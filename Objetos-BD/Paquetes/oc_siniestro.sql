--
-- OC_SINIESTRO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DUAL (Synonym)
--   DBMS_OUTPUT (Synonym)
--   DBMS_STANDARD (Package)
--   OBJETO (Table)
--   SAI_CAT_GENERAL (Table)
--   SINIESTRO (Table)
--   POLIZAS (Table)
--   OC_DETALLE_SINIESTRO (Package)
--   OC_DETALLE_SINIESTRO_ASEG (Package)
--   OC_DETALLE_TRANSACCION (Package)
--   CONFIG_NOMSIN (Table)
--   OC_TRANSACCION (Package)
--   PAGOS_POR_OTROS_CONCEPTOS (Table)
--   PARAMETROS_EMISION (Table)
--   PARAMETROS_ENUM_SIN (Table)
--   ASEGURADO_CERTIFICADO (Table)
--   BENEFICIARIO (Table)
--   BENEF_SIN (Table)
--   CALENDARIO_SEMANAL (Table)
--   COBERTURA_SINIESTRO (Table)
--   COBERTURA_SINIESTRO_ASEG (Table)
--   OC_COBERTURA_SINIESTRO (Package)
--   OC_COBERTURA_SINIESTRO_ASEG (Package)
--   OC_COMPROBANTES_CONTABLES (Package)
--   DETALLE_POLIZA (Table)
--   DETALLE_SINIESTRO (Table)
--   DETALLE_SINIESTRO_ASEG (Table)
--   GT_REA_DISTRIBUCION (Package)
--   TRANSACCION (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_SINIESTRO IS

FUNCTION INSERTA_SINIESTRO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, cNumSiniRef VARCHAR2, 
                           dFec_Ocurrencia DATE, dFec_Notificacion DATE, cDesc_Siniestro VARCHAR2, cTipo_Siniestro VARCHAR2,
                           cMotivo_Siniestro VARCHAR2, cCodPaisOcurr VARCHAR2, cCodProvOcurr VARCHAR2) RETURN NUMBER;

FUNCTION SINIESTRO_DE_ASEGURADO(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdSiniestro NUMBER) RETURN VARCHAR2;

FUNCTION TIENE_SINIESTRO(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, dFecValuacion DATE) RETURN VARCHAR2;

PROCEDURE ANULAR(nCodCia NUMBER, nIdSiniestro NUMBER, dFecAnul DATE, cMotivAnul VARCHAR2);

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSiniestro NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER);

PROCEDURE CERRAR(nCodCia NUMBER, nIdSiniestro NUMBER);

PROCEDURE REABRIR(nCodCia NUMBER, nIdSiniestro NUMBER);

PROCEDURE REVERTIR_ACTIVACION(nCodCia NUMBER, nIdSiniestro NUMBER);

PROCEDURE RECHAZAR (nCodCia NUMBER, nIdSiniestro NUMBER, dFecAnul DATE, cMotivAnul VARCHAR2);

PROCEDURE TRANSACCION_RESERVAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSiniestro NUMBER, 
                               nIdPoliza NUMBER, nIDetPol NUMBER, nIdTransaccion NUMBER);

FUNCTION MONEDA_SINIESTRO(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdSiniestro NUMBER) RETURN VARCHAR2;

FUNCTION F_GET_SIN ( p_msg_regreso    out  nocopy varchar2 ) RETURN NUMBER;

END OC_SINIESTRO;
/

--
-- OC_SINIESTRO  (Package Body) 
--
--  Dependencies: 
--   OC_SINIESTRO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_SINIESTRO IS

FUNCTION INSERTA_SINIESTRO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, cNumSiniRef VARCHAR2, 
                           dFec_Ocurrencia DATE, dFec_Notificacion DATE, cDesc_Siniestro VARCHAR2, cTipo_Siniestro VARCHAR2,
                           cMotivo_Siniestro VARCHAR2, cCodPaisOcurr VARCHAR2, cCodProvOcurr VARCHAR2) RETURN NUMBER IS
