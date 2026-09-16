"""
SYSTOCK - Case Tecnico | Extracao da planilha de origem
=========================================================

Le as 5 abas de base_teste_systock.xlsx e exporta para CSV em data/,
aplicando os tratamentos descritos em docs/01_processo_importacao.md:

  - descarte de colunas/linhas vazias que o Excel mantem no used range
  - conversao de datas (datetime do Excel -> YYYY-MM-DD)
  - renomeacao de produtos_filial.idproduto -> produto_id
  - calculo de pedido_compra.qtde_pendente = qtde_pedida - qtde_entregue
    (coluna que existe no schema, mas nao vem na planilha)

Uso da ferramenta: esta etapa (extracao/importacao) nao tem restricao de
ferramenta no enunciado do case -- apenas as consultas e analises das
Partes 2, 3 e 4 precisam ser SQL puro (ja entregues em sql/). Este
script e o que gerou os arquivos de data/ e o INSERTs de
sql/02_backup_dados.sql.

Dependencias: openpyxl (pip install openpyxl --break-system-packages)

Uso:
    python3 extrair_planilha.py base_teste_systock.xlsx --saida data/
"""

import argparse
import csv
import os
import sys

import openpyxl


def extrair_aba(ws):
    """Le uma planilha e remove colunas/linhas totalmente vazias."""
    rows = list(ws.iter_rows(values_only=True))
    if not rows:
        return [], []

    header = list(rows[0])
    while header and header[-1] is None:
        header.pop()
    ncols = len(header)

    dados = []
    for r in rows[1:]:
        r = list(r[:ncols])
        if all(v is None for v in r):
            continue
        dados.append(r)

    return header, dados


def conv_data(valor):
    """datetime do Excel -> string YYYY-MM-DD; vazio -> ''."""
    if valor is None:
        return ""
    return valor.strftime("%Y-%m-%d") if hasattr(valor, "strftime") else str(valor)


def tratar_produtos_filial(header, dados):
    """Renomeia idproduto -> produto_id, mantendo a ordem das demais colunas."""
    header = ["produto_id" if c == "idproduto" else c for c in header]
    return header, dados


def tratar_pedido_compra(header, dados):
    """Adiciona qtde_pendente = qtde_pedida - qtde_entregue (nao vem na planilha)."""
    idx_pedida = header.index("qtde_pedida")
    idx_entregue = header.index("qtde_entregue")
    idx_entrega = header.index("data_entrega")
    idx_data_pedido = header.index("data_pedido")

    novo_header = header + ["qtde_pendente"]
    novos_dados = []
    for row in dados:
        row = list(row)
        row[idx_data_pedido] = conv_data(row[idx_data_pedido])
        row[idx_entrega] = conv_data(row[idx_entrega])
        pendente = float(row[idx_pedida] or 0) - float(row[idx_entregue] or 0)
        row.append(pendente)
        novos_dados.append(row)
    return novo_header, novos_dados


def tratar_datas_genericas(header, dados, colunas_data):
    """Converte colunas de data para YYYY-MM-DD em qualquer aba."""
    idxs = [header.index(c) for c in colunas_data if c in header]
    for row in dados:
        for i in idxs:
            row[i] = conv_data(row[i])
    return header, dados


def salvar_csv(caminho, header, dados):
    with open(caminho, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(header)
        w.writerows(dados)


def main():
    parser = argparse.ArgumentParser(description="Extrai base_teste_systock.xlsx para CSV")
    parser.add_argument("planilha", help="Caminho do arquivo .xlsx de origem")
    parser.add_argument("--saida", default="data", help="Diretorio de saida dos CSVs (default: data/)")
    args = parser.parse_args()

    if not os.path.isfile(args.planilha):
        sys.exit(f"Arquivo nao encontrado: {args.planilha}")

    os.makedirs(args.saida, exist_ok=True)
    wb = openpyxl.load_workbook(args.planilha, data_only=True)

    esperado = {"venda", "pedido_compra", "entradas_mercadoria", "produtos_filial", "fornecedor"}
    faltando = esperado - set(wb.sheetnames)
    if faltando:
        sys.exit(f"Abas ausentes na planilha: {faltando}")

    # venda
    header, dados = extrair_aba(wb["venda"])
    header, dados = tratar_datas_genericas(header, dados, ["data_emissao"])
    salvar_csv(os.path.join(args.saida, "venda.csv"), header, dados)
    print(f"venda.csv: {len(dados)} linhas")

    # pedido_compra
    header, dados = extrair_aba(wb["pedido_compra"])
    header, dados = tratar_pedido_compra(header, dados)
    salvar_csv(os.path.join(args.saida, "pedido_compra.csv"), header, dados)
    print(f"pedido_compra.csv: {len(dados)} linhas")

    # entradas_mercadoria
    header, dados = extrair_aba(wb["entradas_mercadoria"])
    header, dados = tratar_datas_genericas(header, dados, ["data_entrada"])
    salvar_csv(os.path.join(args.saida, "entradas_mercadoria.csv"), header, dados)
    print(f"entradas_mercadoria.csv: {len(dados)} linhas")

    # produtos_filial
    header, dados = extrair_aba(wb["produtos_filial"])
    header, dados = tratar_produtos_filial(header, dados)
    salvar_csv(os.path.join(args.saida, "produtos_filial.csv"), header, dados)
    print(f"produtos_filial.csv: {len(dados)} linhas")

    # fornecedor
    header, dados = extrair_aba(wb["fornecedor"])
    salvar_csv(os.path.join(args.saida, "fornecedor.csv"), header, dados)
    print(f"fornecedor.csv: {len(dados)} linhas")

    print(f"\nCSVs gerados em: {args.saida}/")
    print("Proximo passo: gerar/atualizar sql/02_backup_dados.sql a partir desses CSVs "
          "(ou importar direto via DBeaver).")


if __name__ == "__main__":
    main()
