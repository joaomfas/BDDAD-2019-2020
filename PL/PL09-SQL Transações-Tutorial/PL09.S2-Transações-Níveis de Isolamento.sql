/******************************************************************************************************************************/ 
-- PARTE 2 - N�veis de Isolamento de Transa��es

-- EXECUTAR INDIVIDUALMENTE os comandos deste script (i.e. n�o executar como um script).
/******************************************************************************************************************************/

-- desativar op��o AUTOCOMMIT
SET AUTOCOMMIT OFF;

-- ativar a SA�DA para ecr�
SET SERVEROUTPUT ON;

DELETE FROM t1;                          -- elimina todos os registos da tabela.
INSERT INTO t1(id, valor) VALUES(1, 0);                
COMMIT;                                                
SELECT * FROM t1;                        -- valor = 0



/******************************************************************************************************************************/ 
-- SEC��O 2.1 - M�ltiplas sess�es concorrentes de uma BD.
--
-- NOTA:
--   * Uma SESS�O de BD:
--       * Representa uma liga��o (CONNECTION) � BD, para interagir com ela, estabelecida como utilizador. 
/******************************************************************************************************************************/

-------------------------------------------------------------------------------------------------------------------------------
-- EXEMPLO 2.1.1 
-- Duas SESS�ES concorrentes de uma BD:
--   * SESS�O 1 - realizada nesta worksheet;
--   * SESS�O 2 - realizada numa UNSHARED worksheet (worksheet com uma UNSHARED CONNECTION); 
--                criada com Ctrl + Shift + N.  
-- ALTERA��ES realizadas por uma transa��o numa SESS�O:
--   * VIS�VEIS noutras sess�es APENAS quando a transa��o � COMMITTED.
-------------------------------------------------------------------------------------------------------------------------------

-- SESS�O 1 (nesta worksheet)
UPDATE t1 SET valor = 1;  -- transa��o INICIADA.
COMMIT;                   -- transa��o TERMINADA.
UPDATE t1 SET valor = 2;  -- INICIADA nova transa��o.
SELECT * FROM t1;         -- valor = 2
                          -- valor TEMPOR�RIO, VIS�VEL apenas nesta sess�o. 

-- SESS�O 2 (numa UNSHARED worksheet)
-- iniciar NOVA SESS�O, abrindo uma UNSHARED worksheet separada (Ctrl + Shift + N);
-- na UNSHARED worksheet, executar o seguinte comando:   
SELECT * FROM t1;         -- valor = 1 (diferente da SESS�O 1); 
                          -- porque a transa��o da SESS�O 1 n�o foi COMMITTED;
                          -- � o valor que est� gravado PERMANENTEMENTE na BD.

-- SESS�O 1 (nesta worksheet)
COMMIT;                   -- transa��o TERMINA;
                          -- altera��o da BD passa a PERMANENTE, sendo VIS�VEL em TODAS as SESS�ES da BD. 
SELECT * FROM t1;         -- valor = 2

-- SESS�O 2 (na UNSHARED worksheet)
SELECT * FROM t1;         -- valor = 2 (igual ao da SESS�O 1).



/******************************************************************************************************************************/ 
-- SEC��O 2.2 - N�veis de Isolamento (ISOLATION LEVEL) de Transa��es.
--
-- NOTAS:
-- Existem tr�s n�veis de isolamento de uma transa��o:
--   * SERIALIZABLE           
--   * READ COMMITTED (por omiss�o)
--   * READ ONLY
--
-- N�veis de isolamento s�o IMPLEMENTADOS com bloqueios (LOCKs):
--   * LOCKs controlam o acesso aos dados:
--       * Para evitar problemas de concorr�ncia.
--   * Permitem a uma transa��o:
--       * Impedir que outras transa��es acedam ou atualizem dados.
--   * Uma transa��o que solicita um LOCK de um recurso:
--       * S� continua quando o LOCK for concedido. 
--   * Um LOCK � libertado:
--       * Por comando COMMIT/ROLLBACK.
/******************************************************************************************************************************/

-------------------------------------------------------------------------------------------------------------------------------
-- EXEMPLO 2.2.1
-- Transa��o SERIALIZABLE
-- 
-- NOTAS:
-- S� v� dois tipos de altera��es:
--   * COMMITTED no in�cio da transa��o;
--   * Feitas pela pr�pria transa��o.

-- Apropriada para os seguintes ambientes:
--   * Grandes BD e transa��es curtas que atualizam apenas poucas linhas;
--   * Onde � relativamente pequena a hip�tese de duas transa��es concorrentes modificarem as mesmas linhas;
--   * Onde transa��es de execu��o relativamente longa s�o principalmente READ ONLY.

