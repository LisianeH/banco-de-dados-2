

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
CREATE OR REPLACE PROCEDURE P_INSERT_HOSPEDES (
    qtd_hospedes    IN INT,
    idade_min       IN INT,
    idade_max       IN INT
) AS
    v_nome              VARCHAR2( 50 );
    v_cidade            VARCHAR2( 50 );
    v_dataNascimento    DATE;
BEGIN
    -- Validação de faixa de idade
    IF idade_min < 18 OR idade_max > 65 OR idade_min >= idade_max THEN
        RAISE_APPLICATION_ERROR( -20001, 'Idades inválidas. Mínima é a partir de 18 anos, máxima é de 65 anos para reservas.' );
    END IF;

    -- Dados na variavel
    v_nomes( 'Ana', 'Carlos', 'Beatriz', 'Marcos', 'Lisiane', 'Pedro', 'Camila', 'Lucca', 'Juliana', 'Rafael', 'Fernanda', 'Gabriel' );
    v__sobrenomes( 'Silva', 'Oliveira', 'Hoffmeister', 'Pereira', 'Ferreira', 'Almeida', 'Sindeaux', 'Gomes', 'Ribeiro', 'Martins', 'Barbosa' );
    v_cidades( 'Porto Alegre', 'Canoas', 'Gravataí', 'Sapucaia', 'Novo Hamburgo', 'Gramado', 'Canela', 'Rolante', 'Dois Irmãos', 'Ivoti' );
    v_datasNascimentos( '01/01/2000', '02/02/2002', '03/03/2003', '04/04/2004', '05/05/2005', '06/06/2006', '07/07/2007', '08/08/2008', '09/09/1999', '10/10/1990', '11/11/1980', '12/12/1970' );

    FOR i IN 1..qtd_hospedes LOOP
        nome_random := v_nomes( TRUNC( DBMS_RANDOM.VALUE( 1, v_nomes.COUNT + 1) ) ) || ' ' || v__sobrenomes( TRUNC( DBMS_RANDOM.VALUE( 1, v__sobrenomes.COUNT + 1) ) );
        cidade_random := v_cidades( TRUNC( DBMS_RANDOM.VALUE( 1, v_cidades.COUNT + 1) ) );
        dataNascimento_random := v_datasNascimentos( TRUNC( DBMS_RANDOM.VALUE( 1, v_datasNascimentos.COUNT + 1) ) );

        -- Inserindo na tabela
        INSERT INTO HOSPEDE ( nome, cidade, dataNascimento )
        VALUES ( nome_random, cidade_random, dataNascimento_random );
    END LOOP;


END;

-- FUNCIONAL
BEGIN
    P_INSERT_HOSPEDES( 1, 18, 65 );
END;



-- 1b) Escrever procedimento para inserir registros na tabela ATENDENTE
-- -> Receber por parâmetro a quantidade de atendentes que deverão ser gerados - Fixar
-- que o atendente 1 é superior de todos os demais

-- DICAS para as questões a e b:
-- • As cidades deverão ser obtidas aleatoriamente de uma tabela CIDADE.
-- • Para compor o nome do hospede, montar aleatoriamente NOME + SOBRENOME,
-- buscando de duas tabelas as quais se tenham nomes e sobrenomes. 

-- Criação das tabelas com nomes e sobrenomes aleatórios, inserção dos dados logo em seguida
CREATE TABLE NOMES (
    id_nome INT PRIMARY KEY,
    nome VARCHAR2(50)
);

CREATE TABLE SOBRENOMES (
    id_sobrenome INT PRIMARY KEY,
    sobrenome VARCHAR2(50)
);

