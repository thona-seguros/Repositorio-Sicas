--
-- GT_BONOS_AGENTES_CALCULO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_OUTPUT (Synonym)
--   DBMS_STANDARD (Package)
--   USUARIOS (Table)
--   OC_ADICIONALES_EMPRESA (Package)
--   OC_AGENTES (Package)
--   SINIESTRO (Table)
--   POLIZAS (Table)
--   GT_BONOS_AGENTES_CALCULO_DET (Package)
--   GT_BONOS_AGENTES_CONFIG (Package)
--   GT_BONOS_AGENTES_FACTURAS (Package)
--   OC_EMPRESAS (Package)
--   GT_BONOS_AGENTES_NIVELES (Package)
--   GT_BONOS_AGENTES_PROYECCION (Package)
--   GT_BONOS_AGENTES_PROY_FACT (Package)
--   GT_BONOS_AGENTES_RANGOS (Package)
--   CORREOS_ELECTRONICOS_PNJ (Table)
--   DETALLE_FACTURAS (Table)
--   OC_TRANSACCION (Package)
--   OC_USUARIOS (Package)
--   PERSONA_NATURAL_JURIDICA (Table)
--   AGENTES (Table)
--   AGENTES_DISTRIBUCION_POLIZA (Table)
--   ASEGURADO_CERTIFICADO (Table)
--   BONOS_AGENTES_CALCULO (Table)
--   BONOS_AGENTES_CALCULO_DET (Table)
--   BONOS_AGENTES_CONFIG (Table)
--   BONOS_AGENTES_FACTURAS (Table)
--   BONOS_AGENTES_NIVELES (Table)
--   BONOS_AGENTES_POLIZAS (Table)
--   BONOS_AGENTES_RANGOS (Table)
--   BONOS_AGENTES_TIPO_SEG (Table)
--   OC_CORREOS_ELECTRONICOS_PNJ (Package)
--   CATALOGO_DE_CONCEPTOS (Table)
--   OC_GENERALES (Package)
--   OC_MAIL (Package)
--   OC_ASEGURADO (Package)
--   DETALLE_POLIZA (Table)
--   FACTURAS (Table)
--   TIPOS_DE_SEGUROS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_BONOS_AGENTES_CALCULO AS

FUNCTION GENERA_IDENTIFICADOR(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN NUMBER;

FUNCTION BONOS_CALCULADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2; 

PROCEDURE INSERTA_BONO_CALCULADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, 
                                 cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE, cTipoBonoConv VARCHAR2, 
                                 nProdPrimaNeta NUMBER, nCantPolizas NUMBER, nMesesProd NUMBER, nCantAgentesProd NUMBER,
                                 nPorcenSiniest NUMBER, nPorcenBono NUMBER, nPorcenPromotoria NUMBER,
                                 nPrimaNetaAsegTit NUMBER, nPorcenAsegTit NUMBER, nMontoTotBono NUMBER);

FUNCTION EXISTE_CALCULO_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, 
                             cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE) RETURN VARCHAR2; 

FUNCTION EXISTE_BONOS_NO_APLICADOS(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN VARCHAR2; 

FUNCTION EXISTE_BONOS_APLICADOS(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN VARCHAR2; 

PROCEDURE CALCULO_BONOS(nCodCia NUMBER, nCodEmpresa NUMBER, cCodigoBono VARCHAR2, cFrecuenciaBono VARCHAR2, 
                        cReglaBono VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE, nIdCalculoProy NUMBER DEFAULT NULL,
                        cTipoBonoConv VARCHAR2);

FUNCTION APLICA_ASEG_TITULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, cIndAsegTitulares VARCHAR2, 
                             nEdadIniAsegTit NUMBER, nEdadFinAsegTit NUMBER) RETURN VARCHAR2; 

FUNCTION INCLUYE_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, cCodAgente VARCHAR2, 
                        cIndEmisionNueva VARCHAR2, cIndRenovacion VARCHAR2, nNumRenov NUMBER) RETURN VARCHAR2; 

PROCEDURE APLICAR_BONOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, cCodAgente VARCHAR2,
                        dFecIniCalcBono DATE, dFecFinCalcBono DATE);

FUNCTION AGENTES_PRODUCTIVOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, cCodAgente VARCHAR2,
                             dFecIniCalcBono DATE, dFecFinCalcBono DATE, nCantAgentesProdAct IN OUT NUMBER) RETURN VARCHAR2;
                             
FUNCTION MONTO_PROYECCION_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, cCodAgente VARCHAR2) RETURN NUMBER;

PROCEDURE LIQUIDA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE);                   

PROCEDURE ASIGNA_NOMINA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE, nIdNomina NUMBER);

PROCEDURE ENVIA_CARTA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodAgente VARCHAR2, cDirectorio VARCHAR2, cNomArchivo VARCHAR2);

END GT_BONOS_AGENTES_CALCULO;
/

--
-- GT_BONOS_AGENTES_CALCULO  (Package Body) 
--
--  Dependencies: 
--   GT_BONOS_AGENTES_CALCULO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_BONOS_AGENTES_CALCULO AS

FUNCTION GENERA_IDENTIFICADOR(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN NUMBER IS
   nIdBono BONOS_AGENTES_CALCULO.IdBono%TYPE;
BEGIN
   SELECT NVL(MAX(IdBono),0) + 1
     INTO nIdBono
     FROM BONOS_AGENTES_CALCULO
    WHERE CodCia     = nCodCia 
      AND CodEmpresa = nCodEmpresa;
   RETURN nIdBono;
END GENERA_IDENTIFICADOR;

FUNCTION BONOS_CALCULADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER) RETURN VARCHAR2 IS
cExiste     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM BONOS_AGENTES_CALCULO
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdBonoVentas   = nIdBonoVentas;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END BONOS_CALCULADOS;

PROCEDURE INSERTA_BONO_CALCULADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, 
                                 cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE, cTipoBonoConv VARCHAR2,
                                 nProdPrimaNeta NUMBER, nCantPolizas NUMBER, nMesesProd NUMBER, nCantAgentesProd NUMBER,
                                 nPorcenSiniest NUMBER, nPorcenBono NUMBER, nPorcenPromotoria NUMBER,
                                 nPrimaNetaAsegTit NUMBER, nPorcenAsegTit NUMBER, nMontoTotBono NUMBER) IS
BEGIN
   BEGIN
      INSERT INTO BONOS_AGENTES_CALCULO
            (CodCia, CodEmpresa, IdBonoVentas, CodNivel, CodAgente, FecIniCalcBono, FecFinCalcBono,
             TipoBonoConv, StsCalcBono, FecStatus, ProdPrimaNeta, CantPolizas, MesesProd, CantAgentesProd,
             PorcenSiniest, PorcenBono, PorcenPromotoria, PrimaNetaAsegTit, PorcenAsegTit,
             MontoTotBono, IdNomina, CodUsuario)
      VALUES(nCodCia, nCodEmpresa, nIdBonoVentas, nCodNivel, cCodAgente, dFecIniCalcBono, dFecFinCalcBono,
             cTipoBonoConv, 'NOAPLI', TRUNC(SYSDATE), nProdPrimaNeta, nCantPolizas, nMesesProd, nCantAgentesProd,
             nPorcenSiniest, nPorcenBono, nPorcenPromotoria, nPrimaNetaAsegTit, nPorcenAsegTit,
             nMontoTotBono, NULL, USER);
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20100,'Error al Insertar Bono Calculado para Nivel ' || nCodNivel || 
                                 ' y Código ' || cCodAgente || ' para Bono No. ' || nIdBonoVentas);
   END;
