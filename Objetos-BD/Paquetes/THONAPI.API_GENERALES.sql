CREATE OR REPLACE PACKAGE THONAPI.API_GENERALES AS
/******************************************************************************
   NOMBRE:       API_GENERALES
   Desarrollado por Darbrain: 22-07-2020 
******************************************************************************/
    PROCEDURE API_REQUISITOS_COBERT( PA_IDPOLIZA IN  NUMBER,  PA_CODASEGURADO IN  NUMBER, PA_NOMBRE IN  VARCHAR2,PA_APPATERNO IN  VARCHAR2, PA_APMATERNO IN  VARCHAR2, PA_CODCOBERT IN  VARCHAR2, PA_IDREQUISITO  IN  VARCHAR2,PA_RESPUESTA OUT CLOB );
    PROCEDURE API_CALCULA_EDAD(FECHANACIMIENTO IN DATE, nEDAD OUT NUMBER );
    PROCEDURE API_ACTIVIDAD_ECONOMICA(cRiesgoActividad IN VARCHAR2, cTipoRiesgo IN VARCHAR2,xDatosActE OUT XMLTYPE);
    PROCEDURE API_COPIA_COTIZACION (nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nNuevaIdCotizacion OUT NUMBER);
    PROCEDURE API_MARCA_COTIZACION (nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nValor OUT NUMBER);
    PROCEDURE API_ASIGNA_VALORES(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nEdad IN NUMBER, nFecha IN VARCHAR2, nOcupacion IN VARCHAR2, nValor OUT NUMBER);
    PROCEDURE API_RECOTIZACION (nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nValor OUT NUMBER);
    PROCEDURE API_PAGO_FACTURA (nIdPoliza IN NUMBER, nIdFactura IN NUMBER,cCodFormaPago IN VARCHAR2, nValor OUT NUMBER);
    PROCEDURE API_CONSULTA_COTIZACION (nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, SetXml OUT CLOB);
    PROCEDURE API_CONSULTA(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, SetSalidaXml OUT CLOB);
    PROCEDURE API_CATALOGO_GIRO (pESPARAVIDA IN CHAR, pESACEPTADO IN CHAR , SetSalidaXml OUT CLOB);
    PROCEDURE API_DIGITAL_CATALOGO_PRODUCT (SetSalidaXml OUT CLOB);
    PROCEDURE API_VIGENCIA_HASTA (VIGENCIAINI OUT DATE);
    PROCEDURE API_VIGENCIA_COTIZACION (VIGENCIAINI OUT DATE);
    PROCEDURE API_DESCARTA_COTIZACION(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nSalida OUT INT);
    PROCEDURE API_ACTUALIZA_COT(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nNombre IN VARCHAR2, nFechaInicioVigencia IN VARCHAR2, nFechaFinVigencia IN VARCHAR2, nFechaCotizacion IN VARCHAR2, nFechaVencimiento IN VARCHAR2, ROWAFFECT OUT NUMBER);
    PROCEDURE API_ACTUALIZA_COTO(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nNombre IN VARCHAR2, nFechaInicioVigencia IN VARCHAR2, nFechaFinVigencia IN VARCHAR2, nFechaCotizacion IN VARCHAR2, nFechaVencimiento IN VARCHAR2, nOcupacion IN VARCHAR2, ROWAFFECT OUT NUMBER);
    PROCEDURE API_ACTUALIZA_ASEG(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nIDetCotizacion IN NUMBER, nNombre IN VARCHAR2,  nApPat IN VARCHAR2, nApMat IN VARCHAR2, nFechaNacimiento IN VARCHAR2, ROWAFFECT OUT NUMBER);
    PROCEDURE API_ACTUALIZA_DETALLE(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nIDetCotizacion IN NUMBER, nNombre IN VARCHAR2, ROWAFFECT OUT NUMBER);
    PROCEDURE API_PLANTILLA_DATOS_PROCESO(W_CODCIA IN NUMBER, W_CODEMPRESA IN NUMBER, P_IDTIPOSEG IN VARCHAR2, P_PLANCOB IN VARCHAR2, P_TIPOPROCESO IN VARCHAR2, Salida OUT CLOB);
    PROCEDURE API_ACTUALIZAR_FECHA(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nFechaFinVigencia IN VARCHAR2, ROWAFFECT OUT NUMBER);
    PROCEDURE API_RECALCULAR_COTIZACION(p_nCodCia NUMBER, p_nCodEmpresa NUMBER, p_nIdCotizacion NUMBER,
                                  p_cIdTipoSeg VARCHAR2, p_cPlanCob VARCHAR2, p_cIndAsegModelo VARCHAR2,
                                  p_cIndCensoSubgrupo VARCHAR2, p_cIndListadoAseg VARCHAR2);
    PROCEDURE API_CONSULTA_FACTURA(nCodCia NUMBER, nIdPoliza NUMBER, nXml OUT CLOB);
    PROCEDURE API_COTIZACION_PRE_EMITIRR(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nIdPoliza IN NUMBER, nIdAseg IN NUMBER, nRFCT IN VARCHAR2,
                nNombreT IN VARCHAR2, nAppatT IN VARCHAR2, nApmatT IN VARCHAR2, nSexoT IN VARCHAR2, nFechaNacT IN VARCHAR2, nDireccionT IN VARCHAR2, nNumInteriorT IN VARCHAR2, nNumExteriorT IN VARCHAR2, 
                nCodColoniaT IN VARCHAR2, nCodProvresT IN VARCHAR2, nCodPosresT IN VARCHAR2, nLadaT IN VARCHAR2, nTelefonoT IN VARCHAR2, nEmailT IN VARCHAR2, 
                nCodFormaCobro IN VARCHAR2, nCodEntidadFinan IN VARCHAR2,
                nCuentaB IN VARCHAR2, nCuentaC IN VARCHAR2, nNumTarjeta IN VARCHAR2, nFechaVen IN VARCHAR2, nNomTitular IN VARCHAR2, nCodPlanPago IN VARCHAR2,
                nNombreD IN VARCHAR2, nAppatD IN VARCHAR2, nApmatD IN VARCHAR2, nSexoD IN VARCHAR2, nFechaNacD IN VARCHAR2, nDireccionD IN VARCHAR2, nNumInteriorD IN VARCHAR2, nNumExteriorD IN VARCHAR2, 
                nCodColoniaD IN VARCHAR2, nCodProvresD IN VARCHAR2, nCodPosresD IN VARCHAR2, nLadaD IN VARCHAR2, nTelefonoD IN VARCHAR2, nEmailD IN VARCHAR2,
                ben1 IN VARCHAR2, ben2 IN VARCHAR2,
                nSetXml OUT CLOB);
    PROCEDURE API_LIBERAR_PLDS(nCodCia IN NUMBER, nCodEmpresa IN NUMBER,nCadenaPolizas IN VARCHAR2, cRespuesta OUT CLOB);
    PROCEDURE API_LIBERAR_PLD(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nIdPoliza IN NUMBER, nSetXml OUT CLOB);
    PROCEDURE API_COTIZACION_PRE_EMITIR(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nIdPoliza IN NUMBER, nIdAseg IN NUMBER, nRFCT IN VARCHAR2,nRFCA1 IN VARCHAR2, nRFCFactura IN VARCHAR2,
                nNombreT IN VARCHAR2, nAppatT IN VARCHAR2, nApmatT IN VARCHAR2, nSexoT IN VARCHAR2, nFechaNacT IN VARCHAR2, nDireccionT IN VARCHAR2, nNumInteriorT IN VARCHAR2, nNumExteriorT IN VARCHAR2, 
                nCodColoniaT IN VARCHAR2, nCodProvresT IN VARCHAR2, nCodPosresT IN VARCHAR2, nLadaT IN VARCHAR2, nTelefonoT IN VARCHAR2, nEmailT IN VARCHAR2, 
                nCodFormaCobro IN VARCHAR2, nCodEntidadFinan IN VARCHAR2,
                nCuentaB IN VARCHAR2, nCuentaC IN VARCHAR2, nNumTarjeta IN VARCHAR2, nFechaVen IN VARCHAR2, nNomTitular IN VARCHAR2, nCodPlanPago IN VARCHAR2,
                nNombreA1 IN VARCHAR2, nAppatA1 IN VARCHAR2, nApmatA1 IN VARCHAR2, nSexoA1 IN VARCHAR2, nFechaNacA1 IN VARCHAR2, nDireccionA1 IN VARCHAR2, nNumInteriorA1 IN VARCHAR2, nNumExteriorA1 IN VARCHAR2, 
                nCodColoniaA1 IN VARCHAR2, nCodProvresA1 IN VARCHAR2, nCodPosresA1 IN VARCHAR2, nLadaA1 IN VARCHAR2, nTelefonoA1 IN VARCHAR2, nEmailA1 IN VARCHAR2,
                nNombreA2 IN VARCHAR2, nAppatA2 IN VARCHAR2, nApmatA2 IN VARCHAR2, nSexoA2 IN VARCHAR2, nFechaNacA2 IN VARCHAR2, nDireccionA2 IN VARCHAR2, nNumInteriorA2 IN VARCHAR2, nNumExteriorA2 IN VARCHAR2, 
                nCodColoniaA2 IN VARCHAR2, nCodProvresA2 IN VARCHAR2, nCodPosresA2 IN VARCHAR2, nLadaA2 IN VARCHAR2, nTelefonoA2 IN VARCHAR2, nEmailA2 IN VARCHAR2,nNacionalidad IN VARCHAR2,nNacionalidadAseg1 IN VARCHAR2,nNacionalidadAseg2 IN VARCHAR2,
                ben1 IN VARCHAR2, ben2 IN VARCHAR2,
                nSetXml OUT CLOB);

PROCEDURE API_COTIZACION_PRE_EMITIR_CFDI(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nIdPoliza IN NUMBER, nIdAseg IN NUMBER, nRFCT IN VARCHAR2,nRFCA1 IN VARCHAR2, nRFCFactura IN VARCHAR2,
                nNombreT IN VARCHAR2, nAppatT IN VARCHAR2, nApmatT IN VARCHAR2, nSexoT IN VARCHAR2, nFechaNacT IN VARCHAR2, nDireccionT IN VARCHAR2, nNumInteriorT IN VARCHAR2, nNumExteriorT IN VARCHAR2, 
                nCodColoniaT IN VARCHAR2, nCodProvresT IN VARCHAR2, nCodPosresT IN VARCHAR2, nLadaT IN VARCHAR2, nTelefonoT IN VARCHAR2, nEmailT IN VARCHAR2, 
                nCodFormaCobro IN VARCHAR2, nCodEntidadFinan IN VARCHAR2,
                nCuentaB IN VARCHAR2, nCuentaC IN VARCHAR2, nNumTarjeta IN VARCHAR2, nFechaVen IN VARCHAR2, nNomTitular IN VARCHAR2, nCodPlanPago IN VARCHAR2,
                nNombreA1 IN VARCHAR2, nAppatA1 IN VARCHAR2, nApmatA1 IN VARCHAR2, nSexoA1 IN VARCHAR2, nFechaNacA1 IN VARCHAR2, nDireccionA1 IN VARCHAR2, nNumInteriorA1 IN VARCHAR2, nNumExteriorA1 IN VARCHAR2, 
                nCodColoniaA1 IN VARCHAR2, nCodProvresA1 IN VARCHAR2, nCodPosresA1 IN VARCHAR2, nLadaA1 IN VARCHAR2, nTelefonoA1 IN VARCHAR2, nEmailA1 IN VARCHAR2,
                nNombreA2 IN VARCHAR2, nAppatA2 IN VARCHAR2, nApmatA2 IN VARCHAR2, nSexoA2 IN VARCHAR2, nFechaNacA2 IN VARCHAR2, nDireccionA2 IN VARCHAR2, nNumInteriorA2 IN VARCHAR2, nNumExteriorA2 IN VARCHAR2, 
                nCodColoniaA2 IN VARCHAR2, nCodProvresA2 IN VARCHAR2, nCodPosresA2 IN VARCHAR2, nLadaA2 IN VARCHAR2, nTelefonoA2 IN VARCHAR2, nEmailA2 IN VARCHAR2,nNacionalidad IN VARCHAR2,nNacionalidadAseg1 IN VARCHAR2,nNacionalidadAseg2 IN VARCHAR2,
                ben1 IN VARCHAR2, ben2 IN VARCHAR2, xInformacionFiscal IN XMLTYPE,
                nSetXml OUT CLOB);

    PROCEDURE API_COTIZACION_PRE_EMITIR_V2(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nIdPoliza IN NUMBER, nIdAseg IN NUMBER, nRFCT IN VARCHAR2,
                nNombreT IN VARCHAR2, nAppatT IN VARCHAR2, nApmatT IN VARCHAR2, nSexoT IN VARCHAR2, nFechaNacT IN VARCHAR2, nDireccionT IN VARCHAR2, nNumInteriorT IN VARCHAR2, nNumExteriorT IN VARCHAR2, 
                nCodColoniaT IN VARCHAR2, nCodProvresT IN VARCHAR2, nCodPosresT IN VARCHAR2, nLadaT IN VARCHAR2, nTelefonoT IN VARCHAR2, nEmailT IN VARCHAR2, 
                nCodFormaCobro IN VARCHAR2, nCodEntidadFinan IN VARCHAR2,
                nCuentaB IN VARCHAR2, nCuentaC IN VARCHAR2, nNumTarjeta IN VARCHAR2, nFechaVen IN VARCHAR2, nNomTitular IN VARCHAR2, nCodPlanPago IN VARCHAR2,
                nNombreD IN VARCHAR2, nAppatD IN VARCHAR2, nApmatD IN VARCHAR2, nSexoD IN VARCHAR2, nFechaNacD IN VARCHAR2, nDireccionD IN VARCHAR2, nNumInteriorD IN VARCHAR2, nNumExteriorD IN VARCHAR2, 
                nCodColoniaD IN VARCHAR2, nCodProvresD IN VARCHAR2, nCodPosresD IN VARCHAR2, nLadaD IN VARCHAR2, nTelefonoD IN VARCHAR2, nEmailD IN VARCHAR2,
                ben1 IN VARCHAR2, ben2 IN VARCHAR2,
                nSetXml OUT CLOB);
    --
    PROCEDURE API_COTIZACION_PRE_EMITIR_V3(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nIdAseg IN NUMBER, 
                nRFCT IN VARCHAR2,
                nNombreT IN VARCHAR2, nAppatT IN VARCHAR2, nApmatT IN VARCHAR2, nSexoT IN VARCHAR2, nFechaNacT IN VARCHAR2, nDireccionT IN VARCHAR2, nNumInteriorT IN VARCHAR2, nNumExteriorT IN VARCHAR2, nLadaT IN VARCHAR2, nTelefonoT IN VARCHAR2, nEmailT IN VARCHAR2, 
                nCuentaB IN VARCHAR2, nCuentaC IN VARCHAR2, nNumTarjeta IN VARCHAR2, nFechaVen IN VARCHAR2, nNomTitular IN VARCHAR2,
                nNombreD IN VARCHAR2, nAppatD IN VARCHAR2, nApmatD IN VARCHAR2, nSexoD IN VARCHAR2, nFechaNacD IN VARCHAR2, nDireccionD IN VARCHAR2, nNumInteriorD IN VARCHAR2, nNumExteriorD IN VARCHAR2, nLadaD IN VARCHAR2, nTelefonoD IN VARCHAR2, nEmailD IN VARCHAR2, 
                nSetXml OUT CLOB);
    --
    PROCEDURE API_COTIZACION_PRE_EMITIR_V4(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nIdAseg IN NUMBER, nRFCT IN VARCHAR2,
                nNombreT IN VARCHAR2, nAppatT IN VARCHAR2, nApmatT IN VARCHAR2, nSexoT IN VARCHAR2, nFechaNacT IN VARCHAR2, nDireccionT IN VARCHAR2, nNumInteriorT IN VARCHAR2, nNumExteriorT IN VARCHAR2, nLadaT IN VARCHAR2, nTelefonoT IN VARCHAR2, nEmailT IN VARCHAR2, 
                nCuentaB IN VARCHAR2, nCuentaC IN VARCHAR2, nNumTarjeta IN VARCHAR2, nFechaVen IN VARCHAR2, nNomTitular IN VARCHAR2,
                nNombreD IN VARCHAR2, nAppatD IN VARCHAR2, nApmatD IN VARCHAR2, nSexoD IN VARCHAR2, nFechaNacD IN VARCHAR2, nDireccionD IN VARCHAR2, nNumInteriorD IN VARCHAR2, nNumExteriorD IN VARCHAR2, nLadaD IN VARCHAR2, nTelefonoD IN VARCHAR2, nEmailD IN VARCHAR2, 
                nSetXml OUT CLOB);
    --
    PROCEDURE API_CONSULTA_CODIGO_POSTAL(pCatalogo IN NUMBER, pCODPOSTAL IN VARCHAR2, cXml OUT CLOB);
    --
    PROCEDURE API_LIBERADA_PLD(nIdPoliza NUMBER, nRespuesta OUT VARCHAR2);
    --
    PROCEDURE API_ACTUALIZAR_SUBIDADOC(nIdCotizacion IN NUMBER, nIdPoliza IN NUMBER, nRespuesta OUT INT);
    --
    PROCEDURE API_SUBIR_DOCUMENTO(nIdPoliza IN NUMBER, nTipo IN VARCHAR2, nDoc IN BLOB, nRespuesta OUT INT);
    --
    PROCEDURE API_SUBIR_PDF(nIdPoliza IN NUMBER, nDoc IN BLOB, nRespuesta OUT INT);
    --
    PROCEDURE API_CONSULTA_NACION(nNaciones OUT CLOB);
    --
    PROCEDURE API_CONSULTA_FORMAPAGO(nFormasPago OUT CLOB);
    --
    PROCEDURE API_LIBERA_POLIZA(nIdPoliza IN NUMBER, nSalida OUT NUMBER);
    --
    PROCEDURE API_BLOQUEDA_POLIZA(nIdPoliza IN NUMBER, nSalida OUT NUMBER);
    --
    PROCEDURE API_OBTENER_DOCUMENTO(nIdDoc IN NUMBER, nSalida OUT BLOB);
    --
    PROCEDURE API_CONSULTA_RFC(nIdPoliza IN NUMBER, nRFC OUT CLOB);
    --
    PROCEDURE API_ENTIDADES_FINANCIERAS(cResult OUT CLOB);
    --
    PROCEDURE API_CONCEPTOS_PRIMA(nIdCotizacion IN NUMBER, cResult OUT CLOB);
    --
    PROCEDURE API_PARENTESCO(cResult OUT CLOB);
    --
    PROCEDURE API_MUESTRA_POLIZAS(nIdPoliza IN NUMBER, cRFC IN VARCHAR2, pCodAgente IN VARCHAR2, cResult OUT CLOB);
    --
    PROCEDURE API_PAGINA_COTIZACIONES(nIdCotizacion IN NUMBER, nCodAgente IN NUMBER,nEstatus IN VARCHAR2, nNumPagina IN NUMBER,nNombre in VARCHAR2,nFechaInicio in VARCHAR2,nFechaFin in VARCHAR2,nCotizaciones in VARCHAR2,  cResult OUT CLOB);
    --
    PROCEDURE API_PAGINA_COTIZACION(nIdCotizacion IN NUMBER, nCodAgente IN NUMBER,nEstatus IN VARCHAR2, nNumPagina IN NUMBER,nNombre in VARCHAR2,nFechaInicio in VARCHAR2,nFechaFin in VARCHAR2, cResult OUT CLOB);
    --
    PROCEDURE API_PAGINA_POLIZA(nIdPoliza IN NUMBER, cRFC IN VARCHAR2, pCodAgente IN VARCHAR2,pNumPagina IN NUMBER,pNombre IN VARCHAR2, pFechaInicio IN VARCHAR2, pFechaFin IN VARCHAR2, pEstatus IN VARCHAR2, cResult OUT CLOB);
    --
    PROCEDURE API_PAGINA_POLIZAS(nIdPoliza IN NUMBER, cRFC IN VARCHAR2, pCodAgente IN VARCHAR2,pNumPagina IN NUMBER,pNombre IN VARCHAR2, pFechaInicio IN VARCHAR2, pFechaFin IN VARCHAR2, pEstatus IN VARCHAR2,pPolizas IN VARCHAR2, cResult OUT CLOB);
    --
    PROCEDURE API_MUESTRA_COTIZACIONES(nIdCotizacion IN NUMBER, nCodAgente IN NUMBER, cResult OUT CLOB);
    --
    PROCEDURE API_COTIZACION_AGENTE(ncodAgente IN NUMBER, nIdCotizacion IN NUMBER, nValor OUT NUMBER);
    --
    PROCEDURE API_POLIZA_AGENTE(ncodAgente IN VARCHAR2, nIdPoliza IN NUMBER, nValor OUT NUMBER);
    --
    PROCEDURE API_CONDICIONES_GENERALES(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, cIdTipoSeg IN VARCHAR2, dFecEmision IN DATE, SetSalidaXml OUT BLOB);
    --
    PROCEDURE API_DOCUMENTO_ASISTENCIAS(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, cIdTipoSeg IN VARCHAR2, cPlanCob  IN VARCHAR2, nCodPaquete IN NUMBER, SetSalidaXml OUT BLOB);
    --
    PROCEDURE API_SINIESTRO_DOCUMENTO(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, cIdTipoSeg IN VARCHAR2, SetSalidaXml OUT BLOB);
    --
    PROCEDURE API_CONSULTA_AGENTE(pCodCia IN NUMBER, pCodEmpresa IN NUMBER, pCodAgente IN NUMBER, cResult OUT CLOB);
    --
    FUNCTION CONTENEDOR_API (nBool BOOLEAN) return NUMBER;
    --
    --RECIBE UN IDENTIFICADOR DE COTIZACION
    PROCEDURE API_CATALOGO_COTIZACION (IDCOT IN NUMBER, SetXml OUT CLOB);
    --ES EL MISMO PROCEDIMIENTO, PERO SOLAMENTE REGRESA LOS CAMPOS QUE SE SOLICITARON, SIN LAS DESCRIPCIONES
    PROCEDURE API_PLANTILLA_DATOS_PROCESO_M(W_CODCIA IN NUMBER, W_CODEMPRESA IN NUMBER, P_IDTIPOSEG IN VARCHAR2, P_PLANCOB IN VARCHAR2, P_TIPOPROCESO IN VARCHAR2 := 'EMISIO', SetXml OUT CLOB);    
    --REGRESA EL CAMPO STATUS POLIZA STSPOLIZA, RECIBIENDO EL PARAMETRO IDPOLIZA 
    PROCEDURE API_REGRESA_ESTATUS_POLIZA (IDPOL IN NUMBER, SetXml OUT CLOB);
    --
    PROCEDURE API_CONSULTA_FACTURAS (IDPOL IN NUMBER, SetXml OUT CLOB);
    --RECIBE UN IDENTIFICADOR DE COTIZACION
    PROCEDURE API_COTIZACIONES (IDCOT IN NUMBER, SetXml OUT CLOB);
    --RECIBE UN IDENTIFICADOR DE POLIZA
    PROCEDURE API_PERSONA_NATURAL_JURIDICA(IDPOL IN NUMBER, SetXml OUT CLOB);
    PROCEDURE API_DETALLE_PRIMER_PAGO(IDPOL IN NUMBER, SetXml OUT CLOB);
    PROCEDURE API_ELIMINAR_COTIZACIONES(nCodCia IN NUMBER, nCodEmpresa IN NUMBER);
    PROCEDURE API_CONSULTA_DOCUMENTACION(nIdCotizacion IN NUMBER, nCantidadConsulta OUT CLOB);
    PROCEDURE API_LIBERA_POLIZA_SIN_PAGO (IDPOLIZA IN NUMBER,nFechaInicioVigencia in VARCHAR2);
    PROCEDURE API_ACTUALIZA_COMISION(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nPorcComisAgente IN NUMBER,nPorcConv OUT NUMBER, nGastos OUT NUMBER);
    PROCEDURE API_POLIZA_EMITIDA(nIdPoliza IN NUMBER,nRespuesta OUT CLOB);
    PROCEDURE API_PAG_COTIZACIONES_AGE(nIdCotizacion IN NUMBER, nCodAgente IN NUMBER,nEstatus IN VARCHAR2, nNumPagina IN NUMBER,nNombre in VARCHAR2,nFechaInicio in VARCHAR2,nFechaFin in VARCHAR2, cResult OUT CLOB);
    PROCEDURE API_PAG_POLIZAS_AGE(nIdPoliza IN NUMBER, cRFC IN VARCHAR2, pCodAgente IN VARCHAR2,pNumPagina IN NUMBER,pNombre IN VARCHAR2, pFechaInicio IN VARCHAR2, pFechaFin IN VARCHAR2, pEstatus IN VARCHAR2, cResult OUT CLOB);
    PROCEDURE API_ASIGNACION_ASEGURADO(nCodCliente IN NUMBER, cNombre IN VARCHAR2, cApePaterno IN VARCHAR2, cApeMaterno IN VARCHAR2,dFecNacimiento IN DATE, cSexo IN VARCHAR2,nTelRes IN NUMBER, nCODASEGURADO OUT NUMBER );
    --PROCEDURE API_IDPOL_SUBGRUPO(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, dFechaRegistro IN DATE, nIdPoliza OUT NUMBER,nIDetPol OUT NUMBER);
    --PROCEDURE API_COBERTURAS(nCodCia IN NUMBER,nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nIdetCotizacion IN NUMBER,nCodGpoCobertWeb IN NUMBER, cCodCobertWeb IN NUMBER, xResultado OUT XMLTYPE);
    --PROCEDURE API_ACTUALIZA_COBERTURAS(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, xDatos IN XMLTYPE, xResultado OUT XMLTYPE, xPrima OUT XMLTYPE);
    PROCEDURE API_COBERTURAS(nCodCia IN NUMBER,nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nIdetCotizacion IN NUMBER,nCodGpoCobertWeb IN NUMBER, cCodCobertWeb IN NUMBER, xResultado OUT XMLTYPE);

    PROCEDURE API_ACTUALIZA_COBERTURAS(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, xDatos IN XMLTYPE, xResultado OUT XMLTYPE,xPrima OUT XMLTYPE);
    PROCEDURE API_OBTENER_GUA(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, cIdTipoSeg IN VARCHAR2, cPlanCob IN VARCHAR2, cCodCobert IN VARCHAR2, cNivel IN VARCHAR2, nFactor IN VARCHAR2, cCodClausula IN VARCHAR2,xResultado OUT XMLTYPE);
    PROCEDURE API_OBTEN_PADECIMENTO_O_NIVELH(nOpcion IN NUMBER, nCodCia IN NUMBER,nCodEmpresa IN NUMBER,cIdTipoSeg IN VARCHAR2,cPlanCob IN VARCHAR2,cCodCobert IN VARCHAR2,cIndIncluido IN VARCHAR2,nFactor IN VARCHAR2,cCodEndoso IN VARCHAR2,xResultado OUT XMLTYPE);
    PROCEDURE API_GUARDAR_PADEC(nCodCia IN NUMBER,nCodEmpresa IN NUMBER,nIdCotizacion IN VARCHAR2,xXMLDatosPadEsp IN XMLTYPE);
    PROCEDURE API_GUARDAR_FACTORES(nCodCia IN NUMBER,nCodEmpresa IN NUMBER,nIdCotizacion IN VARCHAR2,nTipoGuardado IN NUMBER,xXMLDatosGUA IN XMLTYPE, xResultado OUT NUMBER);
    PROCEDURE API_OBTEN_EQUIPO_REGION(nTipo IN NUMBER, nCodCia IN NUMBER, nCodEmpresa IN NUMBER, cIdTipoSeg IN VARCHAR, cPlanCob IN VARCHAR,nCodPaquete IN NUMBER, cCodigo IN VARCHAR, xResultado OUT XMLTYPE);
    PROCEDURE API_ENVIAR_ASEGURADOS_MASIVO(nCodCia IN NUMBER,nCodEmpresa IN NUMBER, nIdPoliza IN NUMBER,xAsegurados IN XMLTYPE);
    PROCEDURE API_SOLICITAR_POLIZA_COLECTIVA(nPoliza IN NUMBER,nCodCia1 IN NUMBER, nCodEmpresa1 IN NUMBER, nIdCotizacion1 IN NUMBER, xDatosCliente IN XMLTYPE, idPoliza OUT NUMBER);
    PROCEDURE API_PRE_EMITE_POLIZA_COLECTIVA(nCodCia IN NUMBER,nCodEmpresa IN NUMBER, nIdPoliza IN NUMBER,cIndRequierePago IN VARCHAR2,cFacturas OUT CLOB) ;
    PROCEDURE API_OBTENER_NUMERO_UNICO(nCodCia IN NUMBER, nIdPoliza IN NUMBER, xDatosPoliza OUT VARCHAR2 );
    PROCEDURE API_POLIZAS_A_RENOVAR(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, dFecEjecucion IN VARCHAR2, xRespuesta OUT XMLTYPE);
    PROCEDURE API_ACTUALIZAR_INF_RE(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdPoliza IN NUMBER, nNumRenov  IN NUMBER,xGenerales IN XMLTYPE);
    PROCEDURE API_RENOVAR_POLIZA(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdPolizaRen IN NUMBER, cEmitePoliza IN VARCHAR2, cPreEmitePoliza IN VARCHAR2, nIdCotizacion IN NUMBER, nPolizaRenovada OUT NUMBER, cFacturas OUT CLOB);
    PROCEDURE PA_CONSULTAR_FEC_POLIZAS_REN(nCodCia IN NUMBER, nCodEmpresa IN NUMBER,xReporte out XMLTYPE);
    PROCEDURE API_CONSULTA_AGENTES_POLIZA(nCodCia IN NUMBER, cNumPolUnico IN VARCHAR2, cConsecutivo IN NUMBER, xRespuesta OUT XMLTYPE);
    PROCEDURE CANCELACION_POLIZAS(nCodCia NUMBER,nCodEmpresa NUMBER,nIdPoliza NUMBER,cMotivAnul VARCHAR2,cRespuesta OUT VARCHAR2,cTipoProceso VARCHAR2,cCod_Moneda OUT VARCHAR2, xRespuesta OUT NUMBER, fechaAnulacion DATE);   
    PROCEDURE API_CONSULTA_SICAS_FLUJOS(xConsultaServicioSicas XMLTYPE, SetSalidaXml OUT CLOB);
    PROCEDURE API_CONSULTA_OBJETO_IMPUESTOS(nCodCia IN NUMBER, nLimInferior IN NUMBER, nLimSuperior IN NUMBER, nTotRegs OUT NUMBER, xRespuesta OUT XMLTYPE);
    PROCEDURE API_CONSULTA_REGIMEN_FISCAL(nLimInferior IN NUMBER, nLimSuperior IN NUMBER, nTotRegs OUT NUMBER, xRespuesta OUT XMLTYPE);
    PROCEDURE API_CONSULTA_USO_CFDI(nCodCia IN NUMBER, nIdRegFisSat IN NUMBER, cTipoPersona IN VARCHAR2, nLimInferior IN NUMBER, nLimSuperior IN NUMBER, nTotRegs OUT NUMBER, xRespuesta OUT XMLTYPE);
    PROCEDURE API_CONSULTA_CATALOGO_GENERAL(pCodLista IN VARCHAR2, pCodValor IN VARCHAR2, xRespuesta OUT CLOB);
    PROCEDURE API_CONSULTA_CIUDAD(cPostal IN VARCHAR2, cColonia IN VARCHAR2, cRespuesta OUT CLOB);
    --
    PROCEDURE API_PAGO_FACTURA_COBRANZA( nIdPoliza      IN POLIZAS.IDPOLIZA%TYPE
                                       , nIdFactura     IN FACTURAS.IDFACTURA%TYPE 
                                       , cCodFormaPago  IN FACTURAS.FORMPAGO%TYPE 
                                       , nNumAprobacion IN VARCHAR2
                                       , dFecha         IN DATE
                                       , bValor        OUT BOOLEAN);
    PROCEDURE API_APLICACION_PAGO( nIdPoliza      IN POLIZAS.IDPOLIZA%TYPE
                                 , nIdFactura     IN FACTURAS.IDFACTURA%TYPE 
                                 , cCodFormaPago  IN FACTURAS.FORMPAGO%TYPE 
                                 , nNumAprobacion IN VARCHAR2 
                                 , dFecha         IN DATE 
                                 , nValor        OUT NUMBER );

    PROCEDURE API_EMITIR_POLIZASP( nIdPoliza    IN  POLIZAS.IDPOLIZA%TYPE
                                 , nValor      OUT  NUMBER );

    PROCEDURE API_CONSULTA_ACTUALIZACION_DWH(nCod IN VARCHAR, SetSalidaXml OUT XMLTYPE);

    /*JACF [28/09/2023] <Se agrega funciÃ³n para consultar catalogo de formas de cobro desde las listas de valores>*/
    PROCEDURE API_CONSULTA_FORMAS_COBRO(LISTA VARCHAR2, xRespuesta OUT CLOB);

