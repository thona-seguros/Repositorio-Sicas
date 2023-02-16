CREATE OR REPLACE PACKAGE          OC_ASEGURADO_CERTIFICADO IS

  PROCEDURE ACTUALIZA_VALORES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                              nIdetPol NUMBER, nCod_Asegurado NUMBER);
  PROCEDURE INSERTA (nCodCia NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER, nCod_Asegurado NUMBER, nIdEndoso NUMBER);
  FUNCTION EXISTE_ASEGURADO(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                            nCod_Asegurado NUMBER) RETURN VARCHAR2;
  FUNCTION EXISTE_ASEGURADO_CP(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                            nCod_Asegurado NUMBER, nIdEndoso NUMBER) RETURN VARCHAR2;
  FUNCTION SUMA_ASEGURADO(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                          nCod_Asegurado NUMBER, cCampo VARCHAR2) RETURN NUMBER;
  PROCEDURE ACTUALIZA_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                  nIDetPol NUMBER, nCod_Asegurado NUMBER);
  FUNCTION TIENE_ASEGURADOS(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER) RETURN VARCHAR2;

  PROCEDURE RENOVAR(nCodCia NUMBER, nIdPolizaRen NUMBER, nIdPoliza NUMBER);

  FUNCTION VALOR_CAMPO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                       nCod_Asegurado NUMBER, cCodPlantilla VARCHAR2, nOrdenProceso NUMBER,
                       cCodCampo VARCHAR2) RETURN VARCHAR2;

  PROCEDURE ANULAR(nCodCia NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER, nCod_Asegurado NUMBER,
                   dFecAnul DATE, cMotivAnul VARCHAR2);

  PROCEDURE EXCLUIR(nCodCia NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER, nCod_Asegurado NUMBER,
                    dFecExclu DATE, cMotivAnulExclu VARCHAR2);

  PROCEDURE EMITIR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER, nIdEndoso NUMBER);

  PROCEDURE REVERTIR_EMISION(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER, nIdEndoso NUMBER);

  PROCEDURE TRASLADA_ASEGURADO(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER, nIdEndoso NUMBER,
                               nIDetPolDest NUMBER);

  PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                     nCod_Asegurado NUMBER, nIdEndoso NUMBER);

  PROCEDURE COPIAR (nCodCia NUMBER, nIdPolizaOrig NUMBER, nIdetPolOrig NUMBER, nIdPolizaDest NUMBER, 
                    nIdetPolDest NUMBER);

  PROCEDURE REHABILITAR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER);

  FUNCTION STATUS_ASEGURADO(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) RETURN VARCHAR2;

  FUNCTION APORTE_FONDOS_ASEGURADO(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) RETURN NUMBER;
  
  PROCEDURE SUSPENDER(nCodCia NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER, nCod_Asegurado NUMBER,
                      dFecExclu DATE, cMotivAnulExclu VARCHAR2, nIdEndoso NUMBER);
   
   FUNCTION AJUSTE_SUMA_ASEG(nCodCia NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER, nCod_Asegurado NUMBER) RETURN VARCHAR2;
   
   FUNCTION SUMA_ASEGURADA(nCodCia NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER, nCod_Asegurado NUMBER) RETURN NUMBER;

END;
/

CREATE OR REPLACE PACKAGE BODY          OC_ASEGURADO_CERTIFICADO IS
--
--  MODIFICACION
--  30/05/2016  Se agrega la funcion EXISTE_ASEGURADO_CP para la emision de corto plazo         MAGO
--  27/06/2019  Se agrago el identificador de si la polizas es de fondos                  -- FONDO  ICO
--

PROCEDURE ACTUALIZA_VALORES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                            nIdetPol NUMBER, nCod_Asegurado NUMBER) IS
nSumaLocal    COBERTURAS.Suma_Asegurada_Local%TYPE;
nSumaMoneda   COBERTURAS.Suma_Asegurada_Moneda%TYPE;
nPrimaLocal   COBERTURAS.Prima_Local%TYPE;
nPrimaMoneda  COBERTURAS.Prima_Moneda%TYPE;
BEGIN
   SELECT NVL(SUM(SumaAseg_Local),0), NVL(SUM(SumaAseg_Moneda),0),
          NVL(SUM(Prima_Local),0), NVL(SUM(Prima_Moneda),0)
     INTO nSumaLocal, nSumaMoneda,
          nPrimaLocal, nPrimaMoneda
     FROM COBERT_ACT_ASEG
    WHERE CodCia         = nCodCia
      AND IdPoliza       = nIdPoliza
      AND IdetPol        = nIdetPol
      AND Cod_Asegurado  = nCod_Asegurado
      AND StsCobertura NOT IN ('ANU', 'CEX','SUS'); 

   UPDATE ASEGURADO_CERTIFICADO
      SET SumaAseg         = nSumaLocal,
          PrimaNeta        = nPrimaLocal,
          SumaAseg_Moneda  = nSumaMoneda,
          PrimaNeta_Moneda = nPrimaMoneda
    WHERE CodCia         = nCodCia
      AND IdPoliza       = nIdPoliza
      AND IdetPol        = nIdetPol
      AND Cod_Asegurado  = nCod_Asegurado;
