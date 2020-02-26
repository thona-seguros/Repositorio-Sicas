CREATE OR REPLACE PACKAGE SICAS_OC.GT_COTIZACIONES IS

   FUNCTION VALIDAR_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2;
   PROCEDURE EMITIR_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER);
   PROCEDURE ANULAR_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER);
   PROCEDURE ABRIR_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER);
   FUNCTION NUMERO_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN NUMBER;
   PROCEDURE RECOTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER);
   FUNCTION INICIO_VIGENCIA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN DATE;
   PROCEDURE ACTUALIZAR_VALORES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER);
   PROCEDURE RECALCULAR_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER,
                                  cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2, cIndAsegModelo VARCHAR2,
                                  cIndCensoSubgrupo VARCHAR2, cIndListadoAseg VARCHAR2);
   PROCEDURE EMISION_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdPoliza NUMBER);
   PROCEDURE REVIERTE_EMISION_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER);
   PROCEDURE CALCULA_SAMI(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER);
   FUNCTION TIPO_DE_SEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2;
   FUNCTION PLAN_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2;
   PROCEDURE COPIAR_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER);
   FUNCTION MONTO_SAMI(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN NUMBER;
   FUNCTION IDENTIFICADOR_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2;
   FUNCTION TIENE_EXTRAPRIMAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2;
   FUNCTION EXISTE_COTIZACION_EMITIDA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2;
   FUNCTION FECHA_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN DATE;
   PROCEDURE COPIA_DATOS_A_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdPoliza NUMBER);
   FUNCTION DIAS_RETROACTIVIDAD_EMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN NUMBER;
   FUNCTION NUMERO_UNICO_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2;
   FUNCTION COTIZADOR_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2;

   FUNCTION EXISTE_SIN_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2;
   FUNCTION CREAR_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nCodCliente NUMBER, nCodAsegurado NUMBER) RETURN VARCHAR2;
   PROCEDURE SEND_MAIL(cCtaEnvio IN VARCHAR2, cPwdEmail IN VARCHAR2, cEmail IN VARCHAR2, cEmailDest IN VARCHAR2,cEmailCC IN VARCHAR2 DEFAULT NULL,
                      cEmailBCC IN VARCHAR2 DEFAULT NULL, cSubject IN VARCHAR2, cMessage IN VARCHAR2);
   FUNCTION COTIZACION_WEB(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2;
   FUNCTION COTIZACION_BASE_WEB(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2;
   PROCEDURE MARCA_COTIZACION_WEB(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER);
   FUNCTION COPIAR_COTIZACION_WEB(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN NUMBER;
                         
END GT_COTIZACIONES;
/
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_COTIZACIONES IS

FUNCTION VALIDAR_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2 IS
cIndAsegModelo              COTIZACIONES.IndAsegModelo%TYPE;
cIndListadoAseg             COTIZACIONES.IndListadoAseg%TYPE;
cIndCensoSubgrupo           COTIZACIONES.IndCensoSubgrupo%TYPE;
nIDetCotizacion             COTIZACIONES_DETALLE.IDetCotizacion%TYPE;
nCobCeros                   NUMBER;

CURSOR DET_Q IS
   SELECT IDetCotizacion, CantAsegurados
     FROM COTIZACIONES_DETALLE
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;

CURSOR CENSO_Q IS
   SELECT IDetCotizacion, IdAsegurado, CantAsegurados
     FROM COTIZACIONES_CENSO_ASEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion;

CURSOR ASEG_Q IS
   SELECT IDetCotizacion, IdAsegurado
     FROM COTIZACIONES_ASEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion;
BEGIN
   SELECT IndAsegModelo, IndListadoAseg, IndCensoSubgrupo
     INTO cIndAsegModelo, cIndListadoAseg, cIndCensoSubgrupo
     FROM COTIZACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;

   IF GT_COTIZACIONES_DETALLE.EXISTE_DETALLE_COTIZACION(nCodCia, nCodEmpresa, nIdCotizacion) = 'N' THEN
      RAISE_APPLICATION_ERROR(-20200,'Cotización No. ' || nIdCotizacion || ' NO tiene Subgrupos Asignados');
   ELSIF cIndCensoSubgrupo = 'C' AND 
         GT_COTIZACIONES_CENSO_ASEG.EXISTE_CENSO_COTIZACION(nCodCia, nCodEmpresa, nIdCotizacion) = 'N' THEN
      RAISE_APPLICATION_ERROR(-20200,'Cotización No. ' || nIdCotizacion || ' NO tiene Censos Asignados');
   ELSIF cIndCensoSubgrupo = 'A' AND 
         GT_COTIZACIONES_ASEG.EXISTEN_ASEGURADOS_COTIZACION(nCodCia, nCodEmpresa, nIdCotizacion) = 'N' THEN
      RAISE_APPLICATION_ERROR(-20200,'Cotización No. ' || nIdCotizacion || ' NO tiene Listado de Asegurados');
   END IF;
   
   FOR W IN DET_Q LOOP
      nIDetCotizacion := W.IDetCotizacion;
      IF cIndAsegModelo = 'S' THEN
         IF GT_COTIZACIONES_DETALLE.TIENE_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion) = 'N' THEN
             RAISE_APPLICATION_ERROR(-20200,'Cotización No. ' || nIdCotizacion || ' NO tiene Coberturas Asignadas');
         END IF;

         SELECT COUNT(*)
           INTO nCobCeros
           FROM COTIZACIONES_COBERTURAS
          WHERE CodCia            = nCodCia
            AND CodEmpresa        = nCodEmpresa
            AND IdCotizacion      = nIdCotizacion
            AND IDetCotizacion    = nIDetCotizacion
            AND SumaAsegCobMoneda = 0
            AND PrimaCobMoneda    = 0;
         
         IF NVL(nCobCeros,0) > 0 THEN
            RAISE_APPLICATION_ERROR(-20200,'Cotización No. ' || nIdCotizacion || ' y SubGrupo No. ' || nIDetCotizacion ||
                                    ' tiene Coberturas con Suma Asegurada y Prima Cero');
         END IF;
      ELSIF cIndCensoSubgrupo = 'S' THEN
         FOR X IN CENSO_Q LOOP
            IF GT_COTIZACIONES_CENSO_ASEG.TIENE_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, X.IdAsegurado) = 'N' THEN
               RAISE_APPLICATION_ERROR(-20200,'Cotización No. ' || nIdCotizacion || ' SubGrupo No. ' || nIDetCotizacion ||
                                       ' y Censo No. ' || X.IdAsegurado ||' NO tiene Coberturas Asignadas');
            END IF;

            SELECT COUNT(*)
              INTO nCobCeros
              FROM COTIZACIONES_COBERT_ASEG
             WHERE CodCia            = nCodCia
               AND CodEmpresa        = nCodEmpresa
               AND IdCotizacion      = nIdCotizacion
               AND IDetCotizacion    = nIDetCotizacion
               AND IdAsegurado       = X.IdAsegurado
               AND SumaAsegCobMoneda = 0
               AND PrimaCobMoneda    = 0;
         
            IF NVL(nCobCeros,0) > 0 THEN
               RAISE_APPLICATION_ERROR(-20200,'Cotización No. ' || nIdCotizacion || ' SubGrupo No. ' || nIDetCotizacion ||
                                       ' y Censo No. ' || X.IdAsegurado || ' tiene Coberturas con Suma Asegurada y Prima en Cero');
            END IF;
         END LOOP;
      ELSIF cIndListadoAseg = 'S' THEN
         FOR Z IN ASEG_Q LOOP
            IF GT_COTIZACIONES_ASEG.TIENE_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, Z.IdAsegurado) = 'N' THEN
               RAISE_APPLICATION_ERROR(-20200,'Cotización No. ' || nIdCotizacion || ' SubGrupo No. ' || nIDetCotizacion ||
                                       ' y Asegurado No. ' || Z.IdAsegurado ||' NO tiene Coberturas Asignadas');
            END IF;

            SELECT COUNT(*)
              INTO nCobCeros
              FROM COTIZACIONES_COBERT_ASEG
             WHERE CodCia            = nCodCia
               AND CodEmpresa        = nCodEmpresa
               AND IdCotizacion      = nIdCotizacion
               AND IDetCotizacion    = nIDetCotizacion
               AND IdAsegurado       = Z.IdAsegurado
               AND SumaAsegCobMoneda = 0
               AND PrimaCobMoneda    = 0;
         
            IF NVL(nCobCeros,0) > 0 THEN
               RAISE_APPLICATION_ERROR(-20200,'Cotización No. ' || nIdCotizacion || ' SubGrupo No. ' || nIDetCotizacion ||
                                       ' y Asegurado No. ' || Z.IdAsegurado || ' tiene Coberturas con Suma Asegurada y Prima en Cero');
            END IF;
         END LOOP;
      END IF;
   END LOOP;
   RETURN('S');
END VALIDAR_COTIZACION;

PROCEDURE EMITIR_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) IS
BEGIN
   UPDATE COTIZACIONES
      SET StsCotizacion = 'EMITID'
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;
END EMITIR_COTIZACION;

PROCEDURE ANULAR_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) IS
BEGIN
   UPDATE COTIZACIONES
      SET StsCotizacion = 'ANULAD'
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;
END ANULAR_COTIZACION;

PROCEDURE ABRIR_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) IS
BEGIN
   UPDATE COTIZACIONES
      SET StsCotizacion = 'COTIZA'
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;
END ABRIR_COTIZACION;

FUNCTION NUMERO_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN NUMBER IS
nIdCotizacion      COTIZACIONES.IdCotizacion%TYPE;
BEGIN
   SELECT NVL(MAX(IdCotizacion),0) + 1
     INTO nIdCotizacion
     FROM COTIZACIONES
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa;

   RETURN(nIdCotizacion);
END NUMERO_COTIZACION;

