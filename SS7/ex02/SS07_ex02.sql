create schema ex02;
set search_path to ex02;

create table customer (
    customer_id serial primary key,
    full_name varchar(100),
    email varchar(100),
    phone varchar(15)
);

create table orders (
    order_id serial primary key,
    customer_id int references customer(customer_id),
    total_amount decimal(10,2),
    order_date date
);

insert into customer (full_name, email, phone) values
('đỗ trung quân', 'quan.dt@gmail.com', '0901234567'),
('nguyễn văn a', 'nva@gmail.com', '0912345678'),
('trần thị b', 'ttb@gmail.com', '0923456789'),
('lê hoàng c', 'lhc@gmail.com', '0934567890');

insert into orders (customer_id, total_amount, order_date) values
(1, 1500000.00, '2026-03-10'),
(1, 350000.00, '2026-03-15'),
(2, 2500000.00, '2026-03-20'),
(3, 800000.00, '2026-04-01'),
(4, 1200000.00, '2026-04-01');

-- 1. tạo view v_order_summary
create view v_order_summary as
select c.full_name, o.total_amount, o.order_date
from customer c
join orders o on c.customer_id = o.customer_id;

-- 2. xem dữ liệu từ view vừa tạo
select * from v_order_summary;

-- 3. tạo view lấy đơn hàng >= 1 triệu
create view v_high_value_orders as
select order_id, customer_id, order_date, total_amount
from orders
where total_amount >= 1000000;

select * from v_high_value_orders;

-- cập nhật 1 bản ghi thông qua view (chỉ thực hiện được khi view truy vấn từ 1 bảng gốc duy nhất)
update v_high_value_orders
set total_amount = 1500000
where order_id = 1;

-- 4. tạo view thống kê doanh thu theo tháng
create view v_monthly_sales as
select
    extract(year from order_date) as year,
    extract(month from order_date) as month,
    sum(total_amount) as total_revenue
from orders
group by extract(year from order_date), extract(month from order_date);

select * from v_monthly_sales;
-- 5. xóa view
drop view v_order_summary;