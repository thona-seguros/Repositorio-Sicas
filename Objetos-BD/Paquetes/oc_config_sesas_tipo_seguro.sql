--
-- OC_CONFIG_SESAS_TIPO_SEGURO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   CONFIG_SESAS_TIPO_SEGURO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CONFIG_SESAS_TIPO_SEGURO IS
PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cIdTipoSegDest VARCHAR2);
FUNCTION CLASE_SEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2;
FUNCTION TIPO_SEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2;
FUNCTION PERIODO_ESPERA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN NUMBER;
FUNCTION INICIO_COBERTURA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN NUMBER;
FUNCTION DIAS_BENEFICIO_3(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN NUMBER;
FUNCTION SUBTIPO_SEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2;
FUNCTION TIPO_RIESGO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cTipoRiesgoSesa VARCHAR2) RETURN VARCHAR2;
FUNCTION COBERTURA_AFECTADA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2;
FUNCTION MODALIDAD(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cTipoModalidad VARCHAR2) RETURN VARCHAR2;
FUNCTION DEDUCIBLE(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN NUMBER;
FUNCTION COASEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN NUMBER;
FUNCTION EXISTE_CONFIG_SESAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2;
END OC_CONFIG_SESAS_TIPO_SEGURO;
/

--
-- OC_CONFIG_SESAS_TIPO_SEGURO  (Package Body) 
--
--  Dependencies: 
--   OC_CONFIG_SESAS_TIPO_SEGURO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.oc_config_sesas_tipo_seguro IS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cIdTipoSegDest VARCHAR2) IS
CURSOR SESAS_Q IS
  SELECT CodCia, CodEmpresa, IdTipoSeg, ClaseSeguro, TipoSeguro,
         PeriodoEspera, InicioCobertura, MaxDiasBenef3, SubTipoSeg,
         TipoRiesgo, TipoRiesgoAsoc, CobertAfectada, ModalSumaAseg,
         ModalPoliza, MtoDeducible, MtoCoaseguro
    FROM CONFIG_SESAS_TIPO_SEGURO
   WHERE CodCia     = nCodCia
     AND CodEmpresa = nCodEmpresa
     AND IdTipoSeg  = cIdTipoSegOrig;
BEGIN
   FOR X IN SESAS_Q LOOP
      INSERT INTO CONFIG_SESAS_TIPO_SEGURO
             (CodCia, CodEmpresa, IdTipoSeg, ClaseSeguro, TipoSeguro,
              PeriodoEspera, InicioCobertura, MaxDiasBenef3, SubTipoSeg,
              TipoRiesgo, TipoRiesgoAsoc, CobertAfectada, ModalSumaAseg,
              ModalPoliza, MtoDeducible, MtoCoaseguro, CodUsuario, FecUltCambio)
      VALUES (X.CodCia, X.CodEmpresa, cIdTipoSegDest, X.ClaseSeguro, X.TipoSeguro,
              X.PeriodoEspera, X.InicioCobertura, X.MaxDiasBenef3, X.SubTipoSeg,
              X.TipoRiesgo, X.TipoRiesgoAsoc, X.CobertAfectada, X.ModalSumaAseg,
              X.ModalPoliza, X.MtoDeducible, X.MtoCoaseguro, USER, SYSDATE);
   END LOOP;
END COPIAR;

FUNCTION CLASE_SEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2 IS
cClaseSeguro     CONFIG_SESAS_TIPO_SEGURO.ClaseSeguro%TYPE;
BEGIN
   BEGIN
      SELECT ClaseSeguro
        INTO cClaseSeguro
        FROM CONFIG_SESAS_TIPO_SEGURO
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cClaseSeguro := 'NA';
   END;
   RETURN(cClaseSeguro);
END CLASE_SEGURO;

FUNCTION TIPO_SEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2 IS
cTipoSeguro     CONFIG_SESAS_TIPO_SEGURO.TipoSeguro%TYPE;
BEGIN
   BEGIN
      SELECT TipoSeguro
        INTO cTipoSeguro
        FROM CONFIG_SESAS_TIPO_SEGURO
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTipoSeguro := 'I';
   END;
   RETURN(cTipoSeguro);
END TIPO_SEGURO;

FUNCTION PERIODO_ESPERA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN NUMBER IS
nPeriodoEspera     CONFIG_SESAS_TIPO_SEGURO.PeriodoEspera%TYPE;
BEGIN
   BEGIN
      SELECT PeriodoEspera
        INTO nPeriodoEspera
        FROM CONFIG_SESAS_TIPO_SEGURO
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPeriodoEspera := 0;
   END;
   RETURN(nPeriodoEspera);
END PERIODO_ESPERA;

FUNCTION INICIO_COBERTURA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN NUMBER IS
nInicioCobertura     CONFIG_SESAS_TIPO_SEGURO.InicioCobertura%TYPE;
BEGIN
   BEGIN
      SELECT InicioCobertura
        INTO nInicioCobertura
        FROM CONFIG_SESAS_TIPO_SEGURO
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nInicioCobertura := 0;
   END;
   RETURN(nInicioCobertura);
