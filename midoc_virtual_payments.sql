/**/
create table license (
  id                        SERIAL NOT NULL,
  code                      INTEGER ,
  start_date                date,
  final_date                date,
  access_number             INTEGER ,
  created_date              TIMESTAMP(3) without TIME ZONE DEFAULT NULL,
  created_by				        text,
  last_modified_date        TIMESTAMP(3) without TIME ZONE DEFAULT NULL,
  last_modified_by		      text,
  CONSTRAINT pk_license PRIMARY KEY (id)
);


/**/
CREATE TABLE enterprise (
  id                        SERIAL NOT NULL,
  parent_id                 INTEGER ,
  license_id                INTEGER ,
  enterprise_level          INTEGER ,
  picture_url_enterprise    text,
  ruc                       VARCHAR(11),
  business_name             VARCHAR(255),  -- ej, ADMINISTRADORA CLINICA RICARDO PALMA S.A.
  web_page                  VARCHAR(100),  -- ej, http://www.crp.com.pe
  trade_name                VARCHAR(100),  -- ej, Clinica Ricardo Palma Sa
  comercial_activity        VARCHAR(50),   -- Actividades de Hospitales
  postal_address            VARCHAR(255),
  contact_name              VARCHAR(255),
  contact_phone             VARCHAR(30),
  midoc_user                VARCHAR (100),
  password                  VARCHAR (100),
  created_date              timestamp(3) without time zone DEFAULT NULL,
  created_by				        text,
  last_modified_date        timestamp(3) without time zone DEFAULT NULL,
  last_modified_by		      text,
  CONSTRAINT pk_enterprise PRIMARY KEY (id),
  CONSTRAINT fk_enterprise FOREIGN KEY (parent_id) REFERENCES enterprise(id),
  CONSTRAINT fk_license_id FOREIGN KEY (license_id) REFERENCES license(id)
);


/**/
create table location (
  id                        SERIAL NOT NULL ,
  enterprise_id             INTEGER ,
  name                      VARCHAR (100),
  description               text,
  picture_url               text,
  is_enabled                boolean,
  postal_address            text,
  created_date              timestamp(3) without time zone DEFAULT NULL,
  created_by				        text,
  last_modified_date        timestamp(3) without time zone DEFAULT NULL,
  last_modified_by		      text,
  CONSTRAINT pk_location PRIMARY KEY (id),
  CONSTRAINT fk_enterprise_id FOREIGN KEY (enterprise_id) REFERENCES enterprise(id)
);


/**/
create table emergency_attention (
  id                        SERIAL NOT NULL ,
  attention_type_id         VARCHAR (80),        -- Nutricion, Psicologia.
  attention_name            VARCHAR (80),        -- specialty name to show
  description               VARCHAR (255),
  picture_url               text,
  is_enabled                boolean,
  is_emergency              boolean,
  created_date              timestamp(3) without time zone DEFAULT NULL,
  created_by				        text,
  last_modified_date        timestamp(3) without time zone DEFAULT NULL,
  last_modified_by		      text,
  CONSTRAINT pk_emergency_attention PRIMARY KEY (id)
);


/**/
create table location_emergency_attention (
  id                        SERIAL NOT NULL ,
  location_id               INTEGER NOT NULL ,
  emergency_attention_id    INTEGER NOT NULL ,
  created_date              timestamp(3) without time zone DEFAULT NULL,
  created_by				        text,
  last_modified_date        timestamp(3) without time zone DEFAULT NULL,
  last_modified_by		      text,
  --CONSTRAINT pk_location_emergency_attention PRIMARY KEY (location_id, emergency_attention_id),
  CONSTRAINT pk_location_emergency_attention PRIMARY KEY (id),
  CONSTRAINT fk_location_emergency_attention01 FOREIGN KEY (location_id) REFERENCES location(id),
  CONSTRAINT fk_location_emergency_attention02 FOREIGN KEY (emergency_attention_id) REFERENCES emergency_attention(id)

);


/**/
create table doctor(
  id                        serial not null,
  emergency_attention_id    INTEGER ,
  location_id               INTEGER ,
  cmd_peru                  VARCHAR (20),     -- colegio de ingenieros del Perú
  degree                    varchar(100),     -- academic degree
  doctor_name               varchar(100),
  year_of_birth             date,
  picture_url               text ,
  email                     varchar(100),
  midoc_user                VARCHAR (100),
  password                  VARCHAR (100),
  type_of_specialist        VARCHAR (100),    -- emergenciólogo and especialista
  is_enabled                boolean,            -- enabled in the system
  call_activate             VARCHAR(1),         -- A: activo, I: inactivo, O:ocupado
  in_call                   boolean ,
  queue_count               INTEGER ,
  created_date              timestamp(3) without time zone DEFAULT NULL,
  created_by				        text,
  last_modified_date        timestamp(3) without time zone DEFAULT NULL,
  last_modified_by		      text,
  CONSTRAINT pk_doctor primary key (id) ,
  CONSTRAINT fk_emergency_attention_id FOREIGN KEY (emergency_attention_id) REFERENCES emergency_attention(id)
);
https://stackoverflow.com/questions/15988084/django-and-bidirectional-relationship-between-model

