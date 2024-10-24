--
-- OC_FACT_ELECT_CONF_DOCTO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_LOB (Synonym)
--   DBMS_LOCK (Synonym)
--   DBMS_OUTPUT (Synonym)
--   DBMS_STANDARD (Package)
--   UTL_HTTP (Synonym)
--   POLIZAS (Table)
--   FACTURAS (Table)
--   FACT_ELECT_CONF_DOCTO (Table)
--   FACT_ELECT_DETALLE_TIMBRE (Table)
--   FACT_ELECT_REGISTROS_XML (Table)
--   DETALLE_FACTURAS (Table)
--   DETALLE_FACT_ELECT_CONF_DOCTO (Table)
--   DETALLE_NOTAS_DE_CREDITO (Table)
--   DETALLE_POLIZA (Table)
--   OC_DDL_OBJETOS (Package)
--   OC_DET_FACT_ELECT_CONF_DOCTO (Package)
--   AGENTES (Table)
--   AGENTE_POLIZA (Table)
--   ASEGURADO (Table)
--   NOTAS_DE_CREDITO (Table)
--   CORREOS_ELECTRONICOS_PNJ (Table)
--   CATALOGO_DE_CONCEPTOS (Table)
--   OC_EJECUTIVO_COMERCIAL (Package)
--   OC_EMPRESAS (Package)
--   OC_FACT_ELECT_DETALLE_TIMBRE (Package)
--   OC_USUARIOS (Package)
--   OC_VALORES_DE_LISTAS (Package)
--   PERSONA_NATURAL_JURIDICA (Table)
--   OC_AGE_DISTRIBUCION_COMISION (Package)
--   OC_ASEGURADO (Package)
--   OC_CLIENTES (Package)
--   OC_GENERALES (Package)
--   OC_MAIL (Package)
--   OC_POLIZAS (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_FACT_ELECT_CONF_DOCTO IS
    cLineaCom        VARCHAR2(1000) := NULL;
    cLineaExe        VARCHAR2(1000) := NULL;
    cLineaCRels      VARCHAR2(1000) := NULL;
    cLineaCRel       VARCHAR2(1000) := NULL;
    cLineaRef        VARCHAR2(1000) := NULL;
    cLineaRec        VARCHAR2(1000) := NULL;
    cLineaDor        VARCHAR2(1000) := NULL;
    cLineaCon        VARCHAR2(1000) := NULL;
    cLineaConit      VARCHAR2(1000) := NULL;
    cLineaConir      VARCHAR2(1000) := NULL;
    cLineaCup        VARCHAR2(1000) := NULL;
    cLineaInad       VARCHAR2(1000) := NULL;
    cLineaRet        VARCHAR2(1000) := NULL;
    cLineaTra        VARCHAR2(1000) := NULL;
    cLineaAdd        VARCHAR2(1000) := NULL;
    cLineaAdi        VARCHAR2(1000) := NULL;
    cLineaPags       VARCHAR2(1000) := NULL;
    cLineaPagsDocRel VARCHAR2(1000) := NULL;

    PROCEDURE ASIGNA_LINEA_IDENTIFICADOR (cCodIdLinea  VARCHAR2,cLinea  VARCHAR2);
    FUNCTION  CREA_DOCUMENTO(nIdFactura  NUMBER DEFAULT NULL ,nIdNcr  NUMBER DEFAULT NULL, nCodCia  NUMBER, nCodEmpresa  NUMBER, cProceso  VARCHAR2,cTipoCfdi  VARCHAR2, cIndRelaciona VARCHAR2 DEFAULT NULL) RETURN VARCHAR2;
    FUNCTION  CREA_IDENTIFICADOR (nIdFactura  NUMBER,nIdNcr  NUMBER DEFAULT NULL,nCodCia  NUMBER,nCodEmpresa  NUMBER, cProceso  VARCHAR2,cCodIdLinea  VARCHAR2,cTipoCfdi  VARCHAR2,cCodCpto  VARCHAR2 DEFAULT NULL, cIndRelaciona VARCHAR2) RETURN VARCHAR2;
    FUNCTION  CONCEPTO_IMPUESTO (nCodCia NUMBER, cProceso VARCHAR2, cCodIdLea VARCHAR2) RETURN VARCHAR2;
    PROCEDURE TIMBRAR(PnIdFactura  NUMBER DEFAULT NULL, pnIdNcr  NUMBER DEFAULT NULL,nCodCia  NUMBER,nCodEmpresa  NUMBER, cProceso  VARCHAR2,cTipoCfdi VARCHAR2, cIndRelaciona VARCHAR2 DEFAULT NULL, cCodRespuesta OUT VARCHAR2, IndOtroPac VARCHAR2 DEFAULT NULL);
    PROCEDURE ENVIA_CORREO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFactura  NUMBER DEFAULT NULL,nIdNcr  NUMBER DEFAULT NULL,
                            cProceso  VARCHAR2,cCodRespuesta VARCHAR2, cDescError VARCHAR2 DEFAULT NULL, cDocto VARCHAR2 DEFAULT NULL);
    FUNCTION  DESTINATARIOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFactura  NUMBER DEFAULT NULL,nIdNcr  NUMBER DEFAULT NULL, cTipoDest VARCHAR2) RETURN VARCHAR2;

END OC_FACT_ELECT_CONF_DOCTO;
/

