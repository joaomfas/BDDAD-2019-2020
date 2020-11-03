-- 4.
--      1)
(Select cd.titulo
From CD cd)
UNION ALL
(Select m.titulo
From Musicas m);

--      2)
(Select cd.titulo
From CD cd)
UNION
(Select m.titulo
From Musicas m);

--      3)
(Select cd.titulo, LENGTH(cd.titulo)
From CD cd)
UNION
(Select m.titulo, LENGTH(m.titulo)
From Musicas m);

--      4)
Select cd.titulo
From CD cd, Musicas m
Where cd.titulo = m.titulo;

--      5)
(Select m.duracao
From Musicas m
Where m.interprete = 'Pink Floyd')
INTERSECT
(Select m.duracao
From Musicas m
Where m.interprete != 'Pink Floyd');

--      6)
(Select m.duracao
From Musicas m
Where m.interprete = 'Pink Floyd')
INTERSECT
(Select m.duracao
From Musicas m
Where m.interprete != 'Pink Floyd')
ORDER BY duracao DESC;

--      7)
Select id_editora
From Editoras
Minus
Select id_editora
From CD;

-- 5.
--      1)
Select Count(*)
From CD
Group By local_compra;

--      2)
Select Distinct Count(*)
From CD
Group By local_compra;

--      3)
Select local_compra, Count(*)
From CD
Group By local_compra;

--      4)
Select local_compra, Count(*)
From CD
Group By local_compra
ORDER BY 2 ASC;

--      5)
Select local_compra, Count(*)
From CD
Where local_compra IS NOT NULL
Group By local_compra
ORDER BY 2 ASC;

--      6)
Select local_compra, Count(*), SUM(valor_pago), MAX(valor_pago)
From CD
Where local_compra IS NOT NULL
Group By local_compra
ORDER BY 2 ASC;

--      7)
Select cod_cd, interprete, Count(*)
From Musicas
Group By cod_cd, interprete
Order By cod_cd;

--      8)
Select Count(*)
From CD
Group By local_compra
Having Count(*) > 2;

--      9)