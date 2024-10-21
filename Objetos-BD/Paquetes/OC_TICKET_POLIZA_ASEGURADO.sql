create or replace PACKAGE          OC_TICKET_POLIZA_ASEGURADO IS
PROCEDURE INSERTAR( nCodCia             IN  TICKET_POLIZA_ASEGURADO.CodCia%TYPE
                  , nCodEmpresa         IN  TICKET_POLIZA_ASEGURADO.CodEmpresa%TYPE
                  , nCodCliente         IN  TICKET_POLIZA_ASEGURADO.CodCliente%TYPE
                  , cCodSucursal        IN  TICKET_POLIZA_ASEGURADO.CodSucursal%TYPE
                  , nNumeroCelular      IN  TICKET_POLIZA_ASEGURADO.NumeroCelular%TYPE
                  , dFechaCompra        IN  TICKET_POLIZA_ASEGURADO.FechaCompra%TYPE
                  , cNumeroConsecutivo  IN  TICKET_POLIZA_ASEGURADO.NumeroConsecutivo%TYPE
                  , cNumeroTicket       IN  TICKET_POLIZA_ASEGURADO.NumeroTicket%TYPE
                  , cCodigoRastreo      IN  TICKET_POLIZA_ASEGURADO.CodigoRastreo%TYPE
                  , nCodAsegurado       IN  TICKET_POLIZA_ASEGURADO.CodAsegurado%TYPE 
                  , nIdPoliza           IN  TICKET_POLIZA_ASEGURADO.IdPoliza%TYPE 
                  , nIDetPol            IN  TICKET_POLIZA_ASEGURADO.IDetPol%TYPE);

PROCEDURE ELIMINAR( nCodCia             IN  TICKET_POLIZA_ASEGURADO.CodCia%TYPE
                  , nCodEmpresa         IN  TICKET_POLIZA_ASEGURADO.CodEmpresa%TYPE
                  , nCodCliente         IN  TICKET_POLIZA_ASEGURADO.CodCliente%TYPE
                  , cCodSucursal        IN  TICKET_POLIZA_ASEGURADO.CodSucursal%TYPE
                  , nNumeroCelular      IN  TICKET_POLIZA_ASEGURADO.NumeroCelular%TYPE
                  , dFechaCompra        IN  TICKET_POLIZA_ASEGURADO.FechaCompra%TYPE
                  , cNumeroConsecutivo  IN  TICKET_POLIZA_ASEGURADO.NumeroConsecutivo%TYPE );

FUNCTION CONSULTAR( nCodCia         IN  TICKET_POLIZA_ASEGURADO.CodCia%TYPE
                  , nCodEmpresa     IN  TICKET_POLIZA_ASEGURADO.CodEmpresa%TYPE
                  , nCodCliente     IN  TICKET_POLIZA_ASEGURADO.CodCliente%TYPE
                  , cCodSucursal    IN  TICKET_POLIZA_ASEGURADO.CodSucursal%TYPE
                  , nNumeroCelular  IN  TICKET_POLIZA_ASEGURADO.NumeroCelular%TYPE
                  , dFechaCompra    IN  TICKET_POLIZA_ASEGURADO.FechaCompra%TYPE
                  , nCodAsegurado   IN  TICKET_POLIZA_ASEGURADO.CodAsegurado%TYPE ) RETURN XMLTYPE;

FUNCTION REGISTRAR( nCodCia      IN  TICKET_POLIZA_ASEGURADO.CodCia%TYPE
                  , nCodEmpresa  IN  TICKET_POLIZA_ASEGURADO.CodEmpresa%TYPE
                  , xDatos       IN  XMLTYPE ) RETURN NUMBER;

FUNCTION SUGBRUPO ( nCodCia      IN  TICKET_POLIZA_ASEGURADO.CodCia%TYPE
                  , nCodEmpresa  IN  TICKET_POLIZA_ASEGURADO.CodEmpresa%TYPE
                  , nIdPoliza    IN  TICKET_POLIZA_ASEGURADO.IdPoliza%TYPE) RETURN NUMBER;

PROCEDURE POLIZA_SUBGRUPO( nCodCia        IN  TICKET_POLIZA_ASEGURADO.CodCia%TYPE
                         , nCodEmpresa    IN  TICKET_POLIZA_ASEGURADO.CodEmpresa%TYPE
                         , nCodCliente    IN  TICKET_POLIZA_ASEGURADO.CodCliente%TYPE
                         , dFechaRegistro IN  TICKET_POLIZA_ASEGURADO.FechaRegistro%TYPE
                         , nCodAsegurado  IN  TICKET_POLIZA_ASEGURADO.CodAsegurado%TYPE
                         , nIdPoliza      OUT TICKET_POLIZA_ASEGURADO.IdPoliza%TYPE
                         , nIDetPol       OUT TICKET_POLIZA_ASEGURADO.IDetPol%TYPE
                         , xBenef         OUT XMLTYPE);                     

