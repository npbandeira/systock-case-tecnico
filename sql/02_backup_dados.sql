-- =====================================================================
-- SYSTOCK - Case Tecnico | Backup / carga de dados (dados REAIS da planilha)
-- Script: 02_backup_dados.sql
-- Fonte: base_teste_systock.xlsx (abas venda, pedido_compra,
-- entradas_mercadoria, produtos_filial, fornecedor)
-- Ordem de carga respeita as FKs:
-- fornecedor -> produtos_filial -> venda -> pedido_compra -> entradas_mercadoria
-- =====================================================================

-- FORNECEDOR
INSERT INTO public.fornecedor (idfornecedor, razao_social) VALUES ('F1', 'Fornecedor 1 LTDA');
INSERT INTO public.fornecedor (idfornecedor, razao_social) VALUES ('F2', 'Fornecedor 2 LTDA');
INSERT INTO public.fornecedor (idfornecedor, razao_social) VALUES ('F3', 'Fornecedor 3 LTDA');
INSERT INTO public.fornecedor (idfornecedor, razao_social) VALUES ('F4', 'Fornecedor 4 LTDA');
INSERT INTO public.fornecedor (idfornecedor, razao_social) VALUES ('F5', 'Fornecedor 5 LTDA');
INSERT INTO public.fornecedor (idfornecedor, razao_social) VALUES ('F6', 'Fornecedor 6 LTDA');
INSERT INTO public.fornecedor (idfornecedor, razao_social) VALUES ('F7', 'Fornecedor 7 LTDA');
INSERT INTO public.fornecedor (idfornecedor, razao_social) VALUES ('F8', 'Fornecedor 8 LTDA');
INSERT INTO public.fornecedor (idfornecedor, razao_social) VALUES ('F9', 'Fornecedor 9 LTDA');
INSERT INTO public.fornecedor (idfornecedor, razao_social) VALUES ('F10', 'Fornecedor 10 LTDA');
INSERT INTO public.fornecedor (idfornecedor, razao_social) VALUES ('F11', 'Fornecedor 11 LTDA');
INSERT INTO public.fornecedor (idfornecedor, razao_social) VALUES ('F12', 'Fornecedor 12 LTDA');
INSERT INTO public.fornecedor (idfornecedor, razao_social) VALUES ('F13', 'Fornecedor 13 LTDA');
INSERT INTO public.fornecedor (idfornecedor, razao_social) VALUES ('F14', 'Fornecedor 14 LTDA');
INSERT INTO public.fornecedor (idfornecedor, razao_social) VALUES ('F15', 'Fornecedor 15 LTDA');
INSERT INTO public.fornecedor (idfornecedor, razao_social) VALUES ('F16', 'Fornecedor 16 LTDA');
INSERT INTO public.fornecedor (idfornecedor, razao_social) VALUES ('F17', 'Fornecedor 17 LTDA');
INSERT INTO public.fornecedor (idfornecedor, razao_social) VALUES ('F18', 'Fornecedor 18 LTDA');
INSERT INTO public.fornecedor (idfornecedor, razao_social) VALUES ('F19', 'Fornecedor 19 LTDA');
INSERT INTO public.fornecedor (idfornecedor, razao_social) VALUES ('F20', 'Fornecedor 20 LTDA');

