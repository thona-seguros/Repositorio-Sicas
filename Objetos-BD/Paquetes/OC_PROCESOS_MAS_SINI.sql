CREATE OR REPLACE PACKAGE SICAS_OC.OC_PROCESOS_MAS_SINI IS
--
--  28/02/2017  Rutina para constituir solo reserva en INFONACOT      -- JICO ASEGMAS 
--  07/08/2018  Ajuste para cambio especial                           -- JICO INFO2
--  17/08/2018  Devolucion de pagos de INFONACOT                      -- JICO ANUPAG
--  30/04/2019  Disminucion de reserva                                -- JICO AJUSTES
--  06/09/2021  Procesos masivo en solicitud                          -- JICO MASSOL
--  16/12/2021  Reingenieria F2                                       -- JICO RF2
--  01/06/2022  Se ajusto insert-values                               -- JICO BMI
--
PROCEDURE PROCESO_REGISTRO(nIdProcMasivo NUMBER, cTipoProceso VARCHAR2);
--
PROCEDURE SINIESTROS_INFONACOT(nIdProcMasivo NUMBER);
--
PROCEDURE SINIESTROS_INFONACOT_EST(nIdProcMasivo NUMBER);   --ASEGMAS
--
PROCEDURE SINIESTROS_INFONACOT_DEV(nIdProcMasivo NUMBER);   --ANUPAG
--
PROCEDURE SINIESTROS_INFONACOT_DRV(nIdProcMasivo NUMBER);   --DISRVA
--
PROCEDURE SINIESTROS_AJUSTES(nIdProcMasivo NUMBER);         --AJUSTES 
--
PROCEDURE SINIESTROS_PAGOS_RVA(nIdProcMasivo NUMBER);
--
FUNCTION OBTIENE_TRANSA_RVA_IND(nIdPoliza NUMBER,    nIdSiniestro NUMBER, 
                                NIDDETSIN NUMBER,    cCodCobert   VARCHAR2, 
                                nNumMod   NUMBER,    DFECHA       DATE) RETURN NUMBER;   
--
FUNCTION OBTIENE_TRANSA_RVA_COL(nIdPoliza  NUMBER,    nIdSiniestro NUMBER,    NIDDETSIN      NUMBER,
                                cCodCobert VARCHAR2,  nNumMod      NUMBER,    nCod_Asegurado NUMBER,   DFECHA DATE) RETURN NUMBER;  
--
FUNCTION OBTIENE_TRANSA_PAG_IND(nNUM_APROBACION NUMBER,   nIdPoliza NUMBER,    nIdSiniestro NUMBER, 
                                NIDDETSIN       NUMBER,   DFECHA    DATE) RETURN NUMBER;
--                                
FUNCTION OBTIENE_TRANSA_PAG_COL(nNUM_APROBACION NUMBER,   nIdPoliza NUMBER,    nIdSiniestro   NUMBER, 
                                NIDDETSIN       NUMBER,   DFECHA    DATE,      nCod_Asegurado NUMBER) RETURN NUMBER;
--                                
PROCEDURE CAMBIA_FECHA_CONTA(nIDTRANSACCION NUMBER, nCodCia NUMBER, DFECHA DATE, nCodEmpresa NUMBER);
--
PROCEDURE CAMBIA_FECHA_OBSERVACION(nIdSiniestro NUMBER, nIdPoliza NUMBER, DFECHA DATE); 
--
PROCEDURE MARCA_NO_ENVIO_CONTABILIDAD(nIDTRANSACCION NUMBER, nCodCia NUMBER, DFECHA DATE); 
--
PROCEDURE MASIVOS_SOLICITUD_RESERVA(nIdProcMasivo NUMBER);         --MASSOL 
--
PROCEDURE SOLICITUD_RESERVA(NCODCIA        NUMBER,   NCODEMPRESA  NUMBER,     NIDSINIESTRO    NUMBER,
                            NIDDETSIN      NUMBER,   CCODCOBERT   VARCHAR2,   CCODCPTOTRANSAC VARCHAR2,
                            NMONTO_RES_MON NUMBER,   CID_COL_INDI VARCHAR2,   nIdProcMasivo   NUMBER);          
--
PROCEDURE SOLICITUD_RESERVA_BORRADO(NCODCIA   NUMBER,   NCODEMPRESA   NUMBER,     NIDSINIESTRO   NUMBER,
                                    NIDDETSIN NUMBER,   CCODCOBERT    VARCHAR2,   CID_COL_INDI   VARCHAR2,   
                                    NNUMMOD   NUMBER,   nIdProcMasivo NUMBER);
--                                    
PROCEDURE SOLICITUD_RESERVA_EMISION(NCODCIA       NUMBER,     NCODEMPRESA NUMBER,     NIDSINIESTRO   NUMBER,
                                    NIDDETSIN     NUMBER,     CCODCOBERT  VARCHAR2,   NMONTO_RES_MON NUMBER,   
                                    CID_COL_INDI  VARCHAR2,   NNUMMOD     NUMBER,     CDESCRIPCION   VARCHAR2,
                                    DFECRES        DATE,      nIdProcMasivo NUMBER);          
--
PROCEDURE MASIVOS_SOLICITUD_PAGOS(nIdProcMasivo NUMBER);
--
PROCEDURE SOLICITUD_PAGOS(NCODCIA       NUMBER,   NCODEMPRESA     NUMBER,   NIDSINIESTRO NUMBER,
                          NIDDETSIN     NUMBER,   NNUM_APROBACION NUMBER,   CID_COL_INDI VARCHAR2,   
                          nIdProcMasivo NUMBER);     
--
PROCEDURE SOLICITUD_PAGOS_BORRADO(NCODCIA       NUMBER,   NCODEMPRESA     NUMBER,   NIDSINIESTRO NUMBER,  
                                  NIDDETSIN     NUMBER,   NNUM_APROBACION NUMBER,   CID_COL_INDI VARCHAR2,
                                  nIdProcMasivo NUMBER);
--
PROCEDURE SOLICITUD_PAGOS_EMISION(NCODCIA      NUMBER,     NCODEMPRESA     NUMBER,   NIDSINIESTRO  NUMBER,
                                  NIDDETSIN    NUMBER,     NNUM_APROBACION NUMBER,   CID_COL_INDI  VARCHAR2,   
                                  CDESCRIPCION VARCHAR2,   DFECPAGO        DATE,     nIdProcMasivo NUMBER);    

--- MLJS 18/06/2025 FUNCIONES PARA LA CARGA MASIVA DE PAGOS DE SINIESTRO
FUNCTION FN_VALIDARESERVA_SOL(PIDSINIESTRO IN NUMBER) RETURN VARCHAR2;
FUNCTION FN_VALIDARESERVA_EMI(PIDSINIESTRO IN NUMBER) RETURN VARCHAR2;
FUNCTION CREAR(cCodCia NUMBER, cCodEmpresa NUMBER) RETURN NUMBER;
FUNCTION CAMBIA_CARACTERES(CADENA_ENTRADA VARCHAR2) RETURN VARCHAR2;
PROCEDURE CONVERT_TO_CLOB;
PROCEDURE SP_CARGA_ARCHIVO(P_CODCIA NUMBER, P_CODEMPRESA NUMBER, P_TIPOPROCESO VARCHAR2, P_DESC_TPO_PROC VARCHAR2, P_LINEA VARCHAR2, P_CODUSUARIO VARCHAR2, 
                           P_TERMINAL VARCHAR2, P_NLINEA OUT NUMBER, P_MENSAJE OUT VARCHAR2);                                  
--
END OC_PROCESOS_MAS_SINI;
/
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_PROCESOS_MAS_SINI IS
--
--  28/02/2017  Rutina para constituir solo reserva en INFONACOT      -- JICO ASEGMAS 
--  07/08/2018  Ajuste para cambio especial                           -- JICO INFO2
--  17/08/2018  Devolucion de pagos de INFONACOT                      -- JICO ANUPAG
--  30/04/2019  Disminucion de reserva                                -- JICO AJUSTES
--  06/09/2021  Procesos masivo en solicitud                          -- JICO MASSOL
--  06/09/2021  Reingenieria F2                                       -- JICO RF2
--  01/06/2022  Se ajusto insert-values BMI                              -- JICO BMI
--
PROCEDURE PROCESO_REGISTRO(nIdProcMasivo NUMBER, cTipoProceso VARCHAR2) IS
BEGIN
   IF cTipoProceso = 'SINCER' THEN
      OC_PROCESOS_MAS_SINI.SINIESTROS_INFONACOT(nIdProcMasivo);      --INFO2
   ELSIF cTipoProceso = 'SINDEV' THEN
      OC_PROCESOS_MAS_SINI.SINIESTROS_INFONACOT_DEV(nIdProcMasivo);  --ANUPAG
   ELSIF cTipoProceso = 'SINEST' THEN                                  
      OC_PROCESOS_MASIVOS.SINIESTROS_INFONACOT_EST(nIdProcMasivo);   --ASEGMAS
   ELSIF cTipoProceso = 'SINDRV' THEN                                  
      OC_PROCESOS_MAS_SINI.SINIESTROS_INFONACOT_DRV(nIdProcMasivo);  --DISRVA
   ELSIF cTipoProceso = 'SINAJU' THEN                                  
      OC_PROCESOS_MAS_SINI.SINIESTROS_AJUSTES(nIdProcMasivo);        --AJUSTES
   ELSIF cTipoProceso = 'SINRPA' THEN                                  
      OC_PROCESOS_MAS_SINI.SINIESTROS_AJUSTES(nIdProcMasivo);        --AJUSTES CONSTITUYE RESERVA
      OC_PROCESOS_MAS_SINI.SINIESTROS_PAGOS_RVA(nIdProcMasivo);      --AJUSTES GENERA PAGO
   ELSIF cTipoProceso = 'SIAJRE' THEN                                  
      OC_PROCESOS_MAS_SINI.MASIVOS_SOLICITUD_RESERVA(nIdProcMasivo);  --MASSOL
   ELSIF cTipoProceso = 'SIAJPA' THEN
DBMS_OUTPUT.put_line('PROCESO_REGISTRO -> '||nIdProcMasivo); 
      OC_PROCESOS_MAS_SINI.MASIVOS_SOLICITUD_PAGOS(nIdProcMasivo);    --MASSOL
   END IF;
END PROCESO_REGISTRO;
--
--
PROCEDURE SINIESTROS_INFONACOT(nIdProcMasivo NUMBER) IS     -- INFOSINI  INICIO
cCodPlantilla          CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE;
cNumSiniRef            SINIESTRO.NumSiniRef%TYPE;
cMotivSiniestro        SINIESTRO.Motivo_de_Siniestro%TYPE;
cCodPaisOcurr          SINIESTRO.CodPaisOcurr%TYPE := '001';
cCodProvOcurr          SINIESTRO.CodProvOcurr%TYPE := '009'; -- No estan mandando la direccion del Trabajador, por lo que por default es D.F.
dFec_Ocurrencia        SINIESTRO.Fec_Ocurrencia%TYPE;
dFec_Notificacion      SINIESTRO.Fec_Notificacion%TYPE;
cDescSiniestro         OBSERVACION_SINIESTRO.Descripcion%TYPE;
nIdSiniestro           SINIESTRO.IdSiniestro%TYPE;
nIdPoliza              POLIZAS.IdPoliza%TYPE;
nIDetPol               SINIESTRO.IDetPol%TYPE;
nCodCia                POLIZAS.CodCia%TYPE;
nCodEmpresa            POLIZAS.CodEmpresa%TYPE;
nEstimacionLocal       SINIESTRO.Monto_Reserva_Local%TYPE;
nEstimacionMoneda      SINIESTRO.Monto_Reserva_Moneda%TYPE;
cCod_Moneda            POLIZAS.Cod_Moneda%TYPE;
cIdTipoSeg             DETALLE_POLIZA.IdTipoSeg%TYPE;
nTasaCambio            DETALLE_POLIZA.Tasa_Cambio%TYPE;
cStsDetalle            DETALLE_POLIZA.StsDetalle%TYPE;
nCod_Asegurado         ASEGURADO.Cod_Asegurado%TYPE;
nCodCliente            CLIENTE_ASEG.CodCliente%TYPE;
cCodCobert             COBERT_ACT_ASEG.CodCobert%TYPE;
cCodTransac            COBERTURA_SINIESTRO.CodTransac%TYPE;
cCodCptoTransac        COBERTURA_SINIESTRO.CodCptoTransac%TYPE;
nNumMod                COBERTURA_SINIESTRO.NumMod%TYPE;
nMonto_Reserva_Local   SINIESTRO.Monto_Reserva_Local%TYPE;
nMonto_Reserva_Moneda  SINIESTRO.Monto_Reserva_Moneda%TYPE;
nOrden                 NUMBER(10):= 1;
nOrdenInc              NUMBER(10);
cUpdate                VARCHAR2(4000);
cMsjError              PROCESOS_MASIVOS_LOG.TxtError%TYPE := NULL;
cExisteDatPart         VARCHAR2(1);
cExisteCob             VARCHAR2(1);
dFecIniVig             POLIZAS.FECINIVIG%TYPE;
dFecFinVig             POLIZAS.FECFINVIG%TYPE;
dFecAnul               POLIZAS.FECANUL%TYPE;
cMotivAnul             POLIZAS.MOTIVANUL%TYPE;
cTipoSiniestro         SINIESTRO.TIPO_SINIESTRO%TYPE;
nCod_AseguradoSini     ASEGURADO.Cod_Asegurado%TYPE;
dFecProceso            DATE;
nCodError              NUMBER(2) := Null;
cIdCredThona           VARCHAR2(30);
nCobertINFO            NUMBER(2);
nNroCuota              NUMBER(2);
nCuota                 NUMBER(14,2);
nIdCredito             INFO_ALTBAJ.Id_Credito%TYPE;
nIdTrabaj              INFO_ALTBAJ.Id_Trabajador%TYPE;
nNumRemesa             INFO_ALTBAJ.Nu_Remesa%TYPE;
cIdInfoPoliza          INFO_SINIESTRO.Id_Poliza%TYPE;
nIdInfoEndoso          INFO_SINIESTRO.Id_Endoso%TYPE;
nIdInfoAsegura         INFO_SINIESTRO.Id_Aseguradora%TYPE;
W_ID_ENVIO             INFO_SINIESTRO.ID_ENVIO%TYPE;
W_CODERRORCARGA        INFO_SINIESTRO.CODERRORCARGA%TYPE;
W_NU_PAGOS             NUMBER(3);  --INFO2
cCodTransacPgo         DETALLE_APROBACION.CodTransac%TYPE;
cCodCptoTranPgo        DETALLE_APROBACION.CodCptoTransac%TYPE;
cTipoAprobacion        APROBACIONES.Tipo_Aprobacion%TYPE := 'P';
nNum_Aprobacion        APROBACIONES.Num_Aprobacion%TYPE;
nBenef                 BENEF_SIN.Benef%TYPE;
cNombreBenef           BENEF_SIN.Nombre%TYPE;
cApellPatBenef         BENEF_SIN.Apellido_Paterno%TYPE;
cApellMatBenef         BENEF_SIN.Apellido_Materno%TYPE;
cObservacion           VARCHAR2(100) := 'Siniestro Pagado';
cCtaCLABE              BENEF_SIN.Cuenta_Clave%TYPE;
--
CURSOR C_CAMPOS_PART  IS
   SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.OrdenDatoPart
     FROM CONFIG_PLANTILLAS_CAMPOS C
    WHERE C.CodPlantilla = cCodPlantilla
      AND C.CodEmpresa   = nCodEmpresa
      AND C.CodCia       = nCodCia
      AND C.NomTabla     = 'DATOS_PART_SINIESTROS'
      AND C.IndDatoPart  = 'S'
    ORDER BY OrdenDatoPart,OrdenCampo;

CURSOR SIN_Q IS
   SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
          NumDetUnico, RegDatosProc, TipoProceso, IndColectiva
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;
--
BEGIN
  --
/*
  BEGIN  -- GRABA
   SELECT A.CAGE_VALOR_CORTO
     INTO W_GRABA
     FROM SAI_CAT_GENERAL A
    WHERE A.CAGE_CD_CATALOGO = 100
      AND A.CAGE_CD_CLAVE_SEG = 1
      AND A.CAGE_CD_CLAVE_TER = 3
      AND A.CAGE_CD_ESTATUS   = 'A';
  EXCEPTION
    WHEN OTHERS THEN
         W_GRABA := 'N';  
  END;
  --
  IF W_GRABA = 'S' THEN
     GRABA := TRUE;
  ELSE
     GRABA := FALSE;
  END IF; -- FIN GRABA
  --
IF GRABA THEN GRABA_TIEMPO(3,nIdProcMasivo,'OC_PROCESOS_MASIVOS-SINIESTROS INFONACOT',1,'');  END IF;
*/
  --
DBMS_OUTPUT.PUT_LINE('OC_PROCESOS_MAS_SINI');  
  FOR X IN SIN_Q LOOP
    nCodCia           := X.CodCia;
    nCodempresa       := X.CodEmpresa;
    cMsjError         := NULL;
    cIdInfoPoliza     :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,1,','));
    nIdInfoEndoso     := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,2,',')));
    nIdInfoAsegura    := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,3,',')));
    nIdCredito        := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,4,',')));
    nIdTrabaj         := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,5,',')));
    nCobertINFO       := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,22,','))); 
    W_ID_ENVIO        := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,23,','))); 
    cCtaCLABE         :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,24,','));
    dFec_Ocurrencia   :=   TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,25,',')),'DD/MM/YYYY');
    cDescSiniestro    := 'ENDOSO: '||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,2,',')); 
    nEstimacionMoneda := TO_NUMBER(TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,13,',')),'999999999990.00'); 
    --
    BEGIN
      SELECT P.IdPoliza,      P.Cod_Moneda,      DP.FecIniVig,       DP.FecFinVig, 
             P.FecAnul,       P.MotivAnul,       Dp.IDetPol,         Dp.StsDetalle,
             P.CodCliente,    Dp.Cod_Asegurado,  I.Nu_Remesa,        I.Id_Credito_Thona,
             DP.IdTipoSeg,    
             TRUNC(MONTHS_BETWEEN(DP.FecIniVig,dFec_Ocurrencia)) NroCuota,
             I.Cuota
        INTO nIdPoliza,       cCod_Moneda,       dFecIniVig,          dFecFinVig, 
             dFecAnul,        cMotivAnul,        nIDetPol,            cStsDetalle,
             nCodCliente,     nCod_Asegurado,    nNumRemesa,          cIdCredThona, 
             cIdTipoSeg, 
             nNroCuota, 
             nCuota
        FROM POLIZAS P, DETALLE_POLIZA DP, INFO_ALTBAJ I
       WHERE I.Id_Credito    = nIdCredito
         AND I.Id_Trabajador = nIdTrabaj
         AND I.IdPoliza      = P.IdPoliza
         AND I.IdPoliza      = DP.IdPoliza
         AND I.IDetPol       = DP.IDetPol
         AND P.CodCia        = X.CodCia
         AND P.CodEmpresa    = X.CodEmpresa
         AND P.StsPoliza   IN ('REN','EMI','ANU');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        nCodError    := 22;
        cObservacion := 'Codigo Error 22: NO EXISTE POLIZA .';
        RAISE_APPLICATION_ERROR(-20225,'Codigo Error 22:  NO EXISTE POLIZA .');
      WHEN OTHERS THEN
           nCodError := 99;
           cObservacion := 'Codigo Error 22: NO EXISTE POLIZA OTHERS.';
           RAISE_APPLICATION_ERROR(-20225,'Codigo Error 22: NO EXISTE POLIZA OTHERS. '||SQLERRM);
    END;
    --
    BEGIN
      SELECT DISTINCT(ISI.CODERRORCARGA)  --INFO2
        INTO W_CODERRORCARGA
        FROM INFO_SINIESTRO ISI
       WHERE ISI.ID_CREDITO    = nIdCredito
         AND ISI.ID_TRABAJADOR = nIdTrabaj
         AND ISI.ID_ENVIO      = W_ID_ENVIO;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        nCodError    := 22;
        cObservacion := 'Codigo Error 22.1: No existe CRED,TRAB,ENVIO';
        RAISE_APPLICATION_ERROR(-20225,cObservacion);
      WHEN TOO_MANY_ROWS  THEN
           nCodError    := 22.1;
           cObservacion := 'Codigo Error 22.1: MAS DE UN CRED,TRAB,ENVIO';
           RAISE_APPLICATION_ERROR(-20225,'Codigo Error 22.1: MAS DE UN CRED,TRAB,ENVIO - '||cNumSiniRef);
      WHEN OTHERS THEN
           nCodError := 99;
           cObservacion := 'Codigo Error 22.1: No existe CRED,TRAB,ENVIO OTHERS';
           RAISE_APPLICATION_ERROR(-20225,'Codigo Error 22.1: No existe CRED,TRAB,ENVIO  OTHERS'||SQLERRM);
    END;
    --
    IF W_CODERRORCARGA > 0 THEN      
        nCodError    := W_CODERRORCARGA;
        cObservacion := 'Codigo Error '||W_CODERRORCARGA||' : Error de validacion.';
        RAISE_APPLICATION_ERROR(-20225,cObservacion);
    END IF;
    --
    cNumSiniRef       := cIdCredThona;
    dFec_Notificacion := TRUNC(SYSDATE);
    nTasaCambio       := OC_GENERALES.TASA_DE_CAMBIO(cCod_Moneda, TRUNC(SYSDATE));
    nEstimacionLocal  := nEstimacionMoneda * nTasaCambio;
    -- Coberturas
    IF nCobertINFO = 1 THEN
       cCodCobert      := 'DESEMP';
       cTipoSiniestro  := '011';
       cMotivSiniestro := '999';
       cCodTransac     := 'APRVAD';
       cCodCptoTransac := 'APRVAD';
       cCodTransacPgo  := 'PARVAD';
       cCodCptoTranPgo := 'PARVAD';
    ELSIF nCobertINFO = 2 THEN
          cCodCobert      := 'INVALI';
          cTipoSiniestro  := '008';
          cMotivSiniestro := '999';
          cCodTransac     := 'APRVAD';
          cCodCptoTransac := 'APRVAD';
          cCodTransacPgo  := 'PARVAD';
          cCodCptoTranPgo := 'PARVAD';
    ELSIF nCobertINFO = 3 THEN
          cCodCobert := 'FALLEC';
          cTipoSiniestro  := '016';
          cMotivSiniestro := '999';
          cCodTransac     := 'ARSBAS';
          cCodCptoTransac := 'APRVBA';
          cCodTransacPgo  := 'PARVBA';
          cCodCptoTranPgo := 'PARVBA';
    ELSIF nCobertINFO = 4 THEN
          cCodCobert := 'DESINV';
          cTipoSiniestro  := '010';
          cMotivSiniestro := '999';
          cCodTransac     := 'APRVAD';
          cCodCptoTransac := 'APRVAD';
          cCodTransacPgo  := 'PARVAD';
          cCodCptoTranPgo := 'PARVAD';
    ELSE
       nCodError := 29;
       cObservacion := 'Error, el Tipo de Cobertura no es válido.';
       RAISE_APPLICATION_ERROR(-20225,'Error, el Tipo de Cobertura no es válido.');
    END IF;
    --
    -- VALIDA SI ES UN AJUSTE O NUEVO SINIESTRO
    --
    BEGIN
      SELECT S.IDSINIESTRO
        INTO nIdSiniestro
        FROM SINIESTRO S
       WHERE NumSiniRef = cNumSiniRef
         AND CodCia     = X.CodCia;
    EXCEPTION 
      WHEN NO_DATA_FOUND  THEN
           nIdSiniestro := 0;
      WHEN OTHERS THEN 
           nIdSiniestro := 0;
    END;
    --
    IF nIdSiniestro = 0 THEN -- Creacion de Siniestro
       --
       nIdSiniestro := OC_SINIESTRO.INSERTA_SINIESTRO(nCodCia, X.CodEmpresa, nIdPoliza, nIDetPol, cNumSiniRef,dFec_Ocurrencia, dFec_Notificacion,
                                                      'Carga Masiva de INFONACOT realizada el ' ||TO_DATE(SYSDATE,'DD/MM/YYYY')||' , con '||cDescSiniestro,
                                                      cTipoSiniestro, cMotivSiniestro, cCodPaisOcurr, cCodProvOcurr);
       BEGIN
         UPDATE SINIESTRO
            SET Cod_Asegurado = nCod_Asegurado
          WHERE CodCia      = nCodCia
            AND IdSiniestro = nIdSiniestro;
       END;
       --
       BEGIN
         OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, nIdPoliza, 'Carga Masiva de INFONACOT, el ' ||
                                                      TO_CHAR(TRUNC(SYSDATE),'DD/MM/YYYY')||' con '||cDescSiniestro);
       EXCEPTION
         WHEN OTHERS THEN
           nCodError := 99;
           cObservacion := 'Error al Insertar la Obervación 1, Favor de validar la información.';
           RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Obervación 2, Favor de validar la información, Error: '||SQLERRM);
       END;
       --
       cCodPlantilla     := OC_CONFIG_PLANTILLAS_PLANCOB.CODIGO_PLANTILLA(nCodCia, nCodempresa, X.IdTipoSeg, X.PlanCob, X.TipoProceso);
       --
       BEGIN
         SELECT 'S'
           INTO cExisteDatPart
           FROM DATOS_PART_SINIESTROS
          WHERE CodCia      = X.CodCia
            AND IdPoliza    = nIdPoliza
            AND IdSiniestro = nIdSiniestro;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           cExisteDatPart := 'N';
       END;
       --
       IF NVL(cExisteDatPart,'N') = 'N' THEN
           INSERT INTO DATOS_PART_SINIESTROS
                  (CodCia, IdSiniestro, IdPoliza, FecSts, StsDatPart, FecProced, IdProcMasivo)
            VALUES(nCodCia, nIdSiniestro, nIdPoliza, TRUNC(SYSDATE), 'SINCER', SYSDATE, nIdProcMasivo);
       END IF;
       --
       FOR I IN C_CAMPOS_PART LOOP
         nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla, X.CodCia, X.CodEmpresa, I.OrdenProceso) + nOrden;
         cUpdate   := 'UPDATE '||'DATOS_PART_SINIESTROS' || ' ' ||
                       'SET'||' ' || 'CAMPO' || I.OrdenDatoPart || '=' || '''' ||
                       LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) || '''' || ' ' ||
                       'WHERE IdPoliza   = ' || nIdPoliza    ||' '||
                       'AND IdSiniestro  = ' || nIdSiniestro ||' '||
                       'AND CodCia       = ' || X.CodCia     ||' '||
                       'AND IdProcMasivo = ' || nIdProcMasivo;
         OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate);
         nOrden := nOrden + 1;
       END LOOP;
       --
       BEGIN
         INSERT INTO DETALLE_SINIESTRO
               (IdSiniestro,        IdPoliza,               IdDetSin,              Monto_Pagado_Moneda, 
                Monto_Pagado_Local, Monto_Reservado_Moneda, Monto_Reservado_Local, IdTipoSeg)
         VALUES(nIdSiniestro,       nIdPoliza,              1,                     0, 
                0,                  nEstimacionMoneda,      nEstimacionLocal,      cIdTipoSeg);
       EXCEPTION
         WHEN OTHERS THEN
           nCodError := 99;
           cObservacion := 'Error DETALLE SINIESTRO (Cero Sini).';
           RAISE_APPLICATION_ERROR(-20225,'DETALLE SINIESTRO (Cero Sini) - Ocurrió el siguiente error: '||SQLERRM);
       END;
       --
       BEGIN
         SELECT 'S'
           INTO cExisteCob
           FROM COBERT_ACT
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND IdPoliza    = nIdPoliza
            AND IdetPol     = nIDetPol
            AND CodCobert   = cCodCobert;
       EXCEPTION
         WHEN NO_DATA_FOUND THEn
           nCodError := 99;
           cObservacion := 'NO Existe Cobertura (SIN Aseg).';
           RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura (SIN Aseg) de '||cCodCobert);
       END;
       --
       IF cExisteCob = 'S' THEN
          BEGIN
            INSERT INTO COBERTURA_SINIESTRO
                  (IdDetSin,              CodCobert,           IdSiniestro,        IdPoliza, 
                   Doc_Ref_Pago,          Monto_Pagado_Moneda, Monto_Pagado_Local, Monto_Reservado_Moneda,
                   Monto_Reservado_Local, StsCobertura,        NumMod,             CodTransac, 
                   CodCptoTransac,        IdTransaccion,       Saldo_Reserva,      IndOrigen, 
                   FecRes,                Saldo_Reserva_Local)
            VALUES(1,                     cCodCobert,          nIdSiniestro,       nIdPoliza, 
                   NULL,                  0,                   0,                  nEstimacionMoneda, 
                   nEstimacionLocal,      'SOL',               1,                  cCodTransac, 
                   cCodCptoTransac,       NULL,                nEstimacionMoneda,  'D',
                   TRUNC(SYSDATE), nEstimacionLocal);
          EXCEPTION
            WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'NO Existe COBERTURA SINIESTRO (Cero Sini).';
              RAISE_APPLICATION_ERROR(-20225,'COBERTURA SINIESTRO (Cero Sini) - Ocurrió el siguiente error: '||SQLERRM);
          END;
       END IF;
       --
       IF nIdSiniestro > 0 THEN
          OC_SINIESTRO.ACTIVAR(X.CodCia, X.CodEmpresa, nIdSiniestro, nIdPoliza, X.NumDetUnico);
       END IF;
       --
    ELSE -- SE APLICA AJUSTE Y ADICIONA EL PAGO AL MISMO SINIESTRO
       --
       BEGIN
         OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, nIdPoliza, 'Carga Masiva de INFONACOT de Ajuste de Reserva, el ' ||
                                                      TO_CHAR(TRUNC(SYSDATE),'DD/MM/YYYY')||' Motivo: '||cDescSiniestro);

       EXCEPTION
         WHEN OTHERS THEN
           nCodError := 99;
           cObservacion := 'Error al Insertar la Obervación 3, Favor de validar la información.';
           RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Obervación 4, Favor de validar la información, Error: '||SQLERRM);
       END;
       --
       BEGIN
         SELECT IdSiniestro,  Monto_Reserva_Local,  Monto_Reserva_Moneda,  IDetPol,  Cod_Asegurado
           INTO nIdSiniestro, nMonto_Reserva_Local, nMonto_Reserva_Moneda, nIDetPol, nCod_AseguradoSini
           FROM SINIESTRO
          WHERE NumSiniRef = cNumSiniRef
            AND CodCia     = X.CodCia;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           RAISE_APPLICATION_ERROR(-20225,'NO Existe Siniestro con Referencia No. : '||cNumSiniRef);
         WHEN TOO_MANY_ROWS THEN
           RAISE_APPLICATION_ERROR(-20225,'Existen Varios Siniestros con Referencia No. : '||cNumSiniRef);
       END;
       --
       IF nEstimacionMoneda > 0 THEN
          cCodTransac     := 'AURVAD';
          cCodCptoTransac := 'AURVAD';
          dFecProceso     := TRUNC(SYSDATE);
       ELSIF nEstimacionMoneda < 0 THEN
             cCodTransac     := 'DIRVAD';
             cCodCptoTransac := 'DIRVAD';
             dFecProceso     := TRUNC(SYSDATE);
             nEstimacionMoneda := nEstimacionMoneda * -1;
       END IF;
       --
       BEGIN
         SELECT NVL(MAX(NumMod),0) + 1  
           INTO nNumMod
           FROM COBERTURA_SINIESTRO
          WHERE IdSiniestro = nIdSiniestro
            AND CodCobert   = cCodCobert
            AND IdPoliza    = nIdPoliza;
       END;
       --
       BEGIN
         SELECT 'S'
           INTO cExisteCob
           FROM COBERT_ACT
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND IdPoliza    = nIdPoliza
            AND IdetPol     = nIDetPol
            AND CodCobert   = cCodCobert;
       EXCEPTION
         WHEN NO_DATA_FOUND THEn
           nCodError := 99;
           cObservacion := 'NO Existe Cobertura (SIN Aseg).';
           RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura (SIN Aseg) de '||cCodCobert);
       END;
       --
       IF cExisteCob = 'S' THEN
          BEGIN
            INSERT INTO COBERTURA_SINIESTRO
             (IdDetSin,              CodCobert,           IdSiniestro,         IdPoliza, 
              Doc_Ref_Pago,          Monto_Pagado_Moneda, Monto_Pagado_Local,  Monto_Reservado_Moneda,
              Monto_Reservado_Local, StsCobertura,        NumMod,              CodTransac,
              CodCptoTransac,        IdTransaccion,       Saldo_Reserva,       IndOrigen,
              FecRes,                Saldo_Reserva_Local)
            VALUES
             (1,                     cCodCobert,          nIdSiniestro,        nIdPoliza, 
             NULL,                   0,                   0,                   nEstimacionMoneda, 
             nEstimacionLocal,       'SOL',               nNumMod,             cCodTransac,
             cCodCptoTransac,        NULL,                nEstimacionMoneda,   'D', 
             TRUNC(SYSDATE),         nEstimacionLocal);
          EXCEPTION
            WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'NO Existe COBERTURA SINIESTRO (Cero Sini).';
              RAISE_APPLICATION_ERROR(-20225,'COBERTURA SINIESTRO (Cero Sini) - Ocurrió el siguiente error: '||SQLERRM);
          END;
       END IF;
       --
       OC_COBERTURA_SINIESTRO.EMITE_RESERVA(nCodCia, nCodEmpresa, nIdSiniestro, nIdPoliza, 1, cCodCobert, nNumMod, NULL);
       --
    END IF;
    --
    -- PROCESO DE PAGOS  INICIO
    --
    -- EVALUA SI YA TUVO UN PAGO  --INFO2
    --
    W_NU_PAGOS := 0;    
    BEGIN
      SELECT COUNT(*)
        INTO W_NU_PAGOS
        FROM SINIESTRO S,
             APROBACIONES A
       WHERE S.IDSINIESTRO = nIdSiniestro
         --
         AND A.IDSINIESTRO = S.IDSINIESTRO;
    END;
    --    
    BEGIN
      OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, nIdPoliza, 'Carga Masiva de INFONACOT de Pagos, el ' ||
                                                   TO_CHAR(TRUNC(SYSDATE),'DD/MM/YYYY')||' Motivo: '||cDescSiniestro);
    EXCEPTION
      WHEN OTHERS THEN
        nCodError := 99;
        cObservacion := 'Error al Insertar la Observación , Favor de validar la información.';
        RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Observación , Favor de validar la información, Error: '||SQLERRM);
    END;
    --
    BEGIN
      nNum_Aprobacion := OC_APROBACIONES.INSERTA_APROBACION(nIdSiniestro, nIdPoliza, nEstimacionLocal,
                                                            nEstimacionMoneda, cTipoAprobacion, 'APR', NULL);
    EXCEPTION
      WHEN OTHERS THEN
        nCodError := 99;
        cObservacion := 'Error al Insertar la Aprobación.';
        RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Aprobación: '|| nIdSiniestro || ' ' || SQLERRM);
    END;
    --
    BEGIN
      INSERT INTO DETALLE_APROBACION
            (Num_Aprobacion,     IdDetAprob,      Cod_Pago,          Monto_Local,
             Monto_Moneda,       IdSiniestro,     CodTransac,        CodCptoTransac)
      VALUES(nNum_Aprobacion,    1,               cCodCobert,        nEstimacionLocal,
             nEstimacionMoneda,  nIdSiniestro,    cCodTransacPgo,    cCodCptoTranPgo);
    EXCEPTION
      WHEN OTHERS THEN
        nCodError := 99;
        cObservacion := 'Insertar en DETALLE APROBACION - Ocurrió el siguiente error.';
        RAISE_APPLICATION_ERROR(-20225,'Insertar en DETALLE APROBACION - Ocurrió el siguiente error: '||SQLERRM);
    END;
    --
    nBenef := 1;
    --
    BEGIN
      SELECT TRIM(PNJ.Nombre), TRIM(PNJ.Apellido_Paterno), TRIM(PNJ.Apellido_Materno)
        INTO cNombreBenef, cApellPatBenef, cApellMatBenef
        FROM CLIENTES CLI, PERSONA_NATURAL_JURIDICA PNJ
       WHERE CLI.Tipo_Doc_Identificacion = PNJ.Tipo_Doc_Identificacion
         AND CLI.Num_Doc_Identificacion  = PNJ.Num_Doc_Identificacion
         AND CLI.CodCliente = nCodCliente;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        nCodError := 99;
        cObservacion := 'CLIENTE NO VALIDO.';
        RAISE_APPLICATION_ERROR(-20225,'CLIENTE NO VALIDO, Error: '||SQLERRM);
      WHEN TOO_MANY_ROWS THEN
        nCodError := 99;
        cObservacion := 'CLIENTE NO VALIDO.';
        RAISE_APPLICATION_ERROR(-20225,'CLIENTE DUPLICADO, Error: '||SQLERRM);
    END;
    --
    IF W_NU_PAGOS = 0 THEN
       BEGIN
         INSERT INTO BENEF_SIN
               (IdSiniestro,         IdPoliza,         Cod_Asegurado,          Benef, 
                Nombre,              Apellido_Paterno, Apellido_Materno,       PorcePart,
                CodParent,           Estado,           Sexo,                   FecEstado, 
                FecAlta,             Obervaciones,     
                IndAplicaISR,        PorcentISR,       Ent_Financiera,      Cuenta_Clave)
         VALUES(nIdSiniestro,        nIdPoliza,        nCod_Asegurado,         nBenef, 
                cNombreBenef,        cApellPatBenef,   cApellMatBenef,         100,
                '0014',              'ACT',            'N',                    TRUNC(SYSDATE),
                TRUNC(SYSDATE),      'Pago por el Siniestro No. ' || cNumSiniRef,
                'N',                 Null,             '072',                  cCtaCLABE);
       EXCEPTION
         WHEN OTHERS THEN
           nCodError := 99;
           cObservacion := 'Error al Insertar Beneficiario de Pago.';
          RAISE_APPLICATION_ERROR(-20225,'Error al Insertar Beneficiario de Pago '|| cNumSiniRef || ' ' || SQLERRM);
       END;
    END IF;
    --
    BEGIN
      UPDATE APROBACIONES
         SET BENEF = nBenef,
             CTALIQUIDADORA = 8601
       WHERE Num_Aprobacion = nNum_Aprobacion
         AND IdSiniestro    = nIdSiniestro
         AND IdPoliza       = nIdPoliza;
    EXCEPTION
      WHEN OTHERS THEN
        nCodError := 99;
        cObservacion := 'Error al Actualizar la Aprobación Aseg con el Beneficiario.';
        RAISE_APPLICATION_ERROR(-20225,'Error al Actualizar la Aprobación Aseg con el Beneficiario '|| cNumSiniRef || ' ' || SQLERRM);
    END;
    --
    BEGIN
      OC_APROBACIONES.PAGAR(X.CodCia, X.CodEmpresa, nNum_Aprobacion, nIdSiniestro, nIdPoliza, 1);
    EXCEPTION
      WHEN OTHERS THEN
        nCodError := 99;
        cObservacion := 'Error al Pagar la Aprobación del Siniestro.';
        RAISE_APPLICATION_ERROR(-20225,'Error al Pagar la Aprobación del Siniestro: '|| nIdSiniestro || ' ' || SQLERRM);
    END;
    --
    -- PROCESO DE PAGOS  FIN
    --
    IF cMsjError IS NULL THEN
       cObservacion := 'Siniestro Pagado';
       nCodError    := 0;
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'PROCE');
    ELSE
       OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','SINIESTROS_INFONACOT No se puede Cargar el Siniestro: '||cMsjError);
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
    END IF;
    --
    OC_PROCESOS_MASIVOS.ACT_INFO_SINI(nIdCredito, nIdTrabaj,W_ID_ENVIO,
                                      nIdSiniestro, dFec_Ocurrencia,cObservacion, nCodError );
  END LOOP;