FUNCTION CUENTA_CUMULOS( nCodCia        IN  TICKET_POLIZA_ASEGURADO.CodCia%TYPE
                       , nCodEmpresa    IN  TICKET_POLIZA_ASEGURADO.CodEmpresa%TYPE
                       , nCodAsegurado  IN  TICKET_POLIZA_ASEGURADO.CodAsegurado%TYPE) RETURN NUMBER;

FUNCTION EXISTE_REGISTRO_ASEG(nCodCia        IN  TICKET_POLIZA_ASEGURADO.CodCia%TYPE
                            , nCodEmpresa    IN  TICKET_POLIZA_ASEGURADO.CodEmpresa%TYPE
                            , nIdPoliza      IN  TICKET_POLIZA_ASEGURADO.IdPoliza%TYPE
                            , nCodAsegurado  IN  TICKET_POLIZA_ASEGURADO.CodAsegurado%TYPE
                            , dFechaRegistro IN  TICKET_POLIZA_ASEGURADO.FechaRegistro%TYPE) RETURN VARCHAR2;

FUNCTION SUBGRUPO_REGISTRADO(nCodCia        IN  TICKET_POLIZA_ASEGURADO.CodCia%TYPE
                            , nCodEmpresa    IN  TICKET_POLIZA_ASEGURADO.CodEmpresa%TYPE
                            , nIdPoliza      IN  TICKET_POLIZA_ASEGURADO.IdPoliza%TYPE
                            , nCodAsegurado  IN  TICKET_POLIZA_ASEGURADO.CodAsegurado%TYPE
                            , dFechaRegistro IN  TICKET_POLIZA_ASEGURADO.FechaRegistro%TYPE) RETURN NUMBER;    

PROCEDURE EMITIR( nCodCia        IN  TICKET_POLIZA_ASEGURADO.CodCia%TYPE
                , nCodEmpresa    IN  TICKET_POLIZA_ASEGURADO.CodEmpresa%TYPE
                , nCodCliente    IN  TICKET_POLIZA_ASEGURADO.CodCliente%TYPE
                --, nNumeroCelular IN  TICKET_POLIZA_ASEGURADO.NumeroCelular%TYPE
                --, dFechaCompra   IN  TICKET_POLIZA_ASEGURADO.FechaCompra%TYPE
                , dFechaRegistro IN  TICKET_POLIZA_ASEGURADO.FechaRegistro%TYPE
                , nCodAsegurado  IN  TICKET_POLIZA_ASEGURADO.CodAsegurado%TYPE
                , nIdPoliza      IN  TICKET_POLIZA_ASEGURADO.IdPoliza%TYPE
                , nIDetPol       IN TICKET_POLIZA_ASEGURADO.IDetPol%TYPE);

PROCEDURE ASIGNA_FACTURA( nCodCia        IN  TICKET_POLIZA_ASEGURADO.CodCia%TYPE
                        , nCodEmpresa    IN  TICKET_POLIZA_ASEGURADO.CodEmpresa%TYPE
                        , nCodCliente    IN  TICKET_POLIZA_ASEGURADO.CodCliente%TYPE
                        --, nNumeroCelular IN  TICKET_POLIZA_ASEGURADO.NumeroCelular%TYPE
                        --, dFechaCompra   IN  TICKET_POLIZA_ASEGURADO.FechaCompra%TYPE
                        , dFechaRegistro IN  TICKET_POLIZA_ASEGURADO.FechaRegistro%TYPE
                        , nCodAsegurado  IN  TICKET_POLIZA_ASEGURADO.CodAsegurado%TYPE
                        , nIdPoliza      IN  TICKET_POLIZA_ASEGURADO.IdPoliza%TYPE
                        , nIDetPol       IN TICKET_POLIZA_ASEGURADO.IDetPol%TYPE
                        , nIdFactura     IN  TICKET_POLIZA_ASEGURADO.IdFactura%TYPE);

PROCEDURE CARGA_COBERTURAS (nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER,
                            nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER, cIdTipoSeg VARCHAR2, 
                            cPlanCob VARCHAR2, nVecesAseguramiento NUMBER);   

FUNCTION EXISTE_TICKET( nCodCia             IN  TICKET_POLIZA_ASEGURADO.CodCia%TYPE
                      , nCodEmpresa         IN  TICKET_POLIZA_ASEGURADO.CodEmpresa%TYPE
                      --, nCodCliente         IN  TICKET_POLIZA_ASEGURADO.CodCliente%TYPE
                      --, cCodSucursal        IN  TICKET_POLIZA_ASEGURADO.CodSucursal%TYPE
                      , nNumeroCelular      IN  TICKET_POLIZA_ASEGURADO.NumeroCelular%TYPE
                      , dFechaCompra        IN  TICKET_POLIZA_ASEGURADO.FechaCompra%TYPE
                      , cNumeroConsecutivo  IN  TICKET_POLIZA_ASEGURADO.NumeroConsecutivo%TYPE ) RETURN VARCHAR2;                           