--
-- OC_FACT_ELECT_CONF_DOCTO  (Package Body) 
--
--  Dependencies: 
--   OC_FACT_ELECT_CONF_DOCTO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_FACT_ELECT_CONF_DOCTO IS

    PROCEDURE ASIGNA_LINEA_IDENTIFICADOR(cCodIdLinea IN VARCHAR2,cLinea IN VARCHAR2) IS
    BEGIN
        IF cCodIdLinea = 'COM'              THEN
            OC_FACT_ELECT_CONF_DOCTO.cLineaCom          := cLinea;
        ELSIF cCodIdLinea = 'EXE'           THEN
            OC_FACT_ELECT_CONF_DOCTO.cLineaExe          := cLinea;
        ELSIF cCodIdLinea = 'CRELS'         THEN
            OC_FACT_ELECT_CONF_DOCTO.cLineaCRels        := cLinea;
        ELSIF cCodIdLinea = 'CREL'          THEN
            OC_FACT_ELECT_CONF_DOCTO.cLineaCRel         := cLinea;
        ELSIF cCodIdLinea = 'REF'           THEN
            OC_FACT_ELECT_CONF_DOCTO.cLineaRef          := cLinea;
        ELSIF cCodIdLinea = 'REC'           THEN
            OC_FACT_ELECT_CONF_DOCTO.cLineaRec          := cLinea;
        ELSIF cCodIdLinea = 'DOR'           THEN
            OC_FACT_ELECT_CONF_DOCTO.cLineaDor          := cLinea;
        ELSIF cCodIdLinea = 'CON'           THEN
            OC_FACT_ELECT_CONF_DOCTO.cLineaCon          := cLinea;
        ELSIF cCodIdLinea = 'CONIT'         THEN
            OC_FACT_ELECT_CONF_DOCTO.cLineaConit        := cLinea;
        ELSIF cCodIdLinea = 'CONIR'         THEN
            OC_FACT_ELECT_CONF_DOCTO.cLineaConir        := cLinea;
        ELSIF cCodIdLinea = 'CUP'           THEN
            OC_FACT_ELECT_CONF_DOCTO.cLineaCup          := cLinea;
        ELSIF cCodIdLinea = 'INAD'          THEN
            OC_FACT_ELECT_CONF_DOCTO.cLineaInad         := cLinea;
        ELSIF cCodIdLinea = 'RET'           THEN
            OC_FACT_ELECT_CONF_DOCTO.cLineaRet          := cLinea;
        ELSIF cCodIdLinea = 'TRA'           THEN
            OC_FACT_ELECT_CONF_DOCTO.cLineaTra          := cLinea;
        ELSIF cCodIdLinea = 'ADD'           THEN
            OC_FACT_ELECT_CONF_DOCTO.cLineaAdd          := cLinea;
        ELSIF cCodIdLinea = 'ADI'           THEN
            OC_FACT_ELECT_CONF_DOCTO.cLineaAdi          := cLinea;
        ELSIF cCodIdLinea = 'PAGS'          THEN
            OC_FACT_ELECT_CONF_DOCTO.cLineaPags         := cLinea;
        ELSIF cCodIdLinea = 'PAGSDOCREL'   THEN
            OC_FACT_ELECT_CONF_DOCTO.cLineaPagsDocRel   := cLinea;
        END IF;
    END ASIGNA_LINEA_IDENTIFICADOR;
    --
    --
    FUNCTION CREA_DOCUMENTO(nIdFactura IN NUMBER DEFAULT NULL,nIdNcr IN NUMBER DEFAULT NULL,nCodCia IN NUMBER,nCodEmpresa IN NUMBER,
                                cProceso IN VARCHAR2,cTipoCfdi IN VARCHAR2, cIndRelaciona VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 IS
        cDocumento          VARCHAR2(10000) := NULL;
        cCodIdentificador   FACT_ELECT_CONF_DOCTO.CODIDENTIFICADOR%TYPE;
        cExiste             VARCHAR2(1);
        CURSOR Q_Dcto IS
            SELECT CodIdentificador, OrdenIdent, IndRecursivo,
                   IndImpuesto, ImptoTraRet, CodCptoImpto,
                   IndRelacion
              FROM FACT_ELECT_CONF_DOCTO
             WHERE CodCia                   = nCodCia
               AND Proceso                  = cProceso
               AND (NVL(IndRecursivo,'N')   = 'N' OR (    (NVL(IndRecursivo,'N') = 'S' AND  NVL(IndImpuesto,'N') = 'N')
                                                      AND (NVL(IndRecursivo,'N') = 'S' AND  NVL(IndRelacion,'N') = 'N')
                                                     )
                   )
             ORDER BY OrdenIdent ASC;

        CURSOR Q_Rec IS
            SELECT CodIdentificador, IndImpuesto, IndRelacion, OrdenIdent
              FROM (
                    SELECT CodIdentificador, NVL(IndImpuesto,'N') IndImpuesto, 'N' IndRelacion, OrdenIdent  ---CONIT O CONIR
                      FROM FACT_ELECT_CONF_DOCTO
                     WHERE CodCia       = nCodCia
                       AND Proceso      = cProceso
                       AND IndImpuesto  = 'S'
                       AND IndRecursivo = 'S'
                    UNION
                    SELECT CodIdentificador, 'N' IndImpuesto, NVL(IndRelacion,'N') IndRelacion, OrdenIdent ---CREL
                      FROM FACT_ELECT_CONF_DOCTO
                     WHERE CodCia       = nCodCia
                       AND Proceso      = cProceso
                       AND IndRelacion  = 'S'
                       AND IndRecursivo = 'S')
             ORDER BY OrdenIdent;

        CURSOR Q_DetCpto IS
            SELECT CodCpto,Monto_Det_Local,Saldo_Det_Moneda,
                   MtoImptoFactElect,IndTipoConcepto,Porcconcepto--,
                   --Orden_Impresion
              FROM (
                    SELECT CC.CodCptoPrimasFactElect CodCpto,SUM(DF.Monto_Det_Local) Monto_Det_Local,SUM(DF.Saldo_Det_Moneda) Saldo_Det_Moneda,
                           SUM(DF.MtoImptoFactElect) MtoImptoFactElect, CC.IndTipoConcepto, CC.Porcconcepto--,
                           --CC.Orden_Impresion
                      FROM DETALLE_FACTURAS DF,CATALOGO_DE_CONCEPTOS CC
                     WHERE IdFactura                 = nIdFactura
                       AND NVL(CC.IndEsImpuesto,'N') = 'N'
                       AND DF.CodCpto                = CC.CodConcepto
                     GROUP BY CC.CodCptoPrimasFactElect, CC.IndTipoConcepto, CC.Porcconcepto--,CC.Orden_Impresion
                     UNION ALL
                    SELECT CC.CodCptoPrimasFactElect CodCpto,SUM(DN.Monto_Det_Local) Monto_Det_Local, SUM(0) Saldo_Det_Moneda,
                           SUM(DN.MtoImptoFactElect) MtoImptoFactElect, CC.IndTipoConcepto, CC.Porcconcepto--,
                           --CC.Orden_Impresion
                      FROM DETALLE_NOTAS_DE_CREDITO DN,CATALOGO_DE_CONCEPTOS CC
                     WHERE IdNcr                     = nIdNcr
                       AND NVL(CC.IndEsImpuesto,'N') = 'N'
                       AND DN.CodCpto                = CC.CodConcepto
                     GROUP BY CC.CodCptoPrimasFactElect, CC.IndTipoConcepto, CC.Porcconcepto--,CC.Orden_Impresion
                   )
             ORDER BY NVL(Monto_Det_Local,0) DESC;

       CURSOR Q_Impto IS
           SELECT CodIdentificador ---CONIT O CONIR
             FROM FACT_ELECT_CONF_DOCTO
            WHERE CodCia       = nCodCia
              AND Proceso      = cProceso
              AND IndImpuesto  = 'S'
              AND IndRecursivo = 'S';

       CURSOR Q_Rel IS
            SELECT CodIdentificador ---CREL
              FROM FACT_ELECT_CONF_DOCTO
             WHERE CodCia       = nCodCia
               AND Proceso      = cProceso
               AND IndRelacion  = 'S'
               AND IndRecursivo = 'S';

    BEGIN
        IF cProceso IN ('EMI','PAG') THEN
            FOR X IN Q_Dcto LOOP
                IF cDocumento IS NULL THEN
                    cDocumento := OC_FACT_ELECT_CONF_DOCTO.CREA_IDENTIFICADOR(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,X.CodIdentificador,cTipoCfdi,NULL,cIndRelaciona);
                ELSE
                    IF X.IndRecursivo = 'S' THEN
                        IF cProceso = 'PAG' THEN
                            cDocumento := cDocumento||OC_FACT_ELECT_CONF_DOCTO.CREA_IDENTIFICADOR(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,X.CodIdentificador,cTipoCfdi,NULL,cIndRelaciona);
                        END IF;
                        FOR J IN Q_Rec LOOP
                            IF J.IndRelacion  = cIndRelaciona AND J.IndImpuesto = 'N' THEN
                                IF cProceso != 'PAG' THEN
                                    cDocumento := cDocumento||OC_FACT_ELECT_CONF_DOCTO.CREA_IDENTIFICADOR(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,X.CodIdentificador,cTipoCfdi,NULL,cIndRelaciona);
                                END IF;
                                OPEN Q_Rel;
                                FETCH Q_Rel INTO cCodIdentificador;

                                IF Q_Rel%NOTFOUND THEN
                                    RAISE_APPLICATION_ERROR(-20225,'No Se Ha Configurado El Registro Correspondiente A La Relacion De Timbre Fiscales, Por Favor Valide Su Configuraci�n');
                                END IF;

                                CLOSE Q_Rel;

                                FOR I IN Q_Rel LOOP ---CRELS O CREL
                                    cCodIdentificador := I.CodIdentificador;
                                    cDocumento := cDocumento||OC_FACT_ELECT_CONF_DOCTO.CREA_IDENTIFICADOR(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,cCodIdentificador,cTipoCfdi,NULL,cIndRelaciona);
                                END LOOP;
                            ELSIF J.IndRelacion  = 'N' AND J.IndImpuesto  = 'S' AND X.CodIdentificador != 'CRELS' THEN
                                FOR F IN Q_DetCpto LOOP
                                    cDocumento := cDocumento||OC_FACT_ELECT_CONF_DOCTO.CREA_IDENTIFICADOR(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,X.CodIdentificador,cTipoCfdi,F.CodCpto,cIndRelaciona);
                                    OPEN Q_Impto;
                                    FETCH Q_Impto INTO cCodIdentificador;

                                    IF Q_Impto%NOTFOUND THEN
                                        RAISE_APPLICATION_ERROR(-20225,'No Se Ha Configurado El Registro Correspondiente A Los Impuestos Por Concepto, Por Favor Valide Su Configuraci�n');
                                    END IF;

                                    CLOSE Q_Impto;

                                    IF NVL(nIdFactura,0) != 0 THEN
                                        BEGIN
                                            SELECT 'S'
                                              INTO cExiste
                                              FROM DETALLE_FACTURAS
                                             WHERE IdFactura = nIdFactura
                                               AND CodCpto IN (SELECT CodConcepto
                                                                 FROM CATALOGO_DE_CONCEPTOS
                                                                WHERE IndEsImpuesto = 'S');
                                        EXCEPTION
                                            WHEN NO_DATA_FOUND THEN
                                                cExiste := 'N';
                                            WHEN TOO_MANY_ROWS THEN
                                                cExiste := 'S';
                                        END;
                                    ELSIF NVL(nIdNcr,0) != 0 THEN
                                        BEGIN
                                            SELECT 'S'
                                              INTO cExiste
                                              FROM DETALLE_NOTAS_DE_CREDITO
                                             WHERE IdNcr = nIdNcr
                                               AND CodCpto IN (SELECT CodConcepto
                                                                 FROM CATALOGO_DE_CONCEPTOS
                                                                WHERE IndEsImpuesto = 'S');
                                        EXCEPTION
                                            WHEN NO_DATA_FOUND THEN
                                                cExiste := 'N';
                                            WHEN TOO_MANY_ROWS THEN
                                                cExiste := 'S';
                                        END;
                                    END IF;

                                    IF cExiste = 'S' THEN
                                        FOR I IN Q_Impto LOOP ---CONIT O CONIR
                                            cCodIdentificador := I.CodIdentificador;
                                            cDocumento := cDocumento||OC_FACT_ELECT_CONF_DOCTO.CREA_IDENTIFICADOR(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,cCodIdentificador,cTipoCfdi,F.CodCpto,cIndRelaciona);
                                        END LOOP;
                                    END IF;
                                END LOOP;
                            END IF;
                        END LOOP;
                        CONTINUE;
                    ELSE
                        IF X.IndImpuesto = 'S' AND cExiste = 'N' THEN
                            NULL; -- SE DEBE OMITIR EL REGISTRO DE IMPUESTOS CUANDO NO HAY CONCEPTOS DEIMPUESTOS POR LO QUE NO SE GENERAESTA LINEA
                        ELSE
                            cDocumento := cDocumento||OC_FACT_ELECT_CONF_DOCTO.CREA_IDENTIFICADOR(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,X.CodIdentificador,cTipoCfdi,NULL,cIndRelaciona);
                        END IF;
                    END IF;
                END IF;
            END LOOP;
        ELSIF  cProceso = 'CAN' THEN
            cDocumento := OC_FACT_ELECT_DETALLE_TIMBRE.UUID_PROCESO(nCodCia, nCodEmpresa, nIdFactura, nIdNcr, 'EMI'); -- CUANDO SE CANCELA SOLO SE PUEDE BUSCAR EL PROCESO EMI YA QUE EL PROCESO PAGO NO SE PUEDE CANCELAR
        END IF;
        RETURN cDocumento;
    END CREA_DOCUMENTO;
    --
    --
    FUNCTION  CREA_IDENTIFICADOR (nIdFactura IN NUMBER,nIdNcr IN NUMBER DEFAULT NULL,nCodCia IN NUMBER,nCodEmpresa IN NUMBER,
                                    cProceso IN VARCHAR2,cCodIdLinea IN VARCHAR2,cTipoCfdi IN VARCHAR2,cCodCpto IN VARCHAR2 DEFAULT NULL,
                                    cIndRelaciona VARCHAR2) RETURN VARCHAR2 IS
        cLineaIdent      VARCHAR2(32700) := NULL;
        cSeparadorIdent  VARCHAR2(3) := '|||';
        cSeparadorCampo  VARCHAR2(2) := '||';
        cSeparadorValor  VARCHAR2(1) := '|';
        cSaltoLinea      VARCHAR2(3) := CHR(13);
        cSqlDinAtrib     DETALLE_FACT_ELECT_CONF_DOCTO.Consulta%TYPE;
        cValorAtributo   DETALLE_FACT_ELECT_CONF_DOCTO.ValorAtributo%TYPE;

        CURSOR Q_IdLine IS
            SELECT FE.CodIdentificador, CodAtributo, OrdenAtrib, CondicionAtributo,
                   TipoValorAtributo, ValorAtributo, Consulta, Proceso,
                   IndEnviaCia, DFE.CodRutinaCalc
              FROM FACT_ELECT_CONF_DOCTO FE,DETALLE_FACT_ELECT_CONF_DOCTO DFE
             WHERE FE.CodIdentificador = cCodIdLinea
               AND FE.CodCia           = nCodCia
               AND FE.Proceso          = cProceso
               AND FE.IdIdentificador  = DFE.IdIdentificador
             ORDER BY OrdenAtrib ASC;
    BEGIN
        FOR X IN Q_IdLine LOOP
            cValorAtributo := NULL;
            IF cLineaIdent IS NULL THEN
                cLineaIdent := cCodIdLinea||cSeparadorIdent;
            END IF;
            IF X.CondicionAtributo = 'R' THEN
                IF X.TipoValorAtributo = 'F' THEN
                    cValorAtributo := X.ValorAtributo;
                ELSIF (X.TipoValorAtributo = 'D' AND X.Consulta IS NOT NULL) OR
                        (X.TipoValorAtributo = 'L' AND X.Consulta IS NOT NULL) THEN
                    cSqlDinAtrib := X.Consulta;
                    cValorAtributo := OC_DDL_OBJETOS.EJECUTAR_QUERY(cSqlDinAtrib);
                ELSIF X.TipoValorAtributo = 'D' AND X.Consulta IS NULL THEN
                    cValorAtributo := OC_DET_FACT_ELECT_CONF_DOCTO.GENERA_VALOR_ATRIBUTO(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,cCodIdLinea,X.CodAtributo,cTipoCfdi,cCodCpto,X.CodRutinaCalc,cIndRelaciona);
                END IF;
            ELSIF X.CondicionAtributo = 'O' AND X.IndEnviaCia = 'S' THEN
                IF X.TipoValorAtributo = 'F' THEN
                    cValorAtributo := X.ValorAtributo;
                ELSIF (X.TipoValorAtributo = 'D' AND X.Consulta IS NOT NULL) OR
                        (X.TipoValorAtributo = 'L' AND X.Consulta IS NOT NULL) THEN
                    cSqlDinAtrib := X.Consulta;
                    cValorAtributo := OC_DDL_OBJETOS.EJECUTAR_QUERY(cSqlDinAtrib);
                ELSIF X.TipoValorAtributo = 'D' AND X.Consulta IS NULL THEN
                    cValorAtributo := OC_DET_FACT_ELECT_CONF_DOCTO.GENERA_VALOR_ATRIBUTO(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,cCodIdLinea,X.CodAtributo,cTipoCfdi,cCodCpto,X.CodRutinaCalc,cIndRelaciona);
                END IF;
            ELSIF X.CondicionAtributo = 'C' THEN
                --cValorAtributo := OC_DET_FACT_ELECT_CONF_DOCTO.GENERA_VALOR_ATRIBUTO(nIdFactura,nIdNcr,nCodCia,cProceso,cCodIdLinea,X.CodAtributo,cTipoCfdi);
                IF X.TipoValorAtributo = 'F' THEN
                    cValorAtributo := X.ValorAtributo;
                ELSIF (X.TipoValorAtributo = 'D' AND X.Consulta IS NOT NULL) OR
                        (X.TipoValorAtributo = 'L' AND X.Consulta IS NOT NULL) THEN
                    cSqlDinAtrib := X.Consulta;
                    cValorAtributo := OC_DDL_OBJETOS.EJECUTAR_QUERY(cSqlDinAtrib);
                ELSIF X.TipoValorAtributo = 'D' AND X.Consulta IS NULL THEN
                    cValorAtributo := OC_DET_FACT_ELECT_CONF_DOCTO.GENERA_VALOR_ATRIBUTO(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,cCodIdLinea,X.CodAtributo,cTipoCfdi,cCodCpto,X.CodRutinaCalc,cIndRelaciona);
                END IF;
            END IF;
            IF cValorAtributo IS NOT NULL THEN
                cLineaIdent := cLineaIdent||X.CodAtributo||cSeparadorValor||cValorAtributo||cSeparadorCampo;
                OC_FACT_ELECT_CONF_DOCTO.ASIGNA_LINEA_IDENTIFICADOR(cCodIdLinea,cLineaIdent);
            END IF;
        END LOOP;
        cLineaIdent := SUBSTR(cLineaIdent,1,LENGTH(cLineaIdent) - 2)||cSaltoLinea;
        RETURN cLineaIdent;
    END CREA_IDENTIFICADOR;
    --
    --
    FUNCTION  CONCEPTO_IMPUESTO (nCodCia NUMBER, cProceso VARCHAR2, cCodIdLea VARCHAR2) RETURN VARCHAR2 IS
        cCodCptoImpto FACT_ELECT_CONF_DOCTO.CodCptoImpto%TYPE;
    BEGIN
        BEGIN
           SELECT CodCptoImpto
             INTO cCodCptoImpto
             FROM FACT_ELECT_CONF_DOCTO
            WHERE CodCia            = nCodCia
              AND Proceso           = cProceso
              AND IndImpuesto       = 'S'
              --AND IndRecursivo      = 'S'
              AND CodIdentificador  = cCodIdLea;
        END;
        RETURN cCodCptoImpto;
    END CONCEPTO_IMPUESTO;

    PROCEDURE TIMBRAR(PnIdFactura  NUMBER DEFAULT NULL,PnIdNcr  NUMBER DEFAULT NULL,nCodCia  NUMBER,nCodEmpresa  NUMBER, cProceso  VARCHAR2,cTipoCfdi VARCHAR2, cIndRelaciona VARCHAR2 DEFAULT NULL, cCodRespuesta OUT VARCHAR2, IndOtroPac VARCHAR2 DEFAULT NULL) IS
        nError             NUMBER;
        cDocto             VARCHAR2(10000);
        cSoapRequest       VARCHAR2 (30000);
        BreqLength         BINARY_INTEGER;
        cBuffer            VARCHAR2(2000);
        cBuffer2           VARCHAR2(32767);
        iAmount            PLS_INTEGER := 2000;
        iOffset            PLS_INTEGER := 1;
        cFolio             FACT_ELECT_DETALLE_TIMBRE.FolioFiscal%TYPE;
        cSerie             FACT_ELECT_DETALLE_TIMBRE.Serie%TYPE;
        eHttpReq           UTL_HTTP.req;
        eHttpResp          UTL_HTTP.resp;
        cClobPDF           CLOB;
        cStrTxt            CLOB;
        cClobXml           CLOB;
        cClob2Xml          CLOB;
        cTimbrarFact       VARCHAR2(2000);
        cNombreArchivoXml  VARCHAR2 (32747);
        cNombreArchivoTxt  VARCHAR2 (32747);
        cNombreArchivoPdf  VARCHAR2 (32747);
        cUuid              VARCHAR2 (50);
        nPos               NUMBER;
        nIndex             NUMBER;
        nCantidad          NUMBER;
        bPdf               BOOLEAN;
        nErrDesc           NUMBER;
        nPosPDF            NUMBER;
        cValorXml          VARCHAR2(3200);
        nPos3              NUMBER;
        nPosErrI           NUMBER;
        nPosErrF           NUMBER;
        cDatoErr           VARCHAR2(3000);
        cCodigoErr         VARCHAR2(10);
        cDescEror          VARCHAR2(1000);
        cXml3              VARCHAR2(5000);
        cSelloCFD          VARCHAR2(1000);
        cNoCertificado     VARCHAR2(1000);
        cCertificado       VARCHAR2(5000);
        cSelloSAT          VARCHAR2(5000);

        TYPE Varchar2Table IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
        vtStrXml           Varchar2Table;

        cPathWallet        VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'017');
        cPwdWallet         VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'018');
        cUser              VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'024');
        cPwd               VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'025');
        nTotal             NUMBER(28,2);
        cRFC               VARCHAR2(20);
        nIdPoliza          POLIZAS.IdPoliza%TYPE;
        cCodCliente        FACTURAS.CodCliente%TYPE;
        nCodAsegurado      ASEGURADO.Cod_Asegurado%TYPE;
        cUuidCancelado     FACT_ELECT_DETALLE_TIMBRE.UuidCancelado%TYPE;
        nIdTimbre          FACT_ELECT_DETALLE_TIMBRE.IDTIMBRE%TYPE;
        nIdFactura         NUMBER;
        nIdNcr             NUMBER;
        cLinea             VARCHAR2(100);
        
    BEGIN
        nIdFactura :=  nvl(PnIdFactura, 0);
        nIdNcr :=  nvl(PnIdNcr, 0);
          
        DELETE FROM FACT_ELECT_REGISTROS_XML X
         WHERE NVL(X.IdFactura, 0) = nIdFactura
           AND NVL(X.IdNcr, 0)     = nIdNcr;
       

        IF NVL(nIdFactura,0) != 0 AND cProceso != 'CAN' THEN
            UPDATE FACTURAS
               SET IndFactElectronica = 'S',
                   FecEnvFactElec     = NULL,
                   CodUsuarioEnvFact  = 'XENVIAR'
             WHERE IdFactura = nIdFactura;
        ELSIF NVL(nIdNcr,0) != 0 AND cProceso != 'CAN' THEN
            UPDATE NOTAS_DE_CREDITO
               SET IndFactElectronica = 'S',
                   FecEnvFactElec     = NULL,
                   CodUsuarioEnvFact  = 'XENVIAR'
             WHERE IdNcr = nIdNcr;
        ELSIF cProceso = 'CAN' AND NVL(nIdFactura,0) != 0 THEN
            UPDATE FACTURAS
               SET IndFactElectronica    = 'S',
                   FecEnvFactElecAnu     = NULL,
                   CodUsuarioEnvFactAnu  = 'XENVIAR'
             WHERE IdFactura = nIdFactura;
        ELSIF cProceso = 'CAN' AND NVL(nIdNcr,0) != 0 THEN
            UPDATE NOTAS_DE_CREDITO
               SET IndFactElectronica    = 'S',
                   FecEnvFactElecAnu     = NULL,
                   CodUsuarioEnvFactAnu  = 'XENVIAR'
             WHERE IdNcr = nIdNcr;
        END IF;


        cDocto := OC_FACT_ELECT_CONF_DOCTO.CREA_DOCUMENTO(nIdFactura, nIdNcr, nCodCia, nCodEmpresa, cProceso, cTipoCfdi, cIndRelaciona);
        IF cProceso != 'CAN' THEN
            cFolio := OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaCom,'folio');
            cSerie := OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaCom,'serie');
        END IF;
        UTL_HTTP.set_wallet('file:'||cPathWallet,cPwdWallet);
        IF cProceso IN ('EMI','PAG') THEN
            cTimbrarFact := OC_GENERALES.BUSCA_PARAMETRO(nCodCia, '023');
            cSoapRequest :=
            '<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
                <soapenv:Body>
                    <RecibirTXT soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
                        <usuario xsi:type="xsd:string">'
                        || cUser ||
                        '</usuario>
                        <contra xsi:type="xsd:string">'
                        || cPwd ||
                        '</contra>
                        <documento xsi:type="xsd:text">'
                         || cDocto ||'
                        </documento>
                        <consecutivo xsi:type="xsd:string">0</consecutivo>
                    </RecibirTXT>
                </soapenv:Body>
            </soapenv:Envelope>';
        ELSIF  cProceso = 'CAN' THEN
            --cUuidCancelado := cDocto;
            IF NVL(IndOtroPac,'N') = 'S' THEN -- CANCELACION OTRO PAC
                cTimbrarFact := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'038');
                IF NVL(nIdFactura,0) != 0 THEN
                    SELECT NVL(SUM(F.Monto_Fact_Local),0),IdPoliza,CodCliente
                      INTO nTotal,nIdPoliza,cCodCliente
                      FROM FACTURAS F
                     WHERE F.Codcia    = nCodCia
                       AND F.IdFactura = nIdFactura
                     GROUP BY IdPoliza,CodCliente;
                ELSIF NVL(nIdNcr,0) != 0 THEN
                    SELECT NVL(SUM(N.Monto_Ncr_Local),0),IdPoliza,CodCliente
                      INTO nTotal,nIdPoliza,cCodCliente
                      FROM NOTAS_DE_CREDITO N
                     WHERE N.Codcia    = nCodCia
                       AND N.IdNcr     = nIdNcr
                     GROUP BY IdPoliza,CodCliente;
                END IF;
                
                IF OC_POLIZAS.FACTURA_POR_POLIZA(nCodCia, nCodEmpresa, nIdPoliza) = 'S' THEN
                   cRFC := OC_CLIENTES.IDENTIFICACION_TRIBUTARIA(cCodCliente);
                ELSE
                    IF NVL(nIdFactura,0) != 0 THEN
                        SELECT A.Cod_Asegurado
                          INTO nCodAsegurado
                          FROM DETALLE_POLIZA D,ASEGURADO A,FACTURAS F
                         WHERE F.Codcia         = nCodCia
                           AND F.IdFactura      = nIdFactura
                           AND F.IdPoliza       = nIdPoliza
                           AND A.Cod_Asegurado  = D.Cod_Asegurado
                           AND D.CodCia         = F.CodCia
                           AND D.IdPoliza       = F.IdPoliza
                           AND D.IDetPol        = F.IDetPol;
                    ELSIF NVL(nIdNcr,0) != 0 THEN
                        SELECT A.Cod_Asegurado
                          INTO nCodAsegurado
                          FROM DETALLE_POLIZA D,ASEGURADO A,NOTAS_DE_CREDITO N
                         WHERE N.Codcia         = nCodCia
                           AND N.IdNcr          = nIdNcr
                           AND N.IdPoliza       = nIdPoliza
                           AND A.Cod_Asegurado  = D.Cod_Asegurado
                           AND D.CodCia         = N.CodCia
                           AND D.IdPoliza       = N.IdPoliza
                           AND D.IDetPol        = N.IDetPol;
                    END IF;
                    cRFC := OC_ASEGURADO.IDENTIFICACION_TRIBUTARIA_ASEG(nCodCia, nCodEmpresa, nCodAsegurado);
                END IF;
                 cSoapRequest :=
                 '<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
                    <soapenv:Header/>
                    <soapenv:Body>
                       <CancelarCFDIOtroPac soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
                          <usuario xsi:type="xsd:string">'|| cUser ||'</usuario>
                          <contra xsi:type="xsd:string">'|| cPwd ||'</contra>
                          <rfcReceptor xsi:type="xsd:string">'|| cRFC ||'</rfcReceptor>
                          <total xsi:type="xsd:string">'|| TO_CHAR(nTotal) ||'</total>
                          <uuid xsi:type="xsd:string">'|| cDocto ||'</uuid>
                       </CancelarCFDIOtroPac>
                    </soapenv:Body>
                 </soapenv:Envelope>';
            ELSE
                cTimbrarFact := OC_GENERALES.BUSCA_PARAMETRO(nCodCia, '027');
                cSoapRequest :=
                '<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
                   <soapenv:Header/>
                   <soapenv:Body>
                      <CancelarCFDI soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
                         <usuario xsi:type="xsd:string">'|| cUser ||'</usuario>
                         <contra xsi:type="xsd:string">'|| cPwd ||'</contra>
                         <uuid xsi:type="xsd:string">'|| cDocto ||'</uuid>
                      </CancelarCFDI>
                   </soapenv:Body>
                </soapenv:Envelope>';
            END IF;
        END IF;
        --- INSERTAMOS DETALLE DE TIMBRE FISCAL (HISTORIA)
       -- DBMS_OUTPUT.PUT_LINE('Antes Insert OC_FACT_ELECT_DETALLE_TIMBRE');     
        nIdTimbre := 0;
