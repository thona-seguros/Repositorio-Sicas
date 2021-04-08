CREATE OR REPLACE PACKAGE OC_ASEGURADO_SERVICIOS_WEB AS
   PROCEDURE CARGA_ASEGURADOS( nCodCia      NUMBER
                             , nCodEmpresa  NUMBER
                             , nIdPoliza    NUMBER
                             , xAsegurados  XMLTYPE );

FUNCTION LISTADO_ASEGURADO (nCodCia         IN NUMBER,  nCodEmpresa         IN NUMBER,  nIdPoliza           IN NUMBER,  nCodAgente          IN NUMBER,
                            nLimInferior    IN NUMBER,  nLimSuperior        IN NUMBER,  nTotRegs            OUT NUMBER, nCodAgenteSesion    IN NUMBER,       
                            nNivel          IN NUMBER,  cNombreContratante  IN VARCHAR2,cApePatContratante 	IN VARCHAR2,
                            cApeMatContratante   IN VARCHAR2,  cNumPolUnico IN VARCHAR2
							)
RETURN XMLTYPE;

FUNCTION CONSULTA_ASEGURADO (nCodCia  NUMBER,  nCodEmpresa NUMBER, nCodAsegurado  NUMBER, nIdPoliza NUMBER DEFAULT NULL, nIDetPol NUMBER DEFAULT NULL)
RETURN XMLTYPE;

FUNCTION VALIDA_ASEG_UNAM(  nCodCia         NUMBER,
                            nCodEmpresa     NUMBER,
                            cNombre         VARCHAR2,   --> JALV (+) 05/02/2021 
                            cApePaterno     VARCHAR2,   --> JALV (+) 05/02/2021
                            cApeMaterno     VARCHAR2,   --> JALV (+) 05/02/2021
                            dFecNac         VARCHAR2,   --> JALV (+) 05/02/2021
                            cEmail          VARCHAR2,   --> JALV (+) 05/02/2021
                             --, cCodAsegurado VARCHAR2 --> JALV (-) 05/02/2021
                             --, cNutra        VARCHAR2 --> JALV (-) 05/02/2021
                            cCodAgrupador VARCHAR2
                            --OUT XML DE POLIZAS 
                             ) RETURN VARCHAR2;

FUNCTION POLIZAS_ASEGURADO_UNAM   (  nCodCia       NUMBER
								  , nCodEmpresa   NUMBER
								  , nCodAsegurado NUMBER
								  , cCodAgrupador VARCHAR2) RETURN XMLTYPE;    

FUNCTION CONSULTA_POLIZA_UNAM ( nCodCia         NUMBER,	
                                nCodEmpresa     NUMBER,
                                --nCodAsegurado   NUMBER,
                                cCodAgrupador   VARCHAR2,
                                cPassword       VARCHAR2)
