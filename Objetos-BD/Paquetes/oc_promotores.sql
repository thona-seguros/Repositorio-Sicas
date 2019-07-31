--
-- OC_PROMOTORES  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   PROMOTORES (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_PROMOTORES IS

  PROCEDURE ACTIVAR_PROMOTOR(nCodCia NUMBER, cCodPromotor VARCHAR2);
  PROCEDURE SUSPENDER_PROMOTOR(nCodCia NUMBER, cCodPromotor VARCHAR2);
  FUNCTION NOMBRE_PROMOTOR(nCodCia NUMBER, cCodPromotor VARCHAR2) RETURN VARCHAR2;
  FUNCTION VERIFICA_NIVEL(nCodCia NUMBER, cCodPromotor VARCHAR2, nPosicion NUMBER) RETURN VARCHAR2;
  FUNCTION EXISTE_PROMOTOR(nCodCia NUMBER, cCodPromotor VARCHAR2) RETURN VARCHAR2 ;
  PROCEDURE CAMBIAR_PROMOTOR(nCodCia NUMBER, cCodPromotor VARCHAR2, cMotivoBaja VARCHAR2, dFecBaja DATE);

END OC_PROMOTORES;
/

--
-- OC_PROMOTORES  (Package Body) 
--
--  Dependencies: 
--   OC_PROMOTORES (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_PROMOTORES IS

PROCEDURE ACTIVAR_PROMOTOR(nCodCia NUMBER, cCodPromotor VARCHAR2) IS
BEGIN
   UPDATE PROMOTORES
      SET StsPromotor = 'ACTIV',
          FecSts      = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodPromotor = cCodPromotor;
END ACTIVAR_PROMOTOR;

PROCEDURE SUSPENDER_PROMOTOR(nCodCia NUMBER, cCodPromotor VARCHAR2) IS
BEGIN
   UPDATE PROMOTORES
      SET StsPromotor = 'SUSPE',
          FecSts      = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodPromotor = cCodPromotor;
END SUSPENDER_PROMOTOR;

FUNCTION NOMBRE_PROMOTOR(nCodCia NUMBER, cCodPromotor VARCHAR2) RETURN VARCHAR2 IS
cNombre       VARCHAR2(500);
BEGIN
   BEGIN
      SELECT TRIM(Nombre) || ' ' || TRIM(Apellido_Paterno) || ' ' || TRIM(Apellido_Materno)
        INTO cNombre
        FROM PERSONA_NATURAL_JURIDICA
       WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN
             (SELECT TipoDocIdentProm, NumDocIdentProm
                FROM PROMOTORES
               WHERE CodCia        = nCodCia
                 AND CodPromotor   = cCodPromotor);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNombre := 'Promotor - NO EXISTE';
   END;
   RETURN(cNombre);
END NOMBRE_PROMOTOR;

FUNCTION VERIFICA_NIVEL(nCodCia NUMBER, cCodPromotor VARCHAR2, nPosicion NUMBER) RETURN VARCHAR2 IS
cExiste   VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM PROMOTORES
       WHERE CodCia        = nCodCia
         AND SUBSTR(CodPromotor,1,nPosicion) = SUBSTR(cCodPromotor,1,nPosicion);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste  := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste  := 'S';
   END;
   RETURN(cExiste);
END VERIFICA_NIVEL;

FUNCTION EXISTE_PROMOTOR(nCodCia NUMBER, cCodPromotor VARCHAR2) RETURN VARCHAR2 IS
cExiste   VARCHAR2(1);
BEGIN
    BEGIN
       SELECT 'S'
         INTO cExiste
         FROM PROMOTORES
        WHERE CodCia      = nCodCia
          AND CodPromotor = cCodPromotor;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste  := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste  := 'S';
   END;
   RETURN(cExiste);
END EXISTE_PROMOTOR;

PROCEDURE CAMBIAR_PROMOTOR(nCodCia NUMBER, cCodPromotor VARCHAR2, cMotivoBaja VARCHAR2, dFecBaja DATE) IS
BEGIN
   UPDATE PROMOTORES
      SET CodMotivoBaja = cMotivoBaja,
          FecBaja       = dFecBaja,
          StsPromotor   = 'REASIG',
          FecSts        = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodPromotor = cCodPromotor;
END CAMBIAR_PROMOTOR;

END OC_PROMOTORES;
/