END INICIO_COBERTURA;

FUNCTION DIAS_BENEFICIO_3(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN NUMBER IS
nMaxDiasBenef3     CONFIG_SESAS_TIPO_SEGURO.MaxDiasBenef3%TYPE;
BEGIN
   BEGIN
      SELECT MaxDiasBenef3
        INTO nMaxDiasBenef3
        FROM CONFIG_SESAS_TIPO_SEGURO
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nMaxDiasBenef3 := 0;
   END;
   RETURN(nMaxDiasBenef3);
END DIAS_BENEFICIO_3;

FUNCTION SUBTIPO_SEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2 IS
cSubTipoSeg     CONFIG_SESAS_TIPO_SEGURO.SubTipoSeg%TYPE;
BEGIN
   BEGIN
      SELECT SubTipoSeg
        INTO cSubTipoSeg
        FROM CONFIG_SESAS_TIPO_SEGURO
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cSubTipoSeg := '1';
   END;
   RETURN(cSubTipoSeg);
END SUBTIPO_SEGURO;

FUNCTION TIPO_RIESGO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cTipoRiesgoSesa VARCHAR2) RETURN VARCHAR2 IS
cTipoRiesgo      CONFIG_SESAS_TIPO_SEGURO.TipoRiesgo%TYPE;
cTipoRiesgoAsoc  CONFIG_SESAS_TIPO_SEGURO.TipoRiesgoAsoc%TYPE;
BEGIN
   BEGIN
      SELECT TipoRiesgo, TipoRiesgoAsoc
        INTO cTipoRiesgo, cTipoRiesgoAsoc
        FROM CONFIG_SESAS_TIPO_SEGURO
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTipoRiesgo     := '1';
         cTipoRiesgoAsoc := '1';
   END;
   IF cTipoRiesgoSesa = 'TRN' THEN
      RETURN(cTipoRiesgo);
   ELSIF cTipoRiesgoSesa = 'TRA' THEN
      RETURN(cTipoRiesgoAsoc);
   END IF;  
END TIPO_RIESGO;

FUNCTION COBERTURA_AFECTADA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2 IS
cCobertAfectada     CONFIG_SESAS_TIPO_SEGURO.CobertAfectada%TYPE;
BEGIN
   BEGIN
      SELECT CobertAfectada
        INTO cCobertAfectada
        FROM CONFIG_SESAS_TIPO_SEGURO
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCobertAfectada := '1';
   END;
   RETURN(cCobertAfectada);
END COBERTURA_AFECTADA;

FUNCTION MODALIDAD(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cTipoModalidad VARCHAR2) RETURN VARCHAR2 IS
cModalSumaAseg    CONFIG_SESAS_TIPO_SEGURO.ModalSumaAseg%TYPE;
cModalPoliza      CONFIG_SESAS_TIPO_SEGURO.ModalPoliza%TYPE;
BEGIN
   BEGIN
      SELECT ModalSumaAseg, ModalPoliza
        INTO cModalSumaAseg, cModalPoliza
        FROM CONFIG_SESAS_TIPO_SEGURO
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cModalSumaAseg  := 'N';
         cModalPoliza    := '1';
   END;
   IF cTipoModalidad = 'MSA' THEN
      RETURN(cModalSumaAseg);
   ELSIF cTipoModalidad = 'MPO' THEN
      RETURN(cModalPoliza);
   END IF;  
END MODALIDAD;

FUNCTION DEDUCIBLE(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN NUMBER IS
nMtoDeducible     CONFIG_SESAS_TIPO_SEGURO.MtoDeducible%TYPE;
BEGIN
   BEGIN
      SELECT MtoDeducible
        INTO nMtoDeducible
        FROM CONFIG_SESAS_TIPO_SEGURO
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nMtoDeducible := 0;
   END;
   RETURN(nMtoDeducible);
END DEDUCIBLE;

FUNCTION COASEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN NUMBER IS
nMtoCoaseguro    CONFIG_SESAS_TIPO_SEGURO.MtoCoaseguro%TYPE;
BEGIN
   BEGIN
      SELECT MtoCoaseguro
        INTO nMtoCoaseguro
        FROM CONFIG_SESAS_TIPO_SEGURO
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nMtoCoaseguro := 0;
   END;
   RETURN(nMtoCoaseguro);
END COASEGURO;

FUNCTION EXISTE_CONFIG_SESAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2 IS
cConfSesas     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cConfSesas
        FROM CONFIG_SESAS_TIPO_SEGURO
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cConfSesas := 'N';
      WHEN TOO_MANY_ROWS THEN
         cConfSesas := 'S';
   END;
   RETURN(cConfSesas);
END EXISTE_CONFIG_SESAS;

END OC_CONFIG_SESAS_TIPO_SEGURO;
/
