CREATE OR REPLACE PACKAGE SICAS_OC.OC_ADMON_RIESGO_SINIESTROS IS
--
-- BITACORA DE CAMBIOS7
--
-- CAMBIO SE QUITA LA VALIDACION DE -SI ES AGENTE-         JMMD  20200709
-- CAMBIO REGISTROS CNSF                                   ICO   20221228
-- CAMBIO PLD ALERTAS SE COLOCA FUNCION DE ENVIO DE CORREO ICO   07/03/2023 ALERTA
--
PROCEDURE VALIDA(P_CODCIA                  NUMBER,
                 P_CODEMPRESA              NUMBER,
                 P_ID_PROCESO              NUMBER,
                 P_IDPOLIZA                NUMBER,
                 P_COD_ASEGURADO           NUMBER,
                 P_IDSINIESTRO             NUMBER,
                 P_NUM_BENEF               NUMBER,
                 P_NOMBRE_COMPLETO         VARCHAR2,
                 P_ST_RESOLUCION           VARCHAR2,              
                 P_TIPO_DOC_IDENTIFICACION VARCHAR2,
                 P_NUM_DOC_IDENTIFICACION  VARCHAR2,
                 P_OBSERVACIONES           VARCHAR2, 
                 P_USUARIO                 VARCHAR2,                
                 P_MENSAJE                 IN OUT VARCHAR2);
--
PROCEDURE INSERTA(P_CODCIA                   NUMBER,
                  P_CODEMPRESA               NUMBER,
                  P_ID_PROCESO               NUMBER,
                  P_IDPOLIZA                 NUMBER,
                  P_STSPOLIZA                VARCHAR2,
                  P_CODCLIENTE               NUMBER,
                  P_NUMSINIESTRO             NUMBER,
                  P_ORIGEN                   VARCHAR2,
                  P_TIPO_DOC_IDENTIFICACION  VARCHAR2,
                  P_NUM_DOC_IDENTIFICACION   VARCHAR2,
                  P_NOMBRE_BENEFICIARIO      VARCHAR2,
                  P_ST_RESOLUCION            VARCHAR2,
                  P_FE_ESTATUS               DATE,
                  P_TP_RESOLUCION            VARCHAR2,
                  P_OBSERVACIONES            VARCHAR2,
                  P_FECHA_PROCESO            DATE,
                  P_USUARIO                  VARCHAR2,
                  P_NUM_BENEF                NUMBER);

END OC_ADMON_RIESGO_SINIESTROS;
/
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_ADMON_RIESGO_SINIESTROS IS
--
PROCEDURE VALIDA(P_CODCIA                  NUMBER,
                 P_CODEMPRESA              NUMBER,
                 P_ID_PROCESO              NUMBER,
                 P_IDPOLIZA                NUMBER,
                 P_COD_ASEGURADO           NUMBER,
                 P_IDSINIESTRO             NUMBER,
                 P_NUM_BENEF               NUMBER,
                 P_NOMBRE_COMPLETO         VARCHAR2,
                 P_ST_RESOLUCION           VARCHAR2,              
                 P_TIPO_DOC_IDENTIFICACION VARCHAR2,
                 P_NUM_DOC_IDENTIFICACION  VARCHAR2,
                 P_OBSERVACIONES           VARCHAR2, 
                 P_USUARIO                 VARCHAR2,                               
                 P_MENSAJE                 IN OUT VARCHAR2) IS  
