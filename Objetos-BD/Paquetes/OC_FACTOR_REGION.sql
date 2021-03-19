create or replace PACKAGE          OC_FACTOR_REGION IS
   PROCEDURE INSERTAR( nCodCia      FACTOR_REGION.CodCia%TYPE
                     , nCodEmpresa  FACTOR_REGION.CodEmpresa%TYPE
                     , cIdTipoSeg   FACTOR_REGION.IdTipoSeg%TYPE
                     , cPlanCob     FACTOR_REGION.PlanCob%TYPE
                     , nCodPaquete  FACTOR_REGION.CodPaquete%TYPE
                     , cCodRegion   FACTOR_REGION.CodRegion%TYPE
                     , nFactor      FACTOR_REGION.Factor%TYPE
                     , cTextoFactor FACTOR_REGION.TextoFactor%TYPE );

   PROCEDURE ELIMINAR( nCodCia     FACTOR_REGION.CodCia%TYPE
                     , nCodEmpresa FACTOR_REGION.CodEmpresa%TYPE
                     , cIdTipoSeg  FACTOR_REGION.IdTipoSeg%TYPE
                     , cPlanCob    FACTOR_REGION.PlanCob%TYPE
                     , nCodPaquete FACTOR_REGION.CodPaquete%TYPE
                     , cCodRegion  FACTOR_REGION.CodRegion%TYPE );

   FUNCTION SERVICIO_XML( nCodCia     FACTOR_REGION.CodCia%TYPE
                        , nCodEmpresa FACTOR_REGION.CodEmpresa%TYPE
                        , cIdTipoSeg  FACTOR_REGION.IdTipoSeg%TYPE
                        , cPlanCob    FACTOR_REGION.PlanCob%TYPE
                        , nCodPaquete FACTOR_REGION.CodPaquete%TYPE
                        , cCodRegion  FACTOR_REGION.CodRegion%TYPE ) RETURN XMLTYPE;

   PROCEDURE REGISTRAR( nCodCia         COTIZACIONES.CodCia%TYPE
                      , nCodEmpresa     COTIZACIONES.CodEmpresa%TYPE
                      , nIdCotizacion   COTIZACIONES.IdCotizacion%TYPE
                      , xXMLDatosRegion XMLTYPE );

   FUNCTION TEXTO_FACTOR( nCodCia     FACTOR_REGION.CodCia%TYPE
                        , nCodEmpresa FACTOR_REGION.CodEmpresa%TYPE
                        , cIdTipoSeg  FACTOR_REGION.IdTipoSeg%TYPE
                        , cPlanCob    FACTOR_REGION.PlanCob%TYPE
                        , nCodPaquete FACTOR_REGION.CodPaquete%TYPE
                        , cCodRegion  FACTOR_REGION.CodRegion%TYPE ) RETURN VARCHAR2;                      

   PROCEDURE REGISTRAR_TEXTO( nCodCia         COTIZACIONES.CodCia%TYPE
                            , nCodEmpresa     COTIZACIONES.CodEmpresa%TYPE
                            , nIdCotizacion   COTIZACIONES.IdCotizacion%TYPE
                            , xXMLDatosRegion XMLTYPE );

