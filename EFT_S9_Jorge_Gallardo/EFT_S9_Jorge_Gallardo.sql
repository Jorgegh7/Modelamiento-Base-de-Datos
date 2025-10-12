DROP TABLE COMUNA CASCADE CONSTRAINTS;
DROP TABLE REGION CASCADE CONSTRAINTS;

DROP TABLE SALUD CASCADE CONSTRAINTS;
DROP TABLE AFP CASCADE CONSTRAINTS;

DROP TABLE PLANTA CASCADE CONSTRAINTS;
DROP TABLE MAQUINA CASCADE CONSTRAINTS;
DROP TABLE TIPO_MAQUINA CASCADE CONSTRAINTS;

DROP TABLE TURNO CASCADE CONSTRAINTS;
DROP TABLE ASIGNACION_TURNO CASCADE CONSTRAINTS;

DROP TABLE EMPLEADO CASCADE CONSTRAINTS;

DROP TABLE AREA_RESPONSABILIDAD CASCADE CONSTRAINTS;
DROP TABLE CATEGORIA_PROCESO CASCADE CONSTRAINTS;
DROP TABLE ESPECIALIDAD CASCADE CONSTRAINTS;

DROP TABLE JEFE_TURNO CASCADE CONSTRAINTS;
DROP TABLE OPERARIO CASCADE CONSTRAINT;
DROP TABLE TECNICO_MANTENCION CASCADE CONSTRAINTS;

DROP TABLE EMPLEADO_CERTIFICACION CASCADE CONSTRAINTS;
DROP TABLE CERTIFICACION CASCADE CONSTRAINTS;

DROP TABLE TIPO_MANTENIMIENTO CASCADE CONSTRAINTS;
DROP TABLE ORDEN_MANTENIMIENTO CASCADE CONSTRAINTS;

/* =======================================================
   PRY2204 - EFT - Semana 9 - Jorge Gallardo
   ======================================================= */
   
--PASO 1: CREAR TABLAS   
   
--#1   
CREATE TABLE REGION
    (
    id_region NUMBER (4) NOT NULL,
    nom_region VARCHAR2 (50)NOT NULL,
    CONSTRAINT PK_REGION PRIMARY KEY (id_region),
    CONSTRAINT UK_REGION_NOM_REGION UNIQUE (nom_region)
);   

--#2
CREATE TABLE COMUNA
    (
    id_comuna NUMBER (4) GENERATED ALWAYS AS IDENTITY
    START WITH 1050 
    INCREMENT BY 5 NOT NULL, 
    nom_comuna VARCHAR2(50) NOT NULL,
    id_region NUMBER (4) NOT NULL,
    CONSTRAINT PK_COMUNA PRIMARY KEY (id_comuna),
    CONSTRAINT FK_COMUNA_REGION
        FOREIGN KEY (id_region) REFERENCES REGION (id_region)   
);

--#3
CREATE TABLE AFP
    (
    id_afp NUMBER (3) NOT NULL, 
    nom_afp VARCHAR2 (255) NOT NULL,
    CONSTRAINT PK_AFP PRIMARY KEY (id_afp),
    CONSTRAINT UK_COMUNA_NOM_AFP UNIQUE (nom_afp) 
);

--#4
CREATE TABLE SALUD
    (
    id_salud NUMBER (4) NOT NULL, 
    nom_salud VARCHAR2 (40) NOT NULL,
    CONSTRAINT PK_SALUD PRIMARY KEY (id_salud),
    CONSTRAINT UK_SALUD_NOM_SALUD UNIQUE (nom_salud) 
);

--#5
CREATE TABLE PLANTA
    (
    id_planta NUMBER (4) NOT NULL,
    nombre_planta VARCHAR2 (50) NOT NULL,
    direccion VARCHAR2 (200) NOT NULL,
    id_comuna NUMBER (4) NOT NULL,
    CONSTRAINT PK_PLANTA PRIMARY KEY (id_planta),
    CONSTRAINT FK_PLANTA_COMUNA
        FOREIGN KEY (id_comuna) REFERENCES COMUNA (id_comuna)
);

