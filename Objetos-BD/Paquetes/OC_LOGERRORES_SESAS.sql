CREATE OR REPLACE PACKAGE SICAS_OC.OC_LOGERRORES_SESAS AS
    
    PROCEDURE SPINSERTLOGSESAS (
                                PA_CODCIA              IN      SICAS_OC.LOGERRORES_SESAS.CODCIA%TYPE,
                                PA_CODEMPRESA          IN      SICAS_OC.LOGERRORES_SESAS.CODEMPRESA%TYPE,
                                PA_CODREPORTE          IN      SICAS_OC.LOGERRORES_SESAS.CODREPORTE%TYPE,
                                PA_CODUSUARIO          IN      SICAS_OC.LOGERRORES_SESAS.CODUSUARIO%TYPE,
                                PA_NUMEPOLIZ           IN      SICAS_OC.LOGERRORES_SESAS.EPOLIZ%TYPE,
                                PA_NUMECERTIICADO      IN      SICAS_OC.LOGERRORES_SESAS.ECERTI%TYPE,
                                PA_CODERROR            IN      SICAS_OC.LOGERRORES_SESAS.CODERR%TYPE,
                                PA_DESCERROR           IN      SICAS_OC.LOGERRORES_SESAS.DESCER%TYPE
                                );

    FUNCTION SPDELETELOGSESAS (
                                PA_CODCIA              IN      SICAS_OC.LOGERRORES_SESAS.CODCIA%TYPE,
                                PA_CODEMPRESA          IN      SICAS_OC.LOGERRORES_SESAS.CODEMPRESA%TYPE,
                                PA_CODUSUARIO          IN      SICAS_OC.LOGERRORES_SESAS.CODUSUARIO%TYPE,
                                PA_CODREPORTE          IN      SICAS_OC.LOGERRORES_SESAS.CODREPORTE%TYPE
                                )
                                RETURN NUMBER;

    csg_0       CONSTANT    NUMBER  :=  0;
    csg_1       CONSTANT    NUMBER  :=  1;

END;
/

CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_LOGERRORES_SESAS AS
    
    PROCEDURE SPINSERTLOGSESAS (
                                PA_CODCIA              IN      SICAS_OC.LOGERRORES_SESAS.CODCIA%TYPE,
                                PA_CODEMPRESA          IN      SICAS_OC.LOGERRORES_SESAS.CODEMPRESA%TYPE,
                                PA_CODREPORTE          IN      SICAS_OC.LOGERRORES_SESAS.CODREPORTE%TYPE,
                                PA_CODUSUARIO          IN      SICAS_OC.LOGERRORES_SESAS.CODUSUARIO%TYPE,
                                PA_NUMEPOLIZ           IN      SICAS_OC.LOGERRORES_SESAS.EPOLIZ%TYPE,
                                PA_NUMECERTIICADO      IN      SICAS_OC.LOGERRORES_SESAS.ECERTI%TYPE,
                                PA_CODERROR            IN      SICAS_OC.LOGERRORES_SESAS.CODERR%TYPE,
                                PA_DESCERROR           IN      SICAS_OC.LOGERRORES_SESAS.DESCER%TYPE
                                ) AS
                                
    vl_CodError     NUMBER;
    
    BEGIN

        INSERT INTO SICAS_OC.LOGERRORES_SESAS (
                                                CODCIA,
                                                CODEMPRESA,
                                                CODREPORTE,
                                                CODUSUARIO,
                                                IDSECUENCIA,
                                                EPOLIZ,
                                                ECERTI,
                                                CODERR,
                                                DESCER,
                                                FECREG,
                                                USUARIOREGISTRO
                                    ) VALUES (
                                                PA_CODCIA,
                                                PA_CODEMPRESA,
                                                PA_CODREPORTE,
                                                PA_CODUSUARIO,
                                                SICAS_OC.SEQ_LOGERRSESAS.NEXTVAL,
                                                PA_NUMEPOLIZ,
                                                PA_NUMECERTIICADO,
                                                PA_CODERROR,
                                                PA_DESCERROR,
                                                SYSDATE,
                                                PA_CODUSUARIO
                                              );

    EXCEPTION
        WHEN OTHERS THEN
            vl_CodError := SQLCODE;
    END;

    FUNCTION SPDELETELOGSESAS (
                                PA_CODCIA              IN      SICAS_OC.LOGERRORES_SESAS.CODCIA%TYPE,
                                PA_CODEMPRESA          IN      SICAS_OC.LOGERRORES_SESAS.CODEMPRESA%TYPE,
                                PA_CODUSUARIO          IN      SICAS_OC.LOGERRORES_SESAS.CODUSUARIO%TYPE,
                                PA_CODREPORTE          IN      SICAS_OC.LOGERRORES_SESAS.CODREPORTE%TYPE
                                ) RETURN NUMBER IS
    BEGIN

        DELETE FROM SICAS_OC.LOGERRORES_SESAS
        WHERE CODCIA = PA_CODCIA
            AND CODEMPRESA = PA_CODEMPRESA
            AND CODUSUARIO = PA_CODUSUARIO
            AND CODREPORTE = PA_CODREPORTE;

        COMMIT;
        RETURN csg_1;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RETURN csg_0;
            RAISE_APPLICATION_ERROR(-20220,'No se pudo realizar el vaciado de información.');
    END;

END;
/

CREATE OR REPLACE PUBLIC SYNONYM OC_LOGERRORES_SESAS FOR SICAS_OC.OC_LOGERRORES_SESAS;
/

GRANT EXECUTE ON SICAS_OC.OC_LOGERRORES_SESAS TO PUBLIC;
/