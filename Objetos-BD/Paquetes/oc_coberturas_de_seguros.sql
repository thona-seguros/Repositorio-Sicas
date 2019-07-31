--
-- OC_COBERTURAS_DE_SEGUROS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   TARIFA_SEXO_EDAD_RIESGO (Table)
--   COBERTURAS_DE_SEGUROS (Table)
--   OC_TARIFA_SEXO_EDAD_RIESGO (Package)
--   OC_TEXTO_COBERTURA (Package)
--   OC_CLAUSULAS_COBERTURAS (Package)
--   GT_COBERTURAS_EXCLUYENTES (Package)
--   OC_PERDIDAS_ORGANICAS (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_COBERTURAS_DE_SEGUROS IS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                 cPlanCobOrig VARCHAR2, cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2);

FUNCTION CODIGO_TARIFA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                       cCodCobert VARCHAR2) RETURN VARCHAR2;

FUNCTION DESCRIPCION_COBERTURA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                               cCodCobert VARCHAR2) RETURN VARCHAR2;

FUNCTION CLAVE_SESAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                     cPlanCob VARCHAR2, cCodCobert VARCHAR2) RETURN VARCHAR2;

FUNCTION SUMA_ASEGURADA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                        cPlanCob VARCHAR2, cCodCobert VARCHAR2, TipoSuma VARCHAR2) RETURN VARCHAR2;

FUNCTION PERIODO_ESPERA_MESES(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                              cPlanCob VARCHAR2, cCodCobert VARCHAR2) RETURN NUMBER;

FUNCTION VALIDA_BASICA (nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                        cCodCobert VARCHAR2) RETURN VARCHAR2;

FUNCTION ORDEN_SESAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                     cPlanCob VARCHAR2, cCodCobert VARCHAR2) RETURN NUMBER;

FUNCTION TIPO_TASA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                   cPlanCob VARCHAR2, cCodCobert VARCHAR2) RETURN NUMBER;

FUNCTION REASEGURO_SINIESTROS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                              cCodCobert VARCHAR2) RETURN VARCHAR2;

FUNCTION CANCELA_POLIZA_SINIESTRO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                                  cPlanCob VARCHAR2, cCodCobert VARCHAR2) RETURN VARCHAR2;

FUNCTION MOTIVO_CANCELA_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                               cPlanCob VARCHAR2, cCodCobert VARCHAR2) RETURN VARCHAR2;

END OC_COBERTURAS_DE_SEGUROS;
/

--
-- OC_COBERTURAS_DE_SEGUROS  (Package Body) 
--
--  Dependencies: 
--   OC_COBERTURAS_DE_SEGUROS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_COBERTURAS_DE_SEGUROS IS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                 cPlanCobOrig VARCHAR2, cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2) IS

nIdTarifaOrig     TARIFA_SEXO_EDAD_RIESGO.IdTarifa%TYPE;

CURSOR COB_Q IS
   SELECT CodCobert, DescCobert, TipoTasa, Porc_Tasa, Prima_Cobert, SumaAsegurada,
          Cod_Moneda, AcumulaASuma, Cobertura_Basica, Calcula_Prorrata, Devuelve_Prima,
          NomRep, Edad_Minima, Edad_Maxima, Edad_Exclusion, CodCpto, ClaveSesas,
          CodRiesgoRea, IndAcumulaSumaRea, IndAcumulaPrimaRea, SumaAsegMinima,
          SumaAsegMaxima, SumaAsegMaxIndiv, IndPerdOrganicas, IndManejaAnticipos,
          PorcenAnticipo, MontoAnticipo, PorcenDeducible, MontoDeducible,
          PeriodoEsperaAnios, PeriodoesperaMeses, IndSumaSami, CodTarifa, 
          OrdenImpresion, TabMortalidad, OrdenSESAS, CodGrupoCobert, IndReaSiniestro,
          IndCancPolSini, CodMotivCancelPol
     FROM COBERTURAS_DE_SEGUROS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND IdTipoSeg  = cIdTipoSegOrig
      AND PlanCob    = cPlanCobOrig;
