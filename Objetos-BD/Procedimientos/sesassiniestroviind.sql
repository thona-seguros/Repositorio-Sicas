--
-- SESASSINIESTROVIIND  (Procedure) 
--
--  Dependencies: 
--   STANDARD (Package)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--   OC_ARCHIVO (Package)
--   SINIESTRO (Table)
--   PLAN_COBERTURAS (Table)
--   POLIZAS (Table)
--   OC_ENTREGAS_CNSF_CONFIG (Package)
--   OC_ENTREGAS_CNSF_PLANTILLA (Package)
--   CONFIG_PLANTILLAS_CAMPOS (Table)
--   CONFIG_SESAS_TIPO_SEGURO (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--   APROBACIONES (Table)
--   OC_CONFIG_PLANTILLAS_CAMPOS (Package)
--   CLIENTES (Table)
--   COBERTURAS_DE_SEGUROS (Table)
--   COBERTURA_SINIESTRO (Table)
--   COBERTURA_SINIESTRO_ASEG (Table)
--   OC_PLAN_COBERTURAS (Package)
--   DETALLE_POLIZA (Table)
--   ENTREGAS_CNSF_CONFIG (Table)
--
CREATE OR REPLACE PROCEDURE SICAS_OC.SESASSINIESTROVIIND (nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2,
                               dFecDesde DATE, dFecHasta DATE, cIdUsr VARCHAR2) IS
cCodPlantilla     ENTREGAS_CNSF_CONFIG.CodPlantilla%TYPE;
cSeparador        ENTREGAS_CNSF_CONFIG.Separador%TYPE;
cEncabezado       VARCHAR2(4000);
cSiniestro        VARCHAR2(1);
cPoliz_Stus       POLIZAS.StsPoliza%TYPE;
cCerti_Stus       DETALLE_POLIZA.StsDetalle%TYPE;
nLinea            NUMBER;
cCadena           VARCHAR2(4000);
cEstts_Sin        VARCHAR2(1);
cEntiOcuSin       VARCHAR2(2);
nMtoRec           NUMBER(20) := 0;
cCobAfectada      VARCHAR2(1) ;
cAprobPago        VARCHAR2(1);
cPuntoComa        VARCHAR2(1) := ';';
nTotPoliza        NUMBER(20)  := 0;
nTotCertif        NUMBER(20)  := 0;
nTotFecNac        NUMBER(20)  := 0;
nTotFecOcurr      NUMBER(20)  := 0;
nTotFecRepor      NUMBER(20)  := 0;
nTotPerEspe       NUMBER(20)  := 0;
nTotMtoReclam     NUMBER(20)  := 0;
nTotMtoDeduc      NUMBER(20)  := 0;
nTotMtoCoaseg     NUMBER(20)  := 0;
nTotAnioPol       NUMBER(20)  := 0;
nTotDiasBen3      NUMBER(20)  := 0;
nTotSubTipo       NUMBER(20)  := 0;
nTotTipoRies      NUMBER(20)  := 0;
nTotPlanPoliza    NUMBER(20)  := 0;
nMtoSiniBe1       NUMBER(20,2)  := 0;
nMtoSiniBe2       NUMBER(20,2)  := 0;
nMtoSiniBe3       NUMBER(20,2)  := 0;
nMtoSiniBe4       NUMBER(20,2)  := 0;
nMtoSiniBe5       NUMBER(20,2)  := 0;
nMtoSiniBe6       NUMBER(20,2)  := 0;
nMtoSiniBe7       NUMBER(20,2)  := 0;
nMtoSiniBe8       NUMBER(20,2)  := 0;
nMtoSiniBe9       NUMBER(20,2)  := 0;
nTotMtoSiniBe1    NUMBER(20)    := 0;
nTotMtoSiniBe2    NUMBER(20)    := 0;
nTotMtoSiniBe3    NUMBER(20)    := 0;
nTotMtoSiniBe4    NUMBER(20)    := 0;
nTotMtoSiniBe5    NUMBER(20)    := 0;
nTotMtoSiniBe6    NUMBER(20)    := 0;
nTotMtoSiniBe7    NUMBER(20)    := 0;
nTotMtoSiniBe8    NUMBER(20)    := 0;
nTotMtoSiniBe9    NUMBER(20)    := 0;

CURSOR C_CAMPO IS
   SELECT NomCampo
     FROM CONFIG_PLANTILLAS_CAMPOS
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND CodPlantilla = cCodPlantilla
    ORDER BY OrdenCampo;

CURSOR C_ARCHIVO IS
   SELECT P.NumPolUnico Poliza, S.Cod_Asegurado Certi, C.TipoSeguro Tipo_Seg,
          S.IdSiniestro Num_Sin, TO_CHAR(S.Fec_Ocurrencia,'YYYYMMDD') FechOcuSin,
          TO_CHAR(S.Fec_Notificacion,'YYYYMMDD') FechRepSin, S.Motivo_De_Siniestro Causa_Sin,
          CEIL(MONTHS_BETWEEN(D.FecFinVig,D.FecIniVig)/12) AnioPoliza,
          TO_CHAR(PN.FecNacimiento,'YYYYMMDD') Fecha_Nac, PN.Sexo, 'C' Forma_Vta,
          DECODE(S.Cod_Moneda,'PS','N',DECODE(S.Cod_Moneda,'US','E','I')) Moneda,
          NVL(C.TipoRiesgo,'1') TipoRiesgo, S.CodPaisOcurr, S.CodProvOcurr,
          NVL(C.MaxDiasBenef3,0) MaxDiasBenef3, NVL(C.SubTipoSeg,'1') SubTipoSeg,
          NVL(C.PeriodoEspera,0) Pdo_Espera, NVL(C.InicioCobertura,2) IniCob,
          C.MtoDeducible, C.MtoCoaseguro, PN.CodPaisRes CodPais, PN.CodProvRes CodEstado,
          'I' TipoMovRec, 1 Num_Reclam, S.IdSiniestro, P.StsPoliza, S.Sts_Siniestro,
          D.IdTipoSeg, D.IdPoliza, S.Monto_Pago_Moneda, S.Monto_Reserva_Moneda,
          OC_PLAN_COBERTURAS.PLAN_POLIZA(D.CodCia, D.CodEmpresa, D.IdTipoSeg, D.PlanCob) PlanPoliza,
          NVL(C.ModalPoliza,'1') ModalPoliza
     FROM DETALLE_POLIZA D, POLIZAS P, CLIENTES CL, PERSONA_NATURAL_JURIDICA PN,
          SINIESTRO S, CONFIG_SESAS_TIPO_SEGURO C
    WHERE PN.Num_Doc_Identificacion  = CL.Num_Doc_Identificacion
      AND PN.Tipo_Doc_Identificacion = CL.Tipo_Doc_Identificacion
      AND CL.CodCliente              = P.CodCliente
      AND C.IdTipoSeg                = D.IdTipoSeg
      AND C.CodEmpresa               = D.CodEmpresa
      AND C.CodCia                   = D.CodCia
      AND S.Fec_Notificacion        >= dFecDesde
      AND S.Fec_Notificacion        <= dFecHasta
      AND S.Sts_Siniestro           != 'SOL'
      AND S.IDetPol                  = D.IDetPol
      AND S.IdPoliza                 = D.IdPoliza
      AND P.IdPoliza                 = D.IdPoliza
      AND D.IdTipoSeg               IN (SELECT IdTipoSeg
                                          FROM PLAN_COBERTURAS
                                         WHERE CodTipoPlan = '011')
      AND D.CodEmpresa               = nCodEmpresa
      AND D.CodCia                   = nCodCia;

   PROCEDURE RESERVAS (nIdPoliza NUMBER, nIdSiniestro NUMBER) IS
   CURSOR RESER_Q IS
      SELECT NVL(CS.ClaveSesas,'1') ClaveSesas, SUM(Monto_Reservado_Moneda) MtoResMoneda
        FROM COBERTURA_SINIESTRO C, DETALLE_POLIZA D, SINIESTRO S, COBERTURAS_DE_SEGUROS CS
       WHERE CS.CodCobert  = C.CodCobert
         AND CS.PlanCob    = D.PlanCob
         AND CS.IdTipoSeg  = D.IdTipoSeg
         AND CS.CodEmpresa = D.CodEmpresa
         AND CS.CodCia     = D.CodCia
         AND D.IDetPol     = S.IDetPol
         AND D.IdPoliza    = S.IdPoliza
         AND S.IdSiniestro = C.IdSiniestro
         AND C.IdSiniestro = nIdSiniestro
         AND C.IdPoliza    = nIdPoliza
       GROUP BY NVL(CS.ClaveSesas,'1')
       UNION
      SELECT NVL(CS.ClaveSesas,'1') ClaveSesas, SUM(Monto_Reservado_Moneda) MtoResMoneda
        FROM COBERTURA_SINIESTRO_ASEG C, DETALLE_POLIZA D, SINIESTRO S, COBERTURAS_DE_SEGUROS CS
       WHERE CS.CodCobert  = C.CodCobert
         AND CS.PlanCob    = D.PlanCob
         AND CS.IdTipoSeg  = D.IdTipoSeg
         AND CS.CodEmpresa = D.CodEmpresa
         AND CS.CodCia     = D.CodCia
         AND D.IDetPol     = S.IDetPol
         AND D.IdPoliza    = S.IdPoliza
         AND S.IdSiniestro = C.IdSiniestro
         AND C.IdSiniestro = nIdSiniestro
         AND C.IdPoliza    = nIdPoliza
       GROUP BY NVL(CS.ClaveSesas,'1');
   BEGIN
      cCobAfectada := NULL;
      nMtoRec      := 0;
      nMtoSiniBe1  := 0;
      nMtoSiniBe2  := 0;
      nMtoSiniBe3  := 0;
      nMtoSiniBe4  := 0;
      nMtoSiniBe5  := 0;
      nMtoSiniBe6  := 0;
      nMtoSiniBe7  := 0;
      nMtoSiniBe8  := 0;
      nMtoSiniBe9  := 0;
      FOR W IN RESER_Q LOOP
         IF cCobAfectada IS NULL THEN
            cCobAfectada := W.ClaveSesas;
         END IF;
         nMtoRec   := NVL(nMtoRec,0) + W.MtoResMoneda;
         IF W.ClaveSesas = '1' THEN
            nMtoSiniBe1 := NVL(nMtoSiniBe1,0) + NVL(W.MtoResMoneda,0);
         ELSIF W.ClaveSesas = '2' THEN
            nMtoSiniBe2 := NVL(nMtoSiniBe2,0) + NVL(W.MtoResMoneda,0);
         ELSIF W.ClaveSesas = '3' THEN
            nMtoSiniBe3 := NVL(nMtoSiniBe3,0) + NVL(W.MtoResMoneda,0);
         ELSIF W.ClaveSesas = '4' THEN
            nMtoSiniBe4 := NVL(nMtoSiniBe4,0) + NVL(W.MtoResMoneda,0);
         ELSIF W.ClaveSesas = '5' THEN
            nMtoSiniBe5 := NVL(nMtoSiniBe5,0) + NVL(W.MtoResMoneda,0);
         ELSIF W.ClaveSesas = '6' THEN
            nMtoSiniBe6 := NVL(nMtoSiniBe6,0) + NVL(W.MtoResMoneda,0);
         ELSIF W.ClaveSesas = '7' THEN
            nMtoSiniBe7 := NVL(nMtoSiniBe7,0) + NVL(W.MtoResMoneda,0);
         ELSIF W.ClaveSesas = '8' THEN
            nMtoSiniBe8 := NVL(nMtoSiniBe8,0) + NVL(W.MtoResMoneda,0);
         ELSE
            nMtoSiniBe9 := NVL(nMtoSiniBe9,0) + NVL(W.MtoResMoneda,0);
         END IF;
      END LOOP;
   END RESERVAS;
BEGIN
   cCodPlantilla := OC_ENTREGAS_CNSF_CONFIG.PLANTILLA(nCodCia, nCodEmpresa, cCodEntrega);
   cSeparador    := OC_ENTREGAS_CNSF_CONFIG.SEPARADOR(nCodCia, nCodEmpresa, cCodEntrega);

   FOR I IN  C_CAMPO  LOOP
      cEncabezado := cEncabezado||I.NomCampo ||cSeparador;
   END LOOP;

   FOR X IN C_ARCHIVO LOOP
      IF X.CodPaisOcurr = '001' THEN
         cEntiOcuSin := TRIM(TO_CHAR(TO_NUMBER(NVL(X.CodProvOcurr,'000')),'00'));
      ELSE
         cEntiOcuSin := '34';
      END IF;

      -- Status del Siniestro
      IF X.Sts_Siniestro IN ('EMI','PGP') THEN
         BEGIN
            SELECT 'S'
              INTO cAprobPago
              FROM APROBACIONES
             WHERE IdSiniestro    = X.IdSiniestro
               AND IdPoliza       = X.IdPoliza
               AND StsAprobacion IN ('PGP');
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
              cAprobPago := 'N';
            WHEN TOO_MANY_ROWS THEN
              cAprobPago := 'S';
         END;
         IF cAprobPago = 'N' THEN
            cEstts_Sin := '4'; -- Pendiente de Pago
         ELSE
            cEstts_Sin := '1'; -- Pago Parcial
         END IF;
      ELSIF X.Sts_Siniestro IN ('ANU','REZ') THEN
         cEstts_Sin := '3'; -- Rechazado o Cancelado
      ELSIF X.Monto_Pago_Moneda = X.Monto_Reserva_Moneda OR 
            X.Sts_Siniestro = 'PAG' THEN --X.Sts_Siniestro = 'PGT' THEN
        cEstts_Sin := '2'; -- Pagado Total
      ELSE
        cEstts_Sin := '5'; -- Litigio
      END IF;

      RESERVAS(X.IdPoliza, X.IdSiniestro);

      -- Totales para Registro de Control
      nTotPoliza        := nTotPoliza + 1;
      nTotCertif        := nTotCertif + 1;
      IF X.Fecha_Nac IS NOT NULL THEN
         nTotFecNac     := nTotFecNac + 1;
      END IF;
      IF X.FechOcuSin IS NOT NULL THEN
         nTotFecOcurr   := nTotFecOcurr + 1;
      END IF;
      IF X.FechRepSin IS NOT NULL THEN
         nTotFecRepor   := nTotFecRepor + 1;
      END IF;
      nTotMtoSiniBe1    := nTotMtoSiniBe1 + nMtoSiniBe1;
      nTotMtoSiniBe2    := nTotMtoSiniBe2 + nMtoSiniBe2;
      nTotMtoSiniBe3    := nTotMtoSiniBe3 + nMtoSiniBe3;
      nTotMtoSiniBe4    := nTotMtoSiniBe4 + nMtoSiniBe4;
      nTotMtoSiniBe5    := nTotMtoSiniBe5 + nMtoSiniBe5;
      nTotMtoSiniBe6    := nTotMtoSiniBe6 + nMtoSiniBe6;
      nTotMtoSiniBe7    := nTotMtoSiniBe7 + nMtoSiniBe7;
      nTotMtoSiniBe8    := nTotMtoSiniBe8 + nMtoSiniBe8;
      nTotMtoSiniBe9    := nTotMtoSiniBe9 + nMtoSiniBe9;
      nTotPlanPoliza    := nTotPlanPoliza + TO_NUMBER(X.PlanPoliza);
      nTotPerEspe       := nTotPerEspe + X.Pdo_Espera;
      nTotMtoReclam     := nTotMtoReclam + nMtoRec;
      nTotMtoDeduc      := nTotMtoDeduc + X.MtoDeducible;
      nTotMtoCoaseg     := nTotMtoCoaseg + X.MtoCoaseguro;
      nTotAnioPol       := nTotAnioPol + X.AnioPoliza;
      nTotDiasBen3      := nTotDiasBen3 + X.MaxDiasBenef3;
      nTotSubTipo       := nTotSubTipo + TO_NUMBER(X.SubTipoSeg);
      nTotTipoRies      := nTotTipoRies + TO_NUMBER(X.TipoRiesgo);
   END LOOP;
   nLinea  := 1;
   cCadena := TRIM(TO_CHAR(nTotPoliza,'99999999999999999990'))    || cSeparador ||
              TRIM(TO_CHAR(nTotCertif,'99999999999999999990'))    || cSeparador ||
              '0'                                                 || cSeparador ||
              '0'                                                 || cSeparador ||
              TRIM(TO_CHAR(nTotFecOcurr,'99999999999999999990'))  || cSeparador ||
              TRIM(TO_CHAR(nTotFecRepor,'99999999999999999990'))  || cSeparador ||
              '0'                                                 || cSeparador ||
              '0'                                                 || cSeparador ||
              '0'                                                 || cSeparador ||
              TRIM(TO_CHAR(nTotAnioPol,'99999999999999999990'))   || cSeparador ||
              TRIM(TO_CHAR(nTotMtoSiniBe1,'99999999999999999990'))|| cSeparador ||
              TRIM(TO_CHAR(nTotMtoSiniBe2,'99999999999999999990'))|| cSeparador ||
              TRIM(TO_CHAR(nTotMtoSiniBe3,'99999999999999999990'))|| cSeparador ||
              TRIM(TO_CHAR(nTotMtoSiniBe4,'99999999999999999990'))|| cSeparador ||
              TRIM(TO_CHAR(nTotMtoSiniBe5,'99999999999999999990'))|| cSeparador ||
              TRIM(TO_CHAR(nTotMtoSiniBe6,'99999999999999999990'))|| cSeparador ||
              TRIM(TO_CHAR(nTotMtoSiniBe7,'99999999999999999990'))|| cSeparador ||
              TRIM(TO_CHAR(nTotMtoSiniBe8,'99999999999999999990'))|| cSeparador ||
              TRIM(TO_CHAR(nTotMtoSiniBe9,'99999999999999999990'))|| cSeparador ||
              '0'                                                 || cSeparador ||
              TRIM(TO_CHAR(nTotPlanPoliza,'99999999999999999990'))|| cSeparador ||
              TRIM(TO_CHAR(nTotFecNac,'99999999999999999990'))    || cSeparador ||
              '0'                                                 || cSeparador ||
              '0'                                                 || cSeparador ||
              TRIM(TO_CHAR(nTotSubTipo,'99999999999999999990'))   || cSeparador ||
              '0'                                                 || cSeparador ||
              TRIM(TO_CHAR(nTotPerEspe,'99999999999999999990'))   || cSeparador ||
              '0'                                                 || cSeparador ||
              OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                       OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 26), cPuntoComa) || CHR(13);
   OC_ARCHIVO.Escribir_Linea(cCadena, cIdUsr, nLinea);

   nLinea  := nLinea + 1;
   cCadena := SUBSTR(cEncabezado,1,LENGTH(cEncabezado)-1) || CHR(13);
   OC_ARCHIVO.Escribir_Linea(cCadena, cIdUsr, nLinea);

   FOR X IN C_ARCHIVO LOOP
      IF X.CodPaisOcurr = '001' THEN
         cEntiOcuSin := TRIM(TO_CHAR(TO_NUMBER(NVL(X.CodProvOcurr,'000')),'00'));
      ELSE
         cEntiOcuSin := '34';
      END IF;

      -- Status del Siniestro
      IF X.Sts_Siniestro IN ('EMI','PGP') THEN
         BEGIN
            SELECT 'S'
              INTO cAprobPago
              FROM APROBACIONES
             WHERE IdSiniestro    = X.IdSiniestro
               AND IdPoliza       = X.IdPoliza
               AND StsAprobacion IN ('PGP');
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
              cAprobPago := 'N';
            WHEN TOO_MANY_ROWS THEN
              cAprobPago := 'S';
         END;
         IF cAprobPago = 'N' THEN
            cEstts_Sin := '4'; -- Pendiente de Pago
         ELSE
            cEstts_Sin := '1'; -- Pago Parcial
         END IF;
      ELSIF X.Sts_Siniestro IN ('ANU','REZ') THEN
         cEstts_Sin := '3'; -- Rechazado o Cancelado
      ELSIF X.Monto_Pago_Moneda = X.Monto_Reserva_Moneda THEN --X.Sts_Siniestro = 'PGT' THEN
        cEstts_Sin := '2'; -- Pagado Total
      ELSE
        cEstts_Sin := '5'; -- Litigio
      END IF;

      RESERVAS(X.IdPoliza, X.IdSiniestro);

      nLinea  := nLinea + 1;
      cCadena := OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 1), X.Poliza) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 2), X.Certi) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 3), X.Tipo_Seg) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 4), X.Num_Sin) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 5), X.FechOcuSin) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 6), X.FechRepSin) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 7), cEntiOcuSin ) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 8), cEstts_Sin) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 9), X.Causa_Sin) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 10), X.AnioPoliza) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 11), nMtoSiniBe1) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 12), nMtoSiniBe2) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 13), nMtoSiniBe3) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 14), nMtoSiniBe4) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 15), nMtoSiniBe5) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 16), nMtoSiniBe6) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 17), nMtoSiniBe7) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 18), nMtoSiniBe8) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 19), nMtoSiniBe9) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 20), X.ModalPoliza) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 21), X.PlanPoliza ) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 22), X.Fecha_Nac) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 23), X.Moneda) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 24), X.Sexo) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 25), X.SubTipoSeg) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 26), X.Forma_Vta) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 27), X.Pdo_Espera) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 28), 0) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 29), cPuntoComa) || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cIdUsr, nLinea);
   END LOOP;
   OC_ARCHIVO.Escribir_Linea('EOF', cIdUsr, 0);
END SESASSINIESTROVIIND;
/

--
-- SESASSINIESTROVIIND  (Synonym) 
--
--  Dependencies: 
--   SESASSINIESTROVIIND (Procedure)
--
CREATE OR REPLACE PUBLIC SYNONYM SESASSINIESTROVIIND FOR SICAS_OC.SESASSINIESTROVIIND
/


GRANT EXECUTE ON SICAS_OC.SESASSINIESTROVIIND TO PUBLIC
/
