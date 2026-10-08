create or replace PACKAGE          OC_REPORTES_FONDO_INVERSION AS
/*------------------------------------------------------------------------
    Nombre: OC_REPORTES_FONDO_INVERSION
    Autor: Gustavo Morfin / Equipo Desarrollo
    Versión: 1.0
    Fecha Creación: 12/05/2026
    Descripción: Paquete encargado de la generación de reportes relacionados
	con fondos de inversión asociados a pólizas.
    Fechas Modificación:
------------------------------------------------------------------------*/

-- FONDO POR POLIZA
	PROCEDURE REP_FONDO_POL (cNomArchivo   IN VARCHAR2
							,cIdTipoSeg    IN VARCHAR2
							,cPlanCob      IN VARCHAR2
							,cCodMoneda    IN VARCHAR2
							,nIdPoliza     IN VARCHAR2
							,dFecDesde     IN DATE
							,dFecHasta     IN DATE
							,cFormato      IN VARCHAR2
							,nIdReporte    IN NUMBER);

-- FONDO POR POLIZA DETALLE
	PROCEDURE REP_FONDO_POL_DET (cNomArchivo   IN VARCHAR2
								,cIdTipoSeg    IN VARCHAR2
								,cPlanCob      IN VARCHAR2
								,cCodMoneda    IN VARCHAR2
								,nIdPoliza     IN VARCHAR2
								,dFecDesde     IN DATE
								,dFecHasta     IN DATE
								,cFormato      IN VARCHAR2
								,nIdReporte    IN NUMBER);

