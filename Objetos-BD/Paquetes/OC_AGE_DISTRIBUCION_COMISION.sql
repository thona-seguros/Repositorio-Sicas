CREATE OR REPLACE PACKAGE          oc_age_distribucion_comision IS
  PROCEDURE BORRAR_REGISTRO(nCodCia NUMBER, nIdPoliza NUMBER);
  FUNCTION  PORCENTAJE_DISTRIBUCION(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodNivel NUMBER, nCodAgente NUMBER) RETURN NUMBER;
  FUNCTION  AGENTE_DISTR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodNivel NUMBER, nCodAgente NUMBER) RETURN NUMBER;
END OC_AGE_DISTRIBUCION_COMISION;
 
/

CREATE OR REPLACE PACKAGE BODY          oc_age_distribucion_comision IS
PROCEDURE BORRAR_REGISTRO(nCodCia NUMBER, nIdPoliza NUMBER) IS
BEGIN
   DELETE AGENTES_DISTRIBUCION_COMISION
     WHERE CodCia = nCodCia 
       AND IdPoliza =  nIdPoliza;
END BORRAR_REGISTRO;

FUNCTION  PORCENTAJE_DISTRIBUCION(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodNivel NUMBER, nCodAgente NUMBER) RETURN NUMBER IS
    nPorcComDist AGENTES_DISTRIBUCION_COMISION.PORC_COM_DISTRIBUIDA%TYPE;
BEGIN
    BEGIN
        SELECT NVL(Porc_Com_Distribuida,0)
          INTO nPorcComDist
          FROM AGENTES_DISTRIBUCION_COMISION
         WHERE CodCia       = nCodCia
           AND IdPoliza     = nIdPoliza
           AND IDetPol      = nIDetPol
           AND Cod_Agente   = nCodAgente
           AND CodNivel     = nCodNivel;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            nPorcComDist := 0;
    END;
    RETURN nPorcComDist;
END PORCENTAJE_DISTRIBUCION;

FUNCTION  AGENTE_DISTR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodNivel NUMBER, nCodAgente NUMBER) RETURN NUMBER IS
    nCodAgentDistr AGENTES_DISTRIBUCION_COMISION.COD_AGENTE_DISTR%TYPE;
BEGIN
    BEGIN
        SELECT NVL(COD_AGENTE_DISTR,0)
          INTO nCodAgentDistr
          FROM AGENTES_DISTRIBUCION_COMISION
         WHERE CodCia       = nCodCia
           AND IdPoliza     = nIdPoliza
           AND IDetPol      = nIDetPol
           AND Cod_Agente   = nCodAgente
           AND CodNivel     = nCodNivel;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            nCodAgentDistr := 0;
    END;
    RETURN nCodAgentDistr;
END AGENTE_DISTR;

END OC_AGE_DISTRIBUCION_COMISION;
