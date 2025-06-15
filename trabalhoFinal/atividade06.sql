

-- Cria a sequência
CREATE SEQUENCE sequencia START WITH 1 INCREMENT BY 1;

-- Cria a tabela e define o campo sequencial
CREATE TABLE HOSPEDE (
    codHospede INT DEFAULT sequencia.NEXTVAL NOT NULL,
    nome VARCHAR2(50),
    cidade VARCHAR2(50),
    dataNascimento DATE,
    PRIMARY KEY(codHospede));

CREATE TABLE ATENDENTE (
    codAtendente INT DEFAULT sequencia.NEXTVAL NOT NULL ,
    codSuperior INTEGER NOT NULL ,
    nome VARCHAR(50) ,
    PRIMARY KEY(codAtendente),
    FOREIGN KEY(codSuperior) REFERENCES ATENDENTE(codAtendente));

CREATE INDEX IFK_Rel_01 ON ATENDENTE (codSuperior); 

CREATE TABLE HOSPEDAGEM (
    codHospedagem INT DEFAULT sequencia.NEXTVAL NOT NULL ,
    codAtendente INTEGER NOT NULL,
    codHospede INTEGER NOT NULL ,
    dataEntrada DATE ,
    dataSaida DATE ,
    numQuarto INTEGER ,
    valorDiaria DECIMAL(9,2) ,
    PRIMARY KEY(codHospedagem),
    FOREIGN KEY(codHospede) REFERENCES HOSPEDE(codHospede),
    FOREIGN KEY(codAtendente) REFERENCES ATENDENTE(codAtendente));

CREATE INDEX IFK_Rel_02 ON HOSPEDAGEM (codHospede);

CREATE INDEX IFK_Rel_03 ON HOSPEDAGEM (codAtendente); 

------------------------------------
-- Tabela para Nomes
CREATE TABLE TABELA_NOMES (
    nome_pessoa VARCHAR2(50) PRIMARY KEY
);

INSERT INTO TABELA_NOMES (nome_pessoa) VALUES ('Yasmim');
INSERT INTO TABELA_NOMES (nome_pessoa) VALUES ('Roberto');
INSERT INTO TABELA_NOMES (nome_pessoa) VALUES ('Lisiane');
INSERT INTO TABELA_NOMES (nome_pessoa) VALUES ('Artur');
INSERT INTO TABELA_NOMES (nome_pessoa) VALUES ('Gustavo');
INSERT INTO TABELA_NOMES (nome_pessoa) VALUES ('Lorenzo');
INSERT INTO TABELA_NOMES (nome_pessoa) VALUES ('Murilo');
INSERT INTO TABELA_NOMES (nome_pessoa) VALUES ('Lucca');
INSERT INTO TABELA_NOMES (nome_pessoa) VALUES ('Vitor');
INSERT INTO TABELA_NOMES (nome_pessoa) VALUES ('Thiago');
INSERT INTO TABELA_NOMES (nome_pessoa) VALUES ('Rafael');
INSERT INTO TABELA_NOMES (nome_pessoa) VALUES ('Yanni');
INSERT INTO TABELA_NOMES (nome_pessoa) VALUES ('Nico');
INSERT INTO TABELA_NOMES (nome_pessoa) VALUES ('Davi');
INSERT INTO TABELA_NOMES (nome_pessoa) VALUES ('William');
INSERT INTO TABELA_NOMES (nome_pessoa) VALUES ('Ana');
INSERT INTO TABELA_NOMES (nome_pessoa) VALUES ('Carlos');
INSERT INTO TABELA_NOMES (nome_pessoa) VALUES ('Beatriz');
INSERT INTO TABELA_NOMES (nome_pessoa) VALUES ('Marcos');
INSERT INTO TABELA_NOMES (nome_pessoa) VALUES ('Pedro');
INSERT INTO TABELA_NOMES (nome_pessoa) VALUES ('Camila');
INSERT INTO TABELA_NOMES (nome_pessoa) VALUES ('Juliana');
INSERT INTO TABELA_NOMES (nome_pessoa) VALUES ('Fernanda');
INSERT INTO TABELA_NOMES (nome_pessoa) VALUES ('Gabriel');
-- no appex deve ser inserido um de cada vez...
SELECT * FROM TABELA_NOMES;

