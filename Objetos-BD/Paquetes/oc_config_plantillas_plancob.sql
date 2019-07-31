--
-- OC_CONFIG_PLANTILLAS_PLANCOB  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   CONFIG_PLANTILLAS_PLANCOB (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.oc_config_plantillas_plancob IS

  FUNCTION CODIGO_PLANTILLA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                            cPlanCob VARCHAR2, cTipoProceso VARCHAR2) RETURN VARCHAR2;

  PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cPlanCobOrig VARCHAR2,
                   cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2);

  FUNCTION AREA_APLICACION(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                           cPlanCob VARCHAR2, cTipoProceso VARCHAR2) RETURN VARCHAR2;

  FUNCTION TIPO_PROCESO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                        cPlanCob VARCHAR2, cAreaAplicacion VARCHAR2) RETURN VARCHAR2;

END OC_CONFIG_PLANTILLAS_PLANCOB;
/

--
-- OC_CONFIG_PLANTILLAS_PLANCOB  (Package Body) 
--
--  Dependencies: 
--   OC_CONFIG_PLANTILLAS_PLANCOB (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.oc_config_plantillas_plancob IS

FUNCTION CODIGO_PLANTILLA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                          cPlanCob VARCHAR2, cTipoProceso VARCHAR2) RETURN VARCHAR2 IS
cCodPlantilla   CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE;   
BEGIN
   SELECT CodPlantilla
     INTO cCodPlantilla 
     FROM CONFIG_PLANTILLAS_PLANCOB
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND IdTipoSeg   = cIdTipoSeg
      AND PlanCob     = cPlanCob
      AND TipoProceso = cTipoProceso;
   IF cCodPlantilla IS NULL THEN
      RAISE_APPLICATION_ERROR(-20220,'No Existe Configurada Plantilla para Proceso  '|| cTipoProceso);
   ELSE
      RETURN(cCodPlantilla);
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20220,'No Existe Configurada Plantilla para Proceso  '|| cTipoProceso);
   WHEN TOO_MANY_ROWS THEN
      RAISE_APPLICATION_ERROR(-20220,'Existen varias Plantillas Configuradas para el Proceso  '|| cTipoProceso);
END CODIGO_PLANTILLA;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cPlanCobOrig VARCHAR2,
                   cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2) IS
CURSOR PLANT_Q IS
  SELECT TipoProceso, CodPlantilla, AreaAplicacion
    FROM CONFIG_PLANTILLAS_PLANCOB
   WHERE CodCia     = nCodCia
     AND CodEmpresa = nCodEmpresa
     AND IdTipoSeg  = cIdTipoSegOrig
     AND PlanCob    = cPlanCobOrig;
BEGIN
   FOR X IN PLANT_Q LOOP
      INSERT INTO CONFIG_PLANTILLAS_PLANCOB
             (CodCia, CodEmpresa, IdTipoSeg, PlanCob, TipoProceso, 
              CodPlantilla, CodUsuario, FecUltCambio, AreaAplicacion)
      VALUES (nCodCia, nCodEmpresa, cIdTipoSegDest, cPlanCobDest, X.TipoProceso, 
              X.CodPlantilla, USER, TRUNC(SYSDATE), X.AreaAplicacion);
   END LOOP;
END COPIAR;

FUNCTION AREA_APLICACION(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                         cPlanCob VARCHAR2, cTipoProceso VARCHAR2) RETURN VARCHAR2 IS
cAreaAplicacion   CONFIG_PLANTILLAS_PLANCOB.AreaAplicacion%TYPE;   
BEGIN
   SELECT AreaAplicacion
     INTO cAreaAplicacion
     FROM CONFIG_PLANTILLAS_PLANCOB
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND IdTipoSeg   = cIdTipoSeg
      AND PlanCob     = cPlanCob
      AND TipoProceso = cTipoProceso;
   IF cAreaAplicacion IS NULL THEN
      RAISE_APPLICATION_ERROR(-20220,'No Existe Configurada el Area de Aplicación del Proceso  '|| cTipoProceso);
   ELSE
      RETURN(cAreaAplicacion);
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20220,'No Existe Configurada Plantilla para Proceso  '|| cTipoProceso);
   WHEN TOO_MANY_ROWS THEN
      RAISE_APPLICATION_ERROR(-20220,'Existen varias Plantillas Configuradas para el Proceso  '|| cTipoProceso);
END AREA_APLICACION;

FUNCTION TIPO_PROCESO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                        cPlanCob VARCHAR2, cAreaAplicacion VARCHAR2) RETURN VARCHAR2 IS 
cTipoProceso   CONFIG_PLANTILLAS_PLANCOB.TipoProceso%TYPE;   
BEGIN
   SELECT TipoProceso
     INTO cTipoProceso
     FROM CONFIG_PLANTILLAS_PLANCOB
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdTipoSeg      = cIdTipoSeg
      AND PlanCob        = cPlanCob
      AND AreaAplicacion = cAreaAplicacion;
   IF cTipoProceso IS NULL THEN
      RAISE_APPLICATION_ERROR(-20220,'No Existe Configurado el Proceso para el Area de Aplicación '|| cAreaAplicacion);
   ELSE
      RETURN(cTipoProceso);
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20220,'No Existe Configurado el Proceso para el Area de Aplicación '|| cAreaAplicacion);
   WHEN TOO_MANY_ROWS THEN
      BEGIN
         SELECT MAX(TipoProceso)
           INTO cTipoProceso
           FROM CONFIG_PLANTILLAS_PLANCOB
          WHERE CodCia         = nCodCia
            AND CodEmpresa     = nCodEmpresa
            AND IdTipoSeg      = cIdTipoSeg
            AND PlanCob        = cPlanCob
            AND AreaAplicacion = cAreaAplicacion;
         RETURN(cTipoProceso);
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20220,SQLERRM);
      END;
END TIPO_PROCESO;

END OC_CONFIG_PLANTILLAS_PLANCOB;
/