PROCEDURE RECOTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) IS
nIdReCotizacion         COTIZACIONES.IdCotizacion%TYPE;
nIdRecotizacionMax      COTIZACIONES.IdCotizacion%TYPE;
cNumUnicoCotizacion     COTIZACIONES.NumUnicoCotizacion%TYPE;
cNumUnicoCotizacionMax  COTIZACIONES.NumUnicoCotizacion%TYPE;
nConsecutivoCot         NUMBER(5);
CURSOR COT_Q IS
   SELECT NumUnicoCotizacion, CodCotizador, NumCotizacionRef, NumCotizacionAnt,
          NombreContratante, FecIniVigCot, FecFinVigCot, FecCotizacion, FecVenceCotizacion,
          NumDiasRetroactividad, Cod_Moneda, SumaAsegCotLocal, SumaAsegCotMoneda,
          PrimaCotLocal, PrimaCotMoneda, IdTipoSeg, PlanCob, CodAgente, CodPlanPago,
          PorcDescuento, PorcGtoAdmin, PorcGtoAdqui, PorcUtilidad, FactorAjuste,
          MontoDeducible, FactFormulaDeduc, CanalFormaVenta, PorcVariacionEmi, 
          IndAsegModelo, IndListadoAseg, IndCensoSubgrupo, IndExtraPrima, CodRiesgoRea, 
          CodTipoBono, DescPoliticaSumasAseg, DescPoliticaEdades, 
          DescTipoIdentAseg, TipoAdministracion, AsegEnIncapacidad, HorasVig, DiasVig, 
          TextoSuscriptor, CantAsegurados, FactorSamiAseg, PromedioSumaAseg, 
          SumaAsegSAMI, SAMIAutorizado, CodUsuario,  DescGiroNegocio, DescActividadAseg, 
          DescFormulaDividendos, NumPolRenovacion, AsegAdheridosPor, PorcenContributorio, 
          FuenteRecursosPrima, TipoProrrata, PorcComisAgte, PorcComisProm, PorcComisDir, 
          IndConvenciones, PorcConvenciones, DescCuotasPrimaNiv, DescElegibilidad,
          DescRiesgosCubiertos, IndCotizacionWeb,
          IndCotizacionBaseWeb, GASTOSEXPEDICION, CODTIPONEGOCIO, CODPAQCOMERCIAL, CODOFICINA, CODCATEGO
     FROM COTIZACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;
BEGIN
   nIdReCotizacion := NUMERO_COTIZACION(nCodCia, nCodEmpresa);
   FOR W IN COT_Q LOOP
      -- Busca Máxima Recotización
      /*
      SELECT NVL(MAX(IdCotizacion),0)
        INTO nIdRecotizacionMax
        FROM COTIZACIONES N
       WHERE N.CodCia                = nCodCia
         AND N.IdCotizacion         >= nIdCotizacion
         AND N.NumUnicoCotizacion LIKE SUBSTR(W.NumUnicoCotizacion,1,INSTR(W.NumUnicoCotizacion,'-',1,4)) || '%';
--       START WITH IdCotizacion   = nIdCotizacion
--      CONNECT BY PRIOR IdCotizacion = NumCotizacionAnt;

      IF nIdRecotizacionMax = 0 THEN
         cNumUnicoCotizacionMax := W.NumUnicoCotizacion;
      ELSE
         cNumUnicoCotizacionMax := GT_COTIZACIONES.NUMERO_UNICO_COTIZACION(nCodCia, nCodEmpresa, nIdRecotizacionMax);
      END IF;

      IF INSTR(cNumUnicoCotizacionMax,'-',1,4) = 0 THEN
         cNumUnicoCotizacion := cNumUnicoCotizacionMax || '-000';
      ELSE
         nConsecutivoCot     := SUBSTR(cNumUnicoCotizacionMax,INSTR(cNumUnicoCotizacionMax,'-',1,4)+1,3) + 1;
         cNumUnicoCotizacion := SUBSTR(cNumUnicoCotizacionMax,1,INSTR(cNumUnicoCotizacionMax,'-',1,4)) ||
                                TRIM(TO_CHAR(nConsecutivoCot,'000'));
      END IF; 
*/
          SELECT NVL(MAX(IdCotizacion),0)
            INTO nIdRecotizacionMax
            FROM COTIZACIONES N
           WHERE N.CodCia                = nCodCia
             AND N.IdCotizacion         >= nIdCotizacion
             AND N.NumUnicoCotizacion LIKE SUBSTR(W.NumUnicoCotizacion,1,INSTR(W.NumUnicoCotizacion,'-',-1)-1) || '%';

            IF nIdRecotizacionMax = 0 THEN
                cNumUnicoCotizacionMax := W.NumUnicoCotizacion;
            ELSE
                cNumUnicoCotizacionMax := GT_COTIZACIONES.NUMERO_UNICO_COTIZACION(nCodCia, nCodEmpresa, nIdRecotizacionMax);
            END IF;

            IF INSTR(cNumUnicoCotizacionMax, '*') > 0 THEN                        
                IF THONAPI.GENERALES_PLATAFORMA_DIGITAL.ES_NUMERICO(SUBSTR(cNumUnicoCotizacionMax,1,INSTR(cNumUnicoCotizacionMax,'-',-1)-1)) = 0 THEN
                    cNumUnicoCotizacion := REPLACE(cNumUnicoCotizacionMax, '*', '-') || '-';
                ELSE
                    cNumUnicoCotizacion := REPLACE(cNumUnicoCotizacionMax, '*', '-');
                END IF;
            ELSE
                cNumUnicoCotizacion := cNumUnicoCotizacionMax;            
            END IF;
    --                        
            --DBMS_OUTPUT.PUT_LINE(cNumUnicoCotizacionMax);
            --DBMS_OUTPUT.PUT_LINE(cNumUnicoCotizacion);

            SELECT MAX(NVL(SUBSTR(cNumUnicoCotizacion,1,INSTR(cNumUnicoCotizacion,'-',-1)-1), SUBSTR(GT_COTIZACIONES.NUMERO_UNICO_COTIZACION(nCodCia, nCodEmpresa, nIdRecotizacionMax),1,INSTR(GT_COTIZACIONES.NUMERO_UNICO_COTIZACION(nCodCia, nCodEmpresa, nIdRecotizacionMax),'-',-1)-1)) || '-' || DECODE(THONAPI.GENERALES_PLATAFORMA_DIGITAL.ES_NUMERICO(SUBSTR(cNumUnicoCotizacion,INSTR(cNumUnicoCotizacion,'-',-1)+1)), 1, TRIM(TO_CHAR(SUBSTR(cNumUnicoCotizacion,INSTR(cNumUnicoCotizacion,'-',-1)+1) + 1, '000')), '001') ) D
              INTO cNumUnicoCotizacion                                              
              FROM COTIZACIONES N
             WHERE N.CodCia                = 1
               AND N.IdCotizacion         >= 1
               AND N.NumUnicoCotizacion LIKE SUBSTR(cNumUnicoCotizacionMax,1,INSTR(cNumUnicoCotizacionMax,'-',-1)) || '%';

      BEGIN
         INSERT INTO COTIZACIONES
                (CodCia, CodEmpresa, IdCotizacion, NumUnicoCotizacion, CodCotizador, NumCotizacionRef, 
                 NumCotizacionAnt, StsCotizacion, FecStatus, NombreContratante, FecIniVigCot, FecFinVigCot, 
                 FecCotizacion, FecVenceCotizacion, NumDiasRetroactividad, Cod_Moneda, SumaAsegCotLocal,
                 SumaAsegCotMoneda, PrimaCotLocal, PrimaCotMoneda, IdTipoSeg, PlanCob, CodAgente, CodPlanPago,
                 PorcDescuento, PorcGtoAdmin, PorcGtoAdqui, PorcUtilidad, FactorAjuste, 
                 MontoDeducible, FactFormulaDeduc, CanalFormaVenta, PorcVariacionEmi, IndAsegModelo, 
                 IndListadoAseg, IndCensoSubgrupo, IndExtraPrima, CodRiesgoRea, CodTipoBono, 
                 DescPoliticaSumasAseg, DescPoliticaEdades, DescTipoIdentAseg, TipoAdministracion, 
                 AsegEnIncapacidad, HorasVig, DiasVig, TextoSuscriptor, CantAsegurados, 
                 FactorSamiAseg, PromedioSumaAseg, SumaAsegSAMI, SAMIAutorizado, CodUsuario, DescGiroNegocio, 
                 DescActividadAseg, DescFormulaDividendos, NumPolRenovacion, AsegAdheridosPor, PorcenContributorio, 
                 FuenteRecursosPrima, TipoProrrata, PorcComisAgte, PorcComisProm, PorcComisDir,  IndConvenciones, 
                 PorcConvenciones, DescCuotasPrimaNiv, DescElegibilidad, DescRiesgosCubiertos, 
                 IndCotizacionWeb, IndCotizacionBaseWeb, GASTOSEXPEDICION, CODTIPONEGOCIO, CODPAQCOMERCIAL, CODOFICINA, CODCATEGO )
         VALUES (nCodCia, nCodEmpresa, nIdReCotizacion, cNumUnicoCotizacion, W.CodCotizador, W.NumCotizacionRef, 
                 nIdCotizacion, 'COTIZA', TRUNC(SYSDATE), W.NombreContratante, W.FecIniVigCot, W.FecFinVigCot, 
                 TRUNC(SYSDATE), TRUNC(SYSDATE) + GT_COTIZADOR_CONFIG.DIAS_VIGENCIA_COTIZACION(nCodCia, nCodEmpresa, W.CodCotizador),
                 W.NumDiasRetroactividad, W.Cod_Moneda, W.SumaAsegCotLocal, W.SumaAsegCotMoneda, W.PrimaCotLocal, 
                 W.PrimaCotMoneda, W.IdTipoSeg, W.PlanCob, W.CodAgente, W.CodPlanPago, W.PorcDescuento, 
                 W.PorcGtoAdmin, W.PorcGtoAdqui, W.PorcUtilidad, W.FactorAjuste,  W.MontoDeducible, W.FactFormulaDeduc, 
                 W.CanalFormaVenta,  W.PorcVariacionEmi, W.IndAsegModelo, W.IndListadoAseg, W.IndCensoSubgrupo, 
                 W.IndExtraPrima, W.CodRiesgoRea, W.CodTipoBono, W.DescPoliticaSumasAseg, 
                 W.DescPoliticaEdades, W.DescTipoIdentAseg, W.TipoAdministracion, W.AsegEnIncapacidad, 
                 W.HorasVig, W.DiasVig, W.TextoSuscriptor, W.CantAsegurados, W.FactorSamiAseg, 
                 W.PromedioSumaAseg, W.SumaAsegSAMI, W.SAMIAutorizado, USER, W.DescGiroNegocio, W.DescActividadAseg, 
                 W.DescFormulaDividendos, W.NumPolRenovacion, W.AsegAdheridosPor, W.PorcenContributorio, 
                 W.FuenteRecursosPrima, W.TipoProrrata, W.PorcComisAgte, W.PorcComisProm, W.PorcComisDir, 
                 W.IndConvenciones, W.PorcConvenciones, W.DescCuotasPrimaNiv, W.DescElegibilidad, W.DescRiesgosCubiertos,
                 W.IndCotizacionWeb, W.IndCotizacionBaseWeb, NVL(W.GASTOSEXPEDICION, 0), W.CODTIPONEGOCIO, W.CODPAQCOMERCIAL, W.CODOFICINA, W.CODCATEGO );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20200,'Duplicada Cotización No. ' || nIdCotizacion);
      END;
      GT_COTIZACIONES_CLAUSULAS.RECOTIZACION_CLAUSULAS(nCodCia, nCodEmpresa, nIdCotizacion, nIdRecotizacion);
      GT_COTIZACIONES_DETALLE.RECOTIZACION_DETALLE(nCodCia, nCodEmpresa, nIdCotizacion, nIdRecotizacion);
      GT_COTIZACIONES_COBERT_MASTER.RECOTIZACION_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, nIdRecotizacion);
      IF W.IndCensoSubgrupo = 'S' THEN
         GT_COTIZACIONES_CENSO_ASEG.RECOTIZACION_CENSO(nCodCia, nCodEmpresa, nIdCotizacion, nIdRecotizacion);
      ELSIF W.IndListadoAseg = 'S' THEN
         GT_COTIZACIONES_ASEG.RECOTIZACION_ASEG(nCodCia, nCodEmpresa, nIdCotizacion, nIdRecotizacion);
      END IF;
   END LOOP;
