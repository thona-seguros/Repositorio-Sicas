CREATE OR REPLACE PACKAGE OC_COMPONENTES_SINIESTRO IS
--
-- CREACION 2021/12/15
-- BITACORA DE CAMBIOS 
-- 
PROCEDURE VALIDA_CODIGO_PAGO(NCODCIA            NUMBER,
                             NCODEMPRESA        NUMBER,
                             NIDSINIESTRO       NUMBER,
                             CIDTIPOSEG         VARCHAR2,
                             CPLANCOB           VARCHAR2,
                             CCOD_PAGO          VARCHAR2,
                             NDEDUCIBLE_PAG     NUMBER,
                             NDEDUCIBLE_EVENTOS NUMBER,           
                             NCOASEGURO_PAG     NUMBER,                                                 
                             NMONTO_MONEDA      NUMBER,
                             CMENSAJE           OUT VARCHAR2);

END OC_COMPONENTES_SINIESTRO;
/
CREATE OR REPLACE PACKAGE BODY OC_COMPONENTES_SINIESTRO IS
-- 
PROCEDURE VALIDA_CODIGO_PAGO(NCODCIA            NUMBER,
                             NCODEMPRESA        NUMBER,
                             NIDSINIESTRO       NUMBER,
                             CIDTIPOSEG         VARCHAR2,
                             CPLANCOB           VARCHAR2,
                             CCOD_PAGO          VARCHAR2,
                             NDEDUCIBLE_PAG     NUMBER,
                             NDEDUCIBLE_EVENTOS NUMBER,           
                             NCOASEGURO_PAG     NUMBER,                                                 
                             NMONTO_MONEDA      NUMBER,
                             CMENSAJE           OUT VARCHAR2) IS
--               
NSUMA_ASEG_MAX           PLAN_COBERTURAS.SUMA_ASEG_MAX%TYPE;
NMONTO_TOTAL_COASEGURO   APROBACIONES.MONTO_LOCAL%TYPE;
NPORCENTAJE              NUMBER;
BEGIN
	--
  CMENSAJE       := '';
  NSUMA_ASEG_MAX := 0;
  NMONTO_TOTAL_COASEGURO := 0;
  --
  IF CCOD_PAGO = 'DEDUCI' THEN  
     IF NDEDUCIBLE_EVENTOS >= 2 THEN
        CMENSAJE := 'Con este evento se excede el limite de dos por Poliza - Familia';
     END IF;
  ELSIF CCOD_PAGO = 'COASEG' THEN
     BEGIN
       SELECT PC.SUMA_ASEG_MAX
         INTO NSUMA_ASEG_MAX
         FROM PLAN_COBERTURAS PC
        WHERE PC.IDTIPOSEG  = CIDTIPOSEG
          AND PC.CODEMPRESA = NCODCIA
          AND PC.CODCIA     = NCODEMPRESA
          AND PC.PLANCOB    = CPLANCOB;
     EXCEPTION
       WHEN OTHERS THEN
            NSUMA_ASEG_MAX := 0;
     END;        
     --
     NMONTO_TOTAL_COASEGURO := NCOASEGURO_PAG + NMONTO_MONEDA;
     --
     NPORCENTAJE := (NMONTO_TOTAL_COASEGURO * 100) / NSUMA_ASEG_MAX;
     --
     IF NPORCENTAJE > 20 THEN
        CMENSAJE := 'Con este evento se excede el 20 % de la suma asegurada: Suma Asegurada =  '||NSUMA_ASEG_MAX||
                    '     Monto Sumatoria de Coaseguros = '||NMONTO_TOTAL_COASEGURO;
     END IF;
  END IF;
  --
END VALIDA_CODIGO_PAGO;
--
--
END OC_COMPONENTES_SINIESTRO;
/
