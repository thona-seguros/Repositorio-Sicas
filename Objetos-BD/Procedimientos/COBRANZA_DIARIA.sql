PROCEDURE COBRANZA_DIARIA AS
nCodCia        DOMICILIACION.CodCia%TYPE;
nCodEmpresa    EMPRESAS_DE_SEGUROS.CodEmpresa%TYPE;
nIdProceso     DOMICILIACION.IdProceso%TYPE;
cNomArchEnvio  CONFIGURACION_DOMICILIACION.NomArchEnvio%TYPE;
dFecArc        VARCHAR2(8);
dFecDomi       VARCHAR2(8);
cObservacion   DOMICILIACION.Observacion%TYPE;
dFecProceso    DOMICILIACION.FecProceso%TYPE := TRUNC(SYSDATE);--TO_DATE('02/01/2019','DD/MM/YYYY');
cDirectorio    VARCHAR2(20);
cNomArchivoRep VARCHAR2(50);
CURSOR CONFDOM_Q IS
   SELECT CodEntidad, Correlativo, Descripcion, Periodicidad, NomArchEnvio, 
          NomArchRespuesta, IndIngMan, IndIntentos, NroReintentos, Ubicacion_Archivo, 
          DiasReintentos, NomComercio, NumAfiliacion, MaxDiasExcepcion, CodPlantilla, 
          Tipo_Configuracion
     FROM CONFIGURACION_DOMICILIACION
    WHERE CodCia  = nCodCia
      AND Tipo_Configuracion IN ('D','T');
      
CURSOR REPCOB_Q IS
   SELECT DISTINCT CodEntidad
     FROM CONFIGURACION_DOMICILIACION
    WHERE CodCia  = nCodCia
      AND Tipo_Configuracion IN ('D','T');      
BEGIN
   IF TRIM(to_char(dFecProceso,'DAY', 'NLS_DATE_LANGUAGE=SPANISH')) NOT IN ('SÁBADO','DOMINGO') THEN
      nCodCia        := OC_GENERALES.CODCIA_USUARIO(USER);
      BEGIN
         SELECT CodEmpresa
           INTO nCodEmpresa
           FROM EMPRESAS_DE_SEGUROS
          WHERE CodCia  = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20000,'NO es Posible Determinar la Empresa '||SQLERRM);
      END; 
      cObservacion   := 'Lote Generado de Manera Automatica para el dia '||TO_CHAR(dFecProceso,'DD/MM/YYYY');
      SELECT TO_CHAR(SYSDATE,'YYMMDD'), TO_CHAR(SYSDATE,'DDMMYYYY')
        INTO dFecArc, dFecDomi
        FROM DUAL;
      FOR W IN CONFDOM_Q LOOP
         cNomArchEnvio := OC_CONFIGURACION_DOMICILIACION.ARCHIVO_ENVIO(nCodCia, W.CodEntidad, W.Tipo_Configuracion);
         IF W.Tipo_Configuracion = 'D' THEN
            cDirectorio := 'WEBTRANS';
            nIdProceso := OC_DOMICILIACION.SIG_IDEPROCESO(nCodCia);
            cNomArchEnvio := cNomArchEnvio||dFecArc||'.'||LPAD(W.Correlativo,3,'0');
         ELSIF W.Tipo_Configuracion = 'T' THEN
            cDirectorio := 'DOMICI';
            nIdProceso := OC_DOMICILIACION.SIG_IDEPROCESO(nCodCia);
            cNomArchEnvio := cNomArchEnvio||dFecDomi||'.TXT';
         END IF;
         OC_DOMICILIACION.INSERTAR(nCodCia, nIdProceso, USER, SYSDATE, NULL, 
                                      NULL, cObservacion, W.CodEntidad, dFecProceso, NULL, 
                                      NULL, 'SOL', LPAD(W.Correlativo,3,'0'), W.Tipo_Configuracion, NULL, 
                                      NULL, 0);

         OC_LOG_TRANSAC_DOM.INSERTA(nCodCia, W.CodEntidad, nIdProceso, 'GEF', 'Proceso de Generacion de Archivo Archivo: '||cNomArchEnvio); 
         UPDATE DOMICILIACION
            SET Estado = 'ARG'
          WHERE CodCia             = nCodCia
            AND IdProceso          = nIdProceso
            AND Tipo_Configuracion = W.Tipo_Configuracion;
         
         ---- EJECUTA PROCESO PARA GENERAR INFORMACION 
         OC_DOMICILIACION.PROVISION_FACTURAS_VENC(nCodCia, dFecProceso, W.CodEntidad, nIdProceso);
         
         ---- GENERA ARCHIVO
         IF W.Tipo_Configuracion = 'D' THEN
            OC_DOMICILIACION.GENERA_ARCHIVO_TEXTO(nCodCia, nCodEmpresa, cNomArchEnvio, nIdProceso);
         ELSIF W.Tipo_Configuracion = 'T' THEN
            OC_DOMICILIACION.GENERA_ARCHIVO_DOMICILIACION(nCodCia, nCodEmpresa, cNomArchEnvio, nIdProceso);
         END IF;
         
         UPDATE DOMICILIACION
            SET UsuarioGen = USER,
                FechaGen   = SYSDATE,
                Estado     = 'GEN'
          WHERE CodCia    = nCodCia
            AND IdProceso = nIdProceso;
         
         ---- SE ENVIA ARCHIVO POR MAIL
         OC_DOMICILIACION.ENVIA_ARCHIVO(nCodCia, nIdProceso, dFecProceso, cNomArchEnvio, cDirectorio);
         
         ---- ACTUALIZA LOTE A ENVIADO
         UPDATE DOMICILIACION
            SET HoraEnvio       = SYSDATE,
                CodUsuarioEnvio = USER,
                Estado          = 'ENV'
          WHERE CodCia    = nCodCia
            AND IdProceso = nIdProceso;
      END LOOP;
      cNomArchivoRep := 'COBRANZA_DIARIA_'||TO_CHAR(dFecProceso,'DDMMYYYY')||'.XLS';
      cDirectorio    := 'REPODIARIO';
      
      FOR W IN REPCOB_Q LOOP
         OC_DOMICILIACION.REPORTE_COBRANZA_DIARIA(nCodCia, dFecProceso, W.CodEntidad, cNomArchivoRep);
         OC_DOMICILIACION.ENVIA_ARCHIVO(nCodCia, 0, dFecProceso, cNomArchivoRep, cDirectorio);
      END LOOP;
   END IF;
END;