END API_GENERALES;
/

CREATE OR REPLACE PACKAGE BODY THONAPI.API_GENERALES AS

    PROCEDURE API_REQUISITOS_COBERT( PA_IDPOLIZA        IN  NUMBER,   
                                        PA_CODASEGURADO     IN  NUMBER,  
                                        PA_NOMBRE           IN  VARCHAR2, 
                                        PA_APPATERNO        IN  VARCHAR2, 
                                        PA_APMATERNO        IN  VARCHAR2, 
                                        PA_CODCOBERT        IN  VARCHAR2, 
    
	PA_IDREQUISITO      IN  VARCHAR2,
                                        PA_RESPUESTA        OUT CLOB ) IS
    
    cHeader VARCHAR2(100);
    FORMAS CLOB;

    BEGIN

            PA_RESPUESTA := GENERALES_PLATAFORMA_DIGITAL.REQUISITOS_COBERT( PA_IDPOLIZA,   
                                                                            PA_CODASEGURADO,
                                                                            PA_NOMBRE,
                                                                            PA_APPATERNO,
                                                                            PA_APMATERNO,
                                                                            PA_CODCOBERT,
                                                                            PA_IDREQUISITO);
    EXCEPTION
        WHEN OTHERS THEN
            cHeader := 'DOCUMENTOS';
            FORMAS := '<?xml version="1.0" encoding="UTF-8" ?><'|| cHeader || '>';
            FORMAS := FORMAS || '<DATA><ASEGURADO></ASEGURADO>';
            FORMAS := FORMAS || '<DOCUMENTO></DOCUMENTO>';
            FORMAS :=  FORMAS || '</' || cHeader || '></DATA>';
            PA_RESPUESTA := FORMAS;
    END API_REQUISITOS_COBERT;
    
    PROCEDURE API_CALCULA_EDAD(FECHANACIMIENTO IN DATE, nEDAD OUT NUMBER ) IS
    BEGIN
        EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
        /*nEdad := 50 ;*/
        nEdad := GENERALES_PLATAFORMA_DIGITAL.CALCULA_EDAD(FECHANACIMIENTO);
    END API_CALCULA_EDAD;
    --
    PROCEDURE API_ACTIVIDAD_ECONOMICA(cRiesgoActividad IN VARCHAR2, cTipoRiesgo IN VARCHAR2, xDatosActE OUT XMLTYPE ) IS

    BEGIN
        xDatosActE:= GENERALES_PLATAFORMA_DIGITAL.ACTIVIDAD_ECONOMICA(cRiesgoActividad, cTipoRiesgo);

    END API_ACTIVIDAD_ECONOMICA;
    --
    PROCEDURE API_COPIA_COTIZACION(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nNuevaIdCotizacion OUT NUMBER) IS
    BEGIN    
        nNuevaIdCotizacion := GENERALES_PLATAFORMA_DIGITAL.COPIA_COTIZACION(nCodCia, nCodEmpresa, nIdCotizacion) ;           
    END API_COPIA_COTIZACION;
    --
    PROCEDURE API_MARCA_COTIZACION (nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nValor OUT NUMBER) IS
        nVal BOOLEAN;
    BEGIN    
        nVal := GENERALES_PLATAFORMA_DIGITAL.MARCA_COTIZACION (nCodCia, nCodEmpresa, nIdCotizacion);
        nValor := API_GENERALES.CONTENEDOR_API(nVal);
    END API_MARCA_COTIZACION;
    --
    PROCEDURE API_ASIGNA_VALORES(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nEdad IN NUMBER, nFecha IN VARCHAR2, nOcupacion IN VARCHAR2, nValor OUT NUMBER) IS
    BEGIN    
        /*UPDATE tabla_cot_seg SET EDAD = nEdad, fecha where USER_ID = p_userid;*/
        nValor := 1;
    END API_ASIGNA_VALORES;
    --
    PROCEDURE API_RECOTIZACION (nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nValor OUT NUMBER) IS
        nVal BOOLEAN;
    BEGIN    
        nVal := GENERALES_PLATAFORMA_DIGITAL.RECOTIZACION (nCodCia, nCodEmpresa, nIdCotizacion);
        nValor := API_GENERALES.CONTENEDOR_API(nVal);
    END API_RECOTIZACION;
    --
     PROCEDURE API_PAGO_FACTURA (nIdPoliza IN NUMBER, nIdFactura IN NUMBER,cCodFormaPago IN VARCHAR2, nValor OUT NUMBER) IS
        nVal BOOLEAN;
    BEGIN    
        nVal := GENERALES_PLATAFORMA_DIGITAL.PAGO_FACTURA(nIdPoliza, nIdFactura,cCodFormaPago);
        nValor := API_GENERALES.CONTENEDOR_API(nVal);
    END API_PAGO_FACTURA;
    --
    PROCEDURE API_CONSULTA_COTIZACION (nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, SetXml OUT CLOB) IS
    BEGIN
        /*SetSalidaXml := '<?xml version="1.0" encoding="UTF-8" ?><DATA></DATA>';*/
        SetXml := GENERALES_PLATAFORMA_DIGITAL.CONSULTA_COTIZACION (nCodCia, nCodEmpresa, nIdCotizacion);
    END API_CONSULTA_COTIZACION;
    --
    PROCEDURE API_CONSULTA(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, SetSalidaXml OUT CLOB) IS
        pPK1            VARCHAR2(32767);
        nNivel          NUMBER := 1;
    BEGIN
            pPK1    := 'CODCIA=' || nCodCia || ',CODEMPRESA=' || nCodEmpresa || ' ,IDCOTIZACION=' || nIdCotizacion;
            SetSalidaXml := GENERALES_PLATAFORMA_DIGITAL.DIGITAL_PLANTILLA(nNivel, pPK1);         
            SetSalidaXml := '<?xml version="1.0" encoding="UTF-8" ?>' || '<DATA>' ||SetSalidaXml || '</DATA>' ;        
    END API_CONSULTA;
    --
    PROCEDURE API_CATALOGO_GIRO (pESPARAVIDA IN CHAR, pESACEPTADO IN CHAR, SetSalidaXml OUT CLOB) IS
    BEGIN
        SetSalidaXml := GENERALES_PLATAFORMA_DIGITAL.CATALOGO_GIRO (pESPARAVIDA, pESACEPTADO);
    END API_CATALOGO_GIRO;
    --
     PROCEDURE API_DIGITAL_CATALOGO_PRODUCT (SetSalidaXml OUT CLOB) IS
     BEGIN
        SetSalidaXml := GENERALES_PLATAFORMA_DIGITAL.DIGITAL_CATALOGO_PRODUCT;
     END API_DIGITAL_CATALOGO_PRODUCT;
    --
    PROCEDURE API_VIGENCIA_HASTA (VIGENCIAINI OUT DATE) IS
    BEGIN
        VIGENCIAINI := GENERALES_PLATAFORMA_DIGITAL.VIGENCIA_HASTA;
        EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
    END API_VIGENCIA_HASTA;
    --
    PROCEDURE API_VIGENCIA_COTIZACION (VIGENCIAINI OUT DATE) IS
    BEGIN
        VIGENCIAINI := GENERALES_PLATAFORMA_DIGITAL.VIGENCIA_COTIZACION;
        EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
    END API_VIGENCIA_COTIZACION;
    --
    PROCEDURE API_DESCARTA_COTIZACION(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nSalida OUT INT) IS
    BEGIN
        nSalida := GENERALES_PLATAFORMA_DIGITAL.DESCARTA_COTIZACION(nCodCia, nCodEmpresa, nIdCotizacion);
    END API_DESCARTA_COTIZACION;
    --
    PROCEDURE API_ACTUALIZA_COTO(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nNombre IN VARCHAR2, nFechaInicioVigencia IN VARCHAR2, nFechaFinVigencia IN VARCHAR2, nFechaCotizacion IN VARCHAR2, nFechaVencimiento IN VARCHAR2, nOcupacion IN VARCHAR2, ROWAFFECT OUT NUMBER) IS
        sqlTextDml VARCHAR2(32726);
    BEGIN
        EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
        sqlTextDml := 'UPDATE COTIZACIONES SET FECSTATUS = trunc(sysdate),';
        sqlTextDml := sqlTextDml || ' NOMBRECONTRATANTE = "' || nNombre ||'" ';
        IF nFechaInicioVigencia IS NOT NULL THEN
            sqlTextDml := sqlTextDml || ', FECINIVIGCOT =  "' || nFechaInicioVigencia ||'" ';
        END IF;
        --sqlTextDml := sqlTextDml || ' FECINIVIGCOT = trunc(sysdate),';
        IF nFechaFinVigencia IS NOT NULL THEN
            sqlTextDml := sqlTextDml || ', FECFINVIGCOT = "' || nFechaFinVigencia ||'" ';
        END IF;
        sqlTextDml := sqlTextDml || ', FECCOTIZACION = trunc(sysdate) ';
        IF nFechaVencimiento IS NOT NULL THEN
            sqlTextDml := sqlTextDml || ', FECVENCECOTIZACION = "' || nFechaVencimiento ||'" ';
        END IF;
        --Solo se actualiza la ocupacion si tiene datos para evitar sobreescritura de vacÃ­os
        IF LENGTH(nOcupacion) > 2 THEN
           sqlTextDml := sqlTextDml || ', DESCACTIVIDADASEG = "' || nOcupacion ||'" ';
        END IF;
        sqlTextDml := sqlTextDml || ' WHERE CODUSUARIO = "THONAPI" AND CODCIA = '|| nCodCia ||' AND CODEMPRESA = '|| nCodEmpresa ||' AND IDCOTIZACION = ' || nIdCotizacion ||'';
        ROWAFFECT := GENERALES_PLATAFORMA_DIGITAL.COTIZACION_ACTUALIZA(sqlTextDml);
        COMMIT;
    END API_ACTUALIZA_COTO;

    --
    PROCEDURE API_ACTUALIZA_COT(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nNombre IN VARCHAR2, nFechaInicioVigencia IN VARCHAR2, nFechaFinVigencia IN VARCHAR2, nFechaCotizacion IN VARCHAR2, nFechaVencimiento IN VARCHAR2, ROWAFFECT OUT NUMBER) IS
        sqlTextDml VARCHAR2(32726);
    BEGIN
        EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
        sqlTextDml := 'UPDATE COTIZACIONES SET FECSTATUS = trunc(sysdate),';
        sqlTextDml := sqlTextDml || ' NOMBRECONTRATANTE = "' || nNombre ||'",';
        sqlTextDml := sqlTextDml || ' FECINIVIGCOT = trunc(sysdate),';
        sqlTextDml := sqlTextDml || ' FECFINVIGCOT = "' || nFechaFinVigencia ||'",';
        sqlTextDml := sqlTextDml || ' FECCOTIZACION = trunc(sysdate),';
        sqlTextDml := sqlTextDml || ' FECVENCECOTIZACION = "' || nFechaVencimiento ||'" ';
        sqlTextDml := sqlTextDml || 'WHERE CODUSUARIO = "THONAPI" AND CODCIA = '|| nCodCia ||' AND CODEMPRESA = '|| nCodEmpresa ||' AND IDCOTIZACION = ' || nIdCotizacion ||'';
        ROWAFFECT := GENERALES_PLATAFORMA_DIGITAL.COTIZACION_ACTUALIZA(sqlTextDml);
        COMMIT;
    END API_ACTUALIZA_COT;
    --
    PROCEDURE API_ACTUALIZAR_FECHA(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nFechaFinVigencia IN VARCHAR2, ROWAFFECT OUT NUMBER) IS
        sqlTextDml VARCHAR2(32726);
    BEGIN
        sqlTextDml := 'UPDATE COTIZACIONES SET ';
        sqlTextDml := sqlTextDml || ' FECFINVIGCOT = "' || nFechaFinVigencia ||'",';
        sqlTextDml := sqlTextDml || 'WHERE CODUSUARIO = "THONAPI" AND CODCIA = '|| nCodCia ||' AND CODEMPRESA = '|| nCodEmpresa ||' AND IDCOTIZACION = ' || nIdCotizacion ||'';
        ROWAFFECT := GENERALES_PLATAFORMA_DIGITAL.COTIZACION_ACTUALIZA(sqlTextDml);
        COMMIT;
    END API_ACTUALIZAR_FECHA;
    --
    PROCEDURE API_ACTUALIZA_ASEG(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nIDetCotizacion IN NUMBER, nNombre IN VARCHAR2, nApPat IN VARCHAR2, nApMat IN VARCHAR2, nFechaNacimiento IN VARCHAR2, ROWAFFECT OUT NUMBER) IS
        sqlTextDml VARCHAR2(32726);
        nEdad NUMBER;
    BEGIN
        EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
        nEdad := GENERALES_PLATAFORMA_DIGITAL.CALCULA_EDAD(nFechaNacimiento);
        sqlTextDml := 'UPDATE COTIZACIONES_ASEG SET ';
        sqlTextDml := sqlTextDml || ' NOMBREASEG = "' || nNombre ||'",';
        sqlTextDml := sqlTextDml || ' APELLIDOPATERNOASEG = "' || nApPat ||'",';
        sqlTextDml := sqlTextDml || ' APELLIDOMATERNOASEG = "' || nApMat ||'",';
        sqlTextDml := sqlTextDml || ' EDADCONTRATACION = "' || nEdad ||'",';
        sqlTextDml := sqlTextDml || ' FECHANACASEG = "' || nFechaNacimiento ||'" ';
        sqlTextDml := sqlTextDml || 'WHERE CODCIA = '|| nCodCia ||' AND CODEMPRESA = '|| nCodEmpresa ||' AND IDETCOTIZACION = ' || nIDetCotizacion ||' AND IDCOTIZACION = ' || nIdCotizacion ||'';
        ROWAFFECT := GENERALES_PLATAFORMA_DIGITAL.COTIZACION_ACTUALIZA(sqlTextDml);
        COMMIT;
    END API_ACTUALIZA_ASEG;
    --
    PROCEDURE API_ACTUALIZA_DETALLE(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nIDetCotizacion IN NUMBER, nNombre IN VARCHAR2, ROWAFFECT OUT NUMBER) IS
        sqlTextDml VARCHAR2(32726);
    BEGIN
        EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
        sqlTextDml := 'UPDATE COTIZACIONES_DETALLE SET ';
        sqlTextDml := sqlTextDml || ' DESCSUBGRUPO = "' || nNombre ||'" ';
        sqlTextDml := sqlTextDml || 'WHERE CODCIA = '|| nCodCia ||' AND CODEMPRESA = '|| nCodEmpresa ||' AND IDETCOTIZACION = ' || nIDetCotizacion ||' AND IDCOTIZACION = ' || nIdCotizacion ||'';
        ROWAFFECT := GENERALES_PLATAFORMA_DIGITAL.COTIZACION_ACTUALIZA(sqlTextDml);
        COMMIT;
    END API_ACTUALIZA_DETALLE;
    --
    PROCEDURE API_PLANTILLA_DATOS_PROCESO(W_CODCIA IN NUMBER, W_CODEMPRESA IN NUMBER, P_IDTIPOSEG IN VARCHAR2, P_PLANCOB IN VARCHAR2, P_TIPOPROCESO IN VARCHAR2, Salida OUT CLOB)
    IS
    BEGIN
        Salida := GENERALES_PLATAFORMA_DIGITAL.PLANTILLA_DATOS_PROCESO(W_CODCIA, W_CODEMPRESA, P_IDTIPOSEG, P_PLANCOB, P_TIPOPROCESO);
    END API_PLANTILLA_DATOS_PROCESO;
    --
    PROCEDURE API_COTIZACION_PRE_EMITIRR(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nIdPoliza IN NUMBER, nIdAseg IN NUMBER, nRFCT IN VARCHAR2,
                nNombreT IN VARCHAR2, nAppatT IN VARCHAR2, nApmatT IN VARCHAR2, nSexoT IN VARCHAR2, nFechaNacT IN VARCHAR2, nDireccionT IN VARCHAR2, nNumInteriorT IN VARCHAR2, nNumExteriorT IN VARCHAR2, 
                nCodColoniaT IN VARCHAR2, nCodProvresT IN VARCHAR2, nCodPosresT IN VARCHAR2, nLadaT IN VARCHAR2, nTelefonoT IN VARCHAR2, nEmailT IN VARCHAR2, 
                nCodFormaCobro IN VARCHAR2, nCodEntidadFinan IN VARCHAR2,
                nCuentaB IN VARCHAR2, nCuentaC IN VARCHAR2, nNumTarjeta IN VARCHAR2, nFechaVen IN VARCHAR2, nNomTitular IN VARCHAR2, nCodPlanPago IN VARCHAR2,
                nNombreD IN VARCHAR2, nAppatD IN VARCHAR2, nApmatD IN VARCHAR2, nSexoD IN VARCHAR2, nFechaNacD IN VARCHAR2, nDireccionD IN VARCHAR2, nNumInteriorD IN VARCHAR2, nNumExteriorD IN VARCHAR2, 
                nCodColoniaD IN VARCHAR2, nCodProvresD IN VARCHAR2, nCodPosresD IN VARCHAR2, nLadaD IN VARCHAR2, nTelefonoD IN VARCHAR2, nEmailD IN VARCHAR2,
                ben1 IN VARCHAR2, ben2 IN VARCHAR2,
                nSetXml OUT CLOB) IS

       cadena VARCHAR2(5000);
       cadena1 VARCHAR2(5000);
       cCadena VARCHAR2(5000);

       cFechaHoy DATE := SYSDATE;
       cFechaUnAnno DATE := add_months(SYSDATE + 1, 12);
       cTipoDocIdentificacion VARCHAR2(10) := 'RFC';
       --cCodFormaCobro VARCHAR2(10) := 'CTC';
       --cCodEntidadFinan VARCHAR2(10) := '012';
       --cCodPlanPago VARCHAR2(10) := 'ANUA';
       cCodFormaCobro VARCHAR2(10) := nCodFormaCobro;
       cCodEntidadFinan VARCHAR2(10) := nCodEntidadFinan;
       cCodPlanPago VARCHAR2(10) := nCodPlanPago;
       cIndDeclara VARCHAR2(10) := 'N';

       rfc VARCHAR2(50) := 'LOOA531113F15'; -- RFC PARA QUE NO PASE PLD

       cTipoIdTributaria VARCHAR2(10) := 'RFC';
       cNumTributario VARCHAR2(50) := 'XAXX010101000'; -- RFC GENERICO
       --cTipoIdTributaria VARCHAR2(10) := '';
       --cNumTributario VARCHAR2(50) := ''; -- RFC Vacio

    BEGIN
        EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
        -- DOBLE VIDA
        IF (nIdAseg = 1) then
            -- CONTRATANTE
            cCadena := 'C,' || cTipoDocIdentificacion ||','|| nRFCT ||','|| nNombreT ||','|| nAppatT ||','|| nApmatT ||','|| nSexoT ||','|| nFechaNacT ||','||cTipoIdTributaria||','||cNumTributario||',';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionT ||','|| nNumInteriorT ||','|| nNumExteriorT ||','|| nCodColoniaT ||','|| nCodProvresT ||','|| nCodPosresT ||','|| nLadaT ||','|| nTelefonoT ||','|| nEmailT ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,';
            -- CONCATENA
            cCadena := cCadena || '|';
            -- ASEGURADO CONTRATANTE
            cCadena := cCadena || 'A,' || cTipoDocIdentificacion ||','|| nRFCT ||','|| nNombreT ||','|| nAppatT ||','|| nApmatT ||','|| nSexoT ||','|| nFechaNacT ||',,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionT ||','|| nNumInteriorT ||','|| nNumExteriorT ||','|| nCodColoniaT ||','|| nCodProvresT ||','|| nCodPosresT ||','|| nLadaT ||','|| nTelefonoT ||','|| nEmailT ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,';--,,,,,,';
            cCadena := cCadena || ben1;
            -- CONCATENA
            cCadena := cCadena || '|';
            -- ASEGURADO
            cCadena := cCadena || 'A,' || cTipoDocIdentificacion ||',,'|| nNombreD ||','|| nAppatD ||','|| nApmatD ||','|| nSexoD ||','|| nFechaNacD ||',,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionD ||','|| nNumInteriorD ||','|| nNumExteriorD ||','|| nCodColoniaD ||','|| nCodProvresD ||','|| nCodPosresD ||','|| nLadaD ||','|| nTelefonoD ||','|| nEmailD ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||',,,,,,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,';--,,,,,,';
            cCadena := cCadena || ben2;
        END IF;
        -- INDIVUDUAL
        IF(nIdAseg = 0) then
            -- CONTRATANTE
            cCadena := 'C,' || cTipoDocIdentificacion ||','|| nRFCT ||','|| nNombreT ||','|| nAppatT ||','|| nApmatT ||','|| nSexoT ||','|| nFechaNacT ||','||cTipoIdTributaria||','||cNumTributario||',';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionT ||','|| nNumInteriorT ||','|| nNumExteriorT ||','|| nCodColoniaT ||','|| nCodProvresT ||','|| nCodPosresT ||','|| nLadaT ||','|| nTelefonoT ||','|| nEmailT ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,';
            -- CONCATENA
            cCadena := cCadena || '|';
            -- ASEGURADO
            cCadena := cCadena || 'A,' || cTipoDocIdentificacion ||','|| nRFCT ||','|| nNombreD ||','|| nAppatD ||','|| nApmatD ||','|| nSexoD ||','|| nFechaNacD ||',,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionD ||','|| nNumInteriorD ||','|| nNumExteriorD ||','|| nCodColoniaD ||','|| nCodProvresD ||','|| nCodPosresD ||','|| nLadaD ||','|| nTelefonoD ||','|| nEmailD ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,';--,,,,,,';
            cCadena := cCadena || ben1;
        END IF;
        -- DOS PERSONAS
        IF (nIdAseg = 2) then
            -- CONTRATANTE
            cCadena := 'C,' || cTipoDocIdentificacion ||','|| nRFCT ||','|| nNombreT ||','|| nAppatT ||','|| nApmatT ||','|| nSexoT ||','|| nFechaNacT ||','||cTipoIdTributaria||','||cNumTributario||',';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionT ||','|| nNumInteriorT ||','|| nNumExteriorT ||','|| nCodColoniaT ||','|| nCodProvresT ||','|| nCodPosresT ||','|| nLadaT ||','|| nTelefonoT ||','|| nEmailT ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,';
            -- CONCATENA
            cCadena := cCadena || '|';
            -- ASEGURADO Y/O CONTRATANTE
            cCadena := cCadena || 'A,' || cTipoDocIdentificacion ||',,'|| nNombreD ||','|| nAppatD ||','|| nApmatD ||','|| nSexoD ||','|| nFechaNacD ||',,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionD ||','|| nNumInteriorD ||','|| nNumExteriorD ||','|| nCodColoniaD ||','|| nCodProvresD ||','|| nCodPosresD ||','|| nLadaD ||','|| nTelefonoD ||','|| nEmailD ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||',,,,,,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,';--,,,,,,';
            cCadena := cCadena || ben2;
        END IF;

        cadena := ''|| nCodCia ||','|| nCodEmpresa ||','|| nIdCotizacion ||','|| nIdAseg ||','|| cCadena;
        --INSERT INTO CADENA_EMISION (TEXTO, FECHA) VALUES (cadena, sysdate);
        --nSetXml := '<DATA></DATA>';

        IF (nIdPoliza = 0) THEN
            nSetXml := GENERALES_PLATAFORMA_DIGITAL.PRE_EMITE_POLIZA_NEW(nCodCia, nCodEmpresa, nIdCotizacion, cCadena, NULL);
        END IF;
        IF (nIdPoliza != 0) THEN
            nSetXml := GENERALES_PLATAFORMA_DIGITAL.PRE_EMITE_POLIZA_NEW(nCodCia, nCodEmpresa, nIdCotizacion, cCadena, nIdPoliza);
        END IF;
        --PRE_EMITE_POLIZA_NEW(nCodCia, nCodEmpresa, nIdCotizacion, cCadena, cIdpOLIZA);

    END API_COTIZACION_PRE_EMITIRR;
    --
    PROCEDURE API_LIBERAR_PLDS(nCodCia IN NUMBER, nCodEmpresa IN NUMBER,nCadenaPolizas IN VARCHAR2, cRespuesta OUT CLOB) IS
    cCadena     VARCHAR2(10) := '';
    cChar            varchar2(10):='';
    cRespuestaBloqueo integer:=0;
    nNumeroCotizacion    NUMBER;
    --cRespuesta       varchar2(500):='';
    CURSOR cursorPolizas IS
            select regexp_substr(nCadenaPolizas,'[^,]+', 1, level) as idpoliza from dual
            connect by regexp_substr(nCadenaPolizas, '[^,]+', 1, level) is not null;


    nSetXml          CLOB;
    BEGIN

    FOR rowdata IN cursorPolizas
      LOOP
      IF LENGTH(rowdata.idpoliza)>2 THEN
                --dbms_output.put_line('-'|| rowdata.idpoliza||'-');
                cChar :=  GENERALES_PLATAFORMA_DIGITAL.PLD_POLIZA_LIBERADA(TO_NUMBER(rowdata.idpoliza));
                IF (cChar = 'N') THEN--Si no fue liberada, revisa que no estÃƒÂ© bloqueada
                    API_GENERALES.API_BLOQUEDA_POLIZA(TO_NUMBER(rowdata.idpoliza), cRespuestaBloqueo);
                    IF (cRespuestaBloqueo = 1) THEN--Si estÃƒÂ¡ bloqueada
                       cRespuesta := 'B' || ',' ||rowdata.idpoliza||'|'||  cRespuesta ;
                    ELSE
                       cRespuesta := cChar || ',' ||rowdata.idpoliza||'|'||  cRespuesta ;
                    END IF;
                ELSIF (cChar = 'S') THEN--Si fue liberada
                    --Obtener el nÃƒÂºmero de la cotizaciÃƒÂ³n 
                    SELECT NUM_COTIZACION INTO nNumeroCotizacion FROM POLIZAS WHERE IDPOLIZA = TO_NUMBER(rowdata.idpoliza); 
                    API_GENERALES.API_LIBERAR_PLD(nCodCia,nCodEmpresa,nNumeroCotizacion,TO_NUMBER(rowdata.idpoliza),nSetXml);
                    cRespuesta := cChar || ',' ||rowdata.idpoliza||'|'||  cRespuesta ;
                END IF;
            END IF;
        --dbms_output.put_line( '-'|| rowdata.idpoliza ||'-');
      END LOOP;

       --for i in 1..array.count LOOP
            --IF LENGTH(array(i))>2 THEN
                --dbms_output.put_line('-'|| array(i)||'-');
                --cChar :=  GENERALES_PLATAFORMA_DIGITAL.PLD_POLIZA_LIBERADA(TO_NUMBER(array(i)));
                --cRespuesta := array(i)||','|| cChar || '|' || cRespuesta ;
                --IF (cChar = 'S') THEN
                   -- API_GENERALES.API_LIBERAR_PLD(nCodCia,nCodEmpresa,1,TO_NUMBER(array(i)),nSetXml);
                --END IF;
            --END IF;
        --END LOOP;

    END API_LIBERAR_PLDS;
