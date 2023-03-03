create or replace PACKAGE          OC_FACT_ELECT_CONF_DOCTO IS
cLineaCom            VARCHAR2(1000)  := NULL;
cLineaExe            VARCHAR2(1000)  := NULL;
cLineaIgl            VARCHAR2(1000)  := NULL;
cLineaCRels          VARCHAR2(1000)  := NULL;
cLineaCRel           VARCHAR2(1000)  := NULL;
cLineaRef            VARCHAR2(1000)  := NULL;
cLineaRec            VARCHAR2(1000)  := NULL;
cLineaDor            VARCHAR2(1000)  := NULL;
cLineaCon            VARCHAR2(1000)  := NULL;
cLineaConit          VARCHAR2(1000)  := NULL;
cLineaConir          VARCHAR2(1000)  := NULL;
cLineaCup            VARCHAR2(1000)  := NULL;
cLineaInad           VARCHAR2(1000)  := NULL;
cLineaRet            VARCHAR2(1000)  := NULL;
cLineaTra            VARCHAR2(1000)  := NULL;
cLineaAdd            VARCHAR2(1000)  := NULL;
cLineaAdi            VARCHAR2(1000)  := NULL;
--cLineaPags         VARCHAR2(1000)  := NULL;
--cLineaPagsDocRel   VARCHAR2(1000)  := NULL;
cLineaPagsT          VARCHAR2(1000)  := NULL;
cLineaPagsP          VARCHAR2(1000)  := NULL;
cLineaPagsPDoc       VARCHAR2(1000)  := NULL;
cLineaPagsPDocImtra  VARCHAR2(1000)  := NULL;
cLineaPagsPImtra     VARCHAR2(1000)  := NULL;

PROCEDURE ASIGNA_LINEA_IDENTIFICADOR (cCodIdLinea  VARCHAR2,cLinea  VARCHAR2);
PROCEDURE INICIALIZA_LINEA_IDENTIFICADOR;
FUNCTION  CREA_DOCUMENTO(nIdFactura  NUMBER DEFAULT NULL ,nIdNcr  NUMBER DEFAULT NULL, nCodCia  NUMBER, nCodEmpresa  NUMBER, cProceso  VARCHAR2,cTipoCfdi  VARCHAR2, cIndRelaciona VARCHAR2 DEFAULT NULL) RETURN VARCHAR2;
FUNCTION  CREA_IDENTIFICADOR (nIdFactura  NUMBER,nIdNcr  NUMBER DEFAULT NULL,nCodCia  NUMBER,
                              nCodEmpresa  NUMBER, cProceso  VARCHAR2,cCodIdLinea  VARCHAR2,
                              cTipoCfdi  VARCHAR2,cCodCpto  VARCHAR2 DEFAULT NULL, cIndRelaciona VARCHAR2, 
                              cCodTipoPlan VARCHAR2 DEFAULT NULL, cIndExentoImp VARCHAR2 DEFAULT NULL) RETURN VARCHAR2;
FUNCTION  CONCEPTO_IMPUESTO (nCodCia NUMBER, cProceso VARCHAR2, cCodIdLea VARCHAR2) RETURN VARCHAR2;
PROCEDURE TIMBRAR(PnIdFactura  NUMBER DEFAULT NULL, pnIdNcr  NUMBER DEFAULT NULL,nCodCia  NUMBER,nCodEmpresa  NUMBER, cProceso  VARCHAR2,cTipoCfdi VARCHAR2, cIndRelaciona VARCHAR2 DEFAULT NULL, cCodRespuesta OUT VARCHAR2, IndOtroPac VARCHAR2 DEFAULT NULL);
PROCEDURE ENVIA_CORREO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFactura  NUMBER DEFAULT NULL,nIdNcr  NUMBER DEFAULT NULL,
                      cProceso  VARCHAR2,cCodRespuesta VARCHAR2, cDescError VARCHAR2 DEFAULT NULL, cDocto VARCHAR2 DEFAULT NULL);
FUNCTION  DESTINATARIOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFactura  NUMBER DEFAULT NULL,nIdNcr  NUMBER DEFAULT NULL, cTipoDest VARCHAR2) RETURN VARCHAR2;
FUNCTION  VENTA_PUBLICO_GENERAL  (nCodCia NUMBER, cCodIdentificador  VARCHAR2, cProceso  VARCHAR2) RETURN VARCHAR2;
FUNCTION DecodeBase64_Corto( cClobScr           CLOB
                              , nLongitudClob      NUMBER
                              , dNombreDirectorio  VARCHAR2
                              , cNombreArchivo     VARCHAR2 ) RETURN VARCHAR2;

FUNCTION DecodeBase64_Largo( cClobScr           CLOB
                           , nLongitudClob      NUMBER
                           , dNombreDirectorio  VARCHAR2
                           , cNombreArchivo     VARCHAR2 ) RETURN VARCHAR2;

FUNCTION ExtraeDoctosFactElec ( nCodCia      FACT_ELECT_DOCTOS_TIMBRE.CodCia%TYPE
                              , nCodEmpresa  FACT_ELECT_DOCTOS_TIMBRE.CodEmpresa%TYPE
                              , nIdTimbre    FACT_ELECT_DOCTOS_TIMBRE.IdTimbre%TYPE
                              , nIdFactura   FACT_ELECT_DOCTOS_TIMBRE.IdFactura%TYPE
                              , nIdNcr       FACT_ELECT_DOCTOS_TIMBRE.IdNcr%TYPE ) RETURN VARCHAR2;

FUNCTION Genera_Fact_Elect( cGenerar       IN  VARCHAR2
                          , nCodCia        IN  POLIZAS.CodCia%TYPE
                          , nCodEmpresa    IN  POLIZAS.CodEmpresa%TYPE
                          , nIdPoliza      IN  POLIZAS.IdPoliza%TYPE
                          , cIndFactElec   IN  VARCHAR2
                          , nLeidos       OUT  NUMBER
                          , nIncorrectos  OUT  NUMBER
                          , nCorrectos    OUT  NUMBER
                          , cTextoSalida  OUT  VARCHAR2
                          , nIdAgrupaEnv  OUT  FACT_ELECT_DOCTOS_TIMBRE.IDAGRUPAENV%TYPE ) RETURN VARCHAR2;

FUNCTION EXISTE_IMPUESTO(nCodCia IN NUMBER, nIdFactura IN NUMBER DEFAULT NULL,nIdNcr IN NUMBER DEFAULT NULL, cProceso IN VARCHAR2) RETURN VARCHAR2;

END OC_FACT_ELECT_CONF_DOCTO;
/
create or replace PACKAGE BODY          OC_FACT_ELECT_CONF_DOCTO IS

-- HOMOLOGACION VIFLEX                                      20220301 JMMD

PROCEDURE ASIGNA_LINEA_IDENTIFICADOR(cCodIdLinea IN VARCHAR2,cLinea IN VARCHAR2) IS
BEGIN
   IF cCodIdLinea = 'COM'              THEN
      OC_FACT_ELECT_CONF_DOCTO.cLineaCom           := cLinea;
   ELSIF cCodIdLinea = 'EXE'           THEN
      OC_FACT_ELECT_CONF_DOCTO.cLineaExe           := cLinea;
   ELSIF cCodIdLinea = 'IGL'           THEN
      OC_FACT_ELECT_CONF_DOCTO.cLineaIgl           := cLinea;
   ELSIF cCodIdLinea = 'CRELS'         THEN
      OC_FACT_ELECT_CONF_DOCTO.cLineaCRels         := cLinea;
   ELSIF cCodIdLinea = 'CREL'          THEN
      OC_FACT_ELECT_CONF_DOCTO.cLineaCRel          := cLinea;
   ELSIF cCodIdLinea = 'EMI'           THEN
      OC_FACT_ELECT_CONF_DOCTO.cLineaRef           := cLinea;
   ELSIF cCodIdLinea = 'REC'           THEN
      OC_FACT_ELECT_CONF_DOCTO.cLineaRec           := cLinea;
   ELSIF cCodIdLinea = 'DOR'           THEN
      OC_FACT_ELECT_CONF_DOCTO.cLineaDor           := cLinea;
   ELSIF cCodIdLinea = 'CON'           THEN
      OC_FACT_ELECT_CONF_DOCTO.cLineaCon           := cLinea;
   ELSIF cCodIdLinea = 'CONIT'         THEN
      OC_FACT_ELECT_CONF_DOCTO.cLineaConit         := cLinea;
   ELSIF cCodIdLinea = 'CONIR'         THEN
      OC_FACT_ELECT_CONF_DOCTO.cLineaConir         := cLinea;
   ELSIF cCodIdLinea = 'CUP'           THEN
      OC_FACT_ELECT_CONF_DOCTO.cLineaCup           := cLinea;
   ELSIF cCodIdLinea = 'INAD'          THEN
      OC_FACT_ELECT_CONF_DOCTO.cLineaInad          := cLinea;
   ELSIF cCodIdLinea = 'RET'           THEN
      OC_FACT_ELECT_CONF_DOCTO.cLineaRet           := cLinea;
   ELSIF cCodIdLinea = 'TRA'           THEN
      OC_FACT_ELECT_CONF_DOCTO.cLineaTra           := cLinea;
   ELSIF cCodIdLinea = 'ADD'           THEN
      OC_FACT_ELECT_CONF_DOCTO.cLineaAdd           := cLinea;
   ELSIF cCodIdLinea = 'ADI'           THEN
      OC_FACT_ELECT_CONF_DOCTO.cLineaAdi           := cLinea;
   ELSIF cCodIdLinea = 'PAGST'         THEN
      OC_FACT_ELECT_CONF_DOCTO.cLineaPagsT         := cLinea;
   ELSIF cCodIdLinea = 'PAGSP'         THEN
      OC_FACT_ELECT_CONF_DOCTO.cLineaPagsP         := cLinea;
   ELSIF cCodIdLinea = 'PAGSPDOC'      THEN
      OC_FACT_ELECT_CONF_DOCTO.cLineaPagsPDoc      := cLinea;
   ELSIF cCodIdLinea = 'PAGSPDOCIMTRA' THEN
      OC_FACT_ELECT_CONF_DOCTO.cLineaPagsPDocImTra := cLinea;
   ELSIF cCodIdLinea = 'PAGSPIMTRA'    THEN
      OC_FACT_ELECT_CONF_DOCTO.cLineaPagsPImTra    := cLinea;
   END IF;
