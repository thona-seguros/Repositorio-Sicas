CREATE OR REPLACE PACKAGE GT_TEMP_LISTADO_DECLARACIONES AS

   FUNCTION CORRELATIVO_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN NUMBER;
   FUNCTION EXISTEN_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2;
   FUNCTION CORRELATIVO_ASIGNADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER) RETURN NUMBER;
   FUNCTION PRIMA_NETA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdAsegurado NUMBER) RETURN NUMBER;
   FUNCTION SUMA_ASEGURADA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdAsegurado NUMBER) RETURN NUMBER;
   PROCEDURE VALIDAR_DATOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER);
   PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER);
   PROCEDURE CALCULA_RFC(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER);
   PROCEDURE CALCULA_RFC_ESPECIAL(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, cNumDocIdentContrat VARCHAR2);
   PROCEDURE COMPARA_LISTADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, cCompararPor VARCHAR2);
   PROCEDURE APLICAR_ENDOSOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER);
   PROCEDURE EXCLUSION_ASEG_INI(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER);
   PROCEDURE GENERA_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER,
                               nCodAsegurado NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, cPlanCob VARCHAR2, 
                               cIdTipoSeg VARCHAR2, cCodMoneda VARCHAR2, nSumaAseg NUMBER);
   PROCEDURE CANCELA_FACTURAS (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                               nIDetPol NUMBER, nIdEndoso NUMBER, dFechaIniVig DATE);
   PROCEDURE ACTUALIZA_VALORES_ENDOSO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER);    
   PROCEDURE CALCULA_PRIMA_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                                      nCodAsegurado NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, 
                                      cPlanCob VARCHAR2, cIdTipoSeg VARCHAR2, cCodCobert VARCHAR2, nSumaAseg NUMBER);
   
   /*********************************************** DECLARACIONES HISTORICAS *************************************************************/                                      
   PROCEDURE APLICAR_ENDOSO_HIST(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER);                                      
   PROCEDURE PRE_EMITE_DECLARACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER);    
   PROCEDURE ACTUALIZA_VALORES_DET_POL_HIST(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER,
                                           nPrimaNetaLocalDetPol NUMBER, nPrimaNetaMonedaDetPol NUMBER, nSumaAsegLocalDetPol NUMBER, nSumaAsegMonedaDetPol NUMBER);
   PROCEDURE ACTUALIZA_VALORES_POL_HIST(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER);                                         
   PROCEDURE ACTUALIZA_ENDOSO_HIST(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER);
END GT_TEMP_LISTADO_DECLARACIONES;
/
create or replace PACKAGE BODY          GT_TEMP_LISTADO_DECLARACIONES AS

FUNCTION CORRELATIVO_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN NUMBER IS
nIdAsegurado     TEMP_LISTADO_DECLARACIONES.IdAsegurado%TYPE;
BEGIN
   SELECT NVL(MAX(IdAsegurado),0) + 1
     INTO nIdAsegurado
     FROM TEMP_LISTADO_DECLARACIONES
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
        FROM TEMP_LISTADO_DECLARACIONES
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

FUNCTION CORRELATIVO_ASIGNADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER) RETURN NUMBER IS
nIdAsegurado     TEMP_LISTADO_DECLARACIONES.IdAsegurado%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IdAsegurado,0)
        INTO nIdAsegurado
        FROM TEMP_LISTADO_DECLARACIONES
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdPoliza    = nIdPoliza
         AND IDetPol     = nIDetPol
         AND CodAsegurado= nCodAsegurado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN 
         nIdAsegurado := 0;
   END;
   RETURN(nIdAsegurado);
END CORRELATIVO_ASIGNADO;

FUNCTION PRIMA_NETA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdAsegurado NUMBER) RETURN NUMBER IS
nPrimaNeta TEMP_LISTADO_DECLARACIONES.PrimaNeta%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PrimaNeta,0)
        INTO nPrimaNeta
        FROM TEMP_LISTADO_DECLARACIONES
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdPoliza    = nIdPoliza
         AND IDetPol     = nIDetPol
         AND IdAsegurado = nIdAsegurado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPrimaNeta := 0;
   END;
   RETURN nPrimaNeta;
END PRIMA_NETA;

FUNCTION SUMA_ASEGURADA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdAsegurado NUMBER) RETURN NUMBER IS
nSumaAsegurada TEMP_LISTADO_DECLARACIONES.SumaAsegurada%TYPE;
BEGIN
    BEGIN
    SELECT NVL(SumaAsegurada,0)
      INTO nSumaAsegurada
      FROM TEMP_LISTADO_DECLARACIONES
     WHERE CodCia      = nCodCia
       AND CodEmpresa  = nCodEmpresa
       AND IdPoliza    = nIdPoliza
       AND IDetPol     = nIDetPol
       AND IdAsegurado = nIdAsegurado;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            nSumaAsegurada := 0;
    END;
    RETURN nSumaAsegurada;
END SUMA_ASEGURADA;

PROCEDURE VALIDAR_DATOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) IS
nExiste         NUMBER(10);
cExiste         VARCHAR2(1);
CURSOR ASEG_Q IS
   SELECT DISTINCT IDetPol
     FROM TEMP_LISTADO_DECLARACIONES
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
     FROM TEMP_LISTADO_DECLARACIONES 
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
      IF OC_DETALLE_POLIZA.TOTAL_ASEGURADOS(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol) <= 1 THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Listado de Asegurados para el Detalle/Subgrupo No. '|| W.IDetPol ||
                                 ' de la Póliza No. '|| nIdPoliza || 
                                 ' Debe Comunicarse con Operaciones o Actualizar el Listado para realizar el proceso');
      END IF;
   END LOOP;

   SELECT COUNT(*)
     INTO nExiste
     FROM TEMP_LISTADO_DECLARACIONES
    WHERE CodCia                 = nCodCia
      AND CodEmpresa             = nCodEmpresa
      AND IdPoliza               = nIdPoliza
      AND (TipoDocIdentificacion  = ' '
       OR  NumDocIdentificacion   = ' ');

   IF NVL(nExiste,0) > 0 THEN
      RAISE_APPLICATION_ERROR(-20225,'Existen Asegurados en el Listado, Sin Tipo o No. de Documento de Identificación. ' ||
                              ' Por Favor actualizar los Datos para Realizar el Comparativo');
   END IF;
END VALIDAR_DATOS;

PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) IS
BEGIN
   DELETE TEMP_LISTADO_DECLARACIONES
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza;
END ELIMINAR;

PROCEDURE CALCULA_RFC(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) IS
cTipoDocIdentificacion      TEMP_LISTADO_DECLARACIONES.TipoDocIdentificacion%TYPE;
cNumDocIdentificacion       TEMP_LISTADO_DECLARACIONES.NumDocIdentificacion%TYPE;
nCodAsegurado               TEMP_LISTADO_DECLARACIONES.CodAsegurado%TYPE;

CURSOR ASEG_Q IS
   SELECT IDetPol, IdAsegurado, NombreAseg, ApellidoPaternoAseg, 
          ApellidoMaternoAseg, FechaNacimiento
     FROM TEMP_LISTADO_DECLARACIONES
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND IdPoliza    = nIdPoliza;
BEGIN
   cTipoDocIdentificacion := 'RFC';
   FOR W IN ASEG_Q LOOP
      cNumDocIdentificacion  := OC_PERSONA_NATURAL_JURIDICA.NUMERO_TRIBUTARIO_RFC(W.NombreAseg, W.ApellidoPaternoAseg, W.ApellidoMaternoAseg, 
                                                                                  W.FechaNacimiento, 'FISICA');
      nCodAsegurado          := OC_ASEGURADO.CODIGO_ASEGURADO(nCodCia, nCodEmpresa, cTipoDocIdentificacion, cNumDocIdentificacion);
      UPDATE TEMP_LISTADO_DECLARACIONES
         SET TipoDocIdentificacion = cTipoDocIdentificacion,
             NumDocIdentificacion  = cNumDocIdentificacion,
             CodAsegurado          = nCodAsegurado
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdPoliza    = nIdPoliza
         AND IDetPol     = W.IDetPol
         AND IdAsegurado = W.IdAsegurado;
   END LOOP;
END CALCULA_RFC;

PROCEDURE CALCULA_RFC_ESPECIAL(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                               cNumDocIdentContrat VARCHAR2) IS
cTipoDocIdentificacion      TEMP_LISTADO_DECLARACIONES.TipoDocIdentificacion%TYPE;
cNumDocIdentificacion       TEMP_LISTADO_DECLARACIONES.NumDocIdentificacion%TYPE;
nCodAsegurado               TEMP_LISTADO_DECLARACIONES.CodAsegurado%TYPE;
nPos_Ini                    NUMBER;
nPos_Fin                    NUMBER;

CURSOR ASEG_Q IS
   SELECT IDetPol, IdAsegurado, NombreAseg, ApellidoPaternoAseg, 
          ApellidoMaternoAseg, FechaNacimiento
     FROM TEMP_LISTADO_DECLARACIONES
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND IdPoliza    = nIdPoliza;
BEGIN
   cTipoDocIdentificacion := 'ALGORI';
   FOR W IN ASEG_Q LOOP
      nPos_Ini := INSTR(W.NombreAseg,' ', 1, 1);

      IF nPos_Ini = 0 THEN
         cNumDocIdentificacion := cNumDocIdentContrat || SUBSTR(W.NombreAseg,LENGTH(W.NombreAseg)-1,2);
      ELSE
         cNumDocIdentificacion := cNumDocIdentContrat || SUBSTR(W.NombreAseg,nPos_Ini-2,2);
      END IF;

      nPos_Ini := INSTR(W.NombreAseg,' ', 1, 1) + 1;

      IF nPos_Ini > 1 THEN
         cNumDocIdentificacion := cNumDocIdentificacion || SUBSTR(W.NombreAseg,nPos_Ini,2);
      ELSE
         cNumDocIdentificacion := cNumDocIdentificacion || '00';
      END IF;

      IF W.ApellidoPaternoAseg IS NOT NULL THEN
         cNumDocIdentificacion := cNumDocIdentificacion || SUBSTR(W.ApellidoPaternoAseg,1,2);
      ELSE
         cNumDocIdentificacion := cNumDocIdentificacion || '00';
      END IF;

      IF W.ApellidoMaternoAseg IS NOT NULL THEN
         IF LENGTH(cNumDocIdentContrat) = 12 THEN
            cNumDocIdentificacion := cNumDocIdentificacion || SUBSTR(W.ApellidoMaternoAseg,1,2);
         ELSE
            cNumDocIdentificacion := cNumDocIdentificacion || SUBSTR(W.ApellidoMaternoAseg,1,1);
         END IF;
      ELSE
         IF LENGTH(cNumDocIdentContrat) = 12 THEN
            cNumDocIdentificacion := cNumDocIdentificacion || '00';
         ELSE
            cNumDocIdentificacion := cNumDocIdentificacion || '0';
         END IF;
      END IF;

      nCodAsegurado          := OC_ASEGURADO.CODIGO_ASEGURADO(nCodCia, nCodEmpresa, cTipoDocIdentificacion, cNumDocIdentificacion);

      UPDATE TEMP_LISTADO_DECLARACIONES
         SET TipoDocIdentificacion = cTipoDocIdentificacion,
             NumDocIdentificacion  = cNumDocIdentificacion,
             CodAsegurado          = nCodAsegurado
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdPoliza    = nIdPoliza
         AND IDetPol     = W.IDetPol
         AND IdAsegurado = W.IdAsegurado;
   END LOOP;
END CALCULA_RFC_ESPECIAL;

PROCEDURE COMPARA_LISTADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, cCompararPor VARCHAR2) IS
cEstado                 ASEGURADO_CERTIFICADO.Estado%TYPE;
cIndContinua            TEMP_LISTADO_DECLARACIONES.IndContinua%TYPE;
cIndAlta                TEMP_LISTADO_DECLARACIONES.IndAlta%TYPE;
cIndBaja                TEMP_LISTADO_DECLARACIONES.IndBaja%TYPE;
cIndLog                 TEMP_LISTADO_DECLARACIONES.IndLog%TYPE;
nCod_Asegurado          ASEGURADO_CERTIFICADO.Cod_Asegurado%TYPE;
cNutra                  ASEGURADO_CERTIFICADO.Campo3%TYPE;
nIdPolizaComp           ASEGURADO_CERTIFICADO.IdPoliza%TYPE;
cExiste                 VARCHAR2(1);
--
nIDetPol                ASEGURADO_CERTIFICADO.IDetPol%TYPE;
nIdAsegurado            TEMP_LISTADO_DECLARACIONES.IdAsegurado%TYPE;
cTipoDocIdentificacion  PERSONA_NATURAL_JURIDICA.Tipo_Doc_Identificacion%TYPE;
cNumDocIdentificacion   PERSONA_NATURAL_JURIDICA.Num_Doc_Identificacion%TYPE;
cNombreAseg             PERSONA_NATURAL_JURIDICA.Nombre%TYPE;
cApellidoPaternoAseg    PERSONA_NATURAL_JURIDICA.Apellido_Paterno%TYPE;
cApellidoMaternoAseg    PERSONA_NATURAL_JURIDICA.Apellido_Materno%TYPE;
dFechaNacimiento        PERSONA_NATURAL_JURIDICA.FecNacimiento%TYPE;
cSexoAseg               PERSONA_NATURAL_JURIDICA.Sexo%TYPE;
cDirecAseg              PERSONA_NATURAL_JURIDICA.DirecRes%TYPE;
cCodigoPostalAseg       PERSONA_NATURAL_JURIDICA.CodPosRes%TYPE;
cNutraCertificado       ASEGURADO_CERTIFICADO.Campo3%TYPE;
cOtroDatoComparativo    TEMP_LISTADO_DECLARACIONES.OtroDatoComparativo%TYPE := NULL;
nSumaAsegurada          ASEGURADO_CERTIFICADO.SumaAseg%TYPE;
nPrimaNeta              ASEGURADO_CERTIFICADO.PrimaNeta%TYPE;
                                                    
CURSOR ASEG_Q IS
   SELECT IdAsegurado, CodAsegurado, NutraCertificado, OtroDatoComparativo, 
          NombreAseg || ' ' || ApellidoPaternoAseg || ' ' || ApellidoMaternoAseg NombreCompleto,
          NombreAseg, ApellidoPaternoAseg, ApellidoMaternoAseg, 
          FechaNacimiento, TipoDocIdentificacion, NumDocIdentificacion
     FROM TEMP_LISTADO_DECLARACIONES T
    WHERE CodCia                = nCodCia
      AND CodEmpresa            = nCodEmpresa
      AND IdPoliza              = nIdPoliza
      AND NVL(IndContinua,'N')  = 'N'
      AND NVL(IndAlta,'N')      = 'N'
      AND NVL(IndBaja,'N')      = 'N'
      AND NVL(IndLog,'N')       = 'N'
      AND EXISTS (SELECT 'S'
                    FROM ASEGURADO_CERTIFICADO
                   WHERE CodCia        = T.CodCia
                     AND IdPoliza      = T.IdPoliza
                     AND IDetPol       > 0
                     AND Cod_Asegurado = T.CodAsegurado
                     AND Estado        = cEstado);

CURSOR ALTAS_Q IS
   SELECT IdAsegurado, CodAsegurado, NutraCertificado, OtroDatoComparativo, 
          NombreAseg || ' ' || ApellidoPaternoAseg || ' ' || ApellidoMaternoAseg NombreCompleto,
          NombreAseg, ApellidoPaternoAseg, ApellidoMaternoAseg, 
          FechaNacimiento, TipoDocIdentificacion, NumDocIdentificacion
     FROM TEMP_LISTADO_DECLARACIONES T
    WHERE CodCia                = nCodCia
      AND CodEmpresa            = nCodEmpresa
      AND IdPoliza              = nIdPoliza
      AND NVL(IndContinua,'N')  = 'N'
      AND NVL(IndAlta,'N')      = 'N'
      AND NVL(IndBaja,'N')      = 'N'
      AND NVL(IndLog,'N')       = 'N'
      AND NOT EXISTS (SELECT 'S'
                        FROM ASEGURADO_CERTIFICADO
                       WHERE CodCia        = T.CodCia
                         AND IdPoliza      = T.IdPoliza
                         AND IDetPol       > 0
                         AND Cod_Asegurado = T.CodAsegurado);
                         
