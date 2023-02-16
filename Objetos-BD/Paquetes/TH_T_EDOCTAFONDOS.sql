CREATE OR REPLACE PACKAGE          TH_T_EDOCTAFONDOS IS

PROCEDURE CARGA_RESUMEN_EDO_CTA(P_CODCIA       NUMBER,
                                P_CODEMPRESA   NUMBER,
                                P_IDPOLIZA     NUMBER,
                                P_IDETPOL      NUMBER,
                                P_CODASEGURADO NUMBER,
                                P_FE_INI       DATE,
                                P_FE_FIN       DATE);
-- 
PROCEDURE CARGA_DETALLE_FONDO(P_CODCIA       NUMBER,
                              P_CODEMPRESA   NUMBER,
                              P_IDPOLIZA     NUMBER,
                              P_IDETPOL      NUMBER,
                              P_CODASEGURADO NUMBER,
                              P_FE_INI       DATE,
                              P_FE_FIN       DATE);
--                                                            
PROCEDURE CARGA_DETALLE_FONDO_COLECTIVO(P_CODCIA       NUMBER,
                              P_CODEMPRESA   NUMBER,
                              P_IDPOLIZA     NUMBER,
                              P_IDETPOL      NUMBER,
                              P_CODASEGURADO NUMBER,
                              P_FE_INI       DATE,
                              P_FE_FIN       DATE);
--                                                            
PROCEDURE GRABA_MOVIMIENTO(P_CODCIA       NUMBER,
                           P_CODEMPRESA   NUMBER,
                           P_IDPOLIZA     NUMBER,
                           P_IDETPOL      NUMBER,
                           P_CODASEGURADO NUMBER,
                           P_ORDEN        NUMBER,
                           P_CONCEPTO     VARCHAR2,
                           P_IMPTE_CARGO  NUMBER,
                           P_IMPTE_ABONO  NUMBER,
                           P_IMPTE_SALDO  NUMBER,
                           P_IDFONDO	    NUMBER,
                           P_IDMOVIMIENTO NUMBER,
                           P_CODCPTOMOV	  VARCHAR2,
                           P_TIPOFONDO	  VARCHAR2,
                           P_FEMOVTO      DATE,
                           P_TPREPORTE    NUMBER);
--
PROCEDURE BORRA_MOVIMIENTO(P_CODCIA       NUMBER,
                           P_CODEMPRESA   NUMBER,
                           P_IDPOLIZA     NUMBER,
                           P_IDETPOL      NUMBER,
                           P_CODASEGURADO NUMBER);
--                           
FUNCTION TOTAL_POR_CPTO_MOVIMIENTO(nCodCia       NUMBER, nCodEmpresa  NUMBER, nIdPoliza     NUMBER,
                                   nIDetPol      NUMBER, nIdFondo     NUMBER, nCodAsegurado NUMBER,
                                   cCodCptoMov VARCHAR2, cTipoFondo VARCHAR2, 
                                   dFecDesde       DATE, dFecHasta     DATE  ) RETURN NUMBER;                           
--                           
END TH_T_EDOCTAFONDOS;

/

CREATE OR REPLACE PACKAGE BODY          TH_T_EDOCTAFONDOS IS
---
-- CREACION     09/09/2018                                        -- JICO
-- Adiciono la Funcion (TOTAL_POR_CPTO_MOVIMIENTO) para  
--   calcular Total de Monto por Concepto de Movimiento           -- AEVS 21092018
--- Agrego Union Select para Concepto INTHON
--     para Procedure TOTAL_POR_CPTO_MOVIMIENTO                   -- AEVS 22012019
---
PROCEDURE CARGA_RESUMEN_EDO_CTA(P_CODCIA       NUMBER,
                                P_CODEMPRESA   NUMBER,
                                P_IDPOLIZA     NUMBER,
                                P_IDETPOL      NUMBER,
                                P_CODASEGURADO NUMBER,
                                P_FE_INI       DATE,
                                P_FE_FIN       DATE) IS
 --  
 W_ORDEN        NUMBER(7);
 W_NOM_CONCEPTO VARCHAR2(200);
 W_IMPTE_CARGO  NUMBER(20,6);
 W_IMPTE_ABONO  NUMBER(20,6);
 W_IMPTE_SALDO  NUMBER(20,6);
  --
CURSOR DETALLES IS
 SELECT ROWNUM ORDEN,
        CONCEPTO,
        MONTO
  FROM (SELECT OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(F.CodCia, F.CodCptoMov) CONCEPTO, 
               NVL(SUM(F.MontoMovMoneda),0) MONTO
          FROM FAI_CONCENTRADORA_FONDO F
--               FAI_FONDOS_DETALLE_POLIZA FD,
--               FAI_MOVIMIENTOS_FONDOS FMF
         WHERE F.CodCia                = P_CODCIA
           AND F.CodEmpresa            = P_CODEMPRESA
           AND F.IdPoliza              = P_IDPOLIZA
           AND F.IDetPol               = P_IDETPOL
           AND F.CodAsegurado          = P_CODASEGURADO
           AND TRUNC(F.FECMOVIMIENTO) >= P_FE_INI
           AND TRUNC(F.FECMOVIMIENTO) <= P_FE_FIN
           AND F.STSMOVIMIENTO         = 'ACTIVO'
/*           --
           AND FD.CodCia       = F.CodCia
           AND FD.CodEmpresa   = F.CodEmpresa
           AND FD.IdPoliza     = F.IdPoliza
           AND FD.IDetPol      = F.IDetPol  
           AND FD.CodAsegurado = F.CodAsegurado
           AND FD.IDFONDO      = F.IDFONDO
           --
           AND FMF.CODCIA      = FD.CODCIA
           AND FMF.CODEMPRESA  = FD.CODEMPRESA
           AND FMF.TIPOFONDO   = FD.TIPOFONDO
           AND FMF.CODCPTOMOV  = F.CODCPTOMOV
           AND NVL(FMF.INDNOAPLICASALDO,'N') = 'N' */
         GROUP BY OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(F.CodCia, F.CodCptoMov)

         ORDER BY NVL(SUM(F.MontoMovMoneda),0) DESC
       )
