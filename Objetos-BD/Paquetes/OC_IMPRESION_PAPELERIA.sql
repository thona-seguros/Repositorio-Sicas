CREATE OR REPLACE PACKAGE SICAS_OC.OC_IMPRESION_PAPELERIA as
/*------------------------------------------------------------------------
    Nombre: OC_IMPRESION_PAPELERIA
    Autor: Laura Ramos y Gustavo Morfin / Equipo Desarrollo
    Versión: 1.0
    Fecha Creación: 12/05/2026
    Descripción:Paquete encargado de la gestión operativa de pólizas, 
	incluyendo distribución multinivel, cambios de cliente, asegurados, 
	generación de reportes y archivos ZIP.
    Fechas Modificación:
------------------------------------------------------------------------*/
    PROCEDURE ADD_REPORTE_ZIP_(
    p_url         IN VARCHAR2,
    p_nombre      IN VARCHAR2,
    p_zip_blob    IN OUT NOCOPY BLOB,
    p_blob_gmprot   IN BLOB DEFAULT NULL,
    p_pdf_size    OUT NUMBER,
    p_tiene_texto OUT BOOLEAN
    );
    
    PROCEDURE GENERA_REPORTE(vPoliza NUMBER,
        vFecha_Ini DATE,
        vFecha_Fin DATE,
        vDet_Ini NUMBER,
        vDet_Fin NUMBER,
        vAseg_Ini NUMBER,
        vAseg_Fin NUMBER,
        vEndoso_Ini NUMBER,
        vEndoso_Fin NUMBER,
        vCH_Asegurado VARCHAR2,
        vCH_Regla VARCHAR2,
        vCH_Nutra VARCHAR2,
        vCH_Suma VARCHAR2,
        vUsuario VARCHAR2,
        vRep_Pol_Vida_Grupo VARCHAR2,
        vRep_Acci_Colectivo VARCHAR2,
        vRep_Acci_Col_Sub VARCHAR2,
        vRep_Pol_Ind VARCHAR2,
        vRep_Vida_Flex VARCHAR2,
        vRep_Cer_Ind_Bloque VARCHAR2,
        vRep_Cons_Ind_Pol VARCHAR2,
        vRep_Cons_Ind_ASE VARCHAR2,
        vRep_Aseg_Prima VARCHAR2,
        vRep_Aseg_Sin_Prima VARCHAR2,
        vRep_Bienvenida VARCHAR2,
        vRep_Sini_Vida VARCHAR2,
        vRep_Sini_AP VARCHAR2,
        vRep_Endoso_Asis VARCHAR2,
        vRep_Auto_Admin VARCHAR2,
        vRep_Cond_Especiales VARCHAR2,
        vRep_Endoso_Gral VARCHAR2,
        vRep_Rec_Fact_Elec VARCHAR2,
        vRep_Condiciones_Gral VARCHAR2,
        vRep_Aviso_Cobro VARCHAR2,
        vRep_Aporte_Reg VARCHAR2,
        vRep_Aviso_Dev VARCHAR2,
        vRep_Aporte_Extra VARCHAR2,
        vRep_Fondo_Colec VARCHAR2,
        vRep_Cer_Ind_aseg VARCHAR2,
        VNombre_Archivo VARCHAR2,
        vRep_ARCHIVO_Condiciones_Gral VARCHAR2,
        vCOD_PAQ VARCHAR2,
        vRep_Gmm_GMProtect     VARCHAR2 DEFAULT NULL 
                             );

    PROCEDURE GENERA_ZIP (vID_Reporte IN NUMBER);


    PROCEDURE GENERA_KITEMISION(cNombRepor VARCHAR2,
                            nActTabla  NUMBER,
                            vPoliza    NUMBER,
                            vUsuario   VARCHAR2 DEFAULT NULL
                                );

    PROCEDURE AGREGA_CONSENTIMIENTOS_ZIP (
                            p_poliza      VARCHAR2,
                            p_det_ini     VARCHAR2,
                            p_det_fin     VARCHAR2,
                            p_endoso_ini  VARCHAR2,
                            p_endoso_fin  VARCHAR2,
                            p_usuario     VARCHAR2,
                            vCH_Regla     VARCHAR2,
                            p_zip_blob    IN OUT NOCOPY BLOB,   
                            p_count       OUT NUMBER,          
                            p_tiene_texto OUT BOOLEAN,     
                            P_Aseg_Ini NUMBER,
                            P_vAseg_Fin NUMBER 
      );

    PROCEDURE AGREGA_CERTIFICADOS_ZIP (
        p_poliza      VARCHAR2,
        p_det_ini     VARCHAR2,
        p_det_fin     VARCHAR2,
        p_endoso_ini  VARCHAR2,
        p_endoso_fin  VARCHAR2,
        p_usuario     VARCHAR2,
        vCH_Regla     VARCHAR2,
        vCH_Suma      VARCHAR2,
        p_zip_blob    IN OUT NOCOPY BLOB,
        p_count       OUT NUMBER,
        p_tiene_texto OUT BOOLEAN, 
        P_Aseg_Ini NUMBER,
        P_vAseg_Fin NUMBER 
    );

    PROCEDURE AGREGA_FONDO_ZIP (
            p_poliza      VARCHAR2,
            p_det_ini     VARCHAR2,
            p_det_fin     VARCHAR2,
            p_endoso_ini  VARCHAR2,
            p_endoso_fin  VARCHAR2,
            p_usuario     VARCHAR2,
            vCH_Regla     VARCHAR2,
            vCH_Suma      VARCHAR2,
            p_zip_blob    IN OUT NOCOPY BLOB,
            p_count       OUT NUMBER,
            p_tiene_texto OUT BOOLEAN, 
            P_Aseg_Ini NUMBER,
            P_vAseg_Fin NUMBER,
            p_fecini DATE 
        );

    PROCEDURE AGREGA_BLOQUE_ZIP (
            p_poliza      VARCHAR2,
            p_det_ini     VARCHAR2,
            p_det_fin     VARCHAR2,
            p_endoso_ini  VARCHAR2,
            p_endoso_fin  VARCHAR2,
            p_usuario     VARCHAR2,
            vCH_Regla     VARCHAR2,
            vCH_Suma      VARCHAR2,
            p_zip_blob    IN OUT NOCOPY BLOB,
            p_count       OUT NUMBER,
            p_tiene_texto OUT BOOLEAN, 
            P_Aseg_Ini NUMBER,
            P_vAseg_Fin NUMBER
    );
    
    PROCEDURE AGREGA_POLIZA_ZIP (
            p_poliza      VARCHAR2,
            p_det_ini     VARCHAR2,
            p_det_fin     VARCHAR2,
            p_endoso_ini  VARCHAR2,
            p_endoso_fin  VARCHAR2,
            p_usuario     VARCHAR2,
            vCH_Regla     VARCHAR2,
            vCH_Suma      VARCHAR2,
            p_zip_blob    IN OUT NOCOPY BLOB,
            p_count       OUT NUMBER,
            p_tiene_texto OUT BOOLEAN, 
            P_Aseg_Ini NUMBER,
            P_vAseg_Fin NUMBER
    );
        vl_Existe   NUMBER;
end OC_IMPRESION_PAPELERIA;
/

CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_IMPRESION_PAPELERIA as

    /*cambio de liga dependiendo el ambiente en el que este montada la app */

     C_URL_BASE CONSTANT VARCHAR2(200) := 'http://sicascloud:8889/reports/rwservlet';
    v_credenciales_j CONSTANT VARCHAR2(200)  := '&'||'j_username=jasperadmin'||'&'||'j_password=jasperadmin';
    v_jasper CONSTANT VARCHAR2(200)  :=  'http://sicascloud:8081/jasperserver/rest_v2/reports/';

    /*cambio de liga dependiendo el ambiente en el que este montada la app */

  PROCEDURE ADD_REPORTE_ZIP_(
    p_url         IN VARCHAR2,
    p_nombre      IN VARCHAR2,
    p_zip_blob    IN OUT NOCOPY BLOB,
    p_blob_gmprot   IN BLOB DEFAULT NULL,
    p_pdf_size    OUT NUMBER,
    p_tiene_texto OUT BOOLEAN
    ) IS
        l_req         UTL_HTTP.req;
        l_resp        UTL_HTTP.resp;
        l_buffer      RAW(32767);
        l_pdf_blob    BLOB;
        l_amount      BINARY_INTEGER := 32767;
        l_total       NUMBER;
        l_resp_abierta BOOLEAN := FALSE;

        FUNCTION tiene_patron(p_offset IN INTEGER) RETURN BOOLEAN IS
            l_chunk_raw  RAW(4000);
            l_chunk_str  VARCHAR2(4000);
            l_amt        INTEGER := 4000;
        BEGIN
            IF p_offset > l_total THEN RETURN FALSE; END IF;
            IF p_offset + l_amt > l_total THEN
                l_amt := l_total - p_offset + 1;
            END IF;
            DBMS_LOB.READ(l_pdf_blob, l_amt, p_offset, l_chunk_raw);
            l_chunk_str := UTL_RAW.CAST_TO_VARCHAR2(l_chunk_raw);

            RETURN (
                l_chunk_str LIKE '% Tj%'    OR
                l_chunk_str LIKE '%] TJ%'   OR
                l_chunk_str LIKE '%(%)Tj%'  OR
                l_chunk_str LIKE '%BT%ET%'  OR
                l_chunk_str LIKE '%stream%' OR
                l_chunk_str LIKE '%/Font%'
            );
        EXCEPTION
            WHEN OTHERS THEN RETURN TRUE;
        END;

    BEGIN
        p_pdf_size    := 0;
        p_tiene_texto := FALSE;

        DBMS_LOB.createtemporary(l_pdf_blob, TRUE);
        UTL_HTTP.set_transfer_timeout(840);

        IF p_url IS NOT NULL THEN 

            BEGIN
                l_req := UTL_HTTP.begin_request(p_url);
                UTL_HTTP.set_header(l_req, 'User-Agent', 'Mozilla/5.0');
    
                l_resp        := UTL_HTTP.get_response(l_req);
                l_resp_abierta := TRUE;
    
                LOOP
                    BEGIN
                        UTL_HTTP.read_raw(l_resp, l_buffer, l_amount);
                        DBMS_LOB.writeappend(l_pdf_blob, UTL_RAW.length(l_buffer), l_buffer);
                    EXCEPTION
                        WHEN UTL_HTTP.end_of_body THEN EXIT;
                    END;
                END LOOP;
    
                UTL_HTTP.end_response(l_resp);
                l_resp_abierta := FALSE;
    
            EXCEPTION
                WHEN UTL_HTTP.request_failed THEN
                    IF l_resp_abierta THEN
                        BEGIN UTL_HTTP.end_response(l_resp); EXCEPTION WHEN OTHERS THEN NULL; END;
                    END IF;
                    DBMS_LOB.freetemporary(l_pdf_blob);
                    p_pdf_size    := 0;
                    p_tiene_texto := FALSE;
                    RETURN;  -- Sale limpiamente sin explotar el proceso padre
    
                WHEN UTL_HTTP.transfer_timeout THEN
                    IF l_resp_abierta THEN
                        BEGIN UTL_HTTP.end_response(l_resp); EXCEPTION WHEN OTHERS THEN NULL; END;
                    END IF;
                    DBMS_LOB.freetemporary(l_pdf_blob);
                    p_pdf_size    := 0;
                    p_tiene_texto := FALSE;
                    RETURN;
    
                WHEN OTHERS THEN
                    IF l_resp_abierta THEN
                        BEGIN UTL_HTTP.end_response(l_resp); EXCEPTION WHEN OTHERS THEN NULL; END;
                    END IF;
                    DBMS_LOB.freetemporary(l_pdf_blob);
                    p_pdf_size    := 0;
                    p_tiene_texto := FALSE;
                    RETURN;
            END;
        END IF;
        
        IF p_url IS NOT NULL THEN --Todos los productos
            p_pdf_size := DBMS_LOB.GETLENGTH(l_pdf_blob);
            l_total    := p_pdf_size;
        ELSE --GMPROTECT
            p_pdf_size := DBMS_LOB.GETLENGTH(p_blob_gmprot);
            l_total    := p_pdf_size;
        END IF; 

        IF p_pdf_size > 0 THEN
            IF    tiene_patron(1)                           THEN p_tiene_texto := TRUE;
            ELSIF tiene_patron(ROUND(l_total * 0.25))       THEN p_tiene_texto := TRUE;
            ELSIF tiene_patron(ROUND(l_total * 0.50))       THEN p_tiene_texto := TRUE;
            ELSIF tiene_patron(ROUND(l_total * 0.75))       THEN p_tiene_texto := TRUE;
            ELSIF tiene_patron(GREATEST(1, l_total - 4000)) THEN p_tiene_texto := TRUE;
            END IF;
        END IF;

        IF p_url IS NULL THEN
            APEX_ZIP.ADD_FILE(
                p_zipped_blob => p_zip_blob,
                p_file_name   => p_nombre,
                p_content     => p_blob_gmprot
            );
        ELSIF p_tiene_texto THEN
            APEX_ZIP.ADD_FILE(
                p_zipped_blob => p_zip_blob,
                p_file_name   => p_nombre,
                p_content     => l_pdf_blob
            );
        END IF;

        DBMS_LOB.freetemporary(l_pdf_blob);

    EXCEPTION
        WHEN OTHERS THEN
            BEGIN
                IF DBMS_LOB.ISTEMPORARY(l_pdf_blob) = 1 THEN
                    DBMS_LOB.freetemporary(l_pdf_blob);
                END IF;
            EXCEPTION WHEN OTHERS THEN NULL;
            END;
            p_pdf_size    := 0;
            p_tiene_texto := FALSE;
    END ADD_REPORTE_ZIP_;

    PROCEDURE GENERA_REPORTE(
        vPoliza NUMBER,
        vFecha_Ini DATE,
        vFecha_Fin DATE,
        vDet_Ini NUMBER,
        vDet_Fin NUMBER,
        vAseg_Ini NUMBER,
        vAseg_Fin NUMBER,
        vEndoso_Ini NUMBER,
        vEndoso_Fin NUMBER,
        vCH_Asegurado VARCHAR2,
        vCH_Regla VARCHAR2,
        vCH_Nutra VARCHAR2,
        vCH_Suma VARCHAR2,
        vUsuario VARCHAR2,
        vRep_Pol_Vida_Grupo VARCHAR2,
        vRep_Acci_Colectivo VARCHAR2,
        vRep_Acci_Col_Sub VARCHAR2,
        vRep_Pol_Ind VARCHAR2,
        vRep_Vida_Flex VARCHAR2,
        vRep_Cer_Ind_Bloque VARCHAR2,
        vRep_Cons_Ind_Pol VARCHAR2,
        vRep_Cons_Ind_ASE VARCHAR2,
        vRep_Aseg_Prima VARCHAR2,
        vRep_Aseg_Sin_Prima VARCHAR2,
        vRep_Bienvenida VARCHAR2,
        vRep_Sini_Vida VARCHAR2,
        vRep_Sini_AP VARCHAR2,
        vRep_Endoso_Asis VARCHAR2,
        vRep_Auto_Admin VARCHAR2,
        vRep_Cond_Especiales VARCHAR2,
        vRep_Endoso_Gral VARCHAR2,
        vRep_Rec_Fact_Elec VARCHAR2,
        vRep_Condiciones_Gral VARCHAR2,
        vRep_Aviso_Cobro VARCHAR2,
        vRep_Aporte_Reg VARCHAR2,
        vRep_Aviso_Dev VARCHAR2,
        vRep_Aporte_Extra VARCHAR2,
        vRep_Fondo_Colec VARCHAR2,
        vRep_Cer_Ind_aseg VARCHAR2,
        VNombre_Archivo VARCHAR2,
        vRep_ARCHIVO_Condiciones_Gral VARCHAR2,
        vCOD_PAQ VARCHAR2,
        vRep_Gmm_GMProtect     VARCHAR2 DEFAULT NULL 
    ) IS

        l_file_blob   BLOB;
        l_url         VARCHAR2(32767);
        l_zip_blob    BLOB;

        TYPE t_reportes  IS TABLE OF VARCHAR2(500) INDEX BY PLS_INTEGER;
        TYPE t_num_arr   IS TABLE OF NUMBER        INDEX BY PLS_INTEGER;
        TYPE t_color_arr IS TABLE OF VARCHAR2(10)  INDEX BY PLS_INTEGER;

        l_reportes    t_reportes;
        l_sizes       t_num_arr;
        l_colores_arr t_color_arr;

        l_idx         PLS_INTEGER := 0;
        l_nombres     VARCHAR2(4000);
        l_tamanos     VARCHAR2(4000);
        l_colores     VARCHAR2(4000);
        l_sizes_cond  NUMBER;
        l_tiene_texto BOOLEAN;
        l_pdf_size    NUMBER;
        l_zip_size    INTEGER;
        nnum_cons     NUMBER;
        nnum_cert     NUMBER;
        
        v_nombre_reporte VARCHAR2(50);
         
         --Argenis
        vl_IsGMPRTEC    NUMBER;
        vl_asist_GMPROTECT   VARCHAR2(100) := 'Asistencias_GMProtect.pdf'; 
        v_blob          BLOB;
        v_mime_type     VARCHAR2(100);
        v_file_name     VARCHAR2(200);
        
        --JJG 20/07/2026
        l_titulo_archivo  VARCHAR2(500);
        l_nombre_archivo  VARCHAR2(1000);
    BEGIN
        DBMS_OUTPUT.put_line('1. Inicio proceso');
        DBMS_LOB.createtemporary(l_zip_blob, TRUE);
        UTL_HTTP.set_persistent_conn_support(FALSE);
        
        /*Argenis*/
        SELECT COUNT(1) 
        INTO vl_IsGMPRTEC
        FROM SICAS_OC.DETALLE_POLIZA D
        WHERE D.IDPOLIZA = vPoliza 
            AND D.IDTIPOSEG = (SELECT CODVALOR 
                                FROM SICAS_OC.VALORES_DE_LISTAS 
                                WHERE CODLISTA = 'GMPRCALC' 
                                    AND CVE_CNSF = 'PRODNEW' /*D.IDTIPOSEG*/);

       /*TERMINA ARGENIS*/

        DELETE FROM LISTADO_KITEMISION WHERE IDPOLIZA = vPoliza;
        COMMIT;

               -- POLIZA VIDA GRUPO
               IF vRep_Pol_Vida_Grupo = 'S' THEN
                    l_url := C_URL_BASE ||
                      '?keyreportappx'||
                       '&' ||'report=POLIZAVG.rep'||
                       '&' ||'P_CODCIA=1'||
                       '&' ||'P_POLIZA='||vPoliza;

            --l_url := VIDA_GRUPO(vPoliza);
            -- C_URL_BASE || || '&'|| 'report=POLIZAVG.rep'||'&'||'P_POLIZA=' || p_poliza;
            ADD_REPORTE_ZIP_(l_url, 'VIDA_GRUPO_'||vPoliza||'.pdf', l_zip_blob, null,l_pdf_size, l_tiene_texto);
            l_idx := l_idx + 1;
            l_reportes(l_idx)    := 'P138_REP_POL_VIDA_GRUPO';
            l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
            l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
            GENERA_KITEMISION('POLIZAVG.rep', 1, vPoliza, vUsuario);
        END IF;

               -- ACCIDENTES COLECTIVOS
               IF vRep_Acci_Colectivo = 'S' THEN
            l_url := C_URL_BASE ||
                      '?keyreportappx'||
                      '&' ||'report=POLIZACA.rep'||
                      '&' ||'P_CODCIA=1'||
                      '&' ||'P_POLIZA='||vPoliza;
            ADD_REPORTE_ZIP_(l_url, 'ACCIDENTES_COLECTIVOS_'||vPoliza||'.pdf', l_zip_blob,null, l_pdf_size, l_tiene_texto);
            l_idx := l_idx + 1;
            l_reportes(l_idx)    := 'P138_REP_ACCI_COLECTIVO';
            l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
            l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
            GENERA_KITEMISION('POLIZACA.rep', 1, vPoliza, vUsuario);
        END IF;

               -- COLECTIVOS SUBGRUPO Y Caratula de GMPROTECT
               
        IF vRep_Gmm_GMProtect = 'S' THEN
                SELECT COUNT(1)
                INTO vl_Existe
                FROM SICAS_OC.DETALLE_POLIZA
                WHERE IDPOLIZA = vPoliza
                    AND IDTIPOSEG = (SELECT CODVALOR 
                                FROM SICAS_OC.VALORES_DE_LISTAS 
                                WHERE CODLISTA = 'GMPRCALC' 
                                    AND CVE_CNSF = 'PRODNEW' /*IDTIPOSEG*/);
                
             IF vl_Existe > 0 THEN
                l_url := 'http://sicascloud:8081/jasperserver/rest_v2/reports/Caratulas_2026_1/POLIZA_GMPRO.pdf?'||
                    'IDPOLIZA='||vPoliza||
                    '&'||'IDETPOLINI='||vDet_Ini||
                    '&'||'IDETPOLFIN='||vDet_Fin||
                    '&'||'CODASEGINI='||vAseg_Ini||
                    '&'||'CODASEGFIN='||vAseg_FiN||
                    '&'||'ENDOSOINI='||vEndoso_Ini||
                    '&'||'ENDOSOFIN='||vEndoso_Fin||
                    v_credenciales_j;
    
                ADD_REPORTE_ZIP_(l_url, 'GMPROTECT_'||vPoliza||'.pdf', l_zip_blob,NULL, l_pdf_size, l_tiene_texto);
                l_idx := l_idx + 1;
                l_reportes(l_idx)    := 'P138_REP_GMM_PROTECT';
                l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
                l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
                GENERA_KITEMISION('POLIZACA.rep', 1, vPoliza, vUsuario);
            ELSE
            
                RAISE_APPLICATION_ERROR(-20001, 'LA PÓLIZA SELECCIONADA NO ES DE TIPO GMPROTECT');
            END IF;
        END IF;
        
        IF vRep_Acci_Col_Sub = 'S' THEN
            l_url :=   C_URL_BASE ||
                      '?keyreportappx'||
                      '&' ||'report=POLCASUB.rep'||
                      '&' ||'P_CODCIA=1'||
                      '&' ||'P_POLIZA='||vPoliza;
            ADD_REPORTE_ZIP_(l_url, 'COLECTIVOS_SUBGRUPO_'||vPoliza||'.pdf', l_zip_blob,null, l_pdf_size, l_tiene_texto);
            l_idx := l_idx + 1;
            l_reportes(l_idx)    := 'P138_REP_ACCI_COL_SUB';
            l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
            l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
            GENERA_KITEMISION('POLCASUB.rep', 1, vPoliza, vUsuario);
        END IF;

               -- POLIZA INDIVIDUAL
               IF vRep_Pol_Ind = 'S' THEN
            l_url := C_URL_BASE ||
                    '?keyreportappx'||
                     '&' ||'report=POLIZAVI.rep'||
                     '&'||'P_CODCIA=1'||
                     '&' ||'P_POLIZA='||vPoliza;
            ADD_REPORTE_ZIP_(l_url, 'POLIZA_INDIVIDUAL_'||vPoliza||'.pdf', l_zip_blob,null, l_pdf_size, l_tiene_texto);
            l_idx := l_idx + 1;
            l_reportes(l_idx)    := 'P138_REP_POL_IND';
            l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
            l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
            GENERA_KITEMISION('POLIZAVI.rep', 1, vPoliza, vUsuario);
        END IF;

               -- VIDA FLEX
               IF vRep_Vida_Flex = 'S' THEN
            l_url := C_URL_BASE ||
                      '?keyreportappx'||
                      '&' ||'report=POLIZAVF.rep'||
                      '&' ||'P_CODCIA=1'||
                      '&' ||'P_POLIZA='||vPoliza;
            ADD_REPORTE_ZIP_(l_url, 'VIDA_FLEX_'||vPoliza||'.pdf', l_zip_blob,null, l_pdf_size, l_tiene_texto);
            l_idx := l_idx + 1;
            l_reportes(l_idx)    := 'P138_REP_VIDA_FLEX';
            l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
            l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
            GENERA_KITEMISION('POLIZAVF.rep', 1, vPoliza, vUsuario);
        END IF;

               -- CONSENTIMIENTO INDIVIDUAL POR POLIZA
               IF vRep_Cons_Ind_Pol = 'S' THEN
                     AGREGA_poliza_ZIP(
                        p_poliza      => TO_CHAR(vPoliza),
                        p_det_ini     => TO_CHAR(vDet_Ini),
                        p_det_fin     => TO_CHAR(vDet_Fin),
                        p_endoso_ini  => TO_CHAR(vEndoso_Ini),
                        p_endoso_fin  => TO_CHAR(vEndoso_Fin),
                        p_usuario     => vUsuario,
                        vCH_Regla     => vCH_Regla,
                        vCH_Suma      => vCH_Suma,
                        p_zip_blob    => l_zip_blob,
                        p_count       => nnum_cert,
                        p_tiene_texto => l_tiene_texto,
                        P_Aseg_Ini    => vAseg_Ini,
                        P_vAseg_Fin => vAseg_FiN
                    );      

            l_idx := l_idx + 1;
            l_reportes(l_idx)    := 'P138_REP_CONS_IND_POL';
            l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
            l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
            GENERA_KITEMISION('CONSIND.rep', 1, vPoliza, vUsuario);
        END IF;

               -- CONSENTIMIENTO INDIVIDUAL POR ASEGURADO           
            IF vRep_Cons_Ind_ASE = 'S' THEN

               AGREGA_CONSENTIMIENTOS_ZIP(
                    p_poliza      => TO_CHAR(vPoliza),
                    p_det_ini     => TO_CHAR(vDet_Ini),
                    p_det_fin     => TO_CHAR(vDet_Fin),
                    p_endoso_ini  => TO_CHAR(vEndoso_Ini),
                    p_endoso_fin  => TO_CHAR(vEndoso_Fin),
                    p_usuario     => vUsuario,
                    vCH_Regla     => vCH_Regla,
                    p_zip_blob    => l_zip_blob,       
                    p_count       => nnum_cons,
                    p_tiene_texto => l_tiene_texto,
                    P_Aseg_Ini               => vAseg_Ini,
                    P_vAseg_Fin => vAseg_FiN
                );
                l_idx := l_idx + 1;
                l_reportes(l_idx)    := 'P138_REP_CONS_IND_ASEG';
                l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
                l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;

                IF NVL(vRep_Cons_Ind_Pol,'N') != 'S' THEN
                    GENERA_KITEMISION('CONSIND.rep', 1, vPoliza, vUsuario);
                END IF;
            END IF;

               -- LISTADO ASEGURADOS CON PRIMA
               IF vRep_Aseg_Prima = 'S' THEN
            l_url :=  C_URL_BASE 
                      ||'?keyreportappx'||
                      '&' ||'report=LSTASEG.rep'||
                      '&' ||'P_CODCIA=1'||
                      '&' ||'P_POLIZA='||vPoliza||
                      '&' ||'P_IDETPOLINI='||vDet_Ini||
                      '&' ||'P_IDETPOLFIN='||vDet_Fin||
                      '&' ||'P_ENDOSOINI='||vEndoso_Ini||
                      '&' ||'P_ENDOSOFIN='||vEndoso_Fin;

            ADD_REPORTE_ZIP_(l_url, 'LISTADO_ASEG_PRIMA_'||vPoliza||'.pdf', l_zip_blob,null, l_pdf_size, l_tiene_texto);
            l_idx := l_idx + 1;
            l_reportes(l_idx)    := 'P138_REP_ASEG_PRIMA';
            l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
            l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
            GENERA_KITEMISION('LSTASEG.rep', 1, vPoliza, vUsuario);
        END IF;

               -- LISTADO ASEGURADOS SIN PRIMA
               IF vRep_Aseg_Sin_Prima = 'S' THEN
            l_url := C_URL_BASE ||           
                      '?keyreportappx'||
                      '&' ||'report=LSTASESP.rep'||
                      '&' ||'P_CODCIA=1'||
                      '&' ||'P_POLIZA='||vPoliza||
                      '&' ||'P_IDETPOLINI='||vDet_Ini||
                      '&' ||'P_IDETPOLFIN='||vDet_Fin||
                      '&' ||'P_ENDOSOINI='||vEndoso_Ini||
                      '&' ||'P_ENDOSOFIN='||vEndoso_Fin;

            ADD_REPORTE_ZIP_(l_url, 'LISTADO_ASEG_SIN_PRIMA_'||vPoliza||'.pdf', l_zip_blob, null,l_pdf_size, l_tiene_texto);
            l_idx := l_idx + 1;
            l_reportes(l_idx)    := 'P138_REP_ASEG_SIN_PRIMA';
            l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
            l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
            GENERA_KITEMISION('LSTASESP.rep', 1, vPoliza, vUsuario);
        END IF;

               -- CARTA BIENVENIDA
               IF vRep_Bienvenida = 'S' THEN
            l_url := C_URL_BASE ||'?keyreportappx'||
                      '&' ||'report=CARTABIE.rep'||
                      '&' ||'P_CODCIA=1'||
                      '&' ||'P_IDPOLIZA='||vPoliza;

            ADD_REPORTE_ZIP_(l_url, 'CARTA_BIENVENIDA_'||vPoliza||'.pdf', l_zip_blob, null,l_pdf_size, l_tiene_texto);
            l_idx := l_idx + 1;
            l_reportes(l_idx)    := 'P138_REP_BIENVENIDA';
            l_sizes(l_idx)       := l_pdf_size;
            l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
            GENERA_KITEMISION('CARTABIE.rep', 1, vPoliza, vUsuario);
        END IF;

               -- SINIESTRO VIDA
               IF vRep_Sini_Vida = 'S' THEN
            l_url := C_URL_BASE || 
                      '?keyreportappx'||
                      '&' ||'report=CARSINVI.rep'||
                      '&' ||'P_CODCIA=1'||
                      '&' ||'P_CODEMPRESA=1'||
                      '&' ||'P_IDPOLIZA='||vPoliza;

            ADD_REPORTE_ZIP_(l_url, 'SINIESTRO_VIDA_'||vPoliza||'.pdf', l_zip_blob,null, l_pdf_size, l_tiene_texto);
            l_idx := l_idx + 1;
            l_reportes(l_idx)    := 'P138_REP_SINI_VIDA';
            l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
            l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
            GENERA_KITEMISION('CARSINVI.rep', 1, vPoliza, vUsuario);
        END IF;

               -- SINIESTRO AP
               IF vRep_Sini_AP = 'S' THEN
            l_url := C_URL_BASE ||
                      '?keyreportappx'||
                      '&' ||'report=CARSINAP.rep'||
                      '&' ||'P_CODCIA=1'||
                      '&' ||'P_CODEMPRESA=1'||
                      '&' ||'P_IDPOLIZA='||vPoliza;

            ADD_REPORTE_ZIP_(l_url, 'SINIESTRO_AP_'||vPoliza||'.pdf', l_zip_blob, null,l_pdf_size, l_tiene_texto);
            l_idx := l_idx + 1;
            l_reportes(l_idx)    := 'P138_REP_SINI_AP';
            l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
            l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
            GENERA_KITEMISION('CARSINAP.rep', 1, vPoliza, vUsuario);
        END IF;

               -- ENDOSO ASISTENCIA
            IF vRep_Endoso_Asis = 'S' THEN
                IF vl_IsGMPRTEC = 1 THEN
                        BEGIN
                            
                            SELECT file_content, mime_type, file_name
                            INTO v_blob, v_mime_type, v_file_name
                            FROM apex_application_static_files
                            WHERE application_id = v('APP_ID')  -- Filtra por tu aplicación actual
                                AND file_name      = vl_asist_GMPROTECT;
                            --Se manda la URL en null, ya que no se ejecutará una petición a jasper, se descargará directamente el blob del pdf que esta en apex
                            ADD_REPORTE_ZIP_(NULL, 'ASISTENCIAS_GMProtect_'||vPoliza||'.pdf', l_zip_blob,v_blob, l_pdf_size, l_tiene_texto);
                            l_idx := l_idx + 1;
                            l_reportes(l_idx)    := 'P138_REP_ENDOSO_ASIS';
                            l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
                            l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
                            GENERA_KITEMISION('ENDASIST.rep', 1, vPoliza, vUsuario);
                
                        EXCEPTION
                             WHEN NO_DATA_FOUND THEN
                                RAISE_APPLICATION_ERROR(-20001, 'El archivo PDF especificado no existe.');
                            WHEN OTHERS THEN
                                RAISE_APPLICATION_ERROR(-20001, 'Error: '||SQLERRM);
                        END;
                
                    ELSE
                         /*  
                     FOR I  IN (
                        SELECT DISTINCT 
                             A.ID_PAQUETE, 
                             V.DESCVALLST
                        FROM ASISTENCIAS_ASEGURADO AA, 
                             POLIZAS P, 
                             ASISTENCIAS A, 
                             VALORES_DE_LISTAS V
                       WHERE A.CodAsistencia  = AA.CodAsistencia
                         AND A.CodEmpresa     = P.CodEmpresa
                         AND A.CodCia         = P.CodCia
                         AND P.CodCia         = AA.CodCia 
                         AND P.IdPoliza       = AA.IdPoliza 
                         AND AA.CodCia        = 1
                         AND AA.IdPoliza      = vPoliza
                         --
                         AND V.CODLISTA = 'PAQUEASIS'
                         AND V.CODVALOR = A.ID_PAQUETE
                       UNION
                      SELECT DISTINCT
                             A.ID_PAQUETE, 
                             V.DESCVALLST
                        FROM ASISTENCIAS_DETALLE_POLIZA AA, 
                             POLIZAS P, 
                             ASISTENCIAS A, 
                             VALORES_DE_LISTAS V
                       WHERE A.CodAsistencia  = AA.CodAsistencia
                         AND A.CodEmpresa     = P.CodEmpresa
                         AND A.CodCia         = P.CodCia
                         AND P.CodCia         = AA.CodCia 
                         AND P.IdPoliza       = AA.IdPoliza 
                         AND AA.CodCia        = 1
                         AND AA.IdPoliza      = vPoliza
                         AND V.CODLISTA = 'PAQUEASIS'
                         AND V.CODVALOR = A.ID_PAQUETE 
                     ) 
                     LOOP
        
                    l_url :=  C_URL_BASE
                              || '?keyreportappx'||
                              '&' ||'report=ENDASISM.rep'||
                              '&' ||'P_POLIZA='||vPoliza||
                              '&' ||'P_CODCIA=1'||
                              '&' || 'P_PAQUETE='|| I.ID_PAQUETE;
                             --'&' ||'P_ID_PAQUETE='||vRep_Endoso_Asis;
                    
                    ADD_REPORTE_ZIP_(l_url, 'ENDOSO_ASISTENCIA_'||vPoliza|| '_' || I.DESCVALLST || '.pdf', l_zip_blob,null, l_pdf_size, l_tiene_texto);
        
        
                    END LOOP;
        
                    --http://sicascloud:8889/reports/rwservlet/?keyreportappx&report=ENDASISM.rep&P_POLIZA=77622&P_CODCIA=1&P_PAQUETE=P4          
                   
                 
                    l_idx := l_idx + 1;
                    l_reportes(l_idx)    := 'P138_REP_ENDOSO_ASIS';
                    l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
                    l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
                    GENERA_KITEMISION('ENDASISM.rep', 1, vPoliza, vUsuario);
                    */
                    
                    --JJG Reporte de Clausulas Asistencias
                        FOR paquete IN (
                                    SELECT DISTINCT
                                           VL.CodValor   AS Id_Paquete,
                                           TRIM(VL.DescValLst) AS Titulo_Reporte
                                      FROM Valores_De_Listas VL,
                                           Clausulas_Poliza CL
                                     WHERE VL.CodLista      = 'PAQUEASIS'
                                       AND VL.Cve_Cnsf      IS NOT NULL
                                       AND CL.Tipo_Clausula = VL.Cve_Cnsf
                                       AND CL.CodCia        = 1
                                       AND CL.IdPoliza      = vPoliza
                                     ORDER BY VL.CodValor
                                )
                                LOOP
                                    l_titulo_archivo :=
                                    TRANSLATE(
                                        UPPER(TRIM(paquete.Titulo_Reporte)),
                                        'ÁÉÍÓÚÜÑ',
                                        'AEIOUUN'
                                    );
                                    l_nombre_archivo :=
                                           vPoliza
                                        || '_Endoso_Asistencia_'
                                        || l_titulo_archivo
                                        || '.PDF';

                                   l_url := 'http://sicascloud:8081/jasperserver/rest_v2/reports/Clausula_Asistencia/ENDASIS_CLAU.pdf?IDPOLIZA='||
                                   vPoliza || 
                                   '&'||'CODCIA=1' ||
                                   '&' || 'ID_PAQUETE=' || paquete.Id_Paquete ||  v_credenciales_j;
 
                                   ADD_REPORTE_ZIP_(l_url, l_nombre_archivo, l_zip_blob, NULL,l_pdf_size, l_tiene_texto);
                                   l_idx := l_idx + 1;
                                   l_reportes(l_idx)    := 'P138_REP_ENDOSO_ASIS';
                                   l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
                                   l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
                                   GENERA_KITEMISION('ENDASIS_CLAU.rep', 1, vPoliza, vUsuario);
                                END LOOP;
                    
                    
                END IF;
            END IF;
               -- AUTOADMINISTRADAS
               IF vRep_Auto_Admin = 'S' THEN
            l_url := C_URL_BASE ||
                      '?keyreportappx'||
                      '&' ||'report=AUTOADMI.rep'||
                      '&' ||'P_CODCIA=1'||
                      '&' ||'P_CODEMPRESA=1'||
                      '&' ||'P_IDPOLIZA='||vPoliza;

            ADD_REPORTE_ZIP_(l_url, 'POLIZAS_AUTOADMINISTRADAS_'||vPoliza||'.pdf', l_zip_blob, null,l_pdf_size, l_tiene_texto);
            l_idx := l_idx + 1;
            l_reportes(l_idx)    := 'P138_REP_AUTO_ADMIN';
            l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
            l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
            GENERA_KITEMISION('AUTOADMI.rep', 1, vPoliza, vUsuario);
        END IF;

               -- CONDICIONES ESPECIALES
               IF vRep_Cond_Especiales = 'S' THEN
            l_url := C_URL_BASE ||
                      '?keyreportappx'||
                      '&' ||'report=ENDOCLAU.rep'||
                      '&' ||'P_CODCIA=1'||
                      '&' ||'P_IDPOLIZA='||vPoliza;

            ADD_REPORTE_ZIP_(l_url, 'CONDICIONES_ESPECIALES_'||vPoliza||'.pdf', l_zip_blob, null,l_pdf_size, l_tiene_texto);
            l_idx := l_idx + 1;
            l_reportes(l_idx)    := 'P138_REP_COND_ESPECIALES';
            l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
            l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
            GENERA_KITEMISION('ENDOCLAU.rep', 1, vPoliza, vUsuario);
        END IF;

               -- ENDOSO GENERAL
               IF vRep_Endoso_Gral = 'S' THEN
            l_url := C_URL_BASE ||
                      '?keyreportappx'||
                      '&' ||'report=ENDOSOS.rep'||
                      '&' ||'P_POLIZA='||vPoliza||
                      '&' ||'P_CODCIA=1'||
                      '&' ||'P_IDENDOSO='||vEndoso_Fin;

            ADD_REPORTE_ZIP_(l_url, 'ENDOSO_GENERAL_'||vPoliza||'.pdf', l_zip_blob,null, l_pdf_size, l_tiene_texto);
            l_idx := l_idx + 1;
            l_reportes(l_idx)    := 'P138_REP_ENDOSO_GRAL';
            l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
            l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
            GENERA_KITEMISION('ENDOSOS.rep', 1, vPoliza, vUsuario);
        END IF;

               -- AVISO COBRO
               IF vRep_Aviso_Cobro = 'S' THEN
            l_url := C_URL_BASE ||
                      '?keyreportappx'||
                      '&' ||'report=AviCob.rep'||
                      '&' ||'P_CODCIA=1'||
                      '&' ||'P_POLIZA='||vPoliza||
                      '&' ||'P_IDETPOLINI='||vDet_Ini||
                      '&' ||'P_IDETPOLFIN='||vDet_Fin||
                      '&' ||'P_ENDOSOINI='||vEndoso_Ini||
                      '&' ||'P_ENDOSOFIN='||vEndoso_Fin;

            ADD_REPORTE_ZIP_(l_url, 'AVISO_COBRO_'||vPoliza||'.pdf', l_zip_blob,null, l_pdf_size, l_tiene_texto);
            l_idx := l_idx + 1;
            l_reportes(l_idx)    := 'P138_REP_AVISO_COBRO';
            l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
            l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
            GENERA_KITEMISION('AviCob.rep', 1, vPoliza, vUsuario);
        END IF;

               -- APORTE REGULAR
               IF vRep_Aporte_Reg = 'S' THEN
            l_url := C_URL_BASE ||
                      '?keyreportappx'||
                      '&' ||'report=APORTREG.rep'||
                      '&' ||'P_CODCIA=1'||
                      '&' ||'P_POLIZA='||vPoliza||
                      '&' ||'P_IDETPOLINI='||vDet_Ini||
                      '&' ||'P_IDETPOLFIN='||vDet_Fin;

            ADD_REPORTE_ZIP_(l_url, 'APORTE_REGULAR_'||vPoliza||'.pdf', l_zip_blob, null,l_pdf_size, l_tiene_texto);
            l_idx := l_idx + 1;
            l_reportes(l_idx)    := 'P138_REP_APORTE_REG';
            l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
            l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
            GENERA_KITEMISION('APORTREG.rep', 1, vPoliza, vUsuario);
        END IF;

               -- AVISO DEVOLUCION
               IF vRep_Aviso_Dev = 'S' THEN
            l_url := C_URL_BASE ||
                      '?keyreportappx'||
                      '&' ||'report=AVIDEVOL.rep'||
                      '&' ||'P_CODCIA=1'||
                      '&' ||'P_POLIZA='||vPoliza||
                      '&' ||'P_IDETPOLINI='||vDet_Ini||
                      '&' ||'P_IDETPOLFIN='||vDet_Fin||
                      '&' ||'P_ENDOSOINI='||vEndoso_Ini||
                      '&' ||'P_ENDOSOFIN='||vEndoso_Fin;

            ADD_REPORTE_ZIP_(l_url, 'AVISO_DEVOLUCION_'||vPoliza||'.pdf', l_zip_blob, null,l_pdf_size, l_tiene_texto);
            l_idx := l_idx + 1;
            l_reportes(l_idx)    := 'P138_REP_AVISO_DEV';
            l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
            l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
            GENERA_KITEMISION('AVIDEVOL.rep', 1, vPoliza, vUsuario);
        END IF;

               -- APORTE EXTRA
               IF vRep_Aporte_Extra = 'S' THEN
            l_url := C_URL_BASE ||
                      '?keyreportappx'||
                      '&' ||'report=APORTEXT.rep'||
                      '&' ||'P_CODCIA=1'||
                      '&' ||'P_POLIZA='||vPoliza||
                      '&' ||'P_IDETPOLINI='||vDet_Ini||
                      '&' ||'P_IDETPOLFIN='||vDet_Fin;

            ADD_REPORTE_ZIP_(l_url, 'APORTE_EXTRAORDINARIO_'||vPoliza||'.pdf', l_zip_blob,null, l_pdf_size, l_tiene_texto);
            l_idx := l_idx + 1;
            l_reportes(l_idx)    := 'P138_REP_APORTE_EXTRA';
            l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
            l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
            GENERA_KITEMISION('APORTEXT.rep', 1, vPoliza, vUsuario);
        END IF;

               -- FONDO COLECTIVO
             IF vRep_Fondo_Colec = 'S' THEN


               AGREGA_FONDO_ZIP(
                        p_poliza      => TO_CHAR(vPoliza),
                        p_det_ini     => TO_CHAR(vDet_Ini),
                        p_det_fin     => TO_CHAR(vDet_Fin),
                        p_endoso_ini  => TO_CHAR(vEndoso_Ini),
                        p_endoso_fin  => TO_CHAR(vEndoso_Fin),
                        p_usuario     => vUsuario,
                        vCH_Regla     => vCH_Regla,
                        vCH_Suma      => vCH_Suma,
                        p_zip_blob    => l_zip_blob,
                        p_count       => nnum_cert,
                        p_tiene_texto => l_tiene_texto,
                        P_Aseg_Ini               => vAseg_Ini,
                        P_vAseg_Fin => vAseg_FiN,
                        p_fecini => vFecha_Ini
                    );

            l_idx := l_idx + 1;
            l_reportes(l_idx)    := 'P138_REP_FONDO_COLEC';
            l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
            l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
            GENERA_KITEMISION('ESCTFOCO.rep', 1, vPoliza, vUsuario);
        END IF;

               -- CERTIFICADO INDIVIDUAL POR BLOQUES
               IF vRep_Cer_Ind_Bloque = 'S' THEN
                   IF vl_IsGMPRTEC = 1 THEN    
                    IF vCH_Regla = 'S' THEN
                        --Certificado 2026                    
                            l_url :=v_jasper||'Caratulas_2026_1/CER_IND_GMPRO.pdf?IDPOLIZA=' || vPoliza ||  
                            '&'||'IDETPOLINI=' || vDet_Ini      || 
                            '&'||'IDETPOLFIN=' || vDet_Fin      ||
                            '&'||'CODASEGINI=' || vAseg_Ini     ||
                            '&'||'CODASEGFIN=' || vAseg_FiN     ||
                            '&'||'ENDOSOINI='  || vEndoso_Ini   ||
                            '&'||'ENDOSOFIN='  || vEndoso_Fin   ||  
                            v_credenciales_j;
                            
                         ADD_REPORTE_ZIP_(l_url, 'CER_INDIVIDUAL_BLOQUES_'||vPoliza||'.pdf', l_zip_blob,NULL, l_pdf_size, l_tiene_texto);
                         l_idx := l_idx + 1;
                        l_reportes(l_idx)    := 'P138_REP_CER_IND_BLOQUE';
                        l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
                        l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
                        GENERA_KITEMISION('CERTIND.rep', 1, vPoliza, vUsuario);
                    ELSE
                        l_url :=  v_jasper|| 'Caratulas_2026_1/CER_IND_RSA_PO_GMPRO.pdf?IDPOLIZA=' || vPoliza ||  
                        '&'||'IDETPOLINI=' || vDet_Ini      || 
                        '&'||'IDETPOLFIN=' || vDet_Fin      ||
                        '&'||'CODASEGINI=' || vAseg_Ini     ||
                        '&'||'CODASEGFIN=' || vAseg_FiN     ||
                        '&'||'ENDOSOINI='  || vEndoso_Ini   ||
                        '&'||'ENDOSOFIN='  || vEndoso_Fin   ||  
                        v_credenciales_j;
                        
                        ADD_REPORTE_ZIP_(l_url, 'CER_INDIVIDUAL_BLOQUES_'||vPoliza||'.pdf', l_zip_blob, NULL,l_pdf_size, l_tiene_texto);
                        l_idx := l_idx + 1;
                        l_reportes(l_idx)    := 'P138_REP_CER_IND_BLOQUE';
                        l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
                        l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
                        GENERA_KITEMISION('CERTIND.rep', 1, vPoliza, vUsuario);
                        
                    END IF;
                ELSE
                      AGREGA_BLOQUE_ZIP(
                                p_poliza      => TO_CHAR(vPoliza),
                                p_det_ini     => TO_CHAR(vDet_Ini),
                                p_det_fin     => TO_CHAR(vDet_Fin),
                                p_endoso_ini  => TO_CHAR(vEndoso_Ini),
                                p_endoso_fin  => TO_CHAR(vEndoso_Fin),
                                p_usuario     => vUsuario,
                                vCH_Regla     => vCH_Regla,
                                vCH_Suma      => vCH_Suma,
                                p_zip_blob    => l_zip_blob,
                                p_count       => nnum_cert,
                                p_tiene_texto => l_tiene_texto,
                                P_Aseg_Ini    => vAseg_Ini,
                                P_vAseg_Fin => vAseg_FiN
                            );      
                    l_idx := l_idx + 1;
                    l_reportes(l_idx)    := 'P138_REP_CER_IND_BLOQUE';
                    l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
                    l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
                    GENERA_KITEMISION('CERTIND.rep', 1, vPoliza, vUsuario);
                END IF;
        END IF;

               -- CERTIFICADO INDIVIDUAL POR ASEGURADO
               IF vRep_Cer_Ind_aseg = 'S' THEN
                         AGREGA_CERTIFICADOS_ZIP(
                        p_poliza      => TO_CHAR(vPoliza),
                        p_det_ini     => TO_CHAR(vDet_Ini),
                        p_det_fin     => TO_CHAR(vDet_Fin),
                        p_endoso_ini  => TO_CHAR(vEndoso_Ini),
                        p_endoso_fin  => TO_CHAR(vEndoso_Fin),
                        p_usuario     => vUsuario,
                        vCH_Regla     => vCH_Regla,
                        vCH_Suma      => vCH_Suma,
                        p_zip_blob    => l_zip_blob,
                        p_count       => nnum_cert,
                        p_tiene_texto => l_tiene_texto,
                        P_Aseg_Ini               => vAseg_Ini,
                        P_vAseg_Fin => vAseg_FiN
                    );
                    l_idx := l_idx + 1;
                    l_reportes(l_idx)    := 'P138_REP_CER_IND_ASEG';
                    l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
                    l_colores_arr(l_idx) := CASE WHEN l_tiene_texto THEN '#0AC756' ELSE '#ff0000' END;
                    GENERA_KITEMISION('CERTINDI', 1, vPoliza, vUsuario);
                END IF;

               -- CONDICIONES GENERALES (archivo estático desde APEX)
               IF vRep_Condiciones_Gral = 'S' THEN
            SELECT BLOB_CONTENT, DOC_SIZE
            INTO   l_file_blob, l_sizes_cond
            FROM   apex_application_files
            WHERE  FILENAME = 'ARCH_GENERALES/' || vRep_ARCHIVO_Condiciones_Gral;

            APEX_ZIP.ADD_FILE(
                p_zipped_blob => l_zip_blob,
                p_file_name   => vRep_ARCHIVO_Condiciones_Gral,
                p_content     => l_file_blob
            );
            l_idx := l_idx + 1;
            l_reportes(l_idx)    := 'P138_REP_CONDICIONES_GRAL';
            l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_file_blob);
            l_colores_arr(l_idx) := '#0AC756';
            GENERA_KITEMISION('CONDGENE', 1, vPoliza, vUsuario);
        END IF;

               -- RECIBOS FACTURA ELECTRONICA
            IF vRep_Rec_Fact_Elec = 'S' THEN

                    DECLARE
                        v_pdf_blob_fe    BLOB;
                        v_xml_blob_fe    BLOB;
                        v_IDAGRUPAENV    NUMBER;
                        v_filename_fe    VARCHAR2(200);
                        v_count_fe       NUMBER  := 0;
                        v_count_ok       NUMBER  := 0;
                        v_count_err      NUMBER  := 0;
                        vl_dest          INTEGER := 1;
                        vl_src           INTEGER := 1;
                        l_lang_ctx_fe    INTEGER := DBMS_LOB.default_lang_ctx;
                        l_warning_fe     INTEGER;
                        vLeidos          NUMBER;
                        vIncorrectos     NUMBER;
                        vCorrectos       NUMBER;
                        vTextoSalida     VARCHAR2(4000);
                        vIdAgrupaEnv     NUMBER;
                        vResultado       VARCHAR2(1);
                        v_IDFACTURA      NUMBER;
                        v_archivo_id_ant NUMBER;
                        v_archivo_id_nvo NUMBER;
                        v_txt_blob_fe    BLOB;
                        v_nombre_arch    VARCHAR2(200);
                        v_docs_generados NUMBER := 0;  
                        cCodUser            VARCHAR2(30); 




                        CURSOR CONSULTA IS
                            SELECT F.IDFACTURA, F.NUMCUOTA,
                                   T.IDAGRUPAENV, T.DOCTOPDF, T.DOCTOXML, T.NOMBARCHZIP
                            FROM   FACTURAS F
                            LEFT JOIN FACT_ELECT_DOCTOS_TIMBRE T ON T.IDFACTURA = F.IDFACTURA
                            WHERE  F.IDPOLIZA = vPoliza
                            AND F.IDENDOSO BETWEEN vEndoso_Ini AND vEndoso_Fin
                            ORDER  BY F.NUMCUOTA;

                    BEGIN
                            SELECT COALESCE(
                                       SYS_CONTEXT('APEX$SESSION','APP_USER'),
                                       SYS_CONTEXT('USERENV','SESSION_USER'),
                                       USER
                                   ) || '_' || SYS_CONTEXT('USERENV','SESSIONID')
                            INTO   cCodUser
                            FROM   DUAL;

                        BEGIN
                            SELECT NVL(MAX(ARCHIVO_ID), 0)
                            INTO   v_archivo_id_ant
                            FROM   TEMP_GEN_ARCHIVO;
                        EXCEPTION
                            WHEN OTHERS THEN v_archivo_id_ant := 0;
                        END;

                        BEGIN
                            vResultado := OC_FACT_ELECT_CONF_DOCTO.Genera_Fact_Elect(
                                                cGenerar      => 'FAC',
                                                nCodCia       => 1,
                                                nCodEmpresa   => 1,
                                                nIdPoliza     => vPoliza,
                                                cIndFactElec  => 'S',
                                                nLeidos       => vLeidos,
                                                nIncorrectos  => vIncorrectos,
                                                nCorrectos    => vCorrectos,
                                                cTextoSalida  => vTextoSalida,
                                                nIdAgrupaEnv  => vIdAgrupaEnv
                                            );
                        EXCEPTION
                            WHEN OTHERS THEN
                                IF SQLCODE = -6503 THEN
                                    vResultado   := NULL;
                                    vTextoSalida := NVL(vTextoSalida, SQLERRM);
                                ELSE
                                    RAISE;  -- Cualquier otro error se propaga normalmente
                                END IF;
                        END;

                        BEGIN
                            SELECT NVL(MAX(ARCHIVO_ID), 0)
                            INTO   v_archivo_id_nvo
                            FROM   TEMP_GEN_ARCHIVO
                            WHERE  ARCHIVO_ID > v_archivo_id_ant
                            AND   REGEXP_SUBSTR(NOMBREARCHIVO, '_([^_]+)_\d{7}_', 1,1,'i',1) = vUsuario;
                        EXCEPTION
                            WHEN OTHERS THEN v_archivo_id_nvo := 0;
                        END;


                        IF vResultado IS NULL THEN
                            BEGIN
                                SELECT COUNT(*)
                                INTO   v_docs_generados
                                FROM   FACT_ELECT_DOCTOS_TIMBRE T
                                JOIN   FACTURAS F ON F.IDFACTURA = T.IDFACTURA
                                WHERE  F.IDPOLIZA = vPoliza
                                AND    (T.DOCTOPDF IS NOT NULL OR T.DOCTOXML IS NOT NULL);
                            EXCEPTION
                                WHEN OTHERS THEN v_docs_generados := 0;
                            END;

                            IF v_docs_generados > 0 THEN
                                vResultado := 'S';  
                            END IF;
                        END IF;

                        IF NVL(vResultado, 'N') <> 'S' THEN
                            RAISE_APPLICATION_ERROR(-20004,
                                'Error al Generar Facturación Electrónica: ' || vTextoSalida);
                        END IF;

                        FOR factura IN CONSULTA LOOP
                            v_count_fe    := v_count_fe + 1;
                            v_IDAGRUPAENV := factura.IDAGRUPAENV;
                            v_IDFACTURA   := factura.IDFACTURA;
                            v_filename_fe := 'FACTURA_' || NVL(TO_CHAR(v_IDFACTURA), TO_CHAR(v_count_fe));

                            -- PDF al ZIP
                            IF factura.DOCTOPDF IS NOT NULL THEN
                                v_pdf_blob_fe := APEX_WEB_SERVICE.clobbase642blob(factura.DOCTOPDF);
                                IF DBMS_LOB.GETLENGTH(v_pdf_blob_fe) > 0 THEN
                                    APEX_ZIP.ADD_FILE(
                                        p_zipped_blob => l_zip_blob,
                                        p_file_name   => v_filename_fe || '.pdf',
                                        p_content     => v_pdf_blob_fe);
                                END IF;
                            END IF;

                            -- XML al ZIP
                            IF factura.DOCTOXML IS NOT NULL THEN
                                DBMS_LOB.createtemporary(v_xml_blob_fe, FALSE);
                                vl_dest := 1; vl_src := 1;
                                DBMS_LOB.converttoblob(
                                    dest_lob     => v_xml_blob_fe,
                                    src_clob     => factura.DOCTOXML,
                                    amount       => DBMS_LOB.lobmaxsize,
                                    dest_offset  => vl_dest,
                                    src_offset   => vl_src,
                                    blob_csid    => DBMS_LOB.default_csid,
                                    lang_context => l_lang_ctx_fe,
                                    warning      => l_warning_fe);
                                IF DBMS_LOB.GETLENGTH(v_xml_blob_fe) > 0 THEN
                                    APEX_ZIP.ADD_FILE(
                                        p_zipped_blob => l_zip_blob,
                                        p_file_name   => v_filename_fe || '.xml',
                                        p_content     => v_xml_blob_fe);
                                END IF;
                                DBMS_LOB.freetemporary(v_xml_blob_fe);
                            END IF;

                            IF factura.DOCTOPDF IS NOT NULL OR factura.DOCTOXML IS NOT NULL THEN
                                v_count_ok := v_count_ok + 1;
                            ELSE
                                v_count_err := v_count_err + 1;
                            END IF;

                        END LOOP;

                        l_idx := l_idx + 1;
                        l_reportes(l_idx)    := 'P138_REP_REC_FACT_ELEC';
                        l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
                        l_colores_arr(l_idx) := CASE WHEN v_count_ok > 0 THEN '#0AC756' ELSE '#ff0000' END;

                        GENERA_KITEMISION('INDFACTELEC', 1, vPoliza, vUsuario);


                        BEGIN
                            BEGIN
                                SELECT DATA,
                                       NVL(NOMBREARCHIVO, 'FACT_ELECT_' || TO_CHAR(vPoliza) || '.txt')
                                INTO   v_txt_blob_fe,
                                       v_nombre_arch
                                FROM   TEMP_GEN_ARCHIVO
                                WHERE  ARCHIVO_ID = (
                                    SELECT MAX(ARCHIVO_ID)
                                    FROM   TEMP_GEN_ARCHIVO
                                    WHERE  ARCHIVO_ID > v_archivo_id_ant
                                     AND   REGEXP_SUBSTR(NOMBREARCHIVO, '_([^_]+)_\d{7}_', 1,1,'i',1) = vUsuario
                                );
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                    v_txt_blob_fe := NULL;
                                    v_nombre_arch := 'FACT_ELECT_' || TO_CHAR(vPoliza) || '.txt';
                                WHEN TOO_MANY_ROWS THEN
                                    -- No debería ocurrir con MAX(), pero por seguridad
                                    v_txt_blob_fe := NULL;
                            END;

                            IF v_txt_blob_fe IS NOT NULL
                               AND DBMS_LOB.GETLENGTH(v_txt_blob_fe) > 0 THEN
                                APEX_ZIP.ADD_FILE(
                                    p_zipped_blob => l_zip_blob,
                                    p_file_name   => v_nombre_arch,
                                    p_content     => v_txt_blob_fe);
                            END IF;
                        END;

                    EXCEPTION
                        WHEN OTHERS THEN
                            IF SQLCODE = -20876 THEN RAISE; END IF;
                            RAISE_APPLICATION_ERROR(-20003,
                                'Error en FACT_ELECT: ' || SQLERRM ||
                                ' | Backtrace: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
                    END;

                END IF;                                       
                commit;




 DECLARE
            l_url_kit   VARCHAR2(2000);
            l_size_kit  NUMBER;
            l_texto_kit BOOLEAN;
        BEGIN
            l_url_kit := C_URL_BASE ||'?keyflex'
             ||'&'||'report=KITEMISI_APPX.rep'||
             '&' ||'P_CODCIA=1'||
             '&' ||'P_POLIZA='||vPoliza||
             '&' ||'P_USUARIO='||vUsuario||
             '&' || 'P_COD_VALOR='|| VCOD_PAQ;

            ADD_REPORTE_ZIP_(l_url_kit, 'KIT_EMISION_'||vPoliza||'.pdf', l_zip_blob,NULL ,l_size_kit, l_texto_kit);


            l_idx := l_idx + 1;
            l_reportes(l_idx)    := 'P138_KIT_EMISION';
            l_sizes(l_idx)       := DBMS_LOB.GETLENGTH(l_zip_blob);
            l_colores_arr(l_idx) := CASE WHEN l_texto_kit THEN '#0AC756' ELSE '#ff0000' END;
        END;

               -- CIERRE DEL ZIP E INSERT EN TABLA
               APEX_ZIP.FINISH(l_zip_blob);
        l_zip_size := DBMS_LOB.GETLENGTH(l_zip_blob);

        IF l_reportes.COUNT > 0 THEN
            FOR i IN 1 .. l_reportes.COUNT LOOP
                l_nombres := l_nombres || CASE WHEN l_nombres IS NOT NULL THEN ',' ELSE '' END || l_reportes(i);
                l_tamanos := l_tamanos || CASE WHEN l_tamanos IS NOT NULL THEN ',' ELSE '' END || TO_CHAR(l_sizes(i));
                l_colores := l_colores || CASE WHEN l_colores IS NOT NULL THEN ',' ELSE '' END || l_colores_arr(i);
            END LOOP;
        END IF;

        INSERT INTO REPORTES_PDF
        ( 
            ID, 
            NOMBRE, 
            ARCHIVO, 
            CODUSUARIO,
            FECHA, 
            TAMANO_ARCHIVO,
            NOMBRE_ARCHIVO,
            COLOR, 
            MIMETYPE
        )
        VALUES (SEQ_REPORTES_PDF.NEXTVAL,
                'PAPELERIA_POLIZA_'||vPoliza||'.zip',
                l_zip_blob, vUsuario, SYSDATE,
                l_tamanos, l_nombres, l_colores, 'application/x-zip-compressed');

        COMMIT;

    END GENERA_REPORTE;


    -- GENERA_ZIP

    PROCEDURE GENERA_ZIP (vID_Reporte IN NUMBER) IS
        l_blob   BLOB;
        l_nombre VARCHAR2(500);
        l_size   INTEGER;
    BEGIN
        SELECT ARCHIVO, NOMBRE, TAMANO_ARCHIVO
        INTO l_blob, l_nombre, l_size
        FROM REPORTES_PDF WHERE ID = vID_Reporte
            AND CODUSUARIO = NVL(V('APP_USER'), USER);

        IF l_blob IS NULL OR l_size IS NULL OR l_size <= 54 THEN
            htp.init;
            owa_util.mime_header('text/plain', FALSE);
            owa_util.http_header_close;
            htp.p('El archivo ZIP está vacío, no se puede descargar.');
            apex_application.stop_apex_engine;
            RETURN;
        END IF;

        owa_util.mime_header('application/zip', FALSE);
        htp.p('Content-Disposition: attachment; filename="'||l_nombre||'"');
        htp.p('Content-Length: '||l_size);
        htp.p('Cache-Control: no-store');
        htp.p('Pragma: no-cache');
        owa_util.http_header_close;
        wpg_docload.download_file(l_blob);
        apex_application.stop_apex_engine;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            htp.init;
            owa_util.mime_header('text/plain', FALSE);
            owa_util.http_header_close;
            htp.p('NO se Encontró el Archivo.');
            apex_application.stop_apex_engine;
    END GENERA_ZIP;




    -- GENERA_KITEMISION

    PROCEDURE GENERA_KITEMISION(
        cNombRepor VARCHAR2,
        nActTabla  NUMBER,
        vPoliza    NUMBER,
        vUsuario   VARCHAR2 DEFAULT NULL
    ) IS
        cDescReporte VARCHAR2(100);
    BEGIN
    
        BEGIN
            SELECT Descripcion 
            INTO cDescReporte 
            FROM REPORTE 
            WHERE Reporte = cNombRepor;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN cDescReporte := NULL;
        END;
                CASE cNombRepor
                    WHEN 'POLIZAVG.rep' THEN cDescReporte := 'PÓLIZA VIDA GRUPO';
                    WHEN 'POLIZACA.rep' THEN cDescReporte := 'PÓLIZA ACCIDENTES COLECTIVOS';
                    WHEN 'POLCASUB.rep' THEN cDescReporte := 'ACCIDENTES COLECTIVOS SUBGRUPO';
                    WHEN 'POLIZAVI.rep' THEN cDescReporte := 'PÓLIZA INDIVIDUAL';
                    WHEN 'POLIZAVF.rep' THEN cDescReporte := 'PÓLIZA VIDA FLEX';
                    WHEN 'CONSIND.rep'  THEN cDescReporte := 'CONSENTIMIENTO INDIVIDUAL';
                    WHEN 'LSTASEG.rep'  THEN cDescReporte := 'LISTADO ASEGURADOS CON PRIMA';
                    WHEN 'LSTASESP.rep' THEN cDescReporte := 'LISTADO ASEGURADOS SIN PRIMA';
                    WHEN 'CARTABIE.rep' THEN cDescReporte := 'CARTA DE BIENVENIDA';
                    WHEN 'CARSINVI.rep' THEN cDescReporte := 'CARTA SINIESTRO VIDA';
                    WHEN 'CARSINAP.rep' THEN cDescReporte := 'CARTA SINIESTRO AP';
                    WHEN 'ENDASISM.rep' THEN cDescReporte := 'ENDOSO ASISTENCIA';
                    WHEN 'AUTOADMI.rep' THEN cDescReporte := 'PÓLIZAS AUTOADMINISTRADAS';
                    WHEN 'ENDOCLAU.rep' THEN cDescReporte := 'CONDICIONES ESPECIALES';
                    WHEN 'ENDOSOS.rep'  THEN cDescReporte := 'ENDOSO GENERAL';
                    WHEN 'AviCob.rep'   THEN cDescReporte := 'AVISO DE COBRO';
                    WHEN 'APORTREG.rep' THEN cDescReporte := 'APORTE REGULAR';
                    WHEN 'AVIDEVOL.rep' THEN cDescReporte := 'AVISO DE DEVOLUCIÓN';
                    WHEN 'APORTEXT.rep' THEN cDescReporte := 'APORTE EXTRAORDINARIO';
                    WHEN 'ESCTFOCO.rep' THEN cDescReporte := 'FONDO COLECTIVO';
                    WHEN 'CERTIND.rep'  THEN cDescReporte := 'CERTIFICADO INDIVIDUAL POR BLOQUES';
                    WHEN 'CERTINDI'     THEN cDescReporte := 'CERTIFICADO INDIVIDUAL X ASEGURADO';
                    WHEN 'CONDGENE'     THEN cDescReporte := 'CONDICIONES GENERALES';
                    WHEN 'INDFACTELEC'  THEN cDescReporte := 'RECIBOS FACT. ELECTRÓNICA';
                    ELSE                     cDescReporte := cNombRepor;
                END CASE;

        BEGIN
            INSERT INTO LISTADO_KITEMISION
                (IDPOLIZA, REPORTE, DESCRIPCION, CODVALOR, DESCVALLST,
                 ACTUALIZO_USUARIO, ACTUALIZO_FECHA)
            VALUES

                (vPoliza, cNombRepor, cDescReporte, '', '',
                 NVL(vUsuario, USER), SYSDATE);
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                UPDATE LISTADO_KITEMISION
                   SET DESCRIPCION       = cDescReporte,
                       CODVALOR          = '',
                       DESCVALLST        = '',
                       ACTUALIZO_USUARIO = NVL(vUsuario, USER),
                       ACTUALIZO_FECHA   = SYSDATE
                 WHERE IDPOLIZA = vPoliza
                   AND REPORTE  = cNombRepor;
        END;

    END GENERA_KITEMISION;


    PROCEDURE AGREGA_CONSENTIMIENTOS_ZIP (
    p_poliza      VARCHAR2,
    p_det_ini     VARCHAR2,
    p_det_fin     VARCHAR2,
    p_endoso_ini  VARCHAR2,
    p_endoso_fin  VARCHAR2,
    p_usuario     VARCHAR2,
    vCH_Regla     VARCHAR2,
    p_zip_blob    IN OUT NOCOPY BLOB,   
    p_count       OUT NUMBER,           
    p_tiene_texto OUT BOOLEAN,           -- si al menos uno tuvo contenid
    P_Aseg_Ini NUMBER,
    P_vAseg_Fin NUMBER 

) IS
    l_pdf_temp  BLOB;
    l_raw       RAW(32767);
    l_req       UTL_HTTP.REQ;
    l_resp      UTL_HTTP.RESP;
    v_url       VARCHAR2(4000);
    v_nombre_pdf VARCHAR2(255);
    nnum        NUMBER := 0;



BEGIN
    p_count       := 0;
    p_tiene_texto := FALSE;

    FOR i IN (
        SELECT COD_ASEGURADO
          FROM ASEGURADO_CERTIFICADO
         WHERE IDPOLIZA = p_poliza
           AND COD_ASEGURADO BETWEEN NVL(P_Aseg_Ini,1)
                             AND NVL(P_vAseg_FIN,9999999999)

    ) LOOP

        -- Construir URL según regla
        IF vCH_Regla = 'S' THEN
          v_url := v_jasper
          || 'Cert_Cons_Asegurados/CON_IND_ASE_PO_SUMA.pdf'
          || '?IDPOLIZA='   || p_poliza
          || '&' || 'IDETPOLINI=' || p_det_ini
          || '&' || 'IDETPOLFIN=' || p_det_fin
          || '&' || 'ENDOSOINI='  || p_endoso_ini
          || '&' || 'ENDOSOFIN='  || p_endoso_fin
          || '&' || 'CODASEGMIN=' || i.COD_ASEGURADO 
          || '&' || 'CODASEGMAX=' || i.COD_ASEGURADO  
          || v_credenciales_j;
        ELSE
            v_url :=  v_jasper
          || 'Cert_Cons_Asegurados/CON_IND_ASE_PO.pdf'
          || '?IDPOLIZA='   || p_poliza
          || '&' || 'IDETPOLINI=' || p_det_ini
          || '&' || 'IDETPOLFIN=' || p_det_fin
          || '&' || 'ENDOSOINI='  || p_endoso_ini
          || '&' || 'ENDOSOFIN='  || p_endoso_fin
          || '&' || 'CODASEGMIN=' || i.COD_ASEGURADO 
          || '&' || 'CODASEGMAX=' || i.COD_ASEGURADO  
          || v_credenciales_j;
        END IF;

        v_nombre_pdf := 'Consentimiento_' || i.COD_ASEGURADO || '.pdf';
        nnum := nnum + 1;

        -- Descargar PDF
        BEGIN
            DBMS_LOB.CREATETEMPORARY(l_pdf_temp, FALSE);

            l_req  := UTL_HTTP.BEGIN_REQUEST(v_url);
            UTL_HTTP.SET_TRANSFER_TIMEOUT(l_req, 60);
            l_resp := UTL_HTTP.GET_RESPONSE(l_req);

            LOOP
                UTL_HTTP.READ_RAW(l_resp, l_raw, 32767);
                DBMS_LOB.WRITEAPPEND(l_pdf_temp, UTL_RAW.LENGTH(l_raw), l_raw);
            END LOOP;

        EXCEPTION
            WHEN UTL_HTTP.END_OF_BODY THEN
                UTL_HTTP.END_RESPONSE(l_resp);
            WHEN OTHERS THEN
                IF l_resp.private_hndl IS NOT NULL THEN
                    UTL_HTTP.END_RESPONSE(l_resp);
                END IF;
        END;

        -- Agregar al ZIP principal si tiene contenido
        IF DBMS_LOB.GETLENGTH(l_pdf_temp) > 0 THEN
            APEX_ZIP.ADD_FILE(
                p_zipped_blob => p_zip_blob,        -- ZIP principal
                p_file_name   => v_nombre_pdf,
                p_content     => l_pdf_temp
            );
            p_count       := p_count + 1;
            p_tiene_texto := TRUE;
        END IF;

        DBMS_LOB.FREETEMPORARY(l_pdf_temp);

        IF MOD(nnum, 100) = 0 THEN COMMIT; END IF;

    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,
            'Error en AGREGA_CONSENTIMIENTOS_ZIP - ' || SQLERRM);
