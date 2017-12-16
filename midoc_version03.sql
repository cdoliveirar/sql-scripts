ALTER TABLE public.medical_history_media DROP CONSTRAINT fk_patient_id;
ALTER TABLE public.location_emergency_attention DROP CONSTRAINT fk_location_emergency_attention01;
ALTER TABLE public.location_emergency_attention DROP CONSTRAINT fk_location_emergency_attention02;
ALTER TABLE public.medical_history DROP CONSTRAINT fk_patient_id;
ALTER TABLE public.medical_history DROP CONSTRAINT fk_doctor_id;
ALTER TABLE public.medical_history DROP CONSTRAINT fk_eemergencista_id;
ALTER TABLE public.enterprise DROP CONSTRAINT fk_enterprise;
ALTER TABLE public.enterprise DROP CONSTRAINT fk_license_id;
ALTER TABLE public.location DROP CONSTRAINT fk_enterprise_id;
ALTER TABLE public.doctor DROP CONSTRAINT fk_emergency_attention_id;
DROP TABLE public.medical_history_media;
DROP TABLE public.location_emergency_attention;
DROP TABLE public.medical_history;
DROP TABLE public.enterprise;
DROP TABLE public.location;
DROP TABLE public.doctor;
DROP TABLE public.patient;
DROP TABLE public.license;
DROP TABLE public.emergency_attention;

--

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
  created_date              timestamp(3) without time zone DEFAULT NULL,
  created_by				        text,
  last_modified_date        timestamp(3) without time zone DEFAULT NULL,
  last_modified_by		      text,
  CONSTRAINT pk_doctor primary key (id) ,
  CONSTRAINT fk_emergency_attention_id FOREIGN KEY (emergency_attention_id) REFERENCES emergency_attention(id)
);


/**/
create table patient(
  id                        serial not null,
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
  nokia_weight              CHARACTER VARYING (10),
  nokia_body_temperature    CHARACTER VARYING (10),
  nokia_blood_pressure      CHARACTER VARYING (10),
  size                      CHARACTER VARYING (100),
  is_enterprise_enabled     boolean,                  -- if has enterprise plan
  created_date              timestamp(3) without time zone DEFAULT NULL,
  created_by				        text,
  last_modified_date        timestamp(3) without time zone DEFAULT NULL,
  last_modified_by		      text,
  constraint pk_patient primary key (id)
);


