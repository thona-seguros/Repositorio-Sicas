CREATE OR REPLACE PACKAGE          OC_FACTOR_EQUIPOS_REPRESENTA IS
   PROCEDURE INSERTAR( nCodCia      FACTOR_EQUIPOS_REPRESENTA.CodCia%TYPE
                     , nCodEmpresa  FACTOR_EQUIPOS_REPRESENTA.CodEmpresa%TYPE
                     , cIdTipoSeg   FACTOR_EQUIPOS_REPRESENTA.IdTipoSeg%TYPE
                     , cPlanCob     FACTOR_EQUIPOS_REPRESENTA.PlanCob%TYPE
                     , nCodPaquete  FACTOR_EQUIPOS_REPRESENTA.CodPaquete%TYPE
                     , cCodEquipo   FACTOR_EQUIPOS_REPRESENTA.CodEquipo%TYPE
                     , cIndIncluido FACTOR_EQUIPOS_REPRESENTA.IndIncluido%TYPE
                     , nFactor      FACTOR_EQUIPOS_REPRESENTA.Factor%TYPE );

   PROCEDURE ELIMINAR( nCodCia     FACTOR_EQUIPOS_REPRESENTA.CodCia%TYPE
                     , nCodEmpresa FACTOR_EQUIPOS_REPRESENTA.CodEmpresa%TYPE
                     , cIdTipoSeg  FACTOR_EQUIPOS_REPRESENTA.IdTipoSeg%TYPE
                     , cPlanCob    FACTOR_EQUIPOS_REPRESENTA.PlanCob%TYPE
                     , nCodPaquete FACTOR_EQUIPOS_REPRESENTA.CodPaquete%TYPE
                     , cCodEquipo  FACTOR_EQUIPOS_REPRESENTA.CodEquipo%TYPE );

   FUNCTION SERVICIO_XML( nCodCia     FACTOR_EQUIPOS_REPRESENTA.CodCia%TYPE
                        , nCodEmpresa FACTOR_EQUIPOS_REPRESENTA.CodEmpresa%TYPE
                        , cIdTipoSeg  FACTOR_EQUIPOS_REPRESENTA.IdTipoSeg%TYPE
                        , cPlanCob    FACTOR_EQUIPOS_REPRESENTA.PlanCob%TYPE
                        , nCodPaquete FACTOR_EQUIPOS_REPRESENTA.CodPaquete%TYPE
                        , cCodEquipo  FACTOR_EQUIPOS_REPRESENTA.CodEquipo%TYPE ) RETURN XMLTYPE;

   PROCEDURE REGISTRAR( nCodCia         COTIZACIONES.CodCia%TYPE
                      , nCodEmpresa     COTIZACIONES.CodEmpresa%TYPE
                      , nIdCotizacion   COTIZACIONES.IdCotizacion%TYPE
                      , xXMLDatosEquRep XMLTYPE );

   FUNCTION TEXTO_FACTOR( nCodCia     FACTOR_EQUIPOS_REPRESENTA.CodCia%TYPE
                        , nCodEmpresa FACTOR_EQUIPOS_REPRESENTA.CodEmpresa%TYPE
                        , cIdTipoSeg  FACTOR_EQUIPOS_REPRESENTA.IdTipoSeg%TYPE
                        , cPlanCob    FACTOR_EQUIPOS_REPRESENTA.PlanCob%TYPE
                        , nCodPaquete FACTOR_EQUIPOS_REPRESENTA.CodPaquete%TYPE
                        , cCodEquipo  FACTOR_EQUIPOS_REPRESENTA.CodEquipo%TYPE ) RETURN VARCHAR2;                      

   PROCEDURE REGISTRAR_TEXTO( nCodCia         COTIZACIONES.CodCia%TYPE
                            , nCodEmpresa     COTIZACIONES.CodEmpresa%TYPE
                            , nIdCotizacion   COTIZACIONES.IdCotizacion%TYPE
                            , xXMLDatosEquRep XMLTYPE );

END OC_FACTOR_EQUIPOS_REPRESENTA;

/

