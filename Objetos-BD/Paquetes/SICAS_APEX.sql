create or replace PACKAGE SICAS_OC.SICAS_APEX AS
FUNCTION FUNC_CODPOSTAL(p_Postal VARCHAR2) RETURN  VARCHAR2;
FUNCTION FUNC_PAIS(p_Pais VARCHAR2) RETURN  VARCHAR2;
FUNCTION FUNC_Provincia(p_Pais VARCHAR2, p_Estado VARCHAR2) RETURN VARCHAR2;
FUNCTION Func_Distrito(p_Pais VARCHAR2, p_Estado VARCHAR2, p_Ciudad VARCHAR2) RETURN  VARCHAR2;
FUNCTION Func_Corregimiento(p_pais varchar2, p_estado varchar2,p_ciudad varchar2, p_municipio varchar2) return VARCHAR2;
FUNCTION  FUNC_COLONIA(p_Postal VARCHAR2, p_Colonia VARCHAR2 , p_Codpais varchar2,p_CodEstado varchar2, p_CodCiudad varchar2, p_Codmunicipio varchar2) RETURN  VARCHAR2;
FUNCTION TRAE_NOMBRE_SUBGRUPO(nCodCia IN NUMBER, nCodfilial IN VARCHAR2, nCodgrupoec IN VARCHAR2) RETURN VARCHAR2;
FUNCTION get_fecha_pago(nCODCIA NUMBER,NIDPOLIZA NUMBER)  RETURN DATE;
FUNCTION get_nombre_ejecutivo(CCod_Agente_Distr VARCHAR2) RETURN VARCHAR2;
FUNCTION FORMA_PAGO_AGENTE (cCODINTER VARCHAR2) RETURN VARCHAR2;
FUNCTION CORREO_AGENTE(ccodinter varchar2) return varchar2;
function get_estatus_pago(ccodcia number,nidpoliza number) return varchar2;
function color_agente(ccodagente varchar2) return varchar2;

function nombre_cod_pago(nidsiniestro number,nIdDetSin number,nnum_aprob number,cCod_Pago varchar2) return varchar2;
function nombre_cobertura (nidsiniestro number,ccodcobert varchar2) return varchar2;
function color_factura(nidfactura number,cstsfact varchar2,cinddomiciliado varchar2,cindpagprod varchar2) return varchar2;
procedure actualiza_aprob (nidsiniestro number, nnumaprob number);
procedure actualiza_aprob_ind (nidsiniestro number, nnumaprob number);
procedure borra_rangos (nidbonoventas number,ctiponvo varchar2 );
FUNCTION SUMA_ASEG_REMANENTE_IND (CCODCIA NUMBER,NIDPOLIZA NUMBER, NIDETPOL NUMBER,CCODCOBERT VARCHAR2) RETURN NUMBER;

procedure emite_rva (P100_IDpoliza number,P100_IdSiniestro number,P100_IdDetSin number,P100_IdPoliza_val number,
                     P100_Monto_Reservado_Moneda number,p100_CodCobert varchar2,p100_NumMod number,P100_nIDETPOL number,
                     ccodcia number,capp_user varchar2,cCodEmpresa number);
procedure activar_aprobacion (ccodcia number,P100_IDSINIESTRO number,P100_NUMAPROB number,P100_NUMMOD number,P100_TXTISR in out varchar2,capp_user varchar2);
procedure PAGAR_APROBACION (p100_IDSINIESTRO NUMBER,p100_NUMAPROB NUMBER,CAPP_USER VARCHAR2,P100_NUMMOD NUMBER);
FUNCTION NOMBRE_PERSONA(cTipoDocIdent VARCHAR2, nNumDocIdent VARCHAR2) RETURN VARCHAR2;

procedure ANULAR_APROBACION(NCodCia NUMBER, nCodEmpresa NUMBER,p100_NumAprob NUMBER,p100_IdSiniestro NUMBER,p100_IdPoliza NUMBER, P100_IdDetSin NUMBER,
                            Capp_USER VARCHAR2,P100_IdTipoSeg VARCHAR2,P100_MONTO_MONEDA NUMBER);

END SICAS_APEX;

/

create or replace PACKAGE BODY SICAS_OC.SICAS_APEX AS
FUNCTION FUNC_CODPOSTAL(p_Postal VARCHAR2) RETURN  VARCHAR2 IS
   cPostal  VARCHAR2(100);
BEGIN
   SELECT Descripcion_Postal
     INTO cPostal
     FROM APARTADO_POSTAL
    WHERE Codigo_Postal = p_Postal;
   RETURN(cPostal);
EXCEPTION 
   WHEN NO_DATA_FOUND THEN
      RETURN('NO EXISTE');
END;
FUNCTION FUNC_PAIS(p_Pais VARCHAR2) RETURN  VARCHAR2 IS
   cPais  VARCHAR2(50);
BEGIN
   SELECT DescPais
     INTO cPais
     FROM PAIS
    WHERE CodPais  = p_Pais;
   RETURN(cPais);
EXCEPTION 
   WHEN NO_DATA_FOUND THEN
      RETURN('NO EXISTE');
END;
FUNCTION FUNC_Provincia(p_Pais VARCHAR2, p_Estado VARCHAR2) RETURN VARCHAR2 IS
   cProvincia  VARCHAR2(50);
BEGIN
   SELECT DescEstado
     INTO cProvincia
     FROM PROVINCIA
    WHERE CodPais  = p_Pais
      AND CodEstado = p_Estado;
   RETURN(cProvincia);
EXCEPTION 
   WHEN NO_DATA_FOUND THEN
      RETURN('NO EXISTE');
END;
FUNCTION Func_Distrito(p_Pais VARCHAR2, p_Estado VARCHAR2, p_Ciudad VARCHAR2) RETURN  VARCHAR2 IS
   cDistrito  VARCHAR2(50);
BEGIN
   SELECT DescCiudad
     INTO cDistrito
     FROM DISTRITO
    WHERE CodPais  = p_Pais
      AND CodEstado = p_Estado
      AND CodCiudad = p_Ciudad;
   RETURN(cDistrito);
EXCEPTION 
   WHEN NO_DATA_FOUND THEN
      RETURN('NO EXISTE');
END;
FUNCTION Func_Corregimiento(p_pais varchar2, p_estado varchar2,
                            p_ciudad varchar2, p_municipio varchar2) return VARCHAR2 is
   cCorregi VARCHAR2(50) := 'No Existe';
BEGIN
   SELECT DescMunicipio
     INTO cCorregi
     FROM CORREGIMIENTO
    WHERE CodPais       = p_Pais
      AND CodEstado     = p_Estado
      AND CodCiudad     = p_Ciudad
      AND CodMunicipio  = p_Municipio;
   RETURN(cCorregi);
EXCEPTION 
   WHEN NO_DATA_FOUND THEN
      RETURN('NO EXISTE');
END;
FUNCTION  FUNC_COLONIA(p_Postal VARCHAR2, p_Colonia VARCHAR2 , p_Codpais varchar2,
								 p_CodEstado varchar2, p_CodCiudad varchar2, p_Codmunicipio varchar2) RETURN  VARCHAR2 IS
   cColonia  VARCHAR2(100);
BEGIN
   SELECT Descripcion_colonia
     INTO cColonia
    FROM COLONIA
    WHERE Codigo_Colonia  = p_Colonia
    AND Codigo_Postal = p_Postal
    AND CODPAIS=p_CodPais
    and CodEstado=p_CodEstado
    and CodCiudad=p_CodCiudad
    and CodMunicipio=p_CodMunicipio;
   RETURN(cColonia);
EXCEPTION 
   WHEN NO_DATA_FOUND THEN
      RETURN('NO EXISTE');
END;
FUNCTION TRAE_NOMBRE_SUBGRUPO(nCodCia IN NUMBER, nCodfilial IN VARCHAR2, nCodgrupoec IN VARCHAR2) RETURN VARCHAR2 IS

cDescSubgrupo   VARCHAR2(100);
BEGIN
         
       BEGIN 
         SELECT  UNIQUE(PNJ.NOMBRE) INTO cDescSubgrupo  ---PNJ.NOMBRE
         --INTO    :BK_POLIZAS.DESC_SUBGRUPO
         FROM   FILIALES                  FI
               ,PERSONA_NATURAL_JURIDICA  PNJ
         WHERE  FI.CODCIA     = nCodCia  --1 ---x.CodCia 
         AND    FI.CODGRUPOEC = nCodgrupoec   ---'GEDR-00000944'--X.CODGRUPOEC
         AND    FI.CODFILIAL  = nCodfilial    ---'DOCENTES'--X.CODFILIAL
         --
         AND    PNJ.TIPO_DOC_IDENTIFICACION = FI.TIPO_DOC_IDENTIFICACION
         AND    PNJ.NUM_DOC_IDENTIFICACION  = FI.NUM_DOC_IDENTIFICACION
         ;
       EXCEPTION   WHEN NO_DATA_FOUND THEN
                   cDescSubgrupo := ' NO EXISTE NOMBRE ';
                   WHEN OTHERS THEN
                   cDescSubgrupo := ' OTHERS SIN NOMBRE ';
       END;            
  RETURN ( cDescSubgrupo );
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN ( 'SIN NOMBRE ');  
END;

FUNCTION get_fecha_pago(nCODCIA NUMBER,NIDPOLIZA NUMBER)  RETURN DATE IS
DFECPAGO DATE;
CURSOR POL_Q IS
  SELECT DISTINCT P.CodCliente, REPLACE(OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente),',') NomContratante,
         P.NumPolUnico, DP.IdPoliza, DP.IDetPol, DP.FecIniVig, DP.FecFinVig,
         DP.IdTipoSeg, DP.PlanCob, DP.StsDetalle, DP.CodEmpresa, P.IndPolCol,
         OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(DP.CodCia, DP.CodEmpresa, DP.IdTipoSeg) DescTipoSeg,
         OC_PLAN_COBERTURAS.NOMBRE_PLANCOB(DP.CodCia, DP.CodEmpresa, DP.IdTipoSeg, DP.PlanCob) DescPlanCob,
         OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', DP.StsDetalle) DescStatus,
         P.NUMPOLREF, DP.Cod_Asegurado, P.CodCia CodCia,
         OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ADMINPOL',P.TipoAdministracion) TipoAdmon,
         OC_PLAN_DE_PAGOS.DESCRIPCION_PLAN(DP.CodCia, DP.CodEmpresa, DP.CodPlanPago) PlanPago,
         OC_PLAN_DE_PAGOS.FRECUENCIA_PAGOS(DP.CodCia, DP.CodEmpresa, DP.CodPlanPago) FrecPago,
         P.CodGrupoEc CodGrupoEc, DP.CodFilial CodFilial, DP.CodCategoria CodCategoria,
         P.DescPoliza, AP.Cod_Agente CodAgente, OC_AGENTES.NOMBRE_AGENTE(DP.CodCia, AP.Cod_Agente) NomAgente,
         P.FecRenovacion FecRenovacion, P.StsPoliza, P.IndFacturaPol, P.CodAgrupador,
         OC_VALORES_DE_LISTAS.BUSCA_LVALOR('AGRUPA', P.CodAgrupador) DescAgrupador
    FROM POLIZAS P, DETALLE_POLIZA DP , AGENTE_POLIZA AP
   WHERE DP.IdPoliza     = P.IdPoliza
     AND DP.CodEmpresa   = P.CodEmpresa
     AND DP.CodCia       = P.CodCia
     AND P.CodCia        = NCodCia
     AND AP.CODCIA   = P.CODCIA
     AND AP.IDPOLIZA = P.IDPOLIZA                    
     AND AP.IND_PRINCIPAL = 'S'
     AND P.IDPOLIZA = NIDPOLIZA
     
   ORDER BY DP.IdPoliza DESC, DP.IDetPol ASC;
BEGIN
  FOR X IN POL_Q LOOP
   IF X.IndFacturaPol = 'S' THEN  


		  BEGIN
		     SELECT MAX(FECFINVIG)
		       INTO dFecPago
		       FROM FACTURAS
		      WHERE Codcia   = X.CodCia
		        AND IdPoliza = X.IdPoliza
		        AND StsFact  = 'PAG';
		  EXCEPTION
		    	WHEN NO_DATA_FOUND THEN
		         dFecPago  := NULL; 
		      WHEN OTHERS THEN
		         dFecPago  := NULL; 
		   END;    
    ELSE
    	 BEGIN
		    	SELECT MAX(FECFINVIG)
		        INTO dFecPago
		        FROM FACTURAS
		       WHERE Codcia   = X.CodCia
		         AND IdPoliza = X.IdPoliza
		         AND IDetPol  = X.IDetPol
		         AND StsFact  = 'PAG';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            dFecPago  := NULL; 
         WHEN OTHERS THEN
            dFecPago  := NULL; 
      END;	
   END IF;
    
  END LOOP;
  return dfecpago;
END;

FUNCTION get_nombre_ejecutivo(CCod_Agente_Distr VARCHAR2) RETURN VARCHAR2 is
cnomejecutivo VARCHAR2(1000);
BEGIN
  BEGIN
   SELECT OC_EJECUTIVO_COMERCIAL.NOMBRE_EJECUTIVO(A.CODCIA, A.CODEJECUTIVO)
     INTO cnomejecutivo
     FROM AGENTES A
    WHERE A.COD_AGENTE =  cCod_Agente_Distr;
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN
         cnomejecutivo := 'NO HAY EJECUTIVO';
    WHEN TOO_MANY_ROWS THEN
         cnomejecutivo := 'EJECUTIVO DUPLICADO';
    WHEN OTHERS THEN
         cnomejecutivo := 'EJECUTIVO MAL DEFINIDO';
  END;
  --
  RETURN cNomEjecutivo;
  --
END;

FUNCTION FORMA_PAGO_AGENTE (cCODINTER VARCHAR2) RETURN VARCHAR2 IS
cDescFormaPago VARCHAR2(1000);
BEGIN 
    FOR X IN (SELECT * FROM AGENTES WHERE COD_AGENTE = cCODINTER) LOOP
      IF OC_MEDIOS_DE_PAGO.NUMERO_DE_TARJETA(X.Tipo_Doc_Identificacion, 
                                             X.Num_Doc_Identificacion,
                                             X.IdFormaPago) IS NOT NULL THEN
         cDescFormaPago := cDescFormaPago || ' No. Tarjeta ' ||
                                               OC_MEDIOS_DE_PAGO.NUMERO_DE_TARJETA(X.Tipo_Doc_Identificacion, 
                                                                                   X.Num_Doc_Identificacion,
                                                                                   X.IdFormaPago) || ' y Vence el ' ||
                                               OC_MEDIOS_DE_PAGO.VENCIMIENTO_TARJETA(X.Tipo_Doc_Identificacion, 
                                                                                     X.Num_Doc_Identificacion,
                                                                                     X.IdFormaPago);
      ELSE
         cDescFormaPago := cDescFormaPago || ' Cta. Bancaria ' ||
                                               OC_MEDIOS_DE_PAGO.CUENTA_BANCARIA(X.Tipo_Doc_Identificacion, 
                                                                                 X.Num_Doc_Identificacion,
                                                                                 X.IdFormaPago) || ' CLABE ' ||
                                               OC_MEDIOS_DE_PAGO.CUENTA_CLABE(X.Tipo_Doc_Identificacion, 
                                                                              X.Num_Doc_Identificacion,
                                                                              X.IdFormaPago);
      END IF;
    END LOOP;      
    RETURN cDescFormaPago;
END;
FUNCTION CORREO_AGENTE(ccodinter varchar2) return varchar2 is
cDescCuentaCorreo VARCHAR2(1000);
wCorrelativo number;
BEGIN 
   FOR X IN (SELECT * FROM AGENTES WHERE COD_AGENTE = cCODINTER) LOOP
   IF x.Idcuentacorreo IS NOT NULL THEN
      IF OC_CORREOS_ELECTRONICOS_PNJ.EXISTE_EMAIL (x.Tipo_Doc_Identificacion, 
                                                   x.Num_Doc_Identificacion,
                                                   x.IdCuentaCorreo) = 'S' THEN
         begin
         cDescCuentaCorreo := oc_correos_electronicos_pnj.email_especifico(x.Tipo_Doc_Identificacion, 
                                                                           x.Num_Doc_Identificacion,
                                                                           x.IdCuentaCorreo);
         exception
         when others then
         cDescCuentaCorreo:=null;
         end;
      ELSE
         begin
         cDescCuentaCorreo := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(x.Tipo_Doc_Identificacion,
                                                                          x.Num_Doc_Identificacion );
                                                                                             
         exception
         when others then
         cDescCuentaCorreo:=null;
         end;
           BEGIN      
			       SELECT correlativo_email INTO wCorrelativo
			         FROM CORREOS_ELECTRONICOS_PNJ
			        WHERE Tipo_Doc_Identificacion = x.Tipo_Doc_Identificacion
			          AND Num_Doc_Identificacion  = x.Num_Doc_Identificacion;
			      EXCEPTION  WHEN NO_DATA_FOUND THEN
			      	            wCorrelativo:= NULL;
			      	         WHEN OTHERS THEN
			      	            wCorrelativo:= NULL;      	         
			      END;
			      /*IF wCorrelativo IS NOT NULL THEN      
			            update agentes set idcuentacorreo = wCorrelativo
			            where cod_agente = x.cod_agente;
			            Standard.commit;  
			      END IF;                                                       */
      END IF;
   ELSE
