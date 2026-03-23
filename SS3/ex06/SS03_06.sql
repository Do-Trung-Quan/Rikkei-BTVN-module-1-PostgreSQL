create database libraryDB;
create schema library;

create table library.Books(
    book_id serial primary key,
    title varchar(100),
    author varchar(50),
    published_year int,
    available boolean default (true)
);

create table library.Members(
    member_id serial primary key,
    name varchar(100),
    email varchar(50) unique,
    join_date date default (current_date)
);