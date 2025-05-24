-- 1) Criar tabela de acumpagamento. Criar trigger’s de insert, update e delete da tabela de Xvenda com a finalidade de armazenar o valor de venda para cada tipo de pagamento, mês e ano na tabela de acumpagamento.
CREATE TABLE acumpagamento (
    codtppagamento  INT NOT NULL,
    mes             INT NOT NULL,
    ano             INT NOT NULL,
    valor           FLOAT NOT NULL,
    PRIMARY KEY (codtppagamento, mes, ano)
);

-- trigger insert
CREATE OR REPLACE TRIGGER trg_insert_venda
AFTER INSERT ON Xvenda
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM acumpagamento
    WHERE codtppagamento = :NEW.codtppagamento
      AND mes = EXTRACT(MONTH FROM :NEW.dtvenda)
      AND ano = EXTRACT(YEAR FROM :NEW.dtvenda);

    IF v_count = 0 THEN
        INSERT INTO acumpagamento (codtppagamento, mes, ano, valor)
        VALUES (:NEW.codtppagamento,
                EXTRACT(MONTH FROM :NEW.dtvenda),
                EXTRACT(YEAR FROM :NEW.dtvenda),
                :NEW.vlvenda);
    ELSE
        UPDATE acumpagamento
        SET valor = valor + :NEW.vlvenda
        WHERE codtppagamento = :NEW.codtppagamento
          AND mes = EXTRACT(MONTH FROM :NEW.dtvenda)
          AND ano = EXTRACT(YEAR FROM :NEW.dtvenda);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro na trigger trg_insert_venda: ' || SQLERRM);
END;

-- trigger update
CREATE OR REPLACE TRIGGER trg_update_venda
AFTER UPDATE ON Xvenda
FOR EACH ROW
BEGIN
    UPDATE acumpagamento
    SET valor = valor - :OLD.vlvenda
    WHERE codtppagamento = :OLD.codtppagamento
      AND mes = EXTRACT(MONTH FROM :OLD.dtvenda)
      AND ano = EXTRACT(YEAR FROM :OLD.dtvenda);
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM acumpagamento
        WHERE codtppagamento = :NEW.codtppagamento
          AND mes = EXTRACT(MONTH FROM :NEW.dtvenda)
          AND ano = EXTRACT(YEAR FROM :NEW.dtvenda);

        IF v_count = 0 THEN
            INSERT INTO acumpagamento (codtppagamento, mes, ano, valor)
            VALUES (:NEW.codtppagamento,
                    EXTRACT(MONTH FROM :NEW.dtvenda),
                    EXTRACT(YEAR FROM :NEW.dtvenda),
                    :NEW.vlvenda);
        ELSE
            UPDATE acumpagamento
            SET valor = valor + :NEW.vlvenda
            WHERE codtppagamento = :NEW.codtppagamento
              AND mes = EXTRACT(MONTH FROM :NEW.dtvenda)
              AND ano = EXTRACT(YEAR FROM :NEW.dtvenda);
        END IF;
    END;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro na trigger trg_update_venda: ' || SQLERRM);
END;

-- trigger delete
CREATE OR REPLACE TRIGGER trg_delete_venda
AFTER DELETE ON Xvenda
FOR EACH ROW
BEGIN
    UPDATE acumpagamento
    SET valor = valor - :OLD.vlvenda
    WHERE codtppagamento = :OLD.codtppagamento
      AND mes = EXTRACT(MONTH FROM :OLD.dtvenda)
      AND ano = EXTRACT(YEAR FROM :OLD.dtvenda);

    DELETE FROM acumpagamento
    WHERE codtppagamento = :OLD.codtppagamento
      AND mes = EXTRACT(MONTH FROM :OLD.dtvenda)
      AND ano = EXTRACT(YEAR FROM :OLD.dtvenda)
      AND ABS(valor) < 0.01;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro na trigger trg_delete_venda: ' || SQLERRM);
END;

-- verificando que não tem nada na tabela
SELECT * FROM acumpagamento;

