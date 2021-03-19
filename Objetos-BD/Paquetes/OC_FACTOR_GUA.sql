create or replace PACKAGE          OC_FACTOR_GUA IS
   PROCEDURE INSERTAR( nCodCia     FACTOR_GUA.CodCia%TYPE
                     , nCodEmpresa FACTOR_GUA.CodEmpresa%TYPE
                     , cIdTipoSeg  FACTOR_GUA.IdTipoSeg%TYPE
                     , cPlanCob    FACTOR_GUA.PlanCob%TYPE
                     , cCodCobert  FACTOR_GUA.CodCobert%TYPE
                     , cNivel      FACTOR_GUA.Nivel%TYPE
                     , nFactor     FACTOR_GUA.Factor%TYPE );

   PROCEDURE ELIMINAR( nCodCia     FACTOR_GUA.CodCia%TYPE
                     , nCodEmpresa FACTOR_GUA.CodEmpresa%TYPE
                     , cIdTipoSeg  FACTOR_GUA.IdTipoSeg%TYPE
                     , cPlanCob    FACTOR_GUA.PlanCob%TYPE
                     , cCodCobert  FACTOR_GUA.CodCobert%TYPE
                     , cNivel      FACTOR_GUA.Nivel%TYPE );

   FUNCTION SERVICIO_XML( nCodCia      FACTOR_GUA.CodCia%TYPE
                        , nCodEmpresa  FACTOR_GUA.CodEmpresa%TYPE
                        , cIdTipoSeg   FACTOR_GUA.IdTipoSeg%TYPE
                        , cPlanCob     FACTOR_GUA.PlanCob%TYPE
                        , cCodCobert   FACTOR_GUA.CodCobert%TYPE
                        , cNivel       FACTOR_GUA.Nivel%TYPE
                        , nFactor      FACTOR_GUA.Factor%TYPE
                        , cCodClausula CLAUSULAS_FACTORES.CodClausula%TYPE ) RETURN XMLTYPE;

   PROCEDURE REGISTRAR( nCodCia       COTIZACIONES.CodCia%TYPE
                      , nCodEmpresa   COTIZACIONES.CodEmpresa%TYPE
                      , nIdCotizacion COTIZACIONES.IdCotizacion%TYPE
                      , xXMLDatosGUA  XMLTYPE );

