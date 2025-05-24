declare prim_nome varchar2(20);
    ult_nome varchar2(20);
    nome_comp varchar2(20);
begin
    prim_nome := 'Rafael';
    ult_nome := 'Gastão';
    formata_nomes (prim_nome, ult_nome, nome_comp, 'ULTIMO PRIMEIRO');
DBMS_OUTPUT.put_line (prim_nome||' '|| ult_nome||' '||nome_comp);
end;