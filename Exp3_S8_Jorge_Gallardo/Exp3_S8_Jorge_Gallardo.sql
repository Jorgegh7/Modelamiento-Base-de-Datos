
DROP TABLE COMUNA CASCADE CONSTRAINTS;
DROP TABLE REGION CASCADE CONSTRAINTS;
DROP TABLE SALUD CASCADE CONSTRAINTS;
DROP TABLE AFP CASCADE CONSTRAINTS;
DROP TABLE EMPLEADO CASCADE CONSTRAINTS;

/* =======================================================
   PRY2204 - Exp3 - Semana 8 
   ======================================================= */

/* ------------------------------------------
   CASO 1: CONSTRUCCIÓN DEL MODELO RELACIONAL
   ------------------------------------------ */ 
   
CREATE TABLE REGION
    (
    id_region NUMBER (4) NOT NULL,
    nom_region VARCHAR2 (255)NOT NULL,
    CONSTRAINT PK_REGION PRIMARY KEY (id_region) 
);

CREATE TABLE COMUNA
    (
    id_comuna NUMBER (4) NOT NULL, 
    nom_comuna VARCHAR2(100) NOT NULL,
    id_region NUMBER (4) NOT NULL,
    CONSTRAINT PK_COMUNA PRIMARY KEY (id_comuna),
    CONSTRAINT FK_REGION
        FOREIGN KEY (id_region) REFERENCES REGION (id_region) 
);

CREATE TABLE AFP
    (
    id_afp NUMBER (5) GENERATED ALWAYS AS IDENTITY
    START WITH 210
    INCREMENT BY 6 NOT NULL, 
    nom_afp VARCHAR2 (255)NOT NULL,
    CONSTRAINT PK_AFP PRIMARY KEY (id_afp)
);

CREATE TABLE SALUD
    (
    id_salud NUMBER (4) NOT NULL, 
    nom_salud VARCHAR2 (40) NOT NULL,
    CONSTRAINT PK_SALUD PRIMARY KEY (id_salud)
);

CREATE TABLE MEDIO_PAGO
    (
    id_mpago NUMBER (3) NOT NULL,
    nombre_mpago VARCHAR2 (50) NOT NULL,
    CONSTRAINT PK_MEDIO_PAGO PRIMARY KEY (id_mpago)
);

CREATE TABLE EMPLEADO
    (
    id_empleado NUMBER (4) NOT NULL,
    rut_empleado VARCHAR2 (10) NOT NULL, 
    nombre_empleado VARCHAR2 (25) NOT NULL,
    apellido_paterno VARCHAR2 (25) NOT NULL,
    apellido_materno VARCHAR2 (25) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    sueldo_base NUMBER (10) NOT NULL,
    bono_jefatura NUMBER (10),
    activo CHAR (1) NOT NULL,
    tipo_empleado VARCHAR2 (25) NOT NULL,
    cod_empleado NUMBER (4),
    cod_salud NUMBER (4) NOT NULL,
    cod_afp NUMBER (5) NOT NULL,
    
    CONSTRAINT PK_EMPLEADO PRIMARY KEY (id_empleado),
    CONSTRAINT FK_SALUD 
        FOREIGN KEY (cod_salud) REFERENCES SALUD (id_salud),
    CONSTRAINT FK_AFP 
        FOREIGN KEY (cod_afp) REFERENCES AFP (id_afp),
    CONSTRAINT FK_EMPLEADO_EMPLEADO
        FOREIGN KEY (cod_empleado) REFERENCES EMPLEADO (id_empleado)    
);


CREATE TABLE ADMINISTRATIVO
    (
    id_empleado NUMBER (4) NOT NULL,
    CONSTRAINT PK_ADMINISTRATIVO PRIMARY KEY (id_empleado), 
    CONSTRAINT FK_EMPLEADO_ADMIN
        FOREIGN KEY (id_empleado) REFERENCES EMPLEADO (id_empleado)
);

CREATE TABLE VENDEDOR
    (
    id_empleado NUMBER (4) NOT NULL,
    comision_venta NUMBER (5,2) NOT NULL,
    CONSTRAINT PK_VENDEDOR PRIMARY KEY (id_empleado),
    CONSTRAINT FK_EMPLEADO_VENDEDOR
        FOREIGN KEY (id_empleado) REFERENCES EMPLEADO (id_empleado)
);

