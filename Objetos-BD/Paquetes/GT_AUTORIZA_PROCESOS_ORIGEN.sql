CREATE OR REPLACE PACKAGE GT_AUTORIZA_PROCESOS_ORIGEN AS
    FUNCTION NUMERO_ORIGEN(nCodCia NUMBER) RETURN NUMBER;
    FUNCTION CODIGO_APLICACION(nCodCia NUMBER,nIdOrigen NUMBER) RETURN VARCHAR2;
    PROCEDURE CREAR (nCodCia NUMBER, nIdObjeto NUMBER, nIdObjetoPrincipal NUMBER, 
                     cCampoLlave VARCHAR2,cCodAplica VARCHAR2);
END GT_AUTORIZA_PROCESOS_ORIGEN;
/

CREATE OR REPLACE PACKAGE BODY GT_AUTORIZA_PROCESOS_ORIGEN AS
    FUNCTION NUMERO_ORIGEN(nCodCia NUMBER) RETURN NUMBER IS
        nIdOrigen AUTORIZA_PROCESOS_ORIGEN.IdOrigen%TYPE;
    BEGIN
        SELECT NVL(MAX(IdOrigen),0) + 1
          INTO nIdOrigen  
          FROM AUTORIZA_PROCESOS_ORIGEN
         WHERE CodCia = nCodCia;
         
        RETURN nIdOrigen;
    END NUMERO_ORIGEN;
    --
    FUNCTION CODIGO_APLICACION(nCodCia NUMBER,nIdOrigen NUMBER) RETURN VARCHAR2 IS
        cCodAplica AUTORIZA_PROCESOS_ORIGEN.CodAplica%TYPE;
    BEGIN
        SELECT CodAplica
          INTO cCodAplica  
          FROM AUTORIZA_PROCESOS_ORIGEN
         WHERE CodCia   = nCodCia
           AND IdOrigen = nIdOrigen;
         
        RETURN cCodAplica;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20225,'No Existe Configurada la Aplicaci�n Orgien Para su Autorizaci�n, Por Favor Comuniquese con su �rea de Sistemas');
    END CODIGO_APLICACION;
    --
    PROCEDURE CREAR (nCodCia NUMBER, nIdObjeto NUMBER, nIdObjetoPrincipal NUMBER, 
                     cCampoLlave VARCHAR2,cCodAplica VARCHAR2) IS
        nIdOrigen AUTORIZA_PROCESOS_ORIGEN.IdOrigen%TYPE;
    BEGIN
        nIdOrigen := GT_AUTORIZA_PROCESOS_ORIGEN.NUMERO_ORIGEN(nCodCia);
        INSERT INTO AUTORIZA_PROCESOS_ORIGEN(CodCia,            IdOrigen,   IdObjeto, 
                                             IdObjetoPrincipal, CampoLlave, CodAplica)
                                      VALUES(nCodCia,           nIdOrigen,  nIdObjeto,    
                                             nIdObjetoPrincipal,cCampoLlave,cCodAplica);
    END;
END GT_AUTORIZA_PROCESOS_ORIGEN;