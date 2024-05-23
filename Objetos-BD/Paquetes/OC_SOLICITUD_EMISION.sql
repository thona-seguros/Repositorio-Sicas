CREATE OR REPLACE PACKAGE OC_SOLICITUD_EMISION IS

FUNCTION NUMERO_SOLICITUD(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN NUMBER;

FUNCTION SOLICITUD_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN NUMBER;

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER);

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER);

PROCEDURE EMITIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER);

PROCEDURE REVERTIR_EMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER);

PROCEDURE POR_EMITIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER);

FUNCTION VALIDAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN VARCHAR2;

PROCEDURE ENVIAR_EMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, cNumPolUnicoOrigen VARCHAR2);

PROCEDURE GENERAR_REPORTE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitudIni NUMBER,
                          nIdSolicitudFin NUMBER, cStsSolicitud VARCHAR2, dFecIniVig DATE,
                          dFecFinVig DATE, cUsuario VARCHAR2, nCodDirecRegional NUMBER);

PROCEDURE REVERTIR_ENVIO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIdPoliza NUMBER);

FUNCTION ASEGURADO_MODELO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN VARCHAR2;

FUNCTION TOTAL_PRIMA_NETA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN NUMBER;

FUNCTION FOLIO_PORTAL(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN VARCHAR2;

PROCEDURE COPIAR_SOLICITUD(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER);

FUNCTION TIPO_SEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN VARCHAR2;

FUNCTION PLAN_COBERTURA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN VARCHAR2;

FUNCTION FECHA_INI_VIG(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN DATE;

FUNCTION FECHA_FIN_VIG(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN DATE;

PROCEDURE DATOS_COTIZACION (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIdCotizacion NUMBER); 

END OC_SOLICITUD_EMISION;

/

create or replace PACKAGE BODY OC_SOLICITUD_EMISION IS
--
-- BITACORA DE CAMBIOS
-- SE AGREGO LA FUNCIONALIDAD PARA RENOVACION DE CLAUSULAS 10/08/2017  CLAUREN
-- SE COLOCO LA FECHA_RENOV = FECHA_FIN_VIG  FECREN
--
FUNCTION NUMERO_SOLICITUD(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN NUMBER IS
nIdSolicitud    SOLICITUD_EMISION.IdSolicitud%TYPE;
BEGIN


--   SELECT NVL(MAX(IdSolicitud),0) + 1    --SECUEN  INICIO
--     INTO nIdSolicitud
--     FROM SOLICITUD_EMISION
--    WHERE CodCia      = nCodCia
--      AND CodEmpresa  = nCodEmpresa;

--        Cambio a secuencia XDS
       SELECT SQ_SLTD_EMI.NEXTVAL
        INTO nIdSolicitud
        FROM DUAL;                          --SECUEN FIN



   RETURN(nIdSolicitud);
END NUMERO_SOLICITUD;

FUNCTION SOLICITUD_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN NUMBER IS
nIdSolicitud   SOLICITUD_EMISION.IdSolicitud%TYPE;
BEGIN
   BEGIN
      SELECT IdSolicitud
        INTO nIdSolicitud
        FROM SOLICITUD_EMISION
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdPoliza   = nIdPoliza;
   EXCEPTION
       WHEN NO_DATA_FOUND THEN
          nIdSolicitud := 0;
   END;
   RETURN(nIdSolicitud);
END SOLICITUD_POLIZA;

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) IS
BEGIN
   UPDATE SOLICITUD_EMISION
      SET StsSolicitud  = 'ANULAD',
          FecStsSol     = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND IdSolicitud = nIdSolicitud;
END ANULAR;

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) IS
BEGIN
   UPDATE SOLICITUD_EMISION
      SET StsSolicitud  = 'XENVIA',
          FecStsSol     = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND IdSolicitud = nIdSolicitud;
END ACTIVAR;

PROCEDURE EMITIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) IS
nIdSolicitud   SOLICITUD_EMISION.IdSolicitud%TYPE;
BEGIN
   BEGIN
      SELECT IdSolicitud
        INTO nIdSolicitud
        FROM SOLICITUD_EMISION
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdPoliza   = nIdPoliza;
   EXCEPTION
       WHEN NO_DATA_FOUND THEN
          nIdSolicitud := 0;
   END;

   IF NVL(nIdSolicitud,0) != 0 THEN
      UPDATE SOLICITUD_EMISION
         SET StsSolicitud  = 'EMITID',
             FecStsSol     = TRUNC(SYSDATE)
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdSolicitud = nIdSolicitud;
   END IF;
END EMITIR;

PROCEDURE REVERTIR_EMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) IS
nIdSolicitud   SOLICITUD_EMISION.IdSolicitud%TYPE;
BEGIN
   BEGIN
      SELECT IdSolicitud
        INTO nIdSolicitud
        FROM SOLICITUD_EMISION
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdPoliza   = nIdPoliza;
   EXCEPTION
       WHEN NO_DATA_FOUND THEN
          nIdSolicitud := 0;
   END;

   IF NVL(nIdSolicitud,0) != 0 THEN
      UPDATE SOLICITUD_EMISION
         SET StsSolicitud  = 'XEMITI',
             FecStsSol     = TRUNC(SYSDATE)
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdSolicitud = nIdSolicitud;
   END IF;
END REVERTIR_EMISION;

PROCEDURE POR_EMITIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) IS
BEGIN
   UPDATE SOLICITUD_EMISION
      SET StsSolicitud  = 'XEMITI',
          FecStsSol     = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND IdSolicitud = nIdSolicitud;
END POR_EMITIR;