CURSOR BAJAS_Q IS
    SELECT A.Cod_Asegurado, A.IDetPol
      FROM ASEGURADO_CERTIFICADO A, TEMP_LISTADO_DECLARACIONES T         
     WHERE A.CodCia         = nCodCia
       AND A.IdPoliza       = nIdPoliza
       AND A.IDetPol        > 0 
       --AND A.IDetPol        = nIDetPol
       AND A.Estado        IN ('EMI','REN')
       AND A.CodCia         = T.CodCia(+)
       AND A.IdPoliza       = T.IdPoliza(+)
       AND A.IDetPol        = T.IDetPol(+)
       AND A.Cod_Asegurado  = T.CodAsegurado(+)
     MINUS 
    SELECT A.Cod_Asegurado, A.IDetPol
      FROM ASEGURADO_CERTIFICADO A, TEMP_LISTADO_DECLARACIONES T         
     WHERE A.CodCia         = nCodCia
       AND A.IdPoliza       = nIdPoliza
       AND A.IDetPol        > 0
       --AND A.IDetPol        = nIDetPol 
       AND A.CodCia         = T.CodCia
       AND A.IdPoliza       = T.IdPoliza
       AND A.IDetPol        = T.IDetPol
       AND A.Cod_Asegurado  = T.CodAsegurado;                       
                         
CURSOR ASEGNUTRA_Q IS
   SELECT IdAsegurado, CodAsegurado, NutraCertificado, OtroDatoComparativo, 
          NombreAseg || ' ' || ApellidoPaternoAseg || ' ' || ApellidoMaternoAseg NombreCompleto,
          NombreAseg, ApellidoPaternoAseg, ApellidoMaternoAseg, 
          FechaNacimiento, TipoDocIdentificacion, NumDocIdentificacion
     FROM TEMP_LISTADO_DECLARACIONES T
    WHERE CodCia                = nCodCia
      AND CodEmpresa            = nCodEmpresa
      AND IdPoliza              = nIdPoliza
      AND NVL(IndContinua,'N')  = 'N'
      AND NVL(IndAlta,'N')      = 'N'
      AND NVL(IndBaja,'N')      = 'N'
      AND NVL(IndLog,'N')       = 'N'
      AND EXISTS (SELECT 'S'
                    FROM ASEGURADO_CERTIFICADO
                   WHERE CodCia        = T.CodCia
                     AND IdPoliza      = T.IdPoliza
                     AND IDetPol       > 0
                     AND Campo3        = T.NutraCertificado
                     AND Estado        = cEstado);   
                     
CURSOR ALTASNUTRA_Q IS
   SELECT IdAsegurado, CodAsegurado, NutraCertificado, OtroDatoComparativo, 
          NombreAseg || ' ' || ApellidoPaternoAseg || ' ' || ApellidoMaternoAseg NombreCompleto,
          NombreAseg, ApellidoPaternoAseg, ApellidoMaternoAseg, 
          FechaNacimiento, TipoDocIdentificacion, NumDocIdentificacion
     FROM TEMP_LISTADO_DECLARACIONES T
    WHERE CodCia                = nCodCia
      AND CodEmpresa            = nCodEmpresa
      AND IdPoliza              = nIdPoliza
      AND NVL(IndContinua,'N')  = 'N'
      AND NVL(IndAlta,'N')      = 'N'
      AND NVL(IndBaja,'N')      = 'N'
      AND NVL(IndLog,'N')       = 'N'
      AND NOT EXISTS (SELECT 'S'
                        FROM ASEGURADO_CERTIFICADO
                       WHERE CodCia        = T.CodCia
                         AND IdPoliza      = T.IdPoliza
                         AND IDetPol       > 0
                         AND Campo3        = T.NutraCertificado
                         AND Estado        = cEstado);      
                         
CURSOR NOMBRE_Q IS   
   SELECT IdAsegurado, CodAsegurado, NutraCertificado, OtroDatoComparativo, 
          NombreAseg || ' ' || ApellidoPaternoAseg || ' ' || ApellidoMaternoAseg NombreCompleto,
          NombreAseg, ApellidoPaternoAseg, ApellidoMaternoAseg, 
          FechaNacimiento, TipoDocIdentificacion, NumDocIdentificacion
     FROM TEMP_LISTADO_DECLARACIONES T
    WHERE CodCia                = nCodCia
      AND CodEmpresa            = nCodEmpresa
      AND IdPoliza              = nIdPoliza
      AND NVL(IndContinua,'N')  = 'N'
      AND NVL(IndAlta,'N')      = 'N'
      AND NVL(IndBaja,'N')      = 'N'
      AND NVL(IndLog,'N')       = 'N';        
      
CURSOR BAJASNOMBRE_Q IS
   SELECT AC.Campo3,AC.IdPoliza,AC.IDetPol,AC.Estado,
          PNJ.Tipo_Doc_Identificacion, PNJ.Num_Doc_Identificacion,
          PNJ.Nombre,PNJ.Apellido_Paterno,PNJ.Apellido_Materno,
          PNJ.FecNacimiento,PNJ.Sexo,DirecRes,PNJ.CodPosRes,
          AC.SumaAseg,AC.PrimaNeta, AC.Cod_Asegurado
     FROM ASEGURADO_CERTIFICADO AC,ASEGURADO A,PERSONA_NATURAL_JURIDICA PNJ
    WHERE AC.CodCia                = nCodCia
      AND AC.IdPoliza              = nIdPoliza
      AND AC.CodCia                = A.CodCia
      AND AC.Cod_Asegurado         = A.Cod_Asegurado
      AND A.Tipo_Doc_Identificacion= PNJ.Tipo_Doc_Identificacion
      AND A.Num_Doc_Identificacion = PNJ.Num_Doc_Identificacion
      AND AC.Estado                = 'EMI';    
                                                                   
BEGIN
   IF cCompararPor = 'CODIGO' THEN
      FOR W IN BAJAS_Q LOOP
         nIdAsegurado := GT_TEMP_LISTADO_DECLARACIONES.CORRELATIVO_ASEGURADO(nCodCia, nCodEmpresa, nIdPoliza);
                     
         BEGIN
            SELECT AC.Campo3,AC.IdPoliza,AC.IDetPol,AC.Estado,
                   PNJ.Tipo_Doc_Identificacion, PNJ.Num_Doc_Identificacion,
                   PNJ.Nombre,PNJ.Apellido_Paterno,PNJ.Apellido_Materno,
                   PNJ.FecNacimiento,PNJ.Sexo,DirecRes,PNJ.CodPosRes,
                   AC.SumaAseg,AC.PrimaNeta
              INTO cNutra,nIdPolizaComp,nIDetPol,cEstado,
                   cTipoDocIdentificacion,cNumDocIdentificacion,
                   cNombreAseg,cApellidoPaternoAseg,cApellidoMaternoAseg,
                   dFechaNacimiento,cSexoAseg,cDirecAseg,cCodigoPostalAseg,
                   nSumaAsegurada,nPrimaNeta
              FROM ASEGURADO_CERTIFICADO AC,ASEGURADO A,PERSONA_NATURAL_JURIDICA PNJ
             WHERE AC.CodCia                = nCodCia
               AND AC.IdPoliza              = nIdPoliza
               AND AC.Cod_Asegurado         = W.Cod_Asegurado
               AND AC.IDetPol               = W.IDetPol
               AND AC.CodCia                = A.CodCia
               AND AC.Cod_Asegurado         = A.Cod_Asegurado
               AND A.Tipo_Doc_Identificacion= PNJ.Tipo_Doc_Identificacion
               AND A.Num_Doc_Identificacion = PNJ.Num_Doc_Identificacion;
         EXCEPTION
             WHEN NO_DATA_FOUND THEN
                 nCod_Asegurado := 0;
                 nIdPolizaComp  := 0;
                 nIDetPol       := 0;
                 cEstado        := NULL;
                 cNutra         := NULL;
         END;
                     
         INSERT INTO TEMP_LISTADO_DECLARACIONES (CodCia, CodEmpresa, IdPoliza, IDetPol, IdAsegurado, 
                                                 TipoDocIdentificacion, NumDocIdentificacion, NombreAseg, 
                                                 ApellidoPaternoAseg, ApellidoMaternoAseg, FechaNacimiento, 
                                                 SexoAseg, DirecAseg, CodigoPostalAseg, CodAsegurado, 
                                                 NutraCertificado, OtroDatoComparativo, SumaAsegurada, 
                                                 PrimaNeta, IndContinua, IndAlta, IndBaja, IndLog, LogComparacion)
                                          VALUES(nCodCia, nCodEmpresa, nIdPolizaComp, nIDetPol, nIdAsegurado,
                                                 cTipoDocIdentificacion, cNumDocIdentificacion, cNombreAseg,
                                                 cApellidoPaternoAseg, cApellidoMaternoAseg, dFechaNacimiento,
                                                 cSexoAseg, cDirecAseg, cCodigoPostalAseg, W.Cod_Asegurado,
                                                 cNutra, cOtroDatoComparativo, nSumaAsegurada, 
                                                 nPrimaNeta, 'N', 'N', 'S', 'N', NULL);
      END LOOP;
           
      cEstado  := 'EMI';
      FOR W IN ASEG_Q LOOP
         UPDATE TEMP_LISTADO_DECLARACIONES
            SET IndContinua = 'S'
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND IdPoliza    = nIdPoliza
            AND IdAsegurado = W.IdAsegurado;
      END LOOP;
      
      cEstado  := 'SUS'; ---REHABILITACIONES
      FOR W IN ASEG_Q LOOP
         UPDATE TEMP_LISTADO_DECLARACIONES
            SET IndContinua = 'S'
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND IdPoliza    = nIdPoliza
            AND IdAsegurado = W.IdAsegurado;
      END LOOP;

      cEstado  := 'ANU';
      FOR W IN ASEG_Q LOOP
         UPDATE TEMP_LISTADO_DECLARACIONES
            SET IndAlta     = 'S'
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND IdPoliza    = nIdPoliza
            AND IdAsegurado = W.IdAsegurado;
      END LOOP;

      cEstado  := 'CEX';
      FOR W IN ASEG_Q LOOP
         UPDATE TEMP_LISTADO_DECLARACIONES
            SET IndAlta     = 'S'
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND IdPoliza    = nIdPoliza
            AND IdAsegurado = W.IdAsegurado;
      END LOOP;

      FOR W IN ALTAS_Q LOOP
         UPDATE TEMP_LISTADO_DECLARACIONES
            SET IndAlta     = 'S'
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND IdPoliza    = nIdPoliza
            AND IdAsegurado = W.IdAsegurado;
      END LOOP;
   ELSIF cCompararPor IN ('NUTRA','CERTIFICADO') THEN
      cEstado  := 'EMI';
      FOR W IN ASEGNUTRA_Q LOOP
         UPDATE TEMP_LISTADO_DECLARACIONES
            SET IndContinua = 'S'
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND IdPoliza    = nIdPoliza
            AND IdAsegurado = W.IdAsegurado;
      END LOOP;

      cEstado  := 'ANU';
      FOR W IN ASEGNUTRA_Q LOOP
         UPDATE TEMP_LISTADO_DECLARACIONES
            SET IndAlta     = 'S'
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND IdPoliza    = nIdPoliza
            AND IdAsegurado = W.IdAsegurado;
      END LOOP;

      cEstado  := 'CEX';
      FOR W IN ASEGNUTRA_Q LOOP
         UPDATE TEMP_LISTADO_DECLARACIONES
            SET IndAlta     = 'S'
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND IdPoliza    = nIdPoliza
            AND IdAsegurado = W.IdAsegurado;
      END LOOP;

      FOR W IN ALTASNUTRA_Q LOOP
         UPDATE TEMP_LISTADO_DECLARACIONES
            SET IndAlta     = 'S'
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND IdPoliza    = nIdPoliza
            AND IdAsegurado = W.IdAsegurado;
      END LOOP;
   ELSIF cCompararPor IN ('NOMBRE') THEN
      FOR W IN NOMBRE_Q LOOP
         BEGIN
            SELECT AC.Cod_Asegurado,AC.Campo3,AC.IdPoliza,AC.IDetPol,AC.Estado
              INTO nCod_Asegurado,cNutra,nIdPolizaComp,nIDetPol,cEstado
              FROM ASEGURADO_CERTIFICADO AC,ASEGURADO A,PERSONA_NATURAL_JURIDICA PNJ
             WHERE AC.CodCia                = nCodCia
               AND AC.IdPoliza              = nIdPoliza
               AND AC.CodCia                = A.CodCia
               AND AC.Cod_Asegurado         = A.Cod_Asegurado
               AND A.Tipo_Doc_Identificacion= PNJ.Tipo_Doc_Identificacion
               AND A.Num_Doc_Identificacion = PNJ.Num_Doc_Identificacion
               AND (PNJ.Nombre           LIKE '%'||W.NombreAseg         ||'%'
               AND  PNJ.Apellido_Paterno LIKE '%'||W.ApellidoPaternoAseg||'%'
               AND  PNJ.Apellido_Materno LIKE '%'||W.ApellidoMaternoAseg||'%');
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               BEGIN
                  SELECT AC.Cod_Asegurado,AC.Campo3,AC.IdPoliza,AC.IDetPol,AC.Estado
                    INTO nCod_Asegurado,cNutra,nIdPolizaComp,nIDetPol,cEstado
                    FROM ASEGURADO_CERTIFICADO AC,ASEGURADO A,PERSONA_NATURAL_JURIDICA PNJ
                   WHERE AC.CodCia                = nCodCia
                     AND AC.IdPoliza              = nIdPoliza
                     AND AC.CodCia                = A.CodCia
                     AND AC.Cod_Asegurado         = A.Cod_Asegurado
                     AND A.Tipo_Doc_Identificacion= PNJ.Tipo_Doc_Identificacion
                     AND A.Num_Doc_Identificacion = PNJ.Num_Doc_Identificacion
                     AND (PNJ.Nombre           LIKE '%'||W.NombreAseg         ||'%'
                     AND  PNJ.Apellido_Paterno LIKE '%'||W.ApellidoPaternoAseg||'%');
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     BEGIN
                        SELECT AC.Cod_Asegurado,AC.Campo3,AC.IdPoliza,AC.IDetPol,AC.Estado
                          INTO nCod_Asegurado,cNutra,nIdPolizaComp,nIDetPol,cEstado
                          FROM ASEGURADO_CERTIFICADO AC,ASEGURADO A,PERSONA_NATURAL_JURIDICA PNJ
                         WHERE AC.CodCia                = nCodCia
                           AND AC.IdPoliza              = nIdPoliza
                           AND AC.CodCia                = A.CodCia
                           AND AC.Cod_Asegurado         = A.Cod_Asegurado
                           AND A.Tipo_Doc_Identificacion= PNJ.Tipo_Doc_Identificacion
                           AND A.Num_Doc_Identificacion = PNJ.Num_Doc_Identificacion
                           AND (PNJ.Nombre           LIKE '%'||W.NombreAseg         ||'%'
                           AND  PNJ.Apellido_Paterno LIKE '%'||W.ApellidoMaternoAseg||'%');
                     EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                           nCod_Asegurado := 0;
                           nIdPolizaComp  := 0;
                           nIDetPol       := 0;
                           cEstado        := 'X';
                           cNutra         := 'X';
                        WHEN TOO_MANY_ROWS THEN
                           cEstado        := 'ERR';
                     END;
                  WHEN TOO_MANY_ROWS THEN
                      cEstado        := 'ERR';
               END;
            WHEN TOO_MANY_ROWS THEN
               cEstado        := 'ERR';
         END;
         
         IF nIdPolizaComp = 0 THEN
            UPDATE TEMP_LISTADO_DECLARACIONES
               SET IndAlta     = 'S'
             WHERE CodCia      = nCodCia
               AND CodEmpresa  = nCodEmpresa
               AND IdPoliza    = nIdPoliza
               AND IdAsegurado = W.IdAsegurado;
         ELSIF cEstado = 'EMI' THEN
            UPDATE TEMP_LISTADO_DECLARACIONES
               SET IndContinua = 'S'
             WHERE CodCia      = nCodCia
               AND CodEmpresa  = nCodEmpresa
               AND IdPoliza    = nIdPoliza
               AND IdAsegurado = W.IdAsegurado;
         ELSIF cEstado = 'CEX' THEN
            UPDATE TEMP_LISTADO_DECLARACIONES
               SET IndAlta     = 'S'
             WHERE CodCia      = nCodCia
               AND CodEmpresa  = nCodEmpresa
               AND IdPoliza    = nIdPoliza
               AND IdAsegurado = W.IdAsegurado;
         ELSIF cEstado = 'ANU' THEN
            UPDATE TEMP_LISTADO_DECLARACIONES
               SET IndAlta     = 'S'
             WHERE CodCia      = nCodCia
               AND CodEmpresa  = nCodEmpresa
               AND IdPoliza    = nIdPoliza
               AND IdAsegurado = W.IdAsegurado;
         ELSIF cEstado = 'ERR' THEN
            UPDATE TEMP_LISTADO_DECLARACIONES
               SET IndLog         = 'S',
                   LogComparacion = 'Nombre ó Apellido Paterno ó Apellido Materno ya Exiten en el Listado Original'
             WHERE CodCia      = nCodCia
               AND CodEmpresa  = nCodEmpresa
               AND IdPoliza    = nIdPoliza
               AND IdAsegurado = W.IdAsegurado;
         END IF;
      END LOOP;
      FOR W IN BAJASNOMBRE_Q LOOP
         BEGIN
            SELECT 'S'
              INTO cExiste
              FROM TEMP_LISTADO_DECLARACIONES
             WHERE CodCia      = nCodCia
               AND CodEmpresa  = nCodEmpresa
               AND IdPoliza    = nIdPoliza
               AND (NombreAseg          LIKE '%'||W.Nombre          ||'%'
               AND  ApellidoPaternoAseg LIKE '%'||W.Apellido_Paterno||'%'
               AND  ApellidoMaternoAseg LIKE '%'||W.Apellido_Materno||'%');
         EXCEPTION
            WHEN NO_DATA_FOUND THEN 
               BEGIN
                  SELECT 'S'
                    INTO cExiste
                    FROM TEMP_LISTADO_DECLARACIONES
                   WHERE CodCia      = nCodCia
                     AND CodEmpresa  = nCodEmpresa
                     AND IdPoliza    = nIdPoliza
                     AND (NombreAseg          LIKE '%'||W.Nombre          ||'%'
                     AND  ApellidoPaternoAseg LIKE '%'||W.Apellido_Paterno||'%');
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN 
                     BEGIN
                        SELECT 'S'
                          INTO cExiste
                          FROM TEMP_LISTADO_DECLARACIONES
                         WHERE CodCia      = nCodCia
                           AND CodEmpresa  = nCodEmpresa
                           AND IdPoliza    = nIdPoliza
                           AND (NombreAseg          LIKE '%'||W.Nombre          ||'%'
                           AND  ApellidoMaternoAseg LIKE '%'||W.Apellido_Materno||'%');
                     EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                           nCod_Asegurado       := 0;
                           nIdPolizaComp        := 0;
                           nIDetPol             := 0;
                           cEstado              := 'X';
                           cNutra               := 'X';
                           cOtroDatoComparativo := 'X';
                           cExiste              := 'N';
                        WHEN TOO_MANY_ROWS THEN
                           cEstado        := 'ERR';
                     END;
               END;
         END;
         
         IF cExiste = 'N' THEN
            nIdAsegurado := GT_TEMP_LISTADO_DECLARACIONES.CORRELATIVO_ASEGURADO(nCodCia, nCodEmpresa, nIdPoliza);
            INSERT INTO TEMP_LISTADO_DECLARACIONES (CodCia, CodEmpresa, IdPoliza, IDetPol, IdAsegurado, 
                                                    TipoDocIdentificacion, NumDocIdentificacion, NombreAseg, 
                                                    ApellidoPaternoAseg, ApellidoMaternoAseg, FechaNacimiento, 
                                                    SexoAseg, DirecAseg, CodigoPostalAseg, CodAsegurado, 
                                                    NutraCertificado, OtroDatoComparativo, SumaAsegurada, 
                                                    PrimaNeta, IndContinua, IndAlta, IndBaja, IndLog, LogComparacion)
                                             VALUES(nCodCia, nCodEmpresa, W.IdPoliza, W.IDetPol, nIdAsegurado,
                                                    W.Tipo_Doc_Identificacion, W.Num_Doc_Identificacion, W.Nombre,
                                                    W.Apellido_Paterno, W.Apellido_Materno, W.FecNacimiento,
                                                    W.Sexo, W.DirecRes, W.CodPosRes, W.Cod_Asegurado,
                                                    cNutra, cOtroDatoComparativo, W.SumaAseg, 
                                                    W.PrimaNeta, 'N', 'N', 'S', 'N', NULL);
         END IF;
      END LOOP;                                                 
   END IF;
