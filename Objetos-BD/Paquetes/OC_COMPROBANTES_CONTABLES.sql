CREATE OR REPLACE PACKAGE OC_COMPROBANTES_CONTABLES IS
-- BITACORA DE CAMBIOS
-- Modificaciones para OGAS                                    JMMD 20210212
-- SE MODIFICA PARA QUE CALCULE BIEN EL TIPO DE CAMBIO         JMMD 20220531
-- SE AJUSTO EL CAMPO PARA INCIDENCIA DE CALCULO DE COMISIONES JICO 20220726 USD
-- SE AGREGA LA SEPARACION PARA RESICO                         CMPL 20221027  20231012     -- RESICO
--
FUNCTION NUM_COMPROBANTE(nCodCia NUMBER) RETURN NUMBER;

FUNCTION CREA_COMPROBANTE(nCodCia NUMBER, cTipoComprob VARCHAR2, nNumTransaccion NUMBER,
                          cTipoDiario VARCHAR2, cCodMoneda VARCHAR2) RETURN NUMBER;

PROCEDURE CUADRA_COMPROBANTE(nCodCia NUMBER, nNumComprob NUMBER);

PROCEDURE ANULA_COMPROBANTE(nCodCia NUMBER, nNumComprob NUMBER);

PROCEDURE REHABILITA_COMPROBANTE(nCodCia NUMBER, nNumComprob NUMBER);

PROCEDURE REVERSA_COMPROBANTE(nCodCia NUMBER, nNumComprob NUMBER, cTipoCompRev VARCHAR2);

PROCEDURE ACTUALIZA_ENVIO(nCodCia NUMBER, nNumComprob NUMBER, nNumPolMizar NUMBER := 0);

PROCEDURE CONTABILIZAR( nCodCia         TRANSACCION.CODCIA%TYPE
                      , nIdTransaccion  TRANSACCION.IDTRANSACCION%TYPE
                      , cTipoComp       VARCHAR2 DEFAULT 'C' );

PROCEDURE TRASLADO(nCodCia NUMBER, dFecDesde DATE, dFecHasta DATE, nNumComprobSC NUMBER,
                   dFecRegistro DATE, cCodUser VARCHAR2, cConcepto VARCHAR2, nDiario NUMBER,
                   cTipoComprob VARCHAR2, cTipoDiario VARCHAR2, cCodMoneda VARCHAR2, 
                   cTipoTraslado VARCHAR2, nLinea IN OUT NUMBER);

PROCEDURE RECONTABILIZAR(nCodCia NUMBER, nIdTransaccion NUMBER, cTipoComp VARCHAR2 DEFAULT 'C', nNumComprob NUMBER);

PROCEDURE ELIMINA_COMPROBANTE(nCodCia NUMBER, nNumComprob NUMBER);

PROCEDURE TRASLADO_SUN(nCodCia NUMBER, dFecDesde DATE, dFecHasta DATE, nNumComprobSun NUMBER,
                       dFecRegistro DATE, cCodUser VARCHAR2, cTipoComprob VARCHAR2,
                       cEncabezado VARCHAR2, nLinea  IN OUT NUMBER);

PROCEDURE RECONTABILIZAR_MASIVO (cTipoComprob VARCHAR2,dFecIni DATE, dFecFin DATE);

FUNCTION COMISION_TIPO_PERSONA( nCodCia         TRANSACCION.CODCIA%TYPE
                              , nIdTransaccion  TRANSACCION.IDTRANSACCION%TYPE
                              , cIdTipoSeg      DETALLE_POLIZA.IDTIPOSEG%TYPE
                              , cTipoPersona    PERSONA_NATURAL_JURIDICA.TIPO_PERSONA%TYPE
                              , cTipoAgente     AGENTES.TIPO_AGENTE%TYPE ) RETURN NUMBER;

FUNCTION COMISION_TIPO_ADICIONALES(nCodCia NUMBER, nIdTransaccion NUMBER, cIdTipoSeg VARCHAR2,
                               cTipoPersona VARCHAR2, cTipoAgente VARCHAR2, CCodCpto VARCHAR2) RETURN NUMBER;

FUNCTION COM_TIPO_ADICIONALES_CANC(nCodCia NUMBER, nIdTransaccion NUMBER, cIdTipoSeg VARCHAR2,
                               cTipoPersona VARCHAR2, cTipoAgente VARCHAR2, CCodCpto VARCHAR2) RETURN NUMBER;

FUNCTION COM_TIPO_ADICIONALES_PAGOS(nCodCia NUMBER, nIdTransaccion NUMBER, cIdTipoSeg VARCHAR2,
                               cTipoPersona VARCHAR2, cTipoAgente VARCHAR2, CCodCpto VARCHAR2) RETURN NUMBER;

FUNCTION APLICA_CANAL_VENTA(nCodCia NUMBER, nIdTransaccion NUMBER, cIdTipoSeg VARCHAR2,
                            cCanalComisVenta VARCHAR2) RETURN VARCHAR2;

FUNCTION APLICA_TIPO_AGENTE(nCodCia NUMBER, nIdTransaccion NUMBER, cIdTipoSeg VARCHAR2,
                            cTipoAgente VARCHAR2) RETURN VARCHAR2;

PROCEDURE ACTUALIZA_MONEDA(nCodCia NUMBER, nNumComprob NUMBER, cCodMoneda VARCHAR2);

FUNCTION STATUS_COMPROBANTE(nCodCia NUMBER, nNumComprob NUMBER) RETURN VARCHAR2;

FUNCTION POSEE_COMPROBANTE(nCodCia NUMBER, nIdTransaccion NUMBER) RETURN VARCHAR2;

FUNCTION ENVIADO_SISTEMA_CONTABLE(nCodCia NUMBER, nIdTransaccion NUMBER) RETURN VARCHAR2;

