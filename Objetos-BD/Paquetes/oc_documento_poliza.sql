--
-- OC_DOCUMENTO_POLIZA  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DOCUMENTO_POLIZA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_DOCUMENTO_POLIZA IS
    PROCEDURE Inserta_Registros(PId_documento Number,PId_Poliza Number);
    FUNCTION fun_MaximoDoc RETURN  Number;
END;
/

--
-- OC_DOCUMENTO_POLIZA  (Package Body) 
--
--  Dependencies: 
--   OC_DOCUMENTO_POLIZA (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_DOCUMENTO_POLIZA 
IS
FUNCTION fun_MaximoDoc RETURN  Number IS
      -- Enter the procedure variables here. As shown below
   nMax        Number(14);

BEGIN
   SELECT NVL(MAX(IdDocumentoPoliza),0)+1
     INTO nMax
     FROM Documento_Poliza ;

   RETURN (nMax);

END;
PROCEDURE Inserta_Registros(PId_documento Number,PId_Poliza Number) IS
    nMax    Number(14);
BEGIN
    nMax :=fun_MaximoDoc;
    INSERT INTO Documento_Poliza
    (IdDocumentoPoliza,IdDocumento,IdPoliza)
    VALUES
    (nMax ,PId_documento,PId_Poliza );
END;
END;
/

--
-- OC_DOCUMENTO_POLIZA  (Synonym) 
--
--  Dependencies: 
--   OC_DOCUMENTO_POLIZA (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_DOCUMENTO_POLIZA FOR SICAS_OC.OC_DOCUMENTO_POLIZA
/


GRANT EXECUTE ON SICAS_OC.OC_DOCUMENTO_POLIZA TO PUBLIC
/