-- PRODUTOS_FILIAL
INSERT INTO public.produtos_filial (filial_id, produto_id, descricao, estoque, preco_unitario, preco_compra, preco_venda, idfornecedor) VALUES (1, 'P1', 'Produto 1', 88.0, 42.65, 144.13, 40.79, 'F8');
INSERT INTO public.produtos_filial (filial_id, produto_id, descricao, estoque, preco_unitario, preco_compra, preco_venda, idfornecedor) VALUES (1, 'P2', 'Produto 2', 28.0, 79.52, 103.56, 174.18, 'F9');
INSERT INTO public.produtos_filial (filial_id, produto_id, descricao, estoque, preco_unitario, preco_compra, preco_venda, idfornecedor) VALUES (1, 'P3', 'Produto 3', 40.0, 119.5, 24.14, 60.69, 'F10');
INSERT INTO public.produtos_filial (filial_id, produto_id, descricao, estoque, preco_unitario, preco_compra, preco_venda, idfornecedor) VALUES (1, 'P4', 'Produto 4', 73.0, 89.67, 7.75, 226.5, 'F11');
INSERT INTO public.produtos_filial (filial_id, produto_id, descricao, estoque, preco_unitario, preco_compra, preco_venda, idfornecedor) VALUES (1, 'P5', 'Produto 5', 97.0, 135.99, 36.18, 89.92, 'F12');
INSERT INTO public.produtos_filial (filial_id, produto_id, descricao, estoque, preco_unitario, preco_compra, preco_venda, idfornecedor) VALUES (1, 'P6', 'Produto 6', 38.0, 161.31, 55.37, 95.6, 'F13');
INSERT INTO public.produtos_filial (filial_id, produto_id, descricao, estoque, preco_unitario, preco_compra, preco_venda, idfornecedor) VALUES (1, 'P7', 'Produto 7', 131.0, 153.82, 14.04, 46.64, 'F7');
INSERT INTO public.produtos_filial (filial_id, produto_id, descricao, estoque, preco_unitario, preco_compra, preco_venda, idfornecedor) VALUES (1, 'P8', 'Produto 8', 71.0, 140.57, 149.5, 95.28, 'F17');
INSERT INTO public.produtos_filial (filial_id, produto_id, descricao, estoque, preco_unitario, preco_compra, preco_venda, idfornecedor) VALUES (1, 'P9', 'Produto 9', 2.0, 30.88, 137.0, 164.32, 'F18');
INSERT INTO public.produtos_filial (filial_id, produto_id, descricao, estoque, preco_unitario, preco_compra, preco_venda, idfornecedor) VALUES (1, 'P10', 'Produto 10', 38.0, 115.71, 27.77, 87.7, 'F19');
INSERT INTO public.produtos_filial (filial_id, produto_id, descricao, estoque, preco_unitario, preco_compra, preco_venda, idfornecedor) VALUES (1, 'P11', 'Produto 11', 154.0, 147.99, 29.39, 44.95, 'F1');
INSERT INTO public.produtos_filial (filial_id, produto_id, descricao, estoque, preco_unitario, preco_compra, preco_venda, idfornecedor) VALUES (1, 'P12', 'Produto 12', 78.0, 32.47, 64.63, 276.58, 'F2');
INSERT INTO public.produtos_filial (filial_id, produto_id, descricao, estoque, preco_unitario, preco_compra, preco_venda, idfornecedor) VALUES (1, 'P13', 'Produto 13', 79.0, 194.04, 58.3, 99.05, 'F3');
INSERT INTO public.produtos_filial (filial_id, produto_id, descricao, estoque, preco_unitario, preco_compra, preco_venda, idfornecedor) VALUES (1, 'P14', 'Produto 14', 9.0, 199.56, 56.8, 80.74, 'F4');
INSERT INTO public.produtos_filial (filial_id, produto_id, descricao, estoque, preco_unitario, preco_compra, preco_venda, idfornecedor) VALUES (1, 'P15', 'Produto 15', 131.0, 101.15, 107.6, 29.24, 'F5');
INSERT INTO public.produtos_filial (filial_id, produto_id, descricao, estoque, preco_unitario, preco_compra, preco_venda, idfornecedor) VALUES (1, 'P16', 'Produto 16', 177.0, 24.64, 75.94, 278.88, 'F6');
INSERT INTO public.produtos_filial (filial_id, produto_id, descricao, estoque, preco_unitario, preco_compra, preco_venda, idfornecedor) VALUES (1, 'P17', 'Produto 17', 105.0, 195.63, 126.25, 183.92, 'F7');
INSERT INTO public.produtos_filial (filial_id, produto_id, descricao, estoque, preco_unitario, preco_compra, preco_venda, idfornecedor) VALUES (1, 'P18', 'Produto 18', 198.0, 162.2, 134.12, 105.61, 'F18');
INSERT INTO public.produtos_filial (filial_id, produto_id, descricao, estoque, preco_unitario, preco_compra, preco_venda, idfornecedor) VALUES (1, 'P19', 'Produto 19', 148.0, 184.36, 121.69, 234.58, 'F19');
INSERT INTO public.produtos_filial (filial_id, produto_id, descricao, estoque, preco_unitario, preco_compra, preco_venda, idfornecedor) VALUES (1, 'P20', 'Produto 20', 196.0, 52.04, 124.87, 157.93, 'F20');

