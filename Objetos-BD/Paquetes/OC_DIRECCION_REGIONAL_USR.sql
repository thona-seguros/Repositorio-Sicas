CREATE OR REPLACE PACKAGE OC_DIRECCION_REGIONAL_USR IS

  PROCEDURE ACTIVAR_USUARIO(nCodCia NUMBER, nCodDirecRegional NUMBER, cCodUsuario VARCHAR2);
  PROCEDURE SUSPENDER_USUARIO(nCodCia NUMBER, nCodDirecRegional NUMBER, cCodUsuario VARCHAR2);
  FUNCTION DIREC_REGIONAL_USUARIO(nCodCia NUMBER, cCodUsuario VARCHAR2) RETURN NUMBER;

END OC_DIRECCION_REGIONAL_USR;
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_DIRECCION_REGIONAL_USR IS

PROCEDURE ACTIVAR_USUARIO(nCodCia NUMBER, nCodDirecRegional NUMBER, cCodUsuario VARCHAR2) IS
BEGIN
   UPDATE DIRECCION_REGIONAL_USR
      SET StsUsuario  = 'ACTIV',
          FecSts      = TRUNC(SYSDATE)
    WHERE CodCia           = nCodCia
      AND CodDirecRegional = nCodDirecRegional
      AND CodUsuario       = cCodUsuario;
END ACTIVAR_USUARIO;

PROCEDURE SUSPENDER_USUARIO(nCodCia NUMBER, nCodDirecRegional NUMBER, cCodUsuario VARCHAR2) IS
BEGIN
   UPDATE DIRECCION_REGIONAL_USR
      SET StsUsuario  = 'SUSPEN',
          FecSts      = TRUNC(SYSDATE)
    WHERE CodCia           = nCodCia
      AND CodDirecRegional = nCodDirecRegional
      AND CodUsuario       = cCodUsuario;
END SUSPENDER_USUARIO;

FUNCTION DIREC_REGIONAL_USUARIO(nCodCia NUMBER, cCodUsuario VARCHAR2) RETURN NUMBER IS
nCodDirecRegional       DIRECCION_REGIONAL_USR.CodDirecRegional%TYPE;
BEGIN
   BEGIN
      SELECT CodDirecRegional
        INTO nCodDirecRegional
        FROM DIRECCION_REGIONAL_USR
       WHERE CodCia           = nCodCia
         AND CodUsuario       = cCodUsuario;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'Usuario ' || cCodUsuario || ' NO Existe Configurado en Ninguna Dirección Regional');
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Usuario ' || cCodUsuario || ' Existe Configurado en Varias Direcciones Regionales');
   END;
   RETURN(nCodDirecRegional);
END DIREC_REGIONAL_USUARIO;

END OC_DIRECCION_REGIONAL_USR;
