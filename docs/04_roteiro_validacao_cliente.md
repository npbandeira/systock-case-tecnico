# Parte 4 — Estratégia de Validação com o Cliente (Fevereiro/2025)

## 1. Principais pontos a validar com o cliente

A validação desta base já partiu de achados concretos (seção 3), não apenas de uma lista teórica de riscos. Os pontos abaixo são os que efetivamente precisam de confirmação do cliente:

1. **Produtos sem cadastro completo** — `P21` a `P28` aparecem nas vendas, mas não têm ficha em `produtos_filial` (sem preço de compra, sem fornecedor, sem estoque parametrizado). Isso impede, por exemplo, calcular margem desses produtos. É preciso confirmar se são produtos novos (cadastro atrasado) ou se houve falha na exportação da planilha.
2. **Filiais 2 e 3 sem cadastro de produto** — `produtos_filial` só tem registros da filial `1`, mas há vendas registradas nas filiais `2` e `3`. Preciso saber se essas filiais realmente vendem os mesmos produtos da filial 1 (e o cadastro só não foi replicado) ou se são filiais com catálogo próprio ainda não informado.
3. **Notas fiscais sem pedido de compra vinculado** — `NFE19` e `NFE20` chegaram sem uma ordem de compra correspondente em `pedido_compra`. Preciso confirmar com o setor de compras: essas notas se referem a algum pedido que não veio na planilha, ou são compras feitas fora do fluxo padrão (compra avulsa/emergencial)?
4. **Fornecedor do pedido divergente do fornecedor cadastrado no produto** — em 22 das 29 linhas de pedido de compra, o fornecedor indicado na ordem de compra é diferente do fornecedor que está cadastrado como responsável por aquele produto. Isso é crítico: se estiver errado, pagamentos e análises de fornecedor podem estar atribuídos à empresa errada. Precisa de confirmação: qual das duas fontes está certa — o cadastro do produto ou o pedido de compra?
5. **Pedidos pendentes** — validar com compras se a lista de "requisitado e não recebido" (11 linhas, produtos `P12`–`P20`, todas com `ordem_compra = 0`) bate com a realidade: são pedidos que ainda nem chegaram a virar uma OC formal com o fornecedor?
6. **Recebimento parcial** — 18 linhas têm parte da quantidade pedida ainda em aberto. Confirmar se isso é normal (entrega fracionada programada) ou se indica atraso do fornecedor.

## 2. Técnicas para garantir exatidão e precisão