END RECOTIZACION;
--
FUNCTION INICIO_VIGENCIA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN DATE IS
dFecIniVigCot      COTIZACIONES.FecIniVigCot%TYPE;
BEGIN
   BEGIN
      SELECT FecIniVigCot
        INTO dFecIniVigCot
        FROM COTIZACIONES
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdCotizacion = nIdCotizacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'NO Existe Cotización No. ' || nIdCotizacion);
   END;

   RETURN(dFecIniVigCot);
END INICIO_VIGENCIA;

PROCEDURE ACTUALIZAR_VALORES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) IS
nSumaAsegCotLocal        COTIZACIONES.SumaAsegCotLocal%TYPE;
nSumaAsegCotMoneda       COTIZACIONES.SumaAsegCotMoneda%TYPE;
nSumaAsegSAMILocal       COTIZACIONES.SumaAsegCotLocal%TYPE;
nSumaAsegSAMIMoneda      COTIZACIONES.SumaAsegCotMoneda%TYPE;
nPrimaCotLocal           COTIZACIONES.PrimaCotLocal%TYPE;
nPrimaCotMoneda          COTIZACIONES.PrimaCotMoneda%TYPE;
nCantAsegurados          COTIZACIONES_DETALLE.CantAsegurados%TYPE;
cIdTipoSeg               COTIZACIONES.IdTipoSeg%TYPE;
cPlanCob                 COTIZACIONES.PlanCob%TYPE;
cCodCotizador            COTIZACIONES.CodCotizador%TYPE;
BEGIN
   cIdTipoSeg    := GT_COTIZACIONES.TIPO_DE_SEGURO(nCodCia, nCodEmpresa, nIdCotizacion);
   cPlanCob      := GT_COTIZACIONES.PLAN_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion);
   cCodCotizador := GT_COTIZACIONES.COTIZADOR_COTIZACION(nCodCia, nCodEmpresa, nIdCotizacion);

   SELECT NVL(SUM(SumaAsegDetLocal),0), NVL(SUM(SumaAsegDetMoneda),0),
          NVL(SUM(PrimaDetLocal),0), NVL(SUM(PrimaDetMoneda),0)
     INTO nSumaAsegCotLocal, nSumaAsegCotMoneda,
          nPrimaCotLocal, nPrimaCotMoneda
     FROM COTIZACIONES_DETALLE
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion;

   SELECT NVL(SUM(CantAsegurados),0)
     INTO nCantAsegurados
     FROM COTIZACIONES_DETALLE
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion;

   SELECT NVL(SUM(CantAsegurados),0) + NVL(nCantAsegurados,0)
     INTO nCantAsegurados
     FROM COTIZACIONES_CENSO_ASEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion;

   SELECT COUNT(*) + NVL(nCantAsegurados,0)
     INTO nCantAsegurados
     FROM COTIZACIONES_ASEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion;

   IF GT_COTIZADOR_CONFIG.CALCULA_SAMI(nCodCia, nCodEmpresa, cCodCotizador) = 'S' THEN
      SELECT NVL(SUM(CC.SumaAsegCobLocal),0), NVL(SUM(CC.SumaAsegCobMoneda),0)
        INTO nSumaAsegSAMILocal, nSumaAsegSAMIMoneda
        FROM COTIZACIONES_COBERTURAS CC, COBERTURAS_DE_SEGUROS CS
       WHERE CS.IndSumaSami    = 'S'
         AND CS.CodCobert      = CC.CodCobert
         AND CS.PlanCob        = cPlanCob
         AND CS.IdTipoSeg      = cIdTipoSeg
         AND CS.CodEmpresa     = CC.CodEmpresa
         AND CS.CodCia         = CC.CodCia
         AND CC.CodCia         = nCodCia
         AND CC.CodEmpresa     = nCodEmpresa
         AND CC.IdCotizacion   = nIdCotizacion;

      SELECT NVL(SUM(SumaAsegCobLocal),0) + NVL(nSumaAsegSAMILocal,0),
             NVL(SUM(SumaAsegCobMoneda),0) + NVL(nSumaAsegSAMIMoneda,0)
        INTO nSumaAsegSAMILocal, nSumaAsegSAMIMoneda
        FROM COTIZACIONES_COBERT_ASEG CC, COBERTURAS_DE_SEGUROS CS
       WHERE CS.IndSumaSami    = 'S'
         AND CS.CodCobert      = CC.CodCobert
         AND CS.PlanCob        = cPlanCob
         AND CS.IdTipoSeg      = cIdTipoSeg
         AND CS.CodEmpresa     = CC.CodEmpresa
         AND CS.CodCia         = CC.CodCia
         AND CC.CodCia         = nCodCia
         AND CC.CodEmpresa     = nCodEmpresa
         AND CC.IdCotizacion   = nIdCotizacion;
   ELSE
      nSumaAsegSAMILocal  := 0;
      nSumaAsegSAMIMoneda := 0;
   END IF;

   IF NVL(nCantAsegurados,0) = 0 THEN
      nCantAsegurados := 1;
   END IF;

   UPDATE COTIZACIONES
      SET SumaAsegCotLocal  = NVL(nSumaAsegCotLocal,0),
          SumaAsegCotMoneda = NVL(nSumaAsegCotMoneda,0),
          PrimaCotLocal     = NVL(nPrimaCotLocal,0),
          PrimaCotMoneda    = NVL(nPrimaCotMoneda,0),
          CantAsegurados    = NVL(nCantAsegurados,0),
          PromedioSumaAseg  = NVL(nSumaAsegSAMIMoneda,0) / NVL(nCantAsegurados,1),
          FecStatus         = TRUNC(SYSDATE),
          CodUsuario        = USER
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion;
END ACTUALIZAR_VALORES;

PROCEDURE RECALCULAR_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER,
                                  cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2, cIndAsegModelo VARCHAR2,
                                  cIndCensoSubgrupo VARCHAR2, cIndListadoAseg VARCHAR2) IS

nIDetCotizacion     COTIZACIONES_DETALLE.IDetCotizacion%TYPE;
nIdAsegurado        COTIZACIONES_COBERT_ASEG.IdAsegurado%TYPE;

CURSOR DET_Q IS
   SELECT IDetCotizacion, CantAsegurados
     FROM COTIZACIONES_DETALLE
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;

CURSOR COB_DET_Q IS
   SELECT IDetCotizacion, CodCobert, SumaAsegCobMoneda, SalarioMensual, 
          VecesSalario, Edad_Minima, Edad_Maxima, Edad_Exclusion,
          SumaAseg_Minima, SumaAseg_Maxima, PorcExtraPrimaDet, 
          MontoExtraPrimaDet, SumaIngresada, DeducibleIngresado,
          CuotaPromedio, PrimaPromedio
     FROM COTIZACIONES_COBERTURAS
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion;

CURSOR CENSO_Q IS
   SELECT IDetCotizacion, IdAsegurado, CantAsegurados
     FROM COTIZACIONES_CENSO_ASEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion;

CURSOR ASEG_Q IS
   SELECT IDetCotizacion, IdAsegurado
     FROM COTIZACIONES_ASEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion;

CURSOR COB_ASEG_Q IS
   SELECT IDetCotizacion, IdAsegurado, CodCobert, SumaAsegCobMoneda, SalarioMensual,
          VecesSalario, Edad_Minima, Edad_Maxima, Edad_Exclusion, SumaAseg_Minima, 
          SumaAseg_Maxima, PorcExtraPrimaDet, MontoExtraPrimaDet, SumaIngresada,
          DeducibleIngresado, CuotaPromedio, PrimaPromedio
     FROM COTIZACIONES_COBERT_ASEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion
      AND IDetCotizacion = nIDetCotizacion
      AND IdAsegurado    = nIdAsegurado;