END ASIGNA_LINEA_IDENTIFICADOR;
    --
PROCEDURE INICIALIZA_LINEA_IDENTIFICADOR IS        
BEGIN
   OC_FACT_ELECT_CONF_DOCTO.cLineaCom           := NULL;
   OC_FACT_ELECT_CONF_DOCTO.cLineaExe           := NULL;
   OC_FACT_ELECT_CONF_DOCTO.cLineaIgl           := NULL;
   OC_FACT_ELECT_CONF_DOCTO.cLineaCRels         := NULL;
   OC_FACT_ELECT_CONF_DOCTO.cLineaCRel          := NULL;
   OC_FACT_ELECT_CONF_DOCTO.cLineaRef           := NULL;
   OC_FACT_ELECT_CONF_DOCTO.cLineaRec           := NULL;
   OC_FACT_ELECT_CONF_DOCTO.cLineaDor           := NULL;
   OC_FACT_ELECT_CONF_DOCTO.cLineaCon           := NULL;
   OC_FACT_ELECT_CONF_DOCTO.cLineaConit         := NULL;
   OC_FACT_ELECT_CONF_DOCTO.cLineaConir         := NULL;
   OC_FACT_ELECT_CONF_DOCTO.cLineaCup           := NULL;
   OC_FACT_ELECT_CONF_DOCTO.cLineaInad          := NULL;
   OC_FACT_ELECT_CONF_DOCTO.cLineaRet           := NULL;
   OC_FACT_ELECT_CONF_DOCTO.cLineaTra           := NULL;
   OC_FACT_ELECT_CONF_DOCTO.cLineaAdd           := NULL;
   OC_FACT_ELECT_CONF_DOCTO.cLineaAdi           := NULL;
   --OC_FACT_ELECT_CONF_DOCTO.cLineaPags       := NULL;
   --OC_FACT_ELECT_CONF_DOCTO.cLineaPagsDocRel := NULL;
   OC_FACT_ELECT_CONF_DOCTO.cLineaPagsP         := NULL;
   OC_FACT_ELECT_CONF_DOCTO.cLineaPagsPDoc      := NULL;
   OC_FACT_ELECT_CONF_DOCTO.cLineaPagsPDocImTra := NULL;
   OC_FACT_ELECT_CONF_DOCTO.cLineaPagsPDocImtra := NULL;    
END INICIALIZA_LINEA_IDENTIFICADOR;
    --    
