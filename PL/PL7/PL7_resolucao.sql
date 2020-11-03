-- 1) Mostrar o nome de todos os médicos e, no caso dos médicos subordinados, o nome do respetivo médico chefe (Figura 2). 
-- O resultado deve ser apresentado por ordem alfabética do primeiro nome referido anteriormente. 
-- O comando deve usar a função NVL que permite substituir o valor NULL por outro valor.
Select m1.nome,
    NVL((Select m2.nome
    From medicos m2
    Where m2.id_medico = m1.id_medico_chefe),' ') as chefe
From medicos m1
Order by 1;

-- 2) Mostrar o id e a designação das especialidades, juntamente com as respetivas datas em que tiveram o maior número de consultas (Figura 3). 
-- O resultado deve ser apresentado por ordem alfabética da designação da especialidade e por ordem ascendente da data. 
-- O comando deve usar a cláusula WITH que permite a reutilização de código.
with consultas_especialidades as
(
    select e.id_especialidade, e.designacao, trunc(c.data_hora) data, count(*) cnt
    from consultas c, medicos m, especialidades e
    where c.id_medico = m.id_medico and m.id_especialidade = e.id_especialidade
    group by e.id_especialidade, e.designacao, trunc(c.data_hora)
)

select id_especialidade, designacao, data
    from consultas_especialidades ce1
    where cnt = (select max(cnt)
        from consultas_especialidades ce2
        where ce1.id_especialidade = ce2.id_especialidade)
 order by 2, 3; 