-- Tabela para Sobrenomes
CREATE TABLE TABELA_SOBRENOMES (
    sobrenome_pessoa VARCHAR2(50) PRIMARY KEY
);

INSERT INTO TABELA_SOBRENOMES (sobrenome_pessoa) VALUES ('Secondshirt');
INSERT INTO TABELA_SOBRENOMES (sobrenome_pessoa) VALUES ('Camillo');
INSERT INTO TABELA_SOBRENOMES (sobrenome_pessoa) VALUES ('Hoffmeister');
INSERT INTO TABELA_SOBRENOMES (sobrenome_pessoa) VALUES ('Raguse');
INSERT INTO TABELA_SOBRENOMES (sobrenome_pessoa) VALUES ('Muller');
INSERT INTO TABELA_SOBRENOMES (sobrenome_pessoa) VALUES ('Pandolfo');
INSERT INTO TABELA_SOBRENOMES (sobrenome_pessoa) VALUES ('Sena');
INSERT INTO TABELA_SOBRENOMES (sobrenome_pessoa) VALUES ('Sindeaux');
INSERT INTO TABELA_SOBRENOMES (sobrenome_pessoa) VALUES ('Baldi');
INSERT INTO TABELA_SOBRENOMES (sobrenome_pessoa) VALUES ('Kernel');
INSERT INTO TABELA_SOBRENOMES (sobrenome_pessoa) VALUES ('Rafaellos');
INSERT INTO TABELA_SOBRENOMES (sobrenome_pessoa) VALUES ('Dufech');
INSERT INTO TABELA_SOBRENOMES (sobrenome_pessoa) VALUES ('Shadow');
INSERT INTO TABELA_SOBRENOMES (sobrenome_pessoa) VALUES ('Rubim');
INSERT INTO TABELA_SOBRENOMES (sobrenome_pessoa) VALUES ('Mestre');
INSERT INTO TABELA_SOBRENOMES (sobrenome_pessoa) VALUES ('Silva');
INSERT INTO TABELA_SOBRENOMES (sobrenome_pessoa) VALUES ('Oliveira');
INSERT INTO TABELA_SOBRENOMES (sobrenome_pessoa) VALUES ('Pereira');
INSERT INTO TABELA_SOBRENOMES (sobrenome_pessoa) VALUES ('Ferreira');
INSERT INTO TABELA_SOBRENOMES (sobrenome_pessoa) VALUES ('Almeida');
INSERT INTO TABELA_SOBRENOMES (sobrenome_pessoa) VALUES ('Gomes');
INSERT INTO TABELA_SOBRENOMES (sobrenome_pessoa) VALUES ('Ribeiro');
INSERT INTO TABELA_SOBRENOMES (sobrenome_pessoa) VALUES ('Martins');
INSERT INTO TABELA_SOBRENOMES (sobrenome_pessoa) VALUES ('Barbosa');
-- no appex deve ser inserido um de cada vez...
SELECT * FROM TABELA_SOBRENOMES;

-- Tabela para Cidades
CREATE TABLE CIDADE (
    nome_cidade VARCHAR2(50) PRIMARY KEY
);

INSERT INTO CIDADE (nome_cidade) VALUES ('Porto Alegre');
INSERT INTO CIDADE (nome_cidade) VALUES ('Canoas');
INSERT INTO CIDADE (nome_cidade) VALUES ('Gravataí');
INSERT INTO CIDADE (nome_cidade) VALUES ('Sapucaia');
INSERT INTO CIDADE (nome_cidade) VALUES ('Novo Hamburgo');
INSERT INTO CIDADE (nome_cidade) VALUES ('Gramado');
INSERT INTO CIDADE (nome_cidade) VALUES ('Canela');
INSERT INTO CIDADE (nome_cidade) VALUES ('Rolante');
INSERT INTO CIDADE (nome_cidade) VALUES ('Dois Irmãos');
INSERT INTO CIDADE (nome_cidade) VALUES ('Ivoti');
-- no appex deve ser inserido um de cada vez...
SELECT * FROM CIDADE;

