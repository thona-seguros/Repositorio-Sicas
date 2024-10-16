CREATE OR REPLACE PACKAGE SICAS_OC.OC_NOMINA IS
FUNCTION  CREAR(nCodCia VARCHAR2) RETURN NUMBER;
PROCEDURE GENERA_NOMINA (nCodCia NUMBER, nCodEmp NUMBER, nIdNomina NUMBER, 
                         cCod_Moneda VARCHAR2, nCalculo NUMBER, cIndAutomatica VARCHAR2);
PROCEDURE PROC_ACTSTSNOM (nCodCia NUMBER, nCodEmpresa NUMBER , nIdNomina NUMBER,  cStsNom VARCHAR2);
PROCEDURE PAGO_NOMINA (nCodCia NUMBER, nCodEmpresa NUMBER, nIdNomina NUMBER);
PROCEDURE ANULA_NOMINA (nCodCia NUMBER, nCodEmpresa NUMBER, nIdNomina NUMBER,
                        dFecAnul DATE, cMotivAnul VARCHAR2);
PROCEDURE MODIFICA_COMISION (nCodCia NUMBER, nCodEmpresa NUMBER, nIdComision NUMBER, 
                             nComAntLocal NUMBER, nComActLocal NUMBER,  nComAntMoneda NUMBER,
                             nComActMoneda NUMBER);
PROCEDURE PROCESA_NOTAS (nCodCia NUMBER, nCodEmpresa NUMBER, nIdNomina NUMBER);
PROCEDURE PROCESA_NOTAS_COMISION (nCodCia NUMBER, nCodEmpresa NUMBER, nIdNomina NUMBER);
PROCEDURE GENERA_DETALLE_NOMINA_COM(nCodCia NUMBER, nIdNomina NUMBER);
PROCEDURE REVERTIR_NOMINA (nCodCia NUMBER, nCodEmpresa NUMBER, nIdNomina NUMBER);
PROCEDURE ACTUALIZA_AUTORIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdNomina NUMBER, nIdAutorizacion NUMBER);
END OC_NOMINA;
/
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_NOMINA IS
--
-- 20190930  SE AJUSTE LA PROGRAMACION      ICO
-- 20191223  SE DESCOMENTA EL PROCEDIMIENTO REVERTIR NOMINA Y SE COMPLETAN DATOS DE INDICES  JMMD
--
FUNCTION CREAR(nCodCia VARCHAR2) RETURN NUMBER  IS
nIdNomina   NOMINA_COMISION.IdNomina%TYPE;
BEGIN
  --
  SELECT SQ_NOMINA.NEXTVAL    
    INTO nIdNomina
    FROM DUAL;
  --  
  RETURN (nIdNomina);
  --
END CREAR;

PROCEDURE GENERA_NOMINA (nCodCia     NUMBER,    nCodEmp  NUMBER,  nIdNomina      NUMBER,
                         cCod_Moneda VARCHAR2,  nCalculo NUMBER,  cIndAutomatica VARCHAR2) IS
cExite       VARCHAR2(1);
--
CURSOR CUR_COMISIONES IS
  SELECT C.Cod_Agente,      C.CodCia,       C.CodEmpresa,   C.Cod_Moneda, 
        SUM(NVL(C.COMISION_LOCAL,0)) COMISION_LOCAL, SUM(NVL(C.COMISION_MONEDA,0)) COMISION_MONEDA, C.IDCOMISION
    FROM COMISIONES C, POLIZAS P
   WHERE C.CodCia     = nCodCia
     AND C.IdNomina   = nIdNomina
     AND C.Cod_Moneda = cCod_Moneda
     AND C.Estado     = 'LIQ'
     AND P.IdPoliza   = C.IdPoliza
   GROUP BY C.Cod_Agente, C.CodCia, C.CodEmpresa, C.Cod_Moneda, C.IdComision   