END OC_TICKET_POLIZA_ASEGURADO;
/
create or replace PACKAGE BODY          OC_TICKET_POLIZA_ASEGURADO IS
PROCEDURE INSERTAR( nCodCia             IN  TICKET_POLIZA_ASEGURADO.CodCia%TYPE
                  , nCodEmpresa         IN  TICKET_POLIZA_ASEGURADO.CodEmpresa%TYPE
                  , nCodCliente         IN  TICKET_POLIZA_ASEGURADO.CodCliente%TYPE
                  , cCodSucursal        IN  TICKET_POLIZA_ASEGURADO.CodSucursal%TYPE
                  , nNumeroCelular      IN  TICKET_POLIZA_ASEGURADO.NumeroCelular%TYPE
                  , dFechaCompra        IN  TICKET_POLIZA_ASEGURADO.FechaCompra%TYPE
                  , cNumeroConsecutivo  IN  TICKET_POLIZA_ASEGURADO.NumeroConsecutivo%TYPE
                  , cNumeroTicket       IN  TICKET_POLIZA_ASEGURADO.NumeroTicket%TYPE
                  , cCodigoRastreo      IN  TICKET_POLIZA_ASEGURADO.CodigoRastreo%TYPE
                  , nCodAsegurado       IN  TICKET_POLIZA_ASEGURADO.CodAsegurado%TYPE 
                  , nIdPoliza           IN  TICKET_POLIZA_ASEGURADO.IdPoliza%TYPE 
                  , nIDetPol            IN  TICKET_POLIZA_ASEGURADO.IDetPol%TYPE) IS
   nIdFactura  TICKET_POLIZA_ASEGURADO.IdFactura%TYPE;
   cStsTicket  TICKET_POLIZA_ASEGURADO.StsTicket%TYPE;
BEGIN 
   EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
   nIdFactura := NULL; --este se va llenar con un proceso nocturno en la noche
   cStsTicket := 'PRE'; --PRE EMITIDO
   --
   INSERT INTO TICKET_POLIZA_ASEGURADO
      ( CodCia           , CodEmpresa  , CodCliente   , CodSucursal  , NumeroCelular, FechaCompra,
        NumeroConsecutivo, NumeroTicket, CodigoRastreo, FechaRegistro, IdPoliza     , IdetPol    ,
        CodAsegurado     , IdFactura   , CodUsuario   , StsTicket    , FecStsTicket )
   VALUES ( nCodCia           , nCodEmpresa  , nCodCliente   , cCodSucursal, nNumeroCelular, dFechaCompra,
            cNumeroConsecutivo, cNumeroTicket, cCodigoRastreo, SYSDATE     , nIdPoliza     , nIdetPol    ,
            nCodAsegurado     , nIdFactura   , USER          , cStsTicket  , SYSDATE );
END INSERTAR;

PROCEDURE ELIMINAR( nCodCia             IN  TICKET_POLIZA_ASEGURADO.CodCia%TYPE
                  , nCodEmpresa         IN  TICKET_POLIZA_ASEGURADO.CodEmpresa%TYPE
                  , nCodCliente         IN  TICKET_POLIZA_ASEGURADO.CodCliente%TYPE
                  , cCodSucursal        IN  TICKET_POLIZA_ASEGURADO.CodSucursal%TYPE
                  , nNumeroCelular      IN  TICKET_POLIZA_ASEGURADO.NumeroCelular%TYPE
                  , dFechaCompra        IN  TICKET_POLIZA_ASEGURADO.FechaCompra%TYPE
                  , cNumeroConsecutivo  IN  TICKET_POLIZA_ASEGURADO.NumeroConsecutivo%TYPE ) IS
BEGIN
   EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
   DELETE TICKET_POLIZA_ASEGURADO
    WHERE  CodCia            = nCodCia
      AND  CodEmpresa        = nCodEmpresa
      AND  CodCliente        = nCodCliente
      AND  CodSucursal       = cCodSucursal
      AND  NumeroCelular     = nNumeroCelular
      AND  FechaCompra       = dFechaCompra
      AND  NumeroConsecutivo = cNumeroConsecutivo;
END ELIMINAR;

FUNCTION CONSULTAR( nCodCia         IN  TICKET_POLIZA_ASEGURADO.CodCia%TYPE
                  , nCodEmpresa     IN  TICKET_POLIZA_ASEGURADO.CodEmpresa%TYPE
                  , nCodCliente     IN  TICKET_POLIZA_ASEGURADO.CodCliente%TYPE
                  , cCodSucursal    IN  TICKET_POLIZA_ASEGURADO.CodSucursal%TYPE
                  , nNumeroCelular  IN  TICKET_POLIZA_ASEGURADO.NumeroCelular%TYPE
                  , dFechaCompra    IN  TICKET_POLIZA_ASEGURADO.FechaCompra%TYPE
                  , nCodAsegurado   IN  TICKET_POLIZA_ASEGURADO.CodAsegurado%TYPE ) RETURN XMLTYPE IS
   --
   cResultado          CLOB;
   xResultado          XMLTYPE;   
   xResultado1         XMLTYPE;
   --