RETURN XMLTYPE;
END OC_ASEGURADO_SERVICIOS_WEB;
/
CREATE OR REPLACE PACKAGE BODY OC_ASEGURADO_SERVICIOS_WEB AS
   PROCEDURE CARGA_ASEGURADOS( nCodCia      NUMBER
                             , nCodEmpresa  NUMBER
                             , nIdPoliza    NUMBER
                             , xAsegurados  XMLTYPE ) IS
      nCodCliente            CLIENTES.CodCliente%TYPE;
      cTipoDocIdentAseg      CLIENTES.Tipo_Doc_Identificacion%TYPE;
      cNumDocIdentAseg       CLIENTES.Num_Doc_Identificacion%TYPE;
      nCod_Asegurado         ASEGURADO.Cod_Asegurado%TYPE;
      cCodmoneda             POLIZAS.Cod_Moneda%TYPE;
      cPlanCob               PLAN_COBERTURAS.PlanCob%TYPE;
      cExiste                VARCHAR2(1);
      cExisteDet             VARCHAR2(1);
      cIdTipoSeg             TIPOS_DE_SEGUROS.IdTipoSeg%TYPE;
      nPorcComis             POLIZAS.PorcComis%TYPE;
      cDescpoliza            POLIZAS.DescPoliza%TYPE;
      nCod_Agente            POLIZAS.Cod_Agente%TYPE;
      cCodPlanPago           POLIZAS.CodPlanPago%TYPE;
      cExisteTipoSeguro      VARCHAR2  (2);
      nTasaCambio            DETALLE_POLIZA.Tasa_Cambio%TYPE;
      nIDetPol               DETALLE_POLIZA.IdetPol%TYPE;
      cIdGrupoTarj           TARJETAS_PREPAGO.IdGrupoTarj%TYPE;
      cCodPromotor           DETALLE_POLIZA.CodPromotor%TYPE;
      cMsjError              PROCESOS_MASIVOS_LOG.TxtError%TYPE := 'N';
      cCodPlantilla          CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE;
      cNomTabla              CONFIG_PLANTILLAS_CAMPOS.NomTabla%TYPE;
      nOrden                 NUMBER(10):= 1  ;
      nOrdenInc              NUMBER(10) ;
      cUpdate                VARCHAR2(4000);
      dFecIniVig             DATE;
      dFecFinVig             DATE;
      cStsPoliza             POLIZAS.StsPoliza%TYPE;
      cExisteParEmi          VARCHAR2(1);
      cExisteAsegCert        VARCHAR2(1);
      cIndSinAseg            VARCHAR2(1);
      cCampo                 CONFIG_PLANTILLAS_CAMPOS.NomCampo%TYPE;
      nSuma                  COBERT_ACT_ASEG.SumaAseg_Local%TYPE;
      nIdEndoso              ENDOSOS.IdEndoso%TYPE;
      cStsDetalle            DETALLE_POLIZA.StsDetalle%TYPE;
      nIdSolicitud           SOLICITUD_EMISION.IdSolicitud%TYPE;

      nSumaAsegurada         COBERT_ACT_ASEG.SumaAseg_Local%TYPE := 0;
      nIdCotizacion          COTIZACIONES.IdCotizacion%TYPE;
      nIDetCotizacion        COTIZACIONES_DETALLE.IDetCotizacion%TYPE;
      --
      cIndEdadPromedio       COTIZACIONES_DETALLE.IndEdadPromedio%TYPE;
      cIndCuotaPromedio      COTIZACIONES_DETALLE.IndCuotaPromedio%TYPE;
      cIndPrimaPromedio      COTIZACIONES_DETALLE.IndPrimaPromedio%TYPE;
      --
      cIndCotizacionWeb      COTIZACIONES.IndCotizacionWeb%TYPE;
      cIndCotizacionBaseWeb  COTIZACIONES.IndCotizacionBaseWeb%TYPE;
      --      
      CURSOR cAseg IS
         WITH
         DET_POL_DATA AS ( SELECT DET.*
                             FROM   XMLTABLE('/DATA'
                                       PASSING xAsegurados
                                          COLUMNS 
                                             IDetPol        NUMBER(14)   PATH 'IDetPol',
                                             ASEGURADOS     XMLTYPE      PATH 'ASEGURADOS') DET
                           ),
         ASEG_DATA AS ( SELECT IDetPol,
                               ASG.*
                          FROM DET_POL_DATA D,
                               XMLTABLE('/ASEGURADOS'
                                    PASSING D.ASEGURADOS
                                       COLUMNS 
                                          Nombre            VARCHAR2(100)  PATH 'Nombre',
                                          ApellidoPaterno   VARCHAR2(100)  PATH 'ApellidoPaterno',
                                          ApellidoMaterno   VARCHAR2(100)  PATH 'ApellidoMaterno',
                                          Genero            VARCHAR2(1)    PATH 'Genero',
                                          FecNacimiento     VARCHAR2(10)   PATH 'FecNacimiento'
                                          ) ASG
                           )                     
         SELECT * FROM ASEG_DATA;  
      --
      CURSOR cCoberturas IS
         SELECT CodCobert         , SumaAsegCobLocal, SumaAsegCobMoneda, Tasa              , PrimaCobLocal, PrimaCobMoneda, DeducibleCobLocal,
                DeducibleCobMoneda, SalarioMensual  , VecesSalario     , SumaaSegCalculada , Edad_Minima  , Edad_Maxima   , Edad_Exclusion   ,
                SumaAseg_Minima   , SumaAseg_Maxima , PorcExtraPrimaDet, MontoExtraPrimaDet, SumaIngresada
         FROM   COTIZACIONES_COBERT_MASTER
         WHERE  CodCia       = nCodCia
           AND  CodEmpresa   = nCodEmpresa
           AND  IdCotizacion = nIdCotizacion;
      --
      CURSOR cCobertActAseg IS
         SELECT DISTINCT IDetPol, Cod_Asegurado, IdEndoso
         FROM   COBERT_ACT_ASEG
         WHERE  CodCia     = nCodCia
           AND  CodEmpresa = nCodEmpresa
           AND  IdPoliza   = nIdPoliza;
   BEGIN
      FOR W IN cAseg LOOP
         nIDetPol          := W.IDetPol;
         cTipoDocIdentAseg := 'RFC';
         cNumDocIdentAseg  := OC_PERSONA_NATURAL_JURIDICA.NUMERO_TRIBUTARIO_RFC(W.Nombre, W.ApellidoPaterno, W.ApellidoMaterno, TO_DATE(W.FecNacimiento, 'DD/MM/YYYY'), 'FISICA');
         IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(cTipoDocIdentAseg, cNumDocIdentAseg) = 'N' THEN
            OC_PERSONA_NATURAL_JURIDICA.INSERTAR_PERSONA(cTipoDocIdentAseg,                       --cTipo_Doc_Identificacion
                                                         cNumDocIdentAseg,                        --cNum_Doc_Identificacion
                                                         W.Nombre,                                --cNombre
                                                         W.ApellidoPaterno,                       --cApellidoPat
                                                         W.ApellidoMaterno,                       --cApellidoMat
                                                         NULL,                                    --cApeCasada
                                                         W.Genero,                                --cSexo
                                                         NULL,                                    --cEstadoCivil
                                                         TO_DATE(W.FecNacimiento, 'DD/MM/YYYY'),  --dFecNacimiento
                                                         NULL,                                    --cDirecRes
                                                         NULL,                                    --cNumInterior
                                                         NULL,                                    --cNumExterior
                                                         NULL,                                    --cCodPaisRes
                                                         NULL,                                    --cCodProvRes
                                                         NULL,                                    --cCodDistRes       
                                                         NULL,                                    --cCodCorrRes
                                                         NULL,                                    --cCodPosRes
                                                         NULL,                                    --cCodColonia
                                                         NULL,                                    --cTelRes
                                                         NULL,                                    --cEmail
                                                         NULL                                     --cLadaTelRes
                                                         );

            UPDATE PERSONA_NATURAL_JURIDICA
               SET Tipo_Persona        = 'FISICA',
                   Tipo_Id_Tributaria  = cTipoDocIdentAseg,
                   Num_Tributario      = 'XAXX010101000'
             WHERE Tipo_Doc_Identificacion   = cTipoDocIdentAseg
               AND Num_Doc_Identificacion    = cNumDocIdentAseg;                                                      
         END IF;
         nCod_Asegurado := OC_ASEGURADO.CODIGO_ASEGURADO(nCodCia, nCodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
         IF nCod_Asegurado = 0 THEN
            nCod_Asegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(nCodCia, nCodEmpresa,cTipoDocIdentAseg, cNumDocIdentAseg);
         END IF;
         nCodCliente := OC_CLIENTES.CODIGO_CLIENTE(cTipoDocIdentAseg, cNumDocIdentAseg);
         IF nCodCliente = 0  THEN
            nCodCliente    := OC_CLIENTES.INSERTAR_CLIENTE(cTipoDocIdentAseg,cNumDocIdentAseg);
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
            SELECT StsPoliza, Cod_Moneda, FecIniVig ,FecFinVig, Num_Cotizacion
              INTO cStsPoliza, cCodMoneda, dFecIniVig,dFecFinVig, nIdCotizacion
              FROM POLIZAS
             WHERE IdPoliza   = nIdPoliza
               AND CodCia     = nCodCia
               AND CodEmpresa = CodEmpresa;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20225,'POLIZA NO EXISTE: '|| nIdPoliza);
         END;
         BEGIN
            SELECT IndSinAseg, StsDetalle, CodPlanPago, IdTipoSeg, PlanCob
              INTO cIndSinAseg, cStsDetalle, cCodPlanPago, cIdTipoSeg, cPlanCob
              FROM DETALLE_POLIZA
             WHERE CodCia     = nCodCia
               AND CodEmpresa = nCodEmpresa
               AND IdPoliza   = nIdpoliza
               AND IDetPol    = nIDetPol;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20225,'DETALLE POLIZA NO EXISTE: '|| nIDetPol);
         END;
         cExiste        := OC_POLIZAS.EXISTE_POLIZA(nCodCia, nCodEmpresa, nIdpoliza);
         nIdSolicitud   := OC_SOLICITUD_EMISION.SOLICITUD_POLIZA(nCodCia, nCodEmpresa, nIdPoliza);
         nTasaCambio    := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
         --
         IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(nCodCia, nIdpoliza, nIDetPol, nCod_Asegurado) = 'N' THEN
            IF cStsPoliza = 'SOL' OR cStsDetalle = 'SOL' THEN
               --OC_ASEGURADO_CERTIFICADO.INSERTA(nCodCia, nIdpoliza, nIDetPol, nCod_Asegurado, 0);
               nIdEndoso := 0;
            ELSIF cStsPoliza = 'EMI' OR cStsDetalle = 'EMI' THEN
               SELECT NVL(MAX(IdEndoso),0)
                 INTO nIdEndoso
                 FROM ENDOSOS
                WHERE CodCia     = nCodCia
                  AND IdPoliza   = nIdPoliza
                  AND StsEndoso  = 'SOL';

               IF NVL(nIdEndoso,0) = 0 THEN
                  nIdEndoso := OC_ENDOSO.CREAR(nIdPoliza);
                  OC_ENDOSO.INSERTA (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso,
                                     'ESV', 'ENDO-' || TRIM(TO_CHAR(nIdPoliza)) || '-' || TRIM(TO_CHAR(nIdEndoso)),
                                     dFecIniVig, dFecFinVig, cCodPlanPago, 0, 0, 0, '010', NULL);
               END IF;
            END IF;
            OC_ASEGURADO_CERTIFICADO.INSERTA(nCodCia, nIdpoliza, nIDetPol, nCod_Asegurado, nIdEndoso);
         END IF;
         nIDetCotizacion := nIDetPol;
         BEGIN
            SELECT NVL(D.IndEdadPromedio,'N'), NVL(D.IndCuotaPromedio,'N'), NVL(D.IndPrimaPromedio,'N')
              INTO cIndEdadPromedio, cIndCuotaPromedio, cIndPrimaPromedio
              FROM COTIZACIONES C, COTIZACIONES_DETALLE D
             WHERE C.CodCia         = nCodCia
               AND C.CodEmpresa     = nCodEmpresa
               AND D.IdCotizacion   = nIdCotizacion
               AND D.IDetCotizacion = nIDetCotizacion
               AND C.CodCia         = D.CodCia
               AND C.CodEmpresa     = D.CodEmpresa
               AND C.IdCotizacion   = D.IdCotizacion;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cIndEdadPromedio  := 'N';
               cIndCuotaPromedio := 'N';
               cIndPrimaPromedio := 'N';
         END;

         IF cIndEdadPromedio = 'N' AND cIndCuotaPromedio = 'N' AND cIndPrimaPromedio = 'N' THEN
            IF OC_COBERT_ACT_ASEG.EXISTE_COBERTURA (nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nIdPoliza, nIDetPol, nCod_Asegurado) = 'N' THEN
               IF NVL(cIndSinAseg,'N') = 'N' THEN
                  IF NVL(nIdSolicitud,0) = 0 THEN
                     IF NVL(nIdCotizacion,0) = 0 THEN
                        OC_COBERT_ACT_ASEG.CARGAR_COBERTURAS(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nIdPoliza,
                                                             nIDetPol, nTasaCambio, nCod_Asegurado, NULL, 0, 0, 0, 0, 99, 0, 0, 0, 0, 0, 0);
                     ELSE
                        GT_COTIZACIONES_COBERT_MASTER.CREAR_COBERTURAS_POLIZA(nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, nIdPoliza, nIDetPol, nCod_Asegurado, 'S', nSumaAsegurada);
                     END IF;
                  ELSE
                     OC_SOLICITUD_COBERTURAS.TRASLADA_COBERTURAS(nCodCia, nCodEmpresa, nIdSolicitud, nIdPoliza, nIDetPol, nCod_Asegurado);
                     OC_SOLICITUD_ASISTENCIAS.TRASLADA_ASISTENCIAS(nCodCia, nCodEmpresa, nIdSolicitud, nIdPoliza, nIDetPol, nCod_Asegurado);
                  END IF;
               ELSE
                  nSuma := OC_ASEGURADO_CERTIFICADO.SUMA_ASEGURADO(nCodCia, nIdPoliza,nIdetPol,nCod_Asegurado,cCampo);
                  OC_COBERT_ACT_ASEG.CARGAR_COBERTURAS_SIN_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nIdPoliza, nIDetPol, nTasaCambio, nCod_Asegurado, nSuma);
               END IF;
               IF NVL(nIdEndoso,0) != 0 THEN
                  UPDATE COBERT_ACT_ASEG
                     SET IdEndoso = nIdEndoso
                   WHERE CodCia        = nCodCia
                     AND IdPoliza      = nIdPoliza
                     AND IDetPol       = nIDetPol
                     AND Cod_Asegurado = nCod_Asegurado;
               END IF;
            END IF;
         END IF;
      END LOOP;
      --
      --Valido si la carga de asegurados proviene de Plataforma Digital
      SELECT IndCotizacionWeb , IndCotizacionBaseWeb
      INTO   cIndCotizacionWeb, cIndCotizacionBaseWeb
      FROM   COTIZACIONES
      WHERE  CodCia       = nCodCia
        AND  IdPoliza     = nIdPoliza
        AND  IdCotizacion = nIdCotizacion;
      --
      IF cIndCotizacionWeb = 'S' AND cIndCotizacionBaseWeb = 'N' THEN
         FOR x IN cCoberturas LOOP
            UPDATE COBERT_ACT_ASEG
            SET    SumaAseg_Local     = x.SumaAsegCobLocal
              ,    SumaAseg_Moneda    = x.SumaAsegCobMoneda
              ,    Tasa               = x.Tasa
              ,    Prima_Moneda       = x.PrimaCobMoneda
              ,    Prima_Local        = x.PrimaCobLocal
              --,    Deducible_Local    = x.DeducibleCobLocal
              --,    Deducible_Moneda   = x.DeducibleCobMoneda
              ,    SalarioMensual     = x.SalarioMensual
              ,    VecesSalario       = x.VecesSalario
              ,    SumaAsegCalculada  = x.SumaaSegCalculada
              ,    Edad_Minima        = x.Edad_Minima
              ,    Edad_Maxima        = x.Edad_Maxima
              ,    Edad_Exclusion     = x.Edad_Exclusion
              ,    SumaAseg_Minima    = x.SumaAseg_Minima 
              ,    SumaAseg_Maxima    = x.SumaAseg_Maxima
              ,    PorcExtraPrimaDet  = x.PorcExtraPrimaDet
              ,    MontoExtraPrimaDet = x.MontoExtraPrimaDet
              ,    SumaIngresada      = x.SumaIngresada
             WHERE CodCia     = nCodCia
               AND CodEmpresa = nCodEmpresa
               AND IdPoliza   = nIdPoliza
               AND CodCobert  = x.CodCobert;
         END LOOP;
         --
         FOR y IN cCobertActAseg LOOP
            SELECT IndSinAseg
            INTO   cIndSinAseg
            FROM   DETALLE_POLIZA
            WHERE  CodCia     = nCodCia
              AND  CodEmpresa = nCodEmpresa
              AND  IdPoliza   = nIdPoliza
              AND  IDetPol    = y.IDetPol;
            --
            OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, y.IDetPol, y.Cod_Asegurado);
            --
            IF NVL(cIndSinAseg,'N') = 'N' OR NVL(y.IdEndoso,0) = 0 THEN
               OC_POLIZAS.ACTUALIZA_VALORES(nCodCia, nIdPoliza, 0);
               OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, y.IDetPol, 0);
            ELSIF NVL(nIdEndoso,0) != 0 THEN
               OC_ENDOSO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, y.IDetPol, y.IdEndoso);
            END IF;
         END LOOP;
      END IF;
      --
   END CARGA_ASEGURADOS;

/*   _______________________________________________________________________________________________________________________________
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 10/01/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : OC_ASEGURADOS_SERVICIOS_WEB                                                                                      |
    | Objetivo   : Package obtiene informacion de los Asegurados que cumplen con los criterios dados en los Servicios WEB de la     |
    |              Plataforma Digital, los resultados son generados en formato XML.                                                 |
    | Modificado : NO                                                                                                               |
    | Ult. Modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |_______________________________________________________________________________________________________________________________|
*/ 

