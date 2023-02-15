CREATE OR REPLACE PACKAGE OC_ENTREGAS_CNSF_PLANTILLA IS
PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntregaOrig VARCHAR2, cCodEntregaDest VARCHAR2);
FUNCTION APLICA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2, 
                cCodPlantilla VARCHAR2, cCampo VARCHAR2) RETURN VARCHAR2;
FUNCTION FORMATO_CAMPO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2, 
                       cCodPlantilla VARCHAR2, cCampo VARCHAR2, cValor VARCHAR2) RETURN VARCHAR2;
END OC_ENTREGAS_CNSF_PLANTILLA;
 
 
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_ENTREGAS_CNSF_PLANTILLA IS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntregaOrig VARCHAR2, cCodEntregaDest VARCHAR2) IS
CURSOR PLANTILLA_Q IS
   SELECT CodPlantilla, Orden, Campo, IndAplica
     FROM ENTREGAS_CNSF_PLANTILLA
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND CodEntrega = cCodEntregaOrig;
BEGIN
   FOR X IN PLANTILLA_Q LOOP
      BEGIN
         INSERT INTO ENTREGAS_CNSF_PLANTILLA
                (CodCia, CodEmpresa, CodEntrega, CodPlantilla, Orden, Campo, IndAplica)
         VALUES (nCodCia, nCodEmpresa, cCodEntregaDest, X.CodPlantilla, X.Orden, X.Campo, X.IndAplica);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20100,'Error al Insertar Copia en ENTREGAS_CNSF_PLANTILLA CodEntrega ' ||
                                    cCodEntregaDest);
      END;
   END LOOP;
END COPIAR;

FUNCTION APLICA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2, 
                cCodPlantilla VARCHAR2, cCampo VARCHAR2) RETURN VARCHAR2 IS
cIndAplica   ENTREGAS_CNSF_PLANTILLA.IndAplica%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndAplica,'N')
        INTO cIndAplica
        FROM ENTREGAS_CNSF_PLANTILLA
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND CodEntrega   = cCodEntrega
         AND CodPlantilla = cCodPlantilla
         AND Campo        = cCampo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndAplica := 'N';
   END;
   RETURN(cIndAplica);
END APLICA;

FUNCTION FORMATO_CAMPO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2,
                       cCodPlantilla VARCHAR2, cCampo VARCHAR2, cValor VARCHAR2) RETURN VARCHAR2 IS
cCampoModif   VARCHAR2(1000);
CURSOR CAMPO_Q IS
   SELECT C.LongitudCampo, C.PosIniCampo, C.NumDecimales, C.TipoCampo
     FROM ENTREGAS_CNSF_PLANTILLA T, CONFIG_PLANTILLAS_CAMPOS C
    WHERE C.OrdenCampo   = T.Orden
      AND C.CodPlantilla = T.CodPlantilla
      AND C.CodEmpresa   = T.CodEmpresa
      AND C.CodCia       = T.CodCia
      AND T.CodCia       = nCodCia
      AND T.CodEmpresa   = nCodEmpresa
      AND T.CodEntrega   = cCodEntrega
      AND T.CodPlantilla = cCodPlantilla
      AND T.Campo        = cCampo;
BEGIN
   FOR X IN CAMPO_Q LOOP
      IF OC_ENTREGAS_CNSF_PLANTILLA.APLICA(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla, cCampo) = 'S' THEN
         cCampoModif := cValor;
      ELSE
         cCampoModif := NULL;
      END IF;
      IF X.TipoCampo = 'VARCHAR2' THEN
--         cCampoModif := LPAD(SUBSTR(cCampoModif,1,X.LongitudCampo),X.LongitudCampo,' ');
         cCampoModif := SUBSTR(cCampoModif,1,X.LongitudCampo);
      ELSIF X.TipoCampo = 'NUMBER' THEN
--         cCampoModif := LPAD(SUBSTR(TO_CHAR(ROUND(TO_NUMBER(cCampoModif),X.NumDecimales)),1,X.LongitudCampo),X.LongitudCampo,'0');
         cCampoModif := SUBSTR(TO_CHAR(ROUND(TO_NUMBER(cCampoModif),X.NumDecimales)),1,X.LongitudCampo);
      ELSE
--         cCampoModif := LPAD(SUBSTR(cCampoModif,1,X.LongitudCampo),X.LongitudCampo,' ');
         cCampoModif := SUBSTR(cCampoModif,1,X.LongitudCampo);
      END IF;
   END LOOP;
   RETURN(cCampoModif);
END FORMATO_CAMPO;

END OC_ENTREGAS_CNSF_PLANTILLA;
