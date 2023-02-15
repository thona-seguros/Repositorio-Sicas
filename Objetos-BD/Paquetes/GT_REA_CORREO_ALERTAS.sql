CREATE OR REPLACE PACKAGE GT_REA_CORREO_ALERTAS IS

FUNCTION NUMERO_ALERTA(nCodCia           NUMBER, 
                       cCodEsquema       VARCHAR2, 
					   nIdEsqContrato    NUMBER,
                       nIdCapaContrato   NUMBER, 
					   cCodEmpresaGremio VARCHAR2, 
                       cCodInterReaseg   VARCHAR2,
					   cIdCalendario     NUMBER) RETURN NUMBER;

END GT_REA_CORREO_ALERTAS;
/

CREATE OR REPLACE PACKAGE BODY GT_REA_CORREO_ALERTAS IS

FUNCTION NUMERO_ALERTA(nCodCia           NUMBER, 
                       cCodEsquema       VARCHAR2, 
					   nIdEsqContrato    NUMBER,
                       nIdCapaContrato   NUMBER, 
					   cCodEmpresaGremio VARCHAR2, 
                       cCodInterReaseg   VARCHAR2,
					   cIdCalendario     NUMBER) RETURN NUMBER IS
nIdAlerta      REA_CORREO_ALERTAS.IdAlerta%TYPE;
BEGIN
   SELECT NVL(MAX(IdAlerta),0) + 1
     INTO nIdAlerta
     FROM REA_CORREO_ALERTAS
    WHERE CodCia           = nCodCia
      AND CodEsquema       = cCodEsquema
      AND IdEsqContrato    = nIdEsqContrato
      AND IdCapaContrato   = nIdCapaContrato
      AND CodEmpresaGremio = cCodEmpresaGremio
      AND CodInterReaseg   = cCodInterReaseg
      AND IdCalendario     = cIdCalendario;
   RETURN(nIdAlerta);
END NUMERO_ALERTA;

END GT_REA_CORREO_ALERTAS;
