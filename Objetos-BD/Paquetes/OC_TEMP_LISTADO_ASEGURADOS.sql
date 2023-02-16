CREATE OR REPLACE PACKAGE OC_TEMP_LISTADO_ASEGURADOS IS
--
-- SE PROGRAMO LA VALIDACION DE LA MARCA CONCENTRADA PARA POLIZAS A DECLARACION   DECLA 20210604
--
  FUNCTION CORRELATIVO_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2;
  FUNCTION EXISTEN_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2;
  PROCEDURE VALIDAR_DATOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER);
  PROCEDURE PROCESA_CAMBIO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER);
  PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER);

END OC_TEMP_LISTADO_ASEGURADOS;





/

CREATE OR REPLACE PACKAGE BODY OC_TEMP_LISTADO_ASEGURADOS IS

FUNCTION CORRELATIVO_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2 IS
nIdAsegurado     SOLICITUD_DETALLE_ASEG.IdAsegurado%TYPE;
BEGIN
   SELECT NVL(MAX(IdAsegurado),0) + 1
     INTO nIdAsegurado
     FROM TEMP_LISTADO_ASEGURADOS
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND IdPoliza    = nIdPoliza;
    RETURN(nIdAsegurado);
END CORRELATIVO_ASEGURADO;

FUNCTION EXISTEN_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2 IS
cExistenAseg     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExistenAseg
        FROM TEMP_LISTADO_ASEGURADOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdPoliza    = nIdPoliza;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExistenAseg := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExistenAseg := 'S';
   END;
   RETURN(cExistenAseg);
END EXISTEN_ASEGURADOS;

PROCEDURE VALIDAR_DATOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) IS
nExiste         NUMBER(10);
cExiste         VARCHAR2(1);
CURSOR ASEG_Q IS
   SELECT DISTINCT IDetPol
     FROM TEMP_LISTADO_ASEGURADOS
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND IdPoliza    = nIdPoliza;
CURSOR DET_Q IS
   SELECT DISTINCT IDetPol
     FROM DETALLE_POLIZA
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND IdPoliza    = nIdPoliza
      AND StsDetalle  = 'EMI';
CURSOR DUP_Q IS
   SELECT NumDocIdentificacion, COUNT(*) 
     FROM TEMP_LISTADO_ASEGURADOS 
    WHERE IdPoliza   = nIdPoliza
      AND CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
   GROUP BY NumDocIdentificacion 
    HAVING COUNT(*) > 1;
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM POLIZAS
       WHERE IdPoliza   = nIdPoliza
         AND CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND StsPoliza  = 'EMI';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Emitida la Póliza No. '|| nIdPoliza);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros Emitidos la Póliza No. '|| nIdPoliza);
   END;

   FOR W IN ASEG_Q LOOP
      BEGIN
         SELECT 'S'
           INTO cExiste
           FROM DETALLE_POLIZA
          WHERE IDetPol     = W.IDetPol
            AND IdPoliza    = nIdPoliza
            AND CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND StsDetalle  = 'EMI';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20225,'NO Existe Emitido el Detalle/Subgrupo No. '|| W.IDetPol ||
                                    ' de la Póliza No. '|| nIdPoliza || 
                                    ' Debe Eliminar los Asegurados del Subgrupo o Emitir el Subgrupo en la Póliza');
      END;
   END LOOP;

   FOR Z IN DUP_Q LOOP
      RAISE_APPLICATION_ERROR(-20225,'Asegurados Duplicados con RFC No.  ' || Z.NumDocIdentificacion);
   END LOOP;   

   FOR W IN DET_Q LOOP
      IF OC_POLIZAS_RESUMEN_ENDOSO_CLA.EXISTE_LISTADO(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol) = 0 THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Listado de Asegurados para el Detalle/Subgrupo No. '|| W.IDetPol ||
                                 ' de la Póliza No. '|| nIdPoliza || 
                                 ' Debe Comunicarse con Operaciones o Actualizar el Listado para realizar el proceso');
      END IF;
   END LOOP;

   SELECT COUNT(*)
     INTO nExiste
     FROM TEMP_LISTADO_ASEGURADOS
    WHERE CodCia                 = nCodCia
      AND CodEmpresa             = nCodEmpresa
      AND IdPoliza               = nIdPoliza
      AND (TipoDocIdentificacion  = ' '
       OR  NumDocIdentificacion   = ' ');

   IF NVL(nExiste,0) > 0 THEN
      RAISE_APPLICATION_ERROR(-20225,'Existen Asegurados en el Listado, Sin Tipo o No. de Documento de Identificación. ' ||
                              ' Por Favor actualizar los Datos para Realizar el Cambio');
   END IF;

   IF OC_ENDOSO.CAMBIO_POR_LISTADO(nCodCia, nCodEmpresa, nIdPoliza) = 'S' THEN
      RAISE_APPLICATION_ERROR(-20225,'YA se realizó el Cambio de Asegurado Modelo por Listado en la Póliza No. ' || nIdPoliza);
   END IF;

