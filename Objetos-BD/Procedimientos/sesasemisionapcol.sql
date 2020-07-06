--
-- SESASEMISIONAPCOL  (Procedure) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DBMS_OUTPUT (Synonym)
--   DBMS_STANDARD (Package)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--   PLAN_COBERTURAS (Table)
--   POLIZAS (Table)
--   FACTURAS (Table)
--   DETALLE_FACTURAS (Table)
--   DETALLE_NOTAS_DE_CREDITO (Table)
--   DETALLE_POLIZA (Table)
--   DETALLE_TRANSACCION (Table)
--   ENTREGAS_CNSF_CONFIG (Table)
--   TARIFA_CONTROL_VIGENCIAS (Table)
--   GT_TARIFA_CONTROL_VIGENCIAS (Package)
--   OC_DETALLE_POLIZA (Package)
--   ACTIVIDADES_ECONOMICAS (Table)
--   ASEGURADO (Table)
--   ASEGURADO_CERTIFICADO (Table)
--   ASISTENCIAS_ASEGURADO (Table)
--   ASISTENCIAS_DETALLE_POLIZA (Table)
--   NOTAS_DE_CREDITO (Table)
--   TEMP_REGISTROS_SESAS (Table)
--   TRANSACCION (Table)
--   OC_SINIESTRO (Package)
--   CONFIG_PLANTILLAS_CAMPOS (Table)
--   CONFIG_SESAS_TIPO_SEGURO (Table)
--   CATALOGO_DE_CONCEPTOS (Table)
--   COBERTURAS_DE_SEGUROS (Table)
--   COBERT_ACT (Table)
--   COBERT_ACT_ASEG (Table)
--   OC_ENTREGAS_CNSF_CONFIG (Package)
--   OC_TARIFA_SEXO_EDAD_RIESGO (Package)
--   PERSONA_NATURAL_JURIDICA (Table)
--   OC_ACTIVIDADES_ECONOMICAS (Package)
--   OC_ARCHIVO (Package)
--   OC_ASEGURADO (Package)
--
CREATE OR REPLACE PROCEDURE SICAS_OC.SESASEMISIONAPCOL( nCodCia      ENTREGAS_CNSF_CONFIG.CODCIA%TYPE
                                                      , nCodEmpresa  ENTREGAS_CNSF_CONFIG.CODEMPRESA%TYPE
                                                      , cCodEntrega  ENTREGAS_CNSF_CONFIG.CODENTREGA%TYPE
                                                      , dFecDesde    DATE
                                                      , dFecHasta    DATE
                                                      , cIdUsr       TEMP_REGISTROS_SESAS.CODUSUARIO%TYPE )  IS
   --Variables Locales
   cCodPlantilla         ENTREGAS_CNSF_CONFIG.CodPlantilla%TYPE;
   cSeparador            ENTREGAS_CNSF_CONFIG.Separador%TYPE;
   cEncabezado           VARCHAR2(4000);
   cPoliz_Stus           POLIZAS.StsPoliza%TYPE;
   cCerti_Stus           DETALLE_POLIZA.StsDetalle%TYPE;
   nPeriodoEspCob        COBERTURAS_DE_SEGUROS.PeriodoEsperaMeses%TYPE;
   nPrimaMonedaTotPol    POLIZAS.PrimaNeta_Moneda%TYPE;
   nPrimaContable        POLIZAS.PrimaNeta_Moneda%TYPE;
   nPrimaContableAnu     POLIZAS.PrimaNeta_Moneda%TYPE;
   nMtoCptoNcrMoneda     DETALLE_NOTAS_DE_CREDITO.MONTO_DET_MONEDA%TYPE;
   nMtoCptoNcrMonedaAnu  DETALLE_NOTAS_DE_CREDITO.MONTO_DET_MONEDA%TYPE;
   nIdPolizaProcCalc     POLIZAS.IdPoliza%TYPE := 0;
   nIdPolizaCalc         POLIZAS.IdPoliza%TYPE := 0;
   nIdPolizaProc         POLIZAS.IdPoliza%TYPE;
   nIDetPolProc          DETALLE_POLIZA.IDetPol%TYPE;
   cEntDd_Ctte           VARCHAR2(2);
   nLinea                NUMBER;
   cCadena               VARCHAR2(4000);
   nSABenef1             NUMBER(20)    := 0;
   nSABenef2             NUMBER(20)    := 0;
   nSABenef3             NUMBER(20)    := 0;
   nSABenef4             NUMBER(20)    := 0;
   nSABenef5             NUMBER(20)    := 0;
   nPmaEmiBe1            NUMBER(20,2)  := 0;
   nPmaEmiBe2            NUMBER(20,2)  := 0;
   nPmaEmiBe3            NUMBER(20,2)  := 0;
   nPmaEmiBe4            NUMBER(20,2)  := 0;
   nPmaEmiBe5            NUMBER(20,2)  := 0;
   cPuntoComa            VARCHAR2(1)   := ';';
   nCantCert             NUMBER(20)    := 0;
   cTipoDetalle          VARCHAR2(20);
   nSACober1             NUMBER(20)    := 0;
   nSACober2             NUMBER(20)    := 0;
   nSACober3             NUMBER(20)    := 0;
   nSACober4             NUMBER(20)    := 0;
   nSACober5             NUMBER(20)    := 0;
   nSACober6             NUMBER(20)    := 0;
   nSACober7             NUMBER(20)    := 0;
   nSACober8             NUMBER(20)    := 0;
   nSACober9             NUMBER(20)    := 0;
   nSACober10            NUMBER(20)    := 0;
   nSACober11            NUMBER(20)    := 0;
   nSACober12            NUMBER(20)    := 0;
   nSACober13            NUMBER(20)    := 0;
   nSACober14            NUMBER(20)    := 0;
   nSACober15            NUMBER(20)    := 0;
   nSACober16            NUMBER(20)    := 0;
   nSACober17            NUMBER(20)    := 0;
   nSACober18            NUMBER(20)    := 0;
   nSACober19            NUMBER(20)    := 0;
   nSACober20            NUMBER(20)    := 0;
   nSACober21            NUMBER(20)    := 0;
   nSACober22            NUMBER(20)    := 0;
   nSACober23            NUMBER(20)    := 0;
   nSACober24            NUMBER(20)    := 0;
   nSACober25            NUMBER(20)    := 0;
   nSACober26            NUMBER(20)    := 0;
   nSACober27            NUMBER(20)    := 0;
   nSACober28            NUMBER(20)    := 0;
   nSACober29            NUMBER(20)    := 0;
   nSACober30            NUMBER(20)    := 0;
   nSACober31            NUMBER(20)    := 0;
   nSACober32            NUMBER(20)    := 0;
   nSACober33            NUMBER(20)    := 0;
   nSACober34            NUMBER(20)    := 0;
   nSACober35            NUMBER(20)    := 0;
   nSACober36            NUMBER(20)    := 0;
   nSACober37            NUMBER(20)    := 0;
   nSACober38            NUMBER(20)    := 0;
   nPmaEmiCo1            NUMBER(20,2)  := 0;
   nPmaEmiCo2            NUMBER(20,2)  := 0;
   nPmaEmiCo3            NUMBER(20,2)  := 0;
   nPmaEmiCo4            NUMBER(20,2)  := 0;
   nPmaEmiCo5            NUMBER(20,2)  := 0;
   nPmaEmiCo6            NUMBER(20,2)  := 0;
   nPmaEmiCo7            NUMBER(20,2)  := 0;
   nPmaEmiCo8            NUMBER(20,2)  := 0;
   nPmaEmiCo9            NUMBER(20,2)  := 0;
   nPmaEmiCo10           NUMBER(20,2)  := 0;
   nPmaEmiCo11           NUMBER(20,2)  := 0;
   nPmaEmiCo12           NUMBER(20,2)  := 0;
   nPmaEmiCo13           NUMBER(20,2)  := 0;
   nPmaEmiCo14           NUMBER(20,2)  := 0;
   nPmaEmiCo15           NUMBER(20,2)  := 0;
   nPmaEmiCo16           NUMBER(20,2)  := 0;
   nPmaEmiCo17           NUMBER(20,2)  := 0;
   nPmaEmiCo18           NUMBER(20,2)  := 0;
   nPmaEmiCo19           NUMBER(20,2)  := 0;
   nPmaEmiCo20           NUMBER(20,2)  := 0;
   nPmaEmiCo21           NUMBER(20,2)  := 0;
   nPmaEmiCo22           NUMBER(20,2)  := 0;
   nPmaEmiCo23           NUMBER(20,2)  := 0;
   nPmaEmiCo24           NUMBER(20,2)  := 0;
   nPmaEmiCo25           NUMBER(20,2)  := 0;
   nPmaEmiCo26           NUMBER(20,2)  := 0;
   nPmaEmiCo27           NUMBER(20,2)  := 0;
   nPmaEmiCo28           NUMBER(20,2)  := 0;
   nPmaEmiCo29           NUMBER(20,2)  := 0;
   nPmaEmiCo30           NUMBER(20,2)  := 0;
   nPmaEmiCo31           NUMBER(20,2)  := 0;
   nPmaEmiCo32           NUMBER(20,2)  := 0;
   nPmaEmiCo33           NUMBER(20,2)  := 0;
   nPmaEmiCo34           NUMBER(20,2)  := 0;
   nPmaEmiCo35           NUMBER(20,2)  := 0;
   nPmaEmiCo36           NUMBER(20,2)  := 0;
   nPmaEmiCo37           NUMBER(20,2)  := 0;
   nPmaEmiCo38           NUMBER(20,2)  := 0;
   nIniCob               CONFIG_SESAS_TIPO_SEGURO.InicioCobertura%TYPE;
   cSubTipoSeg           CONFIG_SESAS_TIPO_SEGURO.SubTipoSeg%TYPE;
   cModalPoliza          CONFIG_SESAS_TIPO_SEGURO.ModalPoliza%TYPE;
   cTipoRiesgoAsoc       CONFIG_SESAS_TIPO_SEGURO.TipoRiesgoAsoc%TYPE;
   cTipo_Seg             CONFIG_SESAS_TIPO_SEGURO.TipoSeguro%TYPE;
   nMaxDiasBenef3        CONFIG_SESAS_TIPO_SEGURO.MaxDiasBenef3%TYPE;
   cTipoRiesgo           CONFIG_SESAS_TIPO_SEGURO.TipoRiesgo%TYPE;
   nMtoFondoAdmin        NUMBER(28,2);
   nMtoVencimiento       NUMBER(28,2);
   nMtoRescate           NUMBER(28,2);
   nSldoFondoInv         NUMBER(28,2);
   nContadorReg          NUMBER(10);
   cTodasAnuladas        VARCHAR2(1);
   cStatus1              VARCHAR2(6);
   cStatus2              VARCHAR2(6);
   cStatus3              VARCHAR2(6);
   cStatus4              VARCHAR2(6);
   cStatus5              VARCHAR2(6) := 'SOL';
   cStatus6              VARCHAR2(6) := 'SOLICI';
   cEsDeclarativa        VARCHAR2(6) := 'S';
   cSexo                 PERSONA_NATURAL_JURIDICA.Sexo%TYPE;
   cRiesgo               ACTIVIDADES_ECONOMICAS.RiesgoActividad%TYPE;
   cCodActividad         PERSONA_NATURAL_JURIDICA.CodActividad%TYPE;
   nIdTarifa             TARIFA_CONTROL_VIGENCIAS.IdTarifa%TYPE;
   nEdad                 NUMBER(5);
   nTasa                 NUMBER;
   cCodCobert            COBERTURAS_DE_SEGUROS.CodCobert%TYPE;
   nPrima_Moneda         COBERT_ACT.Prima_Moneda%TYPE;
   cRecalculoPrimas      VARCHAR2(1);
   --
   dFecNacimiento        PERSONA_NATURAL_JURIDICA.FECNACIMIENTO%TYPE;
   --
   --Afinación
   nCodCiaAfina          DETALLE_POLIZA.CODCIA%TYPE;
   nCodEmpresaAfina      DETALLE_POLIZA.CODEMPRESA%TYPE;
   nIdPolizaAfina        DETALLE_POLIZA.IDPOLIZA%TYPE;
   nIDetPolAfina         DETALLE_POLIZA.IDETPOL%TYPE;
   nCantAseg_1           NUMBER;
   nCantAseg_2           NUMBER;
   cNomArchivo           ENTREGAS_CNSF_CONFIG.NOMARCHIVO%TYPE;
   cNomArchZip           VARCHAR2(100);
   --
   CURSOR C_CAMPO IS
      SELECT NomCampo
        FROM CONFIG_PLANTILLAS_CAMPOS
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND CodPlantilla = cCodPlantilla
      ORDER BY OrdenCampo;
   --
   CURSOR POL_Q IS
      SELECT IdPoliza
           , StsPoliza
           , TipoAdministracion
           , IdTipoSeg
           , PlanCob
           , FecIniVig
        FROM TEMP_POLIZAS_SESAS
       WHERE IdPoliza   = nIdPolizaProc;
   --
   CURSOR POL_IND_Q IS
      SELECT P.NumPolUnico                                     Poliza
           , TRIM(TO_CHAR(D.IdPoliza,'00000000')) || TRIM(TO_CHAR(D.IDetPol,'00000')) || TRIM(TO_CHAR(D.Cod_Asegurado,'0000000'))  Certi
           , DECODE(P.Cod_Moneda,'PS','N',DECODE(P.Cod_Moneda,'US','E','I'))  Moneda
           , TO_CHAR(D.FecIniVig,'YYYYMMDD')                   Ini_Vig
           , TO_CHAR(D.FecFinVig,'YYYYMMDD')                   Fin_Vig
           , TO_CHAR(D.FecIniVig,'YYYYMMDD')                   Fecha_Alta
           , TO_CHAR(D.FecAnul,'YYYYMMDD')                     Fecha_Baja
           , TO_CHAR(PN.FecNacimiento,'YYYYMMDD')              Fecha_Nac
           , DECODE(PN.Sexo,'N',NULL,PN.Sexo)                  Sexo
           , P.FormaVenta                                      Forma_Vta
           , CEIL(MONTHS_BETWEEN(D.FecFinVig,D.FecIniVig)/12)  AnioPoliza
           , SUBSTR(P.TipoDividendo,3,1)                       TipoDividendo
           , 0                                                 MontoDividendo
           , DECODE(NVL(P.IndConcentrada,'N'),'N',0,1)         PolConcentrada
           , PN.CodPaisRes                                     CodPais
           , PN.CodProvRes                                     CodEstado
           , P.IdPoliza
           , P.StsPoliza
           , P.FecFinVig                                       FecFinVigPol
           , P.FecIniVig
           , D.IdTipoSeg
           , D.IDetPol
           , D.StsDetalle
           , D.FecFinVig
           , D.IndAsegModelo
           , NVL(D.CantAsegModelo,0)                           CantAsegModelo
           , D.Cod_Asegurado
           , 'IND'                                             TipoDetalle
        FROM DETALLE_POLIZA            D
           , POLIZAS                   P
           , ASEGURADO                 A
           , PERSONA_NATURAL_JURIDICA  PN
           , PLAN_COBERTURAS           PC
       WHERE PN.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
         AND PN.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
         AND A.Cod_Asegurado            = D.Cod_Asegurado
         AND NOT EXISTS ( SELECT 'N'
                            FROM ASEGURADO_CERTIFICADO
                           WHERE CodCia        = D.CodCia
                             AND IdPoliza      = D.IdPoliza
                             AND IDetPol       = D.IDetPol
                             AND Cod_Asegurado = A.Cod_Asegurado )
         AND ( ( D.FecFinVig >= dFecDesde AND D.StsDetalle IN ('EMI','REN' ) )
            OR ( D.StsDetalle = 'ANU' AND D.FecAnul >= dFecDesde AND D.MotivAnul != 'REEX' )
            OR ( P.StsPoliza  = 'ANU' AND P.FecSts  >= dFecDesde )
             )
         AND P.CodCia       = D.CodCia
         AND P.IdPoliza     = D.IdPoliza
         AND P.CodEmpresa   = D.CodEmpresa
         AND D.CodEmpresa   = nCodEmpresa
         AND D.CodCia       = nCodCia
         AND D.IDetPol      > 0
         AND D.IdPoliza     > 0
         AND PC.IdTipoSeg   = D.IdTipoSeg
         AND PC.CodEmpresa  = D.CodEmpresa
         AND PC.CodCia      = D.CodCia
         AND PC.PlanCob     = D.PlanCob
         AND PC.CodTipoPlan = '033'
       ORDER BY P.IdPoliza;
   --
   CURSOR POL_COL_Q IS
      SELECT P.NumPolUnico                                     Poliza 
           , TRIM(TO_CHAR(D.IdPoliza,'00000000')) || TRIM(TO_CHAR(D.IDetPol,'00000')) || TRIM(TO_CHAR(AC.Cod_Asegurado,'0000000')) Certi
           , DECODE(P.Cod_Moneda,'PS','N',DECODE(P.Cod_Moneda,'US','E','I'))  Moneda
           , TO_CHAR(D.FecIniVig,'YYYYMMDD')                   Ini_Vig
           , TO_CHAR(D.FecFinVig,'YYYYMMDD')                   Fin_Vig
           , TO_CHAR(D.FecIniVig,'YYYYMMDD')                   Fecha_Alta
           , TO_CHAR(D.FecAnul,'YYYYMMDD')                     Fecha_Baja
           , TO_CHAR(PN.FecNacimiento,'YYYYMMDD')              Fecha_Nac
           , DECODE(PN.Sexo,'N',NULL,PN.Sexo)                  Sexo
           , P.FormaVenta                                      Forma_Vta
           , CEIL(MONTHS_BETWEEN(D.FecFinVig,D.FecIniVig)/12)  AnioPoliza
           , SUBSTR(P.TipoDividendo,3,1)                       TipoDividendo
           , 0                                                 MontoDividendo
           , DECODE(NVL(P.IndConcentrada,'N'),'N',0,1)         PolConcentrada
           , PN.CodPaisRes                                     CodPais
           , PN.CodProvRes                                     CodEstado
           , P.IdPoliza
           , P.StsPoliza
           , P.FecFinVig                                       FecFinVigPol
           , P.FecIniVig
           , D.IdTipoSeg
           , D.IDetPol
           , AC.Estado                                         StsDetalle
           , D.FecFinVig
           , D.IndAsegModelo
           , NVL(D.CantAsegModelo,0)                           CantAsegModelo
           , AC.Cod_Asegurado
           , 'COL'                                             TipoDetalle
        FROM DETALLE_POLIZA             D
           , POLIZAS                    P
           , ASEGURADO_CERTIFICADO     AC
           , ASEGURADO                  A
           , PERSONA_NATURAL_JURIDICA  PN
           , PLAN_COBERTURAS           PC
       WHERE PN.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
         AND PN.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
         AND A.Cod_Asegurado            = AC.Cod_Asegurado
         AND AC.CodCia                  = D.CodCia
         AND AC.IdPoliza                = D.IdPoliza
         AND AC.IDetPol                 = D.IDetPol
         AND ( ( D.FecFinVig >= dFecDesde AND D.StsDetalle IN ('EMI','REN') )
            OR ( D.StsDetalle = 'ANU' AND D.FecAnul >= dFecDesde AND  D.MotivAnul != 'REEX' )
            OR ( P.StsPoliza = 'ANU' AND P.FecSts >= dFecDesde ))
         AND P.CodCia     = D.CodCia
         AND P.CodEmpresa = D.CodEmpresa
         AND P.IdPoliza   = D.IdPoliza
         AND D.CodEmpresa = nCodEmpresa
         AND D.CodCia     = nCodCia
         AND D.IDetPol    > 0
         AND D.IdPoliza   > 0
         AND PC.IdTipoSeg   = D.IdTipoSeg
         AND PC.CodEmpresa  = D.CodEmpresa
         AND PC.CodCia      = D.CodCia
         AND PC.PlanCob     = D.PlanCob
         AND PC.CodTipoPlan = '033'
       ORDER BY P.IdPoliza;
   --
   CURSOR POL_IND_MOV_Q IS
      SELECT DISTINCT P.NumPolUnico                            Poliza
           , TRIM(TO_CHAR(D.IdPoliza,'00000000')) || TRIM(TO_CHAR(D.IDetPol,'00000')) || TRIM(TO_CHAR(D.Cod_Asegurado,'0000000')) Certi
           , DECODE(P.Cod_Moneda,'PS','N', DECODE(P.Cod_Moneda,'US','E','I'))  Moneda
           , TO_CHAR(D.FecIniVig,'YYYYMMDD')                   Ini_Vig
           , TO_CHAR(D.FecFinVig,'YYYYMMDD')                   Fin_Vig
           , TO_CHAR(D.FecIniVig,'YYYYMMDD')                   Fecha_Alta
           , TO_CHAR(D.FecAnul,'YYYYMMDD')                     Fecha_Baja
           , TO_CHAR(PN.FecNacimiento,'YYYYMMDD')              Fecha_Nac
           , DECODE(PN.Sexo,'N',NULL,PN.Sexo)                  Sexo
           , P.FormaVenta                                      Forma_Vta
           , CEIL(MONTHS_BETWEEN(D.FecFinVig,D.FecIniVig)/12)  AnioPoliza
           , SUBSTR(P.TipoDividendo,3,1)                       TipoDividendo
           , 0                                                 MontoDividendo
           , DECODE(NVL(P.IndConcentrada,'N'),'N',0,1)         PolConcentrada
           , PN.CodPaisRes                                     CodPais
           , PN.CodProvRes                                     CodEstado
           , P.IdPoliza
           , P.StsPoliza
           , P.FecFinVig                                       FecFinVigPol
           , P.FecIniVig
           , D.IdTipoSeg
           , D.IDetPol
           , D.StsDetalle
           , D.FecFinVig
           , D.IndAsegModelo
           , NVL(D.CantAsegModelo,0)                           CantAsegModelo
           , D.Cod_Asegurado
           , 'IND' TipoDetalle
        FROM DETALLE_POLIZA             D
           , POLIZAS                    P
           , ASEGURADO                  A
           , PERSONA_NATURAL_JURIDICA  PN
           , PLAN_COBERTURAS           PC
       WHERE A.Num_Doc_Identificacion = PN.Num_Doc_Identificacion 
         AND A.Tipo_Doc_Identificacion = PN.Tipo_Doc_Identificacion 
         AND D.Cod_Asegurado           = A.Cod_Asegurado 
         AND dFecDesde                 > D.FecFinVig 
         AND D.CodCia                  = P.CodCia 
         AND D.IdPoliza                = P.IdPoliza 
         AND D.CodEmpresa              = P.CodEmpresa 
         AND nCodEmpresa               = D.CodEmpresa 
         AND nCodCia                   = D.CodCia 
         AND D.IDetPol                 > 0
         AND D.IdPoliza                > 0
         AND nCodCia                   = P.CodCia 
         AND NOT EXISTS ( SELECT 'N' 
                            FROM ASEGURADO_CERTIFICADO 
                           WHERE D.CodCia        = CodCia 
                             AND D.IdPoliza      = IdPoliza 
                             AND D.IDetPol       = IDetPol 
                             AND D.Cod_Asegurado = Cod_Asegurado) 
         AND PC.IdTipoSeg   = D.IdTipoSeg
         AND PC.CodEmpresa  = D.CodEmpresa
         AND PC.CodCia      = D.CodCia
         AND PC.PlanCob     = D.PlanCob
         AND PC.CodTipoPlan = '033'
         AND EXISTS ( SELECT /*+ INDEX(X SYS_C0031885) */ 'S' 
                        FROM TRANSACCION          T
                           , DETALLE_TRANSACCION  X
                       WHERE X.IdTransaccion     = T.IdTransaccion
                         AND X.CodCia            = T.CodCia
                         AND X.CodEmpresa        = T.CodEmpresa
                         AND X.Valor1            = D.IdPoliza
                         AND X.Correlativo       > 0
                         AND X.CodSubProceso   NOT IN ('ESV','ESVTL','PAG','EMIPRD','PAGPRD','APLPRD','ANUPRD','REVPPD')
                         AND T.IdTransaccion     > 0
                         AND T.CodCia            = D.CodCia
                         AND T.CodEmpresa        = D.CodEmpresa
                         AND T.IdProceso        != 6
                         AND T.FechaTransaccion >= dFecDesde )
       ORDER BY P.IdPoliza;

   CURSOR POL_COL_MOV_Q IS
      SELECT DISTINCT P.NumPolUnico  Poliza
           , TRIM(TO_CHAR(D.IdPoliza,'00000000')) || TRIM(TO_CHAR(D.IDetPol,'00000')) || TRIM(TO_CHAR(AC.Cod_Asegurado,'0000000')) Certi
           , DECODE(P.Cod_Moneda,'PS','N', DECODE(P.Cod_Moneda,'US','E','I'))  Moneda
           , TO_CHAR(D.FecIniVig,'YYYYMMDD')                                   Ini_Vig
           , TO_CHAR(D.FecFinVig,'YYYYMMDD')                                   Fin_Vig
           , TO_CHAR(D.FecIniVig,'YYYYMMDD')                                   Fecha_Alta
           , TO_CHAR(D.FecAnul,'YYYYMMDD')                                     Fecha_Baja
           , TO_CHAR(PN.FecNacimiento,'YYYYMMDD')                              Fecha_Nac
           , DECODE(PN.Sexo,'N',NULL,PN.Sexo)                                  Sexo
           , P.FormaVenta                                                      Forma_Vta
           , CEIL(MONTHS_BETWEEN(D.FecFinVig,D.FecIniVig)/12)                  AnioPoliza
           , SUBSTR(P.TipoDividendo,3,1)                                       TipoDividendo
           , 0                                                                 MontoDividendo
           , DECODE(NVL(P.IndConcentrada,'N'),'N',0,1)                         PolConcentrada
           , PN.CodPaisRes                                                     CodPais
           , PN.CodProvRes                                                     CodEstado
           , P.IdPoliza
           , P.StsPoliza
           , P.FecFinVig                                                       FecFinVigPol
           , P.FecIniVig
           , D.IdTipoSeg
           , D.IDetPol
           , AC.Estado                                                         StsDetalle
           , D.FecFinVig
           , D.IndAsegModelo
           , NVL(D.CantAsegModelo,0)                                           CantAsegModelo
           , AC.Cod_Asegurado
           , 'COL'                                                             TipoDetalle
        FROM DETALLE_POLIZA             D
           , POLIZAS                    P
           , ASEGURADO_CERTIFICADO     AC
           , ASEGURADO                  A
           , PERSONA_NATURAL_JURIDICA  PN
           , PLAN_COBERTURAS           PC
       WHERE PN.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
         AND PN.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
         AND A.Cod_Asegurado            = AC.Cod_Asegurado
         AND A.CodCia                   = AC.CodCia
         AND AC.CodCia                  = D.CodCia
         AND AC.IdPoliza                = D.IdPoliza
         AND AC.IDetPol                 = D.IDetPol
         AND P.CodCia                   = D.CodCia
         AND P.IdPoliza                 = D.IdPoliza
         AND D.FecFinVig                < dFecDesde
         AND P.CodCia                   = D.CodCia
         AND P.CodEmpresa               = D.CodEmpresa
         AND P.IdPoliza                 = D.IdPoliza
         AND D.CodEmpresa               = nCodEmpresa
         AND D.CodCia                   = nCodCia
         AND D.IDetPol                  > 0
         AND D.IdPoliza                 > 0
         AND PC.IdTipoSeg   = D.IdTipoSeg
         AND PC.CodEmpresa  = D.CodEmpresa
         AND PC.CodCia      = D.CodCia
         AND PC.PlanCob     = D.PlanCob
         AND PC.CodTipoPlan = '033'
         AND EXISTS ( SELECT /*+ INDEX(DT SYS_C0031885) */ 'S' 
                        FROM TRANSACCION         T
                           , DETALLE_TRANSACCION DT
                       WHERE DT.IdTransaccion    = T.IdTransaccion
                         AND DT.Valor1           = D.IdPoliza
                         AND DT.Correlativo      > 0
                         AND DT.CodSubProceso  NOT IN ('ESV','ESVTL','PAG','EMIPRD','PAGPRD','APLPRD','ANUPRD','REVPPD')
                         AND DT.CodCia           = T.CodCia
                         AND T.CodCia            = D.CodCia
                         AND T.CodEmpresa        = D.CodEmpresa
                         AND T.IdTransaccion     > 0
                         AND T.IdProceso        != 6
                         AND T.FechaTransaccion >= dFecDesde )
      MINUS
      SELECT P.NumPolUnico  Poliza
           , TRIM(TO_CHAR(D.IdPoliza,'00000000')) || TRIM(TO_CHAR(D.IDetPol,'00000')) || TRIM(TO_CHAR(AC.Cod_Asegurado,'0000000'))  Certi
           , DECODE(P.Cod_Moneda,'PS','N', DECODE(P.Cod_Moneda,'US','E','I'))  Moneda
           , TO_CHAR(D.FecIniVig,'YYYYMMDD')                                   Ini_Vig
           , TO_CHAR(D.FecFinVig,'YYYYMMDD')                                   Fin_Vig
           , TO_CHAR(D.FecIniVig,'YYYYMMDD')                                   Fecha_Alta
           , TO_CHAR(D.FecAnul,'YYYYMMDD')                                     Fecha_Baja
           , TO_CHAR(PN.FecNacimiento,'YYYYMMDD')                              Fecha_Nac
           , DECODE(PN.Sexo,'N',NULL,PN.Sexo)                                  Sexo
           , P.FormaVenta                                                      Forma_Vta
           , CEIL(MONTHS_BETWEEN(D.FecFinVig,D.FecIniVig)/12)                  AnioPoliza
           , SUBSTR(P.TipoDividendo,3,1)                                       TipoDividendo
           , 0                                                                 MontoDividendo
           , DECODE(NVL(P.IndConcentrada,'N'),'N',0,1)                         PolConcentrada
           , PN.CodPaisRes                                                     CodPais
           , PN.CodProvRes                                                     CodEstado
           , P.IdPoliza
           , P.StsPoliza
           , P.FecFinVig                                                       FecFinVigPol
           , P.FecIniVig
           , D.IdTipoSeg
           , D.IDetPol
           , AC.Estado                                                         StsDetalle
           , D.FecFinVig
           , D.IndAsegModelo
           , NVL(D.CantAsegModelo,0)                                           CantAsegModelo
           , AC.Cod_Asegurado
           , 'COL'                                                             TipoDetalle
        FROM DETALLE_POLIZA             D
           , POLIZAS                    P
           , ASEGURADO_CERTIFICADO     AC
           , ASEGURADO                  A
           , PERSONA_NATURAL_JURIDICA  PN
           , PLAN_COBERTURAS           PC
       WHERE PN.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
         AND PN.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
         AND A.Cod_Asegurado            = AC.Cod_Asegurado
         AND AC.CodCia                  = D.CodCia
         AND AC.IdPoliza                = D.IdPoliza
         AND AC.IDetPol                 = D.IDetPol
         AND P.IdPoliza                 = D.IdPoliza
         AND ((D.FecFinVig             >= dFecDesde
         AND  D.StsDetalle              IN ('EMI','REN'))
          OR (D.StsDetalle              = 'ANU'
         AND  D.FecAnul                >=  dFecDesde
         AND  D.MotivAnul              != 'REEX')
          OR (P.StsPoliza               = 'ANU'
         AND  P.FecSts                 >= dFecDesde))
         AND P.CodCia                   = D.CodCia
         AND P.IdPoliza                 = D.IdPoliza
         AND P.CodEmpresa               = D.CodEmpresa
         AND D.CodEmpresa               = nCodEmpresa
         AND D.CodCia                   = nCodCia
         AND D.IDetPol                  > 0
         AND D.IdPoliza                 > 0
         AND PC.IdTipoSeg   = D.IdTipoSeg
         AND PC.CodEmpresa  = D.CodEmpresa
         AND PC.CodCia      = D.CodCia
         AND PC.PlanCob     = D.PlanCob
         AND PC.CodTipoPlan = '033'
       ORDER BY IdPoliza;

   PROCEDURE COBERTURAS ( nCodCia         COBERT_ACT.CODCIA%TYPE
                        , nIdPoliza       COBERT_ACT.IDPOLIZA%TYPE
                        , nIDetPol        COBERT_ACT.IDETPOL%TYPE
                        , nCod_Asegurado  COBERT_ACT.COD_ASEGURADO%TYPE
                        , dFecIniVig      DATE ) IS
      CURSOR COBERT_Q IS
         SELECT C.CodCobert
              , NVL(CS.ClaveSesas,'1')     ClaveSesas
              , NVL(OrdenSESAS,0)          OrdenSESAS
              , NVL(PeriodoEsperaMeses,0)  PeriodoEspera
              , SUM(SumaAseg_Moneda)       Suma_Moneda
              , SUM(C.Prima_Moneda)        Prima_Moneda
           FROM COBERT_ACT              C
              , COBERTURAS_DE_SEGUROS  CS
          WHERE CS.IdTipoSeg     = C.IdTipoSeg
            AND CS.PlanCob       = C.PlanCob
            AND CS.CodCobert     = C.CodCobert
            AND CS.CodEmpresa    = C.CodEmpresa
            AND CS.CodCia        = C.CodCia
            AND C.StsCobertura NOT IN (cStatus1, cStatus2, cStatus5)
            AND C.Cod_Asegurado  = nCod_Asegurado
            AND C.IDetPol        = nIDetPol
            AND C.IdPoliza       = nIdPoliza
            AND C.CodCia         = nCodCia
          GROUP BY C.CodCobert, NVL(CS.ClaveSesas,'1'), NVL(OrdenSESAS,0), NVL(PeriodoEsperaMeses,0)
         UNION ALL
         SELECT C.CodCobert
              , NVL(CS.ClaveSesas,'1')     ClaveSesas
              , NVL(OrdenSESAS,0)          OrdenSESAS
              , NVL(PeriodoEsperaMeses,0)  PeriodoEspera
              , SUM(SumaAseg_Moneda)       Suma_Moneda
              , SUM(C.Prima_Moneda)        Prima_Moneda
           FROM COBERT_ACT_ASEG         C
              , COBERTURAS_DE_SEGUROS  CS
          WHERE CS.IdTipoSeg     = C.IdTipoSeg
            AND CS.PlanCob       = C.PlanCob
            AND CS.CodCobert     = C.CodCobert
            AND CS.CodEmpresa    = C.CodEmpresa
            AND CS.CodCia        = C.CodCia
            AND C.StsCobertura NOT IN (cStatus1, cStatus2, cStatus5)
            AND C.Cod_Asegurado  = nCod_Asegurado
            AND C.IDetPol        = nIDetPol
            AND C.IdPoliza       = nIdPoliza
            AND C.CodCia         = nCodCia
          GROUP BY C.CodCobert, NVL(CS.ClaveSesas,'1'), NVL(OrdenSESAS,0), NVL(PeriodoEsperaMeses,0);

      CURSOR CALC_Q IS   
         SELECT C.Cod_Asegurado
              , C.SumaAseg_Moneda
              , C.CodCobert
              , C.Tasa
              , CS.Porc_Tasa
              , CS.CodTarifa
              , C.IdTipoSeg
              , C.PlanCob
              , DECODE(CS.TipoTasa,'C',100,DECODE(CS.TipoTasa,'M',1000,1)) FactorTasa
              , CS.Prima_Cobert
           FROM COBERT_ACT              C
              , COBERTURAS_DE_SEGUROS  CS
          WHERE CS.IdTipoSeg      = C.IdTipoSeg
            AND CS.PlanCob        = C.PlanCob
            AND CS.CodCobert      = C.CodCobert
            AND CS.CodEmpresa     = C.CodEmpresa
            AND CS.CodCia         = C.CodCia
            AND C.SumaAseg_Moneda > 0
            AND C.IDetPol         > 0
            AND C.CodCia          = nCodCia
            AND C.IdPoliza        = nIdPolizaCalc
          UNION ALL
         SELECT C.Cod_Asegurado
              , C.SumaAseg_Moneda
              , C.CodCobert
              , C.Tasa
              , CS.Porc_Tasa
              , CS.CodTarifa
              , C.IdTipoSeg
              , C.PlanCob
              , DECODE(CS.TipoTasa,'C',100,DECODE(CS.TipoTasa,'M',1000,1)) FactorTasa
              , CS.Prima_Cobert
           FROM COBERT_ACT_ASEG         C
              , COBERTURAS_DE_SEGUROS  CS
          WHERE CS.IdTipoSeg      = C.IdTipoSeg
            AND CS.PlanCob        = C.PlanCob
            AND CS.CodCobert      = C.CodCobert
            AND CS.CodEmpresa     = C.CodEmpresa
            AND CS.CodCia         = C.CodCia
            AND C.SumaAseg_Moneda > 0
            AND C.IDetPol         > 0
            AND C.CodCia          = nCodCia
            AND C.IdPoliza        = nIdPolizaCalc;

      CURSOR COB_CALC_Q IS
         SELECT C.Cod_Asegurado
              , C.SumaAseg_Moneda
              , C.CodCobert
              , C.Tasa
              , CS.Porc_Tasa
              , CS.CodTarifa
              , C.IdTipoSeg
              , C.PlanCob
              , DECODE(CS.TipoTasa,'C',100,DECODE(CS.TipoTasa,'M',1000,1)) FactorTasa
              , CS.Prima_Cobert
           FROM COBERT_ACT              C
              , COBERTURAS_DE_SEGUROS  CS
          WHERE CS.IdTipoSeg      = C.IdTipoSeg
            AND CS.PlanCob        = C.PlanCob
            AND CS.CodCobert      = C.CodCobert
            AND CS.CodEmpresa     = C.CodEmpresa
            AND CS.CodCia         = C.CodCia
            AND C.SumaAseg_Moneda > 0
            AND C.Cod_Asegurado   = nCod_Asegurado
            AND C.IDetPol         = nIDetPol
            AND C.CodCia          = nCodCia
            AND C.IdPoliza        = nIdPoliza
            AND C.CodCobert       = cCodCobert
          UNION ALL
         SELECT C.Cod_Asegurado
              , C.SumaAseg_Moneda
              , C.CodCobert
              , C.Tasa
              , CS.Porc_Tasa
              , CS.CodTarifa
              , C.IdTipoSeg
              , C.PlanCob
              , DECODE(CS.TipoTasa,'C',100,DECODE(CS.TipoTasa,'M',1000,1)) FactorTasa
              , CS.Prima_Cobert
           FROM COBERT_ACT_ASEG         C
              , COBERTURAS_DE_SEGUROS  CS
          WHERE CS.IdTipoSeg      = C.IdTipoSeg
            AND CS.PlanCob        = C.PlanCob
            AND CS.CodCobert      = C.CodCobert
            AND CS.CodEmpresa     = C.CodEmpresa
            AND CS.CodCia         = C.CodCia
            AND C.SumaAseg_Moneda > 0
            AND C.Cod_Asegurado   = nCod_Asegurado
            AND C.IDetPol         = nIDetPol
            AND C.CodCia          = nCodCia
            AND C.IdPoliza        = nIdPoliza
            AND C.CodCobert       = cCodCobert;
         --
         CURSOR c_DatosPersona( nCodCia         ASEGURADO.CODCIA%TYPE
                              , nCodEmpresa     ASEGURADO.CODEMPRESA%TYPE
                              , nCod_Asegurado  ASEGURADO.COD_ASEGURADO%TYPE ) IS
            SELECT Sexo, FecNacimiento, CodActividad
              FROM PERSONA_NATURAL_JURIDICA
             WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN ( SELECT Tipo_Doc_Identificacion, Num_Doc_Identificacion
                                                                            FROM ASEGURADO
                                                                           WHERE CodCia        = nCodCia
                                                                             AND CodEmpresa    = nCodEmpresa
                                                                             AND Cod_Asegurado = nCod_Asegurado );
      cExistePoliza  VARCHAR2(1);
   BEGIN
      nSABenef1   := 0;
      nSABenef2   := 0;
      nSABenef3   := 0;
      nSABenef4   := 0;
      nSABenef5   := 0;
      nPmaEmiBe1  := 0;
      nPmaEmiBe2  := 0;
      nPmaEmiBe3  := 0;
      nPmaEmiBe4  := 0;
      nPmaEmiBe5  := 0;
      nSACober1   := 0;
      nSACober2   := 0;
      nSACober3   := 0;
      nSACober4   := 0;
      nSACober5   := 0;
      nSACober6   := 0;
      nSACober7   := 0;
      nSACober8   := 0;
      nSACober9   := 0;
      nSACober10  := 0;
      nSACober11  := 0;
      nSACober12  := 0;
      nSACober13  := 0;
      nSACober14  := 0;
      nSACober15  := 0;
      nSACober16  := 0;
      nSACober17  := 0;
      nSACober18  := 0;
      nSACober19  := 0;
      nSACober20  := 0;
      nSACober21  := 0;
      nSACober22  := 0;
      nSACober23  := 0;
      nSACober24  := 0;
      nSACober25  := 0;
      nSACober26  := 0;
      nSACober27  := 0;
      nSACober28  := 0;
      nSACober29  := 0;
      nSACober30  := 0;
      nSACober31  := 0;
      nSACober32  := 0;
      nSACober33  := 0;
      nSACober34  := 0;
      nSACober35  := 0;
      nSACober36  := 0;
      nSACober37  := 0;
      nSACober38  := 0;
      nPmaEmiCo1  := 0;
      nPmaEmiCo2  := 0;
      nPmaEmiCo3  := 0;
      nPmaEmiCo4  := 0;
      nPmaEmiCo5  := 0;
      nPmaEmiCo6  := 0;
      nPmaEmiCo7  := 0;
      nPmaEmiCo8  := 0;
      nPmaEmiCo9  := 0;
      nPmaEmiCo10 := 0;
      nPmaEmiCo11 := 0;
      nPmaEmiCo12 := 0;
      nPmaEmiCo13 := 0;
      nPmaEmiCo14 := 0;
      nPmaEmiCo15 := 0;
      nPmaEmiCo16 := 0;
      nPmaEmiCo17 := 0;
      nPmaEmiCo18 := 0;
      nPmaEmiCo19 := 0;
      nPmaEmiCo20 := 0;
      nPmaEmiCo21 := 0;
      nPmaEmiCo22 := 0;
      nPmaEmiCo23 := 0;
      nPmaEmiCo24 := 0;
      nPmaEmiCo25 := 0;
      nPmaEmiCo26 := 0;
      nPmaEmiCo27 := 0;
      nPmaEmiCo28 := 0;
      nPmaEmiCo29 := 0;
      nPmaEmiCo30 := 0;
      nPmaEmiCo31 := 0;
      nPmaEmiCo32 := 0;
      nPmaEmiCo33 := 0;
      nPmaEmiCo34 := 0;
      nPmaEmiCo35 := 0;
      nPmaEmiCo36 := 0;
      nPmaEmiCo37 := 0;
      nPmaEmiCo38 := 0;

      BEGIN
         SELECT 'S'
         INTO   cExistePoliza
         FROM   TEMP_POLIZAS_SESAS
         WHERE  IdPoliza = nIdPolizaProc;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
           cExistePoliza := 'N';
      WHEN TOO_MANY_ROWS THEN
           cExistePoliza := 'S';
      END;

      IF cExistePoliza = 'N' THEN
         DELETE TEMP_POLIZAS_SESAS;
         --
         --Administro la tabla alterna
         INSERT INTO TEMP_POLIZAS_SESAS
            SELECT DISTINCT P.IdPoliza
                 , P.StsPoliza
                 , P.TipoAdministracion
                 , D.IdTipoSeg
                 , D.PlanCob
                 , P.FecIniVig
              FROM POLIZAS         P
                 , DETALLE_POLIZA  D
             WHERE D.CodCia                  = P.CodCia
               AND D.IdPoliza                = P.IdPoliza
               AND P.CodCia                  = nCodCia
               AND P.IdPoliza                = nIdPolizaProc
               AND P.StsPoliza              != 'SOL'
               AND ( P.MotivAnul IS NULL
                     OR
                     NVL(P.MotivAnul,'NULL') IS NOT NULL
                     AND
                     P.FecSts >= dFecDesde )
            UNION
            SELECT DISTINCT D.IdPoliza
                 , P.StsPoliza
                 , P.TipoAdministracion
                 , D.IdTipoSeg
                 , D.PlanCob
                 , P.FecIniVig
              FROM POLIZAS        P
                 , DETALLE_POLIZA D
             WHERE P.CodCia        = nCodCia
               AND P.IdPoliza     != nIdPolizaProc
               AND P.StsPoliza    != 'SOL'
               AND P.NumPolUnico  IN ( SELECT NumPolUnico
                                         FROM POLIZAS
                                        WHERE CodCia    = nCodCia
                                          AND IdPoliza  = nIdPolizaProc )
               AND D.IDetPol       = nIDetPolProc
               AND ( D.MotivAnul IS NULL
                     OR 
                     NVL(D.MotivAnul,'NULL') IS NOT NULL
                     AND
                     D.FecAnul   >= dFecDesde
                     OR
                     P.StsPoliza  = 'ANU'
                     AND
                     P.FecSts    >= dFecDesde )
               AND D.IdPoliza      = P.IdPoliza
               AND D.CodCia        = P.CodCia;
         --
         COMMIT;
         --
      END IF;
      --
      IF NVL(nIdPolizaProcCalc,0) != NVL(nIdPoliza,0) THEN
         nIdPolizaProcCalc    := nIdPoliza;
         nPrimaMonedaTotPol   := 0;
         nPrimaContable       := 0;
         nPrimaContableAnu    := 0;
         nMtoCptoNcrMoneda    := 0;
         nMtoCptoNcrMonedaAnu := 0;

         -- Verifica si Todas Están Anuladas
         cTodasAnuladas := 'N';
         FOR T IN POL_Q LOOP
             IF T.StsPoliza != 'ANU' THEN
                cTodasAnuladas := 'N';
                EXIT;
             ELSE
                cTodasAnuladas := 'S';
             END IF;
         END LOOP;

         cEsDeclarativa := 'N';
         FOR Z IN POL_Q LOOP
            IF Z.TipoAdministracion = 'DECLAR' THEN
               cEsDeclarativa := 'S';
            END IF;
            IF cTodasAnuladas = 'N' THEN
               IF Z.StsPoliza IN ('EMI','REN') THEN
                  cStatus1 := 'CEX';
                  cStatus2 := ' ';
                  cStatus3 := 'EXCLUI';
                  cStatus4 := ' ';
               ELSE
                  cStatus1 := 'CEX';
                  cStatus2 := 'ANU';
                  cStatus3 := 'EXCLUI';
                  cStatus4 := 'ANULAD';
               END IF;

               SELECT NVL(SUM(Prima_Moneda),0) + NVL(nPrimaMonedaTotPol,0)
                 INTO nPrimaMonedaTotPol
                 FROM COBERT_ACT
                WHERE CodCia         = nCodCia
                  AND IdPoliza       = Z.IdPoliza
                  AND StsCobertura NOT IN (cStatus1, cStatus2, cStatus5);

               SELECT NVL(SUM(MontoAsistMoneda),0) + NVL(nPrimaMonedaTotPol,0)
                 INTO nPrimaMonedaTotPol
                 FROM ASISTENCIAS_DETALLE_POLIZA
                WHERE CodCia          = nCodCia
                  AND IdPoliza        = Z.IdPoliza
                  AND StsAsistencia NOT IN (cStatus3, cStatus4, cStatus6);

               SELECT NVL(SUM(Prima_Moneda),0) + NVL(nPrimaMonedaTotPol,0)
                 INTO nPrimaMonedaTotPol
                 FROM COBERT_ACT_ASEG
                WHERE CodCia         = nCodCia
                  AND IdPoliza       = Z.IdPoliza
                  AND StsCobertura NOT IN (cStatus1, cStatus2, cStatus5);

               SELECT NVL(SUM(MontoAsistMoneda),0) + NVL(nPrimaMonedaTotPol,0)
                 INTO nPrimaMonedaTotPol
                 FROM ASISTENCIAS_ASEGURADO
                WHERE CodCia          = nCodCia
                  AND IdPoliza        = Z.IdPoliza
                  AND StsAsistencia NOT IN (cStatus3, cStatus4, cStatus6);
            ELSIF cTodasAnuladas = 'S' AND nIdPolizaProcCalc = Z.IdPoliza THEN
               SELECT NVL(SUM(Prima_Moneda),0) + NVL(nPrimaMonedaTotPol,0)
                 INTO nPrimaMonedaTotPol
                 FROM COBERT_ACT
                WHERE CodCia         = nCodCia
                  AND IdPoliza       = Z.IdPoliza;

               SELECT NVL(SUM(MontoAsistMoneda),0) + NVL(nPrimaMonedaTotPol,0)
                 INTO nPrimaMonedaTotPol
                 FROM ASISTENCIAS_DETALLE_POLIZA
                WHERE CodCia          = nCodCia
                  AND IdPoliza        = Z.IdPoliza;

               SELECT NVL(SUM(Prima_Moneda),0) + NVL(nPrimaMonedaTotPol,0)
                 INTO nPrimaMonedaTotPol
                 FROM COBERT_ACT_ASEG
                WHERE CodCia         = nCodCia
                  AND IdPoliza       = Z.IdPoliza;

               SELECT NVL(SUM(MontoAsistMoneda),0) + NVL(nPrimaMonedaTotPol,0)
                 INTO nPrimaMonedaTotPol
                 FROM ASISTENCIAS_ASEGURADO
                WHERE CodCia          = nCodCia
                  AND IdPoliza        = Z.IdPoliza;
            END IF;
 
             SELECT /*+ INDEX(T SYS_C0032162) */ NVL(SUM(DF.Monto_Det_Moneda), 0) + NVL(nPrimaContable,0)
              INTO nPrimaContable
              FROM DETALLE_FACTURAS DF, FACTURAS F, TRANSACCION T
             WHERE T.FechaTransaccion >= dFecDesde
               AND T.FechaTransaccion <= dFecHasta
               AND T.CodCia            = F.CodCia
               AND T.IdTransaccion     = F.IdTransaccion
               AND F.CodCia            = nCodCia
               AND F.IdPoliza          = Z.IdPoliza
               AND DF.CodCpto         IN ( SELECT CodConcepto 
                                             FROM CATALOGO_DE_CONCEPTOS 
                                            WHERE IndCptoPrimas   = 'S' 
                                               OR IndCptoServicio = 'S'
                                               OR IndCptoFondo    = 'S'
                                            GROUP BY CodConcepto )
               --AND F.Stsfact      NOT IN ('ANU') 
               AND DF.IdFactura        = F.IdFactura;

            SELECT NVL(SUM(DF.Monto_Det_Moneda), 0) + NVL(nPrimaContableAnu,0)
              INTO nPrimaContableAnu
              FROM DETALLE_FACTURAS DF, FACTURAS F
             WHERE F.FecSts           >= dFecDesde
               AND F.FecSts           <= dFecHasta
               AND F.CodCia            = nCodCia
               AND F.IdPoliza          = Z.IdPoliza
               AND DF.CodCpto         IN (SELECT CodConcepto 
                                            FROM CATALOGO_DE_CONCEPTOS 
                                           WHERE IndCptoPrimas   = 'S' 
                                              OR IndCptoServicio = 'S'
                                              OR IndCptoFondo    = 'S')
               AND F.Stsfact          IN ('ANU') 
               AND DF.IdFactura        = F.IdFactura;

            SELECT /*+ INDEX(T SYS_C0032162) */ NVL(SUM(DNC.Monto_Det_Moneda),0) + NVL(nMtoCptoNcrMoneda,0)
              INTO nMtoCptoNcrMoneda
              FROM DETALLE_NOTAS_DE_CREDITO DNC,
                   NOTAS_DE_CREDITO NC, TRANSACCION T
             WHERE T.FechaTransaccion >= dFecDesde
               AND T.FechaTransaccion <= dFecHasta
               AND T.CodCia            = NC.CodCia
               AND T.IdTransaccion     = NC.IdTransaccion
               AND NC.CodCia           = nCodCia
               AND NC.IdPoliza         = Z.IdPoliza
               AND DNC.CodCpto        IN (SELECT CodConcepto 
                                            FROM CATALOGO_DE_CONCEPTOS 
                                           WHERE IndCptoPrimas   = 'S' 
                                              OR IndCptoServicio = 'S'
                                              OR IndCptoFondo    = 'S')
               AND NC.IdNcr            = DNC.IdNcr;

            SELECT NVL(SUM(DNC.Monto_Det_Moneda),0) + NVL(nMtoCptoNcrMonedaAnu,0)
              INTO nMtoCptoNcrMonedaAnu
              FROM DETALLE_NOTAS_DE_CREDITO DNC,
                   NOTAS_DE_CREDITO NC
             WHERE NC.FecSts          >= dFecDesde
               AND NC.FecSts          <= dFecHasta
               AND NC.CodCia           = nCodCia
               AND NC.IdPoliza         = Z.IdPoliza
               AND DNC.CodCpto        IN (SELECT CodConcepto 
                                            FROM CATALOGO_DE_CONCEPTOS 
                                           WHERE IndCptoPrimas   = 'S' 
                                              OR IndCptoServicio = 'S'
                                              OR IndCptoFondo    = 'S')
               AND NC.StsNCR           = 'ANU' 
               AND NC.IdNcr            = DNC.IdNcr;
         END LOOP;
 
         nPrimaContable := (NVL(nPrimaContable,0) - NVL(nPrimaContableAnu,0)) - (NVL(nMtoCptoNcrMoneda,0) - NVL(nMtoCptoNcrMonedaAnu,0));