END AGREGA_CONSENTIMIENTOS_ZIP;


PROCEDURE AGREGA_CERTIFICADOS_ZIP (
    p_poliza      VARCHAR2,
    p_det_ini     VARCHAR2,
    p_det_fin     VARCHAR2,
    p_endoso_ini  VARCHAR2,
    p_endoso_fin  VARCHAR2,
    p_usuario     VARCHAR2,
    vCH_Regla     VARCHAR2,
    vCH_Suma      VARCHAR2,
    p_zip_blob    IN OUT NOCOPY BLOB,
    p_count       OUT NUMBER,
    p_tiene_texto OUT BOOLEAN,
    P_Aseg_Ini NUMBER,
    P_vAseg_Fin NUMBER 
) IS
    l_pdf_temp   BLOB;
    l_raw        RAW(32767);
    l_req        UTL_HTTP.REQ;
    l_resp       UTL_HTTP.RESP;
    v_url        VARCHAR2(4000);
    v_nombre_pdf VARCHAR2(255);
    nnum         NUMBER := 0;


BEGIN
    p_count       := 0;
    p_tiene_texto := FALSE;


    FOR i IN (
        SELECT COD_ASEGURADO
          FROM ASEGURADO_CERTIFICADO
         WHERE IDPOLIZA = p_poliza
         AND COD_ASEGURADO 
         BETWEEN NVL(P_Aseg_Ini, 1)                           
                    AND NVL(P_vAseg_FIN, 9999999999)
    ) LOOP

        IF vCH_Regla = 'S' THEN
          v_url := v_jasper
              || 'Cert_Cons_Asegurados/CER_IND_ASE_PO_SUMA.pdf'
              || '?IDPOLIZA='   || p_poliza
              || '&' || 'IDETPOLINI=' || p_det_ini
              || '&' || 'IDETPOLFIN=' || p_det_fin
              || '&' || 'ENDOSOINI='  || p_endoso_ini
              || '&' || 'ENDOSOFIN='  || p_endoso_fin
              || '&' || 'CODASEGMIN=' || i.COD_ASEGURADO  
              || '&' || 'CODASEGMAX=' || i.COD_ASEGURADO  
              || v_credenciales_j;
        ELSE
            v_url := v_jasper
              || 'Cert_Cons_Asegurados/CER_IND_ASE_PO.pdf'
              || '?IDPOLIZA='   || p_poliza
              || '&' || 'IDETPOLINI=' || p_det_ini
              || '&' || 'IDETPOLFIN=' || p_det_fin
              || '&' || 'ENDOSOINI='  || p_endoso_ini
              || '&' || 'ENDOSOFIN='  || p_endoso_fin
              || '&' || 'CODASEGMIN=' || i.COD_ASEGURADO  
              || '&' || 'CODASEGMAX=' || i.COD_ASEGURADO  
              || v_credenciales_j;

        END IF;

        v_nombre_pdf := 'Certificado_' || i.COD_ASEGURADO || '.pdf';
        nnum := nnum + 1;

        BEGIN
            DBMS_LOB.CREATETEMPORARY(l_pdf_temp, FALSE);

            l_req  := UTL_HTTP.BEGIN_REQUEST(v_url);
            UTL_HTTP.SET_TRANSFER_TIMEOUT(l_req, 60);
            l_resp := UTL_HTTP.GET_RESPONSE(l_req);

            LOOP
                UTL_HTTP.READ_RAW(l_resp, l_raw, 32767);
                DBMS_LOB.WRITEAPPEND(l_pdf_temp, UTL_RAW.LENGTH(l_raw), l_raw);
            END LOOP;

        EXCEPTION
            WHEN UTL_HTTP.END_OF_BODY THEN
                UTL_HTTP.END_RESPONSE(l_resp);
            WHEN OTHERS THEN
                IF l_resp.private_hndl IS NOT NULL THEN
                    UTL_HTTP.END_RESPONSE(l_resp);
                END IF;
        END;

        IF DBMS_LOB.GETLENGTH(l_pdf_temp) > 0 THEN
            APEX_ZIP.ADD_FILE(
                p_zipped_blob => p_zip_blob,
                p_file_name   => v_nombre_pdf,
                p_content     => l_pdf_temp
            );
            p_count       := p_count + 1;
            p_tiene_texto := TRUE;
        END IF;

        DBMS_LOB.FREETEMPORARY(l_pdf_temp);

        IF MOD(nnum, 100) = 0 THEN COMMIT; END IF;

    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002,
            'Error en AGREGA_CERTIFICADOS_ZIP - ' || SQLERRM);
