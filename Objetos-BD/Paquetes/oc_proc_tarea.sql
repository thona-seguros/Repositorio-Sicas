--
-- OC_PROC_TAREA  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   PROC_TAREA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_PROC_TAREA IS

  FUNCTION NOMBRE_PROCESO(nIdProceso NUMBER) RETURN VARCHAR2;
  FUNCTION INDICA_FEC_EQUIVALENTE_PRO(nIdProceso NUMBER) RETURN VARCHAR2;

END OC_PROC_TAREA;
/

--
-- OC_PROC_TAREA  (Package Body) 
--
--  Dependencies: 
--   OC_PROC_TAREA (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_PROC_TAREA IS

FUNCTION NOMBRE_PROCESO(nIdProceso NUMBER) RETURN VARCHAR2 IS
cDescripcion_Proceso   PROC_TAREA.Descripcion_Proceso%TYPE;
BEGIN
   BEGIN
      SELECT Descripcion_Proceso
        INTO cDescripcion_Proceso
        FROM PROC_TAREA
       WHERE IdProceso = nIdProceso;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescripcion_Proceso := 'PROCESO NO EXISTE';
   END;
   

   RETURN(cDescripcion_Proceso);
END NOMBRE_PROCESO;

FUNCTION INDICA_FEC_EQUIVALENTE_PRO(nIdProceso NUMBER) RETURN VARCHAR2 IS
cIndFecEquivPro   PROC_TAREA.IndFecEquiv%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndFecEquiv,'N')
        INTO cIndFecEquivPro 
        FROM PROC_TAREA
       WHERE IdProceso = nIdProceso;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndFecEquivPro := 'N';
   END;
   RETURN(cIndFecEquivPro);
END INDICA_FEC_EQUIVALENTE_PRO;

END OC_PROC_TAREA;
/
