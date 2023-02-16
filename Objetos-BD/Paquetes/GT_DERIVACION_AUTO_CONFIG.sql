CREATE OR REPLACE PACKAGE          GT_DERIVACION_AUTO_CONFIG AS
    FUNCTION NUMERO_CONFIGURACION (nCodCia IN NUMBER) RETURN NUMBER;
    FUNCTION AUTOMATICO(nCodCia IN NUMBER, cCodTipoDerivacion IN VARCHAR2, cTipoComprob IN VARCHAR2) RETURN VARCHAR2;
    FUNCTION EXISTE_ACTIVA (nCodCia IN NUMBER, nIdConfDer IN NUMBER, cCodTipoDerivacion IN VARCHAR2, cTipoComprob IN VARCHAR2) RETURN VARCHAR2;
    PROCEDURE ENVIAR_CORREOS(nCodCia IN NUMBER, cCodTipoDerivacion IN VARCHAR2, cTipoComprob IN VARCHAR2, cPara IN OUT VARCHAR2, cCC IN OUT VARCHAR2);
    PROCEDURE ACTIVAR (nCodCia IN NUMBER, nIdConfDer IN NUMBER);
    PROCEDURE CONFIGURAR (nCodCia IN NUMBER, nIdConfDer IN NUMBER);
    PROCEDURE SUSPENDER (nCodCia IN NUMBER, nIdConfDer IN NUMBER);
END GT_DERIVACION_AUTO_CONFIG;
/

CREATE OR REPLACE PACKAGE BODY          GT_DERIVACION_AUTO_CONFIG AS
    FUNCTION NUMERO_CONFIGURACION (nCodCia IN NUMBER) RETURN NUMBER IS
        nIdConfDer  DERIVACION_AUTO_CONFIG.IdConfDer%TYPE;
    BEGIN 
        SELECT NVL(MAX(IdConfDer),0) + 1
          INTO nIdConfDer
          FROM DERIVACION_AUTO_CONFIG
         WHERE CodCia = nCodCia;
        RETURN nIdConfDer;
    END NUMERO_CONFIGURACION;
    
    FUNCTION AUTOMATICO(nCodCia IN NUMBER, cCodTipoDerivacion IN VARCHAR2, cTipoComprob IN VARCHAR2) RETURN VARCHAR2 IS
        cIndDerivaAuto VARCHAR2(1);
    BEGIN
        BEGIN
            SELECT NVL(IndDerivaAuto,'N')
              INTO cIndDerivaAuto
              FROM DERIVACION_AUTO_CONFIG
             WHERE CodCia               = nCodCia
               AND CodTipoDerivacion    = cCodTipoDerivacion
               AND TipoComprob          = cTipoComprob
               AND StsConfig            = 'ACTIVA';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN 
                cIndDerivaAuto := 'N';
        END;
        RETURN cIndDerivaAuto;
    END AUTOMATICO;
    
    PROCEDURE ENVIAR_CORREOS(nCodCia IN NUMBER, cCodTipoDerivacion IN VARCHAR2, cTipoComprob IN VARCHAR2, cPara IN OUT VARCHAR2, cCC IN OUT VARCHAR2) IS
    BEGIN 
        BEGIN
            SELECT EMAILNOTIFICADEST,
                   EMAILNOTIFICACC
              INTO cPara,
                   cCC
              FROM DERIVACION_AUTO_CONFIG
             WHERE CodCia               = nCodCia
               AND CodTipoDerivacion    = cCodTipoDerivacion
               AND TipoComprob          = cTipoComprob;               
        EXCEPTION
            WHEN NO_DATA_FOUND THEN 
                cPara := null;
                cCC := null;
        END;        
    END ENVIAR_CORREOS;
    
    FUNCTION EXISTE_ACTIVA (nCodCia IN NUMBER, nIdConfDer IN NUMBER, cCodTipoDerivacion IN VARCHAR2, cTipoComprob IN VARCHAR2) RETURN VARCHAR2 IS
        cExiste VARCHAR2(1);
    BEGIN
        BEGIN
            SELECT 'S'
              INTO cExiste
              FROM DERIVACION_AUTO_CONFIG
             WHERE CodCia               = nCodCia
               AND CodTipoDerivacion    = cCodTipoDerivacion
               AND TipoComprob          = cTipoComprob
               AND IdConfDer           <> nIdConfDer
               AND StsConfig            = 'ACTIVA';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN 
                cExiste := 'N';
            WHEN TOO_MANY_ROWS THEN
                cExiste := 'S';
        END;
        RETURN cExiste;
    END EXISTE_ACTIVA;
    
    PROCEDURE ACTIVAR (nCodCia IN NUMBER, nIdConfDer IN NUMBER) IS
    BEGIN 
        UPDATE DERIVACION_AUTO_CONFIG
           SET StsConfig    = 'ACTIVA',
               CodUsuario   = USER,
               FechaConfig  = TRUNC(SYSDATE)
         WHERE CodCia       = nCodCia
           AND IdConfDer    = nIdConfDer;               
    END ACTIVAR;
    
    PROCEDURE CONFIGURAR (nCodCia IN NUMBER, nIdConfDer IN NUMBER) IS
    BEGIN 
        UPDATE DERIVACION_AUTO_CONFIG
           SET StsConfig    = 'CONFIG',
               CodUsuario   = USER,
               FechaConfig  = TRUNC(SYSDATE)
         WHERE CodCia       = nCodCia
           AND IdConfDer    = nIdConfDer;               
    END CONFIGURAR;
    
    PROCEDURE SUSPENDER (nCodCia IN NUMBER, nIdConfDer IN NUMBER) IS
    BEGIN 
        UPDATE DERIVACION_AUTO_CONFIG
           SET StsConfig    = 'SUSPEN',
               CodUsuario   = USER,
               FechaConfig  = TRUNC(SYSDATE)
         WHERE CodCia       = nCodCia
           AND IdConfDer    = nIdConfDer;               
    END SUSPENDER;
    
END GT_DERIVACION_AUTO_CONFIG;