;   
--  
BEGIN
   IF nCalculo = 0 THEN
      UPDATE COMISIONES
         SET Fec_Liquidacion = SYSDATE
       WHERE CodCia      = nCodCia
         AND IdNomina    = nIdNomina
         AND CodEmpresa  = nCodEmp
         AND Cod_Moneda  = cCod_Moneda
         AND Estado      = 'LIQ';
   ELSE
      UPDATE COMISIONES
         SET Fec_Liquidacion = SYSDATE
       WHERE CodCia      = nCodCia
         AND IdNomina    = nIdNomina
         AND CodEmpresa  = nCodEmp
         AND Nomina_Pago = TO_CHAR(nIdNomina)
         AND Cod_Moneda  = cCod_Moneda
         AND Estado      = 'LIQ';
   END IF;
   --
   FOR X IN CUR_COMISIONES LOOP
/*       BEGIN
         SELECT CodFormaPago, CodEntidadFinan, NumCuentabancaria
           INTO cFormPago,    cEntFinan,       cNum_Cuenta
           FROM MEDIOS_DE_PAGO MDP, AGENTES AG
          WHERE MDP.Tipo_Doc_Identificacion = AG.Tipo_Doc_Identificacion
            AND MDP.Num_Doc_Identificacion  = AG.Num_Doc_Identificacion
            AND Cod_Agente                  = X.Cod_Agente
            AND CodCia                      = X.CodCia
            AND CodEmpresa                  = X.CodEmpresa
            AND MDP.IndMedioPrincipal       = 'S';
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR(-20225,'No existe Forma de Pago definida para el Agente ' || SQLERRM);
         WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR(-20225,'Hay problemas con la Forma de Pago definida para el Agente ' || SQLERRM);
       END;*/
       --
       BEGIN
         SELECT 'S'
           INTO cExite
           FROM NOMINA_COMISION
          WHERE CodCia      = X.CodCia
            AND CodEmpresa  = X.CodEmpresa
            AND IdNomina    = nIdNomina;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
              INSERT INTO NOMINA_COMISION
               (CodCia,   CodEmpresa,   IdNomina,  Estado,  FecEmision,  CreadoPor,  IndAutomatica)
              VALUES 
               (X.CodCia, X.CodEmpresa, nIdNomina, 'EMI',   SYSDATE,     USER,       cIndAutomatica);
         WHEN OTHERS THEN
            cExite := 'S';
       END;
       --
       INSERT INTO DETALLE_NOMINA
        (Cod_Agente,     CodCia,             CodEmpresa,          IdNomina, 
         CodMoneda,      MontoNetoLocal,     MontoNetoMoneda,     IdComision)
       VALUES 
        (X.Cod_Agente,   X.CodCia,           X.CodEmpresa,        nIdNomina, 
         X.Cod_Moneda,   X.COMISION_LOCAL,   X.COMISION_MONEDA,   X.IdComision);
   END LOOP;
EXCEPTION
     WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20225,'No fue posible completar el proceso, ocurri� el siguiente error: ' || SQLERRM);
END GENERA_NOMINA;

PROCEDURE PROC_ACTSTSNOM (nCodCia NUMBER, nCodEmpresa NUMBER , nIdNomina NUMBER,  cStsNom VARCHAR2) IS
BEGIN
   UPDATE NOMINA_COMISION
      SET Estado     = cStsNom
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND IdNomina   = nIdNomina;
END PROC_ACTSTSNOM;

PROCEDURE PAGO_NOMINA (nCodCia NUMBER, nCodEmpresa NUMBER, nIdNomina NUMBER)IS
nReg         NUMBER;
cCodMoneda   MONEDA.Cod_Moneda%TYPE;
cFormPago    FORMAS_PAGO_AGENTES.FormPago%TYPE;
cEntFinan    FORMAS_PAGO_AGENTES.EntFinan%TYPE;
cNum_Cuenta  FORMAS_PAGO_AGENTES.Num_Cuenta%TYPE;
nIdNcr       NOTAS_DE_CREDITO.IdNcr%TYPE;
nTasaCambio  DETALLE_POLIZA.Tasa_Cambio%TYPE;
--
CURSOR CUR_FACTURAS IS
  SELECT C.IdFactura, C.Comision_Local, C.Comision_Moneda
    FROM COMISIONES C
   WHERE C.CodCia      = nCodCia
     AND C.CodEmpresa  = nCodEmpresa
     AND C.IdNomina    = nIdNomina
     AND C.Estado      =  'PAG';