BEGIN
   FOR W IN DET_Q LOOP
      nIDetCotizacion := W.IDetCotizacion;
      IF cIndAsegModelo = 'S' THEN
         IF GT_COTIZACIONES_DETALLE.TIENE_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, W.IDetCotizacion) = 'N' THEN
               GT_COTIZACIONES_COBERTURAS.CARGAR_COBERTURAS(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nIdCotizacion, 
                                                            W.IDetCotizacion, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
         ELSE
            FOR Y IN COB_DET_Q LOOP
               GT_COTIZACIONES_COBERTURAS.CARGAR_COBERTURAS(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nIdCotizacion, 
                                                            Y.IDetCotizacion, NULL, Y.CodCobert, Y.SumaAsegCobMoneda / W.CantAsegurados,
                                                            Y.SalarioMensual, Y.VecesSalario, Y.Edad_Minima, Y.Edad_Maxima,
                                                            Y.Edad_Exclusion, Y.SumaAseg_Minima, Y.SumaAseg_Maxima,
                                                            Y.PorcExtraPrimaDet, Y.MontoExtraPrimaDet, Y.SumaIngresada,
                                                            Y.DeducibleIngresado, Y.CuotaPromedio, Y.PrimaPromedio);
            END LOOP;
         END IF;
         GT_COTIZACIONES_DETALLE.ACTUALIZAR_VALORES(nCodCia, nCodEmpresa, nIdCotizacion, W.IDetCotizacion);
      ELSIF cIndCensoSubgrupo = 'S' THEN
         FOR C IN CENSO_Q LOOP
            IF GT_COTIZACIONES_CENSO_ASEG.TIENE_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, C.IDetCotizacion, C.IdAsegurado) = 'N' THEN
                  GT_COTIZACIONES_COBERTURAS.CARGAR_COBERTURAS(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nIdCotizacion, 
                                                               C.IDetCotizacion, C.IdAsegurado, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
            ELSE
               nIdAsegurado := C.IdAsegurado;
               FOR Y IN COB_ASEG_Q LOOP
                  GT_COTIZACIONES_COBERTURAS.CARGAR_COBERTURAS(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nIdCotizacion, 
                                                               Y.IDetCotizacion, Y.IdAsegurado, Y.CodCobert, Y.SumaAsegCobMoneda / C.CantAsegurados,
                                                               Y.SalarioMensual, Y.VecesSalario, Y.Edad_Minima, Y.Edad_Maxima,
                                                               Y.Edad_Exclusion, Y.SumaAseg_Minima, Y.SumaAseg_Maxima,
                                                               Y.PorcExtraPrimaDet, Y.MontoExtraPrimaDet, Y.SumaIngresada,
                                                               Y.DeducibleIngresado, Y.CuotaPromedio, Y.PrimaPromedio);
               END LOOP;
            END IF;
            GT_COTIZACIONES_CENSO_ASEG.ACTUALIZAR_VALORES(nCodCia, nCodEmpresa, nIdCotizacion, C.IDetCotizacion, C.IdAsegurado);
            GT_COTIZACIONES_DETALLE.ACTUALIZAR_VALORES(nCodCia, nCodEmpresa, nIdCotizacion, W.IDetCotizacion);
         END LOOP;
      ELSE
         FOR A IN ASEG_Q LOOP
            IF GT_COTIZACIONES_ASEG.TIENE_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, A.IDetCotizacion, A.IdAsegurado) = 'N' THEN
                  GT_COTIZACIONES_COBERTURAS.CARGAR_COBERTURAS(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nIdCotizacion, 
                                                               A.IDetCotizacion, A.IdAsegurado, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
            ELSE
               nIdAsegurado := A.IdAsegurado;
               FOR Y IN COB_ASEG_Q LOOP
                  GT_COTIZACIONES_COBERTURAS.CARGAR_COBERTURAS(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nIdCotizacion, 
                                                               Y.IDetCotizacion, Y.IdAsegurado, Y.CodCobert, Y.SumaAsegCobMoneda,
                                                               Y.SalarioMensual, Y.VecesSalario, Y.Edad_Minima, Y.Edad_Maxima,
                                                               Y.Edad_Exclusion, Y.SumaAseg_Minima, Y.SumaAseg_Maxima,
                                                               Y.PorcExtraPrimaDet, Y.MontoExtraPrimaDet, Y.SumaIngresada,
                                                               Y.DeducibleIngresado, Y.CuotaPromedio, Y.PrimaPromedio);
               END LOOP;
            END IF;
            GT_COTIZACIONES_ASEG.ACTUALIZAR_VALORES(nCodCia, nCodEmpresa, nIdCotizacion, A.IDetCotizacion, A.IdAsegurado);
            GT_COTIZACIONES_DETALLE.ACTUALIZAR_VALORES(nCodCia, nCodEmpresa, nIdCotizacion, W.IDetCotizacion);
         END LOOP;
      END IF;
      GT_COTIZACIONES_DETALLE.ACTUALIZAR_VALORES(nCodCia, nCodEmpresa, nIdCotizacion, W.IDetCotizacion);
   END LOOP;
   GT_COTIZACIONES.ACTUALIZAR_VALORES(nCodCia, nCodEmpresa, nIdCotizacion);
   
   IF GT_COTIZACIONES.MONTO_SAMI(nCodCia, nCodEmpresa, nIdCotizacion) > 0 THEN
      GT_COTIZACIONES.CALCULA_SAMI(nCodCia, nCodEmpresa, nIdCotizacion);
   END IF;
END RECALCULAR_COTIZACION;

PROCEDURE EMISION_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdPoliza NUMBER) IS
cNumUnicoCotizacion      COTIZACIONES.NumUnicoCotizacion%TYPE;
CURSOR COT_Q IS
   SELECT IdCotizacion
     FROM COTIZACIONES
    WHERE CodCia             = nCodCia
      AND CodEmpresa         = nCodEmpresa
      AND NumUnicoCotizacion = cNumUnicoCotizacion
      AND StsCotizacion      = 'EMITID';
BEGIN
   SELECT NumUnicoCotizacion
     INTO cNumUnicoCotizacion
     FROM COTIZACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;

   FOR W IN COT_Q LOOP
      UPDATE COTIZACIONES
         SET StsCotizacion = 'ANPOLE',
             FecStatus     = TRUNC(SYSDATE)
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdCotizacion = W.IdCotizacion;
   END LOOP;

   UPDATE COTIZACIONES
      SET StsCotizacion = 'POLEMI',
          FecStatus     = TRUNC(SYSDATE),
          IdPoliza      = nIdPoliza
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;
END EMISION_POLIZA;

PROCEDURE REVIERTE_EMISION_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) IS
cNumUnicoCotizacion      COTIZACIONES.NumUnicoCotizacion%TYPE;
CURSOR COT_Q IS
   SELECT IdCotizacion
     FROM COTIZACIONES
    WHERE CodCia             = nCodCia
      AND CodEmpresa         = nCodEmpresa
      AND NumUnicoCotizacion = cNumUnicoCotizacion
      AND StsCotizacion      = 'ANPOLE';
BEGIN
   SELECT NumUnicoCotizacion
     INTO cNumUnicoCotizacion
     FROM COTIZACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;

   FOR W IN COT_Q LOOP
      UPDATE COTIZACIONES
         SET StsCotizacion = 'EMITID',
             FecStatus     = TRUNC(SYSDATE)
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdCotizacion = W.IdCotizacion;
   END LOOP;

   UPDATE COTIZACIONES
      SET StsCotizacion = 'EMITID',
          FecStatus     = TRUNC(SYSDATE),
          IdPoliza      = NULL
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;
END REVIERTE_EMISION_POLIZA;

PROCEDURE CALCULA_SAMI(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) IS
nRangoSAMI               NUMBER(5);
nCantAsegurados          COTIZACIONES_DETALLE.CantAsegurados%TYPE;
nSumaAsegSAMI            COTIZACIONES.SumaAsegSAMI%TYPE;
nPromedioSumaAseg        COTIZACIONES.PromedioSumaAseg%TYPE;
nSAMIAutorizado          COTIZACIONES.SAMIAutorizado%TYPE;
BEGIN
   ACTUALIZAR_VALORES(nCodCia, nCodEmpresa, nIdCotizacion);

   SELECT NVL(MAX(CantAsegurados),1), NVL(MAX(PromedioSumaAseg),0), NVL(MAX(SAMIAutorizado),0)
     INTO nCantAsegurados, nPromedioSumaAseg, nSAMIAutorizado
     FROM COTIZACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;

   nRangoSAMI     := OC_POLIZAS.RANGO_SAMI(nCodCia, nCodEmpresa, NULL, nCantAsegurados);
   nSumaAsegSAMI  := NVL(nRangoSAMI * nPromedioSumaAseg,0);
   
   IF nSumaAsegSAMI > 12000000 THEN
      nSumaAsegSAMI := 12000000;
   END IF;
   
   IF nSAMIAutorizado = 0 THEN
      nSAMIAutorizado := nSumaAsegSAMI;
   END IF;

   UPDATE COTIZACIONES
      SET FactorSamiAseg   = nRangoSAMI,
          PromedioSumaAseg = nPromedioSumaAseg,
          SumaAsegSAMI     = nSumaAsegSAMI,
          SAMIAutorizado   = nSAMIAutorizado,
          FecStatus        = TRUNC(SYSDATE),
          CodUsuario       = USER
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;
END CALCULA_SAMI;

FUNCTION TIPO_DE_SEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2 IS
cIdTipoSeg      COTIZACIONES.IdTipoSeg%TYPE;
BEGIN
   SELECT IdTipoSeg
     INTO cIdTipoSeg
     FROM COTIZACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;
   RETURN(cIdTipoSeg);
END TIPO_DE_SEGURO;

FUNCTION PLAN_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2 IS
cPlanCob     COTIZACIONES.PlanCob%TYPE;
BEGIN
   SELECT PlanCob
     INTO cPlanCob
     FROM COTIZACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;
   RETURN(cPlanCob);
END PLAN_COBERTURAS;