--#6
CREATE TABLE TURNO
    (
    id_turno CHAR (5) NOT NULL,
    nombre_turno VARCHAR2 (20) NOT NULL,
    hora_inicio CHAR (5) NOT NULL,
    hora_termino CHAR (5) NOT NULL,
    CONSTRAINT PK_TURNO PRIMARY KEY (id_turno),
    CONSTRAINT UK_TURNO_NOM_TURNO UNIQUE (nombre_turno) 
);

--#7
CREATE TABLE TIPO_MAQUINA
    (
    id_tipo_maquina NUMBER (3) NOT NULL,
    nom_tipo_maquina VARCHAR2 (50) NOT NULL,
    CONSTRAINT PK_TIPO_MAQUINA PRIMARY KEY (id_tipo_maquina),
    CONSTRAINT UK_TIPO_MAQ_NOM_MAQ UNIQUE (nom_tipo_maquina) 
);

--#8
CREATE TABLE MAQUINA
    (
    id_maquina NUMBER (6) NOT NULL,
    nombre_maquina VARCHAR2 (50) NOT NULL,
    activo CHAR (1) NOT NULL,
    id_tipo_maquina NUMBER (3) NOT NULL,
    id_planta NUMBER (4) NOT NULL,
    CONSTRAINT PK_MAQUINA PRIMARY KEY (id_maquina, id_planta),
    CONSTRAINT FK_MAQUINA_PLANTA
        FOREIGN KEY (id_planta) REFERENCES PLANTA (id_planta),
    CONSTRAINT FK_MAQUINA_ID_TIPO_MAQUINA
        FOREIGN KEY (id_tipo_maquina) REFERENCES TIPO_MAQUINA (id_tipo_maquina)
);

--#9
CREATE TABLE CERTIFICACION
    (
    id_certificacion NUMBER (3) NOT NULL,
    nombre_certificacion VARCHAR2 (50) NOT NULL,
    CONSTRAINT PK_CERTIFICACION PRIMARY KEY (id_certificacion)
);

--#10
CREATE TABLE TIPO_MANTENIMIENTO
    (
    id_tipo_mant NUMBER (3) NOT NULL,
    nombre_mant VARCHAR2 (50) NOT NULL,
    CONSTRAINT PK_TIPO_MANTENIMIENTO PRIMARY KEY (id_tipo_mant)  
);

--#11
CREATE TABLE EMPLEADO
    (
    id_empleado NUMBER (6) NOT NULL,
    rut_empleado VARCHAR2 (10) NOT NULL,
    p_nombre VARCHAR2 (50) NOT NULL,
    s_nombre VARCHAR2 (50),
    ap_paterno VARCHAR2 (50) NOT NULL,
    ap_materno VARCHAR2 (50) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    activo CHAR (1) DEFAULT 'S' NOT NULL,
    sueldo_base NUMBER (8) NOT NULL,
    id_afp NUMBER (3) NOT NULL,
    id_salud NUMBER (4) NOT NULL,
    id_planta NUMBER (4) NOT NULL,
    id_jefe NUMBER (6),
    CONSTRAINT PK_EMPLEADO PRIMARY KEY (id_empleado),
    
    CONSTRAINT FK_EMPLEADO_AFP
        FOREIGN KEY (id_afp) REFERENCES AFP (id_afp),
    CONSTRAINT FK_EMPLEADO_SALUD
        FOREIGN KEY (id_salud) REFERENCES SALUD (id_salud),
    CONSTRAINT FK_EMPLEADO_PLANTA
        FOREIGN KEY (id_planta) REFERENCES PLANTA (id_planta),
    CONSTRAINT FK_EMPLEADO_EMPLEADO
        FOREIGN KEY (id_jefe) REFERENCES EMPLEADO (id_empleado)
);

--#12
CREATE TABLE EMPLEADO_CERTIFICACION
    (
    id_empleado NUMBER (6) NOT NULL,
    id_certificacion NUMBER (3) NOT NULL,
    CONSTRAINT PK_EMPLEADO_CERTIFICACION 
        PRIMARY KEY (id_empleado, id_certificacion),
    
    CONSTRAINT FK_EMPLEADO_CERT_EMPLEADO
        FOREIGN KEY (id_empleado) REFERENCES EMPLEADO (id_empleado),
    CONSTRAINT FK_EMPLEADO_CERT_CERTIFICACION
        FOREIGN KEY (id_certificacion) REFERENCES CERTIFICACION (id_certificacion)
);

