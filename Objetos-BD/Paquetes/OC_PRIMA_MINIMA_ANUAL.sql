create or replace PACKAGE          OC_PRIMA_MINIMA_ANUAL IS
   --
   FUNCTION OBTIENE_MTOPRIMIN( nCodCia       SOLICITUD_EMISION.CodCia%TYPE
                             , nCodEmpresa   SOLICITUD_EMISION.CodEmpresa%TYPE
                             , cIdTipoSeg    SOLICITUD_EMISION.IdTipoSeg%TYPE
                             , cPlanCob      SOLICITUD_EMISION.PlanCob%TYPE
                             , cCodPlanPago  SOLICITUD_EMISION.CodPlanPago%TYPE ) RETURN NUMBER;
   --
   PROCEDURE OBTIENE_PRIMAS_SOL( nCodCia              SOLICITUD_EMISION.CodCia%TYPE
                               , nCodEmpresa          SOLICITUD_EMISION.CodEmpresa%TYPE
                               , nIdSolicitud         SOLICITUD_EMISION.IdSolicitud%TYPE
                               , nPrimaCobTotal  OUT  NUMBER
                               , nMtoPriMin      OUT  NUMBER );
   --
   PROCEDURE VALIDA_PRIMAS_SOL( nCodCia       SOLICITUD_EMISION.CodCia%TYPE
                              , nCodEmpresa   SOLICITUD_EMISION.CodEmpresa%TYPE
                              , nIdSolicitud  SOLICITUD_EMISION.IdSolicitud%TYPE );
   --
   PROCEDURE ACTUALIZA_COBERT_COTIZACION( nCodCia         COTIZACIONES.CodCia%TYPE
                                        , nCodEmpresa     COTIZACIONES.CodEmpresa%TYPE
                                        , nIdCotizacion   COTIZACIONES.IdCotizacion%TYPE
                                        , cCodPlanPago    COTIZACIONES.CodPlanPago%TYPE
                                        , nPrimaCobTotal  NUMBER
                                        , nMtoPriMin      PLAN_DE_PAGOS.MtoPriMin%TYPE );
   --
   PROCEDURE ACTUALIZA_COBERT_POLIZA( nCodCia         POLIZAS.CodCia%TYPE
                                    , nCodEmpresa     POLIZAS.CodEmpresa%TYPE
                                    , nIdPoliza       POLIZAS.IdPoliza%TYPE
                                    , cIndPolCol      POLIZAS.IndPolCol%TYPE
                                    , nPrimaCobTotal  NUMBER
                                    , nMtoPriMin      PLAN_DE_PAGOS.MtoPriMin%TYPE );
   --
   PROCEDURE ACTUALIZA_COBERT_EMIFACIL( nCodCia         SOLICITUD_EMISION.CodCia%TYPE
                                      , nCodEmpresa     SOLICITUD_EMISION.CodEmpresa%TYPE
                                      , nIdSolicitud    SOLICITUD_EMISION.IdSolicitud%TYPE
                                      , nPrimaCobTotal  NUMBER
                                      , nMtoPriMin      PLAN_DE_PAGOS.MtoPriMin%TYPE );
   --
   PROCEDURE OBTIENE_PRIMAS_COTIZA( nCodCia             COTIZACIONES.CodCia%TYPE
                                  , nCodEmpresa         COTIZACIONES.CodEmpresa%TYPE
                                  , nIdCotizacion       COTIZACIONES.IdCotizacion%TYPE
                                  , nPrimaCobTotal      OUT  NUMBER
                                  , nMtoPriMin          OUT  NUMBER );
   --
   PROCEDURE VALIDA_PRIMAS_COTIZA( nCodCia        COTIZACIONES.CodCia%TYPE
                                 , nCodEmpresa    COTIZACIONES.CodEmpresa%TYPE
                                 , nIdCotizacion  COTIZACIONES.IdCotizacion%TYPE );
   --
   PROCEDURE OBTIENE_PRIMAS_POLIZA( nCodCia             POLIZAS.CodCia%TYPE
                                  , nCodEmpresa         POLIZAS.CodEmpresa%TYPE
                                  , nIdPoliza           POLIZAS.IdPoliza%TYPE
                                  , nPrimaCobTotal      OUT  NUMBER
                                  , nMtoPriMin          OUT  NUMBER );
   --
   PROCEDURE VALIDA_PRIMAS_POLIZA( nCodCia        POLIZAS.CodCia%TYPE
                                 , nCodEmpresa    POLIZAS.CodEmpresa%TYPE
                                 , nIdPoliza      POLIZAS.IdPoliza%TYPE );
   --