EXCEPTION
   WHEN OTHERS THEN
     ROLLBACK;
     OC_PROCESOS_MASIVOS.ACT_INFO_SINI(nIdCredito, nIdTrabaj,W_ID_ENVIO,
                                       nIdSiniestro, dFec_Ocurrencia,cObservacion, nCodError );
     OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Error 1: '||SQLERRM);
     OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');

END SINIESTROS_INFONACOT;   -- INFOSINI  FINI
--
--
PROCEDURE SINIESTROS_INFONACOT_EST(nIdProcMasivo NUMBER) IS     -- ASEGMAS  INICIO
cCodPlantilla          CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE;
cNumSiniRef            SINIESTRO.NumSiniRef%TYPE;
cMotivSiniestro        SINIESTRO.Motivo_de_Siniestro%TYPE;
cCodPaisOcurr          SINIESTRO.CodPaisOcurr%TYPE := '001';
cCodProvOcurr          SINIESTRO.CodProvOcurr%TYPE := '009'; -- No están mandando la direccion del Trabajador, por lo que por default es D.F.
dFec_Ocurrencia        SINIESTRO.Fec_Ocurrencia%TYPE;
dFec_Notificacion      SINIESTRO.Fec_Notificacion%TYPE;
cDescSiniestro         OBSERVACION_SINIESTRO.Descripcion%TYPE;
nIdSiniestro           SINIESTRO.IdSiniestro%TYPE;
nIdPoliza              POLIZAS.IdPoliza%TYPE;
nIDetPol               SINIESTRO.IDetPol%TYPE;
nCodCia                POLIZAS.CodCia%TYPE;
nCodEmpresa            POLIZAS.CodEmpresa%TYPE;
nEstimacionLocal       SINIESTRO.Monto_Reserva_Local%TYPE;
nEstimacionMoneda      SINIESTRO.Monto_Reserva_Moneda%TYPE;
cCod_Moneda            POLIZAS.Cod_Moneda%TYPE;
cIdTipoSeg             DETALLE_POLIZA.IdTipoSeg%TYPE;
nTasaCambio            DETALLE_POLIZA.Tasa_Cambio%TYPE;
cStsDetalle            DETALLE_POLIZA.StsDetalle%TYPE;
nCod_Asegurado         ASEGURADO.Cod_Asegurado%TYPE;
nCodCliente            CLIENTE_ASEG.CodCliente%TYPE;
cCodCobert             COBERT_ACT_ASEG.CodCobert%TYPE;
cCodTransac            COBERTURA_SINIESTRO.CodTransac%TYPE;
cCodCptoTransac        COBERTURA_SINIESTRO.CodCptoTransac%TYPE;
nNumMod                COBERTURA_SINIESTRO.NumMod%TYPE;
nMonto_Reserva_Local   SINIESTRO.Monto_Reserva_Local%TYPE;
nMonto_Reserva_Moneda  SINIESTRO.Monto_Reserva_Moneda%TYPE;
nOrden                 NUMBER(10):= 1;
nOrdenInc              NUMBER(10);
cUpdate                VARCHAR2(4000);
cMsjError              PROCESOS_MASIVOS_LOG.TxtError%TYPE := NULL;
cExisteDatPart         VARCHAR2(1);
cExisteCob             VARCHAR2(1);
dFecIniVig             POLIZAS.FECINIVIG%TYPE;
dFecFinVig             POLIZAS.FECFINVIG%TYPE;
dFecAnul               POLIZAS.FECANUL%TYPE;
cMotivAnul             POLIZAS.MOTIVANUL%TYPE;
cTipoSiniestro         SINIESTRO.TIPO_SINIESTRO%TYPE;
nCod_AseguradoSini     ASEGURADO.Cod_Asegurado%TYPE;
dFecProceso            DATE;
nCodError              NUMBER(2) := Null;
cIdCredThona           VARCHAR2(30);
nCobertINFO            NUMBER(2);
nNroCuota              NUMBER(2);
nCuota                 NUMBER(14,2);
nIdCredito             INFO_ALTBAJ.Id_Credito%TYPE;
nIdTrabaj              INFO_ALTBAJ.Id_Trabajador%TYPE;
nNumRemesa             INFO_ALTBAJ.Nu_Remesa%TYPE;
cIdInfoPoliza          INFO_SINIESTRO.Id_Poliza%TYPE;
nIdInfoEndoso          INFO_SINIESTRO.Id_Endoso%TYPE;
nIdInfoAsegura         INFO_SINIESTRO.Id_Aseguradora%TYPE;
W_ID_ENVIO             INFO_SINIESTRO.ID_ENVIO%TYPE;
W_CODERRORCARGA        INFO_SINIESTRO.CODERRORCARGA%TYPE;
W_MENSUALIDAD          INFO_SINIESTRO.MENSUALIDAD%TYPE;
cCodTransacPgo         DETALLE_APROBACION.CodTransac%TYPE;
cCodCptoTranPgo        DETALLE_APROBACION.CodCptoTransac%TYPE;
cObservacion           VARCHAR2(100) := 'Siniestro Pagado';
cCtaCLABE              BENEF_SIN.Cuenta_Clave%TYPE;
--
CURSOR C_CAMPOS_PART  IS
   SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.OrdenDatoPart
     FROM CONFIG_PLANTILLAS_CAMPOS C
    WHERE C.CodPlantilla = cCodPlantilla
      AND C.CodEmpresa   = nCodEmpresa
      AND C.CodCia       = nCodCia
      AND C.NomTabla     = 'DATOS_PART_SINIESTROS'
      AND C.IndDatoPart  = 'S'
    ORDER BY OrdenDatoPart,OrdenCampo;

CURSOR SIN_Q IS
   SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
          NumDetUnico, RegDatosProc, TipoProceso, IndColectiva
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;
--
BEGIN
  --
  FOR X IN SIN_Q LOOP
    nCodCia           := X.CodCia;
    nCodempresa       := X.CodEmpresa;
    cMsjError         := NULL;
    cIdInfoPoliza     :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,1,','));
    nIdInfoEndoso     := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,2,',')));
    nIdInfoAsegura    := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,3,',')));
    nIdCredito        := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,4,',')));
    nIdTrabaj         := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,5,',')));
    nCobertINFO       := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,22,','))); 
    W_ID_ENVIO        := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,23,','))); 
    cCtaCLABE         :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,24,','));
    dFec_Ocurrencia   :=   TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,25,',')),'DD/MM/YYYY');
    cDescSiniestro    := 'ENDOSO: '||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,2,',')); 
    nEstimacionMoneda := TO_NUMBER(TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,13,',')),'999999999990.00'); 
    --
    BEGIN
      SELECT P.IdPoliza,      P.Cod_Moneda,      DP.FecIniVig,       DP.FecFinVig, 
             P.FecAnul,       P.MotivAnul,       Dp.IDetPol,         Dp.StsDetalle,
             P.CodCliente,    Dp.Cod_Asegurado,  I.Nu_Remesa,        I.Id_Credito_Thona,
             DP.IdTipoSeg,    
             TRUNC(MONTHS_BETWEEN(DP.FecIniVig,dFec_Ocurrencia)) NroCuota,
             I.Cuota
        INTO nIdPoliza,       cCod_Moneda,       dFecIniVig,          dFecFinVig, 
             dFecAnul,        cMotivAnul,        nIDetPol,            cStsDetalle,
             nCodCliente,     nCod_Asegurado,    nNumRemesa,          cIdCredThona, 
             cIdTipoSeg, 
             nNroCuota, 
             nCuota
        FROM POLIZAS P, DETALLE_POLIZA DP, INFO_ALTBAJ I
       WHERE I.Id_Credito    = nIdCredito
         AND I.Id_Trabajador = nIdTrabaj
         AND I.IdPoliza      = P.IdPoliza
         AND I.IdPoliza      = DP.IdPoliza
         AND I.IDetPol       = DP.IDetPol
         AND P.CodCia        = X.CodCia
         AND P.CodEmpresa    = X.CodEmpresa
         AND P.StsPoliza   IN ('REN','EMI','ANU');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        nCodError    := 22;
        cObservacion := 'Codigo Error 22: No está reportado en los listados.';
        RAISE_APPLICATION_ERROR(-20225,'Codigo Error 22: No está reportado en los listados.');
    END;
    --
    BEGIN
      SELECT ISI.CODERRORCARGA,
             ISI.MENSUALIDAD
        INTO W_CODERRORCARGA,
             W_MENSUALIDAD
        FROM INFO_SINIESTRO ISI
       WHERE ISI.ID_CREDITO    = nIdCredito
         AND ISI.ID_TRABAJADOR = nIdTrabaj
         AND ISI.ID_ENVIO      = W_ID_ENVIO;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        nCodError    := 22;
        cObservacion := 'Codigo Error 22: No está reportado en los listados.';
        RAISE_APPLICATION_ERROR(-20225,cObservacion);
    END;
    --
    cNumSiniRef       := cIdCredThona;
    dFec_Notificacion := TRUNC(SYSDATE);
    nTasaCambio       := OC_GENERALES.TASA_DE_CAMBIO(cCod_Moneda, TRUNC(SYSDATE));
    nEstimacionLocal  := nEstimacionMoneda * nTasaCambio;
    -- Coberturas
    IF nCobertINFO = 1 THEN
       cCodCobert      := 'DESEMP';
       cTipoSiniestro  := '011';
       cMotivSiniestro := '999';
       cCodTransac     := 'APRVAD';
       cCodCptoTransac := 'APRVAD';
       cCodTransacPgo  := 'PARVAD';
       cCodCptoTranPgo := 'PARVAD';
    ELSIF nCobertINFO = 2 THEN
          cCodCobert      := 'INVALI';
          cTipoSiniestro  := '008';
          cMotivSiniestro := '999';
          cCodTransac     := 'APRVAD';
          cCodCptoTransac := 'APRVAD';
          cCodTransacPgo  := 'PARVAD';
          cCodCptoTranPgo := 'PARVAD';
    ELSIF nCobertINFO = 3 THEN
          cCodCobert := 'FALLEC';
          cTipoSiniestro  := '016';
          cMotivSiniestro := '999';
          cCodTransac     := 'ARSBAS';
          cCodCptoTransac := 'APRVBA';
          cCodTransacPgo  := 'PARVBA';
          cCodCptoTranPgo := 'PARVBA';
    ELSIF nCobertINFO = 4 THEN
          cCodCobert := 'DESINV';
          cTipoSiniestro  := '010';
          cMotivSiniestro := '999';
          cCodTransac     := 'APRVAD';
          cCodCptoTransac := 'APRVAD';
          cCodTransacPgo  := 'PARVAD';
          cCodCptoTranPgo := 'PARVAD';
    ELSE
       nCodError := 29;
       cObservacion := 'Error, el Tipo de Cobertura no es válido.';
       RAISE_APPLICATION_ERROR(-20225,'Error, el Tipo de Cobertura no es válido.');
    END IF;
    --
    -- VALIDA SI ES UN AJUSTE O NUEVO SINIESTRO
    --
    BEGIN
      SELECT S.IDSINIESTRO
        INTO nIdSiniestro
        FROM SINIESTRO S
       WHERE NumSiniRef = cNumSiniRef
         AND CodCia     = X.CodCia;
    EXCEPTION 
      WHEN NO_DATA_FOUND  THEN
           nIdSiniestro := 0;
      WHEN OTHERS THEN 
           nIdSiniestro := 0;
    END;
    --
    IF nIdSiniestro = 0 THEN -- Creacion de Siniestro
       --
       nIdSiniestro := OC_SINIESTRO.INSERTA_SINIESTRO(nCodCia, X.CodEmpresa, nIdPoliza, nIDetPol, cNumSiniRef,dFec_Ocurrencia, dFec_Notificacion,
                                                      'Carga Masiva de INFONACOT realizada el ' ||TO_DATE(SYSDATE,'DD/MM/YYYY')||' , con '||cDescSiniestro,
                                                      cTipoSiniestro, cMotivSiniestro, cCodPaisOcurr, cCodProvOcurr);
       BEGIN
         UPDATE SINIESTRO
            SET Cod_Asegurado = nCod_Asegurado
          WHERE CodCia      = nCodCia
            AND IdSiniestro = nIdSiniestro;
       END;
       --
       BEGIN
         OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, nIdPoliza, 'Carga Masiva de INFONACOT, el ' ||
                                                      TO_CHAR(TRUNC(SYSDATE),'DD/MM/YYYY')||' con '||cDescSiniestro);
       EXCEPTION
         WHEN OTHERS THEN
           nCodError := 99;
           cObservacion := 'Error al Insertar la Obervación 1, Favor de validar la información.';
           RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Obervación 2, Favor de validar la información, Error: '||SQLERRM);
       END;
       --
       cCodPlantilla     := OC_CONFIG_PLANTILLAS_PLANCOB.CODIGO_PLANTILLA(nCodCia, nCodempresa, X.IdTipoSeg, X.PlanCob, X.TipoProceso);
       --
       BEGIN
         SELECT 'S'
           INTO cExisteDatPart
           FROM DATOS_PART_SINIESTROS
          WHERE CodCia      = X.CodCia
            AND IdPoliza    = nIdPoliza
            AND IdSiniestro = nIdSiniestro;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           cExisteDatPart := 'N';
       END;
       --
       IF NVL(cExisteDatPart,'N') = 'N' THEN
           INSERT INTO DATOS_PART_SINIESTROS
                  (CodCia, IdSiniestro, IdPoliza, FecSts, StsDatPart, FecProced, IdProcMasivo)
            VALUES(nCodCia, nIdSiniestro, nIdPoliza, TRUNC(SYSDATE), 'SINEST', SYSDATE, nIdProcMasivo);
       END IF;
       --
       FOR I IN C_CAMPOS_PART LOOP
         nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla, X.CodCia, X.CodEmpresa, I.OrdenProceso) + nOrden;
         cUpdate   := 'UPDATE '||'DATOS_PART_SINIESTROS' || ' ' ||
                       'SET'||' ' || 'CAMPO' || I.OrdenDatoPart || '=' || '''' ||
                       LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) || '''' || ' ' ||
                       'WHERE IdPoliza   = ' || nIdPoliza    ||' '||
                       'AND IdSiniestro  = ' || nIdSiniestro ||' '||
                       'AND CodCia       = ' || X.CodCia     ||' '||
                       'AND IdProcMasivo = ' || nIdProcMasivo;
         OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate);
         nOrden := nOrden + 1;
       END LOOP;
       --
       BEGIN
         INSERT INTO DETALLE_SINIESTRO
               (IdSiniestro,        IdPoliza,               IdDetSin,              Monto_Pagado_Moneda, 
                Monto_Pagado_Local, Monto_Reservado_Moneda, Monto_Reservado_Local, IdTipoSeg)
         VALUES(nIdSiniestro,       nIdPoliza,              1,                     0, 
                0,                  nEstimacionMoneda,      nEstimacionLocal,      cIdTipoSeg);
       EXCEPTION
         WHEN OTHERS THEN
           nCodError := 99;
           cObservacion := 'Error DETALLE SINIESTRO (Cero Sini).';
           RAISE_APPLICATION_ERROR(-20225,'DETALLE SINIESTRO (Cero Sini) - Ocurrió el siguiente error: '||SQLERRM);
       END;
       --
       BEGIN
         SELECT 'S'
           INTO cExisteCob
           FROM COBERT_ACT
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND IdPoliza    = nIdPoliza
            AND IdetPol     = nIDetPol
            AND CodCobert   = cCodCobert;
       EXCEPTION
         WHEN NO_DATA_FOUND THEn
           nCodError := 99;
           cObservacion := 'NO Existe Cobertura (SIN Aseg).';
           RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura (SIN Aseg) de '||cCodCobert);
       END;
       --
       IF cExisteCob = 'S' THEN
          BEGIN
            INSERT INTO COBERTURA_SINIESTRO
                  (IdDetSin,              CodCobert,           IdSiniestro,        IdPoliza, 
                   Doc_Ref_Pago,          Monto_Pagado_Moneda, Monto_Pagado_Local, Monto_Reservado_Moneda,
                   Monto_Reservado_Local, StsCobertura,        NumMod,             CodTransac, 
                   CodCptoTransac,        IdTransaccion,       Saldo_Reserva,      IndOrigen, 
                   FecRes,                Saldo_Reserva_Local)
            VALUES(1,                     cCodCobert,          nIdSiniestro,       nIdPoliza, 
                   NULL,                  0,                   0,                  nEstimacionMoneda, 
                   nEstimacionLocal,      'SOL',               1,                  cCodTransac, 
                   cCodCptoTransac,       NULL,                nEstimacionMoneda,  'D',
                   TRUNC(SYSDATE), nEstimacionLocal);
          EXCEPTION
            WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'NO Existe COBERTURA SINIESTRO (Cero Sini).';
              RAISE_APPLICATION_ERROR(-20225,'COBERTURA SINIESTRO (Cero Sini) - Ocurrió el siguiente error: '||SQLERRM);
          END;
       END IF;
       --
       IF nIdSiniestro > 0 THEN
          OC_SINIESTRO.ACTIVAR(X.CodCia, X.CodEmpresa, nIdSiniestro, nIdPoliza, X.NumDetUnico);
       END IF;
       --
    ELSE -- SE APLICA AJUSTE Y ADICIONA EL PAGO AL MISMO SINIESTRO
       --
       BEGIN
         OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, nIdPoliza, 'Carga Masiva de INFONACOT de Ajuste de Reserva, el ' ||
                                                      TO_CHAR(TRUNC(SYSDATE),'DD/MM/YYYY')||' Motivo: '||cDescSiniestro);

       EXCEPTION
         WHEN OTHERS THEN
           nCodError := 99;
           cObservacion := 'Error al Insertar la Obervación 3, Favor de validar la información.';
           RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Obervación 4, Favor de validar la información, Error: '||SQLERRM);
       END;
       --
       BEGIN
         SELECT IdSiniestro,  Monto_Reserva_Local,  Monto_Reserva_Moneda,  IDetPol,  Cod_Asegurado
           INTO nIdSiniestro, nMonto_Reserva_Local, nMonto_Reserva_Moneda, nIDetPol, nCod_AseguradoSini
           FROM SINIESTRO
          WHERE NumSiniRef = cNumSiniRef
            AND CodCia     = X.CodCia;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           RAISE_APPLICATION_ERROR(-20225,'NO Existe Siniestro con Referencia No. : '||cNumSiniRef);
         WHEN TOO_MANY_ROWS THEN
           RAISE_APPLICATION_ERROR(-20225,'Existen Varios Siniestros con Referencia No. : '||cNumSiniRef);
       END;
       --
       IF nEstimacionMoneda > 0 THEN
          cCodTransac     := 'AURVAD';
          cCodCptoTransac := 'AURVAD';
          dFecProceso     := TRUNC(SYSDATE);
       ELSIF nEstimacionMoneda < 0 THEN
             cCodTransac     := 'DIRVAD';
             cCodCptoTransac := 'DIRVAD';
             dFecProceso     := TRUNC(SYSDATE);
             nEstimacionMoneda := nEstimacionMoneda * -1;
       END IF;
       --
       BEGIN
         SELECT NVL(MAX(NumMod),0) + 1
           INTO nNumMod
           FROM COBERTURA_SINIESTRO
          WHERE IdSiniestro = nIdSiniestro
            AND CodCobert   = cCodCobert
            AND IdPoliza    = nIdPoliza;
       END;
       --
       BEGIN
         SELECT 'S'
           INTO cExisteCob
           FROM COBERT_ACT
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND IdPoliza    = nIdPoliza
            AND IdetPol     = nIDetPol
            AND CodCobert   = cCodCobert;
       EXCEPTION
         WHEN NO_DATA_FOUND THEn
           nCodError := 99;
           cObservacion := 'NO Existe Cobertura (SIN Aseg).';
           RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura (SIN Aseg) de '||cCodCobert);
       END;
       --
       IF cExisteCob = 'S' THEN
          BEGIN
            INSERT INTO COBERTURA_SINIESTRO
             (IdDetSin,              CodCobert,           IdSiniestro,         IdPoliza, 
              Doc_Ref_Pago,          Monto_Pagado_Moneda, Monto_Pagado_Local,  Monto_Reservado_Moneda,
              Monto_Reservado_Local, StsCobertura,        NumMod,              CodTransac,
              CodCptoTransac,        IdTransaccion,       Saldo_Reserva,       IndOrigen,
              FecRes,                Saldo_Reserva_Local)
            VALUES
             (1,                     cCodCobert,          nIdSiniestro,        nIdPoliza, 
             NULL,                   0,                   0,                   nEstimacionMoneda, 
             nEstimacionLocal,       'SOL',               nNumMod,             cCodTransac,
             cCodCptoTransac,        NULL,                nEstimacionMoneda,   'D', 
             TRUNC(SYSDATE),         nEstimacionLocal);
          EXCEPTION
            WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'NO Existe COBERTURA SINIESTRO (Cero Sini).';
              RAISE_APPLICATION_ERROR(-20225,'COBERTURA SINIESTRO (Cero Sini) - Ocurrió el siguiente error: '||SQLERRM);
          END;
       END IF;
       --
       OC_COBERTURA_SINIESTRO.EMITE_RESERVA(nCodCia, nCodEmpresa, nIdSiniestro, nIdPoliza, 1, cCodCobert, nNumMod, NULL);
       --
    END IF;
    --
    IF cMsjError IS NULL THEN
       cObservacion := 'SINIESTRO RECHAZADO';
       nCodError    := 0;
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'PROCE');
    ELSE
       OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','SINIESTROS_INFONACOT No se puede Cargar el Siniestro: '||cMsjError);
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
    END IF;
    --
    OC_PROCESOS_MASIVOS.ACT_INFO_SINI(nIdCredito, nIdTrabaj,W_ID_ENVIO,
                                      nIdSiniestro, dFec_Ocurrencia,cObservacion, nCodError );
    --
  END LOOP;

EXCEPTION
   WHEN OTHERS THEN
     ROLLBACK;
     OC_PROCESOS_MASIVOS.ACT_INFO_SINI(nIdCredito, nIdTrabaj,W_ID_ENVIO,
                                       nIdSiniestro, dFec_Ocurrencia,cObservacion, nCodError );
     OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Error: '||SQLERRM);
     OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');

