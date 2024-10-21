create or replace PACKAGE          GT_COTIZACIONES_CLAUSULAS IS

  PROCEDURE RECOTIZACION_CLAUSULAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdRecotizacion NUMBER);
  PROCEDURE CREAR_CLAUSULAS_POL(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdPoliza NUMBER);
  PROCEDURE ACTUALIZA_CLAUSULAS(ncodcia NUMBER, ncodempresa NUMBER, nOrigen NUMBER, nDestino NUMBER);
  FUNCTION EXISTE_CLAUSULA_COTI(nCodCia NUMBER, nIdCotizacion NUMBER, cCodClausula VARCHAR2) RETURN VARCHAR2; ---ARH 23/08/2024
  PROCEDURE ACTUALICOTI_RENOV_CLAUSU(nCodCia NUMBER, nIdCotizacion NUMBER, cCodClausula VARCHAR2, cIndicadorcoti VARCHAR2);  --ARH 23/08/2024
  PROCEDURE CREAR_TEXTORIESGOS_COTIZA(nCodCia NUMBER, cTiponegocio VARCHAR2, cLaboral VARCHAR2, cRies24_365 VARCHAR2, cTraslados VARCHAR2, nIdCotizacion NUMBER); --ARH 23/08/2024
  PROCEDURE COTIZACION_WEB_CLAUSULAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, cCodCobertWeb VARCHAR2, nMontoDiario NUMBER,
                                     nSumaAsegCobLocal NUMBER);--ARH 23/08/2024
  
END GT_COTIZACIONES_CLAUSULAS;
/
create or replace PACKAGE BODY          GT_COTIZACIONES_CLAUSULAS IS

    PROCEDURE RECOTIZACION_CLAUSULAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdRecotizacion NUMBER) IS
    CURSOR DET_Q IS
       SELECT CodCia, CodEmpresa, IdCotizacion, CodClausula
         FROM COTIZACIONES_CLAUSULAS
        WHERE CodCia       = nCodCia
          AND CodEmpresa   = nCodEmpresa
          AND IdCotizacion = nIdCotizacion;
    BEGIN
       FOR W IN DET_Q LOOP
          BEGIN
             INSERT INTO COTIZACIONES_CLAUSULAS
                    (CodCia, CodEmpresa, IdCotizacion, CodClausula)
             VALUES (nCodCia, nCodEmpresa, nIdReCotizacion, W.CodClausula);
          EXCEPTION
             WHEN DUP_VAL_ON_INDEX THEN
                RAISE_APPLICATION_ERROR(-20200,'Duplicada Cláusula de Cotización No. ' || nIdReCotizacion);
          END;
       END LOOP;
       ACTUALIZA_CLAUSULAS(nCodCia, NCodEmpresa, nIdCotizacion, nIdRecotizacion); 
    END RECOTIZACION_CLAUSULAS;

    PROCEDURE CREAR_CLAUSULAS_POL(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdPoliza NUMBER) IS

    nCodClausula    COTIZACIONES_CLAUSULAS.CodClausula%TYPE;
       
    CURSOR COTCLA_Q IS
       SELECT L.CodClausula TipoClausula, L.TextoClausula,
              --L.CodClausula, '0000' TipoClausula, L.TextoClausula,
              C.FecIniVigCot, C.FecFinVigCot
         FROM COTIZACIONES_CLAUSULAS L,
              COTIZACIONES C
        WHERE L.CodCia       = C.CodCia
          AND L.CodEmpresa   = C.CodEmpresa
          AND L.IdCotizacion = C.IdCotizacion
          AND C.CodCia       = nCodCia
          AND C.CodEmpresa   = nCodEmpresa
          AND C.IdCotizacion = nIdCotizacion;
    BEGIN
       nCodClausula := 0;
       FOR X IN COTCLA_Q LOOP
          nCodClausula := nCodClausula + 1;

          INSERT INTO CLAUSULAS_POLIZA
                (CodCia, IdPoliza, Cod_Clausula, Tipo_Clausula, Texto, Inicio_Vigencia, Fin_Vigencia, Estado)
          VALUES(nCodCia, nIdPoliza, nCodClausula, X.TipoClausula, X.TextoClausula, X.FecIniVigCot, X.FecFinVigCot, 'SOL');
       END LOOP;
    EXCEPTION
       WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20200,'Error al Crear las Coberturas '||SQLERRM);
    END CREAR_CLAUSULAS_POL;
    --
    PROCEDURE ACTUALIZA_CLAUSULAS(ncodcia NUMBER, ncodempresa NUMBER, nOrigen NUMBER, nDestino NUMBER) IS
         XVAR CLOB;
    BEGIN

        FOR ENT IN (SELECT C.TEXTOCLAUSULA  ,
                           C.CODCLAUSULA 
                      FROM COTIZACIONES_CLAUSULAS C
                     WHERE C.CODCIA      = NCODCIA
                       AND C.CODEMPRESA  = NCODEMPRESA
                       AND C.IDCOTIZACION= nOrigen) LOOP
            --
            XVAR := ENT.TEXTOCLAUSULA;
            --
            UPDATE COTIZACIONES_CLAUSULAS A     SET A.TEXTOCLAUSULA =  XVAR
             WHERE A.CODCIA      = NCODCIA
               AND A.CODEMPRESA  = NCODEMPRESA          
               AND A.IDCOTIZACION= nDestino
               AND A.CODCLAUSULA = ENT.CODCLAUSULA;
        --                       
        END LOOP;                   
        --
    END;
    --    