/**/
create table patient(
  id                        serial not null,
  location_id               INTEGER ,
  name                      varchar(100),
  year_of_birth             date,
  email                     varchar(100),
  midoc_user                varchar(100),
  password                  varchar(100),
  dni                       varchar(20),
  picture_url               text,
  blood_type                text,
  allergic_reaction         text,
  token_sinch               VARCHAR (100),
  size                      CHARACTER VARYING (100),
  contact_phone             VARCHAR (20),
  gender                    CHARACTER (1),
  is_enterprise_enabled     boolean,                  -- if has enterprise plan
  background                text,
  count_calling             INTEGER ,
  created_date              timestamp(3) without time zone DEFAULT NULL,
  created_by				        text,
  last_modified_date        timestamp(3) without time zone DEFAULT NULL,
  last_modified_by		      text,
  constraint pk_patient primary key (id),
  CONSTRAINT fk_patient_location_id FOREIGN KEY (location_id) REFERENCES location(id)
);


/**/

create table appointment(
  id                        serial not null,
  patient_id                INTEGER ,
  doctor_id                 INTEGER ,
  appointment_time          timestamp(3) without time zone DEFAULT NULL,
  appointment_status        VARCHAR (20),
  created_date              timestamp(3) without time zone DEFAULT NULL,
  created_by				        text,
  last_modified_date        timestamp(3) without time zone DEFAULT NULL,
  last_modified_by		      text,
  CONSTRAINT pk_appointment PRIMARY KEY (id),
  CONSTRAINT fk_appointment_patient FOREIGN KEY (patient_id) REFERENCES patient(id),
  CONSTRAINT fk_appointment_doctor FOREIGN KEY (doctor_id) REFERENCES doctor(id)
);



/**/
create table  medical_history(
  id                        serial not null,
  patient_id                INTEGER,
  doctor_id                 INTEGER,
  emergencista_id           INTEGER,
  location_id               INTEGER ,
  medical_history_text      text,
  symptom                   text,           --  emergencista detalle
  doctor_comment            text,           --  especialista detalle
  diagnostic                text,
  weight                    CHARACTER VARYING (10),
  body_temperature          CHARACTER VARYING (10),
  blood_pressure            CHARACTER VARYING (10),
  heart_rate                CHARACTER VARYING (10),
  next_medical_date         date,
  created_date              timestamp(3) without time zone DEFAULT NULL,
  created_by				        text,
  last_modified_date        timestamp(3) without time zone DEFAULT NULL,
  last_modified_by		      text,
  CONSTRAINT pk_medical_history PRIMARY KEY (id),
  CONSTRAINT fk_patient_id FOREIGN KEY (patient_id) REFERENCES patient(id),
  CONSTRAINT fk_doctor_id FOREIGN KEY (doctor_id) REFERENCES doctor(id),
  CONSTRAINT fk_emergencista_id FOREIGN KEY (emergencista_id) REFERENCES doctor(id)
);

/**/
create table medical_history_media(
  id                        serial NOT NULL ,
  medical_history_id        INTEGER ,
  picture_url               text,
  created_date              timestamp(3) without time zone DEFAULT NULL,
  created_by				        text,
  last_modified_date        timestamp(3) without time zone DEFAULT NULL,
  last_modified_by		      text,
  CONSTRAINT pk_medical_history_media PRIMARY KEY (id),
  CONSTRAINT fk_patient_id FOREIGN KEY (medical_history_id) REFERENCES medical_history(id)
);



select * from artifact_measurement;
create table artifact_measurement(
  id                        SERIAL NOT NULL,
  token                     text,
  weight                    CHARACTER VARYING (10),
  body_temperature          CHARACTER VARYING (10),
  blood_pressure            CHARACTER VARYING (10),
  picture_url               json,
  CONSTRAINT pk_artifact_measurement PRIMARY KEY (id)
);


