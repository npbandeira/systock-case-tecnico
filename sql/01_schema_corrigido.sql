-- =====================================================================
-- SYSTOCK - Case Tecnico | Analista de Integracao de Dados
-- Script: 01_schema_corrigido.sql
-- Objetivo: criar o schema corrigido no PostgreSQL local.
--
-- O SQL original enviado no case continha erros propositais de
-- modelagem. Cada correcao esta comentada no ponto em que foi feita.
-- O detalhamento de cada erro esta em docs/01_processo_importacao.md,
-- secao "Erros identificados no schema original".
-- =====================================================================

DROP TABLE IF EXISTS public.entradas_mercadoria CASCADE;
DROP TABLE IF EXISTS public.pedido_compra CASCADE;
DROP TABLE IF EXISTS public.venda CASCADE;
DROP TABLE IF EXISTS public.produtos_filial CASCADE;
DROP TABLE IF EXISTS public.fornecedor CASCADE;

-- ---------------------------------------------------------------------
-- FORNECEDOR
-- Erros no original:
--   1) coluna "idforncedor" com typo -> renomeada para "idfornecedor".
--   2) PRIMARY KEY referenciava "idproduto", coluna que nao existe
--      nesta tabela (fornecedor nao tem produto). PK corrigida para
--      (idfornecedor).
-- ---------------------------------------------------------------------
CREATE TABLE public.fornecedor (
    idfornecedor  varchar(25)  NOT NULL,
    razao_social  varchar(255) NOT NULL,
    CONSTRAINT fornecedor_pkey PRIMARY KEY (idfornecedor)
);

-- ---------------------------------------------------------------------
-- PRODUTOS_FILIAL
-- Erros no original:
--   1) faltava virgula entre a coluna "idfonecedor" e a CONSTRAINT
--      (erro de sintaxe, o CREATE TABLE nao rodava).
--   2) "idfonecedor" com typo -> renomeado para "idfornecedor".
--   3) "decricao" com typo -> renomeado para "descricao".
--   4) PRIMARY KEY referenciava "idproduto", mas a coluna declarada
--      chama-se "produto_id". PK corrigida para (filial_id, produto_id).
--   5) adicionada FK para fornecedor, ja que a Parte 3.4 do case pede
--      uma trigger que relacione produto <-> fornecedor.
-- ---------------------------------------------------------------------
CREATE TABLE public.produtos_filial (
    filial_id       int4          NULL,
    produto_id      varchar(255)  NOT NULL,
    descricao       varchar(255)  NOT NULL,
    estoque         float8        DEFAULT 0 NOT NULL,
    preco_unitario  float8        DEFAULT 0 NOT NULL,
    preco_compra    float8        DEFAULT 0 NOT NULL,
    preco_venda     float8        DEFAULT 0 NOT NULL,
    idfornecedor    varchar(25)   NULL,
    CONSTRAINT produtos_filial_pkey PRIMARY KEY (filial_id, produto_id),
    CONSTRAINT produtos_filial_fornecedor_fkey FOREIGN KEY (idfornecedor)
        REFERENCES public.fornecedor (idfornecedor)
);

-- ---------------------------------------------------------------------
-- VENDA
-- Nenhum erro estrutural identificado. Mantida como enviada.
-- ---------------------------------------------------------------------
CREATE TABLE public.venda (
    venda_id        int8 NOT NULL,
    data_emissao    date NOT NULL,
    horariomov      varchar(8) DEFAULT '00:00:00'::character varying NOT NULL,
    produto_id      varchar(25) DEFAULT ''::character varying NOT NULL,
    qtde_vendida    float8 NULL,
    valor_unitario  numeric(12,4) DEFAULT 0 NOT NULL,
    filial_id       int8 DEFAULT 1 NOT NULL,
    item            int4 DEFAULT 0 NOT NULL,
    unidade_medida  varchar(3) NULL,
    CONSTRAINT pk_consumo PRIMARY KEY (filial_id, venda_id, data_emissao, produto_id, item, horariomov)
);

-- ---------------------------------------------------------------------
-- PEDIDO_COMPRA
-- Nenhum erro estrutural identificado. Mantida como enviada.
-- ---------------------------------------------------------------------
CREATE TABLE public.pedido_compra (
    pedido_id          float8 DEFAULT 0 NOT NULL,
    data_pedido        date NULL,
    item               float8 DEFAULT 0 NOT NULL,
    produto_id         varchar(25) DEFAULT '0' NOT NULL,
    descricao_produto  varchar(255) NULL,
    ordem_compra       float8 DEFAULT 0 NOT NULL,
    qtde_pedida        float8 NULL,
    filial_id          int4 NULL,
    data_entrega       date NULL,
    qtde_entregue      float8 DEFAULT 0 NOT NULL,
    qtde_pendente      float8 DEFAULT 0 NOT NULL,
    preco_compra       float8 DEFAULT 0 NULL,
    fornecedor_id      int4 DEFAULT 0 NULL,
    CONSTRAINT pedido_compra_pkey PRIMARY KEY (pedido_id, produto_id, item)
);

-- ---------------------------------------------------------------------
-- ENTRADAS_MERCADORIA
-- Erro no original:
--   1) a PRIMARY KEY referenciava a coluna "ordem_compra", mas essa
--      coluna nunca foi declarada na lista de campos da tabela -- o
--      CREATE TABLE nao rodava. A propria observacao do case confirma
--      que "uma entrada de mercadoria e atrelada ao seu pedido de
--      compra pelo campo ORDEM_COMPRA", entao a coluna foi adicionada
--      (mesmo tipo de pedido_compra.ordem_compra: float8) e mantida na
--      PK, junto com uma FK logica para pedido_compra.
-- ---------------------------------------------------------------------
CREATE TABLE public.entradas_mercadoria (
    data_entrada       date NULL,
    nro_nfe            varchar(255) NOT NULL,
    item               float8 DEFAULT 0 NOT NULL,
    produto_id         varchar(25) DEFAULT '0' NOT NULL,
    descricao_produto  varchar(255) NULL,
    qtde_recebida      float8 NULL,
    filial_id          int4 NULL,
    custo_unitario     numeric(12,4) DEFAULT 0 NOT NULL,
    ordem_compra       float8 DEFAULT 0 NOT NULL,
    CONSTRAINT entradas_mercadoria_pkey PRIMARY KEY (ordem_compra, item, produto_id, nro_nfe)
);

-- Indices de apoio para as consultas das Partes 2 e 3
CREATE INDEX idx_venda_data_produto ON public.venda (data_emissao, produto_id);
CREATE INDEX idx_pedido_produto ON public.pedido_compra (produto_id);
CREATE INDEX idx_pedido_ordem_compra ON public.pedido_compra (ordem_compra);
CREATE INDEX idx_entrada_ordem_compra ON public.entradas_mercadoria (ordem_compra);
