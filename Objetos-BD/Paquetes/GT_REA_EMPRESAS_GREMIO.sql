CREATE OR REPLACE PACKAGE GT_REA_EMPRESAS_GREMIO IS
  PROCEDURE ACTIVAR_EMPRESA(nCodCia NUMBER, cCodEmpresaGremio VARCHAR2);
  PROCEDURE SUSPENDER_EMPRESA(nCodCia NUMBER, cCodEmpresaGremio VARCHAR2);
  PROCEDURE BLOQUEAR_EMPRESA(nCodCia NUMBER, cCodEmpresaGremio VARCHAR2, 
                             cCodMotivBloqueo VARCHAR2, dFecBloqueo DATE);
  FUNCTION NOMBRE_EMPRESA(nCodCia NUMBER, cCodEmpresaGremio VARCHAR2) RETURN VARCHAR2;
  FUNCTION LICENCIA(nCodCia NUMBER, cCodEmpresaGremio VARCHAR2) RETURN VARCHAR2;
  FUNCTION TIPO_EMPRESA(nCodCia NUMBER, cCodEmpresaGremio VARCHAR2) RETURN VARCHAR2;
  FUNCTION CODIGO_OFICIAL(nCodCia NUMBER, cCodEmpresaGremio VARCHAR2) RETURN VARCHAR2;
  FUNCTION AGENCIA_CALIFICADORA(nCodCia NUMBER, cCodEmpresaGremio VARCHAR2) RETURN VARCHAR2;
  FUNCTION CODIGO_CALIFICACION(nCodCia NUMBER, cCodEmpresaGremio VARCHAR2) RETURN VARCHAR2;
END GT_REA_EMPRESAS_GREMIO;
/

CREATE OR REPLACE PACKAGE BODY GT_REA_EMPRESAS_GREMIO IS

PROCEDURE ACTIVAR_EMPRESA(nCodCia NUMBER, cCodEmpresaGremio VARCHAR2) IS
BEGIN
   UPDATE REA_EMPRESAS_GREMIO
      SET StsEmpresa      = 'ACTIVA',
          FecStatus       = TRUNC(SYSDATE),
          CodMotivBloqueo = NULL,
          FecBloqueo      = NULL
    WHERE CodCia           = nCodCia
      AND CodEmpresaGremio = cCodEmpresaGremio;
END ACTIVAR_EMPRESA;

PROCEDURE SUSPENDER_EMPRESA(nCodCia NUMBER, cCodEmpresaGremio VARCHAR2) IS
BEGIN
   UPDATE REA_EMPRESAS_GREMIO
      SET StsEmpresa = 'SUSPEN',
          FecStatus  = TRUNC(SYSDATE)
    WHERE CodCia           = nCodCia
      AND CodEmpresaGremio = cCodEmpresaGremio;
END SUSPENDER_EMPRESA;

PROCEDURE BLOQUEAR_EMPRESA(nCodCia NUMBER, cCodEmpresaGremio VARCHAR2, 
                           cCodMotivBloqueo VARCHAR2, dFecBloqueo DATE) IS
BEGIN
   UPDATE REA_EMPRESAS_GREMIO
      SET StsEmpresa      = 'BLOQUE',
          FecStatus       = TRUNC(SYSDATE),
          CodMotivBloqueo = cCodMotivBloqueo,
          FecBloqueo      = dFecBloqueo
    WHERE CodCia           = nCodCia
      AND CodEmpresaGremio = cCodEmpresaGremio;
END BLOQUEAR_EMPRESA;