select * from competition;
create table competition(
    id                        serial not null,
    patient_id                integer,
    doctor_id                 integer,
    qualification             integer,
    qualification_feedback    varchar(100),
    recommendation            integer,
    recommendation_feedback   varchar(100),
    created_date              timestamp(3) without time zone DEFAULT NULL,
    created_by				        text,
    last_modified_date        timestamp(3) without time zone DEFAULT NULL,
    last_modified_by		      text,
    constraint pk_competition primary key (id),
    constraint fk_competition_patient foreign key (patient_id) references patient(id),
    constraint fk_competition_doctor foreign key (doctor_id) references doctor(id)
  );


create table versioning_application(
    url_img                     text,
    version                     VARCHAR(20),
    package_name                text,
    state                       CHAR (1),
    platform                    text,
    application_url             text,
    description                 text,
    aplication                  text,
    created_date              timestamp(3) without time zone DEFAULT NULL,
    last_modified_date        timestamp(3) without time zone DEFAULT NULL
);

-- ===========voucher for enterprise=========
select * from voucher_type;

create table voucher_type(
    id                        varchar(80) not null,
    voucher_type_id		        varchar(80),
    description               text,
    created_date 		          timestamp(3) without time zone DEFAULT NULL,
    last_modified_date        timestamp(3) without time zone DEFAULT NULL,
    constraint voucher_type_pk primary key(id),
	  constraint voucher_type_fk foreign key(voucher_type_id) references voucher_type (id)
);

select * from voucher;
create table voucher(
    id                        SERIAL NOT NULL,
    voucher_type_id           varchar(80),
    name                      varchar(128),
    code                      varchar(128),
    usage                     varchar(128),
    state                     CHAR(1),
    device_id                 text,
    start_datetime            timestamp(3) without time zone DEFAULT NULL,
    end_datetime              timestamp(3) without time zone DEFAULT NULL,
    date_created              timestamp with time zone NOT NULL,
    last_modified_date        timestamp(3) without time zone DEFAULT NULL,
    constraint voucher_pk primary key(id),
	  constraint voucher_type_id foreign key(voucher_type_id) references voucher_type (id)
);


select * from voucher_enterprise;
CREATE TABLE voucher_enterprise(
    voucher_id                SERIAL NOT NULL,
    enterprise_id             SERIAL NOT NULL,
    date_created              timestamp with time zone NOT NULL,
    last_modified_date        timestamp(3) without time zone DEFAULT NULL,
    constraint voucher_id_fk foreign key(voucher_id) references voucher (id),
    constraint enterprise_id_fk foreign key(enterprise_id) references enterprise (id)

);


create table dict_table(

);

select * from payment_transaction;

-- Tipos de Pan de
select * from plantype;
-- drop table plantype
CREATE TABLE plantype(
  id                        varchar(80) not null,
  name                      character varying(128),
  description               character varying(128),
  date_created              timestamp with time zone,
  last_modified_date        timestamp(3) without time zone,
  CONSTRAINT plantype_pk PRIMARY KEY (id)
);


select * from plan;
drop TABLE plan
CREATE TABLE plan(
  id                        serial NOT NULL,
  amount                    numeric(12,2),
  plantype_id               varchar(80),
  date_created              timestamp with time zone,
  last_modified_date        timestamp(3) without time zone,
  CONSTRAINT plan_pk PRIMARY KEY (id),
  CONSTRAINT plantype_id_fk FOREIGN KEY (plantype_id) REFERENCES plantype(id)
);

drop TABLE payment_transaction;

select * from payment_transaction;
create table payment_transaction(
  id                        SERIAL NOT NULL,
  plan_id                   integer,
  first_name                varchar(128),
  last_name                 varchar(128),
  email                     varchar(100),
  amount                    DECIMAL(14,2),
  phone_number              varchar(30),
  address_city              varchar(100),
  address                   varchar(250),
  country_code              varchar(20),
  date_created              timestamp with time zone NOT NULL,
  last_modified_date        timestamp(3) without time zone DEFAULT NULL,
  constraint payment_transaction_pk primary key(id),
  CONSTRAINT paymentTx_plan_fk FOREIGN KEY(plan_id) REFERENCES plan(id)
);



CREATE TABLE recovery_email(
  id                        SERIAL NOT NULL,
  patient_id                INTEGER ,
  --email                   varchar(100),
  code                      varchar(20),
  is_used                   boolean,
  date_created              timestamp with time zone,
  last_modified_date        timestamp(3) without time zone DEFAULT NULL,
  constraint recovery_email_pk primary key(id),
  CONSTRAINT recovery_email_fk FOREIGN KEY(patient_id) REFERENCES patient(id)
  
);



-- ======================
-- END CREATION TABLES --

CREATE INDEX mh_index_location_id ON doctor (location_id);
/*index for doctor*/
CREATE INDEX doctor_index_location_id ON medical_history (location_id);

/*index for token measure*/
CREATE INDEX token_index ON artifact_measurement(token);

