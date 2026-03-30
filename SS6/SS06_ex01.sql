create schema ex01;

set search_path to ex01;

Create table Product (
    id serial primary key,
    name varchar(100),
    category varchar(50),
    price numeric(10,2),
    stock int
);

INSERT INTO Product (name, category, price, stock) VALUES
('iPhone 15 Pro Max 256GB', 'Đồ điện tử', 32990000.00, 50),
('Smart TV Samsung 55 inch 4K', 'Đồ điện tử', 15500000.00, 20),
('Ghế Sofa chữ L bọc nỉ', 'Nội thất', 8500000.00, 10),
('Bàn làm việc gỗ sồi', 'Nội thất', 2200000.00, 30),
('Tai nghe Bluetooth Sony WH-1000XM5', 'Đồ điện tử', 7990000.00, 100);


select * from Product;

select * from Product
order by price desc
limit 3;

select * from Product
where category = 'Điện tử' and price < 10000000;

select * from Product
order by stock;