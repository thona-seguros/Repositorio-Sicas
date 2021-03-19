create or replace PACKAGE          OC_FACTOR_NIVEL_HOSPITALARIO IS
   PROCEDURE INSERTAR( nCodCia      FACTOR_NIVEL_HOSPITALARIO.CodCia%TYPE
                     , nCodEmpresa  FACTOR_NIVEL_HOSPITALARIO.CodEmpresa%TYPE
                     , cIdTipoSeg   FACTOR_NIVEL_HOSPITALARIO.IdTipoSeg%TYPE
                     , cPlanCob     FACTOR_NIVEL_HOSPITALARIO.PlanCob%TYPE
                     , cCodCobert   FACTOR_NIVEL_HOSPITALARIO.CodCobert%TYPE
                     , cCodEndoso   FACTOR_NIVEL_HOSPITALARIO.CodEndoso%TYPE
                     , cIndIncluido FACTOR_NIVEL_HOSPITALARIO.IndIncluido%TYPE
                     , nFactor      FACTOR_NIVEL_HOSPITALARIO.Factor%TYPE );

   PROCEDURE ELIMINAR( nCodCia     FACTOR_NIVEL_HOSPITALARIO.CodCia%TYPE
                     , nCodEmpresa FACTOR_NIVEL_HOSPITALARIO.CodEmpresa%TYPE
                     , cIdTipoSeg  FACTOR_NIVEL_HOSPITALARIO.IdTipoSeg%TYPE
                     , cPlanCob    FACTOR_NIVEL_HOSPITALARIO.PlanCob%TYPE
                     , cCodCobert  FACTOR_NIVEL_HOSPITALARIO.CodCobert%TYPE
                     , cCodEndoso  FACTOR_NIVEL_HOSPITALARIO.CodEndoso%TYPE );

   FUNCTION SERVICIO_XML( nCodCia     FACTOR_NIVEL_HOSPITALARIO.CodCia%TYPE
                        , nCodEmpresa FACTOR_NIVEL_HOSPITALARIO.CodEmpresa%TYPE
                        , cIdTipoSeg  FACTOR_NIVEL_HOSPITALARIO.IdTipoSeg%TYPE
                        , cPlanCob    FACTOR_NIVEL_HOSPITALARIO.PlanCob%TYPE
                        , cCodCobert  FACTOR_NIVEL_HOSPITALARIO.CodCobert%TYPE
                        , cCodEndoso  FACTOR_NIVEL_HOSPITALARIO.CodEndoso%TYPE ) RETURN XMLTYPE;

   PROCEDURE REGISTRAR( nCodCia          COTIZACIONES.CodCia%TYPE
                      , nCodEmpresa      COTIZACIONES.CodEmpresa%TYPE
                      , nIdCotizacion    COTIZACIONES.IdCotizacion%TYPE
                      , xXMLDatosNivHosp XMLTYPE );

