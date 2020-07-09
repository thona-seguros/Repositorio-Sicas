--
-- OC_CONFIG_RESERVAS_FACTORSUF  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   CONFIG_RESERVAS_FACTORSUF (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CONFIG_RESERVAS_FACTORSUF IS

FUNCTION FACTOR_SUFICIENCIA(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, 
                            cIdTipoSeg VARCHAR2, dFecValuacion DATE) RETURN NUMBER;

FUNCTION FACTOR_UTILIDAD(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, 
                         cIdTipoSeg VARCHAR2, dFecValuacion DATE) RETURN NUMBER;

FUNCTION FACTOR_GTOSADQ(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, 
                        cIdTipoSeg VARCHAR2, dFecValuacion DATE) RETURN NUMBER;

FUNCTION PORCENTAJE_DEVOLUCION(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, 
                               cIdTipoSeg VARCHAR2, dFecValuacion DATE) RETURN NUMBER;

PROCEDURE COPIAR (nCodCia NUMBER, cCodReservaOrig VARCHAR2, cCodReservaDest VARCHAR2);

PROCEDURE AGREGAR(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER,
                  cIdTipoSegOrig VARCHAR2, cIdTipoSegDest VARCHAR2);

FUNCTION FACTOR_INSUFICIENCIA(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, 
                              cIdTipoSeg VARCHAR2, dFecValuacion DATE) RETURN NUMBER;

END OC_CONFIG_RESERVAS_FACTORSUF;
/

--
-- OC_CONFIG_RESERVAS_FACTORSUF  (Package Body) 
--
--  Dependencies: 
--   OC_CONFIG_RESERVAS_FACTORSUF (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CONFIG_RESERVAS_FACTORSUF IS

FUNCTION FACTOR_SUFICIENCIA(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER,
                            cIdTipoSeg VARCHAR2, dFecValuacion DATE) RETURN NUMBER IS
nFactorSuficiencia   CONFIG_RESERVAS_FACTORSUF.FactorSuficiencia%TYPE;
BEGIN
   BEGIN
      SELECT FactorSuficiencia
        INTO nFactorSuficiencia
        FROM CONFIG_RESERVAS_FACTORSUF
       WHERE CodCia       = nCodCia
         AND CodReserva   = cCodReserva
         AND CodEmpresa   = nCodEmpresa
         AND IdTipoSeg    = cIdTipoSeg
         AND dFecValuacion BETWEEN FecIniVig AND FecFinVig;     
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nFactorSuficiencia := 0;
      WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Configuración de Factor de Suficiencia.  ' ||
                                'Existen varios registros para la Fecha de Valuación  '|| TRIM(TO_CHAR(dFecValuacion,'DD/MM/YYYY')));
   END;
   RETURN(nFactorSuficiencia);
END FACTOR_SUFICIENCIA;


PROCEDURE COPIAR (nCodCia NUMBER, cCodReservaOrig VARCHAR2, cCodReservaDest VARCHAR2) IS
BEGIN
   BEGIN
      INSERT INTO CONFIG_RESERVAS_FACTORSUF
                 (CodCia, CodReserva, CodEmpresa, IdTipoSeg,
                  FecIniVig, FecFinVig, FactorSuficiencia,
                  FactUtilidad, PorcDevolucion)
           SELECT nCodCia, cCodReservaDest, CodEmpresa, IdTipoSeg,
                  FecIniVig, FecFinVig, FactorSuficiencia,
                  FactUtilidad, PorcDevolucion
             FROM CONFIG_RESERVAS_FACTORSUF
            WHERE CodCia     = nCodCia
                                  AND CodReserva = cCodReservaOrig;
   EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Realizar la Copia de CONFIG_RESERVAS_FACTORSUF '|| SQLERRM );
   END;
END COPIAR;

FUNCTION FACTOR_UTILIDAD(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER,
                         cIdTipoSeg VARCHAR2, dFecValuacion DATE) RETURN NUMBER IS
nFactUtilidad   CONFIG_RESERVAS_FACTORSUF.FactUtilidad%TYPE;
BEGIN
   BEGIN
      SELECT FactUtilidad
        INTO nFactUtilidad
        FROM CONFIG_RESERVAS_FACTORSUF
       WHERE CodCia       = nCodCia
         AND CodReserva   = cCodReserva
         AND CodEmpresa   = nCodEmpresa
         AND IdTipoSeg    = cIdTipoSeg
         AND dFecValuacion BETWEEN FecIniVig AND FecFinVig;     
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nFactUtilidad := 0;
      WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Configuración de Factor de Utilidad.  ' ||
                                'Existen varios registros para la Fecha de Valuación  '|| TRIM(TO_CHAR(dFecValuacion,'DD/MM/YYYY')));
   END;
   RETURN(nFactUtilidad);
END FACTOR_UTILIDAD;