/**/
create table  medical_history(
  id                        serial not null,
  patient_id                INTEGER NOT NULL ,
  doctor_id                 INTEGER NOT NULL ,
  emergencista_id           INTEGER NOT NULL ,
  location_id               INTEGER ,
  medical_history_text      text,
  symptom                   text,
  doctor_comment            text,
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


-- ======================
-- END CREATION TABLES --

-- CREATE INDEX
/* index for medical_history*/
CREATE INDEX mh_index_location_id ON doctor (location_id);
/*index for doctor*/
CREATE INDEX doctor_index_location_id ON medical_history (location_id);

/*review index table*/
select * from pg_indexes where tablename = 'doctor';
select * from pg_indexes where tablename = 'medical_history';



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
 VALUES(1, 1, 2,'20601563046','ADMINISTRADORA CLINICA RICARDO PALMA S.A.','http://www.crp.com.pe',
  'Clinica Ricardo Palma Sa','Actividades de Hospitales','Av. Javier Prado Este Nro. 1066',null,null,
  'rpalma','123456');

insert into enterprise(parent_id, license_id, enterprise_level, ruc, business_name, web_page,
trade_name, comercial_activity, postal_address, contact_name, contact_phone, midoc_user, password)
 VALUES(1, 1, 2,'20100054184',' CLINICA INTERNACIONAL S A','http://www.clinicainternacional.com.pe',
  'CLINICA INTERNACIONAL','Actividades de Hospitales','Jr. Washington Nro. 1471',null,null,
  'internacional','123456');



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




select * from doctor;
insert INTO doctor( emergency_attention_id, location_id, cmd_peru, degree, doctor_name, year_of_birth,
picture_url, email, midoc_user, password, type_of_specialist, is_enabled)
VALUES (1,1 ,'777666','Nutricionista','Nicholas Gatjens','1985-01-01',
'https://s3.amazonaws.com/midoc-dev/doctors-img/Nicholas.jpg','⁠⁠⁠ngatjens@gmail.com','⁠⁠⁠ngatjens','123456','ESPEC',TRUE );

insert INTO doctor( emergency_attention_id, location_id, cmd_peru, degree, doctor_name, year_of_birth,
picture_url, email, midoc_user, password, type_of_specialist, is_enabled)
VALUES (3,1 ,'777666','Nutricionista','Nicholas Gatjens','1985-01-01',
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
'http://res.cloudinary.com/dzthuikyb/image/upload/v1500998377/doctor_03_rqkjdh.jpg','joliveira@gmail.com','joliveira','123456','EMERG',TRUE );

insert INTO doctor( emergency_attention_id, location_id, cmd_peru, degree, doctor_name, year_of_birth,
picture_url, email, midoc_user, password, type_of_specialist, is_enabled)
VALUES (8,1,'777611','emergencista','GianFranco Gutierrez','1985-08-25',
'http://res.cloudinary.com/dzthuikyb/image/upload/v1500998377/doctor_03_rqkjdh.jpg','joliveira@gmail.com','joliveira','123456','EMERG',TRUE );


--
SELECT * FROM location;
INSERT INTO location(enterprise_id, name, description, picture_url, is_enabled, postal_address)
VALUES (3, 'Sede Lima', 'Sede Lima',NULL, TRUE,'Av. Inca Garcilaso de la Vega 1420');
INSERT INTO location(enterprise_id, name, description, picture_url, is_enabled, postal_address)
VALUES (3, 'Sede San Borja', 'Sede San Borja',NULL, TRUE,'Av. Guardia Civil 421 -433');
INSERT INTO location(enterprise_id, name, description, picture_url, is_enabled, postal_address)
VALUES (3, 'Sede Piura', 'Sede Piura ',NULL, TRUE,'Av. Los Cocos 111 Urb. Club Grau');


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
select * from patient;
INSERT INTO patient(name, year_of_birth, email, midoc_user, password, dni, picture_url, blood_type, allergic_reaction, token_sinch, is_enterprise_enabled)
VALUES ('Leo Ramirez','2000-03-15','leo.ramirez.o@gmail.com','lramirez','123456','50607089',null,'RH-','No Alergias','42314123',null);
INSERT INTO patient(name, year_of_birth, email, midoc_user, password, dni, picture_url, blood_type, allergic_reaction, token_sinch, is_enterprise_enabled)
VALUES ('Fredy Alejandro','1940-02-15','fredyac0106@gmail.com','falejandro','12334','50607089',null,'RH-','MultipleAlergias','42314123',null);
INSERT INTO patient(name, year_of_birth, email, midoc_user, password, dni, picture_url, blood_type, allergic_reaction, token_sinch, is_enterprise_enabled)
VALUES ('Isaac Gab','2000-03-25','fredyac0106@gmail.com','falejandro','12334','50607089',null,'O','No alergias','42314123',null);
INSERT INTO patient(name, year_of_birth, email, midoc_user, password, dni, picture_url, blood_type, allergic_reaction, token_sinch, is_enterprise_enabled)
VALUES ('Gustavo Gap','2005-06-04','gustrago@gmail.com','ggap','12334','50607089',null,'O','No alergias','42314123',null);


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


INSERT into

-- =========================




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


select * from medical_history where id =8;



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



select * from doctor

insert INTO doctor( emergency_attention_id, location_id, cmd_peru, degree, doctor_name, year_of_birth,
picture_url, email, midoc_user, password, type_of_specialist, is_enabled)
VALUES (1,1 ,'777666','Nutricionista','Nicholas Gatjens','1985-01-01',
'https://s3.amazonaws.com/midoc-dev/doctors-img/Nicholas.jpg','⁠⁠⁠ngatjens@gmail.com','⁠⁠⁠ngatjens','123456','ESPEC',TRUE );


select * from doctor;
UPDATE doctor
set midoc_user = 'nicholas', email = 'elnicho@gmail.com'
where id = 1;

UPDATE doctor
set midoc_user = 'pdenegri', email = 'ndenegri@gmail.com', doctor_name = 'Paul Gatjens'
where id = 2;


select * from artifact_measurement;