CREATE OR REPLACE PACKAGE OC_CONFIG_RETEN_CANCELACION IS

  FUNCTION PROCENTAJE_RETENCION(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, dFecAnul DATE,
                                nDiasAnul NUMBER) RETURN NUMBER;

  PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cIdTipoSegDest VARCHAR2);

END OC_CONFIG_RETEN_CANCELACION;
 
 
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_CONFIG_RETEN_CANCELACION IS

FUNCTION PROCENTAJE_RETENCION(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, dFecAnul DATE,
                              nDiasAnul NUMBER) RETURN NUMBER IS
nPorcReten    CONFIG_RETEN_CANCELACION.PorcReten%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PorcReten,0) / 100
        INTO nPorcReten
        FROM CONFIG_RETEN_CANCELACION
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdTipoSeg      = cIdTipoSeg
         AND FecIniReten   <= dFecAnul
         AND FecFinReten   >= dFecAnul
         AND DiasIniReten  <= nDiasAnul
         AND DiasFinReten  >= nDiasAnul;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcReten := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Error en Configuraci¿n de Porcentaje de Retenci¿n para Tipo de Seguro ' || cIdTipoSeg);
   END;
   RETURN(nPorcReten);
END PROCENTAJE_RETENCION;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                 cIdTipoSegDest VARCHAR2) IS
CURSOR RETEN_Q IS
   SELECT FecIniReten, FecFinReten, DiasIniReten, DiasFinReten, PorcReten
     FROM CONFIG_RETEN_CANCELACION
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa      
      AND IdTipoSeg  = cIdTipoSegOrig;
BEGIN
   FOR X IN RETEN_Q  LOOP
      INSERT INTO CONFIG_RETEN_CANCELACION
             (CodCia, CodEmpresa, IdTipoSeg,FecIniReten, FecFinReten, 
              DiasIniReten, DiasFinReten, PorcReten, CodUsuario, FecUltCambio)
      VALUES (nCodCia, nCodEmpresa, cIdTipoSegDest, X.FecIniReten, X.FecFinReten, 
              X.DiasIniReten, X.DiasFinReten, X.PorcReten, USER, TRUNC(SYSDATE));
   END LOOP;
END COPIAR;

END OC_CONFIG_RETEN_CANCELACION;
