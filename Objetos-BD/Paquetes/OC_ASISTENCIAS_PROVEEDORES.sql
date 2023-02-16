CREATE OR REPLACE PACKAGE OC_ASISTENCIAS_PROVEEDORES IS

  PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodAsistencia VARCHAR2, nCodProvServicio NUMBER);
  PROCEDURE SUSPENDER(nCodCia NUMBER, nCodEmpresa NUMBER, cCodAsistencia VARCHAR2, nCodProvServicio NUMBER);
  FUNCTION PORCENTAJE_COBRO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodAsistencia VARCHAR2, nCodProvServicio NUMBER) RETURN NUMBER;
  PROCEDURE FIN_SERVICIO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodAsistencia VARCHAR2, 
                         nCodProvServicio NUMBER, dFecFinServicio DATE, cCodMotivFinServ VARCHAR2);

END OC_ASISTENCIAS_PROVEEDORES;
/

CREATE OR REPLACE PACKAGE BODY OC_ASISTENCIAS_PROVEEDORES IS

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodAsistencia VARCHAR2, nCodProvServicio NUMBER) IS
BEGIN
   UPDATE ASISTENCIAS_PROVEEDORES
      SET StsProvServicio  = 'ACTIVO',
          FecSts           = TRUNC(SYSDATE),
          CodUsuario       = USER,
          FecFinServicio   = NULL,
          CodMotivFinServ  = NULL
   WHERE CodCia          = nCodCia
     AND CodEmpresa      = nCodEmpresa
     AND CodAsistencia   = cCodAsistencia
     AND CodProvServicio = nCodProvServicio;
END ACTIVAR;

PROCEDURE SUSPENDER(nCodCia NUMBER, nCodEmpresa NUMBER, cCodAsistencia VARCHAR2, nCodProvServicio NUMBER) IS
BEGIN
   UPDATE ASISTENCIAS_PROVEEDORES
      SET StsProvServicio = 'SUSPEN',
          FecSts          = TRUNC(SYSDATE),
          CodUsuario      = USER
   WHERE CodCia          = nCodCia
     AND CodEmpresa      = nCodEmpresa
     AND CodAsistencia   = cCodAsistencia
     AND CodProvServicio = nCodProvServicio;
END SUSPENDER;

FUNCTION PORCENTAJE_COBRO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodAsistencia VARCHAR2, nCodProvServicio NUMBER) RETURN NUMBER IS
nPorcenCobro   ASISTENCIAS_PROVEEDORES.PorcenCobro%TYPE;
BEGIN
   BEGIN
      SELECT PorcenCobro
        INTO nPorcenCobro
        FROM ASISTENCIAS_PROVEEDORES
       WHERE CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND CodAsistencia   = cCodAsistencia
         AND CodProvServicio = nCodProvServicio;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcenCobro := 0;
   END;
   RETURN(nPorcenCobro);
END PORCENTAJE_COBRO;

PROCEDURE FIN_SERVICIO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodAsistencia VARCHAR2, 
                       nCodProvServicio NUMBER, dFecFinServicio DATE, cCodMotivFinServ VARCHAR2) IS
BEGIN
   UPDATE ASISTENCIAS_PROVEEDORES
      SET FecFinServicio   = dFecFinServicio,
          CodMotivFinServ  = cCodMotivFinServ,
          StsProvServicio  = 'FINSER',
          FecSts           = TRUNC(SYSDATE),
          CodUsuario       = USER
    WHERE CodCia          = nCodCia
      AND CodEmpresa      = nCodEmpresa
      AND CodAsistencia   = cCodAsistencia
      AND CodProvServicio = nCodProvServicio;
END FIN_SERVICIO;

END OC_ASISTENCIAS_PROVEEDORES;