--                OC_FACT_ELECT_DETALLE_TIMBRE.INSERTA_DETALLE(nCodCia, nCodEmpresa, nIdFactura ,
--                                                     nIdNcr, cProceso, cUuid,
--                                                     TRUNC(SYSDATE), cFolio, cSerie,
--                                                     cCodRespuesta,cUuidCancelado,
--                                                     nIdTimbre);
        --DBMS_OUTPUT.PUT_LINE('Despues Insert OC_FACT_ELECT_DETALLE_TIMBRE');                                                         
        --
        cNombreArchivoXml := LPAD(TO_CHAR(NVL(nIdFactura,nIdNcr)),14,'0') ||TO_CHAR(cFolio) || '.xml';
        cNombreArchivoTxt := LPAD(TO_CHAR(NVL(nIdFactura,nIdNcr)),14,'0') ||TO_CHAR(cFolio) || '.txt';
        cNombreArchivoPdf := LPAD(TO_CHAR(NVL(nIdFactura,nIdNcr)),14,'0') ||TO_CHAR(cFolio) || '.pdf';

        UTL_HTTP.SET_TRANSFER_TIMEOUT(3000);
        eHttpReq := UTL_HTTP.BEGIN_REQUEST (cTimbrarFact, 'POST', 'HTTP/1.1');
        UTL_HTTP.SET_BODY_CHARSET (eHttpReq, 'UTF8');
        UTL_HTTP.SET_HEADER (eHttpReq, 'Content-Type', 'text/xml');

        BreqLength := DBMS_LOB.GETLENGTH(cSoapRequest);

        IF BreqLength<= 32767 then
            UTL_HTTP.SET_HEADER (eHttpReq, 'Content-Length', BreqLength);
            UTL_HTTP.WRITE_TEXT (eHttpReq, cSoapRequest);
            nError := 1;
        ELSIF BreqLength> 32767 then
            UTL_HTTP.SET_HEADER (eHttpReq, 'Transfer-Encoding','chunked');
            nError := 0;
            WHILE (iOffset<BreqLength)
            LOOP
                DBMS_LOB.READ(cSoapRequest,iAmount,iOffset,cBuffer);
                UTL_HTTP.write_text(eHttpReq,cBuffer);
                iOffset := iOffset + iAmount;
            END LOOP;
        END IF;

        DBMS_LOB.CREATETEMPORARY(cClobXml, FALSE);
        cLinea := 'Linea 1';
        eHttpResp := UTL_HTTP.GET_RESPONSE (eHttpReq);
        --UTL_HTTP.READ_TEXT(eHttpResp,cStrTxt,32767);

        -- LEE LA RESPUESTA DEL WEBSERVICE EN "CHUNKS"
        -- YA QUE EL TAMA?O DE LA MISMA LO REQUIERE
        BEGIN
            LOOP
                UTL_HTTP.READ_TEXT(eHttpResp,cBuffer2,32767);
                    cClob2Xml:= '';
                    DBMS_LOB.WRITEAPPEND(cClobXml, LENGTH(cBuffer2), cBuffer2);
                    cClob2Xml := cClobXml;
            END LOOP;

        EXCEPTION
            WHEN UTL_HTTP.END_OF_BODY THEN
               UTL_HTTP.END_RESPONSE(eHttpResp);
        END;

        DBMS_LOCK.SLEEP(2);

        nPos := 1;
        nIndex :=1;
        BreqLength := DBMS_LOB.GETLENGTH(cClob2Xml);
        nCantidad := 3000;
        bPdf := FALSE;
        cClobPDF := '';
        cLinea := 'Linea 2';
                
        -- RECUPERA LA RESPUESTA DEL WEBSERVICE Y LA ALMACENA EN UNA TABLA FISICA
        WHILE nPos <= BreqLength
        LOOP
            vtStrXml(nIndex) := DBMS_LOB.SUBSTR(cClob2Xml, nCantidad, nPos);
            nPosPDF := 0;
            INSERT INTO FACT_ELECT_REGISTROS_XML VALUES(vtStrXml(nIndex), nIdFactura, nIdNcr);
            nPosPDF := instr(vtStrXml(nIndex),'<documentopdf');
            IF nPosPDF > 0 THEN
                cClobPDF := cClobPDF || substr(vtStrXml(nIndex),nPosPDF+36,LENGTH(vtStrXml(nIndex))-(nPosPDF-1));
                --nPos3 := instr(vtStrXml(nIndex),'UUID');
                --cXml3 := substr(vtStrXml(nIndex),nPos3+11,36);
                bPdf := TRUE;
            ELSE
                 IF bPdf = TRUE THEN
                    cClobPDF := cClobPDF || vtStrXml(nIndex);
                 END IF;
            END IF;
            nPos := nPos + 3000;
            nIndex := nIndex + 1;
            IF nPos > BreqLength THEN
                nCantidad := BreqLength - nPos;
                nPos := nPos - nCantidad;
            END IF;
        END LOOP;
        IF nIndex = 0 then
                INSERT INTO FACT_ELECT_REGISTROS_XML VALUES(cClob2Xml, nIdFactura, nIdNcr);        
        END IF;


        DBMS_LOCK.SLEEP(2);

        cUuid := '' ;
        nErrDesc := 0;
        cValorXml := '';
        nPos3 := 0;
        cXml3 := '';
        cDatoErr := null;

        BEGIN
            SELECT Valor
              INTO cDatoErr
              FROM FACT_ELECT_REGISTROS_XML 
              WHERE Valor LIKE '%codigo xsi%'
                   AND IDFACTURA = nIdFactura
                   AND IDNCR     = nIdNcr;
        cLinea := 'Linea 3';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
            WHEN OTHERS THEN
                NULL;
        END;
        nPosErrI        := INSTR(cDatoErr,'codigo xsi') + 29;
        nPosErrF        := INSTR(cDatoErr,'/codigo') - 1;
        cCodigoErr      := SUBSTR(cDatoErr,nPosErrI,nPosErrF-nPosErrI);
        cCodRespuesta   := cCodigoErr;

        IF cCodRespuesta = OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'026') THEN   -- SE TIMBRO DE MANERA CORRECTA
            IF cProceso != 'CAN' THEN
                IF NVL(nIdFactura,0) != 0 and nIdFactura > 0 THEN
                cLinea := 'Linea 4';
                        UPDATE FACTURAS
                           SET FolioFactelec     = cFolio ,
                               FecEnvFactElec    = TRUNC(SYSDATE),
                               CodUsuarioEnvFact = USER
                         WHERE IdFactura         = nIdFactura;
                ELSIF NVL(nIdNcr,0) != 0 and nIdNcr > 0 THEN
                cLinea := 'Linea 5';
                        UPDATE NOTAS_DE_CREDITO
                           SET FolioFactelec     = cFolio ,
                               FecEnvFactElec    = TRUNC(SYSDATE),
                               CodUsuarioEnvFact = USER
                         WHERE IdNcr             = nIdNcr;
                END IF;
            ELSIF  cProceso = 'CAN' THEN
                cUuidCancelado := cDocto;
            END IF;
            
            IF  cProceso != 'CAN' THEN
                BEGIN
                    SELECT COUNT(*) INTO nErrDesc FROM FACT_ELECT_REGISTROS_XML 
                     WHERE Valor LIKE '%UUID%'
                       AND IDFACTURA = nIdFactura
                       AND IDNCR     = nIdNcr;
                EXCEPTION WHEN OTHERS THEN
                     nErrDesc := 0;
                END;
                cLinea := 'Linea 6';
                IF nErrDesc > 0 THEN

                    SELECT Valor INTO cValorXml from FACT_ELECT_REGISTROS_XML
                     WHERE Valor LIKE '%UUID%'
                       AND IDFACTURA = nIdFactura
                       AND IDNCR     = nIdNcr;
                    nPos3 := INSTR(cValorXml,'UUID');
                    cXml3 := SUBSTR(cValorXml,nPos3+11,36);

                    cUuid := TRIM(cXml3);

    --                SELECT Valor INTO cValorXml from FACT_ELECT_REGISTROS_XML WHERE Valor LIKE '%<cfdi:Comprobante%';
    --                nPos3 := INSTR(cValorXml,'<cfdi:Comprobante');
    --                cXml3 := SUBSTR(cValorXml,nPos3,36);
                END IF;
            END IF;
