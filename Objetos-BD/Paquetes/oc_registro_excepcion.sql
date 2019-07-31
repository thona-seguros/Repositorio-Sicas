--
-- OC_REGISTRO_EXCEPCION  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   REGISTRO_EXCEPCION (Table)
--   REGISTRO_EXCEPCION (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_REGISTRO_EXCEPCION IS
   PROCEDURE INSERTAR(nCodCia         IN REGISTRO_EXCEPCION.CodCia%TYPE,
                      nIdProceso      IN REGISTRO_EXCEPCION.IdProceso%TYPE,
                      nIdFactura      IN REGISTRO_EXCEPCION.IdFactura%TYPE,
                      nIdExcepcion    IN REGISTRO_EXCEPCION.IdExcepcion%TYPE,
                      dFechaProbCobro IN REGISTRO_EXCEPCION.FechaProbCobro%TYPE,
                      cMot_Excepcion  IN REGISTRO_EXCEPCION.Mot_Excepcion%TYPE);

    FUNCTION EXISTE_REGISTRO (nCodCia    IN REGISTRO_EXCEPCION.CodCia%TYPE,
                              nIdProceso IN REGISTRO_EXCEPCION.IdProceso%TYPE,
                              nIdFactura IN REGISTRO_EXCEPCION.IdFactura%TYPE) RETURN VARCHAR2;

    PROCEDURE REVERSA_EXCEPCION(nCodCia      IN REGISTRO_EXCEPCION.CodCia%TYPE,
                                nIdProceso   IN REGISTRO_EXCEPCION.IdProceso%TYPE,
                                nIdFactura   IN REGISTRO_EXCEPCION.IdFactura%TYPE,
                                nIdExcepcion IN REGISTRO_EXCEPCION.IdExcepcion%TYPE );

    FUNCTION NUMERO_EXCEPCION RETURN NUMBER;
    
    FUNCTION MOTIVO_EXCEPCION(nCodCia IN NUMBER, nIdProceso  IN NUMBER, nIdFactura IN NUMBER, nIdExcepcion IN NUMBER) RETURN VARCHAR2;

END; -- Package spec
/

--
-- OC_REGISTRO_EXCEPCION  (Package Body) 
--
--  Dependencies: 
--   OC_REGISTRO_EXCEPCION (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_REGISTRO_EXCEPCION IS
PROCEDURE INSERTAR(nCodCia         IN REGISTRO_EXCEPCION.CodCia%TYPE,
                   nIdProceso      IN REGISTRO_EXCEPCION.IdProceso%TYPE,
                   nIdFactura      IN REGISTRO_EXCEPCION.IdFactura%TYPE,
                   nIdExcepcion    IN REGISTRO_EXCEPCION.IdExcepcion%TYPE,
                   dFechaProbCobro IN REGISTRO_EXCEPCION.FechaProbCobro%TYPE,
                   cMot_Excepcion  IN REGISTRO_EXCEPCION.Mot_Excepcion%TYPE) IS
BEGIN
   INSERT INTO REGISTRO_EXCEPCION
          (CodCia, IdProceso, IdFactura, IdExcepcion,
           FechaProbCobro, Mot_Excepcion)
   VALUES (nCodCia, nIdProceso, nIdFactura, nIdExcepcion,
           dFechaProbCobro, cMot_Excepcion);
END;

FUNCTION EXISTE_REGISTRO(nCodCia    IN REGISTRO_EXCEPCION.CodCia%TYPE,
                         nIdProceso IN REGISTRO_EXCEPCION.IdProceso%TYPE,
                         nIdFactura IN REGISTRO_EXCEPCION.IdFactura%TYPE) RETURN VARCHAR2 IS
nExiste   VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO nExiste
        FROM REGISTRO_EXCEPCION
       WHERE CodCia    = nCodCia
         AND IdProceso = nIdProceso
         AND IdFactura = nIdFactura;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nExiste:='N';
   END;

   RETURN nExiste;
END EXISTE_REGISTRO;

PROCEDURE REVERSA_EXCEPCION(nCodCia      IN REGISTRO_EXCEPCION.CodCia%TYPE,
                            nIdProceso   IN REGISTRO_EXCEPCION.IdProceso%TYPE,
                            nIdFactura   IN REGISTRO_EXCEPCION.IdFactura%TYPE,
                            nIdExcepcion IN REGISTRO_EXCEPCION.IdExcepcion%TYPE ) IS
BEGIN
   DELETE REGISTRO_EXCEPCION
    WHERE CodCia      = nCodCia
      AND IdProceso   = nIdProceso
      AND IdFactura   = nIdFactura
      AND IdExcepcion = nIdExcepcion;
 END REVERSA_EXCEPCION;

FUNCTION NUMERO_EXCEPCION RETURN NUMBER IS
nIdExcepcion     REGISTRO_EXCEPCION.IdExcepcion%TYPE;
BEGIN
   SELECT NVL(MAX(IdExcepcion),0)+1
     INTO nIdExcepcion
     FROM REGISTRO_EXCEPCION;
   
   RETURN(nIdExcepcion);
END NUMERO_EXCEPCION;

FUNCTION MOTIVO_EXCEPCION(nCodCia IN NUMBER, nIdProceso  IN NUMBER, nIdFactura IN NUMBER, nIdExcepcion IN NUMBER) RETURN VARCHAR2 IS
    cMot_Excepcion  REGISTRO_EXCEPCION.Mot_Excepcion%TYPE;
BEGIN
    BEGIN
        SELECT NVL(Mot_Excepcion,'NA')
          INTO cMot_Excepcion
          FROM REGISTRO_EXCEPCION
         WHERE CodCia      = nCodCia
           AND IdProceso   = nIdProceso
           AND IdFactura   = nIdFactura
           AND IdExcepcion = nIdExcepcion;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            cMot_Excepcion := 'NA';
    END;
    RETURN cMot_Excepcion;
END MOTIVO_EXCEPCION;
    
END OC_REGISTRO_EXCEPCION;
/
