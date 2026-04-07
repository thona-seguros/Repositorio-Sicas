create or replace PROCEDURE SICAS_OC.WS_ALTA_ASEGURADO (
    p_POL_CONSECUTIVO IN NUMBER,  
    p_EMAIL IN VARCHAR2,    
    p_TIPO_IDTRIBUTARIO IN VARCHAR2,
    p_NOMBRE IN VARCHAR2,
    p_APEPAT IN VARCHAR2,
    p_APEMAT IN VARCHAR2,
    p_FECNAC IN DATE,
    p_SEXO IN VARCHAR2,
    p_TELEFONO IN VARCHAR2,
    p_FEC_POL_FINVIG IN DATE,
    p_FECSOLICITUD IN DATE,
    p_FECEMISION IN DATE,
    p_TIPO_ENDOSO IN VARCHAR2,
    p_STS_ENDOSO IN VARCHAR2,
    p_DESC_ENDOSO IN VARCHAR2,
    p_MOTIVO_ENDOSO IN VARCHAR2,
    p_IDETPOL IN NUMBER,
    p_CODCIA IN NUMBER,
    p_CODEMPRESA IN NUMBER,
    p_COD_ASEGURADO IN OUT NUMBER
) AS
  -- Declaración de variables
  A               NUMBER;
  cDato           VARCHAR2(2000);
  cTipC           VARCHAR2(1);
  nCORRELATIVO    NUMBER;
  cCAMPO          VARCHAR2(200);
  cTABLA          VARCHAR2(200);
  cCAMPOREF       VARCHAR2(200);	
  nCod_Asegurado  NUMBER;
  nDummy          NUMBER;
  Dummy           NUMBER;
  cNum_Tributario VARCHAR2(20);
  EXISTES_PNJ     NUMBER := 0;
  EXISTES_COB     NUMBER := 0;
  PASAS_GOUVLOC   NUMBER := 0;
  nTasa_Cambio    TASAS_CAMBIO.Tasa_Cambio%TYPE;
  Error           NUMBER := 0;  
  YA_EXISTE       NUMBER := 0;
  EXIST_ASEG_CERT NUMBER := 0;  
  HAY_ASEGURADO   NUMBER := 0;   
  WPLANCOB        DETALLE_POLIZA.PLANCOB%TYPE;
  WTIPOSEG        DETALLE_POLIZA.IDTIPOSEG%TYPE;
  WTASA_CAMBIO    DETALLE_POLIZA.TASA_CAMBIO%TYPE;
  USUSARIO        VARCHAR2(50); 
  TERMINAL        VARCHAR2(50);
  HABEMUS_EMIS    NUMBER := 0; 
  coberturaEmi    NUMBER := 0;   
  HABIAUNO        NUMBER := 0; 
  HAYASEGURADO    NUMBER := 0; 
  cAseguradoAlfa  ASEGURADO_CERTIFICADO.COD_ASEGURADO%TYPE;   
  GUATJAPEN       VARCHAR2(3); 
  cTexto          VARCHAR2(4000); 
  Fecha_Hoy       VARCHAR2(30) := TO_CHAR(sysdate, 'DD/MM/YYYY HH24:MI:SS');	 
  NvaCantAsegModelo Detalle_Poliza.CantAsegModelo%TYPE;
  nCantAsegModelo Detalle_Poliza.CantAsegModelo%TYPE;
  v_NUMERO_ENDOSO NUMBER;
  v_NUMREF VARCHAR2(100);
  v_NUM_TRIBUTARIO VARCHAR2(100);
  -- Cursor para heredar coberturas
  CURSOR HEREDA_COBERTURA (nCias IN NUMBER, nEmpresas IN NUMBER, nIdpolizas IN NUMBER, nIdetpols IN NUMBER, CaseguradoAlfa IN NUMBER) IS
    SELECT D1.CODEMPRESA, D1.CODCIA, D1.IDPOLIZA, D1.IDETPOL, D1.IDTIPOSEG, D1.TIPOREF, D1.NUMREF, 
           D1.CODCOBERT, D1.COD_ASEGURADO, D1.SUMAASEG_LOCAL, D1.SUMAASEG_MONEDA, D1.TASA, D1.PRIMA_MONEDA, 
           D1.PRIMA_LOCAL, D1.IDENDOSO, D1.STSCOBERTURA, D1.PLANCOB, D1.COD_MONEDA, D1.DEDUCIBLE_LOCAL, 
           D1.DEDUCIBLE_MONEDA, D1.INDCAMBIOSAMI, D1.SUMAASEGORIGEN
    FROM COBERT_ACT_ASEG D1, ASEGURADO_CERTIFICADO C1
    WHERE C1.CODCIA = nCias
      AND C1.idpoliza = nIdpolizas
      AND C1.COD_ASEGURADO = CaseguradoAlfa
      AND C1.IDETPOL = nIdetpols
      AND D1.CODEMPRESA = nEmpresas
      AND D1.CODCIA = C1.CODCIA
      AND D1.IDPOLIZA = C1.idpoliza
      AND D1.IDETPOL = nIdetpols
      AND D1.COD_ASEGURADO = C1.COD_ASEGURADO
      AND D1.STSCOBERTURA = 'EMI';
  -- Procedimiento para limpiar datos en caso de error
  PROCEDURE ROLVAC_1_END IS
  BEGIN
    DELETE FROM ENDOSOS E
    WHERE E.IDPOLIZA = p_POL_CONSECUTIVO 
      AND E.IDENDOSO = v_NUMERO_ENDOSO      
      AND E.TIPOENDOSO = 'ESV'
      AND E.NUMENDREF = v_NUMREF;
    IF p_EMAIL IS NOT NULL THEN
      DELETE FROM CORREOS_ELECTRONICOS_PNJ CE
      WHERE CE.TIPO_DOC_IDENTIFICACION = 'RFC'
        AND CE.NUM_DOC_IDENTIFICACION = v_NUM_TRIBUTARIO
        AND CE.EMAIL = p_EMAIL;
    END IF;
    DELETE FROM ENDOSOS_SEGUIMIENTO ES1
    WHERE ES1.IDPOLIZA = p_POL_CONSECUTIVO
      AND ES1.IDENDOSO = v_NUMERO_ENDOSO  
      AND ES1.STSENDOSO = 'SOL';
    COMMIT;
  END ROLVAC_1_END;
  -- Procedimiento para limpiar datos relacionados con PNJ y Asegurado
  PROCEDURE ROLVAC_4_END_PNJ_ASEG_COB IS
  BEGIN
    DELETE FROM ENDOSOS E
    WHERE E.IDPOLIZA = p_POL_CONSECUTIVO  
      AND E.IDENDOSO = v_NUMERO_ENDOSO      
      AND E.TIPOENDOSO = 'ESV'
      AND E.NUMENDREF = v_NUMREF;
    IF p_EMAIL IS NOT NULL THEN
      DELETE FROM CORREOS_ELECTRONICOS_PNJ CE
      WHERE CE.TIPO_DOC_IDENTIFICACION = 'RFC'
        AND CE.NUM_DOC_IDENTIFICACION = v_NUM_TRIBUTARIO
        AND CE.EMAIL = p_EMAIL;
    END IF;
    DELETE FROM PERSONA_NATURAL_JURIDICA PNJ2
    WHERE PNJ2.Tipo_Doc_Identificacion = 'RFC'
      AND PNJ2.Num_Doc_Identificacion = v_NUM_TRIBUTARIO;
    DELETE FROM ASEGURADO AZE
    WHERE AZE.Cod_Asegurado = p_COD_ASEGURADO
      AND AZE.CodCia = NVL(p_CODCIA, 1)
      AND AZE.CodEmpresa = NVL(p_CODEMPRESA, 1)
      AND AZE.Tipo_Doc_Identificacion = p_TIPO_IDTRIBUTARIO
      AND AZE.Num_Doc_Identificacion = v_NUM_TRIBUTARIO
      AND AZE.CodParent = '0001';
    DELETE FROM COBERT_ACT_ASEG CBA
    WHERE CBA.IdPoliza = p_POL_CONSECUTIVO 
      AND CBA.IDetPol = p_IDETPOL
      AND CBA.CodCia = NVL(p_CODCIA, 1)
      AND CBA.Cod_Asegurado = p_COD_ASEGURADO;
    DELETE FROM ENDOSOS_SEGUIMIENTO ES1
    WHERE ES1.IDPOLIZA = p_POL_CONSECUTIVO
      AND ES1.IDENDOSO = v_NUMERO_ENDOSO  
      AND ES1.STSENDOSO = 'SOL';
    COMMIT;
  END ROLVAC_4_END_PNJ_ASEG_COB;
  -- Procedimiento para abortar la misión en caso de error
  PROCEDURE ROLVAC_5_ABORT_MISSION IS
  BEGIN
    IF v_NUMERO_ENDOSO IS NOT NULL THEN
      DELETE FROM ENDOSOS E
      WHERE E.IDPOLIZA = p_POL_CONSECUTIVO 
        AND E.IDENDOSO = v_NUMERO_ENDOSO      
        AND E.TIPOENDOSO = 'ESV'
        AND E.NUMENDREF = v_NUMREF
        AND E.STSENDOSO = 'SOL';
      COMMIT;
    END IF;
    IF p_EMAIL IS NOT NULL THEN
      DELETE FROM CORREOS_ELECTRONICOS_PNJ CE
      WHERE CE.TIPO_DOC_IDENTIFICACION = 'RFC'
        AND CE.NUM_DOC_IDENTIFICACION = v_NUM_TRIBUTARIO
        AND CE.EMAIL = p_EMAIL;
      COMMIT;
    END IF;
    IF p_COD_ASEGURADO IS NOT NULL THEN
      DELETE FROM ASEGURADO AZE
      WHERE AZE.Cod_Asegurado = p_COD_ASEGURADO
        AND AZE.CodCia = NVL(p_CODCIA, 1)
        AND AZE.CodEmpresa = NVL(p_CODEMPRESA, 1)
        AND AZE.Tipo_Doc_Identificacion = p_TIPO_IDTRIBUTARIO
        AND AZE.Num_Doc_Identificacion = v_NUM_TRIBUTARIO
        AND AZE.CodParent = '0001';
      COMMIT;
    END IF;
    IF p_NOMBRE IS NOT NULL THEN
      DELETE FROM PERSONA_NATURAL_JURIDICA PNJ2
      WHERE PNJ2.Tipo_Doc_Identificacion = 'RFC'
        AND PNJ2.Num_Doc_Identificacion = v_NUM_TRIBUTARIO;
      COMMIT;
    END IF;
    IF p_POL_CONSECUTIVO IS NOT NULL THEN
      DELETE FROM COBERT_ACT_ASEG CBA
      WHERE CBA.IdPoliza = p_POL_CONSECUTIVO
        AND CBA.IDetPol = p_IDETPOL
        AND CBA.CodCia = NVL(p_CODCIA, 1)
        AND CBA.Cod_Asegurado = p_COD_ASEGURADO;
      COMMIT;
    END IF;
    DELETE FROM ENDOSOS_SEGUIMIENTO ES1
    WHERE ES1.IDPOLIZA = p_POL_CONSECUTIVO
      AND ES1.IDENDOSO = v_NUMERO_ENDOSO  
      AND ES1.STSENDOSO = 'SOL';
    COMMIT;
  END ROLVAC_5_ABORT_MISSION;