nIdSiniestro    SINIESTRO.IdSiniestro%TYPE;
cIdTipoSeg      DETALLE_POLIZA.IdTipoSeg%TYPE;
cPlanCob        DETALLE_POLIZA.PlanCob%TYPE;
nUltAsig        CONFIG_NOMSIN.UltSinAsig%TYPE;
cNumSinNom      SINIESTRO.NumSinNom%TYPE;
cCod_Moneda     POLIZAS.Cod_Moneda%TYPE;
nNumSemana      CALENDARIO_SEMANAL.NumSemana%TYPE;

p_msg_regreso       varchar2(50);


BEGIN
   /*SELECT NVL(MAX(IdSiniestro),0) + 1
     INTO nIdSiniestro
     FROM SINIESTRO
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa;*/

    nIdSiniestro := OC_SINIESTRO.F_GET_SIN(p_msg_regreso); 

   BEGIN
      SELECT IdTipoSeg, PlanCob
        INTO cIdTipoSeg, cPlanCob
        FROM DETALLE_POLIZA
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdPoliza    = nIdPoliza
         AND IdetPol     = nIDetpol;
   EXCEPTION 
      WHEN NO_DATA_FOUND THEn 
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Detalle de Póliza '||SQLERRM);
   END;

   SELECT NVL(MAX(UltSinAsig),0) + 1
     INTO nUltAsig
     FROM CONFIG_NOMSIN
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND IdTipoSeg  = cIdTipoSeg
      AND PlanCob    = cPlanCob
      AND Anio       = TO_CHAR(SYSDATE,'YYYY');

   BEGIN    
      SELECT Nomenclatura || LTRIM(TO_CHAR(nUltAsig,'00000000')) || '-' || Anio
        INTO cNumSinNom
        FROM CONFIG_NOMSIN
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob
         AND Anio       = TO_CHAR(SYSDATE,'YYYY');
   EXCEPTION
      WHEN NO_DATA_FOUND THEN 
         RAISE_APPLICATION_ERROR(-20225,'Se debe configurar Nomenclatura de Siniestros a Nivel de los Planes de Coberturas');
   END;

   SELECT Cod_Moneda
     INTO cCod_Moneda
     FROM POLIZAS
    WHERE IdPoliza   = nIdPoliza
      AND CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa;

   UPDATE CONFIG_NOMSIN
      SET UltSinAsig = UltSinAsig + 1
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND IdTipoSeg  = cIdTipoSeg
      AND PlanCob    = cPlanCob
      AND Anio       = TO_CHAR(SYSDATE,'YYYY');

   BEGIN
      SELECT NumSemana
        INTO nNumSemana
        FROM CALENDARIO_SEMANAL
       WHERE dFec_Notificacion BETWEEN FecIniSemana AND FecFinSemana;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN 
         RAISE_APPLICATION_ERROR(-20225,'Revise Configuración de Semanas, ya que NO se a encontrado una semana Configurada' ||
                                 ' para la Fecha de Notificacion ' || TO_CHAR(dFec_Notificacion,'DD/MM/YYYY'));
   END;

   INSERT INTO SINIESTRO
          (IdSiniestro, IdPoliza, NumSiniRef, Tipo_Siniestro, Fec_Ocurrencia, Fec_Notificacion,
           Sts_Siniestro, FecSts, FecAnul, Motiv_Anul, Desc_Siniestro, Monto_Reserva_Local,
           Monto_Reserva_Moneda, Monto_Pago_Local, Monto_Pago_Moneda, Cod_Moneda, IDetPol,
           Num_Bien, Monto_Indeminzacion, Deducible, Tipo_Indemnizacion, Ajustador, CodCia,
           Motivo_de_Siniestro, CodEmpresa, NumSinNom, NumSemana, CodPaisOcurr, CodProvOcurr)
   VALUES (nIdSiniestro, nIdPoliza, cNumSiniRef, cTipo_Siniestro, dFec_Ocurrencia, dFec_Notificacion,
           'SOL', TRUNC(SYSDATE), NULL, NULL, cDesc_Siniestro, 0, 0, 0, 0, cCod_Moneda, nIDetPol,
           0, 0, 0, NULL, NULL, nCodCia,
           cMotivo_Siniestro, nCodEmpresa, cNumSinNom, nNumSemana, cCodPaisOcurr, cCodProvOcurr);
   RETURN(nIdSiniestro);
