CREATE OR REPLACE PACKAGE THONAPI.FLUJO_SINIESTROS_SIGO IS
function agente(cTipo_Doc_Identificacion varchar2,cNum_Doc_Identificacion varchar2,nidpoliza number,nidetpol number) return varchar2;

END FLUJO_SINIESTROS_SIGO;
/

CREATE OR REPLACE PACKAGE BODY THONAPI.FLUJO_SINIESTROS_SIGO IS
   --
function agente(cTipo_Doc_Identificacion varchar2,cNum_Doc_Identificacion varchar2,nidpoliza number,nidetpol number) return varchar2 is
ccod_asegurado ASEGURADO_CERTIFICADO.Cod_Asegurado%TYPE;
nidendoso ASEGURADO_CERTIFICADO.IdEndoso%TYPE;
cestatusAseg ASEGURADO_CERTIFICADO.Estado%TYPE;
nCAMPO3 ASEGURADO_CERTIFICADO.CAMPO3%TYPE;
begin
    BEGIN
      SELECT   A.Cod_Asegurado, AC.IdEndoso, AC.CAMPO3, AC.Estado
        INTO cCod_Asegurado, nIdEndoso, nCAMPO3, cEstatusAseg
        FROM ASEGURADO A, ASEGURADO_CERTIFICADO AC, POLIZAS P
       WHERE P.IdPoliza                = nIdPoliza
         AND P.IdPoliza                = AC.IdPoliza
         AND P.CodCia                  = A.CodCia
         AND AC.CodCia                 = A.CodCia
         AND AC.Cod_Asegurado          = A.Cod_Asegurado
         AND AC.IDetPol                = nIDetPol 
         AND A.Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND A.Num_Doc_Identificacion  = cNum_Doc_Identificacion
      UNION
      SELECT  A.Cod_Asegurado,  0 , NULL, NULL
        FROM ASEGURADO A, ASEGURADO_CERT AC, POLIZAS P
       WHERE P.IdPoliza                = nIdPoliza
         AND P.IdPoliza                = AC.IdPoliza
         AND P.CodCia                  = A.CodCia
         AND AC.CodCia                 = A.CodCia
         AND AC.Cod_Asegurado          = A.Cod_Asegurado
         AND AC.IDETPOL                = nIDetPol 
         AND A.Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND A.Num_Doc_Identificacion  = cNum_Doc_Identificacion
      UNION
      SELECT  A.Cod_Asegurado, 0 , NULL, NULL
        FROM ASEGURADO A, DETALLE_POLIZA D
       WHERE OC_ASEGURADO_CERTIFICADO.TIENE_ASEGURADOS(D.CodCia, D.IdPoliza, D.IDetPol, 0) = 'N'
         AND D.IdPoliza                = nIdPoliza
         AND D.CodCia                  = A.CodCia
         AND D.Cod_Asegurado           = A.Cod_Asegurado
         AND A.Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND A.Num_Doc_Identificacion  = cNum_Doc_Identificacion;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        cCod_Asegurado := NULL;
      WHEN TOO_MANY_ROWS THEN
        cCod_Asegurado := NULL;
    END;
return ccod_asegurado;    
end agente;

END FLUJO_SINIESTROS_SIGO;
/

CREATE OR REPLACE PUBLIC SYNONYM FLUJO_SINIESTROS_SIGO FOR THONAPI.FLUJO_SINIESTROS_SIGO
/

GRANT EXECUTE ON THONAPI.FLUJO_SINIESTROS_SIGO TO PUBLIC
/