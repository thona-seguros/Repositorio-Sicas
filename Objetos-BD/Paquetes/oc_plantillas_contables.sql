--
-- OC_PLANTILLAS_CONTABLES  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   PLANTILLAS_CONTABLES (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_PLANTILLAS_CONTABLES IS

PROCEDURE COPIAR_PLANTILLA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                           cIdTipoSegDest VARCHAR2);

PROCEDURE COPIAR(nCodCia NUMBER, cCodProcesoOrig VARCHAR2, nCodEmpresaOrig NUMBER, cIdTipoSegOrig VARCHAR2,
                 cCodMonedaOrig VARCHAR2, cCodCentroCostoOrig VARCHAR2, cCodUnidadNegocioOrig VARCHAR2,
                 cCodProcesoDest VARCHAR2, nCodEmpresaDest NUMBER, cIdTipoSegDest VARCHAR2, 
                 cCodMonedaDest VARCHAR2, cCodCentroCostoDest VARCHAR2, cCodUnidadNegocioDest VARCHAR2,
                 cIndInvierteDbCr VARCHAR2);
                 
FUNCTION NUMERO_REG_PLANTILLA (nCodCia IN NUMBER, cCodProceso IN VARCHAR2) RETURN NUMBER;              

END OC_PLANTILLAS_CONTABLES;
/

--
-- OC_PLANTILLAS_CONTABLES  (Package Body) 
--
--  Dependencies: 
--   OC_PLANTILLAS_CONTABLES (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_PLANTILLAS_CONTABLES IS

PROCEDURE COPIAR_PLANTILLA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                           cIdTipoSegDest VARCHAR2) IS
nIdRegPlantilla   PLANTILLAS_CONTABLES.IdRegPlantilla%TYPE;
CURSOR EMI_Q IS
   SELECT CodProceso, IdRegPlantilla, CodCpto, CodMoneda, NivelCta1, NivelCta2,
          NivelCta3, NivelCta4, NivelCta5, NivelCta6, NivelCta7, NivelAux,
          RegDebCred, TipoRegistro, CodCentroCosto, CodUnidadNegocio,
          TipoPersona, CanalComisVenta, DescCptoGeneral, TipoAgente
     FROM PLANTILLAS_CONTABLES
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa      
      AND IdTipoSeg  = cIdTipoSegOrig;
BEGIN
   FOR X IN EMI_Q  LOOP
      SELECT NVL(MAX(IdRegPlantilla),0) + 1
        INTO nIdRegPlantilla
        FROM PLANTILLAS_CONTABLES
       WHERE CodCia     = nCodCia
         AND CodProceso = X.CodProceso;

      INSERT INTO PLANTILLAS_CONTABLES
             (CodCia, CodProceso, IdRegPlantilla, CodEmpresa, IdTipoSeg, 
              CodCpto, CodMoneda, NivelCta1, NivelCta2, NivelCta3, NivelCta4, NivelCta5, 
              NivelCta6, NivelCta7, NivelAux, RegDebCred, TipoRegistro,
              CodCentroCosto, CodUnidadNegocio, TipoPersona, CanalComisVenta,
              DescCptoGeneral, TipoAgente)
      VALUES (nCodCia, X.CodProceso, nIdRegPlantilla, nCodEmpresa, cIdTipoSegDest,
              X.CodCpto, X.CodMoneda, X.NivelCta1, X.NivelCta2, X.NivelCta3, X.NivelCta4,
              X.NivelCta5, X.NivelCta6, X.NivelCta7, X.NivelAux, X.RegDebCred, X.TipoRegistro,
              X.CodCentroCosto, X.CodUnidadNegocio, X.TipoPersona, X.CanalComisVenta,
              X.DescCptoGeneral, X.TipoAgente);
   END LOOP;
END COPIAR_PLANTILLA;

PROCEDURE COPIAR(nCodCia NUMBER, cCodProcesoOrig VARCHAR2, nCodEmpresaOrig NUMBER, cIdTipoSegOrig VARCHAR2,
                 cCodMonedaOrig VARCHAR2, cCodCentroCostoOrig VARCHAR2, cCodUnidadNegocioOrig VARCHAR2,
                 cCodProcesoDest VARCHAR2, nCodEmpresaDest NUMBER, cIdTipoSegDest VARCHAR2, 
                 cCodMonedaDest VARCHAR2, cCodCentroCostoDest VARCHAR2, cCodUnidadNegocioDest VARCHAR2,
                 cIndInvierteDbCr VARCHAR2) IS