END COMPARA_LISTADO;

PROCEDURE APLICAR_ENDOSOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER) IS
cTextoEndoso         VARCHAR2(3000);
dFecIniVig           ENDOSOS.FecIniVig%TYPE;
dFecFinVig           ENDOSOS.FecFinVig%TYPE;
cTipoEndoso          ENDOSOS.TipoEndoso%TYPE;
nDiasProrrata        NUMBER(6);
cCodPlanPago         PLAN_DE_PAGOS.CodPlanPago%TYPE;
nCantidadPagos       NUMBER;
nPrimaNetaTotal      NUMBER(28,2);
nNumAsegContinuan    NUMBER;
nNumAsegAlta         NUMBER;
nNumAsegBaja         NUMBER;
nNumAsegLog          NUMBER;
nCodAseguradoAltas   ASEGURADO.Cod_Asegurado%TYPE;
nCodAsegurado        ASEGURADO.Cod_Asegurado%TYPE;
cCodPaisRes          PERSONA_NATURAL_JURIDICA.CodPaisRes%TYPE;
cCodProvRes          PERSONA_NATURAL_JURIDICA.CodProvRes%TYPE;
cCodDistRes          PERSONA_NATURAL_JURIDICA.CodDistRes%TYPE; 
cCodCorrRes          PERSONA_NATURAL_JURIDICA.CodCorrRes%TYPE; 
cCodColonia          PERSONA_NATURAL_JURIDICA.CodColRes%TYPE;
cPlanCob             DETALLE_POLIZA.PlanCob%TYPE;
cIdTipoSeg           DETALLE_POLIZA.IdTipoSeg%TYPE;
nCodAseguradoIni     ASEGURADO.Cod_Asegurado%TYPE;
nNumCotizacion       POLIZAS.Num_Cotizacion%TYPE;
nIdCotizacion        COTIZACIONES.IdCotizacion%TYPE;
nIDetCotizacion      COTIZACIONES_DETALLE.IDetCotizacion%TYPE;
nPrimaLocal          COBERT_ACT_ASEG.Prima_Local%TYPE;
nPrimaMoneda         COBERT_ACT_ASEG.Prima_Moneda%TYPE;
nNumDeclaracion      EAD_CONTROL_ASEGURADOS.NumDeclaracion%TYPE;
nTasaCambio          TASAS_CAMBIO.Tasa_Cambio%TYPE;
cCodMoneda           POLIZAS.Cod_Moneda%TYPE;
nIdEndosoProc        ENDOSOS.IdEndoso%TYPE;
nEdadAseg            NUMBER;
dFecIniVigPol        ENDOSOS.FecIniVig%TYPE;
nCuentaContinua      NUMBER := 0;
nCuentaAltas         NUMBER := 0;
nCuentaBajas         NUMBER := 0;
nCuentaLog           NUMBER := 0;
nDifSumaAseg         NUMBER := 0;
nAcumDifSumaAseg     NUMBER := 0;
nSumaAseg            ASEGURADO_CERTIFICADO.SumaAseg%TYPE;
nCuentaDifSumaAseg   NUMBER;
nCuentaAcumDifSA     NUMBER;

nIdEndosoSV          ENDOSOS.IdEndoso%TYPE;
cTextoEndosoSV       VARCHAR2(30000);
cTipoEndosoSV        ENDOSOS.TipoEndoso%TYPE;
cNumEndRef           ENDOSOS.NumEndRef%TYPE;
cMotivo_EndosoSV     ENDOSOS.Motivo_Endoso%TYPE;
cDescEndosoSV        ENDOSOS.DescEndoso%TYPE;

CURSOR DECLCONT_Q IS   
   SELECT IdAsegurado, CodAsegurado, NutraCertificado, OtroDatoComparativo, 
          NombreAseg || ' ' || ApellidoPaternoAseg || ' ' || ApellidoMaternoAseg NombreCompleto,
          NombreAseg, ApellidoPaternoAseg, ApellidoMaternoAseg, 
          FechaNacimiento, TipoDocIdentificacion, NumDocIdentificacion,
          Sexoaseg, Direcaseg, Codigopostalaseg, SumaAsegurada, 
          PrimaNeta, IndContinua, IndAlta, IndBaja, IndLog, LogComparacion
     FROM TEMP_LISTADO_DECLARACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND IndContinua  = 'S';
      
CURSOR DECLALTA_Q IS   
   SELECT IdAsegurado, CodAsegurado, NutraCertificado, OtroDatoComparativo, 
          NombreAseg || ' ' || ApellidoPaternoAseg || ' ' || ApellidoMaternoAseg NombreCompleto,
          NombreAseg, ApellidoPaternoAseg, ApellidoMaternoAseg, 
          FechaNacimiento, TipoDocIdentificacion, NumDocIdentificacion,
          Sexoaseg, Direcaseg, Codigopostalaseg, SumaAsegurada, 
          PrimaNeta, IndContinua, IndAlta, IndBaja, IndLog, LogComparacion
     FROM TEMP_LISTADO_DECLARACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND IndAlta      = 'S';
      
CURSOR DECLBAJA_Q IS   
   SELECT IdAsegurado, CodAsegurado, NutraCertificado, OtroDatoComparativo, 
          NombreAseg || ' ' || ApellidoPaternoAseg || ' ' || ApellidoMaternoAseg NombreCompleto,
          NombreAseg, ApellidoPaternoAseg, ApellidoMaternoAseg, 
          FechaNacimiento, TipoDocIdentificacion, NumDocIdentificacion,
          Sexoaseg, Direcaseg, Codigopostalaseg, SumaAsegurada, 
          PrimaNeta, IndContinua, IndAlta, IndBaja, IndLog, LogComparacion
     FROM TEMP_LISTADO_DECLARACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND IndBaja      = 'S';  
      
CURSOR DECLLOG_Q IS   
   SELECT IdAsegurado, CodAsegurado, NutraCertificado, OtroDatoComparativo, 
          NombreAseg || ' ' || ApellidoPaternoAseg || ' ' || ApellidoMaternoAseg NombreCompleto,
          NombreAseg, ApellidoPaternoAseg, ApellidoMaternoAseg, 
          FechaNacimiento, TipoDocIdentificacion, NumDocIdentificacion,
          Sexoaseg, Direcaseg, Codigopostalaseg, SumaAsegurada, 
          PrimaNeta, IndContinua, IndAlta, IndBaja, IndLog, LogComparacion
     FROM TEMP_LISTADO_DECLARACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND IndLog       = 'S';            
      
CURSOR ENDOSO_Q IS      
   SELECT SUM(SumaAsegurada) SumaAsegurada,SUM(PrimaNeta) PrimaNeta,
          NVL(IndContinua,'N') IndContinua, NVL(IndAlta,'N') IndAlta, 
          NVL(IndBaja,'N') IndBaja, NVL(IndLog,'N') IndLog
     FROM TEMP_LISTADO_DECLARACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
    GROUP BY IndContinua, IndAlta, IndBaja, IndLog;

CURSOR ASEGCERT_Q IS
   SELECT Cod_Asegurado,PrimaNeta,SumaAseg,
          OC_ASEGURADO.FECHA_NACIMIENTO(nCodCia, nCodEmpresa, Cod_Asegurado) FecNacimiento
     FROM ASEGURADO_CERTIFICADO  
    WHERE CodCia       = nCodCia
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol 
      AND IdEndoso     = nIdEndoso; 
      
CURSOR COB_Q IS
   SELECT CodCobert, Prima_Moneda, Prima_Local, Cod_Moneda
     FROM COBERT_ACT_ASEG
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCodAseguradoAltas
      AND IdTipoSeg     = cIdTipoSeg
      AND PlanCob       = cPlanCob; 
      
CURSOR ASEGCERTORIG_Q IS
   SELECT Cod_Asegurado,PrimaNeta,SumaAseg,
          OC_ASEGURADO.FECHA_NACIMIENTO(nCodCia, nCodEmpresa, Cod_Asegurado) FecNacimiento
     FROM ASEGURADO_CERTIFICADO  
    WHERE CodCia       = nCodCia
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol 
      AND IdEndoso     = nIdEndosoProc; 
      
CURSOR COBORIG_Q(nCodAseguradoOrig IN NUMBER) IS
   SELECT CodCobert, Prima_Moneda, Prima_Local, Cod_Moneda,
          SumaAseg_Local, SumaAseg_Moneda, SalarioMensual, 
          VecesSalario
     FROM COBERT_ACT_ASEG
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCodAseguradoOrig
      AND IdTipoSeg     = cIdTipoSeg
      AND PlanCob       = cPlanCob;     
      
CURSOR ASEGCERTHIST_Q IS
   SELECT Cod_Asegurado,PrimaNeta,SumaAseg,Estado,
          OC_ASEGURADO.FECHA_NACIMIENTO(nCodCia, nCodEmpresa, Cod_Asegurado) FecNacimiento
     FROM ASEGURADO_CERTIFICADO  
    WHERE CodCia     = nCodCia
      AND IdPoliza   = nIdPoliza
      AND IDetPol    = nIDetPol
      AND Estado    IN ('EMI')
      AND IdEndoso  != nIdEndoso
    UNION
   SELECT Cod_Asegurado,PrimaNeta,SumaAseg,Estado,
          OC_ASEGURADO.FECHA_NACIMIENTO(nCodCia, nCodEmpresa, Cod_Asegurado) FecNacimiento
     FROM ASEGURADO_CERTIFICADO  
    WHERE CodCia     = nCodCia
      AND IdPoliza   = nIdPoliza
      AND IDetPol    = nIDetPol
      AND Estado    IN ('EMI','SUS','SOL')
      AND IdEndoso   = nIdEndoso      
   ;         
      
