CREATE OR REPLACE PACKAGE SICAS_OC.TH_CARGA_OPC IS
/******************************************************************************/
-- TH_CARGA_OPC
-- PAQUETE UTILIZADO PARA CARGAR LA INFORMACION DE OPC CADA CIERRE DE MES     --
-- DISEÑO   : MARIA DE LA LUZ JIMENEZ SILVA                                   --
-- CREACION : MARIA DE LA LUZ JIMENEZ SILVA                                   --
-- FECHA CREACION : 20190812                                                  --
/******************************************************************************/

VGNOMPACKAGE  VARCHAR2(20) := 'TH_CARGA_OPC';
VGNOMPROCFUN  VARCHAR2(20);

PROCEDURE CARGA_INICIAL(
/******************************************************************************/
-- PROCEDIMIENTO DE CARGA INICIAL MENSUAL DE LOS SINIESTROS CON RESERVA AL   --
-- CIERRE DEL MES ANTERIOR A LA FECHA DE PROCESO                             --
-- CREACION :  IGNACIO CASTILLO OROZCO                                       --
-- FECHA CREACIÓN 14/02/2019 
-- MODIFICACION : MARIA DE LA LUZ JIMENEZ SILVA
-- FECHA DE ULT MODIF.: 12/08/2019
/******************************************************************************/
  P_CODCIA    IN NUMBER  , 
  P_AÑO_PROC  IN NUMBER  ,
  P_MES_PROC  IN NUMBER  ,
  P_AÑO_ANT   IN NUMBER  ,
  P_MES_ANT   IN NUMBER  ,  
  P_IDPROCESO IN NUMBER  ,    
  P_NUMREGS      IN OUT NUMBER  ,
  P_IMPTE_RVAINI IN OUT NUMBER  ,
  P_ID_ERROR     OUT NUMBER  ,
  P_MENSAJE      OUT VARCHAR2);

PROCEDURE CARGA_DETALLE_MOVTOS( 
/******************************************************************************/
-- PROCEDIMIENTO DE CARGA DE DETALLE DE MOVIMIENTOS DE SINIESTROS QUE SE     --
-- TUVIERON EN EL MES                                                        --
-- CREACION :  IGNACIO CASTILLO OROZCO                                       --
-- FECHA CREACIÓN 14/02/2019                                                 --
-- MODIFICACION : MARIA DE LA LUZ JIMENEZ SILVA                              --
-- FECHA DE ULT MODIF.: 12/08/2019                                           --
/******************************************************************************/
  P_CODCIA        IN NUMBER,
  P_ORIGEN        IN VARCHAR2,
  PIDCARGA        IN NUMBER,
  P_FECHA_INICIAL IN DATE,
  P_FECHA_FINAL   IN DATE,
  P_IDPROCESO     IN NUMBER,
  P_ID_SINIESTRO  IN NUMBER,
  P_ID_ERROR      OUT NUMBER,
  P_MENSAJE       OUT VARCHAR2);
  
PROCEDURE CARGA_RESUMEN_MOVTOS(
/******************************************************************************/
-- PROCEDIMIENTO DE CARGA DE RESUMEN DE MOVIMIENTOS DE SINIESTROS QUE SE     --
-- TUVIERON EN EL MES                                                        --
-- CREACION :  IGNACIO CASTILLO OROZCO                                       --
-- FECHA CREACIÓN 14/02/2019                                                 --
-- MODIFICACION : MARIA DE LA LUZ JIMENEZ SILVA                              --
-- FECHA DE ULT MODIF.: 12/08/2019                                           --
/******************************************************************************/
  P_CODCIA        IN NUMBER,
  P_ORIGEN        IN VARCHAR2,
  P_FECHA_INICIAL IN DATE,
  P_FECHA_FINAL   IN DATE,
  P_IDPROCESO IN NUMBER  ,
  P_ID_SINIESTRO  IN NUMBER,
  P_ID_ERROR OUT NUMBER  ,
  P_MENSAJE  OUT VARCHAR2);

FUNCTION FUNVALIDACGAINICIAL (
  P_AÑO_PROC  IN NUMBER  ,
  P_MES_PROC  IN NUMBER  )   RETURN VARCHAR2;    

PROCEDURE CTROL_CGA_RVA (
  PIDCARGA        IN NUMBER,
  PIDVERSION      IN NUMBER,
  PPERIODICIDAD   IN NUMBER,
  PFECINICIAL     IN DATE,
  PFECFINAL       IN DATE,
  PID_SINIESTRO   IN NUMBER,
  PIMPTE_RVA_INI  IN NUMBER,
  PTOT_REGS_RI    IN NUMBER,
  PIMPTE_AJUMAS   IN NUMBER,
  PTOT_REGS_AA    IN NUMBER,
  PIMPTE_AJUMENOS IN NUMBER,
  PTOT_REG_AD     IN NUMBER, 
  PIMPTE_PAGOS    IN NUMBER,
  PTOT_REGS_PA    IN NUMBER,
  PIMPTE_DESPAGOS IN NUMBER,
  PTOT_REGS_DESP  IN NUMBER,
  PTI_PROCESO     IN VARCHAR2,
  PTF_PROCESO     IN VARCHAR2,
  PCODUSUARIO     IN VARCHAR2,
  P_ID_ERROR OUT NUMBER  ,
  P_MENSAJE  OUT VARCHAR2);
  
END TH_CARGA_OPC;
/
CREATE OR REPLACE PACKAGE BODY SICAS_OC.TH_CARGA_OPC IS
/******************************************************************************/
-- TH_CARGA_OPC                                                               --
-- PAQUETE UTILIZADO PARA CARGA MENSUAL DE LA INFORMACION DE RESERVA OPC      --
-- DISEÑO   : MARIA DE LA LUZ JIMENEZ SILVA                                   --
-- CREACION : MARIA DE LA LUZ JIMENEZ SILVA                                   --
-- FECHA CREACION : 20190812                                                  --
/******************************************************************************/

VG_ID_ERROR  NUMBER(8) := 0;
VG_MENSAJE   VARCHAR(2000);
VGVALIDACION RESERVA.ID_VALIDACION%TYPE;

FUNCTION FUNIDVALIDA RETURN VARCHAR2 IS
  cIDVALIDACION  RESERVA.ID_VALIDACION%TYPE;
BEGIN
   SELECT SUBSTR(USER,1,6)
     INTO cIDVALIDACION
     FROM DUAL;
   RETURN (cIDVALIDACION);
EXCEPTION
   WHEN OTHERS THEN
      RETURN NULL;
END;   
   
FUNCTION FUNVALIDACGAINICIAL (
  P_AÑO_PROC  IN NUMBER  ,
  P_MES_PROC  IN NUMBER  )   RETURN VARCHAR2 IS
  
  nExisteCgaIni  NUMBER(10);
BEGIN
   SELECT COUNT(*)
   INTO   nExisteCgaIni
   FROM   RESERVA R
   WHERE  AÑO_MOVIMIENTO = P_AÑO_PROC
   AND    MES_MOVIMIENTO = P_MES_PROC;
   
   IF nExisteCgaIni = 0 THEN
      RETURN 'N';
   ELSE
      RETURN 'S';
   END IF;
END;
PROCEDURE CARGA_INICIAL(
  P_CODCIA    IN NUMBER  ,
  P_AÑO_PROC  IN NUMBER  ,
  P_MES_PROC  IN NUMBER  ,
  P_AÑO_ANT   IN NUMBER  ,
  P_MES_ANT   IN NUMBER  ,   
  P_IDPROCESO IN NUMBER  ,
  P_NUMREGS      IN OUT NUMBER  ,
  P_IMPTE_RVAINI IN OUT NUMBER  ,
  P_ID_ERROR     OUT NUMBER  ,
  P_MENSAJE      OUT VARCHAR2) IS

  REC_RESERVA    RESERVA%ROWTYPE;  
  nNUMREGS       NUMBER(8);  
  NIMPTE_RVAINI  NUMBER(18,2);
  
CURSOR C_CGA_INI IS
   SELECT *
   FROM   RESERVA R
   WHERE  AÑO_MOVIMIENTO = P_AÑO_ANT
   AND    MES_MOVIMIENTO = P_MES_ANT
   AND    RESERVA_FINAL  != 0
   AND  EXISTS (
          SELECT R.ID_SINIESTRO, SUM(RESERVA_FINAL) RESERVA_FINAL
          FROM   RESERVA R
          WHERE  AÑO_MOVIMIENTO = R.AÑO_MOVIMIENTO
          AND    MES_MOVIMIENTO = R.MES_MOVIMIENTO
          AND    ID_SINIESTRO   = R.ID_SINIESTRO
          GROUP BY ID_SINIESTRO
          HAVING SUM(RESERVA_FINAL) !=0);          
          
PROCEDURE INSERTA_RESERVA(
  P_RESERVA   IN RESERVA%ROWTYPE,
  P_ID_ERROR OUT NUMBER  ,
  P_MENSAJE  OUT VARCHAR2) IS
  
  REC_RESERVA RESERVA%ROWTYPE;
  
BEGIN
   P_ID_ERROR   := 0;
   P_MENSAJE    := NULL;
   REC_RESERVA  := P_RESERVA;
   VGNOMPROCFUN := 'INSERTA_RVA';
   
   INSERT INTO RESERVA VALUES REC_RESERVA;
      
EXCEPTION
  WHEN OTHERS THEN
     P_ID_ERROR := SQLCODE;    
     P_MENSAJE  := VGNOMPROCFUN||'/'||SQLERRM;
     RAISE_APPLICATION_ERROR(-20230,'Error en'|| ' ' ||P_MENSAJE);
