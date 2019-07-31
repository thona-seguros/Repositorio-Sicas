--
-- GT_FAI_CONF_COMISIONES_FONDO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FAI_CONF_COMISIONES_FONDO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_CONF_COMISIONES_FONDO AS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2,
                 cTipoFondoDest VARCHAR2, cNivelComisionOrig VARCHAR2, cPlanComisionOrig VARCHAR2,
                 cNivelComisionDest VARCHAR2, cPlanComisionDest VARCHAR2);

FUNCTION MANEJA_ANTICIPOS(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                          cNivelComision VARCHAR2, cPlanComision VARCHAR2) RETURN VARCHAR2;

FUNCTION TIPO_COMISION(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                       cNivelComision VARCHAR2, cPlanComision VARCHAR2) RETURN VARCHAR2;

FUNCTION COMISION_ANTICIPO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                           cNivelComision VARCHAR2, cPlanComision VARCHAR2) RETURN NUMBER;

FUNCTION COMISION_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                        cNivelComision VARCHAR2, cPlanComision VARCHAR2) RETURN NUMBER;

FUNCTION EXISTE_ESQUEMA_COMISION(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2) RETURN VARCHAR2;

END GT_FAI_CONF_COMISIONES_FONDO;
/

--
-- GT_FAI_CONF_COMISIONES_FONDO  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_CONF_COMISIONES_FONDO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_CONF_COMISIONES_FONDO AS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2,
                 cTipoFondoDest VARCHAR2, cNivelComisionOrig VARCHAR2, cPlanComisionOrig VARCHAR2,
					  cNivelComisionDest VARCHAR2, cPlanComisionDest VARCHAR2) IS 
CURSOR COMI_Q IS
   SELECT NivelComision, PlanComision, EdadInicial, EdadFinal,
          AnoComision, TipoComision, IndAdicComis,  PorcCom,
          IndAnticipo, PorcComAnticipo, CodRutinaCalc
     FROM FAI_CONF_COMISIONES_FONDO
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND TipoFondo     = cTipoFondoOrig
	   AND NivelComision = cNivelComisionOrig
      AND PlanComision  = cPlanComisionOrig;
BEGIN
   FOR X IN COMI_Q LOOP
      BEGIN
         INSERT INTO FAI_CONF_COMISIONES_FONDO
                (CodCia, CodEmpresa, TipoFondo, NivelComision, PlanComision, 
                 EdadInicial, EdadFinal, AnoComision, TipoComision, IndAdicComis,
                 PorcCom, IndAnticipo, PorcComAnticipo, CodRutinaCalc)
         VALUES (nCodCia, nCodEmpresa, cTipoFondoDest, cNivelComisionDest, cPlanComisionDest,
                 X.EdadInicial, X.EdadFinal, X.AnoComision, X.TipoComision, X.IndAdicComis,
                 X.PorcCom, X.IndAnticipo, X.PorcComAnticipo, X.CodRutinaCalc);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20100,'Error Copiando Comisiones para Fondo: '||cTipoFondoDest);
      END;
   END LOOP;
END COPIAR;

FUNCTION MANEJA_ANTICIPOS(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                          cNivelComision VARCHAR2, cPlanComision VARCHAR2) RETURN VARCHAR2 IS
cAnticipos   FAI_CONF_COMISIONES_FONDO.IndAnticipo%TYPE;
BEGIN
   BEGIN
      SELECT 'S'
        INTO cAnticipos
        FROM FAI_CONF_COMISIONES_FONDO
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND TipoFondo     = cTipoFondo
         AND NivelComision = cNivelComision
         AND PlanComision  = cPlanComision
         AND IndAnticipo   = 'S';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cAnticipos := 'N';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Función de Manejo de Anticipos para Fondo: '||cTipoFondo);
   END;
   RETURN(cAnticipos);
END MANEJA_ANTICIPOS;

FUNCTION TIPO_COMISION(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                          cNivelComision VARCHAR2, cPlanComision VARCHAR2) RETURN VARCHAR2 IS
cTipoComision  FAI_CONF_COMISIONES_FONDO.TipoComision%TYPE;
BEGIN
   BEGIN
      SELECT TipoComision
        INTO cTipoComision
        FROM FAI_CONF_COMISIONES_FONDO
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND TipoFondo     = cTipoFondo
         AND NivelComision = cNivelComision
         AND PlanComision  = cPlanComision;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTipoComision := 'N';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Función de Tipo Comisión para Fondo: '||cTipoFondo);
   END;
   RETURN(cTipoComision);
END TIPO_COMISION;

FUNCTION COMISION_ANTICIPO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                           cNivelComision VARCHAR2, cPlanComision VARCHAR2) RETURN NUMBER IS
nPorcComAnticipo   FAI_CONF_COMISIONES_FONDO.PorcComAnticipo%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PorcComAnticipo,0)
        INTO nPorcComAnticipo
        FROM FAI_CONF_COMISIONES_FONDO
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND TipoFondo     = cTipoFondo
         AND NivelComision = cNivelComision
         AND PlanComision  = cPlanComision;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcComAnticipo := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Función de Comisión de Anticipo para Fondo: '||cTipoFondo);
   END;
   RETURN(nPorcComAnticipo);
END COMISION_ANTICIPO;

FUNCTION COMISION_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                        cNivelComision VARCHAR2, cPlanComision VARCHAR2) RETURN NUMBER IS
nPorcCom     FAI_CONF_COMISIONES_FONDO.PorcCom%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PorcCom,0)
        INTO nPorcCom
        FROM FAI_CONF_COMISIONES_FONDO
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND TipoFondo     = cTipoFondo
         AND NivelComision = cNivelComision
         AND PlanComision  = cPlanComision;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcCom := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Función de Comisión de Fondo: '||cTipoFondo);
   END;
   RETURN(nPorcCom);
END COMISION_FONDO;

FUNCTION EXISTE_ESQUEMA_COMISION(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2) RETURN VARCHAR2 IS
cExiste        VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM FAI_CONF_COMISIONES_FONDO
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND TipoFondo     = cTipoFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END EXISTE_ESQUEMA_COMISION;

END GT_FAI_CONF_COMISIONES_FONDO;
/