--                 
P_TP_RESOLUCION   ADMON_RIESGO.TP_RESOLUCION%TYPE := '';
W_MENSAJE         VARCHAR2(300);
CCODACTIVIDAD     PERSONA_NATURAL_JURIDICA.CODACTIVIDAD%TYPE;
P_IDTIPOSEG       TIPOS_DE_SEGUROS.IDTIPOSEG%TYPE;
CCODPAIS          PAIS.CODPAIS%TYPE;
CNOMPAIS          PAIS.DESCPAIS%TYPE;
CCODESTADO        DISTRITO.CODESTADO%TYPE;
CCODCIUDAD        DISTRITO.CODCIUDAD%TYPE;
CNOMCIUDAD        DISTRITO.DESCCIUDAD%TYPE;
--
BEGIN
  --
  W_MENSAJE := '';
  --
  BEGIN
    SELECT D.IDTIPOSEG
      INTO P_IDTIPOSEG
      FROM DETALLE_POLIZA D
     WHERE D.IDPOLIZA = P_IDPOLIZA
       AND D.CODCIA   = P_CODCIA
       AND D.IDETPOL  = 1;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         NULL;
    WHEN OTHERS THEN
         NULL;
  END;
  --
  BEGIN
    SELECT PNJ.CODPAISRES,
           OC_PAIS.NOMBRE_PAIS(PNJ.CODPAISRES) NOM_PAIS,
           PNJ.CODPROVRES,
           PNJ.CODDISTRES,
           OC_DISTRITO.NOMBRE_DISTRITO(PNJ.CODPAISRES,PNJ.CODPROVRES,PNJ.CODDISTRES) NOM_CIUDAD
      INTO CCODPAIS, 
           CNOMPAIS,
           CCODESTADO,
           CCODCIUDAD,
           CNOMCIUDAD 
      FROM PERSONA_NATURAL_JURIDICA PNJ,
           PAIS P
     WHERE PNJ.TIPO_DOC_IDENTIFICACION = P_TIPO_DOC_IDENTIFICACION
       AND PNJ.NUM_DOC_IDENTIFICACION  = P_NUM_DOC_IDENTIFICACION;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         NULL;
    WHEN OTHERS THEN
         NULL;
  END;
  --
  -- VALIDA SI ES EMPLEADO
  --
  IF OC_EMPLEADOS_FUNCIONARIOS.ES_EMPLEADO_FUNCIONARIO(P_CODCIA , P_TIPO_DOC_IDENTIFICACION, P_NUM_DOC_IDENTIFICACION) = 'S' THEN             
     OC_ADMON_RIESGO_SINIESTROS.INSERTA(P_CODCIA,
			      P_CODEMPRESA ,
			      1 ,
			      P_IDPOLIZA  ,
			      'N/A' ,
			      P_COD_ASEGURADO ,      
			      P_IDSINIESTRO ,
			      'EMPLEA'  ,
			      P_TIPO_DOC_IDENTIFICACION	,
			      P_NUM_DOC_IDENTIFICACION	,
			      P_NOMBRE_COMPLETO	,
			      'PEND'	,
			      TRUNC(SYSDATE)	,
			      ''	,
			      'EMPLEADOS'	,
			      TRUNC(SYSDATE)  ,
			      P_USUARIO,
            P_NUM_BENEF );     	     
                   
     W_MENSAJE := '!! ALERTA !!   LA PERSONA ES EMPLEADO  - ENVIADO A AUTORIZACION ';
  END IF;
  --
  -- VALIDA SI ESTA EN LISTA DE REFERENCIA
  --
  IF OC_PERSONA_NATURAL_JURIDICA.EN_LISTA_DE_REFERENCIA(P_TIPO_DOC_IDENTIFICACION, P_NUM_DOC_IDENTIFICACION) = 'S' THEN
     OC_ADMON_RIESGO_SINIESTROS.INSERTA(P_CODCIA,
			      P_CODEMPRESA ,
			      1 ,
			      P_IDPOLIZA  ,
			      'N/A' ,
			      P_COD_ASEGURADO ,      
			      P_IDSINIESTRO ,
			      'LISTA'  ,
			      P_TIPO_DOC_IDENTIFICACION	,
			      P_NUM_DOC_IDENTIFICACION	,
			      P_NOMBRE_COMPLETO	,
			      'PEND'	,
			      TRUNC(SYSDATE)	,
			      ''	,
			      'LISTA DE REFEERENCIA'	,
			      TRUNC(SYSDATE)  ,
			      P_USUARIO ,
            P_NUM_BENEF );      

     W_MENSAJE := '!! ALERTA !!   LA PERSONA ESTA EN LISTA DE REFERENCIA  - ENVIADO A AUTORIZACION ';
   END IF;
  --
  -- VALIDA SI ES AGENTE
  --
