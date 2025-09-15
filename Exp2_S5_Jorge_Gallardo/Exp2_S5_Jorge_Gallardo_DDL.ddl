-- Generado por Oracle SQL Developer Data Modeler 24.3.1.351.0831
--   en:        2025-09-11 15:24:22 CLST
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE AFP 
    ( 
     id_afp     NUMBER (3)  NOT NULL , 
     nombre_afp VARCHAR2 (30)  NOT NULL 
    ) 
;

ALTER TABLE AFP 
    ADD CONSTRAINT AFP_PK PRIMARY KEY ( id_afp ) ;

CREATE TABLE ATENCION 
    ( 
     folio                     NUMBER (5)  NOT NULL , 
     fecha                     DATE  NOT NULL , 
     monto                     NUMBER (8)  NOT NULL , 
     EMPLEADO_id_empleado      NUMBER (3)  NOT NULL , 
     PACIENTE_id_paciente      NUMBER (3)  NOT NULL , 
     PACIENTE_COMUNA_id_comuna NUMBER (3)  NOT NULL , 
     TIPO_PAGO_id_pago         NUMBER (3)  NOT NULL , 
     TIPO_ATENCION_id_atencion NUMBER (3)  NOT NULL , 
     FICHA_id_ficha            NUMBER (3)  NOT NULL , 
     hora                      DATE  NOT NULL , 
     EXAMEN_codigo_examen      NUMBER (5) 
    ) 
;

ALTER TABLE ATENCION 
    ADD CONSTRAINT CK_ATENCION_MONTO 
    CHECK (monto>0) 
;
CREATE UNIQUE INDEX ATENCION__IDX ON ATENCION 
    ( 
     TIPO_ATENCION_id_atencion ASC 
    ) 
;
CREATE UNIQUE INDEX ATENCION__IDXv1 ON ATENCION 
    ( 
     TIPO_PAGO_id_pago ASC 
    ) 
;

ALTER TABLE ATENCION 
    ADD CONSTRAINT PK_ATENCION PRIMARY KEY ( folio, FICHA_id_ficha ) ;

CREATE TABLE CENTRO_MEDICO 
    ( 
     id_centro        NUMBER (3)  NOT NULL , 
     nombre_centro    VARCHAR2 (30)  NOT NULL , 
     COMUNA_id_comuna NUMBER (3)  NOT NULL 
    ) 
;

ALTER TABLE CENTRO_MEDICO 
    ADD CONSTRAINT PK_CENTRO_MEDICO PRIMARY KEY ( id_centro ) ;

CREATE TABLE COMUNA 
    ( 
     id_comuna        NUMBER (3)  NOT NULL , 
     nombre           VARCHAR2 (30)  NOT NULL , 
     REGION_id_region NUMBER (3)  NOT NULL 
    ) 
;

ALTER TABLE COMUNA 
    ADD CONSTRAINT PK_COMUNA PRIMARY KEY ( id_comuna ) ;

ALTER TABLE COMUNA 
    ADD CONSTRAINT COMUNA_nombre_UN UNIQUE ( nombre ) ;

CREATE TABLE EMPLEADO 
    ( 
     id_empleado                    NUMBER (3)  NOT NULL , 
     rut_empleado                   NUMBER (8)  NOT NULL , 
     nombre_empleado                VARCHAR2 (50)  NOT NULL , 
     fecha_ingreso                  DATE  NOT NULL , 
     CENTRO_MEDICO_id_centro        NUMBER (3)  NOT NULL , 
     AFP_id_afp                     NUMBER (3)  NOT NULL , 
     SALUD_id_salud                 NUMBER (3)  NOT NULL , 
     TIPO_EMPLEADO_id_tipo_empleado NUMBER (3)  NOT NULL , 
     ESPECIALIDAD_id_especialidad   NUMBER (3)  NOT NULL , 
     EMPLEADO_id_empleado           NUMBER (3)  NOT NULL , 
     UNIDAD_id_unidad               NUMBER (3)  NOT NULL , 
     rut_d_empleado                 VARCHAR2 (1)  NOT NULL 
    ) 