END SINIESTROS_INFONACOT_EST;   -- ASEGMAS  FINI
--
--
PROCEDURE SINIESTROS_INFONACOT_DEV(nIdProcMasivo NUMBER) IS     -- ANUPAG
cNumSiniRef            SINIESTRO.NumSiniRef%TYPE;
dFec_Ocurrencia        SINIESTRO.Fec_Ocurrencia%TYPE;
dFec_Notificacion      SINIESTRO.Fec_Notificacion%TYPE;
cDescSiniestro         OBSERVACION_SINIESTRO.Descripcion%TYPE;
nIdSiniestro           SINIESTRO.IdSiniestro%TYPE;
nIDDETSIN                DETALLE_SINIESTRO.IDDETSIN%TYPE;         
nIdPoliza              POLIZAS.IdPoliza%TYPE;
nIDetPol               SINIESTRO.IDetPol%TYPE;
nCodCia                POLIZAS.CodCia%TYPE;
nCodEmpresa            POLIZAS.CodEmpresa%TYPE;
nEstimacionLocal       SINIESTRO.Monto_Reserva_Local%TYPE;
nEstimacionMoneda      SINIESTRO.Monto_Reserva_Moneda%TYPE;
cCod_Moneda            POLIZAS.Cod_Moneda%TYPE;
cIdTipoSeg             DETALLE_POLIZA.IdTipoSeg%TYPE;
nTasaCambio            DETALLE_POLIZA.Tasa_Cambio%TYPE;
cStsDetalle            DETALLE_POLIZA.StsDetalle%TYPE;
nCod_Asegurado         ASEGURADO.Cod_Asegurado%TYPE;
nCodCliente            CLIENTE_ASEG.CodCliente%TYPE;
cCodCobert             COBERT_ACT_ASEG.CodCobert%TYPE;
cCodTransac            COBERTURA_SINIESTRO.CodTransac%TYPE;
cCodCptoTransac        COBERTURA_SINIESTRO.CodCptoTransac%TYPE;
nNumMod                COBERTURA_SINIESTRO.NumMod%TYPE;
nMonto_Reserva_Local   SINIESTRO.Monto_Reserva_Local%TYPE;
nMonto_Reserva_Moneda  SINIESTRO.Monto_Reserva_Moneda%TYPE;
cMsjError              PROCESOS_MASIVOS_LOG.TxtError%TYPE := NULL;
cExisteCob             VARCHAR2(1);
dFecIniVig             POLIZAS.FECINIVIG%TYPE;
dFecFinVig             POLIZAS.FECFINVIG%TYPE;
dFecAnul               POLIZAS.FECANUL%TYPE;
cMotivAnul             POLIZAS.MOTIVANUL%TYPE;
nCod_AseguradoSini     ASEGURADO.Cod_Asegurado%TYPE;
dFecProceso            DATE;
nCodError              NUMBER(2) := Null;
cIdCredThona           VARCHAR2(30);
nCobertINFO            NUMBER(2);
nNroCuota              NUMBER(2);
nCuota                 NUMBER(14,2);
nIdCredito             INFO_ALTBAJ.Id_Credito%TYPE;
nIdTrabaj              INFO_ALTBAJ.Id_Trabajador%TYPE;
nNumRemesa             INFO_ALTBAJ.Nu_Remesa%TYPE;
cIdInfoPoliza          INFO_SINIESTRO.Id_Poliza%TYPE;
nIdInfoEndoso          INFO_SINIESTRO.Id_Endoso%TYPE;
nIdInfoAsegura         INFO_SINIESTRO.Id_Aseguradora%TYPE;
W_ID_ENVIO             INFO_SINIESTRO.ID_ENVIO%TYPE;
W_ID_ENVIO_PAGO        VARCHAR2(10);
W_CODERRORCARGA        INFO_SINIESTRO.CODERRORCARGA%TYPE;
nNum_Aprobacion        APROBACIONES.Num_Aprobacion%TYPE;
cObservacion           VARCHAR2(100) := 'Siniestro Pagado';
cCtaCLABE              BENEF_SIN.Cuenta_Clave%TYPE;
--
CURSOR SIN_Q IS
   SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
          NumDetUnico, RegDatosProc, TipoProceso, IndColectiva
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;
--
BEGIN
  --
  FOR X IN SIN_Q LOOP
    nCodCia           := X.CodCia;
    nCodempresa       := X.CodEmpresa;
    cMsjError         := NULL;
    cIdInfoPoliza     :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,1,','));
    nIdInfoEndoso     := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,2,',')));
    nIdInfoAsegura    := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,3,',')));
    nIdCredito        := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,4,',')));
    nIdTrabaj         := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,5,',')));
    W_ID_ENVIO_PAGO   :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,15,','));
    nCobertINFO       := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,22,','))); 
    W_ID_ENVIO        := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,23,','))); 
    cCtaCLABE         :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,24,','));
    dFec_Ocurrencia   :=   TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,25,',')),'DD/MM/YYYY');
    cDescSiniestro    := 'ENDOSO: '||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,2,',')); 
    nEstimacionMoneda := TO_NUMBER(TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,13,',')),'999999999990.00'); 
    --
    -- VALIDA POLIZA
    --
    BEGIN
      SELECT P.IdPoliza,      P.Cod_Moneda,      DP.FecIniVig,       DP.FecFinVig, 
             P.FecAnul,       P.MotivAnul,       Dp.IDetPol,         Dp.StsDetalle,
             P.CodCliente,    Dp.Cod_Asegurado,  I.Nu_Remesa,        I.Id_Credito_Thona,
             DP.IdTipoSeg,    
             TRUNC(MONTHS_BETWEEN(DP.FecIniVig,dFec_Ocurrencia)) NroCuota,
             I.Cuota
        INTO nIdPoliza,       cCod_Moneda,       dFecIniVig,          dFecFinVig, 
             dFecAnul,        cMotivAnul,        nIDetPol,            cStsDetalle,
             nCodCliente,     nCod_Asegurado,    nNumRemesa,          cIdCredThona, 
             cIdTipoSeg, 
             nNroCuota, 
             nCuota
        FROM POLIZAS P, DETALLE_POLIZA DP, INFO_ALTBAJ I
       WHERE I.Id_Credito    = nIdCredito
         AND I.Id_Trabajador = nIdTrabaj
         AND I.IdPoliza      = P.IdPoliza
         AND I.IdPoliza      = DP.IdPoliza
         AND I.IDetPol       = DP.IDetPol
         AND P.CodCia        = X.CodCia
         AND P.CodEmpresa    = X.CodEmpresa
         AND P.StsPoliza   IN ('REN','EMI','ANU');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        nCodError    := 22;
        cObservacion := 'Codigo Error 22: NO EXISTE POLIZA';
        RAISE_APPLICATION_ERROR(-20225,'Codigo Error 22:  NO EXISTE POLIZA');
      WHEN OTHERS THEN
           nCodError := 22.2;
           cObservacion := 'Codigo Error 22.2: NO EXISTE POLIZA';
           RAISE_APPLICATION_ERROR(-20225,'Codigo Error 22.1: NO EXISTE POLIZA'||SQLERRM);
    END;
    --
    cNumSiniRef       := cIdCredThona;
    dFec_Notificacion := TRUNC(SYSDATE);
    nTasaCambio       := OC_GENERALES.TASA_DE_CAMBIO(cCod_Moneda, TRUNC(SYSDATE));
    nEstimacionLocal  := nEstimacionMoneda * nTasaCambio;
    --
    -- VALIDA SINIESTRO
    --
    BEGIN
      SELECT IdSiniestro,  Monto_Reserva_Local,  Monto_Reserva_Moneda,  IDetPol,  Cod_Asegurado
        INTO nIdSiniestro, nMonto_Reserva_Local, nMonto_Reserva_Moneda, nIDetPol, nCod_AseguradoSini
        FROM SINIESTRO
       WHERE NumSiniRef = cNumSiniRef
         AND CodCia     = X.CodCia;
    EXCEPTION 
      WHEN NO_DATA_FOUND  THEN
           nCodError    := 41;
           cObservacion := 'Codigo Error 41: NO EXISTE EL SINIESTRO';
           RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL SINIESTRO');
      WHEN TOO_MANY_ROWS  THEN
           nCodError    := 22.1;
           cObservacion := 'Codigo Error 22.1: MAS DE UN SINIESTRO';
           RAISE_APPLICATION_ERROR(-20225,'Codigo Error 22.1: MAS DE UN SINIESTRO - '||cNumSiniRef);
      WHEN OTHERS THEN 
           nCodError    := 41;
           cObservacion := 'Codigo Error 41.1: NO EXISTE EL SINIESTRO';
           RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL SINIESTRO');
    END;
    --
    -- VALIDA APROBACION
    --
    BEGIN
      SELECT A.NUM_APROBACION,A.IDDETSIN
        INTO nNum_Aprobacion,nIDDETSIN
        FROM APROBACIONES A
       WHERE A.IDSINIESTRO    = nIdSiniestro
         AND A.IDPOLIZA       = nIdPoliza
         AND TO_CHAR(A.FECPAGO,'YYYYMM') = SUBSTR(W_ID_ENVIO_PAGO,1,6);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        nCodError    := 40;
        cObservacion := 'Codigo Error 40: NO EXISTE APROBACION';
        RAISE_APPLICATION_ERROR(-20225,'Codigo Error 40:  NO EXISTE APROBACION');
      WHEN OTHERS THEN
           nCodError := 40;
           cObservacion := 'Codigo Error 40.1: NO EXISTE APROBACION';
           RAISE_APPLICATION_ERROR(-20225,'Codigo Error 40.1: NO EXISTE APROBACION'||SQLERRM);
    END;
    --
    BEGIN
      SELECT DISTINCT(ISI.CODERRORCARGA)  
        INTO W_CODERRORCARGA
        FROM INFO_SINIESTRO ISI
       WHERE ISI.ID_CREDITO    = nIdCredito
         AND ISI.ID_TRABAJADOR = nIdTrabaj
         AND ISI.ID_ENVIO      = W_ID_ENVIO
         AND ISI.TIPOPROCESO   = X.TIPOPROCESO;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        nCodError    := 22;
        cObservacion := 'Codigo Error 22.1: No existe CRED,TRAB,ENVIO';
        RAISE_APPLICATION_ERROR(-20225,cObservacion);
      WHEN OTHERS THEN
           nCodError := 22;
           cObservacion := 'Codigo Error 22.1: No existe CRED,TRAB,ENVIO OTHERS';
           RAISE_APPLICATION_ERROR(-20225,'Codigo Error 22.1: No existe CRED,TRAB,ENVIO  OTHERS'||SQLERRM);
    END;
    --
    IF W_CODERRORCARGA > 0 THEN      
        nCodError    := W_CODERRORCARGA;
        cObservacion := 'Codigo Error '||W_CODERRORCARGA||' : Error de validacion.';
        RAISE_APPLICATION_ERROR(-20225,cObservacion);
    END IF;
    --
    IF nNum_Aprobacion > 0 THEN
       --
       BEGIN
         OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, nIdPoliza, 'Carga Masiva de devolucion de pagos, el ' ||
                                                      TO_CHAR(TRUNC(SYSDATE),'DD/MM/YYYY HH24:MI:SS')||' Motivo: '||cDescSiniestro);

       EXCEPTION
         WHEN OTHERS THEN
           nCodError := 99;
           cObservacion := 'Error al Insertar la Obervacion 3, Favor de validar la informacion.';
           RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Obervacion 4, Favor de validar la informacion, Error: '||SQLERRM);
       END;
       --
       IF nCobertINFO = 1 THEN
          cCodCobert      := 'DESEMP';
          cCodTransac     := 'DIRVAD';
          cCodCptoTransac := 'DIRVAD';
       ELSIF nCobertINFO = 2 THEN
             cCodCobert      := 'INVALI';
             cCodTransac     := 'DIRVAD';
             cCodCptoTransac := 'DIRVAD';
       ELSIF nCobertINFO = 3 THEN
             cCodCobert := 'FALLEC';
             cCodTransac     := 'DIRVBA';
             cCodCptoTransac := 'DIRVBA';
       ELSIF nCobertINFO = 4 THEN
             cCodCobert := 'DESINV';
             cCodTransac     := 'DIRVAD';
             cCodCptoTransac := 'DIRVAD';
       ELSE
          nCodError := 29;
          cObservacion := 'Error, el Tipo de Cobertura no es valido.';
          RAISE_APPLICATION_ERROR(-20225,'Error, el Tipo de Cobertura no es valido.');
       END IF;
       --
       dFecProceso     := TRUNC(SYSDATE);
       --
       BEGIN
         SELECT NVL(MAX(NumMod),0) + 1  
           INTO nNumMod
           FROM COBERTURA_SINIESTRO
          WHERE IdSiniestro = nIdSiniestro
            AND CodCobert   = cCodCobert
            AND IdPoliza    = nIdPoliza;
       END;
       --
       BEGIN
         SELECT 'S'
           INTO cExisteCob
           FROM COBERT_ACT
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND IdPoliza    = nIdPoliza
            AND IdetPol     = nIDetPol
            AND CodCobert   = cCodCobert;
       EXCEPTION
         WHEN NO_DATA_FOUND THEn
           nCodError := 99;
           cObservacion := 'NO Existe Cobertura (SIN Aseg).';
           RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura (SIN Aseg) de '||cCodCobert);
       END;
       --
       IF cExisteCob = 'S' THEN
          BEGIN
            INSERT INTO COBERTURA_SINIESTRO
             (IdDetSin,              CodCobert,           IdSiniestro,         IdPoliza, 
              Doc_Ref_Pago,          Monto_Pagado_Moneda, Monto_Pagado_Local,  Monto_Reservado_Moneda,
              Monto_Reservado_Local, StsCobertura,        NumMod,              CodTransac,
              CodCptoTransac,        IdTransaccion,       Saldo_Reserva,       IndOrigen,
              FecRes,                Saldo_Reserva_Local)
            VALUES
             (1,                     cCodCobert,          nIdSiniestro,        nIdPoliza, 
             NULL,                   0,                   0,                   nEstimacionMoneda, 
             nEstimacionLocal,       'SOL',               nNumMod,             cCodTransac,
             cCodCptoTransac,        NULL,                nEstimacionMoneda,   'D', 
             TRUNC(SYSDATE),         nEstimacionLocal);
          EXCEPTION
            WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'NO Existe COBERTURA SINIESTRO (Cero Sini).';
              RAISE_APPLICATION_ERROR(-20225,'COBERTURA SINIESTRO (Cero Sini) - Ocurrio?el siguiente error: '||SQLERRM);
          END;
       END IF;
       --
       OC_COBERTURA_SINIESTRO.EMITE_RESERVA(nCodCia, nCodEmpresa, nIdSiniestro, nIdPoliza, 1, cCodCobert, nNumMod, NULL);
       --
       -- PROCESO DE DESPAGOS  INICIO
       --
       BEGIN
         OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, nIdPoliza, 'Carga Masiva de INFONACOT de Despagos, el ' ||
                                                      TO_CHAR(TRUNC(SYSDATE),'DD/MM/YYYY')||' Motivo: '||cDescSiniestro);
       EXCEPTION
         WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'Error al Insertar la Obervacion 5, Favor de validar la informacion.';
              RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Obervacion 6, Favor de validar la informacion, Error: '||SQLERRM);
       END;
       --
       BEGIN
         OC_APROBACIONES.ANULAR(nCodCia, nCodEmpresa , nNum_Aprobacion, nIdSiniestro, nIdPoliza , nIdDetSin);
       EXCEPTION
         WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'Error al Insertar la Anualacion de la Aprobacion.';
              RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Anualacion de la Aprobacion '|| nIdSiniestro || ' ' || SQLERRM);
       END;
       --
       -- PROCESO DE DESPAGOS  FIN
       --
    END IF;
    IF cMsjError IS NULL THEN
       cObservacion := 'Siniestro Anulado';
       nCodError    := 0;
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'PROCE');
    ELSE
       OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','SINIESTROS_INFONACOT No se puede Cargar la anulacion: '||cMsjError);
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
    END IF;
    --
    OC_PROCESOS_MASIVOS.ACT_INFO_SINI(nIdCredito, nIdTrabaj,W_ID_ENVIO,
                                      nIdSiniestro, dFec_Ocurrencia,cObservacion, nCodError );
  END LOOP;

EXCEPTION
   WHEN OTHERS THEN
     ROLLBACK;
     OC_PROCESOS_MASIVOS.ACT_INFO_SINI(nIdCredito, nIdTrabaj,W_ID_ENVIO,
                                       nIdSiniestro, dFec_Ocurrencia,cObservacion, nCodError );
     OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Error 1: '||SQLERRM);
     OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END SINIESTROS_INFONACOT_DEV;   -- ANUPAG
--
--
PROCEDURE SINIESTROS_INFONACOT_DRV(nIdProcMasivo NUMBER) IS     -- DISRVA
cNumSiniRef            SINIESTRO.NumSiniRef%TYPE;
dFec_Ocurrencia        SINIESTRO.Fec_Ocurrencia%TYPE;
dFec_Notificacion      SINIESTRO.Fec_Notificacion%TYPE;
cDescSiniestro         OBSERVACION_SINIESTRO.Descripcion%TYPE;
nIdSiniestro           SINIESTRO.IdSiniestro%TYPE;
nIdPoliza              POLIZAS.IdPoliza%TYPE;
nIDetPol               SINIESTRO.IDetPol%TYPE;
nCodCia                POLIZAS.CodCia%TYPE;
nCodEmpresa            POLIZAS.CodEmpresa%TYPE;
nEstimacionLocal       SINIESTRO.Monto_Reserva_Local%TYPE;
nEstimacionMoneda      SINIESTRO.Monto_Reserva_Moneda%TYPE;
cCod_Moneda            POLIZAS.Cod_Moneda%TYPE;
cIdTipoSeg             DETALLE_POLIZA.IdTipoSeg%TYPE;
nTasaCambio            DETALLE_POLIZA.Tasa_Cambio%TYPE;
cStsDetalle            DETALLE_POLIZA.StsDetalle%TYPE;
nCod_Asegurado         ASEGURADO.Cod_Asegurado%TYPE;
nCodCliente            CLIENTE_ASEG.CodCliente%TYPE;
cCodCobert             COBERT_ACT_ASEG.CodCobert%TYPE;
cCodTransac            COBERTURA_SINIESTRO.CodTransac%TYPE;
cCodCptoTransac        COBERTURA_SINIESTRO.CodCptoTransac%TYPE;
nNumMod                COBERTURA_SINIESTRO.NumMod%TYPE;
nMonto_Reserva_Local   SINIESTRO.Monto_Reserva_Local%TYPE;
nMonto_Reserva_Moneda  SINIESTRO.Monto_Reserva_Moneda%TYPE;
cMsjError              PROCESOS_MASIVOS_LOG.TxtError%TYPE := NULL;
cExisteCob             VARCHAR2(1);
dFecIniVig             POLIZAS.FECINIVIG%TYPE;
dFecFinVig             POLIZAS.FECFINVIG%TYPE;
dFecAnul               POLIZAS.FECANUL%TYPE;
cMotivAnul             POLIZAS.MOTIVANUL%TYPE;
nCod_AseguradoSini     ASEGURADO.Cod_Asegurado%TYPE;
dFecProceso            DATE;
nCodError              NUMBER(2) := Null;
cIdCredThona           VARCHAR2(30);
nCobertINFO            NUMBER(2);
nNroCuota              NUMBER(2);
nCuota                 NUMBER(14,2);
nIdCredito             INFO_ALTBAJ.Id_Credito%TYPE;
nIdTrabaj              INFO_ALTBAJ.Id_Trabajador%TYPE;
nNumRemesa             INFO_ALTBAJ.Nu_Remesa%TYPE;
cIdInfoPoliza          INFO_SINIESTRO.Id_Poliza%TYPE;
nIdInfoEndoso          INFO_SINIESTRO.Id_Endoso%TYPE;
nIdInfoAsegura         INFO_SINIESTRO.Id_Aseguradora%TYPE;
W_ID_ENVIO             INFO_SINIESTRO.ID_ENVIO%TYPE;
cObservacion           VARCHAR2(100) := 'Siniestro Pagado';
cCtaCLABE              BENEF_SIN.Cuenta_Clave%TYPE;
--

CURSOR SIN_Q IS
   SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
          NumDetUnico, RegDatosProc, TipoProceso, IndColectiva
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;
--
BEGIN
  --
  FOR X IN SIN_Q LOOP
    nCodCia           := X.CodCia;
    nCodempresa       := X.CodEmpresa;
    cMsjError         := NULL;
    cIdInfoPoliza     :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,1,','));
    nIdInfoEndoso     := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,2,',')));
    nIdInfoAsegura    := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,3,',')));
    nIdCredito        := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,4,',')));
    nIdTrabaj         := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,5,',')));
    nCobertINFO       := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,22,','))); 
    W_ID_ENVIO        := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,23,','))); 
    cCtaCLABE         :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,24,','));
    dFec_Ocurrencia   :=   TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,25,',')),'DD/MM/YYYY');
    cDescSiniestro    := 'ENDOSO: '||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,2,',')); 
    nEstimacionMoneda := TO_NUMBER(TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,13,',')),'999999999990.00'); 
    --
    -- VALIDA POLIZA
    --
    BEGIN
      SELECT P.IdPoliza,      P.Cod_Moneda,      DP.FecIniVig,       DP.FecFinVig, 
             P.FecAnul,       P.MotivAnul,       Dp.IDetPol,         Dp.StsDetalle,
             P.CodCliente,    Dp.Cod_Asegurado,  I.Nu_Remesa,        I.Id_Credito_Thona,
             DP.IdTipoSeg,    
             TRUNC(MONTHS_BETWEEN(DP.FecIniVig,dFec_Ocurrencia)) NroCuota,
             I.Cuota
        INTO nIdPoliza,       cCod_Moneda,       dFecIniVig,          dFecFinVig, 
             dFecAnul,        cMotivAnul,        nIDetPol,            cStsDetalle,
             nCodCliente,     nCod_Asegurado,    nNumRemesa,          cIdCredThona, 
             cIdTipoSeg, 
             nNroCuota, 
             nCuota
        FROM POLIZAS P, DETALLE_POLIZA DP, INFO_ALTBAJ I
       WHERE I.Id_Credito    = nIdCredito
         AND I.Id_Trabajador = nIdTrabaj
         AND I.IdPoliza      = P.IdPoliza
         AND I.IdPoliza      = DP.IdPoliza
         AND I.IDetPol       = DP.IDetPol
         AND P.CodCia        = X.CodCia
         AND P.CodEmpresa    = X.CodEmpresa
         AND P.StsPoliza   IN ('REN','EMI','ANU');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN  
        nCodError    := 22;
        cObservacion := 'Codigo Error 22: NO EXISTE POLIZA'; 
        RAISE_APPLICATION_ERROR(-20225,'Codigo Error 22:  NO EXISTE POLIZA - '||nIdCredito||' - '||nIdTrabaj);
      WHEN OTHERS THEN
           nCodError := 22;
           cObservacion := 'Codigo Error 22.1: NO EXISTE POLIZA';
           RAISE_APPLICATION_ERROR(-20225,'Codigo Error 22.1: NO EXISTE POLIZA - '||nIdCredito||' - '||nIdTrabaj||' - '||SQLERRM);
    END;
    --
    cNumSiniRef       := cIdCredThona;
    dFec_Notificacion := TRUNC(SYSDATE);
    nTasaCambio       := OC_GENERALES.TASA_DE_CAMBIO(cCod_Moneda, TRUNC(SYSDATE));
    nEstimacionLocal  := nEstimacionMoneda * nTasaCambio;
    --
    -- VALIDA SINIESTRO
    --
    BEGIN
      SELECT IdSiniestro,  Monto_Reserva_Local,  Monto_Reserva_Moneda,  IDetPol,  Cod_Asegurado
        INTO nIdSiniestro, nMonto_Reserva_Local, nMonto_Reserva_Moneda, nIDetPol, nCod_AseguradoSini
        FROM SINIESTRO
       WHERE NumSiniRef = cNumSiniRef
         AND CodCia     = X.CodCia
         AND IdSiniestro = (SELECT MAX(IdSiniestro)
                              FROM SINIESTRO S
                             WHERE S.NumSiniRef = cNumSiniRef
                               AND S.CodCia     = X.CodCia
                               AND S.MONTO_RESERVA_LOCAL - S.MONTO_PAGO_LOCAL > 0);
    EXCEPTION 
      WHEN NO_DATA_FOUND  THEN
           nCodError    := 41;
           cObservacion := 'Codigo Error 41: NO EXISTE EL SINIESTRO';
           RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL SINIESTRO - '||cNumSiniRef||' - '||SQLERRM);
      WHEN OTHERS THEN 
           nCodError    := 41;
           cObservacion := 'Codigo Error 41.1: NO EXISTE EL SINIESTRO';
           RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL SINIESTRO - '||cNumSiniRef||' - '||SQLERRM);
    END;
    --
    IF nIdSiniestro > 0 THEN
       --
       BEGIN
         OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, nIdPoliza, 'Carga Masiva de disminucion de reserva masiva, el ' ||
                                                      TO_CHAR(TRUNC(SYSDATE),'DD/MM/YYYY HH24:MI:SS')||' Motivo: '||cDescSiniestro);

       EXCEPTION
         WHEN OTHERS THEN
           nCodError := 99;
           cObservacion := 'Error al Insertar la Obervacion , Favor de validar la informacion.';
           RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Observacion , Favor de validar la informacion, Error: '||SQLERRM);
       END;
       --
       IF nCobertINFO = 1 THEN
          cCodCobert      := 'DESEMP';
          cCodTransac     := 'DIRVAD';
          cCodCptoTransac := 'DIRVAD';
       ELSIF nCobertINFO = 2 THEN
             cCodCobert      := 'INVALI';
             cCodTransac     := 'DIRVAD';
             cCodCptoTransac := 'DIRVAD';
       ELSIF nCobertINFO = 3 THEN
             cCodCobert := 'FALLEC';
             cCodTransac     := 'DIRVBA';
             cCodCptoTransac := 'DIRVBA';
       ELSIF nCobertINFO = 4 THEN
             cCodCobert := 'DESINV';
             cCodTransac     := 'DIRVAD';
             cCodCptoTransac := 'DIRVAD';
       ELSE
          nCodError := 29;
          cObservacion := 'Error, el Tipo de Cobertura no es valido.';
          RAISE_APPLICATION_ERROR(-20225,'Error, el Tipo de Cobertura no es valido.');
       END IF;
       --
       dFecProceso     := TRUNC(SYSDATE);
       --
       BEGIN
         SELECT NVL(MAX(NumMod),0) + 1  
           INTO nNumMod
           FROM COBERTURA_SINIESTRO
          WHERE IdSiniestro = nIdSiniestro
            AND CodCobert   = cCodCobert
            AND IdPoliza    = nIdPoliza;
       END;
       --
       BEGIN
         SELECT 'S'
           INTO cExisteCob
           FROM COBERT_ACT
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND IdPoliza    = nIdPoliza
            AND IdetPol     = nIDetPol
            AND CodCobert   = cCodCobert;
       EXCEPTION
         WHEN NO_DATA_FOUND THEn
           nCodError := 99;
           cObservacion := 'NO Existe Cobertura (SIN Aseg).';
           RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura (SIN Aseg) de '||cCodCobert);
       END;
       --
       IF cExisteCob = 'S' THEN
          BEGIN
            INSERT INTO COBERTURA_SINIESTRO
             (IdDetSin,              CodCobert,           IdSiniestro,         IdPoliza, 
              Doc_Ref_Pago,          Monto_Pagado_Moneda, Monto_Pagado_Local,  Monto_Reservado_Moneda,
              Monto_Reservado_Local, StsCobertura,        NumMod,              CodTransac,
              CodCptoTransac,        IdTransaccion,       Saldo_Reserva,       IndOrigen,
              FecRes,                Saldo_Reserva_Local)
            VALUES
             (1,                     cCodCobert,          nIdSiniestro,        nIdPoliza, 
             NULL,                   0,                   0,                   nEstimacionMoneda, 
             nEstimacionLocal,       'SOL',               nNumMod,             cCodTransac,
             cCodCptoTransac,        NULL,                nEstimacionMoneda,   'D', 
             TRUNC(SYSDATE),         nEstimacionLocal);
          EXCEPTION
            WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'NO Existe COBERTURA SINIESTRO (Cero Sini).';
              RAISE_APPLICATION_ERROR(-20225,'COBERTURA SINIESTRO (Cero Sini) - Ocurrio el siguiente error: '||SQLERRM);
          END;
       END IF;
       --
       OC_COBERTURA_SINIESTRO.EMITE_RESERVA(nCodCia, nCodEmpresa, nIdSiniestro, nIdPoliza, 1, cCodCobert, nNumMod, NULL);
       --
    END IF;
    --
    IF cMsjError IS NULL THEN
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'PROCE');
    ELSE
       OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','SINIESTROS_INFONACOT No se puede Cargar la disminucion de rva: '||cMsjError);
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
    END IF;
    --

  END LOOP;

EXCEPTION
   WHEN OTHERS THEN
     ROLLBACK;
     OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Error 1: '||SQLERRM);
     OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END SINIESTROS_INFONACOT_DRV;  -- DISRVA
