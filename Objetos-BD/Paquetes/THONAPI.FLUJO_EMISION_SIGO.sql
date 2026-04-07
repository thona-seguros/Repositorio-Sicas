CREATE OR REPLACE PACKAGE THONAPI.FLUJO_EMISION_SIGO IS
   FUNCTION SOLICITAR_POL_COLECTIVA( nCodCia                   COTIZACIONES.CodCia%TYPE
                                   , nCodEmpresa               COTIZACIONES.CodEmpresa%TYPE
                                   , nIdCotizacion             COTIZACIONES.IdCotizacion%TYPE
                                   , cTipoDocIdentificacion    PERSONA_NATURAL_JURIDICA.Tipo_Doc_Identificacion%TYPE
                                   , cNumDocIdentificacion     PERSONA_NATURAL_JURIDICA.Num_Doc_Identificacion%TYPE
                                   , cNombreCliente            PERSONA_NATURAL_JURIDICA.Nombre%TYPE
                                   , cApellidoPaternoCliente   PERSONA_NATURAL_JURIDICA.Apellido_Paterno%TYPE
                                   , cApellidoMaternoCliente   PERSONA_NATURAL_JURIDICA.Apellido_Materno%TYPE
                                   , cSexo                     PERSONA_NATURAL_JURIDICA.Sexo%TYPE
                                   , dFecNacimiento            PERSONA_NATURAL_JURIDICA.FecNacimiento%TYPE
                                   , cTipoPersona              PERSONA_NATURAL_JURIDICA.Tipo_Persona%TYPE
                                   , cTipoIdTributario         PERSONA_NATURAL_JURIDICA.Tipo_Id_Tributaria%TYPE
                                   , cNumTributario            PERSONA_NATURAL_JURIDICA.Num_Tributario%TYPE
                                   , cDirecRes                 PERSONA_NATURAL_JURIDICA.DirecRes%TYPE
                                   , cNumInterior              PERSONA_NATURAL_JURIDICA.NumInterior%TYPE
                                   , cNumExterior              PERSONA_NATURAL_JURIDICA.NumExterior%TYPE
                                   , cCodColonia               PERSONA_NATURAL_JURIDICA.CodColRes%TYPE
                                   , cCodProvRes               PERSONA_NATURAL_JURIDICA.CodProvRes%TYPE
                                   , cCodPosRes                PERSONA_NATURAL_JURIDICA.CodPosRes%TYPE
                                   , cTelRes                   PERSONA_NATURAL_JURIDICA.TelRes%TYPE
                                   , cEmail                    PERSONA_NATURAL_JURIDICA.Email%TYPE
                                   , cNacionalidad             PERSONA_NATURAL_JURIDICA.Nacionalidad%TYPE
                                   , cCodFormaCobro            MEDIOS_DE_COBRO.CodFormaCobro%TYPE
                                   , cCodEntidadFinan          MEDIOS_DE_COBRO.CodEntidadFinan%TYPE
                                   , cNumCuentaBancaria        MEDIOS_DE_COBRO.NumCuentaBancaria%TYPE
                                   , cNumCuentaClabe           MEDIOS_DE_COBRO.NumCuentaClabe%TYPE
                                   , cNumTarjeta               MEDIOS_DE_COBRO.NumTarjeta%TYPE
                                   , dFechaVencTarjeta         MEDIOS_DE_COBRO.FechaVencTarjeta%TYPE
                                   , cNombreTitular            MEDIOS_DE_COBRO.NombreTitular%TYPE
                                   , dFecIniVig                DETALLE_POLIZA.FecIniVig%TYPE
                                   , dFecFinVig                DETALLE_POLIZA.FecFinVig%TYPE
                                   , cCodPlanPago              DETALLE_POLIZA.CodPlanPago%TYPE
                                   , cIndAsegModelo            DETALLE_POLIZA.IndAsegModelo%TYPE
                                   , cCodActividad             PERSONA_NATURAL_JURIDICA.CodActividad%TYPE ) RETURN NUMBER;
   --
   PROCEDURE INSERTAR_ASISTENCIAS_ASEG( nCodCia            ASISTENCIAS_ASEGURADO.CodCia%TYPE
                                      , nCodEmpresa        ASISTENCIAS_ASEGURADO.CodEmpresa%TYPE
                                      , nIdPoliza          ASISTENCIAS_ASEGURADO.IdPoliza%TYPE
                                      , nIDetPol           ASISTENCIAS_ASEGURADO.IDetPol%TYPE
                                      , nIdEndoso          ASISTENCIAS_ASEGURADO.IdEndoso%TYPE
                                      , cCodAsistencia     ASISTENCIAS_ASEGURADO.CodAsistencia%TYPE
                                      , cCodMoneda         ASISTENCIAS_ASEGURADO.CodMoneda%TYPE
                                      , nMontoAsistLocal   ASISTENCIAS_ASEGURADO.MontoAsistLocal%TYPE
                                      , nMontoAsistMoneda  ASISTENCIAS_ASEGURADO.MontoAsistMoneda%TYPE );
   --
   FUNCTION ACTUALIZAR_INFORMACION_FISCAL( nCodCia                   POLIZAS.CodCia%TYPE
                                         , nCodEmpresa               POLIZAS.CodEmpresa%TYPE
                                         , nIdPoliza                 POLIZAS.IdPoliza%TYPE
                                         , cCodUsoCFDI               POLIZAS.CodUsoCFDI%TYPE
                                         , cCodObjetoImp             POLIZAS.CodObjetoImp%TYPE
                                         , nIdRegFisSAT              PERSONA_NATURAL_JURIDICA.IdRegFisSAT%TYPE
                                         , cRazonSocialFact          PERSONA_NATURAL_JURIDICA.RazonSocialFact%TYPE
                                         , cTipo_Doc_Identificacion  DIRECCIONES_PNJ.Tipo_Doc_Identificacion%TYPE
                                         , cNum_Doc_Identificacion   DIRECCIONES_PNJ.Num_Doc_Identificacion%TYPE
                                         , cTipo_Direccion           DIRECCIONES_PNJ.Tipo_Direccion%TYPE
                                         , cDireccion                DIRECCIONES_PNJ.Direccion%TYPE
                                         , cCodPais                  DIRECCIONES_PNJ.CodPais%TYPE
                                         , cCodEstado                DIRECCIONES_PNJ.CodEstado%TYPE
                                         , cCodCiudad                DIRECCIONES_PNJ.CodCiudad%TYPE
                                         , cCodMunicipio             DIRECCIONES_PNJ.CodMunicipio%TYPE
                                         , cCodigo_Postal            DIRECCIONES_PNJ.Codigo_Postal%TYPE
                                         , cCodAsentamiento          DIRECCIONES_PNJ.CodAsentamiento%TYPE
                                         , cCodigo_ZIP               DIRECCIONES_PNJ.Codigo_ZIP%TYPE
                                         , cDireccion_Principal      DIRECCIONES_PNJ.Direccion_Principal%TYPE
                                         , cNumInterior              DIRECCIONES_PNJ.NumInterior%TYPE
                                         , cNumExterior              DIRECCIONES_PNJ.NumExterior%TYPE ) RETURN VARCHAR2;
   --
   PROCEDURE CARGAR_ASEGURADOS( nCodCia      ASEGURADOS_SIGO_TMP.CodCia%TYPE
                              , nCodEmpresa  ASEGURADOS_SIGO_TMP.CodEmpresa%TYPE
                              , nIdPoliza    ASEGURADOS_SIGO_TMP.IdPoliza%TYPE );
   --
   FUNCTION INSERTAR_ASEGURADOS( nCodCia           ASEGURADOS_SIGO_TMP.CodCia%TYPE
                               , nCodEmpresa       ASEGURADOS_SIGO_TMP.CodEmpresa%TYPE
                               , nIdPoliza         ASEGURADOS_SIGO_TMP.IdPoliza%TYPE
                               , nIDetPol          ASEGURADOS_SIGO_TMP.IDetPol%TYPE
                               , cNombre           ASEGURADOS_SIGO_TMP.Nombre%TYPE
                               , cApellidoPaterno  ASEGURADOS_SIGO_TMP.ApellidoPaterno%TYPE
                               , cApellidoMaterno  ASEGURADOS_SIGO_TMP.ApellidoMaterno%TYPE
                               , cGenero           ASEGURADOS_SIGO_TMP.Genero%TYPE
                               , dFecNacimiento    ASEGURADOS_SIGO_TMP.FecNacimiento%TYPE
                               , nSalarioMensual   ASEGURADOS_SIGO_TMP.SalarioMensual%TYPE
                               , nVecesSalario     ASEGURADOS_SIGO_TMP.VecesSalario%TYPE
                               , nSumAsegFija      ASEGURADOS_SIGO_TMP.SumAsegFija%TYPE
                               , cRFC              ASEGURADOS_SIGO_TMP.RFC%TYPE ) RETURN NUMBER;
   --
   FUNCTION ELIMINAR_ASEGURADOS( nCodCia      ASEGURADOS_SIGO_TMP.CodCia%TYPE
                               , nCodEmpresa  ASEGURADOS_SIGO_TMP.CodEmpresa%TYPE
                               , nIdPoliza    ASEGURADOS_SIGO_TMP.IdPoliza%TYPE
                               , nIDetPol     ASEGURADOS_SIGO_TMP.IDetPol%TYPE ) RETURN NUMBER;
   --
   FUNCTION PRE_EMITE_POLIZA( nCodCia           POLIZAS.CODCIA%TYPE
                            , nCodEmpresa       POLIZAS.CODEMPRESA%TYPE
                            , nIdPoliza         POLIZAS.IDPOLIZA%TYPE
                            , cIndRequierePago  VARCHAR2 ) RETURN CLOB;
   --
   FUNCTION CONSULTAR_FACTURAS( nCodCia    FACTURAS.CodCia%TYPE
                              , nIdPoliza  FACTURAS.IdPoliza%TYPE ) RETURN CLOB;
   --
   PROCEDURE CARGAR_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                            cPlanCob VARCHAR2, nIdPoliza NUMBER, nIDetPol NUMBER,
                            nTasaCambio NUMBER, nCod_Asegurado NUMBER, cCodCobert VARCHAR2,
                            nSumaAsegManual NUMBER, nSalarioMensual NUMBER, nVecesSalario NUMBER,
                            nEdad_Minima NUMBER, nEdad_Maxima NUMBER, nEdad_Exclusion NUMBER,
                            nSumaAseg_Minima NUMBER, nSumaAseg_Maxima NUMBER, nPorcExtraPrima NUMBER,
                            nMontoExtraPrima NUMBER, nSumaIngresada NUMBER,nFranquiciaingresado NUMBER, 
                            nMontoDiario NUMBER, nDias_Cal NUMBER);

END FLUJO_EMISION_SIGO;
/