FUNCTION CREA_DOCUMENTO(nIdFactura IN NUMBER DEFAULT NULL,nIdNcr IN NUMBER DEFAULT NULL,nCodCia IN NUMBER,nCodEmpresa IN NUMBER,
                          cProceso IN VARCHAR2,cTipoCfdi IN VARCHAR2, cIndRelaciona VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 IS
cDocumento              VARCHAR2(10000) := NULL;
cLinea                  VARCHAR2(10000) := NULL;
cCodIdentificador       FACT_ELECT_CONF_DOCTO.CodIdentificador%TYPE;
cExiste                 VARCHAR2(1);
cExisteImp              VARCHAR2(1);
cCrel                   VARCHAR2(5000);
nIdDocumento            FACT_ELECT_DOCUMENTO.IdDocumento%TYPE;
nNumOrdenDoc            FACT_ELECT_DOCUMENTO.NumOrdenDoc%TYPE := 0; 
  --
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
            SELECT CodCpto, SUM(Monto_Det_Local) Monto_Det_Local, SUM(Saldo_Det_Moneda) Saldo_Det_Moneda, 
	                       MtoImptoFactElect,IndTipoConcepto,Porcconcepto, RAMOREAL 
	                       --Orden_Impresion
	                  FROM (
	                        SELECT NVL(CC.CODTIPOPLAN,CS.IDRAMOREAL) RAMOREAL, CC.CodCptoPrimasFactElect CodCpto,SUM(DF.Monto_Det_Local) Monto_Det_Local,SUM(DF.Saldo_Det_Moneda) Saldo_Det_Moneda,
	                               SUM(DF.MtoImptoFactElect) MtoImptoFactElect, CC.IndTipoConcepto, CC.Porcconcepto
	                               --CC.Orden_Impresion
	                          FROM DETALLE_FACTURAS DF INNER JOIN CATALOGO_DE_CONCEPTOS CC ON DF.CodCpto    = CC.CodConcepto
	                                                   INNER JOIN FACTURAS              F  ON  F.IDFACTURA   = DF.IDFACTURA
	                                                   INNER JOIN DETALLE_POLIZA        DP ON DP.IDPOLIZA   = F.IDPOLIZA
	                                                                                      AND DP.IDETPOL    = F.IDETPOL
	                                                                                      AND DP.CODCIA     = F.CODCIA
	                                                    LEFT JOIN COBERTURAS_DE_SEGUROS CS ON CS.CODCIA     = DP.CODCIA
	                                                                                      AND CS.CODCPTO    = DF.CODCPTO
	                                                                                      AND CS.IDTIPOSEG  = DP.IDTIPOSEG
	                                                                                      AND CS.PLANCOB    = DP.PLANCOB
	                         WHERE DF.IdFactura                 = nIdFactura                         
	                           AND NVL(CC.IndEsImpuesto,'N') = 'N'
	                           AND DF.MONTO_DET_MONEDA > 0
	                           AND DECODE(CS.CODCOBERT, NULL, 'X', CS.CODCOBERT) = NVL((SELECT MAX(CODCOBERT) FROM COBERTURAS_DE_SEGUROS S
	                                                                                     WHERE S.CODCIA     = DP.CODCIA
	                                                                                       AND S.CODCPTO    = DF.CODCPTO
	                                                                                       AND S.IDTIPOSEG  = DP.IDTIPOSEG
	                                                                                       AND S.PLANCOB     = DP.PLANCOB ), 'X')
	                         GROUP BY NVL(CC.CODTIPOPLAN,CS.IDRAMOREAL),
	                                  CC.CodCptoPrimasFactElect, CC.IndTipoConcepto, CC.Porcconcepto--,CC.Orden_Impresion
	                         UNION ALL
	                        SELECT NULL RAMOREAL, CC.CodCptoPrimasFactElect CodCpto,SUM(DN.Monto_Det_Local) Monto_Det_Local, SUM(0) Saldo_Det_Moneda,
	                               SUM(DN.MtoImptoFactElect) MtoImptoFactElect, CC.IndTipoConcepto, CC.Porcconcepto
	                               --CC.Orden_Impresion
	                          FROM DETALLE_NOTAS_DE_CREDITO DN,CATALOGO_DE_CONCEPTOS CC
	                         WHERE IdNcr                     = nIdNcr
	                           AND NVL(CC.IndEsImpuesto,'N') = 'N'
	                           AND DN.CodCpto                = CC.CodConcepto
	                         GROUP BY CC.CodCptoPrimasFactElect, CC.IndTipoConcepto, CC.Porcconcepto--,CC.Orden_Impresion
	                       )
	                 GROUP BY  CodCpto, MtoImptoFactElect,IndTipoConcepto,Porcconcepto, RAMOREAL 
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

CURSOR Q_Documento IS
   SELECT IdDocumento, NumOrdenDoc, IdFactura, IdNcr, Linea, 
          CodProceso, IndGenera, CodIdentificador
     FROM FACT_ELECT_DOCUMENTO
    WHERE CodCia           = nCodCia
      AND CodProceso       = cProceso
      AND NVL(IdFactura,0) = nIdFactura
      AND NVL(IdNcr,0)     = 0
      AND IdDocumento      = nIdDocumento
      AND IndGenera        = 'S'
    UNION ALL 
   SELECT IdDocumento, NumOrdenDoc, IdFactura, IdNcr, Linea, 
          CodProceso, IndGenera, CodIdentificador
     FROM FACT_ELECT_DOCUMENTO
    WHERE CodCia           = nCodCia
      AND CodProceso       = cProceso
      AND NVL(IdNcr,0)     = nIdNcr
      AND NVL(IdFactura,0) = 0
      AND IdDocumento      = nIdDocumento
      AND IndGenera        = 'S'
    ORDER BY NumOrdenDoc ;

BEGIN
   nIdDocumento := OC_FACT_ELECT_DOCUMENTO.ID_DOCUMENTO(nCodCia);

   IF cProceso IN ('EMI','PAG') THEN
      cCrel := OC_FACTURAS.FACTURA_RELACIONADA_UUID_CANC(nCodCia, nIdFactura);
      FOR X IN Q_Dcto LOOP
         --nNumOrdenDoc := nNumOrdenDoc + 1;
         /*IF cDocumento IS NULL THEN
            cDocumento := OC_FACT_ELECT_CONF_DOCTO.CREA_IDENTIFICADOR(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,X.CodIdentificador,cTipoCfdi,NULL,cIndRelaciona);
         ELSE*/
            IF X.IndRecursivo = 'S' THEN
               IF cProceso = 'PAG' THEN
                  --cDocumento := cDocumento||OC_FACT_ELECT_CONF_DOCTO.CREA_IDENTIFICADOR(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,X.CodIdentificador,cTipoCfdi,NULL,cIndRelaciona);
                  cDocumento := OC_FACT_ELECT_CONF_DOCTO.CREA_IDENTIFICADOR(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,X.CodIdentificador,cTipoCfdi,NULL,cIndRelaciona);
               END IF;
               FOR J IN Q_Rec LOOP
                  IF J.IndRelacion  = cIndRelaciona AND J.IndImpuesto = 'N' and (X.CodIdentificador IN ('CREL','CRELS')  AND cCrel IS NOT NULL) THEN                            
                     IF cProceso != 'PAG' THEN
                        --cDocumento := cDocumento||OC_FACT_ELECT_CONF_DOCTO.CREA_IDENTIFICADOR(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,X.CodIdentificador,cTipoCfdi,NULL,cIndRelaciona);
                        cDocumento := OC_FACT_ELECT_CONF_DOCTO.CREA_IDENTIFICADOR(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,X.CodIdentificador,cTipoCfdi,NULL,cIndRelaciona);
                     END IF;
                     OPEN Q_Rel;
                     FETCH Q_Rel INTO cCodIdentificador;
                        IF Q_Rel%NOTFOUND THEN
                           RAISE_APPLICATION_ERROR(-20225,'No Se Ha Configurado El Registro Correspondiente A La Relacion De Timbre Fiscales, Por Favor Valide Su Configuración');
                        END IF;
                     CLOSE Q_Rel;

                     FOR I IN Q_Rel LOOP ---CRELS O CREL
                        cCodIdentificador := I.CodIdentificador;
                        --cDocumento := cDocumento||OC_FACT_ELECT_CONF_DOCTO.CREA_IDENTIFICADOR(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,cCodIdentificador,cTipoCfdi,NULL,cIndRelaciona);
                        cDocumento := OC_FACT_ELECT_CONF_DOCTO.CREA_IDENTIFICADOR(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,cCodIdentificador,cTipoCfdi,NULL,cIndRelaciona);
                     END LOOP;
                  ELSIF J.IndRelacion  = 'N' AND J.IndImpuesto  = 'S' AND (X.CodIdentificador NOT IN ('CREL', 'CRELS') OR cCrel IS NOT NULL ) THEN
                     cExisteImp := 'N';
                     FOR F IN Q_DetCpto LOOP
                        cExiste := 'N';
                        --cDocumento := cDocumento||OC_FACT_ELECT_CONF_DOCTO.CREA_IDENTIFICADOR(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,X.CodIdentificador,cTipoCfdi,F.CodCpto,cIndRelaciona,F.RAMOREAL);
                        cDocumento := OC_FACT_ELECT_CONF_DOCTO.CREA_IDENTIFICADOR(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,X.CodIdentificador,cTipoCfdi,F.CodCpto,cIndRelaciona,F.RamoReal);
                        nNumOrdenDoc := nNumOrdenDoc + 1;
                        OC_FACT_ELECT_DOCUMENTO.INSERTAR (nCodCia, nIdDocumento, nNumOrdenDoc, nIdFactura, nIdNcr, cDocumento, X.CodIdentificador, cProceso, 'S');
                        cExiste := OC_FACT_ELECT_CONF_DOCTO.EXISTE_IMPUESTO(nCodCia, nIdFactura, nIdNcr, cProceso);
--                        OPEN Q_Impto;
--                        FETCH Q_Impto INTO cCodIdentificador;
--                        
--                           IF Q_Impto%NOTFOUND THEN
--                               RAISE_APPLICATION_ERROR(-20225,'No Se Ha Configurado El Registro Correspondiente A Los Impuestos Por Concepto, Por Favor Valide Su Configuración');
--                           END IF;
--                        
--                        CLOSE Q_Impto;
--                        
--                        IF NVL(nIdFactura,0) != 0 THEN
--                           BEGIN
--                              SELECT 'S'
--                                INTO cExiste
--                                FROM DETALLE_FACTURAS
--                               WHERE IdFactura  = nIdFactura
--                                 AND CodCpto   IN (SELECT CodConcepto
--                                                     FROM CATALOGO_DE_CONCEPTOS
--                                                    WHERE IndEsImpuesto = 'S');
--                           EXCEPTION
--                              WHEN NO_DATA_FOUND THEN
--                                 cExiste := 'N';
--                              WHEN TOO_MANY_ROWS THEN
--                                 cExiste := 'S';
--                           END;
--                        ELSIF NVL(nIdNcr,0) != 0 THEN
--                           BEGIN
--                              SELECT 'S'
--                                INTO cExiste
--                                FROM DETALLE_NOTAS_DE_CREDITO
--                               WHERE IdNcr      = nIdNcr
--                                 AND CodCpto   IN (SELECT CodConcepto
--                                                     FROM CATALOGO_DE_CONCEPTOS
--                                                    WHERE IndEsImpuesto = 'S');
--                           EXCEPTION
--                              WHEN NO_DATA_FOUND THEN
--                                 cExiste := 'N';
--                              WHEN TOO_MANY_ROWS THEN
--                                 cExiste := 'S';
--                           END;
--                        END IF;

                        IF cExiste = 'S' THEN
                           cExisteImp := cExiste;
                           --cExiste := 'N';
                           FOR I IN Q_Impto LOOP ---CONIT O CONIR
                              cCodIdentificador := I.CodIdentificador;
                              cLinea := OC_FACT_ELECT_CONF_DOCTO.CREA_IDENTIFICADOR(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,cCodIdentificador,cTipoCfdi,F.CodCpto,cIndRelaciona, F.RamoReal);
                              nNumOrdenDoc := nNumOrdenDoc + 1;
                              OC_FACT_ELECT_DOCUMENTO.INSERTAR (nCodCia, nIdDocumento, nNumOrdenDoc, nIdFactura, nIdNcr, cLinea, cCodIdentificador, cProceso, 'S');
                              IF instr(cLinea, 'CONIT|||') > 0 and instr(cLinea, 'Importe|0.00') > 0 and cCodIdentificador = 'CONIT' THEN
                                 cDocumento := Null;
                              ELSE
                                 cDocumento := cDocumento||cLinea;
                              END IF;
                           END LOOP;
                        ELSE ---- SE APLICA LA EXENCIÓN DE IMPUESTOS, SE DEBE GENERAR LA LINEA DE IMPUESTOS EXENTOS
                           FOR I IN Q_Impto LOOP ---CONIT O CONIR
                              cCodIdentificador := I.CodIdentificador;
                              cLinea := OC_FACT_ELECT_CONF_DOCTO.CREA_IDENTIFICADOR(nIdFactura, nIdNcr, nCodCia, nCodEmpresa, cProceso, cCodIdentificador, cTipoCfdi, F.CodCpto, cIndRelaciona, F.RamoReal, 'S');
                              nNumOrdenDoc := nNumOrdenDoc + 1;
                              OC_FACT_ELECT_DOCUMENTO.INSERTAR (nCodCia, nIdDocumento, nNumOrdenDoc, nIdFactura, nIdNcr, cLinea, cCodIdentificador, cProceso, 'S');
                           END LOOP;
                        END IF;
                     END LOOP;
                  END IF;
               END LOOP;
               CONTINUE;
            ELSE
               cExiste := OC_FACT_ELECT_CONF_DOCTO.EXISTE_IMPUESTO(nCodCia, nIdFactura, nIdNcr, cProceso);
               IF X.IndImpuesto = 'S' AND NVL(cExiste,'N') = 'N' THEN
                  --cDocumento := NUll;  -- SE APLICA LA EXENCIÓN DE IMPUESTOS CUANDO NO HAY CONCEPTOS DE IMPUESTOS POR LO QUE SE GENERAESTA LINEA CON EXENCION
                  cDocumento := OC_FACT_ELECT_CONF_DOCTO.CREA_IDENTIFICADOR(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,X.CodIdentificador,cTipoCfdi,NULL,cIndRelaciona, NULL, 'S');
               ELSIF X.CodIdentificador IN ('CREL','CRELS') THEN
                  cDocumento := NUll;  
               ELSIF X.CodIdentificador NOT IN ('CREL','CRELS') OR cCrel IS NOT NULL THEN
                  --IF (cIndFactCteRfcGenerico = 'N' AND X.CodIdentificador = 'IGL') THEN
                  --   cDocumento := NUll; 
                  --ELSE  
                     --cDocumento := cDocumento||OC_FACT_ELECT_CONF_DOCTO.CREA_IDENTIFICADOR(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,X.CodIdentificador,cTipoCfdi,NULL,cIndRelaciona);
                     cDocumento := OC_FACT_ELECT_CONF_DOCTO.CREA_IDENTIFICADOR(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,X.CodIdentificador,cTipoCfdi,NULL,cIndRelaciona);
                  --END IF;
               END IF;
            END IF;
         --END IF;
         IF cDocumento IS NOT NULL THEN
            nNumOrdenDoc := nNumOrdenDoc + 1;
            OC_FACT_ELECT_DOCUMENTO.INSERTAR (nCodCia, nIdDocumento, nNumOrdenDoc, nIdFactura, nIdNcr, cDocumento, X.CodIdentificador, cProceso, 'S');
         END IF;
      END LOOP;
   ELSIF  cProceso = 'CAN' THEN
      cDocumento := OC_FACT_ELECT_DETALLE_TIMBRE.UUID_PROCESO(nCodCia, nCodEmpresa, nIdFactura, nIdNcr, 'EMI'); -- CUANDO SE CANCELA SOLO SE PUEDE BUSCAR EL PROCESO EMI YA QUE EL PROCESO PAGO NO SE PUEDE CANCELAR
   END IF;

   OC_FACT_ELECT_DOCUMENTO.VALIDA_DOCUMENTO(nCodCia, nIdDocumento);

   IF cProceso != 'CAN' THEN
      cDocumento := NULL;
      FOR W IN Q_Documento LOOP
         IF cDocumento IS NULL THEN
            cDocumento := W.Linea;
         ELSE
            cDocumento := cDocumento||W.Linea;
         END IF;
      END LOOP;
   END IF;
   RETURN cDocumento;
END CREA_DOCUMENTO;
--
--
FUNCTION  CREA_IDENTIFICADOR (nIdFactura  NUMBER,nIdNcr  NUMBER DEFAULT NULL,nCodCia  NUMBER,
                              nCodEmpresa  NUMBER, cProceso  VARCHAR2,cCodIdLinea  VARCHAR2,
                              cTipoCfdi  VARCHAR2,cCodCpto  VARCHAR2 DEFAULT NULL, cIndRelaciona VARCHAR2, 
                              cCodTipoPlan VARCHAR2 DEFAULT NULL, cIndExentoImp VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 IS
cLineaIdent      VARCHAR2(32700) := NULL;
cSeparadorIdent  VARCHAR2(3)     := '|||';
cSeparadorCampo  VARCHAR2(2)     := '||';
cSeparadorValor  VARCHAR2(1)     := '|';
cSaltoLinea      VARCHAR2(3)     := CHR(10);
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
   IF cCodIdLinea = 'CONIT' THEN
      NULL;
   END IF;

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
            cValorAtributo := OC_DET_FACT_ELECT_CONF_DOCTO.GENERA_VALOR_ATRIBUTO(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,cCodIdLinea,X.CodAtributo,cTipoCfdi,cCodCpto,X.CodRutinaCalc,cIndRelaciona, cCodTipoPlan, cIndExentoImp);
         END IF;
      ELSIF X.CondicionAtributo = 'O' AND X.IndEnviaCia = 'S' THEN
         IF X.TipoValorAtributo = 'F' THEN
            cValorAtributo := X.ValorAtributo;
         ELSIF (X.TipoValorAtributo = 'D' AND X.Consulta IS NOT NULL) OR
               (X.TipoValorAtributo = 'L' AND X.Consulta IS NOT NULL) THEN
            cSqlDinAtrib := X.Consulta;
            cValorAtributo := OC_DDL_OBJETOS.EJECUTAR_QUERY(cSqlDinAtrib);
         ELSIF X.TipoValorAtributo = 'D' AND X.Consulta IS NULL THEN
            cValorAtributo := OC_DET_FACT_ELECT_CONF_DOCTO.GENERA_VALOR_ATRIBUTO(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,cCodIdLinea,X.CodAtributo,cTipoCfdi,cCodCpto,X.CodRutinaCalc,cIndRelaciona, cCodTipoPlan, cIndExentoImp);
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
            cValorAtributo := OC_DET_FACT_ELECT_CONF_DOCTO.GENERA_VALOR_ATRIBUTO(nIdFactura,nIdNcr,nCodCia,nCodEmpresa,cProceso,cCodIdLinea,X.CodAtributo,cTipoCfdi,cCodCpto,X.CodRutinaCalc,cIndRelaciona, cCodTipoPlan, cIndExentoImp);
         END IF;
      END IF;

      IF cCodIdLinea = 'CONIT' THEN
         NULL;
      END IF;

      IF cValorAtributo IS NOT NULL THEN
         cLineaIdent := cLineaIdent||X.CodAtributo||cSeparadorValor||cValorAtributo||cSeparadorCampo;
         OC_FACT_ELECT_CONF_DOCTO.ASIGNA_LINEA_IDENTIFICADOR(cCodIdLinea,cLineaIdent);
      END IF;
   END LOOP;
   cLineaIdent := SUBSTR(cLineaIdent,1,LENGTH(cLineaIdent) - 2)||cSaltoLinea;
   --cLineaIdent := (cLineaIdent,cSaltoLinea,'');
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
nError               NUMBER;
cDocto               VARCHAR2(32767);
cSoapRequest         VARCHAR2 (32767);
BreqLength           BINARY_INTEGER;
cBuffer              VARCHAR2(32767);
cBuffer2             VARCHAR2(32767);
iAmount              PLS_INTEGER := 2000;
iOffset              PLS_INTEGER := 1;
cFolio               FACT_ELECT_DETALLE_TIMBRE.FolioFiscal%TYPE;
cSerie               FACT_ELECT_DETALLE_TIMBRE.Serie%TYPE;
cCreels              VARCHAR2(500);
cCreel               VARCHAR2(500);
cUUIDRel             FACT_ELECT_DETALLE_TIMBRE.UUIDRELACIONADO%Type ;
eHttpReq             UTL_HTTP.req;
eHttpResp            UTL_HTTP.resp;
cStrTxt              CLOB;
cClobXml             CLOB;
cClob2Xml            CLOB;
cTimbrarFact         VARCHAR2(2000);
cNombreArchivoXml    VARCHAR2 (32747);
cNombreArchivoTxt    VARCHAR2 (32747);
cNombreArchivoPdf    VARCHAR2 (32747);
cUuid                VARCHAR2 (32747);
cTimbreFiscal        CLOB;
nPos                 NUMBER;
nIndex               NUMBER;
nCantidad            NUMBER;
bPdf                 BOOLEAN;
nErrDesc             NUMBER;
nPosPDF              NUMBER;
cValorXml            VARCHAR2(32747);
nPos3                NUMBER;
nPosErrI             NUMBER;
nPosErrF             NUMBER;
cDatoErr             VARCHAR2(5000);
cCodigoErr           VARCHAR2(10);
cDescError           VARCHAR2(5000);
cXml3                VARCHAR2(5000);
cSelloCFD            VARCHAR2(1000);
cNoCertificado       VARCHAR2(1000);
cCertificado         VARCHAR2(5000);
cSelloSAT            VARCHAR2(5000);
cDoctoRel            VARCHAR2 (50) := NULL;   --> 24/01/2022  JALV(+)
cCve_MotivCancFact   VARCHAR2(30);            --> 24/01/2022  JALV(+)
cClobPDF             CLOB;
cClobIMG             CLOB;


TYPE Varchar2Table IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
vtStrXml             Varchar2Table;

cPathWallet          VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'017');
cPwdWallet           VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'018');
cUser                VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'024');
cPwd                 VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'025');
nTotal               NUMBER(28,2);
cRFC                 VARCHAR2(20);
nIdPoliza            POLIZAS.IdPoliza%TYPE;
cCodCliente          FACTURAS.CodCliente%TYPE;
nCodAsegurado        ASEGURADO.Cod_Asegurado%TYPE;
cUuidCancelado       FACT_ELECT_DETALLE_TIMBRE.UuidCancelado%TYPE;
nIdTimbre            FACT_ELECT_DETALLE_TIMBRE.IDTIMBRE%TYPE;
nIdFactura           NUMBER;
nIdNcr               NUMBER;
cLinea               VARCHAR2(100);
cDoctoEncoded        CLOB;
cDescripcion         CLOB;
    --