END OC_REPORTES_FONDO_INVERSION;
/
create or replace package body          OC_REPORTES_FONDO_INVERSION as
--FONDO POR POLIZA
	PROCEDURE REP_FONDO_POL (cNomArchivo 	VARCHAR2
							,cIdTipoSeg 	VARCHAR2
							,cPlanCob 		VARCHAR2
							,cCodMoneda 	VARCHAR2
							,nIdPoliza 		VARCHAR2
							,dFecDesde   	DATE
							,dFecHasta   	DATE
							,cFormato    	VARCHAR2
							,nIdReporte  	NUMBER) IS

                                  
	cLimitador           VARCHAR2(20) :='</td>';
	nLinea               NUMBER;
	cCadena              VARCHAR2(4200);
	cCadena2             VARCHAR2(4200);
	cCadena3             VARCHAR2(4200);
	cCadenaCOb           VARCHAR2(4200); 
	cCodUser             VARCHAR2(30);
	nDummy               NUMBER;
	cCopy                BOOLEAN;
	cCampoFormatC      	 VARCHAR2(4000):= '<td class=texto>';
	cCampoFormatN        VARCHAR2(4000):= '<td class=numero>';
	cCampoFormatD        VARCHAR2(4000):= '<td class=fecha>';
	nItera               NUMBER:= 0;
	CuantasCoberts       NUMBER:= 0;  
	cMTOAPORTEINILOCAL   NUMBER(28,6); 
	cSaldoFinal          NUMBER(28,6);
	cDesc_Fondo          VARCHAR2(200); 					  
	cMONTOMOVMONEDA      FAI_CONCENTRADORA_FONDO.MONTOMOVMONEDA%type; 
	Error                VARCHAR2(200);
	nRETISR		         NUMBER(28,2);
	nRETISR2             NUMBER(28,2);
	cPRIMABAS            NUMBER(28,2);
	COBPRIMAS            NUMBER(28,2);
	APORPRIMAS           NUMBER(28,2);
	dFecNacimiento       PERSONA_NATURAL_JURIDICA.FecNacimiento%type;
	nEdadCliente         NUMBER;
	n1           		 NUMBER(28,6);--- 
	n2           		 NUMBER(28,6);---
	n3           		 NUMBER(28,6);---
	n4           		 NUMBER(28,6);---
	n5           		 NUMBER(28,6);---
	n6           		 NUMBER(28,6);---
	n7          		 NUMBER(28,6);---
	n8         			 NUMBER(28,6);---
	n9           		 NUMBER(28,6);---
	n10          		 NUMBER(28,6);---
	n11          		 NUMBER(28,6);--- 
	n12          		 NUMBER(28,6);--- 
	n13          		 NUMBER(28,6);--- 
	n14          		 NUMBER(28,6);--- 
	n15          		 NUMBER(28,6);--- 
	n16          		 NUMBER(28,6);--- 
	n17          		 NUMBER(28,6);--- 
	n18          		 NUMBER(28,6);--- 
	n19          		 NUMBER(28,6);--- 
	n20          		 NUMBER(28,6);--- 
	n21          		 NUMBER(28,6);--- 
	n22          		 NUMBER(28,6);--- 
	n23          		 NUMBER(28,6);--- 
	n24          		 NUMBER(28,6);--- 
	n25          		 NUMBER(28,6);--- 
	n26          		 NUMBER(28,6);--- 
	n27          		 NUMBER(28,6);--- 
	n28		     		 NUMBER(28,6);--- 
	nINTHON2          	 NUMBER(28,6);---
	nCXAPOR2          	 NUMBER(28,6);---
	nPMABAS2          	 NUMBER(28,6);---
	nBONOF2           	 NUMBER(28,6);---
	nCARGOF2          	 NUMBER(28,6);---
	nAJUFON2          	 NUMBER(28,6);---
	nRETFON2          	 NUMBER(28,6);---
	nREVFON2          	 NUMBER(28,6);---
	nINTFON2          	 NUMBER(28,6);---
	nRETPAR2          	 NUMBER(28,6);---
	nAPOADI2          	 NUMBER(28,6);--- 
	nAPOINI2          	 NUMBER(28,6);--- 
	nREVAPO2          	 NUMBER(28,6);--- 
	nCOBPMA2          	 NUMBER(28,6);--- 
	nRETTOT2          	 NUMBER(28,6);--- 
	nTRAFON2          	 NUMBER(28,6);--- 
	nREVRET2          	 NUMBER(28,6);--- 
	nREVINT2          	 NUMBER(28,6);--- 
	nREVBOF2          	 NUMBER(28,6);--- 
	nPMACOM2          	 NUMBER(28,6);--- 
	nPMAREG2          	 NUMBER(28,6);--- 
	nCOSSEG2          	 NUMBER(28,6);--- 
	nCACOSE2          	 NUMBER(28,6);--- 
	nCOMFON2          	 NUMBER(28,6);---  
	nCodCia              FAI_FONDOS_DETALLE_POLIZA.CODCIA%type;
	nCodEmpresa          FAI_FONDOS_DETALLE_POLIZA.CodEmpresa%type;
	nIdetPol             FAI_FONDOS_DETALLE_POLIZA.IDETPOL%type;

	--correccion: normaliza filtros de LOV; NULL, % y textos como "% - TODOS" se consideran TODOS
	vIdTipoSegFiltro VARCHAR2(100) := CASE
		WHEN cIdTipoSeg IS NULL OR SUBSTR(TRIM(cIdTipoSeg),1,1) = '%' THEN '%'
		ELSE TRIM(cIdTipoSeg)
	END;
	vPlanCobFiltro VARCHAR2(100) := CASE
		WHEN cPlanCob IS NULL OR SUBSTR(TRIM(cPlanCob),1,1) = '%' THEN '%'
		ELSE TRIM(cPlanCob)
	END;
	vCodMonedaFiltro VARCHAR2(100) := CASE
		WHEN cCodMoneda IS NULL OR SUBSTR(TRIM(cCodMoneda),1,1) = '%' THEN '%'
		ELSE TRIM(cCodMoneda)
	END;

	CURSOR ENCABEZADOS IS
		SELECT CODCIA        
			  ,CODEMPRESA    
			  ,ORDEN         
			  ,CODCONCEPTO   
			  ,DESCRICONCEPTO
			  ,SIGNO	         
		FROM CONCEPTOS_REPORTE_FONDOS 
		ORDER BY ORDEN;

	CURSOR C1(nIdPolizas in VARCHAR, dFechaDesde in DATE, dFechaHasta in DATE) IS
		SELECT b.NumPolUnico, to_char(a.IDFONDO,'9999999999999999999') IDFONDO, a.IDPOLIZA ,a.CODASEGURADO  , a.tipofondo 
		      ,GT_FAI_TIPOS_DE_FONDOS.DESCRIPCION(a.CODCIA,a.CODEMPRESA, a.tipofondo) Nombre_Fondo
			  ,a.CODCIA ,a.CODEMPRESA ,to_char(a.IDPOLIZA,'9999999999999999999') cIDPOLIZA 
		   ,to_char(a.IDFONDO,'9999999999999999999') cIDFONDO , b.Cod_Moneda   Cod_Moneda,B.PRIMANETA_LOCAL
		   ,c.IdTipoSeg ,c.PlanCob, a.IDETPOL,a.stsfondo,TO_CHAR(a.FECEMISION,'DD/MM/YYYY') FECEMISION
		   ,TO_CHAR(b.FECINIVIG,'DD/MM/YYYY') FECINIVIG, TO_CHAR(b.FECFINVIG,'DD/MM/YYYY') FECFINVIG
		   ,OC_CLIENTES.NOMBRE_CLIENTE(b.Codcliente) Cliente,b.STSPOLIZA 
		FROM FAI_FONDOS_DETALLE_POLIZA a
		    ,Polizas                   b
			,Detalle_Poliza            c
		WHERE  a.IdPoliza  = decode(nvl(nIdPolizas,'%'),'%',a.idpoliza,nIdPolizas)
		AND   b.IdPoliza  = a.IdPoliza
		AND   c.idpoliza  = a.IdPoliza
		AND   c.idetpol   = 1  
	--correccion: % o NULL desactiva el filtro; un valor real filtra por igualdad
		AND (vCodMonedaFiltro = '%' OR b.Cod_Moneda = vCodMonedaFiltro)
		AND (vIdTipoSegFiltro = '%' OR c.IdTipoSeg  = vIdTipoSegFiltro)
		AND (vPlanCobFiltro   = '%' OR c.PlanCob    = vPlanCobFiltro)     
		GROUP BY b.NumPolUnico,a.IDFONDO, a.IDPOLIZA,a.CODASEGURADO 
		        ,a.tipofondo,a.CODCIA ,a.CODEMPRESA ,b.Cod_Moneda
				,B.PRIMANETA_LOCAL,c.IdTipoSeg ,c.PlanCob, a.IDETPOL
				,b.CodEmpresa,b.IDPOLIZA,a.stsfondo,a.FECEMISION 
				,b.FECINIVIG, b.FECFINVIG,b.Codcliente, b.STSPOLIZA        
		ORDER BY 2,1;
		
	CURSOR C2 (nIdPoliza in Number, nIdFondo in Number, cTipofondo in Varchar2 ) IS 
		SELECT DISTINCT(b.Codcptomov) Codcptomov, e. tipomov
					   ,OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPMOVFO', e.TipoMov) Desc_Tpo_Movimiento
					   ,f.orden, f.codconcepto,f.signo
		FROM FAI_CONCENTRADORA_FONDO b
			,FAI_MOVIMIENTOS_FONDOS  e
			,CONCEPTOS_REPORTE_FONDOS f
		WHERE b.IdPoliza     = nIdPoliza 
		AND b.IdFondo        = nIdFondo
		AND b.StsMovimiento  in ('ACTIVO', 'INFORM')
		AND e.codcia       = b.codcia
		AND e.codempresa   = b.codempresa
		AND e.tipofondo    = cTipofondo   
		AND e.CodCptoMov   = b.Codcptomov 
		AND e.StsMovFondo  = 'ACTIVO'
		AND f.codcia     = e.codcia
		AND f.codempresa = e.codempresa
		AND f.codconcepto = e.CodCptoMov
		ORDER BY b.codcptomov     ;  

	BEGIN
		SELECT CODUSR
		INTO cCodUser
		FROM SICAS_OC.EXTRACCION_DE_REPORTES
		WHERE IDEXTRACCION = nIdReporte;

   --correccion: elimina residuos de una generación anterior del mismo usuario
		OC_ARCHIVO.Eliminar_Archivo(cCodUser);

		nLinea := 1;
		cCadena  := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
				   ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
				   ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
				   ' <style id="libro">'||chr(10)||
				   '   <!--table'||chr(10)||
				   '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
				   '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
				   '        .texto'||chr(10)||
				   '          {mso-number-format:"\@";}'||chr(10)||
				   '        .numero'||chr(10)||
				   '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
				   '        .fecha'||chr(10)||
				   '          {mso-number-format:"dd\\-mmm\\-yyyy";}'||chr(10)||
				   '    -->'||chr(10)||
				   ' </style><div id="libro">'||chr(10);
		OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); --correccion: usar el usuario del reporte y no USER de la sesión

		nLinea := nLinea + 1;
		cCadena     := '<table border = 0><tr><th>' || oc_empresas.nombre_compania(1) || '</th></tr>'; 
		OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); --correccion: usar el usuario del reporte y no USER de la sesión

		nLinea := nLinea + 1;

		cCadena     := '<tr><th> REPORTE DE FONDOS POR PÓLIZA DEL '||dFecDesde||' AL '||dFecHasta|| '</th></tr>'; 
		OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); --correccion: usar el usuario del reporte y no USER de la sesión

		nLinea := nLinea + 1;
		cCadena     := '<tr><th>  </th></tr></table>'; 
		OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); --correccion: usar el usuario del reporte y no USER de la sesión

		nLinea := nLinea + 1;

		cCadena    :=  '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Póliza Única                </font></th>' ||		            
											'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Póliza Consecutiva          </font></th>' ||		            
											'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estatus de la Póliza        </font></th>' ||
											'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de Emision de la Póliza</font></th>' ||
											'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de Inicio de Vigencia </font></th>' ||
											'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de Fin de Vigencia    </font></th>' ||
											'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo de Seguro              </font></th>' ||
											'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estatus Fondo               </font></th>' ||
											'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Cliente                     </font></th>' || 
											'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF"> Edad Cliente                </font></th>' ||                                        
											'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Número de Fondo de Inversión</font></th>' ||			                                   		            
											'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre del Fondo            </font></th>' ||
											'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo de Moneda              </font></th>' ||
											'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Saldo Inicial              </font></th>' ||
											'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Prima Basica               </font></th>' ; 


		FOR W IN ENCABEZADOS LOOP 
			nItera := nItera + 1;
		    cCadena2 := cCadena2||'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">' || W.CODCONCEPTO||' - '||W.DESCRICONCEPTO || ' </font></th>';

		END LOOP;                           

			cCadena3 := cCadena3||'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Saldo Final                     </font></th>' ; 

			  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); --correccion: usar el usuario del reporte y no USER de la sesión
			  OC_ARCHIVO.Escribir_Linea(cCadena2, cCodUser, nLinea); --correccion: usar el mismo identificador temporal
			  OC_ARCHIVO.Escribir_Linea(cCadena3, cCodUser, nLinea); --correccion: usar el mismo identificador temporal

		FOR X IN C1( nIdPoliza,dFecDesde, dFecHasta) LOOP      
			BEGIN
				SELECT        NVL(SUM(F.MontoMovMoneda),0)
				INTO        cMTOAPORTEINILOCAL
				FROM FAI_CONCENTRADORA_FONDO F
				WHERE F.CodCia                = x.CODCIA
				AND F.CodEmpresa            = x.CODEMPRESA
				AND F.IdPoliza              = x.IDPOLIZA
				AND F.IDetPol               = x.IDETPOL
				AND F.Idfondo               = x.IDFONDO
				AND F.CodAsegurado          = x.CODASEGURADO
				AND TRUNC(F.FECMOVIMIENTO)  < dFecDesde
				AND F.STSMOVIMIENTO         = 'ACTIVO';
			END;


			BEGIN
			    SELECT 	  NVL(SUM(F.MontoMovMoneda),0)
			    INTO 	  cSaldoFinal
				FROM FAI_CONCENTRADORA_FONDO F
			    WHERE F.CodCia                = x.CODCIA
  			    AND F.CodEmpresa            = x.CODEMPRESA
			    AND F.IdPoliza              = x.IDPOLIZA
			    AND F.IDetPol               = x.IDETPOL
			    AND F.Idfondo               = x.IDFONDO
			    AND F.CodAsegurado          = x.CODASEGURADO
			    AND TRUNC(F.FECMOVIMIENTO) <= dFecHasta
			    AND F.STSMOVIMIENTO         = 'ACTIVO';
			END; 

		SELECT FecNacimiento 
		INTO dFecNacimiento
        FROM PERSONA_NATURAL_JURIDICA
        WHERE (TIPO_DOC_IDENTIFICACION	 ,NUM_DOC_IDENTIFICACION) IN (SELECT TIPO_DOC_IDENTIFICACION
																			,NUM_DOC_IDENTIFICACION 
																	  FROM Clientes 
																	  WHERE CodCliente in (SELECT CodCliente 
																						   FROM Polizas 
																						   WHERE iDpOLIZA  =  x.IDPOLIZA));



		SELECT trunc(months_between(sysdate, dFecNacimiento)/12) 
		INTO nEdadCliente 
		FROM dual ; 
		
		IF X.tipofondo = 'VFLEXBASE' THEN
			BEGIN
				SELECT  to_char(SUM(MONTO_DET_MONEDA),'99999999999990.00') 
				INTO cPRIMABAS 
		        FROM DETALLE_FACTURAS
		        WHERE IdFactura IN (SELECT IdFactura
		                            FROM FACTURAS
		                            WHERE IdPoliza = x.IDPOLIZA)
		        AND CodCpto in  ('PRIBAS','PRIADI');
			EXCEPTION  WHEN OTHERS THEN
				cPRIMABAS := '0.00';
			END ; 
			ELSE
				cPRIMABAS := '0.00';
		END IF;	
      --------------------------------------------------------------------------------------------------------------------------------------------------      
      n1 := 0; n2 := 0; n3 := 0; n4 := 0; n5 := 0; n6 := 0; n7 := 0; n8 := 0; n9 := 0; n10:= 0; n11:= 0; n12:= 0; n13:= 0; 
      n14:= 0; n15:= 0; n16:= 0; n17:= 0; n18:= 0; n19:= 0; n20:= 0; n21:= 0; n22:= 0; n23:= 0; n24:= 0; n25:= 0; n26:= 0; 
      n27:= 0; n28:= 0;
      ---------------------------------------------------------------------------------------------------------------------------------------------------
		FOR i IN C2 (x.IDPOLIZA, X.cIDFONDO , X.tipofondo) LOOP

			IF i.Orden = 1  THEN n1 := n1 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 2  THEN n2 := n2 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF;  
			IF i.Orden = 3  THEN n3 := n3 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 4  THEN n4 := n4 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 5  THEN n5 := n5 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 6  THEN n6 := n6 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 7  THEN n7 := n7 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 8  THEN n8 := n8 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 9  THEN n9 := n9 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 10 THEN n10 := n10 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 11 THEN n11 := n11 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 12 THEN n12 := n12 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 13 THEN n13 := n13 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 14 THEN n14 := n14 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 15 THEN n15 := n15 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 16 THEN n16 := n16 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 17 THEN n17 := n17 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 18 THEN n18 := n18 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 19 THEN n19 := n19 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 20 THEN n20 := n20 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 21 THEN n21 := n21 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 22 THEN n22 := n22 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 23 THEN n23 := n23 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 24 THEN n24 := n24 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 25 THEN n25 := n25 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 26 THEN n26 := n26 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF; 
			IF i.Orden = 27 THEN n27 := n27 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF;
			IF i.Orden = 28 THEN n28 := n28 +  NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0);  END IF;              
		END LOOP;


		BEGIN
			SELECT to_char(SUM(MONTOMOVMONEDA),'99999999999990.00')  
			INTO cMONTOMOVMONEDA      
			FROM FAI_CONCENTRADORA_FONDO
			WHERE IdPoliza  = x.IDPOLIZA;
		EXCEPTION  WHEN OTHERS THEN
			cMONTOMOVMONEDA := '0.00';
		END;	
			cDesc_Fondo := GT_FAI_TIPOS_DE_FONDOS.DESCRIPCION(x.CODCIA,x.CODEMPRESA, x.tipofondo) ;

		cCadena := '<tr>' || cCampoFormatC||X.NumPolUnico    ||cLimitador||      
                           cCampoFormatC||X.cIDPOLIZA        ||cLimitador|| 
                           cCampoFormatC||X.STSPOLIZA        ||cLimitador|| 
                           cCampoFormatC||X.FECEMISION       ||cLimitador|| 
                           cCampoFormatC||X.FECINIVIG        ||cLimitador|| 
                           cCampoFormatC||X.FECFINVIG        ||cLimitador|| 
                           cCampoFormatC||X.IdTipoSeg        ||cLimitador||                                              
                           cCampoFormatC||X.stsfondo         ||cLimitador||                                
						   cCampoFormatC||X.Cliente          ||cLimitador||
		     		       cCampoFormatC||nEdadCliente       ||cLimitador||
						   cCampoFormatC||X.cIDFONDO         ||cLimitador||
						   cCampoFormatC||X.Nombre_Fondo     ||cLimitador||
						   cCampoFormatC||X.Cod_Moneda       ||cLimitador||			                     
						   cCampoFormatN||cMTOAPORTEINILOCAL ||cLimitador||	
						   cCampoFormatN||cPRIMABAS          ||cLimitador||
                           cCampoFormatN||n1    ||cLimitador||
                           cCampoFormatN||n2    ||cLimitador||
                           cCampoFormatN||n3    ||cLimitador|| 
                           cCampoFormatN||n4    ||cLimitador|| 
                           cCampoFormatN||n5    ||cLimitador|| 
                           cCampoFormatN||n6    ||cLimitador|| 
                           cCampoFormatN||n7    ||cLimitador|| 
                           cCampoFormatN||n8    ||cLimitador|| 
                           cCampoFormatN||n9    ||cLimitador|| 
                           cCampoFormatN||n10   ||cLimitador||
                           cCampoFormatN||n11   ||cLimitador||
                           cCampoFormatN||n12   ||cLimitador||
                           cCampoFormatN||n13   ||cLimitador||
                           cCampoFormatN||n14   ||cLimitador||
                           cCampoFormatN||n15   ||cLimitador||
                           cCampoFormatN||n16   ||cLimitador||
                           cCampoFormatN||n17   ||cLimitador||
                           cCampoFormatN||n18   ||cLimitador||
                           cCampoFormatN||n19   ||cLimitador||
                           cCampoFormatN||n20   ||cLimitador||
                           cCampoFormatN||n21   ||cLimitador||
                           cCampoFormatN||n22   ||cLimitador||
                           cCampoFormatN||n23   ||cLimitador||
                           cCampoFormatN||n24   ||cLimitador||
                           cCampoFormatN||n25   ||cLimitador||
                           cCampoFormatN||n26   ||cLimitador||
                           cCampoFormatN||n27   ||cLimitador||
                           cCampoFormatN||n28   ||cLimitador||
                           cCampoFormatN||cSaldoFinal ||cLimitador;	----Saldo Final                                                        

			nLinea := nLinea + 1;
			OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); --correccion: usar el usuario del reporte y no USER de la sesión

	END LOOP;
	
	IF cFormato = 'EXCEL' THEN
		OC_ARCHIVO.Escribir_Linea('</table></div></html>', cCodUser, 9999); --correccion: cerrar el archivo con el mismo usuario
		cCadena := '</table></div></html>';  	      
	END IF;
		OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
   --correccion: TEMP_GEN_ARCHIVO se genera y consulta con el mismo cCodUser;
   --             la limpieza previa evita múltiples filas residuales y el ORA-01427
		UPDATE SICAS_OC.EXTRACCION_DE_REPORTES B
		SET (B.REPORTE, B.FECREPORTE, B.STATUS) = (SELECT A.DATA
														 ,SYSDATE
														 ,'GEN'
												   FROM SICAS_OC.TEMP_GEN_ARCHIVO A
												   WHERE A.CODUSER = cCodUser)
		WHERE B.IDEXTRACCION = nIdReporte;

   --correccion: elimina el temporal una vez almacenado el reporte definitivo
		OC_ARCHIVO.Eliminar_Archivo(cCodUser);
		/*  
		DELETE SICAS_OC.EXTRACCION_DE_REPORTES 
		WHERE 1 = 1
		AND CODUSR = cCodUser
		AND TIPO_REPORTE IN ('REP_FONDOPOL')
		AND IDEXTRACCION <= nIdReporte
		;
			OC_ARCHIVO.Eliminar_Archivo(cCodUser);    
        */
	EXCEPTION 
		WHEN OTHERS THEN 
			OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
			RAISE_APPLICATION_ERROR(-20101,'Error en Generación de Fondos por Póliza: '||SQLERRM); 
	END REP_FONDO_POL;

