--
-- GT_FAI_CONF_TIPO_INCENTIVO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FAI_CONF_TIPO_INCENTIVO (Table)
--   GT_FAI_CONF_TIPO_INCENTIVO_DET (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_CONF_TIPO_INCENTIVO AS

PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodIncentivo VARCHAR2);

PROCEDURE CONFIGURAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodIncentivo VARCHAR2);

PROCEDURE REACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodIncentivo VARCHAR2);

PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodIncentivo VARCHAR2);

FUNCTION DESCRIPCION_INCENTIVO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodIncentivo VARCHAR2) RETURN VARCHAR2;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, cTipoFondoDest VARCHAR2, 
                 cCodIncentivoOrig VARCHAR2, cCodIncentivoDest VARCHAR2, 
					  cDescIncentivoDest VARCHAR2);

END GT_FAI_CONF_TIPO_INCENTIVO;
/

--
-- GT_FAI_CONF_TIPO_INCENTIVO  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_CONF_TIPO_INCENTIVO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_CONF_TIPO_INCENTIVO AS

PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodIncentivo VARCHAR2) IS
BEGIN
   UPDATE FAI_CONF_TIPO_INCENTIVO
      SET StsIncentivo = 'ACTIVO',
          FecStatus    = TRUNC(SYSDATE)
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND TipoFondo    = cTipoFondo
      AND CodIncentivo = cCodIncentivo;
END ACTIVAR;

PROCEDURE CONFIGURAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodIncentivo VARCHAR2) IS
BEGIN
   UPDATE FAI_CONF_TIPO_INCENTIVO
      SET StsIncentivo = 'CONFIG',
          FecStatus    = TRUNC(SYSDATE)
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND TipoFondo    = cTipoFondo
      AND CodIncentivo = cCodIncentivo;
END CONFIGURAR;

PROCEDURE REACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodIncentivo VARCHAR2) IS
BEGIN
   UPDATE FAI_CONF_TIPO_INCENTIVO
      SET StsIncentivo = 'ACTIVO',
          FecStatus    = TRUNC(SYSDATE)
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND TipoFondo    = cTipoFondo
      AND CodIncentivo = cCodIncentivo;
END REACTIVAR;

PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodIncentivo VARCHAR2) IS
BEGIN
   UPDATE FAI_CONF_TIPO_INCENTIVO
      SET StsIncentivo = 'SUSPEN',
          FecStatus    = TRUNC(SYSDATE)
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND TipoFondo    = cTipoFondo
      AND CodIncentivo = cCodIncentivo;
END SUSPENDER;

FUNCTION DESCRIPCION_INCENTIVO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodIncentivo VARCHAR2) RETURN VARCHAR2 IS
cDescIncentivo    FAI_CONF_TIPO_INCENTIVO.DescIncentivo%TYPE;
BEGIN
   SELECT DescIncentivo
     INTO cDescIncentivo
     FROM FAI_CONF_TIPO_INCENTIVO
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND TipoFondo    = cTipoFondo
      AND CodIncentivo = cCodIncentivo;
   RETURN(cDescIncentivo);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN('NO EXISTE');
   WHEN OTHERS THEN
      RETURN('ERROR');
END DESCRIPCION_INCENTIVO;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, cTipoFondoDest VARCHAR2, 
                 cCodIncentivoOrig VARCHAR2, cCodIncentivoDest VARCHAR2, cDescIncentivoDest VARCHAR2) IS
CURSOR INCEN_Q IS
   SELECT CodIncentivo, DescIncentivo, Modalidad, StsIncentivo,
          FecStatus, ValorMinimo, ValorMaximo, IndEntrega,
          FecIniVig, FecFinVig, CantMinPol, CantMaxPol
     FROM FAI_CONF_TIPO_INCENTIVO
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND TipoFondo    = cTipoFondoOrig
	   AND CodIncentivo = cCodIncentivoOrig;
BEGIN
   FOR X IN INCEN_Q LOOP
      BEGIN
         INSERT INTO FAI_CONF_TIPO_INCENTIVO
                (CodCia, CodEmpresa, TipoFondo, CodIncentivo, DescIncentivo,
                 Modalidad, StsIncentivo, FecStatus, ValorMinimo, ValorMaximo,
                 IndEntrega, FecIniVig, FecFinVig, CantMinPol, CantMaxPol)
         VALUES (nCodCia, nCodEmpresa, cTipoFondoDest, cCodIncentivoDest, cDescIncentivoDest,
                 X.Modalidad, 'CONFIG', TRUNC(SYSDATE), X.ValorMinimo, X.ValorMaximo,
                 X.IndEntrega, X.FecIniVig, X.FecFinVig, X.CantMinPol, X.CantMaxPol);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20200,'Error Copiando Fondo: '||cTipoFondoDest||' e Incentivo: '||cCodIncentivoDest);
      END;

      GT_FAI_CONF_TIPO_INCENTIVO_DET.COPIAR(nCodCia, nCodEmpresa, cTipoFondoOrig, cTipoFondoDest, 
                                            cCodIncentivoOrig, cCodIncentivoDest);
   END LOOP;
END COPIAR;

END GT_FAI_CONF_TIPO_INCENTIVO;
/