FUNCTION EXTRAE_TIMBREFISCAL(Cadena varchar2, Num_Reg NUMBER) RETURN VARCHAR2 IS
Entrada     VARCHAR2(32727);
Resultado   VARCHAR2(32727);
NumRecord   NUMBER :=0;
BEGIN

   --SELECT SUBSTR(GT_WEB_SERVICES.ExtraeDatos_XML(XMLTYPE(Cadena), 'timbrefiscal'), 1, 32000)
   --SELECT SUBSTR(GT_WEB_SERVICES.ExtraeDatos_XML(Cadena, 'timbrefiscal'), 1, 32000)
   -- INTO Entrada FROM DUAL;        
   FOR ENT IN (select COLUMN_VALUE 
                from table(GT_WEB_SERVICES.split(Cadena,'|'))) LOOP
      NumRecord := NumRecord +1;
      IF NumRecord = Num_Reg THEN                      
         Resultado := ENT.COLUMN_VALUE;
         EXIT;
      END IF;
   END LOOP;

   RETURN Resultado;
END EXTRAE_TIMBREFISCAL;
--
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

   OC_FACT_ELECT_CONF_DOCTO.INICIALIZA_LINEA_IDENTIFICADOR;
   cDocto        := OC_FACT_ELECT_CONF_DOCTO.CREA_DOCUMENTO(nIdFactura, nIdNcr, nCodCia, nCodEmpresa, cProceso, cTipoCfdi, cIndRelaciona);
   cDoctoEncoded := UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(cDocto)));
   DBMS_OUTPUT.PUT_LINE(cDocto); 
   IF cProceso != 'CAN' THEN
      cFolio  := OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaCom,'folio');
      cSerie  := OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaCom,'serie');
      cCreels := OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaCrels,'TipoRelacion');
      cCreel  := OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(OC_FACT_ELECT_CONF_DOCTO.cLineaCrel,'UUID');
   END IF;

   --UTL_HTTP.set_wallet('file:'||cPathWallet,cPwdWallet);

   IF cProceso IN ('EMI','PAG') THEN
      cTimbrarFact := OC_GENERALES.BUSCA_PARAMETRO(nCodCia, '023');
      cSoapRequest :=
         'Usuario='|| cUser ||'&'||'Contra='|| cPwd ||'&'||'Documento='|| cDoctoEncoded ||'&'||'Consecutivo=0';

   ELSIF  cProceso = 'CAN' THEN
      --cUuidCancelado := cDocto;
      IF NVL(nIdFactura,0) != 0 THEN
         SELECT NVL(SUM(F.Monto_Fact_Local),0),IdPoliza,CodCliente, Cve_MotivCancFact    --> 24/01/2022 JALV(+)
           INTO nTotal,nIdPoliza,cCodCliente, cCve_MotivCancFact                         --> 24/01/2022 JALV(+)
           FROM FACTURAS F
          WHERE F.Codcia    = nCodCia
            AND F.IdFactura = nIdFactura
          GROUP BY IdPoliza,CodCliente, Cve_MotivCancFact;
      ELSIF NVL(nIdNcr,0) != 0 THEN
         SELECT NVL(SUM(N.Monto_Ncr_Local),0),IdPoliza,CodCliente, cCve_MotivCancFact    --> 24/01/2022 JALV(+)
           INTO nTotal,nIdPoliza,cCodCliente, cCve_MotivCancFact                         --> 24/01/2022 JALV(+)
           FROM NOTAS_DE_CREDITO N
          WHERE N.Codcia    = nCodCia
            AND N.IdNcr     = nIdNcr
          GROUP BY IdPoliza,CodCliente, Cve_MotivCancFact;
      END IF;
      -- hacer de manera mas dinamica la cancelacion por motivo diferente a 02
      cCve_MotivCancFact := NVL(cCve_MotivCancFact, '02');
      IF  cCve_MotivCancFact = '01' THEN            
         RAISE_APPLICATION_ERROR(-20200,'El procedimiento de cancelación, debe ser ejecutado desde otro sitio que no sea en OC_FACT_ELECT_CONF_DOCTO.timbrar por la opción 01 de motivo de cancelación CFDI (20220101)');
      END IF;
      IF NVL(IndOtroPac,'N') = 'S' THEN -- CANCELACION OTRO PAC
         cTimbrarFact := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'038');
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
         'Usuario='|| cUser ||'&'||'Contra='|| cPwd ||'&'||'UUID='|| cDocto;

      END IF;
   END IF;
   --DBMS_OUTPUT.PUT_LINE(cSoapRequest);

   --insert into FACT_ELECT_REGISTROS_XML values (cSoapRequest, nIdFactura, nIdNcr);

   nIdTimbre := 0;
   cNombreArchivoXml := LPAD(TO_CHAR(NVL(nIdFactura, nIdNcr)), 14, '0') ||TO_CHAR(cFolio) || '.xml';
   cNombreArchivoTxt := LPAD(TO_CHAR(NVL(nIdFactura, nIdNcr)), 14, '0') ||TO_CHAR(cFolio) || '.txt';
   cNombreArchivoPdf := LPAD(TO_CHAR(NVL(nIdFactura, nIdNcr)), 14, '0') ||TO_CHAR(cFolio) || '.pdf';

   UTL_HTTP.SET_TRANSFER_TIMEOUT(3000);
   eHttpReq := UTL_HTTP.BEGIN_REQUEST (cTimbrarFact, 'POST', 'HTTP/1.1');
   --UTL_HTTP.SET_BODY_CHARSET (eHttpReq, 'UTF8');
   UTL_HTTP.SET_HEADER (eHttpReq, 'Content-Type', 'application/x-www-form-urlencoded');

   BreqLength := DBMS_LOB.GETLENGTH(cSoapRequest);

   IF BreqLength<= 32767 then
      UTL_HTTP.SET_HEADER (eHttpReq, 'Content-Length', BreqLength);
      --UTL_HTTP.SET_HEADER (eHttpReq, 'SOAPAction', 'https://www.facturemosya.com/webservice/timbrarCfdi4_0.php/RecibirXML');
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
   cLinea := 'Linea 2';
   GT_WEB_SERVICES.INICIALIZADOM(XMLTYPE(cClob2Xml));
   cCodRespuesta := GT_WEB_SERVICES.EXTRAEDATOS_XMLDOM('codigo');
   --
   cDescripcion := GT_WEB_SERVICES.EXTRAEDATOS_XMLDOM('descripcion');
   IF cProceso IN ('EMI','PAG') THEN
      cDescripcion := UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(cDescripcion)));
   ELSIF cProceso IN ('CAN') THEN
      cDescripcion := UTL_RAW.CAST_TO_VARCHAR2(UTL_RAW.CAST_TO_RAW(cDescripcion));
   END IF;
   --
   --EMITIDOS Y PAGADOS
   IF cProceso IN ('EMI','PAG') and cCodRespuesta = OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'026')  THEN            
      cTimbreFiscal := substr(GT_WEB_SERVICES.EXTRAEDATOS_XMLDOM('timbrefiscal'), 1, 10000);
      cTimbreFiscal := UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(cTimbreFiscal)));
      cUuid := EXTRAE_TIMBREFISCAL(cTimbreFiscal,2);
      cDescError := 'Se timbro correctamente';            
      --
      --Esta salida debe ser tipo Base64
      BEGIN 
         SELECT SUBSTR(VALOR, 1, INSTR(VALOR, '</documentopdf>') -1)
         INTO   cClobPDF
         FROM   ( SELECT SUBSTR(cClob2Xml, INSTR(cClob2Xml, '<documentopdf>') +14) VALOR
                  FROM   DUAL );
      EXCEPTION
      WHEN OTHERS THEN
           cClobPDF := NULL;
      END;
      --      
      cClobIMG := GT_WEB_SERVICES.EXTRAEDATOS_XMLDOM('imagencbb');    --Esta salida debe ser tipo Base64
      cClobXML := cDescripcion;  --Esta salida debe ser tipo Caracter
   ELSE
      --CANCELACIONES U OTROS            
      cDescError := GT_WEB_SERVICES.EXTRAEDATOS_XMLDOM('descripcion');
   END IF;
   IF cCodRespuesta IS NULL OR LENGTH(cCodRespuesta) = 0 THEN
      cCodRespuesta := '501';
      cDescError := GT_WEB_SERVICES.EXTRAEDATOS_XMLDOM('faultstring');
   END IF;

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
   END IF;
    --
   cLinea := 'Linea 8.1';
   OC_FACT_ELECT_DETALLE_TIMBRE.INSERTA_DETALLE(nCodCia, nCodEmpresa, nIdFactura ,
                                                 nIdNcr, cProceso, 
                                                 cUuid,
                                                 TRUNC(SYSDATE), cFolio, cSerie,
                                                 CASE WHEN cCodRespuesta IN ('201','2001') THEN '201' ELSE '501' END,
                                                 cUuidCancelado,
                                                 cCve_MotivCancFact,            --> 24/01/2022 JALV(+)
                                                 -- cDoctoRel,                  --> 24/01/2022  JALV(+)
                                                 nIdTimbre,
                                                 SUBSTR(cCreel,1,100),
                                                 cCodRespuesta,
                                                 cDescError,
                                                 sysdate
                                                 );
   IF cCodRespuesta IN ('201','2001') THEN   
      INSERT INTO FACT_ELECT_DOCTOS_TIMBRE
         ( CodCia, CodEmpresa, IdTimbre, IdFactura, IdNcr, CodProceso, DoctoXML, DoctoPDF, DoctoIMG, IdEntregado )
      VALUES ( nCodCia, nCodEmpresa, nIdTimbre, nIdFactura, nIdNcr, cProceso, cClobXML, cClobPDF, cClobIMG, 'N' );
   END IF;

   cLinea := 'Linea 9';
   OC_FACT_ELECT_CONF_DOCTO.ENVIA_CORREO(nCodCia,nCodEmpresa,nIdFactura,nIdNcr,cProceso,cCodRespuesta,cDescError,cDocto);

   IF nIdFactura != 0 THEN
      DELETE FROM FACT_ELECT_REGISTROS_XML X
       WHERE NVL(X.IdFactura, 0) = nIdFactura;
   ELSIF nIdNcr != 0 THEN
      DELETE FROM FACT_ELECT_REGISTROS_XML X
       WHERE NVL(X.IdNcr, 0)     = nIdNcr;
   END IF;

