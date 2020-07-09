--
-- OC_NOTAS_DE_CREDITO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_OUTPUT (Synonym)
--   DBMS_STANDARD (Package)
--   VALORES_DE_LISTAS (Table)
--   NOTAS_DE_CREDITO (Table)
--   OC_AGENTES (Package)
--   OC_ARCHIVO (Package)
--   SUB_PROCESO (Table)
--   PLAN_DE_PAGOS (Table)
--   POLIZAS (Table)
--   PROC_TAREA (Table)
--   OC_DETALLE_TRANSACCION (Package)
--   OC_DISTRITO (Package)
--   OC_EJECUTIVO_COMERCIAL (Package)
--   OC_EMPRESAS (Package)
--   OC_FACTURAS (Package)
--   OC_FACT_ELECT_CONF_DOCTO (Package)
--   OC_FACT_ELECT_DETALLE_TIMBRE (Package)
--   CONCEPTOS_PLAN_DE_PAGOS (Table)
--   CORREOS_ELECTRONICOS_PNJ (Table)
--   DETALLE_FACTURAS (Table)
--   DETALLE_NOTAS_DE_CREDITO (Table)
--   OC_TRANSACCION (Package)
--   PARAMETROS_EMISION (Table)
--   PARAMETROS_ENUM_NOT_CRE (Table)
--   PARAMETROS_GLOBALES (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--   AGENTES (Table)
--   AGENTES_DETALLES_POLIZAS (Table)
--   ASEGURADO (Table)
--   ASEGURADO_CERTIFICADO (Table)
--   ASISTENCIAS (Table)
--   ASISTENCIAS_ASEGURADO (Table)
--   ASISTENCIAS_DETALLE_POLIZA (Table)
--   PROVINCIA (Table)
--   OC_CORREOS_ELECTRONICOS_PNJ (Package)
--   OC_DETALLE_NOTAS_DE_CREDITO (Package)
--   CATALOGO_DE_CONCEPTOS (Table)
--   CLIENTES (Table)
--   COBERTURAS (Table)
--   COBERTURAS_DE_SEGUROS (Table)
--   COBERTURA_ASEG (Table)
--   COBERT_ACT (Table)
--   COLONIA (Table)
--   COMISIONES (Table)
--   OC_GENERALES (Package)
--   OC_MONEDA (Package)
--   OC_PLAN_DE_PAGOS (Package)
--   OC_CLIENTES (Package)
--   OC_COLONIA (Package)
--   OC_COMISIONES (Package)
--   OC_COMPROBANTES_CONTABLES (Package)
--   OC_CONCEPTOS_PLAN_DE_PAGOS (Package)
--   DETALLE_POLIZA (Table)
--   DIRECCIONES_PNJ (Table)
--   DISTRITO (Table)
--   EMPRESAS (Table)
--   ENDOSOS (Table)
--   FACTURAS (Table)
--   OC_PROVINCIA (Package)
--   TIPO_DE_DOCUMENTO (Table)
--   TRANSACCION (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_NOTAS_DE_CREDITO IS

FUNCTION F_GET_NTCRE ( p_msg_regreso    out  nocopy varchar2 ) RETURN NUMBER; --SEQ XDS 20160727
  
FUNCTION INSERTA_NOTA_CREDITO(nCodCia         NUMBER,    nIdPoliza      NUMBER,    nIDetPol            NUMBER, 
                              nIdEndoso       NUMBER,    nCodCliente    NUMBER,    dFecNcr             DATE, 
                              nMtoNcrLocal    NUMBER,    nMtoNcrMoneda  NUMBER,    nMtoComisLocal      NUMBER, 
                              nMtoComisMoneda NUMBER,    nCodAgente     NUMBER,    cCodMoneda          VARCHAR2, 
                              nTasaCambio     NUMBER,    nIdTransaccion NUMBER,    cIndFactElectronica VARCHAR2) RETURN NUMBER;

PROCEDURE ACTUALIZA_NOTA(nIdNcr NUMBER);

PROCEDURE EMITIR(nIdNcr NUMBER, cNumNcr VARCHAR2);

PROCEDURE ANULAR(nIdNcr NUMBER, dFecAnul DATE, cMotivAnul VARCHAR2, nIdTransaccion NUMBER);

PROCEDURE EMITIR_NOTA_CREDITO(nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER, nIdTransaccion NUMBER);

FUNCTION FUNC_CALCULO_PRORRATA (dFecIniVig DATE ,dFecFinVig DATE ,dFecExc DATE,nPrimaA NUMBER) RETURN NUMBER;

PROCEDURE PAGAR(nCodCia NUMBER, nIdNcr NUMBER, dFecPago DATE);

PROCEDURE APLICAR(nCodCia   NUMBER,    nCodEmpresa   NUMBER,      nIdnCR         NUMBER, 
                  dFecAplic DATE,      cNumReciboRef VARCHAR2,    nIdTransaccion NUMBER);

PROCEDURE ARCHIVO_CLIENTES_FACT_ELECT(nCodCia NUMBER, dFecDesde DATE, dFecHasta DATE);

PROCEDURE ARCHIVO_NC_FACT_ELECT(nCodCia NUMBER, nIdNcr NUMBER, nLinea IN OUT NUMBER);

PROCEDURE ARCHIVO_FACT_ELECT_ANUL_NC(nCodCia NUMBER, nIdNcr NUMBER, nLinea IN OUT NUMBER);

FUNCTION FRECUENCIA_PAGO(nCodCia NUMBER, nIdNcr NUMBER) RETURN VARCHAR2;

FUNCTION CODIGO_PLAN_PAGOS(nCodCia NUMBER, nIdNcr NUMBER) RETURN VARCHAR2;

PROCEDURE REHABILITACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdNcrAnu NUMBER, nIdTransaccion NUMBER);

FUNCTION VIGENCIA_FINAL(nCodCia        NUMBER,   nCodEmpresa    NUMBER,  nIdPoliza      NUMBER, 
                        nIdEndoso      NUMBER,   dFecDevol      DATE,    dFecFinVigPol  DATE,    
                        cCodPlanPago   VARCHAR2) RETURN DATE;

PROCEDURE REVERTIR_APLICACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdnCR NUMBER);
  
FUNCTION FACTURA_ELECTRONICA(nIdNcr    NUMBER,   nCodCia       NUMBER,   nCodEmpresa  NUMBER, 
                             cTipoCfdi VARCHAR2, cIndRelaciona VARCHAR2 DEFAULT NULL) RETURN VARCHAR2;

END OC_NOTAS_DE_CREDITO;
/

--
-- OC_NOTAS_DE_CREDITO  (Package Body) 
--
--  Dependencies: 
--   OC_NOTAS_DE_CREDITO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_NOTAS_DE_CREDITO IS
--
-- MODIFICACIONES
-- CALCULO Y REGISTRO DEL FIN DE VIGENCIA DE RECIBOS Y NOTAS DE CREDITO      2018/03/09  ICOFINVIG
-- CALCULO DEL AÑO POLIZA DE RECIBOS Y NOTAS DE CREDITO                      2019/03/27  ICO LARPLA
--
p_msg_regreso varchar2(50);----var XDS 
--------------------------------------------------------------------
  --- Funcion para buscar el proximo numero de Nota de Credito ---
--------------------------------------------------------------------
 FUNCTION F_GET_NTCRE ( p_msg_regreso    out  nocopy varchar2 ) RETURN NUMBER AS
  
    
      vNumNTCRE       parametros_enum_not_cre.paen_cont_fin%type;
      vNombreTabla    varchar2(30);
      vIdProducto     number(6); 
      
   
   BEGIN
    -- Buscar el nombre de la tabla de la cual se obtendra por la descripcion y la bandera
      select pa.pame_ds_numerador,
             pa.paem_id_producto 
        into vNombreTabla,
             vIdProducto
        from PARAMETROS_EMISION pa
       where pa.paem_cd_producto   =  2
         and pa.paem_des_producto  = 'NOTAS_CREDITO'
         and pa.paem_flag          =  1;

    -- Obtener el numero de nota de credito
   
     select pnt.paen_cont_fin
       into vNumNTCRE
       from parametros_enum_not_cre pnt
      where pnt.paen_id_nc = vIdProducto
      FOR UPDATE OF pnt.paen_cont_fin;

 --  Actualizar al siguiente numero
      update parametros_enum_not_cre pntc
         set pntc.paen_cont_fin = vNumNTCRE +1
       where pntc.paen_id_nc  = vIdProducto; 
      
 
    -- Hacer permanentes los cambios para evitar bloqueo de la tabla
--       commit;
   
  
     return vNumNTCRE;
   
 EXCEPTION
      when no_data_found then
         p_msg_regreso := '.:: No se ha dado de alta '|| vNombreTabla ||' en PARAMETROS_EMISION ::.'||sqlerrm;
         dbms_output.put_line(p_msg_regreso);
         rollback;
        return 0;
      when others then
         p_msg_regreso := '.:: Error en "F_GET_NTCRE" .:: -> '||sqlerrm;
         dbms_output.put_line(p_msg_regreso);
         rollback;
         return 0;
 END F_GET_NTCRE;


FUNCTION INSERTA_NOTA_CREDITO(nCodCia         NUMBER,    nIdPoliza      NUMBER,    nIDetPol            NUMBER, 
                              nIdEndoso       NUMBER,    nCodCliente    NUMBER,    dFecNcr             DATE, 
                              nMtoNcrLocal    NUMBER,    nMtoNcrMoneda  NUMBER,    nMtoComisLocal      NUMBER, 
                              nMtoComisMoneda NUMBER,    nCodAgente     NUMBER,    cCodMoneda          VARCHAR2, 
                              nTasaCambio     NUMBER,    nIdTransaccion NUMBER,    cIndFactElectronica VARCHAR2) RETURN NUMBER IS  --LARPLA