END AGREGA_CERTIFICADOS_ZIP;


PROCEDURE AGREGA_FONDO_ZIP (
    p_poliza      VARCHAR2,
    p_det_ini     VARCHAR2,
    p_det_fin     VARCHAR2,
    p_endoso_ini  VARCHAR2,
    p_endoso_fin  VARCHAR2,
    p_usuario     VARCHAR2,
    vCH_Regla     VARCHAR2,
    vCH_Suma      VARCHAR2,
    p_zip_blob    IN OUT NOCOPY BLOB,
    p_count       OUT NUMBER,
    p_tiene_texto OUT BOOLEAN,
    P_Aseg_Ini NUMBER,
    P_vAseg_Fin NUMBER,
    p_fecini DATE
) IS
    l_pdf_temp   BLOB;
    l_raw        RAW(32767);
    l_req        UTL_HTTP.REQ;
    l_resp       UTL_HTTP.RESP;
    v_url        VARCHAR2(4000);
    v_nombre_pdf VARCHAR2(255);
    nnum         NUMBER := 0;


BEGIN
    p_count       := 0;
    p_tiene_texto := FALSE;


    FOR i IN (
        SELECT COD_ASEGURADO
          FROM ASEGURADO_CERTIFICADO
         WHERE IDPOLIZA = p_poliza
         AND COD_ASEGURADO 
         BETWEEN NVL(P_Aseg_Ini, 1)                           
                    AND NVL(P_vAseg_FIN, 9999999999)
    ) LOOP


          v_url := v_jasper
              || 'Papeleria/ESCTFOCO.pdf?'
              || 'IDPOLIZA='   || p_poliza
              || '&' || 'IDETPOL=' || p_det_ini
              || '&' || 'COD_ASEGURADO=' || i.COD_ASEGURADO  
              || '&' || 'FECINI=' || p_fecini
              || v_credenciales_j;

        v_nombre_pdf := 'FONDO_COLECTIVO_' ||p_poliza||'_ASEG_'|| i.COD_ASEGURADO || '.pdf';
        nnum := nnum + 1;

        BEGIN
            DBMS_LOB.CREATETEMPORARY(l_pdf_temp, FALSE);

            l_req  := UTL_HTTP.BEGIN_REQUEST(v_url);
            UTL_HTTP.SET_TRANSFER_TIMEOUT(l_req, 60);
            l_resp := UTL_HTTP.GET_RESPONSE(l_req);

            LOOP
                UTL_HTTP.READ_RAW(l_resp, l_raw, 32767);
                DBMS_LOB.WRITEAPPEND(l_pdf_temp, UTL_RAW.LENGTH(l_raw), l_raw);
            END LOOP;

        EXCEPTION
            WHEN UTL_HTTP.END_OF_BODY THEN
                UTL_HTTP.END_RESPONSE(l_resp);
            WHEN OTHERS THEN
                IF l_resp.private_hndl IS NOT NULL THEN
                    UTL_HTTP.END_RESPONSE(l_resp);
                END IF;
        END;

        IF DBMS_LOB.GETLENGTH(l_pdf_temp) > 0 THEN
            APEX_ZIP.ADD_FILE(
                p_zipped_blob => p_zip_blob,
                p_file_name   => v_nombre_pdf,
                p_content     => l_pdf_temp
            );
            p_count       := p_count + 1;
            p_tiene_texto := TRUE;
        END IF;

        DBMS_LOB.FREETEMPORARY(l_pdf_temp);

        IF MOD(nnum, 100) = 0 THEN COMMIT; END IF;

    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002,
            'Error en AGREGA_FONDO_ZIP - ' || SQLERRM);