END OC_COMPROBANTES_CONTABLES;
/
CREATE OR REPLACE PACKAGE BODY OC_COMPROBANTES_CONTABLES IS

   CURSOR MOV_CONTABLE_Q (nCodCia number, nCodEmpresa number, nIdTransaccion number, cCodMonedaCia varchar2) IS
    SELECT  1 REG, D.CodEmpresa, DP.IdTipoSeg, DF.CodCpto, F.Cod_Moneda CodMoneda, SUM(DF.Monto_Det_Moneda) MtoMovCuenta,
           SUM(F.MtoComisi_Moneda) MtoComisCuenta, 'FACTURAS CONTABILIZADAS' DescripMov, VL.DESCVALLST  UEN, NULL NIVELCTA3
           ,NULL TipoAgente, NULL COD_AGENTE     -- RESICO
      FROM DETALLE_FACTURAS    DF
         , FACTURAS            F
         , DETALLE_TRANSACCION D
         , TRANSACCION         T
         , DETALLE_POLIZA      DP
         , VALORES_DE_LISTAS         VL
     WHERE DP.IdPoliza         = F.IdPoliza
       AND DP.IDetPol          = NVL(F.IDetPol,DP.IDetPol)
       AND DP.CodCia           = D.CodCia
       AND ( ( TRUNC(F.FecVenc) <= TRUNC(FechaTransaccion)
               AND
               OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, D.CodEmpresa, DP.IdTipoSeg) = 'DEVENG' )
             OR
             OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, D.CodEmpresa, DP.IdTipoSeg) = 'ANTICI' )
       AND DF.IdFactura        = F.IdFactura
       AND T.IdTransaccion     = nIdTransaccion
       AND ( F.IdTransaccion = D.IdTransaccion
             OR
             ( F.IdTransaccionAnu = D.IdTransaccion
               AND
               F.IndContabilizada = 'S' )
             OR
             F.IdTransacContab = D.IdTransaccion )
       AND D.IdTransaccion     = nIdTransaccion
       AND D.CodCia            = nCodCia
       AND D.CodEmpresa        = nCodEmpresa
       AND D.Correlativo       = 1
       AND VL.CODVALOR = DP.IDTIPOSEG
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY D.CodEmpresa, DP.IdTipoSeg, DF.CodCpto, F.Cod_Moneda, 'FACTURAS CONTABILIZADAS', VL.DESCVALLST
     UNION ALL
    SELECT  2 REG, D.CodEmpresa, DP.IdTipoSeg, DN.CodCpto, N.CodMoneda, SUM(Monto_Det_Moneda) MtoMovCuenta,
           SUM(N.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov, VL.DESCVALLST UEN, NULL NIVELCTA3
           ,NULL TipoAgente, NULL COD_AGENTE     -- RESICO
      FROM DETALLE_NOTAS_DE_CREDITO DN
         , DETALLE_TRANSACCION       D
         , NOTAS_DE_CREDITO          N
         , DETALLE_POLIZA           DP
         , VALORES_DE_LISTAS         VL
     WHERE DP.IdPoliza          = N.IdPoliza
       AND DP.IDetPol           = NVL(N.IDetPol, DP.IDetPol)
       AND DP.CodCia            = D.CodCia
       AND DN.IdNcr             = N.IdNcr
       AND N.IdTransaccion      = D.IdTransaccion
       AND D.IdTransaccion      = nIdTransaccion
       AND D.CodCia             = nCodCia
       AND D.CodEmpresa         = nCodEmpresa
       AND D.Correlativo        = 1
       AND VL.CODVALOR = DP.IDTIPOSEG
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY D.CodEmpresa, DP.IdTipoSeg, DN.CodCpto, N.CodMoneda, NULL,  VL.DESCVALLST
     UNION ALL
    SELECT  3 REG, D.CodEmpresa, DP.IdTipoSeg, DN.CodCpto, N.CodMoneda, SUM(Monto_Det_Moneda) MtoMovCuenta,
           SUM(N.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov, VL.DESCVALLST UEN, NULL NIVELCTA3
           ,NULL TipoAgente, NULL COD_AGENTE     -- RESICO
      FROM DETALLE_NOTAS_DE_CREDITO DN
         , DETALLE_TRANSACCION       D
         , NOTAS_DE_CREDITO          N
         , DETALLE_POLIZA           DP
         , VALORES_DE_LISTAS         VL
     WHERE DP.IdPoliza          = N.IdPoliza
       AND DP.IDetPol           = NVL(N.IDetPol, DP.IDetPol)
       AND DP.CodCia            = D.CodCia
       AND DN.IdNcr             = N.IdNcr
       AND N.IdTransaccionAnu   = D.IdTransaccion
       AND D.IdTransaccion      = nIdTransaccion
       AND D.CodCia             = nCodCia
       AND D.CodEmpresa         = nCodEmpresa
       AND D.Correlativo        = 1
       AND VL.CODVALOR = DP.IDTIPOSEG
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY D.CodEmpresa, DP.IdTipoSeg, DN.CodCpto, N.CodMoneda, NULL, VL.DESCVALLST
     UNION ALL
    SELECT  4 REG, D.CodEmpresa, DP.IdTipoSeg, DN.CodCpto, N.CodMoneda, SUM(Monto_Det_Moneda) MtoMovCuenta,
           SUM(N.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov, VL.DESCVALLST UEN, NULL NIVELCTA3
           ,NULL TipoAgente, NULL COD_AGENTE     -- RESICO
      FROM DETALLE_NOTAS_DE_CREDITO DN
         , DETALLE_TRANSACCION       D
         , NOTAS_DE_CREDITO          N
         , DETALLE_POLIZA           DP
         , VALORES_DE_LISTAS         VL
     WHERE DP.IdPoliza          = N.IdPoliza
       AND DP.IDetPol           = NVL(N.IDetPol, DP.IDetPol)
       AND DP.CodCia            = D.CodCia
       AND DN.IdNcr             = N.IdNcr
       AND N.IdTransacAplic     = D.IdTransaccion
       AND D.IdTransaccion      = nIdTransaccion
       AND D.CodCia             = nCodCia
       AND D.CodEmpresa         = nCodEmpresa
       AND D.Correlativo        = 1
       AND VL.CODVALOR = DP.IDTIPOSEG
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY D.CodEmpresa, DP.IdTipoSeg, DN.CodCpto, N.CodMoneda, NULL, VL.DESCVALLST
     UNION ALL
    SELECT  5 REG, D.CodEmpresa, DP.IdTipoSeg, DN.CodCpto, N.CodMoneda, SUM(Monto_Det_Moneda) MtoMovCuenta,
           SUM(N.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov, VL.DESCVALLST UEN, NULL NIVELCTA3
           ,NULL TipoAgente, NULL COD_AGENTE     -- RESICO
      FROM DETALLE_NOTAS_DE_CREDITO DN
         , DETALLE_TRANSACCION       D
         , NOTAS_DE_CREDITO          N
         , DETALLE_POLIZA           DP
         , VALORES_DE_LISTAS         VL
     WHERE DP.IdPoliza          = N.IdPoliza
       AND DP.IDetPol           = NVL(N.IDetPol, DP.IDetPol)
       AND DP.CodCia            = D.CodCia
       AND DN.IdNcr             = N.IdNcr
       AND N.IdTransacRevAplic  = D.IdTransaccion
       AND D.IdTransaccion      = nIdTransaccion
       AND D.CodCia             = nCodCia
       AND D.CodEmpresa         = nCodEmpresa
       AND D.Correlativo        = 1
       AND VL.CODVALOR = DP.IDTIPOSEG
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY D.CodEmpresa, DP.IdTipoSeg, DN.CodCpto, N.CodMoneda, NULL  , VL.DESCVALLST
     UNION ALL
    SELECT  6 REG, D.CodEmpresa, 'GENERA' IdTipoSeg, DN.CodCpto, N.CodMoneda,
           SUM(Monto_Det_Moneda) MtoMovCuenta,
           --SUM(DC.MONTO_MON_LOCAL) MtoMovCuenta,
           SUM(DC.MONTO_MON_EXTRANJERA) MtoComisCuenta,NULL DescripMov, VL.DESCVALLST UEN, NULL NIVELCTA3
           ,OC_AGENTES.TIPO_AGENTE(D.CodCia, C.Cod_Agente) TipoAgente, C.COD_AGENTE     -- RESICO
      FROM DETALLE_NOTAS_DE_CREDITO DN
         , DETALLE_TRANSACCION       D
         , NOTAS_DE_CREDITO          N
         , COMISIONES                C
         , DETALLE_COMISION          DC
         , DETALLE_POLIZA            DP
         , VALORES_DE_LISTAS         VL
     WHERE DN.IdNcr         = N.IdNcr
       AND N.IdPoliza      IS NULL
       AND N.IdTransaccion  = D.IdTransaccion
       AND D.IdTransaccion  = nIdTransaccion
       AND D.CodCia         = nCodCia
       AND D.CodEmpresa     = nCodEmpresa
       AND D.Correlativo    = 1
       AND C.IDNOMINA       = N.IDNOMINA
       AND DC.IDCOMISION    = C.IDCOMISION
       AND DC.CODCONCEPTO   = DN.CODCPTO
       AND DP.IDPOLIZA = C.IDPOLIZA
       AND DP.IDETPOL = C.IDETPOL
       AND VL.CODVALOR = DP.IDTIPOSEG
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY D.CodEmpresa, 'GENERA', DN.CodCpto, N.CodMoneda, NULL, VL.DESCVALLST
             ,D.CodCia, C.Cod_Agente
     UNION ALL
    SELECT  7 REG, D.CodEmpresa, 'GENERA' IdTipoSeg, DN.CodCpto, N.CodMoneda,
           SUM(Monto_Det_Moneda) MtoMovCuenta,
           --SUM(DC.MONTO_MON_LOCAL) MtoMovCuenta,
           SUM(DC.MONTO_MON_EXTRANJERA) MtoComisCuenta,NULL DescripMov, VL.DESCVALLST UEN,
           OC_CAT_REGIMEN_FISCAL.FUN_NIVELCTA3(Dc.IdRegFisSAT) NIVELCTA3
           ,OC_AGENTES.TIPO_AGENTE(D.CodCia, C.Cod_Agente) TipoAgente, C.COD_AGENTE     -- RESICO
      FROM DETALLE_NOTAS_DE_CREDITO DN
         , DETALLE_TRANSACCION       D
         , NOTAS_DE_CREDITO          N
         , COMISIONES                C
         , DETALLE_COMISION          DC
         , DETALLE_POLIZA            DP
         , VALORES_DE_LISTAS         VL
     WHERE DN.IdNcr           = N.IdNcr
       AND N.IdPoliza        IS NULL
       AND N.IdTransaccionAnu = D.IdTransaccion
       AND D.IdTransaccion    = nIdTransaccion
       AND D.CodCia           = nCodCia
       AND D.CodEmpresa       = nCodEmpresa
       AND D.Correlativo      = 1
       AND C.IDNOMINA       = N.IDNOMINA
       AND DC.IDCOMISION    = C.IDCOMISION
       AND DC.CODCONCEPTO   = DN.CODCPTO
       AND DP.IDPOLIZA = C.IDPOLIZA
       AND DP.IDETPOL = C.IDETPOL
       AND VL.CODVALOR = DP.IDTIPOSEG
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY D.CodEmpresa, 'GENERA', DN.CodCpto, N.CodMoneda, NULL, VL.DESCVALLST, Dc.IdRegFisSAT
           ,D.CodCia, C.Cod_Agente
     UNION ALL
    SELECT  8 REG, D.CodEmpresa, 'GENERA' IdTipoSeg, DN.CodCpto, N.CodMoneda,
           SUM(Monto_Det_Moneda) MtoMovCuenta,
           --SUM(DC.MONTO_MON_LOCAL) MtoMovCuenta,
           SUM(DC.MONTO_MON_EXTRANJERA) MtoComisCuenta,NULL DescripMov, VL.DESCVALLST UEN, NULL NIVELCTA3
           ,OC_AGENTES.TIPO_AGENTE(D.CodCia, C.Cod_Agente) TipoAgente, C.COD_AGENTE     -- RESICO
      FROM DETALLE_NOTAS_DE_CREDITO DN
         , DETALLE_TRANSACCION       D
         , NOTAS_DE_CREDITO          N
         , COMISIONES                C
         , DETALLE_COMISION          DC
         , DETALLE_POLIZA            DP
         , VALORES_DE_LISTAS         VL
     WHERE DN.IdNcr         = N.IdNcr
       AND N.IdPoliza      IS NULL
       AND N.IdTransacAplic = D.IdTransaccion
       AND D.IdTransaccion  = nIdTransaccion
       AND D.CodCia         = nCodCia
       AND D.CodEmpresa     = nCodEmpresa
       AND D.Correlativo    = 1
       AND C.IDNOMINA       = N.IDNOMINA
       AND DC.IDCOMISION    = C.IDCOMISION
       AND DC.CODCONCEPTO   = DN.CODCPTO
       AND DP.IDPOLIZA = C.IDPOLIZA
       AND DP.IDETPOL = C.IDETPOL
       AND VL.CODVALOR = DP.IDTIPOSEG
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY D.CodEmpresa, 'GENERA', DN.CodCpto, N.CodMoneda, NULL, VL.DESCVALLST
              ,D.CodCia, C.Cod_Agente
     UNION ALL
    SELECT  9 REG, D.CodEmpresa, 'GENERA' IdTipoSeg, DN.CodCpto, N.CodMoneda,
           --SUM(Monto_Det_Moneda) MtoMovCuenta,
           SUM(DC.MONTO_MON_LOCAL) MtoMovCuenta,
           SUM(DC.MONTO_MON_EXTRANJERA) MtoComisCuenta,NULL DescripMov, VL.DESCVALLST UEN, NULL NIVELCTA3 
           ,OC_AGENTES.TIPO_AGENTE(D.CodCia, C.Cod_Agente) TipoAgente, C.COD_AGENTE     -- RESICO
      FROM DETALLE_NOTAS_DE_CREDITO DN
         , DETALLE_TRANSACCION       D
         , NOTAS_DE_CREDITO          N
         , COMISIONES                C
         , DETALLE_COMISION          DC
         , DETALLE_POLIZA            DP
         , VALORES_DE_LISTAS         VL
     WHERE DN.IdNcr            = N.IdNcr
       AND N.IdPoliza         IS NULL
       AND N.IdTransacRevAplic = D.IdTransaccion
       AND D.IdTransaccion     = nIdTransaccion
       AND D.CodCia            = nCodCia
       AND D.CodEmpresa        = nCodEmpresa
       AND D.Correlativo       = 1
       AND C.IDNOMINA       = N.IDNOMINA
       AND DC.IDCOMISION    = C.IDCOMISION
       AND DC.CODCONCEPTO   = DN.CODCPTO
       AND DP.IDPOLIZA = C.IDPOLIZA
       AND DP.IDETPOL = C.IDETPOL
       AND VL.CODVALOR = DP.IDTIPOSEG
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY D.CodEmpresa, 'GENERA', DN.CodCpto, N.CodMoneda, NULL, VL.DESCVALLST
             ,D.CodCia, C.Cod_Agente
     UNION ALL
    SELECT 10 REG, D.CodEmpresa, 'GENERA' IdTipoSeg, 'TRIVHO', N.CodMoneda,
           SUM(Monto_Det_Moneda) MtoMovCuenta,
           --SUM(DC.MONTO_MON_LOCAL) * -1 MtoMovCuenta,
           SUM(DC.MONTO_MON_EXTRANJERA)* -1 MtoComisCuenta,NULL DescripMov, VL.DESCVALLST UEN, NULL NIVELCTA3
           ,OC_AGENTES.TIPO_AGENTE(D.CodCia, C.Cod_Agente) TipoAgente, C.COD_AGENTE     -- RESICO
      FROM DETALLE_NOTAS_DE_CREDITO DN
         , DETALLE_TRANSACCION       D
         , NOTAS_DE_CREDITO          N
         , COMISIONES                C
         , DETALLE_COMISION          DC
         , DETALLE_POLIZA            DP
         , VALORES_DE_LISTAS         VL
     WHERE DN.IdNcr         = N.IdNcr
       AND N.IdPoliza      IS NULL
       AND N.IdTransaccion  = D.IdTransaccion
       AND DN.CODCPTO       = 'TRIVHO'
       AND D.IdTransaccion  = nIdTransaccion
       AND D.CodCia         = nCodCia
       AND D.CodEmpresa     = nCodEmpresa
       AND D.Correlativo    = 1
       AND C.IDNOMINA       = N.IDNOMINA
       AND DC.IDCOMISION    = C.IDCOMISION
       --AND DC.CODCONCEPTO   = 'IVAHON' --DN.CODCPTO
       AND (OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(C.CodCia, C.CODEMPRESA, DP.IDTIPOSEG) = 'N' AND DC.CODCONCEPTO      = 'IVAHON'
        OR OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(C.CodCia, C.CODEMPRESA, DP.IDTIPOSEG) = 'S' AND DC.CODCONCEPTO      != 'IVASIN')
       AND DP.IDPOLIZA = C.IDPOLIZA
       AND DP.IDETPOL = C.IDETPOL
       AND VL.CODVALOR = DP.IDTIPOSEG
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY D.CodEmpresa, 'GENERA', 'TRIVHO', N.CodMoneda, NULL, VL.DESCVALLST
              ,D.CodCia, C.Cod_Agente
     UNION ALL
    SELECT 11 REG, D.CodEmpresa, 'GENERA' IdTipoSeg, 'TRIVHO', N.CodMoneda,
           SUM(Monto_Det_Moneda) MtoMovCuenta,
           --SUM(DC.MONTO_MON_LOCAL)* -1 MtoMovCuenta,
           SUM(DC.MONTO_MON_EXTRANJERA)* -1 MtoComisCuenta,NULL DescripMov, VL.DESCVALLST UEN, NULL NIVELCTA3
           ,OC_AGENTES.TIPO_AGENTE(D.CodCia, C.Cod_Agente) TipoAgente, C.COD_AGENTE     -- RESICO
      FROM DETALLE_NOTAS_DE_CREDITO DN
         , DETALLE_TRANSACCION       D
         , NOTAS_DE_CREDITO          N
         , COMISIONES                C
         , DETALLE_COMISION          DC
         , DETALLE_POLIZA            DP
         , VALORES_DE_LISTAS         VL
     WHERE DN.IdNcr           = N.IdNcr
       AND N.IdPoliza        IS NULL
       AND N.IdTransaccionAnu = D.IdTransaccion
       AND D.IdTransaccion    = nIdTransaccion
       AND DN.CODCPTO       = 'TRIVHO'
       AND D.CodCia           = nCodCia
       AND D.CodEmpresa       = nCodEmpresa
       AND D.Correlativo      = 1
       AND C.IDNOMINA       = N.IDNOMINA
       AND DC.IDCOMISION    = C.IDCOMISION
       --AND DC.CODCONCEPTO   = 'IVAHON' --DN.CODCPTO
       AND (OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(C.CodCia, C.CODEMPRESA, DP.IDTIPOSEG) = 'N' AND DC.CODCONCEPTO      = 'IVAHON'
        OR OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(C.CodCia, C.CODEMPRESA, DP.IDTIPOSEG) = 'S' AND DC.CODCONCEPTO      != 'IVASIN')
       AND DP.IDPOLIZA = C.IDPOLIZA
       AND DP.IDETPOL = C.IDETPOL
       AND VL.CODVALOR = DP.IDTIPOSEG
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY D.CodEmpresa, 'GENERA', 'TRIVHO', N.CodMoneda, NULL, VL.DESCVALLST
             ,D.CodCia, C.Cod_Agente
     UNION ALL
    SELECT 12 REG, D.CodEmpresa, 'GENERA' IdTipoSeg, 'TRIVHO', N.CodMoneda,
           SUM(Monto_Det_Moneda) MtoMovCuenta,
           --SUM(DC.MONTO_MON_LOCAL)* -1 MtoMovCuenta,
           SUM(DC.MONTO_MON_EXTRANJERA) * -1 MtoComisCuenta,NULL DescripMov, VL.DESCVALLST UEN, NULL NIVELCTA3
           ,OC_AGENTES.TIPO_AGENTE(D.CodCia, C.Cod_Agente) TipoAgente, C.COD_AGENTE     -- RESICO
      FROM DETALLE_NOTAS_DE_CREDITO DN
         , DETALLE_TRANSACCION       D
         , NOTAS_DE_CREDITO          N
         , COMISIONES                C
         , DETALLE_COMISION          DC
         , DETALLE_POLIZA            DP
         , VALORES_DE_LISTAS         VL
     WHERE DN.IdNcr         = N.IdNcr
       AND N.IdPoliza      IS NULL
       AND N.IdTransacAplic = D.IdTransaccion
       AND D.IdTransaccion  = nIdTransaccion
       AND DN.CODCPTO       = 'TRIVHO'
       AND D.CodCia         = nCodCia
       AND D.CodEmpresa     = nCodEmpresa
       AND D.Correlativo    = 1
       AND C.IDNOMINA       = N.IDNOMINA
       AND DC.IDCOMISION    = C.IDCOMISION
       --AND DC.CODCONCEPTO   = 'IVAHON' --DN.CODCPTO
       AND (OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(C.CodCia, C.CODEMPRESA, DP.IDTIPOSEG) = 'N' AND DC.CODCONCEPTO      = 'IVAHON'
        OR OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(C.CodCia, C.CODEMPRESA, DP.IDTIPOSEG) = 'S' AND DC.CODCONCEPTO      != 'IVASIN')
       AND DP.IDPOLIZA = C.IDPOLIZA
       AND DP.IDETPOL = C.IDETPOL
       AND VL.CODVALOR = DP.IDTIPOSEG
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY D.CodEmpresa, 'GENERA', 'TRIVHO', N.CodMoneda, NULL, VL.DESCVALLST
               ,D.CodCia, C.Cod_Agente
     UNION ALL
    SELECT 13 REG, D.CodEmpresa, 'GENERA' IdTipoSeg, 'TRIVHO', N.CodMoneda,
           SUM(Monto_Det_Moneda) MtoMovCuenta,
           --SUM(DC.MONTO_MON_LOCAL)* -1 MtoMovCuenta,
           SUM(DC.MONTO_MON_EXTRANJERA) * -1 MtoComisCuenta,NULL DescripMov, VL.DESCVALLST UEN, NULL NIVELCTA3 
           ,OC_AGENTES.TIPO_AGENTE(D.CodCia, C.Cod_Agente) TipoAgente, C.COD_AGENTE     -- RESICO
      FROM DETALLE_NOTAS_DE_CREDITO DN
         , DETALLE_TRANSACCION       D
         , NOTAS_DE_CREDITO          N
         , COMISIONES                C
         , DETALLE_COMISION          DC
         , DETALLE_POLIZA            DP
         , VALORES_DE_LISTAS         VL
     WHERE DN.IdNcr            = N.IdNcr
       AND N.IdPoliza         IS NULL
       AND N.IdTransacRevAplic = D.IdTransaccion
       AND D.IdTransaccion     = nIdTransaccion
       AND DN.CODCPTO       = 'TRIVHO'
       AND D.CodCia            = nCodCia
       AND D.CodEmpresa        = nCodEmpresa
       AND D.Correlativo       = 1
       AND C.IDNOMINA       = N.IDNOMINA
       AND DC.IDCOMISION    = C.IDCOMISION
       --AND DC.CODCONCEPTO   = 'IVAHON' --DN.CODCPTO
       AND (OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(C.CodCia, C.CODEMPRESA, DP.IDTIPOSEG) = 'N' AND DC.CODCONCEPTO      = 'IVAHON'
        OR OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(C.CodCia, C.CODEMPRESA, DP.IDTIPOSEG) = 'S' AND DC.CODCONCEPTO      != 'IVASIN')
       AND DP.IDPOLIZA = C.IDPOLIZA
       AND DP.IDETPOL = C.IDETPOL
       AND VL.CODVALOR = DP.IDTIPOSEG
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY D.CodEmpresa, 'GENERA', 'TRIVHO', N.CodMoneda, NULL, VL.DESCVALLST
            ,D.CodCia, C.Cod_Agente
     UNION ALL
    SELECT DISTINCT 14 REG, CFT.CodEmpresa, CFT.IdTipoSeg, RTC.CodCptoRva, CCODMONEDACIA CodMoneda,
           SUM(RTC.MtoCptoRva) MtoMovCuenta, 0 MtoComisCuenta, RTC.DescCptoRva DescripMov, VL.DESCVALLST UEN, NULL NIVELCTA3
           ,NULL TipoAgente, NULL COD_AGENTE     -- RESICO
      FROM RESERVAS_TECNICAS_CONTAB RTC
         , RESERVAS_TECNICAS         RT
         , CONFIG_RESERVAS           CF
         , CONFIG_RESERVAS_TIPOSEG  CFT
         , VALORES_DE_LISTAS         VL
     WHERE CFT.CodCia       = CF.CodCia
       AND CFT.CodReserva   = CF.CodReserva
       AND CF.CodCia        = RT.CodCia
       AND CF.CodReserva    = RT.CodReserva
       AND RTC.IdReserva    = RT.IdReserva
       AND RT.IdTransaccion = nIdTransaccion
       AND VL.CODVALOR = CFT.IDTIPOSEG
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY CFT.CodEmpresa, CFT.IdTipoSeg, RTC.CodCptoRva, CCODMONEDACIA, RTC.DescCptoRva, VL.DESCVALLST
     UNION ALL
    SELECT 15 REG, S.CodEmpresa, D.IdTipoSeg, C.CodCptoTransac CodCpto, S.Cod_Moneda CodMoneda,
           SUM(C.Monto_Reservado_Moneda) MtoMovCuenta, 0 MtoComisCuenta, NULL DescripMov, VL.DESCVALLST UEN, NULL NIVELCTA3
           ,NULL TipoAgente, NULL COD_AGENTE     -- RESICO
      FROM DETALLE_TRANSACCION DT
         , COBERTURA_SINIESTRO  C
         , SINIESTRO            S
         , DETALLE_SINIESTRO    D
         , VALORES_DE_LISTAS         VL
     WHERE S.IdSiniestro        = C.IdSiniestro
       AND S.IdSiniestro        = D.IdSiniestro
       AND S.CodCia             = nCodCia
       AND C.IDSINIESTRO        = DT.VALOR1
       AND C.CODCOBERT          = DT.VALOR3
       AND ( C.IdTransaccion = DT.IdTransaccion
             OR
             C.IdTransaccionAnul = DT.IdTransaccion )
       AND DT.IdTransaccion     = nIdTransaccion
       AND DT.CodCia            = nCodCia
       AND DT.CodEmpresa        = nCodEmpresa
--       AND DT.Correlativo       = 1 ----- JMMD20220422 SOLO ESTABA TOMANDO UN SOLO CONCEPTO DEL DETALLE DE TRANSACCION
       AND VL.CODVALOR = D.IDTIPOSEG
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY s.CodEmpresa, D.IdTipoSeg, C.CodCptoTransac, S.Cod_Moneda, NULL, VL.DESCVALLST
     UNION ALL
    SELECT 16 REG, S.CodEmpresa, D.IdTipoSeg, DA.CodCptoTransac CodCpto, S.Cod_Moneda CodMoneda,
           SUM(DA.Monto_Moneda) MtoMovCuenta, 0 MtoComisCuenta, NULL DescripMov, VL.DESCVALLST UEN,
           OC_CAT_REGIMEN_FISCAL.FUN_NIVELCTA3((select B.IDREGFISSAT
                             from BENEF_SIN b
                             where  DA.CodCptoTransac IN ('RETISR','ISRSIN')
                               AND S.CodCia = B.CodCia
                               AND S.CODEMPRESA = B.CODEMPRESA
                               AND S.IdSiniestro = B.IDSINIESTRO
                               AND B.BENEF = A.BENEF   )) NIVELCTA3
           ,NULL TipoAgente, NULL COD_AGENTE     -- RESICO
      FROM DETALLE_TRANSACCION DT
         , DETALLE_APROBACION  DA
         , APROBACIONES         A
         , SINIESTRO            S
         , DETALLE_SINIESTRO    D
         , VALORES_DE_LISTAS         VL
     WHERE S.IdSiniestro        = A.IdSiniestro
       AND S.IdSiniestro        = D.IdSiniestro
       AND A.IdSiniestro        = DA.IdSiniestro
       AND A.Num_Aprobacion     = DA.Num_Aprobacion
       AND S.CodCia             = nCodCia
       AND A.IDSINIESTRO        = DT.VALOR1
       AND ( A.IdTransaccion = DT.IdTransaccion
             OR
             A.IdTransaccionAnul = DT.IdTransaccion )
       AND DT.IdTransaccion     = nIdTransaccion
       AND DT.CodCia            = nCodCia
       AND DT.CodEmpresa        = nCodEmpresa
       AND DT.Correlativo       = 1
       AND VL.CODVALOR = D.IDTIPOSEG
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY S.CodCia , S.IdSiniestro, S.CodEmpresa, D.IdTipoSeg, DA.CodCptoTransac, S.Cod_Moneda, NULL, VL.DESCVALLST,  A.BENEF
     UNION ALL
    SELECT 17 REG, D.CodEmpresa, TP.IdTipoSeg, 'PRIMDE' CodCpto, P.Cod_Moneda CodMoneda,
           SUM(Monto_Moneda) MtoMovCuenta, 0 MtoComisCuenta, NULL DescripMov, VL.DESCVALLST UEN, NULL NIVELCTA3
           ,NULL TipoAgente, NULL COD_AGENTE     -- RESICO
      FROM DETALLE_TRANSACCION D
         , PRIMAS_DEPOSITO     P
         , TARJETAS_PREPAGO   TP
         , VALORES_DE_LISTAS         VL
     WHERE TP.IdPrimaDeposito = P.IdPrimaDeposito
       AND P.IDPRIMADEPOSITO  = D.VALOR1
       AND ( P.IdTransacEmit  = D.IdTransaccion
             OR
             P.IdTransacAplic = D.IdTransaccion
             OR
             P.IdTransacAnul  = D.IdTransaccion )
       AND D.IdTransaccion    = nIdTransaccion
       AND D.CodCia           = nCodCia
       AND D.CodEmpresa       = nCodEmpresa
       AND VL.CODVALOR = TP.IdTipoSeg
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY D.CodEmpresa, TP.IdTipoSeg, 'PRIMDE', P.Cod_Moneda, NULL, VL.DESCVALLST
     UNION ALL
    SELECT 18 REG, D.CodEmpresa, DP.IdTipoSeg, 'PRIMDE' CodCpto, P.Cod_Moneda CodMoneda,
           SUM(Monto_Moneda) MtoMovCuenta, 0 MtoComisCuenta, NULL DescripMov, VL.DESCVALLST UEN, NULL NIVELCTA3
           ,NULL TipoAgente, NULL COD_AGENTE     -- RESICO
      FROM DETALLE_TRANSACCION D
         , PRIMAS_DEPOSITO     P
         , DETALLE_POLIZA     DP
         , VALORES_DE_LISTAS         VL
     WHERE DP.IDetPol         = P.IDetPol
       AND DP.IdPoliza        = P.IdPoliza
       AND DP.CodCia          = nCodCia
       AND P.IDPRIMADEPOSITO  = D.VALOR1
       AND ( P.IdTransacEmit  = D.IdTransaccion
             OR
             P.IdTransacAplic = D.IdTransaccion
             OR
             P.IdTransacAnul  = D.IdTransaccion )
       AND D.IdTransaccion    = nIdTransaccion
       AND D.CodCia           = nCodCia
       AND D.CodEmpresa       = nCodEmpresa
       AND VL.CODVALOR = DP.IdTipoSeg
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY D.CodEmpresa, DP.IdTipoSeg, 'PRIMDE', P.Cod_Moneda, NULL, VL.DESCVALLST
     UNION ALL
    SELECT 19 REG, DP.CodEmpresa, DP.IdTipoSeg, PD.CodCpto, P.Moneda CodMoneda,
           SUM(PD.Monto) MtoMovCuenta, SUM(F.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov, VL.DESCVALLST UEN, NULL NIVELCTA3
           ,NULL TipoAgente, NULL COD_AGENTE     -- RESICO
      FROM DETALLE_TRANSACCION D
         , FACTURAS            F
         , PAGOS               P
         , PAGO_DETALLE       PD
         , DETALLE_POLIZA     DP
         , VALORES_DE_LISTAS         VL
     WHERE F.IdFactura      = P.IdFactura
       AND PD.IdRecibo      = P.IdRecibo
       AND P.IdTransaccion  = D.IdTransaccion
       AND F.IDetPol        = DP.IDetPol
       AND F.IdPoliza       = DP.IdPoliza
       AND D.IdTransaccion  = nIdTransaccion
       AND D.CodCia         = nCodCia
       AND D.CodEmpresa     = nCodEmpresa
       AND D.Correlativo    = 1
       AND VL.CODVALOR = DP.IdTipoSeg
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY DP.CodEmpresa, DP.IdTipoSeg, PD.CodCpto, P.Moneda, NULL, VL.DESCVALLST
     UNION ALL
    SELECT 20 REG, DP.CodEmpresa, DP.IdTipoSeg, PD.CodCpto, P.Moneda CodMoneda,
           SUM(PD.Monto) MtoMovCuenta, SUM(F.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov, VL.DESCVALLST UEN, NULL NIVELCTA3
           ,NULL TipoAgente, NULL COD_AGENTE     -- RESICO
         FROM DETALLE_TRANSACCION D
         , FACTURAS            F
         , PAGOS               P
         , PAGO_DETALLE       PD
         , DETALLE_POLIZA     DP
         , VALORES_DE_LISTAS         VL
     WHERE F.IdFactura        = P.IdFactura
       AND PD.IdRecibo        = P.IdRecibo
       AND P.IdTransaccionAnu = D.IdTransaccion
       AND F.IDetPol          = DP.IDetPol
       AND F.IdPoliza         = DP.IdPoliza
       AND D.IdTransaccion    = nIdTransaccion
       AND D.CodCia           = nCodCia
       AND D.CodEmpresa       = nCodEmpresa
       AND D.Correlativo      = 1
       AND VL.CODVALOR = DP.IdTipoSeg
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY DP.CodEmpresa, DP.IdTipoSeg, PD.CodCpto, P.Moneda, NULL, VL.DESCVALLST
     UNION ALL
    SELECT 21 REG, PD.CodEmpresa, PD.IdTipoSeg, DECODE(P.FormPago,'NCR','PAGNCR','PAGREC') CodCpto, P.Moneda CodMoneda,
           SUM(P.Monto) MtoMovCuenta, 1 MtoComisCuenta, NULL DescripMov, VL.DESCVALLST UEN, NULL NIVELCTA3
           ,NULL TipoAgente, NULL COD_AGENTE     -- RESICO
      FROM DETALLE_TRANSACCION D
         , FACTURAS            F
         , PAGOS               P
         , DETALLE_POLIZA     PD
         , VALORES_DE_LISTAS         VL
     WHERE F.IdFactura      = P.IdFactura
       AND ( P.IdTransaccion = D.IdTransaccion
             OR
             P.IdTransaccionAnu = D.IdTransaccion )
       AND F.IdetPol        = PD.IdetPol
       AND F.IdPoliza       = PD.IdPoliza
       AND D.IdTransaccion  = nIdTransaccion
       AND D.CodCia         = nCodCia
       AND D.CodEmpresa     = nCodEmpresa
       AND D.Correlativo    = 1
       AND VL.CODVALOR = PD.IdTipoSeg
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY PD.CodEmpresa, PD.IdTipoSeg, DECODE(P.FormPago,'NCR','PAGNCR','PAGREC'), P.Moneda, NULL, VL.DESCVALLST
    UNION ALL
    SELECT 22 REG, S.CodEmpresa, D.IdTipoSeg, C.CodCptoTransac CodCpto, S.Cod_Moneda CodMoneda,
           SUM(C.Monto_Reservado_Moneda) MtoMovCuenta, 0 MtoComisCuenta, NULL DescripMov, VL.DESCVALLST UEN, NULL NIVELCTA3
           ,NULL TipoAgente, NULL COD_AGENTE     -- RESICO
      FROM DETALLE_TRANSACCION      DT
         , COBERTURA_SINIESTRO_ASEG  C
         , SINIESTRO                 S
         , DETALLE_SINIESTRO_ASEG    D
         , VALORES_DE_LISTAS         VL
     WHERE S.IdSiniestro    = C.IdSiniestro
       AND S.IdSiniestro    = D.IdSiniestro
       AND S.CodCia         = nCodCia
       AND C.IDSINIESTRO    = DT.VALOR1
       AND ( C.IdTransaccion = DT.IdTransaccion
             OR
             C.IdTransaccionAnul = DT.IdTransaccion )
       AND DT.IdTransaccion = nIdTransaccion
       AND DT.CodCia        = nCodCia
       AND DT.CodEmpresa    = nCodEmpresa
       AND DT.Correlativo   = 1
       AND VL.CODVALOR = D.IdTipoSeg
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY S.CodEmpresa, D.IdTipoSeg, C.CodCptoTransac, S.Cod_Moneda, NULL, VL.DESCVALLST
     UNION ALL
    SELECT 23 REG, S.CodEmpresa, D.IdTipoSeg, DA.CodCptoTransac CodCpto, S.Cod_Moneda CodMoneda,
           SUM(DA.Monto_Moneda) MtoMovCuenta, 0 MtoComisCuenta, NULL DescripMov, VL.DESCVALLST UEN,
           OC_CAT_REGIMEN_FISCAL.FUN_NIVELCTA3((select B.IDREGFISSAT
                             from BENEF_SIN b
                             where  DA.CodCptoTransac IN ('RETISR','ISRSIN')
                               AND S.CodCia = B.CodCia
                               AND S.CODEMPRESA = B.CODEMPRESA
                               AND S.IdSiniestro = B.IDSINIESTRO
                               AND B.BENEF = A.BENEF  )) NIVELCTA3
           ,NULL TipoAgente, NULL COD_AGENTE     -- RESICO
      FROM DETALLE_TRANSACCION     DT
         , DETALLE_APROBACION_ASEG DA
         , APROBACION_ASEG          A
         , SINIESTRO                S
         , DETALLE_SINIESTRO_ASEG   D
         , VALORES_DE_LISTAS         VL
     WHERE S.IdSiniestro        = A.IdSiniestro
       AND S.IdSiniestro        = D.IdSiniestro
       AND A.IdSiniestro        = DA.IdSiniestro
       AND A.Num_Aprobacion     = DA.Num_Aprobacion
       AND S.CodCia             = nCodCia
       AND A.IDSINIESTRO        = DT.VALOR1
       AND ( A.IdTransaccion = DT.IdTransaccion
             OR
             A.IdTransaccionAnul = DT.IdTransaccion )
       AND DT.IdTransaccion     = nIdTransaccion
       AND DT.CodCia            = nCodCia
       AND DT.CodEmpresa        = nCodEmpresa
       AND DT.Correlativo       = 1
       AND VL.CODVALOR = D.IdTipoSeg
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY S.CodCia , S.IdSiniestro, S.CodEmpresa, D.IdTipoSeg, DA.CodCptoTransac, S.Cod_Moneda, NULL, VL.DESCVALLST  ,  A.BENEF
     UNION ALL
    SELECT 24 REG, D.CodEmpresa, DP.IdTipoSeg, DF.CodCpto, F.Cod_Moneda CodMoneda, SUM(DF.Monto_Det_Moneda) MtoMovCuenta,
           SUM(F.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov, VL.DESCVALLST  UEN, NULL NIVELCTA3
           ,NULL TipoAgente, NULL COD_AGENTE     -- RESICO
      FROM DETALLE_TRANSACCION D
         , DETALLE_FACTURAS   DF
         , FACTURAS            F
         , FZ_DETALLE_FIANZAS DP
         , VALORES_DE_LISTAS         VL
     WHERE DP.IdPoliza      = F.IdPoliza
       AND DP.Correlativo   = NVL(F.IDetPol,DP.Correlativo)
       AND DP.CodCia        = D.CodCia
       AND DF.IdFactura     = F.IdFactura
       AND ( F.IdTransaccion = D.IdTransaccion
             OR
             F.IdTransaccionAnu = D.IdTransaccion )
       AND D.IdTransaccion  = nIdTransaccion
       AND D.CodCia         = nCodCia
       AND D.CodEmpresa     = nCodEmpresa
       AND D.Correlativo    = 1
       AND VL.CODVALOR = DP.IdTipoSeg
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY D.CodEmpresa, DP.IdTipoSeg, DF.CodCpto, F.Cod_Moneda, NULL, VL.DESCVALLST
     UNION ALL
    SELECT 25 REG, CF.CodEmpresa, DP.IdTipoSeg, CF.CodCptoMov CodCpto, CF.CodMonedaPago CodMoneda, SUM(CF.MontoMovMoneda) MtoMovCuenta,
           SUM(F.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov, VL.DESCVALLST  UEN, NULL NIVELCTA3
           ,NULL TipoAgente, NULL COD_AGENTE     -- RESICO
      FROM DETALLE_TRANSACCION      D
         , FAI_CONCENTRADORA_FONDO CF
         , FACTURAS                 F
         , DETALLE_POLIZA          DP
         , VALORES_DE_LISTAS         VL
     WHERE DP.IdPoliza         = CF.IdPoliza
       AND DP.IDetPol          = CF.IDetPol
       AND DP.CodCia           = CF.CodCia
       AND CF.IdFondo          > 0
       AND CF.CodAsegurado     > 0
       AND CF.IDetPol          > 0
       AND CF.IdPoliza         > 0
       AND CF.IdFactura        = F.IdFactura(+)
       AND ( CF.IdTransaccion = D.IdTransaccion
             OR
             CF.IdTransaccionAnu = D.IdTransaccion )
       AND CF.CodEmpresa       = D.CodEmpresa
       AND CF.CodCia           = D.CodCia
       AND GT_FAI_MOVIMIENTOS_FONDOS.INDICADORES( CF.CodCia, CF.CodEmpresa,
                                                  GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO(CF.IdFondo),
                                                  CF.CodCptoMov, 'GC') = 'S'
       AND D.IdTransaccion     = nIdTransaccion
       AND D.CodCia            = nCodCia
       AND D.CodEmpresa        = nCodEmpresa
       AND D.Correlativo       = 1
       AND VL.CODVALOR = DP.IdTipoSeg
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY CF.CodEmpresa, DP.IdTipoSeg, CF.CodCptoMov, CF.CodMonedaPago, NULL, VL.DESCVALLST
   UNION ALL
   SELECT REG, CodEmpresa, IdTipoSeg, CodCpto, CodMoneda, SUM(MtoMovCuenta) MtoMovCuenta, --MLJS 01/09/2023 SE AGREGA PARA OBTENER SOLO UN REGISTRO DE HONORARIOS
        SUM( MtoComisCuenta)  MtoComisCuenta, DescripMov, UEN, NIVELCTA3                  --MLJS 01/09/2023
        , TipoAgente, COD_AGENTE     -- RESICO
   FROM (
   SELECT 26 REG, T.CodEmpresa, DP.IdTipoSeg, DC.CodConcepto CodCpto, P.Cod_Moneda CodMoneda, SUM(DC.Monto_Mon_Extranjera) MtoMovCuenta,
        SUM(DC.Monto_Mon_Extranjera) MtoComisCuenta, 'FACTURAS CONTABILIZADAS' DescripMov, VL.DESCVALLST  UEN, NULL NIVELCTA3
        ,OC_AGENTES.TIPO_AGENTE(P.CodCia, C.Cod_Agente) TipoAgente, C.COD_AGENTE     -- RESICO
   FROM POLIZAS P, DETALLE_POLIZA DP, FACTURAS F, TRANSACCION T, COMISIONES C, DETALLE_COMISION DC
         , VALORES_DE_LISTAS         VL
   WHERE T.IDTRANSACCION     = nIdTransaccion
    AND T.CodCia            = nCodCia
    AND (F.IDTRANSACCION     = T.IDTRANSACCION
     OR F.IDTRANSACCIONANU   = T.IDTRANSACCION)
    AND P.IDPOLIZA          = F.IDPOLIZA
    AND P.CodCia            = nCodCia
    AND DP.IDPOLIZA         = P.IDPOLIZA
    AND DP.CodCia           = P.CodCia
    AND DP.IDETPOL          = NVL(C.IDetPol,DP.IDetPol)
    AND ((TRUNC(F.FecVenc) <= TRUNC(FechaTransaccion)
    AND   OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, T.CodEmpresa, DP.IdTipoSeg) = 'DEVENG')
     OR OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, T.CodEmpresa, DP.IdTipoSeg) = 'ANTICI')
    AND C.CodCia            = nCodCia
    AND C.IDPOLIZA          = P.IDPOLIZA
    AND C.COD_MONEDA        = P.COD_MONEDA
    AND C.IDFACTURA         = F.IDFACTURA
    AND DC.CodCia           = C.CodCia
    AND DC.IDCOMISION       = C.IDCOMISION
    --AND DC.CODCONCEPTO      = 'IVAHON'
    AND (OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(P.CodCia, P.CODEMPRESA, DP.IDTIPOSEG) = 'N' AND DC.CODCONCEPTO      = 'IVAHON'
     OR OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(P.CodCia, P.CODEMPRESA, DP.IDTIPOSEG) = 'S' AND DC.CODCONCEPTO      != 'IVASIN')
    AND C.IDCOMISION        = DC.IDCOMISION
       AND VL.CODVALOR = DP.IdTipoSeg
       AND VL.CODLISTA = 'UENXTIPSEG'
   GROUP BY T.CodEmpresa, DP.IdTipoSeg, DC.CodCONCEpto, p.Cod_Moneda, 'FACTURAS CONTABILIZADAS', VL.DESCVALLST
            ,C.Cod_Agente, P.CodCia
    )
    GROUP BY REG, CodEmpresa, IdTipoSeg, CodCpto, CodMoneda, DescripMov, UEN, NIVELCTA3
        , TipoAgente, COD_AGENTE     -- RESICO
    UNION ALL
    SELECT 27 REG, D.CodEmpresa, DP.IdTipoSeg, DC.CODCONCEPTO CodCpto, N.CodMoneda, SUM(Monto_Det_Moneda) MtoMovCuenta,
           SUM(DC.MONTO_MON_EXTRANJERA) MtoComisCuenta, NULL DescripMov, VL.DESCVALLST UEN, NULL NIVELCTA3
           ,OC_AGENTES.TIPO_AGENTE(P.CodCia, C.Cod_Agente) TipoAgente, C.COD_AGENTE     -- RESICO
      FROM DETALLE_TRANSACCION       D
         , NOTAS_DE_CREDITO          N
         , DETALLE_NOTAS_DE_CREDITO DN
         , POLIZAS P
         , DETALLE_POLIZA           DP
         , COMISIONES C , DETALLE_COMISION DC
         , VALORES_DE_LISTAS         VL
     WHERE D.IdTransaccion      = nIdTransaccion
       AND D.CodCia             = nCodCia
       AND D.CodEmpresa         = nCodEmpresa
       AND D.Correlativo        = 1
       AND N.IdTransaccion      = D.IdTransaccion
       AND DN.IdNcr             = N.IdNcr
       AND P.CodCia             = N.CodCia
       AND P.IDPOLIZA           = N.IDPOLIZA
       AND DP.IdPoliza          = N.IdPoliza
       AND DP.IDetPol           = NVL(N.IDetPol, DP.IDetPol)
       AND DP.CodCia            = D.CodCia
       AND C.CodCia             = nCodCia
       AND C.IDPOLIZA           = P.IDPOLIZA
       AND C.COD_MONEDA         = P.COD_MONEDA
       AND C.IDNCR              = N.IDNCR
       AND DC.CodCia            = C.CodCia
       AND DC.IDCOMISION        = C.IDCOMISION
       --AND DC.CODCONCEPTO       = 'IVAHON'
       AND (OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(P.CodCia, P.CODEMPRESA, DP.IDTIPOSEG) = 'N' AND DC.CODCONCEPTO      = 'IVAHON'
        OR OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(P.CodCia, P.CODEMPRESA, DP.IDTIPOSEG) = 'S' AND DC.CODCONCEPTO      != 'IVASIN')
       AND C.IDCOMISION         = DC.IDCOMISION
       AND VL.CODVALOR = DP.IdTipoSeg
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY D.CodEmpresa, DP.IdTipoSeg, DC.CODCONCEPTO, N.CodMoneda, NULL, VL.DESCVALLST
               ,P.CodCia, C.Cod_Agente
     UNION ALL
    SELECT 28 REG, D.CodEmpresa, DP.IdTipoSeg, DC.CODCONCEPTO CodCpto, N.CodMoneda, SUM(Monto_Det_Moneda) MtoMovCuenta,
           SUM(DC.MONTO_MON_EXTRANJERA) MtoComisCuenta, NULL DescripMov, VL.DESCVALLST UEN, NULL NIVELCTA3 
           ,OC_AGENTES.TIPO_AGENTE(P.CodCia, C.Cod_Agente) TipoAgente, C.COD_AGENTE     -- RESICO
      FROM DETALLE_TRANSACCION       D
         , NOTAS_DE_CREDITO          N
         , DETALLE_NOTAS_DE_CREDITO DN
         , POLIZAS P
         , DETALLE_POLIZA           DP
         , COMISIONES C , DETALLE_COMISION DC
         , VALORES_DE_LISTAS         VL
     WHERE D.IdTransaccion      = nIdTransaccion
       AND D.CodCia             = nCodCia
       AND D.CodEmpresa         = nCodEmpresa
       AND D.Correlativo        = 1
       AND N.IdTransaccionAnu   = D.IdTransaccion
       AND DN.IdNcr             = N.IdNcr
       AND P.CodCia             = N.CodCia
       AND P.IDPOLIZA           = N.IDPOLIZA
       and DP.IdPoliza          = N.IdPoliza
       AND DP.IDetPol           = NVL(N.IDetPol, DP.IDetPol)
       AND DP.CodCia            = D.CodCia
       AND C.CodCia             = nCodCia
       AND C.IDPOLIZA           = P.IDPOLIZA
       AND C.COD_MONEDA         = P.COD_MONEDA
       AND C.IDNCR              = N.IDNCR
       AND DC.CodCia            = C.CodCia
       AND DC.IDCOMISION        = C.IDCOMISION
       --AND DC.CODCONCEPTO       = 'IVAHON'
       AND (OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(P.CodCia, P.CODEMPRESA, DP.IDTIPOSEG) = 'N' AND DC.CODCONCEPTO      = 'IVAHON'
        OR OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(P.CodCia, P.CODEMPRESA, DP.IDTIPOSEG) = 'S' AND DC.CODCONCEPTO      != 'IVASIN')
       AND C.IDCOMISION         = DC.IDCOMISION
       AND VL.CODVALOR = DP.IdTipoSeg
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY D.CodEmpresa, DP.IdTipoSeg, DC.CODCONCEPTO, N.CodMoneda, NULL, VL.DESCVALLST
               ,P.CodCia, C.Cod_Agente
     UNION ALL
    SELECT 29 REG, D.CodEmpresa, DP.IdTipoSeg, DC.CODCONCEPTO CodCpto, N.CodMoneda, SUM(Monto_Det_Moneda) MtoMovCuenta,
           SUM(DC.MONTO_MON_EXTRANJERA) MtoComisCuenta, NULL DescripMov, VL.DESCVALLST UEN, NULL NIVELCTA3
           ,OC_AGENTES.TIPO_AGENTE(P.CodCia, C.Cod_Agente) TipoAgente, C.COD_AGENTE     -- RESICO
      FROM DETALLE_TRANSACCION       D
         , NOTAS_DE_CREDITO          N
         , DETALLE_NOTAS_DE_CREDITO DN
         , POLIZAS                  P
         , DETALLE_POLIZA           DP
         , COMISIONES C , DETALLE_COMISION DC
         , VALORES_DE_LISTAS         VL
     WHERE D.IdTransaccion      = nIdTransaccion
       AND D.CodCia             = nCodCia
       AND D.CodEmpresa         = nCodEmpresa
       AND D.Correlativo        = 1
       AND N.IdTransacAplic     = D.IdTransaccion
       AND DN.IdNcr             = N.IdNcr
       AND P.CodCia             = N.CodCia
       AND P.IDPOLIZA           = N.IDPOLIZA
       AND DP.IdPoliza          = N.IdPoliza
       AND DP.IDetPol           = NVL(N.IDetPol, DP.IDetPol)
       AND DP.CodCia            = D.CodCia
       AND C.CodCia             = nCodCia
       AND C.IDPOLIZA           = P.IDPOLIZA
       AND C.COD_MONEDA         = P.COD_MONEDA
       AND C.IDNCR              = N.IDNCR
       AND DC.CodCia            = C.CodCia
       AND DC.IDCOMISION        = C.IDCOMISION
       --AND DC.CODCONCEPTO       = 'IVAHON'
       AND (OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(P.CodCia, P.CODEMPRESA, DP.IDTIPOSEG) = 'N' AND DC.CODCONCEPTO      = 'IVAHON'
        OR OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(P.CodCia, P.CODEMPRESA, DP.IDTIPOSEG) = 'S' AND DC.CODCONCEPTO      != 'IVASIN')
       AND C.IDCOMISION         = DC.IDCOMISION
       AND VL.CODVALOR = DP.IdTipoSeg
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY D.CodEmpresa, DP.IdTipoSeg, DC.CODCONCEPTO, N.CodMoneda, NULL, VL.DESCVALLST
               ,P.CodCia, C.Cod_Agente
     UNION ALL
    SELECT 30 REG, D.CodEmpresa, DP.IdTipoSeg, DC.CODCONCEPTO CodCpto, N.CodMoneda, SUM(Monto_Det_Moneda) MtoMovCuenta,
           SUM(DC.MONTO_MON_EXTRANJERA) MtoComisCuenta, NULL DescripMov, VL.DESCVALLST UEN, NULL NIVELCTA3
           ,OC_AGENTES.TIPO_AGENTE(P.CodCia, C.Cod_Agente) TipoAgente, C.COD_AGENTE     -- RESICO
      FROM DETALLE_TRANSACCION       D
         , NOTAS_DE_CREDITO          N
         , DETALLE_NOTAS_DE_CREDITO DN
         , POLIZAS                  P
         , DETALLE_POLIZA           DP
         , COMISIONES C , DETALLE_COMISION DC
         , VALORES_DE_LISTAS         VL
     WHERE D.IdTransaccion      = nIdTransaccion
       AND D.CodCia             = nCodCia
       AND D.CodEmpresa         = nCodEmpresa
       AND D.Correlativo        = 1
       AND N.IdTransacRevAplic  = D.IdTransaccion
       AND DN.IdNcr             = N.IdNcr
       AND P.CodCia             = N.CodCia
       AND P.IDPOLIZA           = N.IDPOLIZA
       AND DP.IdPoliza          = N.IdPoliza
       AND DP.IDetPol           = NVL(N.IDetPol, DP.IDetPol)
       AND DP.CodCia            = D.CodCia
       AND C.CodCia             = nCodCia
       AND C.IDPOLIZA           = P.IDPOLIZA
       AND C.COD_MONEDA         = P.COD_MONEDA
       AND C.IDNCR              = N.IDNCR
       AND DC.CodCia            = C.CodCia
       AND DC.IDCOMISION        = C.IDCOMISION
       --AND DC.CODCONCEPTO       = 'IVAHON'
       AND (OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(P.CodCia, P.CODEMPRESA, DP.IDTIPOSEG) = 'N' AND DC.CODCONCEPTO      = 'IVAHON'
        OR OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(P.CodCia, P.CODEMPRESA, DP.IDTIPOSEG) = 'S' AND DC.CODCONCEPTO      != 'IVASIN')
       AND C.IDCOMISION         = DC.IDCOMISION
       AND VL.CODVALOR = DP.IdTipoSeg
       AND VL.CODLISTA = 'UENXTIPSEG'
     GROUP BY D.CodEmpresa, DP.IdTipoSeg, DC.CODCONCEPTO, N.CodMoneda, NULL , VL.DESCVALLST
               ,P.CodCia, C.Cod_Agente
   UNION ALL
   SELECT REG, CodEmpresa, IdTipoSeg, CodCpto, CodMoneda, SUM(MtoMovCuenta) MtoMovCuenta, --MLJS 13/09/2023 SE AGREGA PARA OBTENER SOLO UN REGISTRO DE HONORARIOS
        SUM( MtoComisCuenta)  MtoComisCuenta, DescripMov, UEN, NIVELCTA3                  --MLJS 13/09/2023
        , TipoAgente, COD_AGENTE     -- RESICO
   FROM (
   SELECT 31 REG, T.CodEmpresa, DP.IdTipoSeg, DC.CodConcepto CodCpto, P.Cod_Moneda CodMoneda, SUM(DC.Monto_Mon_Extranjera) MtoMovCuenta,
                SUM(DC.Monto_Mon_Extranjera) MtoComisCuenta, 'FACTURAS CONTABILIZADAS' DescripMov, VL.DESCVALLST  UEN, NULL NIVELCTA3
                ,OC_AGENTES.TIPO_AGENTE(P.CodCia, C.Cod_Agente) TipoAgente, C.COD_AGENTE     -- RESICO
   FROM POLIZAS P, DETALLE_POLIZA DP, 
         PAGOS PA, FACTURAS F,
         TRANSACCION T , COMISIONES C, DETALLE_COMISION DC
         , VALORES_DE_LISTAS         VL
   WHERE T.IDTRANSACCION     = nIdTransaccion
    AND T.CodCia            = nCodCia
    AND PA.IDTRANSACCION     = T.IDTRANSACCION
    AND F.IDFACTURA          = PA.IDFACTURA
    AND P.IDPOLIZA          = F.IDPOLIZA
    AND P.CodCia            = nCodCia
    AND DP.IDPOLIZA         = P.IDPOLIZA
    AND DP.CodCia           = P.CodCia
    AND DP.IDETPOL          = NVL(C.IDetPol,DP.IDetPol)
    AND ((TRUNC(F.FecVenc) <= TRUNC(FechaTransaccion)
    AND   OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, T.CodEmpresa, DP.IdTipoSeg) = 'DEVENG')
     OR OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, T.CodEmpresa, DP.IdTipoSeg) = 'ANTICI')
    AND C.CodCia            = nCodCia
    AND C.IDPOLIZA          = P.IDPOLIZA
    AND C.COD_MONEDA        = P.COD_MONEDA
    AND C.IDFACTURA         = F.IDFACTURA
    AND DC.CodCia           = C.CodCia
    AND DC.IDCOMISION       = C.IDCOMISION
    --AND DC.CODCONCEPTO      = 'IVAHON'
    AND (OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(P.CodCia, P.CODEMPRESA, DP.IDTIPOSEG) = 'N' AND DC.CODCONCEPTO      = 'IVAHON'
     OR OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(P.CodCia, P.CODEMPRESA, DP.IDTIPOSEG) = 'S' AND DC.CODCONCEPTO      != 'IVASIN')
    AND C.IDCOMISION        = DC.IDCOMISION
     AND VL.CODVALOR = DP.IdTipoSeg
     AND VL.CODLISTA = 'UENXTIPSEG'
   GROUP BY T.CodEmpresa, DP.IdTipoSeg, DC.CodCONCEpto, p.Cod_Moneda, 'FACTURAS CONTABILIZADAS' , VL.DESCVALLST
            ,P.CodCia, C.Cod_Agente
   )GROUP BY REG, CodEmpresa, IdTipoSeg, CodCpto, CodMoneda,  --MLJS 13/09/2023 SE AGREGA PARA OBTENER SOLO UN REGISTRO DE HONORARIOS
             DescripMov, UEN, NIVELCTA3                       --MLJS 13/09/2023
        , TipoAgente, COD_AGENTE     -- RESICO
   UNION ALL
   SELECT REG, CodEmpresa, IdTipoSeg, CodCpto, CodMoneda, SUM(MtoMovCuenta) MtoMovCuenta, --MLJS 13/09/2023 SE AGREGA PARA OBTENER SOLO UN REGISTRO DE HONORARIOS
        SUM( MtoComisCuenta)  MtoComisCuenta, DescripMov, UEN, NIVELCTA3                  --MLJS 13/09/2023
        , TipoAgente, COD_AGENTE     -- RESICO
   FROM (
   SELECT 32 REG, T.CodEmpresa, DP.IdTipoSeg, 'TRIVHO' CodCpto, P.Cod_Moneda CodMoneda, SUM(DC.Monto_Mon_Extranjera) * -1 MtoMovCuenta,
          SUM(DC.Monto_Mon_Extranjera) * -1 MtoComisCuenta, 'FACTURAS CONTABILIZADAS' DescripMov, VL.DESCVALLST  UEN, NULL NIVELCTA3
          ,OC_AGENTES.TIPO_AGENTE(P.CodCia, C.Cod_Agente) TipoAgente, C.COD_AGENTE     -- RESICO
   FROM POLIZAS P, DETALLE_POLIZA DP,
         PAGOS PA, FACTURAS F,
         TRANSACCION T , COMISIONES C, DETALLE_COMISION DC
         , VALORES_DE_LISTAS         VL
   WHERE T.IDTRANSACCION     = nIdTransaccion
    AND T.CodCia            = nCodCia
    AND PA.IDTRANSACCION     = T.IDTRANSACCION
    AND F.IDFACTURA          = PA.IDFACTURA
    AND P.IDPOLIZA          = F.IDPOLIZA
    AND P.CodCia            = nCodCia
    AND DP.IDPOLIZA         = P.IDPOLIZA
    AND DP.CodCia           = P.CodCia
    AND DP.IDETPOL          = NVL(C.IDetPol,DP.IDetPol)
    AND ((TRUNC(F.FecVenc) <= TRUNC(FechaTransaccion)
    AND   OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, T.CodEmpresa, DP.IdTipoSeg) = 'DEVENG')
     OR OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, T.CodEmpresa, DP.IdTipoSeg) = 'ANTICI')
    AND C.CodCia            = nCodCia
    AND C.IDPOLIZA          = P.IDPOLIZA
    AND C.COD_MONEDA        = P.COD_MONEDA
    AND C.IDFACTURA         = F.IDFACTURA
    AND DC.CodCia           = C.CodCia
    AND DC.IDCOMISION       = C.IDCOMISION
    --AND DC.CODCONCEPTO      = 'IVAHON'
    AND (OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(P.CodCia, P.CODEMPRESA, DP.IDTIPOSEG) = 'N' AND DC.CODCONCEPTO      = 'IVAHON'
     OR OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(P.CodCia, P.CODEMPRESA, DP.IDTIPOSEG) = 'S' AND DC.CODCONCEPTO      != 'IVASIN')
    AND C.IDCOMISION        = DC.IDCOMISION
       AND VL.CODVALOR = DP.IdTipoSeg
       AND VL.CODLISTA = 'UENXTIPSEG'
   GROUP BY T.CodEmpresa, DP.IdTipoSeg, DC.CodCONCEpto, p.Cod_Moneda, 'FACTURAS CONTABILIZADAS', VL.DESCVALLST
            ,P.CodCia, C.Cod_Agente
   ) group by REG, CodEmpresa, IdTipoSeg, CodCpto, CodMoneda,  --MLJS 13/09/2023 SE AGREGA PARA OBTENER SOLO UN REGISTRO DE HONORARIOS
             DescripMov, UEN, NIVELCTA3                        --MLJS 13/09/2023
        , TipoAgente, COD_AGENTE     -- RESICO
     ;

FUNCTION NUM_COMPROBANTE(nCodCia NUMBER) RETURN NUMBER IS
nNumComprob   COMPROBANTES_CONTABLES.NumComprob%TYPE;
BEGIN
--   BEGIN                                      -- JICO  JICO 20151229
--      SELECT NVL(MAX(NumComprob),0)+1
--        INTO nNumComprob
--        FROM COMPROBANTES_CONTABLES
--       WHERE CodCia = nCodCia;
--   END;

  SELECT SQ_COMPR_CONTA.NEXTVAL      -- JICO  JICO 20151229
    INTO nNumComprob
    FROM DUAL;

   RETURN(nNumComprob);
END NUM_COMPROBANTE;

FUNCTION CREA_COMPROBANTE(nCodCia NUMBER, cTipoComprob VARCHAR2, nNumTransaccion NUMBER,
                          cTipoDiario VARCHAR2, cCodMoneda VARCHAR2) RETURN NUMBER IS
nNumComprob   COMPROBANTES_CONTABLES.NumComprob%TYPE;
BEGIN
   nNumComprob := OC_COMPROBANTES_CONTABLES.NUM_COMPROBANTE(nCodCia);

   BEGIN
      INSERT INTO COMPROBANTES_CONTABLES
             (CodCia, NumComprob, TipoComprob, FecComprob, StsComprob, FecSts,
              NumTransaccion, TotalDebitos, TotalCreditos, TotalDifComp,
              FecEnvioSC, NumComprobSC, FecEnvioSun, NumComprobSun, TipoDiario,
              CodMoneda, IndAutomatico)
      VALUES (nCodCia, nNumComprob, cTipoComprob, TRUNC(SYSDATE), 'DES', TRUNC(SYSDATE),
              nNumTransaccion, 0 , 0 , 0, NULL, NULL, NULL, NULL, cTipoDiario,
              cCodMoneda, 'S');
   END;
   RETURN(nNumComprob);
END CREA_COMPROBANTE;

PROCEDURE CUADRA_COMPROBANTE(nCodCia NUMBER, nNumComprob NUMBER) IS
nTotDebitos          COMPROBANTES_CONTABLES.TotalDebitos%TYPE;
nTotCreditos         COMPROBANTES_CONTABLES.TotalCreditos%TYPE;
nTotDebitosLocal     COMPROBANTES_CONTABLES.TotalDebitosLocal%TYPE;
nTotCreditosLocal    COMPROBANTES_CONTABLES.TotalCreditosLocal%TYPE;
nTotalDifComp        COMPROBANTES_CONTABLES.TotalDifComp%TYPE;
cStsComprob          COMPROBANTES_CONTABLES.stscomprob%TYPE;
BEGIN

   nTotDebitos        := OC_COMPROBANTES_DETALLE.TOTAL_DEBITOS(nCodCia, nNumComprob);
   nTotCreditos       := OC_COMPROBANTES_DETALLE.TOTAL_CREDITOS(nCodCia, nNumComprob);
   nTotDebitosLocal   := OC_COMPROBANTES_DETALLE.TOTAL_DEBITOS_LOCAL(nCodCia, nNumComprob);
   nTotCreditosLocal  := OC_COMPROBANTES_DETALLE.TOTAL_CREDITOS_LOCAL(nCodCia, nNumComprob);
   nTotalDifComp      := ABS(nTotDebitos - nTotCreditos);

   IF nTotalDifComp = 0 AND (nTotDebitos != 0 OR nTotCreditos != 0) THEN
      cStsComprob := 'CUA';
   ELSE
      cStsComprob := 'DES';
   END IF;

   BEGIN
      UPDATE COMPROBANTES_CONTABLES
         SET StsComprob         = cStsComprob,
             FecSts             = FecComprob,
             TotalDebitos       = nTotDebitos,
             TotalCreditos      = nTotCreditos,
             TotalDebitosLocal  = nTotDebitosLocal,
             TotalCreditosLocal = nTotCreditosLocal,
             TotalDifComp       = nTotalDifComp
       WHERE CodCia     = nCodCia
         AND NumComprob = nNumComprob;
   END;
END CUADRA_COMPROBANTE;

PROCEDURE ANULA_COMPROBANTE(nCodCia NUMBER, nNumComprob NUMBER) IS
BEGIN
   BEGIN
      UPDATE COMPROBANTES_CONTABLES
         SET StsComprob  = 'ANU',
             FecSts      = TRUNC(SYSDATE)
       WHERE CodCia     = nCodCia
         AND NumComprob = nNumComprob;
   END;
END ANULA_COMPROBANTE;

PROCEDURE REHABILITA_COMPROBANTE(nCodCia NUMBER, nNumComprob NUMBER) IS
BEGIN
   OC_COMPROBANTES_CONTABLES.CUADRA_COMPROBANTE(nCodCia, nNumComprob);
END REHABILITA_COMPROBANTE;

PROCEDURE REVERSA_COMPROBANTE(nCodCia NUMBER, nNumComprob NUMBER, cTipoCompRev VARCHAR2) IS
nNumComprobRev    COMPROBANTES_CONTABLES.NumComprob%TYPE;
nNumTransaccion   COMPROBANTES_CONTABLES.NumTransaccion%TYPE;
cTipoDiario       COMPROBANTES_CONTABLES.TipoDiario%TYPE;
cCodMoneda        COMPROBANTES_CONTABLES.CodMoneda%TYPE;
dFecComprob       COMPROBANTES_CONTABLES.FecComprob%TYPE;
BEGIN
   BEGIN
      SELECT NumTransaccion, TipoDiario, CodMoneda
        INTO nNumTransaccion, cTipoDiario, cCodMoneda
        FROM COMPROBANTES_CONTABLES
       WHERE CodCia     = nCodCia
         AND NumComprob = nNumComprob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20000,'No Existe Comprobante No. '||nNumComprob || ' de Compania ' || nCodCia);
   END;
--   nNumTransaccion := OC_TRANSACCIONES.CREAR_TRANSACCION;
   nNumComprobRev  := OC_COMPROBANTES_CONTABLES.CREA_COMPROBANTE(nCodCia, cTipoCompRev, nNumTransaccion, cTipoDiario, cCodMoneda);
   OC_COMPROBANTES_DETALLE.REVERSA_DETALLE(nCodCia, nNumComprob, nNumComprobRev);

   BEGIN
      SELECT FecComprob
        INTO dFecComprob
        FROM COMPROBANTES_CONTABLES
       WHERE CodCia     = nCodCia
         AND NumComprob = nNumComprobRev;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20000,'No Existe Comprobante de Reverso No. '||nNumComprobRev || ' de Compania' || nCodCia);
   END;

   OC_COMPROBANTES_DETALLE.ACTUALIZA_FECHA(nCodCia, nNumComprob, dFecComprob);
   OC_COMPROBANTES_CONTABLES.CUADRA_COMPROBANTE(nCodCia, nNumComprobRev);