;
--
BEGIN
  --
  -- SALDO INICIAL
  --
  BEGIN
    SELECT 0,
          'SALDO INICIAL DEL PERIODO',
           0,
           0,
           NVL(SUM(F.MontoMovMoneda),0)
      INTO W_ORDEN,
           W_NOM_CONCEPTO,
           W_IMPTE_CARGO,
           W_IMPTE_ABONO,
           W_IMPTE_SALDO
      FROM FAI_CONCENTRADORA_FONDO F
     WHERE F.CodCia                = P_CodCia
       AND F.CodEmpresa            = P_CodEmpresa
       AND F.IdPoliza              = P_IdPoliza
       AND F.IDetPol               = P_IDetPol
       AND F.CodAsegurado          = P_CodAsegurado
       AND TRUNC(F.FECMOVIMIENTO) <= P_Fe_Ini
       AND F.STSMOVIMIENTO         = 'ACTIVO';
  END;
  --
  TH_T_EDOCTAFONDOS.GRABA_MOVIMIENTO(P_CODCIA,  P_CODEMPRESA,    P_IDPOLIZA,       P_IDETPOL,      P_CODASEGURADO,
                                     W_ORDEN,   W_NOM_CONCEPTO,  W_IMPTE_CARGO,    W_IMPTE_ABONO,  W_IMPTE_SALDO,
                                     '',        '',              '',               '',             '',
                                     1);
  DBMS_OUTPUT.PUT_LINE(W_ORDEN||' - '||W_NOM_CONCEPTO||' - '||W_IMPTE_SALDO);
  --  
  FOR D IN DETALLES LOOP
      --
      W_IMPTE_CARGO := 0;
      W_IMPTE_ABONO := 0;
      IF D.MONTO < 0 THEN 
         W_IMPTE_CARGO := D.MONTO;
      ELSE
         W_IMPTE_ABONO := D.MONTO;
      END IF;
      --
      W_IMPTE_SALDO := W_IMPTE_SALDO + D.MONTO;
      --
      TH_T_EDOCTAFONDOS.GRABA_MOVIMIENTO(P_CODCIA,  P_CODEMPRESA,    P_IDPOLIZA,       P_IDETPOL,      P_CODASEGURADO,
                                         D.ORDEN,   D.CONCEPTO,      W_IMPTE_CARGO,    W_IMPTE_ABONO,  W_IMPTE_SALDO,
                                         '',        '',              '',               '',             '',
                                         1);
      DBMS_OUTPUT.PUT_LINE(D.ORDEN||' - '||D.CONCEPTO||' - '||D.MONTO);
      --
  END LOOP;
  --
  BEGIN
    SELECT 1000,
          'SALDO FINAL DEL PERIODO',
           0,
           0,
           NVL(SUM(F.MontoMovMoneda),0)
      INTO W_ORDEN,
           W_NOM_CONCEPTO,
           W_IMPTE_CARGO,
           W_IMPTE_ABONO,
           W_IMPTE_SALDO
      FROM FAI_CONCENTRADORA_FONDO F
     WHERE F.CodCia                = P_CodCia
       AND F.CodEmpresa            = P_CodEmpresa
       AND F.IdPoliza              = P_IdPoliza
       AND F.IDetPol               = P_IDetPol
       AND F.CodAsegurado          = P_CodAsegurado
       AND TRUNC(F.FECMOVIMIENTO) <= P_Fe_Fin
       AND F.STSMOVIMIENTO         = 'ACTIVO';
  END; 
  --
  TH_T_EDOCTAFONDOS.GRABA_MOVIMIENTO(P_CODCIA,  P_CODEMPRESA,    P_IDPOLIZA,       P_IDETPOL,      P_CODASEGURADO,
                                     W_ORDEN,   W_NOM_CONCEPTO,  W_IMPTE_CARGO,    W_IMPTE_ABONO,  W_IMPTE_SALDO,
                                     '',        '',              '',               '',             '',
                                     1);
  DBMS_OUTPUT.PUT_LINE(W_ORDEN||' - '||W_NOM_CONCEPTO||' - '||W_IMPTE_SALDO);
  --
END CARGA_RESUMEN_EDO_CTA;
--
--
--
PROCEDURE CARGA_DETALLE_FONDO(P_CODCIA       NUMBER,
                              P_CODEMPRESA   NUMBER,
                              P_IDPOLIZA     NUMBER,
                              P_IDETPOL      NUMBER,
                              P_CODASEGURADO NUMBER,
                              P_FE_INI       DATE,
                              P_FE_FIN       DATE) IS
 --  
 W_ORDEN        NUMBER(7);
 W_NOM_CONCEPTO VARCHAR2(200);
 W_IMPTE_CARGO  FAI_FONDOS_DETALLE_POLIZA.MTOAPORTEINILOCAL%TYPE;
 W_IMPTE_ABONO  FAI_FONDOS_DETALLE_POLIZA.MTOAPORTEINILOCAL%TYPE;
 W_IMPTE_SALDO  FAI_FONDOS_DETALLE_POLIZA.MTOAPORTEINILOCAL%TYPE;
 W_TIPOFONDO    FAI_FONDOS_DETALLE_POLIZA.TIPOFONDO%TYPE; 
 W_IDFONDO      FAI_FONDOS_DETALLE_POLIZA.IDFONDO%TYPE;
 W_IDMOVIMIENTO FAI_CONCENTRADORA_FONDO.IDMOVIMIENTO%TYPE;
 W_CODCPTOMOV   FAI_CONCENTRADORA_FONDO.CODCPTOMOV%TYPE;
  --
