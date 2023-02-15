CREATE OR REPLACE PACKAGE OC_DOCUMENTO IS

   FUNCTION fun_MaximoDoc RETURN  Number;

  PROCEDURE Genera_transaccion(PId_documento Number,Estado_Final Varchar2);
END;
/

CREATE OR REPLACE PACKAGE BODY OC_DOCUMENTO 
IS

/*
Funcion: Que Devuelve el maximo del Campo Id_documento + 1
Creada Por: David Gonzalez
Fecha: 02/07/2009
*/
FUNCTION fun_MaximoDoc RETURN  Number IS
      -- Enter the procedure variables here. As shown below
   nMax        Number(14);
  
BEGIN
   SELECT NVL(MAX(Id_documento),0)+1
     INTO nMax
     FROM Documento ;
     
   RETURN (nMax);
   
END;

PROCEDURE Genera_transaccion(PId_documento Number,Estado_Final Varchar2) IS

    Fecha date;
BEGIN
IF Estado_Final = 'ANU' THEN
    Fecha:=sysdate;
ELSE
   Fecha:=NULL;
END IF;

    UPDATE DOCUMENTO
       SET Estado=Estado_final,
           Fecha_Estado=Sysdate,
           Fecha_Anulacion=Fecha
    WHERE  Id_documento=PId_documento;
END;

   -- Enter further code below as specified in the Package spec.
END;