begin
    INSERT INTO NOMES (id_nome, nome) VALUES (1, 'Ana');
    INSERT INTO NOMES (id_nome, nome) VALUES (2, 'Bruno');
    INSERT INTO NOMES (id_nome, nome) VALUES (3, 'Carlos');
    INSERT INTO NOMES (id_nome, nome) VALUES (4, 'Daniela');
    INSERT INTO NOMES (id_nome, nome) VALUES (5, 'Eduardo');
    INSERT INTO NOMES (id_nome, nome) VALUES (6, 'Lisiane');
    INSERT INTO NOMES (id_nome, nome) VALUES (7, 'Butiá');
    INSERT INTO NOMES (id_nome, nome) VALUES (8, 'Lorenzo');
END;

begin
    INSERT INTO SOBRENOMES (id_sobrenome, sobrenome) VALUES (1, 'Silva');
    INSERT INTO SOBRENOMES (id_sobrenome, sobrenome) VALUES (2, 'Santos');
    INSERT INTO SOBRENOMES (id_sobrenome, sobrenome) VALUES (3, 'Oliveira');
    INSERT INTO SOBRENOMES (id_sobrenome, sobrenome) VALUES (4, 'Pereira');
    INSERT INTO SOBRENOMES (id_sobrenome, sobrenome) VALUES (5, 'Costa');
    INSERT INTO SOBRENOMES (id_sobrenome, sobrenome) VALUES (6, 'Hoffmeister');
    INSERT INTO SOBRENOMES (id_sobrenome, sobrenome) VALUES (7, 'Raguse');
    INSERT INTO SOBRENOMES (id_sobrenome, sobrenome) VALUES (8, 'Pandolfo');
END;

-- Mesma lógica, mas com cidades
CREATE TABLE CIDADE (
    id_cidade INT PRIMARY KEY,
    nome_cidade VARCHAR2(100)
);

-- Inserindo algumas cidades de exemplo
begin
    INSERT INTO CIDADE (id_cidade, nome_cidade) VALUES (1, 'Porto Alegre');
    INSERT INTO CIDADE (id_cidade, nome_cidade) VALUES (2, 'Canoas');
    INSERT INTO CIDADE (id_cidade, nome_cidade) VALUES (3, 'Viamão');
end;


begin
    INSERT INTO NOMES (id_nome, nome) VALUES (1, 'Lucca');
    INSERT INTO NOMES (id_nome, nome) VALUES (2, 'Lisiane');
    INSERT INTO NOMES (id_nome, nome) VALUES (3, 'Butiá');
    INSERT INTO NOMES (id_nome, nome) VALUES (4, 'Gustavo');
    INSERT INTO NOMES (id_nome, nome) VALUES (5, 'Lorenzo');
    INSERT INTO NOMES (id_nome, nome) VALUES (6, 'Murilo');
    INSERT INTO NOMES (id_nome, nome) VALUES (7, 'Yasmin');
    INSERT INTO NOMES (id_nome, nome) VALUES (8, 'Thiago');
    INSERT INTO NOMES (id_nome, nome) VALUES (9, 'Vitor');
    INSERT INTO NOMES (id_nome, nome) VALUES (10, 'Rafael');
    INSERT INTO NOMES (id_nome, nome) VALUES (11, 'Yanni');
    INSERT INTO NOMES (id_nome, nome) VALUES (12, 'Wylliam');
    INSERT INTO NOMES (id_nome, nome) VALUES (13, 'Nico');
    INSERT INTO NOMES (id_nome, nome) VALUES (14, 'Davi');
    INSERT INTO NOMES (id_nome, nome) VALUES (15, 'Robierto');
END;