END AGREGA_FONDO_ZIP;

PROCEDURE AGREGA_BLOQUE_ZIP (
    p_poliza       VARCHAR2,
    p_det_ini      VARCHAR2,
    p_det_fin      VARCHAR2,
    p_endoso_ini   VARCHAR2,
    p_endoso_fin   VARCHAR2,
    p_usuario      VARCHAR2,
    vCH_Regla      VARCHAR2,
    vCH_Suma       VARCHAR2,
    p_zip_blob     IN OUT NOCOPY BLOB,
    p_count        OUT NUMBER,
    p_tiene_texto  OUT BOOLEAN,
    P_Aseg_Ini     NUMBER,
    P_vAseg_Fin    NUMBER
) IS
    l_pdf_temp       BLOB;
    l_raw            RAW(32767);
    l_req            UTL_HTTP.REQ;
    l_resp           UTL_HTTP.RESP;
    v_url            VARCHAR2(4000);
    v_nombre_pdf     VARCHAR2(255);
    v_nombre_reporte VARCHAR2(50);
    v_inicio         TIMESTAMP;
    l_ok             BOOLEAN := FALSE;
    l_total_bytes    NUMBER := 0;
    v_header_name    VARCHAR2(256);
    v_header_value   VARCHAR2(1024);
    l_content_length NUMBER;