FUNCTION VALIDAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN VARCHAR2 IS
nTotalPrimas       SOLICITUD_COBERTURAS.Prima_Moneda%TYPE;
cDuplicadosError   VARCHAR2(1000) := NULL;
cIdTipoSeg         SOLICITUD_EMISION.IdTipoSeg%TYPE;
cPlanCob           SOLICITUD_EMISION.PlanCob%TYPE;
dFecIniVig         SOLICITUD_EMISION.FecIniVig%TYPE;
CURSOR DET_Q IS
   SELECT IDetSol, PrimaAsegurado
     FROM SOLICITUD_DETALLE
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND IdSolicitud = nIdSolicitud;
BEGIN
   cIdTipoSeg := OC_SOLICITUD_EMISION.TIPO_SEGURO(nCodCia, nCodEmpresa, nIdSolicitud);
   cPlanCob   := OC_SOLICITUD_EMISION.PLAN_COBERTURA(nCodCia, nCodEmpresa, nIdSolicitud);
   dFecIniVig := OC_SOLICITUD_EMISION.FECHA_INI_VIG(nCodCia, nCodEmpresa, nIdSolicitud);
   IF OC_SOLICITUD_EMISION.FOLIO_PORTAL(nCodCia, nCodEmpresa, nIdSolicitud) IS NULL THEN
      RAISE_APPLICATION_ERROR(-20225,'Debe Ingresar el No. de Folio del Portal de Agentes para la Solicitud No. : '||TRIM(TO_CHAR(nIdSolicitud)));
   ELSIF OC_SOLICITUD_DETALLE.TIENE_DETALLES(nCodCia, nCodEmpresa, nIdSolicitud) = 'N' THEN
      RAISE_APPLICATION_ERROR(-20225,'Debe Ingresar SubGrupos a la Solicitud No. : '||TRIM(TO_CHAR(nIdSolicitud)));
   ELSIF OC_PLAN_COBERTURAS.VALIDA_DIAS_RETROACTIVOS(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, dFecIniVig) = 'N' THEN
      IF OC_PROCESO_AUTORIZA_USUARIO.PROCESO_AUTORIZADO(nCodCia, '9145', USER, 'NOAPLI',1) = 'N' THEN
        RAISE_APPLICATION_ERROR(-20225,'La Configuración del Producto Sólo Tiene '||OC_PLAN_COBERTURAS.NUMERO_DIAS_RETROACTIVOS(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob)||' Días de Retroactividad Por Favor Valide la Solicitud con su Supervisor'||TRIM(TO_CHAR(nIdSolicitud)));
      END IF;
   ELSE
      FOR W IN DET_Q LOOP
         IF OC_SOLICITUD_COBERTURAS.TIENE_COBERTURAS(nCodCia, nCodEmpresa, nIdSolicitud, W.IDetSol) = 'N' THEN
            RAISE_APPLICATION_ERROR(-20225,'SubGrupo  No. ' || W.IDetSol || ' de la Solicitud No. : '||TRIM(TO_CHAR(nIdSolicitud)) ||
                                    ' NO Posee Coberturas.  Debe Ingresarlas.');
         ELSIF OC_SOLICITUD_COBERTURAS.COBERTURAS_NEGATIVAS(nCodCia, nCodEmpresa, nIdSolicitud, W.IDetSol) = 'S' THEN
            RAISE_APPLICATION_ERROR(-20225,'SubGrupo No. ' || W.IDetSol || '  de la Solicitud No. : '||TRIM(TO_CHAR(nIdSolicitud)) ||
                                    ' Posee Coberturas con Prima Negativa.  Debe Corregirlas.');
         /*ELSIF OC_SOLICITUD_ASISTENCIAS.TIENE_ASISTENCIAS(nCodCia, nCodEmpresa, nIdSolicitud, W.IDetSol) = 'N' AND
            W.PrimaAsegurado != 0 THEN
            RAISE_APPLICATION_ERROR(-20225,'SubGrupo No. ' || W.IDetSol || ' de la Solicitud No. : '||TRIM(TO_CHAR(nIdSolicitud)) ||
                                    ' NO Posee Asistencias.  Debe Ingresarlas.');*/
         END IF;
         nTotalPrimas := NVL(nTotalPrimas,0) +
                         OC_SOLICITUD_COBERTURAS.TOTAL_COBERTURAS(nCodCia, nCodEmpresa, nIdSolicitud, W.IDetSol) +
                         OC_SOLICITUD_ASISTENCIAS.TOTAL_ASISTENCIAS(nCodCia, nCodEmpresa, nIdSolicitud, W.IDetSol);
      END LOOP;
      IF OC_SOLICITUD_EMISION.ASEGURADO_MODELO(nCodCia, nCodEmpresa, nIdSolicitud) = 'S' THEN
         IF NVL(nTotalPrimas,0) > OC_SOLICITUD_EMISION.TOTAL_PRIMA_NETA(nCodCia, nCodEmpresa, nIdSolicitud) THEN
            RAISE_APPLICATION_ERROR(-20225,'Distribución de Coberturas y Asistencias es Mayor a la Prima Neta de Póliza');
         ELSIF NVL(nTotalPrimas,0) < OC_SOLICITUD_EMISION.TOTAL_PRIMA_NETA(nCodCia, nCodEmpresa, nIdSolicitud) THEN
            RAISE_APPLICATION_ERROR(-20225,'Distribución de Coberturas y Asistencias es Menor a la Prima Neta de Póliza');
         END IF;
      ELSIF OC_SOLICITUD_DETALLE_ASEG.TIENE_ASEGURADOS(nCodCia, nCodEmpresa, nIdSolicitud) = 'N' THEN
         RAISE_APPLICATION_ERROR(-20225,'No ha Cargado el Listado de Asegurados a la Soicitud');
      END IF;
      --
     cDuplicadosError := OC_SOLICITUD_DETALLE_ASEG.VALIDA_ASEG_DUPLICADOS(nCodCia, nCodEmpresa, nIdSolicitud);
      --
      IF cDuplicadosError != 'X' THEN
         --
         RAISE_APPLICATION_ERROR(-20225,'Asegurados Duplicados, ' || cDuplicadosError);
         --
     END IF;
     --
      IF OC_SOLICITUD_AGENTES_DISTRIB.TIENE_DISTRIBUCION(nCodCia, nCodEmpresa, nIdSolicitud) = 'N' THEN
         RAISE_APPLICATION_ERROR(-20225,'No Ha Realizado la Distribución de Comisiones a la Solicitud No. : '||TRIM(TO_CHAR(nIdSolicitud)));
      ELSE
         RETURN('S');
      END IF;
   END IF;
END VALIDAR;

PROCEDURE ENVIAR_EMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, cNumPolUnicoOrigen VARCHAR2) IS
cDescPoliza                   POLIZAS.DescPoliza%TYPE;
nPorcComis                    POLIZAS.PorcComis%TYPE;
nCodCliente                   CLIENTES.CodCliente%TYPE;
nCod_Agente                   POLIZAS.Cod_Agente%TYPE;
nIdPoliza                     POLIZAS.IdPoliza%TYPE;
cNumPolUnico                  POLIZAS.NumPolUnico%TYPE;
cCodGrupoEc                   GRUPO_ECONOMICO.CodGrupoEc%TYPE;
nIDetPol                      DETALLE_POLIZA.IDetPol%TYPE;
nCod_Asegurado                ASEGURADO.Cod_Asegurado%TYPE;
nExiste                       NUMBER;
cTipo_Doc_Identificacion_Det  SOLICITUD_DETALLE.Tipo_Doc_Identificacion%TYPE;
cNum_Doc_Identificacion_Det   SOLICITUD_DETALLE.Num_Doc_Identificacion%TYPE;
cTipo_Doc_Identificacion_Aseg SOLICITUD_DETALLE.Tipo_Doc_Identificacion%TYPE;
cNum_Doc_Identificacion_Aseg  SOLICITUD_DETALLE.Num_Doc_Identificacion%TYPE;

CURSOR SOL_Q IS
   SELECT IdTipoSeg, PlanCob, Cod_Moneda, TasaCambio, Tipo_Doc_Identificacion,
          Num_Doc_Identificacion, FecIniVig, FecFinVig, CodPlanPago, NumCotizacion,
          TipoAdministracion, CodAgrupador, IndFacturaPol, IndFactSubGrupo,
          StsSolicitud, FecStsSol, CodUsuario, DescSolicitud, IndFactElectronica,
          IndCalcDerechoEmis, CodDirecRegional, TipoDocIdentifAseg,
          NumDocIdentifAseg, NumFolioPortal, IndConcentrada, CodTipoNegocio,
          CodCatego, TipoRiesgo, Formaventa, CodObjetoImp, CodUsoCfdi, IndAsistPorPoliza
     FROM SOLICITUD_EMISION
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND IdSolicitud = nIdSolicitud;