CREATE TABLE PROVEEDOR
    (
    id_proveedor NUMBER (5) NOT NULL,
    nombre_proveedor VARCHAR2 (150) NOT NULL,
    rut_proveedor VARCHAR2 (10) NOT NULL,
    telefono VARCHAR2 (10) NOT NULL,
    email VARCHAR2 (200) NOT NULL,
    direccion VARCHAR2 (200) NOT NULL,
    cod_comuna NUMBER (4) NOT NULL,
    CONSTRAINT PK_PROVEEDOR PRIMARY KEY (id_proveedor),
    CONSTRAINT FK_COMUNA
        FOREIGN KEY (cod_comuna) REFERENCES COMUNA (id_comuna)    
);

CREATE TABLE MARCA
    (
    id_marca NUMBER (3) NOT NULL,
    nombre_marca VARCHAR2 (25) NOT NULL,
    CONSTRAINT PK_MARCA PRIMARY KEY (id_marca)    
);

CREATE TABLE CATEGORIA
    (
    id_categoria NUMBER (3) NOT NULL,
    nombre_categoria VARCHAR2 (225) NOT NULL,
    CONSTRAINT PK_CATEGORIA PRIMARY KEY (id_categoria)   
);

CREATE TABLE PRODUCTO
    (
    id_producto NUMBER (4) NOT NULL,
    nombre_producto VARCHAR2 (100) NOT NULL,
    precio_unitario NUMBER NOT NULL,
    origen_nacional CHAR (1) NOT NULL,
    stock_minimo NUMBER (3) NOT NULL,
    activo CHAR (1) NOT NULL,
    cod_marca NUMBER (3) NOT NULL,
    cod_categoria NUMBER (3) NOT NULL,
    cod_proveedor NUMBER (5) NOT NULL,
    
    CONSTRAINT PK_PRODUCTO PRIMARY KEY (id_producto),
    CONSTRAINT FK_MARCA
        FOREIGN KEY (cod_marca) REFERENCES MARCA (id_marca),
    CONSTRAINT FK_CATEGORIA
        FOREIGN KEY (cod_categoria) REFERENCES CATEGORIA (id_categoria),
    CONSTRAINT FK_PROVEEDOR
        FOREIGN KEY (cod_proveedor) REFERENCES PROVEEDOR (id_proveedor)
);

CREATE TABLE VENTA
    (
    id_venta NUMBER (4) GENERATED ALWAYS AS IDENTITY
    START WITH 5050
    INCREMENT BY 3 NOT NULL,
    fecha_venta DATE NOT NULL,
    total_venta NUMBER (10) NOT NULL,
    cod_mpago NUMBER (3) NOT NULL,
    cod_empleado NUMBER (4) NOT NULL,
    
    CONSTRAINT PK_VENTA PRIMARY KEY (id_venta),
    CONSTRAINT FK_MEDIO_PAGO
        FOREIGN KEY (cod_mpago) REFERENCES MEDIO_PAGO (id_mpago),
    CONSTRAINT FK_EMPLEADO
        FOREIGN KEY (cod_empleado) REFERENCES EMPLEADO (id_empleado)    
);

CREATE TABLE DETALLE_VENTA
    (
    cod_venta NUMBER (4) NOT NULL,
    cod_producto NUMBER (4) NOT NULL,
    cantidad NUMBER (6) NOT NULL,
    
    CONSTRAINT PK_DETALLE_VENTA PRIMARY KEY (cod_venta, cod_producto),
    CONSTRAINT FK_VENTA
        FOREIGN KEY (cod_venta) REFERENCES VENTA (id_venta),
    CONSTRAINT FK_PRODUCTO
        FOREIGN KEY (cod_producto) REFERENCES PRODUCTO (id_producto)
);


/* ------------------------------------------
   CASO 2: MODIFICACION DE MODELO
   ------------------------------------------ */
   
ALTER TABLE EMPLEADO
ADD CONSTRAINT CK_EMPLEADO_sueldo_base 
    CHECK (sueldo_base >= 400000);
   
ALTER TABLE VENDEDOR
ADD CONSTRAINT CK_VENDEDOR_comision_venta 
    CHECK (comision_venta >= 0 AND comision_venta <= 0.25);
    