--            cSelloDigital      VARCHAR2(1000);
--
--            SELECT COUNT(*) INTO nErrDesc FROM FACT_ELECT_REGISTROS_XML WHERE Valor LIKE '%UUID%';
--
--            cNoCertificado     VARCHAR2(1000);
--            cCertificado       VARCHAR2(5000);

        ELSE
            BEGIN
            SELECT COUNT(*) 
              INTO nErrDesc 
              FROM FACT_ELECT_REGISTROS_XML 
             WHERE Valor LIKE '%error parsing SOAP%'
               AND IDFACTURA = nIdFactura
               AND IDNCR     = nIdNcr;
            EXCEPTION WHEN OTHERS THEN
                     nErrDesc := 0;
            END;
            cLinea := 'Linea 7 ' || nErrDesc;
            IF nErrDesc = 0 THEN
                BEGIN
                    SELECT Valor INTO cDatoErr FROM FACT_ELECT_REGISTROS_XML 
                        WHERE Valor LIKE '%<descripcion xsi:type="xsd:string">%'
                           AND IDFACTURA = nIdFactura
                           AND IDNCR     = nIdNcr;
                EXCEPTION WHEN OTHERS THEN
                     nErrDesc := 0;
                END;
                nPosErrI        := INSTR(cDatoErr,'<descripcion xsi:type="xsd:string">') + 35;
                nPosErrF        := INSTR(cDatoErr,'/descripcion') - 1;
                cDescEror      := SUBSTR(cDatoErr,nPosErrI,nPosErrF-nPosErrI);
            ELSE