CURSOR FONDOS IS
SELECT FD.TIPOFONDO
  FROM FAI_FONDOS_DETALLE_POLIZA FD
 WHERE FD.CodCia       = P_CODCIA
   AND FD.CodEmpresa   = P_CODEMPRESA
   AND FD.IdPoliza     = P_IDPOLIZA
   AND FD.IDetPol      = P_IDETPOL
   AND FD.CodAsegurado = P_CODASEGURADO
;
--  
CURSOR DETALLES IS
 SELECT ROWNUM ORDEN,
        CONCEPTO,
        MONTO,
        FECHA,
        FONDO
  FROM (SELECT CONCEPTO,
               MONTO,
               FECHA,
               FONDO
          FROM (SELECT OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(F.CodCia, F.CodCptoMov) CONCEPTO, 
                       NVL(SUM(F.MontoMovMoneda),0) MONTO,
                       MAX(F.FECMOVIMIENTO) FECHA,
                       F.IDFONDO            FONDO
                  FROM FAI_CONCENTRADORA_FONDO F,
                       FAI_FONDOS_DETALLE_POLIZA FD
                 WHERE F.CodCia                = P_CODCIA
                   AND F.CodEmpresa            = P_CODEMPRESA
                   AND F.IdPoliza              = P_IDPOLIZA
                   AND F.IDetPol               = P_IDETPOL
                   AND F.CodAsegurado          = P_CODASEGURADO
                   AND TRUNC(F.FECMOVIMIENTO) >= P_FE_INI
                   AND TRUNC(F.FECMOVIMIENTO) <= P_FE_FIN
                   AND F.CODCPTOMOV           IN ('INTFON','RETISR')
                   AND F.STSMOVIMIENTO         = 'ACTIVO'
                   --
                   AND FD.CodCia       = F.CodCia
                   AND FD.CodEmpresa   = F.CodEmpresa
                   AND FD.IdPoliza     = F.IdPoliza
                   AND FD.IDetPol      = F.IDetPol  
                   AND FD.CodAsegurado = F.CodAsegurado
                   AND FD.IDFONDO      = F.IDFONDO
                   AND FD.TIPOFONDO    = W_TIPOFONDO 
                 GROUP BY OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(F.CodCia, F.CodCptoMov),
                          F.IDFONDO
                --
                UNION
                --
                SELECT OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(F.CodCia, F.CodCptoMov) CONCEPTO, 
                       NVL(F.MontoMovMoneda,0) MONTO,
                       F.FECMOVIMIENTO      FECHA,
                       F.IDFONDO            FONDO
                  FROM FAI_CONCENTRADORA_FONDO F,
                       FAI_FONDOS_DETALLE_POLIZA FD
                 WHERE F.CodCia                = P_CODCIA
                   AND F.CodEmpresa            = P_CODEMPRESA
                   AND F.IdPoliza              = P_IDPOLIZA
                   AND F.IDetPol               = P_IDETPOL
                   AND F.CodAsegurado          = P_CODASEGURADO
                   AND TRUNC(F.FECMOVIMIENTO) >= P_FE_INI
                   AND TRUNC(F.FECMOVIMIENTO) <= P_FE_FIN
                   AND F.CODCPTOMOV           NOT IN ('INTFON','RETISR')
                   AND F.STSMOVIMIENTO         = 'ACTIVO'
                   --
                   AND FD.CodCia       = F.CodCia
                   AND FD.CodEmpresa   = F.CodEmpresa
                   AND FD.IdPoliza     = F.IdPoliza
                   AND FD.IDetPol      = F.IDetPol  
                   AND FD.CodAsegurado = F.CodAsegurado
                   AND FD.IDFONDO      = F.IDFONDO
                   AND FD.TIPOFONDO    = W_TIPOFONDO 
                )
          ORDER BY FECHA,
                   MONTO DESC
       )
 ;