EXCEPTION WHEN OTHERS THEN
  RAISE_APPLICATION_ERROR(-20225,' Error General en ACTUALIZA_VALORES : '||SQLERRM);
END ACTUALIZA_VALORES;

PROCEDURE INSERTA (nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER, nIdEndoso NUMBER) IS
BEGIN
   INSERT INTO ASEGURADO_CERTIFICADO
          (CodCia, Idpoliza, IDetpol, Cod_Asegurado, Estado, IdEndoso,
           MontoAporteAseg)
   VALUES (nCodCia, nIdpoliza, nIDetpol, nCod_Asegurado, 'SOL', nIdEndoso,
           0.00);
EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20225,'Ya Existe el Código de Asegurado: '||TRIM(TO_CHAR(nCod_Asegurado))||'En el Certificado:'||nIdetPol);
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20225,' Error Others en OC_ASEGURADO_CERTIFICADO.INSERTA : '||SQLERRM);
END INSERTA;

FUNCTION EXISTE_ASEGURADO(nCodCia NUMBER, nIdpoliza NUMBER, nIdetPol NUMBER, nCod_Asegurado NUMBER) RETURN VARCHAR2 IS
cExiste  VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM ASEGURADO_CERTIFICADO
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdpoliza
         AND IdetPol       = nIdetPol
         AND Cod_Asegurado = nCod_Asegurado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
  END;
  RETURN(cExiste);
END EXISTE_ASEGURADO;

FUNCTION EXISTE_ASEGURADO_CP(nCodCia NUMBER, nIdpoliza NUMBER, nIdetPol NUMBER, nCod_Asegurado NUMBER, nIdEndoso NUMBER) RETURN VARCHAR2 IS
cExiste  VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM ASEGURADO_CERTIFICADO
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdpoliza
         AND IdetPol       = nIdetPol
         AND IdEndoso      = nIdEndoso
         AND Cod_Asegurado = nCod_Asegurado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
  END;
  RETURN(cExiste);
END EXISTE_ASEGURADO_CP;

FUNCTION SUMA_ASEGURADO(nCodCia NUMBER, nIdpoliza NUMBER, nIdetPol NUMBER,
                        nCod_Asegurado NUMBER, cCampo VARCHAR2) RETURN NUMBER IS
nValor  NUMBER(14,2);
cValor  ASEGURADO_CERTIFICADO.CAMPO1%TYPE;
BEGIN
   BEGIN
      SELECT CAMPO1
        INTO cValor
        FROM ASEGURADO_CERTIFICADO
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdpoliza
         AND IdetPol       = nIdetPol
         AND Cod_Asegurado = nCod_Asegurado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cValor := '';
      WHEN TOO_MANY_ROWS THEN
         cValor := ' ';
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error en Asegurado Certificado Suma'||SQLERRM||nValor);
  END;

  nValor := TO_NUMBER(cValor,'999999.999999');

  RETURN(nValor);
END SUMA_ASEGURADO;

PROCEDURE ACTUALIZA_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                nIdetPol NUMBER, nCod_Asegurado NUMBER) IS
nMontoAsistLocal    ASISTENCIAS_ASEGURADO.MontoAsistLocal%TYPE;
nMontoAsistMoneda   ASISTENCIAS_ASEGURADO.MontoAsistMoneda%TYPE;
BEGIN
   SELECT NVL(SUM(MontoAsistLocal),0), NVL(SUM(MontoAsistMoneda),0)
     INTO nMontoAsistLocal, nMontoAsistMoneda
     FROM ASISTENCIAS_ASEGURADO
    WHERE CodCia          = nCodCia
      AND IdPoliza        = nIdPoliza
      AND IdetPol         = nIdetPol
      AND Cod_Asegurado   = nCod_Asegurado
      AND StsAsistencia NOT   IN ('EXCLUI','ANULAD');

   UPDATE ASEGURADO_CERTIFICADO
      SET PrimaNeta        = PrimaNeta + nMontoAsistLocal,
          PrimaNeta_Moneda = PrimaNeta_Moneda + nMontoAsistMoneda
    WHERE CodCia         = nCodCia
      AND IdPoliza       = nIdPoliza
      AND IdetPol        = nIdetPol
      AND Cod_Asegurado  = nCod_Asegurado;
EXCEPTION WHEN OTHERS THEN
  RAISE_APPLICATION_ERROR(-20225,'Error en ACTUALIZA_ASISTENCIAS '||SQLERRM);
END ACTUALIZA_ASISTENCIAS;

FUNCTION TIENE_ASEGURADOS(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER) RETURN VARCHAR2 IS
cExiste  VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM ASEGURADO_CERTIFICADO
       WHERE CodCia         = nCodCia
         AND IdPoliza       = nIdpoliza
         AND IdetPol        = nIdetPol
         AND (IdEndoso      = nIdEndoso
          OR  IdEndosoExclu = nIdEndoso);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
  END;
  RETURN(cExiste);
END TIENE_ASEGURADOS;

PROCEDURE RENOVAR(nCodCia NUMBER, nIdPolizaRen NUMBER, nIdPoliza NUMBER) IS
nCodEmpresa    POLIZAS.CodEmpresa%TYPE;