FUNCTION NOMBRE_EMPRESA(nCodCia NUMBER, cCodEmpresaGremio VARCHAR2) RETURN VARCHAR2 IS
cNomEmpresa       VARCHAR2(500);
BEGIN
   BEGIN
      SELECT TRIM(Nombre) || ' ' || TRIM(Apellido) || ' ' || TRIM(ApeCasada)
        INTO cNomEmpresa
        FROM PERSONA_NATURAL_JURIDICA
       WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN
             (SELECT Tipo_Doc_Identificacion, Num_Doc_Identificacion
                FROM REA_EMPRESAS_GREMIO
               WHERE CodCia           = nCodCia
                 AND CodEmpresaGremio = cCodEmpresaGremio);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNomEmpresa:= 'Empresa del Gremio - NO EXISTE!!!';
   END;
   RETURN(cNomEmpresa);
END NOMBRE_EMPRESA;

FUNCTION LICENCIA(nCodCia NUMBER, cCodEmpresaGremio VARCHAR2) RETURN VARCHAR2 IS
cNumLicencia       REA_EMPRESAS_GREMIO.NumLicencia%TYPE;
BEGIN
   BEGIN
      SELECT NVL(NumLicencia,'SIN LICENCIA')
        INTO cNumLicencia
        FROM REA_EMPRESAS_GREMIO
       WHERE CodCia           = nCodCia
         AND CodEmpresaGremio = cCodEmpresaGremio;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNumLicencia := 'SIN LICENCIA';
   END;
   RETURN(cNumLicencia);
END LICENCIA;

FUNCTION TIPO_EMPRESA(nCodCia NUMBER, cCodEmpresaGremio VARCHAR2) RETURN VARCHAR2 IS
cTipoEmpresa      REA_EMPRESAS_GREMIO.TipoEmpresa%TYPE;
BEGIN
   BEGIN
      SELECT TipoEmpresa
        INTO cTipoEmpresa
        FROM REA_EMPRESAS_GREMIO
       WHERE CodCia           = nCodCia
         AND CodEmpresaGremio = cCodEmpresaGremio;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTipoEmpresa      := NULL;
   END;
   RETURN(cTipoEmpresa);
END TIPO_EMPRESA;

FUNCTION CODIGO_OFICIAL(nCodCia NUMBER, cCodEmpresaGremio VARCHAR2) RETURN VARCHAR2 IS
cCodOficial       REA_EMPRESAS_GREMIO.CodOficial%TYPE;
BEGIN
   BEGIN
      SELECT CodOficial
        INTO cCodOficial
        FROM REA_EMPRESAS_GREMIO
       WHERE CodCia           = nCodCia
         AND CodEmpresaGremio = cCodEmpresaGremio;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodOficial := NULL;
   END;
   RETURN(cCodOficial);
END CODIGO_OFICIAL;

FUNCTION AGENCIA_CALIFICADORA(nCodCia NUMBER, cCodEmpresaGremio VARCHAR2) RETURN VARCHAR2 IS
cCodAgenciaCalif       REA_EMPRESAS_GREMIO.CodAgenciaCalif%TYPE;
BEGIN
   BEGIN
      SELECT CodAgenciaCalif
        INTO cCodAgenciaCalif
        FROM REA_EMPRESAS_GREMIO
       WHERE CodCia           = nCodCia
         AND CodEmpresaGremio = cCodEmpresaGremio;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodAgenciaCalif := NULL;
   END;
   RETURN(cCodAgenciaCalif);
END AGENCIA_CALIFICADORA;

FUNCTION CODIGO_CALIFICACION(nCodCia NUMBER, cCodEmpresaGremio VARCHAR2) RETURN VARCHAR2 IS
cCodCalificacion       REA_EMPRESAS_GREMIO.CodCalificacion%TYPE;
BEGIN
   BEGIN
      SELECT CodCalificacion
        INTO cCodCalificacion
        FROM REA_EMPRESAS_GREMIO
       WHERE CodCia           = nCodCia
         AND CodEmpresaGremio = cCodEmpresaGremio;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodCalificacion := NULL;
   END;
   RETURN(cCodCalificacion);
END CODIGO_CALIFICACION;

END GT_REA_EMPRESAS_GREMIO;
