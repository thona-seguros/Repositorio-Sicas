--
-- OC_LETRAS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_LETRAS AS
FUNCTION miles (mil IN NUMBER) RETURN VARCHAR2;
FUNCTION millones (millon IN NUMBER) RETURN VARCHAR2;
FUNCTION nombre_decenas (digito IN NUMBER) RETURN VARCHAR2;
FUNCTION Letras (numero In NUMBER, cDescMoneda VARCHAR2) RETURN VARCHAR2;
FUNCTION Unidades (unidad IN NUMBER) RETURN VARCHAR2;
FUNCTION cientos (cien IN NUMBER) RETURN VARCHAR2;
FUNCTION decenas (decena IN NUMBER) RETURN VARCHAR2;
END OC_LETRAS;
/

--
-- OC_LETRAS  (Package Body) 
--
--  Dependencies: 
--   OC_LETRAS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_LETRAS AS
FUNCTION miles (mil IN NUMBER) RETURN VARCHAR2 IS
  numero    varchar(6);
  digitos   number;
  digito1   number;
  digito123 number;
BEGIN
  numero  := to_char(mil);
  digitos := length(numero);
  if digitos <= 3 then
    RETURN UPPER(cientos(mil));
  elsif digitos <= 6 then
    digito1   := to_number(substr(numero,1,(digitos-3)));
    digito123 := to_number(substr(numero,-3,3));
    if digito1 = 1 then
       if digito123 = 0 then
          RETURN UPPER('mil');
       else
          RETURN UPPER('mil '||cientos(digito123));
       end if;
    else
       if digito123 = 0 then
          RETURN UPPER(cientos(digito1)||' mil');
       else
          RETURN UPPER (cientos(digito1)||' mil '||cientos(digito123));
       end if;
    end if;
  else
    return('');
  end if;
END;
FUNCTION millones (millon IN NUMBER) RETURN VARCHAR2 IS
  numero    varchar(12);
  digitos   number;
  digito1   number;
  digito2   number;
BEGIN
  numero  := to_char(millon);
  digitos := length(numero);
  if digitos <= 6 then
    RETURN UPPER(miles(millon));
  elsif digitos <= 12 then
    digito1   := to_number(substr(numero,1,(digitos-6)));
    digito2   := to_number(substr(numero,-6,6));
    if digito1 = 1 then
       if digito2 = 0 then
          RETURN UPPER('un millon');
       else
          RETURN UPPER('un millon '||miles(digito2));
       end if;
    else
       if digito2 = 0 then
          RETURN UPPER(miles(digito1)||' millones');
       else
          RETURN UPPER(miles(digito1)||' millones '||miles(digito2));
       end if;
    end if;
  else
    return('');
  end if;
END;
FUNCTION decenas (decena IN NUMBER) RETURN VARCHAR2 IS
-- Convierte numeros de dos digitos a letras
  numero  varchar2(2);
  digitos number;
  digito1 number;
  digito2 number;
BEGIN
  numero  := to_char(decena);
  digitos := length(numero);
  if digitos = 1 then -- Si tiene solo un digito entoces devuelve unidades
    return UPPER(unidades(decena));
  elsif digitos = 2 then -- Esto es en el caso de dos digitos
    if decena = 10 then     -- Estos son casos especiales del 10 a 15
      RETURN UPPER('diez');
    elsif decena = 11 then
      RETURN UPPER('once');
    elsif decena = 12 then
      RETURN UPPER('doce');
    elsif decena = 13 then
      RETURN UPPER ('trece');
    elsif decena = 14 then
      RETURN UPPER ('catorce');
    elsif decena = 15 then
      RETURN UPPER('quince');
    elsif decena = 20 then
      RETURN UPPER('veinte');
    else
      digito1 := to_number(substr(numero,1,1));
      digito2 := to_number(substr(numero,2,1));
      if digito1 = 1 then    -- Estos los casos de 16 al 19
         RETURN UPPER('dieci'||unidades(digito2));
      elsif digito1 = 2 then -- Estos son los casos del 21 al 29
         RETURN UPPER ('veinti'||unidades(digito2));
      else                   -- El resto de los casos
         if digito2 = 0 then
           RETURN UPPER (nombre_decenas(digito1));
         else
           RETURN UPPER (nombre_decenas(digito1)||' y '||unidades(digito2));
         end if;
      end if;
    end if;
  else
    return('');
  end if;
