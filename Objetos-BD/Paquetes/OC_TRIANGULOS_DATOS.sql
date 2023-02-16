CREATE OR REPLACE PACKAGE OC_TRIANGULOS_DATOS IS
  PROCEDURE GENERA_TRIANGULOS(nCodCia NUMBER, nIdTriangulo NUMBER, cProdTriangulo VARCHAR2, dFecFinTriangulo DATE);
  PROCEDURE INSERTAR(nCodCia NUMBER, nIdTriangulo NUMBER, cTipoTriangulo VARCHAR2, nNumRegistro NUMBER,
                     cTxtPerTitulo VARCHAR2);
  PROCEDURE ACTUALIZAR(nCodCia NUMBER, nIdTriangulo NUMBER, cTipoTriangulo VARCHAR2, nNumRegistro NUMBER,
                       cTipo VARCHAR2, nCampo NUMBER, cValorCampo VARCHAR2);
  PROCEDURE TOTALIZAR(nCodCia NUMBER, nIdTriangulo NUMBER, nPeriodos NUMBER);
  PROCEDURE ACUMULADO(nCodCia NUMBER, nIdTriangulo NUMBER, nPeriodos NUMBER);
END OC_TRIANGULOS_DATOS;
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_TRIANGULOS_DATOS IS

PROCEDURE GENERA_TRIANGULOS(nCodCia NUMBER, nIdTriangulo NUMBER, cProdTriangulo VARCHAR2, dFecFinTriangulo DATE) IS

cTxtPerTituloMO     TRIANGULOS_DATOS.TxtPerTitulo%TYPE;
cTipoTrianguloMO    TRIANGULOS_DATOS.TipoTriangulo%TYPE := 'MO';
cTxtPerTituloSI     TRIANGULOS_DATOS.TxtPerTitulo%TYPE;
cTipoTrianguloSI    TRIANGULOS_DATOS.TipoTriangulo%TYPE := 'SI';
cTipoTrianguloSA    TRIANGULOS_DATOS.TipoTriangulo%TYPE := 'SA';
cTipoTrianguloAC    TRIANGULOS_DATOS.TipoTriangulo%TYPE := 'AC';
cTipoTrianguloSF    TRIANGULOS_DATOS.TipoTriangulo%TYPE := 'SF';
cTipoTrianguloRF    TRIANGULOS_DATOS.TipoTriangulo%TYPE := 'RF';
cTipoTrianguloFD    TRIANGULOS_DATOS.TipoTriangulo%TYPE := 'FD';
dFecIniSini         SINIESTRO.Fec_Ocurrencia%TYPE;
dFecFinSini         SINIESTRO.Fec_Ocurrencia%TYPE;
dFecIniNoti         SINIESTRO.Fec_Notificacion%TYPE;
dFecFinNoti         SINIESTRO.Fec_Notificacion%TYPE;
dFecTrimestre       SINIESTRO.Fec_Notificacion%TYPE;
nIdSiniestro        SINIESTRO.IdSiniestro%TYPE;
nIdPoliza           SINIESTRO.IdPoliza%TYPE;
nIDetPol            SINIESTRO.IDetPol%TYPE;
nTotSini            DETALLE_SINIESTRO_ASEG.Monto_Reservado_Moneda%TYPE := 0;
nTotSiniInd         DETALLE_SINIESTRO_ASEG.Monto_Reservado_Moneda%TYPE := 0;
nTotGastos          DETALLE_SINIESTRO_ASEG.Monto_Reservado_Moneda%TYPE := 0;
cCod_Moneda         SINIESTRO.Cod_Moneda%TYPE;
cProducto           VARCHAR2(5);
nTrimestres         NUMBER(5) := 24;
nMeses              NUMBER(5) := nTrimestres * 3;
nNumRegistro        NUMBER(5);
nNumRegSI           NUMBER(5);
cGenVal             VARCHAR2(2);
cCodRamo            VARCHAR2(6);

CURSOR SINI_Q IS
   SELECT S.IdSiniestro, S.IdPoliza, S.IDetPol, S.Fec_Ocurrencia, 
          S.Fec_Notificacion, S.Cod_Moneda
     FROM SINIESTRO S, DETALLE_POLIZA DP, TIPOS_DE_SEGUROS T
    WHERE T.CodCia              = DP.CodCia
      AND T.IdTipoSeg           = DP.IdTipoSeg 
      AND T.CodTipoPlan         = cCodRamo
      AND DP.IdPoliza           = S.IdPoliza
      AND DP.IDetPol            = S.IDetPol
      AND DP.CodCia             = S.CodCia
      AND S.Fec_Ocurrencia     >= dFecIniSini
      AND S.Fec_Ocurrencia      < dFecFinSini
      AND S.Fec_Notificacion   >= dFecIniNoti
      AND S.Fec_Notificacion    < dFecFinNoti
      AND S.Sts_Siniestro      != 'SOL'
      AND S.CodCia              = nCodCia;

CURSOR RESERVAS_Q IS
   SELECT NVL(SUM(Monto_Reservado_Moneda * OC_GENERALES.FUN_TASA_CAMBIO(cCod_Moneda, dFecFinTriangulo)),0) MtoReserva
     FROM COBERTURA_SINIESTRO
    WHERE IdSiniestro  = nIdSiniestro
      AND FecRes      <= dFecFinTriangulo
    UNION
   SELECT NVL(SUM(Monto_Reservado_Moneda * OC_GENERALES.FUN_TASA_CAMBIO(cCod_Moneda, dFecFinTriangulo)),0) MtoReserva
     FROM COBERTURA_SINIESTRO_ASEG
    WHERE IdSiniestro  = nIdSiniestro
      AND FecRes      <= dFecFinTriangulo;