END INSERTA_BONO_CALCULADO;

FUNCTION EXISTE_CALCULO_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, 
                             cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE) RETURN VARCHAR2 IS
cExiste     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM BONOS_AGENTES_CALCULO
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdBonoVentas   = nIdBonoVentas
         AND CodNivel       = nCodNivel
         AND CodAgente      = cCodAgente
         AND FecIniCalcBono = dFecIniCalcBono
         AND FecFinCalcBono = dFecFinCalcBono
         AND StsCalcBono    = 'APLICA';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END EXISTE_CALCULO_BONO;

FUNCTION EXISTE_BONOS_NO_APLICADOS(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN VARCHAR2 IS
cExiste     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM BONOS_AGENTES_CALCULO
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND StsCalcBono    = 'NOAPLI';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END EXISTE_BONOS_NO_APLICADOS;

FUNCTION EXISTE_BONOS_APLICADOS(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN VARCHAR2 IS
cExiste     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM BONOS_AGENTES_CALCULO
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND StsCalcBono    = 'PORLIQ';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END EXISTE_BONOS_APLICADOS;

PROCEDURE CALCULO_BONOS(nCodCia NUMBER, nCodEmpresa NUMBER, cCodigoBono VARCHAR2, cFrecuenciaBono VARCHAR2, 
                        cReglaBono VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE, nIdCalculoProy NUMBER DEFAULT NULL,
                        cTipoBonoConv VARCHAR2) IS
   nIdBonoVentas         BONOS_AGENTES_CONFIG.IdBonoVentas%TYPE;
   nProdPrimaNeta        BONOS_AGENTES_CALCULO.ProdPrimaNeta%TYPE;
   nIdPoliza             BONOS_AGENTES_POLIZAS.IdPoliza%TYPE;
   nCodNivel             BONOS_AGENTES_NIVELES.CodNivel%TYPE;
   cCodAgente            BONOS_AGENTES_NIVELES.CodAgente%TYPE;
   nCodNivelJefe         BONOS_AGENTES_NIVELES.CodNivel%TYPE;
   cCod_Agente_Jefe      BONOS_AGENTES_NIVELES.CodAgente%TYPE;
   nPorcenPromotoria     BONOS_AGENTES_CONFIG.PorcenPromotoria%TYPE;
   nEdadIniAsegTit       BONOS_AGENTES_CONFIG.EdadIniAsegTit%TYPE;
   nEdadFinAsegTit       BONOS_AGENTES_CONFIG.EdadFinAsegTit%TYPE;
   nPorcenAsegTit        BONOS_AGENTES_CONFIG.PorcenAsegTit%TYPE;
   nPorcenAsegTitRec     BONOS_AGENTES_CONFIG.PorcenAsegTit%TYPE;
   nPrimaNetaAsegTit     BONOS_AGENTES_CALCULO.PrimaNetaAsegTit%TYPE;
   nBonoAsegTit          BONOS_AGENTES_RANGOS.MontoBono%TYPE;
   nCantPolizas          BONOS_AGENTES_CALCULO.CantPolizas%TYPE;
   nCantPolRenov         BONOS_AGENTES_CALCULO.CantPolizas%TYPE;
   nTotalBono            BONOS_AGENTES_RANGOS.MontoBono%TYPE;
   nRangoAlcanzando      BONOS_AGENTES_RANGOS.RangoFinal%TYPE;
   nReservaSiniestro     SINIESTRO.Monto_Reserva_Moneda%TYPE;
   nPorcenSiniest        BONOS_AGENTES_CONFIG.PorcenAsegTit%TYPE;
   nPorcenBono           BONOS_AGENTES_CALCULO.PorcenBono%TYPE;
   nCantAgentesProdAct   BONOS_AGENTES_CONFIG.CantAgentesProd%TYPE;
   nMesesProd            NUMBER(5);
   cTienePromotoria      VARCHAR2(1);
   cAplicaTit            VARCHAR2(1);
   nMesInicial           NUMBER(2);
   nCantPolAnt           NUMBER(5);
   nTotPolAnt            NUMBER(10);
   cTieneFacturas        VARCHAR2(1);
   cCodTipoBono          BONOS_AGENTES_CONFIG.CodTipoBono%TYPE;
   cCodRamo              TIPOS_DE_SEGUROS.CodTipoPlan%TYPE;
CURSOR BONOS_Q IS
   SELECT IdBonoVentas, CodigoBono, FrecuenciaBono, ReglaBono, IndAgteConvEsp, 
          IndExcluConvEsp, IndPolEspecificas, IndIdTipoSegPlanes, IndEmisionNueva, 
          IndRenovacion, IndPromotoria, PorcenPromotoria,
          IndAsegTitulares, EdadIniAsegTit, EdadFinAsegTit, PorcenAsegTit,
          ProducMinimaBono, MinimoPolizas,PorcSiniestralidad
     FROM BONOS_AGENTES_CONFIG
    WHERE CodCia            = nCodCia
      AND CodEmpresa        = nCodEmpresa
      AND StsBono           = 'ACTIVO'
      AND CodigoBono     LIKE cCodigoBono
      AND FrecuenciaBono LIKE cFrecuenciaBono
      AND ReglaBono      LIKE cReglaBono
      AND FecIniBono       <= dFecIniCalcBono
      AND FecFinBono       >= dFecFinCalcBono
    ORDER BY IdBonoVentas;

CURSOR AGT_Q IS
   SELECT CodNivel, CodAgente
     FROM BONOS_AGENTES_NIVELES
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdBonoVentas  = nIdBonoVentas;

CURSOR POL_Q IS
   SELECT DISTINCT P.IdPoliza, P.NumRenov, P.FecIniVig
     FROM POLIZAS P, BONOS_AGENTES_POLIZAS B
    WHERE ((GT_BONOS_AGENTES_CONFIG.INDICADORES(nCodCia, nCodEmpresa, nIdBonoVentas, 'RET') = 'N' 
            AND P.FecIniVig BETWEEN dFecIniCalcBono AND dFecFinCalcBono) 
       OR P.FecIniVig BETWEEN dFecIniCalcBono AND dFecFinCalcBono)
--          P.FecIniVig    >= dFecIniCalcBono
--      AND P.FecIniVig    <= dFecFinCalcBono
      AND P.CodTipoBono   = cCodTipoBono
      AND P.StsPoliza   NOT IN ('SOL')--, 'XRE')
      AND P.IdPoliza      = B.IdPoliza
      AND B.CodCia        = nCodCia
      AND B.CodEmpresa    = nCodEmpresa
      AND B.IdBonoVentas  = nIdBonoVentas
      AND EXISTS (SELECT 'S'
                    FROM AGENTES_DISTRIBUCION_POLIZA
                   WHERE CodCia            = P.CodCia
                     AND IdPoliza          = P.IdPoliza
                     AND CodNivel          = nCodNivel
                     AND Cod_Agente_Distr  = cCodAgente)
    ORDER BY P.FecIniVig;

CURSOR PROD_Q IS
   SELECT DISTINCT P.IdPoliza, P.NumRenov, P.FecIniVig
     FROM BONOS_AGENTES_TIPO_SEG B, POLIZAS P, DETALLE_POLIZA D
    WHERE B.CodCia        = nCodCia
      AND B.CodEmpresa    = nCodEmpresa
      AND B.IdBonoVentas  = nIdBonoVentas
      AND P.CodTipoBono   = cCodTipoBono
      AND P.CodCia        > 0
      AND P.CodEmpresa    > 0
      AND P.IdPoliza      > 0 
      AND ((GT_BONOS_AGENTES_CONFIG.INDICADORES(nCodCia, nCodEmpresa, nIdBonoVentas, 'RET') = 'N' 
            AND P.FecIniVig BETWEEN dFecIniCalcBono AND dFecFinCalcBono) 
       --OR P.FecIniVig BETWEEN dFecIniCalcBono AND dFecFinCalcBono)
       OR P.FecIniVig    <= dFecFinCalcBono)
      AND P.StsPoliza NOT IN ('SOL')--, 'XRE')
      AND D.CodCia        = P.CodCia
      AND D.CodEmpresa    = P.CodEmpresa
      AND D.IdPoliza      = P.IdPoliza
      AND D.IDetPol       > 0