END;

          
BEGIN
   P_ID_ERROR    := 0;
   VGNOMPROCFUN  := 'CARGA_INICIAL';
   nNUMREGS      := 0;
   NIMPTE_RVAINI := 0;
   FOR REC_RESERVA IN C_CGA_INI LOOP
      nNUMREGS := nNUMREGS + 1;
      REC_RESERVA.CODCIA            := P_CODCIA;
      REC_RESERVA.AÑO_MOVIMIENTO    := P_AÑO_PROC;
      REC_RESERVA.MES_MOVIMIENTO    := P_MES_PROC;
      REC_RESERVA.NUMSINIREF        := REPLACE(REPLACE(REPLACE(REPLACE(REC_RESERVA.NUMSINIREF,CHR(13),''),CHR(10),''), CHR(11),''), CHR(9),'');     
      REC_RESERVA.ID_PROCESO        := P_IDPROCESO;                  
      REC_RESERVA.ID_VALIDACION     := FUNIDVALIDA;
      REC_RESERVA.RESERVA_ANTERIOR  := REC_RESERVA.RESERVA_FINAL;
      REC_RESERVA.ESTIMACION_INICIAL:= 0;
      REC_RESERVA.AJUSTES_MAS       := 0;
      REC_RESERVA.AJUSTES_MENOS     := 0; 
      REC_RESERVA.PAGOS             := 0; 
      REC_RESERVA.DESPAGOS          := 0;       
      
      NIMPTE_RVAINI  := NIMPTE_RVAINI + REC_RESERVA.RESERVA_ANTERIOR;
      
      INSERTA_RESERVA(REC_RESERVA, VG_ID_ERROR, VG_MENSAJE);
            
      IF SUBSTR(nNUMREGS,-3,3) = '000' THEN
         COMMIT;
      END IF;      
            
   END LOOP;
   P_NUMREGS      := nNUMREGS;
   P_IMPTE_RVAINI := NIMPTE_RVAINI;
EXCEPTION
   WHEN OTHERS THEN
      P_ID_ERROR := SQLCODE;
      P_MENSAJE := VGNOMPACKAGE||'/'||VG_MENSAJE;
      RAISE_APPLICATION_ERROR(-20230,'Error en : '||P_MENSAJE);
END CARGA_INICIAL;

PROCEDURE CARGA_DETALLE_MOVTOS(
  P_CODCIA        IN NUMBER  ,
  P_ORIGEN        IN VARCHAR2,
  PIDCARGA        IN NUMBER  ,
  P_FECHA_INICIAL IN DATE    ,
  P_FECHA_FINAL   IN DATE    ,
  P_IDPROCESO     IN NUMBER  ,
  P_ID_SINIESTRO  IN NUMBER  ,
  P_ID_ERROR     OUT NUMBER  ,
  P_MENSAJE      OUT VARCHAR2) IS
  
  nSINIESTRO          SINIESTRO.IDSINIESTRO%TYPE; 
  nIDTRANSACCION      COBERTURA_SINIESTRO.IDTRANSACCION%TYPE;    

  cCOBERTURA_ACT      RESERVA_DET.ID_COBERTURA%TYPE;
  cCOBERTURA_ANT      RESERVA_DET.ID_COBERTURA%TYPE;

  cTIPO_MOVTO         RESERVA_DET.TIPO_MOVIMIENTO%TYPE;
  --
  nEXISTE_SINIESTRO   NUMBER;
  cSIGNO              VARCHAR2(1);

  --- 
  nREGISTROS          NUMBER;  
  nNumMovtosA         NUMBER;
  nNumMovtosD         NUMBER;
  nImporteAA          NUMBER(18,2);
  nImporteAD          NUMBER(18,2);
 
  nMOVTO                NUMBER := 0;
  REC_RESERVA_DET      RESERVA_DET%ROWTYPE;
  
CURSOR INICIAL IS
   SELECT DISTINCT DT.VALOR1 SINI
     FROM TRANSACCION         T,
          DETALLE_TRANSACCION DT
    WHERE TRUNC(T.FECHATRANSACCION) BETWEEN P_FECHA_INICIAL AND P_FECHA_FINAL    
      AND DT.IDTRANSACCION = T.IDTRANSACCION     
      AND T.IDPROCESO = 6
      AND DT.VALOR1   =  DECODE(P_ID_SINIESTRO,0,DT.VALOR1,P_ID_SINIESTRO)      
    ORDER BY 1;     
--
-- TRANSACCION RESERVA
--
CURSOR TRAN IS
   SELECT *
FROM (
SELECT DT.VALOR1 SINI,
       DECODE(CD.MOVDEBCRED,'C',T.IDTRANSACCION) TRANSAC,
       DECODE(CD.MOVDEBCRED,'D',T.IDTRANSACCION) TRANSACANUL,
       DECODE(CD.MOVDEBCRED,'C','+','-') SIGNO,
       DT.OBJETO
FROM   TRANSACCION T,
       DETALLE_TRANSACCION DT,
       COMPROBANTES_CONTABLES CC,
       COMPROBANTES_DETALLE   CD
WHERE  T.IDPROCESO = 6
AND    DT.IDTRANSACCION  = T.IDTRANSACCION
AND    DT.CODSUBPROCESO != 'SIN'
AND    DT.OBJETO        IN ('COBERTURA_SINIESTRO', 'COBERTURA_SINIESTRO_ASEG')
AND    DT.VALOR1         = nSINIESTRO
AND    CC.NUMTRANSACCION = DT.IDTRANSACCION
AND    CD.CODCIA        = 1
AND    CD.NUMCOMPROB    = CC.NUMCOMPROB
AND (( CD.NIVELCTA1     = '2'
AND    CD.NIVELCTA2     = '1'
AND    CD.NIVELCTA3     = '21')
OR   ( CD.NIVELCTA1     = '2'
AND    CD.NIVELCTA2     = '4'
AND    CD.NIVELCTA3     = '08'))
)
ORDER BY 1, 2,3
;
--
-- DETALLE_TRANSACCION RESERVA
--
CURSOR DET_TRAN IS
   SELECT NVL(T.IDTRANSACCION,0)  TRANSAC,
          TRUNC(FECHATRANSACCION) FETRANSAC,
          TO_NUMBER(TO_CHAR(FECHATRANSACCION,'YYYY')) AÑO_FETRANSAC,
          TO_NUMBER(TO_CHAR(FECHATRANSACCION,'MM'))   MES_FETRANSAC,
          DT.CORRELATIVO  SECUEN,       
          T.USUARIOGENERO USUARIO,
          TRIM(DT.CODSUBPROCESO) SUBPROCESO,
          NVL(VALOR1,' ')  SINIESTRO,
          NVL(VALOR2,' ')  POLIZA,
          NVL(VALOR3,' ')  COBERTURA,
          NVL(VALOR4,' ')  NMOD,
          NVL(MTOLOCAL,0)  MTLOCAL,
          MTOLOCAL         MTLOCAL_NUM,
          T.IDPROCESO      PROCESO
     FROM TRANSACCION         T,
          DETALLE_TRANSACCION DT
    WHERE T.IDTRANSACCION  = nIDTRANSACCION
      AND TRUNC(T.FECHATRANSACCION) BETWEEN P_FECHA_INICIAL AND P_FECHA_FINAL 
      --
      AND DT.IDTRANSACCION = T.IDTRANSACCION
    ORDER BY T.FECHATRANSACCION;
--
-- TRANSACCION APROBACION
--
CURSOR TRAN_A IS
   SELECT NVL(A.IDTRANSACCION,0)     TRANSAC,
          NVL(A.IDTRANSACCIONANUL,0) TRANSACANUL
     FROM APROBACIONES A
    WHERE A.IDSINIESTRO = nSINIESTRO
   UNION
   SELECT NVL(AA.IDTRANSACCION,0)     TRANSAC,
          NVL(AA.IDTRANSACCIONANUL,0) TRANSACANUL
     FROM APROBACION_ASEG AA
    WHERE AA.IDSINIESTRO = nSINIESTRO
    ORDER BY 1;
--
-- DETALLE TRANSACCION APROBACION
--
CURSOR DET_TRAN_A IS
SELECT NVL(T.IDTRANSACCION,0)  TRANSAC,
       TRUNC(T.FECHATRANSACCION) FETRANSAC,
       TO_NUMBER(TO_CHAR(FECHATRANSACCION,'YYYY')) AÑO_FETRANSAC,
       TO_NUMBER(TO_CHAR(FECHATRANSACCION,'MM'))   MES_FETRANSAC,
       T.USUARIOGENERO USUARIO,              
       DT.CORRELATIVO   SECUEN,
       DT.CODSUBPROCESO SUBPROCESO,
       DT.OBJETO        OBJETO,
       NVL(VALOR1,' ')  SINIESTRO,
       NVL(VALOR2,' ')  POLIZA,
       SUBSTR(NVL(VALOR4,' '),1,3)  NMOD,
       T.IDPROCESO      PROCESO,
       DA.CODTRANSAC,
       DA.IDDETAPROB,
       DA.CODCPTOTRANSAC,       
       DA.COD_PAGO      COBERTURA,
       DA.MONTO_LOCAL   MTLOCAL,
       CTS.SIGNO        SIGNO       
  FROM TRANSACCION         T,
       DETALLE_TRANSACCION DT,
       DETALLE_APROBACION_ASEG  DA,
       CONFIG_TRANSAC_SINIESTROS CTS
 WHERE T.IDTRANSACCION  = nIDTRANSACCION
   AND TRUNC(T.FECHATRANSACCION) BETWEEN P_FECHA_INICIAL AND P_FECHA_FINAL
   --
   AND DT.IDTRANSACCION = T.IDTRANSACCION
   --
   AND DA.IDSINIESTRO    = TO_NUMBER(DT.VALOR1)
   AND DA.NUM_APROBACION = TO_NUMBER(DT.VALOR4)
   AND DA.COD_PAGO  NOT IN ('IMPTO','RETENC')
   AND DA.CODCPTOTRANSAC NOT IN ('SUPMED')
   --
   AND CTS.CODCIA        = T.CODCIA
   AND CTS.CODTRANSAC    = DA.CODTRANSAC 