--   	   nDummy := ALERTA('JMMD EN POST QUERY DE BK_AGENTES_DETALLE 4');
         begin
         cDescCuentaCorreo := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(x.Tipo_Doc_Identificacion,
                                                                            x.Num_Doc_Identificacion );
         exception
           when others then
             cDescCuentaCorreo := null;
         end;                                                                                    
           BEGIN      
			       SELECT correlativo_email INTO wCorrelativo
			         FROM CORREOS_ELECTRONICOS_PNJ
			        WHERE Tipo_Doc_Identificacion = x.Tipo_Doc_Identificacion
			          AND Num_Doc_Identificacion  = x.Num_Doc_Identificacion;
			      EXCEPTION  WHEN NO_DATA_FOUND THEN
			      	            wCorrelativo:= NULL;
			      	         WHEN OTHERS THEN
			      	            wCorrelativo:= NULL;      	         
			      END;
			      /*IF wCorrelativo IS NOT NULL THEN      
			            update agentes set idcuentacorreo = wCorrelativo
			            where cod_agente = x.cod_agente;
			            Standard.commit;  
			      END IF;                                         */        
   END IF;
   end loop;
   return (cDescCuentaCorreo);
end;

function get_estatus_pago(ccodcia number,nidpoliza number) return varchar2 is
dfecpago date;
cStPoliza varchar2(40);
CURSOR POL_Q IS
  SELECT DISTINCT P.CodCliente, REPLACE(OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente),',') NomContratante,
         P.NumPolUnico, DP.IdPoliza, DP.IDetPol, DP.FecIniVig, DP.FecFinVig,
         DP.IdTipoSeg, DP.PlanCob, DP.StsDetalle, DP.CodEmpresa, P.IndPolCol,
         OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(DP.CodCia, DP.CodEmpresa, DP.IdTipoSeg) DescTipoSeg,
         OC_PLAN_COBERTURAS.NOMBRE_PLANCOB(DP.CodCia, DP.CodEmpresa, DP.IdTipoSeg, DP.PlanCob) DescPlanCob,
         OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', DP.StsDetalle) DescStatus,
         P.NUMPOLREF, DP.Cod_Asegurado, P.CodCia CodCia,
         OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ADMINPOL',P.TipoAdministracion) TipoAdmon,
         OC_PLAN_DE_PAGOS.DESCRIPCION_PLAN(DP.CodCia, DP.CodEmpresa, DP.CodPlanPago) PlanPago,
         OC_PLAN_DE_PAGOS.FRECUENCIA_PAGOS(DP.CodCia, DP.CodEmpresa, DP.CodPlanPago) FrecPago,
         P.CodGrupoEc CodGrupoEc, DP.CodFilial CodFilial, DP.CodCategoria CodCategoria,
         P.DescPoliza, AP.Cod_Agente CodAgente, OC_AGENTES.NOMBRE_AGENTE(DP.CodCia, AP.Cod_Agente) NomAgente,
         P.FecRenovacion FecRenovacion, P.StsPoliza, P.IndFacturaPol, P.CodAgrupador,
         OC_VALORES_DE_LISTAS.BUSCA_LVALOR('AGRUPA', P.CodAgrupador) DescAgrupador
    FROM POLIZAS P, DETALLE_POLIZA DP , AGENTE_POLIZA AP
   WHERE DP.IdPoliza     = P.IdPoliza
     AND DP.CodEmpresa   = P.CodEmpresa
     AND DP.CodCia       = P.CodCia
     AND P.CodCia        = cCodCia
     AND AP.CODCIA   = P.CODCIA
     AND AP.IDPOLIZA = P.IDPOLIZA                    
     AND AP.IND_PRINCIPAL = 'S'
     AND P.IDPOLIZA = NIDPOLIZA
   ORDER BY DP.IdPoliza DESC, DP.IDetPol ASC;
BEGIN
  FOR X IN POL_Q LOOP
    dfecpago := get_fecha_pago(ccodcia,nidpoliza);
    IF dFecPago  IS NOT NULL THEN
      cStPoliza := 'PAGADA'; 
    ELSIF (dFecPago  IS NULL AND  X.STSPOLIZA = 'ANU') THEN
   	  cStPoliza := 'ANULADA'; 
    ELSIF (dFecPago  IS NULL AND  X.STSPOLIZA IN ('EMI','REN','XRE') ) THEN
   	  cStPoliza := 'PENDIENTE'; 		
    END IF;
  end loop;
  return cStPoliza;
end;
function color_agente(ccodagente varchar2) return varchar2 is
CVALOR VARCHAR2(50);
begin
    for x in (select * from agentes where cod_agente = ccodagente) loop
        if x.EST_AGENTE = 'SUS' then
            CVALOR := 'VA_SUSPEN';
         else
          IF OC_AGENTES_CEDULA_AUTORIZADA.POLIZA_RC_VIGENTE(x.CodCia, x.CodEmpresa, x.Cod_Agente,
      	                                                TRUNC(SYSDATE)) = 'N' AND x.Tipo_Agente != 'DIREC' THEN
             CVALOR := 'VA_SINPOLRC';
          end if;
            if OC_AGENTES_CEDULA_AUTORIZADA.CEDULA_VIGENTE(x.CodCia, x.CodEmpresa, x.Cod_Agente,
      	                                             TRUNC(SYSDATE)) = 'N' AND x.Tipo_Agente != 'DIREC' THEN
                CVALOR := 'VA_SINCEDULA';
            end if;
        if x.EST_AGENTE = 'SOL' then
            CVALOR := 'VA_SOLICITUD';
        end if;
        end if;
        IF CVALOR IS NULL AND X.EST_AGENTE='ACT' THEN
            CVALOR := 'VA_ACTIVO';
        END IF;
    end loop;
    return(CVALOR);
end;

function nombre_cod_pago(nidsiniestro number,nIdDetSin number,nnum_aprob number,cCod_Pago varchar2) return varchar2 is
cExiste varchar2(1);
cdescpago varchar2(1000);
nidetpol siniestro.idetpol%type;
nidpoliza siniestro.idpoliza%type;
cIdTipoSeg detalle_poliza.idtiposeg%type;
cPlanCob  detalle_poliza.plancob%type;
nCodCia detalle_poliza.codcia%type;
nCodEmpresa  detalle_poliza.codempresa%type;
begin
  BEGIN
    SELECT 'S'
      INTO cExiste
      FROM PAGOS_POR_OTROS_CONCEPTOS
     WHERE IdSiniestro = nIdSiniestro
       AND IdDetSin    = nIdDetSin
       AND Concepto    = cCod_Pago;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      cExiste := 'N';
    WHEN TOO_MANY_ROWS THEN
      cExiste := 'S';
  END;
  begin
    select idetpol,idpoliza
    into nidetpol, nidpoliza
    from siniestro
    where idsiniestro = nidsiniestro;

  end;
  BEGIN
    SELECT IdTipoSeg, PLANCOB, CodCia, CodEmpresa 
      INTO cIdTipoSeg, cPlanCob , nCodCia, nCodEmpresa  
      FROM DETALLE_POLIZA
     WHERE IdPoliza = nIdPoliza
       AND IdetPol  = nIdetPol;
  EXCEPTION
  	WHEN OTHERS THEN
  	  cIdTipoSeg  := 'NOEXIS';
  	  cPlanCob    := 'NO EXISTE';
  	  nCodCia     := 1;
  	  nCodEmpresa := 1;
  END;


  IF cExiste = 'N' THEN
       BEGIN
          SELECT DescCobert
            INTO cDescPago
            FROM COBERTURAS_DE_SEGUROS
           WHERE CodCia     = ncodcia
             AND CodEmpresa = ncodempresa
             AND PlanCob    = cPlanCob
             AND IdTipoSeg = cIdTipoSeg
             AND CodCobert  = cCod_Pago;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
       BEGIN
          SELECT DescValLst
            INTO cDescPago
            FROM VALORES_DE_LISTAS
           WHERE CodLista = 'OTROSPAG'
             AND CodValor = cCod_Pago;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
       BEGIN
          SELECT DescValLst
            INTO cDescPago
            FROM VALORES_DE_LISTAS
           WHERE CodLista = 'CONDED'
             AND CodValor = cCod_Pago;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             cDescPago := 'NO EXISTE OP';
       END;
       END;
       END;

  ELSE
       BEGIN
          SELECT DescValLst
            INTO cDescPago
            FROM VALORES_DE_LISTAS
           WHERE CodLista = 'OTROSPAG'
             AND CodValor = cCod_Pago;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             cDescPago := 'NO EXISTE OP';
       END;
  END IF;
return cdescpago;
end;

function nombre_cobertura (nidsiniestro number,ccodcobert varchar2) return varchar2 is
cNomCobert varchar2(1000);
cExiste varchar2(1);
cdescpago varchar2(1000);
nidetpol siniestro.idetpol%type;
nidpoliza siniestro.idpoliza%type;
cIdTipoSeg detalle_poliza.idtiposeg%type;
cPlanCob  detalle_poliza.plancob%type;

begin

  begin
    select idetpol,idpoliza
    into nidetpol, nidpoliza
    from siniestro
    where idsiniestro = nidsiniestro;
  end;
  BEGIN
    SELECT IdTipoSeg, PLANCOB
      INTO cIdTipoSeg, cPlanCob 
      FROM DETALLE_POLIZA
     WHERE IdPoliza = nIdPoliza
       AND IdetPol  = nIdetPol;
  EXCEPTION
  	WHEN OTHERS THEN
  	  cIdTipoSeg  := 'NOEXIS';
  	  cPlanCob    := 'NO EXISTE';
  END;
   BEGIN
      SELECT DescCobert
        INTO cNomCobert
        FROM COBERTURAS_DE_SEGUROS
       WHERE CodCia     = 1
         AND CodEmpresa = 1
         AND PlanCob    = cPlanCob
         AND IdTipoSeg = cIdTipoSeg
         AND CodCobert  = cCodCobert;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNomCobert := 'NO EXISTE';
   END;
   return cnomcobert;
end;
function color_factura(nidfactura number,cstsfact varchar2,cinddomiciliado varchar2,cindpagprod varchar2) return varchar2 is
cAtributo varchar2(50);
begin
	 IF NVL(cINDDOMICILIADO,'N') = 'S' AND NVL(cStsFact,'EMI') NOT IN('PAG','ANU') THEN
	 	 cAtributo := 'VA_PROCOBRO';
	 ELSE
  	 IF NVL(cStsFact,'EMI') = 'XEM' THEN 
       cAtributo := 'VA_SOLICITUD';
     ELSIF NVL(cStsFact,'EMI') = 'PAG' THEN 
   	   IF cIndPagProd = 'S' THEN
         cAtributo := 'VA_PAG_PRODUCTOR';
       ELSE
         cAtributo := 'VA_PAGADA';
       END IF;
     ELSIF NVL(cStsFact,'EMI') = 'ANU' THEN 
       cAtributo := 'VA_ANULADA';
     ELSIF NVL(cStsFact,'EMI') = 'ABO' THEN 
   	   cAtributo := 'VA_ABONADA';
     ELSIF NVL(cStsFact,'EMI') = 'SUS' THEN 
   	   cAtributo := 'VA_SUSPENDIDA';
     END IF;
   END IF; 
   return cAtributo;

end;

procedure actualiza_aprob (nidsiniestro number, nnumaprob number) is
nlocal number;
nmoneda number;
begin
    begin
        select sum(monto_local),sum(monto_moneda)
        into nlocal,nmoneda
        from DETALLE_APROBACION_ASEG
        where idsiniestro = nidsiniestro
          and num_aprobacion = nnumaprob;
    end;
    update APROBACION_ASEG set monto_local = nlocal,monto_moneda = nmoneda
    where idsiniestro = nidsiniestro
          and num_aprobacion = nnumaprob;
end;
procedure actualiza_aprob_ind (nidsiniestro number, nnumaprob number) is
nlocal number;
nmoneda number;
begin
    begin
        select sum(monto_local),sum(monto_moneda)
        into nlocal,nmoneda
        from DETALLE_APROBACION
        where idsiniestro = nidsiniestro
          and num_aprobacion = nnumaprob;
    end;
    update APROBACIONES set monto_local = nlocal,monto_moneda = nmoneda
    where idsiniestro = nidsiniestro
          and num_aprobacion = nnumaprob;
end;

procedure borra_rangos (nidbonoventas number,ctiponvo varchar2 ) is
CTIPOBONO VARCHAR2(50);
begin
    BEGIN
        SELECT TIPOBONOCONV
        INTO CTIPOBONO 
        FROM BONOS_AGENTES_CONFIG
        WHERE IDBONOVENTAS = NIDBONOVENTAS;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           CTIPOBONO := 'XXX';
    END;

    raise_application_error(-20102,'datos '||ctipobono||'- id '||nidbonoventas);
    if CTIPOBONO != 'BONO' THEN
       DELETE BONOS_AGENTES_RANGOS_CONV WHERE IDBONOVENTAS = NIDBONOVENTAS;
    END IF;
    if CTIPOBONO != 'CONVEN' THEN
       DELETE BONOS_AGENTES_RANGOS WHERE IDBONOVENTAS = NIDBONOVENTAS;
    END IF;
end;

FUNCTION SUMA_ASEG_REMANENTE_IND (CCODCIA NUMBER,NIDPOLIZA NUMBER, NIDETPOL NUMBER,CCODCOBERT VARCHAR2) RETURN NUMBER IS
nMontoRvaMoneda NUMBER;
NSUMA_ASEGURADA NUMBER;
SumaAseguradoReal NUMBER;
BEGIN
  BEGIN
    SELECT NVL(SUM(CS.Monto_Reservado_Moneda * Decode(CTS.Signo,'-',-1,1)),0)
      INTO nMontoRvaMoneda
      FROM COBERTURA_SINIESTRO CS,
           CONFIG_TRANSAC_SINIESTROS CTS
     WHERE CS.CodTransac     = CTS.CodTransac
       AND CS.IdPoliza       = NIDPOLIZA
       AND CS.CodCobert      = CCODCOBERT
       AND CS.StsCobertura  != 'ANU';
  END;
								 
NSUMA_ASEGURADA := OC_COBERT_ACT.SUMA_ASEGURADA(CCodCia,NIDPOLIZA, NIDETPOL,CCODCOBERT);
											  
SumaAseguradoReal :=NSUMA_ASEGURADA - nvl(nMontoRvaMoneda,0);

RETURN(SumaAseguradoReal);
END;

procedure emite_rva (P100_IDpoliza number,P100_IdSiniestro number,P100_IdDetSin number,P100_IdPoliza_val number,
                     P100_Monto_Reservado_Moneda number,p100_CodCobert varchar2,p100_NumMod number,P100_nIDETPOL number,
                     ccodcia number,capp_user varchar2,cCodEmpresa number) is
    cIdTipoSeg DETALLE_POLIZA.idtiposeg%type;
	Dummy           			NUMBER;
    nnum number;
    nnumreg number;
	cObservaciones  			VARCHAR2(200);
	cStsSiniestro					SINIESTRO.Sts_Siniestro%TYPE;
	Saldo_Global   				NUMBER(18,2);
	nMontoReservadoMoneda COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;   
	nMontoPagadoMoneda   	COBERTURA_SINIESTRO.Monto_Pagado_Moneda%TYPE;
	nIdAutorizacion 			AUTORIZA_PROCESOS.IdAutorizacion%TYPE;
	cValidaAutorizacion 	VARCHAR2(1);
	cStsAutorizacion			AUTORIZA_PROCESOS.StsAutorizacion%TYPE;
    NMONTO NUMBER;
	nMontoValidaAuto	  	NUMBER(28,2) := 0;
     PROCEDURE PROC_INSREQCOB (nIdPoliza NUMBER, nIdSiniestro NUMBER, cIdTipoSeg VARCHAR2,nIdDetSin NUMBER, cCodCobert VARCHAR2) IS
       CURSOR CUR_REQ IS
          SELECT RS.CodRequisito
            FROM REQUISITO_COBERT_SEGURO /*REQUISITOS_SEGUROS*/ RS, REQUISITOS R
           WHERE RS.IdTipoSeg   = cIdTipoSeg
             AND R.CodRequisito = RS.CodRequisito
             AND R.UsoRequisito   IN ('T','S')
             AND RS.CodCobert = cCodCobert
           MINUS
          SELECT RS.CodRequisito
            FROM REQ_COBERT_SIN RS
           WHERE RS.IdPoliza    = nIdPoliza
             AND RS.IdSiniestro = nIdSiniestro
             AND RS.IdDetSin    = nIdDetSin
             AND RS.CodCobert   = cCodCobert;

    BEGIN
       FOR x IN CUR_REQ LOOP
       	   INSERT INTO REQ_COBERT_SIN ( CodRequisito, CodCia, IdPoliza ,IdDetSin, CodCobert, IdSiniestro , FecSolicitReq, FecEntregaReq, Observaciones, CodUsuario )
                               VALUES ( x.CodRequisito, CCodCia, nIdPoliza, nIdDetSin, cCodCobert, nIdSiniestro,   SYSDATE      , NULL         , NULL         , NULL       );
       END LOOP;
       --
       COMMIT;
    END;

BEGIN

    SELECT IdTipoSeg
      INTO cIdTipoSeg
  	   FROM DETALLE_POLIZA
  	  WHERE IdPoliza = P100_IDpoliza;


begin
    select count(*)
    into nnumreg
    from  COBERTURA_SINIESTRO CS
    where IdSiniestro 				= P100_IdSiniestro
    and stscobertura<>'SOL';
end;
if nvl(nnumreg,0) = 0 then
    nnum := 1;
else
    nnum := 9999;
