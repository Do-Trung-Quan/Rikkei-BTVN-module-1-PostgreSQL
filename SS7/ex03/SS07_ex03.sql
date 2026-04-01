create schema ex03;
set search_path to ex03;

create table customer (
    customer_id serial primary key,
    full_name varchar(100),
    region varchar(50)
);

create table orders (
    order_id serial primary key,
    customer_id int references customer(customer_id),
    total_amount decimal(10,2),
    order_date date,
    status varchar(20)
);

create table product (
    product_id serial primary key,
    name varchar(100),
    price decimal(10,2),
    category varchar(50)
);

create table order_detail (
    order_id int references orders(order_id),
    product_id int references product(product_id),
    quantity int
);

insert into customer (full_name, region) values
('đỗ trung quân', 'hà nội'),
('trần thị b', 'đà nẵng'),
('lê văn c', 'hồ chí minh'),
('phạm thị d', 'hà nội'),
('nguyễn văn e', 'hải phòng');

insert into product (name, price, category) values
('laptop dell xps 13', 25000000.00, 'điện tử'),
('chuột logitech m90', 150000.00, 'phụ kiện'),
('bàn phím cơ razer', 2200000.00, 'phụ kiện'),
('màn hình lg 24 inch', 3500000.00, 'điện tử');

insert into orders (customer_id, total_amount, order_date, status) values
(1, 25150000.00, '2026-03-01', 'completed'),
(2, 3500000.00, '2026-03-05', 'completed'),
(3, 7000000.00, '2026-03-10', 'completed'),
(4, 2200000.00, '2026-03-15', 'completed'),
(5, 450000.00, '2026-03-20', 'completed');

insert into order_detail (order_id, product_id, quantity) values
(1, 1, 1),
(1, 2, 1),
(2, 4, 1),
(3, 4, 2),
(4, 3, 1),
(5, 2, 3);

create view v_revenue_by_region as
select c.region, sum(o.total_amount) as total_revenue
from customer c
join orders o on c.customer_id = o.customer_id
group by c.region;

select * from v_revenue_by_region
order by total_revenue desc
limit 3;

create view v_revenue_above_avg as
select *
from v_revenue_by_region
where total_revenue > (select avg(total_revenue) from v_revenue_by_region);

select * from v_revenue_above_avg;