/*review index table*/
select * from pg_indexes where tablename = 'doctor';
select * from pg_indexes where tablename = 'medical_history';
select * from pg_indexes where tablename = 'artifact_measurement';



-- INSERT VALUES
-- license
select * from license;
insert into license(code, start_date, final_date, access_number)
VALUES ('1321','2017-08-15','2017-12-31','10');

insert into license(code, start_date, final_date, access_number)
VALUES ('7783','2017-08-15','2017-12-31','5');
--

select * from enterprise;
insert into enterprise(parent_id, license_id, enterprise_level, ruc, business_name, web_page,
trade_name, comercial_activity, postal_address, contact_name, contact_phone, midoc_user, password)
 VALUES(NULL, NULL , 1,'20100075009','GAP GLOBAL SOLUTIONS','http://ggs.com.pe',
  'Gap Global Solutions','Desarrollo de Proyectos Innovadores','Av. Javier Prado Este Nro. 2932','Fredy Alejandro','956573855',
  'midoc','midoc');


insert into enterprise(parent_id, license_id, enterprise_level, ruc, business_name, web_page,
trade_name, comercial_activity, postal_address, contact_name, contact_phone, midoc_user, password)
 VALUES(1, 1, 2,'20107463705',' CLINICA SAN PABLO S.A.C',' http://www.sanpablo.com.pe',
  'CLINICA SAN PABLO','Actividades de Hospitales','El Derby (con Av el Polo Nro 780)',null,null,
  'sanpablo','123456');



select * from emergency_attention;
insert into emergency_attention (attention_type_id, attention_name, description, picture_url, is_enabled,is_emergency)
values ('NUTRICION','Nutrición','Un nutricionista te orientará en la adopción de estilos  de vida saludables para mejorar tu salud, y prevenir problemas alimentario-nutricionales.','https://s3.amazonaws.com/midoc-dev/emergency-attention-img/one.png',TRUE ,FALSE );
insert into emergency_attention (attention_type_id, attention_name, description, picture_url, is_enabled,is_emergency)
values ('PSICOLOGÍA','Psicología','Nuestros psicólogos lo ayudarán a resolver problemas de salud relacionados al comportamiento o la conducta.','https://s3.amazonaws.com/midoc-dev/emergency-attention-img/three.png',TRUE,FALSE );
insert into emergency_attention (attention_type_id, attention_name, description, picture_url, is_enabled,is_emergency)
values ('MEDICINA GENERAL','Medicina General ','Nuestros psicólogos lo ayudarán a resolver problemas de salud relacionados al comportamiento o la conducta.','https://s3.amazonaws.com/midoc-dev/emergency-attention-img/two.png',TRUE,FALSE );
insert into emergency_attention (attention_type_id, attention_name, description, picture_url, is_enabled,is_emergency)
values ('TRAUMATOLOGÍA','Traumatología','Los mejores equipos y el mejor staff médico para la rehabilitación de la forma y función de las extremidades, columna y estructuras asociadas','https://s3.amazonaws.com/midoc-dev/emergency-attention-img/two.png',TRUE,TRUE );
insert into emergency_attention (attention_type_id, attention_name, description, picture_url, is_enabled,is_emergency)
values ('CIRUGÍA','Cirugía','Este procedimiento, que se realiza a través de incisiones pequeñas, permite que se abrevie el tiempo de hospitalización','https://s3.amazonaws.com/midoc-dev/emergency-attention-img/one.png',TRUE,TRUE );
insert into emergency_attention (attention_type_id, attention_name, description, picture_url, is_enabled,is_emergency)
values ('IMAGENOLOGÍA','Imagennologia','Especialistas en estudios de imágenes Rayos x, ecografias, tomografía','https://s3.amazonaws.com/midoc-dev/emergency-attention-img/one.png',TRUE,TRUE );
insert into emergency_attention (attention_type_id, attention_name, description, picture_url, is_enabled,is_emergency)
values ('LABORATORIO','Laboratorio de Urgencias',NULL,NULL,TRUE,TRUE );
insert into emergency_attention (attention_type_id, attention_name, description, picture_url, is_enabled,is_emergency)
values ('RADIODIAGNOSTISO','Radiodiagnóstico',NULL,NULL,TRUE,TRUE );
insert into emergency_attention (attention_type_id, attention_name, description, picture_url, is_enabled,is_emergency)
values ('NEFROLOGIA','Nefrología',NULL,NULL,TRUE,TRUE );
insert into emergency_attention (attention_type_id, attention_name, description, picture_url, is_enabled,is_emergency)
values ('NEUMOLOGIA','Neumología',NULL,NULL,TRUE,TRUE );
insert into emergency_attention (attention_type_id, attention_name, description, picture_url, is_enabled,is_emergency)
values ('URGENCIAS','Urgencias',NULL,NULL,TRUE,TRUE );