END OC_FACTOR_REGION;
/
create or replace PACKAGE BODY          OC_FACTOR_REGION IS
   PROCEDURE INSERTAR( nCodCia      FACTOR_REGION.CodCia%TYPE
                     , nCodEmpresa  FACTOR_REGION.CodEmpresa%TYPE
                     , cIdTipoSeg   FACTOR_REGION.IdTipoSeg%TYPE
                     , cPlanCob     FACTOR_REGION.PlanCob%TYPE
                     , nCodPaquete  FACTOR_REGION.CodPaquete%TYPE
                     , cCodRegion   FACTOR_REGION.CodRegion%TYPE
                     , nFactor      FACTOR_REGION.Factor%TYPE
                     , cTextoFactor FACTOR_REGION.TextoFactor%TYPE ) IS
   BEGIN
       INSERT INTO FACTOR_REGION
          ( CodCia, CodEmpresa, IdTipoSeg, PlanCob, CodPaquete, CodRegion, Factor, TextoFactor )
       VALUES ( nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, nCodPaquete, cCodRegion, nFactor, cTextoFactor );
   END INSERTAR;

   PROCEDURE ELIMINAR( nCodCia     FACTOR_REGION.CodCia%TYPE
                     , nCodEmpresa FACTOR_REGION.CodEmpresa%TYPE
                     , cIdTipoSeg  FACTOR_REGION.IdTipoSeg%TYPE
                     , cPlanCob    FACTOR_REGION.PlanCob%TYPE
                     , nCodPaquete FACTOR_REGION.CodPaquete%TYPE
                     , cCodRegion  FACTOR_REGION.CodRegion%TYPE ) IS
   BEGIN
       DELETE FACTOR_REGION
       WHERE  CodCia     = nCodCia
         AND  CodEmpresa = nCodEmpresa
         AND  IdTipoSeg  = cIdTipoSeg
         AND  PlanCob    = cPlanCob
         AND  CodPaquete = nCodPaquete
         AND  CodRegion  = cCodRegion;
   END ELIMINAR;

   FUNCTION SERVICIO_XML( nCodCia     FACTOR_REGION.CodCia%TYPE
                        , nCodEmpresa FACTOR_REGION.CodEmpresa%TYPE
                        , cIdTipoSeg  FACTOR_REGION.IdTipoSeg%TYPE
                        , cPlanCob    FACTOR_REGION.PlanCob%TYPE
                        , nCodPaquete FACTOR_REGION.CodPaquete%TYPE
                        , cCodRegion  FACTOR_REGION.CodRegion%TYPE ) RETURN XMLTYPE IS
      xResultado  XMLTYPE;
   BEGIN
      SELECT XMLROOT(
             XMLELEMENT("DATA",
                        XMLELEMENT("IdTipoSeg"  , A.IdTipoSeg), 
                        XMLELEMENT("PlanCob"    , A.PlanCob),
                        XMLELEMENT("CodPaquete" , A.CodPaquete),
                        XMLELEMENT("DescPaquete", C.DescPaquete),
                        XMLAGG( XMLELEMENT("REGION", XMLFOREST( A.CodRegion                                                  "CodRegion",
                                                                OC_VALORES_DE_LISTAS.BUSCA_LVALOR('REGIONFACT', A.CodRegion) "DescRegion",
                                                                A.Factor                                                     "Factor"
                                                              )
                                          )
                              )
                       ), VERSION '1.0" encoding="UTF-8')
       INTO   xResultado
       FROM   FACTOR_REGION     A
          ,   PAQUETE_COMERCIAL C
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
         AND  A.CodRegion  = NVL( cCodRegion, CodRegion )
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
                      , xXMLDatosRegion XMLTYPE ) IS
      cExisteFactor  VARCHAR2(1) := 'N';
      --
      CURSOR cRegistros IS
         WITH
         PRINCIPAL_DATA AS ( SELECT XT1.*
                             FROM   XMLTABLE('/DATA'
                                       PASSING xXMLDatosRegion
                                          COLUMNS 
                                             IDetCotizacion NUMBER(14)   PATH 'IDetCotizacion',
                                             CodSubGrupo    VARCHAR2(20) PATH 'CodSubGrupo',
                                             CodPaquete     NUMBER(14)   PATH 'CodPaquete',
                                             Region         XMLTYPE      PATH 'REGION' ) XT1
                           ),
         REGION_DATA   AS ( SELECT IDetCotizacion
                                 , CodSubGrupo
                                 , CodPaquete
                                 , XT2.*
                            FROM   PRINCIPAL_DATA P
                               ,   XMLTABLE('/REGION'
                                      PASSING P.Region
                                         COLUMNS 
                                            CodRegion VARCHAR2(6) PATH 'CodRegion',
                                            Factor    NUMBER(9,6) PATH 'Factor' ) XT2
                          )
         SELECT * FROM REGION_DATA;
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
              AND  TipoFactor     = 'REGION';
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
              cExisteFactor := 'N';
         END;
         --
         IF cExisteFactor = 'N' THEN
            INSERT INTO COTIZACIONES_DETALLE_FACTOR
                   (CodCia , CodEmpresa , IdCotizacion , IDetCotizacion  , TipoFactor, CodFactor  , Factor )
            VALUES (nCodCia, nCodEmpresa, nIdCotizacion, x.IDetCotizacion, 'REGION'  , x.CodRegion, x.Factor );
         ELSE
            --
            UPDATE COTIZACIONES_DETALLE_FACTOR
            SET    CodFactor = x.CodRegion
              ,    Factor    = x.Factor
            WHERE  CodCia         = nCodCia
              AND  CodEmpresa     = nCodEmpresa
              AND  IdCotizacion   = nIdCotizacion
              AND  IDetCotizacion = x.IDetCotizacion
              AND  TipoFactor     = 'REGION';
         END IF;
         --
         --Actualizo el FactorAjuste en COTIZACIONES_DETALLE
         GT_COTIZACIONES_DETALLE.RECALCULA_FACTORAJUSTE( nCodCia, nCodEmpresa, nIdCotizacion, x.IDetCotizacion, x.CodSubGrupo );
         --           
      END LOOP;
      --COMMIT;
   END REGISTRAR;

   FUNCTION TEXTO_FACTOR( nCodCia     FACTOR_REGION.CodCia%TYPE
                        , nCodEmpresa FACTOR_REGION.CodEmpresa%TYPE
                        , cIdTipoSeg  FACTOR_REGION.IdTipoSeg%TYPE
                        , cPlanCob    FACTOR_REGION.PlanCob%TYPE
                        , nCodPaquete FACTOR_REGION.CodPaquete%TYPE
                        , cCodRegion  FACTOR_REGION.CodRegion%TYPE ) RETURN VARCHAR2 IS
      cTextoFactor   FACTOR_REGION.TextoFactor%TYPE;                  
   BEGIN
      BEGIN
         SELECT NVL(TextoFactor, ' ')
         INTO   cTextoFactor
         FROM   FACTOR_REGION
         WHERE  CodCia     = nCodCia
           AND  CodEmpresa = nCodEmpresa
           AND  IdTipoSeg  = cIdTipoSeg
           AND  PlanCob    = cPlanCob
           AND  CodPaquete = nCodPaquete
           AND  CodRegion  = cCodRegion;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
           RAISE_APPLICATION_ERROR(-20200,'No es posible determinar texto para Elegibilidad para el Factor de región');         
      END;
      RETURN cTextoFactor;
   END TEXTO_FACTOR;   

   PROCEDURE REGISTRAR_TEXTO( nCodCia         COTIZACIONES.CodCia%TYPE
                            , nCodEmpresa     COTIZACIONES.CodEmpresa%TYPE
                            , nIdCotizacion   COTIZACIONES.IdCotizacion%TYPE
                            , xXMLDatosRegion XMLTYPE ) IS
      cTextoFactor   FACTOR_REGION.TextoFactor%TYPE;
      cTextoRegion   VALORES_DE_LISTAS.DescValLst%TYPE;
      cIdTipoSeg     COTIZACIONES.IdTipoSeg%TYPE;
      cPlanCob       COTIZACIONES.PlanCob%TYPE;
      --
      CURSOR cRegistros IS
         WITH
         PRINCIPAL_DATA AS ( SELECT XT1.*
                             FROM   XMLTABLE('/DATA'
                                       PASSING xXMLDatosRegion
                                          COLUMNS 
                                             IDetCotizacion NUMBER(14)   PATH 'IDetCotizacion',
                                             CodSubGrupo    VARCHAR2(20) PATH 'CodSubGrupo',
                                             CodPaquete     NUMBER(14)   PATH 'CodPaquete',
                                             Region         XMLTYPE      PATH 'REGION' ) XT1
                           ),
         REGION_DATA   AS ( SELECT IDetCotizacion
                                 , CodSubGrupo
                                 , CodPaquete
                                 , XT2.*
                            FROM   PRINCIPAL_DATA P
                               ,   XMLTABLE('/REGION'
                                      PASSING P.Region
                                         COLUMNS 
                                            CodRegion VARCHAR2(6) PATH 'CodRegion',
                                            Factor    NUMBER(9,6) PATH 'Factor' ) XT2
                          )
         SELECT * FROM REGION_DATA;
   BEGIN
      FOR x IN cRegistros LOOP 
          SELECT IdTipoSeg, PlanCob
          INTO   cIdTipoSeg, cPlanCob
          FROM   COTIZACIONES 
          WHERE  CodCia       = nCodCia
            AND  CodEmpresa   = nCodEmpresa
            AND  IdCotizacion = nIdCotizacion;
         --
         cTextoRegion := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('REGIONFACT', X.CodRegion);
         cTextoFactor := OC_FACTOR_REGION.TEXTO_FACTOR(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, X.CodPaquete, X.CodRegion);
         --
         UPDATE COTIZACIONES
         SET    DescElegibilidad = REPLACE(DescElegibilidad,'"','') || ' ' || cTextoFactor || ' ' || cTextoRegion
         WHERE  CodCia       = nCodCia
           AND  CodEmpresa   = nCodEmpresa
           AND  IdCotizacion = nIdCotizacion; 
         --           
      END LOOP;
      --COMMIT;
   END REGISTRAR_TEXTO;

END OC_FACTOR_REGION;
