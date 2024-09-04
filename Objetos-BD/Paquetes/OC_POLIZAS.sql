CREATE OR REPLACE PACKAGE SICAS_OC.OC_POLIZAS IS
--
-- HOMOLOGACION VIFLEX                             JMMD 01/03/2022
-- INCIDENCIA AGENTE                               INCIAGE  JICO 14/06/2023
--
    FUNCTION F_GET_NUMPOL ( p_msg_regreso    out  nocopy varchar2 ) RETURN NUMBER;

    FUNCTION INSERTAR_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, cDescPoliza VARCHAR2,
                 cCodMoneda VARCHAR2, nPorcComis NUMBER, nCodCliente NUMBER,
                 nCodAgente VARCHAR2, cCodPlanPago VARCHAR2, cNumPolUnico VARCHAR2,
                 cNumPolRef VARCHAR2, dFecIniVig DATE ) RETURN NUMBER;

    FUNCTION NUMERO_UNICO(nCodCia NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2;

    PROCEDURE ACTUALIZA_VALORES(nCodCia NUMBER, nIdPoliza NUMBER, nIdEndoso NUMBER);

    FUNCTION VALIDA_POLIZA(nCodCia NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2;

    FUNCTION VALIDA_FIANZA(nCodCia NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER) RETURN VARCHAR2;

    PROCEDURE EMITIR_POLIZA(nCodCia NUMBER, nIdPoliza NUMBER, nCodEmpresa NUMBER);

    PROCEDURE INSERTA_REQUISITOS(nCodCia NUMBER, nIdPoliza NUMBER);

    FUNCTION RENOVAR(nCodCia NUMBER, nIdPolizaRen NUMBER, cEmitePoliza VARCHAR2 DEFAULT 'N',
                     cIndSubGrupos VARCHAR2, IndAsegurados VARCHAR2, nIdCotizacion NUMBER) RETURN NUMBER;

    FUNCTION EXISTE_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2;

    FUNCTION TOTAL_PRIMA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN NUMBER;

    FUNCTION TOTAL_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN NUMBER;

    FUNCTION APLICA_SAMI(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2;

    PROCEDURE CALCULA_SAMI(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER);

    FUNCTION TOTAL_SAMI(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN NUMBER;

    FUNCTION RANGO_SAMI(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nTotalAsegurados NUMBER) RETURN NUMBER;

    FUNCTION SAMI_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN NUMBER;

    FUNCTION POLIZA_AUTOADMINISTRADA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2;

    FUNCTION POLIZA_COLECTIVA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2;

    PROCEDURE REVERTIR_EMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, cTipoPol VARCHAR2);

    PROCEDURE COPIAR(nCodCia NUMBER, nIdPolizaOrig NUMBER);

    FUNCTION DERECHOS_EMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2;

    FUNCTION FACTURA_ELECTRONICA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2;

    PROCEDURE REHABILITACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER);

    PROCEDURE ANULAR_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, dFecAnul DATE,
                cMotivAnul VARCHAR2, cCod_Moneda VARCHAR2, cTipoProceso VARCHAR2);

    PROCEDURE INSERTA_CLAUSULAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER);

    FUNCTION PLAN_DE_PAGOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2;

    FUNCTION FACTURA_POR_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2;

    FUNCTION CODIGO_RIESGO_REASEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2;

    FUNCTION POLIZA_INICIAL_RENOVACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN NUMBER;

    FUNCTION INICIO_VIGENCIA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN DATE;

    FUNCTION NUMERO_INTENTOS_COBRANZA (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN NUMBER;

    FUNCTION APLICA_RETIRO_PRIMA_NIVELADA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2;

    PROCEDURE SEND_MAIL(cCtaEnvio IN VARCHAR2,cPwdEmail IN VARCHAR2,cEmail IN VARCHAR2, cEmailDest IN VARCHAR2,cEmailCC IN VARCHAR2 DEFAULT NULL,
                        cEmailBCC IN VARCHAR2 DEFAULT NULL,cSubject IN VARCHAR2,cMessage IN VARCHAR2);

    PROCEDURE PRE_EMITE_POLIZA(P_CodCia NUMBER, P_CodEmpresa NUMBER, P_IdPoliza NUMBER, P_IDTRANSACCION   NUMBER);  -- LARPLA

    PROCEDURE LIBERA_PRE_EMITE(P_CodCia NUMBER, P_CodEmpresa NUMBER, P_IdPoliza NUMBER, P_Fecha_Pago DATE); --LARPLA

    FUNCTION DIA_COBRO (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN NUMBER;

    FUNCTION BLOQUEADA_PLD(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2;

    FUNCTION LIBERADA_PLD(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2;

    PROCEDURE LIBERA_PRE_EMITE_PLATAFORMA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, dFechaPago DATE);

    FUNCTION MONEDA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2;

    FUNCTION ALTURA_CERO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2;
    
    -- PROCESOS GENERADOS PARA LA RENOVACION ESPECIAL MLJS CAGR ---
    FUNCTION F_OBT_NUMPOLUNICO_REN (CNUMPOLUNICOORIG IN VARCHAR2) RETURN VARCHAR2;              --08/05/2024            
    FUNCTION F_OBT_NUMRENOV_REN (CNUMPOLUNICOORIG IN VARCHAR2) RETURN NUMBER;                   --17/05/2024
    FUNCTION COPIAR_REN(nCodCia NUMBER, nIdPolizaOrig NUMBER, cUsuario VARCHAR2) RETURN NUMBER; --17/05/2024
    
    
    
END OC_POLIZAS;
/
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_POLIZAS IS
   --
   -- BITACORA DE CAMBIO
   -- SE AGREGO LA FUNCIONALIDAD DE LAVADO DE DINERO                        JICO 18/05/2017  LAVDIN
   -- SE UNIFICO A UNA SOLA VALIDACION LAS TRES PERSONALIDADES DE EMISION
   -- SE AGREGO LA FUNCIONALIDAD PARA RENOVACION DE CLAUSULAS               JICO 10/08/2017  CLAUREN
   -- SE AGREGO LA FUNCIONALIDA DE LARGO PLAZO                              JICO 10/04/2019  LARPLA
   -- SE AGREGO LA FUNCIONALIDA DE PREEMISIONO                              JICO 16/05/2019  PREEMI
   -- HOMOLOGACION                                                          JICO 01/10/2019
   -- HOMOLOGACION VIFLEX                                                   JMMD 01/03/2022
   ----------------------------------------------------------------------  SEQ XDS
         --- Funcion para buscar el proximo numero de poliza  ---
   ----------------------------------------------------------------------
    FUNCTION F_GET_NUMPOL ( p_msg_regreso    out  nocopy varchar2 ) RETURN NUMBER AS

         vNumPoliza      parametros_enum_pol.paen_cont_fin%type;
         vNombreTabla    varchar2(30);
         vIdProducto     number(6);


      BEGIN
       -- Buscar el nombre de la tabla de la cual se obtendra por la descripcion y la bandera
         select pa.pame_ds_numerador,
           pa.paem_id_producto
      into vNombreTabla,
           vIdProducto
      from PARAMETROS_EMISION pa
          where pa.paem_cd_producto   = 1
       and pa.paem_des_producto  = 'POLIZA'
       and pa.paem_flag          =  1;

       -- Obtener el numero de poliza correspondiente

        select pp.paen_cont_fin
          into vNumPoliza
          from PARAMETROS_ENUM_POL pp
         where pp.paen_id_pol =vIdProducto
         FOR UPDATE OF pp.paen_cont_fin;

    --  Actualizar al siguiente numero
         update PARAMETROS_ENUM_POL pe
       set pe.paen_cont_fin = vNumPoliza +1
          where pe.paen_id_pol =vIdProducto;


   -- POR SI HAY QUE REGRESAR

      /* SELECT NVL(MAX(IdPoliza),0)+1
         INTO vNumPoliza
         FROM POLIZAS
        WHERE CodCia = nCodCia;*/
        /**  Cambio de A Sequencia XDS 25/07/2016**/


       -- Hacer permanentes los cambios para evitar bloqueo de la tabla
        --  commit;


        return vNumPoliza;
    EXCEPTION
         when no_data_found then
       p_msg_regreso := '.:: No se ha dado de alta '|| vNombreTabla ||' en PARAMETROS_EMISION ::.'||sqlerrm;
       rollback;
      return 0;
         when others then
       p_msg_regreso := '.:: Error en "OC_UTILS.F_GET_NUMPOL" .:: -> '||sqlerrm;
       rollback;
       return 0;
    END F_GET_NUMPOL;



   FUNCTION INSERTAR_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, cDescPoliza VARCHAR2,
             cCodMoneda VARCHAR2, nPorcComis NUMBER, nCodCliente NUMBER,
             nCodAgente VARCHAR2, cCodPlanPago VARCHAR2, cNumPolUnico VARCHAR2,
             cNumPolRef VARCHAR2, dFecIniVig DATE ) RETURN NUMBER IS
   nIdPoliza    POLIZAS.IdPoliza%TYPE;
   --dFecSistema  DATE := TRUNC(SYSDATE);
   --dFecFinVig   DATE := ADD_MONTHS(TRUNC(SYSDATE),12);
   dFecSistema  DATE := TRUNC(dFecIniVig);
   dFecFinVig   DATE := ADD_MONTHS(TRUNC(dFecIniVig),12);
   p_msg_regreso varchar2(50);----var XDS
   BEGIN
    /**
      SELECT NVL(MAX(IdPoliza),0)+1
        INTO nIdPoliza
        FROM POLIZAS
       WHERE CodCia = nCodCia;**/

     --   Cambio a Sequencia XDS **/
         nIdPoliza :=F_GET_NUMPOL(p_msg_regreso);


      BEGIN
         INSERT INTO POLIZAS
          (IdPoliza, CodEmpresa, CodCia, TipoPol, NumPolRef, FecIniVig, FecFinVig,
           FecSolicitud, FecEmision, FecRenovacion, StsPoliza, FecSts, FecAnul,
           MotivAnul, SumaAseg_Local, SumaAseg_Moneda, PrimaNeta_Local, PrimaNeta_Moneda,
           DescPoliza, PorcComis, NumRenov, IndExaInsp, Cod_Moneda, Num_Cotizacion,
           CodCliente, Cod_Agente, CodPlanPago, Medio_Pago, NumPolUnico, PorcDescuento,
           PorcGtoAdmin, PorcGtoAdqui, PorcUtilidad, FactorAjuste, MontoDeducible,
           FactFormulaDeduc, CodRiesgoRea, CodTipoBono, HorasVig, DiasVig,
           IndExtraPrima, AsegAdheridosPor, PorcenContributorio,
           FuenteRecursosPrima, IdFormaCobro, DiaCobroAutomatico, IndManejaFondos)
         VALUES(nIdPoliza, nCodEmpresa, nCodCia, 'P', cNumPolRef, dFecSistema, dFecFinVig,
           dFecSistema, dFecSistema, dFecFinVig, 'SOL', dFecSistema, NULL,
           NULL, 0, 0, 0, 0, cDescPoliza, nPorcComis, 0, 'N', cCodMoneda, NULL,
           nCodCliente, nCodAgente, cCodPlanPago, NULL, cNumPolUnico, 0,
           0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, 'N', NULL, NULL,
           NULL, NULL, 0, 'N');
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
       RAISE_APPLICATION_ERROR(-20225,'Ya Existe No. de Póliza: '||TRIM(cNumPolUnico)||
                ' en la Compañía '||TO_CHAR(nCodCia));
      END;
      RETURN(nIdPoliza);
   END INSERTAR_POLIZA;

   FUNCTION NUMERO_UNICO(nCodCia NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2 IS
   cNumPolUnico    POLIZAS.NumPolUnico%TYPE;
   BEGIN
      BEGIN
         SELECT NumPolUnico
      INTO cNumPolUnico
      FROM POLIZAS
          WHERE CodCia    = nCodCia
       AND IdPoliza = nIdPoliza;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
       cNumPolUnico := NULL;
         WHEN TOO_MANY_ROWS THEN
       RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros de la Póliza: '||TRIM(TO_CHAR(nIdPoliza))||
                ' en la Compañía '||TO_CHAR(nCodCia));
      END;
      RETURN(cNumPolUnico);
   END NUMERO_UNICO;

   PROCEDURE ACTUALIZA_VALORES(nCodCia NUMBER, nIdPoliza NUMBER, nIdEndoso NUMBER) IS
   nSumaLocal          COBERTURAS.Suma_Asegurada_Local%TYPE;
   nSumaMoneda         COBERTURAS.Suma_Asegurada_Moneda%TYPE;
   nPrimaLocal         COBERTURAS.Prima_Local%TYPE;
   nPrimaMoneda        COBERTURAS.Prima_Moneda%TYPE;
   nMontoAsistLocal    ASISTENCIAS_ASEGURADO.MontoAsistLocal%TYPE;
   nMontoAsistMoneda   ASISTENCIAS_ASEGURADO.MontoAsistMoneda%TYPE;
   BEGIN
      SELECT NVL(SUM(SumaAseg_Local),0), NVL(SUM(SumaAseg_Moneda),0),
        NVL(SUM(Prima_Local),0), NVL(SUM(Prima_Moneda),0)
        INTO nSumaLocal, nSumaMoneda,
        nPrimaLocal, nPrimaMoneda
        FROM COBERT_ACT
       WHERE CodCia         = nCodCia
         AND IdPoliza       = nIdPoliza
         AND StsCobertura NOT IN ('CEX');

      SELECT NVL(SUM(MontoAsistLocal),0), NVL(SUM(MontoAsistMoneda),0)
        INTO nMontoAsistLocal, nMontoAsistMoneda
        FROM ASISTENCIAS_DETALLE_POLIZA
       WHERE CodCia          = nCodCia
         AND IdPoliza        = nIdPoliza
         AND StsAsistencia NOT IN ('EXCLUI');

      SELECT NVL(SUM(SumaAseg_Local),0) + NVL(nSumaLocal,0), NVL(SUM(SumaAseg_Moneda),0) + NVL(nSumaMoneda,0),
        NVL(SUM(Prima_Local),0) + NVL(nPrimaLocal,0), NVL(SUM(Prima_Moneda),0) + NVL(nPrimaMoneda,0)
        INTO nSumaLocal, nSumaMoneda,
        nPrimaLocal, nPrimaMoneda
        FROM COBERT_ACT_ASEG
       WHERE CodCia         = nCodCia
         AND IdPoliza       = nIdPoliza
         AND StsCobertura NOT IN ('CEX');

      SELECT NVL(SUM(MontoAsistLocal),0) + NVL(nMontoAsistLocal,0),
        NVL(SUM(MontoAsistMoneda),0) + NVL(nMontoAsistMoneda,0)
        INTO nMontoAsistLocal, nMontoAsistMoneda
        FROM ASISTENCIAS_ASEGURADO
       WHERE CodCia          = nCodCia
         AND IdPoliza        = nIdPoliza
         AND StsAsistencia NOT IN ('EXCLUI');

      UPDATE POLIZAS
         SET SumaAseg_Local   = NVL(nSumaLocal,0),
        SumaAseg_Moneda  = NVL(nSumaMoneda,0),
        PrimaNeta_Local  = NVL(nPrimaLocal,0) + NVL(nMontoAsistLocal,0),
        PrimaNeta_Moneda = NVL(nPrimaMoneda,0) + NVL(nMontoAsistMoneda,0)
       WHERE CodCia    = nCodCia
         AND IdPoliza  = nIdPoliza;
   END ACTUALIZA_VALORES;

   FUNCTION VALIDA_POLIZA(nCodCia NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2 IS
   nSumaAseg                   POLIZAS.SumaAseg_Local%TYPE;
   nSumaAsegCob                COBERTURAS.Suma_Asegurada_Local%TYPE;
   cTipoPol                    POLIZAS.TipoPol%TYPE;
   cTipoAdministracion         POLIZAS.TipoAdministracion%TYPE;
   nSumaAsegAseg               COBERTURAS.Suma_Asegurada_Local%TYPE;
   dFecIniVig                  POLIZAS.FecIniVig%TYPE;
   dFecFinVig                  POLIZAS.FecFinVig%TYPE;
   nPorcComProporcional        AGENTES_DISTRIBUCION_COMISION.Porc_Com_Proporcional%TYPE;
   nPorc_Com_Distribuida       AGENTES_DISTRIBUCION_COMISION.Porc_Com_Distribuida%TYPE;
   nPorc_Comision_Agente       AGENTES_DISTRIBUCION_COMISION.Porc_Comision_Agente%TYPE;
   cIndFactElectronica         POLIZAS.IndFactElectronica%TYPE;
   cIdTipoSeg                  DETALLE_POLIZA.IdTipoSeg%TYPE;
   cPlanCob                    DETALLE_POLIZA.PlanCob%TYPE;
   cIndFacturaPol              POLIZAS.IndFacturaPol%TYPE;
   cNum_TributarioCli          PERSONA_NATURAL_JURIDICA.Num_Tributario%TYPE;
   nCodCliente                 POLIZAS.CodCliente%TYPE;
   cNumPolUnico                POLIZAS.NumPolUnico%TYPE;
   nExamInsp                   NUMBER(10);
   nRegis                      NUMBER(6);
   nRegisA                     NUMBER(6);
   nRequisitos                 NUMBER(6);
   nEmite                      VARCHAR2(1);
   cIndExaInsp                 VARCHAR2(1);
   nRegisAs                    NUMBER(6);
   nEdad                       NUMBER(5);
   nCantPol                    NUMBER(5);
   cEmpresa                    POLIZAS.CodEmpresa%TYPE;                --LAVDIN
   cTipo_Doc_Identificacion    CLIENTES.TIPO_DOC_IDENTIFICACION%TYPE;  --LAVDIN
   cNum_Doc_identificacion     CLIENTES.NUM_DOC_IDENTIFICACION%TYPE;   --LAVDIN
   cMensaje                    VARCHAR2(300);                          --LAVDIN
   cPldstaprobada              POLIZAS.PLDSTAPROBADA%TYPE;             --LAVDIN
   cstspoliza                  POLIZAS.STSPOLIZA%TYPE;                 --LAVDIN 2017/08/07
   nCodEmpresa                 DETALLE_POLIZA.CodEmpresa%TYPE;
   nNumRenov                   POLIZAS.NumRenov%TYPE;
   nDiaCobroAutomatico         POLIZAS.DiaCobroAutomatico%TYPE;
   cIndManejaFondos            POLIZAS.IndManejaFondos%TYPE;
   nIdFormaCobro               POLIZAS.IdFormaCobro%TYPE;
   NUNPRICIPAL                 VARCHAR2(2);      --INCIAGE

   CURSOR CPTO_PRIMAS_Q IS
      SELECT CS.CodCpto
        FROM COBERT_ACT C, COBERTURAS_DE_SEGUROS CS
       WHERE CS.CodCobert  = C.CodCobert
         AND CS.PlanCob    = C.PlanCob
         AND CS.IdTipoSeg  = C.IdTipoSeg
         AND CS.CodEmpresa = C.CodEmpresa
         AND CS.CodCia     = C.CodCia
         AND C.IdPoliza    = nIdPoliza
         AND C.CodCia      = nCodCia
       UNION
      SELECT CS.CodCpto
        FROM COBERT_ACT_ASEG C, COBERTURAS_DE_SEGUROS CS
       WHERE CS.CodCobert  = C.CodCobert
         AND CS.PlanCob    = C.PlanCob
         AND CS.IdTipoSeg  = C.IdTipoSeg
         AND CS.CodEmpresa = C.CodEmpresa
         AND CS.CodCia     = C.CodCia
         AND C.IdPoliza    = nIdPoliza
         AND C.CodCia      = nCodCia
       GROUP BY CS.CodCpto;
   CURSOR DET_Q IS
      SELECT D.CodEmpresa, D.Cod_Asegurado, D.IDetPol, D.PorcComis,
        D.IndFactElectronica, D.FecIniVig, D.FecFinVig,
        A.Tipo_Doc_Identificacion, A.Num_Doc_IDentificacion,
        D.IdTipoSeg, D.PlanCob, D.IdFormaCobro
        FROM DETALLE_POLIZA D, ASEGURADO A
       WHERE A.Cod_Asegurado = D.Cod_Asegurado
         AND D.CodCia        = nCodCia
         AND D.IdPoliza      = nIdPoliza
         AND D.StsDetalle   IN ('SOL','XRE');
   CURSOR ASEG_Q IS
      SELECT AC.IDetPol, AC.Cod_Asegurado, D.CodEmpresa,
        A.Tipo_Doc_Identificacion, A.Num_Doc_IDentificacion
        FROM ASEGURADO_CERTIFICADO AC, ASEGURADO A, DETALLE_POLIZA D
       WHERE D.CodCia        = AC.CodCia
         AND D.IDetPol       = AC.IDetPol
         AND D.IdPoliza      = AC.IdPoliza
         AND A.Cod_Asegurado = AC.Cod_Asegurado
         AND AC.IdPoliza     = nIdPoliza
         AND AC.CodCia       = nCodCia;
   CURSOR AGT_Q IS
      SELECT DISTINCT Cod_Agente, Cod_Agente_Distr, Porc_Comision_Agente,
        Porc_Com_Distribuida, Porc_Com_Proporcional
        FROM AGENTES_DISTRIBUCION_POLIZA
       WHERE IdPoliza = nIdPoliza
         AND CodCia   = nCodCia;
   BEGIN
      nEmite := 'N';

      FOR X IN CPTO_PRIMAS_Q LOOP
         IF X.CodCpto IS NULL THEN
       RAISE_APPLICATION_ERROR(-20200,'Debe Configurar los Conceptos de Prima en Coberturas antes de Emitir la Póliza');
         ELSE
       IF OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(nCodCia, X.CodCpto) = 'CONCEPTO NO EXISTE' THEN
          RAISE_APPLICATION_ERROR(-20200,'Concepto de Prima Configurado en Coberturas ' || X.CodCpto || ' NO es Válido');
       END IF;
         END IF;
      END LOOP;

      BEGIN
         SELECT DISTINCT IdTipoSeg, PlanCob, CodEmpresa
      INTO cIdTipoSeg, cPlanCob, nCodEmpresa
      FROM DETALLE_POLIZA
          WHERE IdPoliza = nIdPoliza
       AND CodCia   = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20200,'No ha Ingresado Certificados/Subgrupos a la Póliza');
         WHEN TOO_MANY_ROWS THEN
       RAISE_APPLICATION_ERROR(-20200,'Asignó Diferentes Tipos de Seguros o Planes de Cobertura a los Certificados/Subgrupos a la Póliza');
      END;

      SELECT IndExaInsp, SumaAseg_Local, TipoPol, TipoAdministracion, NumPolUnico,
        FecIniVig, FecFinVig, IndFactElectronica, IndFacturaPol, P.CodCliente,
        CodEmpresa, C.Tipo_Doc_Identificacion, C.Num_Doc_Identificacion, NVL(P.Pldstaprobada,'N'),
        P.StsPoliza, P.NumRenov, P.DiaCobroAutomatico, P.IdFormaCobro, P.IndManejaFondos
        INTO cIndExaInsp, nSumaAseg, cTipoPol, cTipoAdministracion, cNumPolUnico,
        dFecIniVig, dFecFinVig, cIndFactElectronica, cIndFacturaPol, nCodCliente,
        cEmpresa, cTipo_Doc_Identificacion, cNum_Doc_Identificacion, cPldstaprobada,              --LAVDIN
        cStsPoliza, nNumRenov, nDiaCobroAutomatico, nIdFormaCobro, cIndManejaFondos
        FROM POLIZAS P, CLIENTES C                                                                     --LAVDIN
       WHERE IdPoliza = nIdPoliza
         AND CodCia   = nCodCia
         AND C.CodCliente = P.CodCliente;                                                              --LAVDIN

      IF cStsPoliza = 'PLD'  THEN                            --LAVDIN 2017/08/07
         RAISE_APPLICATION_ERROR(-20200,'La poliza es PLD'); --LAVDIN 2017/08/07
      END IF;                                                --LAVDIN 2017/08/07

      IF NVL(nNumRenov,0) = 0 THEN
         IF OC_PLAN_COBERTURAS.VALIDA_DIAS_RETROACTIVOS(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, dFecIniVig) = 'N' THEN
       IF OC_PROCESO_AUTORIZA_USUARIO.PROCESO_AUTORIZADO(nCodCia, '9145', USER, 'NOAPLI',1) = 'N' THEN
          RAISE_APPLICATION_ERROR(-20225,'La Configuración del Producto Sólo Tiene '||OC_PLAN_COBERTURAS.NUMERO_DIAS_RETROACTIVOS(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob)||' Días de Retroactividad Por Favor Valide su Póliza '||TRIM(TO_CHAR(nIdPoliza)));
       END IF;
         END IF;
      ELSE
         IF OC_PLAN_COBERTURAS.VALIDA_DIAS_RETROACTIVOS_REN(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, dFecIniVig) = 'N' THEN
       IF OC_PROCESO_AUTORIZA_USUARIO.PROCESO_AUTORIZADO(nCodCia, '9145', USER, 'NOAPLI',1) = 'N' THEN
          RAISE_APPLICATION_ERROR(-20225,'La Configuración del Producto Sólo Tiene '||OC_PLAN_COBERTURAS.NUMERO_DIAS_RETROACTIVOS_REN(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob)||' Días de Retroactividad Para Renovación Por Favor Valide su Póliza '||TRIM(TO_CHAR(nIdPoliza)));
       END IF;
         END IF;
      END IF;

      --INICIA LAVDIN
      IF NVL(nCodCliente,0) != 0 THEN
         IF cPldstaprobada = 'N'  THEN
            OC_ADMON_RIESGO.VALIDA_PERSONAS_POLIZA(nIdPoliza,cMensaje);
            IF cMensaje IS NOT NULL THEN
               RAISE_APPLICATION_ERROR(-20226,cMensaje);
            END IF;
         END IF;
      ELSE
         RAISE_APPLICATION_ERROR(-20200,'Póliza No. ' || nIdPoliza ||
         'NO tiene Código de Cliente o Contratante - NO Puede Emitir la Póliza');
      END IF;
      --FIN LAVDIN
      --
      --INICIA INCIAGE
      NUNPRICIPAL := 0;
      --
      SELECT COUNT(*)
        INTO NUNPRICIPAL
        FROM AGENTE_POLIZA
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdPoliza
         AND IND_PRINCIPAL = 'S';
      --
      IF NVL(NUNPRICIPAL,0) > 1 THEN
         RAISE_APPLICATION_ERROR(-20200,'No puede haber mas de un agente marcado como principal en la poliza');
      END IF;
      --FIN INCIAGE

      IF cNumPolUnico IS NOT NULL THEN
         SELECT COUNT(*)
      INTO nCantPol
      FROM POLIZAS
          WHERE CodCia       = nCodCia
       AND NumPolUnico  = cNumPolUnico
       AND StsPoliza   IN ('EMI','SOL')
       AND IdPoliza    != nIdPoliza;

         IF NVL(nCantPol,0) > 0 THEN
       RAISE_APPLICATION_ERROR(-20200,'No. de Póliza Unico YA fue Asignado para otra Póliza que está Emitida o en Solicitud.');
         END IF;
      END IF;

      IF cTipoAdministracion IS NULL AND cIndManejaFondos = 'N' THEN
         RAISE_APPLICATION_ERROR(-20200,'Debe Asignar el Tipo de Administración de la Póliza');
      END IF;

      IF cIndManejaFondos = 'S' THEN
         IF NVL(nIdFormaCobro,0) = 0 THEN
       RAISE_APPLICATION_ERROR(-20200,'Debe Asignar la Forma o Medio de Cobro para la Póliza');
         END IF;

         IF OC_PERSONA_NATURAL_JURIDICA.EMAIL(cTipo_Doc_Identificacion, cNum_Doc_Identificacion) IS NULL THEN
       RAISE_APPLICATION_ERROR(-20200,'Debe Ingresar el Email para el Contratante de la Póliza en Persona Natural Jurídica');
         END IF;
      END IF;

      IF cIndFactElectronica = 'S' AND cIndFacturaPol = 'S' THEN
         cNum_TributarioCli := OC_CLIENTES.IDENTIFICACION_TRIBUTARIA(nCodCliente);
      END IF;

      SELECT COUNT(*)
        INTO nRegisA
        FROM AGENTES_DISTRIBUCION_POLIZA
       WHERE IdPoliza = nIdPoliza
         AND CodCia   = nCodCia;

      IF NVL(nRegisA,0) = 0 THEN
         RAISE_APPLICATION_ERROR(-20200,'No ha Ingresado Distribución de Agentes a Nivel Póliza');
      END IF;

      SELECT COUNT(*)
        INTO nRegisA
        FROM AGENTES_DETALLES_POLIZAS
       WHERE IdPoliza = nIdPoliza
         AND CodCia   = nCodCia;

      IF NVL(nRegisA,0) = 0 THEN
         RAISE_APPLICATION_ERROR(-20200,'No ha Ingresado Agentes a Nivel de Detalle o Certificado');
      END IF;

      FOR R IN AGT_Q LOOP
         FOR T IN DET_Q LOOP
       IF T.FecIniVig < dFecIniVig THEN
          RAISE_APPLICATION_ERROR(-20200,'Fecha de Inicio de Vigencia del ' || TO_CHAR(T.FecIniVig,'DD/MM/RRRR') ||
                   ' en el SubGrupo No. ' || T.IDetPol || ' Es MENOR a la Fecha de Inicio de Vigencia de la Póliza ' ||
                   TO_CHAR(dFecIniVig,'DD/MM/RRRR'));
       ELSIF T.FecIniVig > dFecFinVig THEN
          RAISE_APPLICATION_ERROR(-20200,'Fecha de Inicio de Vigencia del ' || TO_CHAR(T.FecIniVig,'DD/MM/RRRR') ||
                   ' en el SubGrupo No. ' || T.IDetPol || ' Es MAYOR a la Fecha de Fin de Vigencia de la Póliza ' ||
                   TO_CHAR(dFecFinVig,'DD/MM/RRRR'));
       ELSIF T.FecFinVig > dFecFinVig THEN
          RAISE_APPLICATION_ERROR(-20200,'Fecha de Fin de Vigencia al ' || TO_CHAR(T.FecFinVig,'DD/MM/RRRR') ||
                   ' en el SubGrupo No. ' || T.IDetPol || ' Es MAYOR a la Fecha de Fin de Vigencia de la Póliza ' ||
                   TO_CHAR(dFecFinVig,'DD/MM/RRRR'));
       END IF;

       IF OC_TIPOS_DE_SEGUROS.MANEJA_FONDOS(nCodCia, T.CodEmpresa, T.IdTipoSeg) = 'S' THEN
          IF GT_FAI_TIPOS_FONDOS_PRODUCTOS.FONDOS_COLECTIVOS(nCodCia, T.CodEmpresa, T.IdTipoSeg, T.PlanCob) = 'N' THEN  -- GTC - 06/02/2019
             IF GT_FAI_FONDOS_DETALLE_POLIZA.VALIDA_FONDOS(nCodCia, T.CodEmpresa, nIdPoliza, T.IDetPol, T.Cod_Asegurado) = 'N' THEN
           RAISE_APPLICATION_ERROR(-20200,'Revise Configuración de Fondos de Ahorro e Inversión al SubGrupo No. ' || T.IDetPol);
             END IF;
          END IF;

          IF OC_PERSONA_NATURAL_JURIDICA.EMAIL(T.Tipo_Doc_Identificacion, T.Num_Doc_Identificacion) IS NULL THEN
             RAISE_APPLICATION_ERROR(-20200,'Debe Ingresar el Email en Persona Natural Jurídica para el Asegurado del SubGrupo No. ' || T.IDetPol);
          END IF;

          IF T.IdFormaCobro IS NOT NULL THEN
             IF NVL(nDiaCobroAutomatico,0) = 0 AND
           OC_MEDIOS_DE_COBRO.FORMA_DE_COBRO(T.Tipo_Doc_Identificacion, T.Num_Doc_Identificacion, T.IdFormaCobro) IN ('CTC', 'DOMI', 'CLAB') THEN
           RAISE_APPLICATION_ERROR(-20200,'Debe Indicar el Día para Cobranza Automática en la Póliza No. ' || nIdPoliza);
             END IF;
          END IF;
       END IF;

       SELECT NVL(SUM(Porc_Com_Proporcional),0), NVL(SUM(Porc_Com_Distribuida),0), NVL(SUM(Porc_Comision_Agente),0)
         INTO nPorcComProporcional, nPorc_Com_Distribuida, nPorc_Comision_Agente
         FROM AGENTES_DISTRIBUCION_COMISION
        WHERE Cod_Agente        = R.Cod_Agente
          AND Cod_Agente_Distr  = R.Cod_Agente_Distr
          AND IDetPol           = T.IDetPol
          AND IdPoliza          = nIdPoliza
          AND CodCia            = nCodCia;

       IF NVL(R.Porc_Com_Proporcional,0) != nPorcComProporcional THEN
          RAISE_APPLICATION_ERROR(-20200,'Comisión Proporcional del ' || NVL(R.Porc_Com_Proporcional,0) ||
                   '% para el Agente ' || R.Cod_Agente_Distr ||
                   ' a Nivel de Detalle o Certificado No. ' || T.IDetPol || ' NO es Igual a la Comisión Proporcional del ' ||
                   nPorcComProporcional || '% a Nivel Póliza');
       ELSIF NVL(R.Porc_Com_Distribuida,0) != nPorc_Com_Distribuida THEN
          RAISE_APPLICATION_ERROR(-20200,'Comisión Distribuida del ' || NVL(R.Porc_Com_Distribuida,0) ||
                   '% para el Agente ' || R.Cod_Agente_Distr ||
                   ' a Nivel de Detalle o Certificado No. ' || T.IDetPol || ' NO es Igual a la Comisión Distribuida del ' ||
                   nPorc_Com_Distribuida || '% a Nivel Póliza');
       ELSIF NVL(R.Porc_Comision_Agente,0) != nPorc_Comision_Agente THEN
          RAISE_APPLICATION_ERROR(-20200,'Comisión del ' || NVL(R.Porc_Comision_Agente,0) ||
                   '% para el Agente ' || R.Cod_Agente_Distr ||
                   ' a Nivel de Detalle o Certificado No. ' || T.IDetPol || ' NO es Igual a la Comisión del ' ||
                   nPorc_Comision_Agente || '% a Nivel Póliza');
       END IF;
         END LOOP;
      END LOOP;

      BEGIN
         SELECT DISTINCT IdTipoSeg, PlanCob
      INTO cIdTipoSeg, cPlanCob
      FROM DETALLE_POLIZA
          WHERE IdPoliza = nIdPoliza
       AND CodCia   = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20200,'No ha Ingresado Certificados/Subgrupos a la Póliza');
         WHEN TOO_MANY_ROWS THEN
       RAISE_APPLICATION_ERROR(-20200,'Asignó Diferentes Tipos de Seguros o Planes de Cobertura a los Certificados/Subgrupos a la Póliza');
      END;

      FOR W IN DET_Q LOOP
         nEdad   := OC_ASEGURADO.EDAD_ASEGURADO(nCodCia, W.CodEmpresa, W.Cod_Asegurado, dFecIniVig);

         SELECT COUNT(*)
      INTO nRegis
      FROM COBERT_ACT C, COBERTURAS_DE_SEGUROS CS
          WHERE CS.Edad_Maxima < nEdad
       AND CS.CodCobert   = C.CodCobert
       AND CS.PlanCob     = C.PlanCob
       AND CS.IdTipoSeg   = C.IdTipoSeg
       AND CS.CodEmpresa  = C.CodEmpresa
       AND CS.CodCia      = C.CodCia
       AND C.IdPoliza     = nIdPoliza
       AND C.IDetPol      = W.IDetPol
       AND C.CodCia       = nCodCia;

         IF nRegis != 0 THEN
       RAISE_APPLICATION_ERROR(-20200,'El Detalle No. ' || W.IDetPol ||
                ' Posee Coberturas fuera el Rango de Aceptación para la Edad ' || nEdad);
         END IF;

         SELECT COUNT(*)
      INTO nRegis
      FROM COBERT_ACT
          WHERE SumaAseg_Moneda <= 0
       AND IdPoliza         = nIdPoliza
       AND IDetPol          = W.IDetPol
       AND CodCia           = nCodCia;

         IF nRegis != 0 THEN
       RAISE_APPLICATION_ERROR(-20200,'El Detalle No. ' || W.IDetPol || ' Posee ' || nRegis ||
                'Cobertura(s) ccn Suma Asegurado Igual o Menor a Cero ');
         END IF;

         FOR R IN AGT_Q LOOP
       SELECT NVL(SUM(Porc_Com_Proporcional),0)
         INTO nPorcComProporcional
         FROM AGENTES_DISTRIBUCION_COMISION
        WHERE IdPoliza   = nIdPoliza
          AND IDetPol    = W.IDetPol
          AND CodCia     = nCodCia
          AND Cod_Agente = R.Cod_Agente;

       IF NVL(nPorcComProporcional,0) != 100 THEN
          RAISE_APPLICATION_ERROR(-20200,'La Distribución del Agente ' || R.Cod_Agente || ' en el Detalle No. ' || W.IDetPol ||
                   ' Porc.com.propor - '||nPorcComProporcional||
                   ' NO tiene el 100% de Distribución para Comisiones');
       END IF;
         END LOOP;

         SELECT NVL(SUM(Porc_Com_Distribuida),0)
      INTO nPorc_Com_Distribuida
      FROM AGENTES_DISTRIBUCION_COMISION
          WHERE IdPoliza = nIdPoliza
       AND IDetPol  = W.IDetPol
       AND CodCia   = nCodCia;

         IF NVL(nPorc_Com_Distribuida,0) != W.PorcComis THEN
       RAISE_APPLICATION_ERROR(-20200,'La Distribución de Agentes en el Detalle No. ' || W.IDetPol ||
                ' NO Corresponde con el % de Comisión del Detalle/Subgrupo del ' || W.PorcComis || '%');
         END IF;

         IF W.IndFactElectronica = 'S' AND cIndFacturaPol = 'N' THEN
       BEGIN
          SELECT DECODE(Tipo_Doc_Identificacion,'RFC',Num_Doc_Identificacion,Num_Tributario)
            INTO cNum_TributarioCli
            FROM PERSONA_NATURAL_JURIDICA
           WHERE Tipo_Doc_Identificacion = W.Tipo_Doc_Identificacion
             AND Num_Doc_Identificacion  = W.Num_Doc_Identificacion;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR(-20225,'No Existe Asegurado: '||TRIM(TO_CHAR(W.Cod_Asegurado)) || ' en Persona Natural Juridica');
       END;
       IF cNum_TributarioCli IS NULL THEN
          RAISE_APPLICATION_ERROR(-20225,'Asegurado: '||TRIM(TO_CHAR(W.Cod_Asegurado)) || ' No Posee Identificación Tributaria');
       END IF;
         END IF;
      END LOOP;

      FOR W IN ASEG_Q LOOP
         nEdad   := OC_ASEGURADO.EDAD_ASEGURADO(nCodCia, W.CodEmpresa, W.Cod_Asegurado, dFecIniVig);

         SELECT COUNT(*)
      INTO nRegis
      FROM COBERT_ACT_ASEG C, COBERTURAS_DE_SEGUROS CS
          WHERE CS.Edad_Maxima  < nEdad
       AND CS.CodCobert    = C.CodCobert
       AND CS.PlanCob      = C.PlanCob
       AND CS.IdTipoSeg    = C.IdTipoSeg
       AND CS.CodEmpresa   = C.CodEmpresa
       AND CS.CodCia       = C.CodCia
       AND C.IdPoliza      = nIdPoliza
       AND C.IDetPol       = W.IDetPol
       AND C.Cod_Asegurado = W.Cod_Asegurado
       AND C.CodCia        = nCodCia;

         IF nRegis != 0 THEN
       RAISE_APPLICATION_ERROR(-20200,'El Asegurado No. ' || W.Cod_Asegurado || ' del Certificado No. ' || W.IDetPol ||
                ' Posee Coberturas fuera el Rango de Aceptación para la Edad ' || nEdad);
         END IF;

         SELECT COUNT(*)
      INTO nRegis
      FROM COBERT_ACT
          WHERE SumaAseg_Moneda <= 0
       AND Cod_Asegurado    = W.Cod_Asegurado
       AND IdPoliza         = nIdPoliza
       AND IDetPol          = W.IDetPol
       AND CodCia           = nCodCia;

         IF nRegis != 0 THEN
       RAISE_APPLICATION_ERROR(-20200,'El Asegurado No. ' || W.Cod_Asegurado || ' del Certificado No. ' || W.IDetPol ||
                ' Posee ' || nRegis || 'Cobertura(s) ccn Suma Asegurado Igual o Menor a Cero');
         END IF;

         IF OC_TIPOS_DE_SEGUROS.MANEJA_FONDOS(nCodCia, nCodEmpresa, cIdTipoSeg) = 'S' THEN -- GTC - 06/02/2019
       IF GT_FAI_TIPOS_FONDOS_PRODUCTOS.FONDOS_COLECTIVOS(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob) = 'S' THEN
          IF GT_FAI_FONDOS_DETALLE_POLIZA.VALIDA_FONDOS(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol, W.Cod_Asegurado) = 'N' THEN
             RAISE_APPLICATION_ERROR(-20200,'Revise Configuración de Fondos de Ahorro e Inversión al SubGrupo No. ' || W.IDetPol ||
                      ' y el Asegurado No. ' || W.Cod_Asegurado);
          END IF;
       END IF;
         END IF;
      END LOOP;

      SELECT COUNT(*), SUM(SumaAseg_Local)
        INTO nRegis, nSumaAsegCob
        FROM COBERT_ACT
       WHERE IdPoliza = nIdPoliza
         AND CodCia   = nCodCia
         AND IdEndoso = 0;

      SELECT COUNT(*), SUM(SumaAseg_Local)
        INTO nRegisAs, nSumaAsegAseg
        FROM COBERT_ACT_ASEG
       WHERE IdPoliza = nIdPoliza
         AND CodCia   = nCodCia
         AND IdEndoso = 0;

      SELECT COUNT(*)
        INTO nRequisitos
        FROM REQUISITOS_POLIZA REP, REQUISITOS REQ
       WHERE REP.CodRequisito   = REQ.CodRequisito
         AND REQ.IndOblig       = 'S'
         AND REP.FecEntregaReq IS NULL
         AND REP.IdPoliza       = nIdPoliza
         AND REP.CodCia         = nCodCia;

      IF NVL(nRequisitos,0) != 0 THEN
         RAISE_APPLICATION_ERROR(-20200,'No puede Emitir la Póliza porque tiene Requisitos Pendientes de Entrega');
      END IF;

      IF cTipoPol != 'F' THEN
         IF NVL(nRegis,0) > 0 OR NVL(nRegisAs,0) > 0  THEN
       IF NVL(nSumaAsegCob,0) = NVL(nSumaAseg,0)  OR NVL(nSumaAsegAseg,0) = NVL(nSumaAseg,0) THEN
          IF NVL(cIndExaInsp,'N') IN ('E','I') THEN
             SELECT NVL(COUNT(*),0)
          INTO nExamInsp
          FROM (SELECT 1
             FROM EXAMEN
            WHERE IdPoliza = nIdPoliza
              AND CodCia   = nCodCia
            UNION
                SELECT 1
             FROM INSPECCION
            WHERE IdPoliza = nIdPoliza
              AND CodCia   = nCodCia);
             IF NVL(nExamInsp,0) = 0 THEN
           IF NVL(cIndExaInsp,'N') = 'E' THEN
              RAISE_APPLICATION_ERROR(-20200,'Esta Póliza requiere Datos de Exámenes');
           ELSE
              RAISE_APPLICATION_ERROR(-20200,'Esta Póliza requiere Datos de Inspección');
           END IF;
             ELSE
           nEmite := 'S';
             END IF;
          ELSE
             nEmite := 'S';
          END IF;
       ELSE
          RAISE_APPLICATION_ERROR(-20200,'Suma Asegurada de COBERTURAS no coincide con Suma Asegurada de la Póliza');
       END IF;
         ELSE
       RAISE_APPLICATION_ERROR(-20200,'Debe grabarle COBERTURAS a la Póliza');
         END IF;
      ELSE
        nEmite := 'S';
      END IF;
      RETURN(nEmite);
   END VALIDA_POLIZA;

   FUNCTION VALIDA_FIANZA(nCodCia NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER) RETURN VARCHAR2 IS
   cTipoFianza   FZ_DETALLE_FIANZAS.TipoFianza%TYPE;
   nCorrelativo  FZ_DETALLE_FIANZAS.Correlativo%TYPE;
   cCodContrato  FZ_DETALLE_FIANZAS.CodContrato%TYPE;
   cCodProyecto  FZ_DETALLE_FIANZAS.CodProyecto%TYPE;
   cEmite        VARCHAR2(1):='N';
   CURSOR C_DETALLE IS
      SELECT TipoFianza,Correlativo,CodContrato, CodProyecto
        FROM FZ_DETALLE_FIANZAS
       WHERE IdPoliza    = nIdPoliza
         AND CodCia      = nCodCia
         AND Correlativo = nIdetPol
         AND Estado      = 'SOL';
   BEGIN
      BEGIN
         SELECT 'S', TipoFianza, Correlativo, CodContrato, CodProyecto
      INTO cEmite, cTipoFianza, nCorrelativo, cCodContrato, cCodProyecto
      FROM FZ_DETALLE_FIANZAS
          WHERE IdPoliza    = nIdPoliza
       AND CodCia      = nCodCia
       AND Correlativo = nIdetPol
       AND Estado      = 'SOL';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
       cEmite :='N';
      END;
      IF cTipoFianza != '005' AND cCodContrato IS NULL THEN
         RAISE_APPLICATION_ERROR(-20200,'Debe asignarle un Contrato Válido a la Póliza que desea Emitir');
      ELSIF cTipoFianza = '005' AND cCodProyecto IS NULL THEN
         RAISE_APPLICATION_ERROR(-20200,'Debe asignarle un Proyecto Válido a la Póliza que desea Emitir');
      END IF;
      RETURN(cEmite);
   END VALIDA_FIANZA;

   PROCEDURE EMITIR_POLIZA(nCodCia NUMBER, nIdPoliza NUMBER, nCodEmpresa NUMBER) IS
   dFecHoy          DATE := TRUNC(SYSDATE);
   nPorcAgtes       NUMBER;
   cPrima           POLIZAS.PrimaNeta_Local%TYPE;
   nIdTransac       TRANSACCION.IdTransaccion%TYPE;
   cTipoPol         POLIZAS.TipoPol%TYPE;
   cCodPlanPago     POLIZAS.CodPlanPago%TYPE;
   cNumPolRef       POLIZAS.NumPolRef%TYPE;
   cIndPolCol       POLIZAS.IndPolCol%TYPE;
   cIndDeclara      DETALLE_POLIZA.IndDeclara%TYPE;
   cIndFactPeriodo  POLIZAS.IndFactPeriodo%TYPE;
   cIndFacturaPol   POLIZAS.IndFacturaPol%TYPE;
   nIDetPol         DETALLE_POLIZA.IDetPol%TYPE;
   nNum_Cotizacion  POLIZAS.Num_Cotizacion%TYPE;
   CID_PREPAGO      TIPOS_DE_SEGUROS.ID_PREPAGO%TYPE;  -- -- PREEMI
   --
   CURSOR DET_Q IS
      SELECT IDetPol, IndDeclara, Cod_Asegurado, HabitoTarifa
        FROM DETALLE_POLIZA
       WHERE IdPoliza = nIdPoliza
         AND CodCia   = nCodCia
       UNION ALL
      SELECT Correlativo IDetPol, '' IndDeclara, 0 Cod_Asegurado, 'NA' HabitoTarifa
        FROM FZ_DETALLE_FIANZAS
       WHERE IdPoliza = nIdPoliza
         AND CodCia   = nCodCia;

   CURSOR ASEG_Q IS
      SELECT IDetPol, Cod_Asegurado
        FROM ASEGURADO_CERTIFICADO
       WHERE IdPoliza = nIdPoliza
         AND CodCia   = nCodCia;

   CURSOR FONDOS_Q IS
      SELECT IdFondo
        FROM FAI_FONDOS_DETALLE_POLIZA
       WHERE CodAsegurado > 0
         AND IDetPol      = nIDetPol
         AND IdPoliza     = nIdPoliza
         AND CodEmpresa   = nCodEmpresa
         AND CodCia       = nCodCia;
   --
   BEGIN
      SELECT TipoPol, CodPlanPago, NumPolRef, IndPolCol,
        IndFactPeriodo, IndFacturaPol, Num_Cotizacion
        INTO cTipoPol, cCodPlanPago, cNumPolRef, cIndPolCol,
        cIndFactPeriodo, cIndFacturaPol, nNum_Cotizacion
        FROM POLIZAS
       WHERE IdPoliza = nIdPoliza
         AND CodCia   = nCodCia;
      IF cTipoPol != 'F' THEN
         BEGIN   -- LARPLA  INICIO
      SELECT NVL(IndDeclara,'N'), TS.ID_PREPAGO
        INTO cIndDeclara,         CID_PREPAGO         -- PREEMI
        FROM DETALLE_POLIZA D,
             TIPOS_DE_SEGUROS TS
       WHERE D.IdPoliza  = nIdPoliza
         AND D.CodCia    = nCodCia
         AND D.IDETPOL = (SELECT MIN(D1.IDETPOL)
                  FROM DETALLE_POLIZA D1
                 WHERE D1.IdPoliza = D.IdPoliza
                   AND D1.CodCia   = D.CodCia)
         --
         AND TS.IDTIPOSEG = D.IDTIPOSEG;
         EXCEPTION
       WHEN NO_DATA_FOUND THEN
            cIndDeclara := 'N';
       WHEN TOO_MANY_ROWS THEN
            cIndDeclara := 'N';
       WHEN OTHERS THEN
            cIndDeclara := 'N';
         END;    -- LARPLA  FIN
      END IF;

      IF OC_POLIZAS.VALIDA_POLIZA(nCodCia, nIdPoliza) = 'S' THEN
         FOR X IN DET_Q LOOP
       nPorcAgtes := 0;
       BEGIN
           SELECT SUM(Porc_Comision)
             INTO nPorcAgtes
             FROM AGENTES_DETALLES_POLIZAS
            WHERE IdPoliza = nIdPoliza
         AND IdetPol  = X.IDetPol
         AND CodCia   = nCodCia;
       END;

       IF NVL(nPorcAgtes,0) != 100 THEN
           RAISE_APPLICATION_ERROR(-20200,'No puede Emitir la Póliza porque el Detalle de Póliza No. '|| X.IdetPol ||
                    ', Suma ' || NVL(nPorcAgtes,0) ||' en los Agentes Participantes');
       END IF;
       IF cTipoPol = 'F' THEN
           IF OC_POLIZAS.VALIDA_FIANZA(nCodCia, nIdPoliza, X.IDetPol) != 'S' THEN
         RAISE_APPLICATION_ERROR(-20200,'No puede Emitir la Fianza porque Faltan Datos al Detalle '||X.IDetPol);
           END IF;
       END IF;
         END LOOP;

         SELECT SUM(PrimaNeta_Local)
      INTO cPrima
      FROM POLIZAS
          WHERE IdPoliza = nIdPoliza;

         IF cTipoPol != 'F' THEN
       UPDATE RESPONSABLE_PAGO_POL
          SET StsResPago = 'ACT'
        WHERE IdPoliza   = nIdPoliza
          AND CodCia     = nCodCia;

       UPDATE RESPONSABLE_PAGO_DET
          SET StsResPago = 'ACT'
        WHERE IdPoliza   = nIdPoliza
          AND CodCia     = nCodCia;
         END IF;
        
        dbms_output.put_line('nIdPoliza: ' || nIdPoliza || ' cIndFacturaPol: ' || cIndFacturaPol || ' cCodPlanPago: ' || cCodPlanPago || ' cTipoPol: ' || cTipoPol || ' cIndFactPeriodo: ' || cIndFactPeriodo);
        
         IF cIndFacturaPol = 'S' THEN
       nIdTransac := OC_TRANSACCION.CREA(nCodCia,  nCodEmpresa, 7, 'POL');
       OC_DETALLE_TRANSACCION.CREA (nIdTransac, nCodCia, nCodEmpresa, 7, 'POL', 'POLIZAS',
                     nIdPoliza, NULL, NULL, NULL, cPrima);

       OC_FACTURAR.PROC_EMITE_FACT_POL(nIdPoliza, 0, nCodCia, nIdTransac);
         ELSE
       IF cCodPlanPago IS NOT NULL AND cTipoPol != 'F' THEN
          nIdTransac :=  OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 7, 'POL');
          OC_DETALLE_TRANSACCION.CREA (nIdTransac, nCodCia, nCodEmpresa, 7, 'POL', 'POLIZAS',
                   nIdPoliza, NULL, NULL, NULL, cPrima);

          IF NVL(cIndFactPeriodo,'N') = 'N' THEN
             IF cIndDeclara = 'S' THEN
           OC_FACTURAR.PROC_EMITE_FACT_MENSUAL(nIdPoliza, 0, nCodCia, nIdTransac,1);
             ELSE
          OC_FACTURAR.PROC_EMITE_FACTURAS(nIdPoliza, 0, nCodCia, nIdTransac);
             END IF;
          ELSE
             OC_FACTURAR.PROC_EMITE_FACT_PERIODO(nIdPoliza, 0, nCodCia, nIdTransac,1);
          END IF;
       ELSIF cCodPlanPago IS NOT NULL AND cTipoPol = 'F' THEN
          BEGIN
             OC_FACTURAR.PROC_FACT_FIANZA(nIdPoliza, 0, nCodCia,nIdTransac);
          EXCEPTION
             WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20200,'Error en Proceso de Facturación Fianza. Favor verifique'|| SQLERRM);
          END ;
       END IF;
         END IF;
         OC_SEGUIMIENTO.INSERTA_SEGUIMIENTO(nIdPoliza, NULL,NULL);
         OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransac, 'C');

         UPDATE FZ_DETALLE_FIANZAS
       SET Estado = 'EMI'
          WHERE IdPoliza = nIdPoliza
       AND CodCia   = nCodCia;

         IF cTipoPol != 'F' THEN
       OC_CLAUSULAS_POLIZA.EMITIR_TODAS(nCodCia, nIdPoliza);

       UPDATE DATOS_PART_EMISION
          SET StsDatPart = 'EMI'
        WHERE IdPoliza   = nIdPoliza
          AND CodCia     = nCodCia;

       FOR W IN DET_Q LOOP
          OC_DETALLE_POLIZA.EMITIR(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol);
          OC_COBERT_ACT.EMITIR(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol, 0);
          OC_ASISTENCIAS_DETALLE_POLIZA.EMITIR(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol, 0);
          OC_BENEFICIARIO.ACTIVAR(nIdPoliza, W.IDetPol, W.Cod_Asegurado);
          OC_CLAUSULAS_DETALLE.EMITIR_TODAS(nCodCia, nIdPoliza, W.IDetPol);
          nIDetPol := W.IDetPol;
          FOR F IN FONDOS_Q LOOP
             GT_FAI_FONDOS_DETALLE_POLIZA.EMITIR(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol, W.Cod_Asegurado, F.IdFondo);
          END LOOP;
           ---valida si tiene habito para generar valores
          IF NVL(w.HabitoTarifa, 'NA') != 'NA' THEN
             GT_TAB_VALORES_GARANTIZADOS.INSERTA(nCodCia, nCodEmpresa, nIdPoliza,W.IDetPol,0,W.Cod_Asegurado,1);
          END IF;
       END LOOP;

       FOR Z IN ASEG_Q LOOP
          OC_COBERT_ACT_ASEG.EMITIR(nCodCia, nCodEmpresa, nIdPoliza, Z.IDetPol, Z.Cod_Asegurado, 0);
          OC_ASISTENCIAS_ASEGURADO.EMITIR(nCodCia, nCodEmpresa, nIdPoliza, Z.IDetPol, Z.Cod_Asegurado, 0);
          OC_ASEGURADO_CERTIFICADO.EMITIR(nCodCia, nIdPoliza, Z.IDetPol, Z.Cod_Asegurado, 0);
          OC_BENEFICIARIO.ACTIVAR(nIdPoliza, Z.IDetPol, Z.Cod_Asegurado);
       END LOOP;

       OC_SOLICITUD_EMISION.EMITIR(nCodCia, nCodEmpresa, nIdPoliza);
       IF GT_COTIZACIONES.EXISTE_COTIZACION_EMITIDA(nCodCia, nCodEmpresa, nNum_Cotizacion) = 'S' THEN
          GT_COTIZACIONES.EMISION_POLIZA(nCodCia, nCodEmpresa, nNum_Cotizacion, nIdPoliza);
       END IF;

       BEGIN
          UPDATE TAREA
             SET Estado_Final     = 'EJE',
            FechadeRealizado = SYSDATE,
            UsuarioRealizo   = USER,
            Estado           = 'EJE'
           WHERE IdPoliza = nIdPoliza
             AND CodCia   = nCodCia
             AND Estado   = 'PRO';
       EXCEPTION
          WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR(-20200,'Error en Tarea de Póliza No. '|| cNumPolRef ||SQLERRM);
       END;
       -- Realiza Distribución al Reaseguro
       IF cTipoPol != 'F' THEN
          GT_REA_DISTRIBUCION.DISTRIBUYE_REASEGURO(nCodCia, nCodEmpresa, nIdPoliza, nIdTransac, TRUNC(SYSDATE), 'EMISION');
          /*IF GT_REA_DISTRIBUCION.DISTRIB_FACULTATIVA_PEND(nCodCia, nIdTransac) = 'S' THEN
             RAISE_APPLICATION_ERROR(-20200,'Poliza No. '|| cNumPolRef || ' Posee Distribución Facultativa Pendiente');
          END IF;*/
       END IF;

       UPDATE POLIZAS
          SET StsPoliza  = 'EMI',
         FecSts     = dFecHoy,
         FecEmision = dFecHoy
        WHERE IdPoliza = nIdPoliza
          AND CodCia   = nCodCia;
        --
        IF CID_PREPAGO = 'S' THEN     -- PREEMI
           --
           PRE_EMITE_POLIZA(nCodCia, nCodEmpresa, nIdPoliza, nIdTransac);
           --
        END IF;                      -- PREEMI

         END IF;
      END IF;
   END EMITIR_POLIZA;

   PROCEDURE INSERTA_REQUISITOS(nCodCia NUMBER, nIdPoliza NUMBER) IS
   nIDetPol     DETALLE_POLIZA.IDetPol%TYPE;
   cIdTipoSeg   DETALLE_POLIZA.IdTipoSeg%TYPE;
   CURSOR DET_Q IS
      SELECT DISTINCT IDetPol, IdTipoSeg
        FROM DETALLE_POLIZA
       WHERE CodCia   = nCodCia
         AND IdPoliza = nIdPoliza;

   CURSOR REQ_Q IS
      SELECT RS.CodRequisito
        FROM REQUISITOS_SEGUROS RS, REQUISITOS R
       WHERE RS.IdTipoSeg    = cIdTipoSeg
         AND R.CodRequisito  = RS.CodRequisito
         AND R.UsoRequisito IN ('T','E')
         AND R.IndOblig      = 'S'
       MINUS
      SELECT RP.CodRequisito
        FROM REQUISITOS_POLIZA RP
       WHERE RP.IdPoliza  = nIdPoliza
         AND RP.IdeTpol   = nIDetPol;
   BEGIN
      FOR Y IN DET_Q LOOP
         nIDetPol   := Y.IDetPol;
         cIdTipoSeg := Y.IdTipoSeg;
         FOR X IN REQ_Q LOOP
       INSERT INTO REQUISITOS_POLIZA
         (IdPoliza, IdeTpol, CodRequisito, FecSolicitReq, FecEntregaReq, Observaciones, CodUsuario, CodCia)
       VALUES (nIdPoliza, nIDetPol, X.CodRequisito, SYSDATE, SYSDATE, NULL, NULL, nCodCia );
         END LOOP;
      END LOOP;
   END INSERTA_REQUISITOS;

   /*PROCEDURE ANULAR_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, dFecAnul DATE,
            cMotivAnul VARCHAR2, cContabilidad_Automatica VARCHAR2, cCod_Moneda VARCHAR2) IS
   nIdTransacNc         TRANSACCION.IdTransaccion%TYPE;
   nIdTransacAnul       TRANSACCION.IdTransaccion%TYPE;
   nPrima               POLIZAS.PrimaNeta_Moneda%TYPE;
   nPrimaCanc           POLIZAS.PrimaNeta_Moneda%TYPE;
   dFecIniVig           POLIZAS.FecIniVig%TYPE;
   dFecFinVig           POLIZAS.FecFinVig%TYPE;
   nTotPrimaCanc        DETALLE_FACTURAS.Saldo_Det_Moneda%TYPE;
   nTotPrimaFact        DETALLE_FACTURAS.Saldo_Det_Moneda%TYPE;
   nTotNotaCredCanc     DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
   nIdNcr               NOTAS_DE_CREDITO.IdNcr%TYPE;
   nCodCliente          POLIZAS.CodCliente%TYPE;
   nMtoNcrLocal         NOTAS_DE_CREDITO.Monto_NCR_Local%TYPE;
   nMtoNcrMoneda        NOTAS_DE_CREDITO.Monto_NCR_Moneda%TYPE;
   nMtoComisLocal       NOTAS_DE_CREDITO.MtoComisi_Local%TYPE;
   nMtoComisMoneda      NOTAS_DE_CREDITO.MtoComisi_Moneda%TYPE;
   nPorcComis           POLIZAS.PorcComis%TYPE;
   cCodPlanPago         POLIZAS.CodPlanPago%TYPE;
   nTasaCambio          TASAS_CAMBIO.Tasa_Cambio%TYPE;
   cTipoPol             POLIZAS.TipoPol%TYPE;
   cNumPolRef           POLIZAS.NumPolRef%TYPE;
   cIndFactElectronica  POLIZAS.IndFactElectronica%TYPE;
   nPorcPrima           NUMBER(10,6);
   nDiasAnul            NUMBER(6);
   nFactProrrata        NUMBER(11,8);
   nFactor              NUMBER (14,8);
   cContabiliza         VARCHAR2(1);

   CURSOR FAC_Q IS
      SELECT IdetPol, IdFactura, CodCia, CodCobrador
        FROM FACTURAS
       WHERE IdPoliza = nIdPoliza
         AND StsFact  = 'EMI';
   CURSOR NCR_Q IS
      SELECT IdNcr, CodCia, IdPoliza, IDetPol, IdEndoso
        FROM NOTAS_DE_CREDITO
       WHERE IdPoliza = nIdPoliza
         AND StsNcr   = 'EMI';
   CURSOR AGENTES_Q IS
      SELECT D.IDetPol, D.Prima_Local, D.Prima_Moneda, A.IdTipoSeg, A.Cod_Agente, A.Porc_Comision
        FROM AGENTES_DETALLES_POLIZAS A, DETALLE_POLIZA D
       WHERE A.IDetPol    = D.IDetPol
         AND A.IdPoliza   = D.IdPoliza
         AND D.StsDetalle = 'EMI'
         AND D.IdPoliza   = nIdPoliza;
   CURSOR CPTO_PRIMAS_Q IS
      SELECT CS.CodCpto, SUM(C.Prima_Local) Prima_Local, SUM(C.Prima_Moneda) Prima_Moneda
        FROM COBERT_ACT C, COBERTURAS_DE_SEGUROS CS
       WHERE CS.CodCobert  = C.CodCobert
         AND CS.PlanCob    = C.PlanCob
         AND CS.IdTipoSeg  = C.IdTipoSeg
         AND CS.CodEmpresa = C.CodEmpresa
         AND CS.CodCia     = C.CodCia
         AND C.IdPoliza    = nIdPoliza
         AND C.CodCia      = nCodCia
       GROUP BY CS.CodCpto
       UNION
      SELECT CS.CodCpto, SUM(C.Prima_Local) Prima_Local, SUM(C.Prima_Moneda) Prima_Moneda
        FROM COBERT_ACT_ASEG C, COBERTURAS_DE_SEGUROS CS
       WHERE CS.CodCobert  = C.CodCobert
         AND CS.PlanCob    = C.PlanCob
         AND CS.IdTipoSeg  = C.IdTipoSeg
         AND CS.CodEmpresa = C.CodEmpresa
         AND CS.CodCia     = C.CodCia
         AND C.IdPoliza    = nIdPoliza
         AND C.CodCia      = nCodCia
       GROUP BY CS.CodCpto;
   CURSOR CPTO_ASIST_Q IS
      SELECT T.CodCptoServicio, SUM(A.MontoAsistLocal) MontoAsistLocal,
        SUM(A.MontoAsistMoneda) MontoAsistMoneda
        FROM ASISTENCIAS_DETALLE_POLIZA A, DETALLE_POLIZA D, ASISTENCIAS T
       WHERE T.CodAsistencia  = A.CodAsistencia
         AND D.IDetPol        = A.IDetPol
         AND D.IdPoliza       = A.IdPoliza
         AND D.CodCia         = A.CodCia
         AND A.StsAsistencia IN ('EMITID','SOLICI')
         AND A.IdPoliza       = nIdPoliza
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
         AND A.StsAsistencia IN ('EMITID','SOLICI')
         AND A.IdPoliza       = nIdPoliza
         AND A.CodCia         = nCodCia
       GROUP BY T.CodCptoServicio;
   CURSOR ASEG_Q IS
      SELECT IDetPol, Cod_Asegurado
        FROM ASEGURADO_CERTIFICADO
       WHERE IdPoliza = nIdPoliza
         AND CodCia   = nCodCia;
   CURSOR DET_Q IS
      SELECT IDetPol, IndDeclara
        FROM DETALLE_POLIZA
       WHERE IdPoliza = nIdPoliza
         AND CodCia   = nCodCia
       UNION ALL
      SELECT Correlativo IdePol, '' IndDeclara
        FROM FZ_DETALLE_FIANZAS
       WHERE IdPoliza = nIdPoliza
         AND CodCia   = nCodCia;
   BEGIN
      SELECT FecIniVig, FecFinVig, CodCliente, IndFactElectronica,
        PorcComis, CodPlanPago, TipoPol, NumPolRef
        INTO dFecIniVig, dFecFinVig, nCodCliente, cIndFactElectronica,
        nPorcComis, cCodPlanPago, cTipoPol, cNumPolRef
        FROM POLIZAS
       WHERE IdPoliza = nIdPoliza
         AND CodCia   = nCodCia;

      nFactProrrata := OC_GENERALES.PRORRATA(dFecIniVig, dFecFinVig, dFecAnul);
      nDiasAnul     := TRUNC(dFecAnul) - TRUNC(dFecIniVig);

      SELECT NVL(SUM(Prima_Moneda),0)
        INTO nPrima
        FROM DETALLE_POLIZA
       WHERE IdPoliza = nIdPoliza;

      nPrimaCanc := nPrima * nFactProrrata;

      -- Anula Notas de Crédito
      FOR X IN NCR_Q LOOP
         IF NVL(nIdTransacNc,0) = 0 THEN
       nIdTransacNc := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 8, 'ANUNCR');
         END IF;

         -- Acumula Prima Devuelta
         SELECT NVL(SUM(Monto_Det_Moneda),0)
      INTO nTotNotaCredCanc
      FROM DETALLE_NOTAS_DE_CREDITO D, NOTAS_DE_CREDITO N, CATALOGO_DE_CONCEPTOS C
          WHERE C.CodConcepto      = D.CodCpto
       AND C.CodCia           = N.CodCia
       AND (D.IndCptoPrima    = 'S'
        OR C.IndCptoServicio  = 'S')
       AND D.IdNcr            = N.IdNcr
       AND N.IdNcr            = X.IdNcr;

         OC_NOTAS_DE_CREDITO.ANULAR(X.IdNcr, dFecAnul, cMotivAnul, nIdTransacNc);

         OC_DETALLE_TRANSACCION.CREA(nIdTransacNc, nCodCia,  nCodEmpresa, 8, 'ANUNCR', 'NOTAS_DE_CREDITO',
                 nIdPoliza, X.IDetPol, X.IdEndoso, X.IdNcr, nTotNotaCredCanc);
      END LOOP;

      IF NVL(nIdTransacNc,0) != 0 THEN
         OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacNc, 'C');
      END IF;

      cContabiliza := 'N';
      nIdTransacAnul := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 2, 'FAC');

      OC_DETALLE_TRANSACCION.CREA (nIdTransacAnul, nCodCia,  nCodEmpresa, 2, 'POL', 'POLIZAS',
               nIdPoliza, NULL, NULL, NULL, nPrimaCanc);

      -- Sumariza Facturas Emitidas
      nTotPrimaCanc := 0;
      FOR X IN FAC_Q LOOP
         -- Acumula Prima Anulada
         SELECT NVL(SUM(Saldo_Det_Moneda),0)
      INTO nTotPrimaFact
      FROM DETALLE_FACTURAS D, FACTURAS F, CATALOGO_DE_CONCEPTOS C
          WHERE C.CodConcepto      = D.CodCpto
       AND C.CodCia           = F.CodCia
       AND (D.IndCptoPrima    = 'S'
        OR C.IndCptoServicio  = 'S')
       AND D.IdFactura        = F.IdFactura
       AND F.IdFactura        = X.IdFactura;

          nTotPrimaCanc := NVL(nTotPrimaCanc,0) + NVL(nTotPrimaFact,0);
          OC_FACTURAS.ANULAR(X.CodCia, X.IdFactura, dFecAnul, cMotivAnul, X.CodCobrador, nIdTransacAnul);
          OC_DETALLE_TRANSACCION.CREA (nIdTransacAnul, nCodCia,  nCodEmpresa, 2, 'FAC', 'FACTURAS',
                   nIdPoliza, X.IDetPol, NULL, X.IdFactura, NVL(nTotPrimaFact,0));
          cContabiliza := 'S';
      END LOOP;

      IF NVL(nTotPrimaCanc,0) != NVL(nPrimaCanc,0) AND NVL(nPrimaCanc,0) > NVL(nTotPrimaCanc,0) THEN
         nTasaCambio    := OC_GENERALES.TASA_DE_CAMBIO(cCod_Moneda, TRUNC(dFecAnul));
         FOR X IN AGENTES_Q LOOP
       nPorcPrima      := (X.Prima_Moneda * 100 / nPrima) / 100;

       nMtoNcrLocal    := (NVL(nPrimaCanc,0) - NVL(nTotPrimaCanc,0)) * nPorcPrima;
       nMtoNcrMoneda   := NVL(nMtoNcrLocal,0) * nTasaCambio;
       nMtoComisLocal  := (NVL(nMtoNcrLocal,0) * (NVL(nPorcComis,0) / 100)) * (NVL(X.Porc_Comision,0) / 100);
       nMtoComisMoneda := (NVL(nMtoNcrMoneda,0) * (NVL(nPorcComis,0) / 100)) * (NVL(X.Porc_Comision,0) / 100);

       cContabiliza := 'S';
       nIdNcr := OC_NOTAS_DE_CREDITO.INSERTA_NOTA_CREDITO(nCodCia, nIdPoliza, X.IDetPol, 0, nCodCliente, TRUNC(SYSDATE),
                            nMtoNcrLocal, nMtoNcrMoneda, nMtoComisLocal, nMtoComisMoneda,
                            X.Cod_Agente, cCod_Moneda, nTasaCambio, nIdTransacAnul, cIndFactElectronica);
       FOR W IN CPTO_PRIMAS_Q LOOP
          nFactor := W.Prima_Moneda / NVL(nPrima,0);
          OC_DETALLE_NOTAS_DE_CREDITO.INSERTA_DETALLE_NOTA(nIdNcr, W.CodCpto, 'S', nMtoNcrLocal * nFactor, nMtoNcrMoneda * nFactor);
          OC_DETALLE_NOTAS_DE_CREDITO.AJUSTAR(nCodCia, nIdNcr, W.CodCpto, 'S', nMtoNcrLocal * nFactor, nMtoNcrMoneda * nFactor);
          OC_DETALLE_NOTAS_DE_CREDITO.APLICAR_RETENCION(nCodCia, nCodEmpresa, X.IdTipoSeg, dFecAnul,
                          nDiasAnul, cMotivAnul, nIdNcr, W.CodCpto);
       END LOOP;

       FOR K IN CPTO_ASIST_Q LOOP
          nFactor := K.MontoAsistMoneda / NVL(nPrima,0);
          OC_DETALLE_NOTAS_DE_CREDITO.INSERTA_DETALLE_NOTA(nIdNcr, K.CodCptoServicio, 'N', nMtoNcrLocal * nFactor, nMtoNcrMoneda * nFactor);
          OC_DETALLE_NOTAS_DE_CREDITO.AJUSTAR(nCodCia, nIdNcr, K.CodCptoServicio, 'N', nMtoNcrLocal * nFactor, nMtoNcrMoneda * nFactor);
          OC_DETALLE_NOTAS_DE_CREDITO.APLICAR_RETENCION(nCodCia, nCodEmpresa, X.IdTipoSeg, dFecAnul,
                          nDiasAnul, cMotivAnul, nIdNcr, K.CodCptoServicio);
       END LOOP;

       OC_DETALLE_NOTAS_DE_CREDITO.GENERA_CONCEPTOS(nCodCia, nCodEmpresa, cCodPlanPago, X.IdTipoSeg,
                           nIdNcr, nTasaCambio);
       OC_NOTAS_DE_CREDITO.ACTUALIZA_NOTA(nIdNcr);
       OC_NOTAS_DE_CREDITO.EMITIR(nIdNcr, NULL);
       OC_COMISIONES.INSERTA_COMISION_NC(nIdNcr);
       OC_DETALLE_TRANSACCION.CREA (nIdTransacAnul, nCodCia,  nCodEmpresa, 2, 'NOTACR', 'NOTAS_DE_CREDITO',
                     nIdPoliza, X.IDetPol, 0, nIdNcr, nMtoNcrLocal);
         END LOOP;
      END IF;

      UPDATE ENDOSOS
         SET StsEndoso = 'ANU',
        FecAnul   = dFecAnul,
        MotivAnul = cMotivAnul,
        FecSts    = TRUNC(SYSDATE)
       WHERE IdPoliza  = nIdPoliza;

      UPDATE DETALLE_POLIZA
         SET StsDetalle = 'ANU',
        FecAnul   = dFecAnul,
        MotivAnul = cMotivAnul
       WHERE IdPoliza  = nIdPoliza;

      UPDATE POLIZAS
         SET StsPoliza = 'ANU',
        FecSts    = dFecAnul,
        FecAnul   = dFecAnul,
        MotivAnul = cMotivAnul
       WHERE IdPoliza  = nIdPoliza;

      FOR W IN DET_Q LOOP
         OC_COBERT_ACT.ANULAR(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol);
         OC_ASISTENCIAS_DETALLE_POLIZA.ANULAR(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol);
      END LOOP;

      FOR Z IN ASEG_Q LOOP
         OC_ASISTENCIAS_ASEGURADO.ANULAR(nCodCia, nCodEmpresa, nIdPoliza, Z.IDetPol, Z.Cod_Asegurado);
         OC_ASEGURADO_CERTIFICADO.ANULAR(nCodCia, nIdPoliza, Z.IDetPol, Z.Cod_Asegurado, dFecAnul, cMotivAnul);
         OC_COBERT_ACT_ASEG.ANULAR(nCodCia, nCodEmpresa, nIdPoliza, Z.IDetPol, Z.Cod_Asegurado);
      END LOOP;

      IF cContabiliza = 'S' THEN
         OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacAnul, 'C');
      END IF;

      IF cTipoPol != 'F' THEN
         GT_REA_DISTRIBUCION.DISTRIBUYE_REASEGURO(nCodCia, nCodEmpresa, nIdPoliza, nIdTransacAnul, TRUNC(SYSDATE), 'ANULAPOL');
         IF GT_REA_DISTRIBUCION.DISTRIB_FACULTATIVA_PEND(nCodCia, nIdTransacAnul) = 'S' THEN
       RAISE_APPLICATION_ERROR(-20200,'Póliza No. '|| cNumPolRef || ' Posee Distribución Facultativa Pendiente');
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error al Anular Póliza: '||TRIM(TO_CHAR(nIdPoliza))|| ' ' ||SQLERRM);
   END ANULAR_POLIZA;*/

   --FUNCTION RENOVAR(nCodCia NUMBER, nIdPolizaRen NUMBER, cEmitePoliza VARCHAR2 DEFAULT 'N') RETURN NUMBER IS
