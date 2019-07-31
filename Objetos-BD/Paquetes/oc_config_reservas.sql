--
-- OC_CONFIG_RESERVAS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   OC_CONFIG_RESERVAS_CONTAB (Package)
--   OC_CONFIG_RESERVAS_FACTORSUF (Package)
--   OC_CONFIG_RESERVAS_FACTOR_EDAD (Package)
--   OC_CONFIG_RESERVAS_PLANCOB (Package)
--   OC_CONFIG_RESERVAS_PLANCOB_GTO (Package)
--   OC_CONFIG_RESERVAS_PLAN_IBNR (Package)
--   OC_CONFIG_RESERVAS_TARIFAS (Package)
--   OC_CONFIG_RESERVAS_TIPOSEG (Package)
--   CONFIG_RESERVAS (Table)
--   CONFIG_RESERVAS_TIPOSEG (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CONFIG_RESERVAS IS

  FUNCTION NOMBRE_RESERVA(nCodCia NUMBER, cCodReserva VARCHAR2) RETURN VARCHAR2;
  PROCEDURE CONFIGURAR (nCodCia NUMBER, cCodReserva VARCHAR2);
  PROCEDURE ACTIVAR (nCodCia NUMBER, cCodReserva VARCHAR2);
  PROCEDURE SUSPENDER (nCodCia NUMBER, cCodReserva VARCHAR2);
  PROCEDURE COPIAR (nCodCia NUMBER, cCodReservaOrig VARCHAR2, cCodReservaDest VARCHAR2,
                    cDescReserva VARCHAR2);
  FUNCTION INDICADORES(nCodCia NUMBER, cCodReserva VARCHAR2, cTipo VARCHAR2) RETURN VARCHAR2;
  FUNCTION TRIMESTRES(nCodCia NUMBER, cCodReserva VARCHAR2) RETURN NUMBER;

END OC_CONFIG_RESERVAS;
/

--
-- OC_CONFIG_RESERVAS  (Package Body) 
--
--  Dependencies: 
--   OC_CONFIG_RESERVAS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CONFIG_RESERVAS IS

FUNCTION NOMBRE_RESERVA(nCodCia NUMBER, cCodReserva VARCHAR2) RETURN VARCHAR2 IS
cDescReserva    CONFIG_RESERVAS.DescReserva%TYPE;
BEGIN
   BEGIN
      SELECT DescReserva
        INTO cDescReserva
        FROM CONFIG_RESERVAS
       WHERE CodCia     = nCodCia
         AND CodReserva = cCodReserva;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescReserva := 'NO EXISTE';
   END;
   RETURN(cDescReserva);
END NOMBRE_RESERVA;

PROCEDURE CONFIGURAR (nCodCia NUMBER, cCodReserva VARCHAR2) IS
CURSOR TIPOSEG_Q IS
   SELECT CodEmpresa, IdTipoSeg
     FROM CONFIG_RESERVAS_TIPOSEG
    WHERE CodCia        = nCodCia
           AND CodReserva    = cCodReserva
      AND StsTipoSegRva = 'ACT';
BEGIN
   FOR X IN TIPOSEG_Q LOOP
      OC_CONFIG_RESERVAS_TIPOSEG.CONFIGURAR(nCodCia, cCodReserva, X.CodEmpresa, X.IdTipoSeg);
   END LOOP;

   UPDATE CONFIG_RESERVAS
           SET StsReserva = 'CFG'
         WHERE CodCia     = nCodCia
           AND CodReserva = cCodReserva;
END CONFIGURAR;

PROCEDURE SUSPENDER (nCodCia NUMBER, cCodReserva VARCHAR2) IS
CURSOR TIPOSEG_Q IS
   SELECT CodEmpresa, IdTipoSeg
     FROM CONFIG_RESERVAS_TIPOSEG
    WHERE CodCia        = nCodCia
           AND CodReserva    = cCodReserva
      AND StsTipoSegRva = 'ACT';
BEGIN
   FOR X IN TIPOSEG_Q LOOP
      OC_CONFIG_RESERVAS_TIPOSEG.SUSPENDER(nCodCia, cCodReserva, X.CodEmpresa, X.IdTipoSeg);
   END LOOP;

   UPDATE CONFIG_RESERVAS
           SET StsReserva = 'SUS'
         WHERE CodCia     = nCodCia
           AND CodReserva = cCodReserva;
END SUSPENDER;

PROCEDURE ACTIVAR (nCodCia NUMBER, cCodReserva VARCHAR2) IS
cStsReserva     CONFIG_RESERVAS.StsReserva%TYPE;
cStsTipoSeg     CONFIG_RESERVAS.StsReserva%TYPE;
CURSOR TIPOSEG_Q IS
   SELECT CodEmpresa, IdTipoSeg
     FROM CONFIG_RESERVAS_TIPOSEG
    WHERE CodCia        = nCodCia
           AND CodReserva    = cCodReserva
      AND StsTipoSegRva = cStsTipoSeg;
BEGIN
   BEGIN
      SELECT StsReserva
        INTO cStsReserva
        FROM CONFIG_RESERVAS
       WHERE CodCia     = nCodCia
              AND CodReserva = cCodReserva;
   END;
   IF cStsReserva = 'CFG' THEN
      cStsTipoSeg := 'CFG';
      FOR X IN TIPOSEG_Q LOOP
         OC_CONFIG_RESERVAS_TIPOSEG.ACTIVAR(nCodCia, cCodReserva, X.CodEmpresa, X.IdTipoSeg);
      END LOOP;
   ELSIF cStsReserva = 'SUS' THEN
      cStsTipoSeg := 'SUS';
      FOR X IN TIPOSEG_Q LOOP
         OC_CONFIG_RESERVAS_TIPOSEG.ACTIVAR(nCodCia, cCodReserva, X.CodEmpresa, X.IdTipoSeg);
      END LOOP;
   END IF;
   UPDATE CONFIG_RESERVAS
           SET StsReserva = 'ACT'
         WHERE CodCia     = nCodCia
           AND CodReserva = cCodReserva;
END ACTIVAR;

PROCEDURE COPIAR (nCodCia NUMBER, cCodReservaOrig VARCHAR2, 
                  cCodReservaDest VARCHAR2, cDescReserva VARCHAR2 ) IS
BEGIN
   BEGIN
      INSERT INTO CONFIG_RESERVAS
                 (CodCia, CodReserva, DescReserva, StsReserva, FecSts, Periodicidad, 
                  ParamFactorRva, IndConfigGastos, IndReservasTemp,
                  IndRvaMinima, TabMortalidad, IntConmutados, CodUsuarioConfig,
                                                FecConfig, IndFactorEdad, IndAccyEnf, IndIBNRGAAS, CantTrimestres,
                                                IndRvaVidaInd)
           SELECT nCodCia, cCodReservaDest, cDescReserva, 'CFG', SYSDATE,
                  Periodicidad, ParamFactorRva,IndConfigGastos, IndReservasTemp,
                  IndRvaMinima, TabMortalidad, IntConmutados, USER, 
                                                SYSDATE, IndFactorEdad, IndAccyEnf, IndIBNRGAAS, CantTrimestres,
                                                IndRvaVidaInd
             FROM CONFIG_RESERVAS
            WHERE CodCia     = nCodCia
              AND CodReserva = cCodReservaOrig;
   EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Realizar la Copia CONFIG_RESERVAS,  '|| SQLERRM);
   END;
   BEGIN
      OC_CONFIG_RESERVAS_TIPOSEG.COPIAR (nCodCia, cCodReservaOrig , cCodReservaDest);
      OC_CONFIG_RESERVAS_PLANCOB.COPIAR(nCodCia, cCodReservaOrig, cCodReservaDest);
      OC_CONFIG_RESERVAS_PLANCOB_GTO.COPIAR(nCodCia, cCodReservaOrig , cCodReservaDest);
      OC_CONFIG_RESERVAS_TARIFAS.COPIAR(nCodCia, cCodReservaOrig , cCodReservaDest);
      OC_CONFIG_RESERVAS_FACTOR_EDAD.COPIAR(nCodCia, cCodReservaOrig, cCodReservaDest);
      OC_CONFIG_RESERVAS_CONTAB.COPIAR(nCodCia, cCodReservaOrig, cCodReservaDest);
      OC_CONFIG_RESERVAS_FACTORSUF.COPIAR(nCodCia, cCodReservaOrig, cCodReservaDest);
      OC_CONFIG_RESERVAS_PLAN_IBNR.COPIAR(nCodCia, cCodReservaOrig, cCodReservaDest);
   END;
END COPIAR;

FUNCTION INDICADORES(nCodCia NUMBER, cCodReserva VARCHAR2, cTipo VARCHAR2) RETURN VARCHAR2 IS
cIndConfigGastos         CONFIG_RESERVAS.IndConfigGastos%TYPE;
cIndReservasTemp         CONFIG_RESERVAS.IndReservasTemp%TYPE;
cIndRvaMinima            CONFIG_RESERVAS.IndRvaMinima%TYPE;
cIndAccyEnf              CONFIG_RESERVAS.IndAccyEnf%TYPE;
cIndFactorEdad           CONFIG_RESERVAS.IndFactorEdad%TYPE;
cIndIBNRGAAS             CONFIG_RESERVAS.IndIBNRGAAS%TYPE;
cIndRvaVidaInd           CONFIG_RESERVAS.IndRvaVidaInd%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndConfigGastos,'N'), NVL(IndReservasTemp,'N'), NVL(IndRvaMinima,'N'),
             NVL(IndAccyEnf,'N'), NVL(IndFactorEdad,'N'), NVL(IndIBNRGAAS,'N'),
             NVL(IndRvaVidaInd,'N')
        INTO cIndConfigGastos, cIndReservasTemp, cIndRvaMinima,
             cIndAccyEnf, cIndFactorEdad, cIndIBNRGAAS, cIndRvaVidaInd
        FROM CONFIG_RESERVAS
       WHERE CodCia      = nCodCia
         AND CodReserva  = cCodReserva;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndConfigGastos  := 'N';
         cIndReservasTemp  := 'N';
         cIndRvaMinima     := 'N';
         cIndAccyEnf       := 'N';
         cIndFactorEdad    := 'N';
         cIndIBNRGAAS      := 'N';
         cIndRvaVidaInd    := 'N';
   END;
   IF cTipo = 'CG' THEN
      RETURN(cIndConfigGastos);
   ELSIF cTipo = 'RT' THEN
      RETURN(cIndReservasTemp);
   ELSIF cTipo = 'RM' THEN
      RETURN(cIndRvaMinima);
   ELSIF cTipo = 'AE' THEN
      RETURN(cIndAccyEnf);
   ELSIF cTipo = 'FE' THEN
      RETURN(cIndFactorEdad);
   ELSIF cTipo = 'IB' THEN
      RETURN(cIndIBNRGAAS);
   ELSIF cTipo = 'VI' THEN
      RETURN(cIndRvaVidaInd);
   ELSE
      RETURN(0);
   END IF;
END INDICADORES;

FUNCTION TRIMESTRES(nCodCia NUMBER, cCodReserva VARCHAR2) RETURN NUMBER IS
nCantTrimestres   CONFIG_RESERVAS.CantTrimestres%TYPE;
BEGIN
   BEGIN
      SELECT NVL(CantTrimestres,0)
        INTO nCantTrimestres
        FROM CONFIG_RESERVAS
       WHERE CodCia      = nCodCia
         AND CodReserva  = cCodReserva;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nCantTrimestres  := 0;
   END;
   RETURN(nCantTrimestres);
END TRIMESTRES;
  
END OC_CONFIG_RESERVAS;
/
