CREATE OR REPLACE PACKAGE          GT_COTIZACIONES_CLAUSULAS IS

  PROCEDURE RECOTIZACION_CLAUSULAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdRecotizacion NUMBER);
  PROCEDURE CREAR_CLAUSULAS_POL(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIdPoliza NUMBER);
  PROCEDURE ACTUALIZA_CLAUSULAS(ncodcia NUMBER, ncodempresa NUMBER, nOrigen NUMBER, nDestino NUMBER);
  
END GT_COTIZACIONES_CLAUSULAS;
/

CREATE OR REPLACE PACKAGE BODY          GT_COTIZACIONES_CLAUSULAS IS

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
END GT_COTIZACIONES_CLAUSULAS;
