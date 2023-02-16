CREATE OR REPLACE PACKAGE          OC_PROCESOS_MASIVOS IS
------ SE INCLUYEN VALIDACIONES PARA PROVEEDORES SAT Y QEQ (PLD)  JMMD  20200406
------  24/06/2020  Se incluyen nuevas validaciones para proveedores sat (Ya incluye cambios de CPérez)     -- JMMD SAT y PLD 20200624
PROCEDURE PROCESO_REGISTRO(nIdProcMasivo NUMBER, cTipoProceso VARCHAR2);
PROCEDURE ACTUALIZA_STATUS(nIdProcMasivo NUMBER, cStsRegProceso VARCHAR2);
PROCEDURE EMISION(nIdProcMasivo NUMBER);
PROCEDURE EMISION_WEB(nIdProcMasivo NUMBER);
FUNCTION SEPARA_DATOS_VALORCAMPO (cTipoProceso VARCHAR2, cPlanCob VARCHAR2, cIdTipoSeg VARCHAR2,
                                  cCodEmpresa VARCHAR2, cCodCia VARCHAR2, cCampo VARCHAR2, cDatosProc VARCHAR2) RETURN VARCHAR2;
FUNCTION CREAR(cCodCia NUMBER, cCodEmpresa NUMBER) RETURN NUMBER;
PROCEDURE INSERT_DINAMICO(cCodPlantilla VARCHAR2, cTabla VARCHAR2, nOrdenProceso NUMBER, cCadena VARCHAR2);
FUNCTION VALOR_CAMPO(cCadena VARCHAR2, nIndice NUMBER, cDelim VARCHAR2) RETURN VARCHAR2;
FUNCTION INSERTA_VALOR_CAMPO(cCadena  VARCHAR2, nIndice NUMBER, cDelim VARCHAR2, cValor VARCHAR2) RETURN VARCHAR2;
FUNCTION VALOR_POSICION (cCodPlantilla VARCHAR2, nCodEmpresa NUMBER, nCodCia NUMBER, cOrdenProceso NUMBER) RETURN NUMBER;
--FUNCTION INSERTA_ASEG_BENEF(nIdSiniestro NUMBER, nIdPoliza NUMBER, nCod_Asegurado NUMBER, nIdProcMasivo NUMBER, cNumSiniRef VARCHAR2) RETURN NUMBER;
PROCEDURE EMISION_COLECTIVA(nIdProcMasivo NUMBER);
PROCEDURE CANCELACION(nIdProcMasivo NUMBER);
PROCEDURE COBRANZA(nIdProcMasivo NUMBER);
PROCEDURE VENTA_TARJETA(nIdProcMasivo NUMBER);
PROCEDURE EMISION_TARJETA(nIdProcMasivo NUMBER);
PROCEDURE INSERTA_PROCESO_MASIVO_PROC(nIdProcMasivo NUMBER);
   PROCEDURE EMISION_COLECTIVA_ASEGURADO( cNomArchivoCarga  PROCESOS_MASIVOS.NomArchivoCarga%TYPE
                                        , cModificaSexo     VARCHAR2 );
PROCEDURE ALTA_CERTIFICADO(nIdProcMasivo NUMBER);
PROCEDURE AUMENTO(nIdProcMasivo NUMBER);
PROCEDURE BAJA_CERTIFICADO(nIdProcMasivo NUMBER);
PROCEDURE ESTIMACION_SINIESTROS(nIdProcMasivo NUMBER);
PROCEDURE PAGO_SINIESTROS(nIdProcMasivo NUMBER);
PROCEDURE INSERTA_BENEFICIARIO(cCodPlantilla VARCHAR2, cTabla VARCHAR2, nOrdenProceso NUMBER, cCadena VARCHAR2,
                               nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER);
PROCEDURE CREA_ASEG_ESTIM_SINI(nIdProcMasivo NUMBER);
PROCEDURE EMITIR_POLIZA_ESTIM_SINI(nIdProcMasivo NUMBER);
PROCEDURE COPIA_COBERT_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                                 nIdEndoso NUMBER, cEstado VARCHAR2, nCodAsegurado NUMBER);
PROCEDURE EMISION_QR(nidprocmasivo number);
PROCEDURE EMISION_INFONACOT(nIdProcMasivo NUMBER);

PROCEDURE CANCELA_INFONACOT(p_CodCia NUMBER, p_CodEmpresa NUMBER, p_IdPoliza NUMBER,
                            p_IDetPol NUMBER, p_ID_Credito NUMBER, p_Mensaje_Error OUT VARCHAR2);

PROCEDURE SINIESTROS_INFONACOT(nIdProcMasivo NUMBER);

PROCEDURE SINIESTROS_INFONACOT_EST(nIdProcMasivo NUMBER);   --ASEGMAS

PROCEDURE ACT_INFO_SINI(nIdCredito NUMBER,  nIdTrabajador NUMBER, nIdEnvio NUMBER,
                        nIdSiniestro NUMBER, dFec_Ocurrencia DATE, cObservacion VARCHAR2,
                        nCodError NUMBER);

PROCEDURE EMISION_CP(nIdProcMasivo NUMBER);
PROCEDURE EMITE_ASEGURADO_MASIVO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER);
PROCEDURE EMITE_ENDOSO_CP (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER);

PROCEDURE INSERTA_BENEFICIARIO_01(cCodPlantilla VARCHAR2, cTabla VARCHAR2, nOrdenProceso NUMBER, cCadena VARCHAR2,
                               nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER);
FUNCTION TIPO_SEPARADOR(cCodPlantilla VARCHAR2) RETURN VARCHAR2;
PROCEDURE  SINIESTROS_AURVAD(nIdProcMasivo NUMBER);
PROCEDURE  SINIESTROS_DIRVAD(nIdProcMasivo NUMBER);
PROCEDURE  SINIESTROS_ANUPGO(nIdProcMasivo NUMBER);
PROCEDURE  SINIESTROS_PGOGG(nIdProcMasivo NUMBER);
PROCEDURE DIRVAD( wIdSiniestro in Number, wMntoPgo in Number, wCobertura in  Varchar2);
PROCEDURE AURVAD (wIdSiniestro in Number, wMntoPgo in Number, wCobertura in  Varchar2);
PROCEDURE PAGO_SINIESTROS_MASIVO(nIdProcMasivo NUMBER);
FUNCTION  VALIDA_ARCHIVO_CARGA(cNomArchivoCarga VARCHAR2) RETURN BOOLEAN;
PROCEDURE ACTUALIZA_AUTORIZACION(nCodCia NUMBER, nCodEmpresa NUMBER,nIdProcMasivo NUMBER,cNomArchivoCarga VARCHAR2,nIdAutorizacion NUMBER);
PROCEDURE ENDOSO_DECLARACION_MASIVO(nIdProcMasivo NUMBER);
PROCEDURE ASEGURADOS_CON_FONDOS(nIdProcMasivo NUMBER);
PROCEDURE COBRANZA_APORTES_ASEG_FONDOS(nIdProcMasivo NUMBER);
   --
   PROCEDURE CARGA_ARCHIVO_ASEGURADOS ( nCodCia             NUMBER
                                      , cNumPolUnico        VARCHAR2
                                      , cTipoProceso        VARCHAR2
                                      , cIndCol             VARCHAR2
                                      , cCodUsuario         VARCHAR2
                                      , cIndAsegurado       VARCHAR2
                                      , cNombreArchivo      VARCHAR2
                                      , cRegsTotales   OUT  NUMBER
                                      , cRegsCargados  OUT  NUMBER
                                      , cRegsErroneos  OUT  NUMBER );
   --
   FUNCTION DEPURA_CADENA ( cCadenaEntrada  VARCHAR2 ) RETURN VARCHAR2;
   --
   PROCEDURE RECUPERA_LOG_CARGA( cNomArchCarga  VARCHAR2
                               , cNomArcSalida  VARCHAR2 );
END OC_PROCESOS_MASIVOS;

/
create or replace PACKAGE BODY          OC_PROCESOS_MASIVOS IS
--
--  MODIFICACION
--  17/02/2016  SE ELIMINO LA RUTINA DE REQUESITOS                                               -- JICO REQ
--  06/04/2016  SE PROGRAMO REESTRUCTURA-RENOVACION INFONACOT                                    -- JICO INFORE
--  13/04/2016  SE OPTIMIZO SINIESTROS INFONACOT                                                 -- JICO INFOSINI
--  15/04/2016  SE REPROGRAMO NUMEROS DE PLANTILLA EMIQR                                         -- JICO EMIQR
--  29/04/2016  SE DESPROGRAMO REESTRUCTURA-RENOVACION INFONACOT                                 -- JICO INFORE
--  12/05/2016  SE COLOCO FUNCION PARA QUITAR ACENTOS Y  PONER EN MAYUSCULAS                     -- JICO ACENTO
--  13/05/2016  Se agrega codigo para extraer el tipo de separador en PROCEDURE INSERT_DINAMICO  -- MAGO ExistAsegurado
--  18/05/2016  Se agrega un CASE en el cursor para corregir la posicion del campo a separar
--              y se quita el separador fijo (coma) por la variable                              -- MAGO INSERT_DINAMICO
--  25/05/2016  SE COLOCO EL BLOQUE PARA LA NUMERACION                                           -- JICO BLOQUEO
--  24/05/2016  Se agregan funciones de TIPO_SEPARADOR                                           -- MAGO
--  31/05/2016  Se agrega proceso de EMISION_CP para la emision de UBUNT - CP                    -- MAGO
--  01/06/2016  Se agrega proceso de EMITE_ASEGURADO_MASIVO complementario a  EMITE_ENDOSO_CP    -- MAGO
--  15/07/2016  SE PROGRAMA LA CANCELACION-DEVOLUCION DE INFONACOT                               -- JICO INFODEV
--  27/07/2016  Se agregan dos procesos  (AURVAD,DIRVAD) para Ajuste de Reservas usando
--              LayOut Corto a peticion de  Manuel palacios                                      -- AEVS PORFINSALES
--  03/08/2016  SE PROGRAMA EL GRABADO                                                           -- JICO GRABA
--  16/08/2016  Agrego rutina de actualizacion de la tabla PROCESOS_MASIVOS_SEGUIMIENTO          -- AEVS PROCMACSEG
--  01/09/2016  Agrego Rutina para Aseguramos que el IVA no rebase el 16% del monto a pagar             -- AEVS IVA
--  28/02/2017  Rutina para constituir solo reserva en INFONACOT                                        -- JICO ASEGMAS
--  16/02/2018  Cambio de numeracion por eliminacion de nombre completo                                 -- JICO INFO1
--  01/10/2019  Se incluyen validaciones para proveedores sat (Ya incluye cambios de CPérez)            -- JMMD SAT y PLD 20200406
--  24/06/2020  Se incluyen nuevas validaciones para proveedores sat (Ya incluye cambios de CPérez)     -- JMMD SAT y PLD 20200624
PROCEDURE PROCESO_REGISTRO(nIdProcMasivo NUMBER, cTipoProceso VARCHAR2) IS
BEGIN
   IF cTipoProceso = 'EMISIO' THEN
      OC_PROCESOS_MASIVOS.EMISION(nIdProcMasivo);
   ELSIF cTipoProceso = 'EMIWEB' THEN
      OC_PROCESOS_MASIVOS.EMISION_WEB(nIdProcMasivo);
   ELSIF cTipoProceso = 'EMICER' THEN
      OC_PROCESOS_MASIVOS.EMISION_INFONACOT(nIdProcMasivo);
   ELSIF cTipoProceso = 'COLECT' THEN
      OC_PROCESOS_MASIVOS.EMISION_COLECTIVA(nIdProcMasivo);
   ELSIF cTipoProceso = 'ASEGUR' THEN
      NULL;
      --SE DESAHABILITA DEBIDO A QUE SE AGREGAN PARAMETROS DE ENTRADA AL PROCESO Y YA NO ENTRARIA POR ESTA OPCION
      --OC_PROCESOS_MASIVOS.EMISION_COLECTIVA_ASEGURADO(nIdProcMasivo);
   ELSIF cTipoProceso = 'ENDALT' THEN
      OC_PROCESOS_MASIVOS.ALTA_CERTIFICADO(nIdProcMasivo);
   ELSIF cTipoProceso = 'ENDBAJ' THEN
      OC_PROCESOS_MASIVOS.BAJA_CERTIFICADO(nIdProcMasivo);
   ELSIF cTipoProceso = 'ENDAUM' THEN
      OC_PROCESOS_MASIVOS.AUMENTO(nIdProcMasivo);
   ELSIF cTipoProceso = 'ESTSIN' THEN
      OC_PROCESOS_MASIVOS.ESTIMACION_SINIESTROS(nIdProcMasivo);
   ELSIF cTipoProceso = 'PAGSIN' THEN
      --OC_PROCESOS_MASIVOS.PAGO_SINIESTROS(nIdProcMasivo);
       OC_PROCESOS_MASIVOS.PAGO_SINIESTROS_MASIVO(nIdProcMasivo);-- HGONZALEZ ESTE LLAMADO AL FINAL HAY QUE DESCOMENTARLO Y COMENTAR LA LINEA ANTERIOR
   ELSIF cTipoProceso = 'AESTSI' THEN
      OC_PROCESOS_MASIVOS.CREA_ASEG_ESTIM_SINI(nIdProcMasivo);
   ELSIF cTipoProceso = 'EESTSI' THEN
      OC_PROCESOS_MASIVOS.EMITIR_POLIZA_ESTIM_SINI(nIdProcMasivo);
   ELSIF cTipoProceso = 'SINCER' THEN
      OC_PROCESOS_MASIVOS.SINIESTROS_INFONACOT(nIdProcMasivo);
   ELSIF cTipoProceso = 'SINEST' THEN                                  --ASEGMAS
      OC_PROCESOS_MASIVOS.SINIESTROS_INFONACOT_EST(nIdProcMasivo);     --ASEGMAS
   ELSIF cTipoProceso = 'UBUNT' THEN
      OC_PROCESOS_MASIVOS.EMISION_CP(nIdProcMasivo);
   ELSIF cTipoProceso = 'AURVAD' THEN
      OC_PROCESOS_MASIVOS.SINIESTROS_AURVAD(nIdProcMasivo);   --AEVS
   ELSIF cTipoProceso = 'DIRVAD' THEN
      OC_PROCESOS_MASIVOS.SINIESTROS_DIRVAD(nIdProcMasivo);   --AEVS
   ELSIF cTipoProceso = 'ANUPGO' THEN
      OC_PROCESOS_MASIVOS.SINIESTROS_ANUPGO(nIdProcMasivo);   --AEVS
   ELSIF cTipoProceso = 'PAGTES' THEN
      OC_PROCESOS_MASIVOS.SINIESTROS_PGOGG(nIdProcMasivo); --AEVS
   ELSIF cTipoProceso = 'ASEFON' THEN
      OC_PROCESOS_MASIVOS.ASEGURADOS_CON_FONDOS(nIdProcMasivo);
   ELSIF cTipoProceso = 'COASFO' THEN
      OC_PROCESOS_MASIVOS.COBRANZA_APORTES_ASEG_FONDOS(nIdProcMasivo);
   ELSIF cTipoProceso = 'EMIQR' THEN
      OC_PROCESOS_MASIVOS.EMISION_QR(nIdProcMasivo);
   ELSIF cTipoProceso = 'VENTAR' THEN
      OC_PROCESOS_MASIVOS.VENTA_TARJETA(nIdProcMasivo);
   ELSIF cTipoProceso = 'EMITAR' THEN
      OC_PROCESOS_MASIVOS.EMISION_TARJETA(nIdProcMasivo);
   ELSIF cTipoProceso = 'CARFOL' THEN
     OC_TARJETAS_PREPAGO_CARGA.CARGA_FOLIO(nIdProcMasivo);
   ELSIF cTipoProceso = 'CANCEL' THEN
      OC_PROCESOS_MASIVOS.CANCELACION(nIdProcMasivo);
   ELSIF cTipoProceso = 'COBRAN' THEN
      OC_PROCESOS_MASIVOS.COBRANZA(nIdProcMasivo);
   END IF;
END PROCESO_REGISTRO;

PROCEDURE ACTUALIZA_STATUS(nIdProcMasivo NUMBER, cStsRegProceso VARCHAR2) IS
BEGIN
  IF cStsRegProceso = 'PROCE' THEN
     BEGIN
       OC_PROCESOS_MASIVOS.INSERTA_PROCESO_MASIVO_PROC(nIdProcMasivo);
       DELETE PROCESOS_MASIVOS
        WHERE IdProcMasivo = nIdProcMasivo;
     EXCEPTION
        WHEN OTHERS THEN
           OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'ERROR','20225','Error en Traslado de registro a Tabla PROCESOS_MASIVOS_PROC '||SQLERRM);
           OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
     END;
  ELSE
    BEGIN
      UPDATE PROCESOS_MASIVOS
        SET StsRegProceso = cStsRegProceso,
            FecSts        = TRUNC(SYSDATE)
      WHERE IdProcMasivo  = nIdProcMasivo;
   EXCEPTION
       WHEN OTHERS THEN
         OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'ERROR','20225','Error en Actualización de  PROCESOS_MASIVOS '||SQLERRM);
         OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
     END ;
  END IF;
END ACTUALIZA_STATUS;

PROCEDURE EMISION(nIdProcMasivo NUMBER) IS
nCodCliente        CLIENTES.CODCLIENTE%TYPE;
cTipoDocIdentAseg  CLIENTES.TIPO_DOC_IDENTIFICACION%TYPE;
cNumDocIdentAseg   CLIENTES.Num_Doc_Identificacion%TYPE;
nCod_Asegurado     ASEGURADO.Cod_Asegurado%TYPE;
nCodCia            POLIZAS.CodCia%TYPE;
nCodEmpresa        POLIZAS.CodEmpresa%TYPE;
cCodmoneda         POLIZAS.Cod_Moneda%TYPE;
cPlanCob           PLAN_COBERTURAS.PlanCob%TYPE;
cExiste            VARCHAR2  (1);
cExisteDet         VARCHAR2  (1);
nIdPoliza          POLIZAS.IdPoliza%TYPE;
cIdTipoSeg         TIPOS_DE_SEGUROS.IdTipoSeg%TYPE;
nPorcComis         POLIZAS.PorcComis%TYPE;
cDescpoliza        POLIZAS.DescPoliza%TYPE;
nCod_Agente        POLIZAS.Cod_agente%TYPE;
cCodPlanPago       POLIZAS.CodPlanPago%TYPE;
cExisteTipoSeguro  VARCHAR2  (2);
nTasaCambio        DETALLE_POLIZA.Tasa_Cambio%TYPE;
nIDetPol           DETALLE_POLIZA.IDetPol%TYPE;
cIdGrupoTarj       TARJETAS_PREPAGO.IdGrupoTarj%TYPE;
cCodPromotor       DETALLE_POLIZA.CodPromotor%TYPE;
cMsjError          PROCESOS_MASIVOS_LOG.TxtError%TYPE := 'N';
cCodPlantilla      CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE;
cNomTabla          CONFIG_PLANTILLAS_CAMPOS.NomTabla%TYPE;
nOrden             NUMBER(10):= 1  ;
nOrdenInc          NUMBER(10) ;
cUpdate            VARCHAR2(4000);
dFecIniVig         DATE;
dFecFinVig         DATE;
cStsPoliza         POLIZAS.StsPoliza%TYPE;
cExisteParEmi      VARCHAR2(1);
cSexo              PERSONA_NATURAL_JURIDICA.Sexo%TYPE;
dFecNacimiento     PERSONA_NATURAL_JURIDICA.FecNacimiento%TYPE;

CURSOR C_CAMPOS (cNomTabla VARCHAR2) IS
   SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.TipoCampo
     FROM CONFIG_PLANTILLAS_CAMPOS C
    WHERE C.CodPlantilla = cCodPlantilla
      AND C.CodEmpresa   = nCodEmpresa
      AND C.NomTabla     = cNomTabla
      AND C.CodCia       = nCodCia
    ORDER BY OrdenCampo;
CURSOR C_CAMPOS_PART  IS
   SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.OrdenDatoPart
     FROM CONFIG_PLANTILLAS_CAMPOS C
    WHERE C.CodPlantilla = cCodPlantilla
      AND C.CodEmpresa   = nCodEmpresa
      AND C.CodCia       = nCodCia
      AND C.NomTabla     = 'DATOS_PART_EMISION'
      AND C.IndDatoPart  = 'S'
    ORDER BY OrdenDatoPart,OrdenCampo;

CURSOR EMI_Q IS
   SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
          NumDetUnico, RegDatosProc, TipoProceso,IndColectiva
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;
BEGIN
   FOR X IN EMI_Q LOOP
      nCodcia          :=  X.CodCia;
      nCodempresa      :=  X.CodEmpresa;
      cTipoDocIdentAseg := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,',')) ;
      cNumDocIdentAseg  := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,7,',')) ;
      cCodPlanPago      := OC_TIPOS_DE_SEGUROS.PLAN_PAGOS(X.CodCia, X.CodEmpresa, X.IdTipoSeg);
      cCodPlantilla     := OC_CONFIG_PLANTILLAS_PLANCOB.CODIGO_PLANTILLA(X.CodCia,X.CodEmpresa,X.IdTipoSeg,X.PlanCob,X.TipoProceso);
      cSexo             := NVL(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,11,',')),'N');
      dFecNacimiento    := TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,12,',')),'DD/MM/RRRR');

      IF cSexo NOT IN ('M','F','N') THEN
         RAISE_APPLICATION_ERROR(-20100,'Código de Sexo debe contener M, F o N. Favor de Corregir.');
      END IF;

      IF X.NumPolUnico != X.NumDetUnico THEN
         RAISE_APPLICATION_ERROR(-20100,'Número de Póliza no Coincide con el Número de Certificado');
      END IF;
      IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(cTipoDocIdentAseg, cNumDocIdentAseg) = 'N' THEN
         OC_PROCESOS_MASIVOS.INSERT_DINAMICO(cCodPlantilla, 'PERSONA_NATURAL_JURIDICA', 1, X.RegDatosProc);
      ELSE
         nOrden    := 1;
         nOrdenInc := 0;
         FOR I IN C_CAMPOS('PERSONA_NATURAL_JURIDICA') LOOP
            nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
            cUpdate := 'UPDATE '||'PERSONA_NATURAL_JURIDICA'||' '||'SET'||' '||I.NomCampo||'=';
            IF I.TipoCampo = 'DATE' THEN
               cUpdate := cUpdate || ' TO_DATE(' || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||
                          CHR(39) || ','|| CHR(39) || 'DD/MM/RRRR' || CHR(39) || ') ';
            ELSE
               cUpdate := cUpdate || '''' ||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||'''';
            END IF;
            cUpdate := cUpdate ||' '||'WHERE Tipo_Doc_Identificacion='||''''||cTipoDocIdentAseg||''''||' '||
                                      'AND Num_Doc_Identificacion='||''''||cNumDocIdentAseg||'''';

            OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate) ;
            nOrden := nOrden + 1;
         END LOOP;

            /*IF UPPER(I.NomCampo) = 'FECNACIMIENTO' THEN
               nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
               cUpdate := 'UPDATE '||'PERSONA_NATURAL_JURIDICA'||' '||'SET'||' '||I.NomCampo||'='|| 'TO_DATE(' || CHR(39) ||
                          LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',') || CHR(39) || ','|| CHR(39) ||
                          'DD/MM/RRRR' || CHR(39) || ') ' ||
                          'WHERE Tipo_Doc_Identificacion='||''''||cTipoDocIdentAseg||''''||' '||
                          'AND Num_Doc_Identificacion='||''''||cNumDocIdentAseg||'''');
               OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate) ;
            END IF;
            nOrden := nOrden + 1;
         END LOOP;*/
      END IF;
      nOrden    := 1;
      nOrdenInc := 0;
      IF OC_PERSONA_NATURAL_JURIDICA.FUNC_VALIDA_EDAD(cTipoDocIdentAseg, cNumDocIdentAseg, X.CodCia, X.CodEmpresa ,X.IdTipoSeg ,X.PlanCob)= 'N' THEN
         RAISE_APPLICATION_ERROR(-20225,'Edad del Asegurado Fuera del Rango de Aceptación de Coberturas');
      END IF;
      BEGIN
        SELECT Cod_Agente
          INTO nCod_Agente
          FROM PLAN_COBERTURAS
         WHERE CodCia     = X.CodCia
           AND CodEmpresa = X.CodEmpresa
           AND IdTipoSeg  = X.IdTipoSeg
           AND PlanCob    = X.PlanCob;
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
           nCod_Agente := 0;
     END;
     nCodCliente := OC_CLIENTES.CODIGO_CLIENTE(cTipoDocIdentAseg, cNumDocIdentAseg);
     IF nCodCliente = 0  THEN
        nCodCliente    := OC_CLIENTES.INSERTAR_CLIENTE(cTipoDocIdentAseg,cNumDocIdentAseg);
        FOR I IN C_CAMPOS('CLIENTES') LOOP
           nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
           cUpdate := 'UPDATE '||'CLIENTES'||' '||'SET'||' '||I.NomCampo||'=';
           IF I.TipoCampo = 'DATE' THEN
              cUpdate := cUpdate || ' TO_DATE(' || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||
                         CHR(39) || ','|| CHR(39) || 'DD/MM/RRRR' || CHR(39) || ') ';
           ELSE
              cUpdate := cUpdate || '''' ||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||'''';
           END IF;
           cUpdate := cUpdate ||' '||'WHERE CODCLIENTE='||nCodCliente;
           OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate) ;
           nOrden := nOrden + 1;
        END LOOP;
     END IF;
     nCod_Asegurado := OC_ASEGURADO.CODIGO_ASEGURADO(X.CodCia, X.CodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
     IF nCod_Asegurado = 0 THEN
        nCod_Asegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(X.CodCia, X.CodEmpresa,cTipoDocIdentAseg, cNumDocIdentAseg);
     END IF;
      BEGIN
         INSERT INTO CLIENTE_ASEG (CodCliente, Cod_Asegurado)
         VALUES(nCodCliente, nCod_Asegurado);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            NULL;
      END;
      BEGIN
         SELECT IdPoliza, FecIniVig
           INTO nIdpoliza, dFecIniVig
           FROM POLIZAS
          WHERE NumPolUnico = X.NumPolUnico
            AND CodCia      = X.CodCia
            AND CodEmpresa  = X.CodEmpresa
            AND StsPoliza   IN ('SOL','EMI');
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          nIdPoliza := 0;
          dFecIniVig := TRUNC(SYSDATE);
      END;

      IF dFecNacimiento > dFecIniVig THEN
         RAISE_APPLICATION_ERROR(-20225,'La Fecha de Nacimiento no puede ser mayor a la fecha de inicio de Vigencia de la Poliza - NO Procede Crearlo');
      END IF;

      cExiste     := OC_POLIZAS.EXISTE_POLIZA(X.CodCia, X.CodEmpresa, nIdpoliza);
      cDescPoliza := 'Activación Masiva No. ' || TRIM(TO_CHAR(nIdProcMasivo));
      cCodMoneda  := OC_PLAN_COBERTURAS.MONEDA_PLANCOB(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob);
      nPorcComis  := OC_CONFIG_COMISIONES.PORCENTAJE_COMISION(X.CodCia, X.CodEmpresa, X.IdTipoSeg);
      IF cExiste = 'N' AND  NVL(X.IndColectiva,'N') = 'N' THEN
         IF dFecIniVig IS NULL THEN
           dFecIniVig := TRUNC(SYSDATE);
         END IF;
         nIdPoliza   := OC_POLIZAS.INSERTAR_POLIZA(X.CodCia, X.CodEmpresa, cDescPoliza, cCodMoneda, nPorcComis,
                                                nCodCliente, nCod_Agente, cCodPlanPago, TRIM(TO_CHAR(x.numpolunico)),cIdGrupoTarj,dFecIniVig);
      END IF;
      nOrden:= 1;
      nOrdenInc := 0;
      IF NVL(X.IndColectiva,'N') = 'N' THEN
         FOR I IN C_CAMPOS('POLIZAS') LOOP
           nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
           cUpdate := 'UPDATE '||'POLIZAS'||' '||'SET'||' '||I.NomCampo||'=';
           IF I.TipoCampo = 'DATE' THEN
              cUpdate := cUpdate || ' TO_DATE(' || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||
                         CHR(39) || ','|| CHR(39) || 'DD/MM/RRRR' || CHR(39) || ') ';
           ELSE
              cUpdate := cUpdate || '''' ||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||'''';
           END IF;
           cUpdate := cUpdate ||' '||'WHERE IdPoliza='||nIdpoliza||' '||
                      'AND CodCia='||X.CodCia||' '||'AND CodEmpresa='||X.CodEmpresa;
           OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate) ;
           nOrden := nOrden + 1;
         END LOOP;
      END IF;
      cExisteTipoSeguro := OC_TIPOS_DE_SEGUROS.EXISTE_TIPO_DE_SEGURO(X.CodCia, X.CodEmpresa, X.IdTipoSeg );
      IF cExisteTipoSeguro = 'S' THEN
        BEGIN
        -- Inserta Tarea de Seguimiento
          IF OC_TAREA.EXISTE_TAREA(X.CodCia,nIdPoliza) = 'N' THEN
             OC_TAREA.INSERTA_TAREA(X.CodCia, 7, 'SOL', 'EMI', nIdPoliza, nCodCliente, 'A','SOL', 'SOLICITUD DE EMISION');
          END IF;
        -- Genera Detalle de Poliza
          nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
        BEGIN
           SELECT FecIniVig ,FecFinVig, StsPoliza
             INTO dFecIniVig,dFecFinVig,cStsPoliza
             FROM Polizas
            WHERE IdPoliza   = nIdPoliza
              AND CodCia     = X.CodCia
              AND CodEmpresa = X.CodEmpresa;
        END;

        IF cStsPoliza = 'SOL'  THEN
          IF OC_DETALLE_POLIZA.EXISTE_POLIZA_DETALLE(X.CodCia, X.CodEmpresa, nIdPoliza, TRIM(TO_CHAR(x.NumDetUnico))) = 'N' THEN
             BEGIN
                SELECT 'S'
                  INTO cExisteDet
                  FROM DETALLE_POLIZA
                 WHERE IdPoliza   = nIdPoliza
                   AND CodCia     = X.CodCia
                   AND CodEmpresa = X.CodEmpresa
                   AND IDetPol    = 1;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  cExisteDet := 'N';
             END;
             IF NVL(cExisteDet,'N') = 'S' THEN
                RAISE_APPLICATION_ERROR(-20225,'Ya existe un Certificado , NO Póliza es Colectiva: ');
             ELSE
                nIDetPol    := OC_DETALLE_POLIZA.INSERTAR_DETALLE(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob,
                                                                  nIdPoliza, nTasaCambio, nPorcComis, nCod_Asegurado,
                                                                  cCodPlanPago, TRIM(TO_CHAR(X.NumDetUnico)),cCodPromotor,dFecIniVig);
             END IF;
          ELSE
             BEGIN
                SELECT IDetPol
                  INTO nIDetPol
                  FROM DETALLE_POLIZA
                 WHERE CodCia      = X.CodCia
                   AND CodEmpresa  = X.CodEmpresa
                   AND IdPoliza    = nIdpoliza
                   AND NumDetRef   = TRIM(TO_CHAR(x.NumDetUnico));
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   RAISE_APPLICATION_ERROR(-20225,'DETALLE POLIZA NO EXISTE: '|| TRIM(TO_CHAR(x.numpolunico)));
             END;
         END IF;
         nOrden    := 1;
         nOrdenInc := 0;
         FOR I IN C_CAMPOS('DETALLE_POLIZA') LOOP
            nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
            IF UPPER(I.NomCampo) = 'FECINIVIG' THEN
               IF TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')),'DD-MM-YYYY') NOT BETWEEN  dFecIniVig AND  dFecFinVig  THEN
                  RAISE_APPLICATION_ERROR(-20225,'Fecha de Inicio de Vigencia del Certificado debe estar dentro dela  Vigencia de la Póliza');
               END IF;
            END IF;
            IF UPPER(I.NomCampo) = 'FECFINVIG' THEN
               IF TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')),'DD-MM-YYYY') NOT BETWEEN  dFecIniVig AND  dFecFinVig  THEN
                  RAISE_APPLICATION_ERROR(-20225,'Fecha de Final de Vigencia del Certificado debe estar dentro dela  Vigencia de la Póliza ');
               END IF;
            END IF;
            nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;

            cUpdate := 'UPDATE '||'DETALLE_POLIZA'||' '||'SET'||' '||I.NomCampo||'=';
            IF I.TipoCampo = 'DATE' THEN
               cUpdate := cUpdate || ' TO_DATE(' || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||
                          CHR(39) || ','|| CHR(39) || 'DD/MM/RRRR' || CHR(39) || ') ';
            ELSE
               cUpdate := cUpdate || '''' ||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||'''';
            END IF;
            cUpdate := cUpdate ||' '||'WHERE IdPoliza='||nIdPoliza||' '||'AND IDetPol='||nIDetPol||' '||
                       'AND CodCia='||X.CodCia||' '||'AND CodEmpresa='||X.CodEmpresa;
            OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate) ;
            nOrden := nOrden + 1;
         END LOOP;
      nOrden    := 1;
      nOrdenInc := 0;
      FOR I IN C_CAMPOS_PART LOOP
         BEGIN
           SELECT 'S'
             INTO cExisteParEmi
             FROM DATOS_PART_EMISION
            WHERE CodCia    = X.CodCia
              AND Idpoliza  = nIdPoliza
              AND IdetPol   = nIDetPol;
         EXCEPTION
            WHEN no_data_found THEN
               cExisteParEmi := 'N';
         END;
         IF NVL(cExisteParEmi,'N') = 'N' THEN
            INSERT INTO DATOS_PART_EMISION(CodCia, Idpoliza, IdetPol, StsDatPart, FecSts)
            VALUES (X.CodCia, nIdPoliza, nIDetPol, 'SOL', SYSDATE);
         END IF;
         nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
         cUpdate   := 'UPDATE '||'DATOS_PART_EMISION'||' '||'SET'||' '||'CAMPO'||I.OrdenDatoPart||'='||''''||
                      LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')||''''||' '||
                      'WHERE IdPoliza='||nIdpoliza||' '||'AND IDetPol='||nIDetPol||' '||'AND CodCia='||X.CodCia);
         OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate);
         nOrden := nOrden + 1;
      END LOOP;
      IF OC_COBERT_ACT.EXISTE_COBERTURA(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob,nIdPoliza, nIDetPol) = 'N' THEN
        --OC_COBERT_ACT.CARGAR_COBERTURAS(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob,nIdPoliza, nIDetPol, nTasaCambio);
        OC_COBERT_ACT.CARGAR_COBERTURAS(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob,nIdPoliza,
                                        nIDetPol, nTasaCambio, NULL, 0, 0, 0, 0, 99, 0, 0, 0, 0, 0, 0);
      END IF;

      nOrden    := 1;
      nOrdenInc := 0;
      FOR I IN C_CAMPOS('COBERT_ACT') LOOP
         nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
         cUpdate   := 'UPDATE '||'COBERT_ACT'||' '||'SET'||' '||I.NomCampo||'='||''''||
                      LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')||''''||' '||
                      'WHERE IdPoliza = '||nIdpoliza||' '||
                      'AND IDetPol = '||nIDetPol||' '||'AND CodCia='||X.CodCia||' '||'AND CodEmpresa='||X.CodEmpresa||' '||
                      'AND IdTipoSeg = '||''''||X.IdTipoSeg||'''');
         OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate) ;
         nOrden := nOrden + 1;
      END LOOP;
      IF OC_AGENTES_DETALLES_POLIZAS.EXISTE_AGENTE (X.CodCia, nIdPoliza, nIDetPol, X.IdTipoSeg, nCod_Agente) = 'N' THEN
         IF nCod_Agente IS NOT NULL THEN
            OC_AGENTES_DETALLES_POLIZAS.INSERTA_AGENTE(X.CodCia, nIdPoliza, nIDetPol, X.IdTipoSeg, nCod_Agente);
         END IF;
      END IF;

--      OC_POLIZAS.INSERTA_REQUISITOS(X.CodCia, nIdPoliza);     --REQ
      OC_POLIZAS.ACTUALIZA_VALORES(X.CodCia, nIdPoliza, 0);
      OC_DETALLE_POLIZA.ACTUALIZA_VALORES(X.CodCia, nIdPoliza, nIDetPol, 0);
    ELSE
       cMsjError := 'S';
       RAISE_APPLICATION_ERROR(-20225,'Poliza:'||TRIM(TO_CHAR(X.numpolunico)||' Debe estar en Estado SOL'));
    END IF;
      EXCEPTION
        WHEN OTHERS THEN
          cMsjError := SQLERRM;
      END ;
      IF cMsjError = 'N'   THEN
         OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'PROCE');
         IF NVL(X.IndColectiva,'N')= 'N' THEN
            OC_POLIZAS.EMITIR_POLIZA(X.CodCia, nIdPoliza, X.CodEmpresa);
         END IF;
      ELSE
         OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','No se puede emitir la Poliza: '||cMsjError);
         OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
      END IF;
    ELSE
      OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
    END IF;
   END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','No se puede emitir la Poliza Final: '||SQLERRM);
    OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END EMISION;

PROCEDURE EMISION_WEB(nIdProcMasivo NUMBER) IS
nCodCliente        CLIENTES.CODCLIENTE%TYPE;
cTipoDocIdentAseg  CLIENTES.TIPO_DOC_IDENTIFICACION%TYPE;
cNumDocIdentAseg   CLIENTES.Num_Doc_Identificacion%TYPE;
nCod_Asegurado     ASEGURADO.Cod_Asegurado%TYPE;
nCodCia            POLIZAS.CodCia%TYPE;
nCodEmpresa        POLIZAS.CodEmpresa%TYPE;
cCodmoneda         POLIZAS.Cod_Moneda%TYPE;
cPlanCob           PLAN_COBERTURAS.PlanCob%TYPE;
nIdPoliza          POLIZAS.IdPoliza%TYPE;
cIdTipoSeg         TIPOS_DE_SEGUROS.IdTipoSeg%TYPE;
nPorcComis         POLIZAS.PorcComis%TYPE;
cDescpoliza        POLIZAS.DescPoliza%TYPE;
nCod_Agente        POLIZAS.Cod_agente%TYPE;
cCodPlanPago       POLIZAS.CodPlanPago%TYPE;
nTasaCambio        DETALLE_POLIZA.Tasa_Cambio%TYPE;
nIDetPol           DETALLE_POLIZA.IDetPol%TYPE;
cIdGrupoTarj       TARJETAS_PREPAGO.IdGrupoTarj%TYPE;
cCodPromotor       DETALLE_POLIZA.CodPromotor%TYPE;
cMsjError          PROCESOS_MASIVOS_LOG.TxtError%TYPE := 'N';
cCodPlantilla      CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE;
cNomTabla          CONFIG_PLANTILLAS_CAMPOS.NomTabla%TYPE;
cCodFormaCobro     MEDIOS_DE_COBRO.CodFormaCobro%TYPE;
cStsPoliza         POLIZAS.StsPoliza%TYPE;
nOrden             NUMBER(10):= 1  ;
nOrdenInc          NUMBER(10) ;
cUpdate            VARCHAR2(4000);
dFecIniVig         DATE;
dFecFinVig         DATE;
cExisteParEmi      VARCHAR2(1);
cExiste            VARCHAR2  (1);
cExisteDet         VARCHAR2  (1);
cExisteTipoSeguro  VARCHAR2  (2);
cSexo              PERSONA_NATURAL_JURIDICA.Sexo%TYPE;
dFecNacimiento     PERSONA_NATURAL_JURIDICA.FecNacimiento%TYPE;
cOrigen            AGENTE_POLIZA.Origen%TYPE;
W_NIDPROCMASIVO    PROCESOS_MASIVOS.IDPROCMASIVO%TYPE;

CURSOR C_CAMPOS (cNomTabla VARCHAR2, nOrdenProceso NUMBER) IS
   SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.TipoCampo
     FROM CONFIG_PLANTILLAS_CAMPOS C
    WHERE C.CodPlantilla = cCodPlantilla
      AND C.CodEmpresa   = nCodEmpresa
      AND C.OrdenProceso = nOrdenProceso
      AND C.NomTabla     = cNomTabla
      AND C.CodCia       = nCodCia
    ORDER BY OrdenCampo;
CURSOR C_CAMPOS_PART  IS
   SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.OrdenDatoPart
     FROM CONFIG_PLANTILLAS_CAMPOS C
    WHERE C.CodPlantilla = cCodPlantilla
      AND C.CodEmpresa   = nCodEmpresa
      AND C.CodCia       = nCodCia
      AND C.NomTabla     = 'DATOS_PART_EMISION'
      AND C.IndDatoPart  = 'S'
    ORDER BY OrdenDatoPart,OrdenCampo;
cursor emi_q is
   SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
          NumDetUnico, RegDatosProc, TipoProceso,IndColectiva
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;
BEGIN
   W_NIDPROCMASIVO := nIdProcMasivo;
   FOR X IN EMI_Q LOOP
      nCodCia           := X.CodCia;
      nCodempresa       := X.CodEmpresa;

      -- Datos del Contratante
      cTipoDocIdentAseg := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,1+5,','));
      cNumDocIdentAseg  := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,2+5,','));
      cCodPlanPago      := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,28+5,','));
      cSexo             := NVL(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,12,',')),'N');
      dFecNacimiento    := TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,13,',')),'DD/MM/RRRR');

      IF cSexo NOT IN ('M','F','N') THEN
         RAISE_APPLICATION_ERROR(-20100,'Código de Sexo debe contener M, F o N. Favor de Corregir.');
      END IF;

      IF cCodPlanPago IS NULL THEN
         cCodPlanPago      := OC_TIPOS_DE_SEGUROS.PLAN_PAGOS(X.CodCia, X.CodEmpresa, X.IdTipoSeg);
      END IF;
      cCodPlantilla     := OC_CONFIG_PLANTILLAS_PLANCOB.CODIGO_PLANTILLA(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, X.TipoProceso);

      IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(cTipoDocIdentAseg, cNumDocIdentAseg) = 'N' THEN
         OC_PROCESOS_MASIVOS.INSERT_DINAMICO(cCodPlantilla, 'PERSONA_NATURAL_JURIDICA', 1, X.RegDatosProc);
      ELSE
         nOrden    := 1;
         nOrdenInc := 0;
         FOR I IN C_CAMPOS('PERSONA_NATURAL_JURIDICA', 1) LOOP
            nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
            cUpdate := 'UPDATE '||'PERSONA_NATURAL_JURIDICA'||' '||'SET'||' '||I.NomCampo||'=';
            IF I.TipoCampo = 'DATE' THEN
               cUpdate := cUpdate || ' TO_DATE(' || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||
                          CHR(39) || ','|| CHR(39) || 'DD/MM/RRRR' || CHR(39) || ') ';
            ELSE
               cUpdate := cUpdate || '''' ||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||'''';
            END IF;
            cUpdate := cUpdate ||' '||'WHERE Tipo_Doc_Identificacion='||''''||cTipoDocIdentAseg||''''||' '||
                                      'AND Num_Doc_Identificacion='||''''||cNumDocIdentAseg||'''';

            OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate) ;
            nOrden := nOrden + 1;
         END LOOP;

      END IF;
      nOrden    := 1;
      nOrdenInc := 0;

      nCodCliente := OC_CLIENTES.CODIGO_CLIENTE(cTipoDocIdentAseg, cNumDocIdentAseg);
      IF nCodCliente = 0  THEN
         nCodCliente    := OC_CLIENTES.INSERTAR_CLIENTE(cTipoDocIdentAseg,cNumDocIdentAseg);
      END IF;

      BEGIN
         SELECT IdPoliza, FecIniVig
           INTO nIdpoliza, dFecIniVig
           FROM POLIZAS
          WHERE NumPolUnico = X.NumPolUnico
            AND CodCia      = X.CodCia
            AND CodEmpresa  = X.CodEmpresa
            AND StsPoliza   IN ('SOL','EMI');
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            nIdPoliza := 0;
            dFecIniVig := TRUNC(SYSDATE);
      END;

      IF dFecNacimiento > dFecIniVig THEN
         RAISE_APPLICATION_ERROR(-20225,'La Fecha de Nacimiento no puede ser mayor a la fecha de inicio de Vigencia de la Poliza - NO Procede Crearlo');
      END IF;

      cExiste     := OC_POLIZAS.EXISTE_POLIZA(X.CodCia, X.CodEmpresa, nIdpoliza);
      cDescPoliza := 'Activación Masiva No. ' || TRIM(TO_CHAR(nIdProcMasivo));
      cCodMoneda  := OC_PLAN_COBERTURAS.MONEDA_PLANCOB(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob);
      nPorcComis  := OC_CONFIG_COMISIONES.PORCENTAJE_COMISION(X.CodCia, X.CodEmpresa, X.IdTipoSeg);
      IF cExiste = 'N' AND  NVL(X.IndColectiva,'N') = 'N' THEN
         IF dFecIniVig IS NULL THEN
            dFecIniVig := TRUNC(SYSDATE);
         END IF;
         nIdPoliza   := OC_POLIZAS.INSERTAR_POLIZA(X.CodCia, X.CodEmpresa, cDescPoliza, cCodMoneda, nPorcComis,
                                                   nCodCliente, nCod_Agente, cCodPlanPago, TRIM(TO_CHAR(X.NumPolUnico)),
                                                   cIdGrupoTarj, dFecIniVig);
      END IF;
      nOrden:= 1;
      nOrdenInc := 0;
      IF NVL(X.IndColectiva,'N') = 'N' THEN
         FOR I IN C_CAMPOS('POLIZAS', 2) LOOP
           nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
           cUpdate := 'UPDATE '||'POLIZAS'||' '||'SET'||' '||I.NomCampo||'=';
           IF I.TipoCampo = 'DATE' THEN
              cUpdate := cUpdate || ' TO_DATE(' || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||
                         CHR(39) || ','|| CHR(39) || 'DD/MM/RRRR' || CHR(39) || ') ';
           ELSE
              cUpdate := cUpdate || '''' ||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||'''';
           END IF;
           cUpdate    := cUpdate ||' '||'WHERE IdPoliza = '||nIdpoliza||' '||
                         'AND CodCia='||X.CodCia||' '||'AND CodEmpresa = '||X.CodEmpresa;
           OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate) ;
           nOrden := nOrden + 1;
         END LOOP;
         -- Datos DEFAULT para Emisión WEB
         UPDATE POLIZAS
            SET Caracteristica = '1',
                FormaVenta     = '001',
                TipoDividendo  = '003',
                TipoRiesgo     = '002'
          WHERE IdPoliza   = nIdPoliza
            AND CodCia     = X.CodCia
            AND CodEmpresa = X.CodEmpresa;
      END IF;

      cTipoDocIdentAseg := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,29+5,','));
      cNumDocIdentAseg  := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,30+5,','));
      dFecNacimiento    := TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,36+5,',')),'DD/MM/RRRR');

      IF dFecNacimiento > dFecIniVig THEN
         RAISE_APPLICATION_ERROR(-20225,'La Fecha de Nacimiento no puede ser mayor a la fecha de inicio de Vigencia de la Poliza - NO Procede Crearlo');
      END IF;
      --
      IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(cTipoDocIdentAseg, cNumDocIdentAseg) = 'N' THEN
         OC_PROCESOS_MASIVOS.INSERT_DINAMICO(cCodPlantilla, 'PERSONA_NATURAL_JURIDICA', 3, X.RegDatosProc);
      ELSE
         nOrden    := 1;
         nOrdenInc := 0;
         FOR I IN C_CAMPOS('PERSONA_NATURAL_JURIDICA', 3) LOOP
            nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
            cUpdate := 'UPDATE '||'PERSONA_NATURAL_JURIDICA'||' '||'SET'||' '||I.NomCampo||'=';
            IF I.TipoCampo = 'DATE' THEN
               cUpdate := cUpdate || ' TO_DATE(' || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||
                          CHR(39) || ','|| CHR(39) || 'DD/MM/RRRR' || CHR(39) || ') ';
            ELSE
               cUpdate := cUpdate || '''' ||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||'''';
            END IF;
            cUpdate := cUpdate ||' '||'WHERE Tipo_Doc_Identificacion='||''''||cTipoDocIdentAseg||''''||' '||
                                      'AND Num_Doc_Identificacion='||''''||cNumDocIdentAseg||'''';

            OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate) ;
            nOrden := nOrden + 1;
         END LOOP;
      END IF;
      nOrden    := 1;
      nOrdenInc := 0;
      IF OC_PERSONA_NATURAL_JURIDICA.FUNC_VALIDA_EDAD(cTipoDocIdentAseg, cNumDocIdentAseg, X.CodCia,
                                                      X.CodEmpresa, X.IdTipoSeg, X.PlanCob) = 'N' THEN
         RAISE_APPLICATION_ERROR(-20225,'Edad del Asegurado Fuera del Rango de Aceptación de Coberturas');
      END IF;

      cCodFormaCobro := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,78+5,','));

      IF cCodFormaCobro IS NOT NULL THEN
         IF OC_MEDIOS_DE_COBRO.EXISTE_MEDIO_DE_COBRO(cTipoDocIdentAseg, cNumDocIdentAseg, 1) = 'N' THEN
            OC_MEDIOS_DE_COBRO.INSERTAR(cTipoDocIdentAseg, cNumDocIdentAseg, 1, 'S', cCodFormaCobro);
         END IF;
         FOR I IN C_CAMPOS('MEDIOS_DE_COBRO', 10) LOOP
            nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
            cUpdate := 'UPDATE '||'MEDIOS_DE_COBRO'||' '||'SET'||' '||I.NomCampo||'=';
            IF I.TipoCampo = 'DATE' THEN
               cUpdate := cUpdate || ' TO_DATE(' || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||
                          CHR(39) || ','|| CHR(39) || 'DD/MM/RRRR' || CHR(39) || ') ';
            ELSE
               cUpdate := cUpdate || CHR(39) ||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) || CHR(39);
            END IF;

            cUpdate := cUpdate ||' WHERE Tipo_Doc_Identificacion = '|| CHR(39) || cTipoDocIdentAseg || CHR(39) ||' '||
                                    'AND Num_Doc_Identificacion = ' || CHR(39) || cNumDocIdentAseg  || CHR(39);
            OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate) ;
            nOrden := nOrden + 1;
         END LOOP;
      END IF;

      nCod_Asegurado := OC_ASEGURADO.CODIGO_ASEGURADO(X.CodCia, X.CodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
      IF nCod_Asegurado = 0 THEN
         nCod_Asegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(X.CodCia, X.CodEmpresa,cTipoDocIdentAseg, cNumDocIdentAseg);
      END IF;

      BEGIN
         INSERT INTO CLIENTE_ASEG
               (CodCliente, Cod_Asegurado)
         VALUES(nCodCliente, nCod_Asegurado);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            NULL;
      END;

      cExisteTipoSeguro := OC_TIPOS_DE_SEGUROS.EXISTE_TIPO_DE_SEGURO(X.CodCia, X.CodEmpresa, X.IdTipoSeg);
      IF cExisteTipoSeguro = 'S' THEN
         BEGIN
            -- Inserta Tarea de Seguimiento
           IF OC_TAREA.EXISTE_TAREA(X.CodCia,nIdPoliza) = 'N' THEN
               OC_TAREA.INSERTA_TAREA(X.CodCia, 7, 'SOL', 'EMI', nIdPoliza, nCodCliente, 'A','SOL', 'SOLICITUD DE EMISION');
            END IF;
            -- Genera Detalle de Poliza
            nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
            BEGIN
               SELECT FecIniVig ,FecFinVig, StsPoliza
                 INTO dFecIniVig,dFecFinVig,cStsPoliza
                 FROM Polizas
                WHERE IdPoliza   = nIdPoliza
                  AND CodCia     = X.CodCia
                  AND CodEmpresa = X.CodEmpresa;
            END;

            IF cStsPoliza = 'SOL'  THEN
               IF OC_DETALLE_POLIZA.EXISTE_POLIZA_DETALLE(X.CodCia, X.CodEmpresa, nIdPoliza, TRIM(TO_CHAR(x.NumDetUnico))) = 'N' THEN
                  BEGIN
                     SELECT 'S'
                       INTO cExisteDet
                       FROM DETALLE_POLIZA
                      WHERE IdPoliza   = nIdPoliza
                        AND CodCia     = X.CodCia
                        AND CodEmpresa = X.CodEmpresa
                        AND IDetPol    = 1;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        cExisteDet := 'N';
                  END;
                  IF NVL(cExisteDet,'N') = 'S' THEN
                     RAISE_APPLICATION_ERROR(-20225,'Ya existe un Certificado , NO es Poliza Colectiva: ');
                  ELSE
                     nIDetPol    := OC_DETALLE_POLIZA.INSERTAR_DETALLE(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, nIdPoliza,
                                                                       nTasaCambio, nPorcComis, nCod_Asegurado, cCodPlanPago,
                                                                       TRIM(TO_CHAR(X.NumDetUnico)), cCodPromotor, dFecIniVig);
                  END IF;
               ELSE
                  BEGIN
                     SELECT IDetPol
                       INTO nIDetPol
                       FROM DETALLE_POLIZA
                      WHERE CodCia      = X.CodCia
                        AND CodEmpresa  = X.CodEmpresa
                        AND IdPoliza    = nIdPoliza
                        AND NumDetRef   = TRIM(TO_CHAR(x.NumDetUnico));
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        RAISE_APPLICATION_ERROR(-20225,'DETALLE POLIZA NO EXISTE: '|| TRIM(TO_CHAR(X.NumPolUnico)));
                  END;
               END IF;
               nOrden    := 1;
               nOrdenInc := 0;
               FOR I IN C_CAMPOS('DETALLE_POLIZA', 4) LOOP
                  nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla, X.CodCia, X.CodEmpresa, I.OrdenProceso) + 5 + nOrden;
                  IF UPPER(I.NomCampo) = 'FECINIVIG' THEN
                     IF TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')),'DD-MM-YYYY') NOT BETWEEN dFecIniVig AND dFecFinVig THEN
                        RAISE_APPLICATION_ERROR(-20225,'Fecha de Inicio de Vigencia del Certificado debe estar dentro de la Vigencia de la Póliza');
                     END IF;
                  END IF;
                  IF UPPER(I.NomCampo) = 'FECFINVIG' THEN
                     IF TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')),'DD-MM-YYYY') NOT BETWEEN  dFecIniVig AND  dFecFinVig  THEN
                        RAISE_APPLICATION_ERROR(-20225,'Fecha de Final de Vigencia del Certificado debe estar dentro de la Vigencia de la Póliza ');
                     END IF;
                  END IF;
                  nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;

                  cUpdate := 'UPDATE '||'DETALLE_POLIZA'||' '||'SET'||' '||I.NomCampo||'=';
                  IF I.TipoCampo = 'DATE' THEN
                     cUpdate := cUpdate || ' TO_DATE(' || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||
                                CHR(39) || ','|| CHR(39) || 'DD/MM/RRRR' || CHR(39) || ') ';
                  ELSE
                     cUpdate := cUpdate || '''' ||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||'''';
                  END IF;
                  cUpdate := cUpdate ||' '||'WHERE IdPoliza='||nIdPoliza||' '||'AND IDetPol='||nIDetPol||' '||
                             'AND CodCia='||X.CodCia||' '||'AND CodEmpresa='||X.CodEmpresa;
                  OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate) ;
                  nOrden := nOrden + 1;
               END LOOP;
               nOrden    := 1;
               nOrdenInc := 0;

               FOR I IN C_CAMPOS_PART LOOP
                  BEGIN
                     SELECT 'S'
                       INTO cExisteParEmi
                       FROM DATOS_PART_EMISION
                      WHERE CodCia    = X.CodCia
                        AND IdPoliza  = nIdPoliza
                        AND IDetPol   = nIDetPol;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        cExisteParEmi := 'N';
                  END;
                  IF NVL(cExisteParEmi,'N') = 'N' THEN
                     INSERT INTO DATOS_PART_EMISION
                            (CodCia, Idpoliza, IdetPol, StsDatPart, FecSts)
                     VALUES (X.CodCia, nIdPoliza, nIDetPol, 'SOL', SYSDATE);
                  END IF;
                  nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla, X.CodCia, X.CodEmpresa, I.OrdenProceso) + 5 + nOrden;
                  cUpdate   := 'UPDATE '||'DATOS_PART_EMISION'||' '||'SET'||' '||'CAMPO'||I.OrdenDatoPart||'='||''''||
                               LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc, nOrdenInc,',')||''''||' '||
                               'WHERE IdPoliza='||nIdPoliza||' '||'AND IDetPol='||nIDetPol||' '||'AND CodCia='||X.CodCia);
                  OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate);
                  nOrden := nOrden + 1;
               END LOOP;
               IF OC_COBERT_ACT.EXISTE_COBERTURA(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, nIdPoliza, nIDetPol) = 'N' THEN
                  --OC_COBERT_ACT.CARGAR_COBERTURAS(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, nIdPoliza, nIDetPol, nTasaCambio);
                  OC_COBERT_ACT.CARGAR_COBERTURAS(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob,nIdPoliza,
                                                  nIDetPol, nTasaCambio, NULL, 0, 0, 0, 0, 99, 0, 0, 0, 0, 0, 0);
               END IF;
               nOrden    := 1;
               nOrdenInc := 0;
               FOR I IN C_CAMPOS('COBERT_ACT', 0) LOOP
                   nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
                   cUpdate   := 'UPDATE '||'COBERT_ACT'||' '||'SET'||' '||I.NomCampo||'='||''''||
                                LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')||''''||' '||
                                'WHERE IdPoliza = '||nIdpoliza||' '||
                                'AND IDetPol = '||nIDetPol||' '||'AND CodCia='||X.CodCia||' '||'AND CodEmpresa='||X.CodEmpresa||' '||
                                'AND IdTipoSeg = '||''''||X.IdTipoSeg||'''');
                   OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate) ;
                   nOrden := nOrden + 1;
               END LOOP;

               OC_ASISTENCIAS_DETALLE_POLIZA.CARGAR_ASISTENCIAS(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, nIdPoliza,
                                                                nIDetPol, nTasaCambio, cCodMoneda, dFecIniVig, dFecFinVig);

               nCod_Agente := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,53+5,','));

               IF OC_AGENTES_DETALLES_POLIZAS.EXISTE_AGENTE (X.CodCia, nIdPoliza, nIDetPol, X.IdTipoSeg, nCod_Agente) = 'N' THEN
                  IF nCod_Agente IS NOT NULL THEN
                     IF OC_AGENTES.NIVEL_AGENTE(X.CodCia, nCod_Agente) = 5 THEN
                        cOrigen  := 'U';
                     ELSIF OC_AGENTES.NIVEL_AGENTE(X.CodCia, nCod_Agente) = 4 THEN
                        cOrigen  := 'H';
                     ELSE
                        cOrigen  := 'C';
                     END IF;
                     BEGIN
                        INSERT INTO AGENTE_POLIZA
                               (IdPoliza, CodCia, Cod_Agente, Porc_Comision, Ind_Principal, Origen)
                        VALUES (nIdPoliza, X.CodCia, nCod_Agente, 100, 'S', cOrigen);
                        --OC_AGENTES_DETALLES_POLIZAS.INSERTA_AGENTE(X.CodCia, nIdPoliza, nIDetPol, X.IdTipoSeg, nCod_Agente);
                        IF X.IdTipoSeg != 'ESTVIG' THEN
                           OC_COMISIONES.DISTRIBUCION(X.CodCia, nIdPoliza, nCod_Agente, 100);
                           OC_AGENTES_DISTRIBUCION_POLIZA.COPIAR(X.CodCia, nIdPoliza);
                        END IF;
                     EXCEPTION
                        WHEN DUP_VAL_ON_INDEX THEN
                           IF X.IdTipoSeg != 'ESTVIG' THEN
                              OC_COMISIONES.DISTRIBUCION(X.CodCia, nIdPoliza, nCod_Agente, 100);
                              OC_AGENTES_DISTRIBUCION_POLIZA.COPIAR(X.CodCia, nIdPoliza);
                           END IF;
                        WHEN OTHERS THEN
                           RAISE_APPLICATION_ERROR(-20225,'Error en Distribución de Agentes ' || SQLERRM);
                     END;
                  END IF;
               END IF;
--               OC_POLIZAS.INSERTA_REQUISITOS(X.CodCia, nIdPoliza);     --REQ
               OC_PROCESOS_MASIVOS.INSERTA_BENEFICIARIO(cCodPlantilla, 'BENEFICIARIO', 6, X.RegDatosProc, nIdPoliza, nIDetPol, nCod_Asegurado);
               OC_PROCESOS_MASIVOS.INSERTA_BENEFICIARIO(cCodPlantilla, 'BENEFICIARIO', 7, X.RegDatosProc, nIdPoliza, nIDetPol, nCod_Asegurado);
               OC_PROCESOS_MASIVOS.INSERTA_BENEFICIARIO(cCodPlantilla, 'BENEFICIARIO', 8, X.RegDatosProc, nIdPoliza, nIDetPol, nCod_Asegurado);
               OC_PROCESOS_MASIVOS.INSERTA_BENEFICIARIO(cCodPlantilla, 'BENEFICIARIO', 9, X.RegDatosProc, nIdPoliza, nIDetPol, nCod_Asegurado);

               OC_DETALLE_POLIZA.ACTUALIZA_VALORES(X.CodCia, nIdPoliza, nIDetPol, 0);
               OC_POLIZAS.ACTUALIZA_VALORES(X.CodCia, nIdPoliza, 0);
            ELSE
               cMsjError := 'S';
               RAISE_APPLICATION_ERROR(-20225,'Póliza:'||TRIM(TO_CHAR(X.NumPolUnico)||' Debe estar en Estado SOL'));
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               cMsjError := SQLERRM;
         END;
         IF cMsjError = 'N'   THEN
            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'PROCE');
            IF NVL(X.IndColectiva,'N') = 'N' THEN
               OC_DETALLE_POLIZA.ACTUALIZA_VALORES(X.CodCia, nIdPoliza, nIDetPol, 0);
               OC_POLIZAS.ACTUALIZA_VALORES(X.CodCia, nIdPoliza, 0);
               IF X.IdTipoSeg != 'ESTVIG' THEN
                  OC_POLIZAS.EMITIR_POLIZA(X.CodCia, nIdPoliza, X.CodEmpresa);
               END IF;
            END IF;
         ELSE
            OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','No se puede emitir la Póliza: '||cMsjError);
            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
         END IF;
      ELSE
         OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
      END IF;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','No se puede emitir la Póliza Final: '||SQLERRM);
      OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END EMISION_WEB;

PROCEDURE INSERTA_BENEFICIARIO(cCodPlantilla VARCHAR2, cTabla VARCHAR2, nOrdenProceso NUMBER, cCadena VARCHAR2,
                               nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) IS
cCampos    VARCHAR2(4000);
cLinea     VARCHAR2(4000);
cInsert    VARCHAR2(4000);
csql_ins   VARCHAR2(4000);
c_Sql      VARCHAR2(4000);
cSeparador VARCHAR2(1):= ',';
cCadenaD   VARCHAR2(4000);
cCadenaT   VARCHAR2(4000);
cInserta   VARCHAR2(1);

CURSOR  C_DATOS IS
   SELECT OrdenCampo + 5 Orden, NomCampo, PosIniCampo + 5, ValorDefault,
          LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cCadena,OrdenCampo + 5,',')) Valor, TipoCampo
     FROM CONFIG_PLANTILLAS_CAMPOS
    WHERE PosIniCampo IS  NOT  NULL
      AND NomTabla     = cTabla
      AND OrdenProceso = nOrdenProceso
      AND CodPlantilla = cCodPlantilla
    ORDER BY OrdenCampo;
BEGIN
   cInserta := 'N';
   cCampos  := ' IdPoliza, IDetPol, Cod_Asegurado';
   cCadenaD := CHR(39) || TRIM(TO_CHAR(nIdPoliza))      || CHR(39) || ',' ||
               CHR(39) || TRIM(TO_CHAR(nIDetPol))       || CHR(39) || ',' ||
               CHR(39) || TRIM(TO_CHAR(nCod_Asegurado)) || CHR(39) || ',';
   FOR I IN C_DATOS LOOP
      cCampos := cCampos||','||I.NomCampo;
      IF I.TipoCampo != 'DATE' THEN
         cCadenaD := cCadenaD || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cCadena,I.Orden,',')) || CHR(39) || ',';
      ELSE
         cCadenaD := cCadenaD || 'TO_DATE(' || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cCadena,I.Orden,',')) ||
                     CHR(39) || ',' || CHR(39) || 'DD/MM/YYYY' || CHR(39) || ')' || ',';
      END IF;
      IF LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cCadena,I.Orden,',')) IS NOT NULL THEN
         cInserta := 'S';
      END IF;
   END LOOP;
   IF cInserta = 'S' THEN
      cCadenaD  := SUBSTR(cCadenaD,1,LENGTH(cCadenaD)-1);
      cCampos  := SUBSTR(cCampos,2,LENGTH(cCampos));
      cCadenaD := SUBSTR(cCadenaD,2,LENGTH(cCadenaD));
      cInsert  := 'INSERT INTO '||ctabla||'('||cCampos||') VALUES (';
      cSql_Ins := cInsert;
      c_Sql := cInsert||''''||cCadenaD||')';
      OC_DDL_OBJETOS. EJECUTAR_SQL(c_Sql);
   END IF;
END INSERTA_BENEFICIARIO;

FUNCTION SEPARA_DATOS_VALORCAMPO (cTipoProceso VARCHAR2, cPlanCob VARCHAR2, cIdTipoSeg VARCHAR2, cCodEmpresa VARCHAR2,
                                  cCodCia VARCHAR2, cCampo VARCHAR2, cDatosProc VARCHAR2) RETURN VARCHAR2 IS
cCodPlantilla   CONFIG_PLANTILLAS_TABLAS.CodPlantilla%TYPE;
nCodEmpresa     CONFIG_PLANTILLAS_TABLAS.CodEmpresa%TYPE;
nCodCia         CONFIG_PLANTILLAS_TABLAS.CodCia%TYPE;
nOrden          NUMBER(10) := 1;
cValorCampo     VARCHAR2(200);

CURSOR DATOS_Q IS
   SELECT C.NomCampo, C.TipoCampo, C.PosIniCampo, C.LongitudCampo, C.NumDecimales
     FROM CONFIG_PLANTILLAS_CAMPOS C, CONFIG_PLANTILLAS_TABLAS T, CONFIG_PLANTILLAS_PLANCOB P
    WHERE C.OrdenProceso = T.OrdenProceso
      AND C.CodPlantilla = T.CodPlantilla
      AND C.CodEmpresa   = T.CodEmpresa
      AND C.CodCia       = T.CodCia
      AND T.CodPlantilla = P.CodPlantilla
      AND T.CodEmpresa   = P.CodEmpresa
      AND T.CodCia       = P.CodCia
      AND P.TipoProceso  = cTipoProceso
      AND P.PlanCob      = cPlanCob
      AND P.IdTipoSeg    = cIdtipoSeg
      AND P.CodEmpresa   = cCodEmpresa
      AND P.CodCia       = cCodCia
    ORDER BY T.OrdenProceso,C.OrdenCampo, C.PosIniCampo;
BEGIN
   FOR X IN DATOS_Q LOOP
      EXIT WHEN DATOS_Q%NOTFOUND;
      IF cCampo= X.NomCampo THEN
         cValorCampo:=SUBSTR(cDatosProc, X.PosIniCampo, X.LongitudCampo);
      END IF;
   END LOOP;
   IF LENGTH (LTRIM(RTRIM(cValorCampo)))=0 THEN
      RETURN('Error');
   ELSE
      RETURN(cValorCampo);
   END IF;
END SEPARA_DATOS_VALORCAMPO;

FUNCTION CREAR(cCodCia NUMBER, cCodEmpresa NUMBER) RETURN NUMBER IS
nIdProcMasivo  PROCESOS_MASIVOS.IdProcMasivo%TYPE;
BEGIN
   BEGIN
      SELECT IDPROCMASIVO_SEQ.NEXTVAL
      INTO   nIdProcMasivo
      FROM   DUAL;
      --
      UPDATE GENERALES
         SET UltValor = nIdProcMasivo
       WHERE CodCia   = cCodCia
         AND CodCampo = 'IDPROCMASIVO';
   END;
   RETURN (nIdProcMasivo);
END CREAR;

PROCEDURE INSERT_DINAMICO(cCodPlantilla VARCHAR2, cTabla VARCHAR2, nOrdenProceso NUMBER, cCadena VARCHAR2) IS
cCampos     VARCHAR2(4000);
cLinea      VARCHAR2(4000);
cInsert     VARCHAR2(4000);
csql_ins    VARCHAR2(4000);
c_Sql       VARCHAR2(4000);
cSeparador  VARCHAR2(1):= ',';
cCadenaD    VARCHAR2(4000);
cCadenaT    VARCHAR2(4000);
CURSOR  C_DATOS IS
   SELECT CASE CodPlantilla                                                       -- INICIO INFO MAGO
      WHEN 'UBUNT' THEN OrdenCampo                                                -- SE AGREGA UN CASE PARA CORREGIR EL INSERT DINAMICO
      ELSE OrdenCampo + 5 END  Orden, NomCampo, PosIniCampo, ValorDefault,        -- FIN INFO MAGO
          SUBSTR(cCadena,PosIniCampo, LongitudCampo) Valor, TipoCampo
     FROM CONFIG_PLANTILLAS_CAMPOS
    WHERE PosIniCampo IS NOT NULL
      AND NomTabla     = cTabla
      AND OrdenProceso = nOrdenProceso
      AND CodPlantilla = cCodPlantilla
    ORDER BY OrdenCampo;
BEGIN
     -- OBTENEMOS EL TIPO DE SEPARADOR               -- INICIO INFO MAGO
   SELECT CASE TIPOSEPARADOR
            WHEN 'COM' THEN ','
            WHEN 'PIP' THEN '|'
            ELSE ','
          END
       INTO cSeparador
       FROM CONFIG_PLANTILLAS
   WHERE CodPlantilla = cCodPlantilla;              -- FIN INFO MAGO

   FOR  I IN  C_DATOS LOOP
      cCampos := cCampos||','||I.NomCampo;
      -- cCadenaD := cCadenaD||','||LTRIM(I.valor);
      IF I.TipoCampo != 'DATE' THEN
         cCadenaD := cCadenaD || CHR(39) || UPPER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cCadena,I.Orden,cSeparador))) || CHR(39) || ',';      -- INFO MAGO SE CAMBIA EL ',' POR EL cSeparador
      ELSE
         cCadenaD := cCadenaD || 'TO_DATE(' || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cCadena,I.Orden,cSeparador)) ||               -- INFO MAGO SE CAMBIA EL ',' POR EL cSeparador
                     CHR(39) || ',' || CHR(39) || 'DD/MM/YYYY' || CHR(39) || ')' || ',';
      END IF;
   END LOOP;
   cCadenaD  := SUBSTR(cCadenaD,1,LENGTH(cCadenaD)-1);
   cCampos  := SUBSTR(cCampos,2,LENGTH(cCampos));
   cCadenaD := SUBSTR(cCadenaD,2,LENGTH(cCadenaD));
   cInsert  := 'INSERT INTO '||ctabla||'('||cCampos||') VALUES (';
   cSql_Ins := cInsert;
   c_Sql := cInsert||''''||CAMBIA_ACENTOS(cCadenaD)||')';  -- ACENTO
--   c_Sql := cInsert||''''||cCadenaD||')';                  -- ACENTO
   --c_Sql := cInsert||''''||REPLACE(cCadenaD,cSeparador,''',''')||''''||')';
   OC_DDL_OBJETOS.EJECUTAR_SQL(c_Sql);
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error en el Insert Dinámico'|| SQLERRM);
END INSERT_DINAMICO;

FUNCTION VALOR_CAMPO(cCadena  VARCHAR2, nIndice NUMBER, cDelim VARCHAR2) RETURN VARCHAR2 IS
   nPos_Ini   NUMBER;
   nPos_Fin   NUMBER;
BEGIN
   IF nIndice = 1 THEN
      nPos_Ini := 1;
   ELSE
      nPos_Ini := INSTR(cCadena, cDelim, 1, nIndice - 1);
      IF nPos_Ini = 0 THEN
         RETURN NULL;
      ELSE
         nPos_Ini := nPos_Ini + LENGTH(cDelim);
      END IF;
   END IF;
   nPos_Fin := INSTR(cCadena, cDelim, nPos_Ini, 1);
   IF nPos_Fin = 0 THEN
      RETURN SUBSTR(cCadena, nPos_Ini);
   ELSE
      RETURN SUBSTR(cCadena, nPos_Ini, nPos_Fin - nPos_Ini);
   END IF;
END VALOR_CAMPO;

FUNCTION INSERTA_VALOR_CAMPO(cCadena  VARCHAR2, nIndice NUMBER, cDelim VARCHAR2, cValor VARCHAR2) RETURN VARCHAR2 IS
   nPos_Ini   NUMBER;
   nPos_Fin   NUMBER;
   nLength    NUMBER;
BEGIN
   IF nIndice = 1 THEN
      nPos_Ini := 1;
   ELSE
      nPos_Ini := INSTR(cCadena, cDelim, 1, nIndice - 1);
      IF nPos_Ini = 0 THEN
         nPos_Ini := 1;
      END IF;
   END IF;
   nLength  := LENGTH(cCadena);
   nPos_Fin := INSTR(cCadena, ',', 1, nIndice);
   IF nPos_Fin = 0 THEN
      RETURN SUBSTR(cCadena, nPos_Ini)||cValor;
   ELSE
      RETURN SUBSTR(cCadena, 1, nPos_Ini)||cValor||SUBSTR(cCadena, nPos_Fin, nLength - (nPos_Fin-1));
   END IF;
END INSERTA_VALOR_CAMPO;

FUNCTION VALOR_POSICION(cCodPlantilla VARCHAR2, nCodEmpresa NUMBER, nCodCia NUMBER, cOrdenProceso NUMBER) RETURN NUMBER IS
nCant           NUMBER(10);
BEGIN
   BEGIN
      SELECT COUNT (C.NomCampo)
        INTO nCant
        FROM CONFIG_PLANTILLAS_CAMPOS C
       WHERE C.CodPlantilla = cCodPlantilla
         AND C.CodEmpresa   = nCodEmpresa
         AND C.CodCia       = nCodCia
         AND C.OrdenProceso < cOrdenProceso;
   END;
   RETURN (nCant);
END VALOR_POSICION;

/*FUNCTION INSERTA_ASEG_BENEF(nIdSiniestro NUMBER, nIdPoliza NUMBER, nCod_Asegurado NUMBER,
                            nIdProcMasivo NUMBER, cNumSiniRef VARCHAR2) RETURN NUMBER IS
  nBenef         BENEF_SIN.BENEF%TYPE := 1;
  cNombre        BENEF_SIN.NOMBRE%TYPE;
  cApellPaterno  BENEF_SIN.APELLIDO_PATERNO%TYPE;
  cApellMaterno  BENEF_SIN.APELLIDO_MATERNO%TYPE;
  cSexo          BENEF_SIN.SEXO%TYPE;
  cDireccion     BENEF_SIN.DIRECCION%TYPE;
  cEMail         BENEF_SIN.EMAIL%TYPE;
  cEntidad       BENEF_SIN.ENT_FINANCIERA%TYPE;
  cCuenta        BENEF_SIN.NUMCUENTABANCARIA%TYPE;
  cClabe         BENEF_SIN.CUENTA_CLAVE%TYPE;
  cCodCia        ASEGURADO.CODCIA%TYPE;
  dFecNac        PERSONA_NATURAL_JURIDICA.FECNACIMIENTO%TYPE;
  cTipDocIdentif PERSONA_NATURAL_JURIDICA.TIPO_DOC_IDENTIFICACION%TYPE;
  cNumDocIdentif PERSONA_NATURAL_JURIDICA.NUM_DOC_IDENTIFICACION%TYPE;
BEGIN
  BEGIN
    SELECT TRIM(Nombre) Nombre, TRIM(Apellido_Paterno) ApellPaterno, TRIM(Apellido_Materno) ApellMaterno,
           PN.FecNacimiento, PN.Tipo_Doc_Identificacion, PN.Num_Doc_Identificacion,
           OC_ASEGURADO.SEXO_ASEGURADO(AG.CodCia, AG.CodEmpresa, SI.Cod_Asegurado) Sexo,
           OC_ASEGURADO.DIRECCION_ASEGURADO(AG.CodCia, AG.CodEmpresa, SI.Cod_Asegurado) Direccion,
           PN.EMail, MP.CodEntidadFinan, MP.NumCuentaBancaria, MP.NumCuentaClabe
      INTO cNombre, cApellPaterno, cApellMaterno, dFecNac, cTipDocIdentif, cNumDocIdentif,
           cSexo, cDireccion, cEMail, cEntidad, cCuenta, cClabe
      FROM SINIESTRO SI, ASEGURADO  AG, PERSONA_NATURAL_JURIDICA PN, MEDIOS_DE_PAGO MP
     WHERE SI.IdSiniestro             = nIdSiniestro
       AND SI.IdPoliza                = nIdPoliza
       AND SI.Cod_Asegurado           = nCod_Asegurado
       AND SI.Cod_Asegurado           = AG.cod_asegurado
       AND AG.Tipo_Doc_Identificacion = PN.Tipo_Doc_Identificacion
       AND AG.Num_Doc_Identificacion  = PN.Num_Doc_Identificacion
       AND AG.Tipo_Doc_Identificacion = MP.Tipo_Doc_Identificacion(+)
       AND AG.Num_Doc_Identificacion  = MP.Num_Doc_Identificacion(+);
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al Obtener el Asegurado para Insertar Beneficiario '|| cNumSiniRef || ' ' || SQLERRM);
  END;
  BEGIN
    INSERT INTO BENEF_SIN
          (IdSiniestro, IdPoliza, Cod_Asegurado, Benef, Nombre, PorcePart, CodParent, Estado, Sexo, FecEstado, FecAlta,
           Obervaciones, Direccion, EMAil, Cuenta_Clave, Ent_Financiera, NumCuentaBancaria, IndAplicaISR, PorcentISR,
           FecNac, Tipo_Id_Tributario, Num_Doc_Tributario, Apellido_Paterno, Apellido_Materno)
    VALUES(nIdSiniestro, nIdPoliza, nCod_Asegurado, nBenef, cNombre, 100, '0001', 'ACT', cSexo, TRUNC(SYSDATE), TRUNC(SYSDATE),
           'Pago por el Siniestro No. ' || cNumSiniRef, cDireccion, cEMail, cClabe, cEntidad, cCuenta, 'N', Null,
           dFecNac, cTipDocIdentif, cNumDocIdentif, cApellPaterno, cApellMaterno);
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al Insertar Beneficiario de Pago del Siniestro a partir del Asegurado '|| cNumSiniRef || ' ' || SQLERRM);
  END;
  RETURN (nBenef);
EXCEPTION
   WHEN OTHERS THEN
      OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','No se puede insertar el Beneficiario a partir del Asegurado '||SQLERRM);
      OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END INSERTA_ASEG_BENEF;*/

PROCEDURE EMISION_COLECTIVA(nIdProcMasivo NUMBER) IS
nCodCliente        CLIENTES.CODCLIENTE%TYPE;
cTipoDocIdentAseg  CLIENTES.TIPO_DOC_IDENTIFICACION%TYPE;
cNumDocIdentAseg   CLIENTES.num_doc_identificacion%TYPE;
nCod_Asegurado     ASEGURADO.cod_asegurado%TYPE;
nCodcia            POLIZAS.codcia%TYPE;
nCodempresa        POLIZAS.codempresa%TYPE;
cCodmoneda         POLIZAS.cod_moneda%TYPE;
cPlanCob           PLAN_COBERTURAS.plancob%TYPE;
cExiste            VARCHAR2  (1);
cExisteDet         VARCHAR2  (1);
nIdPoliza          POLIZAS.idpoliza%TYPE;
cIdTipoSeg         tipos_de_seguros.idtiposeg%TYPE;
nPorcComis         POLIZAS.porccomis%TYPE;
cDescpoliza        POLIZAS.descpoliza%TYPE;
nCod_Agente        POLIZAS.Cod_agente%TYPE;
cCodPlanPago       POLIZAS.CodPlanPago%TYPE;
cExisteTipoSeguro  VARCHAR2  (2);
nTasaCambio        DETALLE_POLIZA.tasa_cambio%TYPE;
nIDetPol           DETALLE_POLIZA.idetpol%TYPE;
cIdGrupoTarj       TARJETAS_PREPAGO.IdGrupoTarj%TYPE;
cCodPromotor       DETALLE_POLIZA.CodPromotor%TYPE;
cMsjError          PROCESOS_MASIVOS_LOG.TxtError%TYPE := 'N';
cCodPlantilla      CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE;
cNomTabla          CONFIG_PLANTILLAS_CAMPOS.NomTabla%TYPE;
nOrden             NUMBER(10):= 1  ;
nOrdenInc          NUMBER(10) ;
cUpdate            VARCHAR2(4000);
dFecIniVig         DATE;
dFecFinVig         DATE;
cStsPoliza         POLIZAS.StsPoliza%TYPE;
cExisteParEmi      VARCHAR2(1);

CURSOR C_CAMPOS (cNomTabla VARCHAR2) IS
   SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.TipoCampo
     FROM CONFIG_PLANTILLAS_CAMPOS C
    WHERE C.CodPlantilla = cCodPlantilla
      AND C.CodEmpresa   = nCodEmpresa
      AND C.NomTabla     = cNomTabla
      AND C.CodCia       = nCodCia
    ORDER BY OrdenCampo;

CURSOR C_CAMPOS_PART  IS
   SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.OrdenDatoPart
     FROM CONFIG_PLANTILLAS_CAMPOS C
    WHERE C.CodPlantilla = cCodPlantilla
      AND C.CodEmpresa   = nCodEmpresa
      AND C.CodCia       = nCodCia
      AND C.NomTabla     = 'DATOS_PART_EMISION'
      AND C.IndDatoPart  = 'S'
    ORDER BY OrdenDatoPart,OrdenCampo;

CURSOR EMI_Q IS
   SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
          NumDetUnico, RegDatosProc, TipoProceso,IndColectiva
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;
BEGIN
   FOR X IN EMI_Q LOOP
      nCodcia           :=  X.CodCia;
      nCodempresa       :=  X.CodEmpresa;
      cTipoDocIdentAseg := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,',')) ;
      cNumDocIdentAseg  := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,7,',')) ;
      cCodPlanPago      := OC_TIPOS_DE_SEGUROS.PLAN_PAGOS(X.CodCia, X.CodEmpresa, X.IdTipoSeg);
      cCodPlantilla     := OC_CONFIG_PLANTILLAS_PLANCOB.CODIGO_PLANTILLA(X.CodCia,X.CodEmpresa,X.IdTipoSeg,X.PlanCob,X.TipoProceso);
      IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(cTipoDocIdentAseg, cNumDocIdentAseg) = 'N' THEN
         OC_PROCESOS_MASIVOS.INSERT_DINAMICO(cCodPlantilla, 'PERSONA_NATURAL_JURIDICA', 1, X.RegDatosProc);
       ELSE
         nOrden    := 1;
         nOrdenInc := 0;
         FOR I IN C_CAMPOS('PERSONA_NATURAL_JURIDICA') LOOP
            nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
            IF UPPER(I.NomCampo) = 'FECNACIMIENTO' THEN
               nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
               cUpdate := 'UPDATE '||'PERSONA_NATURAL_JURIDICA'||' '||'SET'||' '||I.NomCampo||'='|| 'TO_DATE(' || CHR(39) ||
                          LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',') || CHR(39) || ','|| CHR(39) ||
                          'DD/MM/RRRR' || CHR(39) || ') ' ||
                          'WHERE Tipo_Doc_Identificacion='||''''||cTipoDocIdentAseg||''''||' '||
                          'AND Num_Doc_Identificacion='||''''||cNumDocIdentAseg||'''');
               OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate) ;
            END IF;
            nOrden := nOrden + 1;
         END LOOP;
      END IF;
      nOrden    := 1;
      nOrdenInc := 0;
      IF OC_PERSONA_NATURAL_JURIDICA.FUNC_VALIDA_EDAD(cTipoDocIdentAseg, cNumDocIdentAseg, X.CodCia, X.CodEmpresa ,X.IdTipoSeg ,X.PlanCob)= 'N' THEN
         RAISE_APPLICATION_ERROR(-20225,'Edad del Asegurado Fuera del Rango de Aceptación de Coberturas');
      END IF;
      BEGIN
         SELECT Cod_Agente
           INTO nCod_Agente
           FROM PLAN_COBERTURAS
          WHERE CodCia     = X.CodCia
            AND CodEmpresa = X.CodEmpresa
            AND IdTipoSeg  = X.IdTipoSeg
            AND PlanCob    = X.PlanCob;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            nCod_Agente := 0;
      END;
      nCodCliente := OC_CLIENTES.CODIGO_CLIENTE(cTipoDocIdentAseg, cNumDocIdentAseg);
      IF nCodCliente = 0  THEN
         nCodCliente    := OC_CLIENTES.INSERTAR_CLIENTE(cTipoDocIdentAseg,cNumDocIdentAseg);
         FOR I IN C_CAMPOS('CLIENTES') LOOP
            nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
            cUpdate := 'UPDATE '||'CLIENTES'||' '||'SET'||' '||I.NomCampo||'=';
            IF I.TipoCampo = 'DATE' THEN
               cUpdate := cUpdate || ' TO_DATE(' || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||
                          CHR(39) || ','|| CHR(39) || 'DD/MM/RRRR' || CHR(39) || ') ';
            ELSE
               cUpdate := cUpdate || '''' ||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||'''';
            END IF;
            cUpdate := cUpdate ||' '||'WHERE CODCLIENTE='||nCodCliente;
            OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate) ;
            nOrden := nOrden + 1;
         END LOOP;
      END IF;
      nCod_Asegurado := OC_ASEGURADO.CODIGO_ASEGURADO(X.CodCia, X.CodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
      IF nCod_Asegurado = 0 THEN
         nCod_Asegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(X.CodCia, X.CodEmpresa,cTipoDocIdentAseg, cNumDocIdentAseg);
      END IF;
      BEGIN
         INSERT INTO CLIENTE_ASEG
               (CodCliente, Cod_Asegurado)
         VALUES(nCodCliente, nCod_Asegurado);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            NULL;
      END;
      BEGIN
         SELECT IdPoliza
           INTO nIdpoliza
           FROM Polizas
          WHERE NumPolUnico = X.NumPolUnico
            AND CodCia      = X.CodCia
            AND CodEmpresa  = X.CodEmpresa
            AND StsPoliza   IN ('SOL','EMI');
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          nIdPoliza := 0;
      END;
      cExiste     := OC_POLIZAS.EXISTE_POLIZA(X.CodCia, X.CodEmpresa, nIdpoliza);
      cDescPoliza := 'Activación Masiva No. ' || TRIM(TO_CHAR(nIdProcMasivo));
      cCodMoneda  := OC_PLAN_COBERTURAS.MONEDA_PLANCOB(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob);
      nPorcComis  := OC_CONFIG_COMISIONES.PORCENTAJE_COMISION(X.CodCia, X.CodEmpresa, X.IdTipoSeg);
      IF cExiste = 'N' AND  NVL(X.IndColectiva,'N') = 'N' THEN
         IF dFecIniVig IS NULL THEN
           dFecIniVig := TRUNC(SYSDATE);
         END IF;
         nIdPoliza   := OC_POLIZAS.INSERTAR_POLIZA(X.CodCia, X.CodEmpresa, cDescPoliza, cCodMoneda, nPorcComis,
                                                   nCodCliente, nCod_Agente, cCodPlanPago, TRIM(TO_CHAR(x.NumPolUnico)),
                                                   cIdGrupoTarj, dFecIniVig);
      END IF;
      nOrden:= 1;
      nOrdenInc := 0;
      IF NVL(X.IndColectiva,'N') = 'N' THEN
         FOR I IN C_CAMPOS('POLIZAS') LOOP
           nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
           cUpdate := 'UPDATE '||'POLIZAS'||' '||'SET'||' '||I.NomCampo||'=';
           IF I.TipoCampo = 'DATE' THEN
              cUpdate := cUpdate || ' TO_DATE(' || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||
                         CHR(39) || ','|| CHR(39) || 'DD/MM/RRRR' || CHR(39) || ') ';
           ELSE
              cUpdate := cUpdate || '''' ||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||'''';
           END IF;
           cUpdate := cUpdate ||' '||'WHERE IdPoliza='||nIdpoliza||' '||
                      'AND CodCia='||X.CodCia||' '||'AND CodEmpresa='||X.CodEmpresa;
           OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate) ;
           nOrden := nOrden + 1;
         END LOOP;
      END IF;
      cExisteTipoSeguro := OC_TIPOS_DE_SEGUROS.EXISTE_TIPO_DE_SEGURO(X.CodCia, X.CodEmpresa, X.IdTipoSeg );
      IF cExisteTipoSeguro = 'S' THEN
         BEGIN
            -- Inserta Tarea de Seguimiento
            IF OC_TAREA.EXISTE_TAREA(X.CodCia,nIdPoliza) = 'N' THEN
               OC_TAREA.INSERTA_TAREA(X.CodCia, 7, 'SOL', 'EMI', nIdPoliza, nCodCliente, 'A','SOL', 'SOLICITUD DE EMISION');
            END IF;
            -- Genera Detalle de Poliza
            nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
            BEGIN
               SELECT FecIniVig ,FecFinVig, StsPoliza
                 INTO dFecIniVig,dFecFinVig,cStsPoliza
                 FROM Polizas
                WHERE IdPoliza   = nIdPoliza
                  AND CodCia     = X.CodCia
                  AND CodEmpresa = X.CodEmpresa ;
            END;
            IF cStsPoliza = 'SOL' THEN
               IF OC_DETALLE_POLIZA.EXISTE_POLIZA_DETALLE(X.CodCia, X.CodEmpresa, nIdPoliza, TRIM(TO_CHAR(x.NumDetUnico))) = 'N' THEN
                  nIDetPol    := OC_DETALLE_POLIZA.INSERTAR_DETALLE(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob,
                                                                    nIdPoliza, nTasaCambio, nPorcComis, nCod_Asegurado,
                                                                    cCodPlanPago, TRIM(TO_CHAR(X.NumDetUnico)), cCodPromotor, dFecIniVig);
               ELSE
                  BEGIN
                     SELECT IDetPol
                       INTO nIDetPol
                       FROM DETALLE_POLIZA
                      WHERE CodCia      = X.CodCia
                        AND CodEmpresa  = X.CodEmpresa
                        AND IdPoliza    = nIdpoliza
                        AND NumDetRef   = TRIM(TO_CHAR(x.NumDetUnico));
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        RAISE_APPLICATION_ERROR(-20225,'DETALLE POLIZA NO EXISTE: '|| TRIM(TO_CHAR(x.numpolunico)));
                  END;
               END IF;
               nOrden    := 1;
               nOrdenInc := 0;
               FOR I IN C_CAMPOS('DETALLE_POLIZA') LOOP
                  nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
                  IF UPPER(I.NomCampo) = 'FECINIVIG' THEN
                     IF TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')),'DD-MM-YYYY') NOT BETWEEN  dFecIniVig AND  dFecFinVig  THEN
                        RAISE_APPLICATION_ERROR(-20225,'Fecha de Inicio de Vigencia del Certificado debe estar dentro dela  Vigencia de la Póliza');
                     END IF;
                  END IF;
                  IF UPPER(I.NomCampo) = 'FECFINVIG' THEN
                     IF TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')),'DD-MM-YYYY') NOT BETWEEN  dFecIniVig AND  dFecFinVig  THEN
                        RAISE_APPLICATION_ERROR(-20225,'Fecha de Final de Vigencia del Certificado debe estar dentro dela  Vigencia de la Póliza ');
                     END IF;
                  END IF;
                  nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
                  cUpdate := 'UPDATE '||'DETALLE_POLIZA'||' '||'SET'||' '||I.NomCampo||'=';
                  IF I.TipoCampo = 'DATE' THEN
                     cUpdate := cUpdate || ' TO_DATE(' || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||
                                CHR(39) || ','|| CHR(39) || 'DD/MM/RRRR' || CHR(39) || ') ';
                  ELSE
                     cUpdate := cUpdate || '''' ||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||'''';
                  END IF;
                  cUpdate := cUpdate ||' '||'WHERE IdPoliza='||nIdPoliza||' '||'AND IDetPol='||nIDetPol||' '||
                            'AND CodCia='||X.CodCia||' '||'AND CodEmpresa='||X.CodEmpresa;
                  OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate) ;
                  nOrden := nOrden + 1;
               END LOOP;
               nOrden    := 1;
               nOrdenInc := 0;
               FOR I IN C_CAMPOS_PART LOOP
                  BEGIN
                     SELECT 'S'
                       INTO cExisteParEmi
                       FROM DATOS_PART_EMISION
                      WHERE CodCia    = X.CodCia
                        AND Idpoliza  = nIdPoliza
                        AND IdetPol   = nIDetPol;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        cExisteParEmi := 'N';
                  END;
                  IF NVL(cExisteParEmi,'N') = 'N' THEN
                     INSERT INTO DATOS_PART_EMISION
                            (CodCia, Idpoliza, IdetPol, StsDatPart, FecSts)
                     VALUES (X.CodCia, nIdPoliza, nIDetPol, 'SOL', TRUNC(SYSDATE));
                  END IF;
                  nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
                  cUpdate   := 'UPDATE '||'DATOS_PART_EMISION'||' '||'SET'||' '||'CAMPO'||I.OrdenDatoPart||'='||''''||
                               LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')||''''||' '||
                               'WHERE IdPoliza = '||nIdpoliza||' '|| 'AND IDetPol = '||nIDetPol||' '||'AND CodCia = '||X.CodCia);
                  OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate);
                  nOrden := nOrden + 1;
               END LOOP;
               IF OC_COBERT_ACT.EXISTE_COBERTURA(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob,nIdPoliza, nIDetPol) = 'N' THEN
                 --OC_COBERT_ACT.CARGAR_COBERTURAS(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob,nIdPoliza, nIDetPol, nTasaCambio);
                 OC_COBERT_ACT.CARGAR_COBERTURAS(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob,nIdPoliza,
                                                 nIDetPol, nTasaCambio, NULL, 0, 0, 0, 0, 99, 0, 0, 0, 0, 0, 0);
               END IF;

               IF OC_AGENTES_DETALLES_POLIZAS.EXISTE_AGENTE (X.CodCia, nIdPoliza, nIDetPol, X.IdTipoSeg, nCod_Agente) = 'N' THEN
                  IF nCod_Agente IS NOT NULL THEN
                     OC_AGENTES_DETALLES_POLIZAS.INSERTA_AGENTE(X.CodCia, nIdPoliza, nIDetPol, X.IdTipoSeg, nCod_Agente);
                  END IF;
               END IF;
--               OC_POLIZAS.INSERTA_REQUISITOS(X.CodCia, nIdPoliza);     --REQ
               OC_POLIZAS.ACTUALIZA_VALORES(X.CodCia, nIdPoliza, 0);
               OC_DETALLE_POLIZA.ACTUALIZA_VALORES(X.CodCia, nIdPoliza, nIDetPol, 0);
            ELSE
               cMsjError := 'S';
               RAISE_APPLICATION_ERROR(-20225,'Poliza:'||TRIM(TO_CHAR(X.NumPolUnico)||' Debe estar en Estado SOL'));
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               cMsjError := SQLERRM;
         END;
         IF cMsjError = 'N'   THEN
             OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'PROCE');
             IF NVL(X.IndColectiva,'N')= 'N' THEN
                OC_POLIZAS.EMITIR_POLIZA(X.CodCia, nIdPoliza, X.CodEmpresa);
             END IF;
         ELSE
             OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','No se puede emitir la Póliza: '||cMsjError);
             OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
         END IF;
      ELSE
         OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
      END IF;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','No se puede emitir la Póliza Final: '||SQLERRM);
      OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END EMISION_COLECTIVA;

PROCEDURE CANCELACION(nIdProcMasivo NUMBER) IS
nIdPoliza     POLIZAS.IdPoliza%TYPE;
dFecinivig    POLIZAS.FecIniVig%TYPE;
dFecfinvig    POLIZAS.FecFinVig%TYPE;
vTipopol      POLIZAS.TipoPol%TYPE;
nCodcia       POLIZAS.CodCia%TYPE;
nCodempresa   POLIZAS.CodEmpresa%TYPE;
cCod_Moneda   POLIZAS.Cod_Moneda%TYPE;
nIDetPol      NUMBER;
dFecAnul      POLIZAS.FecAnul%TYPE;
cContinuar    VARCHAR2(2):= 'S';
cMotivAnul    VARCHAR2(200);

CURSOR CANC_Q IS
   SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob,TipoProceso,
          NumPolUnico, NumDetUnico, RegDatosProc
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;

CURSOR  DET_POLIZA is
   SELECT  IdPoliza,IdetPol
     FROM  DETALLE_POLIZA
    WHERE  Idpoliza   = nIdPoliza
      AND  stsdetalle = 'EMI';
BEGIN
   FOR X IN CANC_Q LOOP
      dFecAnul    := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,',')) ;
      cMotivAnul  := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,7,',')) ;
      IF OC_GENERALES.FUN_DESCRIP_LVAL('MOTIVANU',cMotivAnul)!= 'VALOR NO VALIDO' THEN
         BEGIN
            SELECT IdPoliza,FecIniVig,FecFinVig,TipoPol,CodCia,CodEmpresa,Cod_Moneda
              INTO nIdPoliza,dFecinivig,dFecfinvig,vTipopol,nCodCia,nCodEmpresa,cCod_Moneda
              FROM POLIZAS
             WHERE NumPolUnico = X.NumPolUnico
               AND StsPoliza   = 'EMI'
               AND CodCia      = X.CodCia
               AND CodEmpresa  = X.CodEmpresa;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cContinuar:='N';
         END;

         IF dFecAnul >= dFecinivig AND dFecAnul <= dFecfinvig THEN
            OC_procesos_masivos_log.Inserta_LOG(nIdProcMasivo,'CANCELACION','20225','Fecha dentro de la Vigencia de la Póliza');
         ELSE
            cContinuar:='N';
         END IF;

         BEGIN
            SELECT COUNT(idetpol)
              INTO nIDetPol
              FROM DETALLE_POLIZA
             WHERE IdPoliza   = nIdPoliza
               AND StsDetalle = 'EMI'
             GROUP BY IdPoliza;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cContinuar := 'N';
         END;
         IF NVL(cContinuar,'N') != 'N' THEN
            OC_POLIZAS.ANULAR_POLIZA(nCodCia, nCodEmpresa , nIdPoliza , dFecAnul , cMotivAnul , 'N', cCod_Moneda );
            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'PROCE');
         ELSE
            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
         END IF;
      ELSE
         OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'CANCELACION','20225','Motivo de Anulación NO Existe en CatÃ¡logo MOTIVANU');
         OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
      END IF;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'CANCELACION','20225','No se puede Anular la Póliza'||SQLERRM);
      OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END CANCELACION;

PROCEDURE COBRANZA(nIdProcMasivo NUMBER) IS
cStsFact        FACTURAS.StsFact%TYPE := '';
nMontoPago      FACTURAS.Monto_Fact_Local%TYPE := 0;
nIdFactura      FACTURAS.IdFactura%TYPE := 0;
cFormPago       FACTURAS.FormPago%TYPE := '';
cNumReciboPago  FACTURAS.ReciboPago%TYPE := '';
dFecPago        FACTURAS.FecPago%TYPE;
cContinuar      VARCHAR2 (2):= 'S';
cMontoPago      VARCHAR2(20);
nNumCuota       FACTURAS.NumCuota%TYPE;
cEntPago        FACTURAS.EntPago%TYPE;
CURSOR Cobranza_Q IS
    SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, TipoProceso,
          NumPolUnico, NumDetUnico, RegDatosProc
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;
BEGIN
   FOR X IN COBRANZA_Q LOOP
      nNumCuota      := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,','));
      cFormPago      := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,7,','));
      cNumReciboPago := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,8,','));
      dFecPago       := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,9,','));
      cEntPago       := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,10,','));
      nMontoPago     := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,11,',')),'999999.999999') ;
      IF X.NumPolUnico != X.NumDetUnico THEN
          RAISE_APPLICATION_ERROR(-20100,'Numero de Poliza no Coincide con el Numero de Certificado');
      END IF;
      IF nNumCuota IS NULL THEN
         RAISE_APPLICATION_ERROR(-20100,'Debe Ingresar No. de Cuota a Cobrar');
      ELSIF nMontoPago IS NULL THEN
         RAISE_APPLICATION_ERROR(-20100,'El monto de Pago NO puede ser NULO');
      ELSIF dFecPago IS NULL THEN
         RAISE_APPLICATION_ERROR(-20100,'Fecha de Pago NO Puede  ser NULO');
      ELSIF dFecPago > TRUNC(SYSDATE) THEN
         RAISE_APPLICATION_ERROR(-20100,'Fecha de Pago NO Puede ser Mayor a la Fecha del Sistema');
      END IF;
      BEGIN
         SELECT F.StsFact, F.IdFactura
           INTO cStsFact, nIdFactura
           FROM FACTURAS F
          WHERE EXISTS (SELECT 1
                          FROM POLIZAS P
                         WHERE P.CodCia             = X.CodCia
                           AND P.CodEmpresa         = X.CodEmpresa
                           AND P.IdPoliza           = F.IdPoliza
                           AND NVL(P.IndPolCol,'N') = 'N'
                           AND P.NumPolUnico        = X.NumPolUnico)
            AND F.NumCuota = nNumCuota
            AND StsFact IN ('EMI','ABO');
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
            cContinuar:='N';
      END;
      IF OC_GENERALES.FUN_DESCRIP_LVAL('FORMPAGO',cFormPago)!= 'VALOR NO VALIDO' AND cContinuar = 'S' THEN
         OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
         IF cStsFact IN ('EMI','ABO') THEN
            NULL;
            -- Comentado Temporalmente porque ahora Necesita el IdTransaccion
            /*IF OC_FACTURAS.PAGAR(nIdFactura, cFormPago  ,cNumReciboPago , dFecPago ,nMontoPago,cFormPago,cEntPago )= 1 THEN
               OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'PROCE');
            ELSIF OC_FACTURAS.PAGAR(nIdFactura, cFormPago  ,cNumReciboPago , dFecPago ,nMontoPago,cFormPago,cEntPago )= 2 THEN
               OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'COBRANZA','20225','Factura No Existe');
               OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
            ELSIF OC_FACTURAS.PAGAR(nIdFactura, cFormPago  ,cNumReciboPago , dFecPago ,nMontoPago,cFormPago,cEntPago )=0 THEN
               OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'COBRANZA','20225','ERROR al pagar o abonar Factura');
               OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
            END IF;*/
         END IF;
      ELSE
         OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'COBRANZA','20225','Cuota  No.'||nNumCuota||' '|| 'NO Disponible para Cobro.');
         OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
      END IF;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      OC_procesos_masivos_log.Inserta_log(nIdProcMasivo,'COBRANZA','20225','No se puede realizar la Cobranza de la Factura: '||nIdFactura||SQLERRM);
      OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END COBRANZA;

PROCEDURE VENTA_TARJETA(nIdProcMasivo NUMBER)IS
cTipoTarjeta     TARJETAS_PREPAGO.TipoTarjeta%TYPE;
nNumTarjeta      TARJETAS_PREPAGO.NumTarjeta%TYPE;
cCodPromotor     TARJETAS_PREPAGO.CodPromotor%TYPE;
cNumDepBancario  TARJETAS_PREPAGO.NumDepBancario%TYPE;
dFecVenta        TARJETAS_PREPAGO.FecVenta%TYPE;
nMontoPago       PRIMAS_DEPOSITO.Monto_Local%TYPE;
cIndVender       VARCHAR2 (1) := 'N';
cCodMoneda       COBERTURAS_DE_SEGUROS.Cod_Moneda%TYPE;
cNumReciboPago   FACTURAS.ReciboPago%TYPE;
nCodCliente      CLIENTES.CodCliente%TYPE;
dFecPago         TARJETAS_PREPAGO.FecVenta%TYPE;
cStsTarjeta      TARJETAS_PREPAGO.StsTarjeta%TYPE;
nNumFolioVenta   TARJETAS_PREPAGO.NumFolioVenta%TYPE;
CURSOR C_TARJETA IS
    SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, TipoProceso,
          NumPolUnico, NumDetUnico, RegDatosProc
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;
BEGIN
   BEGIN
      FOR X IN C_TARJETA LOOP
         cTipoTarjeta     := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,',')) ;
         nNumTarjeta      := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,7,',')) ;
         cCodPromotor     := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,8,',')) ;
         cNumDepBancario  := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,9,',')) ;
         dFecVenta        := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,10,',')) ;
         dFecPago         := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,11,',')) ;
         nMontoPago       := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,12,',')),'999,999,999,999.99') ;
         cNumReciboPago   := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,13,',')) ;
         IF nNumTarjeta != X.NumPolUnico OR X.NumPolUnico != X.NumDetUnico OR  nNumTarjeta != X.NumDetUnico THEN
            RAISE_APPLICATION_ERROR(-20100,'Numero de Poliza no Coincide con la Tarjeta o con el Numero de Certificado');
         END IF;
         IF cCodPromotor IS NOT NULL THEN
            IF OC_PROMOTORES.EXISTE_PROMOTOR(X.CodCia ,cCodPromotor ) = 'N' THEN
               RAISE_APPLICATION_ERROR(-20100,'Promotor NO Existe');
            END IF;
         END IF;
         BEGIN
            SELECT 'S', StsTarjeta, NumFolioVenta, CodPromotor
              INTO cIndVender, cStsTarjeta, nNumFolioVenta, cCodPromotor
              FROM TARJETAS_PREPAGO
             WHERE IdTipoSeg   = X.IdTipoSeg
               AND CodEmpresa  = X.CodEmpresa
               AND CodCia      = X.CodCia
               AND PlanCob     = X.PlanCob
               AND TipoTarjeta = cTipoTarjeta
               AND NumTarjeta  = nNumTarjeta
               AND StsTarjeta != 'CANP';
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cIndVender := 'N';
         END;
         IF cCodPromotor IS NULL THEN
            cCodPromotor  := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,8,',')) ;
         END IF ;
         IF dFecVenta IS NULL THEN
            RAISE_APPLICATION_ERROR(-20100,'Debe Ingresar la Fecha de Venta de la Tarjeta');
         ELSIF dFecVenta > TRUNC(SYSDATE) THEN
            RAISE_APPLICATION_ERROR(-20100,'Fecha de Venta de la Tarjeta NO Puede ser Mayor a la Fecha del Sistema');
         ELSIF dFecPago IS NULL THEN
            RAISE_APPLICATION_ERROR(-20100,'Debe Ingresar la Fecha de Pago de la Tarjeta');
         ELSIF dFecPago < dFecVenta THEN
           RAISE_APPLICATION_ERROR(-20100,'Fecha de Pago de la Tarjeta NO Puede Ser Menor a la Fecha de Venta');
         ELSIF cNumDepBancario IS NULL THEN
           RAISE_APPLICATION_ERROR(-20100,'Debe Ingresar el No. de Boleta del Depósito Bancario');
         ELSIF NVL(nMontoPago,0) = 0 THEN
           RAISE_APPLICATION_ERROR(-20100,'Debe Ingresar el Monto de la Boleta del Depósito Bancario');
         ELSIF   cStsTarjeta = 'VEND' THEN
            RAISE_APPLICATION_ERROR(-20100,'Tarjeta Ya ha sido Vendida y NO Activada '||nNumTarjeta);
         ELSIF   cStsTarjeta = 'ACTP' THEN
           RAISE_APPLICATION_ERROR(-20100,'Tarjeta Ya ha sido Vendida y Activada '||nNumTarjeta);
         ELSIF
            cIndVender = 'S' AND cNumReciboPago IS NULL THEN
            RAISE_APPLICATION_ERROR(-20100,'NO Ingreso el No. de Recibo de Pago para las Tarjetas Emitidas.  No se RegistrarÃ¡ en los Pagos');
         END IF;
         BEGIN
            SELECT DISTINCT Cod_Moneda
              INTO cCodMoneda
              FROM COBERTURAS_DE_SEGUROS
             WHERE CodCia      = X.CodCia
               AND CodEmpresa  = X.CodEmpresa
               AND IdTipoSeg   = X.IdTipoSeg
               AND PlanCob     = X.PlanCob;
         END;
         IF cIndVender = 'S'  AND cStsTarjeta IN ('PEND', 'ACTR', 'ASIG') AND nNumFolioVenta IS NULL  THEN
            IF cStsTarjeta = 'PEND' AND  OC_TARJETAS_PREPAGO.POSEE_PROMOTOR(X.CodCia, X.CodEmpresa,X.IdTipoSeg,
                                                                            X.PlanCob, cTipoTarjeta, nNumTarjeta) = 'N' THEN
               OC_TARJETAS_PREPAGO.ASIGNA_PROMOTOR(X.CodCia, X.CodEmpresa, X.IdTipoSeg,X.PlanCob, cTipoTarjeta, nNumTarjeta,cCodPromotor);
            END IF;
            OC_TARJETAS_PREPAGO.VENTA_TARJETA(X.CodCia, X.CodEmpresa, X.IdTipoSeg,X.PlanCob, cTipoTarjeta, nNumTarjeta, cCodPromotor, dFecVenta);
            BEGIN
               SELECT NVL(CodCliente,0)
                 INTO nCodCliente
                 FROM EMPRESAS
                WHERE CodCia = X.CodCia;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-20100,'NO Existe Empresa Asignada a la Tarjeta '||TO_CHAR(X.CodCia));
            END;
            IF nCodCliente != 0 THEN
               OC_TARJETAS_PREPAGO.PAGO_TARJETA(X.CodCia, X.CodEmpresa, X.IdTipoSeg,X.PlanCob, cTipoTarjeta, nNumTarjeta, cCodPromotor,
                                                dFecVenta, nCodCliente, nMontoPago, cCodMoneda, cNumDepBancario, cNumReciboPago);
               OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'PROCE');
            ELSE
               RAISE_APPLICATION_ERROR(-20100,'Debe Asignar un No. de Cliente a la Empresa Asignada a la Tarjeta '||TO_CHAR(X.CodCia));
            END IF;
         ELSE
            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
            OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'VENTA','20225','No se puede realizar la Venta de Tarjeta, Favor verificar Estado de Tarjeta '||
                                                nNumTarjeta||' '||SQLERRM);
         END IF;
      END LOOP;
   EXCEPTION
      WHEN OTHERS THEN
         OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'VENTA','20225','No se puede realizar la Venta de Tarjeta '||nNumTarjeta||' '||SQLERRM);
         OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
   END;
END VENTA_TARJETA;

PROCEDURE EMISION_TARJETA(nIdProcMasivo NUMBER) IS
nCodcia                    POLIZAS.CodCia%TYPE;
nCodempresa                POLIZAS.CodEmpresa%TYPE;
cTipoDocIdentAseg          CLIENTES.Tipo_Doc_Identificacion%TYPE;
cNumDocIdentAseg           CLIENTES.Num_Doc_Identificacion%TYPE;
cCodPlantilla              CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE;
cTipoTarjeta               TARJETAS_PREPAGO.TipoTarjeta%TYPE;
nNumTarjeta                TARJETAS_PREPAGO.NumTarjeta%TYPE;
cCodPromotor               TARJETAS_PREPAGO.CodPromotor%TYPE;
cIndVender                 VARCHAR2 (1) := 'N';
cCodMoneda                 COBERTURAS_DE_SEGUROS.Cod_Moneda%TYPE;
cNumReciboPago             FACTURAS.ReciboPago%TYPE;
cNomTabla                  CONFIG_PLANTILLAS_CAMPOS.NomTabla%TYPE := 'TARJETAS_PREPAGO';
nOrden                     NUMBER(10):= 1  ;
nOrdenInc                  NUMBER(10) ;
nOrdenProceso              CONFIG_PLANTILLAS_CAMPOS.OrdenProceso%TYPE;
cIdGrupoTarj               TARJETAS_PREPAGO.IdGrupoTarj%TYPE;
cStsTarjeta                TARJETAS_PREPAGO.StsTarjeta%TYPE;
dFecIniVig                 DATE;
dFecVenta                  DATE;
nIdPrimaDeposito           PRIMAS_DEPOSITO.IdPrimaDeposito%TYPE;
cUpdate                    VARCHAR2(4000);
cNumero_Recibo_Referencia  PRIMAS_DEPOSITO.Numero_Recibo_Referencia%TYPE;

CURSOR EMI_Q IS
   SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
          NumDetUnico, RegDatosProc, TipoProceso,IndColectiva
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;

CURSOR C_CAMPOS (cNomTabla VARCHAR2) IS
   SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.TipoCampo
     FROM CONFIG_PLANTILLAS_CAMPOS C
    WHERE C.CodPlantilla = cCodPlantilla
      AND C.CodEmpresa   = nCodEmpresa
      AND C.NomTabla     = cNomTabla
      AND C.CodCia       = nCodCia
    ORDER BY OrdenCampo;
BEGIN
   FOR X IN EMI_Q LOOP
      BEGIN
         nCodcia           :=  X.CodCia;
         nCodempresa       :=  X.CodEmpresa;
         cTipoDocIdentAseg := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,',')) ;
         cNumDocIdentAseg  := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,7,',')) ;
         cCodPlantilla     := OC_CONFIG_PLANTILLAS_PLANCOB.CODIGO_PLANTILLA(X.CodCia,X.CodEmpresa,X.IdTipoSeg,X.PlanCob,X.TipoProceso);
         IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(cTipoDocIdentAseg, cNumDocIdentAseg) = 'N' THEN
            OC_PROCESOS_MASIVOS.INSERT_DINAMICO(cCodPlantilla, 'PERSONA_NATURAL_JURIDICA', 1, X.RegDatosProc);
         ELSE
            nOrden    := 1;
            nOrdenInc := 0;
            FOR I IN C_CAMPOS('PERSONA_NATURAL_JURIDICA') LOOP
               nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
               IF UPPER(I.NomCampo) = 'FECNACIMIENTO' THEN
                  nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
                  cUpdate := 'UPDATE '||'PERSONA_NATURAL_JURIDICA'||' '||'SET'||' '||I.NomCampo||'='|| 'TO_DATE(' || CHR(39) ||
                             LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',') || CHR(39) || ','|| CHR(39) ||
                             'DD/MM/RRRR' || CHR(39) || ') ' ||
                             'WHERE Tipo_Doc_Identificacion='||''''||cTipoDocIdentAseg||''''||' '||
                             'AND Num_Doc_Identificacion='||''''||cNumDocIdentAseg||'''');
                  OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate) ;
               END IF;
               nOrden := nOrden + 1;
            END LOOP;
         END IF;
         nOrden    := 1;
         nOrdenInc := 0;
         IF OC_PERSONA_NATURAL_JURIDICA.FUNC_VALIDA_EDAD(cTipoDocIdentAseg, cNumDocIdentAseg, X.CodCia, X.CodEmpresa ,X.IdTipoSeg ,X.PlanCob)= 'N' THEN
            RAISE_APPLICATION_ERROR(-20225,'Edad del Asegurado Fuera del Rango de Aceptación de Coberturas');
         END IF;
         BEGIN
            SELECT DISTINCT C.OrdenProceso
              INTO nOrdenProceso
              FROM CONFIG_PLANTILLAS_CAMPOS C
             WHERE C.CodPlantilla = cCodPlantilla
               AND C.CodEmpresa   = X.CodEmpresa
               AND C.NomTabla     = 'TARJETAS_PREPAGO'
               AND C.CodCia       = X.CodCia;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20100,'Debe Ingresar Configuración de Plantilla para la tabla TARJETAS_PREPAGO');
         END;
         nOrdenInc     := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,nOrdenProceso) + 5 + nOrden;
         cTipoTarjeta  := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ;
         nNumTarjeta   := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc + 1,',')) ;
         dFecIniVig    := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc + 3,',')) ;
         IF nNumTarjeta != X.NumPolUnico OR X.NumPolUnico != X.NumDetUnico OR  nNumTarjeta != X.NumDetUnico THEN
           RAISE_APPLICATION_ERROR(-20100,'Número de Póliza no Coincide con la Tarjeta o con el Número de Certificado');
         END IF;
         IF  dFecIniVig IS NULL THEN
            RAISE_APPLICATION_ERROR(-20100,'Debe Ingresar la Fecha de Inicio de la Tarjeta');
         ELSIF OC_PLAN_COBERTURAS.VALIDA_DIAS_RETROACTIVOS(nCodCia, nCodEmpresa, X.IdTipoSeg, X.PlanCob,dFecIniVig )  = 'N' THEN
            RAISE_APPLICATION_ERROR(-20100,'La Fecha de Inicio de Vigencia NO esta dentro de los dÃ­as Retroactivos Configurados');
         ELSIF dFecIniVig > TRUNC(SYSDATE) THEN
            RAISE_APPLICATION_ERROR(-20100,'La Fecha de Inicio de Vigencia NO ser Mayor a la Fecha del Sistema');
         END IF;
         BEGIN
            SELECT CodPromotor,IdGrupoTarj,StsTarjeta, FecVenta
              INTO cCodPromotor,cIdGrupoTarj,cStsTarjeta,dFecVenta
              FROM TARJETAS_PREPAGO
             WHERE IdTipoSeg   = X.IdTipoSeg
               AND CodEmpresa  = X.CodEmpresa
               AND CodCia      = X.CodCia
               AND PlanCob     = X.PlanCob
               AND TipoTarjeta = cTipoTarjeta
               AND NumTarjeta  = nNumTarjeta
               AND StsTarjeta != 'CANP';
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20100,'No Existe Tarjeta No:'||' '||nNumTarjeta||'  '||'Para Emitir Póliza');
         END;
         IF dFecVenta IS NOT NULL THEN
            IF dFecIniVig < dFecVenta THEN
               RAISE_APPLICATION_ERROR(-20100,'La Fecha de Inicio de Vigencia NO puede ser menor a la Fecha de Venta del Folio');
            END IF;
         END IF;

         IF cStsTarjeta = 'PEND' AND  OC_TARJETAS_PREPAGO.POSEE_PROMOTOR(X.CodCia, X.CodEmpresa,X.IdTipoSeg,
                                                                         X.PlanCob, cTipoTarjeta, nNumTarjeta) = 'N' THEN
            cCodPromotor  := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc + 2,',')) ;
            IF cCodPromotor IS NOT NULL THEN
               IF OC_PROMOTORES.EXISTE_PROMOTOR(X.CodCia, cCodPromotor) = 'N' THEN
                  RAISE_APPLICATION_ERROR(-20100,'Promotor NO Existe');
               END IF;
            END IF;
            IF cCodPromotor IS NULL THEN
               RAISE_APPLICATION_ERROR(-20100,' Tarjeta No:'||' '||nNumTarjeta||'  '||'Debe Ingresar Promotor para Asignar');
            ELSE
               OC_TARJETAS_PREPAGO.ASIGNA_PROMOTOR(X.CodCia, X.CodEmpresa, X.IdTipoSeg,X.PlanCob, cTipoTarjeta, nNumTarjeta,cCodPromotor);
            END IF;
         END IF;
         IF OC_TARJETAS_PREPAGO_ACTIV.EXISTE(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, cTipoTarjeta,
                                             nNumTarjeta, cTipoDocIdentAseg, cNumDocIdentAseg) = 'N' THEN
            OC_TARJETAS_PREPAGO_ACTIV.INSERTA(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, cTipoTarjeta,
                                              nNumTarjeta, cTipoDocIdentAseg, cNumDocIdentAseg);
         END IF;
         IF cStsTarjeta != 'ACTR' THEN
            OC_TARJETAS_PREPAGO.ACTIVACION_TARJETA(X.CodCia, X.CodEmpresa,X.IdTipoSeg, X.PlanCob, cTipoTarjeta,
                                                   nNumTarjeta, cCodPromotor, USER, SYSDATE);
         END IF;
         nIdPrimaDeposito := OC_TARJETAS_PREPAGO.NUMERO_PRIMA_DEPOSITO(nCodCia, nCodEmpresa, X.IdTipoSeg, X.PlanCob,
                                                                       cTipoTarjeta, nNumTarjeta, cCodPromotor);
         IF NVL(nIdPrimaDeposito,0) != 0 THEN
            BEGIN
               SELECT Numero_Recibo_Referencia
                 INTO cNumero_Recibo_Referencia
                 FROM PRIMAS_DEPOSITO
                WHERE IdPrimaDeposito = nIdPrimaDeposito;
            END;
         END IF;
         OC_TARJETAS_PREPAGO.EMISION_POLIZA_TARJETA(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, cTipoTarjeta, nNumTarjeta,cCodPromotor, cNumero_Recibo_Referencia, cIdGrupoTarj,dFecIniVig);
         OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'PROCE');
      EXCEPTION
         WHEN OTHERS THEN
            OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'EMITAR','20225','No se puede realizar la Emisión de Tarjeta No. '||nNumTarjeta||' '||SQLERRM);
            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
      END;
   END LOOP;
END EMISION_TARJETA;

PROCEDURE INSERTA_PROCESO_MASIVO_PROC(nIdProcMasivo NUMBER) IS
BEGIN
   BEGIN
      INSERT INTO PROCESOS_MASIVOS_PROC
            (IdProcMasivo, CodCia, CodEmpresa, IdTipoSeg, PlanCob, TipoProceso, StsRegProceso,
             FecSts, RegDatosProc, NumPolUnico, NumDetUnico, IndColectiva, CodUsuario)
      SELECT IdProcMasivo, CodCia, CodEmpresa, IdTipoSeg, PlanCob, TipoProceso, 'PROCE',
             SYSDATE, RegDatosProc, NumPolUnico, NumDetUnico, IndColectiva, CodUsuario
        FROM PROCESOS_MASIVOS
       WHERE IdProcMasivo = nIdProcMasivo;
   EXCEPTION
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error en Traslado de registro a Tabla PROCESOS_MASIVOS_PROC'||SQLERRM);
   END;
END INSERTA_PROCESO_MASIVO_PROC;

PROCEDURE EMISION_COLECTIVA_ASEGURADO( cNomArchivoCarga  PROCESOS_MASIVOS.NomArchivoCarga%TYPE
                                     , cModificaSexo     VARCHAR2 ) IS
   nCodCliente         CLIENTES.CodCliente%TYPE;
   cTipoDocIdentAseg   CLIENTES.Tipo_Doc_Identificacion%TYPE;
   cNumDocIdentAseg    CLIENTES.Num_Doc_Identificacion%TYPE;
   nCod_Asegurado      ASEGURADO.Cod_Asegurado%TYPE;
   nCodcia             POLIZAS.CodCia%TYPE;
   nCodempresa         POLIZAS.CodEmpresa%TYPE;
   cCodmoneda          POLIZAS.Cod_Moneda%TYPE;
   cPlanCob            PLAN_COBERTURAS.PlanCob%TYPE;
   cExiste             VARCHAR2(1);
   cExisteDet          VARCHAR2(1);
   nIdPoliza           POLIZAS.IdPoliza%TYPE;
   cIdTipoSeg          TIPOS_DE_SEGUROS.IdTipoSeg%TYPE;
   nPorcComis          POLIZAS.PorcComis%TYPE;
   cDescpoliza         POLIZAS.DescPoliza%TYPE;
   nCod_Agente         POLIZAS.Cod_Agente%TYPE;
   cCodPlanPago        POLIZAS.CodPlanPago%TYPE;
   cExisteTipoSeguro   VARCHAR2  (2);
   nTasaCambio         DETALLE_POLIZA.Tasa_Cambio%TYPE;
   nIDetPol            DETALLE_POLIZA.IdetPol%TYPE;
   cIdGrupoTarj        TARJETAS_PREPAGO.IdGrupoTarj%TYPE;
   cCodPromotor        DETALLE_POLIZA.CodPromotor%TYPE;
   cMsjError           PROCESOS_MASIVOS_LOG.TxtError%TYPE := 'N';
   cCodPlantilla       CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE;
   cNomTabla           CONFIG_PLANTILLAS_CAMPOS.NomTabla%TYPE;
   nOrden              NUMBER(10):= 1  ;
   nOrdenInc           NUMBER(10) ;
   cUpdate             VARCHAR2(4000);
   dFecIniVig          DATE;
   dFecFinVig          DATE;
   cStsPoliza          POLIZAS.StsPoliza%TYPE;
   cExisteParEmi       VARCHAR2(1);
   cExisteAsegCert     VARCHAR2(1);
   cIndSinAseg         VARCHAR2(1);
   cCampo              CONFIG_PLANTILLAS_CAMPOS.NomCampo%TYPE;
   nSuma               COBERT_ACT_ASEG.SumaAseg_Local%TYPE;
   nIdEndoso           ENDOSOS.IdEndoso%TYPE;
   cStsDetalle         DETALLE_POLIZA.StsDetalle%TYPE;
   nIdSolicitud        SOLICITUD_EMISION.IdSolicitud%TYPE;
   --
   nSumaAsegurada      COBERT_ACT_ASEG.SumaAseg_Local%TYPE;
   nIdCotizacion       COTIZACIONES.IdCotizacion%TYPE;
   nIDetCotizacion     COTIZACIONES_DETALLE.IDetCotizacion%TYPE;
   --
   cIndEdadPromedio    COTIZACIONES_DETALLE.IndEdadPromedio%TYPE;
   cIndCuotaPromedio   COTIZACIONES_DETALLE.IndCuotaPromedio%TYPE;
   cIndPrimaPromedio   COTIZACIONES_DETALLE.IndPrimaPromedio%TYPE;
   --
   nPorcExtraPrimaDet  POLIZAS.PorcExtraPrima%TYPE  := 0;
   nMontoExtraPrimaDet POLIZAS.MontoExtraPrima%TYPE := 0;
   --
   --Variables para Tunning
   nCodCiaDep          CONFIG_PLANTILLAS_PLANCOB.CodCia%TYPE;
   nCodEmpresaDep      CONFIG_PLANTILLAS_PLANCOB.CodEmpresa%TYPE;
   cIdTipoSegDep       CONFIG_PLANTILLAS_PLANCOB.IdTipoSeg%TYPE;
   cPlanCobDep         CONFIG_PLANTILLAS_PLANCOB.PlanCob%TYPE;
   cTipoProcesoDep     CONFIG_PLANTILLAS_PLANCOB.TipoProceso%TYPE;
   nIdPolizaDep        POLIZAS.IdPoliza%TYPE;
   nSalarioMensual     COBERT_ACT_ASEG.SalarioMensual%TYPE;
   nVecesSalario       COBERT_ACT_ASEG.VecesSalario%TYPE;
   nSumaAseguradaOk    COBERT_ACT_ASEG.SumaAseg_Local%TYPE;
   nSalarioMensualOk   COBERT_ACT_ASEG.SalarioMensual%TYPE;
   nVecesSalarioOk     COBERT_ACT_ASEG.VecesSalario%TYPE;
   nIdProcMasivo       PROCESOS_MASIVOS.IdProcMasivo%TYPE;
   cExisteCobert       VARCHAR2(1) := 'N';
   --
   CURSOR C_CAMPOS (cNomTabla VARCHAR2) IS
          SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.TipoCampo
          FROM   CONFIG_PLANTILLAS_CAMPOS C
          WHERE  C.CodPlantilla = cCodPlantilla
            AND  C.CodEmpresa   = nCodEmpresa
            AND  C.NomTabla     = cNomTabla
            AND  C.CodCia       = nCodCia
          ORDER BY OrdenCampo;
   --
   CURSOR C_CAMPOS_PART  IS
          SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.OrdenDatoPart
          FROM   CONFIG_PLANTILLAS_CAMPOS C
          WHERE  C.CodPlantilla = cCodPlantilla
            AND  C.CodEmpresa   = nCodEmpresa
            AND  C.CodCia       = nCodCia
            AND  C.NomTabla     = 'DATOS_PART_EMISION'
            AND  C.IndDatoPart  = 'S'
          ORDER BY OrdenDatoPart, OrdenCampo;
   --
   CURSOR C_CAMPOS_ASEG  IS
          SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.OrdenDatoPart
          FROM   CONFIG_PLANTILLAS_CAMPOS C
          WHERE  C.CodPlantilla = cCodPlantilla
            AND  C.CodEmpresa   = nCodEmpresa
            AND  C.CodCia       = nCodCia
            AND  C.NomTabla     = 'ASEGURADO_CERTIFICADO'
            AND  C.IndAseg  = 'S'
          ORDER BY OrdenDatoPart, OrdenCampo;
   --
   CURSOR EMI_Q IS
          SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico, NumDetUnico, RegDatosProc, TipoProceso, IndColectiva, IndAsegurado, IdProcMasivo
          FROM   PROCESOS_MASIVOS
          WHERE  NomArchivoCarga      = cNomArchivoCarga
            AND  NVL(IdProcesar, 'N') = 'S'
          ORDER BY IdProcMasivo;
   --
   CURSOR c_coberturas ( c_CodCia       CARGA_COBERTURAS_MASIVA.CodCia%TYPE
                       , c_CodEmpresa   CARGA_COBERTURAS_MASIVA.CodEmpresa%TYPE
                       , c_IdTipoSeg    CARGA_COBERTURAS_MASIVA.IdTipoSeg%TYPE
                       , c_PlanCob      CARGA_COBERTURAS_MASIVA.PlanCob%TYPE
                       , c_NumPolUnico  CARGA_COBERTURAS_MASIVA.NumPolUnico%TYPE
                       , c_IdetPol      CARGA_COBERTURAS_MASIVA.IDetPol%TYPE ) IS
          SELECT A.NumPolUnico                    , A.CodCobert                                  , A.SalarioMensual                       , A.VecesSalario                         ,
                 A.SumaAsegManual                 , NVL(A.SumaAsegIngresada, 0) SumaAsegIngresada, NVL(B.SumaAsegMinima, 0) SumaAsegMinima, NVL(B.SumaAsegMaxima, 0) SumaAsegMaxima,
                 NVL(B.Edad_Minima, 0) Edad_Minima, NVL(B.Edad_Maxima      , 0) Edad_Maxima      , NVL(B.Edad_Exclusion, 0) Edad_Exclusion, A.PrimaPromedio
          FROM   CARGA_COBERTURAS_MASIVA  A
             ,   COBERTURAS_DE_SEGUROS    B
          WHERE  B.CodCia       = A.CodCia
            AND  B.CodEmpresa   = A.CodEmpresa
            AND  B.IdTipoSeg    = A.IdTipoSeg
            AND  B.PlanCob      = A.PlanCob
            AND  B.CodCobert    = A.CodCobert
            AND  B.StsCobertura = 'ACT'
            AND  A.CodCia       = c_CodCia
            AND  A.CodEmpresa   = c_CodEmpresa
            AND  A.IdTipoSeg    = c_IdTipoSeg
            AND  A.PlanCob      = c_PlanCob
            AND  A.NumPolUnico  = c_NumPolUnico
            AND  A.IdetPol      = c_IDetPol
          ORDER BY B.OrdenImpresion, B.CodCobert;
BEGIN
   FOR X IN EMI_Q LOOP
       nIdProcMasivo     := x.IdProcMasivo;
       nCodcia           := X.CodCia;
       nCodempresa       := X.CodEmpresa;
       cTipoDocIdentAseg := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,',')) ;
       cNumDocIdentAseg  := UPPER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,7,',')));
       --
--aqui control de misma informacion
       IF NVL(nCodCiaDep, 0) <> x.CodCia AND NVL(nCodEmpresaDep, 0) <> x.CodEmpresa AND NVL(cIdTipoSegDep, 'X') <> x.IdTipoSeg THEN
          nCodCiaDep        := x.CodCia;
          nCodEmpresaDep    := x.CodEmpresa;
          cIdTipoSegDep     := x.IdTipoSeg;
          cPlanCobDep       := x.PlanCob;
          cTipoProcesoDep   := x.TipoProceso;
          --
          cCodPlanPago      := OC_TIPOS_DE_SEGUROS.PLAN_PAGOS(X.CodCia, X.CodEmpresa, X.IdTipoSeg);
          nPorcComis        := OC_CONFIG_COMISIONES.PORCENTAJE_COMISION(X.CodCia, X.CodEmpresa, X.IdTipoSeg);
          cExisteTipoSeguro := OC_TIPOS_DE_SEGUROS.EXISTE_TIPO_DE_SEGURO(X.CodCia, X.CodEmpresa, X.IdTipoSeg);
          --
          cCodMoneda        := OC_PLAN_COBERTURAS.MONEDA_PLANCOB(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob);
          cCodPlantilla     := OC_CONFIG_PLANTILLAS_PLANCOB.CODIGO_PLANTILLA(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, X.TipoProceso);
          --
          BEGIN
             SELECT Cod_Agente
             INTO   nCod_Agente
             FROM   PLAN_COBERTURAS
             WHERE  CodCia     = X.CodCia
               AND  CodEmpresa = X.CodEmpresa
               AND  IdTipoSeg  = X.IdTipoSeg
               AND  PlanCob    = X.PlanCob;
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
               nCod_Agente := 0;
          END;
       ELSE
          IF cPlanCobDep <> x.PlanCob THEN
             cPlanCobDep := x.PlanCob;
             cCodMoneda  := OC_PLAN_COBERTURAS.MONEDA_PLANCOB(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob);
             --
             BEGIN
                SELECT Cod_Agente
                INTO   nCod_Agente
                FROM   PLAN_COBERTURAS
                WHERE  CodCia     = X.CodCia
                  AND  CodEmpresa = X.CodEmpresa
                  AND  IdTipoSeg  = X.IdTipoSeg
                  AND  PlanCob    = X.PlanCob;
             EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  nCod_Agente := 0;
             END;
             --
             IF cTipoProcesoDep <> x.TipoProceso THEN
                cTipoProcesoDep := x.TipoProceso;
                cCodPlantilla   := OC_CONFIG_PLANTILLAS_PLANCOB.CODIGO_PLANTILLA(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, X.TipoProceso);
             END IF;
          ELSE
             IF cTipoProcesoDep <> x.TipoProceso THEN
                cTipoProcesoDep := x.TipoProceso;
                cCodPlantilla   := OC_CONFIG_PLANTILLAS_PLANCOB.CODIGO_PLANTILLA(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, X.TipoProceso);
             END IF;
          END IF;
       END IF;
       --
       IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(cTipoDocIdentAseg, cNumDocIdentAseg) = 'N' THEN
          OC_PROCESOS_MASIVOS.INSERT_DINAMICO(cCodPlantilla, 'PERSONA_NATURAL_JURIDICA', 1, X.RegDatosProc);
       ELSE
          nOrden    := 1;
          nOrdenInc := 0;
--aqui modificar UPDATE
          cUpdate   := 'UPDATE PERSONA_NATURAL_JURIDICA SET ';
          FOR I IN C_CAMPOS('PERSONA_NATURAL_JURIDICA') LOOP
              nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION(cCodPlantilla, X.CodCia, X.CodEmpresa, I.OrdenProceso) + 5 + nOrden;
              IF UPPER(I.NomCampo) = 'FECNACIMIENTO' THEN
                 cUpdate := cUpdate || I.NomCampo || ' = TO_DATE(' || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc, nOrdenInc, ',')) || CHR(39) || ',' || CHR(39) ||
                              'DD/MM/RRRR' || CHR(39) || '),';
              ELSIF UPPER(I.NomCampo) = 'SEXO' THEN
                 cUpdate := cUpdate || I.NomCampo || ' = ' || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc, nOrdenInc, ',')) || CHR(39) || ',';
              END IF;
              nOrden := nOrden + 1;
          END LOOP;
          cUpdate := SUBSTR(cUpdate, 1, LENGTH(cUpdate) - 1) || ' WHERE Tipo_Doc_Identificacion = ' || CHR(39) || cTipoDocIdentAseg || CHR(39) || ' AND Num_Doc_Identificacion = ' || CHR(39) || cNumDocIdentAseg || CHR(39);
          OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate);
       END IF;
       nOrden    := 1;
       nOrdenInc := 0;
       IF OC_PERSONA_NATURAL_JURIDICA.FUNC_VALIDA_EDAD(cTipoDocIdentAseg, cNumDocIdentAseg, X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob)= 'N' THEN
          RAISE_APPLICATION_ERROR(-20225,'Edad del Asegurado Fuera del Rango de Aceptación de Coberturas');
       END IF;
       --
       nCodCliente := OC_CLIENTES.CODIGO_CLIENTE(cTipoDocIdentAseg, cNumDocIdentAseg);
       IF nCodCliente = 0  THEN
          nCodCliente := OC_CLIENTES.INSERTAR_CLIENTE(cTipoDocIdentAseg, cNumDocIdentAseg);
--aqui modificar UPDATE
          cUpdate := 'UPDATE CLIENTES SET ';
          FOR I IN C_CAMPOS('CLIENTES') LOOP
              nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla, X.CodCia, X.CodEmpresa, I.OrdenProceso) + 5 + nOrden;
              cUpdate   := cUpdate || I.NomCampo || ' = ';
              IF I.TipoCampo = 'DATE' THEN
                 cUpdate := cUpdate || ' TO_DATE(' || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc, nOrdenInc, ',')) ||
                            CHR(39) || ',' || CHR(39) || 'DD/MM/RRRR' || CHR(39) || '),';
              ELSE
                 cUpdate := cUpdate || CHR(39) ||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc, nOrdenInc, ',')) || CHR(39) || ',';
              END IF;
              nOrden := nOrden + 1;
          END LOOP;
          cUpdate := SUBSTR(cUpdate, 1, LENGTH(cUpdate) - 1) || ' WHERE CODCLIENTE = ' || nCodCliente;
          OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate) ;
       END IF;
       --
       nCod_Asegurado := OC_ASEGURADO.CODIGO_ASEGURADO(X.CodCia, X.CodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
       IF nCod_Asegurado = 0 THEN
          nCod_Asegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(X.CodCia, X.CodEmpresa,cTipoDocIdentAseg, cNumDocIdentAseg);
       END IF;
       --
       BEGIN
          INSERT INTO CLIENTE_ASEG ( CodCliente, Cod_Asegurado )
          VALUES ( nCodCliente, nCod_Asegurado );
       EXCEPTION
       WHEN DUP_VAL_ON_INDEX THEN
            NULL;
       END;
       --
       BEGIN
          SELECT IdPoliza, StsPoliza
          INTO   nIdpoliza, cStsPoliza
          FROM   POLIZAS
          WHERE  NumPolUnico     = X.NumPolUnico
            AND  CodCia          = X.CodCia
            AND  CodEmpresa      = X.CodEmpresa
            AND  StsPoliza  NOT IN ('ANU','REN');
       EXCEPTION
       WHEN NO_DATA_FOUND THEN
            nIdPoliza := 0;
       END;
       --
       cExiste     := OC_POLIZAS.EXISTE_POLIZA(X.CodCia, X.CodEmpresa, nIdpoliza);
       cDescPoliza := 'Activación Masiva No. ' || TRIM(TO_CHAR(nIdProcMasivo));
       --
       IF cExiste = 'N' AND  NVL(X.IndColectiva,'N') = 'N' THEN
          IF dFecIniVig IS NULL THEN
             dFecIniVig := TRUNC(SYSDATE);
          END IF;
          nIdPoliza := OC_POLIZAS.INSERTAR_POLIZA(X.CodCia, X.CodEmpresa, cDescPoliza, cCodMoneda, nPorcComis, nCodCliente, nCod_Agente, cCodPlanPago, TRIM(TO_CHAR(X.NumPolUnico)), cIdGrupoTarj, dFecIniVig);
       END IF;
       --
       nIdSolicitud := OC_SOLICITUD_EMISION.SOLICITUD_POLIZA(X.CodCia, X.CodEmpresa, nIdPoliza);
       nOrden       := 1;
       nOrdenInc    := 0;
       IF NVL(X.IndColectiva,'N') = 'N' THEN
--aqui modificar UPDATE
          cUpdate := 'UPDATE POLIZAS SET ';
          FOR I IN C_CAMPOS('POLIZAS') LOOP
              nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla , X.CodCia, X.CodEmpresa, I.OrdenProceso) + 5 + nOrden;
              cUpdate := cUpdate || I.NomCampo || ' = ';
              IF I.TipoCampo = 'DATE' THEN
                 cUpdate := cUpdate || ' TO_DATE(' || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc, nOrdenInc, ',')) ||
                            CHR(39) || ','|| CHR(39) || 'DD/MM/RRRR' || CHR(39) || '),';
              ELSE
                 cUpdate := cUpdate || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc, nOrdenInc, ',')) || CHR(39) || ',';
              END IF;
              nOrden := nOrden + 1;
          END LOOP;
          cUpdate := SUBSTR(cUpdate, 1, LENGTH(cUpdate) - 1) || ' WHERE IdPoliza = ' || nIdpoliza || ' AND CodCia = ' || X.CodCia || ' AND CodEmpresa = ' || X.CodEmpresa;
          OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate);
       END IF;
       --
       IF cExisteTipoSeguro = 'S' THEN
          BEGIN
             -- Inserta Tarea de Seguimiento
             IF OC_TAREA.EXISTE_TAREA(X.CodCia, nIdPoliza) = 'N' THEN
                OC_TAREA.INSERTA_TAREA(X.CodCia, 7, 'SOL', 'EMI', nIdPoliza, nCodCliente, 'A', 'SOL', 'SOLICITUD DE EMISION');
             END IF;
             -- Genera Detalle de Poliza
             nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
             --
--aqui control de misma informacion
             IF NVL(nIdPolizaDep, 0) <> nIdPoliza THEN
                nIdPolizaDep := nIdPoliza;
                BEGIN
                   SELECT FecIniVig , FecFinVig , StsPoliza , Num_Cotizacion, NVL(PorcExtraPrima, 0), NVL(MontoExtraPrima, 0)
                   INTO   dFecIniVig, dFecFinVig, cStsPoliza, nIdCotizacion , nPorcExtraPrimaDet    , nMontoExtraPrimaDet
                   FROM   POLIZAS
                   WHERE  IdPoliza   = nIdPoliza
                     AND  CodCia     = X.CodCia
                     AND  CodEmpresa = X.CodEmpresa ;
                END;
             END IF;
             --
             BEGIN
                SELECT IDetPol , IndSinAseg , StsDetalle , CodPlanPago
                INTO   nIDetPol, cIndSinAseg, cStsDetalle, cCodPlanPago
                FROM   DETALLE_POLIZA
                WHERE  CodCia     = X.CodCia
                  AND  CodEmpresa = X.CodEmpresa
                  AND  IdPoliza   = nIdpoliza
                  AND  NumDetRef  = TRIM(TO_CHAR(X.NumDetUnico))
                  AND  IdTipoSeg  = X.IdTipoSeg
                  AND  PlanCob    = X.PlanCob;
             EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-20225,'DETALLE POLIZA NO EXISTE: ' || TRIM(TO_CHAR(X.NumDetUnico)) || ' Con el Producto ' || X.IdTipoSeg || ' y el Plan de Coberturas ' || X.PlanCob);
             END;
             nOrden    := 1;
             nOrdenInc := 0;
             --
             FOR I IN C_CAMPOS('DETALLE_POLIZA') LOOP
                 nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla, X.CodCia, X.CodEmpresa, I.OrdenProceso) + 5 + nOrden;
                 IF UPPER(I.NomCampo) = 'FECINIVIG' THEN
                    IF TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc, nOrdenInc, ',')), 'DD/MM/YYYY') NOT BETWEEN dFecIniVig AND dFecFinVig THEN
                       RAISE_APPLICATION_ERROR(-20225, 'Fecha de Inicio de Vigencia del Certificado debe estar dentro de la Vigencia de la Póliza');
                    END IF;
                 END IF;
                 IF UPPER(I.NomCampo) = 'FECFINVIG' THEN
                    IF TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc, nOrdenInc, ',')), 'DD/MM/YYYY') NOT BETWEEN dFecIniVig AND dFecFinVig THEN
                       RAISE_APPLICATION_ERROR(-20225, 'Fecha de Final de Vigencia del Certificado debe estar dentro de la Vigencia de la Póliza ');
                    END IF;
                 END IF;
                 /*    nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
                 cUpdate := 'UPDATE '||'DETALLE_POLIZA'||' '||'SET'||' '||I.NomCampo||'=';
                 IF I.TipoCampo = 'DATE' THEN
                    cUpdate := cUpdate || ' TO_DATE(' || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||
                               CHR(39) || ','|| CHR(39) || 'DD/MM/RRRR' || CHR(39) || ') ';
                 ELSE
                    cUpdate := cUpdate || '''' ||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||'''';
                 END IF;
                 cUpdate := cUpdate ||' '||'WHERE IdPoliza='||nIdPoliza||' '||'AND IDetPol='||nIDetPol||' '||
                            'AND CodCia='||X.CodCia||' '||'AND CodEmpresa='||X.CodEmpresa;
                 OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate) ;*/
                 nOrden := nOrden + 1;
             END LOOP;
             --
             nOrden    := 1;
             nOrdenInc := 0;
             IF NVL(X.IndAsegurado,'N') = 'S' THEN
                nOrden    := 1;
                nOrdenInc := 0;
                nIdEndoso := 0;
                IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(X.CodCia, nIdpoliza, nIDetPol, nCod_Asegurado) = 'N' THEN
                   IF cStsPoliza = 'SOL' OR cStsDetalle = 'SOL' THEN
                      OC_ASEGURADO_CERTIFICADO.INSERTA(X.CodCia, nIdpoliza, nIDetPol, nCod_Asegurado, 0);
                   ELSE
                      SELECT NVL(MAX(IdEndoso), 0)
                      INTO   nIdEndoso
                      FROM   ENDOSOS
                      WHERE  CodCia    = X.CodCia
                        AND  IdPoliza  = nIdPoliza
                        AND  StsEndoso = 'SOL';
                      --
                      IF NVL(nIdEndoso,0) = 0 THEN
                         nIdEndoso := OC_ENDOSO.CREAR(nIdPoliza);
                         OC_ENDOSO.INSERTA (X.CodCia, X.CodEmpresa, nIdPoliza, nIDetPol, nIdEndoso, 'ESV', 'ENDO-' || TRIM(TO_CHAR(nIdPoliza)) || '-' || TRIM(TO_CHAR(nIdEndoso)),
                                            dFecIniVig, dFecFinVig, cCodPlanPago, 0, 0, 0, '010', NULL);
                      END IF;
                      OC_ASEGURADO_CERTIFICADO.INSERTA(X.CodCia, nIdpoliza, nIDetPol, nCod_Asegurado, nIdEndoso);
                   END IF;
                ELSE
                   RAISE_APPLICATION_ERROR(-20225, 'Asegurado No. : ' || nCod_Asegurado || ' Duplicado en Certificado No. ' || nIDetPol);
                END IF;
                --
--aqui modificar UPDATE
                cUpdate := 'UPDATE ASEGURADO_CERTIFICADO SET ';
                FOR I IN C_CAMPOS_ASEG LOOP  --numero de veces
                    nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla, X.CodCia, X.CodEmpresa, I.OrdenProceso) + 5 + nOrden;
                    cUpdate   := cUpdate || ' CAMPO' || I.OrdenDatoPart || ' = ' || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc, nOrdenInc, ',') || CHR(39) || ',');
                    nOrden    := nOrden + 1;
                END LOOP;
                cUpdate := SUBSTR(cUpdate, 1, LENGTH(cUpdate) - 1) || ' WHERE IdPoliza = ' || nIdPoliza || ' AND IDetPol = ' || nIDetPol || ' AND CodCia = ' || X.CodCia || ' AND Cod_Asegurado = ' || nCod_Asegurado;
                OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate);
                --
--aqui meter la extraccion de salario y nveces
                nSumaAsegurada  := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc, 24, ',')));
                nSalarioMensual := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc, 25, ',')));
                nVecesSalario   := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc, 27, ',')));
                nIDetCotizacion := nIDetPol;
                BEGIN
                   SELECT NVL(D.IndEdadPromedio,'N'), NVL(D.IndCuotaPromedio,'N'), NVL(D.IndPrimaPromedio,'N')
                   INTO   cIndEdadPromedio          , cIndCuotaPromedio          , cIndPrimaPromedio
                   FROM   COTIZACIONES C, COTIZACIONES_DETALLE D
                   WHERE  C.CodCia         = nCodCia
                     AND  C.CodEmpresa     = nCodEmpresa
                     AND  D.IdCotizacion   = nIdCotizacion
                     AND  D.IDetCotizacion = nIDetCotizacion
                     AND  C.CodCia         = D.CodCia
                     AND  C.CodEmpresa     = D.CodEmpresa
                     AND  C.IdCotizacion   = D.IdCotizacion;
                     --AND C.IDetCotizacion = D.IDetCotizacion;
                EXCEPTION
                WHEN NO_DATA_FOUND THEN
                     cIndEdadPromedio  := 'N';
                     cIndCuotaPromedio := 'N';
                     cIndPrimaPromedio := 'N';
                END;
                /* Se quita temporalmente la carga de coberturas para agilizar el proceso de Emisión y solo se deja para Endosos*/
                --IF NVL(nIdEndoso,0) != 0 THEN
                IF cIndEdadPromedio = 'N' AND cIndCuotaPromedio = 'N' AND cIndPrimaPromedio = 'N' THEN
                   IF OC_COBERT_ACT_ASEG.EXISTE_COBERTURA(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, nIdPoliza, nIDetPol, nCod_Asegurado) = 'N' THEN
                      IF NVL(cIndSinAseg,'N') = 'N' THEN
                         IF NVL(nIdSolicitud,0) = 0 THEN
                            --OC_COBERT_ACT_ASEG.CARGAR_COBERTURAS(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, nIdPoliza, nIDetPol, nTasaCambio, nCod_Asegurado);
                            IF NVL(nIdCotizacion,0) = 0 THEN
                               FOR z in c_coberturas ( x.CodCia, x.CodEmpresa, x.IdTipoSeg, x.PlanCob, x.NumPolUnico, nIdetPol ) LOOP
                                   --Regla de Suma Asegurada
                                   IF NVL(nSumaAsegurada, 0) > 0 THEN
                                      nSumaAseguradaOk := NVL(nSumaAsegurada, 0);
                                   ELSE
                                      nSumaAseguradaOk := NVL(nSalarioMensual, 0) * NVL(nVecesSalario, 0);
                                   END IF;
                                   --
                                   nSalarioMensualOk := NVL(nSalarioMensual, 0);
                                   nVecesSalarioOk   := NVL(nVecesSalario, 0);
                                   --
                                   IF nSumaAseguradaOk <= 0 THEN
                                      IF NVL(z.SumaAsegManual, 0) > 0 THEN
                                         nSumaAseguradaOk := NVL(z.SumaAsegManual, 0);
                                      ELSE
                                         nSumaAseguradaOk := NVL(z.SalarioMensual, 0) * NVL(z.VecesSalario, 0);
                                      END IF;
                                      --
                                      nSalarioMensualOk := NVL(z.SalarioMensual, 0);
                                      nVecesSalarioOk   := NVL(z.VecesSalario, 0);
                                   END IF;
                                   --
                                   IF nSumaAseguradaOk <= 0 THEN
                                      OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo, 'AUTOMATICO', '20225', 'No se pueden Cargar las Coberturas, no tiene suma asegurada la cobertura: ' || z.CodCobert);
                                      OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'ERROR');
                                   END IF;
                                   --
                                   OC_COBERT_ACT_ASEG.CARGAR_COBERTURAS( x.CodCia         , x.CodEmpresa    , x.IdTipoSeg       , x.PlanCob          , nIdPoliza       ,
                                                                         nIDetPol         , nTasaCambio     , nCod_Asegurado    , z.CodCobert        , nSumaAseguradaOk,
                                                                         nSalarioMensualOk, nVecesSalarioOk , z.Edad_Minima     , z.Edad_Maxima      , z.Edad_Exclusion,
                                                                         z.SumaAsegMinima , z.SumaAsegMaxima, nPorcExtraPrimaDet, nMontoExtraPrimaDet, z.SumaAsegManual );
                                   --
                                   IF NVL(z.PrimaPromedio, 0) > 0 THEN
                                      BEGIN
                                         SELECT 'S'
                                         INTO   cExisteCobert
                                         FROM   COBERT_ACT_ASEG
                                         WHERE  CodEmpresa    = x.CodEmpresa
                                           AND  CodCia        = x.CodCia
                                           AND  idpoliza      = nIdPoliza
                                           AND  IDetPol       = nIDetPol
                                           AND  IdTipoSeg     = x.IdTipoSeg
                                           AND  Cod_Asegurado = nCod_Asegurado
                                           AND  CodCobert     = z.CodCobert
                                           AND  PlanCob       = x.PlanCob;
                                      EXCEPTION
                                      WHEN NO_DATA_FOUND THEN
                                           cExisteCobert := 'N';
                                      WHEN TOO_MANY_ROWS THEN
                                           cExisteCobert := 'S';
                                      END;
                                      --
                                      IF cExisteCobert = 'S' THEN
                                         UPDATE COBERT_ACT_ASEG
                                         SET    Prima_Local  = z.PrimaPromedio
                                           ,    Prima_Moneda = z.PrimaPromedio
                                         WHERE  CodEmpresa    = x.CodEmpresa
                                           AND  CodCia        = x.CodCia
                                           AND  idpoliza      = nIdPoliza
                                           AND  IDetPol       = nIDetPol
                                           AND  IdTipoSeg     = x.IdTipoSeg
                                           AND  Cod_Asegurado = nCod_Asegurado
                                           AND  CodCobert     = z.CodCobert
                                           AND  PlanCob       = x.PlanCob;
                                      END IF;
                                   END IF;
                               END LOOP;
                               --OC_COBERT_ACT_ASEG.CARGAR_COBERTURAS(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob,nIdPoliza,
                               --                                 nIDetPol, nTasaCambio, nCod_Asegurado, NULL, 0, 0, 0, 0, 99, 0, 0, 0, 0, 0, 0);
                            ELSE
                               GT_COTIZACIONES_COBERT_MASTER.CREAR_COBERTURAS_POLIZA(X.CodCia, X.CodEmpresa, nIdCotizacion, nIDetCotizacion, nIdPoliza, nIDetPol, nCod_Asegurado, 'S', nSumaAsegurada);
                            END IF;
                         ELSE
                            OC_SOLICITUD_COBERTURAS.TRASLADA_COBERTURAS(X.CodCia, X.CodEmpresa, nIdSolicitud, nIdPoliza, nIDetPol, nCod_Asegurado);
                            OC_SOLICITUD_ASISTENCIAS.TRASLADA_ASISTENCIAS(X.CodCia, X.CodEmpresa, nIdSolicitud, nIdPoliza, nIDetPol, nCod_Asegurado);
                         END IF;
                      ELSE
                         BEGIN
                            SELECT 'CAMPO' || ORDENCAMPO CAMPO
                            INTO   cCampo
                            FROM   CONFIG_PLANTILLAS_CAMPOS
                            WHERE  CodCia        = X.CodCia
                              AND  CodEmpresa    = X.CodEmpresa
                              AND  CodPlantilla  = cCodPlantilla
                              AND  NomCampo   LIKE '%MONTO%CREDITO%'
                              AND  IndAseg       = 'S';
                         EXCEPTION
                         WHEN NO_DATA_FOUND THEN
                              RAISE_APPLICATION_ERROR(-20225, 'NO EXISTE CAMPO MONTO CREDITO EN PLANTILLA: ' || cCodPlantilla);
                         WHEN TOO_MANY_ROWS THEN
                              RAISE_APPLICATION_ERROR(-20225, 'EXISTE MAS DE UN CAMPO MONTO CREDITO EN PLANTILLA: ' || cCodPlantilla);
                         END;
                         nSuma := OC_ASEGURADO_CERTIFICADO.SUMA_ASEGURADO(nCodCia, nIdPoliza, nIdetPol, nCod_Asegurado, cCampo);
                         OC_COBERT_ACT_ASEG.CARGAR_COBERTURAS_SIN_TARIFA(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, nIdPoliza, nIDetPol, nTasaCambio, nCod_Asegurado, nSuma);
                      END IF;
                      IF NVL(nIdEndoso,0) != 0 THEN
                         UPDATE COBERT_ACT_ASEG
                         SET    IdEndoso = nIdEndoso
                         WHERE  CodCia        = X.CodCia
                           AND  IdPoliza      = nIdPoliza
                           AND  IDetPol       = nIDetPol
                           AND  Cod_Asegurado = nCod_Asegurado;
                      END IF;
                      OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(X.CodCia, X.CodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado);
                   END IF;
                ELSIF NVL(nIdCotizacion,0) != 0  AND (cIndEdadPromedio = 'S' OR cIndCuotaPromedio = 'S' OR cIndPrimaPromedio = 'S') THEN
                   --IF NVL(nIdCotizacion,0) != 0 THEN
                   GT_TEMP_LISTADO_DECLARACIONES.GENERA_COBERTURAS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso, nCod_Asegurado,
                                                                   nIdCotizacion, nIDetCotizacion, X.PlanCob, X.IdTipoSeg, cCodMoneda,
                                                                   nSumaAsegurada);
                   --END IF;
                END IF;
             END IF;
             --
             IF OC_AGENTES_DETALLES_POLIZAS.EXISTE_AGENTE(X.CodCia, nIdPoliza, nIDetPol, X.IdTipoSeg, nCod_Agente) = 'N' THEN
                IF nCod_Agente IS NOT NULL THEN
                   OC_AGENTES_DETALLES_POLIZAS.INSERTA_AGENTE(X.CodCia, nIdPoliza, nIDetPol, X.IdTipoSeg, nCod_Agente);
                END IF;
             END IF;
             --OC_POLIZAS.INSERTA_REQUISITOS(X.CodCia, nIdPoliza);     --REQ
             IF NVL(cIndSinAseg,'N') = 'N' OR NVL(nIdEndoso,0) = 0 THEN
                OC_POLIZAS.ACTUALIZA_VALORES(X.CodCia, nIdPoliza, 0);
                OC_DETALLE_POLIZA.ACTUALIZA_VALORES(X.CodCia, nIdPoliza, nIDetPol, 0);
             ELSIF NVL(nIdEndoso,0) != 0 THEN
                OC_ENDOSO.ACTUALIZA_VALORES(X.CodCia, X.CodEmpresa, nIdPoliza, nIDetPol, nIdEndoso);
             END IF;
          EXCEPTION
          WHEN OTHERS THEN
               cMsjError := SQLERRM;
          END;
          IF cMsjError = 'N'   THEN
             OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'PROCE');
             /*IF NVL(X.IndColectiva,'N')= 'N' THEN
                OC_POLIZAS.EMITIR_POLIZA(X.CodCia, nIdPoliza, X.CodEmpresa);
             END IF;*/
          ELSE
             OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo, 'AUTOMATICO', '20225', 'No se puede emitir la Póliza o Cargar el Asegurado: ' || cMsjError);
             OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'ERROR');
          END IF;
       ELSE
          OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'ERROR');
       END IF;
   END LOOP;
EXCEPTION
WHEN OTHERS THEN
     OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo, 'AUTOMATICO', '20225', 'No se puede emitir la Póliza o Cargar el Asegurado: ' || SQLERRM);
     OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'ERROR');
END EMISION_COLECTIVA_ASEGURADO;

PROCEDURE ALTA_CERTIFICADO(nIdProcMasivo NUMBER) IS
nCodCliente        CLIENTES.CodCliente%TYPE;
cTipoDocIdentAseg  CLIENTES.Tipo_Doc_Identificacion%TYPE;
cNumDocIdentAseg   CLIENTES.Num_Doc_Identificacion%TYPE;
nCod_Asegurado     ASEGURADO.Cod_Asegurado%TYPE;
nCodcia            POLIZAS.CodCia%TYPE;
nCodempresa        POLIZAS.CodEmpresa%TYPE;
cCodmoneda         POLIZAS.Cod_Moneda%TYPE;
cPlanCob           PLAN_COBERTURAS.PlanCob%TYPE;
cExiste            VARCHAR2  (1);
cExisteDet         VARCHAR2  (1);
nIdPoliza          POLIZAS.IdPoliza%TYPE;
cIdTipoSeg         TIPOS_DE_SEGUROS.IdTipoSeg%TYPE;
nPorcComis         POLIZAS.PorcComis%TYPE;
cDescpoliza        POLIZAS.DescPoliza%TYPE;
nCod_Agente        POLIZAS.Cod_Agente%TYPE;
cCodPlanPago       POLIZAS.CodPlanPago%TYPE;
cExisteTipoSeguro  VARCHAR2  (2);
nTasaCambio        DETALLE_POLIZA.Tasa_Cambio%TYPE;
nIDetPol           DETALLE_POLIZA.IdetPol%TYPE;
cIdGrupoTarj       TARJETAS_PREPAGO.IdGrupoTarj%TYPE;
cCodPromotor       DETALLE_POLIZA.CodPromotor%TYPE;
cMsjError          PROCESOS_MASIVOS_LOG.TxtError%TYPE := 'N';
cCodPlantilla      CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE;
cNomTabla          CONFIG_PLANTILLAS_CAMPOS.NomTabla%TYPE;
nOrden             NUMBER(10):= 1;
nOrdenInc          NUMBER(10);
cUpdate            VARCHAR2(4000);
dFecIniVig         DATE;
dFecFinVig         DATE;
dDetFecIniVig      DATE;
dDetFecFinVig      DATE;
cStsPoliza         POLIZAS.StsPoliza%TYPE;
cIndPolCol         POLIZAS.IndPolCol%TYPE;
cExisteParEmi      VARCHAR2(1);
nIdEndoso          ENDOSOS.IdEndoso%TYPE;
nPrimaEnd          COBERT_ACT.Prima_Local%TYPE;
nSumaEnd           COBERT_ACT.SumaAseg_Local%TYPE;
nFactProrrata      NUMBER(11,8);
cIndFactPeriodo    POLIZAS.IndFactPeriodo%TYPE;
nFrecPagos         PLAN_DE_PAGOS.FrecPagos%TYPE;
nMes               NUMBER (10);
dFecPago           FACTURAS.FecPago%TYPE;
nPrima_local       DETALLE_POLIZA.Prima_local%TYPE;

CURSOR C_CAMPOS (cNomTabla VARCHAR2) IS
   SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.TipoCampo
     FROM CONFIG_PLANTILLAS_CAMPOS C
    WHERE C.CodPlantilla = cCodPlantilla
      AND C.CodEmpresa   = nCodEmpresa
      AND C.NomTabla     = cNomTabla
      AND C.CodCia       = nCodCia
    ORDER BY OrdenCampo;

CURSOR C_CAMPOS_PART  IS
   SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.OrdenDatoPart
     FROM CONFIG_PLANTILLAS_CAMPOS C
    WHERE C.CodPlantilla = cCodPlantilla
      AND C.CodEmpresa   = nCodEmpresa
      AND C.CodCia       = nCodCia
      AND C.NomTabla     = 'DATOS_PART_EMISION'
      AND C.IndDatoPart  = 'S'
    ORDER BY OrdenDatoPart,OrdenCampo;

CURSOR EMI_Q IS
   SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
          NumDetUnico, RegDatosProc, TipoProceso, IndColectiva
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;

CURSOR C_COBERT IS
   SELECT IdPoliza, IDetPol, CodEmpresa, IdTipoSeg, CodCia, CodCobert,
          SumaAseg_Local, SumaAseg_Moneda, Prima_Local, Prima_Moneda, Tasa, PlanCob
     FROM COBERT_ACT
    WHERE IdPoliza     = nIdPoliza
      AND IDETPOL      = nIdetPol
      AND StsCobertura = 'SOL';
BEGIN
   FOR X IN EMI_Q LOOP
      nCodCia           :=  X.CodCia;
      nCodEmpresa       :=  X.CodEmpresa;
      cTipoDocIdentAseg := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,',')) ;
      cNumDocIdentAseg  := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,7,',')) ;
    --  cCodPlanPago      := OC_TIPOS_DE_SEGUROS.PLAN_PAGOS(X.CodCia, X.CodEmpresa, X.IdTipoSeg);
      cCodPlantilla     := OC_CONFIG_PLANTILLAS_PLANCOB.CODIGO_PLANTILLA(X.CodCia,X.CodEmpresa,X.IdTipoSeg,X.PlanCob,X.TipoProceso);
      IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(cTipoDocIdentAseg, cNumDocIdentAseg) = 'N' THEN
         OC_PROCESOS_MASIVOS.INSERT_DINAMICO(cCodPlantilla, 'PERSONA_NATURAL_JURIDICA', 1, X.RegDatosProc);
      END IF;
      BEGIN
         SELECT Cod_Agente
           INTO nCod_Agente
           FROM PLAN_COBERTURAS
          WHERE CodCia     = X.CodCia
            AND CodEmpresa = X.CodEmpresa
            AND IdTipoSeg  = X.IdTipoSeg
            AND PlanCob    = X.PlanCob;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            nCod_Agente := 0;
      END;
      nCodCliente := OC_CLIENTES.CODIGO_CLIENTE(cTipoDocIdentAseg, cNumDocIdentAseg);
      IF nCodCliente = 0  THEN
         nCodCliente    := OC_CLIENTES.INSERTAR_CLIENTE(cTipoDocIdentAseg,cNumDocIdentAseg);
         FOR I IN C_CAMPOS('CLIENTES') LOOP
            nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
            cUpdate := 'UPDATE '||'CLIENTES'||' '||'SET'||' '||I.NomCampo||'=';
            IF I.TipoCampo = 'DATE' THEN
               cUpdate := cUpdate || ' TO_DATE(' || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||
                          CHR(39) || ','|| CHR(39) || 'DD/MM/RRRR' || CHR(39) || ') ';
            ELSE
               cUpdate := cUpdate || '''' ||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||'''';
            END IF;
            cUpdate := cUpdate ||' '||'WHERE CODCLIENTE='||nCodCliente;
            OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate) ;
            nOrden := nOrden + 1;
         END LOOP;
      END IF;
      nCod_Asegurado := OC_ASEGURADO.CODIGO_ASEGURADO(X.CodCia, X.CodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
      IF nCod_Asegurado = 0 THEN
         nCod_Asegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(X.CodCia, X.CodEmpresa,cTipoDocIdentAseg, cNumDocIdentAseg);
      END IF;
      BEGIN
         INSERT INTO CLIENTE_ASEG
               (CodCliente, Cod_Asegurado)
         VALUES(nCodCliente, nCod_Asegurado);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            NULL;
      END;
      BEGIN
         SELECT IdPoliza, CodPlanPago
           INTO nIdPoliza, cCodPlanPago
           FROM Polizas
          WHERE NumPolUnico        = X.NumPolUnico
            AND CodCia             = X.CodCia
            AND CodEmpresa         = X.CodEmpresa
            AND NVL(IndPolCol,'N') = 'S'
            AND StsPoliza          IN ('SOL','EMI');
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          nIdPoliza := 0;
      END;
      IF  OC_POLIZAS.EXISTE_POLIZA(X.CodCia, X.CodEmpresa, nIdpoliza) = 'N' THEN
           RAISE_APPLICATION_ERROR(-20225,'Poliza No Existe   :'||X.NumPolUnico);
      END IF;
      cCodMoneda        := OC_PLAN_COBERTURAS.MONEDA_PLANCOB(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob);
      nPorcComis        := OC_CONFIG_COMISIONES.PORCENTAJE_COMISION(X.CodCia, X.CodEmpresa, X.IdTipoSeg);
      cExisteTipoSeguro := OC_TIPOS_DE_SEGUROS.EXISTE_TIPO_DE_SEGURO(X.CodCia, X.CodEmpresa, X.IdTipoSeg );

      IF cExisteTipoSeguro = 'S' THEN
         BEGIN
            -- Inserta Tarea de Seguimiento
            IF OC_TAREA.EXISTE_TAREA(X.CodCia,nIdPoliza) = 'N' THEN
               OC_TAREA.INSERTA_TAREA(X.CodCia, 7, 'SOL', 'EMI', nIdPoliza, nCodCliente, 'A','SOL', 'SOLICITUD DE EMISION DE CERTIFICADO');
            END IF;
            -- Genera Detalle de Poliza
            nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
            BEGIN
               SELECT FecIniVig ,FecFinVig, StsPoliza, IndPolCol,IndFactPeriodo
                 INTO dFecIniVig,dFecFinVig,cStsPoliza,cIndPolCol,cIndFactPeriodo
                 FROM Polizas
                WHERE IdPoliza   = nIdPoliza
                  AND CodCia     = X.CodCia
                  AND CodEmpresa = X.CodEmpresa ;
            END;

            IF cStsPoliza = 'EMI' AND cIndPolCol = 'S' THEN
               IF OC_DETALLE_POLIZA.EXISTE_POLIZA_DETALLE(X.CodCia, X.CodEmpresa, nIdPoliza, TRIM(TO_CHAR(x.NumDetUnico))) = 'N' THEN
                  nIDetPol    := OC_DETALLE_POLIZA.INSERTAR_DETALLE(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob,
                                                                    nIdPoliza, nTasaCambio, nPorcComis, nCod_Asegurado,
                                                                    cCodPlanPago, TRIM(TO_CHAR(X.NumDetUnico)),cCodPromotor,dFecIniVig);
               ELSE
                  BEGIN
                     SELECT IDetPol
                       INTO nIDetPol
                       FROM DETALLE_POLIZA
                      WHERE CodCia      = X.CodCia
                        AND CodEmpresa  = X.CodEmpresa
                     AND IdPoliza    = nIdpoliza
                        AND NumDetRef   = TRIM(TO_CHAR(x.NumDetUnico));
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        RAISE_APPLICATION_ERROR(-20225,'DETALLE POLIZA NO EXISTE: '|| TRIM(TO_CHAR(x.numpolunico)));
                  END;
               END IF;
               nOrden    := 1;
               nOrdenInc := 0;
               FOR I IN C_CAMPOS('DETALLE_POLIZA') LOOP
                  nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
                  IF UPPER(I.NomCampo) = 'FECINIVIG' THEN
                     IF (TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')),'DD-MM-YYYY') NOT BETWEEN  dFecIniVig AND  dFecFinVig )  OR
                        (OC_FACTURAR.FUNC_VALIDA_FECHA(X.CodCia, X.CodEmpresa, nIdPoliza,
                                                       TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')),'DD-MM-YYYY'),cCodPlanPago) = 'S') THEN
                        DELETE DETALLE_POLIZA
                         WHERE CodCia      = X.CodCia
                           AND CodEmpresa  = X.CodEmpresa
                           AND IdPoliza    = nIdpoliza
                           AND NumDetRef   = TRIM(TO_CHAR(x.NumDetUnico))
                           AND StsDetalle  = 'SOL';
                        RAISE_APPLICATION_ERROR(-20225,'Fecha de Inicio de Vigencia del Certificado debe estar dentro de la Vigencia de la Póliza ' ||
                                                ' o Fecha de Ingreso no Puede ser mayor a la Fecha de Facturación');
                     END IF;
                  END IF;
                  IF UPPER(I.NomCampo) = 'FECFINVIG' THEN
                     IF TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')),'DD-MM-YYYY') NOT BETWEEN  dFecIniVig AND  dFecFinVig  THEN
                        RAISE_APPLICATION_ERROR(-20225,'Fecha de Final de Vigencia del Certificado debe estar dentro de la Vigencia de la Póliza');
                     END IF;
                  END IF;
                  nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
                  cUpdate := 'UPDATE '||'DETALLE_POLIZA'||' '||'SET'||' '||I.NomCampo||'=';
                  IF I.TipoCampo = 'DATE' THEN
                     cUpdate := cUpdate || ' TO_DATE(' || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||
                                CHR(39) || ','|| CHR(39) || 'DD/MM/RRRR' || CHR(39) || ') ';
                  ELSE
                     cUpdate := cUpdate || '''' ||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) ||'''';
                  END IF;
                  cUpdate := cUpdate ||' '||'WHERE IdPoliza='||nIdPoliza||' '||'AND IDetPol='||nIDetPol||' '||
                             'AND CodCia='||X.CodCia||' '||'AND CodEmpresa='||X.CodEmpresa;
                  OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate) ;
                  nOrden := nOrden + 1;
               END LOOP;
               nOrden    := 1;
               nOrdenInc := 0;
               FOR I IN C_CAMPOS_PART LOOP
                  BEGIN
                     SELECT 'S'
                       INTO cExisteParEmi
                       FROM DATOS_PART_EMISION
                      WHERE CodCia    = X.CodCia
                        AND Idpoliza  = nIdPoliza
                        AND IdetPol   = nIDetPol;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        cExisteParEmi := 'N';
                  END;
                  IF NVL(cExisteParEmi,'N') = 'N' THEN
                     INSERT INTO DATOS_PART_EMISION
                            (CodCia, Idpoliza, IdetPol, StsDatPart, FecSts)
                     VALUES (X.CodCia, nIdPoliza, nIDetPol, 'SOL', TRUNC(SYSDATE));
                  END IF;
                  nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + 5 + nOrden;
                  cUpdate   := 'UPDATE '||'DATOS_PART_EMISION'||' '||'SET'||' '||'CAMPO'||I.OrdenDatoPart||'='||''''||
                               LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')||''''||' '||
                               'WHERE IdPoliza= '||nIdPoliza||' '||'AND IDetPol= '||nIDetPol||' '||'AND CodCia= '||X.CodCia);
                  OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate) ;
                  nOrden := nOrden + 1;
               END LOOP;
               IF OC_COBERT_ACT.EXISTE_COBERTURA(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob,nIdPoliza, nIDetPol) = 'N' THEN
                  --OC_COBERT_ACT.CARGAR_COBERTURAS(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob,nIdPoliza, nIDetPol, nTasaCambio);
                  OC_COBERT_ACT.CARGAR_COBERTURAS(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, nIdPoliza,
                                                  nIDetPol, nTasaCambio, NULL, 0, 0, 0, 0, 99, 0, 0, 0, 0, 0, 0);
               END IF;

               IF OC_AGENTES_DETALLES_POLIZAS.EXISTE_AGENTE (X.CodCia, nIdPoliza, nIDetPol, X.IdTipoSeg, nCod_Agente) = 'N' THEN
                  IF nCod_Agente IS NOT NULL THEN
                     OC_AGENTES_DETALLES_POLIZAS.INSERTA_AGENTE(X.CodCia, nIdPoliza, nIDetPol, X.IdTipoSeg, nCod_Agente);
                  END IF;
               END IF;

               OC_POLIZAS.ACTUALIZA_VALORES(X.CodCia, nIdPoliza, 0);
               OC_DETALLE_POLIZA.ACTUALIZA_VALORES(X.CodCia, nIdPoliza, nIDetPol, 0);
               nIdEndoso   := OC_ENDOSO.CREAR(nIdpoliza);

               BEGIN
                  SELECT FecIniVig ,FecFinVig,Prima_local
                    INTO dDetFecIniVig,dDetFecFinVig, nPrima_local
                    FROM DETALLE_POLIZA
                   WHERE CodCia      = X.CodCia
                     AND CodEmpresa  = X.CodEmpresa
                     AND IdPoliza    = nIdpoliza
                     AND IDetPol     = nIDetPol;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     RAISE_APPLICATION_ERROR(-20225,'DETALLE POLIZA NO EXISTE: '|| nIDetPol);
               END;
               nPrimaEnd     := 0;
               nSumaEnd      := 0;
               nFactProrrata := 1;
               -- CaracterÃ­sticas del Plan de Pago
               BEGIN
                  SELECT FrecPagos
                    INTO nFrecPagos
                    FROM PLAN_DE_PAGOS
                   WHERE CodCia      = X.CodCia
                     AND CodEmpresa  = X.CodEmpresa
                     AND CodPlanPago = cCodPlanPago;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     RAISE_APPLICATION_ERROR (-20100,'No Existe Plan de Pagos '||cCodPlanPago);
               END;
               BEGIN
                  SELECT TRUNC(NVL(ADD_MONTHS(MAX(FECVENC),nFrecPagos),SYSDATE))
                    INTO dFecPago
                    FROM FACTURAS
                   WHERE IdPoliza = nIdPoliza
                     AND CodCia   = X.CodCia;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     dFecPago := TRUNC(SYSDATE);
               END;
               IF NVL(cIndFactPeriodo,'N') = 'S' THEN
                  nMes := OC_GENERALES.VALIDA_FECHA_FACTURA(dDetFecIniVig,dFecPago) + 1;
                  IF NVL(nMes,0) > 0  THEN
                     nPrimaEnd :=  (nPrima_local / 12) * nMes;
                  END IF;
               ELSE
                  nPrimaEnd := nPrima_local;
               END IF ;
               FOR I IN C_COBERT LOOP
                  nSumaEnd  := nSumaEnd  + I.SumaAseg_Local;

                  UPDATE COBERT_ACT
                     SET Prima_Local  = nFactProrrata * I.Prima_Local,
                         Prima_Moneda = nFactProrrata * I.Prima_Moneda
                   WHERE IDPoliza     = I.IdPoliza
                     AND IdetPol      = I.IdetPol
                     AND StsCobertura = 'SOL'
                     AND CodCobert    = I.CodCobert;

                  BEGIN
                     INSERT INTO COBERTURAS
                           (IdPoliza, IDetPol, CodEmpresa, IdTipoSeg, CodCia, CodCobert, IdEndoso, StsCobertura,
                            Suma_Asegurada_Local, Suma_Asegurada_Moneda, Prima_Local, Prima_Moneda, Tasa, PlanCob)
                     VALUES(I.IdPoliza, I.IdetPol, I.CodEmpresa, I.IdTipoSeg, I.CodCia, I.CodCobert, nIdEndoso, 'SOL',
                            I.SumaAseg_Local, I.SumaAseg_moneda, (nFactProrrata * I.Prima_Local), (nFactProrrata* I.Prima_Moneda),
                            I.Tasa, I.PlanCob);
                  EXCEPTION
                     WHEN OTHERS THEN
                        RAISE_APPLICATION_ERROR(-20225,'COBERTURAS - Ocurrió el siguiente error: '||SQLERRM);
                  END;
               END LOOP;
               OC_ENDOSO.INSERTA(X.CodCia, X.CodEmpresa, nIdPoliza, nIdetPol, nIdEndoso, 'IND', X.NumDetUnico,
                                 dDetFecIniVig, dDetFecFinVig, cCodPlanPago, nSumaEnd, nPrimaEnd, 0, '018', NULL);
--               OC_POLIZAS.INSERTA_REQUISITOS(X.CodCia, nIdPoliza);     --REQ
            ELSE
               cMsjError := 'S';
               RAISE_APPLICATION_ERROR(-20225,'Póliza: '||TRIM(TO_CHAR(X.NumPolUnico)||' Debe estar en Estado EMI o NO es Colectiva'));
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               cMsjError := SQLERRM;
         END;
         IF cMsjError = 'N'   THEN
            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'PROCE');
         ELSE
            OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','No se puede Emitir Certificado: '||cMsjError);
            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
         END IF;
      ELSE
         OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
      END IF;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
    OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','No se puede Emitir Certificado: '||SQLERRM);
    OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END ALTA_CERTIFICADO;

PROCEDURE BAJA_CERTIFICADO(nIdProcMasivo NUMBER) IS
cTipoEndoso        ENDOSOS.TipoEndoso%TYPE;
nIdpoliza          POLIZAS.Idpoliza%TYPE;
dFecIni            DATE;
dFecFin            DATE;
nIdEndoso          ENDOSOS.IdEndoso%TYPE;
nIdetPol           DETALLE_POLIZA.IdetPol%TYPE;
nSuma_Aseg_Local   DETALLE_POLIZA.Suma_Aseg_Local%TYPE;
nSuma_Aseg_Moneda  DETALLE_POLIZA.Suma_Aseg_Moneda%TYPE;
nPrima_Local       DETALLE_POLIZA.Prima_Local%TYPE;
nPrimaExc          DETALLE_POLIZA.Prima_Local%TYPE;
nPrima_Moneda      DETALLE_POLIZA.Prima_Moneda%TYPE;
nMontoComis        DETALLE_POLIZA.MontoComis%TYPE;
dFecIniVig         DETALLE_POLIZA.FecIniVig %TYPE;
dFecFinVig         DETALLE_POLIZA.FecFinVig%TYPE;
cCodPlanPago       DETALLE_POLIZA.CodPlanPago%TYPE;
nCodCliente        POLIZAS.CodCliente%TYPE;
nDiasAnul          NUMBER(6);
nPrimaProrrata     COBERT_ACT.Prima_Local%TYPE;
nDiasAno           NUMBER(6) := 365;
nDiasProrrata      NUMBER(6);
dFecAnul           DATE ;
nIdTrn             TRANSACCION.IdTransaccion%TYPE;
nCod_Agente        AGENTES_DETALLES_POLIZAS.Cod_Agente%TYPE;
nIdNcr             NOTAS_DE_CREDITO.IdNcr%TYPE;
cIndPolCol         POLIZAS.IndPolCol%TYPE;
cIndFactPeriodo    POLIZAS.IndFactPeriodo%TYPE;
nFrecPagos         PLAN_DE_PAGOS.FrecPagos%TYPE;
nMes               NUMBER (10);
dFecPago           FACTURAS.FecPago%TYPE;
nPrimaEnd          ENDOSOS.Prima_Neta_Local%TYPE;
dFecUlt            FACTURAS.FecPago%TYPE;
nPorcComi          DETALLE_POLIZA.PorcComis%TYPE;

CURSOR C_ENDOSO IS
   SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
          NumDetUnico, RegDatosProc, TipoProceso, IndColectiva
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;

CURSOR C_COBERT IS
   SELECT IdPoliza, IDetPol, CodEmpresa, IdTipoSeg, CodCia, CodCobert,
          SumaAseg_Local, SumaAseg_Moneda, Prima_Local, Prima_Moneda, Tasa, PlanCob
     FROM COBERT_ACT
    WHERE IDPoliza     = nIdPoliza
      AND IDETPOL      = nIdetPol
      AND StsCobertura = 'EMI';
BEGIN
   FOR X IN C_ENDOSO LOOP
      BEGIN
         --cTipoEndoso := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,',')) ;
         dFecIni     := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,',')) ;

         -- dFecFin     := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,8,',')) ;
         BEGIN
            SELECT IdPoliza,CodCliente,IndPolCol,IndFactPeriodo
              INTO nIdpoliza, nCodCliente,cIndPolCol,cIndFactPeriodo
              FROM Polizas
             WHERE NumPolUnico          = X.NumPolUnico
               AND CodCia               = X.CodCia
               AND CodEmpresa           = X.CodEmpresa
               AND NVL(IndPolCol,'N')   = 'S'
               AND StsPoliza            IN ('SOL','EMI');
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               nIdPoliza := 0;
         END;

         IF OC_POLIZAS.EXISTE_POLIZA(X.CodCia, X.CodEmpresa, nIdpoliza) = 'N' OR NVL(cIndPolCol,'N') = 'N' THEN
            RAISE_APPLICATION_ERROR(-20225,'Poliza No Existe  :'||X.NumPolUnico);
         END IF;
         dFecAnul := dFecIni;

         BEGIN
            SELECT IdetPol, Suma_Aseg_Local, Suma_Aseg_Moneda, Prima_Local, Prima_Moneda,
                   MontoComis, FecIniVig, FecFinVig, CodPlanPago, PorcComis
              INTO nIdetPol, nSuma_Aseg_Local, nSuma_Aseg_Moneda, nPrima_Local, nPrima_Moneda,
                   nMontoComis, dFecIniVig, dFecFinVig, cCodPlanPago, nPorcComi
              FROM DETALLE_POLIZA
             WHERE IdPoliza   = nIdPoliza
               AND CodCia     = X.CodCia
               AND NumDetRef  = X.NumDetUnico
               AND StsDetalle = 'EMI';
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20225,'Certificado  No Existe   :'||X.NumDetUnico);
         END;

         BEGIN
            SELECT Cod_Agente
              INTO nCod_Agente
              FROM AGENTES_DETALLES_POLIZAS
             WHERE CodCia      = X.CodCia
               AND IdPoliza    = nIdpoliza
               AND IDetPol     = nIDetPol
               AND IdTipoSeg   = X.IdTipoSeg;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               nCod_Agente := 0;
         END;
         BEGIN
            SELECT FrecPagos
              INTO nFrecPagos
              FROM PLAN_DE_PAGOS
             WHERE CodCia      = X.CodCia
               AND CodEmpresa  = X.CodEmpresa
               AND CodPlanPago = cCodPlanPago;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR (-20100,'No Existe Plan de Pagos '||cCodPlanPago);
         END;

         BEGIN
            SELECT TRUNC(NVL(ADD_MONTHS(MAX(FECVENC),nFrecPagos),SYSDATE)),MAX(FECVENC)
              INTO dFecPago, dFecUlt
              FROM FACTURAS
             WHERE IdPoliza = nIdPoliza
               AND CodCia   = X.CodCia;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               dFecPago := TRUNC(SYSDATE);
         END;
         nPrimaEnd  := OC_ENDOSO.MONTO_ENDOSO_BAJA(X.Codcia, X.CodEmpresa, nIdPoliza ,nIdetPol, dFecAnul, cCodPlanPago ,NVL(cIndFactPeriodo,'N'));
         nIdEndoso  := OC_ENDOSO.CREAR(nIdpoliza);
         OC_ENDOSO.INSERTA(X.Codcia, X.CodEmpresa, nIdPoliza ,nIdetPol ,nIdEndoso , 'EXD' ,X.NumDetUnico, dFecIniVig,
                           dFecFinVig, cCodPlanPago, nSuma_Aseg_Local, nPrimaEnd, nPorcComi, '019', dFecAnul);
         FOR I IN C_COBERT LOOP
            BEGIN
               INSERT INTO COBERTURAS
                      (IdPoliza, IDetPol, CodEmpresa, IdTipoSeg, CodCia,CodCobert, IdEndoso, StsCobertura, Suma_Asegurada_Local,
                       Suma_Asegurada_Moneda, Prima_Local, Prima_Moneda, Tasa, PlanCob)
               VALUES (I.IdPoliza, I.IdetPol, I.CodEmpresa, I.IdTipoSeg, I.CodCia, I.CodCobert, nIdEndoso, 'SOL', I.SumaAseg_Local,
                       I.SumaAseg_Moneda, I.Prima_Local, I.Prima_Local, I.Tasa, I.PlanCob);
            EXCEPTION
               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR(-20225,'COBERTURAS - Ocurrió el siguiente error: '||SQLERRM);
            END;
         END LOOP;

         UPDATE COBERT_ACT
            SET StsCobertura = 'XNC'
          WHERE IdPoliza = nIdPoliza
            AND CodCia   = X.CodCia
            AND IdetPol  = nIdetPol;

         UPDATE DETALLE_POLIZA
            SET StsDetalle = 'XNC',
                FecAnul    = dFecAnul
          WHERE IdPoliza   = nIdPoliza
            AND IdetPol    = nIdetPol
            AND StsDetalle = 'EMI' ;

            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'PROCE');
      EXCEPTION
         WHEN OTHERS THEN
            OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'ENDOSO','20225','No se puede realizar el Endoso '||X.NumPolUnico||' '||SQLERRM);
            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
      END;
   END LOOP;
END BAJA_CERTIFICADO;

PROCEDURE AUMENTO(nIdProcMasivo NUMBER) IS
cTipoEndoso        ENDOSOS.TipoEndoso%TYPE;
nIdpoliza          POLIZAS.IdPoliza%TYPE;
dFecIni            DATE;
dFecFin            DATE;
nIdEndoso          ENDOSOS.IdEndoso%TYPE;
nIdetPol           DETALLE_POLIZA.IdetPol%TYPE;
nSuma_Aseg_Local   DETALLE_POLIZA.Suma_Aseg_Local%TYPE;
nSuma_Aseg_Moneda  DETALLE_POLIZA.Suma_Aseg_Moneda%TYPE;
nPrima_Local       DETALLE_POLIZA.Prima_Local%TYPE;
nPrimaExc          DETALLE_POLIZA.Prima_Local%TYPE;
nPrima_Moneda      DETALLE_POLIZA.Prima_Moneda%TYPE;
nMontoComis        DETALLE_POLIZA.MontoComis%TYPE;
dFecIniVig         DETALLE_POLIZA.FecIniVig %TYPE;
dFecFinVig         DETALLE_POLIZA.FecFinVig%TYPE;
cCodPlanPago       DETALLE_POLIZA.CodPlanPago%TYPE;
nCodCliente        POLIZAS.CodCliente%TYPE;
nDiasAnul          NUMBER(6);
nPrimaProrrata     COBERT_ACT.Prima_Local%TYPE;
nDiasAno           NUMBER(6) := 365;
nDiasProrrata      NUMBER(6);
dFecAnul           DATE ;
nIdTrn             TRANSACCION.IdTransaccion%TYPE;
nCod_Agente        AGENTES_DETALLES_POLIZAS.Cod_Agente%TYPE;
nIdNcr             NOTAS_DE_CREDITO.IdNcr%TYPE;
cIndPolCol         POLIZAS.IndPolCol%TYPE;
cIndFactPeriodo    POLIZAS.IndFactPeriodo%TYPE;
nFrecPagos         PLAN_DE_PAGOS.FrecPagos%TYPE;
nMes               NUMBER (10);
dFecPago           FACTURAS.FecPago%TYPE;
nPrimaEnd          ENDOSOS.Prima_Neta_Local%TYPE;
dFecUlt            FACTURAS.FecPago%TYPE;
nPorcComi          DETALLE_POLIZA.PorcComis%TYPE;
nSalario           COBERT_ACT.SumaAseg_Local%TYPE;
nCodcia            POLIZAS.codcia%TYPE;
nCodempresa        POLIZAS.codempresa%TYPE;
cExisteParEmi      VARCHAR2(1);
cNomCampo          CONFIG_PLANTILLAS_CAMPOS.NomCampo%TYPE;
nOrdenCampo        CONFIG_PLANTILLAS_CAMPOS.OrdenCampo%TYPE;
cCodPlantilla      CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE;
cUpdate            VARCHAR2(4000);
nSumaNew           COBERT_ACT.SumaAseg_Local%TYPE;
nSumaEndo          COBERT_ACT.SumaAseg_Local%TYPE;
nFactProrrata      NUMBER(11,8);
nPrimaCobert       COBERT_ACT.SumaAseg_Local%TYPE;
nPrimaNew          COBERT_ACT.SumaAseg_Local%TYPE;

CURSOR C_ENDOSO IS
   SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
          NumDetUnico, RegDatosProc, TipoProceso, IndColectiva
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;

CURSOR C_COBERT IS
   SELECT IdPoliza, IDetPol, CodEmpresa, IdTipoSeg, CodCia, CodCobert, SumaAseg_Local,
          SumaAseg_Moneda, Prima_Local, Prima_Moneda, Tasa, PlanCob
     FROM COBERT_ACT
    WHERE IdPoliza     = nIdPoliza
      AND IDetPol      = nIdetPol
      AND StsCobertura = 'EMI';
BEGIN
   FOR X IN C_ENDOSO LOOP
      BEGIN
         dFecIni       := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,',')) ;
         nSalario      := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,7,',')) ;
         cCodPlantilla := OC_CONFIG_PLANTILLAS_PLANCOB.CODIGO_PLANTILLA(X.CodCia,X.CodEmpresa,X.IdTipoSeg,X.PlanCob,X.TipoProceso);
         BEGIN
            SELECT IdPoliza,CodCliente,IndPolCol,IndFactPeriodo
              INTO nIdpoliza, nCodCliente,cIndPolCol,cIndFactPeriodo
              FROM Polizas
             WHERE NumPolUnico          = X.NumPolUnico
               AND CodCia               = X.CodCia
               AND CodEmpresa           = X.CodEmpresa
               AND NVL(IndPolCol,'N')   = 'S'
               AND StsPoliza            IN ('SOL','EMI');
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               nIdPoliza := 0;
         END;

         IF OC_POLIZAS.EXISTE_POLIZA(X.CodCia, X.CodEmpresa, nIdpoliza) = 'N' OR NVL(cIndPolCol,'N') = 'N' THEN
            RAISE_APPLICATION_ERROR(-20225,'Poliza No Existe  :'||X.NumPolUnico);
         END IF;
         BEGIN
            SELECT IdetPol,Suma_Aseg_Local,Suma_Aseg_Moneda,Prima_Local,Prima_Moneda,MontoComis,FecIniVig,FecFinVig,CodPlanPago,PorcComis
              INTO nIdetPol,nSuma_Aseg_Local,nSuma_Aseg_Moneda,nPrima_Local,nPrima_Moneda,nMontoComis,dFecIniVig, dFecFinVig,cCodPlanPago,nPorcComi
              FROM DETALLE_POLIZA
             WHERE IdPoliza   = nIdPoliza
               AND CodCia     = X.CodCia
               AND NumDetRef  = X.NumDetUnico
               AND StsDetalle = 'EMI';
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20225,'Certificado  No Existe   :'||X.NumDetUnico);
         END;
         IF dFecIni < dFecIniVig THEN
            RAISE_APPLICATION_ERROR(-20225,'Fecha de Inicio del Endoso No ser menor a la Fecha del Certificado   :'||dFecIni);
         END IF;
         BEGIN
            SELECT 'S'
              INTO cExisteParEmi
              FROM DATOS_PART_EMISION
             WHERE CodCia    = X.CodCia
               AND Idpoliza  = nIdPoliza
               AND IdetPol   = nIDetPol;
         EXCEPTION
            WHEN no_data_found THEN
               cExisteParEmi := 'N';
         END;

         IF NVL(cExisteParEmi,'N') = 'S' THEN
            BEGIN
               SELECT C.NomCampo,C.OrdenCampo
                 INTO cNomCampo, nOrdenCampo
                 FROM CONFIG_PLANTILLAS_CAMPOS C
                WHERE C.CodPlantilla = cCodPlantilla
                  AND C.CodEmpresa   = X.CodEmpresa
                  AND C.CodCia       = X.CodCia
                  AND C.NomTabla     = 'DATOS_PART_EMISION'
                  AND C.NomCampo     = 'SALARIO';
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-20225,'No Existe el Campo Salario en Plantilla de Configuracion  :'||cCodPlantilla);
            END;
            cUpdate   := 'UPDATE '||'DATOS_PART_EMISION'||' '||'SET'||' '||'CAMPO'||nOrdenCampo||'='||''''||
                         nSalario||''''||' '||'WHERE IdPoliza= '||nIdPoliza||' '||
                         'AND IDetPol= '||nIDetPol||' '||'AND CodCia= '||X.CodCia;
            OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate) ;
         END IF;
         BEGIN
            SELECT Cod_Agente
              INTO nCod_Agente
              FROM AGENTES_DETALLES_POLIZAS
             WHERE CodCia      = X.CodCia
               AND IdPoliza    = nIdpoliza
               AND IDetPol     = nIDetPol
               AND IdTipoSeg   = X.IdTipoSeg;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               nCod_Agente := 0;
         END;
         BEGIN
            SELECT TRUNC(MAX(FECVENC))
              INTO dFecPago
              FROM FACTURAS
             WHERE IdPoliza = nIdPoliza
               AND CodCia   = X.CodCia;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               dFecPago := TRUNC(SYSDATE);
         END;
         nIdEndoso := OC_ENDOSO.CREAR(nIdPoliza);
         nSumaEndo := 0;
         nPrimaEnd := 0;
         FOR I IN C_COBERT LOOP
            nSumaNew  := OC_COBERT_ACT.CALCULO_COBERTURA(I.CodCia,I.CodEmpresa,I.IdTipoSeg,I.PlanCob,
                                                         I.IdPoliza ,I.IDetPol,1,I.CodCobert ,'S');
            nPrimaNew  := OC_COBERT_ACT.CALCULO_COBERTURA(I.CodCia,I.CodEmpresa,I.IdTipoSeg,I.PlanCob,
                                                          I.IdPoliza ,I.IDetPol,1,I.CodCobert ,'P');
            IF nSumaNew  <  I.SumaAseg_Local THEN
               RAISE_APPLICATION_ERROR (-20100,'La Nueva Suma Asegurada  No Puede ser Menor a la Actual:'||nSumaNew);
            ELSE
               nSumaNew  := nSumaNew  - I.SumaAseg_Local;
               nPrimaNew := nPrimaNew - I.Prima_Local;
            END IF;
            nSumaEndo := nSumaEndo  + nSumaNew ;
            IF NVL(cIndFactPeriodo,'N') = 'S' THEN
               nMes := OC_GENERALES.VALIDA_FECHA_FACTURA(dFecIni,dFecPago) + 1;
               nPrimaEnd    := nPrimaEnd + (nPrimaNew / 12) * nMes;
               nPrimaCobert := (nPrimaNew / 12) * nMes;
            ELSE
               nFactProrrata  :=  OC_GENERALES.PRORRATA (dFecIni, dFecFinVig, dFecIni);
               nPrimaEnd     :=  nPrimaEnd + (nPrimaNew * nFactProrrata);
               nPrimaCobert  :=  nPrimaNew * nFactProrrata;
            END IF;
            BEGIN
               INSERT INTO COBERTURAS
                      (IdPoliza, IDetPol, CodEmpresa, IdTipoSeg, CodCia, CodCobert, IdEndoso, StsCobertura,
                       Suma_Asegurada_Local, Suma_Asegurada_Moneda, Prima_Local, Prima_Moneda, Tasa, PlanCob)
               VALUES (I.IdPoliza, I.IdetPol, I.CodEmpresa, I.IdTipoSeg, I.CodCia, I.CodCobert, nIdEndoso, 'SOL',
                       nSumaNew, nSumaNew, nPrimaCobert, nPrimaCobert, I.Tasa, I.PlanCob);
            EXCEPTION
               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR(-20225,'COBERTURAS - Ocurrió el siguiente error: '||SQLERRM);
            END;
         END LOOP;
         OC_ENDOSO.INSERTA(X.Codcia, X.CodEmpresa, nIdPoliza, nIdetPol, nIdEndoso, 'AUM', X.NumDetUnico, dFecIni,
                           dFecFinVig, '0001', nSumaEndo, nPrimaEnd, nPorcComi, '021', NULL);
         OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'PROCE');
      EXCEPTION
         WHEN OTHERS THEN
            OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'ENDOSO','20225','No se puede realizar el Endoso '||X.NumPolUnico||' '||SQLERRM);
            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
      END;
   END LOOP;
END AUMENTO;

PROCEDURE EMISION_QR(nIdProcMasivo NUMBER) IS
nCodCliente        CLIENTES.CODCLIENTE%TYPE;
cTipoDocIdentAseg  CLIENTES.TIPO_DOC_IDENTIFICACION%TYPE;
cNumDocIdentAseg   CLIENTES.Num_Doc_Identificacion%TYPE;
nCod_Asegurado     ASEGURADO.Cod_Asegurado%TYPE;
nCodCia            POLIZAS.CodCia%TYPE;
nCodEmpresa        POLIZAS.CodEmpresa%TYPE;
cCodmoneda         POLIZAS.Cod_Moneda%TYPE;
cPlanCob           PLAN_COBERTURAS.PlanCob%TYPE;
nIdPoliza          POLIZAS.IdPoliza%TYPE;
cIdTipoSeg         TIPOS_DE_SEGUROS.IdTipoSeg%TYPE;
nPorcComis         POLIZAS.PorcComis%TYPE;
cDescPoliza        POLIZAS.DescPoliza%TYPE;
nCod_Agente        POLIZAS.Cod_agente%TYPE;
cCodPlanPago       POLIZAS.CodPlanPago%TYPE;
nTasaCambio        DETALLE_POLIZA.Tasa_Cambio%TYPE;
nIDetPol           DETALLE_POLIZA.IDetPol%TYPE;
cIdGrupoTarj       TARJETAS_PREPAGO.IdGrupoTarj%TYPE;
cCodPromotor       DETALLE_POLIZA.CodPromotor%TYPE;
cMsjError          PROCESOS_MASIVOS_LOG.TxtError%TYPE := 'N';
cCodPlantilla      CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE;
cNomTabla          CONFIG_PLANTILLAS_CAMPOS.NomTabla%TYPE;
cCodFormaCobro     MEDIOS_DE_COBRO.CodFormaCobro%TYPE;
cStsPoliza         POLIZAS.StsPoliza%TYPE;
cNombreAseg        PERSONA_NATURAL_JURIDICA.Nombre%TYPE;
cApellidoPaterno   PERSONA_NATURAL_JURIDICA.Apellido_Paterno%TYPE;
cApellidoMaterno   PERSONA_NATURAL_JURIDICA.Apellido_Materno%TYPE;
cDirecRes          PERSONA_NATURAL_JURIDICA.DirecRes%TYPE;
cNumInterior       PERSONA_NATURAL_JURIDICA.NumInterior%TYPE;
cNumExterior       PERSONA_NATURAL_JURIDICA.NumExterior%TYPE;
cDescColonia       COLONIA.Descripcion_Colonia%TYPE;
cCodPosRes         PERSONA_NATURAL_JURIDICA.CodPosRes%TYPE;
cCodColonia        PERSONA_NATURAL_JURIDICA.CodColRes%TYPE;
cCodPaisRes        PERSONA_NATURAL_JURIDICA.CodPaisRes%TYPE;
cCodProvRes        PERSONA_NATURAL_JURIDICA.CodProvRes%TYPE;
cCodDistRes        PERSONA_NATURAL_JURIDICA.CodDistRes%TYPE;
cCodCorrRes        PERSONA_NATURAL_JURIDICA.CodCorrRes%TYPE;
cTelRes            PERSONA_NATURAL_JURIDICA.TelRes%TYPE;
cEmail             PERSONA_NATURAL_JURIDICA.Email%TYPE;
dFecNacimiento     PERSONA_NATURAL_JURIDICA.FecNacimiento%TYPE;
cSexo              PERSONA_NATURAL_JURIDICA.Sexo%TYPE;
cOrigen            AGENTE_POLIZA.Origen%TYPE;
nBenef1            BENEFICIARIO.Benef%TYPE;
cNomBenef1         BENEFICIARIO.Nombre%TYPE;
cDescParent        VALORES_DE_LISTAS.DescValLst%TYPE;
cCodParent1        BENEFICIARIO.CodParent%TYPE;
nPorcePart1        BENEFICIARIO.PorcePart%TYPE;
nBenef2            BENEFICIARIO.Benef%TYPE;
cNomBenef2         BENEFICIARIO.Nombre%TYPE;
cCodParent2        BENEFICIARIO.CodParent%TYPE;
nPorcePart2        BENEFICIARIO.PorcePart%TYPE;
nBenef3            BENEFICIARIO.Benef%TYPE;
cNomBenef3         BENEFICIARIO.Nombre%TYPE;
cCodParent3        BENEFICIARIO.CodParent%TYPE;
nPorcePart3        BENEFICIARIO.PorcePart%TYPE;
dFecEmision        POLIZAS.FecEmision%TYPE;
nOrden             NUMBER(10):= 1  ;
nOrdenInc          NUMBER(10) ;
cUpdate            VARCHAR2(4000);
dFecIniVig         DATE;
dFecFinVig         DATE;
cExisteParEmi      VARCHAR2(1);
cExiste            VARCHAR2(1);
cExisteDet         VARCHAR2(1);
cExisteTipoSeguro  VARCHAR2(2);
cCadenaEspOrig     VARCHAR2(100) := 'áéíóúÀÁÂÃÄÅÈÉÊËÌÍÎÏÒÓÔÕÖÙÚÛÜ';
cCadenaNormal      VARCHAR2(100) := 'aeiouAAAAAAEEEEIIIIOOOOOUUUU';

CURSOR EMI_Q IS
   SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
          NumDetUnico, RegDatosProc, TipoProceso,IndColectiva
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;
BEGIN
   FOR X IN EMI_Q LOOP
      nCodCia           := X.CodCia;
      nCodempresa       := X.CodEmpresa;

      -- Datos del Contratante / Asegurado
      cNombreAseg        := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,3,'|'));  -- EMIQR
      cApellidoPaterno   := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,4,'|'));  -- EMIQR
      cApellidoMaterno   := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,5,'|'));  -- EMIQR
      cDirecRes          := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,'|'));  -- EMIQR
      cNumExterior       := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,7,'|'));  -- EMIQR
      cNumInterior       := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,8,'|'));  -- EMIQR
      cDescColonia       := TRANSLATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,9,'|')),cCadenaEspOrig,cCadenaNormal);  -- EMIQR
      cCodPosRes         := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,12,'|'));  -- EMIQR
      cTelRes            := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,13,'|'));  -- EMIQR
      cEmail             := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,14,'|'));  -- EMIQR
      dFecNacimiento     := TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,15,'|')),'RRRRMMDD');  -- EMIQR
      cSexo              := NVL(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,16,'|')),'N');  -- EMIQR
      cTipoDocIdentAseg  := 'RFC'; -- Se Asigna Fijo 'RFC' porque Layout NO trae el campo
      cNumDocIdentAseg   := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,17,'|'));  -- EMIQR
      cCodPlanPago       := 'ANUA'; -- Se Asigna Fijo ANUA (Anual) porque Layout NO trae el campo
      nCod_Agente        := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,39,'|')));    -- EMIQR  SE COLOCAEL NUMBER PARA ELIMINAR LOS CEROS ANTES
      dFecEmision        := TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,37,'|')),'RRRRMMDD') + 1; -- EMIQR

      IF cCodPosRes IS NOT NULL THEN
         BEGIN
            SELECT Codigo_Colonia
              INTO cCodColonia
              FROM COLONIA
             WHERE Codigo_Postal = cCodPosRes
               AND UPPER(Descripcion_Colonia) LIKE UPPER(cDescColonia) || '%';
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
               cDirecRes := cDirecRes || ' ' || cDescColonia;
         END;

         BEGIN
            SELECT CodPais, CodEstado, CodCiudad, CodMunicipio
              INTO cCodPaisRes, cCodProvRes, cCodDistRes, cCodCorrRes
              FROM APARTADO_POSTAL
             WHERE Codigo_Postal = cCodPosRes;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20100,'NO Existe Código Postal. Favor de Corregir.');
         END;
      ELSE
         RAISE_APPLICATION_ERROR(-20100,'NO Existe Código Postal. Favor de Asignarlo.');
      END IF;

      IF cSexo NOT IN ('M','F','N') THEN
         RAISE_APPLICATION_ERROR(-20100,'Código de Sexo debe contener M, F o N. Favor de Corregir.');
      END IF;

      IF cCodPlanPago IS NULL THEN
         cCodPlanPago      := OC_TIPOS_DE_SEGUROS.PLAN_PAGOS(X.CodCia, X.CodEmpresa, X.IdTipoSeg);
      END IF;

      -- Datos del Beneficiario No. 1
      IF LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,18,'|')) IS NOT NULL THEN
         nBenef1            := 1;
         cNomBenef1         := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,18,'|')) || ' ' ||  -- EMIQR
                               LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,19,'|')) || ' ' ||  -- EMIQR
                               LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,20,'|'));  -- EMIQR
         cDescParent        := TRANSLATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,21,'|')),cCadenaEspOrig,cCadenaNormal);  -- EMIQR
         nPorcePart1        := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,22,'|'));  -- EMIQR
         BEGIN
            SELECT CodValor
              INTO cCodParent1
              FROM VALORES_DE_LISTAS
             WHERE CodLista = 'PARENT'
               AND UPPER(DescVallst) LIKE UPPER(cDescParent) || '%';
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cCodParent1 := '0014';
            WHEN TOO_MANY_ROWS THEN
               cCodParent1 := '0014';
         END;

      ELSE
         nBenef1            := 0;
         cNomBenef1         := NULL;
         nPorcePart1        := 0;
         cCodParent1        := NULL;
      END IF;

      -- Datos del Beneficiario No. 2
      IF LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,23,'|')) IS NOT NULL THEN
         nBenef2            := 2;
         cNomBenef2         := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,23,'|')) || ' ' ||  -- EMIQR
                               LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,24,'|')) || ' ' ||  -- EMIQR
                               LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,25,'|'));  -- EMIQR
         cDescParent        := TRANSLATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,26,'|')),cCadenaEspOrig,cCadenaNormal);  -- EMIQR
         nPorcePart2        := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,27,'|'));  -- EMIQR
         BEGIN
            SELECT CodValor
              INTO cCodParent2
              FROM VALORES_DE_LISTAS
             WHERE CodLista = 'PARENT'
               AND UPPER(DescVallst) LIKE UPPER(cDescParent) || '%';
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cCodParent2 := '0014';
            WHEN TOO_MANY_ROWS THEN
               cCodParent2 := '0014';
         END;
      ELSE
         nBenef2            := 0;
         cNomBenef2         := NULL;
         nPorcePart2        := 0;
         cCodParent2        := NULL;
      END IF;

      -- Datos del Beneficiario No. 3
      IF LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,28,'|')) IS NOT NULL THEN
         nBenef3            := 3;
         cNomBenef3         := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,28,'|')) || ' ' || -- EMIQR
                               LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,29,'|')) || ' ' || -- EMIQR
                               LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,30,'|')); -- EMIQR
         cDescParent        := TRANSLATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,31,'|')),cCadenaEspOrig,cCadenaNormal); -- EMIQR
         nPorcePart3        := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,32,'|'));  -- EMIQR
         BEGIN
            SELECT CodValor
              INTO cCodParent3
              FROM VALORES_DE_LISTAS
             WHERE CodLista = 'PARENT'
               AND UPPER(DescVallst) LIKE UPPER(cDescParent) || '%';
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cCodParent3 := '0014';
            WHEN TOO_MANY_ROWS THEN
               cCodParent3 := '0014';
         END;
      ELSE
         nBenef3            := 0;
         cNomBenef3         := NULL;
         nPorcePart3        := 0;
         cCodParent3        := NULL;
      END IF;
      --
      --
      cCodPlantilla     := OC_CONFIG_PLANTILLAS_PLANCOB.CODIGO_PLANTILLA(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, X.TipoProceso);

      IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(cTipoDocIdentAseg, cNumDocIdentAseg) = 'N' THEN
         OC_PERSONA_NATURAL_JURIDICA.INSERTAR_PERSONA(cTipoDocIdentAseg, cNumDocIdentAseg, cNombreAseg, cApellidoPaterno,
                                                      cApellidoMaterno, NULL, cSexo, NULL, dFecNacimiento, cDirecRes,
                                                      cNumInterior, cNumExterior, cCodPaisRes, cCodProvRes, cCodDistRes,
                                                      cCodCorrRes, cCodPosRes, cCodColonia, cTelRes, cEmail, NULL);
      END IF;

      nCodCliente := OC_CLIENTES.CODIGO_CLIENTE(cTipoDocIdentAseg, cNumDocIdentAseg);
      IF nCodCliente = 0  THEN
         nCodCliente    := OC_CLIENTES.INSERTAR_CLIENTE(cTipoDocIdentAseg,cNumDocIdentAseg);
      END IF;

      BEGIN
         SELECT IdPoliza, FecIniVig
           INTO nIdpoliza, dFecIniVig
           FROM POLIZAS
          WHERE NumPolUnico = X.NumPolUnico
            AND CodCia      = X.CodCia
            AND CodEmpresa  = X.CodEmpresa
            AND StsPoliza   IN ('SOL','EMI');
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            nIdPoliza  := 0;
            dFecIniVig := dFecEmision;
      END;
      --
      IF dFecNacimiento > dFecIniVig THEN
         RAISE_APPLICATION_ERROR(-20225,'La Fecha de Nacimiento no puede ser Mayor a la Fecha de Inicio de Vigencia de la Póliza - NO Procede Crearlo');
      END IF;
      --
      cExiste     := OC_POLIZAS.EXISTE_POLIZA(X.CodCia, X.CodEmpresa, nIdpoliza);
      cDescPoliza := 'Emisión Masiva QR del Registro No. ' || TRIM(TO_CHAR(nIdProcMasivo));
      cCodMoneda  := OC_PLAN_COBERTURAS.MONEDA_PLANCOB(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob);
      nPorcComis  := OC_CONFIG_COMISIONES.PORCENTAJE_COMISION(X.CodCia, X.CodEmpresa, X.IdTipoSeg);

      IF cExiste = 'N' AND  NVL(X.IndColectiva,'N') = 'N' THEN
         IF dFecIniVig IS NULL THEN
            dFecIniVig := dFecEmision;
         END IF;
         nIdPoliza   := OC_POLIZAS.INSERTAR_POLIZA(X.CodCia, X.CodEmpresa, cDescPoliza, cCodMoneda, nPorcComis,
                                                   nCodCliente, nCod_Agente, cCodPlanPago, TRIM(TO_CHAR(X.NumPolUnico)),
                                                   cIdGrupoTarj, dFecIniVig);
      END IF;
      IF NVL(X.IndColectiva,'N') = 'N' THEN
         -- Datos DEFAULT para Emisión QR
         UPDATE POLIZAS
            SET Caracteristica = '1',
                FormaVenta     = '006',
                TipoDividendo  = '003',
                TipoRiesgo     = '002'
          WHERE IdPoliza   = nIdPoliza
            AND CodCia     = X.CodCia
            AND CodEmpresa = X.CodEmpresa;
      END IF;

      IF OC_PERSONA_NATURAL_JURIDICA.FUNC_VALIDA_EDAD(cTipoDocIdentAseg, cNumDocIdentAseg, X.CodCia,
                                                      X.CodEmpresa, X.IdTipoSeg, X.PlanCob) = 'N' THEN
         RAISE_APPLICATION_ERROR(-20225,'Edad del Asegurado Fuera del Rango de Aceptación de Coberturas');
      END IF;

      nCod_Asegurado := OC_ASEGURADO.CODIGO_ASEGURADO(X.CodCia, X.CodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
      IF nCod_Asegurado = 0 THEN
         nCod_Asegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(X.CodCia, X.CodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
      END IF;
      --
      OC_CLIENTE_ASEG.INSERTA(nCodCliente, nCod_Asegurado);
      --
      cExisteTipoSeguro := OC_TIPOS_DE_SEGUROS.EXISTE_TIPO_DE_SEGURO(X.CodCia, X.CodEmpresa, X.IdTipoSeg);
      IF cExisteTipoSeguro = 'S' THEN
         BEGIN
            -- Inserta Tarea de Seguimiento
            IF OC_TAREA.EXISTE_TAREA(X.CodCia,nIdPoliza) = 'N' THEN
               OC_TAREA.INSERTA_TAREA(X.CodCia, 7, 'SOL', 'EMI', nIdPoliza, nCodCliente, 'A','SOL', 'SOLICITUD DE EMISION');
            END IF;
            -- Genera Detalle de Poliza
            nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
            BEGIN
               SELECT FecIniVig ,FecFinVig, StsPoliza
                 INTO dFecIniVig,dFecFinVig,cStsPoliza
                 FROM Polizas
                WHERE IdPoliza   = nIdPoliza
                  AND CodCia     = X.CodCia
                  AND CodEmpresa = X.CodEmpresa;
            END;

            IF cStsPoliza = 'SOL'  THEN
               IF OC_DETALLE_POLIZA.EXISTE_POLIZA_DETALLE(X.CodCia, X.CodEmpresa, nIdPoliza, TRIM(TO_CHAR(X.NumDetUnico))) = 'N' THEN
                  BEGIN
                     SELECT 'S'
                       INTO cExisteDet
                       FROM DETALLE_POLIZA
                      WHERE IdPoliza   = nIdPoliza
                        AND CodCia     = X.CodCia
                        AND CodEmpresa = X.CodEmpresa
                        AND IDetPol    = 1;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        cExisteDet := 'N';
                  END;
                  IF NVL(cExisteDet,'N') = 'S' THEN
                     RAISE_APPLICATION_ERROR(-20225,'Ya existe un Certificado, NO es Póliza Colectiva: ');
                  ELSE
                     nIDetPol    := OC_DETALLE_POLIZA.INSERTAR_DETALLE(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, nIdPoliza,
                                                                       nTasaCambio, nPorcComis, nCod_Asegurado, cCodPlanPago,
                                                                       TRIM(TO_CHAR(X.NumDetUnico)), cCodPromotor, dFecIniVig);
                  END IF;
               ELSE
                  BEGIN
                     SELECT IDetPol
                       INTO nIDetPol
                       FROM DETALLE_POLIZA
                      WHERE CodCia      = X.CodCia
                        AND CodEmpresa  = X.CodEmpresa
                        AND IdPoliza    = nIdPoliza
                        AND NumDetRef   = TRIM(TO_CHAR(X.NumDetUnico));
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        RAISE_APPLICATION_ERROR(-20225,'DETALLE POLIZA NO EXISTE: '|| TRIM(TO_CHAR(X.NumPolUnico)));
                  END;
               END IF;

               IF OC_COBERT_ACT.EXISTE_COBERTURA(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, nIdPoliza, nIDetPol) = 'N' THEN
                  --OC_COBERT_ACT.CARGAR_COBERTURAS(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, nIdPoliza, nIDetPol, nTasaCambio);
                  OC_COBERT_ACT.CARGAR_COBERTURAS(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, nIdPoliza,
                                                  nIDetPol, nTasaCambio, NULL, 0, 0, 0, 0, 99, 0, 0, 0, 0, 0, 0);
               END IF;

               OC_ASISTENCIAS_DETALLE_POLIZA.CARGAR_ASISTENCIAS(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, nIdPoliza,
                                                                nIDetPol, nTasaCambio, cCodMoneda, dFecIniVig, dFecFinVig);


               IF OC_AGENTES_DETALLES_POLIZAS.EXISTE_AGENTE (X.CodCia, nIdPoliza, nIDetPol, X.IdTipoSeg, nCod_Agente) = 'N' THEN
                  IF nCod_Agente IS NOT NULL THEN
                     IF OC_AGENTES.NIVEL_AGENTE(X.CodCia, nCod_Agente) = 5 THEN
                        cOrigen  := 'U';
                     ELSIF OC_AGENTES.NIVEL_AGENTE(X.CodCia, nCod_Agente) = 4 THEN
                        cOrigen  := 'H';
                     ELSE
                        cOrigen  := 'C';
                     END IF;
                     BEGIN
                        INSERT INTO AGENTE_POLIZA
                               (IdPoliza, CodCia, Cod_Agente, Porc_Comision, Ind_Principal, Origen)
                        VALUES (nIdPoliza, X.CodCia, nCod_Agente, 100, 'S', cOrigen);
                        OC_COMISIONES.DISTRIBUCION(X.CodCia, nIdPoliza, nCod_Agente, 100);
                        OC_AGENTES_DISTRIBUCION_POLIZA.COPIAR(X.CodCia, nIdPoliza);
                     EXCEPTION
                        WHEN DUP_VAL_ON_INDEX THEN
                           OC_COMISIONES.DISTRIBUCION(X.CodCia, nIdPoliza, nCod_Agente, 100);
                           OC_AGENTES_DISTRIBUCION_POLIZA.COPIAR(X.CodCia, nIdPoliza);
                        WHEN OTHERS THEN
                           RAISE_APPLICATION_ERROR(-20225,'Error en Distribución de Agentes ' || SQLERRM);
                     END;
                  END IF;
               END IF;

--               OC_POLIZAS.INSERTA_REQUISITOS(X.CodCia, nIdPoliza);     --REQ

               IF NVL(nBenef1,0) > 0 THEN
                  OC_BENEFICIARIO.INSERTA_BENEFICIARIO(nIdPoliza, nIDetPol, nCod_Asegurado, nBenef1, cNomBenef1,
                                                       nPorcePart1, cCodParent1, NULL, NULL, 'N');
               END IF;

               IF NVL(nBenef2,0) > 0 THEN
                  OC_BENEFICIARIO.INSERTA_BENEFICIARIO(nIdPoliza, nIDetPol, nCod_Asegurado, nBenef2, cNomBenef2,
                                                       nPorcePart2, cCodParent2, NULL, NULL, 'N');
               END IF;

               IF NVL(nBenef3,0) > 0 THEN
                  OC_BENEFICIARIO.INSERTA_BENEFICIARIO(nIdPoliza, nIDetPol, nCod_Asegurado, nBenef3, cNomBenef3,
                                                       nPorcePart3, cCodParent3, NULL, NULL, 'N');
               END IF;

               OC_DETALLE_POLIZA.ACTUALIZA_VALORES(X.CodCia, nIdPoliza, nIDetPol, 0);
               OC_POLIZAS.ACTUALIZA_VALORES(X.CodCia, nIdPoliza, 0);
            ELSE
               cMsjError := 'S';
               RAISE_APPLICATION_ERROR(-20225,'Póliza:'||TRIM(TO_CHAR(X.NumPolUnico)||' Debe estar en Estado SOL'));
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               cMsjError := SQLERRM;
         END;
         IF cMsjError = 'N'   THEN
            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'PROCE');
            IF NVL(X.IndColectiva,'N') = 'N' THEN
               OC_DETALLE_POLIZA.ACTUALIZA_VALORES(X.CodCia, nIdPoliza, nIDetPol, 0);
               OC_POLIZAS.ACTUALIZA_VALORES(X.CodCia, nIdPoliza, 0);
               OC_POLIZAS.EMITIR_POLIZA(X.CodCia, nIdPoliza, X.CodEmpresa);
            END IF;
         ELSE
            OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','No se puede emitir la Póliza: '||cMsjError);
            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
         END IF;
      ELSE
         OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
      END IF;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','No se puede emitir la Póliza Final: '||SQLERRM);
      OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END EMISION_QR;

PROCEDURE EMISION_INFONACOT(nIdProcMasivo NUMBER) IS
nCodCliente        CLIENTES.CODCLIENTE%TYPE;
cTipoDocIdentAseg  CLIENTES.TIPO_DOC_IDENTIFICACION%TYPE;
cNumDocIdentAseg   CLIENTES.Num_Doc_Identificacion%TYPE;
nCod_Asegurado     ASEGURADO.Cod_Asegurado%TYPE;
nCodCia            POLIZAS.CodCia%TYPE;
nCodEmpresa        POLIZAS.CodEmpresa%TYPE;
cCodmoneda         POLIZAS.Cod_Moneda%TYPE;
cPlanCob           PLAN_COBERTURAS.PlanCob%TYPE;
nIdPoliza          POLIZAS.IdPoliza%TYPE;
cIdTipoSeg         TIPOS_DE_SEGUROS.IdTipoSeg%TYPE;
nPorcComis         POLIZAS.PorcComis%TYPE;
cDescPoliza        POLIZAS.DescPoliza%TYPE;
nCod_Agente        POLIZAS.Cod_agente%TYPE;
cCodPlanPago       POLIZAS.CodPlanPago%TYPE;
nTasaCambio        DETALLE_POLIZA.Tasa_Cambio%TYPE;
nIDetPol           DETALLE_POLIZA.IDetPol%TYPE;
cIdGrupoTarj       TARJETAS_PREPAGO.IdGrupoTarj%TYPE;
cCodPromotor       DETALLE_POLIZA.CodPromotor%TYPE;
cMsjError          PROCESOS_MASIVOS_LOG.TxtError%TYPE := 'N';
cCodPlantilla      CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE;
cNomTabla          CONFIG_PLANTILLAS_CAMPOS.NomTabla%TYPE;
cCodFormaCobro     MEDIOS_DE_COBRO.CodFormaCobro%TYPE;
cStsPoliza         POLIZAS.StsPoliza%TYPE;
cNombreAseg        PERSONA_NATURAL_JURIDICA.Nombre%TYPE;
cApellidoPaterno   PERSONA_NATURAL_JURIDICA.Apellido_Paterno%TYPE;
cApellidoMaterno   PERSONA_NATURAL_JURIDICA.Apellido_Materno%TYPE;
cDirecRes          PERSONA_NATURAL_JURIDICA.DirecRes%TYPE;
cNumInterior       PERSONA_NATURAL_JURIDICA.NumInterior%TYPE;
cNumExterior       PERSONA_NATURAL_JURIDICA.NumExterior%TYPE;
cDescColonia       COLONIA.Descripcion_Colonia%TYPE;
cCodPosRes         PERSONA_NATURAL_JURIDICA.CodPosRes%TYPE;
cCodColonia        PERSONA_NATURAL_JURIDICA.CodColRes%TYPE;
cCodPaisRes        PERSONA_NATURAL_JURIDICA.CodPaisRes%TYPE;
cCodProvRes        PERSONA_NATURAL_JURIDICA.CodProvRes%TYPE;
cCodDistRes        PERSONA_NATURAL_JURIDICA.CodDistRes%TYPE;
cCodCorrRes        PERSONA_NATURAL_JURIDICA.CodCorrRes%TYPE;
cTelRes            PERSONA_NATURAL_JURIDICA.TelRes%TYPE;
cEmail             PERSONA_NATURAL_JURIDICA.Email%TYPE;
dFecNacimiento     PERSONA_NATURAL_JURIDICA.FecNacimiento%TYPE;
cSexo              PERSONA_NATURAL_JURIDICA.Sexo%TYPE;
cOrigen            AGENTE_POLIZA.Origen%TYPE;
nBenef1            BENEFICIARIO.Benef%TYPE;
cNomBenef1         BENEFICIARIO.Nombre%TYPE;
cDescParent        VALORES_DE_LISTAS.DescValLst%TYPE;
cCodParent1        BENEFICIARIO.CodParent%TYPE;
nPorcePart1        BENEFICIARIO.PorcePart%TYPE;
nBenef2            BENEFICIARIO.Benef%TYPE;
cNomBenef2         BENEFICIARIO.Nombre%TYPE;
cCodParent2        BENEFICIARIO.CodParent%TYPE;
nPorcePart2        BENEFICIARIO.PorcePart%TYPE;
nBenef3            BENEFICIARIO.Benef%TYPE;
cNomBenef3         BENEFICIARIO.Nombre%TYPE;
cCodParent3        BENEFICIARIO.CodParent%TYPE;
nPorcePart3        BENEFICIARIO.PorcePart%TYPE;
dFecEmision        POLIZAS.FecEmision%TYPE;
nOrden             NUMBER(10):= 1  ;
nOrdenInc          NUMBER(10) ;
cUpdate            VARCHAR2(4000);
dFecIniVig         DATE;
dFecFinVig         DATE;
dFecIniVigPol      DATE;
dFecFinVigPol      DATE;
cExisteParEmi      VARCHAR2(1);
cExiste            VARCHAR2(1);
cExisteDet         VARCHAR2(1);
cCadenaEspOrig     VARCHAR2(100) := 'áéíóúÀÁÂÃÄÅÈÉÊËÌÍÎÏÒÓÔÕÖÙÚÛÜ';
cCadenaNormal      VARCHAR2(100) := 'aeiouAAAAAAEEEEIIIIOOOOOUUUU';
cTipoMovimiento    VARCHAR2(2);
nPlazoCredito      NUMBER(5);
--  INFORE INI
W_ID_CREDITO       INFO_ALTBAJ.ID_CREDITO%TYPE;
W_ID_TRABAJADOR    INFO_ALTBAJ.ID_TRABAJADOR%TYPE;
W_PLAZO            INFO_ALTBAJ.PLAZO%TYPE;
W_FE_INICIO        INFO_ALTBAJ.FE_INICIO%TYPE;
W_CONTINUA         BOOLEAN;
W_COD_ERROR        VALORES_DE_LISTAS.CODVALOR%TYPE;
W_IDPOLIZA         DETALLE_POLIZA.IDPOLIZA%TYPE;
W_IDETPOL          DETALLE_POLIZA.IDETPOL%TYPE;
W_DIF_PLAZO        NUMBER;
W_MENSAJE_ERROR    VARCHAR2(2000);
W_GRABA            SAI_CAT_GENERAL.CAGE_VALOR_CORTO%TYPE;
GRABA              BOOLEAN;
-- INFORE FIN

/*DATOS_PART_EMISION*/
vDPE1     VARCHAR2(12);
vDPE2     VARCHAR2(9);
vDPE3     VARCHAR2(12);
vDPE4     VARCHAR2(14);
vDPE5     VARCHAR2(15);
vDPE6     VARCHAR2(33);
vDPE7     VARCHAR2(33);
vDPE8     VARCHAR2(33);
vDPE9     VARCHAR2(33);
vDPE10    VARCHAR2(13);
vDPE11    VARCHAR2(6);
vDPE12    VARCHAR2(16);
vDPE13    VARCHAR2(18);
vDPE14    VARCHAR2(13);
vDPE15    VARCHAR2(9);
vDPE16    VARCHAR2(15);
vDPE17    VARCHAR2(6);
vDPE18    VARCHAR2(19);
vDPE19    VARCHAR2(19);
vDPE20    VARCHAR2(155);
vDPE21    VARCHAR2(20);
vDPE22    VARCHAR2(8);
vDPE23    VARCHAR2(16);
vDPE24    VARCHAR2(15);

CURSOR C_CAMPOS_PART  IS
   SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.OrdenDatoPart
     FROM CONFIG_PLANTILLAS_CAMPOS C
    WHERE C.CodPlantilla = cCodPlantilla
      AND C.CodEmpresa   = nCodEmpresa
      AND C.CodCia       = nCodCia
      AND C.NomTabla     = 'DATOS_PART_EMISION'
      AND C.IndDatoPart  = 'S'
    ORDER BY OrdenDatoPart,OrdenCampo;

CURSOR EMI_Q IS
   SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
          NumDetUnico, RegDatosProc, TipoProceso, IndColectiva
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;
BEGIN
   FOR X IN EMI_Q LOOP
       --
      nCodCia           := X.CodCia;
      nCodempresa       := X.CodEmpresa;
      cTipoMovimiento    := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,17,','));  --INFO1

      IF cTipoMovimiento =  'A' THEN -- Altas
         BEGIN
            SELECT IdPoliza, FecIniVig, FecFinVig, StsPoliza
              INTO nIdPoliza, dFecIniVigPol, dFecFinVigPol, cStsPoliza
              FROM POLIZAS
             WHERE NumPolUnico = X.NumPolUnico
               AND CodCia      = X.CodCia
               AND CodEmpresa  = X.CodEmpresa
               AND StsPoliza   IN ('SOL','EMI');
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20100,'NO Existe la Póliza Unica No. '||X.NumPolUnico);
         END;
         cApellidoPaterno   := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,','));
         cApellidoMaterno   := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,7,','));
         cNombreAseg        := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,8,',')) || ' ' ||
                             LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,9,','));
         dFecNacimiento     := TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,10,',')),'RRRRMMDD');  --INFO1
         cSexo              := NVL(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,11,',')),'N');            --INFO1

         IF dFecNacimiento > dFecIniVigPol THEN
            RAISE_APPLICATION_ERROR(-20225,'La Fecha de Nacimiento no puede ser Mayor a la Fecha de Inicio de Vigencia de la Póliza - NO Procede Crearlo');
         END IF;

         IF cSexo NOT IN ('M','F') THEN  --INFO1
            RAISE_APPLICATION_ERROR(-20100,'Código de Sexo debe contener M o F . Favor de Corregir.');
         END IF;

         cTipoDocIdentAseg  := 'RFC'; -- Se Asigna Fijo 'RFC' porque Layout NO trae el campo
         cNumDocIdentAseg   := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,12,','));   --INFO1

         IF cCodPlanPago IS NULL THEN
            cCodPlanPago      := OC_TIPOS_DE_SEGUROS.PLAN_PAGOS(X.CodCia, X.CodEmpresa, X.IdTipoSeg);
         END IF;

         nCod_Agente        := OC_PLAN_COBERTURAS.CODIGO_AGENTE(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob);
         IF nCod_Agente = 0 THEN
            RAISE_APPLICATION_ERROR(-20100,'NO está Configurado el Código de Agente para el Tipo de Seguro ' || X.IdTipoSeg ||
                                    ' y Plan de Coberturas ' || X.PlanCob);
         END IF;

         dFecIniVig         := TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,14,',')),'RRRRMMDD');    --INFO1
         nPlazoCredito      := NVL(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,15,',')),0);        --INFO1
         IF nPlazoCredito > 0 THEN
            dFecFinVig      := ADD_MONTHS(dFecIniVig,nPlazoCredito);
         ELSE
            RAISE_APPLICATION_ERROR(-20100,'NO se Indica el Plazo del Crédito');
         END IF;

         IF dFecIniVig < dFecIniVigPol THEN
            RAISE_APPLICATION_ERROR(-20100,'Inicio de Vigencia del Crédito ' || TO_CHAR(dFecIniVig,'DD/MM/YYYY') ||
                                    ' está Fuera del Inicio de Vigencia de la Póliza ' || TO_CHAR(dFecIniVigPol,'DD/MM/YYYY'));
         ELSIF dFecFinVig > dFecFinVigPol THEN
            RAISE_APPLICATION_ERROR(-20100,'Fin de Vigencia del Crédito ' || TO_CHAR(dFecFinVig,'DD/MM/YYYY') ||
                                    ' está Fuera del Fin de Vigencia de la Póliza ' || TO_CHAR(dFecFinVigPol,'DD/MM/YYYY'));
         END IF;
         --
         cCodPlantilla     := OC_CONFIG_PLANTILLAS_PLANCOB.CODIGO_PLANTILLA(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, X.TipoProceso);

         IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(cTipoDocIdentAseg, cNumDocIdentAseg) = 'N' THEN
            OC_PERSONA_NATURAL_JURIDICA.INSERTAR_PERSONA(cTipoDocIdentAseg, cNumDocIdentAseg, cNombreAseg, cApellidoPaterno,
                                                         cApellidoMaterno, NULL, cSexo, NULL, dFecNacimiento, cDirecRes,
                                                         cNumInterior, cNumExterior, cCodPaisRes, cCodProvRes, cCodDistRes,
                                                         cCodCorrRes, cCodPosRes, cCodColonia, cTelRes, cEmail, NULL);
         END IF;

         nCodCliente := OC_CLIENTES.CODIGO_CLIENTE(cTipoDocIdentAseg, cNumDocIdentAseg);
         IF nCodCliente = 0  THEN
            nCodCliente    := OC_CLIENTES.INSERTAR_CLIENTE(cTipoDocIdentAseg,cNumDocIdentAseg);
         END IF;

         nCod_Asegurado := OC_ASEGURADO.CODIGO_ASEGURADO(X.CodCia, X.CodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
         IF nCod_Asegurado = 0 THEN
            nCod_Asegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(X.CodCia, X.CodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
         END IF;
         --
         OC_CLIENTE_ASEG.INSERTA(nCodCliente, nCod_Asegurado);
         --
         IF OC_TIPOS_DE_SEGUROS.EXISTE_TIPO_DE_SEGURO(X.CodCia, X.CodEmpresa, X.IdTipoSeg) = 'S' THEN
            BEGIN
               cCodMoneda  := OC_PLAN_COBERTURAS.MONEDA_PLANCOB(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob);
               nPorcComis  := OC_CONFIG_COMISIONES.PORCENTAJE_COMISION(X.CodCia, X.CodEmpresa, X.IdTipoSeg);

               -- Inserta Tarea de Seguimiento
               IF OC_TAREA.EXISTE_TAREA(X.CodCia,nIdPoliza) = 'N' THEN
                  OC_TAREA.INSERTA_TAREA(X.CodCia, 7, 'SOL', 'EMI', nIdPoliza, nCodCliente, 'A','SOL', 'SOLICITUD DE EMISION');
               END IF;
               -- Genera Detalle de Poliza
               nTasaCambio  := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
               cCodMoneda   := OC_PLAN_COBERTURAS.MONEDA_PLANCOB(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob);
               nPorcComis   := OC_CONFIG_COMISIONES.PORCENTAJE_COMISION(X.CodCia, X.CodEmpresa, X.IdTipoSeg);

               IF cStsPoliza = 'SOL'  THEN
                  nIDetPol    := OC_DETALLE_POLIZA.INSERTAR_DETALLE(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, nIdPoliza,
                                                                    nTasaCambio, nPorcComis, nCod_Asegurado, cCodPlanPago,
                                                                    TRIM(TO_CHAR(X.NumDetUnico)), cCodPromotor, dFecIniVig);
                  UPDATE DETALLE_POLIZA
                     SET FecFinVig = dFecFinVig
                   WHERE CodCia     = X.CodCia
                     AND CodEmpresa = X.CodEmpresa
                     AND IdPoliza   = nIdPoliza
                     AND IDetPol    = nIDetPol;

                  nOrden    := 1;
                  nOrdenInc := 0;

                  BEGIN
                    SELECT 'S'
                      INTO cExisteParEmi
                      FROM DATOS_PART_EMISION
                     WHERE CodCia    = X.CodCia
                       AND Idpoliza  = nIdPoliza
                       AND IdetPol   = nIDetPol;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                          cExisteParEmi := 'N';
                  END;

                  IF NVL(cExisteParEmi,'N') = 'N' THEN
                     INSERT INTO DATOS_PART_EMISION
                            (CodCia, IdPoliza, IDetPol, StsDatPart, FecSts)
                     VALUES (X.CodCia, nIdPoliza, nIDetPol, 'SOL', SYSDATE);
                  END IF;

                  FOR I IN C_CAMPOS_PART LOOP
                     nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + nOrden;
/*                     IF I.NomCampo != 'MESES PRIMA' THEN
                        cUpdate   := 'UPDATE '||'DATOS_PART_EMISION'||' '||'SET'||' '||'CAMPO'||I.OrdenDatoPart||'='||''''||
                                     LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc, nOrdenInc,','))||''''||' '||
                                     'WHERE IdPoliza = '||nIdPoliza||' '||'AND IDetPol = '||nIDetPol||' '||'AND CodCia = '||X.CodCia;
                     ELSE
                        -- Se Suman 3 Meses al Plazo del Crédito para el Cálculo de Prima
                        cUpdate   := 'UPDATE '||'DATOS_PART_EMISION'||' '||'SET'||' '||'CAMPO'||I.OrdenDatoPart||'='||''''||
                                     TRIM(TO_CHAR(nPlazoCredito+3))||''''||' '||
                                     'WHERE IdPoliza = '||nIdPoliza||' '||'AND IDetPol = '||nIDetPol||' '||'AND CodCia = '||X.CodCia;
                     END IF;
                     OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate);
                     nOrden := nOrden + 1;
                  END LOOP;
*/
                     ----------------------------NUEVA MODIFICACION XDS------------------------------------------------------------------
                     cUpdate :=  cUpdate ||  CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,','))||CHR(39) || ',';
                     nOrden  := nOrden + 1;
                  END LOOP;
                  --
                  SELECT RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 1),CHR(39)),CHR(39)),
                         RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 2),CHR(39)),CHR(39)),
                         RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 3),CHR(39)),CHR(39)),
                         RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 4),CHR(39)),CHR(39)),
                         RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 5),CHR(39)),CHR(39)),
                         RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 6),CHR(39)),CHR(39)),
                         RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 7),CHR(39)),CHR(39)),
                         RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 8),CHR(39)),CHR(39)),
                         RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 9),CHR(39)),CHR(39)),
                         RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 10),CHR(39)),CHR(39)),
                         RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 11),CHR(39)),CHR(39)),
                         RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 12),CHR(39)),CHR(39)),
                         RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 13),CHR(39)),CHR(39)),
                         RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 14),CHR(39)),CHR(39)),
                         RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 15),CHR(39)),CHR(39)),
                         RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 16),CHR(39)),CHR(39)),
                         RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 17),CHR(39)),CHR(39)),
                         RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 18),CHR(39)),CHR(39)),
                         RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 19),CHR(39)),CHR(39)),
                         RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 20),CHR(39)),CHR(39)),
                         RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 21),CHR(39)),CHR(39)),
                         RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 22),CHR(39)),CHR(39)),
                         RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 23),CHR(39)),CHR(39)),
                         RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 24),CHR(39)),CHR(39))--,
--                         RTRIM(LTRIM(REGEXP_SUBSTR(cUpdate,'[^,"]+', 1, 25),CHR(39)),CHR(39))   --INFO1
                    INTO vDPE1,  vDPE2,  vDPE3,  vDPE4,  vDPE5,
                         vDPE6,  vDPE7,  vDPE8,  vDPE9,  vDPE10,
                         vDPE11, vDPE12, vDPE13, vDPE14, vDPE15,
                         vDPE16, vDPE17, vDPE18, vDPE19, vDPE20,
                         vDPE21, vDPE22, vDPE23, vDPE24--, vDPE25    --INFO1
                    FROM DUAL;

                  UPDATE DATOS_PART_EMISION
                     SET CAMPO1  = vDPE1
                        ,CAMPO2  = vDPE2
                        ,CAMPO3  = vDPE3
                        ,CAMPO4  = vDPE4
                        ,CAMPO5  = vDPE5
                        ,CAMPO6  = vDPE6
                        ,CAMPO7  = vDPE7
                        ,CAMPO8  = vDPE8
                        ,CAMPO9  = vDPE9
                        ,CAMPO10 = vDPE10
                        ,CAMPO11 = vDPE11
                        ,CAMPO12 = vDPE12
                        ,CAMPO13 = vDPE13
                        ,CAMPO14 = vDPE14
                        ,CAMPO15 = vDPE15
                        ,CAMPO16 = vDPE16
                        ,CAMPO17 = vDPE17
                        ,CAMPO18 = vDPE18
                        ,CAMPO19 = vDPE19
                        ,CAMPO20 = vDPE20
                        ,CAMPO21 = vDPE21
                        ,CAMPO22 = vDPE22
                        ,CAMPO23 = vDPE23
                        ,CAMPO24 = vDPE24
--                        ,CAMPO25 = vDPE25    --INFO1
                        ,CAMPO26= TRIM(TO_CHAR(nPlazoCredito+3))
                   WHERE IdPoliza = nIdPoliza
                     AND IDetPol = nIDetPol
                     AND CodCia = X.CodCia;
                  --
                  ----------------------------NUEVA MODIFICACION XDS------------------------------------------------------------------
                  --
                  IF OC_COBERT_ACT.EXISTE_COBERTURA(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, nIdPoliza, nIDetPol) = 'N' THEN
                     --OC_COBERT_ACT.CARGAR_COBERTURAS(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, nIdPoliza, nIDetPol, nTasaCambio);
                     OC_COBERT_ACT.CARGAR_COBERTURAS(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, nIdPoliza,
                                                     nIDetPol, nTasaCambio, NULL, 0, 0, 0, 0, 99, 0, 0, 0, 0, 0, 0);
                  END IF;

                  OC_ASISTENCIAS_DETALLE_POLIZA.CARGAR_ASISTENCIAS(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, nIdPoliza,
                                                                   nIDetPol, nTasaCambio, cCodMoneda, dFecIniVig, dFecFinVig);

                  IF OC_AGENTES_DETALLES_POLIZAS.EXISTE_AGENTE(X.CodCia, nIdPoliza, nIDetPol, X.IdTipoSeg, nCod_Agente) = 'N' THEN
                     IF nCod_Agente IS NOT NULL THEN
                        OC_AGENTES_DISTRIBUCION_POLIZA.COPIAR_DETALLE(X.CodCia, nIdPoliza, nIDetPol);
                     END IF;
                  END IF;

                  OC_DETALLE_POLIZA.ACTUALIZA_VALORES(X.CodCia, nIdPoliza, nIDetPol, 0);
--                  OC_POLIZAS.ACTUALIZA_VALORES(X.CodCia, nIdPoliza, 0);
               ELSE
                  cMsjError := 'S';
                  RAISE_APPLICATION_ERROR(-20225,'Póliza:'||TRIM(TO_CHAR(X.NumPolUnico)||' Debe estar en Estado SOL'));
               END IF;
            EXCEPTION
               WHEN OTHERS THEN
                  cMsjError := SQLERRM;
            END;
            IF cMsjError = 'N'   THEN
               OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'PROCE');
            ELSE
               OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Error: '||cMsjError);
               OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
            END IF;
         ELSE
            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
         END IF;
      ELSIF cTipoMovimiento =  'C' THEN
         --   INFODEV   INICIO
         W_ID_CREDITO    := NVL(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,4,',')),0);
         W_ID_TRABAJADOR := NVL(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,5,',')),0);
         W_CONTINUA      := TRUE;

         BEGIN
           SELECT IA.IDPOLIZA,
                  IA.IDETPOL
             INTO W_IDPOLIZA,
                  W_IDETPOL
             FROM INFO_ALTBAJ IA
            WHERE IA.ID_CREDITO      = W_ID_CREDITO
              AND IA.ID_TRABAJADOR   = W_ID_TRABAJADOR
              AND IA.TIPO_MOVIMIENTO = 'A';
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
                W_CONTINUA  := FALSE;
                W_COD_ERROR := 10;
           WHEN TOO_MANY_ROWS THEN
                W_CONTINUA  := FALSE;
                W_COD_ERROR := 11;
         END;

         IF W_CONTINUA THEN
            CANCELA_INFONACOT(X.CodCia, X.CodEmpresa,W_IDPOLIZA,W_IDETPOL,W_ID_CREDITO,W_MENSAJE_ERROR);
            IF W_MENSAJE_ERROR IS NOT NULL THEN
               W_CONTINUA  := FALSE;
            END IF;
         END IF;

         IF W_CONTINUA THEN
            NULL;
         ELSE
            UPDATE INFO_ALTBAJ IA
               SET IA.CODERRORCARGA = W_COD_ERROR
             WHERE IA.ID_CREDITO      = W_ID_CREDITO
               AND IA.ID_TRABAJADOR   = W_ID_TRABAJADOR
               AND IA.TIPO_MOVIMIENTO = cTipoMovimiento;

            RAISE_APPLICATION_ERROR(-20225,'Tipo de Movimiento: '||cTipoMovimiento||' ERROR -'||W_MENSAJE_ERROR);
            cMsjError := 'S';
         END IF;

         IF cMsjError = 'N'   THEN
            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'PROCE');
         ELSE
            OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Error: '||cMsjError);
            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
         END IF;
         -- INFODEV  FIN
      ELSIF cTipoMovimiento =  'R' THEN
            RAISE_APPLICATION_ERROR(-20225,'Tipo de Movimiento: '||cTipoMovimiento||' Se procesa por otra via');
      ELSE
         RAISE_APPLICATION_ERROR(-20225,'Tipo de Movimiento: '||cTipoMovimiento||' con error no identificado');
      END IF;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Error: '||SQLERRM);
      OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END EMISION_INFONACOT;

PROCEDURE CANCELA_INFONACOT(p_CodCia NUMBER, p_CodEmpresa NUMBER, p_IdPoliza NUMBER,
                            p_IDetPol NUMBER, p_ID_Credito NUMBER, p_Mensaje_Error OUT VARCHAR2) IS

W_IDPOLIZA       DETALLE_POLIZA.IDPOLIZA%TYPE;
W_IDETPOL        DETALLE_POLIZA.IDETPOL%TYPE;
W_FECINIVIG      DETALLE_POLIZA.FECINIVIG%TYPE;
W_FECFINVIG      DETALLE_POLIZA.FECFINVIG%TYPE;
W_CODPLANPAGO    DETALLE_POLIZA.CODPLANPAGO%TYPE;
W_PRIMA_LOCAL    DETALLE_POLIZA.PRIMA_LOCAL%TYPE;
W_PORCCOMIS      DETALLE_POLIZA.PORCCOMIS%TYPE;
W_COD_ASEGURADO  DETALLE_POLIZA.COD_ASEGURADO%TYPE;
W_NOM_ASEGURADO  VARCHAR2(200);
W_IDENDOSO       ENDOSOS.IDENDOSO%TYPE;
W_CODCIA         DETALLE_POLIZA.CODCIA%TYPE;
W_CODEMPRESA     DETALLE_POLIZA.CODEMPRESA%TYPE;
W_ID_CREDITO     INFO_ALTBAJ.ID_CREDITO%TYPE;
W_CONTINUA       BOOLEAN;
W_MENSAJE_ERROR  VARCHAR2(2000);
BEGIN
  W_CODCIA     := p_CodCia;
  W_CODEMPRESA := p_CodEmpresa;
  W_IDPOLIZA   := p_IdPoliza;
  W_IDETPOL    := p_IDetPol;
  W_ID_CREDITO := p_ID_Credito;
  W_CONTINUA   := TRUE;

  BEGIN
   SELECT DP.FECINIVIG,
          DP.FECFINVIG,
          DP.CODPLANPAGO,
          DP.PRIMA_LOCAL,
          DP.PORCCOMIS,
          DP.COD_ASEGURADO,
          SUBSTR(OC_ASEGURADO.NOMBRE_ASEGURADO(DP.CODCIA,DP.CODEMPRESA,DP.COD_ASEGURADO),1,200)
     INTO W_FECINIVIG,
          W_FECFINVIG,
          W_CODPLANPAGO,
          W_PRIMA_LOCAL,
          W_PORCCOMIS,
           W_COD_ASEGURADO,
          W_NOM_ASEGURADO
     FROM DETALLE_POLIZA DP
    WHERE IDPOLIZA = W_IDPOLIZA
      AND IDETPOL  = W_IDETPOL
      AND CODCIA   = W_CODCIA;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         W_MENSAJE_ERROR := 'NO HAY DETALLE DE POLIZA';
         W_CONTINUA   := FALSE;
    WHEN OTHERS THEN
         W_MENSAJE_ERROR := 'PROBLEMAS EN DETALLE DE POLIZA';
         W_CONTINUA   := FALSE;
  END;

  -- ANULA CERTIFICADO
  IF W_CONTINUA THEN
     UPDATE DETALLE_POLIZA DP
        SET DP.STSDETALLE = 'ANU',
            DP.FECANUL    = TRUNC(SYSDATE),
            DP.MOTIVANUL  = 'SOLCON'
      WHERE IDPOLIZA = W_IDPOLIZA
        AND IDETPOL  = W_IDETPOL
        AND CODCIA   = W_CODCIA;

     IF sqlcode <> 0 THEN
        W_CONTINUA      := FALSE;
        W_MENSAJE_ERROR := 'CERTIFICADO -  ERROR AL ANULAR DETALLE';
     END IF;
  END IF;

  IF W_CONTINUA THEN
     OC_COBERT_ACT.ANULAR(W_CODCIA, W_CODEMPRESA, W_IDPOLIZA, W_IDETPOL);

     IF sqlcode <> 0 THEN
        W_CONTINUA      := FALSE;
        W_MENSAJE_ERROR := 'CERTIFICADO -  ERROR AL ANULAR COBERT_ACT';
     END IF;
  END IF;
  IF W_CONTINUA THEN
     OC_ASISTENCIAS_DETALLE_POLIZA.ANULAR(W_CODCIA, W_CODEMPRESA, W_IDPOLIZA, W_IDETPOL);

     IF sqlcode <> 0 THEN
        W_CONTINUA      := FALSE;
        W_MENSAJE_ERROR := 'CERTIFICADO -  ERROR AL ANULAR ASISTENCIAS';
     END IF;
  END IF;
  IF W_CONTINUA THEN
     OC_BENEFICIARIO.ANULAR(W_IDPOLIZA, W_IDETPOL, W_COD_ASEGURADO);

     IF sqlcode <> 0 THEN
        W_CONTINUA      := FALSE;
        W_MENSAJE_ERROR := 'CERTIFICADO -  ERROR AL ANULAR BENEFICIARIO';
     END IF;
  END IF;

  -- EMITE ENDOSO DE DEVOLUCION
  SELECT NVL(MAX(IDENDOSO),0) + 1
    INTO W_IDENDOSO
    FROM ENDOSOS
   WHERE IDPOLIZA = W_IDPOLIZA;
  --
  IF W_CONTINUA THEN
     INSERT INTO ENDOSOS
           (IDPOLIZA, IDENDOSO, TIPOENDOSO, NUMENDREF, FECINIVIG, FECFINVIG,
            FECSOLICITUD, FECEMISION, STSENDOSO, FECSTS, CODPLANPAGO, FECANUL,
            MOTIVANUL, SUMA_ASEG_LOCAL, SUMA_ASEG_MONEDA, PRIMA_NETA_LOCAL,
            DESCENDOSO, PRIMA_NETA_MONEDA, PORCCOMIS, CODEMPRESA, CODCIA,
            IDETPOL, NUM_BIEN, MOTIVO_ENDOSO, FECEXC,INDCALCDERECHOEMIS)
     VALUES(W_IDPOLIZA, W_IDENDOSO, 'NSS', W_IDENDOSO, W_FECINIVIG, W_FECFINVIG,
            TRUNC(SYSDATE), TRUNC(SYSDATE),  'EMI', TRUNC(SYSDATE), W_CODPLANPAGO, '',
            '', 0,  0, W_PRIMA_LOCAL,
            '', W_PRIMA_LOCAL, W_PORCCOMIS, W_CODEMPRESA, W_CODCIA,
            W_IDETPOL, '', '990', '', 'N');
     IF sqlcode <> 0 THEN
        W_CONTINUA      := FALSE;
        W_MENSAJE_ERROR := 'DEVOLUCION -  ERROR AL EMITIR ENDOSO';
     END IF;
  END IF;

  IF W_CONTINUA THEN
     INSERT INTO ENDOSO_TEXTO
           (IDPOLIZA, IDENDOSO, TEXTO )
     VALUES(W_IDPOLIZA, W_IDENDOSO,
            'POR MEDIO DEL PRESENTE ENDOSO, SE HACE CONSTAR QUE SE REALIZA LA BAJA DEL CERTIFICADO '||W_IDETPOL||
            ' A NOMBRE DE '||W_NOM_ASEGURADO||
            ' CON NUMERO DE CREDITO '||W_ID_CREDITO||
            ', LO ANTERIOR ES A SOLICITUD DEL CONTRATANTE POR CREDITO CANCELADO.');

     IF sqlcode <> 0 THEN
        W_CONTINUA      := FALSE;
        W_MENSAJE_ERROR := 'DEVOLUCION -  ERROR AL EMITIR TEXTO ENDOSO';
     END IF;
  END IF;

  -- GENERA NOTA DE CREDITO
  IF W_CONTINUA THEN
     OC_ENDOSO.EMITIR(W_CODCIA, W_CODEMPRESA, W_IDPOLIZA, W_IDETPOL, W_IDENDOSO, 'NSS');
     IF sqlcode <> 0 THEN
        W_CONTINUA      := FALSE;
        W_MENSAJE_ERROR := 'NOTA CRED -  ERROR AL EMITIR NOTA CRED';
     END IF;
  END IF;

  IF W_CONTINUA THEN
     NULL;
  ELSE
     p_Mensaje_Error := sqlcode||' - '||W_MENSAJE_ERROR;
  END IF;
END CANCELA_INFONACOT;   --FIN INFODEV
--
PROCEDURE COPIA_COBERT_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                                 nIdEndoso NUMBER, cEstado VARCHAR2, nCodAsegurado NUMBER) IS

nCodAseg      ASEGURADO_CERTIFICADO.Cod_Asegurado%TYPE;

CURSOR C_COB IS
  SELECT IdTipoSeg, CodCobert, SumaAseg_Local, SumaAseg_Moneda, TipoRef,
         NumRef, PlanCob, Cod_Moneda, Deducible_Local, Deducible_Moneda
    FROM COBERT_ACT_ASEG
   WHERE CodCia        = nCodCia
     AND CodEmpresa    = nCodEmpresa
     AND IdPoliza      = nIdPoliza
     AND IDetPol       = nIDetPol
     AND Cod_Asegurado = nCodAseg;

CURSOR C_ASIS IS
  SELECT CodAsistencia, CodMoneda, MontoAsistLocal, MontoAsistMoneda,
         StsAsistencia, FecSts
    FROM ASISTENCIAS_ASEGURADO
   WHERE CodCia        = nCodCia
     AND CodEmpresa    = nCodEmpresa
     AND IdPoliza      = nIdPoliza
     AND IDetPol       = nIDetPol
     AND Cod_Asegurado = nCodAseg;
BEGIN
  BEGIN
    SELECT NVL(MIN(COD_ASEGURADO),0)
      INTO nCodAseg
      FROM ASEGURADO_CERTIFICADO
     WHERE IdPoliza = nIdPoliza
       AND IDetPol  = nIDetPol
       AND IdEndoso = 0;
  EXCEPTION
    WHEN OTHERS THEN
      nCodAseg := 0;
  END;
  IF nCodAseg > 0 THEN
     -- SE COPIAN LAS COBERT_ACT_ASEG
     FOR Y IN C_COB LOOP
       BEGIN
         INSERT INTO COBERT_ACT_ASEG
               (IdPoliza, IDetPol, CodEmpresa, IdTipoSeg, CodCia, CodCobert, StsCobertura,
                SumaAseg_Local, SumaAseg_Moneda, Prima_Local, Prima_Moneda, Tasa, IdEndoso, TipoRef, NumRef,
                PlanCob, Cod_Moneda, Deducible_Local, Deducible_Moneda, Cod_Asegurado)
         VALUES(nIdPoliza, nIDetPol, nCodEmpresa, Y.IdTipoSeg, nCodCia, Y.CodCobert, cEstado,
                Y.SumaAseg_Local, Y.SumaAseg_Moneda, 0, 0, 0, nIdEndoso, Y.TipoRef, Y.NumRef,
                Y.PlanCob, Y.Cod_Moneda, Y.Deducible_Local, Y.Deducible_Moneda, nCodAsegurado);
       EXCEPTION
         WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Cobertura del Asegurado Modelo en COBERT_ACT_ASEG: '||SQLERRM);
       END;
     END LOOP;
     -- SE COPIAN LAS ASISTENCIAS DEL ASEGURADO
     FOR J IN C_ASIS LOOP
       BEGIN
         INSERT INTO ASISTENCIAS_ASEGURADO
               (CodCia, CodEmpresa, IdPoliza, IDetPol, Cod_Asegurado, CodAsistencia,
                CodMoneda, MontoAsistLocal, MontoAsistMoneda, StsAsistencia,
                FecSts, IdEndoso)
         VALUES (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, J.CodAsistencia,
                 J.CodMoneda, 0, 0, DECODE(cEstado,'EMI','EMITID','SOLICI'),
                 TRUNC(SYSDATE), nIdEndoso);
       EXCEPTION
         WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Cobertura del Asegurado Modelo en ASISTENCIAS_ASEGURADO: '||SQLERRM);
       END;
     END LOOP;
     BEGIN
       OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado);
       OC_ASEGURADO_CERTIFICADO.ACTUALIZA_ASISTENCIAS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado);
       OC_ENDOSO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso);
       OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, nIDetPol, 0);
       OC_POLIZAS.ACTUALIZA_VALORES(nCodCia, nIdPoliza, 0);
     END;
  ELSE
     RAISE_APPLICATION_ERROR(-20225,'Error, No existe un Asegurado que herede las Coberturas: '||SQLERRM);
  END IF;
END COPIA_COBERT_ASEGURADO;

PROCEDURE CREA_ASEG_ESTIM_SINI(nIdProcMasivo NUMBER) IS
nIdPoliza          POLIZAS.IdPoliza%TYPE;
cStsPoliza         POLIZAS.StsPoliza%TYPE;
dFecIniVig         POLIZAS.FecIniVig%TYPE;
dFecFinVig         POLIZAS.FecFinVig%TYPE;
cCodPlanPago       POLIZAS.CodPlanPago%TYPE;
nIDetPol           DETALLE_POLIZA.IDetPol%TYPE;
cStsDetalle        DETALLE_POLIZA.StsDetalle%TYPE;
cIndSinAseg        DETALLE_POLIZA.IndSinAseg%TYPE;
nTasaCambio        DETALLE_POLIZA.Tasa_Cambio%TYPE;
nIdEndoso          ENDOSOS.IdEndoso%TYPE;
nCodCliente        CLIENTE_ASEG.CodCliente%TYPE;
nCod_Asegurado     ASEGURADO.Cod_Asegurado%TYPE;
cNombreAseg        PERSONA_NATURAL_JURIDICA.Nombre%TYPE;
cApPaternoAseg     PERSONA_NATURAL_JURIDICA.Apellido_Paterno%TYPE;
cApMaternoAseg     PERSONA_NATURAL_JURIDICA.Apellido_Materno%TYPE;
cNumDocIdentif     PERSONA_NATURAL_JURIDICA.Num_Doc_Identificacion%TYPE;
dFecNacimiento     PERSONA_NATURAL_JURIDICA.FecNacimiento%TYPE;
cTipoPersona       PERSONA_NATURAL_JURIDICA.Tipo_Persona%TYPE := 'FISICA';
cTipoDocIdentif    PERSONA_NATURAL_JURIDICA.Tipo_Doc_Identificacion%TYPE := 'RFC';
nIdSolicitud       SOLICITUD_EMISION.IdSolicitud%TYPE;
cMsjError          PROCESOS_MASIVOS_LOG.TxtError%TYPE := NULL;
cCodPlantilla      CONFIG_PLANTILLAS.CodPlantilla%TYPE := 'EMITESINIESTRO';
cTipoSeparador     VARCHAR2(1);
dFec_Ocurrencia    SINIESTRO.Fec_Ocurrencia%TYPE;
dFecAnul           POLIZAS.FECANUL%TYPE;
cMotivAnul         POLIZAS.MOTIVANUL%TYPE;

CURSOR EMI_Q IS
   SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
          TO_NUMBER(NumDetUnico) NumDetUnico, RegDatosProc, TipoProceso,IndColectiva
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;
BEGIN
   FOR X IN EMI_Q LOOP
     cMsjError := NULL;
     nCod_Asegurado := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,',')));
     cNombreAseg    := UPPER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,7,',')));
     cApPaternoAseg := UPPER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,8,',')));
     cApMaternoAseg := UPPER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,9,',')));
     dFecNacimiento := TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,10,',')),'YYYYMMDD');
     nCodCliente    := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,3,',')));

     BEGIN
       SELECT P.IdPoliza, P.FecIniVig, P.FecFinVig, P.CodPlanPago, DP.IDetPol, P.StsPoliza, DP.StsDetalle,
              DP.IndSinAseg, DP.Tasa_Cambio, P.FecAnul, P.MotivAnul
         INTO nIdPoliza, dFecIniVig, dFecFinVig, cCodPlanPago, nIDetPol, cStsPoliza, cStsDetalle,
              cIndSinAseg, nTasaCambio, dFecAnul, cMotivAnul
         FROM POLIZAS P, DETALLE_POLIZA DP
        WHERE P.NumPolUnico = X.NumPolUnico
          AND P.CodCia      = X.CodCia
          AND P.CodEmpresa  = X.CodEmpresa
          AND P.StsPoliza   IN ('REN','EMI','ANU')
          AND P.CodCliente  = nCodCliente
          AND P.IdPoliza  = DP.IdPoliza
          AND DP.IDetPol  = X.NumDetUnico;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
          nIdPoliza := 0;
       WHEN TOO_MANY_ROWS THEN
          BEGIN
             SELECT P.IdPoliza, P.FecIniVig, P.FecFinVig, P.CodPlanPago, DP.IDetPol, P.StsPoliza, DP.StsDetalle,
                    DP.IndSinAseg, DP.Tasa_Cambio, P.FecAnul, P.MotivAnul
               INTO nIdPoliza, dFecIniVig, dFecFinVig, cCodPlanPago, nIDetPol, cStsPoliza, cStsDetalle,
                    cIndSinAseg, nTasaCambio, dFecAnul, cMotivAnul
               FROM POLIZAS P, DETALLE_POLIZA DP
              WHERE P.NumPolUnico = X.NumPolUnico
                AND P.CodCia      = X.CodCia
                AND P.CodEmpresa  = X.CodEmpresa
                AND P.StsPoliza   IN ('REN','EMI')
                AND P.CodCliente  = nCodCliente
                AND P.IdPoliza  = DP.IdPoliza
                AND DP.IDetPol  = X.NumDetUnico;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                nIdPoliza := 0;
          END;
     END;

     IF OC_POLIZAS.EXISTE_POLIZA(X.CodCia, X.CodEmpresa, nIdPoliza) = 'S' THEN
        -- Valida la fecha de Anulacion y el motivo sea diferente a Falta de Pago
        IF dFecNacimiento > dFecIniVig THEN
           RAISE_APPLICATION_ERROR(-20225,'La Fecha de Nacimiento no puede ser mayor a la fecha de inicio de Vigencia de la Poliza - NO Procede Crearlo');
        END IF;
        --
        IF cStsPoliza = 'ANU' THEN
           dFec_Ocurrencia   := TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,15,',')),'YYYYMMDD');
           IF dFecAnul IS NOT NULL AND cMotivAnul != 'FPA' THEN
              RAISE_APPLICATION_ERROR(-20225,'Póliza Anulada por Motivo diferente a Falta de Pago - NO Procede Crearlo');
           ELSIF dFec_Ocurrencia > dFecAnul AND cMotivAnul = 'FPA' THEN
                 RAISE_APPLICATION_ERROR(-20225,'Póliza Anulada, la fecha de Ocurrencia es mayor a la Fecha de Anulacion - NO Procede Crearlo');
           END IF;
        END IF;
        -- Si el Asegurado no Existe.
        IF NVL(nCod_Asegurado,0) = 0 THEN
           -- Calcula el RFC.
           cNumDocIdentif := OC_PERSONA_NATURAL_JURIDICA.NUMERO_TRIBUTARIO_RFC(cNombreAseg, cApPaternoAseg, cApMaternoAseg, dFecNacimiento, cTipoPersona);
           -- Si Existe Persona
           IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(cTipoDocIdentif, cNumDocIdentif) = 'N' THEN
              OC_PERSONA_NATURAL_JURIDICA.INSERTAR_PERSONA(cTipoDocIdentif, cNumDocIdentif, cNombreAseg, cApPaternoAseg, cApMaternoAseg, NULL, 'N', 'N',
                                                           dFecNacimiento, NULL, 1, NULL, '001', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
           END IF;
           -- Valida si la Edad corrsponde con el Plan Contratado
           IF OC_PERSONA_NATURAL_JURIDICA.FUNC_VALIDA_EDAD(cTipoDocIdentif, cNumDocIdentif, X.CodCia, X.CodEmpresa ,X.IdTipoSeg ,X.PlanCob)= 'N' THEN
              RAISE_APPLICATION_ERROR(-20225,'Edad del Asegurado Fuera del Rango de Aceptación de Coberturas');
           END IF;
           -- Obtiene el Número de Asegurado
           nCod_Asegurado := OC_ASEGURADO.CODIGO_ASEGURADO(X.CodCia, X.CodEmpresa, cTipoDocIdentif, cNumDocIdentif);
           -- Inserta el Asegurado.
           IF nCod_Asegurado = 0 THEN
              nCod_Asegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(X.CodCia, X.CodEmpresa,cTipoDocIdentif, cNumDocIdentif);
           END IF;
           -- Inserta el Asegurado ligado al Contratante
           BEGIN
             INSERT INTO CLIENTE_ASEG
                   (CodCliente, Cod_Asegurado)
             VALUES(nCodCliente, nCod_Asegurado);
           EXCEPTION
             WHEN DUP_VAL_ON_INDEX THEN
               cMsjError := 'Asegurado: ' || nCod_Asegurado || ' Duplicado en Cliente_Aseg.';
           END;
           -- Valida el Status Poliza para Crear Endoso
           IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(X.CodCia, nIdpoliza, nIDetPol, nCod_Asegurado) = 'N' THEN
              IF cStsPoliza = 'SOL' OR cStsDetalle = 'SOL' THEN
                 OC_ASEGURADO_CERTIFICADO.INSERTA(X.CodCia, nIdpoliza, nIDetPol, nCod_Asegurado, 0);
              ELSE
                 SELECT NVL(MAX(IdEndoso),0)
                   INTO nIdEndoso
                   FROM ENDOSOS
                  WHERE CodCia     = X.CodCia
                    AND IdPoliza   = nIdPoliza
                    AND StsEndoso  = 'SOL';

                 IF NVL(nIdEndoso,0) = 0 THEN
                    nIdEndoso := OC_ENDOSO.CREAR(nIdPoliza);
                    OC_ENDOSO.INSERTA (X.CodCia, X.CodEmpresa, nIdPoliza, nIDetPol, nIdEndoso,
                                       'ESV', 'ENDO-' || TRIM(TO_CHAR(nIdPoliza)) || '-' || TRIM(TO_CHAR(nIdEndoso)),
                                       dFecIniVig, dFecFinVig, cCodPlanPago, 0, 0, 0, '010', NULL);
                 END IF;
                 OC_ASEGURADO_CERTIFICADO.INSERTA(X.CodCia, nIdpoliza, nIDetPol, nCod_Asegurado, nIdEndoso);
              END IF;
           ELSE
              cMsjError := 'Asegurado No. : ' || nCod_Asegurado || ' Duplicado en Certificado No. ' || nIDetPol;
           END IF;
           -- Validar Coberturas
           IF OC_COBERT_ACT_ASEG.EXISTE_COBERTURA(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob,
                                                  nIdPoliza, nIDetPol, nCod_Asegurado) = 'N' THEN

              nIdSolicitud := OC_SOLICITUD_EMISION.SOLICITUD_POLIZA(X.CodCia, X.CodEmpresa, nIdPoliza);

              IF NVL(cIndSinAseg,'N') = 'N' THEN
                 IF NVL(nIdSolicitud,0) = 0 THEN
                    --OC_COBERT_ACT_ASEG.CARGAR_COBERTURAS(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob,
                    --                                     nIdPoliza, nIDetPol, nTasaCambio, nCod_Asegurado);
                    OC_PROCESOS_MASIVOS.COPIA_COBERT_ASEGURADO(X.CodCia, X.CodEmpresa,nIdPoliza, nIDetPol,
                                                               nIdEndoso, 'SOL', nCod_Asegurado);
                    ------- ----- -- - - -- PROCESO_ESPECIAL DE HEREDAR COBERTURA Y ASISTENCIAS
                 ELSE
                    OC_SOLICITUD_COBERTURAS.TRASLADA_COBERTURAS(X.CodCia, X.CodEmpresa, nIdSolicitud, nIdPoliza, nIDetPol, nCod_Asegurado);
                    OC_SOLICITUD_ASISTENCIAS.TRASLADA_ASISTENCIAS(X.CodCia, X.CodEmpresa, nIdSolicitud, nIdPoliza, nIDetPol, nCod_Asegurado);
                    -- Actualizar valores del Asegurado
                    OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(X.CodCia, X.CodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado);
                    OC_ASEGURADO_CERTIFICADO.ACTUALIZA_ASISTENCIAS(X.CodCia, X.CodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado);
                    OC_ENDOSO.ACTUALIZA_VALORES(X.CodCia, X.CodEmpresa, nIdPoliza, nIDetPol, nIdEndoso);
                    OC_DETALLE_POLIZA.ACTUALIZA_VALORES(X.CodCia, nIdPoliza, nIDetPol, 0);
                    OC_POLIZAS.ACTUALIZA_VALORES(X.CodCia, nIdPoliza, 0);
                 END IF;
              END IF;
           END IF;
           -- Asignar Endoso a COBERTURAS y deja en Ceros las Primas de TODAS las coberturas Creadas.
           BEGIN
             IF NVL(nIdEndoso,0) != 0 THEN
                UPDATE COBERT_ACT_ASEG
                   SET IdEndoso = nIdEndoso,
                       Prima_Moneda = 0,
                       Prima_Local  = 0
                 WHERE CodCia        = X.CodCia
                   AND IdPoliza      = nIdPoliza
                   AND IDetPol       = nIDetPol
                   AND Cod_Asegurado = nCod_Asegurado;
             ELSE
                UPDATE COBERT_ACT_ASEG
                   SET Prima_Moneda = 0,
                       Prima_Local  = 0
                 WHERE CodCia        = X.CodCia
                   AND IdPoliza      = nIdPoliza
                   AND IDetPol       = nIDetPol
                   AND Cod_Asegurado = nCod_Asegurado;
             END IF;
           EXCEPTION
             WHEN OTHERS THEN
               cMsjError := 'Error al actualizar las Coberturas. ' || SQLERRM;
           END;
           -- Asignar Código de Asegurado al registro/Layout.
           BEGIN
             SELECT DECODE(TRIM(TipoSeparador),'COM',',','PIPE','|')
               INTO cTipoSeparador
               FROM CONFIG_PLANTILLAS
              WHERE CodPlantilla = cCodPlantilla
                AND CodEmpresa   = X.CodEmpresa
                AND CodCia       = X.CodCia;
           EXCEPTION
             WHEN OTHERS THEN
               cMsjError := 'No Existe Separador para la Plantilla: ' || cCodPlantilla || ' Error ' || SQLERRM;
           END;
           BEGIN
             UPDATE PROCESOS_MASIVOS
                SET RegDatosProc = INSERTA_VALOR_CAMPO(X.RegDatosProc, 6, cTipoSeparador, nCod_Asegurado)
              WHERE IdProcMasivo   = nIdProcMasivo;
           EXCEPTION
             WHEN OTHERS THEN
               cMsjError := 'Error al Actualizar PROCESOS_MASIVOS: '|| SQLERRM;
           END;
        ELSE
           IF OC_ASEGURADO.NOMBRE_ASEGURADO(X.CodCia,X.CodEmpresa,nCod_Asegurado) LIKE '%ASEGURADO%' THEN
              RAISE_APPLICATION_ERROR(-20225,'El código de Asegurado es de un Asegurado Modelo.');
           END IF;
        END IF;
     ELSE
        cMsjError := 'No Existe la Póliza No. ' || X.NumPolUnico || ' con el Subgrupo ' || X.NumDetUnico;
     END IF;

     IF cMsjError IS NULL THEN
        OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'XPROC');
     ELSE
        OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','No se puede Crear el Asegurado para el Siniestro: '||cMsjError);
        OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERRASE');
     END IF;
   END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','CREA_ASEG_ESTIM_SINI Error - No se puede Cargar el Siniestro '|| SQLERRM);
    OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERRASE');
END CREA_ASEG_ESTIM_SINI;

PROCEDURE EMITIR_POLIZA_ESTIM_SINI(nIdProcMasivo NUMBER) IS
nIdPoliza              POLIZAS.IdPoliza%TYPE;
nIDetPol               DETALLE_POLIZA.IDetPol%TYPE;
nIdEndoso              ENDOSOS.IdEndoso%TYPE;
nCod_Asegurado         ASEGURADO.Cod_Asegurado%TYPE;
nCodCliente            CLIENTE_ASEG.CodCliente%TYPE;
cStsEndoso             ENDOSOS.StsEndoso%TYPE;
cTipoEndoso            ENDOSOS.TipoEndoso%TYPE;
cMsjError              PROCESOS_MASIVOS_LOG.TxtError%TYPE := NULL;
dFec_Ocurrencia        SINIESTRO.Fec_Ocurrencia%TYPE;
dFecAnul               POLIZAS.FECANUL%TYPE;
cMotivAnul             POLIZAS.MOTIVANUL%TYPE;
cStsPoliza             POLIZAS.STSPOLIZA%TYPE;

CURSOR EMI_Q IS
   SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
          TO_NUMBER(NumDetUnico) NumDetUnico, RegDatosProc, TipoProceso, IndColectiva
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;
BEGIN
   FOR X IN EMI_Q LOOP
     cMsjError := NULL;
     nCod_Asegurado := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,',')));
     nCodCliente    := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,3,',')));

     IF nCod_Asegurado > 0 THEN
        BEGIN
          SELECT P.IdPoliza, DP.IDetPol, P.FecAnul, P.MotivAnul, P.StsPoliza
            INTO nIdPoliza, nIDetPol, dFecAnul, cMotivAnul, cStsPoliza
            FROM POLIZAS P, DETALLE_POLIZA DP
           WHERE P.NumPolUnico = X.NumPolUnico
             AND P.CodCia      = X.CodCia
             AND P.CodEmpresa  = X.CodEmpresa
             AND P.StsPoliza   IN ('REN','EMI','ANU')
             AND P.CodCliente  = nCodCliente
             AND P.IdPoliza  = DP.IdPoliza
             AND DP.IDetPol  = X.NumDetUnico;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
             nIdPoliza := 0;
          WHEN TOO_MANY_ROWS THEN
             BEGIN
                SELECT P.IdPoliza, DP.IDetPol, P.FecAnul, P.MotivAnul, P.StsPoliza
                  INTO nIdPoliza, nIDetPol, dFecAnul, cMotivAnul, cStsPoliza
                  FROM POLIZAS P, DETALLE_POLIZA DP
                 WHERE P.NumPolUnico = X.NumPolUnico
                   AND P.CodCia      = X.CodCia
                   AND P.CodEmpresa  = X.CodEmpresa
                   AND P.StsPoliza   IN ('REN','EMI')
                   AND P.CodCliente  = nCodCliente
                   AND P.IdPoliza  = DP.IdPoliza
                   AND DP.IDetPol  = X.NumDetUnico;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   nIdPoliza := 0;
             END;
        END;

        IF nIdPoliza > 0 THEN
           -- Valida la fecha de Anulacion y el motivo sea diferente a Falta de Pago
           IF cStsPoliza = 'ANU' THEN
              dFec_Ocurrencia   := TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,15,',')),'YYYYMMDD');
              IF dFecAnul IS NOT NULL AND cMotivAnul != 'FPA' THEN
                 RAISE_APPLICATION_ERROR(-20225,'Póliza Anulada por Motivo diferente a Falta de Pago - NO Procede la Emisión del Endoso');
              ELSIF dFec_Ocurrencia > dFecAnul AND cMotivAnul = 'FPA' THEN
                   RAISE_APPLICATION_ERROR(-20225,'Póliza Anulada, la fecha de Ocurrencia es mayor a la Fecha de Anulación - NO Procede la Emisión del Endoso');
              END IF;
           END IF;
           -- Obtiene el IdEndoso
           BEGIN
             SELECT IdEndoso
               INTO nIdEndoso
               FROM ASEGURADO_CERTIFICADO
              WHERE CodCia         = X.CodCia
                AND IdPoliza       = nIdpoliza
                AND IdetPol        = nIdetPol
                AND Cod_Asegurado  = nCod_Asegurado;
           EXCEPTION
             WHEN OTHERS THEN
               nIdEndoso := 0;
               --cMsjError := 'No Existe Asegurado Certificado para la Póliza No. ' || X.NumPolUnico || ' con el Subgrupo ' || X.NumDetUnico;
           END;
           -- Valida Estatus de ENDOSO
             IF NVL(nIdEndoso,0) > 0 THEN
              BEGIN
                SELECT StsEndoso, TipoEndoso
                  INTO cStsEndoso, cTipoEndoso
                  FROM ENDOSOS
                 WHERE CodCia     = X.CodCia
                   AND CodEmpresa = X.CodEmpresa
                   AND IdPoliza   = nIdPoliza
                   --AND IdetPol    = nIdetPol
                   AND IdEndoso   = nIdEndoso;
              EXCEPTION
                WHEN OTHERS THEN
                  cMsjError := 'No Existe Endoso para la Póliza No. ' || X.NumPolUnico || ' con el Subgrupo ' || X.NumDetUnico;
              END;
              -- Actualiza Estatus de ENDOSO
              IF cStsEndoso = 'SOL' THEN
                 OC_ENDOSO.EMITIR(X.CodCia, X.CodEmpresa, nIdPoliza, nIdetPol, nIdEndoso, cTipoEndoso);
              END IF;
           END IF;
        ELSE
           cMsjError := 'No Existe la Póliza No. ' || X.NumPolUnico || ' con el Subgrupo ' || X.NumDetUnico;
        END IF;

        IF cMsjError IS NULL THEN
           OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'XPROC');
        ELSE
           OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','No se puede Crear el Asegurado para el Siniestro: '||cMsjError);
           OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERREMI');
        END IF;
     ELSE
        cMsjError := 'No se ha creado correctamente el Asegurado. ' || X.NumPolUnico || ' con el Subgrupo ' || X.NumDetUnico;
     END IF;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Error - No se puede Cargar el Siniestro '|| SQLERRM);
      OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERREMI');
END EMITIR_POLIZA_ESTIM_SINI;

PROCEDURE ESTIMACION_SINIESTROS(nIdProcMasivo NUMBER) IS
cCodPlantilla          CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE;
cNumSiniRef            SINIESTRO.NumSiniRef%TYPE;
cMotivSiniestro        SINIESTRO.Motivo_de_Siniestro%TYPE;
cCodPaisOcurr          SINIESTRO.CodPaisOcurr%TYPE := '001';
cCodProvOcurr          SINIESTRO.CodProvOcurr%TYPE;
dFec_Ocurrencia        SINIESTRO.Fec_Ocurrencia%TYPE;
dFec_Notificacion      SINIESTRO.Fec_Notificacion%TYPE;
cDescSiniestro         OBSERVACION_SINIESTRO.Descripcion%TYPE;
nIdSiniestro           SINIESTRO.IdSiniestro%TYPE;
nIdPoliza              POLIZAS.IdPoliza%TYPE;
nIDetPol               SINIESTRO.IDetPol%TYPE;
nCodCia                POLIZAS.CodCia%TYPE;
nCodEmpresa            POLIZAS.CodEmpresa%TYPE;
nEstimacionLocal       SINIESTRO.Monto_Reserva_Local%TYPE;
nEstimacionMoneda      SINIESTRO.Monto_Reserva_Moneda%TYPE;
cCod_Moneda            POLIZAS.Cod_Moneda%TYPE;
cIdTipoSeg             DETALLE_POLIZA.IdTipoSeg%TYPE;
nTasaCambio            DETALLE_POLIZA.Tasa_Cambio%TYPE;
cStsDetalle            DETALLE_POLIZA.StsDetalle%TYPE;
nCod_Asegurado         ASEGURADO.Cod_Asegurado%TYPE;
nCodCliente            CLIENTE_ASEG.CodCliente%TYPE;
cCodCobert             COBERT_ACT_ASEG.CodCobert%TYPE := 'GMXA';
cCodTransac            COBERTURA_SINIESTRO.CodTransac%TYPE      := 'APRVAD';
cCodCptoTransac        COBERTURA_SINIESTRO.CodCptoTransac%TYPE  := 'APRVAD';
nNumMod                COBERTURA_SINIESTRO.NumMod%TYPE;
nMonto_Reserva_Local   SINIESTRO.Monto_Reserva_Local%TYPE;
nMonto_Reserva_Moneda  SINIESTRO.Monto_Reserva_Moneda%TYPE;
nTotAjusteLocal        SINIESTRO.Monto_Reserva_Local%TYPE;
nTotAjusteMoneda       SINIESTRO.Monto_Reserva_Moneda%TYPE;
SumAseg1               COBERT_ACT_ASEG.SUMAASEG_MONEDA%TYPE;
SumaAseguradoReal      COBERT_ACT_ASEG.SUMAASEG_MONEDA%TYPE;
TotPagado              COBERTURA_SINIESTRO_ASEG.MONTO_PAGADO_MONEDA%TYPE;
nMontoRvaMoneda        COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
nOrden                 NUMBER(10):= 1;
nOrdenInc              NUMBER(10);
cUpdate                VARCHAR2(4000);
cEstado                VARCHAR2(100);
cCiudad                VARCHAR2(100);
cNombreAseg            VARCHAR2(200);
nCantSini              NUMBER(5);
cMsjError              PROCESOS_MASIVOS_LOG.TxtError%TYPE := NULL;
cExisteDatPart         VARCHAR2(1);
cExisteCob             VARCHAR2(1);
cAjusteReserva         VARCHAR2(1) := 'N';
cMotivSiniOrig         VARCHAR2(15);
cTotSiniAseg           NUMBER := 0;
dFecIniVig             POLIZAS.FECINIVIG%TYPE;
dFecFinVig             POLIZAS.FECFINVIG%TYPE;
dFecAnul               POLIZAS.FECANUL%TYPE;
cMotivAnul             POLIZAS.MOTIVANUL%TYPE;
cTipoPago              VARCHAR2(1);
cTipoEvento            VARCHAR2(40);
cTipoSiniestro         SINIESTRO.TIPO_SINIESTRO%TYPE := '001';
nCod_AseguradoSini     ASEGURADO.Cod_Asegurado%TYPE;
dFecProceso            DATE;
nIdTransaccion         TRANSACCION.IdTransaccion%TYPE;
ACUANTO_ES             SINIESTRO.Monto_Reserva_Moneda%TYPE;
cNombreArchLogem       VARCHAR2(200);
TERMINAL               VARCHAR2(50);
USUSARIO               VARCHAR2(50);
---nIDTRANSACCION      PROCESOS_MASIVOS_SEGUIMIENTO.IDTRANSACCION%TYPE;
nSALDO_RESERVA         COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA%TYPE;
SALDO_GLOBAL_antes     COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA%TYPE;
SALDO_GLOBAL           COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA%TYPE;
W_GRABA                SAI_CAT_GENERAL.CAGE_VALOR_CORTO%TYPE;
GRABA                  BOOLEAN;
WNUM_ASISTENCIA        PROCESOS_MASIVOS_SEGUIMIENTO.NUM_ASISTENCIA%TYPE;
WRFC_HOSPITAL          PROCESOS_MASIVOS_SEGUIMIENTO.RFC_HOSPITAL%TYPE;
WRFC_ASISTENCIADORA    PROCESOS_MASIVOS_SEGUIMIENTO.RFC_ASISTENCIADORA%TYPE;
WARCHIVO_LOGEM         PROCESOS_MASIVOS_SEGUIMIENTO.ARCHIVO_LOGEM%TYPE;
wOCURRIDO              COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
wPAGADOS               COBERTURA_SINIESTRO_ASEG.MONTO_PAGADO_MONEDA%TYPE;
cIndFecEquiv           SUB_PROCESO.IndFecEquiv%TYPE;
cIndFecEquivPro        PROC_TAREA.IndFecEquiv%TYPE;
dFechaCamb             APROBACIONES.FECPAGO%TYPE;
dFechaCont             FECHA_CONTABLE_EQUIVALENTE.FECHACONTABLE%TYPE;
dFechaReal             FECHA_CONTABLE_EQUIVALENTE.FECHAREAL%TYPE;
cCodEmpresa            SINIESTRO.CODEMPRESA%TYPE;
cCodCia                SINIESTRO.CODCIA%TYPE;

CURSOR C_CAMPOS_PART  IS
  SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.OrdenDatoPart
    FROM CONFIG_PLANTILLAS_CAMPOS C
   WHERE C.CodPlantilla = cCodPlantilla
     AND C.CodEmpresa   = nCodEmpresa
     AND C.CodCia       = nCodCia
     AND C.NomTabla     = 'DATOS_PART_SINIESTROS'
     AND C.IndDatoPart  = 'S'
   ORDER BY OrdenDatoPart,OrdenCampo;

CURSOR EMI_Q IS
  SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
         NumDetUnico, RegDatosProc, TipoProceso,IndColectiva
    FROM PROCESOS_MASIVOS
   WHERE IdProcMasivo   = nIdProcMasivo;
BEGIN
  FOR X IN EMI_Q LOOP
    cMsjError := NULL;
    nCodCliente    := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,3,',')));
    cTipoPago      := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,99,','));
    cTipoEvento    := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,100,','));

    --SE AGREGA VALIDACION DE FECHA--
    cIndFecEquivPro := OC_PROC_TAREA.INDICA_FEC_EQUIVALENTE_PRO(6);
    cIndFecEquiv    := OC_SUB_PROCESO.INDICA_FEC_EQUIVALENTE_SUBPROC(6,'EMIRES');
    dFechaCont      := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_CONTABLE(X.CodCia, X.CodEmpresa);
    dFechaReal      := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_REAL(X.CodCia, X.CodEmpresa);

    IF cIndFecEquivPro = 'S' THEN
       IF cIndFecEquiv = 'S' THEN
          dFechaCamb:= dFechaCont;
       ELSE
          dFechaCamb := dFechaReal;
       END IF;
    ELSE
       dFechaCamb := dFechaReal;
    END IF;

    IF cTipoEvento = 'VIDA' THEN
       cCodCobert := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,101,','));
       IF cCodCobert IN ('GFUN','FALLEC') THEN
          cCodTransac     := 'ARSBAS';
          cCodCptoTransac := 'APRVBA';
       ELSE
          cCodTransac     := 'APRVAD';
          cCodCptoTransac := 'APRVAD';
       END IF;
       cTipoSiniestro  := '008';
    END IF;

    BEGIN
       SELECT P.IdPoliza, P.Cod_Moneda, DP.FecIniVig, DP.FecFinVig, P.FecAnul, P.MotivAnul, IDetPol, StsDetalle
         INTO nIdPoliza, cCod_Moneda, dFecIniVig, dFecFinVig, dFecAnul, cMotivAnul, nIDetPol, cStsDetalle
         FROM POLIZAS P, DETALLE_POLIZA DP
        WHERE P.NumPolUnico = X.NumPolUnico
          AND P.CodCia      = X.CodCia
          AND P.CodEmpresa  = X.CodEmpresa
          AND P.StsPoliza   IN ('REN','EMI','ANU')
          AND P.CodCliente  = nCodCliente
          AND P.IdPoliza    = DP.IdPoliza
          AND DP.IDetPol    = X.NumDetUnico;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          nIdPoliza := 0;
       WHEN TOO_MANY_ROWS THEN
          BEGIN
             SELECT P.IdPoliza, P.Cod_Moneda, DP.FecIniVig, DP.FecFinVig, P.FecAnul, P.MotivAnul, IDetPol, StsDetalle
               INTO nIdPoliza, cCod_Moneda, dFecIniVig, dFecFinVig, dFecAnul, cMotivAnul, nIDetPol, cStsDetalle
               FROM POLIZAS P, DETALLE_POLIZA DP
              WHERE P.NumPolUnico = X.NumPolUnico
                AND P.CodCia      = X.CodCia
                AND P.CodEmpresa  = X.CodEmpresa
                AND P.StsPoliza   IN ('REN','EMI')
                AND P.CodCliente  = nCodCliente
                AND P.IdPoliza    = DP.IdPoliza
                AND DP.IDetPol    = X.NumDetUnico;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                nIdPoliza := 0;
         END;
    END;

    IF OC_POLIZAS.EXISTE_POLIZA(X.CodCia, X.CodEmpresa, nIdPoliza) = 'S' THEN
       cNumSiniRef := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,1,','));

       BEGIN
         SELECT COUNT(*)
           INTO nCantSini
           FROM SINIESTRO
          WHERE NumSiniRef = cNumSiniRef
            AND CodCia     = X.CodCia;
       END;

       IF nCantSini = 0 THEN -- Creacion de Siniestro
          cAjusteReserva := 'N';
          nCod_Asegurado    := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,',')));
          cNombreAseg       := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,7,','))||' '||
                               LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,8,','))||' '||
                               LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,9,','));
          cMotivSiniOrig    := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,12,','));

          --Validar Asegurado este en estatus de Emitido
          IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(X.CodCia, nIdPoliza, nIDetPol, nCod_Asegurado) = 'N' THEN
             IF cStsDetalle = 'SOL' THEN
                RAISE_APPLICATION_ERROR(-20225,'El Asegurado se encuentra en un Certificado en estatus de Solicitud, Asegurado: ' ||nCod_Asegurado);
             END IF;
          ELSE
             IF OC_ASEGURADO_CERTIFICADO.STATUS_ASEGURADO(X.CodCia, nIdPoliza, nIDetPol, nCod_Asegurado) = 'SOL' THEN
                RAISE_APPLICATION_ERROR(-20225,'El Asegurado se encuentra en estatus de Solicitud, Asegurado: ' ||nCod_Asegurado);
             END IF;
          END IF;

          IF nCod_Asegurado = 0 THEN
             RAISE_APPLICATION_ERROR(-20225,'Error No Existe Codigo de Asegurad ' );
          END IF;

          IF nCod_Asegurado > 0 THEN -- Asegurado mayor a Cero
             IF UPPER(cMotivSiniOrig) = 'PENDIENTE' THEN
                cMotivSiniestro := NULL;
             ELSE
                cMotivSiniestro := cMotivSiniOrig;
             END IF;
             cEstado := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,13,','));
             IF cEstado IN ('D.F.','DF') THEN
                cEstado := 'DISTRITO FEDERAL';
             END IF;
             --
             BEGIN
               SELECT p.CodEstado
                 INTO cCodProvOcurr
                 FROM PROVINCIA       p
                WHERE p.DescEstado LIKE '%' || cEstado || '%'
                AND    p.codpais = '001';
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  cCodProvOcurr := '009';
               WHEN TOO_MANY_ROWS THEN
                 RAISE_APPLICATION_ERROR(-20225,'Provincia  '||cEstado||'  con mas de un registro - NO Procede Crearlo');
             END;
             --
             dFec_Ocurrencia   := TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,15,',')),'YYYYMMDD');
             dFec_Notificacion := TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,16,',')),'YYYYMMDD');
             cDescSiniestro    := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,20,','));
             nEstimacionMoneda := TO_NUMBER(TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,22,',')),'999999999990.00');
             nTasaCambio       := OC_GENERALES.TASA_DE_CAMBIO(cCod_Moneda, TRUNC(SYSDATE));
             nEstimacionLocal := nEstimacionMoneda * nTasaCambio;

             -- Valida Si el Asegurado ya tiene creado un Siniestro. Detenerlo? SI, Hay que volver a definir
             BEGIN
               SELECT COUNT(*)
                 INTO cTotSiniAseg
                 FROM SINIESTRO
                WHERE IdPoliza      = nIdPoliza
                  AND Cod_Asegurado = nCod_Asegurado;
             EXCEPTION
               WHEN OTHERS THEN
                 cTotSiniAseg := 0;
             END;

             IF cTotSiniAseg > 0 AND NVL(cTipoPago,'P') != 'S' THEN -- Se adiciona el Tipo de Pago 'S' = Procede con la creación del Siniestro
                RAISE_APPLICATION_ERROR(-20225,'El Asegurado tiene '||TO_CHAR(cTotSiniAseg)||' Siniestro(s) ya registrado(s) - NO Procede Crearlo');
             END IF;
             -- Valida la Fecha de Ocurrencia del Siniestro.
             IF dFec_Ocurrencia < dFecIniVig  OR dFec_Ocurrencia > dFecFinVig THEN
                RAISE_APPLICATION_ERROR(-20225,'Fecha de Ocurrencia, esta fuera del rango de vigencia de la Póliza - NO Procede Crearlo');
             ELSIF dFecAnul IS NOT NULL AND cMotivAnul != 'FPA' THEN
                RAISE_APPLICATION_ERROR(-20225,'Póliza Anulada por Motivo diferente a Falta de Pago - NO Procede Crearlo');
             ELSIF dFec_Ocurrencia > dFecAnul AND cMotivAnul = 'FPA' THEN
                RAISE_APPLICATION_ERROR(-20225,'Póliza Anulada, la fecha de Ocurrencia es mayor a la Fecha de Anulacion - NO Procede Crearlo');
             ELSIF dFec_Ocurrencia > TRUNC (SYSDATE) THEN
                RAISE_APPLICATION_ERROR(-20225,'Fecha de Ocurrencia NO puede ser Mayor  a la Fecha de SISTEMA - NO Procede Crearlo');
             END IF;
             -- Valida la Fecha de Notificación del Siniestro.
             IF dFec_Notificacion > ADD_MONTHS(dFec_Ocurrencia,60) THEN
                RAISE_APPLICATION_ERROR(-20225,'Fecha de Notificación, esta fuera de la Fecha permitida por Ley - NO Procede Crearlo');
             ELSIF dFec_Notificacion > TRUNC (SYSDATE) THEN
                RAISE_APPLICATION_ERROR(-20225,'Fecha de Notificación, no puede ser Mayor a la fecha del SISTEMA - NO Procede Crearlo');
             ELSIF dFec_Notificacion < dFecIniVig THEN
                RAISE_APPLICATION_ERROR(-20225,'Fecha de Notificación, no puede ser Menor al Inicio de Vigencia - NO Procede Crearlo');
             ELSIF dFec_Notificacion < dFec_Ocurrencia THEN
                RAISE_APPLICATION_ERROR(-20225,'Fecha de Notificación, no puede ser Menor a la Fecha de Ocurrencia - NO Procede Crearlo');
             END IF;

             nIdSiniestro := OC_SINIESTRO.INSERTA_SINIESTRO(X.CodCia, X.CodEmpresa, nIdPoliza, X.NumDetUnico, cNumSiniRef,dFec_Ocurrencia, dFec_Notificacion,
                                                            'Carga Masiva de Estimación de Siniestros realizada el ' ||TO_DATE(SYSDATE,'DD/MM/YYYY'),
                                                            cTipoSiniestro, cMotivSiniestro, cCodPaisOcurr, cCodProvOcurr);
             BEGIN
               UPDATE SINIESTRO
                  SET Cod_Asegurado = nCod_Asegurado
                WHERE CodCia      = X.CodCia
                  AND IdSiniestro = nIdSiniestro;
             END;

             BEGIN
                OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, nIdPoliza, 'Carga Masiva de Ajustes de Reserva, el ' ||
                                                             TO_CHAR(TRUNC(SYSDATE),'DD/MM/YYYY')||' Motivo: '||cDescSiniestro);
             EXCEPTION
                WHEN OTHERS THEN
                   RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Obervación, Favor de validar la información, Error: '||SQLERRM);
             END;

             cCodPlantilla     := OC_CONFIG_PLANTILLAS_PLANCOB.CODIGO_PLANTILLA(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, X.TipoProceso);
             nCodCia           := X.CodCia;
             nCodEmpresa       := X.CodEmpresa;

             BEGIN
                INSERT INTO DATOS_PART_SINIESTROS
                       (CodCia, IdSiniestro, IdPoliza, FecSts,STSDATPART,FECPROCED,IDPROCMASIVO)
                 VALUES(X.CodCia, nIdSiniestro, nIdPoliza, TRUNC(dFechaCamb),'ESTSIN',dFechaCamb,nIdProcMasivo);
             EXCEPTION
                WHEN OTHERS THEN
                   RAISE_APPLICATION_ERROR(-20225,'Error en insert en DATOS_PART_SINIESTROS : '||sqlerrm);
             END;

             FOR I IN C_CAMPOS_PART LOOP
               nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla, X.CodCia, X.CodEmpresa, I.OrdenProceso) + nOrden;
               cUpdate   := 'UPDATE '||'DATOS_PART_SINIESTROS' || ' ' ||
                            'SET'||' ' || 'CAMPO' || I.OrdenDatoPart || '=' || '''' ||
                             LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) || '''' || ' ' ||
                            'WHERE IdProcMasivo = ' || nIdProcMasivo || ' ' ||
                            '  AND IdPoliza  = ' || nIdPoliza    ||' '||
                            '  AND IdSiniestro = ' || nIdSiniestro ||' '||
                            '  AND CodCia      = ' || X.CodCia;
               OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate);
               nOrden := nOrden + 1;
             END LOOP;

             BEGIN
               SELECT IDetPol
                 INTO nIDetPol
                 FROM SINIESTRO
                WHERE NumSiniRef = cNumSiniRef
                  AND CodCia     = X.CodCia;
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 RAISE_APPLICATION_ERROR(-20225,'Cero Sini - NO Existe Siniestro con Referencia No. : '||cNumSiniRef);
               WHEN TOO_MANY_ROWS THEN
                 RAISE_APPLICATION_ERROR(-20225,'Cero Sini - Existen Varios Siniestros con Referencia No. : '||cNumSiniRef);
             END;

             BEGIN
               SELECT IdTipoSeg
                 INTO cIdTipoSeg
                 FROM DETALLE_POLIZA
                WHERE CodCia      = X.CodCia
                  AND CodEmpresa  = X.CodEmpresa
                  AND IdPoliza    = nIdPoliza
                  AND IdetPol     = nIDetPol; --X.NumDetUnico;
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 cIdTipoSeg := NULL;
             END;

             IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(X.CodCia, nIdPoliza, nIDetPol, nCod_Asegurado) = 'N' THEN
                -- Valida que no exceda la Suma Asegurada.
                IF OC_COBERTURA_SINIESTRO.VALIDA_SUMA_ASEGURADA(X.CodCia, nIdPoliza, nIDetPol,cCodCobert, cCodTransac, NVL(nEstimacionMoneda,0)) = 'N' THEN
                   RAISE_APPLICATION_ERROR(-20225,'La Estimación NO puede ser mayor a la Suma Asegurada (validacion) de la Cobertura ' ||cCodCobert||' - NO Procede Crearlo');
                END IF;

                BEGIN
                   INSERT INTO DETALLE_SINIESTRO
                         (IdSiniestro, IdPoliza, IdDetSin, Monto_Pagado_Moneda, Monto_Pagado_Local,
                          Monto_Reservado_Moneda, Monto_Reservado_Local, IdTipoSeg)
                   VALUES(nIdSiniestro, nIdPoliza, 1, 0, 0, nEstimacionMoneda, nEstimacionLocal, cIdTipoSeg);
                EXCEPTION
                   WHEN OTHERS THEN
                      RAISE_APPLICATION_ERROR(-20225,'DETALLE SINIESTRO (Cero Sini) - Ocurrió el siguiente error: '||SQLERRM);
                END;

                BEGIN
                   SELECT 'S'
                     INTO cExisteCob
                     FROM COBERT_ACT
                    WHERE CodCia      = X.CodCia
                      AND CodEmpresa  = X.CodEmpresa
                      AND IdPoliza    = nIdPoliza
                      AND IdetPol     = nIDetPol --X.NumDetUnico
                      AND CodCobert   = cCodCobert;
                 EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                       RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura (SIN Aseg) de '||cCodCobert);
                 END;

                IF cExisteCob = 'S' THEN
                   BEGIN
                     INSERT INTO COBERTURA_SINIESTRO
                           (IdDetSin, CodCobert, IdSiniestro, IdPoliza, Doc_Ref_Pago, Monto_Pagado_Moneda, Monto_Pagado_Local, Monto_Reservado_Moneda,
                            Monto_Reservado_Local, StsCobertura, NumMod, CodTransac, CodCptoTransac, IdTransaccion, Saldo_Reserva, IndOrigen, FecRes,
                            Saldo_Reserva_Local)
                     VALUES(1, cCodCobert, nIdSiniestro, nIdPoliza, NULL, 0, 0, nEstimacionMoneda, nEstimacionLocal,
                            'SOL', 1, cCodTransac, cCodCptoTransac, NULL, nEstimacionMoneda, 'D', TRUNC(dFechaCamb), nEstimacionLocal);
                   EXCEPTION
                     WHEN OTHERS THEN
                       RAISE_APPLICATION_ERROR(-20225,'COBERTURA SINIESTRO (Cero Sini) - Ocurrió el siguiente error: '||SQLERRM);
                   END;
                END IF;
             ELSE
                -- Valida que no exceda la Suma Asegurada.
                IF OC_COBERTURA_SINIESTRO_ASEG.VALIDA_SUMA_ASEGURADA(X.CodCia, nIdPoliza, nIDetPol, cCodCobert, cCodTransac,
                                                                     nCod_Asegurado, NVL(nEstimacionMoneda,0)) = 'N' THEN
                   RAISE_APPLICATION_ERROR(-20225,'La Estimación NO puede ser mayor a la Suma Asegurada (validacion Aseg) de la Cobertura ' ||cCodCobert||' - NO Procede Crearlo');
                END IF;
                --
                BEGIN
                  INSERT INTO DETALLE_SINIESTRO_ASEG
                         (IdSiniestro, IdPoliza, IdDetSin, Cod_Asegurado, Monto_Pagado_Moneda, Monto_Pagado_Local,
                          Monto_Reservado_Moneda, Monto_Reservado_Local, IdTipoSeg)
                  VALUES (nIdSiniestro, nIdPoliza, 1, nCod_Asegurado, 0, 0, nEstimacionMoneda, nEstimacionLocal, cIdTipoSeg);
                EXCEPTION
                  WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR(-20225,'DETALLE SINIESTRO ASEG (Cero Sini) - Ocurrió el siguiente error: '||SQLERRM);
                END;
                --
                BEGIN
                  SELECT 'S'
                    INTO cExisteCob
                    FROM COBERT_ACT_ASEG
                   WHERE CodCia        = nCodCia
                     AND CodEmpresa    = nCodEmpresa
                     AND IdPoliza      = nIdPoliza
                     AND IdetPol       = nIDetPol --X.NumDetUnico
                     AND Cod_Asegurado = nCod_Asegurado
                     AND CodCobert     = cCodCobert;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura de '||cCodCobert);
                END;
                --
                BEGIN
                  INSERT INTO COBERTURA_SINIESTRO_ASEG
                        (IdDetSin, CodCobert, IdSiniestro, IdPoliza, Cod_Asegurado, Doc_Ref_Pago, Monto_Pagado_Moneda, Monto_Pagado_Local,
                         Monto_Reservado_Moneda, Monto_Reservado_Local, StsCobertura, NumMod, CodTransac, CodCptoTransac, IdTransaccion,
                         Saldo_Reserva, IndOrigen, FecRes, Saldo_Reserva_Local)
                  VALUES(1, cCodCobert, nIdSiniestro, nIdPoliza, nCod_Asegurado, NULL, 0, 0, nEstimacionMoneda, nEstimacionLocal,
                         'SOL', 1, cCodTransac, cCodCptoTransac, NULL, nEstimacionMoneda, 'A', TRUNC(dFechaCamb), nEstimacionLocal);
                EXCEPTION
                  WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR(-20225,'COBERTURA SINIESTRO ASEG (Cero Sini) - Ocurrió el siguiente error: '||SQLERRM);
                END;
             END IF;
          END IF; -- Asegurado mayor a Cero

          cNombreArchLogem   := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,100,','));

            BEGIN
               UPDATE PROCESOS_MASIVOS_SEGUIMIENTO
                  SET IdPoliza          = nIdPoliza,
                      IdTransaccion     = nIdTransaccion,
                      EMI_REGDATOSPROC  = X.RegDatosProc,
                      IDSINIESTRO       = nIdSiniestro,
                      CODCOBERT         = cCodCobert,
                      NUMMOD            = 1,
                      COD_ASEGURADO     = nCod_Asegurado,
                      TIPO              = 'Crea Siniestro',
                      ARCHIVO_LOGEM     = cNombreArchLogem
               WHERE IdProcMasivo      = nIdProcMasivo;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-20225,' 1 Error en ACTUALIZA_STATUS UPDATE PROCESOS_MASIVOS_SEGUIMIENTO  '||SQLERRM);
               WHEN OTHERS  THEN
                  RAISE_APPLICATION_ERROR(-20225,' 1 Error en ACTUALIZA_STATUS UPDATE PROCESOS_MASIVOS_SEGUIMIENTO  '||SQLERRM);
            END;
       ELSE -- Ajuste del Siniestro
          cAjusteReserva := 'S';

          nCod_Asegurado := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,',')));

          BEGIN
            SELECT IdSiniestro, Monto_Reserva_Local, Monto_Reserva_Moneda, IDetPol, Cod_Asegurado, IdPoliza
              INTO nIdSiniestro, nMonto_Reserva_Local, nMonto_Reserva_Moneda, nIDetPol, nCod_AseguradoSini, nIdPoliza
              FROM SINIESTRO
             WHERE NumSiniRef = cNumSiniRef
               AND CodCia     = X.CodCia;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR(-20225,'NO Existe Siniestro con Referencia No. : '||cNumSiniRef);
            WHEN TOO_MANY_ROWS THEN
              RAISE_APPLICATION_ERROR(-20225,'Existen Varios Siniestros con Referencia No. : '||cNumSiniRef);
          END;
                ----   tomamos la foto de la Reserva  antes de  ajustar   ---
          BEGIN
              SELECT SUM(NVL(A.SALDO_RESERVA,0))
                INTO SALDO_GLOBAL_antes
                FROM COBERTURA_SINIESTRO_ASEG A
               WHERE A.idsiniestro = nIdSiniestro
                 AND A.NUMMOD = (SELECT MAX(A2.NUMMOD)
                                   FROM COBERTURA_SINIESTRO_ASEG A2
                                  WHERE A2.IDSINIESTRO = A.IDSINIESTRO
                                    AND A2.IDPOLIZA    = A.IDPOLIZA
                                    AND A2.CODCOBERT   = A.CODCOBERT)
                AND  A.IDDETSIN =  1 ;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20225,'NDF Error al obtener el saldo de la Reserva antes de Ajustar : '||SQLERRM);
             WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20225,'Others Error al obtener el saldo de la Reserva  antes de Ajustar : '||SQLERRM);
          END;

          IF nCod_Asegurado != nCod_AseguradoSini THEN
              RAISE_APPLICATION_ERROR(-20225,'Error el Siniestro asegurado diferente (Asegurado archivo = '||nCod_Asegurado||
                                             'vs Asegurado en base = '||nCod_AseguradoSini||' del siniestro = '||nIdSiniestro||')');
          END IF;
          nEstimacionMoneda := NVL(TO_NUMBER(TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,22,',')),'999999999990.00'),0);

          ACUANTO_ES := OC_COBERT_ACT_ASEG.SUMA_ASEGURADA(X.CodCia, nIdPoliza, nIDetPol, nCod_Asegurado, cCodCobert);

          IF nEstimacionMoneda = 0 THEN
             RAISE_APPLICATION_ERROR(-20225,'Estimación del Siniestro en Ceros - NO Procede Crearlo');
          ELSIF nEstimacionMoneda > OC_COBERT_ACT_ASEG.SUMA_ASEGURADA(X.CodCia, nIdPoliza, nIDetPol, nCod_Asegurado, cCodCobert) THEN
             RAISE_APPLICATION_ERROR(-20225,'La Estimación NO puede ser mayor a la Suma Asegurada (Suma Aseg. Ajuste) de la Cobertura ' ||cCodCobert||' - NO Procede el Ajuste');
          END IF;

          IF nEstimacionMoneda > 0 THEN
             cCodTransac     := 'AURVAD';
             cCodCptoTransac := 'AURVAD';
             dFecProceso     := TRUNC(dFechaCamb);
          ELSIF nEstimacionMoneda < 0 THEN
             IF cTipoEvento = 'IVA' THEN
                cCodTransac     := 'DRBIVA';
                cCodCptoTransac := 'DRBIVA';
                dFecProceso     := TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,15,',')),'YYYYMMDD');
                nCod_Asegurado  := nCod_AseguradoSini;
             ELSE
                cCodTransac     := 'DIRVAD';
                cCodCptoTransac := 'DIRVAD';
                dFecProceso     := TRUNC(dFechaCamb);
             END IF;
             nEstimacionMoneda := nEstimacionMoneda * -1;
          END IF;

          nTasaCambio      := OC_GENERALES.TASA_DE_CAMBIO(cCod_Moneda, TRUNC(SYSDATE));
          nEstimacionLocal := nEstimacionMoneda * nTasaCambio;

          ----  VALIDAMOS QUE EL MONTO DEL AJUSTE NO REBASE LA SUMA ASEGURADA   -----   AEVS
                         ---  SUMA ASEGURADA ----
          BEGIN
             SELECT UNIQUE(SUMAASEG_LOCAL)
               INTO SumAseg1
               FROM COBERT_ACT_ASEG
              WHERE IdPoliza      = nIdPoliza
                AND CodCobert     = cCodCobert
                AND Cod_Asegurado = nCod_Asegurado;
          EXCEPTION
             WHEN DUP_VAL_ON_INDEX   THEN
                SumAseg1 := 0;
             WHEN NO_DATA_FOUND THEN
                SumAseg1 := 0;
             WHEN OTHERS THEN
                SumAseg1 := 0;
          END;
          IF SumAseg1 IS NULL THEN
             SumAseg1:= 0;
          END IF;

          ----  monto pagado  ---
          BEGIN
             SELECT SUM(MONTO_PAGADO_MONEDA)
               INTO TotPagado
               FROM COBERTURA_SINIESTRO_ASEG
              WHERE IdPoliza      = nIdPoliza
                AND Cod_Asegurado = nCod_Asegurado
                AND CodCobert     = cCodCobert ;
          EXCEPTION
             WHEN DUP_VAL_ON_INDEX THEN
                TotPagado := 0;
             WHEN NO_DATA_FOUND THEN
                TotPagado := 0;
             WHEN OTHERS THEN
                TotPagado := 0;
          END;

          IF TotPagado IS NULL THEN
             TotPagado:= 0;
          END IF;

           ---  Monto Reservado Total Cobertura    ---  EMI  porque es lo realmente  reservado.
          BEGIN
             SELECT SUM(NVL(CS.SALDO_RESERVA,0))
               INTO nMontoRvaMoneda
               FROM COBERTURA_SINIESTRO_ASEG  CS
              WHERE CS.IdPoliza      = nIdPoliza
                AND CS.CodCobert     = cCodCobert
                AND CS.Cod_Asegurado = nCod_Asegurado
                AND CS.StsCobertura  = 'EMI'
                AND CS.NumMod        = ( SELECT MAX(R.NumMod)
                                           FROM COBERTURA_SINIESTRO_ASEG R
                                          WHERE R.IDPOLIZA      = CS.IDPOLIZA
                                            AND R.IDSINIESTRO   = CS.IDSINIESTRO
                                            AND R.COD_ASEGURADO = CS.COD_ASEGURADO
                                            AND R.STSCOBERTURA  = 'EMI');
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                nMontoRvaMoneda := 0;
             WHEN OTHERS  THEN
                nMontoRvaMoneda := 0;
          END;

          IF nMontoRvaMoneda IS NULL THEN
             nMontoRvaMoneda := 0;
          END IF;

          IF SumAseg1 > 0 THEN
             SumaAseguradoReal := (SumAseg1 - (nMontoRvaMoneda + TotPagado));
             IF nEstimacionLocal >  SumaAseguradoReal THEN
                cMsjError := 'La Estimación NO puede ser mayor a la Suma Asegurada.  Suma Asegurada Remanente:  ' ||SumaAseguradoReal ;
                RAISE_APPLICATION_ERROR(-20225,'La Estimación NO puede ser mayor a la Suma Asegurada.  Suma Asegurada Remanente:  ' ||SumaAseguradoReal);
             END IF;
          END IF;

          IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(X.CodCia, nIdPoliza, nIDetPol, nCod_Asegurado) = 'N' THEN
             -- Valida que no exceda la Suma Asegurada.
             IF OC_COBERTURA_SINIESTRO.VALIDA_SUMA_ASEGURADA(X.CodCia, nIdPoliza, nIDetPol, cCodCobert, cCodTransac, nEstimacionMoneda) = 'N' THEN
                RAISE_APPLICATION_ERROR(-20225,'La Estimación NO puede ser mayor a la Suma Asegurada (Validacion Ajuste) de la Cobertura ' ||cCodCobert||' - NO Procede Crearlo');
             END IF;

             BEGIN
                SELECT NVL(MAX(NumMod),0) + 1
                  INTO nNumMod
                  FROM COBERTURA_SINIESTRO
                 WHERE IdSiniestro = nIdSiniestro
                   AND CodCobert   = cCodCobert
                   AND IdPoliza    = nIdPoliza;
             END;

             BEGIN
                INSERT INTO COBERTURA_SINIESTRO
                      (IdDetSin, CodCobert, IdSiniestro, IdPoliza, Doc_Ref_Pago, Monto_Pagado_Moneda, Monto_Pagado_Local, Monto_Reservado_Moneda,
                       Monto_Reservado_Local, StsCobertura, NumMod, CodTransac, CodCptoTransac, IdTransaccion, Saldo_Reserva, IndOrigen, FecRes,
                       Saldo_Reserva_Local)
                VALUES(1, cCodCobert, nIdSiniestro, nIdPoliza, NULL, 0, 0, nEstimacionMoneda , nEstimacionLocal,
                       'SOL', nNumMod, cCodTransac, cCodCptoTransac, NULL, nEstimacionMoneda, 'D', dFecProceso, nEstimacionLocal);
             EXCEPTION
                WHEN OTHERS THEN
                   RAISE_APPLICATION_ERROR(-20225,'COBERTURA SINIESTRO (Ajuste) - Ocurrió el siguiente error: '||SQLERRM);
             END;

             OC_COBERTURA_SINIESTRO.EMITE_RESERVA(X.CodCia, X.CodEmpresa, nIdSiniestro, nIdPoliza, 1, cCodCobert, nNumMod, NULL);

             IF cTipoEvento = 'IVA' THEN
                BEGIN
                   SELECT IdTransaccion
                     INTO nIdTransaccion
                     FROM COBERTURA_SINIESTRO
                    WHERE IdSiniestro = nIdSiniestro
                      AND IdPoliza    = nIdPoliza
                      AND IddetSin    = 1
                      AND CodCobert   = cCodCobert
                      AND NumMod      = nNumMod;
                EXCEPTION
                   WHEN OTHERS THEN
                      RAISE_APPLICATION_ERROR(-20225,'COBERTURA_SINIESTRO_ASEG (Ajuste) - Al obtener la Transaccion ocurrió el siguiente error: '||SQLERRM);
                END;

                BEGIN
                   UPDATE TRANSACCION
                      SET FechaTransaccion = dFecProceso
                    WHERE IdTransaccion = nIdTransaccion;

                   UPDATE COMPROBANTES_DETALLE
                      SET FecDetalle = dFecProceso
                    WHERE NumComprob   IN (SELECT NumComprob
                                             FROM COMPROBANTES_CONTABLES
                                            WHERE NumTransaccion = nIdTransaccion);

                   UPDATE COMPROBANTES_CONTABLES
                      SET FecComprob     = dFecProceso,
                          FecSts         = dFecProceso
                    WHERE NumTransaccion = nIdTransaccion;
                EXCEPTION
                   WHEN OTHERS THEN
                      RAISE_APPLICATION_ERROR(-20225,'COBERTURA_SINIESTRO_ASEG (Ajuste) - Al obtener la Transaccion ocurrió el siguiente error: '||SQLERRM);
                END;
             END IF;
          ELSE
             -- Valida que no exceda la Suma Asegurada.
             IF OC_COBERTURA_SINIESTRO_ASEG.VALIDA_SUMA_ASEGURADA(X.CodCia, nIdPoliza, nIDetPol, cCodCobert, cCodTransac, nCod_Asegurado, nEstimacionMoneda) = 'N' THEN
                RAISE_APPLICATION_ERROR(-20225,'La Estimación NO puede ser mayor a la Suma Asegurada (Validacion Aseg Ajuste) de la Cobertura ' ||cCodCobert||' - NO Procede Crearlo');
             END IF;

             BEGIN
                SELECT NVL(MAX(NumMod),0) + 1
                  INTO nNumMod
                  FROM COBERTURA_SINIESTRO_ASEG
                 WHERE IdSiniestro   = nIdSiniestro
                   AND CodCobert     = cCodCobert
                   AND Cod_Asegurado = nCod_Asegurado
                   AND IdPoliza      = nIdPoliza;
             END;

             BEGIN
                INSERT INTO COBERTURA_SINIESTRO_ASEG
                      (IdDetSin, CodCobert, IdSiniestro, IdPoliza, Cod_Asegurado, Doc_Ref_Pago, Monto_Pagado_Moneda, Monto_Pagado_Local,
                       Monto_Reservado_Moneda, Monto_Reservado_Local, StsCobertura, NumMod, CodTransac, CodCptoTransac, IdTransaccion,
                       Saldo_Reserva, IndOrigen, FecRes, Saldo_Reserva_Local)
                VALUES(1, cCodCobert, nIdSiniestro, nIdPoliza, nCod_Asegurado, NULL, 0, 0, nEstimacionMoneda , nEstimacionLocal,
                       'SOL', nNumMod, cCodTransac, cCodCptoTransac, NULL, nEstimacionMoneda, 'D', dFecProceso, nEstimacionLocal);
             EXCEPTION
                WHEN OTHERS THEN
                   RAISE_APPLICATION_ERROR(-20225,'COBERTURA_SINIESTRO_ASEG (Ajuste) - Ocurrió el siguiente error: '||SQLERRM);
             END;

             OC_COBERTURA_SINIESTRO_ASEG.EMITE_RESERVA(X.CodCia, X.CodEmpresa, nIdSiniestro, nIdPoliza, 1, nCod_Asegurado, cCodCobert, nNumMod, NULL);

               ---  OBTENGO EL IDTRANSACCION  --
             BEGIN
                SELECT IdTransaccion
                  INTO nIdTransaccion
                  FROM COBERTURA_SINIESTRO_ASEG
                 WHERE CODCOBERT     = cCodCobert
                   AND IDSINIESTRO   = nIdSiniestro
                   AND IDPOLIZA      = nIdPoliza
                   AND COD_ASEGURADO = nCod_Asegurado
                   AND NUMMOD        = nNumMod
                   AND CODTRANSAC    = cCodTransac
                   AND STSCOBERTURA  = 'EMI';
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   RAISE_APPLICATION_ERROR(-20225,' 1 Error  COBERTURA_SINIESTRO_ASEG  '||SQLERRM);
                WHEN OTHERS  THEN
                   RAISE_APPLICATION_ERROR(-20225,' 1 Error   COBERTURA_SINIESTRO_ASEG  '||SQLERRM);
             END;

             BEGIN
                UPDATE PROCESOS_MASIVOS_SEGUIMIENTO
                   SET IDPOLIZA          = nIdPoliza,
                       IdTransaccion     = nIdTransaccion,
                       IDSINIESTRO       = nIdSiniestro,
                       CODCOBERT         = cCodCobert,
                       NUMMOD            = nNumMod,
                       COD_ASEGURADO     = nCod_Asegurado,
                       TIPO              = 'Ajuste Reserva'
                WHERE IdProcMasivo = nIdProcMasivo;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   RAISE_APPLICATION_ERROR(-20225,' 2 Error en ACTUALIZA_STATUS UPDATE PROCESOS_MASIVOS_SEGUIMIENTO  '||SQLERRM);
                WHEN OTHERS  THEN
                   RAISE_APPLICATION_ERROR(-20225,' 2 Error en ACTUALIZA_STATUS UPDATE PROCESOS_MASIVOS_SEGUIMIENTO  '||SQLERRM);
             END;

             IF cTipoEvento = 'IVA' THEN
                BEGIN
                   SELECT IdTransaccion
                     INTO nIdTransaccion
                     FROM COBERTURA_SINIESTRO_ASEG
                    WHERE IdSiniestro = nIdSiniestro
                      AND IdPoliza    = nIdPoliza
                      AND IddetSin    = 1
                      AND CodCobert   = cCodCobert
                      AND NumMod      = nNumMod;
                EXCEPTION
                   WHEN OTHERS THEN
                      RAISE_APPLICATION_ERROR(-20225,'COBERTURA_SINIESTRO_ASEG (Ajuste) - Al obtener la Transaccion ocurrió el siguiente error: '||SQLERRM);
                END;

                BEGIN
                   UPDATE TRANSACCION
                      SET FechaTransaccion = dFecProceso
                    WHERE IdTransaccion = nIdTransaccion;

                   UPDATE COMPROBANTES_DETALLE
                      SET FecDetalle = dFecProceso
                    WHERE NumComprob   IN (SELECT NumComprob
                                             FROM COMPROBANTES_CONTABLES
                                            WHERE NumTransaccion = nIdTransaccion);

                   UPDATE COMPROBANTES_CONTABLES
                      SET FecComprob     = dFecProceso,
                          FecSts         = dFecProceso
                    WHERE NumTransaccion = nIdTransaccion;
                EXCEPTION
                   WHEN OTHERS THEN
                      RAISE_APPLICATION_ERROR(-20225,'COBERTURA_SINIESTRO_ASEG (Ajuste) - Al obtener la Transaccion ocurrió el siguiente error: '||SQLERRM);
                END;
             END IF;
          END IF;
       END IF;
    ELSE
       cMsjError := 'No Existe la Póliza No. ' || X.NumPolUnico;
    END IF;

    IF cMsjError IS NULL THEN
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'PROCE');

       IF cAjusteReserva = 'N' AND nIdSiniestro > 0 THEN
          OC_SINIESTRO.ACTIVAR(X.CodCia, X.CodEmpresa, nIdSiniestro, nIdPoliza, X.NumDetUnico);
       END IF;

       cNombreArchLogem   := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,101,','));
       WNUM_ASISTENCIA := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,1,','));

       WRFC_HOSPITAL := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,17,','));

       WRFC_ASISTENCIADORA := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,98,','));

       WARCHIVO_LOGEM := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,101,','));

       BEGIN
          UPDATE PROCESOS_MASIVOS_SEGUIMIENTO
             SET EMI_TIPOPROCESO    = 'ESTSIN',
                 EMI_STSREGPROCESO  = 'EMI',
                 EMI_REGDATOSPROC   = X.RegDatosProc,
                 EMI_USUARIO        = USUSARIO,
                 EMI_TERMINAL       = TERMINAL,
                 EMI_FECHA          = TRUNC(dFechaCamb),
                 EMI_FECHACOMP      = dFechaCamb,
                 IDPOLIZA           = nIdPoliza,
                 ARCHIVO_LOGEM      = cNombreArchLogem,
                 NUM_ASISTENCIA     = WNUM_ASISTENCIA,
                 RFC_HOSPITAL       = WRFC_HOSPITAL,
                 RFC_ASISTENCIADORA = WRFC_ASISTENCIADORA
           WHERE IdProcMasivo     = nIdProcMasivo;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             NULL;
          WHEN OTHERS  THEN
             NULL;
       END;
       ---  Actualizará los campos de Reserva de la Tabla COBERTURA_SINIESTRO_ASEG
       BEGIN
          UPDATE COBERTURA_SINIESTRO_ASEG
             SET MONTO_RESERVADO_LOCAL  = MONTO_RESERVADO_MONEDA,
                 SALDO_RESERVA_LOCAL    = SALDO_RESERVA
           WHERE IDDETSIN      = 1
             AND CODCOBERT     = cCodCobert
             AND IDSINIESTRO   = nIdSiniestro
             AND IDPOLIZA      = nIdPoliza
             AND COD_ASEGURADO = nCod_Asegurado
             AND NUMMOD        = NVL(nNumMod,1);
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20225,'NDF Error al actualizar campos de Reserva en  COBERTURA_SINIESTRO_ASEG : '||SQLERRM);
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20225,'Others Error al actualizar campos de Reserva en  COBERTURA_SINIESTRO_ASEG : '||SQLERRM);
      END;

      SELECT SUM(DECODE(CTS.SIGNO,'-',NVL(MONTO_RESERVADO_MONEDA,0)*(-1),NVL(MONTO_RESERVADO_MONEDA,0)))
        INTO wOCURRIDO
        FROM COBERTURA_SINIESTRO_ASEG G, CONFIG_TRANSAC_SINIESTROS CTS
       WHERE G.IDSINIESTRO   = nIdSiniestro
         AND G.IDPOLIZA      = nIdPoliza
         AND CTS.CODTRANSAC  = G.CODCPTOTRANSAC;

      SELECT SUM(MONTO_PAGADO_MONEDA)
        INTO wPAGADOS
        FROM COBERTURA_SINIESTRO_ASEG
       WHERE IdSiniestro = nIdSiniestro
         AND IdPoliza    = nIdPoliza;

      BEGIN
         UPDATE DETALLE_SINIESTRO_ASEG
            SET MONTO_RESERVADO_LOCAL  = wOCURRIDO,
                MONTO_RESERVADO_MONEDA = wOCURRIDO,
                MONTO_PAGADO_MONEDA    = wPAGADOS,
                MONTO_PAGADO_LOCAL     = wPAGADOS
          WHERE IdSiniestro   = nIdSiniestro
            AND IdPoliza      = nIdPoliza
            AND IdDetSin      = 1
            AND Cod_Asegurado = nCod_Asegurado;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20225,'NDF Error al actualizar DETALLE_SINIESTRO_ASEG : '||SQLERRM);
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20225,'OTHERS Error al actualizar DETALLE_SINIESTRO_ASEG : '||SQLERRM);
      END;

      BEGIN
         UPDATE SINIESTRO
            SET MONTO_RESERVA_LOCAL  = wOCURRIDO,
                MONTO_RESERVA_MONEDA = wOCURRIDO,
                MONTO_PAGO_MONEDA    = wPAGADOS,
                MONTO_PAGO_LOCAL     = wPAGADOS
          WHERE IdSiniestro   = nIdSiniestro
            AND IdPoliza      = nIdPoliza
            AND Cod_Asegurado = nCod_Asegurado;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20225,'NDF Error al actualizar SINIESTRO : '||SQLERRM);
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20225,'OTHERS Error al actualizar SINIESTRO : '||SQLERRM);
      END;
    ELSE
      OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','No se puede Cargar el Siniestro: '||cMsjError);
      OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');

      BEGIN
         UPDATE PROCESOS_MASIVOS_SEGUIMIENTO
            SET ERR_USUARIO      = USUSARIO,
                ERR_TERMINAL     = TERMINAL,
                ERR_FECHA        = TRUNC(dFechaCamb),
                ERR_FECHACOMP    = dFechaCamb,
                IDPOLIZA          = nIdPoliza
          WHERE IdProcMasivo = nIdProcMasivo;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            NULL;
         WHEN OTHERS THEN
            NULL;
      END;
    END IF;
  END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Error - No se puede Cargar el Siniestro '|| SQLERRM);
      OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END ESTIMACION_SINIESTROS;

PROCEDURE PAGO_SINIESTROS(nIdProcMasivo NUMBER) IS
cCodPlantilla      CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE;
cNumSiniRef        SINIESTRO.NumSiniRef%TYPE;
cMotivSiniestro    SINIESTRO.Motivo_de_Siniestro%TYPE;
nIdSiniestro       SINIESTRO.IdSiniestro%TYPE;
nIDetPol           SINIESTRO.IDetPol%TYPE;
nIdPoliza          POLIZAS.IdPoliza%TYPE;
nCodCia            POLIZAS.CodCia%TYPE;
nCodEmpresa        POLIZAS.CodEmpresa%TYPE;
cCod_Moneda        POLIZAS.Cod_Moneda%TYPE;
nTasaCambio        DETALLE_POLIZA.Tasa_Cambio%TYPE;
nCod_Asegurado     ASEGURADO.Cod_Asegurado%TYPE;
nCodCliente        CLIENTE_ASEG.CodCliente%TYPE;
cCodCobert         COBERT_ACT_ASEG.CodCobert%TYPE := 'GMXA';
cCodTransac        COBERTURA_SINIESTRO.CodTransac%TYPE := 'PARVAD';
cCodCptoTransac    COBERTURA_SINIESTRO.CodCptoTransac%TYPE := 'PARVAD';
nNum_Aprobacion    APROBACIONES.Num_Aprobacion%TYPE;
nMonto_Local       APROBACIONES.Monto_Local%TYPE;
nMonto_Moneda      APROBACIONES.Monto_Moneda%TYPE;
cNumFactura        VARCHAR2(45); --FACTURA_EXTERNA.NumFactExt%TYPE;
nIdFactura         FACTURA_EXTERNA.IdeFactExt%TYPE;
cNumDocIdentAsist  PERSONA_NATURAL_JURIDICA.Num_Doc_Identificacion%TYPE;
cTipoAprobacion    APROBACIONES.Tipo_Aprobacion%TYPE;
cNombreProveedor   BENEF_SIN.Nombre%TYPE;
nMtoPendPago       SINIESTRO.Monto_Pago_Moneda%TYPE;
cDescSiniestro     OBSERVACION_SINIESTRO.Descripcion%TYPE;
nOrden             NUMBER(10) := 1;
nOrdenInc          NUMBER(10);
cUpdate            VARCHAR2(4000);
cMsjError          PROCESOS_MASIVOS_LOG.TxtError%TYPE := NULL;
cExisteDatPart     VARCHAR2(1);
cExisteCob         VARCHAR2(1);
nMontoPagar        NUMBER(28,2);
nMontoTotPago      NUMBER(28,2);
nMontoTotIVA       NUMBER(28,2);
nMontoTotISR       NUMBER(28,2);
nBenef             BENEF_SIN.Benef%TYPE;
cNombreBenef       BENEF_SIN.Nombre%TYPE;
cApellPatBenef     BENEF_SIN.Apellido_Paterno%TYPE;
cApellMatBenef     BENEF_SIN.Apellido_Materno%TYPE;
cTipoEvento        VARCHAR2(40);
MontoDePago        NUMBER(28,2);
nSALDO_RESERVA          COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA%TYPE;
nMONTO_RESERVADO_MONEDA COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
TERMINAL            VARCHAR2(50);
USUSARIO            VARCHAR2(50);
IvaCorrecto         NUMBER(28,2);
IsrCorrecto         NUMBER(28,2);
nNombre_Asegurado   PERSONA_NATURAL_JURIDICA.NOMBRE%TYPE;
nApell_Pat_Aseg     PERSONA_NATURAL_JURIDICA.APELLIDO_PATERNO%TYPE;
nApell_Mat_Aseg     PERSONA_NATURAL_JURIDICA.APELLIDO_MATERNO%TYPE;
IDENTIFIQUEISHION   PERSONA_NATURAL_JURIDICA.TIPO_DOC_IDENTIFICACION%TYPE;
NUMEROERREFESE      PERSONA_NATURAL_JURIDICA.NUM_DOC_IDENTIFICACION%TYPE;
nDummyFecha         varchar2(14);
nFechaNacimiento    PERSONA_NATURAL_JURIDICA.FECNACIMIENTO%TYPE;
COD_ASEG_CARGA      ASEGURADO.COD_ASEGURADO%TYPE;
cNombreArchLogem    VARCHAR2(200);
SumAseg1            COBERT_ACT_ASEG.SUMAASEG_MONEDA%TYPE;
TotPagado           COBERTURA_SINIESTRO_ASEG.MONTO_PAGADO_MONEDA%TYPE;
nMontoRvaMoneda     COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
SumaAseguradoReal   COBERT_ACT_ASEG.SUMAASEG_MONEDA%TYPE;
WNUM_ASISTENCIA     PROCESOS_MASIVOS_SEGUIMIENTO.NUM_ASISTENCIA%TYPE;
WRFC_HOSPITAL       PROCESOS_MASIVOS_SEGUIMIENTO.RFC_HOSPITAL%TYPE;
WRFC_ASISTENCIADORA PROCESOS_MASIVOS_SEGUIMIENTO.RFC_ASISTENCIADORA%TYPE;
WARCHIVO_LOGEM      PROCESOS_MASIVOS_SEGUIMIENTO.ARCHIVO_LOGEM%TYPE;
wOCURRIDO           COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
wPAGADOS                COBERTURA_SINIESTRO_ASEG.MONTO_PAGADO_MONEDA%TYPE;
----  Pago T ----  AEVS 16/03/2017
QueHago            COBERTURA_SINIESTRO_ASEG.Saldo_Reserva%TYPE;
PalAurvad          COBERTURA_SINIESTRO_ASEG.Saldo_Reserva%TYPE;
nMtoAproT          APROBACIONES.Monto_Local%TYPE;
nMtoResT           DETALLE_SINIESTRO.Monto_Reservado_Local%TYPE;
NosQueda           COBERT_ACT_ASEG.SUMAASEG_MONEDA%TYPE;
nNumMod            COBERTURA_SINIESTRO_ASEG.NUMMOD%TYPE;
cTipoPago          VARCHAR2(4);
Desc_Tpo_Pgo       VARCHAR2(40);

CURSOR C_CAMPOS_PART  IS
   SELECT NomCampo, OrdenCampo, OrdenProceso, OrdenDatoPart
     FROM CONFIG_PLANTILLAS_CAMPOS
    WHERE CodPlantilla = cCodPlantilla
      AND CodEmpresa   = nCodEmpresa
      AND CodCia       = nCodCia
      AND NomTabla     = 'DATOS_PART_SINIESTROS'
      AND IndDatoPart  = 'S'
    ORDER BY OrdenDatoPart,OrdenCampo;

CURSOR PAGO_Q  IS
   SELECT NomCampo, OrdenCampo, OrdenProceso, OrdenDatoPart
     FROM CONFIG_PLANTILLAS_CAMPOS
    WHERE CodPlantilla = cCodPlantilla
      AND CodEmpresa   = nCodEmpresa
      AND CodCia       = nCodCia
      AND NomTabla     = 'DATOS_PART_SINIESTROS'
      AND IndDatoPart  = 'S'
    ORDER BY OrdenDatoPart,OrdenCampo;

CURSOR EMI_Q IS
   SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
          NumDetUnico, RegDatosProc, TipoProceso,IndColectiva
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;
BEGIN
   SELECT USER ,USERENV('TERMINAL')                   ---  SIGUECARGA
     INTO USUSARIO, TERMINAL
     FROM SYS.DUAL;

   FOR X IN EMI_Q LOOP
      cMsjError := NULL;
      nCodCliente    := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,3,',')));
      cTipoEvento    := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,100,','));

      ----  Tipo de Pago  AEVS 16032017
      cTipoPago    := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,99,','));

      IF cTipoPago = 'P'  THEN
         Desc_Tpo_Pgo := 'PAGO PARCIAL';
      ELSIF cTipoPago = 'T'  THEN
         Desc_Tpo_Pgo := 'PAGO TOTAL';
      END IF;

      IF cTipoEvento = 'VIDA' THEN
         cCodCobert := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,101,','));

         IF cCodCobert IN ('GFUN','FALLEC') THEN
            cCodTransac     := 'PARVBA';
            cCodCptoTransac := 'PARVBA';
         ELSE
            cCodTransac     := 'PARVAD';
            cCodCptoTransac := 'PARVAD';
         END IF;
      END IF;

      BEGIN
         SELECT P.IdPoliza, DP.IDetPol, P.Cod_Moneda
           INTO nIdPoliza, nIDetPol, cCod_Moneda
           FROM POLIZAS P, DETALLE_POLIZA DP
          WHERE P.NumPolUnico = X.NumPolUnico
            AND P.CodCia      = X.CodCia
            AND P.CodEmpresa  = X.CodEmpresa
            AND P.StsPoliza   IN ('REN','EMI','ANU')
            AND P.CodCliente  = nCodCliente
            AND P.IdPoliza    = DP.IdPoliza
            AND DP.IDetPol    = X.NumDetUnico;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            nIdPoliza := 0;
         WHEN TOO_MANY_ROWS THEN
            BEGIN
               SELECT P.IdPoliza, DP.IDetPol, P.Cod_Moneda
                 INTO nIdPoliza, nIDetPol, cCod_Moneda
                 FROM POLIZAS P, DETALLE_POLIZA DP
                WHERE P.NumPolUnico = X.NumPolUnico
                  AND P.CodCia      = X.CodCia
                  AND P.CodEmpresa  = X.CodEmpresa
                  AND P.StsPoliza   IN ('REN','EMI')
                  AND P.CodCliente  = nCodCliente
                  AND P.IdPoliza    = DP.IdPoliza
                  AND DP.IDetPol    = X.NumDetUnico;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  nIdPoliza := 0;
            END;
      END;

      IF OC_POLIZAS.EXISTE_POLIZA(X.CodCia, X.CodEmpresa, nIdPoliza) = 'S' THEN
         cNumSiniRef := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,1,','));
         IF cNumSiniRef IS NULL   THEN
            RAISE_APPLICATION_ERROR(-20225,'  Error en LayOut: No hay Referencia de Siniestro, Favor de validar la información.');
         END IF;

         BEGIN
            SELECT NVL(MAX(IdSiniestro),0)
              INTO nIdSiniestro
              FROM SINIESTRO
             WHERE NumSiniRef = cNumSiniRef
               AND CodCia     = X.CodCia;
         EXCEPTION
            WHEN NO_DATA_FOUND  THEN
               RAISE_APPLICATION_ERROR(-20225,'NDF Error No Encuentra Numero de Siniestro, Favor de validar la información.');
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20225,'OTHERS Error No Encuentra Numero de Siniestro, Favor de validar la información.');
         END;

         IF nIdSiniestro != 0 THEN
            nCod_Asegurado    := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,',')));

            BEGIN
               SELECT SUM(NVL(CS.SALDO_RESERVA,0))
                 INTO nMtoPendPago   -----nMontoRvaMoneda
                 FROM COBERTURA_SINIESTRO_ASEG  CS
                WHERE CS.IDSINIESTRO   =  nIdSiniestro
                  AND CS.IdPoliza      =  nIdPoliza
                  AND CS.CodCobert     = 'GMXA'
                  AND CS.StsCobertura  = 'EMI'
                  AND CS.NUMMOD        = ( SELECT MAX(R.NUMMOD)
                                             FROM COBERTURA_SINIESTRO_ASEG R
                                            WHERE R.IDPOLIZA      = CS.IDPOLIZA
                                              AND R.IDSINIESTRO   = CS.IDSINIESTRO
                                              AND R.COD_ASEGURADO = CS.COD_ASEGURADO
                                              AND R.CODCOBERT     = CS.CODCOBERT
                                              AND R.STSCOBERTURA  = 'EMI' ) ;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  nMtoPendPago  := 0;
               WHEN OTHERS  THEN
                  nMtoPendPago  := 0;
            END;
            IF nMtoPendPago <= 0 THEN
               RAISE_APPLICATION_ERROR(-20225,'El Saldo Pendiente de Pago es menor o igual a Cero, Favor de validar la información.');
            END IF;

            cNumFactura       := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,11,','));
            cMotivSiniestro   := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,12,','));
            cNumDocIdentAsist := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,17,','));
            cDescSiniestro    := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,20,','));

            IF nCod_Asegurado = 0 OR  cTipoEvento = 'VIDA' THEN
               -------   VALIDAMOS QUE EL NOMBRE QUE ENVIAN SEA CORRECTO   ---
               BEGIN
                  SELECT Cod_Asegurado
                    INTO nCod_Asegurado
                    FROM SINIESTRO
                   WHERE IdSiniestro = nIdSiniestro
                     AND CodCia      = X.CodCia;
               EXCEPTION
                  WHEN OTHERS THEN
                     nCod_Asegurado := 0;
               END;

               nNombre_Asegurado  := RTRIM(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,7,',')));
               nApell_Pat_Aseg    := RTRIM(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,8,',')));
               nApell_Mat_Aseg    := RTRIM(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,9,',')));
               nDummyFecha         := RTRIM(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,10,',')));
               nFechaNacimiento    := TO_DATE(RTRIM(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,10,','))),'YYYY/MM/DD');

               BEGIN
                  SELECT Tipo_Doc_Identificacion, Num_Doc_Identificacion
                    INTO IDENTIFIQUEISHION , NUMEROERREFESE
                    FROM PERSONA_NATURAL_JURIDICA
                   WHERE Nombre LIKE  '%'||nNombre_Asegurado||'%'          ---'JORGE OSWALDO'
                     AND Apellido_Paterno   LIKE  '%'||nApell_Pat_Aseg||'%' ---'MORALES'
                     AND Apellido_Materno   LIKE  '%'||nApell_Mat_Aseg||'%' ---'MENES'
                     AND FecNacimiento         = nFechaNacimiento;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     RAISE_APPLICATION_ERROR(-20225,'NDF No se encontró al Asegurado por el nombre cargado');
                  WHEN TOO_MANY_ROWS THEN
                     RAISE_APPLICATION_ERROR(-20225,'2MANYROWS Se encontraron varios registros con el mismo Nombre del Asegurado');
                  WHEN OTHERS THEN
                     RAISE_APPLICATION_ERROR(-20225,'OTHERS No se encontró al Asegurado por el nombre cargado');
               END;

               BEGIN
                  SELECT COD_ASEGURADO
                    INTO COD_ASEG_CARGA
                    FROM ASEGURADO
                   WHERE TIPO_DOC_IDENTIFICACION  = IDENTIFIQUEISHION
                     AND NUM_DOC_IDENTIFICACION   = NUMEROERREFESE;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     RAISE_APPLICATION_ERROR(-20225,'NDF No se encontró al Asegurado por el nombre cargado');
                  WHEN TOO_MANY_ROWS THEN
                     RAISE_APPLICATION_ERROR(-20225,'2MANYROWS Se encontraron varios registros con el mismo Nombre del Asegurado');
                  WHEN OTHERS THEN
                     RAISE_APPLICATION_ERROR(-20225,'OTHERS No se encontró al Asegurado por el nombre cargado');
               END;

               IF COD_ASEG_CARGA != nCod_Asegurado THEN
                  cMsjError := ' El Nombre de Asegurado cargado No concuerda con el Asegurado del Siniestro  ( Codigo de Carga '||COD_ASEG_CARGA||'  Codigo del Siniestro  '||nCod_Asegurado||' )  ' ;
                  RAISE_APPLICATION_ERROR(-20225,' El Nombre de Asegurado cargado No concuerda con el Asegurado del Siniestro   ( Codigo de Carga '||COD_ASEG_CARGA||'  Codigo del Siniestro  '||nCod_Asegurado||' )  ' );
               END IF;
            END IF;

            IF UPPER(cMotivSiniestro) != 'PENDIENTE' THEN
               UPDATE SINIESTRO
                  SET Motivo_de_Siniestro = cMotivSiniestro
                WHERE IdSiniestro = nIdSiniestro
                  AND IdPoliza    = nIdPoliza;
            END IF;

            nTasaCambio       := OC_GENERALES.TASA_DE_CAMBIO(cCod_Moneda, TRUNC(SYSDATE));
            BEGIN
              OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, nIdPoliza, 'Carga Masiva de Pagos, el ' ||
                                                           TO_CHAR(TRUNC(SYSDATE),'DD/MM/YYYY')||' Motivo: '||cDescSiniestro);
            EXCEPTION
              WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Obervación, Favor de validar la información, Error: '||SQLERRM);
            END;

            cCodPlantilla     := OC_CONFIG_PLANTILLAS_PLANCOB.CODIGO_PLANTILLA(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, X.TipoProceso);
            nCodCia           := X.CodCia;
            nCodEmpresa       := X.CodEmpresa;

            ---  AEVS  cambio en la insercion por nueva llave primaria  16/03/2017
            BEGIN
               INSERT INTO DATOS_PART_SINIESTROS
                      (CodCia, IdSiniestro, IdPoliza, FecSts,STSDATPART,FECPROCED,IDPROCMASIVO)
                VALUES(X.CodCia, nIdSiniestro, nIdPoliza, TRUNC(SYSDATE),'PAGSIN',SYSDATE,nIdProcMasivo);
            EXCEPTION
               WHEN OTHERS THEN
                  cMsjError := 'Error: '||SQLERRM;
                  RAISE_APPLICATION_ERROR(-20225,'Error en Insert DATOS_PART_SINIESTROS: '||SQLERRM);
            END;

            FOR I IN C_CAMPOS_PART LOOP
               nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla, X.CodCia, X.CodEmpresa, I.OrdenProceso) + nOrden;
               IF I.OrdenCampo != 9 THEN  -- Estimación del Siniestro
                  cUpdate   := 'UPDATE '||'DATOS_PART_SINIESTROS' || ' ' ||
                               'SET'||' ' || 'CAMPO' || I.OrdenDatoPart || '=' || '''' ||
                                LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) || '''' || ' ' ||
                               'WHERE IdPoliza   = ' || nIdPoliza    ||' '||
                               'AND IdSiniestro  = ' || nIdSiniestro ||' '||
                               'AND CodCia       = ' || X.CodCia     ||' '||
                               'AND IdProcMasivo = ' || nIdProcMasivo
                                ;
                  OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate);
               END IF;
               nOrden := nOrden + 1;
            END LOOP;

            nOrden := 1;
            FOR W IN PAGO_Q LOOP
               nOrdenInc   := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla, X.CodCia, X.CodEmpresa, W.OrdenProceso) + nOrden;
               IF W.OrdenCampo > 6 AND W.OrdenCampo < 82 THEN
                  nMontoPagar := TO_NUMBER(TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc, nOrdenInc,',')),'999999999990.00');

                 IF NVL(nMontoPagar,0) != 0 THEN
                    IF W.NomCampo LIKE '%DESCUENTO%' THEN
                        nMontoTotPago := NVL(nMontoTotPago,0) - NVL(nMontoPagar,0);
                     ELSIF W.NomCampo LIKE '%DEDUCIBLE%' THEN
                           nMontoTotPago := NVL(nMontoTotPago,0) - NVL(nMontoPagar,0);
                     ELSIF W.NomCampo LIKE '%IVA%' THEN
                           nMontoTotIVA   := NVL(nMontoTotIVA,0) + NVL(nMontoPagar,0);
                     ELSIF W.NomCampo LIKE '%ISR%' THEN
                           nMontoTotISR   := NVL(nMontoTotISR,0) + NVL(nMontoPagar,0); -- FALTA VALIDAR QUE SE VA A HACER CON EL ISR?????????
                           nMontoTotPago := NVL(nMontoTotPago,0) - NVL(nMontoPagar,0);
                     ELSE
                        nMontoTotPago  := NVL(nMontoTotPago,0) + NVL(nMontoPagar,0);
                        MontoDePago := Nvl(MontoDePago,0) + NVL(nMontoPagar,0) ;
                     END IF;
                  END IF;
               ELSIF W.OrdenCampo = 82 THEN
                     cNumDocIdentAsist := TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc, nOrdenInc,','));
               ELSIF W.OrdenCampo = 83 THEN
                     cTipoAprobacion   := TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc, nOrdenInc,','));
              END IF;
               nOrden := nOrden + 1;
            END LOOP;

            IF NVL(nMontoTotPago,0) < 0 THEN
               cMsjError := 'El monto total a pagar es Negativo, favor de validar la información.';
               RAISE_APPLICATION_ERROR(-20225,'El monto total a pagar es Negativo, favor de validar la información.');
            ELSIF NVL(nMontoTotPago,0) = 0 AND NVL(nMontoTotIVA,0) = 0 THEN
               cMsjError := 'Registro NO Trae Valores para Pago';
               RAISE_APPLICATION_ERROR(-20225,'Registro NO Trae Valores para Pago');
            ELSIF (NVL(nMontoTotPago,0) + NVL(nMontoTotIVA,0)) > NVL(nMtoPendPago,0) AND  cTipoPago = 'P' THEN  ---  AEVS PAGOT
               RAISE_APPLICATION_ERROR(-20225,'Valor del Pago '|| (NVL(nMontoTotPago,0) + NVL(nMontoTotIVA,0)) ||
                                       ' Supera el Monto Pendiente de Pago del Siniestro ' ||NVL(nMtoPendPago,0));
            ELSE
               nMonto_Local  := NVL(nMontoTotPago,0) + NVL(nMontoTotIVA,0);
               nMonto_Moneda := NVL(nMonto_Local,0) * nTasaCambio;
            END IF;

            ----  VALIDAMOS QUE EL MONTO DEL AJUSTE NO REBASE LA SUMA ASEGURADA   -----   AEVS
                         ---  SUMA ASEGURADA ----
            BEGIN
               SELECT UNIQUE(SUMAASEG_LOCAL)
                 INTO SumAseg1
                 FROM COBERT_ACT_ASEG
                WHERE IDPOLIZA      = nIdPoliza
                  AND CODCOBERT     = cCodCobert
                  AND COD_ASEGURADO = nCod_Asegurado;
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX   THEN
                  SumAseg1 := 0;
               WHEN NO_DATA_FOUND THEN
                  SumAseg1 := 0;
               WHEN OTHERS THEN
                  SumAseg1 := 0;
            END;
            IF SumAseg1 IS NULL THEN
               SumAseg1:= 0;
            END IF;
            ----  monto pagado  ---
            BEGIN
               SELECT SUM(MONTO_PAGADO_MONEDA)
                 INTO TotPagado
                 FROM COBERTURA_SINIESTRO_ASEG
                WHERE IdPoliza      = nIdPoliza
                  AND Cod_Asegurado = nCod_Asegurado
                  AND CodCobert     = cCodCobert ;
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX   THEN
                  TotPagado := 0;
               WHEN NO_DATA_FOUND THEN
                  TotPagado := 0;
               WHEN OTHERS THEN
                  TotPagado := 0;
            END;
            IF TotPagado IS NULL THEN
               TotPagado:= 0;
            END IF;
            nMontoRvaMoneda := 0;
             ---  Monto Reservado Total Cobertura    ---  EMI  porque es lo realmente  reservado.
            BEGIN
               SELECT SUM(NVL(CS.SALDO_RESERVA,0))
                 INTO nMontoRvaMoneda
                 FROM COBERTURA_SINIESTRO_ASEG  CS
                WHERE CS.IdPoliza      = nIdPoliza
                  AND CS.IDSINIESTRO   = nIdSiniestro
                  AND CS.CodCobert     = cCodCobert
                  AND CS.Cod_Asegurado = nCod_Asegurado
                  AND CS.StsCobertura  = 'EMI'
                  AND CS.NUMMOD        = ( SELECT MAX(R.NUMMOD)
                                             FROM COBERTURA_SINIESTRO_ASEG R
                                            WHERE R.IDPOLIZA      = CS.IDPOLIZA
                                              AND R.IDSINIESTRO   = CS.IDSINIESTRO
                                              AND R.COD_ASEGURADO = CS.COD_ASEGURADO
                                              AND R.CodCobert     = CS.CodCobert --RSR 26122016
                                              AND R.StsCobertura  = 'EMI' ) ;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  nMontoRvaMoneda := 0;
               WHEN OTHERS  THEN
                  nMontoRvaMoneda := 0;
            END;
            IF nMontoRvaMoneda IS NULL THEN
               nMontoRvaMoneda := 0;
            END IF;

            IF SumAseg1 > 0 THEN
               SumaAseguradoReal := (SumAseg1 - (nMontoRvaMoneda + TotPagado));
               IF nMontoTotPago >  nMtoPendPago  AND cTipoPago = 'P' THEN
                  cMsjError := 'El monto del Pago NO puede ser mayor a la Reserva.  Reserva :  ' ||nMtoPendPago;
                  RAISE_APPLICATION_ERROR(-20225,'El monto del Pago NO puede ser mayor a la Reserva.  Reserva :  ' ||nMtoPendPago);
               END IF;

               NosQueda :=  ( ( TotPagado + nMtoPendPago + SumaAseguradoReal) - nMonto_Local );
               IF NosQueda < 0 THEN
                  cMsjError :=(' =>  Monto de Cobertura a Pagar NO puede dejar el Monto de Reserva de la cobertura en negativo:  ( '||NosQueda||' )  ');
                  RAISE_APPLICATION_ERROR(-20225,' =>  Monto de Cobertura a Pagar NO puede dejar el Monto de Reserva de la cobertura en negativo:  ( '||NosQueda||' )  ');
               END IF;

               ----------------------------- AJUSTES SI EL PAGO ES TOTAL ----------------------------------------------
               ---  SUMA ASEGURADA ----
               BEGIN
                  SELECT UNIQUE(SUMAASEG_LOCAL)  INTO SumAseg1
                    FROM COBERT_ACT_ASEG
                   WHERE IdPoliza      = nIdPoliza
                     AND CodCobert     = cCodCobert
                     AND Cod_Asegurado = nCod_Asegurado;
               EXCEPTION
                  WHEN DUP_VAL_ON_INDEX   THEN
                     SumAseg1 := 0;
                  WHEN NO_DATA_FOUND THEN
                     SumAseg1 := 0;
                  WHEN OTHERS THEN
                     SumAseg1 := 0;
               END;
               IF SumAseg1 IS NULL THEN
                  SumAseg1:= 0;
               END IF;
                 ----  monto pagado  ---
               BEGIN
                  SELECT SUM(MONTO_PAGADO_MONEDA)
                    INTO TotPagado
                    FROM COBERTURA_SINIESTRO_ASEG
                   WHERE IdPoliza      = nIdPoliza
                     AND Cod_Asegurado = nCod_Asegurado
                     AND CodCobert     = cCodCobert;
               EXCEPTION
                  WHEN DUP_VAL_ON_INDEX   THEN
                     TotPagado := 0;
                  WHEN NO_DATA_FOUND THEN
                     TotPagado := 0;
                  WHEN OTHERS THEN
                     TotPagado := 0;
               END;

               IF cTipoPago = 'T' THEN
                  IF TotPagado IS NULL THEN
                     TotPagado:= 0;
                  END IF;
                  nMontoRvaMoneda := 0;

                  IF nMtoPendPago IS NULL THEN
                     nMtoPendPago := 0;
                  END IF;
                  IF SumAseg1 > 0 THEN
                      SumaAseguradoReal := (SumAseg1 - (nMtoPendPago + TotPagado));
                  END IF;

                  QueHago := ( nMtoPendPago - nMonto_Local);
                  IF QueHago = 0 THEN
                     NULL;
                  ELSIF QueHago > 0  THEN
                     OC_PROCESOS_MASIVOS.DIRVAD(nIdSiniestro,QueHago,cCodCobert);
                  ELSIF QueHago < 0  THEN
                     PalAurvad := ABS(QueHago) ;
                     OC_PROCESOS_MASIVOS.AURVAD(nIdSiniestro,PalAurvad,cCodCobert);
                  END IF;
               END IF;
            END IF;

            IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(X.CodCia, nIdPoliza, nIDetPol, nCod_Asegurado) = 'N' THEN
               nNum_Aprobacion := OC_APROBACIONES.INSERTA_APROBACION(nIdSiniestro, nIdPoliza, nMonto_Local,
                                                                     nMonto_Moneda, cTipoAprobacion, 'APR', nIdFactura);
               BEGIN
                 INSERT INTO DETALLE_APROBACION
                       (Num_Aprobacion, IdDetAprob, Cod_Pago, Monto_Local,
                        Monto_Moneda, IdSiniestro, CodTransac, CodCptoTransac)
                 VALUES(nNum_Aprobacion, 1, cCodCobert, nMonto_Local,
                        nMonto_Moneda, nIdSiniestro, cCodTransac, cCodCptoTransac);
               EXCEPTION
                  WHEN OTHERS THEN
                     RAISE_APPLICATION_ERROR(-20225,'DETALLE APROBACION - Ocurrió el siguiente error: '||SQLERRM);
               END;
            ELSE
               nNum_Aprobacion := OC_APROBACION_ASEG.INSERTA_APROBACION(nIdSiniestro, nIdPoliza, nCod_Asegurado,
                                                                        nMonto_Local, nMonto_Moneda, cTipoAprobacion, 'APR', nIdFactura);

               -- Aseguramos que el IVA no rebase el 16% del monto a pagar ----  IVA
               IvaCorrecto := ( MontoDePago * .16);
               IF nMontoTotIVA > IvaCorrecto THEN
                  cMsjError := ' Error Monto de IVA cargado es mayor al 16% del Monto a Pagar   ' ;
                  RAISE_APPLICATION_ERROR(-20225,' Error Monto de IVA cargado es mayor al 16% del Monto a Pagar  ');
               END IF;
              ---  Aseguramos que el ISR sea correcto  ----  ISR
               IF cTipoEvento = 'VIDA' THEN
                  IsrCorrecto :=  ( MontoDePago * .20 );
                  IF nMontoTotISR > IsrCorrecto THEN
                     cMsjError := ' Error Monto de ISR cargado es mayor al 20% del Monto a Pagar ';
                     RAISE_APPLICATION_ERROR(-20225,' Error Monto de ISR cargado es mayor al 20% del Monto a Pagar  ');
                  END IF;
               ELSE
                  IsrCorrecto :=  ( MontoDePago * .10 );

                  IF nMontoTotISR > IsrCorrecto THEN
                     cMsjError := ' Error Monto de ISR cargado es mayor al 10% del Monto a Pagar  ';
                     RAISE_APPLICATION_ERROR(-20225,' Error Monto de ISR cargado es mayor al 10% del Monto a Pagar  ');
                  END IF;
               END IF;

               cNombreArchLogem   := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,100,','));

               BEGIN
                  UPDATE PROCESOS_MASIVOS_SEGUIMIENTO
                     SET IDPOLIZA       = nIdPoliza,
                         NUM_APROBACION = nNum_Aprobacion,
                         IDSINIESTRO    = nIdSiniestro,
                         COD_ASEGURADO  = nCod_Asegurado,
                         MONTOIVA       = nMontoTotIVA,
                         MONTOPAGAR     = MontoDePago,
                         MONTOISR       = nMontoTotISR,
                         EMI_USUARIO    = USUSARIO,
                         EMI_TERMINAL   = TERMINAL,
                         EMI_FECHA      = TRUNC(SYSDATE),
                         EMI_FECHACOMP  = SYSDATE,
                         TIPO           = 'Paga Siniestro',
                         NUMFACTURA     = cNumFactura,
                         ARCHIVO_LOGEM  = cNombreArchLogem
                   WHERE IdProcMasivo   = nIdProcMasivo;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     RAISE_APPLICATION_ERROR(-20225,' 1 Error en ACTUALIZA_STATUS UPDATE PROCESOS_MASIVOS_SEGUIMIENTO  '||SQLERRM);
                  WHEN OTHERS  THEN
                     RAISE_APPLICATION_ERROR(-20225,' 1 Error en ACTUALIZA_STATUS UPDATE PROCESOS_MASIVOS_SEGUIMIENTO  '||SQLERRM);
               END;
             ------------------------------------------------------------   *******************************    --------------------------------------------------
               IF cTipoEvento = 'VIDA' THEN
                  BEGIN
                     INSERT INTO DETALLE_APROBACION_ASEG
                           (Num_Aprobacion, IdDetAprob, Cod_Pago, Monto_Local,
                            Monto_Moneda, IdSiniestro, CodTransac, CodCptoTransac)
                     VALUES(nNum_Aprobacion, 1, cCodCobert, nMonto_Local,
                            nMonto_Moneda, nIdSiniestro, cCodTransac, cCodCptoTransac);
                  EXCEPTION
                     WHEN OTHERS THEN
                        RAISE_APPLICATION_ERROR(-20225,'DETALLE APROBACION ASEG - Ocurrió el siguiente error: '||SQLERRM);
                  END;
               ELSE
                  BEGIN
                     INSERT INTO DETALLE_APROBACION_ASEG
                           (Num_Aprobacion, IdDetAprob, Cod_Pago, Monto_Local,
                            Monto_Moneda, IdSiniestro, CodTransac, CodCptoTransac)
                     VALUES(nNum_Aprobacion, 1, cCodCobert, nMonto_Local,
                            nMonto_Moneda, nIdSiniestro, cCodTransac, cCodCptoTransac);
                  EXCEPTION
                     WHEN OTHERS THEN
                        RAISE_APPLICATION_ERROR(-20225,'DETALLE APROBACION ASEG - Ocurrió el siguiente error: '||SQLERRM);
                  END;
               END IF;
            END IF;

            IF cNumFactura IS NOT NULL AND cNumDocIdentAsist IS NOT NULL THEN
               nIdFactura := OC_FACTURA_EXTERNA.INSERTAR_FACTURA(X.CodCia, cNumFactura, TRUNC(SYSDATE), 'RFC', cNumDocIdentAsist,
                                                                 nMonto_Moneda, 'Carga Masiva', nIdSiniestro, nNum_Aprobacion, nMontoTotIVA,'UUID',NULL);
            END IF;

            cNombreProveedor := OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO('RFC', cNumDocIdentAsist);
            -- Se adiciona la condición de proveedor y numdoc no sean nulos.
            IF cNombreProveedor IS NOT NULL THEN
               nBenef := OC_BENEF_SIN.INSERTA_BENEF_PROV(nIdSiniestro, nIdPoliza, nCod_Asegurado, 'RFC', cNumDocIdentAsist);
            ELSIF cTipoEvento = 'VIDA' THEN
               nBenef         := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,',')));
               cNombreBenef   := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,7,','));
               cApellPatBenef := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,8,','));
               cApellMatBenef := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,9,','));

               BEGIN
                  INSERT INTO BENEF_SIN
                        (IdSiniestro, IdPoliza, Cod_Asegurado, Benef, Nombre, Apellido_Paterno, Apellido_Materno, PorcePart,
                         CodParent, Estado, Sexo, FecEstado, FecAlta, Obervaciones, IndAplicaISR, PorcentISR)
                  VALUES(nIdSiniestro, nIdPoliza, nCod_Asegurado, nBenef, cNombreBenef, cApellPatBenef, cApellMatBenef, 100,
                         '0014', 'ACT', 'N', TRUNC(SYSDATE), TRUNC(SYSDATE),
                         'Pago por el Siniestro No. ' || cNumSiniRef, 'N', Null);
               EXCEPTION
                  WHEN OTHERS THEN
                     RAISE_APPLICATION_ERROR(-20225,'Error al Insertar Beneficiario de Pago del Siniestro en VIDA '|| cNumSiniRef || ' ' || SQLERRM);
               END;
            ELSE
               -- Aqui se debe crear el beneficiario a partir del asegurado.
               nBenef := OC_BENEF_SIN.INSERTA_ASEG_BENEF(nIdSiniestro, nIdPoliza, nCod_Asegurado);
            END IF;

            IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(X.CodCia, nIdPoliza, nIDetPol, nCod_Asegurado) = 'N' THEN
               BEGIN
                  UPDATE APROBACIONES
                     SET BENEF = nBenef,
                         CTALIQUIDADORA = 8601
                   WHERE Num_Aprobacion = nNum_Aprobacion
                     AND IdSiniestro    = nIdSiniestro
                     AND IdPoliza       = nIdPoliza;
               EXCEPTION
                  WHEN OTHERS THEN
                     RAISE_APPLICATION_ERROR(-20225,'Error al Actualizar la Aprobación Aseg con el Beneficiario '|| cNumSiniRef || ' ' || SQLERRM);
               END;

               BEGIN
                  OC_APROBACIONES.PAGAR(X.CodCia, X.CodEmpresa, nNum_Aprobacion, nIdSiniestro,
                                        nIdPoliza, 1);
               EXCEPTION
                  WHEN OTHERS THEN
                     RAISE_APPLICATION_ERROR(-20225,'Individual. Error al Pagar la Aprobación del Siniestro: '|| nIdSiniestro || ' ' || SQLERRM);
               END;
            ELSE
               BEGIN
                  UPDATE APROBACION_ASEG
                     SET BENEF = nBenef,
                         CTALIQUIDADORA = 8601
                   WHERE Num_Aprobacion = nNum_Aprobacion
                     AND IdSiniestro    = nIdSiniestro
                     AND IdPoliza       = nIdPoliza
                     AND Cod_Asegurado  = nCod_Asegurado;
               EXCEPTION
                  WHEN OTHERS THEN
                     RAISE_APPLICATION_ERROR(-20225,'Error al Actualizar la Aprobación Aseg con el Beneficiario '|| cNumSiniRef || ' ' || SQLERRM);
               END;
               BEGIN
                  OC_APROBACION_ASEG.PAGAR(X.CodCia, X.CodEmpresa, nNum_Aprobacion, nIdSiniestro,
                                           nIdPoliza, nCod_Asegurado, 1);
               EXCEPTION
                  WHEN OTHERS THEN
                     RAISE_APPLICATION_ERROR(-20225,'Colectivos. Error al Pagar la Aprobación del Siniestro: '|| nIdSiniestro || ' ' || SQLERRM);
               END;
            END IF;
         ELSE
            cMsjError := 'NO Existe la Estimación del Siniestro No. ' || nIdSiniestro;
            RAISE_APPLICATION_ERROR(-20225,'Error No se encuentra el Numero del Siniestro: ');
         END IF;
      ELSE
         cMsjError := 'No Existe la Póliza No. ' || X.NumPolUnico;
      END IF;

      IF cMsjError IS NULL THEN
         OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'PROCE');
         WNUM_ASISTENCIA     := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,1,','));
         WRFC_HOSPITAL       := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,17,','));
         WRFC_ASISTENCIADORA := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,98,','));
         WARCHIVO_LOGEM      := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,101,','));

         BEGIN
            UPDATE PROCESOS_MASIVOS_SEGUIMIENTO
               SET EMI_TIPOPROCESO    = 'PAGSIN',
                   EMI_STSREGPROCESO  = 'EMI',
                   EMI_REGDATOSPROC   = X.RegDatosProc,
                   EMI_USUARIO        = USUSARIO,
                   EMI_TERMINAL       = TERMINAL,
                   EMI_FECHA          = TRUNC(SYSDATE),
                   EMI_FECHACOMP      = SYSDATE,
                   IDPOLIZA           = nIdPoliza,
                   NUM_ASISTENCIA     = WNUM_ASISTENCIA,
                   RFC_HOSPITAL       = WRFC_HOSPITAL,
                   RFC_ASISTENCIADORA = WRFC_ASISTENCIADORA,
                   ARCHIVO_LOGEM      = WARCHIVO_LOGEM
             WHERE IdProcMasivo      = nIdProcMasivo;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               NULL;
            WHEN OTHERS  THEN
               NULL;
         END;

         SELECT SUM(DECODE(CTS.SIGNO,'-',NVL(MONTO_RESERVADO_MONEDA,0)*(-1),NVL(MONTO_RESERVADO_MONEDA,0)))
           INTO wOCURRIDO
           FROM COBERTURA_SINIESTRO_ASEG G, CONFIG_TRANSAC_SINIESTROS CTS
          WHERE G.IDSINIESTRO = nIdSiniestro
            AND G.IDPOLIZA    = nIdPoliza
            AND CTS.CODTRANSAC = G.CODCPTOTRANSAC;

         SELECT SUM(MONTO_PAGADO_MONEDA)
           INTO wPAGADOS
           FROM COBERTURA_SINIESTRO_ASEG
          WHERE IdSiniestro = nIdSiniestro
            AND IdPoliza    = nIdPoliza;


         BEGIN
            UPDATE DETALLE_SINIESTRO_ASEG
               SET MONTO_RESERVADO_LOCAL  = wOCURRIDO,
                   MONTO_RESERVADO_MONEDA = wOCURRIDO,
                   MONTO_PAGADO_MONEDA    = wPAGADOS,
                   MONTO_PAGADO_LOCAL     = wPAGADOS
             WHERE IdSiniestro   = nIdSiniestro
               AND IdPoliza      = nIdPoliza
               AND IDDETSIN      = 1
               AND Cod_Asegurado = nCod_Asegurado;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20225,'NDF Error al actualizar DETALLE_SINIESTRO_ASEG : '||SQLERRM);
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20225,'OTHERS Error al actualizar DETALLE_SINIESTRO_ASEG : '||SQLERRM);
         END;

         BEGIN
            UPDATE SINIESTRO
               SET MONTO_RESERVA_LOCAL  = wOCURRIDO,
                   MONTO_RESERVA_MONEDA = wOCURRIDO,
                   MONTO_PAGO_MONEDA    = wPAGADOS,
                   MONTO_PAGO_LOCAL     = wPAGADOS
             WHERE IdSiniestro   = nIdSiniestro
               AND IdPoliza      = nIdPoliza
               AND Cod_Asegurado = nCod_Asegurado;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20225,'NDF Error al actualizar SINIESTRO : '||SQLERRM);
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20225,'OTHERS Error al actualizar SINIESTRO : '||SQLERRM);
         END;
      ELSE
         OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','No se puede Pagar el Siniestro: '||cMsjError);
         OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');

         ---  aevs   seguimiento de  cargas masivas
         BEGIN
            UPDATE PROCESOS_MASIVOS_SEGUIMIENTO
               SET ERR_USUARIO      = USUSARIO,
                   ERR_TERMINAL     = TERMINAL,
                   ERR_FECHA        = TRUNC(SYSDATE),
                   ERR_FECHACOMP    = SYSDATE,
                   IdPoliza         = nIdPoliza
             WHERE IdProcMasivo = nIdProcMasivo;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               NULL;
            WHEN OTHERS  THEN
               NULL;
         END;
      END IF;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','No se puede Pagar el Siniestro '||SQLERRM);
      OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END PAGO_SINIESTROS;

PROCEDURE SINIESTROS_INFONACOT(nIdProcMasivo NUMBER) IS     -- INFOSINI  INICIO
cCodPlantilla          CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE;
cNumSiniRef            SINIESTRO.NumSiniRef%TYPE;
cMotivSiniestro        SINIESTRO.Motivo_de_Siniestro%TYPE;
cCodPaisOcurr          SINIESTRO.CodPaisOcurr%TYPE := '001';
cCodProvOcurr          SINIESTRO.CodProvOcurr%TYPE := '009'; -- No están mandando la direccion del Trabajador, por lo que por default es D.F.
dFec_Ocurrencia        SINIESTRO.Fec_Ocurrencia%TYPE;
dFec_Notificacion      SINIESTRO.Fec_Notificacion%TYPE;
cDescSiniestro         OBSERVACION_SINIESTRO.Descripcion%TYPE;
nIdSiniestro           SINIESTRO.IdSiniestro%TYPE;
nIdPoliza              POLIZAS.IdPoliza%TYPE;
nIDetPol               SINIESTRO.IDetPol%TYPE;
nCodCia                POLIZAS.CodCia%TYPE;
nCodEmpresa            POLIZAS.CodEmpresa%TYPE;
nEstimacionLocal       SINIESTRO.Monto_Reserva_Local%TYPE;
nEstimacionMoneda      SINIESTRO.Monto_Reserva_Moneda%TYPE;
cCod_Moneda            POLIZAS.Cod_Moneda%TYPE;
cIdTipoSeg             DETALLE_POLIZA.IdTipoSeg%TYPE;
nTasaCambio            DETALLE_POLIZA.Tasa_Cambio%TYPE;
cStsDetalle            DETALLE_POLIZA.StsDetalle%TYPE;
nCod_Asegurado         ASEGURADO.Cod_Asegurado%TYPE;
nCodCliente            CLIENTE_ASEG.CodCliente%TYPE;
cCodCobert             COBERT_ACT_ASEG.CodCobert%TYPE;
cCodTransac            COBERTURA_SINIESTRO.CodTransac%TYPE;
cCodCptoTransac        COBERTURA_SINIESTRO.CodCptoTransac%TYPE;
nNumMod                COBERTURA_SINIESTRO.NumMod%TYPE;
nMonto_Reserva_Local   SINIESTRO.Monto_Reserva_Local%TYPE;
nMonto_Reserva_Moneda  SINIESTRO.Monto_Reserva_Moneda%TYPE;
nTotAjusteLocal        SINIESTRO.Monto_Reserva_Local%TYPE;
nTotAjusteMoneda       SINIESTRO.Monto_Reserva_Moneda%TYPE;
nOrden                 NUMBER(10):= 1;
nOrdenInc              NUMBER(10);
cUpdate                VARCHAR2(4000);
cEstado                VARCHAR2(100);
cCiudad                VARCHAR2(100);
cNombreAseg            VARCHAR2(200);
nCantSini              NUMBER(5);
cMsjError              PROCESOS_MASIVOS_LOG.TxtError%TYPE := NULL;
cExisteDatPart         VARCHAR2(1);
cExisteCob             VARCHAR2(1);
cAjusteReserva         VARCHAR2(1) := 'N';
cMotivSiniOrig         VARCHAR2(15);
cTotSiniAseg           NUMBER := 0;
dFecIniVig             POLIZAS.FECINIVIG%TYPE;
dFecFinVig             POLIZAS.FECFINVIG%TYPE;
dFecAnul               POLIZAS.FECANUL%TYPE;
cMotivAnul             POLIZAS.MOTIVANUL%TYPE;
cTipoSiniestro         SINIESTRO.TIPO_SINIESTRO%TYPE;
nCod_AseguradoSini     ASEGURADO.Cod_Asegurado%TYPE;
dFecProceso            DATE;
nIdTransaccion         TRANSACCION.IdTransaccion%TYPE;
nCodError              NUMBER(2) := Null;
cIdCredThona           VARCHAR2(30);
cCadenaEspOrig         VARCHAR2(100) := 'áéíóúÀÁÂÃÄÅÈÉÊËÌÍÎÏÒÓÔÕÖÙÚÛÜ';
cCadenaNormal          VARCHAR2(100) := 'aeiouAAAAAAEEEEIIIIOOOOOUUUU';
cTipoMovimiento        VARCHAR2(2);
nPlazoCredito          NUMBER(5);
nCobertINFO            NUMBER(2);
nNroCuota              NUMBER(2);
nSumAsegDesempleo      NUMBER(14,2);
nCuota                 NUMBER(14,2);
nIdCredito             INFO_ALTBAJ.Id_Credito%TYPE;
nIdTrabaj              INFO_ALTBAJ.Id_Trabajador%TYPE;
nNumRemesa             INFO_ALTBAJ.Nu_Remesa%TYPE;
cIdInfoPoliza          INFO_SINIESTRO.Id_Poliza%TYPE;
nIdInfoEndoso          INFO_SINIESTRO.Id_Endoso%TYPE;
nIdInfoAsegura         INFO_SINIESTRO.Id_Aseguradora%TYPE;
W_ID_ENVIO             INFO_SINIESTRO.ID_ENVIO%TYPE;
W_CODERRORCARGA        INFO_SINIESTRO.CODERRORCARGA%TYPE;
W_MENSUALIDAD          INFO_SINIESTRO.MENSUALIDAD%TYPE;
cCodTransacPgo         DETALLE_APROBACION.CodTransac%TYPE;
cCodCptoTranPgo        DETALLE_APROBACION.CodCptoTransac%TYPE;
cTipoAprobacion        APROBACIONES.Tipo_Aprobacion%TYPE := 'P';
nNum_Aprobacion        APROBACIONES.Num_Aprobacion%TYPE;
nBenef                 BENEF_SIN.Benef%TYPE;
cNombreBenef           BENEF_SIN.Nombre%TYPE;
cApellPatBenef         BENEF_SIN.Apellido_Paterno%TYPE;
cApellMatBenef         BENEF_SIN.Apellido_Materno%TYPE;
cObservacion           VARCHAR2(100) := 'Siniestro Pagado';
cCtaCLABE              BENEF_SIN.Cuenta_Clave%TYPE;
W_GRABA                SAI_CAT_GENERAL.CAGE_VALOR_CORTO%TYPE;
GRABA                  BOOLEAN;

CURSOR C_CAMPOS_PART  IS
   SELECT NomCampo, OrdenCampo, OrdenProceso, OrdenDatoPart
     FROM CONFIG_PLANTILLAS_CAMPOS
    WHERE CodPlantilla = cCodPlantilla
      AND CodEmpresa   = nCodEmpresa
      AND CodCia       = nCodCia
      AND NomTabla     = 'DATOS_PART_SINIESTROS'
      AND IndDatoPart  = 'S'
    ORDER BY OrdenDatoPart,OrdenCampo;

CURSOR SIN_Q IS
   SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
          NumDetUnico, RegDatosProc, TipoProceso, IndColectiva
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;
BEGIN
  FOR X IN SIN_Q LOOP
    nCodCia           := X.CodCia;
    nCodempresa       := X.CodEmpresa;
    cMsjError         := NULL;
    cIdInfoPoliza     :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,1,','));
    nIdInfoEndoso     := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,2,',')));
    nIdInfoAsegura    := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,3,',')));
    nIdCredito        := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,4,',')));
    nIdTrabaj         := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,5,',')));
    nCobertINFO       := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,22,',')));
    W_ID_ENVIO        := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,23,',')));
    cCtaCLABE         :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,24,','));
    dFec_Ocurrencia   :=   TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,25,',')),'DD/MM/YYYY');
    cDescSiniestro    := 'ENDOSO: '||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,2,','));
    nEstimacionMoneda := TO_NUMBER(TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,13,',')),'999999999990.00');
    --
    BEGIN
      SELECT P.IdPoliza,      P.Cod_Moneda,      DP.FecIniVig,       DP.FecFinVig,
             P.FecAnul,       P.MotivAnul,       Dp.IDetPol,         Dp.StsDetalle,
             P.CodCliente,    Dp.Cod_Asegurado,  I.Nu_Remesa,        I.Id_Credito_Thona,
             DP.IdTipoSeg,
             TRUNC(MONTHS_BETWEEN(DP.FecIniVig,dFec_Ocurrencia)) NroCuota,
             I.Cuota
        INTO nIdPoliza,       cCod_Moneda,       dFecIniVig,          dFecFinVig,
             dFecAnul,        cMotivAnul,        nIDetPol,            cStsDetalle,
             nCodCliente,     nCod_Asegurado,    nNumRemesa,          cIdCredThona,
             cIdTipoSeg,
             nNroCuota,
             nCuota
        FROM POLIZAS P, DETALLE_POLIZA DP, INFO_ALTBAJ I
       WHERE I.Id_Credito    = nIdCredito
         AND I.Id_Trabajador = nIdTrabaj
         AND I.IdPoliza      = P.IdPoliza
         AND I.IdPoliza      = DP.IdPoliza
         AND I.IDetPol       = DP.IDetPol
         AND P.CodCia        = X.CodCia
         AND P.CodEmpresa    = X.CodEmpresa
         AND P.StsPoliza   IN ('REN','EMI','ANU');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        nCodError    := 22;
        cObservacion := 'Codigo Error 22: No está reportado en los listados.';
        RAISE_APPLICATION_ERROR(-20225,'Codigo Error 22: No está reportado en los listados.');
    END;
    --
    BEGIN
      SELECT CODERRORCARGA, MENSUALIDAD
        INTO W_CODERRORCARGA, W_MENSUALIDAD
        FROM INFO_SINIESTRO
       WHERE ID_CREDITO    = nIdCredito
         AND ID_TRABAJADOR = nIdTrabaj
         AND ID_ENVIO      = W_ID_ENVIO;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        nCodError    := 22;
        cObservacion := 'Codigo Error 22: No está reportado en los listados.';
        RAISE_APPLICATION_ERROR(-20225,cObservacion);
    END;

    IF W_CODERRORCARGA > 0 THEN
        nCodError    := W_CODERRORCARGA;
        cObservacion := 'Codigo Error '||W_CODERRORCARGA||' : Error de validacion.';
        RAISE_APPLICATION_ERROR(-20225,cObservacion);
    END IF;

    cNumSiniRef       := cIdCredThona;
    dFec_Notificacion := TRUNC(SYSDATE);
    nTasaCambio       := OC_GENERALES.TASA_DE_CAMBIO(cCod_Moneda, TRUNC(SYSDATE));
    nEstimacionLocal  := nEstimacionMoneda * nTasaCambio;
    -- Coberturas
    IF nCobertINFO = 1 THEN
       cCodCobert      := 'DESEMP';
       cTipoSiniestro  := '011';
       cMotivSiniestro := '999';
       cCodTransac     := 'APRVAD';
       cCodCptoTransac := 'APRVAD';
       cCodTransacPgo  := 'PARVAD';
       cCodCptoTranPgo := 'PARVAD';
    ELSIF nCobertINFO = 2 THEN
       cCodCobert      := 'INVALI';
       cTipoSiniestro  := '008';
       cMotivSiniestro := '999';
       cCodTransac     := 'APRVAD';
       cCodCptoTransac := 'APRVAD';
       cCodTransacPgo  := 'PARVAD';
       cCodCptoTranPgo := 'PARVAD';
    ELSIF nCobertINFO = 3 THEN
       cCodCobert := 'FALLEC';
       cTipoSiniestro  := '016';
       cMotivSiniestro := '999';
       cCodTransac     := 'ARSBAS';
       cCodCptoTransac := 'APRVBA';
       cCodTransacPgo  := 'PARVBA';
       cCodCptoTranPgo := 'PARVBA';
    ELSIF nCobertINFO = 4 THEN
       cCodCobert := 'DESINV';
       cTipoSiniestro  := '010';
       cMotivSiniestro := '999';
       cCodTransac     := 'APRVAD';
       cCodCptoTransac := 'APRVAD';
       cCodTransacPgo  := 'PARVAD';
       cCodCptoTranPgo := 'PARVAD';
    ELSE
       nCodError := 29;
       cObservacion := 'Error, el Tipo de Cobertura no es válido.';
       RAISE_APPLICATION_ERROR(-20225,'Error, el Tipo de Cobertura no es válido.');
    END IF;

    -- VALIDA SI ES UN AJUSTE O NUEVO SINIESTRO
    BEGIN
      SELECT IdSiniestro
        INTO nIdSiniestro
        FROM SINIESTRO
       WHERE NumSiniRef = cNumSiniRef
         AND CodCia     = X.CodCia;
    EXCEPTION
      WHEN NO_DATA_FOUND  THEN
           nIdSiniestro := 0;
      WHEN OTHERS THEN
           nIdSiniestro := 0;
    END;

    IF nIdSiniestro = 0 THEN -- Creacion de Siniestro
       nIdSiniestro := OC_SINIESTRO.INSERTA_SINIESTRO(nCodCia, X.CodEmpresa, nIdPoliza, nIDetPol, cNumSiniRef,dFec_Ocurrencia, dFec_Notificacion,
                                                      'Carga Masiva de INFONACOT realizada el ' ||TO_DATE(SYSDATE,'DD/MM/YYYY')||' , con '||cDescSiniestro,
                                                      cTipoSiniestro, cMotivSiniestro, cCodPaisOcurr, cCodProvOcurr);
       BEGIN
         UPDATE SINIESTRO
            SET Cod_Asegurado = nCod_Asegurado
          WHERE CodCia      = nCodCia
            AND IdSiniestro = nIdSiniestro;
       END;

       BEGIN
         OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, nIdPoliza, 'Carga Masiva de INFONACOT, el ' ||
                                                      TO_CHAR(TRUNC(SYSDATE),'DD/MM/YYYY')||' con '||cDescSiniestro);
       EXCEPTION
         WHEN OTHERS THEN
           nCodError := 99;
           cObservacion := 'Error al Insertar la Obervación 1, Favor de validar la información.';
           RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Obervación 2, Favor de validar la información, Error: '||SQLERRM);
       END;

       cCodPlantilla     := OC_CONFIG_PLANTILLAS_PLANCOB.CODIGO_PLANTILLA(nCodCia, nCodempresa, X.IdTipoSeg, X.PlanCob, X.TipoProceso);

       BEGIN
         SELECT 'S'
           INTO cExisteDatPart
           FROM DATOS_PART_SINIESTROS
          WHERE CodCia      = X.CodCia
            AND IdPoliza    = nIdPoliza
            AND IdSiniestro = nIdSiniestro;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           cExisteDatPart := 'N';
       END;

       IF NVL(cExisteDatPart,'N') = 'N' THEN
           INSERT INTO DATOS_PART_SINIESTROS
                  (CodCia, IdSiniestro, IdPoliza, FecSts, StsDatPart, FecProced, IdProcMasivo)
            VALUES(nCodCia, nIdSiniestro, nIdPoliza, TRUNC(SYSDATE), 'SINCER', SYSDATE, nIdProcMasivo);
       END IF;

       FOR I IN C_CAMPOS_PART LOOP
         nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla, X.CodCia, X.CodEmpresa, I.OrdenProceso) + nOrden;
         cUpdate   := 'UPDATE '||'DATOS_PART_SINIESTROS' || ' ' ||
                       'SET'||' ' || 'CAMPO' || I.OrdenDatoPart || '=' || '''' ||
                       LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) || '''' || ' ' ||
                       'WHERE IdPoliza   = ' || nIdPoliza    ||' '||
                       'AND IdSiniestro  = ' || nIdSiniestro ||' '||
                       'AND CodCia       = ' || X.CodCia     ||' '||
                       'AND IdProcMasivo = ' || nIdProcMasivo;
         OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate);
         nOrden := nOrden + 1;
       END LOOP;

       BEGIN
         INSERT INTO DETALLE_SINIESTRO
               (IdSiniestro,        IdPoliza,               IdDetSin,              Monto_Pagado_Moneda,
                Monto_Pagado_Local, Monto_Reservado_Moneda, Monto_Reservado_Local, IdTipoSeg)
         VALUES(nIdSiniestro,       nIdPoliza,              1,                     0,
                0,                  nEstimacionMoneda,      nEstimacionLocal,      cIdTipoSeg);
       EXCEPTION
         WHEN OTHERS THEN
           nCodError := 99;
           cObservacion := 'Error DETALLE SINIESTRO (Cero Sini).';
           RAISE_APPLICATION_ERROR(-20225,'DETALLE SINIESTRO (Cero Sini) - Ocurrió el siguiente error: '||SQLERRM);
       END;

       BEGIN
         SELECT 'S'
           INTO cExisteCob
           FROM COBERT_ACT
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND IdPoliza    = nIdPoliza
            AND IdetPol     = nIDetPol
            AND CodCobert   = cCodCobert;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           nCodError := 99;
           cObservacion := 'NO Existe Cobertura (SIN Aseg).';
           RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura (SIN Aseg) de '||cCodCobert);
       END;

       IF cExisteCob = 'S' THEN
          BEGIN
            INSERT INTO COBERTURA_SINIESTRO
                  (IdDetSin,              CodCobert,           IdSiniestro,        IdPoliza,
                   Doc_Ref_Pago,          Monto_Pagado_Moneda, Monto_Pagado_Local, Monto_Reservado_Moneda,
                   Monto_Reservado_Local, StsCobertura,        NumMod,             CodTransac,
                   CodCptoTransac,        IdTransaccion,       Saldo_Reserva,      IndOrigen,
                   FecRes,                Saldo_Reserva_Local)
            VALUES(1,                     cCodCobert,          nIdSiniestro,       nIdPoliza,
                   NULL,                  0,                   0,                  nEstimacionMoneda,
                   nEstimacionLocal,      'SOL',               1,                  cCodTransac,
                   cCodCptoTransac,       NULL,                nEstimacionMoneda,  'D',
                   TRUNC(SYSDATE), nEstimacionLocal);
          EXCEPTION
            WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'NO Existe COBERTURA SINIESTRO (Cero Sini).';
              RAISE_APPLICATION_ERROR(-20225,'COBERTURA SINIESTRO (Cero Sini) - Ocurrió el siguiente error: '||SQLERRM);
          END;
       END IF;

       IF nIdSiniestro > 0 THEN
          OC_SINIESTRO.ACTIVAR(X.CodCia, X.CodEmpresa, nIdSiniestro, nIdPoliza, X.NumDetUnico);
       END IF;
    ELSE -- SE APLICA AJUSTE Y ADICIONA EL PAGO AL MISMO SINIESTRO
       BEGIN
          OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, nIdPoliza, 'Carga Masiva de INFONACOT de Ajuste de Reserva, el ' ||
                                                       TO_CHAR(TRUNC(SYSDATE),'DD/MM/YYYY')||' Motivo: '||cDescSiniestro);
       EXCEPTION
          WHEN OTHERS THEN
             nCodError := 99;
             cObservacion := 'Error al Insertar la Obervación 3, Favor de validar la información.';
             RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Obervación 4, Favor de validar la información, Error: '||SQLERRM);
       END;

       BEGIN
         SELECT IdSiniestro,  Monto_Reserva_Local,  Monto_Reserva_Moneda,  IDetPol,  Cod_Asegurado
           INTO nIdSiniestro, nMonto_Reserva_Local, nMonto_Reserva_Moneda, nIDetPol, nCod_AseguradoSini
           FROM SINIESTRO
          WHERE NumSiniRef = cNumSiniRef
            AND CodCia     = X.CodCia;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           RAISE_APPLICATION_ERROR(-20225,'NO Existe Siniestro con Referencia No. : '||cNumSiniRef);
         WHEN TOO_MANY_ROWS THEN
           RAISE_APPLICATION_ERROR(-20225,'Existen Varios Siniestros con Referencia No. : '||cNumSiniRef);
       END;
       --
       IF nEstimacionMoneda > 0 THEN
          cCodTransac     := 'AURVAD';
          cCodCptoTransac := 'AURVAD';
          dFecProceso     := TRUNC(SYSDATE);
       ELSIF nEstimacionMoneda < 0 THEN
          cCodTransac     := 'DIRVAD';
          cCodCptoTransac := 'DIRVAD';
          dFecProceso     := TRUNC(SYSDATE);
          nEstimacionMoneda := nEstimacionMoneda * -1;
       END IF;

       BEGIN
         SELECT NVL(MAX(NumMod),0) + 1
           INTO nNumMod
           FROM COBERTURA_SINIESTRO
          WHERE IdSiniestro = nIdSiniestro
            AND CodCobert   = cCodCobert
            AND IdPoliza    = nIdPoliza;
       END;

       BEGIN
         SELECT 'S'
           INTO cExisteCob
           FROM COBERT_ACT
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND IdPoliza    = nIdPoliza
            AND IdetPol     = nIDetPol
            AND CodCobert   = cCodCobert;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           nCodError := 99;
           cObservacion := 'NO Existe Cobertura (SIN Aseg).';
           RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura (SIN Aseg) de '||cCodCobert);
       END;

       IF cExisteCob = 'S' THEN
          BEGIN
            INSERT INTO COBERTURA_SINIESTRO
             (IdDetSin,              CodCobert,           IdSiniestro,         IdPoliza,
              Doc_Ref_Pago,          Monto_Pagado_Moneda, Monto_Pagado_Local,  Monto_Reservado_Moneda,
              Monto_Reservado_Local, StsCobertura,        NumMod,              CodTransac,
              CodCptoTransac,        IdTransaccion,       Saldo_Reserva,       IndOrigen,
              FecRes,                Saldo_Reserva_Local)
            VALUES
             (1,                     cCodCobert,          nIdSiniestro,        nIdPoliza,
             NULL,                   0,                   0,                   nEstimacionMoneda,
             nEstimacionLocal,       'SOL',               nNumMod,             cCodTransac,
             cCodCptoTransac,        NULL,                nEstimacionMoneda,   'D',
             TRUNC(SYSDATE),         nEstimacionLocal);
          EXCEPTION
            WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'NO Existe COBERTURA SINIESTRO (Cero Sini).';
              RAISE_APPLICATION_ERROR(-20225,'COBERTURA SINIESTRO (Cero Sini) - Ocurrió el siguiente error: '||SQLERRM);
          END;
       END IF;
       OC_COBERTURA_SINIESTRO.EMITE_RESERVA(nCodCia, nCodEmpresa, nIdSiniestro, nIdPoliza, 1, cCodCobert, nNumMod, NULL);
    END IF;

    -- PROCESO DE PAGOS  INICIO
    BEGIN
       OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, nIdPoliza, 'Carga Masiva de INFONACOT de Pagos, el ' ||
                                                    TO_CHAR(TRUNC(SYSDATE),'DD/MM/YYYY')||' Motivo: '||cDescSiniestro);
    EXCEPTION
      WHEN OTHERS THEN
        nCodError := 99;
        cObservacion := 'Error al Insertar la Obervación 5, Favor de validar la información.';
        RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Obervación 6, Favor de validar la información, Error: '||SQLERRM);
    END;
    --
    BEGIN
      nNum_Aprobacion := OC_APROBACIONES.INSERTA_APROBACION(nIdSiniestro, nIdPoliza, nEstimacionLocal,
                                                            nEstimacionMoneda, cTipoAprobacion, 'APR', NULL);
    EXCEPTION
      WHEN OTHERS THEN
        nCodError := 99;
        cObservacion := 'Error al Insertar la Aprobación.';
        RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Aprobación: '|| nIdSiniestro || ' ' || SQLERRM);
    END;
    --
    BEGIN
      INSERT INTO DETALLE_APROBACION
            (Num_Aprobacion,     IdDetAprob,      Cod_Pago,          Monto_Local,
             Monto_Moneda,       IdSiniestro,     CodTransac,        CodCptoTransac)
      VALUES(nNum_Aprobacion,    1,               cCodCobert,        nEstimacionLocal,
             nEstimacionMoneda,  nIdSiniestro,    cCodTransacPgo,    cCodCptoTranPgo);
    EXCEPTION
      WHEN OTHERS THEN
        nCodError := 99;
        cObservacion := 'Insertar en DETALLE APROBACION - Ocurrió el siguiente error.';
        RAISE_APPLICATION_ERROR(-20225,'Insertar en DETALLE APROBACION - Ocurrió el siguiente error: '||SQLERRM);
    END;
    --
    nBenef := 1;

    -- ESTE QUERY ESTA EXTRAÑO HAY QUE ANALIZAR SU TIEMPO DE CARGA
    BEGIN
      SELECT TRIM(PNJ.Nombre), TRIM(PNJ.Apellido_Paterno), TRIM(PNJ.Apellido_Materno)
        INTO cNombreBenef, cApellPatBenef, cApellMatBenef
        FROM CLIENTES CLI, PERSONA_NATURAL_JURIDICA PNJ
       WHERE CLI.Tipo_Doc_Identificacion = PNJ.Tipo_Doc_Identificacion
         AND CLI.Num_Doc_Identificacion  = PNJ.Num_Doc_Identificacion
         AND CLI.CodCliente = nCodCliente;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        nCodError := 99;
        cObservacion := 'CLIENTE NO VALIDO.';
        RAISE_APPLICATION_ERROR(-20225,'CLIENTE NO VALIDO, Error: '||SQLERRM);
      WHEN TOO_MANY_ROWS THEN
        nCodError := 99;
        cObservacion := 'CLIENTE NO VALIDO.';
        RAISE_APPLICATION_ERROR(-20225,'CLIENTE DUPLICADO, Error: '||SQLERRM);
    END;
    -- EVALUA SI ES NUEVO O YA TUVO UN SINIESTRO
    IF W_MENSUALIDAD = 1 THEN
       BEGIN
         INSERT INTO BENEF_SIN
               (IdSiniestro,         IdPoliza,         Cod_Asegurado,          Benef,
                Nombre,              Apellido_Paterno, Apellido_Materno,       PorcePart,
                CodParent,           Estado,           Sexo,                   FecEstado,
                FecAlta,             Obervaciones,
                IndAplicaISR,        PorcentISR,       Ent_Financiera,      Cuenta_Clave)
         VALUES(nIdSiniestro,        nIdPoliza,        nCod_Asegurado,         nBenef,
                cNombreBenef,        cApellPatBenef,   cApellMatBenef,         100,
                '0014',              'ACT',            'N',                    TRUNC(SYSDATE),
                TRUNC(SYSDATE),      'Pago por el Siniestro No. ' || cNumSiniRef,
                'N',                 Null,             '072',                  cCtaCLABE);
       EXCEPTION
         WHEN OTHERS THEN
           nCodError := 99;
           cObservacion := 'Error al Insertar Beneficiario de Pago.';
          RAISE_APPLICATION_ERROR(-20225,'Error al Insertar Beneficiario de Pago '|| cNumSiniRef || ' ' || SQLERRM);
       END;
    END IF;

    BEGIN
      UPDATE APROBACIONES
         SET BENEF = nBenef,
             CTALIQUIDADORA = 8601
       WHERE Num_Aprobacion = nNum_Aprobacion
         AND IdSiniestro    = nIdSiniestro
         AND IdPoliza       = nIdPoliza;
    EXCEPTION
      WHEN OTHERS THEN
        nCodError := 99;
        cObservacion := 'Error al Actualizar la Aprobación Aseg con el Beneficiario.';
        RAISE_APPLICATION_ERROR(-20225,'Error al Actualizar la Aprobación Aseg con el Beneficiario '|| cNumSiniRef || ' ' || SQLERRM);
    END;

    BEGIN
      OC_APROBACIONES.PAGAR(X.CodCia, X.CodEmpresa, nNum_Aprobacion, nIdSiniestro, nIdPoliza, 1);
    EXCEPTION
      WHEN OTHERS THEN
        nCodError := 99;
        cObservacion := 'Error al Pagar la Aprobación del Siniestro.';
        RAISE_APPLICATION_ERROR(-20225,'Error al Pagar la Aprobación del Siniestro: '|| nIdSiniestro || ' ' || SQLERRM);
    END;

    -- PROCESO DE PAGOS  FIN
    IF cMsjError IS NULL THEN
       cObservacion := 'Siniestro Pagado';
       nCodError    := 0;
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'PROCE');
    ELSE
       OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','SINIESTROS_INFONACOT No se puede Cargar el Siniestro: '||cMsjError);
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
    END IF;

    OC_PROCESOS_MASIVOS.ACT_INFO_SINI(nIdCredito, nIdTrabaj,W_ID_ENVIO,
                                      nIdSiniestro, dFec_Ocurrencia,cObservacion, nCodError );
  END LOOP;
EXCEPTION
   WHEN OTHERS THEN
     ROLLBACK;
     OC_PROCESOS_MASIVOS.ACT_INFO_SINI(nIdCredito, nIdTrabaj,W_ID_ENVIO,
                                       nIdSiniestro, dFec_Ocurrencia,cObservacion, nCodError );
     OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Error: '||SQLERRM);
     OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');

END SINIESTROS_INFONACOT;   -- INFOSINI  FINI

PROCEDURE SINIESTROS_INFONACOT_EST(nIdProcMasivo NUMBER) IS     -- ASEGMAS  INICIO
cCodPlantilla          CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE;
cNumSiniRef            SINIESTRO.NumSiniRef%TYPE;
cMotivSiniestro        SINIESTRO.Motivo_de_Siniestro%TYPE;
cCodPaisOcurr          SINIESTRO.CodPaisOcurr%TYPE := '001';
cCodProvOcurr          SINIESTRO.CodProvOcurr%TYPE := '009'; -- No están mandando la direccion del Trabajador, por lo que por default es D.F.
dFec_Ocurrencia        SINIESTRO.Fec_Ocurrencia%TYPE;
dFec_Notificacion      SINIESTRO.Fec_Notificacion%TYPE;
cDescSiniestro         OBSERVACION_SINIESTRO.Descripcion%TYPE;
nIdSiniestro           SINIESTRO.IdSiniestro%TYPE;
nIdPoliza              POLIZAS.IdPoliza%TYPE;
nIDetPol               SINIESTRO.IDetPol%TYPE;
nCodCia                POLIZAS.CodCia%TYPE;
nCodEmpresa            POLIZAS.CodEmpresa%TYPE;
nEstimacionLocal       SINIESTRO.Monto_Reserva_Local%TYPE;
nEstimacionMoneda      SINIESTRO.Monto_Reserva_Moneda%TYPE;
cCod_Moneda            POLIZAS.Cod_Moneda%TYPE;
cIdTipoSeg             DETALLE_POLIZA.IdTipoSeg%TYPE;
nTasaCambio            DETALLE_POLIZA.Tasa_Cambio%TYPE;
cStsDetalle            DETALLE_POLIZA.StsDetalle%TYPE;
nCod_Asegurado         ASEGURADO.Cod_Asegurado%TYPE;
nCodCliente            CLIENTE_ASEG.CodCliente%TYPE;
cCodCobert             COBERT_ACT_ASEG.CodCobert%TYPE;
cCodTransac            COBERTURA_SINIESTRO.CodTransac%TYPE;
cCodCptoTransac        COBERTURA_SINIESTRO.CodCptoTransac%TYPE;
nNumMod                COBERTURA_SINIESTRO.NumMod%TYPE;
nMonto_Reserva_Local   SINIESTRO.Monto_Reserva_Local%TYPE;
nMonto_Reserva_Moneda  SINIESTRO.Monto_Reserva_Moneda%TYPE;
nTotAjusteLocal        SINIESTRO.Monto_Reserva_Local%TYPE;
nTotAjusteMoneda       SINIESTRO.Monto_Reserva_Moneda%TYPE;
nOrden                 NUMBER(10):= 1;
nOrdenInc              NUMBER(10);
cUpdate                VARCHAR2(4000);
cEstado                VARCHAR2(100);
cCiudad                VARCHAR2(100);
cNombreAseg            VARCHAR2(200);
nCantSini              NUMBER(5);
cMsjError              PROCESOS_MASIVOS_LOG.TxtError%TYPE := NULL;
cExisteDatPart         VARCHAR2(1);
cExisteCob             VARCHAR2(1);
cAjusteReserva         VARCHAR2(1) := 'N';
cMotivSiniOrig         VARCHAR2(15);
cTotSiniAseg           NUMBER := 0;
dFecIniVig             POLIZAS.FECINIVIG%TYPE;
dFecFinVig             POLIZAS.FECFINVIG%TYPE;
dFecAnul               POLIZAS.FECANUL%TYPE;
cMotivAnul             POLIZAS.MOTIVANUL%TYPE;
cTipoSiniestro         SINIESTRO.TIPO_SINIESTRO%TYPE;
nCod_AseguradoSini     ASEGURADO.Cod_Asegurado%TYPE;
dFecProceso            DATE;
nIdTransaccion         TRANSACCION.IdTransaccion%TYPE;
nCodError              NUMBER(2) := Null;
cIdCredThona           VARCHAR2(30);
cCadenaEspOrig         VARCHAR2(100) := 'áéíóúÀÁÂÃÄÅÈÉÊËÌÍÎÏÒÓÔÕÖÙÚÛÜ';
cCadenaNormal          VARCHAR2(100) := 'aeiouAAAAAAEEEEIIIIOOOOOUUUU';
cTipoMovimiento        VARCHAR2(2);
nPlazoCredito          NUMBER(5);
nCobertINFO            NUMBER(2);
nNroCuota              NUMBER(2);
nSumAsegDesempleo      NUMBER(14,2);
nCuota                 NUMBER(14,2);
nIdCredito             INFO_ALTBAJ.Id_Credito%TYPE;
nIdTrabaj              INFO_ALTBAJ.Id_Trabajador%TYPE;
nNumRemesa             INFO_ALTBAJ.Nu_Remesa%TYPE;
cIdInfoPoliza          INFO_SINIESTRO.Id_Poliza%TYPE;
nIdInfoEndoso          INFO_SINIESTRO.Id_Endoso%TYPE;
nIdInfoAsegura         INFO_SINIESTRO.Id_Aseguradora%TYPE;
W_ID_ENVIO             INFO_SINIESTRO.ID_ENVIO%TYPE;
W_CODERRORCARGA        INFO_SINIESTRO.CODERRORCARGA%TYPE;
W_MENSUALIDAD          INFO_SINIESTRO.MENSUALIDAD%TYPE;
cCodTransacPgo         DETALLE_APROBACION.CodTransac%TYPE;
cCodCptoTranPgo        DETALLE_APROBACION.CodCptoTransac%TYPE;
cTipoAprobacion        APROBACIONES.Tipo_Aprobacion%TYPE := 'P';
nNum_Aprobacion        APROBACIONES.Num_Aprobacion%TYPE;
nBenef                 BENEF_SIN.Benef%TYPE;
cNombreBenef           BENEF_SIN.Nombre%TYPE;
cApellPatBenef         BENEF_SIN.Apellido_Paterno%TYPE;
cApellMatBenef         BENEF_SIN.Apellido_Materno%TYPE;
cObservacion           VARCHAR2(100) := 'Siniestro Pagado';
cCtaCLABE              BENEF_SIN.Cuenta_Clave%TYPE;
W_GRABA                SAI_CAT_GENERAL.CAGE_VALOR_CORTO%TYPE;
GRABA                  BOOLEAN;

CURSOR C_CAMPOS_PART  IS
   SELECT NomCampo, OrdenCampo, OrdenProceso, OrdenDatoPart
     FROM CONFIG_PLANTILLAS_CAMPOS
    WHERE CodPlantilla = cCodPlantilla
      AND CodEmpresa   = nCodEmpresa
      AND CodCia       = nCodCia
      AND NomTabla     = 'DATOS_PART_SINIESTROS'
      AND IndDatoPart  = 'S'
    ORDER BY OrdenDatoPart,OrdenCampo;

CURSOR SIN_Q IS
   SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
          NumDetUnico, RegDatosProc, TipoProceso, IndColectiva
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;
BEGIN
  FOR X IN SIN_Q LOOP
    nCodCia           := X.CodCia;
    nCodempresa       := X.CodEmpresa;
    cMsjError         := NULL;
    cIdInfoPoliza     :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,1,','));
    nIdInfoEndoso     := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,2,',')));
    nIdInfoAsegura    := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,3,',')));
    nIdCredito        := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,4,',')));
    nIdTrabaj         := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,5,',')));
    nCobertINFO       := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,22,',')));
    W_ID_ENVIO        := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,23,',')));
    cCtaCLABE         :=           LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,24,','));
    dFec_Ocurrencia   :=   TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,25,',')),'DD/MM/YYYY');
    cDescSiniestro    := 'ENDOSO: '||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,2,','));
    nEstimacionMoneda := TO_NUMBER(TRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,13,',')),'999999999990.00');

    BEGIN
      SELECT P.IdPoliza,      P.Cod_Moneda,      DP.FecIniVig,       DP.FecFinVig,
             P.FecAnul,       P.MotivAnul,       Dp.IDetPol,         Dp.StsDetalle,
             P.CodCliente,    Dp.Cod_Asegurado,  I.Nu_Remesa,        I.Id_Credito_Thona,
             DP.IdTipoSeg,
             TRUNC(MONTHS_BETWEEN(DP.FecIniVig,dFec_Ocurrencia)) NroCuota,
             I.Cuota
        INTO nIdPoliza,       cCod_Moneda,       dFecIniVig,          dFecFinVig,
             dFecAnul,        cMotivAnul,        nIDetPol,            cStsDetalle,
             nCodCliente,     nCod_Asegurado,    nNumRemesa,          cIdCredThona,
             cIdTipoSeg,
             nNroCuota,
             nCuota
        FROM POLIZAS P, DETALLE_POLIZA DP, INFO_ALTBAJ I
       WHERE I.Id_Credito    = nIdCredito
         AND I.Id_Trabajador = nIdTrabaj
         AND I.IdPoliza      = P.IdPoliza
         AND I.IdPoliza      = DP.IdPoliza
         AND I.IDetPol       = DP.IDetPol
         AND P.CodCia        = X.CodCia
         AND P.CodEmpresa    = X.CodEmpresa
         AND P.StsPoliza   IN ('REN','EMI','ANU');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        nCodError    := 22;
        cObservacion := 'Codigo Error 22: No está reportado en los listados.';
        RAISE_APPLICATION_ERROR(-20225,'Codigo Error 22: No está reportado en los listados.');
    END;

    BEGIN
      SELECT CODERRORCARGA, MENSUALIDAD
        INTO W_CODERRORCARGA, W_MENSUALIDAD
        FROM INFO_SINIESTRO
       WHERE ID_CREDITO    = nIdCredito
         AND ID_TRABAJADOR = nIdTrabaj
         AND ID_ENVIO      = W_ID_ENVIO;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        nCodError    := 22;
        cObservacion := 'Codigo Error 22: No está reportado en los listados.';
        RAISE_APPLICATION_ERROR(-20225,cObservacion);
    END;

    cNumSiniRef       := cIdCredThona;
    dFec_Notificacion := TRUNC(SYSDATE);
    nTasaCambio       := OC_GENERALES.TASA_DE_CAMBIO(cCod_Moneda, TRUNC(SYSDATE));
    nEstimacionLocal  := nEstimacionMoneda * nTasaCambio;
    -- Coberturas
    IF nCobertINFO = 1 THEN
       cCodCobert      := 'DESEMP';
       cTipoSiniestro  := '011';
       cMotivSiniestro := '999';
       cCodTransac     := 'APRVAD';
       cCodCptoTransac := 'APRVAD';
       cCodTransacPgo  := 'PARVAD';
       cCodCptoTranPgo := 'PARVAD';
    ELSIF nCobertINFO = 2 THEN
       cCodCobert      := 'INVALI';
       cTipoSiniestro  := '008';
       cMotivSiniestro := '999';
       cCodTransac     := 'APRVAD';
       cCodCptoTransac := 'APRVAD';
       cCodTransacPgo  := 'PARVAD';
       cCodCptoTranPgo := 'PARVAD';
    ELSIF nCobertINFO = 3 THEN
       cCodCobert := 'FALLEC';
       cTipoSiniestro  := '016';
       cMotivSiniestro := '999';
       cCodTransac     := 'ARSBAS';
       cCodCptoTransac := 'APRVBA';
       cCodTransacPgo  := 'PARVBA';
       cCodCptoTranPgo := 'PARVBA';
    ELSIF nCobertINFO = 4 THEN
       cCodCobert := 'DESINV';
       cTipoSiniestro  := '010';
       cMotivSiniestro := '999';
       cCodTransac     := 'APRVAD';
       cCodCptoTransac := 'APRVAD';
       cCodTransacPgo  := 'PARVAD';
       cCodCptoTranPgo := 'PARVAD';
    ELSE
       nCodError := 29;
       cObservacion := 'Error, el Tipo de Cobertura no es válido.';
       RAISE_APPLICATION_ERROR(-20225,'Error, el Tipo de Cobertura no es válido.');
    END IF;

    -- VALIDA SI ES UN AJUSTE O NUEVO SINIESTRO
    BEGIN
      SELECT IdSiniestro
        INTO nIdSiniestro
        FROM SINIESTRO
       WHERE NumSiniRef = cNumSiniRef
         AND CodCia     = X.CodCia;
    EXCEPTION
      WHEN NO_DATA_FOUND  THEN
           nIdSiniestro := 0;
      WHEN OTHERS THEN
           nIdSiniestro := 0;
    END;

    IF nIdSiniestro = 0 THEN -- Creacion de Siniestro
       nIdSiniestro := OC_SINIESTRO.INSERTA_SINIESTRO(nCodCia, X.CodEmpresa, nIdPoliza, nIDetPol, cNumSiniRef,dFec_Ocurrencia, dFec_Notificacion,
                                                      'Carga Masiva de INFONACOT realizada el ' ||TO_DATE(SYSDATE,'DD/MM/YYYY')||' , con '||cDescSiniestro,
                                                      cTipoSiniestro, cMotivSiniestro, cCodPaisOcurr, cCodProvOcurr);
       BEGIN
         UPDATE SINIESTRO
            SET Cod_Asegurado = nCod_Asegurado
          WHERE CodCia      = nCodCia
            AND IdSiniestro = nIdSiniestro;
       END;

       BEGIN
         OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, nIdPoliza, 'Carga Masiva de INFONACOT, el ' ||
                                                      TO_CHAR(TRUNC(SYSDATE),'DD/MM/YYYY')||' con '||cDescSiniestro);
       EXCEPTION
         WHEN OTHERS THEN
           nCodError := 99;
           cObservacion := 'Error al Insertar la Obervación 1, Favor de validar la información.';
           RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Obervación 2, Favor de validar la información, Error: '||SQLERRM);
       END;

       cCodPlantilla     := OC_CONFIG_PLANTILLAS_PLANCOB.CODIGO_PLANTILLA(nCodCia, nCodempresa, X.IdTipoSeg, X.PlanCob, X.TipoProceso);

       BEGIN
         SELECT 'S'
           INTO cExisteDatPart
           FROM DATOS_PART_SINIESTROS
          WHERE CodCia      = X.CodCia
            AND IdPoliza    = nIdPoliza
            AND IdSiniestro = nIdSiniestro;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           cExisteDatPart := 'N';
       END;

       IF NVL(cExisteDatPart,'N') = 'N' THEN
           INSERT INTO DATOS_PART_SINIESTROS
                  (CodCia, IdSiniestro, IdPoliza, FecSts, StsDatPart, FecProced, IdProcMasivo)
            VALUES(nCodCia, nIdSiniestro, nIdPoliza, TRUNC(SYSDATE), 'SINEST', SYSDATE, nIdProcMasivo);
       END IF;

       FOR I IN C_CAMPOS_PART LOOP
         nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla, X.CodCia, X.CodEmpresa, I.OrdenProceso) + nOrden;
         cUpdate   := 'UPDATE '||'DATOS_PART_SINIESTROS' || ' ' ||
                       'SET'||' ' || 'CAMPO' || I.OrdenDatoPart || '=' || '''' ||
                       LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,',')) || '''' || ' ' ||
                       'WHERE IdPoliza   = ' || nIdPoliza    ||' '||
                       'AND IdSiniestro  = ' || nIdSiniestro ||' '||
                       'AND CodCia       = ' || X.CodCia     ||' '||
                       'AND IdProcMasivo = ' || nIdProcMasivo;
         OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate);
         nOrden := nOrden + 1;
       END LOOP;

       BEGIN
         INSERT INTO DETALLE_SINIESTRO
               (IdSiniestro,        IdPoliza,               IdDetSin,              Monto_Pagado_Moneda,
                Monto_Pagado_Local, Monto_Reservado_Moneda, Monto_Reservado_Local, IdTipoSeg)
         VALUES(nIdSiniestro,       nIdPoliza,              1,                     0,
                0,                  nEstimacionMoneda,      nEstimacionLocal,      cIdTipoSeg);
       EXCEPTION
         WHEN OTHERS THEN
           nCodError := 99;
           cObservacion := 'Error DETALLE SINIESTRO (Cero Sini).';
           RAISE_APPLICATION_ERROR(-20225,'DETALLE SINIESTRO (Cero Sini) - Ocurrió el siguiente error: '||SQLERRM);
       END;

       BEGIN
         SELECT 'S'
           INTO cExisteCob
           FROM COBERT_ACT
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND IdPoliza    = nIdPoliza
            AND IdetPol     = nIDetPol
            AND CodCobert   = cCodCobert;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           nCodError := 99;
           cObservacion := 'NO Existe Cobertura (SIN Aseg).';
           RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura (SIN Aseg) de '||cCodCobert);
       END;

       IF cExisteCob = 'S' THEN
          BEGIN
            INSERT INTO COBERTURA_SINIESTRO
                  (IdDetSin,              CodCobert,           IdSiniestro,        IdPoliza,
                   Doc_Ref_Pago,          Monto_Pagado_Moneda, Monto_Pagado_Local, Monto_Reservado_Moneda,
                   Monto_Reservado_Local, StsCobertura,        NumMod,             CodTransac,
                   CodCptoTransac,        IdTransaccion,       Saldo_Reserva,      IndOrigen,
                   FecRes,                Saldo_Reserva_Local)
            VALUES(1,                     cCodCobert,          nIdSiniestro,       nIdPoliza,
                   NULL,                  0,                   0,                  nEstimacionMoneda,
                   nEstimacionLocal,      'SOL',               1,                  cCodTransac,
                   cCodCptoTransac,       NULL,                nEstimacionMoneda,  'D',
                   TRUNC(SYSDATE), nEstimacionLocal);
          EXCEPTION
            WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'NO Existe COBERTURA SINIESTRO (Cero Sini).';
              RAISE_APPLICATION_ERROR(-20225,'COBERTURA SINIESTRO (Cero Sini) - Ocurrió el siguiente error: '||SQLERRM);
          END;
       END IF;

       IF nIdSiniestro > 0 THEN
          OC_SINIESTRO.ACTIVAR(X.CodCia, X.CodEmpresa, nIdSiniestro, nIdPoliza, X.NumDetUnico);
       END IF;
    ELSE -- SE APLICA AJUSTE Y ADICIONA EL PAGO AL MISMO SINIESTRO
       BEGIN
         OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, nIdPoliza, 'Carga Masiva de INFONACOT de Ajuste de Reserva, el ' ||
                                                      TO_CHAR(TRUNC(SYSDATE),'DD/MM/YYYY')||' Motivo: '||cDescSiniestro);
       EXCEPTION
         WHEN OTHERS THEN
           nCodError := 99;
           cObservacion := 'Error al Insertar la Obervación 3, Favor de validar la información.';
           RAISE_APPLICATION_ERROR(-20225,'Error al Insertar la Obervación 4, Favor de validar la información, Error: '||SQLERRM);
       END;

       BEGIN
         SELECT IdSiniestro,  Monto_Reserva_Local,  Monto_Reserva_Moneda,  IDetPol,  Cod_Asegurado
           INTO nIdSiniestro, nMonto_Reserva_Local, nMonto_Reserva_Moneda, nIDetPol, nCod_AseguradoSini
           FROM SINIESTRO
          WHERE NumSiniRef = cNumSiniRef
            AND CodCia     = X.CodCia;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           RAISE_APPLICATION_ERROR(-20225,'NO Existe Siniestro con Referencia No. : '||cNumSiniRef);
         WHEN TOO_MANY_ROWS THEN
           RAISE_APPLICATION_ERROR(-20225,'Existen Varios Siniestros con Referencia No. : '||cNumSiniRef);
       END;

       IF nEstimacionMoneda > 0 THEN
          cCodTransac       := 'AURVAD';
          cCodCptoTransac   := 'AURVAD';
          dFecProceso       := TRUNC(SYSDATE);
       ELSIF nEstimacionMoneda < 0 THEN
          cCodTransac       := 'DIRVAD';
          cCodCptoTransac   := 'DIRVAD';
          dFecProceso       := TRUNC(SYSDATE);
          nEstimacionMoneda := nEstimacionMoneda * -1;
       END IF;

       BEGIN
         SELECT NVL(MAX(NumMod),0) + 1
           INTO nNumMod
           FROM COBERTURA_SINIESTRO
          WHERE IdSiniestro = nIdSiniestro
            AND CodCobert   = cCodCobert
            AND IdPoliza    = nIdPoliza;
       END;

       BEGIN
         SELECT 'S'
           INTO cExisteCob
           FROM COBERT_ACT
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND IdPoliza    = nIdPoliza
            AND IdetPol     = nIDetPol
            AND CodCobert   = cCodCobert;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           nCodError := 99;
           cObservacion := 'NO Existe Cobertura (SIN Aseg).';
           RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura (SIN Aseg) de '||cCodCobert);
       END;

       IF cExisteCob = 'S' THEN
          BEGIN
            INSERT INTO COBERTURA_SINIESTRO
             (IdDetSin,              CodCobert,           IdSiniestro,         IdPoliza,
              Doc_Ref_Pago,          Monto_Pagado_Moneda, Monto_Pagado_Local,  Monto_Reservado_Moneda,
              Monto_Reservado_Local, StsCobertura,        NumMod,              CodTransac,
              CodCptoTransac,        IdTransaccion,       Saldo_Reserva,       IndOrigen,
              FecRes,                Saldo_Reserva_Local)
            VALUES
             (1,                     cCodCobert,          nIdSiniestro,        nIdPoliza,
             NULL,                   0,                   0,                   nEstimacionMoneda,
             nEstimacionLocal,       'SOL',               nNumMod,             cCodTransac,
             cCodCptoTransac,        NULL,                nEstimacionMoneda,   'D',
             TRUNC(SYSDATE),         nEstimacionLocal);
          EXCEPTION
            WHEN OTHERS THEN
              nCodError := 99;
              cObservacion := 'NO Existe COBERTURA SINIESTRO (Cero Sini).';
              RAISE_APPLICATION_ERROR(-20225,'COBERTURA SINIESTRO (Cero Sini) - Ocurrió el siguiente error: '||SQLERRM);
          END;
       END IF;
       OC_COBERTURA_SINIESTRO.EMITE_RESERVA(nCodCia, nCodEmpresa, nIdSiniestro, nIdPoliza, 1, cCodCobert, nNumMod, NULL);
    END IF;

    IF cMsjError IS NULL THEN
       cObservacion := 'SINIESTRO RECHAZADO';
       nCodError    := 0;
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'PROCE');
    ELSE
       OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','SINIESTROS_INFONACOT No se puede Cargar el Siniestro: '||cMsjError);
       OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
    END IF;

    OC_PROCESOS_MASIVOS.ACT_INFO_SINI(nIdCredito, nIdTrabaj,W_ID_ENVIO,
                                      nIdSiniestro, dFec_Ocurrencia,cObservacion, nCodError );
  END LOOP;
EXCEPTION
   WHEN OTHERS THEN
     ROLLBACK;
     OC_PROCESOS_MASIVOS.ACT_INFO_SINI(nIdCredito, nIdTrabaj,W_ID_ENVIO,
                                       nIdSiniestro, dFec_Ocurrencia,cObservacion, nCodError );
     OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Error: '||SQLERRM);
     OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');

END SINIESTROS_INFONACOT_EST;   -- ASEGMAS  FINI

PROCEDURE ACT_INFO_SINI(nIdCredito NUMBER, nIdTrabajador NUMBER, nIdEnvio NUMBER,
                        nIdSiniestro NUMBER, dFec_Ocurrencia DATE, cObservacion VARCHAR2,
                        nCodError NUMBER) IS
BEGIN
   BEGIN
      UPDATE INFO_SINIESTRO
         SET SINIESTRO          = nIdSiniestro,
             FECHA_SINIESTRO    = dFec_Ocurrencia,
             OBS_SINIESTRO      = cObservacion,
             CVE_NO_PAGO        = nCodError
       WHERE ID_CREDITO    = nIdCredito
         AND ID_TRABAJADOR = nIdTrabajador
         AND ID_ENVIO      = nIdEnvio;
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
  END;
END ACT_INFO_SINI;

PROCEDURE EMISION_CP(nIdProcMasivo NUMBER) IS
nCodCliente        CLIENTES.CodCliente%TYPE;
cTipoDocIdentAseg  CLIENTES.Tipo_Doc_Identificacion%TYPE;
cNumDocIdentAseg   CLIENTES.Num_Doc_Identificacion%TYPE;
nCod_Asegurado     ASEGURADO.Cod_Asegurado%TYPE;
nCodcia            POLIZAS.CodCia%TYPE;
nCodempresa        POLIZAS.CodEmpresa%TYPE;
cCodmoneda         POLIZAS.Cod_Moneda%TYPE;
cPlanCob           PLAN_COBERTURAS.PlanCob%TYPE;
cExiste            VARCHAR2(1);
cExisteDet         VARCHAR2(1);
cNumPolUnico       POLIZAS.NumPolUnico%TYPE;
nIdPoliza          POLIZAS.IdPoliza%TYPE;
cIdTipoSeg         TIPOS_DE_SEGUROS.IdTipoSeg%TYPE;
nPorcComis         POLIZAS.PorcComis%TYPE;
cDescpoliza        POLIZAS.DescPoliza%TYPE;
nCod_Agente        POLIZAS.Cod_Agente%TYPE;
cCodPlanPago       POLIZAS.CodPlanPago%TYPE;
cExisteTipoSeguro  VARCHAR2  (2);
nTasaCambio        DETALLE_POLIZA.Tasa_Cambio%TYPE;
nIDetPol           DETALLE_POLIZA.IdetPol%TYPE;
cIdGrupoTarj       TARJETAS_PREPAGO.IdGrupoTarj%TYPE;
cCodPromotor       DETALLE_POLIZA.CodPromotor%TYPE;
cMsjError          PROCESOS_MASIVOS_LOG.TxtError%TYPE := 'N';
cCodPlantilla      CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE;
cNomTabla          CONFIG_PLANTILLAS_CAMPOS.NomTabla%TYPE;
nOrden             NUMBER(10):= 1  ;
nOrdenInc          NUMBER(10) ;
cUpdate            VARCHAR2(4000);
cRegDatosProc      VARCHAR2(4000);
dFecIniVig         DATE;
dFecFinVig         DATE;
cStsPoliza         POLIZAS.StsPoliza%TYPE;
cExisteParEmi      VARCHAR2(1);
cExisteAsegCert    VARCHAR2(1);
cIndSinAseg        VARCHAR2(1);
cCampo             CONFIG_PLANTILLAS_CAMPOS.NomCampo%TYPE;
nSuma              COBERT_ACT_ASEG.SumaAseg_Local%TYPE;
nIdEndoso          ENDOSOS.IdEndoso%TYPE;
cStsDetalle        DETALLE_POLIZA.StsDetalle%TYPE;
cEndosoReferencia  ENDOSOS.NUMENDREF%TYPE;
fFecEndIni         DATE;
fFecEndFin         DATE;
fHoraIni           VARCHAR2(10);
fHoraFin           VARCHAR2(10);
cDesc_Endoso       ENDOSOS.DESCENDOSO%TYPE;
cNutra             ASEGURADO_CERTIFICADO.CAMPO3%TYPE;
nPrimaPlan         NUMBER(10,2);
nDiasPlan          NUMBER(10,2);

CURSOR C_CAMPOS (cNomTabla VARCHAR2) IS
   SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.TipoCampo
     FROM CONFIG_PLANTILLAS_CAMPOS C
    WHERE C.CodPlantilla = cCodPlantilla
      AND C.CodEmpresa   = nCodEmpresa
      AND C.NomTabla     = cNomTabla
      AND C.CodCia       = nCodCia
    ORDER BY OrdenCampo;

CURSOR C_CAMPOS_PART  IS
   SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.OrdenDatoPart
     FROM CONFIG_PLANTILLAS_CAMPOS C
    WHERE C.CodPlantilla = cCodPlantilla
      AND C.CodEmpresa   = nCodEmpresa
      AND C.CodCia       = nCodCia
      AND C.NomTabla     = 'DATOS_PART_EMISION'
      AND C.IndDatoPart  = 'S'
    ORDER BY OrdenDatoPart, OrdenCampo;

CURSOR C_CAMPOS_ASEG  IS
   SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.OrdenDatoPart
     FROM CONFIG_PLANTILLAS_CAMPOS C
    WHERE C.CodPlantilla = cCodPlantilla
      AND C.CodEmpresa   = nCodEmpresa
      AND C.CodCia       = nCodCia
      AND C.NomTabla     = 'ASEGURADO_CERTIFICADO'
      AND C.IndAseg  = 'S'
    ORDER BY OrdenDatoPart, OrdenCampo;

CURSOR EMI_LOTE (cNumEndosoRef VARCHAR2, cNumeroPolUnico VARCHAR2) IS
   SELECT IdProcMasivo, CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
          NumDetUnico, RegDatosProc, TipoProceso,IndColectiva, IndAsegurado
     FROM PROCESOS_MASIVOS
    WHERE RegDatosProc    LIKE '%|'||cNumEndosoRef||'|%'
      AND cNumeroPolUnico = cNumeroPolUnico;
BEGIN
   BEGIN
     SELECT NumPolUnico, RegDatosProc
       INTO cNumPolUnico, cRegDatosProc
       FROM PROCESOS_MASIVOS
      WHERE IdProcMasivo   = nIdProcMasivo;
   EXCEPTION
       WHEN NO_DATA_FOUND THEN
            cNumPolUnico := NULL;
   END;

   IF cNumPolUnico IS NOT NULL THEN
      cEndosoReferencia := UPPER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cRegDatosProc,7,'|')));

       FOR X IN EMI_LOTE(cEndosoReferencia, cNumPolUnico) LOOP
          nCodcia           := X.CodCia;
          nCodempresa       := X.CodEmpresa;
          cNumPolUnico      := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,5,'|'));
          nIDetPol          := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,'|'));
          cTipoDocIdentAseg := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,19,'|'));
          cNumDocIdentAseg  := UPPER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,20,'|')));
          cEndosoReferencia := UPPER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,7,'|')));
          fFecEndIni        := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,8,'|'));
          fFecEndFin        := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,9,'|'));
          fHoraIni          := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,10,'|'));
          fHoraFin          := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,11,'|'));
          cDesc_Endoso      := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,14,'|'));
          cCodPlanPago      := OC_TIPOS_DE_SEGUROS.PLAN_PAGOS(X.CodCia, X.CodEmpresa, X.IdTipoSeg);
          cCodPlantilla     := OC_CONFIG_PLANTILLAS_PLANCOB.CODIGO_PLANTILLA(X.CodCia,X.CodEmpresa,X.IdTipoSeg,X.PlanCob,X.TipoProceso);
          nPrimaPlan          := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,65,'|'));
          nDiasPlan          := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,66,'|'));

          BEGIN
             SELECT IdPoliza, StsPoliza
               INTO nIdpoliza, cStsPoliza
               FROM Polizas
              WHERE NumPolUnico     = X.NumPolUnico
                AND CodCia          = X.CodCia
                AND CodEmpresa      = X.CodEmpresa
                AND StsPoliza  NOT IN ('ANU','REN');
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                nIdPoliza := 0;
          END;

          IF OC_ENDOSO.EXISTE_CP(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, 'INA', cEndosoReferencia) = 'N' THEN
              nIdEndoso := OC_ENDOSO.CREAR(nIdPoliza);
              OC_ENDOSO.INSERTA_CP(X.CodCia, X.CodEmpresa, nIdPoliza, nIDetPol, nIdEndoso,
                                'INA', cEndosoReferencia ,fFecEndIni, fFecEndFin, cCodPlanPago, 0, 0, 0, '010',
                                cDesc_Endoso || '. Inicia: ' || fHoraIni || ' y termina: ' || fHoraFin, fFecEndFin);
          ELSE
              IF OC_ENDOSO.ESTATUS_CP(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, cEndosoReferencia) = 'SOL' THEN
                  nIdEndoso := OC_ENDOSO.NUMERO_CP(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, cEndosoReferencia);
              ELSE
                  OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(X.IdProcMasivo,'AUTOMATICO','20225','Cargar el Asegurado: '||cMsjError);
                  OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(X.IdProcMasivo,'ERROR');
              END IF;
          END IF;

          IF nIdEndoso > 0 THEN
              IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(cTipoDocIdentAseg, cNumDocIdentAseg) = 'N' THEN
                 OC_PROCESOS_MASIVOS.INSERT_DINAMICO(cCodPlantilla, 'PERSONA_NATURAL_JURIDICA', 5, X.RegDatosProc);
              ELSE
                 nOrden    := 1;
                 nOrdenInc := 0;
                 FOR I IN C_CAMPOS('PERSONA_NATURAL_JURIDICA') LOOP
                    nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + nOrden;
                    IF UPPER(I.NomCampo) = 'FECNACIMIENTO' THEN
                       nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + nOrden;
                       cUpdate := 'UPDATE '||'PERSONA_NATURAL_JURIDICA'||' '||'SET'||' '||I.NomCampo||'='|| 'TO_DATE(' || CHR(39) ||
                                  LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,'|') || CHR(39) || ','|| CHR(39) ||
                                  'DD/MM/RRRR' || CHR(39) || ') ' ||
                                  'WHERE Tipo_Doc_Identificacion='||''''||cTipoDocIdentAseg||''''||' '||
                                  'AND Num_Doc_Identificacion='||''''||cNumDocIdentAseg||'''');
                       OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate);
                    END IF;
                    nOrden := nOrden + 1;
                 END LOOP;
              END IF;
              nOrden    := 1;
              nOrdenInc := 0;

              IF OC_PERSONA_NATURAL_JURIDICA.FUNC_VALIDA_EDAD(cTipoDocIdentAseg, cNumDocIdentAseg, X.CodCia, X.CodEmpresa ,X.IdTipoSeg ,X.PlanCob)= 'N' THEN
                 RAISE_APPLICATION_ERROR(-20225,'Edad del Asegurado Fuera del Rango de Aceptación de Coberturas');
              END IF;
              BEGIN
                 SELECT Cod_Agente
                   INTO nCod_Agente
                   FROM PLAN_COBERTURAS
                  WHERE CodCia     = X.CodCia
                    AND CodEmpresa = X.CodEmpresa
                    AND IdTipoSeg  = X.IdTipoSeg
                    AND PlanCob    = X.PlanCob;
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    nCod_Agente := 0;
              END;

              nCodCliente := OC_CLIENTES.CODIGO_CLIENTE(cTipoDocIdentAseg, cNumDocIdentAseg);
              IF nCodCliente = 0  THEN
                 nCodCliente    := OC_CLIENTES.INSERTAR_CLIENTE(cTipoDocIdentAseg,cNumDocIdentAseg);
              END IF;

              nCod_Asegurado := OC_ASEGURADO.CODIGO_ASEGURADO(X.CodCia, X.CodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);

              IF nCod_Asegurado = 0 THEN
                 nCod_Asegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(X.CodCia, X.CodEmpresa,cTipoDocIdentAseg, cNumDocIdentAseg);
              END IF;

              BEGIN
                 INSERT INTO CLIENTE_ASEG
                       (CodCliente, Cod_Asegurado)
                 VALUES(nCodCliente, nCod_Asegurado);
              EXCEPTION
                 WHEN DUP_VAL_ON_INDEX THEN
                    NULL;
              END;

              cCodMoneda        := OC_PLAN_COBERTURAS.MONEDA_PLANCOB(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob);
              cExisteTipoSeguro := OC_TIPOS_DE_SEGUROS.EXISTE_TIPO_DE_SEGURO(X.CodCia, X.CodEmpresa, X.IdTipoSeg);

              IF cExisteTipoSeguro = 'S' THEN
                 BEGIN
                    -- Inserta Tarea de Seguimiento
                    IF OC_TAREA.EXISTE_TAREA(X.CodCia,nIdPoliza) = 'N' THEN
                       OC_TAREA.INSERTA_TAREA(X.CodCia, 7, 'SOL', 'EMI', nIdPoliza, nCodCliente, 'A','SOL', 'SOLICITUD DE EMISION');
                    END IF;
                    -- Genera Detalle de Poliza
                    nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));

                    BEGIN
                       SELECT FecIniVig ,FecFinVig, StsPoliza
                         INTO dFecIniVig,dFecFinVig, cStsPoliza
                         FROM Polizas
                        WHERE IdPoliza   = nIdPoliza
                          AND CodCia     = X.CodCia
                          AND CodEmpresa = X.CodEmpresa;
                    END;
                    BEGIN
                       SELECT IDetPol, IndSinAseg, StsDetalle, CodPlanPago
                         INTO nIDetPol, cIndSinAseg, cStsDetalle, cCodPlanPago
                         FROM DETALLE_POLIZA
                        WHERE CodCia      = X.CodCia
                          AND CodEmpresa  = X.CodEmpresa
                          AND IdPoliza    = nIdpoliza
                          AND NumDetRef   = TRIM(TO_CHAR(X.NumDetUnico))
                          AND IdTipoSeg   = X.IdTipoSeg
                          AND PlanCob     = X.PlanCob;
                    EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                          RAISE_APPLICATION_ERROR(-20225,'DETALLE POLIZA NO EXISTE: '|| TRIM(TO_CHAR(X.NumDetUnico)) ||
                                                  ' Con el Producto ' || X.IdTipoSeg || ' y el Plan de Coberturas ' || X.PlanCob);
                    END;
                    nOrden    := 1;
                    nOrdenInc := 0;
                    IF FALSE THEN
                        FOR I IN C_CAMPOS('ENDOSOS') LOOP
                           nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla ,X.CodCia, X.CodEmpresa ,I.OrdenProceso) + nOrden;
                           IF UPPER(I.NomCampo) = 'FECINIVIG' THEN
                              IF (TO_DATE(fFecEndIni,'DD/MM/YY') NOT BETWEEN  dFecIniVig AND  dFecFinVig) OR (TO_DATE(fFecEndIni,'DD/MM/YY') < TO_DATE(TRUNC(SYSDATE),'DD/MM/YY')) THEN
                                  RAISE_APPLICATION_ERROR(-20225,'Fecha de Inicio de Vigencia del Endoso debe estar dentro de la Vigencia de la Póliza y debe ser posterior a la fecha actual.');
                              END IF;

                           END IF;
                           IF UPPER(I.NomCampo) = 'FECFINVIG' THEN
                              IF (TO_DATE(fFecEndFin,'DD/MM/YY') NOT BETWEEN  dFecIniVig AND  dFecFinVig) OR (TO_DATE(fFecEndFin,'DD/MM/YY') < TO_DATE(TRUNC(SYSDATE),'DD/MM/YY')) THEN
                                 RAISE_APPLICATION_ERROR(-20225,'Fecha de Final de Vigencia del Endoso debe estar dentro de la Vigencia de la Póliza y debe ser posterior a la fecha actual.');
                              END IF;
                           END IF;
                          nOrden := nOrden + 1;
                        END LOOP;
                    END IF;
                    nOrden    := 1;
                    nOrdenInc := 0;
                    IF NVL(X.IndAsegurado,'N') = 'S' THEN
                       nOrden    := 1;
                       nOrdenInc := 0;
                       -- nIdEndoso := 0;

                       IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO_CP(X.CodCia, nIdpoliza, nIDetPol, nCod_Asegurado, nIdEndoso) = 'N' THEN
                          IF cStsPoliza = 'SOL' OR cStsDetalle = 'SOL' THEN
                             OC_ASEGURADO_CERTIFICADO.INSERTA(X.CodCia, nIdpoliza, nIDetPol, nCod_Asegurado, 0);
                          ELSE
                             OC_ASEGURADO_CERTIFICADO.INSERTA(X.CodCia, nIdpoliza, nIDetPol, nCod_Asegurado, nIdEndoso);
                             --    ACTUALIZAMOS CON EL VALOR NUTRA (UNICO PARA CADA ASEGURADO)

                             UPDATE ASEGURADO_CERTIFICADO
                                SET CAMPO3        = cNutra
                              WHERE CodCia        = X.CodCia
                                AND IdPoliza      = nIdPoliza
                                AND IDetPol       = nIDetPol
                                AND IdEndoso      = nIdEndoso
                                AND Cod_Asegurado = nCod_Asegurado;
                          END IF;
                       ELSE
                          RAISE_APPLICATION_ERROR(-20225,'Asegurado No. : ' || nCod_Asegurado || ' Duplicado en Certificado No. ' || nIDetPol || ', Endoso No. ' || nIdEndoso);
                       END IF;

                       -- LA FUNCION ORIGINAL NO TENIA ESTE FOR
                       FOR I IN C_CAMPOS_PART LOOP
                          BEGIN
                             SELECT 'S'
                               INTO cExisteParEmi
                               FROM DATOS_PART_EMISION
                              WHERE CodCia    = X.CodCia
                                AND IdPoliza  = nIdPoliza
                                AND IDetPol   = nIDetPol
                                AND CAMPO1    = nIdEndoso;
                          EXCEPTION
                             WHEN NO_DATA_FOUND THEN
                                cExisteParEmi := 'N';
                          END;

                          IF NVL(cExisteParEmi,'N') = 'N' AND NVL(nIdEndoso,0) != 0 THEN
                              BEGIN
                                 INSERT INTO DATOS_PART_EMISION
                                        (CodCia, Idpoliza, IdetPol, CAMPO1, StsDatPart, FecSts)
                                 VALUES (X.CodCia, nIdPoliza, nIDetPol, nIdEndoso, 'SOL', trunc(SYSDATE));
                              EXCEPTION
                                 WHEN OTHERS THEN
                                     RAISE_APPLICATION_ERROR(-20225,'INSERT INTO DATOS_PART_EMISION: ' || SQLERRM);
                              END;
                          END IF;

                          nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla, X.CodCia, X.CodEmpresa, I.OrdenProceso);
                          cUpdate   := 'UPDATE '||'DATOS_PART_EMISION'||' '||'SET'||' '||'CAMPO'||I.OrdenDatoPart||'='||''''||
                                       LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc, nOrdenInc + 1 + nOrden,'|')||''''||' '||
                                       'WHERE IdPoliza='||nIdPoliza||' '||'AND IDetPol='||nIDetPol||' ' || 'AND CAMPO1=' || nIdEndoso || ' ' || 'AND CodCia=' || X.CodCia);
                          OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate);
                          nOrden := nOrden + 1;
                       END LOOP;

                       FOR I IN C_CAMPOS_ASEG LOOP
                          nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla, X.CodCia, X.CodEmpresa, I.OrdenProceso);
                          cUpdate   := 'UPDATE '||'ASEGURADO_CERTIFICADO'||' '||'SET'||' '||'CAMPO'||I.OrdenDatoPart||'='||''''||
                                       LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc + 1,'|')||''''||' '||
                                       'WHERE IdPoliza = '||nIdPoliza||' '|| 'AND IDetPol= '||nIDetPol||' '||'AND IdEndoso= '||nIdEndoso||' '||
                                       'AND CodCia= '||X.CodCia||'AND Cod_Asegurado= '||nCod_Asegurado);
                          OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate);
                          nOrden := nOrden + 1;
                       END LOOP;
                       --  Se quita temporalmente la carga de coberturas para agilizar el proceso de Emisión y solo se deja para Endosos
                          IF OC_COBERT_ACT_ASEG.EXISTE_COBERTURA (X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob,
                                                                 nIdPoliza, nIDetPol, nCod_Asegurado) = 'N' THEN
                             IF NVL(cIndSinAseg,'N') = 'N' THEN
--                                   OC_COBERT_ACT_ASEG.CARGAR_COBERTURAS(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob,
--                                                                       nIdPoliza, nIDetPol, nTasaCambio, nCod_Asegurado);
                                  OC_COBERT_ACT_ASEG.CARGAR_COBERTURAS(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, nIdPoliza,
                                                                       nIDetPol, nTasaCambio, nCod_Asegurado, NULL, 0, 0, 0, 0, 99, 0, 0, 0, 0, 0, 0);
                                   UPDATE COBERT_ACT_ASEG
                                      SET PRIMA_MONEDA  = (PRIMA_MONEDA / 365) * nDiasPlan,
                                          PRIMA_LOCAL   = (PRIMA_LOCAL / 365) * nDiasPlan,
                                          TASA          = ((PRIMA_LOCAL / 365) * nDiasPlan) / SUMAASEG_LOCAL
                                    WHERE CodCia        = X.CodCia
                                      AND IdPoliza      = nIdPoliza
                                      AND IDetPol       = nIDetPol
                                      AND StsCobertura  = 'SOL'
                                      AND Cod_Asegurado = nCod_Asegurado
                                      AND IdEndoso      = nIdEndoso;

                                   OC_PROCESOS_MASIVOS.INSERTA_BENEFICIARIO_01(cCodPlantilla, 'BENEFICIARIO', 9, X.RegDatosProc, nIdPoliza, nIDetPol, nCod_Asegurado);
                                   OC_PROCESOS_MASIVOS.INSERTA_BENEFICIARIO_01(cCodPlantilla, 'BENEFICIARIO', 10, X.RegDatosProc, nIdPoliza, nIDetPol, nCod_Asegurado);
                                   OC_PROCESOS_MASIVOS.INSERTA_BENEFICIARIO_01(cCodPlantilla, 'BENEFICIARIO', 11, X.RegDatosProc, nIdPoliza, nIDetPol, nCod_Asegurado);
                                   OC_PROCESOS_MASIVOS.INSERTA_BENEFICIARIO_01(cCodPlantilla, 'BENEFICIARIO', 12, X.RegDatosProc, nIdPoliza, nIDetPol, nCod_Asegurado);
                             ELSE
                                BEGIN
                                   SELECT 'CAMPO'||ORDENCAMPO CAMPO
                                     INTO cCampo
                                     FROM CONFIG_PLANTILLAS_CAMPOS
                                    WHERE CodCia        = X.CodCia
                                      AND CodEmpresa    = X.CodEmpresa
                                      AND CodPlantilla  = cCodPlantilla
                                      AND NomCampo LIKE  '%MONTO%CREDITO%'
                                      AND IndAseg       = 'S';
                                EXCEPTION
                                   WHEN NO_DATA_FOUND THEN
                                      RAISE_APPLICATION_ERROR(-20225,'NO EXISTE CAMPO MONTO CREDITO EN PLANTILLA: '||cCodPlantilla);
                                   WHEN TOO_MANY_ROWS THEN
                                      RAISE_APPLICATION_ERROR(-20225,'EXISTE MAS DE UN CAMPO MONTO CREDITO EN PLANTILLA: '||cCodPlantilla);
                                END;
                                nSuma := OC_ASEGURADO_CERTIFICADO.SUMA_ASEGURADO(nCodCia, nIdPoliza,nIdetPol,nCod_Asegurado,cCampo);
                                OC_COBERT_ACT_ASEG.CARGAR_COBERTURAS_SIN_TARIFA(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, nIdPoliza,
                                                                                nIDetPol, nTasaCambio, nCod_Asegurado, nSuma);
    --                            OC_ENDOSO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso);
                             END IF;
                             OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(X.CodCia, X.CodEmpresa, nIdPoliza, nIDetPol,nCod_Asegurado);
                          END IF;
                    END IF;
                    IF OC_AGENTES_DETALLES_POLIZAS.EXISTE_AGENTE (X.CodCia, nIdPoliza, nIDetPol, X.IdTipoSeg, nCod_Agente) = 'N' THEN
                       IF nCod_Agente IS NOT NULL THEN
                          OC_AGENTES_DETALLES_POLIZAS.INSERTA_AGENTE(X.CodCia, nIdPoliza, nIDetPol, X.IdTipoSeg, nCod_Agente);
                       END IF;
                    END IF;

                    IF NVL(cIndSinAseg,'N') = 'N' OR NVL(nIdEndoso,0) = 0 THEN
                       OC_POLIZAS.ACTUALIZA_VALORES(X.CodCia, nIdPoliza, 0);
                       OC_DETALLE_POLIZA.ACTUALIZA_VALORES(X.CodCia, nIdPoliza, nIDetPol, 0);
                       OC_ENDOSO.ACTUALIZA_VALORES(X.CodCia, X.CodEmpresa, nIdPoliza, nIDetPol, nIdEndoso);
                    ELSIF NVL(nIdEndoso,0) != 0 THEN
                       OC_ENDOSO.ACTUALIZA_VALORES(X.CodCia, X.CodEmpresa, nIdPoliza, nIDetPol, nIdEndoso);
                    END IF;
                 EXCEPTION
                    WHEN OTHERS THEN
                       cMsjError := SQLERRM;
                 END ;
                 IF cMsjError = 'N'   THEN
                   OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(X.IdProcMasivo,'PROCE');
                 ELSE
                    OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(X.IdProcMasivo,'AUTOMATICO','20225','No se puede Cargar el Asegurado: '||cMsjError);
                    OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(X.IdProcMasivo,'ERROR');
                 END IF;
              ELSE
                 OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(X.IdProcMasivo,'ERROR');
              END IF;
          END IF;
       END LOOP;

    -- SE MANDA LLAMAR AL PROCESO DE PARA EMITIR LOS ASEGURADOS AGREGADOS
       EMITE_ASEGURADO_MASIVO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso);
       EMITE_ENDOSO_CP(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso);

       BEGIN
           DELETE DATOS_PART_EMISION
            WHERE CODCIA   = nCodCia
              AND IDPOLIZA = nIdPoliza
               AND IDETPOL  = nIDetPol;
       EXCEPTION
           WHEN OTHERS THEN
           cMsjError := SQLERRM;
       END;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','No se puede Cargar el Asegurado: '||SQLERRM);
      OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END EMISION_CP;

PROCEDURE EMITE_ASEGURADO_MASIVO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER) IS
-- Dummy        NUMBER(5);
-- nRegis       NUMBER(6);
cStsPoliza   POLIZAS.StsPoliza%TYPE;
cIdTipoSeg   DETALLE_POLIZA.IdTipoSeg%TYPE;
cPlanCob     DETALLE_POLIZA.PLANCOB%TYPE;
dFecIniVig   DETALLE_POLIZA.FecIniVig%TYPE;
dFecFinVig   DETALLE_POLIZA.FecFinVig%TYPE;
nCod_Asegurado ASEGURADO_CERTIFICADO.Cod_Asegurado%TYPE;
cIndSinAseg  VARCHAR2(1);
CURSOR C_ASEG IS
   SELECT Cod_Asegurado,SumaAseg,PrimaNeta
     FROM ASEGURADO_CERTIFICADO
    WHERE IdPoliza      = nIdPoliza
      AND IdetPol       = nIDetPol
      AND Estado        = 'SOL';
BEGIN
   BEGIN
      BEGIN
         SELECT StsPoliza
           INTO cStsPoliza
           FROM POLIZAS
          WHERE CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND IdPoliza   = nIdPoliza;
      END;

      BEGIN
         SELECT FecIniVig, FecFinVig, IndSinAseg, IdTipoSeg, PlanCob
           INTO dFecIniVig, dFecFinVig, cIndSinAseg, cIdTipoSeg, cPlanCob
           FROM DETALLE_POLIZA
          WHERE CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND IdPoliza   = nIdPoliza
            AND IdetPol    = nIDetPol;
      END;
         IF TRUE THEN
             FOR X IN C_ASEG LOOP
            IF NVL(cIndSinAseg,'N') = 'N' THEN
               OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, nIDetPol, 0);
               OC_POLIZAS.ACTUALIZA_VALORES(nCodCia, nIdPoliza, 0);
               OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(nCodCia,nCodEmpresa,nIdPoliza,nIDetPol,X.Cod_Asegurado);
            END IF;
            IF cStsPoliza = 'EMI' THEN
               OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(nCodCia,   nCodEmpresa, nIdPoliza, nIDetPol,X.Cod_Asegurado);
               BEGIN
                  UPDATE ASEGURADO_CERTIFICADO
                     SET Estado    = 'EMI',
                         IdEndoso  = nIdEndoso
                   WHERE CodCia        = nCodCia
                     AND IdPoliza      = nIdPoliza
                     AND IdetPol       = nIDetPol
                     AND Cod_Asegurado = X.Cod_Asegurado;
               END;
               BEGIN
                  UPDATE COBERT_ACT_ASEG
                     SET StsCobertura = 'EMI',
                         IdEndoso     = nIdEndoso
                    WHERE CodCia       = nCodCia
                     AND IdPoliza      = nIdPoliza
                     AND IdetPol       = nIDetPol
                     AND Cod_Asegurado = X.Cod_Asegurado ;
               END;
               BEGIN
                  UPDATE ASISTENCIAS_ASEGURADO
                     SET StsAsistencia = 'EMITID',
                         FecSts        = TRUNC(SYSDATE),
                         IdEndoso      = nIdEndoso
                   WHERE CodCia        = nCodCia
                     AND IdPoliza      = nIdPoliza
                     AND IdetPol       = nIDetPol
                     AND Cod_Asegurado = X.Cod_Asegurado ;
               END;
            END IF;
         END LOOP;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error en Cargar Cobertura '|| SQLERRM);
   END;

END EMITE_ASEGURADO_MASIVO;

PROCEDURE EMITE_ENDOSO_CP (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER) IS
cNaturalidad       VARCHAR2(2);
nExiste           NUMBER(5);
nAsegExclu        NUMBER(10);
cArchivoClientes  VARCHAR2(200);
cArchivoFacturas  VARCHAR2(200);
cArchivoNC        VARCHAR2(200);
FecTraslado       VARCHAR2(200);

BEGIN
   IF OC_ENDOSO.VALIDA_ENDOSO(nCodCia, nIdPoliza, nIdEndoso, cNaturalidad) = 'S' THEN
        OC_ENDOSO.EMITIR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso, 'INA');

        IF FALSE THEN
            -- Verifica si Generó Facturas y/o Notas de Crédito
            SELECT COUNT(*)
              INTO nExiste
              FROM FACTURAS
             WHERE IdPoliza  = nIdPoliza
               AND IDetPol   = nIDetPol
               AND IdEndoso  = nIdEndoso
               AND CodCia    = nCodCia;

            SELECT NVL(nExiste,0) + COUNT(*)
              INTO nExiste
              FROM NOTAS_DE_CREDITO
             WHERE IdPoliza  = nIdPoliza
               AND IDetPol   = nIDetPol
               AND IdEndoso  = nIdEndoso
               AND CodCia    = nCodCia;
        END IF;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al emitir el endoso: '||SQLERRM);
END EMITE_ENDOSO_CP;

PROCEDURE INSERTA_BENEFICIARIO_01(cCodPlantilla VARCHAR2, cTabla VARCHAR2, nOrdenProceso NUMBER, cCadena VARCHAR2,
                               nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) IS
cCampos    VARCHAR2(4000);
cLinea     VARCHAR2(4000);
cInsert    VARCHAR2(4000);
csql_ins   VARCHAR2(4000);
c_Sql      VARCHAR2(4000);
cSeparador VARCHAR2(1);
cCadenaD   VARCHAR2(4000);
cCadenaT   VARCHAR2(4000);
cInserta   VARCHAR2(1);

CURSOR  C_DATOS IS
   SELECT CASE CodPlantilla
              WHEN 'UBUNT' THEN OrdenCampo
              ELSE OrdenCampo + 5
          END Orden, NomCampo,
          CASE CodPlantilla
              WHEN 'UBUNT' THEN PosIniCampo
              ELSE PosIniCampo + 5
          END PosIniCampo, ValorDefault,
          LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cCadena,CASE CodPlantilla
                                                            WHEN 'UBUNT' THEN OrdenCampo
                                                            ELSE OrdenCampo + 5
                                                        END,cSeparador)) Valor, TipoCampo
     FROM CONFIG_PLANTILLAS_CAMPOS
    WHERE PosIniCampo IS  NOT  NULL
      AND NomTabla     = cTabla
      AND OrdenProceso = nOrdenProceso
      AND CodPlantilla = cCodPlantilla
    ORDER BY OrdenCampo;
BEGIN
   cSeparador := OC_PROCESOS_MASIVOS.TIPO_SEPARADOR(cCodPlantilla);
   cInserta := 'N';
   cCampos  := ' IdPoliza, IDetPol, Cod_Asegurado';
   cCadenaD := CHR(39) || TRIM(TO_CHAR(nIdPoliza))      || CHR(39) || ',' ||
               CHR(39) || TRIM(TO_CHAR(nIDetPol))       || CHR(39) || ',' ||
               CHR(39) || TRIM(TO_CHAR(nCod_Asegurado)) || CHR(39) || ',';
   FOR I IN C_DATOS LOOP
      cCampos := cCampos||','||I.NomCampo;
      IF I.TipoCampo != 'DATE' THEN
         cCadenaD := cCadenaD || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cCadena,I.Orden,cSeparador)) || CHR(39) || ',';
      ELSE
         cCadenaD := cCadenaD || 'TO_DATE(' || CHR(39) || LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cCadena,I.Orden,cSeparador)) ||
                     CHR(39) || ',' || CHR(39) || 'DD/MM/YYYY' || CHR(39) || ')' || ',';
      END IF;
      IF LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(cCadena,I.Orden,cSeparador)) IS NOT NULL THEN
         cInserta := 'S';
      END IF;
   END LOOP;

   IF cInserta = 'S' THEN
      cCadenaD  := SUBSTR(cCadenaD,1,LENGTH(cCadenaD)-1);
      cCampos  := SUBSTR(cCampos,2,LENGTH(cCampos));
      cCadenaD := SUBSTR(cCadenaD,2,LENGTH(cCadenaD));
      cInsert  := 'INSERT INTO '||ctabla||'('||cCampos||') VALUES (';
      cSql_Ins := cInsert;
      c_Sql := cInsert||''''||cCadenaD||')';
      OC_DDL_OBJETOS. EJECUTAR_SQL(c_Sql);
   END IF;
END INSERTA_BENEFICIARIO_01;

-- FUNCION CREADA PARA OBTENER EL SEPARADOR DE ACUERDO A LA PLANTILLA
FUNCTION TIPO_SEPARADOR(cCodPlantilla VARCHAR2) RETURN VARCHAR2 IS
cTipoSeparador    VARCHAR2(10);
BEGIN
  BEGIN
    SELECT TIPOSEPARADOR
      INTO cTipoSeparador
      FROM CONFIG_PLANTILLAS
     WHERE CODPLANTILLA = cCodPlantilla;

    IF NVL(cTipoSeparador,'COM') = 'PIP' THEN
       RETURN('|');
    ELSE
       RETURN(',');
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN(',');
  END;
END TIPO_SEPARADOR;

PROCEDURE  SINIESTROS_AURVAD(nIdProcMasivo NUMBER) IS      -----PORFINSALES
nIdSiniestro     SINIESTRO.IDSINIESTRO%TYPE;    --  AEVS  NUEVO FLUJO LAYOUT CORTO   AURVAD
nCodAsegurado    SINIESTRO.COD_ASEGURADO%TYPE;
cNumDetUnico     DETALLE_POLIZA.IDETPOL%TYPE;
cIdTipoSeg       DETALLE_POLIZA.IDTIPOSEG%TYPE;
cPlanCob         DETALLE_POLIZA.PLANCOB%TYPE;
cStsPoliza       POLIZAS.STSPOLIZA%TYPE;
cMotivAnul       POLIZAS.MOTIVANUL%TYPE;
cNumPolUnico     POLIZAS.NUMPOLUNICO%TYPE;
nIdPoliza        POLIZAS.IDPOLIZA%TYPE;
nIdetPol         SINIESTRO.IDETPOL%TYPE;
nSumaAseg_Moneda COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nSumaAseg        COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nMontoRvaMoneda  COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
diferencia       COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
PruebaTotal      COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
Resultados       COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
nSumaAseg_Local  COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nMonto           COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nTasaCambio      TASAS_CAMBIO.Tasa_Cambio%TYPE;-- := OC_GENERALES.TASA_DE_CAMBIO(:BK_DATOS.cCod_Moneda, TRUNC(SYSDATE));
nMoneda          POLIZAS.COD_MONEDA%TYPE;
HabemusReserva   COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
nIdetSin         COBERTURA_SINIESTRO_ASEG.IDDETSIN%TYPE;
nNumMod          COBERTURA_SINIESTRO_ASEG.NUMMOD%TYPE;
nFecha           DATE;
cMsjError        VARCHAR2(1000);
TERMINAL         VARCHAR2(50);
USUSARIO         VARCHAR2(50);
nIdlogproceso    PROCESOS_MASIVOS_LOG.IDLOGPROCESO%TYPE;
nTxterror        PROCESOS_MASIVOS_LOG.TXTERROR%TYPE;
nIdTipoSeg       PROCESOS_MASIVOS.IDTIPOSEG%TYPE;
nPlanCob         PROCESOS_MASIVOS.PLANCOB%TYPE;
nTipoProceso     PROCESOS_MASIVOS.TIPOPROCESO%TYPE;
nRegDatosProc    PROCESOS_MASIVOS.REGDATOSPROC%TYPE;
nObservaciones   VARCHAR2(1000);
CompletaLaFrase  VARCHAR2(1000);
EnQueLugar       NUMBER;
nIDTRANSACCION    PROCESOS_MASIVOS_SEGUIMIENTO.IDTRANSACCION%TYPE;
nSALDO_RESERVA    COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA%TYPE;
-------PRUEBA DE  REGRESO   ----  TEMPORAL
nIdSiniestro2     COBERTURA_SINIESTRO_ASEG.IDSINIESTRO%TYPE;
nIdPoliza2        COBERTURA_SINIESTRO_ASEG.IDPOLIZA%TYPE;
nStsCobertura2    COBERTURA_SINIESTRO_ASEG.STSCOBERTURA%TYPE;
nNumMod2          COBERTURA_SINIESTRO_ASEG.NUMMOD%TYPE;
nCodTransac2      COBERTURA_SINIESTRO_ASEG.CODTRANSAC%TYPE;
nCodCptoTransac2  COBERTURA_SINIESTRO_ASEG.CODCPTOTRANSAC%TYPE;
nIdTransaccion2   COBERTURA_SINIESTRO_ASEG.IDTRANSACCION%TYPE;
nSaldoReserva2    COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA%TYPE;
-----------------------------------------
wOCURRIDO           COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
wPAGADOS                COBERTURA_SINIESTRO_ASEG.MONTO_PAGADO_MONEDA%TYPE;

CURSOR EMI_Q(NumProcMasivo IN NUMBER) IS
  SELECT PM.CodCia      CodCia     , PM.CodEmpresa     CodEmpresa, PM.IdTipoSeg     IdTipoSeg, PM.PlanCob           PlanCob, PM.NumPolUnico NumPolUnico,
         PM.NumDetUnico NumDetUnico, PM.RegDatosProc RegDatosProc, PM.TipoProceso TipoProceso, PM.IndColectiva IndColectiva, PM.STSREGPROCESO  STSREGPROCESO
    FROM PROCESOS_MASIVOS PM
   WHERE PM.IdProcMasivo   = NumProcMasivo; --nIdProcMasivo;
BEGIN
   SELECT USER ,USERENV('TERMINAL')                   ---  SIGUECARGA
     INTO USUSARIO , TERMINAL
     FROM SYS.DUAL;

   FOR i IN EMI_Q(nIdProcMasivo) LOOP
      IF i.STSREGPROCESO = 'EMI'  THEN
         BEGIN
            DELETE PROCESOS_MASIVOS
             WHERE IdProcMasivo = nIdProcMasivo;
         EXCEPTION
            WHEN OTHERS THEN
               OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'2 ERROR','20225','Error en Traslado de registro a Tabla PROCESOS_MASIVOS_PROC '||SQLERRM);
               OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'2 ERROR');
         END;
      ELSE
         cMsjError := NULL;
         nIdSiniestro    := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(i.RegDatosProc,1,',')));
         nMonto          := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(i.RegDatosProc,3,',')));
         nFecha          := TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(i.RegDatosProc,4,',')));
         nObservaciones  := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(i.RegDatosProc,5,','));

         ---  Validamos que el monto sea Positivo   ---
         IF nMonto < 0 THEN
            RAISE_APPLICATION_ERROR(-20225,'DIRVAD Error El monto es Negativo y éste proceso es de Aumento de Reserva. ' );
         END IF;

         BEGIN
            SELECT P.IdPoliza, DP.IDetPol, DP.IdTipoSeg, Dp.PlanCob, P.StsPoliza,
                   P.MotivAnul, P.NUMPOLUNICO, SNT.COD_ASEGURADO, SNT.IDETPOL, P.COD_MONEDA
              INTO nIdPoliza, cNumDetUnico, cIdTipoSeg, cPlanCob, cStsPoliza,
                   cMotivAnul ,cNumPolUnico, nCodAsegurado, nIdetPol, nMoneda
              FROM SINIESTRO  SNT, POLIZAS P,  DETALLE_POLIZA DP
             WHERE SNT.IDSINIESTRO =  nIdSiniestro
               AND P.CodCia        = SNT.CODCIA
               AND P.IdPoliza      = SNT.IDPOLIZA
               AND P.StsPoliza    IN ('REN','EMI','ANU')
               AND DP.CODCIA       = SNT.CODCIA
               AND DP.IDPOLIZA     = SNT.IDPOLIZA
               AND DP.IDETPOL      = 1;
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               RAISE_APPLICATION_ERROR(-20225,'Error SELECT POLIZAS Duplicidad de informacion  Suma Asegurada  : ' ||SQLERRM);
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20225,'Error SELECT POLIZAS NDF  Suma Asegurada  : ' ||SQLERRM);
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20225,'Error SELECT POLIZAS OTHERS Suma Asegurada  : ' ||SQLERRM);
         END;

         nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(nMoneda, TRUNC(SYSDATE));

         BEGIN
            SELECT NVL(SumaAseg_Moneda,0), NVL(SumaAseg_Local,0)
              INTO nSumaAseg_Moneda, nSumaAseg_Local
              FROM COBERT_ACT_ASEG
             WHERE CodCia        = i.CodCia
               AND IdPoliza      = nIdPoliza
               AND IdetPol       = nIdetPol
               AND Cod_Asegurado = nCodAsegurado
               AND CodCobert     = 'GMXA';
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               RAISE_APPLICATION_ERROR(-20225,'Error COBERT_ACT_ASEG Duplicidad de informacion  Suma Asegurada  : ' ||SQLERRM);
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20225,'Error COBERT_ACT_ASEG NDF  Suma Asegurada  : ' ||SQLERRM);
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20225,'Error COBERT_ACT_ASEG OTHERS Suma Asegurada  : ' ||SQLERRM);
         END ;

         IF nSumaAseg_Moneda = nSumaAseg_Local THEN
            IF nSumaAseg_Moneda > 0 THEN
               nSumaAseg := nSumaAseg_Moneda;
            END IF;
         ELSE
            nSumaAseg:= 0;
         END IF;

         BEGIN
            SELECT SUM(Monto_Reservado_Moneda)
              INTO nMontoRvaMoneda
              FROM COBERTURA_SINIESTRO_ASEG
             WHERE IdPoliza       = nIdPoliza
               AND CodCobert      = 'GMXA'
               AND Cod_Asegurado  = nCodAsegurado
               AND StsCobertura  != 'ANU';
         EXCEPTION
            WHEN OTHERS  THEN
               RAISE_APPLICATION_ERROR(-20225,'Error COBERTURA_SINIESTRO_ASEG OTHERS MntoRvaMoneda     : ' ||SQLERRM);
         END;

         Diferencia := nSumaAseg - nMontoRvaMoneda ;

         IF Diferencia > 0  THEN
            PruebaTotal := nMontoRvaMoneda + (nMonto * nTasaCambio) ;
            Resultados  := nSumaAseg - PruebaTotal;
            IF Resultados > 0 THEN
               HabemusReserva :=   (nMonto * nTasaCambio) ;
            ELSE
               RAISE_APPLICATION_ERROR(-20225,'Monto de Reserva NO Puede Ser Mayor a Suma Asegurada de Cobertura. Rebasado por : '||Resultados );
            END IF;
         END IF;

         IF HabemusReserva > 0 THEN
            SELECT NVL(MAX(NumMod),0) + 1
              INTO nNumMod
              FROM COBERTURA_SINIESTRO_ASEG
             WHERE IdPoliza      = nIdPoliza
               AND IdSiniestro   = nIdSiniestro
               AND IDDETSIN       = 1
               AND CodCobert     = 'GMXA'
               AND Cod_Asegurado = nCodAsegurado;

            BEGIN
               INSERT INTO COBERTURA_SINIESTRO_ASEG
                     (IDDETSIN, CODCOBERT, IDSINIESTRO, IDPOLIZA, COD_ASEGURADO, DOC_REF_PAGO,
                      MONTO_PAGADO_MONEDA, MONTO_PAGADO_LOCAL, MONTO_RESERVADO_MONEDA,
                      MONTO_RESERVADO_LOCAL, STSCOBERTURA, NUMMOD, CODTRANSAC, CODCPTOTRANSAC,
                      IDTRANSACCION, SALDO_RESERVA, INDORIGEN, FECRES, SALDO_RESERVA_LOCAL, IDTRANSACCIONANUL)
               VALUES(1, 'GMXA', nIdSiniestro, nIdPoliza, nCodAsegurado, NULL,
                      00.00, 00.00, nMonto, nMonto, 'SOL', nNumMod, 'AURVBA', 'AURVBA',
                      NULL, nMonto,  'A', nFecha, nMonto, NULL);
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX THEN
                  RAISE_APPLICATION_ERROR(-20225,'Error INSERT COBERTURA_SINIESTRO_ASEG Ya existe el registro  : ' ||SQLERRM);
               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR(-20225,'Error INSERT COBERTURA_SINIESTRO_ASEG OTHERS    : ' ||SQLERRM);
            END;

            BEGIN
               OC_COBERTURA_SINIESTRO_ASEG.EMITE_RESERVA(i.CodCia  ,i.CodEmpresa, nIdSiniestro,
                                                         nIdPoliza , 1          , nCodAsegurado,
                                                         'GMXA'    , nNumMod    , null);
            EXCEPTION
               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR(-20225,'Error OC_COBERTURA_SINIESTRO_ASEG.EMITE_RESERVA  : ' ||SQLERRM);
            END;
         ELSE
            cMsjError:= 'La reserva No puede ser creada ' ;
         END IF;

         ---  OBTENGO EL IDTRANSACCION  --
         SELECT IDTRANSACCION, SALDO_RESERVA
           INTO nIDTRANSACCION, nSALDO_RESERVA
           FROM COBERTURA_SINIESTRO_ASEG
          WHERE CODCOBERT     = 'GMXA'
            AND IDSINIESTRO   = nIdSiniestro
            AND IDPOLIZA      = nIdPoliza
            AND COD_ASEGURADO = nCodAsegurado
            AND NUMMOD        = nNumMod
            AND CODTRANSAC    = 'AURVBA';

         BEGIN
            UPDATE PROCESOS_MASIVOS_SEGUIMIENTO
               SET IDPOLIZA          = nIdPoliza
                   ,IDTRANSACCION     = nIDTRANSACCION
                   ,IDSINIESTRO       = nIdSiniestro
                   ,COD_ASEGURADO     = nCodAsegurado
                   ,CODCOBERT         = 'GMXA'
                   ,NUMMOD            = nNumMod
                   ,TIPO              = 'Ajuste Corto + '
             WHERE IdProcMasivo = nIdProcMasivo;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20225,' 1 Error en ACTUALIZA_STATUS UPDATE PROCESOS_MASIVOS_SEGUIMIENTO  '||SQLERRM);
            WHEN OTHERS  THEN
               RAISE_APPLICATION_ERROR(-20225,' 1 Error en ACTUALIZA_STATUS UPDATE PROCESOS_MASIVOS_SEGUIMIENTO  '||SQLERRM);
         END;
         BEGIN
            UPDATE COBERTURA_SINIESTRO_ASEG
               SET MONTO_RESERVADO_LOCAL  = nMonto,
                   SALDO_RESERVA_LOCAL    = nSALDO_RESERVA
             WHERE IDDETSIN      = 1
               AND CODCOBERT     = 'GMXA'
               AND IDSINIESTRO   = nIdSiniestro
               AND IDPOLIZA      = nIdPoliza
               AND COD_ASEGURADO = nCodAsegurado
               AND NUMMOD        = nNumMod;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20225,' 1 Error en ACTUALIZA_STATUS UPDATE PROCESOS_MASIVOS_SEGUIMIENTO  '||SQLERRM);
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20225,' 1 Error en ACTUALIZA_STATUS UPDATE PROCESOS_MASIVOS_SEGUIMIENTO  '||SQLERRM);
         END;

         IF cMsjError IS NULL THEN
            OC_PROCESOS_MASIVOS.INSERTA_PROCESO_MASIVO_PROC(nIdProcMasivo);
            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'EMI');
            BEGIN
               SELECT IdTipoSeg, PlanCob, TipoProceso, RegDatosProc
                 INTO nIdTipoSeg, nPlanCob, nTipoProceso, nRegDatosProc
                 FROM PROCESOS_MASIVOS
                WHERE IdProcMasivo = nIdProcMasivo;
            EXCEPTION
               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR(-20225,' 2 Error en ACTUALIZA_STATUS '||SQLERRM);
            END;

            BEGIN
               UPDATE PROCESOS_MASIVOS_SEGUIMIENTO
                  SET EMI_IDTIPOSEG     = nIdTipoSeg    ,
                      EMI_PLANCOB       = nPlanCob      ,
                      EMI_TIPOPROCESO   = nTipoProceso  ,
                      EMI_STSREGPROCESO = 'EMI'         ,
                      EMI_REGDATOSPROC  = nRegDatosProc ,
                      EMI_USUARIO       = USUSARIO      ,
                      EMI_TERMINAL      = TERMINAL      ,
                      EMI_FECHA         = TRUNC(SYSDATE),
                      EMI_FECHACOMP     = SYSDATE       ,
                      IDPOLIZA          = nIdPoliza     ,
                      COD_ASEGURADO     = nCodAsegurado  ,
                      CODCOBERT         = 'GMXA'         ,
                      NUMMOD            = nNumMod        ,
                      TIPO              = 'Ajuste Corto + ',
                      ARCHIVO_LOGEM     = CRGA_NOM_ARCHIVO
                WHERE IdProcMasivo = nIdProcMasivo;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  NULL;
               WHEN OTHERS  THEN
                  RAISE_APPLICATION_ERROR(-20225,' 2 Error en ACTUALIZA_STATUS UPDATE PROCESOS_MASIVOS_SEGUIMIENTO EMI '||SQLERRM);
            END;

            BEGIN
               DELETE PROCESOS_MASIVOS
                WHERE IdProcMasivo = nIdProcMasivo;
            EXCEPTION
               WHEN OTHERS THEN
                  OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'2 ERROR','20225','Error en Traslado de registro a Tabla PROCESOS_MASIVOS_PROC '||SQLERRM);
                  OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'2 ERROR');
             END;

             BEGIN
                SELECT LTRIM(RTRIM(DESCRIPCION)), IDOBSERVA
                  INTO CompletaLaFrase , EnQueLugar
                  FROM OBSERVACION_SINIESTRO
                 WHERE IdSiniestro = nIdSiniestro
                   AND IdPoliza    = nIdPoliza
                   AND IDOBSERVA   = (SELECT MAX(O.IDOBSERVA)
                                        FROM OBSERVACION_SINIESTRO O
                                       WHERE O.IDSINIESTRO = nIdSiniestro
                                         AND O.IDPOLIZA    = nIdPoliza);
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   RAISE_APPLICATION_ERROR(-20225,'NDF 2 Error al encontrar DESCRIPCION OBSERVACION_SINIESTRO AURVAD '||SQLERRM);
                WHEN OTHERS THEN
                   RAISE_APPLICATION_ERROR(-20225,'OTHERS 2 Error al encontrar DESCRIPCION OBSERVACION_SINIESTRO AURVAD'||SQLERRM);
             END;
             BEGIN
                UPDATE OBSERVACION_SINIESTRO
                   SET DESCRIPCION = CompletaLaFrase||' <--> '||nObservaciones
                 WHERE IdSiniestro = nIdSiniestro
                   AND IdPoliza    = nIdPoliza
                   AND IDOBSERVA   = EnQueLugar;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   RAISE_APPLICATION_ERROR(-20225,'NDF 2 Error al encontrar DESCRIPCION OBSERVACION_SINIESTRO AURVAD '||SQLERRM);
                WHEN OTHERS THEN
                   RAISE_APPLICATION_ERROR(-20225,'OTHERS 2 Error al encontrar DESCRIPCION OBSERVACION_SINIESTRO AURVAD'||SQLERRM);
             END;


             SELECT SUM(DECODE(CTS.SIGNO,'-',NVL(MONTO_RESERVADO_MONEDA,0)*(-1),NVL(MONTO_RESERVADO_MONEDA,0)))
               INTO  wOCURRIDO
               FROM COBERTURA_SINIESTRO_ASEG G, CONFIG_TRANSAC_SINIESTROS CTS
              WHERE G.IDSINIESTRO = nIdSiniestro
                AND G.IDPOLIZA    = nIdPoliza
                AND CTS.CODTRANSAC = G.CODCPTOTRANSAC;

             SELECT SUM(MONTO_PAGADO_MONEDA)
               INTO wPAGADOS
               FROM COBERTURA_SINIESTRO_ASEG
              WHERE IDSINIESTRO = nIdSiniestro
                AND IDPOLIZA    = nIdPoliza;


             BEGIN
                UPDATE DETALLE_SINIESTRO_ASEG
                   SET MONTO_RESERVADO_LOCAL  = wOCURRIDO,
                       MONTO_RESERVADO_MONEDA = wOCURRIDO,
                       MONTO_PAGADO_MONEDA    = wPAGADOS,
                       MONTO_PAGADO_LOCAL     = wPAGADOS
                 WHERE IDSINIESTRO   = nIdSiniestro
                   AND IDPOLIZA      = nIdPoliza
                   AND IDDETSIN      = 1;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   RAISE_APPLICATION_ERROR(-20225,'NDF Error al actualizar DETALLE_SINIESTRO_ASEG : '||SQLERRM);
                WHEN OTHERS THEN
                   RAISE_APPLICATION_ERROR(-20225,'OTHERS Error al actualizar DETALLE_SINIESTRO_ASEG : '||SQLERRM);
             END;

             BEGIN
                UPDATE SINIESTRO
                   SET MONTO_RESERVA_LOCAL  = wOCURRIDO,
                       MONTO_RESERVA_MONEDA = wOCURRIDO,
                       MONTO_PAGO_MONEDA    = wPAGADOS,
                       MONTO_PAGO_LOCAL     = wPAGADOS
                 WHERE IdSiniestro   = nIdSiniestro
                   AND IdPoliza      = nIdPoliza;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   RAISE_APPLICATION_ERROR(-20225,'NDF Error al actualizar SINIESTRO : '||SQLERRM);
                WHEN OTHERS THEN
                   RAISE_APPLICATION_ERROR(-20225,'OTHERS Error al actualizar SINIESTRO : '||SQLERRM);
             END;
          ELSE   ------------      H U B O     E R R O R E S  ----------------
             OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','No se puede Cargar el Siniestro: '||cMsjError);
             OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
             BEGIN
                SELECT PML.Idlogproceso, PML.Txterror
                  INTO nIdlogproceso, nTxterror
                  FROM PROCESOS_MASIVOS_LOG PML
                 WHERE PML.IdProcMasivo = nIdProcMasivo
                   AND PML.IDLOGPROCESO = (SELECT MAX(IDLOGPROCESO)
                                             FROM PROCESOS_MASIVOS_LOG
                                            WHERE IdProcMasivo = PML.IdProcMasivo);
             EXCEPTION
                WHEN OTHERS THEN
                   cMsjError:=('-20225 1 Error al consultar PROCESOS_MASIVOS_LOG '||SQLERRM);
             END;
             BEGIN
                UPDATE PROCESOS_MASIVOS_SEGUIMIENTO
                   SET ERR_IDLOGPROCESO = nIdlogproceso ,
                       ERR_TXTERROR     = nTxterror     ,
                       ERR_USUARIO      = USUSARIO      ,
                       ERR_TERMINAL     = TERMINAL      ,
                       ERR_FECHA        = TRUNC(SYSDATE),
                       ERR_FECHACOMP    = SYSDATE
                 WHERE IDPROCMASIVO = nIdProcMasivo;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   NULL;
                WHEN OTHERS  THEN
                   NULL;
             END;
             RAISE_APPLICATION_ERROR(-20225,cMsjError );
        END IF;

        SELECT IDSINIESTRO, IDPOLIZA, STSCOBERTURA, NUMMOD, CODTRANSAC,
               CODCPTOTRANSAC, IDTRANSACCION, SALDO_RESERVA
          INTO nIdSiniestro2, nIdPoliza2, nStsCobertura2, nNumMod2, nCodTransac2,
               nCodCptoTransac2, nIdTransaccion2, nSaldoReserva2
          FROM COBERTURA_SINIESTRO_ASEG
         WHERE IdPoliza      = nIdPoliza
           AND IdSiniestro   = nIdSiniestro
           AND CODCOBERT     = 'GMXA'
           AND IDDETSIN      = 1
           AND NUMMOD        = nNumMod
           AND COD_ASEGURADO = nCodAsegurado;
      END IF;
   END LOOP;  --> EMI_Q
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Error - SINIESTROS_AURVAD No se puede Cargar el Siniestro '|| SQLERRM);
      OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END SINIESTROS_AURVAD;   --AEVS  AURVAD  19052016

PROCEDURE  SINIESTROS_DIRVAD(nIdProcMasivo NUMBER) IS
nIdSiniestro     SINIESTRO.IDSINIESTRO%TYPE;    --  AEVS  NUEVO FLUJO LAYOUT CORTO   DIRVAD
nCodAsegurado    SINIESTRO.COD_ASEGURADO%TYPE;
cNumDetUnico     DETALLE_POLIZA.IDETPOL%TYPE;
cIdTipoSeg       DETALLE_POLIZA.IDTIPOSEG%TYPE;
cPlanCob         DETALLE_POLIZA.PLANCOB%TYPE;
cStsPoliza       POLIZAS.STSPOLIZA%TYPE;
cMotivAnul       POLIZAS.MOTIVANUL%TYPE;
cNumPolUnico     POLIZAS.NUMPOLUNICO%TYPE;
nIdPoliza        POLIZAS.IDPOLIZA%TYPE;
nIdetPol         SINIESTRO.IDETPOL%TYPE;
nSumaAseg_Moneda COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nSumaAseg        COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nMontoRvaMoneda  COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
diferencia       COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
PruebaTotal      COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
Resultados       COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
nSaldoDeLaReserva COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA_LOCAL%TYPE;
prueba_SaldoReserva NUMBER:=0; ---COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA_LOCAL%TYPE;
nSumaAseg_Local  COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nMonto           COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nMonto22         COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nTasaCambio      TASAS_CAMBIO.Tasa_Cambio%TYPE;
nMoneda          POLIZAS.COD_MONEDA%TYPE;
HabemusReserva   COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
nIdetSin         COBERTURA_SINIESTRO_ASEG.IDDETSIN%TYPE;
nNumMod          COBERTURA_SINIESTRO_ASEG.NUMMOD%TYPE;
nFecha           DATE;
cMsjError        VARCHAR2(1000);
USUSARIO         VARCHAR2(50);
TERMINAL         VARCHAR2(50);
nIdlogproceso    PROCESOS_MASIVOS_LOG.IDLOGPROCESO%TYPE;
nTxterror        PROCESOS_MASIVOS_LOG.TXTERROR%TYPE;
nIdTipoSeg       PROCESOS_MASIVOS.IDTIPOSEG%TYPE;
nPlanCob         PROCESOS_MASIVOS.PLANCOB%TYPE;
nTipoProceso     PROCESOS_MASIVOS.TIPOPROCESO%TYPE;
nRegDatosProc    PROCESOS_MASIVOS.REGDATOSPROC%TYPE;
nObservaciones   VARCHAR2(1000);
CompletaLaFrase  VARCHAR2(1000);
EnQueLugar       NUMBER;
nIDTRANSACCION    PROCESOS_MASIVOS_SEGUIMIENTO.IDTRANSACCION%TYPE;
nSALDO_RESERVA    COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA%TYPE;
-------PRUEBA DE  REGRESO   ----  TEMPORAL
nIdSiniestro2     COBERTURA_SINIESTRO_ASEG.IDSINIESTRO%TYPE;
nIdPoliza2        COBERTURA_SINIESTRO_ASEG.IDPOLIZA%TYPE;
nStsCobertura2    COBERTURA_SINIESTRO_ASEG.STSCOBERTURA%TYPE;
nNumMod2          COBERTURA_SINIESTRO_ASEG.NUMMOD%TYPE;
nCodTransac2      COBERTURA_SINIESTRO_ASEG.CODTRANSAC%TYPE;
nCodCptoTransac2  COBERTURA_SINIESTRO_ASEG.CODCPTOTRANSAC%TYPE;
nIdTransaccion2   COBERTURA_SINIESTRO_ASEG.IDTRANSACCION%TYPE;
nSaldoReserva2    COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA%TYPE;
-----------------------------------------
wOCURRIDO           COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
wPAGADOS                COBERTURA_SINIESTRO_ASEG.MONTO_PAGADO_MONEDA%TYPE;

CURSOR EMI_Q(NumProcMasivo IN NUMBER) IS
  SELECT PM.CodCia      CodCia     , PM.CodEmpresa     CodEmpresa, PM.IdTipoSeg     IdTipoSeg, PM.PlanCob           PlanCob, PM.NumPolUnico NumPolUnico,
         PM.NumDetUnico NumDetUnico, PM.RegDatosProc RegDatosProc, PM.TipoProceso TipoProceso, PM.IndColectiva IndColectiva, PM.STSREGPROCESO STSREGPROCESO
    FROM PROCESOS_MASIVOS PM
   WHERE PM.IdProcMasivo   = NumProcMasivo;

BEGIN
   SELECT USER ,USERENV('TERMINAL')                   ---  SIGUECARGA
     INTO USUSARIO , TERMINAL
     FROM SYS.DUAL;

   FOR i IN EMI_Q(nIdProcMasivo) LOOP
      IF  i.STSREGPROCESO = 'EMI'  THEN  --si hay un registro atorado, pero ya emitido previamente, lo quita.
         BEGIN
            DELETE PROCESOS_MASIVOS
             WHERE IdProcMasivo = nIdProcMasivo;
         EXCEPTION
            WHEN OTHERS THEN
               OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'2 ERROR','20225','Error en Traslado de registro a Tabla PROCESOS_MASIVOS_PROC '||SQLERRM);
               OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'2 ERROR');
         END;
      ELSE
         cMsjError := NULL;
         nIdSiniestro    := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(i.RegDatosProc,1,',')));
         nMonto          := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(i.RegDatosProc,3,',')));
         nFecha          := TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(i.RegDatosProc,4,',')));
         nObservaciones  := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(i.RegDatosProc,5,','));

         BEGIN
            SELECT P.IdPoliza, DP.IDetPol, DP.IdTipoSeg, Dp.PlanCob, P.StsPoliza, P.MotivAnul,
                   P.NUMPOLUNICO , SNT.COD_ASEGURADO, SNT.IDETPOL, P.COD_MONEDA
              INTO nIdPoliza, cNumDetUnico, cIdTipoSeg, cPlanCob, cStsPoliza, cMotivAnul,
                   cNumPolUnico , nCodAsegurado, nIdetPol, nMoneda
              FROM SINIESTRO  SNT, POLIZAS P, DETALLE_POLIZA DP
             WHERE SNT.IDSINIESTRO =  nIdSiniestro
               AND P.CodCia    = SNT.CODCIA
               AND P.IdPoliza  = SNT.IDPOLIZA
               AND P.StsPoliza IN ('REN','EMI','ANU')
               AND DP.CODCIA   = SNT.CODCIA
               AND DP.IDPOLIZA = SNT.IDPOLIZA
               AND DP.IDETPOL  = 1  ;
         EXCEPTION
            WHEN TOO_MANY_ROWS THEN
               cMsjError:=('-20225 DIRVAD Error SELECT POLIZAS Duplicidad de informacion  Suma Asegurada  : ' ||SQLERRM);
            WHEN NO_DATA_FOUND THEN
               cMsjError:=('-20225  DIRVAD Error SELECT POLIZAS NDF  Suma Asegurada  : ' ||SQLERRM);
            WHEN OTHERS THEN
               cMsjError:=('-20225 DIRVAD Error SELECT POLIZAS OTHERS Suma Asegurada  : ' ||SQLERRM);
         END;

         nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(nMoneda, TRUNC(SYSDATE));

         -----  Sacamos la Suma Asegurada de la Cobertura  -----------
         IF cMsjError IS NULL THEN
            BEGIN
               SELECT NVL(SumaAseg_Moneda,0), NVL(SumaAseg_Local,0)
                 INTO nSumaAseg_Moneda, nSumaAseg_Local
                 FROM COBERT_ACT_ASEG
                WHERE CodCia        = i.CodCia
                  AND IdPoliza      = nIdPoliza
                  AND IdetPol       = nIdetPol
                  AND Cod_Asegurado = nCodAsegurado
                  AND CodCobert     = 'GMXA';
            EXCEPTION
               WHEN TOO_MANY_ROWS THEN
                  cMsjError:=('-20225   Error COBERT_ACT_ASEG Duplicidad de informacion  Suma Asegurada  : ' ||SQLERRM);
               WHEN NO_DATA_FOUND THEN
                  cMsjError:=('-20225   Error COBERT_ACT_ASEG NDF  Suma Asegurada  : ' ||SQLERRM);
               WHEN OTHERS THEN
                  cMsjError:=('-20225   Error COBERT_ACT_ASEG OTHERS Suma Asegurada  : ' ||SQLERRM);
            END ;
         END IF;

         IF nSumaAseg_Moneda = nSumaAseg_Local THEN
            IF nSumaAseg_Moneda > 0 THEN
               nSumaAseg := nSumaAseg_Moneda;
            END IF;
         ELSE
            nSumaAseg:= 0;
         END IF;

         -----  Sacamos el monto de la Reserva   -----------
         IF cMsjError IS NULL THEN
            BEGIN
               SELECT SUM(Monto_Reservado_Moneda)
                 INTO nMontoRvaMoneda
                 FROM COBERTURA_SINIESTRO_ASEG
                WHERE IdPoliza       = nIdPoliza
                  AND CodCobert      = 'GMXA'
                  AND Cod_Asegurado  = nCodAsegurado
                  AND StsCobertura  != 'ANU';
            EXCEPTION
               WHEN OTHERS  THEN
                  cMsjError:=('-20225   Error COBERTURA_SINIESTRO_ASEG OTHERS MntoRvaMoneda     : ' ||SQLERRM);
           END;
         END IF;

         -----  Sacamos el monto del Saldo de la Reserva   -----------
         IF  cMsjError IS NULL THEN
            BEGIN
               SELECT SALDO_RESERVA
                 INTO nSaldoDeLaReserva
                 FROM COBERTURA_SINIESTRO_ASEG
                WHERE IDDETSIN      > 0
                  AND CODCOBERT     = 'GMXA'
                  AND IDSINIESTRO   = nIdSiniestro --24128
                  AND IDPOLIZA      = nIdPoliza
                  AND COD_ASEGURADO = nCodAsegurado
                  AND NUMMOD        = (SELECT MAX(NUMMOD)
                                         FROM COBERTURA_SINIESTRO_ASEG
                                        WHERE CODCOBERT     = 'GMXA'
                                          AND IDSINIESTRO   = nIdSiniestro --24128
                                          AND IDPOLIZA      = nIdPoliza
                                          AND COD_ASEGURADO = nCodAsegurado);
            EXCEPTION
               WHEN NO_DATA_FOUND  THEN
                  cMsjError:=(' -20225 NDF Error COBERTURA_SINIESTRO_ASEG  nSaldoDeLaReserva     : ' ||SQLERRM);
               WHEN OTHERS  THEN
                  cMsjError:=('-20225   OTHERS Error COBERTURA_SINIESTRO_ASEG  nSaldoDeLaReserva     : ' ||SQLERRM);
            END;
         END IF;
         IF cMsjError IS NULL THEN
            IF nSaldoDeLaReserva = 0  THEN
               cMsjError:=(' El Saldo de la Reserva es Cero y no puede quedar Negativa. No se Puede crear éste Ajuste     ');
            END IF;
         END IF;

         IF cMsjError IS NULL THEN
            SELECT (nSaldoDeLaReserva - nMonto)
              INTO prueba_SaldoReserva
              FROM DUAL;
            IF prueba_SaldoReserva < 0  THEN
               cMsjError:=('-20225   La Disminución dejaría el Saldo de la Reserva Negativa. No se Puede crear éste Ajuste  ' );
            END IF;
         END IF;

         IF cMsjError IS NULL THEN
            diferencia := 0; --nSumaAseg - nMontoRvaMoneda ;
            IF (diferencia > 0) OR (diferencia = 0)   THEN
                PruebaTotal := nMontoRvaMoneda - (nMonto * nTasaCambio) ;
                Resultados := nSumaAseg - PruebaTotal;
               IF  Resultados > 0 THEN
                  HabemusReserva :=   (nMonto * nTasaCambio) ;
               ELSE
                  cMsjError:=('-20225  Monto de Reserva NO Puede Ser Mayor a Suma Asegurada de Cobertura. Rebasado por : '||Resultados );
               END IF;

               SELECT NVL(MAX(NumMod),0) + 1
                 INTO nNumMod
                 FROM COBERTURA_SINIESTRO_ASEG
                WHERE IdPoliza      = nIdPoliza
                  AND IdSiniestro   = nIdSiniestro
                  AND IDDETSIN       = 1
                  AND CodCobert     = 'GMXA'
                  AND Cod_Asegurado = nCodAsegurado;

               BEGIN
                   INSERT INTO COBERTURA_SINIESTRO_ASEG
                        (IDDETSIN, CODCOBERT, IDSINIESTRO, IDPOLIZA, COD_ASEGURADO, DOC_REF_PAGO,
                         MONTO_PAGADO_MONEDA, MONTO_PAGADO_LOCAL, MONTO_RESERVADO_MONEDA,
                         MONTO_RESERVADO_LOCAL, STSCOBERTURA, NUMMOD, CODTRANSAC, CODCPTOTRANSAC,
                         IDTRANSACCION, SALDO_RESERVA, INDORIGEN, FECRES, SALDO_RESERVA_LOCAL,
                         IDTRANSACCIONANUL)
                   VALUES (1, 'GMXA', nIdSiniestro, nIdPoliza, nCodAsegurado, NULL,
                           00.00, 00.00, nMonto, nMonto, 'SOL', nNumMod, 'DIRVAD', 'DIRVAD',
                           NULL, nMonto, 'A', nFecha, nMonto, NULL);
               EXCEPTION
                  WHEN DUP_VAL_ON_INDEX THEN
                     cMsjError:=('-20225  DIRVAD Error INSERT COBERTURA_SINIESTRO_ASEG Ya existe el registro  : ' ||SQLERRM);
                  WHEN OTHERS THEN
                     cMsjError:=(' -20225 DIRVAD Error INSERT COBERTURA_SINIESTRO_ASEG OTHERS    : ' ||SQLERRM);
               END;

               BEGIN
                  OC_COBERTURA_SINIESTRO_ASEG.EMITE_RESERVA(i.CodCia  ,i.CodEmpresa, nIdSiniestro,
                                                            nIdPoliza , 1          , nCodAsegurado,
                                                            'GMXA'    , nNumMod    , null);
               EXCEPTION
                  WHEN OTHERS THEN
                    cMsjError:=(' -20225  DIRVAD Error OC_COBERTURA_SINIESTRO_ASEG.EMITE_RESERVA  : ' ||SQLERRM);
               END;
            ELSE
               cMsjError:= 'La reserva No puede ser creada ' ;
            END IF;
         END IF;
         ---  OBTENGO EL IDTRANSACCION  --
         BEGIN
            SELECT IDTRANSACCION, SALDO_RESERVA
              INTO nIDTRANSACCION, nSALDO_RESERVA
              FROM COBERTURA_SINIESTRO_ASEG
             WHERE CODCOBERT     = 'GMXA'
               AND IDSINIESTRO   = nIdSiniestro
               AND IDPOLIZA      = nIdPoliza
               AND COD_ASEGURADO = nCodAsegurado
               AND NUMMOD        = nNumMod
               AND CODTRANSAC    = 'DIRVAD' ;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20225,' 1 Error en ACTUALIZA_STATUS UPDATE PROCESOS_MASIVOS_SEGUIMIENTO  '||SQLERRM);
            WHEN OTHERS  THEN
               RAISE_APPLICATION_ERROR(-20225,' 1 Error en ACTUALIZA_STATUS UPDATE PROCESOS_MASIVOS_SEGUIMIENTO  '||SQLERRM);
         END;
         BEGIN
            UPDATE PROCESOS_MASIVOS_SEGUIMIENTO
               SET IDPOLIZA      = nIdPoliza,
                   IDTRANSACCION = nIDTRANSACCION,
                   IDSINIESTRO   = nIdSiniestro,
                   COD_ASEGURADO = nCodAsegurado,
                   CODCOBERT     = 'GMXA',
                   NUMMOD        = nNumMod,
                   TIPO          = 'Ajuste Corto - '
             WHERE IdProcMasivo = nIdProcMasivo;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20225,' 1 Error en ACTUALIZA_STATUS UPDATE PROCESOS_MASIVOS_SEGUIMIENTO  '||SQLERRM);
            WHEN OTHERS  THEN
               RAISE_APPLICATION_ERROR(-20225,' 1 Error en ACTUALIZA_STATUS UPDATE PROCESOS_MASIVOS_SEGUIMIENTO  '||SQLERRM);
         END;

         BEGIN
            UPDATE COBERTURA_SINIESTRO_ASEG
               SET MONTO_RESERVADO_LOCAL  = nMonto,
                   SALDO_RESERVA_LOCAL    = nSALDO_RESERVA
             WHERE IDDETSIN      = 1
               AND CODCOBERT     = 'GMXA'
               AND IDSINIESTRO   = nIdSiniestro
               AND IDPOLIZA      = nIdPoliza
               AND COD_ASEGURADO = nCodAsegurado
               AND NUMMOD        = nNumMod;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20225,' 1 Error en ACTUALIZA_STATUS UPDATE PROCESOS_MASIVOS_SEGUIMIENTO  '||SQLERRM);
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20225,' 1 Error en ACTUALIZA_STATUS UPDATE PROCESOS_MASIVOS_SEGUIMIENTO  '||SQLERRM);
         END;

         ----  HACE MAGIA  PROCESA Y EMITE  Ó  MANDA A  PROCESO DE ERROR PROCESOS_MASIVOS_LOG --------
         IF cMsjError IS NULL THEN
            OC_PROCESOS_MASIVOS.INSERTA_PROCESO_MASIVO_PROC(nIdProcMasivo);
            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'EMI');
            BEGIN
               SELECT IdTipoSeg, PlanCob, TipoProceso, RegDatosProc
                 INTO nIdTipoSeg, nPlanCob, nTipoProceso, nRegDatosProc
                 FROM PROCESOS_MASIVOS
                WHERE IdProcMasivo = nIdProcMasivo;
            EXCEPTION
               WHEN OTHERS THEN
                  cMsjError:=('  -20225  2 Error en ACTUALIZA_STATUS '||SQLERRM);
            END;

            BEGIN
               UPDATE PROCESOS_MASIVOS_SEGUIMIENTO
                  SET EMI_IDTIPOSEG     = nIdTipoSeg    ,
                      EMI_PLANCOB       = nPlanCob      ,
                      EMI_TIPOPROCESO   = nTipoProceso  ,
                      EMI_STSREGPROCESO = 'EMI'         ,
                      EMI_REGDATOSPROC  = nRegDatosProc ,
                      EMI_USUARIO       = USUSARIO      ,
                      EMI_TERMINAL      = TERMINAL      ,
                      EMI_FECHA         = TRUNC(SYSDATE),
                      EMI_FECHACOMP     = SYSDATE       ,
                      IDPOLIZA          = nIdPoliza     ,
                      IDSINIESTRO       = nIdSiniestro  ,
                      COD_ASEGURADO     = nCodAsegurado ,
                      CODCOBERT         = 'GMXA'        ,
                      NUMMOD            = nNumMod       ,
                      TIPO              = 'Ajuste Corto - ',
                      ARCHIVO_LOGEM     = CRGA_NOM_ARCHIVO
                WHERE IdProcMasivo = nIdProcMasivo;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  NULL;
               WHEN OTHERS  THEN
                  cMsjError:=(' -20225  2 Error en ACTUALIZA_STATUS UPDATE PROCESOS_MASIVOS_SEGUIMIENTO EMI '||SQLERRM);
            END;
            BEGIN
               DELETE PROCESOS_MASIVOS
                WHERE IdProcMasivo = nIdProcMasivo;
            EXCEPTION
               WHEN OTHERS THEN
                  OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'2 ERROR','20225','Error en Traslado de registro a Tabla PROCESOS_MASIVOS_PROC '||SQLERRM);
                  OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'2 ERROR');
            END;
            BEGIN
               SELECT LTRIM(RTRIM(DESCRIPCION)), IDOBSERVA
                 INTO CompletaLaFrase , EnQueLugar
                 FROM OBSERVACION_SINIESTRO
                WHERE IdSiniestro = nIdSiniestro
                  AND IdPoliza    = nIdPoliza
                  AND IDOBSERVA   = (SELECT MAX(IDOBSERVA)
                                       FROM OBSERVACION_SINIESTRO
                                      WHERE IdSiniestro = nIdSiniestro
                                        AND IdPoliza    = nIdPoliza);
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  cMsjError:=(' -20225 NDF 2 Error al encontrar DESCRIPCION OBSERVACION_SINIESTRO AURVAD '||SQLERRM);
               WHEN OTHERS THEN
                  cMsjError:=(' -20225 NDF 2 OTHERS al encontrar DESCRIPCION OBSERVACION_SINIESTRO AURVAD '||SQLERRM);
            END;
            BEGIN
               UPDATE OBSERVACION_SINIESTRO
                  SET DESCRIPCION = CompletaLaFrase||' <--> '||nObservaciones
                WHERE IdSiniestro  = nIdSiniestro
                  AND IdPoliza     = nIdPoliza
                  AND IDOBSERVA    = EnQueLugar;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  cMsjError:=(' -20225 NDF 2 Error al encontrar DESCRIPCION OBSERVACION_SINIESTRO AURVAD '||SQLERRM);
               WHEN OTHERS THEN
                  cMsjError:=(' -20225 OTHERS 2 Error al encontrar DESCRIPCION OBSERVACION_SINIESTRO AURVAD '||SQLERRM);
            END;

            SELECT  SUM(DECODE(CTS.SIGNO,'-',NVL(MONTO_RESERVADO_MONEDA,0)*(-1),NVL(MONTO_RESERVADO_MONEDA,0)))
              INTO  wOCURRIDO
              FROM COBERTURA_SINIESTRO_ASEG G, CONFIG_TRANSAC_SINIESTROS CTS
             WHERE G.IdSiniestro  = nIdSiniestro
               AND G.IdPoliza     = nIdPoliza
               AND CTS.CODTRANSAC = G.CODCPTOTRANSAC;

            SELECT SUM(MONTO_PAGADO_MONEDA)
              INTO wPAGADOS
              FROM COBERTURA_SINIESTRO_ASEG
             WHERE IdSiniestro = nIdSiniestro
               AND IdPoliza    = nIdPoliza;

            BEGIN
               UPDATE DETALLE_SINIESTRO_ASEG
                  SET MONTO_RESERVADO_LOCAL  = wOCURRIDO,
                      MONTO_RESERVADO_MONEDA = wOCURRIDO,
                      MONTO_PAGADO_MONEDA    = wPAGADOS,
                      MONTO_PAGADO_LOCAL     = wPAGADOS
                WHERE IdSiniestro   = nIdSiniestro
                  AND IdPoliza      = nIdPoliza
                  AND IDDETSIN      = 1;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-20225,'NDF Error al actualizar DETALLE_SINIESTRO_ASEG : '||SQLERRM);
               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR(-20225,'OTHERS Error al actualizar DETALLE_SINIESTRO_ASEG : '||SQLERRM);
            END;

            BEGIN
               UPDATE SINIESTRO
                  SET MONTO_RESERVA_LOCAL  = wOCURRIDO,
                      MONTO_RESERVA_MONEDA = wOCURRIDO,
                      MONTO_PAGO_MONEDA    = wPAGADOS,
                      MONTO_PAGO_LOCAL     = wPAGADOS
                WHERE IdSiniestro   = nIdSiniestro
                  AND IdPoliza      = nIdPoliza;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-20225,'NDF Error al actualizar SINIESTRO : '||SQLERRM);
               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR(-20225,'OTHERS Error al actualizar SINIESTRO : '||SQLERRM);
            END;
         ELSE   ------------      H U B O     E R R O R E S  ----------------
            OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','No se puede Cargar el Siniestro: '||cMsjError);
            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
            BEGIN
               SELECT PML.Idlogproceso, PML.Txterror
                 INTO nIdlogproceso, nTxterror
                 FROM PROCESOS_MASIVOS_LOG PML
                WHERE PML.IdProcMasivo = nIdProcMasivo
                  AND PML.IDLOGPROCESO = (SELECT MAX(IDLOGPROCESO)
                                            FROM PROCESOS_MASIVOS_LOG PMLOG
                                           WHERE IDPROCMASIVO=  PML.IdProcMasivo );
            EXCEPTION
               WHEN OTHERS THEN
                  cMsjError:=('-20225 1 Error al consultar PROCESOS_MASIVOS_LOG '||SQLERRM);
            END;
            BEGIN
               UPDATE PROCESOS_MASIVOS_SEGUIMIENTO
                  SET ERR_IDLOGPROCESO = nIdlogproceso ,
                      ERR_TXTERROR     = nTxterror     ,
                      ERR_USUARIO      = USUSARIO      ,
                      ERR_TERMINAL     = TERMINAL      ,
                      ERR_FECHA        = TRUNC(SYSDATE),
                      ERR_FECHACOMP    = SYSDATE
                WHERE IdProcMasivo = nIdProcMasivo;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  NULL;
               WHEN OTHERS  THEN
                  NULL;
            END;
            RAISE_APPLICATION_ERROR(-20225,cMsjError );
         END IF;

         IF cMsjError IS NULL THEN
            SELECT IdSiniestro, IdPoliza, STSCOBERTURA, NUMMOD, CODTRANSAC,
                   CODCPTOTRANSAC, IDTRANSACCION, SALDO_RESERVA
              INTO nIdSiniestro2, nIdPoliza2, nStsCobertura2, nNumMod2, nCodTransac2,
                   nCodCptoTransac2, nIdTransaccion2, nSaldoReserva2
              FROM COBERTURA_SINIESTRO_ASEG
             WHERE IdPoliza      = nIdPoliza
               AND IdSiniestro   = nIdSiniestro
               AND CODCOBERT     = 'GMXA'
               AND IDDETSIN      = 1
               AND NUMMOD        = nNumMod
               AND COD_ASEGURADO = nCodAsegurado;
         END IF;

         IF cMsjError IS NOT NULL  THEN
            RAISE_APPLICATION_ERROR(-20225,cMsjError );
         END IF;
      END IF;
   END LOOP;  --> EMI_Q
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Error - SINIESTROS_DIRVAD No se puede Cargar el Siniestro '|| SQLERRM);
      OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END SINIESTROS_DIRVAD;   --AEVS  DIRVAD  19052016

PROCEDURE SINIESTROS_ANUPGO(nIdProcMasivo NUMBER) IS
nCodAsegurado    SINIESTRO.COD_ASEGURADO%TYPE;
cNumDetUnico     DETALLE_POLIZA.IDETPOL%TYPE;
cIdTipoSeg       DETALLE_POLIZA.IDTIPOSEG%TYPE;
cPlanCob         DETALLE_POLIZA.PLANCOB%TYPE;
cStsPoliza       POLIZAS.STSPOLIZA%TYPE;
cMotivAnul       POLIZAS.MOTIVANUL%TYPE;
cNumPolUnico     POLIZAS.NUMPOLUNICO%TYPE;
nIdetPol         SINIESTRO.IDETPOL%TYPE;
nSumaAseg_Moneda COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nSumaAseg        COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nMontoRvaMoneda  COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
diferencia       COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
PruebaTotal      COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
Resultados       COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
nSumaAseg_Local  COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nMonto           COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nTasaCambio      TASAS_CAMBIO.Tasa_Cambio%TYPE;-- := OC_GENERALES.TASA_DE_CAMBIO(:BK_DATOS.cCod_Moneda, TRUNC(SYSDATE));
nMoneda          POLIZAS.COD_MONEDA%TYPE;
HabemusReserva   COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
nIdetSin         COBERTURA_SINIESTRO_ASEG.IDDETSIN%TYPE;
nNumMod          COBERTURA_SINIESTRO_ASEG.NUMMOD%TYPE;
nFecha           DATE;
nIdlogproceso    PROCESOS_MASIVOS_LOG.IDLOGPROCESO%TYPE;
nTxterror        PROCESOS_MASIVOS_LOG.TXTERROR%TYPE;
nIdTipoSeg       PROCESOS_MASIVOS.IDTIPOSEG%TYPE;
nPlanCob         PROCESOS_MASIVOS.PLANCOB%TYPE;
nTipoProceso     PROCESOS_MASIVOS.TIPOPROCESO%TYPE;
nRegDatosProc    PROCESOS_MASIVOS.REGDATOSPROC%TYPE;
nObservaciones   VARCHAR2(1000);
CompletaLaFrase  VARCHAR2(1000);
EnQueLugar       NUMBER;
nIDTRANSACCION    PROCESOS_MASIVOS_SEGUIMIENTO.IDTRANSACCION%TYPE;
nSALDO_RESERVA    COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA%TYPE;
-------PRUEBA DE  REGRESO   ----  TEMPORAL
nIdSiniestro2     COBERTURA_SINIESTRO_ASEG.IDSINIESTRO%TYPE;
nIdPoliza2        COBERTURA_SINIESTRO_ASEG.IDPOLIZA%TYPE;
nStsCobertura2    COBERTURA_SINIESTRO_ASEG.STSCOBERTURA%TYPE;
nNumMod2          COBERTURA_SINIESTRO_ASEG.NUMMOD%TYPE;
nCodTransac2      COBERTURA_SINIESTRO_ASEG.CODTRANSAC%TYPE;
nCodCptoTransac2  COBERTURA_SINIESTRO_ASEG.CODCPTOTRANSAC%TYPE;
nIdTransaccion2   COBERTURA_SINIESTRO_ASEG.IDTRANSACCION%TYPE;
nSaldoReserva2    COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA%TYPE;
cMsjError         VARCHAR2(1000);
TERMINAL          VARCHAR2(50);
USUSARIO          VARCHAR2(50);
nIdSiniestro      SINIESTRO.IDSINIESTRO%TYPE;
nIdPoliza         SINIESTRO.IDPOLIZA%TYPE;
nCOD_ASEGURADO    DETALLE_SINIESTRO_ASEG.COD_ASEGURADO%TYPE;
nINDPOLCOL        PROCESOS_MASIVOS_SEGUIMIENTO.INDPOLCOL%TYPE;
nNUM_APROBACION   APROBACION_ASEG.NUM_APROBACION%TYPE;
nIDDETSIN2        DETALLE_SINIESTRO_ASEG.IDDETSIN%TYPE;
nIDDETSIN         DETALLE_SINIESTRO.IDDETSIN%TYPE;

CURSOR EMI_Q(NumProcMasivo IN NUMBER) IS
   SELECT PM.CodCia      CodCia     , PM.CodEmpresa     CodEmpresa, PM.IdTipoSeg     IdTipoSeg, PM.PlanCob           PlanCob, PM.NumPolUnico NumPolUnico,
          PM.NumDetUnico NumDetUnico, PM.RegDatosProc RegDatosProc, PM.TipoProceso TipoProceso, PM.IndColectiva IndColectiva, PM.STSREGPROCESO STSREGPROCESO
     FROM PROCESOS_MASIVOS PM
    WHERE PM.IdProcMasivo   = NumProcMasivo;
BEGIN
   SELECT USER ,USERENV('TERMINAL')                   ---  SIGUECARGA
     INTO USUSARIO , TERMINAL
     FROM SYS.DUAL;

   FOR i IN EMI_Q(nIdProcMasivo) LOOP
      IF  i.STSREGPROCESO = 'EMI'  THEN
         BEGIN
            DELETE PROCESOS_MASIVOS
             WHERE IdProcMasivo = nIdProcMasivo;
         EXCEPTION
            WHEN OTHERS THEN
               OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'2 ERROR','20225','Error en Traslado de registro a Tabla PROCESOS_MASIVOS_PROC '||SQLERRM);
               OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'2 ERROR');
         END;
      ELSE
         cMsjError := NULL;
         nIdSiniestro    := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(i.RegDatosProc,1,',')));
         nIdPoliza       := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(i.RegDatosProc,2,',')));

         nCodAsegurado  := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(i.RegDatosProc,4,',')));

         nNUM_APROBACION := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(i.RegDatosProc,5,','));

         SELECT IndPolCol
           INTO nIndPolCol
           FROM PROCESOS_MASIVOS_SEGUIMIENTO
          WHERE IdProcMasivo  = nIdProcMasivo;

         IF nIndPolCol = 'N' THEN   -- INDIVIDUAL
            BEGIN
               SELECT IDDETSIN
                 INTO nIDDETSIN
                 FROM DETALLE_SINIESTRO
                WHERE IdSiniestro = nIdSiniestro
                  AND IdPoliza    = nIdPoliza;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  cMsjError:=(' -20225  1 Error NDF DETALLE_SINIESTRO  '||SQLERRM);
                  RAISE_APPLICATION_ERROR(-20225,' 1 Error al extraer IDDETSIN de  DETALLE_SINIESTRO  '||SQLERRM);
               WHEN OTHERS  THEN
                  cMsjError:=(' -20225  2 Error Others al extraer IDDETSIN de  DETALLE_SINIESTRO '||SQLERRM);
                  RAISE_APPLICATION_ERROR(-20225,' 2 Error Others al extraer IDDETSIN de  DETALLE_SINIESTRO  '||SQLERRM);
            END;

            BEGIN
               OC_APROBACIONES.ANULAR(1, 1, nNUM_APROBACION, nIdSiniestro,nIdPoliza, nIDDETSIN);
            END;
         ELSIF nINDPOLCOL = 'S' THEN  -- COLECTIVO
            BEGIN
               SELECT IDDETSIN
                 INTO nIDDETSIN2
                 FROM DETALLE_SINIESTRO_ASEG
                WHERE IdSiniestro = nIdSiniestro
                  AND nIdPoliza    = nIdPoliza;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  cMsjError:=(' -20225  3 Error NDF DETALLE_SINIESTRO_ASEG  '||SQLERRM);
                  RAISE_APPLICATION_ERROR(-20225,' 3 Error al extraer IDDETSIN de  DETALLE_SINIESTRO_ASEG  '||SQLERRM);
               WHEN OTHERS  THEN
                  cMsjError:=(' -20225  4 Error Others al extraer IDDETSIN de  DETALLE_SINIESTRO_ASEG '||SQLERRM);
                  RAISE_APPLICATION_ERROR(-20225,' 4 Error Others al extraer IDDETSIN de  DETALLE_SINIESTRO_ASEG  '||SQLERRM);
            END;

            BEGIN
               OC_APROBACION_ASEG.ANULAR(1, 1, nNUM_APROBACION,nIdSiniestro,nIdPoliza, nCodAsegurado, nIDDETSIN2);
            END;
         END IF;
      END IF;

      IF cMsjError IS NULL THEN
         OC_PROCESOS_MASIVOS.INSERTA_PROCESO_MASIVO_PROC(nIdProcMasivo);
         OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'EMI');
         BEGIN
            SELECT IdTipoSeg, PlanCob, TipoProceso, RegDatosProc
              INTO nIdTipoSeg, nPlanCob, nTipoProceso, nRegDatosProc
              FROM PROCESOS_MASIVOS
             WHERE IdProcMasivo = nIdProcMasivo;
         EXCEPTION
            WHEN OTHERS THEN
               cMsjError:=('  -20225  2 Error en ACTUALIZA_STATUS '||SQLERRM);
         END;

         BEGIN
            UPDATE PROCESOS_MASIVOS_SEGUIMIENTO
               SET EMI_IDTIPOSEG     = nIdTipoSeg    ,
                   EMI_PLANCOB       = nPlanCob      ,
                   EMI_TIPOPROCESO   = nTipoProceso  ,
                   EMI_STSREGPROCESO = 'OK'         ,
                   EMI_REGDATOSPROC  = nRegDatosProc ,
                   EMI_USUARIO       = USUSARIO      ,
                   EMI_TERMINAL      = TERMINAL      ,
                   EMI_FECHA         = TRUNC(SYSDATE),
                   EMI_FECHACOMP     = SYSDATE       ,
                   IDPOLIZA          = nIdPoliza     ,
                   IDSINIESTRO       = nIdSiniestro  ,
                   COD_ASEGURADO     = nCodAsegurado ,
                   TIPO             = 'Anulacion LayOut Corto '
             WHERE IdProcMasivo = nIdProcMasivo;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               NULL;
            WHEN OTHERS  THEN
               cMsjError:=(' -20225  2 Error en ACTUALIZA_STATUS UPDATE PROCESOS_MASIVOS_SEGUIMIENTO EMI '||SQLERRM);
         END;

         BEGIN
            DELETE PROCESOS_MASIVOS
             WHERE IdProcMasivo = nIdProcMasivo;
         EXCEPTION
            WHEN OTHERS THEN
               OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'2 ERROR','20225','Error en Traslado de registro a Tabla PROCESOS_MASIVOS_PROC '||SQLERRM);
               OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'2 ERROR');
         END;
         BEGIN
            SELECT LTRIM(RTRIM(DESCRIPCION)), IDOBSERVA
              INTO CompletaLaFrase , EnQueLugar
              FROM OBSERVACION_SINIESTRO
             WHERE IdSiniestro = nIdSiniestro
               AND IdPoliza    = nIdPoliza
               AND IDOBSERVA   = (SELECT MAX(IDOBSERVA)
                                    FROM OBSERVACION_SINIESTRO
                                   WHERE IdSiniestro = nIdSiniestro
                                     AND IdPoliza    = nIdPoliza);
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cMsjError:=(' -20225 NDF 2 Error al encontrar DESCRIPCION OBSERVACION_SINIESTRO AURVAD '||SQLERRM);
            WHEN OTHERS THEN
               cMsjError:=(' -20225 NDF 2 OTHERS al encontrar DESCRIPCION OBSERVACION_SINIESTRO AURVAD '||SQLERRM);
         END;
         BEGIN
            UPDATE OBSERVACION_SINIESTRO
               SET DESCRIPCION = CompletaLaFrase||' <--> '||nObservaciones
             WHERE IDSINIESTRO = nIdSiniestro
               AND IDPOLIZA    = nIdPoliza
               AND IDOBSERVA   = EnQueLugar;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cMsjError:=(' -20225 NDF 2 Error al encontrar DESCRIPCION OBSERVACION_SINIESTRO AURVAD '||SQLERRM);
            WHEN OTHERS THEN
               cMsjError:=(' -20225 OTHERS 2 Error al encontrar DESCRIPCION OBSERVACION_SINIESTRO AURVAD '||SQLERRM);
         END;
      ELSE   ------------      H U B O     E R R O R E S  ----------------
         OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','No se puede Cargar el Siniestro: '||cMsjError);
         OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
         BEGIN
            SELECT PML.Idlogproceso, PML.Txterror
              INTO nIdlogproceso, nTxterror
              FROM PROCESOS_MASIVOS_LOG PML
             WHERE PML.IdProcMasivo = nIdProcMasivo
               AND PML.IDLOGPROCESO = (SELECT MAX(IDLOGPROCESO)
                                         FROM PROCESOS_MASIVOS_LOG PMLOG
                                        WHERE IdProcMasivo = PML.IdProcMasivo);
         EXCEPTION
            WHEN OTHERS THEN
               cMsjError:=('-20225 1 Error al consultar PROCESOS_MASIVOS_LOG '||SQLERRM);
         END;
         BEGIN
            UPDATE PROCESOS_MASIVOS_SEGUIMIENTO
               SET ERR_IDLOGPROCESO = nIdlogproceso ,
                   ERR_TXTERROR     = nTxterror     ,
                   ERR_USUARIO      = USUSARIO      ,
                   ERR_TERMINAL     = TERMINAL      ,
                   ERR_FECHA        = TRUNC(SYSDATE),
                   ERR_FECHACOMP    = SYSDATE
             WHERE IdProcMasivo = nIdProcMasivo;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               NULL;
            WHEN OTHERS  THEN
               NULL;
         END;
         RAISE_APPLICATION_ERROR(-20225,cMsjError );
      END IF;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Error - SINIESTROS_DIRVAD No se puede Cargar el Siniestro '|| SQLERRM);
      OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END SINIESTROS_ANUPGO;

PROCEDURE  SINIESTROS_PGOGG(nIdProcMasivo NUMBER) IS      -----PORFINSALES
nIdSiniestro     SINIESTRO.IDSINIESTRO%TYPE;    --  AEVS  NUEVO FLUJO LAYOUT CORTO   AURVAD
nCodAsegurado    SINIESTRO.COD_ASEGURADO%TYPE;
cNumDetUnico     DETALLE_POLIZA.IDETPOL%TYPE;
cIdTipoSeg       DETALLE_POLIZA.IDTIPOSEG%TYPE;
cPlanCob         DETALLE_POLIZA.PLANCOB%TYPE;
cStsPoliza       POLIZAS.STSPOLIZA%TYPE;
cMotivAnul       POLIZAS.MOTIVANUL%TYPE;
cNumPolUnico     POLIZAS.NUMPOLUNICO%TYPE;
nIdPoliza        POLIZAS.IDPOLIZA%TYPE;
nIdetPol         SINIESTRO.IDETPOL%TYPE;
nSumaAseg_Moneda COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nSumaAseg        COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nMontoRvaMoneda  COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
diferencia       COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
PruebaTotal      COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
Resultados       COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
nSumaAseg_Local  COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nMonto           COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nTasaCambio      TASAS_CAMBIO.Tasa_Cambio%TYPE;-- := OC_GENERALES.TASA_DE_CAMBIO(:BK_DATOS.cCod_Moneda, TRUNC(SYSDATE));
nMoneda          POLIZAS.COD_MONEDA%TYPE;
HabemusReserva   COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
nIdetSin         COBERTURA_SINIESTRO_ASEG.IDDETSIN%TYPE;
nNumMod          COBERTURA_SINIESTRO_ASEG.NUMMOD%TYPE;
nFecha           DATE;
cMsjError        VARCHAR2(1000);
TERMINAL         VARCHAR2(50);
USUSARIO         VARCHAR2(50);
nIdlogproceso    PROCESOS_MASIVOS_LOG.IDLOGPROCESO%TYPE;
nTxterror        PROCESOS_MASIVOS_LOG.TXTERROR%TYPE;
nIdTipoSeg       PROCESOS_MASIVOS.IDTIPOSEG%TYPE;
nPlanCob         PROCESOS_MASIVOS.PLANCOB%TYPE;
nTipoProceso     PROCESOS_MASIVOS.TIPOPROCESO%TYPE;
nRegDatosProc    PROCESOS_MASIVOS.REGDATOSPROC%TYPE;
nObservaciones   VARCHAR2(1000);
CompletaLaFrase  VARCHAR2(1000);
EnQueLugar       NUMBER;
nIDTRANSACCION    PROCESOS_MASIVOS_SEGUIMIENTO.IDTRANSACCION%TYPE;
nSALDO_RESERVA    COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA%TYPE;
-------PRUEBA DE  REGRESO   ----  TEMPORAL
nIdSiniestro2     COBERTURA_SINIESTRO_ASEG.IDSINIESTRO%TYPE;
nIdPoliza2        COBERTURA_SINIESTRO_ASEG.IDPOLIZA%TYPE;
nStsCobertura2    COBERTURA_SINIESTRO_ASEG.STSCOBERTURA%TYPE;
nNumMod2          COBERTURA_SINIESTRO_ASEG.NUMMOD%TYPE;
nCodTransac2      COBERTURA_SINIESTRO_ASEG.CODTRANSAC%TYPE;
nCodCptoTransac2  COBERTURA_SINIESTRO_ASEG.CODCPTOTRANSAC%TYPE;
nIdTransaccion2   COBERTURA_SINIESTRO_ASEG.IDTRANSACCION%TYPE;
nSaldoReserva2    COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA%TYPE;
HabemusPgoGG      NUMBER:=0;
WnIDPROCMASIVO    PROCESOS_MASIVOS_SEGUIMIENTO.IDPROCMASIVO%TYPE;
nPOLCONTA_GG      PROCESOS_MASIVOS_SEGUIMIENTO.POLCONTA_GG%TYPE;
nFECHA_PAGO       PROCESOS_MASIVOS_SEGUIMIENTO.FECHA_PAGO%TYPE;
nIMPORT_PAGO      PROCESOS_MASIVOS_SEGUIMIENTO.IMPORT_PAGO%TYPE;
nOBSERVACION_GG    PROCESOS_MASIVOS_SEGUIMIENTO.OBSERVACION_GG%TYPE;

CURSOR EMI_Q(NumProcMasivo IN NUMBER) IS
  SELECT PM.CodCia      CodCia     , PM.CodEmpresa     CodEmpresa, PM.IdTipoSeg     IdTipoSeg, PM.PlanCob           PlanCob, PM.NumPolUnico NumPolUnico,
         PM.NumDetUnico NumDetUnico, PM.RegDatosProc RegDatosProc, PM.TipoProceso TipoProceso, PM.IndColectiva IndColectiva, PM.STSREGPROCESO  STSREGPROCESO
    FROM PROCESOS_MASIVOS PM
   WHERE PM.IdProcMasivo   = NumProcMasivo; --nIdProcMasivo;
BEGIN
   SELECT USER ,USERENV('TERMINAL')                   ---  SIGUECARGA
     INTO USUSARIO , TERMINAL
     FROM SYS.DUAL;

   FOR i IN EMI_Q(nIdProcMasivo) LOOP

      IF i.STSREGPROCESO = 'EMI'  THEN
         BEGIN
            DELETE PROCESOS_MASIVOS
             WHERE IdProcMasivo = nIdProcMasivo;
         EXCEPTION
            WHEN OTHERS THEN
               OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'2 ERROR','20225','Error en Traslado de registro a Tabla PROCESOS_MASIVOS_PROC '||SQLERRM);
               OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'2 ERROR');
         END;
      ELSE
         cMsjError := NULL;
         WnIDPROCMASIVO   := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(i.RegDatosProc,1,',')));
         nPOLCONTA_GG     := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(i.RegDatosProc,2,','));
         nFECHA_PAGO      := TO_DATE(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(i.RegDatosProc,3,',')));
         nIMPORT_PAGO     := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(i.RegDatosProc,4,','));
         nOBSERVACION_GG  := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(i.RegDatosProc,5,','));

         SELECT COUNT(*)
           INTO HabemusPgoGG
           FROM PROCESOS_MASIVOS_SEGUIMIENTO
          WHERE IDPROCMASIVO    = WnIDPROCMASIVO
            AND EMI_TIPOPROCESO = 'PAGSIN'
            AND IDSINIESTRO IS NOT NULL
            AND POLCONTA_GG IS NULL;

         IF HabemusPgoGG = 1 THEN
            BEGIN
               UPDATE PROCESOS_MASIVOS_SEGUIMIENTO
                  SET POLCONTA_GG     = nPOLCONTA_GG,
                      FECHA_PAGO      = nFECHA_PAGO,
                      IMPORT_PAGO     = nIMPORT_PAGO,
                      PGOGG_USUARIO   = USUSARIO,
                      PGOGG_TERMINAL  = TERMINAL,
                      PGOGG_FECHA     = TRUNC(SYSDATE),
                      PGOGG_FECHACOMP = SYSDATE,
                      OBSERVACION_GG  = nOBSERVACION_GG
                WHERE IDPROCMASIVO    = WnIDPROCMASIVO ---3774959
                  AND EMI_TIPOPROCESO = 'PAGSIN'
                  AND IDSINIESTRO IS NOT NULL
                  AND POLCONTA_GG IS NULL;
            EXCEPTION
               WHEN OTHERS  THEN
                  RAISE_APPLICATION_ERROR(-20225,'Error al Actualizar Procesos_Masivos_Seguimiento: '||SQLERRM);
            END;
         ELSIF HabemusPgoGG > 1 THEN
            cMsjError := 'Error al cargar.El IDCarga: '||WnIDPROCMASIVO||' existe mas de 1 vez. Revisar con el equipo de Tecnologías de la Información. ';
            RAISE_APPLICATION_ERROR(-20225,'Error al cargar.El IDCarga: '||WnIDPROCMASIVO||' existe mas de 1 vez. Revisar con el equipo de Tecnologías de la Información. ');
         ELSIF HabemusPgoGG = 0 THEN
            cMsjError := 'Error al cargar.El IDCarga: '||WnIDPROCMASIVO||' ya fue actualizado antes. No puede ser actualizado mas de Una Vez. ';
            RAISE_APPLICATION_ERROR(-20225,'Error al cargar.El IDCarga: '||WnIDPROCMASIVO||' ya fue actualizado antes. No puede ser actualizado mas de Una Vez. ');
         END IF;
         IF cMsjError IS NULL THEN
            OC_PROCESOS_MASIVOS.INSERTA_PROCESO_MASIVO_PROC(nIdProcMasivo);
            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'EMI');
            BEGIN
               SELECT IdTipoSeg, PlanCob, TipoProceso, RegDatosProc
                 INTO nIdTipoSeg, nPlanCob, nTipoProceso, nRegDatosProc
                 FROM PROCESOS_MASIVOS
                WHERE IdProcMasivo = nIdProcMasivo;
            EXCEPTION
               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR(-20225,' 2 Error en ACTUALIZA_STATUS '||SQLERRM);
            END;

            BEGIN
               DELETE PROCESOS_MASIVOS
                WHERE IdProcMasivo = nIdProcMasivo;
            EXCEPTION
               WHEN OTHERS THEN
                  OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'2 ERROR','20225','Error en Traslado de registro a Tabla PROCESOS_MASIVOS_PROC '||SQLERRM);
                  OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'2 ERROR');
            END;
         ELSE   ------------      H U B O     E R R O R E S  ----------------
            OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','No se puede Cargar el Siniestro: '||cMsjError);
            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
            BEGIN
               SELECT PML.Idlogproceso, PML.Txterror
                 INTO nIdlogproceso, nTxterror
                 FROM PROCESOS_MASIVOS_LOG PML
                WHERE PML.IdProcMasivo = nIdProcMasivo
                  AND PML.IDLOGPROCESO = (SELECT MAX(IDLOGPROCESO)
                                            FROM PROCESOS_MASIVOS_LOG PMLOG
                                           WHERE IdProcMasivo =  PML.IdProcMasivo);
            EXCEPTION
               WHEN OTHERS THEN
                  cMsjError:=('-20225 1 Error al consultar PROCESOS_MASIVOS_LOG '||SQLERRM);
            END;
        END IF;
     END IF;
   END LOOP;  --> EMI_Q
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','Error - SINIESTROS_AURVAD No se puede Cargar el Siniestro '|| SQLERRM);
      OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END SINIESTROS_PGOGG;

PROCEDURE DIRVAD( wIdSiniestro in Number, wMntoPgo in Number, wCobertura in  Varchar2) IS
nIdSiniestro     SINIESTRO.IDSINIESTRO%TYPE;    --  AEVS  NUEVO FLUJO LAYOUT CORTO   DIRVAD
nCodAsegurado    SINIESTRO.COD_ASEGURADO%TYPE;
cNumDetUnico     DETALLE_POLIZA.IDETPOL%TYPE;
cIdTipoSeg       DETALLE_POLIZA.IDTIPOSEG%TYPE;
cPlanCob         DETALLE_POLIZA.PLANCOB%TYPE;
cStsPoliza       POLIZAS.STSPOLIZA%TYPE;
cMotivAnul       POLIZAS.MOTIVANUL%TYPE;
cNumPolUnico     POLIZAS.NUMPOLUNICO%TYPE;
nIdPoliza        POLIZAS.IDPOLIZA%TYPE;
nIdetPol         SINIESTRO.IDETPOL%TYPE;
nSumaAseg_Moneda COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nSumaAseg        COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nMontoRvaMoneda  COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
diferencia       COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
PruebaTotal      COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
Resultados       COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
nSaldoDeLaReserva COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA_LOCAL%TYPE;
prueba_SaldoReserva NUMBER:=0; ---COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA_LOCAL%TYPE;
nSumaAseg_Local  COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nMonto           COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nMonto22         COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nTasaCambio      TASAS_CAMBIO.Tasa_Cambio%TYPE;
nMoneda          POLIZAS.COD_MONEDA%TYPE;
HabemusReserva   COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
nIdetSin         COBERTURA_SINIESTRO_ASEG.IDDETSIN%TYPE;
nNumMod          COBERTURA_SINIESTRO_ASEG.NUMMOD%TYPE;
nFecha           DATE;
cMsjError        VARCHAR2(1000);
USUSARIO         VARCHAR2(50);
TERMINAL         VARCHAR2(50);
nIdlogproceso    PROCESOS_MASIVOS_LOG.IDLOGPROCESO%TYPE;
nTxterror        PROCESOS_MASIVOS_LOG.TXTERROR%TYPE;
nIdTipoSeg       PROCESOS_MASIVOS.IDTIPOSEG%TYPE;
nPlanCob         PROCESOS_MASIVOS.PLANCOB%TYPE;
nTipoProceso     PROCESOS_MASIVOS.TIPOPROCESO%TYPE;
nRegDatosProc    PROCESOS_MASIVOS.REGDATOSPROC%TYPE;
nObservaciones   VARCHAR2(1000);
CompletaLaFrase  VARCHAR2(1000);
EnQueLugar       NUMBER;
nIDTRANSACCION    PROCESOS_MASIVOS_SEGUIMIENTO.IDTRANSACCION%TYPE;
nSALDO_RESERVA    COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA%TYPE;
-------PRUEBA DE  REGRESO   ----  TEMPORAL
nIdSiniestro2     COBERTURA_SINIESTRO_ASEG.IDSINIESTRO%TYPE;
nIdPoliza2        COBERTURA_SINIESTRO_ASEG.IDPOLIZA%TYPE;
nStsCobertura2    COBERTURA_SINIESTRO_ASEG.STSCOBERTURA%TYPE;
nNumMod2          COBERTURA_SINIESTRO_ASEG.NUMMOD%TYPE;
nCodTransac2      COBERTURA_SINIESTRO_ASEG.CODTRANSAC%TYPE;
nCodCptoTransac2  COBERTURA_SINIESTRO_ASEG.CODCPTOTRANSAC%TYPE;
nIdTransaccion2   COBERTURA_SINIESTRO_ASEG.IDTRANSACCION%TYPE;
nSaldoReserva2    COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA%TYPE;
Dummy             NUMBER;
cIndColectivo     VARCHAR2(1);
nCodCia           POLIZAS.CodCia%TYPE;
cIndFecEquiv      SUB_PROCESO.IndFecEquiv%TYPE;
cIndFecEquivPro   PROC_TAREA.IndFecEquiv%TYPE;
dFechaCamb        APROBACIONES.FECPAGO%TYPE;
dFechaCont        FECHA_CONTABLE_EQUIVALENTE.FECHACONTABLE%TYPE;
dFechaReal        FECHA_CONTABLE_EQUIVALENTE.FECHAREAL%TYPE;
cCodEmpresa       SINIESTRO.CODEMPRESA%TYPE;
cCodCia           SINIESTRO.CODCIA%TYPE;

BEGIN
   cMsjError := NULL;

   BEGIN
      SELECT P.IdPoliza, DP.IDetPol, DP.IdTipoSeg, Dp.PlanCob, P.StsPoliza, P.MotivAnul,P.NUMPOLUNICO , SNT.COD_ASEGURADO, SNT.IDETPOL, P.COD_MONEDA , P.CodCia
        INTO   nIdPoliza, cNumDetUnico, cIdTipoSeg, cPlanCob, cStsPoliza, cMotivAnul ,cNumPolUnico , nCodAsegurado, nIdetPol, nMoneda ,nCodCia
        FROM SINIESTRO SNT, POLIZAS P, DETALLE_POLIZA DP
       WHERE SNT.IDSINIESTRO =  wIdSiniestro
         AND P.CodCia    = SNT.CODCIA
         AND P.IdPoliza  = SNT.IDPOLIZA
         AND P.StsPoliza IN ('REN','EMI','ANU')
         AND DP.CODCIA   = SNT.CODCIA
         AND DP.IDPOLIZA = SNT.IDPOLIZA
         AND DP.IDETPOL  = 1;
   EXCEPTION
      WHEN TOO_MANY_ROWS THEN
         cMsjError:=('-20225 DIRVAD Error SELECT POLIZAS Duplicidad de informacion  Suma Asegurada  : ' ||SQLERRM);
      WHEN NO_DATA_FOUND THEN
         cMsjError:=('-20225  DIRVAD Error SELECT POLIZAS NDF  Suma Asegurada  : ' ||SQLERRM);
      WHEN OTHERS THEN
         cMsjError:=('-20225 DIRVAD Error SELECT POLIZAS OTHERS Suma Asegurada  : ' ||SQLERRM);
   END;
   IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(nCodCia, nIdPoliza, nIDetPol, nCodAsegurado) = 'S' THEN
      cIndColectivo := 'S';
   ELSE
      cIndColectivo := 'N';
   END IF;
   IF cMsjError IS NULL THEN
      BEGIN
         SELECT SumaAseg_Moneda,SumaAseg_Local
           INTO nSumaAseg_Moneda, nSumaAseg_Local
           FROM (SELECT NVL(SumaAseg_Moneda,0) SumaAseg_Moneda, NVL(SumaAseg_Local,0) SumaAseg_Local
                   FROM COBERT_ACT_ASEG
                  WHERE CodCia        = nCodCia
                    AND IdPoliza      = nIdPoliza
                    AND IdetPol       = nIdetPol
                    AND Cod_Asegurado = nCodAsegurado
                    AND CodCobert     = wCobertura
                  UNION
                 SELECT NVL(SumaAseg_Moneda,0) SumaAseg_Moneda, NVL(SumaAseg_Local,0) SumaAseg_Local
                   FROM COBERT_ACT
                  WHERE CodCia        = nCodCia
                    AND IdPoliza      = nIdPoliza
                    AND IdetPol       = nIdetPol
                    AND CodCobert     = wCobertura);
      EXCEPTION
         WHEN TOO_MANY_ROWS THEN
            cMsjError:=('-20225   Error COBERT_ACT_ASEG Duplicidad de informacion  Suma Asegurada  : ' ||SQLERRM);
         WHEN NO_DATA_FOUND THEN
            cMsjError:=('-20225   Error COBERT_ACT_ASEG NDF  Suma Asegurada  : ' ||SQLERRM);
         WHEN OTHERS THEN
            cMsjError:=('-20225   Error COBERT_ACT_ASEG OTHERS Suma Asegurada  : ' ||SQLERRM);
      END ;
   END IF;

   IF nSumaAseg_Moneda = nSumaAseg_Local THEN
      IF nSumaAseg_Moneda > 0 THEN
         nSumaAseg := nSumaAseg_Moneda;
      END IF;
   ELSE
      nSumaAseg:= 0;
   END IF;

     -----  Sacamos el monto del Saldo de la Reserva   -----------
   IF cMsjError IS NULL THEN
      BEGIN
         SELECT SALDO_RESERVA
           INTO nSaldoDeLaReserva
           FROM (SELECT SALDO_RESERVA
                   FROM COBERTURA_SINIESTRO_ASEG
                  WHERE IDDETSIN      = 1
                    AND CODCOBERT     = wCobertura
                    AND IDSINIESTRO   = wIdSiniestro
                    AND IDPOLIZA      = nIdPoliza
                    AND COD_ASEGURADO = nCodAsegurado
                    AND NUMMOD        = (SELECT MAX(NUMMOD)
                                           FROM COBERTURA_SINIESTRO_ASEG
                                          WHERE CODCOBERT     = wCobertura
                                            AND IDSINIESTRO   = wIdSiniestro
                                            AND IDPOLIZA      = nIdPoliza
                                            AND COD_ASEGURADO = nCodAsegurado)
                   UNION
                  SELECT SALDO_RESERVA
                    FROM COBERTURA_SINIESTRO
                   WHERE IDDETSIN      = 1
                     AND CODCOBERT     = wCobertura
                     AND IDSINIESTRO   = wIdSiniestro
                     AND IDPOLIZA      = nIdPoliza
                     AND NUMMOD        = (SELECT MAX(NUMMOD)
                                            FROM COBERTURA_SINIESTRO
                                           WHERE CODCOBERT     = wCobertura
                                             AND IDSINIESTRO   = wIdSiniestro
                                             AND IDPOLIZA      = nIdPoliza));
      EXCEPTION
         WHEN NO_DATA_FOUND  THEN
            cMsjError:=('-20225 NDF Error COBERTURA_SINIESTRO_ASEG  nSaldoDeLaReserva     : ' ||SQLERRM);
            RAISE_APPLICATION_ERROR(-20225,'NDF Error COBERTURA_SINIESTRO_ASEG  nSaldoDeLaReserva     : ' ||SQLERRM);
         WHEN OTHERS THEN
            cMsjError:=('-20225 OTHERS Error COBERTURA_SINIESTRO_ASEG  nSaldoDeLaReserva     : ' ||SQLERRM);
            RAISE_APPLICATION_ERROR(-20225,' OTHERS Error COBERTURA_SINIESTRO_ASEG  nSaldoDeLaReserva     : ' ||SQLERRM);
      END;
   END IF;
   IF cMsjError IS NULL THEN
      IF nSaldoDeLaReserva = 0 THEN
         cMsjError:=(' El Saldo de la Reserva es Cero y no puede quedar Negativa. No se Puede crear éste Ajuste');
      END IF;
   END IF;

   IF  cMsjError IS NULL THEN
      Prueba_SaldoReserva := nSaldoDeLaReserva - wMntoPgo;
      IF Prueba_SaldoReserva < 0  THEN
         cMsjError:=('-20225 La Disminución dejaría el Saldo de la Reserva Negativa. No se Puede crear éste Ajuste');
         RAISE_APPLICATION_ERROR(-20225,'La Disminución dejaría el Saldo de la Reserva Negativa. No se Puede crear éste Ajuste');
      END IF;
   END IF;

   IF cMsjError IS NULL THEN
      Diferencia := 0; --nSumaAseg - nMontoRvaMoneda ;
      IF (Diferencia > 0) OR (Diferencia = 0)   THEN
         IF cIndColectivo = 'S' THEN
            SELECT NVL(MAX(NumMod),0) + 1 NumMod
              INTO nNumMod
              FROM COBERTURA_SINIESTRO_ASEG
             WHERE IdPoliza      = nIdPoliza
               AND IdSiniestro   = wIdSiniestro
               AND IDDETSIN       = 1
               AND CodCobert     = wCobertura
               AND Cod_Asegurado = nCodAsegurado;
         ELSE
            SELECT NVL(MAX(NumMod),0) + 1 NumMod
              INTO nNumMod
              FROM COBERTURA_SINIESTRO
             WHERE IdPoliza      = nIdPoliza
               AND IdSiniestro   = wIdSiniestro
               AND IDDETSIN      = 1
               AND CodCobert     = wCobertura;
         END IF;

         BEGIN
            BEGIN
               SELECT NVL(CodEmpresa,1),NVL(CodCia,1)
                 INTO cCodEmpresa, cCodCia
                 FROM SINIESTRO
                WHERE IdSiniestro = wIdSiniestro;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-202,'No existe compañia:'||SQLERRM);
            END;

            cIndFecEquivPro := OC_PROC_TAREA.INDICA_FEC_EQUIVALENTE_PRO(6);
            cIndFecEquiv    := OC_SUB_PROCESO.INDICA_FEC_EQUIVALENTE_SUBPROC(6, 'EMIRES');
            dFechaCont      := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_CONTABLE(cCodCia, cCodEmpresa);
            dFechaReal      := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_REAL(cCodCia, cCodEmpresa);

            IF cIndFecEquivPro = 'S' THEN
               IF cIndFecEquiv = 'S' THEN
                  dFechaCamb:= dFechaCont;
               ELSE
                   dFechaCamb := dFechaReal;
               END IF;
            ELSE
               dFechaCamb := dFechaReal;
            END IF;

            IF cIndColectivo = 'S' THEN
               INSERT INTO COBERTURA_SINIESTRO_ASEG
                     (IDDETSIN, CODCOBERT, IDSINIESTRO, IDPOLIZA, COD_ASEGURADO, DOC_REF_PAGO,
                      MONTO_PAGADO_MONEDA, MONTO_PAGADO_LOCAL, MONTO_RESERVADO_MONEDA,
                      MONTO_RESERVADO_LOCAL, STSCOBERTURA, NUMMOD, CODTRANSAC, CODCPTOTRANSAC,
                      IDTRANSACCION, SALDO_RESERVA, INDORIGEN, FECRES, SALDO_RESERVA_LOCAL,
                      IDTRANSACCIONANUL)
               VALUES(1, wCobertura, wIdSiniestro, nIdPoliza, nCodAsegurado, NULL,
                      00.00, 00.00, wMntoPgo, wMntoPgo, 'SOL', nNumMod, 'DIRVAD', 'DIPGTO',
                      NULL, Prueba_SaldoReserva, 'A', TRUNC(dFechaCamb), Prueba_SaldoReserva,
                      NULL);
            ELSE
                INSERT INTO COBERTURA_SINIESTRO
                     (IDDETSIN, CODCOBERT, IDSINIESTRO, IDPOLIZA, DOC_REF_PAGO,
                      MONTO_PAGADO_MONEDA, MONTO_PAGADO_LOCAL, MONTO_RESERVADO_MONEDA,
                      MONTO_RESERVADO_LOCAL, STSCOBERTURA, NUMMOD, CODTRANSAC, CODCPTOTRANSAC,
                      IDTRANSACCION, SALDO_RESERVA, INDORIGEN, FECRES, SALDO_RESERVA_LOCAL,
                      IDTRANSACCIONANUL)
               VALUES(1, wCobertura, wIdSiniestro, nIdPoliza, NULL,
                      00.00, 00.00, wMntoPgo, wMntoPgo, 'SOL', nNumMod, 'DIRVAD', 'DIPGTO',
                      NULL, Prueba_SaldoReserva, 'A', TRUNC(dFechaCamb), Prueba_SaldoReserva,
                      NULL);
            END IF;
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
               cMsjError:=('-20225  DIRVAD Error INSERT COBERTURA_SINIESTRO_ASEG Ya existe el registro  : ' ||SQLERRM);
            WHEN OTHERS THEN
               cMsjError:=(' -20225 DIRVAD Error INSERT COBERTURA_SINIESTRO_ASEG OTHERS    : ' ||SQLERRM);
         END;

         IF cMsjError IS NULL THEN
            BEGIN
               IF cIndColectivo = 'S' THEN
                  OC_COBERTURA_SINIESTRO_ASEG.EMITE_RESERVA(nCodCia  ,1, wIdSiniestro,
                                                            nIdPoliza , 1          , nCodAsegurado,
                                                            wCobertura, nNumMod    , NULL);
               ELSE
                  OC_COBERTURA_SINIESTRO.EMITE_RESERVA(nCodCia  ,1, wIdSiniestro,
                                                       nIdPoliza , 1 ,wCobertura,
                                                       nNumMod    , NULL);
               END IF;
            EXCEPTION
               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR(-20225,'DIRVAD Error OC_COBERTURA_SINIESTRO_ASEG.EMITE_RESERVA  : ' ||SQLERRM);
            END;
         END IF;
      ELSE
         cMsjError:= 'La reserva No puede ser creada';
      END IF;
   END IF;

   BEGIN
      IF cIndColectivo = 'S' THEN
         UPDATE COBERTURA_SINIESTRO_ASEG
            SET MONTO_RESERVADO_LOCAL   = wMntoPgo,
                MONTO_RESERVADO_MONEDA  = wMntoPgo,
                SALDO_RESERVA_LOCAL     = Prueba_SaldoReserva
          WHERE IDDETSIN      = 1
            AND CODCOBERT     = wCobertura
            AND IDSINIESTRO   = wIdSiniestro
            AND IDPOLIZA      = nIdPoliza
            AND COD_ASEGURADO = nCodAsegurado
            AND NUMMOD        = nNumMod;
      ELSE
         UPDATE COBERTURA_SINIESTRO
            SET MONTO_RESERVADO_LOCAL  = wMntoPgo,
                MONTO_RESERVADO_MONEDA = wMntoPgo,
                SALDO_RESERVA_LOCAL    = Prueba_SaldoReserva
          WHERE IDDETSIN      = 1
            AND CODCOBERT     = wCobertura
            AND IDSINIESTRO   = wIdSiniestro
            AND IDPOLIZA      = nIdPoliza
            AND NUMMOD        = nNumMod;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NDF Error al actualizar COBERTURA_SINIESTRO_ASEG : '||SQLERRM);
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20225,'OTHERS  Error al actualizar COBERTURA_SINIESTRO_ASEG : '||SQLERRM);
   END;

   BEGIN
      SELECT LTRIM(RTRIM(DESCRIPCION)), IDOBSERVA
        INTO CompletaLaFrase, EnQueLugar
        FROM OBSERVACION_SINIESTRO
       WHERE IDSINIESTRO = wIdSiniestro
         AND IDPOLIZA    = nIdPoliza
         AND IDOBSERVA   = (SELECT MAX(IDOBSERVA)
                              FROM OBSERVACION_SINIESTRO
                             WHERE IDSINIESTRO = wIdSiniestro
                               AND IDPOLIZA    = nIdPoliza);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cMsjError:=(' -20225 NDF 2 Error al encontrar DESCRIPCION OBSERVACION_SINIESTRO AURVAD '||SQLERRM);
      WHEN OTHERS THEN
         cMsjError:=(' -20225 NDF 2 OTHERS al encontrar DESCRIPCION OBSERVACION_SINIESTRO AURVAD '||SQLERRM);
   END;

   BEGIN
      UPDATE OBSERVACION_SINIESTRO
         SET DESCRIPCION = CompletaLaFrase||' <--> '||' Pago Total. Ajuste Negativo para dejar Reserva en Cero.'
       WHERE IDSINIESTRO = wIdSiniestro
         AND IDPOLIZA    = nIdPoliza
         AND IDOBSERVA   = EnQueLugar;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cMsjError:=(' -20225 NDF 3 Error al encontrar DESCRIPCION OBSERVACION_SINIESTRO AURVAD '||SQLERRM);
      WHEN OTHERS THEN
         cMsjError:=(' -20225 OTHERS 3 Error al encontrar DESCRIPCION OBSERVACION_SINIESTRO AURVAD '||SQLERRM);
   END;

   BEGIN
      UPDATE DETALLE_SINIESTRO_ASEG
         SET MONTO_RESERVADO_MONEDA = (MONTO_RESERVADO_MONEDA - wMntoPgo),
             MONTO_RESERVADO_LOCAL  = (MONTO_RESERVADO_LOCAL  - wMntoPgo)
       WHERE IDSINIESTRO = wIdSiniestro
         AND IDPOLIZA    = nIdPoliza
         AND IDDETSIN    = 1;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cMsjError:=(' -20225 NDF 4 Error al actualizar  DETALLE_SINIESTRO_ASEG DIRVAD '||SQLERRM);
      WHEN OTHERS THEN
         cMsjError:=(' -20225 OTHERS 4 Error al actualizar  DETALLE_SINIESTRO_ASEG DIRVAD '||SQLERRM);
    END;

    BEGIN
       UPDATE SINIESTRO
          SET MONTO_RESERVA_MONEDA = (MONTO_RESERVA_MONEDA - wMntoPgo),
              MONTO_RESERVA_LOCAL  = (MONTO_RESERVA_LOCAL  - wMntoPgo)
        WHERE IDSINIESTRO = wIdSiniestro
          AND IDPOLIZA    = nIdPoliza;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          cMsjError:=(' -20225 NDF 4 Error al actualizar  SINIESTRO DIRVAD '||SQLERRM);
       WHEN OTHERS THEN
          cMsjError:=(' -20225 OTHERS 4 Error al actualizar  SINIESTRO DIRVAD '||SQLERRM);
    END;

    IF cMsjError IS NULL THEN
       NULL;
    ELSE
       ROLLBACK;
    END IF;
END DIRVAD;

PROCEDURE AURVAD (wIdSiniestro in Number, wMntoPgo in Number, wCobertura in  Varchar2) IS
nIdSiniestro     SINIESTRO.IDSINIESTRO%TYPE;    --  AEVS  NUEVO FLUJO LAYOUT CORTO   DIRVAD
nCodAsegurado    SINIESTRO.COD_ASEGURADO%TYPE;
cNumDetUnico     DETALLE_POLIZA.IDETPOL%TYPE;
cIdTipoSeg       DETALLE_POLIZA.IDTIPOSEG%TYPE;
cPlanCob         DETALLE_POLIZA.PLANCOB%TYPE;
cStsPoliza       POLIZAS.STSPOLIZA%TYPE;
cMotivAnul       POLIZAS.MOTIVANUL%TYPE;
cNumPolUnico     POLIZAS.NUMPOLUNICO%TYPE;
nIdPoliza        POLIZAS.IDPOLIZA%TYPE;
nIdetPol         SINIESTRO.IDETPOL%TYPE;
nSumaAseg_Moneda COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nSumaAseg        COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nMontoRvaMoneda  COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
diferencia       COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
PruebaTotal      COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
Resultados       COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
nSaldoDeLaReserva COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA_LOCAL%TYPE;
prueba_SaldoReserva NUMBER:=0; ---COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA_LOCAL%TYPE;
nSumaAseg_Local  COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nMonto           COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nMonto22         COBERT_ACT_ASEG.SUMAASEG_LOCAL%TYPE;
nTasaCambio      TASAS_CAMBIO.Tasa_Cambio%TYPE;
nMoneda          POLIZAS.COD_MONEDA%TYPE;
HabemusReserva   COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
nIdetSin         COBERTURA_SINIESTRO_ASEG.IDDETSIN%TYPE;
nNumMod          COBERTURA_SINIESTRO_ASEG.NUMMOD%TYPE;
nFecha           DATE;
cMsjError        VARCHAR2(1000);
USUSARIO         VARCHAR2(50);
TERMINAL         VARCHAR2(50);
nIdlogproceso    PROCESOS_MASIVOS_LOG.IDLOGPROCESO%TYPE;
nTxterror        PROCESOS_MASIVOS_LOG.TXTERROR%TYPE;
nIdTipoSeg       PROCESOS_MASIVOS.IDTIPOSEG%TYPE;
nPlanCob         PROCESOS_MASIVOS.PLANCOB%TYPE;
nTipoProceso     PROCESOS_MASIVOS.TIPOPROCESO%TYPE;
nRegDatosProc    PROCESOS_MASIVOS.REGDATOSPROC%TYPE;
nObservaciones   VARCHAR2(1000);
CompletaLaFrase  VARCHAR2(1000);
EnQueLugar       NUMBER;
nIDTRANSACCION    PROCESOS_MASIVOS_SEGUIMIENTO.IDTRANSACCION%TYPE;
nSALDO_RESERVA    COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA%TYPE;
-------PRUEBA DE  REGRESO   ----  TEMPORAL
nIdSiniestro2     COBERTURA_SINIESTRO_ASEG.IDSINIESTRO%TYPE;
nIdPoliza2        COBERTURA_SINIESTRO_ASEG.IDPOLIZA%TYPE;
nStsCobertura2    COBERTURA_SINIESTRO_ASEG.STSCOBERTURA%TYPE;
nNumMod2          COBERTURA_SINIESTRO_ASEG.NUMMOD%TYPE;
nCodTransac2      COBERTURA_SINIESTRO_ASEG.CODTRANSAC%TYPE;
nCodCptoTransac2  COBERTURA_SINIESTRO_ASEG.CODCPTOTRANSAC%TYPE;
nIdTransaccion2   COBERTURA_SINIESTRO_ASEG.IDTRANSACCION%TYPE;
nSaldoReserva2    COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA%TYPE;
Dummy             NUMBER;
cIndColectivo     VARCHAR2(1);
nCodCia           POLIZAS.CodCia%TYPE;
cIndFecEquiv      SUB_PROCESO.IndFecEquiv%TYPE;
cIndFecEquivPro   PROC_TAREA.IndFecEquiv%TYPE;
dFechaCamb        APROBACIONES.FECPAGO%TYPE;
dFechaCont        FECHA_CONTABLE_EQUIVALENTE.FECHACONTABLE%TYPE;
dFechaReal        FECHA_CONTABLE_EQUIVALENTE.FECHAREAL%TYPE;
cCodEmpresa       SINIESTRO.CODEMPRESA%TYPE;
cCodCia           SINIESTRO.CODCIA%TYPE;
BEGIN
   cMsjError := NULL;

   BEGIN
      SELECT P.IdPoliza, DP.IDetPol, DP.IdTipoSeg, Dp.PlanCob, P.StsPoliza, P.MotivAnul,P.NUMPOLUNICO , SNT.COD_ASEGURADO, SNT.IDETPOL, P.COD_MONEDA , P.CodCia
        INTO nIdPoliza, cNumDetUnico, cIdTipoSeg, cPlanCob, cStsPoliza, cMotivAnul ,cNumPolUnico , nCodAsegurado, nIdetPol, nMoneda ,nCodCia
        FROM SINIESTRO  SNT, POLIZAS P, DETALLE_POLIZA DP
       WHERE SNT.IDSINIESTRO =  wIdSiniestro
         AND P.CodCia    = SNT.CODCIA
         AND P.IdPoliza  = SNT.IDPOLIZA
         AND P.StsPoliza IN ('REN','EMI','ANU')
         AND DP.CODCIA   = SNT.CODCIA
         AND DP.IDPOLIZA = SNT.IDPOLIZA
         AND DP.IDETPOL  = 1;
   EXCEPTION
      WHEN TOO_MANY_ROWS THEN
         cMsjError:=('-20225 AURVAD Error SELECT POLIZAS Duplicidad de informacion  Suma Asegurada  : ' ||SQLERRM);
      WHEN NO_DATA_FOUND THEN
         cMsjError:=('-20225  AURVAD Error SELECT POLIZAS NDF  Suma Asegurada  : ' ||SQLERRM);
      WHEN OTHERS THEN
         cMsjError:=('-20225 AURVAD Error SELECT POLIZAS OTHERS Suma Asegurada  : ' ||SQLERRM);
   END;
   IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(nCodCia, nIdPoliza, nIDetPol, nCodAsegurado) = 'S' THEN
      cIndColectivo := 'S';
   ELSE
      cIndColectivo := 'N';
   END IF;
   IF cMsjError IS NULL THEN
      BEGIN
         SELECT SumaAseg_Moneda,SumaAseg_Local
           INTO nSumaAseg_Moneda, nSumaAseg_Local
           FROM (SELECT NVL(SumaAseg_Moneda,0) SumaAseg_Moneda, NVL(SumaAseg_Local,0) SumaAseg_Local
                   FROM COBERT_ACT_ASEG
                  WHERE CodCia        = nCodCia
                    AND IdPoliza      = nIdPoliza
                    AND IdetPol       = nIdetPol
                    AND Cod_Asegurado = nCodAsegurado
                    AND CodCobert     = wCobertura
                  UNION
                 SELECT NVL(SumaAseg_Moneda,0) SumaAseg_Moneda, NVL(SumaAseg_Local,0) SumaAseg_Local
                   FROM COBERT_ACT
                  WHERE CodCia        = nCodCia
                    AND IdPoliza      = nIdPoliza
                    AND IdetPol       = nIdetPol
                    AND CodCobert     = wCobertura);
      EXCEPTION
         WHEN TOO_MANY_ROWS THEN
            cMsjError:=('-20225 AURVAD  Error COBERT_ACT_ASEG Duplicidad de informacion  Suma Asegurada  : ' ||SQLERRM);
         WHEN NO_DATA_FOUND THEN
            cMsjError:=('-20225 AURVAD  Error COBERT_ACT_ASEG NDF  Suma Asegurada  : ' ||SQLERRM);
         WHEN OTHERS THEN
            cMsjError:=('-20225 AURVAD  Error COBERT_ACT_ASEG OTHERS Suma Asegurada  : ' ||SQLERRM);
      END ;
   END IF;

   IF nSumaAseg_Moneda = nSumaAseg_Local THEN
      IF nSumaAseg_Moneda > 0 THEN
         nSumaAseg := nSumaAseg_Moneda;
      END IF;
   ELSE
      nSumaAseg := 0;
   END IF;

     -----  Sacamos el monto del Saldo de la Reserva   -----------
   IF cMsjError IS NULL THEN
      BEGIN
         SELECT Saldo_Reserva
           INTO nSaldoDeLaReserva
           FROM (SELECT SALDO_RESERVA
                   FROM COBERTURA_SINIESTRO_ASEG
                  WHERE IDDETSIN        = 1
                    AND CODCOBERT     = wCobertura
                    AND IDSINIESTRO   = wIdSiniestro
                    AND IDPOLIZA      = nIdPoliza
                    AND COD_ASEGURADO = nCodAsegurado
                    AND NUMMOD        = (SELECT MAX(NUMMOD)
                                           FROM COBERTURA_SINIESTRO_ASEG
                                          WHERE CODCOBERT     = wCobertura
                                            AND IDSINIESTRO   = wIdSiniestro
                                            AND IDPOLIZA      = nIdPoliza
                                            AND COD_ASEGURADO = nCodAsegurado)
                  UNION
                  SELECT SALDO_RESERVA
                    FROM COBERTURA_SINIESTRO
                   WHERE IDDETSIN      = 1
                     AND CODCOBERT     = wCobertura
                     AND IDSINIESTRO   = wIdSiniestro
                     AND IDPOLIZA      = nIdPoliza
                     AND NUMMOD        = (SELECT MAX(NUMMOD)
                                            FROM COBERTURA_SINIESTRO CSA3
                                           WHERE CODCOBERT     = wCobertura
                                             AND IDSINIESTRO   = wIdSiniestro
                                             AND IDPOLIZA      = nIdPoliza));
      EXCEPTION
         WHEN NO_DATA_FOUND  THEN
            cMsjError:=('-20225 NDF Error COBERTURA_SINIESTRO_ASEG  nSaldoDeLaReserva     : ' ||SQLERRM);
            RAISE_APPLICATION_ERROR(-20225,'NDF Error COBERTURA_SINIESTRO_ASEG  nSaldoDeLaReserva     : ' ||SQLERRM);
         WHEN OTHERS  THEN
            cMsjError:=('-20225 OTHERS Error COBERTURA_SINIESTRO_ASEG  nSaldoDeLaReserva     : ' ||SQLERRM);
      END;
   END IF;

   IF nSaldoDeLaReserva IS NULL THEN
      cMsjError:=('AURVAD El Saldo de la Reserva es Nulo. No se Puede crear éste Ajuste     ');
      RAISE_APPLICATION_ERROR(-20225,'AURVAD El Saldo de la Reserva es Nulo. No se Puede crear éste Ajuste     ');
   END IF;

   IF cMsjError IS NULL THEN
      SELECT(nSaldoDeLaReserva + wMntoPgo)
        INTO prueba_SaldoReserva
        FROM DUAL;
   END IF;

   IF cMsjError IS NULL THEN
      Diferencia := 0; --nSumaAseg - nMontoRvaMoneda ;
      IF (Diferencia > 0) OR (Diferencia = 0)   THEN
         IF cIndColectivo = 'S' THEN
            SELECT NVL(MAX(NumMod),0) + 1 NumMod
              INTO nNumMod
              FROM COBERTURA_SINIESTRO_ASEG
             WHERE IdPoliza      = nIdPoliza
               AND IdSiniestro   = wIdSiniestro
               AND IDDETSIN       = 1
               AND CodCobert     = wCobertura
               AND Cod_Asegurado = nCodAsegurado;
         ELSE
            SELECT NVL(MAX(NumMod),0) + 1 NumMod
              INTO nNumMod
              FROM COBERTURA_SINIESTRO
             WHERE IdPoliza      = nIdPoliza
               AND IdSiniestro   = wIdSiniestro
               AND IDDETSIN      = 1
               AND CodCobert     = wCobertura;
         END IF;

         BEGIN
            BEGIN
               SELECT NVL(CodEmpresa,1),NVL(CodCia,1)
                 INTO cCodEmpresa, cCodCia
                 FROM SINIESTRO
                WHERE IdSiniestro = wIdSiniestro;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-202,'No existe compañia:'||SQLERRM);
            END;

            cIndFecEquivPro := OC_PROC_TAREA.INDICA_FEC_EQUIVALENTE_PRO(6);
            cIndFecEquiv    := OC_SUB_PROCESO.INDICA_FEC_EQUIVALENTE_SUBPROC(6, 'EMIRES');
            dFechaCont      := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_CONTABLE(cCodCia, cCodEmpresa);
            dFechaReal      := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_REAL(cCodCia, cCodEmpresa);

            IF cIndFecEquivPro = 'S' THEN
               IF cIndFecEquiv = 'S' THEN
                  dFechaCamb:= dFechaCont;
               ELSE
                  dFechaCamb := dFechaReal;
               END IF;
            ELSE
               dFechaCamb := dFechaReal;
            END IF;

            IF cIndColectivo = 'S' THEN
               INSERT INTO COBERTURA_SINIESTRO_ASEG
                     (IDDETSIN, CODCOBERT, IDSINIESTRO, IDPOLIZA, COD_ASEGURADO, DOC_REF_PAGO,
                      MONTO_PAGADO_MONEDA, MONTO_PAGADO_LOCAL, MONTO_RESERVADO_MONEDA,
                      MONTO_RESERVADO_LOCAL, STSCOBERTURA, NUMMOD, CODTRANSAC, CODCPTOTRANSAC,
                      IDTRANSACCION, SALDO_RESERVA, INDORIGEN, FECRES, SALDO_RESERVA_LOCAL,
                      IDTRANSACCIONANUL)
               VALUES(1, wCobertura, wIdSiniestro, nIdPoliza, nCodAsegurado, NULL,
                      00.00, 00.00, wMntoPgo, wMntoPgo, 'SOL', nNumMod, 'AURVBA', 'AUPGTO',
                      NULL, Prueba_SaldoReserva, 'A', TRUNC(dFechaCamb), Prueba_SaldoReserva,
                      NULL);
            ELSE
                INSERT INTO COBERTURA_SINIESTRO
                     (IDDETSIN, CODCOBERT, IDSINIESTRO, IDPOLIZA, DOC_REF_PAGO,
                      MONTO_PAGADO_MONEDA, MONTO_PAGADO_LOCAL, MONTO_RESERVADO_MONEDA,
                      MONTO_RESERVADO_LOCAL, STSCOBERTURA, NUMMOD, CODTRANSAC, CODCPTOTRANSAC,
                      IDTRANSACCION, SALDO_RESERVA, INDORIGEN, FECRES, SALDO_RESERVA_LOCAL,
                      IDTRANSACCIONANUL)
               VALUES(1, wCobertura, wIdSiniestro, nIdPoliza, NULL,
                      00.00, 00.00, wMntoPgo, wMntoPgo, 'SOL', nNumMod, 'AURVBA', 'AUPGTO',
                      NULL, Prueba_SaldoReserva, 'A', TRUNC(dFechaCamb), Prueba_SaldoReserva,
                      NULL);
            END IF;
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
               cMsjError:=('-20225  AURVAD Error INSERT COBERTURA_SINIESTRO_ASEG Ya existe el registro  : ' ||SQLERRM);
            WHEN OTHERS THEN
               cMsjError:=(' -20225 AURVAD Error INSERT COBERTURA_SINIESTRO_ASEG OTHERS    : ' ||SQLERRM);
         END;
         IF cMsjError IS NULL THEN
            BEGIN
               IF cIndColectivo = 'S' THEN
                  OC_COBERTURA_SINIESTRO_ASEG.EMITE_RESERVA(nCodCia  ,1, wIdSiniestro,
                                                            nIdPoliza , 1          , nCodAsegurado,
                                                            wCobertura, nNumMod    , null);
               ELSE
                  OC_COBERTURA_SINIESTRO.EMITE_RESERVA(nCodCia  ,1, wIdSiniestro,
                                                       nIdPoliza , 1,wCobertura,
                                                       nNumMod    , null);
               END IF;
            EXCEPTION
               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR(-20225,' AURVAD Error OC_COBERTURA_SINIESTRO_ASEG.EMITE_RESERVA  : ' ||SQLERRM);
            END;
        END IF;
     ELSE
        cMsjError:= 'La reserva No puede ser creada ' ;
     END IF;
  END IF;

   BEGIN
      IF cIndColectivo = 'S' THEN
         UPDATE COBERTURA_SINIESTRO_ASEG
            SET MONTO_RESERVADO_LOCAL   = wMntoPgo,
                MONTO_RESERVADO_MONEDA  = wMntoPgo,
                SALDO_RESERVA_LOCAL     = Prueba_SaldoReserva
          WHERE IDDETSIN      = 1
            AND CODCOBERT     = wCobertura
            AND IDSINIESTRO   = wIdSiniestro
            AND IDPOLIZA      = nIdPoliza
            AND COD_ASEGURADO = nCodAsegurado
            AND NUMMOD        = nNumMod;
      ELSE
         UPDATE COBERTURA_SINIESTRO
            SET MONTO_RESERVADO_LOCAL  = wMntoPgo,
                MONTO_RESERVADO_MONEDA = wMntoPgo,
                SALDO_RESERVA_LOCAL    = Prueba_SaldoReserva
          WHERE IDDETSIN      = 1
            AND CODCOBERT     = wCobertura
            AND IDSINIESTRO   = wIdSiniestro
            AND IDPOLIZA      = nIdPoliza
            AND NUMMOD        = nNumMod;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'AURVAD  NDF Error al actualizar COBERTURA_SINIESTRO_ASEG :'||SQLERRM);
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20225,'OTHERS  Error al actualizar COBERTURA_SINIESTRO_ASEG : '||SQLERRM);
   END;

   BEGIN
      SELECT LTRIM(RTRIM(DESCRIPCION)), IDOBSERVA
        INTO CompletaLaFrase, EnQueLugar
        FROM OBSERVACION_SINIESTRO
       WHERE IDSINIESTRO = wIdSiniestro
         AND IDPOLIZA    = nIdPoliza
         AND IDOBSERVA   = (SELECT MAX(IDOBSERVA)
                              FROM OBSERVACION_SINIESTRO
                             WHERE IDSINIESTRO = wIdSiniestro
                               AND IDPOLIZA    = nIdPoliza);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cMsjError:=(' -20225 AURVAD NDF 2 Error al encontrar DESCRIPCION OBSERVACION_SINIESTRO AURVAD  '||SQLERRM);
      WHEN OTHERS THEN
         cMsjError:=(' -20225 AURVAD NDF 2 OTHERS al encontrar DESCRIPCION OBSERVACION_SINIESTRO AURVAD '||SQLERRM);
   END;

   BEGIN
      UPDATE OBSERVACION_SINIESTRO
         SET DESCRIPCION = CompletaLaFrase||' <--> '||' Pago Total. Ajuste Positivo para dejar Reserva en Cero. '
       WHERE IDSINIESTRO = wIdSiniestro
         AND IDPOLIZA    = nIdPoliza
         AND IDOBSERVA   = EnQueLugar;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cMsjError:=(' -20225 NDF 3 Error al encontrar DESCRIPCION OBSERVACION_SINIESTRO AURVAD '||SQLERRM);
      WHEN OTHERS THEN
         cMsjError:=(' -20225 OTHERS 3 Error al encontrar DESCRIPCION OBSERVACION_SINIESTRO AURVAD '||SQLERRM);
   END;

   BEGIN
      IF cIndColectivo = 'S' THEN
         UPDATE DETALLE_SINIESTRO_ASEG
            SET MONTO_RESERVADO_MONEDA = (MONTO_RESERVADO_MONEDA + wMntoPgo),
                MONTO_RESERVADO_LOCAL  = (MONTO_RESERVADO_LOCAL  + wMntoPgo)
          WHERE IDSINIESTRO = wIdSiniestro
            AND IDPOLIZA    = nIdPoliza
            AND IDDETSIN    = 1;
       ELSE
           UPDATE DETALLE_SINIESTRO S
              SET MONTO_RESERVADO_MONEDA = (S.MONTO_RESERVADO_MONEDA + wMntoPgo),
                  MONTO_RESERVADO_LOCAL  = (S.MONTO_RESERVADO_LOCAL  + wMntoPgo)
            WHERE IDSINIESTRO = wIdSiniestro
              AND IDPOLIZA    = nIdPoliza
              AND IDDETSIN    = 1;
       END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cMsjError:=(' -20225 NDF 4 Error al actualizar  DETALLE_SINIESTRO_ASEG AURVAD '||SQLERRM);
      WHEN OTHERS THEN
         cMsjError:=(' -20225 OTHERS 4 Error al actualizar  DETALLE_SINIESTRO_ASEG AURVAD '||SQLERRM);
   END;

    BEGIN
       UPDATE SINIESTRO
          SET MONTO_RESERVA_MONEDA = (MONTO_RESERVA_MONEDA + wMntoPgo),
              MONTO_RESERVA_LOCAL  = (MONTO_RESERVA_LOCAL  + wMntoPgo)
        WHERE IDSINIESTRO = wIdSiniestro
          AND IDPOLIZA    = nIdPoliza;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          cMsjError:=(' -20225 NDF 4 Error al actualizar  SINIESTRO DIRVAD '||SQLERRM);
       WHEN OTHERS THEN
          cMsjError:=(' -20225 OTHERS 4 Error al actualizar  SINIESTRO DIRVAD '||SQLERRM);
    END;

    IF cMsjError IS NULL THEN
       NULL;
    ELSE
       ROLLBACK;
    END IF;
END AURVAD;

PROCEDURE PAGO_SINIESTROS_MASIVO(nIdProcMasivo NUMBER) IS
cCodPlantilla       CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE;
cNumSiniRef         SINIESTRO.NumSiniRef%TYPE;
nIdSiniestro        SINIESTRO.IdSiniestro%TYPE;
nIDetPol            SINIESTRO.IDetPol%TYPE;
nIdPoliza           POLIZAS.IdPoliza%TYPE;
nCodCia             POLIZAS.CodCia%TYPE;
nCodEmpresa         POLIZAS.CodEmpresa%TYPE;
cCodMoneda          POLIZAS.Cod_Moneda%TYPE;
nTasaCambio         DETALLE_POLIZA.Tasa_Cambio%TYPE;
nCodAsegurado       ASEGURADO.Cod_Asegurado%TYPE;
--nCodCliente        CLIENTE_ASEG.CodCliente%TYPE; QUITAR LINEA
cCodCobert          COBERT_ACT_ASEG.CodCobert%TYPE := 'GMXA';
cCodTransac         COBERTURA_SINIESTRO.CodTransac%TYPE := 'PARVAD';
cCodCptoTransac     COBERTURA_SINIESTRO.CodCptoTransac%TYPE := 'PARVAD';
nNumAprobacion     APROBACIONES.Num_Aprobacion%TYPE;
nMontoLocal        APROBACIONES.Monto_Local%TYPE;
nMontoMoneda       APROBACIONES.Monto_Moneda%TYPE;
cNumFactura         VARCHAR2(45); --FACTURA_EXTERNA.NumFactExt%TYPE;
nIdFactura          FACTURA_EXTERNA.IdeFactExt%TYPE;
cTipoAprobacion     APROBACIONES.Tipo_Aprobacion%TYPE;
cNombreProveedor    BENEF_SIN.Nombre%TYPE;
nMtoPendPago        SINIESTRO.Monto_Pago_Moneda%TYPE;
nOrden              NUMBER(10) := 1;
nOrdenInc           NUMBER(10);
cUpdate             VARCHAR2(4000);
cMsjError           PROCESOS_MASIVOS_LOG.TxtError%TYPE := NULL;
cExisteDatPart      VARCHAR2(1);
cExisteCob          VARCHAR2(1);
nMontoPagar         NUMBER(28,2);
nMontoTotPago       NUMBER(28,2);
nMontoTotIVA        NUMBER(28,2);
nMontoTotISR        NUMBER(28,2);
nBenef              BENEF_SIN.Benef%TYPE;
cNombreBenef        BENEF_SIN.Nombre%TYPE;
cApellPatBenef      BENEF_SIN.Apellido_Paterno%TYPE;
cApellMatBenef      BENEF_SIN.Apellido_Materno%TYPE;
MontoDePago         NUMBER(28,2);
nSALDO_RESERVA      COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA%TYPE;
nSaldoRvaMoneda     COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA%TYPE;
nSaldoRvaLocal      COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA_LOCAL%TYPE;
nMtoReservadoMoneda COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
nMtoReservadoLocal  COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_LOCAL%TYPE;
TERMINAL            VARCHAR2(50);
USUSARIO            VARCHAR2(50);
IvaCorrecto         NUMBER(28,2);
IsrCorrecto         NUMBER(28,2);
cNombreAsegurado    PERSONA_NATURAL_JURIDICA.NOMBRE%TYPE;
cApePatAseg         PERSONA_NATURAL_JURIDICA.APELLIDO_PATERNO%TYPE;
cApeMatAseg         PERSONA_NATURAL_JURIDICA.APELLIDO_MATERNO%TYPE;
cTipoDocIdent       PERSONA_NATURAL_JURIDICA.TIPO_DOC_IDENTIFICACION%TYPE;--cTipoDocIdent
cNumDocIdent        PERSONA_NATURAL_JURIDICA.NUM_DOC_IDENTIFICACION%TYPE;--cNumDocIdent
nCodAsegCarga      ASEGURADO.COD_ASEGURADO%TYPE;   --nnCodAsegCarga
cNombreArchLogem    VARCHAR2(200);
SumAseg1            COBERT_ACT_ASEG.SUMAASEG_MONEDA%TYPE;
TotPagado           COBERTURA_SINIESTRO_ASEG.MONTO_PAGADO_MONEDA%TYPE;
nMontoRvaMoneda     COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
SumaAseguradoReal   COBERT_ACT_ASEG.SUMAASEG_MONEDA%TYPE;
nSumaAsegCobert     COBERT_ACT_ASEG.SUMAASEG_MONEDA%TYPE;
WNUM_ASISTENCIA     PROCESOS_MASIVOS_SEGUIMIENTO.NUM_ASISTENCIA%TYPE;
WRFC_HOSPITAL       PROCESOS_MASIVOS_SEGUIMIENTO.RFC_HOSPITAL%TYPE;
WRFC_ASISTENCIADORA PROCESOS_MASIVOS_SEGUIMIENTO.RFC_ASISTENCIADORA%TYPE;
WARCHIVO_LOGEM      PROCESOS_MASIVOS_SEGUIMIENTO.ARCHIVO_LOGEM%TYPE;
wOCURRIDO           COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
wPAGADOS            COBERTURA_SINIESTRO_ASEG.MONTO_PAGADO_MONEDA%TYPE;
----  Pago T ----  AEVS 16/03/2017
QueHago             COBERTURA_SINIESTRO_ASEG.Saldo_Reserva%TYPE;
PalAurvad           COBERTURA_SINIESTRO_ASEG.Saldo_Reserva%TYPE;
nMtoAproT           APROBACIONES.Monto_Local%TYPE;
nMtoResT            DETALLE_SINIESTRO.Monto_Reservado_Local%TYPE;
NosQueda            COBERT_ACT_ASEG.SUMAASEG_MONEDA%TYPE;
nNumMod             COBERTURA_SINIESTRO_ASEG.NUMMOD%TYPE;
cTipoPago           VARCHAR2(4);
Desc_Tpo_Pgo        VARCHAR2(40);
nIdDetSin           DETALLE_SINIESTRO.IDDETSIN%TYPE;
cFolioUUID          VARCHAR2(40);
cRFCProv            VARCHAR2(16);
cNombProv           VARCHAR2(100);
cRegFiscal          VARCHAR2(100);
nMtoHono            NUMBER(14,2);
nMtoHosp            NUMBER(14,2);
nMtoOtrosGtos       NUMBER(14,2);
nMtoDcto            NUMBER(14,2);
nMtoDeducible       NUMBER(14,2);
nMtoIva             NUMBER(14,2);
nMtoIsr             NUMBER(14,2);
nMtoRetIva          NUMBER(14,2);
nMtoRetImpCedular   NUMBER(14,2);
nMtoPagar           NUMBER(28,2);
cRFCBenef           VARCHAR2(16);
cNombProvBenef      VARCHAR2(100);
cNumAsist           VARCHAR2(15);
cNumUnicoPol        VARCHAR2(15);
nIdeFactExt         FACTURA_EXTERNA.IDEFACTEXT%TYPE;
nExiste             NUMBER;
nMtoDedPol          COBERT_ACT.DEDUCIBLE_MONEDA%TYPE;
nMtoTotPagCalc      NUMBER(28,2);
nMtoPagadoMoneda    NUMBER(28,2);
nMtoPagadoLocal     NUMBER(28,2);
nPorcConcepto       CATALOGO_DE_CONCEPTOS.PorcConcepto%TYPE;
nMontoConcepto      CATALOGO_DE_CONCEPTOS.MontoConcepto%TYPE;
cIndTipoConcepto    CATALOGO_DE_CONCEPTOS.IndTipoConcepto%TYPE;
nIndValida          VARCHAR2(1) := 'N';
nMtoBruto           NUMBER(28,2);
nMtoImpto           NUMBER(28,2);
nMtoIVACalc         NUMBER(28,2);
nPosInicio          NUMBER;
nPosFin             NUMBER;
cSeparador          VARCHAR2(1) := '|';
cIndActAseg         VARCHAR2(1) := 'N';
cCodCptoTransacDed  COBERTURA_SINIESTRO.CodCptoTransac%TYPE;
cIndFecEquiv       SUB_PROCESO.IndFecEquiv%TYPE;
cIndFecEquivPro    PROC_TAREA.IndFecEquiv%TYPE;
dFechaCamb         APROBACIONES.FECPAGO%TYPE;
dFechaCont         FECHA_CONTABLE_EQUIVALENTE.FECHACONTABLE%TYPE;
dFechaReal         FECHA_CONTABLE_EQUIVALENTE.FECHAREAL%TYPE;
cFechaNacimiento   varchar2(10);
ncuantos           NUMBER;
cST_RESOLUCIO      ADMON_RIESGO_SINIESTROS.ST_RESOLUCION%TYPE;
cTP_RESOLUCION     ADMON_RIESGO_SINIESTROS.TP_RESOLUCION%TYPE;
nDiasautpld        NUMBER;

CURSOR PAGO_Q  IS
   SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.OrdenDatoPart
     FROM CONFIG_PLANTILLAS_CAMPOS C
    WHERE C.CodPlantilla = cCodPlantilla
      AND C.CodEmpresa   = nCodEmpresa
      AND C.CodCia       = nCodCia
      AND C.NomTabla     = 'DATOS_PART_SINIESTROS'
      AND C.IndDatoPart  = 'S'
    ORDER BY OrdenDatoPart,OrdenCampo;

CURSOR EMI_Q IS
   SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
          NumDetUnico, RegDatosProc, TipoProceso,IndColectiva,
          NomArchivoCarga, IndRegValidado, IndArchValidado
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;

CURSOR FACTEXTSIN_Q IS
    SELECT IdSiniestro
      FROM FACTURA_EXTERNA
     WHERE IdeFactExt = nIdeFactExt;

CURSOR SINCOB_Q IS
    SELECT IdSiniestro
      FROM COBERTURA_SINIESTRO_ASEG
     WHERE Cod_Asegurado = nCodAsegurado;

CURSOR IMPTOS_Q  IS
   SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.OrdenDatoPart
     FROM CONFIG_PLANTILLAS_CAMPOS C
    WHERE C.CodPlantilla = cCodPlantilla
      AND C.CodEmpresa   = nCodEmpresa
      AND C.CodCia       = nCodCia
      AND C.NomTabla     = 'DATOS_PART_SINIESTROS'
      AND C.IndDatoPart  = 'S'
      AND C.ORDENCAMPO BETWEEN 16 AND 21
    ORDER BY OrdenDatoPart,OrdenCampo;

CURSOR GTOS_Q  IS
   SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.OrdenDatoPart
     FROM CONFIG_PLANTILLAS_CAMPOS C
    WHERE C.CodPlantilla = cCodPlantilla
      AND C.CodEmpresa   = nCodEmpresa
      AND C.CodCia       = nCodCia
      AND C.NomTabla     = 'DATOS_PART_SINIESTROS'
      AND C.IndDatoPart  = 'S'
      AND C.ORDENCAMPO BETWEEN 13 AND 15
    ORDER BY OrdenDatoPart,OrdenCampo;
BEGIN
   SELECT  USER ,USERENV('TERMINAL')                   ---  SIGUECARGA
     INTO  USUSARIO , TERMINAL
     FROM  SYS.DUAL;

   FOR X IN EMI_Q LOOP
      IF X.IndRegValidado = 'N' OR X.IndArchValidado = 'N' THEN
          nIndValida := 'S'; --- SOLO REALIZAR VALIDACIONES
      ELSE
        nIndValida := 'N';
      END IF;

      --IF nIndValida = 'S' THEN
      cMsjError := NULL;
      cTipoPago    := RTRIM(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,25,cSeparador)));

      nCodCia           := X.CodCia;
      nCodEmpresa       := X.CodEmpresa;
      --SE AGREGA CODIGO--
      cIndFecEquivPro := OC_PROC_TAREA.INDICA_FEC_EQUIVALENTE_PRO(6);
      cIndFecEquiv    := OC_SUB_PROCESO.INDICA_FEC_EQUIVALENTE_SUBPROC(6, 'APRSIN');
      dFechaCont      := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_CONTABLE(X.CodCia, X.CodEmpresa);
      dFechaReal      := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_REAL(X.CodCia, X.CodEmpresa);

      IF cIndFecEquivPro = 'S' THEN
         IF cIndFecEquiv = 'S' THEN
            dFechaCamb   := dFechaCont;
         ELSE
            dFechaCamb := dFechaReal;
         END IF;
      ELSE
         dFechaCamb := dFechaReal;
      END IF;

      IF cTipoPago = 'P'  THEN
          Desc_Tpo_Pgo := 'PAGO PARCIAL';
          cTipoAprobacion := 'P';
      ELSIF cTipoPago = 'T'  THEN
          Desc_Tpo_Pgo := 'PAGO TOTAL';
          cTipoAprobacion := 'T';
      END IF;

      nIdSiniestro := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,1,cSeparador));

      IF nIdSiniestro IS NULL THEN
        cMsjError := 'Error en LayOut: No Contiene Número de Siniestro, Favor de validar la información.';
        RAISE_APPLICATION_ERROR(-20225,'Error en LayOut: No Contiene Número de Siniestro, Favor de validar la información.');
      END IF;

      BEGIN
        SELECT IdPoliza,IDetPol,Cod_Moneda
          INTO nIdPoliza,nIDetPol,cCodMoneda
          FROM SINIESTRO
         WHERE IdSiniestro = nIdSiniestro;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
            cMsjError := 'No Es Posible Determinar El Siniestro Y Su Información De Póliza, Favor de validar la información.';
            RAISE_APPLICATION_ERROR(-20225,'No Es Posible Determinar El Siniestro Y Su Información De Póliza, Favor de validar la información.');
      END;

      cNumAsist    := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,2,cSeparador));

      cNumUnicoPol := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,3,cSeparador));

      IF OC_POLIZAS.EXISTE_POLIZA(X.CodCia, X.CodEmpresa, nIdPoliza) = 'S' THEN
          IF nIdSiniestro != 0 THEN
                nCodAsegurado    := TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,4,cSeparador)));

                nMtoDeducible     := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,17,cSeparador));

                IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(X.CodCia, nIdPoliza, nIDetPol, nCodAsegurado) = 'S' THEN
                    --COLECTIVO
                    BEGIN
                      SELECT IdDetSin
                        INTO nIdDetSin
                        FROM DETALLE_SINIESTRO_ASEG
                       WHERE IdSiniestro = nIdSiniestro;
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                         cMsjError := 'No Es Posible Determinar Detalle Del Siniestro '||nIdSiniestro||' Para Validar Cobertura, Favor de validar la información.';
                         RAISE_APPLICATION_ERROR(-20225,'No Es Posible Determinar Detalle Del Siniestro '||nIdSiniestro||' Para Validar Cobertura, Favor de validar la información.');
                    END;
                    BEGIN
                        SELECT DISTINCT CodCobert
                          INTO cCodCobert
                          FROM COBERTURA_SINIESTRO_ASEG
                         WHERE IdSiniestro  = nIdSiniestro
                           AND IdDetSin     = nIdDetSin
                           AND IdPoliza     = nIdPoliza
                           AND Cod_Asegurado = nCodAsegurado;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            cMsjError := 'No Es Posible Determinar Una Cobertura Para El Siniestro, Favor de validar la información.';
                            RAISE_APPLICATION_ERROR(-20225,'No Es Posible Determinar Una Cobertura Para El Siniestro, Favor de validar la información.');
                        WHEN TOO_MANY_ROWS THEN
                            cMsjError := 'Existe mas de uan cobertura para el siniestro. Favor de validar la información..';
                            RAISE_APPLICATION_ERROR(-20225,'Existe mas de uan cobertura para el siniestro, Favor de validar la información.');
                    END;
                    IF OC_COBERTURA_SINIESTRO_ASEG.EXISTE_COBERTURA (nIdSiniestro, nIdPoliza, nIdDetSin, nCodAsegurado,
                                                                        cCodCobert) = 'N' THEN
                        cMsjError := 'No Existe La Cobertura Para El Siniestro Asegurado, Favor de validar la información.';
                        RAISE_APPLICATION_ERROR(-20225,'No Existe La Cobertura Para El Siniestro Asegurado, Favor de validar la información.');
                    ELSE
                        --BUSCA SALDO DE LA COBERTURA
                        OC_COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA(nIdSiniestro, nIdPoliza, nIdDetSin, nCodAsegurado,
                                                                    cCodCobert, nSaldoRvaMoneda, nSaldoRvaLocal);
                        --BUSCA MONTO RESERVA CONSTITUIDA
                        OC_COBERTURA_SINIESTRO_ASEG.MONTO_RESERVA(nIdSiniestro, nIdPoliza, nIdDetSin, nCodAsegurado ,
                                                                    cCodCobert, nMtoReservadoMoneda, nMtoReservadoLocal);
                        --BUSCA MONTO SUMA ASEGURADA DE LA COBERTURA
                        nSumaAsegCobert := OC_COBERT_ACT_ASEG.SUMA_ASEGURADA(nCodCia, nIdPoliza, nIDetPol,
                                                                                nCodAsegurado, cCodCobert);
                        ---BUSCA DEDUCIBLE
                        nMtoDedPol := OC_COBERT_ACT_ASEG.DEDUCIBLE(X.CodCia, nIdPoliza, nIDetPol,
                                                                        nCodAsegurado, cCodCobert);
                        ---BUSCA MONTO PAGADO
                        OC_COBERTURA_SINIESTRO_ASEG.MONTO_PAGADO(nIdSiniestro, nIdPoliza, nIdDetSin, nCodAsegurado,
                                                                    cCodCobert, nMtoPagadoMoneda, nMtoPagadoLocal);
                    END IF;
                ELSE
                    --INDIVIDUAL
                    BEGIN
                      SELECT IdDetSin
                        INTO nIdDetSin
                        FROM DETALLE_SINIESTRO
                       WHERE IdSiniestro = nIdSiniestro;
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                         cMsjError := 'No Es Posible Determinar Detalle Del Siniestro '||nIdSiniestro||' Para Validar Cobertura, Favor de validar la información.';
                         RAISE_APPLICATION_ERROR(-20225,'No Es Posible Determinar Detalle Del Siniestro '||nIdSiniestro||' Para Validar Cobertura, Favor de validar la información.');
                    END;
                    BEGIN
                        SELECT DISTINCT CodCobert
                          INTO cCodCobert
                          FROM COBERTURA_SINIESTRO_ASEG
                         WHERE IdSiniestro  = nIdSiniestro
                           AND IdDetSin     = nIdDetSin
                           AND IdPoliza     = nIdPoliza;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            cMsjError := 'No Es Posible Determinar Una Cobertura Para El Siniestro, Favor de validar la información.';
                            RAISE_APPLICATION_ERROR(-20225,'No Es Posible Determinar Una Cobertura Para El Siniestro, Favor de validar la información.');
                        WHEN TOO_MANY_ROWS THEN
                            cMsjError := 'Existe mas de uan cobertura para el siniestro. Favor de validar la información..';
                            RAISE_APPLICATION_ERROR(-20225,'Existe mas de uan cobertura para el siniestro, Favor de validar la información.');
                    END;
                    IF OC_COBERTURA_SINIESTRO.EXISTE_COBERTURA (nIdSiniestro, nIdPoliza, nIdDetSin, cCodCobert) = 'N' THEN
                        cMsjError := 'No Existe La Cobertura Para El Siniestro, Favor de validar la información.';
                        RAISE_APPLICATION_ERROR(-20225,'No Existe La Cobertura Para El Siniestro, Favor de validar la información.');
                    ELSE
                        --BUSCA SALDO DE LA COBERTURA
                        OC_COBERTURA_SINIESTRO.SALDO_RESERVA(nIdSiniestro, nIdPoliza, nIdDetSin, cCodCobert,
                                                                nSaldoRvaMoneda, nSaldoRvaLocal);
                        --BUSCA MONTO RESERVA CONSTITUIDA
                        OC_COBERTURA_SINIESTRO.MONTO_RESERVA(nIdSiniestro, nIdPoliza, nIdDetSin, cCodCobert,
                                                                nMtoReservadoMoneda, nMtoReservadoLocal);
                        --BUSCA MONTO SUMA ASEGURADA DE LA COBERTURA
                        nSumaAsegCobert := OC_COBERT_ACT.SUMA_ASEGURADA(nCodCia, nIdPoliza, nIDetPol,
                                                                            cCodCobert);
                        ---BUSCA DEDUCIBLE
                        nMtoDedPol := OC_COBERT_ACT.DEDUCIBLE(X.CodCia, nIdPoliza, nIDetPol,
                                                                  cCodCobert);
                        ---BUSCA MONTO PAGADO
                        OC_COBERTURA_SINIESTRO.MONTO_PAGADO(nIdSiniestro, nIdPoliza, nIdDetSin, cCodCobert,
                                                                nMtoPagadoMoneda, nMtoPagadoLocal);
                    END IF;
                END IF;
                IF nSaldoRvaMoneda <= 0 THEN
                   cMsjError := 'El Saldo Pendiente de Pago es menor o igual a Cero, Favor de validar la información.';
                   RAISE_APPLICATION_ERROR(-20225,'El Saldo Pendiente de Pago es menor o igual a Cero, Favor de validar la información.');
                END IF;
                IF nMtoDeducible > nMtoDedPol THEN
                    cMsjError := 'Deducible Cargado Es Mayor Al Deducible De La Poliza.';
                    RAISE_APPLICATION_ERROR(-20225,'Deducible Cargado Es Mayor Al Deducible De La Poliza.');
                END IF;

                cRFCProv          := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,10,cSeparador));
                cNombProv         := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,11,cSeparador));
                cRegFiscal        := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,12,cSeparador));
------- JMMD20190927 VALIDACION DE REGISTROS EN SAT
                dbms_output.put_line('jmmd pruebas sat cRFCProv : '||cRFCProv||' COMPAÑIA : '||X.CodCia);
                IF SICAS_OC.OC_PROVEEDORES_SAT.ES_PROVEEDOR_SAT_DEFINITIVO(X.CodCia, cRFCProv) = 'S' THEN
                    dbms_output.put_line('jmmd pruebas sat es proveedor sat definitivo : '||cRFCProv);
                    cMsjError := 'Persona encontrada en an el archivo de SAT DEFINITIVOS.';
                    RAISE_APPLICATION_ERROR(-20225,'Persona encontrada en el archivo de SAT DEFINITIVOS, requiere de autorizacion.');
                END IF;

                IF SICAS_OC.OC_PROVEEDORES_SAT.ES_PROVEEDOR_SAT_PRESUNTOS(X.CodCia, cRFCProv) = 'S' THEN
                    dbms_output.put_line('jmmd pruebas sat es proveedor sat presuntos : '||cRFCProv);
                    cMsjError := 'Persona encontrada en an el archivo de SAT PRESUNTOS.';
                    RAISE_APPLICATION_ERROR(-20225,'Persona encontrada en el archivo de SAT PRESUNTOS, requiere de autorizacion.');
                END IF;
-------
------- JMMD20191025 VALIDACION DE REGISTROS EN PLD
----------
                ---VALIDACION RFC BENEFICIARIO
                cRFCBenef         := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,23,cSeparador));
                cNombProvBenef    := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,24,cSeparador));

                IF LENGTH(REPLACE(LTRIM(RTRIM(REPLACE(cRFCBenef,' '))),'-')) NOT between 12 and 13 THEN
                    cMsjError := ' RFC De Beneficiario De Pago '||cRFCBenef||' No Cumple Con La Longitud Establecida De 13 Caracteres, Por Favor Valide';
                    RAISE_APPLICATION_ERROR(-20225,'RFC De Beneficiario De Pago '||cRFCBenef||' No Cumple Con La Longitud Establecida De 13 Caracteres, Por Favor Valide');
                END IF;
----------
                 BEGIN
                  SELECT DESCVALLST
                    INTO nDiasautpld
                    FROM VALORES_DE_LISTAS
                   WHERE CODLISTA = 'DIASAUTPLD'
                     AND CODVALOR = 'ODC';
                EXCEPTION
                    WHEN OTHERS THEN
                      nDiasautpld := 1;
                END;
----------
                cFechaNacimiento := CALCULA_FECHA_NACIMIENTO(cRFCProv);
                dbms_output.put_line('jmmd pruebas PLD cRFCBenef : '||cRFCBenef||' NOMBRE : '||cNombProvBenef);
                IF OC_CAT_QEQ.ES_QEQ_SINIESTRO('RFC', cRFCBenef, cNombProvBenef, cFechaNacimiento ) = 'S' THEN
-----------------
                   BEGIN
                    SELECT ST_RESOLUCION, TP_RESOLUCION
                      INTO cST_RESOLUCIO, cTP_RESOLUCION
                      FROM ADMON_RIESGO_SINIESTROS
                     WHERE TIPO_DOC_IDENTIFICACION = 'RFC'
                       AND NUM_DOC_IDENTIFICACION = cRFCBenef
                       AND NOMBRE_BENEFICIARIO = cNombProvBenef
                        AND TRUNC(FE_ESTATUS) >= TRUNC(SYSDATE - nDiasautpld)
----------
                        AND NUMSINIESTRO = nIdSiniestro ;
----------                        
                   EXCEPTION
                     WHEN NO_DATA_FOUND THEN
-----------------
                     dbms_output.put_line('jmmd pruebas PLD cRFCBenef : '||cRFCBenef||' no encontrado en admon riesgo siniestros recientemente : '||cNombProvBenef);
                       OC_ADMON_RIESGO_SINIESTROS.INSERTA(
                              X.CodCia,
                              nCodEmpresa,
                              1 ,
                              nIdPoliza  ,
                              'N/A' ,
                              nCodAsegurado ,
                              nIdSiniestro ,
                              'QEQ'  ,
                              'RFC'  ,
                              cRFCBenef  ,
                              cNombProvBenef  ,
                              'PEND'  ,
                              TRUNC(SYSDATE)  ,
                              ''  ,
                              'LA PERSONA ESTA EN PLD'  ,
                              TRUNC(SYSDATE)  ,
                              USUSARIO );
                        dbms_output.put_line('jmmd1 pruebas PLD existe en PLD :Persona encontrada en an el Catalogo de quien es quien. ');
                        cMsjError := 'Persona encontrada en an el Catalogo de quien es quien.';
                        RAISE_APPLICATION_ERROR(-20225,'Persona encontrada en el archivo de quien es quien, requiere de autorizacion.');
                     WHEN OTHERS THEN
                      CONTINUE;
                    END;
---------------
                    SELECT COUNT(*)
                      INTO ncuantos
                      FROM ADMON_RIESGO_SINIESTROS
                     WHERE TIPO_DOC_IDENTIFICACION = 'RFC'
                       AND NUM_DOC_IDENTIFICACION = cRFCBenef
                       AND NOMBRE_BENEFICIARIO = cNombProvBenef
                       AND  ST_RESOLUCION != 'APRO'
---------- JMMD24062020
                       AND NUMSINIESTRO = nIdSiniestro ;
---------- JMMD24062020                              

                    IF ncuantos > 0 THEN
                       cST_RESOLUCIO := 'PEND';
                    ELSE
                       cST_RESOLUCIO := NULL;
                    END IF;

                   IF cST_RESOLUCIO = 'PEND' THEN
                        dbms_output.put_line('jmmd2 pruebas PLD existe en PLD : Persona encontrada en an el Catalogo de quien es quien.');
                        cMsjError := 'Persona encontrada en an el Catalogo de quien es quien.';
                        RAISE_APPLICATION_ERROR(-20225,'Persona encontrada en el archivo de quien es quien, requiere de autorizacion.');
                   END IF;

---------------
                END IF;
-------
                --- SIN VALIDACIONES
                nMtoHono          := TO_NUMBER(LTRIM(REPLACE(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,13,cSeparador),',')));
                nMtoHosp          := TO_NUMBER(LTRIM(REPLACE(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,14,cSeparador),',')));
                nMtoOtrosGtos     := TO_NUMBER(LTRIM(REPLACE(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,15,cSeparador),',')));
                nMtoDcto          := TO_NUMBER(LTRIM(REPLACE(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,16,cSeparador),',')));

                nMtoIva           := TO_NUMBER(LTRIM(REPLACE(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,18,cSeparador),',')));
                nMtoIsr           := TO_NUMBER(LTRIM(REPLACE(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,19,cSeparador),',')));
                nMtoRetIva        := TO_NUMBER(LTRIM(REPLACE(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,20,cSeparador),',')));
                nMtoRetImpCedular := TO_NUMBER(LTRIM(REPLACE(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,21,cSeparador),',')));
                nMtoPagar         := TO_NUMBER(LTRIM(REPLACE(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,22,cSeparador),',')));

                nMtoTotPagCalc := nMtoHono + nMtoHosp + nMtoOtrosGtos + nMtoIva - nMtoDcto - nMtoDeducible - nMtoIsr - nMtoRetIva - nMtoRetImpCedular;

                IF nMtoTotPagCalc <> nMtoPagar THEN
                   cMsjError := 'El monto a pagar no es igual al calculado con la siguiente formula Gtos Honorarios + Gtos Hospitalarios + Otros Gtos + IVA - Descuento - Deducible - Retencion ISR - Retencion IVA - Retencion Cedular';
                   RAISE_APPLICATION_ERROR(-20225,'El monto a pagar no es igual al calculado con la siguiente formula Gtos Honorarios + Gtos Hospitalarios + Otros Gtos + IVA - Descuento - Deducible - Retencion ISR - Retencion IVA - Retencion Cedular');
                ELSE
                   IF nMtoPagar > nMtoReservadoMoneda AND cTipoPago = 'P' THEN --VALIDA QUE NO EXCEDA LO RESERVADO, SI SI VALIDA QUE NO EXCEDA LA RESERVA + SALDO DE COBERTURA
                       IF nMtoPagar > (nMtoReservadoMoneda + nSaldoRvaMoneda) THEN
                           cMsjError := 'El Monto A Pagar Excede El Monto Reservado Y Excede El Monto Reservado  + Saldo De Cobertura, Los Numeros De Siniestros Son: ';
                           FOR J IN SINCOB_Q LOOP
                               cMsjError := cMsjError||J.IdSiniestro||',';
                           END LOOP;
                           RAISE_APPLICATION_ERROR(-20225,'El Monto A Pagar Excede El Monto Reservado Y Excede El Monto Reservado  + Saldo De Cobertura, Los Numeros De Siniestros Son: '||cMsjError);
                       END IF;
                   END IF;
                END IF;

                --VALIDA IMPUESTOS
                IF nMtoIva <> 0 THEN
                    --IVA
                    OC_CATALOGO_DE_CONCEPTOS.TIPO_CONCEPTO(X.CodCia, 'IVASIN', cIndTipoConcepto, nPorcConcepto, nMontoConcepto);
                    IF nPorcConcepto = 0 THEN
                        cMsjError := 'Porcentaje De Iva Es Cero En La Configuracion Del Concepto, Por Favor Valide';
                        RAISE_APPLICATION_ERROR(-20225,'Porcentaje De Iva Es Cero En La Configuracion Del Concepto, Por Favor Valide');
                    ELSE
                        nMtoIVACalc := (nMtoHono + nMtoHosp + nMtoOtrosGtos) * (nPorcConcepto / 100);
                        nMtoBruto := nMtoHono + nMtoHosp + nMtoOtrosGtos;
                        IF ABS((nMtoIva - nMtoIVACalc)) = 0.01 THEN --- SI LA DIFERENCIA ES DE UN CENTAVO ENTONCES SE RESTA LA DIFERENCIA AL IVA DEL ARCHIVO Y SE SUMA AL SUBTOTAL

                            UPDATE PROCESOS_MASIVOS
                               SET RegDatosProc = REPLACE(X.RegDatosProc,TO_CHAR(nMtoIva),TO_CHAR(nMtoIva - 0.01))
                             WHERE IdProcMasivo = nIdProcMasivo;

                            UPDATE PROCESOS_MASIVOS
                               SET RegDatosProc = REPLACE(X.RegDatosProc,TO_CHAR(nMtoHosp),TO_CHAR(nMtoHosp + 0.01))
                             WHERE IdProcMasivo = nIdProcMasivo;
                        ELSE
                            IF nMtoIva > nMtoIVACalc THEN
                                cMsjError := 'El Monto De Iva Declarado En El Archivo Excede Al Porcentaje De Iva Configurado En El Sistema, Por Favor Valide';
                                RAISE_APPLICATION_ERROR(-20225,'El Monto De Iva Declarado En El Archivo Excede Al Porcentaje De Iva Configurado En El Sistema, Por Favor Valide');
                            END IF;
                        END IF;
                    END IF;
                ELSIF nMtoIsr <> 0 THEN
                    --ISR
                        OC_CATALOGO_DE_CONCEPTOS.TIPO_CONCEPTO(X.CodCia, 'ISRSIN', cIndTipoConcepto, nPorcConcepto, nMontoConcepto);
                    IF nPorcConcepto = 0 THEN
                        cMsjError := 'Porcentaje De ISR Es Cero En La Configuración Del Concepto, Por Favor Valide';
                        RAISE_APPLICATION_ERROR(-20225,'Porcentaje De ISR Es Cero En La Configuración Del Concepto, Por Favor Valide');
                    ELSE
                        IF ROUND((nMtoHono + nMtoHosp + nMtoOtrosGtos) * (nPorcConcepto / 100),2) < nMtoIsr THEN
                            cMsjError := 'El Monto De ISR Registrado En El Archivo Excede El monto Del Gasto Mas El Porcentaje De ISR Configurado, Por Favor Valide';
                            RAISE_APPLICATION_ERROR(-20225,'El Monto De ISR Registrado En El Archivo Excede El monto Del Gasto Mas El Porcentaje De ISR Configurado, Por Favor Valide');
                        END IF;
                    END IF;
                ELSIF nMtoRetImpCedular <> 0 THEN
                    --IMPUESTO CEDULAR O LOCAL
                    OC_CATALOGO_DE_CONCEPTOS.TIPO_CONCEPTO(X.CodCia, 'IMPLOC', cIndTipoConcepto, nPorcConcepto, nMontoConcepto);
                    IF nPorcConcepto = 0 THEN
                        cMsjError := 'Porcentaje De Impuesto Local (Cedular) Es Cero En La Configuración Del Concepto, Por Favor Valide';
                        RAISE_APPLICATION_ERROR(-20225,'Porcentaje De Impuesto Local (Cedular) Es Cero En La Configuración Del Concepto, Por Favor Valide');
                    ELSE
                        IF (nMtoHono + nMtoHosp + nMtoOtrosGtos) * (nPorcConcepto / 100) <> nMtoRetImpCedular THEN
                            cMsjError := 'El Monto Del Gasto Mas El Porcentaje De Isr Configurado Es Diferente Al Monto De Iva Registrado En El Archivo, Por Favor Valide';
                            RAISE_APPLICATION_ERROR(-20225,'El Monto Del Gasto Mas El Porcentaje De Isr Configurado Es Diferente Al Monto De Iva Registrado En El Archivo, Por Favor Valide');
                        END IF;
                    END IF;
                ELSIF nMtoRetIva <> 0 THEN
                    OC_CATALOGO_DE_CONCEPTOS.TIPO_CONCEPTO(X.CodCia, 'RETIVA', cIndTipoConcepto, nPorcConcepto, nMontoConcepto);
                    IF nMtoIva <> 0 THEN
                        IF nPorcConcepto = 0 THEN
                            cMsjError := 'Porcentaje De Retención De IVA Es Cero En La Configuración Del Concepto, Por Favor Valide';
                            RAISE_APPLICATION_ERROR(-20225,'Porcentaje De Retención De IVA Es Cero En La Configuración Del Concepto, Por Favor Valide');
                        ELSE
                            IF (nMtoHono + nMtoHosp + nMtoOtrosGtos) * (nPorcConcepto / 100) <> nMtoRetIva THEN
                                cMsjError := 'El Monto De Retencion De Iva No Es Igual Al Monto Registrado En El Archivo, Por Favor Valide';
                                RAISE_APPLICATION_ERROR(-20225,'El Monto De Retencion De Iva No Es Igual Al Monto Registrado En El Archivo, Por Favor Valide');
                            END IF;
                        END IF;
                    ELSE
                        cMsjError := 'No Es Posible Validar La Retencion De Iva Debido A Que El Monto De Iva Es Cero, Por Favor Valide';
                        RAISE_APPLICATION_ERROR(-20225,'No Es Posible Validar La Retencion De Iva Debido A Que El Monto De Iva Es Cero, Por Favor Valide');
                    END IF;
                END IF;

                ---TRANSACCION
                IF OC_COBERTURAS_DE_SEGUROS.VALIDA_BASICA (X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, cCodCobert) = 'S' THEN
                   cCodTransac        := 'PARVBA';
                   cCodCptoTransac    := 'PARVBA';
                   cCodCptoTransacDed := 'DEDUBA'; --- SE AGREGA PARA NO AFECTAR EL CONCEPTO AL CREAR LA APROBACION DE PAGO
                ELSE
                   cCodTransac        := 'PARVAD';
                   cCodCptoTransac    := 'PARVAD';
                   cCodCptoTransacDed := 'DEDUAD'; --- SE AGREGA PARA NO AFECTAR EL CONCEPTO AL CREAR LA APROBACION DE PAGO
                END IF;

                --VALIDA PERSONA NATURAL JURIDICA
                cIndActAseg       := RTRIM(LTRIM(NVL(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,28,cSeparador),'N')));
                cNombreAsegurado  := RTRIM(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,5,cSeparador)));
                cApePatAseg       := RTRIM(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,6,cSeparador)));
                cApeMatAseg       := RTRIM(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,7,cSeparador)));
                ----------------------------- SI cIndActAseg = 'S' ENTONCES SE ACTUALIZA PERSONA NATURAL JURIDICA
                IF cIndActAseg = 'N' THEN
                    BEGIN
                        SELECT pa.tipo_doc_identificacion , pa.num_doc_identificacion,A23.COD_ASEGURADO
                          INTO cTipoDocIdent , cNumDocIdent, nCodAsegCarga
                          FROM PERSONA_NATURAL_JURIDICA  pa,ASEGURADO A23
                         WHERE pa.nombre LIKE  '%'||cNombreAsegurado||'%'          ---'JORGE OSWALDO'
                           AND pa.apellido_paterno   LIKE  '%'||cApePatAseg||'%' ---'MORALES'
                           AND pa.apellido_materno   LIKE  '%'||cApeMatAseg||'%' ---'MENES'
                           AND pa.tipo_doc_identificacion = A23.TIPO_DOC_IDENTIFICACION
                           AND pa.num_doc_identificacion  = A23.NUM_DOC_IDENTIFICACION
                           AND A23.COD_ASEGURADO = nCodAsegurado;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            cMsjError := 'No Es Posible Determinar Persona Natural Juridica Con El Nombre y Código de Asegurado De Carga';
                            RAISE_APPLICATION_ERROR(-20225,'No Es Posible Determinar Persona Natural Juridica Con El Nombre y Código de Asegurado De Carga');
                        WHEN TOO_MANY_ROWS THEN
                            cMsjError := 'Existe Mas De Un Registros Con El Nombre y Codigo de Asegurado En Persona Natural Juridica';
                            RAISE_APPLICATION_ERROR(-20225,'Existe Mas De Un Registros Con El Nombre y Codigo de Asegurado En Persona Natural Juridica');
                        WHEN OTHERS THEN
                            cMsjError := 'Error Al Obtener La Persona Natural Jurídica Por El Nombre Cargado, Por Favor Valide La Información';
                            RAISE_APPLICATION_ERROR(-20225,'Error Al Obtener La Persona Natural Jurídica Por El Nombre Cargado, Por Favor Valide La Información');
                    END;

                    --VALIDA DIFERENCIA ENTRE ASEGURADO DE CARGA Y ASEGURADO DEL SISTEMA
                    IF nCodAsegCarga != nCodAsegurado THEN
                       cMsjError := ' El Nombre de Asegurado cargado No concuerda con el Asegurado del Siniestro   ( Codigo de Carga '||nCodAsegCarga||'  Codigo del Siniestro  '||nCodAsegurado||' )  ';
                       RAISE_APPLICATION_ERROR(-20225,'El Nombre de Asegurado cargado No concuerda con el Asegurado del Siniestro   ( Codigo de Carga '||nCodAsegCarga||'  Codigo del Siniestro  '||nCodAsegurado||' )  ');
                    END IF;
                ELSE
                    --- SE ACTUALIZAN DATOS DE PERSONA NATURAL JURIDICA
                    SELECT A23.tipo_doc_identificacion , A23.num_doc_identificacion
                      INTO cTipoDocIdent , cNumDocIdent
                      FROM ASEGURADO A23
                     WHERE A23.COD_ASEGURADO = nCodAsegurado;

                    UPDATE PERSONA_NATURAL_JURIDICA
                       SET nombre           = cNombreAsegurado,          ---'JORGE OSWALDO'
                           apellido_paterno = cApePatAseg, ---'MORALES'
                           apellido_materno = cApeMatAseg
                     WHERE TIPO_DOC_IDENTIFICACION  = cTipoDocIdent
                       AND NUM_DOC_IDENTIFICACION   = cNumDocIdent;
                END IF;

                --VALIDACION FOLIO FACTURA
                cNumFactura       := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,8,cSeparador));
                cFolioUUID        := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,9,cSeparador));

                BEGIN
                    SELECT IdeFactExt
                      INTO nIdeFactExt
                      FROM FACTURA_EXTERNA
                     WHERE UUID = cFolioUUID;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nIdeFactExt := 0;
                    WHEN TOO_MANY_ROWS THEN
                        cMsjError := 'Existe más de un registro para el UUID '||cFolioUUID||', por favor valide. Los numeros de siniestros son: ';
                        FOR J IN FACTEXTSIN_Q LOOP
                            cMsjError := cMsjError||J.IdSiniestro||',';
                        END LOOP;
                        RAISE_APPLICATION_ERROR(-20225,'Existe más de un registro para el UUID '||cFolioUUID||', por favor valide. Los numeros de siniestros son: ');
                        -- PARA EL LOG DEBERA TRAER TODOS LOS IDSINEISTRO DE LA TABLA FACTURA_EXTERNA SI ES QUE APLICA------------------------------
                END;

                ---VALIDACION RFC BENEFICIARIO
                cRFCBenef         := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,23,cSeparador));
                cNombProvBenef    := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,24,cSeparador));

                IF LENGTH(REPLACE(LTRIM(RTRIM(REPLACE(cRFCBenef,' '))),'-')) NOT between 12 and 13 THEN
                    cMsjError := ' RFC De Beneficiario De Pago '||cRFCBenef||' No Cumple Con La Longitud Establecida De 13 Caracteres, Por Favor Valide';
                    RAISE_APPLICATION_ERROR(-20225,'RFC De Beneficiario De Pago '||cRFCBenef||' No Cumple Con La Longitud Establecida De 13 Caracteres, Por Favor Valide');
                END IF;
                ---VALIDACION RFC Y REGIMENES FISCALES

                nTasaCambio       := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
                cCodPlantilla     := OC_CONFIG_PLANTILLAS_PLANCOB.CODIGO_PLANTILLA(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, X.TipoProceso);

                BEGIN
                 INSERT INTO DATOS_PART_SINIESTROS
                      (CodCia, IdSiniestro, IdPoliza, FecSts,STSDATPART,FECPROCED,IDPROCMASIVO)
                  VALUES(X.CodCia, nIdSiniestro, nIdPoliza, TRUNC(dFechaCamb),'PAGSIN',SYSDATE,nIdProcMasivo);
                EXCEPTION WHEN OTHERS THEN
                   cMsjError := 'Error: '||SQLERRM;
                   RAISE_APPLICATION_ERROR(-20225,'Error en Insert DATOS_PART_SINIESTROS: '||SQLERRM);
                END;

                FOR I IN PAGO_Q LOOP
                   nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla, X.CodCia, X.CodEmpresa, I.OrdenProceso) + nOrden;
                   cUpdate   := 'UPDATE '||'DATOS_PART_SINIESTROS' || ' ' ||
                                'SET'||' ' || 'CAMPO' || I.OrdenDatoPart || '=' || '''' ||
                                 LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenInc,cSeparador)) || '''' || ' ' ||
                                'WHERE IdPoliza   = ' || nIdPoliza    ||' '||
                                'AND IdSiniestro  = ' || nIdSiniestro ||' '||
                                'AND CodCia       = ' || X.CodCia     ||' '||
                                'AND IdProcMasivo = ' || nIdProcMasivo
                                ;
                   OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate);
                   nOrden := nOrden + 1;
                END LOOP;
          ELSE
            cMsjError := 'NO Existe la Estimación del Siniestro No. ' || nIdSiniestro;
            RAISE_APPLICATION_ERROR(-20225,'Error No se encuentra el Numero del Siniestro: ');
          END IF;
      ELSE
         cMsjError := 'No Existe la Póliza No. ' || X.NumPolUnico;
         RAISE_APPLICATION_ERROR(-20225,'No Existe la Póliza No. ' || X.NumPolUnico);
      END IF;
      /*+++++++++++++++++++++++++++ CONCLUYEN VALIDACIONES +++++++++++++++++++++++++++++++*/
      IF cMsjError IS NULL AND  nIndValida = 'S' THEN
        UPDATE PROCESOS_MASIVOS
           SET IndRegValidado = 'S'
         WHERE IdProcMasivo = nIdProcMasivo;
      ELSIF cMsjError IS NULL AND  nIndValida = 'N' THEN
            IF nIdeFactExt = 0 THEN
                --INSERTA EN FACTURA EXTERNA Y EN DETALLE_FACTURA_EXTERNA, INSERTAMOS EN CERO Y ACTUALIZAMOS CUANDO SE CONCLUYAN LAS VALIDACIONES
                nIdeFactExt := OC_FACTURA_EXTERNA.INSERTAR_FACTURA(X.CodCia, cNumFactura, TRUNC(SYSDATE), cTipoDocIdent,
                                                                      cNumDocIdent, 0, 'FACTURA GENERADA POR CARGA MASIVA DE PAGOS',
                                                                      nIdSiniestro  , 0, 0, cFolioUUID,NULL);
                OC_DETALLE_FACTURA_EXTERNA.INSERTA_DETALLE(nIdeFactExt, cNumFactura, cRFCProv, cNombProv,
                                                           cRegFiscal, cRFCBenef, cNombProvBenef, nMtoHono,
                                                           nMtoHosp , nMtoOtrosGtos , nMtoDcto , nMtoDeducible ,
                                                           nMtoIva , nMtoIsr , nMtoRetIva , nMtoRetImpCedular ,
                                                           nMtoPagar);
            ELSE
                BEGIN
                    SELECT 1
                      INTO nExiste
                      FROM DETALLE_FACTURA_EXTERNA
                     WHERE IdeFactExt = nIdeFactExt
                       AND NumFactExt = cNumFactura;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        nExiste := 0;
                    WHEN TOO_MANY_ROWS THEN
                        cMsjError := 'Existe más de un Folio de Factura '||cNumFactura||', por favor valide';
                        -- PARA EL LOG DEBERA TRAER TODOS LOS IDSINEISTRO DE LA TABLA FACTURA_EXTERNA SI ES QUE APLICA-----------------------------
                END;
                IF nExiste = 0 THEN
                    OC_DETALLE_FACTURA_EXTERNA.INSERTA_DETALLE(nIdeFactExt, cNumFactura, cRFCProv, cNombProv,
                                                               cRegFiscal, cRFCBenef, cNombProvBenef, nMtoHono,
                                                               nMtoHosp , nMtoOtrosGtos , nMtoDcto , nMtoDeducible ,
                                                               nMtoIva , nMtoIsr , nMtoRetIva , nMtoRetImpCedular ,
                                                               nMtoPagar);

                    ---ACTUALIZA FACTURA EXTERNA CON SUMATORIA DE DETALLES
                    OC_FACTURA_EXTERNA.ACTUALIZA_MONTOS(X.CodCia, cFolioUUID, nIdeFactExt) ;
                ELSE
                    cMsjError := 'Ya existe un registro con el UUID '||cFolioUUID||', por favor valide';
                    RAISE_APPLICATION_ERROR(-20225,'Ya existe un registro con el UUID '||cFolioUUID||', por favor valide');
                -- PARA EL LOG DEBERA TRAER TODOS LOS IDSINEISTRO DE LA TABLA FACTURA_EXTERNA SI ES QUE APLICA------------------------------
                END IF;
            END IF;

            nMtoPendPago := nMtoReservadoMoneda - nMtoPagadoMoneda;
            --nMontoLocal := nMtoPagar; --+ nMtoIva;
            nMontoLocal := nMtoHono + nMtoHosp + nMtoOtrosGtos  - nMtoDcto - nMtoDeducible ;
            IF nSumaAsegCobert > 0 THEN
                  ----------------------------- AJUSTES SI EL PAGO ES TOTAL ----------------------------------------------
                IF cTipoPago = 'T' THEN
                    IF nMtoPagadoMoneda IS NULL THEN nMtoPagadoMoneda:= 0; END IF;
                    nMtoReservadoMoneda := 0;

                    IF nSumaAsegCobert > 0 THEN
                       SumaAseguradoReal := (nSumaAsegCobert - (nMtoPendPago + nMtoPagadoMoneda));
                    END IF;

                    QueHago := ( nMtoPendPago - nMontoLocal);
                    IF    QueHago = 0  THEN
                       NULL;
                    ELSIF QueHago > 0  THEN
                       OC_PROCESOS_MASIVOS.DIRVAD(nIdSiniestro,QueHago,cCodCobert);
                    ELSIF QueHago < 0  THEN
                       PalAurvad := ABS(QueHago) ;
                       OC_PROCESOS_MASIVOS.AURVAD(nIdSiniestro,PalAurvad,cCodCobert);
                    END IF;
                END IF;
            END IF;

            ---APROBACIONES
            nMontoMoneda := nMontoLocal / nTasaCambio;
            --nMtoBruto := nMtoHono + nMtoHosp + nMtoOtrosGtos - nMtoDcto - nMtoDeducible;-- A PETICION SE QUITAN DEL MOTNO NETO DESCUENTO Y DEDUCIBLE
            --nMtoBruto := nMtoHono + nMtoHosp + nMtoOtrosGtos;
            --nMtoTotPagCalc
            nMtoBruto := 0;
            IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(X.CodCia, nIdPoliza, nIDetPol, nCodAsegurado) = 'S' THEN
                 --COLECTIVO
                   nNumAprobacion := OC_APROBACION_ASEG.INSERTA_APROBACION(nIdSiniestro, nIdPoliza, nCodAsegurado,
                                                                         nMtoTotPagCalc, nMtoTotPagCalc, cTipoAprobacion, 'APR', nIdeFactExt);

                 FOR K IN GTOS_Q LOOP
                      --- SE AGREGA MONTO DEL GASTO O SINIESTRALIDAD
                      IF K.OrdenCampo = 13 AND nMtoHono <> 0 THEN
                          nMtoBruto := nMtoHono;
                          cCodCptoTransac := 'GTOHON';
                          BEGIN
                              SELECT CodTransac
                                INTO cCodTransac
                                FROM CPTOS_TRANSAC_SINIESTROS
                               WHERE CodCptoTransac = cCodCptoTransac;
                          EXCEPTION
                               WHEN NO_DATA_FOUND THEN
                                  cCodTransac := cCodCptoTransac;
                          END;
                      ELSIF K.OrdenCampo = 14 AND nMtoHosp <> 0 THEN
                          nMtoBruto := nMtoHosp;
                          cCodCptoTransac := 'GTOHOS';
                          BEGIN
                              SELECT CodTransac
                                INTO cCodTransac
                                FROM CPTOS_TRANSAC_SINIESTROS
                               WHERE CodCptoTransac = cCodCptoTransac;
                          EXCEPTION
                               WHEN NO_DATA_FOUND THEN
                                  cCodTransac := cCodCptoTransac;
                          END;
                      ELSIF K.OrdenCampo = 15 AND nMtoOtrosGtos <> 0 THEN
                          nMtoBruto := nMtoOtrosGtos;
                          cCodCptoTransac := 'GTOOTR';
                          BEGIN
                              SELECT CodTransac
                                INTO cCodTransac
                                FROM CPTOS_TRANSAC_SINIESTROS
                               WHERE CodCptoTransac = cCodCptoTransac;
                          EXCEPTION
                               WHEN NO_DATA_FOUND THEN
                                  cCodTransac := cCodCptoTransac;
                          END;
                      END IF;
                      IF nMtoBruto <> 0 THEN
                          OC_DETALLE_APROBACION_ASEG.INSERTA_DETALLE(nIdSiniestro, nNumAprobacion, cCodCobert,
                                                                     nMtoBruto, nMtoBruto / nTasaCambio, cCodTransac,
                                                                     cCodCptoTransac);
                          nMtoBruto := NULL;
                      END IF;
                 END LOOP;
                 FOR J IN IMPTOS_Q LOOP
                      IF J.OrdenCampo = 16 AND nMtoDcto <> 0 THEN
                          --INSERTA DETALLE DESCUENTO
                          cCodCobert      := 'DEDUC';
                          nMtoImpto     := nMtoDcto * -1;
                          cCodCptoTransac := 'DESCUE';
                          BEGIN
                              SELECT CodTransac
                                INTO cCodTransac
                                FROM CPTOS_TRANSAC_SINIESTROS
                               WHERE CodCptoTransac = cCodCptoTransac;
                          EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                                  cCodTransac := cCodCptoTransac;
                          END;
                      ELSIF J.OrdenCampo = 17 AND nMtoDeducible <> 0 THEN
                          --INSERTA DETALLE DEDUCIBLE
                          cCodCobert      := 'DEDUC';
                          nMtoImpto       := nMtoDeducible * -1;
                          cCodCptoTransac := cCodCptoTransacDed;
                          BEGIN
                              SELECT CodTransac
                                INTO cCodTransac
                                FROM CPTOS_TRANSAC_SINIESTROS
                               WHERE CodCptoTransac = cCodCptoTransac;
                          EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                                  cCodTransac := cCodCptoTransac;
                          END;
                      ELSIF J.OrdenCampo = 18 AND nMtoIva <> 0 THEN
                          --INSERTA DETALLE IVA
                          cCodCobert      := 'IMPTO';
                          nMtoImpto     := nMtoIva;
                          cCodCptoTransac := 'IVASIN';
                          BEGIN
                              SELECT CodTransac
                                INTO cCodTransac
                                FROM CPTOS_TRANSAC_SINIESTROS
                               WHERE CodCptoTransac = cCodCptoTransac;
                          EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                                  cCodTransac := cCodCptoTransac;
                          END;
                      ELSIF J.OrdenCampo = 19 AND nMtoIsr <> 0 THEN
                          cCodCobert      := 'IMPTO';
                          nMtoImpto     := nMtoIsr * -1;
                          cCodCptoTransac := 'ISRSIN';
                          BEGIN
                              SELECT CodTransac
                                INTO cCodTransac
                                FROM CPTOS_TRANSAC_SINIESTROS
                               WHERE CodCptoTransac = cCodCptoTransac;
                          EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                                  cCodTransac := cCodCptoTransac;
                          END;
                      ELSIF J.OrdenCampo = 20 AND nMtoRetIva <> 0 THEN
                          cCodCobert      := 'IMPTO';
                          nMtoImpto     := nMtoRetIva * -1;
                          cCodCptoTransac := 'RETIVA';
                          BEGIN
                              SELECT CodTransac
                                INTO cCodTransac
                                FROM CPTOS_TRANSAC_SINIESTROS
                               WHERE CodCptoTransac = cCodCptoTransac;
                          EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                                  cCodTransac := cCodCptoTransac;
                          END;
                      ELSIF J.OrdenCampo = 21 AND nMtoRetImpCedular <> 0 THEN
                          cCodCobert      := 'IMPTO';
                          nMtoImpto     := nMtoRetImpCedular * -1;
                          cCodCptoTransac := 'IMPLOC';
                          BEGIN
                              SELECT CodTransac
                                INTO cCodTransac
                                FROM CPTOS_TRANSAC_SINIESTROS
                               WHERE CodCptoTransac = cCodCptoTransac;
                          EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                                  cCodTransac := cCodCptoTransac;
                          END;
                      END IF;
                      IF nMtoImpto != 0 THEN
                          OC_DETALLE_APROBACION_ASEG.INSERTA_DETALLE(nIdSiniestro, nNumAprobacion, cCodCobert,
                                                                     nMtoImpto, nMtoImpto / nTasaCambio, cCodTransac,
                                                                     cCodCptoTransac);
                          nMtoImpto := NULL;
                      END IF;
                 END LOOP;
            ELSE
                 --INDIVIDUAL
                 nNumAprobacion := OC_APROBACIONES.INSERTA_APROBACION(nIdSiniestro, nIdPoliza, nMtoTotPagCalc,
                                                                      nMtoTotPagCalc, cTipoAprobacion, 'APR', nIdeFactExt);
                 FOR K IN GTOS_Q LOOP
                      --- SE AGREGA MONTO DEL GASTO O SINIESTRALIDAD
                      IF K.OrdenCampo = 13 AND nMtoHono <> 0 THEN
                          nMtoBruto := nMtoHono;
                          cCodCptoTransac := 'GTOHON';
                          BEGIN
                              SELECT CodTransac
                                INTO cCodTransac
                                FROM CPTOS_TRANSAC_SINIESTROS
                               WHERE CodCptoTransac = cCodCptoTransac;
                          EXCEPTION
                               WHEN NO_DATA_FOUND THEN
                                  cCodTransac := cCodCptoTransac;
                          END;
                      ELSIF K.OrdenCampo = 14 AND nMtoHosp <> 0 THEN
                          nMtoBruto := nMtoHosp;
                          cCodCptoTransac := 'GTOHOS';
                          BEGIN
                              SELECT CodTransac
                                INTO cCodTransac
                                FROM CPTOS_TRANSAC_SINIESTROS
                               WHERE CodCptoTransac = cCodCptoTransac;
                          EXCEPTION
                               WHEN NO_DATA_FOUND THEN
                                  cCodTransac := cCodCptoTransac;
                          END;
                      ELSIF K.OrdenCampo = 15 AND nMtoOtrosGtos <> 0 THEN
                          nMtoBruto := nMtoOtrosGtos;
                          cCodCptoTransac := 'GTOOTR';
                          BEGIN
                              SELECT CodTransac
                                INTO cCodTransac
                                FROM CPTOS_TRANSAC_SINIESTROS
                               WHERE CodCptoTransac = cCodCptoTransac;
                          EXCEPTION
                               WHEN NO_DATA_FOUND THEN
                                  cCodTransac := cCodCptoTransac;
                          END;
                      END IF;
                      IF nMtoBruto <> 0 THEN
                          OC_DETALLE_APROBACION .INSERTA_DETALLE(nIdSiniestro, nNumAprobacion, cCodCobert,
                                                                     nMtoBruto, nMtoBruto / nTasaCambio, cCodTransac,
                                                                     cCodCptoTransac);
                          nMtoBruto := NULL;
                      END IF;
                 END LOOP;
                 FOR J IN IMPTOS_Q LOOP
                      IF J.OrdenCampo = 16 AND nMtoDcto <> 0 THEN
                          --INSERTA DETALLE DESCUENTO
                          cCodCobert      := 'DEDUC';
                          nMtoImpto     := nMtoDcto * -1;
                          cCodCptoTransac := 'DESCUE';
                          BEGIN
                              SELECT CodTransac
                                INTO cCodTransac
                                FROM CPTOS_TRANSAC_SINIESTROS
                               WHERE CodCptoTransac = cCodCptoTransac;
                          EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                                  cCodTransac := cCodCptoTransac;
                          END;
                      ELSIF J.OrdenCampo = 17 AND nMtoDeducible <> 0 THEN
                          --INSERTA DETALLE DEDUCIBLE
                          cCodCobert      := 'DEDUC';
                          nMtoImpto     := nMtoDeducible * -1;
                          cCodCptoTransac := cCodCptoTransacDed;
                          BEGIN
                              SELECT CodTransac
                                INTO cCodTransac
                                FROM CPTOS_TRANSAC_SINIESTROS
                               WHERE CodCptoTransac = cCodCptoTransac;
                          EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                                  cCodTransac := cCodCptoTransac;
                          END;
                      ELSIF J.OrdenCampo = 18 AND nMtoIva <> 0 THEN
                          --INSERTA DETALLE IVA
                          cCodCobert      := 'IMPTO';
                          nMtoImpto     := nMtoIva;
                          cCodCptoTransac := 'IVASIN';
                          BEGIN
                              SELECT CodTransac
                                INTO cCodTransac
                                FROM CPTOS_TRANSAC_SINIESTROS
                               WHERE CodCptoTransac = cCodCptoTransac;
                          EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                                  cCodTransac := cCodCptoTransac;
                          END;
                      ELSIF J.OrdenCampo = 19 AND nMtoIsr <> 0 THEN
                          cCodCobert      := 'IMPTO';
                          nMtoImpto     := nMtoIsr * -1;
                          cCodCptoTransac := 'ISRSIN';
                          BEGIN
                              SELECT CodTransac
                                INTO cCodTransac
                                FROM CPTOS_TRANSAC_SINIESTROS
                               WHERE CodCptoTransac = cCodCptoTransac;
                          EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                                  cCodTransac := cCodCptoTransac;
                          END;
                      ELSIF J.OrdenCampo = 20 AND nMtoRetIva <> 0 THEN
                          cCodCobert      := 'IMPTO';
                          nMtoImpto     := nMtoRetIva * -1;
                          cCodCptoTransac := 'RETIVA';
                          BEGIN
                              SELECT CodTransac
                                INTO cCodTransac
                                FROM CPTOS_TRANSAC_SINIESTROS
                               WHERE CodCptoTransac = cCodCptoTransac;
                          EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                                  cCodTransac := cCodCptoTransac;
                          END;
                      ELSIF J.OrdenCampo = 21 AND nMtoRetImpCedular <> 0 THEN
                          cCodCobert      := 'IMPTO';
                          nMtoImpto     := nMtoRetImpCedular * -1;
                          cCodCptoTransac := 'IMPLOC';
                          BEGIN
                              SELECT CodTransac
                                INTO cCodTransac
                                FROM CPTOS_TRANSAC_SINIESTROS
                               WHERE CodCptoTransac = cCodCptoTransac;
                          EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                                  cCodTransac := cCodCptoTransac;
                          END;
                      END IF;
                      IF nMtoImpto <> 0 THEN
                          --DETALLE APROBACION
                          OC_DETALLE_APROBACION.INSERTA_DETALLE(nIdSiniestro, nNumAprobacion, cCodCobert ,
                                                                nMtoImpto, nMtoImpto / nTasaCambio, cCodTransac ,
                                                                cCodCptoTransac);
                      END IF;
                   END LOOP;
            END IF;

            -- Se adiciona la condición de proveedor y numdoc no sean nulos.
            IF cNombProvBenef IS NOT NULL THEN
               nBenef := OC_BENEF_SIN.INSERTA_BENEF_PROV(nIdSiniestro, nIdPoliza, nCodAsegurado, 'RFC', cRFCBenef);
            ELSE
               -- Aqui se debe crear el beneficiario a partir del asegurado.
               nBenef := OC_BENEF_SIN.INSERTA_ASEG_BENEF(nIdSiniestro, nIdPoliza, nCodAsegurado);
            END IF;

            ----PAGA APROBACIONES DE PAGO
            IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(X.CodCia, nIdPoliza, nIDetPol, nCodAsegurado) = 'N' THEN
               BEGIN
                 UPDATE APROBACIONES
                    SET BENEF = nBenef,
                        CTALIQUIDADORA = 8601,
                        NUMPAGREF = cNumAsist
                  WHERE nNumAprobacion = nNumAprobacion
                    AND IdSiniestro    = nIdSiniestro
                    AND IdPoliza       = nIdPoliza;
               EXCEPTION
                 WHEN OTHERS THEN
                   RAISE_APPLICATION_ERROR(-20225,'Error al Actualizar la Aprobación Aseg con el Beneficiario '|| cNumSiniRef || ' ' || SQLERRM);
               END;

               BEGIN
                 OC_APROBACIONES.PAGAR(X.CodCia, X.CodEmpresa, nNumAprobacion, nIdSiniestro,
                                       nIdPoliza, 1);
               EXCEPTION
                 WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20225,'Individual. Error al Pagar la Aprobación del Siniestro: '|| nIdSiniestro || ' ' || SQLERRM);
               END;
            ELSE
               BEGIN
                 UPDATE APROBACION_ASEG
                    SET BENEF = nBenef,
                        CTALIQUIDADORA = 8601,
                        NUMPAGREF = cNumAsist
                  WHERE Num_Aprobacion = nNumAprobacion
                    AND IdSiniestro    = nIdSiniestro
                    AND IdPoliza       = nIdPoliza
                    AND Cod_Asegurado  = nCodAsegurado;
               EXCEPTION
                 WHEN OTHERS THEN
                   RAISE_APPLICATION_ERROR(-20225,'Error al Actualizar la Aprobación Aseg con el Beneficiario '|| cNumSiniRef || ' ' || SQLERRM);
               END;
               BEGIN
                  OC_APROBACION_ASEG.PAGAR(X.CodCia, X.CodEmpresa, nNumAprobacion, nIdSiniestro,
                                       nIdPoliza, nCodAsegurado, 1);
               EXCEPTION
                  WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20225,'Colectivos. Error al Pagar la Aprobación del Siniestro: '|| nIdSiniestro || ' ' || SQLERRM);
               END;

            END IF;

            --cNombreArchLogem   := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,27,','));
            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'PROCE');
            WNUM_ASISTENCIA := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,2,cSeparador));
            BEGIN
                UPDATE PROCESOS_MASIVOS_SEGUIMIENTO
                   SET IDPOLIZA         = nIdPoliza,
                       NUM_APROBACION   = nNumAprobacion,
                       IDSINIESTRO      = nIdSiniestro,
                       COD_ASEGURADO    = nCodAsegurado,
                       MONTOIVA         = nMontoTotIVA,
                       MONTOPAGAR       = MontoDePago,
                       MONTOISR         = nMontoTotISR,
                       EMI_USUARIO      = USUSARIO,
                       EMI_TERMINAL     = TERMINAL,
                       EMI_FECHA        = TRUNC(dFechaCamb),
                       EMI_FECHACOMP    = dFechaCamb,
                       TIPO             = 'Paga Siniestro',
                       NUMFACTURA       = cNumFactura,
                       ARCHIVO_LOGEM    = X.NomArchivoCarga,
                       EMI_TIPOPROCESO   = 'PAGSIN',
                       EMI_STSREGPROCESO = 'EMI',
                       EMI_REGDATOSPROC  = X.RegDatosProc,
                       NUM_ASISTENCIA    = WNUM_ASISTENCIA,
                       RFC_HOSPITAL      = cRFCProv,
                       RFC_ASISTENCIADORA= cRFCBenef
                 WHERE IdProcMasivo   = nIdProcMasivo;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 RAISE_APPLICATION_ERROR(-20225,' 1 Error en ACTUALIZA_STATUS UPDATE PROCESOS_MASIVOS_SEGUIMIENTO  '||SQLERRM);
              WHEN OTHERS  THEN
                 RAISE_APPLICATION_ERROR(-20225,' 1 Error en ACTUALIZA_STATUS UPDATE PROCESOS_MASIVOS_SEGUIMIENTO  '||SQLERRM);
            END;

            SELECT SUM(DECODE(CTS.SIGNO,'-',NVL(MONTO_RESERVADO_MONEDA,0)*(-1),NVL(MONTO_RESERVADO_MONEDA,0)))
              INTO wOCURRIDO
              FROM COBERTURA_SINIESTRO_ASEG G, CONFIG_TRANSAC_SINIESTROS CTS
             WHERE G.IDSINIESTRO  = nIdSiniestro
               AND G.IDPOLIZA     = nIdPoliza
               --AND CTS.CODTRANSAC = G.CODCPTOTRANSAC
               AND CTS.CODTRANSAC = G.CODTRANSAC;

            SELECT SUM(MONTO_PAGADO_MONEDA)
              INTO wPAGADOS
              FROM COBERTURA_SINIESTRO_ASEG
             WHERE IDSINIESTRO = nIdSiniestro
               AND IDPOLIZA    = nIdPoliza;

            BEGIN
                UPDATE DETALLE_SINIESTRO_ASEG
                   SET MONTO_RESERVADO_LOCAL  = wOCURRIDO,
                       MONTO_RESERVADO_MONEDA = wOCURRIDO,
                       MONTO_PAGADO_MONEDA    = wPAGADOS,
                       MONTO_PAGADO_LOCAL     = wPAGADOS
                 WHERE IDSINIESTRO   = nIdSiniestro
                   AND IDPOLIZA      = nIdPoliza
                   AND IDDETSIN      = 1
                   AND COD_ASEGURADO = nCodAsegurado;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                   RAISE_APPLICATION_ERROR(-20225,'NDF Error al actualizar DETALLE_SINIESTRO_ASEG : '||SQLERRM);
                WHEN OTHERS THEN
                   RAISE_APPLICATION_ERROR(-20225,'OTHERS Error al actualizar DETALLE_SINIESTRO_ASEG : '||SQLERRM);
            END;

            BEGIN
                  UPDATE SINIESTRO
                     SET MONTO_RESERVA_LOCAL  = wOCURRIDO,
                         MONTO_RESERVA_MONEDA = wOCURRIDO,
                         MONTO_PAGO_MONEDA    = wPAGADOS,
                         MONTO_PAGO_LOCAL     = wPAGADOS
                   WHERE IDSINIESTRO   = nIdSiniestro
                     AND IDPOLIZA      = nIdPoliza
                     AND COD_ASEGURADO = nCodAsegurado;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-20225,'NDF Error al actualizar SINIESTRO : '||SQLERRM);
               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR(-20225,'OTHERS Error al actualizar SINIESTRO : '||SQLERRM);
            END;
      ELSE
        OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','No se puede Pagar el Siniestro: '||cMsjError);
        OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');

     ---  aevs   seguimiento de  cargas masivas
          BEGIN
             UPDATE PROCESOS_MASIVOS_SEGUIMIENTO
                SET ERR_USUARIO      = USUSARIO,
                    ERR_TERMINAL     = TERMINAL,
                    ERR_FECHA        = TRUNC(dFechaCamb),
                    ERR_FECHACOMP    = dFechaCamb,
                    IDPOLIZA         = nIdPoliza
              WHERE IdProcMasivo = nIdProcMasivo;
           EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
            WHEN OTHERS  THEN
              --RAISE_APPLICATION_ERROR(-20225,' 1 Error en ACTUALIZA_STATUS UPDATE PROCESOS_MASIVOS_SEGUIMIENTO ERROR  '||SQLERRM);
             Null;
          END;
      END IF;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo,'AUTOMATICO','20225','No se puede Pagar el Siniestro '||SQLERRM);
      OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo,'ERROR');
END PAGO_SINIESTROS_MASIVO;

FUNCTION  VALIDA_ARCHIVO_CARGA(cNomArchivoCarga VARCHAR2) RETURN BOOLEAN IS
nCuenta NUMBER;
BEGIN
   SELECT COUNT(*)
     INTO nCuenta
     FROM PROCESOS_MASIVOS
    WHERE NomArchivoCarga = cNomArchivoCarga
      AND IndRegValidado = 'N'
      AND CodUsuario = USER;

   IF nCuenta = 0 THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END VALIDA_ARCHIVO_CARGA;

PROCEDURE ACTUALIZA_AUTORIZACION(nCodCia NUMBER, nCodEmpresa NUMBER,nIdProcMasivo NUMBER,cNomArchivoCarga VARCHAR2,nIdAutorizacion NUMBER) IS
BEGIN
   UPDATE PROCESOS_MASIVOS
       SET IdAutorizacion = nIdAutorizacion
     WHERE CodCia          = nCodCia
       AND CodEmpresa      = nCodEmpresa
       AND IdProcMasivo    = nIdProcMasivo
       AND NomArchivoCarga = cNomArchivoCarga;
END ACTUALIZA_AUTORIZACION;

PROCEDURE ENDOSO_DECLARACION_MASIVO(nIdProcMasivo NUMBER) IS
nCodCia           POLIZAS.CodCia%TYPE;
nCodEmpresa       POLIZAS.CodEmpresa%TYPE;
cCodPlantilla     CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE;
cNomTabla         CONFIG_PLANTILLAS_TABLAS.NomTabla%TYPE;
nOrdenProceso     CONFIG_PLANTILLAS_TABLAS.OrdenProceso%TYPE;
nOrdenCampo       CONFIG_PLANTILLAS_CAMPOS.OrdenCampo%TYPE;
cNomCampo         CONFIG_PLANTILLAS_CAMPOS.NomCampo%TYPE;
cValorCampo       VARCHAR2(1000);
cTipoSeparador    CONFIG_PLANTILLAS.TipoSeparador%TYPE;
cSeparador        VARCHAR2(1);
nIdPoliza         POLIZAS.IdPoliza%TYPE;
nIDetPol          DETALLE_POLIZA.IDetPol%TYPE;
cCodPlanPago      POLIZAS.CodPlanPago%TYPE;
cSexo             PERSONA_NATURAL_JURIDICA.Sexo%TYPE;
cTipoDocIdentAseg PERSONA_NATURAL_JURIDICA.Tipo_Doc_Identificacion%TYPE;
cNumDocIdentAseg  PERSONA_NATURAL_JURIDICA.Num_Doc_Identificacion%TYPE;
cNombreAseg       PERSONA_NATURAL_JURIDICA.Nombre%TYPE;
cApellidoPaterno  PERSONA_NATURAL_JURIDICA.Apellido_Paterno%TYPE;
cApellidoMaterno  PERSONA_NATURAL_JURIDICA.Apellido_Materno%TYPE;
dFecNacimiento    PERSONA_NATURAL_JURIDICA.FecNacimiento%TYPE;
dFecIngreso       PERSONA_NATURAL_JURIDICA.FecIngreso%TYPE;

CURSOR C_CAMPOS (cNomTabla VARCHAR2) IS
   SELECT NomCampo, OrdenCampo, OrdenProceso, TipoCampo
     FROM CONFIG_PLANTILLAS_CAMPOS C
    WHERE CodPlantilla = cCodPlantilla
      AND CodEmpresa   = nCodEmpresa
      AND NomTabla     = cNomTabla
      AND CodCia       = nCodCia
    ORDER BY OrdenCampo;

CURSOR EMI_Q IS
   SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
          NumDetUnico, RegDatosProc, TipoProceso, IndColectiva
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;

CURSOR C_COBERT IS
   SELECT IdPoliza, IDetPol, CodEmpresa, IdTipoSeg, CodCia, CodCobert,
          SumaAseg_Local, SumaAseg_Moneda, Prima_Local, Prima_Moneda, Tasa, PlanCob
     FROM COBERT_ACT
    WHERE IdPoliza     = nIdPoliza
      AND IDETPOL      = nIdetPol
      AND StsCobertura = 'SOL';
BEGIN
   FOR X IN EMI_Q LOOP
      cCodPlanPago      := OC_TIPOS_DE_SEGUROS.PLAN_PAGOS(X.CodCia, X.CodEmpresa, X.IdTipoSeg);
      cCodPlantilla     := OC_CONFIG_PLANTILLAS_PLANCOB.CODIGO_PLANTILLA(X.CodCia,X.CodEmpresa,X.IdTipoSeg,X.PlanCob,X.TipoProceso);
      cTipoSeparador    := OC_CONFIG_PLANTILLAS.TIPO_SEPARADOR(X.CodCia, X.CodEmpresa, cCodPlantilla);
      IF cTipoSeparador = 'PIP' THEN
         cSeparador := '|';
      ELSIF cTipoSeparador = 'COM' THEN
         cSeparador := ',';
      END IF;
      cNomTabla      := 'PERSONA_NATURAL_JURIDICA';
      nOrdenProceso  := GT_CONFIG_PLANTILLAS_TABLAS.ORDEN_PROCESO(X.CodCia, X.CodEmpresa, cCodPlantilla, cNomTabla);
      nOrdenCampo    := 1;
      FOR W IN C_CAMPOS(cNomTabla) LOOP
         cValorCampo := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenCampo,cSeparador));
         cNomCampo   := OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(X.CodCia, X.CodEmpresa, cCodPlantilla, nOrdenCampo);
         IF cValorCampo = 'TIPO_ID_TRIBUTARIA' THEN
            cTipoDocIdentAseg := cValorCampo;
         ELSIF cValorCampo = 'NUM_TRIBUTARIO ' THEN
            cNumDocIdentAseg  := cValorCampo;
         ELSIF cValorCampo = 'NOMBRE' THEN
            cNombreAseg       := cValorCampo;
         ELSIF cValorCampo = 'APELLIDO_PATERNO' THEN
            cApellidoPaterno  := cValorCampo;
         ELSIF cValorCampo = 'APELLIDO_MATERNO' THEN
            cApellidoMaterno  := cValorCampo;
         ELSIF cValorCampo = 'SEXO' THEN
            cSexo             := cValorCampo;
         ELSIF cValorCampo = 'FECNACIMIENTO' THEN
            dFecNacimiento    := TO_DATE(cValorCampo,'DD/MM/YYYY');
         ELSIF cValorCampo = 'FECINGRESO' THEN
            dFecIngreso       := TO_DATE(cValorCampo,'DD/MM/YYYY');
         END IF;
         nOrdenCampo := nOrdenCampo + 1;
      END LOOP;

      cNomTabla      := 'CLIENTES';
      nOrdenProceso  := GT_CONFIG_PLANTILLAS_TABLAS.ORDEN_PROCESO(X.CodCia, X.CodEmpresa, cCodPlantilla, cNomTabla);
      FOR W IN C_CAMPOS(cNomTabla) LOOP
         cValorCampo := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenCampo,cSeparador));
         cNomCampo   := OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(X.CodCia, X.CodEmpresa, cCodPlantilla, nOrdenCampo);
         IF cValorCampo = 'CLIENTEUNICO' THEN
            cTipoDocIdentAseg := cValorCampo;
         END IF;
         nOrdenCampo := nOrdenCampo + 1;
      END LOOP;
   END LOOP;
END ENDOSO_DECLARACION_MASIVO;

PROCEDURE ASEGURADOS_CON_FONDOS(nIdProcMasivo NUMBER) IS
nCodCliente        CLIENTES.CodCliente%TYPE;
nCod_Asegurado     ASEGURADO.Cod_Asegurado%TYPE;
nCodCia            POLIZAS.CodCia%TYPE;
nCodEmpresa        POLIZAS.CodEmpresa%TYPE;
cCodMoneda         POLIZAS.Cod_Moneda%TYPE;
cPlanCob           PLAN_COBERTURAS.PlanCob%TYPE;
nIdPoliza          POLIZAS.IdPoliza%TYPE;
cIdTipoSeg         TIPOS_DE_SEGUROS.IdTipoSeg%TYPE;
nPorcComis         POLIZAS.PorcComis%TYPE;
cDescpoliza        POLIZAS.DescPoliza%TYPE;
nCod_Agente        POLIZAS.Cod_Agente%TYPE;
cCodPlanPago       POLIZAS.CodPlanPago%TYPE;
nTasaCambio        DETALLE_POLIZA.Tasa_Cambio%TYPE;
nIDetPol           DETALLE_POLIZA.IDetPol%TYPE;
cIdGrupoTarj       TARJETAS_PREPAGO.IdGrupoTarj%TYPE;
cCodPromotor       DETALLE_POLIZA.CodPromotor%TYPE;
cMsjError          PROCESOS_MASIVOS_LOG.TxtError%TYPE := 'N';
cCodPlantilla      CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE;
cNomTabla          CONFIG_PLANTILLAS_CAMPOS.NomTabla%TYPE;
cCampo             CONFIG_PLANTILLAS_CAMPOS.NomCampo%TYPE;
nSuma              COBERT_ACT_ASEG.SumaAseg_Local%TYPE;
nIdEndoso          ENDOSOS.IdEndoso%TYPE;
cStsDetalle        DETALLE_POLIZA.StsDetalle%TYPE;
nIdSolicitud       SOLICITUD_EMISION.IdSolicitud%TYPE;
cStsPoliza         POLIZAS.StsPoliza%TYPE;
nOrdenProceso      CONFIG_PLANTILLAS_TABLAS.OrdenProceso%TYPE;
nOrdenCampo        CONFIG_PLANTILLAS_CAMPOS.OrdenCampo%TYPE;
cTipoDocIdentAseg  PERSONA_NATURAL_JURIDICA.Tipo_Doc_Identificacion%TYPE;
cNumDocIdentAseg   PERSONA_NATURAL_JURIDICA.Num_Doc_Identificacion%TYPE;
cNombreAseg        PERSONA_NATURAL_JURIDICA.Nombre%TYPE;
cApellidoPaterno   PERSONA_NATURAL_JURIDICA.Apellido_Paterno%TYPE;
cApellidoMaterno   PERSONA_NATURAL_JURIDICA.Apellido_Materno%TYPE;
dFecNacimiento     PERSONA_NATURAL_JURIDICA.FecNacimiento%TYPE;
dFecIngreso        PERSONA_NATURAL_JURIDICA.FecIngreso%TYPE;
nMontoAporteAseg   ASEGURADO_CERTIFICADO.MontoAporteAseg%TYPE;
cTipoSeparador     CONFIG_PLANTILLAS.TipoSeparador%TYPE;
cNomCampo          CONFIG_PLANTILLAS_CAMPOS.NomCampo%TYPE;
cSexo              PERSONA_NATURAL_JURIDICA.Sexo%TYPE;
cValorCampo        VARCHAR2(1000);
cExisteTipoSeguro  VARCHAR2(2);
cExiste            VARCHAR2(1);
cExisteDet         VARCHAR2(1);
cUpdate            VARCHAR2(4000);
dFecIniVig         DATE;
dFecFinVig         DATE;
cExisteParEmi      VARCHAR2(1);
cExisteAsegCert    VARCHAR2(1);
cIndSinAseg        VARCHAR2(1);
cSeparador         VARCHAR2(1);
nOrden             NUMBER(10):= 1;
nOrdenInc          NUMBER(10) ;

CURSOR C_CAMPOS (cNomTabla VARCHAR2) IS
   SELECT NomCampo, OrdenCampo, OrdenProceso, TipoCampo
     FROM CONFIG_PLANTILLAS_CAMPOS
    WHERE CodPlantilla = cCodPlantilla
      AND CodEmpresa   = nCodEmpresa
      AND NomTabla     = cNomTabla
      AND CodCia       = nCodCia
    ORDER BY OrdenCampo;

CURSOR C_CAMPOS_ASEG  IS
   SELECT NomCampo, OrdenCampo, OrdenProceso, OrdenDatoPart
     FROM CONFIG_PLANTILLAS_CAMPOS
    WHERE CodPlantilla = cCodPlantilla
      AND CodEmpresa   = nCodEmpresa
      AND CodCia       = nCodCia
      AND NomTabla     = 'ASEGURADO_CERTIFICADO'
      AND IndAseg      = 'S'
    ORDER BY OrdenDatoPart, OrdenCampo;

CURSOR EMI_Q IS
   SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
          NumDetUnico, RegDatosProc, TipoProceso, IndColectiva,
          IndAsegurado
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;
BEGIN
   FOR X IN EMI_Q LOOP
      nCodCia           := X.CodCia;
      nCodEmpresa       := X.CodEmpresa;
      cCodPlanPago      := OC_TIPOS_DE_SEGUROS.PLAN_PAGOS(X.CodCia, X.CodEmpresa, X.IdTipoSeg);
      cCodPlantilla     := OC_CONFIG_PLANTILLAS_PLANCOB.CODIGO_PLANTILLA(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, X.TipoProceso);
      cTipoSeparador    := OC_CONFIG_PLANTILLAS.TIPO_SEPARADOR(X.CodCia, X.CodEmpresa, cCodPlantilla);
      IF cTipoSeparador = 'PIP' THEN
         cSeparador := '|';
      ELSIF cTipoSeparador = 'COM' THEN
         cSeparador := ',';
      END IF;
      cNomTabla         := 'PERSONA_NATURAL_JURIDICA';
      nOrdenProceso     := GT_CONFIG_PLANTILLAS_TABLAS.ORDEN_PROCESO(X.CodCia, X.CodEmpresa, cCodPlantilla, cNomTabla);
      nOrdenCampo       := 1;
      cTipoDocIdentAseg := 'RFC';
      FOR W IN C_CAMPOS(cNomTabla) LOOP
         cValorCampo := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc,nOrdenCampo + 5,cSeparador));
         cNomCampo   := OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(X.CodCia, X.CodEmpresa, cCodPlantilla, nOrdenCampo);
         IF cNomCampo = 'NUM_DOC_IDENTIFICACION' THEN
            cNumDocIdentAseg  := cValorCampo;
         ELSIF cNomCampo = 'NOMBRE' THEN
            cNombreAseg       := cValorCampo;
         ELSIF cNomCampo = 'APELLIDO_PATERNO' THEN
            cApellidoPaterno  := cValorCampo;
         ELSIF cNomCampo = 'APELLIDO_MATERNO' THEN
            cApellidoMaterno  := cValorCampo;
         ELSIF cNomCampo = 'SEXO' THEN
            cSexo             := cValorCampo;
         ELSIF cNomCampo = 'FECNACIMIENTO' THEN
            dFecNacimiento    := TO_DATE(cValorCampo,'DD/MM/RRRR');
         ELSIF cNomCampo = 'FECINGRESO' THEN
            dFecIngreso       := TO_DATE(cValorCampo,'DD/MM/RRRR');
         END IF;
         nOrdenCampo := nOrdenCampo + 1;
      END LOOP;

      IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(cTipoDocIdentAseg, cNumDocIdentAseg) = 'N' THEN
         BEGIN
            INSERT INTO PERSONA_NATURAL_JURIDICA
                   (Tipo_Doc_Identificacion, Num_Doc_Identificacion, Nombre,
                    Apellido_Paterno, APellido_Materno, Sexo, FecNacimiento,
                    FecIngreso)
            VALUES (cTipoDocIdentAseg, cNumDocIdentAseg, cNombreAseg,
                    cApellidoPaterno, cApellidoMaterno, cSexo, dFecNacimiento,
                    dFecIngreso);
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
               RAISE_APPLICATION_ERROR(-20225,'Ya Existe Persona Natural Jurídica con la Identificación '|| cTipoDocIdentAseg ||
                                       ' - ' || cNumDocIdentAseg);
         END;
      ELSE
         nOrden    := 1;
         nOrdenInc := 0;
         FOR I IN C_CAMPOS('PERSONA_NATURAL_JURIDICA') LOOP
            nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION(cCodPlantilla, X.CodCia, X.CodEmpresa, I.OrdenProceso) + 5 + nOrden;
            IF UPPER(I.NomCampo) = 'FECNACIMIENTO' THEN
               nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla, X.CodCia, X.CodEmpresa, I.OrdenProceso) + 5 + nOrden;
               cUpdate := 'UPDATE '||'PERSONA_NATURAL_JURIDICA'||' '||'SET'||' '||I.NomCampo||'='|| 'TO_DATE(' || CHR(39) ||
                          LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc, nOrdenInc, cSeparador) || CHR(39) || ','|| CHR(39) ||
                          'DD/MM/RRRR' || CHR(39) || ') ' ||
                          'WHERE Tipo_Doc_Identificacion='||''''||cTipoDocIdentAseg||''''||' '||
                          'AND Num_Doc_Identificacion='||''''||cNumDocIdentAseg||'''');
               OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate);
            END IF;
            nOrden := nOrden + 1;
         END LOOP;
      END IF;

      IF OC_PERSONA_NATURAL_JURIDICA.FUNC_VALIDA_EDAD(cTipoDocIdentAseg, cNumDocIdentAseg, X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob) = 'N' THEN
         RAISE_APPLICATION_ERROR(-20225,'Edad del Asegurado Fuera del Rango de Aceptación de Coberturas');
      END IF;
      BEGIN
         SELECT Cod_Agente
           INTO nCod_Agente
           FROM PLAN_COBERTURAS
          WHERE CodCia     = X.CodCia
            AND CodEmpresa = X.CodEmpresa
            AND IdTipoSeg  = X.IdTipoSeg
            AND PlanCob    = X.PlanCob;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            nCod_Agente := 0;
      END;

      nOrden      := 1;
      nOrdenInc   := 0;
      nCodCliente := OC_CLIENTES.CODIGO_CLIENTE(cTipoDocIdentAseg, cNumDocIdentAseg);
      IF nCodCliente = 0  THEN
         nCodCliente    := OC_CLIENTES.INSERTAR_CLIENTE(cTipoDocIdentAseg, cNumDocIdentAseg);
         FOR I IN C_CAMPOS('CLIENTES') LOOP
            nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla, X.CodCia, X.CodEmpresa, I.OrdenProceso) + 5 + nOrden;
            cUpdate := 'UPDATE '||'CLIENTES'||' '||'SET'||' '||I.NomCampo||'=';
            IF I.TipoCampo = 'DATE' THEN
               cUpdate := cUpdate || ' TO_DATE(' || CHR(39) ||
                          LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc, nOrdenInc, cSeparador)) ||
                          CHR(39) || ','|| CHR(39) || 'DD/MM/RRRR' || CHR(39) || ') ';
            ELSE
               cUpdate := cUpdate || '''' ||LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc, nOrdenInc, cSeparador)) ||'''';
            END IF;
            cUpdate := cUpdate ||' '||'WHERE CodCliente = '||nCodCliente;
            OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate) ;
            nOrden := nOrden + 1;
         END LOOP;
      END IF;

      nCod_Asegurado := OC_ASEGURADO.CODIGO_ASEGURADO(X.CodCia, X.CodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
      IF nCod_Asegurado = 0 THEN
         nCod_Asegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(X.CodCia, X.CodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
      END IF;

      BEGIN
         INSERT INTO CLIENTE_ASEG
               (CodCliente, Cod_Asegurado)
         VALUES(nCodCliente, nCod_Asegurado);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            NULL;
      END;
      BEGIN
         SELECT IdPoliza, StsPoliza
           INTO nIdPoliza, cStsPoliza
           FROM POLIZAS
          WHERE NumPolUnico     = X.NumPolUnico
            AND CodCia          = X.CodCia
            AND CodEmpresa      = X.CodEmpresa
            AND StsPoliza  NOT IN ('ANU','REN','SUS');
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            nIdPoliza := 0;
      END;
      cExiste     := OC_POLIZAS.EXISTE_POLIZA(X.CodCia, X.CodEmpresa, nIdPoliza);
      cDescPoliza := 'Activación Masiva No. ' || TRIM(TO_CHAR(nIdProcMasivo));
      cCodMoneda  := OC_PLAN_COBERTURAS.MONEDA_PLANCOB(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob);
      nPorcComis  := OC_CONFIG_COMISIONES.PORCENTAJE_COMISION(X.CodCia, X.CodEmpresa, X.IdTipoSeg);
      IF cExiste = 'N' AND  NVL(X.IndColectiva,'N') = 'N' THEN
         IF dFecIniVig IS NULL THEN
            dFecIniVig := TRUNC(SYSDATE);
         END IF;
         nIdPoliza   := OC_POLIZAS.INSERTAR_POLIZA(X.CodCia, X.CodEmpresa, cDescPoliza, cCodMoneda, nPorcComis,
                                                   nCodCliente, nCod_Agente, cCodPlanPago, TRIM(TO_CHAR(X.NumPolUnico)),
                                                   cIdGrupoTarj, dFecIniVig);
      END IF;
      nIdSolicitud      := OC_SOLICITUD_EMISION.SOLICITUD_POLIZA(X.CodCia, X.CodEmpresa, nIdPoliza);
      cExisteTipoSeguro := OC_TIPOS_DE_SEGUROS.EXISTE_TIPO_DE_SEGURO(X.CodCia, X.CodEmpresa, X.IdTipoSeg);
      IF cExisteTipoSeguro = 'S' THEN
         BEGIN
            -- Inserta Tarea de Seguimiento
            IF OC_TAREA.EXISTE_TAREA(X.CodCia,nIdPoliza) = 'N' THEN
               OC_TAREA.INSERTA_TAREA(X.CodCia, 7, 'SOL', 'EMI', nIdPoliza, nCodCliente, 'A','SOL', 'SOLICITUD DE EMISION');
            END IF;
            -- Genera Detalle de Poliza
            nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
            BEGIN
               SELECT FecIniVig, FecFinVig, StsPoliza
                 INTO dFecIniVig, dFecFinVig, cStsPoliza
                 FROM POLIZAS
                WHERE IdPoliza   = nIdPoliza
                  AND CodCia     = X.CodCia
                  AND CodEmpresa = X.CodEmpresa;
            END;
            BEGIN
               SELECT IDetPol, IndSinAseg, StsDetalle, CodPlanPago
                 INTO nIDetPol, cIndSinAseg, cStsDetalle, cCodPlanPago
                 FROM DETALLE_POLIZA
                WHERE CodCia      = X.CodCia
                  AND CodEmpresa  = X.CodEmpresa
                  AND IdPoliza    = nIdpoliza
                  AND NumDetRef   = TRIM(TO_CHAR(X.NumDetUnico))
                  AND IdTipoSeg   = X.IdTipoSeg
                  AND PlanCob     = X.PlanCob;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-20225,'DETALLE POLIZA NO EXISTE: '|| TRIM(TO_CHAR(X.NumDetUnico)) ||
                                          ' Con el Producto ' || X.IdTipoSeg || ' y el Plan de Coberturas ' || X.PlanCob);
            END;

            nOrden    := 1;
            nOrdenInc := 0;
            IF NVL(X.IndAsegurado,'N') = 'S' THEN
               nOrden    := 1;
               nOrdenInc := 0;
               nIdEndoso := 0;
               IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(X.CodCia, nIdPoliza, nIDetPol, nCod_Asegurado) = 'N' THEN
                  IF cStsPoliza = 'SOL' OR cStsDetalle = 'SOL' THEN
                     OC_ASEGURADO_CERTIFICADO.INSERTA(X.CodCia, nIdPoliza, nIDetPol, nCod_Asegurado, 0);
                  ELSE
                     SELECT NVL(MAX(IdEndoso),0)
                       INTO nIdEndoso
                       FROM ENDOSOS
                      WHERE CodCia     = X.CodCia
                        AND IdPoliza   = nIdPoliza
                        AND StsEndoso  = 'SOL';

                     IF NVL(nIdEndoso,0) = 0 THEN
                        nIdEndoso := OC_ENDOSO.CREAR(nIdPoliza);
                        OC_ENDOSO.INSERTA (X.CodCia, X.CodEmpresa, nIdPoliza, nIDetPol, nIdEndoso,
                                           'ESV', 'ENDO-' || TRIM(TO_CHAR(nIdPoliza)) || '-' || TRIM(TO_CHAR(nIdEndoso)),
                                           dFecIniVig, dFecFinVig, cCodPlanPago, 0, 0, 0, '010', NULL);
                     END IF;
                     OC_ASEGURADO_CERTIFICADO.INSERTA(X.CodCia, nIdpoliza, nIDetPol, nCod_Asegurado, nIdEndoso);
                  END IF;
               ELSE
                  RAISE_APPLICATION_ERROR(-20225,'Asegurado No. : ' || nCod_Asegurado || ' Duplicado en Certificado No. ' || nIDetPol);
               END IF;

               nMontoAporteAseg := 0;
               FOR I IN C_CAMPOS_ASEG LOOP
                  nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla, X.CodCia, X.CodEmpresa, I.OrdenProceso) + 5 + nOrden;

                  IF UPPER(I.NomCampo) IN ('APORTE_EMPLEADO', 'APORTE_CONTRATANTE') THEN
                     nMontoAporteAseg := NVL(nMontoAporteAseg,0) +
                                         TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc, nOrdenInc, cSeparador)));
                  END IF;
                  cUpdate   := 'UPDATE '||'ASEGURADO_CERTIFICADO'||' '||'SET'||' '||'CAMPO'||I.OrdenDatoPart||'='||''''||
                               LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(X.RegDatosProc, nOrdenInc, cSeparador)||''''||' '||
                               'WHERE IdPoliza = '||nIdPoliza|| ' AND IDetPol = ' || nIDetPol || ' AND CodCia = ' || X.CodCia ||
                               'AND Cod_Asegurado = ' || nCod_Asegurado);
                  OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate);
                  nOrden := nOrden + 1;
               END LOOP;

               UPDATE ASEGURADO_CERTIFICADO
                  SET MontoAporteAseg = NVL(nMontoAporteAseg,0)
                WHERE CodCia        = X.CodCia
                  AND IdPoliza      = nIdPoliza
                  AND IDetPol       = nIDetPol
                  AND Cod_Asegurado = nCod_Asegurado;

               /* Se quita temporalmente la carga de coberturas para agilizar el proceso de Emisión y solo se deja para Endosos*/
               --IF NVL(nIdEndoso,0) != 0 THEN
                  IF OC_COBERT_ACT_ASEG.EXISTE_COBERTURA (X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob,
                                                         nIdPoliza, nIDetPol, nCod_Asegurado) = 'N' THEN
                     IF NVL(cIndSinAseg,'N') = 'N' THEN
                        IF NVL(nIdSolicitud,0) = 0 THEN
--                           OC_COBERT_ACT_ASEG.CARGAR_COBERTURAS(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob,
--                                                                nIdPoliza, nIDetPol, nTasaCambio, nCod_Asegurado);
                            BEGIN
                               OC_COBERT_ACT_ASEG.CARGAR_COBERTURAS(X.CodCia, X.CodEmpresa, X.IdTipoSeg, X.PlanCob, nIdPoliza,
                                                                    nIDetPol, nTasaCambio, nCod_Asegurado, NULL, 0, 0, 0, 0, 99, 0, 0, 0, 0, 0, 0);
                            EXCEPTION
                               WHEN OTHERS THEN
                                  NULL;
                            END;
                        ELSE
                           OC_SOLICITUD_COBERTURAS.TRASLADA_COBERTURAS(X.CodCia, X.CodEmpresa, nIdSolicitud, nIdPoliza, nIDetPol, nCod_Asegurado);
                           OC_SOLICITUD_ASISTENCIAS.TRASLADA_ASISTENCIAS(X.CodCia, X.CodEmpresa, nIdSolicitud, nIdPoliza, nIDetPol, nCod_Asegurado);
                        END IF;
                     END IF;
                     IF NVL(nIdEndoso,0) != 0 THEN
                        UPDATE COBERT_ACT_ASEG
                           SET IdEndoso = nIdEndoso
                         WHERE CodCia        = X.CodCia
                           AND IdPoliza      = nIdPoliza
                           AND IDetPol       = nIDetPol
                           AND Cod_Asegurado = nCod_Asegurado;
                     END IF;
                     OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(X.CodCia, X.CodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado);
                     GT_FAI_FONDOS_DETALLE_POLIZA.CREA_FONDOS_AUTOMATICOS(X.CodCia, X.CodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado);
                     GT_FAI_FONDOS_DETALLE_POLIZA.ACTUALIZA_APORTE_INICIAL(X.CodCia, X.CodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado);
                  END IF;
               --END IF;
            END IF;

            IF OC_AGENTES_DETALLES_POLIZAS.EXISTE_AGENTE (X.CodCia, nIdPoliza, nIDetPol, X.IdTipoSeg, nCod_Agente) = 'N' THEN
               IF nCod_Agente IS NOT NULL THEN
                  OC_AGENTES_DETALLES_POLIZAS.INSERTA_AGENTE(X.CodCia, nIdPoliza, nIDetPol, X.IdTipoSeg, nCod_Agente);
               END IF;
            END IF;
--            OC_POLIZAS.INSERTA_REQUISITOS(X.CodCia, nIdPoliza);     --REQ
            IF NVL(cIndSinAseg,'N') = 'N' OR NVL(nIdEndoso,0) = 0 THEN
               OC_POLIZAS.ACTUALIZA_VALORES(X.CodCia, nIdPoliza, 0);
               OC_DETALLE_POLIZA.ACTUALIZA_VALORES(X.CodCia, nIdPoliza, nIDetPol, 0);
            ELSIF NVL(nIdEndoso,0) != 0 THEN
               OC_ENDOSO.ACTUALIZA_VALORES(X.CodCia, X.CodEmpresa, nIdPoliza, nIDetPol, nIdEndoso);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               cMsjError := SQLERRM;
         END ;
         IF cMsjError = 'N'   THEN
            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'PROCE');
         ELSE
            ROLLBACK;
            OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo, 'AUTOMATICO', '20225', 'No se puede emitir la Póliza o Cargar el Asegurado: '||cMsjError);
            OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'ERROR');
         END IF;
      ELSE
         OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'ERROR');
      END IF;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo, 'AUTOMATICO', '20225', 'No se puede emitir la Póliza o Cargar el Asegurado con Fondos: '||SQLERRM);
      OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'ERROR');
END ASEGURADOS_CON_FONDOS;

PROCEDURE COBRANZA_APORTES_ASEG_FONDOS(nIdProcMasivo NUMBER) IS
cMsjError            PROCESOS_MASIVOS_LOG.TxtError%TYPE := 'N';
cCodPlantilla        CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE;
cNomTabla            CONFIG_PLANTILLAS_CAMPOS.NomTabla%TYPE;
cCampo               CONFIG_PLANTILLAS_CAMPOS.NomCampo%TYPE;
nCod_Asegurado       ASEGURADO.Cod_Asegurado%TYPE;
nCodCia              POLIZAS.CodCia%TYPE;
nCodEmpresa          POLIZAS.CodEmpresa%TYPE;
cTipoDocIdentAseg    PERSONA_NATURAL_JURIDICA.Tipo_Doc_Identificacion%TYPE;
cNumDocIdentAseg     PERSONA_NATURAL_JURIDICA.Num_Doc_Identificacion%TYPE;
nMontoAporteAseg     ASEGURADO_CERTIFICADO.MontoAporteAseg%TYPE;
nMontoAporteContrat  ASEGURADO_CERTIFICADO.MontoAporteAseg%TYPE;
cTipoSeparador       CONFIG_PLANTILLAS.TipoSeparador%TYPE;
nOrdenProceso        CONFIG_PLANTILLAS_TABLAS.OrdenProceso%TYPE;
nOrdenCampo          CONFIG_PLANTILLAS_CAMPOS.OrdenCampo%TYPE;
cReferenciaCobro     ASEGURADO_CERTIFICADO.Campo1%TYPE;
nIdFactura           FACTURAS.IdFactura%TYPE;
nIdTransaccion       TRANSACCION.IdTransaccion%TYPE := 0;
cNomCampo            CONFIG_PLANTILLAS_CAMPOS.NomCampo%TYPE;
nIdPoliza            POLIZAS.IdPoliza%TYPE;
cStsPoliza           POLIZAS.StsPoliza%TYPE;
nIDetPol             DETALLE_POLIZA.IDetPol%TYPE;
cValorCampo          VARCHAR2(1000);
cSeparador           VARCHAR2(1);
nOrden               NUMBER(10):= 1;
nOrdenInc            NUMBER(10) ;
dFechaCobro          DATE;
nIdPagoFact          NUMBER(1);

CURSOR C_CAMPOS (cNomTabla VARCHAR2) IS
   SELECT NomCampo, OrdenCampo, OrdenProceso, TipoCampo
     FROM CONFIG_PLANTILLAS_CAMPOS
    WHERE CodPlantilla = cCodPlantilla
      AND CodEmpresa   = nCodEmpresa
      AND NomTabla     = cNomTabla
      AND CodCia       = nCodCia
    ORDER BY OrdenCampo;

CURSOR C_CAMPOS_ASEG  IS
   SELECT NomCampo, OrdenCampo, OrdenProceso, OrdenDatoPart
     FROM CONFIG_PLANTILLAS_CAMPOS
    WHERE CodPlantilla = cCodPlantilla
      AND CodEmpresa   = nCodEmpresa
      AND CodCia       = nCodCia
      AND NomTabla     = 'ASEGURADO_CERTIFICADO'
      AND IndAseg      = 'S'
    ORDER BY OrdenDatoPart, OrdenCampo;

CURSOR COB_Q IS
   SELECT CodCia, CodEmpresa, IdTipoSeg, PlanCob, NumPolUnico,
          NumDetUnico, RegDatosProc, TipoProceso, IndColectiva,
          IndAsegurado
     FROM PROCESOS_MASIVOS
    WHERE IdProcMasivo   = nIdProcMasivo;
BEGIN
   FOR W IN COB_Q LOOP
      BEGIN
         SELECT IdPoliza, StsPoliza
           INTO nIdPoliza, cStsPoliza
           FROM POLIZAS
          WHERE NumPolUnico     = W.NumPolUnico
            AND CodCia          = W.CodCia
            AND CodEmpresa      = W.CodEmpresa
            AND StsPoliza       = 'EMI';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20225,'NO Existe Emitida la Póliza No. ' || W.NumPolUnico ||
                                    ' para Realizar la Cobranza de Aportes de Asegurados con Fondos');
      END;

      BEGIN
         SELECT IDetPol
           INTO nIDetPol
           FROM DETALLE_POLIZA
          WHERE CodCia      = W.CodCia
            AND CodEmpresa  = W.CodEmpresa
            AND IdPoliza    = nIdpoliza
            AND NumDetRef   = TRIM(TO_CHAR(W.NumDetUnico))
            AND IdTipoSeg   = W.IdTipoSeg
            AND PlanCob     = W.PlanCob;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20225,'Certificado/Subgurpo NO Existe: '|| TRIM(TO_CHAR(W.NumDetUnico)) ||
                                    ' Con el Producto ' || W.IdTipoSeg || ' y el Plan de Coberturas ' || W.PlanCob);
      END;
      nCodCia           := W.CodCia;
      nCodEmpresa       := W.CodEmpresa;
      cCodPlantilla     := OC_CONFIG_PLANTILLAS_PLANCOB.CODIGO_PLANTILLA(W.CodCia, W.CodEmpresa, W.IdTipoSeg, W.PlanCob, W.TipoProceso);
      cTipoSeparador    := OC_CONFIG_PLANTILLAS.TIPO_SEPARADOR(W.CodCia, W.CodEmpresa, cCodPlantilla);
      IF cTipoSeparador = 'PIP' THEN
         cSeparador := '|';
      ELSIF cTipoSeparador = 'COM' THEN
         cSeparador := ',';
      END IF;
      cNomTabla         := 'PERSONA_NATURAL_JURIDICA';
      nOrdenProceso     := GT_CONFIG_PLANTILLAS_TABLAS.ORDEN_PROCESO(W.CodCia, W.CodEmpresa, cCodPlantilla, cNomTabla);
      nOrdenCampo       := 1;
      cTipoDocIdentAseg := 'RFC';
      FOR Y IN C_CAMPOS(cNomTabla) LOOP
         cValorCampo := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(W.RegDatosProc, nOrdenCampo + 5, cSeparador));
         cNomCampo   := OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(W.CodCia, W.CodEmpresa, cCodPlantilla, nOrdenCampo);
         IF cNomCampo = 'NUM_DOC_IDENTIFICACION' THEN
            cNumDocIdentAseg  := cValorCampo;
            EXIT;
         END IF;
         nOrdenCampo := nOrdenCampo + 1;
      END LOOP;

      --nCod_Asegurado := OC_ASEGURADO.CODIGO_ASEGURADO(W.CodCia, W.CodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
      IF nIDetPol = 1 THEN
         SELECT DISTINCT Cod_Asegurado
           INTO nCod_Asegurado
           FROM ASEGURADO_CERTIFICADO
          WHERE CodCia     = W.CodCia
            AND IdPoliza   = nIdPoliza
            AND IDetPol    = nIDetPol;
      ELSE
         nCod_Asegurado := OC_ASEGURADO.CODIGO_ASEGURADO(W.CodCia, W.CodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
      END IF;

      IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(W.CodCia, nIdPoliza, nIDetPol, nCod_Asegurado) = 'S' THEN
         nMontoAporteContrat := 0;
         nMontoAporteAseg    := 0;
         FOR I IN C_CAMPOS_ASEG LOOP
            nOrdenInc := OC_PROCESOS_MASIVOS.VALOR_POSICION (cCodPlantilla, W.CodCia, W.CodEmpresa, I.OrdenProceso) + 5 + nOrden;

            IF UPPER(I.NomCampo) = 'APORTE_CONTRATANTE' THEN
               nMontoAporteContrat := NVL(nMontoAporteContrat,0) +
                                      TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(W.RegDatosProc, nOrdenInc, cSeparador)));
            ELSIF UPPER(I.NomCampo) = 'APORTE_EMPLEADO' THEN
               nMontoAporteAseg    := NVL(nMontoAporteAseg,0) +
                                      TO_NUMBER(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(W.RegDatosProc, nOrdenInc, cSeparador)));
            ELSIF UPPER(I.NomCampo) = 'REFERENCIA' THEN
               cReferenciaCobro    := LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(W.RegDatosProc, nOrdenInc, cSeparador));
            END IF;
            nOrden := nOrden + 1;
         END LOOP;

         IF NVL(nMontoAporteAseg,0) = 0 AND NVL(nMontoAporteContrat,0) = 0 THEN
            RAISE_APPLICATION_ERROR(-20225,'Contratante o Asegurado No. '|| TRIM(TO_CHAR(nCod_Asegurado)) ||
                                    ' No tiene Aporte al Fondo en Registro');
         ELSIF cReferenciaCobro IS NULL THEN
            RAISE_APPLICATION_ERROR(-20225,'La Referencia de Cobro es NULA para el Asegurado No. '|| TRIM(TO_CHAR(nCod_Asegurado)) ||
                                    ' NO se puede Procesar Cobranza');
         ELSE
            SELECT NVL(MAX(IdFactura),0)
              INTO nIdFactura
              FROM FACTURAS
             WHERE CodCia     = W.CodCia
               AND IdPoliza   = nIdPoliza
               AND StsFact    = 'EMI';

            IF NVL(nIdFactura,0) = 0 THEN
               SELECT NVL(MAX(IdFactura),0)
                 INTO nIdFactura
                 FROM FACTURAS
                WHERE CodCia     = W.CodCia
                  AND IdPoliza   = nIdPoliza
                  AND StsFact    = 'PAG';
            END IF;
            IF NVL(nIdFactura,0) = 0 THEN
               RAISE_APPLICATION_ERROR(-20225,'NO Existen Facturas Emitidas o Pagadas en la Póliza No. ' || nIdPoliza);
            ELSE
               BEGIN
                  IF OC_SUB_PROCESO.INDICA_FEC_EQUIVALENTE_SUBPROC(12, 'PAG') = 'S' THEN
                     dFechaCobro  := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_CONTABLE(W.CodCia, W.CodEmpresa);
                  ELSE
                     dFechaCobro  := TRUNC(SYSDATE);
                  END IF;

                  nIdPagoFact := OC_FACTURAS.PAGAR_FONDOS(nIdFactura, cReferenciaCobro || '-' || TO_CHAR(TRUNC(dFechaCobro),'DDMMRRRR'),
                                                          dFechaCobro, 0, 'DXN', NULL, nIdTransaccion, 0,
                                                          NVL(nMontoAporteAseg,0) + NVL(nMontoAporteContrat,0));

                  IF NVL(nMontoAporteAseg,0) > 0 THEN
                     BEGIN
                        GT_FAI_FONDOS_DETALLE_POLIZA.APORTACION_COLECTIVA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                          nCod_Asegurado, NVL(nMontoAporteAseg,0));
                     EXCEPTION
                        WHEN OTHERS THEN
                           ROLLBACK;
                           OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo, 'AUTOMATICO', '20225',
                                                               'Error en Aportación Colectiva del Contratante al Asegurado de la Referencia: ' ||
                                                               cReferenciaCobro);
                           OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'ERROR');
                     END;
                  END IF;

                  OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'PROCE');
               EXCEPTION
                  WHEN OTHERS THEN
                      ROLLBACK;
                      OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo, 'AUTOMATICO', '20225',
                                                          'Error en Cobranza de Aporte al Fondo de la Referencia: ' || cReferenciaCobro);
                      OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'ERROR');
               END;
            END IF;
         END IF;
      ELSE
         RAISE_APPLICATION_ERROR(-20225,'Asegurado No. '|| TRIM(TO_CHAR(nCod_Asegurado)) ||
                                 ' No Existe Emitido en Póliza No. ' || nIdPoliza);
      END IF;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      OC_PROCESOS_MASIVOS_LOG.INSERTA_LOG(nIdProcMasivo, 'AUTOMATICO', '20225',
                                          'Error en Cobranza de Aporte al Fondo de la Referencia: ' || cReferenciaCobro || ' ' || SQLERRM);
      OC_PROCESOS_MASIVOS.ACTUALIZA_STATUS(nIdProcMasivo, 'ERROR');
END COBRANZA_APORTES_ASEG_FONDOS;

   PROCEDURE CARGA_ARCHIVO_ASEGURADOS ( nCodCia             NUMBER
                                      , cNumPolUnico        VARCHAR2
                                      , cTipoProceso        VARCHAR2
                                      , cIndCol             VARCHAR2
                                      , cCodUsuario         VARCHAR2
                                      , cIndAsegurado       VARCHAR2
                                      , cNombreArchivo      VARCHAR2
                                      , cRegsTotales   OUT  NUMBER
                                      , cRegsCargados  OUT  NUMBER
                                      , cRegsErroneos  OUT  NUMBER ) IS
      nCodEmpresa              POLIZAS.CodEmpresa%TYPE;
      cIdTipoSeg               DETALLE_POLIZA.IdTipoSeg%TYPE;
      cPlanCob                 DETALLE_POLIZA.PlanCob%TYPE;
      cCodPlantilla            CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE;
      --cSeparador1         VARCHAR2(10) := 'SICAS';
      cSeparador               VARCHAR2(1);
      cRegDatosProc            VARCHAR2(4000);
      cNumDetUnico             PROCESOS_MASIVOS.NumDetUnico%TYPE;
      cNumPolUnicoFinal        PROCESOS_MASIVOS.NumPolUnico%TYPE;
      nIdProcMasivo            NUMBER := 0;
      cNum_Doc_Identificacion  CARGA_ASEGURADOS_EXT.Num_Doc_Identificacion%TYPE;
      --
      CURSOR cRegistros IS
             SELECT *
             FROM   CARGA_ASEGURADOS_EXT
             ORDER BY CodEmpresa, IdTipoSeg, Plancob, Numpolunico, Subgrupo;
   BEGIN
      cRegsTotales   := 0;
      cRegsCargados  := 0;
      cRegsErroneos  := 0;
      --
      FOR x IN cRegistros LOOP
          cRegsTotales := cRegsTotales + 1;
          --
          IF ( nCodEmpresa IS NULL AND cIdTipoSeg IS NULL AND cPlanCob IS NULL ) OR ( nCodEmpresa <> x.CodEmpresa OR cIdTipoSeg <> x.IdTipoSeg OR cPlanCob <> x.PlanCob ) THEN
             nCodEmpresa   := x.CodEmpresa;
             cIdTipoSeg    := TRIM(x.IdTipoSeg);
             cPlanCob      := TRIM(x.Plancob);
             --
             cCodPlantilla := OC_CONFIG_PLANTILLAS_PLANCOB.CODIGO_PLANTILLA( nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, cTipoProceso );
             cSeparador    := OC_PROCESOS_MASIVOS.TIPO_SEPARADOR(cCodPlantilla);
          END IF;
          --
          IF NVL(cIndCol, 'N') = 'S' AND cNumPolUnico IS NOT NULL THEN 
             cNumPolUnicoFinal := TRIM(cNumPolUnico);
          ELSE
             cNumPolUnicoFinal := TRIM(x.Numpolunico);
          END IF;
          --
          cNumDetUnico            := x.Subgrupo;
          nIdProcMasivo           := OC_PROCESOS_MASIVOS.CREAR(nCodCia, nCodEmpresa);
          cNum_Doc_Identificacion := REPLACE(UPPER(TRIM(x.Num_Doc_Identificacion)), 'Ñ', 'N');
          --
          cRegDatosProc := x.CodEmpresa                                     || cSeparador || UPPER(DEPURA_CADENA(TRIM(x.IdTipoSeg)))     || cSeparador || UPPER(DEPURA_CADENA(TRIM(x.PlanCob)))                 || cSeparador ||
                           cNumPolUnicoFinal                                || cSeparador || x.SubGrupo                                  || cSeparador || UPPER(DEPURA_CADENA(TRIM(x.Tipo_Doc_Identificacion))) || cSeparador ||
                           UPPER(DEPURA_CADENA(cNum_Doc_Identificacion))    || cSeparador || UPPER(DEPURA_CADENA(TRIM(x.Nombre)))        || cSeparador || UPPER(DEPURA_CADENA(TRIM(x.Apellido_Paterno)))        || cSeparador ||
                           UPPER(DEPURA_CADENA(TRIM(x.Apellido_Materno)))   || cSeparador || UPPER(DEPURA_CADENA(TRIM(x.Sexo)))          || cSeparador || TO_CHAR(x.FecNacimiento, 'DD/MM/YYYY')                || cSeparador ||
                           UPPER(DEPURA_CADENA(TRIM(x.Tipo_Id_Tributaria))) || cSeparador || UPPER(DEPURA_CADENA(TRIM(x.Numtributario))) || cSeparador || TO_CHAR(x.FecIngreso, 'DD/MM/YYYY')                   || cSeparador ||
                           TO_CHAR(x.FecStatus, 'DD/MM/YYYY')               || cSeparador || UPPER(DEPURA_CADENA(TRIM(x.DirecRes)))      || cSeparador || DEPURA_CADENA(TRIM(x.CodigoZip))                      || cSeparador ||
                           DEPURA_CADENA(TRIM(x.ClienteUnico))              || cSeparador || TO_CHAR(x.FecIniVig, 'DD/MM/YYYY')          || cSeparador || TO_CHAR(x.FecFinVig, 'DD/MM/YYYY')                    || cSeparador ||
                           TO_CHAR(x.FecIniVig2, 'DD/MM/YYYY')              || cSeparador || TO_CHAR(x.FecFinVig2, 'DD/MM/YYYY')         || cSeparador || x.SumaAsegurada                                       || cSeparador || 
                           x.Sueldo                                         || cSeparador || x.Nutra                                     || cSeparador || x.VecesSalario                                        || cSeparador || 
                           x.CampoFlexible1                                 || cSeparador || x.CampoFlexible2                            || cSeparador || x.CampoFlexible3                                      || cSeparador ||
                           x.CampoFlexible4                                 || cSeparador || x.CampoFlexible5                            || cSeparador || x.CampoFlexible6;
          --
          BEGIN
             INSERT INTO PROCESOS_MASIVOS
                ( IdProcMasivo, CodCia      , CodEmpresa , IdTipoSeg  , PlanCob     , TipoProceso , StsRegProceso,
                  FecSts      , RegDatosProc, NumPolUnico, NumDetUnico, IndColectiva, IndAsegurado, CodUsuario   , NomArchivoCarga )
             VALUES( nIdProcMasivo , nCodCia      , nCodEmpresa      , cIdTipoSeg  , cPlanCob, cTipoProceso , 'XPROC'    ,
                     TRUNC(SYSDATE), cRegDatosProc, cNumPolUnicoFinal, cNumDetUnico, cIndCol , cIndAsegurado, cCodUsuario, cNombreArchivo );
             --
             cRegsCargados := cRegsCargados + 1;
          EXCEPTION
          WHEN OTHERS THEN
               cRegsErroneos := cRegsErroneos + 1;
               --PROC_CREA_ARCH_ERRORES(cLinea||'-->'||cMsgArchErr, 'XXX', cCodUser, nLinea);
          END;
      END LOOP;
   END CARGA_ARCHIVO_ASEGURADOS;

   FUNCTION DEPURA_CADENA ( cCadenaEntrada  VARCHAR2 ) RETURN VARCHAR2 IS
      cCadenaSalida  VARCHAR2(500);
      cCodigosMal    VARCHAR2(100) := 'áàâäãåÁÀÂÄÃÅçÇéèêëÉÈÊËíìîïÍÌÎÏ¥¤óòôöõðÓÒÔÖÕÐšŠúùûüÚÙÛÜýÿÝŸžŽ.,:;/*+-()~';
      cCodigosBien   VARCHAR2(100) := 'aaaaaaAAAAAAcCeeeeEEEEiiiiIIIIññooooooOOOOOOsSuuuuUUUUyyYYzZ';
   BEGIN
      cCadenaSalida :=  UPPER(TRANSLATE(LTRIM(cCadenaEntrada), cCodigosMal, cCodigosBien));
      --
      RETURN(cCadenaSalida);
   END DEPURA_CADENA;

   PROCEDURE RECUPERA_LOG_CARGA( cNomArchCarga  VARCHAR2
                               , cNomArcSalida  VARCHAR2 ) IS
      cNomDirectorio   VARCHAR2(100);
      cCtlArchivo1     UTL_FILE.FILE_TYPE;
      cCtlArchivo2     UTL_FILE.FILE_TYPE;
      cCtlArchivo3     UTL_FILE.FILE_TYPE;
      cNomArchivoBad   VARCHAR2(100) := 'carga_asegurados.bad';
      cNomArchivoLog   VARCHAR2(100) := 'carga_asegurados.log';
      cNomArchivoRes   VARCHAR2(100) := SUBSTR(cNomArchCarga, 1, INSTR(cNomArchCarga, '.')) || 'log';
      cLine            VARCHAR2(4000);
      cYaEsError       VARCHAR2(1) := 'N';
      nTotReg          NUMBER := 0;
      cCampoFlexible1  CARGA_ASEGURADOS_LOG.CampoFlexible1%TYPE;
      cCampoFlexible2  CARGA_ASEGURADOS_LOG.CampoFlexible2%TYPE;
      cCampoFlexible3  CARGA_ASEGURADOS_LOG.CampoFlexible3%TYPE;
      nCampo           NUMBER := 2;
      nNumRegIniErr    NUMBER;
      cCadena          VARCHAR2(4000);
      cHayArchivoBad   VARCHAR2(1) := 'S';
      --
      CURSOR c_Detalle IS
             SELECT CampoFlexible1 || ',' || CampoFlexible2 || ',' || CampoFlexible3 Cadena
             FROM   CARGA_ASEGURADOS_LOG
             WHERE  NomArchivoCarga = cNomArchCarga
             ORDER BY IdRegistro;
   BEGIN
      DELETE CARGA_ASEGURADOS_LOG
      WHERE  NomArchivoCarga = cNomArchCarga;
      --
      cNomDirectorio := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SO_PATH', 'REPORT');
      cCtlArchivo1   := UTL_FILE.FOPEN(cNomDirectorio, cNomArchivoLog, 'R');
      LOOP
         BEGIN
            UTL_FILE.GET_LINE(cCtlArchivo1, cLine);
            --
            IF cYaEsError = 'N' AND SUBSTR(cLine, 1, 5) = 'error' THEN
               cYaEsError    := 'S';
               nNumRegIniErr := nTotReg + 1;
            END IF;
            --
            IF cYaEsError = 'N' THEN
               nTotReg         := nTotReg + 1;
               cCampoFlexible1 := REPLACE(REPLACE(cLine, 'carga_asegurados.csv', cNomArchCarga), 'Terminated by ","', 'Terminated by "coma"');
               cCampoFlexible2 := NULL;
               cCampoFlexible3 := NULL;
               --
               INSERT INTO CARGA_ASEGURADOS_LOG
               VALUES ( cNomArchCarga, nTotReg, cCampoFlexible1, cCampoFlexible2, cCampoFlexible3 );
            ELSE
               cCampoFlexible1 := NULL;
               IF nCampo = 2 THEN
                  cCampoFlexible2 := REPLACE(cLine, 'carga_asegurados.csv', cNomArchCarga);
                  nCampo          := 3;
               ELSIF nCampo = 3 THEN
                  nTotReg         := nTotReg + 1;
                  cCampoFlexible3 := REPLACE(cLine, 'carga_asegurados.csv', cNomArchCarga);
                  nCampo          := 2;
                  --
                  INSERT INTO CARGA_ASEGURADOS_LOG
                  VALUES ( cNomArchCarga, nTotReg, cCampoFlexible1, cCampoFlexible2, cCampoFlexible3 );
                  --
                  cCampoFlexible1 := NULL;
                  cCampoFlexible2 := NULL;
                  cCampoFlexible3 := NULL;
               END IF;
            END IF;
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
              EXIT;
         END;
      END LOOP;
      UTL_FILE.FCLOSE(cCtlArchivo1);
      --
      BEGIN
         cCtlArchivo2 := UTL_FILE.FOPEN(cNomDirectorio, cNomArchivoBad, 'R');
      EXCEPTION
      WHEN OTHERS THEN
           cHayArchivoBad := 'N';
      END;
      --
      IF cHayArchivoBad = 'S' THEN
         LOOP
            BEGIN
               UTL_FILE.GET_LINE(cCtlArchivo2, cLine);
               --
               UPDATE CARGA_ASEGURADOS_LOG
               SET    CampoFlexible1 = REPLACE(cLine, 'carga_asegurados.csv', cNomArchCarga)
               WHERE  NomArchivoCarga = cNomArchCarga
                 AND  IdRegistro   = nNumRegIniErr;
               --
               nNumRegIniErr := nNumRegIniErr + 1;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 EXIT;
            END;
         END LOOP;
         UTL_FILE.FCLOSE(cCtlArchivo2);
      END IF;
      --
      cCtlArchivo3 := UTL_FILE.FOPEN(cNomDirectorio, cNomArcSalida, 'W', 32767);
      --
      OPEN c_Detalle;
      LOOP
         FETCH c_Detalle INTO cCadena;
         EXIT WHEN c_Detalle%NOTFOUND;
         --
         UTL_FILE.PUT_LINE(cCtlArchivo3, cCadena);
         --
      END LOOP;
      CLOSE c_Detalle;
      UTL_FILE.FCLOSE(cCtlArchivo3);
      UTL_FILE.FCLOSE_ALL;
   END RECUPERA_LOG_CARGA;
END OC_PROCESOS_MASIVOS;