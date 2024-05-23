ALTER TABLE SOLICITUD_EMISION ADD (
IndConcentrada    VARCHAR2(1)  DEFAULT null,
CodTipoNegocio    VARCHAR2(100) DEFAULT null,
CodCatego	      VARCHAR2(14) DEFAULT null,
TipoRiesgo        VARCHAR2(6) DEFAULT null,
Formaventa        VARCHAR2(6) DEFAULT null,
CodObjetoImp      VARCHAR2(10) DEFAULT null,
CodUsoCfdi        VARCHAR2(10) DEFAULT null);