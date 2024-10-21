
---**** INSERT DE COMBINACION DE TEXTOS PARA RIESGOS A CUBRIR

INSERT INTO COMBINACION_RIESGOCUBIERTO
                (CodCia, CodEmpresa, Tipo_Negocio, Laboral_Riesg, Dia24365_Riesg, Traslado_Riesg, TextoElegibilidad, TextoRiesgoCubierto)
         VALUES (1, 1, 'LABORAL', 'S', 'N', 'N','EMPLEADOS ACTIVOS DEL CONTRATANTE, QUE NO SE ENCUENTRE EN PROCESO DE INCAPACIDAD O ESTADO DE INVALIDEZ AL INICIO DE VIGENCIA DE LA PÓLIZA Y APAREZCAN EN EL LISTADO DE ASEGURADOS.' ,'Se cubre a los empleados de los accidentes que puedan sufrir durante su jornada laboral. No se cubren trayectos de ningún tipo');
/

INSERT INTO COMBINACION_RIESGOCUBIERTO
                (CodCia, CodEmpresa, Tipo_Negocio, Laboral_Riesg, Dia24365_Riesg, Traslado_Riesg, TextoElegibilidad, TextoRiesgoCubierto)
         VALUES (1, 1, 'LABORAL', 'S', 'N', 'S','EMPLEADOS ACTIVOS DEL CONTRATANTE, QUE NO SE ENCUENTRE EN PROCESO DE INCAPACIDAD O ESTADO DE INVALIDEZ AL INICIO DE VIGENCIA DE LA PÓLIZA Y APAREZCAN EN EL LISTADO DE ASEGURADOS.' ,'Se cubre a los empleados de los accidentes que puedan sufrir durante su jornada laboral. Se cubren los traslados interrumpidos de casa al lugar de trabajo y viceversa');
		 
/

INSERT INTO COMBINACION_RIESGOCUBIERTO
                (CodCia, CodEmpresa, Tipo_Negocio, Laboral_Riesg, Dia24365_Riesg, Traslado_Riesg, TextoElegibilidad, TextoRiesgoCubierto)
         VALUES (1, 1, 'LABORAL', 'N', 'S', 'S', 'EMPLEADOS ACTIVOS DEL CONTRATANTE, QUE NO SE ENCUENTRE EN PROCESO DE INCAPACIDAD O ESTADO DE INVALIDEZ AL INICIO DE VIGENCIA DE LA PÓLIZA Y APAREZCAN EN EL LISTADO DE ASEGURADOS.','Se cubre a los empleados de los accidentes que puedan sufrir, la cobertura opera las 24 horas los 365 días del año');
		 
/

INSERT INTO COMBINACION_RIESGOCUBIERTO
                (CodCia, CodEmpresa, Tipo_Negocio, Laboral_Riesg, Dia24365_Riesg, Traslado_Riesg, TextoElegibilidad, TextoRiesgoCubierto)
         VALUES (1, 1, 'DEPORTES', 'N', 'N', 'N', 'DEPORTISTAS AMATEUR, QUE NO SE ENCUENTRE EN PROCESO DE INCAPACIDAD O ESTADO DE INVALIDEZ AL INICIO DE VIGENCIA DE LA PÓLIZA Y APAREZCAN EN EL LISTADO DE ASEGURADOS.','Se cubre a los deportistas amateur de los accidentes que puedan sufrir durante sus entrenamientos, practicas, eventos, competencias y torneos. No se cubren trayectos de ningún tipo');
/

INSERT INTO COMBINACION_RIESGOCUBIERTO
                (CodCia, CodEmpresa, Tipo_Negocio, Laboral_Riesg, Dia24365_Riesg, Traslado_Riesg, TextoElegibilidad, TextoRiesgoCubierto)
         VALUES (1, 1, 'DEPORTES', 'N', 'N', 'S', 'DEPORTISTAS AMATEUR, QUE NO SE ENCUENTRE EN PROCESO DE INCAPACIDAD O ESTADO DE INVALIDEZ AL INICIO DE VIGENCIA DE LA PÓLIZA Y APAREZCAN EN EL LISTADO DE ASEGURADOS.' ,'Se cubre a los deportistas amateur de los accidentes que puedan sufrir durante sus entrenamientos, practicas, eventos, competencias y torneos. Así mismo se cubren los traslados ininterrumpidos de la casa a la sede de los entrenamientos, practicas, eventos, competencias, torneos y viceversa.');
/

COMMIT;