CURSOR GASTOS_Q IS
   SELECT NVL(SUM(Monto_Reservado_Moneda * OC_GENERALES.FUN_TASA_CAMBIO(cCod_Moneda, dFecFinTriangulo)),0) MtoReserva
     FROM PAGOS_POR_OTROS_CONCEPTOS
    WHERE IdSiniestro  = nIdSiniestro
      AND StsPago     NOT IN ('SOL','ANU');
BEGIN
   IF cProdTriangulo = 'VIDA' THEN
      cCodRamo := '010';
   ELSE
      cCodRamo := '030';
   END IF;

   -- Define el Trimestre donde inicia el análisis
   IF TO_CHAR(dFecFinTriangulo,'MM') IN ('01','02','03') THEN
      dFecTrimestre := TO_DATE('01/04'||TO_CHAR(ADD_MONTHS(dFecFinTriangulo,-(nMeses)),'YYYY'),'DD/MM/YYYY');
   ELSIF TO_CHAR(dFecFinTriangulo,'MM') IN ('04','05','06') THEN
      dFecTrimestre := TO_DATE('01/07'||TO_CHAR(ADD_MONTHS(dFecFinTriangulo,-(nMeses)),'YYYY'),'DD/MM/YYYY');
   ELSIF TO_CHAR(dFecFinTriangulo,'MM') IN ('07','08','09') THEN
      dFecTrimestre := TO_DATE('01/10'||TO_CHAR(ADD_MONTHS(dFecFinTriangulo,-(nMeses)),'YYYY'),'DD/MM/YYYY');
   ELSE   
      dFecTrimestre := TO_DATE('01/01'||TO_CHAR(ADD_MONTHS(dFecFinTriangulo,-(nMeses-3)),'YYYY'),'DD/MM/YYYY');
   END IF;

   dFecIniSini      := dFecTrimestre;
   dFecFinSini      := ADD_MONTHS(dFecIniSini,3);
   nNumRegistro     := 1;
   cTxtPerTituloMO  := 'PO / PD';
   OC_TRIANGULOS_DATOS.INSERTAR(nCodCia, nIdTriangulo, cTipoTrianguloMO, nNumRegistro, cTxtPerTituloMO);
   OC_TRIANGULOS_DATOS.INSERTAR(nCodCia, nIdTriangulo, cTipoTrianguloSI, nNumRegistro, cTxtPerTituloMO);
   OC_TRIANGULOS_DATOS.INSERTAR(nCodCia, nIdTriangulo, cTipoTrianguloSA, nNumRegistro, cTxtPerTituloMO);
   OC_TRIANGULOS_DATOS.INSERTAR(nCodCia, nIdTriangulo, cTipoTrianguloAC, nNumRegistro, cTxtPerTituloMO);
   OC_TRIANGULOS_DATOS.INSERTAR(nCodCia, nIdTriangulo, cTipoTrianguloSF, nNumRegistro, cTxtPerTituloMO);
   OC_TRIANGULOS_DATOS.INSERTAR(nCodCia, nIdTriangulo, cTipoTrianguloRF, nNumRegistro, cTxtPerTituloMO);
   OC_TRIANGULOS_DATOS.INSERTAR(nCodCia, nIdTriangulo, cTipoTrianguloFD, nNumRegistro, NULL);

   FOR X IN 1..nTrimestres LOOP
      nNumRegistro    := nNumRegistro + 1;
      cTxtPerTituloMO := TO_CHAR(dFecIniSini,'YYYY') || '-' || CEIL(TO_NUMBER(TO_CHAR(dFecIniSini,'MM')) / 3);
      OC_TRIANGULOS_DATOS.INSERTAR(nCodCia, nIdTriangulo, cTipoTrianguloMO, nNumRegistro, cTxtPerTituloMO);
      OC_TRIANGULOS_DATOS.INSERTAR(nCodCia, nIdTriangulo, cTipoTrianguloSI, nNumRegistro, cTxtPerTituloMO);
      OC_TRIANGULOS_DATOS.INSERTAR(nCodCia, nIdTriangulo, cTipoTrianguloSA, nNumRegistro, cTxtPerTituloMO);
      OC_TRIANGULOS_DATOS.INSERTAR(nCodCia, nIdTriangulo, cTipoTrianguloAC, nNumRegistro, cTxtPerTituloMO);
      OC_TRIANGULOS_DATOS.INSERTAR(nCodCia, nIdTriangulo, cTipoTrianguloSF, nNumRegistro, cTxtPerTituloMO);
      OC_TRIANGULOS_DATOS.INSERTAR(nCodCia, nIdTriangulo, cTipoTrianguloRF, nNumRegistro, cTxtPerTituloMO);

