# Parte 1 — Documentação do Processo de Importação

## 1. Ferramenta utilizada

- **PostgreSQL** (local) como banco de destino.
- **DBeaver** para conexão, execução dos scripts DDL/DML e conferência visual dos dados.
- **Python (openpyxl + csv)** como camada de ETL: leitura da planilha `base_teste_systock.xlsx` (5 abas), extração para CSV intermediário e geração dos `INSERT`s versionáveis em `sql/02_backup_dados.sql` — assim toda a carga fica documentada e reproduzível dentro do próprio repositório, sem depender de reabrir o Excel.

Fluxo adotado:

1. Ler as 5 abas da planilha (`venda`, `pedido_compra`, `entradas_mercadoria`, `produtos_filial`, `fornecedor`) com `openpyxl`, descartando colunas/linhas totalmente vazias que o Excel mantém no `used range`.
2. Exportar cada aba para CSV (`data/*.csv`), aplicando os tratamentos da seção 3.
3. Rodar `sql/01_schema_corrigido.sql` no PostgreSQL local via DBeaver.
4. Rodar `sql/02_backup_dados.sql` para popular o banco.
5. Rodar as consultas de conferência da Parte 4 para validar volumetria e consistência antes de seguir para as Partes 2 e 3.

## 2. Estrutura da planilha

| Aba | Colunas (conforme veio na planilha) | Linhas de dados |
|---|---|---|
| `venda` | venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida | 33 |
| `pedido_compra` | pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, preco_compra, fornecedor_id | 29 |
| `entradas_mercadoria` | data_entrada, nro_nfe, item, produto_id, descricao_produto, ordem_compra, qtde_recebida, filial_id, custo_unitario | 20 |
| `produtos_filial` | filial_id, **idproduto**, descricao, estoque, preco_unitario, preco_compra, preco_venda, idfornecedor | 20 |
| `fornecedor` | idfornecedor, razao_social | 20 |

Tipagem no banco seguiu o DDL do case: datas como `date`, quantidades/valores como `float8`/`numeric`, identificadores como `varchar`.

## 3. Tratamentos aplicados

- **Conversão de datas**: as células de data vêm como `datetime` do Excel (ex.: `2025-01-11 00:00:00`); foi extraída apenas a parte `YYYY-MM-DD` para as colunas `date` do PostgreSQL.
- **Descarte de colunas/linhas fantasma**: as abas do Excel trazem um `used range` maior que os dados reais (ex.: `venda` tem range até a coluna `Z`, mas só as 9 primeiras colunas têm dado). Colunas e linhas 100% vazias foram descartadas na extração.
- **Renomeação de coluna**: a aba `produtos_filial` traz a coluna de produto como **`idproduto`**; ela foi renomeada para **`produto_id`** na carga, para ficar consistente com o nome usado em `venda`, `pedido_compra` e `entradas_mercadoria` (todas usam `produto_id`) e com a PK corrigida da tabela (ver seção 4).
- **Cálculo de `qtde_pendente`**: essa coluna existe no DDL de `pedido_compra` (`DEFAULT 0 NOT NULL`), mas **não veio na planilha**. Foi calculada na importação como `qtde_pedida - qtde_entregue` e gravada já resolvida no banco, em vez de deixada como `0` (valor padrão do DDL, que estaria incorreto para a maioria das linhas).
- **Padronização de tipos numéricos**: campos como `filial_id`, `item`, `pedido_id`, `venda_id` chegam do Excel como `float` (ex.: `1.0`); foram convertidos para inteiro nos `INSERT`s, conforme os tipos `int4`/`int8` do DDL.
- **Escaping de strings**: qualquer apóstrofo em `descricao_produto` / `razao_social` seria escapado (`'` → `''`) — não ocorreu na base atual, mas o script de geração dos `INSERT`s já trata isso.
- **Vínculo pedido → entrada**: conforme a observação do enunciado, `entradas_mercadoria` foi conciliada com `pedido_compra` pelo campo `ordem_compra` (e não por `pedido_id`).

## 4. Ajustes/correções realizadas — erros identificados

