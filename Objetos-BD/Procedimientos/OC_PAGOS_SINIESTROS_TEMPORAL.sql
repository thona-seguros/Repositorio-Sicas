PROCEDURE OC_PAGOS_SINIESTROS_TEMPORAL IS
nIdTransaccion            TRANSACCION.IdTransaccion%TYPE := 0;
nIdSiniestro              SINIESTRO.IdSiniestro%TYPE := 0;
cTipoComp                 COMPROBANTES_CONTABLES.TipoComprob%TYPE;
nNumComprob               COMPROBANTES_CONTABLES.NumComprob%TYPE;
nCount                    NUMBER := 0;
cObservaciones            OBSERVACION_SINIESTRO.Descripcion%TYPE;

CURSOR COB_Q(curIdPoliza     SINIESTRO.IdPoliza%TYPE,
             curIdSiniestro  SINIESTRO.IdSiniestro%TYPE,
             curCodAsegurado SINIESTRO.Cod_Asegurado%TYPE) IS
   SELECT IdDetSin, IdTransaccion
     FROM COBERTURA_SINIESTRO_ASEG
    WHERE IdPoliza      = curIdPoliza
      AND IdSiniestro   = curIdSiniestro
      AND Cod_Asegurado = curCodAsegurado
   UNION
   SELECT IdDetSin, IdTransaccion
     FROM COBERTURA_SINIESTRO
    WHERE IdPoliza      = curIdPoliza
      AND IdSiniestro   = curIdSiniestro;

CURSOR APR_Q(curIdPoliza     SINIESTRO.IdPoliza%TYPE,
             curIdSiniestro  SINIESTRO.IdSiniestro%TYPE,
             curCodAsegurado SINIESTRO.Cod_Asegurado%TYPE) IS
   SELECT IdDetSin, Num_Aprobacion, IdTransaccion 
     FROM APROBACION_ASEG
    WHERE IdPoliza      = curIdPoliza
      AND IdSiniestro   = curIdSiniestro
      AND Cod_Asegurado = curCodAsegurado
--      AND StsAprobacion  = 'EMI'
   UNION
   SELECT IdDetSin, Num_Aprobacion, IdTransaccion 
     FROM APROBACIONES
    WHERE IdPoliza      = curIdPoliza
      AND IdSiniestro   = curIdSiniestro;
--      AND StsAprobacion = 'EMI';

CURSOR SIN_Q IS
   SELECT SI.CodCia, SI.CodEmpresa, SI.IdSiniestro, SI.IdPoliza,
          SI.NumSiniRef NumReferencia, TO_DATE('31-03-2015','dd-mm-yyyy') Fecha,
          SI.Sts_Siniestro Estado, SI.IDetPol, SI.Cod_Asegurado
     FROM SINIESTRO SI
    WHERE SI.IdSiniestro IN (12271);
    --WHERE SI.IdSiniestro IN (12294,12285,12281);
    --WHERE SI.IdSiniestro IN (12294,12285,12281,12302,12291,12286,12290,12224,12234,12232,12269,12252,12233,12260,12288,
    --                         12284,12297,12283,12298,12239,12230,12227,12251,12259,12226,12262,12223,12268,12246,12263,
    --                         12270,12264,12299,12279,12257,12228,12274,12241,12276,12236,12238,12275,12296,12242,12301,
    --                         12255,12272,12303,12289,12253,12250,12292,12265,12287,12300,12295,12244,12267,12277,12229,
    --                         12304,12257,12258,12307,12243,12261,12293,12231,12278,12256,12266,12237,12240,12254,12235,
    --                         12280,12282,12225);
    