BEGIN
   FOR X IN COB_Q LOOP
      INSERT INTO COBERTURAS_DE_SEGUROS
             (CodCia, CodEmpresa, IdTipoSeg, PlanCob, CodCobert, DescCobert, TipoTasa, Porc_Tasa,
              StsCobertura, Prima_Cobert, SumaAsegurada, Cod_Moneda, AcumulaASuma,
              Cobertura_Basica, Calcula_Prorrata, Devuelve_Prima, NomRep,
              Edad_Minima, Edad_Maxima, Edad_Exclusion, CodCpto, ClaveSesas,
              CodRiesgoRea, IndAcumulaSumaRea, IndAcumulaPrimaRea, SumaAsegMinima,
              SumaAsegMaxima, SumaAsegMaxIndiv, IndPerdOrganicas, IndManejaAnticipos,
              PorcenAnticipo, MontoAnticipo, PorcenDeducible, MontoDeducible,
              PeriodoEsperaAnios, PeriodoesperaMeses, IndSumaSami, CodTarifa,
              OrdenImpresion, TabMortalidad, OrdenSESAS, CodGrupoCobert, IndReaSiniestro,
              IndCancPolSini, CodMotivCancelPol)
      VALUES (nCodCia, nCodEmpresa, cIdTipoSegDest, cPlanCobDest, X.CodCobert, X.DescCobert, X.TipoTasa, X.Porc_Tasa,
              'SOL', X.Prima_Cobert, X.SumaAsegurada, X.Cod_Moneda, X.AcumulaASuma,
              X.Cobertura_Basica, X.Calcula_Prorrata, X.Devuelve_Prima, X.NomRep,
              X.Edad_Minima, X.Edad_Maxima, X.Edad_Exclusion, X.CodCpto, X.ClaveSesas,
              X.CodRiesgoRea, X.IndAcumulaSumaRea, X.IndAcumulaPrimaRea, X.SumaAsegMinima,
              X.SumaAsegMaxima, X.SumaAsegMaxIndiv, X.IndPerdOrganicas, X.IndManejaAnticipos,
              X.PorcenAnticipo, X.MontoAnticipo, X.PorcenDeducible, X.MontoDeducible,
              X.PeriodoEsperaAnios, X.PeriodoesperaMeses, X.IndSumaSami, X.CodTarifa,
              X.OrdenImpresion, X.TabMortalidad, X.OrdenSESAS, X.CodGrupoCobert, X.IndReaSiniestro,
              X.IndCancPolSini, X.CodMotivCancelPol);
   END LOOP;

   SELECT NVL(MAX(nIdTarifaOrig),0)
     INTO nIdTarifaOrig
     FROM TARIFA_SEXO_EDAD_RIESGO
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa      
      AND IdTipoSeg  = cIdTipoSegOrig
      AND PlanCob    = cPlanCobOrig;

   IF nIdTarifaOrig > 0 THEN
      OC_TARIFA_SEXO_EDAD_RIESGO.COPIAR_TARIFA_PLAN(nCodCia, nCodEmpresa, cIdTipoSegOrig, cPlanCobOrig,
                                                    cIdTipoSegDest, cPlanCobDest, nIdTarifaOrig);
   END IF;

   OC_PERDIDAS_ORGANICAS.COPIAR(nCodCia, nCodEmpresa, cIdTipoSegOrig, cPlanCobOrig,
                                cIdTipoSegDest, cPlanCobDest);
   OC_CLAUSULAS_COBERTURAS.COPIAR(nCodCia, nCodEmpresa, cIdTipoSegOrig, cPlanCobOrig,
                                cIdTipoSegDest, cPlanCobDest);
   OC_TEXTO_COBERTURA.COPIAR(nCodCia, nCodEmpresa, cIdTipoSegOrig, cPlanCobOrig,
                             cIdTipoSegDest, cPlanCobDest);
   GT_COBERTURAS_EXCLUYENTES.COPIAR(nCodCia, nCodEmpresa, cIdTipoSegOrig, cPlanCobOrig,
                                    cIdTipoSegDest, cPlanCobDest);
END COPIAR;

FUNCTION CODIGO_TARIFA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                       cCodCobert VARCHAR2) RETURN VARCHAR2 IS
cCodTarifa    COBERTURAS_DE_SEGUROS.CodTarifa%TYPE;
BEGIN
   BEGIN
      SELECT CodTarifa
        INTO cCodTarifa
        FROM COBERTURAS_DE_SEGUROS
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdTipoSeg      = cIdTipoSeg
         AND PlanCob        = cPlanCob
         AND CodCobert      = cCodCobert;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodTarifa := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Error en Configuracion de Coberturas del Tipo de Seguro ' || cIdTipoSeg ||
                                 ' y Plan de Coberturas ' || cPlanCob);
   END;
   RETURN(cCodTarifa);
END CODIGO_TARIFA;