--
--
PROCEDURE SINIESTROS_AJUSTES(nIdProcMasivo NUMBER) IS     -- AJUSTES INI
cDescSiniestro         OBSERVACION_SINIESTRO.Descripcion%TYPE;
nIdSiniestro           SINIESTRO.IdSiniestro%TYPE;
NIDDETSIN              DETALLE_SINIESTRO_ASEG.IDDETSIN%TYPE;
nIdPoliza              POLIZAS.IdPoliza%TYPE;
nIDetPol               SINIESTRO.IDetPol%TYPE;
nCodCia                POLIZAS.CodCia%TYPE;
nCodEmpresa            POLIZAS.CodEmpresa%TYPE;
nAJUSTELOCAL           SINIESTRO.Monto_Reserva_Local%TYPE;
nAJUSTEMONEDA          SINIESTRO.Monto_Reserva_Moneda%TYPE;
cCod_Moneda            POLIZAS.Cod_Moneda%TYPE;
nTasaCambio            DETALLE_POLIZA.Tasa_Cambio%TYPE;
nCod_Asegurado         ASEGURADO.Cod_Asegurado%TYPE;
cCodCobert             COBERTURA_SINIESTRO_ASEG.CodCobert%TYPE;
cCodTransac            COBERTURA_SINIESTRO_ASEG.CodTransac%TYPE;
WCODTRANSAC            COBERTURA_SINIESTRO_ASEG.CodTransac%TYPE;
WCODTRANSAC_PAGO       COBERTURA_SINIESTRO_ASEG.CodTransac%TYPE;
cCodCptoTransac        COBERTURA_SINIESTRO_ASEG.CodCptoTransac%TYPE;
WCODCPTOTRANSAC        COBERTURA_SINIESTRO_ASEG.CodCptoTransac%TYPE;
nNumMod                COBERTURA_SINIESTRO_ASEG.NumMod%TYPE;
cMsjError              PROCESOS_MASIVOS_LOG.TxtError%TYPE := NULL;
cExisteCob             VARCHAR2(1);
dFECHA                 POLIZAS.FECINIVIG%TYPE;
WFECHA                 POLIZAS.FECINIVIG%TYPE;
nCodError              NUMBER(2) := Null;
cObservacion           VARCHAR2(100);
WSALDO_RESERVA         COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA%TYPE;
WID_COL_INDI           VARCHAR2(1);
WID_APLICA_CONTA       VARCHAR2(1);
nIDTRANSACCION         TRANSACCION.IDTRANSACCION%TYPE;
--
CURSOR SIN_Q IS
   SELECT CodCia,       CodEmpresa,   IdTipoSeg, 
          PlanCob,      NumPolUnico,  NumDetUnico, 
          RegDatosProc, TipoProceso,  IndColectiva
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;
--
BEGIN
  --
  FOR X IN SIN_Q LOOP
    nCodCia          := X.CodCia;
    nCodempresa      := X.CodEmpresa;
    cMsjError        := NULL;
    WCODTRANSAC_PAGO := NULL;
    --
    nIdSiniestro     := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,1,','))); 
    cCodCobert       :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,2,',')); 
    WCODTRANSAC      :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,3,',')); 
    WCODCPTOTRANSAC  :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,4,',')); 
    nAJUSTEMONEDA    := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,5,',')));                       
    WFECHA           :=   TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,',')),'dd/mm/yyyy');                       
    WID_COL_INDI     :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,7,','));                       
    WID_APLICA_CONTA :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,8,','));                       
    cDescSiniestro   :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,9,','));                       
    --
    -- VALIDA SINIESTRO
    --
    BEGIN
      SELECT IdSiniestro,  S.IDPOLIZA, S.IDETPOL, S.COD_MONEDA 
        INTO nIdSiniestro, nIdPoliza,  nIDetPol,  cCod_Moneda 
        FROM SINIESTRO S
       WHERE S.IDSINIESTRO = nIdSiniestro;
    EXCEPTION 
      WHEN NO_DATA_FOUND  THEN
           nCodError    := 41;
           cObservacion := 'Codigo Error 41: NO EXISTE EL SINIESTRO';
           RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL SINIESTRO - '||nIdSiniestro||' - '||SQLERRM);
      WHEN OTHERS THEN 
           nCodError    := 41;
           cObservacion := 'Codigo Error 41.1: NO EXISTE EL SINIESTRO OTHERS';
           RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL SINIESTRO  OTHERS- '||nIdSiniestro||' - '||SQLERRM);
    END;
    --
    nTasaCambio  := OC_GENERALES.TASA_DE_CAMBIO(cCod_Moneda, TRUNC(SYSDATE));
    nAJUSTELOCAL := nAJUSTEMONEDA * nTasaCambio;
    --
    -- PROCESA SINIESTRO SI ES INDIVIDUAL
    --
    IF nIdSiniestro > 0 AND WID_COL_INDI = 'I' THEN
       --
       -- VALIDA DETALLE_SINIESTRO
       --
       BEGIN
         SELECT DS.IDDETSIN 
           INTO NIDDETSIN
           FROM DETALLE_SINIESTRO DS
          WHERE DS.IDSINIESTRO = nIdSiniestro
            AND DS.IDDETSIN    = 1;
       EXCEPTION 
         WHEN NO_DATA_FOUND  THEN
              nCodError    := 41;
              cObservacion := 'Codigo Error 41: NO EXISTE EL DETALLE DE SINIESTRO';
              RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL DETALLE DE SINIESTRO  - '||nIdSiniestro||' - 1 '||SQLERRM);
         WHEN OTHERS THEN 
              nCodError    := 41;
              cObservacion := 'Codigo Error 41.1: NO EXISTE EL DETALLE DE SINIESTRO OTHERS';
              RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL DETALLE DE SINIESTRO OTHERS- '||nIdSiniestro||' - 1 '||SQLERRM);
       END;
       --
       -- ESTE IF ES POR SI ENTRA POR UN PAGO
       --
       IF WCODTRANSAC = 'PARVBA' OR WCODTRANSAC = 'PARVAD' THEN
          WCODTRANSAC_PAGO := WCODTRANSAC;
          IF WCODTRANSAC = 'PARVBA'  THEN
             WCODTRANSAC := 'AURVBA';
          ELSE             
             WCODTRANSAC := 'AURVAD';
          END IF;
       END IF;
       --
       cCodTransac := WCODTRANSAC;
       IF WCODCPTOTRANSAC = 'N' THEN
          cCodCptoTransac := WCODTRANSAC;
       ELSE
          cCodCptoTransac := WCODCPTOTRANSAC;
       END IF;
       --
       IF WFECHA IS NULL THEN
          dFECHA := TRUNC(SYSDATE);
       ELSE 
          dFECHA := WFECHA;
       END IF;
       --
       BEGIN
         OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, nIdPoliza, 'Carga Masiva de ajuste a la reserva, el ' ||
                                                      dFECHA||' Motivo: '||cDescSiniestro);
       EXCEPTION
         WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'Error al Insertar la Observacion , Favor de validar la informacion.';
              RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Observacion , Favor de validar la informacion, Error: '||SQLERRM);
       END;
       --
       BEGIN
         SELECT NVL(MAX(NumMod),0) + 1  
           INTO nNumMod
           FROM COBERTURA_SINIESTRO
          WHERE IdSiniestro = nIdSiniestro
            AND CodCobert   = cCodCobert
            AND IdPoliza    = nIdPoliza;
       END;
       --
       BEGIN
         SELECT 'S'
           INTO cExisteCob
           FROM COBERTURA_SINIESTRO
          WHERE IdSiniestro = nIdSiniestro
            AND CodCobert   = cCodCobert
            AND IdPoliza    = nIdPoliza;
       EXCEPTION
         WHEN NO_DATA_FOUND THEn
              nCodError := 99;
              cObservacion := 'NO Existe Cobertura .';
              RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura de '||cCodCobert);
         WHEN TOO_MANY_ROWS THEn
              cExisteCob := 'S'; 
         WHEN OTHERS THEn
              nCodError := 99;
              cObservacion := 'NO Existe Cobertura por others.';
              RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura de '||cCodCobert);
       END;
       --
       IF WCODTRANSAC = 'DIRVAD' OR 
          WCODTRANSAC = 'DIRVBA' THEN
          IF cExisteCob = 'S' THEN
             BEGIN
              SELECT CS.SALDO_RESERVA
                INTO WSALDO_RESERVA
                FROM COBERTURA_SINIESTRO CS
               WHERE IdSiniestro = nIdSiniestro
                 AND CodCobert   = cCodCobert
                 AND IdPoliza    = nIdPoliza
                 AND CS.NUMMOD   = nNumMod -1;
             EXCEPTION
               WHEN NO_DATA_FOUND THEn
                    nCodError := 99;
                    cObservacion := 'NO Existe Cobertura (SIN Aseg).';
                    RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura de '||cCodCobert);
             END;
             --
             --IF WSALDO_RESERVA >= nAJUSTEMONEDA THEN
                BEGIN
                  INSERT INTO COBERTURA_SINIESTRO
                   (IDDETSIN,               CODCOBERT,              IDSINIESTRO,          IDPOLIZA,
                    DOC_REF_PAGO,           MONTO_PAGADO_MONEDA,    MONTO_PAGADO_LOCAL,   MONTO_RESERVADO_MONEDA, 
                    MONTO_RESERVADO_LOCAL,  STSCOBERTURA,           NUMMOD,               CODTRANSAC,             
                    CODCPTOTRANSAC,         IDTRANSACCION,          SALDO_RESERVA,        INDORIGEN,              
                    FECRES,                 SALDO_RESERVA_LOCAL,    IDTRANSACCIONANUL,    IDAUTORIZACION)
                  VALUES
                   (NIDDETSIN,              cCodCobert,             nIdSiniestro,         nIdPoliza, 
                    NULL,                   0,                      0,                    nAJUSTEMONEDA,           
                    nAJUSTELOCAL,           'SOL',                  nNumMod,              cCodTransac,             
                    cCodCptoTransac,        NULL,                   nAJUSTEMONEDA,        'D',                     
                    dFECHA,                 nAJUSTELOCAL,           NULL,                 NULL);
                EXCEPTION
                  WHEN OTHERS THEN
                       nCodError := 99;
                       cObservacion := 'ERROR AL INSERTAR COBERTURA COBERTURA_SINIESTRO ';
                       RAISE_APPLICATION_ERROR(-20225,'ERROR AL INSERTAR COBERTURA COBERTURA_SINIESTRO'||SQLERRM);
                END;
             --ELSE
             ---   nCodError := 99;
             --   cObservacion := 'LA RESERVA ES INSUFICIENTE PARA ESTE AJUSTE. ';
             ---   RAISE_APPLICATION_ERROR(-20225,'LA RESERVA '||WSALDO_RESERVA||' ES INSUFICIENTE PARA EL AJUSTE '||nAJUSTEMONEDA||'  '||SQLERRM);
             --END IF;
          END IF;    
       ELSE      
          IF cExisteCob = 'S' THEN
             BEGIN
               INSERT INTO COBERTURA_SINIESTRO
                (IDDETSIN,               CODCOBERT,              IDSINIESTRO,          IDPOLIZA,
                 DOC_REF_PAGO,           MONTO_PAGADO_MONEDA,    MONTO_PAGADO_LOCAL,   MONTO_RESERVADO_MONEDA, 
                 MONTO_RESERVADO_LOCAL,  STSCOBERTURA,           NUMMOD,               CODTRANSAC,             
                 CODCPTOTRANSAC,         IDTRANSACCION,          SALDO_RESERVA,        INDORIGEN,              
                 FECRES,                 SALDO_RESERVA_LOCAL,    IDTRANSACCIONANUL,    IDAUTORIZACION)
               VALUES
                (NIDDETSIN,              cCodCobert,             nIdSiniestro,         nIdPoliza, 
                 NULL,                   0,                      0,                    nAJUSTEMONEDA,           
                 nAJUSTELOCAL,           'SOL',                  nNumMod,              cCodTransac,             
                 cCodCptoTransac,        NULL,                   nAJUSTEMONEDA,        'D',                     
                 dFECHA,                 nAJUSTELOCAL,           NULL,                 NULL);
             EXCEPTION
               WHEN OTHERS THEN
                    nCodError := 99;
                    cObservacion := 'ERROR AL INSERTAR COBERTURA COBERTURA_SINIESTRO ';
                    RAISE_APPLICATION_ERROR(-20225,'ERROR AL INSERTAR COBERTURA COBERTURA_SINIESTRO'||SQLERRM);
             END;
          END IF;
       END IF;
       --
       OC_COBERTURA_SINIESTRO.EMITE_RESERVA(nCodCia, nCodEmpresa, nIdSiniestro, nIdPoliza, NIDDETSIN, cCodCobert, nNumMod, NULL);
       IF WFECHA IS NOT NULL OR WID_APLICA_CONTA = 'N' THEN
          nIDTRANSACCION := OBTIENE_TRANSA_RVA_IND(nIdPoliza, nIdSiniestro, NIDDETSIN, cCodCobert, nNumMod,dFECHA); 
          IF WFECHA IS NOT NULL THEN
            CAMBIA_FECHA_CONTA(nIDTRANSACCION, nCodCia, DFECHA, nCodEmpresa); 
            CAMBIA_FECHA_OBSERVACION(nIdSiniestro, nIdPoliza, DFECHA);
          END IF;
          --
         IF WID_APLICA_CONTA = 'N' THEN
            MARCA_NO_ENVIO_CONTABILIDAD(nIDTRANSACCION, nCodCia , DFECHA);
         END IF;
       END IF;
       --
    END IF;
    --
    --
    -- PROCESA SINIESTRO SI ES COLECTIVO
    --
    IF nIdSiniestro > 0 AND WID_COL_INDI = 'C' THEN
       --
       -- VALIDA DETALLE_SINIESTRO ASEG
       --
       BEGIN
         SELECT DSA.IDDETSIN, DSA.COD_ASEGURADO 
           INTO NIDDETSIN,    nCod_Asegurado
           FROM DETALLE_SINIESTRO_ASEG DSA
          WHERE DSA.IDSINIESTRO = nIdSiniestro
            AND DSA.IDDETSIN    = 1;
       EXCEPTION 
         WHEN NO_DATA_FOUND  THEN
              nCodError    := 41;
              cObservacion := 'Codigo Error 41: NO EXISTE EL DETALLE_DE SINIESTRO ASEG';
              RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL DETALLE DE SINIESTRO ASEG - '||nIdSiniestro||' - 1 '||SQLERRM);
         WHEN OTHERS THEN 
              nCodError    := 41;
              cObservacion := 'Codigo Error 41.1: NO EXISTE EL SINIESTRO ASEG OTHERS';
              RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL DETALLE DE SINIESTRO ASEG OTHERS - '||nIdSiniestro||' - 1 '||SQLERRM);
       END;
       --
       -- ESTE IF ES POR SI ENTRA POR UN PAGO
       --
       IF WCODTRANSAC = 'PARVBA' OR WCODTRANSAC = 'PARVAD' THEN
          WCODTRANSAC_PAGO := WCODTRANSAC;
          IF WCODTRANSAC = 'PARVBA'  THEN
             WCODTRANSAC := 'AURVBA';
          ELSE             
             WCODTRANSAC := 'AURVAD';
          END IF;
       END IF;
       --
       cCodTransac := WCODTRANSAC;
       IF WCODCPTOTRANSAC = 'N' THEN
          cCodCptoTransac := WCODTRANSAC;
       ELSE
          cCodCptoTransac := WCODCPTOTRANSAC;
       END IF;
       --
       IF WFECHA IS NULL THEN
          dFECHA := TRUNC(SYSDATE);
       ELSE 
          dFECHA := WFECHA;
       END IF;
       --
       BEGIN
         OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, nIdPoliza, 'Carga Masiva de ajuste a la reserva, el ' ||
                                                      dFECHA||' Motivo: '||cDescSiniestro);
       EXCEPTION
         WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'Error al Insertar la Observacion , Favor de validar la informacion.';
              RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Observacion , Favor de validar la informacion, Error: '||SQLERRM);
       END;
       --
       BEGIN
         SELECT NVL(MAX(NumMod),0) + 1  
           INTO nNumMod
           FROM COBERTURA_SINIESTRO_ASEG
          WHERE IdSiniestro = nIdSiniestro
            AND CodCobert   = cCodCobert
            AND IdPoliza    = nIdPoliza;
       END;
       --
       BEGIN
         SELECT 'S'
           INTO cExisteCob
           FROM COBERTURA_SINIESTRO_ASEG
          WHERE IdSiniestro = nIdSiniestro
            AND CodCobert   = cCodCobert
            AND IdPoliza    = nIdPoliza;
       EXCEPTION
         WHEN NO_DATA_FOUND THEn
              nCodError := 99;
              cObservacion := 'NO Existe Cobertura (SIN Aseg).';
              RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura (SIN Aseg) de '||cCodCobert);
         WHEN TOO_MANY_ROWS THEn
              cExisteCob := 'S'; 
         WHEN OTHERS THEn
              nCodError := 99;
              cObservacion := 'NO Existe Cobertura (SIN Aseg)others.';
              RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura (SIN Aseg)others.'||cCodCobert);
       END;
       --
       IF WCODTRANSAC = 'DIRVAD' OR 
          WCODTRANSAC = 'DIRVBA' THEN
          IF cExisteCob = 'S' THEN
             BEGIN
              SELECT CSA.SALDO_RESERVA
                INTO WSALDO_RESERVA
                FROM COBERTURA_SINIESTRO_ASEG CSA
               WHERE IdSiniestro = nIdSiniestro
                 AND CodCobert   = cCodCobert
                 AND IdPoliza    = nIdPoliza
                 AND CSA.NUMMOD  = nNumMod -1;
             EXCEPTION
               WHEN NO_DATA_FOUND THEn
                    nCodError := 99;
                    cObservacion := 'NO Existe Cobertura (SIN Aseg).';
                    RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura (SIN Aseg) de '||cCodCobert);
             END;
             --
             --IF WSALDO_RESERVA >= nAJUSTEMONEDA THEN
                BEGIN
                  INSERT INTO COBERTURA_SINIESTRO_ASEG
                   (IDDETSIN,               CODCOBERT,              IDSINIESTRO,          IDPOLIZA,
                    COD_ASEGURADO,          DOC_REF_PAGO,           MONTO_PAGADO_MONEDA,  MONTO_PAGADO_LOCAL,
                    MONTO_RESERVADO_MONEDA, MONTO_RESERVADO_LOCAL,  STSCOBERTURA,         NUMMOD,
                    CODTRANSAC,             CODCPTOTRANSAC,         IDTRANSACCION,        SALDO_RESERVA,
                    INDORIGEN,              FECRES,                 SALDO_RESERVA_LOCAL,  IDTRANSACCIONANUL, 
                    IDAUTORIZACION)
                  VALUES
                   (NIDDETSIN,              cCodCobert,             nIdSiniestro,         nIdPoliza, 
                    nCod_Asegurado,          NULL,                   0,                    0,
                    nAJUSTEMONEDA,           nAJUSTELOCAL,           'SOL',                nNumMod,
                    cCodTransac,             cCodCptoTransac,        NULL,                 nAJUSTEMONEDA,   
                    'D',                     dFECHA,                 nAJUSTELOCAL,         NULL,
                    NULL);
                EXCEPTION
                  WHEN OTHERS THEN
                       nCodError := 99;
                       cObservacion := 'ERROR AL INSERTAR COBERTURA COBERTURA_SINIESTRO_ASEG ';
                       RAISE_APPLICATION_ERROR(-20225,'LA RESERVA '||WSALDO_RESERVA||' ES INSUFICIENTE PARA EL AJUSTE '||nAJUSTEMONEDA||'  '||SQLERRM);
                END;
             --ELSE
             ----   nCodError := 99;
             --   cObservacion := 'LA RESERVA ES INSUFICIENTE PARA ESTE AJUSTE. ';
             --   RAISE_APPLICATION_ERROR(-20225,'LA RESERVA '||WSALDO_RESERVA||' ES INSUFICIENTE PARA EL AJUSTE '||nAJUSTEMONEDA||'  '||SQLERRM);
             --END IF;
          END IF;    
       ELSE      
          IF cExisteCob = 'S' THEN
             BEGIN
               INSERT INTO COBERTURA_SINIESTRO_ASEG
                (IDDETSIN,               CODCOBERT,              IDSINIESTRO,          IDPOLIZA,
                 COD_ASEGURADO,          DOC_REF_PAGO,           MONTO_PAGADO_MONEDA,  MONTO_PAGADO_LOCAL,
                 MONTO_RESERVADO_MONEDA, MONTO_RESERVADO_LOCAL,  STSCOBERTURA,         NUMMOD,
                 CODTRANSAC,             CODCPTOTRANSAC,         IDTRANSACCION,        SALDO_RESERVA,
                 INDORIGEN,              FECRES,                 SALDO_RESERVA_LOCAL,  IDTRANSACCIONANUL,
                 IDAUTORIZACION)
               VALUES
                (NIDDETSIN,              cCodCobert,             nIdSiniestro,         nIdPoliza, 
                 nCod_Asegurado,          NULL,                   0,                    0,
                 nAJUSTEMONEDA,           nAJUSTELOCAL,           'SOL',                nNumMod,
                 cCodTransac,             cCodCptoTransac,        NULL,                 nAJUSTEMONEDA,   
                 'D',                     dFECHA,                 nAJUSTELOCAL,         NULL,
                 NULL);
             EXCEPTION
               WHEN OTHERS THEN
                    nCodError := 99;
                    cObservacion := 'ERROR AL INSERTAR COBERTURA COBERTURA_SINIESTRO_ASEG ';
                    RAISE_APPLICATION_ERROR(-20225,'LA RESERVA '||WSALDO_RESERVA||' ES INSUFICIENTE PARA EL AJUSTE '||nAJUSTEMONEDA||'  '||SQLERRM);
             END;
          END IF;
       END IF;
       --
       OC_COBERTURA_SINIESTRO_ASEG.EMITE_RESERVA(nCodCia, nCodEmpresa, nIdSiniestro, nIdPoliza, NIDDETSIN, nCod_Asegurado, cCodCobert, nNumMod, NULL);
       --
       IF WFECHA IS NOT NULL OR WID_APLICA_CONTA = 'N' THEN
          nIDTRANSACCION := OBTIENE_TRANSA_RVA_COL(nIdPoliza, nIdSiniestro, NIDDETSIN, cCodCobert, nNumMod, nCod_Asegurado, dFECHA); 
          IF WFECHA IS NOT NULL THEN
            CAMBIA_FECHA_CONTA(nIDTRANSACCION, nCodCia, DFECHA, nCodEmpresa); 
            CAMBIA_FECHA_OBSERVACION(nIdSiniestro, nIdPoliza, DFECHA);
          END IF;
          --
         IF WID_APLICA_CONTA = 'N' THEN
            MARCA_NO_ENVIO_CONTABILIDAD(nIDTRANSACCION, nCodCia , DFECHA);
         END IF;
       END IF;
       --
    END IF;
    --
    IF cMsjError IS NULL THEN
       IF WCODTRANSAC_PAGO IS NULL THEN
          IF cMsjError IS NULL THEN
             OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'PROCE');
          ELSE
             OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','SINIESTROS_AJUSTES No se puede Cargar la disminucion de rva: '||cMsjError);
             OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
          END IF;
       END IF;
    END IF;
    --
  END LOOP;
  --
EXCEPTION
  WHEN OTHERS THEN
       ROLLBACK;
       OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Error 1: '||SQLERRM);
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END SINIESTROS_AJUSTES;  
--
--
PROCEDURE SINIESTROS_PAGOS_RVA(nIdProcMasivo NUMBER) IS     
cDescSiniestro         OBSERVACION_SINIESTRO.Descripcion%TYPE;
nIdSiniestro           SINIESTRO.IdSiniestro%TYPE;
NIDDETSIN              DETALLE_SINIESTRO_ASEG.IDDETSIN%TYPE;
nIdPoliza              POLIZAS.IdPoliza%TYPE;
nIDetPol               SINIESTRO.IDetPol%TYPE;
nCodCia                POLIZAS.CodCia%TYPE;
nCodEmpresa            POLIZAS.CodEmpresa%TYPE;
nAJUSTELOCAL           SINIESTRO.Monto_Reserva_Local%TYPE;
nAJUSTEMONEDA          SINIESTRO.Monto_Reserva_Moneda%TYPE;
cCod_Moneda            POLIZAS.Cod_Moneda%TYPE;
nTasaCambio            DETALLE_POLIZA.Tasa_Cambio%TYPE;
nCod_Asegurado         ASEGURADO.Cod_Asegurado%TYPE;
cCodCobert             COBERTURA_SINIESTRO_ASEG.CodCobert%TYPE;
cCodTransac            COBERTURA_SINIESTRO_ASEG.CodTransac%TYPE;
WCODTRANSAC            COBERTURA_SINIESTRO_ASEG.CodTransac%TYPE;
cCodCptoTransac        COBERTURA_SINIESTRO_ASEG.CodCptoTransac%TYPE;
WCODCPTOTRANSAC        COBERTURA_SINIESTRO_ASEG.CodCptoTransac%TYPE;
cMsjError              PROCESOS_MASIVOS_LOG.TxtError%TYPE := NULL;
dFECHA                 POLIZAS.FECINIVIG%TYPE;
WFECHA                 POLIZAS.FECINIVIG%TYPE;
nCodError              NUMBER(2) := Null;
cObservacion           VARCHAR2(100);
WID_COL_INDI           VARCHAR2(1);
WID_APLICA_CONTA       VARCHAR2(1);
nIDTRANSACCION         TRANSACCION.IDTRANSACCION%TYPE;
cNUMSINIREF            SINIESTRO.NUMSINIREF%TYPE;
-- PARA PAGOS
cTipoAprobacion        APROBACIONES.Tipo_Aprobacion%TYPE := 'P';
nNum_Aprobacion        APROBACIONES.Num_Aprobacion%TYPE;
nPorcConcepto          CATALOGO_DE_CONCEPTOS.PorcConcepto%TYPE;
nMontoConcepto         CATALOGO_DE_CONCEPTOS.MontoConcepto%TYPE;
cIndTipoConcepto       CATALOGO_DE_CONCEPTOS.IndTipoConcepto%TYPE;
nBENEF                 BENEF_SIN.BENEF%TYPE;
cNOMBRE_BENEF       	 BENEF_SIN.NOMBRE%TYPE;
cAPE_PAT_BENEF         BENEF_SIN.APELLIDO_PATERNO%TYPE;
cAPE_MAT_BENEF         BENEF_SIN.APELLIDO_MATERNO%TYPE;
nPORC_PART             BENEF_SIN.PORCEPART%TYPE;
nID_PARENTESCO         BENEF_SIN.CODPARENT%TYPE;
cID_SEXO               BENEF_SIN.SEXO%TYPE;
cRFC                   BENEF_SIN.NUM_DOC_TRIBUTARIO%TYPE;
nCUENTA_CLAVE	         BENEF_SIN.NUMCUENTABANCARIA%TYPE;
cID_BANCO              BENEF_SIN.ENT_FINANCIERA%TYPE;
WEXISTE_BENEF          NUMBER  := 0;
cID_APLICA_IVA         VARCHAR2(1);
nIVA_AJUSTEMONEDA      NUMBER(28,2);
nIVA_AJUSTELOCAL       NUMBER(28,2);
WCNUMCUENTABANCARIA    BENEF_SIN.NUMCUENTABANCARIA%TYPE;  --  RF2  CAMPOS NUEVOS ABENEFICIARIO
WCINDAPLICAISR         BENEF_SIN.INDAPLICAISR%TYPE;
WNPORCENTISR           BENEF_SIN.PORCENTISR %TYPE;
WCIDTIPO_PAGO          BENEF_SIN.IDTIPO_PAGO%TYPE;
WCID_EDAD_MINORIA      BENEF_SIN.ID_EDAD_MINORIA%TYPE;
WCNOMBRE_MINORIA       BENEF_SIN.NOMBRE_MINORIA%TYPE;
WNPORC_MINORIA         BENEF_SIN.PORC_MINORIA%TYPE;
CTIPO_PAGO             BENEF_SIN.TIPO_PAGO%TYPE;
cUsuario varchar2(50);
--
CURSOR SIN_Q IS
   SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
          NumDetUnico, RegDatosProc, TipoProceso, IndColectiva
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;
--
BEGIN
  --
  FOR X IN SIN_Q LOOP
    nCodCia          := X.CodCia;
    nCodempresa      := X.CodEmpresa;
    cMsjError        := NULL;
    --
    nIdSiniestro        := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,1,',')));
    cCodCobert          :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,2,','));
    WCODTRANSAC         :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,3,','));
    WCODCPTOTRANSAC     :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,4,','));
    nAJUSTEMONEDA       := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,5,',')));
    WFECHA              :=   TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,',')),'dd/mm/yyyy');
    WID_COL_INDI        :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,7,','));
    WID_APLICA_CONTA    :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,8,','));
    cDescSiniestro      :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,9,','));
    nCod_Asegurado      := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,10,',')));
    cNOMBRE_BENEF       :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,11,','));
    cAPE_PAT_BENEF      :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,12,','));
    cAPE_MAT_BENEF      :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,13,','));
    nPORC_PART          := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,14,',')));
    nID_PARENTESCO      :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,15,','));
    cID_SEXO            :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,16,','));
    cRFC                :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,17,','));
    nCUENTA_CLAVE       :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,18,','));
    cID_BANCO           :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,19,','));
    cID_APLICA_IVA      :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,20,','));
    WCNUMCUENTABANCARIA :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,21,','));     --  RF2  CAMPOS NUEVOS ABENEFICIARIO
    WCINDAPLICAISR      :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,22,','));
    WNPORCENTISR        := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,23,',')));
    WCIDTIPO_PAGO       :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,24,','));
    WCID_EDAD_MINORIA   :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,25,','));
    WCNOMBRE_MINORIA    :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,26,','));
    WNPORC_MINORIA      := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,27,',')));
    --
    -- VALIDA SINIESTRO
    --
    BEGIN
      SELECT IdSiniestro,  S.IDPOLIZA, S.IDETPOL, S.COD_MONEDA,  S.NUMSINIREF 
        INTO nIdSiniestro, nIdPoliza,  nIDetPol,  cCod_Moneda ,  cNUMSINIREF
        FROM SINIESTRO S
       WHERE S.IDSINIESTRO = nIdSiniestro;
    EXCEPTION 
      WHEN NO_DATA_FOUND  THEN
           nCodError    := 41;
           cObservacion := 'Codigo Error 41: NO EXISTE EL SINIESTRO';
           RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL SINIESTRO - '||nIdSiniestro||' - '||SQLERRM);
      WHEN OTHERS THEN 
           nCodError    := 41;
           cObservacion := 'Codigo Error 41.1: NO EXISTE EL SINIESTRO OTHERS';
           RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL SINIESTRO  OTHERS- '||nIdSiniestro||' - '||SQLERRM);
    END;
    --
    nTasaCambio  := OC_GENERALES.TASA_DE_CAMBIO(cCod_Moneda, TRUNC(SYSDATE));
    nAJUSTELOCAL := nAJUSTEMONEDA * nTasaCambio;
    --
    -- PROCESA SINIESTRO SI ES INDIVIDUAL
    --
    IF nIdSiniestro > 0 AND WID_COL_INDI = 'I' THEN
       --
       -- VALIDA DETALLE_SINIESTRO
       --
       BEGIN
         SELECT DS.IDDETSIN 
           INTO NIDDETSIN
           FROM DETALLE_SINIESTRO DS
          WHERE DS.IDSINIESTRO = nIdSiniestro
            AND DS.IDDETSIN    = 1;
       EXCEPTION 
         WHEN NO_DATA_FOUND  THEN
              nCodError    := 41;
              cObservacion := 'Codigo Error 41: NO EXISTE EL DETALLE DE SINIESTRO';
              RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL DETALLE DE SINIESTRO  - '||nIdSiniestro||' - 1 '||SQLERRM);
         WHEN OTHERS THEN 
              nCodError    := 41;
              cObservacion := 'Codigo Error 41.1: NO EXISTE EL DETALLE DE SINIESTRO OTHERS';
              RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL DETALLE DE SINIESTRO OTHERS- '||nIdSiniestro||' - 1 '||SQLERRM);
       END;
       --
       cCodTransac := WCODTRANSAC;
       IF WCODCPTOTRANSAC = 'N' THEN
          cCodCptoTransac := WCODTRANSAC;
       ELSE
          cCodCptoTransac := WCODCPTOTRANSAC;
       END IF;
       --
       IF WFECHA IS NULL THEN
          dFECHA := TRUNC(SYSDATE);
       ELSE 
          dFECHA := WFECHA;
       END IF;
       --
       BEGIN
         OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, nIdPoliza, 'Carga Masiva de pagos, el ' ||
                                                      dFECHA||' Motivo: '||cDescSiniestro);
       EXCEPTION
         WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'Error al Insertar la Observacion , Favor de validar la informacion.';
              RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Observacion , Favor de validar la informacion, Error: '||SQLERRM);
       END;
       --
       BEGIN
         nNum_Aprobacion := OC_APROBACIONES.INSERTA_APROBACION(nIdSiniestro, nIdPoliza, nAJUSTELOCAL,
                                                               nAJUSTEMONEDA, cTipoAprobacion, 'APR', NULL);
       EXCEPTION
         WHEN OTHERS THEN
           nCodError := 99;
           cObservacion := 'Error al Insertar la Aprobación.';
           RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Aprobación: '|| nIdSiniestro || ' ' || SQLERRM);
       END;
       --
       -- DETALLE DE PRIMA
       --
       BEGIN
         INSERT INTO DETALLE_APROBACION
            (Num_Aprobacion,     IdDetAprob,      Cod_Pago,          Monto_Local,
             Monto_Moneda,       IdSiniestro,     CodTransac,        CodCptoTransac)
         VALUES
            (nNum_Aprobacion,    1,               cCodCobert,        nAJUSTELOCAL,
             nAJUSTEMONEDA,      nIdSiniestro,    cCodTransac,       cCodCptoTransac);
       EXCEPTION
         WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'Insertar en DETALLE APROBACION PRIMA- Ocurrio el siguiente error.';
              RAISE_APPLICATION_ERROR(-20225,'Insertar en DETALLE APROBACION PRIMA- Ocurrio el siguiente error: '||SQLERRM);
       END;
       --
       -- DETALLE DE IVA
       --
       IF cID_APLICA_IVA = 'S' THEN
          OC_CATALOGO_DE_CONCEPTOS.TIPO_CONCEPTO(X.CodCia, 'IVAFEE', cIndTipoConcepto, nPorcConcepto, nMontoConcepto);
          --
          nIVA_AJUSTEMONEDA := (nAJUSTEMONEDA) * (nPorcConcepto / 100);
          -- 
          nIVA_AJUSTELOCAL  := nIVA_AJUSTEMONEDA * nTasaCambio;
          --    
          BEGIN
            INSERT INTO DETALLE_APROBACION
              (Num_Aprobacion,     IdDetAprob,      Cod_Pago,          Monto_Local,
               Monto_Moneda,       IdSiniestro,     CodTransac,        CodCptoTransac)
            VALUES
              (nNum_Aprobacion,    2,               'IMPTO',           nIVA_AJUSTELOCAL,
               nIVA_AJUSTEMONEDA,  nIdSiniestro,    cCodTransac,       'IVAFEE');
          EXCEPTION
            WHEN OTHERS THEN
                 nCodError := 99;
                 cObservacion := 'Insertar en DETALLE APROBACION IVA - Ocurrio el siguiente error.';
                 RAISE_APPLICATION_ERROR(-20225,'Insertar en DETALLE APROBACION IVA - Ocurrio el siguiente error: '||SQLERRM);
          END;
          --
       END IF;
       --
       CTIPO_PAGO := SUBSTR(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PAGOBENEF','TRS'),1,30);   --  RF2  SE CAMBIO FUNCIONALIDAD DE BENEF
       --
       SELECT COUNT(*)
         INTO WEXISTE_BENEF
         FROM BENEF_SIN BS
        WHERE BS.IDSINIESTRO   = nIdSiniestro
          AND BS.IDPOLIZA      = nIdPoliza
          AND BS.COD_ASEGURADO = nCod_Asegurado;
       --
       IF WEXISTE_BENEF > 0 THEN
          BEGIN
            SELECT MAX(NVL(BS.BENEF,0)) + 1
              INTO nBENEF
              FROM BENEF_SIN BS
             WHERE BS.IDSINIESTRO = nIdSiniestro
               AND BS.IDPOLIZA    = nIdPoliza;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 nBENEF := 1;
            WHEN OTHERS THEN
                 nCodError := 99;
                 cObservacion := 'Error al extraer maximo beneficiarios';
                 RAISE_APPLICATION_ERROR(-20225,'Error al extraer maximo beneficiarios error: '||SQLERRM);
          END;
       ELSE
           nBENEF := 1;
       END IF;
  BEGIN --PST 27-11-2023 TODO EL QUERY
    SELECT APEX_CUSTOM_AUTH.GET_USERNAME INTO cUsuario FROM DUAL;
	IF(cUsuario IS NULL)THEN
		cUsuario := USER;
	END IF;
  EXCEPTION WHEN OTHERS THEN
    cUsuario := USER;
  END;       --
       BEGIN
         INSERT INTO BENEF_SIN
           (IDSINIESTRO,         IDPOLIZA,           COD_ASEGURADO,         BENEF,
            NOMBRE,              PORCEPART,          CODPARENT,             ESTADO,
            SEXO,                FECESTADO,          FECALTA,               FECBAJA,
            --
            MOTBAJA,             OBERVACIONES,       DIRECCION,             EMAIL,
            TELEFONO,            CUENTA_CLAVE,       ENT_FINANCIERA,        INDPAGO,
            PORCEAPL,            FECNAC,             NUMCUENTABANCARIA,     INDAPLICAISR,
            --
            PORCENTISR,          TIPO_ID_TRIBUTARIO, NUM_DOC_TRIBUTARIO,    APELLIDO_PATERNO,
            APELLIDO_MATERNO,    TIPO_PAGO,          FECFIRMARECLAMACION,   TELEFONO_LOCAL,
            CODCIA,              CODEMPRESA,         CODUSUARIO,            FECREGISTRO,
            --
            IDTIPO_PAGO,         TP_IDENTIFICACION,  NUM_IDENTIFICACION,    COD_CONVENIO,
            ID_EDAD_MINORIA,     NOMBRE_MINORIA,     PORC_MINORIA,          SIT_CLIENTE,
            SIT_REFERENCIA,      SIT_CONCEPTO
            )
         VALUES
            (nIdSiniestro,       nIdPoliza,          nCod_Asegurado,         nBENEF, 
             cNOMBRE_BENEF,      nPORC_PART,         nID_PARENTESCO,         'ACT',
             cID_SEXO,           TRUNC(SYSDATE),     TRUNC(SYSDATE),         '',
             --
             '',                 'Carga masiva',     '',                     '',
             '',                 nCUENTA_CLAVE,      cID_BANCO,              '',         
             '',                 '',                 WCNUMCUENTABANCARIA,    WCINDAPLICAISR,
             --
             WNPORCENTISR,       'RFC',              cRFC,                   cAPE_PAT_BENEF,
             cAPE_MAT_BENEF,     CTIPO_PAGO,         TRUNC(SYSDATE),         '',
             nCodCia,            nCodempresa,        cusuario,                   TRUNC(SYSDATE),
             --
             WCIDTIPO_PAGO,      '',                 '',                     '',
             WCID_EDAD_MINORIA,  WCNOMBRE_MINORIA,   WNPORC_MINORIA,         '',
             '',                 '');
       EXCEPTION
         WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'Error al Insertar Beneficiario de Pago.';
              RAISE_APPLICATION_ERROR(-20225,'Error al Insertar Beneficiario de Pago '|| cNumSiniRef || ' ' || SQLERRM);
       END;
       --       
       BEGIN
         UPDATE APROBACIONES
            SET BENEF          = nBenef,
                CTALIQUIDADORA = 8601
          WHERE Num_Aprobacion = nNum_Aprobacion
            AND IdSiniestro    = nIdSiniestro
            AND IdPoliza       = nIdPoliza;
       EXCEPTION
         WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'Error al Actualizar la Aprobación Aseg con el Beneficiario.';
              RAISE_APPLICATION_ERROR(-20225,'Error al Actualizar la Aprobación Aseg con el Beneficiario '|| cNumSiniRef || ' ' || SQLERRM);
       END;
       --
       BEGIN
         OC_APROBACIONES.PAGAR(X.CodCia, X.CodEmpresa, nNum_Aprobacion, nIdSiniestro, nIdPoliza, 1);
       EXCEPTION
         WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'Error al Pagar la Aprobación del Siniestro.';
              RAISE_APPLICATION_ERROR(-20225,'Error al Pagar la Aprobación del Siniestro: '|| nIdSiniestro || ' ' || SQLERRM);
       END;
       --
       IF WFECHA IS NOT NULL OR WID_APLICA_CONTA = 'N' THEN
          nIDTRANSACCION := OBTIENE_TRANSA_PAG_IND(nNUM_APROBACION, nIdPoliza , nIdSiniestro , NIDDETSIN , DFECHA);          
          --
          IF WFECHA IS NOT NULL THEN
            CAMBIA_FECHA_CONTA(nIDTRANSACCION, nCodCia, DFECHA, nCodEmpresa); 
            CAMBIA_FECHA_OBSERVACION(nIdSiniestro, nIdPoliza, DFECHA);
          END IF;
          --
         IF WID_APLICA_CONTA = 'N' THEN
            MARCA_NO_ENVIO_CONTABILIDAD(nIDTRANSACCION, nCodCia , DFECHA);
         END IF;
       END IF;
    END IF;
    --
    --
    -- PROCESA SINIESTRO SI ES COLECTIVO
    --
    --
    IF nIdSiniestro > 0 AND WID_COL_INDI = 'C' THEN
       --
       -- VALIDA DETALLE_SINIESTRO ASEG
       --
       BEGIN
         SELECT DSA.IDDETSIN 
           INTO NIDDETSIN   
           FROM DETALLE_SINIESTRO_ASEG DSA
          WHERE DSA.IDSINIESTRO = nIdSiniestro
            AND DSA.IDDETSIN    = 1;
       EXCEPTION 
         WHEN NO_DATA_FOUND  THEN
              nCodError    := 41;
              cObservacion := 'Codigo Error 41: NO EXISTE EL DETALLE_DE SINIESTRO ASEG';
              RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL DETALLE DE SINIESTRO ASEG - '||nIdSiniestro||' - 1 '||SQLERRM);
         WHEN OTHERS THEN 
              nCodError    := 41;
              cObservacion := 'Codigo Error 41.1: NO EXISTE EL SINIESTRO ASEG OTHERS';
              RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL DETALLE DE SINIESTRO ASEG OTHERS - '||nIdSiniestro||' - 1 '||SQLERRM);
       END;
       --
       cCodTransac := WCODTRANSAC;
       IF WCODCPTOTRANSAC = 'N' THEN
          cCodCptoTransac := WCODTRANSAC;
       ELSE
          cCodCptoTransac := WCODCPTOTRANSAC;
       END IF;
       --
       IF WFECHA IS NULL THEN
          dFECHA := TRUNC(SYSDATE);
       ELSE 
          dFECHA := WFECHA;
       END IF;
       --
       BEGIN
         OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, nIdPoliza, 'Carga Masiva de ajuste a la reserva, el ' ||
                                                      dFECHA||' Motivo: '||cDescSiniestro);
      EXCEPTION
         WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'Error al Insertar la Observacion , Favor de validar la informacion.';
              RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Observacion , Favor de validar la informacion, Error: '||SQLERRM);
       END;
       --       
       BEGIN
         nNum_Aprobacion := OC_APROBACION_ASEG.INSERTA_APROBACION(nIdSiniestro, nIdPoliza, nCod_Asegurado, nAJUSTELOCAL,
                                                               nAJUSTEMONEDA, cTipoAprobacion, 'APR', NULL);
       EXCEPTION
         WHEN OTHERS THEN
           nCodError := 99;
           cObservacion := 'Error al Insertar la Aprobación.';
           RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Aprobación: '|| nIdSiniestro || ' ' || SQLERRM);
       END;
       --
       -- DETALLE DE PRIMA
       --
       BEGIN
         INSERT INTO DETALLE_APROBACION_ASEG
            (Num_Aprobacion,     IdDetAprob,      Cod_Pago,          Monto_Local,
             Monto_Moneda,       IdSiniestro,     CodTransac,        CodCptoTransac)
         VALUES
            (nNum_Aprobacion,    1,               cCodCobert,        nAJUSTELOCAL,
             nAJUSTEMONEDA,      nIdSiniestro,    cCodTransac,       cCodCptoTransac);
       EXCEPTION
         WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'Insertar en DETALLE APROBACION PRIMA- Ocurrio el siguiente error.';
              RAISE_APPLICATION_ERROR(-20225,'Insertar en DETALLE APROBACION PRIMA- Ocurrio el siguiente error: '||SQLERRM);
       END;
       --
       -- DETALLE DE IVA
       --
       IF cID_APLICA_IVA = 'S' THEN
          OC_CATALOGO_DE_CONCEPTOS.TIPO_CONCEPTO(X.CodCia, 'IVAFEE', cIndTipoConcepto, nPorcConcepto, nMontoConcepto);
          --
          nIVA_AJUSTEMONEDA := (nAJUSTEMONEDA) * (nPorcConcepto / 100);
          -- 
          nIVA_AJUSTELOCAL  := nIVA_AJUSTEMONEDA * nTasaCambio;
          --    
          BEGIN
            INSERT INTO DETALLE_APROBACION_ASEG
              (Num_Aprobacion,     IdDetAprob,      Cod_Pago,          Monto_Local,
               Monto_Moneda,       IdSiniestro,     CodTransac,        CodCptoTransac)
            VALUES
              (nNum_Aprobacion,    2,               'IMPTO',           nIVA_AJUSTELOCAL,
               nIVA_AJUSTEMONEDA,  nIdSiniestro,    cCodTransac,       'IVAFEE');
          EXCEPTION
            WHEN OTHERS THEN
                 nCodError := 99;
                 cObservacion := 'Insertar en DETALLE APROBACION IVA - Ocurrio el siguiente error.';
                 RAISE_APPLICATION_ERROR(-20225,'Insertar en DETALLE APROBACION IVA - Ocurrio el siguiente error: '||SQLERRM);
          END;
          --
       END IF;
       CTIPO_PAGO := SUBSTR(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PAGOBENEF','TRS'),1,30); --  RF2  SE CAMBIO FUNCIONALIDAD DE BENEF
       --
       SELECT COUNT(*)
         INTO WEXISTE_BENEF
         FROM BENEF_SIN BS
        WHERE BS.IDSINIESTRO   = nIdSiniestro
          AND BS.IDPOLIZA      = nIdPoliza
          AND BS.COD_ASEGURADO = nCod_Asegurado;
       --
       IF WEXISTE_BENEF > 0 THEN
          BEGIN
            SELECT MAX(NVL(BS.BENEF,0)) + 1
              INTO nBENEF
              FROM BENEF_SIN BS
             WHERE BS.IDSINIESTRO = nIdSiniestro
               AND BS.IDPOLIZA    = nIdPoliza;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 nBENEF := 1;
            WHEN OTHERS THEN
                 nCodError := 99;
                 cObservacion := 'Error al extraer maximo beneficiarios';
                 RAISE_APPLICATION_ERROR(-20225,'Error al extraer maximo beneficiarios error: '||SQLERRM);
          END;
       ELSE
           nBENEF := 1;
       END IF;
  BEGIN --PST 27-11-2023 TODO EL QUERY
    SELECT APEX_CUSTOM_AUTH.GET_USERNAME INTO cUsuario FROM DUAL;
	IF(cUsuario IS NULL)THEN
		cUsuario := USER;
	END IF;
  EXCEPTION WHEN OTHERS THEN
    cUsuario := USER;
  END;       --
       BEGIN
         INSERT INTO BENEF_SIN
           (IDSINIESTRO,         IDPOLIZA,           COD_ASEGURADO,         BENEF,
            NOMBRE,              PORCEPART,          CODPARENT,             ESTADO,
            SEXO,                FECESTADO,          FECALTA,               FECBAJA,
            --
            MOTBAJA,             OBERVACIONES,       DIRECCION,             EMAIL,
            TELEFONO,            CUENTA_CLAVE,       ENT_FINANCIERA,        INDPAGO,
            PORCEAPL,            FECNAC,             NUMCUENTABANCARIA,     INDAPLICAISR,
            --
            PORCENTISR,          TIPO_ID_TRIBUTARIO, NUM_DOC_TRIBUTARIO,    APELLIDO_PATERNO,
            APELLIDO_MATERNO,    TIPO_PAGO,          FECFIRMARECLAMACION,   TELEFONO_LOCAL,
            CODCIA,              CODEMPRESA,         CODUSUARIO,            FECREGISTRO,
            --
            IDTIPO_PAGO,         TP_IDENTIFICACION,  NUM_IDENTIFICACION,    COD_CONVENIO,
            ID_EDAD_MINORIA,     NOMBRE_MINORIA,     PORC_MINORIA,          SIT_CLIENTE,
            SIT_REFERENCIA,      SIT_CONCEPTO
            )
         VALUES
            (nIdSiniestro,       nIdPoliza,          nCod_Asegurado,         nBENEF, 
             cNOMBRE_BENEF,      nPORC_PART,         nID_PARENTESCO,         'ACT',
             cID_SEXO,           TRUNC(SYSDATE),     TRUNC(SYSDATE),         '',
             --
             '',                 'Carga masiva',     '',                     '',
             '',                 nCUENTA_CLAVE,      cID_BANCO,              '',         
             '',                 '',                 WCNUMCUENTABANCARIA,    WCINDAPLICAISR,
             --
             WNPORCENTISR,       'RFC',              cRFC,                   cAPE_PAT_BENEF,
             cAPE_MAT_BENEF,     CTIPO_PAGO,         TRUNC(SYSDATE),         '',
             nCodCia,            nCodempresa,        cUsuario,                   TRUNC(SYSDATE),
             --
             WCIDTIPO_PAGO,      '',                 '',                     '',
             WCID_EDAD_MINORIA,  WCNOMBRE_MINORIA,   WNPORC_MINORIA,         '',
             '',                 '');
       EXCEPTION
         WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'Error al Insertar Beneficiario de Pago.';
              RAISE_APPLICATION_ERROR(-20225,'Error al Insertar Beneficiario de Pago '|| cNumSiniRef || ' ' || SQLERRM);
       END;
       --       
       BEGIN
         UPDATE APROBACION_ASEG
            SET BENEF          = nBenef,
                CTALIQUIDADORA = 8601
          WHERE Num_Aprobacion = nNum_Aprobacion
            AND IdSiniestro    = nIdSiniestro
            AND IdPoliza       = nIdPoliza;
       EXCEPTION
         WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'Error al Actualizar la Aprobación Aseg con el Beneficiario.';
              RAISE_APPLICATION_ERROR(-20225,'Error al Actualizar la Aprobación Aseg con el Beneficiario '|| cNumSiniRef || ' ' || SQLERRM);
       END;
       --
       BEGIN
         OC_APROBACION_ASEG.PAGAR(X.CodCia, X.CodEmpresa, nNum_Aprobacion, nIdSiniestro, nIdPoliza, nCod_Asegurado, 1);
       EXCEPTION
         WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'Error al Pagar la Aprobación aseg del Siniestro.';
              RAISE_APPLICATION_ERROR(-20225,'Error al Pagar la Aprobación aseg del Siniestro: '|| nIdSiniestro || ' ' || SQLERRM);
       END;
       --
       IF WFECHA IS NOT NULL OR WID_APLICA_CONTA = 'N' THEN
          nIDTRANSACCION := OBTIENE_TRANSA_PAG_COL(nNUM_APROBACION, nIdPoliza , nIdSiniestro , NIDDETSIN , DFECHA, nCod_Asegurado);
          IF WFECHA IS NOT NULL THEN
            CAMBIA_FECHA_CONTA(nIDTRANSACCION, nCodCia, DFECHA, nCodEmpresa); 
            CAMBIA_FECHA_OBSERVACION(nIdSiniestro, nIdPoliza, DFECHA);
          END IF;
          --
         IF WID_APLICA_CONTA = 'N' THEN
            MARCA_NO_ENVIO_CONTABILIDAD(nIDTRANSACCION, nCodCia , DFECHA);
         END IF;
       END IF;

       --
    END IF;
    --
    IF cMsjError IS NULL THEN
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'PROCE');
    ELSE
       OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','SINIESTROS_PAGOS DE AJUSTES No se puede Cargar EL PAGO: '||cMsjError);
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
    END IF;
    --
  END LOOP;
  --
