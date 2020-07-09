--
-- GT_EAD_CONTROL_ASEG_COBERT  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   EAD_CONTROL_ASEG_COBERT (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_EAD_CONTROL_ASEG_COBERT AS
PROCEDURE INSERTAR(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nNumDeclaracion IN NUMBER, nIdPoliza IN NUMBER,
                   nIDetPol IN NUMBER, nCodAsegurado IN NUMBER, nIdEndoso IN NUMBER, cCodCobert IN VARCHAR2,
                   nMtoSumaAsegLocal IN NUMBER, nMtoSumaAsegMoneda IN NUMBER, nMtoPrimaLocal IN NUMBER, nMtoPrimaMoneda IN NUMBER,
                   nTasa IN NUMBER, nSalarioMensual IN NUMBER, nVecesSalario IN NUMBER);
                   
PROCEDURE SUSPENDER(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nNumDeclaracion IN NUMBER, nIdPoliza IN NUMBER,
                    nIDetPol IN NUMBER, nCodAsegurado IN NUMBER, nIdEndoso IN NUMBER, cCodCobert IN VARCHAR2);            
PROCEDURE ACTUALIZAR_VALORES(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nNumDeclaracion IN NUMBER, nIdPoliza IN NUMBER,
                              nIDetPol IN NUMBER, nCodAsegurado IN NUMBER, nIdEndoso IN NUMBER, cCodCobert IN VARCHAR2);                    
END GT_EAD_CONTROL_ASEG_COBERT;
/

--
-- GT_EAD_CONTROL_ASEG_COBERT  (Package Body) 
--
--  Dependencies: 
--   GT_EAD_CONTROL_ASEG_COBERT (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_EAD_CONTROL_ASEG_COBERT AS
PROCEDURE INSERTAR(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nNumDeclaracion IN NUMBER, nIdPoliza IN NUMBER,
                   nIDetPol IN NUMBER, nCodAsegurado IN NUMBER, nIdEndoso IN NUMBER, cCodCobert IN VARCHAR2,
                   nMtoSumaAsegLocal IN NUMBER, nMtoSumaAsegMoneda IN NUMBER, nMtoPrimaLocal IN NUMBER, nMtoPrimaMoneda IN NUMBER,
                   nTasa IN NUMBER, nSalarioMensual IN NUMBER, nVecesSalario IN NUMBER) IS
BEGIN
   BEGIN
      --DBMS_OUTPUT.PUT_LINE(nIdPoliza||' - '||nIDetPol||' - '||nCodAsegurado||' - '||nIdEndoso||' - '||cCodCobert);
      INSERT INTO EAD_CONTROL_ASEG_COBERT (CodCia, CodEmpresa, NumDeclaracion, IdPoliza, IDetPol, CodAsegurado,
                                           IdEndoso, CodCobert, MtoSumaAsegLocal, MtoSumaAsegMoneda, MtoPrimaLocal, MtoPrimaMoneda,
                                           Tasa, SalarioMensual, VecesSalario, StsCobert, FechaEstatus)
                                   VALUES (nCodCia, nCodEmpresa, nNumDeclaracion, nIdPoliza, nIDetPol, nCodAsegurado, 
                                           nIdEndoso, cCodCobert, nMtoSumaAsegLocal, nMtoSumaAsegMoneda, nMtoPrimaLocal, nMtoPrimaMoneda,
                                           nTasa, nSalarioMensual, nVecesSalario, 'ACTIVA', TRUNC(SYSDATE));
   END;
END INSERTAR;

PROCEDURE SUSPENDER(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nNumDeclaracion IN NUMBER, nIdPoliza IN NUMBER,
                    nIDetPol IN NUMBER, nCodAsegurado IN NUMBER, nIdEndoso IN NUMBER, cCodCobert IN VARCHAR2) IS
BEGIN
   UPDATE EAD_CONTROL_ASEG_COBERT
      SET StsCobert     = 'SUSPENDIDA',
          FechaEstatus  = TRUNC(SYSDATE)
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND NumDeclaracion= nNumDeclaracion
      AND IdPoliza      = nIdPoliza 
      AND IDetPol       = nIDetPol 
      AND CodAsegurado  = nCodAsegurado
      AND IdEndoso      = nIdEndoso 
      AND CodCobert     = cCodCobert;
END SUSPENDER;

PROCEDURE ACTUALIZAR_VALORES(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nNumDeclaracion IN NUMBER, nIdPoliza IN NUMBER,
                              nIDetPol IN NUMBER, nCodAsegurado IN NUMBER, nIdEndoso IN NUMBER, cCodCobert IN VARCHAR2) IS
BEGIN
   UPDATE EAD_CONTROL_ASEG_COBERT
      SET MtoSumaAsegLocal    = 0, 
          MtoSumaAsegMoneda   = 0, 
          MtoPrimaLocal       = 0, 
          MtoPrimaMoneda      = 0
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND NumDeclaracion= nNumDeclaracion
      AND IdPoliza      = nIdPoliza 
      AND IDetPol       = nIDetPol 
      AND CodAsegurado  = nCodAsegurado
      AND IdEndoso      = nIdEndoso 
      AND CodCobert     = cCodCobert;
END ACTUALIZAR_VALORES; 

END GT_EAD_CONTROL_ASEG_COBERT;
/

--
-- GT_EAD_CONTROL_ASEG_COBERT  (Synonym) 
--
--  Dependencies: 
--   GT_EAD_CONTROL_ASEG_COBERT (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_EAD_CONTROL_ASEG_COBERT FOR SICAS_OC.GT_EAD_CONTROL_ASEG_COBERT
/


GRANT EXECUTE ON SICAS_OC.GT_EAD_CONTROL_ASEG_COBERT TO PUBLIC
/
