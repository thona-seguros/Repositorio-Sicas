CREATE OR REPLACE PACKAGE OC_RESERVAS_TECNICAS AS
PROCEDURE GENERAR_RESERVA(nCodCia NUMBER, cCodReserva VARCHAR2, cTipoReserva VARCHAR2,
                          dFecIniRva DATE, dFecFinRva DATE, dFecValuacion DATE);
FUNCTION NUMERO_RESERVA RETURN NUMBER;
PROCEDURE ANULAR(nIdReserva NUMBER);
PROCEDURE INSERTA_RESERVA(nIdReserva NUMBER, nCodCia NUMBER, cCodReserva VARCHAR2, cTipoReserva VARCHAR2, 
                          dFecIniRva DATE, dFecFinRva DATE, dFecValuacion DATE);
PROCEDURE CONTABILIZAR(nIdReserva NUMBER);
PROCEDURE ELIMINAR_CONTABILIDAD(nIdReserva NUMBER);
PROCEDURE REVERSAR_CONTABILIDAD(nIdReserva NUMBER);
END OC_RESERVAS_TECNICAS;
 
 

 
 
/

CREATE OR REPLACE PACKAGE BODY OC_RESERVAS_TECNICAS AS

PROCEDURE GENERAR_RESERVA(nCodCia NUMBER, cCodReserva VARCHAR2, cTipoReserva VARCHAR2, 
                          dFecIniRva DATE, dFecFinRva DATE, dFecValuacion DATE) IS 

nIdReserva           RESERVAS_TECNICAS.IdReserva%TYPE;
cGeneroRva           VARCHAR2(1);

CURSOR RVAS_Q IS
   SELECT ParamFactorRva, IndConfigGastos, IndReservasTemp, IndRvaMinima
     FROM CONFIG_RESERVAS
    WHERE CodCia     = nCodCia
      AND CodReserva = cCodReserva
      AND StsReserva = 'ACT';

BEGIN
   cGeneroRva := 'N';
   FOR X IN RVAS_Q LOOP
      cGeneroRva := 'S';
      IF X.IndReservasTemp = 'N' AND cTipoReserva = 'TMP' THEN
         RAISE_APPLICATION_ERROR(-20100,'Configuración de Reserva '||cCodReserva||' NO Permite Generar Reservas Temporales');
      END IF;

      nIdReserva := OC_RESERVAS_TECNICAS.NUMERO_RESERVA;

      OC_RESERVAS_TECNICAS.INSERTA_RESERVA(nIdReserva, nCodCia, cCodReserva, cTipoReserva, 
                                           dFecIniRva, dFecFinRva, dFecValuacion);

      -- Se maneja como Excepción el Commit para permitir que Varios Usuarios o Procesos Generen Reservas al mismo tiempo
      COMMIT;
      
      -- Reservas de Accidentes y Enfermedades
      IF OC_CONFIG_RESERVAS.INDICADORES(nCodCia, cCodReserva, 'AE') = 'S' OR
         OC_CONFIG_RESERVAS.INDICADORES(nCodCia, cCodReserva, 'FE') = 'S' THEN
         BEGIN
            OC_RESERVAS_TECNICAS_ACCYENF.GENERAR_RESERVA(nIdReserva, nCodCia, cCodReserva, dFecIniRva, 
                                                         dFecFinRva, dFecValuacion, X.ParamFactorRva);
         EXCEPTION
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20100,'Error en Generación de Reserva: '|| cCodReserva||' '||SQLERRM);
         END;
      -- Se unifico la reserva con la de Accidentes personales.
      /*SIF OC_CONFIG_RESERVAS.INDICADORES(nCodCia, cCodReserva, 'FE') = 'S' THEN
         BEGIN
            OC_RESERVAS_TECNICAS_FACT_VIDA.GENERAR_RESERVA(nIdReserva, nCodCia, cCodReserva, dFecIniRva, 
                                                    dFecFinRva, dFecValuacion, X.ParamFactorRva);
         EXCEPTION
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20100,'Error en Generación de Reserva: '|| cCodReserva||' '||SQLERRM);
         END;*/
      ELSIF OC_CONFIG_RESERVAS.INDICADORES(nCodCia, cCodReserva, 'IB') = 'S' THEN
         BEGIN
            OC_RESERVAS_TECNICAS_IBNR.GENERAR_RESERVA(nIdReserva, nCodCia, cCodReserva, dFecIniRva, 
                                                      dFecFinRva, dFecValuacion, X.ParamFactorRva);
         EXCEPTION
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20100,'Error en Generación de Reserva: '|| cCodReserva||' '||SQLERRM);
         END;
      ELSE
         BEGIN
            OC_RESERVAS_TECNICAS_REC.GENERAR_RESERVA(nIdReserva, nCodCia, cCodReserva, dFecIniRva, 
                                                     dFecFinRva, dFecValuacion, X.ParamFactorRva);
         EXCEPTION
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20100,'Error en Generación de Reserva: '|| cCodReserva||' '||SQLERRM);
         END;
      END IF;
   END LOOP;
   IF NVL(cGeneroRva,'N') = 'N' THEN
      RAISE_APPLICATION_ERROR(-20100,'NO Generó Reserva: '|| cCodReserva||'. Revise si la Configuración está Activa.');
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      DELETE RESERVAS_TECNICAS
       WHERE IdReserva = nIdReserva;
      COMMIT;
      RAISE_APPLICATION_ERROR(-20100,'Error en Generación de Reserva: '|| cCodReserva||' '||SQLERRM);