;

ALTER TABLE EMPLEADO 
    ADD CONSTRAINT CK_EMPLEADO_RUT_D 
    CHECK (rut_d_empleado IN ('"0"', '"1"', '"2"', '"3"', '"4"', '"5"', '"6"', '"7"', '"8"', '"9"', '"K"', '"k"')) 
;

ALTER TABLE EMPLEADO 
    ADD CONSTRAINT PK_EMPLEADO PRIMARY KEY ( id_empleado ) ;

CREATE TABLE ESPECIALIDAD 
    ( 
     id_especialidad     NUMBER (3)  NOT NULL , 
     nombre_especialidad VARCHAR2 (30)  NOT NULL 
    ) 
;

ALTER TABLE ESPECIALIDAD 
    ADD CONSTRAINT PK_ESPECIALIDAD PRIMARY KEY ( id_especialidad ) ;

CREATE TABLE EXAMEN 
    ( 
     codigo_examen NUMBER (5)  NOT NULL , 
     nombre_examen VARCHAR2 (30)  NOT NULL , 
     tipo_muestra  VARCHAR2 (30)  NOT NULL , 
     preparacion   VARCHAR2 (50)  NOT NULL 
    ) 
;

ALTER TABLE EXAMEN 
    ADD CONSTRAINT PK_EXAMEN PRIMARY KEY ( codigo_examen ) ;

ALTER TABLE EXAMEN 
    ADD CONSTRAINT EXAMEN_nombre_examen_UN UNIQUE ( nombre_examen ) ;

CREATE TABLE FICHA 
    ( 
     id_ficha                  NUMBER (3)  NOT NULL , 
     PACIENTE_id_paciente      NUMBER (3)  NOT NULL , 
     PACIENTE_COMUNA_id_comuna NUMBER (3)  NOT NULL , 
     descripcion               VARCHAR2 (100) 
    ) 
;
CREATE UNIQUE INDEX FICHA_MEDICA__IDX ON FICHA 
    ( 
     PACIENTE_id_paciente ASC , 
     PACIENTE_COMUNA_id_comuna ASC 
    ) 
;

ALTER TABLE FICHA 
    ADD CONSTRAINT PK_FICHA_MEDICA PRIMARY KEY ( id_ficha ) ;

CREATE TABLE PACIENTE 
    ( 
     id_paciente             NUMBER (3)  NOT NULL , 
     rut_paciente            NUMBER (8)  NOT NULL , 
     nombre_paciente         VARCHAR2 (50)  NOT NULL , 
     fecha_nacimiento        DATE  NOT NULL , 
     sexo                    CHAR (1)  NOT NULL , 
     direccion               VARCHAR2 (70)  NOT NULL , 
     COMUNA_id_comuna        NUMBER (3)  NOT NULL , 
     FICHA_id_ficha          NUMBER (3)  NOT NULL , 
     CENTRO_MEDICO_id_centro NUMBER (3)  NOT NULL , 
     telefono                NUMBER (11)  NOT NULL , 
     TIPO_PACIENTEN_id_tipo  NUMBER  NOT NULL , 
     rut_d_paciente          VARCHAR2 (1)  NOT NULL 
    ) 
;

ALTER TABLE PACIENTE 
    ADD CONSTRAINT CK_PACIENTE_RU_D 
    CHECK (rut_d_paciente IN ('"0"', '"1"', '"2"', '"3"', '"4"', '"5"', '"6"', '"7"', '"8"', '"9"', '"K"', '"k"')) 
;
CREATE UNIQUE INDEX PACIENTE__IDX ON PACIENTE 
    ( 
     FICHA_id_ficha ASC 
    ) 
;
CREATE UNIQUE INDEX PACIENTE__IDXv1 ON PACIENTE 
    ( 
     TIPO_PACIENTEN_id_tipo ASC 
    ) 
