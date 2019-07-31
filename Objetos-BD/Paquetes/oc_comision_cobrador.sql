--
-- OC_COMISION_COBRADOR  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FACTURAS (Table)
--   FZ_DETALLE_FIANZAS (Table)
--   DETALLE_COBRADOR (Table)
--   DETALLE_POLIZA (Table)
--   EMPRESAS (Table)
--   TASAS_CAMBIO (Table)
--   COMISION_COBRADOR (Table)
--   OC_EMPRESAS (Package)
--   OC_GENERALES (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_COMISION_COBRADOR IS

FUNCTION NUMERO_COMISION RETURN NUMBER;

PROCEDURE PROC_PAGA_COMI_COBRA(nIdFactura NUMBER, nMontoPago NUMBER, dFecSts DATE, nPorcApl NUMBER,
                               cIndPago VARCHAR2, nCodCobrador NUMBER, cCodMoneda VARCHAR2, cRecibo VARCHAR2);

PROCEDURE ANULAR_COMISION(nIdFactura NUMBER, nCodCobrador NUMBER);

END OC_COMISION_COBRADOR;
/

--
-- OC_COMISION_COBRADOR  (Package Body) 
--
--  Dependencies: 
--   OC_COMISION_COBRADOR (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_COMISION_COBRADOR IS

FUNCTION NUMERO_COMISION RETURN NUMBER IS
nIdComision       COMISION_COBRADOR.IdComision%TYPE;
BEGIN
   BEGIN 
      SELECT NVL(MAX(IdComision),0) + 1
        INTO nIdComision
        FROM COMISION_COBRADOR;
   END;
   RETURN(nIdComision);
END NUMERO_COMISION;

PROCEDURE PROC_PAGA_COMI_COBRA(nIdFactura NUMBER, nMontoPago NUMBER, dFecSts DATE, nPorcApl NUMBER,
                               cIndPago VARCHAR2, nCodCobrador NUMBER, cCodMoneda VARCHAR2, cRecibo VARCHAR2) IS
cIdTipoSeg        DETALLE_POLIZA.IdTipoSeg%TYPE;
nMontoComision    DETALLE_COBRADOR.MontoComision%TYPE;
nPorcentaje       DETALLE_COBRADOR.Porcentaje%TYPE;
nIdComision       COMISION_COBRADOR.IdComision%TYPE;
cCod_Moneda       FACTURAS.Cod_Moneda%TYPE;
nMto_Local        COMISION_COBRADOR.Monto_Local%TYPE;
nMto_Moneda       COMISION_COBRADOR.Monto_Moneda%TYPE;
nTasa             TASAS_CAMBIO.Tasa_Cambio%TYPE;
nCodCia           EMPRESAS.CodCia%TYPE;
cCodMoneda_Emp    EMPRESAS.Cod_Moneda%TYPE;
BEGIN
   nIdComision := OC_COMISION_COBRADOR.NUMERO_COMISION;

   BEGIN
      SELECT D.IdTipoSeg,F.Cod_Moneda,F.CodCia
        INTO cIdTipoSeg,cCod_Moneda,nCodCia
        FROM DETALLE_POLIZA D, FACTURAS F
       WHERE D.IdPoliza  = F.IdPoliza
         AND F.IdFactura = nIdFactura
       UNION
      SELECT D.IdTipoSeg,F.Cod_Moneda,F.CodCia
        FROM FZ_DETALLE_FIANZAS D, FACTURAS F
       WHERE D.IdPoliza   = F.IdPoliza
         AND F. IdFactura = nIdFactura
    GROUP BY D.IdTipoSeg,F.Cod_Moneda,F.CodCia;
   EXCEPTION
      WHEN OTHERS THEN
         cIdTipoSeg := NULL;
   END;
   BEGIN 
      SELECT MontoComision,Porcentaje
        INTO nMontoComision,nPorcentaje
        FROM DETALLE_COBRADOR
       WHERE CodCobrador = nCodCobrador
         AND Cod_Moneda  = cCodMoneda
         AND IdTipoSeg   = cIdTipoSeg;
   EXCEPTION
      WHEN OTHERS THEN
         nMontoComision := 0;
         nPorcentaje    := 0;  
   END;

   cCodMoneda_Emp := OC_EMPRESAS.MONEDA_COMPANIA(nCodCia);

   IF cCod_Moneda != cCodMoneda_Emp THEN 
      nTasa  := OC_GENERALES.TASA_DE_CAMBIO(cCod_Moneda, TRUNC(SYSDATE));

      IF nTasa > 0 THEN 
         BEGIN
            IF nMontoComision != 0    AND nPorcentaje = 0 THEN
               nMto_Local  :=  nMontoComision * nPorcApl * nTasa;
               nMto_Moneda :=  nMontoComision * nPorcApl;
            ELSE
               nMto_Local  := (nMontoPago * nPorcApl  * nTasa * nPorcentaje ) / 100;
               nMto_Moneda := (nMontoPago * nPorcApl * nPorcentaje) / 100;         
              END IF;
         END;  
      ELSE
         RAISE_APPLICATION_ERROR (-20100,'No Existe Tasa de Cambio para Moneda - '||cCod_Moneda);
      END IF;
   ELSE
      BEGIN
         IF nMontoComision != 0   AND nPorcentaje = 0 THEN
            nMto_Local  := nMontoComision;
            nMto_Moneda := nMontoComision;
         ELSE
            nMto_Local  := (nMontoPago *  nPorcentaje) / 100;
            nMto_Moneda := (nMontoPago *  nPorcentaje) / 100;   
         END IF ;  
      END;
   END   IF;
   IF nMto_Local != 0 OR nMto_Moneda != 0 THEN 
      INSERT INTO COMISION_COBRADOR
            (IdComision, CodCobrador, IdFactura, Fecha_Pago, Recibo_Pago, 
             Monto_Local, Monto_Moneda, Fecha_Liquidado, StsComision)
      VALUES(nIdComision, nCodCobrador, nIdFactura, dFecSts, cRecibo,
             nMto_Local, nMto_Moneda, NULL, 'EMI');
   END IF;     
END PROC_PAGA_COMI_COBRA;

PROCEDURE ANULAR_COMISION(nIdFactura NUMBER, nCodCobrador NUMBER) IS
BEGIN
   UPDATE COMISION_COBRADOR
      SET StsComision  = 'ANU'
    WHERE IdFactura       = nIdFactura
      AND CodCobrador     = nCodCobrador
      AND StsComision     = 'EMI'
      AND Fecha_Liquidado IS NULL;
END ANULAR_COMISION;

END OC_COMISION_COBRADOR;
/