CREATE OR REPLACE PACKAGE BODY THONAPI.FLUJO_EMISION_SIGO IS
   --
   FUNCTION SOLICITAR_POL_COLECTIVA( nCodCia                   COTIZACIONES.CodCia%TYPE
                                   , nCodEmpresa               COTIZACIONES.CodEmpresa%TYPE
                                   , nIdCotizacion             COTIZACIONES.IdCotizacion%TYPE
                                   , cTipoDocIdentificacion    PERSONA_NATURAL_JURIDICA.Tipo_Doc_Identificacion%TYPE
                                   , cNumDocIdentificacion     PERSONA_NATURAL_JURIDICA.Num_Doc_Identificacion%TYPE
                                   , cNombreCliente            PERSONA_NATURAL_JURIDICA.Nombre%TYPE
                                   , cApellidoPaternoCliente   PERSONA_NATURAL_JURIDICA.Apellido_Paterno%TYPE
                                   , cApellidoMaternoCliente   PERSONA_NATURAL_JURIDICA.Apellido_Materno%TYPE
                                   , cSexo                     PERSONA_NATURAL_JURIDICA.Sexo%TYPE
                                   , dFecNacimiento            PERSONA_NATURAL_JURIDICA.FecNacimiento%TYPE
                                   , cTipoPersona              PERSONA_NATURAL_JURIDICA.Tipo_Persona%TYPE
                                   , cTipoIdTributario         PERSONA_NATURAL_JURIDICA.Tipo_Id_Tributaria%TYPE
                                   , cNumTributario            PERSONA_NATURAL_JURIDICA.Num_Tributario%TYPE
                                   , cDirecRes                 PERSONA_NATURAL_JURIDICA.DirecRes%TYPE
                                   , cNumInterior              PERSONA_NATURAL_JURIDICA.NumInterior%TYPE
                                   , cNumExterior              PERSONA_NATURAL_JURIDICA.NumExterior%TYPE
                                   , cCodColonia               PERSONA_NATURAL_JURIDICA.CodColRes%TYPE
                                   , cCodProvRes               PERSONA_NATURAL_JURIDICA.CodProvRes%TYPE
                                   , cCodPosRes                PERSONA_NATURAL_JURIDICA.CodPosRes%TYPE
                                   , cTelRes                   PERSONA_NATURAL_JURIDICA.TelRes%TYPE
                                   , cEmail                    PERSONA_NATURAL_JURIDICA.Email%TYPE
                                   , cNacionalidad             PERSONA_NATURAL_JURIDICA.Nacionalidad%TYPE
                                   , cCodFormaCobro            MEDIOS_DE_COBRO.CodFormaCobro%TYPE
                                   , cCodEntidadFinan          MEDIOS_DE_COBRO.CodEntidadFinan%TYPE
                                   , cNumCuentaBancaria        MEDIOS_DE_COBRO.NumCuentaBancaria%TYPE
                                   , cNumCuentaClabe           MEDIOS_DE_COBRO.NumCuentaClabe%TYPE
                                   , cNumTarjeta               MEDIOS_DE_COBRO.NumTarjeta%TYPE
                                   , dFechaVencTarjeta         MEDIOS_DE_COBRO.FechaVencTarjeta%TYPE
                                   , cNombreTitular            MEDIOS_DE_COBRO.NombreTitular%TYPE
                                   , dFecIniVig                DETALLE_POLIZA.FecIniVig%TYPE
                                   , dFecFinVig                DETALLE_POLIZA.FecFinVig%TYPE
                                   , cCodPlanPago              DETALLE_POLIZA.CodPlanPago%TYPE
                                   , cIndAsegModelo            DETALLE_POLIZA.IndAsegModelo%TYPE
                                   , cCodActividad             PERSONA_NATURAL_JURIDICA.CodActividad%TYPE ) RETURN NUMBER IS
      nIdPoliza                POLIZAS.IdPoliza%TYPE;
      cTipoDocIdentificacion2  PERSONA_NATURAL_JURIDICA.Tipo_Doc_Identificacion%TYPE;
      cNumDocIdentificacion2   PERSONA_NATURAL_JURIDICA.Num_Doc_Identificacion%TYPE;
      --cTipoPersona             PERSONA_NATURAL_JURIDICA.Tipo_Persona%TYPE;
      nCodCliente              CLIENTES.CodCliente%TYPE;
      cCodPais                 PAIS.CodPais%TYPE;
      cCodEstado               CORREGIMIENTO.CodEstado%TYPE;
      cCodCiudad               DISTRITO.CodCiudad%TYPE;
      cCodMunicipio            COLONIA.CodMunicipio%TYPE;
      nIdFormaCobro            MEDIOS_DE_COBRO.IdFormaCobro%TYPE;
      nCodAsegurado            ASEGURADO.Cod_Asegurado%TYPE;
      nIdTransac               TRANSACCION.IdTransaccion%TYPE;
   BEGIN
      IF cIndAsegModelo = 'N' THEN
         UPDATE COTIZACIONES
         SET    IndAsegModelo = cIndAsegModelo
         WHERE  IdCotizacion  = nIdCotizacion;
      END IF;
      --
      IF cTipoDocIdentificacion IS NOT NULL AND cNumDocIdentificacion IS NOT NULL THEN
         cTipoDocIdentificacion2 := cTipoDocIdentificacion;
         cNumDocIdentificacion2  := cNumDocIdentificacion;
      ELSE
         cTipoDocIdentificacion2 := 'RFC';
         cNumDocIdentificacion2  := OC_PERSONA_NATURAL_JURIDICA.NUMERO_TRIBUTARIO_RFC( CAMBIA_ACENTOS(cNombreCliente)
                                                                                     , CAMBIA_ACENTOS(cApellidoPaternoCliente)
                                                                                     , CAMBIA_ACENTOS(cApellidoMaternoCliente)
                                                                                     , dFecNacimiento
                                                                                     , cTipoPersona );
      END IF; 
      --
      BEGIN
         SELECT DISTINCT PA.CodPais, M.CodEstado, D.CodCiudad, C.CodMunicipio    
         INTO   cCodPais, cCodEstado, cCodCiudad, cCodMunicipio
         FROM   APARTADO_POSTAL CP  INNER JOIN CORREGIMIENTO M ON  M.CodMunicipio   = CP.CodMunicipio 
                                                               AND M.CodPais        = CP.CodPais 
                                                               AND M.CodEstado      = CP.CodEstado 
                                                               AND M.CodCiudad      = CP.CodCiudad 
                                    INNER JOIN COLONIA C       ON  C.CodPais        = CP.CodPais 
                                                               AND C.CodEstado      = CP.CodEstado 
                                                               AND C.CodCiudad      = CP.CodCiudad 
                                                               AND C.CodMunicipio   = M.CodMunicipio 
                                                               AND C.Codigo_Postal  = CP.Codigo_Postal
                                    INNER JOIN PROVINCIA P     ON  P.CodPais        = CP.CodPais 
                                                               AND P.CodEstado      = CP.CodEstado
                                    INNER JOIN DISTRITO D      ON  D.CodPais        = CP.CodPais 
                                                               AND D.CodEstado      = CP.CodEstado 
                                                               AND D.CodCiudad      = C.CodCiudad 
                                    INNER JOIN PAIS PA         ON  PA.CodPais       = CP.CodPais                                   
         WHERE CP.Codigo_Postal = cCodPosRes
           AND C.Codigo_Colonia = cCodColonia;
      END;
      --
      IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(cTipoDocIdentificacion2, cNumDocIdentificacion2) = 'N' THEN
         --             
         OC_PERSONA_NATURAL_JURIDICA.INSERTAR_PERSONA( cTipoDocIdentificacion2  --cTipo_Doc_Identificacion
                                                     , cNumDocIdentificacion2   --cNum_Doc_Identificacion
                                                     , cNombreCliente           --cNombre
                                                     , cApellidoPaternoCliente  --cApellidoPat
                                                     , cApellidoMaternoCliente  --cApellidoMat
                                                     , NULL                     --cApeCasada
                                                     , NVL(cSexo, 'U')          --cSexo
                                                     , NULL                     --cEstadoCivil
                                                     , dFecNacimiento           --dFecNacimiento
                                                     , cDirecRes                --cDirecRes
                                                     , cNumInterior             --cNumInterior
                                                     , cNumExterior             --cNumExterior
                                                     , cCodPais                 --cCodPaisRes
                                                     , cCodEstado               --cCodProvRes
                                                     , cCodCiudad               --cCodDistRes       
                                                     , cCodMunicipio            --cCodCorrRes
                                                     , cCodPosRes               --cCodPosRes
                                                     , cCodColonia              --cCodColonia
                                                     , cTelRes                  --cTelRes
                                                     , cEmail                   --cEmail
                                                     , NULL );                  --cLadaTelRes
         --
         UPDATE PERSONA_NATURAL_JURIDICA
         SET    Tipo_Persona       = cTipoPersona
           ,    Tipo_Id_Tributaria = cTipoIdTributario
           ,    Num_Tributario     = NVL(cNumTributario, 'XAXX010101000')
           ,    Nacionalidad       = cNacionalidad
           ,    CodActividad       = cCodActividad
         WHERE  Tipo_Doc_Identificacion = cTipoDocIdentificacion2
           AND  Num_Doc_Identificacion  = cNumDocIdentificacion2;
      ELSE 
         UPDATE PERSONA_NATURAL_JURIDICA
         SET    CodPaisRes     = cCodPais
           ,    CodProvRes     = cCodEstado
           ,    CodDistRes     = cCodCiudad
           ,    CodCorrRes     = cCodMunicipio
           ,    CodPosRes      = cCodPosRes
           ,    ZipRes         = cCodPosRes
           ,    CodColRes      = cCodColonia
           ,    DirecRes       = cDirecRes      --cDirecRes
           ,    NumInterior    = cNumInterior   --cNumInterior
           ,    NumExterior    = cNumExterior   --cNumExterior
           ,    Nacionalidad   = cNacionalidad  -- nacionalidad
           ,    Num_Tributario = NVL(cNumTributario, 'XAXX010101000')
           ,    CodActividad   = cCodActividad
         WHERE  Tipo_Doc_Identificacion = cTipoDocIdentificacion2
           AND  Num_Doc_Identificacion  = cNumDocIdentificacion2;
      END IF;
      --
      IF cCodFormaCobro IS NOT NULL THEN
         BEGIN
            SELECT NVL(MAX(IdFormaCobro),0)
            INTO   nIdFormaCobro
            FROM   MEDIOS_DE_COBRO
            WHERE  Tipo_Doc_Identificacion = cTipoDocIdentificacion2
              AND  Num_Doc_Identificacion  = cNumDocIdentificacion2;
         END;
         --
         IF nIdFormaCobro = 0 THEN 
            nIdFormaCobro := 1;
         ELSE
            nIdFormaCobro := nIdFormaCobro + 1;
         END IF;
         --
         OC_MEDIOS_DE_COBRO.INSERTAR(cTipoDocIdentificacion2, cNumDocIdentificacion2, nIdFormaCobro, 'S', 'CTC');
         --
         UPDATE MEDIOS_DE_COBRO
         SET    CodFormaCobro     = cCodFormaCobro
           ,    CodEntidadFinan   = cCodEntidadFinan
           ,    NumCuentaBancaria = cNumCuentaBancaria
           ,    NumCuentaClabe    = cNumCuentaClabe
           ,    NumTarjeta        = cNumTarjeta
           ,    FechaVencTarjeta  = TO_DATE(dFechaVencTarjeta, 'DD/MM/YYYY')
           ,    NombreTitular     = cNombreTitular
         WHERE  Tipo_Doc_Identificacion = cTipoDocIdentificacion2
           AND  Num_Doc_Identificacion  = cNumDocIdentificacion2
           AND  IdFormaCobro            = nIdFormaCobro;
      END IF;
      --
      nCodCliente := OC_CLIENTES.CODIGO_CLIENTE(cTipoDocIdentificacion2, cNumDocIdentificacion2);
      --
      IF nCodCliente = 0 THEN
         nCodCliente := OC_CLIENTES.INSERTAR_CLIENTE(cTipoDocIdentificacion2, cNumDocIdentificacion2);
      END IF;
      --
      nCodAsegurado := OC_ASEGURADO.CODIGO_ASEGURADO(nCodCia, nCodEmpresa, cTipoDocIdentificacion2, cNumDocIdentificacion2);
      --
      IF nCodAsegurado = 0 THEN
         nCodAsegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(nCodCia, nCodEmpresa, cTipoDocIdentificacion2, cNumDocIdentificacion2);
      END IF;                                      
      --     
      nIdPoliza := GT_COTIZACIONES.CREAR_POLIZA(nCodCia, nCodEmpresa, nIdCotizacion, nCodCliente, nCodAsegurado);
      --
      IF cIndAsegModelo = 'N' THEN
         UPDATE COTIZACIONES
         SET    IndAsegModelo = 'S'
         WHERE  IdCotizacion = nIdCotizacion;
      END IF;
      --
      IF cCodPlanPago IS NOT NULL THEN
         UPDATE POLIZAS
         SET    CodPlanPago = cCodPlanPago
         WHERE  CodCia     = nCodCia
           AND  CodEmpresa = nCodEmpresa
           AND  IdPoliza   = nIdPoliza;
         --
         UPDATE DETALLE_POLIZA
         SET    CodPlanPago = cCodPlanPago
         WHERE  CodCia     = nCodCia
           AND  CodEmpresa = nCodEmpresa
           AND  IdPoliza   = nIdPoliza;
      END IF;
      --
      RETURN nIdPoliza;
   EXCEPTION
   WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL SOLICITAR_POL_COLECTIVA: ' || nIdCotizacion || SQLERRM);
   END SOLICITAR_POL_COLECTIVA;
   --
   PROCEDURE INSERTAR_ASISTENCIAS_ASEG( nCodCia            ASISTENCIAS_ASEGURADO.CodCia%TYPE
                                      , nCodEmpresa        ASISTENCIAS_ASEGURADO.CodEmpresa%TYPE
                                      , nIdPoliza          ASISTENCIAS_ASEGURADO.IdPoliza%TYPE
                                      , nIDetPol           ASISTENCIAS_ASEGURADO.IDetPol%TYPE
                                      , nIdEndoso          ASISTENCIAS_ASEGURADO.IdEndoso%TYPE
                                      , cCodAsistencia     ASISTENCIAS_ASEGURADO.CodAsistencia%TYPE
                                      , cCodMoneda         ASISTENCIAS_ASEGURADO.CodMoneda%TYPE
                                      , nMontoAsistLocal   ASISTENCIAS_ASEGURADO.MontoAsistLocal%TYPE
                                      , nMontoAsistMoneda  ASISTENCIAS_ASEGURADO.MontoAsistMoneda%TYPE ) IS
      cStsAsistencia  ASISTENCIAS_ASEGURADO.StsAsistencia%TYPE := 'EMITID';
      dFecSts         ASISTENCIAS_ASEGURADO.FecSts%TYPE := TRUNC(SYSDATE);
      --
      CURSOR cAsegurados IS
             SELECT Cod_Asegurado
             FROM   ASEGURADO_CERTIFICADO
             WHERE  CodCia   = nCodCia
               AND  IdPoliza = nIdPoliza
               AND  IDetPol  = nIDetPol
               AND  IdEndoso = nIdEndoso;
   BEGIN
      FOR x IN cAsegurados LOOP
          INSERT INTO ASISTENCIAS_ASEGURADO
                 ( CodCia   , CodEmpresa     , IdPoliza        , IDetPol      , Cod_Asegurado, CodAsistencia,
                   CodMoneda, MontoAsistLocal, MontoAsistMoneda, StsAsistencia, FecSts       , IdEndoso )
          VALUES ( nCodCia           , nCodEmpresa             , nIdPoliza                , nIDetPol      , x.Cod_Asegurado, NVL(cCodAsistencia, 0),
                   NVL(cCodMoneda, 0), NVL(nMontoAsistLocal, 0), NVL(nMontoAsistMoneda, 0), cStsAsistencia, dFecSts        , nIdEndoso );
      END LOOP;
   EXCEPTION
   WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL INSERTAR_ASISTENCIAS_ASEG EN LA POLIZA: ' || nIdPoliza || ' - ' || SQLERRM);
   END INSERTAR_ASISTENCIAS_ASEG;
   --
   FUNCTION ACTUALIZAR_INFORMACION_FISCAL( nCodCia                   POLIZAS.CodCia%TYPE
                                         , nCodEmpresa               POLIZAS.CodEmpresa%TYPE
                                         , nIdPoliza                 POLIZAS.IdPoliza%TYPE
                                         , cCodUsoCFDI               POLIZAS.CodUsoCFDI%TYPE
                                         , cCodObjetoImp             POLIZAS.CodObjetoImp%TYPE
                                         , nIdRegFisSAT              PERSONA_NATURAL_JURIDICA.IdRegFisSAT%TYPE
                                         , cRazonSocialFact          PERSONA_NATURAL_JURIDICA.RazonSocialFact%TYPE
                                         , cTipo_Doc_Identificacion  DIRECCIONES_PNJ.Tipo_Doc_Identificacion%TYPE
                                         , cNum_Doc_Identificacion   DIRECCIONES_PNJ.Num_Doc_Identificacion%TYPE
                                         , cTipo_Direccion           DIRECCIONES_PNJ.Tipo_Direccion%TYPE
                                         , cDireccion                DIRECCIONES_PNJ.Direccion%TYPE
                                         , cCodPais                  DIRECCIONES_PNJ.CodPais%TYPE
                                         , cCodEstado                DIRECCIONES_PNJ.CodEstado%TYPE
                                         , cCodCiudad                DIRECCIONES_PNJ.CodCiudad%TYPE
                                         , cCodMunicipio             DIRECCIONES_PNJ.CodMunicipio%TYPE
                                         , cCodigo_Postal            DIRECCIONES_PNJ.Codigo_Postal%TYPE
                                         , cCodAsentamiento          DIRECCIONES_PNJ.CodAsentamiento%TYPE
                                         , cCodigo_ZIP               DIRECCIONES_PNJ.Codigo_ZIP%TYPE
                                         , cDireccion_Principal      DIRECCIONES_PNJ.Direccion_Principal%TYPE
                                         , cNumInterior              DIRECCIONES_PNJ.NumInterior%TYPE
                                         , cNumExterior              DIRECCIONES_PNJ.NumExterior%TYPE ) RETURN VARCHAR2 IS
      cResultado              VARCHAR2(2) := 'OK';
      nCorrelativo_Direccion  DIRECCIONES_PNJ.Correlativo_Direccion%TYPE;
      cContador               NUMBER;
   BEGIN
      UPDATE POLIZAS
      SET    CodUsoCFDI   = cCodUsoCFDI
        ,    CodObjetoImp = cCodObjetoImp
      WHERE  CodCia     = nCodCia
        AND  CodEmpresa = nCodEmpresa
        AND  IdPoliza   = nIdPoliza;
      --
      OC_PERSONA_NATURAL_JURIDICA.ACTUALIZA_INFORMACION_FISCAL( cTipo_Doc_Identificacion, cNum_Doc_Identificacion, nIdRegFisSAT, cRazonSocialFact );
      --
      BEGIN
         SELECT NVL(MAX(Correlativo_Direccion), 0) + 1
         INTO   nCorrelativo_Direccion
         FROM   DIRECCIONES_PNJ
         WHERE  Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
           AND  Num_Doc_Identificacion  = cNum_Doc_Identificacion;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
           nCorrelativo_Direccion := 1;
      END;
      --
      SELECT COUNT(*)
      INTO   cContador
      FROM   DIRECCIONES_PNJ
      WHERE  Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
        AND  Num_Doc_Identificacion  = cNum_Doc_Identificacion
        AND  Tipo_Direccion          = cTipo_Direccion;
      --
      IF cContador > 0 THEN
         DELETE DIRECCIONES_PNJ
         WHERE  Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
           AND  Num_Doc_Identificacion  = cNum_Doc_Identificacion
           AND  Tipo_Direccion          = cTipo_Direccion;
      END IF;
      --
      INSERT INTO DIRECCIONES_PNJ
      VALUES ( cTipo_Doc_Identificacion, cNum_Doc_Identificacion, cTipo_Direccion     , nCorrelativo_Direccion, cDireccion    ,
               cCodPais                , cCodEstado             , cCodCiudad          , cCodMunicipio         , cCodigo_Postal,
               cCodAsentamiento        , cCodigo_ZIP            , cDireccion_Principal, cNumInterior          , cNumExterior );
      --
      RETURN cResultado;
   EXCEPTION
   WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL ACTUZALIZAR INFORMACION FISCAL: ' || SQLERRM);
   END ACTUALIZAR_INFORMACION_FISCAL;

   PROCEDURE CARGAR_ASEGURADOS( nCodCia      ASEGURADOS_SIGO_TMP.CodCia%TYPE
                              , nCodEmpresa  ASEGURADOS_SIGO_TMP.CodEmpresa%TYPE
                              , nIdPoliza    ASEGURADOS_SIGO_TMP.IdPoliza%TYPE ) IS
      nCodCliente            CLIENTES.CodCliente%TYPE;
      cTipoDocIdentAseg      CLIENTES.Tipo_Doc_Identificacion%TYPE;
      cNumDocIdentAseg       CLIENTES.Num_Doc_Identificacion%TYPE;
      nCod_Asegurado         ASEGURADO.Cod_Asegurado%TYPE;
      cPlanCob               PLAN_COBERTURAS.PlanCob%TYPE;
      cExiste                VARCHAR2(1);
      cIdTipoSeg             TIPOS_DE_SEGUROS.IdTipoSeg%TYPE;
      cCodPlanPago           POLIZAS.CodPlanPago%TYPE;
      cCodmoneda             POLIZAS.Cod_Moneda%TYPE;
      nTasaCambio            DETALLE_POLIZA.Tasa_Cambio%TYPE;
      nIDetPol               DETALLE_POLIZA.IdetPol%TYPE;
      dFecIniVig             DATE;
      dFecFinVig             DATE;
      cStsPoliza             POLIZAS.StsPoliza%TYPE;
      cIndSinAseg            VARCHAR2(1);
      cCampo                 CONFIG_PLANTILLAS_CAMPOS.NomCampo%TYPE;
      nSuma                  COBERT_ACT_ASEG.SumaAseg_Local%TYPE;
      nIdEndoso              ENDOSOS.IdEndoso%TYPE;
      cStsDetalle            DETALLE_POLIZA.StsDetalle%TYPE;
      nIdSolicitud           SOLICITUD_EMISION.IdSolicitud%TYPE;
      --
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
      nIDetPolEli            DETALLE_POLIZA.IdetPol%TYPE;
      cIndPolCol             POLIZAS.IndPolCol%TYPE;
      --
	   nNuevaSumAseg          COBERT_ACT_ASEG.SumaAseg_Local%TYPE := 0;
      --
      CURSOR cAseg IS
          SELECT IDetPol, Nombre, ApellidoPaterno, ApellidoMaterno, Genero, FecNacimiento, SalarioMensual, VecesSalario, SumAsegFija, RFC
          FROM   ASEGURADOS_SIGO_TMP
          WHERE  CodCia     = nCodCia
            AND  CodEmpresa = nCodEmpresa
            AND  IdPoliza   = nIdPoliza;
      --
      CURSOR cCertificados IS
          SELECT DISTINCT IDetPol
          FROM   ASEGURADOS_SIGO_TMP
          WHERE  CodCia     = nCodCia
            AND  CodEmpresa = nCodEmpresa
            AND  IdPoliza   = nIdPoliza;
      --
      CURSOR cCoberturas IS
         SELECT CodCobert         , SumaAsegCobLocal, SumaAsegCobMoneda, Tasa              , PrimaCobLocal, PrimaCobMoneda, DeducibleCobLocal,
                DeducibleCobMoneda, SalarioMensual  , VecesSalario     , SumaaSegCalculada , Edad_Minima  , Edad_Maxima   , Edad_Exclusion   ,
                SumaAseg_Minima   , SumaAseg_Maxima , PorcExtraPrimaDet, MontoExtraPrimaDet, SumaIngresada, Franquiciaingresado
         FROM   COTIZACIONES_COBERT_MASTER
         WHERE  CodCia         = nCodCia
           AND  CodEmpresa     = nCodEmpresa
           AND  IdCotizacion   = nIdCotizacion
           AND  IDetCotizacion = nIDetCotizacion;
      --
      CURSOR cCoberturas2 IS
         SELECT CodCobert, SalarioMensual, VecesSalario, SumaIngresada
         FROM   COTIZACIONES_COBERT_MASTER
         WHERE  CodCia         = nCodCia
           AND  CodEmpresa     = nCodEmpresa
           AND  IdCotizacion   = nIdCotizacion
           AND  IDetCotizacion = nIDetCotizacion;
      --
      CURSOR cCobertActAseg IS
         SELECT DISTINCT IDetPol, Cod_Asegurado, IdEndoso
         FROM   COBERT_ACT_ASEG
         WHERE  CodCia     = nCodCia
           AND  CodEmpresa = nCodEmpresa
           AND  IdPoliza   = nIdPoliza
           AND  IDetPol    = nIDetPol;
      --
      CURSOR cCobertActAseg_2 IS
         SELECT DISTINCT IDetPol, IdEndoso
         FROM   COBERT_ACT_ASEG
         WHERE  CodCia     = nCodCia
           AND  CodEmpresa = nCodEmpresa
           AND  IdPoliza   = nIdPoliza
           AND  IDetPol    = nIDetPol;
   BEGIN
      --Información de la Póliza
      BEGIN
         SELECT StsPoliza , Cod_Moneda, FecIniVig , FecFinVig , Num_Cotizacion, IndPolCol
         INTO   cStsPoliza, cCodMoneda, dFecIniVig, dFecFinVig, nIdCotizacion , cIndPolCol
         FROM   POLIZAS
         WHERE  IdPoliza   = nIdPoliza
           AND  CodCia     = nCodCia
           AND  CodEmpresa = CodEmpresa;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
           RAISE_APPLICATION_ERROR(-20225, 'POLIZA NO EXISTE: ' || nIdPoliza);
      END;
      --
      --Información de la Cotización
      BEGIN
         SELECT NVL(IndCotizacionWeb, 'N'), NVL(IndCotizacionBaseWeb, 'N')
         INTO   cIndCotizacionWeb         , cIndCotizacionBaseWeb
         FROM   COTIZACIONES
         WHERE  CodCia       = nCodCia
           AND  IdPoliza     = nIdPoliza
           AND  IdCotizacion = nIdCotizacion;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
           RAISE_APPLICATION_ERROR(-20225, 'COTIZACION NO EXISTE: ' || nIdCotizacion);
      END;
      --
      -- Rutina para eliminar los asegurados relacionados al certificado bajo los criterios establecidos
      FOR x IN cCertificados LOOP
          BEGIN
             SELECT StsDetalle
             INTO   cStsDetalle
             FROM   DETALLE_POLIZA
             WHERE  CodCia     = nCodCia
               AND  CodEmpresa = nCodEmpresa
               AND  IdPoliza   = nIdpoliza
               AND  IDetPol    = x.IDetPol;
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20225, 'DETALLE POLIZA NO EXISTE: '|| nIdPoliza || ' - ' || x.IDetPol);
          END;
          --
          --Valido que sea suceptible de eliminarse: la Póliza y el Certificado estén en Estatus de Solicitud, que la Póliza sea Colectiva y que
          --la Cotización venga de Plataforma Digital para proceder a eliminar los asegurados asociados a ese Certificado y todas las Coberturas asociadas a esos Asegurados
          IF cStsPoliza = 'SOL' AND cStsDetalle = 'SOL' AND cIndPolCol = 'S' AND cIndCotizacionWeb = 'S' AND cIndCotizacionBaseWeb = 'N' THEN
             DELETE COBERT_ACT_ASEG
             WHERE  IdPoliza = nIdPoliza
               AND  IDetPol  = x.IDetPol;
             --
             DELETE ASEGURADO_CERTIFICADO
             WHERE  IdPoliza = nIdPoliza
               AND  IDetPol  = x.IDetPol;
          END IF;
      END LOOP;
      --
      FOR W IN cAseg LOOP
          nIDetPol          := W.IDetPol;
          cTipoDocIdentAseg := 'RFC';
          --
          IF W.RFC IS NOT NULL THEN
             cNumDocIdentAseg := W.RFC;
          ELSE
             cNumDocIdentAseg := OC_PERSONA_NATURAL_JURIDICA.NUMERO_TRIBUTARIO_RFC(W.Nombre, W.ApellidoPaterno, W.ApellidoMaterno, TO_DATE(W.FecNacimiento, 'DD/MM/YYYY'), 'FISICA');
          END IF;
          --
          IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(cTipoDocIdentAseg, cNumDocIdentAseg) = 'N' THEN
             OC_PERSONA_NATURAL_JURIDICA.INSERTAR_PERSONA( cTipoDocIdentAseg,                       --cTipo_Doc_Identificacion
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
             --
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
             nCodCliente := OC_CLIENTES.INSERTAR_CLIENTE(cTipoDocIdentAseg,cNumDocIdentAseg);
          END IF;
          BEGIN
             INSERT INTO CLIENTE_ASEG (CodCliente, Cod_Asegurado)
             VALUES (nCodCliente, nCod_Asegurado);
          EXCEPTION
          WHEN DUP_VAL_ON_INDEX THEN
               NULL;
          END;
          --
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
                 --
                IF NVL(nIdEndoso,0) = 0 THEN
                   nIdEndoso := OC_ENDOSO.CREAR(nIdPoliza);
                   OC_ENDOSO.INSERTA( nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso,
                                      'ESV', 'ENDO-' || TRIM(TO_CHAR(nIdPoliza)) || '-' || TRIM(TO_CHAR(nIdEndoso)),
                                      dFecIniVig, dFecFinVig, cCodPlanPago, 0, 0, 0, '010', NULL);
                END IF;
             END IF;
             OC_ASEGURADO_CERTIFICADO.INSERTA(nCodCia, nIdpoliza, nIDetPol, nCod_Asegurado, nIdEndoso); --- se debe de quitar para produccion ARH
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
          --
          IF cIndEdadPromedio = 'N' AND cIndCuotaPromedio = 'N' AND cIndPrimaPromedio = 'N' THEN
             IF OC_COBERT_ACT_ASEG.EXISTE_COBERTURA (nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nIdPoliza, nIDetPol, nCod_Asegurado) = 'N' THEN
                IF NVL(cIndSinAseg,'N') = 'N' THEN
                   IF NVL(nIdSolicitud,0) = 0 THEN
                      IF NVL(nIdCotizacion,0) = 0 THEN
                         -- MASP cambiamos el llamado de OC_COBERT_ACT_ASEG.CARGAR_COBERTURAS para no tocar el proceso que se usa en SICAS y lo repolicamos en 
                         -- este package con los cambios necesarios
                         CARGAR_COBERTURAS(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nIdPoliza,
                                                              nIDetPol, nTasaCambio, nCod_Asegurado, NULL, 0, 0, 0, 0, 99, 0, 0, 0, 0, 0, 0, 0, 0, 0);
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
                --
                IF NVL(nIdEndoso,0) != 0 THEN
                   UPDATE COBERT_ACT_ASEG
                   SET    IdEndoso = nIdEndoso
                   WHERE  CodCia        = nCodCia
                     AND  IdPoliza      = nIdPoliza
                     AND  IDetPol       = nIDetPol
                     AND  Cod_Asegurado = nCod_Asegurado;
                ELSE
                   IF w.SalarioMensual IS NOT NULL AND w.VecesSalario IS NOT NULL AND w.SumAsegFija IS NOT NULL THEN
                      nNuevaSumAseg := (NVL(w.SalarioMensual, 0) * NVL(w.VecesSalario, 0)) + NVL(w.SumAsegFija, 0);
                      --
                      UPDATE COBERT_ACT_ASEG
                      SET    SumaAseg_Local    = nNuevaSumAseg
                        ,    SumaAseg_Moneda   = nNuevaSumAseg
                        ,    SumaAsegCalculada = nNuevaSumAseg
                        ,    SumaIngresada     = w.SumAsegFija
                        ,    SalarioMensual    = w.SalarioMensual
                        ,    VecesSalario      = w.VecesSalario
                      WHERE  CodCia        = nCodCia
                        AND  IdPoliza      = nIdPoliza
                        AND  IDetPol       = nIDetPol
                        AND  Cod_Asegurado = nCod_Asegurado;
                   ELSE
                      FOR y IN cCoberturas2 LOOP
                          nNuevaSumAseg := (NVL(NVL(w.SalarioMensual, y.SalarioMensual), 0) * NVL(NVL(w.VecesSalario, y.VecesSalario), 0)) + NVL(NVL(w.SumAsegFija, y.SumaIngresada), 0);
                          --
                          UPDATE COBERT_ACT_ASEG
                          SET    SumaAseg_Local    = nNuevaSumAseg
                            ,    SumaAseg_Moneda   = nNuevaSumAseg
                            ,    SumaAsegCalculada = nNuevaSumAseg
                            ,    SumaIngresada     = NVL(w.SumAsegFija, y.SumaIngresada)
                            ,    SalarioMensual    = NVL(w.SalarioMensual, y.SalarioMensual)
                            ,    VecesSalario      = NVL(w.VecesSalario, y.VecesSalario)
                          WHERE  CodCia        = nCodCia
                            AND  IdPoliza      = nIdPoliza
                            AND  IDetPol       = nIDetPol
                            AND  Cod_Asegurado = nCod_Asegurado
                            AND  CodCobert     = y.CodCobert;
                      END LOOP;
                   END IF;
                 END IF;
             END IF;
          END IF;
      END LOOP;
      --
      --Valido si la carga de asegurados proviene de Plataforma Digital
      --Evaluo si SalarioMensual y VecesSalario vienen NULL (no traía nada el XML) para poner en su lugar lo configurado en COTIZACIONES_COBERT_MASTER
      IF cIndCotizacionWeb = 'S' AND cIndCotizacionBaseWeb = 'N' THEN
         FOR x IN cCoberturas LOOP
             UPDATE COBERT_ACT_ASEG
             SET    Tasa                = x.Tasa
               ,    Prima_Moneda        = x.PrimaCobMoneda
               ,    Prima_Local         = x.PrimaCobLocal
               ----,    Deducible_Local     = x.DeducibleCobLocal
               ----,    Deducible_Moneda    = x.DeducibleCobMoneda
               ,    SalarioMensual      = NVL(NVL(SalarioMensual, x.SalarioMensual), 0)
               ,    VecesSalario        = NVL(NVL(VecesSalario, x.VecesSalario), 0)
               --,    SumaAsegCalculada   = x.SumaaSegCalculada
               --,    SumaIngresada       = x.SumaIngresada
               ,    Edad_Minima         = x.Edad_Minima
               ,    Edad_Maxima         = x.Edad_Maxima
               ,    Edad_Exclusion      = x.Edad_Exclusion
               ,    SumaAseg_Minima     = x.SumaAseg_Minima 
               ,    SumaAseg_Maxima     = x.SumaAseg_Maxima
               ,    PorcExtraPrimaDet   = x.PorcExtraPrimaDet
               ,    MontoExtraPrimaDet  = x.MontoExtraPrimaDet
               ,    Franquiciaingresado = x.Franquiciaingresado
             WHERE CodCia     = nCodCia
               AND CodEmpresa = nCodEmpresa
               AND IdPoliza   = nIdPoliza
               AND IDetPol    = nIDetPol
               AND CodCobert  = x.CodCobert;
         END LOOP;
         --
         --Actualizo Valores de todos los asegurados de todos los certificados de la póliza
         FOR y IN cCobertActAseg LOOP
             OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, y.IDetPol, y.Cod_Asegurado);
         END LOOP;
         --
         --Actualizo Valores de todos los certificados de la póliza
         FOR x IN cCobertActAseg_2 LOOP
             SELECT IndSinAseg
             INTO   cIndSinAseg
             FROM   DETALLE_POLIZA
             WHERE  CodCia     = nCodCia
               AND  CodEmpresa = nCodEmpresa
               AND  IdPoliza   = nIdPoliza
               AND  IDetPol    = x.IDetPol;
             --
             IF NVL(cIndSinAseg,'N') = 'N' OR NVL(x.IdEndoso,0) = 0 THEN
                OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, x.IDetPol, 0);
             ELSIF NVL(nIdEndoso,0) != 0 THEN
                OC_ENDOSO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, x.IDetPol, x.IdEndoso);
             END IF;
         END LOOP;
         --
         --Actualizo Valores de la póliza
         OC_POLIZAS.ACTUALIZA_VALORES(nCodCia, nIdPoliza, 0);
      END IF;
   EXCEPTION
   WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20205, 'ERROR EN THONAPI.FLUJO_EMISION_SIGO.CARGA_ASEGURADOS: ' || SQLERRM);
   END CARGAR_ASEGURADOS;
   --
   FUNCTION INSERTAR_ASEGURADOS( nCodCia           ASEGURADOS_SIGO_TMP.CodCia%TYPE
                               , nCodEmpresa       ASEGURADOS_SIGO_TMP.CodEmpresa%TYPE
                               , nIdPoliza         ASEGURADOS_SIGO_TMP.IdPoliza%TYPE
                               , nIDetPol          ASEGURADOS_SIGO_TMP.IDetPol%TYPE
                               , cNombre           ASEGURADOS_SIGO_TMP.Nombre%TYPE
                               , cApellidoPaterno  ASEGURADOS_SIGO_TMP.ApellidoPaterno%TYPE
                               , cApellidoMaterno  ASEGURADOS_SIGO_TMP.ApellidoMaterno%TYPE
                               , cGenero           ASEGURADOS_SIGO_TMP.Genero%TYPE
                               , dFecNacimiento    ASEGURADOS_SIGO_TMP.FecNacimiento%TYPE
                               , nSalarioMensual   ASEGURADOS_SIGO_TMP.SalarioMensual%TYPE
                               , nVecesSalario     ASEGURADOS_SIGO_TMP.VecesSalario%TYPE
                               , nSumAsegFija      ASEGURADOS_SIGO_TMP.SumAsegFija%TYPE
                               , cRFC              ASEGURADOS_SIGO_TMP.RFC%TYPE ) RETURN NUMBER IS
      nIdAseg  ASEGURADOS_SIGO_TMP.IdAseg%TYPE;
   BEGIN
      SELECT NVL(MAX(IdAseg), 0) + 1
      INTO   nIdAseg
      FROM   ASEGURADOS_SIGO_TMP
      WHERE  CodCia     = nCodCia
        AND  CodEmpresa = nCodEmpresa
        AND  IdPoliza   = nIdPoliza
        AND  IDetPol    = nIDetPol;
      --
      INSERT INTO ASEGURADOS_SIGO_TMP
             ( CodCia          , CodEmpresa , IdPoliza      , IDetPol        , IdAseg       , Nombre      , ApellidoPaterno ,
               ApellidoMaterno , Genero     , FecNacimiento , SalarioMensual , VecesSalario , SumAsegFija , RFC )
      VALUES ( nCodCia         , nCodEmpresa, nIdPoliza     , nIDetPol       , nIdAseg      , cNombre     , cApellidoPaterno,
               cApellidoMaterno, cGenero    , dFecNacimiento, nSalarioMensual, nVecesSalario, nSumAsegFija, cRFC );
      RETURN nIdAseg;
   EXCEPTION
   WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20205, 'ERROR EN THONAPI.FLUJO_EMISION_SIGO.INSERTAR_ASEGURADOS: ' || SQLERRM);
   END INSERTAR_ASEGURADOS;
   --
   FUNCTION ELIMINAR_ASEGURADOS( nCodCia      ASEGURADOS_SIGO_TMP.CodCia%TYPE
                               , nCodEmpresa  ASEGURADOS_SIGO_TMP.CodEmpresa%TYPE
                               , nIdPoliza    ASEGURADOS_SIGO_TMP.IdPoliza%TYPE
                               , nIDetPol     ASEGURADOS_SIGO_TMP.IDetPol%TYPE ) RETURN NUMBER IS
      nContAseg  NUMBER;
   BEGIN
      SELECT COUNT(IdAseg)
      INTO   nContAseg
      FROM   ASEGURADOS_SIGO_TMP
      WHERE  CodCia     = nCodCia
        AND  CodEmpresa = nCodEmpresa
        AND  IdPoliza   = nIdPoliza
        AND  IDetPol    = nIDetPol;
      --
      DELETE ASEGURADOS_SIGO_TMP
      WHERE  CodCia     = nCodCia
        AND  CodEmpresa = nCodEmpresa
        AND  IdPoliza   = nIdPoliza
        AND  IDetPol    = nIDetPol;
      --
      RETURN nContAseg;
   EXCEPTION
   WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20205, 'ERROR EN THONAPI.FLUJO_EMISION_SIGO.INSERTAR_ASEGURADOS: ' || SQLERRM);
   END ELIMINAR_ASEGURADOS;
   --
   FUNCTION PRE_EMITE_POLIZA( nCodCia           POLIZAS.CODCIA%TYPE
                            , nCodEmpresa       POLIZAS.CODEMPRESA%TYPE
                            , nIdPoliza         POLIZAS.IDPOLIZA%TYPE
                            , cIndRequierePago  VARCHAR2 ) RETURN CLOB IS
      cFacturas      CLOB;
      nIdTransaccion TRANSACCION.IDTRANSACCION%TYPE;
      --
      CURSOR cTransaccion IS
             SELECT IdTransaccion
             FROM   DETALLE_TRANSACCION
             WHERE  CodCia        = nCodCia
               AND  CodEmpresa    = nCodEmpresa
               AND  CodSubProceso = 'POL'
               AND  Objeto        ='POLIZAS'
               AND  Valor1        = nIdPoliza;
   BEGIN
      OC_POLIZAS.EMITIR_POLIZA(nCodCia, nIdPoliza, nCodEmpresa);
      --
      OPEN  cTransaccion;
      FETCH cTransaccion INTO nIdTransaccion;
      CLOSE cTransaccion;                       
      --
      IF cIndRequierePago = 'S' THEN
         OC_POLIZAS.PRE_EMITE_POLIZA(nCodCia, nCodEmpresa, nIdPoliza, nIdTransaccion);
      END IF;
      --
      cFacturas := CONSULTAR_FACTURAS(nCodCia, nIdPoliza);       
      --      
      RETURN cFacturas;
   END PRE_EMITE_POLIZA;
   --
   FUNCTION CONSULTAR_FACTURAS( nCodCia    FACTURAS.CodCia%TYPE
                              , nIdPoliza  FACTURAS.IdPoliza%TYPE ) RETURN CLOB IS
      CURSOR c_Facturas IS
             SELECT F.IdPoliza
                  , F.IDetPol
                  , IdFactura
                  , StsFact
                  , F.FecAnul
                  , FecPago
                  , FecVenc
                  , NumCuota
                  , Cod_Moneda
                  , Monto_Fact_Moneda
                  , OC_DETALLE_POLIZA.MONTO_APORTE_FONDOS(F.CodCia, 1, F.IdPoliza,  F.IDetPol) AporteFondo
                  , GT_FAI_CONFIG_APORTE_FONDO_DET.MONTO_APORTE_ESPECIFICO(F.CodCia, 1, F.IdPoliza, F.IDetPol, D.Cod_Asegurado, GT_FAI_FONDOS_DETALLE_POLIZA.FONDO_PAGO_PRIMA(F.CodCia, 1, F.IdPoliza, F.IDetPol, D.Cod_Asegurado), F.NumCuota)  PrimaNivelada
                  , GT_FAI_CONFIG_APORTE_FONDO_DET.MONTO_APORTE_ESPECIFICO(F.CodCia, 1, F.IdPoliza, F.IDetPol, D.Cod_Asegurado, GT_FAI_FONDOS_DETALLE_POLIZA.FONDO_PAGO_PRIMA(F.CodCia, 1, F.IdPoliza, F.IDetPol, D.Cod_Asegurado), F.NumCuota) + OC_DETALLE_POLIZA.MONTO_APORTE_FONDOS(F.CodCia, 1, F.IdPoliza,  F.IDetPol) + Monto_Fact_Moneda  MontoTotal
                  , SICAS_OC.OBTIENE_REFERENCIA(F.IdPoliza, F.IdFactura) NumRef
                  , IdEndoso
                  , D.CodEmpresa                            
             FROM   FACTURAS        F
                ,   DETALLE_POLIZA  D
             WHERE  D.CodCia   = F.CodCia
               AND  D.IdPoliza = F.IdPoliza
               AND  D.IDetPol  = F.IDetPol 
               AND  F.CODCIA   = nCodCia               
               AND F.IdPoliza  = nIdPoliza
               ORDER BY IdFactura;                    
      --
      CURSOR c_DetalleFact ( p_IdFactura  NUMBER ) IS
             SELECT Concepto
                  , Descripcion
                  , Monto_Local
                  , Monto_Moneda                                  
             FROM ( SELECT DECODE(C.IndCptoPrimas, 'S', 'PRIMNET', F.CodCpto)             Concepto
                         , DECODE(C.IndCptoPrimas, 'S', 'PRIMA NETA', C.DescripConcepto)  Descripcion
                         , SUM(F.Monto_Det_Local)                                         Monto_Local
                         , SUM(F.Monto_Det_Moneda)                                        Monto_Moneda
                    FROM   DETALLE_FACTURAS       F
                       ,   CATALOGO_DE_CONCEPTOS  C
                    WHERE  C.CodCia      = nCodCia
                      AND  C.CodConcepto = F.CodCpto
                      AND  F.IdFactura   = p_IdFactura
                    GROUP BY DECODE(C.IndCptoPrimas, 'S', 'PRIMNET', F.CodCpto), DECODE(C.IndCptoPrimas, 'S', 'PRIMA NETA', C.DescripConcepto) )         
             ORDER BY DECODE(Descripcion, 'PRIMA NETA', 1,  ROWNUM + 1);  
      --
      CURSOR c_FactElec ( p_CodCia NUMBER, p_CodEmpresa NUMBER, p_IdFactura NUMBER ) IS
             SELECT IdTimbre
                  , CodProceso
                  , FechaUUID
                  , Serie
                  , CodRespuestaSAT
                  , StsTimbre
                  , UUID
             FROM   FACT_ELECT_DETALLE_TIMBRE
             WHERE  CodCia = p_CodCia
               AND  CodEmpresa = p_CodEmpresa
               AND  IdFactura = p_IdFactura
               AND  CodRespuestaSAT IN ('201','2001')
               AND  OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_UUID_CANCELADO(CodCia, CodEmpresa, IdFactura, IdNCR, UUID) = 'N'
             ORDER BY IdTimbre;
      --
      r_facturas     c_Facturas%ROWTYPE;              
      r_DetalleFact  c_DetalleFact%ROWTYPE;
      r_FactElec     c_FactElec%ROWTYPE;              
      cResultado     CLOB;
    BEGIN
       cResultado := '{' || CHR(13) ||	'  "FACTURAS": {' || CHR(13) ||	'    "FACTURA": [' || CHR(13);
       --
       OPEN c_Facturas;
       LOOP
          FETCH c_Facturas INTO   r_Facturas;   
          EXIT WHEN c_Facturas%NOTFOUND;
          --
          cResultado := cResultado || '      { "IDPOLIZA": "'          || r_Facturas.IdPoliza                       || '",' || CHR(13);
          cResultado := cResultado || '        "IDETPOL": "'           || r_Facturas.IDetPol                        || '",' || CHR(13);
          cResultado := cResultado || '        "IDFACTURA": "'         || r_Facturas.IdFactura                      || '",' || CHR(13);
          cResultado := cResultado || '        "STSFACT": "'           || r_Facturas.StsFact                        || '",' || CHR(13);
          cResultado := cResultado || '        "FECPAGO": "'           || TO_CHAR(r_Facturas.FecPago, 'YYYY-MM-DD') || '",' || CHR(13);
          cResultado := cResultado || '        "FECVENC": "'           || TO_CHAR(r_Facturas.FecVenc, 'YYYY-MM-DD') || '",' || CHR(13);
          cResultado := cResultado || '        "NUMCUOTA": "'          || r_Facturas.NumCuota                       || '",' || CHR(13);
          cResultado := cResultado || '        "COD_MONEDA": "'        || r_Facturas.Cod_Moneda                     || '",' || CHR(13);
          cResultado := cResultado || '        "MONTO_FACT_MONEDA": "' || r_Facturas.Monto_Fact_Moneda              || '",' || CHR(13);
          cResultado := cResultado || '        "APORTEFONDO": "'       || r_Facturas.AporteFondo                    || '",' || CHR(13);
          cResultado := cResultado || '        "PRIMANIVELADA": "'     || r_Facturas.PrimaNivelada                  || '",' || CHR(13);
          cResultado := cResultado || '        "MONTOTOTAL": "'        || r_Facturas.MontoTotal                     || '",' || CHR(13);
          cResultado := cResultado || '        "NUMREF": "'            || r_Facturas.NumRef                         || '",' || CHR(13);
          cResultado := cResultado || '        "IDENDOSO": "'          || r_Facturas.IdEndoso                       || '",' || CHR(13);
          cResultado := cResultado || '        "DETALLE": [' || CHR(13);
          --
          OPEN c_DetalleFact(r_facturas.IDFACTURA);
          LOOP                                
             FETCH c_DetalleFact INTO r_DetalleFact;   
             EXIT WHEN c_DetalleFact%NOTFOUND;
             --
             cResultado := cResultado || '          { "CODCPTO": "'      || r_DetalleFact.Concepto     || '",' || CHR(13);
             cResultado := cResultado || '            "DESCRIPCION": "'  || r_DetalleFact.Descripcion  || '",' || CHR(13);
             cResultado := cResultado || '            "MONTO_LOCAL": "'  || r_DetalleFact.Monto_Local  || '",' || CHR(13);
             cResultado := cResultado || '            "MONTO_MONEDA": "' || r_DetalleFact.Monto_Moneda || '" },' || CHR(13);
          END LOOP;
          CLOSE c_DetalleFact;
          --
          cResultado := SUBSTR(cResultado, 1, LENGTH(cResultado) - 2) || ' ],' || CHR(13);
          cResultado := cResultado || '        "CFDI": [' || CHR(13);
          --
          OPEN c_FactElec (nCodCia, r_facturas.CodEmpresa, r_Facturas.IdFactura);
          LOOP                                
             FETCH c_FactElec INTO r_FactElec;   
             EXIT WHEN c_FactElec%NOTFOUND;
             --
             cResultado := cResultado || '          { "_IDTIMBRE": "'       || r_FactElec.IdTimbre                         || '",' || CHR(13);
             cResultado := cResultado || '            "CODPROCESO": "'      || r_FactElec.CodProceso                       || '",' || CHR(13);
             cResultado := cResultado || '            "FECHAUUID": "'       || TO_CHAR(r_FactElec.FechaUUID, 'YYYY-MM-DD') || '",' || CHR(13);
             cResultado := cResultado || '            "SERIE": "'           || r_FactElec.Serie                            || '",' || CHR(13);
             cResultado := cResultado || '            "CODRESPUESTASAT": "' || r_FactElec.CodRespuestaSAT                  || '",' || CHR(13);
             cResultado := cResultado || '            "STSTIMBRE": "'       || r_FactElec.StsTimbre                        || '",' || CHR(13);
             cResultado := cResultado || '            "UUID": "'            || r_FactElec.UUID                             || '" },' || CHR(13);
          END LOOP;
          CLOSE c_FactElec;
          --
          cResultado := SUBSTR(cResultado, 1, LENGTH(cResultado) - 2) || ' ]' || CHR(13) || '      },' || CHR(13);
       END LOOP;               
       CLOSE c_Facturas;   
       --
       cResultado := SUBSTR(cResultado, 1, LENGTH(cResultado) - 2) || CHR(13) || '    ]' || CHR(13) || '  }' || CHR(13) || '}';
       RETURN(cResultado);
    END CONSULTAR_FACTURAS;
    
