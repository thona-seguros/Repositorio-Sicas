create or replace PROCEDURE SICAS_OC.WS_MODIFICA_DATOS_BANCARIOS (
    P_BENEF              IN NUMBER,
    P_IDSINIESTRO        IN NUMBER,
    P_IDPOLIZA           IN NUMBER,
    P_COD_ASEGURADO      IN NUMBER,
    P_NUM_CUENTA_BANCARIA IN VARCHAR2,
    P_CUENTA_CLAVE       IN VARCHAR2,
    P_ENT_FINANCIERA     IN VARCHAR2,
    P_MENSAJE            OUT VARCHAR2
) AS
BEGIN
    -- Validación de parámetros
    IF P_BENEF IS NULL THEN
        P_MENSAJE := 'El parámetro BENEF es obligatorio.';
        RAISE_APPLICATION_ERROR(-20001, P_MENSAJE);
    END IF;
    IF P_IDSINIESTRO IS NULL THEN
        P_MENSAJE := 'El IDSINIESTRO es obligatorio.';
        RAISE_APPLICATION_ERROR(-20002, P_MENSAJE);
    END IF;
    IF P_IDPOLIZA IS NULL THEN
        P_MENSAJE := 'El ID de la póliza es obligatorio.';
        RAISE_APPLICATION_ERROR(-20003, P_MENSAJE);
    END IF;
    IF P_COD_ASEGURADO IS NULL THEN
        P_MENSAJE := 'El código del asegurado es obligatorio.';
        RAISE_APPLICATION_ERROR(-20004, P_MENSAJE);
    END IF;
    -- Actualizar en la tabla BENEF_SIN 
    UPDATE BENEF_SIN
    SET 
        Ent_Financiera = COALESCE(P_ENT_FINANCIERA, Ent_Financiera),
        NumCuentaBancaria = COALESCE(P_NUM_CUENTA_BANCARIA, NumCuentaBancaria),
        Cuenta_Clave = COALESCE(P_CUENTA_CLAVE, Cuenta_Clave)
    WHERE IDSINIESTRO = P_IDSINIESTRO
      AND IDPOLIZA = P_IDPOLIZA
      AND COD_ASEGURADO = P_COD_ASEGURADO
      AND BENEF = P_BENEF;
    -- Confirmación del éxito de la operación
    COMMIT;
    P_MENSAJE := 'Información financiera actualizada correctamente.';
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        P_MENSAJE := 'Error al actualizar la información financiera: ' || SQLERRM;
        RAISE_APPLICATION_ERROR(-20005, P_MENSAJE);
END WS_MODIFICA_DATOS_BANCARIOS;
/

CREATE OR REPLACE PUBLIC SYNONYM WS_MODIFICA_DATOS_BANCARIOS FOR SICAS_OC.WS_MODIFICA_DATOS_BANCARIOS
/

GRANT EXECUTE ON SICAS_OC.WS_MODIFICA_DATOS_BANCARIOS TO PUBLIC
/