--#13
CREATE TABLE AREA_RESPONSABILIDAD
    (
    id_area_resp NUMBER (3) NOT NULL,
    nombre_area_resp VARCHAR2 (20) NOT NULL,
    CONSTRAINT PK_AREA_RESP PRIMARY KEY (id_area_resp)    
);

--#14
CREATE TABLE JEFE_TURNO
    (
    id_empleado NUMBER (6) NOT NULL,
    maximo_operarios NUMBER (4) NOT NULL,
    id_area_resp NUMBER (3) NOT NULL,
    CONSTRAINT PK_JEFE_TURNO PRIMARY KEY (id_empleado),
    
    CONSTRAINT FK_JEFE_TURNO_EMPLEADO
        FOREIGN KEY (id_empleado) REFERENCES EMPLEADO (id_empleado)
        ON DELETE CASCADE,
    CONSTRAINT FK_JEFE_TURNO_AREA_RESP
        FOREIGN KEY (id_area_resp) REFERENCES AREA_RESPONSABILIDAD (id_area_resp)
);

--#15
CREATE TABLE CATEGORIA_PROCESO
    (
    id_categoria_pro NUMBER (2) NOT NULL,
    nombre_categoria_pro VARCHAR2 (50) NOT NULL,
    CONSTRAINT PK_CATEGORIA_PROCESO PRIMARY KEY (id_categoria_pro)
);

--#16
CREATE TABLE OPERARIO
    (
    id_empleado NUMBER (6) NOT NULL,
    horas_turno NUMBER (2)DEFAULT 8 NOT NULL,
    id_categoria_pro NUMBER (2) NOT NULL,
    CONSTRAINT PK_OPERARIO PRIMARY KEY (id_empleado),
    
    CONSTRAINT FK_OPERARIO_EMPLEADO
        FOREIGN KEY (id_empleado) REFERENCES EMPLEADO (id_empleado)
        ON DELETE CASCADE,
    CONSTRAINT FK_OPERARIO_CAT_PROCESO
        FOREIGN KEY (id_categoria_pro) REFERENCES CATEGORIA_PROCESO (id_categoria_pro)
);

--#17
CREATE TABLE ESPECIALIDAD
    (
    id_especialidad NUMBER (3) NOT NULL,
    nombre_especialidad VARCHAR2 (50) NOT NULL,
    CONSTRAINT PK_ESPECIALIDAD PRIMARY KEY (id_especialidad)    
);

--#18
CREATE TABLE TECNICO_MANTENCION
    (
    id_empleado NUMBER (6) NOT NULL,
    tiempo_respuesta NUMBER (2) NOT NULL,
    id_especialidad NUMBER (3) NOT NULL,
    CONSTRAINT PK_TECNICO_MANTENCION PRIMARY KEY (id_empleado),
    
    CONSTRAINT FK_TECNICO_MANT_EMPLEADO
        FOREIGN KEY (id_empleado) REFERENCES EMPLEADO (id_empleado)
        ON DELETE CASCADE,
    CONSTRAINT FK_TECNICO_MANT_ESPECIALIDA
        FOREIGN KEY (id_especialidad) REFERENCES ESPECIALIDAD (id_especialidad)   
);

