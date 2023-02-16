CREATE OR REPLACE PACKAGE OC_TIPO_AGENTE IS

PROCEDURE ESTADO(cCodCia NUMBER, cCodTipo VARCHAR2, cEstado VARCHAR2);
FUNCTION DESCRIPCION(cCodCia NUMBER, cCodTipo VARCHAR2) RETURN VARCHAR2;

END; 
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_TIPO_AGENTE IS

PROCEDURE ESTADO(cCodCia NUMBER, cCodTipo VARCHAR2, cEstado VARCHAR2) IS
BEGIN
   IF NVL(cEstado, 'X') IN ('ACTIVA','SUSPEN') THEN
      BEGIN
         UPDATE TIPO_AGENTE
            SET Estado      = cEstado,
                FechaEstado = TRUNC(SYSDATE)
          WHERE CodCia  = cCodCia
            AND CodTipo = cCodTipo;
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20100, 'Error al Intentar Actualizar TIPO_AGENTE');
      END;
   END IF;
END ESTADO;

FUNCTION DESCRIPCION(cCodCia NUMBER, cCodTipo VARCHAR2) RETURN VARCHAR2 IS
cDescripcion   TIPO_AGENTE.Descripcion%TYPE;
BEGIN
   BEGIN
      SELECT Descripcion
        INTO cDescripcion
        FROM TIPO_AGENTE
       WHERE CodCia = cCodCia
         AND CodTipo = cCodTipo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescripcion := 'INVALIDO';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100, 'Inconsistencias en la Recuperacion de Registros en TIPO_AGENTE');
   END;
   RETURN(cDescripcion);
END DESCRIPCION;

end oc_tipo_agente;