ALTER TABLE PRODUCTO
ADD CONSTRAINT CK_PRODUCTO_stock_minimo
    CHECK (stock_minimo >= 3); 
    
ALTER TABLE PROVEEDOR
ADD CONSTRAINT UN_PROVEEDOR_email UNIQUE (email);

ALTER TABLE MARCA
ADD CONSTRAINT UN_MARCA_nombre UNIQUE (nombre_marca);

ALTER  TABLE DETALLE_VENTA
ADD CONSTRAINT CK_DETALLE_VENTA_cantidad
    CHECK (cantidad >0); 

/* ------------------------------------------
   CASO 3: POBLAMIENTO DEL MODELO
   ------------------------------------------ */    

CREATE SEQUENCE SQC_SALUD
START WITH 2050
INCREMENT BY 10; 

CREATE SEQUENCE SQC_EMPLEADO
START WITH 750
INCREMENT BY 3; 

/* REGION  */

INSERT INTO REGION (id_region, nom_region ) VALUES (1, 'Región Metropolitana');
INSERT INTO REGION ( id_region, nom_region ) VALUES (2, 'Valparaíso'); 
INSERT INTO REGION ( id_region, nom_region ) VALUES (3, 'Biobío'); 
INSERT INTO REGION ( id_region, nom_region ) VALUES (4, 'Los Lagos'); 

/* COMUNA  */

-- Región Metropolitana
INSERT INTO COMUNA (id_comuna, nom_comuna, id_region) VALUES (1001, 'Santiago', 1);
INSERT INTO COMUNA (id_comuna, nom_comuna, id_region) VALUES (1002, 'Puente Alto', 1);

-- Región de Valparaíso
INSERT INTO COMUNA (id_comuna, nom_comuna, id_region) VALUES (2001, 'Valparaíso', 2);
INSERT INTO COMUNA (id_comuna, nom_comuna, id_region) VALUES (2002, 'Viña del Mar', 2);

-- Región del Biobío
INSERT INTO COMUNA (id_comuna, nom_comuna, id_region) VALUES (3001, 'Concepción', 3);
INSERT INTO COMUNA (id_comuna, nom_comuna, id_region) VALUES (3002, 'Los Ángeles', 3);

-- Región de Los Lagos
INSERT INTO COMUNA (id_comuna, nom_comuna, id_region) VALUES (4001, 'Puerto Montt', 4);
INSERT INTO COMUNA (id_comuna, nom_comuna, id_region) VALUES (4002, 'Castro', 4);

/* AFP  */

INSERT INTO AFP (nom_afp) VALUES ('AFP Habitat');
INSERT INTO AFP (nom_afp) VALUES ('AFP Cuprum');
INSERT INTO AFP (nom_afp) VALUES ('AFP Provida');
INSERT INTO AFP (nom_afp) VALUES ('AFP PlanVital');

/* SALUD  */

INSERT INTO SALUD (id_salud, nom_salud) VALUES (SQC_SALUD.NEXTVAL, 'Fonasa');
INSERT INTO SALUD (id_salud, nom_salud) VALUES (SQC_SALUD.NEXTVAL,'Isapre Colmena');
INSERT INTO SALUD (id_salud, nom_salud) VALUES (SQC_SALUD.NEXTVAL,'Isapre Banmédica');
INSERT INTO SALUD (id_salud, nom_salud) VALUES (SQC_SALUD.NEXTVAL,'Isapre Cruz Blanca');

/* MEDIO PAGO  */

INSERT INTO MEDIO_PAGO (id_mpago, nombre_mpago) VALUES (11, 'Efectivo');
INSERT INTO MEDIO_PAGO (id_mpago, nombre_mpago) VALUES (12, 'Tarjeta Débito');
INSERT INTO MEDIO_PAGO (id_mpago, nombre_mpago) VALUES (13, 'Tarjeta Crédito');
INSERT INTO MEDIO_PAGO (id_mpago, nombre_mpago) VALUES (14, 'Cheque');

/* PROVEEDOR  */

INSERT INTO PROVEEDOR 
(id_proveedor, nombre_proveedor, rut_proveedor, telefono, email, direccion, cod_comuna)
VALUES 
(1, 'Distribuidora Central Ltda.', '76985432-1', '229876543', 
 'contacto@distribcentral.cl', 'Av. Libertador Bernardo O’Higgins 1234', 1001);

