PROCEDURE DESMARCAR_REGISTROS_SAT  IS

  nLeidos                     NUMBER := 0;
  nErroneos                   NUMBER := 0;
  cObservacion 		      varchar2(500);
  --
  CURSOR DESVIRTUADO_SENTENCIAFAV IS

	SELECT CODCIA, ID_RFC, NOM_CONTRIB, SIT_CONTRIB, OFI_CONTRIB_DESVIRTUADOS, OFI_SENTECIA_FAV,ESTATUS_REGISTRO
	FROM PROVEEDORES_SAT_SENTENCIAFAV 
	UNION
	SELECT CODCIA, ID_RFC, NOM_CONTRIB, SIT_CONTRIB, OFI_CONTRIB_DESVIRTUADOS, OFI_SENTECIA_FAV,ESTATUS_REGISTRO
	FROM PROVEEDORES_SAT_DESVIRTUADOS
	ORDER BY ID_RFC;

  BEGIN

      
    FOR X IN DESVIRTUADO_SENTENCIAFAV LOOP

	  UPDATE PROVEEDORES_SAT_DEFINITIVOS
             SET ESTATUS_REGISTRO = 'APRO'
	  WHERE ID_RFC = X.ID_RFC;

	  IF sql%rowcount > 0 THEN
	     COMMIT;
	     cObservacion := 'Oficio de Sentencia favorable '|| X.OFI_SENTECIA_FAV;
	     TH_BIT_DESBLOQUEOS_SAT.INSERTA(X.CODCIA ,
		  X.ID_RFC ,		
		  X.NOM_CONTRIB ,		
		  X.SIT_CONTRIB ,		
		  X.ESTATUS_REGISTRO ,	
		  'SICAS_OC' ,
		  SYSDATE ,
		  cObservacion 
                 );
	  END IF;

	  UPDATE PROVEEDORES_SAT_PRESUNTOS
             SET ESTATUS_REGISTRO = 'APRO'
	  WHERE ID_RFC = X.ID_RFC;

	  IF sql%rowcount > 0 THEN
	     COMMIT;
	     cObservacion := 'Oficio de Contribuyentes Desvirtuados '|| X.OFI_CONTRIB_DESVIRTUADOS;
	     TH_BIT_DESBLOQUEOS_SAT.INSERTA(X.CODCIA ,
		  X.ID_RFC ,		
		  X.NOM_CONTRIB ,		
		  X.SIT_CONTRIB ,		
		  X.ESTATUS_REGISTRO ,	
		  'SICAS_OC' ,
		  SYSDATE ,
		  cObservacion 
                 );
	     COMMIT;
	  END IF;

    END LOOP;
     --
--    dbms_output.put_line('Leidos: '||nLeidos );    

  EXCEPTION
    WHEN OTHERS THEN
  dbms_output.put_line('Error: '||SQLERRM);  
END DESMARCAR_REGISTROS_SAT;
