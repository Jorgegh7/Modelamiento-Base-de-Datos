DROP SEQUENCE SQC_COMUNA;
DROP SEQUENCE SQC_COMPANIA;

DROP TABLE DOMINIO;
DROP TABLE IDIOMA;

DROP TABLE TITULACION;
DROP TABLE PERSONAL;
DROP TABLE COMPANIA;

DROP TABLE COMUNA;
DROP TABLE ESTADO_CIVIL;
DROP TABLE GENERO;
DROP TABLE TITULO;

DROP TABLE REGION;

/* =======================================================
   PRY2204 - Exp3 - Semana 7 (formato estandarizado)
   ======================================================= */

/* ------------------------------------------
   CASO 1: CREACIÓN DEL MODELO RELACIONAL
   ------------------------------------------ */
   
CREATE TABLE REGION
    (
    id_region NUMBER (2) GENERATED ALWAYS AS IDENTITY
    START WITH 7
    INCREMENT BY 2 NOT NULL,
    nombre_region VARCHAR2 (25) NOT NULL,
    CONSTRAINT PK_REGION PRIMARY KEY (id_region),
    CONSTRAINT UN_nombre_region UNIQUE (nombre_region)
);

CREATE TABLE COMUNA
    (
    id_comuna NUMBER (5) NOT NULL, 
    nombre_comuna VARCHAR2(25) NOT NULL,
    id_region NUMBER (2) NOT NULL,
    CONSTRAINT PK_COMUNA PRIMARY KEY (id_comuna),
    CONSTRAINT UN_COMUNA UNIQUE (nombre_comuna),
    CONSTRAINT FK_REGION
        FOREIGN KEY (id_region) REFERENCES REGION (id_region) 
);

CREATE TABLE COMPANIA
    (
    id_empresa NUMBER (2) NOT NULL,
    nombre_empresa VARCHAR2 (25) NOT NULL,
    id_comuna NUMBER (5) NOT NULL,
    id_region NUMBER (2)NOT NULL, 
    calle VARCHAR2 (50) NOT NULL,
    numeracion NUMBER (5) NOT NULL,
    renta_promedio NUMBER (10) NOT NULL,
    pct_aumento NUMBER (3,4),
    CONSTRAINT PK_COMPANIA PRIMARY KEY ( id_empresa),
    CONSTRAINT UN_nombre_empresa UNIQUE (nombre_empresa),
    CONSTRAINT FK_COMPANIA_COMUNA 
        FOREIGN KEY (id_comuna) REFERENCES COMUNA (id_comuna),
    CONSTRAINT FK_COMPANIA_REGION 
        FOREIGN KEY (id_region) REFERENCES REGION (id_region)    
);

CREATE TABLE ESTADO_CIVIL
    (
    id_estadociv VARCHAR2 (2) NOT NULL,
    descripcion_estdociv VARCHAR2 (25) NOT NULL,
    CONSTRAINT PK_ESTADO_CIVIL PRIMARY KEY (id_estadociv)    
);

CREATE TABLE GENERO
    (
    id_genero VARCHAR2 (3) NOT NULL,
    descripcion_genero VARCHAR2 (25) NOT NULL,
    CONSTRAINT PK_GENERO PRIMARY KEY (id_genero)    
);

CREATE TABLE IDIOMA
    (
    id_idioma NUMBER (3) GENERATED ALWAYS AS IDENTITY
    START WITH 25
    INCREMENT BY 3 NOT NULL,
    nombre_idioma VARCHAR2 (30) NOT NULL,
    CONSTRAINT PK_IDIOMA PRIMARY KEY (id_idioma)    
);

CREATE TABLE TITULO
    (
    id_titulo VARCHAR2 (3) NOT NULL,
    descripcion_titulo VARCHAR2 (25) NOT NULL,
    CONSTRAINT PK_TITULO PRIMARY KEY (id_titulo)
);

