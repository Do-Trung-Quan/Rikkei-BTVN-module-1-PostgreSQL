create schema ex09;

set search_path to ex09;

create table product (
    id serial primary key,
    name varchar(100),
    category varchar(50),
    price numeric(10,2)
);

create table orderdetail (
    id serial primary key,
    order_id int,
    product_id int,
    quantity int,

    foreign key (product_id) references product(id)
);

insert into product (name, category, price) values
('laptop dell xps 15', 'laptop', 30000000.00),
('chuột logitech g102', 'phụ kiện', 400000.00),
('bàn phím cơ akko', 'phụ kiện', 1500000.00),
('màn hình lg 24 inch', 'màn hình', 3200000.00),
('tai nghe sony wh-1000xm5', 'phụ kiện', 7500000.00);

insert into orderdetail (order_id, product_id, quantity) values
(101, 1, 1),
(101, 2, 2),
(102, 3, 1),
(103, 4, 2),
(103, 5, 1),
(104, 1, 1),
(104, 3, 1),
(105, 2, 5),
(106, 5, 2),
(107, 4, 1);


/*
1. Tính tổng doanh thu từng sản phẩm, hiển thị product_name, total_sales (SUM(price * quantity))
2. Tính doanh thu trung bình theo từng loại sản phẩm (GROUP BY category)
3. Chỉ hiển thị các loại sản phẩm có doanh thu trung bình > 20 triệu (HAVING)
4. Hiển thị tên sản phẩm có doanh thu cao hơn doanh thu trung bình toàn bộ sản phẩm (dùng Subquery)
5. Liệt kê toàn bộ sản phẩm và số lượng bán được (nếu có) – kể cả sản phẩm chưa có đơn hàng (LEFT JOIN)
*/

select p.name, Sum(p.price*o.quantity) as total_sales from product p
    join orderdetail o on p.id = o.product_id
group by p.name;

select p.category, round(avg(p.price*o.quantity),2) as avg_sales from product p join orderdetail o on p.id = o.product_id
group by p.category;

select p.name, avg(p.price*o.quantity) as avg_sales from product p join orderdetail o on p.id = o.product_id
group by p.name
having avg(p.price*o.quantity) > 20000000;

select p.name, sum(p.price*o.quantity) as total_sales from product p join orderdetail o on p.id = o.product_id
group by p.name
having sum(p.price*o.quantity) >
       (select avg(p1.price * o1.quantity) from product p1 join orderdetail o1 on p1.id = o1.product_id);

select p.name, o.quantity from product p left join orderdetail o on p.id = o.product_id;