FUNCTION EXISTE_CLAUSULA_COTI(nCodCia NUMBER, nIdCotizacion NUMBER, cCodClausula VARCHAR2) RETURN VARCHAR2 IS
cExiste  VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM COTIZACIONES_CLAUSULAS
       WHERE CodCia       = nCodCia
         AND IdCotizacion = nIdCotizacion
         AND CodClausula = cCodClausula
         AND Indicadorcoti = 'S';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
 RETURN(cExiste);
END EXISTE_CLAUSULA_COTI;

PROCEDURE ACTUALICOTI_RENOV_CLAUSU(nCodCia NUMBER, nIdCotizacion NUMBER, cCodClausula VARCHAR2, cIndicadorcoti VARCHAR2) IS
BEGIN
   UPDATE COTIZACIONES_CLAUSULAS
      SET Indicadorcoti = cIndicadorcoti
    WHERE CodCia        = nCodCia
      AND IdCotizacion  = nIdCotizacion
      AND CodClausula   = cCodClausula;
      
END ACTUALICOTI_RENOV_CLAUSU;

PROCEDURE CREAR_TEXTORIESGOS_COTIZA(nCodCia NUMBER, cTiponegocio VARCHAR2, cLaboral VARCHAR2, cRies24_365 VARCHAR2, cTraslados VARCHAR2, nIdCotizacion NUMBER) IS
cTextElegibilidad   COMBINACION_RIESGOCUBIERTO.TextoElegibilidad%TYPE;
cTextRiesgoCubiert  COMBINACION_RIESGOCUBIERTO.TextoRiesgoCubierto%TYPE;
cExiste  VARCHAR2(1) := 'S';

BEGIN
   BEGIN
      SELECT TextoElegibilidad,TextoRiesgoCubierto
        INTO cTextElegibilidad,cTextRiesgoCubiert
        FROM COMBINACION_RIESGOCUBIERTO
       WHERE CodCia         = nCodCia
         AND Tipo_Negocio   = cTiponegocio
         AND Laboral_Riesg  = cLaboral
         AND Dia24365_Riesg = cRies24_365
         AND Traslado_Riesg = cTraslados;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'N';
   END;
   
   IF cExiste = 'S' THEN
     UPDATE COTIZACIONES
      SET DescElegibilidad  = cTextElegibilidad, 
          DescRiesgosCubiertos = cTextRiesgoCubiert
    WHERE CodCia        = nCodCia
      AND IdCotizacion  = nIdCotizacion;
   END IF;
END CREAR_TEXTORIESGOS_COTIZA;

PROCEDURE COTIZACION_WEB_CLAUSULAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, cCodCobertWeb VARCHAR2, nMontoDiario NUMBER,
                                   nSumaAsegCobLocal NUMBER) IS
cTEXTO	VARCHAR2(4000);
cCodClausula VARCHAR2(20);
cMonto       VARCHAR2(50);
cSumAseg     VARCHAR2(50);



  
BEGIN
    
   Select to_char(nMontoDiario, '$99,999.00') 
    INTO cMonto
    from dual;
     
    Select to_char(nSumaAsegCobLocal, '$99,999.00') 
    INTO cSumAseg
    from dual;
   

   IF cCodCobertWeb = 'RDH' THEN
       cTEXTO:= 'La cobertura de Indemnización Diaria por Hospitalización comenzará a operar a partir del tercer día de hospitalización y hasta por 90 días después del accidente siempre y cuando permanezca hospitalizado el asegurado, con pagos diarios de' || cMonto ||  ' m.n teniendo como límite la Suma Asegurada contratada de,' || cSumAseg || ' m.n.';
 
       cCodClausula := 'RDHA01';
      
   ELSIF cCodCobertWeb = 'INCTPA' THEN
   
       cTEXTO:= 'La cobertura de Incapacidad Temporal por Accidente comenzará a operar a partir del día 12 de incapacidad temporal causada por un accidente, donde se pagará en una sola exhibición la Suma Asegurada contratada de'  || cSumAseg || ' M.N.';
 
       cCodClausula := 'INTA01';
   END IF;
   
   BEGIN
               INSERT INTO COTIZACIONES_CLAUSULAS
                      (CodCia, CodEmpresa, IdCotizacion, CodClausula, Textoclausula)
               VALUES (nCodCia, nCodEmpresa, nIdCotizacion, cCodClausula, cTEXTO);
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX THEN
                    RAISE_APPLICATION_ERROR(-20200,'Duplicada Cláusula de Cotización No. ' || nIdCotizacion);
   END;
END COTIZACION_WEB_CLAUSULAS;

END GT_COTIZACIONES_CLAUSULAS;