end if;        
--raise_application_error(-20102,'numero '||nnum);
FOR X IN (SELECT IDSINIESTRO,IDDETSIN,IDPOLIZA,CODCOBERT,COD_ASEGURADO,NUMMOD  
          FROM COBERTURA_SINIESTRO CS
 		  WHERE IdSiniestro 				= P100_IdSiniestro
           and stscobertura='SOL'
           and rownum= 1
           and nnum = 1
           union
           SELECT IDSINIESTRO,IDDETSIN,IDPOLIZA,CODCOBERT,COD_ASEGURADO,NUMMOD  
          FROM COBERTURA_SINIESTRO CS
 		  WHERE IdSiniestro 				= P100_IdSiniestro
           and stscobertura='SOL'
           and nnum = 9999
		    ORDER BY 6 ) LOOP
	BEGIN
		SELECT CS.IdAutorizacion
		  INTO nIdAutorizacion
		  FROM COBERTURA_SINIESTRO CS,AUTORIZA_PROCESOS AP
		 WHERE IdSiniestro 				= x.IdSiniestro
		   AND IdDetSin		 				= P100_IdDetSin
		   AND IdPoliza		 				= P100_IdPoliza_val
		   AND CodCobert   				= x.codcobert 
		   AND NumMod							= X.NUMMOD
		   AND AP.CodProceso			= '500'
		   AND CS.IdAutorizacion 	= AP.IdAutorizacion;	
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			nIdAutorizacion := NULL;
        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20102,'AQUI ESTA');
	END;
	
	SELECT NVL(SUM(Monto_Reservado_Moneda),0)
	  INTO nMontoValidaAuto
	  FROM COBERTURA_SINIESTRO
	 WHERE IdSiniestro     = x.IdSiniestro
	   AND IdPoliza        = P100_IdPoliza_val
	   AND IdDetSin        = P100_IdDetSin
	   AND StsCobertura    = 'EMI';

	IF nIdAutorizacion IS NULL THEN
        NMONTO:=REPLACE(P100_Monto_Reservado_Moneda,',','') + nMontoValidaAuto;
		begin
        nIdAutorizacion := GT_AUTORIZA_PROCESOS.VALIDA_AUTORIZACION(nvl(cCodCia,1), '500', capp_user, x.IdSiniestro, cIdTipoSeg,NMONTO,0);
        exception
        when others then
        raise_application_error(-20105,'El usuario no tiene privilegios ' || capp_USER  || ' (500)'  ||  'Siniestro ' || P100_IdSiniestro||' - Tipo Seguro '||cIdTipoSeg||' - Monto'||NMONTO||'-'||SQLERRM);
        end;
		IF nIdAutorizacion IS NOT NULL THEN
			OC_COBERTURA_SINIESTRO.ACTUALIZA_AUTORIZACION(P100_IdSiniestro, P100_IdDetSin, P100_IDpoliza,p100_CodCobert, p100_NumMod, nIdAutorizacion);

      GT_AUTORIZA_PROCESOS.AGREGA_DETALLE(cCodCia,nIdAutorizacion);
      GT_AUTORIZA_PROCESOS.NOTIFICA(cCodCia,nIdAutorizacion,GT_AUTORIZA_PROCESOS.EMPLEADO_PROCESA(cCodCia,nIdAutorizacion),'NA');
      COMMIT;
      raise_appliCation_error(-20103,'Se ha Generado la Autorización Número '||nIdAutorizacion||'. Por Favor Espere la Confirmación o Rechazo Para Continuar con su Proceso');
		END IF;
	ELSE
		cStsAutorizacion := GT_AUTORIZA_PROCESOS.ESTATUS_AUTORIZACION(cCodCia,nIdAutorizacion);
		IF cStsAutorizacion = 'RECHAZADA' THEN
			raise_application_error(-20103,'La Autorización '||nIdAutorizacion||' Ha Sido Recahzada, Por Favor Contacte a su Supervisor');
		ELSIF cStsAutorizacion IN ('PENDIENTE','REVISADA') THEN
			raise_application_error(-20103,'La Autorización '||nIdAutorizacion||' Sigue en Estatus PENDIENTE de Autorizar o Rechazar, por Favor Contacte a su Supervisor');
		ELSIF cStsAutorizacion = 'REGRESADA' THEN
			IF OC_PROCESO_AUTORIZA_USUARIO.PROCESO_AUTORIZADO(cCodCia , '500', capp_USER, cIdTipoSeg, P100_Monto_Reservado_Moneda + nMontoValidaAuto) = 'N' THEN
				IF OC_PROCESO_AUTORIZACION.APLICA_NIVEL_JERARQUICO(cCodCia, '500') = 'S' THEN
				  GT_AUTORIZA_PROCESOS.ACTUALIZA(cCodCia, nIdAutorizacion, P100_Monto_Reservado_Moneda + nMontoValidaAuto, 0, TRUNC(SYSDATE), TO_CHAR(SYSDATE,'HH24:MI:SS'));
				  GT_AUTORIZA_PROCESOS.NOTIFICA(cCodCia,nIdAutorizacion,GT_AUTORIZA_PROCESOS.EMPLEADO_PROCESA(cCodCia,nIdAutorizacion),'NA');
				  COMMIT;
				  raise_application_error(-20102,'Para Esta Operacion ya Existe la Autorización REGRESADA Número '||nIdAutorizacion||'. Se han Realizado las Notificaciones Correspondientes a su Supervisor Por Favor Espere la Confirmación o Rechazo Para Continuar con su Proceso');
				ELSE
				  raise_application_error(-20102,'Su Perfil de Usuario NO Permite Generar Este Tipo de Oeraciones Y NO Tiene Asignado un Nivel Gerárquico Superior que le Autorice, Valide con su Supervisor: '||SQLERRM);
				END IF;
			END IF;
			NULL;
		END IF;
	END IF;
	
	BEGIN
		SELECT A.Sts_Siniestro  
			INTO cStsSiniestro
		  FROM SINIESTRO A
		 WHERE A.IdPoliza      = P100_IDpoliza
			 AND A.IdSiniestro   = P100_IdSiniestro;	  
	EXCEPTION 
			WHEN NO_DATA_FOUND THEN
	   	cStsSiniestro:= NULL;
	      raise_application_error(-20102,'Error al recuperar en estatus del Siniestro : '||P100_IDpoliza||'-'||'-'||P100_IdSiniestro||'-'||SQLERRM);
		  WHEN OTHERS THEN
	      cStsSiniestro:= NULL;
	      raise_application_error(-20102,'Error al recuperar en estatus del Siniestro : '||P100_IDpoliza||'-'||'-'||P100_IdSiniestro||'-'||SQLERRM);
	END;
	  
	OC_DETALLE_SINIESTRO.ACTUALIZA_RESERVAS(P100_IdSiniestro);
	PROC_INSREQCOB(P100_IDpoliza, P100_IdSiniestro, cIdTipoSeg, P100_IdDetSin, P100_CodCobert);
	IF cStsSiniestro = 'SOL'  THEN 
-----------  HAREMOS LA EMISION DEL SINIESTRO  después de Crear la apertura de Reserva ---------------
		BEGIN
		  OC_SINIESTRO.ACTIVAR(NVL(cCodCia,1), NVL(cCodEmpresa,1), P100_IdSiniestro,P100_IDpoliza,P100_nIDETPOL);
		EXCEPTION
		  WHEN OTHERS THEN 
		  	raise_application_error(-20102,'Error al Activar el Siniestro '||SQLERRM);
		END;	
		--
		cObservaciones := 'Emite / Activa el Siniestro '||P100_IdSiniestro;
		BEGIN
			OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(P100_IdSiniestro,P100_IDpoliza, cObservaciones);
		EXCEPTION
		  WHEN OTHERS THEN 
		  	raise_application_error(-20102,'Error al Insertar Observaciones '||SQLERRM);
		END;
		--
		BEGIN
			UPDATE COBERTURA_SINIESTRO  CSA1
				 SET CSA1.Monto_Reservado_Local  = CSA1.Monto_Reservado_Moneda,
						 CSA1.Saldo_Reserva_Local 	 = CSA1.Saldo_Reserva
			 WHERE CSA1.IdDetSin      	= P100_IdDetSin
				 AND CSA1.CodCobert     	= P100_CodCobert
			 	 AND CSA1.IdSiniestro   	= P100_IdSiniestro
				 AND CSA1.IdPoliza      	= P100_IDpoliza
				 AND CSA1.NumMod        	= X.NumMod;
		EXCEPTION
		   WHEN OTHERS THEN	   
		      RAISE_APPLICATION_ERROR(-20104,'OTHERS Error al actualizar COBERTURA_SINIESTRO_ASEG : '||SQLERRM);
		END;
		COMMIT;
	 ELSIF  cStsSiniestro IN ('EMI', 'PGP','PGT') THEN   	
        begin
			   OC_COBERTURA_SINIESTRO.EMITE_RESERVA(cCodCia  , cCodEmpresa, P100_IdSiniestro,
                                        P100_IDpoliza, P100_IdDetSin  , p100_CodCobert  ,
                                        p100_NumMod  , NULL);
		exception
          when others then	  
            raise_application_error(-20102,P100_IDpoliza||'-'||P100_IdDetSin||'-'||P100_CodCobert||'-'||P100_NumMod||' --> '||sqlerrm);
        end;
              STANDARD.COMMIT;
		BEGIN
			UPDATE COBERTURA_SINIESTRO  CSA1
				 SET CSA1.Monto_Reservado_Local  = CSA1.Monto_Reservado_Moneda,
				 		 CSA1.Saldo_Reserva_Local 	 = CSA1.Saldo_Reserva
		   WHERE CSA1.IdDetSin      = P100_IdDetSin
				 AND CSA1.CodCobert     = x.CodCobert
				 AND CSA1.IdSiniestro   = P100_IdSiniestro
				 AND CSA1.IdPoliza      = P100_IDpoliza
				 AND CSA1.NumMod        = X.NumMod;
		EXCEPTION
			WHEN OTHERS THEN	
			  RAISE_APPLICATION_ERROR(-20104,'OTHERS Error al actualizar COBERTURA_SINIESTRO_ASEG : '||SQLERRM);
	  END;
		COMMIT;
	END IF;

	SELECT SUM(DECODE(CTS.Signo,'-',NVL(Monto_Reservado_Moneda,0)*(-1),NVL(Monto_Reservado_Moneda,0)))
	  INTO nMontoReservadoMoneda
	  FROM COBERTURA_SINIESTRO G,CONFIG_TRANSAC_SINIESTROS CTS
	 WHERE G.IdSiniestro 	= P100_IdSiniestro
	   AND G.IdPoliza    	= P100_IDpoliza
	   AND CTS.CodTransac = G.CodTransac;
                    
	SELECT SUM(G.Monto_Pagado_Moneda)
		INTO nMontoPagadoMoneda
		FROM COBERTURA_SINIESTRO  G
	 WHERE G.IdSiniestro = P100_IdSiniestro
		 AND G.IdPoliza    = P100_IDpoliza;

	BEGIN      
		UPDATE DETALLE_SINIESTRO DS1
		   SET DS1.Monto_Reservado_Local  = nMontoReservadoMoneda,
		   		 DS1.Monto_Reservado_Moneda = nMontoReservadoMoneda,
		   		 DS1.Monto_Pagado_Moneda    = nMontoPagadoMoneda,
		   		 DS1.Monto_Pagado_Local     = nMontoPagadoMoneda                 
		WHERE DS1.IdSiniestro   = x.IdSiniestro
		AND   DS1.IdPoliza      = P100_IDpoliza
		AND   DS1.IdDetSin      = P100_IdDetSin
		AND   DS1.Cod_Asegurado = x.COD_ASEGURADO;
	EXCEPTION
  	WHEN OTHERS THEN 
	    RAISE_APPLICATION_ERROR(-20104,'OTHERS Error al actualizar DETALLE_SINIESTRO_ASEG : '||SQLERRM);
	END;
                      
	BEGIN      
    UPDATE SINIESTRO S1N
      SET S1N.Monto_Reserva_Local  = nMontoReservadoMoneda,
      		S1N.Monto_Reserva_Moneda = nMontoReservadoMoneda,
      		S1N.Monto_Pago_Moneda    = nMontoPagadoMoneda,
      		S1N.Monto_Pago_Local     = nMontoPagadoMoneda
    WHERE S1N.IdSiniestro   = x.IdSiniestro
    	AND S1N.IdPoliza      = P100_IDpoliza;
	EXCEPTION 
		WHEN OTHERS THEN    
			RAISE_APPLICATION_ERROR(-20104,'OTHERS Error al actualizar SINIESTRO : '||SQLERRM);
	END;  
  COMMIT;
END LOOP;
end emite_rva;
procedure activar_aprobacion (ccodcia number,P100_IDSINIESTRO number,P100_NUMAPROB number,P100_NUMMOD number,P100_TXTISR in out varchar2,capp_user varchar2) is
    NPASO NUMBER;
    cbandisr VARCHAR2(1);
	Dummy								NUMBER;
	nIdAutorizacion 		AUTORIZA_PROCESOS.IdAutorizacion%TYPE;
	nIdAutorizacionVal	AUTORIZA_PROCESOS.IdAutorizacion%TYPE;
	cValidaAutorizacion VARCHAR2(1);
	cStsAutorizacion		AUTORIZA_PROCESOS.StsAutorizacion%TYPE;
	nMontoValidaAuto	  NUMBER(28,2) := 0;
	nMontoTotal	  			NUMBER(28,2) := 0;
	nCuenta							NUMBER := 0;
	nIdSiniestro			SINIESTRO.IDSINIESTRO%TYPE;
	cCodEmpresa				SINIESTRO.CODCIA%TYPE;
	nNumMod					COBERTURA_SINIESTRO.nummod%type := P100_NUMMOD;
	nIDDETSIN				APROBACIONES.IDDETSIN%TYPE;
    cCtaLiquidadora         varchar2(1000);
	nIDPOLIZA				APROBACIONES.IDPOLIZA%TYPE;
	cCODCOBERT				APROBACIONES.CODCOBERT%TYPE;
	cCOD_ASEGURADO			APROBACIONES.COD_ASEGURADO%TYPE;
	nIDTIPOSEG				DETALLE_SINIESTRO.IDTIPOSEG%TYPE;
	nMonto_Reservado_Moneda DETALLE_SINIESTRO.Monto_Reservado_Moneda%type;
    nNumAprob               DETALLE_APROBACION.NUM_APROBACION%type;
    nIDETPOL                SINIESTRO.IDETPOL%TYPE;
	cCod_Pago				DETALLE_APROBACION.cod_pago%type;
	ntotconceptos			number:=0;
	cStsAprobacion			aprobaciones.StsAprobacion%type;
	nbenef					aprobaciones.benef%type;
	NSAT_QEQ				number := 0;
	cCodmoneda				siniestro.cod_moneda%type;
	cNomBenef				varchar2(1000);
    cIndAplicaISR			varchar2(1000);
    nPorcentISR				number;
   	nPorcePart				number;
   	CRFC					varchar2(1000);
   	CNUM_DOC_IDENTIFICACION	              	 varchar2(1000);         
       cTipo_de_Aprobacion   aprobaciones.Tipo_de_Aprobacion%type;
       nmonto_moneda    number;  
       nmonto_local number;

	CURSOR APROB_Q IS
		SELECT IdSiniestro,IdDetSin,IdPoliza,Cod_Asegurado,Num_Aprobacion
		, STSAPROBACION, BENEF    ------ JMMD20190823 SE INCLUYE STSAPROBACION EN LA SELECCION DEL CURSOR
			FROM APROBACIONES A
		 WHERE A.IdSiniestro 							= nIdSiniestro
		   AND A.IdDetSin		 							= nIdDetSin
		   AND A.IdPoliza		 							= nIdPoliza
		   AND A.Cod_Asegurado  					= cCod_Asegurado
		   AND NVL(A.StsAprobacion,'SOL')	= 'SOL'
		   AND A.IdAutorizacion 				 IS NULL;
/******************************************************************************************************************************/
/******************************************************************************************************************************/
/******************************************************************************************************************************/
/******************************************************************************************************************************/
/******************************************************************************************************************************/
PROCEDURE MANDA_CORREO(NUM_IDENTIFICACION VARCHAR2,TABLA VARCHAR2,ORIGEN VARCHAR2) IS
nDummy			NUMBER;
cEmail                      USUARIOS.EMAIL%TYPE;
cPwdEmail                   VARCHAR2(100);
cMiMail                     USUARIOS.EMAIL%TYPE := 'notificaciones@thonaseguros.mx';
cEmailPrincipal             CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
cEmailSecundario            CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
cEmailJefe                  CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
cSubject                    VARCHAR2(500) := 'Notificación Proveedor encontrado en archivos de SAT : ';
cTextoEndosoEnv             ENDOSO_TXT_DET.TEXTO%TYPE;
cTexto1                     varchar2(100)  := 'Le notificamos que el proveedor con RFC-  ';
cTexto2                     varchar2(150)  := ' , se ubica en los supuestos de los artículos 69 y 69-B del CFF, y ha sido localizado en el listado del SAT en la categoria de ';
cTexto3D										VARCHAR2(150)  := '. Su registro no podrá ser concluido hasta que haya sido autorizado y desbloqueado.';
cTexto3P										VARCHAR2(150)  := '. Su registro pudiera ser rechazado, favor de obtener la autorización correspondiente para concluir con su alta.';
CURSOR CORREOS IS
SELECT CAGE_NOM_REG
FROM SAI_CAT_GENERAL
WHERE CAGE_CD_CATALOGO = 13
AND CAGE_NOM_CONCEP = 'SINIESTROS'
AND CAGE_CD_ESTATUS = 'ACT';
BEGIN
   cEmail     := OC_GENERALES.BUSCA_PARAMETRO(1,'021');
   cPwdEmail := OC_GENERALES.BUSCA_PARAMETRO(1,'022');
   
   IF TABLA = 'D' THEN
   		cTextoEndosoEnv :=  cTexto1||NUM_IDENTIFICACION||cTexto2||' DEFINITIVOS '||cTexto3D;
   ELSE
   		cTextoEndosoEnv :=  cTexto1||NUM_IDENTIFICACION||cTexto2||' PRESUNTOS '||cTexto3P;
   END IF;
	FOR X IN CORREOS LOOP  
		cEmailPrincipal := X.CAGE_NOM_REG;
   BEGIN
     OC_SENDMAIL.SEND_MAIL_AGENTES(cEmail,cPwdEmail,cMiMail,cEmailPrincipal,NULL,NULL,cSubject,cTextoEndosoEnv);
   EXCEPTION WHEN OTHERS THEN
      dbms_output.put_line('Error en el envío de notificacion '||cEmailPrincipal);
   END;
   END LOOP;
END;