UNION
SELECT NVL(T.IDTRANSACCION,0)  TRANSAC,
       TRUNC(T.FECHATRANSACCION) FETRANSAC,
       TO_NUMBER(TO_CHAR(FECHATRANSACCION,'YYYY')) AÑO_FETRANSAC,
       TO_NUMBER(TO_CHAR(FECHATRANSACCION,'MM'))   MES_FETRANSAC,
       T.USUARIOGENERO  USUARIO,
       DT.CORRELATIVO   SECUEN,
       DT.CODSUBPROCESO SUBPROCESO,
       DT.OBJETO        OBJETO,
       NVL(VALOR1,' ')  SINIESTRO,
       NVL(VALOR2,' ')  POLIZA,
       SUBSTR(NVL(VALOR4,' '),1,3)  NMOD,
       T.IDPROCESO      PROCESO,
       DA.CODTRANSAC,
       DA.IDDETAPROB,
       DA.CODCPTOTRANSAC,
       DA.COD_PAGO      COBERTURA,
       DA.MONTO_LOCAL   MTLOCAL,
       CTS.SIGNO        SIGNO
  FROM TRANSACCION         T,
       DETALLE_TRANSACCION DT,
       DETALLE_APROBACION DA,
       CONFIG_TRANSAC_SINIESTROS CTS
 WHERE T.IDTRANSACCION  = nIDTRANSACCION
   AND TRUNC(T.FECHATRANSACCION) BETWEEN P_FECHA_INICIAL AND P_FECHA_FINAL
   --
   AND DT.IDTRANSACCION = T.IDTRANSACCION
   --
   AND DA.IDSINIESTRO    = TO_NUMBER(DT.VALOR1)
   AND DA.NUM_APROBACION = TO_NUMBER(DT.VALOR4)
   AND DA.COD_PAGO  NOT IN ('IMPTO','RETENC')
   AND DA.CODCPTOTRANSAC NOT IN ('SUPMED')
   --
   AND CTS.CODCIA        = T.CODCIA
   AND CTS.CODTRANSAC    = DA.CODTRANSAC 
  ORDER BY 2, 11,14;

PROCEDURE INSERTA_RESERVA_DET(
  P_RESERVA_DET  IN RESERVA_DET%ROWTYPE,
  P_ID_ERROR    OUT NUMBER          ,
  P_MENSAJE     OUT VARCHAR2       ) IS
  
  REC_RESERVA_DET RESERVA_DET%ROWTYPE;
BEGIN
   P_ID_ERROR   := 0;
   REC_RESERVA_DET  := P_RESERVA_DET;
   VGNOMPROCFUN := 'INSERTA_RESERVA_DET';
   
   INSERT INTO RESERVA_DET VALUES REC_RESERVA_DET;
EXCEPTION
  WHEN OTHERS THEN
     P_ID_ERROR := SQLCODE;    
     P_MENSAJE  := VGNOMPROCFUN||'/'||SQLERRM;
     RAISE_APPLICATION_ERROR(-20230,'Error en : '||P_MENSAJE);
END;

PROCEDURE DELETE_RESERVA_DET(
  P_RESERVA_DET  IN RESERVA_DET%ROWTYPE,
  P_ID_ERROR    OUT NUMBER         ,
  P_MENSAJE     OUT VARCHAR2       ) IS

  REC_RESERVA_DET RESERVA_DET%ROWTYPE;
BEGIN
   VG_ID_ERROR   := 0;
   REC_RESERVA_DET  := P_RESERVA_DET;
   VGNOMPROCFUN := 'DELETE_RESERVA_DET';
    
   DELETE FROM RESERVA_DET RD
    WHERE RD.ID_SINIESTRO    = REC_RESERVA_DET.ID_SINIESTRO
      AND RD.ID_COBERTURA    = REC_RESERVA_DET.ID_COBERTURA
      AND RD.NMOD            = REC_RESERVA_DET.NMOD 
      AND RD.AÑO_MOVIMIENTO  = REC_RESERVA_DET.AÑO_MOVIMIENTO
      AND RD.MES_MOVIMIENTO  = REC_RESERVA_DET.MES_MOVIMIENTO
      AND RD.TRANSACCION     = REC_RESERVA_DET.TRANSACCION
      AND RD.FE_MOVTO        = REC_RESERVA_DET.FE_MOVTO
      AND RD.TIPO_MOVIMIENTO = REC_RESERVA_DET.TIPO_MOVIMIENTO;
      
    P_ID_ERROR :=  VG_ID_ERROR; 
EXCEPTION
   WHEN OTHERS THEN
     P_ID_ERROR := SQLCODE;    
     P_MENSAJE  := VGNOMPROCFUN||'/'||SQLERRM; 
     RAISE_APPLICATION_ERROR(-20230,'Error en : '||P_MENSAJE);
END;
       
