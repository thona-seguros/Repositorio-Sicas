--
-- OC_TIPOS_DE_SEGUROS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   OC_AGENTES_TIPOS_SEGUROS (Package)
--   PLAN_COBERTURAS (Table)
--   OC_CONFIG_RESERVAS_PLANCOB (Package)
--   OC_CONFIG_RESERVAS_TIPOSEG (Package)
--   OC_CONFIG_RETEN_CANCELACION (Package)
--   OC_CONFIG_RETEN_CANCEL_MOTIV (Package)
--   OC_CONFIG_SESAS_TIPO_SEGURO (Package)
--   OC_CONF_DATPART_EMISION (Package)
--   OC_CONF_DATPART_SINIESTROS (Package)
--   OC_PLANTILLAS_CONTABLES (Package)
--   OC_PLAN_COBERTURAS (Package)
--   OC_REQUISITOS_SEGUROS (Package)
--   TIPOS_DE_SEGUROS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_TIPOS_DE_SEGUROS IS

  FUNCTION PLAN_PAGOS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2;
  
  FUNCTION TIPO_DE_SEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2;
  
  PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                   cIdTipoSegDest VARCHAR2, cDescripDest VARCHAR2, cIndReservas VARCHAR2,
                   cCodReservaDest VARCHAR2, cIndPlantillas VARCHAR2, cIndAgentes VARCHAR2);
  FUNCTION EXISTE_TIPO_DE_SEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2;

  FUNCTION TIPO_CONTABILIDAD(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2;
  
  FUNCTION CODIGO_RAMO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2;
  
  FUNCTION DIAS_CANCELACION(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN NUMBER;
  
  FUNCTION CLAVE_FACT_ELECTRONICA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2;
  
  FUNCTION MANEJA_FONDOS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2;
  
  FUNCTION ES_PRODUCTO_ALTO(cIdTipoSeg VARCHAR2) RETURN VARCHAR2;
  
  FUNCTION ES_PRODUCTO_LARGO_PLAZO(cIdTipoSeg VARCHAR2) RETURN VARCHAR2;  
  
END OC_TIPOS_DE_SEGUROS;
/

--
-- OC_TIPOS_DE_SEGUROS  (Package Body) 
--
--  Dependencies: 
--   OC_TIPOS_DE_SEGUROS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_TIPOS_DE_SEGUROS IS
--
-- CALCULO DEL AÑO POLIZA DE RECIBOS Y NOTAS DE CREDITO                      2019/03/27  ICO LARPLA
--
FUNCTION PLAN_PAGOS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2 IS
cCodPlanPago    TIPOS_DE_SEGUROS.CodPlanPago%TYPE;
BEGIN
   BEGIN
      SELECT NVL(CodPlanPago,'0001')
        INTO cCodPlanPago
        FROM TIPOS_DE_SEGUROS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Tipo de Seguro: '||TRIM(cIdTipoSeg)||' Para Compañía '||TRIM(TO_CHAR(nCodCia))||
                                 ' y la Empresa '||TRIM(TO_CHAR(nCodEmpresa)));
   END;
   RETURN(cCodPlanPago);
END PLAN_PAGOS;

FUNCTION TIPO_DE_SEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2 IS
cDescSeg  VARCHAR2(200);
BEGIN
   BEGIN
      SELECT Descripcion
        INTO cDescSeg
        FROM TIPOS_DE_SEGUROS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescSeg := 'NO EXISTE';
   END;
   RETURN(cDescSeg);
END TIPO_DE_SEGURO;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                 cIdTipoSegDest VARCHAR2, cDescripDest VARCHAR2, cIndReservas VARCHAR2,
                 cCodReservaDest VARCHAR2, cIndPlantillas VARCHAR2, cIndAgentes VARCHAR2) IS
CURSOR TIPOSEG_Q IS
  SELECT TipoSeg, IdPlantilla, CodTipoPlan, DiasCancelacion,
         CodPlanPago, IndRenovAut, TipoContabilidad,
         ClaveFactElect, IndManejaFondos
    FROM TIPOS_DE_SEGUROS
   WHERE CodCia     = nCodCia
     AND CodEmpresa = nCodEmpresa
     AND IdTipoSeg  = cIdTipoSegOrig;
