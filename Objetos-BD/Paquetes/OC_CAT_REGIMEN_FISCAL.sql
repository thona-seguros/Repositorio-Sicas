create or replace PACKAGE OC_CAT_REGIMEN_FISCAL AS

FUNCTION FUN_NOMBRE_REGFIS (nIdRegimen NUMBER)  RETURN VARCHAR2;
	--
	FUNCTION FUN_PROCENTAJEISR (nIdRegimen NUMBER)  RETURN VARCHAR2;
	FUNCTION FUN_NIVELCTA3     (nIdRegimen NUMBER)  RETURN VARCHAR2;
	FUNCTION TIPO_PERSONA      (nIdRegimen NUMBER)  RETURN VARCHAR2;
	FUNCTION LISTADO_WEB       (nLimInferior NUMBER, nLimSuperior NUMBER, nTotRegs OUT NUMBER) RETURN XMLTYPE;
    	FUNCTION FUN_AGENTE_IDREGFISSAT (PCODCIA NUMBER, PCODEMPRESA NUMBER, PCOD_AGENTE NUMBER) RETURN NUMBER;
	--
END OC_CAT_REGIMEN_FISCAL;
/
create or replace PACKAGE BODY          OC_CAT_REGIMEN_FISCAL IS

FUNCTION FUN_NOMBRE_REGFIS ( nIdRegimen NUMBER) RETURN VARCHAR2 IS
   cNomRegFis      CAT_REGIMEN_FISCAL.DescTipoRegimen%TYPE;
BEGIN
   SELECT NVL(DescTipoRegimen,'NA')
     INTO cNomRegFis
     FROM CAT_REGIMEN_FISCAL C
    WHERE IdRegFisSAT = nIdRegimen;
   --
   RETURN ( cNomRegFis );

EXCEPTION WHEN OTHERS THEN
   RETURN NULL;
END FUN_NOMBRE_REGFIS;
--
FUNCTION FUN_PROCENTAJEISR ( nIdRegimen NUMBER) RETURN VARCHAR2 IS
   cPORCCONCEPTO      CAT_REGIMEN_FISCAL.PORCCONCEPTO%TYPE;
BEGIN    
   SELECT PORCCONCEPTO
     INTO cPORCCONCEPTO
     FROM CAT_REGIMEN_FISCAL C
    WHERE IdRegFisSAT = nIdRegimen;
   --
   RETURN ( cPORCCONCEPTO );

EXCEPTION WHEN OTHERS THEN
   RETURN NULL;
END FUN_PROCENTAJEISR;
--
FUNCTION FUN_NIVELCTA3 ( nIdRegimen NUMBER) RETURN VARCHAR2 IS
   cNIVELCTA3      CAT_REGIMEN_FISCAL.NIVELCTA3%TYPE;
BEGIN    
   SELECT NIVELCTA3
     INTO CNIVELCTA3
     FROM CAT_REGIMEN_FISCAL C
    WHERE IdRegFisSAT = nIdRegimen;
   --
   RETURN ( cNIVELCTA3 );

EXCEPTION WHEN OTHERS THEN
   RETURN NULL;
END FUN_NIVELCTA3;
--

FUNCTION TIPO_PERSONA      (nIdRegimen NUMBER)  RETURN VARCHAR2 IS 
cTipoPersona   CAT_REGIMEN_FISCAL.TipoPersona%TYPE;
BEGIN
   BEGIN
      SELECT NVL(TipoPersona,'N')
        INTO cTipoPersona
        FROM CAT_REGIMEN_FISCAL
       WHERE IdRegFisSAT = nIdRegimen;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTipoPersona := 'N';
   END;
   RETURN cTipoPersona;
END TIPO_PERSONA;    

FUNCTION LISTADO_WEB (nLimInferior NUMBER, nLimSuperior NUMBER, nTotRegs OUT NUMBER) RETURN XMLTYPE IS
xListadoRegFiscal   XMLTYPE;
xPrevRegFiscal      XMLTYPE;
BEGIN
   BEGIN
        --> Listado
	    SELECT XMLELEMENT("DATA",
                            XMLAGG(XMLELEMENT("REGIMENFISCAL",  
                                                XMLELEMENT("IdRegFisSat", IdRegFisSat),
                                                XMLELEMENT("DescTipoRegimen", DescTipoRegimen),
                                                XMLELEMENT("TipoPersona", TipoPersona),
                                                XMLELEMENT("FecIniVig", TO_CHAR(FecIniVig,'DD/MM/YYYY')),
                                                XMLELEMENT("FecFinVig", TO_CHAR(FecFinVig,'DD/MM/YYYY'))
                                            )
                                  )
                        )
         INTO xPrevRegFiscal
         FROM (SELECT IdRegFisSat,
                      DescTipoRegimen,
                      TipoPersona,
                      NVL(FecIniVig, TO_DATE('01/01/2000', 'DD/MM/YYYY')) FecIniVig,
                      NVL(FecFinVig, TO_DATE('31/12/9999','DD/MM/YYYY')) FecFinVig,
                      ROW_NUMBER() OVER (ORDER BY IdRegFisSat) Registro
                 FROM CAT_REGIMEN_FISCAL
              ) 
        WHERE Registro BETWEEN nLimInferior AND nLimSuperior;

      SELECT NVL(COUNT(*),0)
        INTO nTotRegs
        FROM CAT_REGIMEN_FISCAL;
   END;    
   SELECT XMLROOT (xPrevRegFiscal, VERSION '1.0" encoding="UTF-8')
     INTO xListadoRegFiscal
     FROM DUAL;
   RETURN xListadoRegFiscal;
END LISTADO_WEB;

    --
    FUNCTION FUN_AGENTE_IDREGFISSAT (PCODCIA NUMBER, PCODEMPRESA NUMBER, PCOD_AGENTE NUMBER) RETURN NUMBER IS
        nIDREGFISSAT   CAT_REGIMEN_FISCAL.IDREGFISSAT%TYPE;
    BEGIN

        SELECT P.IDREGFISSAT 
          INTO nIDREGFISSAT
          FROM SICAS_OC.AGENTES A INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA P ON A.TIPO_DOC_IDENTIFICACION = P.TIPO_DOC_IDENTIFICACION
                                                                                AND A.NUM_DOC_IDENTIFICACION  = P.NUM_DOC_IDENTIFICACION
        WHERE COD_AGENTE = PCOD_AGENTE
          AND CODCIA     = PCODCIA 
          AND CODEMPRESA = PCODEMPRESA;
       --
       RETURN ( nIDREGFISSAT );

    EXCEPTION WHEN OTHERS THEN
        RETURN NULL;
    END FUN_AGENTE_IDREGFISSAT;
    --

END OC_CAT_REGIMEN_FISCAL;
/
CREATE OR REPLACE PUBLIC SYNONYM OC_CAT_REGIMEN_FISCAL ON SICAS_OC.OC_CAT_REGIMEN_FISCAL;
/
GRANT EXECUTE FOR OC_CAT_REGIMEN_FISCAL TO PUBLIC;