nIdNcr               NOTAS_DE_CREDITO.IdNcr%TYPE;
cCodTipoDoc          TIPO_DE_DOCUMENTO.CodTipoDoc%TYPE;
cCodUsuarioEnvFact   NOTAS_DE_CREDITO.CodUsuarioEnvFact%TYPE;
nID_a�o_POLIZA  FACTURAS.id_a�o_poliza%TYPE;  
dFECFINVIGNCR   FACTURAS.FECFINVIG%TYPE;      
dFECFINVIGPOL   POLIZAS.FECFINVIG%TYPE;       
nCODEMPRESA     POLIZAS.CODEMPRESA%TYPE;      
cCODPLANPAGO    POLIZAS.CODPLANPAGO%TYPE;     
--
BEGIN
  --
  BEGIN
    SELECT CodTipoDoc
      INTO cCodTipoDoc
      FROM TIPO_DE_DOCUMENTO
     WHERE CodClase = 'NC'
       AND Sugerido = 'S';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         cCodTipoDoc := NULL;
  END;
  --
  BEGIN     
    SELECT P.FECFINVIG,   P.CODEMPRESA,   P.CODPLANPAGO
      INTO dFECFINVIGPOL, nCODEMPRESA,    cCODPLANPAGO   
      FROM POLIZAS P
     WHERE P.IDPOLIZA = nIdPoliza;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         dFECFINVIGPOL := '';
         nCODEMPRESA   := '';
         cCODPLANPAGO  := '';
    WHEN TOO_MANY_ROWS THEN
         dFECFINVIGPOL := '';
         nCODEMPRESA   := '';
         cCODPLANPAGO  := '';
    WHEN OTHERS THEN
         dFECFINVIGPOL := '';
         nCODEMPRESA   := '';
         cCODPLANPAGO  := '';
  END;  
  --     
  nIdNcr := oc_notas_de_credito.F_GET_NTCRE(p_msg_regreso);
  --
  nID_A�O_POLIZA := OC_FACTURAS.CALCULA_A�O_POLIZA(nIdPoliza, dFecNcr); 
  --
  dFECFINVIGNCR := OC_NOTAS_DE_CREDITO.VIGENCIA_FINAL(nCodCia,       nCODEMPRESA,  nIdPoliza, 
                                                      nIdEndoso,     dFecNcr,      dFecFinVigPol, 
                                                      cCODPLANPAGO);
  --
  IF cIndFactElectronica = 'S' THEN
     cCodUsuarioEnvFact := 'XENVIAR';
  ELSE      
     cCodUsuarioEnvFact := NULL;
  END IF;
  --
  BEGIN
    INSERT INTO NOTAS_DE_CREDITO
     (IdNcr,             IdPoliza,             IDetPol,            IdEndoso,           
      CodCliente,        NumNcr,               FecDevol,           Monto_Ncr_Local,
      Monto_Ncr_Moneda,  StsNcr,               FecSts,             FecAnul, 
      MotivAnul,         MtoComisi_Local,      MtoComisi_Moneda,   CodMoneda,  
      Tasa_Cambio,       CodTipoDoc,           Cod_Agente,         CodCia, 
      Saldo_NCR_Local,   Saldo_NCR_Moneda,     IdTransaccion,      CtaLiquidadora, 
      IdTransaccionAnu,  IndFactElectronica,   CodUsuarioEnvFact,  FECFINVIG,
      CODPLANPAGO,       ID_A�O_POLIZA)
     VALUES 
     (nIdNcr,            nIdPoliza,            nIDetPol,           nIdEndoso, 
      nCodCliente,       NULL,                 dFecNcr,            nMtoNcrLocal,
      nMtoNcrMoneda,     'XEM',                TRUNC(SYSDATE),     NULL, 
      NULL,              nMtoComisLocal,       nMtoComisMoneda,    cCodMoneda, 
      nTasaCambio,       cCodTipoDoc,          nCodAgente,         nCodCia, 
      nMtoNcrLocal,      nMtoNcrMoneda,        nIdTransaccion,     NULL, 
      NULL,              cIndFactElectronica,  cCodUsuarioEnvFact, dFECFINVIGNCR,
      cCODPLANPAGO,      nID_A�O_POLIZA);
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20225,'Error al Insertar Nota de Credito No.: '||TRIM(TO_CHAR(nIdNcr))|| ' ' ||SQLERRM);
   END;
   RETURN(nIdNcr);
END INSERTA_NOTA_CREDITO;  --LARPLA

PROCEDURE ACTUALIZA_NOTA(nIdNcr NUMBER) IS
nMtoTotal         DETALLE_NOTAS_DE_CREDITO.Monto_Det_Local%TYPE;
nMtoTotalMoneda   DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
BEGIN
   -- Actualiza Valor de la Nota de CrÃ©dito con Impuestos
   SELECT NVL(SUM(Monto_Det_Local),0), NVL(SUM(Monto_Det_Moneda),0)
     INTO nMtoTotal, nMtoTotalMoneda
     FROM DETALLE_NOTAS_DE_CREDITO
    WHERE IdNcr = nIdNcr;

   UPDATE NOTAS_DE_CREDITO
      SET Monto_Ncr_Local  = nMtoTotal,
          Monto_Ncr_Moneda = nMtoTotalMoneda,
          Saldo_Ncr_Local  = nMtoTotal,
          Saldo_Ncr_Moneda = nMtoTotalMoneda
    WHERE IdNcr = nIdNcr;

END ACTUALIZA_NOTA;

PROCEDURE EMITIR(nIdNcr NUMBER, cNumNcr VARCHAR2) IS
BEGIN
   UPDATE NOTAS_DE_CREDITO
      SET StsNcr = 'EMI',
          NumNcr = cNumNcr,
          FecSts = TRUNC(SYSDATE)
    WHERE IdNcr  = nIdNcr;
END EMITIR;

PROCEDURE ANULAR(nIdNcr NUMBER, dFecAnul DATE, cMotivAnul VARCHAR2, nIdTransaccion NUMBER) IS
nCodCia               NOTAS_DE_CREDITO.CodCia%TYPE;
cFolioFactElec        NOTAS_DE_CREDITO.FolioFactElec%TYPE;
cIndFactElectronica   NOTAS_DE_CREDITO.IndFactElectronica%TYPE;
cCodUsuarioEnvFactAnu NOTAS_DE_CREDITO.CodUsuarioEnvFactAnu%TYPE;
BEGIN
   BEGIN
      SELECT CodCia, IndFactElectronica, FolioFactElec
        INTO nCodCia, cIndFactElectronica, cFolioFactElec
        FROM NOTAS_DE_CREDITO
       WHERE IdNcr  = nIdNcr;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'No. de Nota de Credito '||TRIM(TO_CHAR(nIdNcr)) || ' NO Existe para Anularla');
   END;

   IF cIndFactElectronica = 'S' AND cFolioFactElec IS NOT NULL THEN
      cCodUsuarioEnvFactAnu := 'XENVIAR';
   ELSE
      cCodUsuarioEnvFactAnu := NULL;
   END IF;

   UPDATE NOTAS_DE_CREDITO
      SET StsNcr               = 'ANU',
          FecSts               = dFecAnul,
          FecAnul              = dFecAnul,                   
          MotivAnul            = cMotivAnul,
          IdTransaccionAnu     = nIdTransaccion,
          CodUsuarioEnvFactAnu = cCodUsuarioEnvFactAnu
    WHERE IdNcr   = nIdNcr
      AND CodCia  = nCodCia;

   OC_COMISIONES.REVERSA_DEVOLUCION(nCodCia, nIdNcr);
END ANULAR;

PROCEDURE EMITIR_NOTA_CREDITO(nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER, nIdTransaccion NUMBER) IS
nIdNcr                   NOTAS_DE_CREDITO.IdNcr%TYPE;
nNumPagos                PLAN_DE_PAGOS.NumPagos%TYPE;
nFrecPagos               PLAN_DE_PAGOS.FrecPagos%TYPE;
nPorcInicial             PLAN_DE_PAGOS.PorcInicial%TYPE;
nCodCliente              POLIZAS.CodCliente%TYPE;
cIdTipoSeg               DETALLE_POLIZA.IdTipoSeg%TYPE;
nTotPrimas               DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nDifer                   DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nDiferMoneda             DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nMtoDet                  DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nMtoDetMoneda            DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nMtoTotal                DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nMtoTotalMoneda          DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
cCodMoneda               POLIZAS.Cod_Moneda%TYPE;
nPrimaNetaMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nMtoPagoMoneda           FACTURAS.Monto_Fact_Moneda%TYPE;
cCodMonedaLocal          EMPRESAS.Cod_Moneda%TYPE;
nPrimaRestMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nMtoComisiMoneda         FACTURAS.MtoComisi_Local%TYPE;
nTotPrimasMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nCodCia                  POLIZAS.CodCia%TYPE;
nCodEmpresa              POLIZAS.CodEmpresa%TYPE;
cCodPlanPago             DETALLE_POLIZA.CodPlanPago%TYPE;
nTasaCambio              DETALLE_POLIZA.Tasa_Cambio%TYPE;
nMtoCpto                 CONCEPTOS_PLAN_DE_PAGOS.MtoCpto%TYPE;
nPorcCpto                CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
cAplica                  CONCEPTOS_PLAN_DE_PAGOS.Aplica%TYPE;
cCodTipoDoc              TIPO_DE_DOCUMENTO.CodTipoDoc%TYPE;
nPrimaLocal              ENDOSOS.Prima_Neta_Moneda%TYPE;
nPrimaMoneda             ENDOSOS.Prima_Neta_Local%TYPE;
nMtoAsistLocal           ASISTENCIAS_DETALLE_POLIZA.MontoAsistLocal%TYPE;
nMtoAsistMoneda          ASISTENCIAS_DETALLE_POLIZA.MontoAsistMoneda%TYPE;
nAsistRestLocal          ASISTENCIAS_DETALLE_POLIZA.MontoAsistLocal%TYPE;
nAsistRestMoneda         ASISTENCIAS_DETALLE_POLIZA.MontoAsistMoneda%TYPE;
nTotPrimaMonedaAseg      ASEGURADO_CERTIFICADO.PrimaNeta_Moneda%TYPE;
cTipoEndoso              ENDOSOS.TipoEndoso%TYPE;
cIndFactElectronica      POLIZAS.IndFactElectronica%TYPE;
Dummy                    NUMBER(5);
dFecPago                 DATE;
nMtoPago                 NUMBER(18,2);
nMtoComisi               NUMBER(18,2);
nPrimaRest               NUMBER(18,2);
dFecHoy                  DATE;
cGraba                   VARCHAR2(1);
nFactor                  NUMBER (14,8);
fFecfinvig               FACTURAS.FECFINVIG%TYPE;      -- ICOFINVIG

CURSOR ENDOSO_Q IS
   SELECT E.Prima_Neta_Local PrimaLocal, E.Prima_Neta_Moneda PrimaMoneda, E.CodPlanPago, E.PorcComis,
          E.FecIniVig, E.FecFinVig, E.FecEmision, E.IDetPol, D.IdTipoSeg, A.Cod_Agente, A.Porc_Comision, E.FecExc,
          D.Prima_Local, D.Prima_Moneda, E.TipoEndoso
     FROM DETALLE_POLIZA D, ENDOSOS E, AGENTES_DETALLES_POLIZAS A
    WHERE D.IdPoliza  = E.IdPoliza
      AND D.IDetPol   = E.IDetPol
      AND E.IdPoliza  = nIdPoliza
      AND E.IdEndoso  = nIdEndoso
      AND A.idpoliza  = E.IdPoliza
      AND A.idetpol   = E.IDetPol;