END INSERTA_SINIESTRO;

FUNCTION SINIESTRO_DE_ASEGURADO(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdSiniestro NUMBER) RETURN VARCHAR2 IS
cExiste   VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM DETALLE_SINIESTRO_ASEG
       WHERE IdPoliza    = nIdPoliza
         AND IdSiniestro = nIdSiniestro
       UNION
      SELECT 'S'
        FROM ASEGURADO_CERTIFICADO
       WHERE CodCia      = nCodCIa
         AND IdPoliza    = nIdPoliza
         AND IDetPol     = nIDetPol;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END SINIESTRO_DE_ASEGURADO;

FUNCTION TIENE_SINIESTRO(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, dFecValuacion DATE) RETURN VARCHAR2 IS
cExiste   VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM SINIESTRO
       WHERE CodCia            = nCodCia
         AND IdPoliza          = nIdPoliza
         AND IDetPol           = nIDetPol
         AND Fec_Notificacion <= dFecValuacion
         AND Sts_Siniestro NOT IN ('SOL','ANU');
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END TIENE_SINIESTRO;

PROCEDURE ANULAR(nCodCia NUMBER, nIdSiniestro NUMBER, dFecAnul DATE, cMotivAnul VARCHAR2) IS
BEGIN
   UPDATE COBERTURA_SINIESTRO
      SET StsCobertura = 'ANU'
    WHERE IdSiniestro = nIdSiniestro;

   UPDATE PAGOS_POR_OTROS_CONCEPTOS
      SET StsPago = 'ANU'
    WHERE IdSiniestro = nIdSiniestro;

   UPDATE SINIESTRO
      SET FecAnul       = dFecAnul,
          Motiv_Anul    = cMotivAnul,
          Sts_Siniestro = 'ANU',
          FecSts        = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND IdSiniestro = nIdSiniestro;
END ANULAR;

PROCEDURE CERRAR(nCodCia NUMBER, nIdSiniestro NUMBER) IS
BEGIN
   UPDATE COBERTURA_SINIESTRO
      SET StsCobertura           = 'CER',
          Monto_Reservado_Local  = Monto_Pagado_Local,
          Monto_Reservado_Moneda = Monto_Pagado_Moneda
    WHERE IdSiniestro = nIdSiniestro;

   UPDATE PAGOS_POR_OTROS_CONCEPTOS
      SET StsPago                = 'CER',
          Monto_Reservado_Local  = Monto_Pago_Local,
          Monto_Reservado_Moneda = Monto_Pago_Moneda
    WHERE IdSiniestro = nIdSiniestro;

   UPDATE SINIESTRO
      SET Sts_Siniestro        = 'CER',
          FecSts               = TRUNC(SYSDATE),
          Monto_Reserva_Local  = Monto_Pago_Local,
          Monto_Reserva_Moneda = Monto_Pago_Moneda
    WHERE CodCia      = nCodCia
      AND IdSiniestro = nIdSiniestro;
END CERRAR;

