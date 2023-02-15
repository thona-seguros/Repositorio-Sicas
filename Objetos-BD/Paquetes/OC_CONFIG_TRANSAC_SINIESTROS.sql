CREATE OR REPLACE PACKAGE OC_CONFIG_TRANSAC_SINIESTROS IS

  FUNCTION DESCRIPCION_TRANSACCION(nCodCia NUMBER, cCodTransac VARCHAR) RETURN VARCHAR2;
  FUNCTION CODIGO_PROC_CONTABLE(nCodCia NUMBER, cCodTransac VARCHAR) RETURN VARCHAR2;
  FUNCTION APLICA(nCodCia NUMBER, cCodTransac VARCHAR) RETURN VARCHAR2;
  PROCEDURE ACTIVAR(nCodCia NUMBER, cCodTransac VARCHAR);
  PROCEDURE CONFIGURAR(nCodCia NUMBER, cCodTransac VARCHAR);
  PROCEDURE SUSPENDER(nCodCia NUMBER, cCodTransac VARCHAR);

END OC_CONFIG_TRANSAC_SINIESTROS;
/

CREATE OR REPLACE PACKAGE BODY OC_CONFIG_TRANSAC_SINIESTROS IS

FUNCTION DESCRIPCION_TRANSACCION(nCodCia NUMBER, cCodTransac VARCHAR) RETURN VARCHAR2 IS
cDescTransac    CONFIG_TRANSAC_SINIESTROS.DescTransac%TYPE;
BEGIN
   BEGIN
      SELECT DescTransac
        INTO cDescTransac
        FROM CONFIG_TRANSAC_SINIESTROS
       WHERE CodCia     = nCodCia
         AND CodTransac = cCodTransac;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Codigo de Transaccion '||TRIM(cCodTransac));
   END;
   RETURN(cDescTransac);
END DESCRIPCION_TRANSACCION;

FUNCTION CODIGO_PROC_CONTABLE(nCodCia NUMBER, cCodTransac VARCHAR) RETURN VARCHAR2 IS
cCodProcContable    CONFIG_TRANSAC_SINIESTROS.CodProcContable%TYPE;
BEGIN
   BEGIN
      SELECT CodProcContable
        INTO cCodProcContable
        FROM CONFIG_TRANSAC_SINIESTROS
       WHERE CodCia     = nCodCia
         AND CodTransac = cCodTransac;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Codigo de Transaccion '||TRIM(cCodTransac));
   END;
   RETURN(cCodProcContable);
END CODIGO_PROC_CONTABLE;

FUNCTION APLICA(nCodCia NUMBER, cCodTransac VARCHAR) RETURN VARCHAR2 IS
cIndAplicTransac    CONFIG_TRANSAC_SINIESTROS.IndAplicTransac%TYPE;
BEGIN
   BEGIN
      SELECT IndAplicTransac
        INTO cIndAplicTransac
        FROM CONFIG_TRANSAC_SINIESTROS
       WHERE CodCia     = nCodCia
         AND CodTransac = cCodTransac;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Codigo de Transaccion '||TRIM(cCodTransac));
   END;
   RETURN(cIndAplicTransac);
END APLICA;

PROCEDURE ACTIVAR(nCodCia NUMBER, cCodTransac VARCHAR) IS
BEGIN
   UPDATE CONFIG_TRANSAC_SINIESTROS
      SET StsTransac = 'ACTIVA',
          FecSts     = TRUNC(SYSDATE),
          CodUsuario = USER
    WHERE CodCia     = nCodCia
      AND CodTransac = cCodTransac;
END ACTIVAR;

PROCEDURE CONFIGURAR(nCodCia NUMBER, cCodTransac VARCHAR) IS
BEGIN
   UPDATE CONFIG_TRANSAC_SINIESTROS
      SET StsTransac = 'CONFIG',
          FecSts     = TRUNC(SYSDATE),
          CodUsuario = USER
    WHERE CodCia     = nCodCia
      AND CodTransac = cCodTransac;
END CONFIGURAR;

PROCEDURE SUSPENDER(nCodCia NUMBER, cCodTransac VARCHAR) IS
BEGIN
   UPDATE CONFIG_TRANSAC_SINIESTROS
      SET StsTransac = 'SUSPEN',
          FecSts     = TRUNC(SYSDATE),
          CodUsuario = USER
    WHERE CodCia     = nCodCia
      AND CodTransac = cCodTransac;
END SUSPENDER;

END OC_CONFIG_TRANSAC_SINIESTROS;