CURSOR CPTO_PRIMAS_Q IS
   SELECT CS.CodCpto, SUM(C.Prima_Local) Prima_Local, SUM(C.Prima_Moneda) Prima_Moneda
     FROM COBERT_ACT C, COBERTURAS_DE_SEGUROS CS
    WHERE CS.CodCobert  = C.CodCobert
      AND CS.PlanCob    = C.PlanCob
      AND CS.IdTipoSeg  = C.IdTipoSeg
      AND CS.CodEmpresa = C.CodEmpresa
      AND CS.CodCia     = C.CodCia
      AND IdEndoso      = nIdEndoso
      AND C.IDetPol     = nIDetPol
      AND C.IdPoliza    = nIdPoliza
      AND C.CodCia      = nCodCia
    GROUP BY CS.CodCpto
    UNION
   SELECT CS.CodCpto, SUM(C.Prima_Local) Prima_Local, SUM(C.Prima_Moneda) Prima_Moneda
     FROM COBERTURAS C, COBERTURAS_DE_SEGUROS CS
    WHERE CS.CodCobert  = C.CodCobert
      AND CS.PlanCob    = C.PlanCob
      AND CS.IdTipoSeg  = C.IdTipoSeg
      AND CS.CodEmpresa = C.CodEmpresa
      AND CS.CodCia     = C.CodCia
      AND IdEndoso      = nIdEndoso
      AND IdEndoso      != 0
      AND C.IDetPol     = nIDetPol
      AND C.IdPoliza    = nIdPoliza
      AND C.CodCia      = nCodCia
    GROUP BY CS.CodCpto
    UNION
   SELECT CS.CodCpto, SUM(C.Prima_Local) Prima_Local, SUM(C.Prima_Moneda) Prima_Moneda
     FROM COBERTURA_ASEG C, COBERTURAS_DE_SEGUROS CS
    WHERE CS.CodCobert  = C.CodCobert
      AND CS.PlanCob    = C.PlanCob
      AND CS.IdTipoSeg  = C.IdTipoSeg
      AND CS.CodEmpresa = C.CodEmpresa
      AND CS.CodCia     = C.CodCia
      AND IdEndoso      = nIdEndoso
      AND IdEndoso      != 0
      --AND C.IDetPol     = nIDetPol
      AND C.IdPoliza    = nIdPoliza
      AND C.CodCia      = nCodCia
    GROUP BY CS.CodCpto
    UNION
   SELECT MAX(CS.CodCpto) CodCpto, nPrimaLocal Prima_Local, nPrimaMoneda Prima_Moneda
     FROM DETALLE_POLIZA D, COBERTURAS_DE_SEGUROS CS
    WHERE CS.Cobertura_Basica = 'S'
      AND CS.PlanCob          = D.PlanCob
      AND CS.IdTipoSeg        = D.IdTipoSeg
      AND CS.CodEmpresa       = D.CodEmpresa
      AND CS.CodCia           = D.CodCia
      AND D.IDetPol           = nIDetPol
      AND D.IdPoliza          = nIdPoliza
      AND D.CodCia            = nCodCia
      AND cTipoEndoso         = 'NSS'
    GROUP BY CS.CodCpto;
CURSOR CPTO_ASIST_Q IS
   SELECT T.CodCptoServicio, SUM(A.MontoAsistLocal) MontoAsistLocal,
          SUM(A.MontoAsistMoneda) MontoAsistMoneda
     FROM ASISTENCIAS_DETALLE_POLIZA A, DETALLE_POLIZA D, ASISTENCIAS T
    WHERE T.CodAsistencia  = A.CodAsistencia
      AND D.IDetPol        = A.IDetPol
      AND D.IdPoliza       = A.IdPoliza
      AND D.CodCia         = A.CodCia
      AND A.StsAsistencia IN ('EXCLUI')
      AND A.IdEndoso       = nIdEndoso
      AND A.IdPoliza       = nIdPoliza
      AND A.IDetPol        = nIDetPol
      AND A.CodCia         = nCodCia
    GROUP BY T.CodCptoServicio
  UNION ALL
   SELECT T.CodCptoServicio, SUM(A.MontoAsistLocal) MontoAsistLocal,
          SUM(A.MontoAsistMoneda) MontoAsistMoneda
     FROM ASISTENCIAS_ASEGURADO A, DETALLE_POLIZA D, ASISTENCIAS T
    WHERE T.CodAsistencia  = A.CodAsistencia
      AND D.IDetPol        = A.IDetPol
      AND D.IdPoliza       = A.IdPoliza
      AND D.CodCia         = A.CodCia
      AND A.StsAsistencia IN ('EXCLUI')
      AND A.IdPoliza       = nIdPoliza
      AND A.IDetPol        = nIDetPol
      AND A.CodCia         = nCodCia
      AND A.Cod_Asegurado IN (SELECT Cod_Asegurado
                                FROM ASEGURADO_CERTIFICADO
                               WHERE IdPoliza      = nIdPoliza
                                 AND CodCia        = nCodCia
                                 AND IdEndosoExclu = nIdEndoso)
    GROUP BY T.CodCptoServicio;
BEGIN
   BEGIN
      SELECT CodTipoDoc
        INTO cCodTipoDoc
        FROM TIPO_DE_DOCUMENTO
       WHERE CodClase = 'NC'
         AND Sugerido = 'S';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodTipoDoc := NULL;
   END;
   BEGIN
      SELECT CodCliente, Cod_Moneda, CodCia, CodEmpresa, IndFactElectronica
        INTO nCodCliente, cCodMoneda, nCodCia, nCodEmpresa, cIndFactElectronica
        FROM POLIZAS
       WHERE IdPoliza = nIdPoliza;
   END;
   BEGIN
        SELECT Cod_Moneda
          INTO cCodMonedaLocal
          FROM EMPRESAS
         WHERE CodCia = nCodCia;
   END;

   FOR X IN ENDOSO_Q LOOP
      cTipoEndoso  := X.TipoEndoso;
      nPrimaLocal  := X.PrimaLocal;
      nPrimaMoneda := X.PrimaMoneda;
      IF  X.FecExc IS NOT NULL THEN
         nPrimaLocal  := OC_NOTAS_DE_CREDITO.FUNC_CALCULO_PRORRATA (X.FecIniVig, X.FecFinVig, X.FecExc, nPrimaLocal);
         nPrimaMoneda := OC_NOTAS_DE_CREDITO.FUNC_CALCULO_PRORRATA (X.FecIniVig, X.FecFinVig, X.FecExc, nPrimaMoneda);

         UPDATE ENDOSOS
            SET Prima_Neta_Local  = nPrimaLocal,
                Prima_Neta_Moneda = nPrimaMoneda
          WHERE IdEndoso  = nIdEndoso
            AND IdPoliza  = nIdPoliza;
      END IF;
      cCodPlanPago := X.CodPlanPago;
      nTasaCambio  := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(X.FecEmision));
      -- Caracteristicas del Plan de Pago
      BEGIN
         SELECT NumPagos, FrecPagos, PorcInicial
           INTO nNumPagos, nFrecPagos, nPorcInicial
           FROM PLAN_DE_PAGOS
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND CodPlanPago = X.CodPlanPago;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR (-20100,'No Existe Plan de Pagos '||X.CodPlanPago);
      END;
      -- Fecha del Primer Pago Siempre a Inicio de Vigencia
      dFecPago := X.FecIniVig;
   -- Fecha del Primer Pago
      /*IF X.FecIniVig > X.FecEmision THEN
         dFecPago := X.FecIniVig;
      ELSE
         dFecPago := X.FecEmision;
      END IF;*/
   -- Monto del Primer Pago
      nTotPrimas       := 0;
      nTotPrimasMoneda := 0;

      IF NVL(nPorcInicial,0) <> 0 THEN
         nMtoPago       := NVL(nPrimaLocal,0) * nPorcInicial / 100;
         nMtoPagoMoneda := NVL(nPrimaMoneda,0) * nPorcInicial / 100;
      ELSE
         nMtoPago       := NVL(nPrimaLocal,0) / nNumPagos;
         nMtoPagoMoneda := NVL(nPrimaMoneda,0) /nNumPagos;
      END IF;

      nPrimaRest := NVL(nPrimaLocal,0) - NVL(nMtoPago,0);
      nMtoComisi := (nMtoPago * X.PorcComis / 100) * (X.Porc_Comision/100);
      nTotPrimas := NVL(nTotPrimas,0) + NVL(nMtoPago,0);

      -- Cambio Multimoneda Ref. F. Ortiz 24/01/2007
      nPrimaRestMoneda := NVL(nPrimaMoneda,0) - NVL(nMtoPagoMoneda,0);
      nMtoComisiMoneda := (nMtoPagoMoneda * X.PorcComis / 100) * (X.Porc_Comision/100);
      nTotPrimasMoneda := NVL(nTotPrimasMoneda,0) + NVL(nMtoPagoMoneda,0);

      FOR NP IN 1..nNumPagos LOOP
         IF NP > 1 THEN
            nMtoPago         := NVL(nPrimaRest,0) / (nNumPagos - 1);
            nTotPrimas       := NVL(nTotPrimas,0) + NVL(nMtoPago,0);
            nMtoComisi       := nMtoPago * X.PorcComis / 100;
            dFecPago         := ADD_MONTHS(dFecPago,nFrecPagos);
            nMtoPagoMoneda   := NVL(nPrimaRestMoneda,0) / (nNumPagos - 1);
            nTotPrimasMoneda := NVL(nTotPrimasMoneda,0) + NVL(nMtoPagoMoneda,0);
            nMtoComisiMoneda := (nMtoPagoMoneda * X.PorcComis / 100) * (X.porc_comision/100);
         END IF;