FUNCTION DESCRIPCION_COBERTURA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                               cCodCobert VARCHAR2) RETURN VARCHAR2 IS
cDescCobert    COBERTURAS_DE_SEGUROS.DescCobert%TYPE;
BEGIN
   BEGIN
      SELECT DescCobert
        INTO cDescCobert
        FROM COBERTURAS_DE_SEGUROS
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdTipoSeg      = cIdTipoSeg
         AND PlanCob        = cPlanCob
         AND CodCobert      = cCodCobert;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescCobert := 'NO EXISTE COBERTURA';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Error en Configuracion de Coberturas del Tipo de Seguro ' || cIdTipoSeg ||
                                 ' y Plan de Coberturas ' || cPlanCob);
   END;
   RETURN(cDescCobert);
END DESCRIPCION_COBERTURA;

FUNCTION CLAVE_SESAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                     cPlanCob VARCHAR2, cCodCobert VARCHAR2) RETURN VARCHAR2 IS
cClaveSesas    COBERTURAS_DE_SEGUROS.ClaveSesas%TYPE;
BEGIN
   BEGIN
      SELECT ClaveSesas
        INTO cClaveSesas
        FROM COBERTURAS_DE_SEGUROS
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdTipoSeg      = cIdTipoSeg
         AND PlanCob        = cPlanCob
         AND CodCobert      = cCodCobert;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cClaveSesas := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Error en Configuración de Coberturas del Tipo de Seguro ' || cIdTipoSeg ||
                                 ' y Plan de Coberturas ' || cPlanCob);
   END;
   RETURN(cClaveSesas);
END CLAVE_SESAS;

FUNCTION SUMA_ASEGURADA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                        cPlanCob VARCHAR2, cCodCobert VARCHAR2, TipoSuma VARCHAR2) RETURN VARCHAR2 IS
nSumaAsegMinima     COBERTURAS_DE_SEGUROS.SumaAsegMinima%TYPE;
nSumaAsegMaxima     COBERTURAS_DE_SEGUROS.SumaAsegMaxima%TYPE;
nSumaAsegMaxIndiv   COBERTURAS_DE_SEGUROS.SumaAsegMaxIndiv%TYPE;
BEGIN
   BEGIN
      SELECT NVL(SumaAsegMinima,0), NVL(SumaAsegMaxima,0), NVL(SumaAsegMaxIndiv,0)
        INTO nSumaAsegMinima, nSumaAsegMaxima, nSumaAsegMaxIndiv
        FROM COBERTURAS_DE_SEGUROS
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdTipoSeg      = cIdTipoSeg
         AND PlanCob        = cPlanCob
         AND CodCobert      = cCodCobert;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nSumaAsegMinima   := 0;
         nSumaAsegMaxima   := 0;
         nSumaAsegMaxIndiv := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Error en Configuración de Coberturas del Tipo de Seguro ' || cIdTipoSeg ||
                                 ' y Plan de Coberturas ' || cPlanCob);
   END;
   IF TipoSuma = 'MIN' THEN
      RETURN(nSumaAsegMinima);
   ELSIF TipoSuma = 'MAX' THEN
      RETURN(nSumaAsegMaxima);
   ELSIF TipoSuma = 'SAMI' THEN
      RETURN(nSumaAsegMaxIndiv);
   ELSE 
      RETURN(0);
   END IF;
END SUMA_ASEGURADA;

FUNCTION PERIODO_ESPERA_MESES(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                              cPlanCob VARCHAR2, cCodCobert VARCHAR2) RETURN NUMBER IS
nPeriodoesperaMeses         COBERTURAS_DE_SEGUROS.PeriodoesperaMeses%TYPE;
BEGIN
   BEGIN
      SELECT PeriodoesperaMeses
        INTO nPeriodoesperaMeses
        FROM COBERTURAS_DE_SEGUROS
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdTipoSeg      = cIdTipoSeg
         AND PlanCob        = cPlanCob
         AND CodCobert      = cCodCobert;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPeriodoesperaMeses  := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Error en Configuración de Coberturas para Periodo de Espera Meses del Tipo de Seguro ' || cIdTipoSeg ||
                                 ' Plan de Coberturas ' || cPlanCob || ' y Cobertura ' || cCodCobert);
   END;
   RETURN(nPeriodoesperaMeses);
END PERIODO_ESPERA_MESES;

