CREATE OR REPLACE PACKAGE          OC_FACTOR_ESCALA_PO IS
   PROCEDURE INSERTAR( nCodCia     FACTOR_ESCALA_PO.CodCia%TYPE
                     , nCodEmpresa FACTOR_ESCALA_PO.CodEmpresa%TYPE
                     , cIdTipoSeg  FACTOR_ESCALA_PO.IdTipoSeg%TYPE
                     , cPlanCob    FACTOR_ESCALA_PO.PlanCob%TYPE
                     , cCodCobert  FACTOR_ESCALA_PO.CodCobert%TYPE
                     , cEscala     FACTOR_ESCALA_PO.Escala%TYPE
                     , nFactor     FACTOR_ESCALA_PO.Factor%TYPE );

   PROCEDURE ELIMINAR( nCodCia     FACTOR_ESCALA_PO.CodCia%TYPE
                     , nCodEmpresa FACTOR_ESCALA_PO.CodEmpresa%TYPE
                     , cIdTipoSeg  FACTOR_ESCALA_PO.IdTipoSeg%TYPE
                     , cPlanCob    FACTOR_ESCALA_PO.PlanCob%TYPE
                     , cCodCobert  FACTOR_ESCALA_PO.CodCobert%TYPE
                     , cEscala     FACTOR_ESCALA_PO.Escala%TYPE );

   FUNCTION SERVICIO_XML( nCodCia      FACTOR_ESCALA_PO.CodCia%TYPE
                        , nCodEmpresa  FACTOR_ESCALA_PO.CodEmpresa%TYPE
                        , cIdTipoSeg   FACTOR_ESCALA_PO.IdTipoSeg%TYPE
                        , cPlanCob     FACTOR_ESCALA_PO.PlanCob%TYPE
                        , cCodCobert   FACTOR_ESCALA_PO.CodCobert%TYPE
                        , cEscala      FACTOR_ESCALA_PO.Escala%TYPE
                        , nFactor      FACTOR_ESCALA_PO.Factor%TYPE
                        , cCodClausula CLAUSULAS_FACTORES.CodClausula%TYPE ) RETURN XMLTYPE;

FUNCTION ESCALA( nCodCia      FACTOR_ESCALA_PO.CodCia%TYPE
               , nCodEmpresa  FACTOR_ESCALA_PO.CodEmpresa%TYPE
               , cIdTipoSeg   FACTOR_ESCALA_PO.IdTipoSeg%TYPE
               , cPlanCob     FACTOR_ESCALA_PO.PlanCob%TYPE
               , cCodCobert   FACTOR_ESCALA_PO.CodCobert%TYPE) RETURN VARCHAR2;                        

FUNCTION FACTOR_ESCALA( nCodCia      FACTOR_ESCALA_PO.CodCia%TYPE
                      , nCodEmpresa  FACTOR_ESCALA_PO.CodEmpresa%TYPE
                      , cIdTipoSeg   FACTOR_ESCALA_PO.IdTipoSeg%TYPE
                      , cPlanCob     FACTOR_ESCALA_PO.PlanCob%TYPE
                      , cCodCobert   FACTOR_ESCALA_PO.CodCobert%TYPE
                      , cEscala      FACTOR_ESCALA_PO.Escala%TYPE) RETURN NUMBER;

FUNCTION EXISTE_FACTOR_ESCALA( nCodCia      FACTOR_ESCALA_PO.CodCia%TYPE
                             , nCodEmpresa  FACTOR_ESCALA_PO.CodEmpresa%TYPE
                             , cIdTipoSeg   FACTOR_ESCALA_PO.IdTipoSeg%TYPE
                             , cPlanCob     FACTOR_ESCALA_PO.PlanCob%TYPE
                             , cCodCobert   FACTOR_ESCALA_PO.CodCobert%TYPE) RETURN VARCHAR2;

   /*PROCEDURE REGISTRAR( nCodCia       COTIZACIONES.CodCia%TYPE
                      , nCodEmpresa   COTIZACIONES.CodEmpresa%TYPE
                      , nIdCotizacion COTIZACIONES.IdCotizacion%TYPE
                      , xXMLDatosGUA  XMLTYPE );*/

END OC_FACTOR_ESCALA_PO;

/

