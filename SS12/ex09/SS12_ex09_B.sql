set search_path to ex9;

begin;
insert into orders(customer_id, product_id, quantity, total_amount)
values (1, 1, 20, 20000.00);
commit;

ROLLBACK;