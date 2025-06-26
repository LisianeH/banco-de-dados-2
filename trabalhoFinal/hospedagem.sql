Banco de dados II

Alunos: Lisiane Hoffmeister e Lucca Mota Sindeaux
Professor: Rafael Gastão
Data: x/06/2025

Exercício 06 - PLSQL - HOSPEDAGEM

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

-- Tabela para Nomes
CREATE TABLE TABELA_NOMES (
    nome_pessoa VARCHAR2(50) PRIMARY KEY
);

begin
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
end;
SELECT * FROM TABELA_NOMES;

-- Tabela para Sobrenomes
CREATE TABLE TABELA_SOBRENOMES (
    sobrenome_pessoa VARCHAR2(50) PRIMARY KEY
);

begin
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
end;
SELECT * FROM TABELA_SOBRENOMES;

-- Tabela para Cidades
CREATE TABLE CIDADE (
    nome_cidade VARCHAR2(50) PRIMARY KEY
);

begin
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
end;
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
    P_INSERE_HOSPEDES( 8, 18, 65 );
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
    P_INSERE_ATENDENTES( 5 );
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





------------------------------------
-- Questão 2.3)

-- Forçando dados para verificar a questão
BEGIN
    INSERT INTO CIDADE (nome_cidade) VALUES ('Torres');
    INSERT INTO CIDADE (nome_cidade) VALUES ('Xangri-lá');
    INSERT INTO HOSPEDE (codHospede, nome, cidade, dataNascimento) VALUES (401, 'ALICE COSTA', 'Canoas', TO_DATE('1980-01-01', 'YYYY-MM-DD'));
    INSERT INTO HOSPEDE (codHospede, nome, cidade, dataNascimento) VALUES (402, 'BERNARDO DIAS', 'Gramado', TO_DATE('1975-02-02', 'YYYY-MM-DD'));
    INSERT INTO HOSPEDE (codHospede, nome, cidade, dataNascimento) VALUES (403, 'FABIO RECENTE', 'Xangri-lá', TO_DATE('1988-03-03', 'YYYY-MM-DD'));
    INSERT INTO HOSPEDE (codHospede, nome, cidade, dataNascimento) VALUES (404, 'FABIO ANTIGO', 'Torres', TO_DATE('1989-04-04', 'YYYY-MM-DD'));
    INSERT INTO HOSPEDE (codHospede, nome, cidade, dataNascimento) VALUES (405, 'RENATA GOMES', 'Rolante', TO_DATE('1991-05-05', 'YYYY-MM-DD'));
    
    -- Hospedagem para ALICE (401) em 2010. Soma = 1500 (Classe D)
    INSERT INTO HOSPEDAGEM (codHospedagem, codHospede, codAtendente, numQuarto, dataEntrada, dataSaida, valorDiaria) VALUES (201, 401, 2, 301, TO_DATE('2010-06-10', 'YYYY-MM-DD'), TO_DATE('2010-06-20', 'YYYY-MM-DD'), 150.00);
    
    -- Hospedagem para BERNARDO (402) em 2010. Soma = 8000 (Classe B)
    INSERT INTO HOSPEDAGEM (codHospedagem, codHospede, codAtendente, numQuarto, dataEntrada, dataSaida, valorDiaria) VALUES (202, 402, 3, 302, TO_DATE('2010-07-01', 'YYYY-MM-DD'), TO_DATE('2010-07-21', 'YYYY-MM-DD'), 400.00);
    
    -- Hospedagem para FABIO RECENTE (403) em 2010. Soma = 500 (Classe E)
    INSERT INTO HOSPEDAGEM (codHospedagem, codHospede, codAtendente, numQuarto, dataEntrada, dataSaida, valorDiaria) VALUES (203, 403, 2, 303, TO_DATE('2010-08-15', 'YYYY-MM-DD'), TO_DATE('2010-08-20', 'YYYY-MM-DD'), 100.00);
    -- ESTA É A HOSPEDAGEM RECENTE que faz o 'FABIO RECENTE' ser incluído na consulta.
    INSERT INTO HOSPEDAGEM (codHospedagem, codHospede, codAtendente, numQuarto, dataEntrada, dataSaida, valorDiaria) VALUES (204, 403, 2, 304, TRUNC(SYSDATE) - 10, TRUNC(SYSDATE) - 5, 999.00);
    
    -- Hospedagem para FABIO ANTIGO (404) em 2010.
    INSERT INTO HOSPEDAGEM (codHospedagem, codHospede, codAtendente, numQuarto, dataEntrada, dataSaida, valorDiaria) VALUES (205, 404, 3, 305, TO_DATE('2010-09-01', 'YYYY-MM-DD'), TO_DATE('2010-09-10', 'YYYY-MM-DD'), 50.00);
    
    -- Hospedagem para RENATA (405) em 2010. A cidade dela começa com 'R', então ela será filtrada.
    INSERT INTO HOSPEDAGEM (codHospedagem, codHospede, codAtendente, numQuarto, dataEntrada, dataSaida, valorDiaria) VALUES (206, 405, 2, 306, TO_DATE('2010-10-01', 'YYYY-MM-DD'), TO_DATE('2010-10-05', 'YYYY-MM-DD'), 200.00);
    
    -- Hospedagem fora de 2010 para um cliente válido, para garantir que o filtro de ano funcione.
    INSERT INTO HOSPEDAGEM (codHospedagem, codHospede, codAtendente, numQuarto, dataEntrada, dataSaida, valorDiaria) VALUES (207, 401, 2, 307, TO_DATE('2011-01-01', 'YYYY-MM-DD'), TO_DATE('2011-01-05', 'YYYY-MM-DD'), 1000.00);