EXCEPTION
  WHEN OTHERS THEN
       ROLLBACK;
       OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Error 1: '||SQLERRM);
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END SINIESTROS_PAGOS_RVA;  
--
--
FUNCTION OBTIENE_TRANSA_RVA_IND(nIdPoliza NUMBER,    nIdSiniestro NUMBER, 
                                NIDDETSIN NUMBER,    cCodCobert   VARCHAR2, 
                                nNumMod   NUMBER,    DFECHA       DATE) RETURN NUMBER IS
--                       
nIDTRANSACCION  COBERTURA_SINIESTRO.IDTRANSACCION%TYPE;
--
BEGIN
  BEGIN
    SELECT C.IDTRANSACCION
      INTO nIDTRANSACCION
      FROM COBERTURA_SINIESTRO C
     WHERE C.IDPOLIZA      = nIdPoliza
       AND C.IDSINIESTRO   = nIdSiniestro
       AND C.IDDETSIN      = NIDDETSIN
       AND C.CODCOBERT     = cCodCobert
       AND C.NUMMOD        = nNumMod
       AND C.FECRES        = DFECHA;
  EXCEPTION
    WHEN NO_DATA_FOUND THEn
         nIDTRANSACCION := 0;
    WHEN TOO_MANY_ROWS THEn
         nIDTRANSACCION := 0;
    WHEN OTHERS THEn
         nIDTRANSACCION := 0;
  END;
  --
  RETURN (nIDTRANSACCION);
  --
END OBTIENE_TRANSA_RVA_IND;  
--
--
FUNCTION OBTIENE_TRANSA_RVA_COL(nIdPoliza  NUMBER,    nIdSiniestro NUMBER,    NIDDETSIN      NUMBER,
                                cCodCobert VARCHAR2,  nNumMod      NUMBER,    nCod_Asegurado NUMBER,   DFECHA DATE) RETURN NUMBER IS 
--                       
nIDTRANSACCION  COBERTURA_SINIESTRO_ASEG.IDTRANSACCION%TYPE;
--
BEGIN
  BEGIN
    SELECT C.IDTRANSACCION
      INTO nIDTRANSACCION
      FROM COBERTURA_SINIESTRO_ASEG C
     WHERE C.IDPOLIZA      = nIdPoliza
       AND C.IDSINIESTRO   = nIdSiniestro
       AND C.IDDETSIN      = NIDDETSIN
       AND C.CODCOBERT     = cCodCobert
       AND C.NUMMOD        = nNumMod
       AND C.COD_ASEGURADO = nCod_Asegurado
       AND C.FECRES        = DFECHA;
  EXCEPTION
    WHEN NO_DATA_FOUND THEn
         nIDTRANSACCION := 0;
    WHEN TOO_MANY_ROWS THEn
         nIDTRANSACCION := 0;
    WHEN OTHERS THEn
         nIDTRANSACCION := 0;
  END;
  --
  RETURN (nIDTRANSACCION);
  --
END OBTIENE_TRANSA_RVA_COL;  
--
--
FUNCTION OBTIENE_TRANSA_PAG_IND(nNUM_APROBACION NUMBER,   nIdPoliza NUMBER,    nIdSiniestro NUMBER, 
                                NIDDETSIN       NUMBER,   DFECHA    DATE) RETURN NUMBER IS
--     
nIDTRANSACCION  COBERTURA_SINIESTRO.IDTRANSACCION%TYPE;
--
BEGIN
  BEGIN
    SELECT A.IDTRANSACCION
      INTO nIDTRANSACCION
      FROM APROBACIONES A
     WHERE A.IDPOLIZA       = nIdPoliza
       AND A.IDSINIESTRO    = nIdSiniestro
       AND A.NUM_APROBACION = nNUM_APROBACION
       AND A.IDDETSIN       = NIDDETSIN
       AND A.FECPAGO        = DFECHA;
  EXCEPTION
    WHEN NO_DATA_FOUND THEn
         nIDTRANSACCION := 0;
    WHEN TOO_MANY_ROWS THEn
         nIDTRANSACCION := 0;
    WHEN OTHERS THEn
         nIDTRANSACCION := 0;
  END;
  --
  RETURN (nIDTRANSACCION);
  --
END OBTIENE_TRANSA_PAG_IND;  
--
--
FUNCTION OBTIENE_TRANSA_PAG_COL(nNUM_APROBACION NUMBER,   nIdPoliza NUMBER,    nIdSiniestro   NUMBER, 
                                NIDDETSIN       NUMBER,   DFECHA    DATE,      nCod_Asegurado NUMBER) RETURN NUMBER IS
--     
nIDTRANSACCION  COBERTURA_SINIESTRO.IDTRANSACCION%TYPE;
--
BEGIN
  BEGIN
    SELECT A.IDTRANSACCION
      INTO nIDTRANSACCION
      FROM APROBACION_ASEG A
     WHERE A.IDPOLIZA      = nIdPoliza
       AND A.IDSINIESTRO   = nIdSiniestro
       AND A.NUM_APROBACION = nNUM_APROBACION
       AND A.IDDETSIN      = NIDDETSIN
       AND A.FECPAGO       = DFECHA
       AND A.COD_ASEGURADO = nCod_Asegurado;
  EXCEPTION
    WHEN NO_DATA_FOUND THEn
         nIDTRANSACCION := 0;
    WHEN TOO_MANY_ROWS THEn
         nIDTRANSACCION := 0;
    WHEN OTHERS THEn
         nIDTRANSACCION := 0;
  END;
  --
  RETURN (nIDTRANSACCION);
  --
END OBTIENE_TRANSA_PAG_COL;  
--
--
PROCEDURE CAMBIA_FECHA_CONTA(nIDTRANSACCION NUMBER, nCodCia NUMBER, DFECHA DATE, nCodEmpresa NUMBER) IS 
--
nNUMCOMPROB     COMPROBANTES_CONTABLES.NUMCOMPROB%type;
--
BEGIN
  BEGIN
    SELECT CC.NUMCOMPROB
      INTO nNUMCOMPROB
      FROM COMPROBANTES_CONTABLES CC
     WHERE CC.CODCIA         = nCodCia
       AND CC.NUMTRANSACCION = nIDTRANSACCION;    
  EXCEPTION
    WHEN NO_DATA_FOUND THEn
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Comprobante Contable de transacion CAMBIA_FECHA_CONTA - '||nIDTRANSACCION);
    WHEN TOO_MANY_ROWS THEn
         RAISE_APPLICATION_ERROR(-20225,'Comprobante Contable Duplicada  de transacion CAMBIA_FECHA_CONTA- '||nIDTRANSACCION);
    WHEN OTHERS THEn
         RAISE_APPLICATION_ERROR(-20225,'Comprobante Contable con problemas  de transacion CAMBIA_FECHA_CONTA- '||nIDTRANSACCION);
  END;
  --  
  UPDATE TRANSACCION T
     SET T.FECHATRANSACCION = DFECHA
   WHERE T.IDTRANSACCION = nIDTRANSACCION
     AND T.CODCIA        = nCodCia
     AND T.CODEMPRESA    = nCodEmpresa;
  --
  UPDATE COMPROBANTES_CONTABLES CC
     SET CC.FECCOMPROB = DFECHA,
         CC.FECSTS     = DFECHA
   WHERE CC.CODCIA     = nCodCia
     AND CC.NUMCOMPROB = nNUMCOMPROB;
  --
  UPDATE COMPROBANTES_DETALLE CD
     SET CD.FECDETALLE = DFECHA
   WHERE CD.CODCIA     = nCodCia
     AND CD.NUMCOMPROB = nNUMCOMPROB;
  --
END CAMBIA_FECHA_CONTA;  
--
--
PROCEDURE CAMBIA_FECHA_OBSERVACION(nIdSiniestro NUMBER, nIdPoliza NUMBER, DFECHA DATE) IS 
--
nIdObserva  OBSERVACION_SINIESTRO.IDOBSERVA%TYPE;
--
BEGIN
  BEGIN
    SELECT MAX(O.IDOBSERVA)
      INTO nIdObserva
      FROM OBSERVACION_SINIESTRO O
     WHERE IdSiniestro = nIdSiniestro
       AND IdPoliza    = nIdPoliza;
 EXCEPTION
    WHEN NO_DATA_FOUND THEn
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Observacion de siniestro - '||nIdSiniestro);
    WHEN TOO_MANY_ROWS THEn
         RAISE_APPLICATION_ERROR(-20225,'Observacion Duplicada de siniestro - '||nIdSiniestro);
    WHEN OTHERS THEn
         RAISE_APPLICATION_ERROR(-20225,'Observacion con problemas de siniestro - '||nIdSiniestro);
  END;
  --  
  UPDATE OBSERVACION_SINIESTRO O
     SET O.FECOBSERV = DFECHA
   WHERE IdSiniestro = nIdSiniestro
     AND IdPoliza    = nIdPoliza
     AND IDOBSERVA   = nIdObserva;
  --
END CAMBIA_FECHA_OBSERVACION;  
--
--
PROCEDURE MARCA_NO_ENVIO_CONTABILIDAD(nIDTRANSACCION NUMBER, nCodCia NUMBER, DFECHA DATE) IS 
--
nNUMCOMPROB     COMPROBANTES_CONTABLES.NUMCOMPROB%type;
--
BEGIN
  BEGIN
    SELECT CC.NUMCOMPROB
      INTO nNUMCOMPROB
      FROM COMPROBANTES_CONTABLES CC
     WHERE CC.CODCIA         = nCodCia
       AND CC.NUMTRANSACCION = nIDTRANSACCION;    
  EXCEPTION
    WHEN NO_DATA_FOUND THEn
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Comprobante Contable de transacion MARCA_NO_ENVIO_CONTABILIDAD- '||nIDTRANSACCION);
    WHEN TOO_MANY_ROWS THEn
         RAISE_APPLICATION_ERROR(-20225,'Comprobante Contable Duplicada  de transacion MARCA_NO_ENVIO_CONTABILIDAD- '||nIDTRANSACCION);
    WHEN OTHERS THEn
         RAISE_APPLICATION_ERROR(-20225,'Comprobante Contable con problemas  de transacion MARCA_NO_ENVIO_CONTABILIDAD- '||nIDTRANSACCION);
  END;
  --  
  UPDATE COMPROBANTES_CONTABLES CC
     SET CC.STSCOMPROB   = 'AJU',
         CC.FECENVIOSC   = DFECHA,
         CC.NUMCOMPROBSC = 0
   WHERE CC.CODCIA     = nCodCia
     AND CC.NUMCOMPROB = nNUMCOMPROB;
  --
END MARCA_NO_ENVIO_CONTABILIDAD;  
--
--
PROCEDURE MASIVOS_SOLICITUD_RESERVA(nIdProcMasivo NUMBER) IS     
NCODCIA                COBERTURA_SINIESTRO_ASEG.CODCIA%TYPE;
NCODEMPRESA            COBERTURA_SINIESTRO_ASEG.CODEMPRESA%TYPE;
NIDSINIESTRO           COBERTURA_SINIESTRO_ASEG.IDSINIESTRO%TYPE;
NIDDETSIN              COBERTURA_SINIESTRO_ASEG.IDDETSIN%TYPE;
CCODCOBERT             COBERTURA_SINIESTRO_ASEG.CODCOBERT%TYPE;
NMONTO_RES_MON         COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
CCODCPTOTRANSAC        COBERTURA_SINIESTRO_ASEG.CODCPTOTRANSAC%TYPE;
NNUMMOD                COBERTURA_SINIESTRO_ASEG.NUMMOD%TYPE;
DFECRES                COBERTURA_SINIESTRO_ASEG.FECRES%TYPE;
--
CID_COL_INDI           VARCHAR2(1);
CID_SOL_EMI            VARCHAR2(6);
CDESCRIPCION           OBSERVACION_SINIESTRO.DESCRIPCION%TYPE;
--
CURSOR SIN_Q IS
   SELECT CodCia,        CodEmpresa,   IdTipoSeg, 
          PlanCob,       NumPolUnico,  NumDetUnico, 
          RegDatosProc,  TipoProceso,  IndColectiva
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo = nIdProcMasivo;
--
BEGIN
  --
  FOR X IN SIN_Q LOOP
    NCODCIA     := X.CodCia;
    NCODEMPRESA := X.CodEmpresa;
    --
    NIDSINIESTRO    := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,1,',')));
    NIDDETSIN       := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,2,',')));
    CCODCOBERT      :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,3,','));
    CCODCPTOTRANSAC :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,4,','));
    NMONTO_RES_MON  := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,5,',')));
    CID_COL_INDI    :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,','));
    CID_SOL_EMI     :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,7,','));
    NNUMMOD         :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,8,','));
    CDESCRIPCION    :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,9,','));
    DFECRES         :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,10,','));
    --
    -- ELIGE PROCESO
    --
    IF CID_SOL_EMI = 'SOL' THEN
       SOLICITUD_RESERVA(NCODCIA,          NCODEMPRESA,    NIDSINIESTRO,
                         NIDDETSIN,        CCODCOBERT,     CCODCPTOTRANSAC,
                         NMONTO_RES_MON,   CID_COL_INDI,   nIdProcMasivo);
    ELSIF CID_SOL_EMI = 'DEL' THEN
       SOLICITUD_RESERVA_BORRADO(NCODCIA,     NCODEMPRESA,   NIDSINIESTRO,
                                 NIDDETSIN,   CCODCOBERT,    CID_COL_INDI,   
                                 NNUMMOD,     nIdProcMasivo);
    ELSIF CID_SOL_EMI = 'EMI' THEN
       SOLICITUD_RESERVA_EMISION(NCODCIA,          NCODEMPRESA,    NIDSINIESTRO,
                                 NIDDETSIN,        CCODCOBERT,     NMONTO_RES_MON,   
                                 CID_COL_INDI,     NNUMMOD,        CDESCRIPCION,
                                 DFECRES,          nIdProcMasivo);                            
    END IF;
    --
  END LOOP;
  --
EXCEPTION
  WHEN OTHERS THEN
       ROLLBACK;
       OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'MASIVOS_SOLICITUD','20225','Error 1: '||SQLERRM);
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END MASIVOS_SOLICITUD_RESERVA;  
--
--
PROCEDURE SOLICITUD_RESERVA(NCODCIA        NUMBER,   NCODEMPRESA  NUMBER,     NIDSINIESTRO    NUMBER,
                            NIDDETSIN      NUMBER,   CCODCOBERT   VARCHAR2,   CCODCPTOTRANSAC VARCHAR2,
                            NMONTO_RES_MON NUMBER,   CID_COL_INDI VARCHAR2,   nIdProcMasivo   NUMBER) IS     
--
NMONTO_RES_LOC         COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_LOCAL%TYPE;
CCODTRANSAC            COBERTURA_SINIESTRO_ASEG.CODTRANSAC%TYPE;
CCOD_TPRESERVA         COBERTURA_SINIESTRO_ASEG.COD_TPRESERVA%TYPE;
WNIDDETSIN             COBERTURA_SINIESTRO_ASEG.IDDETSIN%TYPE;
WNNUMMOD               COBERTURA_SINIESTRO_ASEG.NUMMOD%TYPE;
--
NIDPOLIZA              POLIZAS.IdPoliza%TYPE;
NIDETPOL               SINIESTRO.IDetPol%TYPE;
CCOD_MONEDA            POLIZAS.Cod_Moneda%TYPE;
nTasaCambio            DETALLE_POLIZA.Tasa_Cambio%TYPE;
NCOD_ASEGURADO         ASEGURADO.COD_ASEGURADO%TYPE;
cMsjError              PROCESOS_MASIVOS_LOG.TxtError%TYPE := NULL;
cExisteCob             VARCHAR2(1);
nCodError              NUMBER(2) := Null;
cObservacion           VARCHAR2(100);
cUsuario varchar2(50);

--
--
BEGIN
    --
    -- VALIDA SINIESTRO
    --
    BEGIN
      SELECT S.IDPOLIZA,  S.IDETPOL,  S.COD_MONEDA,  S.COD_ASEGURADO 
        INTO NIDPOLIZA,   nIDetPol,   CCOD_MONEDA,   NCOD_ASEGURADO
        FROM SINIESTRO S
       WHERE S.IDSINIESTRO = NIDSINIESTRO
         AND S.CODCIA      = NCODCIA;
    EXCEPTION 
      WHEN NO_DATA_FOUND  THEN
           nCodError    := 41;
           cObservacion := 'Codigo Error 41: NO EXISTE EL SINIESTRO';
           RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL SINIESTRO - '||NIDSINIESTRO||' - '||SQLERRM);
      WHEN OTHERS THEN 
           nCodError    := 41;
           cObservacion := 'Codigo Error 41.1: NO EXISTE EL SINIESTRO OTHERS';
           RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL SINIESTRO  OTHERS- '||NIDSINIESTRO||' - '||SQLERRM);
    END;
    --
    nTasaCambio    := OC_GENERALES.TASA_DE_CAMBIO(CCOD_MONEDA, TRUNC(SYSDATE));
    NMONTO_RES_LOC := NMONTO_RES_MON * nTasaCambio;
    --
    -- PROCESA SINIESTRO SI ES INDIVIDUAL
    --
    IF NIDSINIESTRO > 0 AND CID_COL_INDI = 'I' THEN
       --
       -- VALIDA DETALLE_SINIESTRO
       --
       BEGIN
         SELECT DS.IDDETSIN
           INTO WNIDDETSIN
           FROM DETALLE_SINIESTRO DS
          WHERE DS.IDSINIESTRO = NIDSINIESTRO
            AND DS.IDDETSIN    = NIDDETSIN;
       EXCEPTION 
         WHEN NO_DATA_FOUND  THEN
              nCodError    := 51;
              cObservacion := 'Codigo Error 51: NO EXISTE EL DETALLE DE SINIESTRO';
              RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL DETALLE DE SINIESTRO  - '||NIDSINIESTRO||' - 1 '||SQLERRM);
         WHEN OTHERS THEN 
              nCodError    := 51;
              cObservacion := 'Codigo Error 51.1: NO EXISTE EL DETALLE DE SINIESTRO OTHERS';
              RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL DETALLE DE SINIESTRO OTHERS- '||NIDSINIESTRO||' - 1 '||SQLERRM);
       END;
       --
       CCODTRANSAC := 'OCURRE';
       --
       BEGIN
         SELECT NVL(MAX(NumMod),0) + 1  
           INTO WNNUMMOD
           FROM COBERTURA_SINIESTRO
          WHERE IdSiniestro = NIDSINIESTRO
            AND IDDETSIN    = NIDDETSIN
            AND CodCobert   = CCODCOBERT
            AND IdPoliza    = NIDPOLIZA;
       END;
       --
       BEGIN
         SELECT DECODE(TS.CODTIPOPLAN,'030','AP'
                                     ,'010','VIDA'
                                     ,'OTRO')
           INTO CCOD_TPRESERVA
           FROM DETALLE_SINIESTRO   DS,
                TIPOS_DE_SEGUROS    TS
          WHERE DS.IDSINIESTRO = NIDSINIESTRO
            AND DS.IDDETSIN    = NIDDETSIN
             --
            AND TS.IDTIPOSEG = DS.IDTIPOSEG;
       EXCEPTION
         WHEN NO_DATA_FOUND THEn
              nCodError := 99;
              cObservacion := 'Codigo Error 99: NO Existe DETALLE .';
              RAISE_APPLICATION_ERROR(-20225,'NO Existe DETALLE '||NIDDETSIN);
         WHEN TOO_MANY_ROWS THEn
              nCodError := 99;
              cObservacion := 'Codigo Error 99.1:Detalle duplicado.';
              RAISE_APPLICATION_ERROR(-20225,'NO Existe DETALLE '||NIDDETSIN);
         WHEN OTHERS THEn
              nCodError := 99;
              cObservacion := 'Codigo Error 99.2:Detalle por others';
              RAISE_APPLICATION_ERROR(-20225,'Detalle por others'||NIDDETSIN);
       END;
       -- 
       BEGIN
         SELECT 'S'
           INTO cExisteCob
           FROM COBERTURA_SINIESTRO
          WHERE IdSiniestro = NIDSINIESTRO
            AND IDDETSIN    = NIDDETSIN          
            AND CodCobert   = CCODCOBERT
            AND IdPoliza    = NIDPOLIZA;
       EXCEPTION
         WHEN NO_DATA_FOUND THEn
              nCodError := 89;
              cObservacion := 'Codigo Error 89:NO Existe Cobertura .';
              RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura de '||CCODCOBERT);
         WHEN TOO_MANY_ROWS THEn
              cExisteCob := 'S'; 
         WHEN OTHERS THEn
              nCodError := 89;
              cObservacion := 'Codigo Error 89:NO Existe Cobertura por others.';
              RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura de '||CCODCOBERT);
       END;
  BEGIN --PST 27-11-2023 TODO EL QUERY
    SELECT APEX_CUSTOM_AUTH.GET_USERNAME INTO cUsuario FROM DUAL;
	IF(cUsuario IS NULL)THEN
		cUsuario := USER;
	END IF;
  EXCEPTION WHEN OTHERS THEN
    cUsuario := USER;
  END;       --
       IF cExisteCob = 'S' THEN
             BEGIN
               INSERT INTO COBERTURA_SINIESTRO
                (IDDETSIN,               CODCOBERT,              IDSINIESTRO,          IDPOLIZA,
                 DOC_REF_PAGO,           MONTO_PAGADO_MONEDA,    MONTO_PAGADO_LOCAL,   MONTO_RESERVADO_MONEDA, 
                 MONTO_RESERVADO_LOCAL,  STSCOBERTURA,           NUMMOD,               CODTRANSAC,
                 --
                 CODCPTOTRANSAC,         IDTRANSACCION,          SALDO_RESERVA,        INDORIGEN,              
                 FECRES,                 SALDO_RESERVA_LOCAL,    IDTRANSACCIONANUL,    IDAUTORIZACION,
                 --
                 CODCIA,                 CODEMPRESA,             COD_MONEDA,           COD_ASEGURADO,
                 COD_TPRESERVA,          IDTPRESERVA,            CODUSUARIO,           FECREGISTRO)
               VALUES
                (NIDDETSIN,              CCODCOBERT,             NIDSINIESTRO,         NIDPOLIZA, 
                 'MASIVO',               0,                      0,                    NMONTO_RES_MON,           
                 NMONTO_RES_LOC,         'SOL',                  WNNUMMOD,              CCODTRANSAC,
                 --           
                 CCODCPTOTRANSAC,        NULL,                   0,                    'D',                     
                 TRUNC(SYSDATE),         0,                      NULL,                 NULL,
                 --
                 NCODCIA,                NCODEMPRESA,            CCOD_MONEDA,          NCOD_ASEGURADO,
                 CCOD_TPRESERVA,         1,                      cusuario,                 TRUNC(SYSDATE));
             EXCEPTION
               WHEN OTHERS THEN
                    nCodError := 99;
                    cObservacion := 'ERROR AL INSERTAR COBERTURA COBERTURA_SINIESTRO ';
                    RAISE_APPLICATION_ERROR(-20225,'ERROR AL INSERTAR COBERTURA COBERTURA_SINIESTRO'||SQLERRM);
             END;
       END IF;
       --
    END IF;
    --
    -- PROCESA SINIESTRO SI ES COLECTIVO
    --
    IF NIDSINIESTRO > 0 AND CID_COL_INDI = 'C' THEN
       --
       -- VALIDA DETALLE_SINIESTRO
       --
       BEGIN
         SELECT DS.IDDETSIN 
           INTO WNIDDETSIN
           FROM DETALLE_SINIESTRO_ASEG DS
          WHERE DS.IDSINIESTRO = NIDSINIESTRO
            AND DS.IDDETSIN    = NIDDETSIN;
       EXCEPTION 
         WHEN NO_DATA_FOUND  THEN
              nCodError    := 51;
              cObservacion := 'Codigo Error 51: NO EXISTE EL DETALLE DE SINIESTRO';
              RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL DETALLE DE SINIESTRO  - '||NIDSINIESTRO||' - 1 '||SQLERRM);
         WHEN OTHERS THEN 
              nCodError    := 51;
              cObservacion := 'Codigo Error 51.1: NO EXISTE EL DETALLE DE SINIESTRO OTHERS';
              RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL DETALLE DE SINIESTRO OTHERS- '||NIDSINIESTRO||' - 1 '||SQLERRM);
       END;
       --
       CCODTRANSAC := 'OCURRE';
       --
       SELECT NVL(MAX(NumMod),0) + 1  
         INTO WNNUMMOD
         FROM COBERTURA_SINIESTRO_ASEG
        WHERE IdSiniestro = NIDSINIESTRO
          AND IDDETSIN    = NIDDETSIN          
          AND CodCobert   = CCODCOBERT
          AND IdPoliza    = NIDPOLIZA;
       --
       BEGIN
         SELECT DECODE(TS.CODTIPOPLAN,'030','AP'
                                     ,'010','VIDA'
                                     ,'OTRO')
           INTO CCOD_TPRESERVA
           FROM DETALLE_SINIESTRO_ASEG   DS,
                TIPOS_DE_SEGUROS    TS
          WHERE DS.IDSINIESTRO = NIDSINIESTRO
            AND DS.IDDETSIN    = NIDDETSIN
             --
            AND TS.IDTIPOSEG = DS.IDTIPOSEG;
       EXCEPTION
         WHEN NO_DATA_FOUND THEn
              nCodError := 99;
              cObservacion := 'Codigo Error 99: NO Existe DETALLE .';
              RAISE_APPLICATION_ERROR(-20225,'NO Existe DETALLE '||NIDDETSIN);
         WHEN TOO_MANY_ROWS THEn
              nCodError := 99;
              cObservacion := 'Codigo Error 99.1:Detalle duplicado.';
              RAISE_APPLICATION_ERROR(-20225,'NO Existe DETALLE '||NIDDETSIN);
         WHEN OTHERS THEn
              nCodError := 99;
              cObservacion := 'Codigo Error 99.2:Detalle por others';
              RAISE_APPLICATION_ERROR(-20225,'Detalle por others'||NIDDETSIN);
       END;
       -- 
       BEGIN
         SELECT 'S'
           INTO cExisteCob
           FROM COBERTURA_SINIESTRO_ASEG
          WHERE IdSiniestro = NIDSINIESTRO
            AND IDDETSIN    = NIDDETSIN          
            AND CodCobert   = CCODCOBERT
            AND IdPoliza    = NIDPOLIZA;
       EXCEPTION
         WHEN NO_DATA_FOUND THEn
              nCodError := 89;
              cObservacion := 'Codigo Error 89:NO Existe Cobertura .';
              RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura de '||CCODCOBERT);
         WHEN TOO_MANY_ROWS THEn
              cExisteCob := 'S'; 
         WHEN OTHERS THEn
              nCodError := 89;
              cObservacion := 'Codigo Error 89:NO Existe Cobertura por others.';
              RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura de '||CCODCOBERT);
       END;
       --
		BEGIN --PST 27-11-2023 TODO EL QUERY
			SELECT APEX_CUSTOM_AUTH.GET_USERNAME INTO cUsuario FROM DUAL;
			IF(cUsuario IS NULL)THEN
				cUsuario := USER;
			END IF;
		EXCEPTION
			WHEN OTHERS THEN
				cUsuario := USER;
		END;
         IF cExisteCob = 'S' THEN
             BEGIN
               INSERT INTO COBERTURA_SINIESTRO_ASEG
                (IDDETSIN,               CODCOBERT,              IDSINIESTRO,          IDPOLIZA,
                 DOC_REF_PAGO,           MONTO_PAGADO_MONEDA,    MONTO_PAGADO_LOCAL,   MONTO_RESERVADO_MONEDA, 
                 MONTO_RESERVADO_LOCAL,  STSCOBERTURA,           NUMMOD,               CODTRANSAC,
                 --
                 CODCPTOTRANSAC,         IDTRANSACCION,          SALDO_RESERVA,        INDORIGEN,              
                 FECRES,                 SALDO_RESERVA_LOCAL,    IDTRANSACCIONANUL,    IDAUTORIZACION,
                 --
                 CODCIA,                 CODEMPRESA,             COD_MONEDA,           COD_ASEGURADO,
                 COD_TPRESERVA,          IDTPRESERVA,            CODUSUARIO,           FECREGISTRO)
               VALUES
                (NIDDETSIN,              CCODCOBERT,             NIDSINIESTRO,         NIDPOLIZA, 
                 'MASIVO',               0,                      0,                    NMONTO_RES_MON,           
                 NMONTO_RES_LOC,         'SOL',                  WNNUMMOD,              CCODTRANSAC,
                 --           
                 CCODCPTOTRANSAC,        NULL,                   0,                    'D',                     
                 TRUNC(SYSDATE),         0,                      NULL,                 NULL,
                 --
                 NCODCIA,                NCODEMPRESA,            CCOD_MONEDA,          NCOD_ASEGURADO,
                 CCOD_TPRESERVA,         1,                      cusuario,                 TRUNC(SYSDATE));
             EXCEPTION
               WHEN OTHERS THEN
                    nCodError := 99;
                    cObservacion := 'ERROR AL INSERTAR COBERTURA COBERTURA_SINIESTRO ';
                    RAISE_APPLICATION_ERROR(-20225,'ERROR AL INSERTAR COBERTURA COBERTURA_SINIESTRO'||SQLERRM);
             END;
       END IF;
       --
    END IF;
    --
    IF cMsjError IS NULL THEN
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'PROCE');
    ELSE
       OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Reserva en solicitud: '||cMsjError);
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
    END IF;
    --
  --