;

ALTER TABLE PACIENTE 
    ADD CONSTRAINT PK_PACIENTE PRIMARY KEY ( id_paciente, COMUNA_id_comuna ) ;

CREATE TABLE REGION 
    ( 
     id_region NUMBER (3)  NOT NULL , 
     nombre    VARCHAR2 (30)  NOT NULL 
    ) 
;

ALTER TABLE REGION 
    ADD CONSTRAINT PK_REGION PRIMARY KEY ( id_region ) ;

ALTER TABLE REGION 
    ADD CONSTRAINT REGION_nombre_UN UNIQUE ( nombre ) ;

CREATE TABLE SALUD 
    ( 
     id_salud     NUMBER (3)  NOT NULL , 
     nombre_salud VARCHAR2 (30)  NOT NULL 
    ) 
;

ALTER TABLE SALUD 
    ADD CONSTRAINT SALUD_PK PRIMARY KEY ( id_salud ) ;

CREATE TABLE TIPO_ATENCION 
    ( 
     id_atencion             NUMBER (3)  NOT NULL , 
     nombre_atencion         VARCHAR2 (30)  NOT NULL , 
     ATENCION_folio          NUMBER (5)  NOT NULL , 
     ATENCION_FICHA_id_ficha NUMBER (3)  NOT NULL 
    ) 
;
CREATE UNIQUE INDEX TIPO_ATENCION__IDX ON TIPO_ATENCION 
    ( 
     ATENCION_folio ASC , 
     ATENCION_FICHA_id_ficha ASC 
    ) 
;

ALTER TABLE TIPO_ATENCION 
    ADD CONSTRAINT PK_TIPO_ATENCION PRIMARY KEY ( id_atencion ) ;

CREATE TABLE TIPO_EMPLEADO 
    ( 
     id_tipo_empleado NUMBER (3)  NOT NULL , 
     nombre_tipo      VARCHAR2 (30)  NOT NULL 
    ) 
;

ALTER TABLE TIPO_EMPLEADO 
    ADD CONSTRAINT TIPO_EMPLEADO_PK PRIMARY KEY ( id_tipo_empleado ) ;

CREATE TABLE TIPO_PACIENTEN 
    ( 
     id_tipo                   NUMBER  NOT NULL , 
     nombre_tipo               VARCHAR2 (20)  NOT NULL , 
     PACIENTE_id_paciente      NUMBER (3)  NOT NULL , 
     PACIENTE_COMUNA_id_comuna NUMBER (3)  NOT NULL 
    ) 
;
CREATE UNIQUE INDEX TIPO_PACIENTEN__IDX ON TIPO_PACIENTEN 
    ( 
     PACIENTE_id_paciente ASC , 
     PACIENTE_COMUNA_id_comuna ASC 
    ) 
;

ALTER TABLE TIPO_PACIENTEN 
    ADD CONSTRAINT PK_TIPO_PACIENTEN PRIMARY KEY ( id_tipo ) ;

CREATE TABLE TIPO_PAGO 
    ( 
     id_pago                 NUMBER (3)  NOT NULL , 
     nombre_tipo             VARCHAR2 (30)  NOT NULL , 
     ATENCION_folio          NUMBER (5)  NOT NULL , 
     ATENCION_FICHA_id_ficha NUMBER (3)  NOT NULL 
    ) 
;
CREATE UNIQUE INDEX TIPO_PAGO__IDX ON TIPO_PAGO 
    ( 
     ATENCION_folio ASC , 
     ATENCION_FICHA_id_ficha ASC 
    ) 
;

ALTER TABLE TIPO_PAGO 
    ADD CONSTRAINT PK_TIPO_PAGO PRIMARY KEY ( id_pago ) ;

CREATE TABLE UNIDAD 
    ( 
     id_unidad               NUMBER (3)  NOT NULL , 
     nombre_unidad           VARCHAR2 (20)  NOT NULL , 
     CENTRO_MEDICO_id_centro NUMBER (3)  NOT NULL 
    ) 