CURSOR PLANCOB_Q IS
  SELECT PlanCob, Desc_Plan
    FROM PLAN_COBERTURAS
   WHERE CodCia     = nCodCia
     AND CodEmpresa = nCodEmpresa
     AND IdTipoSeg  = cIdTipoSegOrig;
BEGIN
   FOR X IN TIPOSEG_Q LOOP
      INSERT INTO TIPOS_DE_SEGUROS
             (CodCia, CodEmpresa, IdTipoSeg, Descripcion, StsTipSeg, FecSts,
              TipoSeg, IdPlantilla, CodTipoPlan, CodPlanPago, IndRenovAut,
              TipoContabilidad, DiasCancelacion, ClaveFactElect, IndManejaFondos)
      VALUES (nCodCia, nCodEmpresa, cIdTipoSegDest, cDescripDest, 'ACT', TRUNC(SYSDATE),
              X.TipoSeg, X.IdPlantilla, X.CodTipoPlan, X.CodPlanPago, X.IndRenovAut,
              X.TipoContabilidad, X.DiasCancelacion, X.ClaveFactElect, X.IndManejaFondos);

      FOR W IN PLANCOB_Q LOOP
         OC_PLAN_COBERTURAS.COPIAR(nCodCia, nCodEmpresa, cIdTipoSegOrig, W.PlanCob,
                                   cIdTipoSegDest, W.PlanCob, W.Desc_Plan,
                                   'N', cCodReservaDest);
      END LOOP;

      OC_REQUISITOS_SEGUROS.COPIAR(nCodCia, nCodEmpresa, cIdTipoSegOrig, cIdTipoSegDest);
      OC_CONF_DATPART_EMISION.COPIAR(nCodCia, nCodEmpresa, cIdTipoSegOrig, cIdTipoSegDest);
      OC_CONF_DATPART_SINIESTROS.COPIAR(nCodCia, nCodEmpresa, cIdTipoSegOrig, cIdTipoSegDest);
      IF cIndReservas = 'S' THEN
         OC_CONFIG_RESERVAS_TIPOSEG.AGREGAR(nCodCia, nCodEmpresa, cCodReservaDest,
                                            cIdTipoSegOrig, cIdTipoSegDest);
         FOR W IN PLANCOB_Q LOOP
            OC_CONFIG_RESERVAS_PLANCOB.AGREGAR(nCodCia, cCodReservaDest, nCodEmpresa, cIdTipoSegOrig,
                                               W.PlanCob, cIdTipoSegDest, W.PlanCob);
         END LOOP;
      END IF;

      IF cIndPlantillas = 'S' THEN
         OC_PLANTILLAS_CONTABLES.COPIAR_PLANTILLA(nCodCia, nCodEmpresa, cIdTipoSegOrig, cIdTipoSegDest);
      END IF;

      IF cIndAgentes = 'S' THEN
         OC_AGENTES_TIPOS_SEGUROS.COPIAR_TIPO_SEGURO(nCodCia, nCodEmpresa, cIdTipoSegOrig, cIdTipoSegDest);
      END IF;

      OC_CONFIG_RETEN_CANCELACION.COPIAR(nCodCia, nCodEmpresa, cIdTipoSegOrig, cIdTipoSegDest);
      OC_CONFIG_RETEN_CANCEL_MOTIV.COPIAR(nCodCia, nCodEmpresa, cIdTipoSegOrig, cIdTipoSegDest);
      OC_CONFIG_SESAS_TIPO_SEGURO.COPIAR(nCodCia, nCodEmpresa, cIdTipoSegOrig, cIdTipoSegDest);
   END LOOP;
END COPIAR;

FUNCTION EXISTE_TIPO_DE_SEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2 IS
cExiste  VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM TIPOS_DE_SEGUROS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END EXISTE_TIPO_DE_SEGURO;

