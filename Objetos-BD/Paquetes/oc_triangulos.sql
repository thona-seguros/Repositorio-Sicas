--
-- OC_TRIANGULOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   OC_TRIANGULOS_DATOS (Package)
--   TIPOS_DE_SEGUROS (Table)
--   TRIANGULOS (Table)
--   TRIANGULOS_DATOS (Table)
--   TRIANGULOS_SINIESTROS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_TRIANGULOS IS
  PROCEDURE PROCESA_TRIANGULOS(nCodCia NUMBER, cProdTriangulo VARCHAR2, dFecFinTriangulo DATE);
  PROCEDURE INSERTAR(nCodCia NUMBER, nIdTriangulo NUMBER, cProdTriangulo VARCHAR2, dFecFinTriangulo DATE);
  PROCEDURE CALCULAR_GAAS(nCodCia NUMBER, nIdTriangulo NUMBER, cProdTriangulo VARCHAR2);
  FUNCTION NUMERO_TRIANGULO(nCodCia NUMBER) RETURN NUMBER;
END OC_TRIANGULOS;
/

--
-- OC_TRIANGULOS  (Package Body) 
--
--  Dependencies: 
--   OC_TRIANGULOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_TRIANGULOS IS

PROCEDURE PROCESA_TRIANGULOS(nCodCia NUMBER, cProdTriangulo VARCHAR2, dFecFinTriangulo DATE) IS
nIdTriangulo    TRIANGULOS.IdTriangulo%TYPE;
cExiste         VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM TRIANGULOS
       WHERE ProdTriangulo  = cProdTriangulo
         AND FecTriangulo  >= dFecFinTriangulo
         AND CodCia         = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   IF NVL(cExiste,'N') = 'N' THEN
      nIdTriangulo := OC_TRIANGULOS.NUMERO_TRIANGULO(nCodCia);
      OC_TRIANGULOS.INSERTAR(nCodCia, nIdTriangulo, cProdTriangulo, dFecFinTriangulo);
      OC_TRIANGULOS_DATOS.GENERA_TRIANGULOS(nCodCia, nIdTriangulo, cProdTriangulo, dFecFinTriangulo);
      OC_TRIANGULOS.CALCULAR_GAAS(nCodCia, nIdTriangulo, cProdTriangulo);
   ELSE
      RAISE_APPLICATION_ERROR(-20100,'Triángulo de Desarrollo YA se generó o Existen Triángulos con Fechas Mayores');
   END IF;
END PROCESA_TRIANGULOS;

PROCEDURE INSERTAR(nCodCia NUMBER, nIdTriangulo NUMBER, cProdTriangulo VARCHAR2, dFecFinTriangulo DATE) IS
BEGIN
   INSERT INTO TRIANGULOS
          (CodCia, IdTriangulo, ProdTriangulo, FecTriangulo, MtoGaas, MtoTotSini,
           FactorGaas, RvaSiniFutura, RvaGaas, FecGenerado, CodUsuario) 
   VALUES (nCodCia, nIdTriangulo, cProdTriangulo, dFecFinTriangulo, 0, 0,
           0, 0, 0, TRUNC(SYSDATE), USER);
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20100,'Error al Insertar en TRIANGULOS IdTriangulo '|| nIdTriangulo ||
                              ' Tipo de Triángulo ' || cProdTriangulo );
END INSERTAR;

PROCEDURE CALCULAR_GAAS(nCodCia NUMBER, nIdTriangulo NUMBER, cProdTriangulo VARCHAR2) IS
nMtoGaas         TRIANGULOS.MtoGaas%TYPE;
nMtoTotSini      TRIANGULOS.MtoTotSini%TYPE;
nFactorGaas      TRIANGULOS.FactorGaas%TYPE;
nRvaSiniFutura   TRIANGULOS.RvaSiniFutura%TYPE;
nRvaGaas         TRIANGULOS.RvaGaas%TYPE;
 
CURSOR ANIOS_Q IS
   SELECT DISTINCT TO_NUMBER(SUBSTR(TxtPerTitulo,1,4)) Anio,
          TO_DATE('01/12/'||TRIM(SUBSTR(TxtPerTitulo,1,4)),'DD/MM/YYYY') FecFinal
     FROM TRIANGULOS_DATOS
    WHERE CodCia         = nCodCia
      AND IdTriangulo    = nIdTriangulo
      AND NumRegistro   != 1
      AND TxtPerTitulo  != 'TOTALES'
      AND TipoTriangulo  = 'MO'
    ORDER BY TO_NUMBER(SUBSTR(TxtPerTitulo,1,4));

