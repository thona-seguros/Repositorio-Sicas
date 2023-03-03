CREATE OR REPLACE PACKAGE OC_FACT_ELECT_DOCUMENTO AS
FUNCTION ID_DOCUMENTO(nCodCia NUMBER) RETURN NUMBER;
PROCEDURE INSERTAR (nCodCia NUMBER, nIdDocumento NUMBER, nNumOrdenDoc NUMBER, nIdFactura NUMBER,
                    nIdNcr NUMBER, cLinea VARCHAR2, cCodIdentificador VARCHAR2, cCodProceso VARCHAR2, 
                    cIndGenera VARCHAR2);
PROCEDURE VALIDA_DOCUMENTO (nCodCia NUMBER, nIdDocumento NUMBER);                    
END OC_FACT_ELECT_DOCUMENTO;
/
CREATE OR REPLACE PACKAGE BODY OC_FACT_ELECT_DOCUMENTO AS
FUNCTION ID_DOCUMENTO(nCodCia NUMBER) RETURN NUMBER IS
nIdDocumento   FACT_ELECT_DOCUMENTO.IdDocumento%TYPE;
BEGIN 
   SELECT SQ_FACT_ELECT_DOCUMENTO.NEXTVAL
     INTO nIdDocumento
     FROM DUAL;
   RETURN nIdDocumento;
END ID_DOCUMENTO;

PROCEDURE INSERTAR (nCodCia NUMBER, nIdDocumento NUMBER, nNumOrdenDoc NUMBER, nIdFactura NUMBER,
                    nIdNcr NUMBER, cLinea VARCHAR2, cCodIdentificador VARCHAR2, cCodProceso VARCHAR2, 
                    cIndGenera VARCHAR2) IS
BEGIN
   INSERT INTO FACT_ELECT_DOCUMENTO(CodCia, IdDocumento, NumOrdenDoc, IdFactura, IdNcr, Linea, CodIdentificador, CodProceso, IndGenera)
        VALUES (nCodCia, nIdDocumento, nNumOrdenDoc, nIdFactura, nIdNcr, cLinea, cCodIdentificador, cCodProceso, cIndGenera);
END INSERTAR;

PROCEDURE VALIDA_DOCUMENTO (nCodCia NUMBER, nIdDocumento NUMBER) IS
cIndGenera     FACT_ELECT_DOCUMENTO.IndGenera%TYPE;
cValorAtributo VARCHAR2(300);
CURSOR Q_DOCUMENTO IS
   SELECT IdDocumento, NumOrdenDoc, IdFactura, IdNcr, Linea, 
          CodProceso, IndGenera, CodIdentificador
     FROM FACT_ELECT_DOCUMENTO
    WHERE CodCia        = nCodCia
      AND IdDocumento   = nIdDocumento
    ORDER BY NumOrdenDoc;
BEGIN
   FOR W IN Q_DOCUMENTO LOOP
      IF W.CodIdentificador = 'REC' THEN ---- VALIDA SI ES VENTA AL PUBLICO EN GENERAL, ENTONCES HABILITA LINEA IGL
         IF OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(W.Linea, 'rfc') NOT LIKE '%XAXX010101000%' AND
            OC_DET_FACT_ELECT_CONF_DOCTO.EXTRAE_VALOR_ATRIBUTO(W.Linea, 'nombre') NOT LIKE '%PUBLICO EN GENERAL%' THEN
            
            UPDATE FACT_ELECT_DOCUMENTO
               SET IndGenera = 'N'
             WHERE CodCia           = nCodCia
               AND IdDocumento      = nIdDocumento
               AND CodIdentificador = 'IGL';
         END IF;
      END IF;
   END LOOP;
END VALIDA_DOCUMENTO;

END OC_FACT_ELECT_DOCUMENTO;
/
CREATE OR REPLACE PUBLIC SYNONYM OC_FACT_ELECT_DOCUMENTO FOR SICAS_OC.OC_FACT_ELECT_DOCUMENTO;
/
GRANT EXECUTE ON OC_FACT_ELECT_DOCUMENTO TO PUBLIC;