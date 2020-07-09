--
-- GT_AUTORIZA_PROCESOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   USUARIOS (Table)
--   NIVELES_AUTORIZACION (Table)
--   NOMINA_COMISION (Table)
--   OC_ADICIONALES_EMPRESA (Package)
--   SINIESTRO (Table)
--   PROCESOS_MASIVOS (Table)
--   GT_AUTORIZA_PROCESOS_LOG (Package)
--   GT_AUTORIZA_PROCESOS_REGRESO (Package)
--   OC_EMPRESAS (Package)
--   OC_USUARIOS (Package)
--   APROBACIONES (Table)
--   APROBACION_ASEG (Table)
--   AUTORIZA_PROCESOS (Table)
--   AUTORIZA_PROCESOS_LOG (Table)
--   AUTORIZA_PROCESOS_REGRESO (Table)
--   COBERTURA_SINIESTRO (Table)
--   COBERTURA_SINIESTRO_ASEG (Table)
--   OC_GENERALES (Package)
--   OC_MAIL (Package)
--   OC_PROCESO_AUTORIZACION (Package)
--   OC_PROCESO_AUTORIZA_USUARIO (Package)
--   GT_NIVELES_AUTORIZACION (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_AUTORIZA_PROCESOS AS
    FUNCTION NUMERO_AUTORIZACION(nCodCia IN NUMBER) RETURN NUMBER;
    FUNCTION MONTO_AUTORIZACION(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER) RETURN NUMBER;
    FUNCTION EMPLEADO_PROCESA(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER) RETURN NUMBER;
    FUNCTION EMPLEADO_REVISA(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER) RETURN NUMBER;
    FUNCTION ESTATUS_AUTORIZACION(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER) RETURN VARCHAR2;
    FUNCTION PROCESO(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER) RETURN VARCHAR2;
    FUNCTION OBSERVACIONES_RECHAZO(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER) RETURN VARCHAR2;
    FUNCTION CREAR(nCodCia IN NUMBER, cCodProceso IN VARCHAR2, nIdDocProceso IN NUMBER, nMontoProceso IN NUMBER,
                    nIdEmpleadoProcesa IN NUMBER, dFecProcesa IN DATE, cHoraProcesa IN VARCHAR2,nMontoAcumProceso IN NUMBER) RETURN NUMBER;
    FUNCTION VALIDA_AUTORIZACION(nCodCia IN NUMBER,cCodProceso IN VARCHAR2, cCodUsuario IN VARCHAR2, nIdDocProceso IN NUMBER,
                                 cIdTipoSeg IN VARCHAR2, nMontoProceso IN NUMBER, nMontoAcumProceso IN NUMBER) RETURN NUMBER;
    PROCEDURE AUTORIZA(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER);
    PROCEDURE RECHAZA(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER,cObservacionesRechazo IN VARCHAR2);
    PROCEDURE REVISA(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER,cObservaciones IN VARCHAR2);
    PROCEDURE REVIERTE(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER);
    PROCEDURE NOTIFICA(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER,nIdEmpleadoProcesa IN NUMBER,cTipoNotificacion VARCHAR2);
    PROCEDURE REGRESA(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER,cObservaciones IN VARCHAR2);
    PROCEDURE ACTUALIZA(nCodCia IN NUMBER, nIdAutorizacion IN NUMBER, nMontoProceso IN NUMBER,
                        nMontoAcumProceso IN NUMBER, dFecProcesa IN DATE, cHoraProcesa IN VARCHAR2);
    PROCEDURE ORIGEN(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER, nIdDocOrigen IN OUT NUMBER, cNomDocOrigen IN OUT VARCHAR2, cIdObjeto IN OUT VARCHAR2);
    PROCEDURE AGREGA_DETALLE(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER);
END GT_AUTORIZA_PROCESOS;
/

--
-- GT_AUTORIZA_PROCESOS  (Package Body) 
--
--  Dependencies: 
--   GT_AUTORIZA_PROCESOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_AUTORIZA_PROCESOS AS
   FUNCTION NUMERO_AUTORIZACION(nCodCia IN NUMBER) RETURN NUMBER IS
      nIdAutorizacion AUTORIZA_PROCESOS.IdAutorizacion%TYPE;
   BEGIN
      SELECT NVL(MAX(IdAutorizacion),0) + 1
        INTO nIdAutorizacion
        FROM AUTORIZA_PROCESOS
       WHERE CodCia     = nCodCia;

      RETURN nIdAutorizacion;
   END NUMERO_AUTORIZACION;
    --
    FUNCTION MONTO_AUTORIZACION(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER) RETURN NUMBER IS
        nMontoProceso AUTORIZA_PROCESOS.MontoProceso%TYPE;
    BEGIN
        BEGIN
            SELECT NVL(MontoProceso,0)
              INTO nMontoProceso
              FROM AUTORIZA_PROCESOS
             WHERE CodCia          = nCodCia
               AND IdAutorizacion  = nIdAutorizacion;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                nMontoProceso := 0;
        END;

        RETURN nMontoProceso;
    END MONTO_AUTORIZACION;
    --
    FUNCTION EMPLEADO_PROCESA(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER) RETURN NUMBER IS
        nIdEmpleadoProcesa AUTORIZA_PROCESOS.IdEmpleadoProcesa%TYPE;
    BEGIN
        BEGIN
            SELECT IdEmpleadoProcesa
              INTO nIdEmpleadoProcesa
              FROM AUTORIZA_PROCESOS
             WHERE CodCia          = nCodCia
               AND IdAutorizacion  = nIdAutorizacion;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                nIdEmpleadoProcesa := 1;
        END;

        RETURN nIdEmpleadoProcesa;
    END EMPLEADO_PROCESA;
    --
    FUNCTION EMPLEADO_REVISA(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER) RETURN NUMBER IS
        nIdEmpleadoRevisa AUTORIZA_PROCESOS.IdEmpleadoRevisa%TYPE;
    BEGIN
        BEGIN
            SELECT IdEmpleadoRevisa
              INTO nIdEmpleadoRevisa
              FROM AUTORIZA_PROCESOS
             WHERE CodCia          = nCodCia
               AND IdAutorizacion  = nIdAutorizacion;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                nIdEmpleadoRevisa := 1;
        END;

        RETURN nIdEmpleadoRevisa;
    END EMPLEADO_REVISA;
    --
    FUNCTION ESTATUS_AUTORIZACION(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER) RETURN VARCHAR2 IS
        cStsAutorizacion AUTORIZA_PROCESOS.StsAutorizacion%TYPE;
    BEGIN
        BEGIN
            SELECT StsAutorizacion
              INTO cStsAutorizacion
              FROM AUTORIZA_PROCESOS
             WHERE CodCia          = nCodCia
               AND IdAutorizacion  = nIdAutorizacion;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                cStsAutorizacion := 'NA';
        END;
        RETURN cStsAutorizacion;
    END;
    --
    FUNCTION PROCESO(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER) RETURN VARCHAR2 IS
        cCodProceso AUTORIZA_PROCESOS.CodProceso%TYPE;
    BEGIN
        BEGIN
            SELECT CodProceso
              INTO cCodProceso
              FROM AUTORIZA_PROCESOS
             WHERE CodCia          = nCodCia
               AND IdAutorizacion  = nIdAutorizacion;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                cCodProceso := 'NA';
        END;
        RETURN cCodProceso;
    END PROCESO;
    --
    FUNCTION OBSERVACIONES_RECHAZO(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER) RETURN VARCHAR2 IS
        cObservacionesRechazo AUTORIZA_PROCESOS.ObservacionesRechazo%TYPE;
    BEGIN
        SELECT ObservacionesRechazo
          INTO cObservacionesRechazo
          FROM AUTORIZA_PROCESOS
         WHERE CodCia          = nCodCia
           AND IdAutorizacion  = nIdAutorizacion;

        RETURN cObservacionesRechazo;
    END OBSERVACIONES_RECHAZO;
    --
   FUNCTION CREAR(nCodCia IN NUMBER, cCodProceso IN VARCHAR2, nIdDocProceso IN NUMBER, nMontoProceso IN NUMBER,
                    nIdEmpleadoProcesa IN NUMBER, dFecProcesa IN DATE, cHoraProcesa IN VARCHAR2,nMontoAcumProceso IN NUMBER) RETURN NUMBER IS
      nIdAutorizacion         AUTORIZA_PROCESOS.IdAutorizacion%TYPE;
      dFechaStatus            AUTORIZA_PROCESOS.FechaStatus%TYPE;
      cHoraPasaAutorizacion   AUTORIZA_PROCESOS.HoraPasaAutorizacion%TYPE;
      dFecPasaAutorizacion    AUTORIZA_PROCESOS.FecPasaAutorizacion%TYPE;
      nIdEmpleadoAutoriza     AUTORIZA_PROCESOS.IdEmpleadoAutoriza%TYPE;
      nIdEmpleadoRevisa       AUTORIZA_PROCESOS.IdEmpleadoRevisa%TYPE;
      cObservaciones          AUTORIZA_PROCESOS.Observaciones%TYPE:= '';

   BEGIN
      dFechaStatus          := TRUNC(SYSDATE);
      dFecPasaAutorizacion  := TRUNC(SYSDATE);
      cHoraPasaAutorizacion := TO_CHAR(SYSDATE,'HH24:MI:SS');
      nIdAutorizacion       := GT_AUTORIZA_PROCESOS.NUMERO_AUTORIZACION(nCodCia);
      nIdEmpleadoAutoriza   := GT_NIVELES_AUTORIZACION.SUPERIOR_QUE_AUTORIZA(nCodCia,nIdEmpleadoProcesa, nMontoProceso);-- DEBERA CAMBIARSE POR LA RUTINA DE AUTORIZACIONES POR MONTO
      nIdEmpleadoRevisa     := GT_NIVELES_AUTORIZACION.EMPLEADO_SUPERIOR(nCodCia,nIdEmpleadoProcesa);

      INSERT INTO AUTORIZA_PROCESOS(CodCia,             IdAutorizacion, CodProceso,   IdDocProceso,         MontoProceso,
                                    IdEmpleadoProcesa,  FecProcesa,     HoraProcesa,  FecPasaAutorizacion,  HoraPasaAutorizacion,
                                    IdEmpleadoAutoriza, FecAutoriza,    HoraAutoriza, IdEmpleadoRevisa,     FecRevisa,
                                    HoraRevisa,         FecRechazo,     HoraRechazo,  ObservacionesRechazo, StsAutorizacion,
                                    FechaStatus,        Observaciones,  MontoAcumProceso)
                             VALUES(nCodCia,            nIdAutorizacion,cCodProceso,  nIdDocProceso,        nMontoProceso,
                                    nIdEmpleadoProcesa, dFecProcesa,    cHoraProcesa, dFecPasaAutorizacion, cHoraPasaAutorizacion,
                                    nIdEmpleadoAutoriza,NULL,           NULL,         nIdEmpleadoRevisa,    NULL,
                                    NULL,               NULL,           NULL,         NULL,                 'PENDIENTE',
                                    TRUNC(SYSDATE),     cObservaciones, nMontoAcumProceso);
      --GT_AUTORIZA_PROCESOS.AGREGA_DETALLE(nCodCia,nIdAutorizacion);                                       
      RETURN nIdAutorizacion;
   END CREAR;
    --
    FUNCTION VALIDA_AUTORIZACION(nCodCia IN NUMBER,cCodProceso IN VARCHAR2, cCodUsuario IN VARCHAR2, nIdDocProceso IN NUMBER,
                                 cIdTipoSeg IN VARCHAR2, nMontoProceso IN NUMBER, nMontoAcumProceso IN NUMBER) RETURN NUMBER IS
        nIdAutorizacionProc AUTORIZA_PROCESOS.IdAutorizacion%TYPE;
        nIdEmpleadoProcesa  NIVELES_AUTORIZACION.IdEmpleado%TYPE;
        dFecProcesa         AUTORIZA_PROCESOS.FecProcesa%TYPE;
        cHoraProcesa        AUTORIZA_PROCESOS.HoraProcesa%TYPE;
    BEGIN
        dFecProcesa         := TRUNC(SYSDATE);
        cHoraProcesa        := TO_CHAR(SYSDATE,'HH24:MI:SS');
        nIdEmpleadoProcesa  := GT_NIVELES_AUTORIZACION.NUMERO_EMPLEADO(nCodCia,cCodUsuario);
        IF OC_PROCESO_AUTORIZA_USUARIO.PROCESO_AUTORIZADO(nCodCia , cCodProceso, cCodUsuario, cIdTipoSeg, nMontoProceso) = 'N' THEN
            IF OC_PROCESO_AUTORIZACION.APLICA_NIVEL_JERARQUICO(nCodCia, cCodProceso) = 'S' THEN
                nIdAutorizacionProc := GT_AUTORIZA_PROCESOS.CREAR(nCodCia, cCodProceso, nIdDocProceso, nMontoProceso, nIdEmpleadoProcesa, dFecProcesa, cHoraProcesa,nMontoAcumProceso);
                --GT_AUTORIZA_PROCESOS.NOTIFICA(nCodCia,nIdAutorizacionProc,nIdEmpleadoProcesa,'NA');
            ELSE
                --nDummy := STOPALERT('Su Perfil de Usuario NO Permite Generar Este Tipo de Oeraciones Y NO Tiene Asignado un Nivel Gerárquico Superior que le Autorice, Valide con su Supervisor: '||SQLERRM);
                RAISE_APPLICATION_ERROR(-20225,'Su Perfil de Usuario NO Permite Generar Este Tipo de Oeraciones Y el Proceso no Tiene Configuración Para Determinar su Nivel Jerárquico, por Favor Valide');
            END IF;
        END IF;
        RETURN nIdAutorizacionProc;
    END VALIDA_AUTORIZACION;
    --
    PROCEDURE AUTORIZA(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER) IS
        nIdEmpleadoProcesa AUTORIZA_PROCESOS.IdEmpleadoProcesa%TYPE;
    BEGIN
        UPDATE AUTORIZA_PROCESOS
           SET StsAutorizacion = 'AUTORIZADA',
               FechaStatus     = TRUNC(SYSDATE),
               FecAutoriza     = TRUNC(SYSDATE),
               HoraAutoriza    = TO_CHAR(SYSDATE,'HH24:MI:SS')
         WHERE CodCia          = nCodCia
           AND IdAutorizacion  = nIdAutorizacion;

        nIdEmpleadoProcesa := GT_AUTORIZA_PROCESOS.EMPLEADO_PROCESA(nCodCia,nIdAutorizacion);
        GT_AUTORIZA_PROCESOS.NOTIFICA(nCodCia,nIdAutorizacion,nIdEmpleadoProcesa,'NR');
    END AUTORIZA;
    --
    PROCEDURE RECHAZA(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER,cObservacionesRechazo IN VARCHAR2) IS
        nIdEmpleadoProcesa AUTORIZA_PROCESOS.IdEmpleadoProcesa%TYPE;
    BEGIN
        UPDATE AUTORIZA_PROCESOS
           SET StsAutorizacion      = 'RECHAZADA',
               FechaStatus          = TRUNC(SYSDATE),
               FecRechazo           = TRUNC(SYSDATE),
               HoraRechazo          = TO_CHAR(SYSDATE,'HH24:MI:SS'),
               ObservacionesRechazo = cObservacionesRechazo
         WHERE CodCia          = nCodCia
           AND IdAutorizacion  = nIdAutorizacion;

        nIdEmpleadoProcesa := GT_AUTORIZA_PROCESOS.EMPLEADO_PROCESA(nCodCia,nIdAutorizacion);
        GT_AUTORIZA_PROCESOS.NOTIFICA(nCodCia,nIdAutorizacion,nIdEmpleadoProcesa,'NR');
    END RECHAZA;
    --
    PROCEDURE REVISA(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER,cObservaciones IN VARCHAR2) IS
        nIdEmpleadoRevisaAnt    AUTORIZA_PROCESOS.IdEmpleadoRevisa%TYPE;
        nIdEmpleadoRevisa       AUTORIZA_PROCESOS.IdEmpleadoRevisa%TYPE;
        nIdEmpleadoProcesa      AUTORIZA_PROCESOS.IdEmpleadoProcesa%TYPE;
    BEGIN
        nIdEmpleadoRevisaAnt := GT_AUTORIZA_PROCESOS.EMPLEADO_REVISA(nCodCia,nIdAutorizacion);
        nIdEmpleadoRevisa    := GT_NIVELES_AUTORIZACION.EMPLEADO_SUPERIOR(nCodCia,nIdEmpleadoRevisaAnt);
        nIdEmpleadoProcesa   := GT_AUTORIZA_PROCESOS.EMPLEADO_PROCESA(nCodCia,nIdAutorizacion);

        UPDATE AUTORIZA_PROCESOS
           SET StsAutorizacion = 'REVISADA',
               FechaStatus     = TRUNC(SYSDATE),
               IdEmpleadoRevisa= nIdEmpleadoRevisa,
               FecRevisa       = TRUNC(SYSDATE),
               HoraRevisa      = TO_CHAR(SYSDATE,'HH24:MI:SS')
         WHERE CodCia          = nCodCia
           AND IdAutorizacion  = nIdAutorizacion;

        GT_AUTORIZA_PROCESOS_LOG.CREAR(nCodCia, nIdAutorizacion, nIdEmpleadoRevisaAnt, TRUNC(SYSDATE), TO_CHAR(SYSDATE,'HH24:MI:SS'), nIdEmpleadoRevisa, cObservaciones);
        --GT_AUTORIZA_PROCESOS.NOTIFICA(nCodCia,nIdAutorizacion,nIdEmpleadoRevisaAnt,'RV');
        GT_AUTORIZA_PROCESOS.NOTIFICA(nCodCia,nIdAutorizacion,nIdEmpleadoProcesa,'RV');
    END;
    --
   PROCEDURE REVIERTE(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER) IS
      cStsAutorizacion        AUTORIZA_PROCESOS.StsAutorizacion%TYPE;
      cExiste                 VARCHAR2(1);
   BEGIN
      cExiste := GT_AUTORIZA_PROCESOS_LOG.EXISTE_REVISION(nCodCia,nIdAutorizacion);

      IF cExiste = 'S' THEN
         cStsAutorizacion := 'REVISADA';
      ELSE
         cStsAutorizacion := 'PENDIENTE';
      END IF;

      UPDATE AUTORIZA_PROCESOS
         SET StsAutorizacion = cStsAutorizacion,
             FechaStatus     = TRUNC(SYSDATE),
             FecAutoriza     = NULL,
             HoraAutoriza    = NULL
       WHERE CodCia          = nCodCia
         AND IdAutorizacion  = nIdAutorizacion;
   END REVIERTE;
   --
   PROCEDURE NOTIFICA(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER,nIdEmpleadoProcesa IN NUMBER,cTipoNotificacion VARCHAR2) IS
      nIdEmpleadoSuperior     AUTORIZA_PROCESOS.IdEmpleadoAutoriza%TYPE;
      nIdEmpleadoAutoriza     AUTORIZA_PROCESOS.IdEmpleadoAutoriza%TYPE;
      nIdEmpleadoReviso       AUTORIZA_PROCESOS_LOG.IdEmpleadoRevisa%TYPE;
      nIdEmpleadoRevisa       AUTORIZA_PROCESOS_LOG.IdEmpleadoSuperior%TYPE;
      nIdEmpleadoRegresa      AUTORIZA_PROCESOS_REGRESO.IdEmpleadoRegresa%TYPE;
      nIdEmpleadoRegresado    AUTORIZA_PROCESOS_REGRESO.IdEmpleadoRegresado%TYPE;
      
      cUsuarioProcesa         USUARIOS.CodUsuario%TYPE;
      cUsuarioSuperior        USUARIOS.CodUsuario%TYPE;
      cUsuarioAutoriza        USUARIOS.CodUsuario%TYPE;
      cUsuarioReviso          USUARIOS.CodUsuario%TYPE;
      cUsuarioRevisa          USUARIOS.CodUsuario%TYPE;
      cUsuarioRegresa         USUARIOS.CodUsuario%TYPE;
      cUsuarioRegresado       USUARIOS.CodUsuario%TYPE;
      
      cSubject                VARCHAR2(200);
      cMessage                VARCHAR2(4000);
	  cEmailAuth              VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'021');
	  cPwdEmail               VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'022');
	  cEmailEnvio             VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'042');
	  
      cEmailEmpleadoProcesa   USUARIOS.Email%TYPE := '';
      cEmailEmpleadoSuperior  USUARIOS.Email%TYPE := '';
      cEmailEmpleadoAutoriza  USUARIOS.Email%TYPE := '';
      cEmailEmpleadoReviso    USUARIOS.Email%TYPE := '';
      cEmailEmpleadoRevisa    USUARIOS.Email%TYPE := '';
      cEmailEmpleadoRegresa   USUARIOS.Email%TYPE := '';
      cEmailEmpleadoRegresado USUARIOS.Email%TYPE := '';
         
      cCodProceso             AUTORIZA_PROCESOS.CodProceso%TYPE;
      nMontoProceso           AUTORIZA_PROCESOS.MontoProceso%TYPE;
      cSeparadorCC            VARCHAR2(1) := ',';
      cError                  VARCHAR2(200);
      cHTMLHeader             VARCHAR2(2000) := '<html><head><meta http-equiv="Content-Language" content="en-us" />'          ||CHR(13)||
                                                '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252" />'||CHR(13)||
                                                '</head><body>'                                                               ||CHR(13);
      cHTMLFooter             VARCHAR2(100)  := '</body></html>';
      cSaltoLinea             VARCHAR2(5)    := '<br>';
      cTextoImportanteOpen    VARCHAR2(10)   := '<strong>';
      cTextoImportanteClose   VARCHAR2(10)   := '</strong>';
      cDetalleAutorizacion    AUTORIZA_PROCESOS.Observaciones%TYPE;
      
   BEGIN
      nMontoProceso           := GT_AUTORIZA_PROCESOS.MONTO_AUTORIZACION(nCodCia,nIdAutorizacion);
        --IF cTipoNotificacion <> 'RV' THEN
      nIdEmpleadoAutoriza     := GT_NIVELES_AUTORIZACION.SUPERIOR_QUE_AUTORIZA(nCodCia,nIdEmpleadoProcesa, nMontoProceso);
      cUsuarioAutoriza        := GT_NIVELES_AUTORIZACION.USUARIO_BD(nCodCia,nIdEmpleadoAutoriza);
      cEmailEmpleadoAutoriza  := OC_USUARIOS.EMAIL(nCodCia, cUsuarioAutoriza);
        --END IF;
      cUsuarioProcesa         := GT_NIVELES_AUTORIZACION.USUARIO_BD(nCodCia,nIdEmpleadoProcesa);
      cEmailEmpleadoProcesa   := OC_USUARIOS.EMAIL(nCodCia, cUsuarioProcesa);
      nIdEmpleadoSuperior     := GT_NIVELES_AUTORIZACION.EMPLEADO_SUPERIOR(nCodCia,nIdEmpleadoProcesa);
      cUsuarioSuperior        := GT_NIVELES_AUTORIZACION.USUARIO_BD(nCodCia,nIdEmpleadoSuperior);
      cEmailEmpleadoSuperior  := OC_USUARIOS.EMAIL(nCodCia, cUsuarioSuperior);
      cCodProceso             := GT_AUTORIZA_PROCESOS.PROCESO(nCodCia,nIdAutorizacion);
      
      BEGIN
         SELECT NVL(Observaciones,'SIN DETALLE')
           INTO cDetalleAutorizacion
           FROM AUTORIZA_PROCESOS
          WHERE CodCia = nCodCia
            AND IdAutorizacion = nIdAutorizacion;
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20225,'Error al Determinar el Detalle de la Autorización: '||nIdAutorizacion);
      END;
      
      IF cTipoNotificacion = 'NA' THEN --NOTIFICACION DE AUTORIZACION
         cSubject  := 'Notificación de Autorización Número '||nIdAutorizacion;
         cMessage  := cHTMLHeader                                                                                                                                                                                                                         ||
                      'Estimado(a): '||OC_USUARIOS.NOMBRE_USUARIO(nCodCia, cUsuarioProcesa)||cSaltoLinea||cSaltoLinea                                                                                                                                     ||
                      '    Su Perfil de Usuario NO Cuenta con el Nivel de Autorización Para Ejecutar '||cTextoImportanteOpen||OC_PROCESO_AUTORIZACION.DESCRIPCION_PROCESO(nCodCia,cCodProceso)||cTextoImportanteClose                                     ||
                      ' Con un Monto de '||TRIM(TO_CHAR(nMontoProceso,'$999,999,999,990.99'))||'.'||cSaltoLinea||cSaltoLinea                                                                                                                              ||
                      'Para Ello se ha Creado la Autorización Número '||cTextoImportanteOpen||nIdAutorizacion||cTextoImportanteClose||' la Cual ha Sido Asignada a '||OC_USUARIOS.NOMBRE_USUARIO(nCodCia, cUsuarioAutoriza)||'.'||cSaltoLinea||cSaltoLinea||
                      'Es Importante que Espere la Confirmación de la Autorización o Rechazo de su Operación Para Poder Continuar con su Proceso.'||cSaltoLinea||cSaltoLinea                                                                              ||
                      '    A Continuación se Agrega el Detalle de la Autorizacion:'||cSaltoLinea                                                                                                                                                          ||
                      cDetalleAutorizacion||cSaltoLinea||cSaltoLinea                                                                                                                                                                                      ||              
                      cTextoImportanteOpen||'    Este Correo es Generado de Manera Automática, Por Favor no lo Responda.'||cTextoImportanteClose||cSaltoLinea||cSaltoLinea                                                                                ||
                      OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)||cSaltoLinea                                                                                                                                                                                   ||
                      ' <img src="'||OC_ADICIONALES_EMPRESA.RUTA_LOGOTIPO(nCodCia)||'" alt="'||OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)||'" height="120" width="280"> '||cSaltoLinea||cHTMLFooter;
      ELSIF cTipoNotificacion = 'NR' THEN --RESPUESTA DE AUTORIZACION
         cSubject  := 'Respuesta de Autorización Número '||nIdAutorizacion||' '||GT_AUTORIZA_PROCESOS.ESTATUS_AUTORIZACION(nCodCia,nIdAutorizacion);
         cMessage  := cHTMLHeader                                                                                                                                                                                                             ||
                      'Estimado(a): '||OC_USUARIOS.NOMBRE_USUARIO(nCodCia, cUsuarioProcesa)||cSaltoLinea||cSaltoLinea                                                                                                                         ||
                      '    Se Informa que su Proceso '||cTextoImportanteOpen||OC_PROCESO_AUTORIZACION.DESCRIPCION_PROCESO(nCodCia,cCodProceso)||cTextoImportanteClose||' con un Monto de '||TRIM(TO_CHAR(nMontoProceso,'$999,999,999,990.99'))||
                      ' con Número de Autorización '||cTextoImportanteOpen||nIdAutorizacion||cTextoImportanteClose||' ha Sido '||GT_AUTORIZA_PROCESOS.ESTATUS_AUTORIZACION(nCodCia,nIdAutorizacion)                                           ||
                      ' por '||OC_USUARIOS.NOMBRE_USUARIO(nCodCia, cUsuarioAutoriza)||' por la Siguiente Razón '||GT_AUTORIZA_PROCESOS.OBSERVACIONES_RECHAZO(nCodCia,nIdAutorizacion)||'.'||cSaltoLinea||cSaltoLinea                          ||
                      ' Por Favor Continue con su Proceso de Validación y/o Seguimiento.'||cSaltoLinea||cSaltoLinea                                                                                                                           ||
                      '    A Continuación se Agrega el Detalle de la Autorizacion:'||cSaltoLinea                                                                                                                                              ||
                      cDetalleAutorizacion||cSaltoLinea||cSaltoLinea                                                                                                                                                                          ||
                      cTextoImportanteOpen||'    Este Correo es Generado de Manera Automática, Por Favor no lo Responda.'||cTextoImportanteClose||cSaltoLinea||cSaltoLinea                                                                    ||
                      OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)||cSaltoLinea                                                                                                                                                                       ||
                      ' <img src="'||OC_ADICIONALES_EMPRESA.RUTA_LOGOTIPO(nCodCia)||'" alt="'||OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)||'" height="120" width="280"> '||cSaltoLinea||cHTMLFooter;
      ELSIF cTipoNotificacion = 'RV' THEN --NOTIFICACION REVISION
         nIdEmpleadoReviso       := GT_AUTORIZA_PROCESOS_LOG.EMPLEADO_REVISION_ANTERIOR(nCodCia,nIdAutorizacion);
         cUsuarioReviso          := GT_NIVELES_AUTORIZACION.USUARIO_BD(nCodCia,nIdEmpleadoReviso);
         cEmailEmpleadoReviso    := OC_USUARIOS.EMAIL(nCodCia, cUsuarioReviso);
            
         nIdEmpleadoRevisa       := GT_AUTORIZA_PROCESOS_LOG.EMPLEADO_ULTIMA_REVISION(nCodCia,nIdAutorizacion);
         cUsuarioRevisa          := GT_NIVELES_AUTORIZACION.USUARIO_BD(nCodCia,nIdEmpleadoRevisa);
         cEmailEmpleadoRevisa    := OC_USUARIOS.EMAIL(nCodCia, cUsuarioRevisa);
            
         cSubject  := 'Revision de Autorización Número '||nIdAutorizacion||' '||GT_AUTORIZA_PROCESOS.ESTATUS_AUTORIZACION(nCodCia,nIdAutorizacion);
         cMessage  := cHTMLHeader                                                                                                                                                                                                                        ||
                      'Estimado(a): '||OC_USUARIOS.NOMBRE_USUARIO(nCodCia, cUsuarioRevisa)||cSaltoLinea||cSaltoLinea                                                                                                                                     ||
                      '    Se Informa que la Autorización para '||cTextoImportanteOpen||OC_PROCESO_AUTORIZACION.DESCRIPCION_PROCESO(nCodCia,cCodProceso)||cTextoImportanteClose||' con un Monto de '||TRIM(TO_CHAR(nMontoProceso,'$999,999,999,990.99')) ||
                      ' con Número de Autorización '||cTextoImportanteOpen||nIdAutorizacion||cTextoImportanteClose||' ha Sido '||GT_AUTORIZA_PROCESOS.ESTATUS_AUTORIZACION(nCodCia,nIdAutorizacion)                                                      ||
                      ' por '||OC_USUARIOS.NOMBRE_USUARIO(nCodCia, cUsuarioReviso)||'.'||cSaltoLinea||cSaltoLinea                                                                                                                                        ||
                      ' El proceso está en espera del Vo.Bo., para poder continuar.'||cSaltoLinea||cSaltoLinea                                                                                                                                           ||
                      '    A Continuación se Agrega el Detalle de la Autorizacion:'||cSaltoLinea                                                                                                                                                         ||
                      cDetalleAutorizacion||cSaltoLinea||cSaltoLinea                                                                                                                                                                                     ||
                      cTextoImportanteOpen||'    Este Correo es Generado de Manera Automática, Por Favor no lo Responda.'||cTextoImportanteClose||cSaltoLinea||cSaltoLinea                                                                               ||
                      OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)||cSaltoLinea                                                                                                                                                                                  ||
                      ' <img src="'||OC_ADICIONALES_EMPRESA.RUTA_LOGOTIPO(nCodCia)||'" alt="'||OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)||'" height="120" width="280"> '||cSaltoLinea||cHTMLFooter;
      ELSIF cTipoNotificacion = 'RG' THEN --- NOTIFICACION REGRESO AUTORIZACION
         nIdEmpleadoRegresa      := GT_AUTORIZA_PROCESOS_REGRESO.EMPLEADO_ULTIMO_REGRESA(nCodCia,nIdAutorizacion);
         cUsuarioRegresa         := GT_NIVELES_AUTORIZACION.USUARIO_BD(nCodCia,nIdEmpleadoRegresa);
         cEmailEmpleadoRegresa   := OC_USUARIOS.EMAIL(nCodCia, cUsuarioRegresa);
         nIdEmpleadoRegresado    := GT_AUTORIZA_PROCESOS_REGRESO.EMPLEADO_ULTIMO_REGRESADO(nCodCia,nIdAutorizacion);
         cUsuarioRegresado       := GT_NIVELES_AUTORIZACION.USUARIO_BD(nCodCia,nIdEmpleadoRegresado);
         cEmailEmpleadoRegresado := OC_USUARIOS.EMAIL(nCodCia, cUsuarioRegresado);
         
         cSubject  := 'Regreso de Autorización Número '||nIdAutorizacion||' '||GT_AUTORIZA_PROCESOS.ESTATUS_AUTORIZACION(nCodCia,nIdAutorizacion);
         cMessage  := cHTMLHeader                                                                                                                                                                                                                        ||
                      'Estimado(a): '||OC_USUARIOS.NOMBRE_USUARIO(nCodCia, cUsuarioRegresado)||cSaltoLinea||cSaltoLinea                                                                                                                                  ||
                      '    Se Informa que la Autorización para '||cTextoImportanteOpen||OC_PROCESO_AUTORIZACION.DESCRIPCION_PROCESO(nCodCia,cCodProceso)||cTextoImportanteClose||' con un Monto de '||TRIM(TO_CHAR(nMontoProceso,'$999,999,999,990.99')) ||
                      ' con Número de Autorización '||cTextoImportanteOpen||nIdAutorizacion||cTextoImportanteClose||' le ha Sido '||GT_AUTORIZA_PROCESOS.ESTATUS_AUTORIZACION(nCodCia,nIdAutorizacion)                                                   ||
                      ' por '||OC_USUARIOS.NOMBRE_USUARIO(nCodCia, cUsuarioRegresa)||'.'||cSaltoLinea||cSaltoLinea                                                                                                                                       ||
                      ' El proceso está en espera del Vo.Bo., para poder continuar.'||cSaltoLinea||cSaltoLinea                                                                                                                                           ||
                      '    A Continuación se Agrega el Detalle de la Autorizacion:'||cSaltoLinea                                                                                                                                                         ||
                      cDetalleAutorizacion||cSaltoLinea||cSaltoLinea                                                                                                                                                                                     ||
                      cTextoImportanteOpen||'    Este Correo es Generado de Manera Automática, Por Favor no lo Responda.'||cTextoImportanteClose||cSaltoLinea||cSaltoLinea                                                                               ||
                      OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)||cSaltoLinea                                                                                                                                                                                  ||
                      ' <img src="'||OC_ADICIONALES_EMPRESA.RUTA_LOGOTIPO(nCodCia)||'" alt="'||OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)||'" height="120" width="280"> '||cSaltoLinea||cHTMLFooter;
      END IF;

      OC_MAIL.INIT_PARAM;
      OC_MAIL.cCtaEnvio   := cEmailAuth;
      OC_MAIL.cPwdCtaEnvio:= cPwdEmail;
           
      IF cTipoNotificacion = 'RV' THEN
         OC_MAIL.SEND_EMAIL(NULL,cEmailEnvio,TRIM(cEmailEmpleadoReviso),TRIM(cEmailEmpleadoRevisa||cSeparadorCC||cEmailEmpleadoAutoriza||cSeparadorCC||cEmailEmpleadoProcesa),NULL,cSubject,cMessage,NULL,NULL,NULL,NULL,cError);
      ELSIF cTipoNotificacion = 'RG' THEN
         OC_MAIL.SEND_EMAIL(NULL,cEmailEnvio,TRIM(cEmailEmpleadoRegresado),TRIM(cEmailEmpleadoRegresa||cSeparadorCC||cEmailEmpleadoAutoriza||cSeparadorCC||cEmailEmpleadoProcesa),NULL,cSubject,cMessage,NULL,NULL,NULL,NULL,cError);
      ELSE
         OC_MAIL.SEND_EMAIL(NULL,cEmailEnvio,TRIM(cEmailEmpleadoProcesa),TRIM(cEmailEmpleadoSuperior||cSeparadorCC||cEmailEmpleadoAutoriza),NULL,cSubject,cMessage,NULL,NULL,NULL,NULL,cError);
      END IF;
   END NOTIFICA;
    --
   PROCEDURE REGRESA(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER,cObservaciones IN VARCHAR2) IS
      nIdEmpleadoRegresa    AUTORIZA_PROCESOS_REGRESO.IdEmpleadoRegresa%TYPE;
      nIdEmpleadoRegresado  AUTORIZA_PROCESOS_REGRESO.IdEmpleadoRegresado%TYPE;
      nIdEmpleadoProcesa    AUTORIZA_PROCESOS.IdEmpleadoProcesa%TYPE;
   BEGIN
      nIdEmpleadoRegresa    := GT_NIVELES_AUTORIZACION.NUMERO_EMPLEADO(nCodCia,USER);
      nIdEmpleadoRegresado  := GT_AUTORIZA_PROCESOS_REGRESO.EMPLEADO_A_REGRESAR(nCodCia,nIdAutorizacion,nIdEmpleadoRegresa);
      nIdEmpleadoProcesa    := GT_AUTORIZA_PROCESOS.EMPLEADO_PROCESA(nCodCia,nIdAutorizacion);

      UPDATE AUTORIZA_PROCESOS
         SET StsAutorizacion   = 'REGRESADA',
             FechaStatus       = TRUNC(SYSDATE),
             IdEmpleadoRegresa = nIdEmpleadoRegresado,
             IdEmpleadoRevisa  = nIdEmpleadoRegresado,
             FecRegresa        = TRUNC(SYSDATE),
             HoraRegresa       = TO_CHAR(SYSDATE,'HH24:MI:SS')
       WHERE CodCia          = nCodCia
         AND IdAutorizacion  = nIdAutorizacion;

      GT_AUTORIZA_PROCESOS_REGRESO.CREAR(nCodCia, nIdAutorizacion, nIdEmpleadoRegresa, TRUNC(SYSDATE), TO_CHAR(SYSDATE,'HH24:MI:SS'), nIdEmpleadoRegresado, cObservaciones);
      GT_AUTORIZA_PROCESOS.NOTIFICA(nCodCia,nIdAutorizacion,nIdEmpleadoProcesa,'RG');
   END REGRESA;
    --
   PROCEDURE ACTUALIZA(nCodCia IN NUMBER, nIdAutorizacion IN NUMBER, nMontoProceso IN NUMBER,
                       nMontoAcumProceso IN NUMBER, dFecProcesa IN DATE, cHoraProcesa IN VARCHAR2) IS
   BEGIN
      IF nMontoAcumProceso = 0 THEN
         UPDATE AUTORIZA_PROCESOS
            SET StsAutorizacion  = 'PENDIENTE',
                FechaStatus      = TRUNC(SYSDATE),
                MontoProceso     = nMontoProceso,
                FecProcesa       = dFecProcesa,
                HoraProcesa      = cHoraProcesa,
                IdEmpleadoRevisa = GT_NIVELES_AUTORIZACION.EMPLEADO_SUPERIOR(nCodCia,IdEmpleadoProcesa)
          WHERE CodCia          = nCodCia
            AND IdAutorizacion  = nIdAutorizacion;   
      ELSE
         UPDATE AUTORIZA_PROCESOS
            SET StsAutorizacion  = 'PENDIENTE',
                FechaStatus      = TRUNC(SYSDATE),
                MontoProceso     = nMontoProceso,
                MontoAcumProceso = nMontoAcumProceso,
                FecProcesa       = dFecProcesa,
                HoraProcesa      = cHoraProcesa,
                IdEmpleadoRevisa = GT_NIVELES_AUTORIZACION.EMPLEADO_SUPERIOR(nCodCia,IdEmpleadoProcesa)
          WHERE CodCia          = nCodCia
            AND IdAutorizacion  = nIdAutorizacion;
      END IF;      
      GT_AUTORIZA_PROCESOS.AGREGA_DETALLE(nCodCia,nIdAutorizacion);
   END ACTUALIZA;
   --
   PROCEDURE ORIGEN(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER, nIdDocOrigen IN OUT NUMBER, cNomDocOrigen IN OUT VARCHAR2, cIdObjeto IN OUT VARCHAR2) IS
       cExiste VARCHAR2(1);
   BEGIN
       SELECT Existe,MIN(IdDocOrigen) IdDocOrigen,NomDocOrigen, IdObjeto
         INTO cExiste,nIdDocOrigen,cNomDocOrigen,cIdObjeto
         FROM (SELECT 'S' Existe,IdNomina IdDocOrigen,'Identificador Pago Comision' NomDocOrigen,'NOMINA_COMISION' IdObjeto
                 FROM NOMINA_COMISION
                WHERE CodCia         = nCodCia
                  AND IdAutorizacion = nIdAutorizacion
                UNION
               SELECT 'S' Existe,IdSiniestro IdDocOrigen,'Identificador Siniestro Colectivo (RESERVA)' NomDocOrigen,'SINIESTRO' IdObjeto
                 FROM APROBACION_ASEG
                WHERE IdAutorizacion = nIdAutorizacion
                UNION
               SELECT 'S' Existe,IdSiniestro IdDocOrigen,'Identificador Siniestro Individual (RESERVA)' NomDocOrigen,'SINIESTRO' IdObjeto
                 FROM APROBACIONES
                WHERE IdAutorizacion = nIdAutorizacion
                UNION
               SELECT 'S' Existe,IdSiniestro IdDocOrigen,'Identificador Siniestro Individual (PAGO)' NomDocOrigen,'SINIESTRO' IdObjeto
                 FROM COBERTURA_SINIESTRO
                WHERE IdAutorizacion = nIdAutorizacion
                UNION
               SELECT 'S' Existe,IdSiniestro IdDocOrigen,'Identificador Siniestro Colectivo (PAGO)' NomDocOrigen,'SINIESTRO' IdObjeto
                 FROM COBERTURA_SINIESTRO_ASEG
                WHERE IdAutorizacion = nIdAutorizacion
                UNION
               SELECT 'S' Existe,IdSiniestro IdDocOrigen,'Identificador Siniestro' NomDocOrigen,'SINIESTRO' IdObjeto
                 FROM SINIESTRO
                WHERE CodCia         = nCodCia
                  AND IdAutorizacion = nIdAutorizacion
                UNION
               SELECT 'S' Existe,IdProcMasivo IdDocOrigen,'Identificador Proceso Masivo' NomDocOrigen,'PROCESOS_MASIVOS' IdObjeto
                 FROM PROCESOS_MASIVOS
                WHERE CodCia         = nCodCia
                  AND IdAutorizacion = nIdAutorizacion)
        GROUP BY Existe,NomDocOrigen,IdObjeto;
   END ORIGEN;
    --
   PROCEDURE AGREGA_DETALLE(nCodCia IN NUMBER,nIdAutorizacion IN NUMBER) IS
      cObservaciones          AUTORIZA_PROCESOS.Observaciones%TYPE;
      cCodProceso             AUTORIZA_PROCESOS.CodProceso%TYPE;
      dFecProcesa             AUTORIZA_PROCESOS.FecProcesa%TYPE;
      cHoraProcesa            AUTORIZA_PROCESOS.HoraProcesa%TYPE;
      dFecPasaAutorizacion    AUTORIZA_PROCESOS.FecPasaAutorizacion%TYPE;
      cHoraPasaAutorizacion   AUTORIZA_PROCESOS.HoraPasaAutorizacion%TYPE;
      nIdEmpleadoProcesa      AUTORIZA_PROCESOS.IdEmpleadoProcesa%TYPE;
      nIdDocOrigen            AUTORIZA_PROCESOS.IdDocProceso%TYPE;
      cNomDocOrigen           VARCHAR2(300);
      cIdObjeto               VARCHAR2(30);
   BEGIN
      BEGIN
          SELECT FecProcesa,HoraProcesa,FecPasaAutorizacion,HoraPasaAutorizacion
            INTO dFecProcesa,cHoraProcesa,dFecPasaAutorizacion,cHoraPasaAutorizacion
            FROM AUTORIZA_PROCESOS
           WHERE CodCia         = nCodCia
             AND IdAutorizacion = nIdAutorizacion;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR(-20225,'No Es Posible Obtener Datos de la Autorización '||nIdAutorizacion||' Por Favor Valide');
      END;
      cCodProceso           := GT_AUTORIZA_PROCESOS.PROCESO(nCodCia,nIdAutorizacion);
      nIdEmpleadoProcesa    := GT_AUTORIZA_PROCESOS.EMPLEADO_PROCESA(nCodCia,nIdAutorizacion);
      GT_AUTORIZA_PROCESOS.ORIGEN(nCodCia,nIdAutorizacion,nIdDocOrigen,cNomDocOrigen,cIdObjeto);
      cObservaciones        := 'Autorización de '||OC_PROCESO_AUTORIZACION.DESCRIPCION_PROCESO(nCodCia,cCodProceso)                                                                      ||CHR(10)||
                               cNomDocOrigen||' '||nIdDocOrigen                                                                                                                          ||CHR(10)||
                               'Procesado el '||TO_CHAR(dFecProcesa, 'Day, DD "de" Month "de" YYYY', 'NLS_DATE_LANGUAGE=SPANISH')||' a las '||cHoraProcesa                               ||CHR(10)||
                               'Pasando a Autorización el '||TO_CHAR(dFecPasaAutorizacion, 'Day, DD "de" Month "de" YYYY', 'NLS_DATE_LANGUAGE=SPANISH')||' a las '||cHoraPasaAutorizacion||CHR(10)||
                               'Autorización Solicitada por '||OC_USUARIOS.NOMBRE_USUARIO(nCodCia,GT_NIVELES_AUTORIZACION.USUARIO_BD(nCodCia,nIdEmpleadoProcesa));
      UPDATE AUTORIZA_PROCESOS
         SET Observaciones  = cObservaciones
       WHERE CodCia         = nCodCia
         AND IdAutorizacion = nIdAutorizacion;
   EXCEPTION
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error en la Generación de Detalle Para Autorización '||nIdAutorizacion||' Por Favor Valide '||SQLERRM);
   END AGREGA_DETALLE;
END GT_AUTORIZA_PROCESOS;
/

--
-- GT_AUTORIZA_PROCESOS  (Synonym) 
--
--  Dependencies: 
--   GT_AUTORIZA_PROCESOS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_AUTORIZA_PROCESOS FOR SICAS_OC.GT_AUTORIZA_PROCESOS
/


GRANT EXECUTE ON SICAS_OC.GT_AUTORIZA_PROCESOS TO PUBLIC
/
