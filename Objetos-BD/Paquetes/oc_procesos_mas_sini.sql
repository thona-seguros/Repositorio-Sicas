--
-- OC_PROCESOS_MAS_SINI  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_OUTPUT (Synonym)
--   DBMS_STANDARD (Package)
--   POLIZAS (Table)
--   PROCESOS_MASIVOS (Table)
--   PROCESOS_MASIVOS_LOG (Table)
--   DATOS_PART_SINIESTROS (Table)
--   DETALLE_APROBACION (Table)
--   DETALLE_APROBACION_ASEG (Table)
--   DETALLE_POLIZA (Table)
--   DETALLE_SINIESTRO (Table)
--   DETALLE_SINIESTRO_ASEG (Table)
--   OC_DDL_OBJETOS (Package)
--   APROBACIONES (Table)
--   APROBACION_ASEG (Table)
--   ASEGURADO (Table)
--   BENEF_SIN (Table)
--   INFO_ALTBAJ (Table)
--   INFO_SINIESTRO (Table)
--   TRANSACCION (Table)
--   OC_PROCESOS_MASIVOS (Package)
--   OC_PROCESOS_MASIVOS_LOG (Package)
--   OC_SINIESTRO (Package)
--   SINIESTRO (Table)
--   COMPROBANTES_CONTABLES (Table)
--   COMPROBANTES_DETALLE (Table)
--   CONFIG_PLANTILLAS_CAMPOS (Table)
--   CONFIG_PLANTILLAS_PLANCOB (Table)
--   CATALOGO_DE_CONCEPTOS (Table)
--   CLIENTES (Table)
--   CLIENTE_ASEG (Table)
--   COBERTURA_SINIESTRO (Table)
--   COBERTURA_SINIESTRO_ASEG (Table)
--   COBERT_ACT (Table)
--   COBERT_ACT_ASEG (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--   OBSERVACION_SINIESTRO (Table)
--   OC_APROBACIONES (Package)
--   OC_APROBACION_ASEG (Package)
--   OC_CATALOGO_DE_CONCEPTOS (Package)
--   OC_COBERTURA_SINIESTRO (Package)
--   OC_COBERTURA_SINIESTRO_ASEG (Package)
--   OC_CONFIG_PLANTILLAS_PLANCOB (Package)
--   OC_GENERALES (Package)
--   OC_OBSERVACION_SINIESTRO (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_PROCESOS_MAS_SINI IS
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
PROCEDURE SINIESTROS_AJUSTES(nIdProcMasivo NUMBER);         --AJUSTES INI
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
PROCEDURE MARCA_NO_ENVIO_CONTABILIDAD(nIDTRANSACCION NUMBER, nCodCia NUMBER, DFECHA DATE); --AJUSTES FIN
--
PROCEDURE ACTUALIZA_PAGOS(nIdPoliza NUMBER,   nIdSiniestro  NUMBER,   NIDDETSIN     NUMBER,   cCodCobert   VARCHAR2, 
                          DFECHA    DATE,     nAJUSTELOCAL  NUMBER,   nAJUSTEMONEDA NUMBER,   cID_COL_INDI VARCHAR);
                          --
END OC_PROCESOS_MAS_SINI;
/

--
-- OC_PROCESOS_MAS_SINI  (Package Body) 
--
--  Dependencies: 
--   OC_PROCESOS_MAS_SINI (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_PROCESOS_MAS_SINI IS
--
--  28/02/2017  Rutina para constituir solo reserva en INFONACOT                                 -- JICO ASEGMAS 
--  07/08/2018  Ajuste para cambio especial                                                      -- JICO INFO2
--  17/08/2018  Devolucion de pagos de INFONACOT                                                 -- JICO ANUPAG
--  30/04/2019  Disminucion de reserva                                                           -- JICO AJUSTES

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
      OC_PROCESOS_MAS_SINI.SINIESTROS_AJUSTES(nIdProcMasivo);    -- CONSTITUYE RESERVA  --AJUSTES
      OC_PROCESOS_MAS_SINI.SINIESTROS_PAGOS_RVA(nIdProcMasivo);  -- GENERA PAGO         --AJUSTES
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
       cObservacion := 'Error, el Tipo de Cobertura no es v�lido.';
       RAISE_APPLICATION_ERROR(-20225,'Error, el Tipo de Cobertura no es v�lido.');
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
           cObservacion := 'Error al Insertar la Obervaci�n 1, Favor de validar la informaci�n.';
           RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Obervaci�n 2, Favor de validar la informaci�n, Error: '||SQLERRM);
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
           RAISE_APPLICATION_ERROR(-20225,'DETALLE SINIESTRO (Cero Sini) - Ocurri� el siguiente error: '||SQLERRM);
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
              RAISE_APPLICATION_ERROR(-20225,'COBERTURA SINIESTRO (Cero Sini) - Ocurri� el siguiente error: '||SQLERRM);
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
           cObservacion := 'Error al Insertar la Obervaci�n 3, Favor de validar la informaci�n.';
           RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Obervaci�n 4, Favor de validar la informaci�n, Error: '||SQLERRM);
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
              RAISE_APPLICATION_ERROR(-20225,'COBERTURA SINIESTRO (Cero Sini) - Ocurri� el siguiente error: '||SQLERRM);
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
        cObservacion := 'Error al Insertar la Observaci�n , Favor de validar la informaci�n.';
        RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Observaci�n , Favor de validar la informaci�n, Error: '||SQLERRM);
    END;
    --
    BEGIN
      nNum_Aprobacion := OC_APROBACIONES.INSERTA_APROBACION(nIdSiniestro, nIdPoliza, nEstimacionLocal,
                                                            nEstimacionMoneda, cTipoAprobacion, 'APR', NULL);
    EXCEPTION
      WHEN OTHERS THEN
        nCodError := 99;
        cObservacion := 'Error al Insertar la Aprobaci�n.';
        RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Aprobaci�n: '|| nIdSiniestro || ' ' || SQLERRM);
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
        cObservacion := 'Insertar en DETALLE APROBACION - Ocurri� el siguiente error.';
        RAISE_APPLICATION_ERROR(-20225,'Insertar en DETALLE APROBACION - Ocurri� el siguiente error: '||SQLERRM);
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
        cObservacion := 'Error al Actualizar la Aprobaci�n Aseg con el Beneficiario.';
        RAISE_APPLICATION_ERROR(-20225,'Error al Actualizar la Aprobaci�n Aseg con el Beneficiario '|| cNumSiniRef || ' ' || SQLERRM);
    END;
    --
    BEGIN
      OC_APROBACIONES.PAGAR(X.CodCia, X.CodEmpresa, nNum_Aprobacion, nIdSiniestro, nIdPoliza, 1);
    EXCEPTION
      WHEN OTHERS THEN
        nCodError := 99;
        cObservacion := 'Error al Pagar la Aprobaci�n del Siniestro.';
        RAISE_APPLICATION_ERROR(-20225,'Error al Pagar la Aprobaci�n del Siniestro: '|| nIdSiniestro || ' ' || SQLERRM);
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
cCodProvOcurr          SINIESTRO.CodProvOcurr%TYPE := '009'; -- No est�n mandando la direccion del Trabajador, por lo que por default es D.F.
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
        cObservacion := 'Codigo Error 22: No est� reportado en los listados.';
        RAISE_APPLICATION_ERROR(-20225,'Codigo Error 22: No est� reportado en los listados.');
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
        cObservacion := 'Codigo Error 22: No est� reportado en los listados.';
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
       cObservacion := 'Error, el Tipo de Cobertura no es v�lido.';
       RAISE_APPLICATION_ERROR(-20225,'Error, el Tipo de Cobertura no es v�lido.');
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
           cObservacion := 'Error al Insertar la Obervaci�n 1, Favor de validar la informaci�n.';
           RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Obervaci�n 2, Favor de validar la informaci�n, Error: '||SQLERRM);
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
           RAISE_APPLICATION_ERROR(-20225,'DETALLE SINIESTRO (Cero Sini) - Ocurri� el siguiente error: '||SQLERRM);
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
              RAISE_APPLICATION_ERROR(-20225,'COBERTURA SINIESTRO (Cero Sini) - Ocurri� el siguiente error: '||SQLERRM);
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
           cObservacion := 'Error al Insertar la Obervaci�n 3, Favor de validar la informaci�n.';
           RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Obervaci�n 4, Favor de validar la informaci�n, Error: '||SQLERRM);
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
              RAISE_APPLICATION_ERROR(-20225,'COBERTURA SINIESTRO (Cero Sini) - Ocurri� el siguiente error: '||SQLERRM);
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
             IF WSALDO_RESERVA >= nAJUSTEMONEDA THEN
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
             ELSE
                nCodError := 99;
                cObservacion := 'LA RESERVA ES INSUFICIENTE PARA ESTE AJUSTE. ';
                RAISE_APPLICATION_ERROR(-20225,'LA RESERVA '||WSALDO_RESERVA||' ES INSUFICIENTE PARA EL AJUSTE '||nAJUSTEMONEDA||'  '||SQLERRM);
             END IF;
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
             IF WSALDO_RESERVA >= nAJUSTEMONEDA THEN
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
             ELSE
                nCodError := 99;
                cObservacion := 'LA RESERVA ES INSUFICIENTE PARA ESTE AJUSTE. ';
                RAISE_APPLICATION_ERROR(-20225,'LA RESERVA '||WSALDO_RESERVA||' ES INSUFICIENTE PARA EL AJUSTE '||nAJUSTEMONEDA||'  '||SQLERRM);
             END IF;
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
cDOCTO                 BENEF_SIN.TIPO_ID_TRIBUTARIO%TYPE  := 'RFC';
cRFC                   BENEF_SIN.NUM_DOC_TRIBUTARIO%TYPE;
nCUENTA_CLAVE	         BENEF_SIN.NUMCUENTABANCARIA%TYPE;
cID_BANCO              BENEF_SIN.ENT_FINANCIERA%TYPE;
WEXISTE_BENEF          NUMBER  := 0;
cID_APLICA_IVA         VARCHAR2(1);
nIVA_AJUSTEMONEDA      NUMBER(28,2);
nIVA_AJUSTELOCAL       NUMBER(28,2);
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
    nIdSiniestro     := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,1,',')));
    cCodCobert       :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,2,','));
    WCODTRANSAC      :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,3,','));
    WCODCPTOTRANSAC  :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,4,','));
    nAJUSTEMONEDA    := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,5,',')));
    WFECHA           :=   TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,',')),'dd/mm/yyyy');
    WID_COL_INDI     :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,7,','));
    WID_APLICA_CONTA :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,8,','));
    cDescSiniestro   :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,9,','));
    nCod_Asegurado   := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,10,',')));
    cNOMBRE_BENEF    :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,11,','));
    cAPE_PAT_BENEF   :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,12,','));
    cAPE_MAT_BENEF   :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,13,','));
    nPORC_PART       := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,14,',')));
    nID_PARENTESCO   :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,15,','));
    cID_SEXO         :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,16,','));
    cRFC             :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,17,','));
    nCUENTA_CLAVE    :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,18,','));
    cID_BANCO        :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,19,','));
    cID_APLICA_IVA   :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,20,','));
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
           cObservacion := 'Error al Insertar la Aprobaci�n.';
           RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Aprobaci�n: '|| nIdSiniestro || ' ' || SQLERRM);
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
       SELECT COUNT(*)
         INTO WEXISTE_BENEF
         FROM BENEF_SIN BS
        WHERE BS.IDSINIESTRO   = nIdSiniestro
          AND BS.IDPOLIZA      = nIdPoliza
          AND BS.COD_ASEGURADO = nCod_Asegurado;
       --
       IF WEXISTE_BENEF = 0 THEN
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
          BEGIN
            SELECT BS.BENEF
              INTO nBENEF
              FROM BENEF_SIN BS
             WHERE BS.IDSINIESTRO   = nIdSiniestro
               AND BS.IDPOLIZA      = nIdPoliza
               AND BS.COD_ASEGURADO = nCod_Asegurado;
          EXCEPTION
            WHEN OTHERS THEN
                 nCodError := 99;
                 cObservacion := 'Error al extraer beneficiarios';
                 RAISE_APPLICATION_ERROR(-20225,'Error al extraer beneficiarios error: '||SQLERRM);
          END;
       END IF;
       --
       IF WEXISTE_BENEF = 0 THEN
          BEGIN
            INSERT INTO BENEF_SIN
               (IdSiniestro,         IdPoliza,         Cod_Asegurado,          Benef, 
                Nombre,              Apellido_Paterno, Apellido_Materno,       PorcePart,
                CodParent,           Estado,           Sexo,                   FecEstado, 
                FecAlta,             Obervaciones,     
                IndAplicaISR,        PorcentISR,       Ent_Financiera,         Cuenta_Clave,
                TIPO_ID_TRIBUTARIO,  NUM_DOC_TRIBUTARIO)
            VALUES(nIdSiniestro,     nIdPoliza,        nCod_Asegurado,         nBENEF, 
                cNOMBRE_BENEF,       cAPE_PAT_BENEF,   cAPE_MAT_BENEF,         nPORC_PART,
                nID_PARENTESCO,      'ACT',            cID_SEXO,               TRUNC(SYSDATE),
                TRUNC(SYSDATE),      'Pago por el Siniestro No. '||nIdSiniestro||' - '||cNumSiniRef,
                'N',                 Null,             cID_BANCO,               nCUENTA_CLAVE,
                cDOCTO,              cRFC);
          EXCEPTION
            WHEN OTHERS THEN
                 nCodError := 99;
                 cObservacion := 'Error al Insertar Beneficiario de Pago.';
                 RAISE_APPLICATION_ERROR(-20225,'Error al Insertar Beneficiario de Pago '|| cNumSiniRef || ' ' || SQLERRM);
          END;
       ELSE
          nBENEF := WEXISTE_BENEF;
       END IF;
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
              cObservacion := 'Error al Actualizar la Aprobaci�n Aseg con el Beneficiario.';
              RAISE_APPLICATION_ERROR(-20225,'Error al Actualizar la Aprobaci�n Aseg con el Beneficiario '|| cNumSiniRef || ' ' || SQLERRM);
       END;
       --
       BEGIN
         OC_APROBACIONES.PAGAR(X.CodCia, X.CodEmpresa, nNum_Aprobacion, nIdSiniestro, nIdPoliza, 1);
       EXCEPTION
         WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'Error al Pagar la Aprobaci�n del Siniestro.';
              RAISE_APPLICATION_ERROR(-20225,'Error al Pagar la Aprobaci�n del Siniestro: '|| nIdSiniestro || ' ' || SQLERRM);
       END;
       --
       ACTUALIZA_PAGOS(nIdPoliza , nIdSiniestro, NIDDETSIN, cCodCobert , DFECHA , nAJUSTELOCAL , nAJUSTEMONEDA ,  WID_COL_INDI);
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
           cObservacion := 'Error al Insertar la Aprobaci�n.';
           RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Aprobaci�n: '|| nIdSiniestro || ' ' || SQLERRM);
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
       --
       SELECT COUNT(*)
         INTO WEXISTE_BENEF
         FROM BENEF_SIN BS
        WHERE BS.IDSINIESTRO   = nIdSiniestro
          AND BS.IDPOLIZA      = nIdPoliza
          AND BS.COD_ASEGURADO = nCod_Asegurado;
       --
       IF WEXISTE_BENEF = 0 THEN
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
          IF nBENEF IS NULL THEN
             nBENEF := 1;
          END IF;
       ELSE
          BEGIN
            SELECT BS.BENEF
              INTO nBENEF
              FROM BENEF_SIN BS
             WHERE BS.IDSINIESTRO   = nIdSiniestro
               AND BS.IDPOLIZA      = nIdPoliza
               AND BS.COD_ASEGURADO = nCod_Asegurado;
          EXCEPTION
            WHEN OTHERS THEN
                 nCodError := 99;
                 cObservacion := 'Error al extraer beneficiarios';
                 RAISE_APPLICATION_ERROR(-20225,'Error al extraer beneficiarios error: '||SQLERRM);
          END;
       END IF;
       --
       IF WEXISTE_BENEF = 0 THEN
          BEGIN
            INSERT INTO BENEF_SIN
               (IdSiniestro,         IdPoliza,         Cod_Asegurado,          Benef, 
                Nombre,              Apellido_Paterno, Apellido_Materno,       PorcePart,
                CodParent,           Estado,           Sexo,                   FecEstado, 
                FecAlta,             Obervaciones,     
                IndAplicaISR,        PorcentISR,       Ent_Financiera,         Cuenta_Clave,
                TIPO_ID_TRIBUTARIO,  NUM_DOC_TRIBUTARIO)
            VALUES(nIdSiniestro,     nIdPoliza,        nCod_Asegurado,         nBENEF, 
                cNOMBRE_BENEF,       cAPE_PAT_BENEF,   cAPE_MAT_BENEF,         nPORC_PART,
                nID_PARENTESCO,      'ACT',            cID_SEXO,               TRUNC(SYSDATE),
                TRUNC(SYSDATE),      'Pago por el Siniestro No. '||nIdSiniestro||' - '||cNumSiniRef,
                'N',                 Null,             cID_BANCO,               nCUENTA_CLAVE,
                cDOCTO,              cRFC);
          EXCEPTION
            WHEN OTHERS THEN
                 nCodError := 99;
                 cObservacion := 'Error al Insertar Beneficiario de Pago.';
                 RAISE_APPLICATION_ERROR(-20225,'Error al Insertar Beneficiario de Pago '|| cNumSiniRef || ' ' || SQLERRM);
          END;
       ELSE
          nBENEF := WEXISTE_BENEF;
       END IF;
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
              cObservacion := 'Error al Actualizar la Aprobaci�n Aseg con el Beneficiario.';
              RAISE_APPLICATION_ERROR(-20225,'Error al Actualizar la Aprobaci�n Aseg con el Beneficiario '|| cNumSiniRef || ' ' || SQLERRM);
       END;
       --
       BEGIN
         OC_APROBACION_ASEG.PAGAR(X.CodCia, X.CodEmpresa, nNum_Aprobacion, nIdSiniestro, nIdPoliza, nCod_Asegurado, 1);
       EXCEPTION
         WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'Error al Pagar la Aprobaci�n aseg del Siniestro.';
              RAISE_APPLICATION_ERROR(-20225,'Error al Pagar la Aprobaci�n aseg del Siniestro: '|| nIdSiniestro || ' ' || SQLERRM);
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
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Comprobante Contable de transacion - '||nIDTRANSACCION);
    WHEN TOO_MANY_ROWS THEn
         RAISE_APPLICATION_ERROR(-20225,'Comprobante Contable Duplicada  de transacion - '||nIDTRANSACCION);
    WHEN OTHERS THEn
         RAISE_APPLICATION_ERROR(-20225,'Comprobante Contable con problemas  de transacion - '||nIDTRANSACCION);
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
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Comprobante Contable de transacion - '||nIDTRANSACCION);
    WHEN TOO_MANY_ROWS THEn
         RAISE_APPLICATION_ERROR(-20225,'Comprobante Contable Duplicada  de transacion - '||nIDTRANSACCION);
    WHEN OTHERS THEn
         RAISE_APPLICATION_ERROR(-20225,'Comprobante Contable con problemas  de transacion - '||nIDTRANSACCION);
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
PROCEDURE ACTUALIZA_PAGOS(nIdPoliza NUMBER,   nIdSiniestro  NUMBER,   NIDDETSIN     NUMBER,   cCodCobert   VARCHAR2, 
                          DFECHA    DATE,     nAJUSTELOCAL  NUMBER,   nAJUSTEMONEDA NUMBER,   cID_COL_INDI VARCHAR) IS 
