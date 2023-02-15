CREATE OR REPLACE PACKAGE OC_SEGUIMIENTO IS

  FUNCTION ID_NUMSEGUI RETURN NUMBER; --IN. SEQ XDS 19/07/2016
   
  PROCEDURE INSERTA_SEGUIMIENTO(nIdPoliza NUMBER, nIDetPol NUMBER, cIdTipoSeg VARCHAR2);

END OC_SEGUIMIENTO;
 
 
 
 

 
 
/

CREATE OR REPLACE PACKAGE BODY OC_SEGUIMIENTO IS

 FUNCTION ID_NUMSEGUI RETURN NUMBER IS --IN. SEQ XDS 19/07/2016
nIdSegui   SEGUIMIENTO.IdNumSegui%TYPE;
BEGIN
   BEGIN
   /**SELECT NVL(MAX(IdNumSegui),0) + 1
     INTO nIdNumSegui 
     FROM SEGUIMIENTO;**/
     /** Cambio a secuencia XDS**/
      SELECT SQ_IDNUMSEGUI.NEXTVAL     
        INTO nIdSegui
        FROM DUAL;
    EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20225,'YA Existe la Secuencia  para Cliente ');
    END;
         RETURN(nIdSegui);

END ID_NUMSEGUI;                       --FIN SEQ XDS 19/07/2016


 PROCEDURE INSERTA_SEGUIMIENTO(nIdPoliza NUMBER, nIDetPol NUMBER, cIdTipoSeg VARCHAR2) IS
nIdNumSegui   SEGUIMIENTO.IdNumSegui%TYPE;

BEGIN
   
   /**SELECT NVL(MAX(IdNumSegui),0) + 1
     INTO nIdNumSegui 
     FROM SEGUIMIENTO;**/

     /** Cambio a secuencia XDS**/

      SELECT SQ_IDNUMSEGUI.NEXTVAL     
        INTO nIdNumSegui
        FROM DUAL;


   INSERT INTO SEGUIMIENTO
         (IdNumSegui, IdPoliza, IDetPol, FecSegui, StsSegui, TipoSegui, FecSts, COdUsr)
   VALUES(nIdNumSegui, nIdPoliza, nIdetPol, SYSDATE, 'ACT', cIdTipoSeg, SYSDATE, USER);

END INSERTA_SEGUIMIENTO;



END OC_SEGUIMIENTO;
