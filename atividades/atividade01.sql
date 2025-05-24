-- 1) Mostre todos os dados de clientes
SELECT * FROM CLIENTE;

-- 2) Mostre todos os dados da tabela de movimento
SELECT * FROM MOVIMENTO;

-- 3) Mostre o nome de todos os produtos cadastrados
SELECT NOME FROM PRODUTO;

-- 4) Mostre o nome e cidade de todos os clientes
SELECT NOME, CIDADE FROM CLIENTE;

-- 5) Mostre o nome e cidade de clientes que possuem status bom
SELECT NOME, CIDADE FROM CLIENTE WHERE STATUS = 'bom';

-- 6) Mostre o nome e preço dos produtos com preço maior que R$1,00 e menor que R$ 2,00 da categoria Sabão
SELECT NOME, PRECO FROM PRODUTO WHERE PRECO > '1.00' AND PRECO < '2.00' AND CATEGORIA = 'sabão';

-- 7) Mostre os dados de todos os pedidos, do cliente C1, para pedidos realizados no período de 01/01/1997 a 31/12/1997.
SELECT * FROM PEDIDO WHERE COD_CLI = 'c1' AND DATA_ENT BETWEEN '01/01/1997' AND '12/31/1997';