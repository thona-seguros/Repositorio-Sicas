CREATE OR REPLACE PACKAGE          OC_FACTOR_DEPORTE_ESPECIAL IS
   PROCEDURE INSERTAR( nCodCia      FACTOR_DEPORTE_ESPECIAL.CodCia%TYPE
                     , nCodEmpresa  FACTOR_DEPORTE_ESPECIAL.CodEmpresa%TYPE
                     , cIdTipoSeg   FACTOR_DEPORTE_ESPECIAL.IdTipoSeg%TYPE
                     , cPlanCob     FACTOR_DEPORTE_ESPECIAL.PlanCob%TYPE
                     , cCodCobert   FACTOR_DEPORTE_ESPECIAL.CodCobert%TYPE
                     , cDeporte     FACTOR_DEPORTE_ESPECIAL.Deporte%TYPE
                     , cRiesgo      FACTOR_DEPORTE_ESPECIAL.Riesgo%TYPE
                     , nFactor      FACTOR_DEPORTE_ESPECIAL.Factor%TYPE );

   PROCEDURE ELIMINAR( nCodCia     FACTOR_DEPORTE_ESPECIAL.CodCia%TYPE
                     , nCodEmpresa FACTOR_DEPORTE_ESPECIAL.CodEmpresa%TYPE
                     , cIdTipoSeg  FACTOR_DEPORTE_ESPECIAL.IdTipoSeg%TYPE
                     , cPlanCob    FACTOR_DEPORTE_ESPECIAL.PlanCob%TYPE
                     , cCodCobert  FACTOR_DEPORTE_ESPECIAL.CodCobert%TYPE
                     , cDeporte    FACTOR_DEPORTE_ESPECIAL.Deporte%TYPE );

   FUNCTION SERVICIO_XML( nCodCia     FACTOR_DEPORTE_ESPECIAL.CodCia%TYPE
                        , nCodEmpresa FACTOR_DEPORTE_ESPECIAL.CodEmpresa%TYPE
                        , cIdTipoSeg  FACTOR_DEPORTE_ESPECIAL.IdTipoSeg%TYPE
                        , cPlanCob    FACTOR_DEPORTE_ESPECIAL.PlanCob%TYPE
                        , cCodCobert  FACTOR_DEPORTE_ESPECIAL.CodCobert%TYPE
                        , cDeporte    FACTOR_DEPORTE_ESPECIAL.Deporte%TYPE ) RETURN XMLTYPE;

   PROCEDURE REGISTRAR( nCodCia         COTIZACIONES.CodCia%TYPE
                      , nCodEmpresa     COTIZACIONES.CodEmpresa%TYPE
                      , nIdCotizacion   COTIZACIONES.IdCotizacion%TYPE
                      , xXMLDatosDepEsp XMLTYPE );

END OC_FACTOR_DEPORTE_ESPECIAL;

/

