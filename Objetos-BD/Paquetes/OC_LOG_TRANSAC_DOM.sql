CREATE OR REPLACE PACKAGE OC_LOG_TRANSAC_DOM  IS
   PROCEDURE INSERTA(nCodCia NUMBER,cCodEntidad VARCHAR,  nIdProceso NUMBER, cTipoTran VARCHAR, cTexto VARCHAR2);
END OC_LOG_TRANSAC_DOM;
 
 

 
 
/

CREATE OR REPLACE PACKAGE BODY oc_log_transac_dom IS

PROCEDURE INSERTA(nCodCia NUMBER,cCodEntidad VARCHAR,  nIdProceso NUMBER, cTipoTran VARCHAR,cTexto VARCHAR2) IS
nCorrelativo NUMBER(14,0);
cUsuario USUARIOS.CodUsuario%TYPE;

BEGIN

   /*SELECT NVL(MAX(CORRELATIVO),0)+1
    INTO  nCorrelativo
   FROM  LOG_TRANSAC_DOM;*/
   /**   Cambio a Secuenci  XDS**/
    SELECT SQ_LOGTRANSACC_DOM.NEXTVAL     
        INTO nCorrelativo
        FROM DUAL;
   

   cUsuario := USER;

   INSERT INTO LOG_TRANSAC_DOM
   VALUES (nCodCia, nIdProceso,nCorrelativo,cUsuario,cCodentidad,cTipotran, SYSDATE, cTexto);
END INSERTA;

END OC_LOG_TRANSAC_DOM;