--
CURSOR NC_Q IS
  SELECT C.IdNcr, C.Comision_Local, C.Comision_Moneda
    FROM COMISIONES C
   WHERE C.CodCia      = nCodCia
     AND C.CodEmpresa  = nCodEmpresa
     AND C.IdNomina    = nIdNomina
     AND C.Estado      =  'PAG';
--
CURSOR CUR_POLIZAS IS
   SELECT DISTINCT C.IdPoliza
     FROM COMISIONES C
    WHERE C.CodCia      = nCodCia
      AND C.CodEmpresa  = nCodEmpresa
      AND C.IdNomina   = nIdNomina
      AND C.Estado      =  'PAG';
--
CURSOR C_PAGO IS
   SELECT SUM(MontoNetoLocal) MontoNetoLocal, SUM(MontoNetoMoneda) MontoNetomMoneda, Cod_Agente, CodMoneda
     FROM DETALLE_NOMINA
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND IdNomina   = nIdNomina
    GROUP BY Cod_Agente, CodMoneda;    
    
--
BEGIN
  SELECT COUNT(*)
    INTO nReg
    FROM NOMINA_COMISION
   WHERE CodCia       = nCodCia
     AND CodEmpresa   = nCodEmpresa
     AND IdNomina     = nIdNomina
     AND FechaLiquida IS NULL;
  --
  IF nReg != 0 THEN
     --
     UPDATE NOMINA_COMISION
        SET FechaLiquida = SYSDATE,
            LiquidaPor   = USER
      WHERE CodCia       = nCodCia
        AND CodEmpresa   = nCodEmpresa
        AND IdNomina     = nIdNomina;
     --
     OC_NOMINA.PROC_ACTSTSNOM(nCodCia,nCodEmpresa, nIdNomina,  'PAG');
     --
     UPDATE COMISIONES C
        SET C.Estado      = 'PAG',
            C.Fec_Estado  = SYSDATE
      WHERE C.CodCia      = nCodCia
        AND C.CodEmpresa  = nCodEmpresa
        AND C.IdNomina    = nIdNomina
        AND C.Estado      =  'LIQ';
     --
     FOR X IN CUR_FACTURAS LOOP
         UPDATE FACTURAS
            SET ComisPagada_Local  = X.Comision_Local,
                ComisPagada_Moneda = X.Comision_Moneda
          WHERE IdFactura = X.IdFactura;
     END LOOP;
     --
     FOR W IN NC_Q LOOP
         UPDATE NOTAS_DE_CREDITO
            SET ComisPagada_Local  = W.Comision_Local,
                ComisPagada_Moneda = W.Comision_Moneda
          WHERE IdNcr = W.IdNcr;
     END LOOP;
     --
     FOR J IN C_PAGO LOOP
         nTasaCambio  := OC_GENERALES.TASA_DE_CAMBIO(J.CodMoneda, TRUNC(SYSDATE));
         BEGIN
           SELECT codformaPago , codentidadFinan , NumCuentabancaria
             INTO cFormPago,     cEntFinan,        cNum_Cuenta
             FROM MEDIOS_DE_PAGO MDP, AGENTES AG
            WHERE MDP.Tipo_Doc_Identificacion = AG.Tipo_Doc_Identificacion
              AND MDP.Num_Doc_Identificacion  = AG.Num_Doc_Identificacion
              AND Cod_Agente                  = J.Cod_Agente
              AND CodCia                      = nCodCia
              AND CodEmpresa                  = nCodEmpresa
              AND MDP.IndMedioPrincipal       = 'S';
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20225,'No existe Forma de Pago Definida para el Agente '||J.Cod_Agente||' en Moneda '||J.CodMoneda);
         END;
         --
         nIdNcr := OC_NOTAS_DE_CREDITO.INSERTA_NOTA_CREDITO(nCodCia,     NULL,           NULL,             0, 
                                                            NULL,        TRUNC(SYSDATE), J.MONTONETOLOCAL, J.MONTONETOMMONEDA,
                                                            NULL,        NULL,           J.Cod_Agente,     J.CodMoneda,
                                                            nTasaCambio,                 0,                'N');
         --
         OC_DETALLE_NOTAS_DE_CREDITO.INSERTA_DETALLE_NOTA(nIdNcr, 'COMISI', 'N', J.MONTONETOLOCAL, J.MONTONETOMMONEDA);
         --
         UPDATE NOTAS_DE_CREDITO
            SET IdNomina   = nIdNomina,
                CodTipoDoc = cFormPago
          WHERE IdNcr    = nIdNcr
            AND CodCia   = nCodCia;
      END LOOP;
   ELSE
      RAISE_APPLICATION_ERROR(-20225,'No puede pagar la N�mina porque existen Agentes a quienes no se les ha Generado pago, por favor verifique.');
   END IF;