--       LARPLA
         nIdNcr := OC_NOTAS_DE_CREDITO.INSERTA_NOTA_CREDITO(nCodCia,       nIdPoliza,         X.IDetPol,     nIdEndoso, 
                                                            nCodCliente,   dFecPago,          nMtoPago,      nMtoPagoMoneda, 
                                                            nMtoComisi,    nMtoComisiMoneda,  X.Cod_Agente,  cCodMoneda, 
                                                            nTasaCambio,   nIdTransaccion,    cIndFactElectronica);

         FOR W IN CPTO_PRIMAS_Q LOOP
            IF nIdEndoso != 0 THEN
               IF X.TipoEndoso NOT IN ('EXA','NSS') THEN
                  nFactor :=   W.Prima_Moneda / X.Prima_Moneda;-- NVL(nMtoPago,0);
               ELSE
                  nFactor :=   W.Prima_Moneda / X.PrimaMoneda;-- NVL(nMtoPago,0);
               END IF;
            ELSE
               nFactor := W.Prima_Moneda / NVL(nMtoPagoMoneda,0);
            END IF;

            OC_DETALLE_NOTAS_DE_CREDITO.INSERTA_DETALLE_NOTA(nIdNcr, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
            OC_DETALLE_NOTAS_DE_CREDITO.AJUSTAR(nCodCia, nIdNcr, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
         END LOOP;

         IF X.TipoEndoso = 'EXA' THEN
            SELECT NVL(SUM(PrimaNeta_Moneda),0)
              INTO nTotPrimaMonedaAseg
              FROM ASEGURADO_CERTIFICADO
             WHERE IdPoliza      = nIdPoliza
               AND IdEndosoExclu = nIdEndoso
               AND Estado        = 'CEX';
            IF nTotPrimaMonedaAseg != 0 THEN
               nFactor  := X.PrimaMoneda / nTotPrimaMonedaAseg;
            ELSE
               nFactor  := X.PrimaMoneda / X.Prima_Moneda;
            END IF;
         ELSE
            nFactor  := 1;
         END IF;
         FOR K IN CPTO_ASIST_Q LOOP
            nAsistRestLocal  := 0;
            nAsistRestMoneda := 0;
            IF NVL(nPorcInicial,0) <> 0 THEN
               nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) * nPorcInicial / 100) * nFactor;
               nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) * nPorcInicial / 100) * nFactor;
            ELSE
               nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) / nNumPagos) * nFactor;
               nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) / nNumPagos) * nFactor;
            END IF;
            nAsistRestLocal  := NVL(nAsistRestLocal,0) + NVL(K.MontoAsistLocal,0) - nMtoAsistLocal;
            nAsistRestMoneda := NVL(nAsistRestMoneda,0) + NVL(K.MontoAsistMoneda,0) - nMtoAsistMoneda;
            IF NP > 1 THEN
               nMtoAsistLocal  := (NVL(nAsistRestLocal,0) / (nNumPagos - 1));
               nMtoAsistMoneda := (NVL(nAsistRestMoneda,0) / (nNumPagos - 1));
            END IF;
            OC_DETALLE_NOTAS_DE_CREDITO.INSERTA_DETALLE_NOTA(nIdNcr, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
            OC_DETALLE_NOTAS_DE_CREDITO.AJUSTAR(nCodCia, nIdNcr, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
         END LOOP;

         OC_NOTAS_DE_CREDITO.ACTUALIZA_NOTA(nIdNcr);
         OC_COMISIONES.INSERTA_COMISION_NC(nIdNcr);
         OC_DETALLE_NOTAS_DE_CREDITO.GENERA_CONCEPTOS(nCodCia, nCodEmpresa, cCodPlanPago, X.IdTipoSeg,
                                                      nIdNcr, nTasaCambio);
         OC_NOTAS_DE_CREDITO.ACTUALIZA_NOTA(nIdNcr);
         OC_NOTAS_DE_CREDITO.EMITIR(nIdNcr, NULL);
      END LOOP;
      IF NVL(X.PrimaLocal,0) <> NVL(nTotPrimas,0) THEN
         nDifer       := NVL(nPrimaLocal,0) - NVL(nTotPrimas,0);
         nDiferMoneda := NVL(nPrimaMoneda,0) - NVL(nTotPrimasMoneda,0);

         OC_DETALLE_NOTAS_DE_CREDITO.ACTUALIZA_DIFERENCIA(nIdNcr, nDifer, nDiferMoneda);
         OC_NOTAS_DE_CREDITO.ACTUALIZA_NOTA(nIdNcr);
      END IF;
      
      OC_DETALLE_NOTAS_DE_CREDITO.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdNcr,'IVASIN');
      
      SELECT SUM(Monto_Det_Moneda)
        INTO nMtoTotalMoneda
        FROM DETALLE_NOTAS_DE_CREDITO
       WHERE IdNcr = nIdNcr;

      OC_DETALLE_TRANSACCION.CREA (nIdTransaccion, nCodCia, nCodEmpresa, 8, 'NCR', 'NOTAS_DE_CREDITO',
                                   nIdPoliza, nIDetPol, nIdEndoso, nIdNcr, nMtoTotalMoneda);
   END LOOP;
END EMITIR_NOTA_CREDITO;

FUNCTION FUNC_CALCULO_PRORRATA (dFecIniVig DATE ,dFecFinVig DATE ,dFecExc DATE,nPrimaA NUMBER) RETURN NUMBER IS
nTotalDias NUMBER (14,2);
nDiasD     NUMBER (14,2);
nDiasC     NUMBER (14,2);
nPrimaP    NUMBER (14,2);

BEGIN
   nTotalDias := dFecFinVig - dFecIniVig;
   nDiasD     := dFecExc - dFecIniVig;
   nDiasC     := nTotalDias - nDiasD;
   nPrimaP    := nPrimaA / nTotalDias * nDiasC;
   RETURN (nPrimaP);
END FUNC_CALCULO_PRORRATA;

PROCEDURE PAGAR(nCodCia NUMBER, nIdNcr NUMBER, dFecPago DATE) IS
nIdTransac               TRANSACCION.IdTransaccion%TYPE;
nMontoNCR                NOTAS_DE_CREDITO.MONTO_NCR_LOCAL%TYPE;
nIdPoliza                NOTAS_DE_CREDITO.IdPoliza%TYPE;
nIDetPol                 NOTAS_DE_CREDITO.IDetPol%TYPE;
nIdEndoso                NOTAS_DE_CREDITO.IdEndoso%TYPE;
nIdNomina                NOTAS_DE_CREDITO.IdNomina%TYPE;
nIdProceso               PROC_TAREA.IdProceso%TYPE;
cCodSubProceso           SUB_PROCESO.CodSubProceso%TYPE;
BEGIN
   SELECT Monto_Ncr_Moneda, IdPoliza, IDetPol, IdEndoso, IdNomina
     INTO nMontoNCR, nIdPoliza, nIDetPol, nIdEndoso, nIdNomina
     FROM NOTAS_DE_CREDITO
    WHERE IdNcr  = nIdNcr
      AND CodCia = nCodCia;

   IF NVL(nIdNomina,0) != 0 THEN
      nIdProceso     := 17; -- Pago de Comisiones a Agentes
      cCodSubProceso := 'PAGO';
   ELSE
      nIdProceso     := 20; -- Pago de Notas de CrÃ©dito
      cCodSubProceso := 'PAGNCR';
   END IF;

   nIdTransac := OC_TRANSACCION.CREA(nCodCia, 1, nIdProceso, cCodSubProceso);

   UPDATE NOTAS_DE_CREDITO
      SET StsNcr         = 'PAG',
          FecSts         = dFecPago,
          IdTransacAplic = nIdTransac
    WHERE IdNcr  = nIdNcr
      AND CodCia = nCodCia;

   OC_COMISIONES.PAGA_ABONA_COMISION_NC(nIdNcr, nIdNcr, dFecPago, 100, 'T');

   OC_DETALLE_TRANSACCION.CREA (nIdTransac,nCodCia, 1, nIdProceso, cCodSubProceso, 'NOTAS_DE_CREDITO', 
                                nIdPoliza, nIDetPol, nIdEndoso, nIdNcr, nMontoNCR);
   OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransac, 'C');
END PAGAR;

PROCEDURE APLICAR(nCodCia   NUMBER,    nCodEmpresa   NUMBER,      nIdnCR         NUMBER, 
                  dFecAplic DATE,      cNumReciboRef VARCHAR2,    nIdTransaccion NUMBER) IS

nMonto_Ncr_Moneda    NOTAS_DE_CREDITO.Monto_Ncr_Moneda%TYPE;
nIdPoliza            NOTAS_DE_CREDITO.IdPoliza%TYPE;
nIDetPol             NOTAS_DE_CREDITO.IDetPol%TYPE;
nIdEndoso            NOTAS_DE_CREDITO.IdEndoso%TYPE;
BEGIN
   BEGIN
      SELECT Monto_Ncr_Moneda, IdPoliza, IDetPol, IdEndoso
        INTO nMonto_Ncr_Moneda, nIdPoliza, nIDetPol, nIdEndoso
        FROM NOTAS_DE_CREDITO
       WHERE IdNcr    = nIdNcr
         AND StsNcr   = 'EMI';

      OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa, 19, 'APLNCR', 'NOTAS_DE_CREDITO',
                                  nIdPoliza, nIDetPol, nIdEndoso, nIdnCR, nMonto_Ncr_Moneda);

      UPDATE NOTAS_DE_CREDITO
         SET StsNcr             = 'APL',
             FecSts             = dFecAplic,
             Saldo_Ncr_Local    = 0,
             Saldo_Ncr_Moneda   = 0,
             IdTransacAplic     = nIdTransaccion
       WHERE IdNcr = nIdNcr;

      OC_COMISIONES.PAGA_ABONA_COMISION_NC(nIdNcr, nIdNcr, dFecAplic, 100, 'T');
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'No. de Nota de Credito '||TRIM(TO_CHAR(nIdNcr)) || ' NO Esta EMITIDA y no Puede Aplicarse');
   END;
END APLICAR;

PROCEDURE ARCHIVO_CLIENTES_FACT_ELECT(nCodCia NUMBER, dFecDesde DATE, dFecHasta DATE) IS
cDescColonia               COLONIA.Descripcion_Colonia%TYPE;
cDescEstado                PROVINCIA.DescEstado%TYPE;
cDescCiudad                DISTRITO.DescCiudad%TYPE;
cTipo_Doc_Identificacion   PERSONA_NATURAL_JURIDICA.Tipo_Doc_Identificacion%TYPE;
cNum_Doc_Identificacion    PERSONA_NATURAL_JURIDICA.Num_Doc_Identificacion%TYPE;
cEmailCia                  CORREOS_ELECTRONICOS_PNJ.Email%TYPE;
cEmailAgteDirec            CORREOS_ELECTRONICOS_PNJ.Email%TYPE;
cCodCliente                NOTAS_DE_CREDITO.CodCliente%TYPE;
cCodPosRes                 PERSONA_NATURAL_JURIDICA.CodPosRes%TYPE;
cNumExterior               PERSONA_NATURAL_JURIDICA.NumExterior%TYPE;
cNumInterior               PERSONA_NATURAL_JURIDICA.NumInterior%TYPE;
cDirecRes                  VARCHAR2(500);
cCodUser                   VARCHAR2(30)   := USER;
nLinea                     NUMBER(15)     := 1;
cCadena                    VARCHAR2(4000);
cEmailsFactElect           VARCHAR2(255);
cSeparador                 VARCHAR2(1)    := '|';
cAsignoEjec                VARCHAR2(1)    := 'N';


w1TIPO_ID_TRIBUTARIA       PERSONA_NATURAL_JURIDICA.TIPO_DOC_IDENTIFICACION%TYPE;
w1NUM_TRIBUTARIO           PERSONA_NATURAL_JURIDICA.NUM_TRIBUTARIO%TYPE;
W2ID_TRIBUTARIA            PERSONA_NATURAL_JURIDICA.TIPO_DOC_IDENTIFICACION%TYPE;   
W2NUM_TRIBUTARIO           PERSONA_NATURAL_JURIDICA.NUM_TRIBUTARIO%TYPE;

