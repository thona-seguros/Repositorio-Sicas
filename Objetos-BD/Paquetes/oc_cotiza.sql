--
-- OC_COTIZA  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_OUTPUT (Synonym)
--   DBMS_STANDARD (Package)
--   POLIZAS (Table)
--   CONFIG_COMISIONES (Table)
--   CT_COTIZACION_AUTO (Table)
--   CT_DET_COT_AUTO (Table)
--   DATOS_PARTICULARES_VEHICULO (Table)
--   PARAMETROS_EMISION (Table)
--   PARAMETROS_ENUM_POL (Table)
--   COBERT_ACT (Table)
--   TASAS_CAMBIO (Table)
--   OC_GENERALES (Package)
--   DETALLE_POLIZA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_COTIZA IS

FUNCTION F_GET_NUMPOL ( p_msg_regreso    out  nocopy varchar2 ) RETURN NUMBER; --SEQ 25/07/2016

PROCEDURE INSERTA_POLIZA (nCodCia NUMBER ,nCodEmpresa NUMBER,cCodCliente VARCHAR2,nIdCotizacion NUMBER,cCodAseg VARCHAR2);


END;
/

--
-- OC_COTIZA  (Package Body) 
--
--  Dependencies: 
--   OC_COTIZA (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_COTIZA IS
  ----------------------------------------------------------------------
      --- Funcion para buscar el proximo numero de poliza 25/07/2016  ---      
 ----------------------------------------------------------------------
 FUNCTION F_GET_NUMPOL ( p_msg_regreso    out  nocopy varchar2 ) RETURN NUMBER AS
     
      vNumPoliza      parametros_enum_pol.paen_cont_fin%type;
      vNombreTabla    varchar2(30);
      vIdProducto     number(6); 
      
   
   BEGIN
    -- Buscar el nombre de la tabla de la cual se obtendra por la descripcion y la bandera
      select pa.pame_ds_numerador,
             pa.paem_id_producto 
        into vNombreTabla,
             vIdProducto
        from PARAMETROS_EMISION pa
       where pa.paem_cd_producto   = 1
         and pa.paem_des_producto  = 'POLIZA'
         and pa.paem_flag          =  1;

    -- Obtener el numero de poliza correspondiente
   
     select pp.paen_cont_fin
       into vNumPoliza
       from PARAMETROS_ENUM_POL pp
      where pp.paen_id_pol =vIdProducto
      FOR UPDATE OF pp.paen_cont_fin;

 --  Actualizar al siguiente numero
      update PARAMETROS_ENUM_POL pe
         set pe.paen_cont_fin = vNumPoliza +1
       where pe.paen_id_pol =vIdProducto; 
      
-- POR SI HAY QUE REGRESAR

        /* SELECT NVL(MAX(IdPoliza),0)+1
           INTO vNumPoliza
           FROM POLIZAS
          WHERE CODCIA = nCodCia;*/
          /**  Cambio de A Sequencia XDS 25/07/2016**/
          
           
    -- Hacer permanentes los cambios para evitar bloqueo de la tabla
     --  commit;
   

     return vNumPoliza;
 EXCEPTION
      when no_data_found then
         p_msg_regreso := '.:: No se ha dado de alta '|| vNombreTabla ||' en PARAMETROS_EMISION ::.'||sqlerrm;
         dbms_output.put_line(p_msg_regreso);
         rollback;
        return 0;
      when others then
         p_msg_regreso := '.:: Error en "OC_COTIZA.F_GET_NUMPOL" .:: -> '||sqlerrm;
         dbms_output.put_line(p_msg_regreso);
         rollback;
         return 0;
 END F_GET_NUMPOL;
  
  PROCEDURE INSERTA_POLIZA (nCodCia NUMBER ,nCodEmpresa NUMBER,cCodCliente VARCHAR2,nIdCotizacion NUMBER,cCodAseg VARCHAR2) IS
   dFecCotizacion   CT_COTIZACION_AUTO.FecCotizacion%TYPE;
   cCod_Moneda      CT_COTIZACION_AUTO.Cod_Moneda%TYPE;
   cIdTipoSeg       CT_COTIZACION_AUTO.IdTipoSeg%TYPE;
   cCodPlanPago     CT_COTIZACION_AUTO.CodPlanPago%TYPE;
   cPlanCob         CT_COTIZACION_AUTO.PlanCob%TYPE;
   nPrecio_Local    CT_COTIZACION_AUTO.Precio_Actual_Local%TYPE;
   nPrecio_Moneda   CT_COTIZACION_AUTO.Precio_Actual_Mon%TYPE;
   nIdPoliza        POLIZAS.IdPoliza%TYPE;
   nTasa_Cambio     TASAS_CAMBIO.Tasa_Cambio%TYPE;
   cMarca           CT_COTIZACION_AUTO.Marca%TYPE;
   cLinea           CT_COTIZACION_AUTO.Linea%TYPE;
   cCod_Modelo      CT_COTIZACION_AUTO.Cod_Modelo%TYPE;
   cAnio            CT_COTIZACION_AUTO.Anio%TYPE;
   cOcupantes       CT_COTIZACION_AUTO.Ocupantes%TYPE;
   nSumaL           CT_COTIZACION_AUTO.Precio_Actual_Local%TYPE := 0;
   nSumaM           CT_COTIZACION_AUTO.Precio_Actual_Local%TYPE := 0;
   nPrimaL          CT_COTIZACION_AUTO.Precio_Actual_Local%TYPE := 0;
   nPrimaM          CT_COTIZACION_AUTO.Precio_Actual_Local%TYPE := 0;
   nPorcComis       CONFIG_COMISIONES.PorcComision%TYPE;
   p_msg_regreso varchar2(50);----var XDS    
   
 


   CURSOR C_COBERTURA IS
      SELECT CodCobertura,SumaAsegLocl,SumaAsegMon,PrimaLocal,Primamoneda
        FROM CT_DET_COT_AUTO
       WHERE IdCotizacion  = nIdCotizacion
         AND CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa;
   BEGIN
        BEGIN
        /* SELECT NVL(MAX(IdPoliza),0)+1
           INTO nIdPoliza
           FROM POLIZAS
          WHERE CODCIA = nCodCia;*/
          /**  Cambio de A Sequencia XDS 25/07/2016**/
          nIdPoliza := F_GET_NUMPOL(p_msg_regreso);
          

      END;
      BEGIN
         SELECT FecCotizacion,Cod_Moneda,IdTipoSeg,CodPlanPago,PlanCob,Precio_Actual_Local,Precio_Actual_Mon,Marca,Linea,Cod_Modelo,Anio,Ocupantes
           INTO dFecCotizacion,cCod_Moneda,cIdTipoSeg,cCodPlanPago,cPlanCob,nPrecio_Local,nPrecio_Moneda,cMarca,cLinea,cCod_Modelo,cAnio,cOcupantes
           FROM CT_COTIZACION_AUTO
          WHERE IdCotizacion  = nIdCotizacion
            AND CodCia        = nCodCia
            AND CodEmpresa    = nCodEmpresa;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR (-20100,'No Existe un Cotizacion '||nIdCotizacion);
      END;
      nTasa_Cambio := OC_GENERALES.TASA_DE_CAMBIO(cCod_Moneda,dFecCotizacion);
      BEGIN
         SELECT porccomision
           INTO nporccomis
           FROM CONFIG_COMISIONES
          WHERE CodEmpresa = nCodEmpresa
            AND IdTipoSeg  = cIdTipoSeg
            AND CodCia     = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
           RAISE_APPLICATION_ERROR (-20100,'Revisar Configuracion de Comisiones para el tipo seguro'||cIdTipoSeg);
      END;
      BEGIN
         INSERT INTO POLIZAS (CodCia,CodEmpresa,CodCliente,TipoPol,FecIniVig,FecFinVig,FecSts,CodPlanPago, IdPoliza,Num_Cotizacion,StsPoliza,FecRenovacion,Cod_Moneda,SumaAseg_Local,SumaAseg_Moneda,FecSolicitud,FecEmision)
                      VALUES (nCodCia,nCodEmpresa,cCodCliente,'P',dFecCotizacion,TRUNC(ADD_MONTHS(dFecCotizacion,12)),SYSDATE,cCodPlanPago, nIdPoliza,nIdCotizacion,'SOL',TRUNC(ADD_MONTHS(dFecCotizacion,12)),cCod_Moneda,nPrecio_Local,nPrecio_Moneda,TRUNC(SYSDATE),TRUNC(SYSDATE)  );
      EXCEPTION
         WHEN OTHERS  THEN
        RAISE_APPLICATION_ERROR (-20100,'Error en Poliza '||SQLERRM);
      END;
      BEGIN
         INSERT INTO DETALLE_POLIZA (CodCia,CodEmpresa,IdPoliza,IdetPol,Cod_Asegurado,CodPlanPago,Suma_Aseg_Local,Suma_Aseg_Moneda,FecIniVig,FecFinVig,IdTipoSeg,Tasa_Cambio,PlanCob,StsDetalle,PorcComis)
              VALUES (nCodCia,nCodEmpresa,nIdPoliza,1,cCodAseg,cCodPlanPago,nPrecio_Local,nPrecio_Moneda,dFecCotizacion,TRUNC(ADD_MONTHS(dFecCotizacion,12)),cIdTipoSeg,nTasa_Cambio,cPlanCob,'SOL',nporccomis);
      EXCEPTION
         WHEN OTHERS  THEN
           RAISE_APPLICATION_ERROR (-20100,'Error en Detalle Poliza '||SQLERRM);
      END;
      BEGIN
         FOR I IN C_COBERTURA LOOP
            nSumaL  := nSumaL  + NVL(I.SumaAsegLocl,0);
            nSumaM  := nSumaM  + NVL(I.SumaAsegMon,0);
            nPrimaL := nPrimaL + NVL(I.PrimaLocal,0);
            nPrimaM := nPrimaM + NVL(I.PrimaMoneda,0);
            INSERT INTO COBERT_ACT(CodCia,CodEmpresa,IdPoliza,IdetPol,IdTipoSeg,TipoRef,CodCobert,SumaAseg_Local,SumaAseg_Moneda,Prima_Moneda,Prima_Local,PlanCob,Cod_Moneda,StsCobertura,NumRef,IdEndoso,Deducible_Local,Deducible_Moneda)
                           VALUES (nCodCia,nCodEmpresa,nIdPoliza,1,cIdTipoSeg,'POLI',I.CodCobertura,I.SumaAsegLocl,I.SumaAsegMon,I.PrimaMoneda,I.PrimaLocal,cPlanCob,cCod_Moneda,'SOL',nIdPoliza,0,0,0);
         END LOOP;
      EXCEPTION
         WHEN OTHERS  THEN
           RAISE_APPLICATION_ERROR (-20100,'Error en Coberturas Poliza '||SQLERRM);
      END;
      BEGIN
         INSERT INTO DATOS_PARTICULARES_VEHICULO (IdetPol,Num_Vehi,IdPoliza,CodCia,Cod_Marca,Cod_Version,Cod_Modelo,Cantidad_Pasajeros,SumaAseg_Local,SumaAseg_Moneda,PrimaNeta_Local,PrimaNeta_Moneda,Anio_Vehiculo)
                                          VALUES (1,1,nIdPoliza,nCodCia,cMarca,cLinea,cCod_Modelo,cOcupantes,nPrecio_Local,nPrecio_Moneda,nPrimaL,nPrimaM,cAnio);
      END;
      BEGIN
         UPDATE CT_COTIZACION_AUTO
            SET IdPoliza      = nIdPoliza,
                Estado        = 'EMI'
          WHERE IdCotizacion  = nIdCotizacion
            AND CodCia        = nCodCia
            AND CodEmpresa    = nCodEmpresa;
      END;
      BEGIN
         UPDATE POLIZAS
            SET SumaAseg_Local   = nSumaL,
                SumaAseg_Moneda  = nSumaM,
                PrimaNeta_Local  = nPrimaL,
                PrimaNeta_Moneda = nPrimaM
          WHERE IdPoliza   = nIdPoliza
            AND CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa;
      END;
      BEGIN
         UPDATE DETALLE_POLIZA
            SET Suma_Aseg_Local  = nSumaL ,
                Suma_Aseg_Moneda = nSumaM,
                Prima_Local      = nPrimaL,
                Prima_Moneda     = nPrimaM
          WHERE IdPoliza   = nIdPoliza
            AND CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa;
      END;
   END INSERTA_POLIZA;


END;
/

--
-- OC_COTIZA  (Synonym) 
--
--  Dependencies: 
--   OC_COTIZA (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_COTIZA FOR SICAS_OC.OC_COTIZA
/


GRANT EXECUTE ON SICAS_OC.OC_COTIZA TO PUBLIC
/
