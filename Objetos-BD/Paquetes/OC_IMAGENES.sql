CREATE OR REPLACE PACKAGE OC_IMAGENES IS

  PROCEDURE INSERTAR(nCodCia NUMBER, cNivel VARCHAR2, cIdentificador VARCHAR2,
                     cPathImagen VARCHAR2, cDescripcion VARCHAR2, cObservaciones VARCHAR2,
                     cFormato VARCHAR2);

END OC_IMAGENES;
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_IMAGENES IS

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
