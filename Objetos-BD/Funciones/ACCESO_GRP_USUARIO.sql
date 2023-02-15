FUNCTION ACCESO_GRP_USUARIO
  ( nCodCia NUMBER)  RETURN VARCHAR2 IS
cIndAcceso GRUPOS_DE_USUARIOS.IndAcceso%TYPE;
BEGIN
   BEGIN
       SELECT NVL(G.IndAcceso,'N')
        INTO cIndAcceso
        FROM GRUPOS_DE_USUARIOS G
       WHERE G.CodCia   = nCodCia
         AND EXISTS (SELECT 1
                       FROM USUARIOS U
                      WHERE U.CodGrupo   =  G.CodGrupo
                        AND U.CODUSUARIO = USER
                        AND U.CodCia     = nCodCia);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
        cIndAcceso := 'N' ;
   END;
   RETURN (cIndAcceso) ;
END;
