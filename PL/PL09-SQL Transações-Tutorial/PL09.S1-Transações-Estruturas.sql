/******************************************************************************************************************************/ 
-- PARTE 1 - Estruturas de Transa��es
--
-- EXECUTAR INDIVIDUALMENTE os comandos deste script (i.e. n�o executar como um script).
/******************************************************************************************************************************/

-- desativar op��o AUTOCOMMIT
SET AUTOCOMMIT OFF;

-- ativar a SA�DA para ecr�
SET SERVEROUTPUT ON;

/******************************************************************************************************************************/ 
-- SEC��O 1.1 - Transa��o que consiste num comando SQL-DDL (CREATE, ALTER, DROP, etc.)
/******************************************************************************************************************************/

-------------------------------------------------------------------------------------------------------------------------------
-- EXEMPLO 1.1.1  
-- Transa��o que consiste num comando CREATE.
-------------------------------------------------------------------------------------------------------------------------------
CALL SYS.TRANSACTIONINFO();                       -- nenhuma transa��o em curso.
CREATE TABLE t1(                                    -- transa��o INICIADA e TERMINADA, IMPLICITAMENTE.    
    id    INT  CONSTRAINT pk_t1_id    PRIMARY KEY,  
    valor INT  CONSTRAINT nn_t1_valor NOT NULL); 
CALL SYS.TRANSACTIONINFO();                       -- nenhuma transa��o em curso.
SELECT * FROM t1;                                   -- tabela criada. 

-------------------------------------------------------------------------------------------------------------------------------
-- EXEMPLO 1.1.2  
-- Transa��o que consiste num comando ALTER.
-------------------------------------------------------------------------------------------------------------------------------
CALL SYS.TRANSACTIONINFO();         -- nenhuma transa��o em curso.
ALTER TABLE t1 ADD nome VARCHAR(25);  -- transa��o INICIADA e TERMINADA, IMPLICITAMENTE. 
CALL SYS.TRANSACTIONINFO();         -- nenhuma transa��o em curso.
SELECT * FROM t1;                     -- tabela com coluna adicionada. 

-------------------------------------------------------------------------------------------------------------------------------
-- EXEMPLO 1.1.3  
-- Transa��o que consiste num comando DROP.
-------------------------------------------------------------------------------------------------------------------------------
CALL SYS.TRANSACTIONINFO();             -- nenhuma transa��o em curso.
DROP TABLE t1 CASCADE CONSTRAINTS PURGE;  -- transa��o INICIADA e TERMINADA, IMPLICITAMENTE.
CALL SYS.TRANSACTIONINFO();             -- nenhuma transa��o em curso.
SELECT * FROM t1;                         -- tabela n�o existe. 



/******************************************************************************************************************************/ 
-- SEC��O 1.2 - Transa��o que consiste num ou mais comandos SQL-DML (INSERT, UPDATE e/ou DELETE)
--
-- NOTAS:
--   * Transa��o INICIADA de uma das seguintes formas:
--       * IMPLICITAMENTE:
--           * Com a execu��o de qualquer comando DDL;
--           * Por um comando DML:
--               * Depois do fim da transa��o anterior;
--               * ou depois do in�cio de uma sess�o (i.e. liga��o estabelecida com a BD).
--       * EXPLICITAMENTE:
--           * Com a execu��o de um comando SET TRANSACTION.
--   * Transa��o TERMINADA de uma das seguintes formas:  
--       * IMPLICITAMENTE: 
--           * Com um comando DDL (COMMIT impl�cito).
--       * EXPLICITAMENTE: 
--           * Com um comando COMMIT/ROLLBACK. 
/******************************************************************************************************************************/