FUNCTION RENOVAR(nCodCia NUMBER, nIdPolizaRen NUMBER, cEmitePoliza VARCHAR2 DEFAULT 'N',
       cIndSubGrupos VARCHAR2, IndAsegurados VARCHAR2, nIdCotizacion NUMBER) RETURN NUMBER IS
dFecHoy           DATE;
dFecFin           DATE;
dFecIni           DATE;
nIdPoliza         POLIZAS.IdPoliza%TYPE;
nIDetPol          DETALLE_POLIZA.IDetPol%TYPE;
nTasaCambio       DETALLE_POLIZA.Tasa_Cambio%TYPE;
nPrima            POLIZAS.PRIMANETA_LOCAL%TYPE;
cNumPolUnico      POLIZAS.NumPolUnico%TYPE;
nCodEmpresa       POLIZAS.CodEmpresa%TYPE;
p_msg_regreso     VARCHAR2(50);----var XDS
cIdTipoSeg        DETALLE_POLIZA.IdTipoSeg%TYPE;
cPlanCob          DETALLE_POLIZA.PlanCob%TYPE;
nDuracionPlan     PLAN_COBERTURAS.DuracionPlan%TYPE;
nCodAsegurado     DETALLE_POLIZA.Cod_Asegurado%TYPE;
nCodCliente       POLIZAS.CodCliente%TYPE;