select * from enterprise;
select * from location;
INSERT INTO location(enterprise_id, name, description, picture_url, is_enabled, postal_address)
VALUES (1, 'Clinica San Pablo Surco', 'Clinica San Pablo sede Surco',NULL, TRUE,'Av. El Polo 789, Surco');


INSERT INTO location(enterprise_id, name, description, picture_url, is_enabled, postal_address)
VALUES (1, 'Clinica San Pablo Trujillo', 'Clinica San Pablo sede Trujillo',NULL, TRUE,null);
INSERT INTO location(enterprise_id, name, description, picture_url, is_enabled, postal_address)
VALUES (1, 'Clinica San Pablo Huaraz', 'Clinica San Pablo sede Huaraz ',NULL, TRUE,null);



select * from doctor;
select * from emergency_attention;
select * from location;

in_call                   boolean ,
  queue_count               INTEGER ,

select * from doctor;
insert INTO doctor( emergency_attention_id, location_id, cmd_peru, degree, doctor_name, year_of_birth,
picture_url, email, midoc_user, password, type_of_specialist, is_enabled,in_call,queue_count)
VALUES (1,1 ,'777666','Nutricionista','Ian Perez','1985-01-01',
'https://s3.amazonaws.com/midocvirtual/image-dev/doctor/doctor_female.png','coryperez@gmail.com','iperez','123456','ESPEC',TRUE, FALSE, 0);


insert INTO doctor( emergency_attention_id, location_id, cmd_peru, degree, doctor_name, year_of_birth,
picture_url, email, midoc_user, password, type_of_specialist, is_enabled,in_call,queue_count)
VALUES (3,1 ,'777666','Nutricionista','Pedro JuanPablo','1985-01-01',
'https://res.cloudinary.com/dzthuikyb/image/upload/v1500998377/doctor_02_nwodq0.jpg','pedrojuanpi@gmail.com','pedroj','123456','ESPEC',TRUE, FALSE , 0);


insert INTO doctor( emergency_attention_id, location_id, cmd_peru, degree, doctor_name, year_of_birth,
picture_url, email, midoc_user, password, type_of_specialist, is_enabled,in_call,queue_count)
VALUES (1,1 ,'777666','Nutricionista','Nicholas Gatjens','1985-01-01',
'https://s3.amazonaws.com/midoc-dev/doctors-img/Nicholas.jpg','⁠⁠⁠ngatjens@gmail.com','nicholasg','123456','ESPEC',TRUE, FALSE, 0);


--

insert INTO doctor( emergency_attention_id, location_id, cmd_peru, degree, doctor_name, year_of_birth,
picture_url, email, midoc_user, password, type_of_specialist, is_enabled)
VALUES (3,1 ,'777666','Nutricionista','Mayra Garcia','1985-01-01',
'https://s3.amazonaws.com/midoc-dev/doctors-img/Nicholas.jpg','⁠⁠⁠ngatjens@gmail.com','⁠⁠⁠ngatjens','123456','ESPEC',TRUE );

insert INTO doctor( emergency_attention_id, location_id, cmd_peru, degree, doctor_name, year_of_birth,
picture_url, email, midoc_user, password, type_of_specialist, is_enabled)
VALUES (5,1 ,'777666','Traumatología','Carlos Oliveira','2000-01-01',
'https://res.cloudinary.com/dzthuikyb/image/upload/v1500998377/doctor_02_nwodq0.jpg','cdoliveirar@gmail.com','coliveira','123456','ESPEC',TRUE );

insert INTO doctor( emergency_attention_id, location_id, cmd_peru, degree, doctor_name, year_of_birth,
picture_url, email, midoc_user, password, type_of_specialist, is_enabled)
VALUES (2,1,'777667','Medicina General','Desireé Alves','2005-01-01',
'https://res.cloudinary.com/dzthuikyb/image/upload/v1500998363/doctora_01_dagzvl.jpg','dalves@gmail.com','dalves','123456','ESPEC',TRUE );

insert INTO doctor( emergency_attention_id, location_id, cmd_peru, degree, doctor_name, year_of_birth,
picture_url, email, midoc_user, password, type_of_specialist, is_enabled)
VALUES (5,1,'777668','Neurología','Benjamin Gomez','2006-01-01',
'http://res.cloudinary.com/dzthuikyb/image/upload/v1500998377/doctor_03_rqkjdh.jpg','bgomez@gmail.com','bgomez','123456','ESPEC',TRUE );