EXCEPTION
  WHEN OTHERS THEN
       ROLLBACK;
       OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Error 1: '||SQLERRM);
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END SOLICITUD_RESERVA;  
--
--
PROCEDURE SOLICITUD_RESERVA_BORRADO(NCODCIA   NUMBER,   NCODEMPRESA   NUMBER,     NIDSINIESTRO   NUMBER,
                                    NIDDETSIN NUMBER,   CCODCOBERT    VARCHAR2,   CID_COL_INDI   VARCHAR2,   
                                    NNUMMOD   NUMBER,   nIdProcMasivo NUMBER) IS     
--
cMsjError              PROCESOS_MASIVOS_LOG.TxtError%TYPE := NULL;
--
BEGIN
  --
  -- PROCESA SINIESTRO SI ES INDIVIDUAL
  --
  IF NIDSINIESTRO > 0 AND CID_COL_INDI = 'I' THEN
     --
     -- VALIDA DETALLE_SINIESTRO
     --
     DELETE COBERTURA_SINIESTRO CS
      WHERE CS.IDSINIESTRO  = NIDSINIESTRO
        AND CS.IDDETSIN     = NIDDETSIN
        AND CS.CODCOBERT    = CCODCOBERT
        AND CS.NUMMOD       = NNUMMOD
        AND CS.STSCOBERTURA = 'SOL'
        AND CS.CODCIA       = NCODCIA
        AND CS.CODEMPRESA   = NCODEMPRESA;
     --
  END IF;
  --
  -- PROCESA SINIESTRO SI ES COLECTIVO
  --
  IF NIDSINIESTRO > 0 AND CID_COL_INDI = 'C' THEN
     --
     -- VALIDA DETALLE_SINIESTRO
     --
     DELETE COBERTURA_SINIESTRO_ASEG CS
      WHERE CS.IDSINIESTRO  = NIDSINIESTRO
        AND CS.IDDETSIN     = NIDDETSIN
        AND CS.CODCOBERT    = CCODCOBERT
        AND CS.NUMMOD       = NNUMMOD
        AND CS.STSCOBERTURA = 'SOL'
        AND CS.CODCIA       = NCODCIA
        AND CS.CODEMPRESA   = NCODEMPRESA;
     --
  END IF;
  --
  IF cMsjError IS NULL THEN
     OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'PROCE');
  ELSE
     OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Reserva en solicitud: '||cMsjError);
     OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
  END IF;
  --
EXCEPTION
  WHEN OTHERS THEN
       ROLLBACK;
       OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Error 1: '||SQLERRM);
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END SOLICITUD_RESERVA_BORRADO;  
--
PROCEDURE SOLICITUD_RESERVA_EMISION(NCODCIA       NUMBER,     NCODEMPRESA NUMBER,     NIDSINIESTRO   NUMBER,
                                    NIDDETSIN     NUMBER,     CCODCOBERT  VARCHAR2,   NMONTO_RES_MON NUMBER,   
                                    CID_COL_INDI  VARCHAR2,   NNUMMOD     NUMBER,     CDESCRIPCION   VARCHAR2,
                                    DFECRES        DATE,      nIdProcMasivo NUMBER) IS     
--
NIDPOLIZA              POLIZAS.IdPoliza%TYPE;
CCOD_MONEDA            POLIZAS.Cod_Moneda%TYPE;
NSUMAASEG_MONEDA       POLIZAS.SUMAASEG_MONEDA%TYPE;
NSUMASEGURADAREAL      POLIZAS.SUMAASEG_MONEDA%TYPE;
WNIDDETSIN             COBERTURA_SINIESTRO_ASEG.IDDETSIN%TYPE;
DFECHA                 COBERTURA_SINIESTRO_ASEG.FECRES%TYPE;
CCODTRANSAC            COBERTURA_SINIESTRO_ASEG.CODTRANSAC%TYPE;
NIDETPOL               SINIESTRO.IDetPol%TYPE;
NCOD_ASEGURADO         ASEGURADO.COD_ASEGURADO%TYPE;
NIDTRANSACCION         TRANSACCION.IDTRANSACCION%TYPE;
cMsjError              PROCESOS_MASIVOS_LOG.TxtError%TYPE := NULL;
cExisteCob             VARCHAR2(1);
nCodError              NUMBER(2) := Null;
cObservacion           VARCHAR2(100);
--
--
BEGIN
    --
    -- VALIDA SINIESTRO
    --
    BEGIN
      SELECT S.IDPOLIZA,  S.IDETPOL,  S.COD_MONEDA,  S.COD_ASEGURADO 
        INTO NIDPOLIZA,   NIDETPOL,   CCOD_MONEDA,   NCOD_ASEGURADO
        FROM SINIESTRO S
       WHERE S.IDSINIESTRO = NIDSINIESTRO
         AND S.CODCIA      = NCODCIA;
    EXCEPTION 
      WHEN NO_DATA_FOUND  THEN
           nCodError    := 01;
           cObservacion := 'Codigo Error 02: NO EXISTE EL SINIESTRO';
           RAISE_APPLICATION_ERROR(-20225,'Codigo Error 01: NO EXISTE EL SINIESTRO - '||NIDSINIESTRO||' - '||SQLERRM);
      WHEN OTHERS THEN 
           nCodError    := 01;
           cObservacion := 'Codigo Error 02: NO EXISTE EL SINIESTRO OTHERS';
           RAISE_APPLICATION_ERROR(-20225,'Codigo Error 01: NO EXISTE EL SINIESTRO  OTHERS- '||NIDSINIESTRO||' - '||SQLERRM);
    END;
    --
    CCODTRANSAC := 'OCURRE';
    --
    -- PROCESA SINIESTRO SI ES INDIVIDUAL
    --
    IF NIDSINIESTRO > 0 AND CID_COL_INDI = 'I' THEN
       --
       -- VALIDA DETALLE_SINIESTRO
       --
       BEGIN
         SELECT DS.IDDETSIN
           INTO WNIDDETSIN
           FROM DETALLE_SINIESTRO DS
          WHERE DS.IDSINIESTRO = NIDSINIESTRO
            AND DS.IDDETSIN    = NIDDETSIN;
       EXCEPTION 
         WHEN NO_DATA_FOUND  THEN
              nCodError    := 02;
              cObservacion := 'Codigo Error 02: NO EXISTE EL DETALLE DE SINIESTRO';
              RAISE_APPLICATION_ERROR(-20225,'Codigo Error 02: NO EXISTE EL DETALLE DE SINIESTRO  - '||NIDSINIESTRO||' - 1 '||SQLERRM);
         WHEN OTHERS THEN 
              nCodError    := 02;
              cObservacion := 'Codigo Error 02: NO EXISTE EL DETALLE DE SINIESTRO OTHERS';
              RAISE_APPLICATION_ERROR(-20225,'Codigo Error 02: NO EXISTE EL DETALLE DE SINIESTRO OTHERS- '||NIDSINIESTRO||' - 1 '||SQLERRM);
       END;       
       --
       -- VALIDA COBERTURA
       --
       BEGIN
         SELECT 'S',
                CS.FECRES    
           INTO cExisteCob,
                dFECHA
           FROM COBERTURA_SINIESTRO CS
          WHERE CS.IDSINIESTRO  = NIDSINIESTRO
            AND CS.CODCOBERT    = CCODCOBERT
            AND CS.IDPOLIZA     = NIDPOLIZA
            AND CS.NUMMOD       = NNUMMOD
            AND CS.IDDETSIN     = NIDDETSIN
            AND CS.STSCOBERTURA = 'SOL';
       EXCEPTION
         WHEN NO_DATA_FOUND THEn
              nCodError := 03;
              cObservacion := 'Codigo Error 03:NO Existe Cobertura .';
              RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura de '||CCODCOBERT||' - REGISTRO No. '||NNUMMOD);
         WHEN TOO_MANY_ROWS THEn
              cExisteCob := 'S'; 
         WHEN OTHERS THEn
              nCodError := 03;
              cObservacion := 'Codigo Error 03:NO Existe Cobertura por others.';
              RAISE_APPLICATION_ERROR(-20225,'OTHERS NO Existe Cobertura de '||CCODCOBERT||' - REGISTRO No. '||NNUMMOD);
       END;
       --
       -- VALIDA SUMA ASEGURADA
       --
       --       
       IF OC_COBERTURA_SINIESTRO.VALIDA_SUMA_ASEGURADA(NCODCIA, NIDPOLIZA, NIDETPOL, CCODCOBERT, CCODTRANSAC, NMONTO_RES_MON) = 'S' THEN
          nCodError    := 04;
          cObservacion := 'Codigo Error 04: Monto de la Reserva es mayor a la Suma Asegurada de la Cobertura';  
          RAISE_APPLICATION_ERROR(-20225,'Error Monto de la Reserva es mayor a la Suma Asegurada de la Cobertura SA:  '||NSUMASEGURADAREAL||' - '||SQLERRM);
       END IF;
       IF cExisteCob = 'S' THEN
          --
          IF DFECRES IS NULL THEN
             DFECHA := TRUNC(SYSDATE);
          ELSE 
             DFECHA := DFECRES;
          END IF;
          --
          OC_COBERTURA_SINIESTRO.EMITE_RESERVA(nCodCia, nCodEmpresa, NIDSINIESTRO, NIDPOLIZA, NIDDETSIN, CCODCOBERT, NNUMMOD, NULL);            
          -- 
          IF DFECRES IS NOT NULL THEN
             --
             UPDATE COBERTURA_SINIESTRO_ASEG CS
                SET CS.FECRES = DFECHA
              WHERE CS.IDSINIESTRO = NIDSINIESTRO
                AND CS.CODCOBERT   = CCODCOBERT
                AND CS.IDPOLIZA    = NIDPOLIZA
                AND CS.NUMMOD      = NNUMMOD
                AND CS.IDDETSIN    = NIDDETSIN;
             --
             NIDTRANSACCION := OBTIENE_TRANSA_RVA_IND(NIDPOLIZA, NIDSINIESTRO, NIDDETSIN, CCODCOBERT, NNUMMOD,DFECHA); 
             --
             CAMBIA_FECHA_CONTA(NIDTRANSACCION, nCodCia, DFECHA, nCodEmpresa); 
             CAMBIA_FECHA_OBSERVACION(NIDSINIESTRO, NIDPOLIZA, DFECHA);
             --
          END IF;          
          --
       END IF;
       --
    END IF;
    --
    -- PROCESA SINIESTRO SI ES COLECTIVO
    --
    IF NIDSINIESTRO > 0 AND CID_COL_INDI = 'C' THEN
       --
       -- VALIDA DETALLE_SINIESTRO
       --
       BEGIN
         SELECT DS.IDDETSIN
           INTO WNIDDETSIN
           FROM DETALLE_SINIESTRO_ASEG DS
          WHERE DS.IDSINIESTRO = NIDSINIESTRO
            AND DS.IDDETSIN    = NIDDETSIN;
       EXCEPTION 
         WHEN NO_DATA_FOUND  THEN
              nCodError    := 02;
              cObservacion := 'Codigo Error 02: NO EXISTE EL DETALLE DE SINIESTRO';
              RAISE_APPLICATION_ERROR(-20225,'Codigo Error 02: NO EXISTE EL DETALLE DE SINIESTRO  - '||NIDSINIESTRO||' - 1 '||SQLERRM);
         WHEN OTHERS THEN 
              nCodError    := 02;
              cObservacion := 'Codigo Error 02: NO EXISTE EL DETALLE DE SINIESTRO OTHERS';
              RAISE_APPLICATION_ERROR(-20225,'Codigo Error 02: NO EXISTE EL DETALLE DE SINIESTRO OTHERS- '||NIDSINIESTRO||' - 1 '||SQLERRM);
       END;       
       --
       -- VALIDA COBERTURA
       --
       BEGIN
         SELECT 'S',
                CS.FECRES    
           INTO cExisteCob,
                dFECHA
           FROM COBERTURA_SINIESTRO_ASEG CS
          WHERE CS.IDSINIESTRO  = NIDSINIESTRO
            AND CS.CODCOBERT    = CCODCOBERT
            AND CS.IDPOLIZA     = NIDPOLIZA
            AND CS.NUMMOD       = NNUMMOD
            AND CS.IDDETSIN     = NIDDETSIN
            AND CS.STSCOBERTURA = 'SOL';
       EXCEPTION
         WHEN NO_DATA_FOUND THEn
              nCodError := 03;
              cObservacion := 'Codigo Error 03:NO Existe Cobertura .';
              RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura de '||CCODCOBERT||' - REGISTRO No. '||NNUMMOD);
         WHEN TOO_MANY_ROWS THEn
              cExisteCob := 'S'; 
         WHEN OTHERS THEn
              nCodError := 03;
              cObservacion := 'Codigo Error 03:NO Existe Cobertura por others.';
              RAISE_APPLICATION_ERROR(-20225,'OTHERS NO Existe Cobertura de '||CCODCOBERT||' - REGISTRO No. '||NNUMMOD);
       END;
       --
       --VALIDA SUMAS ASEG DE POLIZA
       --
       BEGIN
         SELECT UNIQUE(A.SUMAASEG_MONEDA)
           INTO NSUMAASEG_MONEDA
           FROM COBERT_ACT_ASEG A
          WHERE A.IDPOLIZA      = NIDPOLIZA
            AND A.CodCobert     = CCODCOBERT
            AND A.COD_ASEGURADO = NCOD_ASEGURADO
            AND A.IDETPOL       = NIDETPOL;
       EXCEPTION
         WHEN DUP_VAL_ON_INDEX   THEN
              NSUMAASEG_MONEDA := 0;
         WHEN NO_DATA_FOUND THEN
              NSUMAASEG_MONEDA := 0;
         WHEN OTHERS THEN 
              NSUMAASEG_MONEDA := 0;
       END;
       --
       -- VALIDA SUMA ASEGURADA
       --
       IF NSUMAASEG_MONEDA > 0 THEN
          NSUMASEGURADAREAL := OC_COBERTURA_SINIESTRO_ASEG.SUM_ASEG_REMANENTE(NCODCIA, NIDPOLIZA, NIDETPOL, NCOD_ASEGURADO, CCODCOBERT);
       END IF; 
       --
       IF NSUMASEGURADAREAL < NMONTO_RES_MON THEN 
          nCodError    := 04;
          cObservacion := 'Codigo Error 04: Monto de la Reserva es mayor a la Suma Asegurada de la Cobertura';  
          RAISE_APPLICATION_ERROR(-20225,'Error Monto de la Reserva es mayor a la Suma Asegurada de la Cobertura SA:  '||NSUMASEGURADAREAL||' - '||SQLERRM);
       END IF;
       --
       IF cExisteCob = 'S' THEN
          --
          IF DFECRES IS NULL THEN
             DFECHA := TRUNC(SYSDATE);
          ELSE 
             DFECHA := DFECRES;
          END IF;
          --
          OC_COBERTURA_SINIESTRO_ASEG.EMITE_RESERVA(nCodCia, nCodEmpresa, nIdSiniestro, nIdPoliza, NIDDETSIN, NCOD_ASEGURADO, cCodCobert, nNumMod, NULL);
          -- 
          IF DFECRES IS NOT NULL THEN
             --
             UPDATE COBERTURA_SINIESTRO_ASEG CS
                SET CS.FECRES = DFECHA
              WHERE CS.IDSINIESTRO = NIDSINIESTRO
                AND CS.CODCOBERT   = CCODCOBERT
                AND CS.IDPOLIZA    = NIDPOLIZA
                AND CS.NUMMOD      = NNUMMOD
                AND CS.IDDETSIN    = NIDDETSIN;
             --
             NIDTRANSACCION := OBTIENE_TRANSA_RVA_COL(NIDPOLIZA, NIDSINIESTRO, NIDDETSIN, CCODCOBERT, NNUMMOD, NCOD_ASEGURADO ,DFECHA); 
             --
             CAMBIA_FECHA_CONTA(NIDTRANSACCION, nCodCia, DFECHA, nCodEmpresa); 
             CAMBIA_FECHA_OBSERVACION(NIDSINIESTRO, NIDPOLIZA, DFECHA);
             --
          END IF;          
          --
       END IF;
       --
    END IF;
    --
    IF cMsjError IS NULL THEN
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'PROCE');
    ELSE
       OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Reserva en solicitud: '||cMsjError);
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
    END IF;
    --
  --
EXCEPTION
  WHEN OTHERS THEN
       ROLLBACK;
       OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Error 1: '||SQLERRM);
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END SOLICITUD_RESERVA_EMISION;  
--
--
PROCEDURE MASIVOS_SOLICITUD_PAGOS(nIdProcMasivo NUMBER) IS     
NCODCIA                APROBACION_ASEG.CODCIA%TYPE;
NCODEMPRESA            APROBACION_ASEG.CODEMPRESA%TYPE;
NIDDETSIN              APROBACION_ASEG.IDDETSIN%TYPE;
NIDSINIESTRO           APROBACION_ASEG.IDSINIESTRO%TYPE;
NNUM_APROBACION        APROBACION_ASEG.NUM_APROBACION%TYPE;
CCODCPTOTRANSAC        DETALLE_APROBACION_ASEG.CODCPTOTRANSAC%TYPE;
DFECPAGO               APROBACION_ASEG.FECPAGO%TYPE;
--
CID_COL_INDI           VARCHAR2(1);
CID_SOL_EMI            VARCHAR2(6);
CDESCRIPCION           OBSERVACION_SINIESTRO.DESCRIPCION%TYPE;
--
CURSOR SIN_Q IS
   SELECT CodCia,        CodEmpresa,   IdTipoSeg, 
          PlanCob,       NumPolUnico,  NumDetUnico, 
          RegDatosProc,  TipoProceso,  IndColectiva
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo = nIdProcMasivo;
--
BEGIN
  --
  FOR X IN SIN_Q LOOP
    NCODCIA     := X.CodCia;
    NCODEMPRESA := X.CodEmpresa;
    --
    NIDSINIESTRO    := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,1,',')));
    NIDDETSIN       := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,2,',')));
    NNUM_APROBACION := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,3,',')));
    CID_COL_INDI    :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,4,','));
    CID_SOL_EMI     :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,5,','));
    CCODCPTOTRANSAC :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,','));
    CDESCRIPCION    :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,7,','));
    DFECPAGO        :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,8,','));
    --
    -- ELIGE PROCESO
    --
    IF CID_SOL_EMI = 'SOL' THEN
       SOLICITUD_PAGOS(NCODCIA,     NCODEMPRESA,       NIDSINIESTRO,
                       NIDDETSIN,   NNUM_APROBACION,   CID_COL_INDI,
                       nIdProcMasivo);
    ELSIF CID_SOL_EMI = 'DEL' THEN
       SOLICITUD_PAGOS_BORRADO(NCODCIA,     NCODEMPRESA,       NIDSINIESTRO,
                               NIDDETSIN,   NNUM_APROBACION,   CID_COL_INDI,
                               nIdProcMasivo);
    ELSIF CID_SOL_EMI = 'EMI' THEN
       SOLICITUD_PAGOS_EMISION(NCODCIA,        NCODEMPRESA,       NIDSINIESTRO,
                               NIDDETSIN,      NNUM_APROBACION,   CID_COL_INDI,          
                               CDESCRIPCION,   DFECPAGO,          nIdProcMasivo);                            
    END IF;
    --
  END LOOP;
  --
EXCEPTION
  WHEN OTHERS THEN
       ROLLBACK;
       OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'MASIVOS_SOLICITUD','20225','Error 1: '||SQLERRM);
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END MASIVOS_SOLICITUD_PAGOS;  
--
--
PROCEDURE SOLICITUD_PAGOS(NCODCIA       NUMBER,   NCODEMPRESA     NUMBER,   NIDSINIESTRO NUMBER,
                          NIDDETSIN     NUMBER,   NNUM_APROBACION NUMBER,   CID_COL_INDI VARCHAR2,   
                          nIdProcMasivo NUMBER) IS     
--
NNUM_APROBACION_NVO    APROBACION_ASEG.NUM_APROBACION%TYPE;
--
WNIDSINIESTRO          SINIESTRO.IDSINIESTRO%TYPE;
cMsjError              PROCESOS_MASIVOS_LOG.TxtError%TYPE := NULL;
cExisteAPRO            VARCHAR2(1);
nCodError              NUMBER(2) := Null;
cObservacion           VARCHAR2(100);
WNIDDETSIN             COBERTURA_SINIESTRO_ASEG.IDDETSIN%TYPE;
cUsuario varchar2(50);
--
CURSOR APROBA IS
SELECT *
  FROM APROBACIONES A
 WHERE A.IDSINIESTRO    = NIDSINIESTRO
   AND A.NUM_APROBACION = NNUM_APROBACION
   AND A.IDDETSIN       = NIDDETSIN
   AND A.CODCIA         = NCODCIA;
--
CURSOR DET_APROBA IS
SELECT *
  FROM DETALLE_APROBACION A
 WHERE A.IDSINIESTRO    = NIDSINIESTRO
   AND A.NUM_APROBACION = NNUM_APROBACION;
--
CURSOR APROBA_A IS
SELECT *
  FROM APROBACION_ASEG A
 WHERE A.IDSINIESTRO    = NIDSINIESTRO
   AND A.NUM_APROBACION = NNUM_APROBACION
   AND A.IDDETSIN       = NIDDETSIN
   AND A.CODCIA         = NCODCIA;
--
CURSOR DET_APROBA_A IS
SELECT *
  FROM DETALLE_APROBACION_ASEG A
 WHERE A.IDSINIESTRO    = NIDSINIESTRO
   AND A.NUM_APROBACION = NNUM_APROBACION;
--
BEGIN
  --
  -- VALIDA SINIESTRO
  --
  BEGIN
    SELECT S.IDSINIESTRO
      INTO WNIDSINIESTRO
      FROM SINIESTRO S
     WHERE S.IDSINIESTRO = NIDSINIESTRO
       AND S.CODCIA      = NCODCIA;
  EXCEPTION 
    WHEN NO_DATA_FOUND  THEN
         nCodError    := 41;
         cObservacion := 'Codigo Error 41: NO EXISTE EL SINIESTRO';
         RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL SINIESTRO - '||NIDSINIESTRO||' - '||SQLERRM);
    WHEN OTHERS THEN 
         nCodError    := 41;
         cObservacion := 'Codigo Error 41.1: NO EXISTE EL SINIESTRO OTHERS';
         RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL SINIESTRO  OTHERS- '||NIDSINIESTRO||' - '||SQLERRM);
  END;
  --
  -- PROCESA SINIESTRO SI ES INDIVIDUAL
  --
  IF NIDSINIESTRO > 0 AND CID_COL_INDI = 'I' THEN
     --
     BEGIN
       SELECT DS.IDDETSIN
         INTO WNIDDETSIN
         FROM DETALLE_SINIESTRO DS
        WHERE DS.IDSINIESTRO = NIDSINIESTRO
          AND DS.IDDETSIN    = NIDDETSIN;
     EXCEPTION 
       WHEN NO_DATA_FOUND  THEN
            nCodError    := 51;
            cObservacion := 'Codigo Error 51: NO EXISTE EL DETALLE DE SINIESTRO';
            RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL DETALLE DE SINIESTRO  - '||NIDSINIESTRO||' - 1 '||SQLERRM);
       WHEN OTHERS THEN 
            nCodError    := 51;
            cObservacion := 'Codigo Error 51.1: NO EXISTE EL DETALLE DE SINIESTRO OTHERS';
            RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL DETALLE DE SINIESTRO OTHERS- '||NIDSINIESTRO||' - 1 '||SQLERRM);
     END;
     --
     BEGIN
       SELECT NVL(MAX(A.NUM_APROBACION),0) + 1  
         INTO NNUM_APROBACION_NVO
         FROM APROBACIONES A
        WHERE A.IDSINIESTRO = NIDSINIESTRO
          AND A.CODCIA      = NCODCIA;
     END;
     --
     BEGIN
       SELECT 'S'
         INTO cExisteAPRO
         FROM APROBACIONES A
        WHERE A.IDSINIESTRO    = NIDSINIESTRO
          AND A.NUM_APROBACION = NNUM_APROBACION
          AND A.CODCIA         = NCODCIA;
     EXCEPTION
       WHEN NO_DATA_FOUND THEn
            nCodError := 89;
            cObservacion := 'Codigo Error 89:NO Existe Aprobacion .';
            RAISE_APPLICATION_ERROR(-20225,'NO Existe Aprobacion de '||NNUM_APROBACION);
       WHEN TOO_MANY_ROWS THEN
            cExisteAPRO := 'S'; 
       WHEN OTHERS THEn
            nCodError := 89;
            cObservacion := 'Codigo Error 89:NO Existe Aprobacion por others.';
            RAISE_APPLICATION_ERROR(-20225,'NO Existe Aprobacion de '||NNUM_APROBACION);
     END;
	BEGIN --PST 27-11-2023 TODO EL QUERY
		SELECT APEX_CUSTOM_AUTH.GET_USERNAME INTO cUsuario FROM DUAL;
		IF(cUsuario IS NULL)THEN
			cUsuario := USER;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			cUsuario := USER;
	END;
     --
     IF cExisteAPRO = 'S' THEN
        FOR X IN APROBA LOOP
         INSERT INTO APROBACIONES  
           (NUM_APROBACION,        IDSINIESTRO,      IDPOLIZA,             IDDETSIN,
            TIPO_APROBACION,       MONTO_LOCAL,      MONTO_MONEDA,         STSAPROBACION,
            TIPO_DE_APROBACION,    IDTRANSACCION,    INDDISPERSION,        CTALIQUIDADORA,
            IDEFACTEXT,            BENEF,            IDTRANSACCIONANUL,    FECHFONDOSINI,
            CODUSUARIO,            TERMINAL,         INDFONDOSINI,         FECPAGO,
            NUMPAGREF,             IDAUTORIZACION,   CODCIA,               CODEMPRESA,
            COD_MONEDA,            CODCOBERT,        COD_ASEGURADO,        CODUSUARIO_ALTA,
            FECREGISTRO)
         VALUES
           (NNUM_APROBACION_NVO,    X.IDSINIESTRO,    X.IDPOLIZA,           X.IDDETSIN,
            X.TIPO_APROBACION,      X.MONTO_LOCAL,    X.MONTO_MONEDA,       'SOL', 
            X.TIPO_DE_APROBACION,   '',               X.INDDISPERSION,       X.CTALIQUIDADORA,
            X.IDEFACTEXT,           X.BENEF,          '',                   '',
            cusuario,                   X.TERMINAL,       '',                   TRUNC(SYSDATE),
            X.NUMPAGREF,            '',               X. CODCIA,            X.CODEMPRESA,
            X.COD_MONEDA,           X.CODCOBERT,      X.COD_ASEGURADO,      'MASIVO',
            TRUNC(SYSDATE));
        END LOOP;
        --
        --
        --
       FOR D IN DET_APROBA LOOP        
           INSERT INTO DETALLE_APROBACION
             (NUM_APROBACION,        IDDETAPROB,              COD_PAGO,
              MONTO_LOCAL,           MONTO_MONEDA,            IDSINIESTRO,
              CODTRANSAC,            CODCPTOTRANSAC,          CODCIA,
              CODEMPRESA,            COD_MONEDA)
           VALUES
             (NNUM_APROBACION,       D.IDDETAPROB,            D.COD_PAGO,
              D.MONTO_LOCAL,         D.MONTO_MONEDA,          D.IDSINIESTRO,
              D.CODTRANSAC,          D.CODCPTOTRANSAC,        D.CODCIA,
              D.CODEMPRESA,          D.COD_MONEDA);
        END LOOP;
        --
     END IF;
     --
  END IF;
  --
  -- PROCESA SINIESTRO SI ES COLECTIVO
  --
  IF NIDSINIESTRO > 0 AND CID_COL_INDI = 'C' THEN
     --
     BEGIN
       SELECT DS.IDDETSIN
         INTO WNIDDETSIN
         FROM DETALLE_SINIESTRO_ASEG DS
        WHERE DS.IDSINIESTRO = NIDSINIESTRO
          AND DS.IDDETSIN    = NIDDETSIN;
     EXCEPTION 
       WHEN NO_DATA_FOUND  THEN
            nCodError    := 51;
            cObservacion := 'Codigo Error 51: NO EXISTE EL DETALLE DE SINIESTRO';
            RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL DETALLE DE SINIESTRO  - '||NIDSINIESTRO||' - 1 '||SQLERRM);
       WHEN OTHERS THEN 
            nCodError    := 51;
            cObservacion := 'Codigo Error 51.1: NO EXISTE EL DETALLE DE SINIESTRO OTHERS';
            RAISE_APPLICATION_ERROR(-20225,'Codigo Error 41: NO EXISTE EL DETALLE DE SINIESTRO OTHERS- '||NIDSINIESTRO||' - 1 '||SQLERRM);
     END;
     --
     BEGIN
       SELECT NVL(MAX(A.NUM_APROBACION),0) + 1  
         INTO NNUM_APROBACION_NVO
         FROM APROBACION_ASEG A
        WHERE A.IDSINIESTRO = NIDSINIESTRO
          AND A.CODCIA      = NCODCIA;
     END;
     --
     BEGIN
       SELECT 'S'
         INTO cExisteAPRO
         FROM APROBACION_ASEG A
        WHERE A.IDSINIESTRO    = NIDSINIESTRO
          AND A.NUM_APROBACION = NNUM_APROBACION
          AND A.CODCIA         = NCODCIA;
     EXCEPTION
       WHEN NO_DATA_FOUND THEn
            nCodError := 89;
            cObservacion := 'Codigo Error 89:NO Existe Aprobacion .';
            RAISE_APPLICATION_ERROR(-20225,'NO Existe Aprobacion de '||NNUM_APROBACION);
       WHEN TOO_MANY_ROWS THEN
            cExisteAPRO := 'S'; 
       WHEN OTHERS THEn
            nCodError := 89;
            cObservacion := 'Codigo Error 89:NO Existe Aprobacion por others.';
            RAISE_APPLICATION_ERROR(-20225,'NO Existe Aprobacion de '||NNUM_APROBACION);
     END;
	BEGIN --PST 27-11-2023 TODO EL QUERY
		SELECT APEX_CUSTOM_AUTH.GET_USERNAME INTO cUsuario FROM DUAL;
		IF(cUsuario IS NULL)THEN
			cUsuario := USER;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			cUsuario := USER;
	END;
     --
     IF cExisteAPRO = 'S' THEN
        FOR X IN APROBA_A LOOP
         INSERT INTO APROBACIONES  
           (NUM_APROBACION,        IDSINIESTRO,      IDPOLIZA,             IDDETSIN,
            TIPO_APROBACION,       MONTO_LOCAL,      MONTO_MONEDA,         STSAPROBACION,
            TIPO_DE_APROBACION,    IDTRANSACCION,    INDDISPERSION,        CTALIQUIDADORA,
            IDEFACTEXT,            BENEF,            IDTRANSACCIONANUL,    FECHFONDOSINI,
            CODUSUARIO,            TERMINAL,         INDFONDOSINI,         FECPAGO,
            NUMPAGREF,             IDAUTORIZACION,   CODCIA,               CODEMPRESA,
            COD_MONEDA,            CODCOBERT,        COD_ASEGURADO,        CODUSUARIO_ALTA,
            FECREGISTRO)
         VALUES
           (NNUM_APROBACION_NVO,    X.IDSINIESTRO,    X.IDPOLIZA,           X.IDDETSIN,
            X.TIPO_APROBACION,      X.MONTO_LOCAL,    X.MONTO_MONEDA,       'SOL', 
            X.TIPO_DE_APROBACION,   '',               X.INDDISPERSION,       X.CTALIQUIDADORA,
            X.IDEFACTEXT,           X.BENEF,          '',                   '',
            cusuario,                   X.TERMINAL,       '',                   TRUNC(SYSDATE),
            X.NUMPAGREF,            '',               X. CODCIA,            X.CODEMPRESA,
            X.COD_MONEDA,           X.CODCOBERT,      X.COD_ASEGURADO,      'MASIVO',
            TRUNC(SYSDATE));
        END LOOP;
        --
        --
        --
       FOR D IN DET_APROBA_A LOOP        
           INSERT INTO DETALLE_APROBACION_ASEG
             (NUM_APROBACION,        IDDETAPROB,              COD_PAGO,
              MONTO_LOCAL,           MONTO_MONEDA,            IDSINIESTRO,
              CODTRANSAC,            CODCPTOTRANSAC,          CODCIA,
              CODEMPRESA,            COD_MONEDA)
           VALUES
             (NNUM_APROBACION,       D.IDDETAPROB,            D.COD_PAGO,
              D.MONTO_LOCAL,         D.MONTO_MONEDA,          D.IDSINIESTRO,
              D.CODTRANSAC,          D.CODCPTOTRANSAC,        D.CODCIA,
              D.CODEMPRESA,          D.COD_MONEDA);
        END LOOP;
        --
     END IF;
     --
  END IF;
  --
  IF cMsjError IS NULL THEN
     OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'PROCE');
  ELSE
     OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Reserva en solicitud: '||cMsjError);
     OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
  END IF;
  --
  --