- **Reconciliação de totais (De-Para)**: comparar `SUM` de quantidade e valor importados no banco contra o relatório/planilha original do cliente para o mesmo período — bater "no centavo" antes de seguir.
- **Contagem de linhas por tabela**: comparar `COUNT(*)` do banco com o `COUNT` de linhas de cada aba da planilha de origem, para garantir que nada foi perdido (ou duplicado) na carga. (Nesta base: venda=33, pedido_compra=29, entradas_mercadoria=20, produtos_filial=20, fornecedor=20 — todos batendo 1:1 com a planilha.)
- **Checagem de integridade referencial**: toda `venda.produto_id` existe em `produtos_filial`? Todo `entradas_mercadoria.ordem_compra` tem um `pedido_compra` correspondente? Todo `produtos_filial.idfornecedor` existe em `fornecedor`? (as três checagens abaixo, seção 3, já rodaram e trouxeram achados reais).
- **Checagem de consistência entre tabelas para o mesmo conceito**: o fornecedor de um produto deveria ser o mesmo em `pedido_compra.fornecedor_id` e em `produtos_filial.idfornecedor` — a comparação revelou divergência em 76% das linhas (achado #4).
- **Checagem de duplicidade**: mesma chave (`venda_id`, `data_emissao`, `produto_id`, `item`, `horariomov`) aparecendo mais de uma vez indicaria erro de carga.
- **Sanity checks de negócio**: valores negativos, datas futuras, quantidade vendida maior que o estoque disponível, preço de venda menor que o preço de compra.

## 3. Consultas de apoio para a reunião de validação

Todas as queries abaixo foram executadas contra a base carregada e os resultados citados na seção 1 vêm delas.

```sql
-- 3.1 Totais gerais do mês (para "bater" com o relatório do cliente)
SELECT
    COUNT(*)                                             AS qtde_registros_venda,
    SUM(qtde_vendida)                                    AS qtde_total_vendida,
    ROUND(SUM(qtde_vendida * valor_unitario), 2)         AS valor_total_vendido
FROM public.venda
WHERE data_emissao >= DATE '2025-02-01'
  AND data_emissao <  DATE '2025-03-01';

-- 3.2 Totais por filial (garante que nenhuma filial ficou de fora)
SELECT
    filial_id,
    COUNT(*)                                             AS qtde_registros,
    SUM(qtde_vendida)                                    AS qtde_total,
    ROUND(SUM(qtde_vendida * valor_unitario), 2)         AS valor_total
FROM public.venda
WHERE data_emissao >= DATE '2025-02-01'
  AND data_emissao <  DATE '2025-03-01'
GROUP BY filial_id
ORDER BY filial_id;

-- 3.3 [Achado #1] Produtos vendidos sem cadastro em produtos_filial
SELECT DISTINCT v.produto_id, v.filial_id
FROM public.venda v
LEFT JOIN public.produtos_filial pf
       ON pf.produto_id = v.produto_id AND pf.filial_id = v.filial_id
WHERE pf.produto_id IS NULL
ORDER BY v.produto_id;

-- 3.4 [Achado #2] Filiais com venda mas sem nenhum produto cadastrado
SELECT DISTINCT v.filial_id
FROM public.venda v
WHERE NOT EXISTS (
    SELECT 1 FROM public.produtos_filial pf WHERE pf.filial_id = v.filial_id
);

-- 3.5 [Achado #3] Entradas de mercadoria sem pedido de compra correspondente
SELECT em.produto_id, em.nro_nfe, em.ordem_compra, em.data_entrada, em.qtde_recebida
FROM public.entradas_mercadoria em
LEFT JOIN public.pedido_compra pc
       ON pc.ordem_compra = em.ordem_compra AND pc.ordem_compra <> 0
WHERE pc.ordem_compra IS NULL;

-- 3.6 [Achado #4] Fornecedor do pedido de compra divergente do cadastro do produto
SELECT
    pc.produto_id,
    pc.pedido_id,
    'F' || pc.fornecedor_id::text  AS fornecedor_no_pedido,
    pf.idfornecedor                AS fornecedor_cadastrado_no_produto
FROM public.pedido_compra pc
JOIN public.produtos_filial pf
     ON pf.produto_id = pc.produto_id
WHERE 'F' || pc.fornecedor_id::text <> pf.idfornecedor
ORDER BY pc.produto_id;

-- 3.7 Checagem de duplicidade na venda (deveria retornar 0 linhas)
SELECT venda_id, data_emissao, produto_id, item, horariomov, filial_id, COUNT(*)
FROM public.venda
GROUP BY venda_id, data_emissao, produto_id, item, horariomov, filial_id
HAVING COUNT(*) > 1;

-- 3.8 Sanity check: valores/quantidades fora do esperado
SELECT *
FROM public.venda
WHERE qtde_vendida <= 0
   OR valor_unitario <= 0
   OR data_emissao > CURRENT_DATE;
```

## 4. Como conduzir a reunião

1. Abrir com os **totais gerais** (3.1) e por **filial** (3.2) — são os números que o cliente mais reconhece de cabeça, e já descartam problema de importação parcial.
2. Apresentar os **achados de integridade** (3.3 a 3.6) não como "erro do sistema", mas como uma lista objetiva de pontos a confirmar — por exemplo: *"encontramos 8 produtos vendidos que não têm cadastro completo; vocês conseguem confirmar se são lançamentos recentes?"*.
3. Dar destaque especial ao **achado #4** (fornecedor divergente) — é o de maior risco de negócio, porque afeta diretamente qual fornecedor é responsável por cada compra.
4. Encerrar com os **pedidos pendentes** (Parte 2.2), pedindo confirmação do time de compras sobre quais já viraram OC formal e quais ainda não.
5. Deixar claro que cada número apresentado tem uma query correspondente, documentada e auditável — isso constrói confiança de que o dado pode ser conferido a qualquer momento, não é uma "caixa preta".
