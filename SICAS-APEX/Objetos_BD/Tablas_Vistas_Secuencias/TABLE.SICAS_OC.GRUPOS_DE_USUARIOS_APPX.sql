--JIBARRA_04-ENE-2023 <ARCHIVO DE CONTROL DE CREACION DE LA TABLA SICAS_OC.GRUPOS_DE_USUARIOS_APPX PARA EL REQUERIMIENTO DE CONTROL DE ACCESOS EN APEX, NUEVO SISTEMA DE SICAS>
--##SE ELIMINAN EL SINONIMO Y LA TABLA
DROP PUBLIC SYNONYM GRUPOS_DE_USUARIOS_APPX;

DROP TABLE SICAS_OC.GRUPOS_DE_USUARIOS_APPX CASCADE CONSTRAINTS;

/
--##SE CREA LA TABLA SICAS_OC.GRUPOS_DE_USUARIOS_APPX
CREATE TABLE SICAS_OC.GRUPOS_DE_USUARIOS_APPX(CODCIA         	NUMBER          NOT NULL        --CODIGO DE COMPANIA
										,CODGRUPO       	VARCHAR2(20)    NOT NULL        --CODIGO DE GRUPO QUE ORGANIZA A LOS USUARIOS
										,DESCRIPCION      	VARCHAR2(100)   NOT NULL        --DESCRIPCION DEL CODIGO DE GRUPO
										,FLAG_ACCESO   		VARCHAR2(2)     NOT NULL     	--BANDERA QUE INDICA SI EL GRUPO TIENE ACCESO A LA APLCIACION DE SICAS [S (SI), N (NO)]
										,FLAG_SOLO_LECTURA	VARCHAR2(2)     NOT NULL     	--BANDERA QUE INDICA SI EL GRUPO TIENE ACCESO A LA APLCIACION DE SICAS SOLO COMO SONSULTA [S (SI), N (NO)]
										,FLAG_ACTIVO   		VARCHAR2(2)     NOT NULL     	--BANDERA QUE INDICA SI EL GRUPO ESTA ACTIVO [S (SI), N (NO)]
										,FECHA_BAJA			DATE							--FECHA EN LA QUE SE INDICA LA BAJA DEL GRUPO
										,USUARIO_ALTA		VARCHAR2(50)	NOT NULL	    --CAMPO DE CONTROL/AUDITORIA, USUARIO QUE CREA EL REGISTRO
										,FECHA_ALTA			DATE			NOT NULL	    --CAMPO DE CONTROL/AUDITORIA, FECHA EN QUE SE CREA EL REGISTRO
										,USUARIO_MOD		VARCHAR2(50)	NOT NULL	    --CAMPO DE CONTROL/AUDITORIA, USUARIO QUE MODIFICA EL REGISTRO
										,FECHA_MOD			DATE			NOT NULL	    --CAMPO DE CONTROL/AUDITORIA, FECHA EN QUE SE MODIFICA EL REGISTRO
										)TABLESPACE TS_SICASOC;

/
--##SE CREA INDICE UNICO PARA LA TABLA
CREATE UNIQUE INDEX SICAS_OC.GRUPOS_DE_USUARIOS_APPX_IDX1 ON SICAS_OC.GRUPOS_DE_USUARIOS_APPX (CODCIA, CODGRUPO) TABLESPACE IDX_SICASOC;

--##ALTER TABLE DE PRIMARY KEY AND FOREIGN KEY
ALTER TABLE SICAS_OC.GRUPOS_DE_USUARIOS_APPX ADD CONSTRAINT PK_GRUPOS_DE_USUARIOS_APPX PRIMARY KEY (CODCIA, CODGRUPO) USING INDEX;

