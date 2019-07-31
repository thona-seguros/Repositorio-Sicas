--
-- OC_DETALLE_COMISION  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   DETALLE_COMISION (Table)
--   AGENTES (Table)
--   COMISIONES (Table)
--   CONCEPTO_COMISION (Table)
--   CATALOGO_DE_CONCEPTOS (Table)
--   RAMO_CONCEPTO_COMISION (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_DETALLE_COMISION IS 
PROCEDURE INSERTA_DETALLE_COMISION(cCodCia VARCHAR2, nIdPoliza Number, nIdComision Number,
                                   cOrigen VARCHAR2,cIdTipoSeg VARCHAR2) ;
END;
/

--
-- OC_DETALLE_COMISION  (Package Body) 
--
--  Dependencies: 
--   OC_DETALLE_COMISION (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_DETALLE_COMISION IS
PROCEDURE INSERTA_DETALLE_COMISION(cCodCia VARCHAR2, nIdPoliza Number, nIdComision Number,
                                   cOrigen VARCHAR2, cIdTipoSeg VARCHAR2) IS
nExiste                 NUMBER(2);
nMonto_Mon_Local        COMISIONES.Comision_Local%TYPE;
nMonto_Mon_Extranjera   COMISIONES.Comision_Moneda%TYPE;

CURSOR  Oc_Detalle_Com IS
   SELECT CO.CodCia CodCia, CO.IdComision IdComision, CC.CodConcepto CodConcepto, CO.IdFactura, CO.IdNcr,
          DECODE(CDC.Signo_Concepto,'+',((CO.Comision_Local*CC.PorcCpto)/100)*1,((CO.Comision_Local*CC.PorcCpto)/100)*-1) Monto_Mon_Local,
          DECODE(CDC.Signo_Concepto,'+',((CO.Comision_Moneda*CC.PorcCpto)/100)*1,((CO.Comision_Moneda*CC.PorcCpto)/100)*-1) Monto_Mon_Extranjera
     FROM COMISIONES CO, AGENTES AG, CONCEPTO_COMISION CC,
          RAMO_CONCEPTO_COMISION RMC, CATALOGO_DE_CONCEPTOS CDC
    WHERE CO.CodCia      = AG.CodCia
      AND CO.Cod_Agente  = AG.Cod_Agente
      AND AG.CodCia      = CC.CodCia
      AND AG.CodTipo     = CC.CodTipo
      AND CC.CodCia      = RMC.CodCia
      AND CC.CodTipo     = RMC.CodTipo
      AND CC.CODCONCEPTO = RMC.CODCONCEPTO
      AND CC.ORIGEN      = RMC.ORIGEN
      AND CC.CodCia      = CDC.CodCia 
      AND CC.CodConcepto = CDC.CodConcepto
      AND CC.Origen      = cOrigen
      AND RMC.IdTipoSeg  = cIdTipoSeg
      AND CO.CodCia      = cCodCia 
      AND CO.IdPoliza    = nIdPoliza
      AND CO.IdComision  = nIdComision;
BEGIN
   BEGIN
      SELECT 1
        INTO nExiste
        FROM DETALLE_COMISION
       WHERE CodCia     = cCodCia
         AND IdComision = nIdComision;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nExiste:= 0;
      WHEN TOO_MANY_ROWS THEN
         nExiste:= 1;
   END;

   IF nExiste = 0 THEN
      FOR I IN Oc_Detalle_Com LOOP
         nMonto_Mon_Local      := I.Monto_Mon_Local;
         nMonto_Mon_Extranjera := I.Monto_Mon_Extranjera;
         BEGIN
            INSERT INTO DETALLE_COMISION
                  (CodCia, IdComision, CodConcepto, Monto_Mon_Local, 
                   Monto_Mon_Extranjera, Estado, Origen)
            VALUES(I.CodCia, I.IdComision, I.CodConcepto, nMonto_Mon_Local,
                   nMonto_Mon_Extranjera, 'ACT', cOrigen);
         EXCEPTION
            WHEN OTHERS THEN 
               RAISE_APPLICATION_ERROR(-20100, 'Error'||i.CodCia||'-'||i.IdComision||'-'||i.CodConcepto||'-'|| cOrigen ||sqlerrm);
         END;
      END LOOP; 
   ELSE
      RAISE_APPLICATION_ERROR(-20100, 'Intenta Crear de Forma Automática un Nuevo Detalle de Comisión, pero ya Existen Registros');
   END IF;
END INSERTA_DETALLE_COMISION;

end oc_detalle_comision;
/
