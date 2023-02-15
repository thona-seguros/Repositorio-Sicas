CREATE OR REPLACE PACKAGE GT_FACT_ELECT_FACTURA_EXT AS
    FUNCTION NUMERO_TIMBRE(nCodCia NUMBER) RETURN NUMBER;
    FUNCTION INSERTA_FACT_ELECT(nCodCia NUMBER,nIdeFactExt NUMBER, cNumDocPago VARCHAR2,
                                cCodProceso VARCHAR2, cUUID VARCHAR2, dFechaUUID DATE,
                                cFolioFiscal VARCHAR2, cSerie VARCHAR2, cUUIDRelacionado VARCHAR2,
                                dFechaCancelaUUID DATE DEFAULT NULL, cObservaciones VARCHAR2, nMtoIva NUMBER, 
                                nMtoIsr NUMBER, nMtoIvaRet NUMBER, nMtoImpCedular NUMBER, 
                                nMtoTotal NUMBER, cDocumentoXml CLOB) RETURN NUMBER;
    FUNCTION CANCELAR(nCodCia NUMBER, cUUID VARCHAR2, dFechaCancelaUUID DATE, cObservaciones VARCHAR2) RETURN NUMBER; 
    FUNCTION EXISTE_UUID(nCodCia NUMBER, cUUID VARCHAR2) RETURN VARCHAR2;  
    FUNCTION EXISTE_PROCESO(nCodCia NUMBER,nIdeFactExt NUMBER, cCodProceso VARCHAR2) RETURN VARCHAR2;
    FUNCTION ESTATUS_UUID(nCodCia NUMBER, cUUID VARCHAR2) RETURN VARCHAR2;
END GT_FACT_ELECT_FACTURA_EXT;
/

