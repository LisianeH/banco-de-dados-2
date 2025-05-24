declare
    v_salario_ant float;
    v_codemp number := 12;
begin
    select salario_ant into v_salario_ant
    from empregado
    where codemp = v_codemp;
    if v_salario_ant is null then
        update empregado
        set salario_ant = salario
        where codemp = v_codemp;
        commit;
    end if;
exception
    when NO_DATA_FOUND then
    insert into tabela_erros
    values ('Empregado não encontrado com código: ' || v_codemp );
end;

-- para mostrar os dados (inserido o dado na coluna salario_ant, a partir de salario)
select *
    from empregado
    where codemp = 1;

-- para mostrar os dados da tabela tabela_erros, quando gerado um erro.
select *
    from tabela_erros



-- EXEMPLOS PARA USO DE CURSORES
create table acumformapgto
(codtppagamento int not null,
descricaotppagamento varchar(20) not null,
valor float not null,
primary key (codtppagamento));

-- Exemplo 1 - Utilizando a função sum no select
declare v_codtppagamento int;
    v_desctppagamento varchar(50);
    v_valor float;
cursor cur_vendas is
    select v.codtppagamento,
        t.descricaotppagamento,
        sum(v.vlvenda)
    from xvenda v, xtipospagamento t
    where v.codtppagamento = t.codtppagamento
    group by v.codtppagamento, t.descricaotppagamento;
begin
    open cur_vendas;
    LOOP
    FETCH cur_vendas into
        v_codtppagamento,
        v_desctppagamento,
        v_valor;
    EXIT WHEN cur_vendas%NOTFOUND;
    insert into acumformapgto (codtppagamento,
        descricaotppagamento,
        valor)
    values
        (v_codtppagamento,
        v_desctppagamento,
        v_valor);
    end LOOP;
end;

-- Exemplo 2 - Utilizando a função sum no select
declare v_codtppagamento int;
    v_desctppagamento varchar(50);
    v_valor float;
cursor cur_vendas is
    select v.codtppagamento,
        t.descricaotppagamento,
        v.vlvenda
    from xvenda v, xtipospagamento t
    where v.codtppagamento = t.codtppagamento;
begin
    open cur_vendas;
    LOOP
    FETCH cur_vendas into
        v_codtppagamento,
        v_desctppagamento,
        v_valor;
    EXIT WHEN cur_vendas%NOTFOUND;
    update acumformapgto
    set valor = valor + v_valor
    where codtppagamento = v_codtppagamento;
    if SQL%ROWCOUNT = 0 then
        insert into acumformapgto (codtppagamento,
            descricaotppagamento,
            valor)
        values (v_codtppagamento,
            v_desctppagamento,
            v_valor);
    end if;
    end LOOP;
end;

-- Mostrar os dados
select * from acumformapgto;