CREATE OR REPLACE PACKAGE BODY          OC_FACTOR_DEPORTE_ESPECIAL IS
   PROCEDURE INSERTAR( nCodCia      FACTOR_DEPORTE_ESPECIAL.CodCia%TYPE
                     , nCodEmpresa  FACTOR_DEPORTE_ESPECIAL.CodEmpresa%TYPE
                     , cIdTipoSeg   FACTOR_DEPORTE_ESPECIAL.IdTipoSeg%TYPE
                     , cPlanCob     FACTOR_DEPORTE_ESPECIAL.PlanCob%TYPE
                     , cCodCobert   FACTOR_DEPORTE_ESPECIAL.CodCobert%TYPE
                     , cDeporte     FACTOR_DEPORTE_ESPECIAL.Deporte%TYPE
                     , cRiesgo      FACTOR_DEPORTE_ESPECIAL.Riesgo%TYPE
                     , nFactor      FACTOR_DEPORTE_ESPECIAL.Factor%TYPE ) IS
   BEGIN
       INSERT INTO FACTOR_DEPORTE_ESPECIAL
          ( CodCia, CodEmpresa, IdTipoSeg, PlanCob, CodCobert, Deporte, Riesgo, Factor )
       VALUES ( nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, cCodCobert, cDeporte, cRiesgo, nFactor );
   END INSERTAR;

   PROCEDURE ELIMINAR( nCodCia     FACTOR_DEPORTE_ESPECIAL.CodCia%TYPE
                     , nCodEmpresa FACTOR_DEPORTE_ESPECIAL.CodEmpresa%TYPE
                     , cIdTipoSeg  FACTOR_DEPORTE_ESPECIAL.IdTipoSeg%TYPE
                     , cPlanCob    FACTOR_DEPORTE_ESPECIAL.PlanCob%TYPE
                     , cCodCobert  FACTOR_DEPORTE_ESPECIAL.CodCobert%TYPE
                     , cDeporte    FACTOR_DEPORTE_ESPECIAL.Deporte%TYPE ) IS
   BEGIN
       DELETE FACTOR_DEPORTE_ESPECIAL
       WHERE  CodCia     = nCodCia
         AND  CodEmpresa = nCodEmpresa
         AND  IdTipoSeg  = cIdTipoSeg
         AND  PlanCob    = cPlanCob
         AND  CodCobert  = cCodCobert
         AND  Deporte  = cDeporte;
   END ELIMINAR;

   FUNCTION SERVICIO_XML( nCodCia     FACTOR_DEPORTE_ESPECIAL.CodCia%TYPE
                        , nCodEmpresa FACTOR_DEPORTE_ESPECIAL.CodEmpresa%TYPE
                        , cIdTipoSeg  FACTOR_DEPORTE_ESPECIAL.IdTipoSeg%TYPE
                        , cPlanCob    FACTOR_DEPORTE_ESPECIAL.PlanCob%TYPE
                        , cCodCobert  FACTOR_DEPORTE_ESPECIAL.CodCobert%TYPE
                        , cDeporte    FACTOR_DEPORTE_ESPECIAL.Deporte%TYPE ) RETURN XMLTYPE IS
      xResultado  XMLTYPE;
   BEGIN
      SELECT XMLROOT(
             XMLELEMENT("DATA",
                        XMLELEMENT("IdTipoSeg", A.IdTipoSeg), 
                        XMLELEMENT("PlanCob"  , A.PlanCob),
                        XMLELEMENT("CodCobert", A.CodCobert), 
                        XMLAGG( XMLELEMENT("DEPORTEESPECIAL", XMLFOREST( A.Deporte "Deporte",
                                                                              A.Factor "Factor"
                                                                            )
                                          )
                              )
                       ), VERSION '1.0" encoding="UTF-8')
       INTO   xResultado
       FROM   FACTOR_DEPORTE_ESPECIAL A
       WHERE  A.CodCia     = nCodCia
         AND  A.CodEmpresa = nCodEmpresa
         AND  A.IdTipoSeg  = cIdTipoSeg
         AND  A.PlanCob    = cPlanCob
         AND  A.CodCobert  = cCodCobert
         AND  A.Deporte  = NVL( cDeporte, Deporte )
       GROUP BY A.CodCia, A.CodEmpresa, A.IdTipoSeg, A.PlanCob, A.CodCobert;
      --
      RETURN xResultado;
   EXCEPTION
   WHEN OTHERS THEN
      RETURN NULL;
   END SERVICIO_XML;

   PROCEDURE REGISTRAR( nCodCia         COTIZACIONES.CodCia%TYPE
                      , nCodEmpresa     COTIZACIONES.CodEmpresa%TYPE
                      , nIdCotizacion   COTIZACIONES.IdCotizacion%TYPE
                      , xXMLDatosDepEsp XMLTYPE ) IS
      cPrimerVez     VARCHAR2(1) := 'S';
      cTextoClausula LONG;
      cExisteFactor  VARCHAR2(1) := 'N';
     --
      CURSOR cRegistros IS
         WITH
         PRINCIPAL_DATA AS ( SELECT XT1.*
                             FROM   XMLTABLE('/DATA'
                                       PASSING xXMLDatosDepEsp
                                          COLUMNS 
                                             IDetCotizacion NUMBER(14)   PATH 'IDetCotizacion',
                                             CodSubGrupo    VARCHAR2(20) PATH 'CodSubGrupo',
                                             CodCobert      VARCHAR2(7)  PATH 'CodCobert',
                                             DepEsp         XMLTYPE      PATH 'DEPORTEESPECIAL' ) XT1
                           ),
         DEPESP_DATA   AS ( SELECT IDetCotizacion
                                  , CodSubGrupo
                                  , CodCobert
                                  , XT2.*
                             FROM   PRINCIPAL_DATA P
                                ,   XMLTABLE('/DEPORTEESPECIAL'
                                       PASSING P.DepEsp
                                          COLUMNS 
                                             Riesgo VARCHAR2(1) PATH 'Riesgo',
                                             Factor      NUMBER(9,6) PATH 'Factor',
											 Deporte     VARCHAR2(10) PATH 'Deporte',
                                             Clausulas   XMLTYPE     PATH 'DEPORTE' ) XT2
                           )
		SELECT * FROM DEPESP_DATA;
      --
   BEGIN
      FOR x IN cRegistros LOOP 
         --Registro el nuevo factor
         BEGIN
            SELECT 'S'
            INTO   cExisteFactor
            FROM   COTIZACIONES_DETALLE_FACTOR
            WHERE  CodCia         = nCodCia
              AND  CodEmpresa     = nCodEmpresa
              AND  IdCotizacion   = nIdCotizacion
              AND  IDetCotizacion = x.IDetCotizacion
              AND  TipoFactor     = 'DEPESP';
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
              cExisteFactor := 'N';
         END;
         --
         IF cExisteFactor = 'N' THEN
            INSERT INTO COTIZACIONES_DETALLE_FACTOR
                   (CodCia , CodEmpresa , IdCotizacion , IDetCotizacion  , TipoFactor, CodFactor  , Factor )
            VALUES (nCodCia, nCodEmpresa, nIdCotizacion, x.IDetCotizacion, 'DEPESP'  , x.Deporte, x.Factor );
         ELSE
            --
            UPDATE COTIZACIONES_DETALLE_FACTOR
            SET    CodFactor = x.Deporte
                 , Factor    = x.Factor
            WHERE  CodCia         = nCodCia
              AND  CodEmpresa     = nCodEmpresa
              AND  IdCotizacion   = nIdCotizacion
              AND  IDetCotizacion = x.IDetCotizacion
              AND  TipoFactor     = 'DEPESP';
         END IF;
         
         --
         --Actualizo el FactorAjuste en COTIZACIONES_DETALLE
         GT_COTIZACIONES_DETALLE.RECALCULA_FACTORAJUSTE( nCodCia, nCodEmpresa, nIdCotizacion, x.IDetCotizacion, x.CodSubGrupo );
         --           
      END LOOP;
      COMMIT;
   END REGISTRAR;

END OC_FACTOR_DEPORTE_ESPECIAL;