CURSOR Tickets IS
   SELECT NumeroConsecutivo, NumeroTicket, CodigoRastreo
     FROM   TICKET_POLIZA_ASEGURADO
    WHERE  CodCia        = nCodCia
      AND  CodEmpresa    = nCodEmpresa
      AND  CodCliente    = NVL( nCodCliente    , CodCliente )
      AND  CodSucursal   = NVL( cCodSucursal   , CodSucursal )
      AND  NumeroCelular = NVL( nNumeroCelular , NumeroCelular )
      AND  FechaCompra   = NVL( dFechaCompra   , FechaCompra )
      AND  CodAsegurado  = NVL( nCodAsegurado  , CodAsegurado )
    ORDER BY NumeroConsecutivo;
   --
BEGIN
   EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
   cResultado := '<?xml version="1.0"?> <DATA>';
   cResultado := cResultado || '<CodCliente>'    || nCodCliente    || '</CodCliente>';
   cResultado := cResultado || '<CodSucursal>'   || cCodSucursal   || '</CodSucursal>';
   cResultado := cResultado || '<NumeroCelular>' || nNumeroCelular || '</NumeroCelular>';
   cResultado := cResultado || '<FechaCompra>'   || dFechaCompra   || '</FechaCompra>';
   cResultado := cResultado || '<CodAsegurado>'  || nCodAsegurado  || '</CodAsegurado>';
   --
   FOR x IN Tickets LOOP
       cResultado := cResultado || '<TICKET>';
       cResultado := cResultado || '<NUMEROCONSECUTIVO>'  || x.NumeroConsecutivo || '</NUMEROCONSECUTIVO>';
       cResultado := cResultado || '<NUMEROTICKET>'       || x.NumeroTicket      || '</NUMEROTICKET>';
       cResultado := cResultado || '<CODIGORASTREO>'      || x.CodigoRastreo     || '</CODIGORASTREO>';
       cResultado := cResultado || '</TICKET>';
   END LOOP;
   cResultado  := cResultado || '</DATA>';
   xResultado1 := XMLType(cResultado);
   --
   SELECT XMLROOT (xResultado1, VERSION '1.0" encoding="UTF-8')
   INTO   xResultado
   FROM   DUAL;
   --
   RETURN xResultado;
EXCEPTION
WHEN OTHERS THEN
   RETURN NULL;
END CONSULTAR; 

FUNCTION REGISTRAR( nCodCia      IN  TICKET_POLIZA_ASEGURADO.CodCia%TYPE
                  , nCodEmpresa  IN  TICKET_POLIZA_ASEGURADO.CodEmpresa%TYPE
                  , xDatos       IN  XMLTYPE ) RETURN NUMBER IS
   --
   nProceso            NUMBER := 0;
   --Variables del Nodo Padre   
   nCodCliente         TICKET_POLIZA_ASEGURADO.CodCliente%TYPE;
   cCodSucursal        TICKET_POLIZA_ASEGURADO.CodSucursal%TYPE;
   nNumeroCelular      TICKET_POLIZA_ASEGURADO.NumeroCelular%TYPE;
   dFechaCompra        TICKET_POLIZA_ASEGURADO.FechaCompra%TYPE;
   nCodAsegurado       TICKET_POLIZA_ASEGURADO.CodAsegurado%TYPE;
   --Variables del Nodo Padre   
   cNumeroConsecutivo  TICKET_POLIZA_ASEGURADO.NumeroConsecutivo%TYPE;
   cNumeroTicket       TICKET_POLIZA_ASEGURADO.NumeroTicket%TYPE;
   cCodigoRastreo      TICKET_POLIZA_ASEGURADO.CodigoRastreo%TYPE;
   nIdPoliza           TICKET_POLIZA_ASEGURADO.IdPoliza%TYPE; 
   nIDetPol            TICKET_POLIZA_ASEGURADO.IDetPol%TYPE;
   --Variables para el control del XML
   xParse              XMLPARSER.PARSER;
   xDocumento          XMLDOM.DOMDOCUMENT;
   xNodosPadre         XMLDOM.DOMNODELIST;
   xElementoPadre      XMLDOM.DOMNODE;
   xNodosHijo          XMLDOM.DOMNODELIST;
   xElementoHijo       XMLDOM.DOMNODE;
   cXml                CLOB;