begin
    INSERT INTO SOBRENOMES (id_sobrenome, sobrenome) VALUES (1, 'Mota');
    INSERT INTO SOBRENOMES (id_sobrenome, sobrenome) VALUES (2, 'Hoffmeister');
    INSERT INTO SOBRENOMES (id_sobrenome, sobrenome) VALUES (3, 'Raguse');
    INSERT INTO SOBRENOMES (id_sobrenome, sobrenome) VALUES (4, 'Muller');
    INSERT INTO SOBRENOMES (id_sobrenome, sobrenome) VALUES (5, 'Pandolfo');
    INSERT INTO SOBRENOMES (id_sobrenome, sobrenome) VALUES (6, 'Sena');
    INSERT INTO SOBRENOMES (id_sobrenome, sobrenome) VALUES (7, 'Secondshirt');
    INSERT INTO SOBRENOMES (id_sobrenome, sobrenome) VALUES (8, 'Kernel');
    INSERT INTO SOBRENOMES (id_sobrenome, sobrenome) VALUES (9, 'Baldi');
    INSERT INTO SOBRENOMES (id_sobrenome, sobrenome) VALUES (10, 'Rafaellos');
    INSERT INTO SOBRENOMES (id_sobrenome, sobrenome) VALUES (11, 'Dufech');
    INSERT INTO SOBRENOMES (id_sobrenome, sobrenome) VALUES (12, 'Mestre');
    INSERT INTO SOBRENOMES (id_sobrenome, sobrenome) VALUES (13, 'Shadow');
    INSERT INTO SOBRENOMES (id_sobrenome, sobrenome) VALUES (14, 'Rubim');
    INSERT INTO SOBRENOMES (id_sobrenome, sobrenome) VALUES (15, 'Camilo');
END;

-- Mesma lógica, mas com cidades
CREATE TABLE CIDADE (
    id_cidade INT PRIMARY KEY,
    nome_cidade VARCHAR2(100)
);

begin
    INSERT INTO CIDADE (id_cidade, nome_cidade) VALUES (1, 'Porto Alegre');
    INSERT INTO CIDADE (id_cidade, nome_cidade) VALUES (2, 'Canoas');
    INSERT INTO CIDADE (id_cidade, nome_cidade) VALUES (3, 'Viamão');
end;


CREATE OR REPLACE PROCEDURE PRC_INSERE_ATENDENTES (
    p_quantidade IN NUMBER
) as
    v_nome_aleatorio VARCHAR2(50);
    v_sobrenome_aleatorio VARCHAR2(50);
    v_nome_completo VARCHAR2(100);
    v_cod_superior_geral ATENDENTE.codAtendente%TYPE;
begin
    SELECT nome into v_nome_aleatorio FROM (SELECT nome FROM NOMES ORDER BY DBMS_RANDOM.VALUE) WHERE ROWNUM = 1;
    SELECT sobrenome into v_sobrenome_aleatorio FROM (SELECT sobrenome FROM SOBRENOMES ORDER BY DBMS_RANDOM.VALUE) WHERE ROWNUM = 1;
    v_nome_completo := v_nome_aleatorio || ' ' || v_sobrenome_aleatorio;

    -- Pega o próximo ID da sequence e armazena na variável.
    SELECT sequencia.NEXTVAL INTO v_cod_superior_geral FROM DUAL;

    -- Insere o superior geral, informando explicitamente o seu codAtendente e codSuperior com o mesmo valor.
    INSERT INTO ATENDENTE (codAtendente, codSuperior, nome)
    VALUES (v_cod_superior_geral, v_cod_superior_geral, v_nome_completo);

    FOR i in 2..p_quantidade LOOP
        SELECT nome into v_nome_aleatorio FROM (SELECT nome FROM NOMES ORDER BY DBMS_RANDOM.VALUE) WHERE ROWNUM = 1;
        SELECT sobrenome into v_sobrenome_aleatorio FROM (SELECT sobrenome FROM SOBRENOMES ORDER BY DBMS_RANDOM.VALUE) WHERE ROWNUM = 1;
        v_nome_completo := v_nome_aleatorio || ' ' || v_sobrenome_aleatorio;

        INSERT into ATENDENTE (codSuperior, nome)
        VALUES (v_cod_superior_geral, v_nome_completo);
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE(p_quantidade || ' atendentes inseridos com sucesso.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir atendentes: ' || SQLERRM);
END PRC_INSERE_ATENDENTES;

begin
    PRC_INSERE_ATENDENTES(15);
END;

SELECT * from atendente