FUNCTION LISTADO_ASEGURADO (nCodCia         IN NUMBER,  nCodEmpresa         IN NUMBER,      nIdPoliza  IN NUMBER,   nCodAgente       IN NUMBER,
                            nLimInferior    IN NUMBER,  nLimSuperior        IN NUMBER,      nTotRegs   OUT NUMBER,  nCodAgenteSesion IN NUMBER,       
                            nNivel          IN NUMBER,  cNombreContratante  IN VARCHAR2,    cApePatContratante 	IN VARCHAR2,
                            cApeMatContratante   IN VARCHAR2,  cNumPolUnico IN VARCHAR2							
							)
	RETURN XMLTYPE IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 10/01/2021                                                                                                       |
    | Email		 : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : LISTADO_ASEGURADO                                                                                                |
    | Objetivo   : Funcion que obtiene un listado general de los Asegurados que cumplen con los criterios dados desde la Plataforma |
    |              Digital, con resultados paginados y tranforma la salida en formato XML.                                          |
    | Modificado : Si                                                                                                               |
    | Ult. modif.: 11/03/2021                                                                                                       |
    | Modifico	 : J. Alberto Lopez Valle (JALV)                                                                                    |
    | Obj. Modif.: Se agregan filtros por Nombre, apellido Paterno y apellido Materno.                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nCodCia                 Codigo de Compañia              (Entrada)                                                   |
    |           nCodEmpresa             Codigo de Empresa               (Entrada)                                                   |
    |           nIdPoliza               ID de la Póliza                 (Entrada)                                                   |
    |           nCodAgente              Codigo de Empresa               (Entrada)                                                   |
    |           nLimInferior            Limite inferior de pagina       (Entrada)                                                   |
    |           nLimSuperior            Limite superior de pagina       (Entrada)                                                   |
    |           nTotRegs                Total de registros obtenidos    (Salida)                                                    |
    |           cNombreContratante      Nombre del Asegurado            (Entrada)                                                   |
    |           cApePatContratante      Apellido Paterno del Asegurado  (Entrada)                                                   |
    |           cApeMatContratante      Apellido Materno del Asegurado  (Entrada)                                                   |
    |           cNumPolUnico            Numero de Poliza Unico          (Entrada)                                                   |
    |_______________________________________________________________________________________________________________________________|
*/

xListadoAsegurados  XMLTYPE;
xPrevAsegs          XMLTYPE; 

