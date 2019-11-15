CREATE OR REPLACE PROCEDURE SICAS_OC.oc_integrado_contable( dFecDesde     DATE
                                                          , dFecHasta     DATE
                                                          , cTipoComprob  VARCHAR2
                                                          , cFormato      VARCHAR2
                                                          , cNombreCia    VARCHAR2
                                                          , cCodUser      VARCHAR2
                                                          , cStsComprob   VARCHAR2 ) IS
   cLimitador           VARCHAR2(1) :='|';
   nLinea               NUMBER;
   cCadena              VARCHAR2(32700);
   cDinamico            VARCHAR2(32700);
   cValor               VARCHAR2(50);
   cDebCredito          VARCHAR2(7);
   nNumComprob          COMPROBANTES_CONTABLES.NumComprob%TYPE;
   cIdCtaContable       CATALOGO_CONTABLE.IdCtaContable%TYPE;
   cNumPoliza           DETALLE_TRANSACCION.Valor1%TYPE;
   cSubGrupo            DETALLE_TRANSACCION.Valor1%TYPE;
   cRecibo              DETALLE_TRANSACCION.Valor1%TYPE;
   --
   nIdPoliza            NUMBER;
   nIdetPol             NUMBER;
   nIdSiniestro         NUMBER;
   nIdDetSin            NUMBER;
   nNum_Aprobacion      NUMBER;
   nCod_Asegurado       NUMBER;
   nCodCliente          NUMBER;
   nIdFactura           NUMBER;
   nIdNcr               NUMBER;
   --
   cNomContratante      VARCHAR2(250);
   cFecIniVigPol        VARCHAR2(250);
   cFecFinVigPol        VARCHAR2(250);
   cNomBenef            VARCHAR2(250);
   cNomAsegu            VARCHAR2(250);
   CNumPolUnico         VARCHAR2(250);
   --
   cNivelAux            COMPROBANTES_DETALLE.NIVELAUX%TYPE;
   cFecIniVigRec        VARCHAR2(250);
   cFecFinVigRec        VARCHAR2(250);
   cTipoAdministracion  VARCHAR2(250);
   cIdTipoSeg           VARCHAR2(250);
   cCodFilial           VARCHAR2(250);
   cCodDirecRegional    VARCHAR2(250);
   cNomDirecRegional    VARCHAR2(250);
   nImpComDR            NUMBER := 0;
   cCodPromotor         VARCHAR2(250);
   cNomPromotor         VARCHAR2(250);
   nImpComPromotor      NUMBER := 0;
   nCveAgente           NUMBER;
   cNomAgente           VARCHAR2(250);
   nImpComAgente        NUMBER := 0;
   cCodPrestadorServ1   VARCHAR2(250);
   cNomPrestadorServ1   VARCHAR2(250);
   nImpComPresServ1     NUMBER := 0;
   cCodPrestadorServ2   VARCHAR2(250);
   cNomPrestadorServ2   VARCHAR2(250);
   nImpComPresServ2     NUMBER := 0;
   --
   nContPresServ        NUMBER;
   cEsPresServ          VARCHAR2(1);
   cNomPresServ         VARCHAR2(250);
   --
   CURSOR CTA_Q IS 
      SELECT D.CodCia
           , D.NumComprob
           , C.TipoComprob
           , D.IdDetCuenta
           , D.FecDetalle
           , T.CodSubProceso
           , T.Objeto
           , T.Valor1
           , T.Valor2
           , T.Valor3
           , T.Valor4
           , D.NivelCta1
           , D.NivelCta2
           , D.NivelCta3
           , D.NivelCta4
           , D.NivelCta5
           , D.NivelCta6
           , D.NivelCta7
           , D.NivelAux
           , D.MovDebCred
           , D.MtoMovCuenta
           , D.DescMovCuenta
           , D.CodCentroCosto
           , D.CodUnidadNegocio
           , D.DescCptoGeneral
           , D.MtoMovCuentaLocal
           , T.Valor1        NumPoliza
           , T.Valor3        SubGrupo
           , T.Valor4        Recibo
           , C.FecEnvioSC    FechaDerivacion
           , C.NumComprobSC  NumComprobMizar
           , DECODE(C.NumComprobSC,NULL,NULL,C.TipoDiario) TipoDiario                   
           , C.CodMoneda
          FROM COMPROBANTES_CONTABLES  C
             , DETALLE_TRANSACCION     T
             , COMPROBANTES_DETALLE    D
             , SUB_PROCESO             S
         WHERE C.FecComprob   BETWEEN dFecDesde AND dFecHasta
           AND C.TipoComprob        = NVL(cTipoComprob,C.TipoComprob)
           AND C.StsComprob         = DECODE(cStsComprob, 'TODOS', C.StsComprob, cStsComprob )
           AND T.IdTransaccion      = C.NumTransaccion
           AND T.CodCia             = C.CodCia 
           AND T.CodEmpresa         = 1              
           AND D.CodCia             = C.CodCia
           AND D.NumComprob         = C.NumComprob     
           AND D.IdDetCuenta        = D.IdDetCuenta
           AND S.CodProcesoCont     = C.TipoComprob
           AND S.IndGenContabilidad = 'S'
           and S.CodSubProceso      = T.CodSubProceso
         ORDER BY C.TipoComprob, D.NumComprob, d.IdDetCuenta;
   --
   CURSOR COL_Q IS
      SELECT ROWNUM Num  --CHR(10)
           , Campo
           , Etiqueta || DECODE(cFormato , 'TEXTO' , NULL, ' ') || '(' || lower(CAMPO) || ')' ETIQUETA
        FROM ( SELECT DISTINCT CAMPO
                    , MAX(L.ETIQUETA) ETIQUETA
                 FROM PROC_TAREA          P
                    , SUB_PROCESO         S
                    , OBJETO              O
                    , LLAVES              L
                    , PROCESOS_CONTABLES  PC         
                WHERE S.INDGENCONTABILIDAD = 'S'
                  AND S.IDPROCESO          = P.IDPROCESO          
                  AND O.IDPROCESO          = S.IDPROCESO 
                  AND O.CODSUBPROCESO      = S.CODSUBPROCESO      
                  AND L.IDPROCESO          = O.IDPROCESO
                  AND L.CODSUBPROCESO      = O.CODSUBPROCESO
                  AND L.IDOBJETO           = O.IDOBJETO
                  AND PC.CODPROCESO        = S.CODPROCESOCONT       
                  AND (S.CODSUBPROCESO, O.IDOBJETO) IN ( SELECT DISTINCT T.CODSUBPROCESO
                                                              , T.OBJETO  
                                                           FROM COMPROBANTES_CONTABLES  C
                                                              , DETALLE_TRANSACCION     T
                                                              , COMPROBANTES_DETALLE    D
                                                          WHERE C.FecComprob    BETWEEN dFecDesde AND dFecHasta
                                                            AND C.TipoComprob    = NVL(cTipoComprob,C.TipoComprob)
                                                            AND C.StsComprob     = DECODE(cStsComprob, 'TODOS', C.StsComprob, cStsComprob )
                                                            AND T.IdTransaccion  = C.NumTransaccion
                                                            AND T.CODCIA         = C.CODCIA 
                                                            AND T.CODEMPRESA     = 1              
                                                            AND D.CodCia         = C.CodCia
                                                            AND D.NumComprob     = C.NumComprob
                                                            AND D.IDDETCUENTA    = D.IDDETCUENTA                                
             )
      GROUP BY CAMPO
      ORDER BY MAX(L.ETIQUETA));
   --
   CURSOR REG_Q (P_CODPROCESOCONT VARCHAR2, P_CODSUBPROCESO VARCHAR2, P_IDOBJETO VARCHAR2) IS
      SELECT CODPROCESOCONT
           , CODSUBPROCESO
           , IDOBJETO
           , MAX(VALOR1) XVALOR1
           , MAX(VALOR2) XVALOR2
           , MAX(VALOR3) XVALOR3
           , MAX(VALOR4) XVALOR4
        FROM ( SELECT S.CODPROCESOCONT
                    , P.TIPOPROCESO
                    , P.DESCRIPCION_PROCESO
                    , S.CODSUBPROCESO
                    , O.IDOBJETO
                    , CASE WHEN L.ORDEN = 1 THEN CAMPO ELSE NULL END VALOR1
                    , CASE WHEN L.ORDEN = 2 THEN CAMPO ELSE NULL END VALOR2
                    , CASE WHEN L.ORDEN = 3 THEN CAMPO ELSE NULL END VALOR3
                    , CASE WHEN L.ORDEN = 4 THEN CAMPO ELSE NULL END VALOR4
                 FROM PROC_TAREA          P
                    , SUB_PROCESO         S
                    , OBJETO              O
                    , LLAVES              L
                    , PROCESOS_CONTABLES  PC         
                WHERE S.INDGENCONTABILIDAD = 'S'
                  AND S.IDPROCESO          = P.IDPROCESO          
                  AND O.IDPROCESO          = S.IDPROCESO 
                  AND O.CODSUBPROCESO      = S.CODSUBPROCESO      
                  AND L.IDPROCESO          = O.IDPROCESO
                  AND L.CODSUBPROCESO      = O.CODSUBPROCESO
                  AND L.IDOBJETO           = O.IDOBJETO
                  AND PC.CODPROCESO        = S.CODPROCESOCONT
                  AND PC.CODCIA            = 1
                  AND O.CODSUBPROCESO      = P_CODSUBPROCESO
                  AND O.IDOBJETO           = P_IDOBJETO 
                  AND S.CODPROCESOCONT     = P_CODPROCESOCONT)
               GROUP BY CODPROCESOCONT
                      , CODSUBPROCESO
                      , IDOBJETO;
   --
   CURSOR c_comisiones ( c_nCodCia NUMBER, c_nIdPoliza NUMBER, c_nIdetPol NUMBER ) IS
      SELECT CODNIVEL, COD_AGENTE_DISTR, PORC_COM_DISTRIBUIDA
        FROM AGENTES_DISTRIBUCION_COMISION
       WHERE CodCia   = c_nCodCia
         AND IdPoliza = c_nIdPoliza
         AND IdetPol  = c_nIdetPol
       ORDER BY CODNIVEL;
   --
   CURSOR c_pol_comisiones ( c_nIdNcr NUMBER ) IS
      SELECT C.IdPoliza, C.Cod_Agente, SUM(C.Comision_Moneda) Monto
      FROM   NOTAS_DE_CREDITO  A
         ,   DETALLE_NOMINA    B
         ,   COMISIONES        C
      WHERE  A.IdNcr      = c_nIdNcr
        AND  B.IdNomina   = A.IdNomina
        AND  C.IdComision = B.IdComision
        AND  C.Cod_Agente = B.Cod_Agente
      GROUP BY C.IdPoliza, C.Cod_Agente;