------------------------------------
-- Questão 1.a)
CREATE OR REPLACE PROCEDURE P_INSERE_HOSPEDES (
    qtd_hospedes    IN INT,
    idade_min       IN INT,
    idade_max       IN INT
) AS
    nome_random              VARCHAR2( 100 );
    sobrenome_random         VARCHAR2( 50 );
    cidade_random            VARCHAR2( 50 );
    dataNascimento_random    DATE;

    v_data_nascimento_mais_antiga   DATE;
    v_data_nascimento_mais_recente  DATE;
    v_dias_no_intervalo             INT;

BEGIN
    -- Validação de faixa de idade
    IF idade_min < 18 OR idade_max > 65 OR idade_min >= idade_max THEN
        RAISE_APPLICATION_ERROR( -20001, 'Idades inválidas. Mínima é a partir de 18 anos, máxima é de 65 anos para reservas.' );
    END IF;

    -- Data nascimento
    v_data_nascimento_mais_antiga := TRUNC( ADD_MONTHS( SYSDATE, -( idade_max * 12 + 12 ) ) ) + 1;
    v_data_nascimento_mais_recente := TRUNC( ADD_MONTHS( SYSDATE, -( idade_min * 12 ) ) );
    v_dias_no_intervalo := TRUNC( v_data_nascimento_mais_recente - v_data_nascimento_mais_antiga );

    FOR i IN 1..qtd_hospedes LOOP
        SELECT nome_pessoa INTO nome_random
        FROM TABELA_NOMES
        ORDER BY DBMS_RANDOM.VALUE
        FETCH FIRST 1 ROW ONLY;

        SELECT sobrenome_pessoa INTO sobrenome_random
        FROM TABELA_SOBRENOMES
        ORDER BY DBMS_RANDOM.VALUE
        FETCH FIRST 1 ROW ONLY;

        SELECT nome_cidade INTO cidade_random
        FROM CIDADE
        ORDER BY DBMS_RANDOM.VALUE
        FETCH FIRST 1 ROW ONLY;

        nome_random := nome_random || ' ' || sobrenome_random;
        
        dataNascimento_random := v_data_nascimento_mais_antiga + TRUNC( DBMS_RANDOM.VALUE( 0, v_dias_no_intervalo + 1 ) );
        
        INSERT INTO HOSPEDE ( nome, cidade, dataNascimento )
        VALUES ( nome_random, cidade_random, dataNascimento_random );
    END LOOP;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE( 'Erro na procedure P_INSERE_HOSPEDES: ' || SQLERRM );
END;

-- FUNCIONAL
BEGIN
    P_INSERE_HOSPEDES( 1, 18, 65 );
END;

-- VERIFICA A INSERÇÃO
SELECT * FROM HOSPEDE;

-- LIMPA TABELA HOSPEDE
DELETE FROM HOSPEDE;

------------------------------------
-- Questão 1.b)
CREATE OR REPLACE PROCEDURE P_INSERE_ATENDENTES (
    qtd_atendentes IN INT
) AS
    nome_random              VARCHAR2( 100 );
    sobrenome_random         VARCHAR2( 50 );

    cod_atendente_superior_fixo NUMBER;
BEGIN
    IF qtd_atendentes <= 0 THEN
        RAISE_APPLICATION_ERROR( -20001, 'A quantidade de atendentes a ser gerada deve ser maior que zero.' );
    END IF;

    -- Insere o primeiro atendente
    SELECT nome_pessoa INTO nome_random
    FROM TABELA_NOMES
    ORDER BY DBMS_RANDOM.VALUE
    FETCH FIRST 1 ROW ONLY;

    SELECT sobrenome_pessoa INTO sobrenome_random
    FROM TABELA_SOBRENOMES
    ORDER BY DBMS_RANDOM.VALUE
    FETCH FIRST 1 ROW ONLY;

    nome_random := nome_random || ' ' || sobrenome_random;

    -- Faz a sequencia do código do superior
    SELECT sequencia.NEXTVAL INTO cod_atendente_superior_fixo FROM DUAL;

    INSERT INTO ATENDENTE ( codAtendente, codSuperior, nome )
    VALUES ( cod_atendente_superior_fixo, cod_atendente_superior_fixo, nome_random );

    FOR i IN 2..qtd_atendentes LOOP
        SELECT nome_pessoa INTO nome_random
        FROM TABELA_NOMES
        ORDER BY DBMS_RANDOM.VALUE
        FETCH FIRST 1 ROW ONLY;

        SELECT sobrenome_pessoa INTO sobrenome_random
        FROM TABELA_SOBRENOMES
        ORDER BY DBMS_RANDOM.VALUE
        FETCH FIRST 1 ROW ONLY;

        nome_random := nome_random || ' ' || sobrenome_random;

        INSERT INTO ATENDENTE ( codSuperior, nome )
        VALUES ( cod_atendente_superior_fixo, nome_random ); 
    END LOOP;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE( 'Erro na procedure P_INSERE_ATENDENTES: ' || SQLERRM );