BEGIN
   BEGIN
	    SELECT XMLELEMENT("DATA",
                            XMLAGG(XMLELEMENT("ASEGURADOS",
                                                XMLELEMENT("Asegurado", asegurado),
                                                XMLELEMENT("EdoAsegurado", EdoAsegurado),
                                                XMLELEMENT("Agente", agente),
                                                XMLELEMENT("Principal", principal),
                                                XMLELEMENT("IDPoliza", idpoliza),
                                                XMLELEMENT("NumPolUnico", numpolunico),
                                                XMLELEMENT("FecIniVig", fecinivig),
                                                XMLELEMENT("FecFinVig", fecfinvig),
                                                XMLELEMENT("Nombre", nombre),
                                                XMLELEMENT("ApellidoPaterno", apellido_paterno),
                                                XMLELEMENT("ApellidoMaterno", apellido_materno),
                                                XMLELEMENT("Edad", edad),
                                                XMLELEMENT("Sexo", sexo),
                                                XMLELEMENT("EdoCivil", estadocivil),
                                                XMLELEMENT("FecNacimiento", fecnacimiento),
                                                XMLELEMENT("Curp", curp),
                                                XMLELEMENT("FecIngreso", fecingreso),
                                                XMLELEMENT("TipoDocIdentificacion", tipo_doc_identificacion),
                                                XMLELEMENT("NumDocIdentificacion", num_doc_identificacion),
                                                XMLELEMENT("TipoPersona", tipo_persona),
                                                XMLELEMENT("NumTributario", num_tributario),
                                                XMLELEMENT("TipoIDTributaria", tipo_id_tributaria),
                                                XMLELEMENT("TipoSeguro", tipo_seguro),
                                                XMLELEMENT("NomTipoSeguro", desc_tipo_seguro),
                                                XMLELEMENT("TipoPoliza", tipo_poliza),
                                                XMLELEMENT("Pais", pais),
                                                XMLELEMENT("Estado", estado),
                                                XMLELEMENT("Ciudad", ciudad),
                                                XMLELEMENT("Municipio_alcaldia", municipio_alcaldia),
                                                XMLELEMENT("Colonia", colonia),
                                                XMLELEMENT("C.P.", codposres),
                                                XMLELEMENT("Nacionalidad", nacionalidad),
                                                XMLELEMENT("SumaAsegurada", SumaAsegurada),
                                                XMLELEMENT("PrimaNeta", PrimaNeta),
                                                XMLELEMENT("IDetPol", IDetPol)
                                              )
                                  )
                         )
        INTO	xPrevAsegs                
        FROM    (SELECT asegurado,
                        --edoaseg EdoAsegurado,
                        OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', edoaseg) EdoAsegurado,
                        agente,
                        principal,
                        idpoliza,
                        numpolunico,		                                    --> 12/03/2021 (JALV +)
                        fecinivig,
                        fecfinvig,
                        nombre,
                        apellido_paterno,
                        apellido_materno,
                        edad,
                        sexo,
                        estadocivil,
                        fecnacimiento,
                        curp,
                        fecingreso,
                        tipo_doc_identificacion,
                        num_doc_identificacion,
                        tipo_persona,
                        num_tributario,
                        tipo_id_tributaria,
                        tipo_seguro,
                        desc_tipo_seguro,
                        tipo_poliza,
                        pais,
                        estado,
                        ciudad,
                        municipio_alcaldia,
                        colonia,
                        codposres,
                        nacionalidad,
                        SumaAsegurada,
                        PrimaNeta,
                        IDetPol
                FROM    (SELECT     AA.asegurado,
                                    AA.EdoAseg,
                                    AA.agente,
                                    AA.principal,
                                    AA.idpoliza,
                                    AA.numpolunico,		                                --> 12/03/2021 (JALV +)
                                    AA.fecinivig,
                                    AA.fecfinvig,
                                    AA.nombre,
                                    AA.apellido_paterno,
                                    AA.apellido_materno,
                                    AA.edad,
                                    AA.sexo,
                                    AA.estadocivil,
                                    AA.fecnacimiento,
                                    AA.curp,
                                    AA.fecingreso,
                                    AA.tipo_doc_identificacion,
                                    AA.num_doc_identificacion,
                                    AA.tipo_persona,
                                    AA.num_tributario,
                                    AA.tipo_id_tributaria,
                                    AA.tipo_seguro,
                                    AA.desc_tipo_seguro,
                                    AA.tipo_poliza,
                                    AA.pais,
                                    AA.estado,
                                    AA.ciudad,
                                    AA.municipio_alcaldia,
                                    AA.colonia,
                                    AA.codposres,
                                    AA.nacionalidad,
                                    AA.SumaAsegurada,
                                    AA.PrimaNeta,
                                    AA.IDetPol,
                                    ROW_NUMBER() OVER (ORDER BY idpoliza) REGISTRO
                        FROM        (   SELECT  A.cod_asegurado                         ASEGURADO,
                                                DP.stsdetalle                           EDOASEG,
                                                AP.cod_agente                           AGENTE, 
                                                DECODE(AP.ind_principal,'S','Si','No')  PRINCIPAL, 
                                                P.idpoliza,
                                                P.numpolunico,		                                --> 12/03/2021 (JALV +)
                                                DP.fecinivig, 
                                                DP.fecfinvig, 
                                                PNJ.nombre, 
                                                PNJ.apellido_paterno, 
                                                PNJ.apellido_materno,
                                                OC_ASEGURADO.EDAD_ASEGURADO(A.codcia, A.codempresa, A.cod_asegurado, TRUNC(SYSDATE)) EDAD,
                                                PNJ.sexo, 
                                                PNJ.estadocivil, 
                                                PNJ.fecnacimiento,
                                                PNJ.curp,
                                                PNJ.fecingreso,        
                                                PNJ.tipo_doc_identificacion,
                                                PNJ.num_doc_identificacion,
                                                PNJ.tipo_persona,
                                                PNJ.num_tributario, 
                                                PNJ.tipo_id_tributaria,
                                                DP.idtiposeg                        TIPO_SEGURO,
                                                OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(A.codcia, A.codempresa, DP.idtiposeg) DESC_TIPO_SEGURO,
                                                'Individual'                        TIPO_POLIZA,
                                                OC_PAIS.NOMBRE_PAIS(PNJ.codpaisres) PAIS,
                                                OC_PROVINCIA.NOMBRE_PROVINCIA(PNJ.codpaisres, PNJ.codprovres) ESTADO,
                                                OC_DISTRITO.NOMBRE_DISTRITO(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres) CIUDAD,
                                                OC_CORREGIMIENTO.nombre_corregimiento(PNJ.codpaisres,PNJ.codprovres,PNJ.coddistres,PNJ.codcorrres) MUNICIPIO_ALCALDIA,
                                                OC_COLONIA.DESCRIPCION_COLONIA(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres, PNJ.codcorrres, PNJ.codposres, PNJ.codcolres) COLONIA,        
                                                PNJ.codposres,
                                                PNJ.nacionalidad,
                                                DP.Suma_Aseg_Local SumaAsegurada,
                                                DP.Prima_Local PrimaNeta,
                                                DP.IDetPol
                                         FROM   POLIZAS                     P,
                                                DETALLE_POLIZA              DP,
                                                ASEGURADO                   A,
                                                PERSONA_NATURAL_JURIDICA    PNJ,
                                                AGENTE_POLIZA               AP,
                                                (SELECT DISTINCT C.CodCia, C.Cod_Agente, C.IdPoliza, D.Cod_Agente_Distr,
                                                         OC_AGENTES.NIVEL_AGENTE(C.CodCia, c.Cod_Agente ) Nivel
                                                    FROM COMISIONES C, AGENTES_DISTRIBUCION_POLIZA D,
                                                         AGENTE_POLIZA P
                                                   WHERE C.CodCia         = nCodCia
                                                     AND C.Cod_Agente     = D.Cod_Agente_Distr
                                                     AND C.IdPoliza       = D.IdPoliza
                                                     AND D.Cod_Agente     = P.Cod_Agente
                                                     AND C.IdPoliza       = P.IdPoliza
                                                     AND P.Ind_Principal  = 'S') D
                                         WHERE  P.idpoliza      = DP.idpoliza
                                         AND    P.codcia        = DP.codcia
                                         AND    P.codempresa    = DP.codempresa
                                         AND    A.cod_asegurado = DP.cod_asegurado
                                         AND    A.codcia        = DP.codcia
                                         AND    A.codempresa    = DP.codempresa
                                         AND    A.codcia        = P.codcia
                                         AND    A.codempresa    = P.codempresa
                                         AND    DP.stsdetalle   <> 'PRE'
                                         AND    A.tipo_doc_identificacion   = PNJ.tipo_doc_identificacion
                                         AND    A.num_doc_identificacion    = PNJ.num_doc_identificacion
                                         AND    PNJ.nombre      = NVL(cNombreContratante, PNJ.nombre)                       --> 11/03/2021  (JALV +)
                                         AND    (cApePatContratante IS NULL OR PNJ.apellido_paterno = cApePatContratante)   --> 11/03/2021  (JALV +)
                                         AND    (cApeMatContratante IS NULL OR PNJ.apellido_materno = cApeMatContratante)   --> 11/03/2021  (JALV +)
                                         AND    A.codcia        = AP.codcia
                                         AND    P.idpoliza      = AP.idpoliza
                                         AND    P.codcia        = AP.codcia
                                         AND    AP.idpoliza     = DP.idpoliza
                                         AND    AP.codcia       = DP.codcia
                                         AND    OC_POLIZAS.POLIZA_COLECTIVA(P.CodCia, P.CodEmpresa, P.IdPoliza) = 'N'
                                         AND    P.codcia         = nCodCia
                                         AND    P.codempresa     = nCodEmpresa
                                         AND    P.idpoliza       = NVL(nIdPoliza,P.IdPoliza)
                                         AND     AP.cod_agente IN (SELECT   A.cod_agente
                                                                     FROM   AGENTES A
                                                                     CONNECT BY PRIOR A.cod_agente = A.cod_agente_jefe
                                                                     AND     A.est_agente  = 'ACT'
                                                                     AND     A.codcia      = nCodCia
                                                                     AND     A.codempresa  = nCodEmpresa
                                                                     START WITH A.cod_agente  = nCodAgente
                                                                     ) 
                                         AND    AP.Ind_Principal   = 'S'
                                         AND    AP.IdPoliza   = D.IdPoliza
                                         AND    AP.CodCia     = D.CodCia
                                         AND    D.Cod_Agente  = nCodAgenteSesion
                                         AND    D.Nivel       = nNivel
                                         AND    P.numpolunico = NVL(cNumPolUnico, P.numpolunico)
                                         --AND    A.cod_asegurado  = NVL(:nContratante, A.cod_asegurado)
                                         --AND    P.fecinivig >= :dFechaIni
                                         --AND    P.fecfinvig <= :dFechaFin
                                        UNION
                                        -- Colectiva
                                         SELECT AC.cod_asegurado                        ASEGURADO,
                                                AC.estado                               EDOASEG,
                                                AP.cod_agente                           AGENTE, 
                                                DECODE(AP.ind_principal,'S','Si','No')  PRINCIPAL, 
                                                P.idpoliza,
                                                P.numpolunico,		                                --> 12/03/2021 (JALV +)
                                                DP.fecinivig, 
                                                DP.fecfinvig, 
                                                PNJ.nombre, 
                                                PNJ.apellido_paterno, 
                                                PNJ.apellido_materno,
                                                OC_ASEGURADO.EDAD_ASEGURADO(P.codcia, P.codempresa, AC.cod_asegurado, TRUNC(SYSDATE)) EDAD,
                                                PNJ.sexo, 
                                                PNJ.estadocivil, 
                                                PNJ.fecnacimiento,
                                                PNJ.curp,
                                                PNJ.fecingreso,        
                                                PNJ.tipo_doc_identificacion,
                                                PNJ.num_doc_identificacion,
                                                PNJ.tipo_persona,
                                                PNJ.num_tributario, 
                                                PNJ.tipo_id_tributaria,
                                                DP.idtiposeg                            TIPO_SEGURO,
                                                OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(P.codcia, P.codempresa, DP.idtiposeg) DESC_TIPO_SEGURO,
                                                'Colectiva'                             TIPO_POLIZA,
                                                OC_PAIS.NOMBRE_PAIS(PNJ.codpaisres)     PAIS,
                                                OC_PROVINCIA.NOMBRE_PROVINCIA(PNJ.codpaisres, PNJ.codprovres) ESTADO,
                                                OC_DISTRITO.NOMBRE_DISTRITO(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres) CIUDAD,
                                                OC_CORREGIMIENTO.nombre_corregimiento(PNJ.codpaisres,PNJ.codprovres,PNJ.coddistres,PNJ.codcorrres) MUNICIPIO_ALCALDIA,
                                                OC_COLONIA.DESCRIPCION_COLONIA(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres, PNJ.codcorrres, PNJ.codposres, PNJ.codcolres) COLONIA,        
                                                PNJ.codposres,
                                                PNJ.nacionalidad,
                                                AC.SumaAseg SumaAsegurada,
                                                AC.PrimaNeta,
                                                DP.IDetPol
                                         FROM   POLIZAS                     P,
                                                DETALLE_POLIZA              DP,
                                                ASEGURADO_CERTIFICADO       AC,
                                                ASEGURADO                   A,
                                                PERSONA_NATURAL_JURIDICA    PNJ,
                                                AGENTE_POLIZA               AP,
                                                (SELECT  DISTINCT C.CodCia, C.Cod_Agente, C.IdPoliza, D.Cod_Agente_Distr,
                                                         OC_AGENTES.NIVEL_AGENTE(C.CodCia, c.Cod_Agente ) Nivel
                                                    FROM COMISIONES C,
                                                         AGENTES_DISTRIBUCION_POLIZA D,
                                                         AGENTE_POLIZA P
                                                   WHERE C.CodCia         = nCodCia
                                                     AND C.Cod_Agente     = D.Cod_Agente_Distr
                                                     AND C.IdPoliza       = D.IdPoliza
                                                     AND D.Cod_Agente     = P.Cod_Agente
                                                     AND C.IdPoliza       = P.IdPoliza
                                                     AND P.Ind_Principal  = 'S') D   
                                       WHERE     P.idpoliza       = DP.idpoliza
                                         AND     P.codcia         = DP.codcia
                                         AND     P.codempresa     = DP.codempresa
                                         AND     DP.idpoliza      = AC.idpoliza
                                         AND     DP.codcia        = AC.codcia
                                         AND     DP.idetpol       = AC.idetpol
                                         AND     AC.cod_asegurado  = A.cod_asegurado
                                         AND     AC.codcia         = A.codcia
                                         AND     A.tipo_doc_identificacion   = PNJ.tipo_doc_identificacion
                                         AND     A.num_doc_identificacion    = PNJ.num_doc_identificacion
                                         AND     PNJ.nombre       = NVL(cNombreContratante, PNJ.nombre)                      --> 11/03/2021  (JALV +)
                                         AND     (cApePatContratante IS NULL OR PNJ.apellido_paterno = cApePatContratante)   --> 11/03/2021  (JALV +)
                                         AND     (cApeMatContratante IS NULL OR PNJ.apellido_materno = cApeMatContratante)   --> 11/03/2021  (JALV +)
                                         AND     P.idpoliza       = AP.idpoliza
                                         AND     P.codcia         = AP.codcia
                                         AND     P.codcia         = nCodCia
                                         AND     P.codempresa     = nCodEmpresa
                                         AND     P.idpoliza       = NVL(nIdPoliza,P.IdPoliza)
                                         AND     AP.cod_agente IN (SELECT   A.cod_agente
                                                                     FROM   AGENTES A
                                                                     CONNECT BY PRIOR A.cod_agente = A.cod_agente_jefe
                                                                     AND    A.est_agente  = 'ACT'
                                                                     AND    A.codcia      = nCodCia
                                                                     AND    A.codempresa  = nCodEmpresa
                                                                     START WITH A.cod_agente  = nCodAgente
                                                                     ) 
                                         AND     DP.stsdetalle   <> 'PRE'
                                         AND    AP.Ind_Principal   = 'S'
                                         AND    AP.IdPoliza   = D.IdPoliza
                                         AND    AP.CodCia     = D.CodCia
                                         AND    D.Cod_Agente  = nCodAgenteSesion
                                         AND    D.Nivel       = nNivel
                                         AND    P.numpolunico = NVL(cNumPolUnico, P.numpolunico)
                                         --AND     AC.cod_asegurado =  :nContratante  -- NVL(:nContratante, AC.cod_asegurado) --
                                         --AND     P.fecinivig >= :dFechaIni
                                         --AND     P.fecfinvig <= :dFechaFin
                                    ) AA
                        ORDER BY idpoliza
                        ) ASEG
        WHERE   ASEG.registro BETWEEN nLimInferior AND nLimSuperior);

        --> Total registros obtenidos
        SELECT  NVL(COUNT(*),0) TOTAL                            
        INTO    nTotRegs 
        FROM    (  SELECT  A.cod_asegurado                         ASEGURADO,
                           DP.stsdetalle                           EDOASEG,
                           AP.cod_agente                           AGENTE, 
                           DECODE(AP.ind_principal,'S','Si','No')  PRINCIPAL, 
                           P.idpoliza,
                           P.numpolunico,		                                --> 12/03/2021 (JALV +)
                           DP.fecinivig, 
                           DP.fecfinvig, 
                           PNJ.nombre, 
                           PNJ.apellido_paterno, 
                           PNJ.apellido_materno,
                           OC_ASEGURADO.EDAD_ASEGURADO(A.codcia, A.codempresa, A.cod_asegurado, TRUNC(SYSDATE)) EDAD,
                           PNJ.sexo, 
                           PNJ.estadocivil, 
                           PNJ.fecnacimiento,
                           PNJ.curp,
                           PNJ.fecingreso,        
                           PNJ.tipo_doc_identificacion,
                           PNJ.num_doc_identificacion,
                           PNJ.tipo_persona,
                           PNJ.num_tributario, 
                           PNJ.tipo_id_tributaria,
                           DP.idtiposeg                        TIPO_SEGURO,
                           OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(A.codcia, A.codempresa, DP.idtiposeg) DESC_TIPO_SEGURO,
                           'Individual'                        TIPO_POLIZA,
                           OC_PAIS.NOMBRE_PAIS(PNJ.codpaisres) PAIS,
                           OC_PROVINCIA.NOMBRE_PROVINCIA(PNJ.codpaisres, PNJ.codprovres) ESTADO,
                           OC_DISTRITO.NOMBRE_DISTRITO(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres) CIUDAD,
                           OC_CORREGIMIENTO.nombre_corregimiento(PNJ.codpaisres,PNJ.codprovres,PNJ.coddistres,PNJ.codcorrres) MUNICIPIO_ALCALDIA,
                           OC_COLONIA.DESCRIPCION_COLONIA(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres, PNJ.codcorrres, PNJ.codposres, PNJ.codcolres) COLONIA,        
                           PNJ.codposres,
                           PNJ.nacionalidad,
                           DP.Suma_Aseg_Local SumaAsegurada,
                           DP.Prima_Local PrimaNeta
                    FROM   POLIZAS                     P,
                           DETALLE_POLIZA              DP,
                           ASEGURADO                   A,
                           PERSONA_NATURAL_JURIDICA    PNJ,
                           AGENTE_POLIZA               AP,
                           (SELECT DISTINCT C.CodCia, C.Cod_Agente, C.IdPoliza, D.Cod_Agente_Distr,
                                    OC_AGENTES.NIVEL_AGENTE(C.CodCia, c.Cod_Agente ) Nivel
                               FROM COMISIONES C, AGENTES_DISTRIBUCION_POLIZA D,
                                    AGENTE_POLIZA P
                              WHERE C.CodCia         = nCodCia
                                AND C.Cod_Agente     = D.Cod_Agente_Distr
                                AND C.IdPoliza       = D.IdPoliza
                                AND D.Cod_Agente     = P.Cod_Agente
                                AND C.IdPoliza       = P.IdPoliza
                                AND P.Ind_Principal  = 'S') D
                    WHERE  P.idpoliza      = DP.idpoliza
                    AND    P.codcia        = DP.codcia
                    AND    P.codempresa    = DP.codempresa
                    AND    A.cod_asegurado = DP.cod_asegurado
                    AND    A.codcia        = DP.codcia
                    AND    A.codempresa    = DP.codempresa
                    AND    A.codcia        = P.codcia
                    AND    A.codempresa    = P.codempresa
                    AND    DP.stsdetalle   <> 'PRE'
                    AND    A.tipo_doc_identificacion   = PNJ.tipo_doc_identificacion
                    AND    A.num_doc_identificacion    = PNJ.num_doc_identificacion
                    AND    PNJ.nombre      = NVL(cNombreContratante, PNJ.nombre)                       --> 11/03/2021  (JALV +)
                    AND    (cApePatContratante IS NULL OR PNJ.apellido_paterno = cApePatContratante)   --> 11/03/2021  (JALV +)
                    AND    (cApeMatContratante IS NULL OR PNJ.apellido_materno = cApeMatContratante)   --> 11/03/2021  (JALV +)
                    AND    A.codcia        = AP.codcia
                    AND    P.idpoliza      = AP.idpoliza
                    AND    P.codcia        = AP.codcia
                    AND    AP.idpoliza     = DP.idpoliza
                    AND    AP.codcia       = DP.codcia
                    AND    OC_POLIZAS.POLIZA_COLECTIVA(P.CodCia, P.CodEmpresa, P.IdPoliza) = 'N'
                    AND    P.codcia         = nCodCia
                    AND    P.codempresa     = nCodEmpresa
                    AND    P.idpoliza       = NVL(nIdPoliza,P.IdPoliza)
                    AND     AP.cod_agente IN (SELECT   A.cod_agente
                                                FROM   AGENTES A
                                                CONNECT BY PRIOR A.cod_agente = A.cod_agente_jefe
                                                AND     A.est_agente  = 'ACT'
                                                AND     A.codcia      = nCodCia
                                                AND     A.codempresa  = nCodEmpresa
                                                START WITH A.cod_agente  = nCodAgente
                                                ) 
                    AND    AP.Ind_Principal   = 'S'
                    AND    AP.IdPoliza   = D.IdPoliza
                    AND    AP.CodCia     = D.CodCia
                    AND    D.Cod_Agente  = nCodAgenteSesion
                    AND    D.Nivel       = nNivel
                    AND    P.numpolunico = NVL(cNumPolUnico, P.numpolunico)
                    --AND    A.cod_asegurado  = NVL(:nContratante, A.cod_asegurado)
                    --AND    P.fecinivig >= :dFechaIni
                    --AND    P.fecfinvig <= :dFechaFin
                   UNION
                   -- Colectiva
                    SELECT AC.cod_asegurado                        ASEGURADO,
                           AC.estado                               EDOASEG,
                           AP.cod_agente                           AGENTE, 
                           DECODE(AP.ind_principal,'S','Si','No')  PRINCIPAL, 
                           P.idpoliza,
                           P.numpolunico,		                                --> 12/03/2021 (JALV +)
                           DP.fecinivig, 
                           DP.fecfinvig, 
                           PNJ.nombre, 
                           PNJ.apellido_paterno, 
                           PNJ.apellido_materno,
                           OC_ASEGURADO.EDAD_ASEGURADO(P.codcia, P.codempresa, AC.cod_asegurado, TRUNC(SYSDATE)) EDAD,
                           PNJ.sexo, 
                           PNJ.estadocivil, 
                           PNJ.fecnacimiento,
                           PNJ.curp,
                           PNJ.fecingreso,        
                           PNJ.tipo_doc_identificacion,
                           PNJ.num_doc_identificacion,
                           PNJ.tipo_persona,
                           PNJ.num_tributario, 
                           PNJ.tipo_id_tributaria,
                           DP.idtiposeg                            TIPO_SEGURO,
                           OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(P.codcia, P.codempresa, DP.idtiposeg) DESC_TIPO_SEGURO,
                           'Colectiva'                             TIPO_POLIZA,
                           OC_PAIS.NOMBRE_PAIS(PNJ.codpaisres)     PAIS,
                           OC_PROVINCIA.NOMBRE_PROVINCIA(PNJ.codpaisres, PNJ.codprovres) ESTADO,
                           OC_DISTRITO.NOMBRE_DISTRITO(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres) CIUDAD,
                           OC_CORREGIMIENTO.nombre_corregimiento(PNJ.codpaisres,PNJ.codprovres,PNJ.coddistres,PNJ.codcorrres) MUNICIPIO_ALCALDIA,
                           OC_COLONIA.DESCRIPCION_COLONIA(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres, PNJ.codcorrres, PNJ.codposres, PNJ.codcolres) COLONIA,        
                           PNJ.codposres,
                           PNJ.nacionalidad,
                           AC.SumaAseg SumaAsegurada,
                           AC.PrimaNeta
                    FROM   POLIZAS                     P,
                           DETALLE_POLIZA              DP,
                           ASEGURADO_CERTIFICADO       AC,
                           ASEGURADO                   A,
                           PERSONA_NATURAL_JURIDICA    PNJ,
                           AGENTE_POLIZA               AP,
                           (SELECT  DISTINCT C.CodCia, C.Cod_Agente, C.IdPoliza, D.Cod_Agente_Distr,
                                    OC_AGENTES.NIVEL_AGENTE(C.CodCia, c.Cod_Agente ) Nivel
                               FROM COMISIONES C,
                                    AGENTES_DISTRIBUCION_POLIZA D,
                                    AGENTE_POLIZA P
                              WHERE C.CodCia         = nCodCia
                                AND C.Cod_Agente     = D.Cod_Agente_Distr
                                AND C.IdPoliza       = D.IdPoliza
                                AND D.Cod_Agente     = P.Cod_Agente
                                AND C.IdPoliza       = P.IdPoliza
                                AND P.Ind_Principal  = 'S') D   
                  WHERE     P.idpoliza       = DP.idpoliza
                    AND     P.codcia         = DP.codcia
                    AND     P.codempresa     = DP.codempresa
                    AND     DP.idpoliza      = AC.idpoliza
                    AND     DP.codcia        = AC.codcia
                    AND     DP.idetpol       = AC.idetpol
                    AND     AC.cod_asegurado  = A.cod_asegurado
                    AND     AC.codcia         = A.codcia
                    AND     A.tipo_doc_identificacion   = PNJ.tipo_doc_identificacion
                    AND     A.num_doc_identificacion    = PNJ.num_doc_identificacion
                    AND     PNJ.nombre       = NVL(cNombreContratante, PNJ.nombre)                      --> 11/03/2021  (JALV +)
                    AND     (cApePatContratante IS NULL OR PNJ.apellido_paterno = cApePatContratante)   --> 11/03/2021  (JALV +)
                    AND     (cApeMatContratante IS NULL OR PNJ.apellido_materno = cApeMatContratante)   --> 11/03/2021  (JALV +)
                    AND     P.idpoliza       = AP.idpoliza
                    AND     P.codcia         = AP.codcia
                    AND     P.codcia         = nCodCia
                    AND     P.codempresa     = nCodEmpresa
                    AND     P.idpoliza       = NVL(nIdPoliza,P.IdPoliza)
                    AND     AP.cod_agente IN (SELECT   A.cod_agente
                                                FROM   AGENTES A
                                                CONNECT BY PRIOR A.cod_agente = A.cod_agente_jefe
                                                AND    A.est_agente  = 'ACT'
                                                AND    A.codcia      = nCodCia
                                                AND    A.codempresa  = nCodEmpresa
                                                START WITH A.cod_agente  = nCodAgente
                                                ) 
                    AND     DP.stsdetalle   <> 'PRE'
                    AND    AP.Ind_Principal   = 'S'
                    AND    AP.IdPoliza   = D.IdPoliza
                    AND    AP.CodCia     = D.CodCia
                    AND    D.Cod_Agente  = nCodAgenteSesion
                    AND    D.Nivel       = nNivel
                    AND    P.numpolunico = NVL(cNumPolUnico, P.numpolunico)
                 --AND     AC.cod_asegurado =  :nContratante  -- NVL(:nContratante, AC.cod_asegurado) --
                 --AND     P.fecinivig >= :dFechaIni
                 --AND     P.fecfinvig <= :dFechaFin
                ); 

   END;

   SELECT XMLROOT (xPrevAsegs, VERSION '1.0" encoding="UTF-8')
     INTO xListadoAsegurados
     FROM DUAL;
   RETURN xListadoAsegurados;

