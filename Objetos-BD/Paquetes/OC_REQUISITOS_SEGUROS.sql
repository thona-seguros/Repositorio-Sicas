CREATE OR REPLACE PACKAGE OC_REQUISITOS_SEGUROS IS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                 cIdTipoSegDest VARCHAR2);

END OC_REQUISITOS_SEGUROS;
 
 
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_REQUISITOS_SEGUROS IS

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
