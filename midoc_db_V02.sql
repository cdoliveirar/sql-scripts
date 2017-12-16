create table specialty(
  id                    serial not null,
  specialty_type_id     varchar(80),        -- checkeo preventivo, nutricion..
  specialty_name        varchar(80),        -- specialty name to show
  description           varchar(255),
  atention_time         time,   -- Time of public attention
  created_date          timestamp(3) without time zone DEFAULT NULL,
  created_by				    text,
  last_modified_date    timestamp(3) without time zone DEFAULT NULL,
  last_modified_by		  text,
  constraint pk_specialty primary key (id)
);


create table doctor(
  id                    serial not null,
  specialty_id          integer,
  degree                varchar(100),     -- academic degree
  doctor_name           varchar(100),
  user_sinch            varchar(100),
  picture_url           varchar(250),
  email                 varchar(100),
  is_available          boolean,            -- available for attention
  is_enabled            boolean,            -- enabled at the system
  created_date          timestamp(3) without time zone DEFAULT NULL,
  created_by				    text,
  last_modified_date    timestamp(3) without time zone DEFAULT NULL,
  last_modified_by		  text,
  constraint pk_doctor primary key (id),
  constraint fk_doctor_specialty foreign key (specialty_id) references specialty(id)
);


create table patient(
  patient_id            serial not null,
  name                  varchar(100),
  age                   varchar(100),
  email                 varchar(100),
  password              varchar(100),
  dni                   varchar(8),
  picture_url           varchar(250),
  uuid                  varchar(80),              -- sinch code
  is_enterprise_enabled boolean,                  -- if has enterprise plan
  created_date          timestamp(3) without time zone DEFAULT NULL,
  created_by				    text,
  last_modified_date    timestamp(3) without time zone DEFAULT NULL,
  last_modified_by		  text,
  constraint pk_patient primary key (patient_id)
);


CREATE TABLE symptom(
  id                    serial not null,
  patient_id            integer not null,
  symptom_detail        text,
  created_date          timestamp(3) without time zone DEFAULT NULL,
  created_by				    text,
  last_modified_date    timestamp(3) without time zone DEFAULT NULL,
  last_modified_by		  text,
  CONSTRAINT pk_symptom PRIMARY KEY (id),
  CONSTRAINT fk_symptom_patient FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
);


CREATE TABLE profile(
  id                    SERIAL NOT NULL,
  parent_profile_id     INTEGER,
  patient_id            INTEGER,
  created_date          timestamp(3) without time zone DEFAULT NULL,
  created_by				    text,
  last_modified_date    timestamp(3) without time zone DEFAULT NULL,
  last_modified_by		  text,
  CONSTRAINT pk_profile PRIMARY KEY (id),
  CONSTRAINT fk_profile_patient_01 FOREIGN KEY (parent_profile_id) REFERENCES patient(patient_id),
  CONSTRAINT fk_profile_patient_02 FOREIGN KEY (patient_id) REFERENCES patient(patient_id)

);


-- Feedback about the service and recomendation.
create table competition(
  id                        serial not null,
  patient_id                integer not null,
  doctor_id                 integer not null,
  qualification             integer,
  qualification_feedback    varchar(100),
  recommendation            integer,
  recommendation_feedback   varchar(100),
  created_date              timestamp(3) without time zone DEFAULT NULL,
  created_by				        text,
  last_modified_date        timestamp(3) without time zone DEFAULT NULL,
  last_modified_by		      text,
  constraint pk_competition primary key (id),
  constraint fk_competition_patient foreign key (patient_id) references patient(patient_id),
  constraint fk_competition_doctor foreign key (doctor_id) references doctor(id)
);


create table  medical_history(
  id                        serial not null,
  patient_id                integer not null,
  doctor_id                 integer not null,
  medical_history_text      text,
  created_date              timestamp(3) without time zone DEFAULT NULL,
  created_by				        text,
  last_modified_date        timestamp(3) without time zone DEFAULT NULL,
  last_modified_by		      text,
  constraint pk_medical_history primary key (id)
);

