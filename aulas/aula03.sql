select categoria, sum(preco) from produto
    group by categoria
    having sum(preco) > 2

select categoria, sum(preco) from produto
    group by categoria
    having sum(preco) = 
    (select max(maior) from
        (select categoria, sum(preco) as maior from produto
            group by categoria) AS sum_preco)

select produto.nome, R1.maior
    from produto,
    (select cod_prod, max(preco) as maior from produto
        group by cod_prod) R1
    where produto.cod_prod = R1.cod_prod

select cidade, count(*) from cliente
    where limite >= 500
    group by cidade
    having count(*) >= 2


-- Mostre os códigos dos clientes que nunca fizeram pedido
select cod_cli from cliente
    where cod_cli not in
        (select cod_cli from pedido)

-- Mostre os códigos dos clientes que já fizeram pedido
select c.cod_cli from cliente c
    Inner join pedido p on p.cod_cli = c.cod_cli

-- Mostre os códigos e nome dos clientes que nunca fizeram pedido
select nome, cod_cli from cliente
    minus
    select c.nome, p.cod_cli from cliente c, pedido p
        where p.cod_cli = c.cod_cli

select nome, cod_cli from cliente
    where not exists
    (select * from pedido where cliente.cod_cli = pedido.cod_cli)

select nome, cod_cli from cliente
    where cod_cli not in
        (select cod_cli from pedido)