END LISTADO_ASEGURADO;


FUNCTION CONSULTA_ASEGURADO (nCodCia  NUMBER,  nCodEmpresa NUMBER, nCodAsegurado  NUMBER, nIdPoliza NUMBER DEFAULT NULL, nIDetPol NUMBER DEFAULT NULL)
	RETURN XMLTYPE IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 10/01/2021                                                                                                       |
    | Email		 : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : CONSULTA_ASEGURADO                                                                                               |
    | Objetivo   : Funcion que obtiene la informacion detallada del Asegurado dado desde la Plataforma Digital y tranforma la       |
    |              salida en formato XML.                                                                                           |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico	 : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nodCia                  Codigo de Compañia              (Entrada)                                                   |    
    |			nNoContratante		    Codigo del Cliente		        (Entrada)                                                   |
    |           nCodEmpresa             Codigo de Empresa               (Entrada)                                                   |
    |_______________________________________________________________________________________________________________________________|
*/
xAsegurado    XMLTYPE;
xPrevAseg    XMLTYPE; 
BEGIN
   BEGIN
        SELECT XMLELEMENT("DATA",
                            XMLAGG(XMLELEMENT("ASEGURADOS",
                                                XMLELEMENT("Asegurado", asegurado),
                                                XMLELEMENT("Agente", agente),
                                                XMLELEMENT("Principal", principal),
                                                XMLELEMENT("IDPoliza", idpoliza),
                                                XMLELEMENT("NumPolUnico", numpolunico),
                                                XMLELEMENT("IdetPol", idetpol),
                                                XMLELEMENT("FecIniVig", fecinivig),
                                                XMLELEMENT("FecFinVig", fecfinvig),
                                                XMLELEMENT("FecSolicitud", fecsolicitud),
                                                XMLELEMENT("FecEmision", fecemision),
                                                XMLELEMENT("FecRenovacion", fecrenovacion),
                                                XMLELEMENT("Nombre", nombre),
                                                XMLELEMENT("ApellidoPaterno", apellido_paterno),
                                                XMLELEMENT("ApellidoMaterno", apellido_materno),
                                                XMLELEMENT("Edad", edad),
                                                XMLELEMENT("Sexo", sexo),
                                                XMLELEMENT("EdoCivil", estadocivil),
                                                XMLELEMENT("FecNacimiento", fecnacimiento),
                                                XMLELEMENT("Curp", curp),
                                                XMLELEMENT("FecIngreso", fecingreso),
                                                XMLELEMENT("TipoDocIdentificacion", tipo_doc_identificacion),
                                                XMLELEMENT("NumDocIdentificacion", num_doc_identificacion),
                                                XMLELEMENT("TipoPersona", tipo_persona),
                                                XMLELEMENT("NumTributario", num_tributario),
                                                XMLELEMENT("TipoIdTtributaria", tipo_id_tributaria),
                                                XMLELEMENT("TipoSeguro", tipo_seguro),
                                                XMLELEMENT("NomTipoSeguro", des_tipo_seguro),
                                                XMLELEMENT("TipoPoliza", tipo_poliza),
                                                XMLELEMENT("Pais", pais),
                                                XMLELEMENT("Estado", estado),
                                                XMLELEMENT("Ciudad", ciudad),
                                                XMLELEMENT("MunicipioAlcaldia", municipio_alcaldia),
                                                XMLELEMENT("Colonia", colonia),
                                                XMLELEMENT("C.P.", codposres),
                                                XMLELEMENT("Nacionalidad", nacionalidad),
                                                XMLELEMENT("CodPlanPago", codplanpago),
                                                XMLELEMENT("StsDetalle", stsdetalle),
                                                XMLELEMENT("SumaAsegLocal", suma_aseg_local),
                                                XMLELEMENT("PrimaLocal", prima_local),
                                                XMLELEMENT("PrimaNetaLocal", primaneta_local),
                                                XMLELEMENT("NumDetRef", numdetref),
                                                XMLELEMENT("FecAnula", fecanul),
                                                XMLELEMENT("MotivAnula", motivanul)
                                              )
                                  )
                         )                                                
        INTO	xPrevAseg
        FROM    (SELECT A.cod_asegurado                         ASEGURADO, 
                        AP.cod_agente                           AGENTE, 
                        DECODE(AP.ind_principal,'S','Si','No')  PRINCIPAL, 
                        P.idpoliza,
                        P.numpolunico,
                        DP.idetpol,
                        DP.fecinivig, 
                        DP.fecfinvig,
                        P.fecsolicitud, 
                        P.fecemision, 
                        P.fecrenovacion, 
                        PNJ.nombre, 
                        PNJ.apellido_paterno, 
                        PNJ.apellido_materno,
                        OC_ASEGURADO.EDAD_ASEGURADO(A.codcia, A.codempresa, A.cod_asegurado, TRUNC(SYSDATE)) EDAD,
                        PNJ.sexo, 
                        PNJ.estadocivil, 
                        PNJ.fecnacimiento,
                        PNJ.curp,
                        PNJ.fecingreso,        
                        PNJ.tipo_doc_identificacion,
                        PNJ.num_doc_identificacion,
                        PNJ.tipo_persona,
                        PNJ.num_tributario, 
                        PNJ.tipo_id_tributaria,
                        DP.idtiposeg                            TIPO_SEGURO,
                        OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(A.codcia, A.codempresa, DP.idtiposeg) DES_TIPO_SEGURO,
                        'Individual'                            TIPO_POLIZA,
                        OC_PAIS.NOMBRE_PAIS(PNJ.codpaisres)     PAIS,
                        OC_PROVINCIA.NOMBRE_PROVINCIA(PNJ.codpaisres, PNJ.codprovres) ESTADO,
                        OC_DISTRITO.NOMBRE_DISTRITO(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres) CIUDAD,
                        OC_CORREGIMIENTO.nombre_corregimiento(PNJ.codpaisres,PNJ.codprovres,PNJ.coddistres,PNJ.codcorrres) MUNICIPIO_ALCALDIA,
                        OC_COLONIA.DESCRIPCION_COLONIA(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres, PNJ.codcorrres, PNJ.codposres, PNJ.codcolres) COLONIA,        
                        PNJ.codposres,
                        PNJ.nacionalidad,
                        DP.codplanpago, 
                        DP.stsdetalle, 
                        DP.suma_aseg_local, 
                        DP.prima_local,
                        P.primaneta_local,
                        DP.numdetref,
                        DP.fecanul,
                        DP.motivanul
                 FROM   ASEGURADO                   A,
                        PERSONA_NATURAL_JURIDICA    PNJ,
                        AGENTE_POLIZA               AP,
                        POLIZAS                     P,
                        DETALLE_POLIZA              DP 
                 WHERE  P.idpoliza      = DP.idpoliza
                 AND    P.codcia        = DP.codcia
                 AND    P.codempresa    = DP.codempresa
                 AND    A.cod_asegurado = DP.cod_asegurado
                 AND    A.codcia        = DP.codcia
                 AND    A.codempresa    = DP.codempresa
                 AND    A.codcia        = P.codcia
                 AND    A.codempresa    = P.codempresa
                 AND    A.tipo_doc_identificacion   = PNJ.tipo_doc_identificacion
                 AND    A.num_doc_identificacion    = PNJ.num_doc_identificacion  
                 AND    A.codcia        = AP.codcia
                 AND    P.idpoliza      = AP.idpoliza
                 AND    P.codcia        = AP.codcia
                 AND    AP.idpoliza     = DP.idpoliza
                 AND    AP.codcia       = DP.codcia
                 AND    OC_POLIZAS.POLIZA_COLECTIVA(P.CodCia, P.CodEmpresa, P.IdPoliza) = 'N'
                 AND    P.codcia         = nCodCia
                 AND    P.codempresa     = nCodEmpresa
                 --AND    P.idpoliza       = :nPoliza
                 --AND    AP.cod_agente    = :nCodAgente
                 AND    A.cod_asegurado  = nCodAsegurado    --NVL(:nContratante, A.cod_asegurado)
                 AND P.IdPoliza                   = NVL(nIdPoliza,P.IdPoliza)
                 AND DP.IDetPol                   = NVL(nIDetPol,DP.IDetPol)
                 AND DP.StsDetalle     = 'EMI'
                 --AND    P.fecinivig >= :dFechaIni
                 --AND    P.fecfinvig <= :dFechaFin
                UNION
                -- Colectiva
                 SELECT A.cod_asegurado, 
                        AP.cod_agente, 
                        DECODE(AP.ind_principal,'S','Si','No') PRINCIPAL, 
                        P.idpoliza,
                        P.numpolunico,
                        DP.idetpol,
                        DP.fecinivig, 
                        DP.fecfinvig,
                        P.fecsolicitud, 
                        P.fecemision, 
                        P.fecrenovacion, 
                        PNJ.nombre, 
                        PNJ.apellido_paterno, 
                        PNJ.apellido_materno,
                        OC_ASEGURADO.EDAD_ASEGURADO(p.codcia, p.codempresa, AC.cod_asegurado, TRUNC(SYSDATE)) EDAD,
                        PNJ.sexo, 
                        PNJ.estadocivil, 
                        PNJ.fecnacimiento,
                        PNJ.curp,
                        PNJ.fecingreso,        
                        PNJ.tipo_doc_identificacion,
                        PNJ.num_doc_identificacion,
                        PNJ.tipo_persona,
                        PNJ.num_tributario, 
                        PNJ.tipo_id_tributaria,
                        DP.idtiposeg TIPO_SEGURO,
                        OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(p.codcia, P.codempresa, DP.idtiposeg) DESC_TIPO_SEGURO,
                        'Colectiva' TIPO_POLIZA,
                        OC_PAIS.NOMBRE_PAIS(PNJ.codpaisres) PAIS,
                        OC_PROVINCIA.NOMBRE_PROVINCIA(PNJ.codpaisres, PNJ.codprovres) ESTADO,
                        OC_DISTRITO.NOMBRE_DISTRITO(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres) CIUDAD,
                        OC_CORREGIMIENTO.nombre_corregimiento(PNJ.codpaisres,PNJ.codprovres,PNJ.coddistres,PNJ.codcorrres) MUNICIPIO_ALCALDIA,
                        OC_COLONIA.DESCRIPCION_COLONIA(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres, PNJ.codcorrres, PNJ.codposres, PNJ.codcolres) COLONIA,        
                        PNJ.codposres,
                        PNJ.nacionalidad,
                        DP.codplanpago, 
                        DP.stsdetalle, 
                        DP.suma_aseg_local, 
                        DP.prima_local,
                        P.primaneta_local,
                        DP.numdetref,
                        DP.fecanul,
                        DP.motivanul
                 FROM   ASEGURADO_CERTIFICADO       AC,
                        ASEGURADO                   A,
                        PERSONA_NATURAL_JURIDICA    PNJ,
                        AGENTE_POLIZA               AP,
                        POLIZAS                     P,
                        DETALLE_POLIZA              DP  
                   WHERE P.codcia                     = nCodCia
                     AND P.codempresa                 = nCodEmpresa
                     AND AC.cod_asegurado             = nCodAsegurado 
                     AND P.IdPoliza                   = NVL(nIdPoliza,P.IdPoliza)
                     AND DP.IDetPol                   = NVL(nIDetPol,DP.IDetPol)
                     AND P.idpoliza                   = DP.idpoliza
                     AND P.codcia                     = DP.codcia
                     AND P.codempresa                 = DP.codempresa     
                     AND DP.codcia                    = AC.codcia
                     AND DP.idpoliza                  = AC.idpoliza
                     AND DP.idetpol                   = AC.idetpol
                     AND AC.codcia                    = A.codcia
                     AND AC.cod_asegurado             = A.cod_asegurado   
                     AND A.tipo_doc_identificacion    = PNJ.tipo_doc_identificacion
                     AND A.num_doc_identificacion     = PNJ.num_doc_identificacion  
                     AND P.idpoliza                   = AP.idpoliza
                     AND P.codcia                     = AP.codcia
                     AND AC.Estado                    = 'EMI'
                );

      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'El Asegurado '||nCodAsegurado||' no existente en Base de Datos.'); 
   END;

   SELECT 	XMLROOT (xPrevAseg, VERSION '1.0" encoding="UTF-8')
   INTO		xAsegurado
   FROM 	DUAL;

   RETURN xAsegurado;