BEGIN
   /*VALIDACION DE COMPARATIVO PREVIO*/
   SELECT COUNT(IndContinua)
     INTO nCuentaContinua
     FROM TEMP_LISTADO_DECLARACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND IndContinua  = 'S';
      
   SELECT COUNT(IndAlta)
     INTO nCuentaAltas
     FROM TEMP_LISTADO_DECLARACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND IndAlta      = 'S';
      
   SELECT COUNT(IndBaja)
     INTO nCuentaBajas
     FROM TEMP_LISTADO_DECLARACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND IndBaja      = 'S';  
       
   SELECT COUNT(IndLog)
     INTO nCuentaLog
     FROM TEMP_LISTADO_DECLARACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND IndLog       = 'S';             
   /**********************************/
   
   IF NVL(nCuentaLog,0) = 0 AND NVL(nCuentaBajas,0) = 0 AND NVL(nCuentaAltas,0) = 0 AND NVL(nCuentaContinua,0) = 0 THEN
      RAISE_APPLICATION_ERROR(-20225,'No es Posible Aplicar el Endoso, Debe Realizar un Comparativo   '||SQLERRM);
   ELSE
      cTextoEndoso   := 'Carga de Asegurados a Declaración de la Póliza '||nIdPoliza||' Endoso '||nIdEndoso                                             ||CHR(10)||
                        'Declaración Realizada el Día '||OC_GENERALES.FECHA_EN_LETRA(TRUNC(SYSDATE))||' Por ' ||OC_USUARIOS.NOMBRE_USUARIO(nCodCia,USER)||CHR(10)||CHR(10);
      OC_ENDOSO_TEXTO.INSERTA(nIdPoliza, nIdEndoso, cTextoEndoso);
      cTextoEndoso   := NULL;
      nIdEndosoProc  := 0;
      
      BEGIN
         SELECT FecIniVig,FecFinVig,TRUNC(FecFinVig) - TRUNC(FecIniVig),TipoEndoso, CodPlanPago
           INTO dFecIniVig,dFecFinVig,nDiasProrrata,cTipoEndoso, cCodPlanPago
           FROM ENDOSOS
          WHERE CodCia     = nCodCia
            AND IdPoliza   = nIdPoliza
            AND IdetPol    = nIDetPol
            AND IdEndoso   = nIdEndoso;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20225,'No es Posible Determinar Datos Generales del Endoso Para Generar la Declaración '||SQLERRM);
      END;
      
      BEGIN
         SELECT NVL(Num_Cotizacion,0),Cod_Moneda, FecIniVig
           INTO nNumCotizacion, cCodMoneda, dFecIniVigPol
           FROM POLIZAS
          WHERE CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND IdPoliza   = nIdPoliza;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20225,'No es Posible Determinar Datos Generales de la Póliza Para Generar la Declaración '||SQLERRM);
      END;
      
      IF NVL(nNumCotizacion,0) > 0 THEN
         BEGIN
            SELECT C.IdCotizacion,D.IDetCotizacion
              INTO nIdCotizacion,nIDetCotizacion
              FROM COTIZACIONES C,COTIZACIONES_DETALLE D
             WHERE C.CodCia         = nCodCia 
               AND C.CodEmpresa     = nCodEmpresa
               AND C.IdCotizacion   = nNumCotizacion
               AND D.IDetCotizacion = nIDetPol
               AND C.CodCia         = D.CodCia 
               AND C.CodEmpresa     = D.CodEmpresa 
               AND C.IdCotizacion   = D.IdCotizacion;
         END;
      END IF;
      
      BEGIN
         SELECT PlanCob,IdTipoSeg
           INTO cPlanCob,cIdTipoSeg
           FROM DETALLE_POLIZA
          WHERE CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND IdPoliza   = nIdPoliza
            AND IdetPol    = nIDetPol;
      END;
      
      nTasaCambio       := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
      nCantidadPagos    := OC_PLAN_DE_PAGOS.CANTIDAD_PAGOS(nCodCia, nCodEmpresa, cCodPlanPago);
      nNumDeclaracion   := GT_EAD_CONTROL_ASEGURADOS.NUMERO_DECLARACION(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol);
      --- ASEGURADOS INICIALES EN LA DECLARACION
      IF GT_EAD_CONTROL_ASEGURADOS.EXISTE_ENDOSO_INICIAL(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol) = 'N' THEN
         FOR Z IN ASEGCERTORIG_Q LOOP
            nEdadAseg := OC_ASEGURADO.EDAD_ASEGURADO(nCodCia, nCodEmpresa, Z.Cod_Asegurado, dFecIniVigPol);
            GT_EAD_CONTROL_ASEGURADOS.INSERTAR(nCodCia, nCodEmpresa, 0, nIdPoliza, nIDetPol, Z.Cod_Asegurado, nIdEndosoProc,
                                               Z.FecNacimiento, nEdadAseg, NULL, dFecIniVig, dFecFinVig, 
                                               Z.SumaAseg, Z.SumaAseg * nTasaCambio, Z.PrimaNeta, Z.PrimaNeta * nTasaCambio, NULL);
            FOR J IN COBORIG_Q(Z.Cod_Asegurado) LOOP
               GT_EAD_CONTROL_ASEG_COBERT.INSERTAR(nCodCia, nCodEmpresa, 0, nIdPoliza,
                                                   nIDetPol, Z.Cod_Asegurado, nIdEndosoProc, J.CodCobert,
                                                   J.SumaAseg_Local, J.SumaAseg_Moneda, J.Prima_Local, 
                                                   J.Prima_Moneda, nTasaCambio, J.SalarioMensual, J.VecesSalario);
            END LOOP;
         END LOOP;
      END IF;
       
      FOR W IN ENDOSO_Q LOOP
         nPrimaNetaTotal := NVL(nPrimaNetaTotal,0) + W.PrimaNeta;
         IF W.IndContinua = 'S' THEN
            FOR X IN DECLCONT_Q LOOP
               nNumAsegContinuan := NVL(nNumAsegContinuan,0) + 1;
               IF NVL(X.CodAsegurado,0) != 0 THEN  
                  nCuentaDifSumaAseg := 0;
                  IF OC_ASEGURADO_CERTIFICADO.STATUS_ASEGURADO(nCodCia, nIdPoliza, nIDetPol, X.CodAsegurado) = 'SUS' THEN
                     OC_ASEGURADO_CERTIFICADO.REHABILITAR(nCodCia, nIdPoliza, nIDetPol, X.CodAsegurado);
                     OC_COBERT_ACT_ASEG.REHABILITAR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, X.CodAsegurado);
                  END IF;
                  FOR J IN COBORIG_Q(X.CodAsegurado) LOOP
                     nSumaAseg := OC_COBERT_ACT_ASEG.SUMA_ASEGURADA(nCodCia, nIdPoliza, nIdetPol, X.CodAsegurado, J.CodCobert);
                     IF nSumaAseg <> X.SumaAsegurada THEN
                        nCuentaDifSumaAseg   := NVL(nCuentaDifSumaAseg,0) + 1;
                        nDifSumaAseg      := nSumaAseg - X.SumaAsegurada;
                        nAcumDifSumaAseg  := nAcumDifSumaAseg + nDifSumaAseg;
                        BEGIN
                           UPDATE ASEGURADO_CERTIFICADO
                              SET IndAjuSumaAsegDecl = 'S'
                            WHERE CodCia        = nCodCia
                              AND IdPoliza      = nIdPoliza
                              AND IdetPol       = nIDetPol
                              AND Cod_Asegurado = X.CodAsegurado; 
                        END;
                        GT_TEMP_LISTADO_DECLARACIONES.CALCULA_PRIMA_COBERTURAS(nCodCia, nCodEmpresa, nIdPoliza, nIdetPol, X.CodAsegurado, nNumCotizacion, nIDetCotizacion, cPlanCob, cIdTipoSeg, J.CodCobert, X.SumaAsegurada);
                        IF NVL(nIdEndosoSV,0) = 0 THEN
                           nIdEndosoSV       := OC_ENDOSO.CREAR(nIdPoliza);
                           cTipoEndosoSV     := 'ESVTL';
                           cTextoEndosoSV    := 'Listado de Asegurados con Ajuste de Suma Asegurada en Endoso a Declaración '||nIdEndoso||CHR(10)||CHR(10);
                           cNumEndRef        := 'AJU-SA ENDOSO '||nIdEndoso; 
                           cMotivo_EndosoSV  := '024';
                           cDescEndosoSV     := 'Endoso Sin Valor de AJUSTE SUMA ASEGURADA DE ASEGURADOS POR DECLARACION';
                           OC_ENDOSO.INSERTA_CP(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndosoSV, cTipoEndosoSV, cNumEndRef, 
                                                dFecIniVig, dFecFinVig, NULL, 0, 0, 0, cMotivo_EndosoSV, cDescEndosoSV, NULL);
                           OC_ENDOSO_TEXTO.INSERTA(nIdPoliza, nIdEndosoSV, cTextoEndosoSV);
                        END IF;
                        cTextoEndosoSV := ' ASEGURADO: '||X.CodAsegurado||' - '||OC_ASEGURADO.NOMBRE_ASEGURADO(nCodCia, nCodEmpresa, X.CodAsegurado) ||', COBERTURA: '||J.CodCobert||', SUMA ASEGURADA ORIGINAL: '||
                                          TO_CHAR(nSumaAseg,'$999,999,999.99')||', SUMA ASEGURADA MODIFICADA: '||TO_CHAR(X.SumaAsegurada,'$999,999,999.99')||CHR(10);
                        OC_ENDOSO_TEXTO.AGREGA_TEXTO(nIdPoliza, nIdEndosoSV, cTextoEndosoSV);
                     END IF;
                  END LOOP;
                  OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, nIdetPol, X.CodAsegurado);
                  IF NVL(nCuentaDifSumaAseg,0) <> 0 THEN
                     nCuentaAcumDifSA := NVL(nCuentaAcumDifSA,0) + 1; 
                  END IF;
                  IF NVL(nIdEndosoSV,0) <> 0 THEN
                     OC_ENDOSO.EMITIR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndosoSV, cTipoEndosoSV);
                  END IF;
               END IF;
            END LOOP;
         ELSIF W.IndAlta = 'S' THEN
            FOR X IN DECLALTA_Q LOOP   
               nNumAsegAlta         := NVL(nNumAsegAlta,0) + 1;
               nCodAseguradoAltas   := X.CodAsegurado;
               nIdEndosoProc        := nIdEndoso;
               
               IF nCodAseguradoAltas = 0 THEN
                  nCodAseguradoAltas := OC_ASEGURADO.INSERTAR_ASEGURADO(nCodCia, nCodEmpresa, X.TipoDocIdentificacion, X.NumDocIdentificacion);
               END IF;
               
               IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(X.TipoDocIdentificacion, X.NumDocIdentificacion) = 'N' THEN
                  BEGIN
                     SELECT CodPais, CodEstado, CodCiudad,
                            CodMunicipio
                       INTO cCodPaisRes, cCodProvRes, cCodDistRes,
                            cCodCorrRes
                       FROM APARTADO_POSTAL
                      WHERE TO_NUMBER(Codigo_Postal) = TO_NUMBER(X.CodigopostalAseg);
                  END;
                   
                  SELECT MIN(Codigo_Colonia)
                    INTO cCodColonia
                    FROM COLONIA
                   WHERE Codigo_Postal = X.Codigopostalaseg;
                   
                  OC_PERSONA_NATURAL_JURIDICA.INSERTAR_PERSONA(X.TipoDocIdentificacion, X.NumDocIdentificacion,
                                                               X.NombreAseg, X.ApellidoPaternoAseg, X.ApellidoMaternoAseg, NULL,
                                                               X.Sexoaseg, 'N', X.FechaNacimiento,
                                                               X.Direcaseg, NULL, NULL,
                                                               cCodPaisRes, cCodProvRes, cCodDistRes, 
                                                               cCodCorrRes, X.Codigopostalaseg, cCodColonia, 
                                                               NULL, NULL, NULL);
               END IF;
               IF NVL(nIdCotizacion,0) > 0 THEN
                  --
                  GT_TEMP_LISTADO_DECLARACIONES.GENERA_COBERTURAS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso, nCodAseguradoAltas, nIdCotizacion, nIDetCotizacion, cPlanCob, cIdTipoSeg, cCodMoneda, X.SumaAsegurada);
               ELSE
                  OC_ASEGURADO_CERTIFICADO.INSERTA (nCodCia, nIdPoliza, nIdetPol, nCodAseguradoAltas, nIdEndoso);
               END IF;
            END LOOP;
            
            IF NVL(nNumCotizacion,0) = 0 THEN
               SELECT MIN(Cod_Asegurado)
                 INTO nCodAseguradoIni   
                 FROM ASEGURADO_CERTIFICADO 
                WHERE CodCia     = nCodCia
                  AND IdPoliza   = nIdPoliza
                  AND IdetPol    = nIDetPol   
                  AND Estado     = 'EMI';
               OC_COBERT_ACT_ASEG.HEREDA_COB_ENDOSO_DECL(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAseguradoIni, cIdTipoSeg, cPlanCob, nIdEndoso);
            END IF;        
            
            FOR X IN ASEGCERT_Q LOOP
               OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, X.Cod_Asegurado);
               BEGIN
                  UPDATE COBERT_ACT_ASEG
                     SET IdEndoso      = nIdEndoso
                   WHERE CodCia        = nCodCia
                     AND IdPoliza      = nIdPoliza
                     AND IdetPol       = nIDetPol
                     AND Cod_Asegurado = X.Cod_Asegurado; 
               END;
               BEGIN
                  UPDATE ASISTENCIAS_ASEGURADO
                     SET StsAsistencia = 'EMITID',
                         FecSts        = TRUNC(SYSDATE),
                         IdEndoso      = nIdEndoso
                   WHERE CodCia        = nCodCia
                     AND IdPoliza      = nIdPoliza
                     AND IdetPol       = nIDetPol
                     AND Cod_Asegurado = X.Cod_Asegurado; 
               END;
            END LOOP;
         ELSIF W.IndBaja = 'S' THEN
            FOR X IN DECLBAJA_Q LOOP
               nNumAsegBaja := NVL(nNumAsegBaja,0) + 1;
               IF OC_ASEGURADO_CERTIFICADO.STATUS_ASEGURADO (nCodCia, nIdPoliza, nIDetPol, X.CodAsegurado) IN ('EMI') THEN
                  OC_ASEGURADO_CERTIFICADO.SUSPENDER(nCodCia, nIdPoliza, nIdetPol, X.CodAsegurado, dFecIniVig, '0001', nIdEndoso);
                  OC_COBERT_ACT_ASEG.SUSPENDER(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, X.CodAsegurado);
               END IF;
            END LOOP;
         ELSIF W.IndLog = 'S' THEN
            FOR X IN DECLLOG_Q LOOP
               nNumAsegLog := NVL(nNumAsegLog,0) + 1;
            END LOOP;
         END IF;
      END LOOP;
      --- AGREGA HISTORICO DE ASEGURADOS ACTIVOS
      FOR Z IN ASEGCERTHIST_Q LOOP
         nEdadAseg := OC_ASEGURADO.EDAD_ASEGURADO(nCodCia, nCodEmpresa, Z.Cod_Asegurado, dFecIniVig);
         GT_EAD_CONTROL_ASEGURADOS.INSERTAR(nCodCia, nCodEmpresa, nNumDeclaracion, nIdPoliza, nIDetPol, Z.Cod_Asegurado, nIdEndoso,
                                            Z.FecNacimiento, nEdadAseg, NULL, dFecIniVig, dFecFinVig, 
                                            Z.SumaAseg, Z.SumaAseg * nTasaCambio, Z.PrimaNeta, Z.PrimaNeta * nTasaCambio, Z.Estado);
         FOR J IN COBORIG_Q(Z.Cod_Asegurado) LOOP
            GT_EAD_CONTROL_ASEG_COBERT.INSERTAR(nCodCia, nCodEmpresa, nNumDeclaracion, nIdPoliza,
                                                nIDetPol, Z.Cod_Asegurado, nIdEndosoProc, J.CodCobert,
                                                J.SumaAseg_Local, J.SumaAseg_Moneda, J.Prima_Local, 
                                                J.Prima_Moneda, nTasaCambio, J.SalarioMensual, J.VecesSalario);
         END LOOP;
      END LOOP;
      cTextoEndoso := CHR(10)||CHR(10)||'**** R E S U M E N    D E C L A R A C I Ó N ****'                  ||CHR(10)||
                      '    Total Prima Neta Declarada: '                         ||NVL(nPrimaNetaTotal,0)   ||CHR(10)||
                      '    Asegurados Continúan: '                               ||NVL(nNumAsegContinuan,0) ||CHR(10)||
                      '    Asegurados Alta: '                                    ||NVL(nNumAsegAlta,0)      ||CHR(10)||
                      '    Asegurados Baja: '                                    ||NVL(nNumAsegBaja,0)      ||CHR(10)||
                      '    Asegurados Por Revisar: '                             ||NVL(nNumAsegLog,0)       ||CHR(10)||
                      '    Número Asegurados con Diferencia en Suma Asegurada '  ||NVL(nCuentaAcumDifSA,0)  ||CHR(10)||
                      '    Monto Acumulado Diferencias Sumas Asguradas: '        ||NVL(nAcumDifSumaAseg,0);
      OC_ENDOSO_TEXTO.AGREGA_TEXTO(nIdPoliza, nIdEndoso, cTextoEndoso);
      GT_TEMP_LISTADO_DECLARACIONES.ACTUALIZA_VALORES_ENDOSO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso);
      OC_ENDOSO.EMITIR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso, cTipoEndoso);
      GT_TEMP_LISTADO_DECLARACIONES.CANCELA_FACTURAS (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso, dFecIniVig);
      GT_TEMP_LISTADO_DECLARACIONES.ELIMINAR(nCodCia, nCodEmpresa, nIdPoliza);
   END IF;      
END APLICAR_ENDOSOS;

PROCEDURE EXCLUSION_ASEG_INI(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER) IS
nIdEndosoExc      ENDOSOS.IdEndoso%TYPE;
cTextoEndoso      ENDOSO_TEXTO.Texto%TYPE;
dFecAnulExclu     ASEGURADO_CERTIFICADO.FecAnulExclu%TYPE;
dFecIniVig        ENDOSOS.FecIniVig%TYPE;
dFecFinVig        ENDOSOS.FecFinVig%TYPE;
cMotivAnulExclu   ASEGURADO_CERTIFICADO.MotivAnulExclu%TYPE := '0005';
cTipoEndoso       ENDOSOS.TipoEndoso%TYPE := 'SUSP';
cNumEndRef        ENDOSOS.NumEndRef%TYPE := TO_CHAR(nIdEndoso);
cCodPlan          ENDOSOS.CodPlanPago%TYPE;
nSuma_Aseg_Moneda ENDOSOS.Suma_Aseg_Moneda%TYPE;
nPrima_Moneda     ENDOSOS.Prima_Neta_Moneda%TYPE;
nPorcComis        ENDOSOS.PorcComis%TYPE;
cMotivo_Endoso    ENDOSOS.Motivo_Endoso%TYPE := '010';
cDescEndoso       ENDOSOS.DescEndoso%TYPE := 'ENDOSO DE EXCLUSIÓN DE ASEGURADO AUTOMÁTICO POR DECLARACIÓN DE ASEGURADOS';
        