PROCEDURE COPIAR_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) IS
nIdCotizacionCopia      COTIZACIONES.IdCotizacion%TYPE;
CURSOR COT_Q IS
   SELECT NumUnicoCotizacion, CodCotizador, NumCotizacionRef, NumCotizacionAnt,
          NombreContratante, FecIniVigCot, FecFinVigCot, FecCotizacion, FecVenceCotizacion,
          NumDiasRetroactividad, Cod_Moneda, SumaAsegCotLocal, SumaAsegCotMoneda,
          PrimaCotLocal, PrimaCotMoneda, IdTipoSeg, PlanCob, CodAgente, CodPlanPago,
          PorcDescuento, PorcGtoAdmin, PorcGtoAdqui, PorcUtilidad, FactorAjuste,
          MontoDeducible, FactFormulaDeduc, CanalFormaVenta, PorcVariacionEmi, 
          IndAsegModelo, IndListadoAseg, IndCensoSubgrupo, IndExtraPrima, CodRiesgoRea, 
          CodTipoBono, DescPoliticaSumasAseg, DescPoliticaEdades, DescTipoIdentAseg,
          TipoAdministracion, AsegEnIncapacidad, HorasVig, DiasVig, TextoSuscriptor, 
          CantAsegurados,FactorSamiAseg, PromedioSumaAseg, SumaAsegSAMI, SAMIAutorizado, CodUsuario,
          DescGiroNegocio, DescActividadAseg, DescFormulaDividendos, NumPolRenovacion,
          AsegAdheridosPor, PorcenContributorio, FuenteRecursosPrima, TipoProrrata, 
          PorcComisAgte, PorcComisProm, PorcComisDir, IndConvenciones, PorcConvenciones,
          DescCuotasPrimaNiv, DescElegibilidad, DescRiesgosCubiertos, IndCotizacionWeb,
          IndCotizacionBaseWeb, GASTOSEXPEDICION, CODTIPONEGOCIO, CODPAQCOMERCIAL, CODOFICINA, CODCATEGO
     FROM COTIZACIONES C
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;
BEGIN
   nIdCotizacionCopia := NUMERO_COTIZACION(nCodCia, nCodEmpresa);
   FOR W IN COT_Q LOOP
      BEGIN
         INSERT INTO COTIZACIONES
                (CodCia, CodEmpresa, IdCotizacion, NumUnicoCotizacion, CodCotizador, NumCotizacionRef, 
                 NumCotizacionAnt, StsCotizacion, FecStatus, NombreContratante, FecIniVigCot, FecFinVigCot, 
                 FecCotizacion, FecVenceCotizacion, NumDiasRetroactividad, Cod_Moneda, SumaAsegCotLocal,
                 SumaAsegCotMoneda, PrimaCotLocal, PrimaCotMoneda, IdTipoSeg, PlanCob, CodAgente, CodPlanPago,
                 PorcDescuento, PorcGtoAdmin, PorcGtoAdqui, PorcUtilidad, FactorAjuste, 
                 MontoDeducible, FactFormulaDeduc, CanalFormaVenta, PorcVariacionEmi, IndAsegModelo, 
                 IndListadoAseg, IndCensoSubgrupo, IndExtraPrima, CodRiesgoRea, CodTipoBono, 
                 DescPoliticaSumasAseg, DescPoliticaEdades, DescTipoIdentAseg, TipoAdministracion, 
                 AsegEnIncapacidad, HorasVig, DiasVig, TextoSuscriptor, CantAsegurados, 
                 FactorSamiAseg, PromedioSumaAseg,SumaAsegSAMI, SAMIAutorizado, CodUsuario, DescGiroNegocio, 
                 DescActividadAseg,  DescFormulaDividendos, NumPolRenovacion, AsegAdheridosPor, PorcenContributorio, 
                 FuenteRecursosPrima, TipoProrrata, PorcComisAgte, PorcComisProm, PorcComisDir, 
                 IndConvenciones, PorcConvenciones, DescCuotasPrimaNiv, DescElegibilidad, DescRiesgosCubiertos,
                 IndCotizacionWeb, IndCotizacionBaseWeb, GASTOSEXPEDICION, CODTIPONEGOCIO, CODPAQCOMERCIAL, CODOFICINA, CODCATEGO )
         VALUES (nCodCia, nCodEmpresa, nIdCotizacionCopia, W.NumUnicoCotizacion, W.CodCotizador, W.NumCotizacionRef, 
                 NULL, 'COTIZA', TRUNC(SYSDATE), W.NombreContratante, W.FecIniVigCot, W.FecFinVigCot, 
                 TRUNC(SYSDATE), TRUNC(SYSDATE) + GT_COTIZADOR_CONFIG.DIAS_VIGENCIA_COTIZACION(nCodCia, nCodEmpresa, W.CodCotizador),
                 W.NumDiasRetroactividad, W.Cod_Moneda, W.SumaAsegCotLocal, W.SumaAsegCotMoneda, W.PrimaCotLocal, 
                 W.PrimaCotMoneda, W.IdTipoSeg, W.PlanCob, W.CodAgente, W.CodPlanPago, W.PorcDescuento, 
                 W.PorcGtoAdmin, W.PorcGtoAdqui, W.PorcUtilidad, W.FactorAjuste,  W.MontoDeducible, W.FactFormulaDeduc, 
                 W.CanalFormaVenta,  W.PorcVariacionEmi, W.IndAsegModelo, W.IndListadoAseg, W.IndCensoSubgrupo, 
                 W.IndExtraPrima, W.CodRiesgoRea, W.CodTipoBono, W.DescPoliticaSumasAseg, W.DescPoliticaEdades, 
                 W.DescTipoIdentAseg, W.TipoAdministracion, W.AsegEnIncapacidad, W.HorasVig, W.DiasVig, 
                 W.TextoSuscriptor, W.CantAsegurados, W.FactorSamiAseg, W.PromedioSumaAseg, W.SumaAsegSAMI, W.SAMIAutorizado, 
                 USER, W.DescGiroNegocio,  W.DescActividadAseg, W.DescFormulaDividendos, W.NumPolRenovacion, W.AsegAdheridosPor, 
                 W.PorcenContributorio,  W.FuenteRecursosPrima, W.TipoProrrata, W.PorcComisAgte, W.PorcComisProm, W.PorcComisDir, 
                 W.IndConvenciones, W.PorcConvenciones, W.DescCuotasPrimaNiv, W.DescElegibilidad, W.DescRiesgosCubiertos,
                 W.IndCotizacionWeb, W.IndCotizacionBaseWeb, NVL(W.GASTOSEXPEDICION, 0), W.CODTIPONEGOCIO, W.CODPAQCOMERCIAL, W.CODOFICINA, W.CODCATEGO );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20200,'Duplicada Cotización No. ' || nIdCotizacion);
      END;
      GT_COTIZACIONES_CLAUSULAS.RECOTIZACION_CLAUSULAS(nCodCia, nCodEmpresa, nIdCotizacion, nIdCotizacionCopia);
      GT_COTIZACIONES_DETALLE.RECOTIZACION_DETALLE(nCodCia, nCodEmpresa, nIdCotizacion, nIdCotizacionCopia);
      GT_COTIZACIONES_COBERT_MASTER.RECOTIZACION_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, nIdCotizacionCopia);
      IF W.IndCensoSubgrupo = 'S' THEN
         GT_COTIZACIONES_CENSO_ASEG.RECOTIZACION_CENSO(nCodCia, nCodEmpresa, nIdCotizacion, nIdCotizacionCopia);
      ELSIF W.IndListadoAseg = 'S' THEN
         GT_COTIZACIONES_ASEG.RECOTIZACION_ASEG(nCodCia, nCodEmpresa, nIdCotizacion, nIdCotizacionCopia);
      END IF;
   END LOOP;
END COPIAR_COTIZACION;