INSERT INTO PROVEEDOR 
(id_proveedor, nombre_proveedor, rut_proveedor, telefono, email, direccion, cod_comuna)
VALUES 
(2, 'Alimentos del Sur S.A.', '96587412-3', '412345678', 
 'ventas@alimentossur.cl', 'Calle Colo Colo 456, Concepción', 3001);
 
/* MARCA  */ 

INSERT INTO MARCA (id_marca, nombre_marca) VALUES (101, 'Bosch');
INSERT INTO MARCA (id_marca, nombre_marca) VALUES (102, 'DeWalt');
INSERT INTO MARCA (id_marca, nombre_marca) VALUES (103, 'Stanley');
INSERT INTO MARCA (id_marca, nombre_marca) VALUES (104, 'Makita');
INSERT INTO MARCA (id_marca, nombre_marca) VALUES (105, 'Truper');
INSERT INTO MARCA (id_marca, nombre_marca) VALUES (106, 'Hilti');

/* CATEGORIA_PRODUCTO  */

INSERT INTO CATEGORIA (id_categoria, nombre_categoria) VALUES (101, 'Herramientas Eléctricas');
INSERT INTO CATEGORIA (id_categoria, nombre_categoria) VALUES (201, 'Herramientas Manuales');
INSERT INTO CATEGORIA (id_categoria, nombre_categoria) VALUES (301, 'Equipos de Corte y Abrasivos');
INSERT INTO CATEGORIA (id_categoria, nombre_categoria) VALUES (401, 'Fijaciones y Perforación');
INSERT INTO CATEGORIA (id_categoria, nombre_categoria) VALUES (501, 'Decoración');
INSERT INTO CATEGORIA (id_categoria, nombre_categoria) VALUES (601, 'Patio y Piscina');
 
/* EMPLEADO  */

-- EMPLEADO 1
INSERT INTO EMPLEADO (
    id_empleado, 
    rut_empleado, 
    nombre_empleado, 
    apellido_paterno, 
    apellido_materno,
    fecha_contratacion,
    sueldo_base,
    bono_jefatura,
    activo,
    tipo_empleado,
    cod_empleado,
    cod_salud,
    cod_afp
) 
VALUES (
    SQC_EMPLEADO.NEXTVAL, 
    '11111111-1', 
    'Marcela', 
    'González',
    'Pérez', 
    '13-03-2022', 
    950000, 
    80000, 
    'S', 
    'Administrativo',
    NULL,
    2050,
    210); 

-- EMPLEADO 2
INSERT INTO EMPLEADO (
    id_empleado, 
    rut_empleado, 
    nombre_empleado, 
    apellido_paterno, 
    apellido_materno,
    fecha_contratacion,
    sueldo_base,
    bono_jefatura,
    activo,
    tipo_empleado,
    cod_empleado,
    cod_salud,
    cod_afp
) 
VALUES (
    SQC_EMPLEADO.NEXTVAL, 
    '22222222-2', 
    'José', 
    'Muñoz',
    'Ramirez', 
    '10-07-2021', 
    900000, 
    75000, 
    'S', 
    'Administrativo',
    NULL,
    2060,
    216); 

-- EMPLEADO 3
INSERT INTO EMPLEADO (
    id_empleado, 
    rut_empleado, 
    nombre_empleado, 
    apellido_paterno, 
    apellido_materno,
    fecha_contratacion,
    sueldo_base,
    bono_jefatura,
    activo,
    tipo_empleado,
    cod_empleado,
    cod_salud,
    cod_afp
) 
VALUES (
    SQC_EMPLEADO.NEXTVAL, 
    '33333333-3', 
    'Verónica', 
    'Soto',
    'Alarcón', 
    '05-01-2020', 
    880000, 
    70000, 
    'S', 
    'Vendedor',
    750,
    2060,
    228); 

