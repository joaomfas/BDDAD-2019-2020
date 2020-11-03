Set serveroutput on;
-- 1) Criar um script para implementar um trigger sobre a tabela Clientes, designado trgClientesImpedirMenor18Anos, para impedir 
--    o registo de clientes com idade inferior a 18 anos. Numa perspetiva de legibilidade do código, todas as mensagens de erro 
--    devem ser definidas na secção EXCEPTION. Compilar e testar adequadamente o trigger implementado.
CREATE OR REPLACE TRIGGER trgClientesImpedirMenor18Anos 
BEFORE INSERT OR UPDATE OF data_nascimento ON clientes
FOR EACH ROW
DECLARE
    erro_idade EXCEPTION;
BEGIN
    IF MONTHS_BETWEEN(SYSDATE, :NEW.data_nascimento) < 18*12
    THEN
        RAISE erro_idade;
    END IF;       
EXCEPTION
    WHEN erro_idade THEN
        RAISE_APPLICATION_ERROR(-20001,'Idade inválida! <18 anos!');
END trgClientesImpedirMenor18Anos;

--TESTES
-- este registo é IMPEDIDO porque o cliente tem idade inferior a 18 anos
INSERT INTO clientes(nif_cliente, cod_postal, nome, data_nascimento, morada, nr_telemovel) 
     VALUES(900700100, '4200-197', 'Patrícia', TO_DATE('2010-10-10','yyyy-mm-dd'), 'Rua nº 1', 900900900);
     
-- este registo é PERMITIDO porque o cliente tem idade superior a 18 anos.
INSERT INTO clientes(nif_cliente, cod_postal, nome, data_nascimento, morada, nr_telemovel) 
     VALUES(900700100, '4200-197', 'Patrícia', TO_DATE('2000-10-10','yyyy-mm-dd'), 'Rua nº 1', 900900900);
     
-- esta atualização é IMPEDIDA porque o cliente tem idade inferior a 18 anos
UPDATE clientes SET data_nascimento = TO_DATE('2010-10-10','yyyy-mm-dd') WHERE nif_cliente=900700100;

-- esta atualização é PERMITIDA porque o cliente tem idade superior a 18 anos.
UPDATE clientes SET data_nascimento = TO_DATE('2001-10-10','yyyy-mm-dd') WHERE nif_cliente=900700100;

-- 

