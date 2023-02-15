CREATE OR REPLACE PACKAGE OC_DOCUMENTO_POLIZA IS
    PROCEDURE Inserta_Registros(PId_documento Number,PId_Poliza Number);
    FUNCTION fun_MaximoDoc RETURN  Number;
END;
/

CREATE OR REPLACE PACKAGE BODY OC_DOCUMENTO_POLIZA 
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