END OC_FACTOR_NIVEL_HOSPITALARIO;
/
create or replace PACKAGE BODY          OC_FACTOR_NIVEL_HOSPITALARIO IS
   PROCEDURE INSERTAR( nCodCia      FACTOR_NIVEL_HOSPITALARIO.CodCia%TYPE
                     , nCodEmpresa  FACTOR_NIVEL_HOSPITALARIO.CodEmpresa%TYPE
                     , cIdTipoSeg   FACTOR_NIVEL_HOSPITALARIO.IdTipoSeg%TYPE
                     , cPlanCob     FACTOR_NIVEL_HOSPITALARIO.PlanCob%TYPE
                     , cCodCobert   FACTOR_NIVEL_HOSPITALARIO.CodCobert%TYPE
                     , cCodEndoso   FACTOR_NIVEL_HOSPITALARIO.CodEndoso%TYPE
                     , cIndIncluido FACTOR_NIVEL_HOSPITALARIO.IndIncluido%TYPE
                     , nFactor      FACTOR_NIVEL_HOSPITALARIO.Factor%TYPE ) IS
   BEGIN
       INSERT INTO FACTOR_NIVEL_HOSPITALARIO
          ( CodCia, CodEmpresa, IdTipoSeg, PlanCob, CodCobert, CodEndoso, IndIncluido, Factor )
       VALUES ( nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, cCodCobert, cCodEndoso, cIndIncluido, nFactor );
   END INSERTAR;

   PROCEDURE ELIMINAR( nCodCia     FACTOR_NIVEL_HOSPITALARIO.CodCia%TYPE
                     , nCodEmpresa FACTOR_NIVEL_HOSPITALARIO.CodEmpresa%TYPE
                     , cIdTipoSeg  FACTOR_NIVEL_HOSPITALARIO.IdTipoSeg%TYPE
                     , cPlanCob    FACTOR_NIVEL_HOSPITALARIO.PlanCob%TYPE
                     , cCodCobert  FACTOR_NIVEL_HOSPITALARIO.CodCobert%TYPE
                     , cCodEndoso  FACTOR_NIVEL_HOSPITALARIO.CodEndoso%TYPE ) IS
   BEGIN
       DELETE FACTOR_NIVEL_HOSPITALARIO
       WHERE  CodCia     = nCodCia
         AND  CodEmpresa = nCodEmpresa
         AND  IdTipoSeg  = cIdTipoSeg
         AND  PlanCob    = cPlanCob
         AND  CodCobert  = cCodCobert
         AND  CodEndoso  = cCodEndoso;
   END ELIMINAR;

   FUNCTION SERVICIO_XML( nCodCia     FACTOR_NIVEL_HOSPITALARIO.CodCia%TYPE
                        , nCodEmpresa FACTOR_NIVEL_HOSPITALARIO.CodEmpresa%TYPE
                        , cIdTipoSeg  FACTOR_NIVEL_HOSPITALARIO.IdTipoSeg%TYPE
                        , cPlanCob    FACTOR_NIVEL_HOSPITALARIO.PlanCob%TYPE
                        , cCodCobert  FACTOR_NIVEL_HOSPITALARIO.CodCobert%TYPE
                        , cCodEndoso  FACTOR_NIVEL_HOSPITALARIO.CodEndoso%TYPE ) RETURN XMLTYPE IS
      xResultado  XMLTYPE;
   BEGIN
      SELECT XMLROOT(
             XMLELEMENT("DATA",
                        XMLELEMENT("IdTipoSeg", A.IdTipoSeg), 
                        XMLELEMENT("PlanCob"  , A.PlanCob),
                        XMLELEMENT("CodCobert", A.CodCobert), 
                        XMLAGG( XMLELEMENT("NIVELHOSPITALARIO", XMLFOREST( A.IndIncluido  "IndIncluido",
                                                                           A.Factor       "Factor",
                                                                           ( SELECT XMLAGG( XMLFOREST( B.CodClausula  "CodEndoso",
                                                                                                       B.IndPrincipal "IndPrincipal"
                                                                                                     )
                                                                                          )
                                                                             FROM   CLAUSULAS_FACTORES B
                                                                             WHERE  B.TipoFactor  = 'NIVHOS'
                                                                               AND  B.CodFactor   = A.CodEndoso
                                                                               AND  B.CodClausula = NVL( cCodEndoso, CodClausula )
                                                                           ) "ENDOSO"
                                                                         )
                                          )
                              )
                       ), VERSION '1.0" encoding="UTF-8')
       INTO   xResultado
       FROM   FACTOR_NIVEL_HOSPITALARIO A
       WHERE  A.CodCia     = nCodCia
         AND  A.CodEmpresa = nCodEmpresa
         AND  A.IdTipoSeg  = cIdTipoSeg
         AND  A.PlanCob    = cPlanCob
         AND  A.CodCobert  = cCodCobert
         AND  A.CodEndoso  = NVL( cCodEndoso, CodEndoso )
       GROUP BY A.CodCia, A.CodEmpresa, A.IdTipoSeg, A.PlanCob, A.CodCobert;
      --
      RETURN xResultado;
   EXCEPTION
   WHEN OTHERS THEN
      RETURN NULL;
   END SERVICIO_XML;

   PROCEDURE REGISTRAR( nCodCia          COTIZACIONES.CodCia%TYPE
                      , nCodEmpresa      COTIZACIONES.CodEmpresa%TYPE
                      , nIdCotizacion    COTIZACIONES.IdCotizacion%TYPE
                      , xXMLDatosNivHosp XMLTYPE ) IS
      cPrimerVez     VARCHAR2(1) := 'S';
      cTextoClausula LONG;
      cExisteFactor  VARCHAR2(1) := 'N';
      --
      CURSOR cRegistros IS
         WITH
         PRINCIPAL_DATA AS ( SELECT XT1.*
                             FROM   XMLTABLE('/DATA'
                                       PASSING xXMLDatosNivHosp
                                          COLUMNS 
                                             IDetCotizacion NUMBER(14)   PATH 'IDetCotizacion',
                                             CodSubGrupo    VARCHAR2(20) PATH 'CodSubGrupo',
                                             CodCobert      VARCHAR2(7)  PATH 'CodCobert',
                                             NivHosp        XMLTYPE      PATH 'NIVELHOSPITALARIO' ) XT1
                           ),
         NIVHOSP_DATA   AS ( SELECT IDetCotizacion
                                  , CodSubGrupo
                                  , CodCobert
                                  , XT2.*
                             FROM   PRINCIPAL_DATA P
                                ,   XMLTABLE('/NIVELHOSPITALARIO'
                                       PASSING P.NivHosp
                                          COLUMNS 
                                             IndIncluido VARCHAR2(1) PATH 'IndIncluido',
                                             Factor      NUMBER(9,6) PATH 'Factor',
                                             Clausulas   XMLTYPE     PATH 'ENDOSO' ) XT2
                           ),
         CLAUSULAS_DATA AS ( SELECT IDetCotizacion
                                  , CodSubGrupo
                                  , CodCobert
                                  , IndIncluido
                                  , Factor
                                  , XT3.*
                             FROM   NIVHOSP_DATA G
                                ,   XMLTABLE('/ENDOSO'
                                       PASSING G.Clausulas
                                          COLUMNS
                                             CodEndoso     VARCHAR2(10) PATH 'CodEndoso',
                                             TextoClausula CLOB         PATH 'TextoClausula' ) XT3
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
              AND  TipoFactor     = 'NIVHOS';
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
              cExisteFactor := 'N';
         END;
         --
         IF cExisteFactor = 'N' THEN
            INSERT INTO COTIZACIONES_DETALLE_FACTOR
                   (CodCia , CodEmpresa , IdCotizacion , IDetCotizacion  , TipoFactor, CodFactor  , Factor )
            VALUES (nCodCia, nCodEmpresa, nIdCotizacion, x.IDetCotizacion, 'NIVHOS'  , x.CodEndoso, x.Factor );
         ELSE
            --
            UPDATE COTIZACIONES_DETALLE_FACTOR
            SET    CodFactor = x.CodEndoso
                 , Factor    = x.Factor
            WHERE  CodCia         = nCodCia
              AND  CodEmpresa     = nCodEmpresa
              AND  IdCotizacion   = nIdCotizacion
              AND  IDetCotizacion = x.IDetCotizacion
              AND  TipoFactor     = 'NIVHOS';
         END IF;
         --
         --Elimino todas las Clausulas De la Cotización que pertenezcan al Nivel Hospitalario 
         IF cPrimerVez = 'S' THEN
            cPrimerVez := 'N';
            --
            DELETE COTIZACIONES_CLAUSULAS CC
            WHERE  CC.CodCia       = nCodCia
              AND  CC.CodEmpresa   = nCodEmpresa
              AND  CC.IdCotizacion = nIdCotizacion
              AND  CC.CodClausula IN ( SELECT CF.CodClausula
                                       FROM   CLAUSULAS_FACTORES CF
                                       WHERE  CF.TIPOFACTOR = 'NIVHOS' );
         END IF;
         --
         --Determino el Texto de la Clausula
         BEGIN
            SELECT TextoClausula
            INTO   cTextoClausula
            FROM   CLAUSULAS
            WHERE  CodCia      = nCodCia
              AND  CodEmpresa  = nCodEmpresa
              AND  CodClausula = x.CodEndoso;
         EXCEPTION
         WHEN OTHERS THEN
            cTextoClausula := x.TextoClausula;
         END;
         --
         --Inserto las Clausulas de Nivel Hospitalario que vengan en el XML
         BEGIN
            INSERT INTO COTIZACIONES_CLAUSULAS
               ( CodCia, CodEmpresa, IdCotizacion, CodClausula, TextoClausula )
            VALUES ( nCodCia, nCodEmpresa, nIdCotizacion, x.CodEndoso, cTextoClausula );
         EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            UPDATE COTIZACIONES_CLAUSULAS
            SET    TextoClausula = cTextoClausula
            WHERE  CodCia       = nCodCia
              AND  CodEmpresa   = nCodEmpresa
              AND  IdCotizacion = nIdCotizacion
              AND  CodClausula  = x.CodEndoso;
         END; 
         --
         --Actualizo el FactorAjuste en COTIZACIONES_DETALLE 
         GT_COTIZACIONES_DETALLE.RECALCULA_FACTORAJUSTE( nCodCia, nCodEmpresa, nIdCotizacion, x.IDetCotizacion, x.CodSubGrupo );
         --           
      END LOOP;
      COMMIT;
   END REGISTRAR;

END OC_FACTOR_NIVEL_HOSPITALARIO;