--      PR_RESERVAS_RESUMEN_IBNR.INSERTAR(nIdTriangulo, nNumRegistro-1, cTxtPerTituloMO);
      dFecIniSini     := dFecFinSini;
      dFecFinSini     := ADD_MONTHS(dFecIniSini,3);
   END LOOP;

   nNumRegistro     := 1;
   dFecIniSini      := dFecTrimestre;
   dFecFinSini      := ADD_MONTHS(dFecIniSini,3);
   FOR X IN 1..nTrimestres LOOP
      nNumRegistro    := nNumRegistro + 1;
      cTxtPerTituloMO := TO_CHAR(dFecIniSini,'YYYY') || '-' || CEIL(TO_NUMBER(TO_CHAR(dFecIniSini,'MM')) / 3);
      cTxtPerTituloSI := X;
      OC_TRIANGULOS_DATOS.ACTUALIZAR(nCodCia, nIdTriangulo, cTipoTrianguloMO, 1, 'C', X, cTxtPerTituloSI);
      OC_TRIANGULOS_DATOS.ACTUALIZAR(nCodCia, nIdTriangulo, cTipoTrianguloSI, 1, 'C', X, cTxtPerTituloSI);
      OC_TRIANGULOS_DATOS.ACTUALIZAR(nCodCia, nIdTriangulo, cTipoTrianguloSA, 1, 'C', X, cTxtPerTituloSI);
      OC_TRIANGULOS_DATOS.ACTUALIZAR(nCodCia, nIdTriangulo, cTipoTrianguloAC, 1, 'C', X, cTxtPerTituloSI);
      OC_TRIANGULOS_DATOS.ACTUALIZAR(nCodCia, nIdTriangulo, cTipoTrianguloSF, 1, 'C', X, cTxtPerTituloSI);
      OC_TRIANGULOS_DATOS.ACTUALIZAR(nCodCia, nIdTriangulo, cTipoTrianguloRF, 1, 'C', X, cTxtPerTituloSI);
      OC_TRIANGULOS_DATOS.ACTUALIZAR(nCodCia, nIdTriangulo, cTipoTrianguloFD, 1, 'C', X, cTxtPerTituloSI);
      dFecIniNoti := dFecIniSini;
      dFecFinNoti := dFecFinSini;
      nNumRegSI   := 1;
      FOR Y IN X..nTrimestres LOOP
         cTxtPerTituloMO := TO_CHAR(dFecIniNoti,'YYYY') || '-' || CEIL(TO_NUMBER(TO_CHAR(dFecIniNoti,'MM')) / 3);
         cGenVal    := 'N';
         nTotSini   := 0;
         nTotGastos := 0;
         FOR W IN SINI_Q LOOP
            nIdPoliza     := W.IdPoliza;
            nIDetPol      := W.IDetPol;
            nIdSiniestro  := W.IdSiniestro;
            nTotSiniInd   := 0;
            cCod_Moneda   := W.Cod_Moneda;
            FOR W IN RESERVAS_Q LOOP
               nTotSini    := NVL(nTotSini,0) + NVL(W.MtoReserva,0);
               nTotSiniInd := NVL(nTotSiniInd,0) + NVL(W.MtoReserva,0);
            END LOOP;
            FOR W IN GASTOS_Q LOOP
               nTotGastos := NVL(nTotGastos,0) + NVL(W.MtoReserva,0);
            END LOOP;
            cGenVal   := 'S';
            OC_TRIANGULOS_SINIESTROS.INSERTAR(nCodCia, nIdTriangulo, W.IdSiniestro, W.Fec_Ocurrencia, W.Fec_Notificacion, nTotSiniInd);
         END LOOP;

         SELECT DECODE(cGenVal,'S',nTotSini,0)
           INTO nTotSini
           FROM DUAL;
         OC_TRIANGULOS_DATOS.ACTUALIZAR(nCodCia, nIdTriangulo, cTipoTrianguloMO, X+1, 'C', nNumRegSI, nTotSini);
         OC_TRIANGULOS_DATOS.ACTUALIZAR(nCodCia, nIdTriangulo, cTipoTrianguloSI, X+1, 'C', nNumRegSI, nTotSini);
         dFecIniNoti := dFecFinNoti;
         dFecFinNoti := ADD_MONTHS(dFecIniNoti,3);
         nNumRegSI   := nNumRegSI + 1;
      END LOOP;
      dFecIniSini   := dFecFinSini;
      dFecFinSini   := ADD_MONTHS(dFecIniSini,3);
   END LOOP;
   OC_TRIANGULOS_DATOS.ACUMULADO(nCodCia, nIdTriangulo, nTrimestres);
   OC_TRIANGULOS_DATOS.TOTALIZAR(nCodCia, nIdTriangulo, nTrimestres);
END GENERA_TRIANGULOS;

PROCEDURE INSERTAR(nCodCia NUMBER, nIdTriangulo NUMBER, cTipoTriangulo VARCHAR2, nNumRegistro NUMBER,
                   cTxtPerTitulo VARCHAR2) IS
BEGIN
   INSERT INTO TRIANGULOS_DATOS
          (CodCia, IdTriangulo, TipoTriangulo, NumRegistro, TxtPerTitulo) 
   VALUES (nCodCia, nIdTriangulo, cTipoTriangulo, nNumRegistro, cTxtPerTitulo);
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20100,'Error al Insertar en TRIANGULOS_DATOS IdTriángulo '|| nIdTriangulo ||
                              ' Tipo de Triángulo ' || cTipoTriangulo || ' Línea ' || nNumRegistro);
END INSERTAR;

PROCEDURE ACTUALIZAR(nCodCia NUMBER, nIdTriangulo NUMBER, cTipoTriangulo VARCHAR2, nNumRegistro NUMBER,
                     cTipo VARCHAR2, nCampo NUMBER, cValorCampo VARCHAR2) IS
