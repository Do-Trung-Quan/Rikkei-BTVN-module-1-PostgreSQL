create schema ex02;
set search_path to ex02;

create table users (
                       user_id serial primary key,
                       email varchar(100),
                       username varchar(50)
);

-- Sinh 100k user để test hiệu năng Hash Index
insert into users (email, username)
select
    'user' || i || '@example.com',
    'username_' || i
from generate_series(1, 100000) as i;

-- Trước khi tạo index
explain analyze
SELECT * FROM Users WHERE email = 'example@example.com';

--Tạo index B-tree trên customer_id
create index idx_users_email on users(email);

--Sau khi tạo index
explain analyze
SELECT * FROM Users WHERE email = 'example@example.com';