CREATE TABLE PERSONAL
    (
    rut_persona NUMBER (8) NOT NULL,
    dv_persona VARCHAR2 (1) NOT NULL,
    p_nombre VARCHAR2 (25) NOT NULL,
    s_nombre VARCHAR2 (25),
    p_apellido VARCHAR2 (25) NOT NULL,
    s_apellido VARCHAR2 (25) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    fecha_contratacion DATE NOT NULL,
    email VARCHAR2 (100),
    calle VARCHAR2 (50) NOT NULL,
    numeracion NUMBER (5) NOT NULL, 
    sueldo NUMBER (5) NOT NULL,
    
    id_comuna NUMBER (5) NOT NULL, 
    id_empresa NUMBER (2) NOT NULL,
    id_estadociv VARCHAR2 (2) NOT NULL,
    id_genero VARCHAR2 (3) NOT NULL,
    rut_encargado VARCHAR2(8),
    
    CONSTRAINT PK_PERSONAL PRIMARY KEY (rut_persona),
    
    CONSTRAINT FK_COMPANIA
        FOREIGN KEY (id_empresa) REFERENCES COMPANIA (id_empresa),
        
    CONSTRAINT COMUNA
        FOREIGN KEY (id_comuna) REFERENCES COMUNA (id_comuna),
        
    CONSTRAINT FK_ESTADO_CIVIL
        FOREIGN KEY (id_estadociv) REFERENCES ESTADO_CIVIL (id_estadociv),
        
    CONSTRAINT FK_GENERO
        FOREIGN KEY (id_genero) REFERENCES GENERO (id_genero),
        
    CONSTRAINT FK_PERSONAL_PERSONAL
        FOREIGN KEY (rut_persona) REFERENCES PERSONAL (rut_persona)   
);

CREATE TABLE TITULACION
    (
    id_titulo VARCHAR2 (3) NOT NULL,
    rut_persona NUMBER (8) NOT NULL, 
    fecha_titulacion DATE NOT NULL,
    CONSTRAINT FK_ID_TITULO
        FOREIGN KEY (id_titulo) REFERENCES TITULO (id_titulo),
    CONSTRAINT FK_RUT_PERSONA
        FOREIGN KEY (rut_persona) REFERENCES PERSONAL (rut_persona)  
);

CREATE TABLE DOMINIO
    (
    id_idioma NUMBER (3) NOT NULL,
    rut_persona NUMBER (8) NOT NULL,
    nivel VARCHAR2 (25) NOT NULL,
    CONSTRAINT FK_ID_IDIOMA
        FOREIGN KEY (id_idioma) REFERENCES IDIOMA (id_idioma),
    CONSTRAINT FK_RUT_PERSONA_IDIOMA
        FOREIGN KEY (rut_persona) REFERENCES PERSONAL (rut_persona)   
);


/* ------------------------------------------
   CASO 2: ALTER TABLE
   ------------------------------------------ */

ALTER TABLE PERSONAL
ADD CONSTRAINT UN_PERSONAL_EMAIL UNIQUE (email)
ADD CONSTRAINT CK_PERSONAL_dv 
    CHECK ( dv_persona IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'K' ) )
ADD CONSTRAINT CK_PERSONAL_sueldo 
    CHECK (sueldo >= 450000);
ALTER TABLE COMPANIA MODIFY pct_aumento NUMBER(4,3);    

/* ------------------------------------------
   CASO 3: POBLAMIENTO 
   ------------------------------------------ */
   
CREATE SEQUENCE SQC_COMUNA
START WITH 1101
INCREMENT BY 6; 

CREATE SEQUENCE SQC_COMPANIA
START WITH 10
INCREMENT BY 5; 

/* REGION  */

INSERT INTO REGION ( nombre_region ) VALUES ('ARICA Y PARINACOTA');
INSERT INTO REGION ( nombre_region ) VALUES ('METROPOLITANA');
INSERT INTO REGION ( nombre_region ) VALUES ('LA ARAUCANIA'); 

/* COMUNA  */ 

--COMUNA #1
INSERT INTO COMUNA (id_comuna, nombre_comuna, id_region)
VALUES (SQC_COMUNA.NEXTVAL, 'Arica',(SELECT id_region FROM REGION WHERE nombre_region = 'ARICA Y PARINACOTA' ));

--COMUNA #2
INSERT INTO COMUNA (id_comuna, nombre_comuna, id_region)
VALUES (SQC_COMUNA.NEXTVAL, 'Santiago',(SELECT id_region FROM REGION WHERE nombre_region = 'METROPOLITANA' ));

--COMUNA #3
INSERT INTO COMUNA (id_comuna, nombre_comuna, id_region)
VALUES (SQC_COMUNA.NEXTVAL, 'Temuco',(SELECT id_region FROM REGION WHERE nombre_region = 'LA ARAUCANIA' ));

