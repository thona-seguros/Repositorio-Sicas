--
-- OC_TICKET_POLIZA_BENEFICIARIO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   XMLTYPE (Type)
--   DUAL (Synonym)
--   XMLDOM (Synonym)
--   XMLPARSER (Synonym)
--   XMLTYPE (Synonym)
--   XMLTYPE (Synonym)
--   DBMS_XMLDOM (Package)
--   TICKET_POLIZA_BENEFICIARIO (Table)
--   TICKET_POLIZA_BENEFICIARIO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_TICKET_POLIZA_BENEFICIARIO IS
   PROCEDURE INSERTAR( nCodCia             IN  TICKET_POLIZA_BENEFICIARIO.CodCia%TYPE
                     , nCodEmpresa         IN  TICKET_POLIZA_BENEFICIARIO.CodEmpresa%TYPE
                     , nCodCliente         IN  TICKET_POLIZA_BENEFICIARIO.CodCliente%TYPE
                     , nIdPoliza           IN  TICKET_POLIZA_BENEFICIARIO.IdPoliza%TYPE
                     , nIdetPol            IN  TICKET_POLIZA_BENEFICIARIO.IdetPol%TYPE
                     , nCodAsegurado       IN  TICKET_POLIZA_BENEFICIARIO.CodAsegurado%TYPE
                     , nNumBeneficiario    IN  TICKET_POLIZA_BENEFICIARIO.NumBeneficiario%TYPE
                     , cNombreBenef        IN  TICKET_POLIZA_BENEFICIARIO.NombreBenef%TYPE
                     , cApePatBenef        IN  TICKET_POLIZA_BENEFICIARIO.ApePatBenef%TYPE
                     , cApeMatBenef        IN  TICKET_POLIZA_BENEFICIARIO.ApeMatBenef%TYPE
                     , cSexoBenef          IN  TICKET_POLIZA_BENEFICIARIO.SexoBenef%TYPE
                     , dFecNacBenef        IN  TICKET_POLIZA_BENEFICIARIO.FecNacBenef%TYPE
                     , nPorcPartBenef      IN  TICKET_POLIZA_BENEFICIARIO.PorcPartBenef%TYPE
                     , dFecAltaBenef       IN  TICKET_POLIZA_BENEFICIARIO.FecAltaBenef%TYPE
                     , cCodParentBenef     IN  TICKET_POLIZA_BENEFICIARIO.CodParentBenef%TYPE );

   PROCEDURE ELIMINAR( nCodCia           IN  TICKET_POLIZA_BENEFICIARIO.CodCia%TYPE
                     , nCodEmpresa       IN  TICKET_POLIZA_BENEFICIARIO.CodEmpresa%TYPE
                     , nCodCliente       IN  TICKET_POLIZA_BENEFICIARIO.CodCliente%TYPE
                     , nIdPoliza         IN  TICKET_POLIZA_BENEFICIARIO.IdPoliza%TYPE
                     , nIdetPol          IN  TICKET_POLIZA_BENEFICIARIO.IdetPol%TYPE
                     , nCodAsegurado     IN  TICKET_POLIZA_BENEFICIARIO.CodAsegurado%TYPE
                     , nNumBeneficiario  IN  TICKET_POLIZA_BENEFICIARIO.NumBeneficiario%TYPE );

   FUNCTION CONSULTAR( nCodCia           IN  TICKET_POLIZA_BENEFICIARIO.CodCia%TYPE
                     , nCodEmpresa       IN  TICKET_POLIZA_BENEFICIARIO.CodEmpresa%TYPE
                     , nCodCliente       IN  TICKET_POLIZA_BENEFICIARIO.CodCliente%TYPE
                     , nIdPoliza         IN  TICKET_POLIZA_BENEFICIARIO.IdPoliza%TYPE
                     , nIDetPol          IN  TICKET_POLIZA_BENEFICIARIO.IDetPol%TYPE
                     , nCodAsegurado     IN  TICKET_POLIZA_BENEFICIARIO.CodAsegurado%TYPE
                     , nNumBeneficiario  IN  TICKET_POLIZA_BENEFICIARIO.NumBeneficiario%TYPE ) RETURN XMLTYPE;

   FUNCTION REGISTRAR( nCodCia      IN  TICKET_POLIZA_BENEFICIARIO.CodCia%TYPE
                     , nCodEmpresa  IN  TICKET_POLIZA_BENEFICIARIO.CodEmpresa%TYPE
                     , xDatos       IN  XMLTYPE ) RETURN NUMBER;

   FUNCTION LISTAR( nCodCia        IN  TICKET_POLIZA_BENEFICIARIO.CodCia%TYPE
                  , nCodEmpresa    IN  TICKET_POLIZA_BENEFICIARIO.CodEmpresa%TYPE
                  , nCodCliente    IN  TICKET_POLIZA_BENEFICIARIO.CodCliente%TYPE
                  , nIdPoliza      IN  TICKET_POLIZA_BENEFICIARIO.IdPoliza%TYPE
                  , nIDetPol       IN  TICKET_POLIZA_BENEFICIARIO.IDetPol%TYPE
                  , nCodAsegurado  IN  TICKET_POLIZA_BENEFICIARIO.CodAsegurado%TYPE ) RETURN XMLTYPE;

   PROCEDURE EMITIR( nCodCia           IN  TICKET_POLIZA_BENEFICIARIO.CodCia%TYPE
                   , nCodEmpresa       IN  TICKET_POLIZA_BENEFICIARIO.CodEmpresa%TYPE
                   , nCodCliente       IN  TICKET_POLIZA_BENEFICIARIO.CodCliente%TYPE
                   , nIdPoliza         IN  TICKET_POLIZA_BENEFICIARIO.IdPoliza%TYPE
                   , nIdetPol          IN  TICKET_POLIZA_BENEFICIARIO.IdetPol%TYPE
                   , nCodAsegurado     IN  TICKET_POLIZA_BENEFICIARIO.CodAsegurado%TYPE
                   , nNumBeneficiario  IN  TICKET_POLIZA_BENEFICIARIO.NumBeneficiario%TYPE );