O case avisa que contém erros intencionais. Dois grupos foram encontrados: **erros de schema/DDL** (o `CREATE TABLE` como enviado não roda) e **erros de qualidade de dado** (o schema roda, mas os valores têm inconsistências). Os erros de qualidade de dado, por afetarem diretamente a confiabilidade da análise, são detalhados com evidências na Parte 4 (`docs/04_roteiro_validacao_cliente.md`).

### 4.1 Erros de schema/DDL (corrigidos em `sql/01_schema_corrigido.sql`)

| # | Tabela | Erro encontrado | Correção aplicada |
|---|---|---|---|
| 1 | `entradas_mercadoria` | A `PRIMARY KEY` referencia a coluna `ordem_compra`, mas essa coluna **não estava declarada** na lista de campos da tabela — o `CREATE TABLE` original não executa. | Coluna `ordem_compra float8` adicionada, no mesmo tipo de `pedido_compra.ordem_compra`. |
| 2 | `produtos_filial` | Falta vírgula entre a coluna `idfonecedor int4 NULL` e a cláusula `CONSTRAINT` — erro de sintaxe. | Vírgula adicionada. |
| 3 | `produtos_filial` | Coluna `idfonecedor` com erro de digitação. | Renomeada para `idfornecedor`. |
| 4 | `produtos_filial` | Coluna `decricao` com erro de digitação. | Renomeada para `descricao`. |
| 5 | `produtos_filial` | `PRIMARY KEY (filial_id, idproduto)` referencia `idproduto`, mas a coluna declarada no DDL chama-se `produto_id` (e, como visto na seção 2, a planilha real usa o nome `idproduto` para essa coluna — o inverso do DDL). | Coluna do banco padronizada como `produto_id` (nome usado nas demais tabelas) e PK corrigida para `(filial_id, produto_id)`; o mapeamento `idproduto → produto_id` é feito na importação. |
| 6 | `fornecedor` | Coluna `idforncedor` com erro de digitação. | Renomeada para `idfornecedor`. |
| 7 | `fornecedor` | `PRIMARY KEY (idforncedor, idproduto)` referencia `idproduto`, coluna que **não existe em `fornecedor`** (fornecedor não tem produto). | PK corrigida para `(idfornecedor)`. |

Nenhum erro estrutural foi encontrado em `venda` e `pedido_compra` — mantidas como enviadas (à parte a ausência de `qtde_pendente` nos dados, tratada como transformação de carga, seção 3).

### 4.2 Erros de qualidade de dado (encontrados na validação, ver Parte 4)

| # | Achado | Evidência |
|---|---|---|
| 1 | 8 produtos vendidos (`P21`–`P28`) **não têm cadastro** em `produtos_filial` | `LEFT JOIN venda → produtos_filial` retorna produto nulo para esses 8 códigos |
| 2 | `produtos_filial` só tem registros para `filial_id = 1`, mas `venda` tem vendas nas filiais `1`, `2` e `3` | `SELECT DISTINCT filial_id` diverge entre as duas tabelas |
| 3 | 2 notas fiscais (`NFE19`, `NFE20`, `ordem_compra` 19 e 20) em `entradas_mercadoria` **não têm pedido de compra correspondente** | Nenhuma linha de `pedido_compra` tem `ordem_compra` 19 ou 20 |
| 4 | Em 22 das 29 linhas de `pedido_compra`, o `fornecedor_id` registrado **diverge** do fornecedor cadastrado para aquele produto em `produtos_filial` | Comparação `'F' \|\| fornecedor_id` (pedido) vs. `idfornecedor` (cadastro do produto) |
| 5 | `pedido_compra.fornecedor_id` é gravado como número puro (`8`), enquanto `fornecedor.idfornecedor` / `produtos_filial.idfornecedor` usam o padrão `F8` | Formatos incompatíveis entre tabelas para o mesmo conceito de "fornecedor" |

Esses achados são tratados como **pontos de validação com o cliente**, não como algo que a query deveria "esconder" — são exatamente o tipo de inconsistência que uma reunião de validação de dados precisa expor. Ver `docs/04_roteiro_validacao_cliente.md` para as queries completas e o roteiro de apresentação.