PROCEDURE EXISTE_EN_SAT( NUM_IDENTIFICACION VARCHAR2) IS

nDummy			NUMBER;
cExisteEnDefinitivos		VARCHAR2(1) := 'N';
cExisteEnPresuntos			VARCHAR2(1) := 'N';
cStatusDefinitivos			PROVEEDORES_SAT.ESTATUS_REGISTRO%TYPE := NULL;
cStatusPresuntos				PROVEEDORES_SAT.ESTATUS_REGISTRO%TYPE := NULL;
cNomContrib 						PROVEEDORES_SAT_DEFINITIVOS.NOM_CONTRIB%TYPE;
cSitContrib 						PROVEEDORES_SAT_DEFINITIVOS.SIT_CONTRIB%TYPE;
cUsuario								VARCHAR2(100);

BEGIN
	null;
	cUsuario	          := capp_user;
	
	BEGIN
		SELECT 'S', ESTATUS_REGISTRO, NOM_CONTRIB, SIT_CONTRIB
		  INTO cExisteEnDefinitivos, cStatusDefinitivos, cNomContrib, cSitContrib
		  FROM PROVEEDORES_SAT_DEFINITIVOS D
		 WHERE D.ID_RFC = NUM_IDENTIFICACION;
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN
	   cExisteEnDefinitivos := 'N';
	   cStatusDefinitivos := NULL;
		WHEN OTHERS THEN
	   cExisteEnDefinitivos := 'S';
--	   cStatusDefinitivos := NULL;	   
	END ;
	IF cExisteEnDefinitivos = 'S' THEN
		 IF cStatusDefinitivos = 'APRO' THEN
		 		cExisteEnDefinitivos := 'S';
		 ELSE
				NSAT_QEQ := 1;		 	 
		 	 TH_BIT_DESBLOQUEOS_SAT.INSERTA(cCodCia	,
			 NUM_IDENTIFICACION ,
			 cNomContrib ,
			 cSitContrib ,
			 cStatusDefinitivos ,
			 cUsuario ,
			 SYSDATE ,
			 'BENESINI - SINIESTROS - EL BENEFICIARIO QUE INTENTA DAR DE ALTA, SE UBICA EN LOS SUPUESTOS DE LOS ARTÍCULOS 69 Y 69-B DEL CFF, EN EL LISTADO DEL SAT EN LA CATEGORÍA DE "DEFINITIVOS" Y SU REGISTRO NO PODRÁ SER CONCLUIDO!!!');		 	
		  TH_POR_AUTORIZAR_SAT.INSERTA(cCodCia ,
      NUM_IDENTIFICACION ,
      cNomContrib ,
      cSitContrib ,
      cStatusDefinitivos ,
      cUsuario ,
      SYSDATE ,
			'BENESINI - SINIESTROS - EL BENEFICIARIO QUE INTENTA DAR DE ALTA, SE UBICA EN LOS SUPUESTOS DE LOS ARTÍCULOS 69 Y 69-B DEL CFF, EN EL LISTADO DEL SAT EN LA CATEGORÍA DE "DEFINITIVOS" Y SU REGISTRO NO PODRÁ SER CONCLUIDO!!!');		 	
		  				 
		   COMMIT;				   
		 	 MANDA_CORREO(NUM_IDENTIFICACION, 'D','SINIESTROS');
		   raise_application_error(-20102,'ALERTA, EL PROVEEDOR AL QUE INTENTA DAR DE ALTA, HA SIDO LOCALIZADO EN EL LISTADO DEL SAT EN LA CATEGORÍA DE "DEFINITIVOS" Y SU REGISTRO NO PODRÁ SE CONCLUIDO, FAVOR DE NOTIFICAR A SU SUPERIOR. ');
		 END IF;
	END IF;
	BEGIN
		SELECT 'S', ESTATUS_REGISTRO, NOM_CONTRIB, SIT_CONTRIB
		  INTO cExisteEnPresuntos, cStatusPresuntos, cNomContrib, cSitContrib
		  FROM PROVEEDORES_SAT_PRESUNTOS P
		 WHERE P.ID_RFC = NUM_IDENTIFICACION;
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN
	   cExisteEnPresuntos := 'N';
	   cStatusPresuntos := NULL;
		WHEN OTHERS THEN
	   cExisteEnPresuntos := 'S';
	END ;	     
	IF cExisteEnPresuntos = 'S' THEN
		 IF cStatusPresuntos = 'APRO' THEN
		    cExisteEnPresuntos := 'S';
		 ELSE
		 	 TH_BIT_DESBLOQUEOS_SAT.INSERTA(cCodCia	,
			 NUM_IDENTIFICACION ,
			 cNomContrib ,
			 cSitContrib ,
			 cStatusPresuntos ,
			 cUsuario ,
			 SYSDATE ,
			 'BENESINI - SINIESTROS - EL BENEFICIARIO QUE INTENTA DAR DE ALTA, SE UBICA EN LOS SUPUESTOS DE LOS ARTÍCULOS 69 Y 69-B DEL CFF, EN EL LISTADO DEL SAT EN LA CATEGORÍA DE "PRESUNTOS" !!!');		 	
		  TH_POR_AUTORIZAR_SAT.INSERTA(cCodCia ,
      NUM_IDENTIFICACION ,
      cNomContrib ,
      cSitContrib ,
      cStatusPresuntos ,
      cUsuario ,
      SYSDATE ,
			'BENESINI - SINIESTROS - EL BENEFICIARIO QUE INTENTA DAR DE ALTA, SE UBICA EN LOS SUPUESTOS DE LOS ARTÍCULOS 69 Y 69-B DEL CFF, EN EL LISTADO DEL SAT EN LA CATEGORÍA DE "PRESUNTOS" !!!');		 	
		  				 
		   COMMIT;		
		 	 MANDA_CORREO(NUM_IDENTIFICACION,'P','SINIESTROS');
		   raise_application_error(-20102,'ALERTA, EL PROVEEDOR AL QUE INTENTA DAR DE ALTA, HA SIDO LOCALIZADO EN EL LISTADO DEL SAT EN LA CATEGORÍA DE "PRESUNTOS" Y SU REGISTRO NO PODRÁ SE CONCLUIDO, FAVOR DE NOTIFICAR A SU SUPERIOR. ');
		 END IF;	
	END IF;  
END;

PROCEDURE PROC_GENERA_ISR(nCodCia NUMBER, nIdSiniestro NUMBER, nNumAprob NUMBER,
                          nPctISR NUMBER, cCod_Moneda VARCHAR) IS
  
  nMonto           DETALLE_APROBACION.Monto_Moneda%TYPE := 0;
  nISR             DETALLE_APROBACION.Monto_Moneda%TYPE := 0;
  nISRLocal        DETALLE_APROBACION.Monto_Moneda%TYPE := 0;
  nIdDetAprob      DETALLE_APROBACION.IdDetAprob%TYPE := 0;
  cCodTransac      DETALLE_APROBACION.CodTransac%TYPE := 'ISRSIN';
  cCodCptoTransac  DETALLE_APROBACION.CodCptoTransac%TYPE := NULL;
  cCod_Pago        DETALLE_APROBACION.Cod_Pago%TYPE := 'IMPTO';
  nSigno           NUMBER := 1;
  
  CURSOR CON_Q IS
    SELECT DA.Monto_Moneda, CT.Signo, CP.IndTipoCobert
      FROM DETALLE_APROBACION DA,
           CONFIG_TRANSAC_SINIESTROS CT,
           CPTOS_TRANSAC_SINIESTROS CP
     WHERE DA.Num_Aprobacion = nNumAprob
       AND DA.IdSiniestro    = nIdSiniestro
       AND CT.CodCia         = nCodCia
       AND CT.CodTransac     = DA.CodTransac
       AND DA.CodTransac     = CP.CodTransac
       AND DA.CodCptoTransac = CP.CodCptoTransac;
BEGIN
  FOR X IN CON_Q LOOP
  	IF NVL(X.Signo,'-') = '+' THEN
  		 nMonto := nMonto + X.Monto_Moneda;
  	ELSE
  		 nMonto := nMonto - X.Monto_Moneda;
  	END IF;
  END LOOP;
  
  IF NVL(nMonto,0) > 0 THEN
  	 nISR := ((NVL(nMonto,0) * nPctISR) / 100);
     nISRLocal := nISR * OC_GENERALES.TASA_DE_CAMBIO(cCod_Moneda, TRUNC(SYSDATE));
  END IF;
  
  BEGIN
    SELECT NVL(MAX(IdDetAprob),0)+1
      INTO nIdDetAprob
      FROM DETALLE_APROBACION
     WHERE Num_Aprobacion = nNumAprob
       AND IdSiniestro    = nIdSiniestro;
  END;

  BEGIN
    SELECT CP.CodTransac, CP.CodCptoTransac, TO_NUMBER(CO.Signo||1) Signo
      INTO cCodTransac, cCodCptoTransac, nSigno
      FROM CPTOS_TRANSAC_SINIESTROS CP,
           CONFIG_TRANSAC_SINIESTROS CO
     WHERE CO.CodTransac = cCodTransac
       AND CO.CodCia     = nCodCia
       AND CO.CodCia     = CP.CodCia
       AND CO.CodTransac = CP.CodTransac
       AND Cp.IndTipoCobert = 'IM';
  END;
  
  nISR      := NVL(nISR,0) * nSigno;
  nISRLocal := NVL(nISRLocal,0) * nSigno;
  
  BEGIN
  	INSERT INTO DETALLE_APROBACION
  	      (Num_Aprobacion, IdDetAprob, Cod_Pago, Monto_Local, Monto_Moneda, IdSiniestro,
  	       CodTransac, CodCptoTransac)
  	VALUES(nNumAprob, nIdDetAprob, cCod_Pago, nISRLocal, nISR, nIdSiniestro,
  	       cCodTransac, cCodCptoTransac);
  END;

  nMonto_Moneda := NVL(nMonto,0) + nISR;
  nMonto_Local  := (NVL(nMonto,0) + nISR) * OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));

  COMMIT;
END;

PROCEDURE PROC_ACTIVA_PAGO (cCodMoneda VARCHAR2,cCtaLiquidadora VARCHAR2)IS
	Dummy        				NUMBER;
	cExiste         		VARCHAR2(1):= 'N';
	cExisteD        		VARCHAR2(1):= 'N';
	nReserva        		COBERTURA_SINIESTRO.Saldo_Reserva%TYPE := 0;
	nMontoP         		DETALLE_APROBACION.Monto_Moneda%TYPE   := 0;
	nAjuste         		NUMBER(18,2) :=0 ;
	
	nMtoAproT       		APROBACIONES.Monto_Local%TYPE;
	nMtoResT        		DETALLE_SINIESTRO.Monto_Reservado_Local%TYPE;
	QueHago         		COBERTURA_SINIESTRO.Saldo_Reserva%TYPE;
	wNoMeChamaqueen 		detalle_aprobacion.MONTO_LOCAL%TYPE;
BEGIN
cbandisr := 'N';
P100_TXTISR := NULL;
	nMonto_Moneda := nTOTCONCEPTOS;---:BK_DET_APROB.Monto_Moneda;
	nMonto_Local  := nMonto_Moneda * OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
   IF nBenef IS NULL THEN
      RAISE_APPLICATION_ERROR(-20102,'Debe Asignar un Beneficiario para la Aprobación');
   ELSE
   	  IF cIndAplicaISR = 'S' THEN
   	     BEGIN
   	  	   SELECT 'S'
   	  	     INTO cExiste
   	  	     FROM CPTOS_TRANSAC_SINIESTROS CT,
                  DETALLE_APROBACION DA
   	  	    WHERE DA.Num_Aprobacion = nNumAprob
              AND DA.IdSiniestro    = nIdSiniestro
              AND DA.CodTransac     = CT.CodTransac
              AND DA.CodCptoTransac = CT.CodCptoTransac
              AND CT.IndTipoCobert  = 'IM';
   	     EXCEPTION
   	     	 WHEN NO_DATA_FOUND THEN
   	     	   cExiste := 'N';
   	     	 WHEN TOO_MANY_ROWS THEN
   	     	   cExiste := 'S';
   	     END;
   	     IF NVL(cExiste,'N') = 'N' THEN
               PROC_GENERA_ISR(cCodCia, nIdSiniestro, nNumAprob,
                               NPORCENTISR, cCodMoneda );
               
					               select sum(MONTO_LOCAL) into wNoMeChamaqueen
													 from detalle_aprobacion
													where idsiniestro = nIdSiniestro
													  and num_aprobacion = nNumAprob;
		                UPDATE APROBACIONES
							         SET MONTO_LOCAL  = wNoMeChamaqueen,
							             MONTO_MONEDA = wNoMeChamaqueen
							       WHERE IdPoliza       = nIdPoliza
							         AND IdSiniestro    = nIdSiniestro
							         AND IdDetSin       = nIdDetSin
							         AND Cod_Asegurado  = cCod_Asegurado
							         AND Num_Aprobacion = nNumAprob;
               cbandisr := 'S';
               P100_TXTISR := 'Finalizó la creación del ISR, Si requiere Activar favor ejecutar nuevamente el Botón de Activar Aprobación.';
--               raise_application_error(-20102,'Finalizó la creación del ISR, Si requiere Activar favor ejecutar nuevamente el Botón de Activar Aprobación.');
   	     END IF;
      END IF;
   END IF;
   if cbandisr = 'N' THEN
   
   IF cCtaLiquidadora IS NULL THEN
      raise_application_error(-20103,'Debe Asignar la Cuenta Liquidadora de la Aprobación');
   END IF;
   BEGIN
	    SELECT 'S'
	      INTO cExiste
        FROM BENEF_SIN
       WHERE IdSiniestro = nIdSiniestro 
         AND IdPoliza    = nIdPoliza;
   EXCEPTION
         WHEN NO_DATA_FOUND THEN
      	    cExiste := 'N';
      	 WHEN TOO_MANY_ROWS THEN 
      	    cExiste := 'S';
   END;
   IF cExiste = 'N' THEN 
      RAISE_APPLICATION_ERROR(-20102,'1 No puede Activar Aprobación de Pago sin Beneficiario de Siniestro, Favor Verificar');
   END IF;
   IF cTipo_de_Aprobacion = 'T' THEN
     BEGIN 
   	     SELECT NVL(SUM(C.Saldo_Reserva),0) nMonto
   		     INTO nMtoResT   ---nReserva  nMtoAproT
           FROM COBERTURA_SINIESTRO C
          WHERE C.IdSiniestro  =  nIdSiniestro
            AND C.IdPoliza     =  nIdPoliza
            AND C.StsCobertura = 'EMI'
            AND Cod_Asegurado  = cCod_Asegurado
            AND C.CodCobert    = cCod_Pago
            AND C.NumMod IN  (SELECT MAX(NumMod) 
                                FROM COBERTURA_SINIESTRO CC
                               WHERE CC.IdSiniestro =  nIdSiniestro
                                 AND CC.IdPoliza    =  nIdPoliza
                                 AND C.StsCobertura = 'EMI'
                                 AND Cod_Asegurado  = cCod_Asegurado
                                 AND C.CodCobert    = cCod_Pago
                                 AND CC.CodCobert   = C.CodCobert);
       END;
		      BEGIN 
		   	     SELECT NVL(SUM(E.Monto_Local),0)
		   	       INTO nMtoAproT  
		           FROM APROBACIONES E
		          WHERE E.IdSiniestro      = nIdSiniestro 
		            AND E.IdPoliza         = nIdPoliza
		            AND E.Cod_Asegurado    = cCod_Asegurado
		            AND E.MONTO_LOCAL      = nMONTO_MONEDA
		            AND E.NUM_APROBACION   = nNUMAPROB
		            AND E.StsAprobacion   != 'ANU';
		      EXCEPTION 
		         WHEN NO_DATA_FOUND THEN
		      	    nMtoAproT := 0;
		      END;
      
   END IF;    
      BEGIN 
   	     SELECT NVL(SUM(E.Monto_Local),0)
   	       INTO nMtoAproT  
           FROM APROBACIONES E
          WHERE E.IdSiniestro      = nIdSiniestro 
            AND E.IdPoliza         = nIdPoliza
            AND E.Cod_Asegurado    = cCod_Asegurado
            AND E.MONTO_LOCAL    = nMONTO_MONEDA
            AND E.NUM_APROBACION = nNUMAPROB
            AND E.StsAprobacion   != 'ANU';
      EXCEPTION 
         WHEN NO_DATA_FOUND THEN
      	    nMtoAproT := 0;
      END;
        
     
     
      BEGIN 
   	     SELECT NVL(SUM(F.Monto_Reservado_Local),0)
   	       INTO nMtoResT
           FROM DETALLE_SINIESTRO  F
          WHERE F.IdSiniestro    = nIdSiniestro 
            AND F.IdPoliza       = nIdPoliza
            AND F.Cod_Asegurado  = cCod_Asegurado;
      END;
   
      BEGIN
   	     SELECT 'S'
           INTO cExisteD
           FROM DETALLE_APROBACION
          WHERE Num_Aprobacion = nNumAprob
            AND IdSiniestro    = nIdSiniestro ;
      EXCEPTION 
         WHEN NO_DATA_FOUND THEN 
   	        raise_application_error(-20102,'Debe agregar el Detalle de la Aprobación, Favor Verificar');
         WHEN TOO_MANY_ROWS THEN 
            cExisteD := 'S';
      END;

   	  IF nMtoAproT > nMtoResT AND cTipo_de_Aprobacion = 'P' THEN 
   	  	 raise_application_error(-20102,'2 No puede Activar Aprobacion el monto es Mayor a la Reserva del Siniestro, Favor Verificar');
      END IF;   

      UPDATE APROBACIONES
         SET StsAprobacion  = 'EMI'
       WHERE IdPoliza       = nIdPoliza
         AND IdSiniestro    = nIdSiniestro
         AND IdDetSin       = nIdDetSin
         AND Cod_Asegurado  = cCod_Asegurado
         AND Num_Aprobacion = nNumAprob;

      COMMIT;
   END IF;
