create table products(
    id serial primary key ,
    name varchar(50),
    category varchar(50),
    price decimal(10,2),
    stock int
);

insert into products(name, category, price, stock)
values
('Laptop Dell', 'Electronics', 1500, 5),
('Chuột Logitech', 'Electronics', 25.5, 50),
('Bàn phím Razer', 'Electronics', 120, 20),
('Tủ lạnh LG', 'Home Appliances', 800, 3),
('Máy giặt Samsung', 'Home Appliances', 600, 2);

select * from products;
--1. Thêm sản phẩm mới: 'Điều hòa Panasonic', category 'Home Appliances', giá 400.00, stock 10
insert into products(name, category, price, stock)
values
('Điều hòa Panasonic', 'Home Appliances', 400, 10);

--2. Cập nhật stock của 'Laptop Dell' thành 7
update products
set stock = 7
where name = 'Laptop Dell';

--3. Xóa các sản phẩm có stock bằng 0 (nếu có)
delete from products
where stock = 0;

--4. Liệt kê tất cả sản phẩm theo giá tăng dần
select * from products
order by price;

--5. Liệt kê danh mục duy nhất của các sản phẩm (DISTINCT)
select distinct category from products;

--6. Liệt kê sản phẩm có giá từ 100 đến 1000
select * from products
where price between 100 and 1000;

--7. Liệt kê các sản phẩm có tên chứa từ 'LG' hoặc 'Samsung' (sử dụng LIKE/ILIKE)
select * from products
where name like '%LG%' or name like '%Samsung';

--8. Hiển thị 2 sản phẩm đầu tiên theo giá giảm dần, hoặc lấy sản phẩm thứ 2 đến thứ 3 bằng LIMIT và OFFSET
select * from products
order by price desc
limit 2;

select * from products
order by price desc
limit 2 offset 1;