CURSOR DECLBAJA_Q IS   
   SELECT IdAsegurado, CodAsegurado, NutraCertificado, OtroDatoComparativo, 
          NombreAseg || ' ' || ApellidoPaternoAseg || ' ' || ApellidoMaternoAseg NombreCompleto,
          NombreAseg, ApellidoPaternoAseg, ApellidoMaternoAseg, 
          FechaNacimiento, TipoDocIdentificacion, NumDocIdentificacion,
          Sexoaseg, Direcaseg, Codigopostalaseg, SumaAsegurada, 
          PrimaNeta, IndContinua, IndAlta, IndBaja, IndLog, LogComparacion
     FROM TEMP_LISTADO_DECLARACIONES TL
    WHERE TL.CodCia        = nCodCia
      AND TL.CodEmpresa    = nCodEmpresa
      AND TL.IdPoliza      = nIdPoliza
      AND TL.IDetPol       = nIDetPol
      AND TL.IndBaja       = 'S'
      AND OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO_CP(CodCia, IdPoliza, IDetPol, CodAsegurado, 0) = 'S';
BEGIN
   nIdEndosoExc   := OC_ENDOSO.CREAR(nIdPoliza);
   cTextoEndoso   := 'Se Excluyen los Siguientes Asegurados: ' || CHR(10) || CHR(10); 
   
   BEGIN
      SELECT FecIniVig, FecFinVig, CodPlanPago, 
             Suma_Aseg_Moneda, Prima_Neta_Moneda
        INTO dFecIniVig, dFecFinVig, cCodPlan, 
             nSuma_Aseg_Moneda, nPrima_Moneda
        FROM ENDOSOS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdPoliza   = nIdPoliza
         AND IDetPol    = nIDetPol
         AND IdEndoso   = nIdEndoso;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'No es Posible Determinar la Vigencia del Endoso: '||SQLERRM);
   END;
   BEGIN
      SELECT D.PorcComis
        INTO nPorcComis
        FROM POLIZAS P,DETALLE_POLIZA D
       WHERE P.CodCia      = nCodCia
         AND P.CodEmpresa  = nCodEmpresa
         AND P.IdPoliza    = nIdPoliza
         AND P.CodCia      = D.CodCia
         AND P.CodEmpresa  = D.CodEmpresa
         AND P.IdPoliza    = D.IdPoliza;
   EXCEPTION 
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'No es Posible Determinar el Porcentaje de Comisión Para el Endoso de Exclusión de Asegurado: '||SQLERRM);
   END;
   
   OC_ENDOSO.INSERTA_CP(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndosoExc, cTipoEndoso, cNumEndRef, dFecIniVig, dFecFinVig,
                        cCodPlan, nSuma_Aseg_Moneda, nPrima_Moneda, nPorcComis, cMotivo_Endoso, cDescEndoso, NULL);
      
   SELECT MIN(FecVenc)
     INTO dFecAnulExclu
     FROM FACTURAS
    WHERE CodCia               = nCodCia
      AND IdPoliza             = nIdPoliza
      AND IdetPol              = nIDetPol
      AND TRUNC(FecVenc) BETWEEN dFecIniVig AND dFecFinVig
      AND StsFact              = 'EMI';
   FOR W IN DECLBAJA_Q LOOP
      cTextoEndoso := cTextoEndoso || TRIM(TO_CHAR(W.CodAsegurado)) || '-' || W.NombreCompleto || ' el ' ||  TO_CHAR(dFecAnulExclu,'DD/MM/YYYY') || CHR(10);
      UPDATE ASEGURADO_CERTIFICADO
         SET FecAnulExclu   = dFecAnulExclu,
             MotivAnulExclu = cMotivAnulExclu,
             IdEndosoExclu  = nIdEndosoExc
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND Cod_Asegurado = W.CodAsegurado;
   END LOOP;
   BEGIN
      INSERT INTO ENDOSO_TEXTO
             (IdPoliza, IdEndoso, Texto)
      VALUES (nIdPoliza, nIdEndosoExc, cTextoEndoso);
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         UPDATE ENDOSO_TEXTO
            SET Texto = cTextoEndoso
          WHERE IdPoliza   = cTextoEndoso
            AND IdEndoso   = nIdEndosoExc;
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error al Insertar Texto de Asegurados Excluidos '||SQLERRM);
   END;
   OC_ENDOSO.CALCULA_EXCLUSION_ASEG(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndosoExc);
   OC_ENDOSO.EXCLUIR_ASEGURADOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndosoExc);
   
END EXCLUSION_ASEG_INI;

PROCEDURE GENERA_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER,
                            nCodAsegurado NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, cPlanCob VARCHAR2, 
                            cIdTipoSeg VARCHAR2, cCodMoneda VARCHAR2, nSumaAseg NUMBER) IS
cIndCambioSAMI    COBERT_ACT_ASEG.IndCambioSAMI%TYPE;
nSumaAsegLocal    ASEGURADO_CERTIFICADO.SumaAseg%TYPE           := 0;
nSumaAsegMoneda   ASEGURADO_CERTIFICADO.SumaAseg_Moneda%TYPE    := 0;
nPrimaNeta        ASEGURADO_CERTIFICADO.PrimaNeta%TYPE          := 0;
nPrimaNeta_Mon    ASEGURADO_CERTIFICADO.PrimaNeta_Moneda%TYPE   := 0;
nSumaAsegOrigen   COBERT_ACT_ASEG.SumaAsegOrigen%TYPE           := 0;
dFecIniVig        ENDOSOS.FecIniVig%TYPE;
nTasaCambio       TASAS_CAMBIO.Tasa_Cambio%TYPE;
nNumPagos         PLAN_DE_PAGOS.NumPagos%TYPE;
nCuotaPromedio    COTIZACIONES_COBERT_MASTER.CuotaPromedio%TYPE;   
nSumaAsegCobert   COBERT_ACT_ASEG.Sumaaseg_Local%TYPE; 
nValorTipoTasa    NUMBER;
CURSOR COBCOTIZA_Q IS
   SELECT M.CodCobert, M.SumaAsegCobLocal, M.SumaAsegCobMoneda,
          M.Tasa, M.PrimaCobLocal, M.PrimaCobMoneda, M.Edad_Minima,
          M.Edad_Maxima, M.Edad_Exclusion, M.SalarioMensual, 
          M.VecesSalario, M.DeducibleCobLocal, M.DeducibleCobMoneda,
          M.SumaAsegCalculada, M.SumaAseg_Minima, M.SumaAseg_Maxima,
          M.PorcExtraPrimaDet, M.MontoExtraPrimaDet, M.SumaIngresada,
          M.DeducibleIngresado, M.CuotaPromedio, M.PrimaPromedio,
          C.SAMIAutorizado, C.IdTipoSeg, C.PlanCob,
          D.IndEdadPromedio, D.IndCuotaPromedio, D.IndPrimaPromedio
     FROM COTIZACIONES_COBERT_MASTER M, COTIZACIONES C, COTIZACIONES_DETALLE D
    WHERE M.CodCia         = nCodCia
      AND M.CodEmpresa     = nCodEmpresa
      AND M.IdCotizacion   = nIdCotizacion
      AND M.IDetCotizacion = nIDetCotizacion
      AND M.CodCia         = C.CodCia
      AND M.CodEmpresa     = C.CodEmpresa
      AND M.IdCotizacion   = C.IdCotizacion
      AND M.CodCia         = D.CodCia
      AND M.CodEmpresa     = D.CodEmpresa
      AND M.IdCotizacion   = D.IdCotizacion
      AND M.IDetCotizacion = D.IDetCotizacion
    ORDER BY OC_COBERTURAS_DE_SEGUROS.ORDEN_SESAS(C.CodCia, C.CodEmpresa, C.IdTipoSeg, C.PlanCob, M.CodCobert);                               
BEGIN
   nSumaAsegCobert   := nSumaAseg;
   BEGIN
      SELECT OC_PLAN_DE_PAGOS.CANTIDAD_PAGOS(nCodCia, nCodEmpresa, OC_POLIZAS.PLAN_DE_PAGOS(nCodCia, nCodEmpresa, nIdPoliza)) 
        INTO nNumPagos
        FROM DUAL;
   END;
   
---------------------------------  CAPELE 20191120
--            --  SOLO ESTABA EL INSERT Y MARCA ERROR YA QUE EL ENDOSO NO ES PARTE DE LA PK     
--            DECLARE
--                Existe  number := 0;                               
--            BEGIN
--                SELECT COUNT(*)
--                  INTO Existe
--                  FROM ASEGURADO_CERTIFICADO
--                 WHERE CodCia        = nCodCia
--                   AND IdPoliza      = nIdPoliza
--                   AND IdetPol       = nIDetPol
--                   AND Cod_Asegurado = nCodAsegurado
--                   AND ESTADO = 'ANU';
--                --
--                IF EXISTE > 0 THEN
--                    DELETE FROM COBERT_ACT_ASEG
--                     WHERE CodCia        = nCodCia
--                       AND IdPoliza      = nIdPoliza
--                       AND IdetPol       = nIDetPol
--                       AND Cod_Asegurado = nCodAsegurado;
--                    --
--                    DELETE FROM ASEGURADO_CERTIFICADO
--                     WHERE CodCia        = nCodCia
--                       AND IdPoliza      = nIdPoliza
--                       AND IdetPol       = nIDetPol
--                       AND Cod_Asegurado = nCodAsegurado;
--                END IF;
--            END;                
--                --
-------------------------------------------------------------------------------------------------                      
--   
   
   IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO_CP(nCodCia, nIdPoliza, nIDetPol, nCodAsegurado, nIdEndoso) = 'N' THEN
      INSERT INTO ASEGURADO_CERTIFICADO
            (CodCia, IdPoliza, IDetPol, Cod_Asegurado, Estado, SumaAseg, 
             PrimaNeta, IdEndoso, SumaAseg_Moneda, PrimaNeta_Moneda)
      VALUES(nCodCia, nIdPoliza, nIDetPol, nCodAsegurado, 'SOL', nSumaAsegLocal, 
             nPrimaNeta, nIdEndoso, nSumaAsegMoneda, nPrimaNeta_Mon);
   END IF;
          
   IF GT_EAD_CONTROL_ASEGURADOS.EXISTE_ASEGURADO_HIST(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdEndoso) = 'S' THEN
      dFecIniVig := OC_POLIZAS.INICIO_VIGENCIA(nCodCia, nCodEmpresa, nIdPoliza);
   ELSE
      BEGIN
         SELECT FecIniVig
           INTO dFecIniVig
           FROM ENDOSOS
          WHERE CodCia        = nCodCia
            AND CodEmpresa    = nCodEmpresa
            AND IdPoliza      = nIdPoliza
            AND IDetPol       = nIDetPol
            AND IdEndoso      = nIdEndoso;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20200,'NO es Posible Determinar la Fecha Inicio de Vigencia del Endoso' ||nIdEndoso);
      END;
   END IF;          
   FOR W IN COBCOTIZA_Q LOOP
      IF OC_ASEGURADO.EDAD_ASEGURADO(nCodCia, nCodEmpresa, nCodAsegurado, dFecIniVig) < NVL(W.Edad_Exclusion,0) THEN
         IF W.SAMIAutorizado > 0 AND nSumaAsegCobert > W.SAMIAutorizado THEN
            cIndCambioSAMI    := 'S';
            nSumaAsegCobert   := W.SAMIAutorizado;
         END IF;
         BEGIN
         
            IF NVL(W.IndEdadPromedio,'N') = 'S' AND NVL(W.CuotaPromedio,0) != 0 THEN
               NULL;
            ELSIF NVL(W.IndCuotaPromedio,'N') = 'S' AND NVL(W.CuotaPromedio,0) != 0 THEN
               nValorTipoTasa := OC_COBERTURAS_DE_SEGUROS.TIPO_TASA(nCodCia, nCodEmpresa, W.IdTipoSeg, W.PlanCob, W.CodCobert);
               nCuotaPromedio := (GT_COTIZACIONES_COBERT_MASTER.PRIMA_COBERTURA(nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, W.CodCobert) / nNumPagos) / nValorTipoTasa;
               nPrimaNeta     := (nCuotaPromedio * nSumaAsegCobert); 
            ELSIF NVL(W.IndPrimaPromedio,'N') = 'S' AND NVL(W.PrimaPromedio,0) != 0 THEN
               nPrimaNeta := (GT_COTIZACIONES_COBERT_MASTER.PRIMA_COBERTURA(nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, W.CodCobert) / nNumPagos);
            END IF;
         
--            nValorTipoTasa := OC_COBERTURAS_DE_SEGUROS.TIPO_TASA(nCodCia, nCodEmpresa, W.IdTipoSeg, W.PlanCob, W.CodCobert);
--            nCuotaPromedio := (GT_COTIZACIONES_COBERT_MASTER.PRIMA_COBERTURA(nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, W.CodCobert) / nNumPagos) / nValorTipoTasa;
--            nPrimaNeta     := (nCuotaPromedio * nSumaAsegCobert); 
            
            
            nTasaCambio    := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda,TRUNC(SYSDATE));
            nPrimaNeta_Mon := nPrimaNeta / nTasaCambio;
            
            INSERT INTO COBERT_ACT_ASEG
                   (CodCia, CodEmpresa, IdPoliza, IDetPol, TipoRef, NumRef,
                    IdTipoSeg, CodCobert, Cod_Asegurado, SumaAseg_Local, SumaAseg_Moneda, 
                    Tasa, Prima_Moneda, Prima_Local, IdEndoso, StsCobertura, 
                    PlanCob, Cod_Moneda, Deducible_Local, Deducible_Moneda, IndCambioSami,
                    SumaAsegOrigen,SalarioMensual, VecesSalario, SumaAsegCalculada,
                    Edad_Minima, Edad_Maxima, Edad_Exclusion, SumaAseg_Minima,
                    SumaAseg_Maxima, PorcExtraPrimaDet, MontoExtraPrimaDet,
                    SumaIngresada, PrimaNivMoneda, PrimaNivLocal)
            VALUES (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, 'POLI', nIdPoliza,
                    cIdTipoSeg, W.CodCobert, nCodAsegurado, nSumaAsegCobert, nSumaAsegCobert / nTasaCambio, 
                    nCuotaPromedio, nPrimaNeta_Mon, nPrimaNeta, nIdEndoso, 'SOL', 
                    cPlanCob, cCodMoneda, W.DeducibleCobLocal, W.DeducibleCobMoneda, cIndCambioSAMI,
                    nSumaAsegOrigen, W.SalarioMensual, W.VecesSalario, W.SumaAsegCalculada,
                    W.Edad_Minima, W.Edad_Maxima, W.Edad_Exclusion, W.SumaAseg_Minima,
                    W.SumaAseg_Maxima, W.PorcExtraPrimaDet, W.MontoExtraPrimaDet,
                    W.SumaIngresada, W.CuotaPromedio, W.PrimaPromedio);
            nSumaAsegLocal    := nSumaAsegLocal  + nSumaAsegCobert;
            nSumaAsegMoneda   := (nSumaAsegLocal + nSumaAsegCobert) / nTasaCambio;
            nPrimaNeta        := nPrimaNeta      + nPrimaNeta;
            nPrimaNeta_Mon    := nPrimaNeta_Mon  + nPrimaNeta_Mon;                 
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
               RAISE_APPLICATION_ERROR(-20200,'Duplicado Cobertura de Censo o Asegurado en Cobertura ' ||W.CodCobert);
         END;
      ELSE
         IF OC_COBERTURAS_DE_SEGUROS.VALIDA_BASICA(nCodCia, nCodEmpresa, W.IdTipoSeg, W.PlanCob, W.CodCobert) = 'S' THEN
            UPDATE ASEGURADO_CERTIFICADO
               SET Estado  = 'REZ'
             WHERE CodCia        = nCodCia
               AND IdPoliza      = nIdPoliza
               AND IDetPol       = nIDetPol
               AND Cod_Asegurado = nCodAsegurado;
            EXIT;
         END IF;
      END IF;
   END LOOP;
   
   UPDATE ASEGURADO_CERTIFICADO
      SET SumaAseg          = nSumaAsegLocal,
          SumaAseg_Moneda   = nSumaAsegMoneda,
          PrimaNeta         = nPrimaNeta,
          PrimaNeta_Moneda  = nPrimaNeta_Mon
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCodAsegurado;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20200,'Error al Crear las Coberturas desde Cotización '||SQLERRM);      
END GENERA_COBERTURAS;

