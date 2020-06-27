-- função que retona o tipo do animal apartir da data e do sexo

CREATE OR REPLACE FUNCTION tipo_animal(idade lote.idade%TYPE, sexo CHAR) RETURNS TEXT AS $$
DECLARE
	tipo TEXT;
BEGIN
	IF (idade < 3) THEN 
		IF (sexo = 'F') THEN
			tipo = 'Bezerra';
		ELSE 
			tipo = 'Bezerro';
		END IF;
	ELSIF (idade < 5) THEN
		IF (sexo = 'F') THEN
			tipo = 'Novilha';
		ELSE 
			tipo = 'Garote';
		END IF;
	ELSE
		IF (sexo = 'F') THEN
			tipo = 'Vaca';
		ELSE 
			tipo = 'Boi';
		END IF;
	END IF;
	RETURN tipo;
END;
$$ LANGUAGE plpgsql;

-- teste
SELECT tipo_animal(3,'F');
SELECT tipo_animal(3,'M');
SELECT tipo_animal(4,'F');
SELECT tipo_animal(4,'M');
SELECT tipo_animal(8,'F');
SELECT tipo_animal(8,'M');



CREATE OR REPLACE FUNCTION calculo_comissao(valor REAL, quantidade INT, 
comissao FLOAT) RETURNS lote.valor%TYPE AS $$
DECLARE 
	total lote.valor%TYPE;
BEGIN
	total = (valor * quantidade)*(comissao/100);
	RETURN total;
END;
$$ LANGUAGE plpgsql;

-- Teste
SELECT calculo_comissao(100,2,2.0);



CREATE OR REPLACE FUNCTION setar_contas() RETURNS TRIGGER AS $$

BEGIN 
RAISE NOTICE 'Iteração';
	IF (NEW.situacao_arremate = 'Venda' OR NEW.situacao_arremate = 'Defeza') THEN
		RAISE NOTICE 'Iteração';
		INSERT INTO contas (vencimento,total,id_lote,id_cliente)
		VALUES (current_date, NEW.quantidade_lote*NEW.valor, NEW.id_lote, NEW.id_cliente_comprador);
	END IF;
	RETURN NULL;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER setar_contas_trigger
AFTER UPDATE OR INSERT
ON lote FOR EACH ROW
EXECUTE PROCEDURE setar_contas();