--
BEGIN
  FOR F IN FONDOS LOOP
      W_TIPOFONDO    := F.TIPOFONDO;
      W_IDMOVIMIENTO := '';
      W_CODCPTOMOV   := '';
      --
      -- SALDO INICIAL
      --
      BEGIN
        SELECT 0,
               'SALDO INICIAL DEL PERIODO',
               0,
               0,
               NVL(SUM(FC.MontoMovMoneda),0),
               FC.IDFONDO
          INTO W_ORDEN,
               W_NOM_CONCEPTO,
               W_IMPTE_CARGO,
               W_IMPTE_ABONO,
               W_IMPTE_SALDO,
               W_IDFONDO
          FROM FAI_CONCENTRADORA_FONDO FC,
               FAI_FONDOS_DETALLE_POLIZA FD
         WHERE FC.CodCia                = P_CodCia
           AND FC.CodEmpresa            = P_CodEmpresa
           AND FC.IdPoliza              = P_IdPoliza
           AND FC.IDetPol               = P_IDetPol
           AND FC.CodAsegurado          = P_CodAsegurado
           AND TRUNC(FC.FECMOVIMIENTO) <= P_Fe_Ini
           AND FC.STSMOVIMIENTO         = 'ACTIVO'
           --
           AND FD.CodCia       = FC.CodCia
           AND FD.CodEmpresa   = FC.CodEmpresa
           AND FD.IdPoliza     = FC.IdPoliza
           AND FD.IDetPol      = FC.IDetPol  
           AND FD.CodAsegurado = FC.CodAsegurado
           AND FD.IDFONDO      = FC.IDFONDO
           AND FD.TIPOFONDO    = W_TIPOFONDO
         GROUP BY FC.IDFONDO,
                  FC.IDMOVIMIENTO,
                  FC.CODCPTOMOV;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             W_ORDEN        := 0;
             W_NOM_CONCEPTO := 'SALDO INICIAL DEL PERIODO';
             W_IMPTE_CARGO  := 0;
             W_IMPTE_ABONO  := 0;
             W_IMPTE_SALDO  := 0;
             W_IDFONDO      := '';
        WHEN OTHERS THEN
             W_ORDEN        := 0;
             W_NOM_CONCEPTO := 'SALDO INICIAL DEL PERIODO';
             W_IMPTE_CARGO  := 0;
             W_IMPTE_ABONO  := 0;
             W_IMPTE_SALDO  := 0;
             W_IDFONDO      := '';             
      END;
      --
      TH_T_EDOCTAFONDOS.GRABA_MOVIMIENTO(P_CODCIA,  P_CODEMPRESA,    P_IDPOLIZA,       P_IDETPOL,      P_CODASEGURADO,
                                         W_ORDEN,   W_NOM_CONCEPTO,  W_IMPTE_CARGO,    W_IMPTE_ABONO,  W_IMPTE_SALDO,
                                         W_IDFONDO, W_IDMOVIMIENTO,  W_CODCPTOMOV,     W_TIPOFONDO,    P_Fe_Ini,
                                         2);
      DBMS_OUTPUT.PUT_LINE(W_ORDEN||' - '||W_NOM_CONCEPTO||' - '||W_IMPTE_SALDO||' - '||W_TIPOFONDO||' - '||P_Fe_Ini);
      --  
      FOR D IN DETALLES LOOP
          --
          W_IMPTE_CARGO := 0;
          W_IMPTE_ABONO := 0;
          --
          W_IMPTE_SALDO := D.MONTO;
          --
          TH_T_EDOCTAFONDOS.GRABA_MOVIMIENTO(P_CODCIA,  P_CODEMPRESA,    P_IDPOLIZA,       P_IDETPOL,      P_CODASEGURADO,
                                             D.ORDEN,   D.CONCEPTO,      W_IMPTE_CARGO,    W_IMPTE_ABONO,  W_IMPTE_SALDO,
                                             D.FONDO,   W_IDMOVIMIENTO,  W_CODCPTOMOV,     W_TIPOFONDO,    D.FECHA,
                                             2);
          DBMS_OUTPUT.PUT_LINE(D.ORDEN||' - '||D.CONCEPTO||' - '||D.MONTO||' - '||W_TIPOFONDO||' - '||D.FECHA);
          --
      END LOOP;
      --
      BEGIN
        SELECT 1000,
               'SALDO FINAL DEL PERIODO',
               0,
               0,
               NVL(SUM(FC.MontoMovMoneda),0),
               FC.IDFONDO
          INTO W_ORDEN,
               W_NOM_CONCEPTO,
               W_IMPTE_CARGO,
               W_IMPTE_ABONO,
               W_IMPTE_SALDO,
               W_IDFONDO
          FROM FAI_CONCENTRADORA_FONDO FC,
               FAI_FONDOS_DETALLE_POLIZA FD
         WHERE FC.CodCia                = P_CodCia
           AND FC.CodEmpresa            = P_CodEmpresa
           AND FC.IdPoliza              = P_IdPoliza
           AND FC.IDetPol               = P_IDetPol
           AND FC.CodAsegurado          = P_CodAsegurado
           AND TRUNC(FC.FECMOVIMIENTO) <= P_Fe_Fin
           AND FC.STSMOVIMIENTO         = 'ACTIVO'
           --
           AND FD.CodCia       = FC.CodCia
           AND FD.CodEmpresa   = FC.CodEmpresa
           AND FD.IdPoliza     = FC.IdPoliza
           AND FD.IDetPol      = FC.IDetPol  
           AND FD.CodAsegurado = FC.CodAsegurado
           AND FD.IDFONDO      = FC.IDFONDO
           AND FD.TIPOFONDO    = W_TIPOFONDO
         GROUP BY FC.IDFONDO;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             W_ORDEN        := 1000;
             W_NOM_CONCEPTO := 'SALDO FINAL DEL PERIODO';
             W_IMPTE_CARGO  := 0;
             W_IMPTE_ABONO  := 0;
             W_IMPTE_SALDO  := 0;
             W_IDFONDO      := '';
        WHEN OTHERS THEN
             W_ORDEN        := 1000;
             W_NOM_CONCEPTO := 'SALDO FINAL DEL PERIODO';
             W_IMPTE_CARGO  := 0;
             W_IMPTE_ABONO  := 0;
             W_IMPTE_SALDO  := 0;
             W_IDFONDO      := '';            
      END; 
      --
      TH_T_EDOCTAFONDOS.GRABA_MOVIMIENTO(P_CODCIA,  P_CODEMPRESA,    P_IDPOLIZA,       P_IDETPOL,      P_CODASEGURADO,
                                         W_ORDEN,   W_NOM_CONCEPTO,  W_IMPTE_CARGO,    W_IMPTE_ABONO,  W_IMPTE_SALDO,
                                         W_IDFONDO, W_IDMOVIMIENTO,  W_CODCPTOMOV,     W_TIPOFONDO,    P_Fe_Fin,
                                         2);
      DBMS_OUTPUT.PUT_LINE(W_ORDEN||' - '||W_NOM_CONCEPTO||' - '||W_IMPTE_SALDO||' - '||W_TIPOFONDO||' - '||P_Fe_Fin);
      --
  END LOOP;
  --
