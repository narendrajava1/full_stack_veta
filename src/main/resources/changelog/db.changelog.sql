--liquibase formatted sql
--changeset Narendra Kumar Kolli:1
create table department (
        id bigint not null auto_increment,
        description varchar(255),
        name varchar(255),
        primary key (id)
    ) engine=InnoDB;

--changeset Narendra Kumar Kolli:2
create table employee (
        dept_id bigint,
        id bigint not null auto_increment,
        address varchar(255),
        email varchar(255),
        name varchar(255),
        primary key (id)
    ) engine=InnoDB;

--changeset Narendra Kumar Kolli:3
alter table employee
       add constraint FKaqchbcb8i6nvtl9g6c72yba0p
       foreign key (dept_id)
       references department (id);

--changeset Narendra Kumar Kolli:4
create unique index unique_email on employee (email);

--changeset Narendra Kumar Kolli:5
create index idx_department_name on department (name);

--changeset Narendra Kumar Kolli:6
create index idx_employee_email_name on employee (name,email);

--changeset Narendra Kumar Kolli:7
drop view if exists employee_view;
create view employee_view as select emp.id as id, emp.address as address,emp.email as email, emp.name as name,dept.name as deptName,dept.description as description from employee as emp inner join department dept on emp.dept_id=dept.id;