CURSOR DET_Q IS
   SELECT IDetSol, CodSubGrupo, DescSubGrupo, Tipo_Doc_Identificacion, Num_Doc_Identificacion
     FROM SOLICITUD_DETALLE
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND IdSolicitud = nIdSolicitud
    ORDER BY IDetSol;

CURSOR ASEG_Q IS
   SELECT IDetSol, TipoDocIdentificacion, NumDocIdentificacion, IdAsegurado,
          NombreAseg, ApellidoPaternoAseg, ApellidoMaternoAseg,
          FechaNacimiento, SexoAseg, DirecResAseg, CodigoPostalAseg,
          SalarioMensual
     FROM SOLICITUD_DETALLE_ASEG
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND IdSolicitud = nIdSolicitud
      AND IDetSol     = nIDetPol
    ORDER BY IdAsegurado;

CURSOR COB_Q IS
   SELECT SC.CodCobert, SC.SumaAseg_Local, SC.SumaAseg_Moneda, SC.Tasa, 
          SC.Prima_Moneda, SC.Prima_Local, SC.Deducible_Local,
          SC.Deducible_Moneda, SE.IdTipoSeg, SE.PlanCob, SE.Cod_Moneda,
          SC.VecesSalario, SC.FactorReglaSumaAseg
     FROM SOLICITUD_COBERTURAS SC, SOLICITUD_EMISION SE
    WHERE SC.CodCia        = SE.CodCia
      AND SC.CodEmpresa    = SE.CodEmpresa
      AND SC.IDetSol       = nIDetPol
      AND SC.IdSolicitud   = SE.IdSolicitud
      AND SE.CodCia        = nCodCia
      AND SE.CodEmpresa    = nCodEmpresa
      AND SE.IdSolicitud   = nIdSolicitud;    
