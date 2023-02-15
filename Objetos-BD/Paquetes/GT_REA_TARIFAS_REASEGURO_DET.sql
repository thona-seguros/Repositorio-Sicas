CREATE OR REPLACE PACKAGE GT_REA_TARIFAS_REASEGURO_DET IS

  FUNCTION FACTOR_TARIFA(nCodCia NUMBER, cCodTarifaReaseg VARCHAR2, cCodGrupoCobert VARCHAR2,
                         nEdad NUMBER, cCodEmpresaGremio VARCHAR2) RETURN NUMBER;
  PROCEDURE COPIAR(nCodCia NUMBER, cCodTarifaReaSegOrig VARCHAR2, cCodTarifaReaSegDest VARCHAR2);

END GT_REA_TARIFAS_REASEGURO_DET;
/

CREATE OR REPLACE PACKAGE BODY GT_REA_TARIFAS_REASEGURO_DET IS

FUNCTION FACTOR_TARIFA(nCodCia NUMBER, cCodTarifaReaseg VARCHAR2, cCodGrupoCobert VARCHAR2,
                       nEdad NUMBER, cCodEmpresaGremio VARCHAR2) RETURN NUMBER IS
nFactorTarifa       REA_TARIFAS_REASEGURO_DET.FactorTarifa%TYPE;
BEGIN
   BEGIN
      SELECT FactorTarifa
        INTO nFactorTarifa
        FROM REA_TARIFAS_REASEGURO_DET
       WHERE CodCia           = nCodCia
         AND CodTarifaReaseg  = cCodTarifaReaseg
         AND CodGrupoCobert   = cCodGrupoCobert
         AND EdadInicial     <= nEdad
         AND EdadFinal       >= nEdad
         AND CodEmpresaGremio = cCodEmpresaGremio;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         BEGIN
            SELECT FactorTarifa
              INTO nFactorTarifa
              FROM REA_TARIFAS_REASEGURO_DET
             WHERE CodCia           = nCodCia
               AND CodTarifaReaseg  = cCodTarifaReaseg
               AND CodGrupoCobert   = cCodGrupoCobert
               AND EdadInicial     <= nEdad
               AND EdadFinal       >= nEdad
               AND CodEmpresaGremio = '00000';
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               nFactorTarifa := 0;
            WHEN TOO_MANY_ROWS THEN
               RAISE_APPLICATION_ERROR(-20200,'Error en Configuración de Tarifa de Reaseguro  '|| cCodTarifaReaseg || 
                                       ' para el Grupo de Coberturas ' || cCodGrupoCobert || ' de Edad ' || nEdad ||
                                       ' para la Empresa ' || cCodEmpresaGremio);
        END;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20200,'Error en Configuración de Tarifa de Reaseguro  '|| cCodTarifaReaseg || 
                                 ' para el Grupo de Coberturas ' || cCodGrupoCobert || ' de Edad ' || nEdad ||
                                 ' para la Empresa ' || cCodEmpresaGremio);
   END;
   RETURN(nFactorTarifa);
END FACTOR_TARIFA;

PROCEDURE COPIAR(nCodCia NUMBER, cCodTarifaReaSegOrig VARCHAR2, cCodTarifaReaSegDest VARCHAR2) IS
CURSOR TARIREADET_Q IS
   SELECT CodCia, CodTarifaReaSeg, CodGrupoCobert, EdadInicial, EdadFinal, 
          FactorTarifa, CodUsuario, FecUltModif, CodEmpresaGremio
     FROM REA_TARIFAS_REASEGURO_DET
    WHERE CodCia            = nCodCia
      AND CodTarifaReaSeg   = cCodTarifaReaSegOrig;
BEGIN
   FOR W IN TARIREADET_Q LOOP
      INSERT INTO REA_TARIFAS_REASEGURO_DET
             (CodCia, CodTarifaReaSeg, CodGrupoCobert, EdadInicial, EdadFinal, 
              FactorTarifa, CodUsuario, FecUltModif, CodEmpresaGremio)
      VALUES (nCodCia, cCodTarifaReaSegDest, W.CodGrupoCobert, W.EdadInicial, W.EdadFinal, 
              W.FactorTarifa, W.CodUsuario, W.FecUltModif, W.CodEmpresaGremio);
   END LOOP;
END COPIAR;

END GT_REA_TARIFAS_REASEGURO_DET;