END PAGO_NOMINA;
--
PROCEDURE ANULA_NOMINA (nCodCia NUMBER, nCodEmpresa NUMBER, nIdNomina NUMBER, dFecAnul DATE, cMotivAnul VARCHAR2) IS
nIdTransacNc        TRANSACCION.IdTransaccion%TYPE;
nTotNotaCredCanc    DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nNumComprob         COMPROBANTES_CONTABLES.NumComprob%TYPE;
cTipoComprob        COMPROBANTES_CONTABLES.TipoComprob%TYPE;

CURSOR NCR_Q IS
  SELECT IdNcr, CodCia, IdTransacAplic
    FROM NOTAS_DE_CREDITO
   WHERE StsNcr    = 'PAG'
     AND IdNomina  = nIdNomina
     AND CodCia    = nCodCia;
BEGIN
  -- Anula Notas de Cr�dito
  FOR X IN NCR_Q LOOP
      IF NVL(nIdTransacNc,0) = 0 THEN
         nIdTransacNc := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 2, 'NOTACR');
      END IF;
      -- Acumula Prima Devuelta
      SELECT NVL(SUM(Monto_Det_Moneda),0)
        INTO nTotNotaCredCanc
        FROM DETALLE_NOTAS_DE_CREDITO D, NOTAS_DE_CREDITO N, CATALOGO_DE_CONCEPTOS C
       WHERE C.CodConcepto      = D.CodCpto
         AND C.CodCia           = N.CodCia
         AND (D.IndCptoPrima    = 'S'
          OR C.IndCptoServicio  = 'S')
         AND D.IdNcr            = N.IdNcr
         AND N.IdNcr            = X.IdNcr;
      --
      OC_NOTAS_DE_CREDITO.ANULAR(X.IdNcr, dFecAnul, cMotivAnul, nIdTransacNc);
      --
      OC_DETALLE_TRANSACCION.CREA(nIdTransacNc, nCodCia,  nCodEmpresa, 2, 'NOTACR', 'NOTAS_DE_CREDITO',
                                  NULL, NULL, NULL, X.IdNcr, nTotNotaCredCanc);
      --
      BEGIN
        SELECT NumComprob, TipoComprob
          INTO nNumComprob, cTipoComprob
          FROM COMPROBANTES_CONTABLES
         WHERE CodCia         = nCodCia
           AND NumTransaccion = X.IdTransacAplic;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR(-20225,'No existe Comprobante Contable del Pago de la Nota de Cr�dito No. '||X.IdNcr);
      END;
      --
      OC_COMPROBANTES_CONTABLES.REVERSA_COMPROBANTE(nCodCia, nNumComprob, cTipoComprob);
      --
      UPDATE COMPROBANTES_CONTABLES
         SET Numtransaccion = nIdTransacNc
       WHERE NumComprob IN (SELECT MAX(NumComprob)
                              FROM COMPROBANTES_CONTABLES
                             WHERE NumTransaccion = X.IdTransacAplic);
  END LOOP;
  --
  UPDATE DETALLE_COMISION DC
       SET Estado = 'ACT'
   WHERE DC.CODCIA = nCodCia 
     AND IdComision IN (SELECT IdComision
                          FROM COMISIONES
                         WHERE IdNomina = nIdNomina);
  --
  UPDATE COMISIONES C
     SET C.Estado      = 'REC',
         C.Fec_Estado  = SYSDATE
   WHERE C.CodCia      = nCodCia
     AND C.CodEmpresa  = nCodEmpresa
     AND C.IdNomina    = nIdNomina
     AND C.Estado      =  'LIQ';
  --
  UPDATE NOMINA_COMISION
     SET Estado = 'ANULAD'
   WHERE Idnomina = nIdNomina;
  --