BEGIN
   FOR X IN SOL_Q LOOP
      IF OC_SOLICITUD_EMISION.VALIDAR(nCodCia, nCodEmpresa, nIdSolicitud) = 'S' THEN
         nCodCliente  := OC_CLIENTES.CODIGO_CLIENTE(X.Tipo_Doc_Identificacion, X.Num_Doc_Identificacion);
         IF NVL(nCodCliente,0) = 0 THEN
            nCodCliente  := OC_CLIENTES.INSERTAR_CLIENTE(X.Tipo_Doc_Identificacion, X.Num_Doc_Identificacion);
         END IF;
         nPorcComis   := OC_SOLICITUD_AGENTES_DISTRIB.PORCENTAJE_COMISION(nCodCia, nCodEmpresa, nIdSolicitud);
         nCod_Agente  := OC_SOLICITUD_AGENTE.AGENTE_PRINCIPAL(nCodCia, nCodEmpresa, nIdSolicitud);
         nIdPoliza    := OC_POLIZAS.INSERTAR_POLIZA(nCodCia, nCodEmpresa, cDescPoliza, X.Cod_Moneda,
                                                    nPorcComis, nCodCliente, nCod_Agente, X.CodPlanPago, NULL,
                                                    NULL, X.FecIniVig);
         IF cNumPolUnicoOrigen IS NULL THEN
            cNumPolUnico := TRIM(TO_CHAR(nIdPoliza)) || '-00';
         ELSE
            cNumPolUnico := cNumPolUnicoOrigen;
         END IF;
         cCodGrupoEc  := OC_GRUPO_ECONOMICO.VALIDA_CREA(nCodCia, X.Tipo_Doc_Identificacion,
                                                        X.Num_Doc_Identificacion, nIdSolicitud);
         UPDATE POLIZAS P
            SET FecFinVig          = X.FecFinVig,          TipoAdministracion = X.TipoAdministracion,
                CodAgrupador       = X.CodAgrupador,       IndFacturaPol      = X.IndFacturaPol,
                HoraVigIni         = '12:00',              HoraVigFin         = '12:00',
                IndFactElectronica = X.IndFactElectronica, IndCalcDerechoEmis = X.IndCalcDerechoEmis,
                IndPolCol          = 'S',                  Caracteristica     = '1',
                IndFactPeriodo     = 'N',                  FormaVenta         = X.Formaventa,
                TipoRiesgo         = TipoRiesgo,           IndConcentrada     = IndConcentrada,
                TipoDividendo      = '003',                IndAplicoSami      = 'N',
                NumPolUnico        = cNumPolUnico,         CodGrupoEc         = cCodGrupoEc,
                DescPoliza         = X.DescSolicitud,      CodDirecRegional   = X.CodDirecRegional,
                NumFolioPortal     = X.NumFolioPortal,
                FECRENOVACION      = X.FecFinVig,
                CodTipoNegocio     = X.CodTipoNegocio,     CodCatego          = X.CodCatego,
                CodObjetoImp       = X.CodObjetoImp, 
                CodUsoCfdi         = X.CodUsoCfdi  
          WHERE CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND IdPoliza   = nIdPoliza;

         BEGIN
            INSERT INTO AGENTE_POLIZA
                   (IdPoliza, CodCia, Cod_Agente, Porc_Comision, Ind_Principal, Origen)
            SELECT nIdPoliza, CodCia, Cod_Agente, Porc_Comision, Ind_Principal, Origen
              FROM SOLICITUD_AGENTE
             WHERE CodCia      = nCodCia
               AND CodEmpresa  = nCodEmpresa
               AND IdSolicitud = nIdSolicitud;
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
               RAISE_APPLICATION_ERROR(-20225,'Ya existen Agentes Cargados en Póliza No. : '|| cNumPolUnico);
         END;

         BEGIN
            INSERT INTO AGENTES_DISTRIBUCION_POLIZA
                   (CodCia, IdPoliza, Cod_Agente, CodNivel,
                   Cod_Agente_Distr, Porc_Comision_Agente, Porc_Com_Distribuida,
                   Porc_Comision_Plan, Porc_Com_Proporcional, Cod_Agente_Jefe,
                   Porc_Com_Poliza, Origen)
            SELECT CodCia, nIdPoliza, Cod_Agente, CodNivel,
                   Cod_Agente_Distr, Porc_Comision_Agente, Porc_Com_Distribuida,
                   Porc_Comision_Plan, Porc_Com_Proporcional, Cod_Agente_Jefe,
                   Porc_Com_Solicitud, Origen
              FROM SOLICITUD_AGENTES_DISTRIB
             WHERE CodCia      = nCodCia
               AND CodEmpresa  = nCodEmpresa
               AND IdSolicitud = nIdSolicitud;
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
               RAISE_APPLICATION_ERROR(-20225,'Ya existe Distribución de Agentes en Póliza No. : '|| cNumPolUnico);
         END;
         
         --- OBTENER DATOS DE COTIZACION PARA LA POLIZA
         IF X.NumCotizacion IS NOT NULL THEN
            OC_SOLICITUD_EMISION.DATOS_COTIZACION(nCodCia, nCodEmpresa, nIdPoliza, X.NumCotizacion);
         END IF;

         FOR W IN DET_Q LOOP
            IF W.CodSubGrupo IS NOT NULL THEN
               IF NVL(X.IndFacturaPol,'N') = 'N' AND NVL(X.IndFactSubGrupo,'N') = 'S' THEN 
                  cTipo_Doc_Identificacion_Det   := W.Tipo_Doc_Identificacion;
                  cNum_Doc_Identificacion_Det    := W.Num_Doc_Identificacion;
                  cTipo_Doc_Identificacion_Aseg  := W.Tipo_Doc_Identificacion;
                  cNum_Doc_Identificacion_Aseg   := W.Num_Doc_Identificacion;
               ELSE
                  cTipo_Doc_Identificacion_Det   := X.Tipo_Doc_Identificacion;
                  cNum_Doc_Identificacion_Det    := X.Num_Doc_Identificacion;
                  cTipo_Doc_Identificacion_Aseg  := X.TipoDocIdentifAseg;
                  cNum_Doc_Identificacion_Aseg   := X.NumDocIdentifAseg;
               END IF;
               OC_FILIALES.VALIDA_CREA(nCodCia, cCodGrupoEc, cTipo_Doc_Identificacion_Det,
                                       cNum_Doc_Identificacion_Det, W.CodSubGrupo, W.DescSubGrupo);
               OC_FILIALES_CATEGORIAS.VALIDA_CREA(nCodCia, cCodGrupoEc, W.CodSubGrupo,
                                                  W.CodSubGrupo, W.DescSubGrupo);
                                                  
            END IF;
            
            nCod_Asegurado := OC_ASEGURADO.CODIGO_ASEGURADO(nCodCia, nCodEmpresa, cTipo_Doc_Identificacion_Aseg, cNum_Doc_Identificacion_Aseg);
       
            IF NVL(nCod_Asegurado,0) = 0 THEN
               nCod_Asegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(nCodCia, nCodEmpresa, cTipo_Doc_Identificacion_Aseg, cNum_Doc_Identificacion_Aseg);
               INSERT INTO CLIENTE_ASEG
                      (CodCliente, Cod_Asegurado)
               VALUES (nCodCliente, nCod_Asegurado);
            END IF;
            nIDetPol := OC_DETALLE_POLIZA.INSERTAR_DETALLE(nCodCia, nCodEmpresa, X.IdTipoSeg, X.PlanCob,
                                                           nIdPoliza, X.TasaCambio, nPorcComis, nCod_Asegurado,
                                                           X.CodPlanPago, NULL, NULL, X.FecIniVig);
            UPDATE DETALLE_POLIZA
               SET CodFilial           = W.CodSubGrupo,
                   CodCategoria        = W.CodSubGrupo,
                   IndFactElectronica  = 'S',
                   IndAsegModelo       = OC_SOLICITUD_EMISION.ASEGURADO_MODELO(nCodCia, nCodEmpresa, nIdSolicitud),
                   CantAsegModelo      = OC_SOLICITUD_DETALLE.CANTIDAD_ASEGURADOS(nCodCia, nCodEmpresa, nIdSolicitud, W.IDetSol) - 1,
                   IDetPol             = W.IDetSol,
                   NumDetRef           = W.IDetSol,
                   FecIniVig           = X.FecIniVig,
                   FecFinVig           = X.FecFinVig,
                   CodUsoCfdi          = X.CodUsoCfdi,
                   CodObjetoImp        = X.CodObjetoImp
             WHERE CodCia      = nCodCia
               AND CodEmpresa  = nCodEmpresa
               AND IdPoliza    = nIdPoliza
               AND IDetPol     = nIDetPol;

            nIDetPol := W.IDetSol;

            BEGIN
               INSERT INTO AGENTES_DETALLES_POLIZAS
                      (IdPoliza, IDetPol, IdTipoSeg, Cod_Agente, Porc_Comision, Ind_Principal, CodCia, Origen)
               SELECT nIdPoliza, nIDetPol, X.IdTipoSeg, Cod_Agente, Porc_Comision, Ind_Principal, CodCia, Origen
                 FROM SOLICITUD_AGENTE
                WHERE CodCia      = nCodCia
                  AND CodEmpresa  = nCodEmpresa
                  AND IdSolicitud = nIdSolicitud;
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX THEN
                  RAISE_APPLICATION_ERROR(-20225,'Ya existen Agentes Cargados en Póliza No. : '|| cNumPolUnico ||
                                          ' y SubGrupo No. ' || nIDetPol);
            END;

            BEGIN
               INSERT INTO AGENTES_DISTRIBUCION_COMISION
                     (CodCia, IdPoliza, IDetPol, CodNivel, Cod_Agente,
                      Cod_Agente_Distr, Porc_Comision_Plan, Porc_Comision_Agente,
                      Porc_Com_Distribuida, Porc_Com_Proporcional, Cod_Agente_Jefe, Origen)
               SELECT CodCia, nIdPoliza, nIDetPol, CodNivel, Cod_Agente,
                      Cod_Agente_Distr, Porc_Comision_Plan, Porc_Comision_Agente,
                      Porc_Com_Distribuida, Porc_Com_Proporcional, Cod_Agente_Jefe, Origen
                 FROM SOLICITUD_AGENTES_DISTRIB
                WHERE CodCia      = nCodCia
                  AND CodEmpresa  = nCodEmpresa
                  AND IdSolicitud = nIdSolicitud;
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX THEN
                  RAISE_APPLICATION_ERROR(-20225,'Ya existe Distribución de Agentes en Póliza No. : '|| cNumPolUnico ||
                                          ' y SubGrupo No. ' || nIDetPol);
            END;

            IF OC_SOLICITUD_EMISION.ASEGURADO_MODELO(nCodCia, nCodEmpresa, nIdSolicitud) = 'S' THEN
               nCod_Asegurado := 1688154; --27305;
               OC_ASEGURADO_CERTIFICADO.INSERTA (nCodCia, nIdPoliza, nIDetPol, nCod_Asegurado, 0);
               OC_SOLICITUD_COBERTURAS.TRASLADA_COBERTURAS(nCodCia, nCodEmpresa, nIdSolicitud, nIdPoliza, nIDetPol, nCod_Asegurado);
               IF NVL(X.IndAsistPorPoliza,'N') = 'S' THEN
                  OC_SOLICITUD_ASISTENCIAS.TRASLADA_ASISTENCIAS_SUBGRUPOS(nCodCia, nCodEmpresa, nIdSolicitud, nIdPoliza, nIDetPol, nCod_Asegurado);
               ELSE
                  OC_SOLICITUD_ASISTENCIAS.TRASLADA_ASISTENCIAS(nCodCia, nCodEmpresa, nIdSolicitud, nIdPoliza, nIDetPol, nCod_Asegurado);
               END IF;
               OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado);
               OC_ASEGURADO_CERTIFICADO.ACTUALIZA_ASISTENCIAS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado);
               OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, nIDetPol, 0);
            ELSE
               FOR Y IN ASEG_Q LOOP
                  IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(Y.TipoDocIdentificacion, Y.NumDocIdentificacion) = 'N' THEN
                     OC_PERSONA_NATURAL_JURIDICA.INSERTAR_PERSONA(Y.TipoDocIdentificacion, Y.NumDocIdentificacion, Y.NombreAseg,
                                                                  Y.ApellidoPaternoAseg, Y.ApellidoMaternoAseg, NULL,
                                                                  Y.SexoAseg, NULL, Y.FechaNacimiento, Y.DirecResAseg, NULL, NULL,
                                                                  NULL, NULL, NULL, NULL, Y.CodigoPostalAseg, NULL, NULL, NULL, NULL);
                  END IF;
                  IF OC_PERSONA_NATURAL_JURIDICA.FUNC_VALIDA_EDAD(Y.TipoDocIdentificacion, Y.NumDocIdentificacion,
                                                                  nCodCia, nCodEmpresa, X.IdTipoSeg, X.PlanCob) = 'N' THEN
                     RAISE_APPLICATION_ERROR(-20225,'Edad del Asegurado No. ' || Y.IdAsegurado || ' Fuera del Rango de Aceptación de Coberturas');
                  END IF;

                  nCod_Asegurado := OC_ASEGURADO.CODIGO_ASEGURADO(nCodCia, nCodEmpresa, Y.TipoDocIdentificacion, Y.NumDocIdentificacion);
                  IF nCod_Asegurado = 0 THEN
                     nCod_Asegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(nCodCia, nCodEmpresa, Y.TipoDocIdentificacion, Y.NumDocIdentificacion);
                  END IF;

                  BEGIN
                     INSERT INTO CLIENTE_ASEG
                           (CodCliente, Cod_Asegurado)
                     VALUES(nCodCliente, nCod_Asegurado);
                  EXCEPTION
                     WHEN DUP_VAL_ON_INDEX THEN
                        NULL;
                  END;
                  OC_ASEGURADO_CERTIFICADO.INSERTA (nCodCia, nIdPoliza, nIDetPol, nCod_Asegurado, 0);
                  OC_SOLICITUD_COBERTURAS.TRASLADA_COBERTURAS(nCodCia, nCodEmpresa, nIdSolicitud, nIdPoliza, nIDetPol, nCod_Asegurado);
                  IF NVL(X.IndAsistPorPoliza,'N') = 'S' THEN
                     OC_SOLICITUD_ASISTENCIAS.TRASLADA_ASISTENCIAS_SUBGRUPOS(nCodCia, nCodEmpresa, nIdSolicitud, nIdPoliza, nIDetPol, nCod_Asegurado);
                  ELSE
                     OC_SOLICITUD_ASISTENCIAS.TRASLADA_ASISTENCIAS(nCodCia, nCodEmpresa, nIdSolicitud, nIdPoliza, nIDetPol, nCod_Asegurado);
                  END IF;
                  
                  FOR Z IN COB_Q LOOP
                     --Y.SalarioMensual
                     IF NVL(Z.VecesSalario,0) != 0 AND NVL(Z.FactorReglaSumaAseg,0) != 0 THEN
                        UPDATE COBERT_ACT_ASEG
                           SET SumaAseg_Local   = Z.VecesSalario * Y.SalarioMensual, 
                               SumaAseg_Moneda  = Z.VecesSalario * Y.SalarioMensual,
                               Prima_Local      = (Z.VecesSalario * Y.SalarioMensual) * Z.FactorReglaSumaAseg, 
                               Prima_Moneda     = (Z.VecesSalario * Y.SalarioMensual) * Z.FactorReglaSumaAseg, 
                               Tasa             = Z.FactorReglaSumaAseg,
                               SalarioMensual   = Y.SalarioMensual,
                               VecesSalario     = Z.VecesSalario
                         WHERE CodCia        = nCodCia
                           AND CodEmpresa    = nCodEmpresa
                           AND IdPoliza      = nIdPoliza
                           AND IDetPol       = nIDetPol 
                           AND Cod_Asegurado = nCod_Asegurado
                           AND CodCobert     = Z.CodCobert;
                     END IF;
                  END LOOP;
                  OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado);
                  OC_ASEGURADO_CERTIFICADO.ACTUALIZA_ASISTENCIAS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado);
               END LOOP;
               OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, nIDetPol, 0);
            END IF;
         END LOOP;

         --  INICIA CLAUREN
         SELECT COUNT(*)
           INTO nEXISTE
           FROM SOLICITUDES_CLAUSULAS SC
          WHERE SC.CODCIA   = nCodCia
            AND SC.IDPOLIZA = nIdSolicitud;
         --
         IF nEXISTE = 0 THEN
            OC_POLIZAS.INSERTA_CLAUSULAS(nCodCia,nCodEmpresa,nIdPoliza);
         ELSE
            OC_SOLICITUDES_CLAUSULAS.TRASLADA_CLAUSULAS(nCodCia,nCodEmpresa,nIdSolicitud,nIdPoliza);
         END IF;
         --  FIN CLAUREN
         UPDATE SOLICITUD_EMISION
            SET IdPoliza        = nIdPoliza,
                NumPolUnicoAsig = cNumPolUnico
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND IdSolicitud = nIdSolicitud;

         ---si la cotizacion es no nula entonces aplica procedimiento de pantalla 

         OC_SOLICITUD_EMISION.POR_EMITIR(nCodCia, nCodEmpresa, nIdSolicitud);

         OC_POLIZAS.ACTUALIZA_VALORES(nCodCia, nIdPoliza, 0);
         OC_POLIZAS.EMITIR_POLIZA(nCodCia, nIdPoliza, nCodEmpresa);
      END IF;
   END LOOP;
