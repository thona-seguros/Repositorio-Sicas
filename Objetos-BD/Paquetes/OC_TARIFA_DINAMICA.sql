CREATE OR REPLACE PACKAGE oc_tarifa_dinamica IS

  FUNCTION NUMERO_TARIFA RETURN NUMBER;
  PROCEDURE CONFIGURAR (nIdTarifa NUMBER);
  PROCEDURE ACTIVAR (nIdTarifa NUMBER);
  PROCEDURE SUSPENDER (nIdTarifa NUMBER);
  PROCEDURE COPIAR (nIdTarifaOrig NUMBER, nIdTarifaDest NUMBER);
  FUNCTION TARIFA_VIGENTE(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                           cPlanCob VARCHAR2, dFecTarifa DATE) RETURN NUMBER;

END OC_TARIFA_DINAMICA;
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY oc_tarifa_dinamica IS

FUNCTION NUMERO_TARIFA RETURN NUMBER IS
nIdTarifa     TARIFA_DINAMICA.IdTarifa%TYPE;
BEGIN
   SELECT NVL(MAX(IdTarifa),0)+1
     INTO nIdTarifa
     FROM TARIFA_DINAMICA;
   RETURN(nIdTarifa);
END NUMERO_TARIFA;

PROCEDURE CONFIGURAR (nIdTarifa NUMBER) IS
BEGIN
   UPDATE TARIFA_DINAMICA
           SET StsTarifa    = 'CONFIG',
          FecSts       = TRUNC(SYSDATE),
          CodUsuario   = USER,
          FecUltCambio = TRUNC(SYSDATE)
         WHERE IdTarifa     = nIdTarifa;
END CONFIGURAR;

PROCEDURE SUSPENDER (nIdTarifa NUMBER) IS
BEGIN
   UPDATE TARIFA_DINAMICA
           SET StsTarifa    = 'SUSPEN',
          FecSts       = TRUNC(SYSDATE),
          CodUsuario   = USER,
          FecUltCambio = TRUNC(SYSDATE)
         WHERE IdTarifa     = nIdTarifa;
END SUSPENDER;

PROCEDURE ACTIVAR (nIdTarifa NUMBER) IS
BEGIN
   UPDATE TARIFA_DINAMICA
           SET StsTarifa    = 'ACTIVA',
          FecSts       = TRUNC(SYSDATE),
          CodUsuario   = USER,
          FecUltCambio = TRUNC(SYSDATE)
         WHERE IdTarifa     = nIdTarifa;
END ACTIVAR;

PROCEDURE COPIAR (nIdTarifaOrig NUMBER, nIdTarifaDest NUMBER) IS
BEGIN
   BEGIN
      INSERT INTO TARIFA_DINAMICA
            (IdTarifa, CodCia, CodEmpresa, IdTipoSeg, PlanCob,
             FecIniTarifa, FecFinTarifa, ObservTarifa, StsTarifa,
             FecSts, CodUsuario, FecUltCambio)
      SELECT nIdTarifaDest, CodCia, CodEmpresa, IdTipoSeg, PlanCob,
             FecIniTarifa, FecFinTarifa, ObservTarifa, 'CFG',
             TRUNC(SYSDATE), USER, TRUNC(SYSDATE)
        FROM TARIFA_DINAMICA
       WHERE IdTarifa   = nIdTarifaOrig;
   EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Realizar la Copia de TARIFA_DINAMICA,  '|| SQLERRM);
   END;
   BEGIN OC_TARIFA_DINAMICA_DET.COPIAR (nIdTarifaOrig, nIdTarifaDest);
      OC_TARIFA_DINAMICA_FORMULA.COPIAR(nIdTarifaOrig, nIdTarifaDest);
   END;
END COPIAR;

FUNCTION TARIFA_VIGENTE(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                        cPlanCob VARCHAR2, dFecTarifa DATE) RETURN NUMBER IS
nIdTarifa   TARIFA_DINAMICA.IdTarifa%TYPE;
BEGIN
   SELECT NVL(MAX(IdTarifa),0)
     INTO nIdTarifa
     FROM TARIFA_DINAMICA
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdTipoSeg     = cIdTipoSeg
      AND PlanCob       = cPlanCob
      AND FecIniTarifa <= dFecTarifa
      AND FecFinTarifa >= dFecTarifa
      AND StsTarifa     = 'ACTIVA';

   RETURN(nIdTarifa);
END TARIFA_VIGENTE;
  
END OC_TARIFA_DINAMICA;