EXCEPTION WHEN OTHERS THEN
   OC_FACT_ELECT_CONF_DOCTO.ENVIA_CORREO(nCodCia,nCodEmpresa,nIdFactura,nIdNcr,cProceso,cCodRespuesta,cDescError || CHR(10) ||SQLERRM || '-' || cLinea, cDocto );
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
cUUIDRelacionado   FACT_ELECT_DETALLE_TIMBRE.UUIDRELACIONADO%TYPE;
cNombreCliente     VARCHAR2(2000);
cIdentFiscal       VARCHAR2(100);
nIdPoliza          POLIZAS.IdPoliza%TYPE;
cNumPolUnico       POLIZAS.NumPolUnico%TYPE;
BEGIN
   cUUID             := OC_FACT_ELECT_DETALLE_TIMBRE.UUID_PROCESO(nCodCia, nCodEmpresa, nIdFactura,nIdNcr, cProceso);
   cFolioFiscal      := OC_FACT_ELECT_DETALLE_TIMBRE.FOLIO_FISCAL(nCodCia, nCodEmpresa, nIdFactura,nIdNcr, cUUID);
   cSerie            := OC_FACT_ELECT_DETALLE_TIMBRE.SERIE(nCodCia, nCodEmpresa, nIdFactura,nIdNcr, cUUID);
   cUUIDRelacionado  := OC_FACT_ELECT_DETALLE_TIMBRE.UUIDRelacionado(nCodCia, nCodEmpresa, nIdFactura,nIdNcr, cUUID);
   IF NVL(nIdFactura,0) != 0 THEN
      BEGIN
         SELECT OC_CLIENTES.NOMBRE_CLIENTE(F.CodCliente),OC_CLIENTES.IDENTIFICACION_TRIBUTARIA(F.CodCliente),
                OC_POLIZAS.NUMERO_UNICO(nCodCia,P.IdPoliza)
           INTO cNombreCliente,cIdentFiscal,cNumPolUnico
           FROM FACTURAS F,POLIZAS P
          WHERE IdFactura  = nIdFactura
            AND F.IdPoliza = P.IdPoliza;
      END;
      cSubjectFactNcr := 'El "Aviso de Cobro" '||nIdFactura;
      IF cProceso = 'EMI' THEN
         cMessageFactNcr := 'El "Aviso de Cobro" '||nIdFactura;
      ELSIF cProceso = 'CAN' THEN
         cMessageFactNcr := 'La "Cancelación del Aviso de Cobro" '||nIdFactura;
      ELSIF cProceso = 'PAG' THEN
         cMessageFactNcr := 'El "Complemento de pago por el Aviso de Cobro" '||nIdFactura;
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
      cSubjectFactNcr := 'La "Nota de crédito" '||nIdNcr;
      IF cProceso = 'EMI' THEN
         cMessageFactNcr := '"Nota De crédito" '||nIdNcr;
      ELSIF cProceso = 'CAN' THEN
         cMessageFactNcr := '"Cancelación de la Nota de crédito" '||nIdNcr;
      END IF;
   END IF;
     --
     IF cCodRespuesta = OC_GENERALES.BUSCA_PARAMETRO(nCodCia, '026') THEN
         cSubject := 'Comprobante fiscal digital de: '||cNombreCliente||' ('||cIdentFiscal||')'; ---DEFINIR LISTA DE DISTRIBUCION
         cMessage := 'Estimado Agente:

 Se ha generado la facturación electrónica para '||cMessageFactNcr||' de la Póliza '||cNumPolUnico||' con los siguientes datos:

 UUID: '||cUUID||'
 Folio Fiscal: '||cFolioFiscal||'
 Serie: '||cSerie||''|| '
 ' ||CASE WHEN cUUIDRelacionado IS NOT NULL THEN 'Relacionado: ' || cUUIDRelacionado ELSE '' END ||'
 ' ||CASE WHEN cDescError IS NOT NULL THEN '<' || cDescError || '>' ELSE '' END      ||' 
 
 Los archivos XML y PDF se podrán descargar en "Portal de Agentes".

 Nota: Este correo es generado de manera automática, favor de no responder.

 '||OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia);

