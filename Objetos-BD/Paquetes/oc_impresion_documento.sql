--
-- OC_IMPRESION_DOCUMENTO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DUAL (Synonym)
--   DOCUMENTO (Table)
--   DOCUMENTO_POLIZA (Table)
--   TMP_DOCUMENTO_POLIZA (Table)
--   SQ_TMPDOCTOPOL (Sequence)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_IMPRESION_DOCUMENTO IS
  FUNCTION Fun_DevuelveTexto(pTexto Varchar2,pIdPoliza Number) RETURN  Varchar2;
  PROCEDURE InsRegistro_TablaTemp(PId_Poliza Number);
END; -- Package spec
/

--
-- OC_IMPRESION_DOCUMENTO  (Package Body) 
--
--  Dependencies: 
--   OC_IMPRESION_DOCUMENTO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_IMPRESION_DOCUMENTO IS
FUNCTION Fun_DevuelveTexto(pTexto Varchar2,pIdPoliza Number) RETURN  VARCHAR2 IS

  pTextoNuevo Varchar2(1000);
  cTextoNuevo Varchar2(1000);
  cBusqueda Varchar2(100);
  cBusquedaRe Varchar2(100);
  nValorI Number;
  nCodCLiente Number;
  nIdPoliza Number;
  nValorF Number;
  cQuery Varchar2(2500);
  cConsulta Varchar2(1000);
  cParametro Varchar2(100);
BEGIN
  pTextoNuevo := pTexto;
  loop
   Select Instr(pTextoNuevo,'@@')
     Into nValorI
     from dual;

   Select Instr(pTextoNuevo,'@@',nValorI+1,1)
     Into nValorF
     from dual;

  Select Substr(pTextoNuevo,nValorI+2,(nValorF-nValorI)-2)
     Into cBusqueda
     from dual;

  Select Substr(pTextoNuevo,nValorI,(nValorF-nValorI)+2)
     Into cBusquedaRe
     from dual;

  cQuery := 'Select Consulta from DocumentoCampo Where Descripcion like '||CHR(39)|| cBusqueda ||CHR(39);

   EXECUTE IMMEDIATE cQuery INTO cConsulta;
   cConsulta:=cConsulta ||pIdPoliza;
   EXECUTE ImMEDIATE cConsulta INTO cParametro;

   Select Replace(pTextoNuevo,cBusquedaRe,cParametro)
     Into pTextoNuevo
     from dual;
   cQuery:='';
   cConsulta:='';

   Exit When nValorI= 0;

   End loop;
   RETURN (pTextoNuevo);
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN (pTextoNuevo);
         cConsulta := NULL;
         cParametro:= NULL;


END;
PROCEDURE InsRegistro_TablaTemp(PId_Poliza Number) IS
    Ctexto      Varchar2(1000);
    ctextoNuevo Varchar2(1000);
    nUserId     Number;
BEGIN
   SELECT texto
     INTO Ctexto
     FROM documento_poliza a, documento b
    WHERE a.iddocumento =b.id_documento and a.idpoliza =PId_Poliza;

    SELECT userenv('sessionId')
      INTO nUserId
      FROM dual;

    ctextoNuevo:=Fun_devuelveTexto(cTexto,PId_Poliza);

    INSERT INTO Tmp_Documento_Poliza
    (Id_Documento_Poliza,Id_documento,Id_Poliza,Descripcion,Texto,PathImagen,PathFirma,DescFirma,Sesion)
    SELECT Sq_tmpDoctoPol.NEXTVAL, a.iddocumento,a.idpoliza,b.descripcion,ctextoNuevo,b.pathimagen,b.pathfirma,b.descfirma,nUserId
      FROM documento_poliza a, documento b
     WHERE a.iddocumento =b.id_documento
       AND a.idpoliza =PId_Poliza;

  EXCEPTION
      WHEN NO_DATA_FOUND THEN
         Ctexto := NULL;
         nUserId:= 0;


END;

END;
/