END ENVIAR_EMISION;


PROCEDURE GENERAR_REPORTE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitudIni NUMBER,
                          nIdSolicitudFin NUMBER, cStsSolicitud VARCHAR2, dFecIniVig DATE,
                          dFecFinVig DATE, cUsuario VARCHAR2, nCodDirecRegional NUMBER) IS
cCodUser                   VARCHAR2(30)   := USER;
nLinea                     NUMBER(15)     := 1;
cCadena                    VARCHAR2(4000);
cNumPolUnico               POLIZAS.NumPolUnico%TYPE;
dFecEmision                POLIZAS.FecEmision%TYPE;
cStsPoliza                 POLIZAS.StsPoliza%TYPE;

CURSOR SOL_Q IS
   SELECT CodCia, CodEmpresa, IdSolicitud, IdTipoSeg, PlanCob, Cod_Moneda, TasaCambio, Tipo_Doc_Identificacion,
          Num_Doc_Identificacion, FecIniVig, FecFinVig, CodPlanPago, NumCotizacion,
          TipoAdministracion, CodAgrupador, IndFacturaPol, IndFactSubGrupo,
          StsSolicitud, FecStsSol, CodUsuario, IdPoliza,
          OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(Tipo_Doc_Identificacion, Num_Doc_Identificacion) NomContratante,
          OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(CodCia, CodEmpresa, IdTipoSeg) DescProducto,
          OC_PLAN_COBERTURAS.NOMBRE_PLANCOB(CodCia, CodEmpresa, IdTipoSeg, PlanCob) DescPlanCoberturas,
          OC_PLAN_DE_PAGOS.DESCRIPCION_PLAN(CodCia, CodEmpresa, CodPlanPago) DescPlanPagos,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ADMINPOL', TipoAdministracion) DescTipoAdmin,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('AGRUPA', CodAgrupador) DescAgrupador,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', StsSolicitud) DescStsSolicitud,
          OC_GENERALES.FUN_NOMBREUSUARIO(CodCia, CodUsuario) NomUsuario,
          CodDirecRegional, OC_DIRECCION_REGIONAL.NOMBRE_DIRECCION(CodCia, CodDirecRegional) NomDirecRegional,
          TipoDocIdentifAseg, NumDocIdentifAseg,
          OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(TipoDocIdentifAseg, NumDocIdentifAseg) NomAsegurado,
          NumFolioPortal
     FROM SOLICITUD_EMISION
    WHERE CodCia          = nCodCia
      AND CodEmpresa      = nCodEmpresa
      AND IdSolicitud    >= nIdSolicitudIni
      AND IdSolicitud    <= nIdSolicitudFin
      AND StsSolicitud LIKE cStsSolicitud || '%'
      AND ((FecIniVig     >= dFecIniVig AND dFecIniVig IS NOT NULL)
       OR (dFecIniVig IS NULL))
      AND ((FecFinVig     <= dFecFinVig AND dFecFinVig IS NOT NULL)
       OR (dFecFinVig IS NULL))
      AND ((CodDirecRegional = nCodDirecRegional AND nCodDirecRegional IS NOT NULL)
       OR (nCodDirecRegional IS NULL))
      AND CodUsuario    LIKE cUsuario || '%'
    ORDER BY CodCia, CodEmpresa, IdSolicitud;