CREATE OR REPLACE PACKAGE BODY GT_FACT_ELECT_FACTURA_EXT AS
    FUNCTION NUMERO_TIMBRE(nCodCia NUMBER) RETURN NUMBER IS
        nIdTimbreFactExt FACT_ELECT_FACTURA_EXT.IdTimbreFactExt%TYPE;
    BEGIN
        SELECT NVL(MAX(IdTimbreFactExt),0) + 1
          INTO nIdTimbreFactExt
          FROM FACT_ELECT_FACTURA_EXT
         WHERE CodCia = nCodCia;
         
        RETURN nIdTimbreFactExt;
    END NUMERO_TIMBRE;
    --
    FUNCTION INSERTA_FACT_ELECT(nCodCia NUMBER,nIdeFactExt NUMBER, cNumDocPago VARCHAR2,
                                cCodProceso VARCHAR2, cUUID VARCHAR2, dFechaUUID DATE,
                                cFolioFiscal VARCHAR2, cSerie VARCHAR2, cUUIDRelacionado VARCHAR2,
                                dFechaCancelaUUID DATE DEFAULT NULL, cObservaciones VARCHAR2, nMtoIva NUMBER, 
                                nMtoIsr NUMBER, nMtoIvaRet NUMBER, nMtoImpCedular NUMBER, 
                                nMtoTotal NUMBER, cDocumentoXml CLOB) RETURN NUMBER IS
        nIdTimbreFactExt FACT_ELECT_FACTURA_EXT.IdTimbreFactExt%TYPE;
        cExiste          VARCHAR2(1);
    BEGIN
        BEGIN
            SELECT 'S'
              INTO cExiste
              FROM FACT_ELECT_FACTURA_EXT
             WHERE CodCia     = nCodCia
               AND IdeFactExt = nIdeFactExt
               AND CodProceso = cCodProceso
               AND UUID       = cUUID;
        EXCEPTION 
          WHEN NO_DATA_FOUND THEN
              cExiste := 'N';
          WHEN TOO_MANY_ROWS THEN
              cExiste := 'S';
        END;
        IF cExiste = 'S' THEN
            nIdTimbreFactExt := 0;
        ELSE
            nIdTimbreFactExt := GT_FACT_ELECT_FACTURA_EXT.NUMERO_TIMBRE(nCodCia);
            BEGIN
                INSERT INTO FACT_ELECT_FACTURA_EXT (CodCia, IdTimbreFactExt, IdeFactExt, NumDocPago,
                                                    CodProceso, UUID, FechaUUID, FolioFiscal,
                                                    Serie, UUIDRelacionado, FechaCancelaUUID, Observaciones,
                                                    MtoIva, MtoIsr, MtoIvaRet, MtoImpCedular,
                                                    MtoTotal, DocumentoXml, StsTimbreFactExt, FecStatus,
                                                    CodUsuario)
                                            VALUES (nCodCia, nIdTimbreFactExt, nIdeFactExt, cNumDocPago,
                                                    cCodProceso, cUUID, dFechaUUID, cFolioFiscal,
                                                    cSerie, cUUIDRelacionado, dFechaCancelaUUID, cObservaciones,
                                                    nMtoIva, nMtoIsr, nMtoIvaRet, nMtoImpCedular,
                                                    nMtoTotal, cDocumentoXml, 'ACTIVO', TRUNC(SYSDATE),
                                                    USER);
            EXCEPTION 
                WHEN OTHERS THEN
                    nIdTimbreFactExt := 0;                                                    
            END;
        END IF;
        RETURN nIdTimbreFactExt;
    END INSERTA_FACT_ELECT;
    --
    FUNCTION CANCELAR(nCodCia NUMBER, cUUID VARCHAR2, dFechaCancelaUUID DATE, cObservaciones VARCHAR2) RETURN NUMBER IS
        nActualiza NUMBER := 9;
    BEGIN 
        IF GT_FACT_ELECT_FACTURA_EXT.ESTATUS_UUID(nCodCia, cUUID) = 'ANULADO' THEN
            nActualiza := 0;
        ELSIF GT_FACT_ELECT_FACTURA_EXT.EXISTE_UUID(nCodCia, cUUID) = 'N' THEN
            nActualiza := 1;
        ELSE
            BEGIN
                UPDATE FACT_ELECT_FACTURA_EXT
                   SET FechaCancelaUUID = dFechaCancelaUUID,
                       Observaciones    = cObservaciones,
                       StsTimbreFactExt = 'ANULADO',
                       FecStatus        = TRUNC(SYSDATE),
                       CodUsuario       = USER
                 WHERE CodCia = nCodCia
                   AND UUID   = cUUID;
                   
            EXCEPTION 
                WHEN OTHERS THEN 
                    nActualiza := 99;
            END;
        END IF;
        RETURN nActualiza;
    END CANCELAR;
    --
    FUNCTION EXISTE_UUID(nCodCia NUMBER, cUUID VARCHAR2) RETURN VARCHAR2 IS
        cExiste VARCHAR2(1);
    BEGIN
        BEGIN
            SELECT 'S'
              INTO cExiste
              FROM FACT_ELECT_FACTURA_EXT
             WHERE CodCia = nCodCia
               AND UUID   = cUUID;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                cExiste := 'N';
            WHEN TOO_MANY_ROWS THEN
                cExiste := 'S';
        END;
        RETURN cExiste;
    END EXISTE_UUID;
    --
    FUNCTION EXISTE_PROCESO(nCodCia NUMBER,nIdeFactExt NUMBER, cCodProceso VARCHAR2) RETURN VARCHAR2 IS
        cExiste VARCHAR2(1);
    BEGIN
        BEGIN
            SELECT 'S'
              INTO cExiste
              FROM FACT_ELECT_FACTURA_EXT
             WHERE CodCia     = nCodCia
               AND IdeFactExt = nIdeFactExt
               AND CodProceso = cCodProceso
               AND UUID       IS NOT NULL;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                cExiste := 'N';
            WHEN TOO_MANY_ROWS THEN
                cExiste := 'S';
        END;
        RETURN cExiste;
    END EXISTE_PROCESO;
    --
    FUNCTION ESTATUS_UUID(nCodCia NUMBER, cUUID VARCHAR2) RETURN VARCHAR2 IS
        cStsTimbreFactExt FACT_ELECT_FACTURA_EXT.StsTimbreFactExt%TYPE;
    BEGIN
        SELECT StsTimbreFactExt
          INTO cStsTimbreFactExt
          FROM FACT_ELECT_FACTURA_EXT
         WHERE CodCia = nCodCia
           AND UUID   = cUUID;
        RETURN cStsTimbreFactExt;
    END ESTATUS_UUID;
END GT_FACT_ELECT_FACTURA_EXT;
