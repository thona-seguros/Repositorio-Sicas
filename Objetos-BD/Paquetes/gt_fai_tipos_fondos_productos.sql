--
-- GT_FAI_TIPOS_FONDOS_PRODUCTOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FAI_TIPOS_FONDOS_PRODUCTOS (Table)
--   GT_FAI_TIPOS_DE_FONDOS (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_TIPOS_FONDOS_PRODUCTOS AS

FUNCTION FONDO_OBLIGATORIO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                           cPlanCob VARCHAR2, cTipoFondo VARCHAR2) RETURN VARCHAR2;

FUNCTION PORCENTAJE_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                          cPlanCob VARCHAR2, cTipoFondo VARCHAR2) RETURN NUMBER;

FUNCTION MANEJA_FONDOS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                       cPlanCob VARCHAR2) RETURN VARCHAR2;

FUNCTION FONDOS_COLECTIVOS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                           cPlanCob VARCHAR2) RETURN VARCHAR2;

END GT_FAI_TIPOS_FONDOS_PRODUCTOS;
/

--
-- GT_FAI_TIPOS_FONDOS_PRODUCTOS  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_TIPOS_FONDOS_PRODUCTOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_TIPOS_FONDOS_PRODUCTOS  AS

FUNCTION FONDO_OBLIGATORIO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                           cPlanCob VARCHAR2, cTipoFondo VARCHAR2) RETURN VARCHAR2 IS
cIndFondoOblig    FAI_TIPOS_FONDOS_PRODUCTOS.IndFondoOblig%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndFondoOblig,'N')
        INTO cIndFondoOblig
        FROM FAI_TIPOS_FONDOS_PRODUCTOS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob
         AND TipoFondo  = cTipoFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndFondoOblig := 'N';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Existen Varios Registros de Fondos para el Mismo Producto y Plan de Coberturas');
   END;
   RETURN(cIndFondoOblig);
END FONDO_OBLIGATORIO;

FUNCTION PORCENTAJE_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                          cPlanCob VARCHAR2, cTipoFondo VARCHAR2) RETURN NUMBER IS
nPorcFondo    FAI_TIPOS_FONDOS_PRODUCTOS.PorcFondo%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PorcFondo,0)
        INTO nPorcFondo
        FROM FAI_TIPOS_FONDOS_PRODUCTOS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob
         AND TipoFondo  = cTipoFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcFondo := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Existen Varios Registros de Fondos para el Mismo Producto y Plan de Coberturas');
   END;
   RETURN(nPorcFondo);
END PORCENTAJE_FONDO;

FUNCTION MANEJA_FONDOS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                       cPlanCob VARCHAR2) RETURN VARCHAR2 IS
cExistenFondos    VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExistenFondos
        FROM FAI_TIPOS_FONDOS_PRODUCTOS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExistenFondos := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExistenFondos := 'S';
   END;
   RETURN(cExistenFondos);
END MANEJA_FONDOS;

FUNCTION FONDOS_COLECTIVOS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                           cPlanCob VARCHAR2) RETURN VARCHAR2 IS
cExistenFondos    VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExistenFondos
        FROM FAI_TIPOS_FONDOS_PRODUCTOS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob
         AND GT_FAI_TIPOS_DE_FONDOS.INDICADORES(CodCia, CodEmpresa, TipoFondo, 'FCOL') = 'S';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExistenFondos := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExistenFondos := 'S';
   END;
   RETURN(cExistenFondos);
END FONDOS_COLECTIVOS;

END GT_FAI_TIPOS_FONDOS_PRODUCTOS;
/

--
-- GT_FAI_TIPOS_FONDOS_PRODUCTOS  (Synonym) 
--
--  Dependencies: 
--   GT_FAI_TIPOS_FONDOS_PRODUCTOS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_FAI_TIPOS_FONDOS_PRODUCTOS FOR SICAS_OC.GT_FAI_TIPOS_FONDOS_PRODUCTOS
/


GRANT EXECUTE, DEBUG ON SICAS_OC.GT_FAI_TIPOS_FONDOS_PRODUCTOS TO PUBLIC
/