nPorcComisNiv1    NUMBER := 0;
nPorcComisNiv2    NUMBER := 0;
nPorcComisNiv3    NUMBER := 0;
nPorcComisTot     NUMBER := 0;
nPorcComPropT     NUMBER := 0;

cIndAsegModelo    COTIZACIONES.IndAsegModelo%TYPE;
cIndListadoAseg   COTIZACIONES.IndListadoAseg%TYPE;
cIndCensoSubGrupo COTIZACIONES.IndCensoSubGrupo%TYPE;
cIndPolCol        POLIZAS.IndPolCol%TYPE;

nNumRenov         POLIZAS.NUMRENOV%TYPE;

CURSOR POL_REN_Q IS
   SELECT TipoPol, CodCliente, CodEmpresa,  NumPolRef, CodCia, NumPolUnico,
          FecRenovacion, DescPoliza, SumaAseg_Moneda, PrimaNeta_Moneda,
          PorcComis, NumRenov, IndExaInsp, Cod_Moneda, CodGrupoEc, IndPolCol,
          Cod_Agente, CodPlanPago, Medio_Pago, IndProcFact,Caracteristica,
          IndFactPeriodo, FormaVenta, TipoRiesgo, IndConcentrada,TipoDividendo,
          TipoAdministracion, IndFacturaPol, CodAgrupador, HoraVigIni, HoraVigFin,
          IndFactElectronica, IndCalcDerechoEmis, CodDirecRegional, PorcDescuento,
          PorcGtoAdmin, PorcGtoAdqui, PorcUtilidad, FactorAjuste, MontoDeducible,
          FactFormulaDeduc, CodRiesgoRea, CodTipoBono, HorasVig, DiasVig,
          IndExtraPrima, AsegAdheridosPor, PorcenContributorio,
          FuenteRecursosPrima, IdFormaCobro, DiaCobroAutomatico, IndManejaFondos
          --MLJS 06/08/2024 SE AGREGAN LOS SIGUIENTES CAMPOS
          ,CodTipoNegocio, CodPaqComercial,CodCatego, codobjetoimp, codusocfdi 
     FROM POLIZAS
    WHERE IdPoliza = nIdPolizaRen
      AND CodCia   = nCodCia;

CURSOR DET_POL_RENOVAR_Q IS
   SELECT IDetPol, CodCia, Cod_Asegurado, CodEmpresa, CodPlanPago,
          Suma_Aseg_Moneda, Suma_Aseg_local, Prima_Moneda, Prima_local, PorcComis, PlanCob,
          FecIniVig, FecFinVig, IdTipoSeg, CodPromotor, IndDeclara,
          IndSinAseg, CodFilial, CodCategoria, IndFactElectronica,
          IndAsegModelo, CantAsegModelo, MontoComisH, PorcComisH,
          IdDirecAviCob, IdFormaCobro, MontoAporteFondo
          ,codobjetoimp, codusocfdi  --MLJS 06/08/2024 SE AGREGAN
          ,NUMDETREF                 --MLJS 29/08/2024 SE COPIA LA REFERENCIA DEL DETALLE
     FROM DETALLE_POLIZA
    WHERE IdPoliza = nIdPolizaRen
      AND CodCia   = nCodCia;

CURSOR AGENTES_Q IS
   SELECT A.Cod_Agente, A.Ind_Principal, A.Porc_Comision
     FROM AGENTES_DETALLES_POLIZAS A
    WHERE IDetPol  = nIDetPol
      AND CodCia   = nCodCia
      AND IdPoliza = nIdPolizaRen;

CURSOR COB_REN_Q IS
  SELECT CA.IDetPol, CA.CodEmpresa, CA.CodCia, DP.IdTipoSeg,
          CA.CodCobert, CA.SumaAseg_Moneda, CA.Prima_Moneda,
          CA.TipoRef, CA.NumRef, CA.Cod_Asegurado, CA.Cod_Moneda,
          CA.Deducible_Local, CA.Deducible_Moneda, DP.PlanCob,
          CA.SumaAsegCalculada, CA.SalarioMensual, CA.VecesSalario,
          CA.Edad_Minima, CA.Edad_Maxima, CA.Edad_Exclusion,
          CA.SumaAseg_Maxima, CA.SumaAseg_Minima, CA.PorcExtraPrimaDet,
          CA.MontoExtraPrimaDet, CA.SumaIngresada
    FROM COBERT_ACT CA, DETALLE_POLIZA DP
   WHERE DP.IDetPol  = CA.IDetPol
     AND DP.IdPoliza = CA.IdPoliza
     AND CA.IdPoliza = nIdPolizaRen
     AND CA.CodCia   = nCodCia;

CURSOR BIENES_Q IS
  SELECT IDetPol, Num_Bien, CodPais, CodEstado,CodCia,
    CodCiudad, CodMunicipio, Ubicacion_Bien,
    Tipo_Bien, Suma_Aseg_Local_Bien, Suma_Aseg_Moneda_Bien,
    Prima_Neta_Local_Bien, Prima_Neta_Moneda_Bien,
    Inicio_Vigencia, Fin_Vigencia
    FROM DATOS_PARTICULARES_BIENES
   WHERE IdPoliza = nIdPolizaRen
     AND CodCia   = nCodCia;

CURSOR PERSONAS_Q IS
  SELECT IDetPol, Estatura, Peso, Cavidad_Toraxica_Min,
    Cavidad_Toraxica_Max, Capacidad_Abdominal, Presion_Arterial_Min,
    Presion_Arterial_Max, Pulso, Mortalidad, Suma_Aseg_Moneda,
    Suma_Aseg_Local, Extra_Prima_Moneda, Extra_Prima_Local,
    Id_Fumador, Observaciones, Porc_Subnormal, Prima_Local, Prima_Moneda, CodCia
    FROM DATOS_PARTICULARES_PERSONAS
   WHERE IdPoliza = nIdPolizaRen
     AND CodCia   = nCodCia;

CURSOR VEHI_Q IS
  SELECT IDetPol, Num_Vehi, Cod_Marca, Cod_Modelo, Cod_Version,
    Anio_Vehiculo, Placa, Cantidad_Pasajeros, Tarjeta_Circulacion,
    Color, Numero_Chasis, Numero_Motor, SumaAseg_Local, SumaAseg_Moneda,
    PrimaNeta_Local, PrimaNeta_Moneda
    FROM DATOS_PARTICULARES_VEHICULO
   WHERE IdPoliza = nIdPolizaRen
     AND CodCia   = nCodCia;

CURSOR BENEF_Q IS
   SELECT IDetPol, Cod_Asegurado, Benef, Nombre, PorcePart,
     CodParent, Sexo, FecAlta, Obervaciones, IndIrrevocable
     FROM BENEFICIARIO
    WHERE IdPoliza = nIdPolizaRen
      AND Estado   = 'ACTIVO';

CURSOR RESP_POL_Q IS
   SELECT Tipo_Doc_Identificacion, Num_Doc_Identificacion,
     CodResPago, FecAlta, FecBaja, PorcResPago, CodEmpresa
     FROM RESPONSABLE_PAGO_POL
    WHERE StsResPago = 'ACT'
      AND IdPoliza   = nIdPolizaRen
      AND CodCia     = nCodCia;

CURSOR RESP_DET_Q IS
   SELECT IDetPol, Tipo_Doc_Identificacion, Num_Doc_Identificacion,
     CodResPago, FecAlta, FecBaja, PorcResPago, CodEmpresa
     FROM RESPONSABLE_PAGO_DET
    WHERE StsResPago = 'ACT'
      AND IdPoliza   = nIdPolizaRen
      AND CodCia     = nCodCia;

CURSOR RECARGOS_Q IS
   SELECT CodRec, Porc_Recargo, Monto_Local, Monto_Moneda,
     Inicio_Vigencia, Fin_Vigencia, Observaciones
     FROM RECARGOS
    WHERE Estado   = 'ACT'
      AND IdPoliza = nIdPolizaRen
      AND CodCia   = nCodCia;

CURSOR DET_REC_Q IS
   SELECT IDetPol, CodRec, Porc_Recargo, Monto_Local, Monto_Moneda,
     Inicio_Vigencia, Fin_Vigencia, Observaciones
     FROM DETALLE_RECARGO
    WHERE Estado   = 'ACT'
      AND IdPoliza = nIdPolizaRen
      AND CodCia   = nCodCia;

CURSOR DESC_Q IS
   SELECT CodDesc, Porc_Desc, Monto_Local, Monto_Moneda,
     Ini_Vigencia, Fin_Vigencia, Observaciones
     FROM DESCUENTOS
    WHERE Estado   = 'ACT'
      AND IdPoliza = nIdPolizaRen
      AND CodCia   = nCodCia;

CURSOR DET_DESC_Q IS
   SELECT IDetPol, CodDesc, Porc_Desc, Monto_Local, Monto_Moneda,
     Ini_Vigencia, Fin_Vigencia, Observaciones
     FROM DETALLE_DESCUENTO
    WHERE Estado   = 'ACT'
      AND IdPoliza = nIdPolizaRen
      AND CodCia   = nCodCia;

CURSOR TARJ_POL_Q IS
   SELECT Id_DetallePolizasPago, CodLista, CodValor,
     IDetPol, FecVence, NumTarjeta
     FROM DETALLE_POLIZAS_TARJETAS
    WHERE IdPoliza = nIdPolizaRen
      AND CodCia   = nCodCia;

CURSOR DOC_POL_Q IS
   SELECT IdDocumentoPoliza, IdDocumento
     FROM DOCUMENTO_POLIZA
    WHERE IdPoliza = nIdPolizaRen
      AND CodCia   = nCodCia;

CURSOR INSPEC_Q IS
   SELECT Num_Inspeccion, IDetPol, Num_Vehi, Encargado,
     FecRequi, Observaciones
     FROM INSPECCION
    WHERE IdPoliza = nIdPolizaRen
      AND CodCia   = nCodCia;

CURSOR EXAMEN_Q IS
   SELECT IDetPol, Id_Examen, CodMedico, Descripcion_Examen,
     Fecha_Examen, Lugar_Examen, Estado_Examen
     FROM EXAMEN
    WHERE IdPoliza = nIdPolizaRen
      AND CodCia   = nCodCia;

CURSOR REQ_POL_Q IS
   SELECT CodRequisito, FecSolicitReq, FecEntregaReq,
     Observaciones
     FROM REQUISITOS_ENC_POLIZA
    WHERE IdPoliza = nIdPolizaRen
      AND CodCia   = nCodCia;

CURSOR REQ_DET_Q IS
   SELECT IDetPol, CodRequisito, FecSolicitReq, FecEntregaReq,
     Observaciones, CodUsuario
     FROM REQUISITOS_POLIZA
    WHERE IdPoliza = nIdPolizaRen
      AND CodCia   = nCodCia;

CURSOR ASEG_CERT_Q IS
   SELECT CodCia, IDetPol, Cod_Asegurado, FechaAlta, FechaBaja, CodEmpresa,
     SumaAseg, Primaneta
     FROM ASEGURADO_CERT
    WHERE IdPoliza = nIdPolizaRen
      AND CodCia   = nCodCia;

CURSOR COBASEGCERT_Q IS
   SELECT CodCia, IDetPol, CodEmpresa, IdTipoSeg, TipoRef, NumRef, CodCobert,
     Cod_Asegurado, SumaAseg_Local, SumaAseg_Moneda, Tasa, Prima_Moneda,
     Prima_Local, IdEndoso, PlanCob, Cod_Moneda, Deducible_Local, Deducible_Moneda,
     SumaAsegCalculada, SalarioMensual, VecesSalario, Edad_Minima,
     Edad_Maxima, Edad_Exclusion, SumaAseg_Maxima, SumaAseg_Minima,
     PorcExtraPrimaDet, MontoExtraPrimaDet, SumaIngresada
     FROM COBERT_ACT_ASEG
    WHERE IdPoliza = nIdPolizaRen
      AND CodCia   = nCodCia;

CURSOR DET_REN_Q IS
   SELECT CodCia, CodEmpresa, IDetPol, Cod_Asegurado
     FROM DETALLE_POLIZA
    WHERE IdPoliza = nIdPoliza
      AND CodCia   = nCodCia;
BEGIN
   SELECT SYSDATE, CodEmpresa, FecRenovacion, ADD_MONTHS(FecRenovacion,12), IndPolCol --FecFinVig + (FecFinVig - FecIniVig)
     INTO dFecHoy, nCodEmpresa, dFecIni, dFecFin, cIndPolCol
     FROM POLIZAS
    WHERE IdPoliza = nIdPolizaRen
      AND CodCia   = nCodCia;

   SELECT MAX(IdTipoSeg), MAX(PlanCob)
     INTO cIdTipoSeg, cPlanCob
     FROM DETALLE_POLIZA
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND IdPoliza   = nIdPolizaRen;

   nDuracionPlan := OC_PLAN_COBERTURAS.DURACION_PLAN(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob);

   IF NVL(nIdCotizacion,0) <> 0 THEN
      BEGIN
         SELECT CodCliente, Cod_Asegurado
           INTO nCodCliente, nCodAsegurado
           FROM POLIZAS P, DETALLE_POLIZA D
          WHERE P.CodCia      = nCodCia
            AND P.CodEmpresa  = nCodEmpresa
            AND P.IdPoliza    = nIdPolizaRen
            AND P.CodCia      = D.CodCia
            AND P.CodEmpresa  = D.CodEmpresa
            AND P.IdPoliza    = D.IdPoliza
            AND D.IDetPol     = (SELECT MIN(IDetPol)
                                   FROM DETALLE_POLIZA DP
                                  WHERE DP.CodCia      = nCodCia
                                    AND DP.CodEmpresa  = nCodEmpresa
                                    AND DP.IdPoliza    = nIdPolizaRen);

      END;

      BEGIN
         SELECT IndAsegModelo, IndListadoAseg, IndCensoSubGrupo
           INTO cIndAsegModelo, cIndListadoAseg, cIndCensoSubGrupo
           FROM COTIZACIONES
          WHERE CodCia        = nCodCia
            AND CodEmpresa    = nCodEmpresa
            AND IdCotizacion  = nIdCotizacion;
      END;

      FOR X IN POL_REN_Q LOOP
         nIdPoliza := GT_COTIZACIONES.CREAR_POLIZA(nCodCia, nCodEmpresa, nIdCotizacion, nCodCliente, nCodAsegurado);
         IF INSTR(X.NumPolUnico,'-' || TRIM(TO_CHAR(X.NumRenov,'00')),1) != 0 THEN
            cNumPolUnico := SUBSTR(X.NumPolUnico,1,INSTR(X.NumPolUnico,'-' || TRIM(TO_CHAR(X.NumRenov,'00')),1)-1) || '-' || TRIM(TO_CHAR(NVL(X.NumRenov,0)+1,'00'));
         ELSIF X.NumPolUnico IS NOT NULL THEN
            cNumPolUnico := TRIM(X.NumPolUnico) || '-' || TRIM(TO_CHAR(NVL(X.NumRenov,0)+1,'00'));
         ELSE
            cNumPolUnico := TRIM(TO_CHAR(nIdPoliza)) || '-' || TRIM(TO_CHAR(NVL(X.NumRenov,0)+1,'00'));
         END IF;
          
         UPDATE POLIZAS
            SET NumPolUnico   = cNumPolUnico,
                NumRenov      = nNumRenov --MLJS 06/08/2024 NVL(X.NumRenov,0) + 1
          WHERE CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND IdPoliza   = nIdPoliza;

         --DBMS_OUTPUT.PUT_LINE(X.Cod_Agente);
         IF OC_AGENTES.ES_AGENTE_DIRECTO(nCodCia, X.Cod_Agente) = 'S' THEN
            nPorcComisNiv1     := 0;
            nPorcComisNiv2     := 0;
            nPorcComisNiv3     := 0;
         ELSE
            SELECT C.PorcComisDir, C.PorcComisProm, C.PorcComisAgte
              INTO nPorcComisNiv1, nPorcComisNiv2, nPorcComisNiv3
              FROM COTIZACIONES C
             WHERE C.CodCia       = nCodCia
               AND C.CodEmpresa   = nCodEmpresa
               AND C.IdCotizacion = nIdCotizacion;
         --

            nPorcComisTot := 0;
            FOR COM IN (SELECT A.CodNivel
                          FROM AGENTES_DISTRIBUCION_POLIZA A
                         WHERE A.CodCia   = nCodCia
                           AND A.IdPoliza = nIdPoliza) LOOP
             --DBMS_OUTPUT.PUT_LINE('ENTRO .... ');
               IF COM.CodNivel = 1 THEN
                  nPorcComisTot := nPorcComisTot + nPorcComisNiv1;
               ELSIF COM.CodNivel = 2 THEN
                  nPorcComisTot := nPorcComisTot + nPorcComisNiv2;
               ELSIF COM.CodNivel = 3 THEN
                  nPorcComisTot := nPorcComisTot + nPorcComisNiv3;
               END IF;
            END LOOP;
         END IF;

         DECLARE
            nCodNivel            NUMBER :=0;
            nPorcPro             NUMBER :=0;
            nPorcDist            NUMBER :=0;
            nPorcComProporcional NUMBER := 0;
         BEGIN
            --DBMS_OUTPUT.PUT_LINE(nPorcComisTot);
            UPDATE AGENTES_DISTRIBUCION_POLIZA
               SET Porc_Com_Distribuida  = nPorcComisNiv1,
                   Porc_Com_Proporcional = TRUNC(ROUND((nPorcComisNiv1 * 100) / nPorcComisTot, 2), 2),
                   Porc_Com_Poliza       = nPorcComisTot
             WHERE IdPoliza = nIdPoliza
               AND CodCia   = nCodCia
               AND CodNivel = 1;

            IF SQL%ROWCOUNT > 0 THEN
               nPorcComPropT := nPorcComPropT + TRUNC(ROUND((nPorcComisNiv1 * 100) / nPorcComisTot, 2), 2);
            END IF;

            UPDATE AGENTES_DISTRIBUCION_POLIZA
               SET Porc_Com_Distribuida  = nPorcComisNiv2,
                   Porc_Com_Proporcional = TRUNC(ROUND((nPorcComisNiv2 * 100) / nPorcComisTot, 2), 2),
                   Porc_Com_Poliza       = nPorcComisTot
            WHERE IdPoliza = nIdPoliza
              AND CodCia   = nCodCia
              AND CodNivel = 2;

            IF SQL%ROWCOUNT > 0 THEN
               nPorcComPropT := nPorcComPropT + TRUNC(ROUND((nPorcComisNiv2 * 100) / nPorcComisTot, 2), 2);
            END IF;

            IF OC_AGENTES.ES_AGENTE_DIRECTO(nCodCia, X.Cod_Agente) != 'S' THEN
               IF nPorcComisTot = 0 THEN nPorcComisTot := 1; END IF;
               IF nPorcComisNiv3 = 0 THEN nPorcComisNiv3 := 1;     END IF;
            END IF;

            BEGIN
               SELECT TRUNC(ROUND((nPorcComisNiv3 * 100) / nPorcComisTot, 2), 2)
                 INTO nPorcComProporcional
                 FROM DUAL;
            EXCEPTION
               WHEN ZERO_DIVIDE THEN
                  nPorcComProporcional := 0;
            END;

            UPDATE AGENTES_DISTRIBUCION_POLIZA
               SET Porc_Com_Distribuida   = nPorcComisNiv3,
                   Porc_Com_Proporcional  = nPorcComProporcional,
                   Porc_Com_Poliza        = nPorcComisTot
             WHERE IdPoliza = nIdPoliza
               AND CodCia   = nCodCia
               AND CodNivel = 3;

            IF SQL%ROWCOUNT > 0 THEN
             --nPorcComPropT := nPorcComPropT + TRUNC(ROUND((nPorcComisNiv3 * 100) / nPorcComisTot, 2), 2);
               nPorcComPropT := nPorcComPropT + nPorcComProporcional;
            END IF;

            UPDATE AGENTES_DISTRIBUCION_POLIZA
               SET Porc_Com_Proporcional = Porc_Com_Proporcional + (100 - nPorcComPropT)
             WHERE IdPoliza = nIdPoliza
               AND CodNivel = 3
               AND CodCia   = nCodCia;

            DELETE AGENTES_DISTRIBUCION_COMISION
             WHERE CodCia     = nCodCia
               AND IdPoliza   = nIdPoliza;

            DELETE AGENTES_DETALLES_POLIZAS
             WHERE CodCia     = nCodCia
               AND IdPoliza   = nIdPoliza;

            UPDATE DETALLE_POLIZA D
               SET D.PorcComis   = nPorcComisTot
             WHERE D.CodCia      = nCodCia
               AND D.CodEmpresa = nCodEmpresa
               AND D.IdPoliza   = nIdPoliza;

            OC_AGENTES_DISTRIBUCION_POLIZA.COPIAR(nCodCia, nIdPoliza);
         END;
         FOR W IN BENEF_Q LOOP
            INSERT INTO BENEFICIARIO
               (IdPoliza, IDetPol, Cod_Asegurado, Benef, Nombre, PorcePart,
                CodParent, Estado, Sexo, FecEstado, FecAlta, FecBaja,
                MotBaja, Obervaciones, IndIrrevocable)
            VALUES
               (nIdPoliza, W.IDetPol, W.Cod_Asegurado, W.Benef, W.Nombre, W.PorcePart,
                W.CodParent, 'ACTIVO', W.Sexo, dFechoy, dFecIni, NULL,
                NULL, W.Obervaciones, W.IndIrrevocable);
         END LOOP;
         FOR X IN DET_POL_RENOVAR_Q LOOP
            UPDATE DETALLE_POLIZA
                   SET Cod_Asegurado    = X.Cod_Asegurado,
                       SUMA_ASEG_LOCAL  = X.SUMA_ASEG_LOCAL,
                       PRIMA_LOCAL      = X.PRIMA_LOCAL,
                       Suma_Aseg_Moneda = X.Suma_Aseg_Moneda,
                       Prima_Moneda     = X.Prima_Moneda
             WHERE CodCia     = nCodCia
               AND CodEmpresa = nCodEmpresa
               AND IdPoliza   = nIdPoliza
               AND IDetPol    = X.IDetPol;

            DELETE COBERT_ACT_ASEG
             WHERE CodCia     = nCodCia
               AND CodEmpresa = nCodEmpresa
               AND IdPoliza   = nIdPoliza
               AND IDetPol    = X.IDetPol;

            DELETE COBERT_ACT
             WHERE CodCia     = nCodCia
               AND CodEmpresa = nCodEmpresa
               AND IdPoliza   = nIdPoliza
               AND IDetPol    = X.IDetPol;

            IF cIndAsegModelo = 'S' THEN
               GT_COTIZACIONES_COBERTURAS.CREAR_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion,  X.IDetPol,
                                                           nIdPoliza,  X.IDetPol, X.Cod_Asegurado, cIndPolCol);
            ELSIF cIndListadoAseg = 'S' OR cIndCensoSubGrupo = 'S' THEN
               GT_COTIZACIONES_COBERT_ASEG.CREAR_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion,  X.IDetPol,
                                                            nIdPoliza,  X.IDetPol, X.Cod_Asegurado, cIndPolCol);

            END IF;

            -- Censo
            IF cIndCensoSubGrupo = 'S' THEN
               GT_COTIZACIONES_CENSO_ASEG.ACTUALIZA_CERTIFICADO(nCodCia, nCodEmpresa, nIdCotizacion,  X.IDetPol,
                                                                nIdPoliza,  X.IDetPol);
            END IF;
         END LOOP;
      END LOOP;
