--
-- OC_REQUISITOS_SEGUROS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   REQUISITOS_SEGUROS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_REQUISITOS_SEGUROS IS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                 cIdTipoSegDest VARCHAR2);

END OC_REQUISITOS_SEGUROS;
/

--
-- OC_REQUISITOS_SEGUROS  (Package Body) 
--
--  Dependencies: 
--   OC_REQUISITOS_SEGUROS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_REQUISITOS_SEGUROS IS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                 cIdTipoSegDest VARCHAR2) IS
CURSOR REQ_Q IS
   SELECT CodRequisito
     FROM REQUISITOS_SEGUROS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa      
      AND IdTipoSeg  = cIdTipoSegOrig;
BEGIN
   FOR X IN REQ_Q  LOOP
      INSERT INTO REQUISITOS_SEGUROS
             (IdTipoSeg, CodRequisito, CodCia, CodEmpresa)
      VALUES (cIdTipoSegDest, X.CodRequisito, nCodCia, nCodEmpresa);
   END LOOP;
END COPIAR;

END OC_REQUISITOS_SEGUROS;
/