END;

PROCEDURE VALIDA_EN_QEQ (NIDSINIESTROPAR NUMBER,NIDPOLIZAPAR NUMBER,NBENEFPAR number) IS

  Dummy    Number;
  cNombreCompleto			VARCHAR2(300);
  cST_RESOLUCIO				ADMON_RIESGO_SINIESTROS.ST_RESOLUCION%TYPE ; 
  cTP_RESOLUCION			ADMON_RIESGO.TP_RESOLUCION%TYPE ; 
  cListas						  ADMON_RIESGO.Observaciones%TYPE;	
  nIdSiniestro				SINIESTRO.IDSINIESTRO%TYPE;
  nIdPoliza						SINIESTRO.IDPOLIZA%TYPE;
  nCod_Asegurado			SINIESTRO.COD_ASEGURADO%TYPE;
  nCodcia							SINIESTRO.CODCIA%TYPE;
  nCodEmpresa					SINIESTRO.CODEMPRESA%TYPE;	
  nBenef							BENEF_SIN.BENEF%TYPE;
  cTipo_id_tributario BENEF_SIN.TIPO_ID_TRIBUTARIO%TYPE;
  cNum_DOC_tributario BENEF_SIN.NUM_DOC_TRIBUTARIO%TYPE;  
  cUsuario	          VARCHAR2(50);
  cObservaciones		  ADMON_RIESGO.Observaciones%TYPE := '';	  
  ncuantos						NUMBER;
  nDiasautpld					NUMBER;
  
    
BEGIN
	
	cUsuario	          := cAPP_USER;

	BEGIN
		SELECT DESCVALLST
		  INTO nDiasautpld
		  FROM VALORES_DE_LISTAS
		 WHERE CODLISTA = 'DIASAUTPLD'
		   AND CODVALOR = 'ODC';
	EXCEPTION
		  WHEN OTHERS THEN 
		    nDiasautpld := 1;
	END;

		SELECT IDSINIESTRO, IDPOLIZA, COD_ASEGURADO,BENEF,NOMBRE||' ' ||APELLIDO_PATERNO||' '||APELLIDO_MATERNO, TIPO_ID_TRIBUTARIO, NUM_DOC_TRIBUTARIO
	    INTO nIdSiniestro	, nIdPoliza , nCod_Asegurado , nBenef	, cNombreCompleto, cTipo_id_tributario , cNum_DOC_tributario 	
			FROM BENEF_SIN
		 WHERE IDSINIESTRO = NIDSINIESTROPAR
			 AND IDPOLIZA = NIDPOLIZAPAR
             AND BENEF = NBENEFPAR;

		SELECT CODCIA, CODEMPRESA
	    INTO nCodcia, nCodEmpresa
			FROM SINIESTRO
		 WHERE IDSINIESTRO = NIDSINIESTRO
			 AND IDPOLIZA = NIDPOLIZA		 	  ;
--	  Dummy := alerta('Se validara existencia en PLD '|| cNombreCompleto);	
	  
	   BEGIN
	    SELECT ST_RESOLUCION, TP_RESOLUCION
	      INTO cST_RESOLUCIO, cTP_RESOLUCION
	      FROM ADMON_RIESGO_SINIESTROS
	     WHERE (TIPO_DOC_IDENTIFICACION = cTipo_id_tributario OR TIPO_DOC_IDENTIFICACION IS NULL)
	       AND (NUM_DOC_IDENTIFICACION = cNum_DOC_tributario OR NUM_DOC_IDENTIFICACION IS NULL) ----'MAVO640521PC3'
	       AND NOMBRE_BENEFICIARIO = cNombreCompleto ----'OSCAR MANUEL MADERO VALENCIA';
				 AND TRUNC(FE_ESTATUS) >= TRUNC(SYSDATE - nDiasautpld)
				 AND NUMSINIESTRO = NIDSINIESTRO
			 	 AND IDPOLIZA = NIDPOLIZA	;	       
---------------------------
	       
	   EXCEPTION WHEN NO_DATA_FOUND THEN	  	
			BEGIN
	  		OC_ADMON_RIESGO_SINIESTROS.VALIDA(NCODCIA ,
           nCodEmpresa  ,
           1 ,
           nIdPoliza ,
           nCod_Asegurado , 
           nIdSiniestro ,
           nBenef , --P_NUM_BENEF               NUMBER,
           cNombreCompleto ,
           'PEND' ,
           cTipo_id_tributario	,
           cNum_DOC_tributario	,
           '' ,
           cUsuario ,                               
           cObservaciones) 	 ; 

	  	EXCEPTION WHEN OTHERS THEN
-- 	  			 Dummy := alerta('JMMD MARCO ERROR '||SQLERRM); 
           cST_RESOLUCIO := null ;           	  			  	   
	  	END;           

---------------
	   WHEN OTHERS THEN	  
    	    cST_RESOLUCIO := NULL;
--					Dummy := alerta('REGRESO DE ADMON_RIESGO, CON cObservaciones ');   	   	          
	   END;  
---------------	  
     SELECT COUNT(*)
       INTO ncuantos
       FROM ADMON_RIESGO_SINIESTROS
      WHERE (TIPO_DOC_IDENTIFICACION = cTipo_id_tributario OR TIPO_DOC_IDENTIFICACION IS NULL) 
		    AND (NUM_DOC_IDENTIFICACION = cNum_DOC_tributario OR NUM_DOC_IDENTIFICACION IS NULL)
		    AND NOMBRE_BENEFICIARIO = cNombreCompleto
		    AND ST_RESOLUCION != 'APRO'
		    AND NUMSINIESTRO 	 = NIDSINIESTRO
			 	AND IDPOLIZA 			 = NIDPOLIZA	;	
--			Dummy := alerta('Antes del if ncuantos ');   	   	               
			IF ncuantos > 0 THEN
				 cST_RESOLUCIO := 'PEND';
			ELSE
				 cST_RESOLUCIO := 'APRO';
			END IF;
-- 						Dummy := alerta('REGRESO DE ADMON_RIESGO, CON cObservaciones ');   	
		 IF cST_RESOLUCIO = 'PEND' THEN
		   	  NSAT_QEQ := 1;
	       	RAISE_APPLICATION_ERROR(-20104,'EL REGISTRO SE ENCUENTRA EN PLD SINIESTROS, CON STATUS DE '|| cST_RESOLUCIO||'.  REQUIERE AUTORIZACIÓN DEL OFICIAL DE CUMPLIMIENTO');   	 
--	 				RAISE FORM_TRIGGER_FAILURE;	 	  	       	  	
		 END IF; 

END;


PROCEDURE VALIDA_BENEFICIARIO_SAT(pSiniestro number, pPoliza number, pBenef number) IS
nDummy			NUMBER;
cTIPO_ID_TRIBUTARIO				BENEF_SIN.TIPO_ID_TRIBUTARIO%TYPE;
cNUM_DOC_TRIBUTARIO				BENEF_SIN.NUM_DOC_TRIBUTARIO%TYPE;
	
BEGIN
	begin
--  nDummy := ALERTA(' pBenef  '|| pBenef );	
 SELECT TIPO_ID_TRIBUTARIO	, NUM_DOC_TRIBUTARIO
   INTO cTIPO_ID_TRIBUTARIO, cNUM_DOC_TRIBUTARIO
   FROM BENEF_SIN
  WHERE IDSINIESTRO 		= pSiniestro
    AND IDPOLIZA				= pPoliza
    AND BENEF						= pBenef;
	exception 
		 when no_data_found then
		  raise_application_error(-20103,' No se encontro el beneficiario  '||pBenef);	 
	end; 
  EXISTE_EN_SAT(cNUM_DOC_TRIBUTARIO);   
END;

PROCEDURE proc_valida_monto_pago IS
	Dummy              NUMBER(5);
	nMtoOtrPagMoneda   PAGOS_POR_OTROS_CONCEPTOS.Monto_Reservado_Moneda%TYPE;
	nMtoCobertMoneda   COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;
	nMtoPagos					 APROBACIONES.Monto_Local%TYPE;	 
BEGIN
   BEGIN
      SELECT NVL(SUM(Monto_Reservado_Moneda),0)
        INTO nMtoOtrPagMoneda
        FROM PAGOS_POR_OTROS_CONCEPTOS
       WHERE IdSiniestro = nIdSiniestro
         AND IdDetSin    = nIdDetSin
         AND Concepto    = cCod_Pago;

      SELECT NVL(SUM(Saldo_Reserva),0)
        INTO nMtoCobertMoneda
        FROM COBERTURA_SINIESTRO
       WHERE IdSiniestro   = nIdSiniestro
         AND IdDetSin      = nIdDetSin
         AND Cod_Asegurado = cCod_Asegurado;
   END;
	 
		SELECT SUM(NVL(DA.Monto_Local,0))
			INTO nMtoPagos
			FROM APROBACIONES A,DETALLE_APROBACION DA
	 	 WHERE A.IdSiniestro     = nIdSiniestro
			 AND A.IdDetSin        = nIdDetSin
			 AND A.Cod_Asegurado   = cCod_Asegurado
			 AND A.StsAprobacion  IN ('SOL','EMI')
			 AND A.IdSiniestro     = DA.IdSiniestro
			 AND A.Num_Aprobacion  = DA.Num_Aprobacion
			 AND NVL(GT_AUTORIZA_PROCESOS.ESTATUS_AUTORIZACION(cCodCia, A.IdAutorizacion),'NA') != 'RECHAZADA'
			 AND EXISTS (SELECT 'S'
			               FROM COBERTURA_SINIESTRO
			              WHERE IdSiniestro   = nIdSiniestro
											AND IdDetSin      = nIdDetSin
											AND Cod_Asegurado = cCod_Asegurado
											AND CodCobert     = cCod_Pago);
	 
   IF NVL(nMtoCobertMoneda,0) != 0 THEN
      IF NVL(nMtoPagos,0) > NVL(nMtoCobertMoneda,0) THEN
         raise_application_error(-20103,'Monto de Cobertura a Pagar NO puede superar El Saldo de Reserva');
   	  END IF;
   ELSE
   	  --IF NVL(:BK_DET_APROB.TotConceptos,0) > NVL(nMtoOtrPagMoneda,0) THEN
   	  IF NVL(nMtoPagos,0) > NVL(nMtoOtrPagMoneda,0) THEN	
         raise_application_error(-20103,'Monto de Otros Conceptos a Pagar NO puede superar a lo Reservado:'||nTotConceptos||' '||NVL(nMtoOtrPagMoneda,0));
   	  END IF;
   END IF;
END;

BEGIN
/*inicio*/
    NPASO:=1;
    BEGIN
	SELECT IDSINIESTRO,NUM_APROBACION--, cod_pago
	Into nIdSiniestro,nNumAprob--,ccod_pago
	FROM APROBACIONES
	WHERE num_aprobacion = P100_NUMAPROB
    and idsiniestro = P100_IDSINIESTRO;
    EXCEPTION
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20102,'Error en encontrar Aprobacion '||P100_IDSINIESTRO||' - '||P100_NUMAPROB);
    END;

begin
	SELECT IDDETSIN,IDPOLIZA,CODCOBERT,COD_ASEGURADO,StsAprobacion,benef,Tipo_de_Aprobacion,CtaLiquidadora
	INTO nIDDETSIN,nIDPOLIZA,cCODCOBERT,cCOD_ASEGURADO,cStsAprobacion,nbenef,cTipo_de_Aprobacion,cCtaLiquidadora
	FROM APROBACIONES
	WHERE NUM_APROBACION = nNumAprob
	  AND CODCIA = cCodCia
      AND IDSINIESTRO = nIdSiniestro;
exception
when others then
raise_application_error(-20102,'datos : '||nNumAprob||'-'||cCodCia||'-'||nIdSiniestro);
end;
    select Monto_Reservado_Moneda,IDTIPOSEG
    into nMonto_Reservado_Moneda,nIDTIPOSEG
    from   DETALLE_SINIESTRO
    where idsiniestro = nIdSiniestro;
	  
	BEGIN
		SELECT IDETPOL,cod_moneda
			INTO nIdetPol,CCODMONEDA
		  FROM SINIESTRO A
		 WHERE A.IdSiniestro   = nIdSiniestro
           and a.codcia = ccodcia;
	EXCEPTION 
	WHEN OTHERS THEN
			raise_application_error(-20102,'Error al recuperar en estatus del Siniestro : '||SQLERRM);
	END;	
NPASO:=2;
	begin
        SELECT TRIM(Nombre)||' '||TRIM(Apellido_Paterno)||' '||TRIM(Apellido_Materno),
               IndAplicaISR, PorcentISR, PorcePart, 
               Tipo_ID_Tributario, Num_Doc_Tributario  --- SE AGREGAN PARA UTILIZARLOS COMOPARAMETROS EN LA BUSQUEDA DE SAT Y PLD
          INTO cNomBenef,
               cIndAplicaISR,
               nPorcentISR,
   	           nPorcePart,
   	           CRFC,
   	           CNUM_DOC_IDENTIFICACION	              	           
          FROM BENEF_SIN 
         WHERE IdSiniestro   = nIdSiniestro
           AND IdPoliza      = nIdPoliza
           AND Cod_Asegurado = cCod_Asegurado
           AND Benef         = nBenef;
	end;


NPASO:=3;
	--
	PROC_VALIDA_MONTO_PAGO;
NPASO:=4;


    nIdAutorizacionVal := OC_APROBACIONES.NUMERO_AUTORIZACION(nIdSiniestro, nIdDetSin, nIdPoliza,nNumAprob);
NPASO:=5;

	IF NVL(nIdAutorizacionVal,0) = 0 THEN
		SELECT NVL(SUM(Monto_Local),0)
		  INTO nMontoValidaAuto
			FROM APROBACIONes A
		 WHERE A.IdSiniestro 							    = nIdSiniestro
		   AND A.IdDetSin		 							= nIdDetSin
		   AND A.IdPoliza		 							= nIdPoliza
		   AND A.Cod_Asegurado  					= cCod_Asegurado
		   AND NVL(A.StsAprobacion,'SOL')	= 'SOL'
		   AND A.IdAutorizacion 				 IS NULL;
	ELSE
		SELECT NVL(SUM(Monto_Local),0)
		  INTO nMontoValidaAuto
			FROM APROBACIONes A
		 WHERE A.IdSiniestro 							= nIdSiniestro
		   AND A.IdDetSin		 							= nIdDetSin
		   AND A.IdPoliza		 							= nIdPoliza
		   AND A.Cod_Asegurado  					= cCod_Asegurado
		   AND NVL(A.StsAprobacion,'SOL')	= 'SOL'
		   AND A.IdAutorizacion 				 	= nIdAutorizacionVal;
	END IF;
NPASO:=6;
	
	SELECT NVL(SUM(Monto_Local),0)
	  INTO nMontoTotal
		FROM APROBACIONes A
	 WHERE A.IdSiniestro 							= nIdSiniestro
	   AND A.IdDetSin		 							= nIdDetSin
	   AND A.IdPoliza		 							= nIdPoliza
	   AND A.Cod_Asegurado  					= cCod_Asegurado
	   AND A.StsAprobacion 					 IN ('PAG','SOL','EMI')
	   AND NVL(GT_AUTORIZA_PROCESOS.ESTATUS_AUTORIZACION(cCodCia, IdAutorizacion),'NA') != 'RECHAZADA';
NPASO:=6.1;

	IF NVL(nIdAutorizacionVal,0) = 0 THEN
NPASO:=6.2;
        begin
		nIdAutorizacion := GT_AUTORIZA_PROCESOS.VALIDA_AUTORIZACION(cCodCia, '611', cAPP_USER, nIdSiniestro, nIdTipoSeg, nMontoValidaAuto, nMontoTotal);
        end;
NPASO:=6.3;
		IF nIdAutorizacion IS NOT NULL THEN
NPASO:=6.4;
			FOR W IN APROB_Q LOOP
NPASO:=6.41;
				OC_APROBACIONES.ACTUALIZA_AUTORIZACION(W.IdSiniestro, W.IdDetSin, W.IdPoliza, W.Num_Aprobacion, nIdAutorizacion);

			END LOOP;
NPASO:=6.42;
		  GT_AUTORIZA_PROCESOS.AGREGA_DETALLE(cCodCia,nIdAutorizacion);
NPASO:=6.43;
		  GT_AUTORIZA_PROCESOS.NOTIFICA(cCodCia,nIdAutorizacion,GT_AUTORIZA_PROCESOS.EMPLEADO_PROCESA(cCodCia,nIdAutorizacion),'NA');
          COMMIT;
		ELSE
NPASO:=6.5;
		  NSAT_QEQ := 0;
       	  VALIDA_BENEFICIARIO_SAT(nIdSiniestro, nIdPoliza, nBENEF);
		  VALIDA_EN_QEQ(NIDSINIESTRO,NIDPOLIZA,nBENEF);
		  IF NSAT_QEQ = 0 THEN
			PROC_ACTIVA_PAGO(CCODMONEDA,cCtaLiquidadora); --- SE ENVIA A ACTIVAR EL PAGO
 		  END IF;
		END IF;
NPASO:=7;
	ELSIF NVL(nIdAutorizacionVal,0) != 0 THEN
NPASO:=8;
			IF NVL(cStsAprobacion,'SOL') = 'SOL' THEN
				BEGIN
					SELECT DISTINCT A.IdAutorizacion
					  INTO nIdAutorizacion
					  FROM APROBACIONes A,AUTORIZA_PROCESOS AP
					 WHERE A.IdSiniestro 			= nIdSiniestro
					   AND A.IdDetSin		 			= nIdDetSin
					   AND A.IdPoliza		 			= nIdPoliza
					   AND A.Num_Aprobacion 	= nNumAprob
					   AND A.Cod_Asegurado  	= cCod_Asegurado
					   AND AP.CodProceso	  	= '611'
					   AND A.IdAutorizacion 	= AP.IdAutorizacion;
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						nIdAutorizacion := NULL;
				END;
