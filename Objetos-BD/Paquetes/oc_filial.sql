--
-- OC_FILIAL  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   FILIAL (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_FILIAL  IS
   FUNCTION NOMBRE_FILIAL (cCodFilial NUMBER)   RETURN  VARCHAR2 ;
END;
/

--
-- OC_FILIAL  (Package Body) 
--
--  Dependencies: 
--   OC_FILIAL (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_FILIAL IS
   FUNCTION NOMBRE_FILIAL (cCodFilial NUMBER)      RETURN  VARCHAR2 IS
     cNombre VARCHAR2(200);
     BEGIN
        BEGIN
           SELECT TRIM(Nombre) || ' ' || TRIM(Apellido_Paterno) || ' ' ||
                  TRIM(Apellido_Materno) || ' ' || DECODE(ApeCasada, NULL, ' ', ' de ' ||ApeCasada)
             INTO cNombre
             FROM PERSONA_NATURAL_JURIDICA
            WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN
                (SELECT Tipo_Doc_Identificacion, Num_Doc_Identificacion
                   FROM FILIAL
                  WHERE CodFilial = cCodFilial);
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
           cNombre := 'NO EXISTE';
        END;
        RETURN(cNombre)  ;
     END NOMBRE_FILIAL;


END;
/
