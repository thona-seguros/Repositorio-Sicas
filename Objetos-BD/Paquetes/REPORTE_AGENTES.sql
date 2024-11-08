create or replace PACKAGE SICAS_OC.REPORTE_AGENTES AS
/******************************************************************************
   NAME:       SICAS_OC.REPORTE_AGENTES
   PURPOSE:
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        27/03/2023      Usuario       1. Created this package.
******************************************************************************/
PROCEDURE GENERAR_PAGOS(cNomArchivo VARCHAR2, cCodMoneda VARCHAR2, cCodAgente VARCHAR2,
                        dFecDesde DATE, dFecHasta DATE,CFORMATO VARCHAR2,NIDREPORTE NUMBER) ;
PROCEDURE GENERAR_COMISIONES(cNomArchivo VARCHAR2, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                             cCodMoneda VARCHAR2, cCodAgente VARCHAR2, dFecDesde DATE,
                             dFecHasta DATE, cEstado VARCHAR2,cformato varchar2,nidreporte number);
PROCEDURE GENERAR_COMIS_TOTAL(cNomArchivo VARCHAR2, cIdTipoSeg VARCHAR2, cPlanCob  VARCHAR2,
                              cCodMoneda  VARCHAR2, cCodAgente VARCHAR2, dFecDesde DATE,
                              dFecHasta   DATE,cformato varchar2,nidreporte number);
PROCEDURE GENERAR_COMISIONES_HIST(cNomArchivo VARCHAR2, 
                                   dFecDesde   DATE    ,
                                   dFecHasta   DATE    ,cformato varchar2,nidreporte number);
PROCEDURE GENERAR_COMISIONES_NVAS (cNomArchivo VARCHAR2, 
                                   dFecDesde   DATE    ,
                                   dFecHasta   DATE    ,cformato varchar2,nidreporte number);
PROCEDURE LISTAR_AGENTES (cNomArchivo VARCHAR2, CTIPOREP NUMBER,
                                   cformato varchar2,nidreporte number);
PROCEDURE LISTAR_AGENTES_SUS (cNomArchivo VARCHAR2, CTIPOREP NUMBER,dfecdesde date,dfechasta date,
                                   cformato varchar2,nidreporte number);


PROCEDURE REPORTE_ERRORES_EMISION(cNomArchivo VARCHAR2,cformato varchar2,nidreporte number,CTIPOPROCESO VARCHAR2);                                   
PROCEDURE REPORTE_ERRORES_SINIESTRO(cNomArchivo VARCHAR2,cformato varchar2,nidreporte number,CTIPOPROCESO VARCHAR2);                                   
PROCEDURE GENERAR_EMITIDOS(cNomArchivo VARCHAR2, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                           cCodMoneda VARCHAR2, cCodAgente VARCHAR2, dFecDesde DATE,
                           dFecHasta DATE, cformato varchar2, nidreporte number);

PROCEDURE GENERAR_ANULADOS(cNomArchivo VARCHAR2, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                           cCodMoneda VARCHAR2, cCodAgente VARCHAR2, dFecDesde DATE,
                           dFecHasta DATE, cformato varchar2, nidreporte number);
PROCEDURE GENERAR_PAGADOS(cNomArchivo VARCHAR2, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                          cCodMoneda VARCHAR2, cCodAgente VARCHAR2, dFecDesde DATE,
                          dFecHasta DATE, cformato varchar2, nidreporte number);
PROCEDURE PROC_LST_PROYECCION (nidreporte number,nIdCalculoProy number,nIdBonoVentas number,cCodDirRegional varchar2,cCodPromotor varchar2,cCodAgente varchar2);

PROCEDURE GENERAR_PAGOS_DESGLOSE(cNomArchivo VARCHAR2, cCodMoneda VARCHAR2, cCodAgente VARCHAR2,
                        dFecDesde DATE, dFecHasta DATE,cformato varchar2, nidreporte number);
PROCEDURE saldos_mes_anio(pNomArchivo VARCHAR2, pCodMoneda VARCHAR2, pCodAgente VARCHAR2,
                        pFecDesde DATE, pFecHasta DATE,cformato varchar2, nidreporte number);
PROCEDURE PAGOS_AGENTES(cNomArchivo VARCHAR2, cCodMoneda VARCHAR2, cCodAgente VARCHAR2, dFecDesde DATE,
                             dFecHasta DATE,cformato varchar2, nidreporte number);

PROCEDURE COMPARA_COMIS_SALDOS(cNomArchivo VARCHAR2, cCodMoneda VARCHAR2, cCodAgente VARCHAR2, dFecDesde DATE,
                             dFecHasta DATE,cformato varchar2, nidreporte number);
PROCEDURE GENERAR_PAGOSXRAMO(cNomArchivo VARCHAR2, cCodMoneda VARCHAR2, cCodAgente VARCHAR2,
                             dFecDesde DATE, dFecHasta DATE,cformato varchar2, nidreporte number);

END REPORTE_AGENTES;

/

create or replace PACKAGE BODY SICAS_OC.REPORTE_AGENTES AS
PROCEDURE GENERAR_PAGOS(cNomArchivo VARCHAR2, cCodMoneda VARCHAR2, cCodAgente VARCHAR2,
                        dFecDesde DATE, dFecHasta DATE,CFORMATO VARCHAR2,NIDREPORTE NUMBER) IS
cLimitador        VARCHAR2(1) :='|';
nLinea            NUMBER;
cCadena           VARCHAR2(4000);
cCodUser          VARCHAR2(30);
nDummy            NUMBER;
cCopy             BOOLEAN;
cDescFormaPago    VARCHAR2(100);
dFecFin           DATE;
cTipoVigencia     VARCHAR2(20);
nComision         DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nMtoIva           DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nRetISR           DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nRetIVA           DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
cNumComprob       COMPROBANTES_CONTABLES.NumComprob%TYPE;
nIdNcr            NOTAS_DE_CREDITO.IdNcr%TYPE;
cNumFactExt       FACTURA_EXTERNA.NumFactExt%TYPE;
nCodDirecReg      AGENTES.Cod_Agente%TYPE;
cNombreDirecReg   VARCHAR2(500);
-----
nMtoIvaHon        DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nConIvaHon        NUMBER := 0;
-----

CURSOR NC_Q IS
SELECT N.IdNcr,
       N.StsNcr,
       T.FechaTransaccion,
       N.FecDevol,
       N.CodMoneda,
       N.Cod_Agente,
       OC_AGENTES.NOMBRE_AGENTE(N.CodCia, N.Cod_Agente) NombreAgente,
       T.IdTransaccion,
       N.Monto_Ncr_Moneda,
       N.IdNomina,
       N.CodCia,
       N.CtaLiquidadora,
       OC_NIVEL.DESCRIPCION_NIVEL(N.CodCia,
                                  OC_AGENTES.NIVEL_AGENTE(N.CodCia,
                                                          N.Cod_Agente)) NivelAgente,
       OC_AGENTES.TIPO_AGENTE(N.CodCia, N.Cod_Agente) TipoAgente
  FROM NOTAS_DE_CREDITO N, TRANSACCION T
 WHERE ((N.CodMoneda = cCodMoneda AND cCodMoneda != '%') OR
       (N.CodMoneda LIKE cCodMoneda AND cCodMoneda = '%'))
   AND ((N.Cod_Agente = cCodAgente AND cCodAgente != '%') OR
       (N.Cod_Agente LIKE cCodAgente AND cCodAgente = '%'))
   AND N.IdNomina IS NOT NULL
   AND N.StsNcr = 'PAG'
   AND T.IdTransaccion = N.IdTransacAplic
   AND T.IdProceso IN (17) -- Pago de Comisiones
   AND TRUNC(T.FechaTransaccion) >= dFecDesde
   AND TRUNC(T.FechaTransaccion) <= dFecHasta
 ORDER BY N.IdNcr;
CURSOR DET_NC_Q IS
  SELECT D.CodCpto, D.Monto_Det_Moneda, D.IndCptoPrima, C.IndCptoServicio
    FROM DETALLE_NOTAS_DE_CREDITO D,
         NOTAS_DE_CREDITO         N,
         CATALOGO_DE_CONCEPTOS    C
   WHERE C.CodConcepto = D.CodCpto
     AND C.CodCia = N.CodCia
     AND D.CODCPTO != 'TRIVHO'
     AND D.IdNcr = N.IdNcr
     AND N.IdNcr = nIdNcr;
BEGIN
  SELECT CODUSR
    INTO cCodUser
    FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte;

  IF cFormato = 'TEXTO' THEN
    nLinea  := 1;
    cCadena := OC_EMPRESAS.NOMBRE_COMPANIA(1) || CHR(13);
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := 'REPORTE DE PAGOS A AGENTES DEL ' ||
               TO_CHAR(dFecDesde, 'DD/MM/YYYY') || ' Al ' ||
               TO_CHAR(dFecHasta, 'DD/MM/YYYY') || CHR(13);
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := ' ' || CHR(13);
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := 'No. Nota Crédito' || cLimitador || 'Status NC' ||
               cLimitador || 'Código Agente' || cLimitador ||
               'Nombre Agente' || cLimitador || 'Fecha de Pago' ||
               cLimitador || 'Moneda' || cLimitador || 'Monto del Pago' ||
               cLimitador || 'No. de Control' || cLimitador ||
               'Cta. Liquidadora' || cLimitador ||
               'Comision/Honorarios/UDIs' || cLimitador || 'Total IVA' ||
               cLimitador || 'Total IVAHON' || cLimitador || 'Ret. ISR' ||
               cLimitador || 'Ret. IVA' || cLimitador || 'No. Comprobante' ||
               cLimitador || 'Código Direc. Reg.' || cLimitador ||
               'Nombre Dirección Regional' || cLimitador || 'Nivel Agte.' ||
               cLimitador || 'Tipo Agte.' || CHR(13);
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  ELSE
    nLinea  := 1;
    cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"' ||
               chr(10) ||
               ' xmlns:x="urn:schemas-microsoft-com:office:excel"' ||
               chr(10) || ' xmlns="http://www.w3.org/TR/REC-html40">' ||
               chr(10) || ' <style id="libro">' || chr(10) ||
               '   <!--table' || chr(10) ||
               '       {mso-displayed-decimal-separator:"\.";' || chr(10) ||
               '        mso-displayed-thousand-separator:"\,";}' || chr(10) ||
               '        .texto' || chr(10) ||
               '          {mso-number-format:"\@";}' || chr(10) ||
               '        .numero' || chr(10) ||
               '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}' ||
               chr(10) || '        .fecha' || chr(10) ||
               '          {mso-number-format:"dd\\-mmm\\-yyyy";}' ||
               chr(10) || '    -->' || chr(10) ||
               ' </style><div id="libro">' || chr(10);
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := '<table border = 0><tr><th>' ||
               OC_EMPRESAS.NOMBRE_COMPANIA(1) || '</th></tr>';
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := '<tr><th>REPORTE DE PAGOS A AGENTES  DEL ' ||
               TO_CHAR(dFecDesde, 'DD/MM/YYYY') || ' Al ' ||
               TO_CHAR(dFecHasta, 'DD/MM/YYYY') || '</th></tr>';
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := '<tr><th>  </th></tr></table>';
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Nota Crédito</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Status NC</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Agente</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Agente</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de Pago</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Moneda</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto del Pago</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Control</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Cta. Liquidadora</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comisión/Honorarios/UDIs</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total IVA</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total IVAHON</font></th>' || ----JMMD20200812              
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Ret. ISR</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Ret. IVA</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Factura Agente</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Comprobante</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Direc. Reg.</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Dirección Regional</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nivel Agte.</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Typo Agte.</font></th>';
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  END IF;
  FOR X IN NC_Q LOOP
    nIdNcr     := X.IdNcr;
    nComision  := 0;
    nMtoIva    := 0;
    nRetISR    := 0;
    nRetIVA    := 0;
    nMtoIvaHon := 0;
  
    --     nDummy := ALERTA('JMMD CtaLiquidadora  '||X.CtaLiquidadora||' Cod_Agente '||X.Cod_Agente);
    IF X.CtaLiquidadora = '8602' THEN
      nConIvaHon := 0;
    ELSE
      nConIvaHon := 1;
    END IF;
  
    BEGIN
      SELECT Cod_Agente_Distr,
             OC_AGENTES.NOMBRE_AGENTE(CodCia, Cod_Agente_Distr)
        INTO nCodDirecReg, cNombreDirecReg
        FROM AGENTES_DISTRIBUCION_POLIZA
       WHERE CodCia = X.CodCia
         AND IdPoliza IN (SELECT MAX(IdPoliza)
                            FROM COMISIONES C, DETALLE_NOMINA D
                           WHERE C.IdComision = D.IdComision
                             AND C.CodCia = D.CodCia
                             AND D.IdNomina = X.IdNomina
                             AND D.CodCia = X.CodCia)
         AND CodNivel = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        nCodDirecReg    := 0;
        cNombreDirecReg := 'SIN DIRECCION REGIONAL';
      WHEN TOO_MANY_ROWS THEN
        BEGIN
          SELECT MAX(Cod_Agente_Distr)
            INTO nCodDirecReg
            FROM AGENTES_DISTRIBUCION_POLIZA
           WHERE CodCia = X.CodCia
             AND IdPoliza IN (SELECT MAX(IdPoliza)
                                FROM COMISIONES C, DETALLE_NOMINA D
                               WHERE C.IdComision = D.IdComision
                                 AND C.CodCia = D.CodCia
                                 AND D.IdNomina = X.IdNomina
                                 AND D.CodCia = X.CodCia)
             AND CodNivel = 1;
        
          cNombreDirecReg := OC_AGENTES.NOMBRE_AGENTE(X.CodCia,
                                                      nCodDirecReg);
        END;
    END;
  
    FOR W IN DET_NC_Q LOOP
      IF W.CodCpto = 'RETISR' THEN
        nRetISR := NVL(nRetISR, 0) + NVL(W.Monto_Det_Moneda, 0);
      ELSIF W.CodCpto = 'RETIVA' THEN
        nRetIVA := NVL(nRetIVA, 0) + NVL(W.Monto_Det_Moneda, 0);
      ELSIF W.CodCpto = 'IVASIN' THEN
        nMtoIva := NVL(nMtoIva, 0) + NVL(W.Monto_Det_Moneda, 0);
      ELSIF W.CodCpto = 'IVAHON' THEN
        IF nConIvaHon = 1 THEN
          nMtoIvaHon := NVL(nMtoIvaHon, 0) + NVL(W.Monto_Det_Moneda, 0); ---- JMMD 20200812
        ELSE
          nMtoIvaHon := 0;
        END IF;
      ELSE
        nComision := NVL(nComision, 0) + NVL(W.Monto_Det_Moneda, 0);
      END IF;
    END LOOP;
  
    SELECT NVL(MAX(NumFactExt), 'S/F')
      INTO cNumFactExt
      FROM NCR_FACTEXT N, FACTURA_EXTERNA F
     WHERE F.IdeFactExt = N.IdeFactExt
       AND N.IdNcr = nIdNcr;
  
    SELECT NVL(MIN(NumComprob), '0')
      INTO cNumComprob
      FROM COMPROBANTES_CONTABLES
     WHERE NumTransaccion = X.IdTransaccion;
  
    IF cFormato = 'TEXTO' THEN
      cCadena := TO_CHAR(X.IdNcr, '9999999999999') || cLimitador ||
                 X.StsNcr || cLimitador ||
                 TO_CHAR(X.Cod_Agente, '9999999999999') || cLimitador ||
                 X.NombreAgente || cLimitador ||
                 TO_CHAR(X.FechaTransaccion, 'DD/MM/YYYY') || cLimitador ||
                 X.CodMoneda || cLimitador ||
                 TO_CHAR(X.Monto_Ncr_Moneda, '99999999999990.00') ||
                 cLimitador || TO_CHAR(X.IdNomina, '9999999999999') ||
                 cLimitador || X.CtaLiquidadora || cLimitador ||
                 TO_CHAR(nComision, '99999999999990.00') || cLimitador ||
                 TO_CHAR(nMtoIVA, '99999999999990.00') || cLimitador ||
                 TO_CHAR(nMtoIvaHon, '99999999999990.00') || cLimitador || ---- JMMD20200812                    
                 TO_CHAR(nRetISR, '99999999999990.00') || cLimitador ||
                 TO_CHAR(nRetIVA, '99999999999990.00') || cLimitador ||
                 cNumFactExt || cLimitador || cNumComprob || cLimitador ||
                 TO_CHAR(nCodDirecReg, '99999999999990') || cLimitador ||
                 cNombreDirecReg || cLimitador || X.NivelAgente ||
                 cLimitador || X.TipoAgente || CHR(13);
    ELSE
      cCadena := '<tr>' ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdNcr, '9999999999990'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.StsNcr, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Cod_Agente,
                                               '9999999999990'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.NombreAgente, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FechaTransaccion,
                                               'DD/MM/YYYY'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.CodMoneda, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Monto_Ncr_Moneda,
                                               '99999999999990.00'),
                                       'N') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdNomina, '9999999999990'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.CtaLiquidadora, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nComision,
                                               '99999999999990.00'),
                                       'N') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMtoIVA, '99999999999990.00'),
                                       'N') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMtoIvaHon,
                                               '99999999999990.00'),
                                       'N') || ---- JMMD20200812                    
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nRetISR, '99999999999990.00'),
                                       'N') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nRetIVA, '99999999999990.00'),
                                       'N') ||
                 OC_ARCHIVO.CAMPO_HTML(cNumFactExt, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(cNumComprob, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nCodDirecReg,
                                               '99999999999990'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(cNombreDirecReg, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.NivelAgente, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.TipoAgente, 'C') || '</tr>';
    END IF;
    nLinea := nLinea + 1;
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  END LOOP;
  IF cFormato = 'EXCEL' THEN
    OC_ARCHIVO.Escribir_Linea('</table></div></html>', cCodUser, 9999);
  END IF;
  OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0);
  INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
    SELECT nIdReporte + 1,
           B.TIPO_REPORTE,
           B.CODUSR,
           TO_DATE(SYSDATE,'DD/MM/RRRR HH:MI:SS'),
           'GEN',
           A.DATA,
           B.FILE_NAME
      FROM SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
     WHERE A.CODUSER = B.CODUSR
       AND B.IDEXTRACCION = nIdReporte;
  DELETE SICAS_OC.EXTRACCION_DE_REPORTES WHERE IDEXTRACCION = nIdReporte;
  OC_ARCHIVO.Eliminar_Archivo(cCodUser);
END;

PROCEDURE GENERAR_COMISIONES(cNomArchivo VARCHAR2, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2, cCodMoneda VARCHAR2, cCodAgente VARCHAR2, dFecDesde DATE, dFecHasta DATE, cEstado VARCHAR2, cformato varchar2, nidreporte number) IS cLimitador VARCHAR2(1) := '|';
nLinea NUMBER;
cCadena VARCHAR2(4000);
cCodUser VARCHAR2(30);
nDummy NUMBER;
cCopy BOOLEAN;
cDescStatus VARCHAR2(30);
cFecEStado_aniomes VARCHAR2(6);
nCodDirecReg AGENTES.Cod_Agente%TYPE;
cNombreDirecReg VARCHAR2(500);
nIVAHON DETALLE_COMISION.MONTO_MON_LOCAL%TYPE := 0;

CURSOR COM_Q IS
  SELECT 'RECIBO' Tipo,
         F.StsFact StsRec,
         C.IdPoliza,
         C.Cod_Moneda,
         C.IdFactura Recibo,
         C.Cod_Agente,
         OC_AGENTES.NOMBRE_AGENTE(C.CodCia, C.Cod_Agente) NombreAgente,
         C.IDetPol,
         C.IdComision,
         C.Comision_Local,
         C.Comision_Moneda,
         C.CodCia,
         C.Tasa_Cambio,
         C.Estado,
         C.Fec_Estado,
         C.Fec_Generacion,
         C.Fec_Liquidacion,
         C.IdEndoso,
         C.Com_Saldo_Local,
         C.Com_Saldo_Moneda,
         C.IdNomina,
         OC_NIVEL.DESCRIPCION_NIVEL(C.CodCia,
                                    OC_AGENTES.NIVEL_AGENTE(C.CodCia,
                                                            C.Cod_Agente)) NivelAgente,
         OC_AGENTES.TIPO_AGENTE(C.CodCia, C.Cod_Agente) TipoAgente,
         --
         OC_AGENTES.DIRECCION_AGENTE(C.Cod_Agente) DIRECCION,
         PNJ.NUM_DOC_IDENTIFICACION RFC,
         PNJ.CURP CURP
    FROM COMISIONES               C,
         FACTURAS                 F,
         DETALLE_POLIZA           DP,
         PLAN_COBERTURAS          PC,
         AGENTES                  AGE,
         PERSONA_NATURAL_JURIDICA PNJ
   WHERE PC.PlanCob = DP.PlanCob
     AND PC.IdTipoSeg = DP.IdTipoSeg
     AND PC.CodEmpresa = DP.CodEmpresa
     AND PC.CodCia = DP.CodCia
     AND DP.CodCia = F.CodCia
     AND DP.IDetPol = F.IDetPol
     AND DP.IdPoliza = F.IdPoliza
     AND ((DP.IdTipoSeg = cIdTipoSeg AND cIdTipoSeg != '%') OR
         (DP.IdTipoSeg LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
     AND ((DP.PlanCob = cPlanCob AND cPlanCob != '%') OR
         (DP.PlanCob LIKE cPlanCob AND cPlanCob = '%'))
     AND ((F.Cod_Moneda = cCodMoneda AND cCodMoneda != '%') OR
         (F.Cod_Moneda LIKE cCodMoneda AND cCodMoneda = '%'))
     AND ((C.Cod_Agente = cCodAgente AND cCodAgente != '%') OR
         (C.Cod_Agente LIKE cCodAgente AND cCodAgente = '%'))
     AND C.IdFactura = F.IdFactura
     AND C.Estado = cEstado
     AND ((C.Estado = 'PRY' AND TRUNC(C.Fec_Generacion) >= dFecDesde AND
         TRUNC(C.Fec_Generacion) <= dFecHasta AND F.StsFact != 'ANU') OR
         (C.Estado = 'REC' AND TRUNC(C.Fec_Estado) >= dFecDesde AND
         TRUNC(C.Fec_Estado) <= dFecHasta) OR
         (C.Estado = 'LIQ' AND TRUNC(C.Fec_Liquidacion) >= dFecDesde AND
         TRUNC(C.Fec_Liquidacion) <= dFecHasta))
        --
     AND AGE.COD_Agente = C.Cod_Agente
        --
     AND PNJ.TIPO_DOC_IDENTIFICACION = AGE.TIPO_DOC_IDENTIFICACION
     AND PNJ.NUM_DOC_IDENTIFICACION = AGE.NUM_DOC_IDENTIFICACION
  UNION
  SELECT 'NC' Tipo,
         N.StsNcr StsRec,
         C.IdPoliza,
         C.Cod_Moneda,
         C.IdNcr Recibo,
         C.Cod_Agente,
         OC_AGENTES.NOMBRE_AGENTE(C.CodCia, C.Cod_Agente) NombreAgente,
         C.IdetPol,
         C.IdComision,
         C.Comision_Local,
         C.Comision_Moneda,
         C.CodCia,
         C.Tasa_Cambio,
         C.Estado,
         C.Fec_Estado,
         C.Fec_Generacion,
         C.Fec_Liquidacion,
         C.IdEndoso,
         C.Com_Saldo_Local,
         C.Com_Saldo_Moneda,
         C.IdNomina,
         OC_NIVEL.DESCRIPCION_NIVEL(C.CodCia,
                                    OC_AGENTES.NIVEL_AGENTE(C.CodCia,
                                                            C.Cod_Agente)) NivelAgente,
         OC_AGENTES.TIPO_AGENTE(C.CodCia, C.Cod_Agente) TipoAgente,
         --
         OC_AGENTES.DIRECCION_AGENTE(C.Cod_Agente) DIRECCION,
         PNJ.NUM_DOC_IDENTIFICACION RFC,
         PNJ.CURP
    FROM COMISIONES               C,
         NOTAS_DE_CREDITO         N,
         DETALLE_POLIZA           DP,
         PLAN_COBERTURAS          PC,
         AGENTES                  AGE,
         PERSONA_NATURAL_JURIDICA PNJ
   WHERE PC.PlanCob = DP.PlanCob
     AND PC.IdTipoSeg = DP.IdTipoSeg
     AND PC.CodEmpresa = DP.CodEmpresa
     AND PC.CodCia = DP.CodCia
     AND DP.CodCia = N.CodCia
     AND DP.IDetPol = N.IDetPol
     AND DP.IdPoliza = N.IdPoliza
     AND ((DP.IdTipoSeg = cIdTipoSeg AND cIdTipoSeg != '%') OR
         (DP.IdTipoSeg LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
     AND ((DP.PlanCob = cPlanCob AND cPlanCob != '%') OR
         (DP.PlanCob LIKE cPlanCob AND cPlanCob = '%'))
     AND ((N.CodMoneda = cCodMoneda AND cCodMoneda != '%') OR
         (N.CodMoneda LIKE cCodMoneda AND cCodMoneda = '%'))
     AND ((C.Cod_Agente = cCodAgente AND cCodAgente != '%') OR
         (C.Cod_Agente LIKE cCodAgente AND cCodAgente = '%'))
     AND C.IdNcr = N.IdNcr
     AND C.Estado = cEstado
     AND ((C.Estado = 'PRY' AND TRUNC(C.Fec_Generacion) >= dFecDesde AND
         TRUNC(C.Fec_Generacion) <= dFecHasta AND N.StsNcr != 'ANU') OR
         (C.Estado = 'REC' AND TRUNC(C.Fec_Estado) >= dFecDesde AND
         TRUNC(C.Fec_Estado) <= dFecHasta) OR
         (C.Estado = 'LIQ' AND TRUNC(C.Fec_Liquidacion) >= dFecDesde AND
         TRUNC(C.Fec_Liquidacion) <= dFecHasta))
        --
     AND AGE.COD_Agente = C.Cod_Agente
        --
     AND PNJ.TIPO_DOC_IDENTIFICACION = AGE.TIPO_DOC_IDENTIFICACION
     AND PNJ.NUM_DOC_IDENTIFICACION = AGE.NUM_DOC_IDENTIFICACION;

BEGIN
  SELECT CODUSR
    INTO cCodUser
    FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte;

  IF cEstado = 'PRY' THEN
    cDescStatus := 'PENDIENTES';
  ELSIF cEstado = 'REC' THEN
    cDescStatus := 'POR PAGAR';
  ELSE
    cDescStatus := 'LIQUIDADAS';
  END IF;

  IF cFormato = 'TEXTO' THEN
    nLinea  := 1;
    cCadena := oc_empresas.NOMBRE_COMPANIA(1) || CHR(13);
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := 'REPORTE DE COMISIONES ' || cDescStatus || ' DEL ' ||
               TO_CHAR(dFecDesde, 'DD/MM/YYYY') || ' Al ' ||
               TO_CHAR(dFecHasta, 'DD/MM/YYYY') || CHR(13);
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := ' ' || CHR(13);
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := 'Tipo' || cLimitador || 'No. Recibo' || cLimitador ||
               'Status Recibo' || cLimitador || 'Consecutivo Póliza' ||
               cLimitador || 'Detalle/Subgrupo' || cLimitador ||
               'No. Endoso' || cLimitador || 'Código Agente' || cLimitador ||
               'Nombre Agente' || cLimitador || 'Moneda' || cLimitador ||
               'Id. Comisión' || cLimitador || 'Status' || cLimitador ||
               'Mto. Comis. Local' || cLimitador || 'Mto. Comis. Moneda' ||
               cLimitador || 'Tasa de Cambio' || cLimitador ||
               'Fecha Generada' || cLimitador || 'Fecha Pago Recibo' ||
               cLimitador || 'Fecha Pago Recibo Año Mes' || cLimitador ||
               'Fecha Liquidación' || cLimitador ||
               'No. Control Liquidación' || cLimitador ||
               'Código Direc. Reg.' || cLimitador ||
               'Nombre Dirección Regional' || cLimitador || 'Nivel Agte.' ||
               cLimitador || 'Tipo Agte.' || cLimitador || 'Direccion' ||
               cLimitador || 'RFC' || cLimitador || 'CURP' || cLimitador ||
               'IVA HONORARIOS' || CHR(13);
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  ELSE
    nLinea  := 1;
    cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"' ||
               chr(10) ||
               ' xmlns:x="urn:schemas-microsoft-com:office:excel"' ||
               chr(10) || ' xmlns="http://www.w3.org/TR/REC-html40">' ||
               chr(10) || ' <style id="libro">' || chr(10) ||
               '   <!--table' || chr(10) ||
               '       {mso-displayed-decimal-separator:"\.";' || chr(10) ||
               '        mso-displayed-thousand-separator:"\,";}' || chr(10) ||
               '        .texto' || chr(10) ||
               '          {mso-number-format:"\@";}' || chr(10) ||
               '        .numero' || chr(10) ||
               '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}' ||
               chr(10) || '        .fecha' || chr(10) ||
               '          {mso-number-format:"dd\\-mmm\\-yyyy";}' ||
               chr(10) || '    -->' || chr(10) ||
               ' </style><div id="libro">' || chr(10);
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := '<table border = 0><tr><th>' ||
               oc_empresas.NOMBRE_COMPANIA(1) || '</th></tr>';
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := '<tr><th>REPORTE DE COMISIONES ' || cDescStatus || ' DEL ' ||
               TO_CHAR(dFecDesde, 'DD/MM/YYYY') || ' Al ' ||
               TO_CHAR(dFecHasta, 'DD/MM/YYYY') || '</th></tr>';
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := '<tr><th>  </th></tr></table>';
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Recibo</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Status Recibo</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Consecutivo Póliza</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Detalle/Subgrupo</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Endoso</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Agente</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Agente</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Moneda</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Id. Comisión</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Status</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Mto. Comis. Local</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Mto. Comis. Moneda</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tasa de Cambio</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Generada</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Pago Recibo</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Pago Recibo Año Mes</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Liquidación</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Control Liquidación</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Direc. Reg.</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Dirección Regional</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nivel Agte.</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Agte.</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Direccion</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RFC</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CURP</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IVA HONORARIOS</font></th>';
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  END IF;
  FOR X IN COM_Q LOOP
    BEGIN
      SELECT Cod_Agente_Distr,
             OC_AGENTES.NOMBRE_AGENTE(CodCia, Cod_Agente_Distr)
        INTO nCodDirecReg, cNombreDirecReg
        FROM AGENTES_DISTRIBUCION_POLIZA
       WHERE CodCia = X.CodCia
         AND IdPoliza = X.IdPoliza
         AND CodNivel = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        nCodDirecReg    := 0;
        cNombreDirecReg := 'SIN DIRECCION REGIONAL';
      WHEN TOO_MANY_ROWS THEN
        BEGIN
          SELECT MAX(Cod_Agente_Distr)
            INTO nCodDirecReg
            FROM AGENTES_DISTRIBUCION_POLIZA
           WHERE CodCia = X.CodCia
             AND IdPoliza = X.IdPoliza
             AND CodNivel = 1;
        
          cNombreDirecReg := OC_AGENTES.NOMBRE_AGENTE(X.CodCia,
                                                      nCodDirecReg);
        END;
    END;
    ---------------------------------
    BEGIN
      SELECT DC.MONTO_MON_LOCAL
        INTO nIVAHON
        FROM DETALLE_COMISION DC
       WHERE DC.CODCONCEPTO = 'IVAHON'
         AND DC.IDCOMISION = X.IdComision;
    EXCEPTION
      WHEN OTHERS THEN
        nIVAHON := 0;
    END;
    ---------------------------------      
    /*      SELECT TO_DATE(X.Fec_Estado,'MM/YYYY')
    INTO cFecEStado_aniomes
    FROM DUAL;*/
    ---------------------------------       
    IF cFormato = 'TEXTO' THEN
      cCadena := X.Tipo || cLimitador || TO_CHAR(X.Recibo, '9999999999999') ||
                 cLimitador || X.StsRec || cLimitador ||
                 TO_CHAR(X.IdPoliza, '9999999999999') || cLimitador ||
                 TO_CHAR(X.IDetPol, '9999999999999') || cLimitador ||
                 TO_CHAR(X.IdEndoso, '9999999999999') || cLimitador ||
                 TO_CHAR(X.Cod_Agente, '9999999999990') || cLimitador ||
                 X.NombreAgente || cLimitador || X.Cod_Moneda || cLimitador ||
                 TO_CHAR(X.IdComision, '9999999999990') || cLimitador ||
                 X.Estado || cLimitador ||
                 TO_CHAR(X.Comision_Local, '99999999999990.00') ||
                 cLimitador ||
                 TO_CHAR(X.Comision_Moneda, '99999999999990.00') ||
                 cLimitador || TO_CHAR(X.Tasa_Cambio, '9999990.00') ||
                 cLimitador || TO_CHAR(X.Fec_Generacion, 'DD/MM/YYYY') ||
                 cLimitador || TO_CHAR(X.Fec_Estado, 'DD/MM/RRRR') ||
                 cLimitador || TO_CHAR(X.Fec_Estado, 'MM/RRRR') ||
                 cLimitador || TO_CHAR(X.Fec_Liquidacion, 'DD/MM/RRRR') ||
                 cLimitador || TO_CHAR(X.IdNomina, '99999999999990') ||
                 cLimitador || TO_CHAR(nCodDirecReg, '99999999999990') ||
                 cLimitador || cNombreDirecReg || cLimitador ||
                 X.NivelAgente || cLimitador || X.TipoAgente || cLimitador ||
                 X.DIRECCION || cLimitador || X.RFC || cLimitador || X.CURP ||
                 cLimitador || TO_CHAR(nIVAHON, '99999999999990.00') ||
                 CHR(13);
    ELSE
      cCadena := '<tr>' || OC_ARCHIVO.CAMPO_HTML(X.Tipo, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Recibo, '9999999999990'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.StsRec, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdPoliza, '9999999999990'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IDetPol, '9999999999990'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdEndoso, '9999999999990'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Cod_Agente,
                                               '9999999999990'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.NombreAgente, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Cod_Moneda, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdComision,
                                               '9999999999990'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Estado, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Comision_Local,
                                               '99999999999990.00'),
                                       'N') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Comision_Moneda,
                                               '99999999999990.00'),
                                       'N') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Tasa_Cambio, '9999990.00'),
                                       'N') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Fec_Generacion,
                                               'DD/MM/YYYY'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Fec_Estado, 'DD/MM/RRRR'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Fec_Estado, 'MM/RRRR'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Fec_Liquidacion,
                                               'DD/MM/RRRR'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdNomina, '99999999999990'),
                                       'N') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nCodDirecReg,
                                               '99999999999990'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(cNombreDirecReg, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.NivelAgente, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.TipoAgente, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.DIRECCION, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.RFC, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.CURP, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nIVAHON, '99999999999990.00'),
                                       'N') || '</tr>';
    END IF;
    nLinea := nLinea + 1;
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  END LOOP;
  IF cFormato = 'EXCEL' THEN
    OC_ARCHIVO.Escribir_Linea('</table></div></html>', ccodUSER, 9999);
  END IF;
  OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0);
  INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
    SELECT nIdReporte + 1,
           B.TIPO_REPORTE,
           B.CODUSR,
           SYSDATE,
           'GEN',
           A.DATA,
           B.FILE_NAME
      FROM SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
     WHERE A.CODUSER = B.CODUSR
       AND B.IDEXTRACCION = nIdReporte;
  DELETE SICAS_OC.EXTRACCION_DE_REPORTES WHERE IDEXTRACCION = nIdReporte;
  OC_ARCHIVO.Eliminar_Archivo(cCodUser);

END;

PROCEDURE GENERAR_COMIS_TOTAL(cNomArchivo VARCHAR2, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2, cCodMoneda VARCHAR2, cCodAgente VARCHAR2, dFecDesde DATE, dFecHasta DATE, cformato varchar2, nidreporte number) IS cLimitador VARCHAR2(1) := '|';
nLinea NUMBER;
cCadena VARCHAR2(4000);
cCodUser VARCHAR2(30);
nDummy NUMBER;
cCopy BOOLEAN;
nCodDirecReg AGENTES.Cod_Agente%TYPE;
cNombreDirecReg VARCHAR2(500);

CURSOR COM_Q IS
  SELECT 'RECIBO' Tipo,
         F.StsFact StsRec,
         C.IdPoliza,
         C.Cod_Moneda,
         C.IdFactura Recibo,
         C.Cod_Agente,
         OC_AGENTES.NOMBRE_AGENTE(C.CodCia, C.Cod_Agente) NombreAgente,
         C.IdetPol,
         C.IdComision,
         C.Comision_Local,
         C.Comision_Moneda,
         C.CodCia,
         C.Tasa_Cambio,
         C.Estado,
         C.Fec_Estado,
         C.Fec_Generacion,
         C.Fec_Liquidacion,
         C.IdEndoso,
         C.Com_Saldo_Local,
         C.Com_Saldo_Moneda,
         C.IdNomina,
         OC_NIVEL.DESCRIPCION_NIVEL(C.CodCia,
                                    OC_AGENTES.NIVEL_AGENTE(C.CodCia,
                                                            C.Cod_Agente)) NivelAgente,
         OC_AGENTES.TIPO_AGENTE(C.CodCia, C.Cod_Agente) TipoAgente,
         --
         OC_AGENTES.DIRECCION_AGENTE(C.Cod_Agente) DIRECCION,
         PNJ.NUM_DOC_IDENTIFICACION RFC,
         PNJ.CURP
    FROM COMISIONES               C,
         FACTURAS                 F,
         DETALLE_POLIZA           DP,
         PLAN_COBERTURAS          PC,
         AGENTES                  AGE,
         PERSONA_NATURAL_JURIDICA PNJ
   WHERE PC.PlanCob = DP.PlanCob
     AND PC.IdTipoSeg = DP.IdTipoSeg
     AND PC.CodEmpresa = DP.CodEmpresa
     AND PC.CodCia = DP.CodCia
     AND DP.CodCia = F.CodCia
     AND DP.IDetPol = F.IDetPol
     AND DP.IdPoliza = F.IdPoliza
     AND ((DP.IdTipoSeg = cIdTipoSeg AND cIdTipoSeg != '%') OR
         (DP.IdTipoSeg LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
     AND ((DP.PlanCob = cPlanCob AND cPlanCob != '%') OR
         (DP.PlanCob LIKE cPlanCob AND cPlanCob = '%'))
     AND ((F.Cod_Moneda = cCodMoneda AND cCodMoneda != '%') OR
         (F.Cod_Moneda LIKE cCodMoneda AND cCodMoneda = '%'))
     AND ((C.Cod_Agente = cCodAgente AND cCodAgente != '%') OR
         (C.Cod_Agente LIKE cCodAgente AND cCodAgente = '%'))
     AND C.IdFactura = F.IdFactura
     AND F.StsFact != 'ANU'
        --
     AND AGE.COD_Agente = C.Cod_Agente
        --
     AND PNJ.TIPO_DOC_IDENTIFICACION = AGE.TIPO_DOC_IDENTIFICACION
     AND PNJ.NUM_DOC_IDENTIFICACION = AGE.NUM_DOC_IDENTIFICACION
  UNION
  SELECT 'NC' Tipo,
         N.StsNcr StsRec,
         C.IdPoliza,
         C.Cod_Moneda,
         C.IdNcr Recibo,
         C.Cod_Agente,
         OC_AGENTES.NOMBRE_AGENTE(C.CodCia, C.Cod_Agente) NombreAgente,
         C.IdetPol,
         C.IdComision,
         C.Comision_Local,
         C.Comision_Moneda,
         C.CodCia,
         C.Tasa_Cambio,
         C.Estado,
         C.Fec_Estado,
         C.Fec_Generacion,
         C.Fec_Liquidacion,
         C.IdEndoso,
         C.Com_Saldo_Local,
         C.Com_Saldo_Moneda,
         C.IdNomina,
         OC_NIVEL.DESCRIPCION_NIVEL(C.CodCia,
                                    OC_AGENTES.NIVEL_AGENTE(C.CodCia,
                                                            C.Cod_Agente)) NivelAgente,
         OC_AGENTES.TIPO_AGENTE(C.CodCia, C.Cod_Agente) TipoAgente,
         --
         OC_AGENTES.DIRECCION_AGENTE(C.Cod_Agente) DIRECCION,
         PNJ.NUM_DOC_IDENTIFICACION RFC,
         PNJ.CURP
    FROM COMISIONES               C,
         NOTAS_DE_CREDITO         N,
         DETALLE_POLIZA           DP,
         PLAN_COBERTURAS          PC,
         AGENTES                  AGE,
         PERSONA_NATURAL_JURIDICA PNJ
   WHERE PC.PlanCob = DP.PlanCob
     AND PC.IdTipoSeg = DP.IdTipoSeg
     AND PC.CodEmpresa = DP.CodEmpresa
     AND PC.CodCia = DP.CodCia
     AND DP.CodCia = N.CodCia
     AND DP.IDetPol = N.IDetPol
     AND DP.IdPoliza = N.IdPoliza
     AND ((DP.IdTipoSeg = cIdTipoSeg AND cIdTipoSeg != '%') OR
         (DP.IdTipoSeg LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
     AND ((DP.PlanCob = cPlanCob AND cPlanCob != '%') OR
         (DP.PlanCob LIKE cPlanCob AND cPlanCob = '%'))
     AND ((N.CodMoneda = cCodMoneda AND cCodMoneda != '%') OR
         (N.CodMoneda LIKE cCodMoneda AND cCodMoneda = '%'))
     AND ((C.Cod_Agente = cCodAgente AND cCodAgente != '%') OR
         (C.Cod_Agente LIKE cCodAgente AND cCodAgente = '%'))
     AND C.IdNcr = N.IdNcr
     AND N.StsNcr != 'ANU'
        --
     AND AGE.COD_Agente = C.Cod_Agente
        --
     AND PNJ.TIPO_DOC_IDENTIFICACION = AGE.TIPO_DOC_IDENTIFICACION
     AND PNJ.NUM_DOC_IDENTIFICACION = AGE.NUM_DOC_IDENTIFICACION;
BEGIN
  SELECT CODUSR
    INTO cCodUser
    FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte;

  IF cFormato = 'TEXTO' THEN
    nLinea  := 1;
    cCadena := oc_empresas.NOMBRE_COMPANIA(1) || CHR(13);
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := 'REPORTE DE COMISIONES TOTALES DEL ' ||
               TO_CHAR(dFecDesde, 'DD/MM/YYYY') || ' Al ' ||
               TO_CHAR(dFecHasta, 'DD/MM/YYYY') || CHR(13);
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := ' ' || CHR(13);
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := 'Tipo' || cLimitador || 'No. Recibo' || cLimitador ||
               'Status Recibo' || cLimitador || 'Consecutivo Póliza' ||
               cLimitador || 'Detalle/Subgrupo' || cLimitador ||
               'No. Endoso' || cLimitador || 'Código Agente' || cLimitador ||
               'Nombre Agente' || cLimitador || 'Moneda' || cLimitador ||
               'Id. Comisión' || cLimitador || 'Status' || cLimitador ||
               'Mto. Comis. Local' || cLimitador || 'Mto. Comis. Moneda' ||
               cLimitador || 'Tasa de Cambio' || cLimitador ||
               'Fecha Generada' || cLimitador || 'Fecha Pago Recibo' ||
               cLimitador || 'Fecha Liquidación' || cLimitador ||
               'No. Control Liquidación' || cLimitador ||
               'Código Direc. Reg.' || cLimitador ||
               'Nombre Dirección Regional' || cLimitador || 'Nivel Agte.' ||
               cLimitador || 'Tipo Agte.' || cLimitador || 'Direccion' ||
               cLimitador || 'RFC' || cLimitador || 'CURP' || cLimitador ||
              
               CHR(13);
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  ELSE
    nLinea  := 1;
    cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"' ||
               chr(10) ||
               ' xmlns:x="urn:schemas-microsoft-com:office:excel"' ||
               chr(10) || ' xmlns="http://www.w3.org/TR/REC-html40">' ||
               chr(10) || ' <style id="libro">' || chr(10) ||
               '   <!--table' || chr(10) ||
               '       {mso-displayed-decimal-separator:"\.";' || chr(10) ||
               '        mso-displayed-thousand-separator:"\,";}' || chr(10) ||
               '        .texto' || chr(10) ||
               '          {mso-number-format:"\@";}' || chr(10) ||
               '        .numero' || chr(10) ||
               '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}' ||
               chr(10) || '        .fecha' || chr(10) ||
               '          {mso-number-format:"dd\\-mmm\\-yyyy";}' ||
               chr(10) || '    -->' || chr(10) ||
               ' </style><div id="libro">' || chr(10);
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := '<table border = 0><tr><th>' ||
               oc_empresas.NOMBRE_COMPANIA(1) || '</th></tr>';
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := '<tr><th>REPORTE DE COMISIONES TOTALES DEL ' ||
               TO_CHAR(dFecDesde, 'DD/MM/YYYY') || ' Al ' ||
               TO_CHAR(dFecHasta, 'DD/MM/YYYY') || '</th></tr>';
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := '<tr><th>  </th></tr></table>';
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Recibo</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Status Recibo</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Consecutivo Póliza</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Detalle/Subgrupo</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Endoso</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Agente</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Agente</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Moneda</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Id. Comisión</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Status</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Mto. Comis. Local</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Mto. Comis. Moneda</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tasa de Cambio</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Generada</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Pago Recibo</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Liquidación</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Control Liquidación</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Direc. Reg.</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Dirección Regional</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nivel Agte.</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Agte.</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Direccion</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RFC</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CURP</font></th>';
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  END IF;
  FOR X IN COM_Q LOOP
    BEGIN
      SELECT Cod_Agente_Distr,
             OC_AGENTES.NOMBRE_AGENTE(CodCia, Cod_Agente_Distr)
        INTO nCodDirecReg, cNombreDirecReg
        FROM AGENTES_DISTRIBUCION_POLIZA
       WHERE CodCia = X.CodCia
         AND IdPoliza = X.IdPoliza
         AND CodNivel = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        nCodDirecReg    := 0;
        cNombreDirecReg := 'SIN DIRECCION REGIONAL';
      WHEN TOO_MANY_ROWS THEN
        BEGIN
          SELECT MAX(Cod_Agente_Distr)
            INTO nCodDirecReg
            FROM AGENTES_DISTRIBUCION_POLIZA
           WHERE CodCia = X.CodCia
             AND IdPoliza = X.IdPoliza
             AND CodNivel = 1;
        
          cNombreDirecReg := OC_AGENTES.NOMBRE_AGENTE(X.CodCia,
                                                      nCodDirecReg);
        END;
    END;
    IF cFormato = 'TEXTO' THEN
      cCadena := X.Tipo || cLimitador || TO_CHAR(X.Recibo, '9999999999999') ||
                 cLimitador || X.StsRec || cLimitador ||
                 TO_CHAR(X.IdPoliza, '9999999999999') || cLimitador ||
                 TO_CHAR(X.IDetPol, '9999999999999') || cLimitador ||
                 TO_CHAR(X.IdEndoso, '9999999999999') || cLimitador ||
                 TO_CHAR(X.Cod_Agente, '9999999999990') || cLimitador ||
                 X.NombreAgente || cLimitador || X.Cod_Moneda || cLimitador ||
                 TO_CHAR(X.IdComision, '9999999999990') || cLimitador ||
                 X.Estado || cLimitador ||
                 TO_CHAR(X.Comision_Local, '99999999999990.00') ||
                 cLimitador ||
                 TO_CHAR(X.Comision_Moneda, '99999999999990.00') ||
                 cLimitador || TO_CHAR(X.Tasa_Cambio, '9999990.00') ||
                 cLimitador || TO_CHAR(X.Fec_Generacion, 'DD/MM/YYYY') ||
                 cLimitador || TO_CHAR(X.Fec_Estado, 'DD/MM/RRRR') ||
                 cLimitador || TO_CHAR(X.Fec_Liquidacion, 'DD/MM/RRRR') ||
                 cLimitador || TO_CHAR(X.IdNomina, '99999999999990') ||
                 cLimitador || TO_CHAR(nCodDirecReg, '99999999999990') ||
                 cLimitador || cNombreDirecReg || cLimitador ||
                 X.NivelAgente || cLimitador || X.TipoAgente || cLimitador ||
                 X.DIRECCION || cLimitador || X.RFC || cLimitador || X.CURP ||
                 CHR(13);
    ELSE
      cCadena := '<tr>' || OC_ARCHIVO.CAMPO_HTML(X.Tipo, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Recibo, '9999999999990'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.StsRec, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdPoliza, '9999999999990'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IDetPol, '9999999999990'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdEndoso, '9999999999990'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Cod_Agente,
                                               '9999999999990'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.NombreAgente, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Cod_Moneda, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdComision,
                                               '9999999999990'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Estado, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Comision_Local,
                                               '99999999999990.00'),
                                       'N') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Comision_Moneda,
                                               '99999999999990.00'),
                                       'N') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Tasa_Cambio, '9999990.00'),
                                       'N') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Fec_Generacion,
                                               'DD/MM/YYYY'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Fec_Estado, 'DD/MM/RRRR'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Fec_Liquidacion,
                                               'DD/MM/RRRR'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdNomina, '99999999999990'),
                                       'N') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nCodDirecReg,
                                               '99999999999990'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(cNombreDirecReg, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.NivelAgente, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.TipoAgente, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.DIRECCION, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.RFC, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.CURP, 'C') || '</tr>';
    END IF;
    nLinea := nLinea + 1;
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  END LOOP;
  IF cFormato = 'EXCEL' THEN
    OC_ARCHIVO.Escribir_Linea('</table></div></html>', ccodUSER, 9999);
  END IF;
  OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0);
  INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
    SELECT nIdReporte + 1,
           B.TIPO_REPORTE,
           B.CODUSR,
           SYSDATE,
           'GEN',
           A.DATA,
           B.FILE_NAME
      FROM SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
     WHERE A.CODUSER = B.CODUSR
       AND B.IDEXTRACCION = nIdReporte;
  DELETE SICAS_OC.EXTRACCION_DE_REPORTES WHERE IDEXTRACCION = nIdReporte;
  OC_ARCHIVO.Eliminar_Archivo(cCodUser);

END;

PROCEDURE GENERAR_COMISIONES_NVAS(cNomArchivo VARCHAR2, dFecDesde DATE, dFecHasta DATE, cformato varchar2, nidreporte number) IS cLimitador VARCHAR2(1) := '|';
nLinea NUMBER;
cCadena VARCHAR2(4000);
cCodUser VARCHAR2(30);
nDummy NUMBER;
cCopy BOOLEAN;
cDescStatus VARCHAR2(30);
nCodDirecReg AGENTES.Cod_Agente%TYPE;
cNombreDirecReg VARCHAR2(500);

CURSOR q IS
  SELECT g.cd_cia Cia, g.cd_agente Agente, dFecHasta MES
    FROM saldos_comisiones g
   WHERE g.fe_ini_saldo BETWEEN dFecDesde AND dFecHasta
   GROUP BY g.cd_cia, g.cd_agente
   ORDER BY 2, 3;

CURSOR z(vCia IN saldos_comisiones_detalle.cd_cia%TYPE, vAgente IN saldos_comisiones_detalle.cd_agente%TYPE, vFecha IN DATE) IS
  SELECT a1.cd_cia Cia,
         a1.cd_agente Agente,
         LAST_DAY(vFecha) feFinSaldo,
         SUM(a1.mt_comision) ComisionMes,
         SUM(a1.mt_iva) IvaAcreMes,
         SUM(a1.mt_ivaret) IvaRetMes,
         SUM(a1.mt_isrret) IsrretMes,
         SUM(a1.mt_subtotal) SubtotMes,
         SUM(a1.mt_encontra) EnContrMes,
         SUM(a1.mt_afavor) AfavorMes
    FROM saldos_comisiones_detalle a1
   WHERE a1.cd_cia = vCia
     AND a1.cd_agente = vAgente
     AND a1.st_comision = 'REC'
     AND ((TRUNC(a1.fe_pago) IS NULL) AND
         (TRUNC(a1.fe_ini_saldo) <= LAST_DAY(vFecha)))
   GROUP BY a1.cd_cia, a1.cd_agente;

y z%ROWTYPE;
r q%ROWTYPE;

BEGIN
  SELECT CODUSR
    INTO cCodUser
    FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte;

  cDescStatus := 'POR PAGAR';
  --message('Parámetros: ('||cNomArchivo||') ('||dFecDesde||') ('||dFecHasta||')');

  IF cFormato = 'TEXTO' THEN
    nLinea  := 1;
    cCadena := oc_empresas.NOMBRE_COMPANIA(1) || CHR(13);
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := 'NUEVO REPORTE DE COMISIONES ' || cDescStatus || ' DEL ' ||
               TO_CHAR(dFecDesde, 'DD/MM/YYYY') || ' AL ' ||
               TO_CHAR(dFecHasta, 'DD/MM/YYYY') || CHR(13);
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := ' ' || CHR(13);
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := 'Cia' || cLimitador || 'Agente' || cLimitador ||
               'Fecha Fin Saldo' || cLimitador || 'Comision Mes' ||
               cLimitador || 'IVA Acre. Mes' || cLimitador || 'IVA Ret Mes' ||
               cLimitador || 'ISR Ret Mes' || cLimitador || 'SubTotMes' ||
               cLimitador || 'Movs. Negativos' || cLimitador ||
               'Movs. Positivos' || cLimitador || CHR(13);
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  ELSE
    nLinea  := 1;
    cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"' ||
               chr(10) ||
               ' xmlns:x="urn:schemas-microsoft-com:office:excel"' ||
               chr(10) || ' xmlns="http://www.w3.org/TR/REC-html40">' ||
               chr(10) || ' <style id="libro">' || chr(10) ||
               '   <!--table' || chr(10) ||
               '       {mso-displayed-decimal-separator:"\.";' || chr(10) ||
               '        mso-displayed-thousand-separator:"\,";}' || chr(10) ||
               '        .texto' || chr(10) ||
               '          {mso-number-format:"\@";}' || chr(10) ||
               '        .numero' || chr(10) ||
               '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}' ||
               chr(10) || '        .fecha' || chr(10) ||
               '          {mso-number-format:"dd\\-mmm\\-yyyy";}' ||
               chr(10) || '    -->' || chr(10) ||
               ' </style><div id="libro">' || chr(10);
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := '<table border = 0><tr><th>' ||
               oc_empresas.NOMBRE_COMPANIA(1) || '</th></tr>';
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := '<tr><th>NUEVO REPORTE DE COMISIONES ' || cDescStatus ||
               ' DEL ' || TO_CHAR(dFecDesde, 'DD/MM/YYYY') || ' Al ' ||
               TO_CHAR(dFecHasta, 'DD/MM/YYYY') || '</th></tr>';
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := '<tr><th>  </th></tr></table>';
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  
    nLinea  := nLinea + 1;
    cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Cia</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Agente</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Fin Saldo</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comision Mes</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IVA Acre. Mes</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IVA Ret Mes</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ISR Ret Mes</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">SubTotMes</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Movs. Negativos</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Movs. Positivos</font></th>';
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  END IF;

  OPEN q;
  LOOP
    FETCH q
      INTO r;
    EXIT WHEN q%NOTFOUND;
    OPEN z(r.Cia, r.Agente, r.MES);
    LOOP
      FETCH z
        INTO y;
      EXIT WHEN z%NOTFOUND;
      IF cFormato = 'TEXTO' THEN
        cCadena := TO_CHAR(y.Cia, '99999') || cLimitador ||
                   TO_CHAR(y.Agente, '9999999999990') || cLimitador ||
                   TO_CHAR(y.feFinSaldo, 'DD/MM/YYYY') || cLimitador ||
                   TO_CHAR(y.ComisionMes, '99999999999990.00') ||
                   cLimitador || TO_CHAR(y.IvaAcreMes, '99999999999990.00') ||
                   cLimitador || TO_CHAR(y.IvaRetMes, '99999999999990.00') ||
                   cLimitador || TO_CHAR(y.IsrretMes, '99999999999990.00') ||
                   cLimitador || TO_CHAR(y.SubtotMes, '99999999999990.00') ||
                   cLimitador || TO_CHAR(y.EnContrMes, '99999999999990.00') ||
                   cLimitador || TO_CHAR(y.AfavorMes, '99999999999990.00') ||
                   cLimitador || CHR(13);
      ELSE
        cCadena := '<tr>' ||
                   OC_ARCHIVO.CAMPO_HTML(TO_CHAR(y.Cia, '99999'), 'C') ||
                   OC_ARCHIVO.CAMPO_HTML(TO_CHAR(y.Agente, '9999999999990'),
                                         'C') ||
                   OC_ARCHIVO.CAMPO_HTML(TO_CHAR(y.feFinSaldo, 'DD/MM/YYYY'),
                                         'C') ||
                   OC_ARCHIVO.CAMPO_HTML(TO_CHAR(y.ComisionMes,
                                                 '99999999999990.00'),
                                         'C') ||
                   OC_ARCHIVO.CAMPO_HTML(TO_CHAR(y.IvaAcreMes,
                                                 '99999999999990.00'),
                                         'C') ||
                   OC_ARCHIVO.CAMPO_HTML(TO_CHAR(y.IvaRetMes,
                                                 '99999999999990.00'),
                                         'C') ||
                   OC_ARCHIVO.CAMPO_HTML(TO_CHAR(y.IsrretMes,
                                                 '99999999999990.00'),
                                         'C') ||
                   OC_ARCHIVO.CAMPO_HTML(TO_CHAR(y.SubtotMes,
                                                 '99999999999990.00'),
                                         'C') ||
                   OC_ARCHIVO.CAMPO_HTML(TO_CHAR(y.EnContrMes,
                                                 '99999999999990.00'),
                                         'C') ||
                   OC_ARCHIVO.CAMPO_HTML(TO_CHAR(y.AfavorMes,
                                                 '99999999999990.00'),
                                         'C') || '</tr>';
      END IF;
      nLinea := nLinea + 1;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
    END LOOP;
    CLOSE z;
  END LOOP;
  CLOSE q;
  IF cFormato = 'EXCEL' THEN
    OC_ARCHIVO.Escribir_Linea('</table></div></html>', ccodUSER, 9999);
  END IF;
  OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0);
  INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
    SELECT nIdReporte + 1,
           B.TIPO_REPORTE,
           B.CODUSR,
           SYSDATE,
           'GEN',
           A.DATA,
           B.FILE_NAME
      FROM SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
     WHERE A.CODUSER = B.CODUSR
       AND B.IDEXTRACCION = nIdReporte;
  DELETE SICAS_OC.EXTRACCION_DE_REPORTES WHERE IDEXTRACCION = nIdReporte;
  OC_ARCHIVO.Eliminar_Archivo(cCodUser);
END;

PROCEDURE GENERAR_COMISIONES_HIST(cNomArchivo VARCHAR2, dFecDesde DATE, dFecHasta DATE, cformato varchar2, nidreporte number) IS 
				cLimitador        VARCHAR2(1) :='|';
				cAbre             VARCHAR2(20) :='<td>';
				cCierra           VARCHAR2(20) :='</td>';
				nLinea            NUMBER;
				cCadena           VARCHAR2(4000);
		    MiCadena          VARCHAR2(4000);
				cCodUser          VARCHAR2(30);
				nDummy            NUMBER;
				cCopy             BOOLEAN;
				cDescStatus       VARCHAR2(30);
				nCodDirecReg      AGENTES.Cod_Agente%TYPE;
				cNombreDirecReg   VARCHAR2(500);

		    xCia           saldos_comisiones_detalle.cd_cia%TYPE;
		    xAge           saldos_comisiones_detalle.cd_agente%TYPE;
		    xFecha         saldos_comisiones_detalle.fe_ini_saldo%TYPE;
		    MiCadTem       VARCHAR2(500);
		    cConstante     VARCHAR2(50) := '|0|0|0|0|0|0|0|';
		    cConstExcel    VARCHAR2(300) := '<td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td>';
		    FeIni          DATE;
		    FeFin          DATE;
		    vTotNetos      VARCHAR2(3000);
		    vTotBruto      VARCHAR2(3000);
		    vpTotNetos     VARCHAR2(3000);
		    vpTotBruto     VARCHAR2(3000);    
		    nTotNetos      NUMBER(18,2) := 0;
		    nTotBruto      NUMBER(18,2) := 0;
		    GTnTotNetos    NUMBER(18,2) := 0;
		    GTnTotBruto    NUMBER(18,2) := 0;    
		 
		    CURSOR a (vCia    IN saldos_comisiones_detalle.cd_cia%TYPE   , 
		              vAgente IN saldos_comisiones_detalle.cd_agente%TYPE) IS 
		     SELECT codcia     cia, 
		            cod_agente cve 
		       FROM agentes 
		      WHERE codcia     = vCia
		        AND cod_agente = DECODE(vAgente, 0, cod_agente, vAgente);--Agente;
		  
		   b a%ROWTYPE;

BEGIN 
  SELECT CODUSR
    INTO cCodUser
    FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte;

   IF cFormato = 'TEXTO' THEN
      nLinea      := 1;
      cCadena     := oc_empresas.NOMBRE_COMPANIA(1) || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

      nLinea := nLinea + 1;
      cCadena     := 'REPORTE HISTORICO DE COMISIONES ' || cDescStatus || ' DEL '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' AL ' || TO_CHAR(dFecHasta,'DD/MM/YYYY') || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

      nLinea := nLinea + 1;
      cCadena     := ' ' || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

      nLinea := nLinea + 1;
      cCadena     := ' | | '||'|||||||||||||||||||||||||||||||||||||||||||DETALLE|||||||||||||||||||||||||||||||||||||||||||||||||||'||
                              '||||||Totales ANTES   DE IMPUESTOS||||||'||
                              '||||||Totales DESPUES DE IMPUESTOS||||||'||
                              '|Grandes TOTALES|'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);      

      nLinea := nLinea + 1;
      cCadena     :=  'Agente'     ||cLimitador||	  
											'Fecha'      ||cLimitador||--Enero	  
											'Comisiones' ||cLimitador||'Iva Acre'||cLimitador||'Iva Ret'||cLimitador||'Isr Ret'||cLimitador||'Total'||cLimitador||'EnContra'||cLimitador||'A Favor'||cLimitador||
											'Fecha'      ||cLimitador||--Febrero
											'Comisiones' ||cLimitador||'Iva Acre'||cLimitador||'Iva Ret'||cLimitador||'Isr Ret'||cLimitador||'Total'||cLimitador||'EnContra'||cLimitador||'A Favor'||cLimitador||
											'Fecha'      ||cLimitador||--Marzo
											'Comisiones' ||cLimitador||'Iva Acre'||cLimitador||'Iva Ret'||cLimitador||'Isr Ret'||cLimitador||'Total'||cLimitador||'EnContra'||cLimitador||'A Favor'||cLimitador||
											'Fecha'      ||cLimitador||--Abril
											'Comisiones' ||cLimitador||'Iva Acre'||cLimitador||'Iva Ret'||cLimitador||'Isr Ret'||cLimitador||'Total'||cLimitador||'EnContra'||cLimitador||'A Favor'||cLimitador||
											'Fecha'      ||cLimitador||--Mayo
											'Comisiones' ||cLimitador||'Iva Acre'||cLimitador||'Iva Ret'||cLimitador||'Isr Ret'||cLimitador||'Total'||cLimitador||'EnContra'||cLimitador||'A Favor'||cLimitador||
											'Fecha'      ||cLimitador||--Junio
											'Comisiones' ||cLimitador||'Iva Acre'||cLimitador||'Iva Ret'||cLimitador||'Isr Ret'||cLimitador||'Total'||cLimitador||'EnContra'||cLimitador||'A Favor'||cLimitador||
											'Fecha'      ||cLimitador||--Julio
											'Comisiones' ||cLimitador||'Iva Acre'||cLimitador||'Iva Ret'||cLimitador||'Isr Ret'||cLimitador||'Total'||cLimitador||'EnContra'||cLimitador||'A Favor'||cLimitador||
											'Fecha'      ||cLimitador||--Agosto	  
											'Comisiones' ||cLimitador||'Iva Acre'||cLimitador||'Iva Ret'||cLimitador||'Isr Ret'||cLimitador||'Total'||cLimitador||'EnContra'||cLimitador||'A Favor'||cLimitador||
											'Fecha'      ||cLimitador||--Septiembre	  
											'Comisiones' ||cLimitador||'Iva Acre'||cLimitador||'Iva Ret'||cLimitador||'Isr Ret'||cLimitador||'Total'||cLimitador||'EnContra'||cLimitador||'A Favor'||cLimitador||
											'Fecha'      ||cLimitador||--Octubre 
											'Comisiones' ||cLimitador||'Iva Acre'||cLimitador||'Iva Ret'||cLimitador||'Isr Ret'||cLimitador||'Total'||cLimitador||'EnContra'||cLimitador||'A Favor'||cLimitador||	  
											'Fecha'      ||cLimitador||--Noviembre  
											'Comisiones' ||cLimitador||'Iva Acre'||cLimitador||'Iva Ret'||cLimitador||'Isr Ret'||cLimitador||'Total'||cLimitador||'EnContra'||cLimitador||'A Favor'||cLimitador||
											'Fecha'      ||cLimitador||--Diciembre  
											'Comisiones' ||cLimitador||'Iva Acre'||cLimitador||'Iva Ret'||cLimitador||'Isr Ret'||cLimitador||'Total'||cLimitador||'EnContra'||cLimitador||'A Favor'||cLimitador||
											'Enero'      ||cLimitador||-- Totales Antes de Impuestos
											'Febrero'    ||cLimitador||'Marzo'||cLimitador||'Abril'||cLimitador||'Mayo'||cLimitador||'Junio'||cLimitador||'Julio'||cLimitador||'Agosto'||cLimitador||'Septiembre'||cLimitador||'Octubbre'||cLimitador||'Noviembre'||cLimitador||'Diciembre'||cLimitador||
											'Enero'      ||cLimitador||-- Totales Despues de Impuestos
											'Febrero'    ||cLimitador||'Marzo'||cLimitador||'Abril'||cLimitador||'Mayo'||cLimitador||'Junio'||cLimitador||'Julio'||cLimitador||'Agosto'||cLimitador||'Septiembre'||cLimitador||'Octubbre'||cLimitador||'Noviembre'||cLimitador||'Diciembre'||cLimitador||							   
											'Saldos Netos Despues de Impuestos'  ||cLimitador||'Comisiones Brutas Antes de Impuestos'  ||cLimitador||	  										   
											CHR(13);	  	  
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   ELSE
      nLinea := 1;
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
                       '          {mso-number-format:"dd\\-mmm\\-yyyy";}'||chr(10)||
                       '    -->'||chr(10)||
                       ' </style><div id="libro">'||chr(10);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<table border = 0><tr><th>' || oc_empresas.NOMBRE_COMPANIA(1) || '</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<tr><th>REPORTE HISTORICO DE COMISIONES ' || cDescStatus || ' DEL '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' ||
                      TO_CHAR(dFecHasta,'DD/MM/YYYY') || '</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<tr><th>  </th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      --<tr></tr>
      cCadena := '<tr><th align=center bgcolor = "#6A8099"> </th><th align=center bgcolor = "#6A8099" colspan="96">Detalle</th>'||
                 '<th align=center bgcolor = "#74AE98" colspan="12">Totales ANTES   DE IMPUESTOS</th>'||
                 '<th align=center bgcolor = "#2E8839" colspan="12">Totales DESPUES DE IMPUESTOS</th>'||
                 '<th align=center bgcolor = "#CBE36C" colspan="2">Grandes TOTALES</th></tr></table>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);      
      
      nLinea := nLinea + 1;
      cCadena     := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Agente</font></th>'     ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha</font></th>'      ||--Enero	  
										   '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comisiones</font></th>' ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Iva Acre</font></th>'   ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Iva Ret</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Isr Ret</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total</font></th>'      ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">EnContra</font></th>'   ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">A Favor</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha</font></th>'      ||--Febrero
										   '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comisiones</font></th>' ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Iva Acre</font></th>'   ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Iva Ret</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Isr Ret</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total</font></th>'      ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">EnContra</font></th>'   ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">A Favor</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha</font></th>'      ||--Marzo
										   '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comisiones</font></th>' ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Iva Acre</font></th>'   ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Iva Ret</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Isr Ret</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total</font></th>'      ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">EnContra</font></th>'   ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">A Favor</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha</font></th>'      ||--Abril
										   '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comisiones</font></th>' ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Iva Acre</font></th>'   ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Iva Ret</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Isr Ret</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total</font></th>'      ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">EnContra</font></th>'   ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">A Favor</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha</font></th>'      ||--Mayo
										   '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comisiones</font></th>' ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Iva Acre</font></th>'   ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Iva Ret</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Isr Ret</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total</font></th>'      ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">EnContra</font></th>'   ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">A Favor1</font></th>'    ;--    ||	  
        OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);									     

        cCadena :=    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha</font></th>'      ||--Junio
										   '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comisiones</font></th>' ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Iva Acre</font></th>'   ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Iva Ret</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Isr Ret</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total</font></th>'      ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">EnContra</font></th>'   ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">A Favor</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha</font></th>'      ||--Julio
										   '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comisiones</font></th>' ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Iva Acre</font></th>'   ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Iva Ret</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Isr Ret</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total</font></th>'      ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">EnContra</font></th>'   ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">A Favor</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha</font></th>'      ||--Agosto	  
										   '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comisiones</font></th>' ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Iva Acre</font></th>'   ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Iva Ret</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Isr Ret</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total</font></th>'      ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">EnContra</font></th>'   ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">A Favor</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha</font></th>'      ||--Septiembre	  
										   '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comisiones</font></th>' ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Iva Acre</font></th>'   ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Iva Ret</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Isr Ret</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total</font></th>'      ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">EnContra</font></th>'   ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">A Favor</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha</font></th>'      ||--Octubre 
										   '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comisiones</font></th>' ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Iva Acre</font></th>'   ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Iva Ret</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Isr Ret</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total</font></th>'      ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">EnContra</font></th>'   ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">A Favor2</font></th>'    ;--   ||	  
          OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);									     									     
          cCadena  :=  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha</font></th>'      ||--Noviembre  
										   '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comisiones</font></th>' ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Iva Acre</font></th>'   ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Iva Ret</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Isr Ret</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total</font></th>'      ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">EnContra</font></th>'   ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">A Favor</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha</font></th>'      ||--Diciembre  
										   '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comisiones</font></th>' ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Iva Acre</font></th>'   ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Iva Ret</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Isr Ret</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total</font></th>'      ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">EnContra</font></th>'   ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">A Favor</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Enero</font></th>'      ||-- Totales Antes de Impuestos
										   '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Febrero</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Marzo</font></th>'      ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Abril</font></th>'      ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Mayo</font></th>'       ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Junio</font></th>'      ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Julio</font></th>'      ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Agosto</font></th>'     ||	  
                       '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Septiembre</font></th>' ||	  
                       '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Octubbre</font></th>'   ||	  
                       '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Noviembre</font></th>'  ||	  
                       '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Diciembre</font></th>'  ||
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Enero</font></th>'      ||-- Totales Despues de Impuestos
										   '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Febrero</font></th>'    ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Marzo</font></th>'      ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Abril</font></th>'      ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Mayo</font></th>'       ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Junio</font></th>'      ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Julio</font></th>'      ||	  
									     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Agosto</font></th>'     ||	  
                       '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Septiembre</font></th>' ||	  
                       '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Octubre</font></th>'   ||	  
                       '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Noviembre</font></th>'  ||	  
                       '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Diciembre</font></th>'  ||	  																	   
                       '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Saldos Netos Despues de Impuestos</font></th>'  ||	  
                       '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comisiones Brutas Antes de Impuestos</font></th>'
										 ;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END IF;

   --message('He terminado de escribir los titulos');SYNCHRONIZE;
   OPEN a(1,0);
   LOOP 
        FETCH a INTO b;
         EXIT WHEN a%NOTFOUND;
                MiCadena  := '';
                MiCadTem  := '';
                vTotNetos := ''; 
                vTotBruto := '';
                nTotNetos := 0; 
                nTotBruto := 0;
                GTnTotNetos := 0; 
                GTnTotBruto := 0;
                FOR x IN 1..12 LOOP 
                    FeIni := trunc(TO_DATE(LPAD(to_char(x),2,'0')||to_char(trunc(sysdate)-1,'YYYY'),'MMYYYY'));
                    FeFin := LAST_DAY(TO_DATE(LPAD(to_char(x),2,'0')||to_char(trunc(sysdate)-1,'YYYY'),'MMYYYY'));
                    BEGIN
			                          SELECT FeFin             ||cLimitador || --feFinSaldo ,     
			                                 SUM(g.mt_comision)||cLimitador|| --ComisionMes,
			                                 SUM(g.mt_iva)     ||cLimitador|| --IvaAcreMes ,
			                                 SUM(g.mt_ivaret)  ||cLimitador|| --IvaRetMes  ,
			                                 SUM(g.mt_isrret)  ||cLimitador|| --IsrretMes  ,
			                                 SUM(g.mt_subtotal)||cLimitador|| --SubtotMes  ,
			                                 SUM(g.mt_encontra)||cLimitador|| --EnContrMes ,       
			                                 SUM(g.mt_afavor)  ||cLimitador ,   --AfavorMes 
			                                 TO_CHAR(SUM(g.mt_afavor)   +
			                                         SUM(g.mt_encontra))||cLimitador ,
			                                 SUM(g.mt_comision) ||cLimitador  ,
			                                 SUM(g.mt_afavor) + SUM(g.mt_encontra)  ,
			                                 SUM(g.mt_comision)   
			                            INTO MiCadTem, vpTotNetos, vpTotBruto , nTotNetos, nTotBruto
			                            FROM saldos_comisiones_detalle g
			                           WHERE g.cd_cia        = b.cia
			                             AND g.cd_agente     = b.cve
			                             AND g.st_comision  = 'REC'
			                             AND ((TRUNC(g.fe_pago) IS NULL) 
			                             AND g.fe_ini_saldo BETWEEN FeIni   
			                                                    and FeFin) 
			                             AND cFormato = 'TEXTO'
			                           GROUP BY g.cd_cia, g.cd_agente,FeFin
	                         UNION                                   
                          SELECT cAbre||TO_CHAR(Fefin,'DD/MM/YYYY')||cCierra|| --feFinSaldo ,     
                                 cAbre||SUM(g.mt_comision)         ||cCierra|| --ComisionMes,
                                 cAbre||SUM(g.mt_iva)              ||cCierra|| --IvaAcreMes ,
                                 cAbre||SUM(g.mt_ivaret)           ||cCierra|| --IvaRetMes  ,
                                 cAbre||SUM(g.mt_isrret)           ||cCierra|| --IsrretMes  ,
                                 cAbre||SUM(g.mt_subtotal)         ||cCierra|| --SubtotMes  ,
                                 cAbre||SUM(g.mt_encontra)         ||cCierra|| --EnContrMes ,       
                                 cAbre||SUM(g.mt_afavor)           ||cCierra MiCadTem,   --AfavorMes 
                                 cAbre||TO_CHAR(SUM(g.mt_afavor)   +
                                                SUM(g.mt_encontra))||cCierra vpTotNetos,
                                 cAbre||SUM(g.mt_comision)         ||cCierra vpTotBruto,
                                        SUM(g.mt_afavor)   +
                                        SUM(g.mt_encontra)  ntotNetos,
                                        SUM(g.mt_comision)  ntotBruto 
                            FROM saldos_comisiones_detalle g
                           WHERE g.cd_cia        = b.cia
                             AND g.cd_agente     = b.cve
                             AND g.st_comision  = 'REC'
                             AND ((TRUNC(g.fe_pago) IS NULL) 
                             AND g.fe_ini_saldo BETWEEN FeIni
                                                    AND Fefin)
                             AND cFormato != 'TEXTO'                                                    
                           GROUP BY g.cd_cia, g.cd_agente,FeFin;
                           GTnTotNetos := GTnTotNetos + nTotNetos; 
                           GTnTotBruto := GTnTotBruto + nTotBruto;

                     EXCEPTION 
                          WHEN no_data_found THEN 
                               SELECT DECODE(cFormato,'TEXTO', TO_CHAR(FeFin,'DD/MM/YYYY')||cConstante,
                                                                       cAbre||TO_CHAR(FeFin,'DD/MM/YYYY')||cCierra||cConstExcel),
                                      DECODE(cFormato,'TEXTO','0'||cLimitador, 
                                                                        cAbre||'0'||cCierra   ),
                                      DECODE(cFormato,'TEXTO','0'||cLimitador,
                                                                        cAbre||'0'||cCierra   )                                                                                                         
                                 INTO MiCadTem, vpTotNetos, vpTotBruto
                                 FROM dual ;
                     END;
                     --MESSAGE('MiCadTem es: '||MiCadTem||' '||vpTotNetos||' '||vpTotBruto||')');synchronize;
                     MiCadena  := Micadena||MiCadTem;
                     vTotNetos := vTotNetos||vpTotNetos; 
                     vTotBruto := vTotBruto||vpTotBruto;                     
                 END LOOP;
                 --MiCadena  := b.cve||cLimitador||MiCadena||vTotBruto||vTotNetos||GTnTotNetos||cLimitador||GTnTotBruto||'|';                 
						      IF cFormato = 'TEXTO' THEN
						      	 MiCadena  := b.cve||cLimitador||MiCadena||vTotBruto||vTotNetos||GTnTotNetos||cLimitador||GTnTotBruto||'|';                 
						         cCadena := MiCadena||CHR(13); 
						      ELSE
						      	MiCadena  := b.cve||cCierra||MiCadena||vTotBruto||vTotNetos||cAbre||GTnTotNetos||cCierra||cAbre||GTnTotBruto||cCierra;                 
						         cCadena := '<tr>' ||OC_ARCHIVO.CAMPO_HTML(MiCadena,'C')||'</tr>';
						      END IF;
						      nLinea := nLinea + 1;
						      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END LOOP;
	 CLOSE a;
   IF CFormato = 'EXCEL' THEN
      OC_ARCHIVO.Escribir_Linea('</table></div></html>', ccodUSER, 9999);
   END IF;
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
  INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
    SELECT nIdReporte + 1,
           B.TIPO_REPORTE,
           B.CODUSR,
           SYSDATE,
           'GEN',
           A.DATA,
           B.FILE_NAME
      FROM SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
     WHERE A.CODUSER = B.CODUSR
       AND B.IDEXTRACCION = nIdReporte;
  DELETE SICAS_OC.EXTRACCION_DE_REPORTES WHERE IDEXTRACCION = nIdReporte;
  OC_ARCHIVO.Eliminar_Archivo(cCodUser);
EXCEPTION 
   WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      RAISE_APPLICATION_ERROR(-20105,'Error en Generación de Comisiones ' || cDescStatus || ' ' ||SQLERRM); 
      
END;

PROCEDURE LISTAR_AGENTES(cNomArchivo VARCHAR2, CTIPOREP NUMBER, cformato varchar2, nidreporte number) IS cLimitador VARCHAR2(1) := '|';
nLinea NUMBER;
cCadena VARCHAR2(4200);
cCodUser VARCHAR2(30);
nDummy NUMBER;
cCopy BOOLEAN;
dFecVencimiento AGENTES_CEDULA_AUTORIZADA.FecVencimiento%TYPE;
cTipoCedula AGENTES_CEDULA_AUTORIZADA.TipoCedula%TYPE;
cNumCedula AGENTES_CEDULA_AUTORIZADA.NumCedula%TYPE;
dFecVencPolRc AGENTES_CEDULA_AUTORIZADA.FecVencPolRc%TYPE;
cNumPolRc AGENTES_CEDULA_AUTORIZADA.NumPolRc%TYPE;
cNomAsegPolRc AGENTES_CEDULA_AUTORIZADA.NomAsegPolRc%TYPE;
cCodFormaPago MEDIOS_DE_PAGO.CodFormaPago%TYPE;
cCodEntidadFinan MEDIOS_DE_PAGO.CodEntidadFinan%TYPE;
cNumCuentaBancaria MEDIOS_DE_PAGO.NumCuentaBancaria%TYPE;
cNumCuentaClabe MEDIOS_DE_PAGO.NumCuentaClabe%TYPE;
cNombreEntidad VARCHAR2(300);
cDescFormaPago VALORES_DE_LISTAS.DescValLst%TYPE;

wAGENTE_PROMOTOR AGENTES.Cod_Agente_Jefe%TYPE;
wNOMBRE_PROMOTOR VARCHAR2(300);
wCODNIVEL_PROMOTOR AGENTES.CODNIVEL%TYPE;
wNIVEL_PROMOTOR VARCHAR2(100);

wDR_CODIGO AGENTES.Cod_Agente_Jefe%TYPE;
wDR_NOMBRE VARCHAR2(300);
wDR_CODNIVEL AGENTES.CODNIVEL%TYPE;
wDR_NIVEL VARCHAR2(100);

CURSOR AGT_Q IS

  SELECT A.Cod_Agente,
         OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(A.Tipo_Doc_Identificacion,
                                                     A.Num_Doc_Identificacion) Nombre_Agente,
         A.Est_Agente,
         A.Tipo_Agente,
         A.CanalComisVenta,
         A.CodTipo,
         A.CodNivel CodNivel,
         DECODE(A.CODNIVEL,
                1,
                'DIRECCION REGIONAL',
                2,
                'PROMOTOR',
                3,
                'AGENTE',
                4,
                'HONORARIOS',
                5,
                'UDI') NIVEL_AGENTE,
         CE.Email,
         TRIM(P.DirecRes) || ' ' || TRIM(NumExterior) || ' ' ||
         DECODE(NumInterior, NULL, NULL, 'Interior') || ' ' ||
         TRIM(NumInterior) || ' ' ||
         TRIM(OC_COLONIA.DESCRIPCION_COLONIA(P.CodPaisRes,
                                             P.CodProvRes,
                                             P.CodDistRes,
                                             P.CodCorrres,
                                             P.CodPosRes,
                                             CodColRes)) || ', ' ||
         TRIM(OC_PROVINCIA.NOMBRE_PROVINCIA(P.CodPaisRes, P.CodProvRes)) || ', ' ||
         TRIM(OC_CORREGIMIENTO.NOMBRE_CORREGIMIENTO(P.CodPaisRes,
                                                    P.CodProvRes,
                                                    P.CodDistRes,
                                                    P.CodCorrRes)) ||
         ', CP ' || TRIM(P.CodPosRes) Direccion,
         P.TelRes,
         A.CodCia,
         A.Tipo_Doc_Identificacion,
         A.Num_Doc_Identificacion,
         
         OC_AGENTES.EJECUTIVO_COMERCIAL(A.CodCia, A.Cod_Agente) CodEjecutivo,
         OC_EJECUTIVO_COMERCIAL.NOMBRE_EJECUTIVO(A.CodCia,
                                                 OC_AGENTES.EJECUTIVO_COMERCIAL(A.CodCia,
                                                                                A.Cod_Agente)) NombreEjecutivo,
         A.IdFormaPago,
         ---  AEVS  12062017
         TO_CHAR(B.COD_AGENTE) AGENTE_PROMOTOR,
         OC_AGENTES.NOMBRE_AGENTE(B.CodCia, B.COD_AGENTE) NOMBRE_PROMOTOR,
         B.CODNIVEL CODNIVEL_PROMOTOR,
         DECODE(B.CODNIVEL,
                1,
                'DIRECCION REGIONAL',
                2,
                'PROMOTOR',
                3,
                'AGENTE',
                4,
                'HONORARIOS',
                5,
                'UDI') NIVEL_PROMOTOR,
         ----- AEVS  12062017
         TO_CHAR(C.COD_AGENTE) DR_CODIGO,
         OC_AGENTES.NOMBRE_AGENTE(C.CodCia, C.COD_AGENTE) DR_NOMBRE,
         C.CODNIVEL DR_CODNIVEL,
         DECODE(C.CODNIVEL,
                1,
                'DIRECCION REGIONAL',
                2,
                'PROMOTOR',
                3,
                'AGENTE',
                4,
                'HONORARIOS',
                5,
                'UDI') DR_NIVEL,
         a.Fecalta Fecha_Alta
    FROM AGENTES                  A,
         PERSONA_NATURAL_JURIDICA P,
         --  AEVS 12062017
         AGENTES                  B,
         AGENTES                  C,
         CORREOS_ELECTRONICOS_PNJ CE
   WHERE P.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
     AND P.Num_Doc_Identificacion = A.Num_Doc_Identificacion
        ---  AEVS 12062017
     AND B.COD_AGENTE(+) = A.COD_AGENTE_JEFE
        ---  AEVS 12062017
     AND C.COD_AGENTE(+) = B.COD_AGENTE_JEFE
        --
     AND CE.TIPO_DOC_IDENTIFICACION = A.TIPO_DOC_IDENTIFICACION
     AND CE.NUM_DOC_IDENTIFICACION = A.NUM_DOC_IDENTIFICACION
     AND CE.CORRELATIVO_EMAIL = A.IDCUENTACORREO
  ---AND ROWNUM < 24      
   ORDER BY 1; ---Cod_Agente;

BEGIN
  SELECT CODUSR
    INTO cCodUser
    FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte;

  nLinea  := 1;
  cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"' ||
             chr(10) || ' xmlns:x="urn:schemas-microsoft-com:office:excel"' ||
             chr(10) || ' xmlns="http://www.w3.org/TR/REC-html40">' ||
             chr(10) || ' <style id="libro">' || chr(10) || '   <!--table' ||
             chr(10) || '       {mso-displayed-decimal-separator:"\.";' ||
             chr(10) || '        mso-displayed-thousand-separator:"\,";}' ||
             chr(10) || '        .texto' || chr(10) ||
             '          {mso-number-format:"\@";}' || chr(10) ||
             '        .numero' || chr(10) ||
             '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}' ||
             chr(10) || '        .fecha' || chr(10) ||
             '          {mso-number-format:"dd\\-mmm\\-yyyy";}' || chr(10) ||
             '    -->' || chr(10) || ' </style><div id="libro">' || chr(10);
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

  nLinea  := nLinea + 1;
  cCadena := '<table border = 0><tr><th>' || OC_EMPRESAS.NOMBRE_COMPANIA(1) ||
             '</th></tr>';
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

  nLinea := nLinea + 1;

  --MESSAGE('2222');

  IF CTIPOREP = 1 THEN
    cCadena := '<tr><th> LISTADO CORTO DE AGENTES AL  ' ||
               TO_CHAR(TRUNC(SYSDATE), 'DD/MM/YYYY') || '</th></tr>';
  ELSIF CTIPOREP = 2 THEN
    cCadena := '<tr><th> LISTADO LARGO DE AGENTES AL  ' ||
               TO_CHAR(TRUNC(SYSDATE), 'DD/MM/YYYY') || '</th></tr>';
  END IF;

  --MESSAGE('33333');

  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

  nLinea  := nLinea + 1;
  cCadena := '<tr><th>  </th></tr></table>';
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

  --MESSAGE('444444');

  nLinea := nLinea + 1;

  IF CTIPOREP = 1 THEN
    cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código de Agente</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Agente</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nivel Jerárquico Agente</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descripción Nivel Jerárquico Agente</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Status</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Clase de Agente</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo de Agente</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Canal de Venta</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Clave de Promotor</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Promotor</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nivel Jerárquico Promotor</font></th>' ||
              --'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descripción Nivel Jerárquico Promotor</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Clave D.R</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre  D.R</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nivel Jerárquico D.R</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descripción Nivel Jerárquico D.R</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Doc. Identificacion</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Doc. Identificacion</font></th>' ||
              --'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Email</font></th>' ||                                    
              --'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Dirección</font></th>' ||                            
              --'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Teléfono</font></th>' ||                             
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo de Cédula</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Cédula</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Vencimiento de Cédula</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Póliza RC</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Aseguradora Póliza RC</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Vencimiento de Póliza RC</font></th>' ||
              --'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Forma de Pago</font></th>' ||                        
              --'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Entidad Financiera</font></th>' ||                   
              --'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Cuenta Bancaria</font></th>' ||                      
              --'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Cuenta CLABE</font></th>' || 
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Ejecutivo Comercial</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Ejecutivo Comercial</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de Alta del Agente </font></th>';
  
    --MESSAGE('5555555');  
  ELSIF CTIPOREP = 2 THEN
    cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código de Agente</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Agente</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nivel Jerárquico Agente</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descripción Nivel Jerárquico Agente</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Status</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Clase de Agente</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo de Agente</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Canal de Venta</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Clave de Promotor</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Promotor</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nivel Jerárquico Promotor</font></th>' ||
              --'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descripción Nivel Jerárquico Promotor</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Clave D.R</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre  D.R</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nivel Jerárquico D.R</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descripción Nivel Jerárquico D.R</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Doc. Identificacion</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Doc. Identificacion</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Email</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Dirección</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Teléfono</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo de Cédula</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Cédula</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Vencimiento de Cédula</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Póliza RC</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Aseguradora Póliza RC</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Vencimiento de Póliza RC</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Forma de Pago</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Entidad Financiera</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Cuenta Bancaria</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Cuenta CLABE</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Ejecutivo Comercial</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Ejecutivo Comercial</font></th>' ||
               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de Alta del Agente</font></th>';
  
    --MESSAGE('66666');
  END IF;

  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

  --MESSAGE('7777777');
  FOR X IN AGT_Q LOOP
  
    wAGENTE_PROMOTOR   := NULL;
    wNOMBRE_PROMOTOR   := NULL;
    wCODNIVEL_PROMOTOR := NULL;
    wNIVEL_PROMOTOR    := NULL;
    wDR_CODIGO         := NULL;
    wDR_NOMBRE         := NULL;
    wDR_CODNIVEL       := NULL;
    wDR_NIVEL          := NULL;
  
    --MESSAGE('1111111');
    BEGIN
      SELECT TipoCedula, NumCedula, FecVencimiento
        INTO cTipoCedula, cNumCedula, dFecVencimiento
        FROM AGENTES_CEDULA_AUTORIZADA
       WHERE CodCia = X.CodCia
         AND Cod_Agente = X.Cod_Agente
         AND FecVencimiento IN
             (SELECT MAX(FecVencimiento)
                FROM AGENTES_CEDULA_AUTORIZADA
               WHERE CodCia = X.CodCia
                 AND Cod_Agente = X.Cod_Agente);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        cTipoCedula     := NULL;
        cNumCedula      := NULL;
        dFecVencimiento := NULL;
      WHEN TOO_MANY_ROWS THEN
        cTipoCedula     := NULL;
        cNumCedula      := NULL;
        dFecVencimiento := NULL;
      WHEN OTHERS THEN
        cTipoCedula     := NULL;
        cNumCedula      := NULL;
        dFecVencimiento := NULL;
    END;
    --MESSAGE('2222222');
    BEGIN
      SELECT NumPolRc, NomAsegPolRc, FecVencPolRc
        INTO cNumPolRc, cNomAsegPolRc, dFecVencPolRc
        FROM AGENTES_CEDULA_AUTORIZADA
       WHERE CodCia = X.CodCia
         AND Cod_Agente = X.Cod_Agente
         AND FecVencPolRc IN
             (SELECT MAX(FecVencPolRc)
                FROM AGENTES_CEDULA_AUTORIZADA
               WHERE CodCia = X.CodCia
                 AND Cod_Agente = X.Cod_Agente);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        cNumPolRc     := NULL;
        cNomAsegPolRc := NULL;
        dFecVencPolRc := NULL;
      WHEN TOO_MANY_ROWS THEN
        cNumPolRc     := NULL;
        cNomAsegPolRc := NULL;
        dFecVencPolRc := NULL;
      WHEN OTHERS THEN
        cNumPolRc     := NULL;
        cNomAsegPolRc := NULL;
        dFecVencPolRc := NULL;
    END;
    --MESSAGE('33333333');
    BEGIN
      SELECT M.CodFormaPago,
             M.CodEntidadFinan,
             M.NumCuentaBancaria,
             M.NumCuentaClabe,
             OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(E.Tipo_Doc_Identificacion,
                                                         E.Num_Doc_Identificacion) NombreEntidad,
             OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMPAGO', M.CodFormaPago) DescFormaPago
        INTO cCodFormaPago,
             cCodEntidadFinan,
             cNumCuentaBancaria,
             cNumCuentaClabe,
             cNombreEntidad,
             cDescFormaPago
        FROM MEDIOS_DE_PAGO M, ENTIDAD_FINANCIERA E
       WHERE E.CodEntidad(+) = M.CodEntidadFinan
         AND M.Tipo_Doc_Identificacion = X.Tipo_Doc_Identificacion
         AND M.Num_Doc_Identificacion = X.Num_Doc_Identificacion
         AND M.IdFormaPago = X.IdFormaPago;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        cCodFormaPago      := NULL;
        cCodEntidadFinan   := NULL;
        cNumCuentaBancaria := NULL;
        cNumCuentaClabe    := NULL;
        cNombreEntidad     := NULL;
        cDescFormaPago     := NULL;
      WHEN TOO_MANY_ROWS THEN
        cCodFormaPago      := NULL;
        cCodEntidadFinan   := NULL;
        cNumCuentaBancaria := NULL;
        cNumCuentaClabe    := NULL;
        cNombreEntidad     := NULL;
        cDescFormaPago     := NULL;
      WHEN OTHERS THEN
        cCodFormaPago      := NULL;
        cCodEntidadFinan   := NULL;
        cNumCuentaBancaria := NULL;
        cNumCuentaClabe    := NULL;
        cNombreEntidad     := NULL;
        cDescFormaPago     := NULL;
    END;
  
    ---MESSAGE('AGENTE  '||X.Cod_Agente||'      X.CODNIVEL_PROMOTOR   '||X.CODNIVEL_PROMOTOR);
    --- Clave de Promotor  X solo si su jefe es nivel 2
  
    IF X.CODNIVEL_PROMOTOR in (1, 3, 4, 5) THEN
      ---wAGENTE_PROMOTOR   := X.AGENTE_PROMOTOR;              
      ---wNOMBRE_PROMOTOR   := X.NOMBRE_PROMOTOR;          
      ---wCODNIVEL_PROMOTOR := X.CODNIVEL_PROMOTOR;
    
      wDR_CODIGO   := X.AGENTE_PROMOTOR;
      wDR_NOMBRE   := X.NOMBRE_PROMOTOR;
      wDR_CODNIVEL := X.CODNIVEL_PROMOTOR;
      wDR_NIVEL    := X.NIVEL_PROMOTOR;
    
    ELSIF X.CODNIVEL_PROMOTOR = 2 THEN
    
      wAGENTE_PROMOTOR   := X.AGENTE_PROMOTOR;
      wNOMBRE_PROMOTOR   := X.NOMBRE_PROMOTOR;
      wCODNIVEL_PROMOTOR := X.CODNIVEL_PROMOTOR;
      wNIVEL_PROMOTOR    := X.NIVEL_PROMOTOR;
      wDR_CODIGO         := X.DR_CODIGO;
      wDR_NOMBRE         := X.DR_NOMBRE;
      wDR_CODNIVEL       := X.DR_CODNIVEL;
      wDR_NIVEL          := X.DR_NIVEL;
    
      --- solo si su jefe no es nivel 2
      ---MESSAGE('AGENTE   '||X.Cod_Agente||'      X.CODNIVEL_PROMOTOR   '||X.CODNIVEL_PROMOTOR||'      X.DR_CODNIVEL  '||X.DR_CODNIVEL);
      /*IF X.DR_CODNIVEL IN (1,3,4,5) THEN    
          wDR_CODIGO   := X.DR_CODIGO;       
          wDR_NOMBRE   := X.DR_NOMBRE;        
          wDR_CODNIVEL := X.DR_CODNIVEL;       
          wDR_NIVEL    := X.DR_NIVEL;      
      ELSE 
          wDR_CODIGO   := NULL;
          wDR_NOMBRE   := NULL;
          wDR_CODNIVEL := NULL;
          wDR_NIVEL    := NULL; */
    END IF;
  
    IF CTIPOREP = 1 THEN
    
      cCadena := '<tr>' || OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Cod_Agente,
                                                         '9999999999990'),
                                                 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Nombre_Agente, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.CodNivel, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.NIVEL_AGENTE, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Est_Agente, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Tipo_Agente, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.CodTipo, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.CanalComisVenta, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(wAGENTE_PROMOTOR, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(wNOMBRE_PROMOTOR, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(wCODNIVEL_PROMOTOR, 'C') ||
                --OC_ARCHIVO.CAMPO_HTML(wNIVEL_AGENTE_JEFE,'C') ||                     
                 OC_ARCHIVO.CAMPO_HTML(wDR_CODIGO, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(wDR_NOMBRE, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(wDR_CODNIVEL, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(wDR_NIVEL, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Tipo_Doc_Identificacion, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Num_Doc_Identificacion, 'C') ||
                --OC_ARCHIVO.CAMPO_HTML(X.Email,'C') ||                                
                --OC_ARCHIVO.CAMPO_HTML(X.Direccion,'C') ||                            
                --OC_ARCHIVO.CAMPO_HTML(X.TelRes,'C') ||                               
                 OC_ARCHIVO.CAMPO_HTML(cTipoCedula, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(cNumCedula, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(dFecVencimiento, 'D') ||
                 OC_ARCHIVO.CAMPO_HTML(cNumPolRc, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(cNomAsegPolRc, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(dFecVencPolRc, 'D') ||
                --OC_ARCHIVO.CAMPO_HTML(cCodFormaPago||'-'||cDescFormaPago,'C') ||     
                --OC_ARCHIVO.CAMPO_HTML(cCodEntidadFinan||'-'||cNombreEntidad,'C') ||  
                --OC_ARCHIVO.CAMPO_HTML(cNumCuentaBancaria,'C') ||                     
                --OC_ARCHIVO.CAMPO_HTML(cNumCuentaClabe,'C') ||                        
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.CodEjecutivo, '9999999990'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.NombreEjecutivo, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Fecha_Alta, 'D') || '</tr>';
    
    ELSIF CTIPOREP = 2 THEN
      --MESSAGE('AAAAAAAA10');
      cCadena := '<tr>' || OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Cod_Agente,
                                                         '9999999999990'),
                                                 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Nombre_Agente, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.CodNivel, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.NIVEL_AGENTE, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Est_Agente, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Tipo_Agente, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.CodTipo, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.CanalComisVenta, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(wAGENTE_PROMOTOR, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(wNOMBRE_PROMOTOR, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(wCODNIVEL_PROMOTOR, 'C') ||
                --OC_ARCHIVO.CAMPO_HTML(wNIVEL_AGENTE_JEFE,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(wDR_CODIGO, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(wDR_NOMBRE, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(wDR_CODNIVEL, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(wDR_NIVEL, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Tipo_Doc_Identificacion, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Num_Doc_Identificacion, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Email, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Direccion, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.TelRes, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(cTipoCedula, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(cNumCedula, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(dFecVencimiento, 'D') ||
                 OC_ARCHIVO.CAMPO_HTML(cNumPolRc, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(cNomAsegPolRc, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(dFecVencPolRc, 'D') ||
                 OC_ARCHIVO.CAMPO_HTML(cCodFormaPago || '-' ||
                                       cDescFormaPago,
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(cCodEntidadFinan || '-' ||
                                       cNombreEntidad,
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(cNumCuentaBancaria, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(cNumCuentaClabe, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.CodEjecutivo, '9999999990'),
                                       'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.NombreEjecutivo, 'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Fecha_Alta, 'D') || '</tr>';
    END IF;
  
    --  MESSAGE('BBBBBBB1111');
    nLinea := nLinea + 1;
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  END LOOP;
  OC_ARCHIVO.Escribir_Linea('</table></div></html>', ccodUSER, 9999);
  OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0);
  INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
    SELECT nIdReporte + 1,
           B.TIPO_REPORTE,
           B.CODUSR,
           SYSDATE,
           'GEN',
           A.DATA,
           B.FILE_NAME
      FROM SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
     WHERE A.CODUSER = B.CODUSR
       AND B.IDEXTRACCION = nIdReporte;
  DELETE SICAS_OC.EXTRACCION_DE_REPORTES WHERE IDEXTRACCION = nIdReporte;
  OC_ARCHIVO.Eliminar_Archivo(cCodUser);

EXCEPTION
  WHEN OTHERS THEN
    OC_ARCHIVO.Eliminar_Archivo(cCodUser);
    RAISE_APPLICATION_ERROR(-20102,
                            'Error en Generación de Listado de Agente ' ||
                            SQLERRM);
  
END;

PROCEDURE LISTAR_AGENTES_SUS(cNomArchivo VARCHAR2, CTIPOREP NUMBER, dfecdesde date, dfechasta date, cformato varchar2, nidreporte number) IS

cLimitador VARCHAR2(1) := '|';
nLinea NUMBER;
cCadena VARCHAR2(4000);
cCodUser VARCHAR2(30);
nDummy NUMBER;
cCopy BOOLEAN;
cEmail CORREOS_ELECTRONICOS_PNJ.Email%TYPE;
cNomAgente VARCHAR2(1000);
cTipo_Doc_Identificacion agentes.Tipo_Doc_Identificacion%type;
cNum_Doc_Identificacion agentes.Num_Doc_Identificacion%type;
BEGIN
  SELECT CODUSR
    INTO cCodUser
    FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte;

  nLinea  := 1;
  cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"' ||
             chr(10) || ' xmlns:x="urn:schemas-microsoft-com:office:excel"' ||
             chr(10) || ' xmlns="http://www.w3.org/TR/REC-html40">' ||
             chr(10) || ' <style id="libro">' || chr(10) || '   <!--table' ||
             chr(10) || '       {mso-displayed-decimal-separator:"\.";' ||
             chr(10) || '        mso-displayed-thousand-separator:"\,";}' ||
             chr(10) || '        .texto' || chr(10) ||
             '          {mso-number-format:"\@";}' || chr(10) ||
             '        .numero' || chr(10) ||
             '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}' ||
             chr(10) || '        .fecha' || chr(10) ||
             '          {mso-number-format:"dd\\-mmm\\-yyyy";}' || chr(10) ||
             '    -->' || chr(10) || ' </style><div id="libro">' || chr(10);
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

  nLinea  := nLinea + 1;
  cCadena := '<table border = 0><tr><th>' || oc_empresas.NOMBRE_COMPANIA(1) ||
             '</th></tr>';
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

  nLinea  := nLinea + 1;
  cCadena := '<tr><th>LISTADO DE AGENTES A SUSPENDER' || '</th></tr>';
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

  nLinea  := nLinea + 1;
  cCadena := '<tr><th>CEDULA Y/O POLIZA RC VENCEN DEL  ' ||
             TO_CHAR(TRUNC(dFecDesde), 'DD/MM/YYYY') || ' AL ' ||
             TO_CHAR(TRUNC(dFecHasta), 'DD/MM/YYYY') || '</th></tr>';
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

  nLinea  := nLinea + 1;
  cCadena := '<tr><th>  </th></tr></table>';
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

  nLinea  := nLinea + 1;
  cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Agente</font></th>' ||
             '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Agente</font></th>' ||
             '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo de Agente</font></th>' ||
             '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nivel</font></th>' ||
             '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Cédula</font></th>' ||
             '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Cédula</font></th>' ||
             '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Vencimiento Cédula</font></th>' ||
             '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Póliza RC</font></th>' ||
             '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Aseguradora Póliza RC</font></th>' ||
             '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Vencimiento Póliza RC</font></th>' ||
             '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Email</font></th>';
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

  FOR X IN (SELECT A.*,
                   (SELECT AC.tipocedula
                      FROM AGENTES_CEDULA_AUTORIZADA ac
                     WHERE A.CodCia = AC.CodCia
                       AND A.CodEmpresa = AC.CodEmpresa
                       AND A.Cod_Agente = AC.Cod_Agente
                       AND ROWNUM = 1) tipocedula,
                   (SELECT AC.fecvencimiento
                      FROM AGENTES_CEDULA_AUTORIZADA ac
                     WHERE A.CodCia = AC.CodCia
                       AND A.CodEmpresa = AC.CodEmpresa
                       AND A.Cod_Agente = AC.Cod_Agente
                       AND ROWNUM = 1) fecvencimiento,
                   (SELECT AC.fecvencpolrc
                      FROM AGENTES_CEDULA_AUTORIZADA ac
                     WHERE A.CodCia = AC.CodCia
                       AND A.CodEmpresa = AC.CodEmpresa
                       AND A.Cod_Agente = AC.Cod_Agente
                       AND ROWNUM = 1) fecvencpolrc,
                   (SELECT AC.numcedula
                      FROM AGENTES_CEDULA_AUTORIZADA ac
                     WHERE A.CodCia = AC.CodCia
                       AND A.CodEmpresa = AC.CodEmpresa
                       AND A.Cod_Agente = AC.Cod_Agente
                       AND ROWNUM = 1) numcedula,
                   (SELECT AC.numpolrc
                      FROM AGENTES_CEDULA_AUTORIZADA ac
                     WHERE A.CodCia = AC.CodCia
                       AND A.CodEmpresa = AC.CodEmpresa
                       AND A.Cod_Agente = AC.Cod_Agente
                       AND ROWNUM = 1) numpolrc,
                   (SELECT AC.nomasegpolrc
                      FROM AGENTES_CEDULA_AUTORIZADA ac
                     WHERE A.CodCia = AC.CodCia
                       AND A.CodEmpresa = AC.CodEmpresa
                       AND A.Cod_Agente = AC.Cod_Agente
                       AND ROWNUM = 1) nomasegpolrc
              FROM TMP_AGENTES_SUSP T, AGENTES A
             WHERE T.CODUSR = CCODUSER
               AND T.COD_AGENTE = A.COD_AGENTE) LOOP
    BEGIN
      SELECT OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(Tipo_Doc_Identificacion,
                                                         Num_Doc_Identificacion) Email,
             Tipo_Doc_Identificacion,Num_Doc_Identificacion                                                         
        INTO cEmail, cTipo_Doc_Identificacion,cNum_Doc_Identificacion
        FROM AGENTES
       WHERE CodCia = X.CodCia
         AND CodEmpresa = X.CodEmpresa
         AND Cod_Agente = X.Cod_Agente;
    EXCEPTION
      WHEN OTHERS THEN
        cEmail := NULL;
    END;
    SELECT TRIM(Nombre) || ' ' || TRIM(Apellido_Paterno) || ' ' ||
           TRIM(Apellido_Materno) || ' ' ||
           DECODE(ApeCasada, NULL, ' ', ' de ' || ApeCasada)
      INTO CNOMAGENTE
      FROM PERSONA_NATURAL_JURIDICA
     WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
       AND Num_Doc_Identificacion = cNum_Doc_Identificacion ;
  
    cCadena := '<tr>' ||
               OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Cod_Agente, '999990'), 'C') ||
               OC_ARCHIVO.CAMPO_HTML(cNomAgente, 'C') ||
               OC_ARCHIVO.CAMPO_HTML(X.CodTipo, 'C') ||
               OC_ARCHIVO.CAMPO_HTML(X.CodNivel, 'C') ||
               OC_ARCHIVO.CAMPO_HTML(X.TipoCedula, 'C') ||
               OC_ARCHIVO.CAMPO_HTML(X.NumCedula, 'C') ||
               OC_ARCHIVO.CAMPO_HTML(X.FecVencimiento, 'D') ||
               OC_ARCHIVO.CAMPO_HTML(X.NumPolRC, 'C') ||
               OC_ARCHIVO.CAMPO_HTML(X.NomAsegPolRC, 'C') ||
               OC_ARCHIVO.CAMPO_HTML(X.FecVencPolRc, 'D') ||
               OC_ARCHIVO.CAMPO_HTML(cEmail, 'C') || '</tr>';
    nLinea  := nLinea + 1;
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  END LOOP;
  OC_ARCHIVO.Escribir_Linea('</table></div></html>', ccodUSER, 9999);
  OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0);
  INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
    SELECT nIdReporte + 1,
           B.TIPO_REPORTE,
           B.CODUSR,
           SYSDATE,
           'GEN',
           A.DATA,
           B.FILE_NAME
      FROM SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
     WHERE A.CODUSER = B.CODUSR
       AND B.IDEXTRACCION = nIdReporte;
  DELETE SICAS_OC.EXTRACCION_DE_REPORTES WHERE IDEXTRACCION = nIdReporte;
  OC_ARCHIVO.Eliminar_Archivo(cCodUser);
/*EXCEPTION
  WHEN OTHERS THEN
    OC_ARCHIVO.Eliminar_Archivo(cCodUser);
    RAISE_APPLICATION_ERROR(-20105,
                            'Error en Generación de Listado de Agentes a Suspender ' ||
                            SQLERRM);*/
  
END;

PROCEDURE REPORTE_ERRORES_EMISION(cNomArchivo VARCHAR2, cformato varchar2, nidreporte number, CTIPOPROCESO VARCHAR2) IS

cLimitador VARCHAR2(1) := '|';
nLinea NUMBER;
cCadena VARCHAR2(4000);
cCodUser VARCHAR2(30);
nDummy NUMBER;
cCopy BOOLEAN;

CURSOR EMI_Q IS
  SELECT LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(P.REGDATOSPROC, 6, ',')) TipoDocIdentif,
         LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(P.REGDATOSPROC, 7, ',')) NumDocIdentif,
         LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(P.REGDATOSPROC, 8, ',')) Nombres,
         LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(P.REGDATOSPROC, 9, ',')) Apellido_Paterno,
         LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(P.REGDATOSPROC, 10, ',')) Apellido_Materno,
         LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(P.REGDATOSPROC, 12, ',')) FechaNacimiento,
         L.TxtError,
         P.NumPolUnico,
         P.NumDetUnico,
         P.IdTipoSeg,
         P.PlanCob
    FROM PROCESOS_MASIVOS P, PROCESOS_MASIVOS_LOG L
   WHERE L.IdProcMasivo = P.IdProcMasivo
     AND P.TipoProceso = CTipoProceso
     AND P.StsRegProceso IN ('ERROR', 'ERRASE', 'ERREMI')
     AND P.CodUsuario    = CCODUSER;
     /*and p.IdProcMasivo in (select max(pp.IdProcMasivo) from PROCESOS_MASIVOS pp where pp.codusuario=ccoduser and pp.tipoproceso = ctipoproceso)*/ 
     
BEGIN
  SELECT CODUSR
    INTO cCodUser
    FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte;

  nLinea  := 1;
  cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"' ||
             chr(10) || ' xmlns:x="urn:schemas-microsoft-com:office:excel"' ||
             chr(10) || ' xmlns="http://www.w3.org/TR/REC-html40">' ||
             chr(10) || ' <style id="libro">' || chr(10) || '   <!--table' ||
             chr(10) || '       {mso-displayed-decimal-separator:"\.";' ||
             chr(10) || '        mso-displayed-thousand-separator:"\,";}' ||
             chr(10) || '        .texto' || chr(10) ||
             '          {mso-number-format:"\@";}' || chr(10) ||
             '        .numero' || chr(10) ||
             '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}' ||
             chr(10) || '        .fecha' || chr(10) ||
             '          {mso-number-format:"dd\\-mmm\\-yyyy";}' || chr(10) ||
             '    -->' || chr(10) || ' </style><div id="libro">' || chr(10);
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

  nLinea  := nLinea + 1;
  cCadena := '<table border = 0><tr><th>THONA SEGUROS, S.A. de C.V.</th></tr>';
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

  nLinea  := nLinea + 1;
  cCadena := '<tr><th>REPORTE DEL PROCESO MASIVO ' || CTipoProceso ||
             '</th></tr>';
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

  nLinea  := nLinea + 1;
  cCadena := '<tr><th>  </th></tr></table>';
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

  nLinea  := nLinea + 1;
  cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Póliza Unico</font></th>' ||
             '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Detalle/Sub-Grupo</font></th>' ||
             '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Producto</font></th>' ||
             '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Plan de Coberturas</font></th>' ||
             '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Doc. Identificación</font></th>' ||
             '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Doc. Identificación</font></th>' ||
             '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombres</font></th>' ||
             '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Apellido Paterno</font></th>' ||
             '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Apellido Materno</font></th>' ||
             '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de Nacimiento</font></th>' ||
             '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Log de Error</font></th>';
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

  FOR X IN EMI_Q LOOP
    cCadena := '<tr>' || OC_ARCHIVO.CAMPO_HTML(X.NumPolUnico, 'C') ||
               OC_ARCHIVO.CAMPO_HTML(X.NumDetUnico, 'C') ||
               OC_ARCHIVO.CAMPO_HTML(X.IdTipoSeg, 'C') ||
               OC_ARCHIVO.CAMPO_HTML(X.PlanCob, 'C') ||
               OC_ARCHIVO.CAMPO_HTML(X.TipoDocIdentif, 'C') ||
               OC_ARCHIVO.CAMPO_HTML(X.NumDocIdentif, 'C') ||
               OC_ARCHIVO.CAMPO_HTML(X.Nombres, 'C') ||
               OC_ARCHIVO.CAMPO_HTML(X.Apellido_Paterno, 'C') ||
               OC_ARCHIVO.CAMPO_HTML(X.Apellido_Materno, 'D') ||
               OC_ARCHIVO.CAMPO_HTML(X.FechaNacimiento, 'D') ||
               OC_ARCHIVO.CAMPO_HTML(X.TxtError, 'C') || '</tr>';
    nLinea  := nLinea + 1;
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  END LOOP;
  OC_ARCHIVO.Escribir_Linea('</table></div></html>', ccodUSER, 9999);
  OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0);
  INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
    SELECT nIdReporte + 1,
           B.TIPO_REPORTE,
           B.CODUSR,
           SYSDATE,
           'GEN',
           A.DATA,
           B.FILE_NAME
      FROM SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
     WHERE A.CODUSER = B.CODUSR
       AND B.IDEXTRACCION = nIdReporte;
    commit;
  DELETE SICAS_OC.EXTRACCION_DE_REPORTES WHERE IDEXTRACCION = nIdReporte;
  OC_ARCHIVO.Eliminar_Archivo(cCodUser);

EXCEPTION
  WHEN OTHERS THEN
    OC_ARCHIVO.Eliminar_Archivo(cCodUser);
    RAISE_APPLICATION_ERROR(-20102,
                            'Error en Generación de Registros de Emisidn en Procesos Masivos con Error: ' ||
                            SQLERRM);
  
END;

PROCEDURE GENERAR_EMITIDOS(cNomArchivo VARCHAR2, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                           cCodMoneda VARCHAR2, cCodAgente VARCHAR2, dFecDesde DATE,
                           dFecHasta DATE, cformato varchar2, nidreporte number) IS                         
                           
cLimitador      VARCHAR2(1) :='|';
nLinea          NUMBER;
cCadena         VARCHAR2(4000);
cCodUser        VARCHAR2(30);
nDummy          NUMBER;
cCopy           BOOLEAN;
cDescFormaPago  VARCHAR2(100);
dFecFin         DATE;
cTipoVigencia   VARCHAR2(20);
nIdFactura      FACTURAS.IdFactura%TYPE;
nIdPoliza       POLIZAS.IdPoliza%TYPE;
nPrimaNeta      DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nReducPrima     DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nRecargos       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nDerechos       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nImpuesto       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nPrimaTotal     DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nComisionesPEF  DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nHonorariosPEF  DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nUdisPEF        DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nComisionesPEM  DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nHonorariosPEM  DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nUdisPEM        DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nTotComisDist   DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nDifComis       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
cCodPlanPagos   PLAN_DE_PAGOS.CodPlanPago%TYPE;
cCodGenerador   AGENTE_POLIZA.Cod_Agente%TYPE;
nTasaIVA        CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
cDescEstado     PROVINCIA.DescEstado%TYPE;
nFrecPagos      PLAN_DE_PAGOS.FrecPagos%TYPE;
nCodTipo        AGENTES.CODTIPO%TYPE;
cNumComprob     COMPROBANTES_CONTABLES.NumComprob%TYPE;
cTipoEndoso     ENDOSOS.TipoEndoso%TYPE;
dFecFinVig      ENDOSOS.FecFinVig%TYPE;
nIdNcr          NOTAS_DE_CREDITO.IdNcr%TYPE;

nCodAg                 COMISIONES.Cod_Agente%TYPE;
nCodNivelAg            AGENTES.CodNivel%TYPE;
nPorcComisAg	         AGENTES_DISTRIBUCION_POLIZA.Porc_Com_Proporcional%TYPE;
nMontoComisAg          COMISIONES.Comision_Moneda%TYPE;
cEstatusComisAg        COMISIONES.Estado%TYPE;

nCodRg                 COMISIONES.Cod_Agente%TYPE;
nCodNivelRg            AGENTES.CodNivel%TYPE;
nPorcComisRg	         AGENTES_DISTRIBUCION_POLIZA.Porc_Com_Proporcional%TYPE;
nMontoComisRg          COMISIONES.Comision_Moneda%TYPE;
cEstatusComisRg        COMISIONES.Estado%TYPE;

nCodPrm                COMISIONES.Cod_Agente%TYPE;
nCodNivelPrm           AGENTES.CodNivel%TYPE;                     
nPorcComisPrm	         AGENTES_DISTRIBUCION_POLIZA.Porc_Com_Proporcional%TYPE;
nMontoComisPrm         COMISIONES.Comision_Moneda%TYPE;
cEstatusComisPrm       COMISIONES.Estado%TYPE;

nCodHn                 COMISIONES.Cod_Agente%TYPE;
nCodNivelHn            AGENTES.CodNivel%TYPE;
nPorcComisHn	         AGENTES_DISTRIBUCION_POLIZA.Porc_Com_Proporcional%TYPE;
nMontoComisHn          COMISIONES.Comision_Moneda%TYPE;                               
cEstatusComisHn        COMISIONES.Estado%TYPE; 
                                       
nCodUd                 COMISIONES.Cod_Agente%TYPE;
nCodNivelUd            AGENTES.CodNivel%TYPE;
nPorcComisUd	         AGENTES_DISTRIBUCION_POLIZA.Porc_Com_Proporcional%TYPE;
nMontoComisUd          COMISIONES.Comision_Moneda%TYPE;                              
cEstatusComisUd        COMISIONES.Estado%TYPE;
nCantReg_Q		  NUMBER;



CURSOR EMI_Q IS 
   SELECT P.IdPoliza, P.NumPolUnico, P.NumPolRef, DP.CodFilial, OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||
          OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
          F.IdEndoso, F.IdFactura, T.FechaTransaccion, F.FecVenc, F.Cod_Moneda,
          DP.IdTipoSeg, DP.PlanCob, PC.CodTipoPlan,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
          P.CodCliente, P.FecIniVig, P.FecFinVig, P.NumRenov, P.CodCia, F.MtoComisi_Moneda,
          F.NumCuota, P.CodEmpresa, T.IdTransaccion, F.FolioFactElec
     FROM FACTURAS F, TRANSACCION T, POLIZAS P, DETALLE_POLIZA DP, PLAN_COBERTURAS PC
    WHERE PC.PlanCob                 = DP.PlanCob
      AND PC.IdTipoSeg               = DP.IdTipoSeg
      AND PC.CodEmpresa              = DP.CodEmpresa
      AND PC.CodCia                  = DP.CodCia
      AND DP.CodCia                  = F.CodCia
      AND DP.IDetPol                 = F.IDetPol
      AND DP.IdPoliza                = F.IdPoliza
      AND ((DP.IdTipoSeg             = cIdTipoSeg AND cIdTipoSeg != '%')
       OR  (DP.IdTipoSeg          LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
      AND ((DP.PlanCob               = cPlanCob AND cPlanCob != '%')
       OR  (DP.PlanCob            LIKE cPlanCob AND cPlanCob = '%'))
      AND ((F.Cod_Moneda             = cCodMoneda AND cCodMoneda != '%')
       OR  (F.Cod_Moneda          LIKE cCodMoneda AND cCodMoneda = '%'))
      AND ((F.CodGenerador           = cCodAgente AND cCodAgente != '%')
       OR  (F.CodGenerador        LIKE cCodAgente AND cCodAgente = '%'))
      AND P.CodCia                   = F.CodCia
      AND P.IdPoliza                 = F.IdPoliza
      AND F.IndContabilizada         = 'S'
      AND TRUNC(T.FechaTransaccion) >= dFecDesde
      AND TRUNC(T.FechaTransaccion) <= dFecHasta
      AND T.IdProceso               IN (7, 8, 14,18) -- Emisión, Endosos, Contabilizacion y Rehabilitaciones
      AND ((T.IdTransaccion          = F.IdTransaccion AND F.IdTransacContab IS NULL)
       OR  T.IdTransaccion           = F.IdTransacContab)
    ORDER BY F.IdFactura;

CURSOR DET_Q IS
   SELECT D.CodCpto, D.Monto_Det_Moneda, D.IndCptoPrima, C.IndCptoServicio
     FROM DETALLE_FACTURAS D, FACTURAS F, CATALOGO_DE_CONCEPTOS C
    WHERE C.CodConcepto = D.CodCpto
      AND C.CodCia      = F.CodCia
      AND D.IdFactura   = F.IdFactura
      AND F.IdFactura   = nIdFactura;

CURSOR DET_ConC (P_IdPoliza Number, p_idFactura Number ) IS
   SELECT DCO.CodConcepto, DCO.Monto_Mon_Extranjera, AGE.CodTipo, AGE.CodNivel, COM.Cod_Agente
     FROM COMISIONES COM, DETALLE_COMISION DCO, AGENTES AGE
    WHERE DCO.CodConcepto IN ('HONORA','COMISI','COMIPF','COMIPM','UDI')
      AND COM.CodCia     = DCO.CodCia 
      AND COM.IdComision = DCO.IdComision
      AND AGE.COD_AGENTE = COM.COD_AGENTE
      AND COM.idpoliza   = P_IdPoliza
      AND COM.IdFactura  = p_idFactura;   

CURSOR NC_Q IS
   SELECT P.IdPoliza, P.NumPolUnico, P.NumPolRef, DP.CodFilial, OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||
          OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
          N.IdEndoso, N.IdNcr, T.FechaTransaccion, N.FecDevol, N.CodMoneda,
          DP.IdTipoSeg, DP.PlanCob, PC.CodTipoPlan, DP.CodPlanPago,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
          P.CodCliente, P.FecIniVig, P.FecFinVig, P.NumRenov, P.CodCia, N.MtoComisi_Moneda*-1 MtoComisi_Moneda,
          1 NumCuota, P.CodEmpresa, N.FecDevol FecAnul, T.IdTransaccion, N.StsNcr,
          N.IdTransaccion IdTransacEmi, N.IdTransaccionAnu, N.FolioFactElec
     FROM NOTAS_DE_CREDITO N, TRANSACCION T, POLIZAS P, DETALLE_POLIZA DP, PLAN_COBERTURAS PC
    WHERE PC.PlanCob                 = DP.PlanCob
      AND PC.IdTipoSeg               = DP.IdTipoSeg
      AND PC.CodEmpresa              = DP.CodEmpresa
      AND PC.CodCia                  = DP.CodCia
      AND DP.CodCia                  = N.CodCia
      AND DP.IDetPol                 = N.IDetPol
      AND DP.IdPoliza                = N.IdPoliza
      AND ((DP.IdTipoSeg             = cIdTipoSeg AND cIdTipoSeg != '%')
       OR  (DP.IdTipoSeg          LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
      AND ((DP.PlanCob               = cPlanCob AND cPlanCob != '%')
       OR  (DP.PlanCob            LIKE cPlanCob AND cPlanCob = '%'))
      AND ((N.CodMoneda              = cCodMoneda AND cCodMoneda != '%')
       OR  (N.CodMoneda           LIKE cCodMoneda AND cCodMoneda = '%'))
      AND ((N.Cod_Agente             = cCodAgente AND cCodAgente != '%')
       OR  (N.Cod_Agente          LIKE cCodAgente AND cCodAgente = '%'))
      AND P.CodCia                   = N.CodCia
      AND P.IdPoliza                 = N.IdPoliza
      AND T.IdTransaccion            = N.IdTransaccionAnu
      AND T.IdProceso               IN (2, 8)   -- Anulaciones y Endoso
      AND TRUNC(T.FechaTransaccion) >= dFecDesde
      AND TRUNC(T.FechaTransaccion) <= dFecHasta
    ORDER BY N.IdNcr;
CURSOR DET_NC_Q IS
   SELECT D.CodCpto, D.Monto_Det_Moneda, D.IndCptoPrima, C.IndCptoServicio
     FROM DETALLE_NOTAS_DE_CREDITO D, NOTAS_DE_CREDITO N, CATALOGO_DE_CONCEPTOS C
    WHERE C.CodConcepto = D.CodCpto
      AND C.CodCia      = N.CodCia
      AND D.IdNcr       = N.IdNcr
      AND N.IdNcr       = nIdNcr;

CURSOR DET_ConC_NCR (nIdPoliza NUMBER, nIdNcr NUMBER) IS
   SELECT DCO.CodConcepto, DCO.Monto_Mon_Extranjera*-1 Monto_Mon_Extranjera,
          AGE.CodTipo, AGE.CodNivel, COM.Cod_Agente
     FROM COMISIONES COM, DETALLE_COMISION DCO, AGENTES AGE
    WHERE DCO.CodConcepto IN ('HONORA','COMISI','COMIPF','COMIPM','UDI')
      AND COM.CodCia     = DCO.CodCia 
      AND COM.IdComision = DCO.IdComision
      AND AGE.Cod_Agente = COM.Cod_Agente
      AND COM.IdPoliza   = nIdPoliza
      AND COM.IdNcr      = nIdNcr;


CURSOR DET_Comision_Q IS --(nIdPoliza NUMBER, nIdFactura Number ) IS
  	SELECT CodNivel               Tipo
          ,Porc_Com_Proporcional  Comision          
          ,C.Comision_Moneda      Monto 
          ,C.Estado               Estatus_Com
          ,C.Cod_Agente	    
          ,Porc_Com_Distribuida   Comision_Distr
	   FROM COMISIONES              C
	        ,AGENTES_DISTRIBUCION_POLIZA ADP       
	  WHERE C.IDPOLIZA     = ADP.IDPOLIZA
	    AND C.COD_AGENTE   = ADP.COD_AGENTE_DISTR
	    AND ADP.IDPOLIZA   = nIdPoliza 
	    AND C.IdFactura    = nIdFactura;  	    
  
CURSOR DET_Comision_NTC IS --(nIdPoliza NUMBER) IS
 SELECT   CodNivel                Tipo
          ,Porc_Com_Proporcional  Comision
          ,C.Comision_Moneda      Monto 
          ,C.Estado               Estatus_Com
          ,C.Cod_Agente	     
          ,Porc_Com_Distribuida   Comision_Distr
	   FROM COMISIONES              C
	        ,AGENTES_DISTRIBUCION_POLIZA ADP  
          , NOTAS_DE_CREDITO N
	  WHERE C.IDPOLIZA     = ADP.IDPOLIZA
	    AND C.COD_AGENTE   = ADP.COD_AGENTE_DISTR
      AND C.IdNcr        = N.IdNcr
      AND ADP.IDPOLIZA   =  nIdPoliza ;
      
      
            
BEGIN 
  SELECT CODUSR
    INTO cCodUser
    FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte;

   IF CFormato = 'TEXTO' THEN
      nLinea := 1;
      cCadena     := OC_EMPRESAS.NOMBRE_COMPANIA(1)  || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

      nLinea := nLinea + 1;
      cCadena     := 'REPORTE DE CONCILIACION DE COMISIONES EMITIDAS DEL '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' || TO_CHAR(dFecHasta,'DD/MM/YYYY') || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

      nLinea := nLinea + 1;
      cCadena     := ' ' || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

      nLinea := nLinea + 1;
      cCadena     := 'No. de Póliza'||cLimitador||'Consecutivo'||cLimitador||'No. Referencia'||cLimitador||
                     'Sub-Grupo'||cLimitador||'Contratante'||cLimitador||'No. de Endoso'||cLimitador||
                     'Tipo Seguro'||cLimitador||'No. Recibo'||cLimitador||'Forma de Pago'||cLimitador||                                         
                     'Fecha Movimiento'||cLimitador||'Estado'||cLimitador||'Inicio Vig. Póliza'||cLimitador||'Fin Vig. Póliza'||cLimitador||                     
                     'Prima Neta'||cLimitador||
                     'Agente'||cLimitador||'Tipo Agente'||cLimitador||'%Comision Agente'||cLimitador||'Estatus Agente'||cLimitador||
                     'Promotor'||cLimitador||'Tipo Promotor'||cLimitador||'%Comision Promotor'||cLimitador||'Estatus Promotor'||cLimitador||
                     'Regional'||cLimitador||'Tipo Regional'||cLimitador||'%Comision Regional'||cLimitador||'Estatus Regional'||cLimitador||
                     'Honorarios'||cLimitador||'Tipo Honorario'||cLimitador||'%Comision Honorario'||cLimitador||'Estatus Honorario'||cLimitador||
                     'UDIS'||cLimitador||'Tipo UDIS'||cLimitador||'%Comision UDIS'||cLimitador||'Estatus UDIS'||cLimitador||  
                     'Comision Total'||cLimitador||                                        
                     'Código SubRamo'||cLimitador||'Descripción SubRamo'||cLimitador||'No. Cuota'||cLimitador||
                     'No. Comprobante'||cLimitador||'Folio Fact. Electrónica'||cLimitador||CHR(13); 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   ELSIF CFormato = 'EXCEL' THEN
      nLinea := 1;
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
                       '          {mso-number-format:"dd\\-mmm\\-yyyy";}'||chr(10)||
                       '    -->'||chr(10)||
                       ' </style><div id="libro">'||chr(10);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<table border = 0><tr><th>' || OC_EMPRESAS.NOMBRE_COMPANIA(1) || '</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<tr><th>REPORTE DE CONCILIACION COMISIONES EMITIDAS DEL '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' ||
                      TO_CHAR(dFecHasta,'DD/MM/YYYY') || '</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<tr><th>  </th></tr></table>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Póliza</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Consecutivo</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Referencia</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Sub-Grupo</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Contratante</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Endoso</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Seguro</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Recibo</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Forma de Pago</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Movimiento</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estado</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Inicio Vig. Póliza</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fin Vig. Póliza</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Prima Neta</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Agente</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Agente</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">%Comision Agente</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto Agente</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estatus Agente</font></th>' ||                     
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Promotor</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Promotor</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">%Comision Promotor</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto Promotor</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estatus Promotor</font></th>' ||                     
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Regional</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Regional</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">%Comision Regional</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto Regional</font></th>' ||                     
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estatus Regional</font></th>' ||                     
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Honorario</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Honorario</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">%Comision Honorario</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto Honorario</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estatus Honorario</font></th>' ||                     
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">UDIS</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo UDIS</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">%Comision UDIS</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto UDIS</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estatus UDIS</font></th>' ||                                          
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comisión Total</font></th>'||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Plan Coberturas</font></th>'||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código SubRamo</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descripción SubRamo</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Cuota</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Comprobante</font></th>'||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Folio Fact. Electrónica</font></th>'--</tr>'
                     
                     ;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END IF;
   
   
   FOR X IN EMI_Q LOOP
   	  nIdFactura      := X.IdFactura;
   	  nIdPoliza       := X.IdPoliza;
   	  
   	  cCodGenerador   := OC_AGENTE_POLIZA.AGENTE_PRINCIPAL(X.CodCia, X.IdPoliza);
      cDescFormaPago  := OC_FACTURAS.FRECUENCIA_PAGO(X.CodCia, X.IdFactura);
      dFecFin         := NULL; --OC_FACTURAS.VIGENCIA_FINAL(X.CodCia, X.IdFactura);

      BEGIN
         SELECT OC_PROVINCIA.NOMBRE_PROVINCIA(P.CodPaisRes, P.CodProvRes)
           INTO cDescEstado
           FROM CLIENTES C, PERSONA_NATURAL_JURIDICA P
          WHERE P.Tipo_Doc_Identificacion = C.Tipo_Doc_Identificacion
            AND P.Num_Doc_Identificacion  = C.Num_Doc_Identificacion
            AND C.CodCliente              = X.CodCliente;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cDescEstado := NULL;
      END;
      IF cDescEstado = 'PROVINCIA NO EXISTE' THEN
      	 cDescEstado := NULL;
      END IF;

      IF X.NumRenov = 0 THEN
         cTipoVigencia := '1ER. AÑO';
      ELSE
         cTipoVigencia := 'RENOVACION';
      END IF;

      nPrimaNeta      := 0;
      nReducPrima     := 0;
      nRecargos       := 0;
      nDerechos       := 0;
      nImpuesto       := 0;
      nPrimaTotal     := 0;
      nComisionesPEF  := 0;
      nHonorariosPEF  := 0;
      nUdisPEF        := 0;
      nComisionesPEM  := 0;
      nHonorariosPEM  := 0;
      nUdisPEM        := 0;
      nTotComisDist   := 0;
      
      nCodRg           := 0;
      nCodNivelRg      := 0;
			nPorcComisRg	   := 0;
			nMontoComisRg    := 0;			
			cEstatusComisRg  := '';
			
			nCodPrm          := 0;
			nCodNivelPrm     := 0;
			nPorcComisPrm	   := 0;
			nMontoComisPrm   := 0;			
			cEstatusComisPrm := '';
			
			nCodAg           := 0;
			nCodNivelAg      := 0;
			nPorcComisAg	   := 0;
			nMontoComisAg    := 0;
			cEstatusComisAg  := '';
			
			nCodHn           := 0;
			nCodNivelHn      := 0;
			nPorcComisHn	   := 0;
			nMontoComisHn    := 0;
			cEstatusComisHn  := '';
			
			nCodUd           := 0;
			nCodNivelUd      := 0;
			nPorcComisUd	   := 0;
			nMontoComisUd    := 0;
			cEstatusComisUd  := '';
			

      FOR W IN DET_Q LOOP
         IF W.IndCptoPrima = 'S' OR W.IndCptoServicio = 'S' THEN
            nPrimaNeta  := NVL(nPrimaNeta,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'RECFIN' THEN
            nRecargos   := NVL(nRecargos,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'DEREMI' THEN
            nDerechos   := NVL(nDerechos,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'IVASIN' THEN
            nImpuesto   := NVL(nImpuesto,0) + NVL(W.Monto_Det_Moneda,0);
            nTasaIVA    := OC_CONCEPTOS_PLAN_DE_PAGOS.PORCENTAJE_CONCEPTO(X.CodCia, X.CodEmpresa, cCodPlanPagos, W.CodCpto);
         ELSE
            nImpuesto   := NVL(nImpuesto,0) + NVL(W.Monto_Det_Moneda,0);
         END IF;
         nPrimaTotal  := NVL(nPrimaTotal,0) + NVL(W.Monto_Det_Moneda,0);
      END LOOP;

      FOR C IN DET_ConC (X.IdPoliza,X.IdFactura) LOOP
         IF C.CodTipo = 'AGTEPF' THEN --AGENTE PERSONA FISICA
            IF C.CodConcepto IN ('COMISI','COMIPF') THEN
               nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'HONORA' THEN
               nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF;
         ELSIF C.CodTipo = 'AGTEPM' THEN -- AGENTE PERSONA MORAL
            IF C.CodConcepto IN ('COMISI','COMIPM') THEN
               nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'HONORA' THEN
               nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF;
         ELSIF C.CodTipo = 'HONPF' THEN -- HONORARIOS PERSONA FISICA
            IF C.CodConcepto IN ('COMISI','COMIPF') THEN
               nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'HONORA' THEN
               nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF;
         ELSIF C.CodTipo = 'HONPM' THEN -- HONORARIOS PERSONA MORAL 
            IF C.CodConcepto IN ('COMISI','COMIPF') THEN
               nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'HONORA' THEN
               nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF;
         ELSIF C.CodTipo = 'UDISPF' THEN -- UDIS PERSONA FISICA
            IF C.CodConcepto = 'UDI' THEN
               nUdisPEF        := NVL(nUdisPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF;
         ELSIF C.CodTipo = 'UDISPM' THEN -- UDIS PERSONA MORAL 
            IF C.CodConcepto = 'UDI' THEN
               nUdisPEM        := NVL(nUdisPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF;
         END IF;
         nTotComisDist   := NVL(nTotComisDist,0) + NVL(C.Monto_Mon_Extranjera,0);
      END LOOP;

      nDifComis := NVL(X.MtoComisi_Moneda,0) - NVL(nTotComisDist,0);

      SELECT NVL(MIN(NumComprob),'0')
        INTO cNumComprob
        FROM COMPROBANTES_CONTABLES
       WHERE NumTransaccion = X.IdTransaccion;
		  
		  SELECT COUNT(*)
		    INTO nCantReg_Q
	      FROM COMISIONES              C
	          ,AGENTES_DISTRIBUCION_POLIZA ADP       
	     WHERE C.IDPOLIZA     = ADP.IDPOLIZA
	       AND C.COD_AGENTE   = ADP.COD_AGENTE_DISTR
	       AND ADP.IDPOLIZA   = X.IdPoliza 
	       AND C.IdFactura    = X.IdFactura; 
	    
	    IF nCantReg_Q > 0 THEN	    
						-- Detalle de las Comisiones %,Montos
				    FOR DC IN DET_Comision_Q LOOP --(X.IdPoliza,X.IdFactura) LOOP
				    	-- ('Entro  DET_Comision_Q');
			          IF DC.Tipo = 1 THEN 
			         	 nCodRg          := dc.Cod_Agente;          
			         	 nCodNivelRg     := DC.Tipo;
			           --nPorcComisRg	   := DC.Comision;
			           nPorcComisRg	   := DC.Comision_Distr;
			         	 nMontoComisRg   := DC.Monto;
			         	 cEstatusComisRg := DC.Estatus_com;
			         ELSIF DC.Tipo = 2 THEN
			           nCodPrm         := dc.Cod_Agente;          
			         	 nCodNivelPrm    := DC.Tipo;
			           --nPorcComisPrm	 := DC.Comision;
			           nPorcComisPrm	 := DC.Comision_Distr;
			         	 nMontoComisPrm  := DC.Monto;
			         	 cEstatusComisPrm:= DC.Estatus_com;
			         ELSIF DC.Tipo = 3 THEN
			         	 nCodAg          := dc.Cod_Agente;  
			           nCodNivelAg     := DC.Tipo ;         	 
			         	 --nPorcComisAg	   := DC.Comision;
			         	 nPorcComisAg	   := DC.Comision_Distr;
			         	 nMontoComisAg   := DC.Monto;
			         	 cEstatusComisAg := DC.Estatus_com;
			         ELSIF DC.Tipo = 4 THEN
			         	 nCodHn          := dc.Cod_Agente;  
			         	 nCodNivelHn     := DC.Tipo;
			           --nPorcComisHn	   := DC.Comision;
			           nPorcComisHn	   := DC.Comision_Distr;
			         	 nMontoComisHn   := DC.Monto;
			         	 cEstatusComisHn := DC.Estatus_com;
			         ELSIF DC.Tipo = 5 THEN
			           nCodUd          := dc.Cod_Agente;  
			         	 nCodNivelUd     := DC.Tipo;
			           --nPorcComisUd	   := DC.Comision;
			           nPorcComisUd	   := DC.Comision_Distr;
			         	 nMontoComisUd   := DC.Monto;
			         	 cEstatusComisUd := DC.Estatus_com;
			         END IF;
				    END LOOP;
	    END IF;
	    
      -- rmerida FIN --
      IF CFormato = 'TEXTO' THEN
         cCadena := X.NumPolUnico                                  ||cLimitador||
                    TO_CHAR(X.IdPoliza,'9999999999999')            ||cLimitador||
                    X.NumPolRef                                    ||cLimitador||
                    X.CodFilial                                    ||cLimitador||
                    X.Contratante                                  ||cLimitador||
                    TO_CHAR(X.IdEndoso,'9999999999999')            ||cLimitador||
                    X.IdTipoSeg                                    ||cLimitador||
                    TO_CHAR(X.IdFactura,'9999999999990')           ||cLimitador||
                    cDescFormaPago                                 ||cLimitador||
                    TO_CHAR(X.FechaTransaccion,'DD/MM/YYYY')       ||cLimitador||
                    cDescEstado                                    ||cLimitador||
                    TO_CHAR(X.FecIniVig,'DD/MM/RRRR')              ||cLimitador||
                    TO_CHAR(X.FecFinVig,'DD/MM/RRRR')              ||cLimitador||
                    TO_CHAR(nPrimaNeta,'99999999999990.00')        ||cLimitador||                                        
                    cCodGenerador                      ||cLimitador||
                    --LPAD(cCodGenerador,6,'0')                      ||cLimitador||
                    TO_CHAR(nCodNivelAg,'99999999999990')          ||cLimitador||
                    TO_CHAR(nPorcComisAg,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMontoComisAg,'99999999999990.00')     ||cLimitador||
                    cEstatusComisAg                                ||cLimitador||
                    nCodRg                            ||cLimitador||                    
                    --LPAD(nCodRg,6,'0')                            ||cLimitador||                    
                    TO_CHAR(nCodNivelRg,'99999999999990')          ||cLimitador||
                    TO_CHAR(nPorcComisRg,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMontoComisRg,'99999999999990.00')     ||cLimitador||
                    cEstatusComisRg                                ||cLimitador||
                    nCodPrm                            ||cLimitador||                    
                    --LPAD(nCodPrm,6,'0')                            ||cLimitador||                    
                    TO_CHAR(nCodNivelPrm,'99999999999990')         ||cLimitador||                
                    TO_CHAR(nPorcComisPrm,'99999999999990.00')     ||cLimitador||
                    TO_CHAR(nMontoComisPrm,'99999999999990.00')    ||cLimitador||
                    cEstatusComisPrm                               ||cLimitador||
                    nCodHn                         ||cLimitador||                    
                    --LPAD(nCodHn,6,'0')                            ||cLimitador||                    
                    TO_CHAR(nCodNivelHn,'99999999999990')          ||cLimitador||
                    TO_CHAR(nPorcComisHn,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMontoComisHn,'99999999999990.00')     ||cLimitador||                   
                    cEstatusComisHn                                ||cLimitador||                                        
                    nCodUd                       ||cLimitador||                    
                    --LPAD(nCodUd,6,'0')                            ||cLimitador||                    
                    TO_CHAR(nCodNivelUd,'99999999999990')          ||cLimitador||
                    TO_CHAR(nPorcComisUd,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMontoComisUd,'99999999999990.00')     ||cLimitador||                  
                    cEstatusComisUd                                ||cLimitador||
                    
                    TO_CHAR(X.MtoComisi_Moneda,'99999999999990.00')||cLimitador||
                    
                    X.PlanCob                                      ||cLimitador||
                    X.CodTipoPlan                                  ||cLimitador||
                    X.DescSubRamo                                  ||cLimitador||
                    TO_CHAR(X.NumCuota,'99990')                    ||cLimitador||
                    cNumComprob                                    ||cLimitador||
                    X.FolioFactElec                                ||CHR(13);
      ELSIF CFormato = 'EXCEL' THEN
      	--  cCadena := '<tr>'||OC_ARCHIVO.CAMPO_HTML('DEMO','C')||' </tr>';
      	  
         cCadena := '<tr>' || OC_ARCHIVO.CAMPO_HTML(X.NumPolUnico,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdPoliza,'9999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.NumPolRef,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.CodFilial,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.Contratante,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdEndoso,'9999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.IdTipoSeg,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdFactura,'9999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(cDescFormaPago,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.FechaTransaccion,'D') ||
                    OC_ARCHIVO.CAMPO_HTML(cDescEstado,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.FecIniVig,'D') ||
                    OC_ARCHIVO.CAMPO_HTML(X.FecFinVig,'D') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPrimaNeta,'99999999999990.00'),'N') ||                    
                    OC_ARCHIVO.CAMPO_HTML( cCodGenerador, 'C' ) ||                 
                    --OC_ARCHIVO.CAMPO_HTML(LPAD(cCodGenerador,6,'0'),'C') ||                 
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelAg, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisAg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisAg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisAg, 'C') ||
                    --OC_ARCHIVO.CAMPO_HTML(LPAD(nCodPrm,6,'0'),'C') ||                     
                    OC_ARCHIVO.CAMPO_HTML( nCodPrm, 'C' ) ||                     
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelPrm, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisPrm,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisPrm,'99999999999990.00'),'N') ||                    
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisPrm, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(nCodRg, 'C') ||
                    --OC_ARCHIVO.CAMPO_HTML(LPAD(nCodRg,6,'0'),'C') ||                     
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelRg,  'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisRg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisRg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisRg, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML( nCodHn, 'C' ) ||     
                    --OC_ARCHIVO.CAMPO_HTML(LPAD(nCodHn,6,'0'),'C') ||     
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelHn, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisHn,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisHn,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisHn, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML( nCodUd ,'C') ||      
                    --OC_ARCHIVO.CAMPO_HTML(LPAD(nCodUd,6,'0'),'C') ||      
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelUd,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisUd,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisUd,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisUd, 'C') ||
                    
                    
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MtoComisi_Moneda,'99999999999990.00'),'N') ||
                    
                    
                    
                    OC_ARCHIVO.CAMPO_HTML(X.PlanCob, 'C')||
                    OC_ARCHIVO.CAMPO_HTML(X.CodTipoPlan,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.DescSubRamo,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.NumCuota,'99990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(cNumComprob,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.FolioFactElec,'C') || 
                    
                    
                    
                    '</tr>';
                    /*OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MtoComisi_Moneda,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nComisionesPEF,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nComisionesPEM,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nHonorariosPEF,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nHonorariosPEM,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nUdisPEF,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nUdisPEM,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nDifComis,'99999999999990.00'),'N') ||
                    */
      END IF;
      
      nLinea := nLinea + 1;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END LOOP;
   
   
   
   FOR X IN NC_Q LOOP
   	  nIdNcr          := X.IdNcr;
   	  cCodGenerador   := OC_AGENTE_POLIZA.AGENTE_PRINCIPAL(X.CodCia, X.IdPoliza);
      cDescFormaPago  := 'DIRECTO';
      dFecFin         := NULL; --OC_NOTAS_DE_CREDITO.VIGENCIA_FINAL(X.CodCia, X.IdNcr);

      BEGIN
         SELECT OC_PROVINCIA.NOMBRE_PROVINCIA(P.CodPaisRes, P.CodProvRes)
           INTO cDescEstado
           FROM CLIENTES C, PERSONA_NATURAL_JURIDICA P
          WHERE P.Tipo_Doc_Identificacion = C.Tipo_Doc_Identificacion
            AND P.Num_Doc_Identificacion  = C.Num_Doc_Identificacion
            AND C.CodCliente              = X.CodCliente;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cDescEstado := NULL;
      END;
      IF cDescEstado = 'PROVINCIA NO EXISTE' THEN
      	 cDescEstado := NULL;
      END IF;

      IF X.NumRenov = 0 THEN
         cTipoVigencia := '1ER. AÑO';
      ELSE
         cTipoVigencia := 'RENOVACION';
      END IF;

      nPrimaNeta      := 0;
      nReducPrima     := 0;
      nRecargos       := 0;
      nDerechos       := 0;
      nImpuesto       := 0;
      nPrimaTotal     := 0;
      nComisionesPEF  := 0;
      nHonorariosPEF  := 0;
      nUdisPEF        := 0;
      nComisionesPEM  := 0;
      nHonorariosPEM  := 0;
      nUdisPEM        := 0;
      nTotComisDist   := 0;
      
      nCodRg           := 0;
      nCodNivelRg      := 0;
			nPorcComisRg	   := 0;
			nMontoComisRg    := 0;			
			cEstatusComisRg  := '';
			
			nCodPrm          := 0;
			nCodNivelPrm     := 0;
			nPorcComisPrm	   := 0;
			nMontoComisPrm   := 0;			
			cEstatusComisPrm := '';
			
			nCodAg           := 0;
			nCodNivelAg      := 0;
			nPorcComisAg	   := 0;
			nMontoComisAg    := 0;
			cEstatusComisAg  := '';
			
			nCodHn           := 0;
			nCodNivelHn      := 0;
			nPorcComisHn	   := 0;
			nMontoComisHn    := 0;
			cEstatusComisHn  := '';
			
			nCodUd           := 0;
			nCodNivelUd      := 0;
			nPorcComisUd	   := 0;
			nMontoComisUd    := 0;
			cEstatusComisUd  := '';

			

      FOR W IN DET_NC_Q LOOP
         IF W.IndCptoPrima = 'S' OR W.IndCptoServicio = 'S' THEN
            nPrimaNeta  := NVL(nPrimaNeta,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'RECFIN' THEN
            nRecargos   := NVL(nRecargos,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'DEREMI' THEN
            nDerechos   := NVL(nDerechos,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'IVASIN' THEN
            nImpuesto   := NVL(nImpuesto,0) + NVL(W.Monto_Det_Moneda,0);
            nTasaIVA    := OC_CONCEPTOS_PLAN_DE_PAGOS.PORCENTAJE_CONCEPTO(X.CodCia, X.CodEmpresa, cCodPlanPagos, W.CodCpto);
         ELSE
            nImpuesto   := NVL(nImpuesto,0) + NVL(W.Monto_Det_Moneda,0);
         END IF;
         nPrimaTotal  := NVL(nPrimaTotal,0) + NVL(W.Monto_Det_Moneda,0);
      END LOOP;

      FOR C IN DET_ConC_NCR (X.IdPoliza, X.IdNcr) LOOP
      	 IF C.CODTIPO = 'AGTEPF' THEN --AGENTE PERSONA FISICA
          	IF C.CodConcepto IN ('COMISI','COMIPF') THEN
              nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
      	    ELSIF C.CodConcepto = 'HONORA' THEN
      	 	    nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
              NULL;
            END IF;
         ELSIF C.CODTIPO = 'AGTEPM' THEN -- AGENTE PERSONA MORAL 
          	IF C.CodConcepto IN ('COMISI','COMIPM') THEN
               nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
      	    ELSIF C.CodConcepto = 'HONORA' THEN
      	 	     nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF;
         ELSIF C.CODTIPO = 'HONPF' THEN -- HONORARIOS PERSONA FISICA 
            IF C.CodConcepto IN ('COMISI','COMIPF') THEN
               nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
      	    ELSIF C.CodConcepto = 'HONORA' THEN
      	 	    nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF; 			
         ELSIF C.CODTIPO = 'HONPM' THEN -- HONORARIOS PERSONA MORAL 
            IF C.CodConcepto IN ('COMISI','COMIPM') THEN
               nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
      	    ELSIF C.CodConcepto = 'HONORA' THEN
      	 	     nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF; 	
         ELSIF C.CodTipo = 'UDISPF' THEN -- UDIS PERSONA FISICA
            IF C.CodConcepto = 'UDI' THEN
               nUdisPEF        := NVL(nUdisPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF;
         ELSIF C.CodTipo = 'UDISPM' THEN -- UDIS PERSONA MORAL 
            IF C.CodConcepto = 'UDI' THEN
               nUdisPEM        := NVL(nUdisPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF;
      	 END IF;	
         nTotComisDist   := NVL(nTotComisDist,0) + NVL(C.Monto_Mon_Extranjera,0);
      END LOOP;

      nDifComis := NVL(X.MtoComisi_Moneda,0) - NVL(nTotComisDist,0);

      SELECT NVL(MIN(NumComprob),'0')
        INTO cNumComprob
        FROM COMPROBANTES_CONTABLES
       WHERE NumTransaccion = X.IdTransaccion;
      
      -- Detalle de las Comisiones %,Montos
	    FOR DC IN DET_Comision_NTC LOOP -- (X.IdPoliza) LOOP 
          IF DC.Tipo = 1 THEN 
         	 nCodRg          := dc.Cod_Agente;          
         	 nCodNivelRg     := DC.Tipo;
           --nPorcComisRg	   := DC.Comision;
           nPorcComisRg	   := DC.Comision_Distr;
         	 nMontoComisRg   := DC.Monto;
         	 cEstatusComisRg := DC.Estatus_com;
         ELSIF DC.Tipo = 2 THEN
           nCodPrm         := dc.Cod_Agente;          
         	 nCodNivelPrm    := DC.Tipo;
           --nPorcComisPrm	 := DC.Comision;
           nPorcComisPrm	 := DC.Comision_Distr;
         	 nMontoComisPrm  := DC.Monto;
         	 cEstatusComisPrm:= DC.Estatus_com;
         ELSIF DC.Tipo = 3 THEN
         	 nCodAg          := dc.Cod_Agente;  
           nCodNivelAg     := DC.Tipo ;         	 
         	 --nPorcComisAg	   := DC.Comision;
         	 nPorcComisAg	   := DC.Comision_Distr;
         	 nMontoComisAg   := DC.Monto;
         	 cEstatusComisAg := DC.Estatus_com;
         ELSIF DC.Tipo = 4 THEN
         	 nCodHn          := dc.Cod_Agente;  
         	 nCodNivelHn     := DC.Tipo;
           --nPorcComisHn	   := DC.Comision;
           nPorcComisHn	   := DC.Comision_Distr;
         	 nMontoComisHn   := DC.Monto;
         	 cEstatusComisHn := DC.Estatus_com;
         ELSIF DC.Tipo = 5 THEN
           nCodUd          := dc.Cod_Agente;  
         	 nCodNivelUd     := DC.Tipo;
           --nPorcComisUd	   := DC.Comision;
           nPorcComisUd	   := DC.Comision_Distr;
         	 nMontoComisUd   := DC.Monto;
         	 cEstatusComisUd := DC.Estatus_com;
         END IF;
	    END LOOP;
	    
	     
      IF CFormato = 'TEXTO' THEN
         cCadena :=  X.NumPolUnico                                  ||cLimitador||
                    TO_CHAR(X.IdPoliza,'9999999999999')            ||cLimitador||
                    X.NumPolRef                                    ||cLimitador||
                    X.CodFilial                                    ||cLimitador||
                    X.Contratante                                  ||cLimitador||
                    TO_CHAR(X.IdEndoso,'9999999999999')            ||cLimitador||
                    X.IdTipoSeg                                    ||cLimitador||
                    TO_CHAR(X.IdNCR,'9999999999990')               ||cLimitador||
                    cDescFormaPago                                 ||cLimitador||
                    TO_CHAR(X.FechaTransaccion,'DD/MM/YYYY')       ||cLimitador||
                    cDescEstado                                    ||cLimitador||
                    TO_CHAR(X.FecIniVig,'DD/MM/RRRR')              ||cLimitador||
                    TO_CHAR(X.FecFinVig,'DD/MM/RRRR')              ||cLimitador||
                    TO_CHAR(nPrimaNeta,'99999999999990.00')        ||cLimitador||                                        
                    cCodGenerador                      ||cLimitador||
                    --LPAD(cCodGenerador,6,'0')                      ||cLimitador||
                    TO_CHAR(nCodNivelAg,'99999999999990')          ||cLimitador||
                    TO_CHAR(nPorcComisAg,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMontoComisAg,'99999999999990.00')     ||cLimitador||
                    cEstatusComisAg                                ||cLimitador||
                    TO_CHAR(nCodNivelRg,'99999999999990')          ||cLimitador||
                    TO_CHAR(nPorcComisRg,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMontoComisRg,'99999999999990.00')     ||cLimitador||
                    cEstatusComisRg                                ||cLimitador||
                    TO_CHAR(nCodNivelPrm,'99999999999990')         ||cLimitador||                
                    TO_CHAR(nPorcComisPrm,'99999999999990.00')     ||cLimitador||
                    TO_CHAR(nMontoComisPrm,'99999999999990.00')    ||cLimitador||
                    cEstatusComisPrm                               ||cLimitador||
                    TO_CHAR(nCodNivelHn,'99999999999990')          ||cLimitador||
                    TO_CHAR(nPorcComisHn,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMontoComisHn,'99999999999990.00')     ||cLimitador||                   
                    cEstatusComisHn                                ||cLimitador||                                        
                    TO_CHAR(nCodNivelUd,'99999999999990')          ||cLimitador||
                    TO_CHAR(nPorcComisUd,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMontoComisUd,'99999999999990.00')     ||cLimitador||                  
                    cEstatusComisUd                                ||cLimitador||
                    TO_CHAR(X.MtoComisi_Moneda,'99999999999990.00')||cLimitador||                   
                    X.PlanCob                                      ||cLimitador||
                    X.CodTipoPlan                                  ||cLimitador||
                    X.DescSubRamo                                  ||cLimitador||
                    TO_CHAR(X.NumCuota,'99990')                    ||cLimitador||
                    cNumComprob                                    ||cLimitador||
                    X.FolioFactElec                                ||CHR(13);
                    
                   
      ELSIF CFormato = 'EXCEL' THEN
        -- cCadena := '<tr>'||OC_ARCHIVO.CAMPO_HTML('DEMO','C')||' </tr>';
        
         cCadena := '<tr>' || OC_ARCHIVO.CAMPO_HTML(X.NumPolUnico,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdPoliza,'9999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.NumPolRef,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.CodFilial,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.Contratante,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdEndoso,'9999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.IdTipoSeg,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdNcr,'9999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(cDescFormaPago,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.FechaTransaccion,'D') ||
                    OC_ARCHIVO.CAMPO_HTML(cDescEstado,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.FecIniVig,'D') ||
                    OC_ARCHIVO.CAMPO_HTML(X.FecFinVig,'D') ||                    
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPrimaNeta,'99999999999990.00'),'N') ||  
                    --OC_ARCHIVO.CAMPO_HTML(LPAD(cCodGenerador,6,'0'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(cCodGenerador,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelAg, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisAg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisAg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisAg, 'C') ||
                    --OC_ARCHIVO.CAMPO_HTML(LPAD(nCodPrm,6,'0'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML( nCodPrm, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelPrm, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisPrm,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisPrm,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisPrm, 'C') ||
                    --OC_ARCHIVO.CAMPO_HTML(LPAD(nCodRg,6,'0'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML( nCodRg, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelRg, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisRg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisRg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisRg, 'C') ||
                    --OC_ARCHIVO.CAMPO_HTML(LPAD(nCodHn,6,'0'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML( nCodHn, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelHn, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisHn,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisHn,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisHn, 'C') ||
                    --OC_ARCHIVO.CAMPO_HTML(LPAD(nCodUd,6,'0'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML( nCodUd, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelUd, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisUd,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisUd,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisUd, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MtoComisi_Moneda,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(X.PlanCob, 'C')||
                    OC_ARCHIVO.CAMPO_HTML(X.CodTipoPlan,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.DescSubRamo,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.NumCuota,'99990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(cNumComprob,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.FolioFactElec,'C') ||
                    '</tr>'
                                        
                    ;
                     /*
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MtoComisi_Moneda,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nComisionesPEF,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nComisionesPEM,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nHonorariosPEF,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nHonorariosPEM,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nUdisPEF,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nUdisPEM,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nDifComis,'99999999999990.00'),'N') ||
                    
                    */
                    
      END IF;
      nLinea := nLinea + 1;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END LOOP;
      
   IF CFormato = 'EXCEL' THEN
      OC_ARCHIVO.Escribir_Linea('</table></div></html>', ccodUSER, 9999);
   END IF;
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 

  INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
    SELECT nIdReporte + 1,
           B.TIPO_REPORTE,
           B.CODUSR,
           SYSDATE,
           'GEN',
           A.DATA,
           B.FILE_NAME
      FROM SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
     WHERE A.CODUSER = B.CODUSR
       AND B.IDEXTRACCION = nIdReporte;
  DELETE SICAS_OC.EXTRACCION_DE_REPORTES WHERE IDEXTRACCION = nIdReporte;
  OC_ARCHIVO.Eliminar_Archivo(cCodUser);



EXCEPTION 
   WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      RAISE_APPLICATION_ERROR(-20105,'Error en Generación de Conciliacion de Comisiones Emitidas: '||nIdFactura || ' ' ||SQLERRM); 
END;

PROCEDURE GENERAR_ANULADOS(cNomArchivo VARCHAR2, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                           cCodMoneda VARCHAR2, cCodAgente VARCHAR2, dFecDesde DATE,
                           dFecHasta DATE, cformato varchar2, nidreporte number) IS
cLimitador             VARCHAR2(1) :='|';
nLinea                 NUMBER;
cCadena                VARCHAR2(4000);
cCodUser               VARCHAR2(30);
nDummy                 NUMBER;
cCopy                  BOOLEAN;
cDescFormaPago         VARCHAR2(100);
dFecFin                DATE;
cTipoVigencia          VARCHAR2(20);
nIdFactura             FACTURAS.IdFactura%TYPE;
nPrimaNeta             DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nReducPrima            DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nRecargos              DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nDerechos              DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nImpuesto              DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nPrimaTotal            DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nComisionesPEF         DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nHonorariosPEF         DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nUdisPEF               DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nComisionesPEM         DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nHonorariosPEM         DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nUdisPEM               DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nTotComisDist          DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nDifComis              DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
cCodPlanPagos          PLAN_DE_PAGOS.CodPlanPago%TYPE;
cCodGenerador          AGENTE_POLIZA.Cod_Agente%TYPE;
nTasaIVA               CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
cDescEstado            PROVINCIA.DescEstado%TYPE;
nFrecPagos             PLAN_DE_PAGOS.FrecPagos%TYPE;
nCodTipo               AGENTES.CODTIPO%TYPE;
cNumComprob            COMPROBANTES_CONTABLES.NumComprob%TYPE;
nIdNcr                 NOTAS_DE_CREDITO.IdNcr%TYPE;
cStsNcr                NOTAS_DE_CREDITO.StsNcr%TYPE;
cTipoEndoso            ENDOSOS.TipoEndoso%TYPE;
dFecFinVig             ENDOSOS.FecFinVig%TYPE;
nMonto_Det_Moneda      DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nMonto_Mon_Extranjera  DETALLE_COMISION.Monto_Mon_Extranjera%TYPE;

nCodAg                 COMISIONES.Cod_Agente%TYPE;
nCodNivelAg            AGENTES.CodNivel%TYPE;
nPorcComisAg	         AGENTES_DISTRIBUCION_POLIZA.Porc_Com_Proporcional%TYPE;
nMontoComisAg          COMISIONES.Comision_Moneda%TYPE;
cEstatusComisAg        COMISIONES.Estado%TYPE;

nCodRg                 COMISIONES.Cod_Agente%TYPE;
nCodNivelRg            AGENTES.CodNivel%TYPE;
nPorcComisRg	         AGENTES_DISTRIBUCION_POLIZA.Porc_Com_Proporcional%TYPE;
nMontoComisRg          COMISIONES.Comision_Moneda%TYPE;
cEstatusComisRg        COMISIONES.Estado%TYPE;

nCodPrm                COMISIONES.Cod_Agente%TYPE;
nCodNivelPrm           AGENTES.CodNivel%TYPE;                     
nPorcComisPrm	         AGENTES_DISTRIBUCION_POLIZA.Porc_Com_Proporcional%TYPE;
nMontoComisPrm         COMISIONES.Comision_Moneda%TYPE;
cEstatusComisPrm       COMISIONES.Estado%TYPE;

nCodHn                 COMISIONES.Cod_Agente%TYPE;
nCodNivelHn            AGENTES.CodNivel%TYPE;
nPorcComisHn	         AGENTES_DISTRIBUCION_POLIZA.Porc_Com_Proporcional%TYPE;
nMontoComisHn          COMISIONES.Comision_Moneda%TYPE;                               
cEstatusComisHn        COMISIONES.Estado%TYPE; 
                                       
nCodUd                 COMISIONES.Cod_Agente%TYPE;
nCodNivelUd            AGENTES.CodNivel%TYPE;
nPorcComisUd	         AGENTES_DISTRIBUCION_POLIZA.Porc_Com_Proporcional%TYPE;
nMontoComisUd          COMISIONES.Comision_Moneda%TYPE;                              
cEstatusComisUd        COMISIONES.Estado%TYPE;
nCantReg_Q		         NUMBER;



CURSOR ANU_Q IS
   SELECT P.IdPoliza, P.NumPolUnico, P.NumPolRef, DP.CodFilial, OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||
          OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
          F.IdEndoso, F.IdFactura, T.FechaTransaccion, F.FecVenc, F.Cod_Moneda,
          DP.IdTipoSeg, DP.PlanCob, PC.CodTipoPlan,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
          P.CodCliente, P.FecIniVig, P.FecFinVig, P.NumRenov, P.CodCia, F.MtoComisi_Moneda,
          F.NumCuota, P.CodEmpresa, F.FecAnul, F.MotivAnul, T.IdTransaccion, F.FolioFactElec
     FROM FACTURAS F, TRANSACCION T, POLIZAS P, DETALLE_POLIZA DP, PLAN_COBERTURAS PC
    WHERE PC.PlanCob                 = DP.PlanCob
      AND PC.IdTipoSeg               = DP.IdTipoSeg
      AND PC.CodEmpresa              = DP.CodEmpresa
      AND PC.CodCia                  = DP.CodCia
      AND DP.CodCia                  = F.CodCia
      AND DP.IDetPol                 = F.IDetPol
      AND DP.IdPoliza                = F.IdPoliza
      AND ((DP.IdTipoSeg             = cIdTipoSeg AND cIdTipoSeg != '%')
       OR  (DP.IdTipoSeg          LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
      AND ((DP.PlanCob               = cPlanCob AND cPlanCob != '%')
       OR  (DP.PlanCob            LIKE cPlanCob AND cPlanCob = '%'))
      AND ((F.Cod_Moneda             = cCodMoneda AND cCodMoneda != '%')
       OR  (F.Cod_Moneda          LIKE cCodMoneda AND cCodMoneda = '%'))
      AND ((F.CodGenerador           = cCodAgente AND cCodAgente != '%')
       OR  (F.CodGenerador        LIKE cCodAgente AND cCodAgente = '%'))
      AND P.CodCia                   = F.CodCia
      AND P.IdPoliza                 = F.IdPoliza
      AND T.IdTransaccion            = F.IdTransaccionAnu
      AND F.FecContabilizada        <= dFecHasta
      AND F.IndContabilizada         = 'S'
      AND TRUNC(T.FechaTransaccion) >= dFecDesde
      AND TRUNC(T.FechaTransaccion) <= dFecHasta
      --AND T.IdProceso                = 11 -- Cancelación
      --AND F.FecAnul                 >= dFecDesde
      --AND F.FecAnul                 <= dFecHasta
      AND F.StsFact                  = 'ANU'
    ORDER BY F.IdFactura;
CURSOR DET_Q IS
   SELECT D.CodCpto, D.Monto_Det_Moneda, D.IndCptoPrima, C.IndCptoServicio
     FROM DETALLE_FACTURAS D, FACTURAS F, CATALOGO_DE_CONCEPTOS C
    WHERE C.CodConcepto = D.CodCpto
      AND C.CodCia      = F.CodCia
      AND D.IdFactura   = F.IdFactura
      AND F.IdFactura   = nIdFactura;

CURSOR DET_ConC (P_IdPoliza Number, p_idFactura Number ) IS
   SELECT DCO.CodConcepto, DCO.Monto_Mon_Extranjera, AGE.CodTipo, AGE.CodNivel, COM.Cod_Agente
     FROM COMISIONES COM, DETALLE_COMISION DCO, AGENTES AGE
    WHERE DCO.CodConcepto IN ('HONORA','COMISI','COMIPF','COMIPM','UDI')
      AND COM.CodCia     = DCO.CodCia 
      AND COM.IdComision = DCO.IdComision
      AND AGE.Cod_Agente = COM.Cod_Agente
      AND COM.IdPoliza   = P_IdPoliza
      AND COM.IdFactura  = p_idFactura;    
CURSOR NC_Q IS
   SELECT P.IdPoliza, P.NumPolUnico, P.NumPolRef, DP.CodFilial, OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||
          OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
          N.IdEndoso, N.IdNcr, T.FechaTransaccion, N.FecDevol, N.CodMoneda,
          DP.IdTipoSeg, DP.PlanCob, PC.CodTipoPlan, DP.CodPlanPago,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
          P.CodCliente, P.FecIniVig, P.FecFinVig, P.NumRenov, P.CodCia, N.MtoComisi_Moneda*-1 MtoComisi_Moneda,
          1 NumCuota, P.CodEmpresa, N.FecAnul, N.MotivAnul, T.IdTransaccion, N.StsNcr,
          N.IdTransaccion IdTransacEmi, N.IdTransaccionAnu, N.FolioFactElec
     FROM NOTAS_DE_CREDITO N, TRANSACCION T, POLIZAS P, DETALLE_POLIZA DP, PLAN_COBERTURAS PC
    WHERE PC.PlanCob                 = DP.PlanCob
      AND PC.IdTipoSeg               = DP.IdTipoSeg
      AND PC.CodEmpresa              = DP.CodEmpresa
      AND PC.CodCia                  = DP.CodCia
      AND DP.CodCia                  = N.CodCia
      AND DP.IDetPol                 = N.IDetPol
      AND DP.IdPoliza                = N.IdPoliza
      AND ((DP.IdTipoSeg             = cIdTipoSeg AND cIdTipoSeg != '%')
       OR  (DP.IdTipoSeg          LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
      AND ((DP.PlanCob               = cPlanCob AND cPlanCob != '%')
       OR  (DP.PlanCob            LIKE cPlanCob AND cPlanCob = '%'))
      AND ((N.CodMoneda              = cCodMoneda AND cCodMoneda != '%')
       OR  (N.CodMoneda           LIKE cCodMoneda AND cCodMoneda = '%'))
      AND ((N.Cod_Agente             = cCodAgente AND cCodAgente != '%')
       OR  (N.Cod_Agente          LIKE cCodAgente AND cCodAgente = '%'))
      AND P.CodCia                   = N.CodCia
      AND P.IdPoliza                 = N.IdPoliza
      AND T.IdTransaccion            = N.IdTransaccion 
      AND T.IdProceso               IN (2, 8, 18)   -- Anulaciones y Endoso
      AND TRUNC(T.FechaTransaccion) >= dFecDesde
      AND TRUNC(T.FechaTransaccion) <= dFecHasta
    ORDER BY N.IdNcr;
CURSOR DET_NC_Q IS
   SELECT D.CodCpto, D.Monto_Det_Moneda, D.IndCptoPrima, C.IndCptoServicio
     FROM DETALLE_NOTAS_DE_CREDITO D, NOTAS_DE_CREDITO N, CATALOGO_DE_CONCEPTOS C
    WHERE C.CodConcepto = D.CodCpto
      AND C.CodCia      = N.CodCia
      AND D.IdNcr       = N.IdNcr
      AND N.IdNcr       = nIdNcr;

CURSOR DET_ConC_NCR (nIdPoliza NUMBER, nIdNcr NUMBER) IS
   SELECT DCO.CodConcepto, DCO.Monto_Mon_Extranjera*-1 Monto_Mon_Extranjera,
          AGE.CodTipo, AGE.CodNivel, COM.Cod_Agente
     FROM COMISIONES COM, DETALLE_COMISION DCO, AGENTES AGE
    WHERE DCO.CodConcepto IN ('HONORA','COMISI','COMIPF','COMIPM','UDI')
      AND COM.CodCia     = DCO.CodCia 
      AND COM.IdComision = DCO.IdComision
      AND AGE.Cod_Agente = COM.Cod_Agente
      AND COM.IdPoliza   = nIdPoliza
      AND COM.IdNcr      = nIdNcr;

CURSOR DET_Comision_Q (nIdPoliza NUMBER, nIdFactura Number ) IS
  	SELECT CodNivel   Tipo
          ,Porc_Com_Proporcional  Comision
          ,C.Comision_Moneda      Monto 
          ,C.Estado               Estatus_Com
          ,C.Cod_Agente	          
          ,Porc_Com_Distribuida   Comision_Distr
	   FROM COMISIONES              C
	        ,AGENTES_DISTRIBUCION_POLIZA ADP       
	  WHERE C.IDPOLIZA     = ADP.IDPOLIZA
	    AND C.COD_AGENTE   = ADP.COD_AGENTE_DISTR
	    AND ADP.IDPOLIZA   = nIdPoliza 
	    AND C.IdFactura  = nIdFactura;  	    
  
CURSOR DET_Comision_NTC (nIdPoliza NUMBER) IS
 SELECT   CodNivel   Tipo
          ,Porc_Com_Proporcional  Comision
          ,C.Comision_Moneda      Monto 
          ,C.Estado               Estatus_Com 
          ,C.Cod_Agente	          
          ,Porc_Com_Distribuida   Comision_Distr
	   FROM COMISIONES              C
	        ,AGENTES_DISTRIBUCION_POLIZA ADP  
          , NOTAS_DE_CREDITO N
	  WHERE C.IDPOLIZA     = ADP.IDPOLIZA
	    AND C.COD_AGENTE   = ADP.COD_AGENTE_DISTR
      AND C.IdNcr        = N.IdNcr
      AND ADP.IDPOLIZA   =  nIdPoliza ;
      
            
BEGIN 
  SELECT CODUSR
    INTO cCodUser
    FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte;

   IF CFormato = 'TEXTO' THEN
      nLinea := 1;
      cCadena     := OC_EMPRESAS.NOMBRE_COMPANIA(1) || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

      nLinea := nLinea + 1;
      cCadena     := 'REPORTE DE CONCILIACION DE COMISIONES ANULADAS DEL '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' || TO_CHAR(dFecHasta,'DD/MM/YYYY') || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

      nLinea := nLinea + 1;
      cCadena     := ' ' || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

      nLinea := nLinea + 1;
      cCadena     := 'No. de Póliza'||cLimitador||
                     'Consecutivo'||cLimitador||
                     'No. Referencia'||cLimitador||
                     'Sub-Grupo'||cLimitador||
                     'Contratante'||cLimitador|| 
                     'No. de Endoso'||cLimitador||
                     'Tipo'||cLimitador||
                     'No. Recibo'||cLimitador||
                     'Forma de Pago'||cLimitador|| 
                     'Fecha Emisión/Devol'||cLimitador||
                     'Estado'||cLimitador||
                     'Inicio Vig. Póliza'||cLimitador||
                     'Fin Vig. Póliza'||cLimitador||
                     'Prima Neta'||cLimitador||                                          
                     'Agente'||cLimitador||                     
                     'Tipo Agente'||cLimitador||
                     '%Comision Agente'||cLimitador||
                     'Monto Agente'||cLimitador||
                     'Estatus Agente'||cLimitador||                                          
                     'Promotor'||cLimitador||
                     'Tipo Promotor'||cLimitador||
                     '%Comision Promotor'||cLimitador||
                     'Monto Promotor'||cLimitador||
                     'Estatus Promotor'||cLimitador||                     
                     'Regional'||cLimitador||
                     'Tipo Regional'||cLimitador||
                     '%Comision Regional'||cLimitador||
                     'Monto Regional'||cLimitador||
                     'Estatus Regional'||cLimitador||                     
                     'Honorarios'||cLimitador||
                     'Tipo Honorario'||cLimitador||
                     '%Comision Honorario'||cLimitador||
                     'Monto Honorario'||cLimitador||
                     'Estatus Honorario'||cLimitador||                     
                    -- 'UDIS'||cLimitador||
                     'Tipo UDIS'||cLimitador||
                     '%Comision UDIS'||cLimitador||
                     'Monto UDIS'||cLimitador||
                     'Estatus UDIS'||cLimitador||
                                          
                     'Total Comision'||cLimitador||
                     
                     'Fecha de Anulación'||cLimitador||
                     'Motivo Anulación'||cLimitador||
                     
                     'Plan Coberturas'||cLimitador||
                     'Código SubRamo'||cLimitador||
                     'Descripción SubRamo'||cLimitador||
                     'No. Cuota'||cLimitador||
                     'No. Comprobante'||cLimitador||
                     'Folio Fact. Electrónica'||
                     CHR(13);
                     
                     /*
                     'Comisión Sobre Prima'||cLimitador|| 
                     'Comisión Persona Fisica'||cLimitador||
                     'Comisión Persona Moral'||cLimitador|| 
                     'Honorarios Persona Fisica'||cLimitador||
                     'Honorarios Persona Moral'||cLimitador||
                     'UDIS Persona Fisica'||cLimitador||
                     'UDIS Persona Moral'||cLimitador|| 
                     'Dif. en Comisiones'||cLimitador||  
                     'Tipo Seguro'||cLimitador||
                     'Tipo Vigencia'||cLimitador||
                                        
                     'Tasa IVA'||cLimitador||||'Moneda'||cLimitador||                    
                     'No. Renovacion'||cLimitador||*/
                     
                        
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   ELSIF CFormato = 'EXCEL' THEN
      nLinea := 1;
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
                       '          {mso-number-format:"dd\\-mmm\\-yyyy";}'||chr(10)||
                       '    -->'||chr(10)||
                       ' </style><div id="libro">'||chr(10);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<table border = 0><tr><th>' || OC_EMPRESAS.NOMBRE_COMPANIA(1) || '</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<tr><th>REPORTE DE CONCILIACION DE COMISIONES ANULADAS DEL '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' ||
                      TO_CHAR(dFecHasta,'DD/MM/YYYY') || '</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<tr><th>  </th></tr></table>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Póliza</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Consecutivo</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Referencia</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Sub-Grupo</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Contratante</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Endoso</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Recibo</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Forma de Pago</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Emisión/Devol.</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estado</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Inicio Vig. Póliza</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fin Vig. Póliza</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Prima Neta</font></th>' ||                     
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Agente</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Agente</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">%Comision Agente</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto Agente</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estatus Agente</font></th>' ||                     
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Promotor</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Promotor</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">%Comision Promotor</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto Promotor</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estatus Promotor</font></th>' ||                     
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Regional</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Regional</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">%Comision Regional</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto Regional</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estatus Regional</font></th>' ||                     
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Honorario</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Honorario</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">%Comision Honorario</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto Honorario</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estatus Honorario</font></th>' ||
                     
                     --'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">UDIS.</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo UDIS</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">%Comision UDIS</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto UDIS</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estatus UDIS</font></th>' ||                     
                     
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total Comision</font></th>' ||  
                     
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de Anulación</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Motivo Anulación</font></th>' ||
                     
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Plan Coberturas</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código SubRamo</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descripción SubRamo</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Cuota</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Comprobante</font></th>'||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Folio Fact. Electrónica</font></th>'
                    ;
                     
                     /*'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comisión Sobre Prima</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comisión Persona Fisica</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comisión Persona Moral</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Honorarios Persona Fisica</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Honorarios Persona Moral</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">UDIS Persona Fisica</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">UDIS Persona Moral</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Dif. en Comisiones</font></th>'
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Seguro</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Inicio Vigencia</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fin Vigencia</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Renovacion</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Vigencia</font></th>' ||
                      ||
                     
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tasa IVA</font></th>' ||
                     
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Moneda</font></th>' ||
                     */
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END IF;
   FOR X IN ANU_Q LOOP
   	  nIdFactura      := X.IdFactura;
   	  cCodGenerador   := OC_AGENTE_POLIZA.AGENTE_PRINCIPAL(X.CodCia, X.IdPoliza);
      cDescFormaPago  := OC_FACTURAS.FRECUENCIA_PAGO(X.CodCia, X.IdFactura);
      dFecFin         := NULL; --OC_FACTURAS.VIGENCIA_FINAL(X.CodCia, X.IdFactura);

      BEGIN
         SELECT OC_PROVINCIA.NOMBRE_PROVINCIA(P.CodPaisRes, P.CodProvRes)
           INTO cDescEstado
           FROM CLIENTES C, PERSONA_NATURAL_JURIDICA P
          WHERE P.Tipo_Doc_Identificacion = C.Tipo_Doc_Identificacion
            AND P.Num_Doc_Identificacion  = C.Num_Doc_Identificacion
            AND C.CodCliente              = X.CodCliente;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cDescEstado := NULL;
      END;
      IF cDescEstado = 'PROVINCIA NO EXISTE' THEN
      	 cDescEstado := NULL;
      END IF;

      IF X.NumRenov = 0 THEN
         cTipoVigencia := '1ER. AÑO';
      ELSE
         cTipoVigencia := 'RENOVACION';
      END IF;

      nPrimaNeta      := 0;
      nReducPrima     := 0;
      nRecargos       := 0;
      nDerechos       := 0;
      nImpuesto       := 0;
      nPrimaTotal     := 0;
      nComisionesPEF  := 0;
      nHonorariosPEF  := 0;
      nUdisPEF        := 0;
      nComisionesPEM  := 0;
      nHonorariosPEM  := 0;
      nUdisPEM        := 0;
      nTotComisDist   := 0;
      
      nCodRg           := 0;
      nCodNivelRg      := 0;
			nPorcComisRg	   := 0;
			nMontoComisRg    := 0;			
			cEstatusComisRg  := '';
			
			nCodPrm          := 0;
			nCodNivelPrm     := 0;
			nPorcComisPrm	   := 0;
			nMontoComisPrm   := 0;			
			cEstatusComisPrm := '';
			
			nCodAg           := 0;
			nCodNivelAg      := 0;
			nPorcComisAg	   := 0;
			nMontoComisAg    := 0;
			cEstatusComisAg  := '';
			
			nCodHn           := 0;
			nCodNivelHn      := 0;
			nPorcComisHn	   := 0;
			nMontoComisHn    := 0;
			cEstatusComisHn  := '';
			
			nCodUd           := 0;
			nCodNivelUd      := 0;
			nPorcComisUd	   := 0;
			nMontoComisUd    := 0;
			cEstatusComisUd  := '';
			
			
      FOR W IN DET_Q LOOP
         IF W.IndCptoPrima = 'S' OR W.IndCptoServicio = 'S' THEN
            nPrimaNeta  := NVL(nPrimaNeta,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'RECFIN' THEN
            nRecargos   := NVL(nRecargos,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'DEREMI' THEN
            nDerechos   := NVL(nDerechos,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'IVASIN' THEN
            nImpuesto   := NVL(nImpuesto,0) + NVL(W.Monto_Det_Moneda,0);
            nTasaIVA    := OC_CONCEPTOS_PLAN_DE_PAGOS.PORCENTAJE_CONCEPTO(X.CodCia, X.CodEmpresa, cCodPlanPagos, W.CodCpto);
         ELSE
            nImpuesto   := NVL(nImpuesto,0) + NVL(W.Monto_Det_Moneda,0);
         END IF;
         nPrimaTotal  := NVL(nPrimaTotal,0) + NVL(W.Monto_Det_Moneda,0);
      END LOOP;

      FOR C IN DET_ConC (X.IdPoliza,X.IdFactura) LOOP
         IF C.CODTIPO = 'AGTEPF' THEN --AGENTE PERSONA FISICA
            IF C.CodConcepto IN ('COMISI','COMIPF') THEN
               nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'HONORA' THEN
               nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF;
         ELSIF C.CODTIPO = 'AGTEPM' THEN -- AGENTE PERSONA MORAL 
            IF C.CodConcepto IN ('COMISI','COMIPM') THEN
               nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'HONORA' THEN
               nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF;
         ELSIF C.CODTIPO = 'HONPF' THEN -- HONORARIOS PERSONA FISICA 
            IF C.CodConcepto IN ('COMISI','COMIPF') THEN
               nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'HONORA' THEN
               nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF; 			
         ELSIF C.CODTIPO = 'HONPM' THEN -- HONORARIOS PERSONA MORAL 
            IF C.CodConcepto IN ('COMISI','COMIPM') THEN
               nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
      	    ELSIF C.CodConcepto = 'HONORA' THEN
      	 	     nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF; 	
         ELSIF C.CodTipo = 'UDISPF' THEN -- UDIS PERSONA FISICA
            IF C.CodConcepto = 'UDI' THEN
               nUdisPEF        := NVL(nUdisPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF;
         ELSIF C.CodTipo = 'UDISPM' THEN -- UDIS PERSONA MORAL 
            IF C.CodConcepto = 'UDI' THEN
               nUdisPEM        := NVL(nUdisPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF;
      	 END IF;	
         nTotComisDist   := NVL(nTotComisDist,0) + NVL(C.Monto_Mon_Extranjera,0);
      END LOOP;

      nDifComis := NVL(X.MtoComisi_Moneda,0) - NVL(nTotComisDist,0);

      SELECT NVL(MIN(NumComprob),'0')
        INTO cNumComprob
        FROM COMPROBANTES_CONTABLES
       WHERE NumTransaccion = X.IdTransaccion;


	    -- Detalle de las Comisiones %,Montos
	    FOR DC IN DET_Comision_Q(X.IdPoliza,X.IdFactura) LOOP
         IF DC.Tipo = 1 THEN 
         	 nCodRg          := dc.Cod_Agente;          
         	 nCodNivelRg     := DC.Tipo;
           --nPorcComisRg	   := DC.Comision;
           nPorcComisRg	   := DC.Comision_Distr;
         	 nMontoComisRg   := DC.Monto;
         	 cEstatusComisRg := DC.Estatus_com;
         ELSIF DC.Tipo = 2 THEN
           nCodPrm         := dc.Cod_Agente;          
         	 nCodNivelPrm    := DC.Tipo;
           --nPorcComisPrm	 := DC.Comision;
           nPorcComisPrm	 := DC.Comision_Distr;
         	 nMontoComisPrm  := DC.Monto;
         	 cEstatusComisPrm:= DC.Estatus_com;
         ELSIF DC.Tipo = 3 THEN
         	 nCodAg          := dc.Cod_Agente;  
           nCodNivelAg     := DC.Tipo ;         	 
         	 --nPorcComisAg	   := DC.Comision;
         	 nPorcComisAg	   := DC.Comision_Distr;
         	 nMontoComisAg   := DC.Monto;
         	 cEstatusComisAg := DC.Estatus_com;
         ELSIF DC.Tipo = 4 THEN
         	 nCodHn          := dc.Cod_Agente;  
         	 nCodNivelHn     := DC.Tipo;
           --nPorcComisHn	   := DC.Comision;
           nPorcComisHn	   := DC.Comision_Distr;
         	 nMontoComisHn   := DC.Monto;
         	 cEstatusComisHn := DC.Estatus_com;
         ELSIF DC.Tipo = 5 THEN
           nCodUd          := dc.Cod_Agente;  
         	 nCodNivelUd     := DC.Tipo;
           --nPorcComisUd	   := DC.Comision;
           nPorcComisUd	   := DC.Comision_Distr;
         	 nMontoComisUd   := DC.Monto;
         	 cEstatusComisUd := DC.Estatus_com;
         END IF;
	    END LOOP;
	    
      -- rmerida FIN --
      IF CFormato = 'TEXTO' THEN
         cCadena := X.NumPolUnico                                  ||cLimitador||
                    TO_CHAR(X.IdPoliza,'9999999999999')            ||cLimitador||
                    X.NumPolRef                                    ||cLimitador||
                    X.CodFilial                                    ||cLimitador||
                    X.Contratante                                  ||cLimitador||
                    TO_CHAR(X.IdEndoso,'9999999999999')            ||cLimitador||
                    'RECIBO'                                       ||cLimitador||
                    TO_CHAR(X.IdFactura,'9999999999990')           ||cLimitador||
                    cDescFormaPago                                 ||cLimitador||
                    TO_CHAR(X.FechaTransaccion,'DD/MM/YYYY')       ||cLimitador||
                    cDescEstado                                    ||cLimitador||
                    TO_CHAR(X.FecIniVig,'DD/MM/RRRR')              ||cLimitador||
                    TO_CHAR(X.FecFinVig,'DD/MM/RRRR')              ||cLimitador||
                    TO_CHAR(nPrimaNeta,'99999999999990.00')        ||cLimitador||
                    cCodGenerador                                  ||cLimitador||
                    --LPAD(cCodGenerador,6,'0')                      ||cLimitador||                    
                    TO_CHAR(nCodNivelAg,'99999999999990.00')       ||cLimitador||
                    TO_CHAR(nPorcComisAg,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMontoComisAg,'99999999999990.00')     ||cLimitador||
                    cEstatusComisAg                                ||cLimitador||
                    nCodPrm                            ||cLimitador||                    
                    --LPAD(nCodPrm,6,'0')                            ||cLimitador||
                    TO_CHAR(nCodNivelPrm,'99999999999990.00')      ||cLimitador||                
                    TO_CHAR(nPorcComisPrm,'99999999999990.00')     ||cLimitador||
                    TO_CHAR(nMontoComisPrm,'99999999999990.00')    ||cLimitador||
                    cEstatusComisPrm                               ||cLimitador||
                    nCodRg                            ||cLimitador||                    
                    --LPAD(nCodRg,6,'0')                             ||cLimitador||
                    TO_CHAR(nCodNivelRg,'99999999999990.00')       ||cLimitador||
                    TO_CHAR(nPorcComisRg,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMontoComisRg,'99999999999990.00')     ||cLimitador||
                    cEstatusComisRg                                ||cLimitador||
                    --LPAD(nCodHn,6,'0')                             ||cLimitador||
                    nCodHn                              ||cLimitador||
                    TO_CHAR(nCodNivelHn,'99999999999990.00')       ||cLimitador||
                    TO_CHAR(nPorcComisHn,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMontoComisHn,'99999999999990.00')     ||cLimitador||                   
                    cEstatusComisHn                                ||cLimitador||                                        
                    
                    --LPAD(nCodUd,6,'0')                             ||cLimitador||
                    TO_CHAR(nCodNivelUd,'99999999999990.00')       ||cLimitador||
                    TO_CHAR(nPorcComisUd,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMontoComisUd,'99999999999990.00')     ||cLimitador||                  
                    cEstatusComisUd                                ||cLimitador||
                    
                    TO_CHAR(X.MtoComisi_Moneda,'99999999999990.00')||cLimitador||
                    
                    TO_CHAR(X.FecAnul,'DD/MM/RRRR')                ||cLimitador||
                    X.MotivAnul                                    ||cLimitador||
                    
                    X.PlanCob                                      ||cLimitador||
                    X.CodTipoPlan                                  ||cLimitador||
                    X.DescSubRamo                                  ||cLimitador||
                    TO_CHAR(X.NumCuota,'99990')                    ||cLimitador||
                    cNumComprob                                    ||cLimitador||
                    X.FolioFactElec                                ||CHR(13);
                    
                    
                    
                    /*cLimitador||X.IdTipoSeg                                    ||cLimitador||
                    TO_CHAR(nComisionesPEF,'99999999999990.00')    ||cLimitador||
                    TO_CHAR(nComisionesPEM,'99999999999990.00')    ||cLimitador||
                    TO_CHAR(nHonorariosPEF,'99999999999990.00')    ||cLimitador||
                    TO_CHAR(nHonorariosPEM,'99999999999990.00')    ||cLimitador||
                    TO_CHAR(nUdisPEF,'99999999999990.00')          ||cLimitador||
                    TO_CHAR(nUdisPEM,'99999999999990.00')          ||cLimitador||
                    TO_CHAR(nDifComis,'99999999999990.00')         ||cLimitador||
                    
                    --TO_CHAR(X.FecVenc,'DD/MM/RRRR')                ||cLimitador||
                    --TO_CHAR(dFecFin,'DD/MM/RRRR')                  ||cLimitador||
                    TO_CHAR(nTasaIVA,'999990.00')                  ||cLimitador||
                    
                    X.Cod_Moneda                                   ||cLimitador||
                    cTipoVigencia                                  ||cLimitador||
                    
                    TO_CHAR(X.NumRenov,'99990')                    ||cLimitador||
                    
                    
                    
                    */
      ELSIF CFormato = 'EXCEL' THEN
         cCadena := '<tr>' || OC_ARCHIVO.CAMPO_HTML(X.NumPolUnico,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdPoliza,'9999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.NumPolRef,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.CodFilial,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.Contratante,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdEndoso,'9999999999990'),'C') ||                    
                    OC_ARCHIVO.CAMPO_HTML('RECIBO','C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdFactura,'9999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(cDescFormaPago,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.FechaTransaccion,'D') ||
                    OC_ARCHIVO.CAMPO_HTML(cDescEstado,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.FecIniVig,'D') ||
                    OC_ARCHIVO.CAMPO_HTML(X.FecFinVig,'D') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPrimaNeta,'99999999999990.00'),'N') ||                    
                    --OC_ARCHIVO.CAMPO_HTML(LPAD(cCodGenerador,6,'0'),'C') ||                 
                    OC_ARCHIVO.CAMPO_HTML( cCodGenerador, 'C') ||                 
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelAg, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisAg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisAg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisAg, 'C') ||                    
                    --OC_ARCHIVO.CAMPO_HTML(LPAD(nCodPrm,6,'0'),'C') ||                     
                    OC_ARCHIVO.CAMPO_HTML( nCodPrm,'C') ||                     
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelPrm, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisPrm,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisPrm,'99999999999990.00'),'N') ||                    
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisPrm, 'C') ||                    
                    --OC_ARCHIVO.CAMPO_HTML(LPAD(nCodRg,6,'0'),'C') ||                     
                    OC_ARCHIVO.CAMPO_HTML( nCodRg, 'C') ||                     
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelRg,  'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisRg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisRg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisRg, 'C') ||                    
                    --OC_ARCHIVO.CAMPO_HTML(LPAD(nCodHn,6,'0'),'C') ||     
                    OC_ARCHIVO.CAMPO_HTML( nCodHn, 'C') ||     
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelHn, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisHn,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisHn,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisHn, 'C') ||                    
                    --OC_ARCHIVO.CAMPO_HTML(LPAD(nCodUd,6,'0'),'C') ||      
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelUd,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisUd,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisUd,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisUd, 'C') || 
                                       
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MtoComisi_Moneda,'99999999999990.00'),'N') ||
                    
                    OC_ARCHIVO.CAMPO_HTML(X.FecAnul,'D') ||
                    OC_ARCHIVO.CAMPO_HTML(X.MotivAnul,'C') ||
                    
                    OC_ARCHIVO.CAMPO_HTML(X.PlanCob,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.CodTipoPlan,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.DescSubRamo,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.NumCuota,'99990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(cNumComprob,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.FolioFactElec,'C') ||'</tr>'
                    ;
   
   
                    /*OC_ARCHIVO.CAMPO_HTML(X.IdTipoSeg,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nComisionesPEF,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nComisionesPEM,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nHonorariosPEF,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nHonorariosPEM,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nUdisPEF,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nUdisPEM,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nDifComis,'99999999999990.00'),'N') 
                    --OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nTasaIVA,'999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(X.Cod_Moneda,'C') ||
                    
                    OC_ARCHIVO.CAMPO_HTML(cTipoVigencia,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.NumRenov,'99990'),'C') ||     
                    OC_ARCHIVO.CAMPO_HTML(X.FecVenc,'D') ||
                    OC_ARCHIVO.CAMPO_HTML(dFecFin,'D') ||
                    
                     */              
                    
      END IF;
      nLinea := nLinea + 1;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END LOOP;
   
   
   FOR X IN NC_Q LOOP
   	  nIdNcr          := X.IdNcr;
   	  cStsNcr         := X.StsNcr;
   	  cCodGenerador   := OC_AGENTE_POLIZA.AGENTE_PRINCIPAL(X.CodCia, X.IdPoliza);
      cDescFormaPago  := 'DIRECTO';
      dFecFin         := NULL; --OC_NOTAS_DE_CREDITO.VIGENCIA_FINAL(X.CodCia, X.IdNcr);

      BEGIN
         SELECT OC_PROVINCIA.NOMBRE_PROVINCIA(P.CodPaisRes, P.CodProvRes)
           INTO cDescEstado
           FROM CLIENTES C, PERSONA_NATURAL_JURIDICA P
          WHERE P.Tipo_Doc_Identificacion = C.Tipo_Doc_Identificacion
            AND P.Num_Doc_Identificacion  = C.Num_Doc_Identificacion
            AND C.CodCliente              = X.CodCliente;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cDescEstado := NULL;
      END;
      IF cDescEstado = 'PROVINCIA NO EXISTE' THEN
      	 cDescEstado := NULL;
      END IF;

      IF X.NumRenov = 0 THEN
         cTipoVigencia := '1ER. AÑO';
      ELSE
         cTipoVigencia := 'RENOVACION';
      END IF;

      nPrimaNeta      := 0;
      nReducPrima     := 0;
      nRecargos       := 0;
      nDerechos       := 0;
      nImpuesto       := 0;
      nPrimaTotal     := 0;
      nComisionesPEF  := 0;
      nHonorariosPEF  := 0;
      nUdisPEF        := 0;
      nComisionesPEM  := 0;
      nHonorariosPEM  := 0;
      nUdisPEM        := 0;
      nTotComisDist   := 0;
      
      nCodRg           := 0;
      nCodNivelRg      := 0;
			nPorcComisRg	   := 0;
			nMontoComisRg    := 0;
			cEstatusComisRg  := '';
			nCodPrm          := 0;
			nCodNivelPrm     := 0;
			nPorcComisPrm	   := 0;
			nMontoComisPrm   := 0;
			cEstatusComisPrm := '';
			nCodAg           := 0;
			nCodNivelAg      := 0;
			nPorcComisAg	   := 0;
			nMontoComisAg    := 0;
			cEstatusComisAg  := '';
			nCodHn           := 0;
			nCodNivelHn      := 0;
			nPorcComisHn	   := 0;
			nMontoComisHn    := 0;
			cEstatusComisHn  := '';
			
			nCodUd           := 0;
			nCodNivelUd      := 0;
			nPorcComisUd	   := 0;
			nMontoComisUd    := 0;
			cEstatusComisUd  := '';

      FOR W IN DET_NC_Q LOOP
      	 IF X.IdTransaccionAnu = X.IdTransaccion THEN
      	    nMonto_Det_Moneda := NVL(W.Monto_Det_Moneda,0) * -1;
         ELSE
      	    nMonto_Det_Moneda := NVL(W.Monto_Det_Moneda,0);
         END IF;
         IF W.IndCptoPrima = 'S' OR W.IndCptoServicio = 'S' THEN
            nPrimaNeta  := NVL(nPrimaNeta,0) + NVL(nMonto_Det_Moneda,0);
         ELSIF W.CodCpto = 'RECFIN' THEN
            nRecargos   := NVL(nRecargos,0) + NVL(nMonto_Det_Moneda,0);
         ELSIF W.CodCpto = 'DEREMI' THEN
            nDerechos   := NVL(nDerechos,0) + NVL(nMonto_Det_Moneda,0);
         ELSIF W.CodCpto = 'IVASIN' THEN
            nImpuesto   := NVL(nImpuesto,0) + NVL(nMonto_Det_Moneda,0);
            nTasaIVA    := OC_CONCEPTOS_PLAN_DE_PAGOS.PORCENTAJE_CONCEPTO(X.CodCia, X.CodEmpresa, cCodPlanPagos, W.CodCpto);
         ELSE
            nImpuesto   := NVL(nImpuesto,0) + NVL(nMonto_Det_Moneda,0);
         END IF;
         nPrimaTotal  := NVL(nPrimaTotal,0) + NVL(nMonto_Det_Moneda,0);
      END LOOP;

      FOR C IN DET_ConC_NCR (X.IdPoliza, X.IdNcr) LOOP
         IF X.IdTransaccionAnu = X.IdTransaccion THEN
      	    nMonto_Mon_Extranjera := NVL(C.Monto_Mon_Extranjera,0) * -1;
         ELSE
      	    nMonto_Mon_Extranjera := NVL(C.Monto_Mon_Extranjera,0);
         END IF;
      	 IF C.CODTIPO = 'AGTEPF' THEN --AGENTE PERSONA FISICA
          	IF C.CodConcepto IN ('COMISI','COMIPF') THEN
              nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(nMonto_Mon_Extranjera,0);
      	    ELSIF C.CodConcepto = 'HONORA' THEN
      	 	    nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(nMonto_Mon_Extranjera,0);
            ELSE
              NULL;
            END IF;
         ELSIF C.CODTIPO = 'AGTEPM' THEN -- AGENTE PERSONA MORAL 
          	IF C.CodConcepto IN ('COMISI','COMIPM') THEN
               nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(nMonto_Mon_Extranjera,0);
      	    ELSIF C.CodConcepto = 'HONORA' THEN
      	 	     nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(nMonto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF;
         ELSIF C.CODTIPO = 'HONPF' THEN -- HONORARIOS PERSONA FISICA 
            IF C.CodConcepto IN ('COMISI','COMIPF') THEN
               nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(nMonto_Mon_Extranjera,0);
      	    ELSIF C.CodConcepto = 'HONORA' THEN
      	 	    nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(nMonto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF; 			
         ELSIF C.CODTIPO = 'HONPM' THEN -- HONORARIOS PERSONA MORAL 
            IF C.CodConcepto IN ('COMISI','COMIPM') THEN
               nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(nMonto_Mon_Extranjera,0);
      	    ELSIF C.CodConcepto = 'HONORA' THEN
      	 	     nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(nMonto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF; 	
         ELSIF C.CodTipo = 'UDISPF' THEN -- UDIS PERSONA FISICA
            IF C.CodConcepto = 'UDI' THEN
               nUdisPEF        := NVL(nUdisPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF;
         ELSIF C.CodTipo = 'UDISPM' THEN -- UDIS PERSONA MORAL 
            IF C.CodConcepto = 'UDI' THEN
               nUdisPEM        := NVL(nUdisPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF;
      	 END IF;	
         nTotComisDist   := NVL(nTotComisDist,0) + NVL(nMonto_Mon_Extranjera,0);
      END LOOP;

      nDifComis := NVL(X.MtoComisi_Moneda,0) - NVL(nTotComisDist,0);

      SELECT NVL(MIN(NumComprob),'0')
        INTO cNumComprob
        FROM COMPROBANTES_CONTABLES
       WHERE NumTransaccion = X.IdTransaccion;
      
      	-- Detalle de las Comisiones %,Montos
	    FOR DC IN DET_Comision_NTC(X.IdPoliza) LOOP
          IF DC.Tipo = 1 THEN 
         	 nCodRg          := dc.Cod_Agente;          
         	 nCodNivelRg     := DC.Tipo;
           --nPorcComisRg	   := DC.Comision;
           nPorcComisRg	   := DC.Comision_Distr;
         	 nMontoComisRg   := DC.Monto;
         	 cEstatusComisRg := DC.Estatus_com;
         ELSIF DC.Tipo =2 THEN
           nCodPrm         := dc.Cod_Agente;          
         	 nCodNivelPrm    := DC.Tipo;
           --nPorcComisPrm	 := DC.Comision;
           nPorcComisPrm	 := DC.Comision_Distr;
         	 nMontoComisPrm  := DC.Monto;
         	 cEstatusComisPrm:= DC.Estatus_com;
         ELSIF DC.Tipo = 3 THEN
         	 nCodAg          := dc.Cod_Agente;  
           nCodNivelAg     := DC.Tipo ;         	 
         	 --nPorcComisAg	   := DC.Comision;
         	 nPorcComisAg	   := DC.Comision_Distr;
         	 nMontoComisAg   := DC.Monto;
         	 cEstatusComisAg := DC.Estatus_com;
         ELSIF DC.Tipo = 4 THEN
         	 nCodHn          := dc.Cod_Agente;  
         	 nCodNivelHn     := DC.Tipo;
           --nPorcComisHn	   := DC.Comision;
           nPorcComisHn	   := DC.Comision_Distr;
         	 nMontoComisHn   := DC.Monto;
         	 cEstatusComisHn := DC.Estatus_com;
         ELSIF DC.Tipo = 5 THEN
           nCodUd          := dc.Cod_Agente;  
         	 nCodNivelUd     := DC.Tipo;
           --nPorcComisUd	   := DC.Comision;
           nPorcComisUd	   := DC.Comision_Distr;
         	 nMontoComisUd   := DC.Monto;
         	 cEstatusComisUd := DC.Estatus_com;
         END IF;
	    END LOOP; 
      
       

      IF CFormato = 'TEXTO' THEN
         cCadena := X.NumPolUnico                                  ||cLimitador||
                    TO_CHAR(X.IdPoliza,'9999999999999')            ||cLimitador||
                    X.NumPolRef                                    ||cLimitador||
                    X.CodFilial                                    ||cLimitador||
                    X.Contratante                                  ||cLimitador||
                    TO_CHAR(X.IdEndoso,'9999999999999')            ||cLimitador||
                    'NCR'                                          ||cLimitador||
                    TO_CHAR(X.IdNcr,'9999999999990')               ||cLimitador||
                    cDescFormaPago                                 ||cLimitador||
                    TO_CHAR(X.FechaTransaccion,'DD/MM/YYYY')       ||cLimitador||
                    cDescEstado                                    ||cLimitador||
                    TO_CHAR(X.FecIniVig,'DD/MM/RRRR')              ||cLimitador||
                    TO_CHAR(X.FecFinVig,'DD/MM/RRRR')              ||cLimitador||
                    TO_CHAR(nPrimaNeta,'99999999999990.00')        ||cLimitador||                    
                    cCodGenerador                      ||cLimitador||
                    --LPAD(cCodGenerador,6,'0')                      ||cLimitador||                    
                    TO_CHAR(nCodNivelAg)                           ||cLimitador||
                    TO_CHAR(nPorcComisAg,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMontoComisAg,'99999999999990.00')     ||cLimitador||
                    cEstatusComisAg                                ||cLimitador||                    
                    TO_CHAR(nCodPrm)                               ||cLimitador||  
                    TO_CHAR(nCodNivelPrm,'99999999999990.00')      ||cLimitador||                
                    TO_CHAR(nPorcComisPrm,'99999999999990.00')     ||cLimitador||
                    TO_CHAR(nMontoComisPrm,'99999999999990.00')    ||cLimitador||
                    cEstatusComisPrm                               ||cLimitador||                    
                    TO_CHAR(nCodRg)                                ||cLimitador||
                    TO_CHAR(nCodNivelRg)                           ||cLimitador||
                    TO_CHAR(nPorcComisRg,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMontoComisRg,'99999999999990.00')     ||cLimitador||
                    cEstatusComisRg                                ||cLimitador||                    
                    TO_CHAR(nCodHn)                                ||cLimitador||
                    TO_CHAR(nCodNivelHn)                           ||cLimitador||
                    TO_CHAR(nPorcComisHn,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMontoComisHn,'99999999999990.00')     ||cLimitador||                   
                    cEstatusComisHn                                ||cLimitador||
                    --TO_CHAR(nCodUd)                                ||cLimitador|| 
                    TO_CHAR(nCodNivelUd)                           ||cLimitador||
                    TO_CHAR(nPorcComisUd,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMontoComisUd,'99999999999990.00')     ||cLimitador||
                    cEstatusComisUd       
                                             ||cLimitador||                    
                    TO_CHAR(X.MtoComisi_Moneda,'99999999999990.00')||cLimitador||
                    
                    TO_CHAR(X.FecDevol,'DD/MM/RRRR')               ||cLimitador||
                    X.MotivAnul                                    ||cLimitador||
                    
                    X.PlanCob                                      ||cLimitador||
                    X.CodTipoPlan                                  ||cLimitador||
                    X.DescSubRamo                                  ||cLimitador||
                    TO_CHAR(X.NumCuota,'99990')                    ||cLimitador||
                    cNumComprob                                    ||cLimitador||
                    X.FolioFactElec                                ||CHR(13)
                    
                    ;
                    /*
                  --   cLimitador||
                    TO_CHAR(nComisionesPEF,'99999999999990.00')    ||cLimitador||
                    TO_CHAR(nComisionesPEM,'99999999999990.00')    ||cLimitador||
                    TO_CHAR(nHonorariosPEF,'99999999999990.00')    ||cLimitador||
                    TO_CHAR(nHonorariosPEM,'99999999999990.00')    ||cLimitador||
                    TO_CHAR(nUdisPEF,'99999999999990.00')          ||cLimitador||
                    TO_CHAR(nUdisPEM,'99999999999990.00')          ||cLimitador||
                    TO_CHAR(nDifComis,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(X.FecDevol,'DD/MM/RRRR')               ||cLimitador||                    
                  --  TO_CHAR(dFecFin,'DD/MM/RRRR')                  ||cLimitador||
                    
                    TO_CHAR(nTasaIVA,'999990.00')                  ||cLimitador||
                   X.CodMoneda                                    ||cLimitador||
                    cTipoVigencia                                  ||cLimitador||                    
                    TO_CHAR(X.NumRenov,'99990')                    ||cLimitador||
                    X.IdTipoSeg                                    ||cLimitador||
                   
                    
                    */                    
                    
      ELSIF CFormato = 'EXCEL' THEN
         cCadena := '<tr>' || OC_ARCHIVO.CAMPO_HTML(X.NumPolUnico,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdPoliza,'9999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.NumPolRef,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.CodFilial,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.Contratante,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdEndoso,'9999999999990'),'C') ||                    
                    OC_ARCHIVO.CAMPO_HTML('NCR','C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdNcr,'9999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(cDescFormaPago,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.FechaTransaccion,'D') ||
                    OC_ARCHIVO.CAMPO_HTML(cDescEstado,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.FecIniVig,'D') ||
                    OC_ARCHIVO.CAMPO_HTML(X.FecFinVig,'D') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPrimaNeta,'99999999999990.00'),'N') ||                    
                    --OC_ARCHIVO.CAMPO_HTML(LPAD(cCodGenerador,6,'0'),'C') ||                 
                    OC_ARCHIVO.CAMPO_HTML(cCodGenerador, 'C') ||                 
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelAg, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisAg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisAg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisAg, 'C') ||                    
                    --OC_ARCHIVO.CAMPO_HTML(LPAD(nCodPrm,6,'0'),'C') ||                     
                    OC_ARCHIVO.CAMPO_HTML( nCodPrm ,'C') ||                     
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelPrm, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisPrm,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisPrm,'99999999999990.00'),'N') ||                    
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisPrm, 'C') ||                    
                    --OC_ARCHIVO.CAMPO_HTML(LPAD(nCodRg,6,'0'),'C') ||                     
                    OC_ARCHIVO.CAMPO_HTML( nCodRg ,'C') ||                     
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelRg,  'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisRg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisRg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisRg, 'C') ||                    
                    --OC_ARCHIVO.CAMPO_HTML(LPAD(nCodHn,6,'0'),'C') ||     
                    OC_ARCHIVO.CAMPO_HTML( nCodHn,'C') ||     
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelHn, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisHn,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisHn,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisHn, 'C') ||                    
                    --OC_ARCHIVO.CAMPO_HTML(LPAD(nCodUd,6,'0'),'C') ||      
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelUd,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisUd,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisUd,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisUd, 'C') ||
                    
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MtoComisi_Moneda,'99999999999990.00'),'N') ||
                    
                    OC_ARCHIVO.CAMPO_HTML(X.FecAnul,'D') ||
                    OC_ARCHIVO.CAMPO_HTML(X.MotivAnul,'C') ||
                    
                    OC_ARCHIVO.CAMPO_HTML(X.PlanCob,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.CodTipoPlan,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.DescSubRamo,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.NumCuota,'99990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(cNumComprob,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.FolioFactElec,'C') ||'</tr>'
                     ;
                    
                    /*
                    --OC_ARCHIVO.CAMPO_HTML(X.IdTipoSeg,'C') ||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nComisionesPEF,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nComisionesPEM,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nHonorariosPEF,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nHonorariosPEM,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nUdisPEF,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nUdisPEM,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nDifComis,'99999999999990.00'),'N') 
                  OC_ARCHIVO.CAMPO_HTML(X.FecDevol,'D') ||                    
                    OC_ARCHIVO.CAMPO_HTML(dFecFin,'D') ||
                    
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nTasaIVA,'999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(X.CodMoneda,'C') ||
                    
                    OC_ARCHIVO.CAMPO_HTML(cTipoVigencia,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.NumRenov,'99990'),'C') ||                     
                    */
                    
      END IF;
      nLinea := nLinea + 1;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END LOOP;
  
   IF CFormato = 'EXCEL' THEN
      OC_ARCHIVO.Escribir_Linea('</table></div></html>', ccodUSER, 9999);
   END IF;
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 

  INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
    SELECT nIdReporte + 1,
           B.TIPO_REPORTE,
           B.CODUSR,
           SYSDATE,
           'GEN',
           A.DATA,
           B.FILE_NAME
      FROM SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
     WHERE A.CODUSER = B.CODUSR
       AND B.IDEXTRACCION = nIdReporte;
  DELETE SICAS_OC.EXTRACCION_DE_REPORTES WHERE IDEXTRACCION = nIdReporte;
  OC_ARCHIVO.Eliminar_Archivo(cCodUser);


EXCEPTION 
   WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      RAISE_APPLICATION_ERROR(-20105,'Error en Generación de Conciliacion de Comisiones Anuladas: '||nIdFactura || ' ' ||SQLERRM); 
END;

PROCEDURE GENERAR_PAGADOS(cNomArchivo VARCHAR2, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                          cCodMoneda VARCHAR2, cCodAgente VARCHAR2, dFecDesde DATE,
                          dFecHasta DATE, cformato varchar2, nidreporte number) IS
                          
cLimitador             VARCHAR2(1) :='|';
nLinea                 NUMBER;
cCadena                VARCHAR2(8000);
cCodUser               VARCHAR2(30);
nDummy                 NUMBER;
cCopy                  BOOLEAN;
cDescFormaPago         VARCHAR2(100);
dFecFin                DATE;
--cTipoVigencia   VARCHAR2(20);
nIdFactura             FACTURAS.IdFactura%TYPE;
nPrimaNeta             DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
cCodGenerador          AGENTE_POLIZA.Cod_Agente%TYPE;
--cCodPlanPagos          PLAN_DE_PAGOS.CodPlanPago%TYPE;
nTasaIVA               CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
cDescEstado            PROVINCIA.DescEstado%TYPE;
--nFrecPagos             PLAN_DE_PAGOS.FrecPagos%TYPE;
nCodTipo               AGENTES.CODTIPO%TYPE;
cNumComprob            COMPROBANTES_CONTABLES.NumComprob%TYPE;
cTipoTran              VARCHAR2(4);
nIdNcr                 NOTAS_DE_CREDITO.IdNcr%TYPE;
--cTipoEndoso            ENDOSOS.TipoEndoso%TYPE;
dFecFinVig             ENDOSOS.FecFinVig%TYPE;
--cStsNcr                NOTAS_DE_CREDITO.StsNcr%TYPE;

nCodAg                 COMISIONES.Cod_Agente%TYPE;
nCodNivelAg            AGENTES.CodNivel%TYPE;
nPorcComisAg	         AGENTES_DISTRIBUCION_POLIZA.Porc_Com_Proporcional%TYPE;
nMontoComisAg          COMISIONES.Comision_Moneda%TYPE;
cEstatusComisAg        COMISIONES.Estado%TYPE;
nCodRg                 COMISIONES.Cod_Agente%TYPE;
nCodNivelRg            AGENTES.CodNivel%TYPE;
nPorcComisRg	         AGENTES_DISTRIBUCION_POLIZA.Porc_Com_Proporcional%TYPE;
nMontoComisRg          COMISIONES.Comision_Moneda%TYPE;
cEstatusComisRg        COMISIONES.Estado%TYPE;
nCodPrm                COMISIONES.Cod_Agente%TYPE;
nCodNivelPrm           AGENTES.CodNivel%TYPE;                     
nPorcComisPrm	         AGENTES_DISTRIBUCION_POLIZA.Porc_Com_Proporcional%TYPE;
nMontoComisPrm         COMISIONES.Comision_Moneda%TYPE;
cEstatusComisPrm       COMISIONES.Estado%TYPE;
nCodHn                 COMISIONES.Cod_Agente%TYPE;
nCodNivelHn            AGENTES.CodNivel%TYPE;
nPorcComisHn	         AGENTES_DISTRIBUCION_POLIZA.Porc_Com_Proporcional%TYPE;
nMontoComisHn          COMISIONES.Comision_Moneda%TYPE;                               
cEstatusComisHn        COMISIONES.Estado%TYPE;                                        
nCodUd                 COMISIONES.Cod_Agente%TYPE;
nCodNivelUd            AGENTES.CodNivel%TYPE;
nPorcComisUd	         AGENTES_DISTRIBUCION_POLIZA.Porc_Com_Proporcional%TYPE;
nMontoComisUd          COMISIONES.Comision_Moneda%TYPE;                              
cEstatusComisUd        COMISIONES.Estado%TYPE;

nIvaRg                 COMISIONES.Comision_Moneda%TYPE;
nIvaPrm                COMISIONES.Comision_Moneda%TYPE;
nIvaAg                 COMISIONES.Comision_Moneda%TYPE;
nIvaHn                 COMISIONES.Comision_Moneda%TYPE;
nIvaUd                 COMISIONES.Comision_Moneda%TYPE;
nRetIvaRg              COMISIONES.Comision_Moneda%TYPE;
nRetIvaPrm             COMISIONES.Comision_Moneda%TYPE;
nRetIvaAg              COMISIONES.Comision_Moneda%TYPE;
nRetIvaHn              COMISIONES.Comision_Moneda%TYPE;
nRetIvaUd              COMISIONES.Comision_Moneda%TYPE;
nRetIsrRg              COMISIONES.Comision_Moneda%TYPE;
nRetIsrPrm             COMISIONES.Comision_Moneda%TYPE;
nRetIsrAg              COMISIONES.Comision_Moneda%TYPE;
nRetIsrHn              COMISIONES.Comision_Moneda%TYPE;
nRetIsrUd              COMISIONES.Comision_Moneda%TYPE;
cPaso                  Varchar(30);
nCantReg_Q	           NUMBER;


CURSOR PAG_Q IS 
   SELECT P.IdPoliza, P.NumPolUnico, P.NumPolRef, DP.CodFilial, OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||
          OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
          F.IdEndoso, F.IdFactura IdRecibo, T.FechaTransaccion, F.FecVenc, F.Cod_Moneda,
          DP.IdTipoSeg, DP.PlanCob, PC.CodTipoPlan,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
          P.CodCliente, P.FecIniVig, P.FecFinVig, P.NumRenov, P.CodCia, F.MtoComisi_Moneda,
          F.NumCuota, P.CodEmpresa, TRUNC(PG.Fecha) FecPago, T.IdTransaccion, 'PAGO' TipoTran, F.FolioFactElec
     FROM FACTURAS F, PAGOS PG, TRANSACCION T, POLIZAS P, DETALLE_POLIZA DP, PLAN_COBERTURAS PC
    WHERE PC.PlanCob                 = DP.PlanCob
      AND PC.IdTipoSeg               = DP.IdTipoSeg
      AND PC.CodEmpresa              = DP.CodEmpresa
      AND PC.CodCia                  = DP.CodCia
      AND DP.CodCia                  = F.CodCia
      AND DP.IDetPol                 = F.IDetPol
      AND DP.IdPoliza                = F.IdPoliza
      AND ((DP.IdTipoSeg             = cIdTipoSeg AND cIdTipoSeg != '%')
       OR  (DP.IdTipoSeg          LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
      AND ((DP.PlanCob               = cPlanCob AND cPlanCob != '%')
       OR  (DP.PlanCob            LIKE cPlanCob AND cPlanCob = '%'))
      AND ((F.Cod_Moneda             = cCodMoneda AND cCodMoneda != '%')
       OR  (F.Cod_Moneda          LIKE cCodMoneda AND cCodMoneda = '%'))
      AND ((F.CodGenerador           = cCodAgente AND cCodAgente != '%')
       OR  (F.CodGenerador        LIKE cCodAgente AND cCodAgente = '%'))
      AND P.CodCia                   = F.CodCia
      AND P.IdPoliza                 = F.IdPoliza
      AND T.IdTransaccion            = PG.IdTransaccion
      --AND PG.IdTransaccionAnu       IS NULL
      AND PG.IdFactura               = F.IdFactura
      AND TRUNC(PG.Fecha)           >= dFecDesde
      AND TRUNC(PG.Fecha)           <= dFecHasta
      AND F.StsFact                  = 'PAG'
    UNION
   SELECT P.IdPoliza, P.NumPolUnico, P.NumPolRef, DP.CodFilial, OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||
          OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
          F.IdEndoso, F.IdFactura IdRecibo, T.FechaTransaccion, F.FecVenc, F.Cod_Moneda,
          DP.IdTipoSeg, DP.PlanCob, PC.CodTipoPlan,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
          P.CodCliente, P.FecIniVig, P.FecFinVig, P.NumRenov, P.CodCia, F.MtoComisi_Moneda,
          F.NumCuota, P.CodEmpresa, TRUNC(PG.Fecha) FecPago, T.IdTransaccion, 'PAGO' TipoTran, F.FolioFactElec
     FROM FACTURAS F, PAGOS PG, TRANSACCION T, POLIZAS P, DETALLE_POLIZA DP, PLAN_COBERTURAS PC
    WHERE PC.PlanCob                 = DP.PlanCob
      AND PC.IdTipoSeg               = DP.IdTipoSeg
      AND PC.CodEmpresa              = DP.CodEmpresa
      AND PC.CodCia                  = DP.CodCia
      AND DP.CodCia                  = F.CodCia
      AND DP.IDetPol                 = F.IDetPol
      AND DP.IdPoliza                = F.IdPoliza
      AND ((DP.IdTipoSeg             = cIdTipoSeg AND cIdTipoSeg != '%')
       OR  (DP.IdTipoSeg          LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
      AND ((DP.PlanCob               = cPlanCob AND cPlanCob != '%')
       OR  (DP.PlanCob            LIKE cPlanCob AND cPlanCob = '%'))
      AND ((F.Cod_Moneda             = cCodMoneda AND cCodMoneda != '%')
       OR  (F.Cod_Moneda          LIKE cCodMoneda AND cCodMoneda = '%'))
      AND ((F.CodGenerador           = cCodAgente AND cCodAgente != '%')
       OR  (F.CodGenerador        LIKE cCodAgente AND cCodAgente = '%'))
      AND P.CodCia                   = F.CodCia
      AND P.IdPoliza                 = F.IdPoliza
      AND T.IdTransaccion            = PG.IdTransaccion
      AND F.StsFact                 IN ('ANU','EMI')
      AND PG.IdFactura               = F.IdFactura
      AND TRUNC(PG.Fecha)           >= dFecDesde
      AND TRUNC(PG.Fecha)           <= dFecHasta
    UNION
   SELECT P.IdPoliza, P.NumPolUnico, P.NumPolRef, DP.CodFilial, OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||
          OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
          F.IdEndoso, F.IdFactura IdRecibo, T.FechaTransaccion, F.FecVenc, F.Cod_Moneda,
          DP.IdTipoSeg, DP.PlanCob, PC.CodTipoPlan,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
          P.CodCliente, P.FecIniVig, P.FecFinVig, P.NumRenov, P.CodCia, F.MtoComisi_Moneda * -1 MtoComisi_Moneda,
          F.NumCuota, P.CodEmpresa, TRUNC(PG.FecAnulacion) FecPago, T.IdTransaccion, 'REVE' TipoTran, F.FolioFactElec
     FROM FACTURAS F, PAGOS PG, TRANSACCION T, POLIZAS P, DETALLE_POLIZA DP, PLAN_COBERTURAS PC
    WHERE PC.PlanCob                 = DP.PlanCob
      AND PC.IdTipoSeg               = DP.IdTipoSeg
      AND PC.CodEmpresa              = DP.CodEmpresa
      AND PC.CodCia                  = DP.CodCia
      AND DP.CodCia                  = F.CodCia
      AND DP.IDetPol                 = F.IDetPol
      AND DP.IdPoliza                = F.IdPoliza
      AND ((DP.IdTipoSeg             = cIdTipoSeg AND cIdTipoSeg != '%')
       OR  (DP.IdTipoSeg          LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
      AND ((DP.PlanCob               = cPlanCob AND cPlanCob != '%')
       OR  (DP.PlanCob            LIKE cPlanCob AND cPlanCob = '%'))
      AND ((F.Cod_Moneda             = cCodMoneda AND cCodMoneda != '%')
       OR  (F.Cod_Moneda          LIKE cCodMoneda AND cCodMoneda = '%'))
      AND ((F.CodGenerador           = cCodAgente AND cCodAgente != '%')
       OR  (F.CodGenerador        LIKE cCodAgente AND cCodAgente = '%'))
      AND P.CodCia                   = F.CodCia
      AND P.IdPoliza                 = F.IdPoliza
      AND T.IdTransaccion            = PG.IdTransaccionAnu
      AND PG.IdFactura               = F.IdFactura
      AND PG.FecAnulacion           >= dFecDesde
      AND PG.FecAnulacion           <= dFecHasta
    ORDER BY IdRecibo;

CURSOR DET_Q IS
   SELECT D.CodCpto, DECODE(cTipoTran,'PAGO',D.Monto_Det_Moneda,D.Monto_Det_Moneda*-1) Monto_Det_Moneda,
          D.IndCptoPrima, C.IndCptoServicio
     FROM DETALLE_FACTURAS D, FACTURAS F, CATALOGO_DE_CONCEPTOS C
    WHERE C.CodConcepto = D.CodCpto
      AND C.CodCia      = F.CodCia
      AND D.IdFactura   = F.IdFactura
      AND F.IdFactura   = nIdFactura;

CURSOR DET_ConC (P_IdPoliza NUMBER, p_idFactura NUMBER) IS
   SELECT DCO.CodConcepto, AGE.CodTipo, AGE.CodNivel, COM.Cod_Agente,
          DECODE(cTipoTran,'PAGO',DCO.Monto_Mon_Extranjera,DCO.Monto_Mon_Extranjera*-1) Monto_Mon_Extranjera
     FROM COMISIONES COM, DETALLE_COMISION DCO, AGENTES AGE
    WHERE DCO.CodConcepto IN ('IVASIN','RETISR', 'RETIVA')
      AND COM.CodCia     = DCO.CodCia 
      AND COM.IdComision = DCO.IdComision
      AND AGE.Cod_Agente = COM.Cod_Agente
      AND COM.idpoliza   = P_IdPoliza
      AND COM.IdFactura  = p_IdFactura;

CURSOR NC_Q IS
   SELECT P.IdPoliza, P.NumPolUnico, P.NumPolRef, DP.CodFilial, OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||
          OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
          N.IdEndoso, N.IdNcr, T.FechaTransaccion, N.FecDevol, N.CodMoneda,
          DP.IdTipoSeg, DP.PlanCob, PC.CodTipoPlan, DP.CodPlanPago,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
          P.CodCliente, P.FecIniVig, P.FecFinVig, P.NumRenov, P.CodCia, N.MtoComisi_Moneda,
          --DECODE(cStsNcr,'APL',N.MtoComisi_Moneda, N.MtoComisi_Moneda*-1) MtoComisi_Moneda,
          1 NumCuota, P.CodEmpresa, N.FecDevol FecAnul, T.IdTransaccion, N.FolioFactElec, N.StsNcr
     FROM NOTAS_DE_CREDITO N, TRANSACCION T, POLIZAS P, DETALLE_POLIZA DP, PLAN_COBERTURAS PC
    WHERE PC.PlanCob                 = DP.PlanCob
      AND PC.IdTipoSeg               = DP.IdTipoSeg
      AND PC.CodEmpresa              = DP.CodEmpresa
      AND PC.CodCia                  = DP.CodCia
      AND DP.CodCia                  = N.CodCia
      AND DP.IDetPol                 = N.IDetPol
      AND DP.IdPoliza                = N.IdPoliza
      AND ((DP.IdTipoSeg             = cIdTipoSeg AND cIdTipoSeg != '%')
       OR  (DP.IdTipoSeg          LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
      AND ((DP.PlanCob               = cPlanCob AND cPlanCob != '%')
       OR  (DP.PlanCob            LIKE cPlanCob AND cPlanCob = '%'))
      AND ((N.CodMoneda              = cCodMoneda AND cCodMoneda != '%')
       OR  (N.CodMoneda           LIKE cCodMoneda AND cCodMoneda = '%'))
      AND ((N.Cod_Agente             = cCodAgente AND cCodAgente != '%')
       OR  (N.Cod_Agente          LIKE cCodAgente AND cCodAgente = '%'))
      AND P.CodCia                   = N.CodCia
      AND P.IdPoliza                 = N.IdPoliza
      AND (T.IdTransaccion            = N.IdTransacAplic
       OR T.IdTransaccion            = N.IdTransacRevAplic)
      --AND T.IdProceso               IN (2, 8, 19, 17)   -- Anulaciones y Endoso
      AND TRUNC(T.FechaTransaccion) >= dFecDesde
      AND TRUNC(T.FechaTransaccion) <= dFecHasta
    ORDER BY N.IdNcr;
CURSOR DET_NC_Q IS
   SELECT D.CodCpto, D.Monto_Det_Moneda*-1 Monto_Det_Moneda, D.IndCptoPrima, C.IndCptoServicio
          --DECODE(cStsNcr,'APL',D.Monto_Det_Moneda*-1, D.Monto_Det_Moneda) Monto_Det_Moneda, D.IndCptoPrima, C.IndCptoServicio
     FROM DETALLE_NOTAS_DE_CREDITO D, NOTAS_DE_CREDITO N, CATALOGO_DE_CONCEPTOS C
    WHERE C.CodConcepto = D.CodCpto
      AND C.CodCia      = N.CodCia
      AND D.IdNcr       = N.IdNcr
      AND N.IdNcr       = nIdNcr;

CURSOR DET_ConC_NCR (nIdPoliza NUMBER, nIdNcr NUMBER) IS
   SELECT DCO.CodConcepto, AGE.CodTipo, AGE.CodNiVel, COM.Cod_Agente, DCO.Monto_Mon_Extranjera
          --DECODE(cStsNcr,'APL',DCO.Monto_Mon_Extranjera,DCO.Monto_Mon_Extranjera*-1) Monto_Mon_Extranjera,
     FROM COMISIONES COM, DETALLE_COMISION DCO, AGENTES AGE
    WHERE DCO.CodConcepto IN ('IVASIN','RETISR', 'RETIVA')
      AND COM.CodCia     = DCO.CodCia 
      AND COM.IdComision = DCO.IdComision
      AND AGE.Cod_Agente = COM.Cod_Agente
      AND COM.IdPoliza   = nIdPoliza
      AND COM.IdNcr      = nIdNcr;
      
CURSOR DET_Comision_Q (nIdPoliz NUMBER, nIdFactur Number ) IS
  	SELECT CodNivel   Tipo
          ,Porc_Com_Proporcional  Comision
          ,C.Comision_Moneda      Monto 
          ,C.Estado               Estatus_Com
          ,C.Cod_Agente	    
          ,Porc_Com_Distribuida   Comision_Distr
	   FROM COMISIONES              C
	        ,AGENTES_DISTRIBUCION_POLIZA ADP       
	  WHERE C.IDPOLIZA     = ADP.IDPOLIZA
	    AND C.COD_AGENTE   = ADP.COD_AGENTE_DISTR
	    AND ADP.IDPOLIZA   = nIdPoliz 
	    AND C.IdFactura    = nIdFactur;  	    
  
CURSOR DET_Comision_NTC (nIdPolza NUMBER) IS
 SELECT   CodNivel   Tipo
          ,Porc_Com_Proporcional  Comision
          ,C.Comision_Moneda      Monto 
          ,C.Estado               Estatus_Com 
          ,C.Cod_Agente	    
          ,Porc_Com_Distribuida   Comision_Distr
	   FROM COMISIONES              C
	        ,AGENTES_DISTRIBUCION_POLIZA ADP  
          , NOTAS_DE_CREDITO N
	  WHERE C.IDPOLIZA     = ADP.IDPOLIZA
	    AND C.COD_AGENTE   = ADP.COD_AGENTE_DISTR
      AND C.IdNcr        = N.IdNcr
      AND ADP.IDPOLIZA   = nIdPolza ;
      

      
BEGIN 
  SELECT CODUSR
    INTO cCodUser
    FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte;

   IF CFormato = 'TEXTO' THEN
      nLinea := 1;
      cCadena     := OC_EMPRESAS.NOMBRE_COMPANIA(1) || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

      nLinea := nLinea + 1;
      cCadena     := 'REPORTE DE CONCILIACION DE COMISIONES PAGADAS DEL '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' || TO_CHAR(dFecHasta,'DD/MM/YYYY') || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

      nLinea := nLinea + 1;
      cCadena     := ' ' || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

      nLinea := nLinea + 1;
      cCadena     := 'No. de Póliza'||cLimitador||
                     'Consecutivo'||cLimitador||
                     'No. Referencia'||cLimitador||
                     'Sub-Grupo'||cLimitador||
                     'Contratante'||cLimitador||
                     'No. de Endoso'||cLimitador||
                     'Tipo Seguro'||cLimitador||
                     'No. Recibo'||cLimitador||
                     'Forma de Pago'||cLimitador||                                         
                     'Fecha Movimiento'||cLimitador||
                     'Estado'||cLimitador||
                     'Inicio Vig. Póliza'||cLimitador||
                     'Fin Vig. Póliza'||cLimitador||                     
                     'Prima Neta'||cLimitador||
                     'Agente'||cLimitador||
                     'Tipo Agente'||cLimitador||
                     '%Comision Agente'||cLimitador||
                     'Monto Agente'||cLimitador||
                     'Estatus Agente'||cLimitador||
                     'Promotor'||cLimitador||
                     'Tipo Promotor'||cLimitador||
                     '%Comision Promotor'||cLimitador||
                     'Monto Promotor'||cLimitador||
                     'Estatus Promotor'||cLimitador||
                     'Regional'||cLimitador||
                     'Tipo Regional'||cLimitador||
                     '%Comision Regional'||cLimitador||
                     'Monto Regional'||cLimitador||
                     'Estatus Regional'||cLimitador||
                     'Honorarios'||cLimitador||
                     'Tipo Honorario'||cLimitador||
                     '%Comision Honorario'||cLimitador||
                     'Monto Honorario'||cLimitador||
                     'Estatus Honorario'||cLimitador||
                     'UDIS'||cLimitador||
                     'Tipo UDIS'||cLimitador||
                     '%Comision UDIS'||cLimitador||
                     'Monto UDIS'||cLimitador||
                     'Estatus UDIS'||cLimitador||
                     'Comision Total'||cLimitador||                     
                     'IVA Agente'||cLimitador||
                     'RET IVA Agente'||cLimitador||
                     'RET ISR Agente'||cLimitador||
                     'IVA Promotor'||cLimitador||
                     'RET IVA Promotor'||cLimitador||
                     'RET ISR Promotor'||cLimitador||
                     'IVA Regional'||cLimitador||
                     'RET IVA Regional'||cLimitador||
                     'RET ISR Regional'||cLimitador||
                     'IVA Honorarios'||cLimitador||
                     'RET IVA Honorarios'||cLimitador||
                     'RET ISR Honorarios'||cLimitador||
                     'IVA UDIS'||cLimitador||
                     'RET IVA UDIS'||cLimitador||
                     'RET ISR UDIS'||cLimitador||  
                     'Plan Coberturas'||cLimitador||                   
                     'Código SubRamo'||cLimitador||
                     'Descripción SubRamo'||cLimitador||
                     'No. Cuota'||cLimitador||
                     'No. Comprobante'||cLimitador||
                     'Folio Fact. Electrónica'||cLimitador||CHR(13); 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      cPaso := 'cadena txt';
   ELSE
      nLinea := 1;
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
                       '          {mso-number-format:"dd\\-mmm\\-yyyy";}'||chr(10)||
                       '    -->'||chr(10)||
                       ' </style><div id="libro">'||chr(10);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      cPaso := 'cadena xls ini';
       
      nLinea := nLinea + 1;
      cCadena     := '<table border = 0><tr><th>' || OC_EMPRESAS.NOMBRE_COMPANIA(1) || '</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      cPaso := 'cadena xls ini 2.';
      nLinea := nLinea + 1;
      cCadena     := '<tr><th>REPORTE DE CONCIL DE COMISIONES PAGADAS DEL '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' ||
                      TO_CHAR(dFecHasta,'DD/MM/YYYY') || '</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      
      cPaso := 'cadena xls ini 3.';
      nLinea := nLinea + 1;
      cCadena     := '<tr><th>  </th></tr></table>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      nLinea := nLinea + 1;
      cPaso := 'cadena xls ini 4.';
      cCadena := '';      
      cCadena     := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Póliza</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Consecutivo</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Referencia</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Sub-Grupo</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Contratante</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Endoso</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Seguro</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Recibo</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Forma de Pago</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Movimiento</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estado</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Inicio Vig. Póliza</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fin Vig. Póliza</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Prima Neta</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Agente</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Agente</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">%Comis. Agente</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto Agente</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estatus Agente</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Promotor</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Promotor</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">%Comis. Promotor</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto Promotor</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estatus Promotor</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Regional</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Regional</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">%Comis. Regional</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto Regional</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estatus Regional</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Honorario</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Honorario</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">%Comis. Honorario</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto Honorario</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estatus Honorario</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">UDIS</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo UDIS</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">%Comis. UDIS</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto UDIS</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estatus UDIS</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comisión Total</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IVA Agente</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RET IVA Agente</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RET ISR Agente</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IVA Promotor</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RET IVA Promotor</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RET ISR Promotor</font></th>';
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
                     
      cCadena     := '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IVA Regional</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RET IVA Regional</font></th>'||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RET ISR Regional</font></th>'||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IVA Honorario</font></th>'||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RET IVA Honorar</font></th>'||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RET ISR Honorar</font></th>'||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IVA UDIS</font></th>'||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RET IVA UDIS</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RET ISR UDIS</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Plan Coberturas</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código SubRamo</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descrip. SubRamo</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No.Cuota</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No.Comprobante</font></th>'||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Folio Fact. Electrónica</font></th></tr>';
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END IF;
   cPaso := 'cadena xls fin';
   
   FOR X IN PAG_Q LOOP
   	  cPaso  := 'PAG_Q Entra' ;
   	  cTipoTran       := X.TipoTran;
   	  nIdFactura      := X.IdRecibo;
   	  cCodGenerador   := OC_AGENTE_POLIZA.AGENTE_PRINCIPAL(X.CodCia, X.IdPoliza);
      cDescFormaPago  := OC_FACTURAS.FRECUENCIA_PAGO(X.CodCia, X.IdRecibo);
      dFecFin         := NULL; --OC_FACTURAS.VIGENCIA_FINAL(X.CodCia, nIdFactura);      
      
      BEGIN
         SELECT OC_PROVINCIA.NOMBRE_PROVINCIA(P.CodPaisRes, P.CodProvRes)
           INTO cDescEstado
           FROM CLIENTES C, PERSONA_NATURAL_JURIDICA P
          WHERE P.Tipo_Doc_Identificacion = C.Tipo_Doc_Identificacion
            AND P.Num_Doc_Identificacion  = C.Num_Doc_Identificacion
            AND C.CodCliente              = X.CodCliente;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cDescEstado := NULL;
      END;
      IF cDescEstado = 'PROVINCIA NO EXISTE' THEN
      	 cDescEstado := NULL;
      END IF; 

      nPrimaNeta       := 0;     
      nCodRg           := 0;
      nCodNivelRg      := 0;
			nPorcComisRg	   := 0;
			nMontoComisRg    := 0;			
			cEstatusComisRg  := '';
			nCodPrm          := 0;
			nCodNivelPrm     := 0;
			nPorcComisPrm	   := 0;
			nMontoComisPrm   := 0;			
			cEstatusComisPrm := '';
			nCodAg           := 0;
			nCodNivelAg      := 0;
			nPorcComisAg	   := 0;
			nMontoComisAg    := 0;
			cEstatusComisAg  := '';
			nCodHn           := 0;
			nCodNivelHn      := 0;
			nPorcComisHn	   := 0;
			nMontoComisHn    := 0;
			cEstatusComisHn  := '';
			nCodUd           := 0;
			nCodNivelUd      := 0;
			nPorcComisUd	   := 0;
			nMontoComisUd    := 0;
			cEstatusComisUd  := '';
			nIvaRg           := 0;
			nIvaPrm          := 0;
			nIvaAg           := 0;
			nIvaHn           := 0;
			nIvaUd           := 0;
			nRetIvaRg        := 0;
			nRetIvaPrm       := 0;
			nRetIvaAg        := 0;
			nRetIvaHn        := 0;
			nRetIvaUd        := 0;
			nRetIsrRg        := 0;
			nRetIsrPrm       := 0;
			nRetIsrAg        := 0;
			nRetIsrHn        := 0;
			nRetIsrUd        := 0;
			
			
      FOR W IN DET_Q LOOP
         IF W.IndCptoPrima = 'S' OR W.IndCptoServicio = 'S' THEN
         	  cPaso  := 'DET_Q Entra' ;
            nPrimaNeta  := NVL(nPrimaNeta,0) + NVL(W.Monto_Det_Moneda,0);          
         END IF;         
      END LOOP;      
		
      FOR C IN DET_ConC (X.IdPoliza, X.IdRecibo) LOOP
         cPaso  := 'DET_ConC entra'||C.CODNIVEL;      	
         IF C.CODNIVEL = 1 THEN -- REGIONAL
         	  cPaso  := 'DET_ConC CODNIVEL = 1' ;
            IF C.CodConcepto = 'IVASIN' THEN
               nIvaRg         := NVL(nIvaRg,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'RETIVA' THEN
            	 nRetIvaRg      := NVL(nRetIvaRg,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'RETISR' THEN
            	 nRetIsrRg      := NVL(nRetIsrRg,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF;            
         ELSIF C.CODNIVEL = 2 THEN -- PROMOTOR
            cPaso  := 'DET_ConC CODNIVEL = 2' ;   	
            IF C.CodConcepto = 'IVASIN' THEN
               nIvaPrm         := NVL(nIvaPrm,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'RETIVA' THEN
            	 nRetIvaPrm      := NVL(nRetIvaPrm,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'RETISR' THEN
            	 nRetIsrPrm      := NVL(nRetIsrPrm,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF;            
         ELSIF C.CODNIVEL = 3 THEN -- AGENTE 
            cPaso  := 'DET_ConC CODNIVEL = 3' ;
            IF C.CodConcepto = 'IVASIN' THEN
               nIvaAg         := NVL(nIvaAg,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'RETIVA' THEN
            	 nRetIvaAg      := NVL(nRetIvaAg,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'RETISR' THEN
            	 nRetIsrAg      := NVL(nRetIsrAg,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF;			
         ELSIF C.CODNIVEL = 4 THEN -- HONORARIOS  
            cPaso  := 'DET_ConC CODNIVEL = 4' ;
            IF C.CodConcepto = 'IVASIN' THEN
               nIvaHn         := NVL(nIvaHn,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'RETIVA' THEN
            	 nRetIvaHn      := NVL(nRetIvaHn,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'RETISR' THEN
            	 nRetIsrHn      := NVL(nRetIsrHn,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF; 	
         ELSIF C.CodNIVEL = 5 THEN -- UDIS  
            cPaso  := 'DET_ConC CODNIVEL = 5' ;
            IF C.CodConcepto = 'IVASIN' THEN
               nIvaUd         := NVL(nIvaUd,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'RETIVA' THEN
            	 nRetIvaUd      := NVL(nRetIvaUd,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'RETISR' THEN
            	 nRetIsrUd      := NVL(nRetIsrUd,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF;         	
         END IF;	         
      END LOOP;      

      SELECT NVL(MIN(NumComprob),'0')
        INTO cNumComprob
        FROM COMPROBANTES_CONTABLES
       WHERE NumTransaccion = X.IdTransaccion;
    
	    -- Detalle de las Comisiones %,Montos
	    FOR DC IN DET_Comision_Q(X.IdPoliza,X.IdRecibo) LOOP
	    	  cPaso  := 'DET_Comision_Q entra' ;      	
          IF DC.Tipo = 1 THEN 
         	 nCodRg          := dc.Cod_Agente;          
         	 nCodNivelRg     := DC.Tipo;           
           nPorcComisRg	   := DC.Comision_Distr;
         	 nMontoComisRg   := DC.Monto;
         	 cEstatusComisRg := DC.Estatus_com;
         ELSIF DC.Tipo = 2 THEN
           nCodPrm         := dc.Cod_Agente;          
         	 nCodNivelPrm    := DC.Tipo;           
           nPorcComisPrm	 := DC.Comision_Distr;
         	 nMontoComisPrm  := DC.Monto;
         	 cEstatusComisPrm:= DC.Estatus_com;
         ELSIF DC.Tipo = 3 THEN
         	 nCodAg          := dc.Cod_Agente;  
           nCodNivelAg     := DC.Tipo ;
         	 nPorcComisAg	   := DC.Comision_Distr;
         	 nMontoComisAg   := DC.Monto;
         	 cEstatusComisAg := DC.Estatus_com;
         ELSIF DC.Tipo = 4 THEN
         	 nCodHn          := dc.Cod_Agente;  
         	 nCodNivelHn     := DC.Tipo;           
           nPorcComisHn	   := DC.Comision_Distr;
         	 nMontoComisHn   := DC.Monto;
         	 cEstatusComisHn := DC.Estatus_com;
         ELSIF DC.Tipo = 5 THEN
           nCodUd          := dc.Cod_Agente;  
         	 nCodNivelUd     := DC.Tipo;           
           nPorcComisUd	   := DC.Comision_Distr;
         	 nMontoComisUd   := DC.Monto;
         	 cEstatusComisUd := DC.Estatus_com;
         END IF;
	    END LOOP;


      IF CFormato = 'TEXTO' THEN
      	 cPaso  := '1 TEXTO entra' ;      	
         cCadena := X.NumPolUnico                                  ||cLimitador||
                    TO_CHAR(X.IdPoliza,'9999999999999')            ||cLimitador||
                    X.NumPolRef                                    ||cLimitador||
                    X.CodFilial                                    ||cLimitador||
                    X.Contratante                                  ||cLimitador||
                    TO_CHAR(X.IdEndoso,'9999999999999')            ||cLimitador||
                    X.IdTipoSeg                                    ||cLimitador||
                    TO_CHAR(X.IdRecibo,'9999999999990')            ||cLimitador||                    
                    cDescFormaPago                                 ||cLimitador||
                    TO_CHAR(X.FechaTransaccion,'DD/MM/YYYY')       ||cLimitador||
                    cDescEstado                                    ||cLimitador||
                    TO_CHAR(X.FecIniVig,'DD/MM/RRRR')              ||cLimitador||
                    TO_CHAR(X.FecFinVig,'DD/MM/RRRR')              ||cLimitador||
                    TO_CHAR(nPrimaNeta,'99999999999990.00')        ||cLimitador||
                    cCodGenerador                                  ||cLimitador||                                        
                    TO_CHAR(nCodNivelAg,'99999999999990.00')       ||cLimitador||
                    TO_CHAR(nPorcComisAg,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMontoComisAg,'99999999999990.00')     ||cLimitador||
                    cEstatusComisAg                                ||cLimitador||
                    nCodPrm                                        ||cLimitador||
                    TO_CHAR(nCodNivelPrm,'99999999999990.00')      ||cLimitador||                
                    TO_CHAR(nPorcComisPrm,'99999999999990.00')     ||cLimitador||
                    TO_CHAR(nMontoComisPrm,'99999999999990.00')    ||cLimitador||
                    cEstatusComisPrm                               ||cLimitador||
                    nCodRg                                         ||cLimitador||                    
                    TO_CHAR(nCodNivelRg,'99999999999990.00')       ||cLimitador||
                    TO_CHAR(nPorcComisRg,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMontoComisRg,'99999999999990.00')     ||cLimitador||
                    cEstatusComisRg                                ||cLimitador||
                    nCodHn                                         ||cLimitador||
                    TO_CHAR(nCodNivelHn,'99999999999990.00')       ||cLimitador||
                    TO_CHAR(nPorcComisHn,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMontoComisHn,'99999999999990.00')     ||cLimitador||                   
                    cEstatusComisHn                                ||cLimitador||                                        
                    nCodUd                                         ||cLimitador||
                    TO_CHAR(nCodNivelUd,'99999999999990.00')       ||cLimitador||
                    TO_CHAR(nPorcComisUd,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMontoComisUd,'99999999999990.00')     ||cLimitador||                  
                    cEstatusComisUd                                ||cLimitador||
                    TO_CHAR(X.MtoComisi_Moneda,'99999999999990.00')||cLimitador||
                    TO_CHAR(nIvaAg,'99999999999990.00')            ||cLimitador||
                    TO_CHAR(nRetIvaAg,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nRetIsrAg,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nIvaPrm,'99999999999990.00')           ||cLimitador||
                    TO_CHAR(nRetIvaPrm,'99999999999990.00')        ||cLimitador||
                    TO_CHAR(nRetIsrPrm,'99999999999990.00')        ||cLimitador||
                    TO_CHAR(nIvaRg,'99999999999990.00')            ||cLimitador||
                    TO_CHAR(nRetIvaRg,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nRetIsrRg,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nIvaHn,'99999999999990.00')            ||cLimitador||
                    TO_CHAR(nRetIvaHn,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nRetIsrHn,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nIvaUd,'99999999999990.00')            ||cLimitador||
                    TO_CHAR(nRetIvaUd,'99999999999990.00')         ||cLimitador||                                        
                    TO_CHAR(nRetIsrUd,'99999999999990.00')         ||cLimitador||
                    X.PlanCob                                      ||cLimitador||
                    X.CodTipoPlan                                  ||cLimitador||
                    X.DescSubRamo                                  ||cLimitador||
                    TO_CHAR(X.NumCuota,'99990')                    ||cLimitador||
                    cNumComprob                                    ||cLimitador||
                    X.FolioFactElec                                ||CHR(13);
                    
      ELSE
      	 cPaso  := '1 TEXTO entra' ;
         cCadena := '<tr>' || OC_ARCHIVO.CAMPO_HTML(X.NumPolUnico,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdPoliza,'9999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.NumPolRef,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.CodFilial,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.Contratante,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdEndoso,'9999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.IdTipoSeg,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdRecibo,'9999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(cDescFormaPago,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.FechaTransaccion,'D') ||
                    OC_ARCHIVO.CAMPO_HTML(cDescEstado,'C') ||     
                    OC_ARCHIVO.CAMPO_HTML(X.FecIniVig,'D') ||
                    OC_ARCHIVO.CAMPO_HTML(X.FecFinVig,'D') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPrimaNeta,'99999999999990.00'),'N') ||                    
                    OC_ARCHIVO.CAMPO_HTML(cCodGenerador, 'C') ||                 
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelAg, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisAg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisAg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisAg, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(nCodPrm,'C') ||                     
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelPrm, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisPrm,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisPrm,'99999999999990.00'),'N') ||                    
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisPrm, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML( nCodRg, 'C') ||                     
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelRg,  'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisRg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisRg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisRg, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML( nCodHn,'C') ||     
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelHn, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisHn,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisHn,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisHn, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML( nCodUd, 'C') ||      
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelUd,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisUd,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisUd,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisUd, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MtoComisi_Moneda,'99999999999990.00'),'N') ||                    
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nIvaAg,'99999999999990.00'),'N') ||                    
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nRetIvaAg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nRetIsrAg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nIvaPrm,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nRetIvaPrm,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nRetIsrPrm,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nIvaRg,'99999999999990.00'),'N')||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nRetIvaRg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nRetIsrRg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nIvaHn,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nRetIvaHn,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nRetIsrHn,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nIvaUd,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nRetIvaUd,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nRetIsrUd,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(X.PlanCob,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.CodTipoPlan,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.DescSubRamo,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.NumCuota,'99990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(cNumComprob,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.FolioFactElec,'C') || '</tr>';                   
      END IF;
      
      nLinea := nLinea + 1;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END LOOP;
   
   FOR X IN NC_Q LOOP
      cPaso  := 'NC_Q entra' ;
   	  nIdNcr          := X.IdNcr;
   	  --cStsNcr         := X.StsNcr;
   	  cCodGenerador   := OC_AGENTE_POLIZA.AGENTE_PRINCIPAL(X.CodCia, X.IdPoliza);
      cDescFormaPago  := 'DIRECTO';
      dFecFin         := NULL; --OC_NOTAS_DE_CREDITO.VIGENCIA_FINAL(X.CodCia, X.IdNcr);

      BEGIN
         SELECT OC_PROVINCIA.NOMBRE_PROVINCIA(P.CodPaisRes, P.CodProvRes)
           INTO cDescEstado
           FROM CLIENTES C, PERSONA_NATURAL_JURIDICA P
          WHERE P.Tipo_Doc_Identificacion = C.Tipo_Doc_Identificacion
            AND P.Num_Doc_Identificacion  = C.Num_Doc_Identificacion
            AND C.CodCliente              = X.CodCliente;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cDescEstado := NULL;
      END;
      IF cDescEstado = 'PROVINCIA NO EXISTE' THEN
      	 cDescEstado := NULL;
      END IF;
 

      nPrimaNeta      := 0;
       
      nCodRg           := 0;
      nCodNivelRg      := 0;
			nPorcComisRg	   := 0;
			nMontoComisRg    := 0;			
			cEstatusComisRg  := '';
			nCodPrm          := 0;
			nCodNivelPrm     := 0;
			nPorcComisPrm	   := 0;
			nMontoComisPrm   := 0;			
			cEstatusComisPrm := '';
			nCodAg           := 0;
			nCodNivelAg      := 0;
			nPorcComisAg	   := 0;
			nMontoComisAg    := 0;
			cEstatusComisAg  := '';
			nCodHn           := 0;
			nCodNivelHn      := 0;
			nPorcComisHn	   := 0;
			nMontoComisHn    := 0;
			cEstatusComisHn  := '';
			nCodUd           := 0;
			nCodNivelUd      := 0;
			nPorcComisUd	   := 0;
			nMontoComisUd    := 0;
			cEstatusComisUd  := '';
			nIvaRg           := 0;
			nIvaPrm          := 0;
			nIvaAg           := 0;
			nIvaHn           := 0;
			nIvaUd           := 0;
			nRetIvaRg        := 0;
			nRetIvaPrm       := 0;
			nRetIvaAg        := 0;
			nRetIvaHn        := 0;
			nRetIvaUd        := 0;
			nRetIsrRg        := 0;
			nRetIsrPrm       := 0;
			nRetIsrAg        := 0;
			nRetIsrHn        := 0;
			nRetIsrUd        := 0;
			

      FOR W IN DET_NC_Q LOOP
      	 cPaso  := 'DET_NC_Q entra' ;
         IF W.IndCptoPrima = 'S' OR W.IndCptoServicio = 'S' THEN
            nPrimaNeta  := NVL(nPrimaNeta,0) + NVL(W.Monto_Det_Moneda,0);         
         END IF; 
      END LOOP;
      
      FOR C IN DET_ConC_NCR (X.IdPoliza, X.IdNcr) LOOP
         cPaso  := 'DET_ConC_NCR entra' ;
         IF C.CODNIVEL = 1 THEN -- REGIONAL
            IF C.CodConcepto = 'IVASIN' THEN
               nIvaRg         := NVL(nIvaRg,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'RETIVA' THEN
            	 nRetIvaRg      := NVL(nRetIvaRg,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'RETISR' THEN
            	 nRetIsrRg      := NVL(nRetIsrRg,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF;            
         ELSIF C.CODNIVEL = 2 THEN -- PROMOTOR
            IF C.CodConcepto = 'IVASIN' THEN
               nIvaPrm         := NVL(nIvaPrm,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'RETIVA' THEN
            	 nRetIvaPrm      := NVL(nRetIvaPrm,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'RETISR' THEN
            	 nRetIsrPrm      := NVL(nRetIsrPrm,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF;            
         ELSIF C.CODNIVEL = 3 THEN -- AGENTE 
            IF C.CodConcepto = 'IVASIN' THEN
               nIvaAg         := NVL(nIvaAg,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'RETIVA' THEN
            	 nRetIvaAg      := NVL(nRetIvaAg,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'RETISR' THEN
            	 nRetIsrAg      := NVL(nRetIsrAg,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF;			
         ELSIF C.CODNIVEL = 4 THEN -- HONORARIOS  
            IF C.CodConcepto = 'IVASIN' THEN
               nIvaHn         := NVL(nIvaHn,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'RETIVA' THEN
            	 nRetIvaHn      := NVL(nRetIvaHn,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'RETISR' THEN
            	 nRetIsrHn      := NVL(nRetIsrHn,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF; 	
         ELSIF C.CodNIVEL = 5 THEN -- UDIS  
            IF C.CodConcepto = 'IVASIN' THEN
               nIvaUd         := NVL(nIvaUd,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'RETIVA' THEN
            	 nRetIvaUd      := NVL(nRetIvaUd,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSIF C.CodConcepto = 'RETISR' THEN
            	 nRetIsrUd      := NVL(nRetIsrUd,0) + NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               NULL;
            END IF;
             
         END IF;
         -- nTotComisDist   := NVL(nTotComisDist,0) + NVL(C.Monto_Mon_Extranjera,0);
      END LOOP;
      -- nDifComis := NVL(X.MtoComisi_Moneda,0) - NVL(nTotComisDist,0);

      SELECT NVL(MIN(NumComprob),'0')
        INTO cNumComprob
        FROM COMPROBANTES_CONTABLES
       WHERE NumTransaccion = X.IdTransaccion;


      -- Detalle de las Comisiones %,Montos
	    FOR DC IN DET_Comision_NTC(X.IdPoliza) LOOP 
	       cPaso  := 'DET_Comision_NTC entra' ;	 
         IF DC.Tipo = 1 THEN 
         	 nCodRg          := dc.Cod_Agente;          
         	 nCodNivelRg     := DC.Tipo;           
           nPorcComisRg	   := DC.Comision_Distr;
         	 nMontoComisRg   := DC.Monto;
         	 cEstatusComisRg := DC.Estatus_com;
         ELSIF DC.Tipo = 2 THEN
           nCodPrm         := dc.Cod_Agente;          
         	 nCodNivelPrm    := DC.Tipo;           
           nPorcComisPrm	 := DC.Comision_Distr;
         	 nMontoComisPrm  := DC.Monto;
         	 cEstatusComisPrm:= DC.Estatus_com;
         ELSIF DC.Tipo = 3 THEN
         	 nCodAg          := dc.Cod_Agente;  
           nCodNivelAg     := DC.Tipo ;
         	 nPorcComisAg	   := DC.Comision_Distr;
         	 nMontoComisAg   := DC.Monto;
         	 cEstatusComisAg := DC.Estatus_com;
         ELSIF DC.Tipo = 4 THEN
         	 nCodHn          := dc.Cod_Agente;  
         	 nCodNivelHn     := DC.Tipo;
           nPorcComisHn	   := DC.Comision_Distr;
         	 nMontoComisHn   := DC.Monto;
         	 cEstatusComisHn := DC.Estatus_com;
         ELSIF DC.Tipo = 5 THEN
           nCodUd          := dc.Cod_Agente;  
         	 nCodNivelUd     := DC.Tipo;
           nPorcComisUd	   := DC.Comision_Distr;
         	 nMontoComisUd   := DC.Monto;
         	 cEstatusComisUd := DC.Estatus_com;
         END IF;
	    END LOOP;


      IF CFormato = 'TEXTO' THEN
         cPaso  := '2 TEXTO entra' ;	 
         cCadena := X.NumPolUnico                                  ||cLimitador||
                    TO_CHAR(X.IdPoliza,'9999999999999')            ||cLimitador||
                    X.NumPolRef                                    ||cLimitador||
                    X.CodFilial                                    ||cLimitador||
                    X.Contratante                                  ||cLimitador||
                    TO_CHAR(X.IdEndoso,'9999999999999')            ||cLimitador||
                    X.IdTipoSeg                                    ||cLimitador||
                    'NC-' || TO_CHAR(X.IdNcr,'9999999999990')      ||cLimitador||
                    cDescFormaPago                                 ||cLimitador||
                    TO_CHAR(X.FechaTransaccion,'DD/MM/YYYY')       ||cLimitador||
                    cDescEstado                                    ||cLimitador||
                    TO_CHAR(X.FecIniVig,'DD/MM/RRRR')              ||cLimitador||
                    TO_CHAR(X.FecFinVig,'DD/MM/RRRR')              ||cLimitador||
                    TO_CHAR(nPrimaNeta,'99999999999990.00')        ||cLimitador||
                    cCodGenerador                                  ||cLimitador||                   
                    TO_CHAR(nCodNivelAg)                           ||cLimitador||
                    TO_CHAR(nPorcComisAg,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMontoComisAg,'99999999999990.00')     ||cLimitador||
                    cEstatusComisAg                                ||cLimitador||
                    TO_CHAR(nCodPrm)                               ||cLimitador||  
                    TO_CHAR(nCodNivelPrm,'99999999999990.00')      ||cLimitador||                
                    TO_CHAR(nPorcComisPrm,'99999999999990.00')     ||cLimitador||
                    TO_CHAR(nMontoComisPrm,'99999999999990.00')    ||cLimitador||
                    cEstatusComisPrm                               ||cLimitador||
                    TO_CHAR(nCodRg)                                ||cLimitador||
                    TO_CHAR(nCodNivelRg)                           ||cLimitador||
                    TO_CHAR(nPorcComisRg,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMontoComisRg,'99999999999990.00')     ||cLimitador||
                    cEstatusComisRg                                ||cLimitador||
                    TO_CHAR(nCodHn)                                ||cLimitador||
                    TO_CHAR(nCodNivelHn)                           ||cLimitador||
                    TO_CHAR(nPorcComisHn,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMontoComisHn,'99999999999990.00')     ||cLimitador||                   
                    cEstatusComisHn                                ||cLimitador||
                    TO_CHAR(nCodUd)                                ||cLimitador|| 
                    TO_CHAR(nCodNivelUd)                           ||cLimitador||
                    TO_CHAR(nPorcComisUd,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMontoComisUd,'99999999999990.00')     ||cLimitador||
                    cEstatusComisUd                                ||cLimitador||
                    TO_CHAR(X.MtoComisi_Moneda,'99999999999990.00')||cLimitador||                    
                    TO_CHAR(nIvaAg,'99999999999990.00')            ||cLimitador||
                    TO_CHAR(nRetIvaAg,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nRetIsrAg,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nIvaPrm,'99999999999990.00')           ||cLimitador||
                    TO_CHAR(nRetIvaPrm,'99999999999990.00')        ||cLimitador||
                    TO_CHAR(nRetIsrPrm,'99999999999990.00')        ||cLimitador||
                    TO_CHAR(nIvaRg,'99999999999990.00')            ||cLimitador||
                    TO_CHAR(nRetIvaRg,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nRetIsrRg,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nIvaHn,'99999999999990.00')            ||cLimitador||
                    TO_CHAR(nRetIvaHn,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nRetIsrHn,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nIvaUd,'99999999999990.00')            ||cLimitador||
                    TO_CHAR(nRetIvaUd,'99999999999990.00')         ||cLimitador||                                        
                    TO_CHAR(nRetIsrUd,'99999999999990.00')         ||cLimitador||
                    X.PlanCob                                      ||cLimitador||
                    X.CodTipoPlan                                  ||cLimitador||
                    X.DescSubRamo                                  ||cLimitador||
                    TO_CHAR(X.NumCuota,'99990')                    ||cLimitador||
                    cNumComprob                                    ||cLimitador||
                    X.FolioFactElec                                ||CHR(13);
                    
                    
                   
      ELSE
      	 cPaso  := '2 EXCEL entra' ;	 
         cCadena := '<tr>' || OC_ARCHIVO.CAMPO_HTML(X.NumPolUnico,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdPoliza,'9999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.NumPolRef,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.CodFilial,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.Contratante,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdEndoso,'9999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.IdTipoSeg,'C') ||
                    OC_ARCHIVO.CAMPO_HTML('NC-' || TO_CHAR(X.IdNcr,'9999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(cDescFormaPago,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.FechaTransaccion,'D') ||
                    OC_ARCHIVO.CAMPO_HTML(cDescEstado,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.FecIniVig,'D') ||
                    OC_ARCHIVO.CAMPO_HTML(X.FecFinVig,'D') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPrimaNeta,'99999999999990.00'),'N') ||                   
                    OC_ARCHIVO.CAMPO_HTML( cCodGenerador, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelAg, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisAg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisAg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisAg, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML( nCodPrm, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelPrm, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisPrm,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisPrm,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisPrm, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML( nCodRg ,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelRg, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisRg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisRg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisRg, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML( nCodHn, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelHn, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisHn,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisHn,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisHn, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML( nCodUd, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(nCodNivelUd, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nPorcComisUd,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMontoComisUd,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(cEstatusComisUd, 'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MtoComisi_Moneda,'99999999999990.00'),'N') ||                                       
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nIvaAg,'99999999999990.00'),'N') ||                    
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nRetIvaAg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nRetIsrAg,'99999999999990.00'),'N') ||                    
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nIvaPrm,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nRetIvaPrm,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nRetIsrPrm,'99999999999990.00'),'N') ||                    
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nIvaRg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nRetIvaRg,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nRetIsrRg,'99999999999990.00'),'N') ||                    
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nIvaHn,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nRetIvaHn,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nRetIsrHn,'99999999999990.00'),'N') || 
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nIvaUd,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nRetIvaUd,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nRetIsrUd,'99999999999990.00'),'N') || 
                    OC_ARCHIVO.CAMPO_HTML(X.PlanCob,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.CodTipoPlan,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.DescSubRamo,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.NumCuota,'99990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(cNumComprob,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.FolioFactElec,'C') || '</tr>';
                    
                   
                    
      END IF;
      nLinea := nLinea + 1;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END LOOP;
   IF CFormato = 'EXCEL' THEN
      OC_ARCHIVO.Escribir_Linea('</table></div></html>', ccodUSER, 9999);
   END IF;
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 

  INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
    SELECT nIdReporte + 1,
           B.TIPO_REPORTE,
           B.CODUSR,
           SYSDATE,
           'GEN',
           A.DATA,
           B.FILE_NAME
      FROM SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
     WHERE A.CODUSER = B.CODUSR
       AND B.IDEXTRACCION = nIdReporte;
  DELETE SICAS_OC.EXTRACCION_DE_REPORTES WHERE IDEXTRACCION = nIdReporte;
  OC_ARCHIVO.Eliminar_Archivo(cCodUser);
EXCEPTION 
   WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      RAISE_APPLICATION_ERROR(-20105,'Error en Generación de Conciliacion de Comisiones Pagados: '||cPaso||' - '||nIdFactura || ' :: ' ||SQLERRM); 
END;

PROCEDURE REPORTE_ERRORES_SINIESTRO(cNomArchivo VARCHAR2,cformato varchar2,nidreporte number,CTIPOPROCESO VARCHAR2) IS
cLimitador      VARCHAR2(1) :='|';
nLinea          NUMBER;
cCadena         VARCHAR2(4000);
cCodUser        VARCHAR2(30);
nDummy          NUMBER;
cCopy           BOOLEAN;

CURSOR EMI_Q IS 
   SELECT LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(P.REGDATOSPROC,1,',')) NumSiniestro,
          LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(P.REGDATOSPROC,6,',')) CodAsegurado,
          LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(P.REGDATOSPROC,7,','))||' '||
          LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(P.REGDATOSPROC,8,','))||' '||
          LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(P.REGDATOSPROC,9,',')) NombreAseg,
          L.TxtError, P.NumPolUnico, P.NumDetUnico, P.IdTipoSeg, P.PlanCob
     FROM PROCESOS_MASIVOS P, PROCESOS_MASIVOS_LOG L
    WHERE L.IdProcMasivo  = P.IdProcMasivo
      AND P.TipoProceso   = CTipoProceso
      AND P.StsRegProceso IN ('ERROR','ERREMI','ERRASE')
      AND P.CodUsuario    = cCodUser;
BEGIN 
  SELECT CODUSR
    INTO cCodUser
    FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte;
   nLinea := 1;
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
               '          {mso-number-format:"dd\\-mmm\\-yyyy";}'||chr(10)||
               '    -->'||chr(10)||
               ' </style><div id="libro">'||chr(10);
   OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

   nLinea := nLinea + 1;
   cCadena     := '<table border = 0><tr><th>THONA SEGUROS, S.A. de C.V.</th></tr>'; 
   OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

   nLinea := nLinea + 1;
   cCadena     := '<tr><th>REPORTE DEL PROCESO MASIVO '|| CTipoProceso  || '</th></tr>'; 
   OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

   nLinea := nLinea + 1;
   cCadena     := '<tr><th>  </th></tr></table>'; 
   OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

   nLinea := nLinea + 1;
   cCadena     := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Siniestro</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Póliza Unico</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Detalle/Sub-Grupo</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Producto</font></th>' || 
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Plan de Coberturas</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Asegurado</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Asegurado</font></th>' ||
                  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Log de Error</font></th>'; 
   OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

   FOR X IN EMI_Q LOOP
      cCadena := '<tr>' || OC_ARCHIVO.CAMPO_HTML(X.NumSiniestro,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.NumPolUnico,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.NumDetUnico,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.IdTipoSeg,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.PlanCob,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.CodAsegurado,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.NombreAseg,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.TxtError,'C') || '</tr>';
      nLinea := nLinea + 1;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END LOOP;
   OC_ARCHIVO.Escribir_Linea('</table></div></html>', ccodUSER, 9999);
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 

  INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
    SELECT nIdReporte + 1,
           B.TIPO_REPORTE,
           B.CODUSR,
           SYSDATE,
           'GEN',
           A.DATA,
           B.FILE_NAME
      FROM SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
     WHERE A.CODUSER = B.CODUSR
       AND B.IDEXTRACCION = nIdReporte;
  DELETE SICAS_OC.EXTRACCION_DE_REPORTES WHERE IDEXTRACCION = nIdReporte;
  OC_ARCHIVO.Eliminar_Archivo(cCodUser);


EXCEPTION 
   WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      RAISE_APPLICATION_ERROR(-20105,'Error en Generación de Registros de Siniestros Procesos Masivos con Error: ' || SQLERRM); 
END;


PROCEDURE PROC_LST_PROYECCION (nidreporte number,nIdCalculoProy number,nIdBonoVentas number,cCodDirRegional varchar2,cCodPromotor varchar2,cCodAgente varchar2) IS
	nDummy 		NUMBER;
	cCodUser 	USUARIOS.CodUsuario%TYPE;
	cCadena		VARCHAR2(4000);
	nLinea		NUMBER;
	dFecha		DATE;	
	cCopy     BOOLEAN;
	
	CURSOR PROY_Q IS
		SELECT CodCia, CodEmpresa, IdCalculoProy, IdBonoVentas, 
		       CodNivel, CodAgente, FecIniCalcBono, FecFincalcBono, 
		       ProdPrimaNeta, CantPolizas, MesesProd, CantAgentesProd, 
		       PorcenSiniest, PorcenBonoActual, MontoNivel1, 
		       PorcenNivel1, MontoNivel2, PorcenNivel2, MontoNivel3, 
		       PorcenNivel3, MontoNivel4, PorcenNivel4, MontoNivelsup, 
		       PorcenNivelsup, FecCalculoProy, CodUsuario,
		       GT_BONOS_AGENTES_CONFIG.DESCRIPCION_BONO(CodCia, CodEmpresa, IdBonoVentas) DescBono,
		       OC_AGENTES.NOMBRE_AGENTE(CodCia,CodAgente) NombreAgente,
       		 GT_BONOS_AGENTES_CONFIG.CODIGO_BONO(CodCia,CodEmpresa,IdBonoVentas) CodigoBono
		  FROM BONOS_AGENTES_PROYECCION
		 WHERE CodCia           = 1
		   AND CodEmpresa       = 1
		   AND IdCalculoProy    = nIdCalculoProy
		   AND IdBonoVentas     = nIdBonoVentas
		   AND CodAgente     LIKE cCodDirRegional
		 UNION 
		SELECT CodCia, CodEmpresa, IdCalculoProy, IdBonoVentas, 
		       CodNivel, CodAgente, FecIniCalcBono, FecFincalcBono, 
		       ProdPrimaNeta, CantPolizas, MesesProd, CantAgentesProd, 
		       PorcenSiniest, PorcenBonoActual, MontoNivel1, 
		       PorcenNivel1, MontoNivel2, PorcenNivel2, MontoNivel3, 
		       PorcenNivel3, MontoNivel4, PorcenNivel4, MontoNivelsup, 
		       PorcenNivelsup, FecCalculoProy, CodUsuario,
		       GT_BONOS_AGENTES_CONFIG.DESCRIPCION_BONO(CodCia, CodEmpresa, IdBonoVentas) DescBono,
		       OC_AGENTES.NOMBRE_AGENTE(CodCia,CodAgente) NombreAgente,
       		 GT_BONOS_AGENTES_CONFIG.CODIGO_BONO(CodCia,CodEmpresa,IdBonoVentas) CodigoBono
		  FROM BONOS_AGENTES_PROYECCION
		 WHERE CodCia           = 1
		   AND CodEmpresa       = 1
		   AND IdCalculoProy    = nIdCalculoProy
		   AND IdBonoVentas     = nIdBonoVentas
		   AND CodAgente IN (SELECT Cod_Agente
		                       FROM AGENTES
		                      START WITH Cod_Agente_Jefe LIKE cCodDirRegional
		                    CONNECT BY PRIOR Cod_Agente = Cod_Agente_Jefe)
		   AND CodAgente LIKE cCodPromotor
		 UNION
		SELECT CodCia, CodEmpresa, IdCalculoProy, IdBonoVentas, 
		       CodNivel, CodAgente, FecIniCalcBono, FecFincalcBono, 
		       ProdPrimaNeta, CantPolizas, MesesProd, CantAgentesProd, 
		       PorcenSiniest, PorcenBonoActual, MontoNivel1, 
		       PorcenNivel1, MontoNivel2, PorcenNivel2, MontoNivel3, 
		       PorcenNivel3, MontoNivel4, PorcenNivel4, MontoNivelsup, 
		       PorcenNivelsup, FecCalculoProy, CodUsuario,
		       GT_BONOS_AGENTES_CONFIG.DESCRIPCION_BONO(CodCia, CodEmpresa, IdBonoVentas) DescBono,
		       OC_AGENTES.NOMBRE_AGENTE(CodCia,CodAgente) NombreAgente,
       		 GT_BONOS_AGENTES_CONFIG.CODIGO_BONO(CodCia,CodEmpresa,IdBonoVentas) CodigoBono
		  FROM BONOS_AGENTES_PROYECCION
		 WHERE CodCia           = 1
		   AND CodEmpresa       = 1
		   AND IdCalculoProy    = nIdCalculoProy
		   AND IdBonoVentas     = nIdBonoVentas
		   AND CodAgente IN (SELECT Cod_Agente
		                       FROM AGENTES
		                      START WITH Cod_Agente_Jefe LIKE cCodDirRegional
		                    CONNECT BY PRIOR Cod_Agente = Cod_Agente_Jefe)
		   AND CodAgente IN (SELECT Cod_Agente
		                       FROM AGENTES
		                      START WITH Cod_Agente_Jefe LIKE cCodPromotor
		                    CONNECT BY PRIOR Cod_Agente = Cod_Agente_Jefe)
		   AND CodAgente LIKE cCodAgente;
BEGIN
	SELECT SYS_CONTEXT ('USERENV','CURRENT_USERID')
     INTO cCodUser
     FROM DUAL;

  dFecha := TRUNC(SYSDATE);
   
   
	nLinea := 1;
	cCadena  := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
	                 ' xmlns:x="urn:schemas-microsoft-com:office:excel"' ||chr(10)||
	                 ' xmlns="http://www.w3.org/TR/REC-html40">'         ||chr(10)||
	                 ' <style id="libro">'                               ||chr(10)||
	                 '   <!--table'                                      ||chr(10)||
	                 '       {mso-displayed-decimal-separator:"\.";'     ||chr(10)||
	                 '        mso-displayed-thousand-separator:"\,";}'   ||chr(10)||
	                 '        .texto'                                    ||chr(10)||
	                 '          {mso-number-format:"\@";}'               ||chr(10)||
	                 '        .numero'                                   ||chr(10)||
	                 '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
	                 '        .fecha'                                    ||chr(10)||
	                 '          {mso-number-format:"dd\\-mmm\\-yyyy";}'  ||chr(10)||
	                 '    -->'                                           ||chr(10)||
	                 ' </style><div id="libro">'||chr(10);
	OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
	
	nLinea := nLinea + 1;
	cCadena     := '<table border = 0><tr><th>' || oc_empresas.NOMBRE_COMPANIA(1) || '</th></tr>'; 
	OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
	
	nLinea := nLinea + 1;
	cCadena     := '<tr><th>Listado de Poryecciones de Agentes del Día '|| TO_CHAR(dFecha,'DD/MM/YYYY') || '</th></tr>'; 
	OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
	
	nLinea := nLinea + 1;
	cCadena     := '<tr><th>  </th></tr></table>'; 
	OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
	
	nLinea := nLinea + 1;
	cCadena     := '<table border = 1><tr>'																																																					||
								 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Bono</font></th>' 																						||
								 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Bono</font></th>' 																										||
								 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nivel de Agentes del Bono</font></th>' 															||
								 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Agente</font></th>'                   												||
	               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Agente</font></th>'                   																||
	               --'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Promotor</font></th>'                																||
	               --'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Dirección Regional</font></th>'                											||
	               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Producción Prima Neta</font></th>'                       						||
	               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">% Siniestralidad</font></th>'                     										||
	               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Messes Producidos</font></th>'                   										|| 
	               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Cantidad Pólizas</font></th>'                 												||
	               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Cantidad Agentes Productivos</font></th>'                   					||
	               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">% Bono Actual Alcanzado</font></th>'                       					||
	               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de Calculo</font></th>'                    										||
	               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Mto Bono Nivel 1 Alcanzado/Por Alcanzar</font></th>'               	||
	               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Mto Bono Nivel 2 Alcanzado/Por Alcanzar</font></th>'               	||
	               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Mto Bono Nivel 3 Alcanzado/Por Alcanzar</font></th>'             		||
	               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Mto Bono Nivel 4 Alcanzado/Por Alcanzar</font></th>'            			||
	               '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Mto Bono Niveles Superiores Alcanzados/Por Alcanzar</font></th></tr>';
	OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
	
	FOR X IN PROY_Q LOOP
		cCadena := '<tr>' || OC_ARCHIVO.CAMPO_HTML(X.CodigoBono,'C')                    							||
			                   OC_ARCHIVO.CAMPO_HTML(X.DescBono,'C')                                 		|| 
			                   OC_ARCHIVO.CAMPO_HTML(X.CodNivel,'C')  																	|| 
			                   OC_ARCHIVO.CAMPO_HTML(X.CodAgente,'C')                    								|| 
			                   OC_ARCHIVO.CAMPO_HTML(X.NombreAgente,'C')                    						||
			                   OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.ProdPrimaNeta,'99999999999990.00'),'N')  || 
			                   OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.PorcenSiniest,'999990.000000'),'N')  		||
			                   OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MesesProd,'999990'),'N')  								||
			                   OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.CantPolizas,'999990'),'N')  							||
			                   OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.CantAgentesProd,'999990'),'N')  					||
			                   OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.PorcenBonoActual,'999990.000000'),'N')  	||
			                   OC_ARCHIVO.CAMPO_HTML(X.FecCalculoProy,'D')                        			||
			                   OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MontoNivel1,'99999999999990.00'),'N')  	||
			                   OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MontoNivel2,'99999999999990.00'),'N')  	||
			                   OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MontoNivel3,'99999999999990.00'),'N')  	||
			                   OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MontoNivel4,'99999999999990.00'),'N')  	||
			                   OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MontoNivelsup,'99999999999990.00'),'N') 	||'</tr>';  
		nLinea := nLinea + 1;
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END LOOP;

   OC_ARCHIVO.Escribir_Linea('</table></div></html>', ccodUSER, 9999);
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 

  INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
    SELECT nIdReporte + 1,
           B.TIPO_REPORTE,
           B.CODUSR,
           SYSDATE,
           'GEN',
           A.DATA,
           B.FILE_NAME
      FROM SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
     WHERE A.CODUSER = B.CODUSR
       AND B.IDEXTRACCION = nIdReporte;
  DELETE SICAS_OC.EXTRACCION_DE_REPORTES WHERE IDEXTRACCION = nIdReporte;
  OC_ARCHIVO.Eliminar_Archivo(cCodUser);


EXCEPTION 
   WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      raise_application_error(-20102,'Error en Generación de Listado de Proyecciones'|| ' ' ||SQLERRM); 
END;

PROCEDURE GENERAR_PAGOS_DESGLOSE(cNomArchivo VARCHAR2, cCodMoneda VARCHAR2, cCodAgente VARCHAR2,
                        dFecDesde DATE, dFecHasta DATE,cformato varchar2, nidreporte number) IS
cLimitador        VARCHAR2(1) :='|';
nLinea            NUMBER;
cCadena           VARCHAR2(4000);
cCodUser          VARCHAR2(30);
nDummy            NUMBER;
cCopy             BOOLEAN;
cDescFormaPago    VARCHAR2(100);
dFecFin           DATE;
cTipoVigencia     VARCHAR2(20);
nComision         DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nMtoIva           DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nRetISR           DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nRetIVA           DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
cNumComprob       COMPROBANTES_CONTABLES.NumComprob%TYPE;
nIdNcr            NOTAS_DE_CREDITO.IdNcr%TYPE;
cNumFactExt       FACTURA_EXTERNA.NumFactExt%TYPE;
nCodDirecReg      AGENTES.Cod_Agente%TYPE;
cNombreDirecReg   VARCHAR2(500);
-----
nMtoIvaHon        DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nMtoTrivho				DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nMtoTotCom        DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nMtoTotSeg				DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nSPV							NUMBER := 0;
nComisAnt					NUMBER := 0;
niDNCRAnt					NUMBER := 0;
cSegAnt						VARCHAR2(50) := '';
-----

CURSOR NC_Q IS
   SELECT N.IdNcr, N.StsNcr, T.FechaTransaccion, N.FecDevol, N.CodMoneda,
          N.Cod_Agente, OC_AGENTES.NOMBRE_AGENTE(N.CodCia, N.Cod_Agente) NombreAgente,
          T.IdTransaccion, N.Monto_Ncr_Moneda, N.IdNomina, N.CodCia,
          N.CtaLiquidadora,
          OC_NIVEL.DESCRIPCION_NIVEL(N.CodCia, OC_AGENTES.NIVEL_AGENTE(N.CodCia, N.Cod_Agente)) NivelAgente,
          OC_AGENTES.TIPO_AGENTE(N.CodCia, N.Cod_Agente) TipoAgente
         ,C.IDCOMISION,C.IDPOLIZA, C.IDETPOL, DC.CODCONCEPTO, DC.MONTO_MON_EXTRANJERA, DP.IDTIPOSEG , C.IDFACTURA          
     FROM NOTAS_DE_CREDITO N, TRANSACCION T
        , COMISIONES C, DETALLE_COMISION DC,
          DETALLE_POLIZA DP 
    WHERE ((N.CodMoneda              = cCodMoneda AND cCodMoneda != '%')
       OR  (N.CodMoneda           LIKE cCodMoneda AND cCodMoneda = '%'))
      AND ((N.Cod_Agente             = cCodAgente AND cCodAgente != '%')
       OR  (N.Cod_Agente          LIKE cCodAgente AND cCodAgente = '%'))
      AND N.IdNomina            IS NOT NULL
      AND N.StsNcr                   = 'PAG'
      AND T.IdTransaccion            = N.IdTransacAplic
      AND T.IdProceso               IN (17)   -- Pago de Comisiones
      AND TRUNC(T.FechaTransaccion) >= dFecDesde
      AND TRUNC(T.FechaTransaccion) <= dFecHasta
      AND C.IDNOMINA                = N.IDNOMINA
      AND DC.IDCOMISION             = C.IDCOMISION
      AND DP.IDPOLIZA               = C.IDPOLIZA
      AND DP.IDETPOL                = C.IDETPOL      
UNION
   SELECT N.IdNcr, N.StsNcr, T.FechaTransaccion, N.FecDevol, N.CodMoneda,
          N.Cod_Agente, OC_AGENTES.NOMBRE_AGENTE(N.CodCia, N.Cod_Agente) NombreAgente,
          T.IdTransaccion, N.Monto_Ncr_Moneda, N.IdNomina, N.CodCia,
          N.CtaLiquidadora,
          OC_NIVEL.DESCRIPCION_NIVEL(N.CodCia, OC_AGENTES.NIVEL_AGENTE(N.CodCia, N.Cod_Agente)) NivelAgente,
          OC_AGENTES.TIPO_AGENTE(N.CodCia, N.Cod_Agente) TipoAgente
         ,C.IDCOMISION,C.IDPOLIZA, C.IDETPOL, 'TRIVHO', DC.MONTO_MON_EXTRANJERA * -1 MONTO_MON_EXTRANJERA, DP.IDTIPOSEG , C.IDFACTURA          
     FROM NOTAS_DE_CREDITO N, TRANSACCION T
        , COMISIONES C, DETALLE_COMISION DC,
          DETALLE_POLIZA DP 
    WHERE ((N.CodMoneda              = cCodMoneda AND cCodMoneda != '%')
       OR  (N.CodMoneda           LIKE cCodMoneda AND cCodMoneda = '%'))
      AND ((N.Cod_Agente             = cCodAgente AND cCodAgente != '%')
       OR  (N.Cod_Agente          LIKE cCodAgente AND cCodAgente = '%'))
      AND N.IdNomina            IS NOT NULL
      AND N.StsNcr                   = 'PAG'
      AND T.IdTransaccion            = N.IdTransacAplic
      AND T.IdProceso               IN (17)   -- Pago de Comisiones
      AND TRUNC(T.FechaTransaccion) >= dFecDesde
      AND TRUNC(T.FechaTransaccion) <= dFecHasta
      AND C.IDNOMINA                = N.IDNOMINA
      AND DC.IDCOMISION             = C.IDCOMISION
      AND DC.CODCONCEPTO						= 'IVAHON'
      AND DP.IDPOLIZA               = C.IDPOLIZA
      AND DP.IDETPOL                = C.IDETPOL            
    ORDER BY 1,  20, 15;
--    ORDER BY N.IdNcr;    
CURSOR DET_NC_Q IS
   SELECT D.CodCpto, D.Monto_Det_Moneda, D.IndCptoPrima, C.IndCptoServicio
     FROM DETALLE_NOTAS_DE_CREDITO D, NOTAS_DE_CREDITO N, CATALOGO_DE_CONCEPTOS C
    WHERE C.CodConcepto = D.CodCpto
      AND C.CodCia      = N.CodCia
      AND D.IdNcr       = N.IdNcr
      AND N.IdNcr       = nIdNcr;
BEGIN 
  SELECT CODUSR
    INTO cCodUser
    FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte;

   IF cFormato = 'TEXTO' THEN
      nLinea := 1;
      cCadena     := oc_empresas.NOMBRE_COMPANIA(1) || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

      nLinea := nLinea + 1;
      cCadena     := 'REPORTE DE PAGOS A AGENTES DEL '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' || TO_CHAR(dFecHasta,'DD/MM/YYYY') || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

      nLinea := nLinea + 1;
      cCadena     := ' ' || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

      nLinea := nLinea + 1;
      cCadena     := 'No. Nota Crédito'||cLimitador||
--      							 'Status NC'||cLimitador||
      							 'Código Agente'||cLimitador||
                     'Nombre Agente'||cLimitador||'Fecha de Pago'||cLimitador|| 
                     'Moneda'||cLimitador||
--                     'Monto del Pago'||cLimitador||
                     'Id Nomina'||cLimitador|| 
                     'Cta. Liquidadora'||cLimitador||
--                     'Comision/Honorarios/UDIs'||cLimitador||'Total IVA'||cLimitador||'Total IVAHON'||cLimitador||
--                     'Ret. ISR'||cLimitador||'Ret. IVA'||cLimitador|| 
                     'No. Comprobante'||cLimitador||
--                     'Código Direc. Reg.'||cLimitador|| 'Nombre Dirección Regional'||cLimitador||
--                     'Nivel Agte.'||cLimitador||
                     'Tipo Agte.'||
                     'Num. Comision'||'Num. Poliza'||'Detalle Poliza'||'Concepto'||'Monto'||'Tipo Seguro'||'Num. Recibo'|| ---- jmmd20200812
                     'Total por Comisión'||'Total por Tipo de Seguro'||
                     CHR(13); 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   ELSE
      nLinea := 1;
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
                       '          {mso-number-format:"dd\\-mmm\\-yyyy";}'||chr(10)||
                       '    -->'||chr(10)||
                       ' </style><div id="libro">'||chr(10);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<table border = 0><tr><th>' || oc_empresas.NOMBRE_COMPANIA(1) || '</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<tr><th>REPORTE DE PAGOS A AGENTES  DEL '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' ||
                      TO_CHAR(dFecHasta,'DD/MM/YYYY') || '</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<tr><th>  </th></tr></table>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Nota Crédito</font></th>' ||
--                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Status NC</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Agente</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Agente</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de Pago</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Moneda</font></th>' ||
--                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto del Pago</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Id Nomina</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Cta. Liquidadora</font></th>' ||
--                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comisión/Honorarios/UDIs</font></th>' ||
--                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total IVA</font></th>' ||
--                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total IVAHON</font></th>' ||       ----JMMD20200812              
--                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Ret. ISR</font></th>' ||
--                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Ret. IVA</font></th>' ||
--                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Factura Agente</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Comprobante</font></th>' ||
--                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Direc. Reg.</font></th>' ||
--                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Dirección Regional</font></th>'||
--                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nivel Agte.</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Agte.</font></th>'	||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Num. Comision</font></th>'	||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Num. Poliza</font></th>'	||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Detalle Poliza</font></th>'	||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Concepto</font></th>'	||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto</font></th>'	||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Seguro</font></th>'	||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Num. Recibo</font></th>'	||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total por Comisión</font></th>'  ||	                                                                                                                                                                        
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total por Tipo de Seguro</font></th>'	                                                                                                                                                                                                                  	                                                                                                                                                                        
                     ; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END IF;
--   nDummy := alerta('jmmd estoy antes del loop NC_Q');
   FOR X IN NC_Q LOOP
----- jmmd20200825
				IF nSPV = 0 THEN
					 nSPV 		 := 1;
					 niDNCRAnt := X.IDNCR;
					 nComisAnt := X.IDCOMISION;
					 cSegAnt	:= X.IDTIPOSEG;
					  SELECT SUM(A.MONTO_MON_EXTRANJERA)
					    INTO nMtoTotCom
						  FROM (
						   SELECT DC.MONTO_MON_EXTRANJERA MONTO_MON_EXTRANJERA   , DC.CODCONCEPTO     
						     FROM COMISIONES C, DETALLE_COMISION DC
						    WHERE C.IDCOMISION              = X.IDCOMISION     
						      AND DC.IDCOMISION             = C.IDCOMISION  
						UNION
						   SELECT DC.MONTO_MON_EXTRANJERA * -1 MONTO_MON_EXTRANJERA , DC.CODCONCEPTO     
						     FROM COMISIONES C, DETALLE_COMISION DC
						    WHERE C.IDCOMISION              = X.IDCOMISION     
						      AND DC.IDCOMISION             = C.IDCOMISION
						      AND DC.CODCONCEPTO            = 'IVAHON'
						 ) A;
						 
						SELECT SUM(B.MONTO_MON_EXTRANJERA)
						  INTO nMtoTotSeg
						FROM (
						   SELECT N.IdNcr, N.IdNomina, C.IDCOMISION,C.IDPOLIZA, C.IDETPOL, DC.CODCONCEPTO, DC.MONTO_MON_EXTRANJERA MONTO_MON_EXTRANJERA, DP.IDTIPOSEG            
						     FROM NOTAS_DE_CREDITO N, COMISIONES C, DETALLE_COMISION DC,
						          DETALLE_POLIZA DP 
						    WHERE N.IDNCR                    = X.IDNCR
						      AND N.IdNomina            IS NOT NULL
						      AND N.StsNcr                   = 'PAG'
						      AND C.IDNOMINA                = N.IDNOMINA      
						      AND DC.IDCOMISION             = C.IDCOMISION
						      AND DP.IDPOLIZA               = C.IDPOLIZA
						      AND DP.IDETPOL                = C.IDETPOL     
						      AND DP.IDTIPOSEG              = X.IDTIPOSEG 
						UNION
						   SELECT N.IdNcr, N.IdNomina, C.IDCOMISION,C.IDPOLIZA, C.IDETPOL, 'TRIVHO', DC.MONTO_MON_EXTRANJERA * -1 MONTO_MON_EXTRANJERA, DP.IDTIPOSEG           
						     FROM NOTAS_DE_CREDITO N, COMISIONES C, DETALLE_COMISION DC,
						          DETALLE_POLIZA DP 
						    WHERE N.IDNCR                    = X.IDNCR
						      AND N.IdNomina            IS NOT NULL
						      AND N.StsNcr                   = 'PAG'
						      AND C.IDNOMINA                = N.IDNOMINA      
						      AND DC.IDCOMISION             = C.IDCOMISION
						      AND DC.CODCONCEPTO            = 'IVAHON'
						      AND DP.IDPOLIZA               = C.IDPOLIZA
						      AND DP.IDETPOL                = C.IDETPOL   
						      AND DP.IDTIPOSEG              = X.IDTIPOSEG  )B  ;    						 
				ELSE
					IF niDNCRAnt = X.IDNCR THEN
						 IF cSegAnt = X.IDTIPOSEG THEN
						 		nMtoTotSeg := NULL;
								IF nComisAnt = X.IDCOMISION THEN
									 nMtoTotCom := NULL;
								ELSE
									nComisAnt := X.IDCOMISION;
								  SELECT SUM(A.MONTO_MON_EXTRANJERA)
								    INTO nMtoTotCom
									  FROM (
									   SELECT DC.MONTO_MON_EXTRANJERA MONTO_MON_EXTRANJERA   , DC.CODCONCEPTO     
									     FROM COMISIONES C, DETALLE_COMISION DC
									    WHERE C.IDCOMISION              = X.IDCOMISION     
									      AND DC.IDCOMISION             = C.IDCOMISION  
									UNION
									   SELECT DC.MONTO_MON_EXTRANJERA * -1 MONTO_MON_EXTRANJERA , DC.CODCONCEPTO     
									     FROM COMISIONES C, DETALLE_COMISION DC
									    WHERE C.IDCOMISION              = X.IDCOMISION     
									      AND DC.IDCOMISION             = C.IDCOMISION
									      AND DC.CODCONCEPTO            = 'IVAHON'
									 ) A;						
								END IF;
						 ELSE
							cSegAnt := X.IDTIPOSEG;
							nComisAnt := X.IDCOMISION;
							SELECT SUM(B.MONTO_MON_EXTRANJERA)
							  INTO nMtoTotSeg
							FROM (
							   SELECT N.IdNcr, N.IdNomina, C.IDCOMISION,C.IDPOLIZA, C.IDETPOL, DC.CODCONCEPTO, DC.MONTO_MON_EXTRANJERA MONTO_MON_EXTRANJERA, DP.IDTIPOSEG            
							     FROM NOTAS_DE_CREDITO N, COMISIONES C, DETALLE_COMISION DC,
							          DETALLE_POLIZA DP 
							    WHERE N.IDNCR                    = X.IDNCR
							      AND N.IdNomina            IS NOT NULL
							      AND N.StsNcr                   = 'PAG'
							      AND C.IDNOMINA                = N.IDNOMINA      
							      AND DC.IDCOMISION             = C.IDCOMISION
							      AND DP.IDPOLIZA               = C.IDPOLIZA
							      AND DP.IDETPOL                = C.IDETPOL     
							      AND DP.IDTIPOSEG              = X.IDTIPOSEG 
							UNION
							   SELECT N.IdNcr, N.IdNomina, C.IDCOMISION,C.IDPOLIZA, C.IDETPOL, 'TRIVHO', DC.MONTO_MON_EXTRANJERA * -1 MONTO_MON_EXTRANJERA, DP.IDTIPOSEG           
							     FROM NOTAS_DE_CREDITO N, COMISIONES C, DETALLE_COMISION DC,
							          DETALLE_POLIZA DP 
							    WHERE N.IDNCR                    = X.IDNCR
							      AND N.IdNomina            IS NOT NULL
							      AND N.StsNcr                   = 'PAG'
							      AND C.IDNOMINA                = N.IDNOMINA      
							      AND DC.IDCOMISION             = C.IDCOMISION
							      AND DC.CODCONCEPTO            = 'IVAHON'
							      AND DP.IDPOLIZA               = C.IDPOLIZA
							      AND DP.IDETPOL                = C.IDETPOL   
							      AND DP.IDTIPOSEG              = X.IDTIPOSEG  )B    ;	

						  SELECT SUM(A.MONTO_MON_EXTRANJERA)
						    INTO nMtoTotCom
							  FROM (
							   SELECT DC.MONTO_MON_EXTRANJERA MONTO_MON_EXTRANJERA   , DC.CODCONCEPTO     
							     FROM COMISIONES C, DETALLE_COMISION DC
							    WHERE C.IDCOMISION              = X.IDCOMISION     
							      AND DC.IDCOMISION             = C.IDCOMISION  
							UNION
							   SELECT DC.MONTO_MON_EXTRANJERA * -1 MONTO_MON_EXTRANJERA , DC.CODCONCEPTO     
							     FROM COMISIONES C, DETALLE_COMISION DC
							    WHERE C.IDCOMISION              = X.IDCOMISION     
							      AND DC.IDCOMISION             = C.IDCOMISION
							      AND DC.CODCONCEPTO            = 'IVAHON'
							 ) A;													      	
						END IF;
				  ELSE
					 niDNCRAnt := X.IDNCR;
					 nComisAnt := X.IDCOMISION;
					 cSegAnt	:= X.IDTIPOSEG;
					  SELECT SUM(A.MONTO_MON_EXTRANJERA)
					    INTO nMtoTotCom
						  FROM (
						   SELECT DC.MONTO_MON_EXTRANJERA MONTO_MON_EXTRANJERA   , DC.CODCONCEPTO     
						     FROM COMISIONES C, DETALLE_COMISION DC
						    WHERE C.IDCOMISION              = X.IDCOMISION     
						      AND DC.IDCOMISION             = C.IDCOMISION  
						UNION
						   SELECT DC.MONTO_MON_EXTRANJERA * -1 MONTO_MON_EXTRANJERA , DC.CODCONCEPTO     
						     FROM COMISIONES C, DETALLE_COMISION DC
						    WHERE C.IDCOMISION              = X.IDCOMISION     
						      AND DC.IDCOMISION             = C.IDCOMISION
						      AND DC.CODCONCEPTO            = 'IVAHON'
						 ) A;
						 
						SELECT SUM(B.MONTO_MON_EXTRANJERA)
						  INTO nMtoTotSeg
						FROM (
						   SELECT N.IdNcr, N.IdNomina, C.IDCOMISION,C.IDPOLIZA, C.IDETPOL, DC.CODCONCEPTO, DC.MONTO_MON_EXTRANJERA MONTO_MON_EXTRANJERA, DP.IDTIPOSEG            
						     FROM NOTAS_DE_CREDITO N, COMISIONES C, DETALLE_COMISION DC,
						          DETALLE_POLIZA DP 
						    WHERE N.IDNCR                    = X.IDNCR
						      AND N.IdNomina            IS NOT NULL
						      AND N.StsNcr                   = 'PAG'
						      AND C.IDNOMINA                = N.IDNOMINA      
						      AND DC.IDCOMISION             = C.IDCOMISION
						      AND DP.IDPOLIZA               = C.IDPOLIZA
						      AND DP.IDETPOL                = C.IDETPOL     
						      AND DP.IDTIPOSEG              = X.IDTIPOSEG 
						UNION
						   SELECT N.IdNcr, N.IdNomina, C.IDCOMISION,C.IDPOLIZA, C.IDETPOL, 'TRIVHO', DC.MONTO_MON_EXTRANJERA * -1 MONTO_MON_EXTRANJERA, DP.IDTIPOSEG           
						     FROM NOTAS_DE_CREDITO N, COMISIONES C, DETALLE_COMISION DC,
						          DETALLE_POLIZA DP 
						    WHERE N.IDNCR                    = X.IDNCR
						      AND N.IdNomina            IS NOT NULL
						      AND N.StsNcr                   = 'PAG'
						      AND C.IDNOMINA                = N.IDNOMINA      
						      AND DC.IDCOMISION             = C.IDCOMISION
						      AND DC.CODCONCEPTO            = 'IVAHON'
						      AND DP.IDPOLIZA               = C.IDPOLIZA
						      AND DP.IDETPOL                = C.IDETPOL   
						      AND DP.IDTIPOSEG              = X.IDTIPOSEG  )B  ;    						 
						 	
					END IF;
			  END IF;

----- jmmd20200825   	   	
   	  nIdNcr          := X.IdNcr;
      nComision       := 0;
      nMtoIva         := 0;
      nMtoIvaHon			:= 0;
      nRetISR         := 0;
      nRetIVA         := 0;
			nMtoTrivho      := 0;

      BEGIN
         SELECT Cod_Agente_Distr, OC_AGENTES.NOMBRE_AGENTE(CodCia, Cod_Agente_Distr)
           INTO nCodDirecReg, cNombreDirecReg
           FROM AGENTES_DISTRIBUCION_POLIZA
          WHERE CodCia      = X.CodCia
            AND IdPoliza   IN (SELECT MAX(IdPoliza)
                                 FROM COMISIONES C, DETALLE_NOMINA D
                                WHERE C.IdComision = D.IdComision
                                  AND C.CodCia     = D.CodCia
                                  AND D.IdNomina   = X.IdNomina
                                  AND D.CodCia     = X.CodCia)
            AND CodNivel    = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            nCodDirecReg    := 0;
            cNombreDirecReg := 'SIN DIRECCION REGIONAL';
         WHEN TOO_MANY_ROWS THEN
            BEGIN
               SELECT MAX(Cod_Agente_Distr)
                 INTO nCodDirecReg
                 FROM AGENTES_DISTRIBUCION_POLIZA
                WHERE CodCia      = X.CodCia
                  AND IdPoliza   IN (SELECT MAX(IdPoliza)
                                       FROM COMISIONES C, DETALLE_NOMINA D
                                      WHERE C.IdComision = D.IdComision
                                        AND C.CodCia     = D.CodCia
                                        AND D.IdNomina   = X.IdNomina
                                        AND D.CodCia     = X.CodCia)
                  AND CodNivel    = 1;

               cNombreDirecReg := OC_AGENTES.NOMBRE_AGENTE(X.CodCia, nCodDirecReg);
            END;
      END;

      FOR W IN DET_NC_Q LOOP
--      	 nDummy := alerta('jmmd estoy en el loop');
         IF W.CodCpto = 'RETISR' THEN
            nRetISR   := NVL(nRetISR,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'RETIVA' THEN
            nRetIVA   := NVL(nRetIVA,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'IVASIN' THEN
            nMtoIva   := NVL(nMtoIva,0) + NVL(W.Monto_Det_Moneda,0);  
         ELSIF W.CodCpto = 'IVAHON' THEN
            nMtoIvaHon   := NVL(nMtoIvaHon,0) + NVL(W.Monto_Det_Moneda,0);  ---- JMMD 20200812           
         ELSIF W.CodCpto = 'TRIVHO' THEN
            nMtoTrivho   := NVL(nMtoTrivho,0) + NVL(W.Monto_Det_Moneda,0);  ---- JMMD 20200812           
         ELSE
            nComision   := NVL(nComision,0) + NVL(W.Monto_Det_Moneda,0);
         END IF;
      END LOOP;

      SELECT NVL(MAX(NumFactExt),'S/F')
        INTO cNumFactExt
        FROM NCR_FACTEXT N, FACTURA_EXTERNA F
       WHERE F.IdeFactExt = N.IdeFactExt
         AND N.IdNcr      = nIdNcr;

      SELECT NVL(MIN(NumComprob),'0')
        INTO cNumComprob
        FROM COMPROBANTES_CONTABLES
       WHERE NumTransaccion = X.IdTransaccion;

      IF cFormato = 'TEXTO' THEN
         cCadena := TO_CHAR(X.IdNcr,'9999999999999')               ||cLimitador||
--                    X.StsNcr                                       ||cLimitador||
                    TO_CHAR(X.Cod_Agente,'9999999999999')          ||cLimitador||
                    X.NombreAgente                                 ||cLimitador||
                    TO_CHAR(X.FechaTransaccion,'DD/MM/YYYY')       ||cLimitador||
                    X.CodMoneda                                    ||cLimitador||
--                    TO_CHAR(X.Monto_Ncr_Moneda,'99999999999990.00')||cLimitador||
                    TO_CHAR(X.IdNomina,'9999999999999')            ||cLimitador||
                    X.CtaLiquidadora                               ||cLimitador||
--                    TO_CHAR(nComision,'99999999999990.00')         ||cLimitador||
--                    TO_CHAR(nMtoIVA,'99999999999990.00')           ||cLimitador||
--                    TO_CHAR(nMtoIVA,'99999999999990.00')           ||cLimitador||			---- JMMD20200812                    
--                    TO_CHAR(nRetISR,'99999999999990.00')           ||cLimitador||
--                    TO_CHAR(nRetIVA,'99999999999990.00')           ||cLimitador||
--                    cNumFactExt                                    ||cLimitador||
                    cNumComprob                                    ||cLimitador||
--                    TO_CHAR(nCodDirecReg,'99999999999990')         ||cLimitador||
--                    cNombreDirecReg                                ||cLimitador||                                    
--                    X.NivelAgente                                  ||cLimitador||
                    X.TipoAgente 																	 ||cLimitador||
                    TO_CHAR(X.IdComision,'9999999999999')          ||cLimitador||
                    TO_CHAR(X.IdPoliza,'9999999999999')          	 ||cLimitador||
                    TO_CHAR(X.IDetPol,'9999999999999')          	 ||cLimitador||
                    X.CodConcepto												           ||cLimitador||
                    TO_CHAR(X.Monto_Mon_Extranjera,'9999999999999.00')          ||cLimitador||
                    X.IdTipoSeg													           ||cLimitador||
                    TO_CHAR(X.Idfactura,'9999999999999')           ||cLimitador||   
                    TO_CHAR(nMtoTotCom,'99999999999990.00')         ||cLimitador|| 
										TO_CHAR(nMtoTotSeg,'99999999999990.00')         ||                                                                                                                                        
                    CHR(13); 
      ELSE
         cCadena := '<tr>' || OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdNcr,'9999999999990'),'C') ||
--                    OC_ARCHIVO.CAMPO_HTML(X.StsNcr,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Cod_Agente,'9999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.NombreAgente,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FechaTransaccion,'DD/MM/YYYY'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.CodMoneda,'C') ||
--                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Monto_Ncr_Moneda,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdNomina,'9999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.CtaLiquidadora,'C') ||
--                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nComision,'99999999999990.00'),'N') ||
--                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMtoIVA,'99999999999990.00'),'N') ||
--                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMtoIVA,'99999999999990.00'),'N') ||		---- JMMD20200812                    
--                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nRetISR,'99999999999990.00'),'N') ||
--                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nRetIVA,'99999999999990.00'),'N') ||
--                    OC_ARCHIVO.CAMPO_HTML(cNumFactExt,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(cNumComprob,'C') || 
--                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nCodDirecReg,'99999999999990'),'C') ||
--                    OC_ARCHIVO.CAMPO_HTML(cNombreDirecReg,'C') ||
--                    OC_ARCHIVO.CAMPO_HTML(X.NivelAgente,'C') || 
                    OC_ARCHIVO.CAMPO_HTML(X.TipoAgente,'C')  ||   
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IDCOMISION,'99999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IDPOLIZA,'99999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IDETPOL,'99999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.CODCONCEPTO,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Monto_Mon_Extranjera,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IDTIPOSEG),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IDFACTURA,'99999999999990'),'C') ||    
										OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMtoTotCom,'99999999999990.00'),'N') ||
										OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMtoTotSeg,'99999999999990.00'),'N') ||                                                                                                                                                                                                                  
                    '</tr>';
      END IF;
      nLinea := nLinea + 1;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END LOOP;
   IF cFormato = 'EXCEL' THEN
      OC_ARCHIVO.Escribir_Linea('</table></div></html>', ccodUSER, 9999);
   END IF;
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
  INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
    SELECT nIdReporte + 1,
           B.TIPO_REPORTE,
           B.CODUSR,
           SYSDATE,
           'GEN',
           A.DATA,
           B.FILE_NAME
      FROM SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
     WHERE A.CODUSER = B.CODUSR
       AND B.IDEXTRACCION = nIdReporte;
  DELETE SICAS_OC.EXTRACCION_DE_REPORTES WHERE IDEXTRACCION = nIdReporte;
  OC_ARCHIVO.Eliminar_Archivo(cCodUser);

EXCEPTION 
   WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      raise_application_error(-20105,'Error en Generación de Listado de Pago de Agentes ' || SQLERRM); 
END;

PROCEDURE saldos_mes_anio(pNomArchivo VARCHAR2, pCodMoneda VARCHAR2, pCodAgente VARCHAR2,
                        pFecDesde DATE, pFecHasta DATE,cformato varchar2, nidreporte number) IS
cLimitador      			VARCHAR2(1) :='|';
nLinea          			NUMBER;
nLineaimp       			NUMBER := 1;
cCadena         			VARCHAR2(4000);
cCadenaAux      			VARCHAR2(4000);
cCadenaAux1     			VARCHAR2(4000);
cCodUser        			VARCHAR2(30);
nDummy          			NUMBER;
cCopy           			BOOLEAN;
cmoneda								VARCHAR2(5);
nTotalcaracteres			NUMBER;
W_ID_TERMINAL   			VARCHAR2(100);
W_ID_USER       			VARCHAR2(100);
W_ID_ENVIO      			VARCHAR2(100);
cDescFormaPago  			VARCHAR2(100);
dFecFin         			DATE;
dFecprimerdia   			DATE;
cFecFin         			VARCHAR2(10);
cTipoVigencia   			VARCHAR2(20);
nIdFactura      			FACTURAS.IdFactura%TYPE;
nPrimaNeta      			DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nReducPrima     			DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nRecargos       			DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nDerechos       			DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nImpuesto       			DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nImpuestoHonoPF 			DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nImpuestoHonoPM 			DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nImpuestoHonoPFOC 		DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nImpuestoHonoPMOC 		DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nPrimaTotal     			DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nComisionesPEF  			DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nHonorariosPEF  			DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nUdisPEF        			DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nComisionesPEM  			DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nHonorariosPEM  			DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nUdisPEM        			DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nTotComisDist   			DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nDifComis       			DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
cCodPlanPagos   			PLAN_DE_PAGOS.CodPlanPago%TYPE;
cCodGenerador   			AGENTE_POLIZA.Cod_Agente%TYPE;
nTasaIVA        			CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
cDescEstado     			PROVINCIA.DescEstado%TYPE;
nFrecPagos      			PLAN_DE_PAGOS.FrecPagos%TYPE;
nCodTipo        			AGENTES.CODTIPO%TYPE;
cNumComprob     			COMPROBANTES_CONTABLES.NumComprob%TYPE;
cTipoEndoso     			ENDOSOS.TipoEndoso%TYPE;
dFecFinVig      			ENDOSOS.FecFinVig%TYPE;
nIdNcr          			NOTAS_DE_CREDITO.IdNcr%TYPE;
------
cCodtipo        			AGENTES.CODTIPO%TYPE;
cCodtipo1       			AGENTES.CODTIPO%TYPE;
cNombreAgente   			VARCHAR2(200);
nCOD_AGENTE     			AGENTES.COD_AGENTE%TYPE; 
dFE_INI_SALDO   			SALDOS_COMISIONES_MES.FE_INI_SALDO%TYPE;
cFE_INI_SALDO   			varchar2(10);  
cCOD_MONEDA     			SALDOS_COMISIONES_MES.CD_MONEDA%TYPE; 
nMONTO_SALDO_FINAL 		SALDOS_COMISIONES_MES.MT_SALDO_FINAL%TYPE;
------
---
nMtoHonoAge    				NUMBER(28,2);
nMtoComiAge    				NUMBER(28,2);
cTipoAge      				AGENTES.CodTipo%TYPE;
cCodAge        				AGENTES.Cod_Agente%TYPE;

nMtoComiProm  				NUMBER(28,2);
nMtoHonoProm  				NUMBER(28,2);
cTipoProm      				AGENTES.CodTipo%TYPE;
cCodProm       				AGENTES.Cod_Agente%TYPE;

nMtoComiDR    				NUMBER(28,2);
nMtoHonoDR    				NUMBER(28,2);
cTipoDR        				AGENTES.CodTipo%TYPE;
cCodDR         				AGENTES.Cod_Agente%TYPE;
-- ESA 20180620
CFolioFiscal  				FACT_ELECT_DETALLE_TIMBRE.FolioFiscal%TYPE;
cSerie        				FACT_ELECT_DETALLE_TIMBRE.Serie%TYPE;
cUUID          				FACT_ELECT_DETALLE_TIMBRE.UUID%TYPE;
cFechaUUID    				DATE;
cVariosUUID    				NUMBER;
cOrigenRecibo 				VARCHAR2(200);
nOtrasCompPF  				DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nOtrasCompPM  				DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
----
dPagadoHasta    			DATE;
dCubiertoHasta  			DATE;
dFecIniVig      			DATE;
nCuantosEmi      			NUMBER;
nDiasGracia      			NUMBER := 0;
nCuantosPag      			NUMBER := 0;
nMinFactura      			NUMBER := 0;
cStatuspol      			VARCHAR2(3);
--
cCtlArchivo     UTL_FILE.FILE_TYPE;

cNomDirectorio  			VARCHAR2(100) ;

cNomArchZip           VARCHAR2(100);
cIdTipoSeg            VARCHAR2(50) := '%';
cPlanCob              VARCHAR2(100) := '%';
cCodMoneda            VARCHAR2(5) := '%';
cCodAgente            VARCHAR2(25) := '%';
nCodCia               NUMBER := 1;
nCodEmpresa           NUMBER := 1;

cNomCia               VARCHAR2(100);

dFecDesde 						DATE;
dFecHasta 						DATE;
nSPV             			NUMBER := 0;
nAgenteAnt       			NUMBER := 0;
cRutaNomArchivo  			varchar2(100);
      l_bfile         BFILE;
      l_blob          CLOB;

nIVAHON								SALDOS_COMISIONES_MES.MT_SALDO_FINAL%TYPE;

CURSOR SALDOS_ARRASTRE_Q  IS
/* ----- JMMD20210617
SELECT SUM(MT_SALDO_FINAL) COMI_MONEDA, CD_AGENTE AGENTE, CD_MONEDA MONEDA, j.FECHA
FROM SALDOS_COMISIONES_MES SCM,
(SELECT DISTINCT last_day(FE_INI_SALDO)  FECHA
FROM SALDOS_COMISIONES_MES
ORDER BY FECHA) j
WHERE SCM.FE_INI_SALDO = j.FECHA
AND SCM.FE_FIN_SALDO = j.FECHA
AND SCM.CD_MONEDA   = pCodMoneda
--AND SCM.CD_AGENTE = 130
GROUP BY CD_AGENTE, CD_MONEDA, j.FECHA
ORDER BY CD_AGENTE, CD_MONEDA, j.FECHA; */ ----- JMMD20210617

SELECT SUM(MT_SALDO_FINAL) COMI_MONEDA, CD_AGENTE AGENTE, CD_MONEDA MONEDA, j.FECHA FECHA
FROM SALDOS_COMISIONES_MES SCM,
(SELECT DISTINCT last_day(FE_INI_SALDO)  FECHA
FROM SALDOS_COMISIONES_MES
------- JMMD 20210816
WHERE FE_INI_SALDO <= pFecHasta
------- JMMD 20210816
ORDER BY FECHA) j
WHERE SCM.FE_INI_SALDO = j.FECHA
AND SCM.FE_FIN_SALDO = j.FECHA
AND SCM.CD_MONEDA   = pCodMoneda
--AND SCM.CD_AGENTE = 130
GROUP BY CD_AGENTE, CD_MONEDA, j.FECHA
UNION
SELECT SUM(MT_SALDO_FINAL) COMI_MONEDA, CD_AGENTE AGENTE, CD_MONEDA MONEDA, FE_INI_SALDO FECHA
FROM SALDOS_COMISIONES_MES SCM
WHERE /*SCM.FE_INI_SALDO = '01/06/2021'
AND */SCM.FE_FIN_SALDO = pFecHasta
AND SCM.CD_MONEDA   = pCodMoneda
--AND SCM.CD_AGENTE = 130
GROUP BY CD_AGENTE, CD_MONEDA, FE_INI_SALDO
ORDER BY AGENTE, MONEDA, FECHA;


CURSOR ENCABEZADOS_Q IS
   SELECT DISTINCT FE_INI_SALDO
     FROM T_SALDOS_COMISIONES_ANIOMES
     ORDER BY FE_INI_SALDO;

CURSOR DETALLES IS
SELECT cod_agente,  fe_ini_saldo,  cod_moneda, MONTO_saldo_final
  FROM T_SALDOS_COMISIONES_ANIOMES

ORDER BY cOd_agente, fe_ini_saldo; 

----------------------------
CURSOR DETALLES_AGENTES_Q IS
   SELECT DISTINCT COD_AGENTE
     FROM T_SALDOS_COMISIONES_ANIOMES
     ORDER BY COD_AGENTE; 

-------------------------------
PROCEDURE INSERTA_REGISTROS (P_COD_AGENTE IN NUMBER, P_FE_INI_SALDO IN DATE, P_COD_MONEDA IN VARCHAR2, P_MONTO_SALDO_FINAL IN NUMBER) is
BEGIN

       INSERT INTO T_SALDOS_COMISIONES_ANIOMES --(CODCIA, COD_AGENTE, FE_INI_SALDO, COD_MONEDA, MONTO_SALDO_SINAL)
       VALUES(1,P_COD_AGENTE,P_FE_INI_SALDO,P_COD_MONEDA,P_MONTO_SALDO_FINAL);
       nLineaimp := nLineaimp +1;
       
       commit;  
          
END INSERTA_REGISTROS;
-------------------------------

BEGIN 
  SELECT CODUSR
    INTO cCodUser
    FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte;

    SELECT SYS_CONTEXT('userenv', 'terminal'),
           USER
      INTO W_ID_TERMINAL,
           W_ID_USER
      FROM DUAL;
      
    IF pCodMoneda = '%' THEN
 		     raise_application_error(-20105,'En Listado de Saldos de Agentes por Mes y Año, no se puede usar % para la selección de moneda, escoja alguna de la lista' ); 
	END IF;  	 

     --

     cNomDirectorio := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SO_PATH', 'REPORT');
----

  DELETE T_SALDOS_COMISIONES_ANIOMES;
  --
  COMMIT;

----
    ---
      nLinea := 1;
--------------------
      cCadena     := 'REPORTE DE SALDOS AL  ' ||  TO_CHAR(TRUNC(SYSDATE),'DD/MM/YYYY') || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

      nLinea := nLinea + 1;
      cCadena     := ' ' || CHR(13);
--------------------      

   FOR X IN SALDOS_ARRASTRE_Q LOOP

   nCOD_AGENTE                := X.AGENTE; 
--   cFE_INI_SALDO              := TO_CHAR('01/'||X.MES_ANIO);
   dFE_INI_SALDO              := X.FECHA;     

 --  select last_day(cFE_INI_SALDO) into dFE_INI_SALDO from dual;   

   cCOD_MONEDA                := X.MONEDA; 
--------------------- jmmd 20210816
    BEGIN
      SELECT  a.codtipo
        INTO  cCodtipo1 
        FROM AGENTES A
        WHERE A.COD_AGENTE = X.AGENTE;
        
   EXCEPTION WHEN OTHERS THEN
      cCodtipo1        := NULL;
   END;     
   IF cCodtipo1 IN('HONORF', 'HONORM') THEN 
			SELECT SUM(IVAHON) 
			  INTO nIVAHON
			  FROM
			(
			select SUM(DC.MONTO_MON_EXTRANJERA) IVAHON
			from comisiones c,
			detalle_comision dc
			where cod_agente = X.AGENTE
			and c.cod_moneda = pCodMoneda
			and (trunc(fec_estado) between pFecDesde and X.FECHA or
			trunc(fec_liquidacion) between pFecDesde and X.FECHA)
			and dc.idcomision = c.idcomision 
			and codconcepto = 'IVAHON'
			AND C.ESTADO IN( 'REC')
			UNION ALL
			select SUM(DC.MONTO_MON_EXTRANJERA) IVAHON
			from comisiones c,
			detalle_comision dc
			where cod_agente = X.AGENTE
			and c.cod_moneda = pCodMoneda
			and (trunc(fec_estado) between pFecDesde and X.FECHA AND
			trunc(fec_liquidacion) > X.FECHA)
			and dc.idcomision = c.idcomision 
			and codconcepto = 'IVAHON'
			AND C.ESTADO IN( 'LIQ')
			);
   ELSE
   	 nIVAHON := 0;
   END IF;
--------------------- jmmd 20210816

   nMONTO_SALDO_FINAL         := X.COMI_MONEDA + nIVAHON;
----
   INSERTA_REGISTROS (nCOD_AGENTE, dFE_INI_SALDO, cCOD_MONEDA, nMONTO_SALDO_FINAL);

   END LOOP;

   FOR Y IN ENCABEZADOS_Q LOOP

       IF nspv = 0 then    

          nspv := 1;
         cCadena :=  'AGENTE'||cLimitador||'TIPO AGENTE'||cLimitador||'NOMBRE AGENTE'||cLimitador||'MONEDA'||cLimitador||Y.FE_INI_SALDO||cLimitador;
--         cCadena := cCadena||Y.FE_INI_SALDO||cLimitador;
       else
         cCadena := cCadena ||Y.FE_INI_SALDO||cLimitador ;
       end if;   
   END LOOP; 
   
--   	    nDummy := ALERTA('JMMD DESPUES FOR Y IN ENCABEZADOS_Q LOOP cCadena   '||cCadena||'  nLinea  '||nLinea);   

   	    cCadena := cCadena || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

      nLinea := nLinea + 1;   	        				

   cCadena := '';
   
   nspv := 0;
 ------------------
-- nDummy := ALERTA('JMMD EN FOR w IN DETALLES_AGENTES_Q LOOP nspv   '||nspv);           
    FOR W IN DETALLES_AGENTES_Q LOOP 
            BEGIN
              SELECT  a.codtipo, OC_AGENTES.NOMBRE_AGENTE(a.codcia, a.Cod_Agente) NombreAgente
                INTO  cCodtipo , cNombreAgente
                FROM AGENTES A
                WHERE A.COD_AGENTE = W.COD_AGENTE;
                
           EXCEPTION WHEN OTHERS THEN
              cCodtipo        := NULL;
              cNombreAgente   := NULL;
           END;     
	    
       FOR Z IN ENCABEZADOS_Q LOOP  
---------------
			    select  to_date('01/'|| to_char(Z.FE_INI_SALDO, 'MM') ||'/' ||to_char(Z.FE_INI_SALDO, 'YYYY'), 'dd/mm/yyyy') first 
			    into dFecprimerdia 
			    from dual;
 --   nDummy := ALERTA('JMMD EN primer dia dFecprimerdia '||dFecprimerdia); 
    
/*    select sum(mt_comision_mes)
    INTO nMONTO_SALDO_FINAL
			from saldos_comisiones_mes
			where cd_agente = W.COD_AGENTE
			and fe_ini_saldo between dFecprimerdia and Z.FE_INI_SALDO
			and cd_moneda = pCodmoneda;
*/			
					cmoneda := pCodmoneda;
			
---------------
            BEGIN
              SELECT T.MONTO_SALDO_FINAL, T.COD_MONEDA
                INTO nMONTO_SALDO_FINAL, cmoneda
                FROM T_SALDOS_COMISIONES_ANIOMES T
               WHERE T.COD_AGENTE = W.COD_AGENTE
                 AND T.FE_INI_SALDO = Z.FE_INI_SALDO;
            EXCEPTION WHEN OTHERS THEN
                nMONTO_SALDO_FINAL := 0;
                cmoneda := pCodmoneda;
            END;   
 
          
           IF nspv = 0 then   
            
              nAgenteAnt := W.COD_AGENTE;     
              nspv := 1;
             cCadena := W.COD_AGENTE                                 ||cLimitador||
             cCodtipo ||cLimitador|| cNombreAgente ||cLimitador||cmoneda||cLimitador||
             TO_CHAR(nMONTO_SALDO_FINAL,'99999999999990.00')        ||cLimitador;
           else
             IF nAgenteAnt = W.COD_AGENTE THEN
                cCadena := cCadena ||
                TO_CHAR(nMONTO_SALDO_FINAL,'99999999999990.00')        ||cLimitador;
             ELSE
               nAgenteAnt := W.COD_AGENTE ;
               cCadena := '';
               cCadena := W.COD_AGENTE                                  ||cLimitador||
               cCodtipo ||cLimitador|| cNombreAgente ||cLimitador||cmoneda||cLimitador||
               TO_CHAR(nMONTO_SALDO_FINAL,'99999999999990.00')        ||cLimitador;
             END IF;
           end if;
   	      
            ----
        END LOOP;
      cCadena := cCadena || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

      nLinea := nLinea + 1; 
   END LOOP;
 --	    nDummy := ALERTA('JMMD EN despues del LOOP   ');
 	    
 ------------------  
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
  INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
    SELECT nIdReporte + 1,
           B.TIPO_REPORTE,
           B.CODUSR,
           SYSDATE,
           'GEN',
           A.DATA,
           B.FILE_NAME
      FROM SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
     WHERE A.CODUSER = B.CODUSR
       AND B.IDEXTRACCION = nIdReporte;
  DELETE SICAS_OC.EXTRACCION_DE_REPORTES WHERE IDEXTRACCION = nIdReporte;
  OC_ARCHIVO.Eliminar_Archivo(cCodUser);
   
EXCEPTION
   WHEN OTHERS THEN
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      raise_application_error(-20105,'Error en Generación de Listado de Saldos de Agentes por Mes y Año' || SQLERRM); 
END;



PROCEDURE PAGOS_AGENTES(cNomArchivo VARCHAR2, cCodMoneda VARCHAR2, cCodAgente VARCHAR2, dFecDesde DATE,
                             dFecHasta DATE,cformato varchar2, nidreporte number) IS
                
cLimitador        VARCHAR2(1) :='|';
nLinea            NUMBER;
cCadena           VARCHAR2(4000);
cCodUser          VARCHAR2(30);
nDummy            NUMBER;
cCopy             BOOLEAN;
cDescStatus       VARCHAR2(30);
nCodDirecReg      AGENTES.Cod_Agente%TYPE;
cNombreDirecReg   VARCHAR2(500);
nIVAHON						DETALLE_COMISION.MONTO_MON_LOCAL%TYPE := 0;

CURSOR PAGOS_Q IS 
SELECT NC.CodCia COMPAÑIA, NC.Cod_Agente AGENTE, PNJ.NOMBRE||' '||PNJ.APELLIDO_PATERNO||' '||PNJ.APELLIDO_MATERNO NOMBRE_AGENTE, 
      NC.IDNCR, NC.IdNomina, NC.Monto_NCR_Local MONTO_LOCAL, 
               NC.Monto_NCR_Moneda MONTO_MONEDA, TO_CHAR(TRUNC(NC.FecDevol),'DD/MM/YYYY') FechaSolicitud,
               NC.CodMoneda MONEDA, OC_MONEDA.DESCRIPCION_MONEDA(CodMoneda) DescMoneda,  NC.CTALIQUIDADORA CUENTA_LIQUIDADORA,
               CASE 
                 WHEN NC.CTALIQUIDADORA = 8602 THEN 'COMISIONES PF Y PM'
                 WHEN NC.CTALIQUIDADORA = 8606 THEN 'HONORARIO PERSONA FISICA'
                 ELSE 'HONORARIO PERSONA MORAL'
               END DESCRIPCION_CUENTA,
               A.TIPO_DOC_IDENTIFICACION, A.NUM_DOC_IDENTIFICACION, MP.NUMCUENTABANCARIA CUENTA_BANCARIA, MP.NUMCUENTACLABE CUENTA_CLABE, 
               MP.CODENTIDADFINAN CODIGO_ENTIDAD , oc_entidad_financiera.NOMBRE_COMERCIAL(1,MP.CODENTIDADFINAN) descripcion_banco,
                mp.Indmedioprincipal CUENTAPRINCIPAL
   FROM NOMINA_COMISION NOC,
   NOTAS_DE_CREDITO NC,
   AGENTES A, 
   PERSONA_NATURAL_JURIDICA PNJ,  --8602 COMISIONES PF Y PM, 8606 HONORARIO PF, 8607 HONARIO PM
   MEDIOS_DE_PAGO MP 
WHERE nc.fecdevol BETWEEN dFecDesde AND dFecHasta 
AND NOC.ESTADO = 'GENERA'
AND NC.CodCia         = 1
AND NC.IdNOMINA       = NOC.IDNOMINA
AND A.COD_AGENTE = NC.COD_AGENTE
AND PNJ.TIPO_DOC_IDENTIFICACION = A.TIPO_DOC_IDENTIFICACION
AND PNJ.NUM_DOC_IDENTIFICACION = A.NUM_DOC_IDENTIFICACION
AND MP.TIPO_DOC_IDENTIFICACION = A.TIPO_DOC_IDENTIFICACION
AND MP.NUM_DOC_IDENTIFICACION = A.NUM_DOC_IDENTIFICACION
AND MP.INDMEDIOPRINCIPAL = 'S'
ORDER BY NC.FECDEVOL, AGENTE ;

BEGIN 
  SELECT CODUSR
    INTO cCodUser
    FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte;

   IF cFormato = 'TEXTO' THEN
      nLinea := 1;
      cCadena     := oc_empresas.NOMBRE_COMPANIA(1) || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

      nLinea := nLinea + 1;
      cCadena     := 'RELACIÓN DE PAGOS A AGENTES DEL DÍA ' ||  TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' || TO_CHAR(dFecHasta,'DD/MM/YYYY') || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

      nLinea := nLinea + 1;
      cCadena     := ' ' || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

      nLinea := nLinea + 1;
      cCadena     := 'Compañia'                 ||cLimitador||'Agente'                ||cLimitador||
                     'Nombre Agente'        ||cLimitador||'Nota de Credito'        ||cLimitador||
                     'Id Nomina'     ||cLimitador||'Monto Local'                ||cLimitador||
                     'Monto Moneda'        ||cLimitador||'Fecha Solicitud'             ||cLimitador||
                     'Moneda'               ||cLimitador||'Descripción Moneda'              ||cLimitador||
                     'Cuenta liquidadora'               ||cLimitador||'Descripción Cuenta'         ||cLimitador||
                     'Tipo Identificación'   ||cLimitador||'Número de Identificación'            ||cLimitador||
                     'Cuenta Bancaria'       ||cLimitador||'Cuenta Clabe'         ||cLimitador||
                     'Código Entidad'    ||cLimitador||'Descripción Banco'   ||cLimitador||
                     'Cuenta Principal'   ||
                     CHR(13);  
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   ELSE
      nLinea := 1;
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
                       '          {mso-number-format:"dd\\-mmm\\-yyyy";}'||chr(10)||
                       '    -->'||chr(10)||
                       ' </style><div id="libro">'||chr(10);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<table border = 0><tr><th>' || oc_empresas.NOMBRE_COMPANIA(1) || '</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<tr><th>RELACIÓN DE PAGOS A AGENTES DEL DÍA  ' ||  TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' ||
                      TO_CHAR(dFecHasta,'DD/MM/YYYY') || '</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<tr><th>  </th></tr></table>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Compañia</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Agente</font></th>'                 ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Agente</font></th>'              ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nota de Credito</font></th>'         ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Id Nomina</font></th>'           || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto Local</font></th>'              ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto Moneda</font></th>'              ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Solicitud</font></th>'              ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Moneda</font></th>'                     ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descripción Moneda</font></th>'               ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Cuenta liquidadora</font></th>'                     ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descripción Cuenta</font></th>'          ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Identificación</font></th>'         ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Número de Identificación</font></th>'             ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Cuenta Bancaria</font></th>'             ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Cuenta Clabe</font></th>'          ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Entidad</font></th>'          ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descripción Banco</font></th>'    ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Cuenta Principal</font></th>'                                                             
                     ;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END IF;

   FOR X IN PAGOS_Q LOOP

      IF cFormato = 'TEXTO' THEN
         cCadena := X.COMPAÑIA                                     ||cLimitador||
                    TO_CHAR(X.AGENTE,'9999999999999')              ||cLimitador||
                    X.NOMBRE_AGENTE                                ||cLimitador||
                    TO_CHAR(X.IDNCR,'9999999999999')               ||cLimitador||
                    TO_CHAR(X.IdNomina,'9999999999999')            ||cLimitador||
                    TO_CHAR(X.MONTO_LOCAL,'9999999999999.00')      ||cLimitador||
                    TO_CHAR(X.MONTO_MONEDA,'9999999999990.00')     ||cLimitador||
                    X.FechaSolicitud         											 ||cLimitador||                    
                    X.MONEDA                                 			 ||cLimitador||
                    X.DescMoneda                                   ||cLimitador||
                    X.CUENTA_LIQUIDADORA          								 ||cLimitador||
                    X.DESCRIPCION_CUENTA                           ||cLimitador||
                    X.TIPO_DOC_IDENTIFICACION  										 ||cLimitador||
                    X.NUM_DOC_IDENTIFICACION 											 ||cLimitador||
                    X.CUENTA_BANCARIA            									 ||cLimitador||
                    X.CUENTA_CLABE         												 ||cLimitador||
                    X.CODIGO_ENTIDAD        											 ||cLimitador||
                    X.descripcion_banco        										 ||cLimitador||
                    X.CUENTAPRINCIPAL           									 ||cLimitador||
                    CHR(13); 
      ELSE
         cCadena := '<tr>' || OC_ARCHIVO.CAMPO_HTML(X.COMPAÑIA,'C')                               ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.AGENTE,'9999999999990'),'C')              ||
                    OC_ARCHIVO.CAMPO_HTML(X.NOMBRE_AGENTE,'C')                                       ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IDNCR,'9999999999990'),'C')            ||                    
                    OC_ARCHIVO.CAMPO_HTML(X.IdNomina,'C')             ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MONTO_LOCAL,'9999999999990.00'),'N')            ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MONTO_MONEDA,'9999999999990.00'),'N')          ||
                    OC_ARCHIVO.CAMPO_HTML(X.FechaSolicitud,'C')         ||                    
                    OC_ARCHIVO.CAMPO_HTML(X.Moneda,'C')                                   ||
                    OC_ARCHIVO.CAMPO_HTML(X.DescMoneda  ,'C')                                       ||                    
                    OC_ARCHIVO.CAMPO_HTML(X.CUENTA_LIQUIDADORA,'C')          ||
                    OC_ARCHIVO.CAMPO_HTML(X.DESCRIPCION_CUENTA,'C')                                       ||
                    OC_ARCHIVO.CAMPO_HTML(X.TIPO_DOC_IDENTIFICACION,'C')                                       ||                    
                    OC_ARCHIVO.CAMPO_HTML(X.NUM_DOC_IDENTIFICACION,'C')                                       ||
                    OC_ARCHIVO.CAMPO_HTML(X.CUENTA_BANCARIA,'C')                                       ||  
                    OC_ARCHIVO.CAMPO_HTML(X.CUENTA_CLABE,'C')                                       ||                                                                                
                    OC_ARCHIVO.CAMPO_HTML(X.CODIGO_ENTIDAD ,'C')                                       ||                                                                                                                                                                                                                                                                                                          
                    OC_ARCHIVO.CAMPO_HTML(X.descripcion_banco ,'C')  ||
                    OC_ARCHIVO.CAMPO_HTML(X.CUENTAPRINCIPAL ,'C')                                       ||                                                                                                    
                    '</tr>';
      END IF;
 
      nLinea := nLinea + 1;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
 
   END LOOP;
   IF cFormato = 'EXCEL' THEN
      OC_ARCHIVO.Escribir_Linea('</table></div></html>', ccodUser, 9999);
   END IF;
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
  INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
    SELECT nIdReporte + 1,
           B.TIPO_REPORTE,
           B.CODUSR,
           SYSDATE,
           'GEN',
           A.DATA,
           B.FILE_NAME
      FROM SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
     WHERE A.CODUSER = B.CODUSR
       AND B.IDEXTRACCION = nIdReporte;
  DELETE SICAS_OC.EXTRACCION_DE_REPORTES WHERE IDEXTRACCION = nIdReporte;
  OC_ARCHIVO.Eliminar_Archivo(cCodUser);
EXCEPTION 
   WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      raise_application_error(-20105,'Error en Generación de Comisiones ' || cDescStatus || ' ' ||SQLERRM); 
END;

PROCEDURE COMPARA_COMIS_SALDOS(cNomArchivo VARCHAR2, cCodMoneda VARCHAR2, cCodAgente VARCHAR2, dFecDesde DATE,
                             dFecHasta DATE,cformato varchar2, nidreporte number) IS
                
cLimitador        VARCHAR2(1) :='|';
nLinea            NUMBER;
cCadena           VARCHAR2(4000);
cCodUser          VARCHAR2(30);
nDummy            NUMBER;
cCopy             BOOLEAN;
cDescStatus       VARCHAR2(30);
nCodDirecReg      AGENTES.Cod_Agente%TYPE;
cNombreDirecReg   VARCHAR2(500);
nIVAHON						DETALLE_COMISION.MONTO_MON_LOCAL%TYPE := 0;

CURSOR COMPARA_Q IS 
SELECT AGENTE, SUM(SUMCOMIS) COMISION, SUM(SUMARRASTRE) SALDOS, (SUM(SUMCOMIS) - SUM(SUMARRASTRE)) DIFERENCIA
FROM (
SELECT COD_AGENTE AGENTE,SUM(COMISION_MONEDA)  SUMCOMIS, 0 SUMARRASTRE
FROM COMISIONES
WHERE TRUNC(FEC_ESTADO)  BETWEEN dFecDesde AND dFecHasta -- OR
--TRUNC(FEC_LIQUIDACION)  BETWEEN '01/07/2019' AND '20/08/2021' )
AND ESTADO = 'REC'
--AND COD_AGENTE = &3217
AND COD_MONEDA = cCodMoneda
GROUP BY COD_AGENTE
UNION
SELECT COD_AGENTE AGENTE,SUM(COMISION_MONEDA)  SUMCOMIS, 0 SUMARRASTRE
FROM COMISIONES
WHERE (TRUNC(FEC_ESTADO)  BETWEEN dFecDesde AND dFecHasta AND
TRUNC(FEC_LIQUIDACION)  > dFecHasta )
AND ESTADO = 'LIQ'
--AND COD_AGENTE = &3217
AND COD_MONEDA = cCodMoneda
GROUP BY COD_AGENTE
UNION 
SELECT CD_AGENTE AGENTE, 0 SUMCOMIS, SUM(MT_SALDO_FINAL) SUMARRASTRE
FROM SALDOS_COMISIONES_MES
WHERE FE_INI_SALDO = dFecHasta
--AND CD_AGENTE = &3217
AND CD_MONEDA = cCodMoneda
GROUP BY CD_AGENTE) P

GROUP BY AGENTE
ORDER BY AGENTE ;

BEGIN 
  SELECT CODUSR
    INTO cCodUser
    FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte;

      IF cCodMoneda = '%' THEN
 		   raise_application_error(-20105,'En Listado de Comparación de comisiones vs saldos, no se puede usar % para la selección de moneda, escoja alguna de la lista' ); 
   		END IF;  	 

   IF cFormato = 'TEXTO' THEN
      nLinea := 1;
      cCadena     := oc_empresas.NOMBRE_COMPANIA(1) || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

      nLinea := nLinea + 1;
      cCadena     := 'COMPARA COMISIONES POR PAGAR VS. SALDOS ARRASTRE ' ||  TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' || TO_CHAR(dFecHasta,'DD/MM/YYYY') || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

      nLinea := nLinea + 1;
      cCadena     := ' ' || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

      nLinea := nLinea + 1;
      cCadena     := 'Agente'                ||cLimitador||
                     'Comisiones por pagar'        ||cLimitador||
                     'Saldos de arrastre'        ||cLimitador||
                     'Diferencia'   ||
                     CHR(13);  
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   ELSE
      nLinea := 1;
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
                       '          {mso-number-format:"dd\\-mmm\\-yyyy";}'||chr(10)||
                       '    -->'||chr(10)||
                       ' </style><div id="libro">'||chr(10);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<table border = 0><tr><th>' || oc_empresas.NOMBRE_COMPANIA(1) || '</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<tr><th>COMPARA COMISIONES POR PAGAR VS. SALDOS ARRASTRE  ' ||  TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' ||
                      TO_CHAR(dFecHasta,'DD/MM/YYYY') || '</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<tr><th>  </th></tr></table>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

      nLinea := nLinea + 1;
      cCadena     := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Agente</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comisiones por pagar</font></th>'                 ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Saldos de arrastre</font></th>'              ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Diferencia</font></th>'                                                             
                     ;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END IF;

   FOR X IN COMPARA_Q LOOP

			IF X.DIFERENCIA != 0 THEN
		      IF cFormato = 'TEXTO' THEN
		         cCadena := TO_CHAR(X.AGENTE,'9999999999999')              	||cLimitador||
		                    TO_CHAR(X.COMISION,'9999999999999.00')      		||cLimitador||
		                    TO_CHAR(X.SALDOS,'9999999999990.00')     				||cLimitador||
		                    TO_CHAR(X.DIFERENCIA,'9999999999990.00')  			||cLimitador||                    
		                    CHR(13); 
		      ELSE
		         cCadena := '<tr>' || OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.AGENTE,'9999999999990'),'C')              ||
		                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.COMISION,'9999999999990.00'),'N')            ||
		                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.SALDOS,'9999999999990.00'),'N')          ||
		                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.DIFERENCIA,'9999999999990.00'),'N')          ||
		                    '</tr>';
		      END IF;
 
		      nLinea := nLinea + 1;
		      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
 			END IF;
   END LOOP;
   IF cFormato = 'EXCEL' THEN
      OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
   END IF;
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
  INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
    SELECT nIdReporte + 1,
           B.TIPO_REPORTE,
           B.CODUSR,
           SYSDATE,
           'GEN',
           A.DATA,
           B.FILE_NAME
      FROM SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
     WHERE A.CODUSER = B.CODUSR
       AND B.IDEXTRACCION = nIdReporte;
  DELETE SICAS_OC.EXTRACCION_DE_REPORTES WHERE IDEXTRACCION = nIdReporte;
  OC_ARCHIVO.Eliminar_Archivo(cCodUser);
EXCEPTION 
   WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      raise_application_error(-20105,'Error en Generación de Comisiones VS saldos de arrastre  ' || cDescStatus || ' ' ||SQLERRM); 
END;

PROCEDURE GENERAR_PAGOSXRAMO(cNomArchivo VARCHAR2, cCodMoneda VARCHAR2, cCodAgente VARCHAR2,
                             dFecDesde DATE, dFecHasta DATE,cformato varchar2, nidreporte number) IS
        cLimitador        VARCHAR2(1) :='|';
        nLinea            NUMBER;
        cCadena           VARCHAR2(4000);
        cCodUser          VARCHAR2(30);
        nDummy            NUMBER;
        cCopy             BOOLEAN;
        cDescFormaPago    VARCHAR2(100);
        dFecFin           DATE;
        cTipoVigencia     VARCHAR2(20);
        nComision         DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
        nMtoIva           DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
        nRetIVA           DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
        cNumComprob       COMPROBANTES_CONTABLES.NumComprob%TYPE;
        nIdNcr            NOTAS_DE_CREDITO.IdNcr%TYPE;
        cNumFactExt       FACTURA_EXTERNA.NumFactExt%TYPE;
        nCodDirecReg      AGENTES.Cod_Agente%TYPE;
        cNombreDirecReg   VARCHAR2(500);
        -----
        nMtoIvaHon        DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
        nTOTALRETEN       DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
        nConIvaHon        NUMBER := 0;
        -----
        nRetISRRESICO     DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE := 0;
        -----
        nIDREGFISSAT      PERSONA_NATURAL_JURIDICA.IDREGFISSAT%TYPE;
        dFECMOVTOSICAS    PERSONA_NATURAL_JURIDICA.FECMOVTOSICAS%TYPE;
        nNUM_TRIBUTARIO   PERSONA_NATURAL_JURIDICA.NUM_TRIBUTARIO%TYPE;
        si_resico         VARCHAR2(10);

        NRETISR           NUMBER :=0;
        NISR_RESICO       NUMBER :=0; 
        LDEBUG					  VARCHAR2(100) := 'INICIO';
        -------
    LLAVE1    PERSONA_NATURAL_JURIDICA.TIPO_DOC_IDENTIFICACION%TYPE;
    LLAVE2    PERSONA_NATURAL_JURIDICA.NUM_DOC_IDENTIFICACION%TYPE;
    --
        CURSOR NC_Q IS
                 SELECT GPO.CODCIA,
                 				GPO.IDNCR,
                        GPO.STSNCR,
                        GPO.IDNOMINA,
                        GPO.CtaLiquidadora,
                        GPO.AGENTE,
                        GPO.NOMBRE_AGENTE,
                        GPO.rfc_AGENTE,
                        GPO.NumComprob,
                        --Cod_Agente_Distr,
                        --DIR_REG,        
                        OC_NIVEL.DESCRIPCION_NIVEL(1, OC_AGENTES.NIVEL_AGENTE(1, GPO.AGENTE)) NivelAgente,        
                        GPO.CODTIPO,
                        GPO.FECHA_LIQUIDA,
                        NULL NO_FACT_AGENTE,
                        GPO.Codmoneda,
                        GPO.CONCEPTO,
                        GPO.RAMO,
                        GPO.COMISI      MONTO_COMISION,
                        GPO.IVASIN,
                        GPO.IVAHON,
                        GPO.RETISR,
                        GPO.COMISI + GPO.IVASIN                 MONTO_TOTAL,  
                        --DECODE(nvl(si_resico, 0), 1, 0, RETISR) RETISR,
                        --DECODE(nvl(si_resico, 0), 1, RETISR, 0) ISR_RESICO,
                        GPO.RETIVA,
                        GPO.RETISR + GPO.RETIVA                         TOT_RETENCIONES,        
                        case when GPO.CODTIPO = 'HONORM' THEN
                                        GPO.COMISI + GPO.IVASIN + GPO.RETISR+ GPO.RETIVA -- +IVAHON
                                      ELSE
                                        GPO.COMISI + GPO.IVASIN + GPO.RETISR+ GPO.RETIVA
                                 END                            MONTO_PAGO,
                        GPO.RESICO,
                        GPO.FechaTransaccion
                FROM (
                SELECT     SAL.CODCIA,
                					 SAL.idncr,           
                           SAL.idnomina,
                           SAL.STSNCR,
                           SAL.agente,
                           SICAS_OC.OC_AGENTES.NOMBRE_AGENTE(1,SAL.agente) NOMBRE_AGENTE,
                           SAL.rfc_AGENTE,
                           SAL.FechaTransaccion AS fecha_liquida,
                           SAL.CtaLiquidadora,
                           SAL.Codmoneda,
                           CASE WHEN SAL.CONCEPTO NOT IN ('HONORA', 'COMVDA', 'COMACC', 'IVASIN','RETISR','RETIVA','IVAHON') THEN
                                SAL.CONCEPTO 
                           ELSE
                                'COMISI'
                           END CONCEPTO, 
                           SAL.RETPORCEN,
                           SUM(DECODE(SAL.concepto, 'IVASIN', NVL(SAL.monto_mon_local, 0), 0)) IVASIN,
                           SUM(DECODE(SAL.concepto, 'IVAHON', NVL(SAL.monto_mon_local, 0), 0)) IVAHON,        
                           SUM(DECODE(SAL.concepto, 'RETISR', NVL(SAL.monto_mon_local, 0), 0)) RETISR, 
                           SUM(DECODE(SAL.concepto, 'RETIVA', NVL(SAL.monto_mon_local, 0), 0)) RETIVA, 
                           SUM(DECODE(SAL.concepto, 'COMISI', 0, 'IVASIN', 0,  'RETISR', 0, 'RETIVA', 0, 'IVAHON', 0, NVL(SAL.monto_mon_local, 0))) OTRO, 
                           SUM(case when SAL.concepto in('COMISI', 'HONORA', 'COMVDA', 'COMACC') then  NVL(SAL.monto_mon_local, 0) else  0 end) COMISI, 
                           sum(SAL.monto_mon_local)      MTOMONLOCAL,
                           sum(SAL.monto_mon_extranjera) MTOMONEXTRANJERA,
                           sum(SAL.comisionlocal)        COMISLOCAL,
                           sum(SAL.comisionmoneda)       COMISMONEDA,
                           SAL.ramo,
                           SAL.codtipo,
                           SAL.resico,
                           SAL.fecha_movtosicas,
                           --SAL.si_resico,
                           SAL.NumComprob,
                           --Cod_Agente_Distr,
                           --DIR_REG,
                           SAL.FechaTransaccion              
                      from (select NOTA.CODCIA,
                      						 dn.idnomina,
                                   NOTA.IDNCR,
                                   NOTA.STSNCR,
                                   c.idpoliza, 
                                   DN.montonetolocal, 
                                   DN.montonetomoneda, 
                                   NOTA.Codmoneda         Codmoneda, 
                                   NOTA.CtaLiquidadora,
                                   dc.codconcepto       concepto,                
                                   CASE WHEN  C.IDNCR IS NOT NULL AND dc.codconcepto= 'RETISR' AND sign(DC.monto_mon_local) = -1 THEN (DC.monto_mon_local * -1) ELSE DC.monto_mon_local END monto_mon_local,
                                   CASE WHEN  C.IDNCR IS NOT NULL AND dc.codconcepto= 'RETISR' AND sign(DC.monto_mon_extranjera) = -1 THEN (DC.monto_mon_extranjera * -1) ELSE DC.monto_mon_extranjera END monto_mon_extranjera,
                                   CASE WHEN  C.IDNCR IS NOT NULL AND dc.codconcepto= 'RETISR' AND sign(C.comision_local) = -1 THEN (C.comision_local * -1) ELSE C.comision_local END comisionlocal,
                                   CASE WHEN  C.IDNCR IS NOT NULL AND dc.codconcepto= 'RETISR' AND sign(C.comision_moneda) = -1 THEN (C.comision_moneda * -1) ELSE C.comision_moneda END comisionmoneda,
                                   --DC.monto_mon_local 			monto_mon_local, 
                                   --DC.monto_mon_extranjera 	monto_mon_extranjera, 
                                   --c.comision_local  		comisionlocal, 
                                   --c.comision_moneda		 comisionmoneda, 
                                   dp.idtiposeg      tiposeg,                    
                                   a.cod_agente      agente,
                                   a.codtipo         codtipo, 
                                   nvl(pnj.idregfissat, 612)   resico, 
                                   CAT.PORCCONCEPTO  RETPORCEN,
                                   decode(ts.codtipoplan, '010', 'VIDA', '030', 'ACC.PERS.','099','MULTIRAMO') RAMO,
                                   c.fec_liquidacion fecha_liquida, 
                                   pnj.FECMOVTOSICAS fecha_movtosicas, 
                                   replace(PNJ.NUM_TRIBUTARIO, chr(13), '')  rfc_AGENTE,
                                   C.IDCOMISION      IDCOMISION,
                                   --(SELECT NVL(max(1),0) from SICAS_OC.COMPROBANTES_DETALLE CD 
                                   -- WHERE CD.CODCIA     = nota.codcia 
                                   --   AND CD.NUMCOMPROB = CTA.NumComprob 
                                   --   AND (nivelcta1, nivelcta2, nivelcta3, nivelcta4, nivelcta5, NIVELAUX) IN (       
                                   --                       SELECT DISTINCT nivelcta1, nivelcta2, nivelcta3, nivelcta4, nivelcta5, NIVELAUX 
                                   --                         FROM SICAS_OC.PLANTILLAS_CONTABLES PC 
                                   --                        WHERE PC.CODCIA = nota.codcia  AND PC.CODEMPRESA = 1 AND PC.CODPROCESO = '700' AND PC.CODMONEDA = NOTA.Codmoneda AND PC.IDREGFISSAT = nvl(pnj.idregfissat, 612)))  si_resico,
                                   CTA.NumComprob,
                                   --(SELECT Cod_Agente_Distr FROM AGENTES_DISTRIBUCION_POLIZA AD WHERE ROWNUM = 1 AND AD.CodCia      = NOTA.CodCia AND AD.IdPoliza   = C.IDPOLIZA AND AD.CodNivel    = 1) Cod_Agente_Distr,
                                   --(SELECT OC_AGENTES.NOMBRE_AGENTE(c.CodCia, Cod_Agente_Distr)  FROM AGENTES_DISTRIBUCION_POLIZA AD WHERE ROWNUM = 1 AND AD.CodCia      = NOTA.CodCia AND AD.IdPoliza   = C.IDPOLIZA AND AD.CodNivel    = 1) DIR_REG,
                                   T.FechaTransaccion
                              from detalle_nomina dn,
                                   detalle_comision dc,
                                   comisiones c,
                                   detalle_poliza dp,
                                   agentes a,
                                   persona_natural_juridica pnj,
                                   tipos_de_seguros ts,
                                   SICAS_OC.CAT_REGIMEN_FISCAL cat,
                                   NOTAS_DE_CREDITO NOTA,
                                   TRANSACCION T,
                                   COMPROBANTES_CONTABLES CTA
                           WHERE   --dn.idnomina = :nNOMINA  AND
                                   T.IdTransaccion              = NOTA.IdTransacAplic
                               AND T.IdProceso                 IN (17)   -- Pago de Comisiones
                               AND CTA.NumTransaccion = T.IdTransaccion
                               and NOTA.StsNcr                 = 'PAG'
                               AND TRUNC(T.FechaTransaccion) BETWEEN dFecDesde  AND dFecHasta
                               AND NOTA.IDNOMINA               = dn.idnomina  
                               --and nota.idncr                = 33837
                               and c.cod_agente                = decode(nvl(cCodAgente,'%'), '%', c.cod_agente, cCodAgente)
                               and CAT.IDREGFISSAT             =  nvl(pnj.idregfissat, 612)       
                               and dc.idcomision = dn.idcomision
                               and c.idcomision = dc.idcomision
                               and dp.idpoliza = c.idpoliza
                               and dp.idetpol  = (SELECT MIN(DP2.IDETPOL) 
                                                    FROM DETALLE_POLIZA DP2
                                                   WHERE DP2.IDPOLIZA = DP.IDPOLIZA
                                                     AND DP2.CODCIA   = DP.CODCIA)
                               and a.cod_agente = c.cod_agente
                               and pnj.tipo_doc_identificacion = a.tipo_doc_identificacion
                               and pnj.num_doc_identificacion  = a.num_doc_identificacion
                               and ts.idtiposeg = dp.idtiposeg) SAL
                     group by   SAL.CODCIA,
                     						SAL.idnomina,
                                SAL.IDNCR,
                                SAL.STSNCR,
                                SAL.Codmoneda, 
                                SAL.CtaLiquidadora,
                                --si_resico,
                                SAL.NumComprob,                
                                --Cod_Agente_Distr,
                                --DIR_REG,                                          
                                CASE WHEN SAL.CONCEPTO NOT IN ('HONORA', 'COMVDA', 'COMACC', 'IVASIN','RETISR','RETIVA','IVAHON') THEN
                                    SAL.CONCEPTO 
                                ELSE
                                    'COMISI'
                                END, 
                                SAL.RETPORCEN, SAL.ramo, SAL.agente, SAL.codtipo, 
                                SAL.resico, SAL.fecha_liquida, SAL.fecha_movtosicas, 
                                SAL.FechaTransaccion,SAL.rfc_AGENTE) GPO
                    where case when GPO.CODTIPO = 'HONORM' THEN
                            GPO.COMISI + GPO.IVASIN + GPO.RETISR+GPO.RETIVA
                          ELSE
                            GPO.COMISI + GPO.IVASIN + GPO.IVAHON  + GPO.RETISR+ GPO.RETIVA
                        END != 0                
                     order by   GPO.idnomina,
                                GPO.Codmoneda, 
                                GPO.ramo, 
                                GPO.agente, 
                                GPO.codtipo, 
                                GPO.resico, 
                                GPO.fecha_liquida, 
                                GPO.fecha_movtosicas;

        BEGIN 
  SELECT CODUSR
    INTO cCodUser
    FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte;

			  LDEBUG := '1.0';
        IF cFormato = 'TEXTO' THEN
         nLinea     := 1;
         cCadena    := oc_empresas.NOMBRE_COMPANIA(1) || CHR(13);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         nLinea := nLinea + 1;
         cCadena     := 'REPORTE DE PAGOS A AGENTES DEL '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' || TO_CHAR(dFecHasta,'DD/MM/YYYY') || CHR(13);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

         nLinea := nLinea + 1;
         cCadena     := ' ' || CHR(13);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 

         nLinea := nLinea + 1;
         cCadena     := 'No. Nota Crédito'            ||cLimitador||
                        'Status NC'                   ||cLimitador||
                        'No. de Control'              ||cLimitador|| 
                        'Cta. Liquidadora'            ||cLimitador||
                        'Código Agente'               ||cLimitador||
                        'Nombre Agente'               ||cLimitador||
                        'RFC Agente'                  ||cLimitador||
                        'No. Comprobante'             ||cLimitador||
                        'Código Direc. Reg.'          ||cLimitador|| 
                        'Nombre Dirección Regional'   ||cLimitador||
                        'Nivel Agte.'                 ||cLimitador||
                        'Tipo Agte.'                  ||cLimitador||
                        'Fecha de Pago'               ||cLimitador|| 
                        'No.Fact.Agente'              ||cLimitador|| 
                        'Moneda'                      ||cLimitador||
                        'Concepto'                    ||cLimitador||
                        'Ramo'                        ||cLimitador||
                        'Comision/Honorarios/UDIs (MXN)' ||cLimitador||
                        'IVA (MXN)'                   ||cLimitador||
                        'IVA Honorarios (MXN)'        ||cLimitador||
                        'Total (MXN)'                 ||cLimitador||
                        'Ret. ISR 10% (MXN)'          ||cLimitador||
                        'Ret. ISR RESICO 1.25% (MXN)' ||cLimitador|| 
                        'Ret. IVA (MXN)'              ||cLimitador|| 
                        'Total Retenciones (MXN'      ||cLimitador||
                        'Monto del Pago'              ||cLimitador||
                        'Reg SAT'                     ||cLimitador||
                        CHR(13);   
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
        ELSE
         nLinea := 1;
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
                          '          {mso-number-format:"dd\\-mmm\\-yyyy";}'||chr(10)||
                          '    -->'||chr(10)||
                          ' </style><div id="libro">'||chr(10);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
				 LDEBUG := '2.0';
         nLinea := nLinea + 1;
         cCadena     := '<table border = 0><tr><th>' || oc_empresas.NOMBRE_COMPANIA(1) || '</th></tr>'; 
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

         nLinea := nLinea + 1;
         cCadena     := '<tr><th>REPORTE DE PAGOS A AGENTES  DEL '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' ||
                         TO_CHAR(dFecHasta,'DD/MM/YYYY') || '</th></tr>'; 
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

         nLinea := nLinea + 1;
         cCadena     := '<tr><th>  </th></tr></table>'; 
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

         nLinea := nLinea + 1;
         cCadena     := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Nota Crédito</font></th>' ||
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Status NC</font></th>'                  ||
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Control</font></th>'             ||
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Cta. Liquidadora</font></th>'           ||
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Agente</font></th>'              || 
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Agente</font></th>'              ||
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RFC Agente</font></th>'                 ||
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Comprobante</font></th>'            ||
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Direc. Reg.</font></th>'         ||
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Dirección Regional</font></th>'  ||
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nivel Agte.</font></th>'                ||
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Agte.</font></th>'                 ||
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de Pago</font></th>'              ||    
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No.Fact.Agente</font></th>'             ||                                 
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Moneda</font></th>'                     ||    
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Concepto</font></th>'                   ||                                                         
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Ramo</font></th>'                       ||
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comision/Honorarios/UDIs (MXN)</font></th>' ||
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IVA (MXN)</font></th>'                  ||
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IVA Honorarios (MXN)</font></th>'       ||
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total (MXN)</font></th>'                ||
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Ret. ISR 10% (MXN)</font></th>'         ||
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Ret. ISR RESICO 1.25 (MXN)</font></th>' ||
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Ret. IVA (MXN)</font></th>'             ||
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total retenciones (MXN)</font></th>'    ||                     
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto del Pago</font></th>'             ||          
                        '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Reg SAT</font></th>'                                                                                                            
                        ; 
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
        END IF;
        --
				LDEBUG := '3.0';        
        FOR X IN NC_Q LOOP
            --
              SELECT NVL(MAX(NumFactExt),'S/F')
                INTO cNumFactExt
                FROM NCR_FACTEXT N, FACTURA_EXTERNA F
               WHERE F.IdeFactExt = N.IdeFactExt
                 AND N.IdNcr      = X.IdNcr;
            --
						LDEBUG := '4.0';        
            BEGIN
               SELECT NVL(max(1),0)
                 INTO si_resico 
                 FROM COMPROBANTES_DETALLE CD 
                WHERE CD.CODCIA     = X.codcia 
                  AND CD.NUMCOMPROB = X.NumComprob 
                  AND (nivelcta1, nivelcta2, nivelcta3, nivelcta4, nivelcta5, NIVELAUX) IN (       
                                      SELECT DISTINCT nivelcta1, nivelcta2, nivelcta3, nivelcta4, nivelcta5, NIVELAUX 
                                        FROM SICAS_OC.PLANTILLAS_CONTABLES PC 
                                       WHERE PC.CODCIA = X.codcia  
                                         AND PC.CODEMPRESA = 1 
                                         AND PC.CODPROCESO = '700' 
                                         AND PC.CODMONEDA = X.Codmoneda 
                                         AND PC.IDREGFISSAT = 626);
            		LDEBUG := '4.1';        
            EXCEPTION WHEN OTHERS THEN
                si_resico := 0;
            END;

            NRETISR     := CASE WHEN nvl(si_resico, 0) = 1 THEN 0 ELSE X.RETISR END;
            NISR_RESICO := CASE WHEN nvl(si_resico, 0) = 1 THEN X.RETISR ELSE 0 END;
            
            LDEBUG := '4.2';

            BEGIN
                 SELECT Cod_Agente_Distr, OC_AGENTES.NOMBRE_AGENTE(CodCia, Cod_Agente_Distr)
                   INTO nCodDirecReg,     cNombreDirecReg
                   FROM AGENTES_DISTRIBUCION_POLIZA
                  WHERE CodCia      = X.CodCia
                    AND IdPoliza   IN (SELECT MAX(IdPoliza)
                                         FROM COMISIONES C, DETALLE_NOMINA D
                                        WHERE C.IdComision = D.IdComision
                                          AND C.CodCia     = D.CodCia
                                          AND D.IdNomina   = X.IdNomina
                                          AND D.CodCia     = X.CodCia)
                    AND CodNivel    = 1;
                    LDEBUG := '4.3';
            EXCEPTION WHEN NO_DATA_FOUND THEN
                        nCodDirecReg    := 0;
                        cNombreDirecReg := 'SIN DIRECCION REGIONAL';
                      WHEN TOO_MANY_ROWS THEN
                        BEGIN
                           SELECT MAX(Cod_Agente_Distr)
                             INTO nCodDirecReg
                             FROM AGENTES_DISTRIBUCION_POLIZA
                            WHERE CodCia      = X.CodCia
                              AND IdPoliza   IN (SELECT MAX(IdPoliza)
                                                   FROM COMISIONES C, DETALLE_NOMINA D
                                                  WHERE C.IdComision = D.IdComision
                                                    AND C.CodCia     = D.CodCia
                                                    AND D.IdNomina   = X.IdNomina
                                                    AND D.CodCia     = X.CodCia)
                              AND CodNivel    = 1;
                				   LDEBUG := '4.4';
                           cNombreDirecReg := OC_AGENTES.NOMBRE_AGENTE(X.CodCia, nCodDirecReg);
                        END;
            END;
              --    
              LDEBUG := '4.5';
              IF cFormato = 'TEXTO' THEN
                 cCadena := TO_CHAR(X.IdNcr,'9999999999999')               ||cLimitador||
                            X.StsNcr                                       ||cLimitador||
                            TO_CHAR(X.IdNomina,'9999999999999')            ||cLimitador||
                            X.CtaLiquidadora                               ||cLimitador||
                            TO_CHAR(X.AGENTE,'9999999999999')          ||cLimitador||
                            X.NOMBRE_AGENTE                                 ||cLimitador||
                            x.RFC_AGENTE                                ||cLimitador|| 
                            X.NUMCOMPROB                                    ||cLimitador||
                            TO_CHAR(nCodDirecReg,'99999999999990')         ||cLimitador||
                            cNombreDirecReg                                 ||cLimitador||                                    
                            X.NivelAgente                                  ||cLimitador||
                            X.CODTIPO                                    ||cLimitador||
                            TO_CHAR(X.FechaTransaccion,'DD/MM/YYYY')       ||cLimitador||
                            cNumFactExt                                    ||cLimitador||
                            X.CODMONEDA                                    ||cLimitador||
                            X.concepto                                         ||cLimitador||                    
                            X.Ramo                                             ||cLimitador||
                            TO_CHAR(X.MONTO_COMISION,'99999999999990.00')         ||cLimitador||
                            TO_CHAR(X.IVASIN,'99999999999990.00')           ||cLimitador||
                            TO_CHAR(X.IVAHON,'99999999999990.00')        ||cLimitador||             
                            TO_CHAR(X.MONTO_TOTAL,'99999999999990.00') ||cLimitador||
                            TO_CHAR(NRETISR,'99999999999990.00')           ||cLimitador||
                            TO_CHAR(NISR_RESICO,'99999999999990.00')     ||cLimitador||                                    
                            TO_CHAR(X.RETIVA,'99999999999990.00')           ||cLimitador||
                            TO_CHAR(X.TOT_RETENCIONES,'99999999999990.00')     ||cLimitador||
                            TO_CHAR(X.MONTO_PAGO,'99999999999990.00') ||cLimitador||
                            X.RESICO ||
                            CHR(13); 
              ELSE
              	 LDEBUG := '4.6';
                 cCadena := '<tr>' || OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdNcr,'9999999999999'),'C')               ||
                            OC_ARCHIVO.CAMPO_HTML(X.StsNcr,'C')                                       ||
                            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdNomina,'9999999999999'),'C')            ||
                            OC_ARCHIVO.CAMPO_HTML(X.CtaLiquidadora,'C')                               ||
                            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.AGENTE,'9999999999999'),'C')          ||
                            OC_ARCHIVO.CAMPO_HTML(X.NOMBRE_AGENTE,'C')                                 ||
                            OC_ARCHIVO.CAMPO_HTML(X.RFC_AGENTE,'C')                                || 
                            OC_ARCHIVO.CAMPO_HTML(X.NUMCOMPROB,'C')                                    ||
                            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nCodDirecReg,'99999999999990'),'C')         ||
                            OC_ARCHIVO.CAMPO_HTML(cNombreDirecReg,'C')                                 ||                                    
                            OC_ARCHIVO.CAMPO_HTML(X.NivelAgente,'C')                                  ||
                            OC_ARCHIVO.CAMPO_HTML(X.CODTIPO,'C')                                    ||
                            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FechaTransaccion,'DD/MM/YYYY') ,'C')      ||
                            OC_ARCHIVO.CAMPO_HTML(cNumFactExt,'C')                                    ||
                            OC_ARCHIVO.CAMPO_HTML(X.CODMONEDA ,'C')                                   ||
                            OC_ARCHIVO.CAMPO_HTML(X.concepto,'C')                                         ||                    
                            OC_ARCHIVO.CAMPO_HTML(X.Ramo,'C')                                             ||
                            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MONTO_COMISION,'99999999999990.00'),'N')         ||
                            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IVASIN,'99999999999990.00'),'N')           ||
                            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IVAHON,'99999999999990.00') ,'N')       ||             
                            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MONTO_TOTAL,'99999999999990.00'),'N') ||
                            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(NRETISR,'99999999999990.00'),'N')           ||
                            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(NISR_RESICO,'99999999999990.00'),'N')     ||                                    
                            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.RETIVA,'99999999999990.00'),'N')           ||
                            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.TOT_RETENCIONES,'99999999999990.00'),'N')     ||
                            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MONTO_PAGO,'99999999999990.00'),'N') ||
                            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.RESICO,'999'),'C') ||
                            '</tr>'; 
            -----
              END IF;
              nLinea := nLinea + 1;
              LDEBUG := '4.7';
              OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
        END LOOP; 
        LDEBUG := '5.0';
        IF cFormato = 'EXCEL' THEN
            OC_ARCHIVO.Escribir_Linea('</table></div></html>', cCodUser, 9999);
        END IF;
        LDEBUG := '6.0';
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
  INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
    SELECT nIdReporte + 1,
           B.TIPO_REPORTE,
           B.CODUSR,
           SYSDATE,
           'GEN',
           A.DATA,
           B.FILE_NAME
      FROM SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
     WHERE A.CODUSER = B.CODUSR
       AND B.IDEXTRACCION = nIdReporte;
  DELETE SICAS_OC.EXTRACCION_DE_REPORTES WHERE IDEXTRACCION = nIdReporte;
  OC_ARCHIVO.Eliminar_Archivo(cCodUser);
EXCEPTION  WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      raise_application_error(-20105,'Error en Generación de Listado de Pago de Agentes' || ' ' ||SQLERRM); 

END;
                        
END REPORTE_AGENTES;

/

GRANT EXECUTE ON SICAS_OC.REPORTE_AGENTES TO PUBLIC;

/

CREATE PUBLIC SYNONYM REPORTE_AGENTES FOR SICAS_OC.REPORTE_AGENTES;