-- EMPLEADO 4
INSERT INTO EMPLEADO (
    id_empleado, 
    rut_empleado, 
    nombre_empleado, 
    apellido_paterno, 
    apellido_materno,
    fecha_contratacion,
    sueldo_base,
    bono_jefatura,
    activo,
    tipo_empleado,
    cod_empleado,
    cod_salud,
    cod_afp
) 
VALUES (
    SQC_EMPLEADO.NEXTVAL, 
    '44444444-4', 
    'Luis', 
    'Reyes',
    'Fuentes', 
    '01-04-2023', 
    560000, 
    NULL, 
    'S', 
    'Vendedor',
    750,
    2070,
    228);

-- EMPLEADO 5
INSERT INTO EMPLEADO (
    id_empleado, 
    rut_empleado, 
    nombre_empleado, 
    apellido_paterno, 
    apellido_materno,
    fecha_contratacion,
    sueldo_base,
    bono_jefatura,
    activo,
    tipo_empleado,
    cod_empleado,
    cod_salud,
    cod_afp
) 
VALUES (
    SQC_EMPLEADO.NEXTVAL, 
    '55555555-5', 
    'Claudia', 
    'Fernández',
    'Lagos', 
    '15-04-2023', 
    600000, 
    NULL, 
    'S', 
    'Vendedor',
    753,
    2070,
    216);

-- EMPLEADO 6
INSERT INTO EMPLEADO (
    id_empleado, 
    rut_empleado, 
    nombre_empleado, 
    apellido_paterno, 
    apellido_materno,
    fecha_contratacion,
    sueldo_base,
    bono_jefatura,
    activo,
    tipo_empleado,
    cod_empleado,
    cod_salud,
    cod_afp
) 
VALUES (
    SQC_EMPLEADO.NEXTVAL, 
    '66666666-6', 
    'Carlos', 
    'Navarro',
    'Vega', 
    '01-05-2023', 
    610000, 
    NULL, 
    'S', 
    'Administrativo',
    753,
    2060,
    210);

-- EMPLEADO 7
INSERT INTO EMPLEADO (
    id_empleado, 
    rut_empleado, 
    nombre_empleado, 
    apellido_paterno, 
    apellido_materno,
    fecha_contratacion,
    sueldo_base,
    bono_jefatura,
    activo,
    tipo_empleado,
    cod_empleado,
    cod_salud,
    cod_afp
) 
VALUES (
    SQC_EMPLEADO.NEXTVAL, 
    '77777777-7', 
    'Javiero', 
    'Pino',
    'Rojas', 
    '10-05-2023', 
    650000, 
    NULL, 
    'S', 
    'Administrativo',
    750,
    2050,
    210);
    
-- EMPLEADO 8
INSERT INTO EMPLEADO (
    id_empleado, 
    rut_empleado, 
    nombre_empleado, 
    apellido_paterno, 
    apellido_materno,
    fecha_contratacion,
    sueldo_base,
    bono_jefatura,
    activo,
    tipo_empleado,
    cod_empleado,
    cod_salud,
    cod_afp
) 
VALUES (
    SQC_EMPLEADO.NEXTVAL, 
    '88888888-8', 
    'Diego', 
    'Mella',
    'Contreras', 
    '12-05-2023', 
    620000, 
    NULL, 
    'S', 
    'Vendedor',
    750,
    2060,
    216);    

-- EMPLEADO 9
INSERT INTO EMPLEADO (
    id_empleado, 
    rut_empleado, 
    nombre_empleado, 
    apellido_paterno, 
    apellido_materno,
    fecha_contratacion,
    sueldo_base,
    bono_jefatura,
    activo,
    tipo_empleado,
    cod_empleado,
    cod_salud,
    cod_afp
) 
VALUES (
    SQC_EMPLEADO.NEXTVAL, 
    '99999999-9', 
    'Fernanda', 
    'Salas',
    'Herrera', 
    '18-05-2023', 
    570000, 
    NULL, 
    'S', 
    'Vendedor',
    753,
    2070,
    228);
    
-- EMPLEADO 10
INSERT INTO EMPLEADO (
    id_empleado, 
    rut_empleado, 
    nombre_empleado, 
    apellido_paterno, 
    apellido_materno,
    fecha_contratacion,
    sueldo_base,
    bono_jefatura,
    activo,
    tipo_empleado,
    cod_empleado,
    cod_salud,
    cod_afp
) 
VALUES (
    SQC_EMPLEADO.NEXTVAL, 
    '10101010-0', 
    'Tomás', 
    'Vidal',
    'Espinoza', 
    '01-06-2023', 
    530000, 
    NULL, 
    'S', 
    'Vendedor',
    NULL,
    2050,
    222);    

