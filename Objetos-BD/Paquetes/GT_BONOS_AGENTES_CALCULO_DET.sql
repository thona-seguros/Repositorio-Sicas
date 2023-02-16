CREATE OR REPLACE PACKAGE GT_BONOS_AGENTES_CALCULO_DET AS
   PROCEDURE INSERTAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER,
                      cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE, cCodConcepto VARCHAR2,
                      nMontoLocal NUMBER, MontoMoneda NUMBER);
   PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, 
                    cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE);                  
   PROCEDURE LIQUIDAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER,
                      cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE, cCodConcepto VARCHAR2);
   PROCEDURE CALCULO_DETALLE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER,
                      cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE, nMontoBono NUMBER);
   PROCEDURE ASIGNA_IDBONO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER,
                      cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE, nIdBono NUMBER);
END GT_BONOS_AGENTES_CALCULO_DET;
/

CREATE OR REPLACE PACKAGE BODY GT_BONOS_AGENTES_CALCULO_DET AS
   PROCEDURE INSERTAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER,
                      cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE, cCodConcepto VARCHAR2,
                      nMontoLocal NUMBER, MontoMoneda NUMBER) IS
   BEGIN
      INSERT INTO BONOS_AGENTES_CALCULO_DET (CodCia, CodEmpresa, IdBonoVentas, CodNivel, 
                                             CodAgente, FecIniCalcBono, FecFinCalcBono, CodConcepto, 
                                             MontoLocal, MontoMoneda, StsDetalleBono, FechaStatus)
                                     VALUES (nCodCia, nCodEmpresa, nIdBonoVentas, nCodNivel,
                                             cCodAgente, dFecIniCalcBono, dFecFinCalcBono, cCodConcepto,
                                             nMontoLocal, MontoMoneda, 'ACTIVO', TRUNC(SYSDATE));
   END INSERTAR;
   
   PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, 
                    cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE) IS
   BEGIN
      DELETE BONOS_AGENTES_FACTURAS
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdBonoVentas   = nIdBonoVentas
         AND CodNivel       = nCodNivel
         AND CodAgente      = cCodAgente
         AND FecIniCalcBono = dFecIniCalcBono
         AND FecFinCalcBono = dFecFinCalcBono;
   END ELIMINAR;
   
   PROCEDURE LIQUIDAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER,
                      cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE, cCodConcepto VARCHAR2) IS
   BEGIN
      UPDATE BONOS_AGENTES_CALCULO_DET
         SET StsDetalleBono = 'LIQUIDADO', 
             FechaStatus    = TRUNC(SYSDATE)
       WHERE CodCia           = nCodCia
         AND CodEmpresa       = nCodEmpresa
         AND IdBonoVentas     = nIdBonoVentas
         AND CodNivel         = nCodNivel
         AND CodAgente        = cCodAgente
         AND FecIniCalcBono   = dFecIniCalcBono
         AND FecFinCalcBono   = dFecFinCalcBono
         AND CodConcepto      = cCodConcepto
         AND StsDetalleBono   = 'ACTIVO';
   END LIQUIDAR;
   
   PROCEDURE CALCULO_DETALLE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER,
                      cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE, nMontoBono NUMBER) IS
      nMontoLocal    BONOS_AGENTES_CALCULO_DET.MontoLocal%TYPE;
      nMontoMoneda   BONOS_AGENTES_CALCULO_DET.MontoMoneda%TYPE;
      cCodTipoPlan   BONOS_AGENTES_CONFIG.CodTipoPlan%TYPE;
      
      CURSOR CPTO_Q IS
         SELECT DISTINCT CC.CodConcepto,CC.PorcCpto,CC.MtoCpto,CC.Prioridad,
                PNJ.Tipo_Persona,TA.CodTipo,C.IndTipoConcepto,NVL(C.Signo_Concepto,'-') Signo_Concepto
           FROM AGENTES A,TIPO_AGENTE TA,CONCEPTO_COMISION CC,
                PERSONA_NATURAL_JURIDICA PNJ,CATALOGO_DE_CONCEPTOS C,
                RAMO_CONCEPTO_COMISION RC,TIPOS_DE_SEGUROS TS
          WHERE A.CodCia                  = nCodCia
            AND A.CodEmpresa              = nCodEmpresa
            AND A.Cod_Agente              = cCodAgente
            AND A.CodCia                  = TA.CodCia 
            AND A.CodTipo                 = TA.CodTipo
            AND TA.CodTipo                = CC.CodTipo 
            AND A.Tipo_Doc_Identificacion = PNJ.Tipo_Doc_Identificacion
            AND A.Num_Doc_Identificacion  = PNJ.Num_Doc_Identificacion
            AND CC.CodCia                 = C.CodCia
            AND CC.CodConcepto            = C.CodConcepto
            AND RC.IdTipoSeg              = TS.IdTipoSeg
            AND CC.CodCia                 = RC.CodCia
            AND CC.CodTipo                = RC.CodTipo
            AND CC.CodConcepto            = RC.CodConcepto
            AND CC.Origen                 = RC.Origen
            AND CC.Origen                 = 'B'
            AND CC.Estado                 = 'ACTIVA'
            AND TS.CodTipoPlan            = cCodTipoPlan
          ORDER BY CC.Prioridad;
 
   BEGIN
      BEGIN
         SELECT CodTipoPlan
           INTO cCodTipoPlan
           FROM BONOS_AGENTES_CONFIG
          WHERE CodCia       = nCodCia
            AND CodEmpresa   = nCodEmpresa
            AND IdBonoVentas = nIdBonoVentas;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20100,'NO es Posible Determinar los Datos del Bono '||nIdBonoVentas||' en el Cálculo de Conceptos Para Pago, Por Favor Valide');
      END;
      FOR X IN CPTO_Q LOOP
         IF NVL(X.IndTipoConcepto,'PC') = 'PC' THEN
            nMontoLocal := (nMontoBono * X.PorcCpto) / 100;
         ELSIF X.IndTipoConcepto = 'MT' THEN
            nMontoLocal := X.MtoCpto;
         END IF;
         nMontoMoneda := nMontoLocal;
         IF X.Signo_Concepto != '+' THEN
            nMontoMoneda := nMontoMoneda * -1;
            nMontoLocal  := nMontoLocal * -1;
         END IF;
         GT_BONOS_AGENTES_CALCULO_DET.INSERTAR(nCodCia, nCodEmpresa, nIdBonoVentas, nCodNivel,
                                               cCodAgente, dFecIniCalcBono, dFecFinCalcBono, X.CodConcepto,
                                               nMontoLocal, nMontoMoneda);
      END LOOP;
   END CALCULO_DETALLE;
   
   PROCEDURE ASIGNA_IDBONO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER,
                      cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE, nIdBono NUMBER) IS
   BEGIN
      UPDATE BONOS_AGENTES_CALCULO_DET
         SET IdBono = nIdBono 
       WHERE CodCia           = nCodCia
         AND CodEmpresa       = nCodEmpresa
         AND IdBonoVentas     = nIdBonoVentas
         AND CodNivel         = nCodNivel
         AND CodAgente        = cCodAgente
         AND FecIniCalcBono   = dFecIniCalcBono
         AND FecFinCalcBono   = dFecFinCalcBono
         AND StsDetalleBono   = 'ACTIVO';
   END ASIGNA_IDBONO;
END GT_BONOS_AGENTES_CALCULO_DET;