CURSOR CLI_Q IS
   SELECT DISTINCT N.CodCliente, 
          P.Nombre || ' ' || P.Apellido_Paterno || ' ' || P.Apellido_Materno NombreCliente,
          REPLACE(REPLACE(P.DirecRes,CHR(13),' '),CHR(10),' ') DirecRes, P.CodPaisRes, P.CodProvRes, 
          P.CodDistRes, P.CodCorrRes, P.CodPosRes, P.CodColRes, P.TelRes, P.Email, 
          P.NumInterior, P.NumExterior, P.Tipo_Doc_Identificacion, P.Num_Doc_Identificacion,
          DECODE(P.Tipo_Doc_Identificacion,'RFC',P.Num_Doc_Identificacion,P.Num_Tributario) Num_Tributario,
          0 IdDirecAviCob
          ,p.TIPO_ID_TRIBUTARIA, p.NUM_TRIBUTARIO A_NUM_TRIBUTARIO
     FROM NOTAS_DE_CREDITO N, POLIZAS PO, CLIENTES C, PERSONA_NATURAL_JURIDICA P
    WHERE P.Num_Doc_Identificacion  = C.Num_Doc_Identificacion
      AND P.Tipo_Doc_Identificacion = C.Tipo_Doc_Identificacion
      AND C.CodCliente              = N.CodCliente
      AND PO.IndFacturaPol          = 'S'
      AND PO.CodCia                 = N.CodCia
      AND PO.IdPoliza               = N.IdPoliza
      AND N.CodCia                  = nCodCia
      AND ((N.StsNcr               IN ('PAG','APL')
      AND N.FecSts                 >= dFecDesde
      AND N.FecSts                 <= dFecHasta)
       OR (N.StsNcr                 = 'EMI'
      AND N.FecDevol               >= dFecDesde
      AND N.FecDevol               <= dFecHasta))
      AND N.IndFactElectronica      = 'S'
      AND N.CodUsuarioEnvFact       = 'XENVIAR'
      AND N.FecEnvFactElec         IS NULL
    UNION
   SELECT DISTINCT TO_NUMBER('99999' || LPAD(TO_CHAR(D.Cod_Asegurado),9,'0')) CodCliente, 
          P.Nombre || ' ' || P.Apellido_Paterno || ' ' || P.Apellido_Materno NombreCliente,
          REPLACE(P.DirecRes,CHR(13),' ') DirecRes, P.CodPaisRes, P.CodProvRes, P.CodDistRes,
          P.CodCorrRes, P.CodPosRes, P.CodColRes, P.TelRes, P.Email, P.NumInterior, P.NumExterior,
          P.Tipo_Doc_Identificacion, P.Num_Doc_Identificacion,
          DECODE(P.Tipo_Doc_Identificacion,'RFC',P.Num_Doc_Identificacion,P.Num_Tributario) Num_Tributario,
          NVL(D.IdDirecAviCob,0) IdDirecAviCob
          ,p.TIPO_ID_TRIBUTARIA, p.NUM_TRIBUTARIO   A_NUM_TRIBUTARIO
     FROM NOTAS_DE_CREDITO N, POLIZAS PO, DETALLE_POLIZA D, ASEGURADO A, PERSONA_NATURAL_JURIDICA P
    WHERE P.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
      AND P.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
      AND A.Cod_Asegurado           = D.Cod_Asegurado
      AND D.CodCia                  = N.CodCia
      AND D.IdPoliza                = N.IdPoliza
      AND D.IDetPol                 = N.IDetPol
      AND PO.IndFacturaPol          = 'N'
      AND PO.CodCia                 = N.CodCia
      AND PO.IdPoliza               = N.IdPoliza
      AND N.CodCia                  = nCodCia
      AND ((N.StsNcr               IN ('PAG','APL')
      AND N.FecSts                 >= dFecDesde
      AND N.FecSts                 <= dFecHasta)
       OR (N.StsNcr                 = 'EMI'
      AND N.FecDevol               >= dFecDesde
      AND N.FecDevol               <= dFecHasta))
      AND N.IndFactElectronica      = 'S'
      AND N.CodUsuarioEnvFact       = 'XENVIAR'
      AND N.FecEnvFactElec         IS NULL;
      
CURSOR AGT_Q IS
   SELECT DISTINCT CO.Cod_Agente, A.Tipo_Doc_Identificacion,
          A.Num_Doc_Identificacion, A.CodTipo, A.CodNivel, NVL(A.idcuentacorreo,0) CtaMail -- AEVS 14062017
     FROM NOTAS_DE_CREDITO N, COMISIONES CO, AGENTES A
    WHERE A.Cod_Agente           = CO.Cod_Agente
      AND CO.IdNcr               = N.IdNcr
      AND N.CodCliente           = cCodCliente
      AND N.CodCia               = nCodCia
      AND ((N.StsNcr            IN ('PAG','APL')
      AND N.FecSts              >= dFecDesde
      AND N.FecSts              <= dFecHasta)
       OR (N.StsNcr              = 'EMI'
      AND N.FecDevol            >= dFecDesde
      AND N.FecDevol            <= dFecHasta))
      AND N.IndFactElectronica   = 'S'
      AND N.CodUsuarioEnvFact    = 'XENVIAR'
      AND N.FecEnvFactElec      IS NULL
    ORDER BY A.CodNivel;
BEGIN
   cTipo_Doc_Identificacion  := OC_EMPRESAS.TIPO_IDENTIFICACION_TRIBUTARIA(nCodCia);
   cNum_Doc_Identificacion   := OC_EMPRESAS.IDENTIFICACION_TRIBUTARIA(nCodCia);
   cEmailCia                 := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(cTipo_Doc_Identificacion, cNum_Doc_Identificacion);

   FOR X IN CLI_Q LOOP
      IF X.Email IS NOT NULL THEN
         cEmailsFactElect := X.Email || '; ' || cEmailCia;
      ELSE
         cEmailsFactElect := cEmailCia;
      END IF;
      cCodCliente := X.CodCliente;
      cAsignoEjec := 'N';

      FOR W IN AGT_Q LOOP
      
         IF OC_AGENTES.EJECUTIVO_COMERCIAL(nCodCia, W.Cod_Agente) != 0 AND cAsignoEjec = 'N' THEN
            cEmailAgteDirec := OC_EJECUTIVO_COMERCIAL.EMAIL_EJECUTIVO(nCodCia, OC_AGENTES.EJECUTIVO_COMERCIAL(nCodCia, W.Cod_Agente));
            cAsignoEjec     := 'S';
         ELSE
        
           ----  validamos que si el Tipo de Documento No es RFC, busque en el campo Tipo ID Tributaria. Si esta nulo, deja el  Documento original  AEVS 14072017
           IF W.Tipo_Doc_Identificacion NOT IN ('RFC') THEN
            BEGIN 
             SELECT TIPO_ID_TRIBUTARIA, NUM_TRIBUTARIO
             INTO   w1TIPO_ID_TRIBUTARIA, w1NUM_TRIBUTARIO
             FROM PERSONA_NATURAL_JURIDICA
             WHERE TIPO_DOC_IDENTIFICACION = W.Tipo_Doc_Identificacion
             AND   Num_Doc_Identificacion  = W.Num_Doc_Identificacion
             AND   TIPO_ID_TRIBUTARIA      IS NOT NULL
             AND   NUM_TRIBUTARIO          IS NOT NULL    ;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                         w1TIPO_ID_TRIBUTARIA := W.Tipo_Doc_Identificacion;
                         w1NUM_TRIBUTARIO     := W.Num_Doc_Identificacion;
                       WHEN OTHERS THEN
                         w1TIPO_ID_TRIBUTARIA := W.Tipo_Doc_Identificacion;
                         w1NUM_TRIBUTARIO     := W.Num_Doc_Identificacion;
            END; 
            IF w1TIPO_ID_TRIBUTARIA IS NULL THEN  w1TIPO_ID_TRIBUTARIA := W.Tipo_Doc_Identificacion;  w1NUM_TRIBUTARIO := W.Num_Doc_Identificacion; END IF;
           END IF;
      
            --- Buscamos si tiene un Correo Especifico. De no tenerlo, buscamos el Principal  AEVS 14062017
            IF W.CtaMail <> 0 THEN 
                  cEmailAgteDirec := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_ESPECIFICO(w1TIPO_ID_TRIBUTARIA, w1NUM_TRIBUTARIO, W.CtaMail);--W.Tipo_Doc_Identificacion, W.Num_Doc_Identificacion, W.CtaMail);
            ELSE 
                  cEmailAgteDirec := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(w1TIPO_ID_TRIBUTARIA, w1NUM_TRIBUTARIO);
            END IF;
              /*IF W.CodTipo LIKE 'AGTE%' THEN
                 cEmailAgteDirec := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(W.Tipo_Doc_Identificacion, W.Num_Doc_Identificacion);
              ELSIF W.CodTipo LIKE 'DIRE%' THEN
                 cEmailAgteDirec := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(W.Tipo_Doc_Identificacion, W.Num_Doc_Identificacion);
              ELSE
                 cEmailAgteDirec := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(W.Tipo_Doc_Identificacion, W.Num_Doc_Identificacion);
              END IF;*/
         END IF;
               IF cEmailAgteDirec IS NOT NULL THEN
                  IF LENGTH(cEmailsFactElect) + LENGTH(cEmailAgteDirec) <= 255 THEN
                     cEmailsFactElect := cEmailsFactElect || '; ' || cEmailAgteDirec;
                  END IF;
               END IF;
      END LOOP;
      
      
      IF X.IdDirecAviCob = 0 THEN
               cDescColonia := OC_COLONIA.DESCRIPCION_COLONIA(X.CodPaisRes, X.CodProvRes, X.CodDistRes, X.CodCorrRes,
                                                              X.CodPosRes, X.CodColRes);
               cDescEstado  := OC_PROVINCIA.NOMBRE_PROVINCIA(X.CodPaisRes, X.CodProvRes);
               cDescCiudad  := OC_DISTRITO.NOMBRE_DISTRITO(X.CodPaisRes, X.CodProvRes, X.CodDistRes);
               cDirecRes    := X.DirecRes;
               cCodPosRes   := X.CodPosRes;
               cNumExterior := X.NumExterior;
               cNumInterior := X.NumInterior;
      ELSE
         ----  validamos que si el Tipo de Documento No es RFC, busque en el campo Tipo ID Tributaria. Si esta nulo, deja el  Documento original  AEVS 14072017
         IF X.Tipo_Doc_Identificacion NOT IN ('RFC') THEN
            IF ( X.TIPO_ID_TRIBUTARIA IS NOT NULL AND  X.A_NUM_TRIBUTARIO IS NOT NULL ) THEN                 
                 W2ID_TRIBUTARIA   := X.TIPO_ID_TRIBUTARIA ;
                 W2NUM_TRIBUTARIO  := X.A_NUM_TRIBUTARIO ;
            ELSE 
                 W2ID_TRIBUTARIA   := X.Tipo_Doc_Identificacion ;
                 W2NUM_TRIBUTARIO  := X.Num_Doc_Identificacion ;
            END IF;
         END IF;         
         cTipo_Doc_Identificacion  := W2ID_TRIBUTARIA; --X.Tipo_Doc_Identificacion; AEVS 
         cNum_Doc_Identificacion   := W2NUM_TRIBUTARIO;
         BEGIN
            SELECT REPLACE(REPLACE(Direccion,CHR(13),' '),CHR(10),' ') DirecRes,
                   NumExterior, NumInterior, Codigo_Postal, 
                   OC_COLONIA.DESCRIPCION_COLONIA(CodPais, CodEstado, CodCiudad, CodMunicipio, Codigo_Postal, CodAsentamiento) Colonia,
                   OC_PROVINCIA.NOMBRE_PROVINCIA(CodPais, CodEstado) Estado,
                   OC_DISTRITO.NOMBRE_DISTRITO(CodPais, CodEstado, CodCiudad) Ciudad
              INTO cDirecRes, cNumExterior, cNumInterior, cCodPosRes,
                   cDescColonia, cDescEstado, cDescCiudad
              FROM DIRECCIONES_PNJ D
             WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
               AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
               AND Correlativo_Direccion   = X.IdDirecAviCob;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cDirecRes     := NULL;
               cNumExterior  := NULL;
               cNumInterior  := NULL;
               cCodPosRes    := NULL;
               cDescColonia  := NULL;
               cDescEstado   := NULL;
               cDescCiudad   := NULL;
         END;
      END IF;

      IF cDescColonia = 'COLONIA NO EXISTE' THEN
         cDescColonia := NULL;
      END IF;

      cCadena := TRIM(TO_CHAR(X.CodCliente,'00000000000000')) || cSeparador ||
                 X.NombreCliente                              || cSeparador ||
                 ' '                                          || cSeparador ||
                 cDirecRes                                    || cSeparador ||
                 cDescColonia                                 || cSeparador ||
                 cDescCiudad                                  || cSeparador ||
                 cDescEstado                                  || cSeparador ||
                 cCodPosRes                                   || cSeparador ||
                 X.TelRes                                     || cSeparador ||
                 X.Num_Tributario                             || cSeparador ||
                 cNumExterior                                 || cSeparador ||
                 cNumInterior                                 || cSeparador ||
                 cEmailsFactElect                             || cSeparador || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      nLinea  := NVL(nLinea,0) + 1;
   END LOOP;
