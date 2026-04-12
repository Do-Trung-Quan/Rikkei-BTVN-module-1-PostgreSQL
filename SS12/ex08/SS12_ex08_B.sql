set search_path to ex08;

--Session B
begin;
update accounts set balance = 100 where id = 1;
commit;