-------------------------------------------------------------------------------------------------------------------------------
-- EXEMPLO 1.2.1
-- Transa��o que consiste num comando DML (INSERT) e �:
--   * INICIADA IMPLICITAMENTE por comando DDL;
--   * TERMINADA EXPLICITAMENTE por comando COMMIT.
-------------------------------------------------------------------------------------------------------------------------------
CALL SYS.TRANSACTIONINFO();                       -- nenhuma transa��o em curso.
CREATE TABLE t1(                                    -- comando DDL INICIA a transa��o.    
    id    INT  CONSTRAINT pk_t1_id    PRIMARY KEY,  
    valor INT  CONSTRAINT nn_t1_valor NOT NULL);
CALL SYS.TRANSACTIONINFO();                       -- nenhuma transa��o em curso.    
INSERT INTO t1(id, valor) VALUES(1, 1);              
CALL SYS.TRANSACTIONINFO();                       -- uma transa��o em curso.
SELECT * FROM t1;                                   -- valor = 1
                                                    -- registo armazenado TEMPORARIAMENTE; 
                                                    -- registo vis�vel APENAS nesta SESS�O.
COMMIT;                                             -- comando TERMINA EXPLICITAMENTE a transa��o; 
                                                    -- torna PERMANENTES todas as altera��es da transa��o;
                                                    -- altera��es vis�veis em TODAS as SESS�ES da BD.
CALL SYS.TRANSACTIONINFO();                       -- nenhuma transa��o em curso.                                                    
SELECT * FROM t1;                                   -- valor = 1                                  

-------------------------------------------------------------------------------------------------------------------------------
-- EXEMPLO 1.2.2
-- Transa��o que consiste num comando DML (INSERT) e �:
--   * INICIADA IMPLICITAMENTE pelo comando INSERT (depois do fim da transa��o anterior);
--   * TERMINADA EXPLICITAMENTE por comando ROLLBACK.
-------------------------------------------------------------------------------------------------------------------------------
CALL SYS.TRANSACTIONINFO();            -- nenhuma transa��o em curso.
INSERT INTO t1(id, valor) VALUES(2, 2);  -- comando DML INICIA uma nova transa��o.
CALL SYS.TRANSACTIONINFO();            -- uma transa��o em curso.
SELECT * FROM t1;                        -- valor = 1 ; valor = 2                               
ROLLBACK;                                -- comando TERMINA EXPLICITAMENTE a transa��o;
                                         -- desfaz todas as altera��es da transa��o.
CALL SYS.TRANSACTIONINFO();            -- nenhuma transa��o em curso.                                         
SELECT * FROM t1;                        -- valor = 1

-------------------------------------------------------------------------------------------------------------------------------
-- EXEMPLO 1.2.3  
-- Transa��o que consiste num comando DML (INSERT) e �:
--   * INICIADA IMPLICITAMENTE pelo comando INSERT (depois do fim da transa��o anterior);
--   * TERMINADA IMPLICITAMENTE com COMMIT por comando DDL (com sucesso).
-------------------------------------------------------------------------------------------------------------------------------  
CALL SYS.TRANSACTIONINFO();                        -- nenhuma transa��o em curso.
INSERT INTO t1(id, valor) VALUES(2, 2);              -- comando DML INICIA uma nova transa��o.
CALL SYS.TRANSACTIONINFO();                        -- uma transa��o em curso.
CREATE TABLE t2(                                     -- comando DDL TERMINA IMPLICITAMENTE a transa��o com COMMIT.
    id    INT   CONSTRAINT pk_t2_id    PRIMARY KEY,                                                        
    valor INT   CONSTRAINT nn_t2_valor NOT NULL); 
CALL SYS.TRANSACTIONINFO();                        -- nenhuma transa��o em curso.    
SELECT * FROM t1;                                    -- valor = 1 ; valor = 2 
SELECT * FROM t2;                                    -- nova tabela.

