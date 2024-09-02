CREATE OR REPLACE PACKAGE SICAS_OC.OC_REQUISITOS_COBERTURAS AS
    
    ex_insert EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_insert, -02291);
    
    PROCEDURE SPINSERTDINAMICO  (
                                PA_COMANDO              IN      VARCHAR2,
                                PA_CODIGO               OUT     NUMBER,
                                PA_MENSAJE              OUT     VARCHAR2
                                );
    
    PROCEDURE SPDIRECTORY  (
                                PA_COMANDO              IN      VARCHAR2,
                                PA_CODIGO               OUT     NUMBER,
                                PA_MENSAJE              OUT     VARCHAR2
                                );
                                
    PROCEDURE SPINSERTREQCOBERT (
                                PA_CODCIA               IN      SICAS_OC.REQUISITOS_COBERTURAS.CODCIA%TYPE,
                                PA_CODEMPRESA           IN      SICAS_OC.REQUISITOS_COBERTURAS.CODEMPRESA%TYPE,
                                PA_IDTIPOSEG            IN      SICAS_OC.REQUISITOS_COBERTURAS.IDTIPOSEG%TYPE,
                                PA_PLANCOB              IN      SICAS_OC.REQUISITOS_COBERTURAS.PLANCOB%TYPE,
                                PA_CODCOBERT            IN      SICAS_OC.REQUISITOS_COBERTURAS.CODCOBERT%TYPE,
                                PA_CODREQUISITO         IN      SICAS_OC.REQUISITOS_COBERTURAS.CODREQUISITO%TYPE,
                                PA_REQUERIDO            IN      SICAS_OC.REQUISITOS_COBERTURAS.REQUERIDO%TYPE,
                                PA_ORDENEXPEDIENTE      IN      SICAS_OC.REQUISITOS_COBERTURAS.ORDENEXPEDIENTE%TYPE,
                                PA_ORDENPDF             IN      SICAS_OC.REQUISITOS_COBERTURAS.ORDENPDF%TYPE,
                                PA_CANTIDAD             IN      SICAS_OC.REQUISITOS_COBERTURAS.CANTIDAD%TYPE,
                                PA_CODIGO               OUT     NUMBER,
                                PA_MENSAJE              OUT     VARCHAR2
                                );
    
    PROCEDURE SPUPDATEREQCOBERT (
                                PA_CODCIA               IN      SICAS_OC.REQUISITOS_COBERTURAS.CODCIA%TYPE,
                                PA_CODEMPRESA           IN      SICAS_OC.REQUISITOS_COBERTURAS.CODEMPRESA%TYPE,
                                PA_IDTIPOSEG            IN      SICAS_OC.REQUISITOS_COBERTURAS.IDTIPOSEG%TYPE,
                                PA_PLANCOB              IN      SICAS_OC.REQUISITOS_COBERTURAS.PLANCOB%TYPE,
                                PA_CODCOBERT            IN      SICAS_OC.REQUISITOS_COBERTURAS.CODCOBERT%TYPE,
                                PA_CODREQUISITO         IN      SICAS_OC.REQUISITOS_COBERTURAS.CODREQUISITO%TYPE,
                                PA_REQUERIDO            IN      SICAS_OC.REQUISITOS_COBERTURAS.REQUERIDO%TYPE,
                                PA_ORDENEXPEDIENTE      IN      SICAS_OC.REQUISITOS_COBERTURAS.ORDENEXPEDIENTE%TYPE,
                                PA_ORDENPDF             IN      SICAS_OC.REQUISITOS_COBERTURAS.ORDENPDF%TYPE,
                                PA_CANTIDAD             IN      SICAS_OC.REQUISITOS_COBERTURAS.CANTIDAD%TYPE,
                                PA_CODIGO               OUT     NUMBER,
                                PA_MENSAJE              OUT     VARCHAR2
                                );
                                
    PROCEDURE SPDELETEREQCOBERT (
                                PA_CODCIA               IN      SICAS_OC.REQUISITOS_COBERTURAS.CODCIA%TYPE,
                                PA_CODEMPRESA           IN      SICAS_OC.REQUISITOS_COBERTURAS.CODEMPRESA%TYPE,
                                PA_IDTIPOSEG            IN      SICAS_OC.REQUISITOS_COBERTURAS.IDTIPOSEG%TYPE,
                                PA_PLANCOB              IN      SICAS_OC.REQUISITOS_COBERTURAS.PLANCOB%TYPE,
                                PA_CODCOBERT            IN      SICAS_OC.REQUISITOS_COBERTURAS.CODCOBERT%TYPE,
                                PA_CODREQUISITO         IN      SICAS_OC.REQUISITOS_COBERTURAS.CODREQUISITO%TYPE,
                                PA_CODIGO               OUT     NUMBER,
                                PA_MENSAJE              OUT     VARCHAR2
                                );

    csg_0       CONSTANT    NUMBER  :=  0;
    csg_1       CONSTANT    NUMBER  :=  1;

