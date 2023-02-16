CREATE OR REPLACE PACKAGE GT_BONOS_AGENTES_RANGOS AS

PROCEDURE COPIAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER,
                  nIdBonoVentasDest NUMBER, dFecIniVigDest DATE , dFecFinVigDest DATE);

FUNCTION MONTO_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, 
                    dFechaBono DATE, nRangoAlcanzando NUMBER, nProdPrimaNeta NUMBER, 
                    nPorcenPromotoria NUMBER, nPorcenBono IN OUT NUMBER, nBonoAsegTit NUMBER) RETURN NUMBER;

FUNCTION EXISTEN_REGISTROS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2;

PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER);

FUNCTION TIPO_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nPorcenBono NUMBER) RETURN VARCHAR2;

END GT_BONOS_AGENTES_RANGOS;
/

CREATE OR REPLACE PACKAGE BODY GT_BONOS_AGENTES_RANGOS AS

PROCEDURE COPIAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, 
                  nIdBonoVentasDest NUMBER, dFecIniVigDest DATE , dFecFinVigDest DATE) IS
CURSOR RANGOS_Q IS
   SELECT RangoInicial, RangoFinal,
          TipoBono, PorcenBono, MontoBono 
     FROM BONOS_AGENTES_RANGOS
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;
BEGIN
   FOR W IN RANGOS_Q LOOP
      INSERT INTO BONOS_AGENTES_RANGOS
            (CodCia, CodEmpresa, IdBonoVentas, FecIniVig, FecFinVig, 
             RangoInicial, RangoFinal, TipoBono, PorcenBono, MontoBono)
      VALUES(nCodCia, nCodEmpresa, nIdBonoVentasDest, dFecIniVigDest, dFecFinVigDest, 
             W.RangoInicial, W.RangoFinal, W.TipoBono, W.PorcenBono, W.MontoBono);
   END LOOP;
END COPIAR;

FUNCTION MONTO_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER,
                    dFechaBono DATE, nRangoAlcanzando NUMBER, nProdPrimaNeta NUMBER, 
                    nPorcenPromotoria NUMBER, nPorcenBono IN OUT NUMBER, nBonoAsegTit NUMBER) RETURN NUMBER IS
nMontoBono          BONOS_AGENTES_RANGOS.MontoBono%TYPE;
cTipoBono           BONOS_AGENTES_RANGOS.TipoBono%TYPE;
nTotalBono          BONOS_AGENTES_RANGOS.MontoBono%TYPE;
BEGIN
   BEGIN
      SELECT PorcenBono, MontoBono, TipoBono
        INTO nPorcenBono, nMontoBono, cTipoBono
        FROM BONOS_AGENTES_RANGOS
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdBonoVentas   = nIdBonoVentas
         AND FecIniVig     <= dFechaBono
         AND FecFinVig     >= dFechaBono
         AND RangoInicial  <= nRangoAlcanzando
         AND RangoFinal    >= nRangoAlcanzando;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcenBono  := 0;
         nMontoBono   := 0;
         cTipoBono    := 'PORCEN';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Configuración de Rangos del Bono es Incorrecta ' ||
                                 ' porque Existen Varios Registros para la Fecha y Rango Alcanzado');
   END;

   IF cTipoBono = 'PORCEN' THEN
      IF NVL(nPorcenPromotoria,0) > 0 THEN
         nTotalBono := NVL(nProdPrimaNeta,0) * ((nPorcenBono * nPorcenPromotoria / 100) / 100);
      ELSE
         nTotalBono := NVL(nProdPrimaNeta,0) * (nPorcenBono / 100);
      END IF;
   ELSE
      IF NVL(nPorcenPromotoria,0) > 0 THEN
         nTotalBono := NVL(nMontoBono,0) * (nPorcenPromotoria / 100);
      ELSE
         nTotalBono := NVL(nMontoBono,0);
      END IF;
   END IF;
   nTotalBono := NVL(nTotalBono,0) + NVL(nBonoAsegTit,0);
   RETURN(nTotalBono);
END MONTO_BONO;

FUNCTION EXISTEN_REGISTROS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2 IS
cExiste     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM BONOS_AGENTES_RANGOS
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdBonoVentas = nIdBonoVentas;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END EXISTEN_REGISTROS;

PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) IS
BEGIN
   DELETE BONOS_AGENTES_RANGOS
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;
END ELIMINAR;

FUNCTION TIPO_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nPorcenBono NUMBER) RETURN VARCHAR2 IS
   cTipoBono BONOS_AGENTES_RANGOS.TipoBono%TYPE;
BEGIN
   BEGIN
      SELECT TipoBono
        INTO cTipoBono
        FROM BONOS_AGENTES_RANGOS
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdBonoVentas = nIdBonoVentas
         AND PorcenBono   = nPorcenBono;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTipoBono := 'SINTIP';
   END;
   RETURN cTipoBono;
END;

END GT_BONOS_AGENTES_RANGOS;