;

ALTER TABLE UNIDAD 
    ADD CONSTRAINT PK_UNIDAD PRIMARY KEY ( id_unidad ) ;

ALTER TABLE ATENCION 
    ADD CONSTRAINT ATENCION_EMPLEADO_FK FOREIGN KEY 
    ( 
     EMPLEADO_id_empleado
    ) 
    REFERENCES EMPLEADO 
    ( 
     id_empleado
    ) 
;

ALTER TABLE ATENCION 
    ADD CONSTRAINT ATENCION_EXAMEN_FK FOREIGN KEY 
    ( 
     EXAMEN_codigo_examen
    ) 
    REFERENCES EXAMEN 
    ( 
     codigo_examen
    ) 
;

ALTER TABLE ATENCION 
    ADD CONSTRAINT ATENCION_FICHA_FK FOREIGN KEY 
    ( 
     FICHA_id_ficha
    ) 
    REFERENCES FICHA 
    ( 
     id_ficha
    ) 
;

ALTER TABLE ATENCION 
    ADD CONSTRAINT ATENCION_PACIENTE_FK FOREIGN KEY 
    ( 
     PACIENTE_id_paciente,
     PACIENTE_COMUNA_id_comuna
    ) 
    REFERENCES PACIENTE 
    ( 
     id_paciente,
     COMUNA_id_comuna
    ) 
;

ALTER TABLE ATENCION 
    ADD CONSTRAINT ATENCION_TIPO_ATENCION_FK FOREIGN KEY 
    ( 
     TIPO_ATENCION_id_atencion
    ) 
    REFERENCES TIPO_ATENCION 
    ( 
     id_atencion
    ) 
;

ALTER TABLE ATENCION 
    ADD CONSTRAINT ATENCION_TIPO_PAGO_FK FOREIGN KEY 
    ( 
     TIPO_PAGO_id_pago
    ) 
    REFERENCES TIPO_PAGO 
    ( 
     id_pago
    ) 
;

ALTER TABLE CENTRO_MEDICO 
    ADD CONSTRAINT CENTRO_MEDICO_COMUNA_FK FOREIGN KEY 
    ( 
     COMUNA_id_comuna
    ) 
    REFERENCES COMUNA 
    ( 
     id_comuna
    ) 
;

ALTER TABLE COMUNA 
    ADD CONSTRAINT COMUNA_REGION_FK FOREIGN KEY 
    ( 
     REGION_id_region
    ) 
    REFERENCES REGION 
    ( 
     id_region
    ) 
;

ALTER TABLE EMPLEADO 
    ADD CONSTRAINT EMPLEADO_AFP_FK FOREIGN KEY 
    ( 
     AFP_id_afp
    ) 
    REFERENCES AFP 
    ( 
     id_afp
    ) 
;

ALTER TABLE EMPLEADO 
    ADD CONSTRAINT EMPLEADO_CENTRO_MEDICO_FK FOREIGN KEY 
    ( 
     CENTRO_MEDICO_id_centro
    ) 
    REFERENCES CENTRO_MEDICO 
    ( 
     id_centro
    ) 
;

ALTER TABLE EMPLEADO 
    ADD CONSTRAINT EMPLEADO_EMPLEADO_FK FOREIGN KEY 
    ( 
     EMPLEADO_id_empleado
    ) 
    REFERENCES EMPLEADO 
    ( 
     id_empleado
    ) 
;

ALTER TABLE EMPLEADO 
    ADD CONSTRAINT EMPLEADO_ESPECIALIDAD_FK FOREIGN KEY 
    ( 
     ESPECIALIDAD_id_especialidad
    ) 
    REFERENCES ESPECIALIDAD 
    ( 
     id_especialidad
    ) 
;

