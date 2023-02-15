CREATE OR REPLACE PACKAGE OC_ENTREGAS_CNSF_DATOS IS
FUNCTION DATOS_INSTITUCION(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoEntrega VARCHAR2, cTipoDato VARCHAR2) RETURN VARCHAR2;
FUNCTION FECHAS_INSTITUCION(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoEntrega VARCHAR2, cTipoDato VARCHAR2) RETURN DATE;
FUNCTION DATOS_RESPONSABLE(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoEntrega VARCHAR2, cTipoDato VARCHAR2) RETURN VARCHAR2;
FUNCTION DATOS_DESTINATARIO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoEntrega VARCHAR2, cTipoDato VARCHAR2) RETURN VARCHAR2;
END OC_ENTREGAS_CNSF_DATOS;
/

CREATE OR REPLACE PACKAGE BODY OC_ENTREGAS_CNSF_DATOS IS

FUNCTION DATOS_INSTITUCION(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoEntrega VARCHAR2, cTipoDato VARCHAR2) RETURN VARCHAR2 IS
cNomEmpresa       ENTREGAS_CNSF_DATOS.NomEmpresa%TYPE;
cDirecEmpresa     ENTREGAS_CNSF_DATOS.DirecEmpresa%TYPE;
cNumClave         ENTREGAS_CNSF_DATOS.NumClave%TYPE;
cIndFilial        ENTREGAS_CNSF_DATOS.IndFilial%TYPE;
cNomFilial        ENTREGAS_CNSF_DATOS.NomFilial%TYPE;
cNomPresidente    ENTREGAS_CNSF_DATOS.NomPresidente%TYPE;
cNomGerente       ENTREGAS_CNSF_DATOS.NomGerente%TYPE;
BEGIN
   BEGIN
      SELECT NomEmpresa, DirecEmpresa, NumClave, IndFilial, 
             NomFilial, NomPresidente, NomGerente
        INTO cNomEmpresa, cDirecEmpresa, cNumClave, cIndFilial, 
             cNomFilial, cNomPresidente, cNomGerente
        FROM ENTREGAS_CNSF_DATOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND TipoEntrega = cTipoEntrega;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN(NULL);
   END;
   IF cTipoDato = 'NOM' THEN
      RETURN(cNomEmpresa);
   ELSIF cTipoDato = 'DIR' THEN
      RETURN(cDirecEmpresa);
   ELSIF cTipoDato = 'CLA' THEN
      RETURN(cNumClave);
   ELSIF cTipoDato = 'FIL' THEN
      RETURN(cIndFilial);
   ELSIF cTipoDato = 'NFI' THEN
      RETURN(cNomFilial);
   ELSIF cTipoDato = 'PRE' THEN
      RETURN(cNomPresidente);
   ELSIF cTipoDato = 'GER' THEN
      RETURN(cNomGerente);
   ELSE
      RETURN(NULL);
   END IF;
END DATOS_INSTITUCION;

FUNCTION FECHAS_INSTITUCION(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoEntrega VARCHAR2, cTipoDato VARCHAR2) RETURN DATE IS
dFecFundacion     ENTREGAS_CNSF_DATOS.FecFundacion%TYPE;
dFecUltCambio     ENTREGAS_CNSF_DATOS.FecUltCambio%TYPE;
BEGIN
   BEGIN
      SELECT FecFundacion, FecUltCambio
        INTO dFecFundacion, dFecUltCambio
        FROM ENTREGAS_CNSF_DATOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND TipoEntrega = cTipoEntrega;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN(NULL);
   END;
   IF cTipoDato = 'FUN' THEN
      RETURN(dFecFundacion);
   ELSIF cTipoDato = 'CAM' THEN
      RETURN(dFecUltCambio);
   ELSE
      RETURN(NULL);
   END IF;
END FECHAS_INSTITUCION;

FUNCTION DATOS_RESPONSABLE(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoEntrega VARCHAR2, cTipoDato VARCHAR2) RETURN VARCHAR2 IS
cNombreResp       ENTREGAS_CNSF_DATOS.NombreResp%TYPE;
cPuestoResp       ENTREGAS_CNSF_DATOS.PuestoResp%TYPE;
cNomDepResp       ENTREGAS_CNSF_DATOS.NomDepResp%TYPE;
cNumTelResp       ENTREGAS_CNSF_DATOS.NumTelResp%TYPE;
cCedulaProfResp   ENTREGAS_CNSF_DATOS.CedulaProfResp%TYPE;
BEGIN
   BEGIN
      SELECT NombreResp, PuestoResp, NomDepResp, NumTelResp, CedulaProfResp
        INTO cNombreResp, cPuestoResp, cNomDepResp, cNumTelResp, cCedulaProfResp
        FROM ENTREGAS_CNSF_DATOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND TipoEntrega = cTipoEntrega;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN(NULL);
   END;
   IF cTipoDato = 'NOM' THEN
      RETURN(cNombreResp);
   ELSIF cTipoDato = 'PUE' THEN
      RETURN(cPuestoResp);
   ELSIF cTipoDato = 'DEP' THEN
      RETURN(cNomDepResp);
   ELSIF cTipoDato = 'TEL' THEN
      RETURN(cNumTelResp);
   ELSIF cTipoDato = 'CED' THEN
      RETURN(cCedulaProfResp);
   ELSE
      RETURN(NULL);
   END IF;
END DATOS_RESPONSABLE;

FUNCTION DATOS_DESTINATARIO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoEntrega VARCHAR2, cTipoDato VARCHAR2) RETURN VARCHAR2 IS
cNomDestCNSF      ENTREGAS_CNSF_DATOS.NomDestCNSF%TYPE;
cPuestoDestCNSF   ENTREGAS_CNSF_DATOS.PuestoDestCNSF%TYPE;
BEGIN
   BEGIN
      SELECT NomDestCNSF, PuestoDestCNSF
        INTO cNomDestCNSF, cPuestoDestCNSF
        FROM ENTREGAS_CNSF_DATOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND TipoEntrega = cTipoEntrega;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN(NULL);
   END;
   IF cTipoDato = 'NOM' THEN
      RETURN(cNomDestCNSF);
   ELSIF cTipoDato = 'PUE' THEN
      RETURN(cPuestoDestCNSF);
   ELSE
      RETURN(NULL);
   END IF;
END DATOS_DESTINATARIO;

END OC_ENTREGAS_CNSF_DATOS;