--
    PROCEDURE API_LIBERAR_PLD(nCodCia IN NUMBER, nCodEmpresa IN NUMBER,nIdCotizacion IN NUMBER, nIdPoliza IN NUMBER, nSetXml OUT CLOB) IS
    cCadena     VARCHAR2(10) := '';
    BEGIN

        IF (nIdPoliza != 0) THEN
            nSetXml := GENERALES_PLATAFORMA_DIGITAL.PRE_EMITE_POLIZA_NEW(nCodCia, nCodEmpresa, nIdCotizacion, cCadena, nIdPoliza);
            COMMIT;
        END IF;
    END API_LIBERAR_PLD;
    --
    PROCEDURE API_COTIZACION_PRE_EMITIR(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nIdPoliza IN NUMBER, nIdAseg IN NUMBER, nRFCT IN VARCHAR2,nRFCA1 IN VARCHAR2,nRFCFactura IN VARCHAR2,
                nNombreT IN VARCHAR2, nAppatT IN VARCHAR2, nApmatT IN VARCHAR2, nSexoT IN VARCHAR2, nFechaNacT IN VARCHAR2, nDireccionT IN VARCHAR2, nNumInteriorT IN VARCHAR2, nNumExteriorT IN VARCHAR2, 
                nCodColoniaT IN VARCHAR2, nCodProvresT IN VARCHAR2, nCodPosresT IN VARCHAR2, nLadaT IN VARCHAR2, nTelefonoT IN VARCHAR2, nEmailT IN VARCHAR2,
                nCodFormaCobro IN VARCHAR2, nCodEntidadFinan IN VARCHAR2,
                nCuentaB IN VARCHAR2, nCuentaC IN VARCHAR2, nNumTarjeta IN VARCHAR2, nFechaVen IN VARCHAR2, nNomTitular IN VARCHAR2, nCodPlanPago IN VARCHAR2,
                nNombreA1 IN VARCHAR2, nAppatA1 IN VARCHAR2, nApmatA1 IN VARCHAR2, nSexoA1 IN VARCHAR2, nFechaNacA1 IN VARCHAR2, nDireccionA1 IN VARCHAR2, nNumInteriorA1 IN VARCHAR2, nNumExteriorA1 IN VARCHAR2, 
                nCodColoniaA1 IN VARCHAR2, nCodProvresA1 IN VARCHAR2, nCodPosresA1 IN VARCHAR2, nLadaA1 IN VARCHAR2, nTelefonoA1 IN VARCHAR2, nEmailA1 IN VARCHAR2,
                nNombreA2 IN VARCHAR2, nAppatA2 IN VARCHAR2, nApmatA2 IN VARCHAR2, nSexoA2 IN VARCHAR2, nFechaNacA2 IN VARCHAR2, nDireccionA2 IN VARCHAR2, nNumInteriorA2 IN VARCHAR2, nNumExteriorA2 IN VARCHAR2, 
                nCodColoniaA2 IN VARCHAR2, nCodProvresA2 IN VARCHAR2, nCodPosresA2 IN VARCHAR2, nLadaA2 IN VARCHAR2, nTelefonoA2 IN VARCHAR2, nEmailA2 IN VARCHAR2,nNacionalidad IN VARCHAR2,nNacionalidadAseg1 IN VARCHAR2,nNacionalidadAseg2 IN VARCHAR2,
                ben1 IN VARCHAR2, ben2 IN VARCHAR2,
                nSetXml OUT CLOB) IS

       cadena VARCHAR2(5000);
       cadena1 VARCHAR2(5000);
       cCadena VARCHAR2(5000);

       cFechaHoy DATE := SYSDATE;
       cFechaUnAnno DATE := add_months(SYSDATE + 1, 12);
       cTipoDocIdentificacion VARCHAR2(10) := 'RFC';
       --cCodFormaCobro VARCHAR2(10) := 'CTC';
       --cCodEntidadFinan VARCHAR2(10) := '012';
       --cCodPlanPago VARCHAR2(10) := 'ANUA';
       cCodFormaCobro VARCHAR2(10) := nCodFormaCobro;
       cCodEntidadFinan VARCHAR2(10) := nCodEntidadFinan;
       cCodPlanPago VARCHAR2(10) := nCodPlanPago;
       cIndDeclara VARCHAR2(10) := 'N';
       --nNacionalidad VARCHAR2(6):= 'MEX';
       rfc VARCHAR2(50) := 'LOOA531113F15'; -- RFC PARA QUE NO PASE PLD

       cTipoIdTributaria VARCHAR2(10) := 'RFC';

        nCodFormaCobro1 VARCHAR2(100):=nCodFormaCobro;

       -- RFC GENERICO
       --cTipoIdTributaria VARCHAR2(10) := '';
       --cNumTributario VARCHAR2(50) := ''; -- RFC Vacio

    BEGIN
        EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';

        IF LENGTH(nCodFormaCobro)<1 THEN
            nCodFormaCobro1 := 'CTC';
        END IF;
        -- DOBLE VIDA
        IF (nIdAseg = 1) then
            -- CONTRATANTE
            cCadena := 'C,' || cTipoDocIdentificacion ||','|| nRFCT ||','|| nNombreT ||','|| nAppatT ||','|| nApmatT ||','|| nSexoT ||','|| nFechaNacT ||','||cTipoIdTributaria||','||nRFCFactura||',';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionT ||','|| nNumInteriorT ||','|| nNumExteriorT ||','|| nCodColoniaT ||','|| nCodProvresT ||','|| nCodPosresT ||','|| nLadaT ||','|| nTelefonoT ||','|| nEmailT ||','|| nNacionalidad ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,';
            -- CONCATENA
            cCadena := cCadena || '|';
            -- ASEGURADO CONTRATANTE
             cCadena := cCadena || 'A,' || cTipoDocIdentificacion ||','|| nRFCA1 ||','|| nNombreA1 ||','|| nAppatA1 ||','|| nApmatA1 ||','|| nSexoA1 ||','|| nFechaNacA1 ||','||cTipoIdTributaria||','||nRFCA1||',';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionA1 ||','|| nNumInteriorA1 ||','|| nNumExteriorA1 ||','|| nCodColoniaA1 ||','|| nCodProvresA1 ||','|| nCodPosresA1 ||','|| nLadaA1 ||','|| nTelefonoA1 ||','|| nEmailA1 ||','||nNacionalidadAseg1||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,';--,,,,,,';
            cCadena := cCadena || ben1;
            -- CONCATENA
            cCadena := cCadena || '|';
            -- ASEGURADO
            cCadena := cCadena || 'A,' || cTipoDocIdentificacion ||',,'|| nNombreA2 ||','|| nAppatA2 ||','|| nApmatA2 ||','|| nSexoA2 ||','|| nFechaNacA2 ||',,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionA2 ||','|| nNumInteriorA2 ||','|| nNumExteriorA2 ||','|| nCodColoniaA2 ||','|| nCodProvresA2 ||','|| nCodPosresA2 ||','|| nLadaA2 ||','|| nTelefonoA2 ||','|| nEmailA2 ||','||nNacionalidadAseg2||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||',,,,,,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,';--,,,,,,';
            cCadena := cCadena || ben2;
        END IF;
        -- INDIVUDUAL
        IF(nIdAseg = 0) then
            -- CONTRATANTE
            cCadena := 'C,' || cTipoDocIdentificacion ||','|| nRFCT ||','|| nNombreT ||','|| nAppatT ||','|| nApmatT ||','|| nSexoT ||','|| nFechaNacT ||','||cTipoIdTributaria||','||nRFCFactura||',';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionT ||','|| nNumInteriorT ||','|| nNumExteriorT ||','|| nCodColoniaT ||','|| nCodProvresT ||','|| nCodPosresT ||','|| nLadaT ||','|| nTelefonoT ||','|| nEmailT ||','|| nNacionalidad ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,';
            -- CONCATENA
            cCadena := cCadena || '|';
            -- ASEGURADO
           cCadena := cCadena || 'A,' || cTipoDocIdentificacion ||','|| nRFCA1 ||','|| nNombreA1 ||','|| nAppatA1 ||','|| nApmatA1 ||','|| nSexoA1 ||','|| nFechaNacA1 ||','||cTipoIdTributaria||','||nRFCA1||',';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionA1 ||','|| nNumInteriorA1 ||','|| nNumExteriorA1 ||','|| nCodColoniaA1 ||','|| nCodProvresA1 ||','|| nCodPosresA1 ||','|| nLadaA1 ||','|| nTelefonoA1 ||','|| nEmailA1 ||','||nNacionalidadAseg1||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,';--,,,,,,';
            cCadena := cCadena || ben1;
        END IF;
        -- DOS PERSONAS
        IF (nIdAseg = 2) then
            -- CONTRATANTE
            cCadena := 'C,' || cTipoDocIdentificacion ||','|| nRFCT ||','|| nNombreT ||','|| nAppatT ||','|| nApmatT ||','|| nSexoT ||','|| nFechaNacT ||','||cTipoIdTributaria||','||nRFCFactura||',';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionT ||','|| nNumInteriorT ||','|| nNumExteriorT ||','|| nCodColoniaT ||','|| nCodProvresT ||','|| nCodPosresT ||','|| nLadaT ||','|| nTelefonoT ||','|| nEmailT ||','|| nNacionalidad ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,';
            -- CONCATENA
            cCadena := cCadena || '|';
            -- ASEGURADO 
            cCadena := cCadena || 'A,' || cTipoDocIdentificacion ||','|| nRFCA1 ||','|| nNombreA1 ||','|| nAppatA1 ||','|| nApmatA1 ||','|| nSexoA1 ||','|| nFechaNacA1 ||','||cTipoIdTributaria||','||nRFCA1||',';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionA1 ||','|| nNumInteriorA1 ||','|| nNumExteriorA1 ||','|| nCodColoniaA1 ||','|| nCodProvresA1 ||','|| nCodPosresA1 ||','|| nLadaA1 ||','|| nTelefonoA1 ||','|| nEmailA1 ||','||nNacionalidadAseg1||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||',,,,,,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,';--,,,,,,';
            cCadena := cCadena || ben1;
        END IF;

        cadena := ''|| nCodCia ||','|| nCodEmpresa ||','|| nIdCotizacion ||','|| nIdAseg ||','|| cCadena;
       INSERT INTO API_LOG_EMISION (DESCRIPCION, FECHA,ID_COTIZACION) VALUES(cadena, sysdate,nIdCotizacion);
        --INSERT INTO CADENA_EMISION (TEXTO, FECHA) VALUES (cadena, sysdate);
        --nSetXml := '<DATA></DATA>';

        IF (nIdPoliza = 0) THEN
            nSetXml := GENERALES_PLATAFORMA_DIGITAL.PRE_EMITE_POLIZA_NEW(nCodCia, nCodEmpresa, nIdCotizacion, cCadena, NULL);
        END IF;
        IF (nIdPoliza != 0) THEN
            nSetXml := GENERALES_PLATAFORMA_DIGITAL.PRE_EMITE_POLIZA_NEW(nCodCia, nCodEmpresa, nIdCotizacion, cCadena, nIdPoliza);
        END IF;
        --PRE_EMITE_POLIZA_NEW(nCodCia, nCodEmpresa, nIdCotizacion, cCadena, cIdpOLIZA);

    END API_COTIZACION_PRE_EMITIR;

    PROCEDURE API_COTIZACION_PRE_EMITIR_CFDI(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nIdPoliza IN NUMBER, nIdAseg IN NUMBER, nRFCT IN VARCHAR2,nRFCA1 IN VARCHAR2,nRFCFactura IN VARCHAR2,
                nNombreT IN VARCHAR2, nAppatT IN VARCHAR2, nApmatT IN VARCHAR2, nSexoT IN VARCHAR2, nFechaNacT IN VARCHAR2, nDireccionT IN VARCHAR2, nNumInteriorT IN VARCHAR2, nNumExteriorT IN VARCHAR2, 
                nCodColoniaT IN VARCHAR2, nCodProvresT IN VARCHAR2, nCodPosresT IN VARCHAR2, nLadaT IN VARCHAR2, nTelefonoT IN VARCHAR2, nEmailT IN VARCHAR2,
                nCodFormaCobro IN VARCHAR2, nCodEntidadFinan IN VARCHAR2,
                nCuentaB IN VARCHAR2, nCuentaC IN VARCHAR2, nNumTarjeta IN VARCHAR2, nFechaVen IN VARCHAR2, nNomTitular IN VARCHAR2, nCodPlanPago IN VARCHAR2,
                nNombreA1 IN VARCHAR2, nAppatA1 IN VARCHAR2, nApmatA1 IN VARCHAR2, nSexoA1 IN VARCHAR2, nFechaNacA1 IN VARCHAR2, nDireccionA1 IN VARCHAR2, nNumInteriorA1 IN VARCHAR2, nNumExteriorA1 IN VARCHAR2, 
                nCodColoniaA1 IN VARCHAR2, nCodProvresA1 IN VARCHAR2, nCodPosresA1 IN VARCHAR2, nLadaA1 IN VARCHAR2, nTelefonoA1 IN VARCHAR2, nEmailA1 IN VARCHAR2,
                nNombreA2 IN VARCHAR2, nAppatA2 IN VARCHAR2, nApmatA2 IN VARCHAR2, nSexoA2 IN VARCHAR2, nFechaNacA2 IN VARCHAR2, nDireccionA2 IN VARCHAR2, nNumInteriorA2 IN VARCHAR2, nNumExteriorA2 IN VARCHAR2, 
                nCodColoniaA2 IN VARCHAR2, nCodProvresA2 IN VARCHAR2, nCodPosresA2 IN VARCHAR2, nLadaA2 IN VARCHAR2, nTelefonoA2 IN VARCHAR2, nEmailA2 IN VARCHAR2,nNacionalidad IN VARCHAR2,nNacionalidadAseg1 IN VARCHAR2,nNacionalidadAseg2 IN VARCHAR2,
                ben1 IN VARCHAR2, ben2 IN VARCHAR2, xInformacionFiscal IN XMLTYPE,
                nSetXml OUT CLOB) IS

       cadena VARCHAR2(5000);
       cadena1 VARCHAR2(5000);
       cCadena VARCHAR2(5000);

       cFechaHoy DATE := SYSDATE;
       cFechaUnAnno DATE := add_months(SYSDATE + 1, 12);
       cTipoDocIdentificacion VARCHAR2(10) := 'RFC';
       --cCodFormaCobro VARCHAR2(10) := 'CTC';
       --cCodEntidadFinan VARCHAR2(10) := '012';
       --cCodPlanPago VARCHAR2(10) := 'ANUA';
       cCodFormaCobro VARCHAR2(10) := nCodFormaCobro;
       cCodEntidadFinan VARCHAR2(10) := nCodEntidadFinan;
       cCodPlanPago VARCHAR2(10) := nCodPlanPago;
       cIndDeclara VARCHAR2(10) := 'N';
       --nNacionalidad VARCHAR2(6):= 'MEX';
       rfc VARCHAR2(50) := 'LOOA531113F15'; -- RFC PARA QUE NO PASE PLD

       cTipoIdTributaria VARCHAR2(10) := 'RFC';

        nCodFormaCobro1 VARCHAR2(100):=nCodFormaCobro;

       -- RFC GENERICO
       --cTipoIdTributaria VARCHAR2(10) := '';
       --cNumTributario VARCHAR2(50) := ''; -- RFC Vacio

    BEGIN
        EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';

        IF LENGTH(nCodFormaCobro)<1 THEN
            nCodFormaCobro1 := 'CTC';
        END IF;
        -- DOBLE VIDA
        IF (nIdAseg = 1) then
            -- CONTRATANTE
            cCadena := 'C,' || cTipoDocIdentificacion ||','|| nRFCT ||','|| nNombreT ||','|| nAppatT ||','|| nApmatT ||','|| nSexoT ||','|| nFechaNacT ||','||cTipoIdTributaria||','||nRFCFactura||',';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionT ||','|| nNumInteriorT ||','|| nNumExteriorT ||','|| nCodColoniaT ||','|| nCodProvresT ||','|| nCodPosresT ||','|| nLadaT ||','|| nTelefonoT ||','|| nEmailT ||','|| nNacionalidad ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,';
            -- CONCATENA
            cCadena := cCadena || '|';
            -- ASEGURADO CONTRATANTE
             cCadena := cCadena || 'A,' || cTipoDocIdentificacion ||','|| nRFCA1 ||','|| nNombreA1 ||','|| nAppatA1 ||','|| nApmatA1 ||','|| nSexoA1 ||','|| nFechaNacA1 ||','||cTipoIdTributaria||','||nRFCA1||',';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionA1 ||','|| nNumInteriorA1 ||','|| nNumExteriorA1 ||','|| nCodColoniaA1 ||','|| nCodProvresA1 ||','|| nCodPosresA1 ||','|| nLadaA1 ||','|| nTelefonoA1 ||','|| nEmailA1 ||','||nNacionalidadAseg1||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,';--,,,,,,';
            cCadena := cCadena || ben1;
            -- CONCATENA
            cCadena := cCadena || '|';
            -- ASEGURADO
            cCadena := cCadena || 'A,' || cTipoDocIdentificacion ||',,'|| nNombreA2 ||','|| nAppatA2 ||','|| nApmatA2 ||','|| nSexoA2 ||','|| nFechaNacA2 ||',,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionA2 ||','|| nNumInteriorA2 ||','|| nNumExteriorA2 ||','|| nCodColoniaA2 ||','|| nCodProvresA2 ||','|| nCodPosresA2 ||','|| nLadaA2 ||','|| nTelefonoA2 ||','|| nEmailA2 ||','||nNacionalidadAseg2||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||',,,,,,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,';--,,,,,,';
            cCadena := cCadena || ben2;
        END IF;
        -- INDIVUDUAL
        IF(nIdAseg = 0) then
            -- CONTRATANTE
            cCadena := 'C,' || cTipoDocIdentificacion ||','|| nRFCT ||','|| nNombreT ||','|| nAppatT ||','|| nApmatT ||','|| nSexoT ||','|| nFechaNacT ||','||cTipoIdTributaria||','||nRFCFactura||',';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionT ||','|| nNumInteriorT ||','|| nNumExteriorT ||','|| nCodColoniaT ||','|| nCodProvresT ||','|| nCodPosresT ||','|| nLadaT ||','|| nTelefonoT ||','|| nEmailT ||','|| nNacionalidad ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,';
            -- CONCATENA
            cCadena := cCadena || '|';
            -- ASEGURADO
           cCadena := cCadena || 'A,' || cTipoDocIdentificacion ||','|| nRFCA1 ||','|| nNombreA1 ||','|| nAppatA1 ||','|| nApmatA1 ||','|| nSexoA1 ||','|| nFechaNacA1 ||','||cTipoIdTributaria||','||nRFCA1||',';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionA1 ||','|| nNumInteriorA1 ||','|| nNumExteriorA1 ||','|| nCodColoniaA1 ||','|| nCodProvresA1 ||','|| nCodPosresA1 ||','|| nLadaA1 ||','|| nTelefonoA1 ||','|| nEmailA1 ||','||nNacionalidadAseg1||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,';--,,,,,,';
            cCadena := cCadena || ben1;
        END IF;
        -- DOS PERSONAS
        IF (nIdAseg = 2) then
            -- CONTRATANTE
            cCadena := 'C,' || cTipoDocIdentificacion ||','|| nRFCT ||','|| nNombreT ||','|| nAppatT ||','|| nApmatT ||','|| nSexoT ||','|| nFechaNacT ||','||cTipoIdTributaria||','||nRFCFactura||',';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionT ||','|| nNumInteriorT ||','|| nNumExteriorT ||','|| nCodColoniaT ||','|| nCodProvresT ||','|| nCodPosresT ||','|| nLadaT ||','|| nTelefonoT ||','|| nEmailT ||','|| nNacionalidad ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,';
            -- CONCATENA
            cCadena := cCadena || '|';
            -- ASEGURADO 
            cCadena := cCadena || 'A,' || cTipoDocIdentificacion ||','|| nRFCA1 ||','|| nNombreA1 ||','|| nAppatA1 ||','|| nApmatA1 ||','|| nSexoA1 ||','|| nFechaNacA1 ||','||cTipoIdTributaria||','||nRFCA1||',';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionA1 ||','|| nNumInteriorA1 ||','|| nNumExteriorA1 ||','|| nCodColoniaA1 ||','|| nCodProvresA1 ||','|| nCodPosresA1 ||','|| nLadaA1 ||','|| nTelefonoA1 ||','|| nEmailA1 ||','||nNacionalidadAseg1||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||',,,,,,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,';--,,,,,,';
            cCadena := cCadena || ben1;
        END IF;

        cadena := ''|| nCodCia ||','|| nCodEmpresa ||','|| nIdCotizacion ||','|| nIdAseg ||','|| cCadena;
       INSERT INTO API_LOG_EMISION (DESCRIPCION, FECHA,ID_COTIZACION) VALUES(cadena, sysdate,nIdCotizacion);
        --INSERT INTO CADENA_EMISION (TEXTO, FECHA) VALUES (cadena, sysdate);
        --nSetXml := '<DATA></DATA>';

        IF (nIdPoliza = 0) THEN
            nSetXml := GENERALES_PLATAFORMA_DIGITAL.PRE_EMITE_POLIZA_NEW_CFDI40(nCodCia, nCodEmpresa, nIdCotizacion, cCadena, NULL, xInformacionFiscal);
            --nSetXml := GENERALES_PLATAFORMA_DIGITAL.PRE_EMITE_POLIZA_NEW(nCodCia, nCodEmpresa, nIdCotizacion, cCadena, NULL);
        END IF;
        IF (nIdPoliza != 0) THEN
            nSetXml := GENERALES_PLATAFORMA_DIGITAL.PRE_EMITE_POLIZA_NEW_CFDI40(nCodCia, nCodEmpresa, nIdCotizacion, cCadena, nIdPoliza, xInformacionFiscal);
            --nSetXml := GENERALES_PLATAFORMA_DIGITAL.PRE_EMITE_POLIZA_NEW(nCodCia, nCodEmpresa, nIdCotizacion, cCadena, nIdPoliza);
        END IF;
        --PRE_EMITE_POLIZA_NEW(nCodCia, nCodEmpresa, nIdCotizacion, cCadena, cIdpOLIZA);

    END API_COTIZACION_PRE_EMITIR_CFDI;
    --
    PROCEDURE API_COTIZACION_PRE_EMITIR_V2(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nIdPoliza IN NUMBER, nIdAseg IN NUMBER, nRFCT IN VARCHAR2,
                nNombreT IN VARCHAR2, nAppatT IN VARCHAR2, nApmatT IN VARCHAR2, nSexoT IN VARCHAR2, nFechaNacT IN VARCHAR2, nDireccionT IN VARCHAR2, nNumInteriorT IN VARCHAR2, nNumExteriorT IN VARCHAR2, 
                nCodColoniaT IN VARCHAR2, nCodProvresT IN VARCHAR2, nCodPosresT IN VARCHAR2, nLadaT IN VARCHAR2, nTelefonoT IN VARCHAR2, nEmailT IN VARCHAR2, 
                nCodFormaCobro IN VARCHAR2, nCodEntidadFinan IN VARCHAR2,
                nCuentaB IN VARCHAR2, nCuentaC IN VARCHAR2, nNumTarjeta IN VARCHAR2, nFechaVen IN VARCHAR2, nNomTitular IN VARCHAR2, nCodPlanPago IN VARCHAR2,
                nNombreD IN VARCHAR2, nAppatD IN VARCHAR2, nApmatD IN VARCHAR2, nSexoD IN VARCHAR2, nFechaNacD IN VARCHAR2, nDireccionD IN VARCHAR2, nNumInteriorD IN VARCHAR2, nNumExteriorD IN VARCHAR2, 
                nCodColoniaD IN VARCHAR2, nCodProvresD IN VARCHAR2, nCodPosresD IN VARCHAR2, nLadaD IN VARCHAR2, nTelefonoD IN VARCHAR2, nEmailD IN VARCHAR2,
                ben1 IN VARCHAR2, ben2 IN VARCHAR2,
                nSetXml OUT CLOB) IS

       cadena VARCHAR2(5000);
       cCadena VARCHAR2(5000);

       cFechaHoy DATE := SYSDATE;
       cFechaUnAnno DATE := add_months(SYSDATE + 1, 12);
       cTipoDocIdentificacion VARCHAR2(10) := 'RFC';
       cCodFormaCobro VARCHAR2(10) := 'CTC';
       cCodEntidadFinan VARCHAR2(10) := '012';
       cCodPlanPago VARCHAR2(10) := 'ANUA';
       cIndDeclara VARCHAR2(10) := 'N';

       rfc VARCHAR2(50) := 'LOOA531113F15'; -- RFC PARA QUE NO PASE PLD

    BEGIN
        EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';

        cadena := ''|| nCodCia ||','|| nCodEmpresa ||','|| nIdCotizacion ||','|| nIdAseg ||','|| nRFCT ||','
        || nNombreT ||','|| nAppatT ||','|| nApmatT ||','|| nFechaNacT ||','|| nDireccionT ||','|| nNumInteriorT ||','|| nNumExteriorT ||','|| nLadaT ||','|| nTelefonoT ||','|| nEmailT ||',' 
        || nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||','|| nNombreD ||','|| nAppatD ||','|| nApmatD ||','|| nFechaNacD ||','|| nDireccionD ||','
        || nNumInteriorD ||','|| nNumExteriorD ||','|| nLadaD ||','|| nTelefonoD ||','|| nEmailD ||'';

        -- INSERT INTO datos (TEXTO, FECHA) VALUES (cadena, sysdate);

        IF (nIdAseg = 1) then
            -- TITULAR
            cCadena := ''|| cTipoDocIdentificacion ||','|| nRFCT ||','|| nNombreT ||','|| nAppatT ||','|| nApmatT ||',,'|| nFechaNacT ||',,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionT ||','|| nNumInteriorT ||','|| nNumExteriorT ||',,,,'|| nLadaT ||','|| nTelefonoT ||','|| nEmailT ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,,';
            -- CONCATENA
            cCadena := cCadena || '|';
            -- DEPENDIENTE
            cCadena := cCadena || ''|| cTipoDocIdentificacion ||',,'|| nNombreD ||','|| nAppatD ||','|| nApmatD ||',,'|| nFechaNacD ||',,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionD ||','|| nNumInteriorD ||','|| nNumExteriorD ||',,,,'|| nLadaD ||','|| nTelefonoD ||','|| nEmailD ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||',,,,,,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,,';

            /*cCadena := ''|| cTipoDocIdentificacion ||',,'|| nNombreD ||','|| nAppatD ||','|| nApmatD ||',,'|| nFechaNacD ||',,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionD ||','|| nNumInteriorD ||','|| nNumExteriorD ||',,,,'|| nLadaD ||','|| nTelefonoD ||','|| nEmailD ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,,';

            ccadena := cCadena || '|'|| cTipoDocIdentificacion ||',,'|| p_nNombreD ||',ESCAMILLA,TARCISIO,,07/08/1970,,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionT ||',44,B,,,,55,5530199059,'|| nEmailT ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||',123456789012345000,123456789,12345645645645,01/08/2022,ESTRADA ALFONSO CUALQUIERA,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,,';*/
        END IF;

        IF(nIdAseg = 0) then
            cCadena := ''|| cTipoDocIdentificacion ||','|| nRFCT ||','|| nNombreT ||','|| nAppatT ||','|| nApmatT ||',,'|| nFechaNacT ||',,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionT ||','|| nNumInteriorT ||','|| nNumExteriorT ||',,,,'|| nLadaT ||','|| nTelefonoT ||','|| nEmailT ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,,';
        END IF;

        IF (nIdAseg = 2) then
            cCadena := ''|| cTipoDocIdentificacion ||','|| nRFCT ||','|| nNombreT ||','|| nAppatT ||','|| nApmatT ||',,'|| nFechaNacT ||',,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionT ||','|| nNumInteriorT ||','|| nNumExteriorT ||',,,,'|| nLadaT ||','|| nTelefonoT ||','|| nEmailT ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||'';
        END IF;

        cadena := ''|| nCodCia ||','|| nCodEmpresa ||','|| nIdCotizacion ||','|| nIdAseg ||','|| cCadena;
        --INSERT INTO datos (TEXTO, FECHA) VALUES (cadena, sysdate);

        nSetXml := GENERALES_PLATAFORMA_DIGITAL.PRE_EMITE_POLIZA_NEW(nCodCia, nCodEmpresa, nIdCotizacion, cCadena);
    END API_COTIZACION_PRE_EMITIR_V2;
    --
    PROCEDURE API_COTIZACION_PRE_EMITIR_V3(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nIdAseg IN NUMBER, 
                nRFCT IN VARCHAR2,
                nNombreT IN VARCHAR2, nAppatT IN VARCHAR2, nApmatT IN VARCHAR2, nSexoT IN VARCHAR2, nFechaNacT IN VARCHAR2, nDireccionT IN VARCHAR2, nNumInteriorT IN VARCHAR2, nNumExteriorT IN VARCHAR2, nLadaT IN VARCHAR2, nTelefonoT IN VARCHAR2, nEmailT IN VARCHAR2, 
                nCuentaB IN VARCHAR2, nCuentaC IN VARCHAR2, nNumTarjeta IN VARCHAR2, nFechaVen IN VARCHAR2, nNomTitular IN VARCHAR2,
                nNombreD IN VARCHAR2, nAppatD IN VARCHAR2, nApmatD IN VARCHAR2, nSexoD IN VARCHAR2, nFechaNacD IN VARCHAR2, nDireccionD IN VARCHAR2, nNumInteriorD IN VARCHAR2, nNumExteriorD IN VARCHAR2, nLadaD IN VARCHAR2, nTelefonoD IN VARCHAR2, nEmailD IN VARCHAR2, 
                nSetXml OUT CLOB) IS

       cadena VARCHAR2(5000);
       cCadena VARCHAR2(5000);

       cFechaHoy DATE := SYSDATE;
       cFechaUnAnno DATE := add_months(SYSDATE + 1, 12);
       cTipoDocIdentificacion VARCHAR2(10) := 'RFC';
       cCodFormaCobro VARCHAR2(10) := 'CTC';
       cCodEntidadFinan VARCHAR2(10) := '012';
       cCodPlanPago VARCHAR2(10) := 'ANUA';
       cIndDeclara VARCHAR2(10) := 'N';

       rfc VARCHAR2(50) := 'LOOA531113F15'; -- RFC PARA QUE NO PASE PLD

    BEGIN
        EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';

        IF (nIdAseg = 1) then
            -- TITULAR
            cCadena := ''|| cTipoDocIdentificacion ||','|| nRFCT ||','|| nNombreT ||','|| nAppatT ||','|| nApmatT ||','|| nSexoT ||','|| nFechaNacT ||',,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionT ||','|| nNumInteriorT ||','|| nNumExteriorT ||',,,,'|| nLadaT ||','|| nTelefonoT ||','|| nEmailT ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,,';
            -- CONCATENA
            cCadena := cCadena || '|';
            -- DEPENDIENTE
            cCadena := cCadena || ''|| cTipoDocIdentificacion ||',,'|| nNombreD ||','|| nAppatD ||','|| nApmatD ||','|| nSexoD ||','|| nFechaNacD ||',,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionD ||','|| nNumInteriorD ||','|| nNumExteriorD ||',,,,'|| nLadaD ||','|| nTelefonoD ||','|| nEmailD ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||',,,,,,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,,';

            /*cCadena := ''|| cTipoDocIdentificacion ||',,'|| nNombreD ||','|| nAppatD ||','|| nApmatD ||',,'|| nFechaNacD ||',,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionD ||','|| nNumInteriorD ||','|| nNumExteriorD ||',,,,'|| nLadaD ||','|| nTelefonoD ||','|| nEmailD ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,,';

            ccadena := cCadena || '|'|| cTipoDocIdentificacion ||',,'|| p_nNombreD ||',ESCAMILLA,TARCISIO,,07/08/1970,,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionT ||',44,B,,,,55,5530199059,'|| nEmailT ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||',123456789012345000,123456789,12345645645645,01/08/2022,ESTRADA ALFONSO CUALQUIERA,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,,';*/
        END IF;

        IF(nIdAseg = 0) then
            cCadena := ''|| cTipoDocIdentificacion ||','|| nRFCT ||','|| nNombreT ||','|| nAppatT ||','|| nApmatT ||','|| nSexoT ||','|| nFechaNacT ||',,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionT ||','|| nNumInteriorT ||','|| nNumExteriorT ||',,,,'|| nLadaT ||','|| nTelefonoT ||','|| nEmailT ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,,';
        END IF;

        IF (nIdAseg = 2) then
            cCadena := ''|| cTipoDocIdentificacion ||','|| nRFCT ||','|| nNombreT ||','|| nAppatT ||','|| nApmatT ||','|| nSexoT ||','|| nFechaNacT ||',,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionT ||','|| nNumInteriorT ||','|| nNumExteriorT ||',,,,'|| nLadaT ||','|| nTelefonoT ||','|| nEmailT ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||'';
        END IF;

        cadena := ''|| nCodCia ||','|| nCodEmpresa ||','|| nIdCotizacion ||','|| nIdAseg ||','|| cCadena;


        nSetXml := GENERALES_PLATAFORMA_DIGITAL.PRE_EMITE_POLIZA_NEW(nCodCia, nCodEmpresa, nIdCotizacion, cCadena);
    END API_COTIZACION_PRE_EMITIR_V3;
    --
    PROCEDURE API_COTIZACION_PRE_EMITIR_V4(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nIdAseg IN NUMBER, nRFCT IN VARCHAR2,
                nNombreT IN VARCHAR2, nAppatT IN VARCHAR2, nApmatT IN VARCHAR2, nSexoT IN VARCHAR2, nFechaNacT IN VARCHAR2, nDireccionT IN VARCHAR2, nNumInteriorT IN VARCHAR2, nNumExteriorT IN VARCHAR2, nLadaT IN VARCHAR2, nTelefonoT IN VARCHAR2, nEmailT IN VARCHAR2, 
                nCuentaB IN VARCHAR2, nCuentaC IN VARCHAR2, nNumTarjeta IN VARCHAR2, nFechaVen IN VARCHAR2, nNomTitular IN VARCHAR2,
                nNombreD IN VARCHAR2, nAppatD IN VARCHAR2, nApmatD IN VARCHAR2, nSexoD IN VARCHAR2, nFechaNacD IN VARCHAR2, nDireccionD IN VARCHAR2, nNumInteriorD IN VARCHAR2, nNumExteriorD IN VARCHAR2, nLadaD IN VARCHAR2, nTelefonoD IN VARCHAR2, nEmailD IN VARCHAR2, 
                nSetXml OUT CLOB) IS

       cadena VARCHAR2(5000);
       cCadena VARCHAR2(5000);

       cFechaHoy DATE := SYSDATE;
       cFechaUnAnno DATE := add_months(SYSDATE + 1, 12);
       cTipoDocIdentificacion VARCHAR2(10) := 'RFC';
       cCodFormaCobro VARCHAR2(10) := 'CTC';
       cCodEntidadFinan VARCHAR2(10) := '012';
       cCodPlanPago VARCHAR2(10) := 'ANUA';
       cIndDeclara VARCHAR2(10) := 'N';

       rfc VARCHAR2(50) := 'LOOA531113F15'; -- RFC PARA QUE NO PASE PLD

    BEGIN
        EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
        -- DOBLE VIDA
        IF (nIdAseg = 1) then
            -- CONTRATANTE
            cCadena := 'C,' || cTipoDocIdentificacion ||','|| nRFCT ||','|| nNombreT ||','|| nAppatT ||','|| nApmatT ||','|| nSexoT ||','|| nFechaNacT ||',,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionT ||','|| nNumInteriorT ||','|| nNumExteriorT ||',,,,'|| nLadaT ||','|| nTelefonoT ||','|| nEmailT ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,';
            -- CONCATENA
            cCadena := cCadena || '|';
            -- ASEGURADO CONTRATANTE
            cCadena := cCadena || 'A,' || cTipoDocIdentificacion ||','|| nRFCT ||','|| nNombreT ||','|| nAppatT ||','|| nApmatT ||','|| nSexoT ||','|| nFechaNacT ||',,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionT ||','|| nNumInteriorT ||','|| nNumExteriorT ||',,,,'|| nLadaT ||','|| nTelefonoT ||','|| nEmailT ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,';
            -- CONCATENA
            cCadena := cCadena || '|';
            -- ASEGURADO
            cCadena := cCadena || 'A,' || cTipoDocIdentificacion ||',,'|| nNombreD ||','|| nAppatD ||','|| nApmatD ||','|| nSexoD ||','|| nFechaNacD ||',,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionD ||','|| nNumInteriorD ||','|| nNumExteriorD ||',,,,'|| nLadaD ||','|| nTelefonoD ||','|| nEmailD ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||',,,,,,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,';
        END IF;
        -- INDIVUDUAL
        IF(nIdAseg = 0) then
            -- CONTRATANTE
            cCadena := 'C,' || cTipoDocIdentificacion ||','|| nRFCT ||','|| nNombreT ||','|| nAppatT ||','|| nApmatT ||','|| nSexoT ||','|| nFechaNacT ||',,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionT ||','|| nNumInteriorT ||','|| nNumExteriorT ||',,,,'|| nLadaT ||','|| nTelefonoT ||','|| nEmailT ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,';
            -- CONCATENA
            cCadena := cCadena || '|';
            -- ASEGURADO
            cCadena := cCadena || 'A,' || cTipoDocIdentificacion ||','|| nRFCT ||','|| nNombreT ||','|| nAppatT ||','|| nApmatT ||','|| nSexoT ||','|| nFechaNacT ||',,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionT ||','|| nNumInteriorT ||','|| nNumExteriorT ||',,,,'|| nLadaT ||','|| nTelefonoT ||','|| nEmailT ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,';
        END IF;
        -- DOS PERSONAS
        IF (nIdAseg = 2) then
            -- CONTRATANTE
            cCadena := 'C,' || cTipoDocIdentificacion ||','|| nRFCT ||','|| nNombreT ||','|| nAppatT ||','|| nApmatT ||','|| nSexoT ||','|| nFechaNacT ||',,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionT ||','|| nNumInteriorT ||','|| nNumExteriorT ||',,,,'|| nLadaT ||','|| nTelefonoT ||','|| nEmailT ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||','|| nCuentaB ||','|| nCuentaC ||','|| nNumTarjeta ||','|| nFechaVen ||','|| nNomTitular ||',,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,';
            -- CONCATENA
            cCadena := cCadena || '|';
            -- ASEGURADO Y/O CONTRATANTE
            cCadena := cCadena || 'A,' || cTipoDocIdentificacion ||',,'|| nNombreD ||','|| nAppatD ||','|| nApmatD ||','|| nSexoD ||','|| nFechaNacD ||',,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaHoy ||','|| nDireccionD ||','|| nNumInteriorD ||','|| nNumExteriorD ||',,,,'|| nLadaD ||','|| nTelefonoD ||','|| nEmailD ||',';
            cCadena := cCadena || cCodFormaCobro ||','|| cCodEntidadFinan ||',,,,,,,';
            cCadena := cCadena || cFechaHoy ||','|| cFechaUnAnno ||','|| cCodPlanPago ||','|| cFechaHoy ||','|| cFechaUnAnno ||',,'|| cIndDeclara ||','|| cFechaHoy ||',,,,,,,';
        END IF;

        cadena := ''|| nCodCia ||','|| nCodEmpresa ||','|| nIdCotizacion ||','|| nIdAseg ||','|| cCadena;
        --INSERT INTO CADENA_EMISION (TEXTO, FECHA) VALUES (cadena, sysdate);

        nSetXml := GENERALES_PLATAFORMA_DIGITAL.PRE_EMITE_POLIZA_NEW(nCodCia, nCodEmpresa, nIdCotizacion, cCadena);
    END API_COTIZACION_PRE_EMITIR_V4;
    --
    PROCEDURE API_CONSULTA_CODIGO_POSTAL(pCatalogo IN NUMBER, pCODPOSTAL IN VARCHAR2, cXml OUT CLOB) IS
        pCODPAIS        VARCHAR2(100):= null;
        pCODESTADO      VARCHAR2(100):= null;
        pCODCIUDAD      VARCHAR2(100):= null;
        pCODMUNICIPIO   VARCHAR2(100):= null;
        pCODIGO_COLONIA VARCHAR2(100):= null;
    BEGIN
        cXml := GENERALES_PLATAFORMA_DIGITAL.CONSULTA_CODIGO_POSTAL(pCatalogo, pCODPOSTAL, pCODPAIS, pCODESTADO, pCODCIUDAD, pCODMUNICIPIO, pCODIGO_COLONIA);
    END API_CONSULTA_CODIGO_POSTAL;
    --
    PROCEDURE API_RECALCULAR_COTIZACION(p_nCodCia NUMBER, p_nCodEmpresa NUMBER, p_nIdCotizacion NUMBER,
                                  p_cIdTipoSeg VARCHAR2, p_cPlanCob VARCHAR2, p_cIndAsegModelo VARCHAR2,
                                  p_cIndCensoSubgrupo VARCHAR2, p_cIndListadoAseg VARCHAR2) IS
    BEGIN                                  
            GT_COTIZACIONES.RECALCULAR_COTIZACION (p_nCodCia , p_nCodEmpresa , p_nIdCotizacion ,
                                  p_cIdTipoSeg , p_cPlanCob , p_cIndAsegModelo ,
                                  p_cIndCensoSubgrupo , p_cIndListadoAseg );

    END API_RECALCULAR_COTIZACION;
    --
    PROCEDURE API_CONSULTA_FACTURA(nCodCia IN NUMBER, nIdPoliza IN NUMBER, nXml OUT CLOB) IS
    BEGIN
        nXml := GENERALES_PLATAFORMA_DIGITAL.CONSULTA_FACTURA(nCodCia, nIdPoliza);
    END API_CONSULTA_FACTURA;
    --
    FUNCTION CONTENEDOR_API(nBool BOOLEAN) return NUMBER IS
        nValor NUMBER;
    BEGIN
      nValor := CASE WHEN nBool THEN 1 ELSE 0 END;
      RETURN nValor;
    END CONTENEDOR_API;
    --
    PROCEDURE API_LIBERADA_PLD(nIdPoliza NUMBER, nRespuesta OUT VARCHAR2) IS
        nCodCia NUMBER := 1;
        nCodEmpresa NUMBER := 1;
    BEGIN
        nRespuesta := OC_POLIZAS.LIBERADA_PLD(nCodCia, nCodEmpresa, nIdPoliza);
    END API_LIBERADA_PLD;
    --
    PROCEDURE API_ACTUALIZAR_SUBIDADOC(nIdCotizacion IN NUMBER, nIdPoliza IN NUMBER,nRespuesta OUT INT) is
    BEGIN
        UPDATE API_DOCUMENTOS SET IDPOLIZA = nIdPoliza, IDCOTIZACION_API=nIdCotizacion WHERE IDCOTIZACION_API= nIdCotizacion;
        nRespuesta := 1;
    END API_ACTUALIZAR_SUBIDADOC;
    --
    PROCEDURE API_SUBIR_DOCUMENTO(nIdPoliza IN NUMBER, nTipo IN VARCHAR2, nDoc IN BLOB, nRespuesta OUT INT) IS
    BEGIN
        INSERT INTO API_DOCUMENTOS (IDPOLIZA, IDCOTIZACION_API, TIPO, DOCUMENTO, FECHA) VALUES (nIdPoliza,nIdPoliza, nTipo, nDoc, sysdate);
        nRespuesta := 1;
    END API_SUBIR_DOCUMENTO;
    --
    PROCEDURE API_SUBIR_PDF(nIdPoliza IN NUMBER, nDoc IN BLOB, nRespuesta OUT INT) IS
    --PROCEDURE API_SUBIR_PDF(nIdPoliza IN NUMBER, nTipo IN VARCHAR2, nDoc IN BLOB, nRespuesta OUT INT) IS
        ID_INSERT NUMBER;
    BEGIN
        SAVEPOINT INSERCION;
        INSERT INTO PDF (IDPOLIZA, DOCUMENTO, FECHA)
        VALUES 
        (nIdPoliza, nDoc, sysdate) returning IDDOC INTO ID_INSERT;
        nRespuesta := ID_INSERT;
    EXCEPTION
       WHEN DUP_VAL_ON_INDEX THEN
            nRespuesta := 0;
            ROLLBACK TO INSERCION;
       WHEN OTHERS THEN
            nRespuesta := 0;
            ROLLBACK TO INSERCION;
    END API_SUBIR_PDF;
    --
    PROCEDURE API_LIBERA_POLIZA(nIdPoliza IN NUMBER, nSalida OUT NUMBER) IS
        cChar   CHAR(1);
    BEGIN
        --cChar := 'a';
        --nSalida := 0;
        cChar := GENERALES_PLATAFORMA_DIGITAL.PLD_POLIZA_LIBERADA(nIdPoliza);
        nSalida := CASE WHEN cChar = 'S' THEN 1 ELSE 0 END;
        --nSalida := dbms_random.value(1,100);
        --INSERT INTO CADENA_EMISION (TEXTO, FECHA) VALUES (nIdPoliza, sysdate);
        --nRetorna := GENERALES_PLATAFORMA_DIGITAL.PLD_POLIZA_LIBERADA(nIdPoliza);
        --nRetorna := GENERALES_PLATAFORMA_DIGITAL.PLD_POLIZA_LIBERADA(numero);
        --INSERT INTO CADENA_EMISION (TEXTO, FECHA) VALUES (cChar, sysdate);
    END API_LIBERA_POLIZA;
    --
    PROCEDURE API_BLOQUEDA_POLIZA(nIdPoliza IN NUMBER, nSalida OUT NUMBER) IS
        cChar   CHAR(1);
    BEGIN
        cChar := 'a';
        nSalida := 0;
        cChar := GENERALES_PLATAFORMA_DIGITAL.PLD_POLIZA_BLOQUEDA(nIdPoliza);
        nSalida := 0;
        IF cChar = 'S' THEN
           nSalida := 1;
        END IF;

        ----INSERT INTO CADENA_EMISION (TEXTO, FECHA) VALUES (nIdPoliza, sysdate);
        --nRetorna := GENERALES_PLATAFORMA_DIGITAL.PLD_POLIZA_BLOQUEDA(nIdPoliza);
        --INSERT INTO CADENA_EMISION (TEXTO, FECHA) VALUES (nRetorna, sysdate);
    END API_BLOQUEDA_POLIZA;
    --
    PROCEDURE API_OBTENER_DOCUMENTO(nIdDoc IN NUMBER, nSalida OUT BLOB) IS
    BEGIN
        SELECT DOCUMENTO INTO nSalida FROM PDF WHERE IDDOC = nIdDoc;
    END API_OBTENER_DOCUMENTO;
    --
    PROCEDURE API_CONSULTA_NACION(nNaciones OUT CLOB) IS
    BEGIN
        select GENERALES_PLATAFORMA_DIGITAL.CATALOGO_GENERAL('NACION', NULL) into nNaciones from dual;
    END API_CONSULTA_NACION;
    --
    PROCEDURE API_CONSULTA_FORMAPAGO(nFormasPago OUT CLOB) IS
    BEGIN
        select GENERALES_PLATAFORMA_DIGITAL.CATALOGO_GENERAL('FORMPAGO', NULL) into nFormasPago from dual;
    END API_CONSULTA_FORMAPAGO;
    --
    PROCEDURE API_CONSULTA_RFC(nIdPoliza IN NUMBER, nRFC OUT CLOB) IS
    BEGIN
        SELECT NUM_DOC_IDENTIFICACION INTO nRFC FROM CLIENTES WHERE CODCLIENTE = (SELECT CODCLIENTE FROM POLIZAS WHERE IDPOLIZA = nIdPoliza);
    END API_CONSULTA_RFC;
    --
    PROCEDURE API_ENTIDADES_FINANCIERAS(cResult OUT CLOB)IS
        pCodEntidad varchar2(100) := null;
    BEGIN
        cResult:= GENERALES_PLATAFORMA_DIGITAL.CATALOGO_ENTIDAD_FINANCIERA(pCodEntidad);
    END API_ENTIDADES_FINANCIERAS;
    --
    PROCEDURE API_CONCEPTOS_PRIMA(nIdCotizacion IN NUMBER, cResult OUT CLOB) IS    
    BEGIN
        cResult := GENERALES_PLATAFORMA_DIGITAL.COTIZACION_CONCEPTOS_PRIMA(nIdCotizacion);     
    END API_CONCEPTOS_PRIMA;
    --
    PROCEDURE API_PARENTESCO(cResult OUT CLOB) IS
        pCodLista varchar2(100) := 'PARENT';
        pCodValor varchar2(100) := NULL;
    BEGIN
        cResult:= GENERALES_PLATAFORMA_DIGITAL.CATALOGO_GENERAL(pCodLista, pCodValor);
    END API_PARENTESCO;
    --
    PROCEDURE API_MUESTRA_POLIZAS(nIdPoliza IN NUMBER, cRFC IN VARCHAR2, pCodAgente IN VARCHAR2, cResult OUT CLOB) IS
        nCodCia NUMBER := 1;
        nNumRegIni  NUMBER := 1;
        nNumRegFin  NUMBER := 25;
        cadena VARCHAR2(5000);
    BEGIN
        --cadena := ''|| nCodCia ||','|| nIdPoliza ||','|| cRFC ||','|| pCodAgente ||','|| nNumRegIni ||','|| nNumRegFin;
        --INSERT INTO CADENA_EMISION (TEXTO, FECHA) VALUES (cadena, sysdate);
        cResult := GENERALES_PLATAFORMA_DIGITAL.MUESTRA_POLIZAS(nCodCia, nIdPoliza, cRFC, '',pCodAgente, nNumRegIni, nNumRegFin);
        --INSERT INTO CADENA_EMISION (TEXTO, FECHA) VALUES (cResult, sysdate);
    END API_MUESTRA_POLIZAS;
    --
    PROCEDURE API_PAGINA_POLIZA(nIdPoliza IN NUMBER, cRFC IN VARCHAR2, pCodAgente IN VARCHAR2,pNumPagina IN NUMBER,pNombre IN VARCHAR2, pFechaInicio IN VARCHAR2, pFechaFin IN VARCHAR2, pEstatus IN VARCHAR2, cResult OUT CLOB) IS
        --pEstatus    VARCHAR2(10);
        --pNombre     VARCHAR2(100):='';
        nNumRegIni  NUMBER := 1;
        nNumRegFin  NUMBER := 25;
        pCodCia     NUMBER  := 1;
        nFechaInicio    VARCHAR2(100):=null;
        nFechaFin   VARCHAR2(100):=null;
        CURSOR Q_ENACA IS


            SELECT XMLELEMENT("IDPOLIZA",           IDPOLIZA,     
                   XMLELEMENT("NUMPOLUNICO",        NUMPOLUNICO),
                   XMLELEMENT("NOMPAQ",             NOMPAQ),
                   XMLELEMENT("FECEMISION",         FECEMISION),
                   XMLELEMENT("FECINIVIG",          FECINIVIG),
                   XMLELEMENT("FECFINVIG",          FECFINVIG),
                   XMLELEMENT("STSPOLIZA",          STSPOLIZA),
                   XMLELEMENT("CLIENTE",      XMLATTRIBUTES("NOMBRE_CLIENTE",
                                                            "TELMOVIL",
                                                            "EMAIL"
                                                           )),
                   XMLELEMENT("NUM_COTIZACION",     NUM_COTIZACION),
                   XMLELEMENT("COD_AGENTE",         COD_AGENTE),
                   XMLELEMENT("COD_MONEDA",         COD_MONEDA),
                   XMLELEMENT("PRIMANETA_MONEDA",   PRIMANETA_MONEDA),                                                  
                   XMLELEMENT("REMXX",              REMPLAZO                                                  
                   )) XMLDATOS,
                   CODCIA,
                   CODEMPRESA,
                   IDPOLIZA
            FROM (
            SELECT 
                   P.CODCIA,
                   P.CODEMPRESA,
                   P.IDPOLIZA,
                   P.NUMPOLUNICO,
                   P.FECEMISION,
                   P.FECINIVIG,
                   P.FECFINVIG,
                   P.STSPOLIZA,                   
                   --OC_CLIENTES.NOMBRE_CLIENTE(P.CODCLIENTE) NOMBRE_CLIENTE,
                   TRIM(PNJ.Nombre) ||' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) || ' ' || DECODE(PNJ.ApeCasada,NULL,'', ' de ' ||PNJ.ApeCasada) NOMBRE_CLIENTE,
                   NVL(PNJ.TELMOVIL, PNJ.TELRES) TELMOVIL,
                   PNJ.EMAIL ,
                   P.NUM_COTIZACION,
                   P.COD_AGENTE  ,
                   P.COD_MONEDA,
                   P.PRIMANETA_MONEDA,
                   ANTERIOR.NOMBRECONTRATANTE NOMPAQ,
                   'REMXX'   REMPLAZO
            FROM POLIZAS P  INNER JOIN CLIENTES                 CLI         ON CLI.CodCliente = P.CODCLIENTE
                            INNER JOIN PERSONA_NATURAL_JURIDICA PNJ         ON CLI.Tipo_Doc_Identificacion = PNJ.Tipo_Doc_Identificacion AND CLI.Num_Doc_Identificacion  = PNJ.Num_Doc_Identificacion                            
                            LEFT JOIN COTIZACIONES              C           ON C.CODCIA = P.CODCIA AND C.CODEMPRESA = P.CODEMPRESA AND C.IDCOTIZACION = P.NUM_COTIZACION 
                            LEFT JOIN COTIZACIONES              ANTERIOR    ON ANTERIOR.CODCIA = C.CODCIA AND ANTERIOR.CODEMPRESA = C.CODEMPRESA AND ANTERIOR.IDCOTIZACION = C.NUMCOTIZACIONANT
            WHERE  P.CODCIA                     = NVL(pCodCia, 1)              
              AND  P.COD_AGENTE                 = DECODE(NVL(pCodAgente, '0'), '0', P.COD_AGENTE, pCodAgente)              
              AND  P.IDPOLIZA                   = DECODE(NVL(nIdPoliza, 0), 0,  P.IDPOLIZA,   nIdPoliza)
              AND  PNJ.NUM_DOC_IDENTIFICACION   = DECODE(cRFC, NULL, PNJ.NUM_DOC_IDENTIFICACION, cRFC)
              AND  C.IDCOTIZACION               !=0 
              AND  C.IDCOTIZACION IS NOT NULL
              AND NVL(C.INDCOTIZACIONWEB,'N')='S' AND NVL(C.INDCOTIZACIONBASEWEB,'N')='N'
              AND ANTERIOR.NOMBRECONTRATANTE IS NOT NULL
              AND (P.STSPOLIZA =pEstatus OR pEstatus is NULL)
              AND P.FECINIVIG <= TO_DATE(pFechaFin,'DD-MM-YYYY') AND P.FECINIVIG >= TO_DATE(pFechaInicio,'DD-MM-YYYY')

              --AND TRIM(PNJ.Nombre) ||' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) LIKE DECODE(pNombre, NULL, '%', replace(replace(pNombre, '%', '*'), '@', '%'))
              AND TRIM(PNJ.Nombre) ||' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) LIKE DECODE(pNombre, NULL, '%', (replace(pNombre, ' ', '%%')))
             ORDER BY decode(P.STSPOLIZA, 'PLD', 10, 'PRE', 20, 'EMI', 30, 40), P.IDPOLIZA DESC) ;         
        L_ENACA Q_ENACA%ROWTYPE ;

        CURSOR Q_DETALLE (nCODCIA NUMBER, nCODEMPRESA NUMBER, nIDPOLIZA NUMBER) IS
            SELECT XMLELEMENT("CERTIFICADO",   XMLATTRIBUTES("IDETPOL", 
                                                              "IDTIPOSEG",
                                                              "PLANCOB",
                                                              "STSDETALLE",
                                                              "FECINIVIG",
                                                              "FECFINVIG",
                                                              "NOMBRE_ASEG",
                                                              "MOTIVANUL",
                                                              "FECANUL",
                                                              "DESCPLAN",
                                                              "SUMA_ASEG_MONEDA"
                                                              )
                   ) XMLDATOS
            FROM (
            SELECT 
                   D.IDETPOL,
                   D.IDTIPOSEG,
                   D.PLANCOB,
                   D.STSDETALLE ,
                   D.FECINIVIG,
                   D.FECFINVIG,     
                   OC_PERSONA_NATURAL_JURIDICA.NOMBRE_PERSONA(D.COD_ASEGURADO) NOMBRE_ASEG,                                   
                   D.MOTIVANUL,
                   D.FECANUL,                       
                   PP.DESCPLAN,
                   D.SUMA_ASEG_MONEDA
            FROM DETALLE_POLIZA       D   LEFT  JOIN PLAN_DE_PAGOS        PP  ON PP.STSPLAN = 'ACT'         AND PP.CODPLANPAGO = D.CODPLANPAGO                 
            WHERE D.CODCIA     = nCODCIA      
              AND D.CODEMPRESA = nCODEMPRESA 
              AND D.IDPOLIZA   = nIDPOLIZA);
        L_DETAL Q_DETALLE%ROWTYPE ;


        LIN     CLOB;
        LINDETA CLOB;
        NUMREG  NUMBER;   
        nNumeroPolizas  NUMBER;
        nNumeroPaginas  NUMBER;
    BEGIN
        SELECT COUNT(*) INTO nNumeroPolizas
            FROM POLIZAS P  INNER JOIN CLIENTES                 CLI         ON CLI.CodCliente = P.CODCLIENTE
                            INNER JOIN PERSONA_NATURAL_JURIDICA PNJ         ON CLI.Tipo_Doc_Identificacion = PNJ.Tipo_Doc_Identificacion AND CLI.Num_Doc_Identificacion  = PNJ.Num_Doc_Identificacion                            
                            LEFT JOIN COTIZACIONES              C           ON C.CODCIA = P.CODCIA AND C.CODEMPRESA = P.CODEMPRESA AND C.IDCOTIZACION = P.NUM_COTIZACION 
                            LEFT JOIN COTIZACIONES              ANTERIOR    ON ANTERIOR.CODCIA = C.CODCIA AND ANTERIOR.CODEMPRESA = C.CODEMPRESA AND ANTERIOR.IDCOTIZACION = C.NUMCOTIZACIONANT
            WHERE  P.CODCIA                     = NVL(1, 1)              
              AND  P.COD_AGENTE                 = DECODE(NVL(pCodAgente, '0'), '0', P.COD_AGENTE, pCodAgente)              
              AND  P.IDPOLIZA                   = DECODE(NVL('', 0), 0,  P.IDPOLIZA,   '')
              AND  PNJ.NUM_DOC_IDENTIFICACION   = DECODE('', NULL, PNJ.NUM_DOC_IDENTIFICACION, '')
              AND  C.IDCOTIZACION               !=0 
              AND  C.IDCOTIZACION IS NOT NULL
              AND NVL(C.INDCOTIZACIONWEB,'N')='S' AND NVL(C.INDCOTIZACIONBASEWEB,'N')='N'
               AND ANTERIOR.NOMBRECONTRATANTE IS NOT NULL


              AND (P.STSPOLIZA =pEstatus OR pEstatus is NULL)

               --AND (P.STSPOLIZA = 'EMI' OR P.STSPOLIZA = 'PLD')
               --AND P.STSPOLIZA= DECODE(pEstatus, NULL,'%', REPLACE(pEstatus,' ', '%%'))  
               AND P.FECINIVIG <= TO_DATE(pFechaFin,'DD-MM-YYYY') AND P.FECINIVIG >= TO_DATE(pFechaInicio,'DD-MM-YYYY')
              --AND TRIM(PNJ.Nombre) ||' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) LIKE DECODE('', NULL, '%', replace(replace('', '%', '*'), '@', '%'))
              AND TRIM(PNJ.Nombre) ||' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) LIKE DECODE(pNombre, NULL, '%', (replace(pNombre, ' ', '%%')))
             ORDER BY decode(P.STSPOLIZA, 'PLD', 10, 'PRE', 20, 'EMI', 30, 40),P.IDPOLIZA DESC ; 
        nNumeroPaginas := ceil(nNumeroPolizas/15);

         NUMREG := 0;
        LIN := '<?xml version="1.0" encoding="UTF-8" ?><POLIZA>';
        IF(pNumPagina<=nNumeroPaginas AND pNumPagina>0) THEN
            nNumRegIni := 15*(pNumPagina-1)+1;
            nNumRegFin := nNumRegIni +14;
            OPEN Q_ENACA;
            LOOP
                FETCH Q_ENACA INTO L_ENACA;
                EXIT WHEN Q_ENACA%NOTFOUND;
                --
                NUMREG := NUMREG + 1;

                IF NUMREG BETWEEN nNumRegIni AND nNumRegFin THEN

                    LIN := LIN || L_ENACA.XMLDATOS.getclobval();
                    --        
                    LINDETA := '<CERTIFICADOS>';
                    OPEN Q_DETALLE (L_ENACA.CODCIA, L_ENACA.CODEMPRESA, L_ENACA.IDPOLIZA);        
                    LOOP
                        FETCH Q_DETALLE INTO L_DETAL;
                        EXIT WHEN Q_DETALLE%NOTFOUND;    
                        --  
                        LINDETA := LINDETA || L_DETAL.XMLDATOS.getclobval();
                        --                
                    END LOOP;
                    CLOSE Q_DETALLE;
                    --
                    LINDETA := LINDETA || '</CERTIFICADOS>';
                    --
                    LIN :=  GT_WEB_SERVICES.REPLACE_CLOB(LIN, '<REMXX>REMXX</REMXX>', LINDETA);

                END IF;
                --
                IF NUMREG = nNumRegFin THEN
                    EXIT;
                END IF;
            END LOOP;

        CLOSE Q_ENACA;
        IF(nIdPoliza>0) THEN 
          LIN :=  LIN || '<CONTROL><RESPONSE>TRUE</RESPONSE><TOTAL_PAGINAS>1</TOTAL_PAGINAS><TOTAL_POLIZAS>1</TOTAL_POLIZAS></CONTROL></POLIZA>';

        ELSE
          LIN :=  LIN || '<CONTROL><RESPONSE>TRUE</RESPONSE><TOTAL_PAGINAS>'||nNumeroPaginas||'</TOTAL_PAGINAS><TOTAL_POLIZAS>'||nNumeroPolizas||'</TOTAL_POLIZAS></CONTROL></POLIZA>';
        END IF;
       cResult:= LIN;  
       ELSE
        LIN:= '<POLIZA><CONTROL><RESPONSE>FALSE</RESPONSE><TOTAL_PAGINAS>'||nNumeroPaginas||'</TOTAL_PAGINAS><TOTAL_POLIZAS>'||nNumeroPolizas||'</TOTAL_POLIZAS></CONTROL></POLIZA>';
        cResult := LIN;
       END IF;
     -- DBMS_OUTPUT.PUT_LINE(nNumeroPolizas ||','||nNumeroPaginas||','||nNumRegIni||','||nNumRegFin);

    END;
    --
     PROCEDURE API_PAGINA_POLIZAS(nIdPoliza IN NUMBER, cRFC IN VARCHAR2, pCodAgente IN VARCHAR2,pNumPagina IN NUMBER,pNombre IN VARCHAR2, pFechaInicio IN VARCHAR2, pFechaFin IN VARCHAR2, pEstatus IN VARCHAR2,pPolizas IN VARCHAR2, cResult OUT CLOB) IS
        --pEstatus    VARCHAR2(10);
        --pNombre     VARCHAR2(100):='';
        nNumRegIni  NUMBER := 1;
        nNumRegFin  NUMBER := 25;
        pCodCia     NUMBER  := 1;
        nFechaInicio    VARCHAR2(100):=null;
        nFechaFin   VARCHAR2(100):=null;
        CURSOR Q_ENACA IS


            SELECT XMLELEMENT("IDPOLIZA",           IDPOLIZA,     
                   XMLELEMENT("NUMPOLUNICO",        NUMPOLUNICO),
                   XMLELEMENT("NOMPAQ",             NOMPAQ),
                   XMLELEMENT("FECEMISION",         FECEMISION),
                   XMLELEMENT("FECINIVIG",          FECINIVIG),
                   XMLELEMENT("FECFINVIG",          FECFINVIG),
                   XMLELEMENT("STSPOLIZA",          STSPOLIZA),
                   XMLELEMENT("CLIENTE",      XMLATTRIBUTES("NOMBRE_CLIENTE",
                                                            "TELMOVIL",
                                                            "EMAIL"
                                                           )),
                   XMLELEMENT("NUM_COTIZACION",     NUM_COTIZACION),
                   XMLELEMENT("COD_AGENTE",         COD_AGENTE),
                   XMLELEMENT("COD_MONEDA",         COD_MONEDA),
                   XMLELEMENT("PRIMANETA_MONEDA",   PRIMANETA_MONEDA),                                                  
                   XMLELEMENT("REMXX",              REMPLAZO                                                  
                   )) XMLDATOS,
                   CODCIA,
                   CODEMPRESA,
                   IDPOLIZA
            FROM (
            SELECT 
                   P.CODCIA,
                   P.CODEMPRESA,
                   P.IDPOLIZA,
                   P.NUMPOLUNICO,
                   P.FECEMISION,
                   P.FECINIVIG,
                   P.FECFINVIG,
                   P.STSPOLIZA,                   
                   --OC_CLIENTES.NOMBRE_CLIENTE(P.CODCLIENTE) NOMBRE_CLIENTE,
                   TRIM(PNJ.Nombre) ||' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) || ' ' || DECODE(PNJ.ApeCasada,NULL,'', ' de ' ||PNJ.ApeCasada) NOMBRE_CLIENTE,
                   NVL(PNJ.TELMOVIL, PNJ.TELRES) TELMOVIL,
                   PNJ.EMAIL ,
                   P.NUM_COTIZACION,
                   P.COD_AGENTE  ,
                   P.COD_MONEDA,
                   P.PRIMANETA_MONEDA,
                   ANTERIOR.NOMBRECONTRATANTE NOMPAQ,
                   'REMXX'   REMPLAZO
            FROM POLIZAS P  INNER JOIN CLIENTES                 CLI         ON CLI.CodCliente = P.CODCLIENTE
                            INNER JOIN PERSONA_NATURAL_JURIDICA PNJ         ON CLI.Tipo_Doc_Identificacion = PNJ.Tipo_Doc_Identificacion AND CLI.Num_Doc_Identificacion  = PNJ.Num_Doc_Identificacion                            
                            LEFT JOIN COTIZACIONES              C           ON C.CODCIA = P.CODCIA AND C.CODEMPRESA = P.CODEMPRESA AND C.IDCOTIZACION = P.NUM_COTIZACION 
                            LEFT JOIN COTIZACIONES              ANTERIOR    ON ANTERIOR.CODCIA = C.CODCIA AND ANTERIOR.CODEMPRESA = C.CODEMPRESA AND ANTERIOR.IDCOTIZACION = C.NUMCOTIZACIONANT
            WHERE  P.CODCIA                     = NVL(pCodCia, 1)              
              AND  P.COD_AGENTE                 = DECODE(NVL(pCodAgente, '0'), '0', P.COD_AGENTE, pCodAgente)              
              AND  P.IDPOLIZA                   = DECODE(NVL(nIdPoliza, 0), 0,  P.IDPOLIZA,   nIdPoliza)
              AND  PNJ.NUM_DOC_IDENTIFICACION   = DECODE(cRFC, NULL, PNJ.NUM_DOC_IDENTIFICACION, cRFC)
              AND  C.IDCOTIZACION               !=0 
              AND  C.IDCOTIZACION IS NOT NULL
              AND NVL(C.INDCOTIZACIONWEB,'N')='S' AND NVL(C.INDCOTIZACIONBASEWEB,'N')='N'
              AND ANTERIOR.NOMBRECONTRATANTE IS NOT NULL
              AND (P.STSPOLIZA =pEstatus OR pEstatus is NULL AND P.STSPOLIZA<>'SOL')
              AND P.FECINIVIG <= TO_DATE(pFechaFin,'DD-MM-YYYY') AND P.FECINIVIG >= TO_DATE(pFechaInicio,'DD-MM-YYYY')
              AND P.IDPOLIZA in( select regexp_substr(pPolizas,'[^,]+', 1, level) from dual
                                connect by regexp_substr(pPolizas, '[^,]+', 1, level) is not null )
              --AND TRIM(PNJ.Nombre) ||' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) LIKE DECODE(pNombre, NULL, '%', replace(replace(pNombre, '%', '*'), '@', '%'))
              AND TRIM(PNJ.Nombre) ||' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) LIKE DECODE(pNombre, NULL, '%', (replace(pNombre, ' ', '%%')))
             ORDER BY decode(P.STSPOLIZA, 'PLD', 10, 'PRE', 20, 'EMI', 30, 40), P.IDPOLIZA DESC) ;         
        L_ENACA Q_ENACA%ROWTYPE ;

        CURSOR Q_DETALLE (nCODCIA NUMBER, nCODEMPRESA NUMBER, nIDPOLIZA NUMBER) IS
            SELECT XMLELEMENT("CERTIFICADO",   XMLATTRIBUTES("IDETPOL", 
                                                              "IDTIPOSEG",
                                                              "PLANCOB",
                                                              "STSDETALLE",
                                                              "FECINIVIG",
                                                              "FECFINVIG",
                                                              "NOMBRE_ASEG",
                                                              "MOTIVANUL",
                                                              "FECANUL",
                                                              "DESCPLAN",
                                                              "SUMA_ASEG_MONEDA"
                                                              )
                   ) XMLDATOS
            FROM (
            SELECT 
                   D.IDETPOL,
                   D.IDTIPOSEG,
                   D.PLANCOB,
                   D.STSDETALLE ,
                   D.FECINIVIG,
                   D.FECFINVIG,     
                   OC_PERSONA_NATURAL_JURIDICA.NOMBRE_PERSONA(D.COD_ASEGURADO) NOMBRE_ASEG,                                   
                   D.MOTIVANUL,
                   D.FECANUL,                       
                   PP.DESCPLAN,
                   D.SUMA_ASEG_MONEDA
            FROM DETALLE_POLIZA       D   LEFT  JOIN PLAN_DE_PAGOS        PP  ON PP.STSPLAN = 'ACT'         AND PP.CODPLANPAGO = D.CODPLANPAGO                 
            WHERE D.CODCIA     = nCODCIA      
              AND D.CODEMPRESA = nCODEMPRESA 
              AND D.IDPOLIZA   = nIDPOLIZA);
        L_DETAL Q_DETALLE%ROWTYPE ;


        LIN     CLOB;
        LINDETA CLOB;
        NUMREG  NUMBER;   
        nNumeroPolizas  NUMBER;
        nNumeroPaginas  NUMBER;
    BEGIN
        SELECT COUNT(*) INTO nNumeroPolizas
            FROM POLIZAS P  INNER JOIN CLIENTES                 CLI         ON CLI.CodCliente = P.CODCLIENTE
                            INNER JOIN PERSONA_NATURAL_JURIDICA PNJ         ON CLI.Tipo_Doc_Identificacion = PNJ.Tipo_Doc_Identificacion AND CLI.Num_Doc_Identificacion  = PNJ.Num_Doc_Identificacion                            
                            LEFT JOIN COTIZACIONES              C           ON C.CODCIA = P.CODCIA AND C.CODEMPRESA = P.CODEMPRESA AND C.IDCOTIZACION = P.NUM_COTIZACION 
                            LEFT JOIN COTIZACIONES              ANTERIOR    ON ANTERIOR.CODCIA = C.CODCIA AND ANTERIOR.CODEMPRESA = C.CODEMPRESA AND ANTERIOR.IDCOTIZACION = C.NUMCOTIZACIONANT
            WHERE  P.CODCIA                     = NVL(1, 1)              
              AND  P.COD_AGENTE                 = DECODE(NVL(pCodAgente, '0'), '0', P.COD_AGENTE, pCodAgente)              
              AND  P.IDPOLIZA                   = DECODE(NVL('', 0), 0,  P.IDPOLIZA,   '')
              AND  PNJ.NUM_DOC_IDENTIFICACION   = DECODE('', NULL, PNJ.NUM_DOC_IDENTIFICACION, '')
              AND  C.IDCOTIZACION               !=0 
              AND  C.IDCOTIZACION IS NOT NULL
              AND NVL(C.INDCOTIZACIONWEB,'N')='S' AND NVL(C.INDCOTIZACIONBASEWEB,'N')='N'
               AND ANTERIOR.NOMBRECONTRATANTE IS NOT NULL


              AND (P.STSPOLIZA =pEstatus OR pEstatus is NULL AND P.STSPOLIZA<>'SOL')
                AND P.IDPOLIZA in( select regexp_substr(pPolizas,'[^,]+', 1, level) from dual
                                connect by regexp_substr(pPolizas, '[^,]+', 1, level) is not null )
               --AND (P.STSPOLIZA = 'EMI' OR P.STSPOLIZA = 'PLD')
               --AND P.STSPOLIZA= DECODE(pEstatus, NULL,'%', REPLACE(pEstatus,' ', '%%'))  
               AND P.FECINIVIG <= TO_DATE(pFechaFin,'DD-MM-YYYY') AND P.FECINIVIG >= TO_DATE(pFechaInicio,'DD-MM-YYYY')
              --AND TRIM(PNJ.Nombre) ||' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) LIKE DECODE('', NULL, '%', replace(replace('', '%', '*'), '@', '%'))
              AND TRIM(PNJ.Nombre) ||' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) LIKE DECODE(pNombre, NULL, '%', (replace(pNombre, ' ', '%%')))
             ORDER BY decode(P.STSPOLIZA, 'PLD', 10, 'PRE', 20, 'EMI', 30, 40),P.IDPOLIZA DESC ; 
        nNumeroPaginas := ceil(nNumeroPolizas/15);

         NUMREG := 0;
        LIN := '<?xml version="1.0" encoding="UTF-8" ?><POLIZA>';
        IF(pNumPagina<=nNumeroPaginas AND pNumPagina>0) THEN
            nNumRegIni := 15*(pNumPagina-1)+1;
            nNumRegFin := nNumRegIni +14;
            OPEN Q_ENACA;
            LOOP
                FETCH Q_ENACA INTO L_ENACA;
                EXIT WHEN Q_ENACA%NOTFOUND;
                --
                NUMREG := NUMREG + 1;

                IF NUMREG BETWEEN nNumRegIni AND nNumRegFin THEN

                    LIN := LIN || L_ENACA.XMLDATOS.getclobval();
                    --        
                    LINDETA := '<CERTIFICADOS>';
                    OPEN Q_DETALLE (L_ENACA.CODCIA, L_ENACA.CODEMPRESA, L_ENACA.IDPOLIZA);        
                    LOOP
                        FETCH Q_DETALLE INTO L_DETAL;
                        EXIT WHEN Q_DETALLE%NOTFOUND;    
                        --  
                        LINDETA := LINDETA || L_DETAL.XMLDATOS.getclobval();
                        --                
                    END LOOP;
                    CLOSE Q_DETALLE;
                    --
                    LINDETA := LINDETA || '</CERTIFICADOS>';
                    --
                    LIN :=  GT_WEB_SERVICES.REPLACE_CLOB(LIN, '<REMXX>REMXX</REMXX>', LINDETA);

                END IF;
                --
                IF NUMREG = nNumRegFin THEN
                    EXIT;
                END IF;
            END LOOP;

        CLOSE Q_ENACA;
        IF(nIdPoliza>0) THEN 
          LIN :=  LIN || '<CONTROL><RESPONSE>TRUE</RESPONSE><TOTAL_PAGINAS>1</TOTAL_PAGINAS><TOTAL_POLIZAS>1</TOTAL_POLIZAS></CONTROL></POLIZA>';

        ELSE
          LIN :=  LIN || '<CONTROL><RESPONSE>TRUE</RESPONSE><TOTAL_PAGINAS>'||nNumeroPaginas||'</TOTAL_PAGINAS><TOTAL_POLIZAS>'||nNumeroPolizas||'</TOTAL_POLIZAS></CONTROL></POLIZA>';
        END IF;
       cResult:= LIN;  
       ELSE
        LIN:= '<POLIZA><CONTROL><RESPONSE>FALSE</RESPONSE><TOTAL_PAGINAS>'||nNumeroPaginas||'</TOTAL_PAGINAS><TOTAL_POLIZAS>'||nNumeroPolizas||'</TOTAL_POLIZAS></CONTROL></POLIZA>';
        cResult := LIN;
       END IF;
     -- DBMS_OUTPUT.PUT_LINE(nNumeroPolizas ||','||nNumeroPaginas||','||nNumRegIni||','||nNumRegFin);

    END;
    --
    PROCEDURE API_PAGINA_COTIZACIONES(nIdCotizacion IN NUMBER, nCodAgente IN NUMBER,nEstatus IN VARCHAR2, nNumPagina IN NUMBER,nNombre in VARCHAR2,nFechaInicio in VARCHAR2,nFechaFin in VARCHAR2,nCotizaciones in VARCHAR2,  cResult OUT CLOB) IS
        pEstatus        VARCHAR2(10):= NULL;   --Todos los estatus
        nNum            NUMBER := 0;    
        nCotInicial     NUMBER:= 0;
        nCOtFinal       NUMBER:=0;
        nNumTotalPag    NUMBER:=0;
        pNombre         VARCHAR2(100):=nNombre;
        --pFechaInicio    VARCHAR2(50):='12/12/2020';
        --pFechaFin       VARCHAR2(50):='16/12/2020';
        nNumCotizaciones    NUMBER :=0;

        CURSOR Q_COTI IS
          SELECT XMLELEMENT("COTIZACION",  XMLATTRIBUTES("IDCOTIZACION" , 
                                                         "FECHA_COTIZACION",  
                                                         "FECHA_INI_VIG",
                                                         "FECHA_FIN_VIG",
                                                         "FECHA_VENCIMIENTO",  
                                                         "ESTAUS_COTIZACION",   
                                                         "PORCENTAJE_VIGENCIA",   
                                                         "NUM_UNI_COTIZACION",
                                                         "NOMBRE",
                                                         "SUMA_ASEGURADA",
                                                         "PRIMA_COTIZADA",
                                                         "ES_POLIZA_EMITIDA",
                                                         "IDPOLIZA",
                                                         "NUM_RENOVACION_POL",
                                                         "CODAGENTE")) DATOSXML 
            FROM (                                                         
                SELECT A.IDCOTIZACION, 
                       A.FECCOTIZACION                                                      FECHA_COTIZACION,
                       A.FECFINVIGCOT                                                       FECHA_INI_VIG,
                       A.FECFINVIGCOT                                                       FECHA_FIN_VIG,
                       A.FECVENCECOTIZACION                                                 FECHA_VENCIMIENTO,
                       A.STSCOTIZACION                                                      ESTAUS_COTIZACION,
                       DECODE(SIGN(TRUNC((((A.FECVENCECOTIZACION - A.FECCOTIZACION) * 
                             (A.FECVENCECOTIZACION-(TRUNC(SYSDATE)-3)) ) / 10))), -1, 0, 
                             CASE WHEN TRUNC(CEIL((((A.FECVENCECOTIZACION - A.FECCOTIZACION) *
                             (A.FECVENCECOTIZACION-(TRUNC(SYSDATE)-3)) ) / 10)),1) > 100 THEN 0 ELSE 
                             TRUNC(CEIL((((A.FECVENCECOTIZACION - A.FECCOTIZACION) *
                             (A.FECVENCECOTIZACION-(TRUNC(SYSDATE)-3)) ) / 10)),1)END)        PORCENTAJE_VIGENCIA,
                       A.NUMUNICOCOTIZACION                                                 NUM_UNI_COTIZACION,
                       A.NOMBRECONTRATANTE                                                  NOMBRE,
                       A.SUMAASEGCOTMONEDA                                                  SUMA_ASEGURADA,
                       A.PRIMACOTMONEDA                                                     PRIMA_COTIZADA,
                       DECODE(A.IDPOLIZA, NULL, 'N', 'S')                                   ES_POLIZA_EMITIDA,
                       A.IDPOLIZA                                                           IDPOLIZA,
                       A.NUMPOLRENOVACION                                                   NUM_RENOVACION_POL,
                       A.CODAGENTE,
                       NVL(B.NOMBRECONTRATANTE, P.DESC_PLAN)                                NOM_PRODUC               
                FROM COTIZACIONES A LEFT JOIN COTIZACIONES      B ON B.CODCIA       = A.CODCIA      AND B.CODEMPRESA    = A.CODEMPRESA AND B.IDCOTIZACION = A.NUMCOTIZACIONANT  
                                    LEFT JOIN PLAN_COBERTURAS   P ON P.CODCIA       = A.CODCIA      AND P.CODEMPRESA    = A.CODEMPRESA AND P.IDTIPOSEG    = A.IDTIPOSEG   AND P.PLANCOB       = A.PLANCOB 
                 WHERE A.IDCOTIZACION        = DECODE(NVL(nIdCotizacion, 0), 0, A.IDCOTIZACION, nIdCotizacion)       
                   AND A.CODAGENTE           = nCodAgente
                   AND TRUNC(SYSDATE) BETWEEN  TRUNC(A.FECCOTIZACION) AND TRUNC(A.FECVENCECOTIZACION)
                   AND A.FECCOTIZACION <= TO_DATE(nFechaFin,'DD-MM-YYYY') AND A.FECCOTIZACION >= TO_DATE(nFechaInicio,'DD-MM-YYYY')
                   --AND (A.FECCOTIZACION) BETWEEN nFechaInicio AND nFechaFin --<= nFechaFin AND A.FECCOTIZACION >= nFechaInicio
                   AND A.NOMBRECONTRATANTE <> '{NOMBRE}'
                   AND A.CODCIA = 1
                   AND A.CODEMPRESA = 1
                   AND A.STSCOTIZACION  NOT IN ('COTIZA')
                   AND DECODE(A.IDPOLIZA,NULL,'N','S') = 'N'
                   AND NVL(A.IndCotizacionWeb,'N') = 'S' AND NVL(A.IndCotizacionBaseWeb,'N')='N'
                   AND A.STSCOTIZACION = DECODE(nEstatus, NULL, A.STSCOTIZACION, nEstatus)
                   AND A.IDCOTIZACION IN( select regexp_substr(nCotizaciones,'[^,]+', 1, level) from dual
                                connect by regexp_substr(nCotizaciones, '[^,]+', 1, level) is not null )
                   AND A.NOMBRECONTRATANTE LIKE DECODE(pNombre, NULL, '%', (replace(pNombre, ' ', '%%')))
                   --AND A.NOMBRECONTRATANTE LIKE DECODE(pNombre, NULL, '%', replace(replace(pNombre, '%', '*'), '@', '%'))

                ORDER BY A.IDCOTIZACION DESC, decode(a.STSCOTIZACION, 'ANPOLE', 40, 'COTIZA', 10, 'EMITID', decode(ES_POLIZA_EMITIDA, 'S', 25, 'N', 20), 'POLEMI', 30, 50) DESC); 
        R_COTI Q_COTI%ROWTYPE;
        --
        CATA CLOB;
        --            
    BEGIN
            SELECT count(*) INTO nNumCotizaciones

                FROM COTIZACIONES A LEFT JOIN COTIZACIONES      B ON B.CODCIA       = A.CODCIA      AND B.CODEMPRESA    = A.CODEMPRESA AND B.IDCOTIZACION = A.NUMCOTIZACIONANT  
                                    LEFT JOIN PLAN_COBERTURAS   P ON P.CODCIA       = A.CODCIA      AND P.CODEMPRESA    = A.CODEMPRESA AND P.IDTIPOSEG    = A.IDTIPOSEG   AND P.PLANCOB       = A.PLANCOB 
                 WHERE A.IDCOTIZACION        = DECODE(NVL(0, 0), 0, A.IDCOTIZACION, 0)       
                   AND A.CODAGENTE           = nCodAgente
                   AND TRUNC(SYSDATE) BETWEEN  TRUNC(A.FECCOTIZACION) AND TRUNC(A.FECVENCECOTIZACION)
                   --AND (A.FECCOTIZACION) BETWEEN nFechaInicio AND nFechaFin
                   AND A.FECCOTIZACION <= TO_DATE(nFechaFin,'DD-MM-YYYY') AND A.FECCOTIZACION >= TO_DATE(nFechaInicio,'DD-MM-YYYY')
                   AND A.NOMBRECONTRATANTE <> '{NOMBRE}'
                   AND A.CODCIA = 1
                   AND A.CODEMPRESA = 1
                   AND A.STSCOTIZACION  NOT IN ('COTIZA')
                   AND DECODE(A.IDPOLIZA,NULL,'N','S') = 'N'
                   AND NVL(A.IndCotizacionWeb,'N') = 'S' AND NVL(A.IndCotizacionBaseWeb,'N') = 'N'
                   AND A.STSCOTIZACION = DECODE(nEstatus, NULL, A.STSCOTIZACION, nEstatus)
                    AND A.IDCOTIZACION IN( select regexp_substr(nCotizaciones,'[^,]+', 1, level) from dual
                                connect by regexp_substr(nCotizaciones, '[^,]+', 1, level) is not null )
                   AND A.NOMBRECONTRATANTE LIKE DECODE(pNombre, NULL, '%', (replace(pNombre, ' ', '%%')));
                   --AND A.NOMBRECONTRATANTE LIKE DECODE(pNombre, NULL, '%', replace(replace(pNombre, '%', '*'), '@', '%'));
                  -- AND A.NOMBRECONTRATANTE LIKE DECODE('', NULL, '%', replace(replace('', '%', '*'), '@', '%'));

                --AQUÃƒÂ¿ ES DONDE SE REALIZARA LA DIVISIÃƒâ€œN DE LAS PÃƒÂ¿GINAS
                nNumTotalPag := ceil(nNumCotizaciones/15);
                CATA := '<?xml version="1.0" encoding="UTF-8" ?><COTIZACIONES>';

                IF(nNumPagina<=nNumTotalPag AND nNumPagina > 0) THEN 
                nCotInicial := 15*(nNumPagina-1)+1;

                nCOtFinal := nCotInicial +14;
                OPEN Q_COTI;
                LOOP
                    FETCH Q_COTI INTO R_COTI;
                    EXIT WHEN Q_COTI%NOTFOUND;
                    --
                    nNum := nNum + 1;
                    IF (nNum BETWEEN nCotInicial and nCOtFinal) or nCotInicial = 0 THEN 
                        CATA := CATA || R_COTI.DATOSXML.getclobval();
                    END IF;
                    --
                END LOOP;
                --    
                CLOSE Q_COTI;
                IF(nIdCotizacion>0) THEN
                    CATA :=  CATA || '<CONTROL><RESPONSE>TRUE</RESPONSE><TOTAL_PAGINAS>1</TOTAL_PAGINAS><TOTAL_COTIZACIONES>1</TOTAL_COTIZACIONES></CONTROL></COTIZACIONES>';
                    cResult := CATA;
                    --DBMS_OUTPUT.PUT_LINE(CATA);
                ELSE
                    CATA :=  CATA || '<CONTROL><RESPONSE>TRUE</RESPONSE><TOTAL_PAGINAS>'||nNumTotalPag||'</TOTAL_PAGINAS><TOTAL_COTIZACIONES>'||nNumCotizaciones||'</TOTAL_COTIZACIONES></CONTROL></COTIZACIONES>';
                    cResult := CATA;
                END IF;
                ELSE
                CATA:= '<COTIZACIONES><CONTROL><RESPONSE>FALSE</RESPONSE><TOTAL_PAGINAS>'||nNumTotalPag||'</TOTAL_PAGINAS><TOTAL_COTIZACIONES>'||nNumCotizaciones||'</TOTAL_COTIZACIONES></CONTROL></COTIZACIONES>';
                cResult := CATA;
               -- DBMS_OUTPUT.PUT_LINE(CATA);

                 END IF;            
    END;

    --
     PROCEDURE API_PAGINA_COTIZACION(nIdCotizacion IN NUMBER, nCodAgente IN NUMBER,nEstatus IN VARCHAR2, nNumPagina IN NUMBER,nNombre in VARCHAR2,nFechaInicio in VARCHAR2,nFechaFin in VARCHAR2, cResult OUT CLOB) IS
        pEstatus        VARCHAR2(10):= NULL;   --Todos los estatus
        nNum            NUMBER := 0;    
        nCotInicial     NUMBER:= 0;
        nCOtFinal       NUMBER:=0;
        nNumTotalPag    NUMBER:=0;
        pNombre         VARCHAR2(100):=nNombre;
        --pFechaInicio    VARCHAR2(50):='12/12/2020';
        --pFechaFin       VARCHAR2(50):='16/12/2020';
        nNumCotizaciones    NUMBER :=0;

        CURSOR Q_COTI IS
          SELECT XMLELEMENT("COTIZACION",  XMLATTRIBUTES("IDCOTIZACION" , 
                                                         "FECHA_COTIZACION",  
                                                         "FECHA_INI_VIG",
                                                         "FECHA_FIN_VIG",
                                                         "FECHA_VENCIMIENTO",  
                                                         "ESTAUS_COTIZACION",   
                                                         "PORCENTAJE_VIGENCIA",   
                                                         "NUM_UNI_COTIZACION",
                                                         "NOMBRE",
                                                         "SUMA_ASEGURADA",
                                                         "PRIMA_COTIZADA",
                                                         "ES_POLIZA_EMITIDA",
                                                         "IDPOLIZA",
                                                         "NUM_RENOVACION_POL",
                                                         "CODAGENTE")) DATOSXML 
            FROM (                                                         
                SELECT A.IDCOTIZACION, 
                       A.FECCOTIZACION                                                      FECHA_COTIZACION,
                       A.FECFINVIGCOT                                                       FECHA_INI_VIG,
                       A.FECFINVIGCOT                                                       FECHA_FIN_VIG,
                       A.FECVENCECOTIZACION                                                 FECHA_VENCIMIENTO,
                       A.STSCOTIZACION                                                      ESTAUS_COTIZACION,
                       DECODE(SIGN(TRUNC((((A.FECVENCECOTIZACION - A.FECCOTIZACION) * 
                             (A.FECVENCECOTIZACION-(TRUNC(SYSDATE)-3)) ) / 10))), -1, 0, 
                             CASE WHEN TRUNC(CEIL((((A.FECVENCECOTIZACION - A.FECCOTIZACION) *
                             (A.FECVENCECOTIZACION-(TRUNC(SYSDATE)-3)) ) / 10)),1) > 100 THEN 0 ELSE 
                             TRUNC(CEIL((((A.FECVENCECOTIZACION - A.FECCOTIZACION) *
                             (A.FECVENCECOTIZACION-(TRUNC(SYSDATE)-3)) ) / 10)),1)END)        PORCENTAJE_VIGENCIA,
                       A.NUMUNICOCOTIZACION                                                 NUM_UNI_COTIZACION,
                       A.NOMBRECONTRATANTE                                                  NOMBRE,
                       A.SUMAASEGCOTMONEDA                                                  SUMA_ASEGURADA,
                       A.PRIMACOTMONEDA                                                     PRIMA_COTIZADA,
                       DECODE(A.IDPOLIZA, NULL, 'N', 'S')                                   ES_POLIZA_EMITIDA,
                       A.IDPOLIZA                                                           IDPOLIZA,
                       A.NUMPOLRENOVACION                                                   NUM_RENOVACION_POL,
                       A.CODAGENTE,
                       NVL(B.NOMBRECONTRATANTE, P.DESC_PLAN)                                NOM_PRODUC               
                FROM COTIZACIONES A LEFT JOIN COTIZACIONES      B ON B.CODCIA       = A.CODCIA      AND B.CODEMPRESA    = A.CODEMPRESA AND B.IDCOTIZACION = A.NUMCOTIZACIONANT  
                                    LEFT JOIN PLAN_COBERTURAS   P ON P.CODCIA       = A.CODCIA      AND P.CODEMPRESA    = A.CODEMPRESA AND P.IDTIPOSEG    = A.IDTIPOSEG   AND P.PLANCOB       = A.PLANCOB 
                 WHERE A.IDCOTIZACION        = DECODE(NVL(nIdCotizacion, 0), 0, A.IDCOTIZACION, nIdCotizacion)       
                   AND A.CODAGENTE           = nCodAgente
                   AND TRUNC(SYSDATE) BETWEEN  TRUNC(A.FECCOTIZACION) AND TRUNC(A.FECVENCECOTIZACION)
                   AND A.FECCOTIZACION <= TO_DATE(nFechaFin,'DD-MM-YYYY') AND A.FECCOTIZACION >= TO_DATE(nFechaInicio,'DD-MM-YYYY')
                   --AND (A.FECCOTIZACION) BETWEEN nFechaInicio AND nFechaFin --<= nFechaFin AND A.FECCOTIZACION >= nFechaInicio
                   AND A.NOMBRECONTRATANTE <> '{NOMBRE}'
                   AND A.CODCIA = 1
                   AND A.CODEMPRESA = 1
                   AND A.STSCOTIZACION  NOT IN ('COTIZA')
                   AND DECODE(A.IDPOLIZA,NULL,'N','S') = 'N'
                   AND NVL(A.IndCotizacionWeb,'N') = 'S' AND NVL(A.IndCotizacionBaseWeb,'N')='N'
                   AND A.STSCOTIZACION = DECODE(nEstatus, NULL, A.STSCOTIZACION, nEstatus)
                   AND A.NOMBRECONTRATANTE LIKE DECODE(pNombre, NULL, '%', (replace(pNombre, ' ', '%%')))
                   --AND A.NOMBRECONTRATANTE LIKE DECODE(pNombre, NULL, '%', replace(replace(pNombre, '%', '*'), '@', '%'))

                ORDER BY A.IDCOTIZACION DESC, decode(a.STSCOTIZACION, 'ANPOLE', 40, 'COTIZA', 10, 'EMITID', decode(ES_POLIZA_EMITIDA, 'S', 25, 'N', 20), 'POLEMI', 30, 50) DESC); 
        R_COTI Q_COTI%ROWTYPE;
        --
        CATA CLOB;
        --            
    BEGIN
            SELECT count(*) INTO nNumCotizaciones

                FROM COTIZACIONES A LEFT JOIN COTIZACIONES      B ON B.CODCIA       = A.CODCIA      AND B.CODEMPRESA    = A.CODEMPRESA AND B.IDCOTIZACION = A.NUMCOTIZACIONANT  
                                    LEFT JOIN PLAN_COBERTURAS   P ON P.CODCIA       = A.CODCIA      AND P.CODEMPRESA    = A.CODEMPRESA AND P.IDTIPOSEG    = A.IDTIPOSEG   AND P.PLANCOB       = A.PLANCOB 
                 WHERE A.IDCOTIZACION        = DECODE(NVL(0, 0), 0, A.IDCOTIZACION, 0)       
                   AND A.CODAGENTE           = nCodAgente
                   AND TRUNC(SYSDATE) BETWEEN  TRUNC(A.FECCOTIZACION) AND TRUNC(A.FECVENCECOTIZACION)
                   --AND (A.FECCOTIZACION) BETWEEN nFechaInicio AND nFechaFin
                   AND A.FECCOTIZACION <= TO_DATE(nFechaFin,'DD-MM-YYYY') AND A.FECCOTIZACION >= TO_DATE(nFechaInicio,'DD-MM-YYYY')
                   AND A.NOMBRECONTRATANTE <> '{NOMBRE}'
                   AND A.CODCIA = 1
                   AND A.CODEMPRESA = 1
                   AND A.STSCOTIZACION  NOT IN ('COTIZA')
                   AND DECODE(A.IDPOLIZA,NULL,'N','S') = 'N'
                   AND NVL(A.IndCotizacionWeb,'N') = 'S' AND NVL(A.IndCotizacionBaseWeb,'N') = 'N'
                   AND A.STSCOTIZACION = DECODE(nEstatus, NULL, A.STSCOTIZACION, nEstatus)
                   AND A.NOMBRECONTRATANTE LIKE DECODE(pNombre, NULL, '%', (replace(pNombre, ' ', '%%')));
                   --AND A.NOMBRECONTRATANTE LIKE DECODE(pNombre, NULL, '%', replace(replace(pNombre, '%', '*'), '@', '%'));
                  -- AND A.NOMBRECONTRATANTE LIKE DECODE('', NULL, '%', replace(replace('', '%', '*'), '@', '%'));

                --AQUÃƒÂ¿ ES DONDE SE REALIZARA LA DIVISIÃƒâ€œN DE LAS PÃƒÂ¿GINAS
                nNumTotalPag := ceil(nNumCotizaciones/15);
                CATA := '<?xml version="1.0" encoding="UTF-8" ?><COTIZACIONES>';

                IF(nNumPagina<=nNumTotalPag AND nNumPagina > 0) THEN 
                nCotInicial := 15*(nNumPagina-1)+1;

                nCOtFinal := nCotInicial +14;
                OPEN Q_COTI;
                LOOP
                    FETCH Q_COTI INTO R_COTI;
                    EXIT WHEN Q_COTI%NOTFOUND;
                    --
                    nNum := nNum + 1;
                    IF (nNum BETWEEN nCotInicial and nCOtFinal) or nCotInicial = 0 THEN 
                        CATA := CATA || R_COTI.DATOSXML.getclobval();
                    END IF;
                    --
                END LOOP;
                --    
                CLOSE Q_COTI;
                IF(nIdCotizacion>0) THEN
                    CATA :=  CATA || '<CONTROL><RESPONSE>TRUE</RESPONSE><TOTAL_PAGINAS>1</TOTAL_PAGINAS><TOTAL_COTIZACIONES>1</TOTAL_COTIZACIONES></CONTROL></COTIZACIONES>';
                    cResult := CATA;
                    --DBMS_OUTPUT.PUT_LINE(CATA);
                ELSE
                    CATA :=  CATA || '<CONTROL><RESPONSE>TRUE</RESPONSE><TOTAL_PAGINAS>'||nNumTotalPag||'</TOTAL_PAGINAS><TOTAL_COTIZACIONES>'||nNumCotizaciones||'</TOTAL_COTIZACIONES></CONTROL></COTIZACIONES>';
                    cResult := CATA;
                END IF;
                ELSE
                CATA:= '<COTIZACIONES><CONTROL><RESPONSE>FALSE</RESPONSE><TOTAL_PAGINAS>'||nNumTotalPag||'</TOTAL_PAGINAS><TOTAL_COTIZACIONES>'||nNumCotizaciones||'</TOTAL_COTIZACIONES></CONTROL></COTIZACIONES>';
                cResult := CATA;
               -- DBMS_OUTPUT.PUT_LINE(CATA);

                 END IF;
    END;

   --
    PROCEDURE API_MUESTRA_COTIZACIONES(nIdCotizacion IN NUMBER, nCodAgente IN NUMBER, cResult OUT CLOB) IS
        pEstatus        VARCHAR2(10):= NULL;   --Todos los estatus
        --pEstatus in 'EMITID'  CotizaciÃƒÂ³n solo EMITIDA
        --            'POLEMI', CotizaciÃƒÂ³n con Poliza emitida
        --------------para paginaciÃƒÂ³n
        nNumRegIni      NUMBER := 1;    --Para todos los registros entonces 0 (cero)
        nNumRegFin      NUMBER := 50;   --todos los registros entonces 0, recomendaciÃƒÂ³n de 50 en 50 la paginaciÃƒÂ³n como mÃƒÂ¡ximo
        --------------------------------     
    BEGIN
    cResult := GENERALES_PLATAFORMA_DIGITAL.MUESTRA_COTIZACIONES(nIdCotizacion, '',nCodAgente, pEstatus, nNumRegIni, nNumRegFin);      
    END;
    --
    PROCEDURE API_COTIZACION_AGENTE(ncodAgente IN NUMBER, nIdCotizacion IN NUMBER, nValor OUT NUMBER) IS
    BEGIN
        UPDATE COTIZACIONES SET CODAGENTE = ncodAgente WHERE CODCIA = 1 AND CODEMPRESA = 1 AND IDCOTIZACION = nIdCotizacion;
        COMMIT;
        nValor := 1;
    END API_COTIZACION_AGENTE;
    --
    PROCEDURE API_POLIZA_AGENTE(ncodAgente IN VARCHAR2, nIdPoliza IN NUMBER, nValor OUT NUMBER) IS
    BEGIN
        UPDATE POLIZAS SET COD_AGENTE = ncodAgente WHERE CODCIA = 1 AND CODEMPRESA = 1 AND IDPOLIZA = nIdPoliza;
        COMMIT;
        nValor := 1;
    END API_POLIZA_AGENTE;
    --
    PROCEDURE API_CONDICIONES_GENERALES(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, cIdTipoSeg IN VARCHAR2, dFecEmision IN DATE, SetSalidaXml OUT BLOB) IS
    BEGIN
         SetSalidaXml := GENERALES_PLATAFORMA_DIGITAL.CONDICIONES_GENERALES(nCodCia, nCodEmpresa, cIdTipoSeg , dFecEmision);
    END API_CONDICIONES_GENERALES;
    --
    PROCEDURE API_DOCUMENTO_ASISTENCIAS(nCodCia IN NUMBER, nCodEmpresa  IN NUMBER, cIdTipoSeg IN VARCHAR2, cPlanCob IN VARCHAR2, nCodPaquete IN NUMBER, SetSalidaXml OUT BLOB) IS
    BEGIN
        SetSalidaXml := GENERALES_PLATAFORMA_DIGITAL.DOCUMENTO_ASISTENCIAS(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nCodPaquete);
    END API_DOCUMENTO_ASISTENCIAS;
    --
    PROCEDURE API_SINIESTRO_DOCUMENTO(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, cIdTipoSeg IN VARCHAR2, SetSalidaXml OUT BLOB) IS
    BEGIN
         SetSalidaXml := GENERALES_PLATAFORMA_DIGITAL.QUE_HACER_SINIESTROS(nCodCia, nCodEmpresa, cIdTipoSeg);
    END API_SINIESTRO_DOCUMENTO;
    --
    PROCEDURE API_CONSULTA_AGENTE(pCodCia IN NUMBER, pCodEmpresa IN NUMBER, pCodAgente IN NUMBER, cResult OUT CLOB) IS
    BEGIN
        cResult := GENERALES_PLATAFORMA_DIGITAL.CONSULTA_AGENTE(pCodCia, pCodEmpresa, pCodAgente);    
    END;
    ----------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------
     PROCEDURE API_CATALOGO_COTIZACION (IDCOT IN NUMBER, SetXml OUT CLOB) IS
        /*SetSalidaXml := '<?xml version="1.0" encoding="UTF-8" ?><DATA></DATA>';*/
        CURSOR Q_CATA IS
                SELECT  XMLELEMENT("COTIZACION", 
                            XMLELEMENT("STSCOTIZACION", a.stscotizacion),
                            XMLELEMENT("FECSTATUS", a.FECSTATUS),
                            XMLELEMENT("NOMBRECONTRATANTE", a.NOMBRECONTRATANTE),
                            XMLELEMENT("FECINIVIGCOT", a.FECINIVIGCOT),
                            XMLELEMENT("FECFINVIGCOT", a.FECFINVIGCOT),
                            XMLELEMENT("FECCOTIZACION", a.FECCOTIZACION),
                            XMLELEMENT("FECVENCECOTIZACION", a.FECVENCECOTIZACION),
                            XMLELEMENT("COD_MONEDA", a.COD_MONEDA),
                            XMLELEMENT("SUMAASEGCOTLOCAL", a.SUMAASEGCOTLOCAL),
                            XMLELEMENT("SUMAASEGCOTMONEDA", a.SUMAASEGCOTMONEDA),
                            XMLELEMENT("PRIMACOTLOCAL", a.PRIMACOTLOCAL),
                            XMLELEMENT("PRIMACOTMONEDA", a.PRIMACOTMONEDA),
                            XMLELEMENT("IDTIPOSEG", a.IDTIPOSEG),
                            XMLELEMENT("PLANCOB", a.PLANCOB),
                            XMLELEMENT("CODPAQUETE", pc.CODPAQUETE),
                            XMLELEMENT("DESCACTIVIDADASEG", A.DESCACTIVIDADASEG)
                            ) AS DATAXML
                FROM COTIZACIONES A 
                INNER JOIN PAQUETE_COMERCIAL pc on A.CODPAQCOMERCIAL = PC.CODPAQUETE
                WHERE IDCOTIZACION = IDCOT;
        --                  
        R_CATA Q_CATA%ROWTYPE;
        --SetXml := GENERALES_PLATAFORMA_DIGITAL.CONSULTA_COTIZACION (nCodCia, nCodEmpresa, nIdCotizacion);
        --
        CATA CLOB;
        --
    BEGIN
        CATA := '<?xml version="1.0" encoding="UTF-8" ?><DATA>';
            OPEN Q_CATA;
            LOOP
                FETCH Q_CATA INTO R_CATA;
                EXIT WHEN Q_CATA%NOTFOUND;
                --
                CATA := CATA || R_CATA.DATAXML.getclobval();
                --
            END LOOP;
            --    
            CLOSE Q_CATA;
            CATA :=  CATA || '</DATA>';
            SetXml := CATA;

    END API_CATALOGO_COTIZACION;