END VALIDAR_DATOS;

PROCEDURE PROCESA_CAMBIO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) IS
nIDetPol            TEMP_LISTADO_ASEGURADOS.IDetPol%TYPE;
nIDetPolCLA         TEMP_LISTADO_ASEGURADOS.IDetPol%TYPE;
nIDetPolINA         TEMP_LISTADO_ASEGURADOS.IDetPol%TYPE;
nIDetPolNSS         TEMP_LISTADO_ASEGURADOS.IDetPol%TYPE;
nIdEndosoCLA        ENDOSOS.IdEndoso%TYPE := 0;
nIdEndosoINA        ENDOSOS.IdEndoso%TYPE := 0;
nIdEndosoNSS        ENDOSOS.IdEndoso%TYPE := 0;
nIdEndosoMov        ENDOSOS.IdEndoso%TYPE;
dFecIniVig          POLIZAS.FecIniVig%TYPE;
dFecFinVig          POLIZAS.FecFinVig%TYPE;
cCodPlanPago        POLIZAS.CodPlanPago%TYPE;
cTipoEndosoINA      ENDOSOS.TipoEndoso%TYPE := 'INA';
cTipoEndosoNSS      ENDOSOS.TipoEndoso%TYPE := 'NSS';
cTipoEndosoCLA      ENDOSOS.TipoEndoso%TYPE := 'CLA';
cTipoEndosoProc     ENDOSOS.TipoEndoso%TYPE;
cMotivoEndosoINA    ENDOSOS.Motivo_Endoso%TYPE := '010';
cMotivoEndosoNSS    ENDOSOS.Motivo_Endoso%TYPE := '990';
cCodPaisRes         PERSONA_NATURAL_JURIDICA.CodPaisRes%TYPE; 
cCodProvRes         PERSONA_NATURAL_JURIDICA.CodProvRes%TYPE;
cCodDistRes         PERSONA_NATURAL_JURIDICA.CodDistRes%TYPE;
cCodCorrRes         PERSONA_NATURAL_JURIDICA.CodCorrRes%TYPE;
nCodCliente         CLIENTES.CodCliente%TYPE;
nCod_Asegurado      ASEGURADO_CERTIFICADO.Cod_Asegurado%TYPE;
nCod_AsegModelo     ASEGURADO_CERTIFICADO.Cod_Asegurado%TYPE;
cIdTipoSeg          DETALLE_POLIZA.IdTipoSeg%TYPE;
cPlanCob            DETALLE_POLIZA.PlanCob%TYPE;
nSumaAsegEndoso     ENDOSOS.Suma_Aseg_Moneda%TYPE;
nPrimaNetaEndoso    ENDOSOS.Prima_Neta_Moneda%TYPE;
nPrimaNetaAseg      ENDOSOS.Prima_Neta_Moneda%TYPE;
nTasacambio         TASAS_CAMBIO.Tasa_Cambio%TYPE;
nCantEndosoInc      NUMBER(20);
nCantEndosoExc      NUMBER(20);
nTotAsegEndosoExc   NUMBER(20) := 0;
nCantAsegListado    NUMBER(20);
nCuentaAseg         NUMBER(20);
nAsegExiste         NUMBER(20);
cNaturalidad        VARCHAR2(2);
--
CINDCONCENTRADA     POLIZAS.INDCONCENTRADA%TYPE;  --DECLA
NDETALLE_MODELO     NUMBER;                       --DECLA