CURSOR ASEG_CERTIF_Q IS
   SELECT CodCia, IDetPol, Cod_Asegurado, Campo1, Campo2, Campo3, Campo4,
          Campo5, Campo6, Campo7, Campo8, Campo9, Campo10, Campo11,
          Campo12, Campo13, Campo14, Campo15, Campo16, Campo17, Campo18,
          Campo19, Campo20, Campo21, Campo22, Campo23, Campo24, Campo25,
          Campo26, Campo27, Campo28, Campo29, Campo30, Campo31, Campo32,
          Campo33, Campo34, Campo35, Campo36, Campo37, Campo38, Campo39,
          Campo40, Campo41, Campo42, Campo43, Campo44, Campo45, Campo46,
          Campo47, Campo48, Campo49, Campo50, Campo51, Campo52, Campo53,
          Campo54, Campo55, Campo56, Campo57, Campo58, Campo59, Campo60,
          Campo61, Campo62, Campo63, Campo64, Campo65, Campo66, Campo67,
          Campo68, Campo69, Campo70, Campo71, Campo72, Campo73, Campo74,
          Campo75, Campo76, Campo77, Campo78, Campo79, Campo80, Campo81,
          Campo82, Campo83, Campo84, Campo85, Campo86, Campo87, Campo88,
          Campo89, Campo90, Campo91, Campo92, Campo93, Campo94, Campo95,
          Campo96, Campo97, Campo98, Campo99, Campo100, SumaAseg, Primaneta,
          SumaAseg_Moneda, PrimaNeta_Moneda, MontoAporteAseg
     FROM ASEGURADO_CERTIFICADO
    WHERE IdPoliza = nIdPolizaRen
      AND CodCia   = nCodCia;
BEGIN
   SELECT NVL(MAX(CodEmpresa),1)
     INTO nCodEmpresa
     FROM POLIZAS
    WHERE CodCia    = nCodCia
      AND IdPoliza  = nIdPolizaRen;

   FOR P IN ASEG_CERTIF_Q LOOP
      INSERT INTO ASEGURADO_CERTIFICADO
             (CodCia, IdPoliza, IDetPol, Cod_Asegurado, Campo1, Campo2, Campo3, Campo4,
              Campo5, Campo6, Campo7, Campo8, Campo9, Campo10, Campo11,
              Campo12, Campo13, Campo14, Campo15, Campo16, Campo17, Campo18,
              Campo19, Campo20, Campo21, Campo22, Campo23, Campo24, Campo25,
              Campo26, Campo27, Campo28, Campo29, Campo30, Campo31, Campo32,
              Campo33, Campo34, Campo35, Campo36, Campo37, Campo38, Campo39,
              Campo40, Campo41, Campo42, Campo43, Campo44, Campo45, Campo46,
              Campo47, Campo48, Campo49, Campo50, Campo51, Campo52, Campo53,
              Campo54, Campo55, Campo56, Campo57, Campo58, Campo59, Campo60,
              Campo61, Campo62, Campo63, Campo64, Campo65, Campo66, Campo67,
              Campo68, Campo69, Campo70, Campo71, Campo72, Campo73, Campo74,
              Campo75, Campo76, Campo77, Campo78, Campo79, Campo80, Campo81,
              Campo82, Campo83, Campo84, Campo85, Campo86, Campo87, Campo88,
              Campo89, Campo90, Campo91, Campo92, Campo93, Campo94, Campo95,
              Campo96, Campo97, Campo98, Campo99, Campo100, SumaAseg, Primaneta,
              SumaAseg_Moneda, PrimaNeta_Moneda, Estado, MontoAporteAseg)
      VALUES (P.CodCia, nIdPoliza, P.IDetPol, P.Cod_Asegurado, P.Campo1, P.Campo2, P.Campo3, P.Campo4,
              P.Campo5, P.Campo6, P.Campo7, P.Campo8, P.Campo9, P.Campo10, P.Campo11,
              P.Campo12, P.Campo13, P.Campo14, P.Campo15, P.Campo16, P.Campo17, P.Campo18,
              P.Campo19, P.Campo20, P.Campo21, P.Campo22, P.Campo23, P.Campo24, P.Campo25,
              P.Campo26, P.Campo27, P.Campo28, P.Campo29, P.Campo30, P.Campo31, P.Campo32,
              P.Campo33, P.Campo34, P.Campo35, P.Campo36, P.Campo37, P.Campo38, P.Campo39,
              P.Campo40, P.Campo41, P.Campo42, P.Campo43, P.Campo44, P.Campo45, P.Campo46,
              P.Campo47, P.Campo48, P.Campo49, P.Campo50, P.Campo51, P.Campo52, P.Campo53,
              P.Campo54, P.Campo55, P.Campo56, P.Campo57, P.Campo58, P.Campo59, P.Campo60,
              P.Campo61, P.Campo62, P.Campo63, P.Campo64, P.Campo65, P.Campo66, P.Campo67,
              P.Campo68, P.Campo69, P.Campo70, P.Campo71, P.Campo72, P.Campo73, P.Campo74,
              P.Campo75, P.Campo76, P.Campo77, P.Campo78, P.Campo79, P.Campo80, P.Campo81,
              P.Campo82, P.Campo83, P.Campo84, P.Campo85, P.Campo86, P.Campo87, P.Campo88,
              P.Campo89, P.Campo90, P.Campo91, P.Campo92, P.Campo93, P.Campo94, P.Campo95,
              P.Campo96, P.Campo97, P.Campo98, P.Campo99, P.Campo100, P.SumaAseg,
              P.Primaneta, P.SumaAseg_Moneda, P.PrimaNeta_Moneda, 'XRE', P.MontoAporteAseg);
      GT_FAI_FONDOS_DETALLE_POLIZA.RENOVAR(nCodCia, nCodEmpresa, nIdPolizaRen, P.IDetPol, P.Cod_Asegurado, nIdPoliza);
   END LOOP;
