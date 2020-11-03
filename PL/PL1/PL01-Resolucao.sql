--A. Seleções Simples
-- 1) Mostrar todos os dados da tabela CD;
Select * 
From CD;
-- 2) Mostrar o título e a data de compra de todos os CD;
Select titulo,data_compra
From CD;
-- 3) Mostrar a data de compra de todos CD;
Select data_compra
From CD;
-- 4) Mostrar o resultado da alínea anterior, mas sem repetições;
Select Distinct data_compra
From CD;
-- 5) Mostrar o código do CD e o intérprete de todas as músicas;
Select cod_cd, interprete
From Musicas;
-- 6) Mostrar o resultado da alínea anterior, mas sem repetições;
Select Distinct cod_cd, interprete
From Musicas;
-- 7) Mostrar a data de compra de todos os CD com o resultado intitulado "Data de Compra";
Select data_compra AS "Data de Compra"
From CD;
-- 8) Mostrar o título, o valor pago e o respetivo valor do IVA de todos os CD. O valor do IVA é calculado de 
--    acordo com a seguinte fórmula: valor do IVA = (valor pago * 0.23) / 1.23;
Select titulo, (valor_pago*0.23)/1.23 AS "Valor do IVA" 
From CD;
-- 9) Mostrar todos os dados de todas as músicas do CD com o código 2;
Select * From CD
Where cod_cd = 2;
-- 10) Mostrar todos os dados de todas as músicas que não pertencem ao CD com o código 2;
Select * From CD
Where cod_cd != 2;
-- 11) Mostrar todos os dados de todas as músicas do CD com o código 2 cuja duração seja superior a 5;
Select * From Musicas
Where cod_cd = 2 AND duracao < 5;
-- 12) Mostrar todos os dados das músicas do CD com o código 2 cuja duração pertença ao intervalo [4,6];
Select * From Musicas
Where cod_cd = 2 AND (duracao >= 4 AND duracao <= 6);
-- 13) Mostrar todos os dados das músicas do CD com o código 2 cuja duração seja inferior a 4 ou superior a 6;
Select * From Musicas
Where cod_cd = 2 AND (duracao < 4 OR duracao > 6);
-- 14) Mostrar todos os dados das músicas com os números: 1, 3, 5 ou 6;
Select * From Musicas
Where nr_musica IN (1,3,5,6);
-- 15) Mostrar todos os dados das músicas com os números diferentes de 1, 3, 5 e 6;
Select * From Musicas
Where nr_musica NOT IN (1,3,5,6);
-- 16) Mostrar os títulos dos CD comprados na FNAC;
Select titulo From CD
Where local_compra = 'FNAC';
-- 17) Mostrar os títulos dos CD que não foram comprados na FNAC;
Select titulo From CD
Where local_compra != 'FNAC';
-- 18) Mostrar todos os dados das músicas cujo intérprete é uma orquestra;
Select * From Musicas
Where interprete Like '%Orquestra%' OR 
interprete Like '%Orchestra%';
-- 19) Mostrar todos os dados das músicas cujo intérprete tem um Y;
Select * From Musicas
Where interprete Like '%y%'
Or interprete Like '%Y%';
-- 20) Mostrar todos os dados das músicas cujo nome termina com DAL?, sendo ? qualquer caráter;
Select * From Musicas
Where titulo Like '%dal_%';
-- 21) Mostrar todos os dados das músicas cujo título tem o caráter %;
Select * From Musicas
Where titulo Like '%@%%' Escape '@';
-- 22) Mostrar todos os dados das músicas cujo título é iniciado pela letra B, D ou H;
Select * From Musicas
Where titulo Like Upper('B%') Or 
titulo Like Upper('D%') Or
titulo Like Upper('H%');
-- 23) Mostrar todos os dados dos CD sem o local de compra registado;
Select * From CD
Where local_compra Is NULL;
-- 24) Mostrar todos os dados dos CD com o local de compra registado.
Select * From CD
Where local_compra Is Not Null;

-- B. Ordenações
-- 1) Mostrar o título e a data de compra dos CD, por ordem alfabética do título do CD;
Select titulo, data_compra From CD
Order by titulo Asc;
-- 2) Mostrar o título e a data de compra dos CD, por ordem descendente da data de compra do CD;
Select titulo, data_compra From CD
Order by data_compra Desc;
-- 3) Mostrar o título e o local de compra dos CD, por ordem ascendente do local de compra do CD;
Select titulo, local_compra From CD
Order by local_compra Asc;
-- 4) Mostrar o resultado da alínea anterior, mas por ordem descendente do local de compra do CD;
Select titulo, local_compra From CD
Order by local_compra Desc;
-- 5) Mostrar o título, o valor pago e o respetivo valor do IVA dos CD, por ordem decrescente do IVA;
Select titulo, valor_pago From CD
Order by (valor_pago*0.23)/1.23;
-- 6) Mostrar o título do CD por ordem descendente da data de compra e, no caso da igualdade de datas, por
--ordem alfabética do título.
Select titulo From CD
Order by data_compra, titulo Asc;

-- C. Funções de Agregação
-- 1) Mostrar a quantidade de músicas;
Select Count(*) From Musicas;
-- 2) Mostrar a quantidade de locais de compra distintos;
Select Count(Distinct local_compra) From CD;
-- 3) Mostrar o total gasto com a compra de todos os CD;
Select Sum(valor_pago) From CD;
-- 4) Mostrar o maior valor pago por um CD;
Select Max(valor_pago) From CD;
-- 5) Mostrar o menor valor pago por um CD;
Select Min(valor_pago) From CD;
-- 6) Mostrar a média da duração de todas as músicas.
Select Avg(duracao) From Musicas;

-- D. Seleções em múltiplas tabelas - Junções (joins)
-- 1) Mostrar o título do CD e o título das músicas de todos os CD;
Select C.titulo, M.titulo
From CD C, Musicas M
Where C.cod_cd = M.cod_cd;
-- 2) Mostrar o título do CD e o título da música com o número 1 de cada CD;
Select C.titulo, M.titulo
From CD C, Musicas M
Where M.nr_musica = 1 AND C.cod_cd = M.cod_cd;
-- 3) Mostrar o número, o título e a duração, de todas as músicas do CD com o título Punkzilla.
Select M.nr_musica,M.titulo, M.duracao
From CD C, Musicas M
Where C.titulo Like 'Punkzilla';