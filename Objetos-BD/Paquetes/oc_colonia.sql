--
-- OC_COLONIA  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   COLONIA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.oc_colonia IS

  FUNCTION DESCRIPCION_COLONIA(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodCiudad VARCHAR2,  cCodMunicipio VARCHAR2, 
                               cCodigo_Postal VARCHAR2, cCodigo_Colonia VARCHAR2) RETURN VARCHAR2;

END OC_COLONIA;
/

--
-- OC_COLONIA  (Package Body) 
--
--  Dependencies: 
--   OC_COLONIA (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.oc_colonia IS

FUNCTION DESCRIPCION_COLONIA(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodCiudad VARCHAR2,  cCodMunicipio VARCHAR2, 
                             cCodigo_Postal VARCHAR2, cCodigo_Colonia VARCHAR2) RETURN VARCHAR2 IS
cDescColonia   COLONIA.Descripcion_Colonia%TYPE;
BEGIN
   IF NVL(cCodigo_Colonia,0) != '999' THEN
      BEGIN
         SELECT Descripcion_Colonia
           INTO cDescColonia
           FROM COLONIA
          WHERE CodPais        = cCodPais
            AND CodEstado      = cCodEstado
            AND CodCiudad      = cCodCiudad
            AND CodMunicipio   = cCodMunicipio
            AND Codigo_Postal  = cCodigo_Postal
            AND Codigo_Colonia = cCodigo_Colonia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cDescColonia := 'COLONIA NO EXISTE';
      END;
   ELSE
      cDescColonia := NULL;
   END IF;
   RETURN(cDescColonia);
END DESCRIPCION_COLONIA;

END OC_COLONIA;
/
