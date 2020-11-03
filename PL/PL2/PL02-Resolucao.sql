-- A. Seleções Simples
-- 1) Mostrar todos os dados da tabela Equipas;
Select * From Equipas;
-- 2) Mostrar todos os dados da equipa com o id igual a 12;
Select *
From Equipas
Where id_equipa = 12;
-- 3) Mostrar o id e o nome de todas as equipas;
Select equipas.id_equipa, equipas.nome
From equipas;
-- 4) Mostrar o id, o nome e a idade dos treinadores com menos de 40 anos de idade;
Select T.id_treinador, T.nome, T.idade
From Treinadores T
Where T.idade < 40;
-- 5) Mostrar todos os dados da tabela Experiencias relativos aos treinadores que treinaram juniores
-- ou que tenham mais do que 10 anos de experiência;
Select * From Experiencias
Where escalao Like 'Juniores';
-- 6) Mostrar todos os dados dos treinadores com idade pertencente ao intervalo [45, 53] e por ordem
-- decrescente da idade;
Select * From Treinadores
Where idade>=45 AND idade <= 53;
-- 7) Mostrar todos os dados das bolas dos fabricantes Reebok e Olimpic;
Select * From Bolas
Where fabricante Like '%Reebok%' Or 
fabricante Like '%Olimpic%';
-- 8) Mostrar todos os dados dos treinadores cujo nome começa pela letra A.
Select * From Treinadores
Where nome Like 'A%';

-- B. Funções de agregação
-- 1) Mostrar a quantidade de equipas que disputam o campeonato;
Select Count(*) From Equipas;
-- 2) Mostrar a quantidade de fabricantes distintos que produzem bolas usadas no campeonato;
Select Count(Distinct fabricante) From Bolas;
-- 3) Mostrar a quantidade de treinadores com idade superior a 40 anos;
    Select Count (*)
    From Treinadores
    Where idade > 40;
-- 4) Mostrar a idade do treinador mais velho.
Select Max(idade) From Treinadores;

-- C. Seleções em múltiplas tabelas - Junções (joins)
-- 1) Mostrar o id das equipas que utilizam bolas do fabricante Adidas;
Select E.id_equipa
From Equipas E, Bolas B
Where B.fabricante Like 'Adidas' And E.id_equipa = B.id_equipa;
-- 2) Mostrar o resultado da alínea anterior, mas sem repetições;
Select Distinct E.id_equipa
From Equipas E, Bolas B
Where B.fabricante Like 'Adidas' And E.id_equipa = B.id_equipa;
-- 3) Mostrar a média das idades dos treinadores de juvenis;
Select Avg(T.idade)
From Treinadores T, Experiencias E
Where E.escalao Like 'Juvenis' And E.id_treinador = T.id_treinador;
-- 4) Mostrar todos os dados dos treinadores que treinaram juniores durante 5 ou mais anos;
Select *
From Treinadores t, Experiencias e
Where e.escalao Like 'juniores' And t.id_treinador = e.id_treinador And e.anos >= 5;
-- 5) Mostrar todos os dados dos treinadores e das equipas por eles treinadas;
Select *
From Treinadores t, Equipas e, Experiencias ex
Where t.id_treinador = ex.id_treinador And ex.id_equipa = e.id_equipa;
-- 6) Mostrar os nomes e os telefones dos treinadores e os nomes das equipas por eles treinadas;
Select t.nome, t.telefone, e.nome
From Treinadores t, Equipas e, Experiencias ex
Where t.id_treinador = ex.id_treinador And ex.id_equipa = e.id_equipa;
-- 7) Mostrar todos os dados da equipa do Académico e dos respetivos treinadores;
Select *
From Treinadores t, Equipas e, Experiencias ex
Where e.nome Like 'Académico' And e.id_equipa = ex.id_equipa And ex.id_treinador = t.id_treinador;
-- 8) Mostrar a idade do treinador mais velho do Académico;
Select Max(t.idade)
From Treinadores t, Equipas e, Experiencias ex
Where e.nome Like 'Académico' And e.id_equipa = ex.id_equipa And ex.id_treinador = t.id_treinador;
-- 9) Mostrar o total de anos de experiência do treinador António do Académico.
Select Sum(ex.anos)
From Treinadores t, Equipas e, Experiencias ex
Where e.nome Like 'Académico' 
And e.id_equipa = ex.id_equipa 
And ex.id_treinador = t.id_treinador 
And t.nome Like 'António';