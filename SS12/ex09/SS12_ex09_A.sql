create schema ex9;
set search_path to ex9;

-- 1. Tạo các bảng theo thiết kế
create table customers (
    customer_id serial primary key,
    name varchar(50) not null,
    email varchar(50)
);

create table products (
    product_id serial primary key,
    name varchar(50) not null,
    price numeric(10,2) not null,
    stock int not null
);

create table orders (
    order_id serial primary key,
    customer_id int references customers(customer_id),
    product_id int references products(product_id),
    quantity int not null,
    total_amount numeric(12,2),
    order_date timestamp default now()
);

-- 2. Insert dữ liệu gốc (Tạo 1 đơn hàng có quantity > 5)
insert into customers(name, email) values ('Do Trung Quan', 'quan@gmail.com');
insert into products(name, price, stock) values ('Bàn phím cơ', 1000.00, 50);

insert into orders(customer_id, product_id, quantity, total_amount)
values (1, 1, 10, 10000.00);

--read committed
begin transaction isolation level read committed;
select count(*) from orders where quantity > 5;

select pg_sleep(10);

select count(*) from orders where quantity > 5;
commit;

--repeatable read
begin transaction isolation level repeatable read ;
select count(*) from orders where quantity > 5;

select pg_sleep(10);

select count(*) from orders where quantity > 5;
commit;

select count(*) from orders where quantity > 5;

