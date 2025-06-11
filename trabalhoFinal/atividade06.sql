

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