PROCEDURE REABRIR(nCodCia NUMBER, nIdSiniestro NUMBER) IS
BEGIN
   UPDATE COBERTURA_SINIESTRO
      SET StsCobertura           = 'EMI'
    WHERE IdSiniestro = nIdSiniestro;

   UPDATE PAGOS_POR_OTROS_CONCEPTOS
      SET StsPago                = 'EMI'
    WHERE IdSiniestro = nIdSiniestro;

   UPDATE SINIESTRO
      SET Sts_Siniestro        = 'EMI',
          FecSts               = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND IdSiniestro = nIdSiniestro;
END REABRIR;

PROCEDURE REVERTIR_ACTIVACION(nCodCia NUMBER, nIdSiniestro NUMBER) IS
BEGIN
   UPDATE COBERTURA_SINIESTRO
      SET StsCobertura           = 'SOL'
    WHERE IdSiniestro = nIdSiniestro;

   UPDATE PAGOS_POR_OTROS_CONCEPTOS
      SET StsPago                = 'SOL'
    WHERE IdSiniestro = nIdSiniestro;

   UPDATE SINIESTRO
      SET Sts_Siniestro        = 'SOL',
          FecSts               = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND IdSiniestro = nIdSiniestro;
END REVERTIR_ACTIVACION;

PROCEDURE RECHAZAR (nCodCia NUMBER, nIdSiniestro NUMBER, dFecAnul DATE, cMotivAnul VARCHAR2) IS
BEGIN
   UPDATE SINIESTRO
      SET FecAnul       = dFecAnul,
          Motiv_Anul    = cMotivAnul,
          Sts_Siniestro = 'REZ',
          FecSts        = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND IdSiniestro = nIdSiniestro;
END RECHAZAR;

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSiniestro NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) IS
--
dFecHoy              DATE;
nRegis               NUMBER(10);
nRegisCobert         NUMBER(10);
nCob                 NUMBER(1);
cIndDeclara          DETALLE_POLIZA.IndDeclara%TYPE;
nIdTransaccion       TRANSACCION.IdTransaccion%TYPE;
nMonto_Reserva_Monto SINIESTRO.Monto_Reserva_Local%TYPE;
nCodAsegurado        SINIESTRO.Cod_Asegurado%TYPE;
--
CURSOR DET_SIN_Q IS
   SELECT IdDetSin
     FROM DETALLE_SINIESTRO
    WHERE IdSiniestro = nIdSiniestro;
--
CURSOR BENEF_Q IS
   SELECT IdPoliza, IDetPol, Cod_Asegurado, Benef, Nombre,
          PorcePart, CodParent, Estado, Sexo, FecEstado,
          FecAlta, FecBaja, MotBaja, Obervaciones, FecNac
     FROM BENEFICIARIO
    WHERE IdPoliza      = nIdPoliza
      AND IdetPol       = nIdetPol
    AND Cod_Asegurado = nCodAsegurado;
--
CURSOR OBJETOS_Q IS 
   SELECT IdObjeto
      FROM OBJETO
   WHERE IdProceso     =  6
      AND CodSubProceso = 'SIN';
