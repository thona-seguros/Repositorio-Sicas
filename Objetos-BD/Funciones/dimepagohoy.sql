--
-- DIMEPAGOHOY  (Function) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DBMS_OUTPUT (Synonym)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--   SALDOS_COMISIONES_PAGOS (Table)
--
CREATE OR REPLACE FUNCTION SICAS_OC.DimePagoHoy(vCia      IN saldos_comisiones_pagos.cd_cia%TYPE   ,
                     vAgente   IN saldos_comisiones_pagos.cd_agente%TYPE,
                     vTipoRamo IN saldos_comisiones_pagos.cd_tipo_ramo%TYPE,
                     vFeIni    IN saldos_comisiones_pagos.fe_pago%TYPE  ,
                     vFeFin    IN saldos_comisiones_pagos.fe_pago%TYPE  ,
                     vConcepto IN saldos_comisiones_pagos.ds_concepto_pago%TYPE DEFAULT 'NADA') RETURN NUMBER IS
         MontoPago NUMBER(18,2);

BEGIN
      IF vConcepto = 'NADA' THEN 
            SELECT NVL(SUM(b2.mt_pago),0)
              INTO MontoPago
              FROM saldos_comisiones_pagos b2
             WHERE b2.cd_cia       = vCia
               AND b2.cd_agente    = vAgente
               AND b2.cd_tipo_ramo = vTipoRamo
               AND b2.fe_pago BETWEEN vFeIni
                                  AND vFeFin;
      ELSE 
           IF vConcepto = 'COMISI' then 
            SELECT NVL(SUM(b2.mt_pago),0)
              INTO MontoPago
              FROM saldos_comisiones_pagos b2
             WHERE b2.cd_cia           = vCia
               AND b2.cd_agente        = vAgente
               AND b2.cd_tipo_ramo     = vTipoRamo
               AND b2.ds_concepto_pago IN ('COMISI','HONORA','UDI','AJUCOM','AJUHON') 
               AND b2.fe_pago BETWEEN vFeIni
                                  AND vFeFin;
            ELSE 
            SELECT NVL(SUM(b2.mt_pago),0)
              INTO MontoPago
              FROM saldos_comisiones_pagos b2
             WHERE b2.cd_cia           = vCia
               AND b2.cd_agente        = vAgente
               AND b2.cd_tipo_ramo     = vTipoRamo
               AND b2.ds_concepto_pago = vConcepto 
               AND b2.fe_pago BETWEEN vFeIni
                                  AND vFeFin;
            END IF;
      END IF;
      RETURN NVL(MontoPago,0);
      
EXCEPTION
     WHEN no_data_found THEN
          RETURN 0;
     WHEN others THEN
          dbms_output.put_line(sqlerrm);
          RETURN 0;
END DimePagoHoy;
/

--
-- DIMEPAGOHOY  (Synonym) 
--
--  Dependencies: 
--   DIMEPAGOHOY (Function)
--
CREATE OR REPLACE PUBLIC SYNONYM DIMEPAGOHOY FOR SICAS_OC.DIMEPAGOHOY
/


GRANT EXECUTE, DEBUG ON SICAS_OC.DIMEPAGOHOY TO PUBLIC
/
