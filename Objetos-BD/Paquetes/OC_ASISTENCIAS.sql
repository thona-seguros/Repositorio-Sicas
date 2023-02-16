CREATE OR REPLACE PACKAGE OC_ASISTENCIAS IS

  FUNCTION DESCRIPCION_ASISTENCIA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodAsistencia VARCHAR2) RETURN VARCHAR2;
  PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodAsistencia VARCHAR2);
  PROCEDURE SUSPENDER(nCodCia NUMBER, nCodEmpresa NUMBER, cCodAsistencia VARCHAR2);
  FUNCTION TIPO_CALCULO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodAsistencia VARCHAR2) RETURN VARCHAR2;
  FUNCTION COSTO_ASISTENCIA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodAsistencia VARCHAR2) RETURN NUMBER;
  FUNCTION REPORTE_ASISTENCIA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodAsistencia VARCHAR2) RETURN VARCHAR2;
  FUNCTION CALCULA_ASISTENCIA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodAsistencia VARCHAR2,
                              dFecInicio DATE, dFecFinal DATE) RETURN NUMBER;

END OC_ASISTENCIAS;
/

CREATE OR REPLACE PACKAGE BODY OC_ASISTENCIAS IS

FUNCTION DESCRIPCION_ASISTENCIA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodAsistencia VARCHAR2) RETURN VARCHAR2 IS
cDescripAsistencia   ASISTENCIAS.DescripAsistencia%TYPE;
BEGIN
   BEGIN
      SELECT DescripAsistencia 
        INTO cDescripAsistencia
        FROM ASISTENCIAS
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND CodAsistencia = cCodAsistencia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescripAsistencia := 'ASISTENCIA NO EXISTE';
   END;
   RETURN(cDescripAsistencia);
END DESCRIPCION_ASISTENCIA;

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodAsistencia VARCHAR2) IS
BEGIN
   UPDATE ASISTENCIAS
      SET StsAsistencia   = 'ACTIVA',
          FecSts          = TRUNC(SYSDATE),
          CodUsuario      = USER
   WHERE CodCia        = nCodCia
     AND CodEmpresa    = nCodEmpresa
     AND CodAsistencia = cCodAsistencia;
END ACTIVAR;

PROCEDURE SUSPENDER(nCodCia NUMBER, nCodEmpresa NUMBER, cCodAsistencia VARCHAR2) IS
BEGIN
   UPDATE ASISTENCIAS
      SET StsAsistencia   = 'SUSPEN',
          FecSts          = TRUNC(SYSDATE),
          CodUsuario      = USER
   WHERE CodCia        = nCodCia
     AND CodEmpresa    = nCodEmpresa
     AND CodAsistencia = cCodAsistencia;
END SUSPENDER;

FUNCTION TIPO_CALCULO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodAsistencia VARCHAR2) RETURN VARCHAR2 IS
cTipoCalculoAsist   ASISTENCIAS.TipoCalculoAsist%TYPE;
BEGIN
   BEGIN
      SELECT TipoCalculoAsist
        INTO cTipoCalculoAsist
        FROM ASISTENCIAS
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND CodAsistencia = cCodAsistencia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTipoCalculoAsist := NULL;
   END;
   RETURN(cTipoCalculoAsist);
END TIPO_CALCULO;

FUNCTION COSTO_ASISTENCIA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodAsistencia VARCHAR2) RETURN NUMBER IS
nCostoAsistencia   ASISTENCIAS.CostoAsistencia%TYPE;
BEGIN
   BEGIN
      SELECT CostoAsistencia
        INTO nCostoAsistencia
        FROM ASISTENCIAS
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND CodAsistencia = cCodAsistencia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nCostoAsistencia := 0;
   END;
   RETURN(nCostoAsistencia);
END COSTO_ASISTENCIA;

FUNCTION REPORTE_ASISTENCIA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodAsistencia VARCHAR2) RETURN VARCHAR2 IS
cNomReporteAsist   ASISTENCIAS.NomReporteAsist%TYPE;
BEGIN
   BEGIN
      SELECT NomReporteAsist
        INTO cNomReporteAsist
        FROM ASISTENCIAS
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND CodAsistencia = cCodAsistencia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNomReporteAsist := NULL;
   END;
   RETURN(cNomReporteAsist);
END REPORTE_ASISTENCIA;

FUNCTION CALCULA_ASISTENCIA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodAsistencia VARCHAR2,
                            dFecInicio DATE, dFecFinal DATE) RETURN NUMBER IS
nTotalAsist          ASISTENCIAS.CostoAsistencia%TYPE;
BEGIN
   IF OC_ASISTENCIAS.TIPO_CALCULO(nCodCia, nCodEmpresa, cCodAsistencia) = 'DIARIO' THEN
      nTotalAsist := (dFecFinal - dFecInicio) *
                     OC_ASISTENCIAS.COSTO_ASISTENCIA(nCodCia, nCodEmpresa, cCodAsistencia);
   ELSE
      nTotalAsist := OC_ASISTENCIAS.COSTO_ASISTENCIA(nCodCia, nCodEmpresa, cCodAsistencia);
   END IF;
   RETURN(nTotalAsist);
END CALCULA_ASISTENCIA;

END OC_ASISTENCIAS;
