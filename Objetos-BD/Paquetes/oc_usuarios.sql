--
-- OC_USUARIOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   USUARIOS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_USUARIOS AS
    FUNCTION EMAIL (nCodCia NUMBER, cCodUsuario VARCHAR2) RETURN VARCHAR2;

    FUNCTION GRUPO_USUARIO(nCodCia NUMBER, cCodUsuario VARCHAR2) RETURN VARCHAR2;

    FUNCTION NOMBRE_USUARIO(nCodCia NUMBER, cCodUsuario VARCHAR2) RETURN VARCHAR2;

	PROCEDURE CAMBIO_PASSWORD(cCodUsuario VARCHAR2, cPassword VARCHAR2);
END OC_USUARIOS;
/

--
-- OC_USUARIOS  (Package Body) 
--
--  Dependencies: 
--   OC_USUARIOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_USUARIOS AS
FUNCTION EMAIL (nCodCia NUMBER, cCodUsuario VARCHAR2) RETURN VARCHAR2 IS
cEmail      USUARIOS.Email%TYPE;
BEGIN
   BEGIN
      SELECT Email
        INTO cEmail
        FROM USUARIOS
       WHERE CodCia     = nCodCia
         AND CodUsuario = cCodUsuario;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cEmail := 'SIN EMAIL';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error en Configuración del Usuario ' || cCodUsuario ||' - Existe en Varios Grupos');
   END;
   RETURN(cEmail);
END EMAIL;

FUNCTION GRUPO_USUARIO(nCodCia NUMBER, cCodUsuario VARCHAR2) RETURN VARCHAR2 IS
cCodGrupo     USUARIOS.CodGrupo%TYPE;
BEGIN
   BEGIN
      SELECT CodGrupo
        INTO cCodGrupo
        FROM USUARIOS
       WHERE CodCia     = nCodCia
         AND CodUsuario = cCodUsuario;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodGrupo := 'SIN GPO';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error en Configuración del Usuario ' || cCodUsuario ||' - Existe en Varios Grupos');
   END;
   RETURN(cCodGrupo);
END GRUPO_USUARIO;

FUNCTION NOMBRE_USUARIO(nCodCia NUMBER, cCodUsuario VARCHAR2) RETURN VARCHAR2 IS
cNomUsuario     USUARIOS.NomUsuario%TYPE;
BEGIN
   BEGIN
      SELECT NomUsuario
        INTO cNomUsuario
        FROM USUARIOS
       WHERE CodCia     = nCodCia
         AND CodUsuario = cCodUsuario;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNomUsuario := 'NO EXISTE';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error en Configuración del Usuario ' || cCodUsuario ||' - Existe en Varios Grupos');
   END;
   RETURN(cNomUsuario);
END NOMBRE_USUARIO;

PROCEDURE CAMBIO_PASSWORD(cCodUsuario VARCHAR2, cPassword VARCHAR2) IS
   cSql VARCHAR2(200);
BEGIN
   cSql := 'ALTER USER '||cCodUsuario||' IDENTIFIED BY "'||cPassword||'"';
   EXECUTE IMMEDIATE cSql;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al cambiar password: '||SQLCODE||'-'||SQLERRM);
END CAMBIO_PASSWORD;

END OC_USUARIOS;
/

--
-- OC_USUARIOS  (Synonym) 
--
--  Dependencies: 
--   OC_USUARIOS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_USUARIOS FOR SICAS_OC.OC_USUARIOS
/


GRANT EXECUTE ON SICAS_OC.OC_USUARIOS TO PUBLIC
/
