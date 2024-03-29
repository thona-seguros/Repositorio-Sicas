--
-- OC_DETALLE_SINIESTRO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DUAL (Synonym)
--   DETALLE_SINIESTRO (Table)
--   SINIESTRO (Table)
--   CONFIG_TRANSAC_SINIESTROS (Table)
--   COBERTURA_SINIESTRO (Table)
--   PAGOS_POR_OTROS_CONCEPTOS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_DETALLE_SINIESTRO IS

PROCEDURE ACTUALIZA_RESERVAS(nIdSiniestro NUMBER);

END OC_DETALLE_SINIESTRO;
/

--
-- OC_DETALLE_SINIESTRO  (Package Body) 
--
--  Dependencies: 
--   OC_DETALLE_SINIESTRO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_DETALLE_SINIESTRO IS
--
-- Se ajustan detalles de correccion o mejora    20190726 --MEJSIN
--
PROCEDURE ACTUALIZA_RESERVAS(nIdSiniestro NUMBER) IS
dFecHoy                      DATE;
nCobertLocal                 COBERTURA_SINIESTRO.Monto_Reservado_Local%TYPE;
nCobertMoneda                COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;
nMonto_Reservado_Local_otro  PAGOS_POR_OTROS_CONCEPTOS.Monto_Reservado_Local%TYPE;   --MEJSIN
nMonto_Reservado_Moneda_otro PAGOS_POR_OTROS_CONCEPTOS.Monto_Reservado_Moneda%TYPE;  --MEJSIN
nTotSiniLocal                SINIESTRO.Monto_Reserva_Local%TYPE;
nTotSiniMoneda               SINIESTRO.Monto_Reserva_Moneda%TYPE;
--
CURSOR DET_SIN_Q IS
   SELECT IdDetSin
     FROM DETALLE_SINIESTRO
    WHERE IdSiniestro = nIdSiniestro;
--
BEGIN
  --
  SELECT SYSDATE
    INTO dFecHoy
    FROM DUAL;
  --
  nTotSiniLocal  := 0;
  nTotSiniMoneda := 0;
  --
  FOR X IN DET_SIN_Q LOOP
    --
    BEGIN
      SELECT NVL(SUM(DECODE (CN.SIGNO,'-',CS.Monto_Reservado_Local * -1,CS.Monto_Reservado_Local)),0), 
             NVL(SUM(DECODE (CN.SIGNO,'-',CS.Monto_Reservado_Moneda * -1,CS.Monto_Reservado_Moneda)),0)
        INTO nCobertLocal,
             nCobertMoneda
        FROM COBERTURA_SINIESTRO CS, 
             CONFIG_TRANSAC_SINIESTROS CN 
       WHERE CS.CodTransac    = CN.CodTransac
         AND CS.IdSiniestro   = nIdSiniestro
         AND CS.IdDetSin      = X.IdDetSin
         AND CS.StsCobertura != 'ANU' ;
      --
      SELECT NVL(SUM(Monto_Reservado_Local),0),
             NVL(SUM(Monto_Reservado_Moneda),0)
        INTO nMonto_Reservado_Local_otro,
             nMonto_Reservado_Moneda_otro
        FROM PAGOS_POR_OTROS_CONCEPTOS
       WHERE IdSiniestro = nIdSiniestro
         AND IdDetSin    = X.IdDetSin;
      --
      UPDATE DETALLE_SINIESTRO
         SET Monto_Reservado_Local  = NVL(nCobertLocal,0)  + NVL(nMonto_Reservado_Local_otro,0), --MEJSIN
             Monto_Reservado_Moneda = NVL(nCobertMoneda,0) + NVL(nMonto_Reservado_Moneda_otro,0) --MEJSIN
       WHERE IdSiniestro = nIdSiniestro
         AND IdDetSin    = X.IdDetSin;
      --
      nTotSiniLocal  := NVL(nCobertLocal,0)  + NVL(nMonto_Reservado_Local_otro,0);
      nTotSiniMoneda := NVL(nCobertMoneda,0) + NVL(nMonto_Reservado_Moneda_otro,0);
      --
    END;
    --
  END LOOP;
  --
  UPDATE SINIESTRO
     SET Monto_Reserva_Local  = NVL(nTotSiniLocal,0),
         Monto_Reserva_Moneda = NVL(nTotSiniMoneda,0)
   WHERE IdSiniestro   = nIdSiniestro;
  --
END ACTUALIZA_RESERVAS;

END OC_DETALLE_SINIESTRO;
/
