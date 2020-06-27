

-- Criamos uma visão para cada consulta feita.

-- Visão que selecionar todos os leiloes que possuem mais de 2 lotes cadastrados.

CREATE OR REPLACE VIEW leilao_lotes AS
	SELECT le.id_leilao AS leilao,
	       COUNT(*) AS quantidade_lotes
	FROM lote AS l,
	     leilao AS le
	WHERE l.id_leilao = le.id_leilao
	GROUP BY le.id_leilao
	HAVING COUNT(*) > 2
	ORDER BY le.id_leilao;

--Visão que mostras o maior valor ja comprado por cada cliente 

CREATE OR REPLACE VIEW cliente_maior_compra AS
SELECT c.nome_cliente AS nome,
	   MAX(l.valor) AS valor
FROM cliente AS c,
     lote AS l
WHERE c.id_cliente = l.id_cliente_comprador
GROUP BY c.nome_cliente
ORDER BY c.nome_cliente;


-- Visão que mostras os cliente que nao possuem compras de lotes 

CREATE OR REPLACE VIEW cliente_sem_compras AS
SELECT c.nome_cliente
FROM cliente AS c
WHERE NOT EXISTS (
	SELECT 1
	FROM lote AS l
	WHERE c.id_cliente = l.id_cliente_comprador
);


-- Visão que mostrar todos os lotes femeas que estão com vencimento em 2010

CREATE OR REPLACE VIEW lotes_femea_2010 AS
SELECT l.id_lote AS lote,
	   l.sexo_lote AS sexo,
	   c.vencimento
FROM lote AS l,
     contas AS c
WHERE l.id_lote = c.id_lote
  AND l.sexo_lote = 'F'
  AND c.vencimento BETWEEN '2009-12-31' AND '2011-01-01'
ORDER BY l.id_lote;


-- Visão que mostrar todos os cliente que realizaram alguma compra nos leiloes 

CREATE OR REPLACE VIEW compras_em_leiloes AS
SELECT l.id_leilao,
	   l.nome_leilao,
  	   c.nome_cliente
FROM leilao AS l,
	 lote AS lo,
	 cliente AS c
WHERE l.id_leilao = lo.id_leilao
  AND lo.id_cliente_comprador = c.id_cliente
  ORDER BY l.id_leilao;


-- Visão de mapa de compras

CREATE OR REPLACE VIEW mapa_de_compras AS
WITH lotes_leiloes AS(
	SELECT le.id_leilao,
		   le.nome_leilao,
		   le.data_leilao,
		   l.id_cliente_comprador,
		   l.quantidade_lote,
		   l.sexo_lote,
		   l.valor,
		   l.idade,
		   l.id_cliente_vendedor

	FROM lote AS l,
		 leilao AS le
	WHERE le.id_leilao = l.id_leilao
	ORDER BY l.id_cliente_comprador
)
SELECT c.nome_cliente,
	   ll.id_leilao,
	   ll.nome_leilao,
	   ll.data_leilao,
	   ll.quantidade_lote,
	   ll.sexo_lote,
	   ll.valor * ll.quantidade_lote AS TOTAL,
	   ll.idade,
	   ll.id_cliente_vendedor
FROM cliente AS c,
	 lotes_leiloes AS ll
WHERE c.id_cliente = ll.id_cliente_comprador
ORDER BY ll.id_leilao;


-- Visão mapa de vendas

CREATE OR REPLACE VIEW mapa_de_vendas AS
WITH lotes_leiloes AS(
	SELECT le.id_leilao,
		   le.nome_leilao,
		   le.data_leilao,
		   l.id_cliente_vendedor,
		   l.quantidade_lote,
		   l.sexo_lote,
		   l.valor,
		   l.idade,
		   l.id_cliente_comprador

	FROM lote AS l,
		 leilao AS le
	WHERE le.id_leilao = l.id_leilao
	ORDER BY l.id_cliente_vendedor
)
SELECT c.nome_cliente,
	   ll.id_leilao,
	   ll.nome_leilao,
	   ll.data_leilao,
	   ll.quantidade_lote,
	   ll.sexo_lote,
	   ll.valor * ll.quantidade_lote AS TOTAL,
	   ll.idade,
	   ll.id_cliente_comprador
FROM cliente AS c,
	 lotes_leiloes AS ll
WHERE c.id_cliente = ll.id_cliente_vendedor
ORDER BY ll.id_leilao;