CREATE OR REPLACE PACKAGE BODY          OC_FACTOR_ESCALA_PO IS
   PROCEDURE INSERTAR( nCodCia     FACTOR_ESCALA_PO.CodCia%TYPE
                     , nCodEmpresa FACTOR_ESCALA_PO.CodEmpresa%TYPE
                     , cIdTipoSeg  FACTOR_ESCALA_PO.IdTipoSeg%TYPE
                     , cPlanCob    FACTOR_ESCALA_PO.PlanCob%TYPE
                     , cCodCobert  FACTOR_ESCALA_PO.CodCobert%TYPE
                     , cEscala     FACTOR_ESCALA_PO.Escala%TYPE
                     , nFactor     FACTOR_ESCALA_PO.Factor%TYPE ) IS
   BEGIN
       INSERT INTO FACTOR_ESCALA_PO
          ( CodCia, CodEmpresa, IdTipoSeg, PlanCob, CodCobert, Escala, Factor )
       VALUES ( nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, cCodCobert, cEscala, nFactor );
   END INSERTAR;

   PROCEDURE ELIMINAR( nCodCia     FACTOR_ESCALA_PO.CodCia%TYPE
                     , nCodEmpresa FACTOR_ESCALA_PO.CodEmpresa%TYPE
                     , cIdTipoSeg  FACTOR_ESCALA_PO.IdTipoSeg%TYPE
                     , cPlanCob    FACTOR_ESCALA_PO.PlanCob%TYPE
                     , cCodCobert  FACTOR_ESCALA_PO.CodCobert%TYPE
                     , cEscala     FACTOR_ESCALA_PO.Escala%TYPE ) IS
   BEGIN
       DELETE FACTOR_ESCALA_PO
       WHERE  CodCia      = nCodCia
         AND  CodEmpresa  = nCodEmpresa
         AND  IdTipoSeg   = cIdTipoSeg
         AND  PlanCob     = cPlanCob
         AND  CodCobert   = cCodCobert
         AND  Escala      = cEscala;
   END ELIMINAR;

   FUNCTION SERVICIO_XML( nCodCia      FACTOR_ESCALA_PO.CodCia%TYPE
                        , nCodEmpresa  FACTOR_ESCALA_PO.CodEmpresa%TYPE
                        , cIdTipoSeg   FACTOR_ESCALA_PO.IdTipoSeg%TYPE
                        , cPlanCob     FACTOR_ESCALA_PO.PlanCob%TYPE
                        , cCodCobert   FACTOR_ESCALA_PO.CodCobert%TYPE
                        , cEscala      FACTOR_ESCALA_PO.Escala%TYPE
                        , nFactor      FACTOR_ESCALA_PO.Factor%TYPE
                        , cCodClausula CLAUSULAS_FACTORES.CodClausula%TYPE ) RETURN XMLTYPE IS
      xResultado  XMLTYPE;
   BEGIN
      SELECT XMLROOT(
             XMLELEMENT("DATA",
                        XMLELEMENT("IdTipoSeg", A.IdTipoSeg), 
                        XMLELEMENT("PlanCob"  , A.PlanCob),
                        XMLELEMENT("CodCobert", A.CodCobert), 
                        XMLAGG( XMLELEMENT("PO", XMLFOREST( A.Escala "Escala",
                                                            A.Factor "Factor"
                                                           )
                                          )
                              )
                       ), VERSION '1.0" encoding="UTF-8')
       INTO   xResultado
       FROM   FACTOR_ESCALA_PO A
       WHERE  A.CodCia     = nCodCia
         AND  A.CodEmpresa = nCodEmpresa
         AND  A.IdTipoSeg  = cIdTipoSeg
         AND  A.PlanCob    = cPlanCob
         AND  A.CodCobert  = cCodCobert
         AND  A.Escala     = NVL( cEscala  , Escala )
         AND  A.Factor     = NVL( nFactor , Factor )
       GROUP BY A.CodCia, A.CodEmpresa, A.IdTipoSeg, A.PlanCob, A.CodCobert;
      --
      RETURN xResultado;
   EXCEPTION
   WHEN OTHERS THEN
      RETURN NULL;
   END SERVICIO_XML;

FUNCTION ESCALA( nCodCia      FACTOR_ESCALA_PO.CodCia%TYPE
               , nCodEmpresa  FACTOR_ESCALA_PO.CodEmpresa%TYPE
               , cIdTipoSeg   FACTOR_ESCALA_PO.IdTipoSeg%TYPE
               , cPlanCob     FACTOR_ESCALA_PO.PlanCob%TYPE
               , cCodCobert   FACTOR_ESCALA_PO.CodCobert%TYPE) RETURN VARCHAR2 IS
