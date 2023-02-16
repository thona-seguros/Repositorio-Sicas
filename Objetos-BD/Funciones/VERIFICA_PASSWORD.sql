FUNCTION VERIFICA_PASSWORD(username varchar2, password varchar2, old_password varchar2) RETURN boolean IS
n            BOOLEAN;
m            INTEGER;
differ       INTEGER;
isdigit      BOOLEAN;
ischar       BOOLEAN;
ispunct      BOOLEAN;
digitarray   VARCHAR2(20);
punctarray   VARCHAR2(25);
chararray    VARCHAR2(52);

BEGIN
   digitarray := '0123456789';
   chararray  := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
   punctarray := '!"#$%&()``*+,-/:;<=>?_';

   -- Check if the password is same as the username
   IF NLS_LOWER(password) = NLS_LOWER(username) THEN
     RAISE_APPLICATION_ERROR(-20001, 'Password es el mismo o similar al Usuario.  Debe Cambiarlo.');
   END IF;

   -- Check for the minimum length of the password
   IF LENGTH(password) < 8 THEN
      RAISE_APPLICATION_ERROR(-20002, 'Password No puede ser Menor a 8 Caracteres');
   END IF;

   -- Check if the password is too simple. A dictionary of words may be
   -- maintained and a check may be made so as not to allow the words
   -- that are too simple for the password.
   IF NLS_LOWER(password) IN ('welcome', 'database', 'account', 'user', 'password', 'oracle',
                              'computer', 'abcd', 'admin', '1234', '123456', 'tiger',
                              'administrador', 'asdasd', 'abc123abc' ,'contraseña') THEN
      RAISE_APPLICATION_ERROR(-20002, 'Password es muy Simple o una Palabra Común. Debe Cambiarlo');
   END IF;

   -- Check if the password contains at least one letter, one digit 
   -- 1. Check for the digit
   isdigit := FALSE;
   m := LENGTH(password);
   FOR i IN 1..10 LOOP
      FOR j IN 1..m LOOP
         IF SUBSTR(password,j,1) = SUBSTR(digitarray,i,1) THEN
            isdigit := TRUE;
            GOTO findchar;
         END IF;
      END LOOP;
   END LOOP;
   IF isdigit = FALSE THEN
      RAISE_APPLICATION_ERROR(-20003, 'Password debe contener al menos un Número');
   END IF;
   
   -- 2. Check for the character
   <<findchar>>
   ischar := FALSE;
   FOR i IN 1..LENGTH(chararray) LOOP
      FOR j IN 1..m LOOP
         IF SUBSTR(password,j,1) = SUBSTR(chararray,i,1) THEN
            ischar := TRUE;
            GOTO findespecial;
         END IF;
      END LOOP;
   END LOOP;
   IF ischar = FALSE THEN
      RAISE_APPLICATION_ERROR(-20003, 'Password debe contener al menos una letra mayúscula o minúscula');
   END IF;

   -- 3. Check for the special character
   <<findespecial>>
   ispunct := FALSE;
   FOR i IN 1..LENGTH(punctarray) LOOP
      FOR j IN 1..m LOOP
         IF SUBSTR(password,j,1) = SUBSTR(punctarray,i,1) THEN
            ispunct := TRUE;
            GOTO endsearch;
         END IF;
      END LOOP;
   END LOOP;
   IF ispunct = FALSE THEN
      RAISE_APPLICATION_ERROR(-20003, 'Password debe contener al menos un Caracter Especial');
   END IF;
   
   <<endsearch>>
   
   -- Check if the password differs from the previous password by at least 3 letters
   IF old_password IS NOT NULL THEN
     differ := LENGTH(old_password) - LENGTH(password);

     IF ABS(differ) < 3 THEN
       IF LENGTH(password) < LENGTH(old_password) THEN
         m := LENGTH(password);
       ELSE
         m := LENGTH(old_password);
       END IF;

       differ := ABS(differ);
       FOR i IN 1..m LOOP
         IF SUBSTR(password,i,1) != SUBSTR(old_password,i,1) THEN
           differ := differ + 1;
         END IF;
       END LOOP;

       IF differ < 3 THEN
         RAISE_APPLICATION_ERROR(-20004, 'Password debe ser diferente por lo menos en 3 caracteres al Password Anterior');
       END IF;
     END IF;
   END IF;
   -- Everything is fine; return TRUE ;
   RETURN(TRUE);
END;
 
 
 
 