/* COMPAÑIA  */ 

--COMPANIA #1
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (SQC_COMPANIA.NEXTVAL, 'CCyRojas', 'Amapolas', 506, 1857000, 0.5, 1101,(SELECT id_region FROM COMUNA WHERE id_comuna = 1101)); 

--COMPANIA #2    
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (SQC_COMPANIA.NEXTVAL, 'SenTTy','Los Alamos', 3490, 897000, 0.025, 1101, (SELECT id_region FROM COMUNA WHERE id_comuna = 1101));  

--COMPANIA #3
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (SQC_COMPANIA.NEXTVAL, 'Praxia LTDA', 'Las Camelias', 11098, 2157000, 0.035, 1107 ,(SELECT id_region FROM COMUNA WHERE id_comuna = 1107)); 

--COMPANIA #4
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (SQC_COMPANIA.NEXTVAL, 'TIC spa', 'Flores S.A', 4357, 857000, NULL, 1107, (SELECT id_region FROM COMUNA WHERE id_comuna = 1107)); 

--COMPANIA #5
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (SQC_COMPANIA.NEXTVAL, 'SANTANA LTDA', 'AVDA VIC. MACKENA', 106, 757000, 0.015, 1101,(SELECT id_region FROM COMUNA WHERE id_comuna = 1101));

--COMPANIA #6
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (SQC_COMPANIA.NEXTVAL, 'FLORES Y ASOCIADOS', 'PEDRO LATORRE', 557, 589000, 0.015, 1107, (SELECT id_region FROM COMUNA WHERE id_comuna = 1107));

--COMPANIA #7
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (SQC_COMPANIA.NEXTVAL, 'J.A. HOFFMAN', 'LATINA D.32', 509, 1857000, 0.025, 1113, (SELECT id_region FROM COMUNA WHERE id_comuna = 1113));

--COMPANIA #8
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (SQC_COMPANIA.NEXTVAL, 'CAGLIARI D.', 'ALAMEDA', 206, 1857000, NULL, 1107, (SELECT id_region FROM COMUNA WHERE id_comuna = 1107));

--COMPANIA #9
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (SQC_COMPANIA.NEXTVAL, 'Rojas HNOS LTDA', 'SUCRE', 106, 957000, 0.005, 1113, (SELECT id_region FROM COMUNA WHERE id_comuna = 1113));

--COMPANIA #10
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (SQC_COMPANIA.NEXTVAL, 'FRIENDS P. S.A', 'SUECIA', 506, 857000, 0.015, 1113, (SELECT id_region FROM COMUNA WHERE id_comuna = 1113));
                           
/* IDIOMA  */

--IDIOMA #1
INSERT INTO IDIOMA (nombre_idioma)
VALUES ('Ingles'); 

--IDIOMA #2
INSERT INTO IDIOMA (nombre_idioma)
VALUES ('Chino'); 

--IDIOMA #3
INSERT INTO IDIOMA (nombre_idioma)
VALUES ('Aleman'); 

--IDIOMA #4
INSERT INTO IDIOMA (nombre_idioma)
VALUES ('Espanol'); 

--IDIOMA #5
INSERT INTO IDIOMA (nombre_idioma)
VALUES ('Frances'); 

/* Informes */

--INFORME 1

SELECT
    nombre_empresa AS "Nombre Empresa",
    (calle || ' ' || numeracion) AS "DIRECCION",
    renta_promedio AS "Renta Promedio",
    (renta_promedio * (1 + pct_aumento)) AS "Simulación de Renta"
FROM COMPANIA
ORDER BY renta_promedio DESC, nombre_empresa;

--INFORME 2

SELECT 
    id_empresa AS "CODIGO",
    nombre_empresa AS "EMPRESA",
    renta_promedio AS "PROM RENTA ACTUAL",
    pct_aumento + 0.15 AS "PCT AUMENTADO EN 15%",
    renta_promedio * (pct_aumento + 0.15) AS "RENTA AUMENTADA"
FROM COMPANIA
ORDER BY renta_promedio ASC; 




                           
SELECT * FROM COMPANIA
ORDER BY id_empresa;

SELECT * FROM REGION;

SELECT * FROM COMUNA;

SELECT * FROM IDIOMA;

DELETE FROM COMPANIA;

DELETE FROM IDIOMA;

DROP SEQUENCE SQC_COMPANIA;
















