CREATE OR REPLACE PACKAGE OC_FACT_ELECT_USO_CFDI AS
FUNCTION PERSONA_FISICA (nCodCia NUMBER, cCodUsoCFDI VARCHAR2) RETURN VARCHAR2;
FUNCTION PERSONA_MORAL (nCodCia NUMBER, cCodUsoCFDI VARCHAR2) RETURN VARCHAR2;
FUNCTION DESCRIPCION (nCodCia NUMBER, cCodUsoCFDI VARCHAR2) RETURN VARCHAR2;
FUNCTION LISTADO_WEB (nCodCia NUMBER, nIdRegFisSat NUMBER, cTipoPersona VARCHAR2, nLimInferior NUMBER, nLimSuperior NUMBER, nTotRegs OUT NUMBER) RETURN XMLTYPE;
END OC_FACT_ELECT_USO_CFDI;

/

CREATE OR REPLACE PACKAGE BODY OC_FACT_ELECT_USO_CFDI AS
FUNCTION PERSONA_FISICA (nCodCia NUMBER, cCodUsoCFDI VARCHAR2) RETURN VARCHAR2 IS
cIndPersFisica FACT_ELECT_USO_CFDI.IndPersFisica%TYPE;
BEGIN
   BEGIN 
      SELECT NVL(IndPersFisica,'N')
        INTO cIndPersFisica
        FROM FACT_ELECT_USO_CFDI
       WHERE CodCia     = nCodCia
         AND CodUsoCFDI = cCodUsoCFDI;
   END;
   RETURN cIndPersFisica;
END PERSONA_FISICA;

FUNCTION PERSONA_MORAL (nCodCia NUMBER, cCodUsoCFDI VARCHAR2) RETURN VARCHAR2 IS
cIndPersMoral FACT_ELECT_USO_CFDI.IndPersMoral%TYPE;
BEGIN
   BEGIN 
      SELECT NVL(IndPersMoral,'N')
        INTO cIndPersMoral
        FROM FACT_ELECT_USO_CFDI
       WHERE CodCia     = nCodCia
         AND CodUsoCFDI = cCodUsoCFDI;
   END;
   RETURN cIndPersMoral;
END PERSONA_MORAL;

FUNCTION DESCRIPCION (nCodCia NUMBER, cCodUsoCFDI VARCHAR2) RETURN VARCHAR2 IS
cDescUsoCFDI   FACT_ELECT_USO_CFDI.DescUsoCFDI%TYPE;
BEGIN
   BEGIN
      SELECT NVL(DescUsoCFDI,'NA')
        INTO cDescUsoCFDI
        FROM FACT_ELECT_USO_CFDI
       WHERE CodCia     = nCodCia
         AND CodUsoCFDI = cCodUsoCFDI;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescUsoCFDI := 'No Existe';
   END;
   RETURN cDescUsoCFDI;
END DESCRIPCION;

FUNCTION LISTADO_WEB (nCodCia NUMBER, nIdRegFisSat NUMBER, cTipoPersona VARCHAR2, nLimInferior NUMBER, nLimSuperior NUMBER, nTotRegs OUT NUMBER) RETURN XMLTYPE IS
xListadoUsoCFDI   XMLTYPE;
xPrevUsoCFDI      XMLTYPE;
BEGIN
   BEGIN
        --> Listado
	    SELECT XMLELEMENT("DATA",
                            XMLAGG(XMLELEMENT("USOCFDI",  
                                                XMLELEMENT("CodUsoCfdi", CodUsoCfdi),
                                                XMLELEMENT("DescUsoCfdi", DescUsoCfdi),
                                                XMLELEMENT("FecIniVig", TO_CHAR(FecIniVig,'DD/MM/YYYY')),
                                                XMLELEMENT("FecFinVig", TO_CHAR(FecFinVig,'DD/MM/YYYY')),
                                                XMLELEMENT("IndPersFisica", IndPersFisica),
                                                XMLELEMENT("IndPersMoral", IndPersMoral),
                                                XMLELEMENT("IdRegFisSat", IdRegFisSat)
                                            )
                                  )
                        )
         INTO xPrevUsoCFDI
         FROM (SELECT U.CodUsoCfdi, 
                      U.DescUsoCfdi, 
                      U.FecIniVig, 
                      U.FecFinVig, 
                      U.IndPersFisica, 
                      U.IndPersMoral, 
                      R.IdRegFisSat,
                      ROW_NUMBER() OVER (ORDER BY U.CodUsoCfdi) Registro
                 FROM FACT_ELECT_USO_CFDI U, FACT_ELECT_USO_CFDI_REG R,
                      CAT_REGIMEN_FISCAL C
                WHERE U.CodCia      = R.CodCia
                  AND U.CodUsoCfdi  = R.CodUsoCfdi
                  AND R.IdRegFisSat = C.IdRegFisSat
                  AND U.CodCia      = nCodCia
                  AND R.IdRegFisSat = nIdRegFisSat
                  AND C.TipoPersona = CASE cTipoPersona 
                                       WHEN 'FISICA' THEN 'F'
                                       WHEN 'MORAL' THEN 'M'
                                      END
              ) 
        WHERE Registro BETWEEN nLimInferior AND nLimSuperior;

      SELECT NVL(COUNT(U.CodUsoCfdi),0)
        INTO nTotRegs
        FROM FACT_ELECT_USO_CFDI U, FACT_ELECT_USO_CFDI_REG R,
             CAT_REGIMEN_FISCAL C
       WHERE U.CodCia      = R.CodCia
         AND U.CodUsoCfdi  = R.CodUsoCfdi
         AND R.IdRegFisSat = C.IdRegFisSat
         AND U.CodCia      = nCodCia
         AND R.IdRegFisSat = nIdRegFisSat
         AND C.TipoPersona = CASE cTipoPersona 
                              WHEN 'FISICA' THEN 'F'
                              WHEN 'MORAL' THEN 'M'
                             END;
   END;    

   SELECT XMLROOT (xPrevUsoCFDI, VERSION '1.0" encoding="UTF-8')
     INTO xListadoUsoCFDI
     FROM DUAL;

   RETURN xListadoUsoCFDI;    
END LISTADO_WEB;

END OC_FACT_ELECT_USO_CFDI;