BEGIN
   EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
   --
   cXml := xDatos.GETCLOBVAL();
   --
   --Parseo el contenido del documento xml
   xParse := XMLPARSER.NEWPARSER();
   XMLPARSER.PARSECLOB( xParse, cXml ); 
   --
   --Obtenemos el documento xml cargado en un objeto DOM
   xDocumento := XMLPARSER.GETDOCUMENT( xParse );
   XMLPARSER.FREEPARSER( xParse );
   xNodosPadre := XMLDOM.GETCHILDRENBYTAGNAME( XMLDOM.GETDOCUMENTELEMENT( xDocumento ), '*' );
   --
   --Recorremos cada nodo del arreglo, el arreglo inicio en el item 0  --- Aca devuelve 7
   FOR x IN 1..XMLDOM.GETLENGTH( xNodosPadre ) LOOP
      xElementoPadre := XMLDOM.ITEM( xNodosPadre, x - 1 );
      --
      IF x = 1 THEN 
         nCodCliente := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoPadre ));
      ELSIF x = 2 THEN 
         cCodSucursal := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoPadre ));
      ELSIF x = 3 THEN 
         nNumeroCelular := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoPadre ));
      ELSIF x = 4 THEN 
         dFechaCompra := TO_DATE( XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoPadre )), 'DD/MM/YYYY');
      ELSIF x = 5 THEN 
         nIdPoliza := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoPadre ));
      ELSIF x = 6 THEN 
         nIDetPol := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoPadre ));
      ELSIF x = 7 THEN 
         nCodAsegurado := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoPadre ));
      END IF;
   END LOOP;
   --
   --Empiezo en el nodo que necesitamos
   FOR x IN 8..XMLDOM.GETLENGTH( xNodosPadre ) LOOP
      --
      xElementoPadre := XMLDOM.ITEM( xNodosPadre, x - 1 );
      --
      -- obtenemos la lista d eelementos que tiene el nodo actual
      xNodosHijo := XMLDOM.GETCHILDNODES( xElementoPadre );
      --
      FOR y IN 1..XMLDOM.GETLENGTH( xNodosHijo ) LOOP
         --
         --obtenemos un elemento
         xElementoHijo := XMLDOM.ITEM( xNodosHijo, y - 1 );   
         --
         IF y = 1 THEN 
            cNumeroConsecutivo := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoHijo ));
         ELSIF y = 2 THEN 
            cNumeroTicket := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoHijo ));
         ELSIF y = 3 THEN 
            cCodigoRastreo := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoHijo ));
         END IF;
      END LOOP;
      --
      OC_TICKET_POLIZA_ASEGURADO.INSERTAR( nCodCia     , nCodEmpresa       , nCodCliente  , cCodSucursal  , nNumeroCelular,
                                           dFechaCompra, cNumeroConsecutivo, cNumeroTicket, cCodigoRastreo, nCodAsegurado, nIdPoliza, nIDetPol );
   END LOOP;
   --
   nProceso := 1;
   RETURN nProceso;
EXCEPTION 
WHEN OTHERS THEN
     RETURN 0;
END REGISTRAR;

FUNCTION SUGBRUPO ( nCodCia      IN  TICKET_POLIZA_ASEGURADO.CodCia%TYPE
                  , nCodEmpresa  IN  TICKET_POLIZA_ASEGURADO.CodEmpresa%TYPE
                  , nIdPoliza    IN  TICKET_POLIZA_ASEGURADO.IdPoliza%TYPE) RETURN NUMBER IS
nIDetPol TICKET_POLIZA_ASEGURADO.IDetPol%TYPE;
BEGIN
   EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
   SELECT NVL(MAX(IDetPol) + 1, 1)
     INTO nIDetPol
     FROM TICKET_POLIZA_ASEGURADO 
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa 
      AND IdPoliza      = nIdPoliza;
RETURN nIDetPol;
END SUGBRUPO;

PROCEDURE POLIZA_SUBGRUPO( nCodCia        IN  TICKET_POLIZA_ASEGURADO.CodCia%TYPE
                         , nCodEmpresa    IN  TICKET_POLIZA_ASEGURADO.CodEmpresa%TYPE
                         , nCodCliente    IN  TICKET_POLIZA_ASEGURADO.CodCliente%TYPE
                         , dFechaRegistro IN  TICKET_POLIZA_ASEGURADO.FechaRegistro%TYPE
                         , nCodAsegurado  IN  TICKET_POLIZA_ASEGURADO.CodAsegurado%TYPE
                         , nIdPoliza      OUT TICKET_POLIZA_ASEGURADO.IdPoliza%TYPE
                         , nIDetPol       OUT TICKET_POLIZA_ASEGURADO.IDetPol%TYPE
                         , xBenef         OUT XMLTYPE) IS
BEGIN
   EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
   nIdPoliza   := OC_TICKET_POLIZA.POLIZA(nCodCia, nCodEmpresa, nCodCliente, dFechaRegistro);
   IF nIdPoliza <> 0 THEN 
      IF OC_TICKET_POLIZA_ASEGURADO.EXISTE_REGISTRO_ASEG(nCodCia, nCodEmpresa, nIdPoliza, nCodAsegurado, dFechaRegistro) = 'S' THEN
         nIDetPol := OC_TICKET_POLIZA_ASEGURADO.SUBGRUPO_REGISTRADO(nCodCia, nCodEmpresa, nIdPoliza, nCodAsegurado, dFechaRegistro);
         xBenef   := OC_TICKET_POLIZA_BENEFICIARIO.LISTAR(nCodCia, nCodEmpresa, nCodCliente, nIdPoliza, nIDetPol, nCodAsegurado);
      ELSE
         nIDetPol := OC_TICKET_POLIZA_ASEGURADO.SUGBRUPO (nCodCia, nCodEmpresa, nIdPoliza);
      END IF;
   ELSE 
      RAISE_APPLICATION_ERROR(-20100,'ERROR NO Existe configurada póliza para la fecha '||dFechaRegistro);
   END IF;
