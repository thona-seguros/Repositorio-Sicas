--
-- GT_FAI_TIPOS_DE_IMPUESTOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FAI_TIPOS_DE_IMPUESTOS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_TIPOS_DE_IMPUESTOS AS

FUNCTION DESCRIPCION(cTipoImpuesto VARCHAR2) RETURN VARCHAR2;

END GT_FAI_TIPOS_DE_IMPUESTOS;
/

--
-- GT_FAI_TIPOS_DE_IMPUESTOS  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_TIPOS_DE_IMPUESTOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_TIPOS_DE_IMPUESTOS AS

FUNCTION DESCRIPCION (cTipoImpuesto VARCHAR2) RETURN VARCHAR2 IS
cDescTipoImpuesto        FAI_TIPOS_DE_IMPUESTOS.DescTipoImpuesto%TYPE;
BEGIN
   BEGIN
      SELECT DescTipoImpuesto
        INTO cDescTipoImpuesto
        FROM FAI_TIPOS_DE_IMPUESTOS
       WHERE TipoImpuesto = cTipoImpuesto;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescTipoImpuesto := 'NO EXISTE';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Existen Varios Registros para el Tipo de Impuesto ' || cTipoImpuesto);
   END;
   RETURN(cDescTipoImpuesto);
END DESCRIPCION;

END GT_FAI_TIPOS_DE_IMPUESTOS;
/