PROCEDURE CANCELA_FACTURAS (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                            nIDetPol NUMBER, nIdEndoso NUMBER, dFechaIniVig DATE) IS
cAnulaRec         VARCHAR2(1) := 'N';
nTotPrimaCanc     DETALLE_FACTURAS.Saldo_Det_Local%TYPE;
nIdTransaccion    TRANSACCION.IdTransaccion%TYPE;
nNumCuotaIni      FACTURAS.NumCuota%TYPE;
cAnulo            VARCHAR2(1) := 'N';
nExiste           NUMBER(5);
CURSOR FACT_Q IS
   SELECT IdFactura
     FROM FACTURAS
    WHERE IdPoliza  = nIdPoliza
      AND IDetPol   = nIDetPol
      AND IdEndoso  = nIdEndoso
      AND CodCia    = nCodCia;
      
CURSOR CANCFACT_Q IS
   SELECT MAX(IdFactura) IdFactura, NumCuota, CodCobrador
     FROM FACTURAS
    WHERE IdPoliza            = nIdPoliza
      AND IDetPol             = nIDetPol
      --AND IdEndoso           != nIdEndoso
      AND IdEndoso            = 0
      AND dFechaIniVig  BETWEEN FecVenc AND FecFinVig
      AND CodCia              = nCodCia
      AND StsFact             = 'EMI'
    GROUP BY NumCuota, CodCobrador;
BEGIN
   nIdTransaccion := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 2, 'POL');
   FOR W IN CANCFACT_Q LOOP
      cAnulo := 'S';
      nNumCuotaIni := W.NumCuota;
      SELECT NVL(nTotPrimaCanc,0) + NVL(SUM(Saldo_Det_Moneda),0)
        INTO nTotPrimaCanc
        FROM DETALLE_FACTURAS D, FACTURAS F, CATALOGO_DE_CONCEPTOS C
       WHERE C.CodConcepto      = D.CodCpto
         AND C.CodCia           = F.CodCia
         AND (D.IndCptoPrima    = 'S'
          OR C.IndCptoServicio  = 'S')
         AND D.IdFactura        = F.IdFactura
         AND F.IdFactura        = W.IdFactura;

      OC_FACTURAS.ANULAR(nCodCia, W.IdFactura, TRUNC(SYSDATE),'PAD', W.CodCobrador, nIdTransaccion);
      OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa, 2, 'FAC', 'FACTURAS', nIdPoliza, nIDetPol, nIdEndoso, W.IdFactura, nTotPrimaCanc);
   END LOOP;
   IF cAnulo = 'N' THEN
      RAISE_APPLICATION_ERROR(-20200,'No Existen Facturas A Cancelar Para la Póliza ' ||nIdPoliza);
   ELSE
      OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');
      
      SELECT COUNT(*)
        INTO nExiste
        FROM FACTURAS
       WHERE IdPoliza  = nIdPoliza
         AND IDetPol   = nIDetPol
         AND IdEndoso  = nIdEndoso
         AND CodCia    = nCodCia;
         
      IF NVL(nExiste,0) != 0 THEN
         FOR W IN FACT_Q LOOP
            UPDATE FACTURAS
               SET NumCuota  = nNumCuotaIni
             WHERE IdFactura = W.IdFactura;
            
            nNumCuotaIni := nNumCuotaIni + 1;
         END LOOP;
      END IF;
   END IF;
END CANCELA_FACTURAS;

PROCEDURE ACTUALIZA_VALORES_ENDOSO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER) IS
nSumaLocal          COBERTURAS.Suma_Asegurada_Local%TYPE;
nSumaMoneda         COBERTURAS.Suma_Asegurada_Moneda%TYPE;
nPrimaLocal         COBERTURAS.Prima_Local%TYPE;
nPrimaMoneda        COBERTURAS.Prima_Moneda%TYPE;
nMontoAsistLocal    ASISTENCIAS_ASEGURADO.MontoAsistLocal%TYPE;
nMontoAsistMoneda   ASISTENCIAS_ASEGURADO.MontoAsistMoneda%TYPE;
cTipoEndoso         ENDOSOS.TipoEndoso%TYPE;
nNumeroCuotas       PLAN_DE_PAGOS.NumPagos%TYPE;
cCodPlanPago        ENDOSOS.CodPlanPago%TYPE;
BEGIN
   cCodPlanPago   := OC_POLIZAS.PLAN_DE_PAGOS(nCodCia, nCodEmpresa, nIdPoliza);
   nNumeroCuotas  := OC_PLAN_DE_PAGOS.CANTIDAD_PAGOS(nCodCia, nCodEmpresa, cCodPlanPago);
   
   SELECT NVL(SUM(MontoAsistLocal),0), NVL(SUM(MontoAsistMoneda),0)
     INTO nMontoAsistLocal, nMontoAsistMoneda
     FROM ASISTENCIAS_DETALLE_POLIZA
    WHERE CodCia          = nCodCia
      AND IdPoliza        = nIdPoliza
      --AND IdEndoso        = nIdEndoso
      AND IDetPol        = nIDetPol
      AND StsAsistencia NOT IN ('EXCLUI');

   SELECT NVL(SUM(SumaAseg_Local),0) + NVL(nSumaLocal,0), NVL(SUM(SumaAseg_Moneda),0) + NVL(nSumaMoneda,0),
          NVL(SUM(Prima_Local),0) + NVL(nPrimaLocal,0), NVL(SUM(Prima_Moneda),0) + NVL(nPrimaMoneda,0)
     INTO nSumaLocal, nSumaMoneda,
          nPrimaLocal, nPrimaMoneda
     FROM COBERT_ACT_ASEG
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND IdEndoso     != 0
      AND StsCobertura IN ('EMI','SOL','XRE');
      
   SELECT NVL(SUM(SumaAseg_Local),0) + NVL(nSumaLocal,0), NVL(SUM(SumaAseg_Moneda),0) + NVL(nSumaMoneda,0),
          NVL(SUM(Prima_Local / nNumeroCuotas),0) + NVL(nPrimaLocal,0), NVL(SUM(Prima_Moneda / nNumeroCuotas),0) + NVL(nPrimaMoneda,0)
     INTO nSumaLocal, nSumaMoneda,
          nPrimaLocal, nPrimaMoneda
     FROM COBERT_ACT_ASEG
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND IdEndoso      = 0
      AND StsCobertura IN ('EMI','XRE');      

   SELECT NVL(SUM(MontoAsistLocal),0) + NVL(nMontoAsistLocal,0),
          NVL(SUM(MontoAsistMoneda),0) + NVL(nMontoAsistMoneda,0)
     INTO nMontoAsistLocal, nMontoAsistMoneda
     FROM ASISTENCIAS_ASEGURADO
    WHERE CodCia          = nCodCia
      AND IdPoliza        = nIdPoliza
      AND IDetPol         = nIDetPol
      --AND IdEndoso        = nIdEndoso
      AND StsAsistencia NOT IN ('EXCLUI');

   SELECT L.TipoEndoso
     INTO cTipoEndoso
     FROM ENDOSOS L
    WHERE L.CodCia   = nCodCia
      AND L.IdPoliza = nIdPoliza
      AND IDetPol    = nIDetPol
      AND L.IdEndoso = nIdEndoso
      ;

   IF cTipoEndoso NOT IN ('ESV','ESVTL') THEN
      UPDATE ENDOSOS
         SET Suma_Aseg_Local   = NVL(nSumaLocal,0),
             Suma_Aseg_Moneda  = NVL(nSumaMoneda,0),
             Prima_Neta_Local  = NVL(nPrimaLocal,0) + NVL(nMontoAsistLocal,0),
             Prima_Neta_Moneda = NVL(nPrimaMoneda,0) + NVL(nMontoAsistMoneda,0)
       WHERE CodCia    = nCodCia
         AND IdPoliza  = nIdPoliza
         AND IDetPol   = nIDetPol
         AND IdEndoso  = nIdEndoso;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error general en ACTUALIZA_VALORES:   '||SQLERRM);
END ACTUALIZA_VALORES_ENDOSO;

PROCEDURE CALCULA_PRIMA_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                                   nCodAsegurado NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER, 
                                   cPlanCob VARCHAR2, cIdTipoSeg VARCHAR2, cCodCobert VARCHAR2, nSumaAseg NUMBER) IS
cIndCambioSAMI    COBERT_ACT_ASEG.IndCambioSAMI%TYPE;
nSumaAsegLocal    ASEGURADO_CERTIFICADO.SumaAseg%TYPE           := 0;
nSumaAsegMoneda   ASEGURADO_CERTIFICADO.SumaAseg_Moneda%TYPE    := 0;
nPrimaNeta        ASEGURADO_CERTIFICADO.PrimaNeta%TYPE          := 0;
nPrimaNeta_Mon    ASEGURADO_CERTIFICADO.PrimaNeta_Moneda%TYPE   := 0;
nTasaCambio       TASAS_CAMBIO.Tasa_Cambio%TYPE;
nNumPagos         PLAN_DE_PAGOS.NumPagos%TYPE;
nCuotaPromedio    COTIZACIONES_COBERT_MASTER.CuotaPromedio%TYPE;   
nSumaAsegCobert   COBERT_ACT_ASEG.Sumaaseg_Local%TYPE; 
nSAMIAutorizado   COTIZACIONES.SAMIAutorizado%TYPE;
cCodMoneda        POLIZAS.Cod_Moneda%TYPE;
nValorTipoTasa    NUMBER;              
nIdEndosoAseg     ASEGURADO_CERTIFICADO.IdEndoso%TYPE;          
BEGIN
   BEGIN
      SELECT C.SAMIAutorizado, C.Cod_Moneda
        INTO nSAMIAutorizado, cCodMoneda
        FROM COTIZACIONES_COBERT_MASTER M, COTIZACIONES C
       WHERE M.CodCia         = nCodCia
         AND M.CodEmpresa     = nCodEmpresa
         AND M.IdCotizacion   = nIdCotizacion
         AND M.IDetCotizacion = nIDetCotizacion
         AND M.CodCobert      = cCodCobert
         AND M.CodCia         = C.CodCia
         AND M.CodEmpresa     = C.CodEmpresa
         AND M.IdCotizacion   = C.IdCotizacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'No es posible determinar datos de cotización para recalculo de prima por diferencia de Suma Asegurada');
   END;
   nSumaAsegCobert   := nSumaAseg;
   BEGIN
      SELECT OC_PLAN_DE_PAGOS.CANTIDAD_PAGOS(nCodCia, nCodEmpresa, OC_POLIZAS.PLAN_DE_PAGOS(nCodCia, nCodEmpresa, nIdPoliza))
        INTO nNumPagos
        FROM DUAL;
   END;
   
   IF nSAMIAutorizado > 0 AND nSumaAsegCobert > nSAMIAutorizado THEN
      cIndCambioSAMI    := 'S';
      nSumaAsegCobert   := nSAMIAutorizado;
   END IF;
   
   BEGIN
      BEGIN
         SELECT NVL(IdEndoso,0)
           INTO nIdEndosoAseg
           FROM ASEGURADO_CERTIFICADO
          WHERE CodCia        = nCodCia
            AND IdPoliza      = nIdPoliza
            AND IDetPol       = nIDetPol
            AND Cod_Asegurado  = nCodAsegurado;   
           
      END;
      nValorTipoTasa := OC_COBERTURAS_DE_SEGUROS.TIPO_TASA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, cCodCobert);
      IF nIdEndosoAseg = 0 THEN
         nCuotaPromedio := (GT_COTIZACIONES_COBERT_MASTER.PRIMA_COBERTURA(nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, cCodCobert)) / nValorTipoTasa; 
      ELSE
         nCuotaPromedio := (GT_COTIZACIONES_COBERT_MASTER.PRIMA_COBERTURA(nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, cCodCobert) / nNumPagos) / nValorTipoTasa;
      END IF;
      nPrimaNeta     := (nCuotaPromedio * nSumaAsegCobert); 
      nTasaCambio    := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda,TRUNC(SYSDATE));
      nPrimaNeta_Mon := nPrimaNeta / nTasaCambio;
      nSumaAsegLocal    := nSumaAsegCobert;
      nSumaAsegMoneda   := nSumaAsegLocal / nTasaCambio;
      --DBMS_OUTPUT.PUT_LINE('nCodAsegurado '||nCodAsegurado||' cCodCobert '||cCodCobert||' nPrimaNeta '||nPrimaNeta||' nSumaAsegCobert '||nSumaAsegCobert);
      UPDATE COBERT_ACT_ASEG
         SET SumaAseg_Local   = nSumaAsegLocal,
             SumaAseg_Moneda  = nSumaAsegMoneda, 
             Prima_Moneda     = nPrimaNeta, 
             Prima_Local      = nPrimaNeta_Mon,
             Tasa             = nCuotaPromedio,
             IndCambioSami    = cIndCambioSAMI
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND Cod_Asegurado = nCodAsegurado
         AND CodCobert     = cCodCobert
         AND IdTipoSeg     = cIdTipoSeg
         AND PlanCob       = cPlanCob; 
         
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20200,'Duplicado Cobertura de Censo o Asegurado en Cobertura ' ||cCodCobert);
   END;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20200,'Error al Recalcular Primas de Coberturas por Ajuste de Sumas Asegurada '||SQLERRM); 
END CALCULA_PRIMA_COBERTURAS;    


/*********************************************** DECLARACIONES HISTORICAS *************************************************************/                                      
PROCEDURE APLICAR_ENDOSO_HIST(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER) IS
cTextoEndoso               VARCHAR2(3000);
dFecIniVig                 ENDOSOS.FecIniVig%TYPE;
dFecFinVig                 ENDOSOS.FecFinVig%TYPE;
cTipoEndoso                ENDOSOS.TipoEndoso%TYPE;
nDiasProrrata              NUMBER(6);
cCodPlanPago               PLAN_DE_PAGOS.CodPlanPago%TYPE;
nCantidadPagos             NUMBER;
nPrimaNetaTotal            NUMBER(28,2);
nNumAsegContinuan          NUMBER;
nNumAsegAlta               NUMBER;
nNumAsegBaja               NUMBER;
nNumAsegLog                NUMBER;
nCodAseguradoAltas         ASEGURADO.Cod_Asegurado%TYPE;
nCodAsegurado              ASEGURADO.Cod_Asegurado%TYPE;
cCodPaisRes                PERSONA_NATURAL_JURIDICA.CodPaisRes%TYPE;
cCodProvRes                PERSONA_NATURAL_JURIDICA.CodProvRes%TYPE;
cCodDistRes                PERSONA_NATURAL_JURIDICA.CodDistRes%TYPE; 
cCodCorrRes                PERSONA_NATURAL_JURIDICA.CodCorrRes%TYPE; 
cCodColonia                PERSONA_NATURAL_JURIDICA.CodColRes%TYPE;
cPlanCob                   DETALLE_POLIZA.PlanCob%TYPE;
cIdTipoSeg                 DETALLE_POLIZA.IdTipoSeg%TYPE;
nCodAseguradoIni           ASEGURADO.Cod_Asegurado%TYPE;
nNumCotizacion             POLIZAS.Num_Cotizacion%TYPE;
nIdCotizacion              COTIZACIONES.IdCotizacion%TYPE;
nIDetCotizacion            COTIZACIONES_DETALLE.IDetCotizacion%TYPE;
nPrimaLocal                COBERT_ACT_ASEG.Prima_Local%TYPE;
nPrimaMoneda               COBERT_ACT_ASEG.Prima_Moneda%TYPE;
nNumDeclaracion            EAD_CONTROL_ASEGURADOS.NumDeclaracion%TYPE;
nTasaCambio                TASAS_CAMBIO.Tasa_Cambio%TYPE;
cCodMoneda                 POLIZAS.Cod_Moneda%TYPE;
nIdEndosoProc              ENDOSOS.IdEndoso%TYPE;
nEdadAseg                  NUMBER;
dFecIniVigPol              ENDOSOS.FecIniVig%TYPE;
nCuentaContinua            NUMBER := 0;
nCuentaAltas               NUMBER := 0;
nCuentaBajas               NUMBER := 0;
nCuentaLog                 NUMBER := 0;
nDifSumaAseg               NUMBER := 0;
nAcumDifSumaAseg           NUMBER := 0;
nSumaAseg                  ASEGURADO_CERTIFICADO.SumaAseg%TYPE;
nCuentaDifSumaAseg         NUMBER;
nCuentaAcumDifSA           NUMBER;

