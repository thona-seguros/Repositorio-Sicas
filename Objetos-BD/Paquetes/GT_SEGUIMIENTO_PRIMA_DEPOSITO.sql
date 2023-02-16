CREATE OR REPLACE PACKAGE GT_SEGUIMIENTO_PRIMA_DEPOSITO IS

FUNCTION CORRELATIVO(nCodCia NUMBER, nIdPrimaDeposito NUMBER) RETURN NUMBER;

PROCEDURE ACTIVAR(nCodCia NUMBER, nIdPrimaDeposito NUMBER, nIdSeguimiento NUMBER);

PROCEDURE ANULAR(nCodCia NUMBER, nIdPrimaDeposito NUMBER, nIdSeguimiento NUMBER);

END GT_SEGUIMIENTO_PRIMA_DEPOSITO;
/

CREATE OR REPLACE PACKAGE BODY GT_SEGUIMIENTO_PRIMA_DEPOSITO IS

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
