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