insert INTO doctor( emergency_attention_id, location_id, cmd_peru, degree, doctor_name, year_of_birth,
picture_url, email, midoc_user, password, type_of_specialist, is_enabled)
VALUES (2,1, '777610','emergencista','Jemery Suarez','2000-08-25',
'http://res.cloudinary.com/dzthuikyb/image/upload/v1500998377/doctor_03_rqkjdh.jpg','jsuarez@gmail.com','jsuarez','123456','EMERG',TRUE );

insert INTO doctor( emergency_attention_id, location_id, cmd_peru, degree, doctor_name, year_of_birth,
picture_url, email, midoc_user, password, type_of_specialist, is_enabled)
VALUES (2,1,'777611','emergencista','Jaoh Oliveira','2000-08-25',
'http://res.cloudinary.com/dzthuikyb/image/upload/v1500998377/doctor_03_zrqkjdh.jpg','joliveira@gmail.com','joliveira','123456','EMERG',TRUE );

insert INTO doctor( emergency_attention_id, location_id, cmd_peru, degree, doctor_name, year_of_birth,
picture_url, email, midoc_user, password, type_of_specialist, is_enabled)
VALUES (8,1,'777611','emergencista','GianFranco Gutierrez','1985-08-25',
'http://res.cloudinary.com/dzthuikyb/image/upload/v1500998377/doctor_03_rqkjdh.jpg','joliveira@gmail.com','joliveira','123456','EMERG',TRUE );


--
SELECT * FROM location;
select * from enterprise;




select * from emergency_attention;
select * from location;
SELECT * FROM location_emergency_attention;
INSERT INTO location_emergency_attention(location_id, emergency_attention_id) 
VALUES (1,1 );
INSERT INTO location_emergency_attention(location_id, emergency_attention_id)
VALUES (1,2 );
INSERT INTO location_emergency_attention(location_id, emergency_attention_id)
VALUES (1,3 );


INSERT INTO location_emergency_attention(location_id, emergency_attention_id)
VALUES (1,4 );
INSERT INTO location_emergency_attention(location_id, emergency_attention_id)
VALUES (1,5 );
INSERT INTO location_emergency_attention(location_id, emergency_attention_id)
VALUES (2,1 );
INSERT INTO location_emergency_attention(location_id, emergency_attention_id)
VALUES (2,2 );
INSERT INTO location_emergency_attention(location_id, emergency_attention_id)
VALUES (2,3 );
INSERT INTO location_emergency_attention(location_id, emergency_attention_id)
VALUES (2,4 );
INSERT INTO location_emergency_attention(location_id, emergency_attention_id)
VALUES (2,5 );
INSERT INTO location_emergency_attention(location_id, emergency_attention_id)
VALUES (3,1 );
INSERT INTO location_emergency_attention(location_id, emergency_attention_id)
VALUES (3,2 );
INSERT INTO location_emergency_attention(location_id, emergency_attention_id)
VALUES (3,3 );
INSERT INTO location_emergency_attention(location_id, emergency_attention_id)
VALUES (3,4 );
INSERT INTO location_emergency_attention(location_id, emergency_attention_id)
VALUES (3,5 );


-- patient
select * from location;
select * from patient;
INSERT INTO patient(location_id, name, year_of_birth, email, midoc_user, password, dni, picture_url, blood_type, allergic_reaction, token_sinch, is_enterprise_enabled)
VALUES (2,'Leo Ramirez','2000-03-15','leo.ramirez.o@gmail.com','lramirez','123456','50607089',null,'RH-','No Alergias','42314123',null);
INSERT INTO patient(location_id, name, year_of_birth, email, midoc_user, password, dni, picture_url, blood_type, allergic_reaction, token_sinch, is_enterprise_enabled)
VALUES (1, 'Fredy Alejandro','1940-02-15','fredyac0106@gmail.com','falejandro','12334','50607090',null,'RH-','MultipleAlergias','42314123',null);
INSERT INTO patient(location_id, name, year_of_birth, email, midoc_user, password, dni, picture_url, blood_type, allergic_reaction, token_sinch, is_enterprise_enabled)
VALUES (2,'Isaac Gab','2000-03-25','fredyac0106@gmail.com','falejandro','12334','50607091',null,'O','No alergias','42314123',null);
INSERT INTO patient(location_id, name, year_of_birth, email, midoc_user, password, dni, picture_url, blood_type, allergic_reaction, token_sinch, is_enterprise_enabled)
VALUES (2,'Gustavo Gap','2005-06-04','gustrago@gmail.com','ggap','12334','50607092',null,'O','No alergias','42314123',null);
-- prod
INSERT INTO patient(location_id, name, year_of_birth, email, midoc_user, password, dni, picture_url, blood_type, allergic_reaction, token_sinch, is_enterprise_enabled)
VALUES (1,'Martin','2005-06-04','martin@gmail.com','martin','12334','50607083',null,'O','No alergias','42314123',null);