END;

-- FUNCIONAL
BEGIN
    P_INSERE_ATENDENTES( 4 );
END;

-- VERIFICA A INSERÇÃO
SELECT * FROM ATENDENTE;

-- LIMPA TABELA DE ATENDENTE
DELETE FROM ATENDENTE;

------------------------------------
-- Questão 1.c)
CREATE OR REPLACE PROCEDURE P_INSERE_HOSPEDAGEM (
    qtd_hospedagens     IN INT,
    data_inicio         IN DATE,
    data_fim            IN DATE
) AS
    v_codHospede      HOSPEDE.codHospede%TYPE;
    v_codAtendente    ATENDENTE.codAtendente%TYPE;
    
    v_dataEntrada     DATE;
    v_dataSaida       DATE;
    v_numQuarto       HOSPEDAGEM.numQuarto%TYPE;
    v_valorDiaria     HOSPEDAGEM.valorDiaria%TYPE;
    
    v_codHospedagem_existente HOSPEDAGEM.codHospedagem%TYPE;
    v_dataEntrada_existente   HOSPEDAGEM.dataEntrada%TYPE;
    
    -- Para faciliar vamos deixar como variaveis a quantidade de quartos e valor da diária;
    qtd_min_quarto      CONSTANT INT := 1;
    qtd_max_quarto      CONSTANT INT := 100;
    
    min_valor_diaria    CONSTANT DECIMAL( 9,2 ) := 100.00;
    max_valor_diaria    CONSTANT DECIMAL( 9,2 ) := 300.00;
BEGIN
    IF qtd_hospedagens <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'A quantidade de hospedagens a ser gerada deve ser maior que zero.');
    END IF;

    IF data_inicio IS NULL OR data_fim IS NULL THEN
        RAISE_APPLICATION_ERROR(-20002, 'As datas de início e fim do intervalo não podem ser nulas.');
    END IF;

    IF data_inicio > data_fim THEN
        RAISE_APPLICATION_ERROR(-20003, 'A data de início do intervalo deve ser menor que a data de fim.');
    END IF;

    FOR i IN 1..qtd_hospedagens LOOP
        SELECT codHospede INTO v_codHospede
        FROM HOSPEDE
        ORDER BY DBMS_RANDOM.VALUE
        FETCH FIRST 1 ROW ONLY;

        SELECT codAtendente INTO v_codAtendente
        FROM ATENDENTE
        ORDER BY DBMS_RANDOM.VALUE
        FETCH FIRST 1 ROW ONLY;

        v_dataEntrada := TRUNC( data_inicio + DBMS_RANDOM.VALUE( 0, TRUNC( data_fim ) - TRUNC( data_inicio ) + 1 ) );
        
        v_numQuarto := TRUNC( DBMS_RANDOM.VALUE( qtd_min_quarto, qtd_max_quarto + 1 ) );
        
        v_valorDiaria := ROUND( DBMS_RANDOM.VALUE( min_valor_diaria, max_valor_diaria ), 2 );
        
        BEGIN
            SELECT codHospedagem, dataEntrada INTO v_codHospedagem_existente, v_dataEntrada_existente
            FROM HOSPEDAGEM
            WHERE numQuarto = v_numQuarto AND dataSaida IS NULL
            ORDER BY dataEntrada DESC
            FETCH FIRST 1 ROW ONLY;

            UPDATE HOSPEDAGEM
            SET dataSaida = v_dataEntrada - 1
            WHERE codHospedagem = v_codHospedagem_existente;
            
            IF v_dataEntrada - 1 < v_dataEntrada_existente THEN
                UPDATE HOSPEDAGEM
                SET dataSaida = v_dataEntrada_existente
                WHERE codHospedagem = v_codHospedagem_existente;
            END IF;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;

        IF DBMS_RANDOM.VALUE < 0.80 THEN 
            v_dataSaida := v_dataEntrada + TRUNC( DBMS_RANDOM.VALUE( 1, 4 ) ); 
        ELSE
            v_dataSaida := NULL;
        END IF;

        INSERT INTO HOSPEDAGEM (codAtendente, codHospede, dataEntrada, dataSaida, numQuarto, valorDiaria)
        VALUES (v_codAtendente, v_codHospede, v_dataEntrada, v_dataSaida, v_numQuarto, v_valorDiaria);
        
    END LOOP;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE( 'Erro na procedure P_INSERE_HOSPEDAGEM: ' || SQLERRM );