-------------------------------------------------------------------------------------------------------------------------------
-- EXEMPLO 1.2.4  
-- Transa��o que consiste em dois comandos DML (DELETE e INSERT) e �:
--   * INICIADA IMPLICITAMENTE pelo comando DELETE (depois do fim da transa��o anterior);
--   * TERMINADA IMPLICITAMENTE com COMMIT por comando DDL (sem sucesso).
-------------------------------------------------------------------------------------------------------------------------------  
CALL SYS.TRANSACTIONINFO();                        -- nenhuma transa��o em curso.
DELETE FROM t1;                                      -- comando DML INICIA uma nova transa��o.
CALL SYS.TRANSACTIONINFO();                        -- uma transa��o em curso.
INSERT INTO t1(id, valor) VALUES(3, 3);
CALL SYS.TRANSACTIONINFO();                        -- uma transa��o em curso.
CREATE TABLE t1(                                     -- comando DDL TERMINA IMPLICITAMENTE a transa��o com COMMIT.
    id    INT   CONSTRAINT pk_t1_id    PRIMARY KEY,                                                        
    valor INT   CONSTRAINT nn_t1_valor NOT NULL); 
CALL SYS.TRANSACTIONINFO();                        -- nenhuma transa��o em curso.    
SELECT * FROM t1;                                    -- valor = 3

-------------------------------------------------------------------------------------------------------------------------------
-- EXEMPLO 1.2.5  
-- Transa��o que consiste num comando DML (UPDATE) e �:
--   * INICIADA EXPLICITAMENTE pelo comando SET TRANSACTION;
--   * TERMINADA EXPLICITAMENTE com COMMIT.
--
-- NOTAS:
--   * SET TRANSACTION
--       * Permite especificar o NOME de uma transa��o.
--   * Nome de transa��o:
--       * Est� dispon�vel durante a execu��o da transa��o;
--       * Facilita a monitora��o de transa��es de longa dura��o.
-------------------------------------------------------------------------------------------------------------------------------  
SELECT * FROM t1;              -- valor = 3
CALL SYS.TRANSACTIONINFO();  -- nenhuma transa��o em curso.
SET TRANSACTION NAME 'teste';  -- comando INICIA nova transa��o.
CALL SYS.TRANSACTIONINFO();  -- transa��o em curso.
UPDATE t1 SET valor = 5;       
CALL SYS.TRANSACTIONINFO();  -- transa��o em curso.
COMMIT;                        -- TERMINA transa��o.
CALL SYS.TRANSACTIONINFO();  -- nenhuma transa��o em curso.
SELECT * FROM t1;              -- valor = 5  

-------------------------------------------------------------------------------------------------------------------------------
-- EXEMPLO 1.2.6   
-- Comando SET TRANSATION s� � permitido para iniciar uma transa��o. 
-------------------------------------------------------------------------------------------------------------------------------
CALL SYS.TRANSACTIONINFO();  -- nenhuma transa��o em curso.
UPDATE t1 SET valor = 8;       -- comando DML INICIA uma nova transa��o.
CALL SYS.TRANSACTIONINFO();  -- uma transa��o em curso.
SELECT * FROM t1;              -- valor = 8 
SET TRANSACTION NAME 'teste';  -- comando FALHA porque n�o � permitido a meio de uma transa��o.
ROLLBACK;                      -- TERMINA a transa��o.
SELECT * FROM t1;              -- valor = 5


/******************************************************************************************************************************/ 
-- SEC��O 1.3 - Rollback parcial da transa��o.
/******************************************************************************************************************************/

-------------------------------------------------------------------------------------------------------------------------------
-- EXEMPLO 1.3.1  
-- Transa��o com SAVEPOINTs para permitir ROLLBACKs parciais;
--
-- NOTAS:
--   * SAVEPOINTs:
--       * S�o indicadores interm�dios dentro do contexto de uma transa��o;
--       * Dividem uma longa transa��o em partes mais pequenas;
--       * Permitem, numa transa��o longa, desfazer (ROLLBACK) parte da transa��o e n�o toda a transa��o. Por exemplo, quando � 
--         cometido um erro.   
-------------------------------------------------------------------------------------------------------------------------------
DELETE FROM t1;                              -- transa��o INICIADA.
INSERT INTO t1(id, valor) VALUES (1, 0); 
COMMIT;                                      -- transa��o TERMINADA.                            
SELECT * FROM t1;                            -- valor = 0

