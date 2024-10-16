--
-- REFERENCIA_BANCARIA_FONDOS  (Function) 
--
--  Dependencies: 
--   STANDARD (Package)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--   DETALLE_POLIZA (Table)
--   DIGITO_VERIFICADOR (Function)
--
CREATE OR REPLACE FUNCTION SICAS_OC.REFERENCIA_BANCARIA_FONDOS
  (P_IDPOLIZA  NUMBER,
   P_TIPOFONDO VARCHAR2)  RETURN VARCHAR2 IS
 --
 CREFERENCIA   VARCHAR2(20);
 CIDTIPOSEG    VARCHAR2(5);
BEGIN
  --
  CIDTIPOSEG   := '';
  --
  SELECT RPAD(SUBSTR(MAX(IDTIPOSEG),1,5) ,5,'0')
    INTO CIDTIPOSEG
    FROM DETALLE_POLIZA    
   WHERE IDPOLIZA = P_IDPOLIZA;
  --
  IF P_TIPOFONDO = 'REGULAR' THEN 
     CREFERENCIA := CIDTIPOSEG||LPAD(P_IDPOLIZA,7,'0')||'REGULAR';
     CREFERENCIA := CREFERENCIA||TO_CHAR(DIGITO_VERIFICADOR(CREFERENCIA));
  ELSE --EXTRAORDINARIO FALTA LA DEFINICIÓN DEL TIPO DE FONDO
     CREFERENCIA := CIDTIPOSEG||LPAD(P_IDPOLIZA,7,'0')||'EXTRAOR';
     CREFERENCIA := CREFERENCIA||TO_CHAR(DIGITO_VERIFICADOR(CREFERENCIA));
  END IF;
  -- 
  RETURN (CREFERENCIA) ;
END;
/