nIdEndosoSV                ENDOSOS.IdEndoso%TYPE;
cTextoEndosoSV             VARCHAR2(30000);
cTipoEndosoSV              ENDOSOS.TipoEndoso%TYPE;
cNumEndRef                 ENDOSOS.NumEndRef%TYPE;
cMotivo_EndosoSV           ENDOSOS.Motivo_Endoso%TYPE;
cDescEndosoSV              ENDOSOS.DescEndoso%TYPE;

nPrimaOrigLocalDetPol      DETALLE_POLIZA.Prima_Local%TYPE;
nPrimaOrigMonedaDetPol     DETALLE_POLIZA.Prima_Moneda%TYPE;
nSumaAsegOrigLcalDetPol    DETALLE_POLIZA.Suma_Aseg_Local%TYPE;
nSumaAsegOrigMonedaDetPol  DETALLE_POLIZA.Suma_Aseg_Moneda%TYPE;
CURSOR DECLCONT_Q IS   
   SELECT IdAsegurado, CodAsegurado, NutraCertificado, OtroDatoComparativo, 
          NombreAseg || ' ' || ApellidoPaternoAseg || ' ' || ApellidoMaternoAseg NombreCompleto,
          NombreAseg, ApellidoPaternoAseg, ApellidoMaternoAseg, 
          FechaNacimiento, TipoDocIdentificacion, NumDocIdentificacion,
          Sexoaseg, Direcaseg, Codigopostalaseg, SumaAsegurada, 
          PrimaNeta, IndContinua, IndAlta, IndBaja, IndLog, LogComparacion
     FROM TEMP_LISTADO_DECLARACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND IndContinua  = 'S';
      
CURSOR DECLALTA_Q IS   
   SELECT IdAsegurado, CodAsegurado, NutraCertificado, OtroDatoComparativo, 
          NombreAseg || ' ' || ApellidoPaternoAseg || ' ' || ApellidoMaternoAseg NombreCompleto,
          NombreAseg, ApellidoPaternoAseg, ApellidoMaternoAseg, 
          FechaNacimiento, TipoDocIdentificacion, NumDocIdentificacion,
          Sexoaseg, Direcaseg, Codigopostalaseg, SumaAsegurada, 
          PrimaNeta, IndContinua, IndAlta, IndBaja, IndLog, LogComparacion
     FROM TEMP_LISTADO_DECLARACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND IndAlta      = 'S';
      
CURSOR DECLBAJA_Q IS   
   SELECT IdAsegurado, CodAsegurado, NutraCertificado, OtroDatoComparativo, 
          NombreAseg || ' ' || ApellidoPaternoAseg || ' ' || ApellidoMaternoAseg NombreCompleto,
          NombreAseg, ApellidoPaternoAseg, ApellidoMaternoAseg, 
          FechaNacimiento, TipoDocIdentificacion, NumDocIdentificacion,
          Sexoaseg, Direcaseg, Codigopostalaseg, SumaAsegurada, 
          PrimaNeta, IndContinua, IndAlta, IndBaja, IndLog, LogComparacion
     FROM TEMP_LISTADO_DECLARACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND IndBaja      = 'S';  
      
CURSOR DECLLOG_Q IS   
   SELECT IdAsegurado, CodAsegurado, NutraCertificado, OtroDatoComparativo, 
          NombreAseg || ' ' || ApellidoPaternoAseg || ' ' || ApellidoMaternoAseg NombreCompleto,
          NombreAseg, ApellidoPaternoAseg, ApellidoMaternoAseg, 
          FechaNacimiento, TipoDocIdentificacion, NumDocIdentificacion,
          Sexoaseg, Direcaseg, Codigopostalaseg, SumaAsegurada, 
          PrimaNeta, IndContinua, IndAlta, IndBaja, IndLog, LogComparacion
     FROM TEMP_LISTADO_DECLARACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND IndLog       = 'S';            
      
CURSOR ENDOSO_Q IS      
   SELECT SUM(SumaAsegurada) SumaAsegurada,SUM(PrimaNeta) PrimaNeta,
          NVL(IndContinua,'N') IndContinua, NVL(IndAlta,'N') IndAlta, 
          NVL(IndBaja,'N') IndBaja, NVL(IndLog,'N') IndLog
     FROM TEMP_LISTADO_DECLARACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
    GROUP BY IndContinua, IndAlta, IndBaja, IndLog;

CURSOR ASEGCERT_Q IS
   SELECT Cod_Asegurado,PrimaNeta,SumaAseg,
          OC_ASEGURADO.FECHA_NACIMIENTO(nCodCia, nCodEmpresa, Cod_Asegurado) FecNacimiento
     FROM ASEGURADO_CERTIFICADO  
    WHERE CodCia       = nCodCia
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol 
      AND IdEndoso     = nIdEndoso; 
      
CURSOR COB_Q IS
   SELECT CodCobert, Prima_Moneda, Prima_Local, Cod_Moneda
     FROM COBERT_ACT_ASEG
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCodAseguradoAltas
      AND IdTipoSeg     = cIdTipoSeg
      AND PlanCob       = cPlanCob; 
      
CURSOR ASEGCERTORIG_Q IS
   SELECT Cod_Asegurado,PrimaNeta,SumaAseg,
          OC_ASEGURADO.FECHA_NACIMIENTO(nCodCia, nCodEmpresa, Cod_Asegurado) FecNacimiento
     FROM ASEGURADO_CERTIFICADO  
    WHERE CodCia       = nCodCia
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol 
      AND IdEndoso     = nIdEndosoProc; 
      
CURSOR COBORIG_Q(nCodAseguradoOrig IN NUMBER) IS
   SELECT CodCobert, Prima_Moneda, Prima_Local, Cod_Moneda,
          SumaAseg_Local, SumaAseg_Moneda, SalarioMensual, 
          VecesSalario
     FROM COBERT_ACT_ASEG
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCodAseguradoOrig
      AND IdTipoSeg     = cIdTipoSeg
      AND PlanCob       = cPlanCob;     
      
CURSOR ASEGCERTHIST_Q IS
   SELECT Cod_Asegurado,PrimaNeta,SumaAseg,Estado,
          OC_ASEGURADO.FECHA_NACIMIENTO(nCodCia, nCodEmpresa, Cod_Asegurado) FecNacimiento
     FROM ASEGURADO_CERTIFICADO  
    WHERE CodCia     = nCodCia
      AND IdPoliza   = nIdPoliza
      AND IDetPol    = nIDetPol
      AND Estado    IN ('EMI')
      AND IdEndoso  != nIdEndoso
    UNION
   SELECT Cod_Asegurado,PrimaNeta,SumaAseg,Estado,
          OC_ASEGURADO.FECHA_NACIMIENTO(nCodCia, nCodEmpresa, Cod_Asegurado) FecNacimiento
     FROM ASEGURADO_CERTIFICADO  
    WHERE CodCia     = nCodCia
      AND IdPoliza   = nIdPoliza
      AND IDetPol    = nIDetPol
      AND Estado    IN ('EMI','SUS','SOL')
      AND IdEndoso   = nIdEndoso      
   ;         
      
BEGIN
   /*VALIDACION DE COMPARATIVO PREVIO*/
   SELECT COUNT(IndContinua)
     INTO nCuentaContinua
     FROM TEMP_LISTADO_DECLARACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND IndContinua  = 'S';
      
   SELECT COUNT(IndAlta)
     INTO nCuentaAltas
     FROM TEMP_LISTADO_DECLARACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND IndAlta      = 'S';
      
   SELECT COUNT(IndBaja)
     INTO nCuentaBajas
     FROM TEMP_LISTADO_DECLARACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND IndBaja      = 'S';  
       
   SELECT COUNT(IndLog)
     INTO nCuentaLog
     FROM TEMP_LISTADO_DECLARACIONES
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND IndLog       = 'S';             
   /**********************************/
   
   /* VALORES ORIGINALES DE DETALLE POLIZA */
   BEGIN
      SELECT Prima_Local, Prima_Moneda,
             Suma_Aseg_Local, Suma_Aseg_Moneda
        INTO nPrimaOrigLocalDetPol,nPrimaOrigMonedaDetPol,
             nSumaAsegOrigLcalDetPol,nSumaAsegOrigMonedaDetPol
        FROM DETALLE_POLIZA
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza
         AND IDetPol      = nIDetPol;
   EXCEPTION 
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'No es Posible Determinar Valores Origen de Detalle de Póliza');
   END;
   /****************************************/
   
   IF NVL(nCuentaLog,0) = 0 AND NVL(nCuentaBajas,0) = 0 AND NVL(nCuentaAltas,0) = 0 AND NVL(nCuentaContinua,0) = 0 THEN
      RAISE_APPLICATION_ERROR(-20225,'No es Posible Aplicar el Endoso, Debe Realizar un Comparativo   '||SQLERRM);
   ELSE
      cTextoEndoso   := 'Carga de Asegurados a Declaración de la Póliza '||nIdPoliza||' Endoso '||nIdEndoso                                             ||CHR(10)||
                        'Declaración Realizada el Día '||OC_GENERALES.FECHA_EN_LETRA(TRUNC(SYSDATE))||' Por ' ||OC_USUARIOS.NOMBRE_USUARIO(nCodCia,USER)||CHR(10)||CHR(10);
      OC_ENDOSO_TEXTO.INSERTA(nIdPoliza, nIdEndoso, cTextoEndoso);
      cTextoEndoso   := NULL;
      nIdEndosoProc  := 0;
      
      BEGIN
         SELECT FecIniVig,FecFinVig,TRUNC(FecFinVig) - TRUNC(FecIniVig),TipoEndoso, CodPlanPago
           INTO dFecIniVig,dFecFinVig,nDiasProrrata,cTipoEndoso, cCodPlanPago
           FROM ENDOSOS
          WHERE CodCia     = nCodCia
            AND IdPoliza   = nIdPoliza
            AND IdetPol    = nIDetPol
            AND IdEndoso   = nIdEndoso;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20225,'No es Posible Determinar Datos Generales del Endoso Para Generar la Declaración '||SQLERRM);
      END;
      
      BEGIN
         SELECT NVL(Num_Cotizacion,0),Cod_Moneda, FecIniVig
           INTO nNumCotizacion, cCodMoneda, dFecIniVigPol
           FROM POLIZAS
          WHERE CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND IdPoliza   = nIdPoliza;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20225,'No es Posible Determinar Datos Generales de la Póliza Para Generar la Declaración '||SQLERRM);
      END;
      
      IF NVL(nNumCotizacion,0) > 0 THEN
         BEGIN
            SELECT C.IdCotizacion,D.IDetCotizacion
              INTO nIdCotizacion,nIDetCotizacion
              FROM COTIZACIONES C,COTIZACIONES_DETALLE D
             WHERE C.CodCia         = nCodCia 
               AND C.CodEmpresa     = nCodEmpresa
               AND C.IdCotizacion   = nNumCotizacion
               AND D.IDetCotizacion = nIDetPol
               AND C.CodCia         = D.CodCia 
               AND C.CodEmpresa     = D.CodEmpresa 
               AND C.IdCotizacion   = D.IdCotizacion;
         END;
      END IF;
      
      BEGIN
         SELECT PlanCob,IdTipoSeg
           INTO cPlanCob,cIdTipoSeg
           FROM DETALLE_POLIZA
          WHERE CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND IdPoliza   = nIdPoliza
            AND IdetPol    = nIDetPol;
      END;
      
      nTasaCambio       := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
      nCantidadPagos    := OC_PLAN_DE_PAGOS.CANTIDAD_PAGOS(nCodCia, nCodEmpresa, cCodPlanPago);
      nNumDeclaracion   := GT_EAD_CONTROL_ASEGURADOS.NUMERO_DECLARACION(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol);
      --- ASEGURADOS INICIALES EN LA DECLARACION
      IF GT_EAD_CONTROL_ASEGURADOS.EXISTE_ENDOSO_INICIAL(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol) = 'N' THEN
         FOR Z IN ASEGCERTORIG_Q LOOP
            nEdadAseg := OC_ASEGURADO.EDAD_ASEGURADO(nCodCia, nCodEmpresa, Z.Cod_Asegurado, dFecIniVigPol);
            GT_EAD_CONTROL_ASEGURADOS.INSERTAR(nCodCia, nCodEmpresa, 0, nIdPoliza, nIDetPol, Z.Cod_Asegurado, nIdEndosoProc,
                                               Z.FecNacimiento, nEdadAseg, NULL, dFecIniVig, dFecFinVig, 
                                               Z.SumaAseg, Z.SumaAseg * nTasaCambio, Z.PrimaNeta, Z.PrimaNeta * nTasaCambio, NULL);
            FOR J IN COBORIG_Q(Z.Cod_Asegurado) LOOP
               GT_EAD_CONTROL_ASEG_COBERT.INSERTAR(nCodCia, nCodEmpresa, 0, nIdPoliza,
                                                   nIDetPol, Z.Cod_Asegurado, nIdEndosoProc, J.CodCobert,
                                                   J.SumaAseg_Local, J.SumaAseg_Moneda, J.Prima_Local, 
                                                   J.Prima_Moneda, nTasaCambio, J.SalarioMensual, J.VecesSalario);
            END LOOP;
         END LOOP;
      END IF;
       
      FOR W IN ENDOSO_Q LOOP
         nPrimaNetaTotal := NVL(nPrimaNetaTotal,0) + W.PrimaNeta;
         IF W.IndContinua = 'S' THEN
            FOR X IN DECLCONT_Q LOOP
               nNumAsegContinuan := NVL(nNumAsegContinuan,0) + 1;
               IF NVL(X.CodAsegurado,0) != 0 THEN  
                  nCuentaDifSumaAseg := 0;
                  IF OC_ASEGURADO_CERTIFICADO.STATUS_ASEGURADO(nCodCia, nIdPoliza, nIDetPol, X.CodAsegurado) = 'SUS' THEN
                     OC_ASEGURADO_CERTIFICADO.REHABILITAR(nCodCia, nIdPoliza, nIDetPol, X.CodAsegurado);
                     OC_COBERT_ACT_ASEG.REHABILITAR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, X.CodAsegurado);
                  END IF;
                  FOR J IN COBORIG_Q(X.CodAsegurado) LOOP
                     nSumaAseg := OC_COBERT_ACT_ASEG.SUMA_ASEGURADA(nCodCia, nIdPoliza, nIdetPol, X.CodAsegurado, J.CodCobert);
                     IF nSumaAseg <> X.SumaAsegurada THEN
                        nCuentaDifSumaAseg   := NVL(nCuentaDifSumaAseg,0) + 1;
                        nDifSumaAseg      := nSumaAseg - X.SumaAsegurada;
                        nAcumDifSumaAseg  := nAcumDifSumaAseg + nDifSumaAseg;
                        BEGIN
                           UPDATE ASEGURADO_CERTIFICADO
                              SET IndAjuSumaAsegDecl = 'S'
                            WHERE CodCia        = nCodCia
                              AND IdPoliza      = nIdPoliza
                              AND IdetPol       = nIDetPol
                              AND Cod_Asegurado = X.CodAsegurado; 
                        END;
                        GT_TEMP_LISTADO_DECLARACIONES.CALCULA_PRIMA_COBERTURAS(nCodCia, nCodEmpresa, nIdPoliza, nIdetPol, X.CodAsegurado, nNumCotizacion, nIDetCotizacion, cPlanCob, cIdTipoSeg, J.CodCobert, X.SumaAsegurada);
                        IF NVL(nIdEndosoSV,0) = 0 THEN
                           nIdEndosoSV       := OC_ENDOSO.CREAR(nIdPoliza);
                           cTipoEndosoSV     := 'ESVTL';
                           cTextoEndosoSV    := 'Listado de Asegurados con Ajuste de Suma Asegurada en Endoso a Declaración '||nIdEndoso||CHR(10)||CHR(10);
                           cNumEndRef        := 'AJU-SA ENDOSO '||nIdEndoso; 
                           cMotivo_EndosoSV  := '024';
                           cDescEndosoSV     := 'Endoso Sin Valor de AJUSTE SUMA ASEGURADA DE ASEGURADOS POR DECLARACION';
                           OC_ENDOSO.INSERTA_CP(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndosoSV, cTipoEndosoSV, cNumEndRef, 
                                                dFecIniVig, dFecFinVig, NULL, 0, 0, 0, cMotivo_EndosoSV, cDescEndosoSV, NULL);
                           OC_ENDOSO_TEXTO.INSERTA(nIdPoliza, nIdEndosoSV, cTextoEndosoSV);
                        END IF;