FUNCTION TIPO_CONTABILIDAD(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2 IS
cTipoContabilidad    TIPOS_DE_SEGUROS.TipoContabilidad%TYPE;
BEGIN
   BEGIN
      SELECT TipoContabilidad
        INTO cTipoContabilidad
        FROM TIPOS_DE_SEGUROS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Tipo de Seguro: '||TRIM(cIdTipoSeg)||' Para Compañía '||TRIM(TO_CHAR(nCodCia))||
                                 ' y la Empresa '||TRIM(TO_CHAR(nCodEmpresa)));
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Tipos de Seguros: '||TRIM(cIdTipoSeg)||' Para Compañía '||TRIM(TO_CHAR(nCodCia))||
                                 ' y la Empresa '||TRIM(TO_CHAR(nCodEmpresa)));
   END;
   RETURN(cTipoContabilidad);
END TIPO_CONTABILIDAD;

FUNCTION CODIGO_RAMO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2 IS
cCodTipoPlan    TIPOS_DE_SEGUROS.CodTipoPlan%TYPE;
BEGIN
   BEGIN
      SELECT CodTipoPlan
        INTO cCodTipoPlan
        FROM TIPOS_DE_SEGUROS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodTipoPlan := NULL;
   END;
   RETURN(cCodTipoPlan);
END CODIGO_RAMO;

FUNCTION DIAS_CANCELACION(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN NUMBER IS
nDiasCancelacion    TIPOS_DE_SEGUROS.DiasCancelacion%TYPE;
BEGIN
   BEGIN
      SELECT DiasCancelacion
        INTO nDiasCancelacion
        FROM TIPOS_DE_SEGUROS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nDiasCancelacion := 0;
   END;
   RETURN(nDiasCancelacion);
END DIAS_CANCELACION;

FUNCTION CLAVE_FACT_ELECTRONICA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2 IS
cClaveFactElect    TIPOS_DE_SEGUROS.ClaveFactElect%TYPE;
BEGIN
   BEGIN
      SELECT ClaveFactElect
        INTO cClaveFactElect
        FROM TIPOS_DE_SEGUROS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cClaveFactElect := NULL;
   END;
   RETURN(cClaveFactElect);
END CLAVE_FACT_ELECTRONICA;

FUNCTION MANEJA_FONDOS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2 IS
cIndManejaFondos    TIPOS_DE_SEGUROS.IndManejaFondos%TYPE;
BEGIN
   BEGIN
      SELECT IndManejaFondos
        INTO cIndManejaFondos
        FROM TIPOS_DE_SEGUROS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndManejaFondos := 'N';
   END;
   RETURN(cIndManejaFondos);
END MANEJA_FONDOS;

FUNCTION ES_PRODUCTO_ALTO(cIdTipoSeg VARCHAR2) RETURN VARCHAR2 IS  
cEsRiesgoAlto    VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cEsRiesgoAlto
        FROM TIPOS_DE_SEGUROS 
       WHERE IdTipoSeg   = cIdTipoSeg
         AND Tipo_Riesgo = 'ALTO';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cEsRiesgoAlto := 'N';
      WHEN TOO_MANY_ROWS THEN
         cEsRiesgoAlto := 'S';
   END;
   
   RETURN(cEsRiesgoAlto);
END ES_PRODUCTO_ALTO;

FUNCTION ES_PRODUCTO_LARGO_PLAZO(cIdTipoSeg VARCHAR2) RETURN VARCHAR2 IS  --LARPLA
cLARGO_PLAZO    VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cLARGO_PLAZO
        FROM TIPOS_DE_SEGUROS T
       WHERE IdTipoSeg   = cIdTipoSeg
         AND T.ID_LARGO_PLAZO = 'S';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cLARGO_PLAZO := 'N';
      WHEN TOO_MANY_ROWS THEN
         cLARGO_PLAZO := 'S';
   END;
   
   RETURN(cLARGO_PLAZO);
END ES_PRODUCTO_LARGO_PLAZO;

END OC_TIPOS_DE_SEGUROS;
/

--
-- OC_TIPOS_DE_SEGUROS  (Synonym) 
--
--  Dependencies: 
--   OC_TIPOS_DE_SEGUROS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_TIPOS_DE_SEGUROS FOR SICAS_OC.OC_TIPOS_DE_SEGUROS
/


GRANT EXECUTE ON SICAS_OC.OC_TIPOS_DE_SEGUROS TO PUBLIC
/
