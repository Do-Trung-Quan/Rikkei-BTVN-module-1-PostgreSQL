create schema ex01;
set search_path to ex01;

create table orders (
    order_id serial primary key,
    customer_id int,
    order_date date,
    total_amount numeric(10,2)
);

-- Sinh 100k dòng dữ liệu ngẫu nhiên để test hiệu năng
insert into orders (customer_id, order_date, total_amount)
select
    (random() * 5000)::int, -- giả sử có 5000 khách hàng
    current_date - (random() * 365 || ' days')::interval,
    (random() * 10000)::numeric(10,2)
from generate_series(1, 100000);

-- Trước khi tạo index
explain analyze
select * from orders where customer_id = 1;

--Tạo index B-tree trên customer_id
create index idx_order_customerId on orders(customer_id);

--Sau khi tạo index
explain analyze
select * from orders where customer_id = 1;