FUNCTION VALIDA_BASICA (nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                              cCodCobert VARCHAR2) RETURN VARCHAR2 IS
cExiste  VARCHAR2(1);
BEGIN
    BEGIN
      SELECT 'S'
        INTO cExiste
        FROM COBERTURAS_DE_SEGUROS
       WHERE CodCia             = nCodCia
         AND CodEmpresa         = nCodEmpresa
         AND IdTipoSeg          = cIdTipoSeg
         AND PlanCob            = cPlanCob
         AND CodCobert          = cCodCobert
         AND Cobertura_Basica   = 'S';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END VALIDA_BASICA;

FUNCTION ORDEN_SESAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                     cPlanCob VARCHAR2, cCodCobert VARCHAR2) RETURN NUMBER IS
nOrdenSESAS         COBERTURAS_DE_SEGUROS.OrdenSESAS%TYPE;
BEGIN
   BEGIN
      SELECT NVL(OrdenSESAS,0)
        INTO nOrdenSESAS
        FROM COBERTURAS_DE_SEGUROS
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdTipoSeg      = cIdTipoSeg
         AND PlanCob        = cPlanCob
         AND CodCobert      = cCodCobert;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nOrdenSESAS  := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Error en Configuración de Coberturas para Orden en SESAS del Tipo de Seguro ' || cIdTipoSeg ||
                                 ' Plan de Coberturas ' || cPlanCob || ' y Cobertura ' || cCodCobert);
   END;
   RETURN(nOrdenSESAS);
END ORDEN_SESAS;

FUNCTION TIPO_TASA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                   cPlanCob VARCHAR2, cCodCobert VARCHAR2) RETURN NUMBER IS
nFactorTasa       NUMBER;
BEGIN
   BEGIN
      SELECT DECODE(TipoTasa,'C',100,DECODE(TipoTasa,'M',1000,1))
        INTO nFactorTasa
        FROM COBERTURAS_DE_SEGUROS
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdTipoSeg      = cIdTipoSeg
         AND PlanCob        = cPlanCob
         AND CodCobert      = cCodCobert;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nFactorTasa  := 1;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Error en Configuración de Coberturas para Tipo de Tasa del Tipo de Seguro ' || cIdTipoSeg ||
                                 ' Plan de Coberturas ' || cPlanCob || ' y Cobertura ' || cCodCobert);
   END;
   RETURN(nFactorTasa);
END TIPO_TASA;

FUNCTION REASEGURO_SINIESTROS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                              cCodCobert VARCHAR2) RETURN VARCHAR2 IS
cIndReaSiniestro         COBERTURAS_DE_SEGUROS.IndReaSiniestro%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndReaSiniestro,'N')
        INTO cIndReaSiniestro
        FROM COBERTURAS_DE_SEGUROS
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdTipoSeg      = cIdTipoSeg
         AND PlanCob        = cPlanCob
         AND CodCobert      = cCodCobert;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndReaSiniestro  := 'N';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Error en Configuración de Coberturas para Indicador de Reasguro en Siniestros del Tipo de Seguro ' || 
                                 cIdTipoSeg || ' Plan de Coberturas ' || cPlanCob || ' y Cobertura ' || cCodCobert);
   END;
   RETURN(cIndReaSiniestro);
END REASEGURO_SINIESTROS;

FUNCTION CANCELA_POLIZA_SINIESTRO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                                  cPlanCob VARCHAR2, cCodCobert VARCHAR2) RETURN VARCHAR2 IS
cIndCancPolSini    COBERTURAS_DE_SEGUROS.IndCancPolSini%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndCancPolSini,'N')
        INTO cIndCancPolSini
        FROM COBERTURAS_DE_SEGUROS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob
         AND CodCobert  = cCodCobert;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndCancPolSini := 'N';
   END;
   RETURN(cIndCancPolSini);
END CANCELA_POLIZA_SINIESTRO;

FUNCTION MOTIVO_CANCELA_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                               cPlanCob VARCHAR2, cCodCobert VARCHAR2) RETURN VARCHAR2 IS
cCodMotivCancelPol    COBERTURAS_DE_SEGUROS.CodMotivCancelPol%TYPE;
BEGIN
   BEGIN
      SELECT CodMotivCancelPol
        INTO cCodMotivCancelPol
        FROM COBERTURAS_DE_SEGUROS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob
         AND CodCobert  = cCodCobert;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodMotivCancelPol := NULL;
   END;
   RETURN(cCodMotivCancelPol);
END MOTIVO_CANCELA_POLIZA;

END OC_COBERTURAS_DE_SEGUROS;
/