END CARGA_DETALLE_FONDO;
--
--
--
PROCEDURE CARGA_DETALLE_FONDO_COLECTIVO(P_CODCIA       NUMBER,
                              P_CODEMPRESA   NUMBER,
                              P_IDPOLIZA     NUMBER,
                              P_IDETPOL      NUMBER,
                              P_CODASEGURADO NUMBER,
                              P_FE_INI       DATE,
                              P_FE_FIN       DATE) IS
 --  
 W_ORDEN        NUMBER(7);
 W_NOM_CONCEPTO VARCHAR2(200);
 W_IMPTE_CARGO  FAI_FONDOS_DETALLE_POLIZA.MTOAPORTEINILOCAL%TYPE;
 W_IMPTE_ABONO  FAI_FONDOS_DETALLE_POLIZA.MTOAPORTEINILOCAL%TYPE;
 W_IMPTE_SALDO  FAI_FONDOS_DETALLE_POLIZA.MTOAPORTEINILOCAL%TYPE;
 W_TIPOFONDO    FAI_FONDOS_DETALLE_POLIZA.TIPOFONDO%TYPE; 
 W_IDFONDO      FAI_FONDOS_DETALLE_POLIZA.IDFONDO%TYPE;
 W_IDMOVIMIENTO FAI_CONCENTRADORA_FONDO.IDMOVIMIENTO%TYPE;
 W_CODCPTOMOV   FAI_CONCENTRADORA_FONDO.CODCPTOMOV%TYPE;
  --
CURSOR FONDOS IS
SELECT FD.TIPOFONDO
  FROM FAI_FONDOS_DETALLE_POLIZA FD
 WHERE FD.CodCia       = P_CODCIA
   AND FD.CodEmpresa   = P_CODEMPRESA
   AND FD.IdPoliza     = P_IDPOLIZA
   AND FD.IDetPol      = P_IDETPOL
   AND FD.CodAsegurado = P_CODASEGURADO
;
--  
CURSOR DETALLES IS
 SELECT ROWNUM ORDEN,
        CONCEPTO,
        MONTO,
        FECHA,
        FONDO
  FROM (SELECT CONCEPTO,
               MONTO,
               FECHA,
               FONDO
          FROM (SELECT OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(F.CodCia, F.CodCptoMov) CONCEPTO, 
                       NVL(SUM(F.MontoMovMoneda),0) MONTO,
                       MAX(F.FECMOVIMIENTO) FECHA,
                       F.IDFONDO            FONDO,
                       0
                  FROM FAI_CONCENTRADORA_FONDO F,
                       FAI_FONDOS_DETALLE_POLIZA FD
                 WHERE F.CodCia                = P_CODCIA
                   AND F.CodEmpresa            = P_CODEMPRESA
                   AND F.IdPoliza              = P_IDPOLIZA
                   AND F.IDetPol               = P_IDETPOL
                   AND F.CodAsegurado          = P_CODASEGURADO
                   AND TRUNC(F.FECMOVIMIENTO) >= P_FE_INI
                   AND TRUNC(F.FECMOVIMIENTO) <= P_FE_FIN
                   AND F.CODCPTOMOV           IN ('INTFON','RETISR')
                   AND F.STSMOVIMIENTO         = 'ACTIVO'
                   --
                   AND FD.CodCia       = F.CodCia
                   AND FD.CodEmpresa   = F.CodEmpresa
                   AND FD.IdPoliza     = F.IdPoliza
                   AND FD.IDetPol      = F.IDetPol  
                   AND FD.CodAsegurado = F.CodAsegurado
                   AND FD.IDFONDO      = F.IDFONDO
                   AND FD.TIPOFONDO    = W_TIPOFONDO 
                 GROUP BY OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(F.CodCia, F.CodCptoMov),
                          F.IDFONDO
                --
                UNION
                --
                SELECT OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(F.CodCia, F.CodCptoMov) CONCEPTO, 
                       NVL(F.MontoMovMoneda,0) MONTO,
                       F.FECMOVIMIENTO      FECHA,
                       F.IDFONDO            FONDO,
                       ROWNUM
                  FROM FAI_CONCENTRADORA_FONDO F,
                       FAI_FONDOS_DETALLE_POLIZA FD
                 WHERE F.CodCia                = P_CODCIA
                   AND F.CodEmpresa            = P_CODEMPRESA
                   AND F.IdPoliza              = P_IDPOLIZA
                   AND F.IDetPol               = P_IDETPOL
                   AND F.CodAsegurado          = P_CODASEGURADO
                   AND TRUNC(F.FECMOVIMIENTO) >= P_FE_INI
                   AND TRUNC(F.FECMOVIMIENTO) <= P_FE_FIN
                   AND F.CODCPTOMOV           NOT IN ('INTFON','RETISR')
                   AND F.STSMOVIMIENTO         = 'ACTIVO'
                   --
                   AND FD.CodCia       = F.CodCia
                   AND FD.CodEmpresa   = F.CodEmpresa
                   AND FD.IdPoliza     = F.IdPoliza
                   AND FD.IDetPol      = F.IDetPol  
                   AND FD.CodAsegurado = F.CodAsegurado
                   AND FD.IDFONDO      = F.IDFONDO
                   AND FD.TIPOFONDO    = W_TIPOFONDO 
                )
          ORDER BY FECHA,
                   MONTO DESC
       )
 ;
