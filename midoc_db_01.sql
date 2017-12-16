  create table patient(
    patient_id            serial not null,
    name                  varchar(100),
    age                   varchar(100),
    symptom               varchar(254),
    email                 varchar(100),
    uuid                  varchar(80),
    created_date          timestamp(3) without time zone DEFAULT NULL,
    created_by				    text,
    last_modified_date    timestamp(3) without time zone DEFAULT NULL,
    last_modified_by		  text,
    constraint pk_patient primary key (patient_id)
  );


  create table doctor(
    id                    serial not null,
    name                  varchar(100),
    user_sinch            varchar(100),
    picture_url           varchar(100),
    email                 varchar(100),
    specialty             varchar(100),       -- foreign key from specialtyoe
    created_date          timestamp(3) without time zone DEFAULT NULL,
    created_by				    text,
    last_modified_date    timestamp(3) without time zone DEFAULT NULL,
    last_modified_by		  text,
    constraint pk_doctor primary key (id)
  );

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



select * from patient;
select * from doctor;
select * from competition;

 --
insert into patient(name,email) values('carlos','cdoliveirar@gmail.com');
insert into doctor(name,surname,email) values('david','rodriguez','david@gmail.com');
insert into competition(patient_id,doctor_id,qualification,recommendation) values(1,1,'3','SI');
insert into competition(patient_id,qualification,recommendation) values(1,'3','SI');