END REVERSA_COMPROBANTE;

PROCEDURE ACTUALIZA_ENVIO(nCodCia NUMBER, nNumComprob NUMBER, nNumPolMizar NUMBER := 0) IS
BEGIN
   BEGIN
      UPDATE COMPROBANTES_CONTABLES
         SET StsComprob  = 'ENV',
             FecSts      = TRUNC(SYSDATE),
             FecEnvioSC  = TRUNC(SYSDATE),
             NUMCOMPROBSC= nNumPolMizar
       WHERE CodCia     = nCodCia
         AND NumComprob = nNumComprob;
   END;
END ACTUALIZA_ENVIO;

PROCEDURE CONTABILIZAR( nCodCia         TRANSACCION.CODCIA%TYPE
                      , nIdTransaccion  TRANSACCION.IDTRANSACCION%TYPE
                      , cTipoComp       VARCHAR2 DEFAULT 'C' ) IS
   nCodEmpresa        TIPOS_DE_SEGUROS.CodEmpresa%TYPE;
   cIdTipoSeg         TIPOS_DE_SEGUROS.IdTipoSeg%TYPE;
   cCodCpto           CONCEPTOS_PLAN_DE_PAGOS.CodCpto%TYPE;
   cTipoComprob       PROCESOS_CONTABLES.TipoComprob%TYPE;
   nNumComprob        COMPROBANTES_CONTABLES.NumComprob%TYPE  := 0;
   cDescMovCuenta     COMPROBANTES_DETALLE.DescMovCuenta%TYPE := NULL;
   cDescMovGeneral    COMPROBANTES_DETALLE.DescMovCuenta%TYPE := NULL;
   nMtoMovCuenta      COMPROBANTES_DETALLE.MtoMovCuenta%TYPE;
   nMtoMovCuentaLocal COMPROBANTES_DETALLE.MtoMovCuentaLocal%TYPE;
   nIdProceso         TRANSACCION.IdProceso%TYPE;
   cDescProceso       PROC_TAREA.Descripcion_Proceso%TYPE;
   cCodSubProceso     SUB_PROCESO.CodSubProceso%TYPE;
   cDescSubProceso    SUB_PROCESO.Descripcion%TYPE;
   dFechaTransaccion  TRANSACCION.FechaTransaccion%TYPE;
   cCodProceso        SUB_PROCESO.CodProcesoCont%TYPE;
   cDescConcepto      VALORES_DE_LISTAS.DescValLst%TYPE;
   nIdTransac         TRANSACCION.IdTransaccion%TYPE;
   cTipoDiario        COMPROBANTES_CONTABLES.TipoDiario%TYPE;
   cCodMoneda         COMPROBANTES_CONTABLES.CodMoneda%TYPE := NULL;
   cCodMonedaCia      EMPRESAS.Cod_Moneda%TYPE;
   nTasaCambio        TASAS_CAMBIO.Tasa_Cambio%TYPE;
   cContabilizo       VARCHAR2(1);
   cConceptoAdicional VARCHAR2(1);
   cTipoAgente        AGENTES.Tipo_Agente%TYPE;
   nIdRegFisSAT       NUMBER;     -- RESICO
   --
   --Opt:07082019  Optimizacion
   --Se agrega CodEmpresa para entrar por la llave de la tabla Detalle_Transaccion en diversas consultas
   --Se ordenan las columnas para acceder a las tablas por la llave primaria en el orden correcto de las mismas
   --
   --Opt:07082019
   CURSOR PLANT_Q IS
      SELECT NivelCta1, NivelCta2, NivelCta3, NivelCta4, NivelCta5,
             NivelCta6, NivelCta7, NivelAux, RegDebCred, TipoRegistro,
             CodCentroCosto, CodUnidadNegocio, TipoPersona, CanalComisVenta,
             DescCptoGeneral, TipoAgente, NVL(IdRegFisSAT, 0) IdRegFisSAT     -- RESICO
        FROM PLANTILLAS_CONTABLES
       WHERE CodCia              = nCodCia
         AND CodProceso          = cCodProceso
         AND CodMoneda           = cCodMoneda
         AND CodCpto             = cCodCpto
         AND IdTipoSeg           = cIdTipoSeg
         AND CodEmpresa          = nCodEmpresa
         AND (OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(CodCia, CODEMPRESA, cIdTipoSeg) = 'S' AND NVL(TipoAgente,'X') = NVL(cTipoAgente,'X')
          OR  OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(CodCia, CODEMPRESA, cIdTipoSeg) = 'N' )
        -- AND NVL(IdRegFisSAT, -1) = nvl(:nIdRegFisSAT, -1)     -- RESICO I
         AND (IDREGFISSAT = nIdRegFisSAT 
          OR (IDREGFISSAT IS NULL AND IDREGPLANTILLA NOT IN (SELECT IDREGPLANTILLA_SUST 
                                                                  FROM PLANTILLAS_CONTABLES P 
                                                                  WHERE P.CodCia              = CodCia
                                                                    AND P.CodProceso          = CodProceso
                                                                    AND P.CodMoneda           = CodMoneda
                                                                    AND P.CodCpto             = CodCpto
                                                                    AND P.IdTipoSeg           = IdTipoSeg  
                                                                    AND P.TIPOAGENTE          = TIPOAGENTE
                                                                    AND P.IDREGFISSAT         = nIdRegFisSAT)
               ))     -- RESICO F
        ORDER BY IdRegPlantilla;

   --
   --Opt:07082019
   CURSOR SUBPROC_Q IS
      SELECT DISTINCT CodSubProceso
        INTO cCodSubProceso
        FROM DETALLE_TRANSACCION
       WHERE IdTransaccion = nIdTransaccion
         AND CodCia        = nCodCia
       ORDER BY CodSubProceso;
   --
   --Opt:07082019