create table  prescription(
  id                        serial not null,
  medical_history_id        integer not null,
  prescription_text         text,
  created_date              timestamp(3) without time zone DEFAULT NULL,
  created_by				        text,
  last_modified_date        timestamp(3) without time zone DEFAULT NULL,
  last_modified_by		      text,
  constraint pk_prescription primary key (id),
  constraint fk_prescription_medical_history foreign key (medical_history_id) references medical_history(id)
);

-- +++
CREATE TABLE enterprise (
  id                        SERIAL NOT NULL,
  ruc                       VARCHAR(11),
  business_name             VARCHAR(255),
  web_page                  VARCHAR(100),
  trade_name                VARCHAR(100),
  comercial_activity        VARCHAR(50),
  postal_address            VARCHAR(255),
  created_date              timestamp(3) without time zone DEFAULT NULL,
  created_by				        text,
  last_modified_date        timestamp(3) without time zone DEFAULT NULL,
  last_modified_by		      text,
  CONSTRAINT pk_enterprise PRIMARY KEY (id)
);

CREATE TABLE enterprice_employees (
  id                        SERIAL NOT NULL ,
  enterprise_id             INTEGER,
  name                      VARCHAR(100),
  email                     VARCHAR(100),
  dni                       VARCHAR(8),
  created_date              timestamp(3) without time zone DEFAULT NULL,
  created_by				        text,
  last_modified_date        timestamp(3) without time zone DEFAULT NULL,
  last_modified_by		      text,
  CONSTRAINT pk_enterprice_employees PRIMARY KEY (id),
  CONSTRAINT fk_enterprise_id FOREIGN KEY (enterprise_id) REFERENCES enterprise(id)
);


-- it will change for a new table

-- CREATE TABLE enterprise_patient (
--   patient_id                INTEGER NOT NULL,
--   enterprise_id             INTEGER NOT NULL,
--   created_date              TIMESTAMP(3) WITHOUT TIME ZONE DEFAULT NULL,
--   created_by                TEXT,
--   last_modified_date        TIMESTAMP(3) WITHOUT TIME ZONE DEFAULT NULL,
--   last_modified_by          TEXT,
--   CONSTRAINT pks_enterprise_patient PRIMARY KEY (patient_id, enterprise_id),
--   CONSTRAINT fk_patient_id FOREIGN KEY (patient_id) REFERENCES patient (patient_id),
--   CONSTRAINT fk_enterprise FOREIGN KEY (enterprise_id) REFERENCES enterprise (id)
-- );



CREATE TABLE membership (
  id                        SERIAL NOT NULL,
  membership_type           VARCHAR(100),
  description               TEXT,
  created_date              TIMESTAMP(3) WITHOUT TIME ZONE DEFAULT NULL,
  created_by                TEXT,
  last_modified_date        TIMESTAMP(3) WITHOUT TIME ZONE DEFAULT NULL,
  last_modified_by          TEXT,
  CONSTRAINT pk_membership PRIMARY KEY (id)
);



CREATE TABLE membership_patient (
  membership_id             INTEGER,
  patient_id                INTEGER,
  created_date              TIMESTAMP(3) WITHOUT TIME ZONE DEFAULT NULL,
  created_by                TEXT,
  last_modified_date        TIMESTAMP(3) WITHOUT TIME ZONE DEFAULT NULL,
  last_modified_by          TEXT,
  CONSTRAINT pks_membership_patient PRIMARY KEY (membership_id, patient_id),
  CONSTRAINT fk_membership_id FOREIGN KEY (membership_id)  REFERENCES membership(id),
  CONSTRAINT fk_patient_id FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
);



CREATE TABLE promotion (
  id                        SERIAL NOT NULl,
  promotion_type            VARCHAR(100),
  created_date              TIMESTAMP(3) WITHOUT TIME ZONE DEFAULT NULL,
  created_by                TEXT,
  last_modified_date        TIMESTAMP(3) WITHOUT TIME ZONE DEFAULT NULL,
  last_modified_by          TEXT,
  CONSTRAINT pk_promotion PRIMARY KEY (id)
);