CURSOR DET_Q IS
   SELECT DISTINCT T.IDetPol, D.CantAsegModelo + 1 CantAsegModelo, D.IdTipoSeg, D.PlanCob
     FROM TEMP_LISTADO_ASEGURADOS T, DETALLE_POLIZA D
    WHERE D.StsDetalle    = 'EMI'
      AND D.IndAsegModelo = 'S'
      AND D.IDetPol       = T.IDetPol
      AND D.IdPoliza      = T.IdPoliza
      AND D.CodEmpresa    = T.CodEmpresa
      AND D.CodCia        = T.CodCia
      AND T.CodCia        = nCodCia
      AND T.CodEmpresa    = nCodEmpresa
      AND T.IdPoliza      = nIdPoliza
    ORDER BY T.IDetPol;
CURSOR LISTA_Q IS
   SELECT *
     FROM TEMP_LISTADO_ASEGURADOS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND IdPoliza   = nIdPoliza
      AND IDetPol    = nIDetPol
    ORDER BY IDetPol, IdAsegurado;
CURSOR ASEG_Q IS
   SELECT Cod_Asegurado, Estado, IdEndoso
     FROM ASEGURADO_CERTIFICADO
    WHERE CodCia         = nCodCia
      AND IdPoliza       = nIdPoliza
      AND IDetPol        = nIDetPol
      AND IdEndoso      IN (nIdEndosoCLA, nIdEndosoINA)
      AND Cod_Asegurado != nCod_AsegModelo
      AND Estado        IN ('SOL','XRE');
CURSOR COB_Q IS
   SELECT TipoRef, NumRef, CodCobert, SumaAseg_Local, SumaAseg_Moneda,
          Tasa, Prima_Moneda, Prima_Local, Cod_Moneda,
          Deducible_Local, Deducible_Moneda
     FROM COBERT_ACT_ASEG
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCod_AsegModelo
      AND IdTipoSeg     = cIdTipoSeg
      AND PlanCob       = cPlanCob;