CREATE OR REPLACE PACKAGE BODY          OC_FACTOR_EQUIPOS_REPRESENTA IS
   PROCEDURE INSERTAR( nCodCia      FACTOR_EQUIPOS_REPRESENTA.CodCia%TYPE
                     , nCodEmpresa  FACTOR_EQUIPOS_REPRESENTA.CodEmpresa%TYPE
                     , cIdTipoSeg   FACTOR_EQUIPOS_REPRESENTA.IdTipoSeg%TYPE
                     , cPlanCob     FACTOR_EQUIPOS_REPRESENTA.PlanCob%TYPE
                     , nCodPaquete  FACTOR_EQUIPOS_REPRESENTA.CodPaquete%TYPE
                     , cCodEquipo   FACTOR_EQUIPOS_REPRESENTA.CodEquipo%TYPE
                     , cIndIncluido FACTOR_EQUIPOS_REPRESENTA.IndIncluido%TYPE
                     , nFactor      FACTOR_EQUIPOS_REPRESENTA.Factor%TYPE ) IS
   BEGIN
       INSERT INTO FACTOR_EQUIPOS_REPRESENTA
          ( CodCia, CodEmpresa, IdTipoSeg, PlanCob, CodPaquete, CodEquipo, IndIncluido, Factor )
       VALUES ( nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nCodPaquete, cCodEquipo, cIndIncluido, nFactor );
   END INSERTAR;

   PROCEDURE ELIMINAR( nCodCia     FACTOR_EQUIPOS_REPRESENTA.CodCia%TYPE
                     , nCodEmpresa FACTOR_EQUIPOS_REPRESENTA.CodEmpresa%TYPE
                     , cIdTipoSeg  FACTOR_EQUIPOS_REPRESENTA.IdTipoSeg%TYPE
                     , cPlanCob    FACTOR_EQUIPOS_REPRESENTA.PlanCob%TYPE
                     , nCodPaquete FACTOR_EQUIPOS_REPRESENTA.CodPaquete%TYPE
                     , cCodEquipo  FACTOR_EQUIPOS_REPRESENTA.CodEquipo%TYPE ) IS
   BEGIN
       DELETE FACTOR_EQUIPOS_REPRESENTA
       WHERE  CodCia     = nCodCia
         AND  CodEmpresa = nCodEmpresa
         AND  IdTipoSeg  = cIdTipoSeg
         AND  PlanCob    = cPlanCob
         AND  CodPaquete = nCodPaquete
         AND  CodEquipo  = cCodEquipo;
   END ELIMINAR;

   FUNCTION SERVICIO_XML( nCodCia     FACTOR_EQUIPOS_REPRESENTA.CodCia%TYPE
                        , nCodEmpresa FACTOR_EQUIPOS_REPRESENTA.CodEmpresa%TYPE
                        , cIdTipoSeg  FACTOR_EQUIPOS_REPRESENTA.IdTipoSeg%TYPE
                        , cPlanCob    FACTOR_EQUIPOS_REPRESENTA.PlanCob%TYPE
                        , nCodPaquete FACTOR_EQUIPOS_REPRESENTA.CodPaquete%TYPE
                        , cCodEquipo  FACTOR_EQUIPOS_REPRESENTA.CodEquipo%TYPE ) RETURN XMLTYPE IS
      xResultado  XMLTYPE;
   BEGIN
      SELECT XMLROOT(
             XMLELEMENT("DATA",
                        XMLELEMENT("IdTipoSeg"  , A.IdTipoSeg), 
                        XMLELEMENT("PlanCob"    , A.PlanCob),
                        XMLELEMENT("CodPaquete" , A.CodPaquete),
                        XMLELEMENT("DescPaquete", C.DescPaquete),
                        XMLAGG( XMLELEMENT("EQUIPOSREPRESENTATIVOS", XMLFOREST( A.IndIncluido  "IndIncluido",
                                                                                A.Factor       "Factor"
                                                                                /*( SELECT XMLAGG( XMLFOREST( B.CodClausula  "CodEquipo",
                                                                                                            B.IndPrincipal "IndPrincipal"
                                                                                                     )
                                                                                               )
                                                                                  FROM   CLAUSULAS_FACTORES B
                                                                                  WHERE  B.TipoFactor  = 'EQUREP'
                                                                                    AND  B.CodFactor   = A.CodEquipo
                                                                                    AND  B.CodClausula = NVL( cCodEquipo, CodClausula )
                                                                                ) "EQUIPO"*/
                                                                              )
                                          )
                              )
                       ), VERSION '1.0" encoding="UTF-8')
       INTO   xResultado
       FROM   FACTOR_EQUIPOS_REPRESENTA A
          ,   PAQUETE_COMERCIAL         C
       WHERE  C.CodCia     = A.CodCia
         AND  C.CodEmpresa = A.CodEmpresa
         AND  C.IdTipoSeg  = A.IdTipoSeg
         AND  C.PlanCob    = A.PlanCob
         AND  C.CodPaquete = A.CodPaquete 
         AND  A.CodCia     = nCodCia
         AND  A.CodEmpresa = nCodEmpresa
         AND  A.IdTipoSeg  = cIdTipoSeg
         AND  A.PlanCob    = cPlanCob
         AND  A.CodPaquete = nCodPaquete
         AND  A.CodEquipo  = NVL( cCodEquipo, CodEquipo )
       GROUP BY A.CodCia, A.CodEmpresa, A.IdTipoSeg, A.PlanCob, A.CodPaquete, C.DescPaquete;
      --
      RETURN xResultado;
   EXCEPTION
   WHEN OTHERS THEN
      RETURN NULL;
   END SERVICIO_XML;

   PROCEDURE REGISTRAR( nCodCia         COTIZACIONES.CodCia%TYPE
                      , nCodEmpresa     COTIZACIONES.CodEmpresa%TYPE
                      , nIdCotizacion   COTIZACIONES.IdCotizacion%TYPE
                      , xXMLDatosEquRep XMLTYPE ) IS
      cExisteFactor  VARCHAR2(1) := 'N';
      --
      CURSOR cRegistros IS
         WITH
         PRINCIPAL_DATA AS ( SELECT XT1.*
                             FROM   XMLTABLE('/DATA'
                                       PASSING xXMLDatosEquRep
                                          COLUMNS 
                                             IDetCotizacion NUMBER(14)   PATH 'IDetCotizacion',
                                             CodSubGrupo    VARCHAR2(20) PATH 'CodSubGrupo',
                                             CodPaquete     NUMBER(14)   PATH 'CodPaquete',
                                             Equipos        XMLTYPE      PATH 'EQUIPOSREPRESENTATIVOS' ) XT1
                           ),
         EQUREP_DATA   AS ( SELECT IDetCotizacion
                                  , CodSubGrupo
                                  , CodPaquete
                                  , XT2.*
                             FROM   PRINCIPAL_DATA P
                                ,   XMLTABLE('/EQUIPOSREPRESENTATIVOS'
                                       PASSING P.Equipos
                                          COLUMNS 
                                             IndIncluido VARCHAR2(1) PATH 'IndIncluido',
                                             Factor      NUMBER(9,6) PATH 'Factor',
                                             CodEquipo   VARCHAR2(10)PATH 'CodEquipo') XT2
                           )
         SELECT * FROM EQUREP_DATA;
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
              AND  TipoFactor     = 'EQUREP';
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
              cExisteFactor := 'N';
         END;
         --
         IF cExisteFactor = 'N' THEN
            INSERT INTO COTIZACIONES_DETALLE_FACTOR
                   (CodCia , CodEmpresa , IdCotizacion , IDetCotizacion  , TipoFactor, CodFactor  , Factor )
            VALUES (nCodCia, nCodEmpresa, nIdCotizacion, x.IDetCotizacion, 'EQUREP'  , x.CodEquipo, x.Factor );
         ELSE
            --
            UPDATE COTIZACIONES_DETALLE_FACTOR
            SET    CodFactor = x.CodEquipo
              ,    Factor    = x.Factor
            WHERE  CodCia         = nCodCia
              AND  CodEmpresa     = nCodEmpresa
              AND  IdCotizacion   = nIdCotizacion
              AND  IDetCotizacion = x.IDetCotizacion
              AND  TipoFactor     = 'EQUREP';
         END IF;
         --
         --Actualizo el FactorAjuste en COTIZACIONES_DETALLE 
         GT_COTIZACIONES_DETALLE.RECALCULA_FACTORAJUSTE( nCodCia, nCodEmpresa, nIdCotizacion, x.IDetCotizacion, x.CodSubGrupo );
         --           
      END LOOP;
      --COMMIT;
   END REGISTRAR;

   FUNCTION TEXTO_FACTOR( nCodCia     FACTOR_EQUIPOS_REPRESENTA.CodCia%TYPE
                        , nCodEmpresa FACTOR_EQUIPOS_REPRESENTA.CodEmpresa%TYPE
                        , cIdTipoSeg  FACTOR_EQUIPOS_REPRESENTA.IdTipoSeg%TYPE
                        , cPlanCob    FACTOR_EQUIPOS_REPRESENTA.PlanCob%TYPE
                        , nCodPaquete FACTOR_EQUIPOS_REPRESENTA.CodPaquete%TYPE
                        , cCodEquipo  FACTOR_EQUIPOS_REPRESENTA.CodEquipo%TYPE ) RETURN VARCHAR2 IS
      cTextoFactor   FACTOR_EQUIPOS_REPRESENTA.TextoFactor%TYPE;                     
   BEGIN
      BEGIN
         SELECT NVL(TextoFactor, ' ')
         INTO   cTextoFactor
         FROM   FACTOR_EQUIPOS_REPRESENTA
         WHERE  CodCia     = nCodCia
           AND  CodEmpresa = nCodEmpresa
           AND  IdTipoSeg  = cIdTipoSeg
           AND  PlanCob    = cPlanCob
           AND  CodPaquete = nCodPaquete
           AND  CodEquipo  = cCodEquipo;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
           RAISE_APPLICATION_ERROR(-20200,'No es posible determinar texto para Riesgo a cubrir para el Factor de equipo representativo');
      END;
      RETURN cTextoFactor;
   END TEXTO_FACTOR;    

   PROCEDURE REGISTRAR_TEXTO( nCodCia         COTIZACIONES.CodCia%TYPE
                            , nCodEmpresa     COTIZACIONES.CodEmpresa%TYPE
                            , nIdCotizacion   COTIZACIONES.IdCotizacion%TYPE
                            , xXMLDatosEquRep XMLTYPE ) IS
      cTextoFactor   FACTOR_EQUIPOS_REPRESENTA.TextoFactor%TYPE;
      cIdTipoSeg     COTIZACIONES.IdTipoSeg%TYPE;
      cPlanCob       COTIZACIONES.PlanCob%TYPE;
      --
      CURSOR cRegistros IS
         WITH
         PRINCIPAL_DATA AS ( SELECT XT1.*
                             FROM   XMLTABLE('/DATA'
                                       PASSING xXMLDatosEquRep
                                          COLUMNS 
                                             IDetCotizacion NUMBER(14)   PATH 'IDetCotizacion',
                                             CodSubGrupo    VARCHAR2(20) PATH 'CodSubGrupo',
                                             CodPaquete     NUMBER(14)   PATH 'CodPaquete',
                                             Equipos        XMLTYPE      PATH 'EQUIPOSREPRESENTATIVOS' ) XT1
                           ),
         EQUREP_DATA   AS ( SELECT IDetCotizacion
                                  , CodSubGrupo
                                  , CodPaquete
                                  , XT2.*
                             FROM   PRINCIPAL_DATA P
                                ,   XMLTABLE('/EQUIPOSREPRESENTATIVOS'
                                       PASSING P.Equipos
                                          COLUMNS 
                                             IndIncluido VARCHAR2(1) PATH 'IndIncluido',
                                             Factor      NUMBER(9,6) PATH 'Factor',
                                             CodEquipo   VARCHAR2(10)PATH 'CodEquipo') XT2
                          )
         SELECT * FROM EQUREP_DATA;
      --
   BEGIN
      FOR x IN cRegistros LOOP 
         -- Se busca valor del texto para agregar al riesgo a cubrir y actualizar la cotizacion
         SELECT IdTipoSeg, PlanCob
         INTO   cIdTipoSeg, cPlanCob
         FROM   COTIZACIONES 
         WHERE  CodCia        = nCodCia
           AND  CodEmpresa    = nCodEmpresa
           AND  IdCotizacion  = nIdCotizacion;
         --
         cTextoFactor := OC_FACTOR_EQUIPOS_REPRESENTA.TEXTO_FACTOR(nCodCia , nCodEmpresa, cIdTipoSeg, cPlanCob, X.CodPaquete, X.CodEquipo);  
         --
         UPDATE COTIZACIONES
         SET    DescRiesgosCubiertos = REPLACE(DescRiesgosCubiertos,'"','') || ' ' || cTextoFactor
         WHERE  CodCia        = nCodCia
           AND  CodEmpresa    = nCodEmpresa
           AND  IdCotizacion  = nIdCotizacion;
         --           
      END LOOP;
      --COMMIT;
   END REGISTRAR_TEXTO;

   END OC_FACTOR_EQUIPOS_REPRESENTA;