BEGIN
   VG_ID_ERROR  := 0;
   P_ID_ERROR   := VG_ID_ERROR;
   VGNOMPROCFUN := 'CARGA_DETALLE_MOVTOS';
   VGVALIDACION := FUNIDVALIDA;  
   nREGISTROS  := 0;
   nNumMovtosA := 0;
   nNumMovtosD := 0;
   nImporteAA  := 0;
   nImporteAD  := 0;
   
   --- cuadn hay un reproceso de siniestro se debe de elminar la historia
   IF P_IDPROCESO = 2 THEN
   BEGIN
      DELETE FROM RESERVA_DET RD
      WHERE RD.ID_SINIESTRO    = P_ID_SINIESTRO;      
   END;
   END IF;
   
   FOR I IN INICIAL LOOP
      nSINIESTRO := I.SINI;
      nREGISTROS := nREGISTROS + 1;    
      --
      -- TRANSACCIONES DE RESERVA
      --
      VG_MENSAJE := '1.TRANSACCIONES DE RESERVA';     
      FOR T IN TRAN LOOP
         nIDTRANSACCION := T.TRANSAC; 
         cSIGNO         := T.SIGNO;          
         FOR DT IN DET_TRAN LOOP
            BEGIN
               SELECT COUNT(*)
                 INTO nEXISTE_SINIESTRO
                 FROM RESERVA_DET RD
                WHERE RD.ID_SINIESTRO   = nSINIESTRO
                  AND RD.ID_COBERTURA   = DT.COBERTURA  
                  AND RD.NMOD           = DT.NMOD 
                  AND RD.AÑO_MOVIMIENTO = DT.AÑO_FETRANSAC
                  AND RD.MES_MOVIMIENTO = DT.MES_FETRANSAC
                  AND RD.TRANSACCION    = DT.TRANSAC
                  AND RD.FE_MOVTO       = DT.FETRANSAC;    
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  nEXISTE_SINIESTRO := 0;
               WHEN OTHERS THEN    
                  nEXISTE_SINIESTRO := 0;
            END; 
            
            IF nEXISTE_SINIESTRO = 0 THEN 
               IF DT.SUBPROCESO != 'SIN' THEN 
                  IF DT.NMOD = 1 THEN
                     cTIPO_MOVTO := 'ESTINI';                   
                  ELSE
                     IF cSIGNO = '+' THEN
                        cTIPO_MOVTO := 'AJUMAS';
                     ELSE
                        cTIPO_MOVTO := 'AJUMEN';
                     END IF;     
                  END IF;
                  IF DT.SUBPROCESO = 'EMIRES' AND T.TRANSACANUL != 0 THEN
                     cSIGNO := '+';
                  END IF;  
                                     
                  REC_RESERVA_DET.TRANSACCION      := DT.TRANSAC;                                        
                  REC_RESERVA_DET.ID_SINIESTRO     := DT.SINIESTRO;      
                  REC_RESERVA_DET.ID_POLIZA        := DT.POLIZA;
                  REC_RESERVA_DET.ID_COBERTURA     := DT.COBERTURA;
                  REC_RESERVA_DET.TIPO_MOVIMIENTO  := cTIPO_MOVTO;    
                  REC_RESERVA_DET.IMPTE_MOVIMIENTO := DT.MTLOCAL;    
                  REC_RESERVA_DET.FE_MOVTO         := DT.FETRANSAC;
                  REC_RESERVA_DET.AÑO_MOVIMIENTO   := DT.AÑO_FETRANSAC;
                  REC_RESERVA_DET.MES_MOVIMIENTO   := DT.MES_FETRANSAC;                                   
                  REC_RESERVA_DET.NMOD             := DT.NMOD; 
                  REC_RESERVA_DET.PROCESO          := DT.PROCESO;  
                  REC_RESERVA_DET.SUBPROCESO       := DT.SUBPROCESO;
                  REC_RESERVA_DET.SIGNO            := cSIGNO;              
                  REC_RESERVA_DET.CODCIA           := P_CODCIA;  
                  REC_RESERVA_DET.ID_ORIGEN        := P_ORIGEN;
                  REC_RESERVA_DET.ID_VALIDACION    := VGVALIDACION;
                  REC_RESERVA_DET.ID_PROCESO       := P_IDPROCESO;
                  
                  INSERTA_RESERVA_DET(REC_RESERVA_DET,VG_ID_ERROR, VG_MENSAJE);               
                  
                  IF (cTIPO_MOVTO = 'ESTINI') OR (cTIPO_MOVTO = 'AJUMAS') THEN
                     nNumMovtosA := nNumMovtosA + 1;
                     nImporteAA  := nImporteAA  + DT.MTLOCAL;
                  ELSE
                     nNumMovtosD := nNumMovtosD + 1;  
                     nImporteAD  := nImporteAD  + DT.MTLOCAL;
                  END IF;
               END IF;   
            END IF;     
         END LOOP;
         
      END LOOP;
      IF nNumMovtosA > 0 THEN
         CTROL_CGA_RVA (PIDCARGA     , 1,   P_IDPROCESO, P_FECHA_INICIAL, P_FECHA_FINAL, NULL,        0, 
                        0,             0,   nImporteAA,  nNumMovtosA,     nImporteAD   , nNumMovtosD,   0,
                        0,             0,   NULL,         NULL,    USER  ,VG_ID_ERROR  , VG_MENSAJE);
      END IF;
      --
      -- TRANSACCION DE ANULACION DE RESERVA
      --
      nImporteAA := 0;  nNumMovtosA := 0;
      nNumMovtosD:= 0;  nImporteAD  := 0;
      VG_MENSAJE := '2.TRANSACCIONES ANULACION DE RESERVA';
      FOR T IN TRAN LOOP
         nIDTRANSACCION := T.TRANSACANUL;
         cSIGNO         := T.SIGNO;
         cTIPO_MOVTO    := 'AJUMEN';
         FOR DT IN DET_TRAN LOOP
            BEGIN
               SELECT COUNT(*)
                 INTO nEXISTE_SINIESTRO
                 FROM RESERVA_DET RD
                WHERE RD.ID_SINIESTRO    = nSINIESTRO
                  AND RD.ID_COBERTURA    = DT.COBERTURA  
                  AND RD.NMOD            = DT.NMOD 
                  AND RD.AÑO_MOVIMIENTO  = DT.AÑO_FETRANSAC
                  AND RD.MES_MOVIMIENTO  = DT.MES_FETRANSAC 
                  AND RD.TRANSACCION     = DT.TRANSAC
                  AND RD.FE_MOVTO        = DT.FETRANSAC  
                  AND RD.TIPO_MOVIMIENTO = cTIPO_MOVTO;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  nEXISTE_SINIESTRO := 0;
               WHEN OTHERS THEN
                  nEXISTE_SINIESTRO := 0;   
            END; 
  
            IF nEXISTE_SINIESTRO = 0 THEN 
               REC_RESERVA_DET.ID_SINIESTRO     := DT.SINIESTRO;      
               REC_RESERVA_DET.ID_POLIZA        := DT.POLIZA;
               REC_RESERVA_DET.ID_COBERTURA     := DT.COBERTURA;
               REC_RESERVA_DET.TIPO_MOVIMIENTO  := cTIPO_MOVTO;    
               REC_RESERVA_DET.IMPTE_MOVIMIENTO := ABS(DT.MTLOCAL);    
               REC_RESERVA_DET.FE_MOVTO         := DT.FETRANSAC;
               REC_RESERVA_DET.AÑO_MOVIMIENTO   := DT.AÑO_FETRANSAC;
               REC_RESERVA_DET.MES_MOVIMIENTO   := DT.MES_FETRANSAC;      
               REC_RESERVA_DET.TRANSACCION      := DT.TRANSAC;
               REC_RESERVA_DET.NMOD             := DT.NMOD; 
               REC_RESERVA_DET.PROCESO          := DT.PROCESO;  
               REC_RESERVA_DET.SUBPROCESO       := DT.SUBPROCESO;
               REC_RESERVA_DET.SIGNO            := cSIGNO;              
               REC_RESERVA_DET.CODCIA           := P_CODCIA;  
               REC_RESERVA_DET.ID_ORIGEN        := P_ORIGEN;
               REC_RESERVA_DET.ID_VALIDACION    := VGVALIDACION;
               REC_RESERVA_DET.ID_PROCESO       := P_IDPROCESO;
               nNumMovtosD := nNumMovtosD + 1;  
               nImporteAD  := nImporteAD  + REC_RESERVA_DET.IMPTE_MOVIMIENTO;
                  
               INSERTA_RESERVA_DET(REC_RESERVA_DET,VG_ID_ERROR, VG_MENSAJE);  
            END IF;       
         END LOOP;
      END LOOP; 
      
      IF nNumMovtosD <> 0 THEN
         CTROL_CGA_RVA (PIDCARGA     , 1,   P_IDPROCESO, P_FECHA_INICIAL, P_FECHA_FINAL, NULL,    0, 
                        0,             0,   0,           nImporteAD,      nNumMovtosD,   0,    0,
                        0,             0,   NULL,        NULL,    USER,  VG_ID_ERROR,   VG_MENSAJE);      
      END IF;
      --
      -- TRANSACCION DE APROBACIONES
      --
      VG_MENSAJE := '3.TRANSACCION DE APROBACIONES';  
      nNumMovtosA := 0;  nImporteAA := 0;          
      FOR T IN TRAN_A LOOP
         nIDTRANSACCION := T.TRANSAC;          
         FOR DT IN DET_TRAN_A LOOP  
            cCOBERTURA_ACT := DT.COBERTURA;           
            nMOVTO := nMOVTO + 1;
            cSIGNO := DT.SIGNO;
            cTIPO_MOVTO    := 'PAGOS';
            
            IF DT.CODTRANSAC IN ('DEDUAD','DEDUBA')THEN                               
               cCOBERTURA_ACT := cCOBERTURA_ANT; 
               cTIPO_MOVTO    := 'DEDUC';
            ELSIF DT.CODTRANSAC IN ('DESCUE') THEN  
               cTIPO_MOVTO    := 'DESCUE';    
               cCOBERTURA_ACT := cCOBERTURA_ANT; 
            ELSIF DT.COBERTURA = 'DEDUC' THEN   
               cCOBERTURA_ACT := cCOBERTURA_ANT; 
               cTIPO_MOVTO    := DT.COBERTURA;   
            END IF;  
            
            BEGIN
               SELECT COUNT(*)
                 INTO nEXISTE_SINIESTRO
                 FROM RESERVA_DET RD
                WHERE RD.ID_SINIESTRO    = nSINIESTRO
                  AND RD.ID_COBERTURA    = cCOBERTURA_ACT
                  AND RD.NMOD            = DT.NMOD 
                  AND RD.AÑO_MOVIMIENTO  = DT.AÑO_FETRANSAC
                  AND RD.MES_MOVIMIENTO  = DT.MES_FETRANSAC
                  AND RD.TRANSACCION     = DT.TRANSAC
                  AND RD.FE_MOVTO        = DT.FETRANSAC
                  AND RD.TIPO_MOVIMIENTO = cTIPO_MOVTO
                  ;    
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  nEXISTE_SINIESTRO := 0;
               WHEN OTHERS THEN
                  nEXISTE_SINIESTRO := 0; 
            END; 
            
            IF nMOVTO = 1 THEN
               cCOBERTURA_ANT := DT.COBERTURA;
            END IF;            
            IF nEXISTE_SINIESTRO = 0 THEN                    
               REC_RESERVA_DET.ID_SINIESTRO     := DT.SINIESTRO;      
               REC_RESERVA_DET.ID_POLIZA        := DT.POLIZA;
               REC_RESERVA_DET.ID_COBERTURA     := DT.COBERTURA;
               REC_RESERVA_DET.TIPO_MOVIMIENTO  := cTIPO_MOVTO;    
               REC_RESERVA_DET.IMPTE_MOVIMIENTO := ABS(DT.MTLOCAL);    
               REC_RESERVA_DET.FE_MOVTO         := DT.FETRANSAC;
               REC_RESERVA_DET.AÑO_MOVIMIENTO   := DT.AÑO_FETRANSAC;
               REC_RESERVA_DET.MES_MOVIMIENTO   := DT.MES_FETRANSAC;      
               REC_RESERVA_DET.TRANSACCION      := DT.TRANSAC;
               REC_RESERVA_DET.NMOD             := DT.NMOD; 
               REC_RESERVA_DET.PROCESO          := DT.PROCESO;  
               REC_RESERVA_DET.SUBPROCESO       := DT.SUBPROCESO;
               REC_RESERVA_DET.SIGNO            := cSIGNO;              
               REC_RESERVA_DET.CODCIA           := P_CODCIA;  
               REC_RESERVA_DET.ID_ORIGEN        := P_ORIGEN;
               REC_RESERVA_DET.ID_VALIDACION    := VGVALIDACION;
               REC_RESERVA_DET.ID_PROCESO       := P_IDPROCESO;
                  
               INSERTA_RESERVA_DET(REC_RESERVA_DET,VG_ID_ERROR, VG_MENSAJE); 
               
               nNumMovtosA := nNumMovtosA + 1;  
               nImporteAA  := nImporteAA  + REC_RESERVA_DET.IMPTE_MOVIMIENTO;  
                                                                                                     
            ELSE
               BEGIN
                 SELECT *
                   INTO REC_RESERVA_DET
                   FROM RESERVA_DET RD
                  WHERE RD.ID_SINIESTRO    = nSINIESTRO
                    AND RD.ID_COBERTURA    = cCOBERTURA_ACT
                    AND RD.NMOD            = DT.NMOD 
                    AND RD.AÑO_MOVIMIENTO  = DT.AÑO_FETRANSAC
                    AND RD.MES_MOVIMIENTO  = DT.MES_FETRANSAC
                    AND RD.TRANSACCION     = DT.TRANSAC
                    AND RD.FE_MOVTO        = DT.FETRANSAC
                    AND RD.TIPO_MOVIMIENTO = cTIPO_MOVTO;
               EXCEPTION
                  WHEN OTHERS THEN
                     nEXISTE_SINIESTRO := nSINIESTRO;
               END;
               
               IF DT.MTLOCAL != REC_RESERVA_DET.IMPTE_MOVIMIENTO AND DT.CODTRANSAC NOT IN ('DEDUAD','DEDUBA') THEN
                  DELETE_RESERVA_DET(REC_RESERVA_DET,VG_ID_ERROR, VG_MENSAJE);
                  IF VG_ID_ERROR = 0 THEN
                    INSERTA_RESERVA_DET(REC_RESERVA_DET,VG_ID_ERROR, VG_MENSAJE);
                  END IF;
               ELSIF  DT.IDDETAPROB > 1 AND  DT.CODTRANSAC NOT IN ('DEDUAD','DEDUBA') THEN
                  UPDATE RESERVA_DET RD
                  SET    IMPTE_MOVIMIENTO =  IMPTE_MOVIMIENTO + ABS(DT.MTLOCAL)
                  WHERE RD.ID_SINIESTRO    = nSINIESTRO
                    AND RD.ID_COBERTURA    = cCOBERTURA_ACT
                    AND RD.NMOD            = DT.NMOD 
                    AND RD.AÑO_MOVIMIENTO  = DT.AÑO_FETRANSAC
                    AND RD.MES_MOVIMIENTO  = DT.MES_FETRANSAC
                    AND RD.TRANSACCION     = DT.TRANSAC
                    AND RD.FE_MOVTO        = DT.FETRANSAC
                    AND RD.TIPO_MOVIMIENTO = cTIPO_MOVTO;   
               END IF;                
            END IF;  
                        
            cCOBERTURA_ANT := cCOBERTURA_ACT;     
         END LOOP;
      END LOOP; 
      IF nNumMovtosA > 0 THEN
         CTROL_CGA_RVA (PIDCARGA  ,  1,   P_IDPROCESO, P_FECHA_INICIAL, P_FECHA_FINAL, NULL,        0, 
                        0,           0,   0,           0,               0,             nNumMovtosA, nImporteAA,
                        0,           0,   NULL,        NULL,            USER,          VG_ID_ERROR,  VG_MENSAJE);      
      END IF;
      --
      -- TRANSACCION DE ANULACION  DE APROBACIONES
      --
      VG_MENSAJE := '4.TRANSACCION DE ANULACION  DE APROBACIONES';   
      nNumMovtosD := 0;  nImporteAD := 0;     
      FOR T IN TRAN_A LOOP
         nIDTRANSACCION := T.TRANSACANUL;
         
         FOR DT IN DET_TRAN_A LOOP
            cCOBERTURA_ACT := DT.COBERTURA;           
            nMOVTO         := nMOVTO + 1;
            cSIGNO         := DT.SIGNO;
            
            cTIPO_MOVTO    := 'DESPAG';
            
            IF (DT.COBERTURA = 'DEDUC' AND DT.CODTRANSAC IN ('DEDUAD','DEDUBA')) THEN                
               cCOBERTURA_ACT := cCOBERTURA_ANT; 
               cTIPO_MOVTO    := DT.COBERTURA;
                  
            ELSIF (DT.COBERTURA = 'DEDUC' AND DT.CODTRANSAC IN ('DESCUE')) THEN      
               cCOBERTURA_ACT := cCOBERTURA_ANT; 
               cTIPO_MOVTO    := 'DESCUE';
            ELSIF DT.COBERTURA = 'DEDUC' THEN   
               cCOBERTURA_ACT := cCOBERTURA_ANT; 
               cTIPO_MOVTO    := DT.COBERTURA;  
            END IF; 
            
            BEGIN
               SELECT COUNT(*)
                 INTO nEXISTE_SINIESTRO
                 FROM RESERVA_DET RD
                WHERE RD.ID_SINIESTRO    = nSINIESTRO
                  AND RD.ID_COBERTURA    = cCOBERTURA_ACT
                  AND RD.NMOD            = DT.NMOD 
                  AND RD.AÑO_MOVIMIENTO  = DT.AÑO_FETRANSAC
                  AND RD.MES_MOVIMIENTO  = DT.MES_FETRANSAC
                  AND RD.TRANSACCION     = DT.TRANSAC
                  AND RD.FE_MOVTO        = DT.FETRANSAC
                  AND RD.TIPO_MOVIMIENTO = cTIPO_MOVTO
                  ;    
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  nEXISTE_SINIESTRO := 0;
               WHEN OTHERS THEN
                  nEXISTE_SINIESTRO := 0; 
            END; 
            
            IF nMOVTO = 1 THEN
               cCOBERTURA_ANT := DT.COBERTURA;
            END IF;
                        
            IF nEXISTE_SINIESTRO = 0 THEN    
               REC_RESERVA_DET.ID_SINIESTRO     := DT.SINIESTRO;      
               REC_RESERVA_DET.ID_POLIZA        := DT.POLIZA;
               REC_RESERVA_DET.ID_COBERTURA     := DT.COBERTURA;
               REC_RESERVA_DET.TIPO_MOVIMIENTO  := cTIPO_MOVTO;    
               REC_RESERVA_DET.IMPTE_MOVIMIENTO := ABS(DT.MTLOCAL);    
               REC_RESERVA_DET.FE_MOVTO         := DT.FETRANSAC;
               REC_RESERVA_DET.AÑO_MOVIMIENTO   := DT.AÑO_FETRANSAC;
               REC_RESERVA_DET.MES_MOVIMIENTO   := DT.MES_FETRANSAC;      
               REC_RESERVA_DET.TRANSACCION      := DT.TRANSAC;
               REC_RESERVA_DET.NMOD             := DT.NMOD; 
               REC_RESERVA_DET.PROCESO          := DT.PROCESO;  
               REC_RESERVA_DET.SUBPROCESO       := DT.SUBPROCESO;
               REC_RESERVA_DET.SIGNO            := cSIGNO;              
               REC_RESERVA_DET.CODCIA           := P_CODCIA;  
               REC_RESERVA_DET.ID_ORIGEN        := P_ORIGEN;
               REC_RESERVA_DET.ID_VALIDACION    := VGVALIDACION;
               REC_RESERVA_DET.ID_PROCESO       := P_IDPROCESO;
                  
               INSERTA_RESERVA_DET(REC_RESERVA_DET,VG_ID_ERROR, VG_MENSAJE);
               nNumMovtosD :=  nNumMovtosD + 1;  
               nImporteAD  :=  nImporteAD  + REC_RESERVA_DET.IMPTE_MOVIMIENTO; 
             ELSE
                BEGIN
                 SELECT *
                   INTO REC_RESERVA_DET
                   FROM RESERVA_DET RD
                  WHERE RD.ID_SINIESTRO    = nSINIESTRO
                    AND RD.ID_COBERTURA    = cCOBERTURA_ACT
                    AND RD.NMOD            = DT.NMOD 
                    AND RD.AÑO_MOVIMIENTO  = DT.AÑO_FETRANSAC
                    AND RD.MES_MOVIMIENTO  = DT.MES_FETRANSAC
                    AND RD.TRANSACCION     = DT.TRANSAC
                    AND RD.FE_MOVTO        = DT.FETRANSAC
                    AND RD.TIPO_MOVIMIENTO = cTIPO_MOVTO;
               EXCEPTION
                  WHEN OTHERS THEN
                     nEXISTE_SINIESTRO := nSINIESTRO;
               END;
               
               IF DT.MTLOCAL != REC_RESERVA_DET.IMPTE_MOVIMIENTO AND DT.CODTRANSAC NOT IN ('DEDUAD','DEDUBA') THEN
                  DELETE_RESERVA_DET(REC_RESERVA_DET,VG_ID_ERROR, VG_MENSAJE);
                  IF VG_ID_ERROR = 0 THEN
                    INSERTA_RESERVA_DET(REC_RESERVA_DET,VG_ID_ERROR, VG_MENSAJE);
                  END IF;
               ELSIF  DT.IDDETAPROB > 1 AND  DT.CODTRANSAC NOT IN ('DEDUAD','DEDUBA') THEN
                  UPDATE RESERVA_DET RD
                  SET    IMPTE_MOVIMIENTO =  IMPTE_MOVIMIENTO + ABS(DT.MTLOCAL)
                  WHERE RD.ID_SINIESTRO    = nSINIESTRO
                    AND RD.ID_COBERTURA    = cCOBERTURA_ACT
                    AND RD.NMOD            = DT.NMOD 
                    AND RD.AÑO_MOVIMIENTO  = DT.AÑO_FETRANSAC
                    AND RD.MES_MOVIMIENTO  = DT.MES_FETRANSAC
                    AND RD.TRANSACCION     = DT.TRANSAC
                    AND RD.FE_MOVTO        = DT.FETRANSAC
                    AND RD.TIPO_MOVIMIENTO = cTIPO_MOVTO;   
               END IF;         
             END IF;  
             
             cCOBERTURA_ANT := cCOBERTURA_ACT;
                
          END LOOP;
      END LOOP;
      --      
      IF SUBSTR(nREGISTROS,-3,3) = '000' THEN
         COMMIT;
      END IF;        
   END LOOP;
   IF nNumMovtosD > 0 THEN
      CTROL_CGA_RVA (PIDCARGA  ,  1,            P_IDPROCESO, P_FECHA_INICIAL, P_FECHA_FINAL, NULL,    0, 
                     0,           0,            0,           0,               0,             0,       0,
                     nNumMovtosD, nImporteAD,   NULL,        NULL,            USER,          VG_ID_ERROR,  VG_MENSAJE); 
   END IF;
   --COMMIT;