--
    PROCEDURE API_PLANTILLA_DATOS_PROCESO_M (W_CODCIA IN NUMBER, W_CODEMPRESA IN NUMBER, P_IDTIPOSEG IN VARCHAR2,P_PLANCOB IN VARCHAR2, P_TIPOPROCESO IN VARCHAR2 := 'EMISIO', SetXml OUT CLOB) IS
        /*SetSalidaXml := '<?xml version="1.0" encoding="UTF-8" ?><DATA></DATA>';*/

        CURSOR Q_PLAN (P_IDTIPOSEG VARCHAR2, P_PLANCOB VARCHAR2, P_TIPOPROCESO VARCHAR2) IS
            SELECT P.IDTIPOSEG, P.PLANCOB, P.TIPOPROCESO, P.CODPLANTILLA, CP.DESCPLANTILLA, CP.TIPOPLANTILLA, CP.INDSEPARADOR, CP.ACCIONPLANTILLA
              FROM CONFIG_PLANTILLAS_PLANCOB P,
                   CONFIG_PLANTILLAS CP  
             WHERE P.CODCIA         = W_CODCIA
               AND P.CODEMPRESA     = W_CODEMPRESA
               AND P.IDTIPOSEG      = P_IDTIPOSEG
               AND P.PLANCOB        = P_PLANCOB
               AND P.TIPOPROCESO    = P_TIPOPROCESO
               AND CP.CODCIA         = P.CODCIA
               AND CP.CODEMPRESA     = P.CODEMPRESA
               AND CP.CODPLANTILLA   = P.CODPLANTILLA               
               AND CP.STSPLANTILLA   = 'ACT';
        R_PLAN Q_PLAN%ROWTYPE;                  

        CURSOR Q_TABLAS (P_CODPLANTILLA VARCHAR2) IS        
            SELECT T.NOMTABLA, T.ORDENPROCESO 
              FROM CONFIG_PLANTILLAS_TABLAS T
             WHERE T.CODCIA         = W_CODCIA
               AND T.CODEMPRESA     = W_CODEMPRESA
               AND T.CODPLANTILLA   = P_CODPLANTILLA
            ORDER BY ORDENPROCESO;
        R_TABLAS Q_TABLAS%ROWTYPE;     

        CURSOR Q_CAMPOS (P_CODPLANTILLA VARCHAR2, P_NOMTABLA VARCHAR2, P_ORDENPROCESO NUMBER) IS        
            SELECT C.ORDENCAMPO, C.NOMCAMPO, C.INDCLAVEPRIMARIA, C.TIPOCAMPO, C.NUMDECIMALES, C.INDDATOPART, C.ORDENDATOPART, C.INDASEG, C.VALORDEFAULT
              FROM CONFIG_PLANTILLAS_CAMPOS C 
             WHERE C.CODCIA         = W_CODCIA
               AND C.CODEMPRESA     = W_CODEMPRESA
               AND C.CODPLANTILLA   = P_CODPLANTILLA
               AND C.NOMTABLA       = P_NOMTABLA
               AND C.ORDENPROCESO   = P_ORDENPROCESO
            ORDER BY C.ORDENCAMPO;
        R_CAMPOS Q_CAMPOS%ROWTYPE;            
        --
        RESULTADO CLOB;
        --

        FUNCTION GENTAG(NOMTAG VARCHAR2, VALOR VARCHAR2, ES_ATRIB BOOLEAN := FALSE) RETURN VARCHAR2 IS
            XGENTAG VARCHAR2(32727) := NULL;
        BEGIN
            XGENTAG := '<' ||NOMTAG ||'>' || VALOR || '</' ||NOMTAG ||'>';
            RETURN XGENTAG;
        END GENTAG;
        --
        FUNCTION EXTRAE_DICCIONARIO(P_TABLA VARCHAR2, P_COLUMNA VARCHAR2) RETURN VARCHAR2 IS       
            DESCRIPCION VARCHAR2(500);
            SW BOOLEAN := FALSE;
            --
            CURSOR Q_DICC IS
                SELECT C.COMMENTS
                  FROM SYS.ALL_COL_COMMENTS C
                 WHERE C.OWNER = 'SICAS_OC'
                   AND C.TABLE_NAME = P_TABLA
                   AND C.COLUMN_NAME = P_COLUMNA
                   AND LENGTH(TRIM(C.COMMENTS)) > 0; 
            R_DICC Q_DICC%ROWTYPE;
            --                   
            CURSOR Q_DICC2 IS
                SELECT min(C.COMMENTS) COMMENTS
                  FROM SYS.ALL_COL_COMMENTS C
                 WHERE C.OWNER = 'SICAS_OC'
                   AND LENGTH(C.COMMENTS) > 0
                   AND C.COLUMN_NAME = P_COLUMNA; 
            R_DICC2 Q_DICC2%ROWTYPE;
            --                   
        BEGIN
            OPEN Q_DICC;
            LOOP
                FETCH Q_DICC INTO R_DICC;
                EXIT WHEN Q_DICC%NOTFOUND;
                DESCRIPCION := R_DICC.COMMENTS;
                SW := TRUE;
            END LOOP;
            CLOSE Q_DICC;
            IF NOT SW THEN
                DESCRIPCION := replace(P_COLUMNA, '_', ' ');
                DESCRIPCION := UPPER(SUBSTR(DESCRIPCION, 1, 1)) || LOWER(SUBSTR(DESCRIPCION, 2, LENGTH(DESCRIPCION) - 1)); 