--      AND ((D.IdTipoSeg   = cIdTipoSeg AND cIdTipoSeg != '%')
--       OR  (D.IdTipoSeg   LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
      AND D.IdTipoSeg     = B.IdTipoSeg
      AND D.PlanCob       = B.PlanCob
      AND D.IdTipoSeg    IN (SELECT IdTipoSeg
                               FROM TIPOS_DE_SEGUROS
                              WHERE CodCia      = P.CodCia
                                AND CodEmpresa  = P.CodEmpresa
                                AND CodTipoPlan = cCodRamo)
      AND EXISTS (SELECT 'S'
                    FROM AGENTES_DISTRIBUCION_POLIZA
                   WHERE CodCia            = P.CodCia
                     AND IdPoliza          = P.IdPoliza
                     AND CodNivel          = nCodNivel
                     AND Cod_Agente_Distr  = cCodAgente)
    ORDER BY P.FecIniVig;

CURSOR FACT_Q IS
   SELECT DISTINCT F.IdFactura, F.FecPago, NVL(SUM(DF.Monto_Det_Moneda), 0) PrimaFactura 
     FROM DETALLE_FACTURAS DF, FACTURAS F 
    WHERE F.CodCia     = nCodCia
      AND F.IdPoliza   = nIdPoliza
      AND F.IdFactura  > 0
      AND DF.CodCpto   IN (SELECT CodConcepto 
                             FROM CATALOGO_DE_CONCEPTOS 
                            WHERE IndCptoPrimas   = 'S' 
                               OR IndCptoServicio = 'S')
      AND F.Stsfact    IN ('PAG')
      AND F.FecPago    >= dFecIniCalcBono
      AND F.FecPago    <= dFecFinCalcBono
      AND DF.IdFactura  = F.IdFactura
    GROUP BY F.IdFactura, F.FecPago;
    
CURSOR NBFACT_Q IS
   SELECT DISTINCT F.IdFactura, F.FecSts, NVL(SUM(DF.Monto_Det_Moneda), 0) PrimaFactura 
     FROM DETALLE_FACTURAS DF, FACTURAS F 
    WHERE F.CodCia     = nCodCia
      AND F.IdPoliza   = nIdPoliza
      AND F.IdFactura  > 0
      AND DF.CodCpto   IN (SELECT CodConcepto 
                             FROM CATALOGO_DE_CONCEPTOS 
                            WHERE IndCptoPrimas   = 'S' 
                               OR IndCptoServicio = 'S')
      AND F.Stsfact    IN ('EMI')
      AND OC_TRANSACCION.FECHATRANSACCION(F.IdTransaccion) <= dFecFinCalcBono
      AND DF.IdFactura  = F.IdFactura
    GROUP BY F.IdFactura, F.FecSts;    
BEGIN
   IF nIdCalculoProy IS NULL THEN
      DELETE BONOS_AGENTES_FACTURAS F
        WHERE EXISTS (SELECT 'S'
                        FROM BONOS_AGENTES_CALCULO
                       WHERE StsCalcBono    = 'NOAPLI'
                         AND CodCia         = F.CodCia
                         AND CodEmpresa     = F.CodEmpresa
                         AND IdBonoVentas   = F.IdBonoVentas
                         AND CodNivel       = F.CodNivel
                         AND CodAgente      = F.CodAgente
                         AND FecIniCalcBono = F.FecIniCalcBono
                         AND FecFinCalcBono = F.FecFinCalcBono);
                           
      DELETE BONOS_AGENTES_CALCULO_DET F     
        WHERE EXISTS (SELECT 'S'
                        FROM BONOS_AGENTES_CALCULO
                       WHERE StsCalcBono    = 'NOAPLI'
                         AND CodCia         = F.CodCia
                         AND CodEmpresa     = F.CodEmpresa
                         AND IdBonoVentas   = F.IdBonoVentas
                         AND CodNivel       = F.CodNivel
                         AND CodAgente      = F.CodAgente
                         AND FecIniCalcBono = F.FecIniCalcBono
                         AND FecFinCalcBono = F.FecFinCalcBono);    

       DELETE BONOS_AGENTES_CALCULO
        WHERE StsCalcBono = 'NOAPLI';
         
   END IF;
   FOR W IN BONOS_Q LOOP
      nIdBonoVentas := W.IdBonoVentas;
      BEGIN
         SELECT CodTipoBono,CodTIpoPlan
           INTO cCodTipoBono,cCodRamo
           FROM BONOS_AGENTES_CONFIG
          WHERE CodCia       = nCodCia
            AND CodEmpresa   = nCodEmpresa
            AND IdBonoVentas = nIdBonoVentas;
      END;
      FOR X IN AGT_Q LOOP
         -------  SE DETERMINA SI ES BONO O CONVENCIÓN  ---------
         IF cTipoBonoConv = 'BONO' THEN 
            IF ((NVL(W.IndExcluConvEsp,'N') = 'S' AND 
               GT_BONOS_AGENTES_NIVELES.TIENE_CONVENIO_ESPECIAL(nCodCia, nCodEmpresa, nIdBonoVentas, X.CodNivel, X.CodAgente) = 'N') OR
               NVL(W.IndExcluConvEsp,'N') = 'N') AND
               GT_BONOS_AGENTES_CALCULO.AGENTES_PRODUCTIVOS(nCodCia, nCodEmpresa, nIdBonoVentas, X.CodNivel, X.CodAgente,
                                                            dFecIniCalcBono, dFecFinCalcBono, nCantAgentesProdAct) = 'S' AND
               GT_BONOS_AGENTES_CALCULO.EXISTE_CALCULO_BONO(nCodCia, nCodEmpresa, nIdBonoVentas, X.CodNivel, X.CodAgente,
                                                            dFecIniCalcBono, dFecFinCalcBono) = 'N' THEN
               nCodNivel         := X.CodNivel;
               cCodAgente        := X.CodAgente;
               -- Evalúa si Pertenece a Promotoría
               IF W.IndPromotoria = 'S' THEN
                  BEGIN
                     SELECT Cod_Agente_Jefe
                       INTO cCod_Agente_Jefe
                       FROM AGENTES
                      WHERE CodCia     = nCodCia
                        AND Cod_Agente = cCodAgente;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        cCod_Agente_Jefe := NULL;
                     WHEN TOO_MANY_ROWS THEN
                        cCod_Agente_Jefe := NULL;
                  END;
                        
                  IF cCod_Agente_Jefe IS NOT NULL AND OC_AGENTES.NIVEL_AGENTE(nCodCia, cCodAgente) = 2 THEN
                     cTienePromotoria := 'S';
                  ELSE
                     cTienePromotoria := 'N';
                  END IF;
               ELSE
                  cTienePromotoria := 'N';
               END IF;

               IF cTienePromotoria = 'S' THEN
                  nPorcenPromotoria := W.PorcenPromotoria;
               ELSE
                  nPorcenPromotoria := 0;
               END IF;
                     
               -- Valida Incremento por Asegurados Titulares
               IF W.IndAsegTitulares = 'S' THEN
                  nEdadIniAsegTit   := W.EdadIniAsegTit;
                  nEdadFinAsegTit   := W.EdadFinAsegTit;
                  nPorcenAsegTit    := W.PorcenAsegTit;
               ELSE
                  nEdadIniAsegTit   := 0;
                  nEdadFinAsegTit   := 0;
                  nPorcenAsegTit    := 0;
               END IF;
                    
               nProdPrimaNeta      := 0;
               nPrimaNetaAsegTit   := 0;
               nBonoAsegTit        := 0;
               nCantPolizas        := 0;
               nReservaSiniestro   := 0;
               nMesesProd          := 0;
               nMesInicial         := 0;
               nTotPolAnt          := 0;
               nCantPolRenov       := 0;
               nMesesProd          := 0;
               nPorcenSiniest      := 0;
               nCantAgentesProdAct := 0;
               IF NVL(W.IndPolEspecificas,'N') = 'S' THEN
                  
                  FOR Z IN POL_Q LOOP
                     nIdPoliza      := Z.IdPoliza;
                     IF GT_BONOS_AGENTES_CALCULO.INCLUYE_POLIZA(nCodCia, nCodEmpresa, nIdPoliza, cCodAgente, 
                                                                W.IndEmisionNueva, W.IndRenovacion, Z.NumRenov) = 'S' THEN
                        cTieneFacturas := 'N';
                        FOR F IN FACT_Q LOOP
                           cTieneFacturas := 'S';
                           cAplicaTit := GT_BONOS_AGENTES_CALCULO.APLICA_ASEG_TITULAR(nCodCia, nCodEmpresa, nIdPoliza, W.IndAsegTitulares,
                                                                                      nEdadIniAsegTit, nEdadFinAsegTit);
                           IF cAplicaTit = 'N' THEN
                              nProdPrimaNeta    := nProdPrimaNeta + NVL(F.PrimaFactura,0);
                              nPorcenAsegTitRec := 0;
                           ELSE
                              nPrimaNetaAsegTit := NVL(nPrimaNetaAsegTit,0) + NVL(F.PrimaFactura,0);
                              nBonoAsegTit      := NVL(nBonoAsegTit,0) + (NVL(F.PrimaFactura,0) * (nPorcenAsegTit / 100));
                              nProdPrimaNeta    := nProdPrimaNeta + NVL(F.PrimaFactura,0);
                              nPorcenAsegTitRec := nPorcenAsegTit;
                           END IF;
                                 
                           IF nIdCalculoProy IS NULL THEN
                               GT_BONOS_AGENTES_FACTURAS.INSERTAR (nCodCia, nCodEmpresa, nIdBonoVentas, nCodNivel, cCodAgente,
                                                                   dFecIniCalcBono, dFecFinCalcBono, nIdPoliza, Z.NumRenov, 
                                                                   F.IdFactura, F.FecPago, F.PrimaFactura, cAplicaTit, nPorcenAsegTitRec);
                           END IF;
                        END LOOP;
                              
                        -- FACTURAS QUE NO JUEGAN PARA CALCULO --- PROYECCIONES
                        IF nIdCalculoProy IS NOT NULL THEN
                           FOR F IN NBFACT_Q LOOP
                              cAplicaTit := GT_BONOS_AGENTES_CALCULO.APLICA_ASEG_TITULAR(nCodCia, nCodEmpresa, nIdPoliza, W.IndAsegTitulares,
                                                                                         nEdadIniAsegTit, nEdadFinAsegTit);
                              IF cAplicaTit = 'N' THEN
                                 nPorcenAsegTitRec := 0;
                              ELSE
                                 nPorcenAsegTitRec := nPorcenAsegTit;
                              END IF;
                                    
                              GT_BONOS_AGENTES_PROY_FACT.INSERTAR (nCodCia, nCodEmpresa, nIdBonoVentas, nIdCalculoProy, nCodNivel, 
                                                                   cCodAgente, dFecIniCalcBono, dFecFinCalcBono, nIdPoliza, Z.NumRenov, 
                                                                   F.IdFactura, F.FecSts, F.PrimaFactura, cAplicaTit, nPorcenAsegTitRec);
                           END LOOP;
                        END IF;

                        IF cTieneFacturas = 'S' THEN
                           IF NVL(W.IndEmisionNueva,'N') = 'S' AND Z.NumRenov = 0 THEN
                              nCantPolizas := NVL(nCantPolizas,0) + 1;
                           ELSIF NVL(W.IndRenovacion,'N') = 'S' AND Z.NumRenov > 0 THEN
                              nCantPolizas  := NVL(nCantPolizas,0) + 1;
                              nCantPolRenov := NVL(nCantPolRenov,0) + 1;
                           END IF;
                        END IF;
                              
                        -- Acumula Siniestros
                        SELECT NVL(nReservaSiniestro,0) + NVL(SUM(Monto_Reserva_Moneda),0)
                          INTO nReservaSiniestro
                          FROM SINIESTRO
                         WHERE CodCia     = nCodCia
                           AND IdPoliza   = nIdPoliza;
                               
                        -- Determina Meses Productivos
                        IF NVL(nMesesProd,0) = 0 THEN
                           nMesInicial  := TO_NUMBER(TO_CHAR(Z.FecIniVig,'MM'));
                           nMesesProd   := NVL(nMesesProd,0) + 1;
                        ELSIF TO_NUMBER(TO_CHAR(Z.FecIniVig,'MM')) > NVL(nMesInicial,0) THEN
                           nMesInicial  := TO_NUMBER(TO_CHAR(Z.FecIniVig,'MM'));
                           nMesesProd   := NVL(nMesesProd,0) + 1;
                        END IF;
                     END IF;
                  END LOOP;
               ELSE
                  FOR Z IN PROD_Q LOOP
                     nIdPoliza    := Z.IdPoliza;
                     IF GT_BONOS_AGENTES_CALCULO.INCLUYE_POLIZA(nCodCia, nCodEmpresa, nIdPoliza, cCodAgente, 
                                                                W.IndEmisionNueva, W.IndRenovacion, Z.NumRenov) = 'S' THEN
                        cTieneFacturas := 'N';
                        FOR F IN FACT_Q LOOP
                           cTieneFacturas := 'S';
                           cAplicaTit := GT_BONOS_AGENTES_CALCULO.APLICA_ASEG_TITULAR(nCodCia, nCodEmpresa, nIdPoliza, W.IndAsegTitulares,
                                                                                      nEdadIniAsegTit, nEdadFinAsegTit);
                           IF cAplicaTit = 'N' THEN
                              nProdPrimaNeta    := NVL(nProdPrimaNeta,0) + NVL(F.PrimaFactura,0);
                              nPorcenAsegTitRec := 0;
                           ELSE
                              nPrimaNetaAsegTit := NVL(nPrimaNetaAsegTit,0) + NVL(F.PrimaFactura,0);
                              nBonoAsegTit      := NVL(nBonoAsegTit,0) + (NVL(F.PrimaFactura,0) * (nPorcenAsegTit / 100));
                              nProdPrimaNeta    := NVL(nProdPrimaNeta,0) + NVL(F.PrimaFactura,0);-- + (NVL(F.MtoDetAcreMoneda,0) * (nPorcenAsegTit / 100));
                              nPorcenAsegTitRec := nPorcenAsegTit;
                           END IF;
                                 
                           IF nIdCalculoProy IS NULL THEN
                              GT_BONOS_AGENTES_FACTURAS.INSERTAR (nCodCia, nCodEmpresa, nIdBonoVentas, nCodNivel, cCodAgente,
                                                                  dFecIniCalcBono, dFecFinCalcBono, nIdPoliza, Z.NumRenov, 
                                                                  F.IdFactura, F.FecPago, F.PrimaFactura, cAplicaTit, nPorcenAsegTitRec);
                           END IF;
                        END LOOP;
                        -- FACTURAS QUE NO JUEGAN PARA CALCULO --- PROYECCIONES
                        IF nIdCalculoProy IS NOT NULL THEN
                           FOR F IN NBFACT_Q LOOP
                              cAplicaTit := GT_BONOS_AGENTES_CALCULO.APLICA_ASEG_TITULAR(nCodCia, nCodEmpresa, nIdPoliza, W.IndAsegTitulares,
                                                                                         nEdadIniAsegTit, nEdadFinAsegTit);
                              IF cAplicaTit = 'N' THEN
                                 nPorcenAsegTitRec := 0;
                              ELSE
                                 nPorcenAsegTitRec := nPorcenAsegTit;
                              END IF;
                                    
                              GT_BONOS_AGENTES_PROY_FACT.INSERTAR (nCodCia, nCodEmpresa, nIdBonoVentas, nIdCalculoProy, nCodNivel, 
                                                                   cCodAgente, dFecIniCalcBono, dFecFinCalcBono, nIdPoliza, Z.NumRenov, 
                                                                   F.IdFactura, F.FecSts, F.PrimaFactura, cAplicaTit, nPorcenAsegTitRec);
                           END LOOP;
                        END IF;
                              
                        IF cTieneFacturas = 'S' THEN
                           IF NVL(W.IndEmisionNueva,'N') = 'S' AND Z.NumRenov = 0 THEN
                              nCantPolizas := NVL(nCantPolizas,0) + 1;
                           ELSIF NVL(W.IndRenovacion,'N') = 'S' AND Z.NumRenov > 0 THEN
                              nCantPolizas  := NVL(nCantPolizas,0) + 1;
                              nCantPolRenov := NVL(nCantPolRenov,0) + 1;
                           END IF;
                        END IF;

                        -- Acumula Siniestros
                        SELECT NVL(nReservaSiniestro,0) + NVL(SUM(Monto_Reserva_Moneda),0)
                          INTO nReservaSiniestro
                          FROM SINIESTRO
                         WHERE CodCia     = nCodCia
                           AND IdPoliza   = nIdPoliza;

                        -- Determina Meses Productivos
                        IF NVL(nMesesProd,0) = 0 THEN
                           nMesInicial  := TO_NUMBER(TO_CHAR(Z.FecIniVig,'MM'));
                           nMesesProd   := NVL(nMesesProd,0) + 1;
                        ELSIF TO_NUMBER(TO_CHAR(Z.FecIniVig,'MM')) > NVL(nMesInicial,0) THEN
                           nMesInicial  := TO_NUMBER(TO_CHAR(Z.FecIniVig,'MM'));
                           nMesesProd   := NVL(nMesesProd,0) + 1;
                        END IF;
                     END IF;
                  END LOOP;
               END IF;
               IF NVL(nProdPrimaNeta,0) > 0 THEN
                  nPorcenSiniest   := NVL(nReservaSiniestro,0) / NVL(nProdPrimaNeta,0);
               END IF;

               IF W.ReglaBono = 'PRINET' THEN
                  nRangoAlcanzando := NVL(nProdPrimaNeta,0);
               ELSIF W.ReglaBono = 'MESPRO' THEN -- CALCULAR MESES PRODUCTIVOS
                  nRangoAlcanzando := NVL(nMesesProd,0);
               ELSIF W.ReglaBono = 'PORCON' THEN  -- CALCULAR CONSERVACION
                  IF NVL(nTotPolAnt,0) > 0 THEN
                     nRangoAlcanzando := NVL(nCantPolRenov,0) * 100 / NVL(nTotPolAnt,0);
                  ELSE 
                     nRangoAlcanzando := 0;
                  END IF;
               ELSIF W.ReglaBono = 'SINIES' THEN --- CALCULAR SINIESTRALIDAD
                  IF NVL(nProdPrimaNeta,0) > 0 THEN
                     nPorcenSiniest   := NVL(nReservaSiniestro,0) / NVL(nProdPrimaNeta,0);
                  END IF;
                  nRangoAlcanzando := NVL(nPorcenSiniest,0);
               ELSE
                  nRangoAlcanzando := NVL(nProdPrimaNeta,0);
               END IF;

               IF NVL(nProdPrimaNeta,0) >= NVL(W.ProducMinimaBono,0) AND
                  NVL(nCantPolizas,0) >= NVL(W.MinimoPolizas,0) THEN
                  nTotalBono := GT_BONOS_AGENTES_RANGOS.MONTO_BONO(nCodCia, nCodEmpresa, nIdBonoVentas, dFecFinCalcBono, nRangoAlcanzando,
                                                                   nProdPrimaNeta, nPorcenPromotoria, nPorcenBono, nBonoAsegTit);
                  IF NVL(nTotalBono,0) > 0 THEN
                     IF nIdCalculoProy IS NULL THEN
                         GT_BONOS_AGENTES_CALCULO.INSERTA_BONO_CALCULADO(nCodCia, nCodEmpresa, nIdBonoVentas, nCodNivel, cCodAgente, dFecIniCalcBono,
                                                                         dFecFinCalcBono,  cTipoBonoConv ,nProdPrimaNeta, nCantPolizas, nMesesProd,
                                                                         nCantAgentesProdAct, nPorcenSiniest, nPorcenBono, nPorcenPromotoria,
                                                                         nPrimaNetaAsegTit, nPorcenAsegTit, nTotalBono);
                     ELSE
                         GT_BONOS_AGENTES_PROYECCION.INSERTA_BONO_CALCULADO(nCodCia, nCodEmpresa, nIdCalculoProy, nIdBonoVentas, nCodNivel, cCodAgente, dFecIniCalcBono, 
                                                                            dFecFinCalcBono, nProdPrimaNeta, nCantPolizas, nMesesProd, 
                                                                            nCantAgentesProdAct, nPorcenSiniest, nPorcenBono);
                         GT_BONOS_AGENTES_PROYECCION.CALCULO_PROYECCIONES(nCodCia, nCodEmpresa, nIdCalculoProy, nIdBonoVentas);
                     END IF;
                  ELSE
                     IF nIdCalculoProy IS NULL THEN
                         GT_BONOS_AGENTES_FACTURAS.ELIMINAR(nCodCia, nCodEmpresa, nIdBonoVentas, nCodNivel, 
                                                            cCodAgente, dFecIniCalcBono, dFecFinCalcBono);
                     END IF;
                  END IF;
               ELSE
                  IF nIdCalculoProy IS NULL THEN
                      GT_BONOS_AGENTES_FACTURAS.ELIMINAR(nCodCia, nCodEmpresa, nIdBonoVentas, nCodNivel, 
                                                         cCodAgente, dFecIniCalcBono, dFecFinCalcBono);
                  ELSE
                     GT_BONOS_AGENTES_PROYECCION.INSERTA_BONO_CALCULADO(nCodCia, nCodEmpresa, nIdCalculoProy, nIdBonoVentas, nCodNivel, cCodAgente, dFecIniCalcBono, 
                                                                        dFecFinCalcBono, nProdPrimaNeta, nCantPolizas, nMesesProd, 
                                                                        nCantAgentesProdAct, nPorcenSiniest, nPorcenBono);
                     GT_BONOS_AGENTES_PROYECCION.CALCULO_PROYECCIONES(nCodCia, nCodEmpresa, nIdCalculoProy, nIdBonoVentas);
                  END IF;
               END IF;
            END IF;
            -- CALCULA DETALLE DE BONO (CONCEPTOS)
            IF nIdCalculoProy IS NULL AND NVL(nTotalBono,0) > 0 THEN
               GT_BONOS_AGENTES_CALCULO_DET.CALCULO_DETALLE(nCodCia, nCodEmpresa, nIdBonoVentas, nCodNivel,
                                                            cCodAgente, dFecIniCalcBono, dFecFinCalcBono, nTotalBono);
            END IF;
         ELSE
            -- CALCULO CONVENCION
            nCodNivel         := X.CodNivel;
            cCodAgente        := X.CodAgente;
            IF NVL(W.IndPolEspecificas,'N') = 'S' THEN
               FOR Z IN POL_Q LOOP
                  DBMS_OUTPUT.PUT_LINE('CALCULANDO CONVENCION POR POLIZAS ESPECIFICAS.....');
               END LOOP;
            ELSE
               FOR Z IN PROD_Q LOOP
                  nIdPoliza    := Z.IdPoliza;
                  IF GT_BONOS_AGENTES_CALCULO.INCLUYE_POLIZA(nCodCia, nCodEmpresa, nIdPoliza, cCodAgente, 
                                                             W.IndEmisionNueva, W.IndRenovacion, Z.NumRenov) = 'S' THEN
                     cTieneFacturas := 'N';
                     FOR F IN FACT_Q LOOP
                        cTieneFacturas := 'S';
                        nProdPrimaNeta    := NVL(nProdPrimaNeta,0) + NVL(F.PrimaFactura,0);
                        nPorcenAsegTitRec := 0;
                        DBMS_OUTPUT.PUT_LINE('CALCULANDO PRIMA DE FACTURA |'||F.IDFACTURA||'| PARA CONVENCION POR NEGOCIOS DE PRIMAS.....');
                        GT_BONOS_AGENTES_FACTURAS.INSERTAR (nCodCia, nCodEmpresa, nIdBonoVentas, nCodNivel, cCodAgente,
                                                                  dFecIniCalcBono, dFecFinCalcBono, nIdPoliza, Z.NumRenov, 
                                                                  F.IdFactura, F.FecPago, F.PrimaFactura, cAplicaTit, nPorcenAsegTitRec);
                     END LOOP;
                     
                     IF cTieneFacturas = 'S' THEN
                        IF NVL(W.IndEmisionNueva,'N') = 'S' AND Z.NumRenov = 0 THEN
                           nCantPolizas := NVL(nCantPolizas,0) + 1;
                        ELSIF NVL(W.IndRenovacion,'N') = 'S' AND Z.NumRenov > 0 THEN
                           nCantPolizas  := NVL(nCantPolizas,0) + 1;
                           nCantPolRenov := NVL(nCantPolRenov,0) + 1;
                        END IF;
                     END IF;
                     
                     -- Acumula Siniestros
                     SELECT NVL(nReservaSiniestro,0) + NVL(SUM(Monto_Reserva_Moneda),0)
                       INTO nReservaSiniestro
                       FROM SINIESTRO
                      WHERE CodCia     = nCodCia
                        AND IdPoliza   = nIdPoliza;

                     -- Determina Meses Productivos
                     IF NVL(nMesesProd,0) = 0 THEN
                        nMesInicial  := TO_NUMBER(TO_CHAR(Z.FecIniVig,'MM'));
                        nMesesProd   := NVL(nMesesProd,0) + 1;
                     ELSIF TO_NUMBER(TO_CHAR(Z.FecIniVig,'MM')) > NVL(nMesInicial,0) THEN
                        nMesInicial  := TO_NUMBER(TO_CHAR(Z.FecIniVig,'MM'));
                        nMesesProd   := NVL(nMesesProd,0) + 1;
                     END IF; 
                  END IF;
               END LOOP;
            END IF;
            IF NVL(nProdPrimaNeta,0) > 0 THEN
               nPorcenSiniest   := NVL(nReservaSiniestro,0) / NVL(nProdPrimaNeta,0);
            END IF;
            
            IF W.ReglaBono = 'PRINET' THEN
               nRangoAlcanzando := NVL(nProdPrimaNeta,0);
            ELSIF W.ReglaBono = 'SINIES' THEN --- CALCULAR SINIESTRALIDAD
               IF NVL(nProdPrimaNeta,0) > 0 THEN
                  nPorcenSiniest   := NVL(nReservaSiniestro,0) / NVL(nProdPrimaNeta,0);
               END IF;
               nRangoAlcanzando := NVL(nPorcenSiniest,0);
            ELSE
               nRangoAlcanzando := NVL(nProdPrimaNeta,0);
            END IF;
            
            IF NVL(nProdPrimaNeta,0) >= NVL(W.ProducMinimaBono,0) AND
               NVL(nPorcenSiniest,0) <= W.PorcSiniestralidad THEN
               GT_BONOS_AGENTES_CALCULO.INSERTA_BONO_CALCULADO(nCodCia, nCodEmpresa, nIdBonoVentas, nCodNivel, cCodAgente, dFecIniCalcBono,
                                                               dFecFinCalcBono,  cTipoBonoConv ,nProdPrimaNeta, nCantPolizas, nMesesProd,
                                                               nCantAgentesProdAct, nPorcenSiniest, nPorcenBono, nPorcenPromotoria,
                                                               nPrimaNetaAsegTit, nPorcenAsegTit, 0);
            ELSE
               GT_BONOS_AGENTES_FACTURAS.ELIMINAR(nCodCia, nCodEmpresa, nIdBonoVentas, nCodNivel, 
                                                  cCodAgente, dFecIniCalcBono, dFecFinCalcBono);
            END IF;
         END IF; ---- VALIDA cTipoBonoConv
      END LOOP;
   END LOOP;
END CALCULO_BONOS;

FUNCTION APLICA_ASEG_TITULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, cIndAsegTitulares VARCHAR2, 
                             nEdadIniAsegTit NUMBER, nEdadFinAsegTit NUMBER) RETURN VARCHAR2 IS
cIndEdadActuarial  VARCHAR2(1);
nEdad              NUMBER(5);
cAplica            VARCHAR2(1);

CURSOR ASEG_Q IS
   SELECT OC_ASEGURADO.EDAD_ASEGURADO(CodCia, CodEmpresa, Cod_Asegurado, FecIniVig) Edad
     FROM DETALLE_POLIZA
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND IdPoliza   = nIdPoliza
    UNION
   SELECT OC_ASEGURADO.EDAD_ASEGURADO(D.CodCia, D.CodEmpresa, A.Cod_Asegurado, D.FecIniVig) Edad
     FROM ASEGURADO_CERTIFICADO A, DETALLE_POLIZA D
    WHERE A.IDetPol    = D.IDetPol
      AND A.IdPoliza   = D.IdPoliza
      AND A.CodCia     = D.CodCia
      AND D.CodCia     = nCodCia
      AND D.CodEmpresa = nCodEmpresa
      AND D.IdPoliza   = nIdPoliza;
BEGIN
   IF cIndAsegTitulares = 'N' THEN
      cAplica := 'N';
   ELSE
      cAplica := 'N';
      FOR W IN ASEG_Q LOOP
         IF W.Edad BETWEEN nEdadIniAsegTit AND nEdadFinAsegTit THEN
            cAplica := 'S';
            EXIT;
         END IF;
      END LOOP;
   END IF;
   RETURN(cAplica);
END APLICA_ASEG_TITULAR;

FUNCTION INCLUYE_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, cCodAgente VARCHAR2, 
                        cIndEmisionNueva VARCHAR2, cIndRenovacion VARCHAR2, nNumRenov NUMBER) RETURN VARCHAR2 IS