--#19
CREATE TABLE ORDEN_MANTENIMIENTO
    (
    id_orden_mant NUMBER (6) NOT NULL,
    fecha_programada DATE NOT NULL,
    fecha_mantencion DATE NOT NULL,
    descripcion VARCHAR2 (1000) NOT NULL,
    id_planta NUMBER (4) NOT NULL, 
    id_maquina NUMBER (6) NOT NULL,
    id_empleado NUMBER (6) NOT NULL,
    id_tipo_mant NUMBER (3) NOT NULL,
    CONSTRAINT PK_ORDEN_MANTENIMIENTO PRIMARY KEY (id_orden_mant),
    
    CONSTRAINT FK_ORDEN_MANT_MAQUINA
        FOREIGN KEY (id_maquina, id_planta) REFERENCES MAQUINA (id_maquina, id_planta),
    CONSTRAINT FK_ORDEN_MANT_EMPLEADO
        FOREIGN KEY (id_empleado) REFERENCES EMPLEADO (id_empleado),
    CONSTRAINT FK_ORDEN_MANT_TIPO_MANT
        FOREIGN KEY (id_tipo_mant) 
        REFERENCES TIPO_MANTENIMIENTO (id_tipo_mant)    
);

--#20
CREATE TABLE ASIGNACION_TURNO
    (
    fecha DATE NOT NULL,
    id_empleado NUMBER (6) NOT NULL,
    id_planta NUMBER (4) NOT NULL, 
    id_maquina NUMBER (6) NOT NULL,
    id_turno CHAR (1) NOT NULL,
    CONSTRAINT PK_ASIGNACION_TURNO PRIMARY KEY (id_empleado, fecha),
    
    CONSTRAINT FK_ASIGNACION_TURNO_EMPLEADO
        FOREIGN KEY (id_empleado) REFERENCES EMPLEADO (id_empleado),
    CONSTRAINT FK_ASIGNACION_TURNO_MAQUINA
        FOREIGN KEY (id_maquina, id_planta) REFERENCES MAQUINA (id_maquina, id_planta),
    CONSTRAINT FK_ASIGNACION_TURNO_TURNO
        FOREIGN KEY (id_turno) REFERENCES TURNO (id_turno)
);


CREATE SEQUENCE SQC_REGION
START WITH 21
INCREMENT BY 1; 

-- CK Ordena Mantenimiento
ALTER TABLE ORDEN_MANTENIMIENTO
ADD CONSTRAINT CK_FECHA_EJECUCION 
CHECK (fecha_mantencion >= fecha_programada);

--PASO 2: POBLAMIENTO

/* REGION  */

INSERT INTO REGION (id_region, nom_region ) VALUES (SQC_REGION.NEXTVAL, 'Región de Valparaíso');
INSERT INTO REGION (id_region, nom_region ) VALUES (SQC_REGION.NEXTVAL, 'Región Metropolitana');

/* COMUNA  */

INSERT INTO COMUNA (nom_comuna, id_region) VALUES ('Quilpué', 21); 
INSERT INTO COMUNA (nom_comuna, id_region) VALUES ('Maipú', 22);

/* PLANTA  */

INSERT INTO PLANTA (id_planta, nombre_planta, direccion, id_comuna) VALUES (45, 'Planta Oriente', 'Camino Industrial 1234', 1050); 
INSERT INTO PLANTA (id_planta, nombre_planta, direccion, id_comuna) VALUES (46, 'Planta Costa', 'Av. Vidrieras 890', 1055); 

/* TURNO  */

INSERT INTO TURNO (id_turno, nombre_turno, hora_inicio, hora_termino) VALUES ('M0715', 'Mañana', '07:00', '15:00'); 
INSERT INTO TURNO (id_turno, nombre_turno, hora_inicio, hora_termino) VALUES ('T1523', 'Tarde', '15:00', '23:00');
INSERT INTO TURNO (id_turno, nombre_turno, hora_inicio, hora_termino) VALUES ('N2307', 'Noche', '23:00', '07:00');

--PASO 3: RECUPERACION DE DATOS

--INFORME #1
SELECT 
    id_turno || ' - ' || nombre_turno  AS TURNO, 
    hora_inicio AS ENTRADA, 
    hora_termino AS SALIDA 
FROM TURNO
WHERE hora_inicio > '20:00'
ORDER BY hora_inicio DESC;

--INFORME #2
SELECT 
    nombre_turno || ' - ' || id_turno    AS TURNO, 
    hora_inicio AS ENTRADA, 
    hora_termino AS SALIDA 
FROM TURNO
WHERE hora_inicio BETWEEN '06:00' AND '14:59'
ORDER BY hora_inicio ASC;























































