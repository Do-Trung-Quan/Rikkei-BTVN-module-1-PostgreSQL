create table Students(
    id serial primary key ,
    name varchar(50),
    age int,
    major varchar(50),
    gpa decimal(3,2)
);

insert into Students(name, age, major, gpa)
values
('An', 20, 'CNTT', 3.5),
('Bình', 21, 'Toán', 3.2),
('Cường', 22, 'CNTT', 3.8),
('Dương', 20, 'Vật lý', 3.0),
('Em', 21, 'CNTT', 2.9);


-- Bài làm
-- 1. Thêm sinh viên mới: "Hùng", 23 tuổi, chuyên ngành "Hóa học", GPA 3.4
insert into Students(name, age, major, gpa)
values
('Hùng', 23, 'Hóa học', 3.4);

-- 2. Cập nhật GPA của sinh viên "Bình" thành 3.6
update Students
set gpa = 3.6
where name = 'Bình';

-- 3. Xóa sinh viên có GPA thấp hơn 3.0
delete from Students
where gpa < 3.0;

--4. Liệt kê tất cả sinh viên, chỉ hiển thị tên và chuyên ngành, sắp xếp theo GPA giảm dần
select name, major from Students
order by gpa desc;

--5. Liệt kê tên sinh viên duy nhất có chuyên ngành "CNTT"
select distinct name from Students
where major = 'CNTT';

--6. Liệt kê sinh viên có GPA từ 3.0 đến 3.6
select * from Students
where gpa between 3.0 and 3.6;

--7. Liệt kê sinh viên có tên bắt đầu bằng chữ 'C' (sử dụng LIKE/ILIKE)
select * from Students
where name like 'C%';

--8. Hiển thị 3 sinh viên đầu tiên theo thứ tự tên tăng dần, hoặc lấy từ sinh viên thứ 2 đến thứ 4 bằng LIMIT và OFFSET
select * from Students
order by name
limit 3;

select * from Students
order by name
limit 3 offset 1;