cEscala      FACTOR_ESCALA_PO.Escala%TYPE;             
BEGIN
   BEGIN
      SELECT Escala
        INTO cEscala
        FROM FACTOR_ESCALA_PO A
       WHERE A.CodCia     = nCodCia
         AND A.CodEmpresa = nCodEmpresa
         AND A.IdTipoSeg  = cIdTipoSeg
         AND A.PlanCob    = cPlanCob
         AND A.CodCobert  = cCodCobert;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cEscala := 'X';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existe más de una escala para la cobertura '||cCodCobert||' por favor valide configuración de factores de Perdidas Organicas');
   END;
   RETURN cEscala;
END ;     

FUNCTION FACTOR_ESCALA( nCodCia      FACTOR_ESCALA_PO.CodCia%TYPE
                      , nCodEmpresa  FACTOR_ESCALA_PO.CodEmpresa%TYPE
                      , cIdTipoSeg   FACTOR_ESCALA_PO.IdTipoSeg%TYPE
                      , cPlanCob     FACTOR_ESCALA_PO.PlanCob%TYPE
                      , cCodCobert   FACTOR_ESCALA_PO.CodCobert%TYPE
                      , cEscala      FACTOR_ESCALA_PO.Escala%TYPE) RETURN NUMBER IS
nFactor FACTOR_ESCALA_PO.Factor%TYPE;               
BEGIN
   BEGIN
      SELECT Factor
        INTO nFactor
        FROM FACTOR_ESCALA_PO A
       WHERE A.CodCia     = nCodCia
         AND A.CodEmpresa = nCodEmpresa
         AND A.IdTipoSeg  = cIdTipoSeg
         AND A.PlanCob    = cPlanCob
         AND A.CodCobert  = cCodCobert
         AND A.Escala     = cEscala;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nFactor := 1;
   END;
   RETURN nFactor;
END FACTOR_ESCALA;   

FUNCTION EXISTE_FACTOR_ESCALA( nCodCia      FACTOR_ESCALA_PO.CodCia%TYPE
                             , nCodEmpresa  FACTOR_ESCALA_PO.CodEmpresa%TYPE
                             , cIdTipoSeg   FACTOR_ESCALA_PO.IdTipoSeg%TYPE
                             , cPlanCob     FACTOR_ESCALA_PO.PlanCob%TYPE
                             , cCodCobert   FACTOR_ESCALA_PO.CodCobert%TYPE) RETURN VARCHAR2 IS
cExiste  VARCHAR2(1);                             
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM FACTOR_ESCALA_PO A
       WHERE A.CodCia     = nCodCia
         AND A.CodEmpresa = nCodEmpresa
         AND A.IdTipoSeg  = cIdTipoSeg
         AND A.PlanCob    = cPlanCob
         AND A.CodCobert  = cCodCobert;
   EXCEPTION 
      WHEN NO_DATA_FOUND THEN 
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN 
         cExiste := 'N';
   END;
   RETURN cExiste;
END EXISTE_FACTOR_ESCALA;


   /*PROCEDURE REGISTRAR( nCodCia       COTIZACIONES.CodCia%TYPE
                      , nCodEmpresa   COTIZACIONES.CodEmpresa%TYPE
                      , nIdCotizacion COTIZACIONES.IdCotizacion%TYPE
                      , xXMLDatosGUA  XMLTYPE ) IS
      cPrimerVez     VARCHAR2(1) := 'S';
      cTextoClausula CLOB;
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
                                             Escala     VARCHAR2(8) PATH 'Escala',
                                             Factor    NUMBER(9,6) PATH 'Factor',
                                             Clausulas XMLTYPE     PATH 'CLAUSULAS' ) XT2
                           ),
         CLAUSULAS_DATA AS ( SELECT IDetCotizacion
                                  , CodSubGrupo
                                  , CodCobert
                                  , Escala
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
            VALUES (nCodCia, nCodEmpresa, nIdCotizacion, x.IDetCotizacion, 'GUA'  , x.Escala     , x.Factor );
         ELSE
            --
            UPDATE COTIZACIONES_DETALLE_FACTOR
            SET    CodFactor = x.Escala
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
         IF TRIM(x.TextoClausula) IS NULL THEN
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
         ELSE
            cTextoClausula := x.TextoClausula;
         END IF;
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
   END REGISTRAR;*/
END OC_FACTOR_ESCALA_PO;