--                OPEN Q_DICC2;
--                LOOP
--                    FETCH Q_DICC2 INTO R_DICC2;
--                    EXIT WHEN Q_DICC2%NOTFOUND;                    
--                    DESCRIPCION := R_DICC2.COMMENTS;
--                END LOOP;
--                CLOSE Q_DICC2;            
            END IF;
            RETURN DESCRIPCION;
        END EXTRAE_DICCIONARIO;
        --
    BEGIN
        --
        --RESULTADO := RESULTADO || R_COB.DATAXML.getclobval();      
        --  
        RESULTADO := '<?xml version="1.0" encoding="UTF-8" ?>' ||  CHR(10) ;
        RESULTADO := RESULTADO || '<DATA>' || CHR(10);
        OPEN Q_PLAN (P_IDTIPOSEG, P_PLANCOB, P_TIPOPROCESO); LOOP        
            FETCH Q_PLAN INTO R_PLAN;
            EXIT WHEN Q_PLAN%NOTFOUND;
            --  
            RESULTADO := RESULTADO || CHR(9) || '<PLAN_COBERT ' || 
                                      'TIPO_PLANTILLA="' || R_PLAN.TIPOPLANTILLA ||'" ' ||
                                      'INDSEPARADOR="' || R_PLAN.INDSEPARADOR ||'" ' ||
                                      'ACCIONPLANTILLA="' || R_PLAN.ACCIONPLANTILLA || '">' ||CHR(10);
            RESULTADO := RESULTADO || CHR(9) || CHR(9) || CHR(9) || '<TABLAS>'|| CHR(10);
            --
            OPEN Q_TABLAS (R_PLAN.CODPLANTILLA); LOOP        
                FETCH Q_TABLAS INTO R_TABLAS;
                EXIT WHEN Q_TABLAS%NOTFOUND;
                --
                RESULTADO := RESULTADO || CHR(9) || CHR(9) || CHR(9) || CHR(9) || '<' || R_TABLAS.NOMTABLA || ' ' ||
                                                                                'ORDENPROCESO="' || R_TABLAS.ORDENPROCESO || '">' || CHR(10);
                --
                OPEN Q_CAMPOS (R_PLAN.CODPLANTILLA, R_TABLAS.NOMTABLA, R_TABLAS.ORDENPROCESO); LOOP   
                    FETCH Q_CAMPOS INTO R_CAMPOS;
                    EXIT WHEN Q_CAMPOS%NOTFOUND;
                    --
                        RESULTADO := RESULTADO || CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) || '<' || REPLACE(R_CAMPOS.NOMCAMPO, ' ', '_')  || ' ' || 'TIPO="' || R_CAMPOS.TIPOCAMPO ||'" ' || 'DESCRIPCION="' || EXTRAE_DICCIONARIO(R_TABLAS.NOMTABLA, R_CAMPOS.NOMCAMPO)|| '" />' || CHR(10);
                    --
                END LOOP;
                --
                CLOSE Q_CAMPOS;
                RESULTADO := RESULTADO || CHR(9) || CHR(9) || CHR(9) || CHR(9) || '</' || R_TABLAS.NOMTABLA || '>' ||  CHR(10) ;
                --
            END LOOP;
            --
            RESULTADO := RESULTADO || CHR(9) || CHR(9) || CHR(9) || '</TABLAS>' || CHR(10) ; 
            RESULTADO := RESULTADO || CHR(9) || '</PLAN_COBERT>' ||  CHR(10) ; 
            --
            CLOSE Q_TABLAS;
        END LOOP;
        --            
        CLOSE Q_PLAN;
        RESULTADO :=  RESULTADO || '</DATA>';
        RESULTADO := REPLACE(REPLACE(RESULTADO, CHR(9), NULL), CHR(10), NULL);
        SetXml := RESULTADO;
    END API_PLANTILLA_DATOS_PROCESO_M;