END OC_TICKET_POLIZA_BENEFICIARIO;
/

--
-- OC_TICKET_POLIZA_BENEFICIARIO  (Package Body) 
--
--  Dependencies: 
--   OC_TICKET_POLIZA_BENEFICIARIO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_TICKET_POLIZA_BENEFICIARIO IS
   PROCEDURE INSERTAR( nCodCia             IN  TICKET_POLIZA_BENEFICIARIO.CodCia%TYPE
                     , nCodEmpresa         IN  TICKET_POLIZA_BENEFICIARIO.CodEmpresa%TYPE
                     , nCodCliente         IN  TICKET_POLIZA_BENEFICIARIO.CodCliente%TYPE
                     , nIdPoliza           IN  TICKET_POLIZA_BENEFICIARIO.IdPoliza%TYPE
                     , nIdetPol            IN  TICKET_POLIZA_BENEFICIARIO.IdetPol%TYPE
                     , nCodAsegurado       IN  TICKET_POLIZA_BENEFICIARIO.CodAsegurado%TYPE
                     , nNumBeneficiario    IN  TICKET_POLIZA_BENEFICIARIO.NumBeneficiario%TYPE
                     , cNombreBenef        IN  TICKET_POLIZA_BENEFICIARIO.NombreBenef%TYPE
                     , cApePatBenef        IN  TICKET_POLIZA_BENEFICIARIO.ApePatBenef%TYPE
                     , cApeMatBenef        IN  TICKET_POLIZA_BENEFICIARIO.ApeMatBenef%TYPE
                     , cSexoBenef          IN  TICKET_POLIZA_BENEFICIARIO.SexoBenef%TYPE
                     , dFecNacBenef        IN  TICKET_POLIZA_BENEFICIARIO.FecNacBenef%TYPE
                     , nPorcPartBenef      IN  TICKET_POLIZA_BENEFICIARIO.PorcPartBenef%TYPE
                     , dFecAltaBenef       IN  TICKET_POLIZA_BENEFICIARIO.FecAltaBenef%TYPE
                     , cCodParentBenef     IN  TICKET_POLIZA_BENEFICIARIO.CodParentBenef%TYPE ) IS
      cStsBenef  TICKET_POLIZA_BENEFICIARIO.StsBenef%TYPE;
   BEGIN 
      EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
      --
      cStsBenef := 'PRE'; --PRE EMITIDO
      --
      INSERT INTO TICKET_POLIZA_BENEFICIARIO
         ( CodCia     , CodEmpresa, CodCliente , IdPoliza    , IdetPol    , CodAsegurado , NumBeneficiario, NombreBenef, ApePatBenef,
           ApeMatBenef, SexoBenef , FecNacBenef, PorcPartBenef, FecAltaBenef, CodParentBenef, CodUsuario     , StsBenef   , FecStsBenef )
      VALUES ( nCodCia     , nCodEmpresa, nCodCliente , nIdPoliza     , nIdetPol     , nCodAsegurado  , nNumBeneficiario, cNombreBenef, cApePatBenef,
               cApeMatBenef, cSexoBenef , dFecNacBenef, nPorcPartBenef, dFecAltaBenef, cCodParentBenef, USER            , cStsBenef   , SYSDATE );
   END INSERTAR;

   PROCEDURE ELIMINAR( nCodCia           IN  TICKET_POLIZA_BENEFICIARIO.CodCia%TYPE
                     , nCodEmpresa       IN  TICKET_POLIZA_BENEFICIARIO.CodEmpresa%TYPE
                     , nCodCliente       IN  TICKET_POLIZA_BENEFICIARIO.CodCliente%TYPE
                     , nIdPoliza         IN  TICKET_POLIZA_BENEFICIARIO.IdPoliza%TYPE
                     , nIdetPol          IN  TICKET_POLIZA_BENEFICIARIO.IdetPol%TYPE
                     , nCodAsegurado     IN  TICKET_POLIZA_BENEFICIARIO.CodAsegurado%TYPE
                     , nNumBeneficiario  IN  TICKET_POLIZA_BENEFICIARIO.NumBeneficiario%TYPE ) IS
   BEGIN
      EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
      --
      DELETE TICKET_POLIZA_BENEFICIARIO
      WHERE  CodCia          = nCodCia
        AND  CodEmpresa      = nCodEmpresa
        AND  CodCliente      = nCodCliente
        AND  IdPoliza        = nIdPoliza
        AND  IdetPol         = nIdetPol
        AND  CodAsegurado    = nCodAsegurado
        AND  NumBeneficiario = NVL( nNumBeneficiario, NumBeneficiario );
   END ELIMINAR;

   FUNCTION CONSULTAR( nCodCia           IN  TICKET_POLIZA_BENEFICIARIO.CodCia%TYPE
                     , nCodEmpresa       IN  TICKET_POLIZA_BENEFICIARIO.CodEmpresa%TYPE
                     , nCodCliente       IN  TICKET_POLIZA_BENEFICIARIO.CodCliente%TYPE
                     , nIdPoliza         IN  TICKET_POLIZA_BENEFICIARIO.IdPoliza%TYPE
                     , nIDetPol          IN  TICKET_POLIZA_BENEFICIARIO.IDetPol%TYPE
                     , nCodAsegurado     IN  TICKET_POLIZA_BENEFICIARIO.CodAsegurado%TYPE
                     , nNumBeneficiario  IN  TICKET_POLIZA_BENEFICIARIO.NumBeneficiario%TYPE ) RETURN XMLTYPE IS
      --
      cResultado   CLOB;
      xResultado   XMLTYPE;   
      xResultado1  XMLTYPE;
      --
      CURSOR Beneficiarios IS
         SELECT NumBeneficiario, NombreBenef, ApePatBenef, ApeMatBenef, SexoBenef, FecNacBenef, PorcPartBenef, FecAltaBenef, CodParentBenef
         FROM   TICKET_POLIZA_BENEFICIARIO
         WHERE  CodCia          = nCodCia
           AND  CodEmpresa      = nCodEmpresa
           AND  CodCliente      = NVL( nCodCliente     , CodCliente )
           AND  IdPoliza        = NVL( nIdPoliza       , IdPoliza )
           AND  IdetPol         = NVL( nIdetPol        , IdetPol )
           AND  CodAsegurado    = NVL( nCodAsegurado   , CodAsegurado )
           AND  NumBeneficiario = NVL( nNumBeneficiario, NumBeneficiario )
         ORDER BY NumBeneficiario;
   BEGIN
      EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
      --
      cResultado := '<?xml version="1.0"?> <DATA>';
      cResultado := cResultado || '<CodCliente>'   || nCodCliente   || '</CodCliente>';
      cResultado := cResultado || '<IdPoliza>'     || nIdPoliza     || '</IdPoliza>';
      cResultado := cResultado || '<IDetPol>'      || nIDetPol      || '</IDetPol>';
      cResultado := cResultado || '<CodAsegurado>' || nCodAsegurado || '</CodAsegurado>';
      --
      FOR x IN Beneficiarios LOOP
          cResultado := cResultado || '<BENEFICIARIO>';
          cResultado := cResultado || '<NUMBENEFICIARIO>' || x.NumBeneficiario || '</NUMBENEFICIARIO>';
          cResultado := cResultado || '<NOMBREBENEF>'     || x.NombreBenef     || '</NOMBREBENEF>';
          cResultado := cResultado || '<APEPATBENEF>'     || x.ApePatBenef     || '</APEPATBENEF>';
          cResultado := cResultado || '<APEMATBENEF>'     || x.ApeMatBenef     || '</APEMATBENEF>';
          cResultado := cResultado || '<SEXOBENEF>'       || x.SexoBenef       || '</SEXOBENEF>';
          cResultado := cResultado || '<FECNACBENEF>'     || x.FecNacBenef     || '</FECNACBENEF>';
          cResultado := cResultado || '<PORCPARTBENEF>'   || x.PorcPartBenef   || '</PORCPARTBENEF>';
          cResultado := cResultado || '<FECALTABENEF>'    || x.FecAltaBenef    || '</FECALTABENEF>';
          cResultado := cResultado || '<CODPARENTBENEF>'  || x.CodParentBenef  || '</CODPARENTBENEF>';
          cResultado := cResultado || '</BENEFICIARIO>';
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

   FUNCTION REGISTRAR( nCodCia      IN  TICKET_POLIZA_BENEFICIARIO.CodCia%TYPE
                     , nCodEmpresa  IN  TICKET_POLIZA_BENEFICIARIO.CodEmpresa%TYPE
                     , xDatos       IN  XMLTYPE ) RETURN NUMBER IS
      --
      nProceso          NUMBER := 0;
      nContBenef        NUMBER := 0;
      --Variables del Nodo Padre   
      nCodCliente       TICKET_POLIZA_BENEFICIARIO.CodCliente%TYPE;
      nIdPoliza         TICKET_POLIZA_BENEFICIARIO.IdPoliza%TYPE;
      nIdetPol          TICKET_POLIZA_BENEFICIARIO.IdetPol%TYPE;
      nCodAsegurado     TICKET_POLIZA_BENEFICIARIO.CodAsegurado%TYPE;
      --Variables del Nodo Hijo
      nNumBeneficiario  TICKET_POLIZA_BENEFICIARIO.NumBeneficiario%TYPE;
      cNombreBenef      TICKET_POLIZA_BENEFICIARIO.NombreBenef%TYPE;
      cApePatBenef      TICKET_POLIZA_BENEFICIARIO.ApePatBenef%TYPE;
      cApeMatBenef      TICKET_POLIZA_BENEFICIARIO.ApeMatBenef%TYPE;
      cSexoBenef        TICKET_POLIZA_BENEFICIARIO.SexoBenef%TYPE;
      dFecNacBenef      TICKET_POLIZA_BENEFICIARIO.FecNacBenef%TYPE;
      nPorcPartBenef    TICKET_POLIZA_BENEFICIARIO.PorcPartBenef%TYPE;
      dFecAltaBenef     TICKET_POLIZA_BENEFICIARIO.FecAltaBenef%TYPE;
      cCodParentBenef   TICKET_POLIZA_BENEFICIARIO.CodParentBenef%TYPE;
      --Variables para el control del XML
      xParse            XMLPARSER.PARSER;
      xDocumento        XMLDOM.DOMDOCUMENT;
      xNodosPadre       XMLDOM.DOMNODELIST;
      xElementoPadre    XMLDOM.DOMNODE;
      xNodosHijo        XMLDOM.DOMNODELIST;
      xElementoHijo     XMLDOM.DOMNODE;
      cXml              CLOB;
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
            nCodCliente   := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoPadre ));
         ELSIF x = 2 THEN 
            nCodAsegurado := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoPadre ));
         ELSIF x = 3 THEN 
            nIdPoliza     := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoPadre ));
         ELSIF x = 4 THEN 
            nIdetPol      := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoPadre ));
         END IF;
      END LOOP;
      --
      OC_TICKET_POLIZA_BENEFICIARIO.ELIMINAR( nCodCia, nCodEmpresa, nCodCliente, nIdPoliza, nIdetPol, nCodAsegurado, NULL );
      --
      --Empiezo en el nodo que necesitamos
      FOR x IN 5..XMLDOM.GETLENGTH( xNodosPadre ) LOOP
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
               nNumBeneficiario := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoHijo ));
            ELSIF y = 2 THEN
               cNombreBenef := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoHijo ));
            ELSIF y = 3 THEN
               cApePatBenef := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoHijo ));
            ELSIF y = 4 THEN
               cApeMatBenef := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoHijo ));
            ELSIF y = 5 THEN
               cSexoBenef := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoHijo ));
            ELSIF y = 6 THEN
