--
-- GT_BONOS_AGENTES_NEGOCIOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   BONOS_AGENTES_NEGOCIOS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_BONOS_AGENTES_NEGOCIOS AS

PROCEDURE COPIAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nIdBonoVentasDest NUMBER);

FUNCTION EXISTEN_REGISTROS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2; 

FUNCTION PORCENTAJE_NEGOCIO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, cCodTipoNegocio VARCHAR2) RETURN NUMBER; 

FUNCTION CANTIDAD_NEGOCIOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, cCodTipoNegocio VARCHAR2) RETURN NUMBER; 

PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER); 

END GT_BONOS_AGENTES_NEGOCIOS;
/

--
-- GT_BONOS_AGENTES_NEGOCIOS  (Package Body) 
--
--  Dependencies: 
--   GT_BONOS_AGENTES_NEGOCIOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_BONOS_AGENTES_NEGOCIOS AS

PROCEDURE COPIAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nIdBonoVentasDest NUMBER) IS
CURSOR NEG_Q IS
   SELECT CodTipoNegocio, PorcenNegocio, CantNegocios
     FROM BONOS_AGENTES_NEGOCIOS
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;
BEGIN
   FOR W IN NEG_Q LOOP
      INSERT INTO BONOS_AGENTES_NEGOCIOS
            (CodCia, CodEmpresa, IdBonoVentas, CodTipoNegocio, PorcenNegocio, CantNegocios)
      VALUES(nCodCia, nCodEmpresa, nIdBonoVentasDest, W.CodTipoNegocio, W.PorcenNegocio, W.CantNegocios);
   END LOOP;
END COPIAR;

FUNCTION EXISTEN_REGISTROS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2 IS
cExiste     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM BONOS_AGENTES_NEGOCIOS
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdBonoVentas  = nIdBonoVentas;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END EXISTEN_REGISTROS;

FUNCTION PORCENTAJE_NEGOCIO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, cCodTipoNegocio VARCHAR2) RETURN NUMBER IS
nPorcenNegocio     BONOS_AGENTES_NEGOCIOS.PorcenNegocio%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PorcenNegocio,0)
        INTO nPorcenNegocio
        FROM BONOS_AGENTES_NEGOCIOS
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdBonoVentas   = nIdBonoVentas
         AND CodTipoNegocio = cCodTipoNegocio;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcenNegocio := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20200,'Error en Porcentaje de BONOS_AGENTES_NEGOCIOS');
   END;
   RETURN(nPorcenNegocio);
END PORCENTAJE_NEGOCIO;

FUNCTION CANTIDAD_NEGOCIOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, cCodTipoNegocio VARCHAR2) RETURN NUMBER IS
nCantNegocios     BONOS_AGENTES_NEGOCIOS.CantNegocios%TYPE;
BEGIN
   BEGIN
      SELECT NVL(CantNegocios,0)
        INTO nCantNegocios
        FROM BONOS_AGENTES_NEGOCIOS
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdBonoVentas   = nIdBonoVentas
         AND CodTipoNegocio = cCodTipoNegocio;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nCantNegocios := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20200,'Error en Cantidad de Negocios de BONOS_AGENTES_NEGOCIOS');
   END;
   RETURN(nCantNegocios);
END CANTIDAD_NEGOCIOS;

PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) IS
BEGIN
   DELETE BONOS_AGENTES_NEGOCIOS
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdBonoVentas  = nIdBonoVentas;
END ELIMINAR;

END GT_BONOS_AGENTES_NEGOCIOS;
/