--
BEGIN
  FOR F IN FONDOS LOOP
      W_TIPOFONDO    := F.TIPOFONDO;
      W_IDMOVIMIENTO := '';
      W_CODCPTOMOV   := '';
      --
      -- SALDO INICIAL
      --
      BEGIN
        SELECT 0,
               'SALDO INICIAL DEL PERIODO',
               0,
               0,
               NVL(SUM(FC.MontoMovMoneda),0),
               FC.IDFONDO
          INTO W_ORDEN,
               W_NOM_CONCEPTO,
               W_IMPTE_CARGO,
               W_IMPTE_ABONO,
               W_IMPTE_SALDO,
               W_IDFONDO
          FROM FAI_CONCENTRADORA_FONDO FC,
               FAI_FONDOS_DETALLE_POLIZA FD
         WHERE FC.CodCia                = P_CodCia
           AND FC.CodEmpresa            = P_CodEmpresa
           AND FC.IdPoliza              = P_IdPoliza
           AND FC.IDetPol               = P_IDetPol
           AND FC.CodAsegurado          = P_CodAsegurado
           AND TRUNC(FC.FECMOVIMIENTO) <= P_Fe_Ini
           AND FC.STSMOVIMIENTO         = 'ACTIVO'
           --
           AND FD.CodCia       = FC.CodCia
           AND FD.CodEmpresa   = FC.CodEmpresa
           AND FD.IdPoliza     = FC.IdPoliza
           AND FD.IDetPol      = FC.IDetPol  
           AND FD.CodAsegurado = FC.CodAsegurado
           AND FD.IDFONDO      = FC.IDFONDO
           AND FD.TIPOFONDO    = W_TIPOFONDO
         GROUP BY FC.IDFONDO,
                  FC.IDMOVIMIENTO,
                  FC.CODCPTOMOV;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             W_ORDEN        := 0;
             W_NOM_CONCEPTO := 'SALDO INICIAL DEL PERIODO';
             W_IMPTE_CARGO  := 0;
             W_IMPTE_ABONO  := 0;
             W_IMPTE_SALDO  := 0;
             W_IDFONDO      := '';
        WHEN OTHERS THEN
             W_ORDEN        := 0;
             W_NOM_CONCEPTO := 'SALDO INICIAL DEL PERIODO';
             W_IMPTE_CARGO  := 0;
             W_IMPTE_ABONO  := 0;
             W_IMPTE_SALDO  := 0;
             W_IDFONDO      := '';             
      END;
      --
      TH_T_EDOCTAFONDOS.GRABA_MOVIMIENTO(P_CODCIA,  P_CODEMPRESA,    P_IDPOLIZA,       P_IDETPOL,      P_CODASEGURADO,
                                         W_ORDEN,   W_NOM_CONCEPTO,  W_IMPTE_CARGO,    W_IMPTE_ABONO,  W_IMPTE_SALDO,
                                         W_IDFONDO, W_IDMOVIMIENTO,  W_CODCPTOMOV,     W_TIPOFONDO,    P_Fe_Ini,
                                         2);
      DBMS_OUTPUT.PUT_LINE(W_ORDEN||' - '||W_NOM_CONCEPTO||' - '||W_IMPTE_SALDO||' - '||W_TIPOFONDO||' - '||P_Fe_Ini);
      --  
      FOR D IN DETALLES LOOP
          --
          W_IMPTE_CARGO := 0;
          W_IMPTE_ABONO := 0;
          --
          W_IMPTE_SALDO := D.MONTO;
          --
          TH_T_EDOCTAFONDOS.GRABA_MOVIMIENTO(P_CODCIA,  P_CODEMPRESA,    P_IDPOLIZA,       P_IDETPOL,      P_CODASEGURADO,
                                             D.ORDEN,   D.CONCEPTO,      W_IMPTE_CARGO,    W_IMPTE_ABONO,  W_IMPTE_SALDO,
                                             D.FONDO,   W_IDMOVIMIENTO,  W_CODCPTOMOV,     W_TIPOFONDO,    D.FECHA,
                                             2);
          DBMS_OUTPUT.PUT_LINE(D.ORDEN||' - '||D.CONCEPTO||' - '||D.MONTO||' - '||W_TIPOFONDO||' - '||D.FECHA);
          --
      END LOOP;
      --
      BEGIN
        SELECT 1000,
               'SALDO FINAL DEL PERIODO',
               0,
               0,
               NVL(SUM(FC.MontoMovMoneda),0),
               FC.IDFONDO
          INTO W_ORDEN,
               W_NOM_CONCEPTO,
               W_IMPTE_CARGO,
               W_IMPTE_ABONO,
               W_IMPTE_SALDO,
               W_IDFONDO
          FROM FAI_CONCENTRADORA_FONDO FC,
               FAI_FONDOS_DETALLE_POLIZA FD
         WHERE FC.CodCia                = P_CodCia
           AND FC.CodEmpresa            = P_CodEmpresa
           AND FC.IdPoliza              = P_IdPoliza
           AND FC.IDetPol               = P_IDetPol
           AND FC.CodAsegurado          = P_CodAsegurado
           AND TRUNC(FC.FECMOVIMIENTO) <= P_Fe_Fin
           AND FC.STSMOVIMIENTO         = 'ACTIVO'
           --
           AND FD.CodCia       = FC.CodCia
           AND FD.CodEmpresa   = FC.CodEmpresa
           AND FD.IdPoliza     = FC.IdPoliza
           AND FD.IDetPol      = FC.IDetPol  
           AND FD.CodAsegurado = FC.CodAsegurado
           AND FD.IDFONDO      = FC.IDFONDO
           AND FD.TIPOFONDO    = W_TIPOFONDO
         GROUP BY FC.IDFONDO;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             W_ORDEN        := 1000;
             W_NOM_CONCEPTO := 'SALDO FINAL DEL PERIODO';
             W_IMPTE_CARGO  := 0;
             W_IMPTE_ABONO  := 0;
             W_IMPTE_SALDO  := 0;
             W_IDFONDO      := '';
        WHEN OTHERS THEN
             W_ORDEN        := 1000;
             W_NOM_CONCEPTO := 'SALDO FINAL DEL PERIODO';
             W_IMPTE_CARGO  := 0;
             W_IMPTE_ABONO  := 0;
             W_IMPTE_SALDO  := 0;
             W_IDFONDO      := '';            
      END; 
      --
      TH_T_EDOCTAFONDOS.GRABA_MOVIMIENTO(P_CODCIA,  P_CODEMPRESA,    P_IDPOLIZA,       P_IDETPOL,      P_CODASEGURADO,
                                         W_ORDEN,   W_NOM_CONCEPTO,  W_IMPTE_CARGO,    W_IMPTE_ABONO,  W_IMPTE_SALDO,
                                         W_IDFONDO, W_IDMOVIMIENTO,  W_CODCPTOMOV,     W_TIPOFONDO,    P_Fe_Fin,
                                         2);
      DBMS_OUTPUT.PUT_LINE(W_ORDEN||' - '||W_NOM_CONCEPTO||' - '||W_IMPTE_SALDO||' - '||W_TIPOFONDO||' - '||P_Fe_Fin);
      --
  END LOOP;
  --