END GENERAR_RESERVA;

FUNCTION NUMERO_RESERVA RETURN NUMBER IS
nIdReserva    RESERVAS_TECNICAS.IdReserva%TYPE;
cExiste       VARCHAR2(1);
BEGIN
   
      /**
   SELECT NVL(MAX(IdReserva),0)+1
     INTO nIdReserva
     FROM RESERVAS_TECNICAS; **/
   /**  cambio a sequencia XDS**/  
      SELECT SQ_RESERVA_TEC.NEXTVAL     
        INTO nIdReserva
        FROM DUAL;
   
   
   
END NUMERO_RESERVA;

PROCEDURE ANULAR(nIdReserva NUMBER) IS
cStsReserva    RESERVAS_TECNICAS.StsReserva%TYPE;
BEGIN
   BEGIN
      SELECT StsReserva
        INTO cStsReserva
        FROM RESERVAS_TECNICAS
       WHERE IdReserva = nIdReserva;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'NO Existe la Reserva: '|| TO_CHAR(nIdReserva));
   END;
   IF cStsReserva != 'ACT' THEN
      RAISE_APPLICATION_ERROR(-20100,'NO puede Anular la Reserva: '|| TO_CHAR(nIdReserva)||' con Status '||cStsReserva);
   ELSE
      BEGIN
         UPDATE RESERVAS_TECNICAS
            SET StsReserva = 'ANU'
          WHERE IdReserva = nIdReserva;
      END;
   END IF;
END ANULAR;

PROCEDURE INSERTA_RESERVA(nIdReserva NUMBER, nCodCia NUMBER, cCodReserva VARCHAR2, cTipoReserva VARCHAR2, 
                          dFecIniRva DATE, dFecFinRva DATE, dFecValuacion DATE) IS
