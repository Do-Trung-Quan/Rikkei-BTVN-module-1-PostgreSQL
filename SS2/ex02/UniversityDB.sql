create database UniversityDB;

create schema university;

set search_path to university;

create table Students (
                          student_id serial primary key,
                          first_name varchar(50) not null,
                          last_name varchar(50) not null,
                          birth_date date,
                          email varchar(255) unique not null
);

create table Courses (
                         course_id serial primary key,
                         course_name varchar(100) not null,
                         credits int
);

create table Enrollments (
                             enrollment_id serial primary key,
                             student_id int references Students(student_id),
                             course_id int references Courses(course_id),
                             enroll_date date
);