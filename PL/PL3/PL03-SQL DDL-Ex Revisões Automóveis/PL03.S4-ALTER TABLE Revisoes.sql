-- ** alterar tabelas, adicionando campos **

-- ## tabela Revisoes ##

--1)    Eliminar a restri��o de chave prim�ria natural da tabela Revisoes; 
ALTER TABLE revisoes DROP CONSTRAINT pk_revisoes_matricula_data_hora_marcacao;

--2)    Adicionar o novo campo id_revisoes para armazenar valores inteiros positivos gerados automaticamente (auto-incrementados); 
ALTER TABLE revisoes ADD id_revisao INTEGER GENERATED AS IDENTITY; 

--3)    Especificar o novo campo id_revisoes como chave prim�ria artificial;
ALTER TABLE revisoes ADD CONSTRAINT pk_revisoes_nr_revisao PRIMARY KEY(id_revisao);

--4)    Adicionar um registo com a mesma matricula e a data_hora_marcacao de outro registo;
INSERT INTO revisoes(matricula, data_hora_marcacao)
VALUES('42-90-AS', TO_TIMESTAMP('2018/10/23 10:50:00', 'yyyy/mm/dd hh24:mi:ss'));

--5)    Verificar a presen�a do novo registo na tabela, violando a referida correspond�ncia un�voca entre as chaves prim�rias, 
--      natural e artificial;
SELECT *
FROM revisoes
ORDER BY matricula;

--6)    Eliminar o registo adicionado anteriormente.
DELETE FROM revisoes WHERE id_revisao=/* a completar */;

--7)	Resolver o problema indicado na al�nea 5, adicionando uma restri��o que garanta combina��es �nicas dos campos matricula 
--      e data_hora_marcacao;
ALTER TABLE revisoes ADD CONSTRAINT uk_revisoes_matricula_data_hora_marcacao UNIQUE(matricula, data_hora_marcacao);

--8)	Testar a nova restri��o imposta, repetindo a al�nea 4;

--9)	Adicionar dois registos, um com valor NULL no campo matricula e outro com valor NULL no campo data_hora_marcacao;
INSERT INTO revisoes(matricula, data_hora_marcacao)
VALUES(NULL, TO_TIMESTAMP('2018/10/23 10:50:00', 'yyyy/mm/dd hh24:mi:ss'));

INSERT INTO revisoes(matricula, data_hora_marcacao)
VALUES('42-90-AS', NULL);

--10)	Verificar que os dois registos foram adicionados � tabela, violando a chave prim�ria natural;
SELECT *
FROM revisoes
ORDER BY matricula;

--11)	Resolver o problema verificado, come�ando por eliminar os dois registos adicionados;
/* a completar */

--12)	Alterar novamente a tabela de modo a impedir o valor NULL nos campos matricula e data_hora_marcacao;
ALTER TABLE revisoes MODIFY matricula CONSTRAINT nn_revisoes_matricula NOT NULL;
/* a completar * / 

--13)	Repetir o passo 9 para verificar a resolu��o do problema com o NULL na chave prim�ria natural.