--
    PROCEDURE API_REGRESA_ESTATUS_POLIZA (IDPOL IN NUMBER, SetXml OUT CLOB) IS
        /*SetSalidaXml := '<?xml version="1.0" encoding="UTF-8" ?><DATA></DATA>';*/
        CURSOR Q_CATA IS
                SELECT  XMLELEMENT("POLIZA",XMLELEMENT("IDPOLIZA", A.IDPOLIZA),XMLELEMENT("ESTATUS", A.STSPOLIZA)) AS DATAXML
                FROM POLIZAS A
                WHERE IDPOLIZA = IDPOL;
        --                  
        R_CATA Q_CATA%ROWTYPE;
        --SetXml := GENERALES_PLATAFORMA_DIGITAL.CONSULTA_COTIZACION (nCodCia, nCodEmpresa, nIdCotizacion);
        --
        CATA CLOB;
        --
    BEGIN
        CATA := '<?xml version="1.0" encoding="UTF-8" ?><DATA>';
            OPEN Q_CATA;
            LOOP
                FETCH Q_CATA INTO R_CATA;
                EXIT WHEN Q_CATA%NOTFOUND;
                --
                CATA := CATA || R_CATA.DATAXML.getclobval();
                --
            END LOOP;
            --    
            CLOSE Q_CATA;
            CATA :=  CATA || '</DATA>';
            SetXml := CATA;

    END API_REGRESA_ESTATUS_POLIZA;
--
    PROCEDURE API_CONSULTA_FACTURAS (IDPOL IN NUMBER, SetXml OUT CLOB) IS
        /*SetSalidaXml := '<?xml version="1.0" encoding="UTF-8" ?><DATA></DATA>';*/
        CURSOR Q_CATA IS
                SELECT  XMLELEMENT("FACTURA",XMLELEMENT("IDPOLIZA", A.IDPOLIZA),XMLELEMENT("TOTAL", A.MONTO_FACT_MONEDA)) AS DATAXML
                FROM FACTURAS A
                WHERE IDPOLIZA = IDPOL;
        --                  
        R_CATA Q_CATA%ROWTYPE;
        --SetXml := GENERALES_PLATAFORMA_DIGITAL.CONSULTA_COTIZACION (nCodCia, nCodEmpresa, nIdCotizacion);
        --
        CATA CLOB;
        --
    BEGIN
        CATA := '<?xml version="1.0" encoding="UTF-8" ?><DATA>';
            OPEN Q_CATA;
            LOOP
                FETCH Q_CATA INTO R_CATA;
                EXIT WHEN Q_CATA%NOTFOUND;
                --
                CATA := CATA || R_CATA.DATAXML.getclobval();
                --
            END LOOP;
            --    
            CLOSE Q_CATA;
            CATA :=  CATA || '</DATA>';
            SetXml := CATA;

    END API_CONSULTA_FACTURAS;
--
    PROCEDURE API_COTIZACIONES (IDCOT IN NUMBER, SetXml OUT CLOB) IS
        /*SetSalidaXml := '<?xml version="1.0" encoding="UTF-8" ?><DATA></DATA>';*/
        CURSOR Q_CATA IS
                SELECT  XMLELEMENT(EVALNAME CASE WHEN A.IDETCOTIZACION < 2 THEN 'TITULAR' ELSE 'DEPENDIENTE' END,
                            XMLATTRIBUTES(A.IDETCOTIZACION AS "ID"),
                            XMLELEMENT("NOMBREASEG", a.NOMBREASEG),
                            XMLELEMENT("APELLIDOPATERNOSEG", a.apellidopaternoaseg),
                            XMLELEMENT("APELLIDOMATERNOSEG", a.APELLIDOMATERNOASEG),
                            XMLELEMENT("FECHANACASEG", a.FECHANACASEG),
                            XMLELEMENT("EDADCONTRATACION", a.EDADCONTRATACION)
                            ) AS DATAXML
                FROM COTIZACIONES_ASEG A
                WHERE IDCOTIZACION = IDCOT;
        --                  
        R_CATA Q_CATA%ROWTYPE;
        --SetXml := GENERALES_PLATAFORMA_DIGITAL.CONSULTA_COTIZACION (nCodCia, nCodEmpresa, nIdCotizacion);
        --
        CATA CLOB;
        --
    BEGIN
        CATA := '<?xml version="1.0" encoding="UTF-8" ?><DATA>';
            OPEN Q_CATA;
            LOOP
                FETCH Q_CATA INTO R_CATA;
                EXIT WHEN Q_CATA%NOTFOUND;
                --
                CATA := CATA || R_CATA.DATAXML.getclobval();
                --
            END LOOP;
            --    
            CLOSE Q_CATA;
            CATA :=  CATA || '</DATA>';
            SetXml := CATA;

    END API_COTIZACIONES;