--
BEGIN
  BEGIN
    SELECT SYSDATE
      INTO dFecHoy
      FROM DUAL;
  END;
  --
  BEGIN
    SELECT Cod_Asegurado
      INTO nCodAsegurado
      FROM SINIESTRO
     WHERE CodCia      = nCodCia
       AND IdSiniestro = nIdSiniestro
       AND IdPoliza    = nIdPoliza;
  EXCEPTION
    WHEN OTHERS THEN
    nCodAsegurado := 0;
  END;

   nIdTransaccion := OC_TRANSACCION.CREA(nCodCia,  nCodEmpresa,  6, 'SIN');

  --
  IF OC_SINIESTRO.SINIESTRO_DE_ASEGURADO(nCodCia, nIdPoliza, nIDetPol, nIdSiniestro) = 'N' THEN
    BEGIN
       SELECT COUNT(IdSiniestro)
         INTO nCob
         FROM COBERTURA_SINIESTRO
        WHERE IdPoliza     = nIdPoliza
          AND IdSiniestro  = nIdSiniestro
          AND StsCobertura = 'SOL';
     END;

     IF nCob = 0 THEN
        RAISE_APPLICATION_ERROR(-20225,'1 Debe Emitir la Reserva en estado SOL');
     END IF;
     --
     OC_SINIESTRO.TRANSACCION_RESERVAS(nCodCia, nCodEmpresa, nIdSiniestro, nIdPoliza, nIDetPol, nIdTransaccion);

     OC_DETALLE_SINIESTRO.ACTUALIZA_RESERVAS(nIdSiniestro);
  ELSE
     BEGIN
       SELECT COUNT(IdSiniestro)
         INTO nCob
         FROM COBERTURA_SINIESTRO_ASEG
        WHERE IdPoliza     = nIdPoliza
          AND IdSiniestro  = nIdSiniestro
          AND StsCobertura = 'SOL';
     END;

     IF nCob = 0 THEN
        RAISE_APPLICATION_ERROR(-20225,'2 Debe Emitir la Reserva en estado SOL');
     END IF;  
     --
     OC_SINIESTRO.TRANSACCION_RESERVAS(nCodCia, nCodEmpresa, nIdSiniestro, nIdPoliza, nIDetPol, nIdTransaccion);
     OC_DETALLE_SINIESTRO_ASEG.ACTUALIZA_RESERVAS(nIdSiniestro);
  END IF;
  --
  BEGIN
    UPDATE PAGOS_POR_OTROS_CONCEPTOS
       SET StsPago = 'EMI'
     WHERE IdSiniestro = nIdSiniestro;
  END;

  BEGIN
    UPDATE SINIESTRO
       SET Sts_Siniestro   = 'EMI',
           FecSts          = dFecHoy
     WHERE CodCia          = nCodCia
       AND IdSiniestro     = nIdSiniestro;
  END;

  --Inserta Beneficiarios en Sinietro.;
  FOR R1 IN BENEF_Q LOOP
    INSERT INTO BENEF_SIN
          (IdSiniestro, IdPoliza, Cod_Asegurado, Benef, Nombre, PorcePart, CodParent, Estado, Sexo, FecEstado,
           FecAlta, FecBaja, MotBaja, Obervaciones, Direccion, Email, Telefono, Cuenta_Clave, Ent_Financiera,
           IndPago, PorceApl, FecNac)
    VALUES(nIdSiniestro, nIdPoliza, R1.Cod_Asegurado, R1.Benef, R1.Nombre, R1.PorcePart, R1.CodParent, R1.Estado, R1.Sexo, R1.FecEstado,
           R1.FecAlta, R1.FecBaja, R1.MotBaja, R1.Obervaciones, NULL, NULL, NULL, NULL, NULL, NULL, NULL, R1.FecNac);   
  END LOOP;

  --FOR C IN OBJETOS_Q LOOP 
  BEGIN
    SELECT UNIQUE(Monto_Reserva_Moneda)
      INTO nMonto_Reserva_Monto
      FROM SINIESTRO
     WHERE CodCia      = nCodCia
       AND IdSiniestro = nIdSiniestro;
  EXCEPTION 
        WHEN NO_DATA_FOUND THEN 
          RAISE_APPLICATION_ERROR(-20225,'NDF Error al traer nMonto_Reserva_Monto '||SQLERRM);
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20225,'OTHERS Error al traer nMonto_Reserva_Monto '||SQLERRM);  
   END;

  BEGIN         
   OC_DETALLE_TRANSACCION.CREA (nIdTransaccion, nCodCia, nCodEmpresa, 6, 'SIN', 'SINIESTRO',
                                nIdSiniestro, NULL,NULL, NULL, nMonto_Reserva_Monto);  
  EXCEPTION 
    WHEN OTHERS THEN 
      RAISE_APPLICATION_ERROR(-20225,'Error al Crear el Detalle de la Transaccion'||SQLERRM);
  END;

