--/ 4. Criar um script com código PL/SQL para implementar uma função, designada funcStockMax. 
--/ A função deve retornar o maior stock das edições dos livros da livraria. 
--/ Testar adequadamente a função implementada, através de blocos anónimos.
CREATE OR REPLACE FUNCTION funcStockMax RETURN INTEGER
AS
    stockMax INTEGER;
BEGIN
    SELECT MAX(stock) INTO stockMax
    FROM Edicoes_Livros;
    
    RETURN stockMax;
END;

--/ TESTE COM BLOCO ANÓNIMO
SET SERVEROUTPUT ON;
DECLARE
    stockMax INTEGER;
BEGIN
    stockMax := funcStockMax;
    DBMS_OUTPUT.PUT_LINE('O stock máximo é ' || stockMax);
END;

--/ 5. Criar um novo script PL/SQL para implementar um procedimento, designado procTitulosEdicoesStockMax. 
--/ O procedimento deve listar os títulos das edições dos livros que têm o maior stock. 
--/ Caso o stock seja zero, deve ser apresentada uma mensagem apropriada, usando o mecanismo de exceções. 
--/ Testar adequadamente o procedimento implementado, através de blocos anónimos.
CREATE OR REPLACE PROCEDURE procTitulosEdicoesStockMax AS
    maxStock INTEGER;
    zero_stock EXCEPTION;
    nome_livro livros.titulo%TYPE;
BEGIN
    maxStock := funcStockMax;
    
    IF maxStock = 0 THEN
        RAISE zero_stock;
    ELSE
        FOR r in(SELECT l.titulo INTO nome_livro
                FROM livros l, edicoes_livros el
                WHERE el.stock = maxStock
                AND el.id_livro = l.id_livro
                )
        LOOP
            DBMS_OUTPUT.PUT_LINE('Livro com stock máximo ' || r.titulo);
        END LOOP;
    END IF;
EXCEPTION
    WHEN zero_stock THEN 
        DBMS_OUTPUT.PUT_LINE('O stock máximo é zero!!');
END;

--/ TESTE COM BLOCO ANÓNIMO
EXEC procTitulosEdicoesStockMax;

--/ 6. Criar um novo script PL/SQL para implementar uma função, designada funcTitulosAno, 
--/ para retornar os títulos dos livros editados num dado ano. 
--/ A função deve receber, por parâmetro, o ano e tem de retornar um CURSOR do tipo SYS_REFCURSOR. 
--/ Caso o ano recebido seja inválido, a função tem de retornar o valor NULL. 
--/ Testar adequadamente a função implementada através de blocos anónimos.
CREATE OR REPLACE FUNCTION funcTitulosAno(ano edicoes_livros.ano_edicao%TYPE) RETURN SYS_REFCURSOR IS
    livros_rc SYS_REFCURSOR;
BEGIN
    OPEN livros_rc FOR
        SELECT l.titulo
        FROM livros l, edicoes_livros el
        WHERE el.ano_edicao = ano
            AND el.id_livro = l.id_livro;
    RETURN (livros_rc);
END;

--/ TESTE COM BLOCO ANÓNIMO

SELECT funcTitulosAno(2010) FROM dual;

DECLARE
    l_livros SYS_REFCURSOR;
    l_livro livros.titulo%TYPE;
BEGIN
    l_livros := funcTitulosAno(2010);
    LOOP
        FETCH l_livros INTO l_livro;
        EXIT WHEN l_livros%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('LIVRO: ' || l_livro);
    END LOOP;
END;