END ARCHIVO_CLIENTES_FACT_ELECT;

PROCEDURE ARCHIVO_NC_FACT_ELECT(nCodCia NUMBER, nIdNcr NUMBER, nLinea IN OUT NUMBER) IS
cNum_TributarioCia     EMPRESAS.Num_Tributario%TYPE;
cNum_TributarioCli     PERSONA_NATURAL_JURIDICA.Num_Tributario%TYPE;
cNumPolUnico           POLIZAS.NumPolUnico%TYPE;
nMtoIVA                DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nMtoNetoNcr            NOTAS_DE_CREDITO.Monto_Ncr_Moneda%TYPE;
nPrimaNeta             DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nRecargos              DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nDerechos              DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nImpuesto              DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nTasaIVA               CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
nCodEmpresa            POLIZAS.CodEmpresa%TYPE;
cCodPlanPagos          PLAN_DE_PAGOS.CodPlanPago%TYPE;
cIndFacturaPol         POLIZAS.IndFacturaPol%TYPE;
nCod_Asegurado         DETALLE_POLIZA.Cod_Asegurado%TYPE;
nCodigoCliente         POLIZAS.CodCliente%TYPE;
cSucursal              VARCHAR2(3)    := '000';
cTipoDocumento         VARCHAR2(30)   := 'Egreso';
--cFormaPago             VARCHAR2(255)  := 'NO IDENTIFICADO';
cFormaPago             VARCHAR2(255)  := 'NA';
cDescFrecPago          VARCHAR2(20);
cCondPago              VARCHAR2(10)   := 'CONTADO';
nCantArticulos         NUMBER(18,6)   := 1;
cSeparador             VARCHAR2(1)    := '|';
cMoneda                VARCHAR2(5);
cDescripcion           VARCHAR2(255);
cCadena                VARCHAR2(4000);
cCodUser               VARCHAR2(30)   := USER;

CURSOR NC_Q IS
   SELECT IdNcr, NumNcr, CodCliente, IdPoliza, IDetPol, IdEndoso,
          CodMoneda, Tasa_Cambio, Monto_Ncr_Moneda, Monto_Ncr_Local,
          IdTransaccion, 1 NumCuota
     FROM NOTAS_DE_CREDITO
    WHERE CodCia             = nCodCia
      AND IdNcr              = nIdNcr -- Se Agrega para Mandar solo NC Seleccionadas por el usuario
      AND IndFactElectronica = 'S'
      AND FecEnvFactElec    IS NULL
    ORDER BY IdNcr;
CURSOR DET_Q IS
   SELECT D.CodCpto, D.Monto_Det_Moneda, D.IndCptoPrima, C.IndCptoServicio
     FROM DETALLE_NOTAS_DE_CREDITO D, NOTAS_DE_CREDITO N, CATALOGO_DE_CONCEPTOS C
    WHERE C.CodConcepto = D.CodCpto
      AND C.CodCia      = N.CodCia
      AND D.IdNcr       = N.IdNcr
      AND N.IdNcr       = nIdNcr;
BEGIN
   cNum_TributarioCia := OC_EMPRESAS.IDENTIFICACION_TRIBUTARIA(nCodCia);

   FOR W IN NC_Q LOOP
      cDescFrecPago      := OC_NOTAS_DE_CREDITO.FRECUENCIA_PAGO(nCodCia, W.IdNcr);
      cMoneda            := OC_MONEDA.CODIGO_SISTEMA_CONTABLE(W.CodMoneda);
      cCodPlanPagos      := OC_NOTAS_DE_CREDITO.CODIGO_PLAN_PAGOS(nCodCia, W.IdNcr);

      BEGIN
         SELECT P.NumPolUnico, P.CodEmpresa, P.IndFacturaPol, D.Cod_Asegurado
           INTO cNumPolUnico, nCodEmpresa, cIndFacturaPol, nCod_Asegurado
           FROM POLIZAS P, DETALLE_POLIZA D
          WHERE D.CodCia    = P.CodCia
            AND D.IdPoliza  = W.IdPoliza
            AND D.IdetPol   = W.IDetPol
            AND P.CodCia    = nCodCia
            AND P.IdPoliza  = W.IdPoliza;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR (-20100,'NO Existe Poliza No. Consecutivo '|| W.IdPoliza || ' ' || SQLERRM);
      END;

      IF cIndFacturaPol = 'S' THEN
         cNum_TributarioCli := OC_CLIENTES.IDENTIFICACION_TRIBUTARIA(W.CodCliente);
         nCodigoCliente     := W.CodCliente;
      ELSE
         BEGIN
            SELECT DECODE(Tipo_Doc_Identificacion,'RFC',Num_Doc_Identificacion,Num_Tributario)
              INTO cNum_TributarioCli
              FROM PERSONA_NATURAL_JURIDICA
             WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN
                   (SELECT Tipo_Doc_Identificacion, Num_Doc_Identificacion
                      FROM ASEGURADO
                     WHERE CodCia        = nCodCia
                       AND CodEmpresa    = nCodEmpresa
                       AND Cod_Asegurado = nCod_Asegurado);
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20225,'No Existe Asegurado: '||TRIM(TO_CHAR(nCod_Asegurado)) || ' en Persona Natural Juridica');
         END;
         IF cNum_TributarioCli IS NULL THEN
            RAISE_APPLICATION_ERROR(-20225,'Asegurado: '||TRIM(TO_CHAR(nCod_Asegurado)) || ' No Posee Identificacion Tributaria');
         END IF;
         nCodigoCliente     := TO_NUMBER('99999' || LPAD(TO_CHAR(nCod_Asegurado),9,'0'));
      END IF;
      nPrimaNeta      := 0;
      nRecargos       := 0;
      nDerechos       := 0;
      nImpuesto       := 0;

      FOR W IN DET_Q LOOP
         IF W.IndCptoPrima = 'S' OR W.IndCptoServicio = 'S' THEN
            nPrimaNeta  := NVL(nPrimaNeta,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'RECFIN' THEN
            nRecargos   := NVL(nRecargos,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'DEREMI' THEN
            nDerechos   := NVL(nDerechos,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'IVASIN' THEN
            nImpuesto   := NVL(nImpuesto,0) + NVL(W.Monto_Det_Moneda,0);
            nTasaIVA    := OC_CONCEPTOS_PLAN_DE_PAGOS.PORCENTAJE_CONCEPTO(nCodCia, nCodEmpresa, cCodPlanPagos, W.CodCpto);
         ELSE
            nImpuesto   := NVL(nImpuesto,0) + NVL(W.Monto_Det_Moneda,0);
         END IF;
      END LOOP;

      -- Prima Neta
      cDescripcion    := 'PRIMAS DE SEGURO DE LA NOTA DE CREDITO ' || TRIM(TO_CHAR(nIdNcr,'0000000000')) || 
                         ' DE LA POLIZA ' || cNumPolUnico;
      nMtoIVA         := NVL(NVL(nPrimaNeta,0) * nTasaIVA / 100,0);

      cCadena := TRIM(TO_CHAR(W.IdNcr,'00000000000000'))        || cSeparador ||
                 TRIM(cNum_TributarioCia)                       || cSeparador ||
                 cSucursal                                      || cSeparador ||
                 TRIM(cNum_TributarioCli)                       || cSeparador ||
                 TRIM(TO_CHAR(nCodigoCliente,'00000000000000')) || cSeparador ||
                 cTipoDocumento                                 || cSeparador ||
                 cFormaPago                                     || cSeparador ||
                 cDescFrecPago                                  || cSeparador ||
                 cCondPago                                      || cSeparador ||
                 TRIM(cMoneda)                                  || cSeparador ||
                 TO_CHAR(SYSDATE,'DD/MM/YYYY HH:MI:SS')         || cSeparador ||
                 TO_CHAR(W.Tasa_Cambio,'00000000.0000')         || cSeparador ||
                 TRIM(TO_CHAR(nCantArticulos,'9999999990'))     || cSeparador ||
                 TO_CHAR(nPrimaNeta,'99999999990.00')           || cSeparador ||
                 TO_CHAR(nPrimaNeta,'99999999990.00')           || cSeparador ||
                 cDescripcion                                   || cSeparador ||
                 TO_CHAR(NVL(nMtoIVA,0),'99999999990.00')       || cSeparador ||
                 '0.00'                                         || cSeparador || -- Descuento
                 'NO APLICA'                                    || cSeparador || -- Unidad de Medida
                 '1'                                            || cSeparador || CHR(13);   -- No. de ArtÃ­culo
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      nLinea  := NVL(nLinea,0) + 1;

      -- Recargo por Pago Fraccionado
      cDescripcion    := 'FINANCIAMIENTO POR PAGO FRACCIONADO';
      nMtoIVA         := NVL(NVL(nRecargos,0) * nTasaIVA / 100,0);

      cCadena := TRIM(TO_CHAR(W.IdNcr,'00000000000000'))        || cSeparador ||
                 TRIM(cNum_TributarioCia)                       || cSeparador ||
                 cSucursal                                      || cSeparador ||
                 TRIM(cNum_TributarioCli)                       || cSeparador ||
                 TRIM(TO_CHAR(nCodigoCliente,'00000000000000')) || cSeparador ||
                 cTipoDocumento                                 || cSeparador ||
                 cFormaPago                                     || cSeparador ||
                 cDescFrecPago                                  || cSeparador ||
                 cCondPago                                      || cSeparador ||
                 TRIM(cMoneda)                                  || cSeparador ||
                 TO_CHAR(SYSDATE,'DD/MM/YYYY HH:MI:SS')         || cSeparador ||
                 TO_CHAR(W.Tasa_Cambio,'00000000.0000')         || cSeparador ||
                 TRIM(TO_CHAR(nCantArticulos,'9999999990'))     || cSeparador ||
                 TO_CHAR(nRecargos,'99999999990.00')            || cSeparador ||
                 TO_CHAR(nRecargos,'99999999990.00')            || cSeparador ||
                 cDescripcion                                   || cSeparador ||
                 TO_CHAR(NVL(nMtoIVA,0),'99999999990.00')       || cSeparador ||
                 '0.00'                                         || cSeparador || -- Descuento
                 'NO APLICA'                                    || cSeparador || -- Unidad de Medida
                 '1'                                            || cSeparador || CHR(13);   -- No. de ArtÃ­culo
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      nLinea  := NVL(nLinea,0) + 1;

      -- Derechos de PÃ³liza o Gastos de ExpediciÃ³n
      cDescripcion    := 'GASTOS DE EXPEDICION';
      nMtoIVA         := NVL(NVL(nDerechos,0) * nTasaIVA / 100,0);

      cCadena := TRIM(TO_CHAR(W.IdNcr,'00000000000000'))        || cSeparador ||
                 TRIM(cNum_TributarioCia)                       || cSeparador ||
                 cSucursal                                      || cSeparador ||
                 TRIM(cNum_TributarioCli)                       || cSeparador ||
                 TRIM(TO_CHAR(nCodigoCliente,'00000000000000')) || cSeparador ||
                 cTipoDocumento                                 || cSeparador ||
                 cFormaPago                                     || cSeparador ||
                 cDescFrecPago                                  || cSeparador ||
                 cCondPago                                      || cSeparador ||
                 TRIM(cMoneda)                                  || cSeparador ||
                 TO_CHAR(SYSDATE,'DD/MM/YYYY HH:MI:SS')         || cSeparador ||
                 TO_CHAR(W.Tasa_Cambio,'00000000.0000')         || cSeparador ||
                 TRIM(TO_CHAR(nCantArticulos,'9999999990'))     || cSeparador ||
                 TO_CHAR(nDerechos,'99999999990.00')            || cSeparador ||
                 TO_CHAR(nDerechos,'99999999990.00')            || cSeparador ||
                 cDescripcion                                   || cSeparador ||
                 TO_CHAR(NVL(nMtoIVA,0),'99999999990.00')       || cSeparador ||
                 '0.00'                                         || cSeparador || -- Descuento
                 'NO APLICA'                                    || cSeparador || -- Unidad de Medida
                 '1'                                            || cSeparador || CHR(13);   -- No. de ArtÃ­culo
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      nLinea  := NVL(nLinea,0) + 1;
   END LOOP;
   UPDATE NOTAS_DE_CREDITO
      SET FecEnvFactElec     = SYSDATE,
          CodUsuarioEnvFact  = USER
    WHERE CodCia             = nCodCia
      AND IdNcr              = nIdNcr -- Se Agrega para Mandar solo NC Seleccionadas por el usuario
      AND IndFactElectronica = 'S'
      AND FecEnvFactElec    IS NULL;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,SQLERRM);
END ARCHIVO_NC_FACT_ELECT;

PROCEDURE ARCHIVO_FACT_ELECT_ANUL_NC(nCodCia NUMBER, nIdNcr NUMBER, nLinea IN OUT NUMBER) IS
cNum_TributarioCia     EMPRESAS.Num_Tributario%TYPE;
cNum_TributarioCli     PERSONA_NATURAL_JURIDICA.Num_Tributario%TYPE;
cNumPolUnico           POLIZAS.NumPolUnico%TYPE;
nMtoIVA                DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nMtoNetoNcr            FACTURAS.Monto_Fact_Moneda%TYPE;
nPrimaNeta             DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nRecargos              DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nDerechos              DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nImpuesto              DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nTasaIVA               CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
nCodEmpresa            POLIZAS.CodEmpresa%TYPE;
cCodPlanPagos          PLAN_DE_PAGOS.CodPlanPago%TYPE;
cIndFacturaPol         POLIZAS.IndFacturaPol%TYPE;
nCod_Asegurado         DETALLE_POLIZA.Cod_Asegurado%TYPE;
nCodigoCliente         POLIZAS.CodCliente%TYPE;
cSucursal              VARCHAR2(3)    := '000';
cTipoDocumento         VARCHAR2(30)   := 'Ingreso';
cFormaPago             VARCHAR2(255)  := 'NO IDENTIFICADO';
cDescFrecPago          VARCHAR2(20);
cCondPago              VARCHAR2(10)   := 'CONTADO';
nCantArticulos         NUMBER(18,6)   := 1;
cSeparador             VARCHAR2(1)    := '|';
cMoneda                VARCHAR2(5);
cDescripcion           VARCHAR2(255);
cCadena                VARCHAR2(4000);
cCodUser               VARCHAR2(30)   := USER;

CURSOR NC_Q IS
   SELECT IdNcr, NumNcr, CodCliente, IdPoliza, IDetPol, IdEndoso,
          CodMoneda, Tasa_Cambio, Monto_Ncr_Moneda, Monto_Ncr_Local,
          IdTransaccion, 1 NumCuota, FolioFactElec
     FROM NOTAS_DE_CREDITO
    WHERE CodCia              = nCodCia
      AND IdNcr               = nIdNcr -- Se Agrega para Mandar solo NC Seleccionadas por el usuario
      AND IndFactElectronica  = 'S'
      AND FolioFactElec       IS NOT NULL
      AND FecEnvFactElecAnu   IS NULL
    ORDER BY IdNcr;
BEGIN
   cNum_TributarioCia := OC_EMPRESAS.IDENTIFICACION_TRIBUTARIA(nCodCia);

   FOR W IN NC_Q LOOP
      BEGIN
         SELECT P.NumPolUnico, P.CodEmpresa, P.IndFacturaPol, D.Cod_Asegurado
           INTO cNumPolUnico, nCodEmpresa, cIndFacturaPol, nCod_Asegurado
           FROM POLIZAS P, DETALLE_POLIZA D
          WHERE D.CodCia    = P.CodCia
            AND D.IdPoliza  = W.IdPoliza
            AND D.IdetPol   = W.IDetPol
            AND P.CodCia    = nCodCia
            AND P.IdPoliza  = W.IdPoliza;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR (-20100,'NO Existe Poliza No. Consecutivo '|| W.IdPoliza || ' ' || SQLERRM);
      END;

      IF cIndFacturaPol = 'S' THEN
         cNum_TributarioCli := OC_CLIENTES.IDENTIFICACION_TRIBUTARIA(W.CodCliente);
         nCodigoCliente     := W.CodCliente;
      ELSE
         BEGIN
            SELECT DECODE(Tipo_Doc_Identificacion,'RFC',Num_Doc_Identificacion,Num_Tributario)
              INTO cNum_TributarioCli
              FROM PERSONA_NATURAL_JURIDICA
             WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN
                   (SELECT Tipo_Doc_Identificacion, Num_Doc_Identificacion
                      FROM ASEGURADO
                     WHERE CodCia        = nCodCia
                       AND CodEmpresa    = nCodEmpresa
                       AND Cod_Asegurado = nCod_Asegurado);
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20225,'No Existe Asegurado: '||TRIM(TO_CHAR(nCod_Asegurado)) || ' en Persona Natural Juridica');
         END;
         IF cNum_TributarioCli IS NULL THEN
            RAISE_APPLICATION_ERROR(-20225,'Asegurado: '||TRIM(TO_CHAR(nCod_Asegurado)) || ' No Posee Identificacion Tributaria');
         END IF;
         nCodigoCliente     := TO_NUMBER('99999' || LPAD(TO_CHAR(nCod_Asegurado),9,'0'));
      END IF;

      cCadena := TRIM(cNum_TributarioCia)                       || cSeparador ||
                 TRIM(cNum_TributarioCli)                       || cSeparador ||
                 TRIM(W.FolioFactElec)                          || cSeparador || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      nLinea  := NVL(nLinea,0) + 1;
   END LOOP;
   UPDATE NOTAS_DE_CREDITO
      SET FecEnvFactElecAnu     = SYSDATE,
          CodUsuarioEnvFactAnu  = USER
    WHERE CodCia                = nCodCia
      AND IdNcr                 = nIdNcr
      AND IndFactElectronica    = 'S'
      AND FolioFactElec        IS NOT NULL
      AND FecEnvFactElecAnu    IS NULL;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,SQLERRM);