BEGIN
   --
   cCodMonedaCia  := OC_EMPRESAS.MONEDA_COMPANIA(nCodCia);
   cContabilizo   := 'N';

   FOR Z IN SUBPROC_Q LOOP
      BEGIN
         --
         --Opt:07082019
         SELECT DISTINCT T.IdProceso, T.FechaTransaccion, S.CodProcesoCont, T.CodEmpresa
           INTO nIdProceso, dFechaTransaccion, cCodProceso, nCodEmpresa
           FROM TRANSACCION T
              , SUB_PROCESO S
          WHERE S.IdProceso     = T.IdProceso
            AND S.CodSubProceso = Z.CodSubProceso
            AND T.IdTransaccion = nIdTransaccion
            AND T.CodCia        = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR (-20100,'No de Transaccion '||nIdTransaccion||' NO Encuentra el SubProceso '||Z.CodSubProceso);
         WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR (-20100,'No de Transaccion '||nIdTransaccion||' Posee Más de un Proceso');
      END;
      --

     IF OC_SUB_PROCESO.GENERA_CONTABILIDAD(nIdProceso, Z.CodSubProceso) = 'S' THEN
         -- Lee el Tipo de Comprobante a Crear
         IF NVL(nNumComprob,0) = 0 THEN
            cTipoComprob := OC_PROCESOS_CONTABLES.TIPO_COMPROBANTE(nCodCia, cCodProceso, cTipoComp);
            cTipoDiario  := OC_PROCESOS_CONTABLES.TIPO_DIARIO(nCodCia, cCodProceso);
            nNumComprob  := CREA_COMPROBANTE(nCodCia, cTipoComprob, nIdTransaccion, cTipoDiario, cCodMonedaCia);
            --
            --Opt:07082019
            UPDATE COMPROBANTES_CONTABLES
               SET FecComprob = TRUNC(dFechaTransaccion),
                   FecSts     = TRUNC(dFechaTransaccion)
             WHERE CodCia     = nCodCia
               AND NumComprob = nNumComprob;
         END IF;
         -- Descripcin del Movimiento Contable
         cDescProceso    := OC_PROC_TAREA.NOMBRE_PROCESO(nIdProceso);
         cDescSubProceso := OC_SUB_PROCESO.NOMBRE_SUBPROCESO(nIdProceso, Z.CodSubProceso);
         cDescMovGeneral := 'Contabilizacion de ' || cDescProceso || ' para SubProceso ' || cDescSubProceso ||
                            ' de la Transaccion No. ' || TRIM(TO_CHAR(nIdTransaccion)) || ' del ' ||
                            TO_CHAR(dFechaTransaccion,'DD/MM/YYYY');
