create or replace PROCEDURE SICAS_OC.WS_ACTIVA_SINIESTRO (
    p_CodCia         IN NUMBER,          -- Código de la compañía
    p_CodEmpresa     IN NUMBER,          -- Código de la empresa
    p_IdPoliza       IN NUMBER,          -- ID de la póliza
    p_IdetPol        IN NUMBER,          -- ID del detalle de la póliza
    p_IdSiniestro    IN VARCHAR2,        -- ID del siniestro
    p_Mensaje        OUT VARCHAR2        -- Mensaje de salida (éxito o error)
) AS
    Dummy         NUMBER(5);             -- Variable auxiliar
    nRegis        NUMBER(6);             -- Contador de registros
    nDetSini      NUMBER(6);             -- Indicador de detalles de siniestro
    nActiva       VARCHAR2(1);           -- Indicador de activación
    nExaInsp      NUMBER(5);             -- Variable auxiliar para examen de inspección
    cIndExaInsp   VARCHAR2(1);           -- Indicador de examen de inspección
    cObservaciones VARCHAR2(3000);       -- Observaciones para el siniestro
    -- Cursor para obtener detalles del siniestro
    CURSOR DET_SIN_Q IS
       SELECT IdDetSin
         FROM DETALLE_SINIESTRO
        WHERE IdSiniestro = p_IdSiniestro;
    -- Cursor para obtener detalles del siniestro asegurado
    CURSOR DET_SIN_ASEG_Q IS
       SELECT IdDetSin
         FROM DETALLE_SINIESTRO_ASEG
        WHERE IdSiniestro = p_IdSiniestro;
BEGIN
   -- Inicializar variables
   nActiva := 'N';  -- Por defecto, no está activo
   -- Verificar si el siniestro es declarativo y si pertenece a un asegurado
   IF NVL(OC_DETALLE_POLIZA.DECLARATIVA(NVL(p_CodCia, 1), NVL(p_CodEmpresa, 1),
                                        p_IdPoliza, p_IdetPol), 'N') = 'N' AND
      OC_SINIESTRO.SINIESTRO_DE_ASEGURADO(NVL(p_CodCia, 1), p_IdPoliza,
                                          p_IdetPol, p_IdSiniestro) = 'N' THEN 
      -- Recorrer los detalles del siniestro
      FOR X IN DET_SIN_Q LOOP
         -- Contar las coberturas asociadas al siniestro
         SELECT COUNT(*)
           INTO nRegis
           FROM COBERTURA_SINIESTRO
          WHERE IdSiniestro = p_IdSiniestro;
         -- Si no hay coberturas, devolver un error
         IF NVL(nRegis, 0) = 0 THEN
            p_Mensaje := 'Indv Debe grabarle COBERTURAS y Reservas al Siniestro en el Detalle No. ' || TRIM(TO_CHAR(X.IdDetSin));
            RETURN;
         ELSE
            nActiva := 'S';  -- Marcar como activo
         END IF;
         nDetSini := 1;  -- Indicar que hay detalles
      END LOOP;
   ELSE
      -- Recorrer los detalles del siniestro asegurado
      FOR X IN DET_SIN_ASEG_Q LOOP
         -- Contar las coberturas asociadas al siniestro asegurado
         SELECT COUNT(*)
           INTO nRegis
           FROM COBERTURA_SINIESTRO_ASEG
          WHERE IdSiniestro = p_IdSiniestro;
         -- Si no hay coberturas, devolver un error
         IF NVL(nRegis, 0) = 0 THEN
            p_Mensaje := 'Debe grabarle COBERTURAS y Reservas al Siniestro en el Detalle No. ' || TRIM(TO_CHAR(X.IdDetSin));
            RETURN;
         ELSE
            nActiva := 'S';  -- Marcar como activo
         END IF;
         nDetSini := 1;  -- Indicar que hay detalles
      END LOOP;	
   END IF;	
   -- Si no hay detalles de siniestro, devolver un error
   IF NVL(nDetSini, 0) = 0 THEN
      p_Mensaje := 'Colec Debe grabarle Detalles al Siniestro';
      RETURN;
   END IF;
   -- Si el siniestro está listo para activarse
   IF NACTIVA = 'S' THEN
      BEGIN
          -- Activar el siniestro
          OC_SINIESTRO.ACTIVAR(NVL(p_CodCia, 1), NVL(p_CodEmpresa, 1), p_IdSiniestro,
                               p_IdPoliza, p_IdetPol);
          -- Crear observación de activación
          cObservaciones := 'Emite / Activa el Siniestro ' || p_IdSiniestro;
          OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(p_IdSiniestro, p_IdPoliza, cObservaciones);
          -- Confirmar la transacción
          COMMIT;
          p_Mensaje := 'Siniestro activado correctamente.';
      EXCEPTION
          -- Manejar errores durante la activación
          WHEN OTHERS THEN
              p_Mensaje := 'Error al activar el siniestro: ' || SQLERRM;
              ROLLBACK;
      END;
   END IF;
END WS_ACTIVA_SINIESTRO;
/

CREATE OR REPLACE PUBLIC SYNONYM WS_ACTIVA_SINIESTRO FOR SICAS_OC.WS_ACTIVA_SINIESTRO
/

GRANT EXECUTE ON SICAS_OC.WS_ACTIVA_SINIESTRO TO PUBLIC
/