EXCEPTION 
   WHEN OTHERS THEN 
      RAISE_APPLICATION_ERROR(-20100,'ERROR al obetener datos de Póliza: '||SQLERRM||' - '||SQLCODE);
END POLIZA_SUBGRUPO; 

FUNCTION CUENTA_CUMULOS( nCodCia        IN  TICKET_POLIZA_ASEGURADO.CodCia%TYPE
                       , nCodEmpresa    IN  TICKET_POLIZA_ASEGURADO.CodEmpresa%TYPE
                       , nCodAsegurado  IN  TICKET_POLIZA_ASEGURADO.CodAsegurado%TYPE) RETURN NUMBER IS
   nContCumulos  NUMBER;
BEGIN
   EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
   SELECT COUNT(*)
   INTO   nContCumulos
   FROM   ( SELECT AC.IdPoliza, MAX(AC.IdetPol)
            FROM   ASEGURADO_CERTIFICADO  AC
               ,   DETALLE_POLIZA         DP
            WHERE  AC.CodCia        = DP.CodCia
              AND  AC.IdPoliza      = DP.IdPoliza
              AND  AC.IdetPol       = DP.IdetPol
              AND  AC.Cod_Asegurado = DP.Cod_Asegurado
              AND  DP.CodCia        = nCodCia
              AND  DP.CodEmpresa    = nCodEmpresa
              AND  DP.Cod_Asegurado = nCodAsegurado 
              AND  DP.PlanCob       = 'MAESTRO'
              AND  DP.IdTipoSeg     = 'VG2017'
            GROUP BY AC.IdPoliza );
   --
   RETURN nContCumulos;
END CUENTA_CUMULOS;


FUNCTION EXISTE_REGISTRO_ASEG(nCodCia        IN  TICKET_POLIZA_ASEGURADO.CodCia%TYPE
                            , nCodEmpresa    IN  TICKET_POLIZA_ASEGURADO.CodEmpresa%TYPE
                            , nIdPoliza      IN  TICKET_POLIZA_ASEGURADO.IdPoliza%TYPE
                            , nCodAsegurado  IN  TICKET_POLIZA_ASEGURADO.CodAsegurado%TYPE
                            , dFechaRegistro IN  TICKET_POLIZA_ASEGURADO.FechaRegistro%TYPE) RETURN VARCHAR2 IS
   cExiste  VARCHAR2(1);
BEGIN
   EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM TICKET_POLIZA_ASEGURADO
       WHERE CodCia                                = nCodCia
         AND CodEmpresa                            = nCodEmpresa
         AND IdPoliza                              = nIdPoliza
         AND CodAsegurado                          = nCodAsegurado
         AND TO_DATE(FechaRegistro,'DD/MM/YYYY')   = TO_DATE(dFechaRegistro,'DD/MM/YYYY');
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN cExiste;
END EXISTE_REGISTRO_ASEG;   

FUNCTION SUBGRUPO_REGISTRADO(nCodCia        IN  TICKET_POLIZA_ASEGURADO.CodCia%TYPE
                           , nCodEmpresa    IN  TICKET_POLIZA_ASEGURADO.CodEmpresa%TYPE
                           , nIdPoliza      IN  TICKET_POLIZA_ASEGURADO.IdPoliza%TYPE
                           , nCodAsegurado  IN  TICKET_POLIZA_ASEGURADO.CodAsegurado%TYPE
                           , dFechaRegistro IN  TICKET_POLIZA_ASEGURADO.FechaRegistro%TYPE) RETURN NUMBER IS
   nIDetPol TICKET_POLIZA_ASEGURADO.IDetPol%TYPE;                        
BEGIN
   EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
   BEGIN
      SELECT DISTINCT NVL(IDetPol, 0)
        INTO nIDetPol
        FROM TICKET_POLIZA_ASEGURADO 
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa 
         AND IdPoliza      = nIdPoliza
         AND CodAsegurado  = nCodAsegurado
         AND TO_DATE(FechaRegistro,'DD/MM/YYYY') = TO_DATE(dFechaRegistro,'DD/MM/YYYY');
   EXCEPTION
      WHEN NO_DATA_FOUND THEN 
         nIDetPol := 0;
      WHEN TOO_MANY_ROWS THEN 
         RAISE_APPLICATION_ERROR(-20100,'ERROR Existe más de un Subgrupo registraso para el asegurado '||nCodAsegurado||' en el día '||dFechaRegistro);
   END;
   RETURN nIDetPol;
END SUBGRUPO_REGISTRADO;


