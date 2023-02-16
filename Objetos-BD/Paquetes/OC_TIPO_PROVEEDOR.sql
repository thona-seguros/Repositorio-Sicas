CREATE OR REPLACE PACKAGE OC_TIPO_PROVEEDOR IS
   PROCEDURE ESTADO(cCodCia NUMBER, cCodTipoProv VARCHAR2, cEstado VARCHAR2);

   FUNCTION DESCRIPCION(cCodCia NUMBER, cCodTipoProv VARCHAR2) RETURN VARCHAR2;

   FUNCTION TIPO_PROV_ACTIVO(cCodCia NUMBER, cCodTipoProv VARCHAR2) RETURN VARCHAR2;
END;
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_TIPO_PROVEEDOR IS

PROCEDURE ESTADO(cCodCia NUMBER, cCodTipoProv VARCHAR2, cEstado VARCHAR2) IS
BEGIN
   IF NVL(cEstado,'X') IN ('ACTIVA','SUSPEN') THEN
      BEGIN
         UPDATE TIPO_PROVEEDOR
            SET Estado      = cEstado,
                FecSts      = TRUNC(SYSDATE)
          WHERE CodCia      = cCodCia
            AND CodTipoProv = cCodTipoProv;
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20100, 'Error al Intentar Actualizar TIPO_PROVEEDOR');
      END;
   END IF;
END ESTADO;

FUNCTION DESCRIPCION(cCodCia NUMBER, cCodTipoProv VARCHAR2) RETURN VARCHAR2 IS
cDescTipoProv   TIPO_PROVEEDOR.DescTipoProv%TYPE;
BEGIN
   BEGIN
      SELECT DescTipoProv
        INTO cDescTipoProv
        FROM TIPO_PROVEEDOR
       WHERE CodCia      = cCodCia
         AND CodTipoProv = cCodTipoProv;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescTipoProv := 'INVALIDO';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100, 'Inconsistencias en la Recuperacion de Registros en TIPO_PROVEEDOR');
   END;
   RETURN(cDescTipoProv);
END DESCRIPCION;

FUNCTION TIPO_PROV_ACTIVO(cCodCia NUMBER, cCodTipoProv VARCHAR2) RETURN VARCHAR2 IS
cActivo     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cActivo
        FROM TIPO_PROVEEDOR
       WHERE CodCia      = cCodCia
         AND CodTipoProv = cCodTipoProv
         AND Estado      = 'ACTIVA';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cActivo := 'N';
      WHEN TOO_MANY_ROWS THEN
         cActivo := 'S';
   END;
   RETURN(cActivo);
END TIPO_PROV_ACTIVO;

END OC_TIPO_PROVEEDOR;
