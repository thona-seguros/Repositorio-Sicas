CREATE OR REPLACE PACKAGE OC_PROCESO_AUTORIZACION IS

  FUNCTION MANEJA_TIPO_SEGURO(nCodCia NUMBER, cCodProceso VARCHAR2) RETURN VARCHAR2;

  FUNCTION DESCRIPCION_PROCESO(nCodCia NUMBER, cCodProceso VARCHAR2) RETURN VARCHAR2;

  FUNCTION APLICA_NIVEL_JERARQUICO(nCodCia NUMBER, cCodProceso VARCHAR2) RETURN VARCHAR2;

END OC_PROCESO_AUTORIZACION;
/

CREATE OR REPLACE PACKAGE BODY OC_PROCESO_AUTORIZACION IS

FUNCTION MANEJA_TIPO_SEGURO(nCodCia NUMBER, cCodProceso VARCHAR2) RETURN VARCHAR2 IS
cManejaTipoSeg    VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cManejaTipoSeg
        FROM PROCESO_AUTORIZACION
       WHERE CodCia     = nCodCia
         AND CodProceso = cCodProceso
         AND IndTipoSeg = 'S';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cManejaTipoSeg := 'N';
      WHEN TOO_MANY_ROWS THEN
         cManejaTipoSeg := 'S';
   END;
   RETURN(cManejaTipoSeg);
END MANEJA_TIPO_SEGURO;

FUNCTION DESCRIPCION_PROCESO(nCodCia NUMBER, cCodProceso VARCHAR2) RETURN VARCHAR2 IS
cDescProcAutoriza    PROCESO_AUTORIZACION.DescProcAutoriza%TYPE;
BEGIN
   BEGIN
      SELECT DescProcAutoriza
        INTO cDescProcAutoriza
        FROM PROCESO_AUTORIZACION
       WHERE CodCia     = nCodCia
         AND CodProceso = cCodProceso;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescProcAutoriza := 'NO EXISTE';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error en Configuraci�n del Proceso ' || cCodProceso ||' - Existen Varios Registros');
   END;
   RETURN(cDescProcAutoriza);
END DESCRIPCION_PROCESO;

FUNCTION APLICA_NIVEL_JERARQUICO(nCodCia NUMBER, cCodProceso VARCHAR2) RETURN VARCHAR2 IS
cIndNivelJerarquico    PROCESO_AUTORIZACION.IndNivelJerarquico%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndNivelJerarquico,'N')
        INTO cIndNivelJerarquico
        FROM PROCESO_AUTORIZACION
       WHERE CodCia     = nCodCia
         AND CodProceso = cCodProceso;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndNivelJerarquico := 'N';
      WHEN TOO_MANY_ROWS THEN
         cIndNivelJerarquico := 'S';
   END;
   RETURN(cIndNivelJerarquico);
END APLICA_NIVEL_JERARQUICO;

END OC_PROCESO_AUTORIZACION;