BEGIN 
   IF cFormato = 'TEXTO' THEN
      nLinea  := 1;
      cCadena := cNombreCia;
--      DBMS_OUTPUT.PUT_LINE('THONA SEGUROS');
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
      --
      nLinea  := nLinea + 1;
      cCadena := 'REPORTE INTEGRADO DE COMPROBANTES Y CUENTAS CONTABLES DEL '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' || TO_CHAR(dFecHasta,'DD/MM/YYYY') || CHR(13);
--      DBMS_OUTPUT.PUT_LINE(cCadena);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
      --
       nLinea  := nLinea + 1;
       cCadena := ' ' || CHR(13);
--       DBMS_OUTPUT.PUT_LINE(cCadena);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
      --
      nLinea := nLinea + 1;
      --
      FOR C IN COL_Q LOOP
         cDinamico := cDinamico || C.Etiqueta || cLimitador;
      END LOOP; 
      --
      cCadena := 'No. de Comprobante'                        || cLimitador ||
                 'Consecutivo'                               || cLimitador ||
                 'Tipo Comprobante'                          || cLimitador ||
                 'Descripción del Tipo de Comprobante'       || cLimitador ||
                 'No. Póliza MIZAR'                          || cLimitador ||
                 'Fecha Derivación MIZAR'                    || cLimitador ||
                 'No.Póliza Único'                           || cLimitador ||
                 'Cuenta Contable'                           || cLimitador ||
                 'Auxiliar Contable'                         || cLimitador || 
                 'Débito/Crédito'                            || cLimitador ||
                 'Monto'                                     || cLimitador ||
                 'Unidad de Negocio'                         || cLimitador ||
                 'Concepto General'                          || cLimitador ||
                 'Nombre del Contratante'                    || cLimitador ||
                 'Centro de Costos'                          || cLimitador ||
                 'Inicio de Vigencia de la Póliza'           || cLimitador ||
                 'Fin de Vigencia de la Póliza'              || cLimitador ||
                 'Forma de Administración'                   || cLimitador ||
                 'Tipo de Seguro'                            || cLimitador ||
                 'SubProc'                                   || cLimitador ||
                 'Fecha Transacción'                         || cLimitador ||
                 'Nombre del Beneficiario'                   || cLimitador ||
                 'Nombre del Asegurado'                      || cLimitador ||
                 'Nombre del Subgrupo'                       || cLimitador ||
                 'Clave DR'                                  || cLimitador ||
                 'Nombre de la DR'                           || cLimitador ||
                 'Importe Comisión DR'                       || cLimitador ||
                 'Clave Promotor'                            || cLimitador ||
                 'Nombre del Promotor'                       || cLimitador ||
                 'Importe Comisión Promotor'                 || cLimitador ||
                 'Clave del Agente'                          || cLimitador ||
                 'Nombre del Agente'                         || cLimitador ||
                 'Importe Comisión Agente'                   || cLimitador ||
                 'Clave Prestador de Servicio 1'             || cLimitador ||
                 'Nombre Prestador de Servicio 1'            || cLimitador ||
                 'Importe Pago del Prestador de Servicio 1'  || cLimitador ||
                 'Clave Prestador de Servicio 2'             || cLimitador ||
                 'Nombre Prestador de Servicio 2'            || cLimitador ||
                 'Importe Pago del Prestador de Servicio 2'  || cLimitador ||
                 cDinamico                                   || cLimitador ||
                 'Inicio de Vigencia del Recibo o NC'        || cLimitador ||
                 'Fin de Vigencia del Recibo o NC'           || cLimitador ||
                 'Moneda' || CHR(13);

--      DBMS_OUTPUT.PUT_LINE(cCadena);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   ELSE 
      nLinea  := 1;
      cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"' || chr(10) ||
                 ' xmlns:x="urn:schemas-microsoft-com:office:excel"'       || chr(10) ||
                 ' xmlns="http://www.w3.org/TR/REC-html40">'               || chr(10) ||
                 ' <style id="libro">'                                     || chr(10) ||
                 '   <!--table'                                            || chr(10) ||
                 '       {mso-displayed-decimal-separator:"\.";'           || chr(10) ||
                 '        mso-displayed-thousand-separator:"\,";}'         || chr(10) ||
                 '        .texto'                                          || chr(10) ||
                 '          {mso-number-format:"\@";}'                     || chr(10) ||
                 '        .numero'                                         || chr(10) ||
                 '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}' || chr(10) ||
                 '        .fecha'                                          || chr(10) ||
                 '          {mso-number-format:"dd\\-mmm\\-yyyy";}'        || chr(10) ||
                 '    -->'                                                 || chr(10) ||
                 ' </style><div id="libro">'                               || chr(10);
--      DBMS_OUTPUT.PUT_LINE(cCadena);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      --
      nLinea  := nLinea + 1;
      cCadena     := '<table border = 0><tr><th>' || cNombreCia || '</th></tr>'; 
--      DBMS_OUTPUT.PUT_LINE(cCadena);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      --
      nLinea  := nLinea + 1;
      cCadena := '<tr><th>REPORTE INTEGRADO DE COMPROBANTES Y CUENTAS CONTABLES DEL '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' AL ' || TO_CHAR(dFecHasta,'DD/MM/YYYY') || '</th></tr>'; 
--      DBMS_OUTPUT.PUT_LINE(cCadena);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      --
      nLinea  := nLinea + 1;
      cCadena := '<tr><th>  </th></tr></table>'; 
