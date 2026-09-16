-- =====================================================================
-- SYSTOCK - Case Tecnico | Parte 2 - Consultas SQL Basicas
-- =====================================================================

-- ---------------------------------------------------------------------
-- 2.1 Consumo por produto e mes
-- Total de vendas (quantidade e valor em R$) de cada produto,
-- em fevereiro de 2025.
-- ---------------------------------------------------------------------
SELECT
    v.produto_id,
    SUM(v.qtde_vendida)                         AS qtde_total_vendida,
    ROUND(SUM(v.qtde_vendida * v.valor_unitario), 2) AS valor_total_vendido
FROM public.venda v
WHERE v.data_emissao >= DATE '2025-02-01'
  AND v.data_emissao <  DATE '2025-03-01'
GROUP BY v.produto_id
ORDER BY v.produto_id;

-- Alternativa equivalente usando DATE_TRUNC / EXTRACT, caso a coluna
-- precise ser filtrada por mes/ano de forma dinamica (ex.: parametrizada):
--
-- WHERE DATE_TRUNC('month', v.data_emissao) = DATE '2025-02-01'
-- ou
-- WHERE EXTRACT(YEAR FROM v.data_emissao) = 2025
--   AND EXTRACT(MONTH FROM v.data_emissao) = 2
--
-- Preferimos o filtro por intervalo (>= AND <) porque permite que o
-- Postgres use o indice idx_venda_data_produto (criado em
-- 01_schema_corrigido.sql); funcoes aplicadas sobre a coluna
-- (DATE_TRUNC/EXTRACT) exigiriam um indice funcional para se
-- beneficiar do mesmo ganho de performance.


-- ---------------------------------------------------------------------
-- 2.2 Produtos com requisicao pendente
--
-- "Requisitado mas nao recebido" foi interpretado como: o pedido de
-- compra nao tem NENHUMA entrada de mercadoria vinculada (nenhuma nota
-- fiscal recebida para aquela ordem_compra). Isso e diferente de
-- "recebimento parcial" (onde ja chegou uma parte, mas ainda falta
-- saldo) -- por isso as duas situacoes sao entregues em consultas
-- separadas, para nao misturar status diferentes numa mesma lista.
--
-- Importante: nesta base, ordem_compra = 0 representa uma requisicao
-- que ainda NAO teve uma ordem de compra formal emitida junto ao
-- fornecedor (ver docs/01_processo_importacao.md). Por isso o JOIN
-- exclui ordem_compra = 0 do lado da comparacao -- do contrario, se no
-- futuro existisse alguma entrada tambem com ordem_compra = 0 (por
-- outro erro de digitacao, por exemplo), ela casaria erroneamente com
-- todos os pedidos sem OC.
-- ---------------------------------------------------------------------

-- (a) Totalmente nao recebidos: nenhuma entrada de mercadoria para a OC
SELECT
    pc.produto_id,
    pc.descricao_produto,
    pc.pedido_id,
    pc.ordem_compra,
    pc.filial_id,
    pc.data_pedido,
    pc.qtde_pedida
FROM public.pedido_compra pc
LEFT JOIN public.entradas_mercadoria em
       ON em.ordem_compra = pc.ordem_compra
      AND pc.ordem_compra <> 0
WHERE em.ordem_compra IS NULL
ORDER BY pc.produto_id, pc.data_pedido;

-- (b) Recebimento parcial: chegou alguma quantidade, mas ainda ha saldo
-- em aberto (qtde_pendente = qtde_pedida - qtde_entregue, calculada na
-- importacao -- ver docs/01_processo_importacao.md)
SELECT
    pc.produto_id,
    pc.descricao_produto,
    pc.pedido_id,
    pc.ordem_compra,
    pc.qtde_pedida,
    pc.qtde_entregue,
    pc.qtde_pendente
FROM public.pedido_compra pc
WHERE pc.qtde_entregue > 0
  AND pc.qtde_pendente > 0
ORDER BY pc.qtde_pendente DESC;

-- (c) Visao agregada por produto (soma a+b) -- util para uma visao
-- gerencial rapida de "quanto falta chegar", por produto:
SELECT
    pc.produto_id,
    pc.descricao_produto,
    COUNT(*) FILTER (WHERE pc.qtde_pendente > 0)  AS pedidos_com_saldo_aberto,
    SUM(pc.qtde_pendente)                          AS qtde_total_pendente
FROM public.pedido_compra pc
WHERE pc.qtde_pendente > 0
GROUP BY pc.produto_id, pc.descricao_produto
ORDER BY qtde_total_pendente DESC;