END;
/

CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_REQUISITOS_COBERTURAS AS
    
    PROCEDURE SPINSERTDINAMICO  (
                                PA_COMANDO              IN      VARCHAR2,
                                PA_CODIGO               OUT     NUMBER,
                                PA_MENSAJE              OUT     VARCHAR2
                                )IS

    BEGIN
        EXECUTE IMMEDIATE PA_COMANDO;
    EXCEPTION
        WHEN ex_insert THEN
            PA_CODIGO := SQLCODE;
            PA_MENSAJE := 'No existe la cobertura o requisito indicado.';
        WHEN DUP_VAL_ON_INDEX THEN
            PA_CODIGO := SQLCODE;
            PA_MENSAJE := 'El registro ya existe.';
        WHEN OTHERS THEN
            PA_CODIGO := SQLCODE;
            PA_MENSAJE := 'Error: '||SQLERRM;
    END SPINSERTDINAMICO;
    
    PROCEDURE SPDIRECTORY  (
                                PA_COMANDO              IN      VARCHAR2,
                                PA_CODIGO               OUT     NUMBER,
                                PA_MENSAJE              OUT     VARCHAR2
                                ) IS
    
    vl_Total    NUMBER := 0;
    vl_create   VARCHAR2(4000);
    BEGIN
        /*SELECT COUNT(1) 
        INTO vl_Total
        FROM ALL_DIRECTORIES 
        WHERE DIRECTORY_NAME='REQXCOBERT';
        
        IF vl_Total >= 1 THEN
            EXECUTE IMMEDIATE 'drop directory REQXCOBERT';
        END IF;*/
        vl_create := 'CREATE OR REPLACE DIRECTORY REQXCOBERT AS '||CHR(39)||REPLACE(PA_COMANDO,'\CargaRequisitosCob.txt','')||CHR(39);
        EXECUTE IMMEDIATE vl_create;

        
        EXECUTE IMMEDIATE 'grant read, write on directory REQXCOBERT to '||USER;
      --  EXECUTE IMMEDIATE 'GRANT EXECUTE ON SYS.UTL_FILE TO '|| USER;
    END;
    
    PROCEDURE SPINSERTREQCOBERT (
                                PA_CODCIA               IN      SICAS_OC.REQUISITOS_COBERTURAS.CODCIA%TYPE,
                                PA_CODEMPRESA           IN      SICAS_OC.REQUISITOS_COBERTURAS.CODEMPRESA%TYPE,
                                PA_IDTIPOSEG            IN      SICAS_OC.REQUISITOS_COBERTURAS.IDTIPOSEG%TYPE,
                                PA_PLANCOB              IN      SICAS_OC.REQUISITOS_COBERTURAS.PLANCOB%TYPE,
                                PA_CODCOBERT            IN      SICAS_OC.REQUISITOS_COBERTURAS.CODCOBERT%TYPE,
                                PA_CODREQUISITO         IN      SICAS_OC.REQUISITOS_COBERTURAS.CODREQUISITO%TYPE,
                                PA_REQUERIDO            IN      SICAS_OC.REQUISITOS_COBERTURAS.REQUERIDO%TYPE,
                                PA_ORDENEXPEDIENTE      IN      SICAS_OC.REQUISITOS_COBERTURAS.ORDENEXPEDIENTE%TYPE,
                                PA_ORDENPDF             IN      SICAS_OC.REQUISITOS_COBERTURAS.ORDENPDF%TYPE,
                                PA_CANTIDAD             IN      SICAS_OC.REQUISITOS_COBERTURAS.CANTIDAD%TYPE,
                                PA_CODIGO               OUT     NUMBER,
                                PA_MENSAJE              OUT     VARCHAR2
                                ) AS

    BEGIN

        INSERT INTO SICAS_OC.REQUISITOS_COBERTURAS (
                                                CODCIA,
                                                CODEMPRESA,
                                                IDTIPOSEG,
                                                PLANCOB,
                                                CODCOBERT,
                                                CODREQUISITO,
                                                REQUERIDO,
                                                ORDENEXPEDIENTE,
                                                ORDENPDF,
                                                CANTIDAD,
                                                USRINSERT,
                                                FECHAINSERT,
                                                USRMODIF,
                                                FECHAMODIF
                                    ) VALUES (
                                                PA_CODCIA,
                                                PA_CODEMPRESA,
                                                PA_IDTIPOSEG,
                                                PA_PLANCOB,
                                                PA_CODCOBERT,
                                                PA_CODREQUISITO,
                                                PA_REQUERIDO,
                                                PA_ORDENEXPEDIENTE,
                                                PA_ORDENPDF,
                                                PA_CANTIDAD,
                                                USER,
                                                SYSDATE,
                                                USER,
                                                SYSDATE
                                              );
        COMMIT;
        
        PA_CODIGO := csg_1;
        PA_MENSAJE := 'Proceso terminado con exito.';

    EXCEPTION
        WHEN ex_insert THEN
            PA_CODIGO := SQLCODE;
            PA_MENSAJE := 'No existe la cobertura o requisito indicado, '||PA_IDTIPOSEG||'-'||PA_PLANCOB||'-'||PA_CODCOBERT||'-'||PA_CODREQUISITO;
        WHEN DUP_VAL_ON_INDEX THEN
            PA_CODIGO := SQLCODE;
            PA_MENSAJE := 'El registro ya existe, '||PA_IDTIPOSEG||'-'||PA_PLANCOB||'-'||PA_CODCOBERT||'-'||PA_CODREQUISITO;
        WHEN OTHERS THEN
            PA_CODIGO := SQLCODE;
            PA_MENSAJE := 'Error: '||SQLERRM;
    END SPINSERTREQCOBERT;
    
    PROCEDURE SPUPDATEREQCOBERT (
                                PA_CODCIA               IN      SICAS_OC.REQUISITOS_COBERTURAS.CODCIA%TYPE,
                                PA_CODEMPRESA           IN      SICAS_OC.REQUISITOS_COBERTURAS.CODEMPRESA%TYPE,
                                PA_IDTIPOSEG            IN      SICAS_OC.REQUISITOS_COBERTURAS.IDTIPOSEG%TYPE,
                                PA_PLANCOB              IN      SICAS_OC.REQUISITOS_COBERTURAS.PLANCOB%TYPE,
                                PA_CODCOBERT            IN      SICAS_OC.REQUISITOS_COBERTURAS.CODCOBERT%TYPE,
                                PA_CODREQUISITO         IN      SICAS_OC.REQUISITOS_COBERTURAS.CODREQUISITO%TYPE,
                                PA_REQUERIDO            IN      SICAS_OC.REQUISITOS_COBERTURAS.REQUERIDO%TYPE,
                                PA_ORDENEXPEDIENTE      IN      SICAS_OC.REQUISITOS_COBERTURAS.ORDENEXPEDIENTE%TYPE,
                                PA_ORDENPDF             IN      SICAS_OC.REQUISITOS_COBERTURAS.ORDENPDF%TYPE,
                                PA_CANTIDAD             IN      SICAS_OC.REQUISITOS_COBERTURAS.CANTIDAD%TYPE,
                                PA_CODIGO               OUT     NUMBER,
                                PA_MENSAJE              OUT     VARCHAR2
                                ) IS
    
    BEGIN

        UPDATE SICAS_OC.REQUISITOS_COBERTURAS
        SET REQUERIDO = PA_REQUERIDO,
            ORDENEXPEDIENTE = PA_ORDENEXPEDIENTE,
            ORDENPDF = PA_ORDENPDF,
            CANTIDAD = PA_CANTIDAD,
            USRMODIF = USER,
            FECHAMODIF = SYSDATE
        WHERE CODCIA = PA_CODCIA
            AND CODEMPRESA = PA_CODEMPRESA
            AND IDTIPOSEG = PA_IDTIPOSEG
            AND PLANCOB = PA_PLANCOB
            AND CODCOBERT = PA_CODCOBERT
            AND CODREQUISITO = PA_CODREQUISITO;

        COMMIT;
        
        PA_CODIGO := csg_1;
        PA_MENSAJE := 'Proceso terminado con exito.';
        
    EXCEPTION
        WHEN OTHERS THEN
            PA_CODIGO := SQLCODE;
            PA_MENSAJE := 'Error: '||SQLERRM;
    END SPUPDATEREQCOBERT;
    
    PROCEDURE SPDELETEREQCOBERT (
                                PA_CODCIA               IN      SICAS_OC.REQUISITOS_COBERTURAS.CODCIA%TYPE,
                                PA_CODEMPRESA           IN      SICAS_OC.REQUISITOS_COBERTURAS.CODEMPRESA%TYPE,
                                PA_IDTIPOSEG            IN      SICAS_OC.REQUISITOS_COBERTURAS.IDTIPOSEG%TYPE,
                                PA_PLANCOB              IN      SICAS_OC.REQUISITOS_COBERTURAS.PLANCOB%TYPE,
                                PA_CODCOBERT            IN      SICAS_OC.REQUISITOS_COBERTURAS.CODCOBERT%TYPE,
                                PA_CODREQUISITO         IN      SICAS_OC.REQUISITOS_COBERTURAS.CODREQUISITO%TYPE,
                                PA_CODIGO               OUT     NUMBER,
                                PA_MENSAJE              OUT     VARCHAR2
                                ) IS
    BEGIN

        DELETE FROM SICAS_OC.REQUISITOS_COBERTURAS
        WHERE CODCIA = PA_CODCIA
            AND CODEMPRESA = PA_CODEMPRESA
            AND IDTIPOSEG = PA_IDTIPOSEG
            AND PLANCOB = PA_PLANCOB
            AND CODCOBERT = PA_CODCOBERT
            AND CODREQUISITO = PA_CODREQUISITO;

        COMMIT;
        
        PA_CODIGO := csg_1;
        PA_MENSAJE := 'Proceso terminado con exito.';
        
    EXCEPTION
        WHEN OTHERS THEN
            PA_CODIGO := SQLCODE;
            PA_MENSAJE := 'Error: '||SQLERRM;
    END SPDELETEREQCOBERT;

END;
/

CREATE OR REPLACE PUBLIC SYNONYM OC_REQUISITOS_COBERTURAS FOR SICAS_OC.OC_REQUISITOS_COBERTURAS;
/

GRANT EXECUTE ON SICAS_OC.OC_REQUISITOS_COBERTURAS TO PUBLIC;
/