END OC_FACTOR_GUA;
/
create or replace PACKAGE BODY          OC_FACTOR_GUA IS
   PROCEDURE INSERTAR( nCodCia     FACTOR_GUA.CodCia%TYPE
                     , nCodEmpresa FACTOR_GUA.CodEmpresa%TYPE
                     , cIdTipoSeg  FACTOR_GUA.IdTipoSeg%TYPE
                     , cPlanCob    FACTOR_GUA.PlanCob%TYPE
                     , cCodCobert  FACTOR_GUA.CodCobert%TYPE
                     , cNivel      FACTOR_GUA.Nivel%TYPE
                     , nFactor     FACTOR_GUA.Factor%TYPE ) IS
   BEGIN
       INSERT INTO FACTOR_GUA
          ( CodCia, CodEmpresa, IdTipoSeg, PlanCob, CodCobert, Nivel, Factor )
       VALUES ( nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, cCodCobert, cNivel, nFactor );
   END INSERTAR;

   PROCEDURE ELIMINAR( nCodCia     FACTOR_GUA.CodCia%TYPE
                     , nCodEmpresa FACTOR_GUA.CodEmpresa%TYPE
                     , cIdTipoSeg  FACTOR_GUA.IdTipoSeg%TYPE
                     , cPlanCob    FACTOR_GUA.PlanCob%TYPE
                     , cCodCobert  FACTOR_GUA.CodCobert%TYPE
                     , cNivel      FACTOR_GUA.Nivel%TYPE ) IS
   BEGIN
       DELETE FACTOR_GUA
       WHERE  CodCia      = nCodCia
         AND  CodEmpresa  = nCodEmpresa
         AND  IdTipoSeg   = cIdTipoSeg
         AND  PlanCob     = cPlanCob
         AND  CodCobert   = cCodCobert
         AND  Nivel       = cNivel;
   END ELIMINAR;

   FUNCTION SERVICIO_XML( nCodCia      FACTOR_GUA.CodCia%TYPE
                        , nCodEmpresa  FACTOR_GUA.CodEmpresa%TYPE
                        , cIdTipoSeg   FACTOR_GUA.IdTipoSeg%TYPE
                        , cPlanCob     FACTOR_GUA.PlanCob%TYPE
                        , cCodCobert   FACTOR_GUA.CodCobert%TYPE
                        , cNivel       FACTOR_GUA.Nivel%TYPE
                        , nFactor      FACTOR_GUA.Factor%TYPE
                        , cCodClausula CLAUSULAS_FACTORES.CodClausula%TYPE ) RETURN XMLTYPE IS
      xResultado  XMLTYPE;
   BEGIN
      SELECT XMLROOT(
             XMLELEMENT("DATA",
                        XMLELEMENT("IdTipoSeg", A.IdTipoSeg), 
                        XMLELEMENT("PlanCob"  , A.PlanCob),
                        XMLELEMENT("CodCobert", A.CodCobert), 
                        XMLAGG( XMLELEMENT("GUA", XMLFOREST( A.Nivel  "Nivel",
                                                             A.Factor "Factor",
                                                             ( SELECT XMLAGG( XMLFOREST( B.CodClausula  "CodClausula",
                                                                                         B.IndPrincipal "IndPrincipal"
                                                                                       )
                                                                            )
                                                               FROM   CLAUSULAS_FACTORES B
                                                               WHERE  B.TipoFactor  = 'GUA'
                                                                 AND  B.CodFactor   = A.Nivel
                                                                 AND  B.CodClausula = NVL( cCodClausula, CodClausula )
                                                             ) "CLAUSULAS"
                                                           )
                                          )
                              )
                       ), VERSION '1.0" encoding="UTF-8')
       INTO   xResultado
       FROM   FACTOR_GUA A
       WHERE  A.CodCia     = nCodCia
         AND  A.CodEmpresa = nCodEmpresa
         AND  A.IdTipoSeg  = cIdTipoSeg
         AND  A.PlanCob    = cPlanCob
         AND  A.CodCobert  = cCodCobert
         AND  A.Nivel      = NVL( cNivel  , Nivel )
         AND  A.Factor     = NVL( nFactor , Factor )
       GROUP BY A.CodCia, A.CodEmpresa, A.IdTipoSeg, A.PlanCob, A.CodCobert;
      --
      RETURN xResultado;
   EXCEPTION
   WHEN OTHERS THEN
      RETURN NULL;
   END SERVICIO_XML;

   PROCEDURE REGISTRAR( nCodCia       COTIZACIONES.CodCia%TYPE
                      , nCodEmpresa   COTIZACIONES.CodEmpresa%TYPE
                      , nIdCotizacion COTIZACIONES.IdCotizacion%TYPE
                      , xXMLDatosGUA  XMLTYPE ) IS
      cPrimerVez     VARCHAR2(1) := 'S';
      cTextoClausula LONG;
      cExisteFactor  VARCHAR2(1) := 'N';
      --
      CURSOR cRegistros IS
         WITH
         PRINCIPAL_DATA AS ( SELECT XT1.*
                             FROM   XMLTABLE('/DATA'
                                       PASSING xXMLDatosGUA
                                          COLUMNS 
                                             IDetCotizacion NUMBER(14)   PATH 'IDetCotizacion',
                                             CodSubGrupo    VARCHAR2(20) PATH 'CodSubGrupo',
                                             CodCobert      VARCHAR2(7)  PATH 'CodCobert',
                                             Gua            XMLTYPE      PATH 'GUA' ) XT1
                           ),
         GUA_DATA       AS ( SELECT IDetCotizacion
                                  , CodSubGrupo
                                  , CodCobert
                                  , XT2.*
                             FROM   PRINCIPAL_DATA P
                                ,   XMLTABLE('/GUA'
                                       PASSING P.Gua
                                          COLUMNS 
                                             Nivel     VARCHAR2(8) PATH 'Nivel',
                                             Factor    NUMBER(9,6) PATH 'Factor',
                                             Clausulas XMLTYPE     PATH 'CLAUSULAS' ) XT2
                           ),
         CLAUSULAS_DATA AS ( SELECT IDetCotizacion
                                  , CodSubGrupo
                                  , CodCobert
                                  , Nivel
                                  , Factor
                                  , XT3.*
                             FROM   GUA_DATA G
                                ,   XMLTABLE('/CLAUSULAS'
                                       PASSING G.Clausulas
                                          COLUMNS
                                             CodClausula   VARCHAR2(6) PATH 'CodClausula',
                                             TextoClausula CLOB        PATH 'TextoClausula' ) XT3
                           )
         SELECT * FROM CLAUSULAS_DATA;
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
              AND  TipoFactor     = 'GUA';
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
              cExisteFactor := 'N';
         END;
         --
         IF cExisteFactor = 'N' THEN
            INSERT INTO COTIZACIONES_DETALLE_FACTOR
                   (CodCia , CodEmpresa , IdCotizacion , IDetCotizacion  , TipoFactor, CodFactor, Factor )
            VALUES (nCodCia, nCodEmpresa, nIdCotizacion, x.IDetCotizacion, 'GUA'  , x.Nivel     , x.Factor );
         ELSE
            --
            UPDATE COTIZACIONES_DETALLE_FACTOR
            SET    CodFactor = x.Nivel
                 , Factor    = x.Factor
            WHERE  CodCia         = nCodCia
              AND  CodEmpresa     = nCodEmpresa
              AND  IdCotizacion   = nIdCotizacion
              AND  IDetCotizacion = x.IDetCotizacion
              AND  TipoFactor     = 'GUA';
         END IF;
         --
         --Elimino todas las Clausulas De la Cotización que pertenezcan al GUA 
         IF cPrimerVez = 'S' THEN
            cPrimerVez := 'N';
            --
            DELETE COTIZACIONES_CLAUSULAS CC
            WHERE  CC.CodCia       = nCodCia
              AND  CC.CodEmpresa   = nCodEmpresa
              AND  CC.IdCotizacion = nIdCotizacion
              AND  CC.CodClausula IN ( SELECT CF.CodClausula
                                       FROM   CLAUSULAS_FACTORES CF
                                       WHERE  CF.TIPOFACTOR = 'GUA' );
         END IF;
         --
         --Determino el Texto de la Clausula
         BEGIN
            SELECT TextoClausula
            INTO   cTextoClausula
            FROM   CLAUSULAS
            WHERE  CodCia      = nCodCia
              AND  CodEmpresa  = nCodEmpresa
              AND  CodClausula = x.CodClausula;
         EXCEPTION
         WHEN OTHERS THEN
            cTextoClausula := x.TextoClausula;
         END;
         --
         --Inserto las Clausulas de GUA que vengan en el XML
         BEGIN
            INSERT INTO COTIZACIONES_CLAUSULAS
               ( CodCia, CodEmpresa, IdCotizacion, CodClausula, TextoClausula )
            VALUES ( nCodCia, nCodEmpresa, nIdCotizacion, x.CodClausula, cTextoClausula );
         EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            UPDATE COTIZACIONES_CLAUSULAS
            SET    TextoClausula = cTextoClausula
            WHERE  CodCia       = nCodCia
              AND  CodEmpresa   = nCodEmpresa
              AND  IdCotizacion = nIdCotizacion
              AND  CodClausula  = x.CodClausula;
         END; 
         --
         --Actualizo el FactorAjuste en COTIZACIONES_DETALLE
         GT_COTIZACIONES_DETALLE.RECALCULA_FACTORAJUSTE( nCodCia, nCodEmpresa, nIdCotizacion, x.IDetCotizacion, x.CodSubGrupo );
         --           
      END LOOP;
      COMMIT;
   END REGISTRAR;
END OC_FACTOR_GUA;
