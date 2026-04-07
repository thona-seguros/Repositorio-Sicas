CREATE OR REPLACE PACKAGE THONAPI.CATALOGOS_SIGO IS
    FUNCTION LISTAS_DE_VALORES( cCodLista  VALORES_DE_LISTAS.CodLista%TYPE ) RETURN CLOB;
    --
    FUNCTION PLANES_DE_PAGOS( nCodCia      PLAN_DE_PAGOS.CodCia%TYPE
                            , nCodEmpresa  PLAN_DE_PAGOS.CodEmpresa%TYPE ) RETURN CLOB;
    --
    FUNCTION CODIGOS_POSTALES( cCodPostal     APARTADO_POSTAL.Codigo_Postal%TYPE
                             , cCodPais       APARTADO_POSTAL.CodPais%TYPE
                             , cCodEstado     APARTADO_POSTAL.CodEstado%TYPE
                             , cCodCiudad     APARTADO_POSTAL.CodCiudad%TYPE
                             , cCodMunicipio  APARTADO_POSTAL.CodMunicipio%TYPE
                             , cCodColonia    COLONIA.Codigo_Colonia%TYPE ) RETURN CLOB;
    --
    FUNCTION CATEGORIA( nCodCia          CATEGORIAS.CodCia%TYPE
                      , nCodEmpresa      CATEGORIAS.CodEmpresa%TYPE
                      , cCodTipoNegocio  CATEGORIAS.CodTipoNegocio%TYPE ) RETURN CLOB;
    --
    FUNCTION NOTAS_ACLARATORIAS( nCodCia      CLAUSULAS.CodCia%TYPE
                               , nCodEmpresa  CLAUSULAS.CodEmpresa%TYPE ) RETURN CLOB;
    --
    FUNCTION PAQUETES_COMERCIALES( nCodCia      PAQUETE_COMERCIAL.CodCia%TYPE
                                 , nCodEmpresa  PAQUETE_COMERCIAL.CodEmpresa%TYPE
                                 , cIdTipoSeg   PAQUETE_COMERCIAL.IdTipoSeg%TYPE
                                 , cPlanCob     PAQUETE_COMERCIAL.PlanCob%TYPE ) RETURN CLOB;
    --
    FUNCTION TIPOS_DE_SEGURO( nCodCia       TIPOS_DE_SEGUROS.CodCia%TYPE
                            , nCodEmpresa   TIPOS_DE_SEGUROS.CodEmpresa%TYPE
                            , cCodProducto  VARCHAR ) RETURN CLOB;
    --
    FUNCTION COTIZADORES_TIPOSEG( nCodCia        COTIZADOR_TIPOSEG.CodCia%TYPE
                                , nCodEmpresa    COTIZADOR_TIPOSEG.CodEmpresa%TYPE
                                , cCodCotizador  COTIZADOR_TIPOSEG.CodCotizador%TYPE ) RETURN CLOB;
    --
    FUNCTION PLANES_COBERTURAS( nCodCia      PLAN_COBERTURAS.CodCia%TYPE
                              , nCodEmpresa  PLAN_COBERTURAS.CodEmpresa%TYPE
                              , cIdTipoSeg   PLAN_COBERTURAS.IdTipoSeg%TYPE ) RETURN CLOB;
    --
    FUNCTION COTIZADORES_PLANCOB( nCodCia        COTIZADOR_PLANCOB.CodCia%TYPE
                                , nCodEmpresa    COTIZADOR_PLANCOB.CodEmpresa%TYPE
                                , cCodCotizador  COTIZADOR_PLANCOB.CodCotizador%TYPE
                                , cIdTipoSeg     COTIZADOR_PLANCOB.IdTipoSeg%TYPE ) RETURN CLOB;
    --
    FUNCTION TIPOS_REASEGURO( nCodCia  REA_RIESGOS.CodCia%TYPE ) RETURN CLOB;
    --
    FUNCTION ESTADOS_PAIS( cCodPais  PROVINCIA.CodPais%TYPE ) RETURN CLOB;
    --
    FUNCTION REGIMEN_FISCAL RETURN CLOB;
    --
    FUNCTION USO_CFDI( nCodCia       FACT_ELECT_USO_CFDI.CodCia%TYPE
                     , nIdRegFisSat  CAT_REGIMEN_FISCAL.IdRegFisSat%TYPE
                     , cTipoPersona  CAT_REGIMEN_FISCAL.TipoPersona%TYPE ) RETURN CLOB;
    --
    FUNCTION OBJETO_IMPUESTO( nCodCia  FACT_ELECT_OBJETO_IMPUESTO.CodCia%TYPE ) RETURN CLOB;
    --
    FUNCTION ESTRUCTURA_AGENTES( nCodCia      AGENTES.CodCia%TYPE
                               , nCodEmpresa  AGENTES.CodEmpresa%TYPE
                               , nCodAgente   AGENTES.Cod_Agente%TYPE ) RETURN CLOB;
    --
    FUNCTION ENDOSOS_PRODUCTO( nCodCia      CLAUSULAS_TIPOS_SEGUROS.CodCia%TYPE
                             , nCodEmpresa  CLAUSULAS_TIPOS_SEGUROS.CodEmpresa%TYPE 
                             , cIdTipoSeg   CLAUSULAS_TIPOS_SEGUROS.IdTipoSeg%TYPE ) RETURN CLOB;
END CATALOGOS_SIGO;
/