END RENOVAR;

FUNCTION VALOR_CAMPO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                     nCod_Asegurado NUMBER, cCodPlantilla VARCHAR2, nOrdenProceso NUMBER,
                     cCodCampo VARCHAR2) RETURN VARCHAR2 IS
cValorCampo   VARCHAR2(500);
cQuery        VARCHAR2(4000);
cCampo        VARCHAR2(30);
BEGIN
   BEGIN
      SELECT 'CAMPO' || TRIM(TO_CHAR(OrdenDatoPart)) Campo
        INTO cCampo
        FROM CONFIG_PLANTILLAS_CAMPOS
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND CodPlantilla = cCodPlantilla
         AND OrdenProceso = nOrdenProceso
         AND NomCampo     = cCodCampo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20220,'NO Existe Campo  '|| cCodCampo || ' en Plantilla ' || cCodPlantilla ||
                                 ' para la Tabla con No. de Orden ' || nOrdenProceso);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Error en Configuración de Plantilla ' || cCodPlantilla ||
                                 ' Campo '|| cCodCampo || ' Duplicado');
   END;

   cQuery := 'SELECT ' || cCampo ||
             '  FROM ASEGURADO_CERTIFICADO ' ||
             ' WHERE CodCia        = ' || nCodCia ||
             '   AND IdPoliza      = ' || nIdPoliza ||
             '   AND IDetPol       = ' || nIDetPol ||
             '   AND Cod_Asegurado = ' || nCod_Asegurado;

   EXECUTE IMMEDIATE cQuery INTO cValorCampo;

   RETURN(cValorCampo);
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR (-20201, SQLERRM);
END VALOR_CAMPO;

PROCEDURE ANULAR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER,
                 dFecAnul DATE, cMotivAnul VARCHAR2) IS
nCodEmpresa    POLIZAS.CodEmpresa%TYPE;
nIdTipoSeg     DETALLE_POLIZA.IDTIPOSEG%TYPE;
--
CURSOR FONDO_Q IS
   SELECT CodEmpresa, IdFondo
     FROM FAI_FONDOS_DETALLE_POLIZA
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND CodAsegurado  = nCod_Asegurado;
BEGIN
  BEGIN  -- FONDO INICIO
    SELECT DP.IDTIPOSEG
      INTO nIdTipoSeg
      FROM DETALLE_POLIZA DP
     WHERE DP.IDPOLIZA = nIdPoliza
       AND DP.IDETPOL  = nIDetPol
       AND DP.CODCIA   = nCodCia;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN 
         nIdTipoSeg := '';
    WHEN OTHERS THEN 
         nIdTipoSeg := '';
  END;  -- FONDO FIN
  --
  IF OC_TIPOS_DE_SEGUROS.MANEJA_FONDOS(nCodCia, nCodEmpresa, nIdTipoSeg) = 'S' THEN -- FONDO
     IF cMotivAnul != 'REEX' THEN
        FOR W IN FONDO_Q LOOP
           GT_FAI_FONDOS_DETALLE_POLIZA.ANULAR(nCodCia, W.CodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado, W.IdFondo, dFecAnul);
        END LOOP;
     ELSE
        FOR W IN FONDO_Q LOOP
           nCodEmpresa := W.CodEmpresa;
           EXIT;
        END LOOP;
        GT_FAI_FONDOS_DETALLE_POLIZA.ANULAR_POR_REEXPEDICION(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado, dFecAnul);
     END IF;
  END IF; -- FONDO
  --
   UPDATE ASEGURADO_CERTIFICADO
      SET FecAnulExclu   = dFecAnul,
          MotivAnulExclu = cMotivAnul,
          Estado         = 'ANU'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado;
END ANULAR;

PROCEDURE EXCLUIR(nCodCia NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER, nCod_Asegurado NUMBER,
                  dFecExclu DATE, cMotivAnulExclu VARCHAR2) IS
