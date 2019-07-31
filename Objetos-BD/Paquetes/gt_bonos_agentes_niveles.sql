--
-- GT_BONOS_AGENTES_NIVELES  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   BONOS_AGENTES_CONFIG (Table)
--   BONOS_AGENTES_NIVELES (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_BONOS_AGENTES_NIVELES AS

PROCEDURE COPIAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nIdBonoVentasDest NUMBER);

FUNCTION EXISTEN_REGISTROS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER) RETURN VARCHAR2; 

FUNCTION TIENE_CONVENIO_ESPECIAL(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, cCodAgente VARCHAR2) RETURN VARCHAR2; 

PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER); 

END GT_BONOS_AGENTES_NIVELES;
/

--
-- GT_BONOS_AGENTES_NIVELES  (Package Body) 
--
--  Dependencies: 
--   GT_BONOS_AGENTES_NIVELES (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_BONOS_AGENTES_NIVELES AS

PROCEDURE COPIAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nIdBonoVentasDest NUMBER) IS
CURSOR INTER_Q IS
   SELECT CodNivel, CodAgente
     FROM BONOS_AGENTES_NIVELES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;
BEGIN
   FOR W IN INTER_Q LOOP
      INSERT INTO BONOS_AGENTES_NIVELES
            (CodCia, CodEmpresa, IdBonoVentas, CodNivel, CodAgente)
      VALUES(nCodCia, nCodEmpresa, nIdBonoVentasDest, W.CodNivel, W.CodAgente);
   END LOOP;
END COPIAR;

FUNCTION EXISTEN_REGISTROS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER) RETURN VARCHAR2 IS
cExiste     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM BONOS_AGENTES_NIVELES
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdBonoVentas  = nIdBonoVentas
         AND CodNivel     <= nCodNivel;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END EXISTEN_REGISTROS;

FUNCTION TIENE_CONVENIO_ESPECIAL(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, cCodAgente VARCHAR2) RETURN VARCHAR2 IS
cExiste     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM BONOS_AGENTES_NIVELES I, BONOS_AGENTES_CONFIG B
       WHERE I.CodNivel         = nCodNivel
         AND I.CodAgente        = cCodAgente
         AND I.IdBonoVentas     = nIdBonoVentas
         AND B.CodCia           = nCodCia
         AND B.CodEmpresa       = nCodEmpresa
         AND B.IdBonoVentas    != I.IdBonoVentas
         AND B.IndAgteConvEsp   = 'S'
         AND EXISTS (SELECT 'S'
                       FROM BONOS_AGENTES_NIVELES
                      WHERE CodNivel        = I.CodNivel
                        AND CodAgente       = I.CodAgente
                        AND CodCia          = I.CodCia
                        AND CodEmpresa      = I.CodEmpresa
                        AND IdBonoVentas    = I.IdBonoVentas);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END TIENE_CONVENIO_ESPECIAL;

PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) IS
BEGIN
   DELETE BONOS_AGENTES_NIVELES
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdBonoVentas  = nIdBonoVentas;
END ELIMINAR;

END GT_BONOS_AGENTES_NIVELES;
/