END ARCHIVO_FACT_ELECT_ANUL_NC;

FUNCTION FRECUENCIA_PAGO(nCodCia NUMBER, nIdNcr NUMBER) RETURN VARCHAR2 IS
nIdPoliza      NOTAS_DE_CREDITO.IdPoliza%TYPE;
nIDetPol       NOTAS_DE_CREDITO.IDetPol%TYPE;
nIdEndoso      NOTAS_DE_CREDITO.IdEndoso%TYPE;
cCodPlanPago   PLAN_DE_PAGOS.CodPlanPago%TYPE;
nCodEmpresa    POLIZAS.CodEmpresa%TYPE;
cDescFrecPago  VARCHAR2(20);
nFrecPagos     PLAN_DE_PAGOS.FrecPagos%TYPE;
BEGIN
   SELECT IdPoliza, IDetPol, IdEndoso
     INTO nIdPoliza, nIDetPol, nIdEndoso
     FROM NOTAS_DE_CREDITO
    WHERE CodCia    = nCodCia
      AND IdNcr     = nIdNcr;

   IF NVL(nIdEndoso,0) != 0 THEN
      BEGIN
         SELECT CodPlanPago, CodEmpresa
           INTO cCodPlanPago, nCodEmpresa
           FROM ENDOSOS
          WHERE CodCia     = nCodCia
            AND IdPoliza   = nIdPoliza
            AND IDetPol    = nIDetPol
            AND IdEndoso   = nIdEndoso;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cCodPlanPago := NULL;
         WHEN TOO_MANY_ROWS THEN
            cCodPlanPago := NULL;
      END;
    ELSE
      BEGIN
         SELECT CodPlanPago, CodEmpresa
           INTO cCodPlanPago, nCodEmpresa
           FROM DETALLE_POLIZA
          WHERE CodCia     = nCodCia
            AND IdPoliza   = nIdPoliza
            AND IDetPol    = nIDetPol;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cCodPlanPago := NULL;
         WHEN TOO_MANY_ROWS THEN
            cCodPlanPago := NULL;
      END;
      IF cCodPlanPago IS NULL THEN
         BEGIN
            SELECT CodPlanPago, CodEmpresa
              INTO cCodPlanPago, nCodEmpresa
              FROM POLIZAS
             WHERE CodCia     = nCodCia
               AND IdPoliza   = nIdPoliza;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cCodPlanPago := NULL;
            WHEN TOO_MANY_ROWS THEN
               cCodPlanPago := NULL;
         END;
      END IF;
   END IF;
   IF cCodPlanPago IS NULL THEN
      cDescFrecPago   := 'CONTADO';
   ELSE
      BEGIN
         SELECT FrecPagos
           INTO nFrecPagos
           FROM PLAN_DE_PAGOS
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND CodPlanPago = cCodPlanPago;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            nFrecPagos := 12;
         WHEN TOO_MANY_ROWS THEN
            nFrecPagos := 12;
      END;
      IF nFrecPagos = 12 THEN
         cDescFrecPago := 'CONTADO';
      ELSIF nFrecPagos = 2 THEN
         cDescFrecPago := 'BIMENSUAL';
      ELSIF nFrecPagos = 3 THEN
         cDescFrecPago := 'TRIMESTRAL';
      ELSIF nFrecPagos = 6 THEN
         cDescFrecPago := 'SEMESTRAL';
      ELSIF nFrecPagos = 1 THEN
         cDescFrecPago := 'MENSUAL';
      END IF;
   END IF;
   RETURN(cDescFrecPago);
END FRECUENCIA_PAGO;