nIdTipoSeg     DETALLE_POLIZA.IDTIPOSEG%TYPE;
nCodEmpresa    DETALLE_POLIZA.CODEMPRESA%TYPE;
--
CURSOR FONDO_Q IS
   SELECT CodEmpresa, IdFondo
     FROM FAI_FONDOS_DETALLE_POLIZA
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND CodAsegurado  = nCod_Asegurado;
BEGIN
  BEGIN  -- FONDO INICIO
    SELECT DP.IDTIPOSEG, DP.CODEMPRESA
      INTO nIdTipoSeg,   nCodEmpresa
      FROM DETALLE_POLIZA DP
     WHERE DP.IDPOLIZA = nIdPoliza
       AND DP.IDETPOL  = nIDetPol
       AND DP.CODCIA   = nCodCia;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN 
         nIdTipoSeg := '';
    WHEN OTHERS THEN 
         nIdTipoSeg := '';
  END;  -- FONDO FIN
  --
  IF OC_TIPOS_DE_SEGUROS.MANEJA_FONDOS(nCodCia, nCodEmpresa, nIdTipoSeg) = 'S' THEN -- FONDO
     FOR W IN FONDO_Q LOOP
         GT_FAI_FONDOS_DETALLE_POLIZA.ANULAR(nCodCia, W.CodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado, W.IdFondo, dFecExclu);
     END LOOP;
  END IF;  -- FONDO
  --
   UPDATE ASEGURADO_CERTIFICADO
      SET FecAnulExclu   = dFecExclu,
          MotivAnulExclu = cMotivAnulExclu,
          Estado         = 'CEX'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado;
END EXCLUIR;

PROCEDURE EMITIR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER, nIdEndoso NUMBER) IS
CURSOR FONDO_Q IS
   SELECT CodEmpresa, IdFondo
     FROM FAI_FONDOS_DETALLE_POLIZA
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND CodAsegurado  = nCod_Asegurado;
BEGIN
   --IF nIdEndoso <> 0 THEN
   FOR W IN FONDO_Q LOOP
      GT_FAI_FONDOS_DETALLE_POLIZA.EMITIR(nCodCia, W.CodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado, W.IdFondo);
   END LOOP;
   --END IF;

   UPDATE ASEGURADO_CERTIFICADO
      SET Estado        = 'EMI'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IdetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado
      AND IdEndoso      = nIdEndoso;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20220,'Error (OC_ASEGURADO_CERTIFICADO.EMITIR) al Actualizar Asegurado Certificado  ' || SQLERRM);
END EMITIR;

PROCEDURE REVERTIR_EMISION(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER, nIdEndoso NUMBER) IS
CURSOR FONDO_Q IS
   SELECT CodEmpresa, IdFondo
     FROM FAI_FONDOS_DETALLE_POLIZA
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND CodAsegurado  = nCod_Asegurado;
BEGIN
   IF nIdEndoso <> 0 THEN
      FOR W IN FONDO_Q LOOP
         GT_FAI_FONDOS_DETALLE_POLIZA.REVERTIR_EMISION(nCodCia, W.CodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado, W.IdFondo);
      END LOOP;
   END IF;

   UPDATE ASEGURADO_CERTIFICADO
      SET Estado        = 'SOL'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IdetPol       = nIDetPol
      AND IdEndoso      = nIdEndoso
      AND Cod_Asegurado = nCod_Asegurado;
END REVERTIR_EMISION;

PROCEDURE TRASLADA_ASEGURADO(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER, nIdEndoso NUMBER,
                             nIDetPolDest NUMBER) IS
