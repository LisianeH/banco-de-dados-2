select * from cliente
select * from pedido where rownum <= 10 -- limitando para 10 linhas da tabela
select * from produto
select * from movimento

select nome, nro_ped from cliente, pedido --caso que gera produto cartesiano

select cliente.nome, pedido.nro_ped from cliente, pedido, movimento, produto 
    where cliente.cod_cli = pedido.cod_cli 
    and produto.categoria = 'sabão'
    and pedido.nro_ped = movimento.nro_ped
    and movimento.cod_prod = produto.cod_prod

select nome, nro_ped from cliente c
    Inner Join pedido p on (c.cod_cli = p.cod_cli)

select c.nome, p.nro_ped from cliente c, pedido p, produto prod, movimento m
    where c.cod_cli = p.cod_cli
    and categoria = 'sabão'
    and p.nro_ped = m.nro_ped
    and prod.cod_prod = m.cod_prod;