FUNCTION CODIGO_PLAN_PAGOS(nCodCia NUMBER, nIdNcr NUMBER) RETURN VARCHAR2 IS
nIdPoliza      NOTAS_DE_CREDITO.IdPoliza%TYPE;
nIDetPol       NOTAS_DE_CREDITO.IDetPol%TYPE;
nIdEndoso      NOTAS_DE_CREDITO.IdEndoso%TYPE;
cCodPlanPago   PLAN_DE_PAGOS.CodPlanPago%TYPE;
BEGIN
   SELECT IdPoliza, IDetPol, IdEndoso
     INTO nIdPoliza, nIDetPol, nIdEndoso
     FROM NOTAS_DE_CREDITO
    WHERE CodCia    = nCodCia
      AND IdNcr     = nIdNcr;

   IF NVL(nIdEndoso,0) != 0 THEN
      BEGIN
         SELECT CodPlanPago
           INTO cCodPlanPago
           FROM ENDOSOS
          WHERE CodCia     = nCodCia
            AND IdPoliza   = nIdPoliza
            AND IDetPol    = nIDetPol
            AND IdEndoso   = nIdEndoso;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cCodPlanPago := NULL;
         WHEN TOO_MANY_ROWS THEN
            cCodPlanPago := NULL;
      END;
    ELSE
      BEGIN
         SELECT CodPlanPago
           INTO cCodPlanPago
           FROM DETALLE_POLIZA
          WHERE CodCia     = nCodCia
            AND IdPoliza   = nIdPoliza
            AND IDetPol    = nIDetPol;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cCodPlanPago := NULL;
         WHEN TOO_MANY_ROWS THEN
            cCodPlanPago := NULL;
      END;
      IF cCodPlanPago IS NULL THEN
         BEGIN
            SELECT CodPlanPago
              INTO cCodPlanPago
              FROM POLIZAS
             WHERE CodCia     = nCodCia
               AND IdPoliza   = nIdPoliza;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cCodPlanPago := NULL;
            WHEN TOO_MANY_ROWS THEN
               cCodPlanPago := NULL;
         END;
      END IF;
   END IF;
   RETURN(cCodPlanPago);
END CODIGO_PLAN_PAGOS;

PROCEDURE REHABILITACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdNcrAnu NUMBER, nIdTransaccion NUMBER) IS
nIdNcr    NOTAS_DE_CREDITO.IdNcr%TYPE;


CURSOR NCR_Q IS
   SELECT IdPoliza,            IDetPol,             CodCliente,         FecDevol, 
          Monto_Ncr_Local,     Monto_Ncr_Moneda,    IdEndoso,           MtoComisi_Local, 
          MtoComisi_Moneda,    Tasa_Cambio,         Cod_Agente,         CodTipoDoc,
          CodMoneda,           IndFactElectronica,   FECFINVIG,         CODPLANPAGO           --ICOFINVIG
     FROM NOTAS_DE_CREDITO
    WHERE CodCia = nCodCia
      AND IdNcr  = nIdNcrAnu;
CURSOR DET_Q IS
   SELECT CodCpto, Monto_Det_Local, Monto_Det_Moneda,
          IndCptoPrima, MtoOrigDetLocal, MtoOrigDetMoneda          
     FROM DETALLE_NOTAS_DE_CREDITO
    WHERE IdNcr  = nIdNcrAnu;
BEGIN
   FOR W IN NCR_Q LOOP
      nIdNcr := OC_NOTAS_DE_CREDITO.INSERTA_NOTA_CREDITO(nCodCia, W.IdPoliza, W.IDetPol, W.IdEndoso, W.CodCliente,
                                                         W.FecDevol,  W.Monto_Ncr_Local, W.Monto_Ncr_Moneda, W.MtoComisi_Local,
                                                         W.MtoComisi_Moneda, W.Cod_Agente, W.CodMoneda, W.Tasa_Cambio,
                                                         nIdTransaccion, W.IndFactElectronica);
 
      -- ICOFINVIG
      UPDATE NOTAS_DE_CREDITO f
         SET Fecfinvig     = W.FECFINVIG,     
             Codplanpago   = W.CODPLANPAGO 
       WHERE CodCia = nCodCia
         AND IdNcr  = nIdNcr;
      -- ICOFINVIG
      OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa, 18, 'REHNCR', 'NOTAS_DE_CREDITO',
                                  W.IdPoliza, W.IDetPol, NULL, nIdNcr, W.Monto_Ncr_Moneda);

      FOR Z IN DET_Q LOOP
         INSERT INTO DETALLE_NOTAS_DE_CREDITO
               (IdNcr, CodCpto, Monto_Det_Local, Monto_Det_Moneda, IndCptoPrima,
                MtoOrigDetLocal, MtoOrigDetMoneda)
         VALUES(nIdNcr, Z.CodCpto, Z.Monto_Det_Local, Z.Monto_Det_Moneda, Z.IndCptoPrima,
                Z.MtoOrigDetLocal, Z.MtoOrigDetMoneda);
      END LOOP;
      --
      OC_NOTAS_DE_CREDITO.EMITIR(nIdNcr, NULL);
      --
      OC_COMISIONES.INSERTA_COMISION_NC(nIdNcr);
      --
      -- ESTE BLOQUE ES EN LA VERSION DE PRUEBAS SE COLOCA PARA NO PERDER EL CAMBIO AEVS
      --
      BEGIN 
        UPDATE NOTAS_DE_CREDITO
           SET IdNcrRehab = nIdNcr
         WHERE CodCia = nCodCia
           AND IdNcr  = nIdNcrAnu; 
      EXCEPTION 
        WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR (-20100,'No Existe la Nota de Credito Anulada No. ' || nIdNcrAnu);
        WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR (-20100,'Problemas en la Nota de Credito Anulada No. ' || nIdNcrAnu);
      END;
      --      
   END LOOP;
END REHABILITACION;


FUNCTION VIGENCIA_FINAL(nCodCia        NUMBER,   nCodEmpresa    NUMBER,  nIdPoliza      NUMBER, 
                        nIdEndoso      NUMBER,   dFecDevol      DATE,    dFecFinVigPol  DATE,    
                        cCodPlanPago   VARCHAR2) RETURN DATE IS   -- INICIA FINVIG  LARPLA
cCodPlanPagos    PLAN_DE_PAGOS.CodPlanPago%TYPE;
nFrecPagos       PLAN_DE_PAGOS.FrecPagos%TYPE;
cTipoEndoso      ENDOSOS.TipoEndoso%TYPE;
dFecFinVig       ENDOSOS.FecFinVig%TYPE;
cDescFormaPago   VARCHAR2(100);
dFecFinVigNcr    DATE;
BEGIN
   --
   nFrecPagos      := OC_PLAN_DE_PAGOS.FRECUENCIA_PAGOS(nCodCia, nCodEmpresa, cCodPlanPago);

   IF nIdEndoso != 0 THEN
      BEGIN
         SELECT TipoEndoso,  FecFinVig
           INTO cTipoEndoso, dFecFinVig
           FROM ENDOSOS
          WHERE IdPoliza  = nIdPoliza
            AND IdEndoso  = nIdEndoso
            AND CodCia    = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cTipoEndoso := NULL;
      END;
   ELSE
      cTipoEndoso := NULL;
   END IF;

   IF cTipoEndoso IN ('NSS') THEN
      dFecFinVigNcr  := dFecFinVig;
   ELSE
      IF nFrecPagos NOT IN (15,7) THEN
         dFecFinVigNcr := ADD_MONTHS(dFecDevol, nFrecPagos);
      ELSE
         dFecFinVigNcr := dFecDevol + nFrecPagos;
      END IF;
      IF dFecFinVigNcr > dFecFinVigPol THEN
         dFecFinVigNcr := dFecFinVigPol;
      END IF;
   END IF;
   --
   RETURN(dFecFinVigNcr);
   --
END VIGENCIA_FINAL;

PROCEDURE REVERTIR_APLICACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdnCR NUMBER) IS
nIdTransaccion       TRANSACCION.IdTransaccion%TYPE;
CURSOR NC_Q IS
   SELECT IdPoliza, IDetPol, IdEndoso, IdNcr, 
          Monto_Ncr_Moneda, Monto_Ncr_Local
     FROM NOTAS_DE_CREDITO
    WHERE IdNcr   = nIdNcr
      AND CodCia  = nCodCia;
BEGIN
   FOR W IN NC_Q LOOP
      IF NVL(nIdTransaccion,0) = 0 THEN
         nIdTransaccion := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 19, 'APLNCR');
      END IF;

      OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa, 19, 'REAPNC', 'NOTAS_DE_CREDITO',
                                  W.IdPoliza, W.IDetPol, W.IdEndoso, W.IdnCR, W.Monto_Ncr_Moneda);

      UPDATE NOTAS_DE_CREDITO
         SET StsNcr             = 'EMI',
             FecSts             = TRUNC(SYSDATE),
             Saldo_Ncr_Local    = W.Monto_Ncr_Local,
             Saldo_Ncr_Moneda   = W.Monto_Ncr_Moneda,
             IdTransacRevAplic  = nIdTransaccion
       WHERE IdNcr = W.IdNcr;

      UPDATE COMISIONES
         SET Num_Recibo       = NULL,
             Fec_Estado       = TRUNC(SYSDATE),
             Estado           = 'PRY',
             Com_Saldo_Moneda = Comision_Moneda,
             Com_Saldo_Local  = Comision_Local
       WHERE IdNcr     = W.IdNcr
         AND Estado   != 'LIQ';
   END LOOP;
   OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');
END REVERTIR_APLICACION;

FUNCTION FACTURA_ELECTRONICA(nIdNcr  NUMBER, nCodCia  NUMBER, nCodEmpresa  NUMBER, 
                             cTipoCfdi VARCHAR2, cIndRelaciona VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 IS
    cCodRespuesta PARAMETROS_GLOBALES.Descripcion%TYPE;
    cStsNcr      NOTAS_DE_CREDITO.StsNcr%TYPE;         
    cProceso      VALORES_DE_LISTAS.CodValor%TYPE;  
    cIndRel       VARCHAR2(1);  
    cIndEnvia     VARCHAR2(1) := 'N';                  
BEGIN
    BEGIN
        SELECT StsNcr
          INTO cStsNcr
          FROM NOTAS_DE_CREDITO
         WHERE IdNcr = nIdNcr;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR (-20100,'No Es Posible Determinar La Nota De Credito '||nIdNcr||' Para Facturar Electronicamente, Por Favor Valide Que Existe La Factura');
    END;
    IF cStsNcr = 'EMI' THEN
        cProceso := 'EMI';
        cIndRel := 'N';
        IF OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_PROCESO(nCodCia, nCodEmpresa, '', nIdNcr, cProceso) = 'N' THEN
            cIndEnvia := 'S';
        ELSE
            cIndEnvia := 'N';
        END IF;
    ELSIF cStsNcr = 'ANU' THEN
        cProceso := 'CAN';
        cIndRel := 'N';
        IF OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_PROCESO(nCodCia, nCodEmpresa, '', nIdNcr, cProceso) = 'N' THEN
            cIndEnvia := 'S';
        ELSE
            cIndEnvia := 'N';
        END IF;
    END IF;
    IF cIndEnvia = 'S' THEN
        OC_FACT_ELECT_CONF_DOCTO.TIMBRAR(NULL, nIdNcr, nCodCia, nCodEmpresa, cProceso, cTipoCfdi, cIndRel, cCodRespuesta);
    END IF;
    RETURN cCodRespuesta;
EXCEPTION
    WHEN OTHERS THEN
        RETURN cCodRespuesta;
END FACTURA_ELECTRONICA;

END OC_NOTAS_DE_CREDITO;
/

--
-- OC_NOTAS_DE_CREDITO  (Synonym) 
--
--  Dependencies: 
--   OC_NOTAS_DE_CREDITO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_NOTAS_DE_CREDITO FOR SICAS_OC.OC_NOTAS_DE_CREDITO
/


GRANT EXECUTE ON SICAS_OC.OC_NOTAS_DE_CREDITO TO PUBLIC
/