--					Dummy := alerta('jmmd4.1 en bot_activar');				
				cStsAutorizacion := GT_AUTORIZA_PROCESOS.ESTATUS_AUTORIZACION(cCodCia,nIdAutorizacion);
--					Dummy := alerta('jmmd4.2 en bot_activar');								
				IF cStsAutorizacion = 'RECHAZADA' THEN
					raise_application_error(-20102,'La Autorización '||nIdAutorizacion||' Ha Sido Recahzada, Por Favor Contacte a su Supervisor');
				ELSIF cStsAutorizacion IN ('PENDIENTE','REVISADA') THEN
					raise_application_error(-20102,'La Autorización '||nIdAutorizacion||' Sigue en Estatus PENDIENTE de Autorizar o Rechazar, por Favor Contacte a su Supervisor');
				ELSIF cStsAutorizacion = 'REGRESADA' THEN
					IF OC_PROCESO_AUTORIZA_USUARIO.PROCESO_AUTORIZADO(cCodCia , '611', cAPP_USER, '', nMontoValidaAuto) = 'N' THEN
		        IF OC_PROCESO_AUTORIZACION.APLICA_NIVEL_JERARQUICO(cCodCia, '611') = 'S' THEN
		          GT_AUTORIZA_PROCESOS.ACTUALIZA(cCodCia, nIdAutorizacion, nMontoValidaAuto, nMontoTotal, TRUNC(SYSDATE), TO_CHAR(SYSDATE,'HH24:MI:SS'));
		          GT_AUTORIZA_PROCESOS.NOTIFICA(cCodCia,nIdAutorizacion,GT_AUTORIZA_PROCESOS.EMPLEADO_PROCESA(cCodCia,nIdAutorizacion),'NA');
							COMMIT;
		          raise_application_error(-20102,'Para Esta Operacion ya Existe la Autorización REGRESADA Número '||nIdAutorizacion||'. Se han Realizado las Notificaciones Correspondientes a su Supervisor, Por Favor Espere la Confirmación o Rechazo Para Continuar con su Proceso');
		        ELSE
		          raise_application_error(-20102,'Su Perfil de Usuario NO Permite Generar Este Tipo de Oeraciones Y NO Tiene Asignado un Nivel Gerárquico Superior que le Autorice, Valide con su Supervisor: '||SQLERRM);
		        END IF;
		      END IF;
				END IF;
				PROC_ACTIVA_PAGO(CCODMONEDA,cCtaLiquidadora);--- SE ENVIA A ACTIVAR EL PAGO
			END IF;
	END IF;   
END;
/*******************************************/
procedure PAGAR_APROBACION (p100_IDSINIESTRO NUMBER,p100_NUMAPROB NUMBER,CAPP_USER VARCHAR2,P100_NUMMOD NUMBER) IS
    Dummy NUMBER;
    prueba_SaldoReserva number;
    cExiste VARCHAR2(1);
    nCod_Pago DETALLE_APROBACION.Cod_Pago%TYPE;
    nMonto_Local DETALLE_APROBACION.Monto_Local%TYPE;
    nMonto_Moneda DETALLE_APROBACION.Monto_Moneda%TYPE;
    nMaxNumMod  COBERTURA_SINIESTRO.NumMod%TYPE;
    nMonto_Reserva DETALLE_APROBACION.Monto_Moneda%TYPE := 0;
    cStsPag  APROBACIONES.StsAprobacion%TYPE;
    nAjuste  DETALLE_APROBACION.Monto_Local%TYPE := 0;
    cIndTipoCobert CPTOS_TRANSAC_SINIESTROS.IndTipoCobert%TYPE;
    cCpto  VARCHAR2(6);
    nRegis  NUMBER(10);
    nRegisCobert NUMBER(10);
    HABEMUSBENEF NUMBER := 0 ;
    nMtoAproT  APROBACIONES.Monto_Local%TYPE;
    nMtoResT  DETALLE_SINIESTRO.Monto_Reservado_Local%TYPE;
    SALDO_RESERVA  COBERTURA_SINIESTRO.Saldo_Reserva%TYPE;
    SumAseg1  COBERT_ACT.SUMAASEG_LOCAL%TYPE;	
    TotPagado COBERTURA_SINIESTRO.MONTO_PAGADO_MONEDA%TYPE;									       
    nMontoRvaMoneda COBERTURA_SINIESTRO.Saldo_Reserva%TYPE;
    SumaAseguradoReal COBERT_ACT.SUMAASEG_LOCAL%TYPE;
    QueHago    COBERTURA_SINIESTRO.Saldo_Reserva%TYPE;
    USUSARIO   VARCHAR2(50);
    TERMINAL   VARCHAR2(50);
    nIdProcMasivo  PROCESOS_MASIVOS.IdProcMasivo%TYPE;
    PalAurvad  COBERTURA_SINIESTRO.Saldo_Reserva%TYPE;
    wMonto_pagado_moneda  DETALLE_SINIESTRO.MONTO_PAGADO_MONEDA%TYPE;
    sMonto_pagado_local   DETALLE_SINIESTRO.MONTO_PAGADO_LOCAL%TYPE;
    wMnto_pgo_lcl number;
    wMnto_pgo_Mnda SINIESTRO.MONTO_PAGO_MONEDA%TYPE;
    nIdSiniestro SINIESTRO.IDSINIESTRO%TYPE;
    cCodCia	SINIESTRO.CODCIA%TYPE;
    cCodEmpresa	SINIESTRO.CODCIA%TYPE;
    nNumMod	COBERTURA_SINIESTRO.nummod%type := p100_NUMMOD;
    nIDDETSIN	APROBACIONES.IDDETSIN%TYPE;
    cCtaLiquidadora         varchar2(1000);
    nIDPOLIZA	APROBACIONES.IDPOLIZA%TYPE;
    cCODCOBERT	APROBACIONES.CODCOBERT%TYPE;
    cCOD_ASEGURADO	APROBACIONES.COD_ASEGURADO%TYPE;
    nIDTIPOSEG	DETALLE_SINIESTRO.IDTIPOSEG%TYPE;
    nMonto_Reservado_Moneda DETALLE_SINIESTRO.Monto_Reservado_Moneda%type;
    nNumAprob               DETALLE_APROBACION.NUM_APROBACION%type;
    nIDETPOL                SINIESTRO.IDETPOL%TYPE;
    cCod_Pago	DETALLE_APROBACION.cod_pago%type;
    ntotconceptos	number:=0;
    cStsAprobacion	aprobaciones.StsAprobacion%type;
    nbenef	aprobaciones.benef%type;
    NSAT_QEQ	number := 0;
    cCodmoneda	siniestro.cod_moneda%type;
    cNomBenef	varchar2(1000);
    cIndAplicaISR	varchar2(1000);
    nPorcentISR	number;
       nPorcePart	number;
       CRFC	varchar2(1000);
       CNUM_DOC_IDENTIFICACION               varchar2(1000);         
       cTipo_de_Aprobacion   aprobaciones.Tipo_de_Aprobacion%type;
       nmonto_moneda    number;  
       nmonto_local number;


    CURSOR C_RESERVA IS
       SELECT SUM(C.Saldo_Reserva) nMonto,C.CodCobert
         FROM COBERTURA_SINIESTRO C
        WHERE C.IdSiniestro =  nIdSiniestro AND C.IdPoliza    =  nIdPoliza AND Cod_Asegurado = cCod_Asegurado AND C.StsCobertura = 'EMI'
      AND C.NumMod IN  (SELECT MAX(NumMod) 
                             FROM COBERTURA_SINIESTRO CC
                            WHERE CC.IdSiniestro = nIdSiniestro AND CC.IdPoliza    = nIdPoliza AND Cod_Asegurado  = cCod_Asegurado AND C.StsCobertura = 'EMI' aND CC.CodCobert   = C.CodCobert)
        GROUP BY  C.CodCobert;
