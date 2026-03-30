create schema ex03;

set search_path to ex03;

create table customer (
    id serial primary key,
    name varchar(100),
    email varchar(100),
    phone varchar(20),
    points int
);

insert into customer (name, email, phone, points) values
('Nguyễn Văn A', 'nva@gmail.com', '0901111111', 150),
('Trần Thị B', 'ttb@gmail.com', '0902222222', 450),
('Lê Hoàng C', null, '0903333333', 120),
('Phạm Quang D', 'pqd@gmail.com', '0904444444', 300),
('Nguyễn Văn A', 'nva2@gmail.com', '0905555555', 200),
('Đỗ Trung Quân', 'quan@gmail.com', '0906666666', 800),
('Vũ Hải E', 'vhe@gmail.com', '0907777777', 600);

select distinct name
from customer;

select * from customer
where email is null;

select * from customer
order by points desc
limit 3 offset 1;

select * from customer
order by name desc;