END;

-- RESOLUÇÃO -> seleção em si
SELECT
    s.nome,
    s.soma_total,
    CASE
        WHEN s.soma_total BETWEEN 0 AND 1000      THEN 'E'
        WHEN s.soma_total BETWEEN 1000.01 AND 3000  THEN 'D'
        WHEN s.soma_total BETWEEN 3000.01 AND 7000  THEN 'C'
        WHEN s.soma_total BETWEEN 7000.01 AND 10000 THEN 'B'
        ELSE 'A'
    END AS Classe
FROM
    (
        SELECT
            H.codHospede,
            H.nome,
            H.cidade,
            SUM((HG.dataSaida - HG.dataEntrada + 1) * HG.valorDiaria) AS soma_total
        FROM
            HOSPEDAGEM HG
        JOIN
            HOSPEDE H ON HG.codHospede = H.codHospede
        WHERE
            EXTRACT(YEAR FROM HG.dataEntrada) = 2010 AND HG.dataSaida IS NOT NULL
        GROUP BY
            H.codHospede, H.nome, H.cidade
    ) s -- Alias
WHERE
    SUBSTR(s.cidade, 1, 1) BETWEEN 'A' AND 'M'
    OR
    (s.nome LIKE 'FABIO%' AND EXISTS (
        SELECT 1
        FROM HOSPEDAGEM hg_recent
        WHERE hg_recent.codHospede = s.codHospede
          AND hg_recent.dataSaida >= TRUNC(SYSDATE) - 30
    ))
ORDER BY
    Classe,
    s.nome;


-- Questão 2.4
SELECT
    cidade,
    soma_rentabilidade
FROM
    (
        SELECT
            cidade,
            SUM(valor_total_hospedagem) AS soma_rentabilidade,
            -- RANK() função pesquisada que cria o ranking
            RANK() OVER (ORDER BY SUM(valor_total_hospedagem) DESC) as ranking_cidade
        FROM
            (
                -- A função NVL para tratar as hospedagens em aberto.
                SELECT
                    H.cidade,
                    (NVL(HG.dataSaida, TRUNC(SYSDATE)) - HG.dataEntrada + 1) * HG.valorDiaria AS valor_total_hospedagem
                FROM
                    HOSPEDAGEM HG
                JOIN
                    HOSPEDE H ON HG.codHospede = H.codHospede
                WHERE
                    HG.dataEntrada >= ADD_MONTHS(TRUNC(SYSDATE), -3)
            ) hospedagens_sub -- Alias
        GROUP BY
            cidade
    ) rentabilidade_sub -- Alias
WHERE
    ranking_cidade <= 3
ORDER BY
    soma_rentabilidade DESC;


--Questão 2.5
SELECT
    A.nome AS nome_atendente,
    S.nome AS nome_superior,
    COUNT(HG.codHospedagem) AS quantidade_atendimentos
FROM
    ATENDENTE A
-- Self-join para buscar o nome do superior
JOIN
    ATENDENTE S ON A.codSuperior = S.codAtendente
-- Left Join para incluir todos os atendentes, mesmo sem hospedagens recentes
LEFT JOIN
    HOSPEDAGEM HG ON A.codAtendente = HG.codAtendente
                  AND HG.dataEntrada >= TRUNC(SYSDATE) - 30 
GROUP BY
    A.nome,
    S.nome
ORDER BY
    nome_atendente;