/*********************************************************************************************************/
   ELSE
      nIdPoliza := OC_POLIZAS.F_GET_NUMPOL(p_msg_regreso);

      -- Renovación de Póliza
      FOR X IN POL_REN_Q LOOP
         IF nDuracionPlan > 1 AND
            X.NumRenov + 2 > nDuracionPlan THEN
            RAISE_APPLICATION_ERROR(-20225,'Ya NO se puede Renovar la Póliza: '||TRIM(TO_CHAR(nIdPoliza))||
                   ' Porque con esta Renovación Supera la Duración del Plan de Coberturas ');
         END IF;

         nTasaCambio  := OC_GENERALES.TASA_DE_CAMBIO(X.Cod_Moneda, TRUNC(SYSDATE));
         nCodEmpresa  := X.CodEmpresa;
         nPrima       := X.PrimaNeta_Moneda * nTasaCambio;
         /*IF INSTR(X.NumPolUnico,'-' || TRIM(TO_CHAR(X.NumRenov,'00')),1) != 0 THEN
            cNumPolUnico := SUBSTR(X.NumPolUnico,1,INSTR(X.NumPolUnico,'-' || TRIM(TO_CHAR(X.NumRenov,'00')),1)-1) ||
                '-' || TRIM(TO_CHAR(NVL(X.NumRenov,0)+1,'00'));
         ELSIF X.NumPolUnico IS NOT NULL THEN
            cNumPolUnico := TRIM(X.NumPolUnico) || '-' || TRIM(TO_CHAR(NVL(X.NumRenov,0)+1,'00'));
         ELSE
            cNumPolUnico := TRIM(TO_CHAR(nIdPoliza)) || '-' || TRIM(TO_CHAR(NVL(X.NumRenov,0)+1,'00'));
         END IF;*/
         
         -- MLJS 07/08/2024
         cNumPolUnico := F_OBT_NUMPOLUNICO_REN (X.NumPolUnico);
         nNumRenov    := F_OBT_NUMRENOV_REN (X.NumPolUnico);
         
         INSERT INTO POLIZAS
             (IdPoliza, TipoPol, CodCliente, CodEmpresa,  NumPolRef,
             FecIniVig, FecFinVig, FecSolicitud, FecEmision, StsPoliza, FecSts,
             FecAnul, MotivAnul, SumaAseg_Local, SumaAseg_Moneda, PrimaNeta_Local,
             PrimaNeta_Moneda, DescPoliza, PorcComis, FecRenovacion, NumRenov,
             IndExaInsp, CodCia, Cod_Moneda, CodGrupoEc, IndPolCol,
             Cod_Agente, CodPlanPago, Medio_Pago, NumPolUnico, IndProcFact,
             Caracteristica, IndFactPeriodo, FormaVenta, TipoRiesgo, IndConcentrada,
             TipoDividendo, IndAplicoSami, SamiPoliza, TipoAdministracion,
             IndFacturaPol, CodAgrupador, HoraVigIni, HoraVigFin,
             IndFactElectronica, IndCalcDerechoEmis, CodDirecRegional, PorcDescuento,
             PorcGtoAdmin, PorcGtoAdqui, PorcUtilidad, FactorAjuste, MontoDeducible,
             FactFormulaDeduc, CodRiesgoRea, CodTipoBono, HorasVig, DiasVig,
             IndExtraPrima, AsegAdheridosPor, PorcenContributorio,
             FuenteRecursosPrima, IdFormaCobro, DiaCobroAutomatico, IndManejaFondos
              --MLJS 06/08/2024 SE AGREGAN LOS SIGUIENTES CAMPOS
             ,CodTipoNegocio, CodPaqComercial,CodCatego, codobjetoimp, codusocfdi)
         VALUES
             (nIdPoliza, X.TipoPol, X.CodCliente, X.CodEmpresa,  X.NumPolRef,
             dFecIni, dFecFin, dFecHoy, dFecHoy, 'XRE', dFecHoy,
             NULL, NULL, X.SumaAseg_Moneda * nTasaCambio, X.SumaAseg_Moneda,
             X.PrimaNeta_Moneda * nTasaCambio, X.PrimaNeta_Moneda, X.DescPoliza,
             X.PorcComis, dFecFin, nNumRenov, --MLJS 07/08/2024 NVL(X.NumRenov,0)+1, 
             X.IndExaInsp, X.CodCia,
             X.Cod_Moneda, X.CodGrupoEc, X.IndPolCol, X.Cod_Agente, X.CodPlanPago,
             X.Medio_Pago, cNumPolUnico, X.IndProcFact, X.Caracteristica,
             X.IndFactPeriodo, X.FormaVenta, X.TipoRiesgo, X.IndConcentrada,
             X.TipoDividendo, 'N', 0, X.TipoAdministracion, X.IndFacturaPol,
             X.CodAgrupador, X.HoraVigIni, X.HoraVigFin, X.IndFactElectronica,
             X.IndCalcDerechoEmis, X.CodDirecRegional, X.PorcDescuento,
             X.PorcGtoAdmin, X.PorcGtoAdqui, X.PorcUtilidad, X.FactorAjuste, X.MontoDeducible,
             X.FactFormulaDeduc, X.CodRiesgoRea, X.CodTipoBono, X.HorasVig, X.DiasVig,
             X.IndExtraPrima, X.AsegAdheridosPor, X.PorcenContributorio,
             X.FuenteRecursosPrima, X.IdFormaCobro, X.DiaCobroAutomatico, X.IndManejaFondos 
             --MLJS 06/08/2024 SE AGREGAN LOS SIGUIENTES CAMPOS
             ,X.CodTipoNegocio, X.CodPaqComercial,X.CodCatego, X.codobjetoimp, X.codusocfdi);

         -- Inserta Agentes de la Póliza
         INSERT INTO AGENTE_POLIZA
            (IdPoliza, CodCia, Cod_Agente, Porc_Comision, Ind_Principal, Origen)
         SELECT nIdPoliza, CodCia, Cod_Agente, Porc_Comision, Ind_Principal, Origen
           FROM AGENTE_POLIZA
          WHERE CodCia   = nCodCia
            AND IdPoliza = nIdPolizaRen;

         -- Inserta Distribución de Agentes de la Póliza
         INSERT INTO AGENTES_DISTRIBUCION_POLIZA
            (CodCia, IdPoliza, CodNivel, Cod_Agente, Cod_Agente_Distr, Porc_Comision_Plan, Porc_Comision_Agente,
            Porc_com_distribuida, Porc_Com_Proporcional, Cod_Agente_Jefe, Origen)
         SELECT CodCia, nIdPoliza, CodNivel, Cod_Agente, Cod_Agente_Distr, Porc_Comision_Plan, Porc_Comision_Agente,
                Porc_com_distribuida, Porc_Com_Proporcional, Cod_Agente_Jefe, Origen
           FROM AGENTES_DISTRIBUCION_POLIZA
          WHERE CodCia   = nCodCia
            AND IdPoliza = nIdPolizaRen;
      END LOOP;

      IF NVL(cIndSubGrupos,'N') = 'S' THEN
         -- Renovación de Detalles de Póliza
         FOR X IN DET_POL_RENOVAR_Q LOOP
            nIDetPol := X.IDetPol;
            nPrima   := X.Prima_Moneda * nTasaCambio;

            INSERT INTO DETALLE_POLIZA
               (IdPoliza, IDetPol, CodCia, Cod_Asegurado, CodEmpresa, CodPlanPago,
               Suma_Aseg_Local, Suma_Aseg_Moneda, Prima_Local, Prima_Moneda,
               FecIniVig, FecFinVig, IdTipoSeg, Tasa_Cambio, PorcComis, PlanCob,
               StsDetalle, CodPromotor, IndDeclara, IndSinAseg, CodFilial, CodCategoria,
               IndFactElectronica, IndAsegModelo, CantAsegModelo, MontoComisH, PorcComisH,
               IdDirecAviCob, IdFormaCobro, MontoAporteFondo
               ,codobjetoimp, codusocfdi  --MLJS 06/08/2024 SE AGREGAN)
               ,NUMDETREF)                --MLJS 30/08/2024 
            VALUES
               (nIdPoliza, X.IDetPol, X.CodCia, X.Cod_Asegurado, X.CodEmpresa, X.CodPlanPago,
               X.Suma_Aseg_Moneda * nTasaCambio, X.Suma_Aseg_Moneda, X.Prima_Moneda * nTasaCambio, X.Prima_Moneda,
               dFecIni, dFecFin, X.IdTipoSeg, nTasaCambio, X.PorcComis, X.PlanCob,
               'XRE', X.CodPromotor, X.IndDeclara, X.IndSinAseg, X.CodFilial, X.CodCategoria,
               X.IndFactElectronica, X.IndAsegModelo, X.CantAsegModelo, X.MontoComisH, X.PorcComisH,
               X.IdDirecAviCob, X.IdFormaCobro, X.MontoAporteFondo
               ,X.codobjetoimp, X.codusocfdi  --MLJS 06/08/2024 SE AGREGAN
               ,X.NUMDETREF);                 --MLJS 30/08/2024 

          /*OC_DETALLE_TRANSACCION.CREA (nIdTransac, nCodCia, X.CodEmpresa, 3, 'CER', 'DETALLE_POLIZA',
                   nIdPoliza, NULL, NULL, NULL, nPrima);*/

            IF OC_TIPOS_DE_SEGUROS.MANEJA_FONDOS(nCodCia, X.CodEmpresa, X.IdTipoSeg) = 'S' THEN -- GTC - 06/02/2019
               IF GT_FAI_TIPOS_FONDOS_PRODUCTOS.FONDOS_COLECTIVOS(nCodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob) = 'N' THEN
                  GT_FAI_FONDOS_DETALLE_POLIZA.RENOVAR(X.CodCia, X.CodEmpresa, nIdPolizaRen, X.IDetPol, X.Cod_Asegurado, nIdPoliza);
               END IF;
            END IF;
         END LOOP;

         --OC_AGENTES_DISTRIBUCION_POLIZA.COPIAR(nCodCia, nIdPoliza);

         -- Renovación de Bienes de Póliza
         FOR Z IN BIENES_Q LOOP
            INSERT INTO DATOS_PARTICULARES_BIENES
               (IdPoliza, IDetPol, Num_Bien, CodPais, CodEstado,
               CodCiudad, CodMunicipio, Ubicacion_Bien,
               Tipo_Bien, Suma_Aseg_Local_Bien, Suma_Aseg_Moneda_Bien,
               Prima_Neta_Local_Bien, Prima_Neta_Moneda_Bien,
               Inicio_Vigencia, Fin_Vigencia, CodCia)
            VALUES
               (nIdPoliza, Z.IDetPol, Z.Num_Bien, Z.CodPais, Z.CodEstado,
               Z.CodCiudad, Z.CodMunicipio, Z.Ubicacion_Bien,
               Z.Tipo_Bien, Z.Suma_Aseg_Moneda_Bien * nTasaCambio, Z.Suma_Aseg_Moneda_Bien,
               Z.Prima_Neta_Moneda_Bien * nTasaCambio, Z.Prima_Neta_Moneda_Bien,
               dFecIni, dFecFin, Z.CodCia);
         END LOOP;

         -- Renovación de Asegurados de Póliza
         FOR P IN PERSONAS_Q LOOP
            INSERT INTO DATOS_PARTICULARES_PERSONAS
               (IdPoliza, IDetPol, Estatura, Peso, Cavidad_Toraxica_Min,
               Cavidad_Toraxica_Max, Capacidad_Abdominal, Presion_Arterial_Min,
               Presion_Arterial_Max, Pulso, Mortalidad, Suma_Aseg_Moneda,
               Suma_Aseg_Local, Extra_Prima_Moneda, Extra_Prima_Local,
               Id_Fumador, Observaciones, Porc_Subnormal, Prima_Local, Prima_Moneda, CodCia)
            VALUES
               (nIdPoliza, P.IDetPol, P.Estatura, P.Peso, P.Cavidad_Toraxica_Min,
               P.Cavidad_Toraxica_Max, P.Capacidad_Abdominal, P.Presion_Arterial_Min,
               P.Presion_Arterial_Max, P.Pulso, P.Mortalidad, P.Suma_Aseg_Moneda,
               P.Suma_Aseg_Moneda * nTasaCambio, P.Extra_Prima_Moneda, P.Extra_Prima_Moneda * nTasaCambio,
               P.Id_Fumador, P.Observaciones, P.Porc_Subnormal, P.Prima_Moneda * nTasaCambio, P.Prima_Moneda, P.CodCia);
         END LOOP;

         -- Renovación de Automóviles de Póliza
         FOR V IN VEHI_Q LOOP
            INSERT INTO DATOS_PARTICULARES_VEHICULO
               (IdPoliza, IDetPol, Num_Vehi, Cod_Marca, Cod_Modelo, Cod_Version,
               Anio_Vehiculo, Placa, Cantidad_Pasajeros, Tarjeta_Circulacion,
               Color, Numero_Chasis, Numero_Motor, SumaAseg_Local, SumaAseg_Moneda,
               PrimaNeta_Local, PrimaNeta_Moneda)
            VALUES
               (nIdPoliza, V.IDetPol, V.Num_Vehi, V.Cod_Marca, V.Cod_Modelo, V.Cod_Version,
               V.Anio_Vehiculo, V.Placa, V.Cantidad_Pasajeros, V.Tarjeta_Circulacion,
               V.Color, V.Numero_Chasis, V.Numero_Motor, V.SumaAseg_Moneda * nTasaCambio,
               V.SumaAseg_Moneda, V.PrimaNeta_Moneda * nTasaCambio, V.PrimaNeta_Moneda);
         END LOOP;

         IF NVL(IndAsegurados,'N') = 'S' THEN
            -- Asegurados del Detalle
            FOR Q IN ASEG_CERT_Q LOOP
               INSERT INTO ASEGURADO_CERT
                  (CodCia, IdPoliza, IDetPol, Cod_Asegurado, FechaAlta, FechaBaja,
                   CodEmpresa, SumaAseg, Primaneta, Estado)
               VALUES
                  (Q.CodCia, nIdPoliza, Q.IDetPol, Q.Cod_Asegurado, Q.FechaAlta, Q.FechaBaja,
                   Q.CodEmpresa, Q.SumaAseg, Q.Primaneta, 'XRE');
            END LOOP;

            -- Renovación de Coberturas de Detalles de Póliza de Acuerdo a Tarifas
            FOR Y IN COB_REN_Q LOOP
               OC_COBERT_ACT.CARGAR_COBERTURAS(Y.CodCia, Y.CodEmpresa, Y.IdTipoSeg, Y.PlanCob, nIdPoliza,
                                               Y.IDetPol, nTasaCambio, Y.CodCobert, Y.SumaAsegCalculada,
                                               Y.SalarioMensual,  Y.VecesSalario, Y.Edad_Minima,
                                               Y.Edad_Maxima,  Y.Edad_Exclusion, Y.SumaAseg_Minima,
                                               Y.SumaAseg_Maxima, Y.PorcExtraPrimaDet, Y.MontoExtraPrimaDet,
                                               Y.SumaIngresada);
            END LOOP;

            -- Beneficiarios de Detalles de Póliza
            FOR W IN BENEF_Q LOOP
               INSERT INTO BENEFICIARIO
               (IdPoliza, IDetPol, Cod_Asegurado, Benef, Nombre, PorcePart,
                CodParent, Estado, Sexo, FecEstado, FecAlta, FecBaja,
                MotBaja, Obervaciones, IndIrrevocable)
               VALUES (nIdPoliza, W.IDetPol, W.Cod_Asegurado, W.Benef, W.Nombre, W.PorcePart,
                W.CodParent, 'ACTIVO', W.Sexo, dFechoy, dFecIni, NULL,
                NULL, W.Obervaciones, W.IndIrrevocable);
            END LOOP;
         END IF;
      END IF; --- cIndSubGrupos = 'S'

      OC_AGENTES_DISTRIBUCION_POLIZA.COPIAR(nCodCia, nIdPoliza);

      -- Responsables de Pago de Póliza
      FOR W IN RESP_POL_Q LOOP
         INSERT INTO RESPONSABLE_PAGO_POL
            (IdPoliza, CodCia, Tipo_Doc_Identificacion, Num_Doc_Identificacion,
             CodResPago, FecAlta, FecBaja, StsResPago, PorcResPago, CodEmpresa)
         VALUES
            (nIdPoliza, nCodCia, W.Tipo_Doc_Identificacion, W.Num_Doc_Identificacion,
             W.CodResPago, dFecIni, NULL, 'ACT', W.PorcResPago, W.CodEmpresa);
      END LOOP;

      IF NVL(cIndSubGrupos,'N') = 'S' THEN
         -- Responsables de Pago de Detalles de Póliza
         FOR W IN RESP_DET_Q LOOP
            INSERT INTO RESPONSABLE_PAGO_DET
               (IdPoliza, CodCia, IDetPol, Tipo_Doc_Identificacion, Num_Doc_Identificacion,
                CodResPago, FecAlta, FecBaja, StsResPago, PorcResPago, CodEmpresa)
            VALUES
               (nIdPoliza, nCodCia, W.IDetPol, W.Tipo_Doc_Identificacion, W.Num_Doc_Identificacion,
                W.CodResPago, dFecIni, NULL, 'ACT', W.PorcResPago, W.CodEmpresa);
         END LOOP;
      END IF;

      -- Recargos de Póliza
      FOR W IN RECARGOS_Q LOOP
         INSERT INTO RECARGOS
            (IdPoliza, CodCia, CodRec, Porc_Recargo, Monto_Local, Monto_Moneda,
             Inicio_Vigencia, Fin_Vigencia, Observaciones, Estado, Fec_Estado)
         VALUES
            (nIdPoliza, nCodCia, W.CodRec, W.Porc_Recargo, W.Monto_Local, W.Monto_Moneda,
             dFecIni, dFecFin, W.Observaciones, 'ACT', dFecHoy);
      END LOOP;

      IF NVL(cIndSubGrupos,'N') = 'S' THEN
         -- Detalle de Recargos de Póliza
         FOR W IN DET_REC_Q LOOP
            INSERT INTO DETALLE_RECARGO
               (IdPoliza, CodCia, IDetPol, CodRec, Porc_Recargo, Monto_Local, Monto_Moneda,
                Inicio_Vigencia, Fin_Vigencia, Observaciones, Estado, Fec_Estado)
            VALUES
               (nIdPoliza, nCodCia, W.IDetpol, W.CodRec, W.Porc_Recargo, W.Monto_Local, W.Monto_Moneda,
                dFecIni, dFecFin, W.Observaciones, 'ACT', dFecHoy);
         END LOOP;
      END IF;

      -- Descuentos de Póliza
      FOR W IN DESC_Q LOOP
         INSERT INTO DESCUENTOS
            (IdPoliza, CodCia, CodDesc, Porc_Desc, Monto_Local, Monto_Moneda,
             Ini_Vigencia, Fin_Vigencia, Observaciones, Estado, Fecha_Estado)
         VALUES
            (nIdPoliza, nCodCia, W.CodDesc, W.Porc_Desc, W.Monto_Local, W.Monto_Moneda,
             dFecIni, dFecFin, W.Observaciones, 'ACT', dFecHoy);
      END LOOP;

      IF NVL(cIndSubGrupos,'N') = 'S' THEN
         -- Detalle de Descuentos de Póliza
         FOR W IN DET_DESC_Q LOOP
            INSERT INTO DETALLE_DESCUENTO
               (IdPoliza, CodCia, IDetPol, CodDesc, Porc_Desc, Monto_Local, Monto_Moneda,
                Ini_Vigencia, Fin_Vigencia, Observaciones, Estado, Fecha_Estado)
            VALUES
               (nIdPoliza, nCodCia, W.IDetPol, W.CodDesc, W.Porc_Desc, W.Monto_Local, W.Monto_Moneda,
                dFecIni, dFecFin, W.Observaciones, 'ACT', dFecHoy);
         END LOOP;
      END IF;

      -- Claúsulas de Póliza
      OC_CLAUSULAS_POLIZA.RENOVAR(nCodCia, nIdPolizaRen, nIdPoliza);

      IF NVL(cIndSubGrupos,'N') = 'S' THEN
         -- Claúsulas Detalle de Póliza
         OC_CLAUSULAS_DETALLE.RENOVAR(nCodCia, nIdPolizaRen, nIdPoliza);

         -- Tarjetas Detalle de Póliza
         FOR W IN TARJ_POL_Q LOOP
            INSERT INTO DETALLE_POLIZAS_TARJETAS
               (IdPoliza, Id_DetallePolizasPago, CodLista, CodValor,
                IDetPol, FecVence, NumTarjeta, StsDet)
            VALUES
               (nIdPoliza, W.Id_DetallePolizasPago, W.CodLista, W.CodValor,
                W.IDetPol, W.FecVence, W.NumTarjeta, 'ACT');
         END LOOP;
      END IF;

      -- Documento de Póliza
      FOR W IN DOC_POL_Q LOOP
         INSERT INTO DOCUMENTO_POLIZA
            (IdPoliza, CodCia, IdDocumentoPoliza, IdDocumento)
         VALUES
            (nIdPoliza, nCodCia, W.IdDocumentoPoliza, W.IdDocumento);
      END LOOP;

      IF NVL(cIndSubGrupos,'N') = 'S' THEN
         -- Inspecciones
         FOR W IN INSPEC_Q LOOP
            INSERT INTO INSPECCION
               (IdPoliza, CodCia, Num_Inspeccion, IDetPol, Num_Vehi,
                Encargado, FecRequi, Observaciones)
            VALUES
               (nIdPoliza, nCodCia, W.Num_Inspeccion, W.IDetPol, W.Num_Vehi,
                W.Encargado, W.FecRequi, W.Observaciones);
         END LOOP;

         -- Examenes
         FOR W IN EXAMEN_Q LOOP
            INSERT INTO EXAMEN
               (IdPoliza, CodCia, IDetPol, Id_Examen, CodMedico,
                Descripcion_Examen, Fecha_Examen, Lugar_Examen, Estado_Examen)
            VALUES
               (nIdPoliza, nCodCia, W.IDetPol, W.Id_Examen, W.CodMedico,
                W.Descripcion_Examen, NULL, W.Lugar_Examen, 'XRE');
         END LOOP;
      END IF;

      -- Requisitos Póliza
      FOR W IN REQ_POL_Q LOOP
         INSERT INTO REQUISITOS_ENC_POLIZA
            (IdPoliza, CodCia, CodRequisito, FecSolicitReq,
             FecEntregaReq, Observaciones)
         VALUES
            (nIdPoliza, nCodCia, W.CodRequisito, dFecHoy,
             NULL, W.Observaciones);
      END LOOP;

      IF NVL(cIndSubGrupos,'N') = 'S' THEN
         -- Requisitos Detalles Póliza
         FOR W IN REQ_DET_Q LOOP
            INSERT INTO REQUISITOS_POLIZA
               (IdPoliza, CodCia, IDetPol, CodRequisito, FecSolicitReq,
               FecEntregaReq, Observaciones, CodUsuario)
            VALUES
               (nIdPoliza, nCodCia, W.IDetPol, W.CodRequisito, dFecHoy,
                NULL, W.Observaciones, USER);
         END LOOP;

         IF NVL(IndAsegurados,'N') = 'S' THEN
            OC_ASEGURADO_CERTIFICADO.RENOVAR(nCodCia, nIdPolizaRen, nIdPoliza);

            FOR D IN COBASEGCERT_Q LOOP
               OC_COBERT_ACT_ASEG.CARGAR_COBERTURAS(D.CodCia, D.CodEmpresa, D.IdTipoSeg, D.PlanCob, nIdPoliza,
                                                    D.IDetPol, nTasaCambio, D.Cod_Asegurado, D.CodCobert, D.SumaAsegCalculada,
                                                    D.SalarioMensual,  D.VecesSalario, D.Edad_Minima,
                                                    D.Edad_Maxima,  D.Edad_Exclusion, D.SumaAseg_Minima,
                                                    D.SumaAseg_Maxima, D.PorcExtraPrimaDet, D.MontoExtraPrimaDet,
                                                    D.SumaIngresada);
            END LOOP;
         END IF;

         OC_ASISTENCIAS_DETALLE_POLIZA.RENOVAR(nCodCia, nIdPolizaRen, nIdPoliza);

         IF NVL(IndAsegurados,'N') = 'S' THEN
            OC_ASISTENCIAS_ASEGURADO.RENOVAR(nCodCia, nIdPolizaRen, nIdPoliza);
         END IF;

         FOR W IN DET_REN_Q LOOP
            OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, W.IDetPol, 0);
         END LOOP;
      END IF;
      OC_POLIZAS.ACTUALIZA_VALORES(nCodCia, nIdPoliza, 0);
   END IF;
   UPDATE POLIZAS
      SET StsPoliza = 'REN',
          FecSts    = dFecHoy
    WHERE IdPoliza  = nIdPolizaRen
      AND CodCia    = nCodCia;


   UPDATE DETALLE_POLIZA
      SET StsDetalle = 'REN'
    WHERE IdPoliza  = nIdPolizaRen
      AND CodCia    = nCodCia;

   UPDATE COBERT_ACT
      SET StsCobertura = 'REN'
    WHERE IdPoliza     = nIdPolizaRen
      AND CodCia       = nCodCia;

   UPDATE COBERTURAS
      SET StsCobertura = 'REN'
    WHERE IdPoliza     = nIdPolizaRen
      AND CodCia       = nCodCia;

   UPDATE ASISTENCIAS_DETALLE_POLIZA
      SET StsAsistencia = 'RENOVA'
    WHERE IdPoliza     = nIdPolizaRen
      AND CodCia       = nCodCia;

   UPDATE COBERT_ACT_ASEG
      SET StsCobertura = 'REN'
    WHERE IdPoliza     = nIdPolizaRen
      AND CodCia       = nCodCia;

   UPDATE COBERTURA_ASEG
      SET StsCobertura = 'REN'
    WHERE IdPoliza     = nIdPolizaRen
      AND CodCia       = nCodCia;

   UPDATE ASISTENCIAS_ASEGURADO
      SET StsAsistencia = 'RENOVA'
    WHERE IdPoliza     = nIdPolizaRen
      AND CodCia       = nCodCia;

   UPDATE ASEGURADO_CERTIFICADO
      SET Estado = 'REN'
    WHERE IdPoliza     = nIdPolizaRen
      AND CodCia       = nCodCia;

   UPDATE CLAUSULAS_POLIZA
      SET Estado = 'RENOVA'
    WHERE IdPoliza     = nIdPolizaRen
      AND CodCia       = nCodCia;

   UPDATE CLAUSULAS_DETALLE
      SET Estado = 'RENOVA'
    WHERE IdPoliza     = nIdPolizaRen
      AND CodCia       = nCodCia;
   DBMS_OUTPUT.PUT_LINE(cEmitePoliza);
   IF cEmitePoliza = 'S' THEN
      BEGIN
         OC_POLIZAS.EMITIR_POLIZA(nCodCia, nIdPoliza, nCodEmpresa);
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20225,'Error al Emitir Renovación de Póliza: '||TRIM(TO_CHAR(nIdPoliza))|| ' ' ||SQLERRM);
      END;
   END IF;
   RETURN(nIdPoliza);