FUNCTION FACTOR_GTOSADQ(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER,
                        cIdTipoSeg VARCHAR2, dFecValuacion DATE) RETURN NUMBER IS
nFactGtoAdqui   CONFIG_RESERVAS_FACTORSUF.FactGtoAdqui%TYPE;
BEGIN
   BEGIN
      SELECT FactGtoAdqui
        INTO nFactGtoAdqui
        FROM CONFIG_RESERVAS_FACTORSUF
       WHERE CodCia       = nCodCia
         AND CodReserva   = cCodReserva
         AND CodEmpresa   = nCodEmpresa
         AND IdTipoSeg    = cIdTipoSeg
         AND dFecValuacion BETWEEN FecIniVig AND FecFinVig;     
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nFactGtoAdqui := 0;
      WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Configuración de Factor de Gastos de Adquisición.  ' ||
                                'Existen varios registros para la Fecha de Valuación  '|| TRIM(TO_CHAR(dFecValuacion,'DD/MM/YYYY')));
   END;
   RETURN(nFactGtoAdqui);
END FACTOR_GTOSADQ;

FUNCTION PORCENTAJE_DEVOLUCION(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER,
                               cIdTipoSeg VARCHAR2, dFecValuacion DATE) RETURN NUMBER IS
nPorcDevolucion   CONFIG_RESERVAS_FACTORSUF.PorcDevolucion%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PorcDevolucion,0) / 100
        INTO nPorcDevolucion
        FROM CONFIG_RESERVAS_FACTORSUF
       WHERE CodCia       = nCodCia
         AND CodReserva   = cCodReserva
         AND CodEmpresa   = nCodEmpresa
         AND IdTipoSeg    = cIdTipoSeg
         AND dFecValuacion BETWEEN FecIniVig AND FecFinVig;     
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcDevolucion := 0;
      WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Configuración de Porcentaje de Devolución.  ' ||
                                'Existen varios registros para la Fecha de Valuación  '|| TRIM(TO_CHAR(dFecValuacion,'DD/MM/YYYY')));
   END;
   RETURN(nPorcDevolucion);
END PORCENTAJE_DEVOLUCION;

PROCEDURE AGREGAR(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER,
                  cIdTipoSegOrig VARCHAR2, cIdTipoSegDest VARCHAR2) IS
CURSOR FACTOR_Q IS
   SELECT FecIniVig, FecFinVig, FactorSuficiencia, FactUtilidad, PorcDevolucion
     FROM CONFIG_RESERVAS_FACTORSUF
    WHERE CodCia       = nCodCia
      AND CodReserva   = cCodReserva
      AND CodEmpresa   = nCodEmpresa
      AND IdTipoSeg    = cIdTipoSegOrig;
BEGIN
   FOR X IN FACTOR_Q LOOP
      INSERT INTO CONFIG_RESERVAS_FACTORSUF
             (CodCia, CodReserva, CodEmpresa, IdTipoSeg,
              FecIniVig, FecFinVig, FactorSuficiencia,
              FactUtilidad, PorcDevolucion)
      VALUES (nCodCia, cCodReserva, nCodEmpresa, cIdTipoSegDest,
              X.FecIniVig, X.FecFinVig, X.FactorSuficiencia,
              X.FactUtilidad, X.PorcDevolucion);
   END LOOP;
END AGREGAR;

FUNCTION FACTOR_INSUFICIENCIA(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER,
                            cIdTipoSeg VARCHAR2, dFecValuacion DATE) RETURN NUMBER IS
nFactorInSuficiencia   CONFIG_RESERVAS_FACTORSUF.FactorInSuficiencia%TYPE;
BEGIN
   BEGIN
      SELECT FactorInSuficiencia
        INTO nFactorInSuficiencia
        FROM CONFIG_RESERVAS_FACTORSUF
       WHERE CodCia       = nCodCia
         AND CodReserva   = cCodReserva
         AND CodEmpresa   = nCodEmpresa
         AND IdTipoSeg    = cIdTipoSeg
         AND dFecValuacion BETWEEN FecIniVig AND FecFinVig;     
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nFactorInSuficiencia := 0;
      WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Configuración de Factor de InSuficiencia.  ' ||
                                'Existen varios registros para la Fecha de Valuación  '|| TRIM(TO_CHAR(dFecValuacion,'DD/MM/YYYY')));
   END;
   RETURN(nFactorInSuficiencia);
END FACTOR_INSUFICIENCIA;

END OC_CONFIG_RESERVAS_FACTORSUF;
/

--
-- OC_CONFIG_RESERVAS_FACTORSUF  (Synonym) 
--
--  Dependencies: 
--   OC_CONFIG_RESERVAS_FACTORSUF (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_CONFIG_RESERVAS_FACTORSUF FOR SICAS_OC.OC_CONFIG_RESERVAS_FACTORSUF
/


GRANT EXECUTE ON SICAS_OC.OC_CONFIG_RESERVAS_FACTORSUF TO PUBLIC
/