EXCEPTION
   WHEN OTHERS THEN  
      DBMS_OUTPUT.PUT_LINE('EROR:'||nSINIESTRO||'/'||SQLERRM);    
      P_ID_ERROR := VG_ID_ERROR;
      P_MENSAJE  := VGNOMPACKAGE||'/'||VG_MENSAJE||'/'||nSINIESTRO;            
      RAISE_APPLICATION_ERROR(-20230,'Error en : '||P_MENSAJE);
END CARGA_DETALLE_MOVTOS;

PROCEDURE CARGA_RESUMEN_MOVTOS(
  P_CODCIA        IN NUMBER,
  P_ORIGEN        IN VARCHAR2,
  P_FECHA_INICIAL IN DATE,
  P_FECHA_FINAL   IN DATE,
  P_IDPROCESO     IN NUMBER  ,
  P_ID_SINIESTRO  IN NUMBER,
  P_ID_ERROR OUT NUMBER  ,
  P_MENSAJE  OUT VARCHAR2) IS
 
  V_SINIESTRO         SINIESTRO.IDSINIESTRO%TYPE; 
  V_SINIESTRO_ANT     SINIESTRO.IDSINIESTRO%TYPE; 
  V_NUMSINIREF        SINIESTRO.NUMSINIREF%TYPE;
  V_FEC_NOTIFICACION  SINIESTRO.FEC_NOTIFICACION%TYPE;
  V_FEC_OCURRENCIA    SINIESTRO.FEC_OCURRENCIA%TYPE;
  V_IDPOLIZA          POLIZAS.IDPOLIZA%TYPE;
  V_FECINIVIG         POLIZAS.FECINIVIG%TYPE;
  V_FECFINVIG         POLIZAS.FECFINVIG%TYPE;
  V_NUMPOLUNICO       POLIZAS.NUMPOLUNICO%TYPE;
  V_COD_ASEGURADO     SINIESTRO.COD_ASEGURADO%TYPE;
  V_CODCLIENTE        POLIZAS.CODCLIENTE%TYPE;
  V_IDTIPOSEG         DETALLE_POLIZA.IDTIPOSEG%TYPE;
  V_AÑO               NUMBER := 0; 
  V_MES               NUMBER := 0;  

  V_CUENTA_NUEVOS     NUMBER;
  V_EXISTE_SINIESTRO  NUMBER;
  V_RESERVA_ANT       RESERVA.RESERVA_ANTERIOR%TYPE := 0;
  V_RESERVA_FINAL     RESERVA.RESERVA_FINAL%TYPE    := 0;
  V_MOVTO             NUMBER;
  V_ANIOMES_ACT       NUMBER(6);
  V_ANIOMES_ANT       NUMBER(6); 
  V_ANIOMES_PROC      NUMBER(6); 
  V_COBERT_ANT        COBERTURA_SINIESTRO_ASEG.CODCOBERT%TYPE;
  V_COBERT_ACT        COBERTURA_SINIESTRO_ASEG.CODCOBERT%TYPE;
  V_ULTANIOMES        VARCHAR2(6);
  V_CONTCOBS          NUMBER := 0;


  REC_RESERVA    RESERVA%ROWTYPE;


  V_REGISTROS    NUMBER;

  CURSOR INICIAL IS
  SELECT TO_CHAR(DT.FE_MOVTO,'YYYYMM') ANIOMES,
         TO_CHAR(DT.FE_MOVTO,'YYYY') ANIO, 
         TO_CHAR(DT.FE_MOVTO,'MM') MES, 
         DT.ID_SINIESTRO SINI, 
         DT.ID_COBERTURA
   FROM  RESERVA_DET DT
   WHERE DT.FE_MOVTO BETWEEN P_FECHA_INICIAL AND P_FECHA_FINAL
   AND   DT.ID_SINIESTRO   =  DECODE(P_ID_SINIESTRO,0,DT.ID_SINIESTRO,P_ID_SINIESTRO)