END OC_PRIMA_MINIMA_ANUAL;
--
/
create or replace PACKAGE BODY          OC_PRIMA_MINIMA_ANUAL IS
   --
   FUNCTION OBTIENE_MTOPRIMIN( nCodCia       SOLICITUD_EMISION.CodCia%TYPE
                             , nCodEmpresa   SOLICITUD_EMISION.CodEmpresa%TYPE
                             , cIdTipoSeg    SOLICITUD_EMISION.IdTipoSeg%TYPE
                             , cPlanCob      SOLICITUD_EMISION.PlanCob%TYPE
                             , cCodPlanPago  SOLICITUD_EMISION.CodPlanPago%TYPE ) RETURN NUMBER IS
      nMtoPriMin  PLAN_DE_PAGOS.MtoPriMin%TYPE;
      cIndPriMin  PLAN_DE_PAGOS.IndPriMin%TYPE;
   BEGIN
      SELECT MtoPriMin, IndPriMin
      INTO   nMtoPriMin, cIndPriMin
      FROM   PLAN_COBERTURAS
      WHERE  IdTipoSeg  = cIdTipoSeg
        AND  CodEmpresa = nCodEmpresa
        AND  CodCia     = nCodCia
        AND  PlanCob    = cPlanCob;
      --
      IF NVL(cIndPriMin, 'N') = 'N' THEN
	      SELECT MtoPriMin
	      INTO   nMtoPriMin
         FROM   PLAN_DE_PAGOS
         WHERE  CodPlanPago = cCodPlanPago
           AND  CodEmpresa  = nCodEmpresa
           AND  CodCia      = nCodCia;
      END IF;
      --
      RETURN(nMtoPriMin);
   END OBTIENE_MTOPRIMIN;
   --
   PROCEDURE OBTIENE_PRIMAS_SOL( nCodCia              SOLICITUD_EMISION.CodCia%TYPE
                               , nCodEmpresa          SOLICITUD_EMISION.CodEmpresa%TYPE
                               , nIdSolicitud         SOLICITUD_EMISION.IdSolicitud%TYPE
                               , nPrimaCobTotal  OUT  NUMBER
                               , nMtoPriMin      OUT  NUMBER ) IS
      cIndAsegModelo  SOLICITUD_EMISION.IndAsegModelo%TYPE;
      cIdTipoSeg      SOLICITUD_EMISION.IdTipoSeg%TYPE;
      cPlanCob        SOLICITUD_EMISION.PlanCob%TYPE;
      cCodPlanPago    SOLICITUD_EMISION.CodPlanPago%TYPE;
      nCantAseg       NUMBER := 0;
      cControlErr     VARCHAR2(500);
   BEGIN
      IF nIdSolicitud IS NOT NULL THEN
         cControlErr := 'Solicitud de Emisión: ' || nIdSolicitud;
         --
         SELECT IndAsegModelo, IdTipoSeg, PlanCob, CodPlanPago
         INTO   cIndAsegModelo, cIdTipoSeg, cPlanCob, cCodPlanPago
         FROM   SOLICITUD_EMISION
         WHERE  CodCia      = nCodCia
           AND  CodEmpresa  = nCodEmpresa
           AND  IdSolicitud = nIdSolicitud;
         --
         IF NVL(cIndAsegModelo, 'N') = 'N' THEN
            SELECT COUNT(*)
            INTO   nCantAseg
            FROM   SOLICITUD_DETALLE_ASEG
            WHERE  CodCia      = nCodCia
              AND  CodEmpresa  = nCodEmpresa
              AND  IdSolicitud = nIdSolicitud;
         ELSE
            nCantAseg := 1;
         END IF;
         --
         --Obtengo la Prima Anualizada y la multiplico por la cantidad de asegurados
         SELECT SUM(Prima_Moneda) * nCantAseg
         INTO   nPrimaCobTotal
         FROM   SOLICITUD_COBERTURAS
         WHERE  CodCia      = nCodCia
           AND  CodEmpresa  = nCodEmpresa
           AND  IdSolicitud = nIdSolicitud;
      END IF;
      --
      --Obtengo la Prima Mínima Anual Configurada
	   --
      nMtoPriMin := OC_PRIMA_MINIMA_ANUAL.OBTIENE_MTOPRIMIN( nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, cCodPlanPago );
      --
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20225, 'Error al Validar la ' || cControlErr || ' -- ' || SQLERRM);
   END OBTIENE_PRIMAS_SOL;
   --
   PROCEDURE VALIDA_PRIMAS_SOL( nCodCia       SOLICITUD_EMISION.CodCia%TYPE
                              , nCodEmpresa   SOLICITUD_EMISION.CodEmpresa%TYPE
                              , nIdSolicitud  SOLICITUD_EMISION.IdSolicitud%TYPE ) IS
      cIndPriMin      SOLICITUD_EMISION.IndPriMin%TYPE;
      nPrimaCobTotal  NUMBER(18,2);
      nMtoPriMin      NUMBER(18,2);
   BEGIN
      SELECT IndPriMin
      INTO   cIndPriMin
      FROM   SOLICITUD_EMISION
      WHERE  CodCia      = nCodCia
        AND  CodEmpresa  = nCodEmpresa
        AND  IdSolicitud = nIdSolicitud;
      --
      IF cIndPriMin = 'S' THEN
      	OC_PRIMA_MINIMA_ANUAL.OBTIENE_PRIMAS_SOL( nCodCia, nCodEmpresa, nIdSolicitud, nPrimaCobTotal, nMtoPriMin );
         --
         IF nPrimaCobTotal < nMtoPriMin THEN
            OC_PRIMA_MINIMA_ANUAL.ACTUALIZA_COBERT_EMIFACIL( nCodCia, nCodEmpresa, nIdSolicitud, nPrimaCobTotal, nMtoPriMin );
         END IF;
      END IF;
   END VALIDA_PRIMAS_SOL;
   --
   PROCEDURE ACTUALIZA_COBERT_COTIZACION( nCodCia         COTIZACIONES.CodCia%TYPE
                                        , nCodEmpresa     COTIZACIONES.CodEmpresa%TYPE
                                        , nIdCotizacion   COTIZACIONES.IdCotizacion%TYPE
                                        , cCodPlanPago    COTIZACIONES.CodPlanPago%TYPE
                                        , nPrimaCobTotal  NUMBER
                                        , nMtoPriMin      PLAN_DE_PAGOS.MtoPriMin%TYPE ) IS
      nFactorDiferencia  NUMBER(24,8);
      cIdTipoSeg         COTIZACIONES.IdTipoSeg%TYPE;
      cPlanCob           COTIZACIONES.PlanCob%TYPE;
      nTasa              COTIZACIONES_COBERTURAS.Tasa%TYPE;
      nIdetCotizacion2   COTIZACIONES_COBERTURAS.IdetCotizacion%TYPE;
      cCodCobert2        COTIZACIONES_COBERTURAS.CodCobert%TYPE;
      nIdetCotizacion3   COTIZACIONES_COBERT_ASEG.IdetCotizacion%TYPE;
      cCodCobert3        COTIZACIONES_COBERT_ASEG.CodCobert%TYPE;
      nIdAsegurado3      COTIZACIONES_COBERT_ASEG.IdAsegurado%TYPE;
      nPrimaCobTotal_2   NUMBER(24,8);
      nPrimaCobTotal_3   NUMBER(24,8);
      nDiferencia_1      NUMBER(24,8);
      nDiferencia_2      NUMBER(24,8);
      nNumAsegurado      NUMBER;
      nPrimaXaseg        NUMBER(24,8);
      nTotalPrimaAseg    NUMBER(24,8);
      nPrimaMayAseg      NUMBER(24,8);
      --
      CURSOR c_Coberturas1 IS
             SELECT CodCobert, Tasa, IdetCotizacion
             FROM   COTIZACIONES_COBERTURAS
             WHERE  CodCia       = nCodCia
               AND  CodEmpresa   = nCodEmpresa
               AND  IdCotizacion = nIdCotizacion;
      --
      CURSOR c_Coberturas2 IS
             SELECT CodCobert, Tasa, IdetCotizacion, IdAsegurado
             FROM   COTIZACIONES_COBERT_ASEG
             WHERE  CodCia       = nCodCia
               AND  CodEmpresa   = nCodEmpresa
               AND  IdCotizacion = nIdCotizacion;

       --
      CURSOR c_Asegurados1 IS
             SELECT IdAsegurado
             FROM   COTIZACIONES_COBERT_ASEG
             WHERE  CodCia         = nCodCia
               AND  CodEmpresa     = nCodEmpresa
               AND  IdCotizacion   = nIdCotizacion
               AND  IdetCotizacion = nIdetCotizacion3
			   GROUP BY IdAsegurado;	 

      CURSOR c_Asegurados2 IS
             SELECT IdetCotizacion
             FROM   COTIZACIONES_COBERT_ASEG
             WHERE  CodCia     = nCodCia
               AND  CodEmpresa = nCodEmpresa
               AND  IdCotizacion = nIdCotizacion
			   GROUP BY IdetCotizacion;

   BEGIN
      SELECT IdTipoSeg , PlanCob
      INTO   cIdTipoSeg, cPlanCob
      FROM   COTIZACIONES
      WHERE  CodCia       = nCodCia
        AND  CodEmpresa   = nCodEmpresa
        AND  IdCotizacion = nIdCotizacion;
      --
      nFactorDiferencia := ( nMtoPriMin / nPrimaCobTotal ) - 1;
      --
      FOR x IN c_Coberturas1 LOOP
          nTasa := x.Tasa / OC_COBERTURAS_DE_SEGUROS.TIPO_TASA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, x.CodCobert);
          --
          UPDATE COTIZACIONES_COBERTURAS
          SET    Tasa           = x.Tasa * ( 1 + nFactorDiferencia )
            ,    PrimaCobLocal  = SumaAsegCobLocal * (nTasa * ( 1 + nFactorDiferencia ))
            ,    PrimaCobMoneda = SumaAsegCobMoneda * (nTasa * ( 1 + nFactorDiferencia )) 
          WHERE  CodCia         = nCodCia
            AND  CodEmpresa     = nCodEmpresa
            AND  IdCotizacion   = nIdCotizacion
            AND  IdetCotizacion = x.IdetCotizacion
            AND  CodCobert      = x.CodCobert;

            nIdetCotizacion2:= x.IdetCotizacion;
            cCodCobert2     := x.CodCobert;

      END LOOP;
      --
      nTasa := NULL;
      --
      FOR y IN c_Coberturas2 LOOP
          nTasa := y.Tasa / OC_COBERTURAS_DE_SEGUROS.TIPO_TASA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, y.CodCobert);
          --
          UPDATE COTIZACIONES_COBERT_ASEG
          SET    Tasa           = Tasa * ( 1 + nFactorDiferencia )
            ,    PrimaCobLocal  = SumaAsegCobLocal * (nTasa * ( 1 + nFactorDiferencia ))
            ,    PrimaCobMoneda = SumaAsegCobMoneda * (nTasa * ( 1 + nFactorDiferencia )) 
          WHERE  CodCia         = nCodCia
            AND  CodEmpresa     = nCodEmpresa
            AND  IdCotizacion   = nIdCotizacion
            AND  IdetCotizacion = y.IdetCotizacion
            AND  IdAsegurado    = y.IdAsegurado
            AND  CodCobert      = y.CodCobert;

            ---nIdetCotizacion3   := y.IdetCotizacion;
            cCodCobert3        := y.CodCobert;
            nIdAsegurado3      := y.IdAsegurado;
      END LOOP;

      SELECT SUM(PrimaCobMoneda)
      INTO   nPrimaCobTotal_2
      FROM   COTIZACIONES_COBERTURAS
      WHERE  CodCia      = nCodCia
        AND  CodEmpresa  = nCodEmpresa
        AND  IdCotizacion = nIdCotizacion;

      IF NVL(nPrimaCobTotal_2,0) != 0 THEN
         nDiferencia_1 := nMtoPriMin - nPrimaCobTotal_2;
         IF nDiferencia_1 <> 0 THEN
            UPDATE COTIZACIONES_COBERTURAS
            SET    PrimaCobLocal  = PrimaCobLocal + nDiferencia_1
              ,    PrimaCobMoneda = PrimaCobMoneda + nDiferencia_1
            WHERE  CodCia         = nCodCia
            AND  CodEmpresa       = nCodEmpresa
            AND  IdCotizacion     = nIdCotizacion
            AND  IdetCotizacion   = nIdetCotizacion2
            AND  CodCobert        = cCodCobert2;
         END IF;
      ELSE
         SELECT SUM(PrimaCobMoneda)
         INTO   nPrimaCobTotal_3
         FROM   COTIZACIONES_COBERT_ASEG
         WHERE  CodCia      = nCodCia
           AND  CodEmpresa  = nCodEmpresa
           AND  IdCotizacion = nIdCotizacion;

         IF NVL(nPrimaCobTotal_3,0) != 0 THEN
            nDiferencia_2 := nMtoPriMin - nPrimaCobTotal_3;
            IF nDiferencia_2 <> 0 THEN
              SELECT COUNT(DISTINCT IdAsegurado)
              INTO nNumAsegurado
              FROM COTIZACIONES_COBERT_ASEG
              WHERE CodCia      = nCodCia
              AND  CodEmpresa   = nCodEmpresa
              AND  IdCotizacion = nIdCotizacion;

              nPrimaXaseg := nMtoPriMin / nNumAsegurado;
              FOR z IN c_Asegurados2 LOOP
                 nIdetCotizacion3:= z.IdetCotizacion;
                 FOR x IN c_Asegurados1 LOOP

                   SELECT nPrimaXaseg - SUM(PrimaCobMoneda)
                   INTO   nTotalPrimaAseg
                   FROM   COTIZACIONES_COBERT_ASEG
                   WHERE  CodCia          = nCodCia
                   AND    CodEmpresa      = nCodEmpresa
                   AND    IdCotizacion    = nIdCotizacion
                   AND    IdetCotizacion  = nIdetCotizacion3
                   AND    IdAsegurado     = x.IdAsegurado;

                   SELECT MAX(PrimaCobMoneda)
                   INTO   nPrimaMayAseg
                   FROM   COTIZACIONES_COBERT_ASEG
                   WHERE  CodCia          = nCodCia
                   AND    CodEmpresa      = nCodEmpresa
                   AND    IdCotizacion    = nIdCotizacion
                   AND    IdetCotizacion  = nIdetCotizacion3
                   AND    IdAsegurado     = x.IdAsegurado;

                   UPDATE COTIZACIONES_COBERT_ASEG
                   SET    PrimaCobLocal  =   nPrimaMayAseg + nDiferencia_2
                   ,      PrimaCobMoneda =   nPrimaMayAseg + nDiferencia_2
                   WHERE  CodCia         = nCodCia
                   AND  CodEmpresa       = nCodEmpresa
                   AND  IdCotizacion     = nIdCotizacion
                   AND  IdetCotizacion   = nIdetCotizacion3
                   AND  IdAsegurado      = x.IdAsegurado
                   AND  PrimaCobMoneda   = nPrimaMayAseg;
                 END LOOP;
              END LOOP;
            END IF;
         END IF;
      END IF;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL ACTUALIZAR LA TASA Y PRIMAS DE LA COTIZACION: ' || nIdCotizacion || ' - ' || SQLERRM);
   END ACTUALIZA_COBERT_COTIZACION;
   --
  PROCEDURE ACTUALIZA_COBERT_POLIZA( nCodCia         POLIZAS.CodCia%TYPE
                                    , nCodEmpresa     POLIZAS.CodEmpresa%TYPE
                                    , nIdPoliza       POLIZAS.IdPoliza%TYPE
                                    , cIndPolCol      POLIZAS.IndPolCol%TYPE
                                    , nPrimaCobTotal  NUMBER
                                    , nMtoPriMin      PLAN_DE_PAGOS.MtoPriMin%TYPE ) IS
      nFactorDiferencia  NUMBER(24,8);
      nTasa              COTIZACIONES_COBERTURAS.Tasa%TYPE;
      nIdetPol           DETALLE_POLIZA.IdetPol%TYPE;
      nCod_Asegu3        COBERT_ACT_ASEG.Cod_Asegurado%TYPE;
      nIdetPol3          COBERT_ACT.IdetPol%TYPE;
      cCodCobert3        COBERT_ACT.CodCobert%TYPE;
      nPrimaPolTotal_2   NUMBER(24,8);
      nPrimaPolTotal_3   NUMBER(24,8);
      nDiferencia_1      NUMBER(24,8);
      nDiferencia_2      NUMBER(24,8);
      nPrimaMayor        NUMBER(24,8);
      nNumAsegurado      NUMBER;
      nPrimaXaseg        NUMBER(24,8);
      nTotalPrimaAseg    NUMBER(24,8);
      nPrimaMayAseg      NUMBER(24,8);
      nPrimaMaxCob       NUMBER(24,8) := 0;
      --
      CURSOR c_DetallePoliza IS
             SELECT IdTipoSeg, PlanCob, IdetPol
             FROM   DETALLE_POLIZA
             WHERE  CodCia     = nCodCia
               AND  CodEmpresa = nCodEmpresa
               AND  IdPoliza   = nIdPoliza;
      --
      CURSOR c_Coberturas1 IS
             SELECT CodCobert, Tasa, Cod_Asegurado
             FROM   COBERT_ACT_ASEG
             WHERE  CodCia     = nCodCia
               AND  CodEmpresa = nCodEmpresa
               AND  IdPoliza   = nIdPoliza
               AND  IdetPol    = nIdetPol;
      --
      CURSOR c_Coberturas2 IS
             SELECT CodCobert, Tasa, Prima_Moneda
             FROM   COBERT_ACT
             WHERE  CodCia     = nCodCia
               AND  CodEmpresa = nCodEmpresa
               AND  IdPoliza   = nIdPoliza
               AND  IdetPol    = nIdetPol;

      CURSOR c_Asegurados1 IS
             SELECT Cod_Asegurado
             FROM   COBERT_ACT_ASEG
             WHERE  CodCia     = nCodCia
               AND  CodEmpresa = nCodEmpresa
               AND  IdPoliza   = nIdPoliza
               AND  IdetPol    = nIdetPol
			   GROUP BY Cod_Asegurado;

      CURSOR c_Cober IS
             SELECT CodCobert, MAX(Prima_Moneda)Prima_Moneda
             FROM   COBERT_ACT
             WHERE  CodCia   = nCodCia
               AND  CodEmpresa = nCodEmpresa
               AND  IdPoliza   = nIdPoliza
               AND  IdetPol    = nIdetPol
               GROUP BY CodCobert;

   BEGIN
      nFactorDiferencia := ( nMtoPriMin / nPrimaCobTotal ) - 1;
      --
      IF cIndPolCol = 'S' THEN
          nPrimaMayor := 0;
         FOR z IN c_DetallePoliza LOOP
             nIdetPol := z.IdetPol;
             --
             FOR x IN c_Coberturas1 LOOP
                 nTasa := x.Tasa / OC_COBERTURAS_DE_SEGUROS.TIPO_TASA(nCodCia, nCodEmpresa, z.IdTipoSeg, z.PlanCob, x.CodCobert);
                 --
                 UPDATE COBERT_ACT_ASEG
                 SET    Tasa         = x.Tasa * ( 1 + nFactorDiferencia )
                   ,    Prima_Local  = SumaAseg_Local * (nTasa * ( 1 + nFactorDiferencia ))
                   ,    Prima_Moneda = SumaAseg_Moneda * (nTasa * ( 1 + nFactorDiferencia )) 
                 WHERE  CodCia        = nCodCia
                   AND  CodEmpresa    = nCodEmpresa
                   AND  IdPoliza      = nIdPoliza
                   AND  IdetPol       = z.IdetPol
                   AND  CodCobert     = x.CodCobert
                   AND  Cod_Asegurado = x.Cod_Asegurado;   
             END LOOP;
         END LOOP;
      ELSE
         FOR z IN c_DetallePoliza LOOP
             nIdetPol := z.IdetPol;
             --
             FOR y IN c_Coberturas2 LOOP
                 nTasa := y.Tasa / OC_COBERTURAS_DE_SEGUROS.TIPO_TASA(nCodCia, nCodEmpresa, z.IdTipoSeg, z.PlanCob, y.CodCobert);
                 --
                 UPDATE COBERT_ACT
                 SET    Tasa         = Tasa * ( 1 + nFactorDiferencia )
                   ,    Prima_Local  = SumaAseg_Local * (nTasa * ( 1 + nFactorDiferencia ))
                   ,    Prima_Moneda = SumaAseg_Moneda * (nTasa * ( 1 + nFactorDiferencia )) 
                 WHERE  CodCia     = nCodCia
                   AND  CodEmpresa = nCodEmpresa
                   AND  IdPoliza   = nIdPoliza
                   AND  IdetPol    = z.IdetPol
                   AND  CodCobert  = y.CodCobert;
             END LOOP;
         END LOOP;
      END IF;

      SELECT SUM(Prima_Moneda)
      INTO   nPrimaPolTotal_2
      FROM   COBERT_ACT_ASEG
      WHERE  CodCia      = nCodCia
        AND  CodEmpresa  = nCodEmpresa
        AND  IdPoliza   = nIdPoliza;

      IF NVL(nPrimaPolTotal_2,0) != 0 THEN
         nDiferencia_1 := nMtoPriMin - nPrimaPolTotal_2;
         IF nDiferencia_1 <> 0 THEN
                     
            SELECT COUNT(DISTINCT COD_ASEGURADO)
            INTO nNumAsegurado
            FROM COBERT_ACT_ASEG
            WHERE CodCia      = nCodCia
            AND  CodEmpresa  = nCodEmpresa
            AND  IdPoliza   = nIdPoliza;

            nPrimaXaseg := nMtoPriMin / nNumAsegurado;
            FOR z IN c_DetallePoliza LOOP
               nIdetPol := z.IdetPol;
              FOR x IN c_Asegurados1 LOOP
                                              
                 SELECT nPrimaXaseg - SUM(Prima_Moneda)
                 INTO   nTotalPrimaAseg
                 FROM   COBERT_ACT_ASEG
                 WHERE  CodCia        = nCodCia
                 AND    CodEmpresa    = nCodEmpresa
                 AND    IdPoliza      = nIdPoliza
                 AND    IdetPol       = nIdetPol
                 AND    Cod_Asegurado = x.Cod_Asegurado;
                                                          
                 SELECT MAX(Prima_Moneda)
                 INTO   nPrimaMayAseg
                 FROM   COBERT_ACT_ASEG
                 WHERE  CodCia        = nCodCia
                 AND    CodEmpresa    = nCodEmpresa
                 AND    IdPoliza      = nIdPoliza
                 AND    IdetPol       = nIdetPol
                 AND    Cod_Asegurado = x.Cod_Asegurado;
                                                         
                 UPDATE COBERT_ACT_ASEG
                 SET    Prima_Local  = nPrimaMayAseg + nTotalPrimaAseg
                   ,    Prima_Moneda = nPrimaMayAseg + nTotalPrimaAseg
                 WHERE  CodCia         = nCodCia
                 AND  CodEmpresa       = nCodEmpresa
                 AND  IdPoliza         = nIdPoliza
                 AND  IdetPol          = nIdetPol
                 AND  Cod_Asegurado    = x.Cod_Asegurado
                 AND  Prima_moneda     = nPrimaMayAseg;
                        
              END LOOP;
            END LOOP;
         END IF;
      ELSE
         SELECT SUM(Prima_Moneda)
         INTO   nPrimaPolTotal_3
         FROM   COBERT_ACT
         WHERE  CodCia      = nCodCia
           AND  CodEmpresa  = nCodEmpresa
           AND  IdPoliza    = nIdPoliza;

         IF NVL(nPrimaPolTotal_3,0) != 0 THEN
            nDiferencia_2 := nMtoPriMin - nPrimaPolTotal_3;
            IF nDiferencia_2 <> 0 THEN         
              FOR z IN c_DetallePoliza LOOP
                  nIdetPol3 := z.IdetPol;
                  FOR y IN c_Coberturas2 LOOP
                    IF y.Prima_Moneda > nPrimaMaxCob THEN
                       nPrimaMaxCob:= y.Prima_Moneda;
					   cCodCobert3 := y.CodCobert;
                    END IF;
                  END LOOP;
                  UPDATE COBERT_ACT
                  SET    Prima_Local  = Prima_Local + nDiferencia_2
                  ,      Prima_Moneda = Prima_Moneda + nDiferencia_2
                  WHERE  CodCia           = nCodCia
                    AND  CodEmpresa       = nCodEmpresa
                    AND  IdPoliza         = nIdPoliza
                    AND  IdetPol          = nIdetPol3
                    AND  CodCobert        = cCodCobert3;
              END LOOP;
            END IF;
         END IF;
      END IF;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL ACTUALIZAR LA TASA Y PRIMAS DE LA POLIZA: ' || nIdPoliza || ' - ' || SQLERRM);
   END ACTUALIZA_COBERT_POLIZA;
   --
   PROCEDURE ACTUALIZA_COBERT_EMIFACIL( nCodCia         SOLICITUD_EMISION.CodCia%TYPE
                                      , nCodEmpresa     SOLICITUD_EMISION.CodEmpresa%TYPE
                                      , nIdSolicitud    SOLICITUD_EMISION.IdSolicitud%TYPE
                                      , nPrimaCobTotal  NUMBER
                                      , nMtoPriMin      PLAN_DE_PAGOS.MtoPriMin%TYPE ) IS
      nFactorDiferencia  NUMBER(24,8);
      nTasa              SOLICITUD_COBERTURAS.Tasa%TYPE;
      cCodCobert         SOLICITUD_COBERTURAS.CodCobert%TYPE;
      nIdetSol           SOLICITUD_COBERTURAS.IdetSol%TYPE;
      nDiferencia        NUMBER(24,8);
      nPrimaCobTotal_1   NUMBER(24,8);
      nPrimaCobTotal_2   NUMBER(24,8);
      cIndAsegModelo     SOLICITUD_EMISION.IndAsegModelo%TYPE;
      cTotAseg           NUMBER;
      --
      CURSOR c_Coberturas IS
             SELECT CodCobert, Tasa, IdetSol
             FROM   SOLICITUD_COBERTURAS
             WHERE  CodCia      = nCodCia
               AND  CodEmpresa  = nCodEmpresa
               AND  IdSolicitud = nIdSolicitud
               AND  Prima_Moneda > 0;
      --
      CURSOR c_CoberturasTot IS
             SELECT IdetSol, SUM(Prima_Moneda) TotPrima
             FROM   SOLICITUD_COBERTURAS
             WHERE  CodCia      = nCodCia
               AND  CodEmpresa  = nCodEmpresa
               AND  IdSolicitud = nIdSolicitud
               AND  Prima_Moneda > 0
             GROUP BY IdetSol;
   BEGIN
      SELECT IndAsegModelo
      INTO   cIndAsegModelo
      FROM   SOLICITUD_EMISION
      WHERE  CodCia      = nCodCia
        AND  CodEmpresa  = nCodEmpresa
        AND  IdSolicitud = nIdSolicitud;
      --
      IF NVL(cIndAsegModelo, 'N') = 'N' THEN
         SELECT COUNT(*)
         INTO   cTotAseg
         FROM   SOLICITUD_DETALLE_ASEG
         WHERE  CodCia      = nCodCia
           AND  CodEmpresa  = nCodEmpresa
           AND  IdSolicitud = nIdSolicitud;
         --
         nPrimaCobTotal_1 := nPrimaCobTotal * cTotAseg;
      ELSE
         nPrimaCobTotal_1 := nPrimaCobTotal;
      END IF;
      --
      nFactorDiferencia := ( nMtoPriMin / nPrimaCobTotal_1 ) - 1;
      --
      FOR x IN c_Coberturas LOOP
          nTasa := x.tasa;
          --
          UPDATE SOLICITUD_COBERTURAS
          SET    Tasa         = Tasa * ( 1 + nFactorDiferencia )
            ,    Prima_Local  = ROUND(SumaAseg_Local * (nTasa * ( 1 + nFactorDiferencia )), 2)
            ,    Prima_Moneda = ROUND(SumaAseg_Moneda * (nTasa * ( 1 + nFactorDiferencia )), 2)
          WHERE  CodCia      = nCodCia
            AND  CodEmpresa  = nCodEmpresa
            AND  IdSolicitud = nIdSolicitud
            AND  CodCobert   = x.CodCobert
            AND  IdetSol     = x.IdetSol;
          --
          cCodCobert := x.CodCobert;
          nIdetSol   := x.IdetSol;
      END LOOP;
      --
      SELECT SUM(Prima_Moneda)
      INTO   nPrimaCobTotal_2
      FROM   SOLICITUD_COBERTURAS
      WHERE  CodCia      = nCodCia
        AND  CodEmpresa  = nCodEmpresa
        AND  IdSolicitud = nIdSolicitud;
      --
      IF NVL(cIndAsegModelo, 'N') = 'N' THEN
         nDiferencia := ( nMtoPriMin/cTotAseg ) - nPrimaCobTotal_2;
      ELSE
         nDiferencia := nMtoPriMin - nPrimaCobTotal_2;
      END IF;
      --
      IF nDiferencia <> 0 THEN
         UPDATE SOLICITUD_COBERTURAS
         SET    Prima_Local  = Prima_Local + nDiferencia
           ,    Prima_Moneda = Prima_Moneda + nDiferencia
         WHERE  CodCia      = nCodCia
           AND  CodEmpresa  = nCodEmpresa
           AND  IdSolicitud = nIdSolicitud
           AND  CodCobert   = cCodCobert
           AND  IdetSol     = nIdetSol;
      END IF;
      --
      FOR z IN c_CoberturasTot LOOP
          IF NVL(cIndAsegModelo, 'N') = 'N' THEN
             UPDATE SOLICITUD_DETALLE
             SET    PrimaAsegurado = z.TotPrima-- / cTotAseg
             WHERE  CodCia      = nCodCia
               AND  CodEmpresa  = nCodEmpresa
               AND  IdSolicitud = nIdSolicitud
               AND  IdetSol     = z.IdetSol;
          ELSE
             UPDATE SOLICITUD_DETALLE
             SET    PrimaAsegurado = z.TotPrima / CantAsegModelo
             WHERE  CodCia      = nCodCia
               AND  CodEmpresa  = nCodEmpresa
               AND  IdSolicitud = nIdSolicitud
               AND  IdetSol     = z.IdetSol;
          END IF;
      END LOOP;
      --
      UPDATE SOLICITUD_EMISION
      SET    PrimaNetaPol = nMtoPriMin
      WHERE  CodCia      = nCodCia
        AND  CodEmpresa  = nCodEmpresa
        AND  IdSolicitud = nIdSolicitud;
      --
   END ACTUALIZA_COBERT_EMIFACIL;
   --
   PROCEDURE OBTIENE_PRIMAS_COTIZA( nCodCia              COTIZACIONES.CodCia%TYPE
                                  , nCodEmpresa          COTIZACIONES.CodEmpresa%TYPE
                                  , nIdCotizacion        COTIZACIONES.IdCotizacion%TYPE
                                  , nPrimaCobTotal  OUT  NUMBER
                                  , nMtoPriMin      OUT  NUMBER ) IS
                                                                 
   cIndPriMin        COTIZACIONES.INDPRIMIN%TYPE;
   cCodPlanpago      COTIZACIONES.CODPLANPAGO%TYPE;
   cIndPriMinPlan    PLAN_DE_PAGOS.INDPRIMIN%TYPE;
   cIndAsegModelo    COTIZACIONES.INDASEGMODELO%TYPE;
   cIdtiposeg        COTIZACIONES.IDTIPOSEG%TYPE;
   cPlanCob          COTIZACIONES.PLANCOB%TYPE;
   cControlErr       VARCHAR2(500);   
   BEGIN
    SELECT InDprimin, CodPlanpago, IndAsegModelo, Idtiposeg, PlanCob
    INTO cIndPriMin, cCodPlanpago, cIndAsegModelo, cIdtiposeg, cPlanCob
    FROM COTIZACIONES
    WHERE CodCia       = nCodCia
     AND CodEmpresa   = nCodEmpresa
     AND IdCotizacion = nIdCotizacion;
                                   
     IF cIndPriMin = 'S'THEN
        cControlErr := 'Cotizacion: ' || nIdCotizacion;
        SELECT InDprimin
        INTO cIndPriMinPlan
        FROM PLAN_DE_PAGOS
        WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND CodPlanpago  = cCodPlanpago;
              
        IF cIndPriMinPlan = 'S' THEN
           IF cIndAsegModelo = 'S' THEN
              SELECT SUM(PrimaCobMoneda)
              INTO nPrimaCobTotal
              FROM COTIZACIONES_COBERTURAS
              WHERE CodCia       = nCodCia
              AND CodEmpresa   = nCodEmpresa
              AND IdCotizacion = nIdCotizacion;
   	       ELSE
              SELECT SUM(PrimaCobMoneda)
              INTO nPrimaCobTotal
              FROM COTIZACIONES_COBERT_ASEG
              WHERE CodCia       = nCodCia
              AND CodEmpresa   = nCodEmpresa
              AND IdCotizacion = nIdCotizacion;
           END IF;
        END IF;
     END IF;
   --   
   nMtoPriMin := OC_PRIMA_MINIMA_ANUAL.OBTIENE_MTOPRIMIN( nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, cCodPlanPago );
   --
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20225, 'Error al Validar la ' || cControlErr || ' -- ' || SQLERRM);	 
   END OBTIENE_PRIMAS_COTIZA;
   --
   PROCEDURE VALIDA_PRIMAS_COTIZA( nCodCia        COTIZACIONES.CodCia%TYPE
                                 , nCodEmpresa    COTIZACIONES.CodEmpresa%TYPE
                                 , nIdCotizacion  COTIZACIONES.IdCotizacion%TYPE ) IS
      cIndPriMin      COTIZACIONES.IndPriMin%TYPE;
      nPrimaCobTotal  NUMBER(18,2);
      nMtoPriMin      NUMBER(18,2);
      cCodPlanPago    COTIZACIONES.CodPlanPago%TYPE;
   BEGIN
      SELECT IndPriMin, CodPlanPago
      INTO cIndPriMin, cCodPlanPago
      FROM COTIZACIONES
      WHERE CodCia       = nCodCia
        AND CodEmpresa   = nCodEmpresa
        AND IdCotizacion = nIdCotizacion;
      --
      IF cIndPriMin = 'S' THEN
         OC_PRIMA_MINIMA_ANUAL.OBTIENE_PRIMAS_COTIZA(nCodCia, nCodEmpresa, nIdCotizacion, nPrimaCobTotal, nMtoPriMin);
		 --
         IF nPrimaCobTotal < nMtoPriMin THEN
            OC_PRIMA_MINIMA_ANUAL.ACTUALIZA_COBERT_COTIZACION(nCodCia, nCodEmpresa, nIdCotizacion, cCodPlanPago, nPrimaCobTotal, nMtoPriMin);
         END IF;
      END IF;
   END VALIDA_PRIMAS_COTIZA;
   --
   PROCEDURE OBTIENE_PRIMAS_POLIZA( nCodCia             POLIZAS.CodCia%TYPE
                                  , nCodEmpresa         POLIZAS.CodEmpresa%TYPE
                                  , nIdPoliza           POLIZAS.IdPoliza%TYPE
                                  , nPrimaCobTotal      OUT  NUMBER
                                  , nMtoPriMin          OUT  NUMBER ) IS
   cIndPriMin        POLIZAS.INDPRIMIN%TYPE;
   cCodPlanpago      POLIZAS.CODPLANPAGO%TYPE;
   cIndPriMinPlan    PLAN_DE_PAGOS.INDPRIMIN%TYPE;
   cIndPolCol        POLIZAS.INDPOLCOL%TYPE;
   cIdTipoSeg        DETALLE_POLIZA.IDTIPOSEG%TYPE;
   cPlanCob          DETALLE_POLIZA.PLANCOB%TYPE;
   cControlErr       VARCHAR2(500);   
   BEGIN
    SELECT A.IndPriMin, A.CodPlanpago, A.IndPolCol, B.IdTiposeg ,B.PlanCob
    INTO cIndPriMin, cCodPlanpago, cIndPolCol, cIdTipoSeg, cPlanCob
    FROM POLIZAS A, DETALLE_POLIZA B
    WHERE A.CodCia      = nCodCia
     AND A.CodEmpresa   = nCodEmpresa
     AND A.IdPoliza     = nIdPoliza
     AND B.IdPoliza     = A.IdPoliza
     AND B.IdetPol      = 1;
                                   
      IF cIndPriMin = 'S' THEN
         cControlErr := 'Poliza: ' || nIdPoliza;                                          
         SELECT InDprimin
         INTO cIndPriMinPlan
         FROM PLAN_DE_PAGOS
         WHERE CodCia       = nCodCia
           AND CodEmpresa   = nCodEmpresa
           AND CodPlanpago  = cCodPlanpago;
         IF cIndPriMinPlan = 'S' THEN
            IF cIndPolCol = 'S' THEN
               SELECT SUM(Prima_Moneda)
               INTO nPrimaCobTotal
               FROM COBERT_ACT_ASEG
               WHERE CodCia       = nCodCia
                AND CodEmpresa   = nCodEmpresa
                AND IdPoliza     = nIdPoliza;
            ELSIF cIndPolCol = 'N' THEN
               SELECT SUM(Prima_Moneda)
               INTO nPrimaCobTotal
               FROM COBERT_ACT
               WHERE CodCia       = nCodCia
                AND CodEmpresa   = nCodEmpresa
                AND IdPoliza     = nIdPoliza;
            END IF;
         END IF;
      END IF;
   --   
   nMtoPriMin := OC_PRIMA_MINIMA_ANUAL.OBTIENE_MTOPRIMIN( nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, cCodPlanPago );
   --
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20225, 'Error al Validar la ' || cControlErr || ' -- ' || SQLERRM);	 
   END OBTIENE_PRIMAS_POLIZA;
   --
   PROCEDURE VALIDA_PRIMAS_POLIZA( nCodCia        POLIZAS.CodCia%TYPE
                                 , nCodEmpresa    POLIZAS.CodEmpresa%TYPE
                                 , nIdPoliza      POLIZAS.IdPoliza%TYPE ) IS
      cIndPriMin      POLIZAS.IndPriMin%TYPE;
      nPrimaCobTotal  NUMBER(18,2);
      nMtoPriMin      NUMBER(18,2);
      cCodPlanPago    POLIZAS.CodPlanPago%TYPE;
      cIndPolCol      POLIZAS.IndPolCol%TYPE;
   BEGIN
      SELECT IndPriMin, IndPolCol
       INTO cIndPriMin, cIndPolCol
       FROM POLIZAS
      WHERE CodCia       = nCodCia
        AND CodEmpresa   = nCodEmpresa
        AND IdPoliza     = nIdPoliza;
      --
      IF cIndPriMin = 'S' THEN
      	OC_PRIMA_MINIMA_ANUAL.OBTIENE_PRIMAS_POLIZA( nCodCia, nCodEmpresa, nIdPoliza, nPrimaCobTotal, nMtoPriMin );
         --
         IF nPrimaCobTotal < nMtoPriMin THEN
            OC_PRIMA_MINIMA_ANUAL.ACTUALIZA_COBERT_POLIZA( nCodCia, nCodEmpresa, nIdPoliza, cIndPolCol, nPrimaCobTotal, nMtoPriMin );
         END IF;
      END IF;
   END VALIDA_PRIMAS_POLIZA;
   --
END OC_PRIMA_MINIMA_ANUAL;
/

CREATE OR REPLACE PUBLIC SYNONYM OC_PRIMA_MINIMA_ANUAL FOR SICAS_OC.OC_PRIMA_MINIMA_ANUAL
/

GRANT EXECUTE ON SICAS_OC.OC_PRIMA_MINIMA_ANUAL TO PUBLIC
/