BEGIN
   -- Escribe Encabezado de Archivo Excel
   nLinea   := 1;
   cCadena  := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                    ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                    ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                    ' <style id="libro">'||chr(10)||
                    '   <!--table'||chr(10)||
                    '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                    '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                    '        .texto'||chr(10)||
                    '          {mso-number-format:"\@";}'||chr(10)||
                    '        .numero'||chr(10)||
                    '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                    '        .fecha'||chr(10)||
                    '          {mso-number-format:"dd\\-mm\\-yyyy";}'||chr(10)||
                    '    -->'||chr(10)||
                    ' </style><div id="libro">'||chr(10);

   OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

   nLinea := nLinea + 1;
   cCadena     := '<table border = 0><tr><th>' || OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia) || '</th></tr>';
   OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

   nLinea := nLinea + 1;
   cCadena     := '<tr><th>REPORTE DE SOLICITUDES DE LA No. '|| TRIM(TO_CHAR(nIdSolicitudIni)) || ' A LA No. ' ||
                   TRIM(TO_CHAR(nIdSolicitudFin)) || '</th></tr>';
   OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

   nLinea := nLinea + 1;
   cCadena     := '<tr><th>  </th></tr></table>';
   OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

   nLinea := nLinea + 1;
   cCadena     := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Solicitud</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Status Solicitud</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Status</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Cotización</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Contratante</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Asegurado</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Póliza</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Status Póliza</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Emision</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Inicio Vigencia</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fin Vigencia</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Producto</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Plan de Coberturas</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Moneda</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tasa de Cambio</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Plan de Pagos</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Administración</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Agrupador</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Usuario</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Dirección Regional</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Folio Portal</font></th>';
   OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

   FOR X IN SOL_Q LOOP
      IF NVL(X.IdPoliza,0) != 0 THEN
         BEGIN
            SELECT NumPolUnico, FecEmision, StsPoliza
              INTO cNumPolUnico, dFecEmision, cStsPoliza
              FROM POLIZAS
             WHERE CodCia     = X.CodCia
               AND CodEmpresa = X.CodEmpresa
               AND IdPoliza   = X.IdPoliza;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cNumPolUnico := NULL;
               dFecEmision  := NULL;
               cStsPoliza   := NULL;
         END;
         IF cStsPoliza = 'SOL' THEN
            dFecEmision := NULL;
         END IF;
      ELSE
         cNumPolUnico   := NULL;
         dFecEmision    := NULL;
         cStsPoliza     := NULL;
      END IF;

      nLinea := nLinea + 1;
      cCadena := '<tr>' || OC_ARCHIVO.CAMPO_HTML(LPAD(TRIM(TO_CHAR(X.IdSolicitud)),14,'0'),'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.StsSolicitud || '-' || X.DescStsSolicitud,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.FecStsSol,'D') ||
                 OC_ARCHIVO.CAMPO_HTML(X.NumCotizacion,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.NomContratante,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.NomAsegurado,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(cNumPolUnico,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(cStsPoliza,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(dFecEmision,'D') ||
                 OC_ARCHIVO.CAMPO_HTML(X.FecIniVig,'D') ||
                 OC_ARCHIVO.CAMPO_HTML(X.FecFinVig,'D') ||
                 OC_ARCHIVO.CAMPO_HTML(X.IdTipoSeg || '-' || X.DescProducto,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.PlanCob || '-' || X.DescPlanCoberturas,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Cod_Moneda ,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.TasaCambio,'999990.00'),'N') ||
                 OC_ARCHIVO.CAMPO_HTML(X.CodPlanPago || '-' || X.DescPlanPagos,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.TipoAdministracion || '-' || X.DescTipoAdmin,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.CodAgrupador || '-' || X.DescAgrupador,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.CodUsuario || '-' || X.NomUsuario,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.CodDirecRegional || '-' || X.NomDirecRegional,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.NumFolioPortal,'C') || '</tr>';
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END LOOP;
   OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0);
END GENERAR_REPORTE;

PROCEDURE REVERTIR_ENVIO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIdPoliza NUMBER) IS
cStsPoliza     POLIZAS.StsPoliza%TYPE;
nIDetPol       DETALLE_POLIZA.IDetPol%TYPE;
cExiste        VARCHAR2(1);
cEliminoCateg  VARCHAR2(1) := 'N';
cEliminoFilial VARCHAR2(1) := 'N';
cCodGrupoEc    POLIZAS.CodGrupoEc%TYPE;
cTipoPol       POLIZAS.TipoPol%TYPE;

CURSOR DET_Q IS
   SELECT P.CodGrupoEc, D.IDetPol, D.CodFilial, D.CodCategoria
     FROM DETALLE_POLIZA D, POLIZAS P
    WHERE D.CodCia   = P.CodCia
      AND D.IdPoliza = P.IdPoliza
      AND D.CodCia   = nCodCia
      AND P.IdPoliza = nIdPoliza;
BEGIN
   BEGIN
      SELECT StsPoliza, TipoPol
        INTO cStsPoliza, cTipoPol
        FROM POLIZAS
       WHERE IdPoliza  = nIdPoliza
         AND CodCia    = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Póliza No. Consecutivo : '|| nIdPoliza);
   END;

   IF cStsPoliza = 'ANU' THEN
      RAISE_APPLICATION_ERROR(-20225,'Póliza No. Consecutivo : '|| nIdPoliza || ' Ya Fue Anulada. No Puede Revertir la Solicitud');
   ELSIF cStsPoliza = 'REN' THEN
      RAISE_APPLICATION_ERROR(-20225,'Póliza No. Consecutivo : '|| nIdPoliza || ' Ya Fue Renovada. No Puede Revertir la Solicitud');
   ELSIF cStsPoliza = 'EMI' THEN
      OC_POLIZAS.REVERTIR_EMISION(nCodCia, nCodEmpresa, nIdPoliza, cTipoPol);
   END IF;

   FOR X IN DET_Q LOOP
      cEliminoCateg  := 'N';
      cEliminoFilial := 'N';

      DELETE AGENTES_DISTRIBUCION_COMISION
       WHERE CodCia   = nCodCia
         AND IdPoliza = nIdPoliza
         AND IDetPol  = X.IDetPol;

      DELETE AGENTES_DETALLES_POLIZAS
       WHERE CodCia   = nCodCia
         AND IdPoliza = nIdPoliza
         AND IDetPol  = X.IDetPol;

      BEGIN
         SELECT 'S'
           INTO cExiste
           FROM DETALLE_POLIZA D, POLIZAS P
          WHERE P.CodGrupoEc    = X.CodGrupoEc
            AND P.IdPoliza      = D.IdPoliza
            AND P.CodCia        = D.CodCia
            AND D.CodCia        = nCodCia
            AND D.IdPoliza     != nIdPoliza
            AND D.CodFilial     = X.CodFilial
            AND D.CodCategoria  = X.CodCategoria;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cExiste := 'N';
         WHEN TOO_MANY_ROWS THEN
            cExiste := 'S';
      END;

      IF cExiste = 'N' THEN
         cEliminoCateg := 'S';
         DELETE FILIALES_CATEGORIAS
          WHERE CodCia        = nCodCia
            AND CodGrupoEc    = X.CodGrupoEc
            AND CodFilial     = X.CodFilial
            AND CodCategoria  = X.CodCategoria;
      END IF;

      BEGIN
         SELECT 'S'
           INTO cExiste
           FROM DETALLE_POLIZA D, POLIZAS P
          WHERE P.CodGrupoEc    = X.CodGrupoEc
            AND P.IdPoliza      = D.IdPoliza
            AND P.CodCia        = D.CodCia
            AND D.CodCia        = nCodCia
            AND D.IdPoliza     != nIdPoliza
            AND D.CodFilial     = X.CodFilial;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cExiste := 'N';
         WHEN TOO_MANY_ROWS THEN
            cExiste := 'S';
      END;

      IF cExiste = 'N' AND cEliminoCateg = 'S' THEN
         cEliminoFilial := 'S';
         DELETE FILIALES
          WHERE CodCia     = nCodCia
            AND CodGrupoEc = X.CodGrupoEc
            AND CodFilial  = X.CodFilial;
      END IF;

      cCodGrupoEc := X.CodGrupoEc;

      DELETE COBERT_ACT
       WHERE CodCia   = nCodCia
         AND IdPoliza = nIdPoliza
         AND IDetPol  = X.IDetPol;

      DELETE ASISTENCIAS_DETALLE_POLIZA
       WHERE CodCia   = nCodCia
         AND IdPoliza = nIdPoliza
         AND IDetPol  = X.IDetPol;

      DELETE COBERT_ACT_ASEG
       WHERE CodCia   = nCodCia
         AND IdPoliza = nIdPoliza
         AND IDetPol  = X.IDetPol;

      DELETE ASISTENCIAS_ASEGURADO
       WHERE CodCia   = nCodCia
         AND IdPoliza = nIdPoliza
         AND IDetPol  = X.IDetPol;

      DELETE ASEGURADO_CERTIFICADO
       WHERE CodCia   = nCodCia
         AND IdPoliza = nIdPoliza
         AND IDetPol  = X.IDetPol;

      DELETE DETALLE_POLIZA
       WHERE CodCia   = nCodCia
         AND IdPoliza = nIdPoliza
         AND IDetPol  = X.IDetPol;
   END LOOP;

   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM POLIZAS
       WHERE CodCia      = nCodCia
         AND IdPoliza   != nIdPoliza
         AND CodGrupoEc  = cCodGrupoEc;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;

   IF cExiste = 'N' AND cEliminoFilial = 'S' THEN
      DELETE GRUPO_ECONOMICO
       WHERE CodCia      = nCodCia
         AND CodGrupoEc  = cCodGrupoEc;
   END IF;

   DELETE AGENTES_DISTRIBUCION_POLIZA
    WHERE CodCia   = nCodCia
      AND IdPoliza = nIdPoliza;

   DELETE AGENTE_POLIZA
    WHERE CodCia   = nCodCia
      AND IdPoliza = nIdPoliza;

   DELETE CLAUSULAS_POLIZA            --CLAUREN
    WHERE CodCia   = nCodCia          --CLAUREN
      AND IdPoliza = nIdPoliza;       --CLAUREN

   DELETE POLIZAS
    WHERE CodCia   = nCodCia
      AND IdPoliza = nIdPoliza;

   UPDATE SOLICITUD_EMISION
      SET IdPoliza    = NULL
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND IdSolicitud = nIdSolicitud;

   OC_SOLICITUD_EMISION.ACTIVAR(nCodCia, nCodEmpresa, nIdSolicitud);
END REVERTIR_ENVIO;

FUNCTION ASEGURADO_MODELO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN VARCHAR2 IS
cIndAsegModelo   SOLICITUD_EMISION.IndAsegModelo%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndAsegModelo,'N')
        INTO cIndAsegModelo
        FROM SOLICITUD_EMISION
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdSolicitud = nIdSolicitud;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndAsegModelo := 'N';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros de la Solicitud No. ' || nIdSolicitud);
   END;
   RETURN(cIndAsegModelo);
