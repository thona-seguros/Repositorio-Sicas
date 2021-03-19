create or replace PACKAGE sicas_oc.oc_clausulas IS

  FUNCTION DESCRIPCION(nCodCia NUMBER, nCodEmpresa NUMBER, cCodClausula VARCHAR2) RETURN VARCHAR2;
  FUNCTION OBLIGATORIA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodClausula VARCHAR2) RETURN VARCHAR2;
  FUNCTION TIPO_CLAUSULA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodClausula VARCHAR2) RETURN VARCHAR2;
  FUNCTION TIPO_ADMINISTRACION(nCodCia NUMBER, nCodEmpresa NUMBER, cCodClausula VARCHAR2) RETURN VARCHAR2;
  FUNCTION APLICA_ADMINISTRACION(nCodCia NUMBER, nCodEmpresa NUMBER, cCodClausula VARCHAR2) RETURN VARCHAR2;
  FUNCTION TEXTOCLAUSULA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodClausula VARCHAR2) RETURN VARCHAR2;
END OC_CLAUSULAS;
/
create or replace PACKAGE BODY sicas_oc.oc_clausulas IS

FUNCTION DESCRIPCION(nCodCia NUMBER, nCodEmpresa NUMBER, cCodClausula VARCHAR2) RETURN VARCHAR2 IS
cDescClausula    CLAUSULAS.DescClausula%TYPE;
BEGIN
   BEGIN
      SELECT DescClausula
        INTO cDescClausula
        FROM CLAUSULAS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND CodClausula = cCodClausula;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescClausula := 'NO EXISTE';
   END;
   RETURN(cDescClausula);
END DESCRIPCION;

FUNCTION OBLIGATORIA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodClausula VARCHAR2) RETURN VARCHAR2 IS
cIndOblig    CLAUSULAS.IndOblig%TYPE;
BEGIN
   BEGIN
      SELECT IndOblig
        INTO cIndOblig
        FROM CLAUSULAS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND CodClausula = cCodClausula;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndOblig := 'N';
   END;
   RETURN(cIndOblig);
END OBLIGATORIA;

FUNCTION TIPO_CLAUSULA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodClausula VARCHAR2) RETURN VARCHAR2 IS
cIndTipoClausula    CLAUSULAS.IndTipoClausula%TYPE;
BEGIN
   BEGIN
      SELECT IndTipoClausula
        INTO cIndTipoClausula
        FROM CLAUSULAS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND CodClausula = cCodClausula;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndTipoClausula := NULL;
   END;
   RETURN(cIndTipoClausula);
END TIPO_CLAUSULA;

FUNCTION APLICA_ADMINISTRACION(nCodCia NUMBER, nCodEmpresa NUMBER, cCodClausula VARCHAR2) RETURN VARCHAR2 IS
cAplicaTipoAdministracion   CLAUSULAS.AplicaTipoAdministracion%TYPE;
BEGIN
   BEGIN
      SELECT AplicaTipoAdministracion
        INTO cAplicaTipoAdministracion
        FROM CLAUSULAS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND CodClausula = cCodClausula;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cAplicaTipoAdministracion := 'N';
   END;
   RETURN(cAplicaTipoAdministracion);
END APLICA_ADMINISTRACION;




FUNCTION TIPO_ADMINISTRACION(nCodCia NUMBER, nCodEmpresa NUMBER, cCodClausula VARCHAR2) RETURN VARCHAR2 IS
cTipoAdminsitracionClausula    CLAUSULAS.TipoAdMINISTRACION%TYPE;
BEGIN
   BEGIN
      SELECT TipoAdministracion
        INTO cTipoAdminsitracionClausula
        FROM CLAUSULAS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND CodClausula = cCodClausula;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
          cTipoAdminsitracionClausula := null;
   END;
   RETURN( cTipoAdminsitracionClausula);
END TIPO_ADMINISTRACION;

FUNCTION TEXTOCLAUSULA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodClausula VARCHAR2) RETURN VARCHAR2 IS
   cTextoClausula   LONG;
BEGIN
   BEGIN
      SELECT TextoClausula
        INTO cTextoClausula
        FROM CLAUSULAS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND CodClausula = cCodClausula;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTextoClausula := 'NO EXISTE';
   END;
   RETURN(SUBSTR(cTextoClausula, 1, 4000));
END TEXTOCLAUSULA;

END OC_CLAUSULAS;
/