CREATE TABLE promotion_enrollment (
  id                        SERIAL NOT NULL ,
  promotion_id              INTEGER,
  code                      VARCHAR(50),
  is_available              BOOLEAN,
  start_date                DATE,
  final_date                DATE,
  created_date              TIMESTAMP(3) WITHOUT TIME ZONE DEFAULT NULL,
  created_by                TEXT,
  last_modified_date        TIMESTAMP(3) WITHOUT TIME ZONE DEFAULT NULL,
  last_modified_by          TEXT,
  CONSTRAINT pk_promotion_enrollment PRIMARY KEY (id),
  CONSTRAINT fk_promotion_enrollment FOREIGN KEY (promotion_id)
    REFERENCES promotion(id)
);


CREATE TABLE patient_promotion_enrollment (
  patient_id                INTEGER,
  promotion_enrollment_id   INTEGER,
  created_date              TIMESTAMP(3) WITHOUT TIME ZONE DEFAULT NULL,
  created_by                TEXT,
  last_modified_date        TIMESTAMP(3) WITHOUT TIME ZONE DEFAULT NULL,
  last_modified_by          TEXT,
  CONSTRAINT pks_patient_promotion_enrollment PRIMARY KEY (patient_id, promotion_enrollment_id),
  CONSTRAINT fk_patient_promotion_enrollment_01 FOREIGN KEY (patient_id)  REFERENCES patient(patient_id),
  CONSTRAINT fk_patient_promotion_enrollment_02 FOREIGN KEY (promotion_enrollment_id)
    REFERENCES promotion_enrollment(id)

);


-- ======================
-- END CREATION TABLES --


----
----
select * from patient;
select * from doctor;
select * from competition;

--
insert into patient(name,email) values('carlos','cdoliveirar@gmail.com');
insert into doctor(name,surname,email) values('david','rodriguez','david@gmail.com');
insert into competition(patient_id,doctor_id,qualification,recommendation) values(1,1,'3','SI');
insert into competition(patient_id,qualification,recommendation) values(1,'3','SI');


---
ALTER TABLE doctor ADD COLUMN available boolean DEFAULT TRUE;
--
ALTER TABLE doctor ADD COLUMN enabled boolean DEFAULT TRUE;
--

update doctor
set name = 'Jose Rodriguez',
  user_sinch = 'jrodriguez',
  picture_url = 'http://res.cloudinary.com/dzthuikyb/image/upload/v1500998377/doctor_03_rqkjdh.jpg',
  email = 'joserodriguez@gmail.com', specialty = 'NUTRICION'
where id = 3;

delete from doctor where id in(4,5);
--- copy remote
scp -r /path/to/local/dir user@remotehost:/path/to/remote/dir

-- ver las columnsas de una tabla
select column_name, data_type, character_maximum_length
from INFORMATION_SCHEMA.COLUMNS where table_name = 'specialty';

-- ==============
-- especialidades
SELECT *
FROM specialty;