END ASEGURADO_MODELO;

FUNCTION TOTAL_PRIMA_NETA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN NUMBER IS
nPrimaNetaPol   SOLICITUD_EMISION.PrimaNetaPol%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PrimaNetaPol,0)
        INTO nPrimaNetaPol
        FROM SOLICITUD_EMISION
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdSolicitud = nIdSolicitud;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPrimaNetaPol := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros de la Solicitud No. ' || nIdSolicitud);
   END;
   RETURN(nPrimaNetaPol);
END TOTAL_PRIMA_NETA;

FUNCTION FOLIO_PORTAL(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN VARCHAR2 IS
cNumFolioPortal   SOLICITUD_EMISION.NumFolioPortal%TYPE;
BEGIN
   BEGIN
      SELECT NumFolioPortal
        INTO cNumFolioPortal
        FROM SOLICITUD_EMISION
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdSolicitud = nIdSolicitud;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNumFolioPortal := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros de la Solicitud No. ' || nIdSolicitud);
   END;
   RETURN(cNumFolioPortal);
END FOLIO_PORTAL;

PROCEDURE COPIAR_SOLICITUD(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) IS
nIdSolicitudNueva    SOLICITUD_EMISION.IdSolicitud%TYPE;
BEGIN
   BEGIN
      nIdSolicitudNueva := OC_SOLICITUD_EMISION.NUMERO_SOLICITUD(nCodCia, nCodEmpresa);
      INSERT INTO SOLICITUD_EMISION
             (CodCia, CodEmpresa, IdSolicitud, IdPoliza, IdTipoSeg, PlanCob,
              Cod_Moneda, TasaCambio, Tipo_Doc_Identificacion, Num_Doc_Identificacion,
              FecIniVig, FecFinVig, CodPlanPago, TipoAdministracion, CodAgrupador,
              IndFacturaPol, IndFactSubGrupo, StsSolicitud, FecStsSol, CodUsuario,
              NumCotizacion, NumPolUnicoAsig, IndAsegModelo, PrimaNetaPol, DescSolicitud,
              IndFactElectronica, IndCalcDerechoEmis, CodDirecRegional, NumFolioPortal,
              TipoDocIdentifAseg, NumDocIdentifAseg)
      SELECT CodCia, CodEmpresa, nIdSolicitudNueva, NULL, IdTipoSeg, PlanCob,
              Cod_Moneda, TasaCambio, Tipo_Doc_Identificacion, Num_Doc_Identificacion,
              FecIniVig, FecFinVig, CodPlanPago, TipoAdministracion, CodAgrupador,
              IndFacturaPol, IndFactSubGrupo, 'XENVIA', TRUNC(SYSDATE), USER,
              NumCotizacion, NULL, IndAsegModelo, PrimaNetaPol, DescSolicitud,
              IndFactElectronica, IndCalcDerechoEmis, CodDirecRegional, NULL,
              TipoDocIdentifAseg, NumDocIdentifAseg
        FROM SOLICITUD_EMISION
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdSolicitud = nIdSolicitud;
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20225,'Nueva Solicitud No. ' || nIdSolicitudNueva || ' Ya Existe en el Sistema');
   END;

   OC_SOLICITUD_DETALLE.COPIAR(nCodCia, nCodEmpresa, nIdSolicitud, nIdSolicitudNueva);
   OC_SOLICITUD_COBERTURAS.COPIAR(nCodCia, nCodEmpresa, nIdSolicitud, nIdSolicitudNueva);
   OC_SOLICITUD_ASISTENCIAS.COPIAR(nCodCia, nCodEmpresa, nIdSolicitud, nIdSolicitudNueva);
   OC_SOLICITUD_DETALLE_ASEG.COPIAR(nCodCia, nCodEmpresa, nIdSolicitud, nIdSolicitudNueva);
   OC_SOLICITUD_AGENTE.COPIAR(nCodCia, nCodEmpresa, nIdSolicitud, nIdSolicitudNueva);
   OC_SOLICITUD_AGENTES_DISTRIB.COPIAR(nCodCia, nCodEmpresa, nIdSolicitud, nIdSolicitudNueva);
   OC_SOLICITUDES_CLAUSULAS.COPIAR(nCodCia, nCodEmpresa, nIdSolicitud, nIdSolicitudNueva);    --CLAUREN
