CREATE OR REPLACE PACKAGE OC_TABLAS_MORTALIDAD AS
   PROCEDURE COPIAR(nCodCia NUMBER, cTipoTabla VARCHAR2, nCodCiaDest NUMBER, cTipoTablaDest VARCHAR2, nPorcAplica NUMBER);
   FUNCTION VALOR_QX(nCodCia NUMBER, cTipoTabla VARCHAR2, cSexo VARCHAR2, cFumador VARCHAR2, nEdad NUMBER) RETURN NUMBER;
   FUNCTION VALOR_LX(nCodCia NUMBER, cTipoTabla VARCHAR2, cSexo VARCHAR2, cFumador VARCHAR2, nEdad NUMBER) RETURN NUMBER;
   FUNCTION VALOR_PX(nCodCia NUMBER, cTipoTabla VARCHAR2, cSexo VARCHAR2, cFumador VARCHAR2, nEdad NUMBER) RETURN NUMBER;
END OC_TABLAS_MORTALIDAD;

--End of DDL script for OC_TABLAS_MORTALIDAD
 
 
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_TABLAS_MORTALIDAD AS

PROCEDURE COPIAR(nCodCia NUMBER, cTipoTabla VARCHAR2, nCodCiaDest NUMBER, cTipoTablaDest VARCHAR2, nPorcAplica NUMBER) IS
CURSOR C_MORTAL IS
   SELECT Sexo, Fumador, Edad, Qx, Lx
     FROM TABLAS_MORTALIDAD
    WHERE CodCia    = nCodCia
           AND TipoTabla = cTipoTabla;
BEGIN
   FOR X IN C_MORTAL LOOP
      INSERT INTO TABLAS_MORTALIDAD
             (CodCia, TipoTabla, Sexo, Fumador, Edad, Qx, Lx, PX)
      VALUES (nCodCiaDest, cTipoTablaDest, X.Sexo, X.Fumador, X.Edad, (X.Qx*nPorcAplica)/100, X.Lx, 0);
  END LOOP;
END COPIAR;

FUNCTION VALOR_QX(nCodCia NUMBER, cTipoTabla VARCHAR2, cSexo VARCHAR2, cFumador VARCHAR2, nEdad NUMBER) RETURN NUMBER IS
nQx      TABLAS_MORTALIDAD.Qx%TYPE;
BEGIN
   BEGIN
      SELECT Qx
        INTO nQx
        FROM TABLAS_MORTALIDAD
       WHERE CodCia    = nCodCia
              AND TipoTabla = cTipoTabla
         AND Sexo      = cSexo
         AND Fumador   = cFumador
         AND Edad      = nEdad;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nQx   := 0;
   END;
   RETURN(nQx);
END VALOR_QX;

FUNCTION VALOR_LX(nCodCia NUMBER, cTipoTabla VARCHAR2, cSexo VARCHAR2, cFumador VARCHAR2, nEdad NUMBER) RETURN NUMBER IS
nLx      TABLAS_MORTALIDAD.Lx%TYPE;
BEGIN
   BEGIN
      SELECT Lx
        INTO nLx
        FROM TABLAS_MORTALIDAD
       WHERE CodCia    = nCodCia
              AND TipoTabla = cTipoTabla
         AND Sexo      = cSexo
         AND Fumador   = cFumador
         AND Edad      = nEdad;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nLx   := 0;
   END;
   RETURN(nLx);
END VALOR_LX;

FUNCTION VALOR_PX(nCodCia NUMBER, cTipoTabla VARCHAR2, cSexo VARCHAR2, cFumador VARCHAR2, nEdad NUMBER) RETURN NUMBER IS
nPx      TABLAS_MORTALIDAD.Px%TYPE;
BEGIN
   BEGIN
      SELECT Px
        INTO nPx
        FROM TABLAS_MORTALIDAD
       WHERE CodCia    = nCodCia
              AND TipoTabla = cTipoTabla
         AND Sexo      = cSexo
         AND Fumador   = cFumador
         AND Edad      = nEdad;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPx   := 0;
   END;
   RETURN(nPx);
END VALOR_PX;

END OC_TABLAS_MORTALIDAD;