BEGIN
    p_count       := 0;
    p_tiene_texto := FALSE;
 
 
  
    APEX_DEBUG.ENABLE(p_level => APEX_DEBUG.C_LOG_LEVEL_INFO);


    v_nombre_reporte := CASE WHEN vCH_Regla = 'S'
                                 THEN 'CER_IND_REGLA_PO.pdf'
                                 ELSE 'CER_IND_PO.pdf'
                            END;

    v_url := v_jasper || 'Certificados_y_Consentimientos/' || v_nombre_reporte ||
             '?IDPOLIZA='   || p_poliza ||
             '&'||'IDETPOLINI=' || p_det_ini ||
             '&'||'IDETPOLFIN=' || p_det_fin ||
             '&'||'CODASEGINI=' || P_Aseg_Ini ||
             '&'||'CODASEGFIN=' || P_vAseg_Fin ||
             '&'||'ENDOSOINI='  || p_endoso_ini ||
             '&'||'ENDOSOFIN='  || p_endoso_Fin ||
             v_credenciales_j;

    v_nombre_pdf := 'CER_INDIVIDUAL_BLOQUES_' || p_poliza || '.pdf';

    APEX_DEBUG.INFO('CER_INDIVIDUAL_BLOQUES - INICIO - poliza=%s det_ini=%s det_fin=%s endoso_ini=%s endoso_fin=%s',
        p_poliza, p_det_ini, p_det_fin, p_endoso_ini, p_endoso_fin);

    v_inicio := SYSTIMESTAMP;

    DBMS_LOB.CREATETEMPORARY(l_pdf_temp, TRUE);

    BEGIN
        l_req := UTL_HTTP.BEGIN_REQUEST(v_url);
        UTL_HTTP.SET_HEADER(l_req, 'User-Agent', 'Mozilla/4.0');

        UTL_HTTP.SET_PERSISTENT_CONN_SUPPORT(TRUE);

        UTL_HTTP.SET_TRANSFER_TIMEOUT(l_req, 5400);

        APEX_DEBUG.INFO(
            'CER_INDIVIDUAL_BLOQUES - ESPERANDO RESPUESTA DE JASPER - poliza=%s '||
            '(este paso puede tardar varios minutos, es normal no ver mas '||
            'mensajes hasta que Jasper responda)', p_poliza);

        l_resp := UTL_HTTP.GET_RESPONSE(l_req);

        APEX_DEBUG.INFO('CER_INDIVIDUAL_BLOQUES - RESPUESTA RECIBIDA - poliza=%s status=%s duracion_seg=%s',
            p_poliza, l_resp.status_code,
            ROUND(EXTRACT(SECOND FROM (SYSTIMESTAMP - v_inicio)) +
                  EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_inicio))*60, 1));

        FOR j IN 1..UTL_HTTP.GET_HEADER_COUNT(l_resp) LOOP
            UTL_HTTP.GET_HEADER(l_resp, j, v_header_name, v_header_value);
            IF UPPER(v_header_name) = 'CONTENT-LENGTH' THEN
                BEGIN
                    l_content_length := TO_NUMBER(v_header_value);
                EXCEPTION
                    WHEN OTHERS THEN l_content_length := NULL;
                END;
            END IF;
        END LOOP;

        IF l_resp.status_code <> 200 THEN

            DECLARE
                l_err_raw   RAW(32767);
                l_err_text  VARCHAR2(32767) := NULL;
            BEGIN
                BEGIN
                    LOOP
                        UTL_HTTP.READ_RAW(l_resp, l_err_raw, 32767);
                        l_err_text := l_err_text || UTL_RAW.CAST_TO_VARCHAR2(l_err_raw);
                    END LOOP;
                EXCEPTION
                    WHEN UTL_HTTP.END_OF_BODY THEN
                        NULL; -- fin normal de la lectura del body de error
                    WHEN OTHERS THEN
                        l_err_text := NVL(l_err_text, '(no se pudo leer el body: ' || SQLERRM || ')');
                END;

                APEX_DEBUG.ERROR(
                    'CER_INDIVIDUAL_BLOQUES - HTTP_ERROR - poliza=%s status=%s reason=%s body=%s',
                    p_poliza, l_resp.status_code, l_resp.reason_phrase,
                    SUBSTR(NVL(l_err_text, '(body vacio)'), 1, 3000));
            END;

            UTL_HTTP.END_RESPONSE(l_resp);
            DBMS_LOB.FREETEMPORARY(l_pdf_temp);
            RETURN;
        END IF;

        LOOP
            UTL_HTTP.READ_RAW(l_resp, l_raw, 32767);
            DBMS_LOB.WRITEAPPEND(l_pdf_temp, UTL_RAW.LENGTH(l_raw), l_raw);
            l_total_bytes := l_total_bytes + UTL_RAW.LENGTH(l_raw);
        END LOOP;

    EXCEPTION
        WHEN UTL_HTTP.END_OF_BODY THEN
            UTL_HTTP.END_RESPONSE(l_resp);
            l_ok := TRUE;

            APEX_DEBUG.INFO(
                'CER_INDIVIDUAL_BLOQUES - OK - poliza=%s bytes=%s content_length=%s duracion_seg=%s',
                p_poliza, l_total_bytes, l_content_length,
                ROUND(EXTRACT(SECOND FROM (SYSTIMESTAMP - v_inicio)) +
                      EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_inicio))*60, 1));

            IF l_content_length IS NOT NULL AND l_total_bytes < l_content_length THEN
                APEX_DEBUG.WARN(
                    'CER_INDIVIDUAL_BLOQUES - DESCARGA_INCOMPLETA - poliza=%s recibidos=%s esperados=%s',
                    p_poliza, l_total_bytes, l_content_length);
            END IF;

        WHEN OTHERS THEN
            BEGIN
                IF l_resp.private_hndl IS NOT NULL THEN
                    UTL_HTTP.END_RESPONSE(l_resp);
                END IF;
            EXCEPTION
                WHEN OTHERS THEN NULL;
            END;

            APEX_DEBUG.ERROR('CER_INDIVIDUAL_BLOQUES - ERROR - poliza=%s det_ini=%s det_fin=%s endoso_ini=%s endoso_fin=%s error=%s duracion_seg=%s',
                p_poliza, p_det_ini, p_det_fin, p_endoso_ini, p_endoso_fin,
                SQLERRM,
                ROUND(EXTRACT(SECOND FROM (SYSTIMESTAMP - v_inicio)) +
                      EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_inicio))*60, 1));

            IF DBMS_LOB.ISTEMPORARY(l_pdf_temp) = 1 THEN
                DBMS_LOB.FREETEMPORARY(l_pdf_temp);
            END IF;

            RETURN;
    END;

    IF NOT l_ok THEN
        IF DBMS_LOB.ISTEMPORARY(l_pdf_temp) = 1 THEN
            DBMS_LOB.FREETEMPORARY(l_pdf_temp);
        END IF;
        RETURN;
    END IF;


    IF DBMS_LOB.GETLENGTH(l_pdf_temp) < 500 THEN
        APEX_DEBUG.WARN('CER_INDIVIDUAL_BLOQUES - VACIO - poliza=%s bytes=%s sin contenido valido',
            p_poliza, DBMS_LOB.GETLENGTH(l_pdf_temp));
        DBMS_LOB.FREETEMPORARY(l_pdf_temp);
        RETURN;
    END IF;

    APEX_ZIP.ADD_FILE(
        p_zipped_blob => p_zip_blob,
        p_file_name   => v_nombre_pdf,
        p_content     => l_pdf_temp
    );
    p_count       := p_count + 1;
    p_tiene_texto := TRUE;

    DBMS_LOB.FREETEMPORARY(l_pdf_temp);