GROUP BY TO_CHAR(DT.FE_MOVTO,'YYYYMM'), TO_CHAR(DT.FE_MOVTO,'YYYY'), TO_CHAR(DT.FE_MOVTO,'MM'),
            DT.ID_SINIESTRO, DT.ID_COBERTURA      
  ORDER BY 4,5,1;

  CURSOR COB_RES IS
  SELECT ID_COBERTURA,
         SUM(ESTINI) ESTINI,
         SUM(AJUMAS) AJUMAS,
         SUM(AJUMEN) AJUMEN,
         SUM(PAGOS)  PAGOS,
         SUM(DESPAG) DESPAG
    FROM (
          SELECT DT.ID_COBERTURA,
                 DT.TIPO_MOVIMIENTO,
                 SUM(CASE WHEN DT.SIGNO = '+' THEN DT.IMPTE_MOVIMIENTO
                     ELSE DT.IMPTE_MOVIMIENTO *-1
                     END) ESTINI,
                 0 AJUMAS,
                 0 AJUMEN,
                 0 PAGOS,
                 0 DESPAG
            FROM RESERVA_DET DT
           WHERE DT.ID_SINIESTRO    = V_SINIESTRO
             AND DT.TIPO_MOVIMIENTO = 'ESTINI'
             AND DT.AÑO_MOVIMIENTO  = V_AÑO
             AND DT.MES_MOVIMIENTO  = V_MES
           GROUP BY DT.ID_COBERTURA,DT.TIPO_MOVIMIENTO       
  UNION
  SELECT DT.ID_COBERTURA,
         DT.TIPO_MOVIMIENTO,
         0 ESTINI,
         SUM(DT.IMPTE_MOVIMIENTO) AJUMAS,
         0 AJUMEN,
         0 PAGOS,
         0 DESPAG
    FROM RESERVA_DET DT
   WHERE DT.ID_SINIESTRO    = V_SINIESTRO
     AND DT.TIPO_MOVIMIENTO = 'AJUMAS'
     AND DT.AÑO_MOVIMIENTO  = V_AÑO
     AND DT.MES_MOVIMIENTO  = V_MES
   GROUP BY DT.ID_COBERTURA, DT.TIPO_MOVIMIENTO       
  UNION
  SELECT DT.ID_COBERTURA,
         DT.TIPO_MOVIMIENTO,
         0 ESTINI,
         0 AJUMAS,
         SUM(DT.IMPTE_MOVIMIENTO) AJUMEN,
         0 PAGOS,
         0 DESPAG
    FROM RESERVA_DET DT
   WHERE DT.ID_SINIESTRO    = V_SINIESTRO
     AND DT.TIPO_MOVIMIENTO = 'AJUMEN'
     AND DT.AÑO_MOVIMIENTO  = V_AÑO
     AND DT.MES_MOVIMIENTO  = V_MES
   GROUP BY DT.ID_COBERTURA, DT.TIPO_MOVIMIENTO
  UNION
  SELECT DT.ID_COBERTURA,
         CASE WHEN DT.TIPO_MOVIMIENTO = 'DEDUC'  THEN 'PAGOS'
              WHEN DT.TIPO_MOVIMIENTO = 'DESCUE' THEN 'PAGOS'
              ELSE DT.TIPO_MOVIMIENTO
         END TIPO_MOVIMIENTO,                         
         0 ESTINI,
         0 AJUMAS,
         0 AJUMEN,
         SUM(CASE WHEN DT.TIPO_MOVIMIENTO = 'PAGOS' THEN DT.IMPTE_MOVIMIENTO
                  WHEN DT.TIPO_MOVIMIENTO = 'DEDUC' AND DT.SIGNO= '-' THEN 
                       DT.IMPTE_MOVIMIENTO *-1
                  WHEN DT.TIPO_MOVIMIENTO = 'DESCUE' AND DT.SIGNO= '-' THEN 
                       DT.IMPTE_MOVIMIENTO *-1
             END) PAGOS,
         0 DESPAG
    FROM RESERVA_DET DT
   WHERE DT.ID_SINIESTRO    = V_SINIESTRO
     AND DT.TIPO_MOVIMIENTO IN ('PAGOS','DEDUC','DESCUE')
     AND DT.AÑO_MOVIMIENTO  = V_AÑO
     AND DT.MES_MOVIMIENTO  = V_MES
     AND DT.TRANSACCION  IN (SELECT TRANSACCION 
                               FROM RESERVA_DET 
                              WHERE AÑO_MOVIMIENTO = DT.AÑO_MOVIMIENTO
                                AND MES_MOVIMIENTO = DT.MES_MOVIMIENTO
                                AND TIPO_MOVIMIENTO = 'PAGOS')
     GROUP BY DT.ID_COBERTURA,
              CASE WHEN DT.TIPO_MOVIMIENTO = 'DEDUC'  THEN 'PAGOS'
                   WHEN DT.TIPO_MOVIMIENTO = 'DESCUE' THEN 'PAGOS'
                   ELSE DT.TIPO_MOVIMIENTO
              END  
  UNION
  SELECT DT.ID_COBERTURA,
         CASE WHEN DT.TIPO_MOVIMIENTO = 'DEDUC'  THEN 'DESPAG'
              WHEN DT.TIPO_MOVIMIENTO = 'DESCUE' THEN 'DESPAG'
              ELSE DT.TIPO_MOVIMIENTO
         END TIPO_MOVIMIENTO,                         
         0 ESTINI,
         0 AJUMAS,
         0 AJUMEN,
         0 PAGOS,
         SUM(CASE WHEN DT.TIPO_MOVIMIENTO = 'DESPAG' THEN DT.IMPTE_MOVIMIENTO
                  WHEN DT.TIPO_MOVIMIENTO = 'DEDUC' AND DT.SIGNO= '-' THEN 
                       DT.IMPTE_MOVIMIENTO *-1
                  WHEN DT.TIPO_MOVIMIENTO = 'DESCUE' AND DT.SIGNO= '-' THEN 
                       DT.IMPTE_MOVIMIENTO *-1
             END) DESPAG
    FROM RESERVA_DET DT
   WHERE DT.ID_SINIESTRO    = V_SINIESTRO
     AND DT.TIPO_MOVIMIENTO IN ('DESPAG','DEDUC','DESCUE')
     AND DT.AÑO_MOVIMIENTO  = V_AÑO
     AND DT.MES_MOVIMIENTO  = V_MES
     AND DT.TRANSACCION  IN (SELECT TRANSACCION 
                               FROM RESERVA_DET 
                              WHERE AÑO_MOVIMIENTO = DT.AÑO_MOVIMIENTO
                                AND MES_MOVIMIENTO = DT.MES_MOVIMIENTO
                                AND TIPO_MOVIMIENTO = 'DESPAG')
                           
 GROUP BY DT.ID_COBERTURA,
          CASE WHEN DT.TIPO_MOVIMIENTO = 'DEDUC'  THEN 'DESPAG'
            WHEN DT.TIPO_MOVIMIENTO = 'DESCUE' THEN 'DESPAG'
            ELSE DT.TIPO_MOVIMIENTO
          END              
  )
  WHERE ID_COBERTURA = V_COBERT_ACT 
  GROUP BY ID_COBERTURA  
  ORDER BY ID_COBERTURA;

FUNCTION FUN_DIFMESES(
  PANIOMES_ACT IN NUMBER,
  PANIOMES_ANT IN NUMBER) RETURN NUMBER IS
  
  V_NUMMESES  NUMBER(8);
  
BEGIN
  VGNOMPROCFUN := 'FUN_DIFMESES';
  V_NUMMESES := MONTHS_BETWEEN(TO_DATE(PANIOMES_ACT,'YYYYMM'),TO_DATE(PANIOMES_ANT,'YYYYMM'));  
     
  RETURN (V_NUMMESES);
EXCEPTION
   WHEN OTHERS THEN
      P_MENSAJE := VGNOMPROCFUN||'/'||SQLERRM; 
      RAISE_APPLICATION_ERROR(-20230,'Error en : '||P_MENSAJE);     
      RETURN  0; 
END;

PROCEDURE RESERVA_PENDIENTE( 
  P_REC_RESERVA       IN RESERVA%ROWTYPE,
  P_RESERVA           IN RESERVA.RESERVA_FINAL%TYPE,
  P_RESERVA_FINAL     IN RESERVA.RESERVA_FINAL%TYPE,
  P_ANIOMES_ACT       IN NUMBER  ,
  P_ANIOMES_ANT       IN NUMBER  ,
  P_IDPROCESO         IN NUMBER  ,
  P_TIPODEPROCESO     IN NUMBER  , --(1-ENTRE MESES 2-A FECHA PROCESO )
  P_EXISTESIN         IN NUMBER  ,  -- 0 NO EXISTE, 1 EXISTE
  P_ID_ERROR         OUT NUMBER  ,
  P_MENSAJE          OUT VARCHAR2) IS 
  
  V_AÑO               NUMBER := 0; 
  V_MES               NUMBER := 0; 
  
  R_RESERVA          RESERVA%ROWTYPE;
  V_DIFMESES         NUMBER(8);
  