END CONSULTA_ASEGURADO;

FUNCTION VALIDA_ASEG_UNAM(  nCodCia         NUMBER,
                            nCodEmpresa     NUMBER,
                            cNombre         VARCHAR2,   --> JALV (+) 05/02/2021 
                            cApePaterno     VARCHAR2,   --> JALV (+) 05/02/2021
                            cApeMaterno     VARCHAR2,   --> JALV (+) 05/02/2021
                            dFecNac         VARCHAR2,       --> JALV (+) 05/02/2021
                            cEmail          VARCHAR2,   --> JALV (+) 05/02/2021
                            --, cCodAsegurado VARCHAR2  --> JALV (-) 05/02/2021
                            --, cNutra        VARCHAR2  --> JALV (-) 05/02/2021
                            cCodAgrupador VARCHAR2
                            --OUT XML DE POLIZAS 
                             ) RETURN VARCHAR2 IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : ?                                                                                                                |
    | Para       : ?                                                                                                                |
    | Fecha Elab.: ?                                                                                                                |
    | Email		 : ?                                                                                                                |
    | Nombre     : VALIDA_ASEG_UNAM                                                                                                 |
    | Objetivo   : Funcion que valida la existencia del Asegurado UNAM.                                                             |
    | Modificado : Si                                                                                                               |
    | Ult. modif.: 05/02/2021                                                                                                       |
    | Modifico	 : J. Alberto Lopez Valle                                                                                           |
    | Obj. Modif.: Se cambio funcionalidad por completo. Verifica que exista una Poliza asociada, Si existe o no su contraseña de   |
    |              Usuario si no es asi la genera,encripta e inserta el usuario. Verifica tambien si el cliente existe en el        |
    |              servicio de impresion de certificados individuales si no es asi lo agrega. Restringe el numero de intentos para  |
    |              determinar si puede o no hacerlo directamente en Plataforma Digital o con ejecutivo. Devuelve el Password.       |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nodCia                  Codigo de Compañia                  (Entrada)                                               |        
    |           nCodEmpresa             Codigo de Empresa                   (Entrada)                                               |
    |			cNombre		            Nombre del Asegurado	            (Entrada)                                               |
    |			cApePaterno		        Apellido Paterno del Asegurado      (Entrada)                                               |
    |			cApeMaterno		        Apellido Materno del Asegurado      (Entrada)                                               |
    |			dFecNac		            Fecha de Nacimiento del Asegurado   (Entrada)                                               |
    |			cEmail		            Correo electronico del Asegurado    (Entrada)                                               |
    |			cCodAgrupador		    Codigo del Agrupador		        (Entrada)                                               |
    |_______________________________________________________________________________________________________________________________|
