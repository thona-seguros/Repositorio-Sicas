CREATE OR REPLACE PACKAGE          OC_EMPRESAS_DE_SEGUROS IS

FUNCTION NOMBRE_EMPRESA(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN VARCHAR2;
FUNCTION EMAIL_EMPRESA(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN VARCHAR2;
FUNCTION IDENTIFICACION_TRIBUTARIA(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN VARCHAR2;
PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresaOrig NUMBER, nCodEmpresaDest NUMBER, cNomEmpresaDest VARCHAR2);
FUNCTION TELEFONO (nCodCia NUMBER, nCodEmpresa NUMBER) RETURN VARCHAR2;
FUNCTION FAX (nCodCia NUMBER, nCodEmpresa NUMBER) RETURN VARCHAR2;
FUNCTION EMAIL (nCodCia NUMBER, nCodEmpresa NUMBER) RETURN VARCHAR2;

END OC_EMPRESAS_DE_SEGUROS;
/

CREATE OR REPLACE PACKAGE BODY          OC_EMPRESAS_DE_SEGUROS IS

FUNCTION NOMBRE_EMPRESA(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN VARCHAR2 IS
cNomEmpresa   EMPRESAS_DE_SEGUROS.NomEmpresa%TYPE;
BEGIN
   SELECT NomEmpresa
     INTO cNomEmpresa
     FROM EMPRESAS_DE_SEGUROS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa;
   RETURN(cNomEmpresa);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      cNomEmpresa := 'EMPRESA - NO EXISTE!!!';
      RETURN(cNomEmpresa);
END NOMBRE_EMPRESA;

FUNCTION EMAIL_EMPRESA(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN VARCHAR2 IS
cEMail     EMPRESAS_DE_SEGUROS.EMail%TYPE;
BEGIN
   SELECT EMail
     INTO cEMail
     FROM EMPRESAS_DE_SEGUROS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa;
   RETURN(cEMail);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      cEMail   := NULL;
      RETURN(cEMail);
END EMAIL_EMPRESA;

FUNCTION IDENTIFICACION_TRIBUTARIA(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN VARCHAR2 IS
cNum_Tributario     EMPRESAS_DE_SEGUROS.Num_Tributario%TYPE;
BEGIN
   SELECT Num_Tributario
     INTO cNum_Tributario
     FROM EMPRESAS_DE_SEGUROS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa;
   IF cNum_Tributario IS NULL THEN
      RAISE_APPLICATION_ERROR(-20200,'Empresa '|| nCodCia || ' NO Tiene Registrada su Identificación Tributaria');
   ELSE   
      RETURN(cNum_Tributario);
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20200,'Empresa '|| nCodEmpresa || ' NO Existe');
END IDENTIFICACION_TRIBUTARIA;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresaOrig NUMBER, nCodEmpresaDest NUMBER, cNomEmpresaDest VARCHAR2) IS
nIdTarifaDest    TARIFA_DINAMICA.IdTarifa%TYPE;
nIdTarifaOrig    TARIFA_DINAMICA.IdTarifa%TYPE;
cCodCobert       TARIFA_DINAMICA_FORMULA.CodCobert%TYPE;
cTipoTarifa      TARIFA_DINAMICA_FORMULA.TipoTarifa%TYPE;
nIdCampo         TARIFA_DINAMICA_FORMULA.IdCampo%TYPE;

CURSOR EMP_Q IS
   SELECT TipoEmpresa, NomEmpresa, DirecEmpresa, CodPaisEmp,
          CodProvEmp, CodDistEmp, CodCorrEmp, ZipEmp, TelEmp,
          FaxEmp, Email, FecConstit, Tipo_Id_Tributaria,
          Num_Tributario, Dias_Aviso_Renovacion
     FROM EMPRESAS_DE_SEGUROS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR CONT_Q IS
   SELECT Corr_Contacto, Contacto, Departamento, TelContacto,
          FaxContacto, Email, Puesto 
     FROM CONTACTOS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR PLANT_Q IS
   SELECT CodPlantilla, DescPlantilla, TipoPlantilla, StsPlantilla, FecSts,
          NomArchivo, PathArchivo, IndSeparador, TipoSeparador, AccionPlantilla,
          CodUsuario, FecUltCambio, CodEntidad
     FROM CONFIG_PLANTILLAS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR TAB_Q IS
   SELECT CodPlantilla, NomTabla, OrdenProceso, TipoTabla,
          WhereTabla, OrdenCampos, TipoAccion, CodRutina
     FROM CONFIG_PLANTILLAS_TABLAS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR CAMP_Q IS
   SELECT CodPlantilla, NomTabla, OrdenProceso, OrdenCampo, NomCampo,
          IndClavePrimaria, TipoCampo, PosIniCampo, LongitudCampo,
          NumDecimales, ValorDefault, SqlValidacion, SQLValorCampo,
          IndDatoPart, OrdenDatoPart, IndAseg
     FROM CONFIG_PLANTILLAS_CAMPOS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR PLANPAGO_Q IS
   SELECT CodPlanPago, DescPlan, NumPagos, FrecPagos, PorcInicial,
          StsPlan, FecSts, TipoPago
     FROM PLAN_DE_PAGOS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR CPTOS_Q IS
   SELECT CodPlanPago, CodCpto, PorcCpto, Aplica, MtoCpto,
          IndModif, MtoMinajuste, MtoMaxAjuste, MtoMaximo,
          MtoMinimo, Prioridad, RutinaCalculo
     FROM CONCEPTOS_PLAN_DE_PAGOS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR RAMOS_Q IS
   SELECT CodPlanPago, CodCpto, IdTipoSeg
     FROM RAMOS_CONCEPTOS_PLAN
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR TIPSEG_Q IS
   SELECT IdTipoSeg, Descripcion, TipoSeg, StsTipSeg, IdPlantilla, CodTipoPlan,
          CodPlanPago, IndRenovAut, TipoContabilidad, DiasCancelacion
     FROM TIPOS_DE_SEGUROS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR REG_Q IS
   SELECT IdTipoSeg, NumRegistro, FecRegistro, NumAutorTipSeg,
          FecIngreso, Observaciones, CodUsuario
     FROM REGISTRO_TIPSEG_AUTORIDAD
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR REQSEG_Q IS
   SELECT IdTipoSeg, CodRequisito
     FROM REQUISITOS_SEGUROS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR DATEMI_Q IS
   SELECT IdTipoSeg, IdCampo, TipoDato, Longitud, Decimales,
          IndOblig, DescCampo, CatalogVal, IndUnico, IndImpresion,
          OrdenImpresion, DatCampoUnico
     FROM CONF_DATPART_EMISION
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR DATSIN_Q IS
   SELECT IdTipoSeg, IdCampo, TipoDato, Longitud, Decimales,
          IndOblig, DescCampo, CatalogVal, IndUnico, DatCampoUnico
     FROM CONF_DATPART_SINIESTROS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR SESAS_Q IS
   SELECT IdTipoSeg, ClaseSeguro, TipoSeguro, PeriodoEspera, InicioCobertura,
          MaxDiasBenef3, SubTipoSeg, TipoRiesgo, TipoRiesgoAsoc, CobertAfectada,
          ModalSumaAseg, ModalPoliza, MtoDeducible, MtoCoaseguro, CodUsuario,
          FecUltCambio
     FROM CONFIG_SESAS_TIPO_SEGURO
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR CANC_Q IS
   SELECT IdTipoSeg, FecIniReten, FecFinReten, DiasIniReten,
          PorcReten, CodUsuario, FecUltCambio
     FROM CONFIG_RETEN_CANCELACION
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR COMIS_Q IS
   SELECT IdTipoSeg, PorcComision, MontoComision
     FROM CONFIG_COMISIONES
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR SOBCOMIS_Q IS
   SELECT IdTipoSeg, RangoInicial, RangoFinal, PorcSobComis, MontoSobComis
     FROM CONFIG_SOBRECOMISIONES
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR PLANCOB_Q IS
   SELECT IdTipoSeg, PlanCob, Desc_Plan, UltModPlan, Estado_Plan,
          CodUsuario, TipPlanCob, CodMoneda, CodTipoPlan, Cod_Agente,
          DiasRetroactivos, Modalidad, PlanPoliza, Indisputabilidad,
          CodTemporalidad, IndAplicaSami, ComMinima, ComMaxima,
          PorcGtoAdmin, PorcGtoAdqui, PorcUtilidad
     FROM PLAN_COBERTURAS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;   

CURSOR CNFPLANT_Q IS
   SELECT IdTipoSeg, PlanCob, TipoProceso, CodPlantilla,
          CodUsuario, FecUltCambio, AreaAplicacion
     FROM CONFIG_PLANTILLAS_PLANCOB
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;   

CURSOR ASIS_Q IS
   SELECT IdTipoSeg, PlanCob, CodAsistencia, IndAsistOblig,
          StsPlanCobAsist, FecSts, CodUsuario, FecUltCambio
     FROM CONFIG_ASISTENCIAS_PLANCOB
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR NIVEL_Q IS
   SELECT IdTipoSeg, PlanCob, CodNivel, ComAgeNivel, Origen
     FROM NIVEL_PLAN_COBERTURA
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR REQPLAN_Q IS
   SELECT IdTipoSeg, PlanCob, CodRequisito
     FROM REQUISITOS_PLAN_COBERT
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR NOMSIN_Q IS
   SELECT IdTipoSeg, PlanCob, Codigo, Nomenclatura, 
          Anio, UltSinAsig, Descipcion
     FROM CONFIG_NOMSIN
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR TAR_Q IS
   SELECT IdTipoSeg, PlanCob, CodCobert, EdadIniTarifa,
          EdadFinTarifa, SexoTarifa, RiesgoTarifa,
          SumaAsegTarifa, PrimaTarifa, TasaTarifa
     FROM TARIFA_SEXO_EDAD_RIESGO
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR DIN_Q IS
   SELECT IdTarifa, IdTipoSeg, PlanCob, FecIniTarifa, FecFinTarifa,
          ObservTarifa, StsTarifa, FecSts, CodUsuario, FecUltCambio
     FROM TARIFA_DINAMICA
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR DET_DIN_Q IS
   SELECT CodCobert, TipoTarifa, IdCampo, IndAplicFormula, 
          CodCampo, OrdenProcCampo, CodCondicion, ValorIniCond,
          ValorFinCond, ValorTarifa, CampoValor, OrdenProcCampoVal,
          CodUsuario, FecUltCambio, OrdenCampo, TipoProceso
     FROM TARIFA_DINAMICA_DET
    WHERE IdTarifa   = nIdTarifaOrig;

CURSOR FORM_DIN_Q IS
   SELECT Codcobert, TipoTarifa, IdOrdenFormula, TipoOperacion,
          ValorOperacion, ValorCampo, OrdenProcValCampo, CodUsuario,
          FecUltCambio, OrdenCampo, IdCampo
     FROM TARIFA_DINAMICA_FORMULA
    WHERE IdTarifa   = nIdTarifaOrig;

CURSOR COA_Q IS
   SELECT IdTipoSeg, PlanCob, FecIniVig, FecFinVig,
          PorcenCoaseguro, FactorCoaseguro
     FROM FACTOR_COASEGURO
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR DED_Q IS
   SELECT IdTipoSeg, PlanCob, FecIniVig, FecFinVig,
          MontoDeducible, FactorDeducible
     FROM FACTOR_DEDUCIBLE
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR FSUM_Q IS
   SELECT IdTipoSeg, PlanCob, FecIniVig, FecFinVig,
          MontoSumaAseg, FactorSumaAseg
     FROM FACTOR_SUMA_ASEGURADA
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR GUA_Q IS
   SELECT IdTipoSeg, PlanCob, FecIniVig, FecFinVig,
          PorcentajeGua, FactorGua
     FROM GASTO_USUAL_ACOSTUMBRADO
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR COBERT_Q IS
   SELECT IdTipoSeg, PlanCob, CodCobert, DescCobert, TipoTasa, Porc_Tasa,
          Prima_Cobert, StsCobertura, SumaAsegurada, Cod_Moneda, AcumulaASuma,
          IndBasica, Cobertura_Basica, Calcula_Prorrata, Devuelve_Prima,
          Edad_Minima, Edad_Maxima, Edad_Exclusion, NomRep, CodCpto, CodTarifa,
          ClaveSesas, SumaAsegMinima, SumaAsegMaxima, SumaAsegMaxIndiv,
          IndPerdOrganicas, IndManejaAnticipos, PorcenAnticipo, MontoAnticipo,
          PorcenDeducible, MontoDeducible, PeriodoEsperaAnios, PeriodoEsperaMeses,
          CodRiesgoRea, IndAcumulaSumaRea, IndAcumulaPrimaRea, IndSumaSami,
          OrdenImpresion, TabMortalidad
     FROM COBERTURAS_DE_SEGUROS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR PERD_Q IS
   SELECT IdTipoSeg, PlanCob, CodCobert, CodPerdOrganica,
          FecIniIndem, FecFinIndem, PorcenIndemnizacion
     FROM PERDIDAS_ORGANICAS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;

CURSOR REQCOB_Q IS
   SELECT IdTipoSeg, PlanCob, CodCobert, CodRequisito
     FROM REQUISITO_COBERT_SEGURO
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresaOrig;
BEGIN
   BEGIN
      FOR W IN EMP_Q LOOP
         INSERT INTO EMPRESAS_DE_SEGUROS
                (CodCia, CodEmpresa, TipoEmpresa, NomEmpresa, DirecEmpresa, CodPaisEmp,
                 CodProvEmp, CodDistEmp, CodCorrEmp, ZipEmp, TelEmp,
                 FaxEmp, Email, StsEmpresa, FecSts, FecIngreso, FecConstit,
                 Tipo_Id_Tributaria, Num_Tributario, Dias_Aviso_Renovacion)
         VALUES (nCodCia, nCodEmpresaDest, W.TipoEmpresa, cNomEmpresaDest, W.DirecEmpresa, W.CodPaisEmp,
                 W.CodProvEmp, W.CodDistEmp, W.CodCorrEmp, W.ZipEmp, W.TelEmp,
                 W.FaxEmp, W.Email, 'ACT', TRUNC(SYSDATE), TRUNC(SYSDATE), W.FecConstit,
                 W.Tipo_Id_Tributaria, W.Num_Tributario, W.Dias_Aviso_Renovacion);
      END LOOP;
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20200,'Empresa '|| nCodEmpresaDest || ' YA Existe');
   END;

   FOR W IN CONT_Q LOOP
      INSERT INTO CONTACTOS
            (CodCia, CodEmpresa, Corr_Contacto, Contacto, Departamento,
             TelContacto, FaxContacto, Email, Puesto)
      VALUES(nCodCia, nCodEmpresaDest, W.Corr_Contacto, W.Contacto, W.Departamento,
             W.TelContacto, W.FaxContacto, W.Email, W.Puesto);
   END LOOP;

   FOR V IN PLANPAGO_Q LOOP
      INSERT INTO PLAN_DE_PAGOS
            (CodCia, CodEmpresa, CodPlanPago, DescPlan, NumPagos, 
             FrecPagos, PorcInicial, StsPlan, FecSts, TipoPago)
      VALUES(nCodCia, nCodEmpresaDest, V.CodPlanPago, V.DescPlan, V.NumPagos,
             V.FrecPagos, V.PorcInicial, V.StsPlan, TRUNC(SYSDATE), V.TipoPago);
   END LOOP;

   FOR T IN CPTOS_Q LOOP
      INSERT INTO CONCEPTOS_PLAN_DE_PAGOS
            (CodCia, CodEmpresa, CodPlanPago, CodCpto, PorcCpto, Aplica,
             MtoCpto, IndModif, MtoMinajuste, MtoMaxAjuste, MtoMaximo,
             MtoMinimo, Prioridad, RutinaCalculo)
      VALUES(nCodCia, nCodEmpresaDest, T.CodPlanPago, T.CodCpto, T.PorcCpto, T.Aplica,
             T.MtoCpto, T.IndModif, T.MtoMinajuste, T.MtoMaxAjuste, T.MtoMaximo,
             T.MtoMinimo, T.Prioridad, T.RutinaCalculo);
   END LOOP;

   FOR R IN RAMOS_Q LOOP
      INSERT INTO RAMOS_CONCEPTOS_PLAN
            (CodCia, CodEmpresa, CodPlanPago, CodCpto, IdTipoSeg)
      VALUES(nCodCia, nCodEmpresaDest, R.CodPlanPago, R.CodCpto, R.IdTipoSeg);
   END LOOP;

   FOR P IN PLANT_Q LOOP
      INSERT INTO CONFIG_PLANTILLAS
            (CodCia, CodEmpresa, CodPlantilla, DescPlantilla, TipoPlantilla, StsPlantilla,
             FecSts, NomArchivo, PathArchivo, IndSeparador, TipoSeparador, 
             AccionPlantilla, CodUsuario, FecUltCambio, CodEntidad)
      VALUES(nCodCia, nCodEmpresaDest, P.CodPlantilla, P.DescPlantilla, P.TipoPlantilla, P.StsPlantilla,
             TRUNC(SYSDATE), P.NomArchivo, P.PathArchivo, P.IndSeparador, P.TipoSeparador, 
             P.AccionPlantilla, USER, TRUNC(SYSDATE), P.CodEntidad);
   END LOOP;

   FOR T IN TAB_Q LOOP
      INSERT INTO CONFIG_PLANTILLAS_TABLAS
            (CodCia, CodEmpresa, CodPlantilla, NomTabla, OrdenProceso, TipoTabla,
             WhereTabla, OrdenCampos, TipoAccion, CodRutina)
      VALUES(nCodCia, nCodEmpresaDest, T.CodPlantilla, T.NomTabla, T.OrdenProceso, T.TipoTabla,
             T.WhereTabla, T.OrdenCampos, T.TipoAccion, T.CodRutina);
   END LOOP;

   FOR C IN CAMP_Q LOOP
      INSERT INTO CONFIG_PLANTILLAS_CAMPOS
            (CodCia, CodEmpresa, CodPlantilla, NomTabla, OrdenProceso, OrdenCampo, 
             NomCampo, IndClavePrimaria, TipoCampo, PosIniCampo, LongitudCampo,
             NumDecimales, ValorDefault, SqlValidacion, SQLValorCampo,
             IndDatoPart, OrdenDatoPart, IndAseg)
      VALUES(nCodCia, nCodEmpresaDest, C.CodPlantilla, C.NomTabla, C.OrdenProceso, C.OrdenCampo,
             C.NomCampo, C.IndClavePrimaria, C.TipoCampo, C.PosIniCampo, C.LongitudCampo,
             C.NumDecimales, C.ValorDefault, C.SqlValidacion, C.SQLValorCampo,
             C.IndDatoPart, C.OrdenDatoPart, C.IndAseg);
   END LOOP;

   FOR X IN TIPSEG_Q LOOP
      INSERT INTO TIPOS_DE_SEGUROS
            (CodCia, CodEmpresa, IdTipoSeg, Descripcion, StsTipSeg, 
             FecSts, TipoSeg, IdPlantilla, CodTipoPlan,
             CodPlanPago, IndRenovAut, TipoContabilidad, DiasCancelacion)
      VALUES(nCodCia, nCodEmpresaDest, X.IdTipoSeg, X.Descripcion, X.StsTipSeg,
             TRUNC(SYSDATE), X.TipoSeg, X.IdPlantilla, X.CodTipoPlan,
             X.CodPlanPago, X.IndRenovAut, X.TipoContabilidad, X.DiasCancelacion);
   END LOOP;

   FOR R IN REG_Q  LOOP
      INSERT INTO REGISTRO_TIPSEG_AUTORIDAD
            (CodCia, CodEmpresa, IdTipoSeg, NumRegistro, FecRegistro,
             NumautorTipSeg, FecIngreso, Observaciones, CodUsuario)
      VALUES(nCodCia, nCodEmpresaDest, R.IdTipoSeg, R.NumRegistro, R.FecRegistro,
             R.NumAutorTipSeg, R.FecIngreso, R.Observaciones, USER);
   END LOOP;

   FOR R IN REQSEG_Q LOOP
      INSERT INTO REQUISITOS_SEGUROS
            (CodCia, CodEmpresa, IdTipoSeg, CodRequisito)
      VALUES(nCodCia, nCodEmpresaDest, R.IdTipoSeg, R.CodRequisito);
   END LOOP;

   FOR D IN DATEMI_Q LOOP
      INSERT INTO CONF_DATPART_EMISION
            (CodCia, CodEmpresa, IdTipoSeg, IdCampo, TipoDato, Longitud,
             Decimales, IndOblig, DescCampo, CatalogVal, IndUnico,
             IndImpresion, OrdenImpresion, DatCampoUnico)
      VALUES(nCodCia, nCodEmpresaDest, D.IdTipoSeg, D.IdCampo, D.TipoDato, D.Longitud,
             D.Decimales, D.IndOblig, D.DescCampo, D.CatalogVal, D.IndUnico,
             D.IndImpresion, D.OrdenImpresion, D.DatCampoUnico);
   END LOOP;

   FOR S IN DATSIN_Q LOOP
      INSERT INTO CONF_DATPART_SINIESTROS
            (CodCia, CodEmpresa, IdTipoSeg, IdCampo, TipoDato, Longitud, Decimales,
             IndOblig, DescCampo, CatalogVal, IndUnico, DatCampoUnico)
      VALUES(nCodCia, nCodEmpresaDest, S.IdTipoSeg, S.IdCampo, S.TipoDato, S.Longitud, S.Decimales,
             S.IndOblig, S.DescCampo, S.CatalogVal, S.IndUnico, S.DatCampoUnico);
   END LOOP;

   FOR T IN SESAS_Q LOOP
      INSERT INTO CONFIG_SESAS_TIPO_SEGURO
            (CodCia, CodEmpresa, IdTipoSeg, ClaseSeguro, TipoSeguro, PeriodoEspera,
             InicioCobertura, MaxDiasBenef3, SubTipoSeg, TipoRiesgo, TipoRiesgoAsoc,
             CobertAfectada, ModalSumaAseg, ModalPoliza, MtoDeducible, MtoCoaseguro,
             CodUsuario, FecUltCambio)
      VALUES(nCodCia, nCodEmpresaDest, T.IdTipoSeg, T.ClaseSeguro, T.TipoSeguro, T.PeriodoEspera,
             T.InicioCobertura, T.MaxDiasBenef3, T.SubTipoSeg, T.TipoRiesgo, T.TipoRiesgoAsoc,
             T.CobertAfectada, T.ModalSumaAseg, T.ModalPoliza, T.MtoDeducible, T.MtoCoaseguro,
             T.CodUsuario, T.FecUltCambio);
   END LOOP;

   FOR C IN CANC_Q LOOP
      INSERT INTO CONFIG_RETEN_CANCELACION
            (CodCia, CodEmpresa, IdTipoSeg, FecIniReten, FecFinReten,
             DiasIniReten, PorcReten, CodUsuario, FecUltCambio)
      VALUES(nCodCia, nCodEmpresaDest, C.IdTipoSeg, C.FecIniReten, C.FecFinReten,
             C.DiasIniReten, C.PorcReten, C.CodUsuario, C.FecUltCambio);
   END LOOP;

   FOR Z IN COMIS_Q LOOP
      INSERT INTO CONFIG_COMISIONES
            (CodCia, CodEmpresa, IdTipoSeg, PorcComision, MontoComision)
      VALUES(nCodCia, nCodEmpresaDest, Z.IdTipoSeg, Z.PorcComision, Z.MontoComision);
   END LOOP;

   FOR W IN SOBCOMIS_Q LOOP
      INSERT INTO CONFIG_SOBRECOMISIONES
            (CodCia, CodEmpresa, IdTipoSeg, RangoInicial, 
             RangoFinal, PorcSobComis, MontoSobComis)
      VALUES(nCodCia, nCodEmpresaDest, W.IdTipoSeg, W.RangoInicial,
             W.RangoFinal, W.PorcSobComis, W.MontoSobComis);
   END LOOP;

   FOR X IN PLANCOB_Q LOOP
      INSERT INTO PLAN_COBERTURAS
            (CodCia, CodEmpresa, IdTipoSeg, PlanCob, Desc_Plan, UltModPlan,
             Estado_Plan, CodUsuario, TipPlanCob, CodMoneda, CodTipoPlan,
             Cod_Agente, DiasRetroactivos, Modalidad, PlanPoliza,
             Indisputabilidad, CodTemporalidad, IndAplicaSami, ComMinima,
             ComMaxima, PorcGtoAdmin, PorcGtoAdqui, PorcUtilidad)
      VALUES(nCodCia, nCodEmpresaDest, X.IdTipoSeg, X.PlanCob, X.Desc_Plan, X.UltModPlan,
             X.Estado_Plan, USER, X.TipPlanCob, X.CodMoneda, X.CodTipoPlan,
             X.Cod_Agente, X.DiasRetroactivos, X.Modalidad, X.PlanPoliza,
             X.Indisputabilidad, X.CodTemporalidad, X.IndAplicaSami, X.ComMinima,
             X.ComMaxima, X.PorcGtoAdmin, X.PorcGtoAdqui, X.PorcUtilidad);
   END LOOP;

   FOR P IN CNFPLANT_Q LOOP
      INSERT INTO CONFIG_PLANTILLAS_PLANCOB
            (CodCia, CodEmpresa, IdTipoSeg, PlanCob, TipoProceso,
             CodPlantilla, CodUsuario, FecUltCambio, AreaAplicacion)
      VALUES(nCodCia, nCodEmpresaDest, P.IdTipoSeg, P.PlanCob, P.TipoProceso,
             P.CodPlantilla, P.CodUsuario, P.FecUltCambio, P.AreaAplicacion);
   END LOOP;

   FOR A IN ASIS_Q LOOP
      INSERT INTO CONFIG_ASISTENCIAS_PLANCOB
            (CodCia, CodEmpresa, IdTipoSeg, PlanCob, CodAsistencia,
             IndAsistOblig, StsPlanCobAsist, FecSts, CodUsuario,
             FecUltCambio)
      VALUES(nCodCia, nCodEmpresaDest, A.IdTipoSeg, A.PlanCob, A.CodAsistencia,
             A.IndAsistOblig, A.StsPlanCobAsist, A.FecSts, A.CodUsuario,
             A.FecUltCambio);
   END LOOP;

   FOR N IN NIVEL_Q LOOP
      INSERT INTO NIVEL_PLAN_COBERTURA
            (CodCia, CodEmpresa, IdTipoSeg, PlanCob, 
             CodNivel, ComAgeNivel, Origen)
      VALUES(nCodCia, nCodEmpresaDest, N.IdTipoSeg, N.PlanCob, 
             N.CodNivel, N.ComAgeNivel, N.Origen);
   END LOOP;

   FOR R IN REQPLAN_Q LOOP
      INSERT INTO REQUISITOS_PLAN_COBERT
            (CodCia, CodEmpresa, IdTipoSeg, PlanCob, CodRequisito)
      VALUES(nCodCia, nCodEmpresaDest, R.IdTipoSeg, R.PlanCob, R.CodRequisito);
   END LOOP;

   FOR N IN NOMSIN_Q LOOP
      INSERT INTO CONFIG_NOMSIN
            (CodCia, CodEmpresa, IdTipoSeg, PlanCob, Codigo,
             Nomenclatura,  Anio, UltSinAsig, Descipcion)
      VALUES(nCodCia, nCodEmpresaDest, N.IdTipoSeg, N.PlanCob, N.Codigo,
             N.Nomenclatura, N.Anio, N.UltSinAsig, N.Descipcion);
   END LOOP;

   FOR T IN TAR_Q LOOP
      INSERT INTO TARIFA_SEXO_EDAD_RIESGO
            (CodCia, CodEmpresa, IdTipoSeg, PlanCob, CodCobert,
             EdadIniTarifa, EdadFinTarifa, SexoTarifa, RiesgoTarifa,
             SumaAsegTarifa, PrimaTarifa, TasaTarifa)
      VALUES(nCodCia, nCodEmpresaDest, T.IdTipoSeg, T.PlanCob, T.CodCobert,
             T.EdadIniTarifa, T.EdadFinTarifa, T.SexoTarifa, T.RiesgoTarifa,
             T.SumaAsegTarifa, T.PrimaTarifa, T.TasaTarifa);
   END LOOP;

   FOR T IN DIN_Q LOOP
      nIdTarifaDest  := OC_TARIFA_DINAMICA.NUMERO_TARIFA;
      nIdTarifaOrig  := T.IdTarifa;

      INSERT INTO TARIFA_DINAMICA
            (CodCia, CodEmpresa, IdTarifa, IdTipoSeg, PlanCob, 
             FecIniTarifa, FecFinTarifa, ObservTarifa, StsTarifa,
             FecSts, CodUsuario, FecUltCambio)
      VALUES(nCodCia, nCodEmpresaDest, nIdTarifaDest, T.IdTipoSeg, T.PlanCob,
             T.FecIniTarifa, T.FecFinTarifa, T.ObservTarifa, T.StsTarifa,
             TRUNC(SYSDATE), USER, TRUNC(SYSDATE));

      FOR D IN DET_DIN_Q LOOP
         INSERT INTO TARIFA_DINAMICA_DET
               (IdTarifa, CodCobert, TipoTarifa, IdCampo,
                IndAplicFormula, CodCampo, OrdenProcCampo, CodCondicion,
                ValorIniCond, ValorFinCond, ValorTarifa, CampoValor,
                OrdenProcCampoVal, CodUsuario, FecUltCambio, OrdenCampo,
                TipoProceso)
         VALUES(nIdTarifaDest, D.CodCobert, D.TipoTarifa, D.IdCampo,
                D.IndAplicFormula, D.CodCampo, D.OrdenProcCampo, D.CodCondicion,
                D.ValorIniCond, D.ValorFinCond, D.ValorTarifa, D.CampoValor,
                D.OrdenProcCampoVal, USER, TRUNC(SYSDATE), D.OrdenCampo,
                D.TipoProceso);
      END LOOP;

      FOR F IN FORM_DIN_Q LOOP
         INSERT INTO TARIFA_DINAMICA_FORMULA
               (IdTarifa, CodCobert, TipoTarifa, IdOrdenFormula,
                TipoOperacion, ValorOperacion, ValorCampo, OrdenProcValCampo,
                CodUsuario, FecUltCambio, OrdenCampo, IdCampo)
         VALUES(nIdTarifaDest, F.CodCobert, F.TipoTarifa, F.IdOrdenFormula,
                F.TipoOperacion, F.ValorOperacion, F.ValorCampo, F.OrdenProcValCampo,
                F.CodUsuario, F.FecUltCambio, F.OrdenCampo, F.IdCampo);
      END LOOP;
   END LOOP;

   FOR C IN COA_Q LOOP
      INSERT INTO FACTOR_COASEGURO
            (CodCia, CodEmpresa, IdTipoSeg, PlanCob, FecIniVig,
             FecFinVig, PorcenCoaseguro, FactorCoaseguro)
      VALUES(nCodCia, nCodEmpresaDest, C.IdTipoSeg, C.PlanCob, C.FecIniVig,
             C.FecFinVig, C.PorcenCoaseguro, C.FactorCoaseguro);
   END LOOP;

   FOR D IN DED_Q LOOP
      INSERT INTO FACTOR_DEDUCIBLE
            (CodCia, CodEmpresa, IdTipoSeg, PlanCob, FecIniVig,
             FecFinVig, MontoDeducible, FactorDeducible)
      VALUES(nCodCia, nCodEmpresaDest, D.IdTipoSeg, D.PlanCob, D.FecIniVig,
             D.FecFinVig, D.MontoDeducible, D.FactorDeducible);
   END LOOP;

   FOR F IN FSUM_Q LOOP
      INSERT INTO FACTOR_SUMA_ASEGURADA
            (CodCia, CodEmpresa, IdTipoSeg, PlanCob, FecIniVig,
             FecFinVig, MontoSumaAseg, FactorSumaAseg)
      VALUES(nCodCia, nCodEmpresaDest, F.IdTipoSeg, F.PlanCob, F.FecIniVig,
             F.FecFinVig, F.MontoSumaAseg, F.FactorSumaAseg);
   END LOOP;

   FOR G IN GUA_Q LOOP
      INSERT INTO GASTO_USUAL_ACOSTUMBRADO
            (CodCia, CodEmpresa, IdTipoSeg, PlanCob, FecIniVig,
             FecFinVig, PorcentajeGua, FactorGua)
      VALUES(nCodCia, nCodEmpresaDest, G.IdTipoSeg, G.PlanCob, G.FecIniVig,
             G.FecFinVig, G.PorcentajeGua, G.FactorGua);
   END LOOP;

   FOR Y IN COBERT_Q LOOP
      INSERT INTO COBERTURAS_DE_SEGUROS
            (CodCia, CodEmpresa, IdTipoSeg, PlanCob, CodCobert, DescCobert, TipoTasa, Porc_Tasa,
             Prima_Cobert, StsCobertura, SumaAsegurada, Cod_Moneda, AcumulaASuma,
             IndBasica, Cobertura_Basica, Calcula_Prorrata, Devuelve_Prima,
             Edad_Minima, Edad_Maxima, Edad_Exclusion, NomRep, CodCpto, CodTarifa,
             ClaveSesas, SumaAsegMinima, SumaAsegMaxima, SumaAsegMaxIndiv,
             IndPerdOrganicas, IndManejaAnticipos, PorcenAnticipo, MontoAnticipo,
             PorcenDeducible, MontoDeducible, PeriodoEsperaAnios, PeriodoEsperaMeses,
             CodRiesgoRea, IndAcumulaSumaRea, IndAcumulaPrimaRea, IndSumaSami,
             OrdenImpresion, TabMortalidad)
      VALUES(nCodCia, nCodEmpresaDest, Y.IdTipoSeg, Y.PlanCob, Y.CodCobert, Y.DescCobert, Y.TipoTasa, Y.Porc_Tasa,
             Y.Prima_Cobert, Y.StsCobertura, Y.SumaAsegurada, Y.Cod_Moneda, Y.AcumulaASuma,
             Y.IndBasica, Y.Cobertura_Basica, Y.Calcula_Prorrata, Y.Devuelve_Prima,
             Y.Edad_Minima, Y.Edad_Maxima, Y.Edad_Exclusion, Y.NomRep, Y.CodCpto, Y.CodTarifa,
             Y.ClaveSesas, Y.SumaAsegMinima, Y.SumaAsegMaxima, Y.SumaAsegMaxIndiv,
             Y.IndPerdOrganicas, Y.IndManejaAnticipos, Y.PorcenAnticipo, Y.MontoAnticipo,
             Y.PorcenDeducible, Y.MontoDeducible, Y.PeriodoEsperaAnios, Y.PeriodoEsperaMeses,
             Y.CodRiesgoRea, Y.IndAcumulaSumaRea, Y.IndAcumulaPrimaRea, Y.IndSumaSami,
             Y.OrdenImpresion, Y.TabMortalidad);
   END LOOP;

   FOR Z IN PERD_Q LOOP
      INSERT INTO PERDIDAS_ORGANICAS
            (CodCia, CodEmpresa, IdTipoSeg, PlanCob, CodCobert,
             CodPerdOrganica, FecIniIndem, FecFinIndem, PorcenIndemnizacion)
      VALUES(nCodCia, nCodEmpresaDest, Z.IdTipoSeg, Z.PlanCob, Z.CodCobert,
             Z.CodPerdOrganica, Z.FecIniIndem, Z.FecFinIndem, Z.PorcenIndemnizacion);
   END LOOP;

   FOR R IN REQCOB_Q LOOP
      INSERT INTO REQUISITO_COBERT_SEGURO
            (CodCia, CodEmpresa, IdTipoSeg, PlanCob, 
             CodCobert, CodRequisito)
      VALUES(nCodCia, nCodEmpresaDest, R.IdTipoSeg, R.PlanCob,
             R.CodCobert, R.CodRequisito);
   END LOOP;

END COPIAR;

FUNCTION TELEFONO(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN VARCHAR2 IS
cTelEmp     EMPRESAS_DE_SEGUROS.TelEmp%TYPE;
cNomEmpresa EMPRESAS_DE_SEGUROS.NomEmpresa%TYPE;
BEGIN
   SELECT NVL(TelEmp,'SIN TELEFONO')
     INTO cTelEmp
     FROM EMPRESAS_DE_SEGUROS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa;
   RETURN(cTelEmp);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      cNomEmpresa := 'EMPRESA - NO EXISTE!!!';
      RETURN(cNomEmpresa);
END TELEFONO;

FUNCTION FAX(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN VARCHAR2 IS
cFaxEmp     EMPRESAS_DE_SEGUROS.FaxEmp%TYPE;
cNomEmpresa EMPRESAS_DE_SEGUROS.NomEmpresa%TYPE;
BEGIN
   SELECT NVL(FaxEmp,'SIN FAX')
     INTO cFaxEmp
     FROM EMPRESAS_DE_SEGUROS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa;
   RETURN(cFaxEmp);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      cNomEmpresa := 'EMPRESA - NO EXISTE!!!';
      RETURN(cNomEmpresa);
END FAX;

FUNCTION EMAIL(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN VARCHAR2 IS
cEmail     EMPRESAS_DE_SEGUROS.Email%TYPE;
cNomEmpresa EMPRESAS_DE_SEGUROS.NomEmpresa%TYPE;
BEGIN
   SELECT NVL(Email,'SIN EMAIL')
     INTO cEmail
     FROM EMPRESAS_DE_SEGUROS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa;
   RETURN(cEmail);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      cNomEmpresa := 'EMPRESA - NO EXISTE!!!';
      RETURN(cNomEmpresa);
END EMAIL;

END OC_EMPRESAS_DE_SEGUROS;