END CARGA_DETALLE_FONDO_COLECTIVO;
--
--
--
PROCEDURE GRABA_MOVIMIENTO(P_CODCIA       NUMBER,
                           P_CODEMPRESA   NUMBER,
                           P_IDPOLIZA     NUMBER,
                           P_IDETPOL      NUMBER,
                           P_CODASEGURADO NUMBER,
                           P_ORDEN        NUMBER,
                           P_CONCEPTO     VARCHAR2,
                           P_IMPTE_CARGO  NUMBER,
                           P_IMPTE_ABONO  NUMBER,
                           P_IMPTE_SALDO  NUMBER,
                           P_IDFONDO	    NUMBER,
                           P_IDMOVIMIENTO NUMBER,
                           P_CODCPTOMOV	  VARCHAR2,
                           P_TIPOFONDO	  VARCHAR2,
                           P_FEMOVTO      DATE,
                           P_TPREPORTE    NUMBER) IS
--
BEGIN
  --
  INSERT INTO T_EDO_CTA_FONDOS
    (CODCIA,            CODEMPRESA,         IDPOLIZA,
     IDETPOL,           CODASEGURADO,       TPREPORTE,
     ORDEN,             NOM_CONCEPTO,       IMPTE_CARGO,
     IMPTE_ABONO,       IMPTE_SALDO,        IDFONDO,
     IDMOVIMIENTO,      CODCPTOMOV,         TIPOFONDO,
     FEMOVTO)
  VALUES
    (P_CODCIA,          P_CODEMPRESA,       P_IDPOLIZA,
     P_IDETPOL,         P_CODASEGURADO,     P_TPREPORTE,
     P_ORDEN,           P_CONCEPTO,         P_IMPTE_CARGO,
     P_IMPTE_ABONO,     P_IMPTE_SALDO,      P_IDFONDO,
     P_IDMOVIMIENTO,    P_CODCPTOMOV,       P_TIPOFONDO,
     P_FEMOVTO);
  --
  COMMIT;   
  --  
END GRABA_MOVIMIENTO;
--
--
--
PROCEDURE BORRA_MOVIMIENTO(P_CODCIA       NUMBER,
                           P_CODEMPRESA   NUMBER,
                           P_IDPOLIZA     NUMBER,
                           P_IDETPOL      NUMBER,
                           P_CODASEGURADO NUMBER) IS
--
BEGIN
  --
  DELETE T_EDO_CTA_FONDOS
    WHERE CODCIA       = P_CODCIA
      AND CODEMPRESA   = P_CODEMPRESA
      AND IDPOLIZA     = P_IDPOLIZA
      AND IDETPOL      = P_IDETPOL
      AND CODASEGURADO = P_CODASEGURADO;
  --
  COMMIT;   
  --  
END BORRA_MOVIMIENTO;
--
FUNCTION TOTAL_POR_CPTO_MOVIMIENTO(nCodCia       NUMBER, nCodEmpresa  NUMBER, nIdPoliza     NUMBER,
                                   nIDetPol      NUMBER, nIdFondo     NUMBER, nCodAsegurado NUMBER,
                                   cCodCptoMov VARCHAR2, cTipoFondo VARCHAR2, 
                                   dFecDesde       DATE, dFecHasta     DATE ) RETURN NUMBER IS
