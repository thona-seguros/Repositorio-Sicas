--
-- SESASEMISIONGMIND  (Procedure) 
--
--  Dependencies: 
--   STANDARD (Package)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--   OC_ARCHIVO (Package)
--   PLAN_COBERTURAS (Table)
--   POLIZAS (Table)
--   OC_ENTREGAS_CNSF_CONFIG (Package)
--   OC_ENTREGAS_CNSF_PLANTILLA (Package)
--   CONFIG_PLANTILLAS_CAMPOS (Table)
--   CONFIG_SESAS_TIPO_SEGURO (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--   ASEGURADO (Table)
--   OC_CONFIG_PLANTILLAS_CAMPOS (Package)
--   OC_DETALLE_FACTURAS (Package)
--   COBERTURAS_DE_SEGUROS (Table)
--   COBERT_ACT (Table)
--   DETALLE_POLIZA (Table)
--   ENTREGAS_CNSF_CONFIG (Table)
--   OC_SINIESTRO (Package)
--
CREATE OR REPLACE PROCEDURE SICAS_OC.SESASEMISIONGMIND (nCodCia NUMBER, nCodEmpresa NUMBER, cCodEntrega VARCHAR2,
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
nSABenef1         NUMBER(20) := 0;
nSABenef2         NUMBER(20) := 0;
nPmaEmiBe1        NUMBER(20) := 0;
nPmaEmiBe2        NUMBER(20) := 0;
cPuntoComa        VARCHAR2(1) := ';';
nTotPoliza        NUMBER(20)  := 0;
nTotCertif        NUMBER(20)  := 0;
nTotFecIni        NUMBER(20)  := 0;
nTotFecFin        NUMBER(20)  := 0;
nTotFecAlta       NUMBER(20)  := 0;
nTotFecBaja       NUMBER(20)  := 0;
nTotFecNac        NUMBER(20)  := 0;
nTotStsPol        NUMBER(20)  := 0;
nTotStsCert       NUMBER(20)  := 0;
nTotEntCont       NUMBER(20)  := 0;
nTotSABenef1      NUMBER(20)  := 0;
nTotSABenef2      NUMBER(20)  := 0;
nTotPmaEmiBe1     NUMBER(20)  := 0;
nTotPmaEmiBe2     NUMBER(20)  := 0;
nTotAnioPol       NUMBER(20)  := 0;
nTotIniCob        NUMBER(20)  := 0;
nTotSubTipo       NUMBER(20)  := 0;

CURSOR C_CAMPO IS
   SELECT NomCampo
     FROM CONFIG_PLANTILLAS_CAMPOS
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND CodPlantilla = cCodPlantilla
    ORDER BY OrdenCampo;

CURSOR C_ARCHIVO IS
   SELECT D.NumDetRef Poliza, D.IDetPol Certi, C.TipoSeguro Tipo_Seg,
          DECODE(P.Cod_Moneda,'PS','N',DECODE(P.Cod_Moneda,'US','E','I')) MONEDA,
          TO_CHAR(D.FecIniVig,'YYYYMMDD') Ini_Vig, TO_CHAR(D.FecFinVig,'YYYYMMDD') Fin_Vig,
          TO_CHAR(D.FecIniVig,'YYYYMMDD') Fecha_Alta, TO_CHAR(D.FecAnul,'YYYYMMDD') Fecha_Baja,
          TO_CHAR(PN.FecNacimiento,'YYYYMMDD') Fecha_Nac, PN.Sexo,
          NVL(C.ModalSumaAseg,'N') ModalSumaAseg, 'C' Forma_Vta,
          CEIL(MONTHS_BETWEEN(D.FecFinVig,D.FecIniVig)/12) AnioPoliza,
          NVL(C.InicioCobertura,2) IniCob, NVL(C.SubTipoSeg,'1') SubTipoSeg,
          PN.CodPaisRes CodPais, PN.CodProvRes CodEstado, P.IdPoliza, P.StsPoliza,
          P.FecFinVig FecFinVigPol, D.IdTipoSeg, D.IDetPol, D.StsDetalle, D.FecFinVig
     FROM DETALLE_POLIZA D, POLIZAS P, ASEGURADO A, PERSONA_NATURAL_JURIDICA PN, CONFIG_SESAS_TIPO_SEGURO C
    WHERE PN.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
      AND PN.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
      AND A.Cod_Asegurado            = D.Cod_Asegurado
      AND A.CodEmpresa               = D.CodEmpresa
      AND A.CodCia                   = D.CodCia
      AND C.IdTipoSeg                = D.IdTipoSeg
      AND C.CodEmpresa               = D.CodEmpresa
      AND C.CodCia                   = D.CodCia
      AND P.IdPoliza                 = D.IdPoliza
      AND (D.FecFinVig              >= dFecDesde
       OR (D.StsDetalle              = 'ANU'
      AND  D.FecAnul                >=  dFecDesde))
      AND D.IdTipoSeg               IN (SELECT IdTipoSeg
                                          FROM PLAN_COBERTURAS
                                         WHERE CodTipoPlan = '034')
      AND D.CodEmpresa               = nCodEmpresa
      AND D.CodCia                   = nCodCia;

   PROCEDURE COBERTURAS (nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER)IS
   CURSOR COBERT_Q IS
      SELECT NVL(CS.ClaveSesas,'1') ClaveSesas, SUM(SumaAseg_Local) Suma_Local, SUM(C.Prima_Local) Prima_Local
        FROM COBERT_ACT C, COBERTURAS_DE_SEGUROS CS
       WHERE CS.CodCobert  = C.CodCobert
         AND CS.PlanCob    = C.PlanCob
         AND CS.IdTipoSeg  = C.IdTipoSeg
         AND CS.CodEmpresa = C.CodEmpresa
         AND CS.CodCia     = C.CodCia
         AND C.IDetPol     = nIDetPol
         AND C.IdPoliza    = nIdPoliza
         AND C.CodCia      = nCodCia
       GROUP BY NVL(CS.ClaveSesas,'1');
   BEGIN
      nSABenef1   := 0;
      nSABenef2   := 0;
      nPmaEmiBe1  := 0;
      nPmaEmiBe2  := 0;
      FOR W IN COBERT_Q LOOP
         IF W.ClaveSesas = '1' THEN
            nSABenef1  := NVL(nSABenef1,0) + NVL(W.Suma_Local,0);
            nPmaEmiBe1 := NVL(nPmaEmiBe1,0) + NVL(W.Prima_Local,0);
         ELSE
            nSABenef2  := NVL(nSABenef2,0) + NVL(W.Suma_Local,0);
            nPmaEmiBe2 := NVL(nPmaEmiBe2,0) + NVL(W.Prima_Local,0);
         END IF;
      END LOOP;
      nPmaEmiBe1 := nPmaEmiBe1 + OC_DETALLE_FACTURAS.MONTO_SERVICIOS(nCodCia, nIdPoliza, nIDetPol);
   END COBERTURAS;
BEGIN
   cCodPlantilla := OC_ENTREGAS_CNSF_CONFIG.PLANTILLA(nCodCia, nCodEmpresa, cCodEntrega);
   cSeparador    := OC_ENTREGAS_CNSF_CONFIG.SEPARADOR(nCodCia, nCodEmpresa, cCodEntrega);
   FOR I IN  C_CAMPO  LOOP
      cEncabezado := cEncabezado||I.NomCampo ||cSeparador;
   END LOOP;

   FOR X IN C_ARCHIVO LOOP
      IF X.CodPais = '001' THEN
        IF TO_NUMBER(X.CodEstado) BETWEEN 1 AND 32 THEN
           cEntDd_Ctte := TRIM(TO_CHAR(TO_NUMBER(X.CodEstado),'00'));
        ELSE
           cEntDd_Ctte := '34';
        END IF;
      ELSIF X.CodPais != '001' THEN
         cEntDd_Ctte := '33';
      ELSE
         cEntDd_Ctte := '34'; --'99';
      END IF;

      -- Status de la Poliza
      IF X.StsPoliza = 'EMI' THEN
         cPoliz_Stus := '1'; -- En Vigor
         IF X.FecFinVigPol <= dFecHasta THEN
            cPoliz_Stus := '2'; -- Expirada o Terminada
         END IF;
      ELSIF X.StsPoliza = 'ANU' THEN
         cPoliz_Stus := '3'; -- Cancelada
         IF OC_SINIESTRO.TIENE_SINIESTRO(nCodCia, X.IdPoliza, X.IDetPol, dFecDesde) = 'S' THEN
            cPoliz_Stus := '4'; -- Baja por muerte, invalidez o incapacidad
         END IF;
      ELSIF X.StsPoliza = 'RES' THEN
         cPoliz_Stus := '5'; -- Rescatas
      ELSIF X.StsPoliza = 'SAL' THEN
         cPoliz_Stus := '6'; -- Saldada
      ELSIF X.StsPoliza = 'PRO' THEN
         cPoliz_Stus := '7'; -- Prorrogada
      ELSIF X.FecFinVigPol <= dFecHasta THEN
         cPoliz_Stus := '2'; -- Expirada o Terminada
      END IF;

      -- Status del Certificado
      IF X.StsDetalle = 'EMI' THEN
         cCerti_Stus := '1'; -- En Vigor
         IF X.FecFinVig <= dFecHasta THEN
            cCerti_Stus := '2'; -- Expirada o Terminada
         END IF;
      ELSIF X.StsDetalle IN ('ANU','EXC') THEN
         cCerti_Stus := '3'; -- Cancelada
         IF OC_SINIESTRO.TIENE_SINIESTRO(nCodCia, X.IdPoliza, X.IDetPol, dFecDesde) = 'S' THEN
            cCerti_Stus := '4'; -- Baja por muerte, invalidez o incapacidad
         END IF;
      ELSIF X.StsDetalle = 'RES' THEN
         cCerti_Stus := '5'; -- Rescatas
      ELSIF X.StsDetalle = 'SAL' THEN
         cCerti_Stus := '6'; -- Saldada
      ELSIF X.StsDetalle = 'PRO' THEN
         cCerti_Stus := '7'; -- Prorrogada
      ELSIF X.FecFinVig <= dFecHasta THEN
         cCerti_Stus := '2'; -- Expirada o Terminada
      END IF;

      COBERTURAS (nCodCia, X.IdPoliza, X.IDetPol);

      -- Totales para Registro de Control
      nTotPoliza        := nTotPoliza + 1;
      nTotCertif        := nTotCertif + 1;
      IF X.Ini_Vig IS NOT NULL THEN
         nTotFecIni     := nTotFecIni + 1;
      END IF;
      IF X.Fin_Vig IS NOT NULL THEN
         nTotFecFin     := nTotFecFin + 1;
      END IF;
      IF X.Fecha_Alta IS NOT NULL THEN
         nTotFecAlta    := nTotFecAlta + 1;
      END IF;
      IF X.Fecha_Baja IS NOT NULL THEN
         nTotFecBaja    := nTotFecBaja + 1;
      END IF;
      IF X.Fecha_Nac IS NOT NULL THEN
         nTotFecNac     := nTotFecNac + 1;
      END IF;
      nTotStsPol        := nTotStsPol + TO_NUMBER(cPoliz_Stus);
      nTotStsCert       := nTotStsCert + TO_NUMBER(cCerti_Stus);
      nTotEntCont       := nTotEntCont + 1;
      nTotSABenef1      := nTotSABenef1 + nSABenef1;
      nTotSABenef2      := nTotSABenef2 + nSABenef2;
      nTotPmaEmiBe1     := nTotPmaEmiBe1 + nPmaEmiBe1;
      nTotPmaEmiBe2     := nTotPmaEmiBe2 + nPmaEmiBe2;
      nTotAnioPol       := nTotAnioPol + X.AnioPoliza;
      nTotIniCob        := nTotIniCob + X.IniCob;
      nTotSubTipo       := nTotSubTipo + TO_NUMBER(X.SubTipoSeg);
   END LOOP;
   nLinea  := 1;
   cCadena := TRIM(TO_CHAR(nTotPoliza,'99999999999999999990'))    || cSeparador ||
              TRIM(TO_CHAR(nTotCertif,'99999999999999999990'))    || cSeparador ||
              '0'                                                 || cSeparador ||
              '0'                                                 || cSeparador ||
              TRIM(TO_CHAR(nTotFecIni,'99999999999999999990'))    || cSeparador ||
              TRIM(TO_CHAR(nTotFecFin,'99999999999999999990'))    || cSeparador ||
              TRIM(TO_CHAR(nTotFecAlta,'99999999999999999990'))   || cSeparador ||
              TRIM(TO_CHAR(nTotFecBaja,'99999999999999999990'))   || cSeparador ||
              TRIM(TO_CHAR(nTotFecNac,'99999999999999999990'))    || cSeparador ||
              '0'                                                 || cSeparador ||
              TRIM(TO_CHAR(nTotStsPol,'99999999999999999990'))    || cSeparador ||
              TRIM(TO_CHAR(nTotStsCert,'99999999999999999990'))   || cSeparador ||
              '0'                                                 || cSeparador ||
              '0'                                                 || cSeparador ||
              TRIM(TO_CHAR(nTotEntCont,'99999999999999999990'))   || cSeparador ||
              TRIM(TO_CHAR(nTotSABenef1,'99999999999999999990'))  || cSeparador ||
              TRIM(TO_CHAR(nTotSABenef2,'99999999999999999990'))  || cSeparador ||
              TRIM(TO_CHAR(nTotPmaEmiBe1,'99999999999999999990')) || cSeparador ||
              TRIM(TO_CHAR(nTotPmaEmiBe2,'99999999999999999990')) || cSeparador ||
              TRIM(TO_CHAR(nTotAnioPol,'99999999999999999990'))   || cSeparador ||
              TRIM(TO_CHAR(nTotIniCob,'99999999999999999990'))    || cSeparador ||
              TRIM(TO_CHAR(nTotSubTipo,'99999999999999999990'))   || cSeparador ||
              OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                       OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 23), cPuntoComa) || CHR(13);
   OC_ARCHIVO.Escribir_Linea(cCadena, cIdUsr, nLinea);

   nLinea  := nLinea + 1;
   cCadena := SUBSTR(cEncabezado,1,LENGTH(cEncabezado)-1) || CHR(13);
   OC_ARCHIVO.Escribir_Linea(cCadena, cIdUsr, nLinea);

   FOR X IN C_ARCHIVO LOOP
      IF X.CodPais = '001' THEN
        IF TO_NUMBER(X.CodEstado) BETWEEN 1 AND 32 THEN
           cEntDd_Ctte := TRIM(TO_CHAR(TO_NUMBER(X.CodEstado),'00'));
        ELSE
           cEntDd_Ctte := '34';
        END IF;
      ELSIF X.CodPais != '001' THEN
         cEntDd_Ctte := '33';
      ELSE
         cEntDd_Ctte := '34';--'99';
      END IF;

      -- Status de la Poliza
      IF X.StsPoliza = 'EMI' THEN
         cPoliz_Stus := '1'; -- En Vigor
         IF X.FecFinVigPol <= dFecHasta THEN
            cPoliz_Stus := '2'; -- Expirada o Terminada
         END IF;
      ELSIF X.StsPoliza = 'ANU' THEN
         cPoliz_Stus := '3'; -- Cancelada
         IF OC_SINIESTRO.TIENE_SINIESTRO(nCodCia, X.IdPoliza, X.IDetPol, dFecDesde) = 'S' THEN
            cPoliz_Stus := '4'; -- Baja por muerte, invalidez o incapacidad
         END IF;
      ELSIF X.StsPoliza = 'RES' THEN
         cPoliz_Stus := '5'; -- Rescatas
      ELSIF X.StsPoliza = 'SAL' THEN
         cPoliz_Stus := '6'; -- Saldada
      ELSIF X.StsPoliza = 'PRO' THEN
         cPoliz_Stus := '7'; -- Prorrogada
      ELSIF X.FecFinVigPol <= dFecHasta THEN
         cPoliz_Stus := '2'; -- Expirada o Terminada
      END IF;

      -- Status del Certificado
      IF X.StsDetalle = 'EMI' THEN
         cCerti_Stus := '1'; -- En Vigor
         IF X.FecFinVig <= dFecHasta THEN
            cCerti_Stus := '2'; -- Expirada o Terminada
         END IF;
      ELSIF X.StsDetalle IN ('ANU','EXC') THEN
         cCerti_Stus := '3'; -- Cancelada
         IF OC_SINIESTRO.TIENE_SINIESTRO(nCodCia, X.IdPoliza, X.IDetPol, dFecDesde) = 'S' THEN
            cCerti_Stus := '4'; -- Baja por muerte, invalidez o incapacidad
         END IF;
      ELSIF X.StsDetalle = 'RES' THEN
         cCerti_Stus := '5'; -- Rescatas
      ELSIF X.StsDetalle = 'SAL' THEN
         cCerti_Stus := '6'; -- Saldada
      ELSIF X.StsDetalle = 'PRO' THEN
         cCerti_Stus := '7'; -- Prorrogada
      ELSIF X.FecFinVig <= dFecHasta THEN
         cCerti_Stus := '2'; -- Expirada o Terminada
      END IF;

      COBERTURAS (nCodCia, X.IdPoliza, X.IDetPol);

      nLinea  := nLinea + 1;
      cCadena := OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 1),  X.Poliza) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 2),  X.Certi) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 3),  X.Tipo_Seg) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 4),  X.MONEDA) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 5),  X.Ini_Vig) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 6),  X.Fin_Vig) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 7),  X.Fecha_Alta) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 8),  X.Fecha_Baja) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 9),  X.Fecha_Nac) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 10), X.Sexo) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 11), cPoliz_Stus) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 12), cCerti_Stus) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 13), X.ModalSumaAseg) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 14), X.Forma_Vta) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 15), cEntDd_Ctte) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 16), nSABenef1) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 17), nSABenef2) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 18), nPmaEmiBe1) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 19), nPmaEmiBe2) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 20), X.AnioPoliza) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 21), X.IniCob) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 22), X.SubTipoSeg) || cSeparador ||
                 OC_ENTREGAS_CNSF_PLANTILLA.FORMATO_CAMPO(nCodCia, nCodEmpresa, cCodEntrega, cCodPlantilla,
                                                          OC_CONFIG_PLANTILLAS_CAMPOS.CAMPO(nCodCia, nCodEmpresa, cCodPlantilla, 23), cPuntoComa) || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cIdUsr, nLinea);

   END LOOP;
   OC_ARCHIVO.Escribir_Linea('EOF', cIdUsr, 0);
END SESASEMISIONGMIND;
/

--
-- SESASEMISIONGMIND  (Synonym) 
--
--  Dependencies: 
--   SESASEMISIONGMIND (Procedure)
--
CREATE OR REPLACE PUBLIC SYNONYM SESASEMISIONGMIND FOR SICAS_OC.SESASEMISIONGMIND
/


GRANT EXECUTE ON SICAS_OC.SESASEMISIONGMIND TO PUBLIC
/
