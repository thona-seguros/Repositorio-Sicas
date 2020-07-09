--
-- GT_CAT_RESPUESTA_WEBTRANSFER  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   CAT_RESPUESTA_WEBTRANSFER (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_CAT_RESPUESTA_WEBTRANSFER AS
    FUNCTION TIPO_RESPUESTA (nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, 
                             nCorrelativo IN NUMBER, cCodRespuesta IN VARCHAR2) RETURN VARCHAR2;
                             
    FUNCTION ISO_RESPUESTA (nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, 
                             nCorrelativo IN NUMBER, cCodRespuesta IN VARCHAR2,
                             cCodTipoRespuesta IN VARCHAR2) RETURN VARCHAR2;
                             
    FUNCTION DESC_RESPUESTA (nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, 
                             nCorrelativo IN NUMBER, cCodRespuesta IN VARCHAR2,
                             cCodTipoRespuesta IN VARCHAR2) RETURN VARCHAR2;    
                             
    FUNCTION PERMITE_REENVIO (nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, 
                             nCorrelativo IN NUMBER, cCodRespuesta IN VARCHAR2,
                             cCodTipoRespuesta IN VARCHAR2) RETURN VARCHAR2;    
                             
    FUNCTION DIAS_REENVIO (nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, 
                          nCorrelativo IN NUMBER, cCodRespuesta IN VARCHAR2,
                          cCodTipoRespuesta IN VARCHAR2) RETURN NUMBER;    
                             
    FUNCTION REENVIOS_POSTERIORES (nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, 
                                    nCorrelativo IN NUMBER, cCodRespuesta IN VARCHAR2,
                                    cCodTipoRespuesta IN VARCHAR2) RETURN NUMBER; 
                                    
    FUNCTION PERMITE_INTERVALOS (nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, 
                                 nCorrelativo IN NUMBER, cCodRespuesta IN VARCHAR2,
                                 cCodTipoRespuesta IN VARCHAR2) RETURN VARCHAR2;   
                                 
    FUNCTION HORAS_INTERVALO (nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, 
                              nCorrelativo IN NUMBER, cCodRespuesta IN VARCHAR2,
                              cCodTipoRespuesta IN VARCHAR2) RETURN NUMBER;  
                              
    FUNCTION REINTENTOS_INTERVALO (nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, 
                                  nCorrelativo IN NUMBER, cCodRespuesta IN VARCHAR2,
                                  cCodTipoRespuesta IN VARCHAR2) RETURN NUMBER; 
                                  
    FUNCTION EXISTE_CONFIG(nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, nCorrelativo IN NUMBER) RETURN VARCHAR2;                                                                                                                                                                                             
                             
END GT_CAT_RESPUESTA_WEBTRANSFER;
/

--
-- GT_CAT_RESPUESTA_WEBTRANSFER  (Package Body) 
--
--  Dependencies: 
--   GT_CAT_RESPUESTA_WEBTRANSFER (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_CAT_RESPUESTA_WEBTRANSFER AS
    FUNCTION TIPO_RESPUESTA (nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, 
                             nCorrelativo IN NUMBER, cCodRespuesta IN VARCHAR2) RETURN VARCHAR2 IS
        cCodTipoRespuesta   CAT_RESPUESTA_WEBTRANSFER.CodTipoRespuesta%TYPE;
    BEGIN
        BEGIN
            SELECT NVL(CodTipoRespuesta,'NA')
              INTO cCodTipoRespuesta
              FROM CAT_RESPUESTA_WEBTRANSFER
             WHERE CodCia       = nCodCia
               AND CodEntidad   = cCodEntidad
               AND Correlativo  = nCorrelativo
               AND CodRespuesta = cCodRespuesta;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                cCodTipoRespuesta := 'NA';            
        END;
        RETURN cCodTipoRespuesta;
    END TIPO_RESPUESTA;
    
    FUNCTION ISO_RESPUESTA (nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, 
                             nCorrelativo IN NUMBER, cCodRespuesta IN VARCHAR2,
                             cCodTipoRespuesta IN VARCHAR2) RETURN VARCHAR2 IS
        cCodIsoRespuesta    CAT_RESPUESTA_WEBTRANSFER.CodIsoRespuesta%TYPE;
    BEGIN
        BEGIN
            SELECT NVL(CodIsoRespuesta,'NA')
              INTO cCodIsoRespuesta
              FROM CAT_RESPUESTA_WEBTRANSFER
             WHERE CodCia           = nCodCia
               AND CodEntidad       = cCodEntidad
               AND Correlativo      = nCorrelativo
               AND CodRespuesta     = cCodRespuesta
               AND CodTipoRespuesta = cCodTipoRespuesta;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                cCodIsoRespuesta := 'NA';            
        END;
        RETURN cCodIsoRespuesta;
    END ISO_RESPUESTA;
    
    FUNCTION DESC_RESPUESTA (nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, 
                             nCorrelativo IN NUMBER, cCodRespuesta IN VARCHAR2,
                             cCodTipoRespuesta IN VARCHAR2) RETURN VARCHAR2 IS
        cDescRespuesta    CAT_RESPUESTA_WEBTRANSFER.DescRespuesta%TYPE;
    BEGIN
        BEGIN
            SELECT NVL(DescRespuesta,'NA')
              INTO cDescRespuesta
              FROM CAT_RESPUESTA_WEBTRANSFER
             WHERE CodCia           = nCodCia
               AND CodEntidad       = cCodEntidad
               AND Correlativo      = nCorrelativo
               AND CodRespuesta     = cCodRespuesta
               AND CodTipoRespuesta = cCodTipoRespuesta;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                cDescRespuesta := 'NA';            
        END;
        RETURN cDescRespuesta;
    END DESC_RESPUESTA;
    
    FUNCTION PERMITE_REENVIO (nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, 
                             nCorrelativo IN NUMBER, cCodRespuesta IN VARCHAR2,
                             cCodTipoRespuesta IN VARCHAR2) RETURN VARCHAR2 IS
        cIndPermiteReenvio CAT_RESPUESTA_WEBTRANSFER.IndPermiteReenvio%TYPE;
    BEGIN
        BEGIN
            SELECT NVL(IndPermiteReenvio,'N')
              INTO cIndPermiteReenvio
              FROM CAT_RESPUESTA_WEBTRANSFER
             WHERE CodCia           = nCodCia
               AND CodEntidad       = cCodEntidad
               AND Correlativo      = nCorrelativo
               AND CodRespuesta     = cCodRespuesta
               AND CodTipoRespuesta = cCodTipoRespuesta;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                cIndPermiteReenvio := 'N';            
        END;
        RETURN cIndPermiteReenvio;
    END PERMITE_REENVIO;         
    
    FUNCTION DIAS_REENVIO (nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, 
                           nCorrelativo IN NUMBER, cCodRespuesta IN VARCHAR2,
                           cCodTipoRespuesta IN VARCHAR2) RETURN NUMBER IS
        nNumDiasReenvio CAT_RESPUESTA_WEBTRANSFER.NumDiasReenvio%TYPE;
    BEGIN
        BEGIN
            SELECT NVL(NumDiasReenvio,0)
              INTO nNumDiasReenvio
              FROM CAT_RESPUESTA_WEBTRANSFER
             WHERE CodCia           = nCodCia
               AND CodEntidad       = cCodEntidad
               AND Correlativo      = nCorrelativo
               AND CodRespuesta     = cCodRespuesta
               AND CodTipoRespuesta = cCodTipoRespuesta;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                nNumDiasReenvio := 0;            
        END;
        RETURN nNumDiasReenvio;
    END DIAS_REENVIO;
    
    FUNCTION REENVIOS_POSTERIORES (nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, 
                                    nCorrelativo IN NUMBER, cCodRespuesta IN VARCHAR2,
                                    cCodTipoRespuesta IN VARCHAR2) RETURN NUMBER IS
        nNumReenvioPosteriores CAT_RESPUESTA_WEBTRANSFER.NumReenvioPosteriores%TYPE;
    BEGIN
        BEGIN
            SELECT NVL(NumReenvioPosteriores,0)
              INTO nNumReenvioPosteriores
              FROM CAT_RESPUESTA_WEBTRANSFER
             WHERE CodCia           = nCodCia
               AND CodEntidad       = cCodEntidad
               AND Correlativo      = nCorrelativo
               AND CodRespuesta     = cCodRespuesta
               AND CodTipoRespuesta = cCodTipoRespuesta;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                nNumReenvioPosteriores := 0;            
        END;
        RETURN nNumReenvioPosteriores;
    END REENVIOS_POSTERIORES;
    
    FUNCTION PERMITE_INTERVALOS (nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, 
                                 nCorrelativo IN NUMBER, cCodRespuesta IN VARCHAR2,
                                 cCodTipoRespuesta IN VARCHAR2) RETURN VARCHAR2 IS
        cIndPermiteIntervalo    CAT_RESPUESTA_WEBTRANSFER.IndPermiteIntervalo%TYPE;
    BEGIN
        BEGIN
            SELECT NVL(IndPermiteIntervalo,'N')
              INTO cIndPermiteIntervalo
              FROM CAT_RESPUESTA_WEBTRANSFER
             WHERE CodCia           = nCodCia
               AND CodEntidad       = cCodEntidad
               AND Correlativo      = nCorrelativo
               AND CodRespuesta     = cCodRespuesta
               AND CodTipoRespuesta = cCodTipoRespuesta;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                cIndPermiteIntervalo := 'N';            
        END;
        RETURN cIndPermiteIntervalo;
    END PERMITE_INTERVALOS;
    
        FUNCTION HORAS_INTERVALO (nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, 
                              nCorrelativo IN NUMBER, cCodRespuesta IN VARCHAR2,
                              cCodTipoRespuesta IN VARCHAR2) RETURN NUMBER IS
        nNumHorasIntervalo  CAT_RESPUESTA_WEBTRANSFER.NumHorasIntervalo%TYPE;
    BEGIN
        BEGIN
            SELECT NVL(NumHorasIntervalo,0)
              INTO nNumHorasIntervalo
              FROM CAT_RESPUESTA_WEBTRANSFER
             WHERE CodCia           = nCodCia
               AND CodEntidad       = cCodEntidad
               AND Correlativo      = nCorrelativo
               AND CodRespuesta     = cCodRespuesta
               AND CodTipoRespuesta = cCodTipoRespuesta;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                nNumHorasIntervalo := 0;            
        END;
        RETURN nNumHorasIntervalo;
    END HORAS_INTERVALO;
    
    FUNCTION REINTENTOS_INTERVALO (nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, 
                                  nCorrelativo IN NUMBER, cCodRespuesta IN VARCHAR2,
                                  cCodTipoRespuesta IN VARCHAR2) RETURN NUMBER IS
        nNumReintentosIntervalo  CAT_RESPUESTA_WEBTRANSFER.NumReintentosIntervalo%TYPE;
    BEGIN
        BEGIN
            SELECT NVL(NumReintentosIntervalo,0)
              INTO nNumReintentosIntervalo
              FROM CAT_RESPUESTA_WEBTRANSFER
             WHERE CodCia           = nCodCia
               AND CodEntidad       = cCodEntidad
               AND Correlativo      = nCorrelativo
               AND CodRespuesta     = cCodRespuesta
               AND CodTipoRespuesta = cCodTipoRespuesta;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                nNumReintentosIntervalo := 0;            
        END;
        RETURN nNumReintentosIntervalo;
    END REINTENTOS_INTERVALO;
    
    FUNCTION EXISTE_CONFIG(nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, nCorrelativo IN NUMBER) RETURN VARCHAR2 IS
        cExiste VARCHAR2(1);
    BEGIN 
        BEGIN
            SELECT 'S'
              INTO cExiste
              FROM CAT_RESPUESTA_WEBTRANSFER
             WHERE CodCia           = nCodCia
               AND CodEntidad       = cCodEntidad
               AND Correlativo      = nCorrelativo;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                cExiste := 'N';
            WHEN TOO_MANY_ROWS THEN
                cExiste := 'S';
        END;
        RETURN cExiste;
    END EXISTE_CONFIG;
    
END GT_CAT_RESPUESTA_WEBTRANSFER;
/

--
-- GT_CAT_RESPUESTA_WEBTRANSFER  (Synonym) 
--
--  Dependencies: 
--   GT_CAT_RESPUESTA_WEBTRANSFER (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_CAT_RESPUESTA_WEBTRANSFER FOR SICAS_OC.GT_CAT_RESPUESTA_WEBTRANSFER
/


GRANT EXECUTE ON SICAS_OC.GT_CAT_RESPUESTA_WEBTRANSFER TO PUBLIC
/