nMonto   Number;
BEGIN
-- DBMS_OUTPUT.PUT_LINE('22012019 cINICIA  poliza   '||nIdPoliza||'   Asegurado   '||nCodAsegurado||'      IdFondo  '||nIdFondo||'    CodCptoMov   '||cCodCptoMov||'    cTipoFondo  '||cTipoFondo); 
 BEGIN
   SELECT  MONTO INTO nMonto
      FROM ( SELECT MONTO
              FROM (SELECT
                       NVL(SUM(F.MontoMovMoneda),0) MONTO
                  FROM FAI_CONCENTRADORA_FONDO F,
                       FAI_FONDOS_DETALLE_POLIZA FD
                 WHERE F.CodCia                = nCodCia
                   AND F.CodEmpresa            = nCodEmpresa
                   AND F.IdPoliza              = nIdPoliza
                   AND F.IDFONDO               = nIdFondo
                   AND F.IDetPol               = nIDetPol
                   AND F.CodAsegurado          = nCodAsegurado
                   AND TRUNC(F.FECMOVIMIENTO) >= dFecDesde
                   AND TRUNC(F.FECMOVIMIENTO) <= dFecHasta
                   AND F.CODCPTOMOV           IN ('INTFON','RETISR')
                   AND F.CODCPTOMOV           =  cCodCptoMov
                   AND F.STSMOVIMIENTO         = 'ACTIVO'
                   --
                   AND FD.CodCia       = F.CodCia
                   AND FD.CodEmpresa   = F.CodEmpresa
                   AND FD.IdPoliza     = F.IdPoliza
                   AND FD.IDetPol      = F.IDetPol  
                   AND FD.CodAsegurado = F.CodAsegurado
                   AND FD.IDFONDO      = F.IDFONDO
                   AND FD.TIPOFONDO    = cTipoFondo
                 GROUP BY OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(F.CodCia, F.CodCptoMov),
                          F.IDFONDO,F.CodCptoMov
                --
                UNION
                --   --    AEVS 22012019 INTHON Estatus INFORMATIVO
				SELECT
                       NVL(SUM(F.MontoMovMoneda),0) MONTO
                  FROM FAI_CONCENTRADORA_FONDO F,
                       FAI_FONDOS_DETALLE_POLIZA FD
                 WHERE F.CodCia                = nCodCia
                   AND F.CodEmpresa            = nCodEmpresa
                   AND F.IdPoliza              = nIdPoliza
                   AND F.IDFONDO               = nIdFondo
                   AND F.IDetPol               = nIDetPol
                   AND F.CodAsegurado          = nCodAsegurado
                   AND TRUNC(F.FECMOVIMIENTO) >= dFecDesde
                   AND TRUNC(F.FECMOVIMIENTO) <= dFecHasta
                   AND F.CODCPTOMOV           IN ('INTHON')
                   AND F.CODCPTOMOV           =  cCodCptoMov
                   AND F.STSMOVIMIENTO         = 'INFORM'
                   --
                   AND FD.CodCia       = F.CodCia
                   AND FD.CodEmpresa   = F.CodEmpresa
                   AND FD.IdPoliza     = F.IdPoliza
                   AND FD.IDetPol      = F.IDetPol  
                   AND FD.CodAsegurado = F.CodAsegurado
                   AND FD.IDFONDO      = F.IDFONDO
                   AND FD.TIPOFONDO    = cTipoFondo
                 GROUP BY OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(F.CodCia, F.CodCptoMov),
                          F.IDFONDO,F.CodCptoMov
                --
                UNION
                --
                SELECT  NVL(SUM(F.MontoMovMoneda),0) MONTO
                  FROM FAI_CONCENTRADORA_FONDO F
                       ,FAI_FONDOS_DETALLE_POLIZA FD
                 WHERE F.CodCia                = nCodCia
                   AND F.CodEmpresa            = nCodEmpresa
                   AND F.IdPoliza              = nIdPoliza
                   AND F.IDFONDO               = nIdFondo
                   AND F.IDetPol               = nIDetPol
                   AND F.CodAsegurado          = nCodAsegurado
                   AND TRUNC(F.FECMOVIMIENTO) >= dFecDesde
                   AND TRUNC(F.FECMOVIMIENTO) <= dFecHasta
                   AND F.CODCPTOMOV           NOT IN ('INTFON','RETISR')
                   AND F.CODCPTOMOV           =  cCodCptoMov
                   AND F.STSMOVIMIENTO         = 'ACTIVO'
                   --
                   AND FD.CodCia       = F.CodCia
                   AND FD.CodEmpresa   = F.CodEmpresa
                   AND FD.IdPoliza     = F.IdPoliza
                   AND FD.IDetPol      = F.IDetPol  
                   AND FD.CodAsegurado = F.CodAsegurado
                   AND FD.IDFONDO      = F.IDFONDO
                   AND FD.TIPOFONDO    = cTipoFondo
                   GROUP BY OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(F.CodCia, F.CodCptoMov),
                          F.IDFONDO,F.CodCptoMov
                 ));                 
       EXCEPTION  WHEN OTHERS THEN
          nMonto := 0 ;
       END ;

--	      DBMS_OUTPUT.PUT_LINE('22012019 RETURN( '||nMonto||' )');
      RETURN(nMonto);

EXCEPTION WHEN OTHERS THEN
      nMonto:= 0 ;
      RETURN(nMonto);
END     TOTAL_POR_CPTO_MOVIMIENTO;
--
END TH_T_EDOCTAFONDOS;