--      DBMS_OUTPUT.PUT_LINE(cCadena);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      --
      nLinea  := nLinea + 1;
      --
      FOR C IN COL_Q LOOP
         cDinamico := cDinamico || '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">' || C.Etiqueta || '</font></th>';
      END LOOP; 
      --
      cCadena := '<table border = 1><tr>'                                                                                          ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Comprobante</font></th>'                       ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Consecutivo</font></th>'                              ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Comprobante</font></th>'                         ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descripción del Tipo de Comprobante</font></th>'      ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Póliza MIZAR</font></th>'                         ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Derivación MIZAR</font></th>'                   ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No.Póliza Único</font></th>'                          ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Cuenta Contable</font></th>'                          || 
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Auxiliar Contable</font></th>'                        ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Débito/Crédito</font></th>'                           ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto</font></th>'                                    ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Unidad de Negocio</font></th>'                        ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Concepto General</font></th>'                         ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre del Contratante</font></th>'                   ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Centro de Costos</font></th>'                         ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Inicio de Vigencia de la Póliza</font></th>'          ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fin de Vigencia de la Póliza</font></th>'             ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Forma de Administración</font></th>'                  ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo de Seguro</font></th>'                           ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">SubProc</font></th>'                                  ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Transacción</font></th>'                        ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre del Beneficiario</font></th>'                  ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre del Asegurado</font></th>'                     ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre del SubGrupo</font></th>'                      ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Clave DR</font></th>'                                 ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre de la DR</font></th>'                          ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Importe Comisión DR</font></th>'                      ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Clave Promotor</font></th>'                           ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre del Promotor</font></th>'                      ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Importe Comisión Promotor</font></th>'                ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Clave del Agente</font></th>'                         ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre del Agente</font></th>'                        ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Importe Comisión Agente</font></th>'                  ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Clave Prestador de Servicio 1</font></th>'            ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Prestador de Servicio 1</font></th>'           ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Importe Pago del Prestador de Servicio 1</font></th>' ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Clave Prestador de Servicio 2</font></th>'            ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Prestador de Servicio 2</font></th>'           ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Importe Pago del Prestador de Servicio 2</font></th>' ||
                 cDinamico                                                                                                         ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Inicio de Vigencia del Recibo o NC</font></th>'       ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fin de Vigencia del Recibo o NC</font></th>'          ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Moneda</font></th></tr>';
      --La cadena excede la longitud máxima de la función OC_ARCHIVO.Escribir_Linea que es VARCHAR2(4000), por lo que se divide en 2 partes
      OC_ARCHIVO.Escribir_Linea(SUBSTR(cCadena, 1, 3000), cCodUser, nLinea);
      OC_ARCHIVO.Escribir_Linea(SUBSTR(cCadena, 3000), cCodUser, nLinea);
   END IF;
   --
   FOR x IN CTA_Q LOOP
      --
      cDinamico       := NULL;          
      --
      nIdPoliza       := NULL;
      nIdetPol        := NULL;
      nIdSiniestro    := NULL;
      nIdDetSin       := NULL;
      nNum_Aprobacion := NULL;
      --
      cNomContratante := NULL;
      nCveAgente      := NULL;
      cNomAgente      := NULL;
      cFecIniVigPol   := NULL;
      cFecFinVigPol   := NULL;
      cNomBenef       := NULL;
      cNomAsegu       := NULL;
      nCod_Asegurado  := NULL;
      cNumPolUnico    := NULL;
      --          
      FOR Reg IN REG_Q(x.TipoComprob, x.CodSubProceso, x.Objeto) LOOP
         cNumPoliza  := NULL;
         cSubGrupo   := NULL;
         cRecibo     := NULL;
         --
         IF X.TipoComprob NOT IN ('800','801','802') THEN
            cNumPoliza  := X.NumPoliza;
            cSubGrupo   := X.SubGrupo;
            cRecibo     := X.Recibo;
         ELSE
            BEGIN
               SELECT IdPoliza, IDetPol, X.NumPoliza
                 INTO cNumPoliza, cSubGrupo, cRecibo
                 FROM PRIMAS_DEPOSITO
                WHERE IdPrimaDeposito = TO_NUMBER(X.NumPoliza);
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cNumPoliza := NULL;
               cSubGrupo  := NULL;
               cRecibo    := NULL;
            END;
         END IF;       
         --
         nNumComprob := X.NumComprob;
         --
         IF x.MovDebCred = 'D' THEN
            cDebCredito := 'Débito';
         ELSE
            cDebCredito := 'Crédito';
         END IF;
         --
         cIdCtaContable := LPAD(TRIM(TO_CHAR(x.CodCia)),14,'0') || x.NivelCta1 || x.NivelCta2 ||x.NivelCta3 || 
                           x.NivelCta4 || x.NivelCta5 || x.NivelCta6 || x.NivelCta7 || x.NivelAux;
         cNivelAux      := x.NivelAux;
         cNumPoliza     := NULL;
         --         
         FOR c IN COL_Q LOOP
            CASE C.CAMPO 
               WHEN Reg.xValor1 THEN cValor :=  x.Valor1;
               WHEN Reg.xValor2 THEN cValor :=  x.Valor2;
               WHEN Reg.xValor3 THEN cValor :=  x.Valor3;
               WHEN Reg.xValor4 THEN cValor :=  x.Valor4;
               ELSE cValor := NULL;
            END CASE;                                            
            --
            IF c.Campo = 'IDPOLIZA' THEN
               nIdPoliza := cValor;
            ELSIF c.Campo = 'IDETPOL' THEN
               nIdetPol := cValor;
            ELSIF c.Campo = 'IDSINIESTRO' THEN
               nIdSiniestro := cValor;
            ELSIF c.Campo = 'IDDETSIN' THEN
               nIdDetSin := cValor;
            ELSIF c.Campo = 'NUM_APROBACION' THEN
               nNum_Aprobacion := cValor;
            ELSIF c.Campo = 'IDNCR' THEN
               IF X.TipoComprob = 700 THEN
                  nIdNcr := x.Valor4;
                  cValor := x.Valor4;
               ELSE
                  nIdNcr := cValor;
               END IF;
            ELSIF c.Campo = 'IDFACTURA' THEN
               nIdFactura := cValor;
            END IF;
            --                    
            IF c.Campo = Reg.xValor1 OR c.Campo = Reg.xValor2 OR c.campo = Reg.xValor3 OR c.campo = Reg.xValor4 THEN
               IF cFormato = 'TEXTO' THEN
                  cDinamico := cDinamico ||  cValor|| cLimitador;
               ELSE
                  cDinamico := cDinamico || OC_ARCHIVO.CAMPO_HTML( cValor, 'C');
               END IF;
            ELSE
               IF cFormato = 'TEXTO' THEN
                  cDinamico := cDinamico || NULL || cLimitador;
               ELSE
                  cDinamico := cDinamico ||OC_ARCHIVO.CAMPO_HTML( NULL , 'C');
               END IF;
            END IF;
         END LOOP;
         -- 
         IF nIdNcr IS NOT NULL THEN
            BEGIN
               SELECT TO_CHAR(FECSTS, 'DD/MM/YYYY'), TO_CHAR(FECFINVIG, 'DD/MM/YYYY')
               INTO   cFecIniVigRec, cFecFinVigRec
               FROM   NOTAS_DE_CREDITO
               WHERE  IDNCR = nIdNcr;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cFecIniVigRec := NULL;
               cFecFinVigRec := NULL;
            END;
         END IF;
         --
         IF nIdFactura IS NOT NULL THEN
            BEGIN
               SELECT TO_CHAR(F.FecVenc, 'DD/MM/YYYY'), TO_CHAR(F.FecFinVig, 'DD/MM/YYYY')
               INTO   cFecIniVigRec, cFecFinVigRec
               FROM   FACTURAS F
               WHERE  F.IdFactura = nIdFactura;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cFecIniVigRec := NULL;
               cFecFinVigRec := NULL;
            END;
         END IF;
         --
         IF x.TipoComprob in (500, 510, 600, 610) THEN --SINIESTROS
            cFecIniVigRec := NULL;
            cFecFinVigRec := NULL;
         END IF;
         --
         IF nIdSiniestro IS NOT NULL THEN
            BEGIN
               SELECT Cod_Asegurado, S.IdetPol, S.IdPoliza  
                 INTO nCod_Asegurado, nIdetPol, nIdPoliza
                 FROM SINIESTRO S
                WHERE S.IdSiniestro = nIdSiniestro;
            EXCEPTION
            WHEN OTHERS THEN
               nCod_Asegurado := NULL;
               nIdetPol       := NULL;                          
            END;
            --     
         END IF;
         --
         IF nIdetPol IS NULL THEN 
            nIdetPol :=  1;
         END IF;
         --
         IF nIdPoliza IS NOT NULL THEN
            BEGIN
               SELECT po.Cod_Agente, po.CodCliente, TO_CHAR(po.FecIniVig, 'DD/MM/YYYY'), TO_CHAR(po.FecFinVig, 'DD/MM/YYYY'), po.NumPolUnico, po.TipoAdministracion
                 INTO nCveAgente, nCodCliente, cFecIniVigPol, cFecFinVigPol, cNumPolUnico, cTipoAdministracion 
                 FROM POLIZAS PO
                WHERE po.IdPoliza  = nIdPoliza
                  AND po.CodCia    = x.CodCia;                           
            EXCEPTION
            WHEN OTHERS THEN
               nCveAgente    := NULL;
               nCodCliente   := NULL;
               cFecIniVigPol := NULL;
               cFecFinVigPol := NULL;                    
            END;         
           --
            IF nCod_Asegurado IS NULL THEN             
               BEGIN
                  SELECT DP.Cod_Asegurado, DP.IdTipoSeg, DP.CodFilial
                    INTO nCod_Asegurado, cIdTipoSeg, cCodFilial
                    FROM DETALLE_POLIZA DP
                   WHERE DP.IdPoliza = nIdPoliza
                     AND DP.IdetPol  = nIdetPol;                           
               EXCEPTION
               WHEN OTHERS THEN
                  nCod_Asegurado := NULL;
                  cIdTipoSeg     := NULL;
                  cCodFilial     := NULL;
               END;         
            ELSE
               BEGIN
                  SELECT DP.IdTipoSeg, DP.CodFilial
                    INTO cIdTipoSeg, cCodFilial
                    FROM DETALLE_POLIZA DP
                   WHERE DP.IdPoliza = nIdPoliza
                     AND DP.IdetPol  = nIdetPol;                           
               EXCEPTION
               WHEN OTHERS THEN
                  cIdTipoSeg := NULL;
                  cCodFilial := NULL;
               END;         
            END IF;
            --                  
            IF nCveAgente IS NULL THEN
                BEGIN
                   SELECT Cod_Agente
                     INTO nCveAgente
                     FROM AGENTE_POLIZA A
                    WHERE A.CodCia        = x.CodCia
                      AND A.IdPoliza      = nIdPoliza
                      AND A.Ind_Principal = 'S'
                      AND ROWNUM          = 1;                             
                EXCEPTION
                WHEN OTHERS THEN
                   nCveAgente  := null;
                END;                                  
            END IF;
            --              
            IF nCodCliente IS NOT NULL THEN 
               cNomContratante := OC_GENERALES.FUN_NOMBRECLIENTE(nCodCliente);
            END IF;
            --
            IF nCod_Asegurado IS NOT NULL OR nIdSiniestro IS NOT NULL THEN 
               IF nCod_Asegurado IS NOT NULL THEN 
                  cNomAsegu := OC_GENERALES.FUN_NOMBREASEGURADO(X.CodCia, 1, nCod_Asegurado) ;
               END IF;                  
               --
               cNomBenef := NULL;
               --
               IF nIdSiniestro IS NOT NULL  THEN
                  FOR BEN IN ( SELECT B.Nombre                                         
                                 FROM BENEF_SIN B
                                WHERE IdPoliza    = nIdPoliza
                                  AND IdSiniestro = nIdSiniestro
                                  AND ROWNUM < 3 )
                  LOOP
                      IF LENGTH(cNomBenef) > 0 THEN
                         cNomBenef := cNomBenef ||CHR(10);
                      END IF;
                      --                                 
                      cNomBenef := cNomBenef || BEN.Nombre;   
                  END LOOP;                          
               ELSE
                  FOR BEN IN ( SELECT B.Nombre                                         
                                 FROM BENEFICIARIO B
                                WHERE IdPoliza      = nIdPoliza
                                  AND IDetPol       = nIDetPol
                                  AND Cod_Asegurado = nCod_Asegurado
                                  AND ROWNUM < 3 )
                  LOOP
                     IF LENGTH(cNomBenef) > 0 THEN
                        cNomBenef := cNomBenef || CHR(10);
                     END IF;
                     --                                 
                     cNomBenef := cNomBenef || BEN.Nombre;   
                  END LOOP;
               END IF;
            END IF;
         END IF;   
         --
         IF x.TipoComprob <> 700 THEN  
            cCodDirecRegional  := NULL;
            cNomDirecRegional  := NULL;
            nImpComDR          := NULL;
            cCodPromotor       := NULL;
            cNomPromotor       := NULL;
            nImpComPromotor    := NULL;
            nCveAgente         := NULL;
            cNomAgente         := NULL;
            nImpComAgente      := NULL;
            cCodPrestadorServ1 := NULL;
            cNomPrestadorServ1 := NULL;
            nImpComPresServ1   := NULL;
            cCodPrestadorServ2 := NULL;
            cNomPrestadorServ2 := NULL;
            nImpComPresServ2   := NULL;
            cNomPresServ       := NULL;
            nContPresServ      := 1;
            --
            FOR y IN c_comisiones ( x.CodCia, nIdPoliza, nIDetPol ) LOOP
               IF y.CodNivel = 1 THEN
                  cCodDirecRegional := y.Cod_Agente_Distr;
                  cNomDirecRegional := OC_GENERALES.FUN_NOMBREAGENTE(y.Cod_Agente_Distr);
                  cNomPresServ      := cNomDirecRegional;
                  nImpComDR         := NULL;
               ELSIF y.CodNivel = 2 THEN
                  cCodPromotor    := y.Cod_Agente_Distr;
                  cNomPromotor    := OC_GENERALES.FUN_NOMBREAGENTE(y.Cod_Agente_Distr);
                  cNomPresServ    := cNomPromotor;
                  nImpComPromotor := NULL;
               ELSIF y.CodNivel = 3 THEN
                  nCveAgente    := y.Cod_Agente_Distr;
                  cNomAgente    := OC_GENERALES.FUN_NOMBREAGENTE(y.Cod_Agente_Distr);
                  cNomPresServ  := cNomAgente;
                  nImpComAgente := NULL;
               END IF;
               --
               BEGIN
                  SELECT 'S'
                  INTO   cEsPresServ
                  FROM   SICAS_OC.AGENTES
                  WHERE  COD_AGENTE = y.Cod_Agente_Distr
                    AND  CODTIPO IN ('HONPM', 'HONPF', 'HONORF', 'HONORM');
               EXCEPTION
               WHEN OTHERS THEN
                  cEsPresServ := 'N';
               END;
               --
               IF cEsPresServ = 'S' THEN
                  IF nContPresServ = 1 THEN
                     cCodPrestadorServ1 := y.Cod_Agente_Distr;
                     cNomPrestadorServ1 := cNomPresServ;
                     nImpComPresServ1   := NULL;
                     nContPresServ      := 2;
                  ELSIF nContPresServ = 2 THEN
                     cCodPrestadorServ2 := y.Cod_Agente_Distr;
                     cNomPrestadorServ2 := cNomPresServ;
                     nImpComPresServ2   := NULL;
                  END IF;
               END IF;
            END LOOP;
            --
            IF cFormato = 'TEXTO' THEN
               cCadena := TO_CHAR(X.NumComprob,'9999999999999')               || cLimitador ||  --'No. de Comprobante'
                          TO_CHAR(X.IdDetCuenta,'9999999999999')              || cLimitador ||  --'Consecutivo'
                          X.TipoComprob                                       || cLimitador ||  --'Tipo Comprobante'
                          X.DescMovCuenta                                     || cLimitador ||  --'Descripción del Tipo de Comprobante'
                          X.TipoDiario||'-'||X.NumComprobMizar                || cLimitador ||  --'No. Póliza MIZAR'
                          TO_CHAR(X.FechaDerivacion,'DD/MM/YYYY')             || cLimitador ||  --'Fecha Derivación MIZAR'
                          cNumPolUnico                                        || cLimitador ||  --'No.Póliza Único'
                          OC_CATALOGO_CONTABLE.FORMATO_CUENTA(cIdCtaContable) || cLimitador ||  --'Cuenta Contable'
                          cNivelAux                                           || cLimitador ||  --'Auxiliar Contable'
                          cDebCredito                                         || cLimitador ||  --'Débito/Crédito'
                          TO_CHAR(X.MtoMovCuenta,'99999999999990.00')         || cLimitador ||  --'Monto'
                          X.CodUnidadNegocio                                  || cLimitador ||  --'Unidad de Negocio'
                          X.DescCPTOGeneral                                   || cLimitador ||  --'Concepto General'
                          cNomContratante                                     || cLimitador ||  --'Nombre del Contratante'
                          X.CodCentroCosto                                    || cLimitador ||  --'Centro de Costos'
                          cFecIniVigPol                                       || cLimitador ||  --'Inicio de Vigencia de la Póliza'
                          cFecFinVigPol                                       || cLimitador ||  --'Fin de Vigencia de la Póliza'
                          cTipoAdministracion                                 || cLimitador ||  --'Forma de Administración'
                          cIdTipoSeg                                          || cLimitador ||  --'Tipo de Seguro'
                          x.CodSubProceso                                     || cLimitador ||  --'SubProc'
                          TO_CHAR(X.FecDetalle,'DD/MM/YYYY')                  || cLimitador ||  --'Fecha Transacción'
                          cNomBenef                                           || cLimitador ||  --'Nombre del Beneficiario'
                          cNomAsegu                                           || cLimitador ||  --'Nombre del Asegurado'
                          cCodFilial                                          || cLimitador ||  --'Nombre del Subgrupo'
                          cCodDirecRegional                                   || cLimitador ||  --'Clave DR'
                          cNomDirecRegional                                   || cLimitador ||  --'Nombre de la DR'
                          TO_CHAR(nImpComDR,'99999999999990.00')              || cLimitador ||  --'Importe Comisión DR'
                          cCodPromotor                                        || cLimitador ||  --'Clave Promotor'
                          cNomPromotor                                        || cLimitador ||  --'Nombre del Promotor'
                          TO_CHAR(nImpComPromotor,'99999999999990.00')        || cLimitador ||  --'Importe Comisión Promotor'
                          nCveAgente                                          || cLimitador ||  --'Clave del Agente'
                          cNomAgente                                          || cLimitador ||  --'Nombre del Agente'
                          TO_CHAR(nImpComAgente,'99999999999990.00')          || cLimitador ||  --'Importe Comisión Agente'
                          cCodPrestadorServ1                                  || cLimitador ||  --'Clave Prestador de Servicio 1'
                          cNomPrestadorServ1                                  || cLimitador ||  --'Nombre Prestador de Servicio 1'
                          TO_CHAR(nImpComPresServ1,'99999999999990.00')       || cLimitador ||  --'Importe Pago del Prestador de Servicio 1'
                          cCodPrestadorServ2                                  || cLimitador ||  --'Clave Prestador de Servicio 2'
                          cNomPrestadorServ2                                  || cLimitador ||  --'Nombre Prestador de Servicio 2'
                          TO_CHAR(nImpComPresServ2,'99999999999990.00')       || cLimitador ||  --'Importe Pago del Prestador de Servicio 2'
                          cDinamico                                           || cLimitador ||
                          cFecIniVigRec                                       || cLimitador ||  --'Inicio de Vigencia del Recibo o NC'
                          cFecFinVigRec                                       || cLimitador ||  --'Fin de Vigencia del Recibo o NC'
                          x.CodMoneda                                         || CHR(13);       --'Moneda'
            ELSE
               cCadena := '<tr>' ||
                          OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.NumComprob,'9999999999999'),'C')               ||  --'No. de Comprobante'
                          OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdDetCuenta,'9999999999999'),'C')              ||  --'Consecutivo'
                          OC_ARCHIVO.CAMPO_HTML(X.TipoComprob,'C')                                       ||  --'Tipo Comprobante'
                          OC_ARCHIVO.CAMPO_HTML(X.DescMovCuenta,'C')                                     ||  --'Descripción del Tipo de Comprobante'
                          OC_ARCHIVO.CAMPO_HTML(X.TipoDiario||'-'||X.NumComprobMizar,'C')                ||  --'No. Póliza MIZAR'
                          OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FechaDerivacion,'DD/MM/YYYY'),'D')             ||  --'Fecha Derivación MIZAR'
                          OC_ARCHIVO.CAMPO_HTML(CNumPolUnico,'C')                                        ||  --'No.Póliza Único'                                 
                          OC_ARCHIVO.CAMPO_HTML(OC_CATALOGO_CONTABLE.FORMATO_CUENTA(cIdCtaContable),'C') ||  --'Cuenta Contable'
                          OC_ARCHIVO.CAMPO_HTML(cNivelAux,'C')                                           ||  --'Auxiliar Contable'
                          OC_ARCHIVO.CAMPO_HTML(cDebCredito,'C')                                         ||  --'Débito/Crédito'
                          OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MtoMovCuenta,'99999999999990.00'),'N')         ||  --'Monto'
                          OC_ARCHIVO.CAMPO_HTML(X.CodUnidadNegocio,'C')                                  ||  --'Unidad de Negocio'
                          OC_ARCHIVO.CAMPO_HTML(X.DescCPTOGeneral,'C')                                   ||  --'Concepto General'
                          OC_ARCHIVO.CAMPO_HTML(cNomContratante,'C')                                     ||  --'Nombre del Contratante'
                          OC_ARCHIVO.CAMPO_HTML(X.CodCentroCosto,'C')                                    ||  --'Centro de Costos'
                          OC_ARCHIVO.CAMPO_HTML(cFecIniVigPol,'C')                                       ||  --'Inicio de Vigencia de la Póliza'
                          OC_ARCHIVO.CAMPO_HTML(cFecFinVigPol,'C')                                       ||  --'Fin de Vigencia de la Póliza'
                          OC_ARCHIVO.CAMPO_HTML(cTipoAdministracion,'C')                                 ||  --'Forma de Administración'
                          OC_ARCHIVO.CAMPO_HTML(cIdTipoSeg,'C')                                          ||  --'Tipo de Seguro'
                          OC_ARCHIVO.CAMPO_HTML(X.CodSubProceso,'C')                                     ||  --'SubProc'
                          OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FecDetalle,'DD/MM/YYYY'),'D')                  ||  --'Fecha Transacción'
                          OC_ARCHIVO.CAMPO_HTML(cNomBenef,'C')                                           ||  --'Nombre del Beneficiario'
                          OC_ARCHIVO.CAMPO_HTML(cNomAsegu,'C')                                           ||  --'Nombre del Asegurado'
                          OC_ARCHIVO.CAMPO_HTML(cCodFilial,'C')                                          ||  --'Nombre del Subgrupo'
                          OC_ARCHIVO.CAMPO_HTML(cCodDirecRegional,'C')                                   ||  --'Clave DR'
                          OC_ARCHIVO.CAMPO_HTML(cNomDirecRegional,'C')                                   ||  --'Nombre de la DR'
                          OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nImpComDR,'99999999999990.00'),'N')              ||  --'Importe Comisión DR'
                          OC_ARCHIVO.CAMPO_HTML(cCodPromotor,'C')                                        ||  --'Clave Promotor'
                          OC_ARCHIVO.CAMPO_HTML(cNomPromotor,'C')                                        ||  --'Nombre del Promotor'
                          OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nImpComPromotor,'99999999999990.00'),'N')        ||  --'Importe Comisión Promotor'
                          OC_ARCHIVO.CAMPO_HTML(nCveAgente,'C')                                          ||  --'Clave del Agente'
                          OC_ARCHIVO.CAMPO_HTML(cNomAgente,'C')                                          ||  --'Nombre del Agente'
                          OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nImpComAgente,'99999999999990.00'),'N')          ||  --'Importe Comisión Agente'
                          OC_ARCHIVO.CAMPO_HTML(cCodPrestadorServ1,'C')                                  ||  --'Clave Prestador de Servicio 1'
                          OC_ARCHIVO.CAMPO_HTML(cNomPrestadorServ1,'C')                                  ||  --'Nombre Prestador de Servicio 1'
                          OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nImpComPresServ1,'99999999999990.00'),'N')       ||  --'Importe Pago del Prestador de Servicio 1'
                          OC_ARCHIVO.CAMPO_HTML(cCodPrestadorServ2,'C')                                  ||  --'Clave Prestador de Servicio 2'
                          OC_ARCHIVO.CAMPO_HTML(cNomPrestadorServ2,'C')                                  ||  --'Nombre Prestador de Servicio 2'
                          OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nImpComPresServ2,'99999999999990.00'),'N')       ||  --'Importe Pago del Prestador de Servicio 2'
                          cDinamico                                                                      ||
                          OC_ARCHIVO.CAMPO_HTML(cFecIniVigRec,'C')                                       ||  --'Inicio de Vigencia del Recibo o NC'
                          OC_ARCHIVO.CAMPO_HTML(cFecFinVigRec,'C')                                       ||  --'Fin de Vigencia del Recibo o NC'
                          OC_ARCHIVO.CAMPO_HTML(x.CodMoneda,'C')                                         ||  --'Moneda'
                          '</tr>';
            END IF;
            --
            nLinea := nLinea + 1;
