--
-- SESASSINIESTROAPIND  (Procedure) 
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
--   DETALLE_POLIZA (Table)
--   ENTREGAS_CNSF_CONFIG (Table)
--
CREATE OR REPLACE PROCEDURE SICAS_OC.SESASSINIESTROAPIND (nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2,
                               dFecDesde DATE, dFecHasta DATE, cIdUsr VARCHAR2) IS
cCodPlantilla     ENTREGAS_CNSF_CONFIG.CodPlantilla%TYPE;
cSeparador        ENTREGAS_CNSF_CONFIG.Separador%TYPE;
cEncabezado       VARCHAR2(4000);
cSiniestro        VARCHAR2(1);
cPoliz_Stus       POLIZAS.StsPoliza%TYPE;
cCerti_Stus       DETALLE_POLIZA.StsDetalle%TYPE;
cEntDd_Ctte       VARCHAR2(2);
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
          D.IdTipoSeg, D.IdPoliza, S.Monto_Pago_Moneda, S.Monto_Reserva_Moneda
     FROM DETALLE_POLIZA D, POLIZAS P, CLIENTES CL, PERSONA_NATURAL_JURIDICA PN,
          SINIESTRO S, CONFIG_SESAS_TIPO_SEGURO C
    WHERE PN.Num_Doc_Identificacion  = CL.Num_Doc_Identificacion
      AND PN.Tipo_Doc_Identificacion = CL.Tipo_Doc_Identificacion
      AND CL.CodCliente              = P.CodCliente
      AND C.IdTipoSeg                = D.IdTipoSeg
      AND C.CodEmpresa               = D.CodEmpresa
      AND C.CodCia                   = D.CodCia
      AND S.Fec_Notificacion        >= dFecDesde
      AND S.Fec_Notificacion        >= dFecHasta
      AND S.Sts_Siniestro           != 'SOL'
      AND S.IDetPol                  = D.IDetPol
      AND S.IdPoliza                 = D.IdPoliza
      AND P.IdPoliza                 = D.IdPoliza
      AND D.IdTipoSeg               IN (SELECT IdTipoSeg
                                          FROM PLAN_COBERTURAS
                                         WHERE CodTipoPlan = '031')
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
      FOR W IN RESER_Q LOOP
         IF cCobAfectada IS NULL THEN
            cCobAfectada := W.ClaveSesas;
         END IF;
         nMtoRec   := NVL(nMtoRec,0) + W.MtoResMoneda;
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

      IF X.CodPais = '001' THEN
        IF TO_NUMBER(X.CodEstado) BETWEEN 1 AND 32 THEN
           cEntDd_Ctte := TRIM(TO_CHAR(TO_NUMBER(X.CodEstado),'00'));
        ELSE
           cEntDd_Ctte := '34';
        END IF;
      ELSIF X.CodPais != '001' THEN
         cEntDd_Ctte := '33';
      ELSE
         cEntDd_Ctte := '99';
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
            cEstts_Sin := '3'; -- Pendiente de Pago
         ELSE
            cEstts_Sin := '2'; -- Pago Parcial
         END IF;
      ELSIF X.Sts_Siniestro IN ('ANU','REZ') THEN
         cEstts_Sin := '5'; -- Rechazado o Cancelado
      ELSIF X.Monto_Pago_Moneda = X.Monto_Reserva_Moneda OR 
            X.Sts_Siniestro = 'PAG' THEN --X.Sts_Siniestro = 'PGT' THEN
        cEstts_Sin := '1'; -- Pagado Total
      ELSE
        cEstts_Sin := '4'; -- Litigio
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
              TRIM(TO_CHAR(nTotFecNac,'99999999999999999990'))    || cSeparador ||
              '0'                                                 || cSeparador ||
              '0'                                                 || cSeparador ||
              '0'                                                 || cSeparador ||
              TRIM(TO_CHAR(nTotFecOcurr,'99999999999999999990'))  || cSeparador ||
              TRIM(TO_CHAR(nTotFecRepor,'99999999999999999990'))  || cSeparador ||
              '0'                                                 || cSeparador ||
              '0'                                                 || cSeparador ||
              '0'                                                 || cSeparador ||
              '0'                                                 || cSeparador ||
              TRIM(TO_CHAR(nTotPerEspe,'99999999999999999990'))   || cSeparador ||
              '0'                                                 || cSeparador ||
              TRIM(TO_CHAR(nTotMtoReclam,'99999999999999999990')) || cSeparador ||
              '0'                                                 || cSeparador ||
              TRIM(TO_CHAR(nTotMtoDeduc,'99999999999999999990'))  || cSeparador ||
              TRIM(TO_CHAR(nTotMtoCoaseg,'99999999999999999990')) || cSeparador ||
              TRIM(TO_CHAR(nTotAnioPol,'99999999999999999990'))   || cSeparador ||
              TRIM(TO_CHAR(nTotDiasBen3,'99999999999999999990'))  || cSeparador ||
              TRIM(TO_CHAR(nTotSubTipo,'99999999999999999990'))   || cSeparador ||
              TRIM(TO_CHAR(nTotTipoRies,'99999999999999999990'))  || cSeparador ||
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

      IF X.CodPais = '001' THEN
        IF TO_NUMBER(X.CodEstado) BETWEEN 1 AND 32 THEN
           cEntDd_Ctte := TRIM(TO_CHAR(TO_NUMBER(X.CodEstado),'00'));
        ELSE
           cEntDd_Ctte := '34';
        END IF;
      ELSIF X.CodPais != '001' THEN
         cEntDd_Ctte := '33';
      ELSE
         cEntDd_Ctte := '99';
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
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 4), X.Moneda) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 5), X.Fecha_Nac) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 6), X.Sexo) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 7), X.Num_Sin) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 8), X.Num_Reclam) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 9), X.FechOcuSin) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 10), X.FechRepSin) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 11), cEstts_Sin) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 12), X.Forma_Vta) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 13), cEntDd_Ctte ) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 14), cEntiOcuSin ) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 15), X.Pdo_Espera) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 16), cCobAfectada) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 17), nMtoRec) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 18), X.Causa_Sin) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 19), X.MtoDeducible) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 20), X.MtoCoaseguro) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 21), X.AnioPoliza) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 22), X.MaxDiasBenef3) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 23), X.SubTipoSeg) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 24), X.TipoRiesgo) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 25), X.TipoMovRec) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 26), cPuntoComa) || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cIdUsr, nLinea);
   END LOOP;
   OC_ARCHIVO.Escribir_Linea('EOF', cIdUsr, 0);
END SESASSINIESTROAPIND;
/

--
-- SESASSINIESTROAPIND  (Synonym) 
--
--  Dependencies: 
--   SESASSINIESTROAPIND (Procedure)
--
CREATE OR REPLACE PUBLIC SYNONYM SESASSINIESTROAPIND FOR SICAS_OC.SESASSINIESTROAPIND
/


GRANT EXECUTE ON SICAS_OC.SESASSINIESTROAPIND TO PUBLIC
/