--        cCodMonedaCia := 'USD';
        FOR W IN MOV_CONTABLE_Q  (nCodCia, nCodEmpresa, nIdTransaccion, cCodMonedaCia)LOOP
            nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(W.CodMoneda, TRUNC(dFechaTransaccion));
            nCodEmpresa := W.CodEmpresa;
            cIdTipoSeg  := W.IdTipoSeg;
            cCodCpto    := W.CodCpto;
            cTipoAgente := W.TipoAgente;
            nIdRegFisSAT:= OC_CAT_REGIMEN_FISCAL.FUN_AGENTE_IDREGFISSAT(nCodCia, nCodEmpresa, W.COD_AGENTE);     -- RESICO
            --
            IF W.CodMoneda IS NOT NULL AND cCodMoneda IS NULL THEN
               cCodMoneda := W.CodMoneda;
            END IF;
            -- Actualiza Facturas por Tipo de Contabilidad Anticipada o Devengada
            IF W.DescripMov = 'FACTURAS CONTABILIZADAS' THEN
               OC_FACTURAS.ACTUALIZA_CONTABILIZACION(nCodCia, nIdTransaccion);
            END IF;
   -----
            BEGIN
               SELECT 'S'
                 INTO cConceptoAdicional
                 FROM CONCEPTOS_ADICIONALES
                WHERE CodConcepto   = W.CodCpto;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  cConceptoAdicional := 'N';
               WHEN TOO_MANY_ROWS THEN
                  cConceptoAdicional := 'S';
               WHEN OTHERS THEN
                  cConceptoAdicional := 'N';
            END;
   -----
            FOR X IN PLANT_Q LOOP
               IF X.NivelCta1 = '5' AND X.NivelCta2 = '3' AND X.NivelCta3 = '09' THEN
                 X.CodUnidadNegocio := W.UEN;
               END IF;
   -----
               IF X.TipoRegistro = 'MO' THEN
                  IF X.TipoAgente IS NULL THEN
                     nMtoMovCuenta := ABS(W.MtoMovCuenta);
                  ELSIF OC_COMPROBANTES_CONTABLES.APLICA_TIPO_AGENTE(nCodCia, nIdTransaccion, cIdTipoSeg, X.TipoAgente) = 'S' THEN
                     nMtoMovCuenta := ABS(W.MtoComisCuenta);                     
                  ELSE
                     nMtoMovCuenta := 0;
                  END IF;
               ELSE
                  IF ABS(W.MtoComisCuenta) != 0 THEN
                     IF cConceptoAdicional = 'S' THEN 
                     --                      X.CodUnidadNegocio := W.UEN; ---- JMMD20200817 SE CAMBIA LA UNIDAD DE NEGOCIO DE LA PLANTILLA POR LA UEN DEL TIPO DE SEGURO
                        IF cCodProceso = 100 THEN
                           IF    W.REG = 26 THEN -- MLJS 05/09/2023 SE AGREGA CONDICION PARA IDENTIFICAR LOS RECIBOS Y NOTAS DE CREDITO
                              nMtoMovCuenta := ABS(OC_COMPROBANTES_CONTABLES.COMISION_TIPO_ADICIONALES(nCodCia, nIdTransaccion, cIdTipoSeg,
                                                                                      X.TipoPersona, X.TipoAgente, W.CodCpto));
                           ELSIF W.REG = 28 THEN  -- MLJS 05/09/2023 SE AGREGA CONDICION PARA IDENTIFICAR LOS RECIBOS Y NOTAS DE CREDITO
                             nMtoMovCuenta := ABS(OC_COMPROBANTES_CONTABLES.COM_TIPO_ADICIONALES_CANC(nCodCia, nIdTransaccion, cIdTipoSeg,
                                                                                           X.TipoPersona, X.TipoAgente, W.CodCpto));
                           END IF;
                        ELSE
                           IF cCodProceso = 200 THEN
                             IF    W.REG = 28 THEN -- MLJS 05/09/2023 SE AGREGA CONDICION PARA IDENTIFICAR LOS RECIBOS Y NOTAS DE CREDITO
                                 nMtoMovCuenta := ABS(OC_COMPROBANTES_CONTABLES.COM_TIPO_ADICIONALES_CANC(nCodCia, nIdTransaccion, cIdTipoSeg,
                                                                                           X.TipoPersona, X.TipoAgente, W.CodCpto));
                              ELSIF W.REG = 26 THEN -- MLJS 05/09/2023 SE AGREGA CONDICION PARA IDENTIFICAR LOS RECIBOS Y NOTAS DE CREDITO
                                nMtoMovCuenta := ABS(OC_COMPROBANTES_CONTABLES.COMISION_TIPO_ADICIONALES(nCodCia, nIdTransaccion, cIdTipoSeg,
                                                                                           X.TipoPersona, X.TipoAgente, W.CodCpto));
                              END IF;
                           ELSE
                             IF cCodProceso IN( 300,310,320,330) THEN
                                nMtoMovCuenta := ABS(OC_COMPROBANTES_CONTABLES.COM_TIPO_ADICIONALES_PAGOS(nCodCia, nIdTransaccion, cIdTipoSeg,
                                                                                             X.TipoPersona, X.TipoAgente, W.CodCpto));
                             ELSE
                                 IF cCodProceso IN( 700,900) THEN
                                   nMtoMovCuenta := W.MtoComisCuenta;
                                 END IF;
                             END IF;
                           END IF;
                        END IF;
                     ELSE             ------- JMMD20191015

                     nMtoMovCuenta := ABS(OC_COMPROBANTES_CONTABLES.COMISION_TIPO_PERSONA(nCodCia, nIdTransaccion, cIdTipoSeg,
                                                                                       X.TipoPersona, X.TipoAgente));
                     END IF;   ---- JMMD20191015
                  ELSE
                     nMtoMovCuenta := 0;
                  END IF;
               END IF;
               IF X.CanalComisVenta IS NOT NULL THEN
                  --
                  IF OC_COMPROBANTES_CONTABLES.APLICA_CANAL_VENTA(nCodCia, nIdTransaccion, cIdTipoSeg, X.CanalComisVenta) = 'N' THEN
                     nMtoMovCuenta := 0;
                  END IF;
                  --
               END IF;
               IF NVL(nMtoMovCuenta,0) != 0 THEN
                  IF W.DescripMov IS NULL OR W.DescripMov = 'FACTURAS CONTABILIZADAS' THEN
                     cDescConcepto := OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(nCodCia, cCodCpto);
                     IF cDescConcepto = 'CONCEPTO NO EXISTE' THEN
                        cDescConcepto := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('RVACONTA', cCodCpto);
                        IF cDescConcepto = 'NO EXISTE' THEN
                           cDescConcepto := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CPTOSINI', cCodCpto);
                        END IF;
                     END IF;
                     cDescMovCuenta := cDescMovGeneral || ' por el Concepto de ' || TRIM(cCodCpto) || '-' ||
                                       TRIM(cDescConcepto) || ' y un Monto de ' ||
                                       TRIM(TO_CHAR(nMtoMovCuenta,'999,999,999,990.00') || ' y Concepto MIZAR ' ||
                                       X.DescCptoGeneral);
                  ELSE
                     cDescMovCuenta := W.DescripMov;
                  END IF;
                  cContabilizo   := 'S';
                  nMtoMovCuentaLocal := nMtoMovCuenta * nTasaCambio;
                  OC_COMPROBANTES_DETALLE.INSERTA_DETALLE(nCodCia, nNumComprob, X.NivelCta1, X.NivelCta2,
                                                          X.NivelCta3, X.NivelCta4, X.NivelCta5,
                                                          X.NivelCta6, X.NivelCta7, X.NivelAux, X.RegDebCred,
                                                          nMtoMovCuenta, cDescMovCuenta, X.CodCentroCosto,
                                                          X.CodUnidadNegocio, X.DescCptoGeneral, nMtoMovCuentaLocal);
               END IF;
            END LOOP;
         END LOOP;

         IF cContabilizo = 'S' THEN
            OC_COMPROBANTES_CONTABLES.ACTUALIZA_MONEDA(nCodCia, nNumComprob, NVL(cCodMoneda,cCodMonedaCia));
            OC_COMPROBANTES_DETALLE.ACTUALIZA_FECHA(nCodCia, nNumComprob, TRUNC(dFechaTransaccion));
            OC_COMPROBANTES_CONTABLES.CUADRA_COMPROBANTE(nCodCia, nNumComprob);
         ELSE
            OC_COMPROBANTES_CONTABLES.ELIMINA_COMPROBANTE(nCodCia, nNumComprob);
         END IF;
      END IF;
   END LOOP;
END CONTABILIZAR;

PROCEDURE RECONTABILIZAR(nCodCia NUMBER, nIdTransaccion NUMBER, cTipoComp VARCHAR2 DEFAULT 'C', nNumComprob NUMBER) IS
nCodEmpresa        TIPOS_DE_SEGUROS.CodEmpresa%TYPE;
cIdTipoSeg         TIPOS_DE_SEGUROS.IdTipoSeg%TYPE;
cCodCpto           CONCEPTOS_PLAN_DE_PAGOS.CodCpto%TYPE;
cTipoComprob       PROCESOS_CONTABLES.TipoComprob%TYPE;
cDescMovCuenta     COMPROBANTES_DETALLE.DescMovCuenta%TYPE := NULL;
cDescMovGeneral    COMPROBANTES_DETALLE.DescMovCuenta%TYPE := NULL;
nMtoMovCuenta      COMPROBANTES_DETALLE.MtoMovCuenta%TYPE;
nMtoMovCuentaLocal COMPROBANTES_DETALLE.MtoMovCuentaLocal%TYPE;
nIdProceso         TRANSACCION.IdProceso%TYPE;
cDescProceso       PROC_TAREA.Descripcion_Proceso%TYPE;
cCodSubProceso     SUB_PROCESO.CodSubProceso%TYPE;
cDescSubProceso    SUB_PROCESO.Descripcion%TYPE;
dFechaTransaccion  TRANSACCION.FechaTransaccion%TYPE;
cCodProceso        SUB_PROCESO.CodProcesoCont%TYPE;
cDescConcepto      VALORES_DE_LISTAS.DescValLst%TYPE;
nNumComprobRecont  COMPROBANTES_CONTABLES.NumComprob%TYPE;
cTipoDiario        COMPROBANTES_CONTABLES.TipoDiario%TYPE;
dFecComprob        COMPROBANTES_CONTABLES.FecComprob%TYPE;
dFecSts            COMPROBANTES_CONTABLES.FecSts%TYPE;
cCodMoneda         COMPROBANTES_CONTABLES.CodMoneda%TYPE := NULL;
cCodMonedaCia      EMPRESAS.Cod_Moneda%TYPE;
nTasaCambio        TASAS_CAMBIO.Tasa_Cambio%TYPE;
cConceptoAdicional VARCHAR2(1);
cTipoAgente        AGENTES.Tipo_Agente%TYPE;     -- RESICO
nIdRegFisSAT       NUMBER;     -- RESICO

CURSOR PLANT_Q IS
-- MLJS 13/07/2023 SE HOMOLOGA DE ACUERDO A PROC CONTABILIZAR
   SELECT NivelCta1, NivelCta2, NivelCta3, NivelCta4, NivelCta5,
             NivelCta6, NivelCta7, NivelAux, RegDebCred, TipoRegistro,
             CodCentroCosto, CodUnidadNegocio, TipoPersona, CanalComisVenta,
             DescCptoGeneral, TipoAgente
        FROM PLANTILLAS_CONTABLES
       WHERE CodCia              = nCodCia
         AND CodProceso          = cCodProceso
         AND CodMoneda           = cCodMoneda
         AND CodCpto             = cCodCpto
         AND IdTipoSeg           = cIdTipoSeg
         AND CodEmpresa          = nCodEmpresa
         AND (OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(CodCia, CODEMPRESA, cIdTipoSeg) = 'S' AND NVL(TipoAgente,'X') = NVL(cTipoAgente,'X')
          OR  OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(CodCia, CODEMPRESA, cIdTipoSeg) = 'N' )
       ORDER BY IdRegPlantilla;


CURSOR SUBPROC_Q IS
   SELECT DISTINCT CodSubProceso
     INTO cCodSubProceso
     FROM DETALLE_TRANSACCION D
    WHERE IdTransaccion = nIdTransaccion;


BEGIN
   cCodMonedaCia   := OC_EMPRESAS.MONEDA_COMPANIA(nCodCia);
   BEGIN
      SELECT FecComprob, FecSts, NVL(CodMoneda, cCodMonedaCia)
        INTO dFecComprob, dFecSts, cCodMoneda
        FROM COMPROBANTES_CONTABLES
       WHERE CodCia     = nCodCia
         AND NumComprob = nNumComprob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         dFecComprob := NULL;
         dFecSts     := NULL;
   END;
   OC_COMPROBANTES_DETALLE.ELIMINA_DETALLE(nCodCia, nNumComprob);
   OC_COMPROBANTES_CONTABLES.ELIMINA_COMPROBANTE(nCodCia, nNumComprob);

   FOR Z IN SUBPROC_Q LOOP
      BEGIN
         SELECT DISTINCT T.IdProceso, T.FechaTransaccion, S.CodProcesoCont, T.CodEmpresa  -- MLJS 13/07/2023 SE AGREGA LA EMPRESA
           INTO nIdProceso, dFechaTransaccion, cCodProceso, nCodEmpresa                   -- MLJS 13/07/2023
           FROM TRANSACCION T, SUB_PROCESO S
          WHERE S.CodSubProceso = Z.CodSubProceso
            AND S.IdProceso     = T.IdProceso
            AND T.IdTransaccion = nIdTransaccion;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR (-20100,'No de Transaccion '||nIdTransaccion||' NO Encuentra el SubProceso '||Z.CodSubProceso);
         WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR (-20100,'No de Transaccion '||nIdTransaccion||' Posee Mas de un Proceso');
      END;

      IF dFecComprob IS NULL THEN
         dFecComprob := dFechaTransaccion;
         dFecSts     := dFechaTransaccion;
      END IF;

      IF OC_SUB_PROCESO.GENERA_CONTABILIDAD(nIdProceso, Z.CodSubProceso) = 'S' THEN
         -- Lee el Tipo de Comprobante a Crear
         IF NVL(nNumComprobRecont,0) = 0 THEN
            cTipoComprob      := OC_PROCESOS_CONTABLES.TIPO_COMPROBANTE(nCodCia, cCodProceso, cTipoComp);
            cTipoDiario       := OC_PROCESOS_CONTABLES.TIPO_DIARIO(nCodCia, cCodProceso);
            nNumComprobRecont := CREA_COMPROBANTE(nCodCia, cTipoComprob, nIdTransaccion, cTipoDiario, cCodMoneda);
            UPDATE COMPROBANTES_CONTABLES
               SET NumComprob = nNumComprob,
                   FecComprob = dFecComprob,
                   CodMoneda  = cCodMoneda,
                   FecSts     = dFecSts
             WHERE NumComprob = nNumComprobRecont;
         END IF;

         -- Descripcin del Movimiento Contable
         cDescProceso    := OC_PROC_TAREA.NOMBRE_PROCESO(nIdProceso);
         cDescSubProceso := OC_SUB_PROCESO.NOMBRE_SUBPROCESO(nIdProceso, Z.CodSubProceso);
         cDescMovGeneral := 'Contabilizacion de ' || cDescProceso || ' para SubProceso ' || cDescSubProceso ||
                            ' de la Transaccion No. ' || TRIM(TO_CHAR(nIdTransaccion)) || ' del ' ||
                            TO_CHAR(dFechaTransaccion,'DD/MM/YYYY');

         FOR W IN MOV_CONTABLE_Q (nCodCia, nCodEmpresa, nIdTransaccion, cCodMonedaCia)  LOOP
            nTasaCambio    := OC_GENERALES.TASA_DE_CAMBIO(W.CodMoneda, TRUNC(dFechaTransaccion));
            nCodEmpresa    := W.CodEmpresa;
            cIdTipoSeg     := W.IdTipoSeg;
            cCodCpto       := W.CodCpto;
            cTipoAgente    := W.TipoAgente;  --MLJS 13/07/2023
            nIdRegFisSAT   := OC_CAT_REGIMEN_FISCAL.FUN_AGENTE_IDREGFISSAT(nCodCia, nCodEmpresa, W.COD_AGENTE);     -- RESICO
            --
            DBMS_OUTPUT.PUT_LINE('cConceptoAdicional -> '||cConceptoAdicional||'  W.CodCpto  '||W.CodCpto|| ' cCodProceso --> '||cCodProceso );            
            IF W.CodMoneda IS NOT NULL AND cCodMoneda IS NULL THEN
               cCodMoneda     := W.CodMoneda;
            END IF;

            -- Actualiza Facturas por Tipo de Contabilidad Anticipada o Devengada
            IF W.DescripMov = 'FACTURAS CONTABILIZADAS' THEN
               OC_FACTURAS.ACTUALIZA_CONTABILIZACION(nCodCia, nIdTransaccion);
            END IF;
-----
            BEGIN
              SELECT 'S'
                INTO cConceptoAdicional
                FROM CONCEPTOS_ADICIONALES
               WHERE CODCONCEPTO   = W.CODCPTO;
            EXCEPTION
             WHEN NO_DATA_FOUND THEN
               cConceptoAdicional := 'N';
             WHEN TOO_MANY_ROWS THEN
               cConceptoAdicional := 'S';
             WHEN OTHERS THEN
               cConceptoAdicional := 'N';
            END;

            DBMS_OUTPUT.PUT_LINE('cConceptoAdicional -> '||cConceptoAdicional|| ' cCodProceso --> '||cCodProceso );
-----
            FOR X IN PLANT_Q LOOP
/*              IF cConceptoAdicional = 'S' THEN
                 X.CodUnidadNegocio := W.UEN; ---- JMMD20200817 SE CAMBIA LA UNIDAD DE NEGOCIO DE LA PLANTILLA POR LA UEN DEL TIPO DE SEGURO
                 DBMS_OUTPUT.PUT_LINE('cConceptoAdicional -> '||cConceptoAdicional|| ' cCodProceso --> '||cCodProceso||' W.CODCPTO -> '||W.CODCPTO||' X.CodUnidadNegocio '||X.CodUnidadNegocio );
              END IF; */
              IF X.NIVELCTA1 = '5' AND X.NIVELCTA2 = '3' AND X.NIVELCTA3 = '09' THEN
                 X.CodUnidadNegocio := W.UEN;
              END IF;
              DBMS_OUTPUT.PUT_LINE('X.TipoRegistro -> '||X.TipoRegistro|| ' cCodProceso --> '||cCodProceso );
               IF X.TipoRegistro = 'MO' THEN
                  IF X.TipoAgente IS NULL THEN
                     nMtoMovCuenta := ABS(W.MtoMovCuenta);
                  ELSIF OC_COMPROBANTES_CONTABLES.APLICA_TIPO_AGENTE(nCodCia, nIdTransaccion, cIdTipoSeg, X.TipoAgente) = 'S' THEN
----- jmmd20220531  asi estaba                     nMtoMovCuenta := ABS(W.MtoMovCuenta);
                     nMtoMovCuenta := ABS(W.MtoComisCuenta);
                  ELSE
                     nMtoMovCuenta := 0;
                  END IF;
               ELSE
                  IF ABS(W.MtoComisCuenta) != 0 THEN