/*  IF OC_AGENTES.ES_AGENTE(P_TIPO_DOC_IDENTIFICACION, P_NUM_DOC_IDENTIFICACION) = 'S' THEN
     OC_ADMON_RIESGO_SINIESTROS.INSERTA(P_CODCIA,
			      P_CODEMPRESA ,
			      1 ,
			      P_IDPOLIZA  ,
			      'N/A' ,
			      P_COD_ASEGURADO ,      
			      P_IDSINIESTRO ,
			      'AGENTE'  ,
			      P_TIPO_DOC_IDENTIFICACION	,
			      P_NUM_DOC_IDENTIFICACION	,
			      P_NOMBRE_COMPLETO	,
			      'PEND'	,
			      TRUNC(SYSDATE)	,
			      ''	,
			      'LA PERSONA ES AGENTE'	,
			      TRUNC(SYSDATE)  ,
			      P_USUARIO ,
            P_NUM_BENEF );        

     W_MENSAJE := '!! ALERTA !!  LA PERSONA ES AGENTE - ENVIADO A AUTORIZACION  - ENVIADO A AUTORIZACION ';
  END IF;*/
  --
  -- VALIDA SI ES CLIENTE DE ALTO RIESGO
  --
  IF OC_CLIENTES.ES_CLIENTE_ALTO(P_TIPO_DOC_IDENTIFICACION, P_NUM_DOC_IDENTIFICACION) = 'S' THEN
     OC_ADMON_RIESGO_SINIESTROS.INSERTA(P_CODCIA,
			      P_CODEMPRESA ,
			      1 ,
			      P_IDPOLIZA  ,
			      'N/A' ,
			      P_COD_ASEGURADO ,      
			      P_IDSINIESTRO ,
			      'CLIENT'  ,
			      P_TIPO_DOC_IDENTIFICACION	,
			      P_NUM_DOC_IDENTIFICACION	,
			      P_NOMBRE_COMPLETO	,
			      'PEND'	,
			      TRUNC(SYSDATE)	,
			      ''	,
			      'LA PERSONA ES CLIENTE DE RIESGO'	,
			      TRUNC(SYSDATE)  ,
			      P_USUARIO,
            P_NUM_BENEF );        

     W_MENSAJE := '!! ALERTA !!  LA PERSONA ES CLIENTE DE RIESGO  - ENVIADO A AUTORIZACION ';
  END IF;
  --
  -- VALIDA SI LA ACTIVIDAD ES DE ALTO RIESGO
  -- 
  CCODACTIVIDAD := OC_PERSONA_NATURAL_JURIDICA.ACTIVIDAD(P_TIPO_DOC_IDENTIFICACION, P_NUM_DOC_IDENTIFICACION);
  --
  IF OC_ACTIVIDADES_ECONOMICAS.TIPORIESGO(cCodActividad) = 'ALTO' THEN
     OC_ADMON_RIESGO_SINIESTROS.INSERTA(P_CODCIA,
			      P_CODEMPRESA ,
			      1 ,
			      P_IDPOLIZA  ,
			      'N/A' ,
			      P_COD_ASEGURADO ,      
			      P_IDSINIESTRO ,
			      'ACTIVI'  ,
			      P_TIPO_DOC_IDENTIFICACION	,
			      P_NUM_DOC_IDENTIFICACION	,
			      P_NOMBRE_COMPLETO	,
			      'PEND'	,
			      TRUNC(SYSDATE)	,
			      ''	,
			      'LA PERSONA ES CLIENTE CON ACTIVIDAD DE RIESGO'	,
			      TRUNC(SYSDATE)  ,
			      P_USUARIO ,
            P_NUM_BENEF );    

     W_MENSAJE := '!! ALERTA !!   LA PERSONA ES CLIENTE CON ACTIVIDAD DE RIESGO  - ENVIADO A AUTORIZACION ';
  END IF;
  --
  -- VALIDA SI ES QUIEN ES QUIEN
  --
  IF OC_CAT_QEQ.ES_QEQ(P_TIPO_DOC_IDENTIFICACION,P_NUM_DOC_IDENTIFICACION) = 'S' THEN
     OC_ADMON_RIESGO_SINIESTROS.INSERTA(P_CODCIA,
			      P_CODEMPRESA ,
			      1 ,
			      P_IDPOLIZA  ,
			      'N/A' ,
			      P_COD_ASEGURADO ,      
			      P_IDSINIESTRO ,
			      'QEQ'  ,
			      P_TIPO_DOC_IDENTIFICACION	,
			      P_NUM_DOC_IDENTIFICACION	,
			      P_NOMBRE_COMPLETO	,
			      'PEND'	,
			      TRUNC(SYSDATE)	,
			      ''	,
			      'LA PERSONA ESTA EN QUIEN ES QUIEN '	,
			      TRUNC(SYSDATE)  ,
			      P_USUARIO,
            P_NUM_BENEF );    

     W_MENSAJE := '!! ALERTA !!   LA PERSONA ESTA EN QUIEN ES QUIEN  - ENVIADO A AUTORIZACION ';
   END IF;
  --
  -- VALIDA SI ES DE UNA LISTA DE LA CNSF
  --
  IF OC_PLD_LISTAS_CNSF.ES_LISTA_CNSF(P_TIPO_DOC_IDENTIFICACION,P_NUM_DOC_IDENTIFICACION) = 'S' THEN
     OC_ADMON_RIESGO_SINIESTROS.INSERTA(P_CODCIA,
			      P_CODEMPRESA ,
			      1 ,
			      P_IDPOLIZA  ,
			      'N/A' ,
			      P_COD_ASEGURADO ,      
			      P_IDSINIESTRO ,
			      'LCNSF'  ,
			      P_TIPO_DOC_IDENTIFICACION	,
			      P_NUM_DOC_IDENTIFICACION	,
			      P_NOMBRE_COMPLETO	,
			      'PEND'	,
			      TRUNC(SYSDATE)	,
			      ''	,
			      'LA PERSONA ESTA EN LISTA DE CNSF '	,
			      TRUNC(SYSDATE)  ,
			      P_USUARIO,
            P_NUM_BENEF );    
     W_MENSAJE := '!! ALERTA !!   LA PERSONA ESTA EN UNA LISTA NEGRA DE LA CNSF - ENVIADO A AUTORIZACION ';
  END IF;
  --   --
   -- VALIDA SI ES PAIS DE ALTO RIESGO  SOLO REGISTRA
   --
   IF OC_PAIS.ES_PAIS_ALTO_RIESGO(CCODPAIS) = 'S' THEN
              OC_ADMON_ACTIVI.INSERTA(P_CODCIA,       -- P_CODCIA          NUMBER,
                                1,                    -- P_ID_PROCESO      NUMBER,
                                P_IDSINIESTRO,        -- P_IDPOLIZA        NUMBER,
                                0,                    -- P_IDETPOL         NUMBER,
                                'PAIS',               -- P_TP_PERSONA      VARCHAR2,
                                'PAIS',               -- P_ORIGEN          VARCHAR2,
                                P_NUM_BENEF,          -- P_CODCLIENTE      NUMBER,
                                P_COD_ASEGURADO,      -- P_CODASEGURADO    NUMBER,
                                0,                    -- P_IDFACTURA       NUMBER,
                                '',                   -- P_IDTIPOSEG       VARCHAR,
                                '',                   -- P_COD_MONEDA      VARCHAR2,
                                '',                   -- P_FORMPAGO        VARCHAR2,
                                '',                   -- P_TIPO_PERSONA    VARCHAR2,
                                '',                   -- P_CODACTIVIDAD    VARCHAR2,
                                '',                   -- P_ASEGURADOS_EMI  NUMBER,
                                '',                   -- P_ASEGURADOS_END  NUMBER,
                                '',                   -- P_SUMAASEG_EMI    NUMBER,
                                '',                   -- P_SUMAASEG_END    NUMBER
                                'EL ASEGURADO O BENEFICIARIO ES DE UN PAIS DE ALTO RIESGO, '||CCODPAIS||' = '||CNOMPAIS,    -- P_OBSERVACIONES   VARCHAR2,
                                '',                   -- P_IDENDOSO        NUMBER,    
                                P_TIPO_DOC_IDENTIFICACION, -- P_TIPO_DOC_IDENTIFICACION VARCHAR2,    
                                P_NUM_DOC_IDENTIFICACION   -- P_NUM_DOC_IDENTIFICACION	VARCHAR2	     
                               );      
   END IF;
   --
   -- VALIDA SI ES CIUDAD DE ALTO RIESGO  SOLO REGISTRA
   --  
   IF OC_DISTRITO.ES_CIUDAD_ALTO_RIESGO(CCODPAIS, CCODESTADO, CCODCIUDAD) = 'S' THEN
              OC_ADMON_ACTIVI.INSERTA(P_CODCIA,       -- P_CODCIA          NUMBER,
                                1,                    -- P_ID_PROCESO      NUMBER,
                                P_IDSINIESTRO,        -- P_IDPOLIZA        NUMBER,
                                0,                    -- P_IDETPOL         NUMBER,
                                'CIUDAD',             -- P_TP_PERSONA      VARCHAR2,
                                'CIUDAD',             -- P_ORIGEN          VARCHAR2,
                                P_NUM_BENEF,          -- P_CODCLIENTE      NUMBER,
                                P_COD_ASEGURADO,      -- P_CODASEGURADO    NUMBER,
                                0,                    -- P_IDFACTURA       NUMBER,
                                '',                   -- P_IDTIPOSEG       VARCHAR,
                                '',                   -- P_COD_MONEDA      VARCHAR2,
                                '',                   -- P_FORMPAGO        VARCHAR2,
                                '',                   -- P_TIPO_PERSONA    VARCHAR2,
                                '',                   -- P_CODACTIVIDAD    VARCHAR2,
                                '',                   -- P_ASEGURADOS_EMI  NUMBER,
                                '',                   -- P_ASEGURADOS_END  NUMBER,
                                '',                   -- P_SUMAASEG_EMI    NUMBER,
                                '',                   -- P_SUMAASEG_END    NUMBER
                                'EL ASEGURADO O BENEFICIARIO ES DE UNA CIUDAD DE ALTO RIESGO, '||CCODCIUDAD||' = '||CNOMCIUDAD,    -- P_OBSERVACIONES   VARCHAR2,
                                '',                   -- P_IDENDOSO        NUMBER,    
                                P_TIPO_DOC_IDENTIFICACION, -- P_TIPO_DOC_IDENTIFICACION VARCHAR2,    
                                P_NUM_DOC_IDENTIFICACION   -- P_NUM_DOC_IDENTIFICACION	VARCHAR2	     
                               );      
   END IF;
   --
   P_MENSAJE := W_MENSAJE;
   --