ALTER TABLE EMPLEADO 
    ADD CONSTRAINT EMPLEADO_SALUD_FK FOREIGN KEY 
    ( 
     SALUD_id_salud
    ) 
    REFERENCES SALUD 
    ( 
     id_salud
    ) 
;

ALTER TABLE EMPLEADO 
    ADD CONSTRAINT EMPLEADO_TIPO_EMPLEADO_FK FOREIGN KEY 
    ( 
     TIPO_EMPLEADO_id_tipo_empleado
    ) 
    REFERENCES TIPO_EMPLEADO 
    ( 
     id_tipo_empleado
    ) 
;

ALTER TABLE EMPLEADO 
    ADD CONSTRAINT EMPLEADO_UNIDAD_FK FOREIGN KEY 
    ( 
     UNIDAD_id_unidad
    ) 
    REFERENCES UNIDAD 
    ( 
     id_unidad
    ) 
;

ALTER TABLE FICHA 
    ADD CONSTRAINT FICHA_PACIENTE_FK FOREIGN KEY 
    ( 
     PACIENTE_id_paciente,
     PACIENTE_COMUNA_id_comuna
    ) 
    REFERENCES PACIENTE 
    ( 
     id_paciente,
     COMUNA_id_comuna
    ) 
;

ALTER TABLE PACIENTE 
    ADD CONSTRAINT PACIENTE_CENTRO_MEDICO_FK FOREIGN KEY 
    ( 
     CENTRO_MEDICO_id_centro
    ) 
    REFERENCES CENTRO_MEDICO 
    ( 
     id_centro
    ) 
;

ALTER TABLE PACIENTE 
    ADD CONSTRAINT PACIENTE_COMUNA_FK FOREIGN KEY 
    ( 
     COMUNA_id_comuna
    ) 
    REFERENCES COMUNA 
    ( 
     id_comuna
    ) 
;

ALTER TABLE PACIENTE 
    ADD CONSTRAINT PACIENTE_FICHA_FK FOREIGN KEY 
    ( 
     FICHA_id_ficha
    ) 
    REFERENCES FICHA 
    ( 
     id_ficha
    ) 
;

ALTER TABLE PACIENTE 
    ADD CONSTRAINT PACIENTE_TIPO_PACIENTEN_FK FOREIGN KEY 
    ( 
     TIPO_PACIENTEN_id_tipo
    ) 
    REFERENCES TIPO_PACIENTEN 
    ( 
     id_tipo
    ) 
;

ALTER TABLE TIPO_ATENCION 
    ADD CONSTRAINT TIPO_ATENCION_ATENCION_FK FOREIGN KEY 
    ( 
     ATENCION_folio,
     ATENCION_FICHA_id_ficha
    ) 
    REFERENCES ATENCION 
    ( 
     folio,
     FICHA_id_ficha
    ) 
;

ALTER TABLE TIPO_PACIENTEN 
    ADD CONSTRAINT TIPO_PACIENTEN_PACIENTE_FK FOREIGN KEY 
    ( 
     PACIENTE_id_paciente,
     PACIENTE_COMUNA_id_comuna
    ) 
    REFERENCES PACIENTE 
    ( 
     id_paciente,
     COMUNA_id_comuna
    ) 
;

ALTER TABLE TIPO_PAGO 
    ADD CONSTRAINT TIPO_PAGO_ATENCION_FK FOREIGN KEY 
    ( 
     ATENCION_folio,
     ATENCION_FICHA_id_ficha
    ) 
    REFERENCES ATENCION 
    ( 
     folio,
     FICHA_id_ficha
    ) 
;

ALTER TABLE UNIDAD 
    ADD CONSTRAINT UNIDAD_CENTRO_MEDICO_FK FOREIGN KEY 
    ( 
     CENTRO_MEDICO_id_centro
    ) 
    REFERENCES CENTRO_MEDICO 
    ( 
     id_centro
    ) 
;



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            16
-- CREATE INDEX                             8
-- ALTER TABLE                             46
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