--------------------- JMMD20191015 IVAHON
                      IF cConceptoAdicional = 'S' THEN
                         IF cCodProceso = 100 THEN
                            IF    W.REG = 26 THEN  -- MLJS 05/09/2023 SE AGREGA CONDICION PARA IDENTIFICAR LOS RECIBOS Y NOTAS DE CREDITO
                                nMtoMovCuenta := ABS(OC_COMPROBANTES_CONTABLES.COMISION_TIPO_ADICIONALES(nCodCia, nIdTransaccion, cIdTipoSeg,
                                                                                                  X.TipoPersona, X.TipoAgente, W.CodCpto));
                            ELSIF W.REG = 28 THEN  -- MLJS 05/09/2023 SE AGREGA CONDICION PARA IDENTIFICAR LOS RECIBOS Y NOTAS DE CREDITO
                                nMtoMovCuenta := ABS(OC_COMPROBANTES_CONTABLES.COM_TIPO_ADICIONALES_CANC(nCodCia, nIdTransaccion, cIdTipoSeg,
                                                                                           X.TipoPersona, X.TipoAgente, W.CodCpto));
                            END IF;
                         ELSE
                           IF cCodProceso = 200 THEN
                              IF    W.REG = 28 THEN -- MLJS 05/09/2023 SE AGREGA CONDICION PARA IDENTIFICAR LOS RECIBOS Y NOTAS DE CREDITO
                                 nMtoMovCuenta := ABS(OC_COMPROBANTES_CONTABLES.COM_TIPO_ADICIONALES_CANC(nCodCia, nIdTransaccion, cIdTipoSeg,
                                                                                           X.TipoPersona, X.TipoAgente, W.CodCpto));
                              ELSIF W.REG = 26 THEN -- MLJS 05/09/2023 SE AGREGA CONDICION PARA IDENTIFICAR LOS RECIBOS Y NOTAS DE CREDITO
                                 nMtoMovCuenta := ABS(OC_COMPROBANTES_CONTABLES.COMISION_TIPO_ADICIONALES(nCodCia, nIdTransaccion, cIdTipoSeg,
                                                                                                  X.TipoPersona, X.TipoAgente, W.CodCpto));
                              END IF;
                           ELSE
                             IF cCodProceso IN( 300,310,320,330) THEN
                                DBMS_OUTPUT.PUT_LINE('cCodProceso 300,310,320,330 -> '||cCodProceso||' W.UEN --> '||W.UEN );
                                nMtoMovCuenta := ABS(OC_COMPROBANTES_CONTABLES.COM_TIPO_ADICIONALES_PAGOS(nCodCia, nIdTransaccion, cIdTipoSeg,
                                                                                             X.TipoPersona, X.TipoAgente, W.CodCpto));
                             ELSE
                              IF cCodProceso IN( 700,900) THEN
                                DBMS_OUTPUT.PUT_LINE('cCodProceso 700,900 -> '||cCodProceso||' W.UEN --> '||W.UEN );
                                nMtoMovCuenta := W.MtoComisCuenta;
                              END IF;
                             END IF;
                           END IF;
                         END IF;
                      ELSE             ------- JMMD20191015
                        nMtoMovCuenta := ABS(OC_COMPROBANTES_CONTABLES.COMISION_TIPO_PERSONA(nCodCia, nIdTransaccion, cIdTipoSeg,
                                                                                          X.TipoPersona, X.TipoAgente));
                      END IF;
                  ELSE
                     nMtoMovCuenta := 0;
                  END IF;
               END IF;
               IF X.CanalComisVenta IS NOT NULL THEN
                  IF OC_COMPROBANTES_CONTABLES.APLICA_CANAL_VENTA(nCodCia, nIdTransaccion, cIdTipoSeg, X.CanalComisVenta) = 'N' THEN
                     nMtoMovCuenta := 0;
                  END IF;
               END IF;
               --
               IF NVL(nMtoMovCuenta,0) != 0 THEN
                  IF W.DescripMov IS NULL OR W.DescripMov = 'FACTURAS CONTABILIZADAS' THEN
                     cDescConcepto := OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(nCodCia, cCodCpto);
                     IF cDescConcepto = 'CONCEPTO NO EXISTE' THEN
                        cDescConcepto    := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('RVACONTA', cCodCpto);
                        IF cDescConcepto = 'NO EXISTE' THEN
                           cDescConcepto := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CPTOSINI', cCodCpto);
                        END IF;
                     END IF;
                     cDescMovCuenta := cDescMovGeneral || ' por el Concepto de ' || TRIM(cCodCpto) || '-' ||
                                       TRIM(cDescConcepto) || ' y un Monto de ' ||
                                       TRIM(TO_CHAR(nMtoMovCuenta,'999,999,999,990.00') || ' y Concepto MIZAR ' ||
                                       X.DescCptoGeneral);
                  ELSE
                     cDescMovCuenta := W.DescripMov;
                  END IF;
                  nMtoMovCuentaLocal := nMtoMovCuenta * nTasaCambio;

                  OC_COMPROBANTES_DETALLE.INSERTA_DETALLE(nCodCia, nNumComprob, X.NivelCta1, X.NivelCta2,
                                                          X.NivelCta3, X.NivelCta4, X.NivelCta5,
                                                          X.NivelCta6, X.NivelCta7, X.NivelAux, X.RegDebCred,
                                                          nMtoMovCuenta, cDescMovCuenta, X.CodCentroCosto,
                                                          X.CodUnidadNegocio, X.DescCptoGeneral, nMtoMovCuentaLocal);

               END IF;
            END LOOP;
         END LOOP;
         OC_COMPROBANTES_CONTABLES.ACTUALIZA_MONEDA(nCodCia, nNumComprob, NVL(cCodMoneda,cCodMonedaCia));
         OC_COMPROBANTES_DETALLE.ACTUALIZA_FECHA(nCodCia, nNumComprob, dFecComprob);
         OC_COMPROBANTES_CONTABLES.CUADRA_COMPROBANTE(nCodCia, nNumComprob);
      END IF;
   END LOOP;
END RECONTABILIZAR;

PROCEDURE TRASLADO(nCodCia NUMBER, dFecDesde DATE, dFecHasta DATE,  nNumComprobSC NUMBER,
                   dFecRegistro DATE, cCodUser VARCHAR2, cConcepto VARCHAR2, nDiario NUMBER,
                   cTipoComprob VARCHAR2, cTipoDiario VARCHAR2, cCodMoneda VARCHAR2,
                   cTipoTraslado VARCHAR2, nLinea IN OUT NUMBER) IS

cIdCtaContable     CATALOGO_CONTABLE.IdCtaContable%TYPE;
cCuenta            VARCHAR2(40);
cConceptoCta       VARCHAR2(1000);
cCadena            VARCHAR2(4000);
cSeparador         VARCHAR2(1) := '|';
cCodMonedaCia      EMPRESAS.Cod_Moneda%TYPE;
cCodMonedaMizar    VARCHAR2(1);
nTipoCambio        NUMBER(8,4);
nNumAsiento        NUMBER(10) := 0;

CURSOR COMP_Q IS
   SELECT NumComprob, CodMoneda
     FROM COMPROBANTES_CONTABLES
    WHERE CodCia             = nCodCia
      AND TipoComprob        = cTipoComprob
      AND ((TipoDiario       = cTipoDiario AND cTipoDiario IS NOT NULL)
       OR cTipoDiario IS NULL)
      AND StsComprob         = 'CUA'
      AND TRUNC(FecComprob) >= dFecDesde
      AND TRUNC(FecComprob) <= dFecHasta
      AND CodMoneda          = cCodMoneda
      AND NumComprobSC      IS NULL;

CURSOR DET_Q IS
   SELECT CD.NivelCta1, CD.NivelCta2, CD.NivelCta3, CD.NivelCta4,
          CD.NivelCta5, CD.NivelCta6, CD.NivelCta7, CD.NivelAux, CD.MovDebCred,
          CD.CodCentroCosto, CD.CodUnidadNegocio, CD.DescCptoGeneral, CC.CodMoneda,
          SUM(DECODE(CD.MovDebCred,'D',CD.MtoMovCuenta, 0)) TotDebitos,
          SUM(DECODE(CD.MovDebCred,'C',CD.MtoMovCuenta, 0)) TotCreditos,
          SUM(DECODE(CD.MovDebCred,'D',CD.MtoMovCuentaLocal, 0)) TotDebitosLocal,
          SUM(DECODE(CD.MovDebCred,'C',CD.MtoMovCuentaLocal, 0)) TotCreditosLocal
     FROM COMPROBANTES_DETALLE CD, COMPROBANTES_CONTABLES CC
    WHERE CD.CodCia             = CC.CodCia
      AND CD.NumComprob         = CC.NumComprob
      AND CC.CodCia             = nCodCia
      AND CC.TipoComprob        = cTipoComprob
      AND ((CC.TipoDiario       = cTipoDiario AND cTipoDiario IS NOT NULL)
       OR cTipoDiario IS NULL)
      AND CC.StsComprob         = 'CUA'
      AND TRUNC(CC.FecComprob) >= dFecDesde
      AND TRUNC(CC.FecComprob) <= dFecHasta
      AND CodMoneda             = cCodMoneda
      AND CC.NumComprobSC      IS NULL
    GROUP BY CD.NivelCta1, CD.NivelCta2, CD.NivelCta3, CD.NivelCta4,
          CD.NivelCta5, CD.NivelCta6, CD.NivelCta7, CD.NivelAux, CD.MovDebCred,
          CD.CodCentroCosto, CD.CodUnidadNegocio, CD.DescCptoGeneral, CC.CodMoneda;
BEGIN
   cCodMonedaCia   := OC_EMPRESAS.MONEDA_COMPANIA(nCodCia);
   nTipoCambio     := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, dFecHasta);
   FOR X IN DET_Q LOOP
      nNumAsiento    := NVL(nNumAsiento,0) + 1;
      cIdCtaContable := LPAD(TRIM(TO_CHAR(nCodCia)),14,'0') || X.NivelCta1 || X.NivelCta2 ||
                        X.NivelCta3 || X.NivelCta4 || X.NivelCta5 || X.NivelCta6 || X.NivelCta7 ||
                        X.NivelAux;

      cCuenta         := OC_CATALOGO_CONTABLE.FORMATO_CUENTA(cIdCtaContable);

      cCodMonedaMizar := OC_MONEDA.CODIGO_SISTEMA_CONTABLE(X.CodMoneda);

      cCadena := '5'                                       || CHR(9) ||   -- Compania MIZAR
                 SUBSTR(cTipoDiario,1,4)                   || CHR(9) ||   -- Tipo Tran
                 TRIM(TO_CHAR(nDiario,'0'))                || CHR(9) ||   -- Poliza
                 TRIM(TO_CHAR(nNumAsiento))                || CHR(9) ||   -- No. de Asiento
                 RPAD(NVL(cConcepto,' '),100,' ')          || CHR(9) ||   -- Concepto de Poliza
                 TO_CHAR(dFecRegistro,'DD/MM/YYYY')        || CHR(9) ||   -- Fecha
                 RPAD(cCuenta,60,' ')                      || CHR(9) ||   -- Cuenta Contable
                 RPAD(NVL(X.CodCentroCosto,' '),40,' ')    || CHR(9) ||   -- Centro de Costo
                 RPAD(NVL(X.CodUnidadNegocio,' '),40,' ')  || CHR(9) ||   -- UEN
                 LPAD(X.NivelAux,6,'0')                    || CHR(9) ||   -- Auxiliar
                 '*'                                       || CHR(9) ||   -- Proyecto
                 'ME'                                      || CHR(9) ||   -- Libro
                 cCodMonedaMizar                           || CHR(9);     -- Moneda

      IF X.MovDebCred = 'D'  THEN
         cCadena := cCadena || TO_CHAR(X.TotDebitos,'0000000000.00')   || CHR(9) ||
                    TO_CHAR(X.TotDebitosLocal,'0000000000.00')         || CHR(9) ||
                    '1'                                                || CHR(9); -- Cargos
      ELSE
         cCadena := cCadena || TO_CHAR(X.TotCreditos,'0000000000.00') || CHR(9) ||
                    TO_CHAR(X.TotCreditosLocal,'0000000000.00')       || CHR(9) ||
                    '0'                                               || CHR(9); -- Creditos
      END IF;

      cCadena := cCadena || '0'                           || CHR(9) || -- Unidades
                 TO_CHAR(nTipoCambio,'000.0000')          || CHR(9) || -- Tipo de Cambio
                 RPAD(NVL(X.DescCptoGeneral,' '),64,' ')  || CHR(9) || -- Concepto Individual
                 RPAD('_',12,' ')                         || CHR(9) || -- Cheque
                 RPAD('_',12,' ')                         || CHR(9);   -- Referencia
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      nLinea  := NVL(nLinea,0) + 1;
   END LOOP;
   IF cTipoTraslado = 'SCD' THEN -- Solo para Traslado Definitivo
      FOR X IN COMP_Q LOOP
         UPDATE COMPROBANTES_CONTABLES
            SET NumComprobSC = nNumComprobSC,
                FecEnvioSC   = dFecRegistro
          WHERE CodCia       = nCodCia
            AND NumComprob   = X.NumComprob;
      END LOOP;
   END IF;
END TRASLADO;

PROCEDURE ELIMINA_COMPROBANTE(nCodCia NUMBER, nNumComprob NUMBER) IS
BEGIN

    DELETE COMPROBANTES_CONTABLES
     WHERE CodCia     = nCodCia
       AND NumComprob = nNumComprob;

END ELIMINA_COMPROBANTE;

PROCEDURE TRASLADO_SUN(nCodCia NUMBER, dFecDesde DATE, dFecHasta DATE, nNumComprobSun NUMBER,
                       dFecRegistro DATE, cCodUser VARCHAR2, cTipoComprob VARCHAR2,
                       cEncabezado VARCHAR2, nLinea  IN OUT NUMBER) IS
cCuenta        VARCHAR2(16);
cCadena        VARCHAR2(4000);
cSeparador     VARCHAR2(1) := '|';
cPeriodo       VARCHAR2(8) := TRIM(TO_CHAR(dFecRegistro,'YYYY')) || '/' || TRIM(LPAD(TO_CHAR(dFecRegistro,'MM'),3,'0'));
cCentroCostos  VARCHAR2(5);
cRamo          VARCHAR2(3);

CURSOR COMP_Q IS
   SELECT NumComprob
     FROM COMPROBANTES_CONTABLES
    WHERE CodCia             = nCodCia
      AND TipoComprob        = cTipoComprob
      AND StsComprob         = 'CUA'
      AND TRUNC(FecComprob) >= dFecDesde
      AND TRUNC(FecComprob) <= dFecHasta
      AND NumComprobSun     IS NULL;

CURSOR DET_Q IS
   SELECT 'MXP' Moneda, P.TipoDiario, SUBSTR(P.NomProceso,1,30) Referencia,
          SUBSTR(S.Descripcion,1,50) Descripcion,
          CD.NivelCta1, CD.NivelCta2, CD.NivelCta3, CD.NivelCta4,
          CD.NivelCta5, CD.MovDebCred, TRUNC(CD.FecDetalle) FecDetalle,
          SUM(DECODE(CD.MovDebCred,'D', CD.MtoMovCuenta, -CD.MtoMovCuenta)) TotImporte
     FROM COMPROBANTES_DETALLE CD, DETALLE_TRANSACCION D, TRANSACCION T,
          COMPROBANTES_CONTABLES C,  PROCESOS_CONTABLES P, SUB_PROCESO S
    WHERE P.CodCia             = C.CodCia
      AND S.CodProcesoCont     = P.CodProceso
      AND S.IndGenContabilidad = 'S'
      AND S.CodSubProceso      = D.CodSubProceso
      AND S.IdProceso          = T.IdProceso
      AND T.IdTransaccion      = C.NumTransaccion
      AND T.CodCia             = C.CodCia
      AND D.IdTransaccion      = T.IdTransaccion
      AND CD.CodCia            = C.CodCia
      AND CD.NumComprob        = C.NumComprob
      AND C.CodCia             = nCodCia
      AND C.TipoComprob        = cTipoComprob
      AND C.StsComprob         = 'CUA'
      AND TRUNC(C.FecComprob) >= dFecDesde
      AND TRUNC(C.FecComprob) <= dFecHasta
      AND C.NumComprobSun     IS NULL
    GROUP BY 'MXP', P.TipoDiario, SUBSTR(P.NomProceso,1,30),
             SUBSTR(S.Descripcion,1,50), CD.NivelCta1, CD.NivelCta2,
             CD.NivelCta3, CD.NivelCta4, CD.NivelCta5, CD.MovDebCred, TRUNC(CD.FecDetalle);