END VALIDA;

PROCEDURE INSERTA(P_CODCIA                   NUMBER,
                  P_CODEMPRESA               NUMBER,
                  P_ID_PROCESO               NUMBER,
                  P_IDPOLIZA                 NUMBER,
                  P_STSPOLIZA                VARCHAR2,
                  P_CODCLIENTE               NUMBER,
                  P_NUMSINIESTRO             NUMBER,
                  P_ORIGEN                   VARCHAR2,
                  P_TIPO_DOC_IDENTIFICACION  VARCHAR2,
                  P_NUM_DOC_IDENTIFICACION   VARCHAR2,
                  P_NOMBRE_BENEFICIARIO      VARCHAR2,
                  P_ST_RESOLUCION            VARCHAR2,
                  P_FE_ESTATUS               DATE,
                  P_TP_RESOLUCION            VARCHAR2,
                  P_OBSERVACIONES            VARCHAR2,
                  P_FECHA_PROCESO            DATE,
                  P_USUARIO                  VARCHAR2,
                  P_NUM_BENEF                NUMBER) IS
--
W_ERRORENVIO VARCHAR2(2000);
vl_YaSeReportoAntes NUMBER := 0;

BEGIN
    BEGIN
  
      SELECT COUNT(1)
      INTO vl_YaSeReportoAntes
      FROM SICAS_OC.ADMON_RIESGO_SINIESTROS
      WHERE ID_PROCESO = P_ID_PROCESO
        AND IDPOLIZA = P_IDPOLIZA
        AND CODCLIENTE = P_CODCLIENTE
        AND NUMSINIESTRO = P_NUMSINIESTRO
        --AND ORIGEN = 'QEQ' --la validacion se implementará para evitar duplicados de cualquier origen, no solo QEQ
        AND TIPO_DOC_IDENTIFICACION = P_TIPO_DOC_IDENTIFICACION
        AND NUM_DOC_IDENTIFICACION = P_NUM_DOC_IDENTIFICACION
        AND NOMBRE_BENEFICIARIO = P_NOMBRE_BENEFICIARIO
        AND ST_RESOLUCION IN ('PEND','PENT','PENC'); --VALIDARÁ SOLO QUE EXISTA EL MISMO REGISTRO Y ESTE AÚN PENDIENTE
        
    EXCEPTION
        WHEN OTHERS THEN
            vl_YaSeReportoAntes := 0;
    END;
    
    IF vl_YaSeReportoAntes = 0 THEN

  --INSERTA ADMON_RIESGO_SINIESTROS
  --
  INSERT INTO SICAS_OC.ADMON_RIESGO_SINIESTROS
   (CODCIA,
    CODEMPRESA,
    ID_PROCESO,
    IDPOLIZA,
    STSPOLIZA,
    CODCLIENTE,
    NUMSINIESTRO,
    ORIGEN,
    TIPO_DOC_IDENTIFICACION,
    NUM_DOC_IDENTIFICACION,
    NOMBRE_BENEFICIARIO,
    ST_RESOLUCION,
    FE_ESTATUS,
    TP_RESOLUCION,
    OBSERVACIONES,
    FECHA_PROCESO ,
    USUARIO)
  VALUES
   (P_CODCIA,
    P_CODEMPRESA,
    P_ID_PROCESO,
    P_IDPOLIZA,
    P_STSPOLIZA,
    P_CODCLIENTE,
    P_NUMSINIESTRO,
    P_ORIGEN,
    P_TIPO_DOC_IDENTIFICACION,
    P_NUM_DOC_IDENTIFICACION,
    P_NOMBRE_BENEFICIARIO,
    P_ST_RESOLUCION,
    P_FE_ESTATUS,
    P_TP_RESOLUCION,
    P_OBSERVACIONES,
    P_FECHA_PROCESO,
    P_USUARIO );
  --
  COMMIT;
  --
  OC_ADMON_RIESGO_SINIESTROS_H.INSERTA(P_CODCIA  ,
      P_CODEMPRESA,
      P_ID_PROCESO,
      P_IDPOLIZA,
      P_STSPOLIZA,
      P_CODCLIENTE,
      P_NUMSINIESTRO,
      P_ORIGEN,
      P_TIPO_DOC_IDENTIFICACION,
      P_NUM_DOC_IDENTIFICACION,
      P_NOMBRE_BENEFICIARIO,
      P_ST_RESOLUCION,
      P_FE_ESTATUS,  
      P_TP_RESOLUCION,
      P_OBSERVACIONES,
      P_FECHA_PROCESO,
      P_USUARIO );
  --
  -- ALERTA
  --
  ENVIA_CORREO_REPORTE_PLD('SINIESTRO', --PORIGEN
                           P_NUMSINIESTRO,  
                           0,           --P_IDPOLIZA,
                           0,           --P_ASEGURADO,
                           P_ORIGEN,
                           P_NUM_BENEF,
                           W_ERRORENVIO);
  --
        COMMIT;
  --   
    END IF;
END INSERTA;
--

END OC_ADMON_RIESGO_SINIESTROS;
/

CREATE OR REPLACE PUBLIC SYNONYM OC_ADMON_RIESGO_SINIESTROS FOR SICAS_OC.OC_ADMON_RIESGO_SINIESTROS;
    
GRANT EXECUTE ON SICAS_OC.OC_ADMON_RIESGO_SINIESTROS TO PUBLIC;
/