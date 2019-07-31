--
-- OC_FACT_ELECT_DET_TIMBRE_LOG  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   FACT_ELECT_DETALLE_TIMBRE_LOG (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_FACT_ELECT_DET_TIMBRE_LOG AS
    FUNCTION NUMERO_LOG(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN NUMBER;
    PROCEDURE INSERTAR(nCodCia NUMBER, nCodEmpresa NUMBER, cNombreCampo VARCHAR2,
                       nIdFactura NUMBER, nIdNcr NUMBER, cSentencia VARCHAR2, cTipoModificacion VARCHAR2, 
                       cValorAntes VARCHAR2, cValorDespues VARCHAR2, dFechaMod DATE, cCodUsuario VARCHAR2); 
END OC_FACT_ELECT_DET_TIMBRE_LOG;
/

--
-- OC_FACT_ELECT_DET_TIMBRE_LOG  (Package Body) 
--
--  Dependencies: 
--   OC_FACT_ELECT_DET_TIMBRE_LOG (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_FACT_ELECT_DET_TIMBRE_LOG AS
    FUNCTION NUMERO_LOG(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN NUMBER IS
        nIdLog FACT_ELECT_DETALLE_TIMBRE_LOG.IdLog%TYPE;
    BEGIN
        SELECT NVL(MAX(IdLog),0) + 1
          INTO nIdLog
          FROM FACT_ELECT_DETALLE_TIMBRE_LOG
         WHERE CodCia     = nCodCia
           AND CodEmpresa = nCodEmpresa;
        RETURN nIdLog;
    END NUMERO_LOG;
    --
    PROCEDURE INSERTAR(nCodCia NUMBER, nCodEmpresa NUMBER, cNombreCampo VARCHAR2,
                       nIdFactura NUMBER, nIdNcr NUMBER, cSentencia VARCHAR2, cTipoModificacion VARCHAR2, 
                       cValorAntes VARCHAR2, cValorDespues VARCHAR2, dFechaMod DATE, cCodUsuario VARCHAR2) IS
        nIdLog FACT_ELECT_DETALLE_TIMBRE_LOG.IdLog%TYPE;
    BEGIN
        nIdLog      := OC_FACT_ELECT_DET_TIMBRE_LOG.NUMERO_LOG(nCodCia, nCodEmpresa);
        INSERT INTO FACT_ELECT_DETALLE_TIMBRE_LOG (IdLog, CodCia, CodEmpresa, NombreCampo, 
                                                   IdFactura, IdNcr, Sentencia, TipoModificacion, 
                                                   ValorAntes, ValorDespues, FechaMod, CodUsuario)
             VALUES (nIdLog, nCodCia, nCodEmpresa, cNombreCampo,
                     nIdFactura, nIdNcr, cSentencia, cTipoModificacion, 
                     cValorAntes, cValorDespues, dFechaMod, cCodUsuario);
    END INSERTAR;
    
END OC_FACT_ELECT_DET_TIMBRE_LOG;
/
