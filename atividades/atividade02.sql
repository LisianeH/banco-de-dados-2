-- 1) Selecionar o nome do cliente e quantidade de produtos comprados, somente para clientes que compraram Coca Cola.
select c.cliente, iv.qtde from Xcliente c
    Inner join Xvenda v on c.codcliente = v.codcliente
    Inner join  Xitensvenda iv on v.nnf = iv.nnf and v.dtvenda = iv.dtvenda
    Inner join Xproduto prod on iv.codproduto = prod.codproduto
    where prod.descricaoproduto = 'Coca Cola';

-- 2) Selecionar o nome do cliente e o valor total comprado por ele.
select c.cliente, sum(v.vlvenda) as sum from Xcliente c
    Inner join Xvenda v on c.codcliente = v.codcliente
    group by c.cliente
    order by c.cliente asc;

-- 3) Selecionar a descrição e o maior preço de produto vendido.
select prod.descricaoproduto, max(prod.preco) as max from Xproduto prod
    Inner join Xitensvenda iv on iv.codproduto = prod.codproduto
    group by prod.descricaoproduto;

-- 4) Selecionar o nome do cliente e descrição do tipo de pagamento utilizado nas vendas.
select c.cliente, tp.descricaotppagamento from Xcliente c
    Inner join Xvenda v on v.codcliente = c.codcliente
    Inner join Xtipospagamento tp on tp.codtppagamento = v.codtppagamento;
    
-- 5) Selecionar o nome do cliente, nnf, data da venda, descrição do tipo de pagamento, descrição do produto e quantidade vendida dos itens vendidos. 
select c.cliente, v.nnf, TO_CHAR(v.dtvenda, 'YYYY-MM-DD') as dtvenda, tp.descricaotppagamento, prod.descricaoproduto, iv.qtde from Xcliente c
    Inner join Xvenda v on v.codcliente = c.codcliente
    Inner join Xtipospagamento tp on tp.codtppagamento = v.codtppagamento
    Inner join Xitensvenda iv on iv.nnf = v.nnf and iv.dtvenda = v.dtvenda
    Inner join Xproduto prod on prod.codproduto = iv.codproduto
    order by c.cliente asc, prod.descricaoproduto asc;

-- 6) Selecionar a média de preço dos produtos vendidos.
select avg(prod.preco) as avg from Xproduto prod;

-- 7) Selecionar o nome do cliente e a descrição dos produtos comprados por ele. Não repetir os dados (distinct).
select distinct c.cliente, prod.descricaoproduto from Xcliente c 
    Inner join Xvenda v on v.codcliente = c.codcliente
    Inner join Xitensvenda iv on iv.nnf = v.nnf and iv.dtvenda = v.dtvenda
    Inner join Xproduto prod on prod.codproduto = iv.codproduto
    order by c.cliente asc;

-- 8) Selecionar a descrição do tipo de pagamento, e a maior data de venda que utilizou esse tipo de pagamento. Ordenar a consulta pela descrição do tipo de pagamento.
select tp.descricaotppagamento, TO_CHAR(max(v.dtvenda), 'YYYY-MM-DD') as max from Xtipospagamento tp
    Inner join Xvenda v on v.codtppagamento = tp.codtppagamento
    group by tp.descricaotppagamento
    order by tp.descricaotppagamento asc;

-- 9) Selecionar a data da venda e a média da quantidade de produtos vendidos. Ordenar pela data da venda decrescente.
select TO_CHAR(v.dtvenda, 'YYYY-MM-DD') as dtvenda, avg(iv.qtde) as avg from Xvenda v
    Inner join Xitensvenda iv on iv.nnf = v.nnf and iv.dtvenda = v.dtvenda
    group by v.dtvenda
    order by v.dtvenda desc;

-- 10) Selecionar a descrição do produto e a média de quantidades vendidas do produto. Somente se a média for superior a 4.
select prod.descricaoproduto, avg(iv.qtde) as avg from Xproduto prod
    Inner join Xitensvenda iv on iv.codproduto = prod.codproduto
    group by prod.descricaoproduto
    having AVG(iv.qtde) > 4;