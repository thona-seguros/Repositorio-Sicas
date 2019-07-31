--
-- OC_AGENTES_CEDULA_AUTORIZADA  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   AGENTES_CEDULA_AUTORIZADA (Table)
--   OC_AGENTES (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_AGENTES_CEDULA_AUTORIZADA IS

  FUNCTION CEDULA_VIGENTE(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAgente NUMBER, dFecVigencia DATE) RETURN VARCHAR2;
  FUNCTION NUMERO_CEDULA(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAgente NUMBER, dFecVigencia DATE) RETURN VARCHAR2;
  FUNCTION VENCIMIENTO_CEDULA(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAgente NUMBER, cNumCedula VARCHAR2) RETURN VARCHAR2;
  FUNCTION POLIZA_RC_VIGENTE(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAgente NUMBER, dFecVigencia DATE) RETURN VARCHAR2;
  FUNCTION POLIZA_RC(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAgente NUMBER, cNumCedula VARCHAR2) RETURN VARCHAR2;
  FUNCTION VENCIMIENTO_POLIZA_RC(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAgente NUMBER, cNumCedula VARCHAR2) RETURN VARCHAR2;
END OC_AGENTES_CEDULA_AUTORIZADA;
/

--
-- OC_AGENTES_CEDULA_AUTORIZADA  (Package Body) 
--
--  Dependencies: 
--   OC_AGENTES_CEDULA_AUTORIZADA (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_AGENTES_CEDULA_AUTORIZADA IS

FUNCTION CEDULA_VIGENTE(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAgente NUMBER, dFecVigencia DATE) RETURN VARCHAR2 IS
cVigente    VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cVigente
        FROM AGENTES_CEDULA_AUTORIZADA
       WHERE CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND Cod_Agente      = nCodAgente
         AND FecVencimiento >= dFecVigencia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         IF OC_AGENTES.NIVEL_AGENTE(nCodCia, nCodAgente) != 5 THEN
            cVigente := 'N';
         ELSE
            cVigente := 'S';
         END IF;
      WHEN TOO_MANY_ROWS THEN
         cVigente := 'S';
   END;
   RETURN(cVigente);
END CEDULA_VIGENTE;

FUNCTION NUMERO_CEDULA(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAgente NUMBER, dFecVigencia DATE) RETURN VARCHAR2 IS
cNumCedula    AGENTES_CEDULA_AUTORIZADA.NumCedula%TYPE;
BEGIN
   BEGIN
      SELECT NumCedula
        INTO cNumCedula
        FROM AGENTES_CEDULA_AUTORIZADA
       WHERE CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND Cod_Agente      = nCodAgente
         AND FecVencimiento >= dFecVigencia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNumCedula := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Agente No. ' || nCodAgente || ' Posee Varias Cédulas Vigentes.');
   END;
   RETURN(cNumCedula);
END NUMERO_CEDULA;

FUNCTION VENCIMIENTO_CEDULA(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAgente NUMBER, cNumCedula VARCHAR2) RETURN VARCHAR2 IS
dFecVencimiento    AGENTES_CEDULA_AUTORIZADA.FecVencimiento%TYPE;
BEGIN
   SELECT MAX(FecVencimiento)
     INTO dFecVencimiento
     FROM AGENTES_CEDULA_AUTORIZADA
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND Cod_Agente   = nCodAgente
      AND NumCedula    = cNumCedula;
   RETURN(dFecVencimiento);
END VENCIMIENTO_CEDULA;

FUNCTION POLIZA_RC_VIGENTE(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAgente NUMBER, dFecVigencia DATE) RETURN VARCHAR2 IS
cVigente    VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cVigente
        FROM AGENTES_CEDULA_AUTORIZADA
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND Cod_Agente     = nCodAgente
         AND FecVencPolRC  >= dFecVigencia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         IF OC_AGENTES.NIVEL_AGENTE(nCodCia, nCodAgente) != 5 THEN
            cVigente := 'N';
         ELSE
            cVigente := 'S';
         END IF;
      WHEN TOO_MANY_ROWS THEN
         cVigente := 'S';
   END;
   RETURN(cVigente);
END POLIZA_RC_VIGENTE;

FUNCTION POLIZA_RC(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAgente NUMBER, cNumCedula VARCHAR2) RETURN VARCHAR2 IS
cNumPolRC    AGENTES_CEDULA_AUTORIZADA.NumPolRC%TYPE;
BEGIN
   BEGIN
      SELECT NumPolRC
        INTO cNumPolRC
        FROM AGENTES_CEDULA_AUTORIZADA
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND Cod_Agente    = nCodAgente
         AND NumCedula     = cNumCedula;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNumPolRC := 'NO TIENE POLIZA';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Agente No. ' || nCodAgente || ' Posee Varias Cédulas Vigentes. ' ||
                                 'No se puede determinar la Póliza RC Vigente.');
   END;
   RETURN(cNumPolRC);
END POLIZA_RC;

FUNCTION VENCIMIENTO_POLIZA_RC(nCodCia NUMBER, nCodEmpresa NUMBER, nCodAgente NUMBER, cNumCedula VARCHAR2) RETURN VARCHAR2 IS
dFecVencPolRC    AGENTES_CEDULA_AUTORIZADA.FecVencPolRC%TYPE;
BEGIN
   BEGIN
      SELECT FecVencPolRC
        INTO dFecVencPolRC
        FROM AGENTES_CEDULA_AUTORIZADA
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND Cod_Agente    = nCodAgente
         AND NumCedula     = cNumCedula;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         dFecVencPolRC := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Agente No. ' || nCodAgente || ' Posee Varias Cédulas Vigentes. ' ||
                                 'No se puede determinar la Fecha de Vencimiento de la Póliza RC Vigente.');
   END;
   RETURN(dFecVencPolRC);
END VENCIMIENTO_POLIZA_RC;

END OC_AGENTES_CEDULA_AUTORIZADA;
/