--            DBMS_OUTPUT.PUT_LINE(cCadena);
            OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         ELSE
            IF (X.DescMovCuenta NOT LIKE '%IVA%') AND (X.DescMovCuenta NOT LIKE '%ISR%') THEN
               FOR z IN c_pol_comisiones ( nIdNcr ) LOOP            
                  cCodDirecRegional  := NULL;
                  cNomDirecRegional  := NULL;
                  nImpComDR          := NULL;
                  cCodPromotor       := NULL;
                  cNomPromotor       := NULL;
                  nImpComPromotor    := NULL;
                  nCveAgente         := NULL;
                  cNomAgente         := NULL;
                  nImpComAgente      := NULL;
                  cCodPrestadorServ1 := NULL;
                  cNomPrestadorServ1 := NULL;
                  nImpComPresServ1   := NULL;
                  cCodPrestadorServ2 := NULL;
                  cNomPrestadorServ2 := NULL;
                  nImpComPresServ2   := NULL;
                  cNomPresServ       := NULL;
                  nContPresServ      := 1;
                  --
                  FOR y IN c_comisiones ( x.CodCia, z.IdPoliza, nIDetPol ) LOOP
                     IF y.CodNivel = 1 THEN
                        cCodDirecRegional := y.Cod_Agente_Distr;
                        cNomDirecRegional := OC_GENERALES.FUN_NOMBREAGENTE(y.Cod_Agente_Distr);
                        cNomPresServ      := cNomDirecRegional;
                        IF y.Cod_Agente_Distr = z.Cod_Agente THEN
                           nImpComDR := z.Monto;
                        ELSE
                           nImpComDR := NULL;
                        END IF;
                     ELSIF y.CodNivel = 2 THEN
                        cCodPromotor := y.Cod_Agente_Distr;
                        cNomPromotor := OC_GENERALES.FUN_NOMBREAGENTE(y.Cod_Agente_Distr);
                        cNomPresServ := cNomPromotor;
                        IF y.Cod_Agente_Distr = z.Cod_Agente THEN
                           nImpComPromotor := z.Monto;
                        ELSE
                           nImpComPromotor := NULL;
                        END IF;
                     ELSIF y.CodNivel = 3 THEN
                        nCveAgente   := y.Cod_Agente_Distr;
                        cNomAgente   := OC_GENERALES.FUN_NOMBREAGENTE(y.Cod_Agente_Distr);
                        cNomPresServ := cNomAgente;
                        IF y.Cod_Agente_Distr = z.Cod_Agente THEN
                           nImpComAgente := z.Monto;
                        ELSE
                           nImpComAgente := NULL;
                        END IF;
                     END IF;
                     --
                     BEGIN
                        SELECT 'S'
                        INTO   cEsPresServ
                        FROM   SICAS_OC.AGENTES
                        WHERE  COD_AGENTE = y.Cod_Agente_Distr
                          AND  CODTIPO IN ('HONPM', 'HONPF', 'HONORF', 'HONORM');
                     EXCEPTION
                     WHEN OTHERS THEN
                        cEsPresServ := 'N';
                     END;
                     --
                     IF cEsPresServ = 'S' THEN
                        IF nContPresServ = 1 THEN
                           cCodPrestadorServ1 := y.Cod_Agente_Distr;
                           cNomPrestadorServ1 := cNomPresServ;
                           IF y.Cod_Agente_Distr = z.Cod_Agente THEN
                              nImpComPresServ1 := z.Monto;
                           ELSE
                              nImpComPresServ1 := NULL;
                           END IF;
                           nContPresServ      := 2;
                        ELSIF nContPresServ = 2 THEN
                           cCodPrestadorServ2 := y.Cod_Agente_Distr;
                           cNomPrestadorServ2 := cNomPresServ;
                           IF y.Cod_Agente_Distr = z.Cod_Agente THEN
                              nImpComPresServ2 := z.Monto;
                           ELSE
                              nImpComPresServ2 := NULL;
                           END IF;
                        END IF;
                     END IF;
                  END LOOP;
                  --
                  IF cFormato = 'TEXTO' THEN
                     cCadena := TO_CHAR(X.NumComprob,'9999999999999')               || cLimitador ||  --'No. de Comprobante'
                                TO_CHAR(X.IdDetCuenta,'9999999999999')              || cLimitador ||  --'Consecutivo'
                                X.TipoComprob                                       || cLimitador ||  --'Tipo Comprobante'
                                X.DescMovCuenta                                     || cLimitador ||  --'Descripción del Tipo de Comprobante'
                                X.TipoDiario||'-'||X.NumComprobMizar                || cLimitador ||  --'No. Póliza MIZAR'
                                TO_CHAR(X.FechaDerivacion,'DD/MM/YYYY')             || cLimitador ||  --'Fecha Derivación MIZAR'
                                cNumPolUnico                                        || cLimitador ||  --'No.Póliza Único'
                                OC_CATALOGO_CONTABLE.FORMATO_CUENTA(cIdCtaContable) || cLimitador ||  --'Cuenta Contable'
                                cNivelAux                                           || cLimitador ||  --'Auxiliar Contable'
                                cDebCredito                                         || cLimitador ||  --'Débito/Crédito'
                                TO_CHAR(X.MtoMovCuenta,'99999999999990.00')         || cLimitador ||  --'Monto'
                                X.CodUnidadNegocio                                  || cLimitador ||  --'Unidad de Negocio'
                                X.DescCPTOGeneral                                   || cLimitador ||  --'Concepto General'
                                cNomContratante                                     || cLimitador ||  --'Nombre del Contratante'
                                X.CodCentroCosto                                    || cLimitador ||  --'Centro de Costos'
                                cFecIniVigPol                                       || cLimitador ||  --'Inicio de Vigencia de la Póliza'
                                cFecFinVigPol                                       || cLimitador ||  --'Fin de Vigencia de la Póliza'
                                cTipoAdministracion                                 || cLimitador ||  --'Forma de Administración'
                                cIdTipoSeg                                          || cLimitador ||  --'Tipo de Seguro'
                                x.CodSubProceso                                     || cLimitador ||  --'SubProc'
                                TO_CHAR(X.FecDetalle,'DD/MM/YYYY')                  || cLimitador ||  --'Fecha Transacción'
                                cNomBenef                                           || cLimitador ||  --'Nombre del Beneficiario'
                                cNomAsegu                                           || cLimitador ||  --'Nombre del Asegurado'
                                cCodFilial                                          || cLimitador ||  --'Nombre del Subgrupo'
                                cCodDirecRegional                                   || cLimitador ||  --'Clave DR'
                                cNomDirecRegional                                   || cLimitador ||  --'Nombre de la DR'
                                TO_CHAR(nImpComDR,'99999999999990.00')              || cLimitador ||  --'Importe Comisión DR'
                                cCodPromotor                                        || cLimitador ||  --'Clave Promotor'
                                cNomPromotor                                        || cLimitador ||  --'Nombre del Promotor'
                                TO_CHAR(nImpComPromotor,'99999999999990.00')        || cLimitador ||  --'Importe Comisión Promotor'
                                nCveAgente                                          || cLimitador ||  --'Clave del Agente'
                                cNomAgente                                          || cLimitador ||  --'Nombre del Agente'
                                TO_CHAR(nImpComAgente,'99999999999990.00')          || cLimitador ||  --'Importe Comisión Agente'
                                cCodPrestadorServ1                                  || cLimitador ||  --'Clave Prestador de Servicio 1'
                                cNomPrestadorServ1                                  || cLimitador ||  --'Nombre Prestador de Servicio 1'
                                TO_CHAR(nImpComPresServ1,'99999999999990.00')       || cLimitador ||  --'Importe Pago del Prestador de Servicio 1'
                                cCodPrestadorServ2                                  || cLimitador ||  --'Clave Prestador de Servicio 2'
                                cNomPrestadorServ2                                  || cLimitador ||  --'Nombre Prestador de Servicio 2'
                                TO_CHAR(nImpComPresServ2,'99999999999990.00')       || cLimitador ||  --'Importe Pago del Prestador de Servicio 2'
                                cDinamico                                           || cLimitador ||
                                cFecIniVigRec                                       || cLimitador ||  --'Inicio de Vigencia del Recibo o NC'
                                cFecFinVigRec                                       || cLimitador ||  --'Fin de Vigencia del Recibo o NC'
                                x.CodMoneda                                         || CHR(13);       --'Moneda'
                  ELSE
                     cCadena := '<tr>' ||
                                OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.NumComprob,'9999999999999'),'C')               ||  --'No. de Comprobante'
                                OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdDetCuenta,'9999999999999'),'C')              ||  --'Consecutivo'
                                OC_ARCHIVO.CAMPO_HTML(X.TipoComprob,'C')                                       ||  --'Tipo Comprobante'
                                OC_ARCHIVO.CAMPO_HTML(X.DescMovCuenta,'C')                                     ||  --'Descripción del Tipo de Comprobante'
                                OC_ARCHIVO.CAMPO_HTML(X.TipoDiario||'-'||X.NumComprobMizar,'C')                ||  --'No. Póliza MIZAR'
                                OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FechaDerivacion,'DD/MM/YYYY'),'D')             ||  --'Fecha Derivación MIZAR'
                                OC_ARCHIVO.CAMPO_HTML(CNumPolUnico,'C')                                        ||  --'No.Póliza Único'                                 
                                OC_ARCHIVO.CAMPO_HTML(OC_CATALOGO_CONTABLE.FORMATO_CUENTA(cIdCtaContable),'C') ||  --'Cuenta Contable'
                                OC_ARCHIVO.CAMPO_HTML(cNivelAux,'C')                                           ||  --'Auxiliar Contable'
                                OC_ARCHIVO.CAMPO_HTML(cDebCredito,'C')                                         ||  --'Débito/Crédito'
                                OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MtoMovCuenta,'99999999999990.00'),'N')         ||  --'Monto'
                                OC_ARCHIVO.CAMPO_HTML(X.CodUnidadNegocio,'C')                                  ||  --'Unidad de Negocio'
                                OC_ARCHIVO.CAMPO_HTML(X.DescCPTOGeneral,'C')                                   ||  --'Concepto General'
                                OC_ARCHIVO.CAMPO_HTML(cNomContratante,'C')                                     ||  --'Nombre del Contratante'
                                OC_ARCHIVO.CAMPO_HTML(X.CodCentroCosto,'C')                                    ||  --'Centro de Costos'
                                OC_ARCHIVO.CAMPO_HTML(cFecIniVigPol,'C')                                       ||  --'Inicio de Vigencia de la Póliza'
                                OC_ARCHIVO.CAMPO_HTML(cFecFinVigPol,'C')                                       ||  --'Fin de Vigencia de la Póliza'
                                OC_ARCHIVO.CAMPO_HTML(cTipoAdministracion,'C')                                 ||  --'Forma de Administración'
                                OC_ARCHIVO.CAMPO_HTML(cIdTipoSeg,'C')                                          ||  --'Tipo de Seguro'
                                OC_ARCHIVO.CAMPO_HTML(X.CodSubProceso,'C')                                     ||  --'SubProc'
                                OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FecDetalle,'DD/MM/YYYY'),'D')                  ||  --'Fecha Transacción'
                                OC_ARCHIVO.CAMPO_HTML(cNomBenef,'C')                                           ||  --'Nombre del Beneficiario'
                                OC_ARCHIVO.CAMPO_HTML(cNomAsegu,'C')                                           ||  --'Nombre del Asegurado'
                                OC_ARCHIVO.CAMPO_HTML(cCodFilial,'C')                                          ||  --'Nombre del Subgrupo'
                                OC_ARCHIVO.CAMPO_HTML(cCodDirecRegional,'C')                                   ||  --'Clave DR'
                                OC_ARCHIVO.CAMPO_HTML(cNomDirecRegional,'C')                                   ||  --'Nombre de la DR'
                                OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nImpComDR,'99999999999990.00'),'N')              ||  --'Importe Comisión DR'
                                OC_ARCHIVO.CAMPO_HTML(cCodPromotor,'C')                                        ||  --'Clave Promotor'
                                OC_ARCHIVO.CAMPO_HTML(cNomPromotor,'C')                                        ||  --'Nombre del Promotor'
                                OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nImpComPromotor,'99999999999990.00'),'N')        ||  --'Importe Comisión Promotor'
                                OC_ARCHIVO.CAMPO_HTML(nCveAgente,'C')                                          ||  --'Clave del Agente'
                                OC_ARCHIVO.CAMPO_HTML(cNomAgente,'C')                                          ||  --'Nombre del Agente'
                                OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nImpComAgente,'99999999999990.00'),'N')          ||  --'Importe Comisión Agente'
                                OC_ARCHIVO.CAMPO_HTML(cCodPrestadorServ1,'C')                                  ||  --'Clave Prestador de Servicio 1'
                                OC_ARCHIVO.CAMPO_HTML(cNomPrestadorServ1,'C')                                  ||  --'Nombre Prestador de Servicio 1'
                                OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nImpComPresServ1,'99999999999990.00'),'N')       ||  --'Importe Pago del Prestador de Servicio 1'
                                OC_ARCHIVO.CAMPO_HTML(cCodPrestadorServ2,'C')                                  ||  --'Clave Prestador de Servicio 2'
                                OC_ARCHIVO.CAMPO_HTML(cNomPrestadorServ2,'C')                                  ||  --'Nombre Prestador de Servicio 2'
                                OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nImpComPresServ2,'99999999999990.00'),'N')       ||  --'Importe Pago del Prestador de Servicio 2'
                                cDinamico                                                                      ||
                                OC_ARCHIVO.CAMPO_HTML(cFecIniVigRec,'C')                                       ||  --'Inicio de Vigencia del Recibo o NC'
                                OC_ARCHIVO.CAMPO_HTML(cFecFinVigRec,'C')                                       ||  --'Fin de Vigencia del Recibo o NC'
                                OC_ARCHIVO.CAMPO_HTML(x.CodMoneda,'C')                                         ||  --'Moneda'
                                '</tr>';
                  END IF;
                  --
                  nLinea := nLinea + 1;
