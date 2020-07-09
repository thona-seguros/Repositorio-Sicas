--
-- OC_IMAGENES  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   IMAGENES (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_IMAGENES IS

  PROCEDURE INSERTAR(nCodCia NUMBER, cNivel VARCHAR2, cIdentificador VARCHAR2,
                     cPathImagen VARCHAR2, cDescripcion VARCHAR2, cObservaciones VARCHAR2,
                     cFormato VARCHAR2);

END OC_IMAGENES;
/

--
-- OC_IMAGENES  (Package Body) 
--
--  Dependencies: 
--   OC_IMAGENES (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_IMAGENES IS

PROCEDURE INSERTAR(nCodCia NUMBER, cNivel VARCHAR2, cIdentificador VARCHAR2,
                   cPathImagen VARCHAR2, cDescripcion VARCHAR2, cObservaciones VARCHAR2,
                   cFormato VARCHAR2) IS
BEGIN
   BEGIN
      INSERT INTO IMAGENES
             (CodCia, Nivel, Identificador, Path_Imagen, Observaciones,
              Descripcion, CodUsuario, StsImagenes, FecSts, Formato)
      VALUES (nCodCia, cNivel, cIdentificador, cPathImagen, cObservaciones,
              cDescripcion, USER, 'ACT', SYSDATE, cFormato);
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         NULL;
   END;
END INSERTAR;

END OC_IMAGENES;
/

--
-- OC_IMAGENES  (Synonym) 
--
--  Dependencies: 
--   OC_IMAGENES (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_IMAGENES FOR SICAS_OC.OC_IMAGENES
/


GRANT EXECUTE ON SICAS_OC.OC_IMAGENES TO PUBLIC
/