--##COMENTARIOS DESCRIPTIVOS DE LAS COLUMNAS
COMMENT ON COLUMN SICAS_OC.GRUPOS_DE_USUARIOS_APPX.CODCIA 				IS 'CODIGO DE COMPANIA';
COMMENT ON COLUMN SICAS_OC.GRUPOS_DE_USUARIOS_APPX.CODGRUPO 			IS 'CODIGO DE GRUPO QUE ORGANIZA A LOS USUARIOS';
COMMENT ON COLUMN SICAS_OC.GRUPOS_DE_USUARIOS_APPX.DESCRIPCION 			IS 'DESCRIPCION DEL CODIGO DE GRUPO';
COMMENT ON COLUMN SICAS_OC.GRUPOS_DE_USUARIOS_APPX.FLAG_ACCESO 			IS 'BANDERA QUE INDICA SI EL GRUPO TIENE ACCESO A LA APLCIACION DE SICAS [S (SI), N (NO)]';
COMMENT ON COLUMN SICAS_OC.GRUPOS_DE_USUARIOS_APPX.FLAG_SOLO_LECTURA	IS 'BANDERA QUE INDICA SI EL GRUPO TIENE ACCESO A LA APLCIACION DE SICAS SOLO COMO SONSULTA [S (SI), N (NO)]';
COMMENT ON COLUMN SICAS_OC.GRUPOS_DE_USUARIOS_APPX.FLAG_ACTIVO 			IS 'BANDERA QUE INDICA SI EL GRUPO ESTA ACTIVO [S (SI), N (NO)]';
COMMENT ON COLUMN SICAS_OC.GRUPOS_DE_USUARIOS_APPX.FECHA_BAJA 			IS 'FECHA EN LA QUE SE INDICA LA BAJA DEL GRUPO';
COMMENT ON COLUMN SICAS_OC.GRUPOS_DE_USUARIOS_APPX.USUARIO_ALTA 		IS 'CAMPO DE CONTROL/AUDITORIA, USUARIO QUE CREA EL REGISTRO';
COMMENT ON COLUMN SICAS_OC.GRUPOS_DE_USUARIOS_APPX.FECHA_ALTA 			IS 'CAMPO DE CONTROL/AUDITORIA, FECHA EN QUE SE CREA EL REGISTRO';
COMMENT ON COLUMN SICAS_OC.GRUPOS_DE_USUARIOS_APPX.USUARIO_MOD 			IS 'CAMPO DE CONTROL/AUDITORIA, USUARIO QUE MODIFICA EL REGISTRO';
COMMENT ON COLUMN SICAS_OC.GRUPOS_DE_USUARIOS_APPX.FECHA_MOD 			IS 'CAMPO DE CONTROL/AUDITORIA, FECHA EN QUE SE MODIFICA EL REGISTRO';

/
--##GRANT´s
GRANT DELETE, INSERT, SELECT, UPDATE ON SICAS_OC.GRUPOS_DE_USUARIOS_APPX TO PUBLIC;

/
--##SINONIMO
CREATE OR REPLACE PUBLIC SYNONYM GRUPOS_DE_USUARIOS_APPX FOR SICAS_OC.GRUPOS_DE_USUARIOS_APPX;

/
--##INSERT para considerar la informacion de control de la aplciacion de acceso
INSERT INTO SICAS_OC.GRUPOS_DE_USUARIOS_APPX (CODCIA,CODGRUPO,DESCRIPCION,FLAG_ACCESO,FLAG_SOLO_LECTURA,FLAG_ACTIVO,FECHA_BAJA,USUARIO_ALTA,FECHA_ALTA,USUARIO_MOD,FECHA_MOD)
SELECT --*
    GU.CODCIA
    ,GU.CODGRUPO
    ,GU.DESCGRUPO
    ,NVL(GU.INDACCESO,'N') FLAG_ACCESO
    ,NVL(GU.INDCONSULTA,'N') FLAG_SOLO_LECTURA
    ,'S' FLAG_ACTIVO
    ,NULL FECHA_BAJA
    ,USER USUARIO_ALTA
    ,TRUNC(SYSDATE) FECHA_ALTA
    ,USER USUARIO_MOD
    ,TRUNC(SYSDATE) FECHA_MOD
FROM SICAS_OC.GRUPOS_DE_USUARIOS GU
;

/

COMMIT;