BEGIN
   IF cEncabezado = 'S' THEN
      -- Escribe Encabezado de Archivo Excel
      nLinea   := 1;
      cCadena  := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                       ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                       ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                       ' <style id="libro">'||chr(10)||
                       '   <!--table'||chr(10)||
                       '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                       '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                       '        .texto'||chr(10)||
                       '          {mso-number-format:"\@";}'||chr(10)||
                       '        .numero'||chr(10)||
                       '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                       '        .fecha'||chr(10)||
                       '          {mso-number-format:"dd\\-mm\\-yyyy";}'||chr(10)||
                       '    -->'||chr(10)||
                       ' </style><div id="libro">'||chr(10);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      nLinea   := 2;
      cCadena := '<table border = 1><tr><th>ALC</th><th>A</th></tr>';
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      nLinea   := 3;
      cCadena := '<tr><th>1</th><th>2</th><th>3</th><th>4</th><th>5</th><th>6</th><th>7</th><th>'||
                 '8</th><th>8</th><th>10</th><th>11</th><th>12</th><th>13</th><th>14</th><th>15</th>'||
                 '<th>16</th><th>17</th><th>18</th><th>19</th><th>20</th><th>21</th><th>22</th><th>23</th><th>24</th>'||
                 '<th>25</th></tr>';
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      nLinea   := 4;
      cCadena := '<table border = 1><tr><th>Cuenta</th><th>Periodo</th><th>Importe</th>'||
                 '<th>Moneda</th><th>Ope</th><th>Fecha</th><th>Tipo de Diario</th><th>'||
                 'Referencia</th><th>Descripcin</th><th>Vencimiento</th><th>Activo</th>'||
                 '<th>Sub</th><th>Marcador</th><th>Asignacin</th><th>T1 CCO</th>'||
                 '<th>T2 EDO</th><th>T3 AGE</th><th>T4 RAMO</th><th>T5 REF</th>'||
                 '<th>T6 RFC</th><th>T7 IMP</th><th>T8 PYR</th><th>T9</th><th>T10</th>'||
                 '<th>LAYOUT</th></tr>';
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END IF;
   FOR X IN DET_Q LOOP
      nLinea  := NVL(nLinea,0) + 1;
      cCuenta := X.NivelCta1 || X.NivelCta2 || X.NivelCta3 || X.NivelCta4 || X.NivelCta5;
      IF X.NivelCta1 IN (5, 6) THEN
         cCentroCostos := '300';
         cRamo         := '333';
       ELSE
         cCentroCostos := ' ';
         cRamo         := X.NivelCta5;
      END IF;
      cCadena := '<tr>' ||OC_ARCHIVO.CAMPO_HTML(cCuenta,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(cPeriodo,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.TotImporte,'999,999,999,999,990.00'),'N') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Moneda,'C') ||
                 OC_ARCHIVO.CAMPO_HTML('AOM','C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.FecDetalle,'D') ||
                 OC_ARCHIVO.CAMPO_HTML(X.TipoDiario,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Referencia,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Descripcion,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(' ','C') ||
                 OC_ARCHIVO.CAMPO_HTML(' ','C') ||
                 OC_ARCHIVO.CAMPO_HTML(' ','C') ||
                 OC_ARCHIVO.CAMPO_HTML(' ','C') ||
                 OC_ARCHIVO.CAMPO_HTML(' ','C') ||
                 OC_ARCHIVO.CAMPO_HTML(cCentroCostos,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(' ','C') ||
                 OC_ARCHIVO.CAMPO_HTML(' ','C') ||
                 OC_ARCHIVO.CAMPO_HTML(cRamo,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TRIM(TO_CHAR(nNumComprobSun,'000000')),'C') ||
                 OC_ARCHIVO.CAMPO_HTML(' ','C') ||
                 OC_ARCHIVO.CAMPO_HTML(' ','C') ||
                 OC_ARCHIVO.CAMPO_HTML(' ','C') ||
                 OC_ARCHIVO.CAMPO_HTML(' ','C') ||
                 OC_ARCHIVO.CAMPO_HTML(' ','C') ||
                 OC_ARCHIVO.CAMPO_HTML('1;2','C') || '</tr>';
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END LOOP;
   FOR X IN COMP_Q LOOP
      UPDATE COMPROBANTES_CONTABLES
         SET NumComprobSun = nNumComprobSun,
             FecEnvioSun   = dFecRegistro
       WHERE CodCia      = nCodCia
         AND NumComprob  = X.NumComprob;
   END LOOP;
END TRASLADO_SUN;

PROCEDURE RECONTABILIZAR_MASIVO (cTipoComprob VARCHAR2,dFecIni DATE, dFecFin DATE) IS

CURSOR C_COMPRO IS
  SELECT NumComprob, TipoComprob, FecSts, CodCia, NumTransaccion
    FROM COMPROBANTES_CONTABLES
   WHERE TipoComprob   = cTipoComprob
     AND TRUNC(FecSts) BETWEEN dFecIni AND dFecFin
     AND NumComprobSC  IS NULL
   ORDER BY TipoComprob;
BEGIN
   FOR I IN  C_COMPRO LOOP
      UPDATE COMPROBANTES_CONTABLES
         SET StsComprob = 'DES'
       WHERE NumComprob = I.NumComprob;

       OC_COMPROBANTES_DETALLE.ELIMINA_DETALLE(I.CodCia, I.NumComprob);
       OC_COMPROBANTES_CONTABLES.ELIMINA_COMPROBANTE(I.CodCia, I.NumComprob);
       OC_COMPROBANTES_CONTABLES.RECONTABILIZAR(I.CodCia, I.NumTransaccion, 'C', I.NumComprob);
       OC_COMPROBANTES_CONTABLES.CUADRA_COMPROBANTE(I.CodCia, I.NumComprob);

       UPDATE COMPROBANTES_CONTABLES
          SET FecSts       = I.FecSts,
              FecComprob   = I.FecSts
        WHERE NumComprob   = I.NumComprob;
   END LOOP;
END RECONTABILIZAR_MASIVO;

FUNCTION COMISION_TIPO_PERSONA( nCodCia         TRANSACCION.CODCIA%TYPE
                              , nIdTransaccion  TRANSACCION.IDTRANSACCION%TYPE
                              , cIdTipoSeg      DETALLE_POLIZA.IDTIPOSEG%TYPE
                              , cTipoPersona    PERSONA_NATURAL_JURIDICA.TIPO_PERSONA%TYPE
                              , cTipoAgente     AGENTES.TIPO_AGENTE%TYPE ) RETURN NUMBER IS
   nComision_Moneda  COMISIONES.Comision_Moneda%TYPE;
   --
   --Opt:07082019  Optimizacion
   --Se agregan estas variables para recuperar sus valores y poder accesar a las tablas por la llave principal o indices que continen
   --Se ordenan las columnas para acceder a las tablas por la llave primaria en el orden correcto de las mismas
   --
   nCodEmpresa TRANSACCION.CODEMPRESA%TYPE;
   nIdPoliza   DETALLE_TRANSACCION.VALOR1%TYPE;
   nIDetPol    DETALLE_TRANSACCION.VALOR2%TYPE;
   --
BEGIN
   SELECT A.CODEMPRESA
   INTO   nCodEmpresa
   FROM   TRANSACCION A
   WHERE  A.IdTransaccion = nIdTransaccion
     AND  A.CodCia        = nCodCia;
   --
   --Opt:07082019
   SELECT NVL(SUM(Comision_Moneda),0)
     INTO nComision_Moneda
     FROM COMISIONES                 C
        , FACTURAS                   F
        , DETALLE_TRANSACCION        D
        , TRANSACCION                T
        , DETALLE_POLIZA            DP
        , AGENTES                    A
        , PERSONA_NATURAL_JURIDICA PNJ
    WHERE PNJ.Tipo_Persona            = cTipoPersona
      AND PNJ.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
      AND PNJ.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
      AND A.CodTipo                   = cTipoAgente
      AND A.Cod_Agente                = C.Cod_Agente
      AND A.CodCia                    = C.CodCia
      AND C.IdFactura                 = F.IdFactura
      AND DP.IdTipoSeg                = cIdTipoSeg
      AND DP.IdPoliza                 = F.IdPoliza
      AND DP.IDetPol                  = NVL(F.IDetPol, DP.IDetPol)
      AND DP.CodCia                   = D.CodCia
      AND ( F.IdTransaccion = D.IdTransaccion
            OR
            ( F.IdTransaccionAnu = D.IdTransaccion
              OR
              F.IdTransacContab  = D.IdTransaccion
              AND
              F.IndContabilizada = 'S' ) )
      AND T.IdTransaccion             = D.IdTransaccion
      AND ( ( TRUNC(F.FecVenc) <= TRUNC(T.FechaTransaccion)
              AND
              OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, D.CodEmpresa, DP.IdTipoSeg) = 'DEVENG' )
            OR
            OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, D.CodEmpresa, DP.IdTipoSeg) = 'ANTICI' )
      AND D.Correlativo               = 1
      AND D.IdTransaccion             = nIdTransaccion
      AND D.CodEmpresa                = nCodEmpresa
      AND D.CodCia                    = nCodCia;

   --
   --Opt:07082019
   SELECT NVL(nComision_Moneda,0) + NVL(SUM(C.Comision_Moneda),0)
     INTO nComision_Moneda
     FROM COMISIONES                 C
        , NOTAS_DE_CREDITO           N
        , DETALLE_TRANSACCION        D
        , DETALLE_POLIZA            DP
        , AGENTES                    A
        , PERSONA_NATURAL_JURIDICA PNJ
    WHERE PNJ.Tipo_Persona            = cTipoPersona
      AND PNJ.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
      AND PNJ.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
      AND A.CodTipo                   = cTipoAgente
      AND A.Cod_Agente                = C.Cod_Agente
      AND A.CodCia                    = C.CodCia
      AND C.IdNcr                     = N.IdNcr
      AND DP.IdTipoSeg                = cIdTipoSeg
      AND DP.IdPoliza                 = N.IdPoliza
      AND DP.IDetPol                  = NVL(N.IDetPol, DP.IDetPol)
      AND DP.CodCia                   = D.CodCia
      AND ( N.IdTransaccion     = D.IdTransaccion
            OR
            N.IdTransaccionAnu  = D.IdTransaccion
            OR
            N.IdTransacAplic    = D.IdTransaccion
            OR
            N.IdTransacRevAplic = D.IdTransaccion )
      AND D.IdTransaccion             = nIdTransaccion
      AND D.CodCia                    = nCodCia
      AND D.CodEmpresa                = nCodEmpresa
      AND D.Correlativo               = 1;

   --
   --Opt:07082019
   SELECT NVL(nComision_Moneda,0) + NVL(SUM(N.MtoComisi_Moneda),0)
     INTO nComision_Moneda
     FROM NOTAS_DE_CREDITO           N
        , DETALLE_TRANSACCION        D
        , AGENTES                    A
        , PERSONA_NATURAL_JURIDICA PNJ
    WHERE PNJ.Tipo_Persona            = cTipoPersona
      AND PNJ.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
      AND PNJ.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
      AND A.CodTipo                   = cTipoAgente
      AND A.Cod_Agente                = N.Cod_Agente
      AND A.CodCia                    = D.CodCia
      AND N.IdTransaccion             = D.IdTransaccion
      AND N.IdPoliza                 IS NULL
      AND D.IdTransaccion             = nIdTransaccion
      AND D.CodCia                    = nCodCia
      AND D.CodEmpresa                = nCodEmpresa
      AND D.Correlativo               = 1;

   --
   --Opt:07082019
   SELECT NVL(nComision_Moneda,0) + NVL(SUM(Comision_Moneda),0)
     INTO nComision_Moneda
     FROM COMISIONES                 C
        , FACTURAS                   F
        , PAGOS                      P
        , DETALLE_TRANSACCION        D
        , DETALLE_POLIZA            DP
        , AGENTES                    A
        , PERSONA_NATURAL_JURIDICA PNJ
    WHERE PNJ.Tipo_Persona            = cTipoPersona
      AND PNJ.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
      AND PNJ.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
      AND A.CodTipo                   = cTipoAgente
      AND A.Cod_Agente                = C.Cod_Agente
      AND A.CodCia                    = C.CodCia
      AND C.IdFactura                 = F.IdFactura
      AND DP.IdTipoSeg                = cIdTipoSeg
      AND DP.IdPoliza                 = F.IdPoliza
      AND DP.IDetPol                  = NVL(F.IDetPol, DP.IDetPol)
      AND DP.CodCia                   = D.CodCia
      AND F.IdFactura                 = P.IdFactura
      AND ( P.IdTransaccion    = D.IdTransaccion
            OR
            P.IdTransaccionAnu = D.IdTransaccion )
      AND D.IdTransaccion             = nIdTransaccion
      AND D.CodCia                    = nCodCia
      AND D.CodEmpresa                = nCodEmpresa
      AND D.Correlativo               = 1;

   --
   --Opt:07082019
   BEGIN
      SELECT Valor1, Valor2
      INTO   nIdPoliza, nIDetPol
      FROM   DETALLE_TRANSACCION
      WHERE  IdTransaccion = nIdTransaccion
        AND  CodCia        = nCodCia
        AND  CodEmpresa    = nCodEmpresa
        AND  Correlativo   = 1;
   EXCEPTION
   WHEN OTHERS THEN
        nIdPoliza  := NULL;
        nIDetPol   := NULL;
   END;

   SELECT NVL(nComision_Moneda,0) + NVL(SUM(Comision_Moneda),0)
     INTO nComision_Moneda
     FROM COMISIONES                 C
        , AGENTES                    A
        , DETALLE_TRANSACCION        D
        , PERSONA_NATURAL_JURIDICA PNJ
        , FAI_CONCENTRADORA_FONDO   CF
        , FACTURAS                   F
        , DETALLE_POLIZA            DP
    WHERE PNJ.Tipo_Persona            = cTipoPersona
      AND PNJ.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
      AND PNJ.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
      AND A.CodTipo                   = cTipoAgente
      AND A.Cod_Agente                = C.Cod_Agente
      AND A.CodCia                    = C.CodCia
      AND C.IdFactura                 = F.IdFactura
      AND DP.IdPoliza                 = CF.IdPoliza
      AND DP.IDetPol                  = CF.IDetPol
      AND DP.CodCia                   = CF.CodCia
      AND DP.Cod_Asegurado            = CF.CodAsegurado
      AND DP.CodEmpresa               = CF.CodEmpresa
      AND CF.IdFondo                  > 0
      AND CF.CodAsegurado             > 0
      AND CF.IDetPol                  > 0
      AND CF.IdPoliza                 > 0
      AND CF.IdFactura                = F.IdFactura
      AND (CF.IdTransaccion           = D.IdTransaccion
       OR CF.IdTransaccionAnu         = D.IdTransaccion)
      AND CF.CodEmpresa               = D.CodEmpresa
      AND CF.CodCia                   = D.CodCia
      AND GT_FAI_MOVIMIENTOS_FONDOS.INDICADORES(CF.CodCia, CF.CodEmpresa,
                                                GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO(CF.IdFondo),
                                                CF.CodCptoMov, 'GC') = 'S'
      AND GT_FAI_MOVIMIENTOS_FONDOS.INDICADORES(CF.CodCia, CF.CodEmpresa,
                                                GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO(CF.IdFondo),
                                                CF.CodCptoMov, 'CO') = 'S'
      AND D.IdTransaccion             = nIdTransaccion
      AND D.CodCia                    = nCodCia
      AND D.CodEmpresa                = NVL(nCodEmpresa, D.CODEMPRESA)
      AND D.Correlativo               = 1
      AND DP.IdPoliza                 = NVL(nIdPoliza  , DP.IdPoliza)
      AND DP.IDetPol                  = NVL(nIDetPol   , DP.IDetPol)
      AND DP.CodCia                   = NVL(nCodCia    , DP.CodCia);

   RETURN(nComision_Moneda);
END COMISION_TIPO_PERSONA;
------------------
FUNCTION COMISION_TIPO_ADICIONALES(nCodCia NUMBER, nIdTransaccion NUMBER, cIdTipoSeg VARCHAR2,
                               cTipoPersona VARCHAR2, cTipoAgente VARCHAR2, CCodCpto VARCHAR2) RETURN NUMBER IS
nComision_Moneda      COMISIONES.Comision_Moneda%TYPE;
BEGIN
   SELECT NVL(SUM(DC.MONTO_MON_EXTRANJERA),0)
     INTO nComision_Moneda
     FROM COMISIONES C, FACTURAS F, DETALLE_TRANSACCION D,
          TRANSACCION T, DETALLE_POLIZA DP, AGENTES A,
          PERSONA_NATURAL_JURIDICA PNJ, DETALLE_COMISION DC
    WHERE PNJ.Tipo_Persona            = cTipoPersona
      AND PNJ.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
      AND PNJ.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
      AND A.CodTipo                   = cTipoAgente
      AND A.Cod_Agente                = C.Cod_Agente
      AND A.CodCia                    = C.CodCia
      AND C.IdFactura                 = F.IdFactura
      AND DC.CODCIA                   = C.CODCIA
      AND DC.IDCOMISION               = C.IDCOMISION
      AND DC.CODCONCEPTO              = 'IVAHON'
      AND DP.IdTipoSeg                = cIdTipoSeg
      AND DP.IdPoliza                 = F.IdPoliza
      AND DP.IDetPol                  = NVL(F.IDetPol, DP.IDetPol)
      AND DP.CodCia                   = D.CodCia
      AND (F.IdTransaccion            = D.IdTransaccion
       OR (F.IdTransaccionAnu         = D.IdTransaccion
       OR  F.IdTransacContab          = D.IdTransaccion
      AND  F.IndContabilizada         = 'S'))
      AND T.IdTransaccion             = D.IdTransaccion
      AND ((TRUNC(F.FecVenc)         <= TRUNC(T.FechaTransaccion)
      AND   OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, D.CodEmpresa, DP.IdTipoSeg) = 'DEVENG')
       OR OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, D.CodEmpresa, DP.IdTipoSeg) = 'ANTICI')
      AND D.Correlativo               = 1
      AND D.IdTransaccion             = nIdTransaccion
      AND D.CodCia                    = nCodCia
;


   RETURN(nComision_Moneda);
END COMISION_TIPO_ADICIONALES;
------------------
FUNCTION COM_TIPO_ADICIONALES_CANC(nCodCia NUMBER, nIdTransaccion NUMBER, cIdTipoSeg VARCHAR2,
                               cTipoPersona VARCHAR2, cTipoAgente VARCHAR2, CCodCpto VARCHAR2) RETURN NUMBER IS
nComision_Moneda      COMISIONES.Comision_Moneda%TYPE;
BEGIN
   SELECT NVL(SUM(DC.MONTO_MON_EXTRANJERA),0)
     INTO nComision_Moneda
    FROM  TRANSACCION T --,
           ,DETALLE_TRANSACCION D
           ,NOTAS_DE_CREDITO NC
           , COMISIONES C
           , DETALLE_COMISION DC
           , DETALLE_POLIZA DP
           , AGENTES A
           , PERSONA_NATURAL_JURIDICA PNJ
    WHERE T.IdTransaccion             = nIdTransaccion
      AND D.IdTransaccion             = T.IdTransaccion
      AND D.CodCia                    = nCodCia
      AND D.Correlativo               = 1
      AND (NC.IdTransaccion           = D.IdTransaccion
       OR NC.IdTransaccionAnu         = D.IdTransaccion
       OR  NC.IdTransacaPLIC          = D.IdTransaccion)
      AND C.IdNCR                     = NC.IDNCR
      AND C.IDPOLIZA                  = NC.IDPOLIZA
      AND DC.CODCIA                   = C.CODCIA
      AND DC.IDCOMISION               = C.IDCOMISION
      AND DC.CODCONCEPTO              = 'IVAHON'
      AND DP.IdTipoSeg                = cIdTipoSeg
      AND DP.IdPoliza                 = NC.IdPoliza
      AND DP.IDetPol                  = NVL(NC.IDetPol, DP.IDetPol)
      AND DP.CodCia                   = D.CodCia
      AND A.CodTipo                   = cTipoAgente
      AND A.Cod_Agente                = C.Cod_Agente
      AND A.CodCia                    = C.CodCia
      AND PNJ.Tipo_Persona            = cTipoPersona
      AND PNJ.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
      AND PNJ.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
      AND ((TRUNC(NC.FecdEVOL)         <= TRUNC(T.FechaTransaccion)
      AND   OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(1, D.CodEmpresa, DP.IdTipoSeg) = 'DEVENG')
       OR OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(1, D.CodEmpresa, DP.IdTipoSeg) = 'ANTICI')
;

   DBMS_OUTPUT.PUT_LINE('En com_tipo_adicionales_canc ->  nComision_Moneda --> '||nComision_Moneda );
   RETURN(nComision_Moneda);
END COM_TIPO_ADICIONALES_CANC;
------------------

FUNCTION COM_TIPO_ADICIONALES_PAGOS(nCodCia NUMBER, nIdTransaccion NUMBER, cIdTipoSeg VARCHAR2,
                               cTipoPersona VARCHAR2, cTipoAgente VARCHAR2, CCodCpto VARCHAR2) RETURN NUMBER IS
nComision_Moneda      COMISIONES.Comision_Moneda%TYPE;
BEGIN
      SELECT NVL(SUM(DC.MONTO_MON_EXTRANJERA),0)
     INTO nComision_Moneda
     FROM COMISIONES C,
     FACTURAS F,
     DETALLE_TRANSACCION D,
          TRANSACCION T, DETALLE_POLIZA DP , AGENTES A,
          PAGOS PA ,
          PERSONA_NATURAL_JURIDICA PNJ,
            DETALLE_COMISION DC
    WHERE PNJ.Tipo_Persona            = cTipoPersona
      AND PNJ.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
      AND PNJ.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
      AND A.CodTipo                   = cTipoAgente
      AND A.Cod_Agente                = C.Cod_Agente
      AND A.CodCia                    = C.CodCia
      AND C.IdFactura                 = F.IdFactura
      AND DC.CODCIA                   = C.CODCIA
      AND DC.IDCOMISION               = C.IDCOMISION
      AND DC.CODCONCEPTO              = 'IVAHON'
      AND DP.IdTipoSeg                = cIdTipoSeg
      AND DP.IdPoliza                 = F.IdPoliza
      AND DP.IDetPol                  = NVL(F.IDetPol, DP.IDetPol)
      AND DP.CodCia                   = D.CodCia
      AND (PA.IdTransaccion            = D.IdTransaccion
        OR  PA.IdTransaccionAnu         = D.IdTransaccion)
      AND  F.IDFACTURA                 = PA.IDFACTURA
      AND  T.IdTransaccion             = D.IdTransaccion
      AND ((TRUNC(F.FecVenc)         <= TRUNC(T.FechaTransaccion)
     AND   OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(1, D.CodEmpresa, DP.IdTipoSeg) = 'DEVENG')
       OR OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(1, D.CodEmpresa, DP.IdTipoSeg) = 'ANTICI')
      AND D.Correlativo               = nCodCia
      AND D.IdTransaccion             = nIdTransaccion
      AND D.CodCia                    = nCodCia
;


   RETURN(nComision_Moneda);
END COM_TIPO_ADICIONALES_PAGOS;
------------------

FUNCTION APLICA_CANAL_VENTA(nCodCia NUMBER, nIdTransaccion NUMBER,
                            cIdTipoSeg VARCHAR2, cCanalComisVenta VARCHAR2) RETURN VARCHAR2 IS
