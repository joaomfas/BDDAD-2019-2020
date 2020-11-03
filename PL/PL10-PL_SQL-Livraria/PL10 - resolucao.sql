-- 4. Criar um script com código PL/SQL para implementar um procedimento designado procQtdEdicoesLivrosEditora. 
-- Este procedimento deve mostrar a quantidade de edições de livros de uma editora passada por parâmetro. 
-- A existência da editora na BD deve ser verificada através da estrutura de decisão IF-THEN-ELSE. 
-- Caso não se verifique a existência da editora deve ser apresentada uma mensagem apropriada. 
-- Testar adequadamente o procedimento implementado através de blocos anónimos. 
-- Para visualizar o resultado, executar o comando SET SERVEROUTPUT ON.
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE procQtdEdicoesLivrosEditora(l_id_editora Editoras.id_editora%type) AS
    l_qtd_livros INTEGER;
    l_contador INTEGER;
BEGIN
    
    SELECT COUNT(*) INTO l_contador
    FROM editoras WHERE id_editora = l_id_editora;
    
    IF(l_contador!=0)THEN
        SELECT COUNT(*) INTO l_qtd_livros
        FROM edicoes_livros WHERE id_editora = l_id_editora;
        
        DBMS_OUTPUT.PUT_LINE('Quantidade de livros: ' || l_qtd_livros);
        
    ELSE
        DBMS_OUTPUT.PUT_LINE('Editora ' || l_qtd_livros || ' inexistente!');
        
    END IF;
END;

-- 5. Criar um novo script PL/SQL para implementar um procedimento designado procStockEdicaoLivro. 
-- Este procedimento deve mostrar o stock e o stock mínimo de uma edição de um livro passado por parâmetro.
-- A existência da edição do livro na BD deve ser verificada através do mecanismo de exceções. 
-- Caso não se verifique a existência da edição do livro, deve ser apresentada uma mensagem apropriada. 
-- Testar adequadamente o procedimento implementado através de blocos anónimos.
CREATE OR REPLACE PROCEDURE procStockEdicaoLivro(l_isbn Edicoes_livros.isbn%type) AS
    l_stock INTEGER;
    l_stock_min INTEGER;
BEGIN 
    SELECT stock, stock_min INTO l_stock, l_stock_min        
    FROM edicoes_livros
    WHERE isbn = l_isbn;
        
    DBMS_OUTPUT.PUT_LINE('Stock: ' || l_stock || '  Stock mínimo: ' || l_stock_min);

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Livro não existe!!');
END;

-- 6. Criar um novo script PL/SQL para implementar um procedimento designado procAutores. 
-- Este procedimento deve listar o identificador e o nome de todos os autores. 
-- A listagem deve ter o formato ilustrado na Figura 2. 
-- O procedimento deve recorrer a um CURSOR explícito e às instruções OPEN, FETCH e CLOSE para processar o CURSOR. 
-- Testar adequadamente o procedimento implementado através de blocos anónimos.
CREATE OR REPLACE PROCEDURE procAutores AS
    CURSOR c_autores IS
        Select *
        From autores
        ORDER BY nome;
        
    l_autores autores%ROWTYPE;
    l_linha INTEGER;
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('-',4) || RPAD('ID',6) || 'NOME');
    DBMS_OUTPUT.PUT_LINE(RPAD('-',35,'-'));
    
    OPEN c_autores;
    LOOP
        FETCH c_autores INTO l_autores;
        EXIT WHEN c_autores%NOTFOUND;
        
        l_linha := c_autores%ROWCOUNT;
        
        DBMS_OUTPUT.PUT_LINE(RPAD(l_linha,8) || RPAD(l_autores.id_autor, 12) || l_autores.nome);
    END LOOP;
    CLOSE c_autores;
END;
-- 7. Duplicar o script anterior e alterar o código de modo a processar o CURSOR com uma instrução FOR de CURSOR. 
-- Testar adequadamente o procedimento implementado através de blocos anónimos.
CREATE OR REPLACE PROCEDURE procAutores1 AS
    CURSOR c_autores IS
        Select *
        From autores
        ORDER BY nome;
        
    l_autor autores%ROWTYPE;
    l_linha INTEGER;
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('-',4) || RPAD('ID',6) || 'NOME');
    DBMS_OUTPUT.PUT_LINE(RPAD('-',35));
    
    OPEN c_autores;
    FOR l_autor IN c_autores
    LOOP 
        l_linha := c_autores%ROWCOUNT;
        DBMS_OUTPUT.PUT_LINE(RPAD(l_linha,8) || RPAD(l_autor.id_autor, 12) || l_autor.nome);
    END LOOP;
    CLOSE c_autores;
END;