END ANULA_NOMINA;

PROCEDURE GENERA_DETALLE_NOMINA_COM (nCodCia NUMBER, nIdNomina NUMBER) IS
--
CURSOR CUR_COMISIONES IS
 SELECT CO.CodCia,CO.IdNomina,DC.CodConcepto,CO.Cod_Agente,CO.Cod_Moneda,
        SUM(DC.Monto_Mon_Local) MontoNetoLocal,
        SUM(DC.Monto_Mon_Extranjera) MontoNetoMoneda
   FROM COMISIONES CO, DETALLE_COMISION DC
  WHERE CO.CodCia     = DC.CodCia
    AND CO.Idcomision = DC.Idcomision
    AND CO.CodCia     = nCodCia
    AND CO.IdNomina   = nIdNomina
    AND CO.Estado     = 'LIQ'
  GROUP BY CO.CodCia, CO.IdNomina, DC.CodConcepto, CO.Cod_Agente, CO.Cod_Moneda;
BEGIN
  FOR I IN CUR_COMISIONES LOOP
      INSERT INTO DETALLE_NOMINA_COMISION
       (CodCia,           IdNomina,          CodConcepto,   Cod_Agente,
        MontoNetoLocal,   MontoNetoMoneda,   CodMoneda)
      VALUES 
       (I.CodCia,         I.IdNomina,        I.CodConcepto, I.Cod_Agente,
        I.MontoNetoLocal, I.MontoNetoMoneda, I.Cod_Moneda);
   END LOOP;
END GENERA_DETALLE_NOMINA_COM;

PROCEDURE MODIFICA_COMISION (nCodCia      NUMBER,  nCodEmpresa   NUMBER,  nIdComision   NUMBER, nComAntLocal NUMBER, 
                             nComActLocal NUMBER,  nComAntMoneda NUMBER,  nComActMoneda NUMBER) IS
BEGIN
   UPDATE COMISIONES C
      SET C.UsrMod              = USER,
          C.FecMod              = SYSDATE,
          C.Comision_Local      = nComActLocal,
          C.Comision_Local_Ant  = nComAntLocal,
          C.Comision_Moneda     = nComActMoneda,
          C.Comision_Moneda_Ant = nComAntMoneda
    WHERE C.CodCia      = nCodCia
      AND C.CodEmpresa  = nCodEmpresa
      AND C.IdComision  = nIdComision;
END MODIFICA_COMISION;

PROCEDURE PROCESA_NOTAS (nCodCia NUMBER, nCodEmpresa NUMBER, nIdNomina NUMBER) IS
--
nReg         NUMBER;
cCodMoneda   MONEDA.Cod_Moneda%TYPE;
cFormPago    FORMAS_PAGO_AGENTES.FormPago%TYPE;
cEntFinan    FORMAS_PAGO_AGENTES.EntFinan%TYPE;
cNum_Cuenta  FORMAS_PAGO_AGENTES.Num_Cuenta%TYPE;
nIdNcr       NOTAS_DE_CREDITO.IdNcr%TYPE;
nTasaCambio  DETALLE_POLIZA.Tasa_Cambio%TYPE;
cTipoAgente  AGENTES.Tipo_Agente%TYPE;
--
CURSOR C_DET_NOMINA IS
  SELECT SUM (MontoNetoLocal) MontoLocal, SUM (MontoNetoMoneda) MontoMoneda, Cod_Agente, CodMoneda
    FROM DETALLE_NOMINA
   WHERE CodCia     = nCodCia
     AND CodEmpresa = nCodEmpresa
     AND IdNomina   = nIdNomina
   GROUP BY Cod_Agente, CodMoneda;
