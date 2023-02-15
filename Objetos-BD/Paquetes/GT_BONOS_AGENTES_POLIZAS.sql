CREATE OR REPLACE PACKAGE GT_BONOS_AGENTES_POLIZAS AS

PROCEDURE COPIAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nIdBonoVentasDest NUMBER);

FUNCTION EXISTEN_REGISTROS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2; 

PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER);

END GT_BONOS_AGENTES_POLIZAS;
/

CREATE OR REPLACE PACKAGE BODY GT_BONOS_AGENTES_POLIZAS AS

PROCEDURE COPIAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nIdBonoVentasDest NUMBER) IS
CURSOR AGT_Q IS
   SELECT IdPoliza
     FROM BONOS_AGENTES_POLIZAS
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;
BEGIN
   FOR W IN AGT_Q LOOP
      INSERT INTO BONOS_AGENTES_POLIZAS
            (CodCia, CodEmpresa, IdBonoVentas, IdPoliza)
      VALUES(nCodCia, nCodEmpresa, nIdBonoVentasDest, W.IdPoliza);
   END LOOP;
END COPIAR;

FUNCTION EXISTEN_REGISTROS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2 IS
cExiste     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM BONOS_AGENTES_POLIZAS
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdBonoVentas = nIdBonoVentas;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END EXISTEN_REGISTROS;

PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) IS
BEGIN
   DELETE BONOS_AGENTES_POLIZAS
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;
END ELIMINAR;

END GT_BONOS_AGENTES_POLIZAS;