--EXCEPTION
--   WHEN OTHERS THEN
--      RAISE_APPLICATION_ERROR(-20225,'Error al Renovar Póliza: '||TRIM(TO_CHAR(nIdPoliza))|| ' ' ||SQLERRM);
END RENOVAR;

   FUNCTION EXISTE_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2 IS
   cExiste  VARCHAR2(1);
   BEGIN
      BEGIN
         SELECT 'S'
      INTO cExiste
      FROM POLIZAS
          WHERE CodCia     = nCodCia
       AND CodEmpresa = nCodEmpresa
       AND IdPoliza   = nIdPoliza;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
       cExiste := 'N';
         WHEN TOO_MANY_ROWS THEN
       cExiste := 'S';
      END;
      RETURN(cExiste);
   END EXISTE_POLIZA;

   FUNCTION TOTAL_PRIMA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN NUMBER IS
   nPrimaTotal      DETALLE_POLIZA.Prima_Moneda%TYPE;
   BEGIN
      SELECT SUM(D.Prima_Moneda)
        INTO nPrimaTotal
        FROM DETALLE_POLIZA D, POLIZAS P
       WHERE D.StsDetalle IN  ('SOL','XRE','EMI')
         AND D.IdPoliza   = P.IdPoliza
         AND P.IdPoliza   = nIdPoliza;
      RETURN(nPrimaTotal);
   END TOTAL_PRIMA;

    FUNCTION TOTAL_ASEGURADOS( nCodCia      NUMBER
                             , nCodEmpresa  NUMBER
                             , nIdPoliza    NUMBER ) RETURN NUMBER IS
       nTotalAseg         NUMBER(10);
       nCantAsegModelo    NUMBER(10);
       cIndCotizacionWeb  COTIZACIONES.IndCotizacionWeb%TYPE;
    BEGIN
       BEGIN
          SELECT NVL(C.IndCotizacionWeb, 'N')
          INTO   cIndCotizacionWeb
          FROM   COTIZACIONES C
             ,   POLIZAS      P
          WHERE  C.CodCia       = P.CodCia
            AND  C.CodEmpresa   = P.CodEmpresa
            AND  C.IdCotizacion = P.Num_Cotizacion
            AND  P.CodCia       = nCodCia
            AND  P.CodEmpresa   = nCodEmpresa
            AND  P.IdPoliza     = nIdPoliza;
       EXCEPTION
       WHEN NO_DATA_FOUND THEN
            cIndCotizacionWeb := 'N';
       END;
       --
       SELECT COUNT(*)
         INTO nTotalAseg
         FROM ASEGURADO_CERTIFICADO AC, DETALLE_POLIZA D, POLIZAS P
        WHERE AC.IDetPol   = D.IDetPol
          AND AC.IdPoliza  = D.IdPoliza
          AND D.StsDetalle IN  ('SOL','XRE','EMI')
          AND D.IdPoliza   = P.IdPoliza
          AND P.CodEmpresa = nCodEmpresa
          AND P.CodCia     = nCodCia
          AND P.IdPoliza   = nIdPoliza;
       --
       IF cIndCotizacionWeb = 'S' THEN
          SELECT NVL(SUM(CantAsegModelo),0)
          INTO   nCantAsegModelo
          FROM TIPOS_DE_SEGUROS TS, DETALLE_POLIZA D, POLIZAS P
          WHERE TS.TipoSeg      = 'P'
            AND TS.IdTipoSeg    = D.IdTipoSeg
            AND TS.CodEmpresa   = D.CodEmpresa
            AND TS.CodCia       = D.CodCia
            AND D.IndAsegModelo = 'S'
            AND D.StsDetalle   IN ('SOL','XRE','EMI')
            AND D.IdPoliza      = P.IdPoliza
            AND P.CodEmpresa    = nCodEmpresa
            AND P.CodCia        = nCodCia
            AND P.IdPoliza      = nIdPoliza;
          --
          IF nCantAsegModelo > 0 THEN
             nTotalAseg := nCantAsegModelo;
          END IF;
       ELSE
          SELECT NVL(SUM(CantAsegModelo),0) + NVL(nTotalAseg,0)
          INTO nTotalAseg
          FROM TIPOS_DE_SEGUROS TS, DETALLE_POLIZA D, POLIZAS P
          WHERE TS.TipoSeg      = 'P'
            AND TS.IdTipoSeg    = D.IdTipoSeg
            AND TS.CodEmpresa   = D.CodEmpresa
            AND TS.CodCia       = D.CodCia
            AND D.IndAsegModelo = 'S'
            AND D.StsDetalle   IN ('SOL','XRE','EMI')
            AND D.IdPoliza      = P.IdPoliza
            AND P.CodEmpresa    = nCodEmpresa
            AND P.CodCia        = nCodCia
            AND P.IdPoliza      = nIdPoliza;
       END IF;

       IF NVL(nTotalAseg,0) = 0 THEN
          SELECT COUNT(*)
            INTO nTotalAseg
            FROM TIPOS_DE_SEGUROS TS, DETALLE_POLIZA D, POLIZAS P
           WHERE TS.TipoSeg      = 'P'
             AND TS.IdTipoSeg    = D.IdTipoSeg
             AND TS.CodEmpresa   = D.CodEmpresa
             AND TS.CodCia       = D.CodCia
             AND D.IndAsegModelo = 'N'
             AND D.StsDetalle   IN ('SOL','XRE','EMI')
             AND D.IdPoliza      = P.IdPoliza
             AND P.CodEmpresa    = nCodEmpresa
             AND P.CodCia        = nCodCia
             AND P.IdPoliza      = nIdPoliza;
       END IF;

       RETURN(nTotalAseg);

    END TOTAL_ASEGURADOS;

   FUNCTION APLICA_SAMI(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2 IS
   cIndAplicaSAMI      VARCHAR2(1);
   BEGIN
      BEGIN
         SELECT 'S'
      INTO cIndAplicaSAMI
      FROM DETALLE_POLIZA D, POLIZAS P, PLAN_COBERTURAS PC
          WHERE PC.IndAplicaSAMI = 'S'
       AND PC.PlanCob       = D.PlanCob
       AND PC.IdTipoSeg     = D.IdTipoSeg
       AND PC.CodEmpresa    = P.CodEmpresa
       AND PC.CodCia        = P.CodCia
       AND D.StsDetalle    IN  ('SOL','XRE','EMI')
       AND D.IdPoliza       = P.IdPoliza
       AND P.IdPoliza       = nIdPoliza;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
       cIndAplicaSAMI := 'N';
         WHEN TOO_MANY_ROWS THEN
       cIndAplicaSAMI := 'S';
      END;
      RETURN(cIndAplicaSAMI);
   END APLICA_SAMI;

   PROCEDURE CALCULA_SAMI(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) IS
   nTotSumaAsegLocal     COBERT_ACT.SumaAseg_Local%TYPE;
   nSamiPromedio         POLIZAS.SAMIPoliza%TYPE;
   nSamiPoliza           POLIZAS.SAMIPoliza%TYPE;
   cCod_Moneda           POLIZAS.Cod_Moneda%TYPE;
   nTasaCambio           TASAS_CAMBIO.Tasa_Cambio%TYPE;
   nTotalAseg            NUMBER(10);
   nRangoSAMI            NUMBER(5);

   CURSOR COB_Q IS
      SELECT CA.IDetPol, CA.IdTipoSeg, CA.PlanCob, CA.CodCobert, CA.SumaAseg_Moneda, CA.Tasa,
        'COBERT_ACT' Origen
        FROM COBERT_ACT CA, DETALLE_POLIZA DP
       WHERE DP.IDetPol         = CA.IDetPol
         AND DP.IdPoliza        = CA.IdPoliza
         AND CA.SumaAseg_Moneda > nSamiPoliza
         AND CA.StsCobertura   IN ('SOL','EMI','XRE')
         AND CA.IdEndoso        = 0
         AND CA.IdPoliza        = nIdPoliza
         AND CA.CodEmpresa      = nCodEmpresa
         AND CA.CodCia          = nCodCia
       UNION
      SELECT CA.IDetPol, CA.IdTipoSeg, CA.PlanCob, CA.CodCobert, CA.SumaAseg_Moneda, CA.Tasa,
        'COBERT_ACT_ASEG' Origen
        FROM COBERT_ACT_ASEG CA, DETALLE_POLIZA DP
       WHERE DP.IDetPol         = CA.IDetPol
         AND DP.IdPoliza        = CA.IdPoliza
         AND CA.SumaAseg_Moneda > nSamiPoliza
         AND CA.StsCobertura   IN ('SOL','EMI','XRE')
         AND CA.IdEndoso        = 0
         AND CA.IdPoliza        = nIdPoliza
         AND CA.CodEmpresa      = nCodEmpresa
         AND CA.CodCia          = nCodCia;
   CURSOR COB_SAMI_Q IS
      SELECT DISTINCT IDetPol, Cod_Asegurado
        FROM COBERT_ACT
       WHERE IndCambioSami   = 'S'
         AND IdEndoso        = 0
         AND IdPoliza        = nIdPoliza
         AND CodEmpresa      = nCodEmpresa
         AND CodCia          = nCodCia
       UNION
      SELECT DISTINCT IDetPol, Cod_Asegurado
        FROM COBERT_ACT_ASEG
       WHERE IndCambioSami   = 'S'
         AND IdEndoso        = 0
         AND IdPoliza        = nIdPoliza
         AND CodEmpresa      = nCodEmpresa
         AND CodCia          = nCodCia;
   BEGIN
      BEGIN
         SELECT Cod_Moneda
      INTO cCod_Moneda
      FROM POLIZAS
          WHERE CodCia     = nCodCia
       AND CodEmpresa = nCodEmpresa
       AND IdPoliza   = nIdPoliza;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20225,'NO Existe Póliza: '||TRIM(TO_CHAR(nIdPoliza))|| ' ' ||SQLERRM);
      END;

      nTasaCambio       := OC_GENERALES.TASA_DE_CAMBIO(cCod_Moneda, TRUNC(SYSDATE));
      nTotSumaAsegLocal := OC_POLIZAS.TOTAL_SAMI(nCodCia, nCodEmpresa, nIdPoliza);
      nTotalAseg        := OC_POLIZAS.TOTAL_ASEGURADOS(nCodCia, nCodEmpresa, nIdPoliza);
      nRangoSAMI        := OC_POLIZAS.RANGO_SAMI(nCodCia, nCodEmpresa, nIdPoliza, nTotalAseg);
      nSamiPromedio     := NVL(nTotSumaAsegLocal,0) / NVL(nTotalAseg,0);
      nSamiPoliza       := NVL((nRangoSAMI + 1) * nSamiPromedio,0);

      IF NVL(nSamiPoliza,0) > 0 THEN
         UPDATE POLIZAS
       SET IndAplicoSami = 'S',
           SamiPoliza    = nSamiPoliza
          WHERE CodCia     = nCodCia
       AND CodEmpresa = nCodEmpresa
       AND IdPoliza   = nIdPoliza;

         FOR W IN COB_Q LOOP
       IF W.Origen = 'COBERT_ACT' THEN
          UPDATE COBERT_ACT
             SET IndCambioSAMI   = 'S',
            SumaAsegOrigen  = SumaAseg_Moneda,
            SumaAseg_Moneda = nSamiPoliza,
            SumaAseg_Local  = nSamiPoliza * nTasaCambio,
            Prima_Moneda    = nSamiPoliza *  W.Tasa,
            Prima_Local     = (nSamiPoliza * nTasaCambio) * W.Tasa
           WHERE CodCobert       = W.CodCobert
             AND PlanCob         = W.PlanCob
             AND IdTipoSeg       = W.IdTipoSeg
             AND IdEndoso        = 0
             AND StsCobertura   IN ('SOL','XRE')
             AND IDetPol         = W.IDetPol
             AND IdPoliza        = nIdPoliza
             AND CodEmpresa      = nCodEmpresa
             AND CodCia          = nCodCia;
       ELSIF W.Origen = 'COBERT_ACT_ASEG' THEN
          UPDATE COBERT_ACT_ASEG
             SET IndCambioSAMI   = 'S',
            SumaAsegOrigen  = SumaAseg_Moneda,
            SumaAseg_Moneda = nSamiPoliza,
            SumaAseg_Local  = nSamiPoliza * nTasaCambio,
            Prima_Moneda    = nSamiPoliza *  W.Tasa,
            Prima_Local     = (nSamiPoliza * nTasaCambio) * W.Tasa
           WHERE CodCobert       = W.CodCobert
             AND PlanCob         = W.PlanCob
             AND IdTipoSeg       = W.IdTipoSeg
             AND IdEndoso        = 0
             AND StsCobertura   IN ('SOL','XRE')
             AND IDetPol         = W.IDetPol
             AND IdPoliza        = nIdPoliza
             AND CodEmpresa      = nCodEmpresa
             AND CodCia          = nCodCia;
       END IF;
         END LOOP;
         FOR Y IN COB_SAMI_Q LOOP
       IF Y.Cod_Asegurado != 0 THEN
          OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, Y.IdetPol, Y.Cod_Asegurado);
          OC_ASEGURADO_CERTIFICADO.ACTUALIZA_ASISTENCIAS(nCodCia, nCodEmpresa, nIdPoliza, Y.IdetPol, Y.Cod_Asegurado);
       END IF;
       OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, Y.IDetPol, 0);
         END LOOP;
         OC_POLIZAS.ACTUALIZA_VALORES(nCodCia, nIdPoliza, 0);
      END IF;
   END CALCULA_SAMI;

   FUNCTION TOTAL_SAMI(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN NUMBER IS
   nTotSumaAsegLocal     COBERT_ACT.SumaAseg_Local%TYPE;
   BEGIN
      SELECT NVL(SUM(CA.SumaAseg_Moneda),0)
        INTO nTotSumaAsegLocal
        FROM COBERT_ACT CA, DETALLE_POLIZA DP, COBERTURAS_DE_SEGUROS C
       WHERE C.IndSumaSAMI    = 'S'
         AND C.CodCobert      = CA.CodCobert
         AND C.PlanCob        = CA.PlanCob
         AND C.IdTipoSeg      = CA.IdTipoSeg
         AND C.CodEmpresa     = CA.CodEmpresa
         AND C.CodCia         = CA.CodCia
         AND DP.IDetPol       = CA.IDetPol
         AND DP.IdPoliza      = CA.IdPoliza
         AND CA.StsCobertura IN ('SOL','EMI','XRE')
         AND CA.IdPoliza      = nIdPoliza
         AND CA.CodEmpresa    = nCodEmpresa
         AND CA.CodCia        = nCodCia;

      SELECT NVL(nTotSumaAsegLocal,0) + NVL(SUM(CA.SumaAseg_Moneda),0)
        INTO nTotSumaAsegLocal
        FROM COBERT_ACT_ASEG CA, DETALLE_POLIZA DP, COBERTURAS_DE_SEGUROS C
       WHERE C.IndSumaSAMI    = 'S'
         AND C.CodCobert      = CA.CodCobert
         AND C.PlanCob        = CA.PlanCob
         AND C.IdTipoSeg      = CA.IdTipoSeg
         AND C.CodEmpresa     = CA.CodEmpresa
         AND C.CodCia         = CA.CodCia
         AND DP.IDetPol       = CA.IDetPol
         AND DP.IdPoliza      = CA.IdPoliza
         AND CA.StsCobertura IN ('SOL','EMI','XRE')
         AND CA.IdPoliza      = nIdPoliza
         AND CA.CodEmpresa    = nCodEmpresa
         AND CA.CodCia        = nCodCia;
      RETURN(nTotSumaAsegLocal);
   END TOTAL_SAMI;

   FUNCTION RANGO_SAMI(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nTotalAsegurados NUMBER) RETURN NUMBER IS
   nRangoSAMI      NUMBER(5);
   BEGIN
      IF NVL(nTotalAsegurados,0) < 25 THEN
         nRangoSAMI := 2;
      ELSIF NVL(nTotalAsegurados,0) < 50 THEN
         nRangoSAMI := 3;
      ELSIF NVL(nTotalAsegurados,0) < 100 THEN
         nRangoSAMI := 4;
      ELSIF NVL(nTotalAsegurados,0) < 150 THEN
         nRangoSAMI := 5;
      ELSIF NVL(nTotalAsegurados,0) < 200 THEN
         nRangoSAMI := 6;
      ELSIF NVL(nTotalAsegurados,0) < 300 THEN
         nRangoSAMI := 7;
      ELSIF NVL(nTotalAsegurados,0) < 400 THEN
         nRangoSAMI := 8;
      ELSIF NVL(nTotalAsegurados,0) < 500 THEN
         nRangoSAMI := 9;
      ELSIF NVL(nTotalAsegurados,0) < 650 THEN
         nRangoSAMI := 10;
      ELSIF NVL(nTotalAsegurados,0) < 800 THEN
         nRangoSAMI := 11;
      ELSIF NVL(nTotalAsegurados,0) < 1000 THEN
         nRangoSAMI := 12;
      ELSIF NVL(nTotalAsegurados,0) < 1500 THEN
         nRangoSAMI := 13;
      ELSIF NVL(nTotalAsegurados,0) < 2500 THEN
         nRangoSAMI := 14;
      ELSIF NVL(nTotalAsegurados,0) > 2500 THEN
         nRangoSAMI := 15;
      END IF;

      /*IF NVL(nTotalAsegurados,0) < 10 THEN
         nRangoSAMI := 0;
      ELSIF NVL(nTotalAsegurados,0) < 25 THEN
         nRangoSAMI := 1;
      ELSIF NVL(nTotalAsegurados,0) < 50 THEN
         nRangoSAMI := 2;
      ELSIF NVL(nTotalAsegurados,0) < 100 THEN
         nRangoSAMI := 3;
      ELSIF NVL(nTotalAsegurados,0) < 150 THEN
         nRangoSAMI := 4;
      ELSIF NVL(nTotalAsegurados,0) < 200 THEN
         nRangoSAMI := 5;
      ELSIF NVL(nTotalAsegurados,0) < 300 THEN
         nRangoSAMI := 6;
      ELSIF NVL(nTotalAsegurados,0) < 400 THEN
         nRangoSAMI := 7;
      ELSIF NVL(nTotalAsegurados,0) < 500 THEN
         nRangoSAMI := 8;
      ELSE
         nRangoSAMI := 9;
      END IF;*/
      RETURN(nRangoSAMI);
   END RANGO_SAMI;

   FUNCTION SAMI_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN NUMBER IS
   nSamiPoliza   POLIZAS.SamiPoliza%TYPE;
   BEGIN
      SELECT NVL(SamiPoliza,0)
        INTO nSamiPoliza
        FROM POLIZAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdPoliza   = nIdPoliza;
      RETURN(nSamiPoliza);
   END SAMI_POLIZA;

   FUNCTION POLIZA_AUTOADMINISTRADA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2 IS
   cAutoAdministrada  VARCHAR2(1);
   BEGIN
      BEGIN
         SELECT 'S'
      INTO cAutoAdministrada
      FROM POLIZAS
          WHERE CodCia             = nCodCia
       AND CodEmpresa         = nCodEmpresa
       AND IdPoliza           = nIdPoliza
       AND TipoAdministracion LIKE 'AUT%';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
       cAutoAdministrada := 'N';
         WHEN TOO_MANY_ROWS THEN
       cAutoAdministrada := 'S';
      END;
      RETURN(cAutoAdministrada);
   END POLIZA_AUTOADMINISTRADA;

   FUNCTION POLIZA_COLECTIVA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2 IS
   cIndPolCol  VARCHAR2(1);
   BEGIN
      BEGIN
         SELECT NVL(IndPolCol,'N')
      INTO cIndPolCol
      FROM POLIZAS
          WHERE CodCia             = nCodCia
       AND CodEmpresa         = nCodEmpresa
       AND IdPoliza           = nIdPoliza;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
       cIndPolCol := 'N';
         WHEN TOO_MANY_ROWS THEN
       cIndPolCol := 'S';
      END;
      RETURN(cIndPolCol);
   END POLIZA_COLECTIVA;

   PROCEDURE REVERTIR_EMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, cTipoPol VARCHAR2) IS
   nEndosos         NUMBER(5);
   nFacturas        NUMBER(5);
   nSiniestros      NUMBER(5);
   nComprobantes    NUMBER(5);
   nIDetPol         DETALLE_POLIZA.IDetPol%TYPE;
   nNum_Cotizacion  POLIZAS.Num_Cotizacion%TYPE;

   CURSOR DET_Q IS
      SELECT IDetPol, Cod_Asegurado
        FROM DETALLE_POLIZA
       WHERE IdPoliza = nIdPoliza
         AND CodCia   = nCodCia
       UNION ALL
      SELECT Correlativo IDetPol, 0 Cod_Asegurado
        FROM FZ_DETALLE_FIANZAS
       WHERE IdPoliza = nIdPoliza
         AND CodCia   = nCodCia;

   CURSOR ASEG_Q IS
      SELECT IDetPol, Cod_Asegurado
        FROM ASEGURADO_CERTIFICADO
       WHERE IdPoliza = nIdPoliza
         AND CodCia   = nCodCia;

   CURSOR FACT_Q IS
      SELECT IdFactura, IdTransaccion
        FROM FACTURAS
       WHERE IdPoliza  = nIdPoliza
         AND CodCia    = nCodCia;

   CURSOR COMP_Q IS
      SELECT NumComprob
        FROM COMPROBANTES_CONTABLES
       WHERE CodCia    = nCodCia
         AND NumTransaccion IN (SELECT IdTransaccion
                   FROM FACTURAS
                  WHERE IdPoliza  = nIdPoliza
               AND CodCia    = nCodCia);

   CURSOR FONDOS_Q IS
      SELECT IdFondo
        FROM FAI_FONDOS_DETALLE_POLIZA
       WHERE CodAsegurado > 0
         AND IDetPol      = nIDetPol
         AND IdPoliza     = nIdPoliza
         AND CodEmpresa   = nCodEmpresa
         AND CodCia       = nCodCia;
   BEGIN
      BEGIN
         SELECT COUNT(*)
      INTO nEndosos
      FROM ENDOSOS
          WHERE IdPoliza  = nIdPoliza
       AND CodCia    = nCodCia;
      END;

      BEGIN
         SELECT COUNT(*)
      INTO nFacturas
      FROM FACTURAS
          WHERE IdPoliza  = nIdPoliza
       AND CodCia    = nCodCia
       AND StsFact  IN ('ANU','PAG');
      END;

      BEGIN
         SELECT COUNT(*) + NVL(nFacturas,0)
      INTO nFacturas
      FROM FACTURAS
          WHERE IdPoliza        = nIdPoliza
       AND CodCia          = nCodCia
       AND FecEnvFactElec IS NOT NULL;
      END;

      BEGIN
         SELECT COUNT(*)
      INTO nSiniestros
      FROM SINIESTRO
          WHERE IdPoliza  = nIdPoliza
       AND CodCia    = nCodCia;
      END;

      BEGIN
         SELECT COUNT(*)
      INTO nComprobantes
      FROM COMPROBANTES_CONTABLES
          WHERE CodCia    = nCodCia
       AND NumTransaccion IN (SELECT IdTransaccion
                 FROM FACTURAS
                WHERE IdPoliza  = nIdPoliza
                  AND CodCia    = nCodCia)
       AND FecEnvioSC IS NOT NULL;
      END;

      IF NVL(nEndosos,0) = 0 AND NVL(nFacturas,0) = 0 AND NVL(nSiniestros,0) = 0 AND
         NVL(nComprobantes,0) = 0 THEN
         UPDATE POLIZAS
       SET StsPoliza = 'SOL',
           FecSts    = TRUNC(SYSDATE)
          WHERE IdPoliza  = nIdPoliza
       AND CodCia    = nCodCia;

         UPDATE RESPONSABLE_PAGO_POL
       SET StsResPago = 'SOL'
          WHERE IdPoliza   = nIdPoliza
       AND CodCia     = nCodCia;


         UPDATE CLAUSULAS_POLIZA
       SET Estado    = 'SOLICI'
          WHERE IdPoliza  = nIdPoliza
       AND CodCia    = nCodCia;

         UPDATE CLAUSULAS_DETALLE
       SET Estado    = 'SOLICI'
          WHERE IdPoliza  = nIdPoliza
       AND CodCia    = nCodCia;

         FOR W IN DET_Q LOOP
       OC_DETALLE_POLIZA.REVERTIR_EMISION(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol);
       OC_COBERT_ACT.REVERTIR_EMISION(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol, 0);
       OC_ASISTENCIAS_DETALLE_POLIZA.REVERTIR_EMISION(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol, 0);
       OC_BENEFICIARIO.REVERTIR_ACTIVACION(nIdPoliza, W.IDetPol, W.Cod_Asegurado);
       nIDetPol  := W.IDetPol;

       FOR F IN FONDOS_Q LOOP
          GT_FAI_FONDOS_DETALLE_POLIZA.REVERTIR_EMISION(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, W.Cod_Asegurado, F.IdFondo);
       END LOOP;
         END LOOP;

         UPDATE RESPONSABLE_PAGO_DET
       SET StsResPago = 'SOL'
          WHERE IdPoliza   = nIdPoliza
       AND CodCia     = nCodCia;

         UPDATE CLAUSULAS_DETALLE
       SET Estado    = 'SOL'
          WHERE IdPoliza  = nIdPoliza
       AND CodCia    = nCodCia;

         FOR Z IN ASEG_Q LOOP
       OC_COBERT_ACT_ASEG.REVERTIR_EMISION(nCodCia, nCodEmpresa, nIdPoliza, Z.IDetPol, Z.Cod_Asegurado, 0);
       OC_ASISTENCIAS_ASEGURADO.REVERTIR_EMISION(nCodCia, nCodEmpresa, nIdPoliza, Z.IDetPol, Z.Cod_Asegurado, 0);
       OC_ASEGURADO_CERTIFICADO.REVERTIR_EMISION(nCodCia, nIdPoliza, Z.IDetPol, Z.Cod_Asegurado, 0);
       OC_BENEFICIARIO.REVERTIR_ACTIVACION(nIdPoliza, Z.IDetPol, Z.Cod_Asegurado);
         END LOOP;

         IF cTipoPol = 'F' THEN
       UPDATE FZ_DETALLE_FIANZAS
          SET Estado    = 'SOL'
        WHERE IdPoliza  = nIdPoliza
          AND CodCia    = nCodCia;
         END IF;

         FOR Y IN COMP_Q LOOP
       OC_COMPROBANTES_DETALLE.ELIMINA_DETALLE(nCodCia, Y.NumComprob);
       OC_COMPROBANTES_CONTABLES.ELIMINA_COMPROBANTE(nCodCia, Y.NumComprob);
         END LOOP;

         OC_COMISIONES.REVERSA_COMISION(nCodCia, nIdPoliza);

         FOR X IN FACT_Q LOOP
       DELETE DETALLE_FACTURAS
        WHERE IdFactura = X.IdFactura;

       DELETE FACTURAS
        WHERE IdFactura = X.IdFactura;

       DELETE REA_DISTRIBUCION
        WHERE IdTransaccion = X.IdTransaccion;

       OC_DETALLE_TRANSACCION.ELIMINAR(nCodCia, nCodEmpresa, X.IdTransaccion);
       OC_TRANSACCION.ELIMINAR(nCodCia, nCodEmpresa, X.IdTransaccion);
         END LOOP;

         OC_SOLICITUD_EMISION.REVERTIR_EMISION(nCodCia, nCodEmpresa, nIdPoliza);

         SELECT Num_Cotizacion
      INTO nNum_Cotizacion
      FROM POLIZAS
          WHERE IdPoliza = nIdPoliza
       AND CodCia   = nCodCia;

         IF GT_COTIZACIONES.EXISTE_COTIZACION_EMITIDA(nCodCia, nCodEmpresa, nNum_Cotizacion) = 'S' THEN
       GT_COTIZACIONES.REVIERTE_EMISION_POLIZA(nCodCia, nCodEmpresa, nNum_Cotizacion);
         END IF;
      ELSE
         RAISE_APPLICATION_ERROR(-20225,'NO puede Revertir la Emisión porque la Póliza No. ' || TRIM(TO_CHAR(nIdPoliza)) ||
                  ' Ya Tiene Movimientos ó sus Datos ya fueron Enviados a Otros Sistemas');
      END IF;
   END REVERTIR_EMISION;

   PROCEDURE COPIAR(nCodCia NUMBER, nIdPolizaOrig NUMBER) IS
   dFecHoy       DATE;
   nIdPoliza     POLIZAS.IdPoliza%TYPE;
   nIDetPol      DETALLE_POLIZA.IDetPol%TYPE;
   cTipoSeg      TIPOS_DE_SEGUROS.TipoSeg%TYPE;
   cNumPolUnico  POLIZAS.NumPolUnico%TYPE;
   p_msg_regreso varchar2(50);----var XDS
   cINDRAMOREAL  VARCHAR2(100);
   cESRamoReal   VARCHAR2(1);

   CURSOR POL_Q IS
      SELECT CodEmpresa, TipoPol, NumPolRef, SumaAseg_Local, SumaAseg_Moneda,
        PrimaNeta_Local, PrimaNeta_Moneda, DescPoliza, PorcComis, IndExaInsp,
        Cod_Moneda, Num_Cotizacion, CodCliente, Cod_Agente, CodPlanPago,
        Medio_Pago, NumPolUnico, IndPolCol, IndProcFact, Caracteristica,
        IndFactPeriodo, FormaVenta, TipoRiesgo, IndConcentrada, TipoDividendo,
        CodGrupoEc, IndAplicoSami, SamiPoliza, TipoAdministracion, NumRenov,
        HoraVigIni, HoraVigFin, CodAgrupador, IndFacturaPol,
        IndFactElectronica, IndCalcDerechoEmis, CodDirecRegional, PorcDescuento,
        PorcGtoAdmin, PorcGtoAdqui, PorcUtilidad, FactorAjuste, MontoDeducible,
        FactFormulaDeduc, CodRiesgoRea, CodTipoBono, HorasVig, DiasVig,
        IndExtraPrima, AsegAdheridosPor, PorcenContributorio,
        FuenteRecursosPrima, IdFormaCobro, DiaCobroAutomatico, IndManejaFondos,
        TipoProrrata, IndConvenciones, CodTipoNegocio, CodPaqComercial,
        CodOficina,CodCatego
        --MLJS 07/08/2024 SE AGREGAN LOS SIGUIENTES CAMPOS
        , codobjetoimp, codusocfdi 
        FROM POLIZAS
       WHERE IdPoliza = nIdPolizaOrig
         AND CodCia   = nCodCia;

   CURSOR DET_Q IS
      SELECT IDetPol, Cod_Asegurado, CodEmpresa, CodPlanPago, Suma_Aseg_Local,
        Suma_Aseg_Moneda, Prima_Local, Prima_Moneda, IdTipoSeg, Tasa_Cambio,
        PorcComis,  NULL CodContrato, NULL CodProyecto, NULL Cod_Moneda,
        PlanCob, MontoComis, NumDetRef, FecAnul, Motivanul, CodPromotor,
        IndDeclara, IndSinAseg, CodFilial, CodCategoria, IndFactElectronica,
        IndAsegModelo, CantAsegModelo, MontoComisH, PorcComisH, IdDirecAviCob,
        IdFormaCobro, MontoAporteFondo
        ,codobjetoimp, codusocfdi  --MLJS 07/08/2024 SE AGREGAN
        FROM DETALLE_POLIZA
       WHERE IdPoliza = nIdPolizaOrig
         AND CodCia   = nCodCia
       UNION
      SELECT Correlativo IDetPol, 0 Cod_Asegurado, CodEmpresa, CodPlanPago,
        MontoLocal Suma_Aseg_Local, MontoMoneda Suma_Aseg_Moneda, PrimaLocal Prima_Local,
        PrimaMoneda Prima_Moneda, IdTipoSeg,0 Tasa_Cambio, PorcComis, CodContrato,
        CodProyecto, Cod_Moneda, NULL PlanCob, 0 MontoComis, NULL NumDetRef, NULL FecAnul,
        NULL Motivanul, NULL CodPromotor, NULL IndDeclara, NULL IndSinAseg,
        NULL CodFilial, NULL CodCategoria, NULL IndFactElectronica,
        'N' IndAsegModelo, 0 CantAsegModelo, 0 MontoComisH, 0 PorcComisH, NULL IdDirecAviCob,
        NULL IdFormaCobro, 0 MontoAporteFondo
        ,NULL codobjetoimp, NULL codusocfdi  --MLJS 07/08/2024 SE AGREGAN
        FROM FZ_DETALLE_FIANZAS
       WHERE IdPoliza = nIdPolizaOrig
         AND CodCia   = nCodCia;

   CURSOR COB_Q IS
     SELECT CA.IDetPol, CA.CodEmpresa, CA.CodCia, DP.IdTipoSeg, CA.CodCobert,
       CA.SumaAseg_Moneda, CA.Prima_Moneda, TipoRef, CA.NumRef, CA.IdEndoso,
       CA.PlanCob, CA.Cod_Moneda, CA.Deducible_Local, CA.Deducible_Moneda,
       CA.Cod_Asegurado, CA.IDRAMOREAL
       FROM COBERT_ACT CA, DETALLE_POLIZA DP
      WHERE DP.IDetPol  = CA.IDetPol
        AND DP.IdPoliza = CA.IdPoliza
        AND CA.IdPoliza = nIdPolizaOrig
        AND CA.CodCia   = nCodCia;

   CURSOR PER_Q IS
      SELECT IDetPol, Estatura, Peso, Cavidad_Toraxica_Min, Cavidad_Toraxica_Max,
        Capacidad_Abdominal, Presion_Arterial_Min, Presion_Arterial_Max,
        Pulso, Mortalidad, Suma_Aseg_Moneda, Suma_Aseg_Local,
        Extra_Prima_Moneda, Extra_Prima_Local, Id_Fumador,
        Observaciones, Porc_SubNormal, Prima_Local, Prima_Moneda
        FROM DATOS_PARTICULARES_PERSONAS
       WHERE IdPoliza = nIdPolizaOrig
         AND CodCia   = nCodCia;

   CURSOR BIEN_Q IS
      SELECT Num_Bien, IDetPol, CodPais, CodEstado, CodCiudad, CodMunicipio,
        Ubicacion_Bien, Tipo_Bien, Suma_Aseg_Local_Bien, Suma_Aseg_Moneda_Bien,
        Prima_Neta_Local_Bien, Prima_Neta_Moneda_Bien
        FROM DATOS_PARTICULARES_BIENES
       WHERE IdPoliza = nIdPolizaOrig
         AND CodCia   = nCodCia;

   CURSOR AUTO_Q IS
      SELECT IDetPol, Num_Vehi, Cod_Marca, Cod_Version, Cod_Modelo, Anio_Vehiculo,
        Placa, Cantidad_Pasajeros, Tarjeta_Circulacion, Color, Numero_Chasis,
        Numero_Motor, SumaAseg_Local, SumaAseg_Moneda, PrimaNeta_Local,
        PrimaNeta_Moneda
        FROM DATOS_PARTICULARES_VEHICULO
       WHERE IdPoliza = nIdPolizaOrig
         AND CodCia   = nCodCia;

   CURSOR AGTE_POL_Q IS
      SELECT Cod_Agente, Porc_Comision, Ind_Principal, Origen
        FROM AGENTE_POLIZA
       WHERE CodCia   = nCodCia
         AND IdPoliza = nIdPolizaOrig;

   CURSOR AGTE_DIST_POL_Q IS
      SELECT Cod_Agente, CodNivel, Cod_Agente_Distr, Porc_Comision_Agente,
        Porc_Com_Distribuida, Porc_Comision_Plan, Porc_Com_Proporcional,
        Cod_Agente_Jefe, Porc_Com_Poliza, Origen
        FROM AGENTES_DISTRIBUCION_POLIZA
       WHERE CodCia   = nCodCia
         AND IdPoliza = nIdPolizaOrig;

   CURSOR AGENTES_Q IS
      SELECT A.Cod_Agente, A.Ind_Principal, A.Porc_Comision, A.Origen
        FROM AGENTES_DETALLES_POLIZAS A
       WHERE IDetPol  = nIDetPol
         AND CodCia   = nCodCia
         AND IdPoliza = nIdPolizaOrig;

   CURSOR AGTE_DIST_DET_Q IS
      SELECT CodNivel, Cod_Agente, Cod_Agente_Distr, Porc_Comision_Plan,
        Porc_Comision_Agente, Porc_Com_Distribuida, Porc_Com_Proporcional,
        Cod_Agente_Jefe, Origen
        FROM AGENTES_DISTRIBUCION_COMISION
       WHERE IDetPol  = nIDetPol
         AND CodCia   = nCodCia
         AND IdPoliza = nIdPolizaOrig;

   CURSOR ASEG_CERT_Q IS
      SELECT CodCia, IdPoliza, Cod_Asegurado, FechaAlta, FechaBaja, CodEmpresa,
        SumaAseg, Primaneta
        FROM ASEGURADO_CERT
       WHERE IDetPol  = nIDetPol
         AND IdPoliza = nIdPolizaOrig
         AND CodCia   = nCodCia;
   BEGIN
      SELECT TRUNC(SYSDATE)
        INTO dFecHoy
        FROM DUAL;
      FOR X IN POL_Q LOOP
         /**
         SELECT NVL(MAX(IdPoliza),0)+1
      INTO nIdPoliza
      FROM POLIZAS;**/
      /** Cambio a Sequencia XDS **/

        nIdPoliza :=OC_POLIZAS.F_GET_NUMPOL(p_msg_regreso);

         BEGIN
       cNumPolUnico := TRIM(TO_CHAR(nIdPoliza)) || '-' || TRIM(TO_CHAR(X.NumRenov,'00'));
       INSERT INTO POLIZAS
             (IdPoliza, CodEmpresa, CodCia, TipoPol, NumPolRef,
         FecIniVig, FecFinVig, FecSolicitud, FecEmision, FecRenovacion,
         StsPoliza, FecSts, FecAnul, MotivAnul, SumaAseg_Local, SumaAseg_Moneda,
         PrimaNeta_Local, PrimaNeta_Moneda, DescPoliza, PorcComis, NumRenov,
         IndExaInsp, Cod_Moneda, Num_Cotizacion, CodCliente, Cod_Agente,
         CodPlanPago, Medio_Pago, NumPolUnico, IndPolCol, IndProcFact,
         Caracteristica, IndFactPeriodo, FormaVenta, TipoRiesgo,
         IndConcentrada, TipoDividendo, CodGrupoEc, IndAplicoSami,
         SamiPoliza, TipoAdministracion, HoraVigIni, HoraVigFin, CodAgrupador,
         IndFacturaPol, IndFactElectronica, IndCalcDerechoEmis, CodDirecRegional,
         PorcDescuento, PorcGtoAdmin, PorcGtoAdqui, PorcUtilidad, FactorAjuste, MontoDeducible,
         FactFormulaDeduc, CodRiesgoRea, CodTipoBono, HorasVig, DiasVig,
         IndExtraPrima, AsegAdheridosPor, PorcenContributorio,
         FuenteRecursosPrima, IdFormaCobro, DiaCobroAutomatico, IndManejaFondos,
         TipoProrrata, IndConvenciones, CodTipoNegocio, CodPaqComercial,
         CodOficina, CodCatego
         ,codobjetoimp, codusocfdi)  --MLJS 07/08/2024 SE AGREGAN)
       VALUES(nIdPoliza, X.CodEmpresa, nCodCia, X.TipoPol, X.NumPolRef,
         dFecHoy, ADD_MONTHS(dFecHoy,12), dFecHoy, dFecHoy, ADD_MONTHS(dFecHoy,12),
         'SOL', dFecHoy, NULL, NULL, X.SumaAseg_Local, X.SumaAseg_Moneda,
         X.PrimaNeta_Local, X.PrimaNeta_Moneda, X.DescPoliza, X.PorcComis, X.NumRenov,
         X.IndExaInsp, X.Cod_Moneda, X.Num_Cotizacion, X.CodCliente, X.Cod_Agente,
         X.CodPlanPago, X.Medio_Pago, cNumPolUnico, X.IndPolCol, X.IndProcFact,
         X.Caracteristica, X.IndFactPeriodo, X.FormaVenta, X.TipoRiesgo,
         X.IndConcentrada, X.TipoDividendo, X.CodGrupoEc, X.IndAplicoSami,
         X.SamiPoliza, X.TipoAdministracion, X.HoraVigIni, X.HoraVigFin, X.CodAgrupador,
         X.IndFacturaPol, X.IndFactElectronica, X.IndCalcDerechoEmis, X.CodDirecRegional,
         X.PorcDescuento, X.PorcGtoAdmin, X.PorcGtoAdqui, X.PorcUtilidad, X.FactorAjuste, X.MontoDeducible,
         X.FactFormulaDeduc, X.CodRiesgoRea, X.CodTipoBono, X.HorasVig, X.DiasVig,
         X.IndExtraPrima, X.AsegAdheridosPor, X.PorcenContributorio,
         X.FuenteRecursosPrima, X.IdFormaCobro, X.DiaCobroAutomatico, X.IndManejaFondos,
         X.TipoProrrata, X.IndConvenciones, X.CodTipoNegocio, X.CodPaqComercial,
         X.CodOficina, X.CodCatego
         ,X.codobjetoimp, X.codusocfdi);  --MLJS 07/08/2024 SE AGREGAN
         EXCEPTION
       WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20225,'Error en Copiado de Nueva Póliza ' ||SQLERRM);
         END;

        --IF  X.Num_Cotizacion > 0 THEN
          --  GT_POLIZAS_TEXTO_COTIZACION.INSERTA(nCodCia, X.CodEmpresa, X.Num_Cotizacion, nIdPoliza);
         --END IF;

         OC_CLAUSULAS_POLIZA.COPIAR(nCodCia, nIdPolizaOrig, nIdPoliza);

         FOR G IN AGTE_POL_Q LOOP
         INSERT INTO AGENTE_POLIZA
           (IdPoliza, CodCia, Cod_Agente, Porc_Comision,
            Ind_Principal, Origen)
         VALUES (nIdPoliza, nCodCia, G.Cod_Agente, G.Porc_Comision,
            G.Ind_Principal, G.Origen);
         END LOOP;

         FOR D IN AGTE_DIST_POL_Q LOOP
         INSERT INTO AGENTES_DISTRIBUCION_POLIZA
           (IdPoliza, CodCia, Cod_Agente, CodNivel, Cod_Agente_Distr, Porc_Comision_Agente,
            Porc_Com_Distribuida, Porc_Comision_Plan, Porc_Com_Proporcional,
            Cod_Agente_Jefe, Porc_Com_Poliza, Origen)
         VALUES (nIdPoliza, nCodCia, D.Cod_Agente, D.CodNivel, D.Cod_Agente_Distr, D.Porc_Comision_Agente,
            D.Porc_Com_Distribuida, D.Porc_Comision_Plan, D.Porc_Com_Proporcional,
            D.Cod_Agente_Jefe, D.Porc_Com_Poliza, D.Origen);
         END LOOP;

         FOR Y IN DET_Q LOOP
       nIDetPol := Y.IDetPol;
       BEGIN
          SELECT DISTINCT TipoSeg
            INTO cTipoSeg
            FROM TIPOS_DE_SEGUROS
           WHERE IdTipoSeg  = Y.IdTipoSeg
             AND CodCia     = nCodCia
             AND CodEmpresa = Y.CodEmpresa;
       END;
       BEGIN
          IF cTipoSeg != 'F' THEN
             INSERT INTO DETALLE_POLIZA
              (IdPoliza, IDetPol, CodCia, Cod_Asegurado, CodEmpresa, CodPlanPago,
               Suma_Aseg_Local, Suma_Aseg_Moneda, Prima_Local, Prima_Moneda,
               FecIniVig, FecFinVig, IdTipoSeg,  Tasa_Cambio, PorcComis, StsDetalle,
               PlanCob, MontoComis, NumDetRef, FecAnul, Motivanul, CodPromotor,
               IndDeclara, IndSinAseg, CodFilial, CodCategoria, IndFactElectronica,
               IndAsegModelo, CantAsegModelo, MontoComisH, PorcComisH, IdDirecAviCob,
               IdFormaCobro, MontoAporteFondo
               ,codobjetoimp, codusocfdi ) -- MLJS 07/08/2024
             VALUES(nIdPoliza, Y.IDetPol, nCodCia, Y.Cod_Asegurado, Y.CodEmpresa, Y.CodPlanPago,
               Y.Suma_Aseg_Local, Y.Suma_Aseg_Moneda, Y.Prima_Local, Y.Prima_Moneda,
               dFecHoy, ADD_MONTHS(dFecHoy,12), Y.IdTipoSeg, Y.Tasa_Cambio, Y.PorcComis, 'SOL',
               Y.PlanCob, Y.MontoComis, Y.NumDetRef, Y.FecAnul, Y.Motivanul, Y.CodPromotor,
               Y.IndDeclara, Y.IndSinAseg, Y.CodFilial, Y.CodCategoria, Y.IndFactElectronica,
               Y.IndAsegModelo, Y.CantAsegModelo, Y.MontoComisH, Y.PorcComisH, Y.IdDirecAviCob,
               Y.IdFormaCobro, Y.MontoAporteFondo
               ,Y.codobjetoimp, Y.codusocfdi ); -- MLJS 07/08/2024
          ELSE
             INSERT INTO FZ_DETALLE_FIANZAS
              (IdPoliza, Correlativo, CodCia,  CodEmpresa,
               CodPlanPago, MontoLocal, MontoMoneda, PrimaLocal,
               PrimaMoneda, Inicio_Vigencia, Fin_Vigencia, IdTipoSeg,
               PorcComis, Estado, CodContrato, CodProyecto, Cod_Moneda)
             VALUES(nIdPoliza, Y.IDetPol, nCodCia, Y.CodEmpresa,
               Y.CodPlanPago, Y.Suma_Aseg_Local, Y.Suma_Aseg_Moneda, Y.Prima_Local,
               Y.Prima_Moneda, dFecHoy, ADD_MONTHS(dFecHoy,12), Y.IdTipoSeg,
               Y.PorcComis, 'SOL', Y.CodContrato, Y.CodProyecto, Y.Cod_Moneda);
          END IF ;

          --IF X.Num_Cotizacion > 0 THEN
            -- GT_DETALLE_POLIZA_COTIZ.INSERTA(nCodCia, Y.CodEmpresa, X.Num_Cotizacion, Y.IDetPol,
             --                                nIdPoliza, Y.IDetPol);
         -- END IF;
       EXCEPTION
          WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR(-20225,'Error en Copiado Insert Detalle ' ||SQLERRM);
       END;

       FOR J IN AGENTES_Q LOOP
            INSERT INTO AGENTES_DETALLES_POLIZAS
              (IdPoliza, IdetPol, IdTiposeg, Cod_Agente, Porc_Comision,
               Ind_Principal, CodCia, Origen)
            VALUES (nIdPoliza, nIDetPol, Y.IdTiposeg, J.Cod_Agente, J.Porc_Comision,
               J.Ind_Principal, nCodCia, J.Origen);
       END LOOP;

       FOR H IN AGTE_DIST_DET_Q LOOP
            INSERT INTO AGENTES_DISTRIBUCION_COMISION
              (CodCia, IdPoliza, IdetPol, CodNivel, Cod_Agente, Cod_Agente_Distr,
               Porc_Comision_Plan, Porc_Comision_Agente, Porc_Com_Distribuida,
               Porc_Com_Proporcional, Cod_Agente_Jefe, Origen)
            VALUES (nCodCia, nIdPoliza, nIDetPol, H.CodNivel, H.Cod_Agente, H.Cod_Agente_Distr,
               H.Porc_Comision_Plan, H.Porc_Comision_Agente, H.Porc_Com_Distribuida,
               H.Porc_Com_Proporcional, H.Cod_Agente_Jefe, H.Origen);
       END LOOP;

       FOR Q IN ASEG_CERT_Q LOOP
          INSERT INTO ASEGURADO_CERT
            (CodCia, IdPoliza, IdetPol, Cod_Asegurado, FechaAlta, FechaBaja,
             CodEmpresa, SumaAseg, Primaneta, Estado)
          VALUES (Q.CodCia, nIdPoliza, nIdetPol, Q.Cod_Asegurado, Q.FechaAlta, Q.FechaBaja,
             Q.CodEmpresa, Q.SumaAseg, Q.Primaneta, 'SOL');
       END LOOP;

       OC_ASEGURADO_CERTIFICADO.COPIAR(nCodCia, nIdPolizaOrig, nIDetPol, nIdPoliza, nIDetPol);

       OC_COBERT_ACT_ASEG.COPIAR(nCodCia, nIdPolizaOrig, nIDetPol, nIdPoliza, nIDetPol);

       OC_ASISTENCIAS_ASEGURADO.COPIAR(nCodCia, nIdPolizaOrig, nIDetPol, nIdPoliza, nIDetPol);

       OC_ASISTENCIAS_DETALLE_POLIZA.COPIAR(nCodCia, nIdPolizaOrig, nIDetPol, nIdPoliza, nIDetPol);

       OC_BENEFICIARIO.COPIAR(nIdPolizaOrig, nIDetPol, Y.Cod_Asegurado, nIdPoliza, nIDetPol, Y.Cod_Asegurado);

       GT_FAI_FONDOS_DETALLE_POLIZA.COPIAR_FONDOS(nCodCia, Y.CodEmpresa, nIdPolizaOrig, nIDetPol, Y.Cod_Asegurado, nIdPoliza);
         END LOOP;

       IF cTipoSeg != 'F' THEN


       FOR Z IN COB_Q LOOP

             -- CAPELE
             cESRamoReal := NVL(OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(Z.CODCIA,Z.CODEMPRESA, Z.IDTIPOSEG ), 'N');

             IF cESRamoReal = 'S' AND Z.IDRAMOREAL IS NULL THEN
                cINDRAMOREAL := OC_COBERTURAS_DE_SEGUROS.COBERTURA_IDRAMOREAL(Z.CodCia, Z.CODEMPRESA, Z.IdTipoSeg, Z.PlanCob, Z.CodCobert);
             ELSE
                cINDRAMOREAL := Z.IDRAMOREAL;
             END IF;
            --
            INSERT INTO COBERT_ACT
           (IdPoliza,  IDetPol, CodEmpresa, CodCia, CodCobert, StsCobertura,
            SumaAseg_Local, SumaAseg_Moneda, Prima_Local, Prima_Moneda, Tasa,
            IdEndoso, IdTipoSeg, TipoRef, NumRef, PlanCob, Cod_Moneda,
            Deducible_Local, Deducible_Moneda, Cod_Asegurado, IDRAMOREAL)
          VALUES(nIdPoliza, Z.IDetPol, Z.CodEmpresa, Z.CodCia, Z.CodCobert, 'SOL',
            Z.SumaAseg_Moneda, Z.SumaAseg_Moneda, Z.Prima_Moneda, Z.Prima_Moneda, NULL,
            0, Z.IdTipoSeg, Z.TipoRef, Z.NumRef, Z.PlanCob, Z.Cod_Moneda,
            Z.Deducible_Local, Z.Deducible_Moneda, Z.Cod_Asegurado, cINDRAMOREAL);
       END LOOP;

       FOR W IN PER_Q LOOP
          INSERT INTO DATOS_PARTICULARES_PERSONAS
           (IdPoliza, IDetPol, Estatura, Peso, Cavidad_Toraxica_Min,
            Cavidad_Toraxica_Max, Capacidad_Abdominal, Presion_Arterial_Min,
            Presion_Arterial_Max, Pulso, Mortalidad, Suma_Aseg_Moneda,
            Suma_Aseg_Local, Extra_Prima_Moneda, Extra_Prima_Local, Id_Fumador,
            Observaciones, Porc_SubNormal, Prima_Local, Prima_Moneda)
          VALUES(nIdPoliza, W.IDetPol, W.Estatura, W.Peso, W.Cavidad_Toraxica_Min,
            W.Cavidad_Toraxica_Max, W.Capacidad_Abdominal, W.Presion_Arterial_Min,
            W.Presion_Arterial_Max, W.Pulso, W.Mortalidad, W.Suma_Aseg_Moneda,
            W.Suma_Aseg_Local,  W.Extra_Prima_Moneda, W.Extra_Prima_Local, W.Id_Fumador,
            W.Observaciones, W.Porc_SubNormal, W.Prima_Local, W.Prima_Moneda);
       END LOOP;
       FOR B IN BIEN_Q LOOP
          INSERT INTO DATOS_PARTICULARES_BIENES
           (IdPoliza, Num_Bien, IDetPol, CodPais, CodEstado, CodCiudad,
            CodMunicipio, Ubicacion_Bien, Tipo_Bien, Suma_Aseg_Local_Bien,
            Suma_Aseg_Moneda_Bien,Prima_Neta_Local_Bien, Prima_Neta_Moneda_Bien,
            Inicio_Vigencia, Fin_Vigencia)
          VALUES(nIdPoliza, B.Num_Bien, B.IDetPol, B.CodPais, B.CodEstado, B.CodCiudad,
            B.CodMunicipio, B.Ubicacion_Bien, B.Tipo_Bien, B.Suma_Aseg_Local_Bien,
            B.Suma_Aseg_Moneda_Bien, B.Prima_Neta_Local_Bien, B.Prima_Neta_Moneda_Bien,
            dFecHoy, ADD_MONTHS(dFecHoy,12));
       END LOOP;
       FOR A IN AUTO_Q LOOP
          INSERT INTO DATOS_PARTICULARES_VEHICULO
           (IdPoliza, IDetPol, Num_Vehi, Cod_Marca, Cod_Version,
            Cod_Modelo, Anio_Vehiculo, Placa, Cantidad_Pasajeros,
            Tarjeta_Circulacion, Color, Numero_Chasis, Numero_Motor,
            SumaAseg_Local, SumaAseg_Moneda, PrimaNeta_Local, PrimaNeta_Moneda)
          VALUES(nIdPoliza, A.IDetPol, A.Num_Vehi, A.Cod_Marca, A.Cod_Version,
            A.Cod_Modelo, A.Anio_Vehiculo, A.Placa, A.Cantidad_Pasajeros,
            A.Tarjeta_Circulacion, A.Color, A.Numero_Chasis, A.Numero_Motor,
            A.SumaAseg_Local, A.SumaAseg_Moneda,  A.PrimaNeta_Local, A.PrimaNeta_Moneda);
       END LOOP;
         END IF;
      END LOOP;
   END COPIAR;

   FUNCTION DERECHOS_EMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2 IS
   cIndCalcDerechoEmis    POLIZAS.IndCalcDerechoEmis%TYPE;
   BEGIN
      BEGIN
         SELECT IndCalcDerechoEmis
      INTO cIndCalcDerechoEmis
      FROM POLIZAS
          WHERE CodCia             = nCodCia
       AND CodEmpresa         = nCodEmpresa
       AND IdPoliza           = nIdPoliza;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
       cIndCalcDerechoEmis := 'N';
         WHEN TOO_MANY_ROWS THEN
       cIndCalcDerechoEmis := 'S';
      END;
      RETURN(cIndCalcDerechoEmis);
   END DERECHOS_EMISION;

   FUNCTION FACTURA_ELECTRONICA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2 IS
   cIndFactElectronica    POLIZAS.IndFactElectronica%TYPE;
   BEGIN
      BEGIN
         SELECT IndFactElectronica
      INTO cIndFactElectronica
      FROM POLIZAS
          WHERE CodCia             = nCodCia
       AND CodEmpresa         = nCodEmpresa
       AND IdPoliza           = nIdPoliza;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
       cIndFactElectronica := 'N';
         WHEN TOO_MANY_ROWS THEN
       cIndFactElectronica := 'S';
      END;
      RETURN(cIndFactElectronica);
   END FACTURA_ELECTRONICA;

   PROCEDURE REHABILITACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) IS
   nIdTransaccionAnu     FACTURAS.IdTransaccionAnu%TYPE;
   nIdTransaccionAnuNc   FACTURAS.IdTransaccionAnu%TYPE;
   nIdTransaccionEmiNc   FACTURAS.IdTransaccionAnu%TYPE;
   nIdTransaccion        TRANSACCION.IdTransaccion%TYPE;
   dFecTransaccion       TRANSACCION.FechaTransaccion%TYPE;
   nPrimaNeta_Moneda     POLIZAS.PrimaNeta_Moneda%TYPE;
   cStsPoliza            POLIZAS.StsPoliza%TYPE;
   dFecAnul              POLIZAS.FecAnul%TYPE;
   nIdTransacNc          TRANSACCION.IdTransaccion%TYPE;
   nIdTransacNcRehab     TRANSACCION.IdTransaccion%TYPE;
   nTotNotaCredCanc      DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;

   CURSOR ASEG_Q IS
      SELECT IDetPol, Cod_Asegurado
        FROM ASEGURADO_CERTIFICADO
       WHERE IdPoliza = nIdPoliza;

   CURSOR DET_Q IS
      SELECT IDetPol, Cod_Asegurado, Prima_Moneda
        FROM DETALLE_POLIZA
       WHERE IdPoliza   = nIdPoliza
         AND CodCia     = nCodCia;

   CURSOR FACT_Q IS
      SELECT IdFactura
        FROM FACTURAS
       WHERE IdTransaccionAnu = nIdTransaccionAnu
         AND IdPoliza         = nIdPoliza
       ORDER BY IdFactura;

   CURSOR NCR_Q IS
      SELECT IdNcr, CodCia, IdPoliza, IDetPol, IdEndoso
        FROM NOTAS_DE_CREDITO
       WHERE IdPoliza      = nIdPoliza
         AND IdTransaccion = nIdTransaccionEmiNc
         AND StsNcr        = 'EMI';

   CURSOR NCR_ANU_Q IS
      SELECT IdNcr, CodCia, IdPoliza, IDetPol, IdEndoso
        FROM NOTAS_DE_CREDITO
       WHERE IdPoliza         = nIdPoliza
         AND IdTransaccionAnu = nIdTransaccionAnuNc;
   BEGIN
      BEGIN
         SELECT StsPoliza, PrimaNeta_Moneda, FecAnul
      INTO cStsPoliza, nPrimaNeta_Moneda, dFecAnul
      FROM POLIZAS
          WHERE CodCia    = nCodCia
       AND IdPoliza  = nIdPoliza;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20225,'NO existe la Póliza No. ' || TRIM(TO_CHAR(nIdPoliza)) || ' para Rehabilitarla');
      END;

      IF cStsPoliza = 'ANU' THEN
         UPDATE POLIZAS
       SET StsPoliza = 'EMI',
           Fecanul   = NULL,
           MotivAnul = NULL,
           FecSts    = TRUNC(SYSDATE)
          WHERE IdPoliza = nIdPoliza;

         nIdTransaccion  := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 18, 'REHAB');
         dFecTransaccion := OC_TRANSACCION.FECHATRANSACCION(nIdTransaccion);

         OC_DETALLE_TRANSACCION.CREA (nIdTransaccion, nCodCia,  nCodEmpresa, 18, 'REHAB', 'POLIZAS',
                  nIdPoliza, NULL, NULL, NULL, nPrimaNeta_Moneda);

         FOR W IN DET_Q LOOP
           OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia,  nCodEmpresa, 18, 'REHAB', 'DETALLE_POLIZA',
                         nIdPoliza, W.IDetPol, NULL, NULL, W.Prima_Moneda);
           OC_DETALLE_POLIZA.REHABILITAR(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol);
           OC_COBERT_ACT.REHABILITAR(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol);
           OC_ASISTENCIAS_DETALLE_POLIZA.REHABILITAR(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol);
           OC_BENEFICIARIO.REHABILITAR(nIdPoliza, W.IDetPol, W.Cod_Asegurado);
         END LOOP;

         FOR X IN ASEG_Q LOOP
       OC_ASEGURADO_CERTIFICADO.REHABILITAR(nCodCia, nIdPoliza, X.IdetPol, X.Cod_Asegurado);
       OC_COBERT_ACT_ASEG.REHABILITAR(nCodCia, nCodEmpresa, nIdPoliza, X.IdetPol, X.Cod_Asegurado);
       OC_ASISTENCIAS_ASEGURADO.REHABILITAR(nCodCia, nCodEmpresa, nIdPoliza, X.IdetPol, X.Cod_Asegurado);
       OC_BENEFICIARIO.REHABILITAR(nIdPoliza, X.IDetPol, X.Cod_Asegurado);
         END LOOP;

         UPDATE ENDOSOS
       SET StsEndoso = 'EMI',
           FecAnul   = NULL,
           MotivAnul = NULL,
           FecSts    = TRUNC(SYSDATE)
          WHERE IdPoliza  = nIdPoliza
       AND StsEndoso = 'ANU'
       AND FecAnul   = dFecAnul;

         -- Rehabilita Facturas Anuladas
         SELECT MAX(T.IdTransaccion)
      INTO nIdTransaccionAnu
      FROM TRANSACCION T, DETALLE_TRANSACCION D
          WHERE D.CodSubProceso      = 'FAC'
       AND D.CodCia             = nCodCia
       AND D.CodEmpresa         = nCodEmpresa
       AND TO_NUMBER(D.Valor1)  = nIdPoliza
       AND TO_NUMBER(D.Valor2) != 0
       AND T.IdTransaccion      = D.IdTransaccion
       AND T.IdProceso          = 2;

         FOR W IN FACT_Q LOOP
       OC_FACTURAS.REHABILITACION(nCodCia, nCodEmpresa, W.IdFactura, nIdTransaccion);
         END LOOP;

         OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, '100');
         GT_REA_DISTRIBUCION.DISTRIBUYE_REASEGURO(nCodCia, nCodEmpresa, nIdPoliza,
                         nIdTransaccion, dFecTransaccion, 'EMISION');
         -- Rehabilita Notas de Crédito Anuladas
         SELECT MAX(T.IdTransaccion)
      INTO nIdTransaccionAnuNc
      FROM TRANSACCION T, DETALLE_TRANSACCION D
          WHERE D.CodSubProceso     = 'ANUNCR'
       AND D.CodCia            = nCodCia
       AND D.CodEmpresa        = nCodEmpresa
       AND TO_NUMBER(D.Valor1) = nIdPoliza
       AND T.IdTransaccion     = D.IdTransaccion
       AND T.IdProceso         = 8;

         FOR W IN NCR_ANU_Q LOOP
       IF NVL(nIdTransacNcRehab,0) = 0 THEN
          nIdTransacNcRehab := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 18, 'REHNCR');
       END IF;

       OC_NOTAS_DE_CREDITO.REHABILITACION(nCodCia, nCodEmpresa, W.IdNcr, nIdTransacNcRehab);
         END LOOP;

         IF nIdTransacNcRehab != 0 THEN
       OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacNcRehab, '100');
         END IF;

         -- Anula Notas de Crédito de la Anulación
         SELECT MAX(T.IdTransaccion)
      INTO nIdTransaccionEmiNc
      FROM TRANSACCION T, DETALLE_TRANSACCION D
          WHERE D.CodSubProceso     = 'NOTACR' 
       AND D.CodCia            = nCodCia
       AND D.CodEmpresa        = nCodEmpresa
       AND TO_NUMBER(D.Valor1) = nIdPoliza
       AND T.IdTransaccion     = D.IdTransaccion
       AND T.IdProceso         = 2;

         FOR X IN NCR_Q LOOP
       IF NVL(nIdTransacNc,0) = 0 THEN
          nIdTransacNc := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 8, 'ANUNCR');
       END IF;

       -- Acumula Prima Devuelta
       SELECT NVL(SUM(Monto_Det_Moneda),0)
         INTO nTotNotaCredCanc
         FROM DETALLE_NOTAS_DE_CREDITO D, NOTAS_DE_CREDITO N, CATALOGO_DE_CONCEPTOS C
        WHERE C.CodConcepto      = D.CodCpto
          AND C.CodCia           = N.CodCia
          AND (D.IndCptoPrima    = 'S'
           OR C.IndCptoServicio  = 'S')
          AND D.IdNcr            = N.IdNcr
          AND N.IdNcr            = X.IdNcr;

       OC_NOTAS_DE_CREDITO.ANULAR(X.IdNcr, TRUNC(SYSDATE), 'REHAB', nIdTransacNc);

       OC_DETALLE_TRANSACCION.CREA(nIdTransacNc, nCodCia,  nCodEmpresa, 8, 'ANUNCR', 'NOTAS_DE_CREDITO',
                    nIdPoliza, X.IDetPol, X.IdEndoso, X.IdNcr, nTotNotaCredCanc);
         END LOOP;

         IF NVL(nIdTransacNc,0) != 0 THEN
       OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacNc, 'C');
         END IF;
         --
         OC_ENDOSO.ENDOSO_REHABILITACION(nCodCia, nCodEmpresa , nIdPoliza);  --ENDCAN
         --
      ELSE
         RAISE_APPLICATION_ERROR(-20225,'La Póliza No. ' || TRIM(TO_CHAR(nIdPoliza)) || ' NO está Anulada para Rehabilitarse');
      END IF;
   END REHABILITACION;
   --
   PROCEDURE ANULAR_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, dFecAnul DATE,
            cMotivAnul VARCHAR2, cCod_Moneda VARCHAR2, cTipoProceso VARCHAR2) IS
   dFecAnulReal         POLIZAS.FecAnul%TYPE;
   nTotPrimaPag         FACTURAS.Monto_Fact_Moneda%TYPE;
   nTotPrimaEmit        FACTURAS.Monto_Fact_Moneda%TYPE;
   cIndFacturaPol       POLIZAS.IndFacturaPol%TYPE;
   nPrimaCanc           POLIZAS.PrimaNeta_Moneda%TYPE;
   dFecIniVig           POLIZAS.FecIniVig%TYPE;
   dFecFinVig           POLIZAS.FecFinVig%TYPE;
   nCodCliente          POLIZAS.CodCliente%TYPE;
   nPorcComis           POLIZAS.PorcComis%TYPE;
   cCodPlanPago         POLIZAS.CodPlanPago%TYPE;
   nTasaCambio          TASAS_CAMBIO.Tasa_Cambio%TYPE;
   cTipoPol             POLIZAS.TipoPol%TYPE;
   cNumPolRef           POLIZAS.NumPolRef%TYPE;
   cIndFactElectronica  POLIZAS.IndFactElectronica%TYPE;
   nTotPrimaCanc        DETALLE_FACTURAS.Saldo_Det_Moneda%TYPE;
   nTotPrimaFact        DETALLE_FACTURAS.Saldo_Det_Moneda%TYPE;
   nIdTransacNc         TRANSACCION.IdTransaccion%TYPE;
   nIdTransacAnul       TRANSACCION.IdTransaccion%TYPE;
   nIdTransacEmiNc      TRANSACCION.IdTransaccion%TYPE;
   nTotNotaCredCanc     DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
   nIdNcr               NOTAS_DE_CREDITO.IdNcr%TYPE;
   nMtoNcrLocal         NOTAS_DE_CREDITO.Monto_NCR_Local%TYPE;
   nMtoNcrMoneda        NOTAS_DE_CREDITO.Monto_NCR_Moneda%TYPE;
   nMtoComisLocal       NOTAS_DE_CREDITO.MtoComisi_Local%TYPE;
   nMtoComisMoneda      NOTAS_DE_CREDITO.MtoComisi_Moneda%TYPE;
   cIdTipoSeg           DETALLE_POLIZA.IdTipoSeg%TYPE;
   nIDetPol             DETALLE_POLIZA.IDetPol%TYPE;
   nCod_Agente          AGENTE_POLIZA.Cod_Agente%TYPE;
   nIdEndoso            ENDOSOS.IdEndoso%TYPE;
   nCod_Asegurado       DETALLE_POLIZA.Cod_Asegurado%TYPE; -- GTC - 17-12-2018
   nFactor              NUMBER (14,8);
   nDiasAno             NUMBER(6) := 365;
   nDiasPagados         NUMBER(6);
   nCantAsegSubgrupo    NUMBER(6);
   cFactPoliza          VARCHAR2(1);
   cFactEndosos         VARCHAR2(1);
   cAnulaPoliza         VARCHAR2(1);
   cAnulaSubgrupo       VARCHAR2(1);
   cAnulaEndoso         VARCHAR2(1);
   cContabiliza         VARCHAR2(1);
   nFactProrrata        NUMBER(11,8);
   nDiasAnul            NUMBER(6);
   nCertEmi             NUMBER(10);
   nEndosos             NUMBER(5);
   
   CURSOR PRIMA_Q IS
      SELECT F.StsFact, F.IdFactura, NVL(D.Monto_Det_Moneda,0) Monto_Det_Moneda,
        D.Saldo_Det_Moneda, F.IdEndoso, F.FecVenc
        FROM DETALLE_FACTURAS D, FACTURAS F, CATALOGO_DE_CONCEPTOS C
       WHERE C.CodConcepto      = D.CodCpto
         AND C.CodCia           = F.CodCia
         AND (D.IndCptoPrima    = 'S'
          OR C.IndCptoServicio  = 'S')
         AND D.IdFactura        = F.IdFactura
         AND F.StsFact         != 'ANU'
         AND F.IdPoliza         = nIdPoliza
         AND F.CodCia           = nCodCia;

   CURSOR FAC_Q IS
      SELECT IdetPol, IdFactura, CodCia, CodCobrador, FolioFactElec
        FROM FACTURAS
       WHERE IdPoliza = nIdPoliza
         AND StsFact  = 'EMI';

   CURSOR NCR_Q IS
      SELECT IdNcr, CodCia, IdPoliza, IDetPol, IdEndoso, FolioFactElec
        FROM NOTAS_DE_CREDITO
       WHERE IdPoliza = nIdPoliza
         AND StsNcr   = 'EMI';

   CURSOR CPTO_PRIMAS_Q IS
      SELECT CS.CodCpto, SUM(C.Prima_Local) Prima_Local, SUM(C.Prima_Moneda) Prima_Moneda
        FROM COBERT_ACT C, COBERTURAS_DE_SEGUROS CS
       WHERE CS.CodCobert    = C.CodCobert
         AND CS.PlanCob      = C.PlanCob
         AND CS.IdTipoSeg    = C.IdTipoSeg
         AND CS.CodEmpresa   = C.CodEmpresa
         AND CS.CodCia       = C.CodCia
         AND C.StsCobertura  = 'EMI'
         AND C.IdPoliza      = nIdPoliza
         AND C.CodCia        = nCodCia
       GROUP BY CS.CodCpto
       UNION
      SELECT CS.CodCpto, SUM(C.Prima_Local) Prima_Local, SUM(C.Prima_Moneda) Prima_Moneda
        FROM COBERT_ACT_ASEG C, COBERTURAS_DE_SEGUROS CS
       WHERE CS.CodCobert    = C.CodCobert
         AND CS.PlanCob      = C.PlanCob
         AND CS.IdTipoSeg    = C.IdTipoSeg
         AND CS.CodEmpresa   = C.CodEmpresa
         AND CS.CodCia       = C.CodCia
         AND C.StsCobertura  = 'EMI'
         AND C.IdPoliza      = nIdPoliza
         AND C.CodCia        = nCodCia
       GROUP BY CS.CodCpto;

   CURSOR CPTO_ASIST_Q IS
      SELECT T.CodCptoServicio, SUM(A.MontoAsistLocal) MontoAsistLocal,
        SUM(A.MontoAsistMoneda) MontoAsistMoneda
        FROM ASISTENCIAS_DETALLE_POLIZA A, DETALLE_POLIZA D, ASISTENCIAS T
       WHERE T.CodAsistencia  = A.CodAsistencia
         AND D.IDetPol        = A.IDetPol
         AND D.IdPoliza       = A.IdPoliza
         AND D.CodCia         = A.CodCia
         AND A.StsAsistencia  = 'EMITID'
         AND A.IdPoliza       = nIdPoliza
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
         AND A.StsAsistencia  = 'EMITID'
         AND A.IdPoliza       = nIdPoliza
         AND A.CodCia         = nCodCia
       GROUP BY T.CodCptoServicio;

   CURSOR ASEG_Q IS
      SELECT IDetPol, Cod_Asegurado
        FROM ASEGURADO_CERTIFICADO
       WHERE IdPoliza = nIdPoliza
         AND CodCia   = nCodCia
         AND Estado   = 'EMI';

   --Se agrega Prima_Moneda para la disribucion de la cancelación de reaseguro 310720202
   CURSOR DET_Q IS
      SELECT IDetPol, IndDeclara, Cod_Asegurado, IdTipoSeg, PlanCob, Prima_Moneda
        FROM DETALLE_POLIZA
       WHERE IdPoliza = nIdPoliza
         AND CodCia   = nCodCia
       UNION ALL
      SELECT Correlativo IDetPol, '' IndDeclara, 0 Cod_Asegurado, NULL IdTipoSeg, NULL PlanCob, 0 Prima_Moneda
        FROM FZ_DETALLE_FIANZAS
       WHERE IdPoliza = nIdPoliza
         AND CodCia   = nCodCia;

   CURSOR DET_ANU_Q IS
      SELECT DISTINCT D.IDetPol, D.IndDeclara
        FROM DETALLE_POLIZA D, FACTURAS F
       WHERE D.IdPoliza = nIdPoliza
         AND D.CodCia   = nCodCia
         AND F.IdPoliza = D.IdPoliza
         AND F.IDetPol  = D.IDetPol
         AND F.CodCia   = D.CodCia
         AND F.IdEndoso = 0
         AND F.StsFact  = 'EMI'
         AND F.FecVenc <= dFecAnul
       UNION ALL
      SELECT DISTINCT D.Correlativo IDetPol, '' IndDeclara
        FROM FZ_DETALLE_FIANZAS D, FACTURAS F
       WHERE D.IdPoliza = nIdPoliza
         AND D.CodCia   = nCodCia
         AND F.IdPoliza = D.IdPoliza
         AND F.CodCia   = D.CodCia
         AND F.IdEndoso = 0
         AND F.StsFact  = 'EMI'
         AND F.FecVenc <= dFecAnul;

   CURSOR ENDO_Q IS
      SELECT E.IDetPol, E.IdEndoso, E.TipoEndoso, E.FecIniVig
        FROM ENDOSOS E, FACTURAS F
       WHERE E.IdPoliza = nIdPoliza
         AND E.CodCia   = nCodCia
         AND F.IdPoliza = E.IdPoliza
         AND F.IDetPol  = E.IDetPol
         AND F.CodCia   = E.CodCia
         AND F.IdEndoso = E.IdEndoso
         AND F.StsFact  = 'EMI'
         AND F.FecVenc <= dFecAnul;

   CURSOR FONDOS_Q IS -- GTC - 17-12-2018
      SELECT IdFondo
        FROM FAI_FONDOS_DETALLE_POLIZA
       WHERE StsFondo      = 'EMITID'
         AND CodAsegurado  = nCod_Asegurado
         AND IDetPol       = nIDetPol
         AND IdPoliza      = nIdPoliza
         AND CodCia        = nCodCia;
   BEGIN
      SELECT COUNT(*)
        INTO nEndosos
        FROM ENDOSOS
       WHERE StsEndoso = 'SOL'
         AND IdPoliza  = nIdPoliza
         AND CodCia    = nCodCia;

      IF NVL(nEndosos,0) > 0 THEN
         RAISE_APPLICATION_ERROR(-20225,'Póliza No. ' || TRIM(TO_CHAR(nIdPoliza)) ||
                  ' Tiene Endosos en SOLICITUD, debe Emitirlos o Eliminarlos antes de Anular');
      END IF;

      SELECT FecIniVig, FecFinVig, CodCliente, IndFacturaPol,
        PorcComis, CodPlanPago, TipoPol, NumPolRef, IndFactElectronica
        INTO dFecIniVig, dFecFinVig, nCodCliente, cIndFacturaPol,
        nPorcComis, cCodPlanPago, cTipoPol, cNumPolRef, cIndFactElectronica
        FROM POLIZAS
       WHERE IdPoliza = nIdPoliza
         AND CodCia   = nCodCia;

      -- Calcula Fecha de Anulación para NO Devolver Prima
      nDiasAno      := TRUNC(dFecFinVig) - TRUNC(dFecIniVig);

      nTotPrimaPag  := 0;
      nTotPrimaEmit := 0;
      cFactPoliza   := 'N';
      cFactEndosos  := 'N';

      FOR W IN PRIMA_Q LOOP
         nTotPrimaEmit    := NVL(nTotPrimaEmit,0) + W.Monto_Det_Moneda;
         IF W.StsFact IN ('PAG','ABO') THEN
       nTotPrimaPag  := NVL(nTotPrimaPag,0) + (W.Monto_Det_Moneda - W.Saldo_Det_Moneda);
         ELSIF W.IdEndoso = 0 AND W.FecVenc <= dFecAnul THEN
       cFactPoliza   := 'S';
         ELSIF W.IdEndoso != 0 AND W.FecVenc <= dFecAnul THEN
       cFactEndosos  := 'S';
         END IF;
      END LOOP;

      IF NVL(nTotPrimaEmit,0) != 0 THEN
         nDiasPagados   := CEIL(nTotPrimaPag / (nTotPrimaEmit / nDiasAno));
      ELSE
         nDiasPagados   := 0;
      END IF;
      IF NVL(nDiasPagados,0) != 0 AND cTipoProceso != 'POLIZA' THEN
         dFecAnulReal   := dFecIniVig + nDiasPagados;
      ELSE
         dFecAnulReal   := dFecAnul;
      END IF;
      nDiasAnul      := nDiasPagados;
      nFactProrrata  := OC_GENERALES.PRORRATA(dFecIniVig, dFecFinVig, dFecAnulReal);
      nPrimaCanc     := nTotPrimaEmit * nFactProrrata;

      cAnulaPoliza   := 'N';
      cAnulaSubgrupo := 'N';
      cAnulaEndoso   := 'N';

      IF ((NVL(nTotPrimaPag,0) = 0 OR cIndFacturaPol = 'S') AND cFactPoliza = 'S') OR cTipoProceso = 'POLIZA' THEN
         cAnulaPoliza   := 'S';
      ELSIF cIndFacturaPol = 'N' AND cFactPoliza = 'S' THEN
         SELECT COUNT(DISTINCT Cod_Asegurado)
              INTO nCantAsegSubgrupo
              FROM DETALLE_POLIZA
                  WHERE CodCia     = nCodCia
               AND IdPoliza   = nIdPoliza
               AND StsDetalle = 'EMI';
         IF nCantAsegSubgrupo = 1 THEN
               cAnulaPoliza   := 'S';
         ELSE
               SELECT MIN(IdEndoso)
                 INTO nIdEndoso
                 FROM FACTURAS
                WHERE IdPoliza  = nIdPoliza
                  AND CodCia    = nCodCia
                  AND IdFactura IN (SELECT MIN(IdFactura)
                                   FROM FACTURAS
                                       WHERE IdPoliza  = nIdPoliza
                                    AND CodCia    = nCodCia
                                    AND FecVenc  <= dFecAnul
                                    AND StsFact   = 'EMI');
               IF NVL(nIdEndoso,0) = 0 THEN
                  cAnulaSubgrupo := 'S';
               ELSE
                  cAnulaEndoso   := 'S';
               END IF;
         END IF;
      ELSIF cFactEndosos = 'S' THEN
         cAnulaEndoso   := 'S';
      END IF;

      IF cAnulaPoliza = 'S' THEN
         IF NVL(nTotPrimaPag,0) = 0 THEN
       -- Anula Notas de Crédito
               IF cTipoProceso IS NOT NULL THEN
                  FOR X IN NCR_Q LOOP
                     IF NVL(nIdTransacNc,0) = 0 THEN
                   nIdTransacNc := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 8, 'ANUNCR');
                     END IF;

                     -- Acumula Prima Devuelta
                     SELECT NVL(SUM(Monto_Det_Moneda),0)
                      INTO nTotNotaCredCanc
                      FROM DETALLE_NOTAS_DE_CREDITO D, NOTAS_DE_CREDITO N, CATALOGO_DE_CONCEPTOS C
                     WHERE C.CodConcepto      = D.CodCpto
                       AND C.CodCia           = N.CodCia
                       AND (D.IndCptoPrima    = 'S'
                        OR C.IndCptoServicio  = 'S')
                       AND D.IdNcr            = N.IdNcr
                       AND N.IdNcr            = X.IdNcr;

                     OC_NOTAS_DE_CREDITO.ANULAR(X.IdNcr, dFecAnulReal, cMotivAnul, nIdTransacNc);

                     OC_DETALLE_TRANSACCION.CREA(nIdTransacNc, nCodCia,  nCodEmpresa, 8, 'ANUNCR', 'NOTAS_DE_CREDITO',
                             nIdPoliza, X.IDetPol, X.IdEndoso, X.IdNcr, nTotNotaCredCanc);
                     
                  END LOOP;

                  IF NVL(nIdTransacNc,0) != 0 THEN
                     OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacNc, 'C');
                  END IF;
               END IF;
         END IF;

         cContabiliza := 'N';
         nIdTransacAnul := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 2, 'FAC');

         OC_DETALLE_TRANSACCION.CREA (nIdTransacAnul, nCodCia,  nCodEmpresa, 2, 'POL', 'POLIZAS',
                  nIdPoliza, NULL, NULL, NULL, nPrimaCanc);

         -- Sumariza Facturas Emitidas
         nTotPrimaCanc := 0;
         FOR X IN FAC_Q LOOP
            -- Acumula Prima Anulada
               SELECT NVL(SUM(D.Saldo_Det_Moneda),0)
                 INTO nTotPrimaFact
                 FROM DETALLE_FACTURAS D, FACTURAS F, CATALOGO_DE_CONCEPTOS C
                WHERE C.CodConcepto      = D.CodCpto
                  AND C.CodCia           = F.CodCia
                  AND (D.IndCptoPrima    = 'S'
                   OR C.IndCptoServicio  = 'S')
                  AND D.IdFactura        = F.IdFactura
                  AND F.IdFactura        = X.IdFactura;

                nTotPrimaCanc := NVL(nTotPrimaCanc,0) + NVL(nTotPrimaFact,0);
                OC_FACTURAS.ANULAR(X.CodCia, X.IdFactura, dFecAnulReal, cMotivAnul, X.CodCobrador, nIdTransacAnul);
                OC_DETALLE_TRANSACCION.CREA (nIdTransacAnul, nCodCia,  nCodEmpresa, 2, 'FAC', 'FACTURAS',
                              nIdPoliza, X.IDetPol, NULL, X.IdFactura, NVL(nTotPrimaFact,0));
                cContabiliza := 'S';
         END LOOP;

         IF cContabiliza = 'S' THEN
            OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacAnul, 'C');
         END IF;

         cContabiliza := 'N';
         IF NVL(nTotPrimaCanc,0) != NVL(nPrimaCanc,0) AND NVL(nPrimaCanc,0) > NVL(nTotPrimaCanc,0) THEN
               BEGIN
                  SELECT IdTipoSeg, IDetPol
                    INTO cIdTipoSeg, nIDetPol
                    FROM DETALLE_POLIZA
                   WHERE CodCia     = nCodCia
                     AND IdPoliza   = nIdPoliza
                     AND IDetPol   IN (SELECT MIN(IDetPol)
                          FROM DETALLE_POLIZA
                         WHERE CodCia     = nCodCia
                           AND IdPoliza   = nIdPoliza
                           AND StsDetalle = 'EMI');
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     RAISE_APPLICATION_ERROR(-20225,'No Existe Certificados Emitidos en Póliza No. ' || TRIM(TO_CHAR(nIdPoliza)));
               END;

               SELECT MIN(Cod_Agente)
                 INTO nCod_Agente
                 FROM AGENTE_POLIZA
                WHERE CodCia        = nCodCia
                  AND IdPoliza      = nIdPoliza
                  AND Ind_Principal = 'S';

               IF NVL(nIdTransacEmiNc,0) = 0 THEN
                  nIdTransacEmiNc := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 2, 'NOTACR');
               END IF;

               nTasaCambio    := OC_GENERALES.TASA_DE_CAMBIO(cCod_Moneda, TRUNC(dFecAnulReal));
               nMtoNcrLocal    := (NVL(nPrimaCanc,0) - NVL(nTotPrimaCanc,0));
               nMtoNcrMoneda   := NVL(nMtoNcrLocal,0) * nTasaCambio;
               nMtoComisLocal  := NVL(nMtoNcrLocal,0) * (NVL(nPorcComis,0) / 100);
               nMtoComisMoneda := NVL(nMtoNcrMoneda,0) * (NVL(nPorcComis,0) / 100);

               cContabiliza := 'S';
               nIdNcr := OC_NOTAS_DE_CREDITO.INSERTA_NOTA_CREDITO(nCodCia, nIdPoliza, nIDetPol, 0, nCodCliente, NVL(dFecAnulReal, TRUNC(SYSDATE)),
                                    nMtoNcrLocal, nMtoNcrMoneda, nMtoComisLocal, nMtoComisMoneda,
                                    nCod_Agente, cCod_Moneda, nTasaCambio, nIdTransacEmiNc, cIndFactElectronica);
               FOR W IN CPTO_PRIMAS_Q LOOP
                  nFactor := W.Prima_Moneda / NVL(nTotPrimaEmit,0);
                  OC_DETALLE_NOTAS_DE_CREDITO.INSERTA_DETALLE_NOTA(nIdNcr, W.CodCpto, 'S', nMtoNcrLocal * nFactor, nMtoNcrMoneda * nFactor);
                  OC_DETALLE_NOTAS_DE_CREDITO.AJUSTAR(nCodCia, nIdNcr, W.CodCpto, 'S', nMtoNcrLocal * nFactor, nMtoNcrMoneda * nFactor);
                  OC_DETALLE_NOTAS_DE_CREDITO.APLICAR_RETENCION(nCodCia, nCodEmpresa, cIdTipoSeg, dFecAnulReal,
                                  nDiasAnul, cMotivAnul, nIdNcr, W.CodCpto);
               END LOOP;

               FOR K IN CPTO_ASIST_Q LOOP
                  nFactor := K.MontoAsistMoneda / NVL(nTotPrimaEmit,0);
                  OC_DETALLE_NOTAS_DE_CREDITO.INSERTA_DETALLE_NOTA(nIdNcr, K.CodCptoServicio, 'N', nMtoNcrLocal * nFactor, nMtoNcrMoneda * nFactor);
                  OC_DETALLE_NOTAS_DE_CREDITO.AJUSTAR(nCodCia, nIdNcr, K.CodCptoServicio, 'N', nMtoNcrLocal * nFactor, nMtoNcrMoneda * nFactor);
                  OC_DETALLE_NOTAS_DE_CREDITO.APLICAR_RETENCION(nCodCia, nCodEmpresa, cIdTipoSeg, dFecAnulReal,
                                  nDiasAnul, cMotivAnul, nIdNcr, K.CodCptoServicio);
               END LOOP;

               OC_DETALLE_NOTAS_DE_CREDITO.GENERA_CONCEPTOS(nCodCia, nCodEmpresa, cCodPlanPago, cIdTipoSeg,
                                   nIdNcr, nTasaCambio);
               OC_NOTAS_DE_CREDITO.ACTUALIZA_NOTA(nIdNcr);
               OC_NOTAS_DE_CREDITO.EMITIR(nIdNcr, NULL);
               DBMS_OUTPUT.put_line('OC POLIZAS nMtoNcrLocal:'||nMtoNcrLocal||'  nFactor  '||nFactor||'  nMtoNcrMoneda  '||nMtoNcrMoneda);
        
               OC_COMISIONES.INSERTA_COMISION_NC(nIdNcr);
               OC_DETALLE_TRANSACCION.CREA (nIdTransacEmiNc, nCodCia,  nCodEmpresa, 2, 'NOTACR', 'NOTAS_DE_CREDITO',
                             nIdPoliza, nIDetPol, 0, nIdNcr, nMtoNcrMoneda);
         END IF;
         --
         IF cContabiliza = 'S' THEN
            OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacEmiNc, 'C');
         END IF;
         --
         UPDATE ENDOSOS
               SET StsEndoso  = 'ANU',
                   FecAnul    = dFecAnulReal,
                   MotivAnul  = cMotivAnul,
                   FecSts     = TRUNC(SYSDATE)
                  WHERE IdPoliza   = nIdPoliza
               AND StsEndoso != 'SOL'
               AND CodCia     = nCodCia;
         --
         UPDATE DETALLE_POLIZA
               SET StsDetalle = 'ANU',
                   FecAnul   = dFecAnulReal,
                   MotivAnul = cMotivAnul
          WHERE IdPoliza  = nIdPoliza
            AND CodCia    = nCodCia;

         UPDATE POLIZAS
               SET StsPoliza = 'ANU',
                   FecSts    = TRUNC(SYSDATE),
                   FecAnul   = dFecAnulReal,
                   MotivAnul = cMotivAnul
          WHERE IdPoliza  = nIdPoliza
            AND CodCia    = nCodCia;

         OC_CLAUSULAS_POLIZA.ANULAR_TODAS(nCodCia, nIdPoliza);

         FOR W IN DET_Q LOOP
               --Se generación de detalle de transacción para la disribucion de la cancelación de reaseguro 310720202
               OC_DETALLE_TRANSACCION.CREA(nIdTransacAnul, nCodCia,  nCodEmpresa, 2, 'CER', 'DETALLE_POLIZA', nIdPoliza, W.IDetPol, NULL, NULL, W.Prima_Moneda);
               --
               -- GTC - 17-12-2018
               nIDetPol       := W.IDetPol;
               nCod_Asegurado := W.Cod_Asegurado;
               IF OC_TIPOS_DE_SEGUROS.MANEJA_FONDOS(nCodCia, nCodEmpresa, W.IdTipoSeg) = 'S' THEN -- GTC - 06/02/2019
                  IF GT_FAI_TIPOS_FONDOS_PRODUCTOS.FONDOS_COLECTIVOS(nCodCia, nCodEmpresa, W.IdTipoSeg, W.PlanCob) = 'N' THEN
                     IF cMotivAnul != 'REEX' THEN
                   IF NVL(nTotPrimaPag,0) = 0 THEN
                   null;
                --                     FOR F IN FONDOS_Q LOOP
                --                        GT_FAI_FONDOS_DETALLE_POLIZA.ANULAR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado, F.IdFondo, dFecAnulReal);
                --                     END LOOP;
                   END IF;
                     ELSE
                  -- GT_FAI_FONDOS_DETALLE_POLIZA.ANULAR_POR_REEXPEDICION(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado, dFecAnulReal);
                  null;
                     END IF;
                  END IF;
               END IF;

            -- GTC - 17-12-2018
            OC_COBERT_ACT.ANULAR(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol);
            OC_ASISTENCIAS_DETALLE_POLIZA.ANULAR(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol);
            OC_BENEFICIARIO.ANULAR(nIdPoliza, W.IDetPol, W.Cod_Asegurado);
            OC_CLAUSULAS_DETALLE.ANULAR_TODAS(nCodCia, nIdPoliza, W.IDetPol);
         END LOOP;

         FOR Z IN ASEG_Q LOOP
               OC_ASISTENCIAS_ASEGURADO.ANULAR(nCodCia, nCodEmpresa, nIdPoliza, Z.IDetPol, Z.Cod_Asegurado);
               OC_ASEGURADO_CERTIFICADO.ANULAR(nCodCia, nIdPoliza, Z.IDetPol, Z.Cod_Asegurado, dFecAnulReal, cMotivAnul);
               OC_COBERT_ACT_ASEG.ANULAR(nCodCia, nCodEmpresa, nIdPoliza, Z.IDetPol, Z.Cod_Asegurado);
               OC_BENEFICIARIO.ANULAR(nIdPoliza, Z.IDetPol, Z.Cod_Asegurado);
         END LOOP;

         IF cTipoPol != 'F' THEN
            GT_REA_DISTRIBUCION.DISTRIBUYE_REASEGURO(nCodCia, nCodEmpresa, nIdPoliza, nIdTransacAnul, TRUNC(SYSDATE), 'ANULAPOL');
            IF GT_REA_DISTRIBUCION.DISTRIB_FACULTATIVA_PEND(nCodCia, nIdTransacAnul) = 'S' THEN
                RAISE_APPLICATION_ERROR(-20200,'Póliza No. '|| cNumPolRef || ' Posee Distribución Facultativa Pendiente');
            END IF;
         END IF;
         --
         OC_ENDOSO.ENDOSO_ANULACION(nCodCia, nCodEmpresa , nIdPoliza , dFecAnulReal, cMotivAnul);  --ENDCAN
         --
      ELSIF cAnulaSubGrupo = 'S' THEN
         FOR W IN DET_ANU_Q LOOP
             OC_DETALLE_POLIZA.ANULAR_DETALLE(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol, dFecAnulReal,
                    cMotivAnul, 'N', cCod_Moneda, cTipoProceso);
         END LOOP;
         -- Valida si Debe Anular la Póliza si ya no tiene Certificados Emitidos
         SELECT COUNT(*)
           INTO nCertEmi
           FROM DETALLE_POLIZA
          WHERE CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND IdPoliza   = nIdPoliza
            AND StsDetalle = 'EMI';

        IF nCertEmi = 0 THEN
            UPDATE POLIZAS
                  SET StsPoliza = 'ANU',
                 FecSts    = TRUNC(SYSDATE),
                 FecAnul   = dFecAnulReal,
                 MotivAnul = cMotivAnul
             WHERE IdPoliza  = nIdPoliza;
        END IF;
      ELSIF cAnulaEndoso = 'S' THEN
         FOR W IN ENDO_Q LOOP
                OC_ENDOSO.ANULAR(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol, W.IdEndoso,
                        W.TipoEndoso, W.FecIniVig, cMotivAnul);
         END LOOP;
      END IF;

   EXCEPTION
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error al Anular Póliza: '||TRIM(TO_CHAR(nIdPoliza))|| ' ' ||SQLERRM);
   END ANULAR_POLIZA;

   PROCEDURE INSERTA_CLAUSULAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) IS
   cIdTipoSeg      DETALLE_POLIZA.IdTipoSeg%TYPE;
   cPlanCob        DETALLE_POLIZA.PlanCob%TYPE;
   nCod_Clausula   CLAUSULAS_DETALLE.Cod_Clausula%TYPE;
   cTextoClausula  CLAUSULAS.TextoClausula%TYPE;
   dFecIniVig      POLIZAS.FecIniVig%TYPE;
   dFecFinVig      POLIZAS.FecFinVig%TYPE;

   CURSOR DET_Q IS
      SELECT DISTINCT IdTipoSeg, PlanCob
        FROM DETALLE_POLIZA
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdPoliza   = nIdPoliza;

   CURSOR CLAU_Q IS
      SELECT C.CodClausula
        FROM CLAUSULAS_TIPOS_SEGUROS CTS, CLAUSULAS C
       WHERE CTS.IdTipoSeg   = cIdTipoSeg
         AND CTS.CodCia      = nCodCia
         AND CTS.CodEmpresa  = nCodEmpresa
         AND CTS.IDRENOVACION = 'N'  --CLAUREN
         AND C.CodClausula   = CTS.CodClausula
         AND C.CodCia        = CTS.CodCia
         AND C.CodEmpresa    = CTS.CodEmpresa
         AND C.StsClausula   = 'ACTIVA'
         AND C.IndOblig      = 'S'
       UNION
      SELECT C.CodClausula
        FROM CLAUSULAS_PLAN_COBERTURAS CTS, CLAUSULAS C
       WHERE CTS.PlanCob     = cPlanCOb
         AND CTS.IdTipoSeg   = cIdTipoSeg
         AND CTS.CodCia      = nCodCia
         AND CTS.CodEmpresa  = nCodEmpresa
         AND CTS.IDRENOVACION = 'N'  --CLAUREN
         AND C.CodClausula   = CTS.CodClausula
         AND C.CodCia        = CTS.CodCia
         AND C.CodEmpresa    = CTS.CodEmpresa
         AND C.StsClausula   = 'ACTIVA'
         AND C.IndOblig      = 'S'
       MINUS
      SELECT CP.Tipo_Clausula
        FROM CLAUSULAS_POLIZA CP
       WHERE CP.IdPoliza  = nIdPoliza
         AND CP.CodCia    = nCodCia
       MINUS
      SELECT CD.Tipo_Clausula
        FROM CLAUSULAS_DETALLE CD
       WHERE CD.IdPoliza  = nIdPoliza
         AND CD.CodCia    = nCodCia;
   BEGIN
      BEGIN
         SELECT FecIniVig, FecFinVig
      INTO dFecIniVig, dFecFinVig
      FROM POLIZAS
          WHERE IdPoliza   = nIdPoliza
       AND CodEmpresa = nCodEmpresa
       AND CodCia     = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20225,'No. de Póliza: '||TRIM(TO_CHAR(nIdPoliza))|| ' NO Existe');
      END;

      FOR Y IN DET_Q LOOP
         cIdTipoSeg := Y.IdTipoSeg;
         cPlanCob   := Y.PlanCob;
         FOR X IN CLAU_Q LOOP
       SELECT NVL(MAX(Cod_Clausula),0) + 1
         INTO nCod_Clausula
         FROM CLAUSULAS_POLIZA
        WHERE CodCia    = nCodCia
          AND IdPoliza  = nIdPoliza;

          BEGIN
             SELECT TextoClausula
          INTO cTextoClausula
         FROM CLAUSULAS
             WHERE CodCia      = nCodCia
          AND CodEmpresa  = nCodEmpresa
          AND CodClausula = X.CodClausula;
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
             cTextoClausula := NULL;
          END;

       INSERT INTO CLAUSULAS_POLIZA
         (CodCia, IdPoliza, Cod_Clausula, Tipo_Clausula,
          Texto, Inicio_Vigencia, Fin_Vigencia, Estado)
       VALUES (nCodCia, nIdPoliza, nCod_Clausula, X.CodClausula,
          cTextoClausula, dFecIniVig, dFecFinVig, 'SOLICI');
         END LOOP;
      END LOOP;
   END INSERTA_CLAUSULAS;

   FUNCTION PLAN_DE_PAGOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2 IS
   cCodPlanPago     POLIZAS.CodPlanPago%TYPE;
   BEGIN
      BEGIN
         SELECT CodPlanPago
      INTO cCodPlanPago
      FROM POLIZAS
          WHERE CodCia             = nCodCia
       AND CodEmpresa         = nCodEmpresa
       AND IdPoliza           = nIdPoliza;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20225,'No. de Póliza: '||TRIM(TO_CHAR(nIdPoliza))|| ' NO Existe');
         WHEN TOO_MANY_ROWS THEN
       RAISE_APPLICATION_ERROR(-20225,'Error al Buscar Plan de Pagos porque Existen Varias Pólizas: '||TRIM(TO_CHAR(nIdPoliza))|| ' ' ||SQLERRM);
      END;
      RETURN(cCodPlanPago);
   END PLAN_DE_PAGOS;

   FUNCTION FACTURA_POR_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2 IS
       cIndFacturaPol  POLIZAS.IndFacturaPol%TYPE;
   BEGIN
       SELECT NVL(IndFacturaPol,'N')
         INTO cIndFacturaPol
         FROM POLIZAS
        WHERE CodCia             = nCodCia
       AND CodEmpresa       = nCodEmpresa
       AND IdPoliza         = nIdPoliza;
       RETURN cIndFacturaPol;
   EXCEPTION
         WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20225,'No. de Póliza: '||TRIM(TO_CHAR(nIdPoliza))|| ' NO Existe');
         WHEN TOO_MANY_ROWS THEN
       RAISE_APPLICATION_ERROR(-20225,'Error al Buscar el Indicador de Facturación Por Póliza: '||TRIM(TO_CHAR(nIdPoliza))|| ' ' ||SQLERRM);
   END FACTURA_POR_POLIZA;

   FUNCTION CODIGO_RIESGO_REASEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2 IS
   cCodRiesgoRea        POLIZAS.CodRiesgoRea%TYPE;
   BEGIN
      BEGIN
         SELECT NVL(CodRiesgoRea,'N')
      INTO cCodRiesgoRea
      FROM POLIZAS
          WHERE CodCia        = nCodCia
       AND CodEmpresa    = nCodEmpresa
       AND IdPoliza      = nIdPoliza;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
       cCodRiesgoRea := NULL;
         WHEN TOO_MANY_ROWS THEN
       RAISE_APPLICATION_ERROR(-20225,'Error al Buscar el Código de Riesgo de Reaseguro en Póliza: '||TRIM(TO_CHAR(nIdPoliza))|| ' ' ||SQLERRM);
      END;
      RETURN(cCodRiesgoRea);
   END CODIGO_RIESGO_REASEGURO;

   FUNCTION POLIZA_INICIAL_RENOVACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN NUMBER IS
   nIdPolizaInicial        POLIZAS.IdPoliza%TYPE;
   cNumPolUnico            POLIZAS.NumPolUnico%TYPE;
   nNumRenov               POLIZAS.NumRenov%TYPE;
   cNumPolUnicoOrig        POLIZAS.NumPolUnico%TYPE;
   BEGIN
      BEGIN
        SELECT NumPolUnico, NumRenov
          INTO cNumPolUnico, nNumRenov
          FROM POLIZAS
         WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND IdPoliza    = nIdPoliza;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20225,'NO Existe Póliza Renovada No.: '||TRIM(TO_CHAR(nIdPoliza)));
      END;

      IF INSTR(cNumPolUnico,'-' || TRIM(TO_CHAR(nNumRenov,'00')),1) != 0 THEN
         cNumPolUnicoOrig := SUBSTR(cNumPolUnico,1,INSTR(cNumPolUnico,'-' || TRIM(TO_CHAR(nNumRenov,'00')),1)-1);
      ELSIF cNumPolUnico IS NOT NULL THEN
         cNumPolUnicoOrig := cNumPolUnico;
      END IF;

      SELECT NVL(MIN(IdPoliza),0)
        INTO nIdPolizaInicial
        FROM POLIZAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdPoliza   > 0
         AND NumRenov   = 0
         AND NumPolUnico LIKE cNumPolUnicoOrig || '%';

      IF NVL(nIdPolizaInicial,0) = 0 THEN
         RAISE_APPLICATION_ERROR(-20225,'NO se Encontró Póliza de Emisión Inicial de la Renovación de Póliza No.: '||TRIM(TO_CHAR(nIdPoliza)));
      ELSE
         RETURN(nIdPolizaInicial);
      END IF;
   END POLIZA_INICIAL_RENOVACION;

   FUNCTION INICIO_VIGENCIA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN DATE IS
   dFecIniVig        POLIZAS.FecIniVig%TYPE;
   BEGIN
      BEGIN
        SELECT FecIniVig
          INTO dFecIniVig
          FROM POLIZAS
         WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND IdPoliza    = nIdPoliza;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20225,'NO Existe Inicio de Vigencia de la Póliza No.: '||TRIM(TO_CHAR(nIdPoliza)));
      END;
      RETURN(dFecIniVig);
   END INICIO_VIGENCIA;

   FUNCTION NUMERO_INTENTOS_COBRANZA (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN NUMBER IS
      nNumIntentosCobranza POLIZAS.NumIntentosCobranza%TYPE;
   BEGIN
      BEGIN
         SELECT NVL(NumIntentosCobranza,0)
      INTO nNumIntentosCobranza
      FROM POLIZAS
          WHERE CodCia      = nCodCia
       AND CodEmpresa  = nCodEmpresa
       AND IdPoliza    = nIdPoliza;
         EXCEPTION
       WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20225,'NO Existe Número de Intentos de Cobranza en la Póliza No.: '||TRIM(TO_CHAR(nIdPoliza)));
      END;
      RETURN nNumIntentosCobranza;
   END NUMERO_INTENTOS_COBRANZA;

   FUNCTION APLICA_RETIRO_PRIMA_NIVELADA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2 IS
   cAplicaRetiro      VARCHAR2(1) := 'N';
   BEGIN
      BEGIN
         SELECT 'S'
      INTO cAplicaRetiro
      FROM COBERT_ACT
          WHERE CodCia          = nCodCia
       AND CodEmpresa      = nCodEmpresa
       AND IdPoliza        = nIdPoliza
       AND PrimaNivMoneda <= 0;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
       cAplicaRetiro := 'N';
         WHEN TOO_MANY_ROWS THEN
       cAplicaRetiro := 'S';
      END;

      IF cAplicaRetiro = 'N' THEN
         BEGIN
       SELECT 'S'
         INTO cAplicaRetiro
         FROM COBERT_ACT_ASEG
        WHERE CodCia          = nCodCia
          AND CodEmpresa      = nCodEmpresa
          AND IdPoliza        = nIdPoliza
          AND PrimaNivMoneda <= 0;
         EXCEPTION
       WHEN NO_DATA_FOUND THEN
          cAplicaRetiro := 'N';
       WHEN TOO_MANY_ROWS THEN
          cAplicaRetiro := 'S';
         END;
      END IF;
      RETURN(cAplicaRetiro);
   END APLICA_RETIRO_PRIMA_NIVELADA;

   PROCEDURE SEND_MAIL(cCtaEnvio IN VARCHAR2, cPwdEmail IN VARCHAR2, cEmail IN VARCHAR2, cEmailDest IN VARCHAR2, cEmailCC IN VARCHAR2 DEFAULT NULL,
             cEmailBCC IN VARCHAR2 DEFAULT NULL, cSubject IN VARCHAR2, cMessage IN VARCHAR2) IS
   cError VARCHAR2(1000);
   BEGIN
      OC_MAIL.INIT_PARAM;
      OC_MAIL.cCtaEnvio    := cCtaEnvio;
      OC_MAIL.cPwdCtaEnvio := cPwdEmail;
      OC_MAIL.SEND_EMAIL(NULL,cEmail, TRIM(cEmailDest), TRIM(cEmailCC), TRIM(cEmailBCC),
               cSubject, cMessage, NULL, NULL, NULL, NULL, cError);
      IF cError != 0 THEN
         RAISE_APPLICATION_ERROR(-20200,'Error al Enviar el Correo '||cError);
      END IF;
   END SEND_MAIL;


   PROCEDURE PRE_EMITE_POLIZA(P_CodCia NUMBER, P_CodEmpresa NUMBER, P_IdPoliza NUMBER, P_IDTRANSACCION   NUMBER) IS  -- PREEMI   INICIO
   --
   W_FE_INIVIG      PREEMISION.FE_INIVIG%TYPE;
   W_FE_FINVIG      PREEMISION.FE_FINVIG%TYPE;
   W_FE_EMISION     PREEMISION.FE_EMISION%TYPE;
   --
   BEGIN
     --
     BEGIN
       SELECT P.FECINIVIG,   P.FECFINVIG
         INTO W_FE_INIVIG,   W_FE_FINVIG
         FROM POLIZAS P
        WHERE P.IdPoliza = P_IdPoliza
          AND P.CodCia   = P_CodCia;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
       W_FE_INIVIG := NULL;
       W_FE_FINVIG := NULL;
       W_FE_EMISION := NULL;
       WHEN OTHERS THEN
       W_FE_INIVIG := NULL;
       W_FE_FINVIG := NULL;
       W_FE_EMISION := NULL;
     END;
     --
     UPDATE COBERTURAS
        SET STSCOBERTURA = 'PRE'
      WHERE CodCia       = P_CodCia
        AND IdPoliza     = P_IdPoliza
        AND STSCOBERTURA = 'EMI';
     --
     UPDATE COBERT_ACT
        SET STSCOBERTURA = 'PRE'
      WHERE CodCia       = P_CodCia
        AND IdPoliza     = P_IdPoliza
        AND STSCOBERTURA = 'EMI';
     --
     UPDATE ASISTENCIAS_DETALLE_POLIZA
        SET STSASISTENCIA = 'PREEMI'
      WHERE CodCia        = P_CodCia
        AND CodEmpresa    = P_CodEmpresa
        AND IdPoliza      = P_IdPoliza
        AND STSASISTENCIA = 'EMITID';
     --
     UPDATE BENEFICIARIO
        SET ESTADO = 'PREEMI'
      WHERE IdPoliza = P_IdPoliza
        AND ESTADO   = 'EMITID';
     --
     UPDATE COBERTURA_ASEG
        SET STSCOBERTURA = 'PRE'
      WHERE CodCia       = P_CodCia
        AND IdPoliza     = P_IdPoliza
        AND STSCOBERTURA = 'EMI';
     --
     UPDATE COBERT_ACT_ASEG
        SET STSCOBERTURA = 'PRE'
      WHERE CodCia       = P_CodCia
        AND IdPoliza     = P_IdPoliza
        AND STSCOBERTURA = 'EMI';
     --
     UPDATE ASEGURADO_CERTIFICADO
        SET ESTADO = 'PRE'
      WHERE CodCia   = P_CodCia
        AND IdPoliza = P_IdPoliza
        AND ESTADO   = 'EMI';
     --
     UPDATE ASISTENCIAS_ASEGURADO
        SET STSASISTENCIA = 'PREEMI'
      WHERE CodCia     = P_CodCia
        AND CodEmpresa = P_CodEmpresa
        AND IdPoliza   = P_IdPoliza
        AND STSASISTENCIA = 'EMITID';
     --
     UPDATE CLAUSULAS_POLIZA
        SET ESTADO = 'PREEMI'
      WHERE CodCia   = P_CodCia
        AND IdPoliza = P_IdPoliza
        AND ESTADO   = 'EMITID';
     --
     UPDATE FACTURAS
        SET STSFACT            = 'PRE',
       INDFACTELECTRONICA = 'N'   -- CANCELA FACTURACION ELECTRONICA
      WHERE CodCia   = P_CodCia
        AND IdPoliza = P_IdPoliza
        AND STSFACT  = 'EMI';
     --
     UPDATE COMPROBANTES_CONTABLES
        SET StsComprob = 'PRE'     -- CANCELA CONTABILIDAD
      WHERE NUMTRANSACCION = P_IDTRANSACCION
        AND TIPOCOMPROB = '100'
        AND StsComprob  = 'CUA';
     --
     UPDATE DETALLE_POLIZA
        SET STSDETALLE = 'PRE'
      WHERE IdPoliza   = P_IdPoliza
        AND STSDETALLE = 'EMI';
     --
     UPDATE POLIZAS
        SET STSPOLIZA = 'PRE'
      WHERE IdPoliza  = P_IdPoliza
        AND STSPOLIZA = 'EMI';
     --
     INSERT INTO PREEMISION
      (ID_CodCia,      ID_POLIZA,
       FE_INIVIG,      FE_FINVIG,
       FE_EMISION,     USUARIO_EMI,
       FE_INIVIG_PRE,  FE_FINVIG_PRE,
       FE_PREEMISION,  USUARIO_PRE)
     VALUES
      (P_CodCia,         P_IdPoliza,
       W_FE_INIVIG,      W_FE_FINVIG,
       SYSDATE,          USER,
       '',  '',
       '',  ''
      );
     --
   --
   END PRE_EMITE_POLIZA;
   --
   --
   --
   PROCEDURE LIBERA_PRE_EMITE(P_CodCia NUMBER, P_CodEmpresa NUMBER, P_IdPoliza NUMBER, P_Fecha_Pago DATE) IS
   --
   Wd_FecIniVig_Pol    POLIZAS.FECINIVIG%TYPE;
   Wd_FecFinVig_Pol    POLIZAS.FECFINVIG%TYPE;
   Wn_IdTransaccion    TRANSACCION.IDTRANSACCION%TYPE;
   WC_CodPlanPago      POLIZAS.CodPlanPago%TYPE;
   WN_NUMPAGOS         NUMBER;
   WC_FRECPAGOS        NUMBER;
   WD_FECINIVIG_REC    POLIZAS.FECINIVIG%TYPE;
   WD_FECFINVIG_REC    POLIZAS.FECFINVIG%TYPE;
   --
   WN_MESES_VIGENCIA   NUMBER(6) := 0;

   nDiasVigencia        NUMBER;

   --
   CURSOR RECIBOS IS
   SELECT F.IDFACTURA, F.IDENDOSO, F.NUMCUOTA
     FROM FACTURAS F
    WHERE F.IdPoliza = P_IdPoliza
    ORDER BY F.IDFACTURA
   ;
   --
   BEGIN
      BEGIN
       SELECT MONTHS_BETWEEN(FECFINVIG,FECINIVIG),  CodPlanPago
         INTO WN_MESES_VIGENCIA,                    WC_CodPlanPago
        /* SELECT FecFinVig - FecIniVig, CodPlanPago
      INTO nDiasVigencia, WC_CodPlanPago*/
      FROM POLIZAS P
          WHERE IdPoliza = P_IdPoliza;
      EXCEPTION
       WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR (-20100,'No Existe POLIZA '||P_IdPoliza);
      END;
     --
     Wd_FecIniVig_Pol := P_Fecha_Pago;
     Wd_FecFinVig_Pol := ADD_MONTHS(P_Fecha_Pago,WN_MESES_VIGENCIA);
    -- Wd_FecFinVig_Pol := P_Fecha_Pago + nDiasVigencia;
     --
     BEGIN
       SELECT NUMPAGOS,     FRECPAGOS
         INTO WN_NUMPAGOS,  WC_FRECPAGOS
         FROM PLAN_DE_PAGOS
        WHERE CodCia      = P_CodCia
          AND CodEmpresa  = P_CodEmpresa
          AND CodPlanPago = WC_CodPlanPago;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR (-20100,'No Existe Plan de Pagos '||WC_CodPlanPago);
     END;
     --
     UPDATE COBERTURAS
        SET STSCOBERTURA = 'EMI'
      WHERE CodCia       = P_CodCia
        AND IdPoliza     = P_IdPoliza
        AND STSCOBERTURA = 'PRE';
     --
     UPDATE COBERT_ACT
        SET STSCOBERTURA = 'EMI'
      WHERE CodCia       = P_CodCia
        AND IdPoliza     = P_IdPoliza
        AND STSCOBERTURA = 'PRE';
     --
     UPDATE ASISTENCIAS_DETALLE_POLIZA
        SET STSASISTENCIA = 'EMITID',
       FECSTS        = Wd_FecIniVig_Pol
      WHERE CodCia        = P_CodCia
        AND CodEmpresa    = P_CodEmpresa
        AND IdPoliza      = P_IdPoliza
        AND STSASISTENCIA= 'PREEMI';
     --
     UPDATE BENEFICIARIO
        SET ESTADO    = 'EMITID',
       FECESTADO = Wd_FecIniVig_Pol,
       FECALTA   = Wd_FecIniVig_Pol
      WHERE IdPoliza = P_IdPoliza
        AND ESTADO   = 'PREEMI';
     --
     UPDATE COBERTURA_ASEG
        SET STSCOBERTURA = 'EMI'
      WHERE CodCia       = P_CodCia
        AND IdPoliza     = P_IdPoliza
        AND STSCOBERTURA = 'PRE';
     --
     UPDATE COBERT_ACT_ASEG
        SET STSCOBERTURA = 'EMI'
      WHERE CodCia       = P_CodCia
        AND IdPoliza     = P_IdPoliza
        AND STSCOBERTURA = 'PRE';
     --
     UPDATE ASEGURADO_CERTIFICADO
        SET ESTADO = 'EMI'
      WHERE CodCia   = P_CodCia
        AND IdPoliza = P_IdPoliza
        AND ESTADO   = 'PRE';
     --
     UPDATE ASISTENCIAS_ASEGURADO
        SET STSASISTENCIA = 'EMITID',
       FECSTS        = Wd_FecIniVig_Pol
      WHERE CodCia        = P_CodCia
        AND CodEmpresa    = P_CodEmpresa
        AND IdPoliza      = P_IdPoliza
        AND STSASISTENCIA = 'PREEMI';
     --
     UPDATE CLAUSULAS_POLIZA
        SET ESTADO          = 'EMITID',
       INICIO_VIGENCIA = Wd_FecIniVig_Pol,
       FIN_VIGENCIA    = Wd_FecFinVig_Pol
      WHERE CodCia   = P_CodCia
        AND IdPoliza = P_IdPoliza
        AND ESTADO   = 'PREEMI';
     --
     -- LIBERA FACTURACION ELECTRONICA
     --
     FOR R IN RECIBOS LOOP
         --
        IF WN_NUMPAGOS > 1 THEN  --SI ES DIFEENTE A ANUAL
       IF R.NUMCUOTA = 1 THEN
          IF WC_FRECPAGOS NOT IN (15,7) THEN
             WD_FECINIVIG_REC := Wd_FecIniVig_Pol;
          ELSE
             WD_FECINIVIG_REC := Wd_FecIniVig_Pol + WC_FRECPAGOS;
          END IF;
       ELSE
          IF WC_FRECPAGOS NOT IN (15,7) THEN
             WD_FECINIVIG_REC := ADD_MONTHS(WD_FECINIVIG_REC,WC_FRECPAGOS);
          ELSE
             WD_FECINIVIG_REC := WD_FECINIVIG_REC + WC_FRECPAGOS;
          END IF;

       END IF;
       --
       WD_FECFINVIG_REC := OC_FACTURAS.VIGENCIA_FINAL(P_CodCia,          P_CodEmpresa, P_IdPoliza,
                        R.IDFACTURA,       R.IDENDOSO,   WD_FECINIVIG_REC,
                        Wd_FecFinVig_Pol,  R.NUMCUOTA,   WC_CodPlanPago);
       --
         ELSE  -- SI ES ANUAL
       WD_FECINIVIG_REC := Wd_FecIniVig_Pol;
       WD_FECFINVIG_REC := ADD_MONTHS(Wd_FecIniVig_Pol,12);
         END IF;
         --
         UPDATE FACTURAS
       SET STSFACT            = 'EMI',
           INDFACTELECTRONICA = 'S',
           FECVENC            = WD_FECINIVIG_REC,
           FECSTS             = WD_FECINIVIG_REC,
           FECCONTABILIZADA   = WD_FECINIVIG_REC,
           FECFINVIG          = WD_FECFINVIG_REC
          WHERE CodCia    = P_CodCia
       AND IdPoliza  = P_IdPoliza
       AND IDFACTURA = R.IDFACTURA
       AND STSFACT   = 'PRE';
     END LOOP;
     --
     --
     --
     BEGIN
       SELECT DISTINCT(IDTRANSACCION)
         INTO Wn_IdTransaccion
         FROM FACTURAS
        WHERE CodCia   = P_CodCia
          AND IdPoliza = P_IdPoliza;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
       Wn_IdTransaccion := 0;
       WHEN TOO_MANY_ROWS THEN
       Wn_IdTransaccion := 0;
       WHEN OTHERS THEN
       Wn_IdTransaccion := 0;
     END;
     --
     -- LIBERA CONTABILIDAD  VERIFICAR LA OPERATIVA CORRECTA CON PAGO
     --
     UPDATE TRANSACCION
        SET FECHATRANSACCION = Wd_FecIniVig_Pol
      WHERE IDTRANSACCION = Wn_IdTransaccion;
     --
     UPDATE COMPROBANTES_CONTABLES
        SET StsComprob = 'CUA',
       FECCOMPROB  = Wd_FecIniVig_Pol,
       FECSTS      = Wd_FecIniVig_Pol
      WHERE NUMTRANSACCION = Wn_IdTransaccion
        AND StsComprob    = 'PRE';
     --
     UPDATE DETALLE_POLIZA
        SET STSDETALLE = 'EMI',
       FECINIVIG  = Wd_FecIniVig_Pol,
       FECFINVIG  = Wd_FecFinVig_Pol
      WHERE IdPoliza   = P_IdPoliza
        AND STSDETALLE = 'PRE';
     --
     UPDATE POLIZAS
        SET STSPOLIZA     = 'EMI',
       FECINIVIG     = Wd_FecIniVig_Pol,
       FECFINVIG     = Wd_FecFinVig_Pol,
       FECSOLICITUD  = Wd_FecIniVig_Pol,
       FECEMISION    = Wd_FecIniVig_Pol,
       FECRENOVACION = ADD_MONTHS(Wd_FecIniVig_Pol,12),
       FECSTS        = Wd_FecIniVig_Pol
      WHERE IdPoliza  = P_IdPoliza
        AND STSPOLIZA = 'PRE';
    --
    UPDATE PREEMISION
       SET FE_INIVIG_PRE = Wd_FecIniVig_Pol,
      FE_FINVIG_PRE = Wd_FecFinVig_Pol,
      FE_PREEMISION = SYSDATE,
      USUARIO_PRE   = USER
     WHERE ID_POLIZA = P_IdPoliza;
     --
   END LIBERA_PRE_EMITE;     -- PREEMI  FIN

   FUNCTION DIA_COBRO (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN NUMBER IS
   nDiaCobroAutomatico POLIZAS.DiaCobroAutomatico%TYPE;
   BEGIN
      BEGIN
         SELECT NVL(DiaCobroAutomatico,0)
      INTO nDiaCobroAutomatico
      FROM POLIZAS
          WHERE CodCia     = nCodCia
       AND CodEmpresa = nCodEmpresa
       AND IdPoliza   = nIdPoliza;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
       nDiaCobroAutomatico := 0;
         WHEN TOO_MANY_ROWS THEN
       RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros de la Póliza: '||TRIM(TO_CHAR(nIdPoliza))||
                ' en la Compañía '||TO_CHAR(nCodCia));
      END;
      RETURN nDiaCobroAutomatico;
   END;

   FUNCTION BLOQUEADA_PLD(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2 IS
   cExiste VARCHAR2(1);
   BEGIN
      BEGIN
         SELECT 'S'
      INTO cExiste
      FROM POLIZAS
          WHERE CodCia                    = nCodCia
       AND CodEmpresa                = nCodEmpresa
       AND IdPoliza                  = nIdPoliza
       AND NVL(PldStBloqueada,'N')   = 'S'
       AND NVL(PldStAprobada,'N')    = 'N'
       AND StsPoliza                 = 'PLD';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
       cExiste := 'N';
      END;
      RETURN cExiste;
   END BLOQUEADA_PLD;

   FUNCTION LIBERADA_PLD(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2 IS
   cExiste VARCHAR2(1);
   BEGIN
      BEGIN
         SELECT 'S'
      INTO cExiste
      FROM POLIZAS
          WHERE CodCia                    = nCodCia
       AND CodEmpresa                = nCodEmpresa
       AND IdPoliza                  = nIdPoliza
       AND NVL(PldStBloqueada,'N')   = 'S'
       AND NVL(PldStAprobada,'N')    = 'S'
       AND StsPoliza                != 'PLD';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
       cExiste := 'N';
      END;
      RETURN cExiste;
   END LIBERADA_PLD;

   PROCEDURE LIBERA_PRE_EMITE_PLATAFORMA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, dFechaPago DATE) IS
   --
   dFecIniVigPol     POLIZAS.FecIniVig%TYPE;
   dFecFinVigPol     POLIZAS.FecFinVig%TYPE;
   dFecIniVig        POLIZAS.FecIniVig%TYPE;
   dFecFinVig        POLIZAS.FecFinVig%TYPE;
   nIdTransaccion    TRANSACCION.IdTransaccion%TYPE;
   cCodPlanPago      POLIZAS.CodPlanPago%TYPE;
   nNumPagos         NUMBER;
   nFrecPagos        NUMBER;
   dFecIniVigRec     POLIZAS.FecIniVig%TYPE;
   dFecFinVigRec     POLIZAS.FecFinVig%TYPE;
   --
   nMesesVigencia   NUMBER(6) := 0;

   nDiasVigencia        NUMBER;

   --
   CURSOR RECIBOS IS
      SELECT F.IdFactura, F.IdEndoso, F.NumCuota
        FROM FACTURAS F
       WHERE F.CodCia   = nCodCia
         AND F.IdPoliza = nIdPoliza
       ORDER BY F.IdFactura;
   --
   BEGIN
      BEGIN
         SELECT P.FecFinVig - P.FecIniVig, P.CodPlanPago, P.FecFinVig, P.FecIniVig
      INTO nDiasVigencia, cCodPlanPago, dFecFinVig, dFecIniVig
      FROM POLIZAS P
          WHERE IdPoliza = nIdPoliza;
      EXCEPTION
       WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR (-20100,'No Existe POLIZA '||nIdPoliza);
      END;
     --
      dFecIniVigPol := dFechaPago;
     --
      BEGIN
         SELECT NumPagos, FrecPagos
      INTO nNumPagos, nFrecPagos
      FROM PLAN_DE_PAGOS
          WHERE CodCia      = nCodCia
       AND CodEmpresa  = nCodEmpresa
       AND CodPlanPago = cCodPlanPago;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR (-20100,'No Existe Plan de Pagos '||cCodPlanPago);
      END;
     --
      UPDATE Coberturas
         SET StsCobertura = 'EMI'
       WHERE CodCia       = nCodCia
         AND IdPoliza     = nIdPoliza
         AND StsCobertura = 'PRE';
     --
      UPDATE COBERT_ACT
         SET StsCobertura = 'EMI'
       WHERE CodCia       = nCodCia
         AND IdPoliza     = nIdPoliza
         AND StsCobertura = 'PRE';
     --
     UPDATE ASISTENCIAS_DETALLE_POLIZA
        SET StsAsistencia  = 'EMITID',
       FecSts         = dFecIniVigPol
      WHERE CodCia         = nCodCia
        AND CodEmpresa     = nCodEmpresa
        AND IdPoliza       = nIdPoliza
        AND StsAsistencia  = 'PREEMI';
     --
     UPDATE BENEFICIARIO
        SET Estado    = 'EMITID',
       FecEstado = dFecIniVigPol,
       FecAlta   = dFecIniVigPol
      WHERE IdPoliza = nIdPoliza
        AND Estado   = 'PREEMI';
     --
     UPDATE COBERTURA_ASEG
        SET StsCobertura = 'EMI'
      WHERE CodCia       = nCodCia
        AND IdPoliza     = nIdPoliza
        AND StsCobertura = 'PRE';
     --
     UPDATE COBERT_ACT_ASEG
        SET StsCobertura = 'EMI'
      WHERE CodCia       = nCodCia
        AND IdPoliza     = nIdPoliza
        AND StsCobertura = 'PRE';
     --
     UPDATE ASEGURADO_CERTIFICADO
        SET Estado = 'EMI'
      WHERE CodCia   = nCodCia
        AND IdPoliza = nIdPoliza
        AND Estado   = 'PRE';
     --
     UPDATE ASISTENCIAS_ASEGURADO
        SET StsAsistencia = 'EMITID',
       FecSts        = dFecIniVigPol
      WHERE CodCia        = nCodCia
        AND CodEmpresa    = nCodEmpresa
        AND IdPoliza      = nIdPoliza
        AND StsAsistencia = 'PREEMI';
     --
     UPDATE CLAUSULAS_POLIZA
        SET Estado          = 'EMITID'
      WHERE CodCia   = nCodCia
        AND IdPoliza = nIdPoliza
        AND Estado   = 'PREEMI';
     --
     -- LIBERA FACTURACION ELECTRONICA
     --
      FOR R IN RECIBOS LOOP
         --
         UPDATE FACTURAS
       SET StsFact            = 'EMI',
           IndFactElectronica = 'S',
           FecSts             = dFecIniVigPol,
           FecContabilizada   = dFecIniVigPol
          WHERE CodCia    = nCodCia
       AND IdPoliza  = nIdPoliza
       AND IdFactura = R.IdFactura
       AND StsFact   = 'PRE';
      END LOOP;
     --
     --
     --
      BEGIN
         SELECT DISTINCT(IdTransaccion)
      INTO nIdTransaccion
      FROM FACTURAS
          WHERE CodCia   = nCodCia
       AND IdPoliza = nIdPoliza;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
       nIdTransaccion := 0;
         WHEN TOO_MANY_ROWS THEN
       nIdTransaccion := 0;
         WHEN OTHERS THEN
       nIdTransaccion := 0;
      END;
     --
     -- LIBERA CONTABILIDAD  VERIFICAR LA OPERATIVA CORRECTA CON PAGO
     --
      UPDATE TRANSACCION
        SET FechaTransaccion = dFecIniVigPol
      WHERE IdTransaccion = nIdTransaccion;
      --
      UPDATE COMPROBANTES_CONTABLES
        SET StsComprob = 'CUA',
       FecComprob  = dFecIniVigPol,
       FecSts      = dFecIniVigPol
      WHERE NumTransaccion = nIdTransaccion
        AND StsComprob    = 'PRE';
      --
      UPDATE DETALLE_POLIZA
        SET StsDetalle = 'EMI'
      WHERE IdPoliza   = nIdPoliza
        AND StsDetalle = 'PRE';
      --
      UPDATE POLIZAS
        SET StsPoliza     = 'EMI',
       FecEmision    = dFecIniVigPol,
       FecSts        = SYSDATE
      WHERE IdPoliza  = nIdPoliza
        AND StsPoliza = 'PRE';
      --
      UPDATE PREEMISION
       SET Fe_Inivig_Pre = dFecIniVig,
      Fe_Finvig_Pre = dFecFinVig,
      Fe_PreEmision = SYSDATE,
      Usuario_Pre   = USER
      WHERE Id_Poliza = nIdPoliza;
     --
   END LIBERA_PRE_EMITE_PLATAFORMA;
    --
    FUNCTION MONEDA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2 IS
        cCODMONEDA   VARCHAR2(20);
        CURSOR rMONEDA IS
            SELECT P.COD_MONEDA
              FROM POLIZAS P
            WHERE CodCia     = nCodCia
              AND CodEmpresa = nCodEmpresa
              AND IdPoliza   = nIdPoliza;

    BEGIN
        FOR ENT in rMONEDA LOOP
            cCODMONEDA := ENT.COD_MONEDA;
        END LOOP;
        RETURN cCODMONEDA;
    EXCEPTION WHEN OTHERS THEN
        RETURN NULL;
    END MONEDA;
    --
fUNCTION ALTURA_CERO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2 IS
cAlturaCero             VARCHAR2(1);
nMontoPrimaCompMoneda   DETALLE_POLIZA.MontoPrimaCompMoneda%TYPE;
BEGIN
   SELECT NVL(SUM(MontoPrimaCompMoneda),0)
     INTO nMontoPrimaCompMoneda
     FROM DETALLE_POLIZA
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND IdPoliza   = nIdPoliza;

   IF NVL(nMontoPrimaCompMoneda,0) < 0 THEN 
      cAlturaCero := 'S';
   ELSE
      cAlturaCero := 'N';
   END IF;
   RETURN cAlturaCero;
END ALTURA_CERO;  

-- PROCESOS GENERADOS PARA LA RENOVACION ESPECIAL MLJS CAGR ---
--17/05/2024
--07/08/2024 SE MODIFICA LA RENOVACION
FUNCTION F_OBT_NUMPOLUNICO_REN (CNUMPOLUNICOORIG IN VARCHAR2) RETURN VARCHAR2 IS
  cCadena    POLIZAS.NUMPOLUNICO%TYPE;
  nNumrenov  POLIZAS.NUMRENOV%TYPE;
BEGIN
    nNumrenov := TO_NUMBER(SUBSTR(CNUMPOLUNICOORIG,-2)) + 1;
    --cCadena   := SUBSTR(CNUMPOLUNICOORIG,1,INSTR(CNUMPOLUNICOORIG,'-'))||LPAD(TO_NUMBER(SUBSTR(CNUMPOLUNICOORIG,-2)) + 1,2,0);
    cCadena   := SUBSTR(CNUMPOLUNICOORIG,1,LENGTH(CNUMPOLUNICOORIG)-LENGTH(SUBSTR(CNUMPOLUNICOORIG,-2)))||LPAD(TO_CHAR(TO_NUMBER(SUBSTR(CNUMPOLUNICOORIG,-2))+1),2,0);	
    RETURN (cCadena);

EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20226,'Error al Obtener el número de Póliza: '||TRIM(CNUMPOLUNICOORIG)|| ' Error raised in: '|| $$plsql_unit ||' at line ' || $$plsql_line || ' - '||sqlerrm);