*/                             
   --cExiste        VARCHAR2(1);                                --> JALV (-) 05/02/2021
   --cPrefijo       VARCHAR2(3);                                --> JALV (-) 05/02/2021
   --cCampo3        ASEGURADO_CERTIFICADO.Campo3%TYPE;          --> JALV (-) 05/02/2021
   nCodAsegurado    ASEGURADO_CERTIFICADO.Cod_Asegurado%TYPE;
   nCodCliente      POLIZAS.CodCliente%TYPE;                    --> Inicia agregar variables: JALV 05/02/2021
   nIntento         USER_CERTIF_INDIV.NoIntento%TYPE;   
   cPassword        USER_CERTIF_INDIV.password%TYPE;
   nIdCertCte       CTES_CERTIF_INDIV.IdCertCte%TYPE;   
   cStsCliente      CLIENTES.StsCliente%TYPE;
   nIdPoliza        POLIZAS.IdPoliza%TYPE;
   cPasswE          VARCHAR2(100);
   cResultado       VARCHAR2(2000);
   cExisteUsr       VARCHAR2(1);
   cExisteCte       VARCHAR2(1);                                --> Fin agregar variables: JALV 05/02/2021
BEGIN
      --cPrefijo := SUBSTR(cCodAsegurado,1,3);
      --nCodAsegurado := TO_NUMBER(SUBSTR(cCodAsegurado,5,LENGTH(cCodAsegurado)));

    BEGIN
            --> Este servicio validará que el asegurado existe a partir del nombre, apellidos y fecha de nacimiento,
            SELECT  DISTINCT NVL(A.cod_asegurado,0), P.codcliente, P.idpoliza, C.stscliente
            --INTO cExiste                                                      --> JALV (-) 05/02/2021
            INTO    nCodAsegurado, nCodCliente, nIdPoliza, cStsCliente          --> JALV (+) 05/02/2021
            FROM    PERSONA_NATURAL_JURIDICA    PNJ,                            --> JALV (+) 05/02/2021
                    ASEGURADO                   A,                              --> JALV (+) 05/02/2021
                    ASEGURADO_CERTIFICADO       AC,
                    POLIZAS                     P,
                    DETALLE_POLIZA              DP,
                    CLIENTES                    C                               --> JALV (+) 05/02/2021
            WHERE   A.tipo_doc_identificacion   = PNJ.tipo_doc_identificacion   --> JALV (+) 05/02/2021
            AND     A.num_doc_identificacion    = PNJ.num_doc_identificacion    --> JALV (+) 05/02/2021
            AND     C.codcliente                = P.codcliente                  --> JALV (+) 05/02/2021
            AND     A.Cod_Asegurado             = AC.Cod_Asegurado              --> JALV (+) 05/02/2021
            AND     A.codcia                    = P.codcia                      --> JALV (+) 05/02/2021
            AND     A.CodEmpresa                = P.CodEmpresa                  --> JALV (+) 05/02/2021
            AND     AC.idpoliza                 = P.idpoliza                    --> JALV (+) 05/02/2021
            AND     AC.codcia                   = P.codcia                      --> JALV (+) 05/02/2021
            AND     AC.CodCia                   = DP.CodCia
            AND     AC.IdPoliza                 = DP.IdPoliza
            AND     AC.IDetPol                  = DP.IDetPol
            AND     P.idpoliza                  = DP.idpoliza
            AND     P.CodCia                    = DP.CodCia
            AND     P.CodEmpresa                = DP.CodEmpresa
            AND     UPPER(PNJ.nombre)           LIKE UPPER(cNombre) --)= NVL(UPPER(cNombre),UPPER(PNJ.nombre))    --> JALV (+) 05/02/2021
            AND     UPPER(PNJ.apellido_paterno) = UPPER(cApePaterno)            --> JALV (+) 05/02/2021
            AND     UPPER(PNJ.apellido_materno) = UPPER(cApeMaterno)            --> JALV (+) 05/02/2021
            AND     PNJ.fecnacimiento           = TO_DATE(dFecNac,'DD/MM/YYYY')--TO_DATE(dFecNac,'DD/MM/YY')   --> JALV (+) 05/02/2021           
            AND     P.CodAgrupador              = cCodAgrupador
            AND     AC.Estado                   = 'EMI'                         --> JALV (+) 05/02/2021
            AND     A.CodCia                    = nCodCia                       --> JALV (+) 05/02/2021
            AND     A.CodEmpresa                = nCodEmpresa;                  --> JALV (+) 05/02/2021
            --AND A.Cod_Asegurado  = nCodAsegurado                              --> JALV (-) 05/02/2021

            nIntento := OC_USER_CERTIF_INDIV.NUM_INTENTOS_CERT(nCodCia, nCodEmpresa, nCodAsegurado);
            --DBMS_OUTPUT.PUT_LINE('Si Existe el Asegurado '||nCodAsegurado||' en Poliza de Cliente y el No. Intentos realizados es: '||nIntento);            

            --DBMS_OUTPUT.PUT_LINE('  Ahora voy a validar que exista en Usuarios: USER_CERTIF_INDIV');
            cExisteUsr := OC_USER_CERTIF_INDIV.EXISTE_USUARIO_CERT(nCodCia, nCodEmpresa, nCodAsegurado);

            --DBMS_OUTPUT.PUT_LINE('  Luego validar si el Cliente '||nCodCliente||' existe en CTES_CERTIF_INDIV');
            cExisteCte:= OC_CTES_CERTIF_INDIV.EXISTE_CTE_CERT(nCodCia, nCodEmpresa, nCodCliente);

            --DBMS_OUTPUT.PUT_LINE('Validar accion segun el número de intento');                     
            IF nIntento = 0 AND cExisteUsr = 'N' THEN    --> Registrar Password y/o Cliente (NoIntentos = 1)
                --DBMS_OUTPUT.PUT_LINE('Ninguna vez ('||nIntento||'): No Existe el Password ni usuario. Se Genera y Encripta el Password');
                cPasswE   := OC_USER_CERTIF_INDIV.CREA_PASSW_CERT (cNombre, cApePaterno, cApeMaterno, nCodAsegurado);  --> Cambiar Prefijo del Nombre ****
                cPassword := OC_USER_CERTIF_INDIV.ENCRIPTA_PW(cPasswE);    

                IF cExisteCte = 'N' THEN -- NO EXISTE Cliente
                    --DBMS_OUTPUT.PUT_LINE('No existe Cliente en CTES_CERTIF_INDIV, Insertarlo y Activarlo');
                    --DBMS_OUTPUT.PUT_LINE('OC_CTES_CERTIF_INDIV.INSERTAR('||nCodCia||', '||nCodEmpresa||', ctes_certif_indiv_seq.NEXTVAL, '||nCodCliente||')');
                    OC_CTES_CERTIF_INDIV.INSERTAR(nCodCia, nCodEmpresa, ctes_certif_indiv_seq.NEXTVAL, nCodCliente);
                    --DBMS_OUTPUT.PUT_LINE('OC_CTES_CERTIF_INDIV.ACTIVAR('||nCodCia||', '||nCodEmpresa||', ctes_certif_indiv_seq.currval)');
                    OC_CTES_CERTIF_INDIV.ACTIVAR(nCodCia, nCodEmpresa, ctes_certif_indiv_seq.currval);                    
                END IF;                
                --DBMS_OUTPUT.PUT_LINE('Obtener el IdCertCte del Cliente en CTES_CERTIF_INDIV');
                SELECT IdCertCte
                INTO   nIdCertCte
                FROM   CTES_CERTIF_INDIV
                WHERE  CodCliente  = nCodCliente
                AND    CodCia      = nCodCia
                AND    CodEmpresa  = nCodEmpresa;
                --DBMS_OUTPUT.PUT_LINE(' Obtuve el IdCertCte '||nIdCertCte||' de CTES_CERTIF_INDIV, y continuo ...');                                      
                --DBMS_OUTPUT.PUT_LINE('Ahora si ya puedo Insertar Y Activar el Asegurado '||nCodAsegurado||' en tabla USER_CERTIF_INDIV');
                --DBMS_OUTPUT.PUT_LINE('OC_USER_CERTIF_INDIV.INSERTAR('||nCodCia||', '||nCodEmpresa||', user_certif_indiv_seq.NEXTVAL, '||nCodAsegurado||', '||cPassword||', '||cEmail||', '||nIntento||', '||nIdCertCte);
                OC_USER_CERTIF_INDIV.INSERTAR(nCodCia, nCodEmpresa, user_certif_indiv_seq.NEXTVAL, nCodAsegurado, cPassword, cEmail, nIntento, nIdCertCte);                
                --DBMS_OUTPUT.PUT_LINE('OC_USER_CERTIF_INDIV.ACTIVAR('||nCodCia||', '||nCodEmpresa||', user_certif_indiv_seq.CURRVAL)');
                OC_USER_CERTIF_INDIV.ACTIVAR(nCodCia, nCodEmpresa, user_certif_indiv_seq.CURRVAL);

                --DBMS_OUTPUT.PUT_LINE('Finalmente Devolver el password generado');
                cResultado := OC_USER_CERTIF_INDIV.DESENCRIPTA_PW(OC_USER_CERTIF_INDIV.OBTENER_PASSW_CERT(nCodCia, nCodEmpresa, nCodAsegurado));
            ELSIF   nIntento = 1 THEN
                --DBMS_OUTPUT.PUT_LINE('Primera vez ('||nIntento||'): Devolver el pasword ya registrado');
                cResultado := OC_USER_CERTIF_INDIV.DESENCRIPTA_PW(OC_USER_CERTIF_INDIV.OBTENER_PASSW_CERT(nCodCia, nCodEmpresa, nCodAsegurado));
            --ELSIF   nIntento = 2 THEN
                --DBMS_OUTPUT.PUT_LINE('Segunda vez ('||nIntento||'): Devolver el pasword ya registrado');
             --   cResultado := OC_USER_CERTIF_INDIV.OBTENER_PASSW_CERT(nCodCia, nCodEmpresa, nCodAsegurado);
            ELSE
                --DBMS_OUTPUT.PUT_LINE('Tercera ocasión o mas ('||nIntento||')');
                --DBMS_OUTPUT.PUT_LINE('Devolver Mensaje de Numero de intentos excedido');
                cResultado := 'Numero de intentos excedido';
            END IF;

            IF nIntento  != 0 OR cResultado <> 'Password_No_existe' OR cResultado <> 'NO EXISTE el asegurado en Polizas de UNAM' THEN
            --DBMS_OUTPUT.PUT_LINE('Incremento el numero de intentos');              
               UPDATE  USER_CERTIF_INDIV
                SET     Email = cEmail, NoIntento = NoIntento+1
                WHERE   CodAsegurado = nCodAsegurado
                AND     CodCia       = nCodCia
                AND     CodEmpresa   = nCodEmpresa;
                --COMMIT;
            END IF;

      EXCEPTION 
         WHEN NO_DATA_FOUND THEN
            --DBMS_OUTPUT.PUT_LINE('No existe, devolver mensaje de asegurado no registrado en pólizas UNAM');
            --cExiste := 'N';                                                   --> JALV (-) 05/02/2021
            nCodAsegurado := 0;                                                 --> JALV (-) 05/02/2021
            cResultado := 'NO EXISTE el asegurado en Polizas de UNAM';
    END;
       --DBMS_OUTPUT.PUT_LINE('Valor Final obtenido '||cResultado);    

    RETURN cResultado;    