BEGIN
  -- Inicialización de variables
  --USUSARIO := :APP_USER;
  USUSARIO := 'SICAS';
  TERMINAL := 'APEX';
  -- Lógica principal del procedimiento
  IF Error = 0 THEN
    cNum_Tributario := OC_PERSONA_NATURAL_JURIDICA.NUMERO_TRIBUTARIO_RFC(p_NOMBRE, p_APEPAT, 
                                                                        p_APEMAT, p_FECNAC,
                                                                        'FISICA');
    v_NUM_TRIBUTARIO := cNum_Tributario;
    -- Verificación de existencia de la persona en la tabla PERSONA_NATURAL_JURIDICA
    SELECT COUNT(*) INTO YA_EXISTE  
    FROM PERSONA_NATURAL_JURIDICA PJ
    WHERE PJ.Tipo_Doc_Identificacion = p_TIPO_IDTRIBUTARIO                
      AND PJ.Num_Doc_Identificacion = v_NUM_TRIBUTARIO;  
    nCod_Asegurado := oc_asegurado.ID_ASEGURADO;
    p_COD_ASEGURADO := nCod_Asegurado;
    IF YA_EXISTE = 0 THEN
      p_COD_ASEGURADO := nCod_Asegurado;
      -- Inserción de la persona en la tabla PERSONA_NATURAL_JURIDICA
      oc_persona_natural_juridica.INSERTAR_PERSONA(p_TIPO_IDTRIBUTARIO, v_NUM_TRIBUTARIO,  
                                                  p_NOMBRE, p_APEPAT, 
                                                  p_APEMAT, NULL, --cApeCasada
                                                  p_SEXO, NULL, --cEstadoCivil
                                                  p_FECNAC, NULL, --cDirecRes
                                                  NULL, --cNumInterior
                                                  NULL, --cNumExterior
                                                  NULL, --cCodPaisRes
                                                  NULL, --cCodProvRes
                                                  NULL, --cCodDistRes
                                                  NULL, --cCodCorrRes
                                                  NULL, --cCodPosRes
                                                  NULL, --cCodColonia
                                                  p_TELEFONO,   
                                                  p_EMAIL, 
                                                  NULL); --cLadaTelRes
      COMMIT;
      -- Verificación de la inserción
      SELECT COUNT(*) INTO EXISTES_PNJ
      FROM PERSONA_NATURAL_JURIDICA PJ
      WHERE PJ.Tipo_Doc_Identificacion = p_TIPO_IDTRIBUTARIO                
        AND PJ.Num_Doc_Identificacion = v_NUM_TRIBUTARIO;  
      IF EXISTES_PNJ = 0 THEN  
        ROLVAC_1_END; 
        RAISE_APPLICATION_ERROR(-20000, 'NDF No existe la persona en Persona Natural Juridica');
      END IF; 	
    END IF;
    -- Verificación de existencia del asegurado
    SELECT COUNT(*) INTO HAY_ASEGURADO
    FROM ASEGURADO AF
    WHERE AF.TIPO_DOC_IDENTIFICACION = p_TIPO_IDTRIBUTARIO   
      AND AF.NUM_DOC_IDENTIFICACION = v_NUM_TRIBUTARIO;
    IF HAY_ASEGURADO = 0 THEN
      -- Inserción del asegurado
      INSERT INTO ASEGURADO (Cod_Asegurado, CodCia, CodEmpresa, Tipo_Doc_Identificacion,
                             Num_Doc_Identificacion, CodParent)
      VALUES (p_COD_ASEGURADO, NVL(p_CODCIA, 1), NVL(p_CODEMPRESA, 1), p_TIPO_IDTRIBUTARIO, 
              v_NUM_TRIBUTARIO, '0001');
      COMMIT;
    ELSE
      -- Obtención del código del asegurado existente
      SELECT AF.COD_ASEGURADO INTO nCod_Asegurado
      FROM ASEGURADO AF
      WHERE AF.TIPO_DOC_IDENTIFICACION = p_TIPO_IDTRIBUTARIO   
        AND AF.NUM_DOC_IDENTIFICACION = v_NUM_TRIBUTARIO;										 
      p_COD_ASEGURADO := nCod_Asegurado;
    END IF;
    -- Verificación de existencia del asegurado en el certificado
    SELECT COUNT(*) INTO EXIST_ASEG_CERT
    FROM ASEGURADO_CERTIFICADO VB
    WHERE VB.IDPOLIZA = p_POL_CONSECUTIVO
      AND VB.COD_ASEGURADO = nCod_Asegurado
      AND VB.IDETPOL = p_IDETPOL;
    -- Obtención del número de endoso  XXX
    SELECT NVL(MAX(IdEndoso), 0) + 1 INTO v_NUMERO_ENDOSO
    FROM ENDOSOS
    WHERE IdPoliza = p_POL_CONSECUTIVO;
     IF EXIST_ASEG_CERT = 0 THEN
      -- Inserción del asegurado en el certificado
      INSERT INTO ASEGURADO_CERTIFICADO (CodCia, Idpoliza, Idetpol, Cod_Asegurado, Estado, IdEndoso)
      VALUES (NVL(p_CODCIA, 1), p_POL_CONSECUTIVO, p_IDETPOL, NVL(p_COD_ASEGURADO, nCod_Asegurado), 'SOL', v_NUMERO_ENDOSO);
      COMMIT;
    ELSE
      -- Limpieza de datos en caso de que el asegurado ya exista en la póliza
      --p_NOMBRE := NULL;				         	   
      --p_COD_ASEGURADO := NULL;
      --v_NUM_TRIBUTARIO := NULL;				         	   
      ROLVAC_4_END_PNJ_ASEG_COB; 				         	     
      RAISE_APPLICATION_ERROR(-20001, 'Ya existe el Asegurado en ésta Póliza');
    END IF;
    -- Generación de la referencia del endoso
    v_NUMREF := 'END-' || p_POL_CONSECUTIVO || '-' || v_NUMERO_ENDOSO;
    -- Verificación de existencia de seguimiento de endoso
    SELECT COUNT(*) INTO HABIAUNO
    FROM ENDOSOS_SEGUIMIENTO ES1A
    WHERE ES1A.IDPOLIZA = p_POL_CONSECUTIVO
      AND ES1A.IDENDOSO = v_NUMERO_ENDOSO  
      AND ES1A.STSENDOSO = 'SOL';
    IF HABIAUNO > 0 THEN
      -- Eliminación de seguimiento de endoso existente
      DELETE FROM ENDOSOS_SEGUIMIENTO ES1
      WHERE ES1.IDPOLIZA = p_POL_CONSECUTIVO
        AND ES1.IDENDOSO = v_NUMERO_ENDOSO  
        AND ES1.STSENDOSO = 'SOL';
      COMMIT;
    END IF;
    -- Inserción del endoso
    INSERT INTO ENDOSOS (IDPOLIZA, IDENDOSO, TIPOENDOSO, NUMENDREF, FECINIVIG, FECFINVIG, FECSOLICITUD, 
                         FECEMISION, STSENDOSO, FECSTS, CODPLANPAGO, FECANUL, MOTIVANUL, SUMA_ASEG_LOCAL, 
                         SUMA_ASEG_MONEDA, PRIMA_NETA_LOCAL, DESCENDOSO, PRIMA_NETA_MONEDA, PORCCOMIS, 
                         CODEMPRESA, CODCIA, IDETPOL, NUM_BIEN, MOTIVO_ENDOSO, FECEXC, INDCALCDERECHOEMIS)
    VALUES (p_POL_CONSECUTIVO, v_NUMERO_ENDOSO, p_TIPO_ENDOSO, v_NUMREF, TRUNC(SYSDATE), 
            p_FEC_POL_FINVIG, p_FECSOLICITUD, p_FECEMISION, p_STS_ENDOSO, TRUNC(SYSDATE), 
            NULL, NULL, 'CONSAS', 0.00, 0.00, 0.00, p_DESC_ENDOSO, 0.00, 0.00, 1, 1, p_IDETPOL, 
            NULL, p_MOTIVO_ENDOSO, NULL, 'N');
    COMMIT;
    -- Inserción del seguimiento del endoso
    INSERT INTO ENDOSOS_SEGUIMIENTO (IDPOLIZA, IDENDOSO, TIPOENDOSO, NUMENDREF, STSENDOSO, FECSTS, 
                                     IDETPOL, USUARIO, TERMINAL, FECH_ALTA)
    VALUES (p_POL_CONSECUTIVO, v_NUMERO_ENDOSO, 'ESV', v_NUMREF, 'SOL', TRUNC(SYSDATE), 
            p_IDETPOL, USUSARIO, TERMINAL, SYSDATE);
    COMMIT;
    -- Verificación de existencia del asegurado en el certificado
    SELECT COUNT(*) INTO HAYASEGURADO
    FROM ASEGURADO_CERTIFICADO AC2
    WHERE AC2.CODCIA = 1 
      AND AC2.IDPOLIZA = p_POL_CONSECUTIVO
      AND AC2.IDETPOL = p_IDETPOL
      AND AC2.COD_ASEGURADO = nCod_Asegurado;
    -- Obtención del asegurado más antiguo para heredar coberturas
    BEGIN
      SELECT MIN(C2.COD_ASEGURADO) INTO cAseguradoAlfa
      FROM ASEGURADO_CERTIFICADO C2, COBERT_ACT_ASEG CAA
      WHERE C2.CODCIA = 1
        AND C2.IDPOLIZA = p_POL_CONSECUTIVO
        AND C2.IDETPOL = p_IDETPOL
        AND CAA.IDPOLIZA = C2.IDPOLIZA   
        AND CAA.COD_ASEGURADO = C2.COD_ASEGURADO
        AND CAA.STSCOBERTURA = 'EMI';
    END;
    -- Inserción de coberturas heredadas
    FOR i IN HEREDA_COBERTURA(1, 1, p_POL_CONSECUTIVO, p_IDETPOL, cAseguradoAlfa) LOOP
      INSERT INTO COBERT_ACT_ASEG (IdPoliza, IDetPol, CodEmpresa, IdTipoSeg, CodCia,
                                   CodCobert, StsCobertura, SumaAseg_Local, SumaAseg_Moneda,
                                   Prima_Local, Prima_Moneda, Tasa, IdEndoso, TipoRef,
                                   NumRef, PlanCob, Cod_Moneda, Deducible_Local, Deducible_Moneda,
                                   Cod_Asegurado)
      VALUES (i.IDPOLIZA, i.IDETPOL, 1, i.IDTIPOSEG, 1,
              i.CODCOBERT, 'EMI', i.SUMAASEG_LOCAL, i.SUMAASEG_MONEDA,
              i.PRIMA_LOCAL, i.PRIMA_MONEDA, i.TASA, v_NUMERO_ENDOSO, 'POLI',
              i.IDPOLIZA, i.PLANCOB, i.COD_MONEDA, i.DEDUCIBLE_MONEDA, i.DEDUCIBLE_LOCAL, 
              p_COD_ASEGURADO);
      COMMIT;
    END LOOP;
    -- Actualización de valores y asistencia del asegurado
    OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(1, 1, p_POL_CONSECUTIVO, 
                                              p_IDETPOL, NVL(p_COD_ASEGURADO, nCod_Asegurado));
    COMMIT;
    OC_ASEGURADO_CERTIFICADO.ACTUALIZA_ASISTENCIAS(1, 1, p_POL_CONSECUTIVO, 
                                                  1, NVL(p_COD_ASEGURADO, nCod_Asegurado));
    COMMIT;
    -- Emisión del asegurado y del endoso
    OC_ASEGURADO_CERTIFICADO.EMITIR(1, p_POL_CONSECUTIVO, 1, NVL(p_COD_ASEGURADO, nCod_Asegurado), v_NUMERO_ENDOSO);
    COMMIT;
    OC_ENDOSO.EMITIR(1, 1, p_POL_CONSECUTIVO, p_IDETPOL, v_NUMERO_ENDOSO, 'ESV');
    COMMIT;
    -- Actualización del estado de las coberturas
    UPDATE COBERT_ACT_ASEG
    SET StsCobertura = 'EMI'
    WHERE CodCia = 1
      AND IdPoliza = p_POL_CONSECUTIVO
      AND IdetPol = p_IDETPOL
      AND IdEndoso = v_NUMERO_ENDOSO
      AND Cod_Asegurado = NVL(p_COD_ASEGURADO, nCod_Asegurado);
    COMMIT;
    -- Verificación de emisión del asegurado
    SELECT COUNT(*) INTO HABEMUS_EMIS
    FROM ASEGURADO_CERTIFICADO AC
    WHERE AC.CODCIA = 1
      AND AC.IDPOLIZA = p_POL_CONSECUTIVO
      AND AC.IDETPOL = p_IDETPOL
      AND AC.COD_ASEGURADO = NVL(p_COD_ASEGURADO, nCod_Asegurado)
      AND AC.ESTADO = 'EMI';
    IF HABEMUS_EMIS > 0 THEN
      -- Actualización del estado del endoso a 'EMI'
      UPDATE ENDOSOS_SEGUIMIENTO ES1
      SET ES1.STSENDOSO = 'EMI'
      WHERE ES1.IDPOLIZA = p_POL_CONSECUTIVO
        AND ES1.IDENDOSO = v_NUMERO_ENDOSO  
        AND ES1.STSENDOSO = 'SOL';
      COMMIT;
    ELSIF HABEMUS_EMIS = 0 THEN
      -- Reintento de emisión del endoso
      OC_ENDOSO.EMITIR(1, 1, p_POL_CONSECUTIVO, p_IDETPOL, v_NUMERO_ENDOSO, 'ESV');
      COMMIT;
      -- Verificación de emisión del asegurado después del reintento
      SELECT COUNT(*) INTO HABEMUS_EMIS
      FROM ASEGURADO_CERTIFICADO AC
      WHERE AC.CODCIA = 1
        AND AC.IDPOLIZA = p_POL_CONSECUTIVO
        AND AC.IDETPOL = p_IDETPOL
        AND AC.COD_ASEGURADO = NVL(p_COD_ASEGURADO, nCod_Asegurado)
        AND AC.ESTADO = 'EMI';
      IF HABEMUS_EMIS > 0 THEN
        -- Actualización del estado del endoso a 'EMI'
        UPDATE ENDOSOS_SEGUIMIENTO ES1
        SET ES1.STSENDOSO = 'EMI'
        WHERE ES1.IDPOLIZA = p_POL_CONSECUTIVO
          AND ES1.IDENDOSO = v_NUMERO_ENDOSO  
          AND ES1.STSENDOSO = 'SOL';
        COMMIT;
      END IF;
    END IF;
    -- Verificación de coberturas emitidas
    SELECT COUNT(*) INTO coberturaEmi 
    FROM COBERTURA_ASEG CAS1
    WHERE CAS1.IDPOLIZA = p_POL_CONSECUTIVO
      AND CAS1.COD_ASEGURADO = NVL(p_COD_ASEGURADO, nCod_Asegurado)
      AND CAS1.STSCOBERTURA = 'EMI';
    IF coberturaEmi = 0 THEN
      -- Emisión de coberturas
      OC_COBERT_ACT_ASEG.EMITIR(1, 1, p_POL_CONSECUTIVO, 1, NVL(p_COD_ASEGURADO, nCod_Asegurado), v_NUMERO_ENDOSO);
      COMMIT;
    END IF;
    -- Actualización de la cantidad de asegurados modelo
    BEGIN
      SELECT NVL(CantAsegModelo, 0) INTO nCantAsegModelo
      FROM Detalle_Poliza
      WHERE IdPoliza = p_POL_CONSECUTIVO
        AND IdetPol = p_IDETPOL;   
    EXCEPTION WHEN OTHERS THEN
      nCantAsegModelo := 0;                       	
    END;
    IF nCantAsegModelo > 0 THEN
      NvaCantAsegModelo := nCantAsegModelo - 1;
      UPDATE Detalle_Poliza
      SET CantAsegModelo = (CantAsegModelo - 1)
      WHERE IdPoliza = p_POL_CONSECUTIVO
        AND IdetPol = p_IDETPOL;  
      COMMIT;
    END IF;
    -- Generación de texto para el endoso
    cTexto := 'Se da de Alta al Asegurado ' || p_COD_ASEGURADO || ' - ' || oc_asegurado.NOMBRE_ASEGURADO(NVL(NVL(p_CODCIA, 1), 1), NVL(NVL(p_CODEMPRESA, 1), 1), p_COD_ASEGURADO) || 
              '  por medio del Endoso Sin Valor  :  ' || v_NUMERO_ENDOSO ||
              '   Número de Referencia del Endoso:  ' || v_NUMREF ||
              '   La Póliza ' || p_POL_CONSECUTIVO || '   Certificado  ' || p_IDETPOL || '  Tenía  ' || nCantAsegModelo || '    Asegurados Modelo  y ahora tiene ' || NvaCantAsegModelo ||
              '   Alta hecha por el usuario  ' || USUSARIO || ' - ' || (OC_USUARIOS.NOMBRE_USUARIO(NVL(p_CODCIA, 1), USUSARIO)) || '   en la Terminal:  ' || TERMINAL || ' en la fecha: ' || Fecha_Hoy;
    IF cTexto IS NOT NULL THEN
      -- Inserción del texto en el endoso
      INSERT INTO ENDOSO_TEXTO (IdPoliza, IdEndoso, Texto)
      VALUES (p_POL_CONSECUTIVO, v_NUMERO_ENDOSO, cTexto);
      COMMIT;
    END IF;
    -- Actualización del estado del endoso a 'EMI'
    UPDATE ENDOSOS_SEGUIMIENTO ES1
    SET ES1.STSENDOSO = 'EMI'
    WHERE ES1.IDPOLIZA = p_POL_CONSECUTIVO
      AND ES1.IDENDOSO = v_NUMERO_ENDOSO  
      AND ES1.STSENDOSO = 'SOL';
    COMMIT;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    -- Manejo de excepciones: limpieza de datos y rollback
    ROLVAC_4_END_PNJ_ASEG_COB; 
    ROLVAC_5_ABORT_MISSION; 
    COMMIT;  
    RAISE;
END WS_ALTA_ASEGURADO;
/

CREATE OR REPLACE PUBLIC SYNONYM WS_ALTA_ASEGURADO FOR SICAS_OC.WS_ALTA_ASEGURADO
/

GRANT EXECUTE ON SICAS_OC.WS_ALTA_ASEGURADO TO PUBLIC
/