cCanalComis     VARCHAR2(1);
--
BEGIN
  --
   BEGIN
      SELECT 'S'
        INTO cCanalComis
        FROM AGENTES_DISTRIBUCION_COMISION AG, FACTURAS F,
             DETALLE_TRANSACCION D, TRANSACCION T, DETALLE_POLIZA DP, AGENTES A
       WHERE A.CanalComisVenta    = cCanalComisVenta
         AND A.Cod_Agente         = AG.Cod_Agente_Distr
         AND A.CodEmpresa         = DP.CodEmpresa
         AND A.CodCia             = AG.CodCia
         AND AG.IDetPol           = DP.IDetPol
         AND AG.IdPoliza          = DP.IdPoliza
         AND AG.CodCia            = DP.CodCia
         AND DP.IdTipoSeg         = cIdTipoSeg
         AND DP.IdPoliza          = F.IdPoliza
         AND DP.IDetPol           = NVL(F.IDetPol, DP.IDetPol)
         AND DP.CodCia            = D.CodCia
         AND T.IdTransaccion      = D.IdTransaccion
         AND ((TRUNC(F.FecVenc)  <= TRUNC(T.FechaTransaccion)
         AND   OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, D.CodEmpresa, DP.IdTipoSeg) = 'DEVENG')
          OR OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, D.CodEmpresa, DP.IdTipoSeg) = 'ANTICI')
         AND F.IdFactura          > 0
         AND (F.IdTransaccion     = D.IdTransaccion
          OR (F.IdTransaccionAnu  = D.IdTransaccion
         AND  F.IndContabilizada  = 'S')
          OR  F.IdTransacContab   = D.IdTransaccion)
         AND D.Correlativo        = 1
         AND D.IdTransaccion      = nIdTransaccion
         AND D.CodCia             = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCanalComis := 'N';
      WHEN TOO_MANY_ROWS THEN
         cCanalComis := 'S';
   END;

   IF cCanalComis = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cCanalComis
           FROM NOTAS_DE_CREDITO N, DETALLE_TRANSACCION D,
                AGENTES_DISTRIBUCION_COMISION AG, DETALLE_POLIZA DP, AGENTES A
          WHERE A.CanalComisVenta   = cCanalComisVenta
            AND A.Cod_Agente        = AG.Cod_Agente_Distr
            AND A.CodCia            = AG.CodCia
            AND AG.IDetPol          = DP.IDetPol
            AND AG.IdPoliza         = DP.IdPoliza
            AND AG.CodCia           = DP.CodCia
            AND DP.IdTipoSeg        = cIdTipoSeg
            AND DP.IdPoliza         = N.IdPoliza
            AND DP.IDetPol          = NVL(N.IDetPol, DP.IDetPol)
            AND DP.CodCia           = D.CodCia
            AND (N.IdTransaccion    = D.IdTransaccion
             OR  N.IdTransaccionAnu = D.IdTransaccion
             OR  N.IdTransacAplic   = D.IdTransaccion
             OR  N.IdTransacRevAplic = D.IdTransaccion)
            AND D.Correlativo       = 1
            AND D.IdTransaccion     = nIdTransaccion
            AND D.CodCia            = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cCanalComis := 'N';
         WHEN TOO_MANY_ROWS THEN
            cCanalComis := 'S';
      END;
   END IF;

   IF cCanalComis = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cCanalComis
           FROM NOTAS_DE_CREDITO N, DETALLE_TRANSACCION D, AGENTES A
          WHERE A.CanalComisVenta   = cCanalComisVenta
            AND A.Cod_Agente        = N.Cod_Agente
            AND A.CodCia            = D.CodCia
            AND (N.IdTransaccion    = D.IdTransaccion
             OR  N.IdTransaccionAnu = D.IdTransaccion
             OR  N.IdTransacAplic   = D.IdTransaccion
             OR  N.IdTransacRevAplic = D.IdTransaccion)
            AND D.Correlativo       = 1
            AND D.IdTransaccion     = nIdTransaccion
            AND D.CodCia            = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cCanalComis := 'N';
         WHEN TOO_MANY_ROWS THEN
            cCanalComis := 'S';
      END;
   END IF;

   IF cCanalComis = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cCanalComis
           FROM AGENTES_DISTRIBUCION_COMISION AG, FACTURAS F, PAGOS P,
                DETALLE_TRANSACCION D, DETALLE_POLIZA DP, AGENTES A
          WHERE A.CanalComisVenta   = cCanalComisVenta
            AND A.Cod_Agente        = AG.Cod_Agente_Distr
            AND A.CodCia            = AG.CodCia
            AND AG.IDetPol          = DP.IDetPol
            AND AG.IdPoliza         = DP.IdPoliza
            AND AG.CodCia           = DP.CodCia
            AND DP.IdTipoSeg        = cIdTipoSeg
            AND DP.IdPoliza         = F.IdPoliza
            AND DP.IDetPol          = NVL(F.IDetPol, DP.IDetPol)
            AND DP.CodCia           = D.CodCia
            AND F.IdFactura         = P.IdFactura
            AND (P.IdTransaccion    = D.IdTransaccion
             OR  P.IdTransaccionAnu = D.IdTransaccion)
            AND D.Correlativo       = 1
            AND D.IdTransaccion     = nIdTransaccion
            AND D.CodCia            = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cCanalComis := 'N';
         WHEN TOO_MANY_ROWS THEN
            cCanalComis := 'S';
      END;
   END IF;

   IF cCanalComis = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cCanalComis
           FROM DETALLE_TRANSACCION DT, AGENTES_DISTRIBUCION_COMISION AG,
                SINIESTRO S, COBERTURA_SINIESTRO_ASEG C, AGENTES A
          WHERE A.CanalComisVenta  = cCanalComisVenta
            AND A.Cod_Agente       = AG.Cod_Agente_Distr
            AND A.CodCia           = AG.CodCia
            AND AG.IDetPol         = S.IDetPol
            AND AG.IdPoliza        = S.IdPoliza
            AND AG.CodCia          = S.CodCia
            AND S.IdSiniestro      = C.IdSiniestro
            AND S.IdPoliza         = C.IdPoliza
            AND S.CodCia           = nCodCia
            AND DT.Correlativo     = 1
            AND (C.IdTransaccion     = DT.IdTransaccion
             OR  C.IdTransaccionAnul = DT.IdTransaccion)
            AND DT.IdTransaccion   = nIdTransaccion;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cCanalComis := 'N';
         WHEN TOO_MANY_ROWS THEN
            cCanalComis := 'S';
      END;
   END IF;

   IF cCanalComis = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cCanalComis
           FROM DETALLE_TRANSACCION DT, AGENTES_DISTRIBUCION_COMISION AG,
                SINIESTRO S, COBERTURA_SINIESTRO C, AGENTES A
          WHERE A.CanalComisVenta  = cCanalComisVenta
            AND A.Cod_Agente       = AG.Cod_Agente_Distr
            AND A.CodCia           = AG.CodCia
            AND AG.IDetPol         = S.IDetPol
            AND AG.IdPoliza        = S.IdPoliza
            AND AG.CodCia          = S.CodCia
            AND S.IdSiniestro      = C.IdSiniestro
            AND S.IdPoliza         = C.IdPoliza
            AND S.CodCia           = nCodCia
            AND DT.Correlativo     = 1
            AND (C.IdTransaccion     = DT.IdTransaccion
             OR  C.IdTransaccionAnul = DT.IdTransaccion)
            AND DT.IdTransaccion   = nIdTransaccion;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cCanalComis := 'N';
         WHEN TOO_MANY_ROWS THEN
            cCanalComis := 'S';
      END;
   END IF;

   IF cCanalComis = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cCanalComis
           FROM DETALLE_TRANSACCION DT, AGENTES_DISTRIBUCION_COMISION AG,
                SINIESTRO S, APROBACIONES C, AGENTES A
          WHERE A.CanalComisVenta  = cCanalComisVenta
            AND A.Cod_Agente       = AG.Cod_Agente_Distr
            AND A.CodCia           = AG.CodCia
            AND AG.IDetPol         = S.IDetPol
            AND AG.IdPoliza        = S.IdPoliza
            AND AG.CodCia          = S.CodCia
            AND S.IdSiniestro      = C.IdSiniestro
            AND S.IdPoliza         = C.IdPoliza
            AND S.CodCia           = nCodCia
            AND DT.Correlativo     = 1
            AND (C.IdTransaccion     = DT.IdTransaccion
             OR  C.IdTransaccionAnul = DT.IdTransaccion)
            AND DT.IdTransaccion   = nIdTransaccion
          UNION
         SELECT 'S'
           FROM DETALLE_TRANSACCION DT, AGENTES_DISTRIBUCION_COMISION AG,
                SINIESTRO S, APROBACION_ASEG C, AGENTES A
          WHERE A.CanalComisVenta  = cCanalComisVenta
            AND A.Cod_Agente       = AG.Cod_Agente_Distr
            AND A.CodCia           = AG.CodCia
            AND AG.IDetPol         = S.IDetPol
            AND AG.IdPoliza        = S.IdPoliza
            AND AG.CodCia          = S.CodCia
            AND S.IdSiniestro      = C.IdSiniestro
            AND S.IdPoliza         = C.IdPoliza
            AND S.CodCia           = nCodCia
            AND DT.Correlativo     = 1
            AND (C.IdTransaccion     = DT.IdTransaccion
             OR  C.IdTransaccionAnul = DT.IdTransaccion)
            AND DT.IdTransaccion   = nIdTransaccion;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cCanalComis := 'N';
         WHEN TOO_MANY_ROWS THEN
            cCanalComis := 'S';
      END;
   END IF;

   IF cCanalComis = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cCanalComis
           FROM AGENTES_DISTRIBUCION_COMISION AG, AGENTES A, DETALLE_TRANSACCION D,
                FAI_CONCENTRADORA_FONDO CF, FACTURAS F, DETALLE_POLIZA  DP
          WHERE A.CanalComisVenta   = cCanalComisVenta
            AND A.Cod_Agente        = AG.Cod_Agente_Distr
            AND A.CodEmpresa        = DP.CodEmpresa
            AND A.CodCia            = AG.CodCia
            AND AG.IDetPol          = DP.IDetPol
            AND AG.IdPoliza         = DP.IdPoliza
            AND AG.CodCia           = DP.CodCia
            AND DP.IdPoliza         = CF.IdPoliza
            AND DP.IDetPol          = CF.IDetPol
            AND DP.CodCia           = CF.CodCia
            AND CF.IdFondo          > 0
            AND CF.CodAsegurado     > 0
            AND CF.IDetPol          > 0
            AND CF.IdPoliza         > 0
            AND CF.IdFactura        = F.IdFactura
            AND (CF.IdTransaccion   = D.IdTransaccion
             OR CF.IdTransaccionAnu = D.IdTransaccion)
            AND CF.CodEmpresa       = D.CodEmpresa
            AND CF.CodCia           = D.CodCia
            AND GT_FAI_MOVIMIENTOS_FONDOS.INDICADORES(CF.CodCia, CF.CodEmpresa,
                                                      GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO(CF.IdFondo),
                                                      CF.CodCptoMov, 'GC') = 'S'
            AND D.Correlativo       = 1
            AND D.IdTransaccion     = nIdTransaccion
            AND D.CodCia            = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cCanalComis := 'N';
         WHEN TOO_MANY_ROWS THEN
            cCanalComis := 'S';
      END;
   END IF;

   RETURN(cCanalComis);
END APLICA_CANAL_VENTA;

FUNCTION APLICA_TIPO_AGENTE(nCodCia NUMBER, nIdTransaccion NUMBER, cIdTipoSeg VARCHAR2,
                            cTipoAgente VARCHAR2) RETURN VARCHAR2 IS
cAplicaTipoAgen     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cAplicaTipoAgen
        FROM AGENTES_DISTRIBUCION_COMISION AG, FACTURAS F,
             DETALLE_TRANSACCION D, TRANSACCION T, DETALLE_POLIZA DP, AGENTES A
       WHERE A.CodTipo            = cTipoAgente
         AND A.Cod_Agente         = AG.Cod_Agente_Distr
         AND A.CodEmpresa         = DP.CodEmpresa
         AND A.CodCia             = AG.CodCia
         AND AG.IDetPol           = DP.IDetPol
         AND AG.IdPoliza          = DP.IdPoliza
         AND AG.CodCia            = DP.CodCia
         AND DP.IdTipoSeg         = cIdTipoSeg
         AND DP.IdPoliza          = F.IdPoliza
         AND DP.IDetPol           = NVL(F.IDetPol, DP.IDetPol)
         AND DP.CodCia            = D.CodCia
         AND T.IdTransaccion      = D.IdTransaccion
         AND ((TRUNC(F.FecVenc)  <= TRUNC(T.FechaTransaccion)
         AND   OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, D.CodEmpresa, DP.IdTipoSeg) = 'DEVENG')
          OR OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, D.CodEmpresa, DP.IdTipoSeg) = 'ANTICI')
         AND F.IdFactura          > 0
         AND (F.IdTransaccion     = D.IdTransaccion
          OR (F.IdTransaccionAnu  = D.IdTransaccion
         AND  F.IndContabilizada  = 'S')
          OR  F.IdTransacContab   = D.IdTransaccion)
         AND D.Correlativo        = 1
         AND D.IdTransaccion      = nIdTransaccion
         AND D.CodCia             = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cAplicaTipoAgen := 'N';
      WHEN TOO_MANY_ROWS THEN
         cAplicaTipoAgen := 'S';
   END;

   IF cAplicaTipoAgen = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cAplicaTipoAgen
           FROM NOTAS_DE_CREDITO N, DETALLE_TRANSACCION D,
                AGENTES_DISTRIBUCION_COMISION AG, DETALLE_POLIZA DP, AGENTES A
          WHERE A.CodTipo           = cTipoAgente
            AND A.Cod_Agente        = AG.Cod_Agente_Distr
            AND A.CodCia            = AG.CodCia
            AND AG.IDetPol          = DP.IDetPol
            AND AG.IdPoliza         = DP.IdPoliza
            AND AG.CodCia           = DP.CodCia
            AND DP.IdTipoSeg        = cIdTipoSeg
            AND DP.IdPoliza         = N.IdPoliza
            AND DP.IDetPol          = NVL(N.IDetPol, DP.IDetPol)
            AND DP.CodCia           = D.CodCia
            AND (N.IdTransaccion    = D.IdTransaccion
             OR  N.IdTransaccionAnu = D.IdTransaccion
             OR  N.IdTransacAplic   = D.IdTransaccion
             OR  N.IdTransacRevAplic = D.IdTransaccion)
            AND D.Correlativo       = 1
            AND D.IdTransaccion     = nIdTransaccion
            AND D.CodCia            = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cAplicaTipoAgen := 'N';
         WHEN TOO_MANY_ROWS THEN
            cAplicaTipoAgen := 'S';
      END;
   END IF;

   IF cAplicaTipoAgen = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cAplicaTipoAgen
           FROM NOTAS_DE_CREDITO N, DETALLE_TRANSACCION D, AGENTES A
          WHERE A.CodTipo           = cTipoAgente
            AND A.Cod_Agente        = N.Cod_Agente
            AND A.CodCia            = D.CodCia
            AND (N.IdTransaccion    = D.IdTransaccion
             OR  N.IdTransaccionAnu = D.IdTransaccion
             OR  N.IdTransacAplic   = D.IdTransaccion
             OR  N.IdTransacRevAplic = D.IdTransaccion)
            AND D.Correlativo       = 1
            AND D.IdTransaccion     = nIdTransaccion
            AND D.CodCia            = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cAplicaTipoAgen := 'N';
         WHEN TOO_MANY_ROWS THEN
            cAplicaTipoAgen := 'S';
      END;
   END IF;

   IF cAplicaTipoAgen = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cAplicaTipoAgen
           FROM AGENTES_DISTRIBUCION_COMISION AG, FACTURAS F, PAGOS P,
                DETALLE_TRANSACCION D, DETALLE_POLIZA DP, AGENTES A
          WHERE A.CodTipo           = cTipoAgente
            AND A.Cod_Agente        = AG.Cod_Agente_Distr
            AND A.CodCia            = AG.CodCia
            AND AG.IDetPol          = DP.IDetPol
            AND AG.IdPoliza         = DP.IdPoliza
            AND AG.CodCia           = DP.CodCia
            AND DP.IdTipoSeg        = cIdTipoSeg
            AND DP.IdPoliza         = F.IdPoliza
            AND DP.IDetPol          = NVL(F.IDetPol, DP.IDetPol)
            AND DP.CodCia           = D.CodCia
            AND F.IdFactura         = P.IdFactura
            AND (P.IdTransaccion    = D.IdTransaccion
             OR  P.IdTransaccionAnu = D.IdTransaccion)
            AND D.Correlativo       = 1
            AND D.IdTransaccion     = nIdTransaccion
            AND D.CodCia            = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cAplicaTipoAgen := 'N';
         WHEN TOO_MANY_ROWS THEN
            cAplicaTipoAgen := 'S';
      END;
   END IF;

   IF cAplicaTipoAgen = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cAplicaTipoAgen
           FROM DETALLE_TRANSACCION DT, AGENTES_DISTRIBUCION_COMISION AG,
                SINIESTRO S, COBERTURA_SINIESTRO C, AGENTES A
          WHERE A.CodTipo          = cTipoAgente
            AND A.Cod_Agente       = AG.Cod_Agente_Distr
            AND A.CodCia           = AG.CodCia
            AND AG.IDetPol         = S.IDetPol
            AND AG.IdPoliza        = S.IdPoliza
            AND AG.CodCia          = S.CodCia
            AND S.IdSiniestro      = C.IdSiniestro
            AND S.IdPoliza         = C.IdPoliza
            AND S.CodCia           = nCodCia
            AND DT.Correlativo     = 1
            AND (C.IdTransaccion     = DT.IdTransaccion
             OR  C.IdTransaccionAnul = DT.IdTransaccion)
            AND DT.IdTransaccion   = nIdTransaccion
          UNION
         SELECT 'S'
           FROM DETALLE_TRANSACCION DT, AGENTES_DISTRIBUCION_COMISION AG,
                SINIESTRO S, COBERTURA_SINIESTRO_ASEG C, AGENTES A
          WHERE A.CodTipo          = cTipoAgente
            AND A.Cod_Agente       = AG.Cod_Agente_Distr
            AND A.CodCia           = AG.CodCia
            AND AG.IDetPol         = S.IDetPol
            AND AG.IdPoliza        = S.IdPoliza
            AND AG.CodCia          = S.CodCia
            AND S.IdSiniestro      = C.IdSiniestro
            AND S.IdPoliza         = C.IdPoliza
            AND S.CodCia           = nCodCia
            AND DT.Correlativo     = 1
            AND (C.IdTransaccion     = DT.IdTransaccion
             OR  C.IdTransaccionAnul = DT.IdTransaccion)
            AND DT.IdTransaccion   = nIdTransaccion;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cAplicaTipoAgen := 'N';
         WHEN TOO_MANY_ROWS THEN
            cAplicaTipoAgen := 'S';
      END;
   END IF;

   IF cAplicaTipoAgen = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cAplicaTipoAgen
           FROM DETALLE_TRANSACCION DT, AGENTES_DISTRIBUCION_COMISION AG,
                SINIESTRO S, APROBACIONES C, AGENTES A
          WHERE A.CodTipo          = cTipoAgente
            AND A.Cod_Agente       = AG.Cod_Agente_Distr
            AND A.CodCia           = AG.CodCia
            AND AG.IDetPol         = S.IDetPol
            AND AG.IdPoliza        = S.IdPoliza
            AND AG.CodCia          = S.CodCia
            AND S.IdSiniestro      = C.IdSiniestro
            AND S.IdPoliza         = C.IdPoliza
            AND S.CodCia           = nCodCia
            AND DT.Correlativo     = 1
            AND (C.IdTransaccion     = DT.IdTransaccion
             OR  C.IdTransaccionAnul = DT.IdTransaccion)
            AND DT.IdTransaccion   = nIdTransaccion
          UNION
         SELECT 'S'
           FROM DETALLE_TRANSACCION DT, AGENTES_DISTRIBUCION_COMISION AG,
                SINIESTRO S, APROBACION_ASEG C, AGENTES A
          WHERE A.CodTipo          = cTipoAgente
            AND A.Cod_Agente       = AG.Cod_Agente_Distr
            AND A.CodCia           = AG.CodCia
            AND AG.IDetPol         = S.IDetPol
            AND AG.IdPoliza        = S.IdPoliza
            AND AG.CodCia          = S.CodCia
            AND S.IdSiniestro      = C.IdSiniestro
            AND S.IdPoliza         = C.IdPoliza
            AND S.CodCia           = nCodCia
            AND DT.Correlativo     = 1
            AND (C.IdTransaccion     = DT.IdTransaccion
             OR  C.IdTransaccionAnul = DT.IdTransaccion)
            AND DT.IdTransaccion   = nIdTransaccion;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cAplicaTipoAgen := 'N';
         WHEN TOO_MANY_ROWS THEN
            cAplicaTipoAgen := 'S';
      END;
   END IF;

   IF cAplicaTipoAgen = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cAplicaTipoAgen
           FROM AGENTES_DISTRIBUCION_COMISION AG, AGENTES A, DETALLE_TRANSACCION D,
                FAI_CONCENTRADORA_FONDO CF, FACTURAS F, DETALLE_POLIZA  DP
          WHERE A.CodTipo           = cTipoAgente
            AND A.Cod_Agente        = AG.Cod_Agente_Distr
            AND A.CodEmpresa        = DP.CodEmpresa
            AND A.CodCia            = AG.CodCia
            AND AG.IDetPol          = DP.IDetPol
            AND AG.IdPoliza         = DP.IdPoliza
            AND AG.CodCia           = DP.CodCia
            AND DP.IdPoliza         = CF.IdPoliza
            AND DP.IDetPol          = CF.IDetPol
            AND DP.CodCia           = CF.CodCia
            AND CF.IdFondo          > 0
            AND CF.CodAsegurado     > 0
            AND CF.IDetPol          > 0
            AND CF.IdPoliza         > 0
            AND CF.IdFactura        = F.IdFactura
            AND (CF.IdTransaccion   = D.IdTransaccion
             OR CF.IdTransaccionAnu = D.IdTransaccion)
            AND CF.CodEmpresa       = D.CodEmpresa
            AND CF.CodCia           = D.CodCia
            AND GT_FAI_MOVIMIENTOS_FONDOS.INDICADORES(CF.CodCia, CF.CodEmpresa,
                                                      GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO(CF.IdFondo),
                                                      CF.CodCptoMov, 'GC') = 'S'
            AND D.Correlativo       = 1
            AND D.IdTransaccion     = nIdTransaccion
            AND D.CodCia            = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cAplicaTipoAgen := 'N';
         WHEN TOO_MANY_ROWS THEN
            cAplicaTipoAgen := 'S';
      END;
   END IF;

   RETURN(cAplicaTipoAgen);
END APLICA_TIPO_AGENTE;

PROCEDURE ACTUALIZA_MONEDA(nCodCia NUMBER, nNumComprob NUMBER, cCodMoneda VARCHAR2) IS
BEGIN
   BEGIN
      UPDATE COMPROBANTES_CONTABLES
         SET CodMoneda   = cCodMoneda
       WHERE CodCia      = nCodCia
         AND NumComprob  = nNumComprob;
   END;
END ACTUALIZA_MONEDA;

FUNCTION STATUS_COMPROBANTE(nCodCia NUMBER, nNumComprob NUMBER) RETURN VARCHAR2 IS
cStsComprob    COMPROBANTES_CONTABLES.StsComprob%TYPE;
BEGIN
   BEGIN
      SELECT StsComprob
        INTO cStsComprob
        FROM COMPROBANTES_CONTABLES
       WHERE CodCia     = nCodCia
         AND NumComprob = nNumComprob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20000,'No Existe Comprobante No. '||nNumComprob || ' de Companía ' || nCodCia);
   END;
   RETURN(cStsComprob);
END STATUS_COMPROBANTE;

FUNCTION POSEE_COMPROBANTE(nCodCia NUMBER, nIdTransaccion NUMBER) RETURN VARCHAR2 IS
nExiste    NUMBER(5);
BEGIN
   BEGIN
      SELECT COUNT(*)
        INTO nExiste
        FROM COMPROBANTES_CONTABLES
       WHERE CodCia         = nCodCia
         AND NumTransaccion = nIdTransaccion;
   END;
   IF NVL(nExiste,0) != 0 THEN
      RETURN('S');
   ELSE
      RETURN('N');
   END IF;
END POSEE_COMPROBANTE;

FUNCTION ENVIADO_SISTEMA_CONTABLE(nCodCia NUMBER, nIdTransaccion NUMBER) RETURN VARCHAR2 IS
cEnviado     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cEnviado
        FROM COMPROBANTES_CONTABLES
       WHERE CodCia         = nCodCia
         AND NumTransaccion = nIdTransaccion
         AND FecEnvioSC    IS NOT NULL
         AND NumComprobSC  IS NOT NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cEnviado := 'N';
      WHEN TOO_MANY_ROWS THEN
         cEnviado := 'S';
   END;
   RETURN(cEnviado);
END ENVIADO_SISTEMA_CONTABLE;

END OC_COMPROBANTES_CONTABLES;
/