END;
FUNCTION nombre_decenas (digito IN NUMBER) RETURN VARCHAR2 IS
BEGIN
  if digito = 1 then
    RETURN UPPER ('dieci');
  elsif digito = 2 then
    RETURN UPPER ('veinti');
  elsif digito = 3 then
    RETURN UPPER ('treinta');
  elsif digito = 4 then
    RETURN UPPER ('cuarenta');
  elsif digito = 5 then
    RETURN UPPER ('cincuenta');
  elsif digito = 6 then
    RETURN UPPER ('sesenta');
  elsif digito = 7 then
    RETURN UPPER ('setenta');
  elsif digito = 8 then
    RETURN UPPER ('ochenta');
  elsif digito = 9 then
    RETURN UPPER ('noventa');
  elsif digito = 0 then
    RETURN UPPER ('cero');
  else
    return('');
  end if;
END;
FUNCTION Letras (numero In NUMBER, cDescMoneda VARCHAR2) RETURN VARCHAR2 IS
  temp         NUMBER;
BEGIN
  temp := trunc(numero);
     If numero - temp = 0 Then
        RETURN UPPER (millones(temp)||' '||cDescMoneda||' con '||'00/100');
      Else
        RETURN UPPER (millones(temp)||' '||cDescMoneda||' con '||Lpad(TO_CHAR(((numero - temp) * 100)),2,'0')||'/100');
     end if;
END;
FUNCTION Unidades (unidad IN NUMBER) RETURN VARCHAR2 IS
-- Convierte los numero desde 0 hasta 9 a letras
BEGIN
  if unidad = 1 then
    RETURN UPPER ('un');
  elsif unidad = 2 then
    RETURN UPPER ('dos');
  elsif unidad = 3 then
    RETURN UPPER ('tres');
  elsif unidad = 4 then
    RETURN UPPER ('cuatro');
  elsif unidad = 5 then
    RETURN UPPER ('cinco');
  elsif unidad = 6 then
    RETURN UPPER ('seis');
  elsif unidad = 7 then
    RETURN UPPER ('siete');
  elsif unidad = 8 then
    RETURN UPPER('ocho');
  elsif unidad = 9 then
    RETURN UPPER ('nueve');
  elsif unidad = 0 then
    RETURN UPPER('cero');
  else
    return('');
  end if;
END;
FUNCTION cientos (cien IN NUMBER) RETURN VARCHAR2 IS
-- convierte numeros de tres o menos digitos as letras
  numero   varchar2(3);
  digitos  number;
  digito1  number;
  digito23 number;
BEGIN
  numero  := to_char(cien);
  digitos := length(numero);
  if digitos <= 2 then     -- En el caso de que el numero sea de uno
    RETURN UPPER (decenas(cien)); -- o dos digitos
  elsif digitos = 3 then   -- En el caso de que sean tres digitos
    digito1  := to_number(substr(numero,1,1));
    digito23 := to_number(substr(numero,2,2));
    if digito1 = 1 then     -- El caso del cien
      if digito23 = 0 then
         RETURN UPPER('cien');
      else
         RETURN UPPER('ciento '||decenas(digito23));
      end if;
    elsif digito1 = 5 then  -- El caso de los quinientos
      if digito23 = 0 then
         RETURN UPPER('quinientos');
      else
         RETURN UPPER('quinientos '||decenas(digito23));
      end if;
    elsif digito1 = 9 then  -- El caso de los novecientos
      if digito23 = 0 then
         RETURN UPPER ('novecientos');
      else
         RETURN UPPER('novecientos '||decenas(digito23));
      end if;
    elsif digito1 = 7 then  -- El caso de los setecientos
      if digito23 = 0 then
         RETURN UPPER('setecientos');
      else
         RETURN UPPER('setecientos '||decenas(digito23));
      end if;

    else                    -- El resto de los casos
      if digito23 = 0 then
        RETURN UPPER(unidades(digito1)||'cientos');
      else
        RETURN UPPER(unidades(digito1)||'cientos '||decenas(digito23));
      end if;
    end if;
  else
    return('');
  end if;
END;
END OC_LETRAS;
/

--
-- OC_LETRAS  (Synonym) 
--
--  Dependencies: 
--   OC_LETRAS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_LETRAS FOR SICAS_OC.OC_LETRAS
/


GRANT EXECUTE ON SICAS_OC.OC_LETRAS TO PUBLIC
/
