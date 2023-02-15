CREATE OR REPLACE PACKAGE          OC_SUB_PROCESO IS

  FUNCTION NOMBRE_SUBPROCESO(nIdProceso NUMBER, cCodSubProceso VARCHAR2) RETURN VARCHAR2;

  FUNCTION GENERA_CONTABILIDAD(nIdProceso NUMBER, cCodSubProceso VARCHAR2) RETURN VARCHAR2;

  FUNCTION PROCESO_CONTABLE(nIdProceso NUMBER, cCodSubProceso VARCHAR2) RETURN VARCHAR2;

  FUNCTION PROCESO_AUTORIZACION(nIdProceso NUMBER, cCodSubProceso VARCHAR2) RETURN VARCHAR2;
  FUNCTION INDICA_FEC_EQUIVALENTE_SUBPROC(nIdProceso NUMBER,cCodSubProceso VARCHAR2) RETURN VARCHAR2;
  PROCEDURE CAMBIA_FECHA_EQUIVALENTE(nIdProceso NUMBER);
  PROCEDURE DESMARCA_FEC_EQUIVALENTE(nIdProceso NUMBER);
  
END OC_SUB_PROCESO;
/

CREATE OR REPLACE PACKAGE BODY          OC_SUB_PROCESO IS

FUNCTION NOMBRE_SUBPROCESO(nIdProceso NUMBER, cCodSubProceso VARCHAR2) RETURN VARCHAR2 IS
cDescripcion   SUB_PROCESO.Descripcion%TYPE;
BEGIN
   BEGIN
      SELECT Descripcion
        INTO cDescripcion
        FROM SUB_PROCESO
       WHERE IdProceso     = nIdProceso
         AND CodSubProceso = cCodSubProceso;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescripcion := 'SUBPROCESO NO EXISTE';
   END;
   RETURN(cDescripcion);
END NOMBRE_SUBPROCESO;

FUNCTION GENERA_CONTABILIDAD(nIdProceso NUMBER, cCodSubProceso VARCHAR2) RETURN VARCHAR2 IS
cIndGenContabilidad   SUB_PROCESO.IndGenContabilidad%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndGenContabilidad,'N')
        INTO cIndGenContabilidad
        FROM SUB_PROCESO
       WHERE IdProceso     = nIdProceso
         AND CodSubProceso = cCodSubProceso;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndGenContabilidad := 'N';
   END;
   RETURN(cIndGenContabilidad);
END GENERA_CONTABILIDAD;

FUNCTION PROCESO_CONTABLE(nIdProceso NUMBER, cCodSubProceso VARCHAR2) RETURN VARCHAR2 IS
cCodProcesoCont   SUB_PROCESO.CodProcesoCont%TYPE;
BEGIN
   BEGIN
      SELECT CodProcesoCont
        INTO cCodProcesoCont
        FROM SUB_PROCESO
       WHERE IdProceso     = nIdProceso
         AND CodSubProceso = cCodSubProceso;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'NO Existe Código de Proceso Contable en Sub-Proceso '|| cCodSubProceso);
   END;
   IF cCodProcesoCont IS NULL THEN
      RAISE_APPLICATION_ERROR(-20100,'NO está Configurado el Código de Proceso Contable en Sub-Proceso '|| cCodSubProceso);
   END IF;
   RETURN(cCodProcesoCont);
END PROCESO_CONTABLE;

FUNCTION PROCESO_AUTORIZACION(nIdProceso NUMBER, cCodSubProceso VARCHAR2) RETURN VARCHAR2 IS
cCodProceso   SUB_PROCESO.CodProceso%TYPE;
BEGIN
   BEGIN
      SELECT CodProceso
        INTO cCodProceso
        FROM SUB_PROCESO
       WHERE IdProceso     = nIdProceso
         AND CodSubProceso = cCodSubProceso;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodProceso := NULL;
   END;
   RETURN(cCodProceso);
END PROCESO_AUTORIZACION;
FUNCTION INDICA_FEC_EQUIVALENTE_SUBPROC(nIdProceso NUMBER,cCodSubProceso VARCHAR2) RETURN VARCHAR2 IS
cIndFecEquiv   PROC_TAREA.IndFecEquiv%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndFecEquiv,'N')
        INTO cIndFecEquiv 
        FROM SUB_PROCESO
       WHERE IdProceso = nIdProceso
       AND CodSubProceso = cCodSubProceso;
       
        EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndFecEquiv  := 'N';
   END;
   RETURN(cIndFecEquiv);
END INDICA_FEC_EQUIVALENTE_SUBPROC;

procedure CAMBIA_FECHA_EQUIVALENTE(nIdProceso NUMBER)IS

BEGIN
   BEGIN
    
      UPDATE SUB_PROCESO
      SET IndFecEquiv = 'S'
      WHERE IdProceso = nIdProceso;
      
    EXCEPTION
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20234,'ERROR AL ACTUALIZAR'||nIdProceso);
   END;   
END CAMBIA_FECHA_EQUIVALENTE;

procedure DESMARCA_FEC_EQUIVALENTE(nIdProceso NUMBER)IS

BEGIN
   BEGIN
    
      UPDATE SUB_PROCESO
      SET IndFecEquiv = 'N'
      WHERE IdProceso = nIdProceso;
      
    EXCEPTION
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20234,'ERROR AL ACTUALIZAR'||nIdProceso);
   END;   
END DESMARCA_FEC_EQUIVALENTE;

end oc_sub_proceso;