-- appointment
select * from appointment;
INSERT into appointment(patient_id, doctor_id, appointment_time,appointment_status)
VALUES(1,1,'2017-10-02 10:30:00','ATENDIDO');
INSERT into appointment(patient_id, doctor_id, appointment_time,appointment_status)
VALUES(2,1,'2017-10-03 09:15:00','PENDIENTE');
INSERT into appointment(patient_id, doctor_id, appointment_time,appointment_status)
VALUES(1,2,'2017-10-03 09:15:00','CANCELADO');



-- Medical History
SELECT * from patient;
SELECT * from doctor where type_of_specialist = 'ESPEC';
SELECT * from doctor where type_of_specialist = 'EMERG';
select * from medical_history;
INSERT INTO medical_history(patient_id, doctor_id, emergencista_id, location_id, medical_history_text, symptom, doctor_comment)
VALUES (1,2,5,1,'El paciente paso a cuidados intensivos','Paciente con quemaduras multiples','Indicaciones del especialista'  );
INSERT INTO medical_history(patient_id, doctor_id, emergencista_id, location_id, medical_history_text, symptom, doctor_comment)
VALUES (2,2,5,1,'Paciente cuidados intensivos','diarrea','fue necesario suero' );
INSERT INTO medical_history(patient_id, doctor_id, emergencista_id, location_id, medical_history_text, symptom, doctor_comment)
VALUES (3,3,4,1,'de alta','roptura de tibia','clavos de adamantio' );
INSERT INTO medical_history(patient_id, doctor_id, emergencista_id, location_id, medical_history_text, symptom, doctor_comment)
VALUES (4,1,5,1,'cuidados intensivos','accidente de auto','operacion inmediata' );
INSERT INTO medical_history(patient_id, doctor_id, emergencista_id, location_id, medical_history_text, symptom, doctor_comment)
VALUES (2,2,5,1,'quemaduras','accidente de auto','operacion inmediata' );
INSERT INTO medical_history(patient_id, doctor_id, emergencista_id, location_id, medical_history_text, symptom, doctor_comment)
VALUES (4,2,5,1,'intoxicacion','dolor fuerte de estomago','lavado estomacal' );

-- prod
INSERT INTO medical_history(patient_id, doctor_id, emergencista_id, location_id, medical_history_text, symptom, doctor_comment)
VALUES (4,3,8,1,'cuidados intensivos','accidente motocicleta','operacion inmediata' );
INSERT INTO medical_history(patient_id, doctor_id, emergencista_id, location_id, medical_history_text, symptom, doctor_comment)
VALUES (5,3,8,1,'roptura de femur','dolor intenso pierna','operacion inmediata' );


select * from medical_history;

SELECT * FROM doctor WHERE type_of_specialist = 'EMERG';


select * from medical_history_media;
select * from medical_history;
INSERT INTO medical_history_media(medical_history_id, picture_url)
VALUES (1,'url picture1.png');
INSERT INTO medical_history_media(medical_history_id, picture_url)
VALUES (1,'url picture2.png');
INSERT INTO medical_history_media(medical_history_id, picture_url)
VALUES (1,'url picture3.png');
INSERT INTO medical_history_media(medical_history_id, picture_url)
VALUES (2,'url picture1.jpg');
INSERT INTO medical_history_media(medical_history_id, picture_url)
VALUES (2,'url picture2.jpg');
INSERT INTO medical_history_media(medical_history_id, picture_url)
VALUES (3,'url placa.png');
INSERT INTO medical_history_media(medical_history_id, picture_url)
VALUES (4,'url medicinas.png');

-- prod
INSERT INTO medical_history_media(medical_history_id, picture_url)
VALUES (4,'https://urgenciasbidasoa.files.wordpress.com/2012/11/fractura-costal-torax-ap-y-l.jpg');
INSERT INTO medical_history_media(medical_history_id, picture_url)
VALUES (4,'https://urgenciasbidasoa.files.wordpress.com/2012/11/fractura-costal-torax-ap-y-l.jpg');
INSERT INTO medical_history_media(medical_history_id, picture_url)
VALUES (4,'https://urgenciasbidasoa.files.wordpress.com/2012/11/fractura-costal-torax-ap-y-l.jpg');


