create schema ex05;
set search_path to ex05;

create table customers (
    customer_id serial primary key,
    full_name varchar(100),
    email varchar(100) unique,
    city varchar(50)
);

create table products (
    product_id serial primary key,
    product_name varchar(100),
    category text[],
    price numeric(10,2)
);

create table orders (
    order_id serial primary key,
    customer_id int references customers(customer_id),
    product_id int references products(product_id),
    order_date date,
    quantity int
);

insert into customers (full_name, email, city) values
('đỗ trung quân', 'quan@gmail.com', 'hà nội'),
('nguyễn văn a', 'nva@gmail.com', 'đà nẵng'),
('trần thị b', 'ttb@gmail.com', 'hồ chí minh'),
('lê văn c', 'lvc@yahoo.com', 'hà nội'),
('phạm d', 'pd@bing.com', 'hải phòng');

insert into products (product_name, category, price) values
('laptop gaming', array['Electronics', 'Computers'], 1200.00),
('chuột không dây', array['Electronics', 'Accessories'], 50.00),
('bàn phím cơ', array['Electronics', 'Accessories'], 120.00),
('màn hình 24 inch', array['Electronics', 'Monitors'], 600.00),
('tai nghe', array['Audio', 'Accessories'], 800.00);

insert into orders (customer_id, product_id, order_date, quantity) values
(1, 1, '2026-01-01', 1), (1, 2, '2026-01-02', 2),
(2, 4, '2026-01-05', 1), (3, 5, '2026-01-10', 1),
(4, 1, '2026-01-15', 2), (5, 3, '2026-01-20', 5),
(1, 4, '2026-02-01', 1), (2, 2, '2026-02-05', 1),
(3, 1, '2026-02-10', 1), (4, 5, '2026-02-15', 2);

-- 1.
explain analyze select * from customers where email = 'quan@gmail.com';
explain analyze select * from products where category @> array['Electronics'];
explain analyze select * from products where price between 500 and 1000;

-- 2.
create index idx_customers_email on customers using btree(email);
create index idx_customers_city on customers using hash(city);
create index idx_products_category on products using gin(category);
create extension if not exists btree_gist;
create index idx_products_price on products using gist(price);

-- 3.
explain analyze select * from customers where email = 'quan@gmail.com';
explain analyze select * from products where category @> array['Electronics'];
explain analyze select * from products where price between 500 and 1000;

-- 4.
create index idx_orders_date on orders(order_date);
cluster orders using idx_orders_date;

-- 5.
create view v_top_customers as
select c.full_name, sum(o.quantity) as total_items_bought
from customers c
join orders o on c.customer_id = o.customer_id
group by c.full_name
order by total_items_bought desc
limit 3;

create view v_product_revenue as
select p.product_name, sum(p.price * o.quantity) as total_revenue
from products p
join orders o on p.product_id = o.product_id
group by p.product_name;

-- 6.
create view v_customer_city as
select customer_id, full_name, city
from customers
with check option;

update v_customer_city
set city = 'nha trang'
where customer_id = 1;

select * from customers where customer_id = 1;