BEGIN
   FOR SIN IN SIN_Q LOOP -- SINIESTROS
     nCount := nCount + 1;
     nIdSiniestro := SIN.IdSiniestro;
     DBMS_OUTPUT.PUT_LINE('Se Procesa el Siniestro: '||nIdSiniestro);
     
     FOR COB IN COB_Q(SIN.IdPoliza, SIN.IdSiniestro, SIN.Cod_Asegurado) LOOP -- COBERTURAS
       nIdTransaccion := COB.IdTransaccion;
       cTipoComp    := 'C';
       nNumComprob  := 0;
       IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(SIN.CodCia, SIN.IdPoliza, SIN.IDetPol, SIN.Cod_Asegurado) = 'N' THEN
          BEGIN
            UPDATE COBERTURA_SINIESTRO
               SET FecRes = SIN.Fecha
             WHERE IdPoliza = SIN.IdPoliza
               AND IdSiniestro = SIN.IdSiniestro;
          EXCEPTION
            WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR(-20225,'Actualizar la Cobertura: '|| nIdTransaccion || ' ' || SQLERRM);
          END;
       ELSE 
          BEGIN
            UPDATE COBERTURA_SINIESTRO_ASEG
               SET FecRes = SIN.Fecha
             WHERE IdPoliza = SIN.IdPoliza
               AND IdSiniestro = SIN.IdSiniestro
               AND Cod_Asegurado = SIN.Cod_Asegurado;
          EXCEPTION
            WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR(-20225,'Actualizar la Cobertura: '|| nIdTransaccion || ' ' || SQLERRM);
          END;
       END IF;
         
       BEGIN
         UPDATE TRANSACCION
            SET FechaTransaccion = SIN.Fecha
          WHERE IdTransaccion = nIdTransaccion;
       EXCEPTION
         WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20225,'Actualizar la Transacción: '|| nIdTransaccion || ' ' || SQLERRM);
       END;
       --
       BEGIN
         SELECT TipoComprob, NumComprob
           INTO cTipoComp, nNumComprob
           FROM COMPROBANTES_CONTABLES
          WHERE NumTransaccion = nIdTransaccion;
       EXCEPTION
         WHEN OTHERS THEN
           cTipoComp := 'C';
           nNumComprob := 0;
       END;
       --
       /*BEGIN
         UPDATE COMPROBANTES_DETALLE
            SET FecDetalle = SIN.Fecha
          WHERE NumComprob = nNumComprob;
       EXCEPTION
         WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20225,'Eliminar los Comprobantes Detalle de la Transaccion: '|| nIdTransaccion || ' ' || SQLERRM);
       END;*/
       --
       BEGIN
         DELETE FROM COMPROBANTES_DETALLE
          WHERE NumComprob = nNumComprob;
       EXCEPTION
         WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20225,'Eliminar los Comprobantes Detalle de la Transaccion: '|| nIdTransaccion || ' ' || SQLERRM);
       END;
       --
       BEGIN
         DELETE FROM COMPROBANTES_CONTABLES
          WHERE NumComprob = nNumComprob;
       EXCEPTION
         WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20225,'Eliminar los Comprobantes Contables de la Transaccion: '|| nIdTransaccion || ' ' || SQLERRM);
       END;
       --
       /*BEGIN
         UPDATE COMPROBANTES_CONTABLES
            SET FecComprob = SIN.Fecha,
			          FecSts     = SIN.Fecha
          WHERE NumTransaccion = nIdTransaccion;
       EXCEPTION
         WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20225,'Eliminar los Comprobantes Contables de la Transaccion: '|| nIdTransaccion || ' ' || SQLERRM);
       END;
       --
       OC_COMPROBANTES_CONTABLES.RECONTABILIZAR(SIN.CodCia, nIdTransaccion, cTipoComp, nNumComprob);*/
       --
     END LOOP; -- COBERTURAS

     FOR APR IN APR_Q(SIN.IdPoliza, SIN.IdSiniestro, SIN.Cod_Asegurado) LOOP -- APROBACIONES
       nIdTransaccion := APR.IdTransaccion;
       cTipoComp    := 'C';
       nNumComprob  := 0;
       IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(SIN.CodCia, SIN.IdPoliza, SIN.IDetPol, SIN.Cod_Asegurado) = 'N' THEN
          IF nIdTransaccion IS NULL THEN
             OC_APROBACIONES.PAGAR(SIN.CodCia, SIN.CodEmpresa, APR.Num_Aprobacion, SIN.IdSiniestro,
                                   SIN.IdPoliza, APR.IdDetSin);
             BEGIN
               SELECT IdTransaccion
                 INTO nIdTransaccion
                 FROM APROBACIONES
                WHERE IdPoliza       = SIN.IdPoliza
                  AND IdSiniestro    = SIN.IdSiniestro
                  AND IdDetSin       = APR.IdDetSin
                  AND Num_Aprobacion = APR.Num_Aprobacion;
             EXCEPTION WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20225,'Obtener la Aprobación del Siniestro: '|| SIN.IdSiniestro || ' ' || SQLERRM);
             END;
          END IF;
       ELSE 
          IF nIdTransaccion IS NULL THEN
             OC_APROBACION_ASEG.PAGAR(SIN.CodCia, SIN.CodEmpresa, APR.Num_Aprobacion, 
                                      SIN.IdSiniestro, SIN.IdPoliza, SIN.Cod_Asegurado,
                                      APR.IdDetSin);
             BEGIN
               SELECT IdTransaccion
                 INTO nIdTransaccion
                 FROM APROBACION_ASEG
                WHERE IdPoliza       = SIN.IdPoliza
                  AND IdSiniestro    = SIN.IdSiniestro
                  AND IdDetSin       = APR.IdDetSin
                  AND Cod_Asegurado  = SIN.Cod_Asegurado
                  AND Num_Aprobacion = APR.Num_Aprobacion;
             EXCEPTION WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20225,'Obtener la Aprobación Aseg del Siniestro: '|| SIN.IdSiniestro || ' ' || SQLERRM);
             END;
          END IF;
       END IF;
         
       BEGIN
         UPDATE TRANSACCION
            SET FechaTransaccion = SIN.Fecha
          WHERE IdTransaccion = nIdTransaccion;
       EXCEPTION
         WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20225,'Actualizar la Transacción: '|| nIdTransaccion || ' ' || SQLERRM);
       END;
       --
       BEGIN
         SELECT TipoComprob, NumComprob
           INTO cTipoComp, nNumComprob
           FROM COMPROBANTES_CONTABLES
          WHERE NumTransaccion = nIdTransaccion;
       EXCEPTION
         WHEN OTHERS THEN
           cTipoComp := 'C';
           nNumComprob := 0;
       END;
       --
       /*BEGIN
         UPDATE COMPROBANTES_DETALLE
            SET FecDetalle = SIN.Fecha
          WHERE NumComprob = nNumComprob;
       EXCEPTION
         WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20225,'Eliminar los Comprobantes Detalle de la Transaccion: '|| nIdTransaccion || ' ' || SQLERRM);
       END;*/
       --
       BEGIN
         DELETE COMPROBANTES_DETALLE
          WHERE NumComprob = nNumComprob;
       EXCEPTION
         WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20225,'Eliminar los Comprobantes Detalle de la Transaccion: '|| nIdTransaccion || ' ' || SQLERRM);
       END;
       --
       /*BEGIN
         UPDATE COMPROBANTES_CONTABLES
            SET FecComprob = SIN.Fecha,
			          FecSts     = SIN.Fecha
          WHERE NumComprob = nNumComprob;
       EXCEPTION
         WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20225,'Eliminar los Comprobantes Contables de la Transaccion: '|| nIdTransaccion || ' ' || SQLERRM);
       END;*/
       --
       BEGIN
         DELETE COMPROBANTES_CONTABLES
          WHERE NumComprob = nNumComprob;
       EXCEPTION
         WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20225,'Eliminar los Comprobantes Contables de la Transaccion: '|| nIdTransaccion || ' ' || SQLERRM);
       END;
       --
       --OC_COMPROBANTES_CONTABLES.RECONTABILIZAR(SIN.CodCia, nIdTransaccion, cTipoComp, nNumComprob);
       --
     END LOOP; -- APROBACIONES
     --
     BEGIN
       UPDATE SINIESTRO
          SET FecSts = SIN.Fecha,
              Fec_Notificacion = SIN.Fecha
        WHERE IdSiniestro = SIN.IdSiniestro;
     EXCEPTION
       WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20225,'Actualizar Siniestro No.: '|| SIN.IdSiniestro || ' ' || SQLERRM);
     END;
     --
     cObservaciones := 'Se cambia la Fecha de la Emisión de la Reserva y Pago, Se elimina la contabilidad para no afectar a Mizar, por solicitud de Jacquelinne Escobar y autorizado por Oscar Valdivia.';
     --
     OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(SIN.IdSiniestro, SIN.IdPoliza, cObservaciones);
     --
     IF nCount = 100 THEN
        Commit;
        nCount := 0;
     END IF;
   END LOOP; -- SINIESTROS
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Siniestro: '||nIdSiniestro||' Error en '||SQLERRM);
END OC_PAGOS_SINIESTROS_TEMPORAL;
