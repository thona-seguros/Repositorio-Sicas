CREATE OR REPLACE PACKAGE SICAS_OC.OC_GENERARFC IS
    vl_Cont                 NUMBER := 0;
        vl_Valor                NUMBER := 0;
        vl_Valor2               NUMBER := 0;
        vl_Residuo              NUMBER := 0;
        vl_Cociente             NUMBER := 0;
        vl_Palabra              VARCHAR2(100);
        vl_Val1                 VARCHAR2(1);
        vl_Val2                 VARCHAR2(1);
        varx                    VARCHAR2(100);
        vlNumLetra              VARCHAR2(1000);
/*
    Derechos Reservados (c), 2004 Ing. Salvador Garcia Velazquez
    Reglas de uso:
    
        Puedes usar este algoritmo en tu aplicacion personal,
        educacional, empresarial o comercial, siempre y cuando
        este mensaje de derechos reservados este presente. Su
        uso es libre de regalias y su autor es libre de cualquier
        fallo debido al codigo o logica.

    Por ningun motivo se da permiso de distribuir este codigo.
    Este codigo sigue siendo propiedad exclusiva del autor.
    Las rutinas afectadas por los derechos reservados son:

        GeneraRFC, RFCApellidoCorto, RFCArmalo, RFCUnApellido,
        RFCDigitoVerIFicador, RFCFiltraAcentos, RFCFiltraNombres
        RFCHomoclave y RFCQuitaProhibidas

    Cualquier rutina se puede emplear independientemente, siempre
    y cuando incluya este mensaje. Para cualquier correción, omisión
    o modIFicación, favor de dirigirse a sal_garcia@bigfoot.com

    Esta rutina genera el RFC. Datos de entrada:

        strNombre: Tipo String Nombre de pila Dato valido requerido.
        strPaterno: Tipo String Apellido paterno Por lo menos un
        strMaterno: Tipo String Apellido materno apellido es requerido.
        dteFechaNacimiento: Tipo Date
*/
    FUNCTION GENERAPRINCIPAL(Nombre VARCHAR2,ApPaterno VARCHAR2,ApMaterno VARCHAR2,Fecha VARCHAR2) RETURN VARCHAR2;
    PROCEDURE RFCFiltraNombres(Nombre IN VARCHAR2, ApPaterno IN VARCHAR2, ApMaterno IN VARCHAR2,Out_Nombre OUT VARCHAR2, Out_ApPaterno OUT VARCHAR2, Out_ApMaterno OUT VARCHAR2);
    PROCEDURE RFCFiltraNombresMoral(Nombre IN VARCHAR2,Out_Nombre OUT VARCHAR2);
    FUNCTION RFCApellidoCorto(Nombre VARCHAR2,ApPaterno VARCHAR2,ApMaterno VARCHAR2,Fecha VARCHAR2) RETURN VARCHAR2;
    FUNCTION RFCArmalo(Nombre VARCHAR2,ApPaterno VARCHAR2,ApMaterno VARCHAR2,Fecha VARCHAR2) RETURN VARCHAR2;
    FUNCTION RFCUnApellido(strNombre VARCHAR2, strPaterno VARCHAR2, strMaterno VARCHAR2, strFecha VARCHAR2) RETURN VARCHAR2;
    FUNCTION RFCQuitaProhibidas(strRFC VARCHAR2) RETURN VARCHAR2;
    FUNCTION RFCHomoclave(strNombre VARCHAR2, strPaterno VARCHAR2, strMaterno VARCHAR2) RETURN VARCHAR2;
    FUNCTION RFCHomoclaveMoral(strNombre VARCHAR2) RETURN VARCHAR2;
    FUNCTION RFCDigitoVerIFicador(strRFC  VARCHAR2) RETURN VARCHAR2;
    FUNCTION RFCDigitoVerIFicadorMoral(strRFC  VARCHAR2) RETURN VARCHAR2;
    FUNCTION OC_NUMALETRAS(P_NUMEROENTERO IN NUMBER) RETURN VARCHAR2;
    FUNCTION OC_CARACTERES(P_CARACTER IN VARCHAR2) RETURN VARCHAR2;

END;
/

