-- 1) Criar uma tabela de acumproduto com a seguinte estrutura
CREATE TABLE acumproduto (
    codproduto NUMBER PRIMARY KEY,
    descricaoproduto VARCHAR2(50) NOT NULL,
    qtde FLOAT NOT NULL);

CREATE OR REPLACE PROCEDURE preencher_acumproduto
IS
    CURSOR c_produtos IS
        SELECT i.codproduto, p.descricaoproduto, SUM(i.qtde) AS total_qtde
        FROM Xitensvenda i
        JOIN Xproduto p ON i.codproduto = p.codproduto
        GROUP BY i.codproduto, p.descricaoproduto;

    codproduto        acumproduto.codproduto%TYPE;
    descricaoproduto  acumproduto.descricaoproduto%TYPE;
    qtde              acumproduto.qtde%TYPE;

BEGIN
    OPEN c_produtos;
    LOOP
        FETCH c_produtos INTO codproduto, descricaoproduto, qtde;
        EXIT WHEN c_produtos%NOTFOUND;

        -- Inserir na tabela temporária
        INSERT INTO acumproduto (codproduto, descricaoproduto, qtde)
        VALUES (codproduto, descricaoproduto, qtde);

        -- Mostrar no DBMS_OUTPUT
        DBMS_OUTPUT.PUT_LINE('**********');
        DBMS_OUTPUT.PUT_LINE('Cód. Produto: ' || codproduto);
        DBMS_OUTPUT.PUT_LINE('Descrição: ' || descricaoproduto);
        DBMS_OUTPUT.PUT_LINE('Quantidade: ' || qtde);
    END LOOP;
    CLOSE c_produtos;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
END;

BEGIN
    preencher_acumproduto;
END;


-- 2) Criar uma tabela de produto_novo com a seguinte estrutura
CREATE TABLE produto_novo (
    descricaoproduto VARCHAR2(50) PRIMARY KEY,
    preco FLOAT NOT NULL,
    preco_aumento FLOAT NOT NULL);

CREATE OR REPLACE PROCEDURE p_atualiza_precos_produto AS
    CURSOR c_produto IS
        SELECT descricaoproduto, preco
        FROM Xproduto;

    descricaoproduto  Xproduto.descricaoproduto%TYPE;
    preco             Xproduto.preco%TYPE;
    preco_aumento     FLOAT;

BEGIN
    OPEN c_produto;
    LOOP
        FETCH c_produto INTO descricaoproduto, preco;
        EXIT WHEN c_produto%NOTFOUND;

        IF preco < 2 THEN
            preco_aumento := preco + (preco * 0.10);
            INSERT INTO produto_novo (descricaoproduto, preco, preco_aumento)
            VALUES (descricaoproduto, preco, preco_aumento);

        ELSE
            preco_aumento := preco + (preco * 0.15);
            UPDATE Xproduto
            SET preco = preco_aumento
            WHERE descricaoproduto = descricaoproduto;
        END IF;

        DBMS_OUTPUT.PUT_LINE('**********');
        DBMS_OUTPUT.PUT_LINE('Descrição: ' || descricaoproduto);
        DBMS_OUTPUT.PUT_LINE('Preço antigo: ' || TO_CHAR( preco, 'FM99990.00' ) );
        DBMS_OUTPUT.PUT_LINE('Preço atual: ' || TO_CHAR( preco_aumento, 'FM99990.00' ) );
    END LOOP;
    CLOSE c_produto;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
END;

BEGIN
    p_atualiza_precos_produto;
END;


-- 3) Criar uma tabela de nova_venda com a seguinte estrutura
CREATE TABLE nova_venda (
    nnf INTEGER NOT NULL,
    dtvenda DATE NOT NULL,
    vlvenda FLOAT NOT NULL,
    vlvenda_desconto FLOAT NOT NULL,
    PRIMARY KEY( nnf, dtvenda ) );

CREATE OR REPLACE PROCEDURE p_processar_vendas IS
    CURSOR c_vendas IS
        SELECT nnf, dtvenda, vlvenda FROM Xvenda;

    nnf              nova_venda.nnf%TYPE;
    dtvenda          nova_venda.dtvenda%TYPE;
    vlvenda          nova_venda.vlvenda%TYPE;
    vlvenda_desconto nova_venda.vlvenda_desconto%TYPE;

BEGIN
    OPEN c_vendas;
    LOOP
        FETCH c_vendas INTO nnf, dtvenda, vlvenda;
        EXIT WHEN c_vendas%NOTFOUND;

        IF vlvenda > 10 THEN
            vlvenda_desconto := vlvenda * 0.9;
        ELSE
            vlvenda_desconto := vlvenda * 0.92;
        END IF;

        INSERT INTO nova_venda (nnf, dtvenda, vlvenda, vlvenda_desconto)
        VALUES (nnf, dtvenda, vlvenda, vlvenda_desconto);

        DBMS_OUTPUT.PUT_LINE('**********');
        DBMS_OUTPUT.PUT_LINE('NNF: ' || nnf);
        DBMS_OUTPUT.PUT_LINE('Data: ' || TO_CHAR( dtvenda, 'DD/MM/YYYY' ) );
        DBMS_OUTPUT.PUT_LINE('Valor: R$ ' || TO_CHAR( vlvenda, 'FM99990.00' ) );
        DBMS_OUTPUT.PUT_LINE('Valor com Desconto: R$ ' || TO_CHAR( vlvenda_desconto, 'FM99990.00' ) );
    END LOOP;
    CLOSE c_vendas;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
END;

BEGIN
    p_processar_vendas;
END;