END VALIDA_ASEG_UNAM;

   FUNCTION POLIZAS_ASEGURADO_UNAM   (  nCodCia       NUMBER
                                      , nCodEmpresa   NUMBER
                                      , nCodAsegurado NUMBER
                                      , cCodAgrupador VARCHAR2) RETURN XMLTYPE IS
   nIdPoliza      POLIZAS.IdPoliza%TYPE;
   nIDetPol       DETALLE_POLIZA.IDetPol%TYPE;
   xAseg          XMLTYPE;
   xPolizas       XMLTYPE;
   xListaPolizas  XMLTYPE;

   CURSOR POL_Q IS
      SELECT P.NumPolUnico, P.IdPoliza, D.IDetPol, 
             P.FecIniVig, P.FecFinVig
        FROM ASEGURADO_CERTIFICADO A, DETALLE_POLIZA D, POLIZAS P
       WHERE A.CodCia         = nCodCia
         AND A.Cod_Asegurado  = nCodAsegurado
         AND P.CodAgrupador   = cCodAgrupador
         AND P.StsPoliza      = 'EMI'
         AND A.CodCia         = D.CodCia
         AND A.IdPoliza       = D.IdPoliza
         AND A.IDetPol        = D.IDetPol
         AND D.CodCia         = P.CodCia
         AND D.CodEmpresa     = P.CodEmpresa
         AND D.IdPoliza       = P.IdPoliza ;
   BEGIN
      SELECT XMLCONCAT(
                  XMLELEMENT("Cod_Asegurado", A.Cod_Asegurado),
                  XMLELEMENT("NombreAsegurado", OC_ASEGURADO.NOMBRE_ASEGURADO(nCodCia, nCodEmpresa, A.Cod_Asegurado))
            )
        INTO xAseg
        FROM ASEGURADO A
       WHERE A.CodCia         = nCodCia
         AND A.Cod_Asegurado  = nCodAsegurado;

      FOR X IN POL_Q LOOP
         nIdPoliza   := X.IdPoliza;
         nIDetPol    := X.IDetPol;
         SELECT XMLCONCAT(XMLELEMENT("POLIZA",
                              XMLELEMENT("NumPolUnico", X.NumPolUnico),
                              XMLELEMENT("IDetPol", X.IDetPol),
                              XMLELEMENT("IdPoliza", X.IdPoliza),
                              XMLELEMENT("FecIniVig", TO_CHAR(X.FecIniVig,'DD/MM/YYYY')),
                              XMLELEMENT("FecFinVig", TO_CHAR(X.FecFinVig,'DD/MM/YYYY'))
                           )
                  )
           INTO xPolizas
           FROM ASEGURADO_CERTIFICADO A, DETALLE_POLIZA D, POLIZAS P
          WHERE A.CodCia         = nCodCia
            AND A.Cod_Asegurado  = nCodAsegurado
            AND D.IdPoliza       = nIdPoliza
            AND D.IDetPol        = nIDetPol
            AND P.CodAgrupador   = cCodAgrupador
            AND P.StsPoliza      = 'EMI'
            AND A.CodCia         = D.CodCia
            AND A.IdPoliza       = D.IdPoliza
            AND A.IDetPol        = D.IDetPol
            AND D.CodCia         = P.CodCia
            AND D.CodEmpresa     = P.CodEmpresa
            AND D.IdPoliza       = P.IdPoliza ;

         SELECT XMLCONCAT(xListaPolizas,xPolizas)
           INTO xListaPolizas
           FROM DUAL;
      END LOOP;

      SELECT XMLELEMENT("DATA",XMLCONCAT(xAseg,xListaPolizas))
        INTO xAseg
        FROM DUAL;

      SELECT XMLROOT(xAseg, VERSION '1.0" encoding="UTF-8')
        INTO xAseg
        FROM DUAL;

      RETURN xAseg;
   END POLIZAS_ASEGURADO_UNAM;

-- Funcion que valida password y devuelve xml
FUNCTION CONSULTA_POLIZA_UNAM ( nCodCia         NUMBER,	
                                nCodEmpresa     NUMBER,
                                --nCodAsegurado   NUMBER,
                                cCodAgrupador   VARCHAR2,
                                cPassword       VARCHAR2)
RETURN XMLTYPE IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 05/02/2021                                                                                                       |
    | Email		 : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : CONSULTA_POLIZA_UNAM                                                                                             |
    | Objetivo   : Funcion que verifica el password del Asegurado, si coincide genenera un XML con la Poliza del Asegurado UNAM.    |
    |              Devuelve un XML.                                                                                                 |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico	 : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nCodCia                 Codigo de Compañia              (Entrada)                                                   |
    |           nCodEmpresa             Codigo de Empresa               (Entrada)                                                   |
    |           nCodAsegurado           Codigo del Asegurado            (Entrada)                                                   |
    |           cCodAgrupador           Codigo del Agrupador            (Entrada)                                                   |
    |           cPassword               Contraseña a validar            (Entrada)                                                   |
    |_______________________________________________________________________________________________________________________________|
*/
cCoincidePw     VARCHAR2(1);
nCodAsegurado   ASEGURADO_CERTIFICADO.Cod_Asegurado%TYPE;
xCertificado    XMLTYPE;
xPrevArch       XMLTYPE; 
BEGIN    
    nCodAsegurado := SUBSTR(cPassword,(INSTR(cPassword, '-',1)+1),LENGTH(cPassword));
    --cCoincidePw := OC_USER_CERTIF_INDIV.COMPARA_PASSW_CERT ( nCodCia, nCodEmpresa, nCodAsegurado, cPassword);
    cCoincidePw := OC_USER_CERTIF_INDIV.COMPARA_PASSW_CERT ( nCodCia, nCodEmpresa, cPassword);
    IF cCoincidePw = 'S' THEN
        xPrevArch   :=  POLIZAS_ASEGURADO_UNAM (nCodCia, nCodEmpresa, nCodAsegurado, cCodAgrupador);
     /*ELSE
        SELECT XMLELEMENT("DATA",
                            XMLELEMENT("Password NO coimcide",1)
                        )
        INTO	xPrevArch
		FROM    DUAL;*/
     END IF;

   SELECT 	XMLROOT(xPrevArch, VERSION '1.0" encoding="UTF-8')
   INTO		xCertificado
   FROM 	DUAL;

   RETURN xCertificado;   
END CONSULTA_POLIZA_UNAM;

END OC_ASEGURADO_SERVICIOS_WEB;
/
CREATE OR REPLACE PUBLIC SYNONYM OC_ASEGURADO_SERVICIOS_WEB FOR SICAS_OC.OC_ASEGURADO_SERVICIOS_WEB;
/
GRANT EXECUTE ON OC_ASEGURADO_SERVICIOS_WEB TO PUBLIC;
/