CURSOR PROD_Q IS
   SELECT DECODE(CodTipoPlan,'010','VIDA', 'AyE') Producto
     FROM TIPOS_DE_SEGUROS
    WHERE CodCia   = nCodCia;

/*CURSOR CTAS_Q IS
   SELECT IdeCta, CodCia, Cta1, Cta2, Cta3, Cta4,
          Cta5, Cta6, Cta7, Cta8, NumCtaAux
     FROM COMPROBANTES_DETALLE
    WHERE CodCia = '01'
      AND Cta1   = cCta1
      AND Cta2   = cCta2
      AND Cta3   = cCta3;*/
BEGIN
/*   -- Sumariza GAAS de Cuentas Contables
   IF cProdTriangulo = 'VIDA' THEN
      cCta1 := '5411';
      cCta2 := '00';
   ELSE
      cCta1 := '5411';
      cCta2 := '01';
   END IF;*/
   nMtoGaas  := 0;
/*   FOR W IN ANIOS_Q LOOP
      FOR Y IN PROD_Q LOOP
         IF cProdTriangulo = Y.Producto THEN
            cCta3 := Y.CtaAux;
            FOR X IN CTAS_Q LOOP
               nMtoGaas := NVL(nMtoGaas,0) + PR_SALDOS.FNSALDOS(W.Anio, X.IdeCta, X.CodCia, X.Cta1, X.Cta2, X.Cta3,
                                                                X.Cta4, X.Cta5, X.Cta6, X.Cta7, X.Cta8, X.NumCtaAux,
                                                                'H','M','ACTUAL',SUBSTR(TO_CHAR(W.FecFinal,'MONTH'),1,3),0,NULL);
            END LOOP;
         END IF;
      END LOOP;
   END LOOP;*/
   -- Sumariza Siniestros
   BEGIN
      SELECT NVL(SUM(MtoSiniestro),0)
        INTO nMtoTotSini
        FROM TRIANGULOS_SINIESTROS
       WHERE IdTriangulo = nIdTriangulo
         AND CodCia      = nCodCia;
   END;
   
   IF NVL(nMtoTotSini,0) != 0 THEN
      nFactorGaas := NVL(nMtoGaas,0) / NVL(nMtoTotSini,0);
   ELSE
      nFactorGaas := 0;
   END IF;
   
   -- Detarmina Reserva de Siniestralidad Futura
   BEGIN
      SELECT NVL(TO_NUMBER(TxtTotal),0)
        INTO nRvaSiniFutura
        FROM TRIANGULOS_DATOS
       WHERE CodCia        = nCodCia
         AND IdTriangulo   = nIdTriangulo
         AND TxtPerTitulo  = 'TOTALES'
         AND TipoTriangulo = 'RF';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nRvaSiniFutura := 0;
   END;
   
   nRvaGaas := NVL(nFactorGaas,0) * NVL(nRvaSiniFutura,0);
   
   UPDATE TRIANGULOS
      SET MtoGaas       = nMtoGaas,
          MtoTotSini    = nMtoTotSini,
          FactorGaas    = nFactorGaas,
          RvaSiniFutura = nRvaSiniFutura,
          RvaGaas       = nRvaGaas
    WHERE IdTriangulo = nIdTriangulo
      AND CodCia      = nCodCia;
END CALCULAR_GAAS;

FUNCTION NUMERO_TRIANGULO(nCodCia NUMBER) RETURN NUMBER IS
nIdTriangulo    TRIANGULOS.IdTriangulo%TYPE;   
BEGIN
   SELECT COUNT(*) + 1
     INTO nIdTriangulo
     FROM TRIANGULOS
    WHERE CodCia  = nCodCia;
   RETURN(nIdTriangulo);
END NUMERO_TRIANGULO;

END OC_TRIANGULOS;
/

--
-- OC_TRIANGULOS  (Synonym) 
--
--  Dependencies: 
--   OC_TRIANGULOS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_TRIANGULOS FOR SICAS_OC.OC_TRIANGULOS
/


GRANT EXECUTE ON SICAS_OC.OC_TRIANGULOS TO PUBLIC
/
