CREATE OR REPLACE PACKAGE GT_FAI_PRECIOS AS

FUNCTION DESCRIPCION_PRECIO (cTipoPrecio VARCHAR2) RETURN VARCHAR2;

END GT_FAI_PRECIOS;
/

CREATE OR REPLACE PACKAGE BODY GT_FAI_PRECIOS  AS

FUNCTION DESCRIPCION_PRECIO (cTipoPrecio VARCHAR2) RETURN VARCHAR2 IS
cDescPrecio    FAI_PRECIOS.DescPrecio%TYPE;
BEGIN
   BEGIN
      SELECT DescPrecio
        INTO cDescPrecio
        FROM FAI_PRECIOS
       WHERE TipoPrecio  = cTipoPrecio;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescPrecio := 'NO EXISTE';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Existen Varios Registros para el Precio  '||cTipoPrecio);
   END;
   RETURN(cDescPrecio);
END DESCRIPCION_PRECIO;

END GT_FAI_PRECIOS;