FUNCTION MONTO_SAMI(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN NUMBER IS
nSumaAsegSAMI       COTIZACIONES.SumaAsegSAMI%TYPE;
BEGIN
   SELECT NVL(SumaAsegSAMI,0)
     INTO nSumaAsegSAMI
     FROM COTIZACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;

   RETURN(nSumaAsegSAMI);
END MONTO_SAMI;

FUNCTION IDENTIFICADOR_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2 IS
    nComisPlanCob           NIVEL_PLAN_COBERTURA.ComAgeNivel%TYPE;
    nComisAgente            NIVEL_PLAN_COBERTURA.ComAgeNivel%TYPE;
    nComisPromotor          NIVEL_PLAN_COBERTURA.ComAgeNivel%TYPE;
    nComisDirecReg          NIVEL_PLAN_COBERTURA.ComAgeNivel%TYPE;
    nComisNivel             NIVEL_PLAN_COBERTURA.ComAgeNivel%TYPE;
    cIndExtraPrima          COTIZACIONES.IndExtraPrima%TYPE;
    cIdTipoSeg              COTIZACIONES.IdTipoSeg%TYPE;
    cPlanCob                COTIZACIONES.PlanCob%TYPE;
    nPorcComisAgte          COTIZACIONES.PorcComisAgte%TYPE;
    nPorcComisProm          COTIZACIONES.PorcComisProm%TYPE;
    nPorcComisDir           COTIZACIONES.PorcComisDir%TYPE;
    nPorcUtilidad           COTIZACIONES.PorcUtilidad%TYPE;
    nPorcGtoAdmin           COTIZACIONES.PorcGtoAdmin%TYPE;
    nPorcDescuento          COTIZACIONES.PorcDescuento%TYPE;
    cCanalFormaVenta        COTIZACIONES.CanalFormaVenta%TYPE;
    cCodRiesgoRea           COTIZACIONES.CodRiesgoRea%TYPE;
    cCodTipoBono            COTIZACIONES.CodTipoBono%TYPE;
    nFactorAjuste           COTIZACIONES.FactorAjuste%TYPE;
    nPorcGtoAdqui           COTIZACIONES.PorcGtoAdqui%TYPE;
    nFactorAjusteSubGrupo   COTIZACIONES.FactorAjuste%TYPE;
    cExtraPrima             VARCHAR2(3);
    cClaveCotizacion        VARCHAR2(100);

CURSOR COM_Q IS
   SELECT CodNivel, NVL(SUM(ComAgeNivel),0) ComisNivel
     FROM NIVEL_PLAN_COBERTURA
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND IdTipoSeg  = cIdTiposeg
      AND PlanCob    = cPlanCob
      AND Origen     = 'C'
    GROUP BY CodNivel;
BEGIN
   SELECT IndExtraPrima, IdTipoSeg, PlanCob, PorcComisAgte,
          PorcComisProm, PorcComisDir, PorcUtilidad, PorcGtoAdmin,
          PorcDescuento, CanalFormaVenta, CodRiesgoRea, CodTipoBono,
          PorcGtoAdqui, FactorAjuste
     INTO cIndExtraPrima, cIdTipoSeg, cPlanCob, nPorcComisAgte,
          nPorcComisProm, nPorcComisDir, nPorcUtilidad, nPorcGtoAdmin,
          nPorcDescuento, cCanalFormaVenta, cCodRiesgoRea, cCodTipoBono,
          nPorcGtoAdqui, nFactorAjuste
     FROM COTIZACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;

   SELECT NVL(MAX(DECODE(FactorAjuste,0,1,FactorAjuste)),1)
     INTO nFactorAjusteSubGrupo
     FROM COTIZACIONES_DETALLE
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdCotizacion   = nIdCotizacion;

   IF cIndExtraPrima = 'S' THEN
      cExtraPrima := 'ESI';
   ELSE
      cExtraPrima := 'ENO';
   END IF;

   IF NVL(nPorcComisAgte,0) = 0 AND  NVL(nPorcComisProm,0) = 0 AND  NVL(nPorcComisDir,0) = 0 THEN
      SELECT NVL(SUM(ComAgeNivel),1)
        INTO nComisPlanCob 
        FROM NIVEL_PLAN_COBERTURA
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTiposeg
         AND PlanCob    = cPlanCob
         AND Origen     = 'C';

      nComisAgente     := 0;
      nComisPromotor   := 0;
      nComisDirecReg   := 0;
      FOR W IN COM_Q LOOP
         nComisNivel := NVL(W.ComisNivel,0) * NVL(nPorcGtoAdqui,0) / NVL(nComisPlanCob,1);
         IF W.CodNivel = 1 THEN
            nComisDirecReg := NVL(nComisNivel,0);
         ELSIF W.CodNivel = 2 THEN
            nComisPromotor := NVL(nComisNivel,0);
         ELSIF W.CodNivel = 3 THEN
            nComisAgente := NVL(nComisNivel,0);
         ELSE
            nComisAgente := NVL(nComisAgente,0) + NVL(nComisNivel,0);
         END IF;
      END LOOP;
   ELSE
      nComisAgente     := NVL(nPorcComisAgte,0);
      nComisPromotor   := NVL(nPorcComisProm,0);
      nComisDirecReg   := NVL(nPorcComisDir,0);
   END IF;
   
   nFactorAjuste := NVL(nFactorAjuste,0) * NVL(nFactorAjusteSubGrupo,1);

   cClaveCotizacion := 'M' || TRIM(TO_CHAR(nPorcUtilidad + nPorcGtoAdmin,'00.00')) || '-' ||
                       'D' || TRIM(TO_CHAR(nPorcDescuento,'00.00')) || '-' ||
                       TRIM(cCanalFormaVenta) || '-' ||
                       'A' || TRIM(TO_CHAR(NVL(nComisAgente,0), '00.00')) || '-' ||
                       'P' || TRIM(TO_CHAR(NVL(nComisPromotor,0), '00.00')) || '-' ||
                       'D' || TRIM(TO_CHAR(NVL(nComisDirecReg,0), '00.00')) || '-' ||
                       TRIM(cCodRiesgoRea) || '-' ||
                       TRIM(cExtraPrima) || '-' ||
                       TRIM(cCodTipoBono) || '-' ||
                       TRIM(TO_CHAR(nFactorAjuste,'00.00'));
   RETURN(cClaveCotizacion);
END IDENTIFICADOR_COTIZACION;


FUNCTION TIENE_EXTRAPRIMAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2 IS
nPorcExtraPrimaDet    COTIZACIONES_DETALLE.PorcExtraPrimaDet%TYPE;
nMontoExtraPrimaDet   COTIZACIONES_DETALLE.MontoExtraPrimaDet%TYPE;
BEGIN
   SELECT NVL(SUM(PorcExtraPrimaDet),0), NVL(SUM(MontoExtraPrimaDet),0)
     INTO nPorcExtraPrimaDet, nMontoExtraPrimaDet
     FROM COTIZACIONES_DETALLE
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;

   SELECT NVL(SUM(PorcExtraPrimaAseg),0) + NVL(nPorcExtraPrimaDet,0), 
          NVL(SUM(MontoExtraPrimaAseg),0) + NVL(nMontoExtraPrimaDet,0)
     INTO nPorcExtraPrimaDet, nMontoExtraPrimaDet
     FROM COTIZACIONES_ASEG
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;

   IF NVL(nPorcExtraPrimaDet,0) > 0 OR NVL(nMontoExtraPrimaDet,0) > 0 THEN
      RETURN('S');
   ELSE
      RETURN('N');
   END IF;
END TIENE_EXTRAPRIMAS;

FUNCTION EXISTE_COTIZACION_EMITIDA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2 IS
cExisteCot       VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExisteCot
        FROM COTIZACIONES
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdCotizacion  = nIdCotizacion
         AND StsCotizacion = 'EMITID';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExisteCot  := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExisteCot  := 'S';
   END;
   RETURN(cExisteCot);
END EXISTE_COTIZACION_EMITIDA;

FUNCTION FECHA_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN DATE IS
dFecCotizacion      COTIZACIONES.FecCotizacion%TYPE;
BEGIN
   BEGIN
      SELECT FecCotizacion
        INTO dFecCotizacion
        FROM COTIZACIONES
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdCotizacion = nIdCotizacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'NO Existe Cotización No. ' || nIdCotizacion);
   END;

   RETURN(dFecCotizacion);
END FECHA_COTIZACION;

PROCEDURE COPIA_DATOS_A_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdPoliza NUMBER) IS
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
             FuenteRecursosPrima  = W.FuenteRecursosPrima
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza;
   END LOOP;
END COPIA_DATOS_A_POLIZA;

FUNCTION DIAS_RETROACTIVIDAD_EMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN NUMBER IS
nNumDiasRetroactividad      COTIZACIONES.NumDiasRetroactividad%TYPE;
BEGIN
   BEGIN
      SELECT NumDiasRetroactividad
        INTO nNumDiasRetroactividad
        FROM COTIZACIONES
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdCotizacion = nIdCotizacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'NO Existe Cotización No. ' || nIdCotizacion);
   END;

   RETURN(nNumDiasRetroactividad);
END DIAS_RETROACTIVIDAD_EMISION;

FUNCTION NUMERO_UNICO_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2 IS
cNumUnicoCotizacion      COTIZACIONES.NumUnicoCotizacion%TYPE;
BEGIN
   BEGIN
      SELECT NumUnicoCotizacion
        INTO cNumUnicoCotizacion
        FROM COTIZACIONES
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdCotizacion = nIdCotizacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'NO Existe Cotización No. ' || nIdCotizacion);
   END;

   RETURN(cNumUnicoCotizacion);
END NUMERO_UNICO_COTIZACION;

FUNCTION COTIZADOR_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2 IS
cCodCotizador      COTIZACIONES.CodCotizador%TYPE;
BEGIN
   BEGIN
      SELECT CodCotizador
        INTO cCodCotizador
        FROM COTIZACIONES
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdCotizacion = nIdCotizacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'NO Existe Cotización No. ' || nIdCotizacion);
   END;

   RETURN(cCodCotizador);
END COTIZADOR_COTIZACION;

FUNCTION EXISTE_SIN_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2 IS
cExistePol       VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExistePol
        FROM COTIZACIONES
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdCotizacion  = nIdCotizacion
         AND IdPoliza      IS NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExistePol  := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExistePol  := 'S';
   END;
   RETURN(cExistePol);
END EXISTE_SIN_POLIZA;

FUNCTION CREAR_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nCodCliente NUMBER, nCodAsegurado NUMBER) RETURN VARCHAR2 IS
nIdPoliza        POLIZAS.IdPoliza%TYPE;
nNumRenov        POLIZAS.NumRenov%TYPE;
cNumPolUnico     POLIZAS.NumPolUnico%TYPE;
cIndPolCol       POLIZAS.IndpolCol%TYPE;
cIndAplicoSAMI   POLIZAS.IndAplicoSAMI%TYPE;
nSAMIPoliza      POLIZAS.SAMIPoliza%TYPE;
nIDetPol         DETALLE_POLIZA.IDetPol%TYPE;
cOrigen          AGENTE_POLIZA.Origen%TYPE;
nCodAgente       AGENTE_POLIZA.Origen%TYPE;
nPorcComDis      AGENTES_DISTRIBUCION_POLIZA.Porc_Com_Distribuida%TYPE;
nProporcional    AGENTES_DISTRIBUCION_POLIZA.Porc_Com_Proporcional%TYPE;
nProporcAjust    AGENTES_DISTRIBUCION_POLIZA.Porc_Com_Proporcional%TYPE;
cTipoCotiz       COTIZADOR_CONFIG.CodTipoCotizador%TYPE;
cPrefijoPol      VARCHAR2(30);--PLAN_COBERTURAS.PrefijoPol%TYPE;
nPorcGtoAdqui    COTIZACIONES.PorcGtoAdqui%TYPE;      

CURSOR COTIZ_Q IS
  SELECT CodCotizador, NumUnicoCotizacion, NumCotizacionRef, FecIniVigCot, FecFinVigCot,
         SumaAsegCotLocal, SumaAsegCotMoneda, PrimaCotLocal, PrimaCotMoneda,
         DescPoliticaEdades, PorcComisAgte, NumPolRenovacion, Cod_Moneda, CodAgente,
         CodPlanPago, IndListadoAseg, IndAsegModelo, IndCensoSubGrupo, CanalFormaventa,
         SAMIAutorizado, TipoAdministracion, PorcDescuento, PorcGtoAdmin, PorcGtoAdqui,
         PorcUtilidad, FactorAjuste, MontoDeducible, FactFormulaDeduc, CodRiesgoRea,
         CodTipoBono, HorasVig, DiasVig, IndExtraPrima, AsegAdheridosPor, PorcenContributorio,
         FuenteRecursosPrima, PorcComisProm, PorcComisDir, TipoProrrata, IndConvenciones, CODTIPONEGOCIO, CODPAQCOMERCIAL, CODOFICINA , CODCATEGO,
         IdTipoSeg, PlanCob
    FROM COTIZACIONES c
   WHERE CodCia        = nCodCia
     AND CodEmpresa    = nCodEmpresa
     AND IdCotizacion  = nIdCotizacion
     AND StsCotizacion = 'EMITID'
     AND IdPoliza      IS NULL;