cIncluyePol   VARCHAR2(1) := 'N';
cPolizaAgente VARCHAR2(1) := 'N';

BEGIN
   BEGIN
      SELECT 'S'
        INTO cPolizaAgente
        FROM AGENTES_DISTRIBUCION_POLIZA
       WHERE CodCia            = nCodCia
         AND IdPoliza          = nIdPoliza
         AND Cod_Agente_Distr  = cCodAgente;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cPolizaAgente := 'N';
      WHEN TOO_MANY_ROWS THEN
         cPolizaAgente := 'S';
   END;

   IF cPolizaAgente = 'S' THEN
      IF NVL(cIndEmisionNueva,'N') = 'S' AND nNumRenov = 0 THEN
         cIncluyePol := 'S';
      ELSIF NVL(cIndRenovacion,'N') = 'S' AND nNumRenov > 0 THEN
         cIncluyePol := 'S';
      ELSE
         cIncluyePol := 'N';
      END IF;
   ELSE
      cIncluyePol := 'N';
   END IF;
   RETURN(cIncluyePol);
END INCLUYE_POLIZA;

PROCEDURE APLICAR_BONOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, cCodAgente VARCHAR2,
                        dFecIniCalcBono DATE, dFecFinCalcBono DATE) IS
nIdBono BONOS_AGENTES_CALCULO.IdBono%TYPE;                        
BEGIN
   nIdBono := GT_BONOS_AGENTES_CALCULO.GENERA_IDENTIFICADOR(nCodCia, nCodEmpresa);
   
   UPDATE BONOS_AGENTES_CALCULO
      SET StsCalcBono  = 'PORLIQ',
          FecStatus    = TRUNC(SYSDATE),
          IdBono       = nIdBono
    WHERE CodCia           = nCodCia 
      AND CodEmpresa       = nCodEmpresa 
      AND IdBonoVentas     = nIdBonoVentas 
      AND CodNivel         = nCodNivel
      AND CodAgente        = cCodAgente
      AND FecIniCalcBono   = dFecIniCalcBono 
      AND FecFinCalcBono   = dFecFinCalcBono;
      
   GT_BONOS_AGENTES_CALCULO_DET.ASIGNA_IDBONO(nCodCia, nCodEmpresa, nIdBonoVentas, nCodNivel, cCodAgente,
                        dFecIniCalcBono, dFecFinCalcBono, nIdBono);
