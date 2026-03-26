create schema ex03;
SET search_path TO ex03;

create table customers (
    customer_id int primary key,
    customer_name varchar(100),
    city varchar(50)
);

create table orders (
    order_id int primary key,
    customer_id int references customers(customer_id),
    order_date date,
    total_price decimal(10, 2)
);

create table order_items (
    item_id int primary key,
    order_id int references orders(order_id),
    product_id int,
    quantity int,
    price decimal(10, 2)
);

insert into customers (customer_id, customer_name, city) values
(1, 'nguyễn văn a', 'hà nội'),
(2, 'trần thị b', 'đà nẵng'),
(3, 'lê văn c', 'hồ chí minh'),
(4, 'phạm thị d', 'hà nội');

insert into orders (order_id, customer_id, order_date, total_price) values
(101, 1, '2024-12-20', 3000),
(102, 2, '2025-01-05', 1500),
(103, 1, '2025-02-10', 2500),
(104, 3, '2025-02-15', 4000),
(105, 4, '2025-03-01', 800);

insert into order_items (item_id, order_id, product_id, quantity, price) values
(1, 101, 1, 2, 1500),
(2, 102, 2, 1, 1500),
(3, 103, 3, 5, 500),
(4, 104, 2, 4, 1000),
(5, 105, 3, 1, 500),
(6, 105, 4, 1, 300);


--1. hiển thị tổng doanh thu và tổng số đơn hàng của mỗi khách hàng: Chỉ hiển thị khách hàng có tổng doanh thu > 2000 .Dùng ALIAS: total_revenue và order_count
select c.customer_name, sum(o.total_price) as total_revenue, count(o.order_id) as order_count from customers c join orders o on c.customer_id = o.customer_id
group by c.customer_name
having sum(o.total_price) > 2000;

--2. hiển thị những khách hàng có doanh thu lớn hơn mức doanh thu trung bình của tất cả khách hàng
select c.customer_name, avg(o.total_price) as avg_total from customers c join orders o on c.customer_id = o.customer_id
group by c.customer_name
having avg(o.total_price) >
       (select avg(o.total_price) from  orders o);

--3. lọc ra thành phố có tổng doanh thu cao nhất
select c.city, sum(o.total_price) as city_total_revenue from customers c join orders o on c.customer_id = o.customer_id
group by c.city
having sum(o.total_price) =
       (select sum(o1.total_price) from customers c1 join orders o1 on c1.customer_id = o1.customer_id
        group by c1.city
        order by sum(o1.total_price) desc
        limit 1);

--4.hiển thị chi tiết: Tên khách hàng, tên thành phố, tổng sản phẩm đã mua, tổng chi tiêu
select c.customer_name, c.city, count(oi.item_id) as item_count, sum(oi.price * oi.quantity) as total_revenue from customers c join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
group by c.customer_name, c.city;