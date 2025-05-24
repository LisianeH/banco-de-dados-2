create or replace procedure PrcTesteCursor_WHILE is
--Declarando as variáveis que serão manipuladas
vCod_cli varchar2(10);
vNome varchar2(40);
vID int := 1;
--Criando o cursor que fará um select na tabela de clientes...
cursor cC1 is
SELECT cod_cli, nome FROM CLIENTE ORDER BY cod_cli;
begin
dbms_output.put_line('*****EXEMPLO DE LAÇO USANDO WHILE LOOP- END
LOOP*****');
--Exemplo de Laço do tipo WHILE LOOP - END LOOP
--Abrindo o cursor
open cC1;
-- 1-) Instrução de início do loop
--Este loop será executado enquanto a variável vID for menor que 3
WHILE vID <= 3 LOOP
dbms_output.put_line('********************************************************');
--2-) Atribuindo o retorno da consulta, às variáveis
fetch cC1
into vCod_cli, vNome;
--3-) Escrevendo o valor das variáveis somente...
dbms_output.put_line('ID: ' || vCod_cli);
dbms_output.put_line('Nome: ' || vNome);
 vID:= vID + 1;
--4-) instrução para finalizar o loop
end loop;
--5-)Fechando o cursor para disponibilizar os recursos que estavam sendo utilizados
close cC1;
end ;

--- Testando
begin
PrcTesteCursor_WHILE;
end;

-- Para Executar:
-- Procedure prctestecursor_while:
begin
 -- Chamando a procedure
prctestecursor_while;
end;

------------------------------
CREATE OR REPLACE PROCEDURE criar_e_usar_tabela_temp AS
 -- Variável para armazenar o comando SQL de criação
 v_sql_create VARCHAR2(4000);
 -- Variável para armazenar o comando SQL de inserção
 v_sql_insert VARCHAR2(4000);
 vcodcli varchar(10);
 vnome varchar(40);
BEGIN
 -- Criando a tabela temporária dinamicamente
 v_sql_create := '
 CREATE GLOBAL TEMPORARY TABLE TMP_CLIENTE (COD_CLI VARCHAR2(10), NOME VARCHAR2(40))';
 EXECUTE IMMEDIATE v_sql_create;
 -- Inserindo dados na tabela temporária usando SELECT com WHERE
 v_sql_insert := '
 INSERT INTO TMP_CLIENTE (cod_cli, nome)
 SELECT cod_cli, nome FROM cliente WHERE cod_cli = ''c1''
 ';
 EXECUTE IMMEDIATE v_sql_insert;
 -- Opcional: limpar a tabela ao final (não obrigatório se ON COMMIT DELETE ROWS)
 EXECUTE IMMEDIATE 'DROP TABLE TMP_CLIENTE';
EXCEPTION
 WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
END;

-----------------------------------
CREATE GLOBAL TEMPORARY TABLE TMP_CLIENTE (
    COD_CLI VARCHAR2(10),
    NOME VARCHAR2(40)
) ON COMMIT DELETE ROWS;

CREATE OR REPLACE PROCEDURE listar_cliente_usar_tabela_temp AS
    v_sql_insert VARCHAR2(4000);
    vcodcli VARCHAR2(10);
    vnome   VARCHAR2(40);

    CURSOR cC1 IS
        SELECT cod_cli, nome FROM TMP_CLIENTE ORDER BY cod_cli;

BEGIN
    v_sql_insert := '
        INSERT INTO TMP_CLIENTE (cod_cli, nome)
        SELECT cod_cli, nome FROM cliente ';
    EXECUTE IMMEDIATE v_sql_insert;

    OPEN cC1;
    LOOP
        FETCH cC1 INTO vcodcli, vnome;
        EXIT WHEN cC1%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('**********');
        DBMS_OUTPUT.PUT_LINE('ID: ' || vcodcli);
        DBMS_OUTPUT.PUT_LINE('Nome: ' || vnome);

    END LOOP;
    CLOSE cC1;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);

END;

BEGIN
    listar_cliente_usar_tabela_temp;
END;