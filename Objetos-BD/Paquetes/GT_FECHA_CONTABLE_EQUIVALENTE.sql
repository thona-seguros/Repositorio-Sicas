CREATE OR REPLACE PACKAGE          GT_FECHA_CONTABLE_EQUIVALENTE IS

  FUNCTION FECHA_CONTABLE(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN DATE;
  FUNCTION FECHA_REAL(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN DATE;
  PROCEDURE INSERTA_FECHA_CONTABLE(nCodCia NUMBER, nCodEmpresa NUMBER, dFechaReal DATE, dFechaContable DATE);

END GT_FECHA_CONTABLE_EQUIVALENTE;
/

CREATE OR REPLACE PACKAGE BODY          GT_FECHA_CONTABLE_EQUIVALENTE IS

FUNCTION FECHA_CONTABLE(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN DATE IS
dFechaContable    FECHA_CONTABLE_EQUIVALENTE.FechaContable%TYPE;
BEGIN
   BEGIN
      SELECT FechaContable
        INTO dFechaContable
        FROM FECHA_CONTABLE_EQUIVALENTE
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND FechaReal   = TRUNC(sysdate);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         dFechaContable := TRUNC(SYSDATE);
   END;
   RETURN(dFechaContable);
END FECHA_CONTABLE;

FUNCTION FECHA_REAL(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN DATE IS
dFechaReal    FECHA_CONTABLE_EQUIVALENTE.FechaReal%TYPE;
BEGIN
      SELECT trunc(sysdate)
        INTO dFechaReal
        FROM dual;

   RETURN(dFechaReal);
END FECHA_REAL;


PROCEDURE INSERTA_FECHA_CONTABLE(nCodCia NUMBER, nCodEmpresa NUMBER, dFechaReal DATE, dFechaContable DATE) IS
BEGIN
   BEGIN
      INSERT INTO FECHA_CONTABLE_EQUIVALENTE
             (CodCia, CodEmpresa, FechaReal, FechaContable, CodUsuario)
      VALUES (nCodCia, nCodEmpresa, TRUNC(dFechaReal), TRUNC(dFechaContable), USER);
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20100,'Fecha Real del Sistema ' || TO_CHAR(dFechaReal,'DD/MM/RRRR') || ' YA fue Cargada');
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20100,SQLERRM);
   END;
END INSERTA_FECHA_CONTABLE;

END GT_FECHA_CONTABLE_EQUIVALENTE;