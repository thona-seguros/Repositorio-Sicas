CREATE OR REPLACE PACKAGE GT_COTIZADOR_CLAUSULAS IS

  PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, cCodClausula VARCHAR2);
  PROCEDURE CONFIGURAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, cCodClausula VARCHAR2);
  PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, cCodClausula VARCHAR2);
  PROCEDURE COPIAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizadorOrig VARCHAR2, cCodCotizadorDest VARCHAR2);
  FUNCTION EXISTEN_CLAUSULAS(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN VARCHAR2;

END GT_COTIZADOR_CLAUSULAS;
/

CREATE OR REPLACE PACKAGE BODY GT_COTIZADOR_CLAUSULAS IS

PROCEDURE CONFIGURAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, cCodClausula VARCHAR2) IS
BEGIN
   UPDATE COTIZADOR_CLAUSULAS
      SET StsClausulaCot = 'CONFIG'
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND CodCotizador = cCodCotizador
      AND CodClausula  = cCodClausula;
END CONFIGURAR;

PROCEDURE SUSPENDER(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, cCodClausula VARCHAR2) IS
BEGIN
   UPDATE COTIZADOR_CLAUSULAS
      SET StsClausulaCot = 'SUSPEN'
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND CodCotizador = cCodCotizador
      AND CodClausula  = cCodClausula;
END SUSPENDER;

PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, cCodClausula VARCHAR2) IS
BEGIN
   UPDATE COTIZADOR_CLAUSULAS
      SET StsClausulaCot = 'ACTIVO'
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND CodCotizador = cCodCotizador
      AND CodClausula  = cCodClausula;
END ACTIVAR;

PROCEDURE COPIAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizadorOrig VARCHAR2, cCodCotizadorDest VARCHAR2) IS
BEGIN
   BEGIN
      INSERT INTO COTIZADOR_CLAUSULAS
                 (CodCia, CodEmpresa, CodCotizador, CodClausula,
                  FecAlta, StsClausulaCot, FecStatus, CodUsuario)
           SELECT nCodCia, CodEmpresa, cCodCotizadorDest, CodClausula, 
                  FecAlta, 'CONFIG', TRUNC(SYSDATE), USER
             FROM COTIZADOR_CLAUSULAS
            WHERE CodCia       = nCodCia
              AND CodEmpresa   = nCodEmpresa
              AND CodCotizador = cCodCotizadorOrig;
   EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Realizar la Copia de COTIZADOR_CLAUSULAS  '|| SQLERRM);
   END;
END COPIAR;

FUNCTION EXISTEN_CLAUSULAS(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN VARCHAR2 IS
cExiste   VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM COTIZADOR_CLAUSULAS
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND CodCotizador  = cCodCotizador;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste  := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste  := 'S';
   END;
   RETURN(cExiste);
END EXISTEN_CLAUSULAS;

END GT_COTIZADOR_CLAUSULAS;