/*         IF cEsDeclarativa = 'S' AND NVL(nPrimaMonedaTotPol,0) = 0 AND 
            NVL(nPrimaMonedaTotPol,0) != NVL(nPrimaContable,0) THEN
            nPrimaMonedaTotPol := NVL(nPrimaContable,0);
         END IF;*/

         cRecalculoPrimas := 'N';

         IF NVL(nPrimaMonedaTotPol,0) = 0 THEN
            cRecalculoPrimas := 'S';
            FOR Z IN POL_Q LOOP
               nIdPolizaCalc  := Z.IdPoliza;
               nIdTarifa      := GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE(nCodCia, nCodEmpresa, Z.IdTipoSeg, Z.PlanCob, Z.FecIniVig);

               FOR W IN CALC_Q LOOP
                  IF W.Tasa > 0 THEN
                     nPrimaMonedaTotPol := NVL(nPrimaMonedaTotPol,0) + (W.SumaAseg_Moneda * W.Tasa);
                  ELSIF W.CodTarifa IS NULL THEN
                     IF NVL(W.Prima_Cobert,0) != 0 THEN
                        nPrimaMonedaTotPol := NVL(nPrimaMonedaTotPol,0) + NVL(W.Prima_Cobert,0);
                     ELSE
                        nPrimaMonedaTotPol := NVL(nPrimaMonedaTotPol,0) + (W.SumaAseg_Moneda * W.Porc_Tasa / 1000);
                     END IF;
                  ELSE
                     --
                     OPEN c_DatosPersona ( nCodCia, nCodEmpresa, W.Cod_Asegurado );
                     FETCH c_DatosPersona INTO cSexo, dFecNacimiento, cCodActividad;
                     CLOSE c_DatosPersona;
                     --                     
                     IF cSexo IS NULL THEN
                        cSexo := 'M';
                        dFecNacimiento := TRUNC(SYSDATE);
                        cCodActividad := NULL;
                     END IF;
                     --
                     nEdad   := FLOOR((TRUNC(dFecIniVig) - TRUNC(dFecNacimiento)) / 365.25);
                     cRiesgo := OC_ACTIVIDADES_ECONOMICAS.RIESGO_ACTIVIDAD(cCodActividad);
                     --
                     IF nEdad = 0 THEN
                        nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA_EDAD_MINIMA(nCodCia, nCodEmpresa, W.IdTipoSeg, W.PlanCob,
                                                                                    W.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa);
                     ELSE
                        BEGIN
                           nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA(nCodCia, nCodEmpresa, W.IdTipoSeg, W.PlanCob,
                                                                           W.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa);
                        EXCEPTION
                        WHEN OTHERS THEN
                           BEGIN
                              nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA_EDAD_MINIMA(nCodCia, nCodEmpresa, W.IdTipoSeg, W.PlanCob,
                                                                                          W.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa);
                           EXCEPTION
                           WHEN OTHERS THEN
                              RAISE_APPLICATION_ERROR(-20200,SQLERRM);
                           END;
                        END;
                     END IF;
                     nPrimaMonedaTotPol := NVL(nPrimaMonedaTotPol,0) + (W.SumaAseg_Moneda * nTasa / W.FactorTasa);
                  END IF;
               END LOOP;
            END LOOP;
         END IF;

         IF NVL(nPrimaMonedaTotPol,0) = 0 THEN
            nPrimaMonedaTotPol := 1;
         END IF;

         /*IF NVL(nPrimaContable,0) = 0 THEN
            nPrimaContable := nPrimaMonedaTotPol;
         END IF;*/
      END IF;

      FOR Z IN POL_Q LOOP
         IF cTodasAnuladas = 'N' AND nIdPolizaProcCalc = Z.IdPoliza THEN
            nIdTarifa      := GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE(nCodCia, nCodEmpresa, Z.IdTipoSeg, Z.PlanCob, Z.FecIniVig);
            IF Z.StsPoliza IN ('EMI','REN') THEN
               cStatus1 := 'CEX';
               cStatus2 := ' ';
               cStatus3 := 'EXCLUI';
               cStatus4 := ' ';
            ELSE
               cStatus1 := 'CEX';
               cStatus2 := 'ANU';
               cStatus3 := 'EXCLUI';
               cStatus4 := 'ANULAD';
            END IF;
         ELSIF cTodasAnuladas = 'S' AND nIdPolizaProcCalc = Z.IdPoliza THEN
            nIdTarifa      := GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE(nCodCia, nCodEmpresa, Z.IdTipoSeg, Z.PlanCob, Z.FecIniVig);
            cStatus1 := ' ';
            cStatus2 := ' ';
            cStatus3 := ' ';
            cStatus4 := ' ';
         END IF;
      END LOOP;

      FOR W IN COBERT_Q LOOP
         IF cRecalculoPrimas = 'N' THEN
            nPrima_Moneda := NVL(W.Prima_Moneda,0);
         ELSE
            IF NVL(W.Prima_Moneda,0) > 0 THEN
               nPrima_Moneda := NVL(W.Prima_Moneda,0);
            ELSE
               cCodCobert    := W.CodCobert;
               FOR R IN COB_CALC_Q LOOP
                  IF R.Tasa > 0 THEN
                     nPrima_Moneda := R.SumaAseg_Moneda * R.Tasa;
                  ELSIF R.CodTarifa IS NULL THEN
                     IF NVL(R.Prima_Cobert,0) != 0 THEN
                        nPrima_Moneda := NVL(R.Prima_Cobert,0);
                     ELSE
                        nPrima_Moneda := R.SumaAseg_Moneda * R.Porc_Tasa / 1000;
                     END IF;
                  ELSE
                     --
                     OPEN c_DatosPersona ( nCodCia, nCodEmpresa, R.Cod_Asegurado );
                     FETCH c_DatosPersona INTO cSexo, dFecNacimiento, cCodActividad;
                     CLOSE c_DatosPersona;
                     --                     
                     IF cSexo IS NULL THEN
                        cSexo := 'M';
                        dFecNacimiento := TRUNC(SYSDATE);
                        cCodActividad := NULL;
                     END IF;
                     --
                     nEdad   := FLOOR((TRUNC(dFecIniVig) - TRUNC(dFecNacimiento)) / 365.25);
                     cRiesgo := OC_ACTIVIDADES_ECONOMICAS.RIESGO_ACTIVIDAD(cCodActividad);
                     IF nEdad = 0 THEN
                        nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA_EDAD_MINIMA(nCodCia, nCodEmpresa, R.IdTipoSeg, R.PlanCob,
                                                                                    R.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa);
                     ELSE
                        BEGIN
                           nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA(nCodCia, nCodEmpresa, R.IdTipoSeg, R.PlanCob,
                                                                           R.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa);
                        EXCEPTION
                        WHEN OTHERS THEN
                           BEGIN
                              nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA_EDAD_MINIMA(nCodCia, nCodEmpresa, R.IdTipoSeg, R.PlanCob,
                                                                                          R.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa);
                           EXCEPTION
                           WHEN OTHERS THEN
                              RAISE_APPLICATION_ERROR(-20200,SQLERRM);
                           END;
                        END;
                     END IF;
                     nPrima_Moneda      := R.SumaAseg_Moneda * nTasa / R.FactorTasa;
                  END IF;
               END LOOP;
            END IF;
         END IF;
         
         IF W.ClaveSesas = '1' THEN
            nSABenef1  := NVL(nSABenef1,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiBe1 := NVL(nPmaEmiBe1,0) + (NVL(nPrimaContable,0) * (NVL(nPrima_Moneda,0) / NVL(nPrimaMonedaTotPol,0)));
         ELSIF W.ClaveSesas = '2' THEN
            nSABenef2  := NVL(nSABenef2,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiBe2 := NVL(nPmaEmiBe2,0) + (NVL(nPrimaContable,0) * (NVL(nPrima_Moneda,0) / NVL(nPrimaMonedaTotPol,0)));
         ELSIF W.ClaveSesas = '3' THEN
            nSABenef3  := NVL(nSABenef3,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiBe3 := NVL(nPmaEmiBe3,0) + (NVL(nPrimaContable,0) * (NVL(nPrima_Moneda,0) / NVL(nPrimaMonedaTotPol,0)));
         ELSIF W.ClaveSesas = '4' THEN
            nSABenef4  := NVL(nSABenef4,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiBe4 := NVL(nPmaEmiBe4,0) + (NVL(nPrimaContable,0) * (NVL(nPrima_Moneda,0) / NVL(nPrimaMonedaTotPol,0)));
         ELSE
            nSABenef5  := NVL(nSABenef5,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiBe5 := NVL(nPmaEmiBe5,0) + (NVL(nPrimaContable,0) * (NVL(nPrima_Moneda,0) / NVL(nPrimaMonedaTotPol,0)));
         END IF;
         
         IF W.PeriodoEspera > NVL(nPeriodoEspCob,0) THEN
            nPeriodoEspCob := W.PeriodoEspera;
         END IF; 

         IF W.OrdenSESAS = 1 THEN
            nSACober1  := NVL(nSACober1,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo1 := NVL(nPmaEmiCo1,0) + NVL(nPrima_Moneda,0);
         ELSIF W.OrdenSESAS = 2 THEN
            nSACober2  := NVL(nSACober2,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo2 := NVL(nPmaEmiCo2,0) + NVL(nPrima_Moneda,0);
         ELSIF W.OrdenSESAS = 3 THEN
            nSACober3  := NVL(nSACober3,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo3 := NVL(nPmaEmiCo3,0) + NVL(nPrima_Moneda,0);
         ELSIF W.OrdenSESAS = 4 THEN
            nSACober4  := NVL(nSACober4,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo4 := NVL(nPmaEmiCo4,0) + NVL(nPrima_Moneda,0);
         ELSIF W.OrdenSESAS = 5 THEN
            nSACober5  := NVL(nSACober5,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo5 := NVL(nPmaEmiCo5,0) + NVL(nPrima_Moneda,0);
         ELSIF W.OrdenSESAS = 6 THEN
            nSACober6  := NVL(nSACober6,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo6 := NVL(nPmaEmiCo6,0) + NVL(nPrima_Moneda,0);
         ELSIF W.OrdenSESAS = 7 THEN
            nSACober7  := NVL(nSACober7,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo7 := NVL(nPmaEmiCo7,0) + NVL(nPrima_Moneda,0);
         ELSIF W.OrdenSESAS = 8 THEN
            nSACober8  := NVL(nSACober8,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo8 := NVL(nPmaEmiCo8,0) + NVL(nPrima_Moneda,0);
         ELSIF W.OrdenSESAS = 9 THEN
            nSACober9  := NVL(nSACober9,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo9 := NVL(nPmaEmiCo9,0) + NVL(nPrima_Moneda,0);
         ELSIF W.OrdenSESAS = 10 THEN
            nSACober10  := NVL(nSACober10,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo10 := NVL(nPmaEmiCo10,0) + NVL(nPrima_Moneda,0);
         ELSIF W.OrdenSESAS = 11 THEN
            nSACober11  := NVL(nSACober11,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo11 := NVL(nPmaEmiCo11,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 12 THEN
            nSACober12  := NVL(nSACober12,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo12 := NVL(nPmaEmiCo12,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 13 THEN
            nSACober13  := NVL(nSACober13,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo13 := NVL(nPmaEmiCo13,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 14 THEN
            nSACober14  := NVL(nSACober14,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo14 := NVL(nPmaEmiCo14,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 15 THEN
            nSACober15  := NVL(nSACober15,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo15 := NVL(nPmaEmiCo15,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 16 THEN
            nSACober16  := NVL(nSACober16,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo16 := NVL(nPmaEmiCo16,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 17 THEN
            nSACober17  := NVL(nSACober17,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo17 := NVL(nPmaEmiCo17,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 18 THEN
            nSACober18  := NVL(nSACober18,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo18 := NVL(nPmaEmiCo18,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 19 THEN
            nSACober19  := NVL(nSACober19,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo19 := NVL(nPmaEmiCo19,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 20 THEN
            nSACober20  := NVL(nSACober20,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo20 := NVL(nPmaEmiCo20,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 21 THEN
            nSACober21  := NVL(nSACober21,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo21 := NVL(nPmaEmiCo21,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 22 THEN
            nSACober22  := NVL(nSACober22,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo22 := NVL(nPmaEmiCo22,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 23 THEN
            nSACober23  := NVL(nSACober23,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo23 := NVL(nPmaEmiCo23,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 24 THEN
            nSACober24  := NVL(nSACober24,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo24 := NVL(nPmaEmiCo24,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 25 THEN
            nSACober25  := NVL(nSACober25,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo25 := NVL(nPmaEmiCo25,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 26 THEN
            nSACober26  := NVL(nSACober26,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo26 := NVL(nPmaEmiCo26,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 27 THEN
            nSACober27  := NVL(nSACober27,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo27 := NVL(nPmaEmiCo27,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 28 THEN
            nSACober28  := NVL(nSACober28,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo28 := NVL(nPmaEmiCo28,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 29 THEN
            nSACober29  := NVL(nSACober29,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo29 := NVL(nPmaEmiCo29,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 30 THEN
            nSACober30  := NVL(nSACober30,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo30 := NVL(nPmaEmiCo30,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 31 THEN
            nSACober31  := NVL(nSACober31,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo31 := NVL(nPmaEmiCo31,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 32 THEN
            nSACober32  := NVL(nSACober32,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo32 := NVL(nPmaEmiCo32,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 33 THEN
            nSACober33  := NVL(nSACober33,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo33 := NVL(nPmaEmiCo33,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 34 THEN
            nSACober34  := NVL(nSACober34,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo34 := NVL(nPmaEmiCo34,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 35 THEN
            nSACober35  := NVL(nSACober35,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo35 := NVL(nPmaEmiCo35,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 36 THEN
            nSACober36  := NVL(nSACober36,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo36 := NVL(nPmaEmiCo36,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 37 THEN
            nSACober37  := NVL(nSACober37,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo37 := NVL(nPmaEmiCo37,0) + NVL(W.Prima_Moneda,0);
         ELSIF W.OrdenSESAS = 38 THEN
            nSACober38  := NVL(nSACober38,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo38 := NVL(nPmaEmiCo38,0) + NVL(W.Prima_Moneda,0);
         ELSE
            nSACober38  := NVL(nSACober38,0) + NVL(W.Suma_Moneda,0);
            nPmaEmiCo38 := NVL(nPmaEmiCo38,0) + NVL(W.Prima_Moneda,0);
         END IF;
      END LOOP;
      -- nPmaEmiBe1 := nPmaEmiBe1 + OC_DETALLE_FACTURAS.MONTO_SERVICIOS(nCodCia, nIdPoliza, nIDetPol);
      IF cTipoDetalle = 'IND' THEN
         --
         SELECT (NVL(nPrimaContable,0) * (NVL(SUM(MontoAsistLocal),0) / NVL(nPrimaMonedaTotPol,0))) + nPmaEmiBe1
              , NVL(SUM(MontoAsistLocal),0) + NVL(nPmaEmiCo1,0)
           INTO nPmaEmiBe1, nPmaEmiCo1
           FROM ASISTENCIAS_DETALLE_POLIZA
          WHERE CodCia         = nCodCia
            AND CodEmpresa     = nCodEmpresa
            AND IdPoliza       = nIdPoliza
            AND IDetPol        = nIDetPol
            AND StsAsistencia NOT IN (cStatus3, cStatus4, cStatus6);
         --
      ELSE
         --
         SELECT (NVL(nPrimaContable,0) * (NVL(SUM(MontoAsistLocal),0) / NVL(nPrimaMonedaTotPol,0))) + nPmaEmiBe1
              , NVL(SUM(MontoAsistLocal),0) + NVL(nPmaEmiCo1,0)
           INTO nPmaEmiBe1, nPmaEmiCo1
           FROM ASISTENCIAS_ASEGURADO
          WHERE CodCia         = nCodCia
            AND CodEmpresa     = nCodEmpresa
            AND IdPoliza       = nIdPoliza
            AND IDetPol        = nIDetPol
            AND Cod_Asegurado  = nCod_Asegurado
            AND StsAsistencia NOT IN (cStatus3, cStatus4, cStatus6);
         --
      END IF;
   END COBERTURAS;

   PROCEDURE INSERTA_REGISTRO(nIdPoliza NUMBER, nIDetPol NUMBER, cIdTipoSeg VARCHAR2, cCodPais VARCHAR2, 
                              cCodEstado VARCHAR2, cStsPoliza VARCHAR2, dFecFinVigPol DATE, cStsDetalle VARCHAR2,
                              dFecFinVig DATE, cTipoDetallePol VARCHAR2, cPoliza VARCHAR2, nCod_Asegurado NUMBER,
                              cPolConcentrada VARCHAR2, cIndAsegModelo VARCHAR2, nCantAsegModelo NUMBER,
                              cCerti VARCHAR2, cMoneda VARCHAR2, cIni_Vig VARCHAR2,
                              cFin_Vig VARCHAR2, cFecha_Alta VARCHAR2, cFecha_Baja VARCHAR2, cFecha_Nac VARCHAR2, 
                              cSexo VARCHAR2, cForma_Vta VARCHAR2, cTipoDividendo VARCHAR2, nMontoDividendo NUMBER,
                              nAnioPoliza NUMBER,  dFecIniVig DATE, nCantAseg_1 NUMBER, nCantAseg_2  NUMBER, cCodEntrega VARCHAR2 ) IS
   BEGIN
      nContadorReg := nContadorReg + 1;
      IF nContadorReg > 5000 THEN
         COMMIT;
         nContadorReg := 1;
      END IF;

      -- Lee Datos de SESAS
      BEGIN
         SELECT NVL(InicioCobertura,2), NVL(SubTipoSeg,'1'),
                NVL(MaxDiasBenef3,0), NVL(TipoRiesgo,'1'), 
                0 MtoFondoAdmin, 0 MtoVencimiento, 0 MtoRescate, 
                NVL(ModalPoliza,'1') ModalPoliza, 0 SldoFondoInv, 
                NVL(TipoRiesgoAsoc,'1') TipoRiesgoAsoc, TipoSeguro
           INTO nIniCob, cSubTipoSeg, nMaxDiasBenef3, cTipoRiesgo, 
                nMtoFondoAdmin, nMtoVencimiento, nMtoRescate, 
                cModalPoliza, nSldoFondoInv, cTipoRiesgoAsoc, cTipo_Seg
           FROM CONFIG_SESAS_TIPO_SEGURO
          WHERE CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND IdTipoSeg  = cIdTipoSeg;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nIniCob          := 2;
         cSubTipoSeg      := NULL;
         nMaxDiasBenef3   := 0;
         cModalPoliza     := NULL;
         cTipoRiesgoAsoc  := NULL;
         cTipo_Seg        := NULL;
         nMtoFondoAdmin   := 0;
         nMtoVencimiento  := 0;
         nMtoRescate      := 0;
         nSldoFondoInv    := 0;
      END;

      IF cCodPais = '001' THEN
        IF TO_NUMBER(cCodEstado) BETWEEN 1 AND 32 THEN
           cEntDd_Ctte := TRIM(TO_CHAR(TO_NUMBER(cCodEstado),'00'));
        ELSE
           cEntDd_Ctte := '34';
        END IF;
      ELSIF cCodPais != '001' THEN
         cEntDd_Ctte := '33';
      ELSE
         cEntDd_Ctte := '34'; --'99';
      END IF;

      -- Status de la Poliza
      IF cStsPoliza = 'EMI' THEN
         cPoliz_Stus := '1'; -- En Vigor
         IF dFecFinVigPol <= dFecHasta THEN
            cPoliz_Stus := '2'; -- Expirada o Terminada
         END IF;
      ELSIF cStsPoliza = 'ANU' THEN
         cPoliz_Stus := '3'; -- Cancelada
         IF OC_SINIESTRO.TIENE_SINIESTRO(nCodCia, nIdPoliza, nIDetPol, dFecDesde) = 'S' THEN
            cPoliz_Stus := '4'; -- Baja por muerte, invalidez o incapacidad
         END IF;
      ELSIF cStsPoliza = 'RES' THEN
         cPoliz_Stus := '5'; -- Rescatas
      ELSIF cStsPoliza = 'SAL' THEN
         cPoliz_Stus := '6'; -- Saldada
      ELSIF cStsPoliza = 'PRO' THEN
         cPoliz_Stus := '7'; -- Prorrogada
      ELSIF dFecFinVigPol <= dFecHasta THEN
         cPoliz_Stus := '2'; -- Expirada o Terminada
      END IF;

      -- Status del Certificado
      IF cStsDetalle = 'EMI' THEN
         cCerti_Stus := '1'; -- En Vigor
         IF dFecFinVig <= dFecHasta THEN
            cCerti_Stus := '2'; -- Expirada o Terminada
         END IF;
      ELSIF cStsDetalle IN ('ANU','EXC') THEN
         cCerti_Stus := '3'; -- Cancelada
         IF OC_SINIESTRO.TIENE_SINIESTRO(nCodCia, nIdPoliza, nIDetPol, dFecDesde) = 'S' THEN
            cCerti_Stus := '4'; -- Baja por muerte, invalidez o incapacidad
         END IF;
      ELSIF cStsDetalle = 'RES' THEN
         cCerti_Stus := '5'; -- Rescatas
      ELSIF cStsDetalle = 'SAL' THEN
         cCerti_Stus := '6'; -- Saldada
      ELSIF cStsDetalle = 'PRO' THEN
         cCerti_Stus := '7'; -- Prorrogada
      ELSIF dFecFinVig <= dFecHasta THEN
         cCerti_Stus := '2'; -- Expirada o Terminada
      END IF;

      cTipoDetalle   := cTipoDetallePol;
      nIdPolizaProc  := nIdPoliza;
      nIDetPolProc   := nIDetPol;
      COBERTURAS (nCodCia, nIdPoliza, nIDetPol, nCod_Asegurado, dFecIniVig);

      IF cPolConcentrada = 1 THEN
         IF cIndAsegModelo = 'S' THEN
            nCantCert := nCantAseg_1;
         ELSE
            nCantCert := nCantAseg_2;
         END IF;
      ELSIF cIndAsegModelo = 'S' THEN
         nCantCert := NVL(nCantAsegModelo,0);
      ELSE
         nCantCert := 1;
      END IF;

      IF dFecFinVig > dFecHasta THEN
         nIniCob  := 1;
      ELSIF dFecFinVig <= dFecHasta THEN
         nIniCob  := 2;
      END IF;

      cCadena := cPoliza                        || cSeparador ||
                 cCerti                         || cSeparador ||
                 cTipo_Seg                      || cSeparador ||
                 cMoneda                        || cSeparador ||
                 cIni_Vig                       || cSeparador ||
                 cFin_Vig                       || cSeparador ||
                 cFecha_Alta                    || cSeparador ||
                 cFecha_Baja                    || cSeparador ||
                 cFecha_Nac                     || cSeparador ||
                 cSexo                          || cSeparador ||
                 cPoliz_Stus                    || cSeparador ||
                 cCerti_Stus                    || cSeparador ||
                 cForma_Vta                     || cSeparador ||
                 cEntDd_Ctte                    || cSeparador ||
                 TRIM(TO_CHAR(nPeriodoEspCob))  || cSeparador ||
                 REPLACE(TRIM(TO_CHAR(nSABenef1,'999999999999999999')),'.',NULL)   || cSeparador ||
                 REPLACE(TRIM(TO_CHAR(nSABenef2,'999999999999999999')),'.',NULL)   || cSeparador ||
                 REPLACE(TRIM(TO_CHAR(nSABenef3,'999999999999999999')),'.',NULL)   || cSeparador ||
                 REPLACE(TRIM(TO_CHAR(nSABenef4,'999999999999999999')),'.',NULL)   || cSeparador ||
                 REPLACE(TRIM(TO_CHAR(nSABenef5,'999999999999999999')),'.',NULL)   || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiBe1,'9999999999999.99'))                      || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiBe2,'9999999999999.99'))                      || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiBe3,'9999999999999.99'))                      || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiBe4,'9999999999999.99'))                      || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiBe5,'9999999999999.99'))                      || cSeparador ||
                 cTipoDividendo                 || cSeparador ||
                 REPLACE(TRIM(TO_CHAR(nMontoDividendo,'9999999999999.99')),'.',NULL) || cSeparador ||
                 TRIM(TO_CHAR(nAnioPoliza))     || cSeparador ||
                 TRIM(TO_CHAR(nIniCob))         || cSeparador ||
                 TRIM(TO_CHAR(nMaxDiasBenef3))  || cSeparador ||
                 cSubTipoSeg                    || cSeparador ||
                 cTipoRiesgo                    || cSeparador ||
                 cPolConcentrada                || cSeparador ||
                 TRIM(TO_CHAR(nCantCert))       || cSeparador ||
                 cPuntoComa                     || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo1,'9999999999999.99'))  || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo2,'9999999999999.99'))  || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo3,'9999999999999.99'))  || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo4,'9999999999999.99'))  || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo5,'9999999999999.99'))  || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo6,'9999999999999.99'))  || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo7,'9999999999999.99'))  || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo8,'9999999999999.99'))  || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo9,'9999999999999.99'))  || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo10,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo11,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo12,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo13,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo14,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo15,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo16,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo17,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo18,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo19,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo20,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo21,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo22,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo23,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo24,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo25,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo26,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo27,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo28,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo29,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo30,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo31,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo32,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo33,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo34,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo35,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo36,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo37,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nPmaEmiCo38,'9999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober1,'9999999999999999.99'))  || cSeparador ||
                 TRIM(TO_CHAR(nSACober2,'9999999999999999.99'))  || cSeparador ||
                 TRIM(TO_CHAR(nSACober3,'9999999999999999.99'))  || cSeparador ||
                 TRIM(TO_CHAR(nSACober4,'9999999999999999.99'))  || cSeparador ||
                 TRIM(TO_CHAR(nSACober5,'9999999999999999.99'))  || cSeparador ||
                 TRIM(TO_CHAR(nSACober6,'9999999999999999.99'))  || cSeparador ||
                 TRIM(TO_CHAR(nSACober7,'9999999999999999.99'))  || cSeparador ||
                 TRIM(TO_CHAR(nSACober8,'9999999999999999.99'))  || cSeparador ||
                 TRIM(TO_CHAR(nSACober9,'9999999999999999.99'))  || cSeparador ||
                 TRIM(TO_CHAR(nSACober10,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober11,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober12,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober13,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober14,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober15,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober16,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober17,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober18,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober19,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober20,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober21,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober22,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober23,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober24,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober25,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober26,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober27,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober28,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober29,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober30,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober31,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober32,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober33,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober34,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober35,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober36,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober37,'9999999999999999.99')) || cSeparador ||
                 TRIM(TO_CHAR(nSACober38,'9999999999999999.99')) || cSeparador;
      --
      OC_REPORTES_THONA.INSERTAR_REGISTRO( nCodCia, nCodEmpresa, cCodEntrega, cIdUsr, cCadena );
      --
   END INSERTA_REGISTRO;
BEGIN
   -- Elimina Registros de SESAS
   DELETE TEMP_REPORTES_THONA
   WHERE  CodCia     = nCodCia
     AND  CodEmpresa = nCodEmpresa
     AND  CodReporte = cCodEntrega
     AND  CodUsuario = cIdUsr;
   --
   COMMIT;
   --
   cCodPlantilla := OC_ENTREGAS_CNSF_CONFIG.PLANTILLA(nCodCia, nCodEmpresa, cCodEntrega);
   cSeparador    := OC_ENTREGAS_CNSF_CONFIG.SEPARADOR(nCodCia, nCodEmpresa, cCodEntrega);
   nContadorReg  := 0;
   --
   --Inicializo variables de Afinación
   nCodCiaAfina     := 0;
   nCodEmpresaAfina := 0;
   nIdPolizaAfina   := 0;
   nIDetPolAfina    := 0;
   nCantAseg_1      := 0;
   nCantAseg_2      := 0; 
   --
   FOR I IN  C_CAMPO  LOOP
      cEncabezado := cEncabezado||I.NomCampo ||cSeparador;
   END LOOP;
   --
   cEncabezado := cEncabezado     ||
                  'Prima Cob. 1'  ||cSeparador || 'Prima Cob. 2'  ||cSeparador ||
                  'Prima Cob. 3'  ||cSeparador || 'Prima Cob. 4'  ||cSeparador ||
                  'Prima Cob. 5'  ||cSeparador || 'Prima Cob. 6'  ||cSeparador ||
                  'Prima Cob. 7'  ||cSeparador || 'Prima Cob. 8'  ||cSeparador ||
                  'Prima Cob. 9'  ||cSeparador || 'Prima Cob. 10' ||cSeparador ||
                  'Prima Cob. 11' ||cSeparador || 'Prima Cob. 12' ||cSeparador ||
                  'Prima Cob. 13' ||cSeparador || 'Prima Cob. 14' ||cSeparador ||
                  'Prima Cob. 15' ||cSeparador || 'Prima Cob. 16' ||cSeparador ||
                  'Prima Cob. 17' ||cSeparador || 'Prima Cob. 18' ||cSeparador ||
                  'Prima Cob. 19' ||cSeparador || 'Prima Cob. 20' ||cSeparador ||
                  'Prima Cob. 21' ||cSeparador || 'Prima Cob. 22' ||cSeparador ||
                  'Prima Cob. 23' ||cSeparador || 'Prima Cob. 24' ||cSeparador ||
                  'Prima Cob. 25' ||cSeparador || 'Prima Cob. 26' ||cSeparador ||
                  'Prima Cob. 27' ||cSeparador || 'Prima Cob. 28' ||cSeparador ||
                  'Prima Cob. 29' ||cSeparador || 'Prima Cob. 30' ||cSeparador ||
                  'Prima Cob. 31' ||cSeparador || 'Prima Cob. 32' ||cSeparador ||
                  'Prima Cob. 33' ||cSeparador || 'Prima Cob. 34' ||cSeparador ||
                  'Prima Cob. 35' ||cSeparador || 'Prima Cob. 36' ||cSeparador ||
                  'Prima Cob. 37' ||cSeparador || 'Prima Cob. 38' ||cSeparador ||
                  'SA Cob. 1'     ||cSeparador || 'SA Cob. 2'     ||cSeparador ||
                  'SA Cob.3'      ||cSeparador || 'SA Cob. 4'     ||cSeparador ||
                  'SA Cob. 5'     ||cSeparador || 'SA Cob. 6'     ||cSeparador ||
                  'SA Cob. 7'     ||cSeparador || 'SA Cob. 8'     ||cSeparador ||
                  'SA Cob. 9'     ||cSeparador || 'SA Cob. 10'    ||cSeparador ||
                  'SA Cob. 11'    ||cSeparador || 'SA Cob. 12'    ||cSeparador ||
                  'SA Cob. 13'    ||cSeparador || 'SA Cob. 14'    ||cSeparador ||
                  'SA Cob. 15'    ||cSeparador || 'SA Cob. 16'    ||cSeparador ||
                  'SA Cob. 17'    ||cSeparador || 'SA Cob. 18'    ||cSeparador ||
                  'SA Cob. 19'    ||cSeparador || 'SA Cob. 20'    ||cSeparador ||
                  'SA Cob. 21'    ||cSeparador || 'SA Cob. 22'    ||cSeparador ||
                  'SA Cob. 23'    ||cSeparador || 'SA Cob. 24'    ||cSeparador ||
                  'SA Cob. 25'    ||cSeparador || 'SA Cob. 26'    ||cSeparador ||
                  'SA Cob. 27'    ||cSeparador || 'SA Cob. 28'    ||cSeparador ||
                  'SA Cob. 29'    ||cSeparador || 'SA Cob. 30'    ||cSeparador ||
                  'SA Cob. 31'    ||cSeparador || 'SA Cob. 32'    ||cSeparador ||
                  'SA Cob. 33'    ||cSeparador || 'SA Cob. 34'    ||cSeparador ||
                  'SA Cob. 35'    ||cSeparador || 'SA Cob. 36'    ||cSeparador ||
                  'SA Cob. 37'    ||cSeparador || 'SA Cob. 38'    ||cSeparador;

   nLinea  := 1;
   cCadena := SUBSTR(cEncabezado,1,LENGTH(cEncabezado)-1);
   --
   OC_REPORTES_THONA.INSERTAR_REGISTRO( nCodCia, nCodEmpresa, cCodEntrega, cIdUsr, cCadena );
   --
   DELETE TEMP_POLIZAS_SESAS;
   COMMIT;
   --
   FOR W IN POL_IND_Q LOOP
      --Afinación
      IF nCodCiaAfina <> nCodCia OR nCodEmpresaAfina <> nCodEmpresa OR nIdPolizaAfina <> W.IdPoliza OR nIDetPolAfina <> W.IDetPol THEN
         nCodCiaAfina     := nCodCia;
         nCodEmpresaAfina := nCodEmpresa;
         nIdPolizaAfina   := W.IdPoliza;
         nIDetPolAfina    := W.IDetPol;
         --
         nCantAseg_1      := OC_DETALLE_POLIZA.TOTAL_ASEGURADOS(nCodCia, nCodEmpresa, W.IdPoliza, W.IDetPol);
         nCantAseg_2      := nCantAseg_1; 
         --
         SELECT nCantAseg_1 - (COUNT(*) - 1)
           INTO nCantAseg_1
           FROM ASEGURADO_CERTIFICADO
          WHERE IdPoliza   = W.IdPoliza
            AND IDetPol    = W.IDetPol
            AND CodCia     = nCodCia
            AND Estado    IN ('SOL','XRE','EMI');
      END IF;
      --
      INSERTA_REGISTRO(W.IdPoliza, W.IDetPol, W.IdTipoSeg, W.CodPais, W.CodEstado, 
                       W.StsPoliza, W.FecFinVigPol, W.StsDetalle, W.FecFinVig,
                       W.TipoDetalle, W.Poliza, W.Cod_Asegurado, W.PolConcentrada,
                       W.IndAsegModelo, W.CantAsegModelo, W.Certi, 
                       W.Moneda, W.Ini_Vig, W.Fin_Vig, W.Fecha_Alta, W.Fecha_Baja,
                       W.Fecha_Nac, W.Sexo, W.Forma_Vta, W.TipoDividendo, W.MontoDividendo,
                       W.AnioPoliza, W.FecIniVig, nCantAseg_1, nCantAseg_2, cCodEntrega );
   END LOOP;
   --
   DELETE TEMP_POLIZAS_SESAS
   COMMIT;
   --
   --Inicializo variables de Afinación
   nCodCiaAfina     := 0;
   nCodEmpresaAfina := 0;
   nIdPolizaAfina   := 0;
   nIDetPolAfina    := 0;
   nCantAseg_1      := 0;
   nCantAseg_2      := 0; 
   --
   FOR W IN POL_COL_Q LOOP
      --Afinación
      IF nCodCiaAfina <> nCodCia OR nCodEmpresaAfina <> nCodEmpresa OR nIdPolizaAfina <> W.IdPoliza OR nIDetPolAfina <> W.IDetPol THEN
         nCodCiaAfina     := nCodCia;
         nCodEmpresaAfina := nCodEmpresa;
         nIdPolizaAfina   := W.IdPoliza;
         nIDetPolAfina    := W.IDetPol;
         --
         nCantAseg_1      := OC_DETALLE_POLIZA.TOTAL_ASEGURADOS(nCodCia, nCodEmpresa, W.IdPoliza, W.IDetPol);
         nCantAseg_2      := nCantAseg_1; 
         --
         SELECT nCantAseg_1 - (COUNT(*) - 1)
           INTO nCantAseg_1
           FROM ASEGURADO_CERTIFICADO
          WHERE IdPoliza   = W.IdPoliza
            AND IDetPol    = W.IDetPol
            AND CodCia     = nCodCia
            AND Estado    IN ('SOL','XRE','EMI');
      END IF;
      --
      INSERTA_REGISTRO(W.IdPoliza, W.IDetPol, W.IdTipoSeg, W.CodPais, W.CodEstado, 
                       W.StsPoliza, W.FecFinVigPol, W.StsDetalle, W.FecFinVig,
                       W.TipoDetalle, W.Poliza, W.Cod_Asegurado, W.PolConcentrada,
                       W.IndAsegModelo, W.CantAsegModelo, W.Certi,
                       W.Moneda, W.Ini_Vig, W.Fin_Vig, W.Fecha_Alta, W.Fecha_Baja,
                       W.Fecha_Nac, W.Sexo, W.Forma_Vta, W.TipoDividendo, W.MontoDividendo,
                       W.AnioPoliza, W.FecIniVig, nCantAseg_1, nCantAseg_2, cCodEntrega );
   END LOOP;
   --
   DELETE TEMP_POLIZAS_SESAS
   COMMIT;
   --
   --Inicializo variables de Afinación
   nCodCiaAfina     := 0;
   nCodEmpresaAfina := 0;
   nIdPolizaAfina   := 0;
   nIDetPolAfina    := 0;
   nCantAseg_1      := 0;
   nCantAseg_2      := 0; 
   --
   FOR W IN POL_IND_MOV_Q LOOP
      --Afinación
      IF nCodCiaAfina <> nCodCia OR nCodEmpresaAfina <> nCodEmpresa OR nIdPolizaAfina <> W.IdPoliza OR nIDetPolAfina <> W.IDetPol THEN
         nCodCiaAfina     := nCodCia;
         nCodEmpresaAfina := nCodEmpresa;
         nIdPolizaAfina   := W.IdPoliza;
         nIDetPolAfina    := W.IDetPol;
         --
         nCantAseg_1      := OC_DETALLE_POLIZA.TOTAL_ASEGURADOS(nCodCia, nCodEmpresa, W.IdPoliza, W.IDetPol);
         nCantAseg_2      := nCantAseg_1; 
         --
         SELECT nCantAseg_1 - (COUNT(*) - 1)
           INTO nCantAseg_1
           FROM ASEGURADO_CERTIFICADO
          WHERE IdPoliza   = W.IdPoliza
            AND IDetPol    = W.IDetPol
            AND CodCia     = nCodCia
            AND Estado    IN ('SOL','XRE','EMI');
      END IF;
      --
      INSERTA_REGISTRO(W.IdPoliza, W.IDetPol, W.IdTipoSeg, W.CodPais, W.CodEstado, 
                       W.StsPoliza, W.FecFinVigPol, W.StsDetalle, W.FecFinVig,
                       W.TipoDetalle, W.Poliza, W.Cod_Asegurado, W.PolConcentrada,
                       W.IndAsegModelo, W.CantAsegModelo, W.Certi, 
                       W.Moneda, W.Ini_Vig, W.Fin_Vig, W.Fecha_Alta, W.Fecha_Baja,
                       W.Fecha_Nac, W.Sexo, W.Forma_Vta, W.TipoDividendo, W.MontoDividendo,
                       W.AnioPoliza, W.FecIniVig, nCantAseg_1, nCantAseg_2, cCodEntrega );
   END LOOP;
   --
   DELETE TEMP_POLIZAS_SESAS
   COMMIT;
   --
   --Inicializo variables de Afinación
   nCodCiaAfina     := 0;
   nCodEmpresaAfina := 0;
   nIdPolizaAfina   := 0;
   nIDetPolAfina    := 0;
   nCantAseg_1      := 0;
   nCantAseg_2      := 0; 
   --
   FOR W IN POL_COL_MOV_Q LOOP
      --Afinación
      IF nCodCiaAfina <> nCodCia OR nCodEmpresaAfina <> nCodEmpresa OR nIdPolizaAfina <> W.IdPoliza OR nIDetPolAfina <> W.IDetPol THEN
         nCodCiaAfina     := nCodCia;
         nCodEmpresaAfina := nCodEmpresa;
         nIdPolizaAfina   := W.IdPoliza;
         nIDetPolAfina    := W.IDetPol;
         --
         nCantAseg_1      := OC_DETALLE_POLIZA.TOTAL_ASEGURADOS(nCodCia, nCodEmpresa, W.IdPoliza, W.IDetPol);
         nCantAseg_2      := nCantAseg_1; 
         --
         SELECT nCantAseg_1 - (COUNT(*) - 1)
           INTO nCantAseg_1
           FROM ASEGURADO_CERTIFICADO
          WHERE IdPoliza   = W.IdPoliza
            AND IDetPol    = W.IDetPol
            AND CodCia     = nCodCia
            AND Estado    IN ('SOL','XRE','EMI');
      END IF;
      --
      INSERTA_REGISTRO(W.IdPoliza, W.IDetPol, W.IdTipoSeg, W.CodPais, W.CodEstado, 
                       W.StsPoliza, W.FecFinVigPol, W.StsDetalle, W.FecFinVig,
                       W.TipoDetalle, W.Poliza, W.Cod_Asegurado, W.PolConcentrada,
                       W.IndAsegModelo, W.CantAsegModelo, W.Certi, 
                       W.Moneda, W.Ini_Vig, W.Fin_Vig, W.Fecha_Alta, W.Fecha_Baja,
                       W.Fecha_Nac, W.Sexo, W.Forma_Vta, W.TipoDividendo, W.MontoDividendo,
                       W.AnioPoliza, W.FecIniVig, nCantAseg_1, nCantAseg_2, cCodEntrega );
   END LOOP;
   COMMIT;
   --
   cNomArchivo := OC_ENTREGAS_CNSF_CONFIG.NOMBRE_ARCHIVO(nCodCia, nCodEmpresa, cCodEntrega);
   cNomArchZip := SUBSTR(cNomArchivo, 1, INSTR(cNomArchivo, '.')-1) || '.zip';
   --
   OC_REPORTES_THONA.GENERA_REPORTE( nCodCia, nCodEmpresa, cCodEntrega, cIdUsr, cNomArchivo, cNomArchZip );
   OC_REPORTES_THONA.COPIA_ARCHIVO_BLOB( nCodCia, nCodEmpresa, cCodEntrega, cIdUsr, cNomArchZip );
   --
EXCEPTION
WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20200,SQLERRM);
END SESASEMISIONAPCOL;
/