-- FONDO POR POLIZA A DETALLE
	PROCEDURE REP_FONDO_POL_DET (cNomArchivo 	VARCHAR2
								,cIdTipoSeg 	VARCHAR2
								,cPlanCob 		VARCHAR2
								,cCodMoneda  	VARCHAR2
								,nIdPoliza  	VARCHAR2
								,dFecDesde  	DATE
								,dFecHasta  	DATE
								,cFormato     	VARCHAR2
								,nIdReporte   	NUMBER) IS                                                                     

	cLimitador           VARCHAR2(20) :='</td>';
	nLinea               NUMBER;
	cCadena              VARCHAR2(4200);
	cCadena2             VARCHAR2(4200);
	cCadena3             VARCHAR2(4200);
	cCadenaCOb           VARCHAR2(4200); 
	cCodUser             VARCHAR2(30);
	nDummy               NUMBER;
	cCopy                BOOLEAN;
	cCampoFormatC      	 VARCHAR2(4000):= '<td class=texto>';
	cCampoFormatN     	 VARCHAR2(4000):= '<td class=numero>';
	cCampoFormatD     	 VARCHAR2(4000):= '<td class=fecha>';
	nItera            	 NUMBER:= 0;
	CuantasCoberts    	 NUMBER:= 0;  
	cMTOAPORTEINILOCAL   NUMBER(28,6); 
	cSaldoFinal          NUMBER(28,6);
	cDesc_Fondo        	 VARCHAR2(200); 					  
	cMONTOMOVMONEDA      FAI_CONCENTRADORA_FONDO.MONTOMOVMONEDA%type; 
	Error                VARCHAR2(200);
	nRETISR		         NUMBER(28,2);
	nRETISR2             NUMBER(28,2);
	cPRIMABAS            NUMBER(28,2);
	COBPRIMAS          	 NUMBER(28,2);
	APORPRIMAS         	 NUMBER(28,2);
	n1           		 NUMBER(28,6);
	n2          		 NUMBER(28,6);
	n3          		 NUMBER(28,6);
	n4          		 NUMBER(28,6);
	n5          		 NUMBER(28,6);
	n6          		 NUMBER(28,6);
	n7          		 NUMBER(28,6);---
	n8          		 NUMBER(28,6);---
	n9          		 NUMBER(28,6);---
	n10         		 NUMBER(28,6);---
	n11         		 NUMBER(28,6);--- 
	n12         		 NUMBER(28,6);--- 
	n13         		 NUMBER(28,6);--- 
	n14         		 NUMBER(28,6);--- 
	n15         		 NUMBER(28,6);--- 
	n16         		 NUMBER(28,6);--- 
	n17         		 NUMBER(28,6);--- 
	n18         		 NUMBER(28,6);--- 
	n19         		 NUMBER(28,6);--- 
	n20         		 NUMBER(28,6);--- 
	n21         		 NUMBER(28,6);--- 
	n22         		 NUMBER(28,6);--- 
	n23         		 NUMBER(28,6);--- 
	n24         		 NUMBER(28,6);--- 
	n25         		 NUMBER(28,6);--- 
	n26         		 NUMBER(28,6);--- 
	n27         		 NUMBER(28,6);---
	n28         		 NUMBER(28,6);---  
	XNombre_Fondo  		 VARCHAR2(200);
	XCod_Moneda   		 VARCHAR2(20);
	nINTHON2         	 NUMBER(28,6);---
	nCXAPOR2         	 NUMBER(28,6);---
	nPMABAS2         	 NUMBER(28,6);---
	nBONOF2          	 NUMBER(28,6);---
	nCARGOF2         	 NUMBER(28,6);---
	nAJUFON2         	 NUMBER(28,6);---
	nRETFON2         	 NUMBER(28,6);---
	nREVFON2         	 NUMBER(28,6);---
	nINTFON2         	 NUMBER(28,6);---
	nRETPAR2         	 NUMBER(28,6);---
	nAPOADI2         	 NUMBER(28,6);--- 
	nAPOINI2         	 NUMBER(28,6);--- 
	nREVAPO2         	 NUMBER(28,6);--- 
	nCOBPMA2         	 NUMBER(28,6);--- 
	nRETTOT2         	 NUMBER(28,6);--- 
	nTRAFON2         	 NUMBER(28,6);--- 
	nREVRET2         	 NUMBER(28,6);--- 
	nREVINT2         	 NUMBER(28,6);--- 
	nREVBOF2         	 NUMBER(28,6);--- 
	nPMACOM2         	 NUMBER(28,6);--- 
	nPMAREG2         	 NUMBER(28,6);--- 
	nCOSSEG2         	 NUMBER(28,6);--- 
	nCACOSE2         	 NUMBER(28,6);--- 
	nCOMFON2         	 NUMBER(28,6);---  
	nCodCia            	 FAI_FONDOS_DETALLE_POLIZA.CODCIA%type;
	nCodEmpresa        	 FAI_FONDOS_DETALLE_POLIZA.CodEmpresa%type;
	nIdetPol           	 FAI_FONDOS_DETALLE_POLIZA.IDETPOL%type;

	--correccion: normaliza filtros de LOV; NULL, % y textos como "% - TODOS" se consideran TODOS
	vIdTipoSegFiltro VARCHAR2(100) := CASE
		WHEN cIdTipoSeg IS NULL OR SUBSTR(TRIM(cIdTipoSeg),1,1) = '%' THEN '%'
		ELSE TRIM(cIdTipoSeg)
	END;
	vPlanCobFiltro VARCHAR2(100) := CASE
		WHEN cPlanCob IS NULL OR SUBSTR(TRIM(cPlanCob),1,1) = '%' THEN '%'
		ELSE TRIM(cPlanCob)
	END;
	vCodMonedaFiltro VARCHAR2(100) := CASE
		WHEN cCodMoneda IS NULL OR SUBSTR(TRIM(cCodMoneda),1,1) = '%' THEN '%'
		ELSE TRIM(cCodMoneda)
	END;

	CURSOR ENCABEZADOS IS
		SELECT CODCIA
			  ,CODEMPRESA    
			  ,ORDEN         
			  ,CODCONCEPTO   
			  ,DESCRICONCEPTO
			  ,SIGNO	         
		FROM CONCEPTOS_REPORTE_FONDOS 
		ORDER BY ORDEN;

	CURSOR PRIMARIO IS
		SELECT UNIQUE(tipofondo )tipofondo 
		FROM FAI_FONDOS_DETALLE_POLIZA; 

	CURSOR C1(nIdPolizas in VARCHAR, dFechaDesde in VARCHAR, dFechaHasta in VARCHAR, nTipofondo in VARCHAR) IS
		SELECT  b.NumPolUnico, to_char(a.IDFONDO,'9999999999999999999') IDFONDO, a.IDPOLIZA ,a.CODASEGURADO  
			   ,a.tipofondo ,GT_FAI_TIPOS_DE_FONDOS.DESCRIPCION(a.CODCIA,a.CODEMPRESA, a.tipofondo) Nombre_Fondo
			   ,a.CODCIA ,a.CODEMPRESA ,to_char(a.IDPOLIZA,'9999999999999999999') cIDPOLIZA 
			   ,to_char(a.IDFONDO,'9999999999999999999') cIDFONDO ,b.Cod_Moneda Cod_Moneda,B.PRIMANETA_LOCAL
			   ,c.IdTipoSeg ,c.PlanCob, a.IDETPOL    
		FROM  FAI_FONDOS_DETALLE_POLIZA a
			 ,Polizas                   b
			 ,Detalle_Poliza            c
		WHERE a.IdPoliza  = decode(nvl(nIdPolizas,'%'),'%',a.idpoliza,nIdPolizas)
		AND   a.Tipofondo = nTipofondo
		AND   b.IdPoliza  = a.IdPoliza
		AND   c.idpoliza  = a.IdPoliza
		AND   c.idetpol   = 1  
	--correccion: % o NULL desactiva el filtro; un valor real filtra por igualdad
		AND (vCodMonedaFiltro = '%' OR b.Cod_Moneda = vCodMonedaFiltro)
		AND (vIdTipoSegFiltro = '%' OR c.IdTipoSeg  = vIdTipoSegFiltro)
		AND (vPlanCobFiltro   = '%' OR c.PlanCob    = vPlanCobFiltro)     
		GROUP BY b.NumPolUnico, a.IDFONDO, a.IDPOLIZA
				,a.CODASEGURADO , a.tipofondo,a.CODCIA 
				,a.CODEMPRESA ,b.Cod_Moneda,B.PRIMANETA_LOCAL
				,c.IdTipoSeg ,c.PlanCob, a.IDETPOL
				,b.CodEmpresa,b.IDPOLIZA       
		ORDER BY 2,1;

	CURSOR C2 (nIdPoliza in Number, nIdFondo in Number, cTipofondo in Varchar2 ) IS 
		SELECT DISTINCT(b.Codcptomov) Codcptomov
					   ,e. tipomov
					   ,OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPMOVFO', e.TipoMov)  Desc_Tpo_Movimiento
					   ,f.orden
					   ,f.codconcepto
					   ,f.signo
		FROM FAI_CONCENTRADORA_FONDO b
			,FAI_MOVIMIENTOS_FONDOS  e
			,CONCEPTOS_REPORTE_FONDOS f
		WHERE b.IdPoliza     = nIdPoliza 
		AND b.IdFondo        = nIdFondo
		AND b.StsMovimiento  in ('ACTIVO', 'INFORM') 
		AND e.codcia       = b.codcia
		AND e.codempresa   = b.codempresa
		AND e.tipofondo    = cTipofondo  
		AND e.CodCptoMov   = b.Codcptomov 
		AND e.StsMovFondo  = 'ACTIVO'
		AND f.codcia     = e.codcia
		AND f.codempresa = e.codempresa
		AND f.codconcepto = e.CodCptoMov
		ORDER BY b.codcptomov;  

	BEGIN	
		SELECT CODUSR
		INTO cCodUser
		FROM SICAS_OC.EXTRACCION_DE_REPORTES
		WHERE IDEXTRACCION = nIdReporte;

	--correccion: elimina residuos de una generación anterior del mismo usuario
		OC_ARCHIVO.Eliminar_Archivo(cCodUser);

		nLinea := 1;
		cCadena  := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
				   ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
				   ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
				   ' <style id="libro">'||chr(10)||
				   '   <!--table'||chr(10)||
				   '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
				   '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
				   '        .texto'||chr(10)||
				   '          {mso-number-format:"\@";}'||chr(10)||
				   '        .numero'||chr(10)||
				   '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
				   '        .fecha'||chr(10)||
				   '          {mso-number-format:"dd\\-mmm\\-yyyy";}'||chr(10)||
				   '    -->'||chr(10)||
				   ' </style><div id="libro">'||chr(10);
		OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); --correccion: usar el usuario del reporte y no USER de la sesión

		nLinea := nLinea + 1;
		cCadena     := '<table border = 0><tr><th>' || oc_empresas.nombre_compania(1) || '</th></tr>'; 
		OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); --correccion: usar el usuario del reporte y no USER de la sesión

		nLinea := nLinea + 1;

		cCadena     := '<tr><th>  REPORTE DE FONDOS DEL '||dFecDesde||' AL '||dFecHasta || '</th></tr>'; 
		OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); --correccion: usar el usuario del reporte y no USER de la sesión

		nLinea := nLinea + 1;
		cCadena     := '<tr><th>  </th></tr></table>'; 
		OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); --correccion: usar el usuario del reporte y no USER de la sesión

		nLinea := nLinea + 1;
		cCadena    := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre del Fondo            </font></th>' ||
												  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo de Moneda              </font></th>' ||
												  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Saldo Inicial              </font></th>' ||
												  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Prima Basica               </font></th>' ; 


					   FOR W IN ENCABEZADOS LOOP 
						 nItera := nItera + 1;

							cCadena2 := cCadena2||'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">' || W.CODCONCEPTO||' - '||W.DESCRICONCEPTO ||  ' </font></th>';

						 END LOOP;                           

							cCadena3 := cCadena3||'<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Saldo Final                     </font></th>' ; 

		OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); --correccion: usar el usuario del reporte y no USER de la sesión
		OC_ARCHIVO.Escribir_Linea(cCadena2, cCodUser, nLinea); --correccion: usar el mismo identificador temporal
		OC_ARCHIVO.Escribir_Linea(cCadena3, cCodUser, nLinea); --correccion: usar el mismo identificador temporal

	FOR  PR IN PRIMARIO LOOP
  	          --------------------------------------------------------------------------------------------------------------------------------------------------      
				      n1 := 0; n2 := 0; n3 := 0; n4 := 0; n5 := 0; n6 := 0; n7 := 0; n8 := 0; n9 := 0; n10:= 0; n11:= 0; n12:= 0; n13:= 0; n14:= 0; n15:= 0; n16:= 0;
				      n17:= 0; n18:= 0; n19:= 0; n20:= 0; n21:= 0; n22:= 0; n23:= 0; n24:= 0; n25:= 0; n26:= 0; n27:= 0; n28:= 0;
				      cMTOAPORTEINILOCAL := 0; 
				      cSaldoFinal        := 0; 
				      cPRIMABAS          := 0;
			  ---------------------------------------------------------------------------------------------------------------------------------------------------
	FOR X IN C1( nIdPoliza,dFecDesde, dFecHasta, PR. TipoFondo) LOOP      

		BEGIN
			SELECT NVL(SUM(F.MontoMovMoneda),0) + cMTOAPORTEINILOCAL
			INTO cMTOAPORTEINILOCAL
			FROM FAI_CONCENTRADORA_FONDO F
			WHERE F.CodCia                = x.CODCIA
			AND F.CodEmpresa            = x.CODEMPRESA
			AND F.IdPoliza              = x.IDPOLIZA
			AND F.IDetPol               = x.IDETPOL
			AND F.Idfondo               = x.IDFONDO
			AND TRUNC(F.FECMOVIMIENTO)  < dFecDesde
			AND F.STSMOVIMIENTO         = 'ACTIVO';
		END;

		BEGIN
			SELECT 	  NVL(SUM(F.MontoMovMoneda),0) + cSaldoFinal
			INTO 	  cSaldoFinal
			FROM FAI_CONCENTRADORA_FONDO F
			WHERE F.CodCia                = x.CODCIA
			AND F.CodEmpresa            = x.CODEMPRESA
			AND F.IdPoliza              = x.IDPOLIZA
			AND F.IDetPol               = x.IDETPOL
			AND F.Idfondo               = x.IDFONDO
			AND TRUNC(F.FECMOVIMIENTO) <= dFecHasta
			AND F.STSMOVIMIENTO         = 'ACTIVO';
		END;    

	IF X.tipofondo = 'VFLEXBASE' THEN
		BEGIN
			SELECT  to_char(SUM(MONTO_DET_MONEDA),'99999999999990.00') + cPRIMABAS  
			INTO cPRIMABAS 
			FROM DETALLE_FACTURAS
			WHERE IdFactura IN (SELECT IdFactura
								FROM FACTURAS
								WHERE IdPoliza = x.IDPOLIZA)
			AND CodCpto IN ('PRIBAS','PRIADI');
		EXCEPTION  WHEN OTHERS THEN
			cPRIMABAS := '0.00';
		END ; 
	ELSE
		cPRIMABAS := '0.00';
	END IF;	

	FOR i IN C2 (x.IDPOLIZA, X.cIDFONDO , X.tipofondo) LOOP				      	
		XNombre_Fondo := 	X.Nombre_Fondo;
		XCod_Moneda  :=   X.Cod_Moneda;
		IF i.Orden = 1  THEN n1  := n1  + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 2  THEN n2  := n2  + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF;  
		IF i.Orden = 3  THEN n3  := n3  + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 4  THEN n4  := n4  + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 5  THEN n5  := n5  + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 6  THEN n6  := n6  + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 7  THEN n7  := n7  + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 8  THEN n8  := n8  + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 9  THEN n9  := n9  + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 10 THEN n10 := n10 + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 11 THEN n11 := n11 + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 12 THEN n12 := n12 + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 13 THEN n13 := n13 + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 14 THEN n14 := n14 + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 15 THEN n15 := n15 + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 16 THEN n16 := n16 + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 17 THEN n17 := n17 + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 18 THEN n18 := n18 + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 19 THEN n19 := n19 + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 20 THEN n20 := n20 + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 21 THEN n21 := n21 + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 22 THEN n22 := n22 + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 23 THEN n23 := n23 + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 24 THEN n24 := n24 + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 25 THEN n25 := n25 + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 26 THEN n26 := n26 + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF; 
		IF i.Orden = 27 THEN n27 := n27 + NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF;
		IF i.Orden = 28 THEN n28 := NVL(TH_T_EDOCTAFONDOS.TOTAL_POR_CPTO_MOVIMIENTO(x.CODCIA ,x.CODEMPRESA , x.IDPOLIZA, x.IDetPol,X.cIDFONDO,x.CODASEGURADO, i.codconcepto,x.tipofondo,dFecDesde,dFecHasta),0); END IF;              
	END LOOP;

		BEGIN
			SELECT to_char(SUM(MONTOMOVMONEDA),'99999999999990.00')  
			INTO cMONTOMOVMONEDA      
			FROM FAI_CONCENTRADORA_FONDO
			WHERE IdPoliza  = x.IDPOLIZA;
		EXCEPTION  WHEN OTHERS THEN
			cMONTOMOVMONEDA := '0.00';
		END;	
			cDesc_Fondo := GT_FAI_TIPOS_DE_FONDOS.DESCRIPCION(x.CODCIA,x.CODEMPRESA, x.tipofondo) ;
	END LOOP;      
				      cCadena := '<tr>' || cCampoFormatC||XNombre_Fondo     ||cLimitador||
							 cCampoFormatC||XCod_Moneda       ||cLimitador||			                     
							   cCampoFormatN||cMTOAPORTEINILOCAL ||cLimitador||										         							         
							  cCampoFormatN||cPRIMABAS          ||cLimitador||	                          
				                           cCampoFormatN||n1    ||cLimitador||
				                           cCampoFormatN||n2    ||cLimitador||
				                           cCampoFormatN||n3    ||cLimitador|| 
				                           cCampoFormatN||n4    ||cLimitador|| 
				                           cCampoFormatN||n5    ||cLimitador|| 
				                           cCampoFormatN||n6    ||cLimitador|| 
				                           cCampoFormatN||n7    ||cLimitador|| 
				                           cCampoFormatN||n8    ||cLimitador|| 
				                           cCampoFormatN||n9    ||cLimitador|| 
				                           cCampoFormatN||n10   ||cLimitador||
				                           cCampoFormatN||n11   ||cLimitador||
				                           cCampoFormatN||n12   ||cLimitador||
				                           cCampoFormatN||n13   ||cLimitador||
				                           cCampoFormatN||n14   ||cLimitador||
				                           cCampoFormatN||n15   ||cLimitador||
				                           cCampoFormatN||n16   ||cLimitador||
				                           cCampoFormatN||n17   ||cLimitador||
				                           cCampoFormatN||n18   ||cLimitador||
				                           cCampoFormatN||n19   ||cLimitador||
				                           cCampoFormatN||n20   ||cLimitador||
				                           cCampoFormatN||n21   ||cLimitador||
				                           cCampoFormatN||n22   ||cLimitador||
				                           cCampoFormatN||n23   ||cLimitador||
				                           cCampoFormatN||n24   ||cLimitador||
				                           cCampoFormatN||n25   ||cLimitador||
				                           cCampoFormatN||n26   ||cLimitador||
				                           cCampoFormatN||n27   ||cLimitador||
				                           cCampoFormatN||n28   ||cLimitador||
				                           cCampoFormatN||cSaldoFinal ||cLimitador;	

				      nLinea := nLinea + 1;
				      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); --correccion: usar el usuario del reporte y no USER de la sesión

	END LOOP;      
	IF cFormato = 'EXCEL' THEN
      OC_ARCHIVO.Escribir_Linea('</table></div></html>', cCodUser, 9999); --correccion: cerrar el archivo con el mismo usuario
      cCadena := '</table></div></html>';
	END IF;
		OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
   --correccion: TEMP_GEN_ARCHIVO se genera y consulta con el mismo cCodUser;
   --             la limpieza previa evita múltiples filas residuales y el ORA-01427
	UPDATE SICAS_OC.EXTRACCION_DE_REPORTES B
    SET (B.REPORTE, B.FECREPORTE, B.STATUS) = (SELECT A.DATA
													 ,SYSDATE
													 ,'GEN'
                                               FROM SICAS_OC.TEMP_GEN_ARCHIVO A
                                               WHERE A.CODUSER = cCodUser)
    WHERE B.IDEXTRACCION = nIdReporte;

   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
/*
    DELETE SICAS_OC.EXTRACCION_DE_REPORTES 
    WHERE 1 = 1
    AND CODUSR = cCodUser
    AND TIPO_REPORTE IN ('REP_POLDET')
    AND IDEXTRACCION <= nIdReporte
    ;
        OC_ARCHIVO.Eliminar_Archivo(cCodUser);
*/                 
	EXCEPTION 
	   WHEN OTHERS THEN 
		  OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
			RAISE_APPLICATION_ERROR(-20102,'Error en Generación de Fondos por Póliza a Detalle: '||SQLERRM); 
	END REP_FONDO_POL_DET;

END OC_REPORTES_FONDO_INVERSION;
/
GRANT EXECUTE ON SICAS_OC.OC_REPORTES_FONDO_INVERSION TO PUBLIC;
/
CREATE OR REPLACE PUBLIC SYNONYM OC_REPORTES_FONDO_INVERSION FOR SICAS_OC.OC_REPORTES_FONDO_INVERSION;
/