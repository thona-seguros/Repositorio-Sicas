--
-- OC_DETALLE_TRANSACCION  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   DETALLE_TRANSACCION (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_DETALLE_TRANSACCION IS

PROCEDURE CREA (nIdTransac NUMBER, nCodCia NUMBER,nCodEmp NUMBER, nIdPro NUMBER,cCodSubPro VARCHAR2, cObjeto VARCHAR2,
                cValor1 VARCHAR2, cValor2 VARCHAR2, cValor3 VARCHAR2, cValor4 VARCHAR2, nMtoLocal NUMBER);

PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdTransaccion NUMBER);

END;
/

--
-- OC_DETALLE_TRANSACCION  (Package Body) 
--
--  Dependencies: 
--   OC_DETALLE_TRANSACCION (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_DETALLE_TRANSACCION IS

PROCEDURE CREA (nIdTransac NUMBER, nCodCia NUMBER,nCodEmp NUMBER, nIdPro NUMBER, cCodSubPro VARCHAR2, cObjeto VARCHAR2,
            cValor1 VARCHAR2, cValor2 VARCHAR2,cValor3 VARCHAR2, cValor4 VARCHAR2, nMtoLocal NUMBER) IS
nCorr NUMBER(10);
BEGIN
   SELECT NVL(MAX(correlativo),0)+1
     INTO nCorr
     FROM DETALLE_TRANSACCION
    WHERE IdTransaccion = nIdTransac
      AND CodCia        = nCodCia
      AND CodEmpresa    = nCodEmp ;

  BEGIN
   INSERT INTO DETALLE_TRANSACCION
          (IdTransaccion, CodCia, CodEmpresa, Correlativo, CodSubProceso, Objeto, 
           Valor1, Valor2, Valor3, Valor4, MtoLocal)
   VALUES (nIdTransac, nCodCia, nCodEmp, nCorr,cCodSubPro, cObjeto,
           cValor1, cValor2, cValor3, cValor4, nMtoLocal);
  EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20225,'Others Error al insertar Detalle Transaccion: '||SQLERRM);
  END;
           
END;

PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdTransaccion NUMBER) IS
BEGIN
   DELETE DETALLE_TRANSACCION
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdTransaccion = nIdTransaccion;
END ELIMINAR;

END OC_DETALLE_TRANSACCION;
/

--
-- OC_DETALLE_TRANSACCION  (Synonym) 
--
--  Dependencies: 
--   OC_DETALLE_TRANSACCION (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_DETALLE_TRANSACCION FOR SICAS_OC.OC_DETALLE_TRANSACCION
/


GRANT EXECUTE ON SICAS_OC.OC_DETALLE_TRANSACCION TO PUBLIC
/
