FUNCTION DimeFPagoHoy(vCia      IN saldos_comisiones_pagos.cd_cia%TYPE      ,
                      vAgente   IN saldos_comisiones_pagos.cd_agente%TYPE   ,
                      vTipoRamo IN saldos_comisiones_pagos.cd_tipo_ramo%TYPE,
                      vMonto    IN saldos_comisiones_pagos.mt_pago%TYPE     ,
                      vFeIni    IN saldos_comisiones_pagos.fe_pago%TYPE     ,
                      vFeFin    IN saldos_comisiones_pagos.fe_pago%TYPE     ) RETURN DATE IS
         FeMontoPago DATE;
BEGIN
      SELECT b2.fe_pago
        INTO FeMontoPago
        FROM saldos_comisiones_pagos b2
       WHERE b2.cd_cia       = vCia
         AND b2.cd_agente    = vAgente
         AND b2.cd_tipo_ramo = vTipoRamo
         AND b2.mt_pago      = vMonto
         AND b2.fe_pago BETWEEN vFeIni
                            AND vFeFin;
      RETURN FeMontoPago;

EXCEPTION
     WHEN no_data_found THEN
          RETURN NULL;
     WHEN others THEN
          RETURN NULL;
END DimeFPagoHoy;