c_ExpresionInt1  VARCHAR2(3000) := NULL;
cValCampoConv    TRIANGULOS_DATOS.Periodo01%TYPE;
BEGIN
   IF nNumRegistro != 1 THEN
      IF cTipoTriangulo != 'FD' THEN
         cValCampoConv   := TRIM(TO_CHAR(TO_NUMBER(TRIM(cValorCampo)),'999999999990.000000'));
      ELSE
         cValCampoConv   := TRIM(TO_CHAR(TO_NUMBER(TRIM(cValorCampo)),'999990.000000000000'));
      END IF;
   ELSE
      cValCampoConv   := cValorCampo;
   END IF;
   c_ExpresionInt1 := 'UPDATE TRIANGULOS_DATOS SET ';
   IF cTipo = 'C' THEN
      c_ExpresionInt1 := c_ExpresionInt1 || 'Periodo' || TRIM(TO_CHAR(nCampo,'00'));
   ELSE
      c_ExpresionInt1 := c_ExpresionInt1 || 'TxtTotal ';
   END IF;
   c_ExpresionInt1 := c_ExpresionInt1 || ' = ' || CHR(39)||cValCampoConv||CHR(39) ||
                      ' WHERE IdTriangulo   = ' || nIdTriangulo ||
                      '   AND CodCia        = ' || nCodCia ||
                      '   AND TipoTriangulo = ' || CHR(39)||cTipoTriangulo||CHR(39)||
                      '   AND NumRegistro   = ' || nNumRegistro;
   EXECUTE IMMEDIATE c_ExpresionInt1;
END ACTUALIZAR;

PROCEDURE TOTALIZAR(nCodCia NUMBER, nIdTriangulo NUMBER, nPeriodos NUMBER) IS
nNumRegistro     NUMBER(5);
cTipoTriangulo   TRIANGULOS_DATOS.TipoTriangulo%TYPE;
c_ExpresionInt1  VARCHAR2(3000) := NULL;
nValorAcum       NUMBER(30,6);
nTotal           NUMBER(30,6);

CURSOR TRIANG_Q IS
   SELECT TipoTriangulo, MAX(TO_NUMBER(NumRegistro))+1 NumRegistro, SUM(NVL(TO_NUMBER(Periodo01),0)) Periodo01,
          SUM(NVL(TO_NUMBER(Periodo02),0)) Periodo02, SUM(NVL(TO_NUMBER(Periodo03),0)) Periodo03,
          SUM(NVL(TO_NUMBER(Periodo04),0)) Periodo04, SUM(NVL(TO_NUMBER(Periodo05),0)) Periodo05,
          SUM(NVL(TO_NUMBER(Periodo06),0)) Periodo06, SUM(NVL(TO_NUMBER(Periodo07),0)) Periodo07,
          SUM(NVL(TO_NUMBER(Periodo08),0)) Periodo08, SUM(NVL(TO_NUMBER(Periodo09),0)) Periodo09,
          SUM(NVL(TO_NUMBER(Periodo10),0)) Periodo10, SUM(NVL(TO_NUMBER(Periodo11),0)) Periodo11,
          SUM(NVL(TO_NUMBER(Periodo12),0)) Periodo12, SUM(NVL(TO_NUMBER(Periodo13),0)) Periodo13,
          SUM(NVL(TO_NUMBER(Periodo14),0)) Periodo14, SUM(NVL(TO_NUMBER(Periodo15),0)) Periodo15,
          SUM(NVL(TO_NUMBER(Periodo16),0)) Periodo16, SUM(NVL(TO_NUMBER(Periodo17),0)) Periodo17,
          SUM(NVL(TO_NUMBER(Periodo18),0)) Periodo18, SUM(NVL(TO_NUMBER(Periodo19),0)) Periodo19,
          SUM(NVL(TO_NUMBER(Periodo20),0)) Periodo20, SUM(NVL(TO_NUMBER(Periodo21),0)) Periodo21,
          SUM(NVL(TO_NUMBER(Periodo22),0)) Periodo22, SUM(NVL(TO_NUMBER(Periodo23),0)) Periodo23,
          SUM(NVL(TO_NUMBER(Periodo24),0)) Periodo24
     FROM TRIANGULOS_DATOS
    WHERE CodCia         = nCodCia
      AND IdTriangulo    = nIdTriangulo
      AND NumRegistro   != 1
      AND TipoTriangulo != 'FD'
    GROUP BY TipoTriangulo;
CURSOR TOTAL_Q IS
   SELECT TipoTriangulo, NumRegistro, 
          NVL(SUM(NVL(TO_NUMBER(Periodo01),0) + NVL(TO_NUMBER(Periodo02),0) + NVL(TO_NUMBER(Periodo03),0) +
          NVL(TO_NUMBER(Periodo04),0) + NVL(TO_NUMBER(Periodo05),0) + NVL(TO_NUMBER(Periodo06),0) +
          NVL(TO_NUMBER(Periodo07),0) + NVL(TO_NUMBER(Periodo08),0) + NVL(TO_NUMBER(Periodo09),0) +
          NVL(TO_NUMBER(Periodo10),0) + NVL(TO_NUMBER(Periodo11),0) + NVL(TO_NUMBER(Periodo12),0) +
          NVL(TO_NUMBER(Periodo13),0) + NVL(TO_NUMBER(Periodo14),0) + NVL(TO_NUMBER(Periodo15),0) +
          NVL(TO_NUMBER(Periodo16),0) + NVL(TO_NUMBER(Periodo17),0) + NVL(TO_NUMBER(Periodo18),0) +
          NVL(TO_NUMBER(Periodo19),0) + NVL(TO_NUMBER(Periodo20),0) + NVL(TO_NUMBER(Periodo21),0) +
          NVL(TO_NUMBER(Periodo22),0) + NVL(TO_NUMBER(Periodo23),0) + NVL(TO_NUMBER(Periodo24),0)),0) Total
     FROM TRIANGULOS_DATOS
    WHERE CodCia         = nCodCia
      AND IdTriangulo    = nIdTriangulo
      AND NumRegistro   != 1
      AND TipoTriangulo != 'FD'
    GROUP BY TipoTriangulo, NumRegistro;

