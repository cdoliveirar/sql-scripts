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
  call_activate             VARCHAR(1),
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
 VALUES(1, 1, 2,'20601563046','ADMINISTRADORA CLINICA RICARDO PALMA S.A.','http://www.crp.com.pe',
  'Clinica Ricardo Palma Sa','Actividades de Hospitales','Av. Javier Prado Este Nro. 1066',null,null,
  'rpalma','123456');

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




select * from doctor;
insert INTO doctor( emergency_attention_id, location_id, cmd_peru, degree, doctor_name, year_of_birth,
picture_url, email, midoc_user, password, type_of_specialist, is_enabled)
VALUES (1,1 ,'777666','Nutricionista','Nicholas Gatjens','1985-01-01',
'https://s3.amazonaws.com/midoc-dev/doctors-img/Nicholas.jpg','⁠⁠⁠ngatjens@gmail.com','⁠⁠⁠ngatjens','123456','ESPEC',TRUE );

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
INSERT INTO patient(location_id, name, year_of_birth, email, midoc_user, password, dni, picture_url, blood_type, allergic_reaction, token_sinch, is_enterprise_enabled)
VALUES (1,'Leo Ramirez','2000-03-15','leo.ramirez.o@gmail.com','lramirez','123456','50607089',null,'RH-','No Alergias','42314123',null);
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


select * from medical_history_media where id =8;


select * from emergency_attention;

select * from doctor WHERE id in(6,7,8);
select * from doctor WHERE type_of_specialist = 'EMERG' and location_id = 1
select * from doctor WHERE type_of_specialist = 'ESPEC';


select * from doctor where type_of_specialist = 'EMERG';
select mh.patient_id, from medical_history mh inner join doctor d