---------------------------------
---------------------------------
     ELSE
         ---    OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CATERRSAT',cCodRespuesta)||'
         --cEmailDest := OC_USUARIOS.EMAIL(nCodCia,USER);
         cSubject   := INITCAP(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PROCFACELE', cProceso))|| ' Para '||cSubjectFactNcr||' Realizado de Manera Incorrecta';---DEFINIR LISTA DE DISTRIBUCION
         cMessage   := cMessageFactNcr|| ' no se timbró de manera correcta por la siguiente razón:

 Error: < '||cCodRespuesta||' : '||cDescError||' >

 El documento o UUID para el envío al SAT se adjunta a continuación:

'||

 cDocto

||'

 Favor de validar el documento de envío y de ejecutar nuevamente el Timbrado.
 
 Nota: Este correo es generado de manera automática, favor de no responder.

'||OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia);
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
                RAISE_APPLICATION_ERROR (-20100,'Error: No Es Posible Determinar La Póliza Para Generacion De Destinatarios Para Facturación Electrónica');
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
                    RAISE_APPLICATION_ERROR (-20100,'Error: No Es Posible Determinar La Póliza Para Generacion De Destinatarios Para Facturación Electrónica');
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

FUNCTION  VENTA_PUBLICO_GENERAL  (nCodCia NUMBER, cCodIdentificador  VARCHAR2, cProceso  VARCHAR2) RETURN VARCHAR2 IS
cIndVentaPublicoGeneral FACT_ELECT_CONF_DOCTO.IndVentaPublicoGeneral%TYPE;
BEGIN 
   BEGIN
      SELECT NVL(IndVentaPublicoGeneral,'N')
        INTO cIndVentaPublicoGeneral
        FROM FACT_ELECT_CONF_DOCTO
       WHERE CodCia           = nCodCia
         AND CodIdentificador = cCodIdentificador
         AND Proceso          = cProceso;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndVentaPublicoGeneral := 'N';
   END;
   RETURN cIndVentaPublicoGeneral;
END VENTA_PUBLICO_GENERAL;

FUNCTION DecodeBase64_Corto( cClobScr           CLOB
                           , nLongitudClob      NUMBER
                           , dNombreDirectorio  VARCHAR2
                           , cNombreArchivo     VARCHAR2 ) RETURN VARCHAR2 IS
   bBlobDecoded    BLOB;
   bSalidaBlob     BLOB;  
   fArchivoSalida  UTL_FILE.FILE_TYPE;
   --Variables utilizadas al cargar clob
   nDestOffset     INTEGER := 1;
   nSrcOffset      INTEGER := 1;
   nSrcCsid        NUMBER  := NLS_CHARSET_ID('UTF8');
   nLangCtx        INTEGER := DBMS_LOB.DEFAULT_LANG_CTX;
   nWarn           INTEGER := NULL;
BEGIN
   --Convertir el clob en un blob para decodificar
   DBMS_LOB.CREATETEMPORARY(bSalidaBlob, TRUE);
   DBMS_LOB.CONVERTTOBLOB( dest_lob     => bSalidaBlob
                         , src_clob     => cClobScr
                         , amount       => nLongitudClob
                         , dest_offset  => nDestOffset
                         , src_offset   => nSrcOffset    
                         , blob_csid    => nSrcCsid
                         , lang_context => nLangCtx
                         , WARNING      => nWarn);

   --Decodificar
   bBlobDecoded := NULL;
   bBlobDecoded := UTL_ENCODE.BASE64_DECODE(bSalidaBlob);

   --Genera el Archivo
   fArchivoSalida := UTL_FILE.FOPEN(dNombreDirectorio, cNombreArchivo, 'WB');
   UTL_FILE.PUT_RAW(fArchivoSalida, bBlobDecoded);
   UTL_FILE.FFLUSH(fArchivoSalida);
   UTL_FILE.FCLOSE(fArchivoSalida);
   --
   RETURN 'OK';
EXCEPTION
WHEN OTHERS THEN
     UTL_FILE.FCLOSE_ALL;
     RETURN SQLERRM;
END DecodeBase64_Corto;

FUNCTION DecodeBase64_Largo( cClobScr           CLOB
                           , nLongitudClob      NUMBER
                           , dNombreDirectorio  VARCHAR2
                           , cNombreArchivo     VARCHAR2 ) RETURN VARCHAR2 IS
   fArchivoSalida  UTL_FILE.FILE_TYPE;
   --Variables para la Decodificación
   bClobTrim       CLOB;
   nClobLen        NUMBER;
   nAmount1        NUMBER := 1440; -- must be a whole multiple of 4
   nReadOffset     NUMBER := 1;
   bBlobLoc        BLOB;
   rBuffer1        RAW(1440);
   cStringBuffer   VARCHAR2(1440);
   --Variables para la Generar el Archivo
   nBlobLen        NUMBER;
   rBuffer2        RAW(32767);
   nAmount2        NUMBER := 32767;
   nPosicion       NUMBER := 1;
   nVeces          NUMBER;
BEGIN
   -- UTL_ENCODE.BASE64_DECODE is limited to 32k, process in chunks if bigger    
   -- Remove all NEW_LINE from base64 string
   DBMS_LOB.CREATETEMPORARY(bClobTrim, TRUE);
   LOOP
      EXIT WHEN nReadOffset > nLongitudClob;
      cStringBuffer := REPLACE(REPLACE(DBMS_LOB.SUBSTR(cClobScr, nAmount1, nReadOffset), CHR(13), NULL), CHR(10), NULL);
      DBMS_LOB.WRITEAPPEND(bClobTrim, LENGTH(cStringBuffer), cStringBuffer);
      nReadOffset := nReadOffset + nAmount1;
   END LOOP;
   --
   nReadOffset := 1;
   nClobLen    := DBMS_LOB.GETLENGTH(bClobTrim);
   DBMS_LOB.CREATETEMPORARY(bBlobLoc, TRUE);
   LOOP
      EXIT WHEN nReadOffset > nClobLen;
      rBuffer1 := UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(DBMS_LOB.SUBSTR(bClobTrim, nAmount1, nReadOffset)));
      DBMS_LOB.WRITEAPPEND(bBlobLoc, DBMS_LOB.GETLENGTH(rBuffer1), rBuffer1);
      nReadOffset := nReadOffset + nAmount1;
   END LOOP;
   --
   nBlobLen       := DBMS_LOB.getlength(bBlobLoc);
   fArchivoSalida := UTL_FILE.fopen(dNombreDirectorio, cNombreArchivo, 'wb');
   --
   nVeces := CEIL(nBlobLen/nAmount2);
   FOR x IN 1..nVeces LOOP
      DBMS_LOB.READ(bBlobLoc, nAmount2, nPosicion, rBuffer2);
      UTL_FILE.put_raw(fArchivoSalida, rBuffer2, TRUE);
      nPosicion := nPosicion + nAmount2;
   END LOOP;
   UTL_FILE.fclose(fArchivoSalida);
   --
   RETURN 'OK';