PROCEDURE CARGAR_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                            cPlanCob VARCHAR2, nIdPoliza NUMBER, nIDetPol NUMBER,
                            nTasaCambio NUMBER, nCod_Asegurado NUMBER, cCodCobert VARCHAR2,
                            nSumaAsegManual NUMBER, nSalarioMensual NUMBER, nVecesSalario NUMBER,
                            nEdad_Minima NUMBER, nEdad_Maxima NUMBER, nEdad_Exclusion NUMBER,
                            nSumaAseg_Minima NUMBER, nSumaAseg_Maxima NUMBER, nPorcExtraPrima NUMBER,
                            nMontoExtraPrima NUMBER, nSumaIngresada NUMBER,nFranquiciaingresado NUMBER, 
                            nMontoDiario NUMBER, nDias_Cal NUMBER) IS
nCod_Moneda             POLIZAS.Cod_Moneda%TYPE;
nTasaCambioDet          DETALLE_POLIZA.Tasa_Cambio%TYPE;
dFecEmision             POLIZAS.FecEmision%TYPE ;
nSumaAsegMoneda         DETALLE_POLIZA.Suma_Aseg_Moneda%TYPE;
nSumaAsegLocal          DETALLE_POLIZA.Suma_Aseg_Local%TYPE;
dFecIniVig              POLIZAS.FecIniVig%TYPE;
dFecFinVig              POLIZAS.FecFinVig%TYPE;
cSexo                   PERSONA_NATURAL_JURIDICA.Sexo%TYPE;
cRiesgo                 ACTIVIDADES_ECONOMICAS.RiesgoActividad%TYPE;
cCodActividad           PERSONA_NATURAL_JURIDICA.CodActividad%TYPE;
nIdTarifa               TARIFA_CONTROL_VIGENCIAS.IdTarifa%TYPE;
nEdad                   NUMBER(5);
nEdadEmision            NUMBER(5);
nExiste                 NUMBER;
nExisteAgen             NUMBER;
nTasa                   NUMBER;
nTasaNivelada           NUMBER;
nValor                  NUMBER;
nValorMoneda            NUMBER;
nPrimaNivLocal          NUMBER := 0;
nPrimaNivMoneda         NUMBER := 0;
cTipoProceso            CONFIG_PLANTILLAS_PLANCOB.TipoProceso%TYPE;
nIdEndoso               ASEGURADO_CERTIFICADO.IdEndoso%TYPE;
cTarifaDinamica         VARCHAR2(1) := 'N';
nPorcDescuento          POLIZAS.PorcDescuento%TYPE;
nPorcGtoAdmin           POLIZAS.PorcGtoAdmin%TYPE;
nPorcGtoAdqui           POLIZAS.PorcGtoAdqui%TYPE;
nPorcUtilidad           POLIZAS.PorcUtilidad%TYPE;
nFactorAjuste           POLIZAS.FactorAjuste%TYPE;
nMontoDeducible         POLIZAS.MontoDeducible%TYPE;
nFactFormulaDeduc       POLIZAS.FactFormulaDeduc%TYPE;
nHorasVig               POLIZAS.HorasVig%TYPE;
nDiasVig                POLIZAS.DiasVig%TYPE;
nEdad_MinimaCob         COBERTURAS_DE_SEGUROS.Edad_Minima%TYPE;
nEdad_MaximaCob         COBERTURAS_DE_SEGUROS.Edad_Maxima%TYPE;
nEdad_ExclusionCob      COBERTURAS_DE_SEGUROS.Edad_Exclusion%TYPE;
nSumaAseg_MinimaCob     COBERTURAS_DE_SEGUROS.SumaAsegMinima%TYPE;
nSumaAseg_MaximaCob     COBERTURAS_DE_SEGUROS.SumaAsegMaxima%TYPE;
cTipoSeg                TIPOS_DE_SEGUROS.TipoSeg%TYPE;
nDeducibleCobLocal      COBERT_ACT_ASEG.Deducible_Local%TYPE;
nDeducibleCobMoneda     COBERT_ACT_ASEG.Deducible_Moneda%TYPE;
nNumRenov               POLIZAS.NumRenov%TYPE;
cStsCobertura           COBERT_ACT.StsCobertura%TYPE;
nIdPolizaEmision        POLIZAS.IdPoliza%TYPE;
dFecIniVigEmision       POLIZAS.FecIniVig%TYPE;
nPorcGtoAdminTar        TARIFA_SEXO_EDAD_RIESGO.PorcGtoAdmin%TYPE;

