\connect postgres;

-- Apaga o banco acadêmico, caso exista
DROP DATABASE IF EXISTS leilao;



CREATE DATABASE leilao;


\c leilao

CREATE TABLE cliente(
 id_cliente SERIAL NOT NULL,
 nome_cliente VARCHAR(50) NOT NULL,
 telefone_cliente CHAR(11),
 fazenda_cliente VARCHAR(50),
 CONSTRAINT cliente_pk PRIMARY KEY (id_cliente)
);

CREATE TABLE leilao(
 id_leilao SERIAL NOT NULL,
 nome_leilao VARCHAR(50) NOT NULL,
 local_leilao VARCHAR(50) NOT NULL,
 data_leilao DATE NOT NULL,
 CONSTRAINT leilao_pk PRIMARY KEY (id_leilao)
);

CREATE TABLE lote(
 id_lote SERIAL NOT NULL,
 quantidade_lote INT NOT NULL,
 sexo_lote CHAR(1) NOT NULL,
 idade INT NOT NULL,
 comissao_compra FLOAT NOT NULL,
 comissao_venda FLOAT NOT NULL,
 situacao_arremate CHAR(10),
 valor REAL,
 parcelas INT,
 id_cliente_vendedor INT NOT NULL,
 id_cliente_comprador INT,
 id_leilao INT NOT NULL,
 CONSTRAINT lote_pk PRIMARY KEY (id_lote),
 CONSTRAINT lote_leilao_fk FOREIGN KEY (id_leilao) 
 REFERENCES leilao(id_leilao),
 CONSTRAINT lote_cliente_comprador_fk FOREIGN KEY (id_cliente_comprador) 
 REFERENCES cliente(id_cliente),
 CONSTRAINT lote_cliente_vendedor_fk FOREIGN KEY (id_cliente_vendedor) 
 REFERENCES cliente(id_cliente)
);

CREATE TABLE contas(
 codigo_conta SERIAL NOT NULL,
 vencimento DATE,
 total REAL NOT NULL,
 id_lote INT NOT NULL,
 id_cliente INT NOT NULL,
 CONSTRAINT conta_pk PRIMARY KEY (codigo_conta),
 CONSTRAINT conta_lote_fk FOREIGN KEY (id_lote)
 REFERENCES lote(id_lote),
 CONSTRAINT conta_cliente_fk FOREIGN KEY (id_cliente) 
 REFERENCES cliente(id_cliente)
);