EXCEPTION
WHEN OTHERS THEN
     UTL_FILE.FCLOSE_ALL;
     RETURN SQLERRM;
END DecodeBase64_Largo;

FUNCTION ExtraeDoctosFactElec ( nCodCia      FACT_ELECT_DOCTOS_TIMBRE.CodCia%TYPE
                              , nCodEmpresa  FACT_ELECT_DOCTOS_TIMBRE.CodEmpresa%TYPE
                              , nIdTimbre    FACT_ELECT_DOCTOS_TIMBRE.IdTimbre%TYPE
                              , nIdFactura   FACT_ELECT_DOCTOS_TIMBRE.IdFactura%TYPE
                              , nIdNcr       FACT_ELECT_DOCTOS_TIMBRE.IdNcr%TYPE ) RETURN VARCHAR2 IS
   dNombreDirectorio  VARCHAR2(40) := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SO_PATH', 'DIRFAC');
   cClobXML           FACT_ELECT_DOCTOS_TIMBRE.DOCTOXML%TYPE;
   cClobIMG           FACT_ELECT_DOCTOS_TIMBRE.DOCTOIMG%TYPE;
   cClobPDF           FACT_ELECT_DOCTOS_TIMBRE.DOCTOPDF%TYPE;
   cArchXML           VARCHAR2(100);
   cArchPDF           VARCHAR2(100);
   cArchIMG           VARCHAR2(100);
   cArchZIP           VARCHAR2(100);
   fArchivoSalida     UTL_FILE.FILE_TYPE;
   nLongitudClob      NUMBER;
   cResultado         VARCHAR2(4000);
   cCodProceso        FACT_ELECT_DOCTOS_TIMBRE.CodProceso%TYPE;
BEGIN
   BEGIN
      SELECT DoctoXML, DoctoIMG, DoctoPDF, CodProceso
      INTO   cClobXML, cClobIMG, cClobPDF, cCodProceso
      FROM   FACT_ELECT_DOCTOS_TIMBRE
      WHERE  CodCia            = nCodCia
        AND  CodEmpresa        = nCodEmpresa
        AND  IdTimbre          = nIdTimbre
        AND  NVL(IdFactura, 0) = NVL(NVL(nIdFactura, IdFactura), 0)
        AND  NVL(IdNcr    , 0) = NVL(NVL(nIdNcr    , IdNcr    ), 0);
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
        cResultado := 'ERROR: No existen documentos asociados a la Factura: ' || nIdFactura || ', Nota de Crédito: ' || nIdNcr; 
        RETURN cResultado;
   END;
   --Armado de los nombres de archivos
   IF NVL(nIdFactura, 0) > 0 THEN
      cArchXML := 'Factura_' || nIdFactura || '_' || cCodProceso || '.xml';
      cArchPDF := 'Factura_' || nIdFactura || '_' || cCodProceso || '.pdf';
      cArchIMG := 'Factura_' || nIdFactura || '_' || cCodProceso || '.png';
      cArchZIP := 'Doctos_Factura_' || nIdFactura || '_' || cCodProceso || '.zip';
   ELSE
      cArchXML := 'Ncr_' || nIdNcr || '_' || cCodProceso || '.xml';
      cArchPDF := 'Ncr_' || nIdNcr || '_' || cCodProceso || '.pdf';
      cArchIMG := 'Ncr_' || nIdNcr || '_' || cCodProceso || '.png';
      cArchZIP := 'Doctos_Ncr_' || nIdNcr || '_' || cCodProceso || '.zip';
   END IF;
   --
   --Proceso XML
   fArchivoSalida := UTL_FILE.FOPEN(dNombreDirectorio, cArchXML, 'W', 32767);
   UTL_FILE.PUT_LINE(fArchivoSalida, cClobXML);
   UTL_FILE.FCLOSE(fArchivoSalida);
   --
   --Proceso IMG
   nLongitudClob := DBMS_LOB.GETLENGTH(cClobIMG);
   --
   IF nLongitudClob > 32767 THEN
      cClobPDF   := DecodeBase64_Largo( cClobIMG, nLongitudClob, dNombreDirectorio, cArchIMG );
   ELSE
      cResultado := DecodeBase64_Corto( cClobIMG, nLongitudClob, dNombreDirectorio, cArchIMG );
   END IF;
   --
   --Proceso PDF
   nLongitudClob := DBMS_LOB.GETLENGTH(cClobPDF);
   --
   IF nLongitudClob > 32767 THEN
      cClobPDF   := DecodeBase64_Largo( cClobPDF, nLongitudClob, dNombreDirectorio, cArchPDF );
   ELSE
      cResultado := DecodeBase64_Corto( cClobPDF, nLongitudClob, dNombreDirectorio, cArchPDF );
   END IF;
   --
   IF ZIP_UTIL_PKG.ZIP_ARCHIVOS(dNombreDirectorio, cArchZIP, cArchXML || ',' || cArchIMG || ',' || cArchPDF ) THEN
      BEGIN
         UTL_FILE.FREMOVE(dNombreDirectorio, cArchXML);
         UTL_FILE.FREMOVE(dNombreDirectorio, cArchIMG);
         UTL_FILE.FREMOVE(dNombreDirectorio, cArchPDF);
      EXCEPTION
      WHEN OTHERS THEN
           NULL;
      END;
   END IF;
   --
   UPDATE FACT_ELECT_DOCTOS_TIMBRE
   SET    NombArchZIP = cArchZIP
   WHERE  CodCia            = nCodCia
     AND  CodEmpresa        = nCodEmpresa
     AND  IdTimbre          = nIdTimbre
     AND  NVL(IdFactura, 0) = NVL(NVL(nIdFactura, IdFactura), 0)
     AND  NVL(IdNcr    , 0) = NVL(NVL(nIdNcr    , IdNcr    ), 0);
   --
   RETURN cResultado;
EXCEPTION
WHEN OTHERS THEN
     UTL_FILE.FCLOSE_ALL;
END ExtraeDoctosFactElec;

FUNCTION Genera_Fact_Elect( cGenerar       IN  VARCHAR2
                          , nCodCia        IN  POLIZAS.CodCia%TYPE      
                          , nCodEmpresa    IN  POLIZAS.CodEmpresa%TYPE  
                          , nIdPoliza      IN  POLIZAS.IdPoliza%TYPE    
                          , cIndFactElec   IN  VARCHAR2                 
                          , nLeidos       OUT  NUMBER
                          , nIncorrectos  OUT  NUMBER
                          , nCorrectos    OUT  NUMBER
                          , cTextoSalida  OUT  VARCHAR2
                          , nIdAgrupaEnv  OUT  FACT_ELECT_DOCTOS_TIMBRE.IDAGRUPAENV%TYPE ) RETURN VARCHAR2 IS
   cTraslado           VARCHAR2(1) := 'S';
   nLinea              NUMBER;
   cCadena             VARCHAR2(4000);
   cCodUser            VARCHAR2(30); 
   cCodRespuesta       PARAMETROS_GLOBALES.DESCRIPCION%TYPE;
   cRespuestaTimbrado  PARAMETROS_GLOBALES.DESCRIPCION%TYPE;
   cDescError          VALORES_DE_LISTAS.DESCVALLST%TYPE;
   nCodCliAntFact      FACTURAS.CODCLIENTE%TYPE;
   nCodCliAntPol       POLIZAS.CODCLIENTE%TYPE;
   nCodCteGen          FACTURAS.CODCLIENTE%TYPE := 3141738;
   cResultado          VARCHAR2(4000);
   nIdTimbre           FACT_ELECT_DOCTOS_TIMBRE.IdTimbre%TYPE;
   --
   CURSOR c_Fact_Q IS
          SELECT CodCia, IdFactura, IdPoliza, IndFactCteRFCGenerico
          FROM   FACTURAS
          WHERE  CodCia             = nCodCia
            AND  IdPoliza           = nIdPoliza
            AND  IndFactElectronica = 'S'
            AND  StsFact           IN ('EMI', 'PAG')
            AND  FecEnvFactElec    IS NULL
            AND  OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_PROCESO( nCodCia, nCodEmpresa, IdFactura, '', 'EMI' ) = 'N';      
   --
   CURSOR c_DoctosTimbre IS
          SELECT CodCia, CodEmpresa, IdTimbre, IdFactura, IdNcr
          FROM   FACT_ELECT_DOCTOS_TIMBRE
          WHERE  CodCia      = nCodCia
            AND  CodEmpresa  = nCodEmpresa
            AND  IdAgrupaEnv = nIdAgrupaEnv;
