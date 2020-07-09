--
-- OC_PROCESO_AUTORIZA_USUARIO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   PROCESO_AUTORIZA_USUARIO (Table)
--   OC_PROCESO_AUTORIZACION (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_PROCESO_AUTORIZA_USUARIO IS

FUNCTION PROCESO_AUTORIZADO(nCodCia NUMBER, cCodProceso VARCHAR2, cCodUsuario VARCHAR2, 
                            cIdTipoSeg VARCHAR2, nMontoProceso NUMBER) RETURN VARCHAR2;

PROCEDURE COPIAR(nCodCia NUMBER, cCodUsuarioOrigen VARCHAR2, cCodUsuarioDestino VARCHAR2);

PROCEDURE ELIMINAR(nCodCia NUMBER, cCodUsuario VARCHAR2);

END OC_PROCESO_AUTORIZA_USUARIO;
/

--
-- OC_PROCESO_AUTORIZA_USUARIO  (Package Body) 
--
--  Dependencies: 
--   OC_PROCESO_AUTORIZA_USUARIO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_PROCESO_AUTORIZA_USUARIO IS
FUNCTION PROCESO_AUTORIZADO(nCodCia NUMBER, cCodProceso VARCHAR2, cCodUsuario VARCHAR2, 
                            cIdTipoSeg VARCHAR2, nMontoProceso NUMBER) RETURN VARCHAR2 IS
cAutorizado         VARCHAR2(1);

BEGIN
    IF OC_PROCESO_AUTORIZACION.MANEJA_TIPO_SEGURO(nCodCia, cCodProceso) = 'S' THEN 
        BEGIN
           SELECT 'S'
             INTO cAutorizado
             FROM PROCESO_AUTORIZA_USUARIO
            WHERE CodCia               = nCodCia
              AND CodProceso           = cCodProceso
              AND IdTipoSeg            = cIdTipoSeg
              AND CodUsuario           = cCodUsuario
              AND MtoMinimoAutorizado <= nMontoProceso
              AND MtoMaximoAutorizado >= nMontoProceso;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 cAutorizado := 'N';
           WHEN TOO_MANY_ROWS THEN
              RAISE_APPLICATION_ERROR(-20225,'Error en Configuración del Usuario ' || cCodUsuario || ' para el Proceso ' || cCodProceso ||
                                      '-' || OC_PROCESO_AUTORIZACION.DESCRIPCION_PROCESO(nCodCia, cCodProceso) || ' en el Tipo de Seguro ' ||
                                      cIdTipoSeg || '. Existen Varios Registros.');
        END;
    ELSE
        BEGIN
           SELECT 'S'
             INTO cAutorizado
             FROM PROCESO_AUTORIZA_USUARIO
            WHERE CodCia               = nCodCia
              AND CodProceso           = cCodProceso
              AND CodUsuario           = cCodUsuario
              AND MtoMinimoAutorizado <= nMontoProceso
              AND MtoMaximoAutorizado >= nMontoProceso;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              cAutorizado := 'N';
           WHEN TOO_MANY_ROWS THEN
              RAISE_APPLICATION_ERROR(-20225,'Error en Configuración del Usuario ' || cCodUsuario || ' NO está Autorizado para el Proceso ' || cCodProceso ||
                                      '-' || OC_PROCESO_AUTORIZACION.DESCRIPCION_PROCESO(nCodCia, cCodProceso) ||
                                      '.  Existen Varios Registros');
        END;
    END IF;
   
   RETURN(cAutorizado);
END PROCESO_AUTORIZADO;

PROCEDURE COPIAR(nCodCia NUMBER, cCodUsuarioOrigen VARCHAR2, cCodUsuarioDestino VARCHAR2) IS
CURSOR PROC_Q IS
   SELECT CodCia, CodProceso, IdTipoSeg,
          MtoMinimoAutorizado, MtoMaximoAutorizado
     FROM PROCESO_AUTORIZA_USUARIO
    WHERE CodCia               = nCodCia
      AND CodUsuario           = cCodUsuarioOrigen;
BEGIN
   FOR W IN PROC_Q LOOP
      BEGIN
         INSERT INTO PROCESO_AUTORIZA_USUARIO
                (CodCia, CodProceso, CodUsuario, IdTipoSeg,
                 MtoMinimoAutorizado, MtoMaximoAutorizado)
         VALUES (W.CodCia, W.CodProceso, cCodUsuarioDestino, W.IdTipoSeg,
                 W.MtoMinimoAutorizado, W.MtoMaximoAutorizado);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            UPDATE PROCESO_AUTORIZA_USUARIO
               SET MtoMinimoAutorizado = W.MtoMinimoAutorizado,
                   MtoMaximoAutorizado = W.MtoMaximoAutorizado
             WHERE CodCia               = nCodCia
               AND CodProceso           = W.CodProceso
               AND IdTipoSeg            = W.IdTipoSeg
               AND CodUsuario           = cCodUsuarioDestino;
      END;
   END LOOP;
END COPIAR;

PROCEDURE ELIMINAR(nCodCia NUMBER, cCodUsuario VARCHAR2) IS
BEGIN
   DELETE PROCESO_AUTORIZA_USUARIO
    WHERE CodCia               = nCodCia
      AND CodUsuario           = cCodUsuario;
END ELIMINAR;

END OC_PROCESO_AUTORIZA_USUARIO;
/

--
-- OC_PROCESO_AUTORIZA_USUARIO  (Synonym) 
--
--  Dependencies: 
--   OC_PROCESO_AUTORIZA_USUARIO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_PROCESO_AUTORIZA_USUARIO FOR SICAS_OC.OC_PROCESO_AUTORIZA_USUARIO
/


GRANT EXECUTE ON SICAS_OC.OC_PROCESO_AUTORIZA_USUARIO TO PUBLIC
/