-- VENDA
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (1, '2025-01-11', '08:00:00', 'P1', 5.0, 78.93, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (2, '2025-03-02', '08:00:00', 'P2', 7.0, 92.96, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (3, '2025-01-28', '08:00:00', 'P3', 9.0, 197.61, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (4, '2025-01-10', '08:00:00', 'P4', 38.6, 139.71, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (5, '2025-01-11', '08:00:00', 'P5', 3.0, 126.79, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (6, '2025-01-24', '08:00:00', 'P6', 2.0, 36.83, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (7, '2025-02-22', '08:00:00', 'P7', 5.0, 40.75, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (8, '2025-01-26', '08:00:00', 'P8', 20.04, 51.37, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (9, '2025-01-17', '08:00:00', 'P9', 6.0, 172.55, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (10, '2025-01-03', '08:00:00', 'P10', 90.0, 44.22, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (11, '2025-01-08', '08:00:00', 'P11', 6.0, 190.37, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (12, '2025-01-21', '08:00:00', 'P12', 2.86, 136.4, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (13, '2025-01-24', '08:00:00', 'P13', 13.0, 61.85, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (14, '2025-02-07', '08:00:00', 'P14', 53.0, 106.3, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (15, '2025-02-20', '08:00:00', 'P15', 27.0, 43.4, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (16, '2025-02-17', '08:00:00', 'P16', 37.11, 14.41, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (17, '2025-02-22', '08:00:00', 'P17', 3.0, 139.8, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (18, '2025-02-18', '08:00:00', 'P18', 5.0, 185.23, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (19, '2025-02-20', '08:00:00', 'P19', 10.0, 182.51, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (20, '2025-02-28', '08:00:00', 'P20', 2.0, 68.54, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (21, '2025-01-24', '08:00:00', 'P21', 25.0, 61.85, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (22, '2025-02-07', '08:00:00', 'P22', 6.0, 106.3, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (23, '2025-02-20', '08:00:00', 'P23', 7.0, 43.4, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (24, '2025-02-17', '08:00:00', 'P24', 4.0, 14.41, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (25, '2025-02-22', '08:00:00', 'P25', 8.0, 139.8, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (26, '2025-02-18', '08:00:00', 'P26', 3.11, 185.23, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (27, '2025-02-20', '08:00:00', 'P27', 3.0, 182.51, 2, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (28, '2025-03-28', '08:00:00', 'P28', 6.0, 68.54, 3, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (29, '2025-03-17', '08:00:00', 'P24', 5.0, 14.41, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (30, '2025-03-22', '08:00:00', 'P25', 3.0, 139.8, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (31, '2025-03-18', '08:00:00', 'P26', 4.0, 185.23, 1, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (32, '2025-03-20', '08:00:00', 'P27', 2.0, 182.51, 2, 1, 'UN');
INSERT INTO public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) VALUES (33, '2025-03-28', '08:00:00', 'P28', 1.0, 68.54, 3, 1, 'UN');

-- PEDIDO_COMPRA
-- Observacao: a coluna qtde_pendente NAO existe na planilha original; foi
-- calculada durante a importacao como (qtde_pedida - qtde_entregue).
-- Pedidos com ordem_compra = 0 representam requisicoes ainda sem ordem de
-- compra formal emitida junto ao fornecedor (ver docs/01_processo_importacao.md).
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (1, '2025-01-02', 1, 'P1', 'Produto 1', 1.0, 96.0, 1, '2025-02-27', 10.0, 86.0, 46.67, 1);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (2, '2025-01-07', 1, 'P2', 'Produto 2', 2.0, 14.0, 1, '2025-01-07', 7.0, 7.0, 77.32, 2);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (3, '2025-01-05', 1, 'P3', 'Produto 3', 3.0, 12.0, 1, '2025-01-03', 2.0, 10.0, 47.82, 3);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (4, '2025-01-22', 1, 'P4', 'Produto 4', 4.0, 27.0, 1, '2025-01-28', 3.0, 24.0, 49.57, 4);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (5, '2025-01-28', 1, 'P5', 'Produto 5', 5.0, 35.0, 1, '2025-02-28', 12.0, 23.0, 57.18, 5);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (6, '2025-02-22', 1, 'P6', 'Produto 6', 6.0, 98.0, 1, '2025-01-05', 55.0, 43.0, 59.96, 6);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (7, '2025-03-01', 1, 'P7', 'Produto 7', 7.0, 34.0, 1, '2025-02-01', 29.0, 5.0, 49.22, 7);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (8, '2025-02-02', 1, 'P8', 'Produto 8', 8.0, 29.0, 1, '2025-02-14', 24.0, 5.0, 35.88, 8);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (9, '2025-01-15', 1, 'P9', 'Produto 9', 9.0, 57.0, 1, '2025-01-28', 34.0, 23.0, 28.48, 9);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (10, '2025-01-09', 1, 'P10', 'Produto 10', 10.0, 49.0, 1, '2025-02-09', 4.0, 45.0, 42.86, 10);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (11, '2025-02-22', 1, 'P11', 'Produto 11', 11.0, 24.0, 1, '2025-01-08', 12.0, 12.0, 14.82, 11);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (12, '2025-02-25', 1, 'P12', 'Produto 12', 12.0, 91.0, 1, '2025-02-20', 48.0, 43.0, 6.92, 12);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (13, '2025-02-23', 1, 'P13', 'Produto 13', 13.0, 99.0, 1, '2025-02-02', 91.0, 8.0, 65.44, 13);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (14, '2025-01-21', 1, 'P14', 'Produto 14', 14.0, 96.0, 1, '2025-01-01', 27.0, 69.0, 21.91, 14);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (15, '2025-02-04', 1, 'P15', 'Produto 15', 15.0, 45.0, 1, '2025-01-04', 1.0, 44.0, 85.04, 15);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (16, '2025-02-27', 1, 'P16', 'Produto 16', 16.0, 84.0, 1, '2025-01-14', 51.0, 33.0, 64.17, 16);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (17, '2025-01-08', 1, 'P17', 'Produto 17', 17.0, 22.0, 1, '2025-01-19', 7.0, 15.0, 74.55, 17);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (18, '2025-02-17', 1, 'P18', 'Produto 18', 18.0, 63.0, 1, '2025-01-02', 17.0, 46.0, 24.94, 18);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (19, '2025-02-19', 1, 'P19', 'Produto 19', 0.0, 20.0, 1, '2025-01-08', 0.0, 20.0, 22.21, 19);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (20, '2025-02-10', 1, 'P20', 'Produto 20', 0.0, 25.0, 1, '2025-01-15', 0.0, 25.0, 38.51, 20);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (21, '2025-02-25', 1, 'P12', 'Produto 12', 0.0, 12.0, 1, '2025-02-20', 0.0, 12.0, 6.92, 12);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (22, '2025-02-23', 1, 'P13', 'Produto 13', 0.0, 4.0, 1, '2025-02-02', 0.0, 4.0, 65.44, 13);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (23, '2025-01-21', 1, 'P14', 'Produto 14', 0.0, 6.0, 1, '2025-01-01', 0.0, 6.0, 21.91, 14);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (24, '2025-02-04', 1, 'P15', 'Produto 15', 0.0, 8.0, 1, '2025-01-04', 0.0, 8.0, 85.04, 15);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (25, '2025-02-27', 1, 'P16', 'Produto 16', 0.0, 9.0, 1, '2025-01-14', 0.0, 9.0, 64.17, 16);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (26, '2025-01-08', 1, 'P17', 'Produto 17', 0.0, 4.0, 1, '2025-01-19', 0.0, 4.0, 74.55, 17);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (27, '2025-02-17', 1, 'P18', 'Produto 18', 0.0, 3.0, 1, '2025-01-02', 0.0, 3.0, 24.94, 18);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (28, '2025-02-19', 1, 'P19', 'Produto 19', 0.0, 3.0, 1, '2025-01-08', 0.0, 3.0, 22.21, 19);
INSERT INTO public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) VALUES (29, '2025-02-10', 1, 'P20', 'Produto 20', 0.0, 2.0, 1, '2025-01-15', 0.0, 2.0, 38.51, 20);

-- ENTRADAS_MERCADORIA
INSERT INTO public.entradas_mercadoria (data_entrada, nro_nfe, item, produto_id, descricao_produto, qtde_recebida, filial_id, custo_unitario, ordem_compra) VALUES ('2025-02-27', 'NFE1', 1, 'P1', 'Produto 1', 77.0, 1, 84.35, 1.0);
INSERT INTO public.entradas_mercadoria (data_entrada, nro_nfe, item, produto_id, descricao_produto, qtde_recebida, filial_id, custo_unitario, ordem_compra) VALUES ('2025-01-20', 'NFE2', 1, 'P2', 'Produto 2', 64.0, 1, 16.66, 2.0);
INSERT INTO public.entradas_mercadoria (data_entrada, nro_nfe, item, produto_id, descricao_produto, qtde_recebida, filial_id, custo_unitario, ordem_compra) VALUES ('2025-02-18', 'NFE3', 1, 'P3', 'Produto 3', 88.0, 1, 90.36, 3.0);
INSERT INTO public.entradas_mercadoria (data_entrada, nro_nfe, item, produto_id, descricao_produto, qtde_recebida, filial_id, custo_unitario, ordem_compra) VALUES ('2025-02-12', 'NFE4', 1, 'P4', 'Produto 4', 4.0, 1, 84.68, 4.0);
INSERT INTO public.entradas_mercadoria (data_entrada, nro_nfe, item, produto_id, descricao_produto, qtde_recebida, filial_id, custo_unitario, ordem_compra) VALUES ('2025-02-19', 'NFE5', 1, 'P5', 'Produto 5', 95.0, 1, 98.99, 5.0);
INSERT INTO public.entradas_mercadoria (data_entrada, nro_nfe, item, produto_id, descricao_produto, qtde_recebida, filial_id, custo_unitario, ordem_compra) VALUES ('2025-02-08', 'NFE6', 1, 'P6', 'Produto 6', 41.0, 1, 90.29, 6.0);
INSERT INTO public.entradas_mercadoria (data_entrada, nro_nfe, item, produto_id, descricao_produto, qtde_recebida, filial_id, custo_unitario, ordem_compra) VALUES ('2025-01-03', 'NFE7', 1, 'P7', 'Produto 7', 75.0, 1, 27.22, 7.0);
INSERT INTO public.entradas_mercadoria (data_entrada, nro_nfe, item, produto_id, descricao_produto, qtde_recebida, filial_id, custo_unitario, ordem_compra) VALUES ('2025-02-21', 'NFE8', 1, 'P8', 'Produto 8', 25.0, 1, 71.1, 8.0);
INSERT INTO public.entradas_mercadoria (data_entrada, nro_nfe, item, produto_id, descricao_produto, qtde_recebida, filial_id, custo_unitario, ordem_compra) VALUES ('2025-02-13', 'NFE9', 1, 'P9', 'Produto 9', 57.0, 1, 19.55, 9.0);
INSERT INTO public.entradas_mercadoria (data_entrada, nro_nfe, item, produto_id, descricao_produto, qtde_recebida, filial_id, custo_unitario, ordem_compra) VALUES ('2025-03-01', 'NFE10', 1, 'P10', 'Produto 10', 7.0, 1, 54.39, 10.0);
INSERT INTO public.entradas_mercadoria (data_entrada, nro_nfe, item, produto_id, descricao_produto, qtde_recebida, filial_id, custo_unitario, ordem_compra) VALUES ('2025-01-23', 'NFE11', 1, 'P11', 'Produto 11', 85.0, 1, 91.89, 11.0);
INSERT INTO public.entradas_mercadoria (data_entrada, nro_nfe, item, produto_id, descricao_produto, qtde_recebida, filial_id, custo_unitario, ordem_compra) VALUES ('2025-01-02', 'NFE12', 1, 'P12', 'Produto 12', 12.0, 1, 38.53, 12.0);
INSERT INTO public.entradas_mercadoria (data_entrada, nro_nfe, item, produto_id, descricao_produto, qtde_recebida, filial_id, custo_unitario, ordem_compra) VALUES ('2025-02-20', 'NFE13', 1, 'P13', 'Produto 13', 7.0, 1, 60.86, 13.0);
INSERT INTO public.entradas_mercadoria (data_entrada, nro_nfe, item, produto_id, descricao_produto, qtde_recebida, filial_id, custo_unitario, ordem_compra) VALUES ('2025-01-10', 'NFE14', 1, 'P14', 'Produto 14', 92.0, 1, 38.48, 14.0);
INSERT INTO public.entradas_mercadoria (data_entrada, nro_nfe, item, produto_id, descricao_produto, qtde_recebida, filial_id, custo_unitario, ordem_compra) VALUES ('2025-01-13', 'NFE15', 1, 'P15', 'Produto 15', 68.0, 1, 95.58, 15.0);
INSERT INTO public.entradas_mercadoria (data_entrada, nro_nfe, item, produto_id, descricao_produto, qtde_recebida, filial_id, custo_unitario, ordem_compra) VALUES ('2025-01-22', 'NFE16', 1, 'P16', 'Produto 16', 89.0, 1, 39.46, 16.0);
INSERT INTO public.entradas_mercadoria (data_entrada, nro_nfe, item, produto_id, descricao_produto, qtde_recebida, filial_id, custo_unitario, ordem_compra) VALUES ('2025-02-24', 'NFE17', 1, 'P17', 'Produto 17', 10.0, 1, 10.32, 17.0);
INSERT INTO public.entradas_mercadoria (data_entrada, nro_nfe, item, produto_id, descricao_produto, qtde_recebida, filial_id, custo_unitario, ordem_compra) VALUES ('2025-01-31', 'NFE18', 1, 'P18', 'Produto 18', 48.0, 1, 62.56, 18.0);
INSERT INTO public.entradas_mercadoria (data_entrada, nro_nfe, item, produto_id, descricao_produto, qtde_recebida, filial_id, custo_unitario, ordem_compra) VALUES ('2025-02-13', 'NFE19', 1, 'P19', 'Produto 19', 64.0, 1, 84.54, 19.0);
INSERT INTO public.entradas_mercadoria (data_entrada, nro_nfe, item, produto_id, descricao_produto, qtde_recebida, filial_id, custo_unitario, ordem_compra) VALUES ('2025-01-01', 'NFE20', 1, 'P20', 'Produto 20', 6.0, 1, 65.7, 20.0);