/* PRODUCTO  */

--PRODUCTO 1
INSERT INTO PRODUCTO (
    id_producto,
    nombre_producto,
    precio_unitario,
    origen_nacional,
    stock_minimo,
    activo,
    cod_marca,
    cod_categoria,
    cod_proveedor
) VALUES
(1001, 'Martillo de acero 16oz', 7500, 'S', 3, 'S', 105, 201, 1);

--PRODUCTO 2
INSERT INTO PRODUCTO (
    id_producto,
    nombre_producto,
    precio_unitario,
    origen_nacional,
    stock_minimo,
    activo,
    cod_marca,
    cod_categoria,
    cod_proveedor
) VALUES
(1002, 'Taladro eléctrico 500W', 75000, 'S', 3, 'S', 101, 101, 2);

--PRODUCTO 3
INSERT INTO PRODUCTO (
    id_producto,
    nombre_producto,
    precio_unitario,
    origen_nacional,
    stock_minimo,
    activo,
    cod_marca,
    cod_categoria,
    cod_proveedor
) VALUES
(1003, 'Compresor de aire 100L profesional', 466990, 'S', 3, 'S', 102, 101, 1);

--PRODUCTO 4
INSERT INTO PRODUCTO (
    id_producto,
    nombre_producto,
    precio_unitario,
    origen_nacional,
    stock_minimo,
    activo,
    cod_marca,
    cod_categoria,
    cod_proveedor
) VALUES
(1004, 'Soldadora MIG 220A profesional', 524990, 'S', 3, 'S', 104, 101, 2);

--PRODUCTO 5
INSERT INTO PRODUCTO (
    id_producto,
    nombre_producto,
    precio_unitario,
    origen_nacional,
    stock_minimo,
    activo,
    cod_marca,
    cod_categoria,
    cod_proveedor
) VALUES
(1005, 'Taladro percutor industrial 900W', 225990, 'S', 3, 'S', 104, 101, 2);

/* VENTA  */

--VENTA 1
INSERT INTO VENTA (
    fecha_venta,
    total_venta,
    cod_mpago,
    cod_empleado
) VALUES
('12-05-2023',225990, 12, 771); 

--VENTA 2
INSERT INTO VENTA (
    fecha_venta,
    total_venta,
    cod_mpago,
    cod_empleado
) VALUES
('23-10-2023',524990, 13, 777);

--VENTA 3
INSERT INTO VENTA (
    fecha_venta,
    total_venta,
    cod_mpago,
    cod_empleado
) VALUES
('17-02-2023',466990, 11, 759);

/* DETALLE_VENTA  */

--DETALLE_VENTA 1
INSERT INTO DETALLE_VENTA (
    cod_venta,
    cod_producto,
    cantidad
) VALUES
(5050,1005, 1);

--DETALLE_VENTA 2
INSERT INTO DETALLE_VENTA (
    cod_venta,
    cod_producto,
    cantidad
) VALUES
(5053,1004, 1);

/* ------------------------------------------
   CASO 4: RECUPERACION DE DATOS
   ------------------------------------------ */
   
--INFORME 1   
   
SELECT 
    id_empleado AS identificador,
    nombre_empleado || ' ' || apellido_paterno || ' ' || apellido_materno AS "NOMBRE COMPLETO",
    sueldo_base AS salario, 
    bono_jefatura AS bonificacion,
    sueldo_base + bono_jefatura AS "SALARIO SIMULADO" 
FROM EMPLEADO
WHERE bono_jefatura IS NOT NULL AND activo = 'S'
ORDER BY "SALARIO SIMULADO" DESC, apellido_paterno; 


--INFORME 2

SELECT 
    nombre_empleado || ' ' || apellido_paterno || ' ' || apellido_materno AS "NOMBRE COMPLETO",
    sueldo_base AS sueldo, 
    sueldo_base * 0.08 AS "POSIBLE AUMENTO",
    sueldo_base + (sueldo_base * 0.08) AS "SUELDO SIMULADO" 
FROM EMPLEADO
WHERE sueldo_base BETWEEN 550000 AND 800000
ORDER BY sueldo_base ASC; 