END;

-- FUNCIONAL
BEGIN
    P_INSERE_HOSPEDAGEM(
        10,
        TO_DATE( '01/06/2024', 'DD/MM/YYYY' ),
        TO_DATE( '30/06/2024', 'DD/MM/YYYY' )
    );
END;

-- VERIFICA A INSERÇÃO
SELECT * FROM HOSPEDAGEM;

-- LIMPA TABELA DE HOSPEDAGEM
DELETE FROM HOSPEDAGEM;

------------------------------------
-- Questão 2.1)
SELECT
    H.nome AS nome_hospede,
    A.nome AS nome_atendente,
    HG.numQuarto,
    ( HG.dataSaida - HG.dataEntrada + 1 ) * HG.valorDiaria AS valor_total_hospedagem
FROM
    HOSPEDAGEM HG
JOIN
    HOSPEDE H ON HG.codHospede = H.codHospede
JOIN
    ATENDENTE A ON HG.codAtendente = A.codAtendente
WHERE
    HG.dataSaida IS NOT NULL 
    AND TRUNC(MONTHS_BETWEEN( HG.dataEntrada, H.dataNascimento ) / 12 ) = 21
    AND HG.dataEntrada IN (
        SELECT DISTINCT HG_SUB.dataEntrada
        FROM HOSPEDAGEM HG_SUB
        JOIN HOSPEDE H_SUB ON HG_SUB.codHospede = H_SUB.codHospede
        WHERE
            TRUNC( MONTHS_BETWEEN( HG_SUB.dataEntrada, H_SUB.dataNascimento ) / 12 ) BETWEEN 40 AND 45
    )
ORDER BY
    valor_total_hospedagem DESC, 
    nome_hospede ASC
FETCH FIRST 10 ROWS ONLY;

-- Para ter dados testando a consulta
INSERT INTO ATENDENTE ( codAtendente, codSuperior, nome )
VALUES ( 1, 1, 'Carlos Santos' );

INSERT INTO HOSPEDE (codHospede, nome, cidade, dataNascimento)
VALUES ( 10, 'Joao da Silva', 'Porto Alegre', TO_DATE( '10/05/2004', 'DD/MM/YYYY' ) );

INSERT INTO HOSPEDE (codHospede, nome, cidade, dataNascimento)
VALUES ( 20, 'Maria Souza', 'Canoas', TO_DATE( '10/05/1981', 'DD/MM/YYYY') );

INSERT INTO HOSPEDAGEM ( codHospedagem, codAtendente, codHospede, dataEntrada, dataSaida, numQuarto, valorDiaria )
VALUES ( 1, 1, 10, TO_DATE( '10/05/2025', 'DD/MM/YYYY' ), TO_DATE( '12/05/2025', 'DD/MM/YYYY' ), 5, 250.00 );

INSERT INTO HOSPEDAGEM ( codHospedagem, codAtendente, codHospede, dataEntrada, dataSaida, numQuarto, valorDiaria )
VALUES ( 2, 1, 20, TO_DATE('10/05/2025', 'DD/MM/YYYY'), TO_DATE('11/05/2025', 'DD/MM/YYYY'), 15, 300.00 );