CURSOR TOT_SA_Q IS
   SELECT NumRegistro
     FROM TRIANGULOS_DATOS
    WHERE CodCia        = nCodCia
      AND IdTriangulo   = nIdTriangulo
      AND TxtPerTitulo  = 'TOTALES'
      AND TipoTriangulo = cTipoTriangulo
    ORDER BY NumRegistro;

BEGIN
   FOR X IN TRIANG_Q LOOP
      OC_TRIANGULOS_DATOS.INSERTAR(nCodCia, nIdTriangulo, X.TipoTriangulo, X.NumRegistro, 'TOTALES');
      UPDATE TRIANGULOS_DATOS
         SET Periodo01 = TRIM(TO_CHAR(X.Periodo01,'999999999990.000000')),
             Periodo02 = TRIM(TO_CHAR(X.Periodo02,'999999999990.000000')),
             Periodo03 = TRIM(TO_CHAR(X.Periodo03,'999999999990.000000')),
             Periodo04 = TRIM(TO_CHAR(X.Periodo04,'999999999990.000000')),
             Periodo05 = TRIM(TO_CHAR(X.Periodo05,'999999999990.000000')),
             Periodo06 = TRIM(TO_CHAR(X.Periodo06,'999999999990.000000')),
             Periodo07 = TRIM(TO_CHAR(X.Periodo07,'999999999990.000000')),
             Periodo08 = TRIM(TO_CHAR(X.Periodo08,'999999999990.000000')),
             Periodo09 = TRIM(TO_CHAR(X.Periodo09,'999999999990.000000')),
             Periodo10 = TRIM(TO_CHAR(X.Periodo10,'999999999990.000000')),
             Periodo11 = TRIM(TO_CHAR(X.Periodo11,'999999999990.000000')),
             Periodo12 = TRIM(TO_CHAR(X.Periodo12,'999999999990.000000')),
             Periodo13 = TRIM(TO_CHAR(X.Periodo13,'999999999990.000000')),
             Periodo14 = TRIM(TO_CHAR(X.Periodo14,'999999999990.000000')),
             Periodo15 = TRIM(TO_CHAR(X.Periodo15,'999999999990.000000')),
             Periodo16 = TRIM(TO_CHAR(X.Periodo16,'999999999990.000000')),
             Periodo17 = TRIM(TO_CHAR(X.Periodo17,'999999999990.000000')),
             Periodo18 = TRIM(TO_CHAR(X.Periodo18,'999999999990.000000')),
             Periodo19 = TRIM(TO_CHAR(X.Periodo19,'999999999990.000000')),
             Periodo20 = TRIM(TO_CHAR(X.Periodo20,'999999999990.000000')),
             Periodo21 = TRIM(TO_CHAR(X.Periodo21,'999999999990.000000')),
             Periodo22 = TRIM(TO_CHAR(X.Periodo22,'999999999990.000000')),
             Periodo23 = TRIM(TO_CHAR(X.Periodo23,'999999999990.000000')),
             Periodo24 = TRIM(TO_CHAR(X.Periodo24,'999999999990.000000'))
       WHERE IdTriangulo   = nIdTriangulo
         AND NumRegistro   = X.NumRegistro
         AND TipoTriangulo = X.TipoTriangulo;

      UPDATE TRIANGULOS_DATOS
         SET TxtTotal = 'TOTAL'
       WHERE CodCia        = nCodCia
         AND IdTriangulo   = nIdTriangulo
         AND NumRegistro   = 1
         AND TipoTriangulo = X.TipoTriangulo;
   END LOOP;

   FOR X IN TOTAL_Q LOOP
      OC_TRIANGULOS_DATOS.ACTUALIZAR(nCodCia, nIdTriangulo, X.TipoTriangulo, X.NumRegistro, 'T', 0, X.Total);
   END LOOP;
   
   -- Totaliza Siniestralidad Acumulada por Periodo
   cTipoTriangulo := 'SA';
   FOR X IN TOT_SA_Q LOOP
      FOR Y IN 1..nPeriodos LOOP
         nNumRegistro := X.NumRegistro - Y;
         c_ExpresionInt1 := 'SELECT TO_NUMBER(NVL(Periodo' || TRIM(TO_CHAR(Y,'00')) || ',0))' ||
                            '  FROM TRIANGULOS_DATOS' ||
                            ' WHERE IdTriangulo   = ' || nIdTriangulo ||
                            '   AND CodCia        = ' || nCodCia ||
                            '   AND TipoTriangulo = ' || CHR(39)||cTipoTriangulo||CHR(39)||
                            '   AND NumRegistro   = ' || nNumRegistro;
         EXECUTE IMMEDIATE c_ExpresionInt1 INTO nValorAcum;
         OC_TRIANGULOS_DATOS.ACTUALIZAR(nCodCia, nIdTriangulo, cTipoTriangulo, X.NumRegistro, 'C', Y, nValorAcum);
      END LOOP;
   END LOOP;

   -- Totaliza Siniestralidad Acumulada por Trimestre
   cTipoTriangulo := 'SA';
   nTotal         := 0;
   FOR X IN TOT_SA_Q LOOP
      FOR Y IN 1..nPeriodos LOOP
         nNumRegistro := X.NumRegistro - Y;
         c_ExpresionInt1 := 'SELECT TO_NUMBER(NVL(Periodo' || TRIM(TO_CHAR(Y,'00')) || ',0))' ||
                            '  FROM TRIANGULOS_DATOS' ||
                            ' WHERE IdTriangulo   = ' || nIdTriangulo ||
                            '   AND CodCia        = ' || nCodCia ||
                            '   AND TipoTriangulo = ' || CHR(39)||cTipoTriangulo||CHR(39)||
                            '   AND NumRegistro   = ' || nNumRegistro;
         EXECUTE IMMEDIATE c_ExpresionInt1 INTO nValorAcum;
         nTotal := NVL(nTotal,0) + nValorAcum;
         OC_TRIANGULOS_DATOS.ACTUALIZAR(nCodCia, nIdTriangulo, cTipoTriangulo, nNumRegistro, 'T', Y, nValorAcum);
      END LOOP;
      OC_TRIANGULOS_DATOS.ACTUALIZAR(nCodCia, nIdTriangulo, cTipoTriangulo, X.NumRegistro, 'T', X.NumRegistro, nTotal);
   END LOOP;

   cTipoTriangulo := 'SF';
   nTotal         := 0;
   FOR X IN TOT_SA_Q LOOP
      FOR Y IN 1..nPeriodos LOOP
         nNumRegistro := X.NumRegistro - Y;
         c_ExpresionInt1 := 'SELECT TO_NUMBER(NVL(Periodo' || TRIM(TO_CHAR(24,'00')) || ',0))' ||
                            '  FROM TRIANGULOS_DATOS' ||
                            ' WHERE IdTriangulo   = ' || nIdTriangulo ||
                            '   AND CodCia        = ' || nCodCia ||
                            '   AND TipoTriangulo = ' || CHR(39)||cTipoTriangulo||CHR(39)||
                            '   AND NumRegistro   = ' || nNumRegistro;
         EXECUTE IMMEDIATE c_ExpresionInt1 INTO nValorAcum;
         nTotal := NVL(nTotal,0) + nValorAcum;
         OC_TRIANGULOS_DATOS.ACTUALIZAR(nCodCia, nIdTriangulo, cTipoTriangulo, nNumRegistro, 'T', Y, nValorAcum);
      END LOOP;
      OC_TRIANGULOS_DATOS.ACTUALIZAR(nCodCia, nIdTriangulo, cTipoTriangulo, X.NumRegistro, 'T', X.NumRegistro, nTotal);
   END LOOP;