BEGIN
  SELECT COUNT(*)
    INTO nReg
    FROM NOMINA_COMISION
   WHERE CodCia       = nCodCia
     AND CodEmpresa   = nCodEmpresa
     AND IdNomina     = nIdNomina
     AND Estado       = 'REVISA';
  --
  IF nReg != 0 THEN
     --
     BEGIN
       OC_NOMINA.PROC_ACTSTSNOM(nCodCia,nCodEmpresa, nIdNomina,  'GENERA');
     END;
     --
     FOR J IN C_DET_NOMINA LOOP
         nTasaCambio  := OC_GENERALES.TASA_DE_CAMBIO(J.CodMoneda, TRUNC(SYSDATE));
         BEGIN
           SELECT codformaPago, codentidadFinan, NumCuentabancaria
             INTO cFormPago,    cEntFinan,       cNum_Cuenta
             FROM MEDIOS_DE_PAGO MDP, AGENTES AG
            WHERE MDP.Tipo_Doc_Identificacion = AG.Tipo_Doc_Identificacion
              AND MDP.Num_Doc_Identificacion  = AG.Num_Doc_Identificacion
              AND Cod_Agente                  = J.Cod_Agente
              AND CodCia                      = nCodCia
              AND CodEmpresa                  = nCodEmpresa
              AND MDP.IndMedioPrincipal       = 'S';
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20225,'No existe Forma de Pago Definida para el Agente '||J.Cod_Agente);
         END;
         --
         nIdNcr := OC_NOTAS_DE_CREDITO.INSERTA_NOTA_CREDITO(nCodCia, NULL, NULL, 0, NULL, TRUNC(SYSDATE),J.MontoLocal, J.MontoMoneda, 
                                                            NULL, NULL,J.Cod_Agente, J.CodMoneda, nTasaCambio, 0, 'N');
         --
         BEGIN
           SELECT Tipo_Agente
             INTO cTipoAgente
             FROM AGENTES
            WHERE CodCia     = nCodCia
              AND Cod_Agente = J.Cod_Agente;
         EXCEPTION
           WHEN NO_DATA_FOUND
                THEN RAISE_APPLICATION_ERROR(-20225,'Error de Integridad, no existe el Agente '||J.Cod_Agente);
         END;
         --
         BEGIN
           OC_DETALLE_NOTAS_DE_CREDITO.GENERA_CONCEPTOS_COMISION(nCodCia, nCodEmpresa, nIdNcr, nTasaCambio, 
                                                                 J.MontoLocal, J.MontoMoneda, cTipoAgente);
         END;
         --
         UPDATE NOTAS_DE_CREDITO
            SET IdNomina   = nIdNomina,
                CodTipoDoc = cFormPago
          WHERE IdNcr    = nIdNcr
            AND CodCia   = nCodCia;
         --
         BEGIN
           OC_NOTAS_DE_CREDITO.ACTUALIZA_NOTA(nIdNcr);
         END;
      END LOOP;
   ELSE
      RAISE_APPLICATION_ERROR(-20225,'Proceso es posible solo si se ha dado por revisada la Nomina, por favor verifique.');
   END IF;
END PROCESA_NOTAS;