BEGIN
   P_ID_ERROR      := 0;
   VGNOMPROCFUN    := 'RESERVA_PENDIENTE';
   V_DIFMESES      := FUN_DIFMESES(P_ANIOMES_ACT,P_ANIOMES_ANT);
   R_RESERVA       := P_REC_RESERVA  ; 
           
   IF P_RESERVA_FINAL <> 0 AND ((V_DIFMESES > 1 AND P_IDPROCESO <> 2) OR (V_DIFMESES >= 1 AND P_IDPROCESO = 2)) THEN
      R_RESERVA.ESTIMACION_INICIAL := 0; 
      R_RESERVA.AJUSTES_MAS        := 0;
      R_RESERVA.AJUSTES_MENOS      := 0;
      R_RESERVA.PAGOS              := 0;
      R_RESERVA.DESPAGOS           := 0;
      R_RESERVA.RESERVA_ANTERIOR   := P_RESERVA;
      R_RESERVA.RESERVA_FINAL      := P_RESERVA;
       
      IF (P_TIPODEPROCESO= 1) THEN -- AND P_IDPROCESO <> 2) THEN
         V_DIFMESES := V_DIFMESES -1;
      END IF;      
      
      FOR Z IN 1..(V_DIFMESES) LOOP
         V_AÑO := TO_CHAR(ADD_MONTHS(TO_DATE(P_ANIOMES_ANT,'YYYYMM'),Z),'YYYY');
         V_MES := TO_CHAR(ADD_MONTHS(TO_DATE(P_ANIOMES_ANT,'YYYYMM'),Z),'MM'); 
         R_RESERVA.AÑO_MOVIMIENTO := V_AÑO;
         R_RESERVA.MES_MOVIMIENTO := V_MES;                                                 
                
         IF P_EXISTESIN = 0 THEN
            INSERT INTO RESERVA VALUES R_RESERVA;  
         ELSE
            UPDATE RESERVA
            SET    RESERVA_ANTERIOR = P_RESERVA,
                   RESERVA_FINAL    = P_RESERVA
            WHERE  AÑO_MOVIMIENTO   = V_AÑO
              AND  MES_MOVIMIENTO   = V_MES
              AND  ID_SINIESTRO     = R_RESERVA.ID_SINIESTRO
              AND  ID_COBERTURA     = R_RESERVA.ID_COBERTURA;            
         END IF;   
      END LOOP;    
   END IF;   
EXCEPTION
   WHEN OTHERS THEN
      P_ID_ERROR := SQLCODE;
      P_MENSAJE  := VGNOMPROCFUN||'/'||SQLERRM;    
      RAISE_APPLICATION_ERROR(-20230,'Error en : '||P_MENSAJE); 
END RESERVA_PENDIENTE;

BEGIN /*PRINCIPAL*/ 
   P_ID_ERROR      := 0;
   VGNOMPROCFUN    := 'CARGA_RESUMEN_MOVTOS';
   V_REGISTROS     := 0;
   V_CUENTA_NUEVOS := 0;
   V_MOVTO         := 0;
   V_COBERT_ACT    := '';
   V_COBERT_ANT    := '';
   V_REGISTROS     := 0;
   
   IF P_IDPROCESO = 2 THEN
   BEGIN
      DELETE FROM RESERVA R
      WHERE  R.ID_SINIESTRO = P_ID_SINIESTRO;      
   END;
   END IF;
   
    FOR I IN INICIAL LOOP
       V_AÑO              := I.ANIO;
       V_MES              := I.MES;
       V_SINIESTRO        := I.SINI;
       V_EXISTE_SINIESTRO := 0;
       V_NUMSINIREF       := '';
       V_FEC_NOTIFICACION := '';
       V_FEC_OCURRENCIA   := '';
       V_IDPOLIZA         := '';
       V_FECINIVIG        := '';
       V_FECFINVIG        := '';
       V_NUMPOLUNICO      := '';
       V_COD_ASEGURADO    := '';
       V_CODCLIENTE       := '';
       V_IDTIPOSEG        := '';
       V_REGISTROS        := V_REGISTROS + 1;  
       V_CONTCOBS         := V_CONTCOBS + 1;
       V_COBERT_ACT       := I.ID_COBERTURA;
        
       REC_RESERVA.CODCIA         := P_CODCIA;
       REC_RESERVA.ID_SINIESTRO   := I.SINI;     
       REC_RESERVA.ID_PROCESO     := P_IDPROCESO;
       REC_RESERVA.ID_ORIGEN      := P_ORIGEN;
       REC_RESERVA.ID_VALIDACION  := FUNIDVALIDA;
             
       V_ANIOMES_ACT      := TO_NUMBER(I.ANIO||LPAD(I.MES,2,0));  
       V_ANIOMES_PROC     := TO_NUMBER(TO_CHAR(P_FECHA_INICIAL,'YYYYMM'));                                        
         
      IF V_CONTCOBS = 1 THEN
         V_COBERT_ANT   := V_COBERT_ACT;
      END IF;    
      
      -- SE OBTIENE EL ANIOMES MAS ACTUAL
      BEGIN
         SELECT MAX(TO_CHAR(DT.FE_MOVTO,'YYYYMM')) ANIOMES
           INTO V_ULTANIOMES
           FROM RESERVA_DET DT
          WHERE DT.ID_SINIESTRO = V_SINIESTRO
            AND DT.ID_COBERTURA = V_COBERT_ACT
         GROUP BY  DT.ID_COBERTURA;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              V_ULTANIOMES := NULL;                           
      END;  
      
       --INFORMACIÓN DEL SINIESTRO
      BEGIN
         VG_MENSAJE := 'INFORMACIÓN DEL SINIESTRO';
         SELECT S.NUMSINIREF,               S.FEC_NOTIFICACION,
                S.FEC_OCURRENCIA,           P.IDPOLIZA,
                P.FECINIVIG,                P.FECFINVIG,
                P.NUMPOLUNICO,              S.COD_ASEGURADO,
                P.CODCLIENTE,               DP.IDTIPOSEG,
                S.CODCIA,                   S.COD_MONEDA,
                TS.CODTIPOPLAN,             DECODE(SUBSTR(PC.CODTIPOPLAN,-1,1),1,'IND','COL')
           INTO REC_RESERVA.NUMSINIREF,     REC_RESERVA.FE_NOTIFICACION,
                REC_RESERVA.FE_OCURRIDO,    REC_RESERVA.ID_POLIZA,
                REC_RESERVA.FE_INIVIG,      REC_RESERVA.FE_FINVIG,
                REC_RESERVA.NUMPOLUNICO,    REC_RESERVA.COD_ASEGURADO,
                REC_RESERVA.COD_CLIENTE,    REC_RESERVA.TIPO_SEGURO,
                REC_RESERVA.CODCIA,         REC_RESERVA.ID_MONEDA,
                REC_RESERVA.ID_RAMO,        REC_RESERVA.ID_IND_O_COL    
           FROM SINIESTRO        S,
                POLIZAS          P,
                DETALLE_POLIZA   DP,
                TIPOS_DE_SEGUROS TS,
                PLAN_COBERTURAS  PC
          WHERE S.IDSINIESTRO = I.SINI
            --
            AND P.IDPOLIZA = S.IDPOLIZA
            --
            AND DP.IDPOLIZA = P.IDPOLIZA
            AND DP.IDETPOL  = (SELECT MIN(DP2.IDETPOL)
                                 FROM DETALLE_POLIZA DP2
                                WHERE DP2.IDPOLIZA = DP.IDPOLIZA)
            --
            AND TS.IDTIPOSEG = DP.IDTIPOSEG
            --
            AND PC.IDTIPOSEG = DP.IDTIPOSEG
            AND PC.PLANCOB   = DP.PLANCOB;
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20230,'Error en : '||VG_MENSAJE);
      END; 
      
      SELECT COUNT(*)
        INTO V_EXISTE_SINIESTRO
        FROM RESERVA R
       WHERE R.AÑO_MOVIMIENTO = V_AÑO
         AND R.MES_MOVIMIENTO = V_MES
         AND R.ID_SINIESTRO   = V_SINIESTRO
         AND R.ID_COBERTURA   = V_COBERT_ACT;
      
      FOR J IN COB_RES LOOP
         V_MOVTO := V_MOVTO + 1;
         REC_RESERVA.ID_COBERTURA  := J.ID_COBERTURA;
                                                       
         IF V_MOVTO = 1 THEN
            V_RESERVA_ANT := 0;
            V_ANIOMES_ANT   := V_ANIOMES_ACT;
            V_SINIESTRO_ANT := V_SINIESTRO;
         ELSE                
            V_RESERVA_ANT := V_RESERVA_FINAL;                
         END IF;
                                
          IF V_SINIESTRO_ANT != V_SINIESTRO OR V_COBERT_ACT != V_COBERT_ANT THEN
             V_RESERVA_ANT   := 0; 
             V_RESERVA_FINAL := 0;
             V_ANIOMES_ANT   := 0;
             V_COBERT_ANT    := V_COBERT_ACT;
          END IF; 
           
          IF V_COBERT_ACT = V_COBERT_ANT THEN
             V_RESERVA_ANT := V_RESERVA_FINAL;                
          END IF;
            
          REC_RESERVA.RESERVA_ANTERIOR  := V_RESERVA_ANT;                                                                                                        
            
          REC_RESERVA.RESERVA_FINAL      := 0;                                      
          REC_RESERVA.AÑO_MOVIMIENTO     := I.ANIO;
          REC_RESERVA.MES_MOVIMIENTO     := I.MES;
          REC_RESERVA.ESTIMACION_INICIAL := NVL(J.ESTINI,0); 
          REC_RESERVA.AJUSTES_MAS        := NVL(J.AJUMAS,0); 
          REC_RESERVA.AJUSTES_MENOS      := NVL(J.AJUMEN,0); 
          REC_RESERVA.PAGOS              := NVL(J.PAGOS,0); 
          REC_RESERVA.DESPAGOS           := NVL(J.DESPAG,0); 
          
          REC_RESERVA.RESERVA_ANTERIOR   := V_RESERVA_ANT;  
          
          IF V_EXISTE_SINIESTRO = 0 THEN             
             V_CUENTA_NUEVOS := V_CUENTA_NUEVOS + 1; 
                            
             INSERT INTO RESERVA VALUES REC_RESERVA;
                 --                                                 
             UPDATE RESERVA R
                SET R.RESERVA_FINAL  = NVL(R.RESERVA_ANTERIOR,0) + NVL(J.ESTINI,0) + NVL(J.AJUMAS,0) - NVL(J.AJUMEN,0) - NVL(J.PAGOS,0) + NVL(J.DESPAG,0)
              WHERE R.CODCIA         = 1
                AND R.ID_SINIESTRO   = V_SINIESTRO
                AND R.AÑO_MOVIMIENTO = V_AÑO
                AND R.MES_MOVIMIENTO = V_MES
                AND R.ID_COBERTURA   = J.ID_COBERTURA;                                
             
             --- ARRASTRA RESERVA PENDIENTE ENTRE PERIODOS.
             IF V_ANIOMES_ANT <> 0 THEN
                RESERVA_PENDIENTE(REC_RESERVA,V_RESERVA_ANT,V_RESERVA_FINAL,V_ANIOMES_ACT,V_ANIOMES_ANT,P_IDPROCESO,1,0,VG_ID_ERROR, VG_MENSAJE);
             END IF;
             V_RESERVA_FINAL := V_RESERVA_ANT + NVL(J.ESTINI,0) + NVL(J.AJUMAS,0) - NVL(J.AJUMEN,0) - NVL(J.PAGOS,0) + NVL(J.DESPAG,0);
             
             -- ARRASTRA RESERVA PENDIENTE A LA FECHA DE PROCESO
             IF V_ULTANIOMES = V_ANIOMES_ACT THEN
                RESERVA_PENDIENTE(REC_RESERVA,V_RESERVA_FINAL,V_RESERVA_FINAL,V_ANIOMES_PROC,V_ANIOMES_ACT,P_IDPROCESO,2,0,VG_ID_ERROR, VG_MENSAJE);
             END IF;   
          ELSE
             V_RESERVA_FINAL := V_RESERVA_ANT + NVL(J.ESTINI,0) + NVL(J.AJUMAS,0) - NVL(J.AJUMEN,0) - NVL(J.PAGOS,0) + NVL(J.DESPAG,0);
             
             UPDATE RESERVA R
             SET    RESERVA_ANTERIOR   = V_RESERVA_ANT,
                    ESTIMACION_INICIAL = NVL(J.ESTINI,0),
                    AJUSTES_MAS        = NVL(J.AJUMAS,0),
                    AJUSTES_MENOS      = NVL(J.AJUMEN,0),
                    PAGOS              = NVL(J.PAGOS,0),
                    DESPAGOS           = NVL(J.DESPAG,0),
                    RESERVA_FINAL      = V_RESERVA_FINAL
             WHERE  AÑO_MOVIMIENTO     = V_AÑO
             AND    MES_MOVIMIENTO     = V_MES
             AND    ID_SINIESTRO       = V_SINIESTRO
             AND    ID_COBERTURA       = J.ID_COBERTURA;
             
              --- ARRASTRA RESERVA PENDIENTE ENTRE PERIODOS.       
             IF V_ANIOMES_ANT <> 0 THEN      
                RESERVA_PENDIENTE(REC_RESERVA,V_RESERVA_ANT,V_RESERVA_FINAL,V_ANIOMES_ACT,V_ANIOMES_ANT,P_IDPROCESO,1,1,VG_ID_ERROR, VG_MENSAJE);
             END IF;                          
             -- ARRASTRA RESERVA PENDIENTE A LA FECHA DE PROCESO
             IF V_ULTANIOMES = V_ANIOMES_ACT THEN
                RESERVA_PENDIENTE(REC_RESERVA,V_RESERVA_FINAL,V_RESERVA_FINAL,V_ANIOMES_PROC,V_ANIOMES_ACT,P_IDPROCESO,2,1,VG_ID_ERROR, VG_MENSAJE);
             END IF;    
          END IF;      
      END LOOP;           
      V_SINIESTRO_ANT := V_SINIESTRO;
      V_COBERT_ANT    := V_COBERT_ACT;
      V_ANIOMES_ANT   := V_ANIOMES_ACT;   
      
      IF SUBSTR(V_REGISTROS,-3,3) = '000' THEN
         COMMIT;
      END IF;           
      --   