nIdTransaccion   RESERVAS_TECNICAS.IdTransaccion%TYPE;
nCodEmpresa      CONFIG_RESERVAS_TIPOSEG.CodEmpresa%TYPE;
BEGIN
   SELECT MIN(CodEmpresa)
     INTO nCodEmpresa
     FROM CONFIG_RESERVAS_TIPOSEG
    WHERE CodCia     = nCodCia
      AND CodReserva = cCodReserva;

   nIdTransaccion := OC_TRANSACCION.CREA(nCodCia,  nCodEmpresa, 9, 'GEN');

   OC_DETALLE_TRANSACCION.CREA (nIdTransaccion, nCodCia, nCodEmpresa, 9, 'GEN', 'RESERVAS_TECNICAS',
                                                                                  nIdReserva, NULL, NULL, NULL, 0);

   INSERT INTO RESERVAS_TECNICAS
          (IdReserva, CodCia, CodReserva, TipoReserva, FecIniRva, FecFinRva,
           FecProceso, StsReserva, FecSts, IdTransaccion, IndContabilizada,
           CodUsuario, FecGenerada)
   VALUES (nIdReserva, nCodCia, cCodReserva, cTipoReserva, dFecIniRva, dFecFinRva,
           dFecValuacion, 'ACT', SYSDATE, nIdTransaccion, 'N',
           USER, SYSDATE);
END INSERTA_RESERVA;

PROCEDURE CONTABILIZAR(nIdReserva NUMBER) IS
nMtoCpto         RESERVAS_TECNICAS_CONTAB.MtoCptoRva%TYPE;
cCodReserva      RESERVAS_TECNICAS.CodReserva%TYPE;
nIdTransaccion   RESERVAS_TECNICAS.IdTransaccion%TYPE;
dFecProceso      RESERVAS_TECNICAS.FecProceso%TYPE;
dFecIniRva       RESERVAS_TECNICAS.FecIniRva%TYPE;
dFecFinRva       RESERVAS_TECNICAS.FecFinRva%TYPE;
nCodCia          RESERVAS_TECNICAS.CodCia%TYPE;
cDescCptoRva     RESERVAS_TECNICAS_CONTAB.DescCptoRva%TYPE;
cDescReserva     CONFIG_RESERVAS.DescReserva%TYPE;

CURSOR CONTA_Q IS
   SELECT CodCptoResRva, CodCptoRva, TipoContab, TipoPlazo, ValuacionPlazo, ValCortoPlazo
     FROM CONFIG_RESERVAS_CONTAB
    WHERE CodReserva  = cCodReserva
    ORDER BY CodCptoResRva, CodCptoRva;
BEGIN
   BEGIN
      SELECT RT.CodCia, RT.CodReserva, CF.DescReserva, RT.IdTransaccion,
             RT.FecProceso, RT.FecIniRva, RT.FecFinRva
        INTO nCodCia, cCodReserva, cDescReserva, nIdTransaccion,
             dFecProceso, dFecIniRva, dFecFinRva
        FROM RESERVAS_TECNICAS RT, CONFIG_RESERVAS CF
       WHERE CF.CodCia     = RT.CodCia
         AND CF.CodReserva = RT.CodReserva
         AND RT.IdReserva  = nIdReserva;
   END;
   FOR X IN CONTA_Q LOOP
      IF X.TipoContab IN ('BA','AD') THEN
         nMtoCpto := OC_RESERVAS_TECNICAS_RES.MONTO_BASICA_ADICIONAL(nIdReserva, X.CodCptoResRva, X.TipoContab);
      ELSE
         nMtoCpto := OC_RESERVAS_TECNICAS_RES.MONTO_RESUMEN(nIdReserva, X.CodCptoResRva);
      END IF;
      IF nMtoCpto != 0 THEN
         cDescCptoRva := 'Contabilidad de Reservas '||cCodReserva||'-'||TRIM(INITCAP(cDescReserva))||
                         ', Transacción No. '||nIdTransaccion||
                         ' del '||TO_CHAR(dFecIniRva,'DD/MM/YYYY')||' al ' ||
                         TO_CHAR(dFecFinRva,'DD/MM/YYYY') || ' Valuada al ' ||
                         TO_CHAR(dFecProceso,'DD/MM/YYYY');
         OC_RESERVAS_TECNICAS_CONTAB.INSERTAR(nIdReserva, X.CodCptoResRva, X.CodCptoRva,
                                              nMtoCpto, cDescCptoRva);
      END IF;
   END LOOP;
   OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');
   BEGIN
      UPDATE RESERVAS_TECNICAS
         SET IndContabilizada = 'S',
             StsReserva       = 'CON',
             FecSts           = SYSDATE
       WHERE IdReserva = nIdReserva;
   END;