CREATE OR REPLACE PACKAGE BODY THONAPI.CATALOGOS_SIGO IS
    FUNCTION LISTAS_DE_VALORES( cCodLista  VALORES_DE_LISTAS.CodLista%TYPE ) RETURN CLOB IS
        cJson         CLOB;
        cTemp         CLOB;
        cCodigo       VALORES_DE_LISTAS.CodValor%TYPE;
        cDescripcion  VALORES_DE_LISTAS.DescValLst%TYPE;
        --
        CURSOR c_ListVal IS
            SELECT CodValor    Codigo
                 , DescValLst  Descripcion
            FROM   VALORES_DE_LISTAS
            WHERE  CodLista = cCodLista
            ORDER BY CodValor;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(cJson, TRUE);
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH('[ '), '[ ');
        --
        OPEN c_ListVal;
        LOOP
            FETCH c_ListVal INTO cCodigo, cDescripcion;
            EXIT WHEN c_ListVal%NOTFOUND;
            cTemp := '{
                        "CODIGO": "' || cCodigo || '",
                        "DESCRIPCION": "' || cDescripcion || '"
                      }';
            IF DBMS_LOB.GETLENGTH(cJson) > 2 THEN
                DBMS_LOB.WRITEAPPEND(cJson, 2, ', ');
            END IF;
            DBMS_LOB.WRITEAPPEND(cJson, LENGTH(cTemp), cTemp);
        END LOOP;
        CLOSE c_ListVal;
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH(' ]'), ' ]');
        RETURN cJson;
    END LISTAS_DE_VALORES;

    FUNCTION PLANES_DE_PAGOS( nCodCia      PLAN_DE_PAGOS.CodCia%TYPE
                            , nCodEmpresa  PLAN_DE_PAGOS.CodEmpresa%TYPE ) RETURN CLOB IS
        cJson         CLOB;
        cTemp         CLOB;
        cCodPlanPago  PLAN_DE_PAGOS.CodPlanPago%TYPE;
        cDescPlan     PLAN_DE_PAGOS.DescPlan%TYPE;
        --
        CURSOR c_PlanPagos IS
            SELECT CodPlanPago, DescPlan
            FROM   PLAN_DE_PAGOS
            WHERE  CodCia     = nCodCia
              AND  CodEmpresa = nCodEmpresa
              AND  StsPlan    = 'ACT'
            ORDER BY CodPlanPago;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(cJson, TRUE);
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH('[ '), '[ ');
        --
        OPEN c_PlanPagos;
        LOOP
            FETCH c_PlanPagos INTO cCodPlanPago, cDescPlan;
            EXIT WHEN c_PlanPagos%NOTFOUND;
            cTemp := '{
                        "CODPLANPAGO": "' || cCodPlanPago || '",
                        "DESCPLAN": "' || cDescPlan || '"
                      }';
            IF DBMS_LOB.GETLENGTH(cJson) > 2 THEN
                DBMS_LOB.WRITEAPPEND(cJson, 2, ', ');
            END IF;
            DBMS_LOB.WRITEAPPEND(cJson, LENGTH(cTemp), cTemp);
        END LOOP;
        CLOSE c_PlanPagos;
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH(' ]'), ' ]');
        RETURN cJson;
    END PLANES_DE_PAGOS;

    FUNCTION CODIGOS_POSTALES( cCodPostal     APARTADO_POSTAL.Codigo_Postal%TYPE
                             , cCodPais       APARTADO_POSTAL.CodPais%TYPE
                             , cCodEstado     APARTADO_POSTAL.CodEstado%TYPE
                             , cCodCiudad     APARTADO_POSTAL.CodCiudad%TYPE
                             , cCodMunicipio  APARTADO_POSTAL.CodMunicipio%TYPE
                             , cCodColonia    COLONIA.Codigo_Colonia%TYPE ) RETURN CLOB IS
        cJson         CLOB;
        cTemp         CLOB;
        cCodPostal1      APARTADO_POSTAL.Codigo_Postal%TYPE;
        cCodPais1        APARTADO_POSTAL.CodPais%TYPE;
        cDescPais        PAIS.DescPais%TYPE;
        cCodEstado1      APARTADO_POSTAL.CodEstado%TYPE;
        cDescEstado      PROVINCIA.DescEstado%TYPE;
        cCodCiudad1      APARTADO_POSTAL.CodCiudad%TYPE;
        cDescCiudad      DISTRITO.DescCiudad%TYPE;
        cCodMunicipio1   APARTADO_POSTAL.CodMunicipio%TYPE;
        cDescMunicipio   CORREGIMIENTO.DescMunicipio%TYPE;
        cCodColonia1     COLONIA.Codigo_Colonia%TYPE;
        cDescColonia     COLONIA.Descripcion_Colonia%TYPE;
        --
        CURSOR c_CodPostal IS
            SELECT DISTINCT
                   CP.Codigo_Postal
                 , PA.CodPais
                 , PA.DescPais
                 , P.CodEstado
                 , P.DescEstado
                 , X.CodCiudad
                 , X.DescCiudad
                 , M.CodMunicipio
                 , M.DescMunicipio
                 , C.Codigo_Colonia
                 , C.Descripcion_Colonia
            FROM APARTADO_POSTAL CP
                INNER JOIN CORREGIMIENTO M ON M.CodMunicipio = CP.CodMunicipio
                                          AND M.CodPais      = CP.CodPais
                                          AND M.CodEstado    = CP.CodEstado
                                          AND M.CodCiudad    = CP.CodCiudad 
                INNER JOIN COLONIA C ON C.CodPais       = CP.CodPais
                                    AND C.CodEstado     = CP.CodEstado
                                    AND C.CodCiudad     = CP.CodCiudad
                                    AND C.CodMunicipio  = M.CodMunicipio
                                    AND C.Codigo_Postal = CP.Codigo_Postal
                INNER JOIN DISTRITO X ON X.CodPais   = CP.CodPais
                                     AND X.CodEstado = CP.CodEstado
                                     AND X.CodCiudad = CP.CodCiudad
                INNER JOIN PROVINCIA P ON P.CodPais   = CP.CodPais
                                      AND P.CodEstado = CP.CodEstado 
                INNER JOIN PAIS PA ON PA.CodPais = CP.CodPais                                   
            WHERE CP.Codigo_Postal  =  NVL(cCodPostal   , CP.Codigo_Postal)
              AND CP.CodPais        =  NVL(cCodPais     , CP.CodPais      )
              AND CP.CodEstado      =  NVL(cCodEstado   , CP.CodEstado    )
              AND CP.CodCiudad      =  NVL(cCodCiudad   , CP.CodCiudad    )
              AND CP.CodMunicipio   =  NVL(cCodMunicipio, CP.CodMunicipio )
              AND C.Codigo_Colonia  =  NVL(cCodColonia  , C.Codigo_Colonia)
            ORDER BY CodPais, CodEstado, CodCiudad, CodMunicipio, Codigo_Colonia;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(cJson, TRUE);
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH('[ '), '[ ');
        --
        OPEN c_CodPostal;
        LOOP
            FETCH c_CodPostal INTO 
                cCodPostal1, cCodPais1, cDescPais, cCodEstado1, cDescEstado, cCodCiudad1, cDescCiudad, cCodMunicipio1, cDescMunicipio, cCodColonia1, cDescColonia;
            EXIT WHEN c_CodPostal%NOTFOUND;
            cTemp := '{
                        "CODPOSTAL": "' || cCodPostal1 || '",
                        "CODPAIS": "' || cCodPais1 || '",
                        "DESCPAIS": "' || cDescPais || '",
                        "CODESTADO": "' || cCodEstado1 || '",
                        "DESCESTADO": "' || cDescEstado || '",
                        "CODCIUDAD": "' || cCodCiudad1 || '",
                        "DESCCIUDAD": "' || cDescCiudad || '",
                        "CODMUNICIPIO": "' || cCodMunicipio1 || '",
                        "DESCMUNICIPIO": "' || cDescMunicipio || '",
                        "CODCOLONIA": "' || cCodColonia1 || '",
                        "DESCCOLONIA": "' || cDescColonia || '"
                      }';
            IF DBMS_LOB.GETLENGTH(cJson) > 2 THEN
                DBMS_LOB.WRITEAPPEND(cJson, 2, ', ');
            END IF;
            DBMS_LOB.WRITEAPPEND(cJson, LENGTH(cTemp), cTemp);
        END LOOP;
        CLOSE c_CodPostal;
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH(' ]'), ' ]');
        RETURN cJson;
    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERRNNNOR : '  || SQLERRM);
    END CODIGOS_POSTALES;

    FUNCTION CATEGORIA( nCodCia          CATEGORIAS.CodCia%TYPE
                      , nCodEmpresa      CATEGORIAS.CodEmpresa%TYPE
                      , cCodTipoNegocio  CATEGORIAS.CodTipoNegocio%TYPE ) RETURN CLOB IS
        cJson        CLOB;
        cTemp        CLOB;
        cCodCatego   CATEGORIAS.CodCatego%TYPE;
        cDescCatego  CATEGORIAS.DescCatego%TYPE;
        --
        CURSOR c_Categorias IS
            SELECT CodCatego, DescCatego
            FROM   CATEGORIAS
            WHERE  CodCia         = nCodCia
              AND  CodEmpresa     = nCodEmpresa
              AND  CodTipoNegocio = cCodTipoNegocio;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(cJson, TRUE);
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH('[ '), '[ ');
        --
        OPEN c_Categorias;
        LOOP
            FETCH c_Categorias INTO cCodCatego, cDescCatego;
            EXIT WHEN c_Categorias%NOTFOUND;
            cTemp := '{
                        "CODCATEGO": "' || cCodCatego || '",
                        "DESCCATEGO": "' || cDescCatego || '"
                      }';
            IF DBMS_LOB.GETLENGTH(cJson) > 2 THEN
                DBMS_LOB.WRITEAPPEND(cJson, 2, ', ');
            END IF;
            DBMS_LOB.WRITEAPPEND(cJson, LENGTH(cTemp), cTemp);
        END LOOP;
        CLOSE c_Categorias;
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH(' ]'), ' ]');
        RETURN cJson;
    END CATEGORIA;

    FUNCTION NOTAS_ACLARATORIAS( nCodCia      CLAUSULAS.CodCia%TYPE
                               , nCodEmpresa  CLAUSULAS.CodEmpresa%TYPE ) RETURN CLOB IS
        cJson        CLOB;
        cTemp        CLOB;
        cCodClausula    CLAUSULAS.CodClausula%TYPE;
        cTextoClausula  CLAUSULAS.TextoClausula%TYPE;
        --
        CURSOR c_Clausulas IS
            SELECT CodClausula, TextoClausula
            FROM   CLAUSULAS
            WHERE  CodCia       = nCodCia
              AND  CodEmpresa   = nCodEmpresa
              AND  DescClausula = 'NOTAS ACLARATORIAS'
            ORDER BY CodClausula;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(cJson, TRUE);
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH('[ '), '[ ');
        --
        OPEN c_Clausulas;
        LOOP
            FETCH c_Clausulas INTO cCodClausula, cTextoClausula;
            EXIT WHEN c_Clausulas%NOTFOUND;
            cTemp := '{
                        "CODCLAUSULA": "' || cCodClausula || '",
                        "TEXTOCLAUSULA": "' || cTextoClausula || '"
                      }';
            IF DBMS_LOB.GETLENGTH(cJson) > 2 THEN
                DBMS_LOB.WRITEAPPEND(cJson, 2, ', ');
            END IF;
            DBMS_LOB.WRITEAPPEND(cJson, LENGTH(cTemp), cTemp);
        END LOOP;
        CLOSE c_Clausulas;
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH(' ]'), ' ]');
        RETURN cJson;
    END NOTAS_ACLARATORIAS;

    FUNCTION PAQUETES_COMERCIALES( nCodCia      PAQUETE_COMERCIAL.CodCia%TYPE
                                 , nCodEmpresa  PAQUETE_COMERCIAL.CodEmpresa%TYPE
                                 , cIdTipoSeg   PAQUETE_COMERCIAL.IdTipoSeg%TYPE
                                 , cPlanCob     PAQUETE_COMERCIAL.PlanCob%TYPE ) RETURN CLOB IS
        cJson         CLOB;
        cTemp         CLOB;
        cCodPaquete   PAQUETE_COMERCIAL.CodPaquete%TYPE;
        cDescPaquete  PAQUETE_COMERCIAL.DescPaquete%TYPE;
        --
        CURSOR c_Paquetes IS
            SELECT CodPaquete, DescPaquete
            FROM   PAQUETE_COMERCIAL
            WHERE  CodCia     = nCodCia
              AND  CodEmpresa = nCodEmpresa
              AND  IdTipoSeg  = cIdTipoSeg
              AND  PlanCob    = cPlanCob
            ORDER BY CodPaquete;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(cJson, TRUE);
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH('[ '), '[ ');
        --
        OPEN c_Paquetes;
        LOOP
            FETCH c_Paquetes INTO cCodPaquete, cDescPaquete;
            EXIT WHEN c_Paquetes%NOTFOUND;
            cTemp := '{
                        "CODPAQUETE": "' || cCodPaquete || '",
                        "DESCPAQUETE": "' || cDescPaquete || '"
                      }';
            IF DBMS_LOB.GETLENGTH(cJson) > 2 THEN
                DBMS_LOB.WRITEAPPEND(cJson, 2, ', ');
            END IF;
            DBMS_LOB.WRITEAPPEND(cJson, LENGTH(cTemp), cTemp);
        END LOOP;
        CLOSE c_Paquetes;
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH(' ]'), ' ]');
        RETURN cJson;
    END PAQUETES_COMERCIALES;

    FUNCTION TIPOS_DE_SEGURO( nCodCia       TIPOS_DE_SEGUROS.CodCia%TYPE
                            , nCodEmpresa   TIPOS_DE_SEGUROS.CodEmpresa%TYPE
                            , cCodProducto  VARCHAR ) RETURN CLOB IS
        cJson         CLOB;
        cTemp         CLOB;
        cIdTipoSeg    TIPOS_DE_SEGUROS.IdTipoSeg%TYPE;
        cDescripcion  TIPOS_DE_SEGUROS.Descripcion%TYPE;
        --
        CURSOR c_TiposSeguros IS
            SELECT DISTINCT tp.IdTipoSeg, tp.Descripcion
            FROM   TIPOS_DE_SEGUROS  tp
               ,   PLAN_COBERTURAS   pc
            WHERE  pc.CodCia     = tp.CodCia
              AND  pc.CodEmpresa = tp.CodEmpresa
              AND  pc.IdTipoSeg  = tp.IdTipoSeg
              AND  tp.CodCia     = nCodCia
              AND  tp.CodEmpresa = nCodEmpresa
              AND  tp.StsTipSeg  = 'ACT'
              AND  (  (cCodProducto = 'VD' AND tp.CodTipoPlan = '010')
                   OR (cCodProducto = 'GM' AND tp.CodTipoPlan = '030' AND pc.CodTipoPlan IN ('034','35','036'))
                   OR (cCodProducto = 'AP' AND tp.CodTipoPlan = '030' AND pc.CodTipoPlan NOT IN ('034','35','036'))
                   OR (cCodProducto = 'MU' AND tp.CodTipoPlan = '099' ) )
            ORDER BY tp.IdTipoSeg;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(cJson, TRUE);
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH('[ '), '[ ');
        --
        OPEN c_TiposSeguros;
        LOOP
            FETCH c_TiposSeguros INTO cIdTipoSeg, cDescripcion;
            EXIT WHEN c_TiposSeguros%NOTFOUND;
            cTemp := '{
                        "IDTIPOSEG": "' || cIdTipoSeg || '",
                        "DESCRIPCION": "' || cDescripcion || '"
                      }';
            IF DBMS_LOB.GETLENGTH(cJson) > 2 THEN
                DBMS_LOB.WRITEAPPEND(cJson, 2, ', ');
            END IF;
            DBMS_LOB.WRITEAPPEND(cJson, LENGTH(cTemp), cTemp);
        END LOOP;
        CLOSE c_TiposSeguros;
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH(' ]'), ' ]');
        RETURN cJson;
    END TIPOS_DE_SEGURO;

    FUNCTION COTIZADORES_TIPOSEG( nCodCia        COTIZADOR_TIPOSEG.CodCia%TYPE
                                , nCodEmpresa    COTIZADOR_TIPOSEG.CodEmpresa%TYPE
                                , cCodCotizador  COTIZADOR_TIPOSEG.CodCotizador%TYPE ) RETURN CLOB IS
        cJson         CLOB;
        cTemp         CLOB;
        cIdTipoSeg    COTIZADOR_TIPOSEG.IdTipoSeg%TYPE;
        cDescripcion  TIPOS_DE_SEGUROS.Descripcion%TYPE;
        --
        CURSOR c_CotizadorTipoSeg IS
            SELECT DISTINCT IdTipoSeg, OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(CodCia, CodEmpresa, IdTipoSeg) Descripcion
            FROM   COTIZADOR_TIPOSEG
            WHERE  CodCia        = nCodCia
              AND  CodEmpresa    = nCodEmpresa
              AND  CodCotizador  = cCodCotizador
              AND  StsTipoSegCot = 'ACTIVO'
            ORDER BY IdTipoSeg;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(cJson, TRUE);
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH('[ '), '[ ');
        --
        OPEN c_CotizadorTipoSeg;
        LOOP
            FETCH c_CotizadorTipoSeg INTO cIdTipoSeg, cDescripcion;
            EXIT WHEN c_CotizadorTipoSeg%NOTFOUND;
            cTemp := '{
                        "IDTIPOSEG": "' || cIdTipoSeg || '",
                        "DESCRIPCION": "' || cDescripcion || '"
                      }';
            IF DBMS_LOB.GETLENGTH(cJson) > 2 THEN
                DBMS_LOB.WRITEAPPEND(cJson, 2, ', ');
            END IF;
            DBMS_LOB.WRITEAPPEND(cJson, LENGTH(cTemp), cTemp);
        END LOOP;
        CLOSE c_CotizadorTipoSeg;
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH(' ]'), ' ]');
        RETURN cJson;
    END COTIZADORES_TIPOSEG;

    FUNCTION PLANES_COBERTURAS( nCodCia      PLAN_COBERTURAS.CodCia%TYPE
                              , nCodEmpresa  PLAN_COBERTURAS.CodEmpresa%TYPE
                              , cIdTipoSeg   PLAN_COBERTURAS.IdTipoSeg%TYPE ) RETURN CLOB IS
        cJson         CLOB;
        cTemp         CLOB;
        cPlanCob      PLAN_COBERTURAS.PlanCob%TYPE;
        cDescPlanCob  PLAN_COBERTURAS.Desc_Plan%TYPE;
        --
        CURSOR c_PlanCoberturas IS
            SELECT PlanCob, Desc_Plan
            FROM   PLAN_COBERTURAS
            WHERE  CodCia      = nCodCia
              AND  CodEmpresa  = nCodEmpresa
              AND  IdTipoSeg   = cIdTipoSeg
              AND  Estado_Plan = 'ACT'
            ORDER BY PlanCob;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(cJson, TRUE);
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH('[ '), '[ ');
        --
        OPEN c_PlanCoberturas;
        LOOP
            FETCH c_PlanCoberturas INTO cPlanCob, cDescPlanCob;
            EXIT WHEN c_PlanCoberturas%NOTFOUND;
            cTemp := '{
                        "PLANCOB": "' || cPlanCob || '",
                        "DESCPLANCOB": "' || cDescPlanCob || '"
                      }';
            IF DBMS_LOB.GETLENGTH(cJson) > 2 THEN
                DBMS_LOB.WRITEAPPEND(cJson, 2, ', ');
            END IF;
            DBMS_LOB.WRITEAPPEND(cJson, LENGTH(cTemp), cTemp);
        END LOOP;
        CLOSE c_PlanCoberturas;
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH(' ]'), ' ]');
        RETURN cJson;
    END PLANES_COBERTURAS;

    FUNCTION COTIZADORES_PLANCOB( nCodCia        COTIZADOR_PLANCOB.CodCia%TYPE
                                , nCodEmpresa    COTIZADOR_PLANCOB.CodEmpresa%TYPE
                                , cCodCotizador  COTIZADOR_PLANCOB.CodCotizador%TYPE
                                , cIdTipoSeg     COTIZADOR_PLANCOB.IdTipoSeg%TYPE ) RETURN CLOB IS
        cJson         CLOB;
        cTemp         CLOB;
        cPlanCob      COTIZADOR_PLANCOB.PlanCob%TYPE;
        cDescPlanCob  PLAN_COBERTURAS.Desc_Plan%TYPE;
        --
        CURSOR c_CotizadorPlanCob IS
            SELECT DISTINCT PlanCob, SUBSTR(OC_PLAN_COBERTURAS.NOMBRE_PLANCOB(CodCia, CodEmpresa, IdTipoSeg, PlanCob),1,2000) DescPlanCob
            FROM   COTIZADOR_PLANCOB
            WHERE  CodCia       = nCodCia
              AND  CodEmpresa   = nCodEmpresa
              AND  CodCotizador = cCodCotizador
              AND IdTipoSeg     = cIdTipoSeg
              AND StsPlanCot    = 'ACTIVO'
            ORDER BY IdTipoSeg;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(cJson, TRUE);
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH('[ '), '[ ');
        --
        OPEN c_CotizadorPlanCob;
        LOOP
            FETCH c_CotizadorPlanCob INTO cPlanCob, cDescPlanCob;
            EXIT WHEN c_CotizadorPlanCob%NOTFOUND;
            cTemp := '{
                        "PLANCOB": "' || cPlanCob || '",
                        "DESCPLANCOB": "' || cDescPlanCob || '"
                      }';
            IF DBMS_LOB.GETLENGTH(cJson) > 2 THEN
                DBMS_LOB.WRITEAPPEND(cJson, 2, ', ');
            END IF;
            DBMS_LOB.WRITEAPPEND(cJson, LENGTH(cTemp), cTemp);
        END LOOP;
        CLOSE c_CotizadorPlanCob;
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH(' ]'), ' ]');
        RETURN cJson;
    END COTIZADORES_PLANCOB;

    FUNCTION TIPOS_REASEGURO( nCodCia  REA_RIESGOS.CodCia%TYPE ) RETURN CLOB IS
        cJson        CLOB;
        cTemp        CLOB;
        cCodRiesgo   REA_RIESGOS.CodRiesgo%TYPE;
        cDescRiesgo  REA_RIESGOS.DescRiesgo%TYPE;
        --
        CURSOR c_TipoReaseguro IS
            SELECT CodRiesgo, DescRiesgo
            FROM   REA_RIESGOS
            WHERE  CodCia              = nCodCia
              AND  IndAplicaCotizacion = 'S'
            ORDER BY CodRiesgo;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(cJson, TRUE);
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH('[ '), '[ ');
        --
        OPEN c_TipoReaseguro;
        LOOP
            FETCH c_TipoReaseguro INTO cCodRiesgo, cDescRiesgo;
            EXIT WHEN c_TipoReaseguro%NOTFOUND;
            cTemp := '{
                        "CODRIESGO": "' || cCodRiesgo || '",
                        "DESCRIESGO": "' || cDescRiesgo || '"
                      }';
            IF DBMS_LOB.GETLENGTH(cJson) > 2 THEN
                DBMS_LOB.WRITEAPPEND(cJson, 2, ', ');
            END IF;
            DBMS_LOB.WRITEAPPEND(cJson, LENGTH(cTemp), cTemp);
        END LOOP;
        CLOSE c_TipoReaseguro;
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH(' ]'), ' ]');
        RETURN cJson;
    END TIPOS_REASEGURO;
    --
    FUNCTION ESTADOS_PAIS( cCodPais  PROVINCIA.CodPais%TYPE ) RETURN CLOB IS
        cJson        CLOB;
        cTemp        CLOB;
        cCodEstado   PROVINCIA.CodEstado%TYPE;
        cDescEstado  PROVINCIA.DescEstado%TYPE;
        --
        CURSOR c_Estados IS
               SELECT CodEstado, DescEstado
               FROM   PROVINCIA
               WHERE  CodPais = cCodPais
               ORDER BY CodEstado;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(cJson, TRUE);
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH('[ '), '[ ');
        --
        OPEN c_Estados;
        LOOP
            FETCH c_Estados INTO cCodEstado, cDescEstado;
            EXIT WHEN c_Estados%NOTFOUND;
            cTemp := '{
                        "CODESTADO": "' || cCodEstado || '",
                        "DESCESTADO": "' || cDescEstado || '"
                      }';
            IF DBMS_LOB.GETLENGTH(cJson) > 2 THEN
                DBMS_LOB.WRITEAPPEND(cJson, 2, ', ');
            END IF;
            DBMS_LOB.WRITEAPPEND(cJson, LENGTH(cTemp), cTemp);
        END LOOP;
        CLOSE c_Estados;
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH(' ]'), ' ]');
        RETURN cJson;
    END ESTADOS_PAIS;
    --
    FUNCTION REGIMEN_FISCAL RETURN CLOB IS
        cJson             CLOB;
        cTemp             CLOB;
        nIdRegFisSat      CAT_REGIMEN_FISCAL.IdRegFisSat%TYPE;
        cDescTipoRegimen  CAT_REGIMEN_FISCAL.DescTipoRegimen%TYPE;
        cTipoPersona      CAT_REGIMEN_FISCAL.TipoPersona%TYPE;
        dFecIniVig        CAT_REGIMEN_FISCAL.FecIniVig%TYPE;
        dFecFinVig        CAT_REGIMEN_FISCAL.FecFinVig%TYPE;
        --      
        CURSOR c_RegimenFiscal IS
               SELECT IdRegFisSat
                    , DescTipoRegimen
                    , TipoPersona
                    , FecIniVig
                    , FecFinVig
               FROM   CAT_REGIMEN_FISCAL
               ORDER BY IdRegFisSat;
   BEGIN
        DBMS_LOB.CREATETEMPORARY(cJson, TRUE);
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH('[ '), '[ ');
        --
        OPEN c_RegimenFiscal;
        LOOP
            FETCH c_RegimenFiscal INTO nIdRegFisSat, cDescTipoRegimen, cTipoPersona, dFecIniVig, dFecFinVig;
            EXIT WHEN c_RegimenFiscal%NOTFOUND;
            cTemp := '{
                        "IDREGFISSAT": "' || nIdRegFisSat || '",
                        "DESCTIPOREGIMEN": "' || cDescTipoRegimen || '",
                        "TIPOPERSONA": "' || cTipoPersona || '",
                        "FECINIVIG": "' || TO_CHAR(dFecIniVig, 'DD/MM/YYYY') || '",
                        "FECFINVIG": "' || TO_CHAR(dFecFinVig, 'DD/MM/YYYY') || '"
                      }';
            IF DBMS_LOB.GETLENGTH(cJson) > 2 THEN
                DBMS_LOB.WRITEAPPEND(cJson, 2, ', ');
            END IF;
            DBMS_LOB.WRITEAPPEND(cJson, LENGTH(cTemp), cTemp);
        END LOOP;
        CLOSE c_RegimenFiscal;
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH(' ]'), ' ]');
        RETURN cJson;
    END REGIMEN_FISCAL;
    --
    FUNCTION USO_CFDI( nCodCia       FACT_ELECT_USO_CFDI.CodCia%TYPE
                     , nIdRegFisSat  CAT_REGIMEN_FISCAL.IdRegFisSat%TYPE
                     , cTipoPersona  CAT_REGIMEN_FISCAL.TipoPersona%TYPE ) RETURN CLOB IS
        cJson             CLOB;
        cTemp             CLOB;
        cCodUsoCfdi       FACT_ELECT_USO_CFDI.CodUsoCfdi%TYPE;
        cDescUsoCfdi      FACT_ELECT_USO_CFDI.DescUsoCfdi%TYPE;
        dFecIniVig        FACT_ELECT_USO_CFDI.FecIniVig%TYPE;
        dFecFinVig        FACT_ELECT_USO_CFDI.FecFinVig%TYPE;
        cIndPersFisica    FACT_ELECT_USO_CFDI.IndPersFisica%TYPE;
        cIndPersMoral     FACT_ELECT_USO_CFDI.IndPersMoral%TYPE;
        --      
        CURSOR c_UsoCFDI IS
               SELECT U.CodUsoCfdi
                    , U.DescUsoCfdi
                    , U.FecIniVig
                    , U.FecFinVig
                    , U.IndPersFisica
                    , U.IndPersMoral
               FROM   FACT_ELECT_USO_CFDI      U
                  ,   FACT_ELECT_USO_CFDI_REG  R
                  ,   CAT_REGIMEN_FISCAL       C
               WHERE  U.CodCia      = R.CodCia
                 AND  U.CodUsoCfdi  = R.CodUsoCfdi
                 AND  R.IdRegFisSat = C.IdRegFisSat
                 AND  U.CodCia      = nCodCia
                 AND  R.IdRegFisSat = nIdRegFisSat
                 AND  C.TipoPersona = cTipoPersona
               ORDER BY U.CodUsoCfdi;
   BEGIN
        DBMS_LOB.CREATETEMPORARY(cJson, TRUE);
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH('[ '), '[ ');
        --
        OPEN c_UsoCFDI;
        LOOP
            FETCH c_UsoCFDI INTO cCodUsoCfdi, cDescUsoCfdi, dFecIniVig, dFecFinVig, cIndPersFisica, cIndPersMoral;
            EXIT WHEN c_UsoCFDI%NOTFOUND;
            cTemp := '{
                        "CODUSOCFDI": "' || cCodUsoCfdi || '",
                        "DESCUSOCFDI": "' || cDescUsoCfdi || '",
                        "FECINIVIG": "' || TO_CHAR(dFecIniVig, 'DD/MM/YYYY') || '",
                        "FECFINVIG": "' || TO_CHAR(dFecFinVig, 'DD/MM/YYYY') || '",
                        "INDPERSFISICA": "' || cIndPersFisica || '",
                        "INDPERSMORAL": "' || cIndPersMoral || '"
                      }';
            IF DBMS_LOB.GETLENGTH(cJson) > 2 THEN
                DBMS_LOB.WRITEAPPEND(cJson, 2, ', ');
            END IF;
            DBMS_LOB.WRITEAPPEND(cJson, LENGTH(cTemp), cTemp);
        END LOOP;
        CLOSE c_UsoCFDI;
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH(' ]'), ' ]');
        RETURN cJson;
    END USO_CFDI;
    --
    FUNCTION OBJETO_IMPUESTO( nCodCia  FACT_ELECT_OBJETO_IMPUESTO.CodCia%TYPE ) RETURN CLOB IS
        cJson           CLOB;
        cTemp           CLOB;
        cCodObjetoImp   FACT_ELECT_OBJETO_IMPUESTO.CodObjetoImp%TYPE;
        cDescObjetoImp  FACT_ELECT_OBJETO_IMPUESTO.DescObjetoImp%TYPE;
        dFecIniVig      FACT_ELECT_OBJETO_IMPUESTO.FecIniVig%TYPE;
        dFecFinVig      FACT_ELECT_OBJETO_IMPUESTO.FecFinVig%TYPE;
        --      
        CURSOR c_ObjetoImpuesto IS
               SELECT CodObjetoImp
                    , DescObjetoImp
                    , FecIniVig
                    , FecFinVig
               FROM   FACT_ELECT_OBJETO_IMPUESTO
               WHERE  CodCia  = nCodCia
               ORDER BY CodObjetoImp;
   BEGIN
        DBMS_LOB.CREATETEMPORARY(cJson, TRUE);
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH('[ '), '[ ');
        --
        OPEN c_ObjetoImpuesto;
        LOOP
            FETCH c_ObjetoImpuesto INTO cCodObjetoImp, cDescObjetoImp, dFecIniVig, dFecFinVig;
            EXIT WHEN c_ObjetoImpuesto%NOTFOUND;
            cTemp := '{
                        "CODOBJETOIMP": "' || cCodObjetoImp || '",
                        "DESCOBJETOIMP": "' || cDescObjetoImp || '",
                        "FECINIVIG": "' || TO_CHAR(dFecIniVig, 'DD/MM/YYYY') || '",
                        "FECFINVIG": "' || TO_CHAR(dFecFinVig, 'DD/MM/YYYY') || '"
                      }';
            IF DBMS_LOB.GETLENGTH(cJson) > 2 THEN
                DBMS_LOB.WRITEAPPEND(cJson, 2, ', ');
            END IF;
            DBMS_LOB.WRITEAPPEND(cJson, LENGTH(cTemp), cTemp);
        END LOOP;
        CLOSE c_ObjetoImpuesto;
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH(' ]'), ' ]');
        RETURN cJson;
    END OBJETO_IMPUESTO;
    --
    FUNCTION ESTRUCTURA_AGENTES( nCodCia      AGENTES.CodCia%TYPE
                               , nCodEmpresa  AGENTES.CodEmpresa%TYPE
                               , nCodAgente   AGENTES.Cod_Agente%TYPE ) RETURN CLOB IS
        cJson               CLOB;
        cTemp               CLOB;
        cPuesto             VARCHAR2(50);
        cCodAgente          VARCHAR2(10);
        cCodAgenteAnt       VARCHAR2(10);
        cNomAgente          VARCHAR2(200);
        cTipoAgente         VARCHAR2(6);
        dFechaAlta          DATE;
        cStsAgente          VARCHAR2(10);
        cCanalComisVenta    VARCHAR2(6);
        cExcluirHonorarios  VARCHAR2(2);
        cPagoAutom          VARCHAR2(2);
        nEjecutivo          NUMBER(10);
        cNomEjecutivo       VARCHAR2(200);
        --      
        CURSOR c_Estructura IS
               SELECT Puesto
                    , CASE
                         WHEN TRIM(TO_CHAR(Dir_Regional)) IS NOT NULL AND TRIM(TO_CHAR(Promotoria)) IS NOT NULL AND TRIM(TO_CHAR(Codigo)) IS NOT NULL THEN TRIM(TO_CHAR(Codigo))
                         WHEN TRIM(TO_CHAR(Dir_Regional)) IS NOT NULL AND TRIM(TO_CHAR(Promotoria)) IS NOT NULL AND TRIM(TO_CHAR(Codigo)) IS NULL THEN TRIM(TO_CHAR(Promotoria))
                         WHEN TRIM(TO_CHAR(Dir_Regional)) IS NOT NULL AND TRIM(TO_CHAR(Promotoria)) IS NULL AND TRIM(TO_CHAR(Codigo)) IS NULL THEN TRIM(TO_CHAR(Dir_Regional))
                         WHEN TRIM(TO_CHAR(Dir_Regional)) IS NOT NULL AND TRIM(TO_CHAR(Promotoria)) IS NULL AND TRIM(TO_CHAR(Codigo)) IS NOT NULL THEN TRIM(TO_CHAR(Codigo))
                      END  CodAgente
                    , CASE
                         WHEN TRIM(TO_CHAR(Dir_Regional)) IS NOT NULL AND TRIM(TO_CHAR(Promotoria)) IS NOT NULL AND TRIM(TO_CHAR(Codigo)) IS NOT NULL THEN TRIM(TO_CHAR(Promotoria))
                         WHEN TRIM(TO_CHAR(Dir_Regional)) IS NOT NULL AND TRIM(TO_CHAR(Promotoria)) IS NOT NULL AND TRIM(TO_CHAR(Codigo)) IS NULL THEN TRIM(TO_CHAR(Dir_Regional))
                         WHEN TRIM(TO_CHAR(Dir_Regional)) IS NOT NULL AND TRIM(TO_CHAR(Promotoria)) IS NULL AND TRIM(TO_CHAR(Codigo)) IS NULL THEN NULL
                         WHEN TRIM(TO_CHAR(Dir_Regional)) IS NOT NULL AND TRIM(TO_CHAR(Promotoria)) IS NULL AND TRIM(TO_CHAR(Codigo)) IS NOT NULL THEN TRIM(TO_CHAR(Dir_Regional))
                      END  CodAgenteAnt
                    , NomAgente
                    , TipoAgente
                    , FechaAlta
                    , StsAgente        
                    , CanalComisVenta
                    , ExcluirHonorarios
                    , PagoAutom
                    , Ejecutivo
                    , NomEjecutivo
               FROM ( SELECT ( SELECT Descripcion FROM NIVEL N WHERE N.CodNivel = A.CodNivel AND N.CodCia = nCodCia )  Puesto
                           , SUBSTR(SYS_CONNECT_BY_PATH(A.Cod_Agente, '/'), 2)  Jerarquia
                           , DECODE( (SELECT CodNivel FROM AGENTES WHERE Cod_Agente  = nCodAgente), 1, nCodAgente,'')  Dir_Regional
                           , NVL(DECODE( A.CodNivel,
                                         1, (SUBSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.Cod_Agente, '/'), 2), ((INSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.Cod_Agente, '/'), 2), '/', 1, 1))+1), ((INSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.Cod_Agente, '/'),2), '/', 1, 2)) - ((INSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.Cod_Agente, '/'),2), '/', 1, 1))+1)))), 
                                         2, (SUBSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.Cod_Agente, '/'), 2), ((INSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.Cod_Agente, '/'), 2), '/', 1, 1))+1), ((LENGTH(SUBSTR(SYS_CONNECT_BY_PATH(A.Cod_Agente, '/'),2))) - (INSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.Cod_Agente, '/'),2), '/', 1, 1))))),
                                            (DECODE((SELECT CodNivel FROM AGENTES WHERE Cod_Agente  = nCodAgente), 
                                                     1, (SUBSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.Cod_Agente, '/'), 2), ((INSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.Cod_Agente, '/'), 2), '/', 1, 1))+1), ((INSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.Cod_Agente, '/'),2), '/', 1, 2)) - ((INSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.Cod_Agente, '/'),2), '/', 1, 1))+1)))), 
                                                     2, (SUBSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.Cod_Agente, '/'), 2), ((INSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.Cod_Agente, '/'), 2), '/', 1, 1))+1), ((LENGTH(SUBSTR(SYS_CONNECT_BY_PATH(A.Cod_Agente, '/'),2)) ) - (INSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.Cod_Agente, '/'),2), '/', 1, 1))))),
                                                        ''))
                                        ), '')  Promotoria
                           , DECODE( A.CodNivel, 1, ' ', 2, ' ', 3, A.Cod_Agente, '')  Codigo
                           , A.Tipo_Agente  TipoAgente
                           , A.FecAlta      FechaAlta
                           , DECODE(A.Est_Agente,'ACT','ACTIVO','SUS','SUSPENDIDO','SOL','SOLICITUD','INA','INACTICO',Est_Agente)  StsAgente
                           , A.CanalComisVenta  CanalComisVenta
                           , DECODE(A.IndExcluirHonorario,'S','SI','NO')  ExcluirHonorarios
                           , DECODE(A.IndPagosAutom,'S','SI','NO')  PagoAutom
                           , A.CodEjecutivo  Ejecutivo
                           , OC_EJECUTIVO_COMERCIAL.NOMBRE_EJECUTIVO(nCodCia, A.CodEjecutivo)  NomEjecutivo
                           , OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(A.Tipo_Doc_Identificacion, A.Num_Doc_Identificacion )  NomAgente
                      FROM   AGENTES A
                      CONNECT BY PRIOR A.Cod_Agente = A.Cod_Agente_Jefe
                        AND  A.CodCia     = nCodCia
                        AND  A.CodEmpresa = nCodEmpresa       
                      START WITH A.Cod_Agente = nCodAgente
                      ORDER SIBLINGS BY A.Cod_Agente);
   BEGIN
        DBMS_LOB.CREATETEMPORARY(cJson, TRUE);
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH('[ '), '[ ');
        --
        OPEN c_Estructura;
        LOOP
            FETCH c_Estructura INTO cPuesto   , cCodAgente      , cCodAgenteAnt     , cNomAgente, cTipoAgente, dFechaAlta,
                                    cStsAgente, cCanalComisVenta, cExcluirHonorarios, cPagoAutom, nEjecutivo , cNomEjecutivo;
            EXIT WHEN c_Estructura%NOTFOUND;
            cTemp := '{
                        "PUESTO": "' || cPuesto || '",
                        "CODAGENTE": "' || cCodAgente || '",
                        "CODAGENTEANT": "' || cCodAgenteAnt || '",
                        "NOMAGENTE": "' || cNomAgente || '",
                        "TIPOAGENTE": "' || cTipoAgente || '",
                        "FECHAALTA": "' || TO_CHAR(dFechaAlta, 'DD/MM/YYYY') || '",
                        "STSAGENTE": "' || cStsAgente || '",
                        "CANALCOMISVENTA": "' || cCanalComisVenta || '",
                        "EXCLUIRHONORARIOS": "' || cExcluirHonorarios || '",
                        "PAGOAUTOM": "' || cPagoAutom || '",
                        "EJECUTIVO": "' || nEjecutivo || '",
                        "NOMEJECUTIVO": "' || cNomEjecutivo || '",
                      }';
            IF DBMS_LOB.GETLENGTH(cJson) > 2 THEN
                DBMS_LOB.WRITEAPPEND(cJson, 2, ', ');
            END IF;
            DBMS_LOB.WRITEAPPEND(cJson, LENGTH(cTemp), cTemp);
        END LOOP;
        CLOSE c_Estructura;
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH(' ]'), ' ]');
        RETURN cJson;
    END ESTRUCTURA_AGENTES;
    --
    FUNCTION ENDOSOS_PRODUCTO( nCodCia      CLAUSULAS_TIPOS_SEGUROS.CodCia%TYPE
                             , nCodEmpresa  CLAUSULAS_TIPOS_SEGUROS.CodEmpresa%TYPE 
                             , cIdTipoSeg   CLAUSULAS_TIPOS_SEGUROS.IdTipoSeg%TYPE ) RETURN CLOB IS
        cJson                CLOB;
        cTemp                CLOB;
        cCodClausula         CLAUSULAS.CodClausula%TYPE;
        cDescClausula        CLAUSULAS.DescClausula%TYPE;
        cIndOblig            CLAUSULAS.IndOblig%TYPE;
        cIndTipoClausula     CLAUSULAS.IndTipoClausula%TYPE;
        cAplicaTipoAdmin     CLAUSULAS.AplicaTipoAdministracion%TYPE;
        cTipoAdministracion  CLAUSULAS.TipoAdministracion%TYPE;
        --      
        CURSOR c_ObjetoImpuesto IS
               SELECT CodClausula
                    , OC_CLAUSULAS.DESCRIPCION(CodCia, CodEmpresa, CodClausula) DescClausula
                    , OC_CLAUSULAS.OBLIGATORIA(CodCia, CodEmpresa, CodClausula) IndOblig
                    , OC_CLAUSULAS.TIPO_CLAUSULA(CodCia, CodEmpresa, CodClausula) IndTipoClausula
                    , OC_CLAUSULAS.APLICA_ADMINISTRACION(CodCia, CodEmpresa, CodClausula) AplicaTipoAdmin
                    , OC_CLAUSULAS.TIPO_ADMINISTRACION(CodCia, CodEmpresa, CodClausula) TipoAdministracion
               FROM   CLAUSULAS_TIPOS_SEGUROS
               WHERE  CodCia     = nCodCia
                 AND  CodEmpresa = nCodEmpresa
                 AND  IdTipoSeg  = cIdTipoSeg
               ORDER BY CodClausula;
   BEGIN
        DBMS_LOB.CREATETEMPORARY(cJson, TRUE);
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH('[ '), '[ ');
        --
        OPEN c_ObjetoImpuesto;
        LOOP
            FETCH c_ObjetoImpuesto INTO cCodClausula, cDescClausula, cIndOblig, cIndTipoClausula, cAplicaTipoAdmin, cTipoAdministracion;
            EXIT WHEN c_ObjetoImpuesto%NOTFOUND;
            cTemp := '{
                        "CODCLAUSULA": "' || cCodClausula || '",
                        "DESCCLAUSULA": "' || cDescClausula || '",
                        "INDOBLIG": "' || cIndOblig || '",
                        "INDTIPOCLAUSULA": "' || cIndTipoClausula || '",
                        "APLICATIPOADMIN": "' || cAplicaTipoAdmin || '",
                        "TIPOADMINISTRACION": "' || cTipoAdministracion || '"
                      }';
            IF DBMS_LOB.GETLENGTH(cJson) > 2 THEN
                DBMS_LOB.WRITEAPPEND(cJson, 2, ', ');
            END IF;
            DBMS_LOB.WRITEAPPEND(cJson, LENGTH(cTemp), cTemp);
        END LOOP;
        CLOSE c_ObjetoImpuesto;
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH(' ]'), ' ]');
        RETURN cJson;
    END ENDOSOS_PRODUCTO;
    
END CATALOGOS_SIGO;
/

CREATE OR REPLACE PUBLIC SYNONYM CATALOGOS_SIGO FOR THONAPI.CATALOGOS_SIGO
/

GRANT EXECUTE ON THONAPI.CATALOGOS_SIGO TO PUBLIC
/