create schema ex08;
set search_path to ex08;

create table accounts (
    id serial primary key,
    balance numeric(12,2)
);

insert into accounts (balance) values (1000.00);


-- non-repeatable read
--Session A
begin transaction isolation level read committed ;
select balance from accounts where id = 1;
select pg_sleep(10); --chờ session B can thiệp
select balance from accounts where id = 1;
commit ;

select balance from accounts where id = 1;

-- repeatable read
--Session A
begin transaction isolation level repeatable read;
select balance from accounts where id = 1;
select pg_sleep(10); --chờ session B can thiệp
select balance from accounts where id = 1;
commit ;

select balance from accounts where id = 1;