END APLICAR_BONOS;

FUNCTION AGENTES_PRODUCTIVOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, cCodAgente VARCHAR2,
                             dFecIniCalcBono DATE, dFecFinCalcBono DATE, nCantAgentesProdAct IN OUT NUMBER) RETURN VARCHAR2 IS
nCantAgentesProd         BONOS_AGENTES_CONFIG.CantAgentesProd%TYPE;
nProdMinAgentesProd      BONOS_AGENTES_CONFIG.ProdMinAgentesProd%TYPE;
nProdMinAgentesProdAct   BONOS_AGENTES_CONFIG.ProdMinAgentesProd%TYPE;
nIdPoliza                BONOS_AGENTES_POLIZAS.IdPoliza%TYPE;
cCodAgenteProm           AGENTES.Cod_Agente%TYPE;
cCodNivelProm            AGENTES.CodNivel%TYPE;
cAplicaBono              VARCHAR2(1);

CURSOR AGTE_PROM_Q IS
   SELECT CodNivel, Cod_Agente
     FROM AGENTES
    WHERE Cod_Agente_Jefe  = cCodAgente
      AND Est_Agente       = 'ACT';

CURSOR POL_Q IS
   SELECT DISTINCT P.IdPoliza, P.NumRenov, P.FecIniVig
     FROM POLIZAS P, BONOS_AGENTES_POLIZAS B
    WHERE P.FecIniVig    >= dFecIniCalcBono
      AND P.FecIniVig    <= dFecFinCalcBono
      AND P.StsPoliza   NOT IN ('SOL', 'XRE')
      AND P.IdPoliza      = B.IdPoliza
      AND B.CodCia        = nCodCia
      AND B.CodEmpresa    = nCodEmpresa
      AND B.IdBonoVentas  = nIdBonoVentas
      AND EXISTS (SELECT 'S'
                    FROM AGENTES_DISTRIBUCION_POLIZA
                   WHERE CodCia            = P.CodCia
                     AND IdPoliza          = P.IdPoliza
                     AND CodNivel          = cCodNivelProm
                     AND Cod_Agente_Distr  = cCodAgenteProm);

