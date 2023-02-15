CREATE OR REPLACE PACKAGE oc_catalogo_contable IS

  FUNCTION NOMBRE_CUENTA(cIdCtaContable VARCHAR2) RETURN VARCHAR2;

  FUNCTION EXISTE_CUENTA(cIdCtaContable VARCHAR2) RETURN VARCHAR2;
  
  FUNCTION CREA_ID_CUENTA(nCodCia NUMBER, cNivelCta1 VARCHAR2, cNivelCta2 VARCHAR2,
                          cNivelCta3 VARCHAR2, cNivelCta4 VARCHAR2, cNivelCta5 VARCHAR2,
                          cNivelCta6 VARCHAR2, cNivelCta7 VARCHAR2, cNivelAux VARCHAR2,
                          cNombreCta VARCHAR2, cClasifCta VARCHAR2) RETURN VARCHAR2;

  FUNCTION FORMATO_CUENTA(cIdCtaContable VARCHAR2) RETURN VARCHAR2;

END OC_CATALOGO_CONTABLE;
 
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY oc_catalogo_contable IS

FUNCTION NOMBRE_CUENTA(cIdCtaContable VARCHAR2) RETURN VARCHAR2 IS
cNombreCta   CATALOGO_CONTABLE.NombreCta%TYPE;
BEGIN
   BEGIN
      SELECT NombreCta
        INTO cNombreCta
        FROM CATALOGO_CONTABLE
       WHERE IdCtaContable = cIdCtaContable;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNombreCta := 'NO EXISTE';
   END;
   RETURN(cNombreCta);
END NOMBRE_CUENTA;

FUNCTION EXISTE_CUENTA(cIdCtaContable VARCHAR2) RETURN VARCHAR2 IS
cExiste   VARCHAR2(1) := 'N';
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM CATALOGO_CONTABLE
       WHERE IdCtaContable = cIdCtaContable;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
   END;
   RETURN(cExiste);
END EXISTE_CUENTA;

FUNCTION CREA_ID_CUENTA(nCodCia NUMBER, cNivelCta1 VARCHAR2, cNivelCta2 VARCHAR2,
                        cNivelCta3 VARCHAR2, cNivelCta4 VARCHAR2, cNivelCta5 VARCHAR2,
                        cNivelCta6 VARCHAR2, cNivelCta7 VARCHAR2, cNivelAux VARCHAR2,
                        cNombreCta VARCHAR2, cClasifCta VARCHAR2) RETURN VARCHAR2 IS
cIdCtaContable   CATALOGO_CONTABLE.IdCtaContable%TYPE;
BEGIN
   cIdCtaContable := LPAD(TRIM(TO_CHAR(nCodCia)),14,'0') || cNivelCta1 || cNivelCta2 ||
                     cNivelCta3 || cNivelCta4 || cNivelCta5 || cNivelCta6 || cNivelCta7 || 
                     cNivelAux;
   IF OC_CATALOGO_CONTABLE.EXISTE_CUENTA(cIdCtaContable) = 'N' THEN
      BEGIN
         INSERT INTO CATALOGO_CONTABLE
               (IdCtaContable, CodCia, NivelCta1, NivelCta2, NivelCta3, NivelCta4,
                NivelCta5, NivelCta6, NivelCta7, NivelAux, NombreCta, ClasifCta,
                StsCtaCont, FecSts)
         VALUES(cIdCtaContable, nCodCia, cNivelCta1, cNivelCta2, cNivelCta3, cNivelCta4,
                cNivelCta5, cNivelCta6, cNivelCta7, cNivelAux, cNombreCta, cClasifCta,
                'ACTIVA', SYSDATE);
      END;
   END IF;
   RETURN(cIdCtaContable); 
END CREA_ID_CUENTA;

FUNCTION FORMATO_CUENTA(cIdCtaContable VARCHAR2) RETURN VARCHAR2 IS
cCuenta        VARCHAR2(40);
CURSOR CTA_Q IS
   SELECT NivelCta1, NivelCta2, NivelCta3, NivelCta4,
          NivelCta5, NivelCta6, NivelCta7, NivelAux
     FROM CATALOGO_CONTABLE
    WHERE IdCtaContable = cIdCtaContable;
BEGIN
   FOR X IN CTA_Q LOOP
      cCuenta := X.NivelCta1 || X.NivelCta2 || X.NivelCta3;

      IF X.NivelCta4 IS NOT NULL THEN
         cCuenta := cCuenta || '.' || X.NivelCta4;
      END IF;

      IF X.NivelCta5 IS NOT NULL THEN
         cCuenta := cCuenta || '.' || X.NivelCta5;
      END IF;

      IF X.NivelCta6 IS NOT NULL THEN
         cCuenta :=  cCuenta || '.' || X.NivelCta6;
      END IF;
      IF X.NivelCta7 IS NOT NULL THEN
         cCuenta :=  cCuenta || '.' || X.NivelCta7;
      END IF;
      /*IF X.NivelAux IS NOT NULL THEN
         cCuenta :=  cCuenta || '.' || X.NivelAux;
      END IF;*/
   END LOOP;
   RETURN(cCuenta);
END FORMATO_CUENTA;

END OC_CATALOGO_CONTABLE;