EXCEPTION
    WHEN OTHERS THEN
        BEGIN
            IF DBMS_LOB.ISTEMPORARY(l_pdf_temp) = 1 THEN
                DBMS_LOB.FREETEMPORARY(l_pdf_temp);
            END IF;
        EXCEPTION
            WHEN OTHERS THEN NULL;
        END;

        APEX_DEBUG.ERROR('CER_INDIVIDUAL_BLOQUES - ERROR_FATAL - poliza=%s error=%s', p_poliza, SQLERRM);
        RAISE_APPLICATION_ERROR(-20002,
            'Error en AGREGA_BLOQUE_ZIP - ' || SQLERRM);
END AGREGA_BLOQUE_ZIP;


PROCEDURE AGREGA_POLIZA_ZIP (
    p_poliza       VARCHAR2,
    p_det_ini      VARCHAR2,
    p_det_fin      VARCHAR2,
    p_endoso_ini   VARCHAR2,
    p_endoso_fin   VARCHAR2,
    p_usuario      VARCHAR2,
    vCH_Regla      VARCHAR2,
    vCH_Suma       VARCHAR2,
    p_zip_blob     IN OUT NOCOPY BLOB,
    p_count        OUT NUMBER,
    p_tiene_texto  OUT BOOLEAN,
    P_Aseg_Ini     NUMBER,
    P_vAseg_Fin    NUMBER
) IS
    l_pdf_temp       BLOB;
    l_raw            RAW(32767);
    l_req            UTL_HTTP.REQ;
    l_resp           UTL_HTTP.RESP;
    v_url            VARCHAR2(4000);
    v_nombre_pdf     VARCHAR2(255);
    v_nombre_reporte VARCHAR2(50);
    v_inicio         TIMESTAMP;
    l_ok             BOOLEAN := FALSE;
    l_total_bytes    NUMBER := 0;
    v_header_name    VARCHAR2(256);
    v_header_value   VARCHAR2(1024);
    l_content_length NUMBER;
