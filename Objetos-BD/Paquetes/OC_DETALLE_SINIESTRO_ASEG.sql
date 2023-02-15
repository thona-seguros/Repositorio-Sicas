CREATE OR REPLACE PACKAGE OC_DETALLE_SINIESTRO_ASEG IS

PROCEDURE ACTUALIZA_RESERVAS(nIdSiniestro NUMBER);

END OC_DETALLE_SINIESTRO_ASEG;
/

CREATE OR REPLACE PACKAGE BODY OC_DETALLE_SINIESTRO_ASEG IS
--
-- Se ajustan detalles de correccion o mejora    20190726 --MEJSIN
--
PROCEDURE ACTUALIZA_RESERVAS(nIdSiniestro NUMBER) IS
dFecHoy          DATE;
nCobertLocal     COBERTURA_SINIESTRO.Monto_Reservado_Local%TYPE;
nCobertMoneda    COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;
nMonto_Reservado_Local_otro  PAGOS_POR_OTROS_CONCEPTOS.Monto_Reservado_Local%TYPE;   --MEJSIN
nMonto_Reservado_Moneda_otro PAGOS_POR_OTROS_CONCEPTOS.Monto_Reservado_Moneda%TYPE;  --MEJSIN
nTotSiniLocal    SINIESTRO.Monto_Reserva_Local%TYPE;
nTotSiniMoneda   SINIESTRO.Monto_Reserva_Moneda%TYPE;
--
CURSOR DET_SIN_Q IS
   SELECT IdDetSin, Cod_Asegurado
     FROM DETALLE_SINIESTRO_ASEG
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
      SELECT NVL(SUM(DECODE (CN.SIGNO,'-',CS.Monto_Reservado_Local * -1,CS.Monto_Reservado_Local)),0),   --MEJSIN
             NVL(SUM(DECODE (CN.SIGNO,'-',CS.Monto_Reservado_Moneda * -1,CS.Monto_Reservado_Moneda)),0)  --MEJSIN
        INTO nCobertLocal, nCobertMoneda
        FROM COBERTURA_SINIESTRO_ASEG CS, 
             CONFIG_TRANSAC_SINIESTROS CN 
       WHERE CS.CodTransac     = CN.CodTransac
         AND CS.IdSiniestro    = nIdSiniestro
         AND CS.IdDetSin       = X.IdDetSin
         AND CS.Cod_Asegurado  = X.Cod_Asegurado
         AND CS.StsCobertura  != 'ANU' ;
      --
      SELECT NVL(SUM(Monto_Reservado_Local),0), 
             NVL(SUM(Monto_Reservado_Moneda),0)
        INTO nMonto_Reservado_Local_otro,
             nMonto_Reservado_Moneda_otro
        FROM PAGOS_POR_OTROS_CONCEPTOS
       WHERE IdSiniestro = nIdSiniestro
         AND IdDetSin    = X.IdDetSin;
      --
      UPDATE DETALLE_SINIESTRO_ASEG
         SET Monto_Reservado_Local  = NVL(nCobertLocal,0) + NVL(nMonto_Reservado_Local_otro,0),
             Monto_Reservado_Moneda = NVL(nCobertLocal,0) + NVL(nMonto_Reservado_Moneda_otro,0)
       WHERE IdSiniestro   = nIdSiniestro
         AND Cod_Asegurado = X.Cod_Asegurado
         AND IdDetSin      = X.IdDetSin;
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

END OC_DETALLE_SINIESTRO_ASEG;
