-- A. Subquery não-correlacionada (SNC)
-- 1) Mostrar o nome dos marinheiros mais velhos. O comando deve usar uma SNC como
--    “operando” de um operador relacional, na cláusula WHERE.
Select nome
From marinheiros
Where idade = (Select Max(idade)
               From marinheiros);
-- 2) Mostrar o id e o nome dos marinheiros que não reservaram barcos (Figura 3). 
--    O comando deve usar uma SNC como “operando” de uma condição NOT IN, na cláusula WHERE.
Select id_marinheiro, nome
From marinheiros
Where id_marinheiro NOT IN (Select id_marinheiro
                            From reservas);
-- 3) Mostrar o id, o nome de cada marinheiro e a diferença da idade, em valor relativo, para 
--    a idade média dos marinheiros, por ordem decrescente do valor absoluto da diferença entre idades. 
--    O comando deve usar uma SNC como “coluna”, na cláusula SELECT, e a função TRUNC no resultado da diferença.
Select m1.id_marinheiro, m1.nome, 
Trunc((Select Avg(m2.idade) From Marinheiros m2) - m1.idade) As diferenca_para_idade_media
From Marinheiros m1
Order by ABS(diferenca_para_idade_media) DESC;
-- 4) Mostrar a quantidade de marinheiros que reservaram barcos com a cor vermelho e barcos com a cor verde. 
--    O comando deve usar uma SNC como “tabela”, na cláusula FROM.
Select Count(id_marinheiro) As Qtd_marinheiros
From (
       (Select Distinct id_marinheiro 
       From reservas r, barcos b 
       Where (r.id_barco=b.id_barco And cor Like 'vermelho'))
       Intersect 
       (Select Distinct id_marinheiro 
       From reservas r, barcos b 
       Where (r.id_barco=b.id_barco And cor Like 'verde'))
       );
-- 5) Mostrar as datas com mais reservas de barcos.
--    O comando deve usar uma SNC como “operando” de um operador relacional, na cláusula HAVING.
Select r1.data
From reservas r1
Group By r1.data
Having Count(*) = (
                    Select Max(Count(*)) From reservas r2 
                    Group By r2.data
                    );
-- B. Subquery correlacionada (SC)
-- 1) Mostrar o id, o nome e a quantidade de reservas de barcos dos marinheiros registados na BD, 
--    por ordem decrescente da quantidade de reservas. O comando deve usar uma SC como “coluna”, na cláusula SELECT.
Select id_marinheiro, nome,
                            (Select Count(*)
                             From reservas r
                             Where m.id_marinheiro = r.id_marinheiro) As Qtd_reservas
From marinheiros m
Order By Qtd_reservas DESC;
-- 2) Mostrar o id dos marinheiros cuja quantidade de reservas de um barco seja superior à quantidade média de 
--    reservas desse barco. Além disso, o resultado deve também incluir o id do barco e a quantidade de reservas. 
--    O comando deve usar uma SC como “operando” de um operador relacional, na cláusula HAVING.
Select r1.id_marinheiro, r1.id_barco
From reservas r1
Group By id_barco
Having Count(*) = (Select Max(Count(r.id_barco)) From reservas r Group By r.id_barco);

-- 3) Mostrar o nome dos marinheiros que reservaram todos os barcos de nome 'Interlake'.  
--    O comando deve usar uma SC como "operando" de uma condição NOT EXISTS, na cláusula WHERE. 
SELECT M.nome 
  FROM marinheiros M
 WHERE NOT EXISTS(SELECT B.id_barco
                    FROM barcos B
                   WHERE UPPER(B.nome) LIKE 'INTERLAKE'
                   MINUS
                  SELECT B.id_barco 
                    FROM barcos B INNER JOIN reservas R ON B.id_barco=R.id_barco
                   WHERE UPPER(B.nome) LIKE 'INTERLAKE' AND R.id_marinheiro=M.id_marinheiro);                               