PROCEDURE EMITIR( nCodCia        IN  TICKET_POLIZA_ASEGURADO.CodCia%TYPE
                , nCodEmpresa    IN  TICKET_POLIZA_ASEGURADO.CodEmpresa%TYPE
                , nCodCliente    IN  TICKET_POLIZA_ASEGURADO.CodCliente%TYPE
                --, nNumeroCelular IN  TICKET_POLIZA_ASEGURADO.NumeroCelular%TYPE
                --, dFechaCompra   IN  TICKET_POLIZA_ASEGURADO.FechaCompra%TYPE
                , dFechaRegistro IN  TICKET_POLIZA_ASEGURADO.FechaRegistro%TYPE
                , nCodAsegurado  IN  TICKET_POLIZA_ASEGURADO.CodAsegurado%TYPE
                , nIdPoliza      IN  TICKET_POLIZA_ASEGURADO.IdPoliza%TYPE
                , nIDetPol       IN  TICKET_POLIZA_ASEGURADO.IDetPol%TYPE) IS
BEGIN
   UPDATE TICKET_POLIZA_ASEGURADO
      SET StsTicket     = 'EMI',
          FecStsTicket  = TRUNC(SYSDATE)
    WHERE CodCia                                = nCodCia
      AND CodEmpresa                            = nCodEmpresa 
      AND CodCliente                            = nCodCliente
      --AND NumeroCelular                         = nNumeroCelular
     -- AND TO_DATE(FechaCompra,'DD/MM/YYYY')     = NVL(dFechaCompra,FechaCompra)
      AND TO_DATE(FechaRegistro,'DD/MM/YYYY')   = NVL(dFechaRegistro,FechaRegistro)
      AND IdPoliza                              = nIdPoliza
      AND IDetPol                               = NVL(nIDetPol,IDetPol)
      AND CodAsegurado                          = NVL(nCodAsegurado,CodAsegurado);
END EMITIR;

PROCEDURE ASIGNA_FACTURA( nCodCia        IN  TICKET_POLIZA_ASEGURADO.CodCia%TYPE
                        , nCodEmpresa    IN  TICKET_POLIZA_ASEGURADO.CodEmpresa%TYPE
                        , nCodCliente    IN  TICKET_POLIZA_ASEGURADO.CodCliente%TYPE
                        --, nNumeroCelular IN  TICKET_POLIZA_ASEGURADO.NumeroCelular%TYPE
                        --, dFechaCompra   IN  TICKET_POLIZA_ASEGURADO.FechaCompra%TYPE
                        , dFechaRegistro IN  TICKET_POLIZA_ASEGURADO.FechaRegistro%TYPE
                        , nCodAsegurado  IN  TICKET_POLIZA_ASEGURADO.CodAsegurado%TYPE
                        , nIdPoliza      IN  TICKET_POLIZA_ASEGURADO.IdPoliza%TYPE
                        , nIDetPol       IN TICKET_POLIZA_ASEGURADO.IDetPol%TYPE
                        , nIdFactura     IN  TICKET_POLIZA_ASEGURADO.IdFactura%TYPE) IS
BEGIN 
   UPDATE TICKET_POLIZA_ASEGURADO
      SET IdFactura  = nIdFactura
    WHERE CodCia                                = nCodCia
      AND CodEmpresa                            = nCodEmpresa 
      AND CodCliente                            = nCodCliente
      --AND NumeroCelular                         = nNumeroCelular
      --AND TO_DATE(FechaCompra,'DD/MM/YYYY')     = dFechaCompra
      AND TO_DATE(FechaRegistro,'DD/MM/YYYY')   = dFechaRegistro
      AND IdPoliza                              = nIdPoliza
      AND IDetPol                               = NVL(nIDetPol,IDetPol)
      AND CodAsegurado                          = NVL(nCodAsegurado,CodAsegurado);
END ASIGNA_FACTURA;
--

PROCEDURE CARGA_COBERTURAS (nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, nIDetCotizacion NUMBER,
                            nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER, cIdTipoSeg VARCHAR2, 
                            cPlanCob VARCHAR2, nVecesAseguramiento NUMBER) IS
nSumaAsegLocal    NUMBER;                            
nSumaAsegMoneda   NUMBER;    
nValorMoneda      NUMBER;
nValorLocal       NUMBER;
CURSOR COTCOB_Q IS
   SELECT C.IdTipoSeg, M.CodCobert, M.SumaAsegCobLocal, M.SumaAsegCobMoneda, M.Tasa,
          M.PrimaCobLocal, M.PrimaCobMoneda, M.DeducibleCobLocal, M.DeducibleCobMoneda,
          C.SAMIAutorizado, C.PlanCob, C.Cod_Moneda, M.SalarioMensual, M.VecesSalario,
          M.SumaAsegCalculada, M.Edad_Minima, M.Edad_Maxima, M.Edad_Exclusion, M.SumaAseg_Minima,
          M.SumaAseg_Maxima, M.PorcExtraPrimaDet, M.MontoExtraPrimaDet, 
          M.SumaIngresada, C.IndAsegModelo, C.IndCensoSubGrupo,
          M.CuotaPromedio, M.PrimaPromedio, M.DeducibleIngresado, M.Franquiciaingresado, M.MontoDiario,
          M.Dias_Cal---ARH 26-08-2024
     FROM COTIZACIONES_COBERT_MASTER M, COTIZACIONES C
    WHERE M.CodCia         = C.CodCia
      AND M.CodEmpresa     = C.CodEmpresa
      AND M.IdCotizacion   = C.IdCotizacion
      AND C.CodCia         = nCodCia
      AND C.CodEmpresa     = nCodEmpresa
      AND C.IdCotizacion   = nIdCotizacion
      AND M.IDetCotizacion = nIDetCotizacion;