--
PROCEDURE API_PERSONA_NATURAL_JURIDICA (IDPOL IN NUMBER, SetXml OUT CLOB) IS
        CURSOR Q_CATA IS
                SELECT  XMLELEMENT("DATA",
                XMLELEMENT("TIPO_DOC_IDENTIFICACION", p.TIPO_DOC_IDENTIFICACION),
                XMLELEMENT("NUM_DOC_IDENTIFICACION", p.NUM_DOC_IDENTIFICACION),
                XMLELEMENT("NOMBRE", p.NOMBRE),
                XMLELEMENT("SEXO", p.SEXO),
                XMLELEMENT("FECNACIMIENTO", p.FECNACIMIENTO),
                XMLELEMENT("TIPO_ID_TRIBUTARIA", p.TIPO_ID_TRIBUTARIA),
                XMLELEMENT("NUM_TRIBUTARIO", p.NUM_TRIBUTARIO),
                XMLELEMENT("FECINGRESO", p.FECINGRESO),
                XMLELEMENT("FECSTS", p.FECSTS),
                XMLELEMENT("DirecRes", p.DirecRes),
                XMLELEMENT("NumInterior", CASE WHEN P.NumInterior IS NULL THEN ' ' ELSE P.NumInterior END),
                XMLELEMENT("NumExterior", CASE WHEN P.NumExterior IS NULL THEN ' ' ELSE P.NumExterior END),
                XMLELEMENT("CodColonia", p.codcolres),
                XMLELEMENT("CodProvRes", p.CodProvRes),
                XMLELEMENT("CodPosRes", p.CodPosRes),
                XMLELEMENT("LadaTelRes", CASE WHEN P.LadaTelRes IS NULL THEN ' ' ELSE P.LadaTelRes END),
                XMLELEMENT("TelRes", CASE WHEN P.TelRes IS NULL THEN ' ' ELSE P.TelRes END),
                XMLELEMENT("Email", P.Email)
                ) AS DATAXML
                FROM PERSONA_NATURAL_JURIDICA P join CLIENTES C ON P.num_doc_identificacion = C.num_doc_identificacion
                                                join polizas O ON C.codcliente = O.codcliente WHERE O.idpoliza = IDPOL;
        --                  
        R_CATA Q_CATA%ROWTYPE;
        --SetXml := GENERALES_PLATAFORMA_DIGITAL.CONSULTA_COTIZACION (nCodCia, nCodEmpresa, nIdCotizacion);
        --
        CATA CLOB;
        --
    BEGIN
        CATA := '<?xml version="1.0" encoding="UTF-8" ?>';
            OPEN Q_CATA;
            LOOP
                FETCH Q_CATA INTO R_CATA;
                EXIT WHEN Q_CATA%NOTFOUND;
                --
                CATA := CATA || R_CATA.DATAXML.getclobval();
                --
            END LOOP;
            --    
            CLOSE Q_CATA;
            SetXml := CATA;

    END API_PERSONA_NATURAL_JURIDICA;

    --Creado por AAT y JCP 14/Nov/19
    --Obtiene el primer nodo factura con todo el detalle de su monto, incluyendo texto de conceptos
    PROCEDURE API_DETALLE_PRIMER_PAGO (IDPOL IN NUMBER, SetXml OUT CLOB) IS
        DETALLE_FACTURAS CLOB;
        XML_temp XMLTYPE;
    BEGIN
        DETALLE_FACTURAS := GENERALES_PLATAFORMA_DIGITAL.CONSULTA_FACTURA(1,IDPOL);
        SELECT XMLQUERY (
           '//FACTURAS//FACTURA[1]'  
           PASSING XMLTYPE(  DETALLE_FACTURAS )
           RETURNING CONTENT
        ) INTO XML_temp
        FROM dual;  
        SetXml := '<?xml version="1.0" encoding="UTF-8" ?><DATA>' || XML_temp.getClobVal() || '</DATA>';
    END API_DETALLE_PRIMER_PAGO;
    --
    PROCEDURE API_ELIMINAR_COTIZACIONES(nCodCia IN NUMBER, nCodEmpresa IN NUMBER) IS
     nSetXml          CLOB;

        cursor cursorPolizas is 
            --select POL.IDPOLIZA from polizas POL 
            --INNER JOIN COTIZACIONES COT ON POL.NUM_COTIZACION = COT.IDCOTIZACION 
            --where COT.CODCOTIZADOR LIKE '%WEB%' AND  POL.FECSOLICITUD < SYSDATE - nNumDias AND STSPOLIZA = 'PRE' ORDER BY POL.IDPOLIZA DESC;
            SELECT P.IdPoliza, P.NumPolUnico, P.StsPoliza, C.IdCotizacion, C.StsCotizacion, C.FecVenceCotizacion,
                   P.CodCliente, OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) NombreCliente
              FROM POLIZAS P, COTIZACIONES C
            WHERE P.CodCia= nCodCia
            AND P.CodEmpresa= nCodEmpresa
            AND NVL(C.IndCotizacionBaseWeb,'N') = 'N'
            AND NVL(C.IndCotizacionWeb,'N')= 'S'
            AND C.FecVenceCotizacion< TRUNC(SYSDATE)
            AND C.StsCotizacion IN ('POLEMI')
            AND P.StsPoliza IN ('PRE')
            AND C.CodCotizador IN ('VIWEB','AIWEB')
            AND P.CodCia = C.CodCia
            AND P.CodEmpresa= C.CodEmpresa
            AND P.IdPoliza= C.IdPoliza;

        CURSOR cCotizacionesCaducadas is
            --select COTIZAC.IDCOTIZACION FROM COTIZACIONES COTIZAC WHERE COTIZAC.FECVENCECOTIZACION- nNumDias < SYSDATE AND COTIZAC.CODCOTIZADOR LIKE '%WEB%' AND COTIZAC.STSCOTIZACION NOT LIKE 'POLEMI' AND COTIZAC.IDCOTIZACION>2195 AND COTIZAC.INDCOTIZACIONBASEWEB!= 'S';
            SELECT IdCotizacion, NumUnicoCotizacion, CodCotizador, IdTipoSeg, FecVenceCotizacion,
                   FecIniVigCot, FecFinVigCot, StsCotizacion, IdPoliza
              FROM COTIZACIONES
            WHERE CodCia= nCodCia
            AND CodEmpresa= nCodEmpresa
            AND NVL(IndCotizacionBaseWeb,'N')= 'N'
            AND NVL(IndCotizacionWeb,'N')= 'S'
            AND FecVenceCotizacion< TRUNC(SYSDATE)
            AND StsCotizacion IN ('EMITID','COTIZA')
            AND CodCotizador IN ('VIWEB','AIWEB');
    BEGIN


   FOR p IN cursorPolizas LOOP

      --DELETE FROM POLIZAS WHERE IDPOLIZA= p.IDPOLIZA;
      OC_POLIZAS.REVERTIR_EMISION(nCodCia, nCodEmpresa, p.IDPOLIZA, 'P');
      GT_COTIZACIONES.ANULAR_COTIZACION(nCodCia, nCodEmpresa, P.idCotizacion);
   END LOOP; 
      --OBTENER LAS CANTIDADES DE COTIZACIONES A ELIMINAR CON EL PARÃƒÂ¿METRO O CONDICIÃƒâ€œN DE QUE SU VIGENCIA DE COTIZACIÃƒâ€œN YA HAYA CADUCADO 
   FOR CO IN cCotizacionesCaducadas LOOP
     GT_COTIZACIONES.ANULAR_COTIZACION(nCodCia, nCodEmpresa, CO.idCotizacion);
   END LOOP;
      --DELETE FROM COTIZACIONES WHERE FECVENCECOTIZACION < SYSDATE AND CODCOTIZADOR LIKE '%WEB%' AND STSCOTIZACION NOT LIKE 'POLEMI' AND IDCOTIZACION>2195;
    END API_ELIMINAR_COTIZACIONES;
     --
    PROCEDURE API_CONSULTA_DOCUMENTACION(nIdCotizacion IN NUMBER, nCantidadConsulta OUT CLOB) IS
    BEGIN
        select COUNT(*) INTO nCantidadConsulta FROM api_documentos WHERE IDCOTIZACION_API = nIdCotizacion;
    END API_CONSULTA_DOCUMENTACION;
    --
    PROCEDURE API_LIBERA_POLIZA_SIN_PAGO (IDPOLIZA IN NUMBER,nFechaInicioVigencia IN VARCHAR2) IS
    NCODCIA         NUMBER:=1;
    NCODEMPRESA     NUMBER:=1;
    BEGIN        
        IF nFechaInicioVigencia IS NOT NULL THEN
            OC_POLIZAS.LIBERA_PRE_EMITE(NCODCIA, NCODEMPRESA, IDPOLIZA, TO_DATE(nFechaInicioVigencia,'DD-MM-YYYY'));
        ELSE
            OC_POLIZAS.LIBERA_PRE_EMITE(NCODCIA, NCODEMPRESA, IDPOLIZA, trunc(sysdate));    
        END IF;
    END API_LIBERA_POLIZA_SIN_PAGO;
    --
    PROCEDURE API_ACTUALIZA_COMISION(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nPorcComisAgente IN NUMBER,nPorcConv OUT NUMBER, nGastos OUT NUMBER) IS 
    BEGIN
        GT_COTIZACIONES_DETALLE.RESTAURA_FACTORAJUSTE(nCodCia, nCodEmpresa, nIdCotizacion, 1);
        GENERALES_PLATAFORMA_DIGITAL.ACTUALIZA_COMISIONES(nCodCia,nCodEmpresa,nIdCotizacion,nPorcComisAgente, nPorcConv, nGastos);
    END API_ACTUALIZA_COMISION;
    --
    PROCEDURE API_POLIZA_EMITIDA(nIdPoliza IN NUMBER,nRespuesta OUT CLOB) IS
    BEGIN
       select COUNT(*) INTO nRespuesta FROM polizas where IDPOLIZA = nIdPoliza and STSPOLIZA = 'EMI';
    END API_POLIZA_EMITIDA;
    --
    PROCEDURE API_PAG_COTIZACIONES_AGE(nIdCotizacion IN NUMBER, nCodAgente IN NUMBER,nEstatus IN VARCHAR2, nNumPagina IN NUMBER,nNombre in VARCHAR2,nFechaInicio in VARCHAR2,nFechaFin in VARCHAR2, cResult OUT CLOB) IS
        pEstatus        VARCHAR2(10):= NULL;   --Todos los estatus
        nNum            NUMBER := 0;    
        nCotInicial     NUMBER:= 0;
        nCOtFinal       NUMBER:=0;
        nNumTotalPag    NUMBER:=0;
        pNombre         VARCHAR2(100):=nNombre;
        --pFechaInicio    VARCHAR2(50):='12/12/2020';
        --pFechaFin       VARCHAR2(50):='16/12/2020';
        nNumCotizaciones    NUMBER :=0;

        CURSOR Q_COTI IS
          SELECT XMLELEMENT("COTIZACION",  XMLATTRIBUTES("IDCOTIZACION" , 
                                                         "FECHA_COTIZACION",  
                                                         "FECHA_INI_VIG",
                                                         "FECHA_FIN_VIG",
                                                         "FECHA_VENCIMIENTO",  
                                                         "ESTAUS_COTIZACION",   
                                                         "PORCENTAJE_VIGENCIA",   
                                                         "NUM_UNI_COTIZACION",
                                                         "NOMBRE",
                                                         "SUMA_ASEGURADA",
                                                         "PRIMA_COTIZADA",
                                                         "ES_POLIZA_EMITIDA",
                                                         "IDPOLIZA",
                                                         "NUM_RENOVACION_POL",
                                                         "CODAGENTE")) DATOSXML 
            FROM (                                                         
                SELECT A.IDCOTIZACION, 
                       A.FECCOTIZACION                                                      FECHA_COTIZACION,
                       A.FECFINVIGCOT                                                       FECHA_INI_VIG,
                       A.FECFINVIGCOT                                                       FECHA_FIN_VIG,
                       A.FECVENCECOTIZACION                                                 FECHA_VENCIMIENTO,
                       A.STSCOTIZACION                                                      ESTAUS_COTIZACION,
                       DECODE(SIGN(TRUNC((((A.FECVENCECOTIZACION - A.FECCOTIZACION) * 
                             (A.FECVENCECOTIZACION-(TRUNC(SYSDATE)-3)) ) / 10))), -1, 0, 
                             CASE WHEN TRUNC(CEIL((((A.FECVENCECOTIZACION - A.FECCOTIZACION) *
                             (A.FECVENCECOTIZACION-(TRUNC(SYSDATE)-3)) ) / 10)),1) > 100 THEN 0 ELSE 
                             TRUNC(CEIL((((A.FECVENCECOTIZACION - A.FECCOTIZACION) *
                             (A.FECVENCECOTIZACION-(TRUNC(SYSDATE)-3)) ) / 10)),1)END)        PORCENTAJE_VIGENCIA,
                       A.NUMUNICOCOTIZACION                                                 NUM_UNI_COTIZACION,
                       A.NOMBRECONTRATANTE                                                  NOMBRE,
                       A.SUMAASEGCOTMONEDA                                                  SUMA_ASEGURADA,
                       A.PRIMACOTMONEDA                                                     PRIMA_COTIZADA,
                       DECODE(A.IDPOLIZA, NULL, 'N', 'S')                                   ES_POLIZA_EMITIDA,
                       A.IDPOLIZA                                                           IDPOLIZA,
                       A.NUMPOLRENOVACION                                                   NUM_RENOVACION_POL,
                       A.CODAGENTE,
                       NVL(B.NOMBRECONTRATANTE, P.DESC_PLAN)                                NOM_PRODUC               
                FROM COTIZACIONES A LEFT JOIN COTIZACIONES      B ON B.CODCIA       = A.CODCIA      AND B.CODEMPRESA    = A.CODEMPRESA AND B.IDCOTIZACION = A.NUMCOTIZACIONANT  
                                    LEFT JOIN PLAN_COBERTURAS   P ON P.CODCIA       = A.CODCIA      AND P.CODEMPRESA    = A.CODEMPRESA AND P.IDTIPOSEG    = A.IDTIPOSEG   AND P.PLANCOB       = A.PLANCOB 
                 WHERE A.IDCOTIZACION        = DECODE(NVL(nIdCotizacion, 0), 0, A.IDCOTIZACION, nIdCotizacion)       
                   AND A.CODAGENTE           = nCodAgente
                   AND TRUNC(SYSDATE) BETWEEN  TRUNC(A.FECCOTIZACION) AND TRUNC(A.FECVENCECOTIZACION)
                   AND A.FECCOTIZACION <= TO_DATE(nFechaFin,'DD-MM-YYYY') AND A.FECCOTIZACION >= TO_DATE(nFechaInicio,'DD-MM-YYYY')
                   --AND (A.FECCOTIZACION) BETWEEN nFechaInicio AND nFechaFin --<= nFechaFin AND A.FECCOTIZACION >= nFechaInicio
                   AND A.NOMBRECONTRATANTE <> '{NOMBRE}'
                   AND A.CODCIA = 1
                   AND A.CODEMPRESA = 1
                   AND A.STSCOTIZACION  NOT IN ('COTIZA')
                   AND DECODE(A.IDPOLIZA,NULL,'N','S') = 'N'
                   AND NVL(A.IndCotizacionWeb,'N') = 'S' AND NVL(A.IndCotizacionBaseWeb,'N')='N'
                   AND A.STSCOTIZACION = DECODE(nEstatus, NULL, A.STSCOTIZACION, nEstatus)
                   AND A.NOMBRECONTRATANTE LIKE DECODE(pNombre, NULL, '%', (replace(pNombre, ' ', '%%')))
                   --AND A.NOMBRECONTRATANTE LIKE DECODE(pNombre, NULL, '%', replace(replace(pNombre, '%', '*'), '@', '%'))

                ORDER BY A.IDCOTIZACION DESC, decode(a.STSCOTIZACION, 'ANPOLE', 40, 'COTIZA', 10, 'EMITID', decode(ES_POLIZA_EMITIDA, 'S', 25, 'N', 20), 'POLEMI', 30, 50) DESC); 
        R_COTI Q_COTI%ROWTYPE;
        --
        CATA CLOB;
        --            
    BEGIN
            SELECT count(*) INTO nNumCotizaciones

                FROM COTIZACIONES A LEFT JOIN COTIZACIONES      B ON B.CODCIA       = A.CODCIA      AND B.CODEMPRESA    = A.CODEMPRESA AND B.IDCOTIZACION = A.NUMCOTIZACIONANT  
                                    LEFT JOIN PLAN_COBERTURAS   P ON P.CODCIA       = A.CODCIA      AND P.CODEMPRESA    = A.CODEMPRESA AND P.IDTIPOSEG    = A.IDTIPOSEG   AND P.PLANCOB       = A.PLANCOB 
                 WHERE A.IDCOTIZACION        = DECODE(NVL(0, 0), 0, A.IDCOTIZACION, 0)       
                   AND A.CODAGENTE           = nCodAgente
                   AND TRUNC(SYSDATE) BETWEEN  TRUNC(A.FECCOTIZACION) AND TRUNC(A.FECVENCECOTIZACION)
                   --AND (A.FECCOTIZACION) BETWEEN nFechaInicio AND nFechaFin
                   AND A.FECCOTIZACION <= TO_DATE(nFechaFin,'DD-MM-YYYY') AND A.FECCOTIZACION >= TO_DATE(nFechaInicio,'DD-MM-YYYY')
                   AND A.NOMBRECONTRATANTE <> '{NOMBRE}'
                   AND A.CODCIA = 1
                   AND A.CODEMPRESA = 1
                   AND A.STSCOTIZACION  NOT IN ('COTIZA')
                   AND DECODE(A.IDPOLIZA,NULL,'N','S') = 'N'
                   AND NVL(A.IndCotizacionWeb,'N') = 'S' AND NVL(A.IndCotizacionBaseWeb,'N') = 'N'
                   AND A.STSCOTIZACION = DECODE(nEstatus, NULL, A.STSCOTIZACION, nEstatus)
                   AND A.NOMBRECONTRATANTE LIKE DECODE(pNombre, NULL, '%', (replace(pNombre, ' ', '%%')));
                   --AND A.NOMBRECONTRATANTE LIKE DECODE(pNombre, NULL, '%', replace(replace(pNombre, '%', '*'), '@', '%'));
                  -- AND A.NOMBRECONTRATANTE LIKE DECODE('', NULL, '%', replace(replace('', '%', '*'), '@', '%'));

                --AQUÃƒÂ¿ ES DONDE SE REALIZARA LA DIVISIÃƒâ€œN DE LAS PÃƒÂ¿GINAS
                nNumTotalPag := ceil(nNumCotizaciones/15);
                CATA := '<?xml version="1.0" encoding="UTF-8" ?><COTIZACIONES>';

                IF(nNumPagina<=nNumTotalPag AND nNumPagina > 0) THEN 
                nCotInicial := 15*(nNumPagina-1)+1;

                nCOtFinal := nCotInicial +14;
                OPEN Q_COTI;
                LOOP
                    FETCH Q_COTI INTO R_COTI;
                    EXIT WHEN Q_COTI%NOTFOUND;
                    --
                    nNum := nNum + 1;
                    IF (nNum BETWEEN nCotInicial and nCOtFinal) or nCotInicial = 0 THEN 
                        CATA := CATA || R_COTI.DATOSXML.getclobval();
                    END IF;
                    --
                END LOOP;
                --    
                CLOSE Q_COTI;
                IF(nIdCotizacion>0) THEN
                    CATA :=  CATA || '<CONTROL><RESPONSE>TRUE</RESPONSE><TOTAL_PAGINAS>1</TOTAL_PAGINAS><TOTAL_COTIZACIONES>1</TOTAL_COTIZACIONES></CONTROL></COTIZACIONES>';
                    cResult := CATA;
                    --DBMS_OUTPUT.PUT_LINE(CATA);
                ELSE
                    CATA :=  CATA || '<CONTROL><RESPONSE>TRUE</RESPONSE><TOTAL_PAGINAS>'||nNumTotalPag||'</TOTAL_PAGINAS><TOTAL_COTIZACIONES>'||nNumCotizaciones||'</TOTAL_COTIZACIONES></CONTROL></COTIZACIONES>';
                    cResult := CATA;
                END IF;
                ELSE
                CATA:= '<COTIZACIONES><CONTROL><RESPONSE>FALSE</RESPONSE><TOTAL_PAGINAS>'||nNumTotalPag||'</TOTAL_PAGINAS><TOTAL_COTIZACIONES>'||nNumCotizaciones||'</TOTAL_COTIZACIONES></CONTROL></COTIZACIONES>';
                cResult := CATA;
               -- DBMS_OUTPUT.PUT_LINE(CATA);

                 END IF;            
    END API_PAG_COTIZACIONES_AGE;

    PROCEDURE API_PAG_POLIZAS_AGE(nIdPoliza IN NUMBER, cRFC IN VARCHAR2, pCodAgente IN VARCHAR2,pNumPagina IN NUMBER,pNombre IN VARCHAR2, pFechaInicio IN VARCHAR2, pFechaFin IN VARCHAR2, pEstatus IN VARCHAR2, cResult OUT CLOB) IS
        --pEstatus    VARCHAR2(10);
        --pNombre     VARCHAR2(100):='';
        nNumRegIni  NUMBER := 1;
        nNumRegFin  NUMBER := 25;
        pCodCia     NUMBER  := 1;
        nFechaInicio    VARCHAR2(100):=null;
        nFechaFin   VARCHAR2(100):=null;
        CURSOR Q_ENACA IS
        SELECT IDPOLIZA,   
               NUMPOLUNICO,
               NOMPAQ,
               FECEMISION,
               FECINIVIG,
               FECFINVIG,
               STSPOLIZA,
               NOMBRE_CLIENTE,
               TELMOVIL,
               EMAIL,
               NUM_COTIZACION,
               COD_AGENTE,
               COD_MONEDA,
               PRIMANETA_MONEDA,                                                  
               REMPLAZO,
               CODCIA,
               CODEMPRESA
        FROM (
        SELECT 
               P.CODCIA,
               P.CODEMPRESA,
               P.IDPOLIZA,
               P.NUMPOLUNICO,
               P.FECEMISION,
               P.FECINIVIG,
               P.FECFINVIG,
               P.STSPOLIZA,                   
               --OC_CLIENTES.NOMBRE_CLIENTE(P.CODCLIENTE) NOMBRE_CLIENTE,
               TRIM(PNJ.Nombre) ||' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) || ' ' || DECODE(PNJ.ApeCasada,NULL,'', ' de ' ||PNJ.ApeCasada) NOMBRE_CLIENTE,
               NVL(PNJ.TELMOVIL, PNJ.TELRES) TELMOVIL,
               PNJ.EMAIL ,
               P.NUM_COTIZACION,
               P.COD_AGENTE  ,
               P.COD_MONEDA,
               P.PRIMANETA_MONEDA,
               ANTERIOR.NOMBRECONTRATANTE NOMPAQ,
               'REMXX'   REMPLAZO
        FROM POLIZAS P  INNER JOIN CLIENTES                 CLI         ON CLI.CodCliente = P.CODCLIENTE
                        INNER JOIN PERSONA_NATURAL_JURIDICA PNJ         ON CLI.Tipo_Doc_Identificacion = PNJ.Tipo_Doc_Identificacion AND CLI.Num_Doc_Identificacion  = PNJ.Num_Doc_Identificacion                            
                        LEFT JOIN COTIZACIONES              C           ON C.CODCIA = P.CODCIA AND C.CODEMPRESA = P.CODEMPRESA AND C.IDCOTIZACION = P.NUM_COTIZACION 
                        LEFT JOIN COTIZACIONES              ANTERIOR    ON ANTERIOR.CODCIA = C.CODCIA AND ANTERIOR.CODEMPRESA = C.CODEMPRESA AND ANTERIOR.IDCOTIZACION = C.NUMCOTIZACIONANT
        WHERE  P.CODCIA                     = NVL(1, 1)              
          AND  P.COD_AGENTE                 = DECODE(NVL(pCodAgente, '0'), '0', P.COD_AGENTE, pCodAgente)              
          AND  P.IDPOLIZA                   = DECODE(NVL(nIdPoliza, 0), 0,  P.IDPOLIZA, nIdPoliza)
          AND  PNJ.NUM_DOC_IDENTIFICACION   = DECODE(cRFC, NULL, PNJ.NUM_DOC_IDENTIFICACION, cRFC)
          AND  C.IDCOTIZACION               !=0 
          AND  C.IDCOTIZACION IS NOT NULL
          AND NVL(C.INDCOTIZACIONWEB,'N')='S' AND NVL(C.INDCOTIZACIONBASEWEB,'N')='N'
          AND ANTERIOR.NOMBRECONTRATANTE IS NOT NULL
          AND (P.STSPOLIZA = pEstatus OR pEstatus is NULL)
          AND P.STSPOLIZA <> 'SOL'
          AND P.FECINIVIG >= TO_DATE(pFechaInicio,'DD-MM-YYYY') AND P.FECINIVIG <= TO_DATE(pFechaFin,'DD-MM-YYYY')

          --AND TRIM(PNJ.Nombre) ||' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) LIKE DECODE(pNombre, NULL, '%', replace(replace(pNombre, '%', '*'), '@', '%'))
          AND TRIM(PNJ.Nombre) ||' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) LIKE DECODE(pNombre, NULL, '%', (replace('', ' ', '%%')))
        ORDER BY decode(P.STSPOLIZA, 'PLD', 10, 'PRE', 20, 'EMI', 30, 40), P.IDPOLIZA DESC);
        L_ENACA Q_ENACA%ROWTYPE;

        CURSOR Q_DETALLE (nCODCIA NUMBER, nCODEMPRESA NUMBER, nIDPOLIZA NUMBER) IS
            SELECT XMLELEMENT("CERTIFICADO",   XMLATTRIBUTES("IDETPOL", 
                                                              "IDTIPOSEG",
                                                              "PLANCOB",
                                                              "STSDETALLE",
                                                              "FECINIVIG",
                                                              "FECFINVIG",
                                                              "NOMBRE_ASEG",
                                                              "MOTIVANUL",
                                                              "FECANUL",
                                                              "DESCPLAN",
                                                              "SUMA_ASEG_MONEDA"
                                                              )
                   ) XMLDATOS
            FROM (
            SELECT 
                   D.IDETPOL,
                   D.IDTIPOSEG,
                   D.PLANCOB,
                   D.STSDETALLE ,
                   D.FECINIVIG,
                   D.FECFINVIG,     
                   OC_PERSONA_NATURAL_JURIDICA.NOMBRE_PERSONA(D.COD_ASEGURADO) NOMBRE_ASEG,                                   
                   D.MOTIVANUL,
                   D.FECANUL,                       
                   PP.DESCPLAN,
                   D.SUMA_ASEG_MONEDA
            FROM DETALLE_POLIZA       D   LEFT  JOIN PLAN_DE_PAGOS        PP  ON PP.STSPLAN = 'ACT'         AND PP.CODPLANPAGO = D.CODPLANPAGO                 
            WHERE D.CODCIA     = nCODCIA      
              AND D.CODEMPRESA = nCODEMPRESA 
              AND D.IDPOLIZA   = nIDPOLIZA);
        L_DETAL Q_DETALLE%ROWTYPE ;


        LIN     CLOB;
        LINDETA CLOB;
        NUMREG  NUMBER;   
        nNumeroPolizas  NUMBER;
        nNumeroPaginas  NUMBER;
    BEGIN
        SELECT COUNT(*) INTO nNumeroPolizas
            FROM POLIZAS P  INNER JOIN CLIENTES                 CLI         ON CLI.CodCliente = P.CODCLIENTE
                            INNER JOIN PERSONA_NATURAL_JURIDICA PNJ         ON CLI.Tipo_Doc_Identificacion = PNJ.Tipo_Doc_Identificacion AND CLI.Num_Doc_Identificacion  = PNJ.Num_Doc_Identificacion                            
                            LEFT JOIN COTIZACIONES              C           ON C.CODCIA = P.CODCIA AND C.CODEMPRESA = P.CODEMPRESA AND C.IDCOTIZACION = P.NUM_COTIZACION 
                            LEFT JOIN COTIZACIONES              ANTERIOR    ON ANTERIOR.CODCIA = C.CODCIA AND ANTERIOR.CODEMPRESA = C.CODEMPRESA AND ANTERIOR.IDCOTIZACION = C.NUMCOTIZACIONANT
            WHERE  P.CODCIA                     = NVL(pCodCia, 1)              
              AND  P.COD_AGENTE                 = DECODE(NVL(pCodAgente, '0'), '0', P.COD_AGENTE, pCodAgente)              
              AND  P.IDPOLIZA                   = DECODE(NVL(nIdPoliza, 0), 0,  P.IDPOLIZA, nIdPoliza)
              AND  PNJ.NUM_DOC_IDENTIFICACION   = DECODE(cRFC, NULL, PNJ.NUM_DOC_IDENTIFICACION, cRFC)
              AND  C.IDCOTIZACION               !=0
              AND P.STSPOLIZA <> 'SOL'
              AND  C.IDCOTIZACION IS NOT NULL
              AND NVL(C.INDCOTIZACIONWEB,'N')='S' AND NVL(C.INDCOTIZACIONBASEWEB,'N')='N'
               AND ANTERIOR.NOMBRECONTRATANTE IS NOT NULL


              AND (P.STSPOLIZA =pEstatus OR pEstatus is NULL)

               --AND (P.STSPOLIZA = 'EMI' OR P.STSPOLIZA = 'PLD')
               --AND P.STSPOLIZA= DECODE(pEstatus, NULL,'%', REPLACE(pEstatus,' ', '%%'))  
               AND P.FECINIVIG >= TO_DATE(pFechaInicio,'DD-MM-YYYY') AND P.FECINIVIG <= TO_DATE(pFechaFin,'DD-MM-YYYY')
              --AND TRIM(PNJ.Nombre) ||' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) LIKE DECODE('', NULL, '%', replace(replace('', '%', '*'), '@', '%'))
              AND TRIM(PNJ.Nombre) ||' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) LIKE DECODE(pNombre, NULL, '%', (replace(pNombre, ' ', '%%')))
             ORDER BY decode(P.STSPOLIZA, 'PLD', 10, 'PRE', 20, 'EMI', 30, 40),P.IDPOLIZA DESC ; 
        nNumeroPaginas := ceil(nNumeroPolizas/15);
         NUMREG := 0;
        LIN := '<?xml version="1.0" encoding="UTF-8" ?><POLIZA>';
        IF(pNumPagina<=nNumeroPaginas AND pNumPagina>0) THEN
            nNumRegIni := 15*(pNumPagina-1)+1;
            nNumRegFin := nNumRegIni +14;
            OPEN Q_ENACA;
            LOOP
                FETCH Q_ENACA INTO L_ENACA;
                EXIT WHEN Q_ENACA%NOTFOUND;
                NUMREG := NUMREG + 1;
                IF NUMREG BETWEEN nNumRegIni AND nNumRegFin THEN

                    --LIN := LIN || '<POLIZA>';
                    LIN := LIN || '<IDPOLIZA>' || TO_CHAR(L_ENACA.IDPOLIZA);
                    LIN := LIN || '<NUMPOLUNICO>' || TO_CHAR(L_ENACA.NUMPOLUNICO) || '</NUMPOLUNICO>';
                    LIN := LIN || '<NOMPAQ>' || TO_CHAR(L_ENACA.NOMPAQ) || '</NOMPAQ>';   
                    LIN := LIN || '<FECEMISION>' || TO_CHAR(L_ENACA.FECEMISION) || '</FECEMISION>';
                    LIN := LIN || '<FECINIVIG>' || TO_CHAR(L_ENACA.FECINIVIG) || '</FECINIVIG>';   
                    LIN := LIN || '<FECFINVIG>' || TO_CHAR(L_ENACA.FECFINVIG) || '</FECFINVIG>';   
                    LIN := LIN || '<STSPOLIZA>' || TO_CHAR(L_ENACA.STSPOLIZA) || '</STSPOLIZA>';
                    LIN := LIN || '<CLIENTE NOMBRE_CLIENTE="'|| TO_CHAR(L_ENACA.NOMBRE_CLIENTE) ||'" TELMOVIL="'|| TO_CHAR(L_ENACA.TELMOVIL) ||'" EMAIL="'|| TO_CHAR(L_ENACA.EMAIL) ||'">';
                    --LIN := LIN || '<NOMBRE_CLIENTE >' || TO_CHAR(L_ENACA.NOMBRE_CLIENTE) || '</NOMBRE_CLIENTE>';
                    --LIN := LIN || '<TELMOVIL>' || TO_CHAR(L_ENACA.TELMOVIL) || '</TELMOVIL>';
                    --LIN := LIN || '<EMAIL>' || TO_CHAR(L_ENACA.EMAIL) || '</EMAIL>';
                    LIN := LIN || '</CLIENTE>';
                    LIN := LIN || '<NUM_COTIZACION>' || TO_CHAR(L_ENACA.NUM_COTIZACION) || '</NUM_COTIZACION>';
                    LIN := LIN || '<COD_AGENTE>' || TO_CHAR(L_ENACA.COD_AGENTE) || '</COD_AGENTE>';
                    LIN := LIN || '<COD_MONEDA>' || TO_CHAR(L_ENACA.COD_MONEDA) || '</COD_MONEDA>';
                    LIN := LIN || '<PRIMANETA_MONEDA>' || TO_CHAR(L_ENACA.PRIMANETA_MONEDA) || '</PRIMANETA_MONEDA>';
                    LIN := LIN || '<REMPLAZO>' || TO_CHAR(L_ENACA.REMPLAZO) || '</REMPLAZO>';
                    LIN := LIN || '<CODCIA>' || TO_CHAR(L_ENACA.REMPLAZO) || '</CODCIA>';
                    LIN := LIN || '<CODEMPRESA>' || TO_CHAR(L_ENACA.CODEMPRESA) || '</CODEMPRESA>';
                    LIN := LIN || '</IDPOLIZA>';
                    --        
                    LINDETA := '<CERTIFICADOS>';
                    OPEN Q_DETALLE (L_ENACA.CODCIA, L_ENACA.CODEMPRESA, L_ENACA.IDPOLIZA);        
                    LOOP
                        FETCH Q_DETALLE INTO L_DETAL;
                        EXIT WHEN Q_DETALLE%NOTFOUND;    
                        --  
                        LINDETA := LINDETA || L_DETAL.XMLDATOS.getclobval();
                        --                
                    END LOOP;
                    CLOSE Q_DETALLE;
                    --
                    LINDETA := LINDETA || '</CERTIFICADOS>';
                    --
                    LIN :=  GT_WEB_SERVICES.REPLACE_CLOB(LIN, '<REMXX>REMXX</REMXX>', LINDETA);

                END IF;
                --
                IF NUMREG = nNumRegFin THEN
                    EXIT;
                END IF;
            END LOOP;

        CLOSE Q_ENACA;
        IF(nIdPoliza>0) THEN 
          LIN :=  LIN || '<CONTROL><RESPONSE>TRUE</RESPONSE><TOTAL_PAGINAS>1</TOTAL_PAGINAS><TOTAL_POLIZAS>1</TOTAL_POLIZAS></CONTROL></POLIZA>';

        ELSE
          LIN :=  LIN || '<CONTROL><RESPONSE>TRUE</RESPONSE><TOTAL_PAGINAS>'||nNumeroPaginas||'</TOTAL_PAGINAS><TOTAL_POLIZAS>'||nNumeroPolizas||'</TOTAL_POLIZAS></CONTROL></POLIZA>';
        END IF;
       cResult:= LIN;  
       ELSE
        LIN := '<POLIZA><CONTROL><RESPONSE>FALSE</RESPONSE><TOTAL_PAGINAS>'||nNumeroPaginas||'</TOTAL_PAGINAS><TOTAL_POLIZAS>'||nNumeroPolizas||'</TOTAL_POLIZAS></CONTROL></POLIZA>';
        cResult := LIN;
       END IF;
     -- DBMS_OUTPUT.PUT_LINE(nNumeroPolizas ||','||nNumeroPaginas||','||nNumRegIni||','||nNumRegFin);

    END API_PAG_POLIZAS_AGE;
    --

    PROCEDURE API_ASIGNACION_ASEGURADO(nCodCliente IN NUMBER, cNombre IN VARCHAR2, cApePaterno IN VARCHAR2, cApeMaterno IN VARCHAR2,dFecNacimiento IN DATE, cSexo IN VARCHAR2,nTelRes IN NUMBER, nCODASEGURADO OUT NUMBER) IS
    nCodCia         NUMBER:=1;
    nCodEmpresa     NUMBER:=1;

    BEGIN
        EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
        /*nEdad := 50 ;*/
        nCODASEGURADO := OC_TICKET_VENTA.ASEGURADO(nCodCia,nCodEmpresa,nCodCliente,cNombre,cApePaterno,cApeMaterno,dFecNacimiento,cSexo, nTelRes);
    END API_ASIGNACION_ASEGURADO;
    --
    PROCEDURE API_COBERTURAS(nCodCia IN NUMBER,nCodEmpresa IN NUMBER, nIdCotizacion IN NUMBER, nIdetCotizacion IN NUMBER,nCodGpoCobertWeb IN NUMBER, cCodCobertWeb IN NUMBER, xResultado OUT XMLTYPE) IS
    BEGIN
        xResultado := SICAS_OC.OC_COTIZACIONES_COBERT_WEB.SERVICIO_XML(nCodCia,nCodEmpresa,nIdCotizacion,nIdetCotizacion,nCodGpoCobertWeb,cCodCobertWeb );
    END API_COBERTURAS;
    --
    PROCEDURE API_ACTUALIZA_COBERTURAS(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, xDatos IN XMLTYPE, xResultado OUT XMLTYPE,xPrima OUT XMLTYPE) IS
    --xPrima      clob;
    BEGIN
    xResultado:=SICAS_OC.OC_COTIZACIONES_COBERT_WEB.ACTUALIZAR(nCodCia,nCodEmpresa,xDatos,xPrima);

   END API_ACTUALIZA_COBERTURAS;
   --
   PROCEDURE API_OBTENER_GUA(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, cIdTipoSeg IN VARCHAR2, cPlanCob IN VARCHAR2, cCodCobert IN VARCHAR2, cNivel IN VARCHAR2, nFactor IN VARCHAR2, cCodClausula IN VARCHAR2,xResultado OUT XMLTYPE) IS
   BEGIN
   xResultado := SICAS_OC.OC_FACTOR_GUA.SERVICIO_XML( nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, cCodCobert, cNivel, nFactor, cCodClausula);
   END API_OBTENER_GUA;
   --
   PROCEDURE API_OBTEN_PADECIMENTO_O_NIVELH(nOpcion IN NUMBER, nCodCia IN NUMBER,nCodEmpresa IN NUMBER,cIdTipoSeg IN VARCHAR2,cPlanCob IN VARCHAR2,cCodCobert IN VARCHAR2,cIndIncluido IN VARCHAR2,nFactor IN VARCHAR2,cCodEndoso IN VARCHAR2,xResultado OUT XMLTYPE)IS
   BEGIN
        IF(nOpcion = 1) THEN
            xResultado := SICAS_OC.OC_FACTOR_PADEC_ESPECIAL.SERVICIO_XML(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, cCodCobert, cCodEndoso);
        ELSE
            xResultado := SICAS_OC.OC_FACTOR_NIVEL_HOSPITALARIO.SERVICIO_XML( nCodCia,nCodEmpresa,cIdTipoSeg,cPlanCob,cCodCobert,cCodEndoso);
        END IF;
   END API_OBTEN_PADECIMENTO_O_NIVELH;