END COPIAR_SOLICITUD;

FUNCTION TIPO_SEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN VARCHAR2 IS
    cIdTipoSeg SOLICITUD_EMISION.IdTipoSeg%TYPE;
BEGIN
    BEGIN
      SELECT IdTipoSeg
        INTO cIdTipoSeg
        FROM SOLICITUD_EMISION
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdSolicitud = nIdSolicitud;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIdTipoSeg := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros de la Solicitud No. ' || nIdSolicitud);
   END;
   RETURN(cIdTipoSeg);
END TIPO_SEGURO;

FUNCTION PLAN_COBERTURA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN VARCHAR2 IS
    cPlanCob SOLICITUD_EMISION.PlanCob%TYPE;
BEGIN
    BEGIN
      SELECT PlanCob
        INTO cPlanCob
        FROM SOLICITUD_EMISION
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdSolicitud = nIdSolicitud;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cPlanCob := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros de la Solicitud No. ' || nIdSolicitud);
   END;
   RETURN(cPlanCob);
END PLAN_COBERTURA;

FUNCTION FECHA_INI_VIG(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN DATE IS
    dFecIniVig SOLICITUD_EMISION.FecIniVig%TYPE;
BEGIN
    BEGIN
      SELECT FecIniVig
        INTO dFecIniVig
        FROM SOLICITUD_EMISION
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdSolicitud = nIdSolicitud;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         dFecIniVig := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros de la Solicitud No. ' || nIdSolicitud);
   END;
   RETURN(dFecIniVig);
END FECHA_INI_VIG;

FUNCTION FECHA_FIN_VIG(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN DATE IS
    dFecFinVig SOLICITUD_EMISION.FecFinVig%TYPE;
BEGIN
    BEGIN
      SELECT FecFinVig
        INTO dFecFinVig
        FROM SOLICITUD_EMISION
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdSolicitud = nIdSolicitud;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         dFecFinVig := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros de la Solicitud No. ' || nIdSolicitud);
   END;
   RETURN(dFecFinVig);
END FECHA_FIN_VIG;

PROCEDURE DATOS_COTIZACION (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIdCotizacion NUMBER) IS
CURSOR COT_Q IS
   SELECT PorcDescuento, PorcGtoAdmin, PorcGtoAdqui, PorcUtilidad,
          FactorAjuste, MontoDeducible, FactFormulaDeduc,
          CodRiesgoRea, CodTipoBono, HorasVig, DiasVig,
          IndExtraPrima, AsegAdheridosPor, PorcenContributorio,
          FuenteRecursosPrima
     FROM COTIZACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;
BEGIN
   FOR W IN COT_Q LOOP
      UPDATE POLIZAS
         SET PorcDescuento        = W.PorcDescuento,
             PorcGtoAdmin         = W.PorcGtoAdmin,
             PorcGtoAdqui         = W.PorcGtoAdqui,
             PorcUtilidad         = W.PorcUtilidad,
             FactorAjuste         = W.FactorAjuste,
             MontoDeducible       = W.MontoDeducible,
             FactFormulaDeduc     = W.FactFormulaDeduc,
             CodRiesgoRea         = W.CodRiesgoRea,
             CodTipoBono          = W.CodTipoBono,
             HorasVig             = W.HorasVig,
             DiasVig              = W.DiasVig,
             IndExtraPrima        = W.IndExtraPrima,
             AsegAdheridosPor     = W.AsegAdheridosPor,
             PorcenContributorio  = W.PorcenContributorio,
             FuenteRecursosPrima  = W.FuenteRecursosPrima,
             Num_Cotizacion       = nIdCotizacion
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdPoliza   = nIdPoliza;  
   END LOOP;
END DATOS_COTIZACION; 

END OC_SOLICITUD_EMISION;
