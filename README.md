# Case Técnico — Analista de Integração de Dados (Implantação) | Systock

Solução do case técnico de importação, integração e validação de dados de vendas, pedidos de compra e estoque, usando PostgreSQL. Dados 100% reais, extraídos de `base_teste_systock.xlsx` (5 abas: `venda`, `pedido_compra`, `entradas_mercadoria`, `produtos_filial`, `fornecedor`).

## Estrutura do repositório

```
systock-case/
├── README.md                              # este arquivo
├── sql/
│   ├── 01_schema_corrigido.sql            # DDL corrigido (com comentários dos erros originais)
│   ├── 02_backup_dados.sql                # carga completa dos dados reais (INSERTs)
│   ├── 03_consultas_basicas.sql           # Parte 2 — consultas básicas
│   └── 04_transformacoes.sql              # Parte 3 — transformações + trigger
├── docs/
│   ├── 01_processo_importacao.md          # Parte 1 — documentação do processo de importação
│   └── 04_roteiro_validacao_cliente.md    # Parte 4 — roteiro de validação com o cliente
└── data/                                   # CSVs extraídos da planilha original (após tratamentos)
    ├── venda.csv
    ├── pedido_compra.csv
    ├── entradas_mercadoria.csv
    ├── produtos_filial.csv
    └── fornecedor.csv
```

## Como reproduzir localmente

1. Suba um PostgreSQL local (ex.: `docker run --name systock -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres:16`).
2. Conecte via DBeaver (ou outro client de sua preferência) em `localhost:5432`.
3. Execute os scripts **nesta ordem**:
   1. `sql/01_schema_corrigido.sql`
   2. `sql/02_backup_dados.sql`
   3. `sql/03_consultas_basicas.sql`
   4. `sql/04_transformacoes.sql`
4. Consulte `docs/01_processo_importacao.md` e `docs/04_roteiro_validacao_cliente.md` para o racional de cada decisão e para as queries de auditoria/validação.

## Resumo das entregas

| Parte | Conteúdo | Onde encontrar |
|---|---|---|
| 1 | Documentação do processo de importação | `docs/01_processo_importacao.md` |
| 2 | Consumo por produto/mês + requisições pendentes | `sql/03_consultas_basicas.sql` |
| 3 | Concatenação, formatação de datas, filtro de quantidade, trigger de fornecedor | `sql/04_transformacoes.sql` |
| 4 | Roteiro de validação com o cliente + queries de auditoria | `docs/04_roteiro_validacao_cliente.md` |

## Erros intencionais identificados

O case avisa que contém erros propositais. Foram identificados dois grupos — detalhamento completo com evidências em `docs/01_processo_importacao.md`:

**Erros de schema (o `CREATE TABLE` original não roda):**
- `entradas_mercadoria`: PK referenciava uma coluna (`ordem_compra`) nunca declarada na tabela.
- `produtos_filial`: faltava vírgula antes do `CONSTRAINT`, typos em `idfonecedor`/`decricao`, e PK referenciando `idproduto` em vez do nome real da coluna.
- `fornecedor`: typo em `idforncedor` e PK referenciando `idproduto`, coluna que não existe na tabela.

**Erros de qualidade de dado (o schema roda, mas os valores têm inconsistências — achados obtidos validando a base já carregada):**
- 8 produtos vendidos (`P21`–`P28`) sem cadastro em `produtos_filial`.
- `produtos_filial` só cadastrado para a filial `1`, mas há vendas nas filiais `2` e `3`.
- 2 notas fiscais (`NFE19`, `NFE20`) em `entradas_mercadoria` sem pedido de compra correspondente.
- Em 22 das 29 linhas de `pedido_compra`, o fornecedor do pedido diverge do fornecedor cadastrado para o produto.
- Formato de fornecedor inconsistente entre tabelas (`8` em `pedido_compra.fornecedor_id` vs. `F8` em `fornecedor.idfornecedor`).