END TOTALIZAR;

PROCEDURE ACUMULADO(nCodCia NUMBER, nIdTriangulo NUMBER, nPeriodos NUMBER) IS

cTipoTriangulo   TRIANGULOS_DATOS.TipoTriangulo%TYPE;
nNumRegMax       TRIANGULOS_DATOS.NumRegistro%TYPE;
nNumRegMaxAcum   TRIANGULOS_DATOS.NumRegistro%TYPE;
nNumRegAct       TRIANGULOS_DATOS.NumRegistro%TYPE;
c_ExpresionInt1  VARCHAR2(3000) := NULL;
nValorAcum       NUMBER(30,6);
nValorProm       NUMBER(30,6);
nValorAnt        NUMBER(30,6);
nValorSinAcum    NUMBER(30,6);
nValorAcumAnt    NUMBER(30,6);
nPosicion        NUMBER(30);
nFrec            NUMBER(5);
nValorFactor     NUMBER(30,12);
nFactor          NUMBER(30,12);

CURSOR ACUM_Q IS
   SELECT TipoTriangulo, NumRegistro
     FROM TRIANGULOS_DATOS
    WHERE CodCia        = nCodCia
      AND IdTriangulo   = nIdTriangulo
      AND NumRegistro  != 1
      AND TipoTriangulo = cTipoTriangulo
    ORDER BY NumRegistro;