create or replace PACKAGE BODY          OC_GENERARFC IS

    FUNCTION GENERAPRINCIPAL(Nombre VARCHAR2,ApPaterno VARCHAR2,ApMaterno VARCHAR2,Fecha VARCHAR2) RETURN VARCHAR2 IS
        vl_RFCorrecto           VARCHAR2(50);
        vl_Nombre               VARCHAR2(4000);
        vl_ApPaterno            VARCHAR2(150);
        vl_ApMaterno            VARCHAR2(150);
        vl_Nombre2              VARCHAR2(150);
        vl_ApPaterno2           VARCHAR2(150);
        vl_ApMaterno2           VARCHAR2(150);
        vl_formato              VARCHAR2(6);
        vl_NombreOriginal       VARCHAR2(150);
        vl_ApPaternoOriginal    VARCHAR2(150);
        vl_ApMaternoOriginal    VARCHAR2(150);
        vl_strRFC               VARCHAR2(4000);
        vl_RFCHomoClave         VARCHAR2(20);
        vl_DigitoVerif          VARCHAR2(20);
        vl_strRFCName           VARCHAR2(20);
        vl_NumPalabras          NUMBER := 0;

    BEGIN

        BEGIN
            vl_formato := TO_CHAR(TO_DATE(Fecha,'DD/MM/YYYY'),'YYMMDD');
        EXCEPTION
            WHEN OTHERS THEN
                vl_formato := TO_CHAR(Fecha,'YYMMDD');
        END;
                
        vl_Nombre := UPPER(Nombre);

        IF LENGTH(vl_Nombre) > 0 THEN

            vl_ApPaterno := UPPER(vl_ApPaterno);
            vl_ApMaterno := UPPER(vl_ApMaterno);

            vl_Nombre := (REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(vl_Nombre,'Á','A'),'É','E'),'Í','I'),'Ó','O'),'Ú','U'));
            vl_ApPaterno := (REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(ApPaterno),'Á','A'),'É','E'),'Í','I'),'Ó','O'),'Ú','U'));
            vl_ApMaterno := (REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(ApMaterno),'Á','A'),'É','E'),'Í','I'),'Ó','O'),'Ú','U'));

            vl_NombreOriginal := vl_Nombre;
            vl_ApPaternoOriginal := vl_ApPaterno;
            vl_ApMaternoOriginal := vl_ApMaterno;

            vl_Nombre2 := vl_Nombre;
            vl_ApPaterno2 := vl_ApPaterno;
            vl_ApMaterno2 := vl_ApMaterno;

            IF LENGTH(vl_ApPaterno) > 0 AND LENGTH(vl_ApMaterno) > 1 THEN

                SICAS_OC.OC_GENERARFC.RFCFiltraNombres(vl_Nombre2,vl_ApPaterno2,vl_ApMaterno2,vl_Nombre,vl_ApPaterno,vl_ApMaterno);

                IF LENGTH(vl_ApPaterno) < 3 THEN
                    vl_strRFC := SICAS_OC.OC_GENERARFC.RFCApellidoCorto(vl_Nombre, vl_ApPaterno, vl_ApMaterno, vl_formato);
                ELSE
                    vl_strRFC := SICAS_OC.OC_GENERARFC.RFCArmalo(vl_Nombre, vl_ApPaterno, vl_ApMaterno, vl_formato);
                END IF;

            ELSIF LENGTH(vl_ApPaterno) = 0 OR LENGTH(NVL(vl_ApMaterno,' ')) = 1 THEN 

                SICAS_OC.OC_GENERARFC.RFCFiltraNombres(vl_Nombre2,vl_ApPaterno2,vl_ApMaterno2,vl_Nombre,vl_ApPaterno,vl_ApMaterno);

                vl_strRFC := SICAS_OC.OC_GENERARFC.RFCUnApellido(vl_Nombre, vl_ApPaterno, vl_ApMaterno, vl_formato);

            ELSIF ApPaterno IS NULL AND ApMaterno IS NULL THEN --PERSONA MORAL
                RAISE_APPLICATION_ERROR(-20000,'El algoritmo no puede calcular el RFC de personas Morales');
                vl_Nombre2 := REPLACE(vl_Nombre2,'-',' ');
                vl_Nombre := REPLACE('  ',' ');
                vl_Nombre := REPLACE(vl_Nombre,'-',' ');

                SICAS_OC.OC_GENERARFC.RFCFiltraNombresMoral(vl_Nombre2,vl_Nombre);

                vl_Palabra := NULL;
                vl_Cont := 0;

                --vl_Nombre := vl_Nombre||' ';
                vl_Nombre := vl_Nombre;

                FOR i IN 1..LENGTH(vl_Nombre) LOOP
                        varx := SUBSTR(vl_Nombre,i,1);
                        IF varx <> ' ' THEN
                            vl_Palabra := vl_Palabra||varx;

                        ELSE --SI ES UN ESPACIO, SE TERMINO UNA PALABRA Y SE CONVIERTE A TEXTO SI ES NUMERO O CARACTER
                            vl_Cont := vl_Cont + 1;
                            BEGIN
                                vlNumLetra := OC_NUMALETRAS(TO_NUMBER(vl_Palabra)); --SE VALIDA SI LA PALABRA ES UN NUMERO
                                vl_Nombre := REPLACE(vl_Nombre,vl_Palabra,vlNumLetra);
                                vl_Palabra := NULL;
                            EXCEPTION
                                WHEN OTHERS THEN
                                    BEGIN
                                        vlNumLetra := OC_CARACTERES(vl_Palabra); --SE VALIDA SI LA PALABRA ES UN CARACTER ESPECIAL AISLADO

                                        IF vlNumLetra <> 'XXX' THEN
                                            vl_Nombre := REPLACE(vl_Nombre,vl_Palabra,vlNumLetra);
                                        END IF;

                                        vl_Palabra := NULL;
                                    EXCEPTION
                                        WHEN OTHERS THEN
                                            vlNumLetra := NULL;
                                            vl_Palabra := NULL;
                                    END;
                            END;

                    END IF;
                END LOOP;

                vl_Nombre := REPLACE(vl_Nombre,'  ',' ');

                vl_NumPalabras := vl_Cont; --TO_NUMBER(LENGTH(vl_Nombre) - LENGTH(REPLACE(vl_Nombre,' ','')) + 1);

                IF vl_NumPalabras = 1 THEN
                    IF LENGTH(vl_NumPalabras) < 3 THEN --SI LA UNICA PALABRA ES DE LONGITUD MENOR A 3, SE COMPLEMENTA CON 'X' A LA DERECHA
                        vl_strRFC := RPAD(vl_Nombre,3,'X');
                    ELSE
                        vl_strRFC := SUBSTR(vl_Nombre,0,3);
                    END IF;

                    vl_strRFC := vl_strRFC || vl_formato;
                ELSIF vl_NumPalabras = 2 THEN
                    vl_strRFC := SUBSTR(vl_Nombre,0,1);
                    vl_strRFC := vl_strRFC||SUBSTR(vl_Nombre,INSTR(vl_Nombre,' ',2) + 1 ,2);
                    vl_strRFC := vl_strRFC || vl_formato;
                ELSIF vl_NumPalabras >= 3 THEN
                    vl_strRFC := SUBSTR(vl_Nombre,0,1);
                    vl_strRFC := vl_strRFC||SUBSTR(vl_Nombre,INSTR(vl_Nombre,' ',2) + 1 ,1);
                    vl_strRFC := vl_strRFC||SUBSTR(vl_Nombre,INSTR(vl_Nombre,' ',1,2)+1 ,1);
                    vl_strRFC := vl_strRFC || vl_formato;
                ELSE
                    vl_strRFC := 'XEX'||vl_formato;
                END IF;

            END IF;

        END IF; 

        IF ApPaterno IS NULL AND ApMaterno IS NULL THEN --PERSONA MORAL
            vl_NombreOriginal := REPLACE(vl_NombreOriginal,'-',' ');
            vl_RFCHomoClave := SICAS_OC.OC_GENERARFC.RFCHomoclaveMoral(vl_NombreOriginal);

            --vl_strRFC := vl_strRFC || vl_RFCHomoClave;

            --vl_DigitoVerif := SICAS_OC.OC_GENERARFC.RFCDigitoVerificadorMoral(vl_strRFC);

            --vl_RFCorrecto := vl_strRFC || vl_DigitoVerif;

            vl_RFCorrecto := vl_strRFC;
        ELSE --PERSONA FISICA

            vl_strRFC := SICAS_OC.OC_GENERARFC.RFCQuitaProhibidas(vl_strRFC);

            vl_RFCHomoClave := SICAS_OC.OC_GENERARFC.RFCHomoclave(vl_NombreOriginal, vl_ApPaternoOriginal, vl_ApMaternoOriginal);

            vl_strRFC := vl_strRFC || vl_RFCHomoClave;

            vl_DigitoVerif := SICAS_OC.OC_GENERARFC.RFCDigitoVerificador(vl_strRFC);

            vl_RFCorrecto := vl_strRFC || vl_DigitoVerif;

        END IF;

        RETURN vl_RFCorrecto;
    EXCEPTION
        WHEN OTHERS THEN
            vl_RFCorrecto := 'XEXX010101000';
            RETURN vl_RFCorrecto;

    END GENERAPRINCIPAL;

    FUNCTION RFCArmalo(Nombre VARCHAR2,ApPaterno VARCHAR2,ApMaterno VARCHAR2,Fecha VARCHAR2) RETURN VARCHAR2 IS --COMPLETO

        vl_Armalo           VARCHAR2(10);
        vl_strLetra         VARCHAR2(10);
        vl_strPrimerVocal   VARCHAR2(10);
        vl_TO_CHARor        VARCHAR2(10);
        vl_i                NUMBER;
        vl_intIdx           NUMBER;

    BEGIN            

        --Primero consigo la primera vocal del nombre comenzando con la segunda letra.
        FOR i IN 0..LENGTH(ApPaterno) LOOP
            vl_TO_CHARor := SUBSTR(ApPaterno,i+1,1);
            IF vl_TO_CHARor IN ('A','E','I','O','U') THEN
                vl_strPrimerVocal := vl_TO_CHARor;
                EXIT;
            END IF;
        END LOOP;

        vl_Armalo := SUBSTR(ApPaterno, 0,1) || vl_strPrimerVocal || SUBSTR(ApMaterno, 0,1) || SUBSTR(Nombre, 0,1) || Fecha;

        RETURN vl_Armalo;

    END RFCArmalo;

    FUNCTION RFCApellidoCorto(Nombre VARCHAR2,ApPaterno VARCHAR2,ApMaterno VARCHAR2,Fecha VARCHAR2)  RETURN VARCHAR2 IS
        vl_ApCorto  VARCHAR2(10);

    BEGIN
       -- 'Eta rutina calcula el RFC tomando en cuenta un
       -- 'apellido paterno de tres o menos letras.

        vl_ApCorto := LPAD(ApPaterno, 1) || LPAD(ApMaterno, 1) || LPAD(Nombre, 2) || Fecha; 

        RETURN vl_ApCorto;
    END RFCApellidoCorto;

    PROCEDURE RFCFiltraNombres(Nombre IN VARCHAR2, ApPaterno IN VARCHAR2, ApMaterno IN VARCHAR2,Out_Nombre OUT VARCHAR2, Out_ApPaterno OUT VARCHAR2, Out_ApMaterno OUT VARCHAR2) IS  --COMPLETO
        --strArPalabras() As Variant;
        i               NUMBER;

        TYPE array_t IS VARRAY(120) of varchar2(10);
        TYPE array_tt IS VARRAY(40) of varchar2(10);
        arrayy_Palabras array_t := array_t('.', ',', 'DE ', 'DEL ', 'LA ', 'LOS ', 'LAS ', 'Y ', 'MC ', 'MAC ', 'VON ', 'VAN ');
        arrayy_Nombress array_tt := array_tt('JOSE ', 'MARIA ', 'J ', 'MA ','MA. ','M. ');

        strNombre       VARCHAR2(50);
        strPaterno      VARCHAR2(50);
        strMaterno      VARCHAR2(50);
        --Esta rutina elimina palabras sobrantes para el calculo del RFC de los tres nombres.
    BEGIN

        strNombre := Nombre;
        strPaterno := ' '||ApPaterno;
        strMaterno := ' '||ApMaterno;
        FOR i IN arrayy_Palabras.FIRST..arrayy_Palabras.LAST LOOP --AAA
            strNombre := REPLACE(strNombre, arrayy_Palabras(i), '');
            strPaterno := REPLACE(strPaterno, arrayy_Palabras(i), '');
            strMaterno := REPLACE(strMaterno, arrayy_Palabras(i), '');
        END LOOP;

        --Inicializa el arreglo con las palabras que no queremos.
        --Busca cada palabra en los tres nombre y eliminala si se encuentra.
        --Listo, ahora sigo con el nombre pila, buscando la presencia de Maria o Jose.
        --Inicializa el arreglo con las palabras que queremos eliminar.

        --Haz esto solo si el nombre de pila tiene algun espacio.
        IF NVL(INSTR(strNombre, ' '),0) > 0 THEN
            FOR i IN arrayy_Nombress.FIRST..arrayy_Nombress.LAST LOOP --AAA
                strNombre := REPLACE(strNombre, arrayy_Nombress(i), '');
            END LOOP;
        END IF;

        --Por ultimo, elimina doble consonantes de los nombres cuando estas ocurren en las primeras dos letras del nombre.
        IF NVL(INSTR(strNombre,'CH'),0) > 0 THEN
             strNombre := REPLACE(strNombre, 'CH', 'C');
        ELSIF NVL(INSTR(strNombre,'LL'),0) > 0 THEN
            strNombre := REPLACE(strNombre, 'LL', 'L');
        END IF;

        IF NVL(INSTR(strPaterno,'CH'),0) > 0 THEN
             strPaterno := REPLACE(strPaterno, 'CH', 'C');
        ELSIF NVL(INSTR(strPaterno,'LL'),0) > 0 THEN
            strPaterno := REPLACE(strPaterno, 'LL', 'L');
        END IF;

        IF NVL(INSTR(strMaterno,'CH'),0) > 0 THEN
             strMaterno := REPLACE(strMaterno, 'CH', 'C');
        ELSIF NVL(INSTR(strMaterno,'LL'),0) > 0 THEN
            strMaterno := REPLACE(strMaterno, 'LL', 'L');
        END IF;
        
        Out_Nombre := strNombre;
        Out_ApPaterno := SUBSTR(strPaterno,2,LENGTH(strPaterno));
        Out_ApMaterno := SUBSTR(strMaterno,2,LENGTH(strMaterno));

    END RFCFiltraNombres;

    PROCEDURE RFCFiltraNombresMoral(Nombre IN VARCHAR2,Out_Nombre OUT VARCHAR2) IS  --COMPLETO
        --strArPalabras() As Variant;
        i               NUMBER;

        TYPE array_t IS VARRAY(120) OF VARCHAR2(40);
        TYPE array_tt IS VARRAY(6) OF VARCHAR2(10);
        arrayy_Palabras array_t := array_t('.', ',', ' DE ', ' DEL ', 'LA ', ' LOS ', ' LAS ', ' Y ', ' MC ', ' MAC ', ' VON ', ' VAN ',' EL ','UN ',' UNA ','UNOS ','UNAS ','LO ','AL ',
            ' CIA. ',' COMPAÑIA ',' SOCIEDAD ',' SOC. ',' SOC ',' CIA ',
            ' S. EN C.',' S.A.',' C.V.',' CV',' SA',' SAPI',' SAMI',' SA MI',' S.A.S.',' SAS',' R.L.',' S, DE R.L.',' S. EN C. POR A.',' SAPIB',' SAB',' SAS',' S.C.',' S.C',' S.A', ' C.V',' R.L',' S.EN C.S.',
            ' E.N.R.',' SOFOM',' A.P.',' A.P');

        arrayy_Nombress array_tt := array_tt('JOSE ', 'MARIA ', 'J ', 'MA ','MA. ','M. ');

        strNombre       VARCHAR2(50);
        --Esta rutina elimina palabras sobrantes para el calculo del RFC de los tres nombres.
    BEGIN

        strNombre := Nombre;

        FOR i IN arrayy_Palabras.FIRST..arrayy_Palabras.LAST LOOP --AAA
            strNombre := REPLACE(strNombre, arrayy_Palabras(i), '');
        END LOOP;

        --Inicializa el arreglo con las palabras que no queremos.
        --Busca cada palabra en los tres nombre y eliminala si se encuentra.
        --Listo, ahora sigo con el nombre pila, buscando la presencia de Maria o Jose.
        --Inicializa el arreglo con las palabras que queremos eliminar.

        --Haz esto solo si el nombre de pila tiene algun espacio.
        IF NVL(INSTR(strNombre, ' '),0) > 0 THEN
            FOR i IN arrayy_Nombress.FIRST..arrayy_Nombress.LAST LOOP --AAA
                strNombre := REPLACE(strNombre, arrayy_Nombress(i), '');
            END LOOP;

        END IF;

        --Por ultimo, elimina doble consonantes de los nombres cuando estas ocurren en las primeras dos letras del nombre.
        IF NVL(INSTR(strNombre,'CH'),0) > 0 THEN
             strNombre := REPLACE(strNombre, 'CH', 'C');
        ELSIF NVL(INSTR(strNombre,'LL'),0) > 0 THEN
            strNombre := REPLACE(strNombre, 'LL', 'L');
        END IF;

        Out_Nombre := strNombre;

    END RFCFiltraNombresMoral;

    FUNCTION RFCUnApellido(strNombre VARCHAR2, strPaterno VARCHAR2, strMaterno VARCHAR2, strFecha VARCHAR2) RETURN VARCHAR2 IS --COMPLETO
        --Esta rutina toma en cuenta casos cuando solo se 'da un apellido, ya sea el paterno o materno.
        strApellido VARCHAR2(100);
     BEGIN

        IF NVL(LENGTH(strPaterno),0) > 0 AND NVL(LENGTH(strMaterno),0) = 0 THEN --'Solo hay apellido paterno.
            strApellido := SUBSTR(strPaterno, 0,2);
        ELSIF NVL(LENGTH(strPaterno),0) = 0 AND NVL(LENGTH(strMaterno),0) > 0 THEN--'Solo hay apellido materno.
            strApellido := SUBSTR(strMaterno, 0,2);
        ELSE
            strApellido := SUBSTR(strNombre,0, 2);
        END IF;

        --Ahora arma el RFC.
        strApellido := strApellido || SUBSTR(strNombre,0, 2) ||strFecha;

        RETURN strApellido;

    END RFCUnApellido;

    FUNCTION RFCQuitaProhibidas(strRFC VARCHAR2) RETURN VARCHAR2 IS --COMPLETO
        --Esta rutina quita cualquiera de las palabras prohibidas, cambiando el ultimo caracter de dicha palabra a X.
        strPalabras     VARCHAR2(4000);
        str_RCFOK       VARCHAR2(50) := NULL;
        str_RCFOK2      VARCHAR2(50);
        vl_RFCSalida    VARCHAR2(50);
    BEGIN

        --Define todas las palabras prohibidas.
        strPalabras := 'BUEI*,BUEY*,CACA*,CACO*,CAGA*,CAGO*,CAKA*,CAKO*,COGE*,COJA*,';
        strPalabras := strPalabras || 'KOGE*,KOJO*,KAKA*,KULO*,MAME*,MAMO*,MEAR*,';
        strPalabras := strPalabras || 'MEAS*,MEON*,MION*,COJE*,COJI*,COJO*,CULO*,';
        strPalabras := strPalabras || 'FETO*,GUEY*,JOTO*,KACA*,KACO*,KAGA*,KAGO*,';
        strPalabras := strPalabras || 'MOCO*,MULA*,PEDA*,PEDO*,PENE*,PUTA*,PUTO*,';
        strPalabras := strPalabras || 'QULO*,RATA*,RUIN*';
        strPalabras := strPalabras || 'FUCK*,CUNT*,PISS*,SHIT*,COCK*,DICK*,KNOB*,PUSS*,SHAG*,TITS*,PUSY*';

        --Si alguna de estas se encuentra, cambiala.
        IF INSTR(strPalabras, SUBSTR(strRFC,0,4)|| '*') > 0 THEN --Reemplaza el cuarto caracter del RFC para eliminar l apalabra prohibida.
            str_RCFOK := SUBSTR(strRFC,0,4);
            str_RCFOK2 := SUBSTR(str_RCFOK,0,3)||'X';
            str_RCFOK := REPLACE(strRFC ,str_RCFOK,str_RCFOK2);
        END IF;

        IF str_RCFOK IS NOT NULL THEN
            vl_RFCSalida := str_RCFOK;
        ELSE
            vl_RFCSalida := strRFC;
        END IF;

        RETURN vl_RFCSalida;

    END RFCQuitaProhibidas;

    FUNCTION RFCDigitoVerIFicador(strRFC  VARCHAR2) RETURN VARCHAR2 IS --COMPLETO
        --Esta rutina calcula el digito verIFicador. El RFC consta de las iniciales, los digitos de la fecha de nacimiento y los dos caracteres de la homoclave.
        strDigitos      VARCHAR2(4000);
        strChars        VARCHAR2(4000);
        strArDigitos    VARCHAR2(4000);--VARIANT
        strArChars      VARCHAR2(4000);--VARIANT
        strBuffer       VARCHAR2(4000);
        strCh           VARCHAR2(4000);
        strDV           VARCHAR2(4000);
        intProd1        NUMBER;
        intProd3        NUMBER;
        intSumas        NUMBER := 0;
        intContador     NUMBER;
        intQuo          NUMBER;
        intRem          NUMBER;
        intDV           NUMBER;
        i               NUMBER;
        intIdx          NUMBER;
        intTemp         NUMBER;
        vl_TO_CHAR1     VARCHAR2(50) := NULL;
    BEGIN

        --strDigitos := '0001020304050607080910111213141516171819202122232425262728293031323334353637';
        strChars := '0123456789ABCDEFGHIJKLMN*OPQRSTUVWXYZ';
        --Inicializa el contador.
        --intContador := 13;

        --El RFC tiene 12 caracteres: 4 Letras, 6 digitos y 2 caracteres (homoclave) Barre los 12 caracteres del RFC.
        FOR i IN 1..LENGTH(strRFC) LOOP --AAA
            strCh := SUBSTR(strRFC, i, 1);
            IF strCh = ' ' THEN
                strCh := '*';
            END IF;

            intIdx := INSTR(strChars, strCh) - 1;--original
            --intIdx := INSTR(strChars, strCh) ;--argenis

            intSumas := intSumas + intIdx * (14 - i);
            --intContador := intContador - 1;
            --strBuffer := strBuffer || Format$(intIdx, '00');
            strBuffer := strBuffer || TO_CHAR(intIdx);    
        END LOOP;

        IF intSumas Mod 11 = 0 THEN
            strDV := '0';
        Else
            intDV := 11 - intSumas Mod 11;
            IF intDV > 9 THEN
                strDV := 'A';
            Else
                strDV := TO_CHAR(intDV);
            END IF;
        END IF;

        RETURN strDV;

    END RFCDigitoVerIFicador;

    FUNCTION RFCDigitoVerIFicadorMoral(strRFC  VARCHAR2) RETURN VARCHAR2 IS --COMPLETO
        --Esta rutina calcula el digito verIFicador. El RFC consta de las iniciales, los digitos de la fecha de nacimiento y los dos caracteres de la homoclave.
        strDigitos      VARCHAR2(4000);
        strChars        VARCHAR2(4000);
        strArDigitos    VARCHAR2(4000);--VARIANT
        strArChars      VARCHAR2(4000);--VARIANT
        strBuffer       VARCHAR2(4000);
        strCh           VARCHAR2(4000);
        strDV           VARCHAR2(4000);
        intProd1        NUMBER;
        intProd3        NUMBER;
        intSumas        NUMBER := 0;
        intContador     NUMBER;
        intQuo          NUMBER;
        intRem          NUMBER;
        intDV           NUMBER;
        i               NUMBER;
        intIdx          NUMBER;
        intTemp         NUMBER;
        vl_TO_CHAR1     VARCHAR2(50) := NULL;
        strResHomonimo  VARCHAR2(50);
        vl_RFFC         varchar2(40) := null;
    BEGIN

        --strDigitos := '0001020304050607080910111213141516171819202122232425262728293031323334353637';
        strChars := '0123456789ABCDEFGHIJKLMN*OPQRSTUVWXYZ';
        --Inicializa el contador.
        --intContador := 13;

        --El RFC tiene 12 caracteres: 4 Letras, 6 digitos y 2 caracteres (homoclave) Barre los 12 caracteres del RFC.
        FOR i IN 1..LENGTH(strRFC) LOOP --AAA
            strCh := SUBSTR(strRFC, i, 1);
            IF strCh = ' ' THEN
                strCh := '*';
            END IF;

            intIdx := INSTR(strChars, strCh) - 1;--original
            --intIdx := INSTR(strChars, strCh) ;--argenis

            intSumas := intSumas + intIdx * (10 - i);
            --intContador := intContador - 1;
            --strBuffer := strBuffer || Format$(intIdx, '00');
            strBuffer := strBuffer || TO_CHAR(intIdx);    
        END LOOP;

        IF intSumas Mod 11 = 0 THEN
            strDV := '0';
        Else
            intDV := 11 - intSumas Mod 11;
            IF intDV > 9 THEN
                strDV := 'A';
            Else
                strDV := TO_CHAR(intDV);
            END IF;
        END IF;

        RETURN strDV;

        /*
        --strDigitos := '0001020304050607080910111213141516171819202122232425262728293031323334353637';
        strChars := '0123456789&ABCDEFGHIJKLMN*OPQRSTUVWXYZÑ';
        strResHomonimo := '123456789ABCDEFGHIJKLMNPQRSTUVWXYZ';
        --Inicializa el contador.
        --intContador := 13;

        --El RFC tiene 12 caracteres: 4 Letras, 6 digitos y 2 caracteres (homoclave) Barre los 12 caracteres del RFC.
        FOR i IN 1..LENGTH(strRFC) LOOP --AAA
            strCh := SUBSTR(strRFC, i, 1);
            IF strCh = ' ' THEN
                strCh := '*';
            END IF;

            intIdx := INSTR(strChars, strCh) - 1;--original
            --intIdx := INSTR(strChars, strCh) ;--argenis

            --intContador := intContador - 1;
            --strBuffer := strBuffer || Format$(intIdx, '00');
            strBuffer := strBuffer || TO_CHAR(intIdx);    

        END LOOP;
        strBuffer := '0'||strBuffer;
        FOR i IN 1..LENGTH(strBuffer) LOOP
            varx := SUBSTR(strBuffer,i,2);
            vl_Valor := TO_NUMBER(varx) * SUBSTR(varx,-1);
            vl_Valor2 := vl_Valor2 + vl_Valor;
        END LOOP;
--DBMS_OUTPUT.PUT_LINE(vl_Valor2);
        strBuffer := SUBSTR(TO_CHAR(vl_Valor2),-3);
        vl_Cociente := FLOOR(strBuffer / 34);
        vl_Valor := vl_Cociente * 34;
        vl_Residuo := strBuffer - vl_Valor;
--DBMS_OUTPUT.PUT_LINE(vl_Cociente||' '||vl_Residuo);

        vl_Val1 := SUBSTR(strResHomonimo,vl_Cociente+1,1);
        vl_Val2 := SUBSTR(strResHomonimo,vl_Residuo+1,1);
DBMS_OUTPUT.PUT_LINE(vl_Val1||' '||vl_Val2);

        RETURN strDV;
*/
    END RFCDigitoVerIFicadorMoral;

    FUNCTION RFCHomoclave(strNombre VARCHAR2, strPaterno VARCHAR2, strMaterno VARCHAR2) RETURN VARCHAR2 IS

        --Esta rutina calcula la homoclave, que es de dos caracteres. El proceso solo toma en cuenta los nombres de la persona.
        strNombreComp   VARCHAR2(4000);
        --strChars        VARCHAR2(4000);
        --strDigitos      VARCHAR2(4000);
        strCharsHc      VARCHAR2(4000);
       /* strDigitos2     VARCHAR2(4000);
        strSeq          VARCHAR2(4000);
        strArSeq()      VARCHAR2(4000);
        strArSeq1()     As Variant
        strArSeq2()     VARCHAR2(4000);*/
        strChr          VARCHAR2(4000);
        i               NUMBER;
        --intIdx          NUMBER;
        strCadena       VARCHAR2(4000);
        intNum1         NUMBER := 0;
        intNum2         NUMBER := 0;
        --intProd3        NUMBER;
        intSum          NUMBER := 0;
        --strSum          VARCHAR2(4000);
        int3            NUMBER;
        intQuo          NUMBER(18,0);
        intRem          NUMBER;
        --str2Digitos     VARCHAR2(4000);
        strHomoclave    VARCHAR2(4000);

    BEGIN

        --Consigue el nombre completo de la persona.
        IF strPaterno IS NOT NULL OR strMaterno IS NOT NULL THEN
            strNombreComp := strPaterno || ' ' || strMaterno || ' ' || strNombre;
        ELSE
            strNombreComp := strNombre;
        END IF;
        --Inicializa la cadena de caracteres que contiene los caracteres permitidos para la homoclave.
        --Notese la ausencia del numero 0 y la letra o.
        strCharsHc := '123456789ABCDEFGHIJKLMNPQRSTUVWXYZ';

        --Inicializa la cadena con 0 para desplazar todo a la derecha.
        strCadena := '0';

        FOR i IN 1..LENGTH(strNombreComp) LOOP --AAA

            strChr := SUBSTR(strNombreComp, i, 1);

            --Convierte la letra a un numero de dos digitos.
            IF strChr IN (' ', '-') THEN
                strCadena := strCadena || '00';
            ELSIF strChr IN ( 'Ñ', 'Ü') THEN    
                strCadena := strCadena || '10';
            ELSIF strChr IN ( 'A','B','C','D','E','F','G','H','I') THEN    
                strCadena := strCadena || TO_CHAR(ASCII(strChr) - 54);
            ELSIF strChr IN ( 'J','K','L','M','N','O','P','Q','R') THEN    
                strCadena := strCadena || TO_CHAR(ASCII(strChr) - 53);    
            ELSIF strChr IN ( 'S','T','U','V','W','X','Y','Z') THEN    
                strCadena := strCadena || TO_CHAR(ASCII(strChr) - 51);   
            ELSIF strChr IN ( '0','1','2','3','4','5','6','7','8','9') THEN  
                --Se supone que esta linea nunca se ejecutara, pues un nombre no usa digitos. Aun asi, como estaba en el algoritmo original, lo dejo aqui.
                strCadena := strCadena || strChr;
            END IF;

        END LOOP;

        --Borra toda la cadena y realiza una operacion matematica, en cada uno de los digitos.
        --Por cada digitos se toman dos a la vez y se multiplica este numero por el digito de unidades del mismo numero.
        /*Ejemplo:
            Si la cadena es 01245

            Se comienza con el primer digito, se toman dos y luego
            se multiplica por la unidad de ese mismo numero:

            Primer digito = 0, los dos: 01
            Se multiplica '01' (1) por '1'
            Se acumula.

            Segundo digito = 1, los dos: 12
            Se multiplica '12' (12) por '2'

            Tercer digito = 2, los dos: 24
            Se multiplica '24' (24) por '4'
            etc.
            */

        FOR i IN 1..LENGTH(strCadena)-1 LOOP
            intNum1 := TO_CHAR(SUBSTR(strCadena, i, 2));
            intNum2 := TO_CHAR(SUBSTR(strCadena, i + 1, 1));
            intSum := intSum + (intNum1 * intNum2);
        END LOOP;

        --De la suma, solo necesito los ultimos tres digitos. La forma mas facil de hacer esto en convirtiendo el numero a cadena, luego tomando los tres digitos de la derecha.

        int3 := TO_CHAR(SUBSTR(TO_CHAR(intSum), -3));
        intQuo := FLOOR(int3 / 34);
        intRem := int3 Mod 34;

        --La homoclave se consigue usando el cociente y el residuo.
        --Se usa el cociente y residio para buscar las letras del homoclave dentro de la tabla de caracteres permitidos.
        strHomoclave := SUBSTR(strCharsHc, intQuo + 1, 1) || SUBSTR(strCharsHc, intRem + 1, 1);

        RETURN strHomoclave;

    END RFCHomoclave;

    FUNCTION RFCHomoclaveMoral(strNombre VARCHAR2) RETURN VARCHAR2 IS

        --Esta rutina calcula la homoclave, que es de dos caracteres. El proceso solo toma en cuenta los nombres de la persona.
        strNombreComp   VARCHAR2(4000);
        strCharsHc      VARCHAR2(4000);
        strChr          VARCHAR2(4000);
        i               NUMBER;
        strCadena       VARCHAR2(4000);
        intNum1         NUMBER := 0;
        intNum2         NUMBER := 0;
        intSum          NUMBER := 0;
        int3            NUMBER := 0;
        intQuo          NUMBER(18,0);
        intRem          NUMBER;
        strHomoclave    VARCHAR2(4000);

    BEGIN

        --Consigue el nombre completo de la persona.
        strNombreComp := strNombre;

        --Inicializa la cadena de caracteres que contiene los caracteres permitidos para la homoclave.
        --Notese la ausencia del numero 0 y la letra o.
        strCharsHc := '123456789ABCDEFGHIJKLMNPQRSTUVWXYZ';

        --Inicializa la cadena con 0 para desplazar todo a la derecha.
        strCadena := '0';

        FOR i IN 1..LENGTH(strNombreComp) LOOP --AAA

            strChr := SUBSTR(strNombreComp, i, 1);

            --Convierte la letra a un numero de dos digitos.
            IF strChr IN (' ', '-') THEN
                strCadena := strCadena || '00';
            ELSIF strChr IN ( 'Ñ', 'Ü') THEN    
                strCadena := strCadena || '10';
            ELSIF strChr IN ( 'A','B','C','D','E','F','G','H','I') THEN    
                strCadena := strCadena || TO_CHAR(ASCII(strChr) - 54);
            ELSIF strChr IN ( 'J','K','L','M','N','O','P','Q','R') THEN    
                strCadena := strCadena || TO_CHAR(ASCII(strChr) - 53);    
            ELSIF strChr IN ( 'S','T','U','V','W','X','Y','Z') THEN    
                strCadena := strCadena || TO_CHAR(ASCII(strChr) - 51);   
            ELSIF strChr IN ( '0','1','2','3','4','5','6','7','8','9') THEN  
                --Se supone que esta linea nunca se ejecutara, pues un nombre no usa digitos. Aun asi, como estaba en el algoritmo original, lo dejo aqui.
                strCadena := strCadena || strChr;
            END IF;

        END LOOP;

        --Borra toda la cadena y realiza una operacion matematica, en cada uno de los digitos.
        --Por cada digitos se toman dos a la vez y se multiplica este numero por el digito de unidades del mismo numero.
        /*Ejemplo:
            Si la cadena es 01245

            Se comienza con el primer digito, se toman dos y luego
            se multiplica por la unidad de ese mismo numero:

            Primer digito = 0, los dos: 01
            Se multiplica '01' (1) por '1'
            Se acumula.

            Segundo digito = 1, los dos: 12
            Se multiplica '12' (12) por '2'

            Tercer digito = 2, los dos: 24
            Se multiplica '24' (24) por '4'
            etc.
            */

        FOR i IN 1..LENGTH(strCadena)-1 LOOP
            intNum1 := TO_CHAR(SUBSTR(strCadena, i, 2));
            intNum2 := TO_CHAR(SUBSTR(strCadena, i + 1, 1));
            intSum := intSum + (intNum1 * intNum2);
        END LOOP;

        --De la suma, solo necesito los ultimos tres digitos. La forma mas facil de hacer esto en convirtiendo el numero a cadena, luego tomando los tres digitos de la derecha.

        int3 := TO_CHAR(SUBSTR(TO_CHAR(intSum), -3));
        intQuo := FLOOR(int3 / 34);
        intRem := int3 Mod 34;

        --La homoclave se consigue usando el cociente y el residuo.
        --Se usa el cociente y residio para buscar las letras del homoclave dentro de la tabla de caracteres permitidos.
        strHomoclave := intQuo + 1; --SUBSTR(strCharsHc, intQuo + 1, 1)|| SUBSTR(strCharsHc, intRem + 1, 1);

        RETURN strHomoclave;

    END RFCHomoclaveMoral;

    FUNCTION F_OBT_NUMERO_MENOR_MIL(P_NUMEROENTERO IN NUMBER) RETURN VARCHAR2 IS

    --OBJETIVO    : FUNCION PRIVADA PARA OBTENER NUMEROS MENORES A MIL CONVERTIDOS EN LETRAS

    FUERA_DE_RANGO EXCEPTION;
    NUMERO_ENTERO  EXCEPTION;

    CENTENAS NUMBER;
    DECENAS  NUMBER;
    UNIDADES NUMBER;

    V_NUMEROENLETRA VARCHAR2(100);
    UNIR            VARCHAR2(2);

    BEGIN
        BEGIN
            IF TRUNC(P_NUMEROENTERO) <> P_NUMEROENTERO THEN
                RAISE NUMERO_ENTERO;
            END IF;

            IF P_NUMEROENTERO < 0 OR P_NUMEROENTERO > 999 THEN
                RAISE FUERA_DE_RANGO;
            END IF;

            IF P_NUMEROENTERO = 100 THEN
                RETURN('CIEN ');
            ELSIF P_NUMEROENTERO = 0 THEN
                RETURN('CERO ');
            ELSIF P_NUMEROENTERO = 1 THEN
                RETURN('UNO ');
            ELSE

            CENTENAS := TRUNC(P_NUMEROENTERO / 100);
            DECENAS  := TRUNC((P_NUMEROENTERO MOD 100) / 10);
            UNIDADES := P_NUMEROENTERO MOD 10;
            UNIR     := 'Y ';

            -- OBTENIENDO CENTENAS
            IF CENTENAS = 1 THEN
                V_NUMEROENLETRA := 'CIENTO ';
            ELSIF CENTENAS = 2 THEN
                V_NUMEROENLETRA := 'DOSCIENTOS ';
            ELSIF CENTENAS = 3 THEN
                V_NUMEROENLETRA := 'TRESCIENTOS ';
            ELSIF CENTENAS = 4 THEN
                V_NUMEROENLETRA := 'CUATROCIENTOS ';
            ELSIF CENTENAS = 5 THEN
                V_NUMEROENLETRA := 'QUINIENTOS ';
            ELSIF CENTENAS = 6 THEN
                V_NUMEROENLETRA := 'SEISCIENTOS ';
            ELSIF CENTENAS = 7 THEN
                V_NUMEROENLETRA := 'SETECIENTOS ';
            ELSIF CENTENAS = 8 THEN
                V_NUMEROENLETRA := 'OCHOCIENTOS ';
            ELSIF CENTENAS = 9 THEN
                V_NUMEROENLETRA := 'NOVECIENTOS ';
            END IF;

            -- OBTENIENDO DECENAS
            IF DECENAS = 3 THEN
                V_NUMEROENLETRA := V_NUMEROENLETRA || 'TREINTA ';
            ELSIF DECENAS = 4 THEN
                V_NUMEROENLETRA := V_NUMEROENLETRA || 'CUARENTA ';
            ELSIF DECENAS = 5 THEN
                V_NUMEROENLETRA := V_NUMEROENLETRA || 'CINCUENTA ';
            ELSIF DECENAS = 6 THEN
                V_NUMEROENLETRA := V_NUMEROENLETRA || 'SESENTA ';
            ELSIF DECENAS = 7 THEN
                V_NUMEROENLETRA := V_NUMEROENLETRA || 'SETENTA ';
            ELSIF DECENAS = 8 THEN
                V_NUMEROENLETRA := V_NUMEROENLETRA || 'OCHENTA ';
            ELSIF DECENAS = 9 THEN
                V_NUMEROENLETRA := V_NUMEROENLETRA || 'NOVENTA ';
            ELSIF DECENAS = 1 THEN
                IF UNIDADES < 6 THEN
                    IF UNIDADES = 0 THEN
                        V_NUMEROENLETRA := V_NUMEROENLETRA || 'DIEZ ';
                    ELSIF UNIDADES = 1 THEN
                        V_NUMEROENLETRA := V_NUMEROENLETRA || 'ONCE ';
                    ELSIF UNIDADES = 2 THEN
                        V_NUMEROENLETRA := V_NUMEROENLETRA || 'DOCE ';
                    ELSIF UNIDADES = 3 THEN
                        V_NUMEROENLETRA := V_NUMEROENLETRA || 'TRECE ';
                    ELSIF UNIDADES = 4 THEN
                        V_NUMEROENLETRA := V_NUMEROENLETRA || 'CATORCE ';
                    ELSIF UNIDADES = 5 THEN
                        V_NUMEROENLETRA := V_NUMEROENLETRA || 'QUINCE ';
                    END IF;
                    UNIDADES := 0;
                ELSE
                    V_NUMEROENLETRA := V_NUMEROENLETRA || 'DIECI';
                    UNIR            := NULL;
                END IF;
            ELSIF DECENAS = 2 THEN
                IF UNIDADES = 0 THEN
                    V_NUMEROENLETRA := V_NUMEROENLETRA || 'VEINTE ';
                ELSE
                    V_NUMEROENLETRA := V_NUMEROENLETRA || 'VEINTI';
                END IF;
                UNIR := NULL;
            ELSIF DECENAS = 0 THEN
                UNIR := NULL;
            END IF;

            -- OBTENIENDO UNIDADES
            IF UNIDADES = 1 THEN
                V_NUMEROENLETRA := V_NUMEROENLETRA || UNIR || 'UNO ';
            ELSIF UNIDADES = 2 THEN
                V_NUMEROENLETRA := V_NUMEROENLETRA || UNIR || 'DOS ';
            ELSIF UNIDADES = 3 THEN
                V_NUMEROENLETRA := V_NUMEROENLETRA || UNIR || 'TRES ';
            ELSIF UNIDADES = 4 THEN
                V_NUMEROENLETRA := V_NUMEROENLETRA || UNIR || 'CUATRO ';
            ELSIF UNIDADES = 5 THEN
                V_NUMEROENLETRA := V_NUMEROENLETRA || UNIR || 'CINCO ';
            ELSIF UNIDADES = 6 THEN
                V_NUMEROENLETRA := V_NUMEROENLETRA || UNIR || 'SEIS ';
            ELSIF UNIDADES = 7 THEN
                V_NUMEROENLETRA := V_NUMEROENLETRA || UNIR || 'SIETE ';
            ELSIF UNIDADES = 8 THEN
                V_NUMEROENLETRA := V_NUMEROENLETRA || UNIR || 'OCHO ';
            ELSIF UNIDADES = 9 THEN
                V_NUMEROENLETRA := V_NUMEROENLETRA || UNIR || 'NUEVE ';
            END IF;
        END IF;

        RETURN(V_NUMEROENLETRA);

    EXCEPTION
        WHEN NUMERO_ENTERO THEN
            RETURN('ERROR: EL NUMERO NO ES ENTERO');
            RAISE;
        WHEN FUERA_DE_RANGO THEN
            RETURN('ERROR: NUMERO FUERA DE RANGO');
            RAISE;
        WHEN OTHERS THEN
            RAISE;
    END;

    END F_OBT_NUMERO_MENOR_MIL;

    FUNCTION OC_NUMALETRAS(P_NUMEROENTERO IN NUMBER) RETURN VARCHAR2 IS

    --OBJETIVO    : FUNCION PARA OBTENER NUMERO CONVERTIDO EN LETRAS 

    FUERA_DE_RANGO EXCEPTION;

    N_MILLARES_DE_MILLON NUMBER;
    N_MILLONES           NUMBER;
    N_MILLARES           NUMBER;
    CENTENAS             NUMBER;
    CENTIMOS             NUMBER;
    V_NUMEROENLETRA      VARCHAR2(2000);
    N_ENTERO             NUMBER;
    AUX                  VARCHAR2(15);
    N_MILLARES_DE_BILLON NUMBER;

    BEGIN
        BEGIN
            IF P_NUMEROENTERO < 0 OR P_NUMEROENTERO > 999999999999999.99 THEN
                    RAISE FUERA_DE_RANGO;
            END IF;

            N_ENTERO := TRUNC(P_NUMEROENTERO);

            N_MILLARES_DE_BILLON := TRUNC(N_ENTERO / 1000000000000);

            N_MILLARES_DE_MILLON := TRUNC(MOD(N_ENTERO, 1000000000000) /1000000000);

            N_MILLONES := TRUNC(MOD(N_ENTERO, 1000000000) / 1000000);

            N_MILLARES := TRUNC(MOD(N_ENTERO, 1000000) / 1000);

            CENTENAS := MOD(N_ENTERO, 1000);

            CENTIMOS := MOD((ROUND(P_NUMEROENTERO, 2) * 100), 100);

            -- BILLONES DE MILLON
            IF N_MILLARES_DE_BILLON = 1 THEN
                IF N_MILLARES_DE_MILLON = 0 OR N_MILLARES_DE_BILLON = 1 THEN
                    V_NUMEROENLETRA := 'UN BILLON ';
                ELSE
                    V_NUMEROENLETRA := 'BILLON ';
                END IF;
            ELSIF N_MILLARES_DE_BILLON > 1 THEN

                V_NUMEROENLETRA := F_OBT_NUMERO_MENOR_MIL(N_MILLARES_DE_BILLON);

                IF N_MILLARES_DE_MILLON = 0 THEN
                    V_NUMEROENLETRA := V_NUMEROENLETRA || 'MIL BILLONES ';
                ELSE
                    V_NUMEROENLETRA := V_NUMEROENLETRA || 'BILLONES ';
                END IF;

            END IF;

            -- MILLARES DE MILLON
            IF N_MILLARES_DE_MILLON = 1 THEN
                IF N_MILLONES = 0 THEN
                    V_NUMEROENLETRA := V_NUMEROENLETRA || ' MIL MILLONES ';
                ELSE
                    V_NUMEROENLETRA := V_NUMEROENLETRA || ' MIL ';
                END IF;
            ELSIF N_MILLARES_DE_MILLON > 1 THEN

                V_NUMEROENLETRA := V_NUMEROENLETRA || F_OBT_NUMERO_MENOR_MIL(N_MILLARES_DE_MILLON);

                IF N_MILLONES = 0 THEN
                    V_NUMEROENLETRA := V_NUMEROENLETRA || 'MIL MILLONES ';
                ELSE
                    V_NUMEROENLETRA := V_NUMEROENLETRA || 'MIL ';
                END IF;

            END IF;

            -- MILLONES
            IF N_MILLONES = 1 AND N_MILLARES_DE_MILLON = 0 THEN
                V_NUMEROENLETRA := 'UN MILLON ';
            ELSIF N_MILLONES > 0 THEN
                V_NUMEROENLETRA := V_NUMEROENLETRA || F_OBT_NUMERO_MENOR_MIL(N_MILLONES) || 'MILLONES ';
            END IF;

            -- MILES
            IF N_MILLARES = 1 AND N_MILLARES_DE_MILLON = 0 AND N_MILLONES = 0 THEN
                V_NUMEROENLETRA := 'MIL ';
            ELSIF N_MILLARES > 0 THEN
                V_NUMEROENLETRA := V_NUMEROENLETRA || F_OBT_NUMERO_MENOR_MIL(N_MILLARES) || 'MIL ';
            END IF;

            -- CENTENAS
            IF CENTENAS > 0 OR (N_ENTERO = 0 AND CENTIMOS = 0) THEN
                V_NUMEROENLETRA := V_NUMEROENLETRA || F_OBT_NUMERO_MENOR_MIL(CENTENAS);
            END IF; 

            IF CENTIMOS > 0 THEN
                IF N_ENTERO > 0 THEN
                    V_NUMEROENLETRA := V_NUMEROENLETRA || 'CON ' || REPLACE(F_OBT_NUMERO_MENOR_MIL(CENTIMOS),'UNO ','UN ') || AUX;
            ELSE
                V_NUMEROENLETRA := V_NUMEROENLETRA ||REPLACE(F_OBT_NUMERO_MENOR_MIL(CENTIMOS),'UNO','UN') || AUX;
            END IF;
        END IF;

        RETURN(V_NUMEROENLETRA);

    EXCEPTION
        WHEN FUERA_DE_RANGO THEN
            RETURN('ERROR: NUMERO FUERA DE RANGO');
            RAISE;
        WHEN OTHERS THEN
            RETURN('ERROR:');
            RAISE;
    END;

    END OC_NUMALETRAS;

    FUNCTION OC_CARACTERES(P_CARACTER IN VARCHAR2) RETURN VARCHAR2 IS
        vl_Cadena   VARCHAR2(50) := NULL;
    BEGIN
        IF P_CARACTER = '@' THEN
            vl_Cadena := 'ARROBA';
        ELSIF P_CARACTER = '´' THEN
            vl_Cadena := 'APOSTROFE';
        ELSIF P_CARACTER = '%' THEN
            vl_Cadena := 'PORCIENTO';
        ELSIF P_CARACTER = '#' THEN
            vl_Cadena := 'NUMERO';
        ELSIF P_CARACTER = '!' THEN
            vl_Cadena := 'ADMIRACION';
        ELSIF P_CARACTER = '.' THEN
            vl_Cadena := 'PUNTO';
        ELSIF P_CARACTER = '$' THEN
            vl_Cadena := 'PESOS';
        ELSIF P_CARACTER = '"' THEN
            vl_Cadena := 'COMILLAS';
        ELSIF P_CARACTER = '-' THEN
            vl_Cadena := 'GUION';
        ELSIF P_CARACTER = '/' THEN
            vl_Cadena := 'DIAGONAL';
        ELSIF P_CARACTER = '+' THEN
            vl_Cadena := 'SUMA';
        ELSIF P_CARACTER = '(' THEN
            vl_Cadena := 'ABRE PARENTESIS';
        ELSIF P_CARACTER = ')' THEN
            vl_Cadena := 'CIERRA PARENTESIS';
        ELSIF P_CARACTER = '\' THEN
            vl_Cadena := 'DIAGONAL';
        ELSE
            vl_Cadena := 'XXX';
        END IF;

        RETURN vl_Cadena;
    EXCEPTION
        WHEN OTHERS THEN
            vl_Cadena := 'XXX';
            RETURN vl_Cadena;
    END OC_CARACTERES;

END OC_GENERARFC;
/

CREATE OR REPLACE PUBLIC SYNONYM OC_GENERARFC FOR SICAS_OC.OC_GENERARFC;
/

GRANT EXECUTE ON SICAS_OC.OC_GENERARFC TO PUBLIC;
/
