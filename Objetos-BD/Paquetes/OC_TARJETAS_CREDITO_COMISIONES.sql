CREATE OR REPLACE PACKAGE OC_TARJETAS_CREDITO_COMISIONES IS

  FUNCTION COMISION_USO(nCodCia NUMBER, cCodEntidad VARCHAR2, cTipoTarjeta VARCHAR2, dFecComision DATE) RETURN NUMBER;

  FUNCTION COMISION_MSI(nCodCia NUMBER, cCodEntidad VARCHAR2, cTipoTarjeta VARCHAR2, dFecComision DATE, nCantMSI NUMBER) RETURN NUMBER;

  FUNCTION TOTAL_DIF_COBRANZA_MSI(nCodCia NUMBER, cCodEntidad VARCHAR2, cTipoTarjeta VARCHAR2, dFecComision DATE, nCantMSI NUMBER) RETURN NUMBER;

END OC_TARJETAS_CREDITO_COMISIONES;
 
/

CREATE OR REPLACE PACKAGE BODY OC_TARJETAS_CREDITO_COMISIONES IS

FUNCTION COMISION_USO(nCodCia NUMBER, cCodEntidad VARCHAR2, cTipoTarjeta VARCHAR2, dFecComision DATE) RETURN NUMBER IS
nPorcenComisUso     TARJETAS_CREDITO_COMISIONES.PorcenComisUso%TYPE;
BEGIN
   BEGIN
      SELECT PorcenComisUso 
        INTO nPorcenComisUso
        FROM TARJETAS_CREDITO_COMISIONES
       WHERE CodCia           = nCodCia
         AND CodEntidad       = cCodEntidad
         AND TipoTarjeta      = cTipoTarjeta
         AND FecIniComision  >= dFecComision
         AND FecFinComision  <= dFecComision;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcenComisUso  := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Configuración de Comisión por Uso de Tarjeta '|| cTipoTarjeta ||
                                 ' de Entidad Financiera ' || cCodEntidad);
  END;
  RETURN(nPorcenComisUso);
END COMISION_USO;

FUNCTION COMISION_MSI(nCodCia NUMBER, cCodEntidad VARCHAR2, cTipoTarjeta VARCHAR2, dFecComision DATE, nCantMSI NUMBER) RETURN NUMBER IS
nPorcen3MSI         TARJETAS_CREDITO_COMISIONES.Porcen3MSI%TYPE;
nPorcen6MSI         TARJETAS_CREDITO_COMISIONES.Porcen6MSI%TYPE;
nPorcen9MSI         TARJETAS_CREDITO_COMISIONES.Porcen9MSI%TYPE;
nPorcen12MSI        TARJETAS_CREDITO_COMISIONES.Porcen12MSI%TYPE;
BEGIN
   BEGIN
      SELECT Porcen3MSI, Porcen6MSI, Porcen9MSI, Porcen12MSI 
        INTO nPorcen3MSI, nPorcen6MSI, nPorcen9MSI, nPorcen12MSI
        FROM TARJETAS_CREDITO_COMISIONES
       WHERE CodCia           = nCodCia
         AND CodEntidad       = cCodEntidad
         AND TipoTarjeta      = cTipoTarjeta
         AND FecIniComision  >= dFecComision
         AND FecFinComision  <= dFecComision;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcen3MSI   := 0;
         nPorcen6MSI   := 0;
         nPorcen9MSI   := 0;
         nPorcen12MSI  := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Configuración de Comisiones MSI de Tarjeta '|| cTipoTarjeta ||
                                 ' de Entidad Financiera ' || cCodEntidad);
   END;
   IF nCantMSI = 3 THEN
      RETURN(nPorcen3MSI);
   ELSIF nCantMSI = 6 THEN
      RETURN(nPorcen6MSI);
   ELSIF nCantMSI = 9 THEN
      RETURN(nPorcen9MSI);
   ELSIF nCantMSI = 12 THEN
      RETURN(nPorcen12MSI);
   ELSE
      RAISE_APPLICATION_ERROR(-20100,'Cantidad de Meses Sin Intereses (' || nCantMSI || ') NO Configurada en el Sistema');
   END IF;
END COMISION_MSI;

FUNCTION TOTAL_DIF_COBRANZA_MSI(nCodCia NUMBER, cCodEntidad VARCHAR2, cTipoTarjeta VARCHAR2, dFecComision DATE, nCantMSI NUMBER) RETURN NUMBER IS
nPorcenComisUso     TARJETAS_CREDITO_COMISIONES.PorcenComisUso%TYPE;
nPorcen3MSI         TARJETAS_CREDITO_COMISIONES.Porcen3MSI%TYPE;
nPorcen6MSI         TARJETAS_CREDITO_COMISIONES.Porcen6MSI%TYPE;
nPorcen9MSI         TARJETAS_CREDITO_COMISIONES.Porcen9MSI%TYPE;
nPorcen12MSI        TARJETAS_CREDITO_COMISIONES.Porcen12MSI%TYPE;
BEGIN
   BEGIN
      SELECT PorcenComisUso, Porcen3MSI, Porcen6MSI, Porcen9MSI, Porcen12MSI
        INTO nPorcenComisUso, nPorcen3MSI, nPorcen6MSI, nPorcen9MSI, nPorcen12MSI
        FROM TARJETAS_CREDITO_COMISIONES
       WHERE CodCia           = nCodCia
         AND CodEntidad       = cCodEntidad
         AND TipoTarjeta      = cTipoTarjeta
         AND FecIniComision  >= dFecComision
         AND FecFinComision  <= dFecComision;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcenComisUso  := 0;
         nPorcen3MSI      := 0;
         nPorcen6MSI      := 0;
         nPorcen9MSI      := 0;
         nPorcen12MSI     := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Configuración de Comisión por Uso de Tarjeta '|| cTipoTarjeta ||
                                 ' de Entidad Financiera ' || cCodEntidad);
  END;
   IF nCantMSI = 3 THEN
      RETURN(nPorcenComisUso + nPorcen3MSI);
   ELSIF nCantMSI = 6 THEN
      RETURN(nPorcenComisUso + nPorcen6MSI);
   ELSIF nCantMSI = 9 THEN
      RETURN(nPorcenComisUso + nPorcen9MSI);
   ELSIF nCantMSI = 12 THEN
      RETURN(nPorcenComisUso + nPorcen12MSI);
   ELSE
      RAISE_APPLICATION_ERROR(-20100,'Cantidad de Meses Sin Intereses (' || nCantMSI || ') NO Configurada en el Sistema');
   END IF;
END TOTAL_DIF_COBRANZA_MSI;

END OC_TARJETAS_CREDITO_COMISIONES;
