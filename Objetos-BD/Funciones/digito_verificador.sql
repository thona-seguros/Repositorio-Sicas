--
-- DIGITO_VERIFICADOR  (Function) 
--
--  Dependencies: 
--   STANDARD (Package)
--   PLITBLM (Synonym)
--
CREATE OR REPLACE FUNCTION SICAS_OC.DIGITO_VERIFICADOR(cCuenta VARCHAR2) RETURN NUMBER IS
TYPE ARR_LETRAS IS VARRAY(26) OF VARCHAR(1);
TYPE ARR_FACTOR IS VARRAY(26) OF NUMBER(1);
TYPE ARR_CUENTA IS VARRAY(19) OF VARCHAR(1);

 --definición de una variable tipo array;
Letras_arr   ARR_LETRAS;
Factor_arr   ARR_FACTOR;
Cuenta_arr   ARR_CUENTA;
cLetra       VARCHAR2(1);
nFactor      NUMBER(1);
nResult      NUMBER(2);
nTotal       NUMBER(3);
nDigito      NUMBER(2);
BEGIN
   --inicializar los valores del array
   Letras_Arr := ARR_LETRAS('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z');
   Factor_Arr := ARR_FACTOR(1,2,3,4,5,6,7,8,9,1,2,3,4,5,6,7,8,9,1,2,3,4,5,6,7,8);
   Cuenta_Arr := ARR_CUENTA('0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0');
   FOR I IN 1..19 LOOP
      Cuenta_Arr(I) := SUBSTR(cCuenta, I, 1);
      FOR J IN Letras_Arr.FIRST .. Letras_Arr.LAST LOOP
         cLetra := Letras_Arr(J);
         IF cLetra = SUBSTR(cCuenta, I, 1) THEN
            Cuenta_Arr(I) := Factor_Arr(J);
            EXIT;
         END IF;
      END LOOP;
   END LOOP;
   nFactor := 2;
   nTotal  := 0;
   FOR I IN REVERSE 1..19 LOOP
      nResult := TO_NUMBER(Cuenta_Arr(I)) * nFactor;
      IF nResult > 9 THEN
         nResult:=  TO_NUMBER(SUBSTR(TO_NUMBER(nResult/10),1,1)) + TO_NUMBER(SUBSTR(TO_NUMBER(nResult),2,1));
      END IF;
      nTotal := nTotal + nResult;
      IF nFactor = 2 THEN
         nFactor := 1;
      ELSE
         nFactor := 2;
      END IF;
   END LOOP;
   nDigito := ((TRUNC(nTotal/10,0)*10)+10) - nTotal;
   IF nDigito >= 10 THEN
      nDigito := 0;
   END IF;
   RETURN(nDigito);
 END DIGITO_VERIFICADOR;
/