PROCEDURE API_GUARDAR_PADEC(nCodCia IN NUMBER,nCodEmpresa IN NUMBER,nIdCotizacion IN VARCHAR2,xXMLDatosPadEsp IN XMLTYPE) IS
  BEGIN
        OC_FACTOR_PADEC_ESPECIAL.REGISTRAR(nCodCia, nCodEmpresa, nIdCotizacion, xXMLDatosPadEsp);
  END API_GUARDAR_PADEC;

     PROCEDURE API_GUARDAR_FACTORES(nCodCia IN NUMBER,nCodEmpresa IN NUMBER,nIdCotizacion IN VARCHAR2,nTipoGuardado IN NUMBER,xXMLDatosGUA IN XMLTYPE, xResultado OUT NUMBER) IS

        BEGIN
         xResultado:=0;
        IF(nTipoGuardado=1) THEN
            OC_FACTOR_GUA.REGISTRAR(nCodCia, nCodEmpresa, nIdCotizacion, xXMLDatosGUA);
            xResultado := 1;
        END IF;
        IF(nTipoGuardado=2) THEN
            OC_FACTOR_PADEC_ESPECIAL.REGISTRAR(nCodCia, nCodEmpresa, nIdCotizacion, xXMLDatosGUA);
            xResultado := 2;
        END IF;
        IF(nTipoGuardado=3) THEN
            OC_FACTOR_NIVEL_HOSPITALARIO.REGISTRAR(nCodCia, nCodEmpresa, nIdCotizacion, xXMLDatosGUA);
            xResultado := 3;
        END IF;
        IF(nTipoGuardado=4) THEN
            OC_FACTOR_EQUIPOS_REPRESENTA.REGISTRAR(nCodCia, nCodEmpresa, nIdCotizacion, xXMLDatosGUA);
            xResultado := 4;
        END IF;
        IF(nTipoGuardado=5) THEN
            OC_FACTOR_REGION.REGISTRAR(nCodCia, nCodEmpresa, nIdCotizacion, xXMLDatosGUA);
            xResultado := 5;
        END IF;
        IF(nTipoGuardado=6) THEN
            OC_COTIZACIONES_COBERT_WEB.ACTUALIZA_DATOS_COBERTURA(nCodCia, nCodEmpresa, nIdCotizacion, xXMLDatosGUA);
            xResultado := 6;
        END IF;
        IF(nTipoGuardado=7) THEN
            OC_FACTOR_EQUIPOS_REPRESENTA.REGISTRAR(nCodCia, nCodEmpresa, nIdCotizacion, xXMLDatosGUA);            
            xResultado := 7;
        END IF;
        IF(nTipoGuardado=8) THEN
            OC_FACTOR_REGION.REGISTRAR(nCodCia, nCodEmpresa, nIdCotizacion, xXMLDatosGUA);            
            xResultado := 8;
        END IF;
        IF(nTipoGuardado=9) THEN
            OC_FACTOR_EQUIPOS_REPRESENTA.REGISTRAR_TEXTO(nCodCia, nCodEmpresa, nIdCotizacion, xXMLDatosGUA);            
            xResultado := 9;
        END IF;
        IF(nTipoGuardado=10) THEN
            OC_FACTOR_REGION.REGISTRAR_TEXTO(nCodCia, nCodEmpresa, nIdCotizacion, xXMLDatosGUA);            
            xResultado := 10;
        END IF;


   END API_GUARDAR_FACTORES;
PROCEDURE API_OBTEN_EQUIPO_REGION(nTipo IN NUMBER, nCodCia IN NUMBER, nCodEmpresa IN NUMBER, cIdTipoSeg IN VARCHAR, cPlanCob IN VARCHAR,nCodPaquete IN NUMBER, cCodigo IN VARCHAR, xResultado OUT XMLTYPE)IS
  BEGIN
    IF(nTipo = 1) THEN
        xResultado:= SICAS_OC.OC_FACTOR_EQUIPOS_REPRESENTA.SERVICIO_XML( nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nCodPaquete, cCodigo);
    END IF;
    IF(nTipo = 2) THEN
        xResultado := SICAS_OC.OC_FACTOR_REGION.SERVICIO_XML( nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nCodPaquete, cCodigo );
    END IF;
  END API_OBTEN_EQUIPO_REGION;
  --
  PROCEDURE API_ENVIAR_ASEGURADOS_MASIVO(nCodCia IN NUMBER,nCodEmpresa IN NUMBER, nIdPoliza IN NUMBER,xAsegurados IN XMLTYPE) IS
  BEGIN
        OC_ASEGURADO_SERVICIOS_WEB.CARGA_ASEGURADOS(nCodCia, nCodEmpresa, nIdPoliza, xAsegurados);
  END API_ENVIAR_ASEGURADOS_MASIVO;
  --
  PROCEDURE API_SOLICITAR_POLIZA_COLECTIVA(nPoliza IN NUMBER,nCodCia1 IN NUMBER, nCodEmpresa1 IN NUMBER, nIdCotizacion1 IN NUMBER, xDatosCliente IN XMLTYPE, idPoliza OUT NUMBER) IS
  BEGIN
       idPoliza := OC_POLIZAS_SERVICIOS_WEB.GENERA_POLIZA(nCodCia1, nCodEmpresa1, nIdCotizacion1, xDatosCliente);
  END API_SOLICITAR_POLIZA_COLECTIVA;
   --
  PROCEDURE API_PRE_EMITE_POLIZA_COLECTIVA(nCodCia IN NUMBER,nCodEmpresa IN NUMBER, nIdPoliza IN NUMBER,cIndRequierePago IN VARCHAR2,cFacturas OUT CLOB) IS
  BEGIN
       cFacturas := OC_POLIZAS_SERVICIOS_WEB.PRE_EMITE_POLIZA(nCodCia, nCodEmpresa, nIdPoliza,cIndRequierePago);
  END API_PRE_EMITE_POLIZA_COLECTIVA;
  --
  PROCEDURE API_OBTENER_NUMERO_UNICO(nCodCia IN NUMBER, nIdPoliza IN NUMBER, xDatosPoliza OUT VARCHAR2 ) IS    
  BEGIN
        xDatosPoliza:=OC_POLIZAS.NUMERO_UNICO(nCodCia , nIdPoliza );                            
  END API_OBTENER_NUMERO_UNICO;  
  --


  PROCEDURE API_POLIZAS_A_RENOVAR(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, dFecEjecucion IN VARCHAR2, xRespuesta OUT XMLTYPE) IS
  BEGIN   
    xRespuesta := SICAS_OC.OC_RENOVACION.POLIZAS_A_RENOVAR(nCodCia, nCodEmpresa, TO_DATE(dFecEjecucion,'DD-MM-YYYY'));
  END API_POLIZAS_A_RENOVAR;

  PROCEDURE API_ACTUALIZAR_INF_RE(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdPoliza IN NUMBER, nNumRenov  IN NUMBER,xGenerales IN XMLTYPE) IS
  BEGIN
       SICAS_OC.OC_RENOVACION.ACTUALIZAR_INFORMACION(nCodCia, nCodEmpresa, nIdPoliza, nNumRenov, xGenerales);     
  END API_ACTUALIZAR_INF_RE;

  PROCEDURE API_RENOVAR_POLIZA(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdPolizaRen IN NUMBER, cEmitePoliza IN VARCHAR2, cPreEmitePoliza IN VARCHAR2, nIdCotizacion IN NUMBER, nPolizaRenovada OUT NUMBER, cFacturas OUT CLOB) IS            
  BEGIN                    
        nPolizaRenovada:= OC_POLIZAS_SERVICIOS_WEB.RENOVAR(nCodCia, nCodEmpresa, nIdPolizaRen, cEmitePoliza, cPreEmitePoliza, nIdCotizacion, cFacturas);        
  END  API_RENOVAR_POLIZA;


  PROCEDURE PA_CONSULTAR_FEC_POLIZAS_REN(nCodCia IN NUMBER, nCodEmpresa IN NUMBER,xReporte out XMLTYPE) IS
  BEGIN
        xReporte := OC_RENOVACION.LISTADO_FECPROCESO(nCodCia, nCodEmpresa);
  END PA_CONSULTAR_FEC_POLIZAS_REN;

    PROCEDURE API_CONSULTA_AGENTES_POLIZA(nCodCia IN NUMBER, cNumPolUnico IN VARCHAR2, cConsecutivo IN NUMBER, xRespuesta OUT XMLTYPE) IS
    xPrevio XMLTYPE;
    BEGIN
        SELECT  XMLELEMENT("DATA", 
                    XMLELEMENT("AGENTES",
                        XMLAGG(XMLELEMENT("AGENTE", t1.cod_agente))))
        INTO xPrevio
        FROM (
            SELECT  a.cod_agente
            FROM    POLIZAS         P,
                    AGENTE_POLIZA   A
            WHERE   P.CodCia      = A.CodCia
            AND     P.IdPoliza    = A.IdPoliza
            AND     p.numpolunico  = NVL(cNumPolUnico, p.numpolunico)
            AND     p.idpoliza  =  NVL(cConsecutivo, p.idpoliza)
            GROUP BY a.cod_agente
        ) t1;

        SELECT XMLROOT(xPrevio, VERSION '1.0" encoding="UTF-8')
        INTO xRespuesta
        FROM dual;
    END API_CONSULTA_AGENTES_POLIZA;

    PROCEDURE CANCELACION_POLIZAS(nCodCia NUMBER,nCodEmpresa NUMBER,nIdPoliza NUMBER,cMotivAnul VARCHAR2,cRespuesta OUT VARCHAR2,cTipoProceso VARCHAR2,cCod_Moneda OUT VARCHAR2, xRespuesta OUT NUMBER, fechaAnulacion DATE) IS
  dFecAnul DATE := TRUNC(TO_DATE(fechaAnulacion, 'DD/MM/RRRR'));
  BEGIN
        cCod_Moneda := OC_POLIZAS.MONEDA(nCodCia, nCodEmpresa, nIdPoliza);
        xRespuesta := OC_POLIZAS_SERVICIOS_WEB.ANULAR_POLIZA(nCodCia, nCodEmpresa, nIdPoliza, dFecAnul, cMotivAnul, cCod_Moneda, cRespuesta, cTipoProceso);
  END CANCELACION_POLIZAS;

PROCEDURE API_CONSULTA_SICAS_FLUJOS(xConsultaServicioSicas XMLTYPE, SetSalidaXml OUT CLOB) IS
cNombreServicio VARCHAR2(100);
nCodigoAgente NUMBER(5);
nIdPoliza  NUMBER(5);
nCodCia  NUMBER(5);
nCodEmpresa NUMBER(5);
CURSOR cGenCotiza IS
   WITH
   COTIZA_DATA AS ( SELECT GEN.*
                       FROM   XMLTABLE('/DATA'
                                 PASSING xConsultaServicioSicas
                                    COLUMNS 
                                       NombreSer       VARCHAR2(100)   PATH 'Nombre',
                                       Parametros         XMLTYPE      PATH 'PARAMETROS') GEN
                     ),
         SERVICIO_DATA   AS ( SELECT  NombreSer,XT2.*
                            FROM   COTIZA_DATA P
                               ,   XMLTABLE('/PARAMETROS'
                                      PASSING P.Parametros
                                         COLUMNS 
                                            CodAgente NUMBER(5) PATH 'CodAgente',
                                            CodCia NUMBER(5) PATH 'CodCia',
                                            CodEmpresa NUMBER(5) PATH 'CodEmpresa',
                                            IdPoliza NUMBER(5) PATH 'IdPoliza') XT2
                          )
   SELECT * FROM SERVICIO_DATA;
BEGIN
   FOR X IN cGenCotiza LOOP
      IF X.NombreSer IS NOT NULL THEN
         cNombreServicio         := X.NombreSer;
      END IF;
      IF X.CodAgente IS NOT NULL THEN
         nCodigoAgente         := X.CodAgente;
      END IF;
      IF X.CodCia IS NOT NULL THEN
         nCodCia         := X.CodCia;
      END IF;
      IF X.CodEmpresa IS NOT NULL THEN
         nCodEmpresa         := X.CodEmpresa;
      END IF;
      IF X.IdPoliza IS NOT NULL THEN
         nIdPoliza         := X.IdPoliza;
      END IF;
   END LOOP;

   IF cNombreServicio ='GENERALES_PLATAFORMA_DIGITAL.CONSULTA_AGENTE' THEN
        SetSalidaXml := GENERALES_PLATAFORMA_DIGITAL.CONSULTA_AGENTE(nCodCia, nCodEmpresa, nCodigoAgente);          
   END IF;
   IF cNombreServicio ='GENERALES_PLATAFORMA_DIGITAL.DIGITAL_CATALOGO_PRODUCT' THEN
        SetSalidaXml := GENERALES_PLATAFORMA_DIGITAL.DIGITAL_CATALOGO_PRODUCT;  
   END IF;
   IF cNombreServicio ='GENERALES_PLATAFORMA_DIGITAL.CONSULTA_FACTURA' THEN
        SetSalidaXml := GENERALES_PLATAFORMA_DIGITAL.CONSULTA_FACTURA(nCodCia, nIdPoliza);  
   END IF;   
    END API_CONSULTA_SICAS_FLUJOS;

    PROCEDURE API_CONSULTA_OBJETO_IMPUESTOS(nCodCia IN NUMBER, nLimInferior IN NUMBER, nLimSuperior IN NUMBER, nTotRegs OUT NUMBER, xRespuesta OUT XMLTYPE) IS
    BEGIN
        xRespuesta := SICAS_OC.Oc_Fact_Elect_Objeto_Impuesto.Listado_Web(nCodCia, nLimInferior, nLimSuperior, nTotRegs);
    END API_CONSULTA_OBJETO_IMPUESTOS;
    PROCEDURE API_CONSULTA_REGIMEN_FISCAL(nLimInferior IN NUMBER, nLimSuperior IN NUMBER, nTotRegs OUT NUMBER, xRespuesta OUT XMLTYPE) IS
    BEGIN
        xRespuesta := SICAS_OC.OC_CAT_REGIMEN_FISCAL.Listado_Web(nLimInferior, nLimSuperior, nTotRegs);
    END API_CONSULTA_REGIMEN_FISCAL;
    PROCEDURE API_CONSULTA_USO_CFDI(nCodCia IN NUMBER, nIdRegFisSat IN NUMBER, cTipoPersona IN VARCHAR2, nLimInferior IN NUMBER, nLimSuperior IN NUMBER, nTotRegs OUT NUMBER, xRespuesta OUT XMLTYPE) IS
    BEGIN
        xRespuesta := SICAS_OC.OC_FACT_ELECT_USO_CFDI.Listado_Web(nCodCia, nIdRegFisSat, cTipoPersona, nLimInferior, nLimSuperior, nTotRegs);
    END API_CONSULTA_USO_CFDI;
    PROCEDURE API_CONSULTA_CATALOGO_GENERAL(pCodLista IN VARCHAR2, pCodValor IN VARCHAR2, xRespuesta OUT CLOB) IS
    BEGIN
        xRespuesta := THONAPI.GENERALES_PLATAFORMA_DIGITAL.CATALOGO_GENERAL(pCodLista, pCodValor);
    END API_CONSULTA_CATALOGO_GENERAL;

    PROCEDURE API_CONSULTA_CIUDAD(cPostal IN VARCHAR2, cColonia IN VARCHAR2, cRespuesta OUT CLOB) IS
    BEGIN
        SELECT codciudad INTO cRespuesta 
        FROM colonia 
        WHERE codigo_postal = cPostal 
        AND codigo_colonia = cColonia;

        EXCEPTION
            WHEN TOO_MANY_ROWS THEN
                cRespuesta := 'SE ENCONTRARON MUCHOS REGISTROS';
            WHEN NO_DATA_FOUND THEN
                cRespuesta := 'SIN DATOS';
    END API_CONSULTA_CIUDAD;

PROCEDURE API_PAGO_FACTURA_COBRANZA( nIdPoliza      IN POLIZAS.IDPOLIZA%TYPE
                                   , nIdFactura     IN FACTURAS.IDFACTURA%TYPE
                                   , cCodFormaPago  IN FACTURAS.FORMPAGO%TYPE 
                                   , nNumAprobacion IN VARCHAR2
                                   , dFecha         IN DATE
                                   , bValor        OUT BOOLEAN) IS

dFecha2                  DATE := NVL( TRUNC(dFecha), TRUNC(SYSDATE));
nCobrar                 NUMBER(1);
nIdTransac              TRANSACCION.IdTransaccion%TYPE;
nIdTransaccion          TRANSACCION.IdTransaccion%TYPE;
nCodAsegurado           DETALLE_POLIZA.Cod_Asegurado%TYPE;
nIdFondo                FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;
nPrimaNivelada          FAI_CONFIG_APORTE_FONDO_DET.MontoAporteMoneda%TYPE;
nAporteFondo            DETALLE_POLIZA.MontoAporteFondo%TYPE;
cEstatus                VARCHAR2(10);
cStsPoliza              SICAS_OC.POLIZAS.StsPoliza%TYPE;       
cCodCFDI                VARCHAR2(100);
bTerminoOk              BOOLEAN := FALSE;
nCodCia                 NUMBER;
nCodEmpresa             NUMBER;
dFecIniVig              SICAS_OC.POLIZAS.FecIniVig%TYPE;       

CURSOR Q_FACTCOB IS
   SELECT FAC.IdFactura,  POL.CodEmpresa, FAC.IndContabilizada,
          FAC.Monto_Fact_Moneda, FAC.IdPoliza, FAC.IDetPol,FAC.NumCuota, FAC.Cod_moneda,
          '000'  CodEntidad,
          POL.StsPoliza
     FROM FACTURAS FAC, POLIZAS POL   
    WHERE FAC.CodCia     = POL.CodCia
      AND FAC.IdPoliza   = POL.IdPoliza
      AND POL.IdPoliza   = nIdPoliza
      AND FAC.IdFactura  = nIdFactura;                                

R_FACTCOB Q_FACTCOB%ROWTYPE; 

CURSOR Q_FACTURAS IS
   SELECT F.IdFactura,
          F.CodCia,
          1    CodEmpresa,
          'A'  TipoCfdi,
          'N'  IndRelaciona,
          F.StsFact
     FROM FACTURAS F
    WHERE F.IdPoliza     =  nIdPoliza
    ORDER BY F.IdFactura;

R_Facturas Q_FACTURAS%ROWTYPE;          

BEGIN
   BEGIN
      SELECT CodCia, CodEmpresa, StsPoliza, FecIniVig
        INTO nCodCia, nCodEmpresa, cStsPoliza, dFecIniVig
        FROM POLIZAS
       WHERE IdPoliza = nIdPoliza;
   END;

   IF cStsPoliza =  'PRE' THEN

    OC_POLIZAS.LIBERA_PRE_EMITE(nCodCia, nCodEmpresa, nIdPoliza, TRUNC(dFecha2));

      OPEN Q_FACTURAS;
      LOOP
         FETCH Q_FACTURAS INTO R_Facturas;
         EXIT WHEN Q_FACTURAS%NOTFOUND; 
         cCodCFDI := OC_FACTURAS.FACTURA_ELECTRONICA(R_Facturas.IdFactura, nCodCia, nCodEmpresa, R_Facturas.TipoCfdi, R_Facturas.IndRelaciona);

   DBMS_OUTPUT.put_line('cCodCFDI: ' || cCodCFDI);

         IF OC_GENERALES.BUSCA_PARAMETRO(nCodCia, '026') = cCodCFDI THEN --201
           NULL;
         END IF;
      END LOOP;
      CLOSE Q_FACTURAS;
   END IF; 

   OPEN Q_FACTCOB ;
   LOOP
         FETCH Q_FACTCOB INTO R_FACTCOB;
         EXIT WHEN Q_FACTCOB%NOTFOUND; 

  -- FOR FC IN FACTCOB LOOP
      BEGIN
         SELECT D.Cod_Asegurado
           INTO nCodAsegurado
           FROM DETALLE_POLIZA D
          WHERE D.CodCia   = nCodCia
            AND D.IdPoliza = R_FACTCOB.IdPoliza
            AND D.IDetPol  = R_FACTCOB.IDetPol;
      END;

      IF R_FACTCOB.IndContabilizada = 'N' THEN
         nIdTransaccion := OC_TRANSACCION.CREA(nCodCia, R_FACTCOB.CodEmpresa, 14, 'CONFAC');
         OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, R_FACTCOB.CodEmpresa, 14, 'CONFAC',
                                    'FACTURAS', R_FACTCOB.IdPoliza, R_FACTCOB.IDetPol, NULL, R_FACTCOB.IdFactura, R_FACTCOB.Monto_Fact_Moneda);
         UPDATE FACTURAS
            SET IdTransacContab  = nIdTransaccion,
                IndContabilizada = 'S',
                FecContabilizada = TRUNC(dFecha2)
          WHERE IdFactura = R_FACTCOB.IdFactura;
         OC_COMPROBANTES_CONTABLES.CONTABILIZAR(1, nIdTransaccion, 'C');
      END IF;

      nIdTransac := OC_TRANSACCION.CREA(1,  R_FACTCOB.CodEmpresa, 12, 'PAG');

      IF GT_FAI_FONDOS_DETALLE_POLIZA.EXISTEN_FONDOS(1, R_FACTCOB.CodEmpresa, R_FACTCOB.IdPoliza, R_FACTCOB.IDetPol, nCodAsegurado) = 'N' THEN
         nCobrar := OC_FACTURAS.PAGAR (R_FACTCOB.IdFactura, nNumAprobacion, dFecha2, R_FACTCOB.Monto_Fact_Moneda, cCodFormaPago, R_FACTCOB.CodEntidad, nIdTransac);
      ELSE             
         nAporteFondo := OC_DETALLE_POLIZA.MONTO_APORTE_FONDOS(nCodCia, R_FACTCOB.CodEmpresa, R_FACTCOB.IdPoliza,  R_FACTCOB.IDetPol);             
         nIdFondo     := GT_FAI_FONDOS_DETALLE_POLIZA.FONDO_PAGO_PRIMA(nCodCia, R_FACTCOB.CodEmpresa, R_FACTCOB.IdPoliza, R_FACTCOB.IDetPol, nCodAsegurado);             
         IF NVL(nIdFondo,0) > 0 THEN
            nPrimaNivelada := GT_FAI_CONFIG_APORTE_FONDO_DET.MONTO_APORTE_ESPECIFICO(nCodCia, R_FACTCOB.CodEmpresa, R_FACTCOB.IdPoliza, R_FACTCOB.IDetPol, nCodAsegurado, nIdFondo, R_FACTCOB.NumCuota);
         ELSE
            nPrimaNivelada := 0;
         END IF;
         nCobrar := OC_FACTURAS.PAGAR_FONDOS(R_FACTCOB.IdFactura, nNumAprobacion, dFecha2, R_FACTCOB.Monto_Fact_Moneda, cCodFormaPago, R_FACTCOB.CodEntidad, nIdTransac, nPrimaNivelada, nAporteFondo);
      END IF;

      IF nCobrar = 1 THEN
         bTerminoOk := TRUE;
         UPDATE PAGOS P 
            SET P.Moneda         = R_FACTCOB.Cod_moneda, 
                P.Num_Recibo_Ref = nNumAprobacion
          WHERE P.CodCia         = nCodCia
            AND P.CodEmpresa     = nCodEmpresa
            AND P.IdFactura      = R_FACTCOB.IdFactura
            AND P.IdTransaccion  = nIdTransac;

         UPDATE FACTURAS
            SET FecSts         = TRUNC(dFecha2),
                IndDomiciliado = NULL
          WHERE CodCia    = nCodCia
            AND IdFactura = R_FACTCOB.IdFactura;

         OC_COMPROBANTES_CONTABLES.CONTABILIZAR(1, nIdTransac, 'C');

         cCodCFDI := OC_FACTURAS.FACTURA_ELECTRONICA(R_FACTCOB.IdFactura, 1, 1, 'A', 'S');           

         IF OC_GENERALES.BUSCA_PARAMETRO(R_Facturas.CodCia, '026') = cCodCFDI THEN --201
            NULL;
         END IF;

      END IF;
   END LOOP;
   CLOSE Q_FACTCOB;
   DBMS_OUTPUT.put_line('bTerminoOk');

bValor := bTerminoOk;
END API_PAGO_FACTURA_COBRANZA;

PROCEDURE API_APLICACION_PAGO( nIdPoliza      IN POLIZAS.IDPOLIZA%TYPE
                             , nIdFactura     IN FACTURAS.IDFACTURA%TYPE 
                             , cCodFormaPago  IN FACTURAS.FORMPAGO%TYPE 
                             , nNumAprobacion IN VARCHAR2 
                             , dFecha         IN DATE 
                             , nValor        OUT NUMBER ) IS
   bVal BOOLEAN;
BEGIN
   API_PAGO_FACTURA_COBRANZA( nIdPoliza, nIdFactura, cCodFormaPago, nNumAprobacion, dFecha, bVal);
   nValor := API_GENERALES.CONTENEDOR_API(bVal);
END API_APLICACION_PAGO;


PROCEDURE API_EMITIR_POLIZASP( nIdPoliza    IN  POLIZAS.IDPOLIZA%TYPE
                             , nValor      OUT  NUMBER ) IS
nCodCia         SICAS_OC.POLIZAS.CODCIA%TYPE;
nCodEmpresa     SICAS_OC.POLIZAS.CODEMPRESA%TYPE;
cStsPoliza      SICAS_OC.POLIZAS.StsPoliza%TYPE;
dFecIniVig      SICAS_OC.POLIZAS.FecIniVig%TYPE; 
cCodCFDI        VARCHAR2(100); 

CURSOR Q_FACTURAS IS
   SELECT F.IdFactura,
          F.CodCia,
          1    CodEmpresa,
          'A'  TipoCfdi,
          'N'  IndRelaciona,
          F.StsFact
     FROM FACTURAS F
    WHERE F.IdPoliza     =  nIdPoliza
    ORDER BY F.IdFactura;

R_Facturas Q_FACTURAS%ROWTYPE;    

BEGIN
    BEGIN
      SELECT CodCia, CodEmpresa, StsPoliza, FecIniVig
        INTO nCodCia, nCodEmpresa, cStsPoliza, dFecIniVig
        FROM POLIZAS
       WHERE IdPoliza = nIdPoliza;
    END;

    IF cStsPoliza =  'PRE' THEN

        OC_POLIZAS.LIBERA_PRE_EMITE(nCodCia, nCodEmpresa, nIdPoliza, TRUNC(SYSDATE));
        OPEN Q_FACTURAS;
        LOOP
            FETCH Q_FACTURAS INTO R_Facturas;
            EXIT WHEN Q_FACTURAS%NOTFOUND; 
            cCodCFDI := OC_FACTURAS.FACTURA_ELECTRONICA(R_Facturas.IdFactura, nCodCia, nCodEmpresa, R_Facturas.TipoCfdi, R_Facturas.IndRelaciona);

            DBMS_OUTPUT.put_line('cCodCFDI: ' || cCodCFDI);

            IF OC_GENERALES.BUSCA_PARAMETRO(nCodCia, '026') = cCodCFDI THEN --201
                NULL;
            END IF;
        END LOOP;
        CLOSE Q_FACTURAS;
        nValor := 1;
    ELSE
        nValor := 0;
   END IF; 

END API_EMITIR_POLIZASP;

PROCEDURE API_CONSULTA_ACTUALIZACION_DWH(nCod IN VARCHAR, SetSalidaXml OUT XMLTYPE) IS
BEGIN
    SetSalidaXml := SICAS_OC.OC_ENDOSO_SERVICIOS_WEB.CONSULTA_ENDOSO_SERVICIOS_WEB(nCod);         
END API_CONSULTA_ACTUALIZACION_DWH;

/*JACF [28/09/2023] <Se agrega funciÃ³n para consultar catalogo de formas de cobro desde las listas de valores>*/
PROCEDURE API_CONSULTA_FORMAS_COBRO(LISTA VARCHAR2, xRespuesta OUT CLOB) IS
    BEGIN    
        xRespuesta := GENERALES_PLATAFORMA_DIGITAL.FORMAS_COBRO(LISTA);
END API_CONSULTA_FORMAS_COBRO;

END API_GENERALES;