--
nNUMMOD  COBERTURA_SINIESTRO.NUMMOD%TYPE;
--
BEGIN
  IF cID_COL_INDI = 'I' THEN
     BEGIN
       SELECT MAX(C.NUMMOD)
         INTO nNUMMOD
         FROM COBERTURA_SINIESTRO C
        WHERE C.IDPOLIZA      = nIdPoliza
          AND C.IDSINIESTRO   = nIdSiniestro
          AND C.IDDETSIN      = NIDDETSIN
          AND C.CODCOBERT     = cCodCobert
          AND C.FECRES        = DFECHA;
     EXCEPTION
       WHEN OTHERS THEN
            nNUMMOD := 0;
     END;
     --
     UPDATE COBERTURA_SINIESTRO C
        SET C.MONTO_PAGADO_MONEDA = nAJUSTEMONEDA,
            C.MONTO_PAGADO_LOCAL  = nAJUSTELOCAL,
            C.SALDO_RESERVA       = C.SALDO_RESERVA       - nAJUSTEMONEDA,
            C.SALDO_RESERVA_LOCAL = C.SALDO_RESERVA_LOCAL - nAJUSTELOCAL
      WHERE C.IDPOLIZA    = nIdPoliza
        AND C.IDSINIESTRO = nIdSiniestro
        AND C.IDDETSIN    = NIDDETSIN
        AND C.CODCOBERT   = cCodCobert
        AND C.FECRES      = DFECHA
        AND C.NUMMOD      = nNUMMOD;
     --
     UPDATE DETALLE_SINIESTRO DS
        SET DS.MONTO_PAGADO_MONEDA = DS.MONTO_PAGADO_MONEDA + nAJUSTEMONEDA,
            DS.MONTO_PAGADO_LOCAL  = DS.MONTO_PAGADO_LOCAL  + nAJUSTELOCAL
      WHERE DS.IDSINIESTRO = nIdSiniestro
        AND DS.IDPOLIZA    = nIdPoliza
        AND DS.IDDETSIN    = NIDDETSIN;
     --
  END IF;
  --
  IF cID_COL_INDI = 'C' THEN
     BEGIN
       SELECT MAX(CA.NUMMOD)
         INTO nNUMMOD
         FROM COBERTURA_SINIESTRO_ASEG CA
        WHERE CA.IDPOLIZA      = nIdPoliza
          AND CA.IDSINIESTRO   = nIdSiniestro
          AND CA.IDDETSIN      = NIDDETSIN
          AND CA.CODCOBERT     = cCodCobert
          AND CA.FECRES        = DFECHA;
     EXCEPTION
       WHEN OTHERS THEN
            nNUMMOD := 0;
     END;
     --
     UPDATE COBERTURA_SINIESTRO_ASEG C
        SET C.MONTO_PAGADO_MONEDA = nAJUSTEMONEDA,
            C.MONTO_PAGADO_LOCAL  = nAJUSTELOCAL,
            C.SALDO_RESERVA       = C.SALDO_RESERVA       - nAJUSTEMONEDA,
            C.SALDO_RESERVA_LOCAL = C.SALDO_RESERVA_LOCAL - nAJUSTELOCAL
      WHERE C.IDPOLIZA    = nIdPoliza
        AND C.IDSINIESTRO = nIdSiniestro
        AND C.IDDETSIN    = NIDDETSIN
        AND C.CODCOBERT   = cCodCobert
        AND C.FECRES      = DFECHA
        AND C.NUMMOD      = nNUMMOD;
     -- 
     UPDATE DETALLE_SINIESTRO_ASEG DSA
        SET DSA.MONTO_PAGADO_MONEDA = DSA.MONTO_PAGADO_MONEDA + nAJUSTEMONEDA,
            DSA.MONTO_PAGADO_LOCAL  = DSA.MONTO_PAGADO_LOCAL  + nAJUSTELOCAL
      WHERE DSA.IDSINIESTRO = nIdSiniestro
        AND DSA.IDPOLIZA    = nIdPoliza
        AND DSA.IDDETSIN    = NIDDETSIN;
     --
  END IF;
  --
  UPDATE SINIESTRO S
     SET S.MONTO_PAGO_MONEDA = S.MONTO_PAGO_MONEDA + nAJUSTEMONEDA,
         S.MONTO_PAGO_LOCAL  = S.MONTO_PAGO_LOCAL  + nAJUSTELOCAL;
  --
END ACTUALIZA_PAGOS;  -- AJUSTES FIN--
--
--
--
--
END OC_PROCESOS_MAS_SINI;
/