EXCEPTION
  WHEN OTHERS THEN
       ROLLBACK;
       OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Error 1: '||SQLERRM);
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END SOLICITUD_PAGOS;  
--
--
PROCEDURE SOLICITUD_PAGOS_BORRADO(NCODCIA       NUMBER,   NCODEMPRESA     NUMBER,   NIDSINIESTRO NUMBER,  
                                  NIDDETSIN     NUMBER,   NNUM_APROBACION NUMBER,   CID_COL_INDI VARCHAR2,
                                  nIdProcMasivo NUMBER) IS     
--
cMsjError   PROCESOS_MASIVOS_LOG.TxtError%TYPE := NULL;
NBORRADO    NUMBER;
--
BEGIN
  --
  -- PROCESA SINIESTRO SI ES INDIVIDUAL
  --
  IF NIDSINIESTRO > 0 AND CID_COL_INDI = 'I' THEN
     --
     DELETE APROBACIONES A
      WHERE A.IDSINIESTRO    = NIDSINIESTRO
        AND A.NUM_APROBACION = NNUM_APROBACION
        AND A.STSAPROBACION  = 'SOL'
        AND A.CODCIA         = NCODCIA
        AND A.CODEMPRESA     = NCODEMPRESA;
     --   
     NBORRADO := SQL%ROWCOUNT;
     --
     IF NBORRADO > 0 THEN
        DELETE DETALLE_APROBACION A
         WHERE A.IDSINIESTRO    = NIDSINIESTRO
           AND A.NUM_APROBACION = NNUM_APROBACION
           AND A.CODCIA         = NCODCIA;
     END IF;
     --
  END IF;
  --
  -- PROCESA SINIESTRO SI ES COLECTIVO
  --
  IF NIDSINIESTRO > 0 AND CID_COL_INDI = 'C' THEN
     --
     -- VALIDA DETALLE_SINIESTRO
     --
     DELETE APROBACION_ASEG A
      WHERE A.IDSINIESTRO    = NIDSINIESTRO
        AND A.IDDETSIN       = NIDDETSIN
        AND A.NUM_APROBACION = NNUM_APROBACION
        AND A.STSAPROBACION  = 'SOL'
        AND A.CODCIA         = NCODCIA
        AND A.CODEMPRESA     = NCODEMPRESA;
     --   
     NBORRADO := SQL%ROWCOUNT;
     --
     IF NBORRADO > 0 THEN
        DELETE DETALLE_APROBACION_ASEG A
         WHERE A.IDSINIESTRO    = NIDSINIESTRO
           AND A.NUM_APROBACION = NNUM_APROBACION
           AND A.CODCIA         = NCODCIA;
     END IF;
     --
  END IF;
  --
  IF cMsjError IS NULL THEN
     OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'PROCE');
  ELSE
     OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Reserva en solicitud: '||cMsjError);
     OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
  END IF;
  --
EXCEPTION
  WHEN OTHERS THEN
       ROLLBACK;
       OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Error 1: '||SQLERRM);
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END SOLICITUD_PAGOS_BORRADO;  
--
--
PROCEDURE SOLICITUD_PAGOS_EMISION(NCODCIA      NUMBER,     NCODEMPRESA     NUMBER,   NIDSINIESTRO  NUMBER,
                                  NIDDETSIN    NUMBER,     NNUM_APROBACION NUMBER,   CID_COL_INDI  VARCHAR2,   
                                  CDESCRIPCION VARCHAR2,   DFECPAGO        DATE,     nIdProcMasivo NUMBER) IS     
--
NIDPOLIZA              POLIZAS.IdPoliza%TYPE;
CCOD_MONEDA            POLIZAS.Cod_Moneda%TYPE;
NSUMAASEG_MONEDA       POLIZAS.SUMAASEG_MONEDA%TYPE;
NSUMASEGURADAREAL      POLIZAS.SUMAASEG_MONEDA%TYPE;
WNIDDETSIN             COBERTURA_SINIESTRO_ASEG.IDDETSIN%TYPE;
DFECHA                 COBERTURA_SINIESTRO_ASEG.FECRES%TYPE;
CCODTRANSAC            COBERTURA_SINIESTRO_ASEG.CODTRANSAC%TYPE;
NCOD_ASEGURADO         COBERTURA_SINIESTRO_ASEG.COD_ASEGURADO%TYPE;
NIDETPOL               SINIESTRO.IDetPol%TYPE;
NIDTRANSACCION         TRANSACCION.IDTRANSACCION%TYPE;
cMsjError              PROCESOS_MASIVOS_LOG.TxtError%TYPE := NULL;
cExisteCob             VARCHAR2(1);
nCodError              NUMBER(2) := Null;
cObservacion           VARCHAR2(100);
--
--
BEGIN
    --
    -- VALIDA SINIESTRO
    --
    BEGIN
      SELECT S.IDPOLIZA,  S.IDETPOL,  S.COD_MONEDA,  S.COD_ASEGURADO 
        INTO NIDPOLIZA,   NIDETPOL,   CCOD_MONEDA,   NCOD_ASEGURADO
        FROM SINIESTRO S
       WHERE S.IDSINIESTRO = NIDSINIESTRO
         AND S.CODCIA      = NCODCIA;
    EXCEPTION 
      WHEN NO_DATA_FOUND  THEN
           nCodError    := 01;
           cObservacion := 'Codigo Error 02: NO EXISTE EL SINIESTRO';
           RAISE_APPLICATION_ERROR(-20225,'Codigo Error 01: NO EXISTE EL SINIESTRO - '||NIDSINIESTRO||' - '||SQLERRM);
      WHEN OTHERS THEN 
           nCodError    := 01;
           cObservacion := 'Codigo Error 02: NO EXISTE EL SINIESTRO OTHERS';
           RAISE_APPLICATION_ERROR(-20225,'Codigo Error 01: NO EXISTE EL SINIESTRO  OTHERS- '||NIDSINIESTRO||' - '||SQLERRM);
    END;
    --
    CCODTRANSAC := 'OCURRE';
    --
    -- PROCESA SINIESTRO SI ES INDIVIDUAL
    --
    IF NIDSINIESTRO > 0 AND CID_COL_INDI = 'I' THEN
       --
       -- VALIDA DETALLE_SINIESTRO
       --
       BEGIN
         SELECT DS.IDDETSIN
           INTO WNIDDETSIN
           FROM DETALLE_SINIESTRO DS
          WHERE DS.IDSINIESTRO = NIDSINIESTRO
            AND DS.IDDETSIN    = NIDDETSIN;
       EXCEPTION 
         WHEN NO_DATA_FOUND  THEN
              nCodError    := 02;
              cObservacion := 'Codigo Error 02: NO EXISTE EL DETALLE DE SINIESTRO';
              RAISE_APPLICATION_ERROR(-20225,'Codigo Error 02: NO EXISTE EL DETALLE DE SINIESTRO  - '||NIDSINIESTRO||' - 1 '||SQLERRM);
         WHEN OTHERS THEN 
              nCodError    := 02;
              cObservacion := 'Codigo Error 02: NO EXISTE EL DETALLE DE SINIESTRO OTHERS';
              RAISE_APPLICATION_ERROR(-20225,'Codigo Error 02: NO EXISTE EL DETALLE DE SINIESTRO OTHERS- '||NIDSINIESTRO||' - 1 '||SQLERRM);
       END;       
       --
       -- VALIDA APROBACION
       --
       BEGIN
         SELECT 'S'
           INTO cExisteCob
           FROM APROBACIONES A
          WHERE A.IDSINIESTRO    = NIDSINIESTRO
            AND A.NUM_APROBACION = NNUM_APROBACION
            AND A.CODCIA         = NCODCIA
            AND A.IDDETSIN       = NIDDETSIN
            AND A.STSAPROBACION  = 'SOL';
       EXCEPTION
         WHEN NO_DATA_FOUND THEn
              nCodError := 03;
              cObservacion := 'Codigo Error 03:NO Existe Aprobacion .';
              RAISE_APPLICATION_ERROR(-20225,'NO Existe Aprobacion de '||NNUM_APROBACION);
         WHEN TOO_MANY_ROWS THEn
              cExisteCob := 'S'; 
         WHEN OTHERS THEn
              nCodError := 03;
              cObservacion := 'Codigo Error 03:NO Existe Aprobacion por others.';
              RAISE_APPLICATION_ERROR(-20225,'OTHERS NO Existe Aprobacion de '||NNUM_APROBACION);
       END;
       --
       IF cExisteCob = 'S' THEN
          --
          IF DFECPAGO IS NULL THEN
             DFECHA := TRUNC(SYSDATE);
          ELSE 
             DFECHA := DFECPAGO;
          END IF;
          --
          BEGIN
            OC_APROBACIONES.PAGAR(NCODCIA, NCODEMPRESA, NNUM_APROBACION, NIDSINIESTRO, NIDPOLIZA, NIDDETSIN);
          EXCEPTION
            WHEN OTHERS THEN
                 nCodError := 99;
                 cObservacion := 'Error al Pagar la Aprobación del Siniestro.';
                 RAISE_APPLICATION_ERROR(-20225,'Error al Pagar la Aprobación del Siniestro: '|| NIDSINIESTRO || ' ' || SQLERRM);
          END;
          -- 
          IF DFECHA IS NOT NULL THEN
             --
             UPDATE APROBACIONES A
                SET A.FECPAGO = DFECHA
              WHERE A.IDSINIESTRO    = NIDSINIESTRO
                AND A.NUM_APROBACION = NNUM_APROBACION
                AND A.CODCIA         = NCODCIA
                AND A.IDDETSIN       = NIDDETSIN;
             --
             nIDTRANSACCION := OBTIENE_TRANSA_PAG_IND(nNUM_APROBACION, nIdPoliza , nIdSiniestro , NIDDETSIN , DFECHA);          
             --
             CAMBIA_FECHA_CONTA(NIDTRANSACCION, nCodCia, DFECHA, nCodEmpresa); 
             CAMBIA_FECHA_OBSERVACION(NIDSINIESTRO, NIDPOLIZA, DFECHA);
             --
          END IF;          
          --
       END IF;
       --
    END IF;
    --
    -- PROCESA SINIESTRO SI ES COLECTIVO
    --
    IF NIDSINIESTRO > 0 AND CID_COL_INDI = 'C' THEN
       --
       -- VALIDA DETALLE_SINIESTRO
       --
       BEGIN
         SELECT DS.IDDETSIN
           INTO WNIDDETSIN
           FROM DETALLE_SINIESTRO_ASEG DS
          WHERE DS.IDSINIESTRO = NIDSINIESTRO
            AND DS.IDDETSIN    = NIDDETSIN;
       EXCEPTION 
         WHEN NO_DATA_FOUND  THEN
              nCodError    := 02;
              cObservacion := 'Codigo Error 02: NO EXISTE EL DETALLE DE SINIESTRO';
              RAISE_APPLICATION_ERROR(-20225,'Codigo Error 02: NO EXISTE EL DETALLE DE SINIESTRO  - '||NIDSINIESTRO||' - 1 '||SQLERRM);
         WHEN OTHERS THEN 
              nCodError    := 02;
              cObservacion := 'Codigo Error 02: NO EXISTE EL DETALLE DE SINIESTRO OTHERS';
              RAISE_APPLICATION_ERROR(-20225,'Codigo Error 02: NO EXISTE EL DETALLE DE SINIESTRO OTHERS- '||NIDSINIESTRO||' - 1 '||SQLERRM);
       END;       
       --
       -- VALIDA APROBACION
       --
       BEGIN
         SELECT 'S'
           INTO cExisteCob
           FROM APROBACION_ASEG A
          WHERE A.IDSINIESTRO     = NIDSINIESTRO
            AND A.NUM_APROBACION = NNUM_APROBACION
            AND A.CODCIA          = NCODCIA
            AND A.IDDETSIN        = NIDDETSIN
            AND A.STSAPROBACION    = 'SOL';
       EXCEPTION
         WHEN NO_DATA_FOUND THEn
              nCodError := 03;
              cObservacion := 'Codigo Error 03:NO Existe Aprobacion .';
              RAISE_APPLICATION_ERROR(-20225,'NO Existe Aprobacion de '||NNUM_APROBACION);
         WHEN TOO_MANY_ROWS THEn
              cExisteCob := 'S'; 
         WHEN OTHERS THEn
              nCodError := 03;
              cObservacion := 'Codigo Error 03:NO Existe Aprobacion por others.';
              RAISE_APPLICATION_ERROR(-20225,'OTHERS NO Existe Aprobacion de '||NNUM_APROBACION);
       END;
       --
       IF cExisteCob = 'S' THEN
          --
          IF DFECPAGO IS NULL THEN
             DFECHA := TRUNC(SYSDATE);
          ELSE 
             DFECHA := DFECPAGO;
          END IF;
          --
          BEGIN
            OC_APROBACION_ASEG.PAGAR(NCODCIA, NCODEMPRESA, NNUM_APROBACION,NIDSINIESTRO, NIDPOLIZA, NCOD_ASEGURADO, NIDDETSIN);
         EXCEPTION
            WHEN OTHERS THEN
                 nCodError := 99;
                 cObservacion := 'Error al Pagar la Aprobación del Siniestro.';
                 RAISE_APPLICATION_ERROR(-20225,'Error al Pagar la Aprobación del Siniestro: '|| NIDSINIESTRO || ' ' || SQLERRM);
          END;
          -- 
          IF DFECHA IS NOT NULL THEN
             --
             UPDATE APROBACION_ASEG A
                SET A.FECPAGO = DFECHA
              WHERE A.IDSINIESTRO     = NIDSINIESTRO
                AND A.NUM_APROBACION = NNUM_APROBACION
                AND A.CODCIA          = NCODCIA
                AND A.IDDETSIN        = NIDDETSIN;
             --
             nIDTRANSACCION := OBTIENE_TRANSA_PAG_COL(nNUM_APROBACION, nIdPoliza , nIdSiniestro , NIDDETSIN , DFECHA, nCod_Asegurado);
             --
             CAMBIA_FECHA_CONTA(NIDTRANSACCION, nCodCia, DFECHA, nCodEmpresa); 
             CAMBIA_FECHA_OBSERVACION(NIDSINIESTRO, NIDPOLIZA, DFECHA);
             --
          END IF;          
          --
       END IF;
       --
    END IF;
    --
    IF cMsjError IS NULL THEN
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'PROCE');
    ELSE
       OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Reserva en solicitud: '||cMsjError);
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
    END IF;
    --
  --
EXCEPTION
  WHEN OTHERS THEN
       ROLLBACK;
       OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Error 1: '||SQLERRM);
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END SOLICITUD_PAGOS_EMISION; 
--
--- MLJS 18/06/2025-23/06/2025 FUNCIONES PARA LA CARGA MASIVA DE PAGOS DE SINIESTRO
FUNCTION FN_VALIDARESERVA_SOL (PIDSINIESTRO IN NUMBER) RETURN VARCHAR2 IS
  NHAYRVASOL  NUMBER;
  CEXISTE     VARCHAR2(1);
  NCODCIA       SINIESTRO.CODCIA%TYPE;
  NIDPOLIZA     SINIESTRO.IDPOLIZA%TYPE;
  NIDETPOL      SINIESTRO.IDETPOL%TYPE;
  NCODASEGURADO SINIESTRO.COD_ASEGURADO%TYPE;
BEGIN
  CEXISTE := 'N';
  SELECT S.IDPOLIZA, S.IDETPOL, S.COD_ASEGURADO, S.CODCIA
  INTO   NIDPOLIZA,  NIDETPOL,  NCODASEGURADO, NCODCIA
  FROM   SINIESTRO S
  WHERE  IDSINIESTRO = PIDSINIESTRO;
  IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(NCODCIA, nIdPoliza, nIDetPol, nCodAsegurado) = 'S' THEN
     SELECT COUNT(*)
     INTO   NHAYRVASOL
     FROM   COBERTURA_SINIESTRO_ASEG CSA
     WHERE  CSA.IDSINIESTRO = PIDSINIESTRO
     AND    CSA.MONTO_RESERVADO_MONEDA != 0
     AND    CSA.STSCOBERTURA IN ('SOL');
  ELSE
     SELECT COUNT(*)
     INTO   NHAYRVASOL
     FROM   COBERTURA_SINIESTRO CSA
     WHERE  CSA.IDSINIESTRO = PIDSINIESTRO
     AND    CSA.MONTO_RESERVADO_MONEDA != 0
     AND    CSA.STSCOBERTURA IN ('SOL');
  END IF;

  IF NHAYRVASOL > 0 THEN
     CEXISTE := 'S';
  END IF;

  RETURN CEXISTE;

END FN_VALIDARESERVA_SOL;

FUNCTION FN_VALIDARESERVA_EMI(PIDSINIESTRO IN NUMBER) RETURN VARCHAR2 IS
  NRVANOCONTA   NUMBER;
  CEXISTE       VARCHAR2(1);
  NCODCIA       SINIESTRO.CODCIA%TYPE;
  NIDPOLIZA     SINIESTRO.IDPOLIZA%TYPE;
  NIDETPOL      SINIESTRO.IDETPOL%TYPE;
  NCODASEGURADO SINIESTRO.COD_ASEGURADO%TYPE;
  cCargaRegistro VARCHAR2(1);
  cMsgArchErr VARCHAR2(2000);

BEGIN
  CEXISTE := 'N';
  SELECT S.IDPOLIZA, S.IDETPOL, S.COD_ASEGURADO, S.CODCIA
  INTO   NIDPOLIZA,  NIDETPOL,  NCODASEGURADO, NCODCIA
  FROM   SINIESTRO S
  WHERE  IDSINIESTRO = PIDSINIESTRO;

  IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(NCODCIA, nIdPoliza, nIDetPol, nCodAsegurado) = 'S' THEN
     SELECT COUNT(*)
     INTO   NRVANOCONTA
     FROM   COBERTURA_SINIESTRO_ASEG CSA INNER JOIN TRANSACCION T ON (CSA.IDTRANSACCION = T.IDTRANSACCION )
                                         INNER JOIN SINIESTRO   S ON (S.IDSINIESTRO     = CSA.IDSINIESTRO)
     WHERE  CSA.MONTO_RESERVADO_MONEDA != 0
     AND    CSA.IDTRANSACCION IS NOT NULL
     AND    CSA.STSCOBERTURA IN ('EMI')
     AND    S.STS_SINIESTRO NOT IN ('ANU','CER')
     AND    CSA.IDSINIESTRO = PIDSINIESTRO
     AND    NOT EXISTS (SELECT *
                        FROM   COMPROBANTES_CONTABLES CC
                        WHERE  CC.CODCIA = 1
                        AND    CC.NUMTRANSACCION = T.IDTRANSACCION)
     ORDER BY CSA.IDSINIESTRO DESC  ;

  ELSE
     SELECT COUNT(*)
     INTO   NRVANOCONTA
     FROM   COBERTURA_SINIESTRO CSA INNER JOIN TRANSACCION T ON (CSA.IDTRANSACCION = T.IDTRANSACCION )
                                    INNER JOIN SINIESTRO   S ON (S.IDSINIESTRO     = CSA.IDSINIESTRO)
     WHERE  CSA.MONTO_RESERVADO_MONEDA != 0
     AND    CSA.IDTRANSACCION IS NOT NULL
     AND    CSA.STSCOBERTURA IN ('EMI')
     AND    S.STS_SINIESTRO NOT IN ('ANU','CER')
     AND    CSA.IDSINIESTRO = PIDSINIESTRO
     AND    NOT EXISTS (SELECT *
                        FROM   COMPROBANTES_CONTABLES CC
                        WHERE  CC.CODCIA = 1
                        AND    CC.NUMTRANSACCION = T.IDTRANSACCION)
     ORDER BY CSA.IDSINIESTRO DESC ;
  END IF;

  IF NRVANOCONTA > 0 THEN
     CEXISTE := 'S';
  END IF;
  RETURN CEXISTE;
END FN_VALIDARESERVA_EMI;

FUNCTION CREAR(cCodCia NUMBER, cCodEmpresa NUMBER) RETURN NUMBER IS
nIdProcMasivo  PROCESOS_MASIVOS.IdProcMasivo%TYPE;
BEGIN
   BEGIN
      SELECT IDPROCMASIVO_SEQ.NEXTVAL
      INTO   nIdProcMasivo
      FROM   DUAL;
      UPDATE GENERALES
         SET UltValor = nIdProcMasivo
       WHERE CodCia   = cCodCia
         AND CodCampo = 'IDPROCMASIVO';
   END;
   RETURN (nIdProcMasivo);
END CREAR; 

FUNCTION CAMBIA_CARACTERES(CADENA_ENTRADA VARCHAR2) RETURN VARCHAR2 IS
  CADENA_SALIDA VARCHAR2(4000);
  ENTRADA       VARCHAR2(50) := 'áéíóúÀÁÂAÄAÈÉÊËÌÍÎÏÒÓÔOÖÙÚÛÜ';
  SALIDA        VARCHAR2(50) := 'aeiouAAAAAAEEEEIIIIOOOOOUUUU';
BEGIN
CADENA_SALIDA :=  UPPER(TRANSLATE(LTRIM(CADENA_ENTRADA),ENTRADA,SALIDA));
CADENA_SALIDA :=  REPLACE(CADENA_SALIDA,'(','');
CADENA_SALIDA :=  REPLACE(CADENA_SALIDA,')','');
CADENA_SALIDA :=  REPLACE(CADENA_SALIDA,'?','');
CADENA_SALIDA :=  REPLACE(CADENA_SALIDA,'?','');
CADENA_SALIDA :=  REPLACE(CADENA_SALIDA,'!','');
CADENA_SALIDA :=  REPLACE(CADENA_SALIDA,'!','');
CADENA_SALIDA :=  REPLACE(CADENA_SALIDA,':','');
CADENA_SALIDA :=  REPLACE(CADENA_SALIDA,';','');
CADENA_SALIDA :=  REPLACE(CADENA_SALIDA,' ','');
CADENA_SALIDA :=  REPLACE(CADENA_SALIDA,'"','');
CADENA_SALIDA :=  REPLACE(CADENA_SALIDA,' ','');
RETURN(CADENA_SALIDA);
END;

PROCEDURE CONVERT_TO_CLOB IS
L_DEST_OFFSET  NUMBER := 1;
L_SRC_OFFSET   NUMBER := 1;
L_LANG_CONTEXT NUMBER := DBMS_LOB.DEFAULT_LANG_CTX;
L_WARNING      NUMBER;
 L_CLOB CLOB;
 L_BFILE  BFILE;
  L_BLOB   BLOB;
BEGIN

DBMS_LOB.CREATETEMPORARY ( L_CLOB, TRUE );
DBMS_LOB.CONVERTTOCLOB(
DEST_LOB      => L_CLOB,
SRC_BLOB      => L_BLOB,
AMOUNT        => DBMS_LOB.LOBMAXSIZE,
DEST_OFFSET   => L_DEST_OFFSET,
SRC_OFFSET    => L_SRC_OFFSET,
BLOB_CSID     => NLS_CHARSET_ID('AL32UTF8'),
LANG_CONTEXT  => L_LANG_CONTEXT,
WARNING       => L_WARNING );
END CONVERT_TO_CLOB;

PROCEDURE SP_CARGA_ARCHIVO(P_CODCIA NUMBER, P_CODEMPRESA NUMBER, P_TIPOPROCESO VARCHAR2, P_DESC_TPO_PROC VARCHAR2, P_LINEA VARCHAR2, P_CODUSUARIO VARCHAR2, 
                           P_TERMINAL VARCHAR2, P_NLINEA OUT NUMBER, P_MENSAJE OUT VARCHAR2) IS
  W_IDSINIESTRO   SINIESTRO.IDSINIESTRO%TYPE;
  nIdDetSin       DETALLE_SINIESTRO.IDDETSIN%TYPE;
  cNumSiniRef     SINIESTRO.NumSiniRef%TYPE;
  cCodEmpresa     POLIZAS.CODEMPRESA%TYPE;
  NIdPoliza       POLIZAS.IDPOLIZA%TYPE;
  nIDetPol        DETALLE_POLIZA.IDETPOL%TYPE;
  cNumPolUnico    PROCESOS_MASIVOS.NumPolUnico%TYPE;
  cNumReferencia  VARCHAR2(40);
  cStsPoliza      POLIZAS.StsPoliza%TYPE;
  cMotivAnul      POLIZAS.MOTIVANUL%TYPE;
  nCod_Asegurado  ASEGURADO.Cod_Asegurado%TYPE; 
  nCodCliente     POLIZAS.CodCliente%TYPE;
  cTipoEvento     VARCHAR2(400);
  cIdTipoSeg      DETALLE_POLIZA.IdTipoSeg%TYPE;
  cPlanCob        DETALLE_POLIZA.PlanCob%TYPE;
  cNumDetUnico    PROCESOS_MASIVOS.NumDetUnico%TYPE;
  nNumDetUnico    DETALLE_POLIZA.IDetPol%TYPE;
  PlanDeCobro     VARCHAR2(20);
  nINDPOLCOL      VARCHAR2(10);

  nIdCredito      INFO_ALTBAJ.Id_Credito%TYPE;
  nIdTrabaj       INFO_ALTBAJ.Id_Trabajador%TYPE;
  cIdCredThona    INFO_ALTBAJ.Id_Credito_Thona%TYPE;

  W_ID_ENVIO         INFO_SINIESTRO.ID_ENVIO%TYPE;
  W_POLIZA           POLIZAS.IDPOLIZA%TYPE;
  W_CODASEG          ASEGURADO.Cod_Asegurado%TYPE;
  W_NUMAPROB         NUMBER;
  WC_CARGA           NUMBER;
  W_TI_LEIDOS        NUMBER;
  WI_ARCHIVO_REPORTE VARCHAR2(1000);
  W_LINEA_REPORTE    VARCHAR2(1000);
  INICIO             VARCHAR2(50);
  W_PROCESOS         VARCHAR2(6);
  W_MONTO            COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
  PasasManito        NUMBER;
  NumRegistro        NUMBER := 0;    

  W_IDCARGA          PROCESOS_MASIVOS_SEGUIMIENTO.IDPROCMASIVO%TYPE; 
  W_POLCONTA_GG      PROCESOS_MASIVOS_SEGUIMIENTO.POLCONTA_GG%TYPE; 
  W_FECHA_PAGO       PROCESOS_MASIVOS_SEGUIMIENTO.FECHA_PAGO%TYPE;   
  W_IMPORT_PAGO      PROCESOS_MASIVOS_SEGUIMIENTO.IMPORT_PAGO%TYPE;
  HABEMUSPAGUS       NUMBER := 0; 
  nNombreArchivo     PROCESOS_MASIVOS.NomArchivoCarga%TYPE;
  nIdProcMasivo      PROCESOS_MASIVOS.IdProcMasivo%TYPE;

  NGASTOSHONORARIOS	     SINIESTRO.MONTO_RESERVA_LOCAL%TYPE;
  NGASTOSHOSPITALARIOS 	 SINIESTRO.MONTO_RESERVA_LOCAL%TYPE;
  NOTROSGASTOS	         SINIESTRO.MONTO_RESERVA_LOCAL%TYPE;
  NDESCUENTO	           SINIESTRO.MONTO_RESERVA_LOCAL%TYPE;
  NDEDUCIBLE             SINIESTRO.MONTO_RESERVA_LOCAL%TYPE;
  NMONTOAPAGAR           SINIESTRO.MONTO_RESERVA_LOCAL%TYPE;
  cCodCobert             COBERTURA_SINIESTRO.CODCOBERT%TYPE;
  nSaldoRvaMoneda        COBERTURA_SINIESTRO.SALDO_RESERVA%TYPE;
  nSaldoRvaLocal         COBERTURA_SINIESTRO.SALDO_RESERVA_LOCAL%TYPE;
  NSUMASEGREMANENTE      COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;

  cRegDatosProc  VARCHAR2(4000);
  cCargaRegistro VARCHAR2(1);
  cMsgArchErr    VARCHAR2(2000);
  cConteoCarga   NUMBER(10)    := 0;
  nLinea         NUMBER := 0;
  clinea         VARCHAR2(32000);
  cSeparador     VARCHAR2(1) := '|';
  NVEZE          NUMBER :=0;
  l_id           NUMBER;
