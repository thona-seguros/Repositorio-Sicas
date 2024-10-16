--
-- GT_FAI_TIPOS_DE_INTERES  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FAI_TIPOS_DE_INTERES (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_TIPOS_DE_INTERES AS

FUNCTION DESCRIPCION(cTipoInteres VARCHAR2) RETURN VARCHAR2;
FUNCTION PERIODICIDAD(cTipoInteres VARCHAR2) RETURN VARCHAR2;

END GT_FAI_TIPOS_DE_INTERES;
/

--
-- GT_FAI_TIPOS_DE_INTERES  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_TIPOS_DE_INTERES (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_TIPOS_DE_INTERES AS

FUNCTION DESCRIPCION (cTipoInteres VARCHAR2) RETURN VARCHAR2 IS
cDescTipoInteres        FAI_TIPOS_DE_INTERES.DescTipoInteres%TYPE;
BEGIN
   BEGIN
      SELECT DescTipoInteres
        INTO cDescTipoInteres
        FROM FAI_TIPOS_DE_INTERES
       WHERE TipoInteres = cTipoInteres;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescTipoInteres := 'NO EXISTE';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Existen Varios Registros para el Tipo de Interes ' || cTipoInteres);
   END;
   RETURN(cDescTipoInteres);
END DESCRIPCION;

FUNCTION PERIODICIDAD (cTipoInteres VARCHAR2) RETURN VARCHAR2 IS
cPeriodicidad        FAI_TIPOS_DE_INTERES.Periodicidad%TYPE;
BEGIN
   BEGIN
      SELECT Periodicidad
        INTO cPeriodicidad
        FROM FAI_TIPOS_DE_INTERES
       WHERE TipoInteres = cTipoInteres;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'No Existe Tipo de Interes ' || cTipoInteres);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Existen Varios Registros para el Tipo de Interes ' || cTipoInteres);
   END;
   RETURN(cPeriodicidad);
END PERIODICIDAD;

END GT_FAI_TIPOS_DE_INTERES;
/