CURSOR COB_Q IS
   SELECT CodCobert, Porc_Tasa, TipoTasa, Prima_Cobert,
          SumaAsegurada, Cod_Moneda, CodTarifa, Edad_Minima,
          Edad_Maxima, Edad_Exclusion, MontoDeducible, PorcenDeducible,
          SumaAsegMinima, SumaAsegMaxima,
          DECODE(TipoTasa,'C',100,DECODE(TipoTasa,'M',1000,1)) FactorTasa,
          NVL(IDRAMOREAL, OC_COBERTURAS_DE_SEGUROS.COBERTURA_IDRAMOREAL(CodCia, CODEMPRESA, IdTipoSeg, PlanCob, CodCobert)) IDRAMOREAL
     FROM COBERTURAS_DE_SEGUROS
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdTipoSeg     = cIdTipoSeg
      AND PlanCob       = cPlanCob
      AND Edad_Minima  <= nEdad
      AND Edad_Maxima  >= nEdad
      AND CodCobert     = NVL(cCodCobert, CodCobert)
      AND StsCobertura  = 'ACT';
BEGIN
   IF NVL(nTasaCambio,0) = 0 THEN
      RAISE_APPLICATION_ERROR(-20225,'No Existe Tasa de Cambio para Generar Coberturas');
   END IF;
   BEGIN
      SELECT 1
        INTO nExiste
        FROM COBERT_ACT_ASEG
       WHERE CodCia            = nCodCia
         AND IdPoliza          = nIdPoliza
         AND IdetPol           = nIDetPol
         AND StsCobertura NOT IN ('SOL','XRE')
         AND Cod_Asegurado     = nCod_Asegurado
         AND CodCobert         = NVL(cCodCobert, CodCobert);
   EXCEPTION
       WHEN NO_DATA_FOUND THEN
          nExiste := 0;
       WHEN TOO_MANY_ROWS THEN
          nExiste := 1;
   END;

   IF nExiste = 0 THEN
      DELETE COBERT_ACT_ASEG
       WHERE CodCia         = nCodCia
         AND IdPoliza       = nIdPoliza
         AND IdetPol        = nIDetPol
         AND StsCobertura  IN ('SOL','XRE')
         AND Cod_Asegurado  = nCod_Asegurado
         AND CodCobert      = NVL(cCodCobert, CodCobert);

      BEGIN
         SELECT P.Cod_Moneda, TRUNC(P.FecEmision), TRUNC(P.FecIniVig), TRUNC(P.FecFinVig),
                HorasVig, DiasVig, PorcDescuento, PorcGtoAdmin, PorcGtoAdqui,
                PorcUtilidad, FactorAjuste, MontoDeducible, FactFormulaDeduc, NumRenov
           INTO nCod_Moneda, dFecEmision, dFecIniVig, dFecFinVig, nHorasVig, nDiasVig,
                nPorcDescuento, nPorcGtoAdmin, nPorcGtoAdqui, nPorcUtilidad,
                nFactorAjuste, nMontoDeducible, nFactFormulaDeduc, nNumRenov
           FROM POLIZAS P
          WHERE P.CodCia    = nCodCia
            AND P.IdPoliza  = nIdPoliza;
      END;

      nEdad         := OC_ASEGURADO.EDAD_ASEGURADO(nCodCia, nCodEmpresa, nCod_Asegurado, dFecIniVig);
      nIdTarifa     := GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, dFecIniVig);

      IF nNumRenov = 0 THEN
         cStsCobertura     := 'SOL';
         nEdadEmision      := nEdad;
      ELSE
         cStsCobertura     := 'XRE';
         nIdPolizaEmision  := OC_POLIZAS.POLIZA_INICIAL_RENOVACION(nCodCia, nCodEmpresa, nIdPoliza);
         dFecIniVigEmision := OC_POLIZAS.INICIO_VIGENCIA(nCodCia, nCodEmpresa, nIdPolizaEmision);
         nEdadEmision      := OC_ASEGURADO.EDAD_ASEGURADO(nCodCia, nCodEmpresa, nCod_Asegurado, dFecIniVigEmision);
      END IF;

      FOR X IN COB_Q  LOOP
         nPrimaNivLocal     := 0;
         nPrimaNivMoneda    := 0;

         BEGIN
            SELECT TipoSeg
              INTO cTipoSeg
              FROM TIPOS_DE_SEGUROS
             WHERE CodCia    = nCodCia
               AND CodEmpresa = nCodEmpresa
               AND IdTipoSeg = cIdTipoSeg;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cTipoSeg := 'N';
         END;

         IF (nEdad BETWEEN X.Edad_Minima AND X.Edad_Maxima AND nEdad_Minima = X.Edad_Minima AND nEdad_Maxima = X.Edad_Maxima) OR
             NVL(cTipoSeg,'N') != 'P' OR
            (nEdad BETWEEN nEdad_Minima AND nEdad_Maxima AND (nEdad_Minima != X.Edad_Minima OR nEdad_Maxima != X.Edad_Maxima)) THEN
            nEdad_MinimaCob     := NVL(nEdad_Minima,0);
            nEdad_MaximaCob     := NVL(nEdad_Maxima,0);
            nEdad_ExclusionCob  := NVL(nEdad_Exclusion,0);
            nSumaAseg_MinimaCob := NVL(nSumaAseg_Minima,0);
            nSumaAseg_MaximaCob := NVL(nSumaAseg_Maxima,0);

            IF cCodCobert IS NULL THEN
               IF NVL(nEdad_MinimaCob,0) = 0 THEN
                  nEdad_MinimaCob := X.Edad_Minima;
               END IF;
               IF NVL(nEdad_MaximaCob,0) = 0 THEN
                  nEdad_MaximaCob := X.Edad_Maxima;
               END IF;
               IF NVL(nEdad_ExclusionCob,0) = 0 THEN
                  nEdad_ExclusionCob := X.Edad_Exclusion;
               END IF;
               IF NVL(nSumaAseg_MinimaCob,0) = 0 THEN
                  nSumaAseg_MinimaCob := X.SumaAsegMinima;
               END IF;
               IF NVL(nSumaAseg_MaximaCob,0) = 0 THEN
                  nSumaAseg_MaximaCob := X.SumaAsegMaxima;
               END IF;
            END IF;

            IF X.CodTarifa IS NULL THEN
               cTarifaDinamica := 'N'; -- EC - 20/01/2017
               nSumaAsegMoneda := 0;
               nSumaAsegLocal  := 0;
               IF X.TipoTasa = 'C' THEN
                  nTasa := X.Porc_Tasa/ X.FactorTasa;
               ELSIF X.TipoTasa = 'M' THEN
                  nTasa := X.Porc_Tasa/ X.FactorTasa;
               ELSE
                  nTasa := X.Porc_Tasa;
               END IF;
               IF NVL(nTasa,0) =  0 THEN
                  nValorMoneda := X.Prima_Cobert;
                  nValor       := X.Prima_Cobert * nTasaCambio;
                  IF NVL(X.SumaAsegurada,0) != 0 THEN
                     nTasa        := NVL(nValorMoneda,0) / NVL(X.SumaAsegurada,0);
                  END IF;
               ELSE
                  nValorMoneda := NVL(X.SumaAsegurada,0) * NVL(nTasa,0);
                  nValor       := (NVL(X.SumaAsegurada,0) * NVL(nTasa,0)) * nTasaCambio;
               END IF;
               nSumaAsegMoneda := NVL(X.SumaAsegurada,0);
               nSumaAsegLocal  := NVL(X.SumaAsegurada,0) * nTasaCambio;
            ELSE
               IF OC_TARIFA_DINAMICA.TARIFA_VIGENTE(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, dFecEmision) = 0 THEN
                  IF nIdTarifa = 0 THEN
                     RAISE_APPLICATION_ERROR(-20225,'NO Existe Tarifa Vigente por Sexo, Edad y Riesgo para el Tipo de Seguro ' || cIdTipoSeg ||
                                             ' Plan de Coberturas ' || cPlanCob || ' y Fecha de Inicio de Vigencia de la Póliza ' ||
                                             TO_CHAR(dFecIniVig,'DD/MM/RRRR'));
                  END IF;

                  IF X.CodTarifa IN ('EDADYSEXO','SEXOEDAD') THEN
                     BEGIN
                        SELECT D.FecIniVig
                          INTO dFecIniVig
                          FROM DETALLE_POLIZA D
                         WHERE D.IdPoliza       = nIdPoliza
                           AND D.IdetPol        = nIDetPol;
                     EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                           RAISE_APPLICATION_ERROR(-20225,'No Existe Detalle de Póliza para Generar Coberturas');
                     END;
                     cTarifaDinamica := 'N'; -- EC - 20/01/2017
                     cSexo           := OC_ASEGURADO.SEXO_ASEGURADO(nCodCia, nCodEmpresa, nCod_Asegurado);
                     cCodActividad   := OC_ASEGURADO.ACTIVIDAD_ECONOMICA_ASEG(nCodCia, nCodEmpresa, nCod_Asegurado);
                     cRiesgo         := OC_ACTIVIDADES_ECONOMICAS.RIESGO_ACTIVIDAD(cCodActividad);
                     nSumaAsegMoneda := OC_TARIFA_SEXO_EDAD_RIESGO.SUMA_ASEGURADA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                  X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL);
                     nTasa           := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                               X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL);
                     IF NVL(nSumaAsegMoneda,0) = 0 THEN
                        IF NVL(nSumaAsegManual,0) != 0 THEN
                           nSumaAsegMoneda := NVL(nSumaAsegManual,0);
                        ELSE
                           nSumaAsegMoneda := NVL(X.SumaAsegurada,0);
                        END IF;
                     END IF;

                     IF (NVL(nSumaAsegManual,0) != 0 AND  cIdTipoSeg != 'GMINDC') THEN
                        nValorMoneda    := OC_TARIFA_SEXO_EDAD_RIESGO.PRIMA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                   X.CodCobert, nEdad, cSexo, cRiesgo, 0, nIdTarifa, NULL);
                     ELSE
                        nValorMoneda    := OC_TARIFA_SEXO_EDAD_RIESGO.PRIMA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                   X.CodCobert, nEdad, cSexo, cRiesgo, nSumaAsegMoneda, nIdTarifa, NULL);
                     END IF;

                     IF NVL(nValorMoneda,0) = 0 AND NVL(nTasa,0) != 0 THEN
                        nValorMoneda := nSumaAsegMoneda * NVL(nTasa,0);
                     END IF;
                     nValor          := NVL(nValorMoneda,0) * nTasaCambio;
                     IF NVL(nSumaAsegMoneda,0) != 0 AND NVL(nTasa,0) = 0 THEN
                        nTasa           := NVL(nValorMoneda,0) / NVL(nSumaAsegMoneda,0);
                     END IF;
                  ELSE
                     cTarifaDinamica   := 'N';
                     cCodActividad     := NULL; --OC_ASEGURADO.ACTIVIDAD_ECONOMICA_ASEG(nCodCia, nCodEmpresa, nCod_Asegurado);
                     cRiesgo           := 'NA'; --OC_ACTIVIDADES_ECONOMICAS.RIESGO_ACTIVIDAD(cCodActividad);
                     --nPorcExtraPrima   := OC_PLAN_COBERTURAS.PORCENTAJE_EXTRAPRIMA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob);
                     --nMontoExtraPrima  := OC_PLAN_COBERTURAS.MONTO_EXTRAPRIMA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob);

                     nSumaAsegMoneda := OC_TARIFA_SEXO_EDAD_RIESGO.SUMA_ASEGURADA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                  X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL);

                     IF NVL(nSumaAsegMoneda,0) = 0 THEN
                        IF NVL(nSumaAsegManual,0) != 0 THEN
                           nSumaAsegMoneda := NVL(nSumaAsegManual,0);
                        ELSE
                           nSumaAsegMoneda := NVL(X.SumaAsegurada,0);
                        END IF;
                     END IF;

                     nTasa            := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                X.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL);
                     nTasaNivelada    := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_NIVELADA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                  X.CodCobert, nEdadEmision, cSexo, cRiesgo, nIdTarifa, NULL);
                     nPorcGtoAdminTar := OC_TARIFA_SEXO_EDAD_RIESGO.PORCEN_GASTOS_ADMIN(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                        X.CodCobert, nEdadEmision, cSexo, cRiesgo, nIdTarifa, NULL);

                     IF NVL(nTasa,0) > 0 THEN
                        nTasa := NVL(nTasa,0) * (1 - (NVL(nPorcDescuento,0) / 100));

                        nTasa := NVL(nTasa,0) * (1 + (NVL(nPorcExtraPrima,0) / 100));

                        nTasa := NVL(nTasa,0) + NVL(nMontoExtraPrima,0);

                        --IF NVL(nFactorAjuste,0) > 0 THEN
                        nTasa := NVL(nTasa,0) * NVL(nFactorAjuste,0);
                        --END IF;

                        -- Factor Deducible ??
                        nTasa := (1-(NVL(nFactFormulaDeduc,0) * NVL(nMontoDeducible,0))) * NVL(nTasa,0);

                        IF NVL(nHorasVig,0) > 0 THEN
                           nTasa := NVL(nTasa,0) * (NVL(nHorasVig,0) / 24);
                        END IF;

                        IF NVL(nDiasVig,0) > 0 THEN
                           nTasa := NVL(nTasa,0) * (NVL(nDiasVig,0) / 365);
                        END IF;

                        --IF cTipoProrrata = 'D365' THEN
                           --nTasa := (NVL(nTasa,0) / 365) * (dFecFinVig - dFecIniVig);
                        --END IF;

                        --IF NVL(nDiasVig,0) > 0 THEN
                           --nTasa := NVL(nTasa,0) * (NVL(nDiasVig,0) / OC_GENERALES.DIAS_ANIO(dFecIniVig, dFecFinVig));
                        --END IF;

                        nTasa := NVL(nTasa,0) / (1 - (NVL(nPorcGtoAdqui,0) / 100) - (NVL(nPorcUtilidad,0) / 100) -
                                 (NVL(nPorcGtoAdmin,0) / 100) -  (NVL(nPorcGtoAdminTar,0) / 100));
                     END IF;

                     IF NVL(nTasaNivelada,0) > 0 THEN
                        nTasaNivelada := (NVL(nTasaNivelada,0) + (NVL(nMontoExtraPrima,0) /
                                         (1 - (NVL(nPorcGtoAdqui,0) / 100) - (NVL(nPorcUtilidad,0) / 100) - (NVL(nPorcGtoAdmin,0) / 100) -
                                         (NVL(nPorcGtoAdminTar,0) / 100)))) * (1 + (NVL(nPorcExtraPrima,0) / 100));
                     END IF;

                     IF NVL(nSumaAsegMoneda,0) = 0 THEN
                        nSumaAsegMoneda  := NVL(X.SumaAsegurada,0);
                     END IF;

                     nValorMoneda    := OC_TARIFA_SEXO_EDAD_RIESGO.PRIMA_TARIFA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
                                                                                X.CodCobert, nEdad, cSexo, cRiesgo, 0, nIdTarifa, NULL); --nSumaAsegMoneda);
                     IF NVL(nValorMoneda,0) = 0 AND NVL(nTasa,0) != 0 THEN
                        nValorMoneda := NVL(nSumaAsegMoneda,0) * NVL(nTasa,0) / X.FactorTasa;
                     END IF;
                     nValor    := NVL(nValorMoneda,0) * nTasaCambio;
                     IF NVL(nSumaAsegMoneda,0) != 0 AND NVL(nTasa,0) = 0 THEN
                        nTasa        := NVL(nValorMoneda,0) / NVL(nSumaAsegMoneda,0);
                     END IF;

                     nPrimaNivMoneda := NVL(nSumaAsegMoneda,0) * NVL(nTasaNivelada,0) / X.FactorTasa;
                     nPrimaNivMoneda := NVL(nPrimaNivMoneda,0) - NVL(nValorMoneda,0);
                     nPrimaNivLocal  := NVL(nPrimaNivMoneda,0) * nTasaCambio;
                  END IF;
               ELSE
                  cTipoProceso := OC_CONFIG_PLANTILLAS_PLANCOB.TIPO_PROCESO(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, 'ASEDET');

                  IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(nCodCia, nIdPoliza, nIDetPol, nCod_Asegurado) = 'S' THEN
                     cTarifaDinamica := 'S'; -- EC - 20/01/2017
                     nSumaAsegMoneda := OC_TARIFA_DINAMICA_DET.CALCULAR_TARIFA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, cIdTipoSeg,
                                                                               cPlanCob, X.CodCobert, 'S', dFecEmision, nCod_Asegurado,
                                                                               cTipoProceso);
                     nValorMoneda    := OC_TARIFA_DINAMICA_DET.CALCULAR_TARIFA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, cIdTipoSeg,
                                                                               cPlanCob, X.CodCobert, 'P', dFecEmision, nCod_Asegurado,
                                                                               cTipoProceso);
                     nTasa           := OC_TARIFA_DINAMICA_DET.CALCULAR_TARIFA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, cIdTipoSeg,
                                                                               cPlanCob, X.CodCobert, 'T', dFecEmision, nCod_Asegurado,
                                                                               cTipoProceso);

                     IF NVL(nSumaAsegMoneda,0) = 0 THEN
                        nSumaAsegMoneda := X.SumaAsegurada;
                     END IF;
                     IF NVL(nValorMoneda,0) = 0 THEN
                        nValorMoneda    := X.Prima_Cobert;
                     END IF;
                     IF NVL(nTasa,0) = 0 THEN
                        IF X.TipoTasa = 'C' THEN
                           nTasa := X.Porc_Tasa/ X.FactorTasa;
                        ELSIF X.TipoTasa = 'M' THEN
                           nTasa := X.Porc_Tasa/ X.FactorTasa;
                        ELSE
                           nTasa := X.Porc_Tasa;
                        END IF;
                     ELSE
                        IF X.TipoTasa = 'C' THEN
                           nTasa := nTasa/ X.FactorTasa;
                        ELSIF X.TipoTasa = 'M' THEN
                           nTasa := nTasa/ X.FactorTasa;
                        END IF;
                     END IF;
                     IF nTasa != 0 AND nValorMoneda = 0 THEN
                        nValorMoneda := nSumaAsegMoneda * nTasa;
                     ELSIF nTasa = 0 AND nSumaAsegMoneda != 0 THEN
                        nTasa  := NVL(nValorMoneda,0) / nSumaAsegMoneda;
                     END IF;
                     nValor    := NVL(nValorMoneda,0) * nTasaCambio;
                  END IF;
               END IF;
            END IF;
            IF X.Cod_Moneda != nCod_Moneda THEN
               nTasaCambioDet  := OC_GENERALES.TASA_DE_CAMBIO(nCod_Moneda, dFecEmision);
               nSumaAsegMoneda := NVL(nSumaAsegMoneda,0) / nTasaCambioDet;
               nSumaAsegLocal  := NVL(nSumaAsegMoneda,0) * nTasaCambioDet;
               nValorMoneda    := NVL(nValorMoneda,0) / nTasaCambioDet;
               nValor          := NVL(nValorMoneda,0) * nTasaCambioDet;
            ELSE
               nSumaAsegLocal  := NVL(nSumaAsegMoneda,0) * nTasaCambio;
            END IF;

            IF NVL(X.MontoDeducible,0) != 0 THEN
               nDeducibleCobMoneda := NVL(X.MontoDeducible,0);
               nDeducibleCobLocal  := NVL(X.MontoDeducible,0) * nTasaCambio;
            ELSE
               nDeducibleCobMoneda := NVL(nSumaAsegMoneda,0) * NVL(X.PorcenDeducible,0) / 100;
               nDeducibleCobLocal  := NVL(nDeducibleCobMoneda,0) * nTasaCambio;
            END IF;

            BEGIN
               SELECT NVL(MAX(IdEndoso),0)
                 INTO nIdEndoso
                 FROM ASEGURADO_CERTIFICADO
                WHERE CodCia        = nCodCia
                  AND IdPoliza      = nIdPoliza
                  AND IDetPol       = nIDetPol
                  AND Cod_Asegurado = nCod_Asegurado;
            END;
            IF (cTarifaDinamica = 'S' AND NVL(nSumaAsegMoneda,0) != 0 AND NVL(nValorMoneda,0) != 0) OR
               (cTarifaDinamica = 'N' AND NVL(nSumaAsegMoneda,0) != 0) THEN
               BEGIN
                  INSERT INTO COBERT_ACT_ASEG
                        (IdPoliza, IDetPol, CodEmpresa, IdTipoSeg, CodCia,
                         CodCobert, StsCobertura, SumaAseg_Local, SumaAseg_Moneda,
                         Prima_Local, Prima_Moneda, Tasa, IdEndoso, TipoRef,
                         NumRef, PlanCob, Cod_Moneda, Deducible_Local, Deducible_Moneda,
                         Cod_Asegurado, PrimaNivMoneda, PrimaNivLocal, SalarioMensual,
                         VecesSalario, SumaAsegCalculada, Edad_Minima, Edad_Maxima,
                         Edad_Exclusion, SumaAseg_Minima, SumaAseg_Maxima, PorcExtraPrimaDet,
                         MontoExtraPrimaDet, SumaIngresada, IDRAMOREAL, Franquiciaingresado, MontoDiario, Dias_Cal)
                  VALUES(nIdPoliza, nIDetPol, nCodEmpresa, cIdTipoSeg, nCodCia,
                         X.CodCobert, cStsCobertura, nSumaAsegLocal, nSumaAsegMoneda,
                         nValor, nValorMoneda, nTasa, nIdEndoso, 'POLI',
                         nIdPoliza, cPlanCob, nCod_Moneda, nDeducibleCobLocal, nDeducibleCobMoneda,
                         nCod_Asegurado, nPrimaNivMoneda, nPrimaNivLocal, NVL(nSalarioMensual,0),
                         NVL(nVecesSalario,0), NVL(nSumaAsegManual,0), nEdad_MinimaCob,
                         nEdad_MaximaCob, nEdad_ExclusionCob, nSumaAseg_MinimaCob,
                         nSumaAseg_MaximaCob, nPorcExtraPrima, nMontoExtraPrima, nSumaIngresada, X.IDRAMOREAL, 
                         nFranquiciaingresado, nMontoDiario , nDias_Cal);
               EXCEPTION
                  WHEN DUP_VAL_ON_INDEX THEN
                     RAISE_APPLICATION_ERROR(-20225,'Existen Coberturas Duplicadas para Detalle de la Póliza: '||
                                            TRIM(TO_CHAR(nIdPoliza))||' - '||TO_CHAR(nIDetPol));
               END;
            END IF;
         END IF;
      END LOOP;
   END IF;
END CARGAR_COBERTURAS;

END FLUJO_EMISION_SIGO;
/

CREATE OR REPLACE PUBLIC SYNONYM FLUJO_EMISION_SIGO FOR THONAPI.FLUJO_EMISION_SIGO
/

GRANT EXECUTE ON THONAPI.FLUJO_EMISION_SIGO TO PUBLIC
/