CURSOR PROD_Q IS
   SELECT DISTINCT P.IdPoliza, P.NumRenov, P.FecIniVig
     FROM BONOS_AGENTES_TIPO_SEG B, DETALLE_POLIZA D, POLIZAS P
    WHERE B.PlanCob       = B.PlanCob
      AND B.IdTipoSeg     = D.IdTipoSeg
      AND B.IdBonoVentas  = nIdBonoVentas
      AND B.CodEmpresa    = D.CodEmpresa
      AND B.CodCia        = D.CodCia
      AND D.IDetPol       > 0
      AND D.IdPoliza      = P.IdPoliza
      AND D.CodEmpresa    = P.CodEmpresa
      AND D.CodCia        = P.CodCia
      AND P.FecIniVig    >= dFecIniCalcBono
      AND P.FecIniVig    <= dFecFinCalcBono
      AND P.StsPoliza   NOT IN ('SOL', 'XRE')
      AND P.IdPoliza      > 0
      AND P.CodEmpresa    = nCodEmpresa
      AND P.CodCia        = nCodCia
      AND EXISTS (SELECT 'S'
                    FROM AGENTES_DISTRIBUCION_POLIZA
                   WHERE CodCia            = P.CodCia
                     AND IdPoliza          = P.IdPoliza
                     AND CodNivel          = cCodNivelProm
                     AND Cod_Agente_Distr  = cCodAgenteProm);

