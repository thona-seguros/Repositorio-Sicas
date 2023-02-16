CREATE OR REPLACE PACKAGE          OC_TRANSACCION IS

FUNCTION CREA (nCodCia NUMBER, nCodEmp NUMBER, nIdPro NUMBER, cIdSProc VARCHAR2) RETURN NUMBER;

FUNCTION ID_PROCESO(nIdTransaccion NUMBER) RETURN NUMBER;

PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdTransaccion NUMBER);

FUNCTION FechaTransaccion(nIdTransaccion NUMBER) RETURN VARCHAR2;

END OC_TRANSACCION;
/

CREATE OR REPLACE PACKAGE BODY          OC_TRANSACCION IS

FUNCTION CREA (nCodCia NUMBER, nCodEmp NUMBER, nIdPro NUMBER,cIdSProc VARCHAR2) RETURN NUMBER IS
nIdTransac        NUMBER(10);
cStsSubProc       VARCHAR2(3);
cIndFecEquivPro   PROC_TAREA.IndFecEquiv%TYPE;
cIndFecEquiv      SUB_PROCESO.IndFecEquiv%TYPE;
dFechaCamb        APROBACIONES.FECPAGO%TYPE;
dFechaCont        FECHA_CONTABLE_EQUIVALENTE.FECHACONTABLE%TYPE;
dFechaReal        FECHA_CONTABLE_EQUIVALENTE.FECHAREAL%TYPE;

BEGIN
--   SELECT  NVL(MAX(IdTransaccion),0) + 1   --JICO  20151106
--     INTO nIdTransac
--     FROM TRANSACCION
--    WHERE CodCia     = nCodCia
--      AND CodEmpresa = nCodEmp;         

  SELECT SQ_TRANSACCION.NEXTVAL      --JICO  20151106
    INTO nIdTransac
    FROM DUAL;
    
    
   BEGIN
      SELECT StsSubProc
        INTO cStsSubProc
        FROM SUB_PROCESO
       WHERE IdProceso     = nIdPro
         AND CodSubProceso = cIdSProc;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100,'SubProceso '||cIdSProc||' NO existe para el Proceso '||nIdPro);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR (-20100,'Existen varios SubProceso '||cIdSProc||' para el Proceso '||nIdPro);
   END;

   IF cStsSubProc <> 'EMI' THEN
      RAISE_APPLICATION_ERROR (-20100,'El estatus del SubProceso no es EMITIDO');
   END IF;
   BEGIN
     
    
    cIndFecEquivPro := OC_PROC_TAREA.INDICA_FEC_EQUIVALENTE_PRO(nIdPro);
    cIndFecEquiv    := OC_SUB_PROCESO.INDICA_FEC_EQUIVALENTE_SUBPROC(nIdPro,cIdSProc);
    dFechaCont      := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_CONTABLE(nCodCia, nCodEmp);
    dFechaReal      := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_REAL(nCodCia, nCodEmp);
    
     
    IF cIndFecEquivPro = 'S' THEN
    
      IF cIndFecEquiv = 'S' then
         dFechaCamb:= dFechaCont;  
      else
        dFechaCamb := dFechaReal;
      end if;
      
    ELSE
    
     dFechaCamb := dFechaReal;
     
    end if; 
    
     INSERT INTO TRANSACCION (IdTransaccion, CodCia, CodEmpresa, IdProceso, FechaTransaccion, UsuarioGenero)
     VALUES (nIdTransac, nCodCia, nCodEmp, nIdPro, dFechaCamb, USER);
   EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN
       RAISE_APPLICATION_ERROR (-20100,'Transacción '||nIdTransac||' fué utilizada por otro usuario. Favor de ejecutar nuevamente la operación ');
     WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR (-20100,'Error al Insertar la Transacción '||nIdTransac||' '|| SQLERRM);
   END;
   RETURN (nIdTransac);
END CREA;

FUNCTION ID_PROCESO(nIdTransaccion NUMBER) RETURN NUMBER IS
nIdProceso   TRANSACCION.IdProceso%TYPE;
BEGIN
   BEGIN
      SELECT DISTINCT IdProceso
        INTO nIdProceso
        FROM TRANSACCION
       WHERE IdTransaccion = nIdTransaccion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100,'No de Transaccion '||nIdTransaccion||' NO existe');
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR (-20100,'No de Transaccion '||nIdTransaccion||' Generada para Varios Procesos');
   END;
   RETURN(nIdProceso);
END ID_PROCESO;

PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdTransaccion NUMBER) IS
BEGIN
   DELETE DETALLE_TRANSACCION
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdTransaccion = nIdTransaccion;
END ELIMINAR;

FUNCTION FechaTransaccion(nIdTransaccion NUMBER) RETURN VARCHAR2 IS
cFechaTansaccion  VARCHAR2(30);
BEGIN
   BEGIN
      SELECT FechaTransaccion
        INTO cFechaTansaccion
        FROM TRANSACCION
       WHERE IdTransaccion = nIdTransaccion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cFechaTansaccion := Null;
      WHEN TOO_MANY_ROWS THEN
         cFechaTansaccion := Null;
   END;
   RETURN cFechaTansaccion;
END FechaTransaccion;

END OC_TRANSACCION;
