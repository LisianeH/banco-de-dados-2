

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
-- Questão 1.a)
CREATE OR REPLACE PROCEDURE P_INSERT_HOSPEDES (
    qtd_hospedes    IN INT,
    idade_min       IN INT,
    idade_max       IN INT
) AS
    nome_random              VARCHAR2( 100 );
    sobrenome_random         VARCHAR2( 50 );
    cidade_random            VARCHAR2( 50 );
    dataNascimento_random    DATE;

BEGIN
    -- Validação de faixa de idade
    IF idade_min < 18 OR idade_max > 65 OR idade_min >= idade_max THEN
        RAISE_APPLICATION_ERROR( -20001, 'Idades inválidas. Mínima é a partir de 18 anos, máxima é de 65 anos para reservas.' );
    END IF;

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
        
        dataNascimento_random := ADD_MONTHS( TRUNC( SYSDATE ), - ( TRUNC( DBMS_RANDOM.VALUE( idade_min, idade_max + 1 ) ) * 12 ) );
        
        INSERT INTO HOSPEDE ( nome, cidade, dataNascimento )
        VALUES ( nome_random, cidade_random, dataNascimento_random );
    END LOOP;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE( 'Erro na procedure P_INSERT_HOSPEDES: ' || SQLERRM );
END;

-- FUNCIONAL
BEGIN
    P_INSERT_HOSPEDES( 1, 18, 65 );
END;

-- VERIFICA A INSERÇÃO
SELECT * FROM HOSPEDE;

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
        DBMS_OUTPUT.PUT_LINE( 'Erro na procedure P_INSERT_ATENDENTES: ' || SQLERRM );
END;

-- FUNCIONAL
BEGIN
    P_INSERE_ATENDENTES( 4 );
END;

-- VERIFICA A INSERÇÃO
SELECT * FROM ATENDENTE;

-- LIMPA TABELA DE ATENDENTE
DELETE FROM ATENDENTE;