------------------------------------
-- Questão 2.2)
SELECT
    TO_CHAR( HG.dataSaida, 'YYYY/MM' ) AS mes_ano_saida,
    UPPER( S.nome ) AS nome_superior_atendente,
    SUM( ( HG.dataSaida - HG.dataEntrada + 1 ) * HG.valorDiaria ) AS soma_valor_diarias
FROM
    HOSPEDAGEM HG
JOIN
    ATENDENTE A ON HG.codAtendente = A.codAtendente
JOIN
    ATENDENTE S ON A.codSuperior = S.codAtendente
WHERE
    HG.dataSaida IS NOT NULL 
    AND NOT ( TO_CHAR( HG.dataSaida, 'YYYY/MM' ) BETWEEN '2011/06' AND '2011/07' )
GROUP BY
    TO_CHAR( HG.dataSaida, 'YYYY/MM' ),
    UPPER( S.nome )
HAVING
    SUM( ( HG.dataSaida - HG.dataEntrada + 1 ) * HG.valorDiaria ) > (
        SELECT AVG( ( HG_SUB.dataSaida - HG_SUB.dataEntrada + 1 ) * HG_SUB.valorDiaria )
        FROM HOSPEDAGEM HG_SUB
        WHERE HG_SUB.dataSaida BETWEEN TRUNC( SYSDATE ) - 10 AND TRUNC( SYSDATE )
            AND HG_SUB.dataSaida IS NOT NULL
    )
ORDER BY
    mes_ano_saida ASC;

-- Para ter dados testando a consulta
INSERT INTO ATENDENTE ( codAtendente, codSuperior, nome )
VALUES ( 2, 1, 'Ana Oliveira' );

INSERT INTO ATENDENTE ( codAtendente, codSuperior, nome )
VALUES ( 3, 1, 'Pedro Ferreira' );

INSERT INTO HOSPEDE ( codHospede, nome, cidade, dataNascimento )
VALUES (30, 'Fernando Costa', 'Sao Paulo', TO_DATE( '01/01/1995', 'DD/MM/YYYY' ) );

INSERT INTO HOSPEDAGEM ( codHospedagem, codAtendente, codHospede, dataEntrada, dataSaida, numQuarto, valorDiaria )
VALUES ( 100, 1, 10, TO_DATE( '10/05/2025', 'DD/MM/YYYY' ), TO_DATE( '12/05/2025', 'DD/MM/YYYY' ), 5, 250.00 );

INSERT INTO HOSPEDAGEM ( codHospedagem, codAtendente, codHospede, dataEntrada, dataSaida, numQuarto, valorDiaria )
VALUES (101, 1, 20, TO_DATE( '10/05/2025', 'DD/MM/YYYY'), TO_DATE( '11/05/2025', 'DD/MM/YYYY' ), 15, 300.00 );

INSERT INTO HOSPEDAGEM ( codHospedagem, codAtendente, codHospede, dataEntrada, dataSaida, numQuarto, valorDiaria )
VALUES ( 102, 2, 30, TO_DATE( '08/06/2025', 'DD/MM/YYYY'), TO_DATE('10/06/2025', 'DD/MM/YYYY'), 25, 180.00 );

INSERT INTO HOSPEDAGEM ( codHospedagem, codAtendente, codHospede, dataEntrada, dataSaida, numQuarto, valorDiaria )
VALUES ( 103, 3, 10, TO_DATE( '12/06/2025', 'DD/MM/YYYY' ), TO_DATE( '14/06/2025', 'DD/MM/YYYY' ), 30, 200.00 );

INSERT INTO HOSPEDAGEM ( codHospedagem, codAtendente, codHospede, dataEntrada, dataSaida, numQuarto, valorDiaria )
VALUES ( 104, 1, 20, TO_DATE( '01/06/2011', 'DD/MM/YYYY' ), TO_DATE( '05/06/2011', 'DD/MM/YYYY' ), 40, 150.00 ); 

INSERT INTO HOSPEDAGEM ( codHospedagem, codAtendente, codHospede, dataEntrada, dataSaida, numQuarto, valorDiaria )
VALUES ( 105, 2, 10, TO_DATE( '03/06/2025', 'DD/MM/YYYY' ), TO_DATE( '05/06/2025', 'DD/MM/YYYY' ), 45, 220.00 );