CALL SYS.TRANSACTIONINFO();                -- nenhuma transa��o em curso.
SET TRANSACTION NAME 'teste de savepoints';  -- comando INICIA nova transa��o.
CALL SYS.TRANSACTIONINFO();                -- uma transa��o em curso.
SAVEPOINT s1;                                -- comando cria savepoint designado s1.
CALL SYS.TRANSACTIONINFO();                -- uma transa��o em curso.
UPDATE t1 SET valor = 1;                     -- transa��o INICIADA.
CALL SYS.TRANSACTIONINFO();                -- uma transa��o em curso.
SELECT * FROM t1;                            -- valor = 1
SAVEPOINT s2;
UPDATE t1 SET valor = 2;
SELECT * FROM t1;                            -- valor = 2
ROLLBACK TO s2;                              -- rollback PARCIAL da transa��o at� s2.
SELECT * FROM t1;                            -- valor = 1
ROLLBACK;                                    -- TERMINA a transa��o;
                                             -- Rollback TOTAL da transa��o.
SELECT * FROM t1;                            -- valor = 0



/******************************************************************************************************************************/ 
-- SEC��O 1.4 - Op��o Autocommit
/******************************************************************************************************************************/
-------------------------------------------------------------------------------------------------------------------------------
-- EXEMPLO 1.4.1  
-- Efeito da op��o AUTOCOMMIT. 
-------------------------------------------------------------------------------------------------------------------------------
-- ativar novamente a op��o AUTOCOMMIT
SET AUTOCOMMIT ON;

CALL SYS.TRANSACTIONINFO();             -- nenhuma transa��o em curso.
DELETE FROM t1;                           -- transa��o INICIADA;
                                          -- transa��o TERMINADA IMPLICITAMMENTE com COMMIT. 
CALL SYS.TRANSACTIONINFO();             -- nenhuma transa��o em curso.
INSERT INTO t1(id, valor) VALUES (1, 1);  -- transa��o INICIADA;
                                          -- transa��o TERMINADA IMPLICITAMMENTE com COMMIT.
CALL SYS.TRANSACTIONINFO();             -- nenhuma transa��o em curso.                           
SELECT * FROM t1;                         -- valor = 1
CALL SYS.TRANSACTIONINFO();             -- nenhuma transa��o em curso.
UPDATE t1 SET valor = 2;                  -- transa��o INICIADA;
                                          -- transa��o TERMINADA IMPLICITAMMENTE com COMMIT. 
CALL SYS.TRANSACTIONINFO();             -- nenhuma transa��o em curso.
SELECT * FROM t1;                         -- valor = 2
ROLLBACK;
SELECT * FROM t1;                         -- valor = 2

-- desativar novamente a op��o AUTOCOMMIT
SET AUTOCOMMIT OFF; 

UPDATE t1 SET valor = 0;                  -- transa��o INICIADA. 
COMMIT;                                   -- transa��o TERMINADA.
SELECT * FROM t1;                         -- valor = 0 (valor inicial igual ao da transa��o anterior)

CALL SYS.TRANSACTIONINFO();             -- nenhuma transa��o em curso.
DELETE FROM t1;                           -- transa��o INICIADA.
CALL SYS.TRANSACTIONINFO();             -- uma transa��o em curso.
INSERT INTO t1(id, valor) VALUES (1, 1);
SELECT * FROM t1;                         -- valor = 1
CALL SYS.TRANSACTIONINFO();             -- uma transa��o em curso.
SELECT * FROM t1;                         -- valor = 1
UPDATE t1 SET valor = 2;                   
CALL SYS.TRANSACTIONINFO();             -- uma transa��o em curso.
SELECT * FROM t1;                         -- valor = 2
ROLLBACK;                                 -- transa��o TERMINADA.
SELECT * FROM t1;                         -- valor = 0.