BEGIN
   -- Calcula Siniestralidad Acumulada
   cTipoTriangulo := 'SI';
   FOR X IN ACUM_Q LOOP
      FOR Y IN 1..nPeriodos LOOP
         IF Y = 2 THEN
            nFrec := 1;
         ELSIF Y > 2 THEN
            nFrec := nFrec + 2;
         ELSE
            nFrec := 0;
         END IF;
         c_ExpresionInt1 := 'SELECT SUM(';
         FOR W IN 1..Y LOOP
            c_ExpresionInt1 := c_ExpresionInt1 || 'TO_NUMBER(Periodo' || TRIM(TO_CHAR(W,'00')) || ')';
            IF W != Y THEN
               c_ExpresionInt1 := c_ExpresionInt1 || ' + ';
            END IF;
         END LOOP;
         c_ExpresionInt1 := c_ExpresionInt1 || ') FROM TRIANGULOS_DATOS' ||
                            ' WHERE IdTriangulo   = ' || nIdTriangulo ||
                            '   AND CodCia        = ' || nCodCia ||
                            '   AND TipoTriangulo = ' || CHR(39)||X.TipoTriangulo||CHR(39)||
                            '   AND NumRegistro   = ' || X.NumRegistro;
         EXECUTE IMMEDIATE c_ExpresionInt1 INTO nValorAcum;
         IF X.NumRegistro - 1 > (Y + nPeriodos - 2 - nFrec) AND nFrec != 0 THEN
            nValorAcum := NULL;
         END IF;
         OC_TRIANGULOS_DATOS.ACTUALIZAR(nCodCia, nIdTriangulo, 'SA', X.NumRegistro, 'C', Y, nValorAcum);
      END LOOP;
   END LOOP;
   
   -- Calcula Factores de Desarrollo
   cTipoTriangulo := 'SA';
   OC_TRIANGULOS_DATOS.INSERTAR(nCodCia, nIdTriangulo, 'FD', 2, 'FACTOR');
   OC_TRIANGULOS_DATOS.ACTUALIZAR(nCodCia, nIdTriangulo, 'FD', 2, 'C', 1, 1);
   SELECT MAX(NumRegistro)+1
     INTO nNumRegMax
     FROM TRIANGULOS_DATOS
    WHERE CodCia        = nCodCia
      AND IdTriangulo   = nIdTriangulo
      AND TipoTriangulo = 'SA';

   FOR Y IN 2..nPeriodos LOOP
      nNumRegAct      := nNumRegMax - Y;
      c_ExpresionInt1 := 'SELECT NVL(SUM(NVL(TO_NUMBER(' || 'Periodo' || TRIM(TO_CHAR(Y,'00')) || '),0)),0)';
      c_ExpresionInt1 := c_ExpresionInt1 || ' FROM TRIANGULOS_DATOS' ||
                         ' WHERE IdTriangulo   = ' || nIdTriangulo ||
                         '   AND CodCia        = ' || nCodCia ||
                         '   AND TipoTriangulo = ' || CHR(39)||cTipoTriangulo||CHR(39) ||
                         '   AND NumRegistro   > 1 ' ||
                         '   AND NumRegistro   <= '||nNumRegAct;
      EXECUTE IMMEDIATE c_ExpresionInt1 INTO nValorAcum;

      c_ExpresionInt1 := 'SELECT NVL(SUM(NVL(TO_NUMBER(' || 'Periodo' || TRIM(TO_CHAR(Y-1,'00')) || '),1)),0)';
      c_ExpresionInt1 := c_ExpresionInt1 || ' FROM TRIANGULOS_DATOS' ||
                         ' WHERE IdTriangulo   = ' || nIdTriangulo ||
                         '   AND CodCia        = ' || nCodCia ||
                         '   AND TipoTriangulo = ' || CHR(39)||cTipoTriangulo||CHR(39)  ||
                         '   AND NumRegistro   > 1 ' ||
                         '   AND NumRegistro   <= '||nNumRegAct;
      EXECUTE IMMEDIATE c_ExpresionInt1 INTO nValorProm;

      IF Y > nPeriodos OR NVL(nValorProm,0) = 0 THEN
         nValorFactor := 1;
      ELSE
         nValorFactor := ROUND(nValorAcum / nValorProm,6);
      END IF;
      OC_TRIANGULOS_DATOS.ACTUALIZAR(nCodCia, nIdTriangulo, 'FD', 2, 'C', Y, NVL(nValorFactor,0));
   END LOOP;

   -- Calcula Acumulado
   cTipoTriangulo := 'SA';
   FOR X IN ACUM_Q LOOP
      FOR Y IN 1..nPeriodos LOOP
         IF Y = 2 THEN
            nFrec := 1;
         ELSIF Y > 2 THEN
            nFrec := nFrec + 2;
         ELSE
            nFrec := 0;
         END IF;
         -- Lee Periodo de Siniestralidad Acumulada
         c_ExpresionInt1 := 'SELECT NVL(TO_NUMBER(Periodo' || TRIM(TO_CHAR(Y,'00')) || '),0)' ||
                            '  FROM TRIANGULOS_DATOS' ||
                            ' WHERE IdTriangulo   = ' || nIdTriangulo ||
                            '   AND CodCia        = ' || nCodCia ||
                            '   AND TipoTriangulo = ' || CHR(39)||X.TipoTriangulo||CHR(39)||
                            '   AND NumRegistro   = ' || X.NumRegistro;
         EXECUTE IMMEDIATE c_ExpresionInt1 INTO nValorAcum;

         IF Y > nPeriodos AND nFrec != 0 THEN 
            nValorAcum := 0;
         ELSIF X.NumRegistro - 1 > (Y + nPeriodos - 2 - nFrec) AND nFrec != 0 THEN
            -- Lee Factor de Desarrollo del Periodo
            c_ExpresionInt1 := 'SELECT NVL(TO_NUMBER(Periodo' || TRIM(TO_CHAR(Y,'00')) || '),0)' ||
                               '  FROM TRIANGULOS_DATOS' ||
                               ' WHERE IdTriangulo   = ' || nIdTriangulo ||
                               '   AND CodCia        = ' || nCodCia ||
                               '   AND TipoTriangulo = ' || CHR(39)||'FD'||CHR(39)||
                               '   AND NumRegistro   = 2';
            EXECUTE IMMEDIATE c_ExpresionInt1 INTO nFactor;

            -- Lee Valor Acumulado Periodo Anterior
            c_ExpresionInt1 := 'SELECT NVL(TO_NUMBER(Periodo' || TRIM(TO_CHAR(Y-1,'00')) || '),0)' ||
                               '  FROM TRIANGULOS_DATOS' ||
                               ' WHERE IdTriangulo   = ' || nIdTriangulo ||
                               '   AND CodCia        = ' || nCodCia ||
                               '   AND TipoTriangulo = ' || CHR(39)||'AC'||CHR(39)||
                               '   AND NumRegistro   = ' || X.NumRegistro;
            EXECUTE IMMEDIATE c_ExpresionInt1 INTO nValorAnt;
            nValorAcum := NVL(nValorAnt * nFactor,0);
         END IF;
         OC_TRIANGULOS_DATOS.ACTUALIZAR(nCodCia, nIdTriangulo, 'AC', X.NumRegistro, 'C', Y, nValorAcum);
      END LOOP;
   END LOOP;

   -- Calcula Siniestralidad Acumulada Futura
   cTipoTriangulo := 'AC';
   FOR X IN ACUM_Q LOOP
      FOR Y IN 1..nPeriodos LOOP
         IF Y = 2 THEN
            nFrec := 1;
         ELSIF Y > 2 THEN
            nFrec := nFrec + 2;
         ELSE
            nFrec := 0;
         END IF;

         -- Lee Periodo de Siniestralidad Acumulada
         c_ExpresionInt1 := 'SELECT NVL(TO_NUMBER(Periodo' || TRIM(TO_CHAR(Y,'00')) || '),0)' ||
                            '  FROM TRIANGULOS_DATOS' ||
                            ' WHERE IdTriangulo   = ' || nIdTriangulo ||
                            '   AND CodCia        = ' || nCodCia ||
                            '   AND TipoTriangulo = ' || CHR(39)||X.TipoTriangulo||CHR(39)||
                            '   AND NumRegistro   = ' || X.NumRegistro;
         EXECUTE IMMEDIATE c_ExpresionInt1 INTO nValorAcum;

         IF Y > nPeriodos AND nFrec != 0 OR nFrec = 0 THEN
            nValorAcum := 0;
         ELSIF X.NumRegistro - 1 <= (Y + nPeriodos - 2 - nFrec) AND nFrec != 0 THEN
            -- Lee Valor de Siniestralidad Acumulada
            c_ExpresionInt1 := 'SELECT NVL(TO_NUMBER(Periodo' || TRIM(TO_CHAR(Y,'00')) || '),0)' ||
                               '  FROM TRIANGULOS_DATOS' ||
                               ' WHERE IdTriangulo   = ' || nIdTriangulo ||
                               '   AND CodCia        = ' || nCodCia ||
                               '   AND TipoTriangulo = ' || CHR(39)||'SA'||CHR(39)||
                               '   AND NumRegistro   = ' || X.NumRegistro;
            EXECUTE IMMEDIATE c_ExpresionInt1 INTO nValorSinAcum;
            nValorAcum := NVL(nValorAcum - nValorSinAcum,0);
         END IF;
         OC_TRIANGULOS_DATOS.ACTUALIZAR(nCodCia, nIdTriangulo, 'SF', X.NumRegistro, 'C', Y, nValorAcum);
      END LOOP;
   END LOOP;

   -- Calcula Siniestralidad Futura Reserva
   cTipoTriangulo := 'AC';
   FOR X IN ACUM_Q LOOP
      FOR Y IN 1..nPeriodos LOOP
         IF Y = 2 THEN
            nFrec := 1;
         ELSIF Y > 2 THEN
            nFrec := nFrec + 2;
         ELSE
            nFrec := 0;
         END IF;

         IF Y > nPeriodos AND nFrec != 0 OR nFrec = 0 THEN
            nValorAcum := 0;
         ELSIF X.NumRegistro - 1 <= (Y + nPeriodos - 2 - nFrec) AND nFrec != 0 THEN
            -- Lee Periodo de Siniestralidad Acumulada
            c_ExpresionInt1 := 'SELECT NVL(TO_NUMBER(Periodo' || TRIM(TO_CHAR(Y,'00')) || '),0)' ||
                               '  FROM TRIANGULOS_DATOS' ||
                               ' WHERE IdTriangulo   = ' || nIdTriangulo ||
                               '   AND CodCia        = ' || nCodCia ||
                               '   AND TipoTriangulo = ' || CHR(39)||X.TipoTriangulo||CHR(39)||
                               '   AND NumRegistro   = ' || X.NumRegistro;
            EXECUTE IMMEDIATE c_ExpresionInt1 INTO nValorAcum;

            -- Lee Valor de Siniestralidad Acumulada
            c_ExpresionInt1 := 'SELECT NVL(TO_NUMBER(Periodo' || TRIM(TO_CHAR(Y,'00')) || '),0)' ||
                               '  FROM TRIANGULOS_DATOS' ||
                               ' WHERE IdTriangulo   = ' || nIdTriangulo ||
                               '   AND CodCia        = ' || nCodCia ||
                               '   AND TipoTriangulo = ' || CHR(39)||'SA'||CHR(39)||
                               '   AND NumRegistro   = ' || X.NumRegistro;
            EXECUTE IMMEDIATE c_ExpresionInt1 INTO nValorSinAcum;
            nValorAcum := NVL(nValorAcum - nValorSinAcum,0);
         ELSE
            -- Lee Periodo de Siniestralidad Acumulada
            c_ExpresionInt1 := 'SELECT NVL(TO_NUMBER(Periodo' || TRIM(TO_CHAR(Y-1,'00')) || '),0)' ||
                               '  FROM TRIANGULOS_DATOS' ||
                               ' WHERE IdTriangulo   = ' || nIdTriangulo ||
                               '   AND CodCia        = ' || nCodCia ||
                               '   AND TipoTriangulo = ' || CHR(39)||X.TipoTriangulo||CHR(39)||
                               '   AND NumRegistro   = ' || X.NumRegistro;
            EXECUTE IMMEDIATE c_ExpresionInt1 INTO nValorAcum;

            -- Lee Valor de Siniestralidad Acumulada Futura
            c_ExpresionInt1 := 'SELECT NVL(TO_NUMBER(Periodo' || TRIM(TO_CHAR(Y,'00')) || '),0)' ||
                               '  FROM TRIANGULOS_DATOS' ||
                               ' WHERE IdTriangulo   = ' || nIdTriangulo ||
                               '   AND TipoTriangulo = ' || CHR(39)||'SF'||CHR(39)||
                               '   AND NumRegistro   = ' || X.NumRegistro;
            EXECUTE IMMEDIATE c_ExpresionInt1 INTO nValorSinAcum;
            nValorAcum := NVL(nValorSinAcum - nValorAcum,0);
         END IF;

         OC_TRIANGULOS_DATOS.ACTUALIZAR(nCodCia, nIdTriangulo, 'RF', X.NumRegistro, 'C', Y, nValorAcum);
      END LOOP;
   END LOOP;

END ACUMULADO;

END OC_TRIANGULOS_DATOS;