/**********************************************************************************************************************************/
    PROCEDURE AURVAD (wIdSiniestro in Number, wMntoPgo in Number, wCobertura in  Varchar2) IS
    nIdSiniestro     SINIESTRO.IDSINIESTRO%TYPE;    --  AEVS  NUEVO FLUJO LAYOUT CORTO   DIRVAD
    nCodAsegurado    SINIESTRO.COD_ASEGURADO%TYPE;
    cNumDetUnico     DETALLE_POLIZA.IDETPOL%TYPE;              
    cIdTipoSeg       DETALLE_POLIZA.IDTIPOSEG%TYPE; 
    cPlanCob         DETALLE_POLIZA.PLANCOB%TYPE;
    cStsPoliza       POLIZAS.STSPOLIZA%TYPE;
    cMotivAnul       POLIZAS.MOTIVANUL%TYPE;
    cNumPolUnico     POLIZAS.NUMPOLUNICO%TYPE;
    nIdPoliza        POLIZAS.IDPOLIZA%TYPE;
    nIdetPol         SINIESTRO.IDETPOL%TYPE;  
    nSumaAseg_Moneda COBERT_ACT.SUMAASEG_LOCAL%TYPE;
    nSumaAseg        COBERT_ACT.SUMAASEG_LOCAL%TYPE;
    nMontoRvaMoneda  COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
    diferencia       COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
    PruebaTotal      COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;       
    Resultados       COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE; 
    nSaldoDeLaReserva COBERTURA_SINIESTRO.SALDO_RESERVA_LOCAL%TYPE; 
    prueba_SaldoReserva NUMBER:=0; ---COBERTURA_SINIESTRO_ASEG.SALDO_RESERVA_LOCAL%TYPE; 
    nSumaAseg_Local  COBERT_ACT.SUMAASEG_LOCAL%TYPE;
    nMonto           COBERT_ACT.SUMAASEG_LOCAL%TYPE; 
    nMonto22         COBERT_ACT.SUMAASEG_LOCAL%TYPE;
    nTasaCambio      TASAS_CAMBIO.Tasa_Cambio%TYPE;
    nMoneda          POLIZAS.COD_MONEDA%TYPE;  
    HabemusReserva   COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
    nIdetSin         COBERTURA_SINIESTRO.IDDETSIN%TYPE;
    nNumMod          COBERTURA_SINIESTRO.NUMMOD%TYPE;
    nFecha           DATE;
    cMsjError        VARCHAR2(1000);
    USUSARIO         VARCHAR2(50); 
    TERMINAL         VARCHAR2(50);
    nIdlogproceso    PROCESOS_MASIVOS_LOG.IDLOGPROCESO%TYPE;  
    nTxterror        PROCESOS_MASIVOS_LOG.TXTERROR%TYPE;
    nIdTipoSeg       PROCESOS_MASIVOS.IDTIPOSEG%TYPE;
    nPlanCob         PROCESOS_MASIVOS.PLANCOB%TYPE;
    nTipoProceso     PROCESOS_MASIVOS.TIPOPROCESO%TYPE;
    nRegDatosProc    PROCESOS_MASIVOS.REGDATOSPROC%TYPE;  
    nObservaciones   VARCHAR2(1000);
    CompletaLaFrase  VARCHAR2(1000);
    EnQueLugar       NUMBER;
    nIDTRANSACCION    PROCESOS_MASIVOS_SEGUIMIENTO.IDTRANSACCION%TYPE; 
    nSALDO_RESERVA    COBERTURA_SINIESTRO.SALDO_RESERVA%TYPE;  
    Dummy             Number;
    cIndFecEquiv      SUB_PROCESO.IndFecEquiv%TYPE;
    cIndFecEquivPro   PROC_TAREA.IndFecEquiv%TYPE;
    dFechaCamb        APROBACIONES.FECPAGO%TYPE;
    dFechaCont        FECHA_CONTABLE_EQUIVALENTE.FECHACONTABLE%TYPE;
    dFechaReal        FECHA_CONTABLE_EQUIVALENTE.FECHAREAL%TYPE;
    cCodEmpresa       SINIESTRO.CODEMPRESA%TYPE;
    cCodCia           SINIESTRO.CODCIA%TYPE;
    BEGIN  
        cMsjError := NULL;   
            BEGIN
               SELECT P.IdPoliza, DP.IDetPol, DP.IdTipoSeg, Dp.PlanCob, P.StsPoliza, P.MotivAnul,P.NUMPOLUNICO , SNT.COD_ASEGURADO, SNT.IDETPOL, P.COD_MONEDA 
               INTO   nIdPoliza, cNumDetUnico, cIdTipoSeg, cPlanCob, cStsPoliza, cMotivAnul ,cNumPolUnico , nCodAsegurado, nIdetPol, nMoneda 
               FROM SINIESTRO  SNT,
                     POLIZAS P, 
                     DETALLE_POLIZA DP
               WHERE SNT.IDSINIESTRO =  wIdSiniestro
               AND P.CodCia    = SNT.CODCIA
               AND P.IdPoliza  = SNT.IDPOLIZA
               AND P.StsPoliza IN ('REN','EMI','ANU')
               AND DP.CODCIA   = SNT.CODCIA
               AND DP.IDPOLIZA = SNT.IDPOLIZA
               AND DP.IDETPOL  = 1  ;                    
             EXCEPTION
                  WHEN OTHERS THEN
                     cMsjError:=('x');                 
            END;
            IF cMsjError IS NULL THEN
                BEGIN                     
                 SELECT NVL(SumaAseg_Moneda,0), NVL(SumaAseg_Local,0)
                   INTO nSumaAseg_Moneda, nSumaAseg_Local
                   FROM COBERT_ACT
                  WHERE CodCia        = 1 AND IdPoliza      = nIdPoliza AND IdetPol       = nIdetPol
                    AND Cod_Asegurado = nCodAsegurado AND CodCobert     = wCobertura AND IDETPOL       = nIdetPol;
                EXCEPTION 
                    WHEN OTHERS THEN
                     cMsjError:=('x');                 
                END ;
            END IF;      
            IF nSumaAseg_Moneda = nSumaAseg_Local THEN
               IF nSumaAseg_Moneda > 0 THEN
                nSumaAseg := nSumaAseg_Moneda;
               END IF;
            ELSE
               nSumaAseg:= 0;
            END IF;  
            IF  cMsjError IS NULL THEN 
                BEGIN
                  SELECT CSAG.SALDO_RESERVA
                  INTO   nSaldoDeLaReserva
                  FROM COBERTURA_SINIESTRO CSAG
                  WHERE CSAG.IDDETSIN      = 1
                  AND   CSAG.CODCOBERT     = wCobertura
                  AND   CSAG.IDSINIESTRO   = wIdSiniestro
                  AND   CSAG.IDPOLIZA      = nIdPoliza
                  AND   CSAG.COD_ASEGURADO = nCodAsegurado
                  AND   CSAG.NUMMOD        = (SELECT MAX(CSA3.NUMMOD)
                                              FROM COBERTURA_SINIESTRO CSA3
                                              WHERE CSA3.CODCOBERT     = wCobertura
                                              AND   CSA3.IDSINIESTRO   = wIdSiniestro
                                              AND   CSA3.IDPOLIZA      = nIdPoliza
                                              AND   CSA3.COD_ASEGURADO = nCodAsegurado);
                EXCEPTION
                   WHEN OTHERS  THEN           
                     cMsjError:=('x');                 
                      raise_application_error(-20102,' -20225 NDF Error COBERTURA_SINIESTRO_ASEG  nSaldoDeLaReserva     : ' ||SQLERRM);
                END; 
            END IF;
            IF  nSaldoDeLaReserva IS NULL THEN    
                cMsjError:=('x');                 
            END IF;  
            IF  cMsjError IS NULL THEN 
              SELECT(nSaldoDeLaReserva + wMntoPgo) INTO prueba_SaldoReserva FROM DUAL;
            END IF;  
            IF  cMsjError IS NULL THEN   
                diferencia := 0; --nSumaAseg - nMontoRvaMoneda ; 
                IF (diferencia > 0) OR (diferencia = 0)   THEN  
                    SELECT NVL(MAX(NumMod),0) + 1
                     INTO nNumMod
                     FROM COBERTURA_SINIESTRO
                    WHERE IdPoliza      = nIdPoliza
                      AND IdSiniestro   = wIdSiniestro
                      AND IDDETSIN       = 1
                      AND CodCobert     = wCobertura
                      AND Cod_Asegurado = nCodAsegurado;
                    
                    BEGIN
                        BEGIN
                            select NVL(CODEMPRESA,1),NVL(CODCIA,1)
                                into cCodEmpresa, cCodCia
                              from siniestro
                              where idsiniestro = nIdSiniestro
                              and idpoliza     = nIdPoliza;
                        EXCEPTION
                               WHEN NO_DATA_FOUND THEN
                                    null;
                        END;
                        cIndFecEquivPro := OC_PROC_TAREA.INDICA_FEC_EQUIVALENTE_PRO(6);
                        cIndFecEquiv    := OC_SUB_PROCESO.INDICA_FEC_EQUIVALENTE_SUBPROC(6,'SINAPR');
                        dFechaCont      := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_CONTABLE(cCodCia, cCodEmpresa);
                        dFechaReal      := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_REAL(cCodCia, cCodEmpresa);
                        IF cIndFecEquivPro = 'S' THEN
                           IF cIndFecEquiv = 'S' then
                              dFechaCamb:= dFechaCont;  
                           else
                               dFechaCamb := dFechaReal;
                           end if;
                        ELSE
                            dFechaCamb := dFechaReal;
                        end if;
                        
                        INSERT INTO COBERTURA_SINIESTRO (   IDDETSIN,CODCOBERT ,IDSINIESTRO,IDPOLIZA,COD_ASEGURADO,DOC_REF_PAGO,MONTO_PAGADO_MONEDA,MONTO_PAGADO_LOCAL,MONTO_RESERVADO_MONEDA,MONTO_RESERVADO_LOCAL,STSCOBERTURA,
                                                                NUMMOD,CODTRANSAC,CODCPTOTRANSAC,IDTRANSACCION,SALDO_RESERVA,INDORIGEN,FECRES,SALDO_RESERVA_LOCAL,IDTRANSACCIONANUL)
                                                      VALUES (  1,wCobertura,wIdSiniestro,nIdPoliza,nCodAsegurado,NULL,00.00,00.00,wMntoPgo,wMntoPgo,'SOL',nNumMod,'AURVBA','AUPGTO',NULL,prueba_SaldoReserva  ,'A',trunc(dFechaCamb) ,prueba_SaldoReserva,NULL);
                    EXCEPTION
                        WHEN DUP_VAL_ON_INDEX THEN
                            cMsjError:=('x');                 
                        WHEN OTHERS THEN
                            cMsjError:=('x');                 
                    END;

                    IF cMsjError IS NULL THEN
                        BEGIN
                            OC_COBERTURA_SINIESTRO.EMITE_RESERVA(1  ,1, wIdSiniestro,nIdPoliza , 1          , wCobertura, nNumMod    , null);  
                        EXCEPTION WHEN OTHERS THEN 
                            raise_application_error(-20102,' -20225  AURVAD Error OC_COBERTURA_SINIESTRO_ASEG.EMITE_RESERVA  : ' ||SQLERRM);
                        END;          
                    END IF;
                ELSE   
                    cMsjError:=('x');                 
                END IF;                
            END IF; 
                      BEGIN
                         UPDATE COBERTURA_SINIESTRO  CSA1
                            SET CSA1.MONTO_RESERVADO_LOCAL  = nMonto
                                ,CSA1.SALDO_RESERVA_LOCAL    = prueba_SaldoReserva
                          WHERE CSA1.IDDETSIN      = 1
                            AND CSA1.CODCOBERT     = wCobertura
                            AND CSA1.IDSINIESTRO   = wIdSiniestro
                            AND CSA1.IDPOLIZA      = nIdPoliza
                            AND CSA1.COD_ASEGURADO = nCodAsegurado
                            AND CSA1.NUMMOD        = nNumMod;
                      EXCEPTION
                         WHEN OTHERS THEN              
                     cMsjError:=('x');                 
                            raise_application_error(-20102,' -20225 AURVAD OTHERS  Error al actualizar COBERTURA_SINIESTRO_ASEG : '||SQLERRM);
                      END;
                     BEGIN
    			              SELECT LTRIM(RTRIM(T.DESCRIPCION)) , T.IDOBSERVA
    			              INTO   CompletaLaFrase , EnQueLugar
    			              FROM OBSERVACION_SINIESTRO T
    			              WHERE T.IDSINIESTRO = wIdSiniestro 
    			              AND   T.IDPOLIZA    = nIdPoliza    
    			              AND   T.IDOBSERVA   = (SELECT MAX(O.IDOBSERVA)
    			                                     FROM OBSERVACION_SINIESTRO O
    			                                     WHERE O.IDSINIESTRO = wIdSiniestro
    			                                     AND   O.IDPOLIZA    = nIdPoliza    
    			                                     );
                     EXCEPTION
    			              WHEN OTHERS THEN
                     cMsjError:=('x');                 
    			           END;
               BEGIN
                 UPDATE OBSERVACION_SINIESTRO T2
                 SET   T2.DESCRIPCION = CompletaLaFrase||' <--> '||' Pago Total.Ajuste Positivo para dejar Reserva en Cero. '
                 WHERE T2.IDSINIESTRO = wIdSiniestro 
                 AND   T2.IDPOLIZA    = nIdPoliza    
                 AND   T2.IDOBSERVA   = EnQueLugar;
               EXCEPTION
                  WHEN OTHERS THEN
                     cMsjError:=('x');                 
               END;   
               BEGIN 
                  UPDATE DETALLE_SINIESTRO S
    						     SET S.MONTO_RESERVADO_MONEDA = (S.MONTO_RESERVADO_MONEDA - wMntoPgo)
    						         ,S.MONTO_RESERVADO_LOCAL  = (S.MONTO_RESERVADO_LOCAL  - wMntoPgo)
    						   WHERE S.IDSINIESTRO = wIdSiniestro
    						     AND S.IDPOLIZA    = nIdPoliza
    						     AND S.IDDETSIN    = 1;
               EXCEPTION 
                  WHEN OTHERS THEN
                     cMsjError:=('x');                 
    				   END;
             IF cMsjError IS NULL THEN
             	   COMMIT;
             ELSE
             	   ROLLBACK;
             END IF;
    END AURVAD;
    /*****************************************************************/
    /*****************************************************************/
    /*****************************************************************/
    PROCEDURE DIRVAD (wIdSiniestro in Number, wMntoPgo in Number, wCobertura in  Varchar2) IS
        nIdSiniestro     SINIESTRO.IDSINIESTRO%TYPE;    --  AEVS  NUEVO FLUJO LAYOUT CORTO   DIRVAD
        nCodAsegurado    SINIESTRO.COD_ASEGURADO%TYPE;
        cNumDetUnico     DETALLE_POLIZA.IDETPOL%TYPE;              
        cIdTipoSeg       DETALLE_POLIZA.IDTIPOSEG%TYPE; 
        cPlanCob         DETALLE_POLIZA.PLANCOB%TYPE;
        cStsPoliza       POLIZAS.STSPOLIZA%TYPE;
        cMotivAnul       POLIZAS.MOTIVANUL%TYPE;
        cNumPolUnico     POLIZAS.NUMPOLUNICO%TYPE;
        nIdPoliza        POLIZAS.IDPOLIZA%TYPE;
        nIdetPol         SINIESTRO.IDETPOL%TYPE;  
        nSumaAseg_Moneda COBERT_ACT.SUMAASEG_LOCAL%TYPE;
        nSumaAseg        COBERT_ACT.SUMAASEG_LOCAL%TYPE;
        nMontoRvaMoneda  COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
        diferencia       COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
        PruebaTotal      COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;       
        Resultados       COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE; 
        nSaldoDeLaReserva COBERTURA_SINIESTRO.SALDO_RESERVA_LOCAL%TYPE; 
        nSumaAseg_Local  COBERT_ACT.SUMAASEG_LOCAL%TYPE;
        nMonto           COBERT_ACT.SUMAASEG_LOCAL%TYPE; 
        nMonto22         COBERT_ACT.SUMAASEG_LOCAL%TYPE;
        nTasaCambio      TASAS_CAMBIO.Tasa_Cambio%TYPE;
        nMoneda          POLIZAS.COD_MONEDA%TYPE;  
        HabemusReserva   COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
        nIdetSin         COBERTURA_SINIESTRO.IDDETSIN%TYPE;
        nNumMod          COBERTURA_SINIESTRO.NUMMOD%TYPE;
        nFecha           DATE;
        cMsjError        VARCHAR2(1000);
        USUSARIO         VARCHAR2(50); 
        TERMINAL         VARCHAR2(50);
        nIdlogproceso    PROCESOS_MASIVOS_LOG.IDLOGPROCESO%TYPE;  
        nTxterror        PROCESOS_MASIVOS_LOG.TXTERROR%TYPE;
        nIdTipoSeg       PROCESOS_MASIVOS.IDTIPOSEG%TYPE;
        nPlanCob         PROCESOS_MASIVOS.PLANCOB%TYPE;
        nTipoProceso     PROCESOS_MASIVOS.TIPOPROCESO%TYPE;
        nRegDatosProc    PROCESOS_MASIVOS.REGDATOSPROC%TYPE;  
        nObservaciones   VARCHAR2(1000);
        CompletaLaFrase  VARCHAR2(1000);
        EnQueLugar       NUMBER;
        nIDTRANSACCION    PROCESOS_MASIVOS_SEGUIMIENTO.IDTRANSACCION%TYPE; 
        nSALDO_RESERVA    COBERTURA_SINIESTRO.SALDO_RESERVA%TYPE;  
        nIdSiniestro2     COBERTURA_SINIESTRO.IDSINIESTRO%TYPE;
        nIdPoliza2        COBERTURA_SINIESTRO.IDPOLIZA%TYPE;
        nStsCobertura2    COBERTURA_SINIESTRO.STSCOBERTURA%TYPE;
        nNumMod2          COBERTURA_SINIESTRO.NUMMOD%TYPE;
        nCodTransac2      COBERTURA_SINIESTRO.CODTRANSAC%TYPE;
        nCodCptoTransac2  COBERTURA_SINIESTRO.CODCPTOTRANSAC%TYPE;
        nIdTransaccion2   COBERTURA_SINIESTRO.IDTRANSACCION%TYPE;
        nSaldoReserva2    COBERTURA_SINIESTRO.SALDO_RESERVA%TYPE;
        Dummy             Number;
        cIndFecEquiv      SUB_PROCESO.IndFecEquiv%TYPE;
        cIndFecEquivPro   PROC_TAREA.IndFecEquiv%TYPE;
        dFechaCamb        APROBACIONES.FECPAGO%TYPE;
        dFechaCont        FECHA_CONTABLE_EQUIVALENTE.FECHACONTABLE%TYPE;
        dFechaReal        FECHA_CONTABLE_EQUIVALENTE.FECHAREAL%TYPE;
        cCodEmpresa       SINIESTRO.CODEMPRESA%TYPE;
        cCodCia           SINIESTRO.CODCIA%TYPE;
    BEGIN  
        cMsjError := NULL;
        BEGIN
          SELECT P.IdPoliza, DP.IDetPol, DP.IdTipoSeg, Dp.PlanCob, P.StsPoliza, P.MotivAnul,P.NUMPOLUNICO , SNT.COD_ASEGURADO, SNT.IDETPOL, P.COD_MONEDA 
          INTO nIdPoliza, cNumDetUnico, cIdTipoSeg, cPlanCob, cStsPoliza, cMotivAnul ,cNumPolUnico , nCodAsegurado, nIdetPol, nMoneda 
          FROM SINIESTRO  SNT,
          POLIZAS P, 
          DETALLE_POLIZA DP
          WHERE SNT.IDSINIESTRO =  wIdSiniestro
          AND P.CodCia = SNT.CODCIA
          AND P.IdPoliza  = SNT.IDPOLIZA
          AND P.StsPoliza IN ('REN','EMI','ANU')
          AND DP.CODCIA= SNT.CODCIA
          AND DP.IDPOLIZA = SNT.IDPOLIZA
          AND DP.IDETPOL  = 1  ;  
        EXCEPTION
            WHEN OTHERS THEN
                cMsjError:='x';
        END;
        IF cMsjError IS NULL THEN
            BEGIN
                SELECT NVL(SumaAseg_Moneda,0), NVL(SumaAseg_Local,0)
                INTO nSumaAseg_Moneda, nSumaAseg_Local
                FROM COBERT_ACT
                WHERE CodCia  = 1
                AND IdPoliza= nIdPoliza
                AND IdetPol = nIdetPol
                AND Cod_Asegurado = nCodAsegurado
                AND CodCobert  = wCobertura;
            EXCEPTION 
                WHEN OTHERS THEN
                    cMsjError:='x';
            END ;
        END IF;
        IF nSumaAseg_Moneda = nSumaAseg_Local THEN
    	    IF nSumaAseg_Moneda > 0 THEN
    	  	    nSumaAseg := nSumaAseg_Moneda;
    	    END IF;
        ELSE
    	    nSumaAseg:= 0;
        END IF;  
        IF  cMsjError IS NULL THEN 
            BEGIN
                SELECT CSAG.SALDO_RESERVA
                INTO nSaldoDeLaReserva
                FROM COBERTURA_SINIESTRO CSAG
                WHERE CSAG.IDDETSIN= 1
                AND CSAG.CODCOBERT  = wCobertura
                AND CSAG.IDSINIESTRO= wIdSiniestro
                AND CSAG.IDPOLIZA= nIdPoliza
                AND CSAG.COD_ASEGURADO = nCodAsegurado
                AND   CSAG.NUMMOD        = (SELECT MAX(CSA3.NUMMOD)
                FROM COBERTURA_SINIESTRO CSA3
                WHERE CSA3.CODCOBERT     = wCobertura
                  AND   CSA3.IDSINIESTRO   = wIdSiniestro
                  AND   CSA3.IDPOLIZA      = nIdPoliza
                  AND   CSA3.COD_ASEGURADO = nCodAsegurado);
            EXCEPTION  
            WHEN NO_DATA_FOUND  THEN           
                RAISE_APPLICATION_ERROR(-20102,'-20225 NDF Error COBERTURA_SINIESTRO_ASEG  nSaldoDeLaReserva     : ' ||SQLERRM);
            WHEN OTHERS  THEN           
                RAISE_APPLICATION_ERROR(-20102,'-20225 OTHERS Error COBERTURA_SINIESTRO_ASEG  nSaldoDeLaReserva     : ' ||SQLERRM);
            END; 
        END IF;
        IF  cMsjError IS NULL THEN    
            IF  nSaldoDeLaReserva = 0  THEN
                cMsjError:='x';
            END IF;       
        END IF;  
        IF  cMsjError IS NULL THEN 
            SELECT(nSaldoDeLaReserva - wMntoPgo)
            INTO prueba_SaldoReserva
            froM DUAL;
            IF prueba_SaldoReserva < 0  THEN
                RAISE_APPLICATION_ERROR(-20102,'-20225 La Disminución dejaría el Saldo de la Reserva Negativa. No se Puede crear éste Ajuste  ' );
            END IF;
        END IF;  
        IF  cMsjError IS NULL THEN   
            diferencia := 0; --nSumaAseg - nMontoRvaMoneda ; 
            IF (diferencia > 0) OR (diferencia = 0)   THEN  
                SELECT NVL(MAX(NumMod),0) + 1
                INTO nNumMod
                FROM COBERTURA_SINIESTRO
                WHERE IdPoliza      = nIdPoliza
                AND IdSiniestro   = wIdSiniestro
                AND IDDETSIN       = 1
                AND CodCobert     = wCobertura
                AND Cod_Asegurado = nCodAsegurado;
                BEGIN
                    BEGIN
                        select NVL(CODEMPRESA,1),NVL(CODCIA,1)
                        into cCodEmpresa, cCodCia
                        from siniestro
                        where idsiniestro = nIdSiniestro
                        and idpoliza     = nIdPoliza;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            null;
                    END;
                    cIndFecEquivPro := OC_PROC_TAREA.INDICA_FEC_EQUIVALENTE_PRO(6);
                    cIndFecEquiv    := OC_SUB_PROCESO.INDICA_FEC_EQUIVALENTE_SUBPROC(6,'SINAPR');
                    dFechaCont      := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_CONTABLE(cCodCia, cCodEmpresa);
                    dFechaReal      := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_REAL(cCodCia, cCodEmpresa);
                    IF cIndFecEquivPro = 'S' THEN
                        IF cIndFecEquiv = 'S' then
                            dFechaCamb:= dFechaCont;  
                        else
                            dFechaCamb := dFechaReal;
                        end if;
                    ELSE
                        dFechaCamb := dFechaReal;
                    end if;
                    INSERT INTO COBERTURA_SINIESTRO (   IDDETSIN,CODCOBERT,IDSINIESTRO,IDPOLIZA,COD_ASEGURADO,DOC_REF_PAGO,MONTO_PAGADO_MONEDA,MONTO_PAGADO_LOCAL,MONTO_RESERVADO_MONEDA,MONTO_RESERVADO_LOCAL,STSCOBERTURA,NUMMOD,CODTRANSAC,CODCPTOTRANSAC,IDTRANSACCION,SALDO_RESERVA,INDORIGEN,FECRES,SALDO_RESERVA_LOCAL,IDTRANSACCIONANUL)
                    VALUES (1,wCobertura,wIdSiniestro,nIdPoliza,nCodAsegurado,NULL,00.00,00.00,wMntoPgo,wMntoPgo,'SOL',nNumMod,'DIRVAD','DIRVAD',NULL,prueba_SaldoReserva,'A',trunc(sysdate),prueba_SaldoReserva,NULL);
                EXCEPTION
                    WHEN OTHERS THEN
                        cMsjError:='x';
                END;
                IF cMsjError IS NULL THEN
                    BEGIN
                        OC_COBERTURA_SINIESTRO.EMITE_RESERVA(1  ,1, wIdSiniestro,nIdPoliza , 1          , wCobertura, nNumMod    , null);  
                    EXCEPTION
                        WHEN OTHERS THEN 
                            RAISE_APPLICATION_ERROR(-20102,' -20225  DIRVAD Error OC_COBERTURA_SINIESTRO_ASEG.EMITE_RESERVA  : ' ||SQLERRM);
                    END;          
                END IF;
            ELSE   
                cMsjError:='x';
            END IF;                
        END IF; 
        BEGIN
            UPDATE COBERTURA_SINIESTRO  CSA1
            SET CSA1.MONTO_RESERVADO_LOCAL  = nMonto,CSA1.SALDO_RESERVA_LOCAL    = prueba_SaldoReserva
            WHERE CSA1.IDDETSIN      = 1 AND   CSA1.CODCOBERT     = wCobertura
            AND   CSA1.IDSINIESTRO   = wIdSiniestro
            AND   CSA1.IDPOLIZA      = nIdPoliza
            AND   CSA1.COD_ASEGURADO = nCodAsegurado
            AND   CSA1.NUMMOD        = nNumMod;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN 
                RAISE_APPLICATION_ERROR(-20102,'NDF Error al actualizar COBERTURA_SINIESTRO_ASEG : '||SQLERRM);
            WHEN OTHERS THEN              
                RAISE_APPLICATION_ERROR(-20102,' -20225  OTHERS  Error al actualizar COBERTURA_SINIESTRO_ASEG : '||SQLERRM);
        END;
        BEGIN
            SELECT LTRIM(RTRIM(T.DESCRIPCION)) , T.IDOBSERVA
            INTO   CompletaLaFrase , EnQueLugar
            FROM OBSERVACION_SINIESTRO T
            WHERE T.IDSINIESTRO = wIdSiniestro 
            AND   T.IDPOLIZA    = nIdPoliza    
            AND   T.IDOBSERVA   = (SELECT MAX(O.IDOBSERVA)
            FROM OBSERVACION_SINIESTRO O
            WHERE O.IDSINIESTRO = wIdSiniestro
            AND   O.IDPOLIZA    = nIdPoliza);
        EXCEPTION
            WHEN OTHERS THEN
                cMsjError:='x';
        END; 
        BEGIN
            UPDATE OBSERVACION_SINIESTRO T2
            SET   T2.DESCRIPCION = CompletaLaFrase||' <--> '||' Pago Total.Ajuste Negativo para dejar Reserva en Cero. '
            WHERE T2.IDSINIESTRO = wIdSiniestro 
            AND   T2.IDPOLIZA    = nIdPoliza    
            AND   T2.IDOBSERVA   = EnQueLugar;
        EXCEPTION
            WHEN OTHERS THEN
                cMsjError:='x';
        END;   
        BEGIN 
            UPDATE DETALLE_SINIESTRO S
            SET   S.MONTO_RESERVADO_MONEDA = (S.MONTO_RESERVADO_MONEDA - wMntoPgo),S.MONTO_RESERVADO_LOCAL  = (S.MONTO_RESERVADO_LOCAL  - wMntoPgo)
            WHERE S.IDSINIESTRO = wIdSiniestro AND   S.IDPOLIZA    = nIdPoliza AND   S.IDDETSIN    = 1;
        EXCEPTION
            WHEN OTHERS THEN
                cMsjError:='x';
        END;
        IF cMsjError IS NULL THEN
            COMMIT;
        ELSE
            ROLLBACK;
        END IF;
    END dirvad;
    /*****************************************************************/
    /*****************************************************************/
    /*****************************************************************/
    PROCEDURE VALIDA_EN_QEQ(NIDSINIESTROpar number,NIDPOLIZApar number,nBENEFpar number) is

        Dummy    Number;
        cNombreCompleto			VARCHAR2(300);
        cST_RESOLUCIO				ADMON_RIESGO_SINIESTROS.ST_RESOLUCION%TYPE ; 
        cTP_RESOLUCION			ADMON_RIESGO.TP_RESOLUCION%TYPE ; 
        cListas						  ADMON_RIESGO.Observaciones%TYPE;	
        nIdSiniestro				SINIESTRO.IDSINIESTRO%TYPE;
        nIdPoliza						SINIESTRO.IDPOLIZA%TYPE;
        nCod_Asegurado			SINIESTRO.COD_ASEGURADO%TYPE;
        nCodcia							SINIESTRO.CODCIA%TYPE;
        nCodEmpresa					SINIESTRO.CODEMPRESA%TYPE;	
        nBenef							BENEF_SIN.BENEF%TYPE;
        cTipo_id_tributario BENEF_SIN.TIPO_ID_TRIBUTARIO%TYPE;
        cNum_DOC_tributario BENEF_SIN.NUM_DOC_TRIBUTARIO%TYPE;  
        cUsuario	          VARCHAR2(50);
        cObservaciones		  ADMON_RIESGO.Observaciones%TYPE := '';	  
        ncuantos						NUMBER;
        nDiasautpld					NUMBER;
    BEGIN
        cUsuario	 := CAPP_USER;
        BEGIN
            SELECT DESCVALLST
            INTO nDiasautpld
            FROM VALORES_DE_LISTAS
            WHERE CODLISTA = 'DIASAUTPLD'
            aND CODVALOR = 'ODC';
        EXCEPTION
            WHEN OTHERS THEN 
                nDiasautpld := 1;
        END;
        SELECT IDSINIESTRO, IDPOLIZA, COD_ASEGURADO,BENEF,NOMBRE||' ' ||APELLIDO_PATERNO||' '||APELLIDO_MATERNO, TIPO_ID_TRIBUTARIO, NUM_DOC_TRIBUTARIO
        INTO nIdSiniestro	, nIdPoliza , nCod_Asegurado , nBenef	, cNombreCompleto, cTipo_id_tributario , cNum_DOC_tributario 	
        frOM BENEF_SIN
        WHERE IDSINIESTRO = NIDSINIESTROpar
        AND IDPOLIZA = NIDPOLIZApar
        AND BENEF = nBENEFpar;
        SELECT CODCIA, CODEMPRESA
        INTO nCodcia, nCodEmpresa
        FROM SINIESTRO
        WHERE IDSINIESTRO = NIDSINIESTRO
        AND IDPOLIZA = NIDPOLIZA		 	  ;
        BEGIN
            SELECT ST_RESOLUCION, TP_RESOLUCION
            INTO cST_RESOLUCIO, cTP_RESOLUCION
            FROM ADMON_RIESGO_SINIESTROS
            WHERE (TIPO_DOC_IDENTIFICACION = cTipo_id_tributario OR TIPO_DOC_IDENTIFICACION IS NULL)
            AND (NUM_DOC_IDENTIFICACION = cNum_DOC_tributario OR NUM_DOC_IDENTIFICACION IS NULL) 
            AND NOMBRE_BENEFICIARIO = cNombreCompleto 
            AND TRUNC(FE_ESTATUS) >= TRUNC(SYSDATE - nDiasautpld)
            AND NUMSINIESTRO = NIDSINIESTRO
            AND IDPOLIZA = NIDPOLIZA	;	 
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN	  	
                BEGIN
                    OC_ADMON_RIESGO_SINIESTROS.VALIDA(NCODCIA ,nCodEmpresa  ,1 ,nIdPoliza ,nCod_Asegurado , nIdSiniestro ,nBenef ,cNombreCompleto ,'PEND' ,cTipo_id_tributario	,cNum_DOC_tributario	,'' ,cUsuario , cObservaciones); 
                EXCEPTION 
                    WHEN OTHERS THEN
                        cST_RESOLUCIO := null ;  	  			  	
                END;  
            WHEN OTHERS THEN	  
                cST_RESOLUCIO := NULL;
        END;  
        SELECT COUNT(*)
        INTO ncuantos
        FROM ADMON_RIESGO_SINIESTROS
        WHERE (TIPO_DOC_IDENTIFICACION = cTipo_id_tributario OR TIPO_DOC_IDENTIFICACION IS NULL) 
        AND (NUM_DOC_IDENTIFICACION = cNum_DOC_tributario OR NUM_DOC_IDENTIFICACION IS NULL)
        AND NOMBRE_BENEFICIARIO = cNombreCompleto
        AND ST_RESOLUCION != 'APRO'
        AND NUMSINIESTRO 	 = NIDSINIESTRO
        AND IDPOLIZA 			 = NIDPOLIZA	;	
        IF ncuantos > 0 THEN
    				 cST_RESOLUCIO := 'PEND';
        ELSE
    				 cST_RESOLUCIO := 'APRO';
        END IF;
        IF cST_RESOLUCIO = 'PEND' THEN
    	    NSAT_QEQ := 1;
    	 	RAISE_APPLICATION_ERROR(-20104,'EL REGISTRO SE ENCUENTRA EN PLD SINIESTROS, CON STATUS DE '|| cST_RESOLUCIO||'.  REQUIERE AUTORIZACIÓN DEL OFICIAL DE CUMPLIMIENTO');	 
        END IF; 	
    END VALIDA_EN_QEQ;
    /*inicio*/
