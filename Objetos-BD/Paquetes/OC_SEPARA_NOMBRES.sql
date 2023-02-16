CREATE OR REPLACE PACKAGE OC_SEPARA_NOMBRES IS

  PROCEDURE SEPARA_NOMBRES_APELLIDOS;

  PROCEDURE SEPARA_APELLIDOS_NOMBRES;

END OC_SEPARA_NOMBRES;
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_SEPARA_NOMBRES IS

PROCEDURE SEPARA_NOMBRES_APELLIDOS IS
nPosicion   NUMBER;
cApeMater   SEPARA_NOMBRES.Apellido_Materno%TYPE;
cApePater   SEPARA_NOMBRES.Apellido_Paterno%TYPE;
cNombre     SEPARA_NOMBRES.NombreSolo%TYPE;
nContador   NUMBER := 0;
nPosAnt     NUMBER;
CURSOR REG_Q IS
   SELECT IdRegistro, NombreCompleto
     FROM SEPARA_NOMBRES;
BEGIN
   UPDATE SEPARA_NOMBRES
      SET NombreCompleto = TRIM(NombreCompleto);

   UPDATE SEPARA_NOMBRES
      SET NombreCompleto = REPLACE(NombreCompleto,'  ',' ');
   FOR Y IN REG_Q LOOP
      nContador := 0;
      nPosAnt   := 0;
      cApeMater := NULL;
      cApePater := NULL;

      FOR X IN REVERSE 1..5 LOOP
         SELECT INSTR(Y.NombreCompleto,' ',1,X) 
           INTO nPosicion
           FROM DUAL;
         IF nPosicion != 0 THEN
            nContador := nContador + 1;
            IF nContador = 1 THEN
               cApeMater := SUBSTR(Y.NombreCompleto,nPosicion+1,LENGTH(Y.NombreCompleto));
               nPosAnt   := nPosicion;
            ELSIF nContador = 2 THEN
               cApePater := SUBSTR(Y.NombreCompleto,nPosicion+1,nPosAnt-nPosicion);
               nPosAnt   := nPosicion;
               EXIT;
            END IF;
         END IF;
      END LOOP;
      cNombre  := SUBSTR(Y.NombreCompleto,1,nPosAnt);
      UPDATE SEPARA_NOMBRES
         SET Apellido_Materno = cApeMater,
             Apellido_Paterno = cApePater,
             NombreSolo       = cNombre
       WHERE IdRegistro = Y.IdRegistro;
   END LOOP;
END SEPARA_NOMBRES_APELLIDOS;

PROCEDURE SEPARA_APELLIDOS_NOMBRES IS
nPosicion   NUMBER;
cApeMater   SEPARA_NOMBRES.Apellido_Materno%TYPE;
cApePater   SEPARA_NOMBRES.Apellido_Paterno%TYPE;
cNombre     SEPARA_NOMBRES.NombreSolo%TYPE;
nContador   NUMBER := 0;
nPosAnt     NUMBER;

CURSOR REG_Q IS
   SELECT IdRegistro, NombreCompleto
     FROM SEPARA_NOMBRES;
BEGIN
   UPDATE SEPARA_NOMBRES
      SET NombreCompleto = TRIM(NombreCompleto);

   UPDATE SEPARA_NOMBRES
      SET NombreCompleto = REPLACE(NombreCompleto,'  ',' ');
   FOR Y IN REG_Q LOOP
      nContador := 0;
      nPosAnt   := 0;
      cApeMater := NULL;
      cApePater := NULL;

      FOR X IN 1..5 LOOP
         SELECT INSTR(Y.NombreCompleto,' ',1,X) 
           INTO nPosicion
           FROM DUAL;
         IF nPosicion != 0 THEN
            nContador := nContador + 1;
            IF nContador = 1 THEN
               cApePater := SUBSTR(Y.NombreCompleto,1,nPosicion-1);
               nPosAnt   := nPosicion;
            ELSIF nContador = 2 THEN
               cApeMater := SUBSTR(Y.NombreCompleto,nPosAnt+1,nPosicion-nPosAnt);
               nPosAnt   := nPosicion;
               EXIT;
            END IF;
         END IF;
      END LOOP;
      cNombre  := SUBSTR(Y.NombreCompleto,nPosAnt+1,LENGTH(Y.NombreCompleto));
      UPDATE SEPARA_NOMBRES
         SET Apellido_Materno = cApeMater,
             Apellido_Paterno = cApePater,
             NombreSolo       = cNombre
       WHERE IdRegistro = Y.IdRegistro;
      COMMIT;
   END LOOP;
END SEPARA_APELLIDOS_NOMBRES;

END OC_SEPARA_NOMBRES;