-- inserindo nova venda na Xvenda, para adicionar na acumpagamento
INSERT INTO Xvenda (nnf, dtvenda, codcliente, codtppagamento, vlvenda)
VALUES (3, TO_DATE('2025-05-24', 'YYYY-MM-DD'), 1, 1, 37.40);

SELECT * FROM acumpagamento;

-- update de uma venda existente
UPDATE Xvenda
SET vlvenda = 50.00
WHERE nnf = 3
  AND dtvenda = TO_DATE('2025-05-24', 'YYYY-MM-DD');

SELECT * FROM acumpagamento;

-- deletar a venda 
DELETE FROM Xvenda
WHERE nnf = 3
  AND dtvenda = TO_DATE('2025-05-24', 'YYYY-MM-DD');

SELECT * FROM acumpagamento;

-- 2) Criar tabela de acumproduto. Criar trigger’s de insert, update e delete da tabela de Xitensvenda, com a finalidade de inserir na tabela de acumproduto.
CREATE TABLE acumproduto_at5 (
    codproduto  INT NOT NULL,
    qtde        INT NOT NULL,
    PRIMARY KEY (codproduto) );

-- trigger de insert
CREATE OR REPLACE TRIGGER trg_insert_itensvenda
AFTER INSERT ON Xitensvenda
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM acumproduto_at5
    WHERE codproduto = :NEW.codproduto;

    IF v_count = 0 THEN
        INSERT INTO acumproduto_at5 (codproduto, qtde)
        VALUES (:NEW.codproduto, :NEW.qtde);
    ELSE
        UPDATE acumproduto_at5
        SET qtde = qtde + :NEW.qtde
        WHERE codproduto = :NEW.codproduto;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro na trigger trg_insert_itensvenda: ' || SQLERRM);
END;

-- trigger update
CREATE OR REPLACE TRIGGER trg_update_itensvenda
AFTER UPDATE OF qtde ON Xitensvenda
FOR EACH ROW
BEGIN
    UPDATE acumproduto_at5
    SET qtde = qtde - :OLD.qtde + :NEW.qtde
    WHERE codproduto = :NEW.codproduto;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro na trigger trg_update_itensvenda: ' || SQLERRM);
END;

-- trigger delete
CREATE OR REPLACE TRIGGER trg_delete_itensvenda
AFTER DELETE ON Xitensvenda
FOR EACH ROW
BEGIN
    UPDATE acumproduto_at5
    SET qtde = qtde - :OLD.qtde
    WHERE codproduto = :OLD.codproduto;

    DELETE FROM acumproduto_at5
    WHERE codproduto = :OLD.codproduto
      AND qtde <= 0;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro na trigger trg_delete_itensvenda: ' || SQLERRM);
END;

-- verificando que não tem nada na tabela
SELECT * FROM acumproduto_at5;

-- inserindo nova venda na Xitensvenda, para adicionar na acumpagamento
INSERT INTO Xvenda (nnf, dtvenda, codcliente, codtppagamento, vlvenda)
VALUES (3, TO_DATE('2025-05-24', 'YYYY-MM-DD'), 1, 1, 6);

INSERT INTO Xitensvenda (nnf, dtvenda, codproduto, qtde)
VALUES (3, TO_DATE('2025-05-24', 'YYYY-MM-DD'), 1, 5);

SELECT * FROM acumproduto_at5;

-- update de uma venda existente
UPDATE Xitensvenda
SET qtde = 8
WHERE nnf = 3
  AND dtvenda = TO_DATE('2025-05-24', 'YYYY-MM-DD')
  AND codproduto = 1;

SELECT * FROM acumproduto_at5;

-- deletar a venda 
DELETE FROM Xitensvenda
WHERE nnf = 3
  AND dtvenda = TO_DATE('2025-05-24', 'YYYY-MM-DD')
  AND codproduto = 1;

SELECT * FROM acumproduto_at5;

DELETE FROM Xvenda
WHERE nnf = 3
  AND dtvenda = TO_DATE('2025-05-24', 'YYYY-MM-DD');