CURSOR AGEDIS_Q IS
  SELECT CodNivel, Cod_Agente_Distr, Porc_Com_Distribuida
    FROM AGENTES_DISTRIBUCION_POLIZA
   WHERE CodCia     = nCodCia
     AND IdPoliza   = nIdPoliza
     AND Cod_Agente = nCodAgente;
BEGIN
   IF GT_COTIZACIONES.EXISTE_COTIZACION_EMITIDA(nCodCia, nCodEmpresa, nIdCotizacion) = 'S' AND
      GT_COTIZACIONES.EXISTE_SIN_POLIZA(nCodCia, nCodEmpresa, nIdCotizacion) = 'S' THEN
      FOR X IN COTIZ_Q LOOP
         IF X.NumPolRenovacion IS NOT NULL THEN
--                    DBMS_OUTPUT.PUT_LINE('X.NumPolRenovacion: ' || X.NumPolRenovacion);  --capele 200226 
                    nNumRenov    := TO_NUMBER(SUBSTR(X.NumPolRenovacion, INSTR(X.NumPolRenovacion,'-',-1)+1, LENGTH(X.NumPolRenovacion) - INSTR(X.NumPolRenovacion,'-',-1)))+1;
                    cNumPolUnico := SUBSTR(X.NumPolRenovacion, 1, INSTR(X.NumPolRenovacion,'-', -1))||LPAD(nNumRenov,2,'0');
--                    DBMS_OUTPUT.PUT_LINE('cNumPolUnico: ' || cNumPolUnico); --capele 200226
         ELSE
            nNumRenov          := 0;
            cNumPolUnico       := X.NumCotizacionRef;
         END IF;

         cTipoCotiz := GT_COTIZADOR_CONFIG.TIPO_DE_COTIZADOR(nCodCia, nCodEmpresa, X.CodCotizador);
         IF NVL(cTipoCotiz,'API') IN ('API','VI') THEN
            cIndPolCol := 'N';
         ELSE
            cIndPolCol := 'S';
         END IF;

         IF X.SAMIAutorizado > 0 THEN
            cIndAplicoSAMI  := 'S';
            nSAMIPoliza     := X.SAMIAutorizado;
         END IF;

         nIdPoliza := OC_POLIZAS.INSERTAR_POLIZA(nCodCia, nCodEmpresa, X.DescPoliticaEdades,
                                                 X.Cod_Moneda, X.PorcComisAgte, nCodCliente,
                                                 X.CodAgente, X.CodPlanPago, cNumPolUnico,
                                                 X.NumUnicoCotizacion, X.FecIniVigCot);
         --
         -- genera numero unico conforme parametro
         cPrefijoPol := OC_PLAN_COBERTURAS.PREFIJO_POLIZA(nCodCia, nCodEmpresa, X.IdTipoSeg, X.PlanCob);
         IF cPrefijoPol IS NOT NULL THEN
            cNumPolUnico := TRIM(cPrefijoPol) || '-' || TRIM(TO_CHAR(nIdPoliza)) || '-' || TRIM(TO_CHAR(nNumRenov,'00'));
         END IF;                                          
         --
         UPDATE POLIZAS
            SET Num_Cotizacion       = nIdCotizacion,
                FecFinVig            = X.FecFinVigCot,
                SumaAseg_Local       = X.SumaAsegCotLocal,
                SumaAseg_Moneda      = X.SumaAsegCotMoneda,
                PrimaNeta_Local      = X.PrimaCotLocal,
                PrimaNeta_Moneda     = X.PrimaCotMoneda,
                IndPolCol            = cIndPolCol,
                Caracteristica       = 1,
                IndAplicoSAMI        = cIndAplicoSAMI,
                SAMIPoliza           = nSAMIPoliza,
                FormaVenta           = X.CanalFormaventa,
                TipoAdministracion   = X.TipoAdministracion,
                HoraVigIni           = X.HorasVig,
                HoraVigFin           = X.HorasVig,
                PorcDescuento        = X.PorcDescuento,
                PorcGtoAdmin         = X.PorcGtoAdmin,
                PorcGtoAdqui         = X.PorcGtoAdqui,
                PorcUtilidad         = X.PorcUtilidad,
                FactorAjuste         = X.FactorAjuste,
                MontoDeducible       = X.MontoDeducible,
                FactFormulaDeduc     = X.FactFormulaDeduc,
                CodRiesgoRea         = X.CodRiesgoRea,
                CodTipoBono          = X.CodTipoBono,
                HorasVig             = X.HorasVig,
                DiasVig              = X.DiasVig,
                IndExtraPrima        = X.IndExtraPrima,
                AsegAdheridosPor     = X.AsegAdheridosPor,
                PorcenContributorio  = X.PorcenContributorio,
                FuenteRecursosPrima  = X.FuenteRecursosPrima,
                TipoProrrata         = X.TipoProrrata,
                IndConvenciones      = X.IndConvenciones,
                CODTIPONEGOCIO       = X.CODTIPONEGOCIO,
                CODPAQCOMERCIAL      = X.CODPAQCOMERCIAL,
                CODOFICINA           = X.CODOFICINA,
                CODCATEGO            = X.CODCATEGO,
                NumPolUnico          = cNumPolUnico
          WHERE CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND IdPoliza   = nIdPoliza;

           nIDetPol := GT_COTIZACIONES_DETALLE.CREAR_CERTIFICADO(nCodCia, nCodEmpresa, nIdCotizacion, nIdPoliza, nCodAsegurado, cIndPolCol);
           GT_POLIZAS_TEXTO_COTIZACION.INSERTA(nCodCia, nCodEmpresa, nIdCotizacion, nIdPoliza);
           GT_COTIZACIONES_CLAUSULAS.CREAR_CLAUSULAS_POL(nCodCia, nCodEmpresa, nIdCotizacion, nIdPoliza);

         -- Agentes
         IF OC_AGENTES.NIVEL_AGENTE(nCodCia, X.CodAgente) = 5 THEN
            cOrigen  := 'U';
         ELSIF OC_AGENTES.NIVEL_AGENTE(nCodCia, X.CodAgente) = 4 THEN
            cOrigen  := 'H';
         ELSE
            cOrigen  := 'C';
         END IF;

         BEGIN
            INSERT INTO AGENTE_POLIZA
                   (IdPoliza, CodCia, Cod_Agente, Porc_Comision, Ind_Principal, Origen)
            VALUES (nIdPoliza, nCodCia, X.CodAgente, 100, 'S', cOrigen);
         EXCEPTION
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20200,'Error al Insertar el Agente de la Póliza.');
           END;

         OC_COMISIONES.DISTRIBUCION(nCodCia, nIdPoliza, X.CodAgente, 100);
           nProporcAjust := 0;
         FOR Y IN AGEDIS_Q LOOP
            IF Y.CodNivel = 1 THEN
                  nPorcComDis := X.PorcComisDir;
            ELSIF Y.CodNivel = 2 THEN
                  nPorcComDis := X.PorcComisProm;
            ELSIF Y.CodNivel = 3 THEN
                  nPorcComDis := X.PorcComisAgte;
            END IF;

            IF NVL(X.PorcGtoAdqui,0) != 0 THEN
               IF cOrigen != 'H' THEN
                  nProporcional := TRUNC(ROUND((Y.Porc_Com_Distribuida*100)/X.PorcGtoAdqui,2),2);
               ELSIF cOrigen = 'H' THEN
                  nProporcional := TRUNC(ROUND((nPorcComDis*100)/X.PorcGtoAdqui,2),2);
               END IF;
            ELSE
               nProporcional := 100;
            END IF;

            nProporcAjust := nProporcAjust + nProporcional; 

            IF (nProporcAjust > 100 AND nProporcAjust <= 100.01) THEN
               nProporcAjust := nProporcAjust - 100;
               nProporcional := nProporcional - nProporcAjust;
            ELSIF (nProporcAjust < 100 AND nProporcAjust >= 99.99)  THEN
               nProporcAjust := nProporcAjust - 100;
               nProporcional := nProporcional + nProporcAjust;
            END IF;

            IF OC_AGENTES.ES_AGENTE_DIRECTO(nCodCia, nCodAgente) = 'DIREC' THEN
               nPorcComDis    := 0;
               nPorcGtoAdqui  := 0;
            ELSE
               nPorcGtoAdqui := X.PorcGtoAdqui;
            END IF;

            UPDATE AGENTES_DISTRIBUCION_POLIZA
               SET Porc_Com_Distribuida = nPorcComDis,
                   --Porc_Com_Poliza      = X.PorcGtoAdqui,
                   Porc_Com_Poliza      = nPorcGtoAdqui,
                   Porc_Com_proporcional = nProporcional
             WHERE CodCia           = nCodCia
               AND IdPoliza         = nIdPoliza
               AND Cod_Agente       = nCodAgente
               AND CodNivel         = Y.CodNivel
               AND Cod_Agente_Distr = Y.Cod_Agente_Distr;
         END LOOP;

         BEGIN
            OC_AGENTES_DISTRIBUCION_POLIZA.COPIAR(nCodCia, nIdPoliza);
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
               OC_COMISIONES.DISTRIBUCION(nCodCia, nIdPoliza, nCodAgente, 100);
               OC_AGENTES_DISTRIBUCION_POLIZA.COPIAR(nCodCia, nIdPoliza);
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20225,'Error en Distribución de Agentes ' || SQLERRM);
         END;

         UPDATE COTIZACIONES
            SET IdPoliza = nIdPoliza
          WHERE CodCia       = nCodCia
            AND CodEmpresa   = nCodEmpresa
            AND IdCotizacion = nIdCotizacion;
      END LOOP;
      RETURN(nIdPoliza);
   ELSE
      RAISE_APPLICATION_ERROR(-20200,'Error La Cotización está en Cotizacion o ya se encuentra en otra Póliza.' || SQLERRM);
      RETURN(0);
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20200,'Error al Crear la Póliza de la Cotización '||SQLERRM);
END CREAR_POLIZA;