nCod_AseguradoOrig   ASEGURADO_CERTIFICADO.Cod_Asegurado%TYPE;
cIdTipoSeg           DETALLE_POLIZA.IdTipoSeg%TYPE;
cPlanCob             DETALLE_POLIZA.PlanCob%TYPE;
nCodEmpresa          DETALLE_POLIZA.CodEmpresa%TYPE;
BEGIN
   BEGIN
      SELECT IdTipoSeg, PlanCob, CodEmpresa
        INTO cIdTipoSeg, cPlanCob, nCodEmpresa
        FROM DETALLE_POLIZA
       WHERE CodCia     = nCodCia
         AND IdPoliza   = nIdPoliza
         AND IDetPol    = nIDetPolDest;
   EXCEPTION
        WHEN NO_DATA_FOUND THEN
           RAISE_APPLICATION_ERROR(-20220,'NO existe Certificado o Detalle de Póliza Destino No. ' || nIDetPolDest);
   END;
   BEGIN
      INSERT INTO ASEGURADO_CERTIFICADO
            (CodCia, IdPoliza, IDetPol, Cod_Asegurado, Estado, SumaAseg,
             SumaAseg_Moneda, PrimaNeta, PrimaNeta_Moneda, IdEndoso,
             FecAnulExclu, MotivAnulExclu, Campo1, Campo2, Campo3, Campo4,
             Campo5, Campo6, Campo7, Campo8, Campo9, Campo10, Campo11,
             Campo12, Campo13, Campo14, Campo15, Campo16, Campo17, Campo18,
             Campo19, Campo20, Campo21, Campo22, Campo23, Campo24, Campo25,
             Campo26, Campo27, Campo28, Campo29, Campo30, Campo31, Campo32,
             Campo33, Campo34, Campo35, Campo36, Campo37, Campo38, Campo39,
             Campo40, Campo41, Campo42, Campo43, Campo44, Campo45, Campo46,
             Campo47, Campo48, Campo49, Campo50, Campo51, Campo52, Campo53,
             Campo54, Campo55, Campo56, Campo57, Campo58, Campo59, Campo60,
             Campo61, Campo62, Campo63, Campo64, Campo65, Campo66, Campo67,
             Campo68, Campo69, Campo70, Campo71, Campo72, Campo73, Campo74,
             Campo75, Campo76, Campo77, Campo78, Campo79, Campo80, Campo81,
             Campo82, Campo83, Campo84, Campo85, Campo86, Campo87, Campo88,
             Campo89, Campo90, Campo91, Campo92, Campo93, Campo94, Campo95,
             Campo96, Campo97, Campo98, Campo99, Campo100)
      SELECT CodCia, IdPoliza, nIDetPolDest, Cod_Asegurado, Estado, 0,
             0, 0, 0, IdEndoso,
             FecAnulExclu, MotivAnulExclu, Campo1, Campo2, Campo3, Campo4,
             Campo5, Campo6, Campo7, Campo8, Campo9, Campo10, Campo11,
             Campo12, Campo13, Campo14, Campo15, Campo16, Campo17, Campo18,
             Campo19, Campo20, Campo21, Campo22, Campo23, Campo24, Campo25,
             Campo26, Campo27, Campo28, Campo29, Campo30, Campo31, Campo32,
             Campo33, Campo34, Campo35, Campo36, Campo37, Campo38, Campo39,
             Campo40, Campo41, Campo42, Campo43, Campo44, Campo45, Campo46,
             Campo47, Campo48, Campo49, Campo50, Campo51, Campo52, Campo53,
             Campo54, Campo55, Campo56, Campo57, Campo58, Campo59, Campo60,
             Campo61, Campo62, Campo63, Campo64, Campo65, Campo66, Campo67,
             Campo68, Campo69, Campo70, Campo71, Campo72, Campo73, Campo74,
             Campo75, Campo76, Campo77, Campo78, Campo79, Campo80, Campo81,
             Campo82, Campo83, Campo84, Campo85, Campo86, Campo87, Campo88,
             Campo89, Campo90, Campo91, Campo92, Campo93, Campo94, Campo95,
             Campo96, Campo97, Campo98, Campo99, Campo100
        FROM ASEGURADO_CERTIFICADO
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND Cod_Asegurado = nCod_Asegurado
         AND IdEndoso      = nIdEndoso;
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20220,'Asegurado No. ' || nCod_Asegurado ||
                                 ' Ya existe en Certificado o Detalle de Póliza Destino No. ' || nIDetPolDest);
   END;

   SELECT NVL(MIN(Cod_Asegurado),0)
     INTO nCod_AseguradoOrig
     FROM ASEGURADO_CERTIFICADO
    WHERE CodCia     = nCodCia
      AND IdPoliza   = nIdPoliza
      AND IDetPol    = nIDetPolDest;

   IF nCod_AseguradoOrig != 0 THEN
      OC_COBERT_ACT_ASEG.HEREDA_COBERTURAS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPolDest, nCod_AseguradoOrig, cIdTipoSeg, cPlanCob);
      OC_ASISTENCIAS_ASEGURADO.HEREDA_ASISTENCIAS(nCodCia, nCodEmpresa, nIdPoliza, nIdetPolDest, nCod_AseguradoOrig, cIdTipoSeg, cPlanCob);
   END IF;
   GT_FAI_FONDOS_DETALLE_POLIZA.TRASLADA_FONDOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado, nIDetPolDest);
   OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, nIdetPolDest, 0);
   OC_POLIZAS.ACTUALIZA_VALORES(nCodCia, nIdPoliza, 0);
END TRASLADA_ASEGURADO;

PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                   nIDetPol NUMBER, nCod_Asegurado NUMBER, nIdEndoso NUMBER) IS
CURSOR FONDO_Q IS
   SELECT CodEmpresa, IdFondo
     FROM FAI_FONDOS_DETALLE_POLIZA
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND CodAsegurado  = nCod_Asegurado;
BEGIN
   OC_COBERT_ACT_ASEG.ELIMINAR(nCodCia, nIdPoliza, nIDetPol, nCod_Asegurado, nIdEndoso);
   OC_ASISTENCIAS_ASEGURADO.ELIMINAR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado, nIdEndoso);

   FOR W IN FONDO_Q LOOP
      GT_FAI_FONDOS_DETALLE_POLIZA.ELIMINA_FONDO(W.IdFondo);
   END LOOP;

   DELETE ASEGURADO_CERTIFICADO
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado
      AND IdEndoso      = nIdEndoso;
END ELIMINAR;

PROCEDURE COPIAR (nCodCia NUMBER, nIdPolizaOrig NUMBER, nIdetPolOrig NUMBER, nIdPolizaDest NUMBER,
                  nIdetPolDest NUMBER) IS
nCodEmpresa          DETALLE_POLIZA.CodEmpresa%TYPE;