--                  DBMS_OUTPUT.PUT_LINE(cCadena);
                  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
               END LOOP;
            ELSE
            cCodDirecRegional  := NULL;
            cNomDirecRegional  := NULL;
            nImpComDR          := NULL;
            cCodPromotor       := NULL;
            cNomPromotor       := NULL;
            nImpComPromotor    := NULL;
            nCveAgente         := NULL;
            cNomAgente         := NULL;
            nImpComAgente      := NULL;
            cCodPrestadorServ1 := NULL;
            cNomPrestadorServ1 := NULL;
            nImpComPresServ1   := NULL;
            cCodPrestadorServ2 := NULL;
            cNomPrestadorServ2 := NULL;
            nImpComPresServ2   := NULL;
            cNomPresServ       := NULL;
            nContPresServ      := 1;
            --
            FOR y IN c_comisiones ( x.CodCia, nIdPoliza, nIDetPol ) LOOP
               IF y.CodNivel = 1 THEN
                  cCodDirecRegional := y.Cod_Agente_Distr;
                  cNomDirecRegional := OC_GENERALES.FUN_NOMBREAGENTE(y.Cod_Agente_Distr);
                  cNomPresServ      := cNomDirecRegional;
                  nImpComDR         := NULL;
               ELSIF y.CodNivel = 2 THEN
                  cCodPromotor    := y.Cod_Agente_Distr;
                  cNomPromotor    := OC_GENERALES.FUN_NOMBREAGENTE(y.Cod_Agente_Distr);
                  cNomPresServ    := cNomPromotor;
                  nImpComPromotor := NULL;
               ELSIF y.CodNivel = 3 THEN
                  nCveAgente    := y.Cod_Agente_Distr;
                  cNomAgente    := OC_GENERALES.FUN_NOMBREAGENTE(y.Cod_Agente_Distr);
                  cNomPresServ  := cNomAgente;
                  nImpComAgente := NULL;
               END IF;
               --
               BEGIN
                  SELECT 'S'
                  INTO   cEsPresServ
                  FROM   SICAS_OC.AGENTES
                  WHERE  COD_AGENTE = y.Cod_Agente_Distr
                    AND  CODTIPO IN ('HONPM', 'HONPF', 'HONORF', 'HONORM');
               EXCEPTION
               WHEN OTHERS THEN
                  cEsPresServ := 'N';
               END;
               --
               IF cEsPresServ = 'S' THEN
                  IF nContPresServ = 1 THEN
                     cCodPrestadorServ1 := y.Cod_Agente_Distr;
                     cNomPrestadorServ1 := cNomPresServ;
                     nImpComPresServ1   := NULL;
                     nContPresServ      := 2;
                  ELSIF nContPresServ = 2 THEN
                     cCodPrestadorServ2 := y.Cod_Agente_Distr;
                     cNomPrestadorServ2 := cNomPresServ;
                     nImpComPresServ2   := NULL;
                  END IF;
               END IF;
            END LOOP;
            --
            IF cFormato = 'TEXTO' THEN
               cCadena := TO_CHAR(X.NumComprob,'9999999999999')               || cLimitador ||  --'No. de Comprobante'
                          TO_CHAR(X.IdDetCuenta,'9999999999999')              || cLimitador ||  --'Consecutivo'
                          X.TipoComprob                                       || cLimitador ||  --'Tipo Comprobante'
                          X.DescMovCuenta                                     || cLimitador ||  --'Descripción del Tipo de Comprobante'
                          X.TipoDiario||'-'||X.NumComprobMizar                || cLimitador ||  --'No. Póliza MIZAR'
                          TO_CHAR(X.FechaDerivacion,'DD/MM/YYYY')             || cLimitador ||  --'Fecha Derivación MIZAR'
                          cNumPolUnico                                        || cLimitador ||  --'No.Póliza Único'
                          OC_CATALOGO_CONTABLE.FORMATO_CUENTA(cIdCtaContable) || cLimitador ||  --'Cuenta Contable'
                          cNivelAux                                           || cLimitador ||  --'Auxiliar Contable'
                          cDebCredito                                         || cLimitador ||  --'Débito/Crédito'
                          TO_CHAR(X.MtoMovCuenta,'99999999999990.00')         || cLimitador ||  --'Monto'
                          X.CodUnidadNegocio                                  || cLimitador ||  --'Unidad de Negocio'
                          X.DescCPTOGeneral                                   || cLimitador ||  --'Concepto General'
                          cNomContratante                                     || cLimitador ||  --'Nombre del Contratante'
                          X.CodCentroCosto                                    || cLimitador ||  --'Centro de Costos'
                          cFecIniVigPol                                       || cLimitador ||  --'Inicio de Vigencia de la Póliza'
                          cFecFinVigPol                                       || cLimitador ||  --'Fin de Vigencia de la Póliza'
                          cTipoAdministracion                                 || cLimitador ||  --'Forma de Administración'
                          cIdTipoSeg                                          || cLimitador ||  --'Tipo de Seguro'
                          x.CodSubProceso                                     || cLimitador ||  --'SubProc'
                          TO_CHAR(X.FecDetalle,'DD/MM/YYYY')                  || cLimitador ||  --'Fecha Transacción'
                          cNomBenef                                           || cLimitador ||  --'Nombre del Beneficiario'
                          cNomAsegu                                           || cLimitador ||  --'Nombre del Asegurado'
                          cCodFilial                                          || cLimitador ||  --'Nombre del Subgrupo'
                          cCodDirecRegional                                   || cLimitador ||  --'Clave DR'
                          cNomDirecRegional                                   || cLimitador ||  --'Nombre de la DR'
                          TO_CHAR(nImpComDR,'99999999999990.00')              || cLimitador ||  --'Importe Comisión DR'
                          cCodPromotor                                        || cLimitador ||  --'Clave Promotor'
                          cNomPromotor                                        || cLimitador ||  --'Nombre del Promotor'
                          TO_CHAR(nImpComPromotor,'99999999999990.00')        || cLimitador ||  --'Importe Comisión Promotor'
                          nCveAgente                                          || cLimitador ||  --'Clave del Agente'
                          cNomAgente                                          || cLimitador ||  --'Nombre del Agente'
                          TO_CHAR(nImpComAgente,'99999999999990.00')          || cLimitador ||  --'Importe Comisión Agente'
                          cCodPrestadorServ1                                  || cLimitador ||  --'Clave Prestador de Servicio 1'
                          cNomPrestadorServ1                                  || cLimitador ||  --'Nombre Prestador de Servicio 1'
                          TO_CHAR(nImpComPresServ1,'99999999999990.00')       || cLimitador ||  --'Importe Pago del Prestador de Servicio 1'
                          cCodPrestadorServ2                                  || cLimitador ||  --'Clave Prestador de Servicio 2'
                          cNomPrestadorServ2                                  || cLimitador ||  --'Nombre Prestador de Servicio 2'
                          TO_CHAR(nImpComPresServ2,'99999999999990.00')       || cLimitador ||  --'Importe Pago del Prestador de Servicio 2'
                          cDinamico                                           || cLimitador ||
                          cFecIniVigRec                                       || cLimitador ||  --'Inicio de Vigencia del Recibo o NC'
                          cFecFinVigRec                                       || cLimitador ||  --'Fin de Vigencia del Recibo o NC'
                          x.CodMoneda                                         || CHR(13);       --'Moneda'
            ELSE
               cCadena := '<tr>' ||
                          OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.NumComprob,'9999999999999'),'C')               ||  --'No. de Comprobante'
                          OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdDetCuenta,'9999999999999'),'C')              ||  --'Consecutivo'
                          OC_ARCHIVO.CAMPO_HTML(X.TipoComprob,'C')                                       ||  --'Tipo Comprobante'
                          OC_ARCHIVO.CAMPO_HTML(X.DescMovCuenta,'C')                                     ||  --'Descripción del Tipo de Comprobante'
                          OC_ARCHIVO.CAMPO_HTML(X.TipoDiario||'-'||X.NumComprobMizar,'C')                ||  --'No. Póliza MIZAR'
                          OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FechaDerivacion,'DD/MM/YYYY'),'D')             ||  --'Fecha Derivación MIZAR'
                          OC_ARCHIVO.CAMPO_HTML(CNumPolUnico,'C')                                        ||  --'No.Póliza Único'                                 
                          OC_ARCHIVO.CAMPO_HTML(OC_CATALOGO_CONTABLE.FORMATO_CUENTA(cIdCtaContable),'C') ||  --'Cuenta Contable'
                          OC_ARCHIVO.CAMPO_HTML(cNivelAux,'C')                                           ||  --'Auxiliar Contable'
                          OC_ARCHIVO.CAMPO_HTML(cDebCredito,'C')                                         ||  --'Débito/Crédito'
                          OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MtoMovCuenta,'99999999999990.00'),'N')         ||  --'Monto'
                          OC_ARCHIVO.CAMPO_HTML(X.CodUnidadNegocio,'C')                                  ||  --'Unidad de Negocio'
                          OC_ARCHIVO.CAMPO_HTML(X.DescCPTOGeneral,'C')                                   ||  --'Concepto General'
                          OC_ARCHIVO.CAMPO_HTML(cNomContratante,'C')                                     ||  --'Nombre del Contratante'
                          OC_ARCHIVO.CAMPO_HTML(X.CodCentroCosto,'C')                                    ||  --'Centro de Costos'
                          OC_ARCHIVO.CAMPO_HTML(cFecIniVigPol,'C')                                       ||  --'Inicio de Vigencia de la Póliza'
                          OC_ARCHIVO.CAMPO_HTML(cFecFinVigPol,'C')                                       ||  --'Fin de Vigencia de la Póliza'
                          OC_ARCHIVO.CAMPO_HTML(cTipoAdministracion,'C')                                 ||  --'Forma de Administración'
                          OC_ARCHIVO.CAMPO_HTML(cIdTipoSeg,'C')                                          ||  --'Tipo de Seguro'
                          OC_ARCHIVO.CAMPO_HTML(X.CodSubProceso,'C')                                     ||  --'SubProc'
                          OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FecDetalle,'DD/MM/YYYY'),'D')                  ||  --'Fecha Transacción'
                          OC_ARCHIVO.CAMPO_HTML(cNomBenef,'C')                                           ||  --'Nombre del Beneficiario'
                          OC_ARCHIVO.CAMPO_HTML(cNomAsegu,'C')                                           ||  --'Nombre del Asegurado'
                          OC_ARCHIVO.CAMPO_HTML(cCodFilial,'C')                                          ||  --'Nombre del Subgrupo'
                          OC_ARCHIVO.CAMPO_HTML(cCodDirecRegional,'C')                                   ||  --'Clave DR'
                          OC_ARCHIVO.CAMPO_HTML(cNomDirecRegional,'C')                                   ||  --'Nombre de la DR'
                          OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nImpComDR,'99999999999990.00'),'N')              ||  --'Importe Comisión DR'
                          OC_ARCHIVO.CAMPO_HTML(cCodPromotor,'C')                                        ||  --'Clave Promotor'
                          OC_ARCHIVO.CAMPO_HTML(cNomPromotor,'C')                                        ||  --'Nombre del Promotor'
                          OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nImpComPromotor,'99999999999990.00'),'N')        ||  --'Importe Comisión Promotor'
                          OC_ARCHIVO.CAMPO_HTML(nCveAgente,'C')                                          ||  --'Clave del Agente'
                          OC_ARCHIVO.CAMPO_HTML(cNomAgente,'C')                                          ||  --'Nombre del Agente'
                          OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nImpComAgente,'99999999999990.00'),'N')          ||  --'Importe Comisión Agente'
                          OC_ARCHIVO.CAMPO_HTML(cCodPrestadorServ1,'C')                                  ||  --'Clave Prestador de Servicio 1'
                          OC_ARCHIVO.CAMPO_HTML(cNomPrestadorServ1,'C')                                  ||  --'Nombre Prestador de Servicio 1'
                          OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nImpComPresServ1,'99999999999990.00'),'N')       ||  --'Importe Pago del Prestador de Servicio 1'
                          OC_ARCHIVO.CAMPO_HTML(cCodPrestadorServ2,'C')                                  ||  --'Clave Prestador de Servicio 2'
                          OC_ARCHIVO.CAMPO_HTML(cNomPrestadorServ2,'C')                                  ||  --'Nombre Prestador de Servicio 2'
                          OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nImpComPresServ2,'99999999999990.00'),'N')       ||  --'Importe Pago del Prestador de Servicio 2'
                          cDinamico                                                                      ||
                          OC_ARCHIVO.CAMPO_HTML(cFecIniVigRec,'C')                                       ||  --'Inicio de Vigencia del Recibo o NC'
                          OC_ARCHIVO.CAMPO_HTML(cFecFinVigRec,'C')                                       ||  --'Fin de Vigencia del Recibo o NC'
                          OC_ARCHIVO.CAMPO_HTML(x.CodMoneda,'C')                                         ||  --'Moneda'
                          '</tr>';
            END IF;
            --
            nLinea := nLinea + 1;
--            DBMS_OUTPUT.PUT_LINE(cCadena);
            OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
            END IF;
         END IF;
      END LOOP;
   END LOOP;
   --
   IF cFormato = 'EXCEL' THEN
--      DBMS_OUTPUT.PUT_LINE('</table></div></html>');
      OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
   END IF;
   --
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0);
   COMMIT;
EXCEPTION 
WHEN OTHERS THEN 
   RAISE_APPLICATION_ERROR(-20000, 'Error en OC_INTEGRADO_CONTABLE ' || SQLERRM);
END oc_integrado_contable;
/