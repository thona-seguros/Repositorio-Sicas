--
-- OC_DETALLE_FACTURA_EXTERNA  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   DETALLE_FACTURA_EXTERNA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_DETALLE_FACTURA_EXTERNA IS

  PROCEDURE INSERTA_DETALLE(nIdeFactExt NUMBER, cNumFactExt VARCHAR2, cRfcProvAtiende VARCHAR2, cNomProvAtiende VARCHAR2, 
                            cRegimenFis VARCHAR2, cRfcBenefPago VARCHAR2, cNomBenefPago VARCHAR2, nMtoGtoHonorario NUMBER,
                            nMtoGtoHospital NUMBER, nMtoOtroGasto NUMBER, nMtoDescuento NUMBER, nMtoDeducible NUMBER,
                            nMtoIVA NUMBER, nMtoISR NUMBER, nMtoIVARet NUMBER, nMtoImpCedular NUMBER,
                            nMtoTotal NUMBER);

END OC_DETALLE_FACTURA_EXTERNA;
/

--
-- OC_DETALLE_FACTURA_EXTERNA  (Package Body) 
--
--  Dependencies: 
--   OC_DETALLE_FACTURA_EXTERNA (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_DETALLE_FACTURA_EXTERNA IS

    PROCEDURE INSERTA_DETALLE(nIdeFactExt NUMBER, cNumFactExt VARCHAR2, cRfcProvAtiende VARCHAR2, cNomProvAtiende VARCHAR2, 
                              cRegimenFis VARCHAR2, cRfcBenefPago VARCHAR2, cNomBenefPago VARCHAR2, nMtoGtoHonorario NUMBER,
                              nMtoGtoHospital NUMBER, nMtoOtroGasto NUMBER, nMtoDescuento NUMBER, nMtoDeducible NUMBER,
                              nMtoIVA NUMBER, nMtoISR NUMBER, nMtoIVARet NUMBER, nMtoImpCedular NUMBER,
                              nMtoTotal NUMBER) IS
        nExiste NUMBER;
    BEGIN
        BEGIN
            SELECT 1
              INTO nExiste
              FROM DETALLE_FACTURA_EXTERNA
             WHERE IdeFactExt    = nIdeFactExt
               AND NumFactExt = cNumFactExt;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                nExiste := 0;
            WHEN TOO_MANY_ROWS THEN
                nExiste := 1;
        END;
        IF nExiste = 1 THEN 
            RAISE_APPLICATION_ERROR(-20225,'La factura '||cNumFactExt||' ya existe, por favor valide');
        ELSE
            INSERT INTO DETALLE_FACTURA_EXTERNA(IdeFactExt,     NumFactExt,    RfcProvAtiende, NomProvAtiende , 
                                                RegimenFis,     RfcBenefPago,  NomBenefPago,   MtoGtoHonorario ,
                                                MtoGtoHospital, MtoOtroGasto,  MtoDescuento,   MtoDeducible ,
                                                MtoIVA,         MtoISR,        MtoIVARet,      MtoImpCedular ,
                                                MtoTotal,       FecFactExt,    CodUsuario)
                                         VALUES(nIdeFactExt,    cNumFactExt,   cRfcProvAtiende,cNomProvAtiende , 
                                                cRegimenFis,    cRfcBenefPago, cNomBenefPago,  nMtoGtoHonorario ,
                                                nMtoGtoHospital,nMtoOtroGasto, nMtoDescuento,  nMtoDeducible ,
                                                nMtoIVA,        nMtoISR,       nMtoIVARet,     nMtoImpCedular ,
                                                nMtoTotal,      TRUNC(SYSDATE),USER);
        END IF;
    END INSERTA_DETALLE;

END OC_DETALLE_FACTURA_EXTERNA;
/