END CONTABILIZAR;

PROCEDURE ELIMINAR_CONTABILIDAD(nIdReserva NUMBER) IS
nIdTransaccion   RESERVAS_TECNICAS.IdTransaccion%TYPE;
nCodCia          RESERVAS_TECNICAS.CodCia%TYPE;
cEliminoComprob  VARCHAR2(1);
CURSOR COMP_Q IS
   SELECT CodCia, NumComprob, NumComprobSC 
     FROM COMPROBANTES_CONTABLES
    WHERE CodCia         = nCodCia
      AND NumTransaccion = nIdTransaccion;
BEGIN
   BEGIN
      SELECT CodCia, IdTransaccion
        INTO nCodCia, nIdTransaccion
        FROM RESERVAS_TECNICAS
       WHERE IdReserva  = nIdReserva;
   END;

   FOR X IN COMP_Q LOOP
      IF X.NumComprobSC IS NULL THEN
         OC_COMPROBANTES_DETALLE.ELIMINA_DETALLE(nCodCia, X.NumComprob);
         OC_COMPROBANTES_CONTABLES.ELIMINA_COMPROBANTE(nCodCia, X.NumComprob);
         cEliminoComprob := 'S';
      ELSE
         cEliminoComprob := 'N';
      END IF;
   END LOOP;

   IF cEliminoComprob = 'S' THEN
      OC_RESERVAS_TECNICAS_CONTAB.ELIMINAR(nIdReserva);
   
      UPDATE RESERVAS_TECNICAS
         SET StsReserva = 'ACT',
             FecSts     = TRUNC(SYSDATE)
       WHERE IdReserva  = nIdReserva;
   ELSE
      RAISE_APPLICATION_ERROR(-20100,'NO puede Eliminar Comprobantes ya Trasladados al Sistema Central');
   END IF;
END ELIMINAR_CONTABILIDAD;

PROCEDURE REVERSAR_CONTABILIDAD(nIdReserva NUMBER) IS
nIdTransaccion   RESERVAS_TECNICAS.IdTransaccion%TYPE;
nCodCia          RESERVAS_TECNICAS.CodCia%TYPE;
cEliminoComprob  VARCHAR2(1);
cTipoCompRev     PROCESOS_CONTABLES.TipoCompRev%TYPE;
cCodProcesoCont  SUB_PROCESO.CodProcesoCont%TYPE;

CURSOR COMP_Q IS
   SELECT MAX(CodCia) CodCia, MAX(NumComprob) NumComprob
     FROM COMPROBANTES_CONTABLES
    WHERE CodCia         = nCodCia
      AND NumTransaccion = nIdTransaccion;
BEGIN
   BEGIN
      SELECT CodCia, IdTransaccion
        INTO nCodCia, nIdTransaccion
        FROM RESERVAS_TECNICAS
       WHERE IdReserva  = nIdReserva;
   END;
   cCodProcesoCont := OC_SUB_PROCESO.PROCESO_CONTABLE(9, 'GEN');
   cTipoCompRev    := OC_PROCESOS_CONTABLES.TIPO_COMPROBANTE(nCodCia, cCodProcesoCont, 'R');

   FOR X IN COMP_Q LOOP
      OC_COMPROBANTES_CONTABLES.REVERSA_COMPROBANTE(X.CodCia, X.NumComprob, cTipoCompRev);
   END LOOP;

   OC_RESERVAS_TECNICAS_CONTAB.ELIMINAR(nIdReserva);

   UPDATE RESERVAS_TECNICAS
      SET StsReserva = 'ACT',
          FecSts     = TRUNC(SYSDATE)
    WHERE IdReserva  = nIdReserva;
END REVERSAR_CONTABILIDAD;

END OC_RESERVAS_TECNICAS;