/*
  UPDATE COBERTURA_SINIESTRO
     SET StsCobertura  = 'EMI',
         IdTransaccion = nIdTransaccion
   WHERE IdSiniestro   = nIdSiniestro;
  --    
  UPDATE COBERTURA_SINIESTRO_ASEG
     SET StsCobertura  = 'EMI',
         IdTransaccion = nIdTransaccion
   WHERE IdSiniestro   = nIdSiniestro;

  OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');

  BEGIN
    UPDATE TAREA
       SET Estado_Final     = 'EJE',
           FechadeRealizado = SYSDATE,
           UsuarioRealizo   = USER,
           Estado           = 'EJE'
     WHERE IdSiniestro      = nIdSiniestro
       AND CodCia           = nCodCia
       AND CodSubProceso    = 'SIN'
       AND IdProceso        = 6
       AND Estado           = 'PRO';
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error en Tarea de Siniestro No. '|| nIdSiniestro ||SQLERRM);
  END;*/
EXCEPTION
  WHEN OTHERS THEN 
    RAISE_APPLICATION_ERROR(-20225,'Error al Activar el Siniestro No. '|| nIdSiniestro ||SQLERRM);
END ACTIVAR;

PROCEDURE TRANSACCION_RESERVAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSiniestro NUMBER, 
                               nIdPoliza NUMBER, nIDetPol NUMBER, nIdTransaccion NUMBER) IS
--
dFecHoy         DATE;
nCobertLocal    COBERTURA_SINIESTRO.Monto_Reservado_Local%TYPE;
nCobertMoneda   COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;
nOtrPagLocal    PAGOS_POR_OTROS_CONCEPTOS.Monto_Reservado_Local%TYPE;
nOtrPagMoneda   PAGOS_POR_OTROS_CONCEPTOS.Monto_Reservado_Moneda%TYPE;
nTotSiniLocal   SINIESTRO.Monto_Reserva_Local%TYPE;
nTotSiniMoneda  SINIESTRO.Monto_Reserva_Moneda%TYPE;
nIdDetSin       COBERTURA_SINIESTRO.IdDetSin%TYPE;
nNumMod         COBERTURA_SINIESTRO.NumMod%TYPE;
--
--
W_GRABA                SAI_CAT_GENERAL.CAGE_VALOR_CORTO%TYPE;
GRABA                  BOOLEAN;
--
CURSOR COBERT_Q(cIdDetSin COBERTURA_SINIESTRO.IdDetSin%TYPE) IS
   SELECT Monto_Reservado_Local, Monto_Reservado_Moneda, NumMod, CodCobert
     FROM COBERTURA_SINIESTRO_ASEG
    WHERE IdSiniestro = nIdSiniestro
      AND IdDetSin    = cIdDetSin
      AND StsCobertura = 'SOL'
   UNION
   SELECT Monto_Reservado_Local, Monto_Reservado_Moneda, NumMod, CodCobert
     FROM COBERTURA_SINIESTRO
    WHERE IdSiniestro = nIdSiniestro
      AND IdDetSin    = cIdDetSin
      AND StsCobertura = 'SOL';
--
CURSOR DET_SIN_Q IS
   SELECT IdDetSin, NULL Cod_Asegurado
     FROM DETALLE_SINIESTRO
    WHERE IdSiniestro = nIdSiniestro
    UNION 
   SELECT IdDetSin, Cod_Asegurado
     FROM DETALLE_SINIESTRO_ASEG
    WHERE IdSiniestro = nIdSiniestro;
--
BEGIN
  --
  /*BEGIN  -- GRABA
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
IF GRABA THEN GRABA_TIEMPO(3,nIdSiniestro,'OC_SINIESTRO-TRANSACCION_RESERVAS',1,'');  END IF;  */
  nTotSiniLocal  := 0;
  nTotSiniMoneda := 0;

  FOR X IN DET_SIN_Q LOOP
