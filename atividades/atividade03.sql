-- 1) Criar uma procedure Aumenta_Produto:
create or replace procedure aumenta_produto ( percentual_aumento IN float )
is 
begin
    update Xproduto set preco = ( preco * percentual_aumento ) / 100 + preco;
end;

-- 2) Criar a função perc_desconto, que recebe como parâmetro o código do cliente e deve retornar o percentual de desconto conforme a tabela abaixo:
create or replace procedure perc_desconto ( codcli IN number, percentual_desc OUT float )
is 
    totalItens number := 0;
begin
    select count(*) into totalItens from Xvenda v
        inner join Xitensvenda iv on (v.nnf = iv.nnf and v.dtvenda = iv.dtvenda)
        where v.codcliente = codcli;
    IF totalItens = 1 THEN
        percentual_desc := 5;
    ELSIF totalItens > 1 and totalItens <= 9 THEN
        percentual_desc := 7.5;
    ELSIF totalItens >= 10 THEN
        percentual_desc := 12.5;
    END IF;
end;

-- 3) Criar uma procedure media_vendas:
CREATE OR REPLACE PROCEDURE p_media_vendas (
    p_codcliente IN NUMBER,
    media_vendas OUT FLOAT,
    qtd_vendas OUT NUMBER
)
IS
BEGIN
    SELECT COUNT(*)
    INTO qtd_vendas
    FROM Xvenda
    WHERE codcliente = p_codcliente;

    SELECT AVG(vlvenda)
    INTO media_vendas
    FROM Xvenda
    WHERE codcliente = p_codcliente;
END;

DECLARE
    media_vendas FLOAT;
    qtd_vendas NUMBER;
BEGIN
    p_media_vendas( 1, media_vendas, qtd_vendas );
    DBMS_OUTPUT.PUT_LINE( 'Média de vendas: ' || media_vendas );
    DBMS_OUTPUT.PUT_LINE( 'Quantidade de vendas: ' || qtd_vendas );
END;

-- 4) Criar uma procedure media_produto:
CREATE OR REPLACE PROCEDURE p_media_produto (
    data_ini IN DATE,
    data_fim IN DATE,
    media_valor OUT FLOAT,
    soma_qtde OUT NUMBER
)
IS
BEGIN
    SELECT SUM(qtde)
    INTO soma_qtde
    FROM Xitensvenda
    WHERE dtvenda BETWEEN data_ini AND data_fim;

    SELECT AVG(p.preco)
    INTO media_valor
    FROM Xitensvenda i
    JOIN Xproduto p ON i.codproduto = p.codproduto
    WHERE i.dtvenda BETWEEN data_ini AND data_fim;
END;

DECLARE
    media_preco FLOAT;
    soma_qtd  NUMBER;
BEGIN
    p_media_produto( TO_DATE('20/04/2002','DD/MM/YYYY' ), TO_DATE( '25/04/2002','DD/MM/YYYY' ), media_preco, soma_qtd );
    DBMS_OUTPUT.PUT_LINE( 'Média dos preços: ' || media_preco );
    DBMS_OUTPUT.PUT_LINE( 'Soma das quantidades: ' || soma_qtd );
END;

-- 5) Criar uma procedure max_vltipopagto:
CREATE OR REPLACE PROCEDURE p_max_vltipopagto (
    descricaotppagto IN VARCHAR,
    maior_valor OUT FLOAT
)
IS
BEGIN
    SELECT MAX(v.vlvenda)
    INTO maior_valor
    FROM Xvenda v
    JOIN Xtipospagamento t ON v.codtppagamento = t.codtppagamento
    WHERE t.descricaotppagamento = descricaotppagto;
END;

DECLARE
    v_maior_valor FLOAT;
BEGIN
    p_max_vltipopagto( 'Dinheiro', v_maior_valor );
    DBMS_OUTPUT.PUT_LINE( 'Maior valor de venda para o tipo de pagamento: ' || v_maior_valor );
END;

-- 6) Criar a função retorna_mediageral que retorna a média geral das vendas. 
create or replace function media_venda_cli
return float is
v_media float;
begin

select avg(vlvenda)
into v_media
from Xvenda;
return(v_media);
end;

--Para Rodar
select media_venda_cli from dual

-- 7) Criar a função retorna_novo_preco:
CREATE OR REPLACE FUNCTION f_retorna_novo_preco (
    descricaoproduto IN VARCHAR,
    qtde_vendida IN NUMBER
) 
RETURN FLOAT IS
    preco_atual FLOAT;
    novo_preco FLOAT;
BEGIN
    SELECT preco INTO preco_atual
    FROM Xproduto p
    WHERE p.descricaoproduto = descricaoproduto;

    IF qtde_vendida = 1 THEN
        novo_preco := preco_atual * 1.05;
    ELSIF qtde_vendida = 2 THEN
        novo_preco := preco_atual * 1.07;
    ELSIF qtde_vendida = 3 THEN
        novo_preco := preco_atual * 1.08;
    ELSIF qtde_vendida = 4 THEN
        novo_preco := preco_atual * 1.09;
    ELSIF qtde_vendida >= 5 THEN
        novo_preco := preco_atual * 1.12;
    END IF;

    RETURN novo_preco;
END;

-- 8) Criar a função retorna_valor_pagamento
CREATE OR REPLACE FUNCTION f_retorna_valor_pagamento (
    descricaotppagamento IN VARCHAR
) 
RETURN NUMBER IS
    qtd_clientes NUMBER;
BEGIN
    SELECT COUNT(DISTINCT v.codcliente) 
    INTO qtd_clientes
    FROM Xvenda v
    JOIN Xtipospagamento t ON v.codtppagamento = t.codtppagamento
    WHERE t.descricaotppagamento = descricaotppagamento;

    RETURN qtd_clientes;
END;

-- 9) Criar a função retorna_ultimavenda
CREATE OR REPLACE FUNCTION f_retorna_ultimavenda (
    descricaoproduto IN VARCHAR2
) 
RETURN DATE IS
    ultima_data DATE;
BEGIN
    SELECT MAX(v.dtvenda)
    INTO ultima_data
    FROM Xitensvenda i
    JOIN Xproduto p ON i.codproduto = p.codproduto
    JOIN Xvenda v ON i.nnf = v.nnf AND i.dtvenda = v.dtvenda
    WHERE p.descricaoproduto = descricaoproduto;

    RETURN ultima_data;
END;

-- 10) Criar a função retorna_menorvenda
CREATE OR REPLACE FUNCTION f_retorna_menorvenda 
RETURN FLOAT IS
    menor_valor FLOAT;
BEGIN
    SELECT MIN(vlvenda)
    INTO menor_valor
    FROM Xvenda;

    RETURN menor_valor;
END;