END F_OBT_NUMPOLUNICO_REN;

--17/05/2024
FUNCTION F_OBT_NUMRENOV_REN (CNUMPOLUNICOORIG IN VARCHAR2) RETURN NUMBER IS
  nNumrenov  POLIZAS.NUMRENOV%TYPE;

BEGIN
  nNumrenov := TO_NUMBER(SUBSTR(CNUMPOLUNICOORIG,-2)) + 1;
  RETURN (nNumrenov);
END F_OBT_NUMRENOV_REN;

-- 08/05/2024
FUNCTION COPIAR_REN(nCodCia NUMBER, nIdPolizaOrig NUMBER, cUsuario VARCHAR2) RETURN NUMBER IS
   v_archivo_r       UTL_FILE.FILE_TYPE;
   v_archivo_w       UTL_FILE.FILE_TYPE;
   v_log             VARCHAR2(32767);
   dFecHoy           DATE;
   dFecha            DATE;
   dFecFin           DATE;
   nIdPoliza         POLIZAS.IdPoliza%TYPE;
   nIDetPol          DETALLE_POLIZA.IDetPol%TYPE;
   cTipoSeg          TIPOS_DE_SEGUROS.TipoSeg%TYPE;
   cNumPolUnico      POLIZAS.NumPolUnico%TYPE;
   p_msg_regreso     varchar2(50);----var XDS
   cINDRAMOREAL      VARCHAR2(100);
   cESRamoReal       VARCHAR2(1);
   nCodEmpresa       NUMBER(1);
   nIdPolizaEnd		   NUMBER;
   dFecIniVigEnd		 DATE;
   nIDetPolEnd		   NUMBER;
   dFecIniVigPol	   DATE;
   nLinea            NUMBER := 1;
   nNumRenov         POLIZAS.NUMRENOV%TYPE;
   cTIENEASEGS       VARCHAR2(1);
   NHAYCERTS         NUMBER;
   NCERTPOSFINI      NUMBER;
   bContinua         BOOLEAN;     
   DFECINIVIGP       POLIZAS.FECINIVIG%TYPE;
   DFECINIVIGDP      DETALLE_POLIZA.FECINIVIG%TYPE;
   NUMASEGS          NUMBER;
   nValida           NUMBER;
   
   RERROR            EXCEPTION;

   CURSOR POL_Q IS
      SELECT CodEmpresa, TipoPol, NumPolRef, SumaAseg_Local, SumaAseg_Moneda,
        PrimaNeta_Local, PrimaNeta_Moneda, DescPoliza, PorcComis, IndExaInsp,
        Cod_Moneda, Num_Cotizacion, CodCliente, Cod_Agente, CodPlanPago,
        Medio_Pago, NumPolUnico, IndPolCol, IndProcFact, Caracteristica,
        IndFactPeriodo, FormaVenta, TipoRiesgo, IndConcentrada, TipoDividendo,
        CodGrupoEc, IndAplicoSami, SamiPoliza, TipoAdministracion, NumRenov,
        HoraVigIni, HoraVigFin, CodAgrupador, IndFacturaPol,
        IndFactElectronica, IndCalcDerechoEmis, CodDirecRegional, PorcDescuento,
        PorcGtoAdmin, PorcGtoAdqui, PorcUtilidad, FactorAjuste, MontoDeducible,
        FactFormulaDeduc, CodRiesgoRea, CodTipoBono, HorasVig, DiasVig,
        IndExtraPrima, AsegAdheridosPor, PorcenContributorio,
        FuenteRecursosPrima, IdFormaCobro, DiaCobroAutomatico, IndManejaFondos,
        TipoProrrata, IndConvenciones, CodTipoNegocio, CodPaqComercial,
        CodOficina,CodCatego, Coaseguro, deducible, codobjetoimp, codusocfdi
        FROM POLIZAS
       WHERE IdPoliza = nIdPolizaOrig
         AND CodCia   = nCodCia;

   CURSOR DET_Q IS
      SELECT IDetPol, Cod_Asegurado, CodEmpresa, CodPlanPago, Suma_Aseg_Local,
        Suma_Aseg_Moneda, Prima_Local, Prima_Moneda, IdTipoSeg, Tasa_Cambio,
        PorcComis,  NULL CodContrato, NULL CodProyecto, NULL Cod_Moneda,
        PlanCob, MontoComis, NumDetRef, FecAnul, Motivanul, CodPromotor,
        IndDeclara, IndSinAseg, CodFilial, CodCategoria, IndFactElectronica,
        IndAsegModelo, CantAsegModelo, MontoComisH, PorcComisH, IdDirecAviCob,
        IdFormaCobro, MontoAporteFondo
        FROM DETALLE_POLIZA
       WHERE IdPoliza = nIdPolizaOrig
         AND CodCia   = nCodCia
       UNION
      SELECT Correlativo IDetPol, 0 Cod_Asegurado, CodEmpresa, CodPlanPago,
        MontoLocal Suma_Aseg_Local, MontoMoneda Suma_Aseg_Moneda, PrimaLocal Prima_Local,
        PrimaMoneda Prima_Moneda, IdTipoSeg,0 Tasa_Cambio, PorcComis, CodContrato,
        CodProyecto, Cod_Moneda, NULL PlanCob, 0 MontoComis, NULL NumDetRef, NULL FecAnul,
        NULL Motivanul, NULL CodPromotor, NULL IndDeclara, NULL IndSinAseg,
        NULL CodFilial, NULL CodCategoria, NULL IndFactElectronica,
        'N' IndAsegModelo, 0 CantAsegModelo, 0 MontoComisH, 0 PorcComisH, NULL IdDirecAviCob,
        NULL IdFormaCobro, 0 MontoAporteFondo
        FROM FZ_DETALLE_FIANZAS
       WHERE IdPoliza = nIdPolizaOrig
         AND CodCia   = nCodCia;

   CURSOR COB_Q IS
     SELECT CA.IDetPol, CA.CodEmpresa, CA.CodCia, DP.IdTipoSeg, CA.CodCobert,
       CA.SumaAseg_Moneda, CA.Prima_Moneda, TipoRef, CA.NumRef, CA.IdEndoso,
       CA.PlanCob, CA.Cod_Moneda, CA.Deducible_Local, CA.Deducible_Moneda,
       CA.Cod_Asegurado, CA.IDRAMOREAL
       FROM COBERT_ACT CA, DETALLE_POLIZA DP
      WHERE DP.IDetPol  = CA.IDetPol
        AND DP.IdPoliza = CA.IdPoliza
        AND CA.IdPoliza = nIdPolizaOrig
        AND CA.CodCia   = nCodCia;

   CURSOR PER_Q IS
      SELECT IDetPol, Estatura, Peso, Cavidad_Toraxica_Min, Cavidad_Toraxica_Max,
        Capacidad_Abdominal, Presion_Arterial_Min, Presion_Arterial_Max,
        Pulso, Mortalidad, Suma_Aseg_Moneda, Suma_Aseg_Local,
        Extra_Prima_Moneda, Extra_Prima_Local, Id_Fumador,
        Observaciones, Porc_SubNormal, Prima_Local, Prima_Moneda
        FROM DATOS_PARTICULARES_PERSONAS
       WHERE IdPoliza = nIdPolizaOrig
         AND CodCia   = nCodCia;

   CURSOR BIEN_Q IS
      SELECT Num_Bien, IDetPol, CodPais, CodEstado, CodCiudad, CodMunicipio,
        Ubicacion_Bien, Tipo_Bien, Suma_Aseg_Local_Bien, Suma_Aseg_Moneda_Bien,
        Prima_Neta_Local_Bien, Prima_Neta_Moneda_Bien
        FROM DATOS_PARTICULARES_BIENES
       WHERE IdPoliza = nIdPolizaOrig
         AND CodCia   = nCodCia;

   CURSOR AUTO_Q IS
      SELECT IDetPol, Num_Vehi, Cod_Marca, Cod_Version, Cod_Modelo, Anio_Vehiculo,
        Placa, Cantidad_Pasajeros, Tarjeta_Circulacion, Color, Numero_Chasis,
        Numero_Motor, SumaAseg_Local, SumaAseg_Moneda, PrimaNeta_Local,
        PrimaNeta_Moneda
        FROM DATOS_PARTICULARES_VEHICULO
       WHERE IdPoliza = nIdPolizaOrig
         AND CodCia   = nCodCia;

   CURSOR AGTE_POL_Q IS
      SELECT Cod_Agente, Porc_Comision, Ind_Principal, Origen
        FROM AGENTE_POLIZA
       WHERE CodCia   = nCodCia
         AND IdPoliza = nIdPolizaOrig;

   CURSOR AGTE_DIST_POL_Q IS
      SELECT Cod_Agente, CodNivel, Cod_Agente_Distr, Porc_Comision_Agente,
        Porc_Com_Distribuida, Porc_Comision_Plan, Porc_Com_Proporcional,
        Cod_Agente_Jefe, Porc_Com_Poliza, Origen
        FROM AGENTES_DISTRIBUCION_POLIZA
       WHERE CodCia   = nCodCia
         AND IdPoliza = nIdPolizaOrig;

   CURSOR AGENTES_Q IS
      SELECT A.Cod_Agente, A.Ind_Principal, A.Porc_Comision, A.Origen
        FROM AGENTES_DETALLES_POLIZAS A
       WHERE IDetPol  = nIDetPol
         AND CodCia   = nCodCia
         AND IdPoliza = nIdPolizaOrig;

   CURSOR AGTE_DIST_DET_Q IS
      SELECT CodNivel, Cod_Agente, Cod_Agente_Distr, Porc_Comision_Plan,
        Porc_Comision_Agente, Porc_Com_Distribuida, Porc_Com_Proporcional,
        Cod_Agente_Jefe, Origen
        FROM AGENTES_DISTRIBUCION_COMISION
       WHERE IDetPol  = nIDetPol
         AND CodCia   = nCodCia
         AND IdPoliza = nIdPolizaOrig;

   CURSOR ASEG_CERT_Q IS
      SELECT CodCia, IdPoliza, Cod_Asegurado, FechaAlta, FechaBaja, CodEmpresa,
        SumaAseg, Primaneta
        FROM ASEGURADO_CERT
       WHERE IDetPol  = nIDetPol
         AND IdPoliza = nIdPolizaOrig
         AND CodCia   = nCodCia;
         
   CURSOR DETPOL_Q IS
   SELECT DISTINCT CodCia, IdPoliza, IDetPol
     FROM ASEGURADO_CERTIFICADO
    WHERE CODCIA    = nCodCia
      AND IdPoliza  = nIdPolizaOrig;
      
   CURSOR ASEGSEND IS
     SELECT IDPOLIZA,IDETPOL, IDENDOSO, COUNT(*) TOTASEGS
     FROM   ASEGURADO_CERTIFICADO 
     WHERE  CODCIA   = nCodCia
     AND    IDPOLIZA = nIdPolizaOrig
     AND    IDENDOSO > 0
     GROUP BY IDPOLIZA, IDETPOL, IDENDOSO
     ORDER BY IDPOLIZA DESC;
     
   CURSOR VALENDOS IS
     SELECT IDETPOL, COUNT(*)
     FROM   POLIZAS P,
            ENDOSOS E
     WHERE  E.CODCIA     = nCodCia
     AND    E.IDPOLIZA   = P.IDPOLIZA
     AND    E.TIPOENDOSO IN ('INA','IND')
     AND    E.STSENDOSO  = 'EMI'
     AND    P.IDPOLIZA   = nIdPolizaOrig
     AND    TRUNC(P.FECEMISION)  != TRUNC(E.FECEMISION)
     AND    E.FECINIVIG > P.FECINIVIG
     GROUP BY IDETPOL;
      
   BEGIN
   
    DBMS_OUTPUT.PUT_LINE('ENTRÉ');
      --OC_ARCHIVO.ESCRIBIR_LINEA(SQLERRM,USER,nLinea);
      nValida:= 0;
      SELECT TRUNC(SYSDATE)
        INTO dFecHoy
        FROM DUAL;
      FOR X IN POL_Q LOOP
         DBMS_OUTPUT.PUT_LINE('ENTRA FOR '||nIdPolizaOrig);
        -- SE AGREGAN FECHA DE VIGENCIA CORRECTAS Y NUMPOUNICO 
         SELECT SYSDATE, CodEmpresa, FecRenovacion, ADD_MONTHS(FecRenovacion,12)--, IndPolCol --FecFinVig + (FecFinVig - FecIniVig)
          INTO dFecha, nCodEmpresa, dFecHoy, dFecFin --, cIndPolCol
          FROM POLIZAS
          WHERE IdPoliza = nIdPolizaOrig
          AND CodCia     = nCodCia;

          -- MLJS 17/05/2024
          cNumPolUnico := F_OBT_NUMPOLUNICO_REN (X.NumPolUnico);
          nNumRenov    := F_OBT_NUMRENOV_REN (X.NumPolUnico);
          
          --DBMS_OUTPUT.PUT_LINE('cNumPolUnico '||cNumPolUnico);
          --DBMS_OUTPUT.PUT_LINE('nNumRenov '||nNumRenov);
          -- MLJS 23/05/2024 ANTES QUE SE GENERE EL NUMERO DE POLIZA SE VALIDA SI LA PÓLIZA A RENOVAR TIENE CERTIFICADOS
          -- CREADOS POSTERIORES A LA EMISION DE LA POLIZA
          bContinua := TRUE;
          FOR I IN VALENDOS LOOP
            BEGIN
              SELECT COUNT(*) 
              INTO   NUMASEGS
              FROM   ASEGURADO_CERTIFICADO
              WHERE  IDPOLIZA = nIdPolizaOrig
              AND    IDETPOL  = I.IDETPOL
              AND    IDENDOSO = 0;
            EXCEPTION
              WHEN OTHERS THEN
                 NUMASEGS := 0; 
            END;     
               
             IF NUMASEGS > 0 THEN
               bContinua := TRUE;
             ELSE
               bContinua := FALSE; 
               return 1;
               EXIT;
             END IF;
           END LOOP;    
            -- DBMS_OUTPUT.PUT_LINE('bContinua '||bContinua);   
            /* IF NCERTPOSFINI > 0 THEN    
                FOR T IN DETPOL_Q LOOP  
                  SELECT P.FECEMISION, E.FECEMISION
                  INTO   DFECINIVIGP, DFECINIVIGDP
                  FROM   POLIZAS P, ENDOSOS E
                  WHERE  P.CODCIA     = E.CODCIA
                  AND    P.IDPOLIZA   = E.IDPOLIZA
                  AND    P.FECEMISION != E.FECEMISION
                  AND    P.IDPOLIZA   = nIdPolizaOrig
                  AND    E.IDETPOL   = T.IDETPOL
                  ORDER BY P.IDPOLIZA DESC;	
                    
                  IF DFECINIVIGDP > DFECINIVIGP THEN
                    nLinea := nLinea + 1;
                    OC_ARCHIVO.ESCRIBIR_LINEA('Certificado '||T.IDETPOL||' dado de alta posterior a emisión de Póliza '||nIdPolizaOrig ,user,nLinea);
                  END IF;
                END LOOP;
             END IF;*/
             
             --MLJS 23/05/2024 SE VALIDA SI LOS TODOS LOS ASEGURADOS EN UN DETALLE SE DIERON DE ALTA EN EL ENDOSO
             -- GENERADO POSTERIOR A LA FECHA DE INICIO DE LA PÓLIZA A RENOVAR
            /* FOR N IN ASEGSEND LOOP
                SELECT COUNT(*)
                INTO   NUMASEGS
                FROM   ASEGURADO_CERTIFICADO
                WHERE  CODCIA   = nCodCia
                AND    IDPOLIZA = nIdPolizaOrig
                AND    IDETPOL  = N.IDETPOL;
                
                IF N.TOTASEGS = NUMASEGS THEN
                  dFecIniVigPol := OC_POLIZAS.INICIO_VIGENCIA(nCodCia,nCodCia,nIdPolizaOrig);
                  
                  SELECT FECEMISION
                  INTO   dFecIniVigEnd
                  FROM   ENDOSOS
                  WHERE  IDPOLIZA = nIdPolizaOrig
                  AND    IDENDOSO = N.IDENDOSO;
                  
                  IF dFecIniVigEnd > DFECINIVIGP THEN
                    nValida := 1;
                    nLinea := nLinea + 1;
                    OC_ARCHIVO.ESCRIBIR_LINEA('Póliza no renovada. Todos los Asegurados del certificado '||N.IDETPOL||' dados de alta posterior a emisión de Póliza '||nIdPolizaOrig ,user,nLinea);
                  END IF;
                END IF;
                
                IF nValida = 1 THEN
                   bContinua := FALSE;
                 ELSE
                   bContinua := TRUE; 
                 END IF;
             END LOOP;*/
             
         -- EXCEPTION
          --   WHEN OTHERS THEN
         --      NULL;
               --RAISE_APPLICATION_ERROR(-20226,'Error al Emitir Renovación de Póliza: '||TRIM(TO_CHAR(nIdPolizaOrig))|| ' Error raised in: '|| $$plsql_unit ||' at line ' || $$plsql_line || ' - '||sqlerrm);    
          --END;
          
          IF bContinua = TRUE THEN 
           -- MLJS 17/05/2024   
            nIdPoliza :=OC_POLIZAS.F_GET_NUMPOL(p_msg_regreso);

            BEGIN
           --cNumPolUnico := TRIM(TO_CHAR(nIdPoliza)) || '-' || TRIM(TO_CHAR(X.NumRenov,'00'));
               INSERT INTO POLIZAS
                     (IdPoliza, CodEmpresa, CodCia, TipoPol, NumPolRef,
                 FecIniVig, FecFinVig, FecSolicitud, FecEmision, FecRenovacion,
                 StsPoliza, FecSts, FecAnul, MotivAnul, SumaAseg_Local, SumaAseg_Moneda,
                 PrimaNeta_Local, PrimaNeta_Moneda, DescPoliza, PorcComis, NumRenov,
                 IndExaInsp, Cod_Moneda, Num_Cotizacion, CodCliente, Cod_Agente,
                 CodPlanPago, Medio_Pago, NumPolUnico, IndPolCol, IndProcFact,
                 Caracteristica, IndFactPeriodo, FormaVenta, TipoRiesgo,
                 IndConcentrada, TipoDividendo, CodGrupoEc, IndAplicoSami,
                 SamiPoliza, TipoAdministracion, HoraVigIni, HoraVigFin, CodAgrupador,
                 IndFacturaPol, IndFactElectronica, IndCalcDerechoEmis, CodDirecRegional,
                 PorcDescuento, PorcGtoAdmin, PorcGtoAdqui, PorcUtilidad, FactorAjuste, MontoDeducible,
                 FactFormulaDeduc, CodRiesgoRea, CodTipoBono, HorasVig, DiasVig,
                 IndExtraPrima, AsegAdheridosPor, PorcenContributorio,
                 FuenteRecursosPrima, IdFormaCobro, DiaCobroAutomatico, IndManejaFondos,
                 TipoProrrata, IndConvenciones, CodTipoNegocio, CodPaqComercial,
                 CodOficina, CodCatego,Coaseguro, deducible, codobjetoimp, codusocfdi)
               VALUES(nIdPoliza, X.CodEmpresa, nCodCia, X.TipoPol, X.NumPolRef,
                 dFecHoy, ADD_MONTHS(dFecHoy,12), dFecHoy, dFecHoy, ADD_MONTHS(dFecHoy,12),
                 'SOL', dFecHoy, NULL, NULL, X.SumaAseg_Local, X.SumaAseg_Moneda,
                 X.PrimaNeta_Local, X.PrimaNeta_Moneda, X.DescPoliza, X.PorcComis, nNumRenov,
                 X.IndExaInsp, X.Cod_Moneda, X.Num_Cotizacion, X.CodCliente, X.Cod_Agente,
                 X.CodPlanPago, X.Medio_Pago, cNumPolUnico, X.IndPolCol, X.IndProcFact,
                 X.Caracteristica, X.IndFactPeriodo, X.FormaVenta, X.TipoRiesgo,
                 X.IndConcentrada, X.TipoDividendo, X.CodGrupoEc, X.IndAplicoSami,
                 X.SamiPoliza, X.TipoAdministracion, X.HoraVigIni, X.HoraVigFin, X.CodAgrupador,
                 X.IndFacturaPol, X.IndFactElectronica, X.IndCalcDerechoEmis, X.CodDirecRegional,
                 X.PorcDescuento, X.PorcGtoAdmin, X.PorcGtoAdqui, X.PorcUtilidad, X.FactorAjuste, X.MontoDeducible,
                 X.FactFormulaDeduc, X.CodRiesgoRea, X.CodTipoBono, X.HorasVig, X.DiasVig,
                 X.IndExtraPrima, X.AsegAdheridosPor, X.PorcenContributorio,
                 X.FuenteRecursosPrima, X.IdFormaCobro, X.DiaCobroAutomatico, X.IndManejaFondos,
                 X.TipoProrrata, X.IndConvenciones, X.CodTipoNegocio, X.CodPaqComercial,
                 X.CodOficina, X.CodCatego, X.Coaseguro, X.deducible, X.codobjetoimp, X.codusocfdi);
            EXCEPTION
               WHEN OTHERS THEN
                 RAISE_APPLICATION_ERROR(-20225,'Error en Copiado de Nueva Póliza ' ||SQLERRM);
            END;

            --IF  X.Num_Cotizacion > 0 THEN
              --  GT_POLIZAS_TEXTO_COTIZACION.INSERTA(nCodCia, X.CodEmpresa, X.Num_Cotizacion, nIdPoliza);
             --END IF;

             -----------------------------------------------------------------
               INSERT INTO RENOVACIONES
                  (CODCIA,          CODEMPRESA, IDPOLIZA,       /*NUMPOLUNICO,*/       NUMRENOV,
                   FECRENOVACION,      IDPOLIZAREN,  --NUMPOLUNICO_REN,   NUMRENOV_REN,
                   FECRENOVACIONREN,  TIPOMOVTO,        FECPROCESO,        USUARIOPROCESO)
                VALUES
                  (nCodCia,            1, nIdPolizaOrig,    /*CNUMPOLUNICO_ACT,*/  X.NumRenov,
                   dFecHoy,             nIdPoliza,       --cNumPolUnico,      NNUMRENOV,
                   ADD_MONTHS(dFecHoy,12),            'REN',       SYSDATE,           cUsuario);
                        
               
             ---------------------------------------------------------------
             OC_CLAUSULAS_POLIZA.COPIAR(nCodCia, nIdPolizaOrig, nIdPoliza);

             FOR G IN AGTE_POL_Q LOOP
                 INSERT INTO AGENTE_POLIZA
                   (IdPoliza, CodCia, Cod_Agente, Porc_Comision,
                    Ind_Principal, Origen)
                 VALUES (nIdPoliza, nCodCia, G.Cod_Agente, G.Porc_Comision,
                    G.Ind_Principal, G.Origen);
             END LOOP;

             FOR D IN AGTE_DIST_POL_Q LOOP
               INSERT INTO AGENTES_DISTRIBUCION_POLIZA
                 (IdPoliza, CodCia, Cod_Agente, CodNivel, Cod_Agente_Distr, Porc_Comision_Agente,
                  Porc_Com_Distribuida, Porc_Comision_Plan, Porc_Com_Proporcional,
                  Cod_Agente_Jefe, Porc_Com_Poliza, Origen)
               VALUES (nIdPoliza, nCodCia, D.Cod_Agente, D.CodNivel, D.Cod_Agente_Distr, D.Porc_Comision_Agente,
                  D.Porc_Com_Distribuida, D.Porc_Comision_Plan, D.Porc_Com_Proporcional,
                  D.Cod_Agente_Jefe, D.Porc_Com_Poliza, D.Origen);
             END LOOP;

             FOR Y IN DET_Q LOOP
               nIDetPol := Y.IDetPol;
               BEGIN
                  SELECT DISTINCT TipoSeg
                    INTO cTipoSeg
                    FROM TIPOS_DE_SEGUROS
                   WHERE IdTipoSeg  = Y.IdTipoSeg
                     AND CodCia     = nCodCia
                     AND CodEmpresa = Y.CodEmpresa;
               END;
               BEGIN
                  IF cTipoSeg != 'F' THEN
                     INSERT INTO DETALLE_POLIZA
                      (IdPoliza, IDetPol, CodCia, Cod_Asegurado, CodEmpresa, CodPlanPago,
                       Suma_Aseg_Local, Suma_Aseg_Moneda, Prima_Local, Prima_Moneda,
                       FecIniVig, FecFinVig, IdTipoSeg,  Tasa_Cambio, PorcComis, StsDetalle,
                       PlanCob, MontoComis, NumDetRef, FecAnul, Motivanul, CodPromotor,
                       IndDeclara, IndSinAseg, CodFilial, CodCategoria, IndFactElectronica,
                       IndAsegModelo, CantAsegModelo, MontoComisH, PorcComisH, IdDirecAviCob,
                       IdFormaCobro, MontoAporteFondo)
                     VALUES(nIdPoliza, Y.IDetPol, nCodCia, Y.Cod_Asegurado, Y.CodEmpresa, Y.CodPlanPago,
                       Y.Suma_Aseg_Local, Y.Suma_Aseg_Moneda, Y.Prima_Local, Y.Prima_Moneda,
                       dFecHoy, ADD_MONTHS(dFecHoy,12), Y.IdTipoSeg, Y.Tasa_Cambio, Y.PorcComis, 'SOL',
                       Y.PlanCob, Y.MontoComis, Y.NumDetRef, Y.FecAnul, Y.Motivanul, Y.CodPromotor,
                       Y.IndDeclara, Y.IndSinAseg, Y.CodFilial, Y.CodCategoria, Y.IndFactElectronica,
                       Y.IndAsegModelo, Y.CantAsegModelo, Y.MontoComisH, Y.PorcComisH, Y.IdDirecAviCob,
                       Y.IdFormaCobro, Y.MontoAporteFondo);
                  ELSE
                     INSERT INTO FZ_DETALLE_FIANZAS
                      (IdPoliza, Correlativo, CodCia,  CodEmpresa,
                       CodPlanPago, MontoLocal, MontoMoneda, PrimaLocal,
                       PrimaMoneda, Inicio_Vigencia, Fin_Vigencia, IdTipoSeg,
                       PorcComis, Estado, CodContrato, CodProyecto, Cod_Moneda)
                     VALUES(nIdPoliza, Y.IDetPol, nCodCia, Y.CodEmpresa,
                       Y.CodPlanPago, Y.Suma_Aseg_Local, Y.Suma_Aseg_Moneda, Y.Prima_Local,
                       Y.Prima_Moneda, dFecHoy, ADD_MONTHS(dFecHoy,12), Y.IdTipoSeg,
                       Y.PorcComis, 'SOL', Y.CodContrato, Y.CodProyecto, Y.Cod_Moneda);
                  END IF ;

                  --IF X.Num_Cotizacion > 0 THEN
                    -- GT_DETALLE_POLIZA_COTIZ.INSERTA(nCodCia, Y.CodEmpresa, X.Num_Cotizacion, Y.IDetPol,
                     --                                nIdPoliza, Y.IDetPol);
                 -- END IF;
               EXCEPTION
                  WHEN OTHERS THEN
                     RAISE_APPLICATION_ERROR(-20225,'Error en Copiado Insert Detalle ' ||SQLERRM);
               END;

               FOR J IN AGENTES_Q LOOP
                    INSERT INTO AGENTES_DETALLES_POLIZAS
                      (IdPoliza, IdetPol, IdTiposeg, Cod_Agente, Porc_Comision,
                       Ind_Principal, CodCia, Origen)
                    VALUES (nIdPoliza, nIDetPol, Y.IdTiposeg, J.Cod_Agente, J.Porc_Comision,
                       J.Ind_Principal, nCodCia, J.Origen);
               END LOOP;

               FOR H IN AGTE_DIST_DET_Q LOOP
                    INSERT INTO AGENTES_DISTRIBUCION_COMISION
                      (CodCia, IdPoliza, IdetPol, CodNivel, Cod_Agente, Cod_Agente_Distr,
                       Porc_Comision_Plan, Porc_Comision_Agente, Porc_Com_Distribuida,
                       Porc_Com_Proporcional, Cod_Agente_Jefe, Origen)
                    VALUES (nCodCia, nIdPoliza, nIDetPol, H.CodNivel, H.Cod_Agente, H.Cod_Agente_Distr,
                       H.Porc_Comision_Plan, H.Porc_Comision_Agente, H.Porc_Com_Distribuida,
                       H.Porc_Com_Proporcional, H.Cod_Agente_Jefe, H.Origen);
               END LOOP;

               FOR Q IN ASEG_CERT_Q LOOP
                  INSERT INTO ASEGURADO_CERT
                    (CodCia, IdPoliza, IdetPol, Cod_Asegurado, FechaAlta, FechaBaja,
                     CodEmpresa, SumaAseg, Primaneta, Estado)
                  VALUES (Q.CodCia, nIdPoliza, nIdetPol, Q.Cod_Asegurado, Q.FechaAlta, Q.FechaBaja,
                     Q.CodEmpresa, Q.SumaAseg, Q.Primaneta, 'SOL');
               END LOOP;
                 
               OC_ASEGURADO_CERTIFICADO.COPIAR_REN(nCodCia, nIdPolizaOrig, nIDetPol, nIdPoliza, nIDetPol);

               OC_COBERT_ACT_ASEG.COPIAR_REN(nCodCia, nIdPolizaOrig, nIDetPol, nIdPoliza, nIDetPol);
              
               IF NVL(X.IndPolCol,'N') = 'N' THEN
                  OC_ASISTENCIAS_ASEGURADO.COPIAR(nCodCia, nIdPolizaOrig, nIDetPol, nIdPoliza, nIDetPol);

                  OC_ASISTENCIAS_DETALLE_POLIZA.COPIAR_REN(nCodCia, nIdPolizaOrig, nIDetPol, nIdPoliza, nIDetPol);

                  OC_BENEFICIARIO.COPIAR_REN(nIdPolizaOrig, nIDetPol, Y.Cod_Asegurado, nIdPoliza, nIDetPol, Y.Cod_Asegurado);
               END IF;
               GT_FAI_FONDOS_DETALLE_POLIZA.COPIAR_FONDOS_REN(nCodCia, Y.CodEmpresa, nIdPolizaOrig, nIDetPol, Y.Cod_Asegurado, nIdPoliza);
                         
               -- SE VALIDA SI EN EL CERTIFICADO HAY ASEGURADOS
               cTIENEASEGS := OC_ASEGURADO_CERTIFICADO.TIENE_ASEGURADOS(nCodCia,nIdPoliza,nIDetPol,0);
                 
               IF cTIENEASEGS = 'S' THEN
                   OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, nIDetPol, 0);
               ELSE
                 DELETE FROM DETALLE_POLIZA WHERE CODCIA = nCodCia AND IDPOLIZA = nIdPoliza AND IDETPOL = nIdPoliza;
               END IF;
                 
             
             END LOOP;

             IF cTipoSeg != 'F' THEN


                 FOR Z IN COB_Q LOOP

                       -- CAPELE
                       cESRamoReal := NVL(OC_TIPOS_DE_SEGUROS.INDMULTIRAMO(Z.CODCIA,Z.CODEMPRESA, Z.IDTIPOSEG ), 'N');

                       IF cESRamoReal = 'S' AND Z.IDRAMOREAL IS NULL THEN
                          cINDRAMOREAL := OC_COBERTURAS_DE_SEGUROS.COBERTURA_IDRAMOREAL(Z.CodCia, Z.CODEMPRESA, Z.IdTipoSeg, Z.PlanCob, Z.CodCobert);
                       ELSE
                          cINDRAMOREAL := Z.IDRAMOREAL;
                       END IF;
                      --
                      INSERT INTO COBERT_ACT
                     (IdPoliza,  IDetPol, CodEmpresa, CodCia, CodCobert, StsCobertura,
                      SumaAseg_Local, SumaAseg_Moneda, Prima_Local, Prima_Moneda, Tasa,
                      IdEndoso, IdTipoSeg, TipoRef, NumRef, PlanCob, Cod_Moneda,
                      Deducible_Local, Deducible_Moneda, Cod_Asegurado, IDRAMOREAL)
                    VALUES(nIdPoliza, Z.IDetPol, Z.CodEmpresa, Z.CodCia, Z.CodCobert, 'SOL',
                      Z.SumaAseg_Moneda, Z.SumaAseg_Moneda, Z.Prima_Moneda, Z.Prima_Moneda, NULL,
                      0, Z.IdTipoSeg, Z.TipoRef, Z.NumRef, Z.PlanCob, Z.Cod_Moneda,
                      Z.Deducible_Local, Z.Deducible_Moneda, Z.Cod_Asegurado, cINDRAMOREAL);
                 END LOOP;

                 FOR W IN PER_Q LOOP
                    INSERT INTO DATOS_PARTICULARES_PERSONAS
                     (IdPoliza, IDetPol, Estatura, Peso, Cavidad_Toraxica_Min,
                      Cavidad_Toraxica_Max, Capacidad_Abdominal, Presion_Arterial_Min,
                      Presion_Arterial_Max, Pulso, Mortalidad, Suma_Aseg_Moneda,
                      Suma_Aseg_Local, Extra_Prima_Moneda, Extra_Prima_Local, Id_Fumador,
                      Observaciones, Porc_SubNormal, Prima_Local, Prima_Moneda)
                    VALUES(nIdPoliza, W.IDetPol, W.Estatura, W.Peso, W.Cavidad_Toraxica_Min,
                      W.Cavidad_Toraxica_Max, W.Capacidad_Abdominal, W.Presion_Arterial_Min,
                      W.Presion_Arterial_Max, W.Pulso, W.Mortalidad, W.Suma_Aseg_Moneda,
                      W.Suma_Aseg_Local,  W.Extra_Prima_Moneda, W.Extra_Prima_Local, W.Id_Fumador,
                      W.Observaciones, W.Porc_SubNormal, W.Prima_Local, W.Prima_Moneda);
                 END LOOP;
                 FOR B IN BIEN_Q LOOP
                    INSERT INTO DATOS_PARTICULARES_BIENES
                     (IdPoliza, Num_Bien, IDetPol, CodPais, CodEstado, CodCiudad,
                      CodMunicipio, Ubicacion_Bien, Tipo_Bien, Suma_Aseg_Local_Bien,
                      Suma_Aseg_Moneda_Bien,Prima_Neta_Local_Bien, Prima_Neta_Moneda_Bien,
                      Inicio_Vigencia, Fin_Vigencia)
                    VALUES(nIdPoliza, B.Num_Bien, B.IDetPol, B.CodPais, B.CodEstado, B.CodCiudad,
                      B.CodMunicipio, B.Ubicacion_Bien, B.Tipo_Bien, B.Suma_Aseg_Local_Bien,
                      B.Suma_Aseg_Moneda_Bien, B.Prima_Neta_Local_Bien, B.Prima_Neta_Moneda_Bien,
                      dFecHoy, ADD_MONTHS(dFecHoy,12));
                 END LOOP;
                 FOR A IN AUTO_Q LOOP
                    INSERT INTO DATOS_PARTICULARES_VEHICULO
                     (IdPoliza, IDetPol, Num_Vehi, Cod_Marca, Cod_Version,
                      Cod_Modelo, Anio_Vehiculo, Placa, Cantidad_Pasajeros,
                      Tarjeta_Circulacion, Color, Numero_Chasis, Numero_Motor,
                      SumaAseg_Local, SumaAseg_Moneda, PrimaNeta_Local, PrimaNeta_Moneda)
                    VALUES(nIdPoliza, A.IDetPol, A.Num_Vehi, A.Cod_Marca, A.Cod_Version,
                      A.Cod_Modelo, A.Anio_Vehiculo, A.Placa, A.Cantidad_Pasajeros,
                      A.Tarjeta_Circulacion, A.Color, A.Numero_Chasis, A.Numero_Motor,
                      A.SumaAseg_Local, A.SumaAseg_Moneda,  A.PrimaNeta_Local, A.PrimaNeta_Moneda);
                 END LOOP;
             END IF;
          END IF;     
      END LOOP;
            
      IF bContinua = TRUE THEN       
          BEGIN
            
             OC_POLIZAS.ACTUALIZA_VALORES(nCodCia, nIdPoliza, 0);  
             OC_POLIZAS.EMITIR_POLIZA(nCodCia, nIdPoliza, nCodCia);
                    
            UPDATE POLIZAS
              SET StsPoliza = 'REN',
                  FecSts    = dFecHoy
            WHERE IdPoliza  = nIdPolizaOrig
              AND CodCia    = nCodCia;


           UPDATE DETALLE_POLIZA
              SET StsDetalle = 'REN'
            WHERE IdPoliza  = nIdPolizaOrig
              AND CodCia    = nCodCia;

           UPDATE COBERT_ACT
              SET StsCobertura = DECODE(StsCobertura,'EMI','REN',StsCobertura)
            WHERE IdPoliza     = nIdPolizaOrig
              AND CodCia       = nCodCia;

           UPDATE COBERTURAS
              SET StsCobertura = 'REN'
            WHERE IdPoliza     = nIdPolizaOrig
              AND CodCia       = nCodCia;

           UPDATE ASISTENCIAS_DETALLE_POLIZA
              SET StsAsistencia = DECODE(StsAsistencia,'EMITID','RENOVA',StsAsistencia)
            WHERE IdPoliza     = nIdPolizaOrig
              AND CodCia       = nCodCia;

           UPDATE COBERT_ACT_ASEG
              SET StsCobertura = DECODE(StsCobertura,'EMI','REN',StsCobertura)
            WHERE IdPoliza     = nIdPolizaOrig
              AND CodCia       = nCodCia;

           UPDATE COBERTURA_ASEG
              SET StsCobertura = DECODE(StsCobertura,'EMI','REN',StsCobertura)
            WHERE IdPoliza     = nIdPolizaOrig
              AND CodCia       = nCodCia;

           UPDATE ASISTENCIAS_ASEGURADO
              SET StsAsistencia = DECODE(StsAsistencia,'EMITID','RENOVA',StsAsistencia)
            WHERE IdPoliza     = nIdPolizaOrig
              AND CodCia       = nCodCia;

           UPDATE ASEGURADO_CERTIFICADO
              SET Estado       = DECODE(Estado,'EMI','REN',Estado)
            WHERE IdPoliza     = nIdPolizaOrig
              AND CodCia       = nCodCia;

           UPDATE CLAUSULAS_POLIZA
              SET Estado       = DECODE(Estado,'EMITID','RENOVA',Estado)
            WHERE IdPoliza     = nIdPolizaOrig
              AND CodCia       = nCodCia;

           UPDATE CLAUSULAS_DETALLE
              SET Estado       = DECODE(Estado,'EMITID','RENOVA',Estado)
            WHERE IdPoliza     = nIdPolizaOrig
              AND CodCia       = nCodCia;
            
          EXCEPTION
              WHEN RERROR THEN
                RAISE_APPLICATION_ERROR(-20226,'Certificado(s) dado de alta posterior a emisión de Póliza: '||TRIM(TO_CHAR(nIdPolizaOrig))|| ' Error raised in: '|| $$plsql_unit ||' at line ' || $$plsql_line || ' - '||sqlerrm); 
               
             WHEN OTHERS THEN
               
             --v_log := 'Error al Emitir Renovación de Póliza: '||TRIM(TO_CHAR(nIdPolizaOrig))|| ' Error raised in: '|| $$plsql_unit ||' at line ' || $$plsql_line || ' - '||sqlerrm;
               
               IF SQLCODE = -20226 THEN

                   RAISE_APPLICATION_ERROR(-20226,'Error al Emitir Renovación de Póliza: '||TRIM(TO_CHAR(nIdPolizaOrig))|| ' Error raised in: '|| $$plsql_unit ||' at line ' || $$plsql_line || ' - '||sqlerrm);
               ELSE

                   RAISE_APPLICATION_ERROR(-20225,'Error al Emitir Renovación de Póliza: '||TRIM(TO_CHAR(nIdPolizaOrig))|| ' Error raised in: '|| $$plsql_unit ||' at line ' || $$plsql_line || ' - '||sqlerrm);
               END IF;
             

          END;          
             
          RETURN (nIdPoliza);
       ELSE
        DBMS_OUTPUT.PUT_LINE('ESTA RARO');
        RETURN (1);
       END IF;
   END COPIAR_REN;
 -- PROCESOS GENERADOS PARA LA RENOVACION ESPECIAL MLJS CAGR ---  
END OC_POLIZAS;
/