CURSOR ASIST_Q IS
   SELECT CodAsistencia, CodMoneda, MontoAsistLocal, MontoAsistMoneda,
          StsAsistencia, FecSts
     FROM ASISTENCIAS_ASEGURADO
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCod_AsegModelo;
BEGIN
   OC_TEMP_LISTADO_ASEGURADOS.VALIDAR_DATOS(nCodCia, nCodEmpresa, nIdPoliza);

   BEGIN
      SELECT FecIniVig,  FecFinVig,   CodPlanPago,
             P.INDCONCENTRADA,  --DECLA
             OC_GENERALES.TASA_DE_CAMBIO(Cod_Moneda, TRUNC(SYSDATE))
        INTO dFecIniVig, dFecFinVig, cCodPlanPago,
             CINDCONCENTRADA,  --DECLA
             nTasacambio
        FROM POLIZAS P
       WHERE IdPoliza   = nIdPoliza
         AND CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Póliza No. '|| nIdPoliza);
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20225,SQLERRM);
   END;

   nTotAsegEndosoExc := 0;
   NDETALLE_MODELO   := 0;  --DECLA
   FOR X IN DET_Q LOOP
      BEGIN
         SELECT AC.Cod_Asegurado
           INTO nCod_AsegModelo
           FROM PERSONA_NATURAL_JURIDICA P, ASEGURADO A, ASEGURADO_CERTIFICADO AC
          WHERE P.Nombre               LIKE '%ASEGURADO%'
            AND P.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
            AND P.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
            AND A.Cod_Asegurado           = AC.Cod_Asegurado
            AND AC.CodCia                 = nCodCia
            AND AC.IdPoliza               = nIdPoliza
            AND AC.IDetPol                = X.IDetPol;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20225,'NO Puede Cambiar Asegurado Modelo de la Póliza No. ' || nIdPoliza ||
                                    ' porque NO Existe el Asegurado Modelo en el Subgrupo No. ' || nIDetPol);
         WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20225,'NO Puede Cambiar Asegurado Modelo de la Póliza No. ' || nIdPoliza ||
                                    ' porque Tiene mas de un Asegurado Modelo en el Subgrupo No. ' || nIDetPol);
      END;

      nIDetPol      := X.IDetPol;
      cIdTipoSeg    := X.IdTipoSeg;
      cPlanCob      := X.PlanCob;

      -- Genera Endoso CLA - Cambio Listado de Asegurados
      IF NVL(nIdEndosoCLA,0) = 0 THEN
         nIdEndosoCLA  := OC_ENDOSO.CREAR(nIdPoliza);
         nIDetPolCLA   := nIDetPol;
         OC_ENDOSO.INSERTA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndosoCLA, cTipoEndosoCLA,
                           'CLA-' || TRIM(TO_CHAR(nIdPoliza)) || '-' || TRIM(TO_CHAR(nIdEndosoCLA)),
                           dFecIniVig, dFecFinVig, cCodPlanPago, 0, 0, 0, '050', NULL);
         OC_ENDOSO_TEXTO.INSERTA(nIdPoliza, nIdEndosoCLA, 'Cambio del Asegurado Modelo por Listado de Asegurados sin Cobro de Prima');
      END IF;

      SELECT COUNT(*)
        INTO nCantAsegListado
        FROM TEMP_LISTADO_ASEGURADOS
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol;

      cTipoEndosoProc     := NULL;
      nPrimaNetaAseg      := 0;
      IF NVL(X.CantAsegModelo,0) < NVL(nCantAsegListado,0) THEN
         nCantEndosoInc      := NVL(nCantAsegListado,0) - NVL(X.CantAsegModelo,0);
         nCantEndosoExc      := 0;
         cTipoEndosoProc     := 'INA';
         nSumaAsegEndoso     := 0;
         nPrimaNetaEndoso    := 0;
      ELSIF NVL(X.CantAsegModelo,0) > NVL(nCantAsegListado,0) THEN
         nCantEndosoInc      := 0;
         nCantEndosoExc      := NVL(X.CantAsegModelo,0) - NVL(nCantAsegListado,0);
         nTotAsegEndosoExc   := NVL(nTotAsegEndosoExc,0) + NVL(nCantEndosoExc,0);
         cTipoEndosoProc     := 'NSS';
         nSumaAsegEndoso     := 0; -- Endoso NSS no registra Suma Asegurada
         nPrimaNetaAseg      := 0;
         FOR Z IN COB_Q LOOP
            nPrimaNetaAseg   := NVL(nPrimaNetaAseg,0) + (Z.Prima_Moneda / NVL(X.CantAsegModelo,0));
         END LOOP;
         FOR Z IN ASIST_Q LOOP
            nPrimaNetaAseg   := NVL(nPrimaNetaAseg,0) + (Z.MontoAsistMoneda / NVL(X.CantAsegModelo,0));
         END LOOP;
         nPrimaNetaEndoso    := NVL(nPrimaNetaEndoso,0) + (NVL(nPrimaNetaAseg,0) * NVL(nCantEndosoExc,0));
      END IF;

      -- Genera Endoso INA/NSS - Inclusión de Asegurados/Nota de Crédito Sin Sustento Técnico
      IF cTipoEndosoProc = 'INA' AND nIdEndosoINA = 0 THEN
         nIdEndosoINA  := OC_ENDOSO.CREAR(nIdPoliza);
         nIDetPolINA   := nIDetPol;
         OC_ENDOSO.INSERTA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndosoINA, cTipoEndosoINA,
                           'CLA-' || TRIM(TO_CHAR(nIdPoliza)) || '-' || TRIM(TO_CHAR(nIdEndosoINA)),
                           dFecIniVig, dFecFinVig, cCodPlanPago, nSumaAsegEndoso, nPrimaNetaEndoso,
                           0, cMotivoEndosoINA, NULL);

         OC_ENDOSO_TEXTO.INSERTA(nIdPoliza, nIdEndosoINA, 'Endoso de ' || INITCAP(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPENDOS', cTipoEndosoINA)) ||
                                 ' por Cambio del Asegurado Modelo a Listado de Asegurados con Cobro de Prima');
      END IF;

      IF cTipoEndosoProc = 'NSS' THEN 
         IF nIdEndosoNSS = 0 THEN
             nIdEndosoNSS  := OC_ENDOSO.CREAR(nIdPoliza);
             nIDetPolNSS   := nIDetPol;
             OC_ENDOSO.INSERTA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndosoNSS, cTipoEndosoNSS,
                               'CLA-' || TRIM(TO_CHAR(nIdPoliza)) || '-' || TRIM(TO_CHAR(nIdEndosoNSS)),
                               dFecIniVig, dFecFinVig, cCodPlanPago, nSumaAsegEndoso, nPrimaNetaEndoso,
                               0, cMotivoEndosoNSS, NULL);
         ELSIF NVL(nPrimaNetaAseg,0) != 0 THEN
            UPDATE ENDOSOS
               SET Prima_Neta_Moneda = NVL(Prima_Neta_Moneda,0) + NVL(nPrimaNetaEndoso,0),
                   Prima_Neta_Local  = (NVL(Prima_Neta_Moneda,0) + NVL(nPrimaNetaEndoso,0)) * nTasaCambio
             WHERE CodCia     = nCodCia
               AND CodEmpresa = nCodEmpresa
               AND IdPoliza   = nIdPoliza
               AND IdEndoso   = nIdEndosoNSS;
         END IF;

         OC_ENDOSO_TEXTO.INSERTA(nIdPoliza, nIdEndosoNSS, 'Endoso de ' || INITCAP(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPENDOS', cTipoEndosoNSS)) ||
                                 ' por Cambio del Asegurado Modelo a Listado de Asegurados con Devolución de Prima por ' ||
                                 TRIM(TO_CHAR(NVL(nPrimaNetaEndoso,0),'999,999,999,990.00')) || ' de ' || 
                                 TRIM(TO_CHAR(nTotAsegEndosoExc,'999,999,990')) || ' Asegurados Excluidos sin Datos de Registro en Listado Original');
      END IF;

      nAsegExiste := 0;
      nCuentaAseg := 0;
      FOR W IN LISTA_Q LOOP
         -- Verifica si Existe Registro en Persona Natural Juridica o Crea el Registro
         IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(W.TipoDocIdentificacion, W.NumDocIdentificacion) = 'N' THEN
            BEGIN
               SELECT CodPais, CodEstado, CodCiudad, CodMunicipio
                 INTO cCodPaisRes, cCodProvRes, cCodDistRes, cCodCorrRes
                 FROM APARTADO_POSTAL
                WHERE Codigo_Postal = W.CodigoPostalAseg;
            EXCEPTION
               WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                  cCodPaisRes := NULL;
                  cCodProvRes := NULL;
                  cCodDistRes := NULL;
                  cCodCorrRes := NULL;
            END;
            OC_PERSONA_NATURAL_JURIDICA.INSERTAR_PERSONA(W.TipoDocIdentificacion, W.NumDocIdentificacion,
                                                         W.NombreAseg, W.ApellidoPaternoAseg, W.ApellidoMaternoAseg,
                                                         NULL, W.SexoAseg, NULL, W.FechaNacimiento, W.DirecResAseg,
                                                         NULL, NULL, cCodPaisRes, cCodProvRes, cCodDistRes,
                                                         cCodCorrRes, W.CodigoPostalAseg, NULL, NULL, NULL, NULL);
         END IF;

         -- Valida que el Asegurado esté en el Rango de Aceptación de Coberturas
         IF OC_PERSONA_NATURAL_JURIDICA.FUNC_VALIDA_EDAD(W.TipoDocIdentificacion, W.NumDocIdentificacion, nCodCia, 
                                                         nCodEmpresa, cIdTipoSeg, cPlanCob)= 'N' THEN
            RAISE_APPLICATION_ERROR(-20225,'Edad del Asegurado Fuera del Rango de Aceptación de Coberturas');
         END IF;

         -- Crea Registro de Cliente si no existe
         nCodCliente := OC_CLIENTES.CODIGO_CLIENTE(W.TipoDocIdentificacion, W.NumDocIdentificacion);
         IF nCodCliente = 0  THEN
            nCodCliente  := OC_CLIENTES.INSERTAR_CLIENTE(W.TipoDocIdentificacion, W.NumDocIdentificacion);
         END IF;

         -- Se Crea El Código del Asegurado
         nCod_Asegurado := OC_ASEGURADO.CODIGO_ASEGURADO(nCodCia, nCodEmpresa, W.TipoDocIdentificacion, W.NumDocIdentificacion);
         IF nCod_Asegurado = 0 THEN
            nCod_Asegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(nCodCia, nCodEmpresa, W.TipoDocIdentificacion, W.NumDocIdentificacion);
         END IF;

         OC_CLIENTE_ASEG.INSERTA(nCodCliente, nCod_Asegurado);

         nCuentaAseg := NVL(nCuentaAseg,0) + 1;
         IF NVL(nCuentaAseg,0) <= NVL(X.CantAsegModelo,0) THEN
            nIdEndosoMov := nIdEndosoCLA;
         ELSIF cTipoEndosoProc = 'INA' THEN
            nIdEndosoMov := nIdEndosoINA;
         ELSIF cTipoEndosoProc = 'NSS' THEN
            nIdEndosoMov := nIdEndosoNSS;
         END IF;
         IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(nCodCia, nIdpoliza, nIDetPol, nCod_Asegurado) = 'N' THEN
            OC_ASEGURADO_CERTIFICADO.INSERTA(nCodCia, nIdpoliza, nIDetPol, nCod_Asegurado, nIdEndosoMov);
         ELSE
            -- Conteo de Asegurados Ya Cargados por Siniestro para Cambiarlos a Endoso Sin Cobro
            IF nIdEndosoMov = nIdEndosoINA THEN
               nAsegExiste := NVL(nAsegExiste,0) + 1;
            END IF;
         END IF;
      END LOOP;

      -- Cambia Asegurados Con Cobro de Prima para el Endoso sin Cobro de Prima por los Asegurados ya Cargados por Siniestro
      IF NVL(nAsegExiste,0) > 0 THEN
         nCuentaAseg := 1;
         FOR W IN ASEG_Q LOOP
            IF W.IdEndoso = nIdEndosoINA AND nCuentaAseg <= nAsegExiste THEN
               UPDATE ASEGURADO_CERTIFICADO
                  SET IdEndoso       = nIdEndosoCLA
                WHERE CodCia         = nCodCia
                  AND IdPoliza       = nIdPoliza
                  AND IDetPol        = nIDetPol
                  AND Cod_Asegurado  = W.Cod_Asegurado
                  AND Estado        IN ('SOL','XRE');

               nCuentaAseg := NVL(nCuentaAseg,0) + 1;
            END IF;
            IF nCuentaAseg > nAsegExiste THEN
               EXIT;
            END IF;
         END LOOP;
      END IF;


      FOR W IN ASEG_Q LOOP
         DELETE COBERT_ACT_ASEG
          WHERE CodCia        = nCodCia
            AND CodEmpresa    = nCodEmpresa
            AND IdPoliza      = nIdPoliza
            AND IdetPol       = nIDetPol
            AND StsCobertura IN ('SOL','XRE')
            AND Cod_Asegurado = W.Cod_Asegurado;

         -- Carga Coberturas
         FOR Z IN COB_Q LOOP
            BEGIN
               INSERT INTO COBERT_ACT_ASEG
                     (IdPoliza, IDetPol, CodEmpresa, IdTipoSeg, CodCia,
                      CodCobert, StsCobertura, SumaAseg_Local, SumaAseg_Moneda,
                      Prima_Local, Prima_Moneda, Tasa, IdEndoso, TipoRef,
                      NumRef, PlanCob, Cod_Moneda, Deducible_Local, Deducible_Moneda,
                      Cod_Asegurado)
               VALUES(nIdPoliza, nIDetPol, nCodEmpresa, cIdTipoSeg, nCodCia,
                      Z.CodCobert, W.Estado, Z.SumaAseg_Local, Z.SumaAseg_Moneda,
                      Z.Prima_Local / NVL(X.CantAsegModelo,0), Z.Prima_Moneda / NVL(X.CantAsegModelo,0),
                      Z.Prima_Moneda / NVL(X.CantAsegModelo,0) / Z.SumaAseg_Moneda, W.IdEndoso, Z.TipoRef,
                      Z.NumRef, cPlanCob, Z.Cod_Moneda, Z.Deducible_Local, Z.Deducible_Moneda,
                      W.Cod_Asegurado);
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX THEN
                  RAISE_APPLICATION_ERROR(-20225,'Existen Coberturas Duplicadas para Detalle de la Póliza: '||
                                          TRIM(TO_CHAR(nIdPoliza))||' - '||TO_CHAR(nIDetPol) || ' y Asegurado ' ||
                                          W.Cod_Asegurado);
            END;
         END LOOP;

         -- Carga Asistencias
         FOR Z IN ASIST_Q LOOP
            BEGIN
               INSERT INTO ASISTENCIAS_ASEGURADO
                      (CodCia, CodEmpresa, IdPoliza, IDetPol, Cod_Asegurado, CodAsistencia,
                       CodMoneda, MontoAsistLocal, MontoAsistMoneda, StsAsistencia,
                       FecSts, IdEndoso)
               VALUES (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, W.Cod_Asegurado, Z.CodAsistencia,
                       Z.CodMoneda, Z.MontoAsistLocal / NVL(X.CantAsegModelo,0), 
                       Z.MontoAsistMoneda / NVL(X.CantAsegModelo,0), 
                       DECODE(W.Estado,'SOL','SOLICI','XRENOV'), TRUNC(SYSDATE), W.IdEndoso);
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX THEN
                  RAISE_APPLICATION_ERROR(-20225,'Existen Asistencias Duplicadas para Detalle de la Póliza: '||
                                          TRIM(TO_CHAR(nIdPoliza))||' - '||TO_CHAR(nIDetPol) || ' Asegurado '||
                                          W.Cod_Asegurado || ' y Endoso No. ' || W.IdEndoso);
            END;
         END LOOP;

         OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, W.Cod_Asegurado);
         OC_ASEGURADO_CERTIFICADO.ACTUALIZA_ASISTENCIAS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, W.Cod_Asegurado);
      END LOOP;

      -- Excluye Asegurado Modelo
      OC_ASEGURADO_CERTIFICADO.EXCLUIR(nCodCia, nIdPoliza, nIDetPol, nCod_AsegModelo, TRUNC(SYSDATE), 'CLA');
      OC_COBERT_ACT_ASEG.EXCLUIR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCod_AsegModelo);
      OC_ASISTENCIAS_ASEGURADO.EXCLUIR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCod_AsegModelo);
      OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCod_AsegModelo);
      OC_ASEGURADO_CERTIFICADO.ACTUALIZA_ASISTENCIAS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCod_AsegModelo);

      -- Se quita la Marca y Cantidad de Asegurado Modelo
      UPDATE DETALLE_POLIZA DP
         SET IndAsegModelo = 'N',
             CantAsegModelo = 0
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdPoliza   = nIdPoliza
         AND DP.IDETPOL = nIDetPol;
      -- SE VALIDA SI YA NO HAY SUBGRUPOS CON ASEGURADO MODELO  DECLA
      SELECT COUNT(*)
        INTO NDETALLE_MODELO
        FROM DETALLE_POLIZA DP
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdPoliza   = nIdPoliza
         AND NVL(IndAsegModelo,'N') = 'S';
      -- SI NO HAY MAS SUBGRUPOS CON ASEGURADO MODELO SE QUITA LA MARCA CONCETRADA  DECLA 
      IF NDETALLE_MODELO = 0 THEN 
         UPDATE POLIZAS P
            SET P.INDCONCENTRADA = 'N'
          WHERE CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND IdPoliza   = nIdPoliza;
      END IF;   
   END LOOP;

   -- Actualiza y Emite Endoso de Cambio de Asegurado Modelo por Listado de Asegurados
   IF NVL(nIdEndosoCLA,0) != 0 THEN
      OC_ENDOSO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPolCLA, nIdEndosoCLA);
      IF OC_ENDOSO.VALIDA_ENDOSO(nCodCia, nIdPoliza, nIdEndosoCLA, cNaturalidad) = 'S' THEN
         OC_ENDOSO.EMITIR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPolCLA, nIdEndosoCLA, cTipoEndosoCLA);
      END IF;
   END IF;

   -- Actualiza y Emite Endoso por Inclusión de Asegurados
   IF NVL(nIdEndosoINA,0) != 0 THEN
      OC_ENDOSO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPolINA, nIdEndosoINA);
      IF OC_ENDOSO.VALIDA_ENDOSO(nCodCia, nIdPoliza, nIdEndosoINA, cNaturalidad) = 'S' THEN
         OC_ENDOSO.EMITIR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPolINA, nIdEndosoINA, cTipoEndosoINA);
      END IF;
   END IF;

   -- Actualiza y Emite Endoso por Exclusión de Asegurados
   IF NVL(nIdEndosoNSS,0) != 0 THEN
      IF OC_ENDOSO.VALIDA_ENDOSO(nCodCia, nIdPoliza, nIdEndosoNSS, cNaturalidad) = 'S' THEN
         OC_ENDOSO.EMITIR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPolNSS, nIdEndosoNSS, cTipoEndosoNSS);
      END IF;
   END IF;

   -- Se Elimina Listado de Asegurados
   OC_TEMP_LISTADO_ASEGURADOS.ELIMINAR(nCodCia, nCodEmpresa, nIdPoliza);
END PROCESA_CAMBIO;

PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) IS
BEGIN
   DELETE TEMP_LISTADO_ASEGURADOS
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza;
END;

END OC_TEMP_LISTADO_ASEGURADOS;