-- Um comando DML da transa��o SERIALIZABLE sobre um recurso:
--   * FALHA quando h� uma transa��o de ATUALIZA��O desse recurso da BD, UNCOMMITTED, no in�cio da transa��o SERIALIZABLE.
-------------------------------------------------------------------------------------------------------------------------------

-- SESS�O 1 (nesta worksheet)
SELECT * FROM t1;         -- valor = 2
  
UPDATE t1 SET valor = 3;  -- nova transa��o INICIADA; 
                          -- transa��o adquire o LOCK da tabela que impede altera��es desta, noutras transa��es;
SELECT * FROM t1;         -- valor = 3          

-- SESS�O 2 (na UNSHARED worksheet)
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE NAME 'S';  -- transa��o 'S' INICIADA. 
UPDATE t1 SET valor = 4;                                -- esperar que a transa��o da SESS�O 1 liberte o LOCK da tabela.

-- SESS�O 1 (nesta worksheet)
COMMIT;  -- liberta o LOCK da tabela.

-- SESS�O 2 (na UNSHARED worksheet)
-- o LOCK foi libertado, mas surge o ERRO ORA-08177: n�o � poss�vel sequenciar o acesso para esta transa��o.
ROLLBACK;  -- transa��o 'S' TERMINADA.

-------------------------------------------------------------------------------------------------------------------------------
-- EXEMPLO 2.2.2  
-- Transa��o READ COMMITTED (por omisss�o)
--
-- NOTAS:
-- Todas as queries executadas por uma transa��o:
--   * V�m apenas dados COMMITTED antes do in�cio da consulta (n�o do in�cio da transa��o como numa transa��o SERIALIZABLE)
--
-- Apropriada para os ambientes:
--   * Em que provavelmente poucas transa��es entram em conflito. 
--
-- Comando DML da transa��o sobre um recurso:
--   * ESPERA pela liberta��o do LOCK desse recurso quando h� uma transa��o de atualiza��o do recurso, UNCOMMITTED.
-------------------------------------------------------------------------------------------------------------------------------

-- SESS�O 1 (nesta worksheet)
SELECT * FROM t1;         -- valor = 3
  
UPDATE t1 SET valor = 4;  -- nova transa��o INICIADA.
                          -- transa��o adquire o LOCK da tabela; 
                          -- este LOCK impede altera��es desta tabela noutras transa��es.
SELECT * FROM t1;         -- valor = 4 

-- SESS�O 2 (na UNSHARED worksheet)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED NAME 'RC';  -- transa��o 'RC' INICIADA.
UPDATE t1 SET valor = 5;                                   -- esperar que a transa��o da SESS�O 1 liberte o LOCK da tabela.

-- SESS�O 1 (nesta worksheet)
COMMIT;  -- transa��o terminada;  
         -- o LOCK da tabela � libertado.

-- SESS�O 2 (na UNSHARED worksheet)
SELECT * FROM t1;  -- valor = 5 (atualizado)

-- SESS�O 1 (nesta worksheet)
SELECT * FROM t1;  -- ainda valor = 4

-- SESS�O 2 (na UNSHARED worksheet)
COMMIT;  -- transa��o 'RC' TERMINADA.

-- SESS�O 1 (nesta worksheet)
SELECT * FROM t1;  -- agora valor = 5

-------------------------------------------------------------------------------------------------------------------------------
-- EXEMPLO 2.2.3  
-- Transa��o READ ONLY.
--
-- NOTAS:
-- Semelhante a transa��es SERIALIZABLE:
--   * S� n�o permite que os dados sejam modificados na transa��o (excepto para o utilizador SYS).
-- Todas as queries executadas por uma transa��o:
--   * V�m apenas dados COMMITTED antes do in�cio da transa��o.
--
-- Apropriada para:
--   * Gerar relat�rios cujo conte�do seja consistente com o tempo anterior ao in�cio da transa��o; 
--   * Executar m�ltiplas queries sobre uma ou mais tabelas enquanto outros utilizadores atualizam essas mesmas tabelas.
-------------------------------------------------------------------------------------------------------------------------------
SET TRANSACTION READ ONLY NAME 'RO';  -- transa��o INICIADA.
                                      -- transa��o apenas de leitura (permite SELECT mas sem cl�usula FOR UPDATE).
SELECT * FROM t1;                     -- valor 5   
CALL SYS.TRANSACTIONINFO();         -- uma transa��o em curso.
UPDATE t1 SET valor = 6;              -- comando FALHA porque n�o � poss�vel alterar a BD.
CALL SYS.TRANSACTIONINFO();         -- uma transa��o em curso.                                      
COMMIT;                               -- transa��o TERMINADA. 
CALL SYS.TRANSACTIONINFO();         -- nenhuma transa��o em curso.
SELECT * FROM t1;                     -- valor 5
