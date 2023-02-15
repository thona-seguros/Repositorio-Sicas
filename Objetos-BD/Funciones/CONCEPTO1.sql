FUNCTION CONCEPTO1(cnombre VARCHAR2) RETURN VARCHAR2 IS
    resultado varchar2(100);
    contador number;
begin

    contador := 0;
    for k in 1..length(cnombre) loop 
        if substr(cnombre, k,1) in('0','1','2','3','4','5','6','7','8','9') then
            resultado := substr(cnombre, 1, k-1);        
            EXIT;        
        end if;
    end loop;
    return(resultado);
end;