BEGIN 
   nSumaAsegLocal    := 0;
   nSumaAsegMoneda   := 0;
   nValorMoneda      := 0;
   nValorLocal       := 0;
   FOR I IN COTCOB_Q LOOP
      nSumaAsegLocal    := I.SumaAsegCobLocal * nVecesAseguramiento;
      nSumaAsegMoneda   := I.SumaAsegCobMoneda * nVecesAseguramiento;
      nValorLocal       := I.PrimaPromedio * nVecesAseguramiento;
      nValorMoneda      := I.PrimaPromedio * nVecesAseguramiento;
      --nValorMoneda      := ROUND((I.Tasa * nSumaAsegMoneda) / 1000,2);
      --nValorLocal       := ROUND((I.Tasa * nSumaAsegLocal) / 1000,2);
      BEGIN
         INSERT INTO COBERT_ACT_ASEG
               (Codcia, Codempresa, Idpoliza, Idetpol, Idtiposeg, Tiporef, 
                Numref, Codcobert, Cod_Asegurado, Sumaaseg_Local, Sumaaseg_Moneda, 
                Tasa, Prima_Moneda, Prima_Local, Idendoso, Stscobertura, Plancob, 
                Cod_Moneda, Deducible_Local, Deducible_Moneda, Sumaasegorigen, 
                Salariomensual, Vecessalario, SumaAsegCalculada, Edad_Minima, 
                Edad_Maxima, Edad_Exclusion, Sumaaseg_Minima, Sumaaseg_Maxima, 
                Porcextraprimadet, Montoextraprimadet, Sumaingresada, Primanivmoneda, 
                Primanivlocal, Franquiciaingresado, MontoDiario,---ARH 06-08-2024
                Dias_Cal)
         VALUES(nCodCia, nCodEmpresa, nIdpoliza, nIdetpol, cIdTipoSeg, 'POLI',
                nIdpoliza, I.CodCobert, nCodAsegurado, NVL(nSumaAsegLocal,0), NVL(nSumaAsegMoneda,0),
                I.Tasa, NVL(nValorMoneda,0), NVL(nValorLocal,0), 0, 'SOL', cPlanCob,
                I.Cod_Moneda, NVL(I.DeducibleCobLocal,0), NVL(I.DeducibleCobMoneda,0), 0,
                NVL(I.SalarioMensual,0), NVL(I.VecesSalario,0), NVL(I.SumaAsegCalculada,0),
                I.Edad_Minima, I.Edad_Maxima, I.Edad_Exclusion, I.SumaAseg_Minima, I.SumaAseg_Maxima, 
                I.PorcExtraPrimaDet, I.MontoExtraPrimaDet, I.SumaIngresada, 0,
                0, I.Franquiciaingresado, I.MontoDiario, I.Dias_Cal);---ARH 06-08-2024
         END;
   END LOOP;
   OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, nIdetPol, nCodAsegurado);
END CARGA_COBERTURAS; 
--
FUNCTION EXISTE_TICKET( nCodCia             IN  TICKET_POLIZA_ASEGURADO.CodCia%TYPE
                      , nCodEmpresa         IN  TICKET_POLIZA_ASEGURADO.CodEmpresa%TYPE
                      --, nCodCliente         IN  TICKET_POLIZA_ASEGURADO.CodCliente%TYPE
                      --, cCodSucursal        IN  TICKET_POLIZA_ASEGURADO.CodSucursal%TYPE
                      , nNumeroCelular      IN  TICKET_POLIZA_ASEGURADO.NumeroCelular%TYPE
                      , dFechaCompra        IN  TICKET_POLIZA_ASEGURADO.FechaCompra%TYPE
                      , cNumeroConsecutivo  IN  TICKET_POLIZA_ASEGURADO.NumeroConsecutivo%TYPE ) RETURN VARCHAR2 IS
cExiste  VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM TICKET_POLIZA_ASEGURADO
       WHERE CodCia              = nCodCia
         AND CodEmpresa          = nCodEmpresa
         --AND CodCliente          = nCodCliente
         --AND CodSucursal         = cCodSucursal
         AND NumeroCelular       = nNumeroCelular
         AND FechaCompra         = dFechaCompra
         AND NumeroConsecutivo   = cNumeroConsecutivo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN 
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN 
         cExiste := 'N';
   END;
   RETURN cExiste;
END EXISTE_TICKET;    

END OC_TICKET_POLIZA_ASEGURADO;