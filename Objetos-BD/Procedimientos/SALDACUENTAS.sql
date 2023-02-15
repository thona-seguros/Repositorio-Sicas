PROCEDURE saldacuentas (vAgente IN NUMBER, vFecIni IN DATE , vFecFin IN DATE ) IS
--DECLARE
        CURSOR x IS 
        SELECT cd_cia           Cia      ,
               cd_agente        Agente   ,
               cd_tipo_ramo     Ramo     ,
               fe_ini_saldo   IniSaldo , 
               fe_fin_saldo   FinSaldo ,
               fe_proc_saldo    ProSaldo ,
               cd_moneda        Moneda   ,
               mt_saldo_inicial SaldoIni ,
               mt_com_tot       Comtot   ,
               mt_iva_tot       IVATot   , 
               mt_ivaret_tot    IVARetTot,
               mt_isr_tot       ISRTot   ,
               mt_isrret_tot    ISRRetTot,
               mt_subtotal_tot  Subtot   ,
               mt_encontra_tot  EnConTot ,
               mt_afavor_tot    AfaVorTot,
               mt_saldo_final   SaldoFin 
          FROM saldos_comisiones 
         where cd_agente = vAgente
           and fe_ini_saldo between vFecIni 
                                and vFecFin
          ORDER BY fe_ini_saldo;
        
        y x%ROWTYPE;
        
        FUNCTION DimeSaldoAnterior (vCia    IN saldos_comisiones_diarios.cd_cia%TYPE      , 
                                    vAgente IN saldos_comisiones_diarios.cd_agente%TYPE   ,
                                    vFecFin IN VARCHAR2                                   ,
                                    vRamo   IN saldos_comisiones_diarios.cd_tipo_ramo%TYPE) RETURN NUMBER IS 
                 xSaldoAnt saldos_comisiones_diarios.mt_saldo_final%TYPE := 0;                                    
                 vFechaBusca DATE;
        BEGIN
             xSaldoAnt := 0;
             vFechaBusca := TO_DATE(vFecfin,'DD/MM/YYYY')-1;
              DBMS_OUTPUT.PUT_LINE('Entro con: ' ||vCia||' '||vAgente ||' '||vRamo ||' '||vFecFin||' ' ||xSaldoAnt||vFechaBusca);
              --Entro con: 1 157 010 02/01/2016
             SELECT NVL(b.mt_saldo_final,0) vSaldoAnt
               INTO xSaldoAnt
               FROM saldos_comisiones_diarios b
              WHERE b.cd_cia       = vCia
                AND b.cd_agente    = vAgente 
                AND b.cd_tipo_ramo = vRamo         
                and TO_CHAR(b.fe_saldo,'dd/mm/yyyy')  = TO_CHAR(vFechaBusca,'dd/mm/yyyy'); 
