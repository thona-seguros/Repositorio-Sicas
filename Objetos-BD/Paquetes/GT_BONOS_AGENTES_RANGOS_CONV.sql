CREATE OR REPLACE PACKAGE GT_BONOS_AGENTES_RANGOS_CONV AS

PROCEDURE COPIAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER,
                  nIdBonoVentasDest NUMBER, dFecIniVigDest DATE , dFecFinVigDest DATE);

FUNCTION TIPO_CONVENCION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER,
                         dFechaBono DATE, nProdPrimaNeta NUMBER) RETURN VARCHAR2;

FUNCTION EXISTEN_REGISTROS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2;

PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER);

END GT_BONOS_AGENTES_RANGOS_CONV;
/

CREATE OR REPLACE PACKAGE BODY GT_BONOS_AGENTES_RANGOS_CONV AS

PROCEDURE COPIAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, 
                  nIdBonoVentasDest NUMBER, dFecIniVigDest DATE , dFecFinVigDest DATE) IS
CURSOR RANGOS_Q IS
   SELECT TipoConvencion, RangoInicial, RangoFinal
     FROM BONOS_AGENTES_RANGOS_CONV
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;
BEGIN
   FOR W IN RANGOS_Q LOOP
      INSERT INTO BONOS_AGENTES_RANGOS_CONV
            (CodCia, CodEmpresa, IdBonoVentas, TipoConvencion, 
             FecIniVig, FecFinVig, RangoInicial, RangoFinal)
      VALUES(nCodCia, nCodEmpresa, nIdBonoVentasDest, W.TipoConvencion, 
             dFecIniVigDest, dFecFinVigDest, W.RangoInicial, W.RangoFinal);
   END LOOP;
END COPIAR;

FUNCTION TIPO_CONVENCION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER,
                         dFechaBono DATE, nProdPrimaNeta NUMBER) RETURN VARCHAR2 IS
cTipoConvencion     BONOS_AGENTES_RANGOS_CONV.TipoConvencion%TYPE;
BEGIN
   BEGIN
      SELECT TipoConvencion
        INTO cTipoConvencion
        FROM BONOS_AGENTES_RANGOS_CONV
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdBonoVentas   = nIdBonoVentas
         AND FecIniVig     <= dFechaBono
         AND FecFinVig     >= dFechaBono
         AND RangoInicial  <= nProdPrimaNeta
         AND RangoFinal    >= nProdPrimaNeta;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTipoConvencion := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Configuración de Rangos de Convenciones es Incorrecta ' ||
                                 ' porque Existen Varios Registros para la Fecha y Rango Alcanzado');
   END;

   RETURN(cTipoConvencion);
END TIPO_CONVENCION;

FUNCTION EXISTEN_REGISTROS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2 IS
cExiste     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM BONOS_AGENTES_RANGOS_CONV
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
   DELETE BONOS_AGENTES_RANGOS_CONV
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdBonoVentas = nIdBonoVentas;
END ELIMINAR;

END GT_BONOS_AGENTES_RANGOS_CONV;
