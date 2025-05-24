-- Mostre os alunos que fizeram todas as disciplinas do prof Gastão

Select nome from aluno where not exist( (Select cod_disc from disciplina where prof = 'Gastão') minus (select cod_disc from turma where cod_aluno = aluno.cod_aluno) )

-- Todos os clientes que compraram produtos da categoria sabão
Select nome 

-- Mostre todos os clientes que não fizeram pedido
Select c.cod_cli, c.nome, p.nro_ped from cliente c
    left join pedido p on p.cod_cli = c.cod_cli
    where nro_ped is null

-- Criando uma view onde não é permitido visualizar a coluna limite 
create view vcliente as
    select cod_cli, nome, cidade, uf, telefone, status from cliente

-- Para qualificar uma view, adicionamos o 'or replace' para fazer update
create or replace view vcliente as
    select cod_cli, nome, cidade, uf, telefone, status from cliente
    where limite < 100;

select * from vcliente