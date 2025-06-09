

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
CREATE OR REPLACE PROCEDURE PRC_INSERE_ATENDENTES (
    p_quantidade IN NUMBER
) AS
    -- 1. Declaração de um tipo "array de strings"
    TYPE t_lista_strings IS TABLE OF VARCHAR2(50);

    -- 2. Declaração das variáveis do tipo array, já inicializadas com os dados
    v_nomes t_lista_strings := t_lista_strings(
        'Yasmim', 'Roberto', 'Lisiane', 'Artur', 'Gustavo', 'Lorenzo', 'Murilo'
        'Lucca', 'Vitor', 'Thiago', 'Rafael', 'Yanni', 'Nico', 'Davi', 'William'
    );
    
    v_sobrenomes t_lista_strings := t_lista_strings(
        'Secondshirt', 'Camillo', 'Hoffmeister', 'Raguse', 'Muller', 'Pandolfo', 'Sena'
        'Sindeaux', 'Baldi', 'Kernel', 'Rafaellos', 'Dufech', 'Shadow', 'Rubim', 'Mestre'
    );

    -- Variáveis que continuam sendo usadas no processo
    v_nome_aleatorio      VARCHAR2(50);
    v_sobrenome_aleatorio VARCHAR2(50);
    v_nome_completo       VARCHAR2(100);
    v_cod_superior_geral  ATENDENTE.codAtendente%TYPE;

BEGIN
    -- Validação simples para evitar loops infinitos ou erros
    IF p_quantidade <= 0 THEN
        RETURN;
    END IF;

    -- *** INÍCIO DA MUDANÇA DE LÓGICA ***
    -- Gera o nome do superior geral pegando valores aleatórios dos arrays
    v_nome_aleatorio := v_nomes(TRUNC(DBMS_RANDOM.VALUE(1, v_nomes.COUNT + 1)));
    v_sobrenome_aleatorio := v_sobrenomes(TRUNC(DBMS_RANDOM.VALUE(1, v_sobrenomes.COUNT + 1)));
    v_nome_completo := v_nome_aleatorio || ' ' || v_sobrenome_aleatorio;
    -- *** FIM DA MUDANÇA DE LÓGICA ***

    -- A lógica para inserir o superior geral permanece a mesma, pois é a correta
    SELECT sequencia.NEXTVAL INTO v_cod_superior_geral FROM DUAL;
    INSERT INTO ATENDENTE (codAtendente, codSuperior, nome)
    VALUES (v_cod_superior_geral, v_cod_superior_geral, v_nome_completo);


    -- Loop para inserir os demais atendentes (do 2º até a quantidade desejada)
    FOR i IN 2..p_quantidade LOOP
        -- *** INÍCIO DA MUDANÇA DE LÓGICA ***
        -- Gera um nome aleatório para cada novo atendente
        v_nome_aleatorio := v_nomes(TRUNC(DBMS_RANDOM.VALUE(1, v_nomes.COUNT + 1)));
        v_sobrenome_aleatorio := v_sobrenomes(TRUNC(DBMS_RANDOM.VALUE(1, v_sobrenomes.COUNT + 1)));
        v_nome_completo := v_nome_aleatorio || ' ' || v_sobrenome_aleatorio;
        -- *** FIM DA MUDANÇA DE LÓGICA ***

        -- Insere o atendente, usando o código do superior geral
        INSERT INTO ATENDENTE (codSuperior, nome)
        VALUES (v_cod_superior_geral, v_nome_completo);
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE(p_quantidade || ' atendentes inseridos com sucesso.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir atendentes: ' || SQLERRM);
        -- É uma boa prática relançar o erro para que a aplicação que chamou a procedure saiba que algo deu errado
        RAISE;
END;
/

BEGIN
    PRC_INSERE_ATENDENTES(15); -- Ou qualquer outro número
END;