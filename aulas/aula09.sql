CREATE OR REPLACE TRIGGER seguranca_cliente
BEFORE INSERT OR DELETE OR UPDATE ON cliente
BEGIN
if (to_char(sysdate,'DY') in ('SÁB','DOM'))
 or (to_number(to_char(sysdate,'HH24')) not between 8 and 18) then
 if DELETING then
 raise_application_error(-20001,'Você só pode deletar no horário comercial');
 elsif INSERTING then
 raise_application_error(-20001,'Você só pode inserir no horário comercial');
 elsif UPDATING ('endereco') THEN
 raise_application_error(-20001,'Você só pode alterar o endereco no horário
comercial');
 else
 raise_application_error(-20001,'Você só pode alterar no horário comercial');
 end if;
end if;
end;

select * from cliente;
delete from cliente where cod_cli = 'c1';

--------------------------
create table curso2 (codcurso integer not null,
curso varchar(30) not null,
carga_horaria integer not null,
carga_horaria_ant integer null,
primary key (codcurso));

insert into curso2 values (1, 'Android', 20, null);
insert into curso2 values (2, 'PL/SQL', 12, null);
insert into curso2 values (3, 'Java', 120, null);
insert into curso2 values (4, 'Oratoria', 20, null);

create or replace trigger curso2_ch
before update of carga_horaria on curso2
for each row
begin
    if nvl(:new.carga_horaria,0) < nvl(:old.carga_horaria,0) then
        raise_application_error(-20003,'A carga horária do curso não pode ser diminuida.');
    end if;
    :new.carga_horaria_ant := :old.carga_horaria;
end;