BEGIN
   SELECT SYS_CONTEXT('USERENV', 'CURRENT_USERID')
   INTO   cCodUser
   FROM   DUAL;
   --
   SELECT AGRUPA_DOCTOS_SEQ.NEXTVAL
   INTO   nIdAgrupaEnv
   FROM   DUAL;
   --
   BEGIN
      SELECT Descripcion
      INTO   cRespuestaTimbrado
      FROM   PARAMETROS_GLOBALES 
      WHERE  CodCia = nCodCia
        AND  Codigo = '026';
      --
      cTraslado := 'S';
   EXCEPTION
   WHEN OTHERS THEN
        cTraslado    := 'N';
        cTextoSalida := 'NO esta definido el parametro global de Facturación Electrónica';
        RETURN cTraslado;
   END;
   --
   IF cIndFactElec = 'S' AND cGenerar = 'FAC' THEN
      nLeidos 	   := 0;
      nCorrectos   := 0;
      nIncorrectos := 0;
      nLinea       := 1;
      cCadena      := 'LOG DE FACTURACION ELECTRONICA ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS');
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea); 
      FOR w IN c_Fact_Q LOOP
          nLeidos := nLeidos + 1;	
          IF w.IndFactCteRFCGenerico = 'S' THEN
             SELECT CodCliente
             INTO   nCodCliAntFact
             FROM   FACTURAS
             WHERE  CodCia    = w.CodCia
               AND  IdFactura = w.IdFactura;
             --
             SELECT CodCliente 
             INTO   nCodCliAntPol 
             FROM   POLIZAS 
             WHERE  CodCia   = w.CodCia
               AND  IdPoliza = w.IdPoliza;
             --
             UPDATE FACTURAS
             SET    CodCliente = nCodCteGen
             WHERE  CodCia     = w.CodCia
               AND  IdFactura  = w.IdFactura;
             --
             UPDATE POLIZAS
             SET    CodCliente = nCodCteGen
             WHERE  CodCia 	   = w.CodCia
               AND  IdPoliza   = w.IdPoliza;		
          END IF;	
          --
          BEGIN
             OC_FACT_ELECT_CONF_DOCTO.TIMBRAR(w.IdFactura, NULL, w.CodCia, nCodEmpresa, 'EMI', 'A', 'N', cCodRespuesta, 'N');
          EXCEPTION
          WHEN OTHERS THEN
               nLinea  := nLinea + 1; 
               cCadena := ' FACTURA - ' || w.IdFactura || ' ERROR DE PROCESO - ' || cCodRespuesta || ' - ' || SQLERRM;
               OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea); 
          END;
          --
          BEGIN
             SELECT DescValLST
             INTO   cDescError
             FROM   VALORES_DE_LISTAS 
             WHERE  CodLista = 'CATERRSAT'
               AND  CodValor = cCodRespuesta;
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
               cDescError := 'ERROR NO ENCONTRADO';
          WHEN OTHERS THEN
               cDescError := 'ERROR CON PROBLEMAS';
          END;
          --
          IF cCodRespuesta = cRespuestaTimbrado THEN
             nCorrectos := nCorrectos + 1;
             cTraslado  := 'S';
             nLinea     := nLinea + 1; 
             cCadena    := ' FACTURA - ' || w.IdFactura || ' CODIGO CORRECTO - ' || cCodRespuesta || ' ' || cDescError;
             OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea); 
	         --
	         SELECT MAX(IdTimbre)
	         INTO   nIdTimbre
	         FROM   FACT_ELECT_DETALLE_TIMBRE
	         WHERE  CodCia     = w.CodCia
	           AND  CodEmpresa = nCodEmpresa
	           AND  IdFactura  = w.IdFactura
	           AND  CodProceso = 'EMI';
             --
             UPDATE FACT_ELECT_DOCTOS_TIMBRE
             SET    IdAgrupaEnv = nIdAgrupaEnv
             WHERE  CodCia     = w.CodCia
               AND  CodEmpresa = nCodEmpresa
	           AND  IdTimbre   = nIdTimbre
               AND  IdFactura  = w.IdFactura
	           AND  CodProceso = 'EMI';
          ELSE
             nIncorrectos := nIncorrectos + 1;
             cTraslado    := 'S';
             nLinea       := nLinea + 1; 
             cCadena      := ' FACTURA - ' || w.IdFactura || ' CODIGO INCORRECTO - ' || cCodRespuesta || ' ' || cDescError;
             OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea); 
          END IF;
          --
          IF w.IndFactCteRFCGenerico = 'S' THEN
             UPDATE FACTURAS
             SET    CodCliente            = nCodCliAntFact
               ,    IndFactCteRFCGenerico = 'S'
               ,    CodCliRFCGenerico     = nCodCteGen
             WHERE  CodCia    = w.CodCia
               AND  IdFactura = w.IdFactura;
             --
             UPDATE POLIZAS
             SET    CodCliente = nCodCliAntPol
             WHERE  IdPoliza   = w.IdPoliza;
          END IF;
      END LOOP;
      --
      FOR x IN c_DoctosTimbre LOOP
          cResultado := ExtraeDoctosFactElec( x.CodCia
                                            , x.CodEmpresa
                                            , x.IdTimbre
                                            , x.IdFactura
                                            , x.IdNcr );
          IF cResultado = 'OK' THEN
--             SET    DoctoXML    = NULL
--               ,    DoctoIMG    = NULL
--               ,    DoctoPDF    = NULL
--               ,    IdEntregado = 'S'
             UPDATE FACT_ELECT_DOCTOS_TIMBRE
             SET    IdEntregado = 'S'
             WHERE  CodCia            = x.CodCia
               AND  CodEmpresa        = x.CodEmpresa
               AND  IdTimbre          = x.IdTimbre
               AND  NVL(IdFactura, 0) = NVL(NVL(x.IdFactura, IdFactura), 0)
               AND  NVL(IdNcr    , 0) = NVL(NVL(x.IdNcr    , IdNcr    ), 0)
               AND  IdAgrupaEnv       = nIdAgrupaEnv;
          END IF;
      END LOOP;
      --
      IF NVL(cTraslado,'N') = 'S' THEN
         BEGIN
            OC_ARCHIVO.ESCRIBIR_LINEA('EOF', cCodUser, 0);
            cTextoSalida := 'Proceso Terminado  Procesados = ' || nLeidos || '  Correctos = ' || nCorrectos || '  Incorrectos = ' || nIncorrectos;
         EXCEPTION
         WHEN OTHERS THEN
              cTextoSalida := SQLERRM;
         END;
      END IF;
   END IF;
   --
   RETURN cTraslado;
END Genera_Fact_Elect;

FUNCTION EXISTE_IMPUESTO(nCodCia IN NUMBER, nIdFactura IN NUMBER DEFAULT NULL,nIdNcr IN NUMBER DEFAULT NULL, cProceso IN VARCHAR2) RETURN VARCHAR2 IS
cExiste           VARCHAR2(1);   
cCodIdentificador FACT_ELECT_CONF_DOCTO.CodIdentificador%TYPE;

CURSOR Q_Impto IS
   SELECT CodIdentificador ---CONIT O CONIR PARA EMISION DE FACTURAS
     FROM FACT_ELECT_CONF_DOCTO
    WHERE CodCia       = nCodCia
      AND Proceso      = cProceso
      AND IndImpuesto  = 'S'
      AND IndRecursivo = 'S'
    UNION ALL
   SELECT CodIdentificador ---PAGSPDOCIMTRA O PAGSPIMTRA PARA COMPLEMENTOS DE PAGO
     FROM FACT_ELECT_CONF_DOCTO
    WHERE CodCia       = nCodCia
      AND Proceso      = cProceso
      AND IndImpuesto  = 'S'
      AND IndRecursivo = 'N';
BEGIN
   OPEN Q_Impto;
   FETCH Q_Impto INTO cCodIdentificador;
      IF Q_Impto%NOTFOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'No Se Ha Configurado El Registro Correspondiente A Los Impuestos Por Concepto, Por Favor Valide Su Configuración');
      END IF;
   CLOSE Q_Impto;

   IF NVL(nIdFactura,0) != 0 THEN
      BEGIN
         SELECT 'S'
           INTO cExiste
           FROM DETALLE_FACTURAS
          WHERE IdFactura  = nIdFactura
            AND CodCpto   IN (SELECT CodConcepto
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
          WHERE IdNcr      = nIdNcr
            AND CodCpto   IN (SELECT CodConcepto
                                FROM CATALOGO_DE_CONCEPTOS
                               WHERE IndEsImpuesto = 'S');
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cExiste := 'N';
         WHEN TOO_MANY_ROWS THEN
            cExiste := 'S';
      END;
   END IF;
   RETURN cExiste;
END;

END OC_FACT_ELECT_CONF_DOCTO;
/
--
-- OC_FACT_ELECT_CONF_DOCTO  (Synonym) 
--
--  Dependencies: 
--   OC_FACT_ELECT_CONF_DOCTO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_FACT_ELECT_CONF_DOCTO FOR SICAS_OC.OC_FACT_ELECT_CONF_DOCTO
/
GRANT EXECUTE ON SICAS_OC.OC_FACT_ELECT_CONF_DOCTO TO PUBLIC
/