--               --- envio de email con error desconocido
                 cCodRespuesta   := '501';
                 cLinea := 'Linea 8';
            END IF;
        END IF;
        --
        cLinea := 'Linea 8.1';
        --OC_FACT_ELECT_DETALLE_TIMBRE.INSERTA_DETALLE(nCodCia, nCodEmpresa, nIdTimbre, cProceso, cUuid, TRUNC(SYSDATE),cCodRespuesta, cStsTimbre, cUuidCancelado);
        OC_FACT_ELECT_DETALLE_TIMBRE.INSERTA_DETALLE(nCodCia, nCodEmpresa, nIdFactura ,
                                                     nIdNcr, cProceso, cUuid,
                                                     TRUNC(SYSDATE), cFolio, cSerie,
                                                     cCodRespuesta,cUuidCancelado,
                                                     nIdTimbre);
        --OC_FACT_ELECT_DETALLE_TIMBRE.ACTUALIZA_DETALLE(nCodCia, nCodEmpresa, nIdTimbre, cProceso, cUuid, TRUNC(SYSDATE),cCodRespuesta, cUuidCancelado);
        cLinea := 'Linea 9';    
        DBMS_OUTPUT.PUT_LINE(cLinea);                                       
        IF cCodRespuesta = OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'026') THEN --- NOTIFICACIONES
            --Aqui se envia la notificacion de que el timbrado fue realizado de manera correcta
            cLinea := 'Linea 10';
            OC_FACT_ELECT_CONF_DOCTO.ENVIA_CORREO(nCodCia,nCodEmpresa,nIdFactura,nIdNcr,cProceso,cCodRespuesta,NULL,cDocto);
            cLinea := 'Linea 11'; 
        ELSE
            --Aqui envia mail conmensaje de error conocido
            cLinea := 'Linea 12';
            OC_FACT_ELECT_CONF_DOCTO.ENVIA_CORREO(nCodCia,nCodEmpresa,nIdFactura,nIdNcr,cProceso,cCodRespuesta,cDescEror,cDocto);
            cLinea := 'Linea 13';
        END IF;
        IF nIdFactura != 0 THEN
           DELETE FROM FACT_ELECT_REGISTROS_XML X
            WHERE NVL(X.IdFactura, 0) = nIdFactura;
        ELSIF nIdNcr != 0 THEN
           DELETE FROM FACT_ELECT_REGISTROS_XML X
            WHERE NVL(X.IdNcr, 0)     = nIdNcr;
        END IF;
    EXCEPTION WHEN OTHERS THEN
            OC_FACT_ELECT_CONF_DOCTO.ENVIA_CORREO(nCodCia,nCodEmpresa,nIdFactura,nIdNcr,cProceso,cCodRespuesta,cDescEror || CHR(10) ||SQLERRM || '-' || cLinea, cDocto );
            RAISE_APPLICATION_ERROR(-20200,sqlerrm);
    END TIMBRAR;

    PROCEDURE ENVIA_CORREO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFactura  NUMBER DEFAULT NULL,nIdNcr  NUMBER DEFAULT NULL,
                            cProceso  VARCHAR2,cCodRespuesta VARCHAR2, cDescError VARCHAR2 DEFAULT NULL, cDocto VARCHAR2 DEFAULT NULL) IS
        cMessage           VARCHAR2(4000);
        cMessageFactNcr    VARCHAR2(100);
        cEmail             VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'031');--'hgonzalez@thonaseguros.mx';
        cEmailOrig         VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'021');
        cPwdEmail          VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'022');--'Thona2017';
        cEmailDest         VARCHAR2(100) := OC_USUARIOS.EMAIL(nCodCia,USER);
        cEmailCC           VARCHAR2(100);
        cSubject           VARCHAR2(1000);
        cSubjectFactNcr    VARCHAR2(1000);
        cFolioFiscal       FACT_ELECT_DETALLE_TIMBRE.FolioFiscal%TYPE;
        cUUID              FACT_ELECT_DETALLE_TIMBRE.UUID%TYPE;
        cSerie             FACT_ELECT_DETALLE_TIMBRE.Serie%TYPE;
        cNombreCliente     VARCHAR2(2000);
        cIdentFiscal       VARCHAR2(100);
        nIdPoliza          POLIZAS.IdPoliza%TYPE;
        cNumPolUnico       POLIZAS.NumPolUnico%TYPE;
    BEGIN
        cUUID        := OC_FACT_ELECT_DETALLE_TIMBRE.UUID_PROCESO(nCodCia, nCodEmpresa, nIdFactura,nIdNcr, cProceso);
        cFolioFiscal := OC_FACT_ELECT_DETALLE_TIMBRE.FOLIO_FISCAL(nCodCia, nCodEmpresa, nIdFactura,nIdNcr, cUUID);
        cSerie       := OC_FACT_ELECT_DETALLE_TIMBRE.SERIE(nCodCia, nCodEmpresa, nIdFactura,nIdNcr, cUUID);
        IF NVL(nIdFactura,0) != 0 THEN
            BEGIN
                SELECT OC_CLIENTES.NOMBRE_CLIENTE(F.CodCliente),OC_CLIENTES.IDENTIFICACION_TRIBUTARIA(F.CodCliente),
                       OC_POLIZAS.NUMERO_UNICO(nCodCia,P.IdPoliza)
                  INTO cNombreCliente,cIdentFiscal,cNumPolUnico
                  FROM FACTURAS F,POLIZAS P
                 WHERE IdFactura  = nIdFactura
                   AND F.IdPoliza = P.IdPoliza;
            END;
            cSubjectFactNcr := 'El Aviso de Cobro '||nIdFactura;
            IF cProceso = 'EMI' THEN
                cMessageFactNcr := 'El Aviso de Cobro '||nIdFactura;
            ELSIF cProceso = 'CAN' THEN
                cMessageFactNcr := 'La Cancelaci�n del Aviso de Cobro '||nIdFactura;
            ELSIF cProceso = 'PAG' THEN
                cMessageFactNcr := 'El Complemento de Pago Para El Aviso de Cobro '||nIdFactura;
            END IF;
        ELSIF NVL(nIdNcr,0) != 0 THEN
            BEGIN
                SELECT OC_CLIENTES.NOMBRE_CLIENTE(F.CodCliente),OC_CLIENTES.IDENTIFICACION_TRIBUTARIA(F.CodCliente),
                       OC_POLIZAS.NUMERO_UNICO(nCodCia,P.IdPoliza)
                  INTO cNombreCliente,cIdentFiscal,cNumPolUnico
                  FROM NOTAS_DE_CREDITO F,POLIZAS P
                 WHERE IdNcr = nIdNcr
                   AND F.IdPoliza = P.IdPoliza;
            END;
            cSubjectFactNcr := 'La Nota De Cr�dito '||nIdNcr;
            IF cProceso = 'EMI' THEN
                cMessageFactNcr := 'Nota De C�dito '||nIdNcr;
            ELSIF cProceso = 'CAN' THEN
                cMessageFactNcr := 'Cancelaci�n de la Nota De C�dito '||nIdNcr;
            END IF;
        END IF;
        IF cCodRespuesta = OC_GENERALES.BUSCA_PARAMETRO(nCodCia, '026') THEN
            cSubject := 'Comprobante Fiscal Digital de: '||cNombreCliente||' ('||cIdentFiscal||')'; ---DEFINIR LISTA DE DISTRIBUCION
            cMessage := 'Estimado Agente

    Se ha generado su Facturaci�n Electr�nica para '||cMessageFactNcr||' de la P�liza '||cNumPolUnico||' con los siguientes datos

    UUID: '||cUUID||'
    Folio Fiscal: '||cFolioFiscal||'
    Serie: '||cSerie||'

    Los archivos XML y PDF los podr�s descargar del Portal de Agentes.

    Este Correo es Generado de Manera Autom�tica, Por Favor no lo Responda

    '||OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia);


        ELSE
            ---    OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CATERRSAT',cCodRespuesta)||'
            --cEmailDest := OC_USUARIOS.EMAIL(nCodCia,USER);
            cSubject   := INITCAP(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PROCFACELE', cProceso))|| ' Para '||cSubjectFactNcr||' Realizado de Manera Incorrecta';---DEFINIR LISTA DE DISTRIBUCION
            cMessage   := cMessageFactNcr|| ' no se timbr� de manera correcta por la siguiente raz�n

 Error: '||cCodRespuesta||':'||cDescError||'

 El Documento o UUID de env�o al SAT se adjunta a continuaci�n:

 '||

 cDocto

 ||'

 Favor de Validar el Documento de Env�o y ejecutar nuevamente el Timbrado';
        END IF;
        OC_MAIL.INIT_PARAM;
        OC_MAIL.cCtaEnvio    := cEmailOrig;
        OC_MAIL.cPwdCtaEnvio := cPwdEmail;
        OC_MAIL.MAIL(cEmail,cEmailDest,null,null,cSubject,cMessage);
    END ENVIA_CORREO;

    FUNCTION  DESTINATARIOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFactura  NUMBER DEFAULT NULL,nIdNcr  NUMBER DEFAULT NULL, cTipoDest VARCHAR2) RETURN VARCHAR2 IS
        nIdPoliza                   NUMBER;
        cDestCC                     VARCHAR2(1000) := NULL;
        cDest                       VARCHAR2(1000) := NULL;
        cNumDocIdentificacion       AGENTES.Num_Doc_Identificacion%TYPE;
        cSeparador                  VARCHAR2(1) := ',';
        CURSOR Q_Agentes IS
            SELECT A.Cod_Agente,
                   OC_AGE_DISTRIBUCION_COMISION.AGENTE_DISTR (P.CodCia,
                                                              P.IdPoliza,
                                                              DP.IDetPol,
                                                              2,
                                                              A.Cod_Agente) Codigo_Promotor,
                   OC_AGE_DISTRIBUCION_COMISION.AGENTE_DISTR (P.CodCia,
                                                              P.IdPoliza,
                                                              DP.IDetPol,
                                                              1,
                                                              A.Cod_Agente) Codigo_Direccion,
                   A.CodEjecutivo
              FROM POLIZAS P,AGENTE_POLIZA AP,AGENTES A,
                   DETALLE_POLIZA DP
             WHERE P.IdPoliza = DP.IdPoliza
               AND P.IdPoliza = AP.IdPoliza
               AND AP.Cod_Agente = A.Cod_Agente
               AND P.IDPOLIZA = nIdPoliza;
        CURSOR Q_Email IS
            SELECT CPN.Email
              FROM PERSONA_NATURAL_JURIDICA PN,CORREOS_ELECTRONICOS_PNJ CPN
             WHERE PN.Num_Doc_Identificacion  = CPN.Num_Doc_Identificacion
               AND PN.Tipo_Doc_Identificacion = CPN.Tipo_Doc_Identificacion
               AND CPN.Email_Principal        = 'S'
               AND PN.Num_Doc_Identificacion  = cNumDocIdentificacion;

    BEGIN
        IF NVL(nIdFactura,0) != 0 THEN
            BEGIN
                SELECT IdPoliza
                  INTO nIdPoliza
                  FROM FACTURAS
                 WHERE IdFactura = nIdFactura
                   AND CodCia    = nCodCia;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR (-20100,'Error: No Es Posible Determinar La P�liza Para Generacion De Destinatarios Para Facturaci�n Electr�nica');
            END;
        ELSIF NVL(nIdNcr,0) != 0 THEN
            BEGIN
                SELECT IdPoliza
                  INTO nIdPoliza
                  FROM NOTAS_DE_CREDITO
                 WHERE IdNcr     = nIdNcr
                   AND CodCia    = nCodCia;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR (-20100,'Error: No Es Posible Determinar La P�liza Para Generacion De Destinatarios Para Facturaci�n Electr�nica');
            END;
        END IF;
        IF cTipoDest = 'TO' THEN
            FOR W IN Q_Agentes LOOP
                IF W.Cod_Agente != 0 THEN
                    BEGIN
                        SELECT Num_Doc_Identificacion
                          INTO cNumDocIdentificacion
                          FROM AGENTES
                         WHERE Cod_Agente = W.Cod_Agente;

                         FOR X IN Q_Email LOOP
                            cDest := cDest||X.Email||cSeparador;
                         END LOOP;
                         cDest := cDest||OC_EJECUTIVO_COMERCIAL.EMAIL_EJECUTIVO(nCodCia,W.CodEjecutivo)||cSeparador;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                    END;
                END IF;
                IF W.Codigo_Promotor != 0 THEN
                    BEGIN
                        SELECT Num_Doc_Identificacion
                          INTO cNumDocIdentificacion
                          FROM AGENTES
                         WHERE Cod_Agente = W.Codigo_Promotor;

                         FOR X IN Q_Email LOOP
                            cDest := cDest||X.Email||cSeparador;
                         END LOOP;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                    END;
                END IF;
                IF W.Codigo_Direccion != 0 THEN
                    BEGIN
                        SELECT Num_Doc_Identificacion
                          INTO cNumDocIdentificacion
                          FROM AGENTES
                         WHERE Cod_Agente = W.Codigo_Direccion;

                         FOR X IN Q_Email LOOP
                            cDest := cDest||X.Email||cSeparador;
                         END LOOP;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                    END;
                END IF;
            END LOOP;
        ELSIF cTipoDest = 'CC' THEN
            cDestCC := OC_GENERALES.BUSCA_PARAMETRO(nCodCia, '030');
        END IF;
        IF cDest IS NOT NULL THEN
            RETURN cDest;
        ELSIF cDestCC IS NOT NULL THEN
            RETURN cDestCC;
        END IF;
    END DESTINATARIOS;

END OC_FACT_ELECT_CONF_DOCTO;
/