BEGIN
    p_count       := 0;
    p_tiene_texto := FALSE;
 
 
  
    APEX_DEBUG.ENABLE(p_level => APEX_DEBUG.C_LOG_LEVEL_INFO);


    v_nombre_reporte := CASE WHEN vCH_Regla = 'S'
                                 THEN 'CON_IND_RSA_PO.pdf'
                                 ELSE 'CON_IND_PO.pdf'
                            END;

    v_url := v_jasper || 'Certificados_y_Consentimientos/' || v_nombre_reporte ||
             '?IDPOLIZA='   || p_poliza ||
             '&'||'IDETPOLINI=' || p_det_ini ||
             '&'||'IDETPOLFIN=' || p_det_fin ||
             '&'||'CODASEGINI=' || P_Aseg_Ini ||
             '&'||'CODASEGFIN=' || P_vAseg_Fin ||
             '&'||'ENDOSOINI='  || p_endoso_ini ||
             '&'||'ENDOSOFIN='  || p_endoso_Fin ||
             v_credenciales_j;

    v_nombre_pdf := 'CONS_INDIVIDUAL_' || p_poliza || '.pdf';

    APEX_DEBUG.INFO('CONS_INDIVIDUAL_- INICIO - poliza=%s det_ini=%s det_fin=%s endoso_ini=%s endoso_fin=%s',
        p_poliza, p_det_ini, p_det_fin, p_endoso_ini, p_endoso_fin);

    v_inicio := SYSTIMESTAMP;

    DBMS_LOB.CREATETEMPORARY(l_pdf_temp, TRUE);

    BEGIN
        l_req := UTL_HTTP.BEGIN_REQUEST(v_url);
        UTL_HTTP.SET_HEADER(l_req, 'User-Agent', 'Mozilla/4.0');

        UTL_HTTP.SET_PERSISTENT_CONN_SUPPORT(TRUE);

        UTL_HTTP.SET_TRANSFER_TIMEOUT(l_req, 5400);

        APEX_DEBUG.INFO(
            'CONS_INDIVIDUAL_ - ESPERANDO RESPUESTA DE JASPER - poliza=%s '||
            '(este paso puede tardar varios minutos, es normal no ver mas '||
            'mensajes hasta que Jasper responda)', p_poliza);

        l_resp := UTL_HTTP.GET_RESPONSE(l_req);

        APEX_DEBUG.INFO('CONS_INDIVIDUAL_ - RESPUESTA RECIBIDA - poliza=%s status=%s duracion_seg=%s',
            p_poliza, l_resp.status_code,
            ROUND(EXTRACT(SECOND FROM (SYSTIMESTAMP - v_inicio)) +
                  EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_inicio))*60, 1));

        FOR j IN 1..UTL_HTTP.GET_HEADER_COUNT(l_resp) LOOP
            UTL_HTTP.GET_HEADER(l_resp, j, v_header_name, v_header_value);
            IF UPPER(v_header_name) = 'CONTENT-LENGTH' THEN
                BEGIN
                    l_content_length := TO_NUMBER(v_header_value);
                EXCEPTION
                    WHEN OTHERS THEN l_content_length := NULL;
                END;
            END IF;
        END LOOP;

        IF l_resp.status_code <> 200 THEN

            DECLARE
                l_err_raw   RAW(32767);
                l_err_text  VARCHAR2(32767) := NULL;
            BEGIN
                BEGIN
                    LOOP
                        UTL_HTTP.READ_RAW(l_resp, l_err_raw, 32767);
                        l_err_text := l_err_text || UTL_RAW.CAST_TO_VARCHAR2(l_err_raw);
                    END LOOP;
                EXCEPTION
                    WHEN UTL_HTTP.END_OF_BODY THEN
                        NULL; -- fin normal de la lectura del body de error
                    WHEN OTHERS THEN
                        l_err_text := NVL(l_err_text, '(no se pudo leer el body: ' || SQLERRM || ')');
                END;

                APEX_DEBUG.ERROR(
                    'CONS_INDIVIDUAL_ - HTTP_ERROR - poliza=%s status=%s reason=%s body=%s',
                    p_poliza, l_resp.status_code, l_resp.reason_phrase,
                    SUBSTR(NVL(l_err_text, '(body vacio)'), 1, 3000));
            END;

            UTL_HTTP.END_RESPONSE(l_resp);
            DBMS_LOB.FREETEMPORARY(l_pdf_temp);
            RETURN;
        END IF;

        LOOP
            UTL_HTTP.READ_RAW(l_resp, l_raw, 32767);
            DBMS_LOB.WRITEAPPEND(l_pdf_temp, UTL_RAW.LENGTH(l_raw), l_raw);
            l_total_bytes := l_total_bytes + UTL_RAW.LENGTH(l_raw);
        END LOOP;

    EXCEPTION
        WHEN UTL_HTTP.END_OF_BODY THEN
            UTL_HTTP.END_RESPONSE(l_resp);
            l_ok := TRUE;

            APEX_DEBUG.INFO(
                'CONS_INDIVIDUAL_ - OK - poliza=%s bytes=%s content_length=%s duracion_seg=%s',
                p_poliza, l_total_bytes, l_content_length,
                ROUND(EXTRACT(SECOND FROM (SYSTIMESTAMP - v_inicio)) +
                      EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_inicio))*60, 1));

            IF l_content_length IS NOT NULL AND l_total_bytes < l_content_length THEN
                APEX_DEBUG.WARN(
                    'CONS_INDIVIDUAL_ - DESCARGA_INCOMPLETA - poliza=%s recibidos=%s esperados=%s',
                    p_poliza, l_total_bytes, l_content_length);
            END IF;

        WHEN OTHERS THEN
            BEGIN
                IF l_resp.private_hndl IS NOT NULL THEN
                    UTL_HTTP.END_RESPONSE(l_resp);
                END IF;
            EXCEPTION
                WHEN OTHERS THEN NULL;
            END;

            APEX_DEBUG.ERROR('CONS_INDIVIDUAL_ - ERROR - poliza=%s det_ini=%s det_fin=%s endoso_ini=%s endoso_fin=%s error=%s duracion_seg=%s',
                p_poliza, p_det_ini, p_det_fin, p_endoso_ini, p_endoso_fin,
                SQLERRM,
                ROUND(EXTRACT(SECOND FROM (SYSTIMESTAMP - v_inicio)) +
                      EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_inicio))*60, 1));

            IF DBMS_LOB.ISTEMPORARY(l_pdf_temp) = 1 THEN
                DBMS_LOB.FREETEMPORARY(l_pdf_temp);
            END IF;

            RETURN;
    END;

    IF NOT l_ok THEN
        IF DBMS_LOB.ISTEMPORARY(l_pdf_temp) = 1 THEN
            DBMS_LOB.FREETEMPORARY(l_pdf_temp);
        END IF;
        RETURN;
    END IF;


    IF DBMS_LOB.GETLENGTH(l_pdf_temp) < 500 THEN
        APEX_DEBUG.WARN('CONS_INDIVIDUAL_ - VACIO - poliza=%s bytes=%s sin contenido valido',
            p_poliza, DBMS_LOB.GETLENGTH(l_pdf_temp));
        DBMS_LOB.FREETEMPORARY(l_pdf_temp);
        RETURN;
    END IF;

    APEX_ZIP.ADD_FILE(
        p_zipped_blob => p_zip_blob,
        p_file_name   => v_nombre_pdf,
        p_content     => l_pdf_temp
    );
    p_count       := p_count + 1;
    p_tiene_texto := TRUE;

    DBMS_LOB.FREETEMPORARY(l_pdf_temp);

EXCEPTION
    WHEN OTHERS THEN
        BEGIN
            IF DBMS_LOB.ISTEMPORARY(l_pdf_temp) = 1 THEN
                DBMS_LOB.FREETEMPORARY(l_pdf_temp);
            END IF;
        EXCEPTION
            WHEN OTHERS THEN NULL;
        END;

        APEX_DEBUG.ERROR('CONS_INDIVIDUAL_ - ERROR_FATAL - poliza=%s error=%s', p_poliza, SQLERRM);
        RAISE_APPLICATION_ERROR(-20002,
            'Error en AGREGA_BLOQUE_ZIP - ' || SQLERRM);
END AGREGA_POLIZA_ZIP;
end OC_IMPRESION_PAPELERIA;
/

GRANT EXECUTE ON SICAS_OC.OC_IMPRESION_PAPELERIA TO PUBLIC;
/

CREATE OR REPLACE PUBLIC SYNONYM OC_IMPRESION_PAPELERIA FOR SICAS_OC.OC_IMPRESION_PAPELERIA;
/




