/*****************************************************************************************************************************/ 
-- PARTE 3 - Transa��es com Procedimentos PL/SQL

-- EXECUTAR INDIVIDUALMENTE os comandos deste script (i.e. n�o executar como um script).
/*****************************************************************************************************************************/\

-- desativar op��o AUTOCOMMIT
SET AUTOCOMMIT OFF;

-- ativar a SA�DA para ecr�
SET SERVEROUTPUT ON;

-------------------------------------------------------------------------------------------------------------------------------
-- EXEMPLO 3.1  
-- Procedimento PL/SQL participa numa transa��o e n�o altera o FIM desta transa��o. A transa��o � terminada com ROLLBACK. 
-------------------------------------------------------------------------------------------------------------------------------
-- eliminar registos da tabela t1
DELETE FROM t1;
COMMIT;

-- criar e guardar procedimento compilado na BD 
CREATE OR REPLACE PROCEDURE proc_sem_commit
AS
BEGIN
    UPDATE t1 SET valor = 2;
END;
/

CALL SYS.TRANSACTIONINFO();           -- nenhuma transa��o em curso.
SELECT * FROM t1;                       -- nenhum registo.
INSERT INTO t1(id, valor) VALUES(1,1);  -- transa��o INICIADA.
CALL SYS.TRANSACTIONINFO();           -- uma transa��o em curso.
SELECT * FROM t1;                       -- valor = 1
CALL proc_sem_commit();                 -- procedimento participa na transa��o e n�o termina esta transa��o.
CALL SYS.TRANSACTIONINFO();           -- uma transa��o em curso.
SELECT * FROM t1;                       -- valor = 2
ROLLBACK;                               -- transa��o TERMINADA. 
CALL SYS.TRANSACTIONINFO();           -- nenhuma transa��o em curso.
SELECT * FROM t1;                       -- nenhum registo (tabela inicial).

-------------------------------------------------------------------------------------------------------------------------------
-- EXEMPLO 3.2  
-- Procedimento PL/SQL participa numa transa��o e n�o altera o FIM desta transa��o. A transa��o � terminada com COMMIT. 
-------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM t1;                       -- nenhum registo. 
INSERT INTO t1(id, valor) VALUES(1,1);  -- transa��o INICIADA.                                
SELECT * FROM t1;                       -- valor = 1
CALL proc_sem_commit();                 -- procedimento participa na transa��o e n�o termina esta transa��o.                
SELECT * FROM t1;                       -- valor = 2
COMMIT;                                 -- transa��o TERMINADA. 
SELECT * FROM t1;                       -- valor = 2.

-------------------------------------------------------------------------------------------------------------------------------
-- EXEMPLO 3.3  
-- Procedimento PL/SQL participa numa transa��o e altera o FIM desta transa��o.
--
-- NOTAS:
--   * A responsabilidade de terminar uma transa��o:
--       * � de quem inicia essa transa��o;
--       * N�o � de um procedimento que participa na transa��o.

--   * Em GERAL: 
--       * COMMIT/ROLLBACK n�o deve existir no corpo de Procedimento/Fun��o PL/SQL. 
-------------------------------------------------------------------------------------------------------------------------------
-- criar e guardar procedimento compilado na BD  
CREATE OR REPLACE PROCEDURE proc_com_commit
AS
BEGIN
    UPDATE t1 SET valor = 3;  
    COMMIT;                 -- Em GERAL, � m� pr�tica usar COMMIT/ROLLBACK aqui. 
END;
/

SELECT * FROM t1;              -- valor = 2. 
CALL SYS.TRANSACTIONINFO();  -- nenhuma transa��o em curso.
UPDATE t1 SET valor = 0;       -- transa��o INICIADA.
CALL SYS.TRANSACTIONINFO();  -- uma transa��o em curso.
SELECT * FROM t1;              -- valor = 0 
CALL proc_com_commit();        -- transa��o TERMINADA (com COMMIT). 
CALL SYS.TRANSACTIONINFO();  -- nenhuma transa��o em curso.
SELECT * FROM t1;              -- valor = 3
ROLLBACK;                                 
SELECT * FROM t1;              -- valor = 3.

-------------------------------------------------------------------------------------------------------------------------------
-- EXEMPLO 3.4  
-- Procedimento PL/SQL participa numa transa��o (PRINCIPAL) como transa��o AUT�NOMA (independente).
--
-- NOTAS:
--   * Transa��o aut�noma (TA):
--       * Totalmente independente. 
--       * N�o partilha com a transa��o PRINCIPAL (TP):
--           * LOCKs;
--           * Recursos;
--           * Depend�ncias de commit/rollback (i.e., estes comandos n�o afetam a transa��o principal e vice-versa).
--       * Altera��es da TA:
--           * Tornam-se vis�veis para outras transa��es, ap�s COMMIT da TA.
--           * Tornam-se vis�veis para a TP quando esta retoma o controlo da transa��o, mas s� se for READ COMMITED.  
--   * Interesse:
--       * Log de eventos (salientar que rollback da TP n�o afeta a TA)
-------------------------------------------------------------------------------------------------------------------------------
-- eliminar registos da tabela t1
DELETE FROM t1;
COMMIT;

-- criar e guardar procedimento compilado na BD  
CREATE OR REPLACE PROCEDURE proc_transacao_autonoma
AS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO t1(id, valor) VALUES(5,5);  
    COMMIT;                  
END;
/

SELECT * FROM t1;                       -- nenhum registo. 
CALL SYS.TRANSACTIONINFO();           -- nenhuma transa��o em curso.
INSERT INTO t1(id, valor) VALUES(4,4);  -- transa��o INICIADA.
CALL SYS.TRANSACTIONINFO();           -- uma transa��o em curso.
SELECT * FROM t1;                       -- valor = 4 
CALL proc_transacao_autonoma();         -- transa��o aut�noma; o COMMIT n�o termina transa��o. 
CALL SYS.TRANSACTIONINFO();           -- uma transa��o em curso.
SELECT * FROM t1;                       -- valor = 4 e valor 5
ROLLBACK;                               -- TERMINA transa��o;
                                        -- n�o desfaz transa��o aut�noma definida pelo procedimento.
SELECT * FROM t1;                       -- valor = 5