INSERT INTO medical_history_media(medical_history_id, picture_url)
VALUES (8,'https://previews.123rf.com/images/thailoei92/thailoei921504/thailoei92150400083/39098961-X-ray-of-leg-with-metal-plates-2-view-Stock-Photo.jpg');
INSERT INTO medical_history_media(medical_history_id, picture_url)
VALUES (8,'http://radpod.org/wp-content/uploads/2007/01/eg_femur.JPG');
INSERT INTO medical_history_media(medical_history_id, picture_url)
VALUES (8,'https://thumbs.dreamstime.com/z/eje-de-la-fractura-del-f%C3%A9mur-fue-actuado-y-fijaci%C3%B3n-interna-46694335.jpg');


select * from plantype;
insert into plantype(id, name, description, date_created)
VALUES ('PLAN_PERSONAL', 'Plan Personal','2 Video consultas nutrionales mensuales', now());
insert into plantype(id, name, description, date_created)
VALUES ('PLAN_FAMILIAR', 'Plan Familiar', '4 videos consultas nutricionales mensuales', now());

select * from plan;

INSERT INTO plan(amount,plantype_id, date_created ) VALUES (50, 'PLAN_PERSONAL', now());
INSERT INTO plan(amount,plantype_id, date_created ) VALUES (80, 'PLAN_FAMILIAR', now());

-- =========================

select * from plan;




SELECT * from patient;
select * from doctor;
select * from medical_history;
--

select * from location where enterprise_id = 3;
select * from emergency_attention;

-- One2Onw2922
select ea.id, ea. from emergency_attention ea
INNER JOIN location_emergency_attention lea  on ea.id = lea.emergency_attention_id
INNER JOIN location l on lea.location_id = l.id
where l.id = 1; -- sede
--
select ap.* from emergency_attention ap
INNER JOIN location_emergency_attention lea  on ap.id = lea.emergency_attention_id
where lea.location_id = 1;
--

SELECT * FROM doctor where type_of_specialist = 'ESPEC';
select * from doctor where type_of_specialist = 'EMERG';
select * from location;

UPDATE doctor
set location_id = 1
where type_of_specialist = 'ESPEC';

UPDATE doctor
set location_id = 1
where type_of_specialist = 'EMERG';



SELECT * from emergency_attention att
  INNER join location_emergency_attention lea on (att.id = lea.emergency_attention_id)
where lea.location_id = 1;

select ap.* from emergency_attention ap
INNER JOIN location_emergency_attention lea  on ap.id = lea.emergency_attention_id
where lea.location_id = 1;


SELECT * from doctor where location_id =1 and type_of_specialist = 'EMERG';
--
select * from patient;
select * from medical_history;

-- api/doctor/<id_doctor>/location/<id_location>

select mh.id as medical_history_id, p.name, p.year_of_birth, p.blood_type, p.allergic_reaction, p.id
  from medical_history mh inner join patient p on (mh.patient_id = p.id)
where mh.emergencista_id = 5 and mh.location_id =1 and mh.doctor_id =2;

-- medical history detail
select mhm.picture_url, mh.patient_id,mh.doctor_id, mh.emergencista_id, mh.location_id,
mh.medical_history_text,mh.symptom, mh.doctor_comment
from medical_history mh inner join medical_history_media mhm on (mh.id = mhm.medical_history_id)
where mh.patient_id = 1 mh.doc
-- 


select * from medical_history_media where id =8;


select * from emergency_attention;

select * from doctor WHERE id in(6,7,8);
select * from doctor WHERE type_of_specialist = 'EMERG' and location_id = 1
select * from doctor WHERE type_of_specialist = 'ESPEC';


select * from doctor where type_of_specialist = 'EMERG';
select mh.patient_id, from medical_history mh inner join doctor d

select * from doctor;
select * from patient;

select * from patient where token_sinch = '097f3021-5ca2-42c0-8988-78f201421549';

#alter table patient add COLUMN background text;


select * from medical_history;
select * from patient order by id desc;

select t.name, t.background from patient t where id = 1264
--
select * from doctor;
select * from patient;
select * from medical_history;
--
select * from patient where id in (
select DISTINCT (patient_id) from medical_history where doctor_id = 1);
--
select * from patient where id in (
select count(*) from medical_history where doctor_id = 1);

--
select * from patient where id in(
select patient_id from medical_history where doctor_id = 1
ORDER by created_date desc);
--
select * from patient where id = 1352;       #1386;
--
select * from patient order by id desc;

select DISTINCT(dni) from patient

select LENGTH (code) from voucher;


select id,queue_count from doctor;
update doctor
set call_activate = 'I'


update voucher
set state = 0
where id = 1;





alter table doctor add COLUMN in_call boolean;
alter table doctor add COLUMN queue_count INTEGER;

DELETE from doctor where id in (2,3);

select * from patient;

select * from doctor;
alter table patient add COLUMN count_calling INTEGER;