/*IF GRABA THEN GRABA_TIEMPO(3,nIdSiniestro,'OC_SINIESTRO-TRANSACCION_RESERVAS',2,'DSQ');  END IF;  */
/*    BEGIN
      SELECT NVL(SUM(Monto_Reservado_Local),0), NVL(SUM(Monto_Reservado_Moneda),0)
        INTO nOtrPagLocal, nOtrPagMoneda
        FROM PAGOS_POR_OTROS_CONCEPTOS
       WHERE IdSiniestro = nIdSiniestro
         AND IdDetSin    = X.IdDetSin;
    END;*/
    --
    FOR J IN COBERT_Q(X.IdDetSin) LOOP
/*IF GRABA THEN GRABA_TIEMPO(3,nIdSiniestro,'OC_SINIESTRO-TRANSACCION_RESERVAS',3,'CQ');  END IF;  */
      IF X.Cod_Asegurado IS NULL THEN

/*IF GRABA THEN GRABA_TIEMPO(3,nIdSiniestro,'OC_SINIESTRO-TRANSACCION_RESERVAS',4,'CQ NO ASEG');  END IF;  */
         OC_COBERTURA_SINIESTRO.EMITE_RESERVA(nCodCia, nCodEmpresa, nIdSiniestro, nIdPoliza,
                                              X.IdDetSin, J.CodCobert, J.NumMod, nIdTransaccion);
/*IF GRABA THEN GRABA_TIEMPO(3,nIdSiniestro,'OC_SINIESTRO-TRANSACCION_RESERVAS',5,'CQ NO ASEG');  END IF;  */
         --nCobertLocal  := nCobertLocal + NVL(J.Monto_Reservado_Local,0);
         --nCobertMoneda := nCobertMoneda + NVL(Monto_Reservado_Moneda,0);
         --
      ELSE
/*IF GRABA THEN GRABA_TIEMPO(3,nIdSiniestro,'OC_SINIESTRO-TRANSACCION_RESERVAS',6,'CQ SI ASEG');  END IF;  */
         OC_COBERTURA_SINIESTRO_ASEG.EMITE_RESERVA(nCodCia, nCodEmpresa, nIdSiniestro, nIdPoliza,
                                                   X.IdDetSin, X.Cod_Asegurado, J.CodCobert, J.NumMod, nIdTransaccion);
/*IF GRABA THEN GRABA_TIEMPO(3,nIdSiniestro,'OC_SINIESTRO-TRANSACCION_RESERVAS',7,'CQ SI ASEG');  END IF;  */
         --nCobertLocal  := nCobertLocal + NVL(J.Monto_Reservado_Local,0);
         --nCobertMoneda := nCobertMoneda + NVL(Monto_Reservado_Moneda,0);
         --
      END IF;
    END LOOP;
/*IF GRABA THEN GRABA_TIEMPO(3,nIdSiniestro,'OC_SINIESTRO-TRANSACCION_RESERVAS',8,'DSQ');  END IF;  */

    --nTotSiniLocal  := NVL(nCobertLocal,0) + NVL(nOtrPagLocal,0);
    --nTotSiniMoneda := NVL(nCobertLocal,0) + NVL(nOtrPagLocal,0);
    
    GT_REA_DISTRIBUCION.DISTRIBUYE_SINIESTROS(nCodCia, nCodEmpresa, nIdSiniestro, nIdTransaccion, TRUNC(SYSDATE));
    OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');