CURSOR FACT_Q IS
   SELECT DISTINCT F.IdFactura, F.FecPago, NVL(SUM(DF.Monto_Det_Moneda), 0) PrimaFactura 
     FROM DETALLE_FACTURAS DF, FACTURAS F 
    WHERE F.CodCia     = nCodCia
      AND F.IdPoliza   = nIdPoliza
      AND F.IdFactura  > 0
      AND DF.CodCpto   IN (SELECT CodConcepto 
                             FROM CATALOGO_DE_CONCEPTOS 
                            WHERE IndCptoPrimas   = 'S' 
                               OR IndCptoServicio = 'S')
      AND F.Stsfact    != ('ANU')
      AND F.FecPago    <= dFecFinCalcBono
      AND DF.IdFactura  = F.IdFactura
    GROUP BY F.IdFactura, F.FecPago;
BEGIN
   IF nCodNivel = 2 THEN -- Promotores
      nCantAgentesProd := GT_BONOS_AGENTES_CONFIG.CANT_AGENTES_PROD(nCodCia, nCodEmpresa, nIdBonoVentas);
      IF NVL(nCantAgentesProd,0) = 0 THEN
         cAplicaBono := 'S';
      ELSE
         nCantAgentesProdAct := 0;
         nProdMinAgentesProd := GT_BONOS_AGENTES_CONFIG.PROD_MINIMA_AGENTES(nCodCia, nCodEmpresa, nIdBonoVentas);
         FOR W IN AGTE_PROM_Q LOOP
            cCodNivelProm        := W.CodNivel;
            cCodAgenteProm       := W.Cod_Agente;
            nProdMinAgentesProdAct := 0;
            IF GT_BONOS_AGENTES_CONFIG.INDICADORES(nCodCia, nCodEmpresa, nIdBonoVentas, 'BPE') = 'S' THEN
               FOR Z IN POL_Q LOOP
                  nIdPoliza      := Z.IdPoliza;
                  FOR F IN FACT_Q LOOP
                     nProdMinAgentesProdAct := NVL(nProdMinAgentesProdAct,0) + NVL(F.PrimaFactura,0);
                  END LOOP;
               END LOOP;
            ELSE
               FOR Z IN PROD_Q LOOP
                  nIdPoliza      := Z.IdPoliza;
                  FOR F IN FACT_Q LOOP
                     nProdMinAgentesProdAct := NVL(nProdMinAgentesProdAct,0) + NVL(F.PrimaFactura,0);
                  END LOOP;
               END LOOP;
            END IF;
            
            IF nProdMinAgentesProdAct >= nProdMinAgentesProd THEN 
               nCantAgentesProdAct := NVL(nCantAgentesProdAct,0) + 1;
            END IF;
         END LOOP;
         IF NVL(nCantAgentesProdAct,0) >= NVL(nCantAgentesProd,0) THEN
            cAplicaBono := 'S';
         ELSE
            cAplicaBono := 'N';
         END IF;
      END IF;
   ELSE
      cAplicaBono := 'S';
   END IF;
   RETURN(cAplicaBono);