insert into specialty(specialty_type_id, specialty_name, description, atention_time)
values('CHEQUEO_PREVENTIVO','CHEQUEO PREVENTIVO', 'Solicite a nuestros médicos generales para que le realice una evaluación preventiva.','00:15:00');
insert into specialty(specialty_type_id, specialty_name, description, atention_time)
values('SALUD_MENTAL','SALUD MENTAL', 'Psicologos y psiquiatras lo ayudarán a resolver problemas de salud relacionados al comportamiento.','00:15:00');
insert into specialty(specialty_type_id, specialty_name, description, atention_time)
values('NUTRICION','NUTRICION', 'Un nutricionista te orientará en la adopción de estilos de vida saludables para mejorar
	tu salud, y prevenir problemas alimentarios-nutricionales.','00:15:00');

SELECT * FROM specialty;


-- ==============
------------- doctores
insert into doctor(specialty_id,degree,doctor_name,user_sinch,picture_url,email,is_available,is_enabled)
values(1,'Medicina Interna','David Sánchez','dsanchez','http://res.cloudinary.com/dzthuikyb/image/upload/v1500998377/doctor_03_rqkjdh.jpg',
 'dsanchez@gmail.com','True', 'True');

insert into doctor(specialty_id,degree,doctor_name,user_sinch,picture_url,email,is_available,is_enabled)
values(1,'Medicina Interna','Liz Cornejo','lcornejo','http://res.cloudinary.com/dzthuikyb/image/upload/v1500998377/doctor_03_rqkjdh.jpg',
 'dsanchez@gmail.com','True', 'True');

insert into doctor(specialty_id,degree,doctor_name,user_sinch,picture_url,email,is_available,is_enabled)
values(1,'Medicina Interna','Ana Maria Llerena','anamaria','http://res.cloudinary.com/dzthuikyb/image/upload/v1500998377/doctor_03_rqkjdh.jpg',
 'lcornejo@gmail.com','True', 'True');

 insert into doctor(specialty_id,degree,doctor_name,user_sinch,picture_url,email,is_available,is_enabled)
values(1,'Medicina Interna','Shirley Guerra','sguerra','http://res.cloudinary.com/dzthuikyb/image/upload/v1500998377/doctor_03_rqkjdh.jpg',
 'sguerra@gmail.com','True', 'True');

 insert into doctor(specialty_id,degree,doctor_name,user_sinch,picture_url,email,is_available,is_enabled)
values(1,'Medicina Interna','Julio Montero','jmontero','http://res.cloudinary.com/dzthuikyb/image/upload/v1500998377/doctor_03_rqkjdh.jpg',
 'jmontero@gmail.com','True', 'True');

 insert into doctor(specialty_id,degree,doctor_name,user_sinch,picture_url,email,is_available,is_enabled)
values(1,'Medicina Interna','Renato Vergara','rvergara','http://res.cloudinary.com/dzthuikyb/image/upload/v1500998377/doctor_03_rqkjdh.jpg',
 'rvergara@gmail.com','True', 'True');

----
---
insert into doctor(specialty_id,degree,doctor_name,user_sinch,picture_url,email,is_available,is_enabled)
values(2,'Psiquiatria','Leonid Ramirez','lramirez','http://res.cloudinary.com/dzthuikyb/image/upload/v1500998377/doctor_03_rqkjdh.jpg',
 'lramirez@gmail.com','True', 'True');

insert into doctor(specialty_id,degree,doctor_name,user_sinch,picture_url,email,is_available,is_enabled)
values(2,'Psiquiatria','Jeanfranco Gutierrez','jgutierrez','http://res.cloudinary.com/dzthuikyb/image/upload/v1500998377/doctor_03_rqkjdh.jpg',
 'jgutierrez@gmail.com','True', 'True');

insert into doctor(specialty_id,degree,doctor_name,user_sinch,picture_url,email,is_available,is_enabled)
values(2,'Psiquiatria','Isaac Apple','sapple','http://res.cloudinary.com/dzthuikyb/image/upload/v1500998377/doctor_03_rqkjdh.jpg',
 'sapple@gmail.com','True', 'True');
--
insert into doctor(specialty_id,degree,doctor_name,user_sinch,picture_url,email,is_available,is_enabled)
values(3,'Nutriología Clínica','Alison Gonzales','jgutierrez','http://res.cloudinary.com/dzthuikyb/image/upload/v1500998377/doctor_03_rqkjdh.jpg',
 'jgutierrez@gmail.com','True', 'True');

insert into doctor(specialty_id,degree,doctor_name,user_sinch,picture_url,email,is_available,is_enabled)
values(3,'Nutriología Clínica','Carlos Oliveira','sapple','http://res.cloudinary.com/dzthuikyb/image/upload/v1500998377/doctor_03_rqkjdh.jpg',
 'sapple@gmail.com','True', 'True');

SELECT * FROM doctor;

-- ========
-- pacientes
INSERT INTO patient(name, age, email, password, dni)
VALUES('papa1','40','papa1@gmail.com','12345','55445505');
INSERT INTO patient(name, age, email, password, dni)
VALUES('duivan','16','duinvan@gmail.com','12345','55445505');
INSERT INTO patient(name, age, email, password, dni)
VALUES('jusmar','16','jus@gmail.com','12345','55445505');
INSERT INTO patient(name, age, email, password, dni)
VALUES('leo','30','leo@gmail.com','12345','55445505');

INSERT INTO patient(name, age, email, password, dni)
VALUES('leomar','30','leomar@gmail.com','12345','55445505');
--
INSERT INTO patient(name, age, email, password, dni)
VALUES('papa2','30','papa2@gmail.com','12345','55445505');
--
INSERT INTO patient(name, age, email, password, dni)
VALUES('jasmin','20','jasmin@gmail.com','12345','55445505');

INSERT INTO patient(name, age, email, password, dni)
VALUES('kalesee','20','kalesee@gmail.com','12345','55445505');


SELECT * from patient;
SELECT *
FROM symptom;

delete from patient where patient_id = 1;

select * from patient;



SELECT * from profile;
INSERT INTO profile(parent_profile_id, patient_id)
VALUES(1, 2)
INSERT INTO profile(parent_profile_id, patient_id)
VALUES(1, 3)
INSERT INTO profile(parent_profile_id, patient_id)
VALUES(1, 4)
INSERT INTO profile(parent_profile_id, patient_id)
VALUES(5, 6)
INSERT INTO profile(parent_profile_id, patient_id)
VALUES(5, 7)


select * from patient;
select * from patient ORDER BY patient_id desc;
-- DELETE from patient where patient_id BETWEEN 14 and 27;
select * from profile;
delete from profile where id = 1;

-- lista de padres
select distinct p.name,p.patient_id
from patient p INNER JOIN profile pro on (p.patient_id = pro.parent_profile_id);
-- dj equivalent - > p = Patient.objects.filter(parent_profile__isnull=False).distinct()

-- lista de hijos
select p.name, p.patient_id, p.password
from patient p INNER JOIN profile pro on (p.patient_id = pro.patient_id)
where pro.parent_profile_id in(2);
--
select * from patient;
select * from profile;

--- +++
select * from enterprise;
INSERT INTO enterprise(ruc, business_name, web_page, trade_name, comercial_activity, postal_address)
VALUES ('20100075009',' IBM DEL PERU S A C','http://www.ibm.com','IBM','Consultores Prog. y Sumin. Informatic','Av. Javier Prado Este Nro. 6230');

--
SELECT * from membership;
INSERT INTO membership (membership_type, description)
VALUES ('Estandar','S/.79, un solo pago de S/. 939 ');
INSERT INTO membership (membership_type, description)
VALUES ('Premium','S/.95, un solo pago de S/. 1140 ');

--
SELECT * FROM membership_patient;

--
select * from promotion;
INSERT INTO promotion (promotion_type ) VALUES ('50% descuento');
INSERT INTO promotion (promotion_type ) VALUES ('10% descuento');
INSERT INTO promotion (promotion_type ) VALUES ('20% descuento');

--
SELECT * FROM promotion_enrollment;
INSERT INTO promotion_enrollment (promotion_id, code, is_available, start_date, final_date)
VALUES (1,'D7-2017',TRUE, '2017-08-01','2017-08-31');
INSERT INTO promotion_enrollment (promotion_id, code, is_available, start_date, final_date)
VALUES (2,'D10-2017',TRUE, '2017-10-01','2017-10-31');

--
SELECT * FROM patient_promotion_enrollment;
INSERT INTO patient_promotion_enrollment (patient_id, promotion_enrollment_id )
VALUES ();

-- para ver si un usuario esta en una empresa y tiene una membresia
SELECT * FROM patient;
SELECT * FROM enterprise;
SELECT * FROM enterprise_patient;
SELECT * FROM membership;
SELECT * FROM membership_patient;


select * from patient;

delete from patient where patient_id = 3;