BEGIN
   clinea := P_LINEA; 
   IF P_TIPOPROCESO IN ('PAGSIN') THEN
      W_IDSINIESTRO  := OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,1,',');
      cNumPolUnico   := TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,3,cSeparador));
      nCod_Asegurado := TO_NUMBER(TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,4,cSeparador)));
      cCodEmpresa    := P_CODEMPRESA;
      BEGIN
         SELECT IDPOLIZA INTO NIdPoliza
         FROM POLIZAS 
         WHERE NumPolUnico = cNumPolUnico
         AND STSPOLIZA = 'EMI';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cCargaRegistro := 'N';
            cMsgArchErr := 'No Existe Poliza';
      END;

      BEGIN
         SELECT IdTipoSeg, PlanCob, IDetPol INTO cIdTipoSeg, cPlanCob, cNumDetUnico
           FROM DETALLE_POLIZA
          WHERE IdPoliza   = NIdPoliza
            AND CodCia     = P_CODCIA
            AND IDetPol   IN (SELECT MIN(IDetPol) FROM DETALLE_POLIZA WHERE IdPoliza      = NIdPoliza AND CodCia        = P_CODCIA AND Cod_Asegurado = nCod_Asegurado
                              UNION SELECT MIN(IDetPol) FROM ASEGURADO_CERTIFICADO WHERE IdPoliza      = NIdPoliza AND CodCia        = P_CODCIA AND Cod_Asegurado = nCod_Asegurado
                              UNION SELECT MIN(IDetPol) FROM ASEGURADO_CERT WHERE IdPoliza      = NIdPoliza AND CodCia        = P_CODCIA AND Cod_Asegurado = nCod_Asegurado);
         cCargaRegistro := 'S';
         cRegDatosProc  := cLinea;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cCargaRegistro := 'N'; cMsgArchErr := 'No Existe asegurado '||nCod_Asegurado;
         WHEN TOO_MANY_ROWS THEN
            cCargaRegistro := 'N'; cMsgArchErr := 'Existe en Varios Detalles de la Póliza No. ' || cNumPolUnico;
      END;

      -- MLJS 18/06/2025 VALIDACIONES DE RESERVA
      IF OC_PROCESOS_MAS_SINI.FN_VALIDARESERVA_SOL(W_IDSINIESTRO) = 'S' THEN
         cCargaRegistro := 'N';
         cMsgArchErr := 'El siniestro '||W_IDSINIESTRO||' tiene reservas en SOLICITUD. Favor de validar la información.';
      ELSE
         IF OC_PROCESOS_MAS_SINI.FN_VALIDARESERVA_EMI(W_IDSINIESTRO) = 'S' THEN
            cCargaRegistro := 'N';
            cMsgArchErr := 'El siniestro '||W_IDSINIESTRO||' tiene reservas no contabilizadas. Favor de validar la información.';
         ELSE 
           BEGIN
              SELECT IdDetSin
                INTO nIdDetSin
                FROM DETALLE_SINIESTRO_ASEG
               WHERE IdSiniestro = W_IDSINIESTRO
              UNION
              SELECT IdDetSin
                FROM DETALLE_SINIESTRO
               WHERE IdSiniestro = W_IDSINIESTRO;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 cCargaRegistro := 'N';
                 cMsgArchErr  := 'No Es Posible Determinar Detalle Del Siniestro '||W_IDSINIESTRO||' Para Validar Cobertura, Favor de validar la información.';
           END;
           NGASTOSHONORARIOS	   := TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,12,cSeparador));
           NGASTOSHOSPITALARIOS  := TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,13,cSeparador));
           NOTROSGASTOS	         := TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,14,cSeparador));
           NDESCUENTO	           := TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,15,cSeparador));
           NDEDUCIBLE            := TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,16,cSeparador));
           NMONTOAPAGAR          := TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,22,cSeparador)); --MLJS 30/07/2025 21->22

           BEGIN
             SELECT DISTINCT CodCobert
               INTO cCodCobert
               FROM COBERTURA_SINIESTRO_ASEG
              WHERE IdSiniestro  = W_IDSINIESTRO
                AND IdDetSin     = nIdDetSin
                AND IdPoliza     = nIdPoliza
                AND Cod_Asegurado = nCod_Asegurado
             UNION
             SELECT DISTINCT CodCobert
               FROM COBERTURA_SINIESTRO
              WHERE IdSiniestro  = W_IDSINIESTRO
                AND IdDetSin     = nIdDetSin
                AND IdPoliza     = nIdPoliza
                AND Cod_Asegurado = nCod_Asegurado;  
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                cCargaRegistro := 'N';
                cMsgArchErr    := 'No Es Posible Determinar Una Cobertura Para El Siniestro '||W_IDSINIESTRO||'. Favor de validar la información.';
              WHEN TOO_MANY_ROWS THEN
                cCargaRegistro := 'N';
                cMsgArchErr    := 'Existe mas de uan cobertura para el siniestro '||W_IDSINIESTRO||'. Favor de validar la información..';
           END;

           IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(P_CODCIA, nIdPoliza, nIDetPol, nCod_Asegurado) = 'S' THEN

              OC_COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA(W_IDSINIESTRO, nIdPoliza, nIdDetSin, nCod_Asegurado,
                                                        cCodCobert, nSaldoRvaMoneda, nSaldoRvaLocal);
              NSUMASEGREMANENTE := OC_COBERTURA_SINIESTRO_ASEG.SUM_ASEG_REMANENTE(P_CODCIA, nIdPoliza, nIDetPol, nCod_Asegurado,cCodCobert);

           ELSE
              OC_COBERTURA_SINIESTRO.SALDO_RESERVA(W_IDSINIESTRO, nIdPoliza, nIdDetSin,
                                                   cCodCobert, nSaldoRvaMoneda, nSaldoRvaLocal);

              NSUMASEGREMANENTE := OC_COBERT_ACT.SUMA_ASEGURADA(P_CODCIA,nIdPoliza, nIDetPol,cCodCobert) -
                                   OC_COBERTURA_SINIESTRO.PAGO_DE_COB_SINIESTRO (P_CODCIA, W_IDSINIESTRO, cCodCobert);

           END IF;

           IF     NMONTOAPAGAR > nSaldoRvaMoneda THEN
              cCargaRegistro := 'N';
              cMsgArchErr    := 'El Monto a Pagar es mayor a la Reserva del siniestro '||W_IDSINIESTRO||'. Favor de validar la información.';
           ELSIF  NSUMASEGREMANENTE < NMONTOAPAGAR THEN
              cCargaRegistro := 'N';
              cMsgArchErr    := 'El Monto a Pagar del siniestro '||W_IDSINIESTRO||' es mayor a la Suma Asegurada. Favor de validar la información.';                
           END IF;

         END IF;
      -- MLJS 18/06/2025 y 23/06/2025 VALIDACIONES DE RESERVA   
      ------------------------------------------------------------------------
      END IF;
   ELSIF P_TIPOPROCESO IN ('ESTSIN', 'MODSIN', 'SINRVA') THEN
      cNumPolUnico   := TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,2,','));
      nNumDetUnico   := TO_NUMBER(TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,5,',')));
      nCodCliente    := TO_NUMBER(TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,3,',')));
      nCod_Asegurado := TO_NUMBER(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,6,','));
      cTipoEvento    := TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,100,','));
      cNumSiniRef    := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,1,','));
      cCodEmpresa    := P_CODEMPRESA;
      IF cTipoEvento = 'IVA' THEN
        BEGIN
           SELECT P.IdPoliza, DP.IDetPol, DP.IdTipoSeg, Dp.PlanCob,P.StsPoliza, P.MotivAnul, P.CodCliente, SI.Cod_Asegurado
             INTO nIdPoliza, cNumDetUnico, cIdTipoSeg, cPlanCob,cStsPoliza, cMotivAnul, nCodCliente, nCod_Asegurado
             FROM SINIESTRO SI, POLIZAS P, DETALLE_POLIZA DP
            WHERE SI.NumSiniRef  = cNumSiniRef
              AND SI.CodCia      = P_CODCIA
              AND SI.IdPoliza    = P.IdPoliza
              AND P.StsPoliza   IN ('REN','EMI','ANU')
              AND SI.IdPoliza    = DP.IdPoliza
              AND SI.IDetPol     = DP.IDetPol;
           cCargaRegistro := 'S'; cRegDatosProc  := cLinea;
        EXCEPTION
           WHEN OTHERS THEN
              cCargaRegistro := 'N'; cMsgArchErr    := 'No hay Siniestro '||SQLERRM;                   
        END;
        BEGIN
           cLinea := OC_PROCESOS_MASIVOS.INSERTA_VALOR_CAMPO(cLinea, 3, ',', nCodCliente);
           cLinea := OC_PROCESOS_MASIVOS.INSERTA_VALOR_CAMPO(cLinea, 6, ',', nCod_Asegurado);
        EXCEPTION
           WHEN OTHERS THEN
              cCargaRegistro := 'N'; cMsgArchErr    := 'Error al Actualizar PROCESOS_MASIVOS: '|| SQLERRM;
        END;
      ELSE
        BEGIN
           SELECT P.IdPoliza, DP.IDetPol, DP.IdTipoSeg, Dp.PlanCob, P.StsPoliza, P.MotivAnul
             INTO nIdPoliza, cNumDetUnico, cIdTipoSeg, cPlanCob, cStsPoliza, cMotivAnul
             FROM POLIZAS P, DETALLE_POLIZA DP
            WHERE P.CodCia       = P_CODCIA AND P.NumPolUnico  = cNumPolUnico AND P.StsPoliza    IN ('REN','EMI','ANU') AND P.CodCliente   = nCodCliente
              AND P.IdPoliza     = DP.IdPoliza AND DP.IDetPol     = nNumDetUnico;
           cCargaRegistro := 'S';
           cRegDatosProc  := cLinea;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              cCargaRegistro := 'N';
              cMsgArchErr := 'No hay datos';
           WHEN TOO_MANY_ROWS THEN
              cCargaRegistro := 'S';
              cRegDatosProc  := cLinea;
           BEGIN
              SELECT P.IdPoliza, DP.IDetPol, DP.IdTipoSeg, Dp.PlanCob, P.StsPoliza, P.MotivAnul
                INTO nIdPoliza, cNumDetUnico, cIdTipoSeg, cPlanCob, cStsPoliza, cMotivAnul
                FROM POLIZAS P, DETALLE_POLIZA DP
               WHERE P.CodCia       = P_CODCIA
                 AND P.NumPolUnico  = cNumPolUnico
                 AND P.StsPoliza   IN ('REN','EMI')
                 AND P.CodCliente   = nCodCliente
                 AND P.IdPoliza     = DP.IdPoliza
                 AND DP.IDetPol     = nNumDetUnico;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                cCargaRegistro := 'N'; cMsgArchErr := 'No hay datos';
           END;
        END;
      END IF;
      IF nCod_Asegurado > 0 AND cTipoEvento NOT IN ('IVA','VIDA') THEN
        BEGIN
          SELECT IdTipoSeg, PlanCob, IDetPol INTO cIdTipoSeg, cPlanCob, cNumDetUnico
            FROM DETALLE_POLIZA
           WHERE IdPoliza   = nIdPoliza
             AND CodCia     = P_CODCIA
             AND IDetPol   IN (SELECT MIN(IDetPol) FROM DETALLE_POLIZA WHERE IdPoliza = nIdPoliza AND CodCia = P_CODCIA AND Cod_Asegurado = nCod_Asegurado UNION
                               SELECT MIN(IDetPol) FROM ASEGURADO_CERTIFICADO WHERE IdPoliza = nIdPoliza AND CodCia = P_CODCIA AND Cod_Asegurado = nCod_Asegurado UNION
                               SELECT MIN(IDetPol) FROM ASEGURADO_CERT WHERE IdPoliza      = nIdPoliza AND CodCia        = P_CODCIA AND Cod_Asegurado = nCod_Asegurado);
          cCargaRegistro := 'S';
          cRegDatosProc  := cLinea;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              cCargaRegistro := 'N';
              cMsgArchErr := 'No Existe Poliza';
           WHEN TOO_MANY_ROWS THEN
              cCargaRegistro := 'N';
              cMsgArchErr := 'Varios Detalles';
        END;
      ELSIF cCargaRegistro = 'S' THEN
         cCargaRegistro := 'S';
         cRegDatosProc  := cLinea;
      END IF;
      IF cCargaRegistro = 'S' THEN
         IF cStsPoliza = 'ANU' AND cMotivAnul != 'FPA' THEN
            cCargaRegistro := 'N';
            cMsgArchErr := 'Poliza Anulada y Estatus Diferente a Falta de Pago';
         ELSE
            cCargaRegistro := 'S';
            cRegDatosProc  := cLinea;
         END IF;
      END IF;

   ELSIF P_TIPOPROCESO IN ('SINPAG') THEN
      cNumReferencia := TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,1,','));
      cCodEmpresa    := P_CODEMPRESA;
      BEGIN
         SELECT P.IdPoliza, P.NumPolUnico, DP.IDetPol,DP.IdTipoSeg, Dp.PlanCob, P.StsPoliza, P.MotivAnul,P.CodCliente, S.Cod_Asegurado
           INTO nIdPoliza, cNumPolUnico, cNumDetUnico,cIdTipoSeg, cPlanCob, cStsPoliza, cMotivAnul,nCodCliente, nCod_Asegurado
           FROM SINIESTRO S, POLIZAS P, DETALLE_POLIZA DP
          WHERE S.NumSiniRef = cNumReferencia
            AND S.IdPoliza   = P.IdPoliza
            AND P.StsPoliza  IN ('REN','EMI','ANU')
            AND S.IdPoliza   = DP.IdPoliza
            AND S.IDetPol    = DP.IDetPol;
         cCargaRegistro := 'S';
         cRegDatosProc  := cLinea;
      EXCEPTION
         WHEN OTHERS THEN
            cCargaRegistro := 'N';
            cMsgArchErr    := 'No hay datos';
      END;
   ELSIF P_TIPOPROCESO IN ('SINCER','SINDEV','SINEST','SINDRV') THEN
      W_ID_ENVIO  := OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,23,',');
      nIdCredito  := OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,4,',');
      nIdTrabaj   := OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,5,',');
      cCodEmpresa    := P_CODEMPRESA;
      cIdTipoSeg     := 'FONACO';
      cPlanCob       := 'INFONACOT';
      cRegDatosProc  := cLinea;
      cCargaRegistro := 'S';
      cNumPolUnico  := nIdCredito;
      cNumDetUnico  := nIdTrabaj;
   ELSIF P_TIPOPROCESO IN ('AURVAD', 'DIRVAD', 'PAGO' ) THEN
      W_IDSINIESTRO  := OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,1,',');
      W_PROCESOS     := OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,2,',');
      W_MONTO        := OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,3,',');
      PasasManito  := 1;
      IF P_TIPOPROCESO = W_PROCESOS THEN
         NULL;         
      ELSE     
         W_LINEA_REPORTE := 'Error al cargar Siniestro:  '||W_IDSINIESTRO||'  El proceso elegido ( '||
                            P_TIPOPROCESO||' ) no es igual al del LayOut ( '||W_PROCESOS||' ) ';
         PasasManito     := 0;
         cCargaRegistro  := 'N';
      END IF;
      IF PasasManito > 0 THEN
        BEGIN
          SELECT P.IdPoliza, DP.IDetPol, DP.IdTipoSeg, Dp.PlanCob, P.StsPoliza, P.MotivAnul,P.NUMPOLUNICO
            INTO nIdPoliza, cNumDetUnico, cIdTipoSeg, cPlanCob, cStsPoliza, cMotivAnul ,cNumPolUnico
            FROM SINIESTRO  SNT,
                 POLIZAS P, 
                 DETALLE_POLIZA DP
           WHERE SNT.IDSINIESTRO =  W_IDSINIESTRO AND P.CodCia    = SNT.CodCia AND P.IdPoliza  = SNT.IdPoliza
             AND P.StsPoliza IN ('REN','EMI','ANU') AND DP.CODCIA   = SNT.CodCia AND DP.IDPOLIZA = SNT.IdPoliza
             AND DP.IDETPOL  = SNT.IDetPol;
          cCargaRegistro := 'S';
          cRegDatosProc  := cLinea;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              cCargaRegistro := 'N';
              cMsgArchErr := 'No hay datos';
           WHEN TOO_MANY_ROWS THEN
              cCargaRegistro := 'S';
              cRegDatosProc  := cLinea;
              BEGIN
                 SELECT P.IdPoliza, DP.IDetPol, DP.IdTipoSeg, Dp.PlanCob, P.StsPoliza, P.MotivAnul,P.NUMPOLUNICO
                   INTO nIdPoliza, cNumDetUnico, cIdTipoSeg, cPlanCob, cStsPoliza, cMotivAnul, cNumPolUnico
                   FROM SINIESTRO  SNT,POLIZAS P, DETALLE_POLIZA DP
                  WHERE SNT.IDSINIESTRO =  W_IDSINIESTRO AND P.CodCia    = SNT.CodCia AND P.IdPoliza  = SNT.IdPoliza
                    AND P.StsPoliza IN ('REN','EMI') AND DP.CODCIA   = SNT.CodCia AND DP.IDPOLIZA = SNT.IdPoliza
                    AND DP.IDETPOL  = SNT.IDetPol; 
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    cCargaRegistro := 'N';
                    cMsgArchErr    := 'No hay datos';
              END;
        END;
        cCodEmpresa    := P_CODEMPRESA;            
        cRegDatosProc  := cLinea;
      END IF;
      IF PasasManito > 0 THEN
         cCargaRegistro := cCargaRegistro;
      ELSE 
         cCargaRegistro := 'N'; 
      END IF;  
   ELSIF P_TIPOPROCESO IN ('SINAJU','SINRPA' ) THEN
      cCodEmpresa    := P_CODEMPRESA;
      cIdTipoSeg     := OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,3,',');
      cPlanCob       := OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,4,',');
      cRegDatosProc  := cLinea;
      cCargaRegistro := 'S';
      cNumPolUnico  := OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,1,',');
      cNumDetUnico  := OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,2,','); 
   ELSIF P_TIPOPROCESO = 'SIAJRE' THEN
      cIdTipoSeg     := OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,1,',');
      cPlanCob       := OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,3,',');
      cNumPolUnico   := OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,7,',');
      cNumDetUnico   := OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,8,',');
      cCodEmpresa    := P_CODEMPRESA;
      cRegDatosProc  := cLinea;
      cCargaRegistro := 'S';
   ELSIF P_TIPOPROCESO = 'SIAJPA' THEN      
      cIdTipoSeg     := OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,1,',');
      cPlanCob       := OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,5,',');
      cNumPolUnico   := OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,2,',');
      cNumDetUnico   := OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,4,',');
      cCodEmpresa    := P_CODEMPRESA;
      cRegDatosProc  := cLinea;
      cCargaRegistro := 'S';
   ELSIF P_TIPOPROCESO = 'ANUPGO' THEN      
      NumRegistro :=  NumRegistro + 1;
      W_IDSINIESTRO:= TO_NUMBER(TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,1,',')));
      W_POLIZA     := TO_NUMBER(TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,2,',')));
      W_PROCESOS   := OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,3,',');
      W_CODASEG    := TO_NUMBER(TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,4,',')));
      W_NUMAPROB   := OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,5,',');
      W_MONTO      := OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,6,',');
      PasasManito  := 1;        
      IF P_TIPOPROCESO = W_PROCESOS THEN
         NULL;         
      ELSE     
         W_LINEA_REPORTE := 'Error al cargar Siniestro:  '||W_IDSINIESTRO||'  El proceso elegido ( '||
                            P_TIPOPROCESO||' ) no es igual al del LayOut ( '||W_PROCESOS||' ) . Registro # '||NumRegistro;
         PasasManito  := 0;
         cCargaRegistro := 'N';
      END IF;
      IF W_IDSINIESTRO  IS NULL THEN   
         W_LINEA_REPORTE := 'Error al cargar Archivo. El proceso elegido ( '||P_TIPOPROCESO||' ) no tiene el Numero de Siniestro.  Registro # '||NumRegistro ;
         PasasManito  := 0;
         cCargaRegistro := 'N';
      END IF;
      IF W_POLIZA IS NULL THEN             
         W_LINEA_REPORTE := 'Error al cargar Archivo. El proceso elegido ( '||P_TIPOPROCESO||' ) no tiene el Numero de Póliza.  Registro # '||NumRegistro ;
         PasasManito    := 0;
         cCargaRegistro := 'N';
      END IF;
      IF W_CODASEG IS NULL THEN              
         W_LINEA_REPORTE := 'Error al cargar Archivo. El proceso elegido ( '||P_TIPOPROCESO||' ) no tiene el Numero de Asegurado.  Registro # '||NumRegistro ;
         PasasManito  := 0;
         cCargaRegistro := 'N';
      END IF;
      IF W_NUMAPROB IS NULL THEN             
         W_LINEA_REPORTE := 'Error al cargar Archivo. El proceso elegido ( '||P_TIPOPROCESO||' ) no tiene el Numero de Aprobación.  Registro # '||NumRegistro ;
         PasasManito  := 0;
         cCargaRegistro := 'N';
      END IF;
      BEGIN
         SELECT P.IdPoliza, DP.IDetPol, DP.IdTipoSeg, Dp.PlanCob, P.StsPoliza, P.MotivAnul,P.NumPolUnico
           INTO nIdPoliza, cNumDetUnico, cIdTipoSeg, cPlanCob, cStsPoliza, cMotivAnul ,cNumPolUnico
           FROM SINIESTRO SNT, POLIZAS P, DETALLE_POLIZA DP
          WHERE SNT.IdSiniestro =  W_IdSiniestro AND P.CodCia    = SNT.CodCia AND P.IdPoliza  = SNT.IdPoliza
            AND P.StsPoliza IN ('REN','EMI','ANU') AND DP.CODCIA   = SNT.CodCia AND DP.IdPoliza = SNT.IdPoliza
            AND DP.IDETPOL  = SNT.IDetPol;     
         cCargaRegistro := 'S';
         cRegDatosProc  := cLinea;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cCargaRegistro := 'N';
            cMsgArchErr := 'No hay datos';
         WHEN TOO_MANY_ROWS THEN
            cCargaRegistro := 'S';
            cRegDatosProc  := cLinea;
            BEGIN
               SELECT P.IdPoliza, DP.IDetPol, DP.IdTipoSeg, Dp.PlanCob, P.StsPoliza, P.MotivAnul,P.NumPolUnico
                 INTO nIdPoliza, cNumDetUnico, cIdTipoSeg, cPlanCob, cStsPoliza, cMotivAnul, cNumPolUnico
                 FROM SINIESTRO  SNT,POLIZAS P, DETALLE_POLIZA DP
                WHERE SNT.IdSiniestro =  W_IdSiniestro AND P.CodCia    = SNT.CodCia AND P.IdPoliza  = SNT.IdPoliza
                  AND P.StsPoliza IN ('REN','EMI') AND DP.CodCia   = SNT.CodCia AND DP.IdPoliza = SNT.IdPoliza
                  AND DP.IDetPol  = SNT.IDetPol; 
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  cCargaRegistro := 'N';
                  cMsgArchErr := 'No hay datos';
            END;
      END;
      IF PasasManito > 0 THEN
         SELECT UNIQUE(DP1.PLANCOB)
           INTO PlanDeCobro
           FROM DETALLE_POLIZA DP1
          WHERE DP1.IDPOLIZA = W_POLIZA; 
          IF PlanDeCobro = 'INFONACOT' THEN 
             nINDPOLCOL := 'N';          
          ELSE
            BEGIN 
              SELECT DECODE( VL.DESCVALLST,'INDIVIDUAL','N','S') 
              INTO nINDPOLCOL
              FROM POLIZAS P, DETALLE_POLIZA DP, PLAN_COBERTURAS PC, VALORES_DE_LISTAS VL
              WHERE P.IdPoliza    = W_POLIZA
              AND DP.IdPoliza   = P.IdPoliza
              AND DP.IDetPol    = 1 
              AND PC.CodCia     = DP.CodCia
              AND PC.CodEmpresa = DP.CodEmpresa
              AND PC.IdTipoSeg  = DP.IdTipoSeg
              AND PC.PlanCob    = DP.PlanCob
              AND VL.CODLISTA   = 'TIPORAMO'
              AND VL.CODVALOR   = PC.CodTipoPlan;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                nINDPOLCOL :=NULL;
              WHEN OTHERS  THEN
                nINDPOLCOL :=NULL;
            END;           
          END IF; 
          cCargaRegistro := 'S';
          cRegDatosProc  := cLinea;                              
          cCodEmpresa    := '1';            
      END IF;
      IF PasasManito > 0 THEN
          cCargaRegistro := cCargaRegistro;
      ELSE 
          cCargaRegistro := 'N';  
      END IF; 
   ELSIF P_TIPOPROCESO = 'PAGTES' THEN
      W_IDCARGA     := TO_NUMBER(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,1,','));
      W_POLCONTA_GG := OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,2,',');
      W_FECHA_PAGO  := TO_DATE(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,3,','),'DD/MM/YYYY');
      W_IMPORT_PAGO := TO_NUMBER(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cLinea,4,','));
      PasasManito  := 1;            
      IF W_IDCARGA IS NULL THEN    
         W_LINEA_REPORTE := 'Error al cargar.Campo   IDCarga viene nulo. ';
         PasasManito  := 0;
         cCargaRegistro := 'N';       
      ELSIF W_POLCONTA_GG IS NULL THEN     
         W_LINEA_REPORTE := 'Error al cargar.Campo   Poliza Contable viene nulo.  IDCarga: '||W_IDCARGA;
         PasasManito  := 0;
         cCargaRegistro := 'N';                 
      ELSIF W_FECHA_PAGO IS NULL THEN    
         W_LINEA_REPORTE := 'Error al cargar.Campo   Fecha de Pago viene nulo.  IDCarga: '||W_IDCARGA;
         PasasManito  := 0;
         cCargaRegistro := 'N';         
      ELSIF W_IMPORT_PAGO IS NULL THEN     
         W_LINEA_REPORTE := 'Error al cargar.Campo   IMPORT_PAGO viene nulo.  IDCarga: '||W_IDCARGA;
         PasasManito  := 0;
         cCargaRegistro := 'N';                 
      END IF;
      SELECT COUNT(*)
        INTO HABEMUSPAGUS  --   nNombreArchivo
        FROM PROCESOS_MASIVOS_SEGUIMIENTO S
       WHERE S.IDPROCMASIVO    = W_IDCARGA ---3774959
         AND S.IDSINIESTRO IS NOT NULL
         AND S.EMI_TIPOPROCESO = 'PAGSIN'
         AND S.POLCONTA_GG IS NULL;

      IF HABEMUSPAGUS = 1 THEN
        BEGIN
          SELECT SA.IDSINIESTRO
            INTO W_IDSINIESTRO
            FROM PROCESOS_MASIVOS_SEGUIMIENTO SA
           WHERE SA.IDPROCMASIVO    = W_IDCARGA ---3774959
             AND SA.EMI_TIPOPROCESO = 'PAGSIN'
             AND SA.IDSINIESTRO IS NOT NULL
             AND SA.POLCONTA_GG IS NULL; 
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              W_LINEA_REPORTE := 'No hay datos del numero de Siniestro para el  IDCarga: '||W_IDCARGA||'. No procede';
              PasasManito  := 0;
              cCargaRegistro := 'N';  
           WHEN OTHERS THEN
              W_LINEA_REPORTE := 'Error en busqueda del numero de Siniestro para el  IDCarga: '||W_IDCARGA||'. No procede';
              PasasManito  := 0;
              cCargaRegistro := 'N';  
        END;
      ELSIF HABEMUSPAGUS = 0 THEN
         W_LINEA_REPORTE := 'Error al cargar.El IDCarga: '||W_IDCARGA||' ya fue actualizado antes. No puede ser actualizado mas de Una Vez. ';
         PasasManito  := 0;
         cCargaRegistro := 'N';
      ELSIF HABEMUSPAGUS > 1 THEN
         W_LINEA_REPORTE :=  'Error al cargar.El IDCarga: '||W_IDCARGA||' existe mas de 1 vez. Revisar con el equipo de Tecnologías de la Información. ';
         PasasManito  := 0;
         cCargaRegistro := 'N';                
      END IF;     
      IF PasasManito > 0 THEN
        BEGIN
          SELECT P.IdPoliza, DP.IDetPol, DP.IdTipoSeg, Dp.PlanCob, P.StsPoliza, P.MotivAnul,P.NUMPOLUNICO
            INTO nIdPoliza, cNumDetUnico, cIdTipoSeg, cPlanCob, cStsPoliza, cMotivAnul ,cNumPolUnico
            FROM SINIESTRO SNT, POLIZAS P, DETALLE_POLIZA DP
           WHERE SNT.IDSINIESTRO =  W_IDSINIESTRO
             AND P.CodCia    = SNT.CodCia
             AND P.IdPoliza  = SNT.IdPoliza
             AND P.StsPoliza IN ('REN','EMI','ANU')
             AND DP.CodCia   = SNT.CodCia
             AND DP.IdPoliza = SNT.IdPoliza
             AND DP.IDetPol  = SNT.IDetPol;      
          cCargaRegistro := 'S';
          cRegDatosProc  := cLinea;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              cCargaRegistro := 'N';
              cMsgArchErr := 'No hay datos';
           WHEN TOO_MANY_ROWS THEN
              cCargaRegistro := 'S';
              cRegDatosProc  := cLinea;
              BEGIN
                 SELECT P.IdPoliza, DP.IDetPol, DP.IdTipoSeg, Dp.PlanCob, P.StsPoliza, P.MotivAnul,P.NUMPOLUNICO
                   INTO nIdPoliza, cNumDetUnico, cIdTipoSeg, cPlanCob, cStsPoliza, cMotivAnul, cNumPolUnico
                   FROM SINIESTRO  SNT,POLIZAS P, DETALLE_POLIZA DP
                  WHERE SNT.IDSINIESTRO =  W_IDSINIESTRO
                    AND P.CodCia    = SNT.CodCia
                    AND P.IdPoliza  = SNT.IdPoliza
                    AND P.StsPoliza IN ('REN','EMI')
                    AND DP.CodCia   = SNT.CodCia
                    AND DP.IdPoliza = SNT.IdPoliza
                    AND DP.IDetPol  = SNT.IDetPol; 
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    cCargaRegistro := 'N';
                    cMsgArchErr    := 'No hay datos';
              END;
        END;
        cCodEmpresa    := P_CODEMPRESA;            
        cRegDatosProc  := cLinea;            
      END IF;
      IF PasasManito > 0 THEN
         cCargaRegistro := cCargaRegistro;
      ELSE 
         cCargaRegistro := 'N';  
      END IF;  
   END IF;

   IF cCargaRegistro = 'S' THEN
      nIdProcMasivo := OC_PROCESOS_MAS_SINI.CREAR(P_CODCIA, TO_NUMBER(TRIM(cCodEmpresa)));
      cRegDatosProc := CAMBIA_CARACTERES(cRegDatosProc);
      BEGIN
         INSERT INTO PROCESOS_MASIVOS
               (IdProcMasivo, CodCia, CodEmpresa, IdTipoSeg, PlanCob, TipoProceso, StsRegProceso, FecSts, RegDatosProc, NumPolUnico, NumDetUnico, IndColectiva, IndAsegurado, CodUsuario, NomArchivoCarga, IndRegValidado, IndArchValidado)
         VALUES(nIdProcMasivo, P_CODCIA, TO_NUMBER(cCodEmpresa), cIdTipoSeg, cPlanCob, P_TIPOPROCESO, 'XPROC', SYSDATE, cRegDatosProc, cNumPolUnico, cNumDetUnico, 'N', 'N', P_CODUSUARIO, nNombreArchivo, 'N', 'N');
         cConteoCarga := cConteoCarga + 1;
         COMMIT;
        --
         W_TI_LEIDOS := W_TI_LEIDOS + 1;
        --
        --:P33_TI_LEIDOS   := W_TI_LEIDOS;
      EXCEPTION
         WHEN OTHERS THEN
            raise_application_error(-20105,'Error al Insertar Procesos_Masivos: '||SQLERRM);
      END;
      IF P_TIPOPROCESO = 'PAGTES' THEN 
        BEGIN 
           UPDATE PROCESOS_MASIVOS_SEGUIMIENTO ST
              SET ST.ARCHIVO_GG      = nNombreArchivo
            WHERE ST.IDPROCMASIVO    = W_IDCARGA 
              AND ST.EMI_TIPOPROCESO = 'PAGSIN'
              AND ST.IDSINIESTRO IS NOT NULL
              AND ST.POLCONTA_GG IS NULL; 
        EXCEPTION
           WHEN OTHERS  THEN
              raise_application_error(-20105,'Error al Actualizar Procesos_Masivos_Seguimiento: '||SQLERRM);
        END;
      ELSIF P_TIPOPROCESO IN ('AURVAD', 'DIRVAD', 'ANUPGO' ) THEN
         BEGIN 
           INSERT INTO PROCESOS_MASIVOS_SEGUIMIENTO
                      (IDPROCMASIVO, CODCIA, CODEMPRESA, CRGA_COD_PROCESO, CRGA_DESCPROCESO,CRGA_NOM_ARCHIVO, CRGA_REGDATOSPROC, CRGA_STS, CRGA_USUARIO, CRGA_TERMINAL,CRGA_FECHA, CRGA_FECHACOMP, INDPOLCOL)
                VALUES(nIdProcMasivo, P_CODCIA, P_CODEMPRESA, P_TIPOPROCESO, P_DESC_TPO_PROC,nNombreArchivo, cRegDatosProc, 'XPROC', P_CODUSUARIO, P_TERMINAL,TRUNC(SYSDATE), SYSDATE, nINDPOLCOL);
         EXCEPTION
            WHEN OTHERS  THEN
               raise_application_error(-20105,'Error al Insertar Procesos_Masivos: '||SQLERRM);
         END;       
      ELSIF P_TIPOPROCESO IN ('ESTSIN', 'PAGSIN', 'MODSIN', 'SINRVA') THEN
         BEGIN 
           INSERT INTO PROCESOS_MASIVOS_SEGUIMIENTO
                      (IDPROCMASIVO, CODCIA, CODEMPRESA, CRGA_COD_PROCESO, CRGA_DESCPROCESO,CRGA_NOM_ARCHIVO, CRGA_REGDATOSPROC, CRGA_STS, CRGA_USUARIO, CRGA_TERMINAL,CRGA_FECHA, CRGA_FECHACOMP)
                VALUES(nIdProcMasivo, P_CODCIA, P_CODEMPRESA, P_TIPOPROCESO, P_DESC_TPO_PROC,nNombreArchivo, cRegDatosProc, 'XPROC', P_CODUSUARIO, P_TERMINAL,TRUNC(SYSDATE), SYSDATE);
         EXCEPTION
            WHEN OTHERS  THEN
               raise_application_error(-20105,'Error al Insertar Procesos_Masivos: '||SQLERRM);
         END;
         --STANDARD.COMMIT; --MLJS 19/06/2025
         COMMIT;            --MLJS 19/06/2025
      END IF;
   ELSE
      IF NVEZE = 0 THEN
         NLINEA:=1;
         l_id := F_NUEVA_EXTRACCION('ERROR_CARGA',P_CODUSUARIO,'ERROR CARGA_'||to_char(sysdate,'dd_mm_yyyy hh24:mi:ss')||'.txt','TXT');
         OC_ARCHIVO.Escribir_Linea(' ', P_CODUSUARIO, nLinea);
         NVEZE:=1;
      END IF;
      nLinea := nLinea + 1;
      OC_ARCHIVO.Escribir_Linea(cLinea||'-->'||cMsgArchErr, P_CODUSUARIO, nLinea);
      P_NLINEA := nLinea;
      P_MENSAJE:= cMsgArchErr;
      COMMIT;
   END IF;
END SP_CARGA_ARCHIVO;
--- MLJS 18/06/2025-23/06/2025 FUNCIONES PARA LA CARGA MASIVA DE PAGOS DE SINIESTRO 
END OC_PROCESOS_MAS_SINI;
/