BEGIN
    --for i in 1..apex_application.g_f01.count loop
	SELECT IDSINIESTRO,CODCIA,NUM_APROBACION,cod_pago,CodEmpresa
	Into nIdSiniestro,cCodCia,nNumAprob,ccod_pago,cCodEmpresa
	FROM DETALLE_APROBACION
	wHERE num_aprobacion = p100_NUMAPROB
    and idsiniestro = p100_IDSINIESTRO
    and IDDETAPROB=1;

	SELECT IDDETSIN,IDPOLIZA,CODCOBERT,COD_ASEGURADO,StsAprobacion,benef,Tipo_de_Aprobacion,CtaLiquidadora
	INTO nIDDETSIN,nIDPOLIZA,cCODCOBERT,cCOD_ASEGURADO,cStsAprobacion,nbenef,cTipo_de_Aprobacion,CCtaLiquidadora
	FROM APROBACIONes
	WHERE NUM_APROBACION = nNumAprob
	  AND CODCIA = cCodCia
      AND IDSINIESTRO = nIdSiniestro;

    select Monto_Reservado_Moneda,IDTIPOSEG
    into nMonto_Reservado_Moneda,nIDTIPOSEG
    from   DETALLE_SINIESTRO
    where idsiniestro = nIdSiniestro;
	BEGIN
		SELECT IDETPOL,cod_moneda
			INTO nIdetPol,ccodmoneda
		  FROM SINIESTRO A
		 WHERE A.IdSiniestro   = nIdSiniestro
           and a.codcia = ccodcia;
	EXCEPTION 
	WHEN OTHERS THEN
			raise_application_error(-20102,'Error al recuperar en estatus del Siniestro : '||SQLERRM);
	END;	
    begin
        SELECT TRIM(Nombre)||' '||TRIM(Apellido_Paterno)||' '||TRIM(Apellido_Materno),
               IndAplicaISR, PorcentISR, PorcePart, 
               Tipo_ID_Tributario, Num_Doc_Tributario
          INTO cNomBenef,
               cIndAplicaISR,
               nPorcentISR,
               nPorcePart,
               CRFC,
               CNUM_DOC_IDENTIFICACION	              	           
          FROM BENEF_SIN 
         WHERE IdSiniestro   = nIdSiniestro
           AND IdPoliza      = nIdPoliza
           --AND Cod_Asegurado = cCod_Asegurado
           AND Benef         = nBenef;
    end;
    VALIDA_EN_QEQ(nidsiniestro,nidpoliza,nbenef);
    IF CCtaLiquidadora IS NULL THEN
        RAISE_APPLICATION_ERROR(-20102,'Debe Asignar la Cuenta Liquidadora para la Aprobación de Pago');
    END IF;
    BEGIN 
     SELECT NVL(SUM(C.Saldo_Reserva),0) nMonto
         INTO nMtoResT
       FROM COBERTURA_SINIESTRO C
      WHERE C.IdSiniestro  =  NIdSiniestro
        AND C.IdPoliza     =  nIdPoliza
        AND C.StsCobertura = 'EMI'
          AND C.NumMod IN  	 (SELECT MAX(NumMod) 
                                FROM COBERTURA_SINIESTRO CC
                               WHERE CC.IdSiniestro =  nIdSiniestro
                                 AND CC.IdPoliza    =  nIdPoliza
                                 AND C.StsCobertura = 'EMI'
                                 AND CC.CodCobert   = C.CodCobert);
    END;
    BEGIN
        sELECT NVL(SUM(DA.Monto_Local),0) Monto_Local
        INTO nMtoAproT
        FROM DETALLE_APROBACION DA, APROBACIONES AP, CPTOS_TRANSAC_SINIESTROS CT
        WHERE DA.Num_Aprobacion = nNUMAPROB
        AND DA.IdSiniestro    = nIdSiniestro
        AND AP.Num_Aprobacion = DA.Num_Aprobacion
        AND AP.IdSiniestro    = DA.IdSiniestro
        AND AP.IdPoliza       = nIdPoliza
        AND DA.CodTransac     = CT.CodTransac
        AND DA.CodCptoTransac = CT.CodCptoTransac
        AND CT.IndDisminRva   = 'S';
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            nMtoAproT := 0;
    END;
    IF nMtoAproT > nMtoResT AND cTipo_de_Aprobacion = 'P' THEN 
        raise_application_error(-20102,'No puede Activar Aprobacion el Monto es Mayor al Saldo de la Reserva  ( '||nMtoResT||' ) de la Cobertura, Favor de Verificar');
    END IF;  
    IF cTIPO_DE_APROBACION = 'T' THEN
        QueHago := ( nMtoResT - nMtoAproT);
        IF  QueHago = 0  THEN
            OC_APROBACIONes.PAGAR(cCodCia, cCodEmpresa, nNumAprob, nIdSiniestro, nIdPoliza, nIdDetSin);
        ELSIF QueHago > 0  THEN
            DIRVAD(nIdSiniestro,QueHago,cCod_Pago );
            OC_APROBACIONes.PAGAR(cCodCia, cCodEmpresa, nNumAprob, nIdSiniestro, nIdPoliza, nIdDetSin); 
            COMMIT;
        ELSIF QueHago < 0  THEN
            PalAurvad := ABS(QueHago) ;
            AURVAD(nIdSiniestro,PalAurvad,cCod_Pago);
            OC_APROBACIONes.PAGAR(cCodCia, cCodEmpresa, nNumAprob, nIdSiniestro, nIdPoliza, nIdDetSin);
            COMMIT;
        END IF;	
    ELSE
        OC_APROBACIONes.PAGAR(cCodCia, cCodEmpresa, nNumAprob, nIdSiniestro, nIdPoliza, nIdDetSin);
        COMMIT;
    END IF;
    
    SELECT DS.MONTO_PAGADO_MONEDA , DS.MONTO_PAGADO_LOCAL INTO wMonto_pagado_moneda , sMonto_pagado_local
    FROM DETALLE_SINIESTRO DS  WHERE DS.IDSINIESTRO  = nIdSiniestro AND DS.IDPOLIZA     = nIdPoliza  AND DS.IDDETSIN     = 1 ;   
    SELECT S1.MONTO_PAGO_LOCAL,S1.MONTO_PAGO_MONEDA INTO wMnto_pgo_lcl , wMnto_pgo_Mnda  
    FROM SINIESTRO S1 WHERE S1.IDSINIESTRO  = nIdSiniestro AND S1.IDPOLIZA     = nIdPoliza;
    COMMIT;  
END PAGAR_APROBACION;
    /*****************************************************************/
    /*****************************************************************/
    /*****************************************************************/

FUNCTION NOMBRE_PERSONA(cTipoDocIdent VARCHAR2, nNumDocIdent VARCHAR2) RETURN VARCHAR2 IS
      cNombre  VARCHAR2(500);
BEGIN
       SELECT TRIM(Nombre) || ' ' || TRIM(Apellido_Paterno) || ' ' ||
              TRIM(Apellido_Materno) || ' ' || DECODE(ApeCasada, NULL, ' ', ' de ' ||ApeCasada)
         INTO cNombre
         FROM PERSONA_NATURAL_JURIDICA
        WHERE Tipo_Doc_Identificacion = cTipoDocIdent
          AND Num_Doc_Identificacion  = nNumDocIdent;
       RETURN(cNombre);
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          cNombre := 'PERSONAL NATURAL JURIDICA - NO EXISTE!!!';
          RETURN(cNombre);
END NOMBRE_PERSONA;

procedure ANULAR_APROBACION(NCodCia NUMBER, nCodEmpresa NUMBER,p100_NumAprob NUMBER,p100_IdSiniestro NUMBER,p100_IdPoliza NUMBER, P100_IdDetSin NUMBER,
                            Capp_USER VARCHAR2,P100_IdTipoSeg VARCHAR2,P100_MONTO_MONEDA NUMBER) IS
Dummy   NUMBER;
nIdAutorizacion 		AUTORIZA_PROCESOS.IdAutorizacion%TYPE;
cValidaAutorizacion VARCHAR2(1);
cStsAutorizacion		AUTORIZA_PROCESOS.StsAutorizacion%TYPE;
BEGIN
	BEGIN
		SELECT A.IdAutorizacion
		  INTO nIdAutorizacion
		  FROM APROBACIONES A,AUTORIZA_PROCESOS AP
		 WHERE A.IdSiniestro 		= P100_IdSiniestro
		   AND A.IdDetSin		 		= P100_IdDetSin
		   AND A.IdPoliza		 		= P100_IdPoliza
		   AND A.Num_Aprobacion = P100_NumAprob
		   AND AP.CodProceso	  = '612'
		   AND A.IdAutorizacion = AP.IdAutorizacion;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			nIdAutorizacion := NULL;
	END;
	
	IF nIdAutorizacion IS NULL THEN
		nIdAutorizacion := GT_AUTORIZA_PROCESOS.VALIDA_AUTORIZACION(NCodCia, '612', CAPP_USER, P100_IdSiniestro, P100_IdTiposeg, P100_MONTO_MONEDA,0);
		IF nIdAutorizacion IS NOT NULL THEN
			OC_APROBACIONES.ACTUALIZA_AUTORIZACION(P100_IdSiniestro, P100_IdDetSin, P100_IdPoliza,P100_NumAprob, nIdAutorizacion);
      GT_AUTORIZA_PROCESOS.AGREGA_DETALLE(nCodCia,nIdAutorizacion);
      STANDARD.COMMIT;
      RAISE_APPLICATION_ERROR(-20102,'Se ha Generado la Autorización Número '||nIdAutorizacion||'. Por Favor Espere la Confirmación o Rechazo Para Continuar con su Proceso');
      
		END IF;
	ELSE
		cStsAutorizacion := GT_AUTORIZA_PROCESOS.ESTATUS_AUTORIZACION(NCodCia,nIdAutorizacion);
		IF cStsAutorizacion = 'RECHAZADA' THEN
			RAISE_APPLICATION_ERROR(-20102,'La Autorización '||nIdAutorizacion||' Ha Sido Recahzada, Por Favor Contacte a su Supervisor');
      
		ELSIF cStsAutorizacion IN ('PENDIENTE','REVISADA') THEN
			RAISE_APPLICATION_ERROR(-20102,'La Autorización '||nIdAutorizacion||' Sigue en Estatus PENDIENTE de Autorizar o Rechazar, por Favor Contacte a su Supervisor');
		END IF;
	END IF;	
   	  OC_APROBACIONES.ANULAR(nCodCia, nCodEmpresa,P100_NumAprob, P100_IdSiniestro,P100_IdPoliza, P100_IdDetSin);
       STANDARD.COMMIT;
END;

END SICAS_APEX;

/

GRANT EXECUTE ON SICAS_OC.SICAS_APEX TO PUBLIC;
 
/
 
CREATE PUBLIC SYNONYM SICAS_APEX FOR SICAS_OC.SICAS_APEX;