PROCEDURE PROCESA_NOTAS_COMISION (nCodCia NUMBER, nCodEmpresa NUMBER, nIdNomina NUMBER) IS
--
nReg         NUMBER;
cCodMoneda   MONEDA.Cod_Moneda%TYPE;
cFormPago    FORMAS_PAGO_AGENTES.FormPago%TYPE;
cEntFinan    FORMAS_PAGO_AGENTES.EntFinan%TYPE;
cNum_Cuenta  FORMAS_PAGO_AGENTES.Num_Cuenta%TYPE;
nIdNcr       NOTAS_DE_CREDITO.IdNcr%TYPE;
nTasaCambio  DETALLE_POLIZA.Tasa_Cambio%TYPE;
cTipoAgente  AGENTES.Tipo_Agente%TYPE;
--
CURSOR C_DET_NOMINA IS
  SELECT SUM (MontoNetoLocal) MontoLocal, SUM (MontoNetoMoneda) MontoMoneda, Cod_Agente, CodMoneda
    FROM DETALLE_NOMINA
   WHERE CodCia     = nCodCia
     AND CodEmpresa = nCodEmpresa
     AND IdNomina   = nIdNomina
   GROUP BY Cod_Agente, CodMoneda;
BEGIN
  SELECT COUNT(*)
    INTO nReg
    FROM NOMINA_COMISION
   WHERE CodCia       = nCodCia
     AND CodEmpresa   = nCodEmpresa
     AND IdNomina     = nIdNomina
     AND Estado       = 'REVISA';
  --
  IF nReg != 0 THEN
     --
     BEGIN
       OC_NOMINA.PROC_ACTSTSNOM(nCodCia,nCodEmpresa, nIdNomina,  'GENERA');
     END;
     --
     FOR J IN C_DET_NOMINA LOOP
         nTasaCambio  := OC_GENERALES.TASA_DE_CAMBIO(J.CodMoneda, TRUNC(SYSDATE));
         BEGIN
            SELECT codformaPago, codentidadFinan, NumCuentabancaria
              INTO cFormPago,    cEntFinan,       cNum_Cuenta
              FROM MEDIOS_DE_PAGO MDP, AGENTES AG
             WHERE MDP.Tipo_Doc_Identificacion = AG.Tipo_Doc_Identificacion
               AND MDP.Num_Doc_Identificacion  = AG.Num_Doc_Identificacion
               AND Cod_Agente                  = J.Cod_Agente
               AND CodCia                      = nCodCia
               AND CodEmpresa                  = nCodEmpresa
               AND MDP.IndMedioPrincipal       = 'S';
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20225,'No existe Forma de Pago Definida para el Agente '||J.Cod_Agente||' en Moneda '||J.CodMoneda);
         END;
         nIdNcr := OC_NOTAS_DE_CREDITO.INSERTA_NOTA_CREDITO(nCodCia, NULL, NULL, 0, NULL, TRUNC(SYSDATE),J.MontoLocal, J.MontoMoneda, NULL, NULL,
                                                            J.Cod_Agente, J.CodMoneda, nTasaCambio,0, 'N');
         --                                                   
         BEGIN 
           SELECT Tipo_Agente
             INTO cTipoAgente
             FROM AGENTES
            WHERE CodCia     = nCodCia
              AND Cod_Agente = J.Cod_Agente;
         EXCEPTION
           WHEN NO_DATA_FOUND
                THEN RAISE_APPLICATION_ERROR(-20225,'Error de Integridad, no existe el Agente '||J.Cod_Agente);
         END;
         --
         BEGIN
           OC_DETALLE_NOTAS_DE_CREDITO.GENERA_CONCEPTOS_NOTA(nCodCia, nIdNcr,nIdNomina);
         END;
         --
         UPDATE NOTAS_DE_CREDITO
            SET IdNomina   = nIdNomina,
                CodTipoDoc = cFormPago
          WHERE IdNcr    = nIdNcr
            AND CodCia   = nCodCia;
         --
         BEGIN
           OC_NOTAS_DE_CREDITO.ACTUALIZA_NOTA(nIdNcr);
         END;
         --
      END LOOP;
   ELSE
      RAISE_APPLICATION_ERROR(-20225,'Proceso es posible solo si se ha dado por revisada la Nomina, por favor verifique.');
   END IF;
END PROCESA_NOTAS_COMISION;

PROCEDURE REVERTIR_NOMINA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdNomina NUMBER) IS
nExiste      NUMBER(5) := 0;
--
CURSOR NOM_Q IS
  SELECT *
    FROM NOMINA_COMISION NC
   WHERE NC.IDNOMINA = nIdNomina
     AND NC.CODCIA   = nCodCia;