--               IF XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoHijo )) IS NULL THEN
--                  dFecNacBenef := NULL;
--               ELSE
--                  BEGIN
                     dFecNacBenef := TO_DATE(XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoHijo )), 'DD/MM/YYYY');
--                  EXCEPTION
--                  WHEN OTHERS THEN
--                     dFecNacBenef := TO_DATE(XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoHijo )), 'MM/DD/YYYY');
--                  END;
--               END IF;
            ELSIF y = 7 THEN
               nPorcPartBenef := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoHijo ));
            ELSIF y = 8 THEN
--               IF XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoHijo )) IS NULL THEN
--                  dFecNacBenef := NULL;
--               ELSE
--                  BEGIN
                     dFecAltaBenef := TO_DATE(XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoHijo )), 'DD/MM/YYYY');
--                  EXCEPTION
--                  WHEN OTHERS THEN
--                     dFecAltaBenef := TO_DATE(XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoHijo )), 'MM/DD/YYYY');
--                  END;
--               END IF;
            ELSIF y = 9 THEN
               cCodParentBenef := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoHijo ));
            END IF;
         END LOOP;
         --
         OC_TICKET_POLIZA_BENEFICIARIO.INSERTAR( nCodCia      , nCodEmpresa     , nCodCliente   , nIdPoliza    , nIdetPol    ,
                                                 nCodAsegurado, nNumBeneficiario, cNombreBenef  , cApePatBenef , cApeMatBenef,
                                                 cSexoBenef   , dFecNacBenef    , nPorcPartBenef, dFecAltaBenef, cCodParentBenef );
      END LOOP;
      --
      nProceso := 1;
      RETURN nProceso;
   EXCEPTION 
   WHEN OTHERS THEN 
        RETURN 0;
   END REGISTRAR;

   FUNCTION LISTAR( nCodCia        IN  TICKET_POLIZA_BENEFICIARIO.CodCia%TYPE
                  , nCodEmpresa    IN  TICKET_POLIZA_BENEFICIARIO.CodEmpresa%TYPE
                  , nCodCliente    IN  TICKET_POLIZA_BENEFICIARIO.CodCliente%TYPE
                  , nIdPoliza      IN  TICKET_POLIZA_BENEFICIARIO.IdPoliza%TYPE
                  , nIDetPol       IN  TICKET_POLIZA_BENEFICIARIO.IDetPol%TYPE
                  , nCodAsegurado  IN  TICKET_POLIZA_BENEFICIARIO.CodAsegurado%TYPE ) RETURN XMLTYPE IS
      --
      cResultado   CLOB;
      xResultado   XMLTYPE;   
      xResultado1  XMLTYPE;
      --
      CURSOR Beneficiarios IS
         SELECT NumBeneficiario, NombreBenef, ApePatBenef, ApeMatBenef, 
                PorcPartBenef, FecAltaBenef, CodParentBenef
         FROM   TICKET_POLIZA_BENEFICIARIO
         WHERE  CodCia          = nCodCia
           AND  CodEmpresa      = nCodEmpresa
           AND  CodCliente      = nCodCliente
           AND  IdPoliza        = nIdPoliza
           AND  IdetPol         = nIdetPol
           AND  CodAsegurado    = nCodAsegurado
         ORDER BY NumBeneficiario;
   BEGIN
      EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
      --
      cResultado := '<?xml version="1.0"?> <DATA>';
      --
      FOR x IN Beneficiarios LOOP
          cResultado := cResultado || '<BENEFICIARIO>';
          cResultado := cResultado || '<NUMBENEFICIARIO>' || x.NumBeneficiario || '</NUMBENEFICIARIO>';
          cResultado := cResultado || '<NOMBREBENEF>'     || x.NombreBenef     || '</NOMBREBENEF>';
          cResultado := cResultado || '<APEPATBENEF>'     || x.ApePatBenef     || '</APEPATBENEF>';
          cResultado := cResultado || '<APEMATBENEF>'     || x.ApeMatBenef     || '</APEMATBENEF>';
          cResultado := cResultado || '<PORCPARTBENEF>'   || x.PorcPartBenef   || '</PORCPARTBENEF>';
          cResultado := cResultado || '<CODPARENTBENEF>'   || x.CodParentBenef   || '</CODPARENTBENEF>';
          cResultado := cResultado || '</BENEFICIARIO>';
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
   END LISTAR;


   PROCEDURE EMITIR( nCodCia           IN  TICKET_POLIZA_BENEFICIARIO.CodCia%TYPE
                   , nCodEmpresa       IN  TICKET_POLIZA_BENEFICIARIO.CodEmpresa%TYPE
                   , nCodCliente       IN  TICKET_POLIZA_BENEFICIARIO.CodCliente%TYPE
                   , nIdPoliza         IN  TICKET_POLIZA_BENEFICIARIO.IdPoliza%TYPE
                   , nIdetPol          IN  TICKET_POLIZA_BENEFICIARIO.IdetPol%TYPE
                   , nCodAsegurado     IN  TICKET_POLIZA_BENEFICIARIO.CodAsegurado%TYPE
                   , nNumBeneficiario  IN  TICKET_POLIZA_BENEFICIARIO.NumBeneficiario%TYPE ) IS
   BEGIN
      EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
      --
      UPDATE TICKET_POLIZA_BENEFICIARIO
      SET    StsBenef = 'EMI'
      WHERE  CodCia          = nCodCia
        AND  CodEmpresa      = nCodEmpresa
        AND  CodCliente      = nCodCliente
        AND  IdPoliza        = nIdPoliza
        AND  IdetPol         = nIdetPol
        AND  CodAsegurado    = nCodAsegurado
        AND  NumBeneficiario = NVL( nNumBeneficiario, NumBeneficiario );
   END EMITIR;
END OC_TICKET_POLIZA_BENEFICIARIO;
/

--
-- OC_TICKET_POLIZA_BENEFICIARIO  (Synonym) 
--
--  Dependencies: 
--   OC_TICKET_POLIZA_BENEFICIARIO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_TICKET_POLIZA_BENEFICIARIO FOR SICAS_OC.OC_TICKET_POLIZA_BENEFICIARIO
/


GRANT EXECUTE ON SICAS_OC.OC_TICKET_POLIZA_BENEFICIARIO TO PUBLIC
/