END LOOP;
--
COMMIT;
   DBMS_OUTPUT.PUT_LINE('FIN -> '||TO_CHAR(SYSDATE,'YYYY/MM/DD HH24:MI:SS')); 
EXCEPTION
   WHEN OTHERS THEN
      P_MENSAJE := VGNOMPACKAGE||'/'||SQLERRM||'/'||P_MENSAJE;
      RAISE_APPLICATION_ERROR(-20230,'Error en : '||P_MENSAJE);
END CARGA_RESUMEN_MOVTOS;

PROCEDURE CTROL_CGA_RVA (
  PIDCARGA        IN NUMBER,
  PIDVERSION      IN NUMBER,
  PPERIODICIDAD   IN NUMBER,
  PFECINICIAL     IN DATE,
  PFECFINAL       IN DATE,
  PID_SINIESTRO   IN NUMBER,
  PIMPTE_RVA_INI  IN NUMBER,
  PTOT_REGS_RI    IN NUMBER,
  PIMPTE_AJUMAS   IN NUMBER,
  PTOT_REGS_AA    IN NUMBER,
  PIMPTE_AJUMENOS IN NUMBER,
  PTOT_REG_AD     IN NUMBER, 
  PIMPTE_PAGOS    IN NUMBER,
  PTOT_REGS_PA    IN NUMBER,
  PIMPTE_DESPAGOS IN NUMBER,
  PTOT_REGS_DESP  IN NUMBER,
  PTI_PROCESO     IN VARCHAR2,
  PTF_PROCESO     IN VARCHAR2,
  PCODUSUARIO     IN VARCHAR2,
  P_ID_ERROR OUT NUMBER  ,
  P_MENSAJE  OUT VARCHAR2) IS
  
  NHAYCGA          NUMBER;
  
  REC_CTROL_RVA   CTROL_CGA_RESERVA%ROWTYPE;
  CTI_PROCESO     CTROL_CGA_RESERVA.TI_PROCESO%TYPE;
  CTF_PROCESO     CTROL_CGA_RESERVA.TF_PROCESO%TYPE;

BEGIN
   P_ID_ERROR  := 0;
   CTI_PROCESO := PTI_PROCESO;
   CTF_PROCESO := PTF_PROCESO;
   BEGIN
      SELECT COUNT(*)
      INTO   NHAYCGA
      FROM   CTROL_CGA_RESERVA
      WHERE  IDCARGA       = PIDCARGA
      AND    IDVERSION     = PIDVERSION
      AND    PERIODICIDAD  = PPERIODICIDAD
      AND    FECINICIAL    = PFECINICIAL
      AND    FECFINAL      = PFECFINAL;
      
   EXCEPTION
      WHEN OTHERS THEN
         NHAYCGA := 0;         
   END; 
   
    
    REC_CTROL_RVA.IDCARGA        := PIDCARGA;
    REC_CTROL_RVA.IDVERSION      := 1;
    REC_CTROL_RVA.PERIODICIDAD   := PPERIODICIDAD;   
    REC_CTROL_RVA.FECINICIAL     := PFECINICIAL;   
    REC_CTROL_RVA.FECFINAL       := PFECFINAL;    
    REC_CTROL_RVA.ID_SINIESTRO   := PID_SINIESTRO;
    REC_CTROL_RVA.IMPTE_RVA_INI  := CASE WHEN PIMPTE_RVA_INI  = 0 THEN 0 ELSE PIMPTE_RVA_INI  END;
    REC_CTROL_RVA.TOT_REGS_RI    := CASE WHEN PTOT_REGS_RI    = 0 THEN 0 ELSE PTOT_REGS_RI    END;
    REC_CTROL_RVA.IMPTE_AJUMAS   := CASE WHEN PIMPTE_AJUMAS   = 0 THEN 0 ELSE PIMPTE_AJUMAS   END;
    REC_CTROL_RVA.TOT_REGS_AA    := CASE WHEN PTOT_REGS_AA    = 0 THEN 0 ELSE PTOT_REGS_AA    END;
    REC_CTROL_RVA.IMPTE_AJUMENOS := CASE WHEN PIMPTE_AJUMENOS = 0 THEN 0 ELSE PIMPTE_AJUMENOS END;
    REC_CTROL_RVA.TOT_REG_AD     := CASE WHEN PTOT_REG_AD     = 0 THEN 0 ELSE PTOT_REG_AD     END;
    REC_CTROL_RVA.IMPTE_PAGOS    := CASE WHEN PIMPTE_PAGOS    = 0 THEN 0 ELSE PIMPTE_PAGOS    END;
    REC_CTROL_RVA.TOT_REGS_PA    := CASE WHEN PTOT_REGS_PA    = 0 THEN 0 ELSE PTOT_REGS_PA    END;
    REC_CTROL_RVA.IMPTE_DESPAGOS := CASE WHEN PIMPTE_DESPAGOS = 0 THEN 0 ELSE PIMPTE_DESPAGOS END;
    REC_CTROL_RVA.TOT_REGS_DESP  := CASE WHEN PTOT_REGS_DESP  = 0 THEN 0 ELSE PTOT_REGS_DESP  END;
    IF CTI_PROCESO IS NULL THEN
       REC_CTROL_RVA.TI_PROCESO     := TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS');
    ELSE REC_CTROL_RVA.TI_PROCESO   := CTI_PROCESO;  END IF;
    IF CTF_PROCESO IS NULL THEN
       REC_CTROL_RVA.TF_PROCESO     := TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS');
    ELSE REC_CTROL_RVA.TF_PROCESO   := CTF_PROCESO;  END IF;
      
    REC_CTROL_RVA.CODUSUARIO     := PCODUSUARIO;
   
   IF NHAYCGA = 0 THEN      
      INSERT INTO CTROL_CGA_RESERVA VALUES REC_CTROL_RVA;                                             
   ELSE
        UPDATE CTROL_CGA_RESERVA
        SET    IMPTE_RVA_INI  = REC_CTROL_RVA.IMPTE_RVA_INI,
               TOT_REGS_RI    = REC_CTROL_RVA.TOT_REGS_RI,
               IMPTE_AJUMAS   = REC_CTROL_RVA.IMPTE_AJUMAS,
               TOT_REGS_AA    = REC_CTROL_RVA.TOT_REGS_AA,
               IMPTE_AJUMENOS = REC_CTROL_RVA.IMPTE_AJUMENOS,
               TOT_REG_AD     = REC_CTROL_RVA.TOT_REG_AD, 
               IMPTE_PAGOS    = REC_CTROL_RVA.IMPTE_PAGOS,
               TOT_REGS_PA    = REC_CTROL_RVA.TOT_REGS_PA,
               IMPTE_DESPAGOS = REC_CTROL_RVA.IMPTE_DESPAGOS,
               TOT_REGS_DESP  = REC_CTROL_RVA.TOT_REGS_DESP,
               TF_PROCESO     = REC_CTROL_RVA.TF_PROCESO
        WHERE  IDCARGA       = PIDCARGA
        AND    IDVERSION     = PIDVERSION
        AND    PERIODICIDAD  = PPERIODICIDAD
        AND    FECINICIAL    = PFECINICIAL
        AND    FECFINAL      = PFECFINAL; 
               
   END IF;  
  -- COMMIT;
EXCEPTION                                     
   WHEN OTHERS THEN
      P_ID_ERROR  := SQLCODE;
      P_MENSAJE   := SQLERRM;
END;                                 
END TH_CARGA_OPC;
/