END AGENTES_PRODUCTIVOS;

FUNCTION MONTO_PROYECCION_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, cCodAgente VARCHAR2) RETURN NUMBER IS
    nMontoProyeccion NUMBER(28,2);
BEGIN
    RETURN nMontoProyeccion;
END MONTO_PROYECCION_BONO;

PROCEDURE LIQUIDA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE) IS
BEGIN
   UPDATE BONOS_AGENTES_CALCULO
      SET StsCalcBono = 'LIQUID',
          FecStatus   = TRUNC(SYSDATE)
    WHERE CodCia           = nCodCia 
      AND CodEmpresa       = nCodEmpresa 
      AND IdBonoVentas     = nIdBonoVentas 
      AND CodNivel         = nCodNivel 
      AND CodAgente        = cCodAgente 
      AND FecIniCalcBono   = dFecIniCalcBono 
      AND FecFinCalcBono   = dFecFinCalcBono;
END LIQUIDA;

PROCEDURE ASIGNA_NOMINA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE, nIdNomina NUMBER) IS
BEGIN
   UPDATE BONOS_AGENTES_CALCULO
      SET IdNomina = nIdNomina
    WHERE CodCia           = nCodCia 
      AND CodEmpresa       = nCodEmpresa 
      AND IdBonoVentas     = nIdBonoVentas 
      AND CodNivel         = nCodNivel 
      AND CodAgente        = cCodAgente 
      AND FecIniCalcBono   = dFecIniCalcBono 
      AND FecFinCalcBono   = dFecFinCalcBono;
END ASIGNA_NOMINA;

PROCEDURE ENVIA_CARTA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodAgente VARCHAR2, cDirectorio VARCHAR2, cNomArchivo VARCHAR2) IS
   cEmailAgente            CORREOS_ELECTRONICOS_PNJ.Email%TYPE;
   cEmailCC                USUARIOS.Email%TYPE;
   cEmailAuth              VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'021');--OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'042');
   cPwdEmail               VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'022');--OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'043');
   cEmailEnvio             VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'042');
   cError                  VARCHAR2(3000);
   cSubject                VARCHAR2(1000);
   cMessage                VARCHAR2(3000);
   cHTMLHeader             VARCHAR2(2000) := '<html><head><meta http-equiv="Content-Language" content="en-us" />'             ||CHR(13)||
                                                '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252" />'||CHR(13)||
                                                '</head><body>'                                                               ||CHR(13);
   cHTMLFooter             VARCHAR2(100)  := '</body></html>';
   cSaltoLinea             VARCHAR2(5)    := '<br>';
   cTextoImportanteOpen    VARCHAR2(10)   := '<strong>';
   cTextoImportanteClose   VARCHAR2(10)   := '</strong>';
BEGIN
   BEGIN
      SELECT OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(A.Tipo_Doc_Identificacion, A.Num_Doc_Identificacion)
        INTO cEmailAgente
        FROM AGENTES A,PERSONA_NATURAL_JURIDICA P
       WHERE A.CodCia                  = nCodCia
         AND A.Cod_Agente              = cCodAgente
         AND A.Tipo_Doc_Identificacion = P.Tipo_Doc_Identificacion
         AND A.Num_Doc_Identificacion  = P.Num_Doc_Identificacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'AGENTE: '||OC_AGENTES.NOMBRE_AGENTE(nCodCia, cCodAgente)||' NO Tiene Configurado Un Email Principal, Por Favor Configure Una Cuenta de Correo Principal');
   END;
   cEmailCC := OC_USUARIOS.EMAIL(nCodCia,USER);
   cSubject := 'Carta Informativa Bono Ganado '||OC_AGENTES.NOMBRE_AGENTE(nCodCia, cCodAgente);
   cMessage := cHTMLHeader                                                                                                                                                             ||
                'Estimado(a): '||OC_AGENTES.NOMBRE_AGENTE(nCodCia, cCodAgente)||cSaltoLinea||cSaltoLinea                                                                               ||
                '    '||cTextoImportanteOpen||OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)||cTextoImportanteClose||' Hace de su conocimiento, que ha sido acreedor a un Bono por sus ventas. ' ||
                'Toda la Información al Respecto se Encuentra en la Carta Adjunta a Este Correo.'||cSaltoLinea||cSaltoLinea                                                            ||
                cTextoImportanteOpen||'    Este Correo es Generado de Manera Automática, Por Favor no lo Responda.'||cTextoImportanteClose||cSaltoLinea||cSaltoLinea                   ||
                OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)||cSaltoLinea                                                                                                                                                                                   ||
                ' <img src="'||OC_ADICIONALES_EMPRESA.RUTA_LOGOTIPO(nCodCia)||'" alt="'||OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)||'" height="120" width="280"> '||cSaltoLinea||cHTMLFooter;
   
   OC_MAIL.INIT_PARAM;
   OC_MAIL.cCtaEnvio   := cEmailAuth;
   OC_MAIL.cPwdCtaEnvio:= cPwdEmail;
           
   OC_MAIL.SEND_EMAIL(cDirectorio,cEmailEnvio,TRIM(cEmailAgente),TRIM(cEmailCC),NULL,cSubject,cMessage,cNomArchivo,NULL,NULL,NULL,cError);
END ENVIA_CARTA;

END GT_BONOS_AGENTES_CALCULO;
/

--
-- GT_BONOS_AGENTES_CALCULO  (Synonym) 
--
--  Dependencies: 
--   GT_BONOS_AGENTES_CALCULO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_BONOS_AGENTES_CALCULO FOR SICAS_OC.GT_BONOS_AGENTES_CALCULO
/


GRANT EXECUTE, DEBUG ON SICAS_OC.GT_BONOS_AGENTES_CALCULO TO PUBLIC
/
