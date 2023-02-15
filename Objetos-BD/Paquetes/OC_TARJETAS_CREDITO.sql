CREATE OR REPLACE PACKAGE OC_TARJETAS_CREDITO IS

  FUNCTION NOMBRE(nCodCia NUMBER, cCodEntidad VARCHAR2, cTipoTarjeta VARCHAR2) RETURN VARCHAR2;
  PROCEDURE ACTIVAR(nCodCia NUMBER, cCodEntidad VARCHAR2, cTipoTarjeta VARCHAR2);
  PROCEDURE SUSPENDER(nCodCia NUMBER, cCodEntidad VARCHAR2, cTipoTarjeta VARCHAR2);

END OC_TARJETAS_CREDITO;
 
/

CREATE OR REPLACE PACKAGE BODY OC_TARJETAS_CREDITO IS

FUNCTION NOMBRE(nCodCia NUMBER, cCodEntidad VARCHAR2, cTipoTarjeta VARCHAR2) RETURN VARCHAR2 IS
cNombreTarjeta     TARJETAS_CREDITO.NombreTarjeta%TYPE;
BEGIN
   BEGIN
      SELECT NombreTarjeta 
        INTO cNombreTarjeta
        FROM TARJETAS_CREDITO
       WHERE CodCia           = nCodCia
         AND CodEntidad       = cCodEntidad
         AND TipoTarjeta      = cTipoTarjeta;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNombreTarjeta  := 'NO EXISTE';
  END;
  RETURN(cNombreTarjeta);
END NOMBRE;

PROCEDURE ACTIVAR(nCodCia NUMBER, cCodEntidad VARCHAR2, cTipoTarjeta VARCHAR2) IS
BEGIN
   BEGIN
      UPDATE TARJETAS_CREDITO
         SET StsTarjeta = 'ACTIVA',
             FechaSts   = SYSDATE
       WHERE CodCia           = nCodCia
         AND CodEntidad       = cCodEntidad
         AND TipoTarjeta      = cTipoTarjeta;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100,'No Existe Tarjeta '||cTipoTarjeta);
  END;
END ACTIVAR;

PROCEDURE SUSPENDER(nCodCia NUMBER, cCodEntidad VARCHAR2, cTipoTarjeta VARCHAR2) IS
BEGIN
   BEGIN
      UPDATE TARJETAS_CREDITO
         SET StsTarjeta = 'SUSPEN',
             FechaSts   = SYSDATE  
       WHERE CodCia           = nCodCia
         AND CodEntidad       = cCodEntidad
         AND TipoTarjeta      = cTipoTarjeta;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100,'No Existe Tarjeta '||cTipoTarjeta);
  END;
END SUSPENDER;

END OC_TARJETAS_CREDITO;