--                and b.fe_saldo     = TO_DATE(vFecfin,'DD/MM/YYYY')-1 
                                   /*(SELECT MAX(b1.fe_saldo)  
                                        FROM saldos_comisiones_diarios b1
                                       WHERE b1.cd_cia       = B.cd_cia
                                         AND b1.cd_agente    = B.cd_agente                 
                                         AND b1.cd_tipo_ramo = B.cd_tipo_ramo 
                                         AND to_char(b1.fe_saldo,'dd/mm/yyyy')     = to_char(vFecfin-1,'dd/mm/yyyy'));*/
              DBMS_OUTPUT.PUT_LINE('Salgo con: ' ||vCia||' '||vAgente ||' '||vRamo ||' '||vFecFin||' ('||xSaldoAnt||')');
              RETURN xSaldoAnt;
              
      EXCEPTION 
             WHEN no_data_found THEN 
                  DBMS_OUTPUT.PUT_LINE('NDF: '||SQLERRM);
                  RETURN 0;
             WHEN others THEN 
                  DBMS_OUTPUT.PUT_LINE('OTHERS: '||SQLERRM);             
                  RETURN 0;
        END DimeSaldoAnterior;

        PROCEDURE MeteDiario (vTipo     IN NUMBER                                        ,
                              vCia      IN saldos_comisiones_detalle.cd_cia%TYPE         , 
                              vAgente   IN saldos_comisiones_detalle.cd_agente%TYPE      ,
                              vFecIni   IN saldos_comisiones.fe_ini_saldo%TYPE           ,
                              vFecFin   IN saldos_comisiones.fe_fin_saldo%TYPE           ,
                              vRamo     IN saldos_comisiones.cd_tipo_ramo%TYPE           ) IS 

                  vSaldoIniMes saldos_comisiones_diarios.mt_saldo_inicial%TYPE :=  0; 
                  vSaldoFinMes saldos_comisiones_diarios.mt_saldo_final%TYPE   :=  0;                  
        BEGIN
                  vSaldoIniMes := 0;
                  vSaldoFinMes := 0;                  
                  DBMS_OUTPUT.PUT_LINE('Entro a MeteDiario con: '|| vCia||','|| vAgente||','||vFecIni||','|| vFecFin||','||vRamo||')');
                  DBMS_OUTPUT.PUT_LINE(' ');
                  DBMS_OUTPUT.PUT_LINE(' ');                  
                  vSaldoIniMes := DimeSaldoAnterior (vCia,vAgente ,TO_CHAR(vFecFin,'DD/MM/YYYY'), vRamo);
                  vSaldoFinMes := vSaldoIniMes;          
                  DBMS_OUTPUT.PUT_LINE('vSaldoIniMes: '||vSaldoIniMes||' vSaldoFinMes: '||vSaldoFinMes||' vFecFin: '||vFecFin);                      
                  DBMS_OUTPUT.PUT_LINE(' ');
                  DBMS_OUTPUT.PUT_LINE(' ');                                    
                  IF vTipo = 2 THEN 
                       UPDATE saldos_comisiones_diarios
                          SET mt_saldo_inicial = vSaldoIniMes,
                              mt_saldo_final   = vSaldoFinMes
                        WHERE cd_cia       = vCia 
                          AND cd_agente    = vAgente 
                          AND cd_tipo_ramo = vRamo 
                          AND fe_saldo     = vFecFin;

                       UPDATE saldos_comisiones x  
                          SET mt_saldo_inicial = vSaldoIniMes,
                              mt_saldo_final   = vSaldoFinMes
                        WHERE cd_cia       = vCia 
                          AND cd_agente    = vAgente 
                          AND cd_tipo_ramo = vRamo 
                          AND x.fe_ini_saldo = vFecFin;                          
                      vSaldoIniMes := 0;
                      vSaldoFinMes := 0;                          
                  ELSE 
                        INSERT INTO saldos_comisiones_diarios
                               (cd_cia          , cd_agente      , cd_tipo_ramo , fe_saldo      , fe_proc_saldo , cd_moneda    ,
                                mt_saldo_inicial, mt_com_tot     , mt_iva_tot   , mt_ivaret_tot , mt_isr_tot    , mt_isrret_tot,
                                mt_subtotal_tot , mt_encontra_tot, mt_afavor_tot, mt_saldo_final, ds_observacion)
                        VALUES (vCiA, vAgente, vRamo, vFecIni, vFecFin, 'PS',vSaldoIniMes,0,0,0,0,0,0,0,0,0,'Saldo incial Diario'  );
                 END IF;
        --
        EXCEPTION 
             WHEN dup_val_on_index THEN 
                  UPDATE saldos_comisiones_diarios
                     SET fe_saldo     = vFecfin
                   WHERE cd_cia       = vCia  
                     AND cd_agente    = vAgente 
                     AND cd_tipo_ramo = vRamo  
                     AND fe_saldo     = vFecIni;
        END MeteDiario; 

        PROCEDURE MeteMes(vCia    IN saldos_comisiones_detalle.cd_cia%TYPE   , 
                          vAgente IN saldos_comisiones_detalle.cd_agente%TYPE,
                          vFecIni IN saldos_comisiones.fe_ini_saldo%TYPE     ,
                          vFecFin IN saldos_comisiones.fe_fin_saldo%TYPE     ,
                          vRamo   IN saldos_comisiones.cd_tipo_ramo%TYPE     ) IS
        BEGIN
                  INSERT INTO saldos_comisiones 
                         (cd_cia        , cd_agente     , cd_tipo_ramo , fe_ini_saldo, fe_fin_saldo , fe_proc_saldo  , cd_moneda      , mt_saldo_inicial,
                          mt_com_tot    , mt_iva_tot    , mt_ivaret_tot, mt_isr_tot  , mt_isrret_tot, mt_subtotal_tot, mt_encontra_tot, mt_afavor_tot   ,
                          mt_saldo_final, ds_observacion)
                  VALUES (vCiA, vAgente, vRamo, vFecIni, vFecFin, vFecFin, 'PS',0,0,0,0,0,0,0,0,0,0,'Saldo incial Mensual'  );
        --
        EXCEPTION 
             WHEN dup_val_on_index THEN 
                  UPDATE saldos_comisiones
                     SET fe_fin_saldo = vFecfin
                   WHERE cd_cia       = vCia  
                     AND cd_agente    = vAgente 
                     AND cd_tipo_ramo = vRamo 
                     AND fe_ini_saldo = vFecIni;
        END;

      PROCEDURE CreaSaldosIniciales (vCia      IN saldos_comisiones_detalle.cd_cia%TYPE   , 
                                     vAgente   IN saldos_comisiones_detalle.cd_agente%TYPE,
                                     vFecIni   IN saldos_comisiones.fe_ini_saldo%TYPE     ,
                                     vFecFin   IN saldos_comisiones.fe_fin_saldo%TYPE     ,
                                     vRamo     IN saldos_comisiones.cd_tipo_ramo%TYPE     ,
                                     vSaldoIni IN saldos_comisiones.mt_saldo_inicial%TYPE ,
                                     vSaldofin IN saldos_comisiones.mt_saldo_final%TYPE   ) IS 
      BEGIN 
        --MeteDiario(vCia, vAgente, vFecIni, vFecFin, '010'); 
        --MeteDiario(vCia, vAgente, vFecIni, vFecFin, '030');        
        --MeteMes   (vCia, vAgente, vFecIni, vFecFin, '010'); 
        --MeteMes   (vCia, vAgente, vFecIni, vFecFin, '030');        
        --
        DBMS_OUTPUT.PUT_LINE('MeteDiario(2, '|| vCia||','|| vAgente||','||vfecIni||','||vFecFin||','||vRamo||')');
                  DBMS_OUTPUT.PUT_LINE(' ');
                  DBMS_OUTPUT.PUT_LINE(' ');                          
        MeteDiario(2,vCia, vAgente, vFecIni, vFecFin, vRamo); 
--        MeteMes   (2,vCia, vAgente, vFecIni, vFecFin, '010'); 
--        MeteMes   (2,vCia, vAgente, vFecIni, vFecFin, '030');
        --
        --COMMIT;
     END CreaSaldosIniciales;

 
BEGIN
     OPEN x;
     LOOP 
        FETCH x INTO y;
         EXIT WHEN x%NOTFOUND;
              DBMS_OUTPUT.PUT_LINE('creaSaldosIniciales '|| y.Cia||','|| y.Agente||','||y.IniSaldo||','|| y.FinSaldo||','||y.Ramo||','|| y.SaldoIni||','|| y.SaldoFin||')');
              DBMS_OUTPUT.PUT_LINE(' ');                                
              CreaSaldosIniciales( y.Cia, y.Agente,y.IniSaldo, y.FinSaldo, y.Ramo, y.SaldoIni, y.SaldoFin);
     END LOOP;
     CLOSE x;
     
END saldacuentas;

 
 
