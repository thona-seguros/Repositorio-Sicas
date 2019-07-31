--
-- OC_AGENTES_TIPOS_SEGUROS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   AGENTES_TIPOS_SEGUROS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_AGENTES_TIPOS_SEGUROS IS

  FUNCTION EMITE_TIPO_SEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAgente NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2;

  PROCEDURE COPIAR_TIPO_SEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cIdTipoSegDest VARCHAR2);

END OC_AGENTES_TIPOS_SEGUROS;
/

--
-- OC_AGENTES_TIPOS_SEGUROS  (Package Body) 
--
--  Dependencies: 
--   OC_AGENTES_TIPOS_SEGUROS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_AGENTES_TIPOS_SEGUROS IS

FUNCTION EMITE_TIPO_SEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAgente NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2 IS
cEmite    VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cEmite
        FROM AGENTES_TIPOS_SEGUROS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND Cod_Agente  = nCodAgente
         AND IdTipoSeg   = cIdTipoSeg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cEmite := 'N';
      WHEN TOO_MANY_ROWS THEN
         cEmite := 'S';
   END;
   RETURN(cEmite);
END EMITE_TIPO_SEGURO;

PROCEDURE COPIAR_TIPO_SEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cIdTipoSegDest VARCHAR2) IS
CURSOR AGTE_Q IS
   SELECT DISTINCT Cod_Agente, Porc_Comision, Tipo_Comision
     FROM AGENTES_TIPOS_SEGUROS
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND IdTipoSeg   = cIdTipoSegOrig;
BEGIN
   FOR W IN AGTE_Q LOOP
      INSERT INTO AGENTES_TIPOS_SEGUROS
             (CodCia, CodEmpresa, Cod_Agente, IdTipoSeg,
              Porc_Comision, Tipo_Comision)
      VALUES (nCodCia, nCodEmpresa, W.Cod_Agente, cIdTipoSegDest,
              W.Porc_Comision, W.Tipo_Comision);
   END LOOP;
END COPIAR_TIPO_SEGURO;

END OC_AGENTES_TIPOS_SEGUROS;
/