--
CURSOR NC_Q IS
  SELECT *
    FROM NOTAS_DE_CREDITO N
   WHERE IdNomina = nIdNomina
     AND N.CODCIA = nCodCia;
--
BEGIN
--  NULL;  jmmd20191223 se descomento el procedimiento por solicitud de Juan Perez

  FOR W IN NC_Q LOOP
      SELECT COUNT(*)
        INTO nExiste
        FROM COMPROBANTES_CONTABLES
       WHERE CODCIA = nCodCia
         AND NumTransaccion = W.IdTransacAplic
         AND FecEnvioSc IS NOT NULL;
      --
      IF nExiste != 0 THEN
         RAISE_APPLICATION_ERROR(-20225,'NO es Posible Revertir la Liquidaci�n de Comisiones No. ' ||
                                 nIdNomina || ', Porque la Contabilidad fue Enviada al Sistema Central Contable. ' ||
                                 ' Debe Anular la Liquidaci�n.');
      END IF;
   END LOOP;
   --
   FOR X IN NOM_Q LOOP
       UPDATE DETALLE_COMISION DC
          SET Estado = 'ACT'
        WHERE DC.CODCIA = nCodCia
          AND DC.IdComision IN (SELECT IdComision
                                  FROM COMISIONES C
                                 WHERE C.CODCIA   = nCodCia
                                   AND C.IdNomina = nIdNomina);
       --
       UPDATE COMISIONES C
          SET Estado          = 'REC',
              IdNomina        = NULL,
              Fec_Liquidacion = NULL
        WHERE C.CODCIA = nCodCia
          AND IdNomina = nIdNomina;
       --
       FOR W IN NC_Q LOOP
           DELETE COMPROBANTES_DETALLE
            WHERE Codcia = nCodCia
              AND NumComprob IN (SELECT NumComprob
                                   FROM COMPROBANTES_CONTABLES
                                  WHERE Codcia = nCodCia
                                    and NumTransaccion = W.IdTransacAplic);
           -- 
           DELETE COMPROBANTES_CONTABLES
            WHERE Codcia = nCodCia
              AND NumTransaccion = W.IdTransacAplic;
           --
           DELETE NCR_FACTEXT
            WHERE IdNcr = W.IdNcr;
           --       
           DELETE DETALLE_NOTAS_DE_CREDITO
            WHERE IdNcr = W.IdNcr;
           --
           DELETE NOTAS_DE_CREDITO
            WHERE Codcia = nCodCia
              AND IdNcr  = W.IdNcr;
           --
           DELETE DETALLE_TRANSACCION 
            WHERE Codcia        = nCodCia
              AND IdTransaccion = W.IdTransacAplic;
           --
           DELETE TRANSACCION 
            WHERE Codcia        = nCodCia
              AND IdTransaccion = W.IdTransacAplic;
       END LOOP;
       --
       DELETE DETALLE_NOMINA_COMISION
        WHERE Codcia   = nCodCia
          AND Idnomina = nIdNomina;    
       --
       DELETE DETALLE_NOMINA 
        WHERE Codcia   = nCodCia
          AND Idnomina = nIdNomina;
       --
       DELETE NOMINA_COMISION
        WHERE IdNomina = nIdNomina;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,SQLERRM);

END REVERTIR_NOMINA;
--
PROCEDURE ACTUALIZA_AUTORIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdNomina NUMBER, nIdAutorizacion NUMBER) IS
BEGIN
  UPDATE NOMINA_COMISION
     SET IdAutorizacion = nIdAutorizacion
   WHERE CodCia     = nCodCia
     AND CodEmpresa = nCodEmpresa
     AND IdNomina   = nIdNomina;
EXCEPTION
  WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20225,'Error al Asignar Autorizaci�n: '||nIdAutorizacion||' '||SQLERRM);
END ACTUALIZA_AUTORIZACION;

END OC_NOMINA;

