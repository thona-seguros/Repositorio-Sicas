--> Homologacion de datos de tipo_persona en PERSONA_NATURAL_JURIDICA :
UPDATE  PERSONA_NATURAL_JURIDICA --> 1
SET     tipo_persona = 'MORAL'
WHERE   tipo_persona = 'MORALE';
/
UPDATE  PERSONA_NATURAL_JURIDICA --> 2
SET     tipo_persona = 'MORAL'
WHERE   tipo_persona = 'M';
/
UPDATE  PERSONA_NATURAL_JURIDICA --> 23
SET     tipo_persona = 'FISICA'
WHERE   tipo_persona = 'F';
/
UPDATE  PERSONA_NATURAL_JURIDICA --> 5994535
SET     tipo_persona = 'FISICA'
WHERE   tipo_persona IS NULL;
/
COMMIT;
/