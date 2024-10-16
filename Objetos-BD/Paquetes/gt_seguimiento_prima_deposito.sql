--
-- GT_SEGUIMIENTO_PRIMA_DEPOSITO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   SEGUIMIENTO_PRIMA_DEPOSITO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_SEGUIMIENTO_PRIMA_DEPOSITO IS

FUNCTION CORRELATIVO(nCodCia NUMBER, nIdPrimaDeposito NUMBER) RETURN NUMBER;

PROCEDURE ACTIVAR(nCodCia NUMBER, nIdPrimaDeposito NUMBER, nIdSeguimiento NUMBER);

PROCEDURE ANULAR(nCodCia NUMBER, nIdPrimaDeposito NUMBER, nIdSeguimiento NUMBER);

END GT_SEGUIMIENTO_PRIMA_DEPOSITO;
/

--
-- GT_SEGUIMIENTO_PRIMA_DEPOSITO  (Package Body) 
--
--  Dependencies: 
--   GT_SEGUIMIENTO_PRIMA_DEPOSITO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_SEGUIMIENTO_PRIMA_DEPOSITO IS

FUNCTION CORRELATIVO(nCodCia NUMBER, nIdPrimaDeposito NUMBER) RETURN NUMBER IS
nIdSeguimiento    SEGUIMIENTO_PRIMA_DEPOSITO.IdSeguimiento%TYPE;
BEGIN
   SELECT NVL(MAX(IdSeguimiento),0)+1
     INTO nIdSeguimiento
     FROM SEGUIMIENTO_PRIMA_DEPOSITO
    WHERE CodCia          = nCodCia
      AND IdPrimaDeposito = nIdPrimaDeposito;

   RETURN(nIdSeguimiento);
END CORRELATIVO;

PROCEDURE ACTIVAR(nCodCia NUMBER, nIdPrimaDeposito NUMBER, nIdSeguimiento NUMBER) IS
BEGIN
   UPDATE SEGUIMIENTO_PRIMA_DEPOSITO
      SET StsSeguimiento = 'ACTIVO',
          FechaSts       = SYSDATE
    WHERE CodCia           = nCodCia
      AND IdPrimaDeposito  = nIdPrimaDeposito
      AND IdSeguimiento    = nIdSeguimiento;
END ACTIVAR;

PROCEDURE ANULAR(nCodCia NUMBER, nIdPrimaDeposito NUMBER, nIdSeguimiento NUMBER) IS
BEGIN
   UPDATE SEGUIMIENTO_PRIMA_DEPOSITO
      SET StsSeguimiento = 'ANULAD',
          FechaSts       = SYSDATE
    WHERE CodCia           = nCodCia
      AND IdPrimaDeposito  = nIdPrimaDeposito
      AND IdSeguimiento    = nIdSeguimiento;
END ANULAR;

END GT_SEGUIMIENTO_PRIMA_DEPOSITO;
/