CURSOR ASEG_CERTIF_Q IS
   SELECT CodCia, IdPoliza, Cod_Asegurado, Campo1, Campo2, Campo3, Campo4,
              Campo5, Campo6, Campo7, Campo8, Campo9, Campo10, Campo11,
              Campo12, Campo13, Campo14, Campo15, Campo16, Campo17, Campo18,
              Campo19, Campo20, Campo21, Campo22, Campo23, Campo24, Campo25,
              Campo26, Campo27, Campo28, Campo29, Campo30, Campo31, Campo32,
              Campo33, Campo34, Campo35, Campo36, Campo37, Campo38, Campo39,
              Campo40, Campo41, Campo42, Campo43, Campo44, Campo45, Campo46,
              Campo47, Campo48, Campo49, Campo50, Campo51, Campo52, Campo53,
              Campo54, Campo55, Campo56, Campo57, Campo58, Campo59, Campo60,
              Campo61, Campo62, Campo63, Campo64, Campo65, Campo66, Campo67,
              Campo68, Campo69, Campo70, Campo71, Campo72, Campo73, Campo74,
              Campo75, Campo76, Campo77, Campo78, Campo79, Campo80, Campo81,
              Campo82, Campo83, Campo84, Campo85, Campo86, Campo87, Campo88,
              Campo89, Campo90, Campo91, Campo92, Campo93, Campo94, Campo95,
              Campo96, Campo97, Campo98, Campo99, Campo100, SumaAseg, Primaneta,
              SumaAseg_Moneda, PrimaNeta_Moneda, MontoAporteAseg
     FROM ASEGURADO_CERTIFICADO
    WHERE IDetPol  = nIDetPolOrig
      AND IdPoliza = nIdPolizaOrig
      AND CodCia   = nCodCia;
BEGIN
   SELECT NVL(MAX(CodEmpresa),1)
     INTO nCodEmpresa
     FROM POLIZAS
    WHERE CodCia    = nCodCia
      AND IdPoliza  = nIdPolizaOrig;

   FOR P IN ASEG_CERTIF_Q LOOP
      INSERT INTO ASEGURADO_CERTIFICADO
             (CodCia, IdPoliza, IDetPol, Cod_Asegurado, Campo1, Campo2, Campo3, Campo4,
              Campo5, Campo6, Campo7, Campo8, Campo9, Campo10, Campo11,
              Campo12, Campo13, Campo14, Campo15, Campo16, Campo17, Campo18,
              Campo19, Campo20, Campo21, Campo22, Campo23, Campo24, Campo25,
              Campo26, Campo27, Campo28, Campo29, Campo30, Campo31, Campo32,
              Campo33, Campo34, Campo35, Campo36, Campo37, Campo38, Campo39,
              Campo40, Campo41, Campo42, Campo43, Campo44, Campo45, Campo46,
              Campo47, Campo48, Campo49, Campo50, Campo51, Campo52, Campo53,
              Campo54, Campo55, Campo56, Campo57, Campo58, Campo59, Campo60,
              Campo61, Campo62, Campo63, Campo64, Campo65, Campo66, Campo67,
              Campo68, Campo69, Campo70, Campo71, Campo72, Campo73, Campo74,
              Campo75, Campo76, Campo77, Campo78, Campo79, Campo80, Campo81,
              Campo82, Campo83, Campo84, Campo85, Campo86, Campo87, Campo88,
              Campo89, Campo90, Campo91, Campo92, Campo93, Campo94, Campo95,
              Campo96, Campo97, Campo98, Campo99, Campo100, SumaAseg, Primaneta, Estado,
              IdEndoso, SumaAseg_Moneda, PrimaNeta_Moneda, IdEndosoExclu, MontoAporteAseg)
      VALUES (P.CodCia, nIdPolizaDest, nIDetPolDest, P.Cod_Asegurado, P.Campo1, P.Campo2, P.Campo3, P.Campo4,
              P.Campo5, P.Campo6, P.Campo7, P.Campo8, P.Campo9, P.Campo10, P.Campo11,
              P.Campo12, P.Campo13, P.Campo14, P.Campo15, P.Campo16, P.Campo17, P.Campo18,
              P.Campo19, P.Campo20, P.Campo21, P.Campo22, P.Campo23, P.Campo24, P.Campo25,
              P.Campo26, P.Campo27, P.Campo28, P.Campo29, P.Campo30, P.Campo31, P.Campo32,
              P.Campo33, P.Campo34, P.Campo35, P.Campo36, P.Campo37, P.Campo38, P.Campo39,
              P.Campo40, P.Campo41, P.Campo42, P.Campo43, P.Campo44, P.Campo45, P.Campo46,
              P.Campo47, P.Campo48, P.Campo49, P.Campo50, P.Campo51, P.Campo52, P.Campo53,
              P.Campo54, P.Campo55, P.Campo56, P.Campo57, P.Campo58, P.Campo59, P.Campo60,
              P.Campo61, P.Campo62, P.Campo63, P.Campo64, P.Campo65, P.Campo66, P.Campo67,
              P.Campo68, P.Campo69, P.Campo70, P.Campo71, P.Campo72, P.Campo73, P.Campo74,
              P.Campo75, P.Campo76, P.Campo77, P.Campo78, P.Campo79, P.Campo80, P.Campo81,
              P.Campo82, P.Campo83, P.Campo84, P.Campo85, P.Campo86, P.Campo87, P.Campo88,
              P.Campo89, P.Campo90, P.Campo91, P.Campo92, P.Campo93, P.Campo94, P.Campo95,
              P.Campo96, P.Campo97, P.Campo98, P.Campo99, P.Campo100, P.SumaAseg, P.Primaneta, 'SOL',
              0, P.SumaAseg_Moneda, P.PrimaNeta_Moneda, 0, P.MontoAporteAseg);

      OC_BENEFICIARIO.COPIAR(nIdPolizaOrig, nIDetPolOrig, P.Cod_Asegurado,
                             nIdPolizaDest, nIDetPolDest, P.Cod_Asegurado);
      GT_FAI_FONDOS_DETALLE_POLIZA.COPIAR_FONDOS(nCodCia, nCodEmpresa, nIdPolizaOrig, nIDetPolOrig, P.Cod_Asegurado, nIdPolizaDest);
   END LOOP;
