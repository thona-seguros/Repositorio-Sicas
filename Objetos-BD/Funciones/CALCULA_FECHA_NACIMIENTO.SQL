--
-- CALCULA_FECHA_NACIMIENTO  (Function) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DUAL (Synonym)
--   DBMS_OUTPUT (Synonym)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--
CREATE OR REPLACE FUNCTION SICAS_OC.CALCULA_FECHA_NACIMIENTO
  (P_RFC VARCHAR2)  RETURN DATE IS
 --
 cFechaNacimiento   	VARCHAR2(10);
 cFechaNacimientoComp  	DATE;
 nAnioSysdate		NUMBER;
 nAnio			NUMBER;
 nMes			NUMBER;
 nDia			NUMBER;
 nposicionInicial	NUMBER;

 BEGIN
  --
  SELECT TO_CHAR(SYSDATE,'YYYY')
    INTO nAnioSysdate
    FROM DUAL;
    
  DBMS_OUTPUT.PUT_LINE('ANIO SYSDATE ES : '||nAnioSysdate);
  
  SELECT REGEXP_INSTR(P_RFC,'[0-9]')
    INTO nposicionInicial
    FROM DUAL;

  DBMS_OUTPUT.PUT_LINE('nposicionInicial ES : '||nposicionInicial);
  
  SELECT SUBSTR(P_RFC,nposicionInicial,2), SUBSTR(P_RFC,nposicionInicial + 2,2), SUBSTR(P_RFC,nposicionInicial + 4,2)
    INTO  nAnio, nMes, nDia
    FROM DUAL;
  --
  cFechaNacimiento := nDia||'/'||nMes||'/'|| nAnio;

  DBMS_OUTPUT.PUT_LINE('cFechaNacimiento ES : '||cFechaNacimiento);
  
  SELECT TO_DATE(cFechaNacimiento,'DD/MM/RRRR')
    INTO cFechaNacimientoComp
    FROM DUAL;

  DBMS_OUTPUT.PUT_LINE('LA FECHA DE NACIMIENTO ES : '||cFechaNacimientoComp);
  --

  --
  RETURN (cFechaNacimientoComp);
  --
END;
/

--
-- CALCULA_FECHA_NACIMIENTO  (Synonym) 
--
--  Dependencies: 
--   CALCULA_FECHA_NACIMIENTO (Function)
--
CREATE OR REPLACE PUBLIC SYNONYM CALCULA_FECHA_NACIMIENTO FOR SICAS_OC.CALCULA_FECHA_NACIMIENTO
/


GRANT EXECUTE ON SICAS_OC.CALCULA_FECHA_NACIMIENTO TO PUBLIC
/