nIdRegPlantilla   PLANTILLAS_CONTABLES.IdRegPlantilla%TYPE;
cRegDebCred       PLANTILLAS_CONTABLES.RegDebCred%TYPE;

CURSOR EMI_Q IS
   SELECT IdRegPlantilla, CodCpto, CodMoneda, NivelCta1, NivelCta2,
          NivelCta3, NivelCta4, NivelCta5, NivelCta6, NivelCta7, NivelAux,
          RegDebCred, TipoRegistro, CodCentroCosto, CodUnidadNegocio,
          TipoPersona, CanalComisVenta, DescCptoGeneral, TipoAgente
     FROM PLANTILLAS_CONTABLES
    WHERE CodCia        = nCodCia
      AND CodProceso    = cCodProcesoOrig
      AND CodEmpresa    = nCodEmpresaOrig
      AND IdTipoSeg     = cIdTipoSegOrig
      AND ((CodMoneda = cCodMonedaOrig AND cCodMonedaOrig IS NOT NULL)
       OR  cCodMonedaOrig IS NULL)
      AND ((CodCentroCosto = cCodCentroCostoOrig AND cCodCentroCostoOrig IS NOT NULL)
       OR  cCodCentroCostoOrig IS NULL)
      AND ((CodUnidadNegocio = cCodUnidadNegocioOrig AND cCodUnidadNegocioOrig IS NOT NULL)
       OR  cCodUnidadNegocioOrig IS NULL);
BEGIN
   FOR X IN EMI_Q  LOOP
      SELECT NVL(MAX(IdRegPlantilla),0) + 1
        INTO nIdRegPlantilla
        FROM PLANTILLAS_CONTABLES
       WHERE CodCia     = nCodCia;

      IF cIndInvierteDbCr = 'S' THEN
         IF X.RegDebCred = 'D' THEN
            cRegDebCred := 'C';
         ELSE
            cRegDebCred := 'D';
         END IF;
      ELSE
         cRegDebCred := X.RegDebCred;
      END IF;

      INSERT INTO PLANTILLAS_CONTABLES
             (CodCia, CodProceso, IdRegPlantilla, CodEmpresa, IdTipoSeg, 
              CodCpto, CodMoneda, NivelCta1, NivelCta2, NivelCta3, NivelCta4,
              NivelCta5, NivelCta6, NivelCta7, NivelAux, RegDebCred, TipoRegistro,
              CodCentroCosto, CodUnidadNegocio, TipoPersona, CanalComisVenta,
              DescCptoGeneral, TipoAgente)
      VALUES (nCodCia, cCodProcesoDest, nIdRegPlantilla, nCodEmpresaDest, cIdTipoSegDest,
              X.CodCpto, NVL(cCodMonedaDest,X.CodMoneda), X.NivelCta1, X.NivelCta2, X.NivelCta3,
              X.NivelCta4, X.NivelCta5,  X.NivelCta6, X.NivelCta7, X.NivelAux, cRegDebCred, 
              X.TipoRegistro, NVL(cCodCentroCostoDest,X.CodCentroCosto), 
              NVL(cCodUnidadNegocioDest,X.CodUnidadNegocio), X.TipoPersona, X.CanalComisVenta,
              X.DescCptoGeneral, X.TipoAgente);
   END LOOP;
END COPIAR;

FUNCTION NUMERO_REG_PLANTILLA (nCodCia IN NUMBER, cCodProceso IN VARCHAR2) RETURN NUMBER IS
nIdRegPlantilla PLANTILLAS_CONTABLES.IdRegPlantilla%TYPE;
BEGIN
    SELECT NVL(MAX(IdRegPlantilla),0) + 1
        INTO nIdRegPlantilla
        FROM PLANTILLAS_CONTABLES
       WHERE CodCia     = nCodCia
         AND CodProceso = cCodProceso;
    RETURN nIdRegPlantilla;
END NUMERO_REG_PLANTILLA;   

END OC_PLANTILLAS_CONTABLES;
/