-- 3) Executar o comando para criar uma nova coluna na tabela de Xcliente. Criar uma procedure atualiza_sitcliente.
ALTER TABLE Xcliente ADD sitcliente VARCHAR2(1) NULL;

CREATE OR REPLACE PROCEDURE atualiza_sitcliente(p_data IN DATE) AS
BEGIN
    UPDATE Xcliente c
    SET c.sitcliente = 'I';

    UPDATE Xcliente c
    SET c.sitcliente = 'A'
    WHERE EXISTS (
        SELECT 1 
        FROM Xvenda v
        WHERE v.codcliente = c.codcliente
          AND v.dtvenda >= p_data
    );
END;

-- trigger insert
CREATE OR REPLACE TRIGGER trg_cliente_ativo
AFTER INSERT ON Xvenda
FOR EACH ROW
BEGIN
    UPDATE Xcliente
    SET sitcliente = 'A'
    WHERE codcliente = :NEW.codcliente;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao atualizar cliente para ativo: ' || SQLERRM);
END;

-- conferir a tabela ainda sem dados na nova coluna
SELECT * FROM Xcliente;

-- rodar a procedure a partir de uma data
BEGIN
    atualiza_sitcliente(TO_DATE('2002-04-25', 'YYYY-MM-DD'));
END;

SELECT * FROM Xcliente;

-- 4) Criar tabela de acumproduto2. Criar trigger’s de insert, update e delete da tabela de Xproduto com a finalidade de armazenar a quantidade de produtos de cada unidade na tabela de acumproduto2.
CREATE TABLE acumproduto2 (
    unidade     CHAR(2) NOT NULL,
    qtde        INT NOT NULL,
    CONSTRAINT pk_acumproduto2 PRIMARY KEY (unidade) );

-- trigger insert
CREATE OR REPLACE TRIGGER trg_insert_acumproduto2
AFTER INSERT ON Xproduto
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM acumproduto2
    WHERE unidade = :NEW.unidade;

    IF v_count > 0 THEN
        UPDATE acumproduto2
        SET qtde = qtde + 1
        WHERE unidade = :NEW.unidade;
    ELSE
        INSERT INTO acumproduto2 (unidade, qtde)
        VALUES (:NEW.unidade, 1);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro na trigger trg_insert_acumproduto2: ' || SQLERRM);
END;

-- trigger update
CREATE OR REPLACE TRIGGER trg_update_acumproduto2
AFTER UPDATE ON Xproduto
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    UPDATE acumproduto2
    SET qtde = qtde - 1
    WHERE unidade = :OLD.unidade;

    SELECT COUNT(*) INTO v_count
    FROM acumproduto2
    WHERE unidade = :NEW.unidade;

    IF v_count > 0 THEN
        UPDATE acumproduto2
        SET qtde = qtde + 1
        WHERE unidade = :NEW.unidade;
    ELSE
        INSERT INTO acumproduto2 (unidade, qtde)
        VALUES (:NEW.unidade, 1);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro na trigger trg_update_acumproduto2: ' || SQLERRM);
END;

-- trigger delete
CREATE OR REPLACE TRIGGER trg_delete_acumproduto2
AFTER DELETE ON Xproduto
FOR EACH ROW
BEGIN
    UPDATE acumproduto2
    SET qtde = qtde - 1
    WHERE unidade = :OLD.unidade;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro na trigger trg_delete_acumproduto2: ' || SQLERRM);
END;

-- verificando as tabelas:
SELECT * FROM Xproduto ORDER BY codproduto;
SELECT * FROM acumproduto2 ORDER BY unidade;

-- inserindo novo dado
INSERT INTO Xproduto (codproduto, descricaoproduto, unidade, preco)
VALUES (999, 'Produto Teste', 'UN', 10);

SELECT * FROM acumproduto2;

-- update
UPDATE Xproduto
SET unidade = 'KG'
WHERE codproduto = 999;

SELECT * FROM acumproduto2;

-- deletar produto
DELETE FROM Xproduto
WHERE codproduto = 999;

SELECT * FROM acumproduto2;