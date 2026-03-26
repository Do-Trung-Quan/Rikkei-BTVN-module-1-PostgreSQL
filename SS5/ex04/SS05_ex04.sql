create schema ex03;
SET search_path TO ex03;

create table customers (
    customer_id serial primary key,
    customer_name varchar(100),
    city varchar(50)
);

create table orders (
    order_id serial primary key,
    customer_id int references customers(customer_id),
    order_date date,
    total_amount numeric(10,2)
);

create table order_items (
    item_id serial primary key,
    order_id int references orders(order_id),
    product_name varchar(100),
    quantity int,
    price numeric(10,2)
);

insert into customers (customer_name, city) values
('nguyễn văn a', 'hà nội'),
('trần thị b', 'đà nẵng'),
('phạm minh c', 'tp. hồ chí minh');

insert into orders (customer_id, order_date, total_amount) values
(1, '2026-03-01', 1500000.00),
(1, '2026-03-15', 300000.00),
(2, '2026-03-10', 2500000.00),
(3, '2026-03-20', 500000.00);

insert into order_items (order_id, product_name, quantity, price) values
(1, 'tai nghe không dây', 1, 1500000.00),
(2, 'chuột máy tính', 1, 300000.00),
(3, 'bàn phím cơ', 1, 2000000.00),
(3, 'lót chuột gaming', 1, 500000.00),
(4, 'cáp sạc nhanh', 2, 250000.00);

--1
select c.customer_name as "Tên khách", o.order_date as "Ngày đặt hàng", o.total_amount as "Tổng tiền" from customers c join orders o on c.customer_id = o.customer_id;

--2
select sum(o.total_amount) as sum_total, avg(total_amount) as avg_total, max(total_amount) as max_total, min(total_amount) as min_total, count(o.order_id) as num_of_order from orders o;

--3.
select c.city, sum(o.total_amount) as sum_total from customers c join orders o on c.customer_id = o.customer_id
group by c.city
having sum(o.total_amount) > 1000000;

--4
select oi.product_name, c.customer_name, o.order_date, oi.quantity, oi.price from order_items oi join orders o on oi.order_id = o.order_id
join customers c on o.customer_id = c.customer_id;

--5
select c.customer_name, sum(o.total_amount) as sum_total from customers c join orders o on c.customer_id = o.customer_id
group by c.customer_name
having sum(o.total_amount) = (
    select sum(o.total_amount) from orders o
    group by o.customer_id
    order by sum(o.total_amount) desc
    limit 1
    );