PROCEDURE SEND_MAIL(cCtaEnvio IN VARCHAR2, cPwdEmail IN VARCHAR2, cEmail IN VARCHAR2, cEmailDest IN VARCHAR2,cEmailCC IN VARCHAR2 DEFAULT NULL,
                    cEmailBCC IN VARCHAR2 DEFAULT NULL, cSubject IN VARCHAR2, cMessage IN VARCHAR2) IS
   cError VARCHAR2(1000);
BEGIN
   OC_MAIL.INIT_PARAM;
   OC_MAIL.cCtaEnvio    := cCtaEnvio;
   OC_MAIL.cPwdCtaEnvio := cPwdEmail;
   OC_MAIL.SEND_EMAIL(NULL,cEmail,TRIM(cEmailDest),TRIM(cEmailCC),TRIM(cEmailBCC),cSubject,cMessage,NULL,NULL,NULL,NULL,cError);
   IF cError != 0 THEN
      RAISE_APPLICATION_ERROR(-20200,'Error al Enviar el Correo '||cError);
   END IF;
END SEND_MAIL;

FUNCTION COTIZACION_WEB(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2 IS 
cIndCotizacionWeb COTIZACIONES.IndCotizacionWeb%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndCotizacionWeb,'N')
        INTO cIndCotizacionWeb
        FROM COTIZACIONES
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdCotizacion  = nIdCotizacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndCotizacionWeb  := 'N';
      WHEN TOO_MANY_ROWS THEN
         cIndCotizacionWeb  := 'S';
   END;
   RETURN cIndCotizacionWeb;
END COTIZACION_WEB;

FUNCTION COTIZACION_BASE_WEB(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN VARCHAR2 IS
cIndCotizacionBaseWeb COTIZACIONES.IndCotizacionBaseWeb%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndCotizacionBaseWeb,'N')
        INTO cIndCotizacionBaseWeb
        FROM COTIZACIONES
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdCotizacion  = nIdCotizacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndCotizacionBaseWeb  := 'N';
      WHEN TOO_MANY_ROWS THEN
         cIndCotizacionBaseWeb  := 'S';
   END;
   RETURN cIndCotizacionBaseWeb;
END COTIZACION_BASE_WEB;

PROCEDURE MARCA_COTIZACION_WEB(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) IS
BEGIN
   UPDATE COTIZACIONES
      SET IndCotizacionWeb       = 'S',
          IndCotizacionBaseWeb   = 'N'
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdCotizacion  = nIdCotizacion;
END;

FUNCTION COPIAR_COTIZACION_WEB(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) RETURN NUMBER IS
nIdCotizacionCopia      COTIZACIONES.IdCotizacion%TYPE;
CURSOR COT_Q IS
   SELECT NumUnicoCotizacion, CodCotizador, NumCotizacionRef, NumCotizacionAnt,
          NombreContratante, FecIniVigCot, FecFinVigCot, FecCotizacion, FecVenceCotizacion,
          NumDiasRetroactividad, Cod_Moneda, SumaAsegCotLocal, SumaAsegCotMoneda,
          PrimaCotLocal, PrimaCotMoneda, IdTipoSeg, PlanCob, CodAgente, CodPlanPago,
          PorcDescuento, PorcGtoAdmin, PorcGtoAdqui, PorcUtilidad, FactorAjuste,
          MontoDeducible, FactFormulaDeduc, CanalFormaVenta, PorcVariacionEmi, 
          IndAsegModelo, IndListadoAseg, IndCensoSubgrupo, IndExtraPrima, CodRiesgoRea, 
          CodTipoBono, DescPoliticaSumasAseg, DescPoliticaEdades, DescTipoIdentAseg,
          TipoAdministracion, AsegEnIncapacidad, HorasVig, DiasVig, TextoSuscriptor, 
          CantAsegurados,FactorSamiAseg, PromedioSumaAseg, SumaAsegSAMI, SAMIAutorizado, CodUsuario,
          DescGiroNegocio, DescActividadAseg, DescFormulaDividendos, NumPolRenovacion,
          AsegAdheridosPor, PorcenContributorio, FuenteRecursosPrima, TipoProrrata, 
          PorcComisAgte, PorcComisProm, PorcComisDir, IndConvenciones, PorcConvenciones,
          DescCuotasPrimaNiv, DescElegibilidad, DescRiesgosCubiertos, IndCotizacionWeb,
          IndCotizacionBaseWeb, GASTOSEXPEDICION,  CODTIPONEGOCIO, CODPAQCOMERCIAL , CODOFICINA, CODCATEGO
     FROM COTIZACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdCotizacion = nIdCotizacion;
BEGIN
   nIdCotizacionCopia := NUMERO_COTIZACION(nCodCia, nCodEmpresa);
   FOR W IN COT_Q LOOP
      BEGIN
         INSERT INTO COTIZACIONES
                (CodCia, CodEmpresa, IdCotizacion, NumUnicoCotizacion, CodCotizador, NumCotizacionRef, 
                 NumCotizacionAnt, StsCotizacion, FecStatus, NombreContratante, FecIniVigCot, FecFinVigCot, 
                 FecCotizacion, FecVenceCotizacion, NumDiasRetroactividad, Cod_Moneda, SumaAsegCotLocal,
                 SumaAsegCotMoneda, PrimaCotLocal, PrimaCotMoneda, IdTipoSeg, PlanCob, CodAgente, CodPlanPago,
                 PorcDescuento, PorcGtoAdmin, PorcGtoAdqui, PorcUtilidad, FactorAjuste, 
                 MontoDeducible, FactFormulaDeduc, CanalFormaVenta, PorcVariacionEmi, IndAsegModelo, 
                 IndListadoAseg, IndCensoSubgrupo, IndExtraPrima, CodRiesgoRea, CodTipoBono, 
                 DescPoliticaSumasAseg, DescPoliticaEdades, DescTipoIdentAseg, TipoAdministracion, 
                 AsegEnIncapacidad, HorasVig, DiasVig, TextoSuscriptor, CantAsegurados, 
                 FactorSamiAseg, PromedioSumaAseg,SumaAsegSAMI, SAMIAutorizado, CodUsuario, DescGiroNegocio, 
                 DescActividadAseg,  DescFormulaDividendos, NumPolRenovacion, AsegAdheridosPor, PorcenContributorio, 
                 FuenteRecursosPrima, TipoProrrata, PorcComisAgte, PorcComisProm, PorcComisDir, 
                 IndConvenciones, PorcConvenciones, DescCuotasPrimaNiv, DescElegibilidad, DescRiesgosCubiertos,
                 IndCotizacionWeb, IndCotizacionBaseWeb, GASTOSEXPEDICION, CODTIPONEGOCIO, CODPAQCOMERCIAL, CODOFICINA, CODCATEGO )
         VALUES (nCodCia, nCodEmpresa, nIdCotizacionCopia, W.NumUnicoCotizacion, W.CodCotizador, W.NumCotizacionRef, 
                 NULL, 'COTIZA', TRUNC(SYSDATE), W.NombreContratante, W.FecIniVigCot, W.FecFinVigCot, 
                 TRUNC(SYSDATE), TRUNC(SYSDATE) + GT_COTIZADOR_CONFIG.DIAS_VIGENCIA_COTIZACION(nCodCia, nCodEmpresa, W.CodCotizador),
                 W.NumDiasRetroactividad, W.Cod_Moneda, W.SumaAsegCotLocal, W.SumaAsegCotMoneda, W.PrimaCotLocal, 
                 W.PrimaCotMoneda, W.IdTipoSeg, W.PlanCob, W.CodAgente, W.CodPlanPago, W.PorcDescuento, 
                 W.PorcGtoAdmin, W.PorcGtoAdqui, W.PorcUtilidad, W.FactorAjuste,  W.MontoDeducible, W.FactFormulaDeduc, 
                 W.CanalFormaVenta,  W.PorcVariacionEmi, W.IndAsegModelo, W.IndListadoAseg, W.IndCensoSubgrupo, 
                 W.IndExtraPrima, W.CodRiesgoRea, W.CodTipoBono, W.DescPoliticaSumasAseg, W.DescPoliticaEdades, 
                 W.DescTipoIdentAseg, W.TipoAdministracion, W.AsegEnIncapacidad, W.HorasVig, W.DiasVig, 
                 W.TextoSuscriptor, W.CantAsegurados, W.FactorSamiAseg, W.PromedioSumaAseg, W.SumaAsegSAMI, W.SAMIAutorizado, 
                 USER, W.DescGiroNegocio,  W.DescActividadAseg, W.DescFormulaDividendos, W.NumPolRenovacion, W.AsegAdheridosPor, 
                 W.PorcenContributorio,  W.FuenteRecursosPrima, W.TipoProrrata, W.PorcComisAgte, W.PorcComisProm, W.PorcComisDir, 
                 W.IndConvenciones, W.PorcConvenciones, W.DescCuotasPrimaNiv, W.DescElegibilidad, W.DescRiesgosCubiertos,
                 W.IndCotizacionWeb, W.IndCotizacionBaseWeb, NVL(W.GASTOSEXPEDICION, 0), W.CODTIPONEGOCIO, W.CODPAQCOMERCIAL, w.CODOFICINA, W.CODCATEGO );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20200,'Duplicada Cotización No. ' || nIdCotizacion);
      END;
      GT_COTIZACIONES_CLAUSULAS.RECOTIZACION_CLAUSULAS(nCodCia, nCodEmpresa, nIdCotizacion, nIdCotizacionCopia);
      GT_COTIZACIONES_DETALLE.RECOTIZACION_DETALLE(nCodCia, nCodEmpresa, nIdCotizacion, nIdCotizacionCopia);
      GT_COTIZACIONES_COBERT_MASTER.RECOTIZACION_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, nIdCotizacionCopia);
      IF W.IndCensoSubgrupo = 'S' THEN
         GT_COTIZACIONES_CENSO_ASEG.RECOTIZACION_CENSO(nCodCia, nCodEmpresa, nIdCotizacion, nIdCotizacionCopia);
      ELSIF W.IndListadoAseg = 'S' THEN
         GT_COTIZACIONES_ASEG.RECOTIZACION_ASEG(nCodCia, nCodEmpresa, nIdCotizacion, nIdCotizacionCopia);
      END IF;
   END LOOP;
   RETURN nIdCotizacionCopia;
END COPIAR_COTIZACION_WEB;


END GT_COTIZACIONES;
/