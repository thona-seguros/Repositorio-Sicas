CREATE OR REPLACE PACKAGE OC_TAREA IS

  PROCEDURE INSERTA_TAREA(nCodCia NUMBER, nIdProceso NUMBER, cProcIni VARCHAR2, cProcFin VARCHAR2,
                          nIdPoliza NUMBER, nCodCliente NUMBER, cTipoTarea VARCHAR2,
                          cSubTipoTarea VARCHAR2, cNombreTarea VARCHAR2);
 FUNCTION EXISTE_TAREA(nCodCia NUMBER, nIdpoliza NUMBER) RETURN VARCHAR2;

END OC_TAREA;
 
 
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_TAREA IS

PROCEDURE INSERTA_TAREA(nCodCia NUMBER, nIdProceso NUMBER, cProcIni VARCHAR2, cProcFin VARCHAR2,
                          nIdPoliza NUMBER, nCodCliente NUMBER, cTipoTarea VARCHAR2,
                          cSubTipoTarea VARCHAR2, cNombreTarea VARCHAR2) IS
nIdTarea           TAREA.IdTarea%TYPE;
nTiempo            PROC_TAREA.Tiempo%TYPE;
cParametro_Tiempo  PROC_TAREA.Parametro_Tiempo%TYPE;
dFechaEsperada     TAREA.FechaEsperada%TYPE;
BEGIN
    BEGIN
       SELECT Tiempo, Parametro_Tiempo
         INTO nTiempo,cParametro_Tiempo
         FROM PROC_TAREA
        WHERE PROINI = 'SOL'
          AND PROFIN  = 'EMI'
          AND IDPROCESO = 7;
   EXCEPTION
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20200,'Error Definicion de Configuracion de Proceso'||SQLERRM);
   END;

   IF cParametro_Tiempo = 'M' THEN
      dFechaEsperada := TRUNC (ADD_MONTHS (SYSDATE,nTiempo));
   ELSIF cParametro_Tiempo = 'D' THEN
      dFechaEsperada := TRUNC (SYSDATE + nTiempo);
   END IF;

   BEGIN
      SELECT NVL(MAX(IdTarea),0)+1
        INTO nIdTarea
        FROM TAREA
       WHERE CodCia = nCodCia;

      INSERT INTO TAREA
             (CodCia, IdTarea, CodUsuario, TipoTarea, SubTipoTarea, NombreTarea,
              IdPoliza, Estado_Inicial, Estado, CodCliente, FechaGraba, FechaEsperada)
      VALUES (nCodCia, nIdTarea, USER, cTipoTarea, cSubTipoTarea, cNombreTarea,
              nIdPoliza, 'PRO','PRO', nCodCliente, SYSDATE, dFechaEsperada);
   EXCEPTION
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20200,'Error en Insertar Tarea de Solicitud de P¿liza-'||SQLERRM);
   END;
END INSERTA_TAREA;
FUNCTION EXISTE_TAREA(nCodCia NUMBER, nIdpoliza NUMBER) RETURN VARCHAR2 IS
cExiste  VARCHAR2(1);
BEGIN

   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM TAREA
       WHERE CodCia     = nCodCia
         AND idpoliza   = nIdPoliza;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;

   RETURN(cExiste);
END EXISTE_TAREA;
END OC_TAREA;
