create schema ex03;
set search_path to ex03;

create table products (
    product_id serial primary key,
    category_id int,
    price numeric(10,2),
    stock_quantity int
);

-- Sinh 100k sản phẩm thuộc 100 danh mục khác nhau
insert into products (category_id, price, stock_quantity)
select
    (random() * 100)::int,
    (random() * 20000000)::numeric(10,2),
    (random() * 500)::int
from generate_series(1, 100000);

create index idx_products_categoryId on products(category_id);
cluster products using idx_products_categoryId;

create index idx_products_price on products(price);

explain analyse
SELECT * FROM Products WHERE category_id = 1 ORDER BY price;