/*IF GRABA THEN GRABA_TIEMPO(3,nIdSiniestro,'OC_SINIESTRO-TRANSACCION_RESERVAS',9,'DSQ');  END IF;  */
    /*OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa, 6, 'EMIRES', 'COBERTURA_SINIESTRO',
                                   nIdSiniestro, nIdPoliza, X.IdDetSin, NULL, nTotSiniLocal);*/
    /*BEGIN
      UPDATE TAREA
         SET Estado_Final     = 'EJE',
             FechadeRealizado = SYSDATE,
                   UsuarioRealizo   = USER,
                   Estado           = 'EJE'
             WHERE IdSiniestro      = nIdSiniestro
               AND CodCia           = nCodCia
               AND CodSubProceso    = 'EMIRES'
               AND IdProceso         = 6
               AND Estado           = 'PRO';
         EXCEPTION
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20225,'Error en Tarea de Siniestro No. '|| nIdSiniestro ||SQLERRM);
         END;
      END;*/
  END LOOP;
/*IF GRABA THEN GRABA_TIEMPO(3,nIdSiniestro,'OC_SINIESTRO-TRANSACCION_RESERVAS',10,'DSQ');  END IF;  */
END TRANSACCION_RESERVAS;

FUNCTION MONEDA_SINIESTRO(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdSiniestro NUMBER) RETURN VARCHAR2 IS
cCod_Moneda   SINIESTRO.Cod_Moneda%TYPE;
BEGIN
   BEGIN
      SELECT Cod_Moneda
        INTO cCod_Moneda
        FROM SINIESTRO
       WHERE CodCia       = nCodCia
         AND IdPoliza     = nIdPoliza
         AND IDetPol      = nIDetPol
         AND IdSiniestro  = nIdSiniestro;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe el Siniestro No. '|| nIdSiniestro);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existe Varios Registros del Siniestro No. '|| nIdSiniestro);
   END;
   RETURN(cCod_Moneda);
END MONEDA_SINIESTRO;

-------------------------------------------------------------------- SEQ XDS
   -- Funcion para buscar el proximo numero de Siniestros   ---
--------------------------------------------------------------------
 FUNCTION F_GET_SIN ( p_msg_regreso    out  nocopy varchar2 ) RETURN NUMBER AS
  
  
      vNumSIN        parametros_enum_sin.paen_cont_fin%type;
      vNombreTabla   varchar2(30);
      vIdProducto    number(6); 
      
   
   BEGIN
    -- Buscar el nombre de la tabla de la cual se obtendra por la descripcion y la bandera
      select pa.pame_ds_numerador,
             pa.paem_id_producto 
        into vNombreTabla,
             vIdProducto
        from PARAMETROS_EMISION pa
       where pa.paem_cd_producto   =  3
         and pa.paem_des_producto  = 'SINIESTROS'
         and pa.paem_flag          =  1;

    -- Obtener el numero de facturas
   
     select ps.paen_cont_fin
       into vNumSIN
       from parametros_enum_sin ps
      where ps.paen_id_sin = vIdProducto
      FOR UPDATE OF ps.paen_cont_fin;

 --  Actualizar al siguiente numero
      update  parametros_enum_sin p
         set p.paen_cont_fin = vNumSIN +1
       where p.paen_id_sin   = vIdProducto; 
      
    -- Hacer permanentes los cambios para evitar bloqueo de la tabla
    --   commit;
     return vNumSIN;     
 EXCEPTION
      when no_data_found then
         p_msg_regreso := '.:: No se ha dado de alta '|| vNombreTabla ||' en PARAMETROS_EMISION ::.'||sqlerrm;
         dbms_output.put_line(p_msg_regreso);
         rollback;
        return 0;
      when others then
         p_msg_regreso := '.:: Error en "OC_SINIESTRO.F_GET_SIN" .:: -> '||sqlerrm;
         dbms_output.put_line(p_msg_regreso);
         rollback;
         return 0;
 END F_GET_SIN;

END OC_SINIESTRO;
/

--
-- OC_SINIESTRO  (Synonym) 
--
--  Dependencies: 
--   OC_SINIESTRO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_SINIESTRO FOR SICAS_OC.OC_SINIESTRO
/


GRANT EXECUTE ON SICAS_OC.OC_SINIESTRO TO PUBLIC
/
