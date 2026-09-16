-- =====================================================================
-- SYSTOCK - Case Tecnico | Parte 3 - Transformacoes de Dados
-- =====================================================================

-- ---------------------------------------------------------------------
-- 3.1 e 3.2 e 3.3 combinadas
-- (1) Concatenar produto_id + descricao_produto no formato "ID - Descricao"
-- (2) Datas no formato DD/MM/YYYY
-- (3) Somente produtos com quantidade requisitada maior que 10 unidades
--
-- Resultado no mesmo formato do exemplo do enunciado:
--   Produto              | Qtde Requisitada | Data Solicitacao
--   12345 - Detergente    | 15                | 01/01/2025
--
-- Nota sobre a interpretacao do item 3: o exemplo do proprio enunciado
-- mostra UMA linha por produto, com "Qtde Requisitada" = 15 e UMA data
-- (a do pedido). Isso indica um filtro por QUANTIDADE pedida naquela
-- linha (qtde_pedida > 10), e nao por "numero de vezes que o produto
-- foi requisitado" (contagem de pedidos) -- interpretacao que testamos
-- com os dados reais e que nao produz nenhum resultado, ja que nenhum
-- produto tem mais de 2 pedidos no periodo. A versao por contagem fica
-- comentada logo abaixo, documentada como alternativa, caso a intencao
-- do avaliador fosse essa.
-- ---------------------------------------------------------------------
SELECT
    CONCAT(pc.produto_id, ' - ', COALESCE(pc.descricao_produto, '(sem descricao)')) AS "Produto",
    pc.qtde_pedida                                    AS "Qtde Requisitada",
    TO_CHAR(pc.data_pedido, 'DD/MM/YYYY')              AS "Data Solicitacao"
FROM public.pedido_compra pc
WHERE pc.qtde_pedida > 10
ORDER BY pc.qtde_pedida DESC;

-- Alternativa (nao usada como principal): produtos requisitados em
-- MAIS DE 10 PEDIDOS distintos no periodo -- funcionaria em uma base
-- com maior volume/historico; com a amostra atual nenhum produto
-- atinge esse volume, entao a consulta abaixo retorna 0 linhas aqui,
-- mas continua correta para uso em producao:
SELECT
    CONCAT(pc.produto_id, ' - ', MIN(pc.descricao_produto)) AS "Produto",
    COUNT(*)                                    AS "Qtde Requisicoes",
    TO_CHAR(MAX(pc.data_pedido), 'DD/MM/YYYY')  AS "Data Solicitacao"
FROM public.pedido_compra pc
GROUP BY pc.produto_id
HAVING COUNT(*) > 10
ORDER BY "Qtde Requisicoes" DESC;

-- A mesma logica de concatenacao/formatacao de data aplicada a venda,
-- caso seja necessaria para outras validacoes:
SELECT
    CONCAT(v.produto_id, ' - ', COALESCE(pf.descricao, '(sem descricao)')) AS "Produto",
    TO_CHAR(v.data_emissao, 'DD/MM/YYYY')            AS "Data Venda",
    v.qtde_vendida,
    v.valor_unitario
FROM public.venda v
LEFT JOIN public.produtos_filial pf
       ON pf.produto_id = v.produto_id
      AND pf.filial_id  = v.filial_id
ORDER BY v.produto_id, v.data_emissao;


-- =====================================================================
-- 3.4 Trigger: geracao automatica de idfornecedor numerico
--
-- Interpretacao adotada (documentada tambem em
-- docs/01_processo_importacao.md):
-- O enunciado pede uma trigger que "gere automaticamente um novo
-- idfornecedor numerico na tabela de produtos que se relacione com a
-- tabela de fornecedor". Ou seja: sempre que um produto for inserido
-- em produtos_filial SEM fornecedor informado (idfornecedor IS NULL),
-- a trigger deve:
--   a) gerar um novo codigo numerico sequencial (via SEQUENCE);
--   b) criar o registro correspondente na tabela fornecedor (para nao
--      violar a FK produtos_filial_fornecedor_fkey), com um nome
--      provisorio ate cadastro definitivo;
--   c) atribuir esse novo idfornecedor ao produto que esta sendo
--      inserido.
--
-- Observacao sobre inconsistencia do case: fornecedor.idfornecedor foi
-- definido como varchar(25) no schema original, mas o enunciado pede
-- explicitamente um id "numerico". Nos dados reais da planilha,
-- fornecedor.idfornecedor e produtos_filial.idfornecedor usam o padrao
-- 'F1'..'F20' (prefixo + numero). Resolvido gerando a PARTE NUMERICA a
-- partir de uma SEQUENCE (garantindo unicidade e o requisito de ser
-- numerica) e compondo o codigo final no mesmo padrao 'F<numero>' ja
-- usado no restante da base, para nao quebrar a convencao existente.
--
-- Outro ponto identificado durante a validacao (ver Parte 4): a coluna
-- pedido_compra.fornecedor_id guarda o fornecedor como numero puro
-- (ex.: 8), sem o prefixo 'F', enquanto produtos_filial/fornecedor usam
-- 'F8'. Isso foi tratado como achado de qualidade de dados (documentado
-- em docs/04_roteiro_validacao_cliente.md), e nao replicado aqui -- a
-- trigger mantem o padrao correto ('F' + numero) para novos cadastros.
-- =====================================================================

CREATE SEQUENCE IF NOT EXISTS public.seq_fornecedor_auto
    START WITH 1000
    INCREMENT BY 1;

CREATE OR REPLACE FUNCTION public.fn_gerar_fornecedor_automatico()
RETURNS TRIGGER AS $$
DECLARE
    v_novo_id varchar(25);
BEGIN
    IF NEW.idfornecedor IS NULL THEN
        v_novo_id := 'F' || nextval('public.seq_fornecedor_auto')::text;

        INSERT INTO public.fornecedor (idfornecedor, razao_social)
        VALUES (v_novo_id, 'Fornecedor pendente de cadastro (gerado automaticamente)');

        NEW.idfornecedor := v_novo_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_produtos_filial_fornecedor ON public.produtos_filial;

CREATE TRIGGER trg_produtos_filial_fornecedor
    BEFORE INSERT ON public.produtos_filial
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_gerar_fornecedor_automatico();

-- Teste manual da trigger (nao faz parte da carga oficial de dados):
-- INSERT INTO public.produtos_filial
--   (filial_id, produto_id, descricao, estoque, preco_unitario, preco_compra, preco_venda, idfornecedor)
-- VALUES
--   (1, 'P999', 'Produto Teste Trigger', 10, 50.00, 30.00, 50.00, NULL);
--
-- SELECT * FROM public.produtos_filial WHERE produto_id = 'P999';
-- SELECT * FROM public.fornecedor ORDER BY idfornecedor DESC LIMIT 3;