END COPIAR;

PROCEDURE REHABILITAR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) IS
BEGIN
   UPDATE ASEGURADO_CERTIFICADO
      SET FecAnulExclu   = NULL,
          MotivAnulExclu = NULL,
          IdEndosoExclu  = NULL,
          Estado         = 'EMI'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado
      AND Estado       IN ('ANU','SUS');
END REHABILITAR;

FUNCTION STATUS_ASEGURADO(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) RETURN VARCHAR2 IS
cEstado     ASEGURADO_CERTIFICADO.Estado%TYPE;
BEGIN
   BEGIN
      SELECT Estado
        INTO cEstado
        FROM ASEGURADO_CERTIFICADO
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdpoliza
         AND IdetPol       = nIdetPol
         AND Cod_Asegurado = nCod_Asegurado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cEstado := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Asegurado No. ' || nCod_Asegurado ||
                                 ' Duplicado en Póliza No. ' || nIdPoliza || ' y Detalle/SubGrupo ' || nIDetPol);
  END;
  RETURN(cEstado);
END STATUS_ASEGURADO;

FUNCTION APORTE_FONDOS_ASEGURADO(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) RETURN NUMBER IS
nMontoAporteAseg     ASEGURADO_CERTIFICADO.MontoAporteAseg%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MontoAporteAseg,0)
        INTO nMontoAporteAseg
        FROM ASEGURADO_CERTIFICADO
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND Cod_Asegurado = nCod_Asegurado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nMontoAporteAseg := 0;
   END;
   RETURN(nMontoAporteAseg);
END APORTE_FONDOS_ASEGURADO;

PROCEDURE SUSPENDER(nCodCia NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER, nCod_Asegurado NUMBER,
                    dFecExclu DATE, cMotivAnulExclu VARCHAR2, nIdEndoso NUMBER) IS
CURSOR FONDO_Q IS
   SELECT CodEmpresa, IdFondo
     FROM FAI_FONDOS_DETALLE_POLIZA
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND CodAsegurado  = nCod_Asegurado;
BEGIN
   FOR W IN FONDO_Q LOOP
      NULL;--GT_FAI_FONDOS_DETALLE_POLIZA.ANULAR(nCodCia, W.CodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado, W.IdFondo, dFecExclu);
   END LOOP;

   UPDATE ASEGURADO_CERTIFICADO
      SET FecAnulExclu   = dFecExclu,
          MotivAnulExclu = cMotivAnulExclu,
          Estado         = 'SUS',
          IdEndosoExclu  = nIdEndoso
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado;
END SUSPENDER;

FUNCTION AJUSTE_SUMA_ASEG(nCodCia NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER, nCod_Asegurado NUMBER) RETURN VARCHAR2 IS
cIndAjuSumaAsegDecl ASEGURADO_CERTIFICADO.IndAjuSumaAsegDecl%TYPE; 
BEGIN
   BEGIN
      SELECT NVL(IndAjuSumaAsegDecl,'N')
        INTO cIndAjuSumaAsegDecl
        FROM ASEGURADO_CERTIFICADO
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND Cod_Asegurado = nCod_Asegurado;
   EXCEPTION 
      WHEN NO_DATA_FOUND THEN 
         RAISE_APPLICATION_ERROR(-20220,'No es Posible determinar el Asegurado No. ' || nCod_Asegurado || 
                                 ' en Póliza No. ' || nIdPoliza || ' y Detalle/SubGrupo ' || nIDetPol);
   END;
   RETURN cIndAjuSumaAsegDecl;
END AJUSTE_SUMA_ASEG;

FUNCTION SUMA_ASEGURADA(nCodCia NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER, nCod_Asegurado NUMBER) RETURN NUMBER IS
nSumaAseg ASEGURADO_CERTIFICADO.SumaAseg%TYPE;
BEGIN
   BEGIN
      SELECT NVL(SumaAseg,0)
        INTO nSumaAseg
        FROM ASEGURADO_CERTIFICADO
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND Cod_Asegurado = nCod_Asegurado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN 
         nSumaAseg := 0;
   END;
   RETURN nSumaAseg;
END SUMA_ASEGURADA;

END OC_ASEGURADO_CERTIFICADO;