--                        cTextoEndosoSV := ' ASEGURADO: '||X.CodAsegurado||' - '||OC_ASEGURADO.NOMBRE_ASEGURADO(nCodCia, nCodEmpresa, X.CodAsegurado) ||', COBERTURA: '||J.CodCobert||', SUMA ASEGURADA ORIGINAL: '||
--                                          TO_CHAR(nSumaAseg,'$999,999,999.99')||', SUMA ASEGURADA MODIFICADA: '||TO_CHAR(X.SumaAsegurada,'$999,999,999.99')||CHR(10);
--                        OC_ENDOSO_TEXTO.AGREGA_TEXTO(nIdPoliza, nIdEndosoSV, cTextoEndosoSV);
                     END IF;
                  END LOOP;
                  OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, nIdetPol, X.CodAsegurado);
                  IF NVL(nCuentaDifSumaAseg,0) <> 0 THEN
                     nCuentaAcumDifSA := NVL(nCuentaAcumDifSA,0) + 1; 
                  END IF;
                  IF NVL(nIdEndosoSV,0) <> 0 THEN
                     OC_ENDOSO.EMITIR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndosoSV, cTipoEndosoSV);
                  END IF;
               END IF;
            END LOOP;
         ELSIF W.IndAlta = 'S' THEN
            FOR X IN DECLALTA_Q LOOP   
               nNumAsegAlta         := NVL(nNumAsegAlta,0) + 1;
               nCodAseguradoAltas   := X.CodAsegurado;
               nIdEndosoProc        := nIdEndoso;
               
               IF nCodAseguradoAltas = 0 THEN
                  nCodAseguradoAltas := OC_ASEGURADO.INSERTAR_ASEGURADO(nCodCia, nCodEmpresa, X.TipoDocIdentificacion, X.NumDocIdentificacion);
               END IF;
               
               IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(X.TipoDocIdentificacion, X.NumDocIdentificacion) = 'N' THEN
                  BEGIN
                     SELECT CodPais, CodEstado, CodCiudad,
                            CodMunicipio
                       INTO cCodPaisRes, cCodProvRes, cCodDistRes,
                            cCodCorrRes
                       FROM APARTADO_POSTAL
                      WHERE TO_NUMBER(Codigo_Postal) = TO_NUMBER(X.CodigopostalAseg);
                  END;
                   
                  SELECT MIN(Codigo_Colonia)
                    INTO cCodColonia
                    FROM COLONIA
                   WHERE Codigo_Postal = X.Codigopostalaseg;
                   
                  OC_PERSONA_NATURAL_JURIDICA.INSERTAR_PERSONA(X.TipoDocIdentificacion, X.NumDocIdentificacion,
                                                               X.NombreAseg, X.ApellidoPaternoAseg, X.ApellidoMaternoAseg, NULL,
                                                               X.Sexoaseg, 'N', X.FechaNacimiento,
                                                               X.Direcaseg, NULL, NULL,
                                                               cCodPaisRes, cCodProvRes, cCodDistRes, 
                                                               cCodCorrRes, X.Codigopostalaseg, cCodColonia, 
                                                               NULL, NULL, NULL);
               END IF;
               IF NVL(nIdCotizacion,0) > 0 THEN
                  GT_TEMP_LISTADO_DECLARACIONES.GENERA_COBERTURAS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso, nCodAseguradoAltas, nIdCotizacion, nIDetCotizacion, cPlanCob, cIdTipoSeg, cCodMoneda, X.SumaAsegurada);
               ELSE
                  OC_ASEGURADO_CERTIFICADO.INSERTA (nCodCia, nIdPoliza, nIdetPol, nCodAseguradoAltas, nIdEndoso);
               END IF;
            END LOOP;
            
            IF NVL(nNumCotizacion,0) = 0 THEN
               SELECT MIN(Cod_Asegurado)
                 INTO nCodAseguradoIni   
                 FROM ASEGURADO_CERTIFICADO 
                WHERE CodCia     = nCodCia
                  AND IdPoliza   = nIdPoliza
                  AND IdetPol    = nIDetPol   
                  AND Estado     = 'EMI';
               OC_COBERT_ACT_ASEG.HEREDA_COB_ENDOSO_DECL(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAseguradoIni, cIdTipoSeg, cPlanCob, nIdEndoso);
            END IF;        
            
            FOR X IN ASEGCERT_Q LOOP
               OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, X.Cod_Asegurado);
               BEGIN
                  UPDATE COBERT_ACT_ASEG
                     SET IdEndoso      = nIdEndoso
                   WHERE CodCia        = nCodCia
                     AND IdPoliza      = nIdPoliza
                     AND IdetPol       = nIDetPol
                     AND Cod_Asegurado = X.Cod_Asegurado; 
               END;
               BEGIN
                  UPDATE ASISTENCIAS_ASEGURADO
                     SET StsAsistencia = 'EMITID',
                         FecSts        = TRUNC(SYSDATE),
                         IdEndoso      = nIdEndoso
                   WHERE CodCia        = nCodCia
                     AND IdPoliza      = nIdPoliza
                     AND IdetPol       = nIDetPol
                     AND Cod_Asegurado = X.Cod_Asegurado; 
               END;
            END LOOP;
         ELSIF W.IndBaja = 'S' THEN
            FOR X IN DECLBAJA_Q LOOP
               nNumAsegBaja := NVL(nNumAsegBaja,0) + 1;
               IF OC_ASEGURADO_CERTIFICADO.STATUS_ASEGURADO (nCodCia, nIdPoliza, nIDetPol, X.CodAsegurado) IN ('EMI') THEN
                  OC_ASEGURADO_CERTIFICADO.SUSPENDER(nCodCia, nIdPoliza, nIdetPol, X.CodAsegurado, dFecIniVig, '0001', nIdEndoso);
                  OC_COBERT_ACT_ASEG.SUSPENDER(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, X.CodAsegurado);
               END IF;
            END LOOP;
         ELSIF W.IndLog = 'S' THEN
            FOR X IN DECLLOG_Q LOOP
               nNumAsegLog := NVL(nNumAsegLog,0) + 1;
            END LOOP;
         END IF;
      END LOOP;
      --- AGREGA HISTORICO DE ASEGURADOS ACTIVOS
      FOR Z IN ASEGCERTHIST_Q LOOP
         nEdadAseg := OC_ASEGURADO.EDAD_ASEGURADO(nCodCia, nCodEmpresa, Z.Cod_Asegurado, dFecIniVig);
         GT_EAD_CONTROL_ASEGURADOS.INSERTAR(nCodCia, nCodEmpresa, nNumDeclaracion, nIdPoliza, nIDetPol, Z.Cod_Asegurado, nIdEndoso,
                                            Z.FecNacimiento, nEdadAseg, NULL, dFecIniVig, dFecFinVig, 
                                            Z.SumaAseg, Z.SumaAseg * nTasaCambio, Z.PrimaNeta, Z.PrimaNeta * nTasaCambio, Z.Estado);
         FOR J IN COBORIG_Q(Z.Cod_Asegurado) LOOP
            GT_EAD_CONTROL_ASEG_COBERT.INSERTAR(nCodCia, nCodEmpresa, nNumDeclaracion, nIdPoliza,
                                                nIDetPol, Z.Cod_Asegurado, nIdEndosoProc, J.CodCobert,
                                                J.SumaAseg_Local, J.SumaAseg_Moneda, J.Prima_Local, 
                                                J.Prima_Moneda, nTasaCambio, J.SalarioMensual, J.VecesSalario);
         END LOOP;
      END LOOP;
      cTextoEndoso := CHR(10)||CHR(10)||'**** R E S U M E N    D E C L A R A C I Ó N ****'                  ||CHR(10)||
                      '    Total Prima Neta Declarada: '                         ||NVL(nPrimaNetaTotal,0)   ||CHR(10)||
                      '    Asegurados Continúan: '                               ||NVL(nNumAsegContinuan,0) ||CHR(10)||
                      '    Asegurados Alta: '                                    ||NVL(nNumAsegAlta,0)      ||CHR(10)||
                      '    Asegurados Baja: '                                    ||NVL(nNumAsegBaja,0)      ||CHR(10)||
                      '    Asegurados Por Revisar: '                             ||NVL(nNumAsegLog,0)       ||CHR(10)||
                      '    Número Asegurados con Diferencia en Suma Asegurada '  ||NVL(nCuentaAcumDifSA,0)  ||CHR(10)||
                      '    Monto Acumulado Diferencias Sumas Asguradas: '        ||NVL(nAcumDifSumaAseg,0);
      OC_ENDOSO_TEXTO.AGREGA_TEXTO(nIdPoliza, nIdEndoso, cTextoEndoso);
      GT_TEMP_LISTADO_DECLARACIONES.ACTUALIZA_VALORES_ENDOSO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso);
      OC_ENDOSO.EMITIR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso, cTipoEndoso);
      --GT_TEMP_LISTADO_DECLARACIONES.CANCELA_FACTURAS (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso, dFecIniVig);
      GT_TEMP_LISTADO_DECLARACIONES.PRE_EMITE_DECLARACION (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso);
      GT_TEMP_LISTADO_DECLARACIONES.ACTUALIZA_VALORES_DET_POL_HIST(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso,
                                                                   nPrimaOrigLocalDetPol,nPrimaOrigMonedaDetPol,
                                                                   nSumaAsegOrigLcalDetPol,nSumaAsegOrigMonedaDetPol);
      GT_TEMP_LISTADO_DECLARACIONES.ACTUALIZA_VALORES_POL_HIST(nCodCia, nCodEmpresa, nIdPoliza);                                                                
      GT_TEMP_LISTADO_DECLARACIONES.ELIMINAR(nCodCia, nCodEmpresa, nIdPoliza);
      GT_TEMP_LISTADO_DECLARACIONES.ACTUALIZA_ENDOSO_HIST(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso);
   END IF;      
END APLICAR_ENDOSO_HIST;

PROCEDURE PRE_EMITE_DECLARACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER) IS
   nIdTransaccion TRANSACCION.IdTransaccion%TYPE;
BEGIN
   BEGIN
      SELECT DISTINCT IdTransaccion
        INTO nIdTransaccion
        FROM FACTURAS
       WHERE CodCia     = nCodCia
         AND IdPoliza   = nIdPoliza 
         AND IDetPol    = nIDetPol 
         AND IdEndoso   = nIdEndoso;
   EXCEPTION 
      WHEN OTHERS THEN 
         RAISE_APPLICATION_ERROR(-20225,'No es Posible Determinar la Transacción del Recibo Emitido Para el Endoso '||nIdEndoso);
   END;
  --
--   UPDATE COBERTURAS
--      SET StsCobertura = 'PRE'
--    WHERE CodCia     = nCodCia
--      AND CodEmpresa = nCodEmpresa
--      AND IdPoliza   = nIdPoliza 
--      AND IDetPol    = nIDetPol 
--      AND IdEndoso   = nIdEndoso
--      AND StsCobertura = 'EMI';
--      --
--   UPDATE COBERT_ACT_ASEG
--     SET StsCobertura = 'PRE'
--   WHERE CodCia     = nCodCia
--     AND CodEmpresa = nCodEmpresa
--     AND IdPoliza   = nIdPoliza 
--     AND IDetPol    = nIDetPol 
--     AND IdEndoso   = nIdEndoso
--     AND StsCobertura = 'EMI';
--
--   UPDATE ASISTENCIAS_DETALLE_POLIZA
--      SET StsAsistencia = 'PREEMI'
--    WHERE CodCia        = nCodCia
--      AND CodEmpresa    = nCodEmpresa
--      AND IdPoliza      = nIdPoliza
--      AND StsAsistencia = 'EMITID';
--

--   UPDATE COBERTURA_ASEG
--     SET StsCobertura = 'PRE'
--   WHERE CodCia         = nCodCia
--     AND CodEmpresa     = nCodEmpresa
--     AND IdPoliza       = nIdPoliza 
--     AND IDetPol        = nIDetPol 
--     AND IdEndoso       = nIdEndoso
--     AND StsCobertura   = 'EMI';
--
--   UPDATE ASEGURADO_CERTIFICADO
--      SET Estado = 'PRE'
--    WHERE CodCia   = nCodCia
--      AND IdPoliza = nIdPoliza
--      AND IDetPol  = nIDetPol 
--      AND IdEndoso = nIdEndoso
--      AND Estado   = 'EMI';
--
--   UPDATE ASISTENCIAS_ASEGURADO
--     SET STSASISTENCIA = 'PREEMI'        
--   WHERE CodCia         = nCodCia
--     AND CodEmpresa     = nCodEmpresa
--     AND IdPoliza       = nIdPoliza
--     AND IDetPol        = nIDetPol 
--     AND IdEndoso       = nIdEndoso
--     AND STSASISTENCIA  = 'EMITID';
----

--
   UPDATE FACTURAS
     SET StsFact            = 'PRE',
         IndFactElectronica = 'N'   -- CANCELA FACTURACION ELECTRONICA
   WHERE CodCia         = nCodCia
     AND IdPoliza       = nIdPoliza
     AND IDetPol        = nIDetPol 
     AND IdEndoso       = nIdEndoso
     AND IdTransaccion  = nIdTransaccion
     AND StsFact        = 'EMI';
--
   DELETE COMPROBANTES_DETALLE
    WHERE NumComprob = (SELECT NumComprob 
                           FROM COMPROBANTES_CONTABLES
                          WHERE CodCia         = nCodCia
                            AND NumTransaccion = nIdTransaccion);

   DELETE COMPROBANTES_CONTABLES
    WHERE CodCia         = nCodCia
      AND NumTransaccion = nIdTransaccion;
--    

  --
--
END PRE_EMITE_DECLARACION;                

PROCEDURE ACTUALIZA_VALORES_DET_POL_HIST(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER,
                                         nPrimaNetaLocalDetPol NUMBER, nPrimaNetaMonedaDetPol NUMBER, nSumaAsegLocalDetPol NUMBER, nSumaAsegMonedaDetPol NUMBER) IS
BEGIN    
   UPDATE DETALLE_POLIZA
      SET Prima_Local      = nPrimaNetaLocalDetPol,
          Prima_Moneda     = nPrimaNetaMonedaDetPol,
          Suma_Aseg_Local  = nSumaAsegLocalDetPol,
          Suma_Aseg_Moneda = nSumaAsegMonedaDetPol
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND IdPoliza   = nIdPoliza
      AND IDetPol    = nIDetPol;
END ACTUALIZA_VALORES_DET_POL_HIST;  

PROCEDURE ACTUALIZA_VALORES_POL_HIST(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) IS 
nPrimaLocalPoliza       POLIZAS.PrimaNeta_Local%TYPE;
nPrimaMonedaPoliza      POLIZAS.PrimaNeta_Moneda%TYPE;
nSumaAsegLocalPoliza    POLIZAS.SumaAseg_Local%TYPE;
nSumaAsegMonedaPoliza   POLIZAS.SumaAseg_Moneda %TYPE;
BEGIN
   SELECT NVL(SUM(Prima_Local),0), NVL(SUM(Prima_Moneda),0),
          NVL(SUM(Suma_Aseg_Local),0), NVL(SUM(Suma_Aseg_Moneda),0)
     INTO nPrimaLocalPoliza, nPrimaMonedaPoliza,
          nSumaAsegLocalPoliza, nSumaAsegMonedaPoliza
     FROM DETALLE_POLIZA
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND IdPoliza   = nIdPoliza;
      
   UPDATE POLIZAS
      SET PrimaNeta_Local  = nPrimaLocalPoliza,
          PrimaNeta_Moneda = nPrimaMonedaPoliza,
          SumaAseg_Local   = nSumaAsegLocalPoliza,
          SumaAseg_Moneda  = nSumaAsegMonedaPoliza
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND IdPoliza   = nIdPoliza;
END ACTUALIZA_VALORES_POL_HIST;

PROCEDURE ACTUALIZA_ENDOSO_HIST(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER) IS
BEGIN 
   UPDATE ENDOSOS
      SET Suma_Aseg_Local     = 0, 
          Suma_Aseg_Moneda    = 0, 
          Prima_Neta_Local    = 0, 
          Prima_Neta_Moneda   = 0
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND IdPoliza   = nIdPoliza
      AND IDetPol    = nIDetPol
      AND IdEndoso   = nIdEndoso;
END ACTUALIZA_ENDOSO_HIST;                    

END GT_TEMP_LISTADO_DECLARACIONES;