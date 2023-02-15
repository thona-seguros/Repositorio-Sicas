CREATE OR REPLACE PACKAGE          GT_AUTORIZA_PROCESOS_LOG AS
    FUNCTION NUMERO_REVISION(nCodCia IN NUMBER, nIdAutorizacion IN NUMBER) RETURN NUMBER;
    PROCEDURE CREAR(nCodCia IN NUMBER, nIdAutorizacion IN NUMBER, nIdEmpleadoRevisa IN NUMBER, dFechaRevisa IN DATE,
                    cHoraRevisa IN VARCHAR2, nIdEmpleadoSuperior IN NUMBER, cObservaciones IN VARCHAR2);
    FUNCTION EMPLEADO_ULTIMA_REVISION(nCodCia IN NUMBER, nIdAutorizacion IN NUMBER) RETURN NUMBER;
    FUNCTION EMPLEADO_REVISION_ANTERIOR(nCodCia IN NUMBER, nIdAutorizacion IN NUMBER) RETURN NUMBER;
    FUNCTION EXISTE_REVISION(nCodCia IN NUMBER, nIdAutorizacion IN NUMBER) RETURN VARCHAR2;
END GT_AUTORIZA_PROCESOS_LOG;
/

CREATE OR REPLACE PACKAGE BODY          GT_AUTORIZA_PROCESOS_LOG AS
    FUNCTION NUMERO_REVISION(nCodCia IN NUMBER, nIdAutorizacion IN NUMBER) RETURN NUMBER IS
        nIdRevision AUTORIZA_PROCESOS_LOG.IdRevision%TYPE;
    BEGIN
        SELECT NVL(MAX(IdRevision),0) + 1
          INTO nIdRevision
          FROM AUTORIZA_PROCESOS_LOG
         WHERE CodCia         = nCodCia
           AND IdAutorizacion = nIdAutorizacion;
        RETURN nIdRevision;
    END NUMERO_REVISION;
    --
    PROCEDURE CREAR(nCodCia IN NUMBER, nIdAutorizacion IN NUMBER, nIdEmpleadoRevisa IN NUMBER, dFechaRevisa IN DATE,
                    cHoraRevisa IN VARCHAR2, nIdEmpleadoSuperior IN NUMBER, cObservaciones IN VARCHAR2) IS
        nIdRevision AUTORIZA_PROCESOS_LOG.IdRevision%TYPE;
    BEGIN
        nIdRevision := GT_AUTORIZA_PROCESOS_LOG.NUMERO_REVISION(nCodCia, nIdAutorizacion);
        INSERT INTO AUTORIZA_PROCESOS_LOG (CodCia,     IdAutorizacion,     IdRevision,  IdEmpleadoRevisa, FechaRevisa, 
                                           HoraRevisa, IdEmpleadoSuperior, StsRevision, FechaStatus,      Observaciones)
                                   VALUES (nCodCia,    nIdAutorizacion,    nIdRevision, nIdEmpleadoRevisa,dFechaRevisa,
                                           cHoraRevisa,nIdEmpleadoSuperior,'EMITIDA',   TRUNC(SYSDATE),   cObservaciones);
    END CREAR;
    --
    FUNCTION EMPLEADO_ULTIMA_REVISION(nCodCia IN NUMBER, nIdAutorizacion IN NUMBER) RETURN NUMBER IS
        nIdEmpleadoSuperior AUTORIZA_PROCESOS_LOG.IdEmpleadoSuperior%TYPE;
    BEGIN
        BEGIN
           SELECT APL.IdEmpleadoSuperior
             INTO nIdEmpleadoSuperior
             FROM AUTORIZA_PROCESOS_LOG APL,AUTORIZA_PROCESOS AP
            WHERE AP.CodCia          = nCodCia
              AND APL.IdAutorizacion = nIdAutorizacion
              AND APL.IdAutorizacion = AP.IdAutorizacion
              AND APL.IdRevision     = (SELECT NVL(MAX(IdRevision),1)
                                          FROM AUTORIZA_PROCESOS_LOG APL1
                                         WHERE APL1.CodCia         = nCodCia
                                           AND APL1.IdAutorizacion = AP.IdAutorizacion); 
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                SELECT IdEmpleadoRevisa
                  INTO nIdEmpleadoSuperior
                  FROM AUTORIZA_PROCESOS
                 WHERE IdAutorizacion = nIdAutorizacion;
        END;                                                                        
        RETURN nIdEmpleadoSuperior;
    END EMPLEADO_ULTIMA_REVISION;
    --
    FUNCTION EMPLEADO_REVISION_ANTERIOR(nCodCia IN NUMBER, nIdAutorizacion IN NUMBER) RETURN NUMBER IS
      nIdEmpleadoRevisa AUTORIZA_PROCESOS_LOG.IdEmpleadoRevisa%TYPE;
    BEGIN
         BEGIN
           SELECT APL.IdEmpleadoRevisa
             INTO nIdEmpleadoRevisa
             FROM AUTORIZA_PROCESOS_LOG APL,AUTORIZA_PROCESOS AP
            WHERE AP.CodCia          = nCodCia
              AND APL.IdAutorizacion = nIdAutorizacion
              AND APL.IdAutorizacion = AP.IdAutorizacion
              AND APL.IdRevision     = (SELECT NVL(MAX(IdRevision),1)
                                          FROM AUTORIZA_PROCESOS_LOG APL1
                                         WHERE APL1.CodCia         = nCodCia
                                           AND APL1.IdAutorizacion = AP.IdAutorizacion); 
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                SELECT IdEmpleadoRevisa
                  INTO nIdEmpleadoRevisa
                  FROM AUTORIZA_PROCESOS
                 WHERE IdAutorizacion = nIdAutorizacion;
        END;                                                                        
        RETURN nIdEmpleadoRevisa;
    END EMPLEADO_REVISION_ANTERIOR;
    --
    FUNCTION EXISTE_REVISION(nCodCia IN NUMBER, nIdAutorizacion IN NUMBER) RETURN VARCHAR2 IS
        cExisteRevision VARCHAR2(1);
    BEGIN
        BEGIN
            SELECT 'S'
              INTO cExisteRevision
              FROM AUTORIZA_PROCESOS_LOG
             WHERE CodCia          = nCodCia
               AND IdAutorizacion  = nIdAutorizacion;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                cExisteRevision := 'N';
            WHEN TOO_MANY_ROWS THEN
                cExisteRevision := 'S';
        END;
        RETURN cExisteRevision;
    END EXISTE_REVISION;
END GT_AUTORIZA_PROCESOS_LOG;
