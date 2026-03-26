create table students (
                          student_id serial primary key,
                          full_name varchar(100),
                          major varchar(50)
);

create table courses (
                         course_id serial primary key,
                         course_name varchar(100),
                         credit int
);

create table enrollments (
                             student_id int references students(student_id),
                             course_id int references courses(course_id),
                             score numeric(5,2)
);

insert into students (full_name, major) values
                                            ('Đỗ Trung Quân', 'Công nghệ thông tin'),
                                            ('Nguyễn Thị Linh', 'Khoa học máy tính'),
                                            ('Trần Tuấn Anh', 'An toàn thông tin');

insert into courses (course_name, credit) values
                                              ('Cơ sở dữ liệu', 3),
                                              ('Lập trình Web', 3),
                                              ('Trí tuệ nhân tạo', 3);

insert into enrollments (student_id, course_id, score) values
                                                           (1, 1, 8.5),
                                                           (1, 2, 9.0),
                                                           (2, 1, 9.5),
                                                           (2, 3, 8.0),
                                                           (3, 2, 7.5);


/*
1. ALIAS:
Liệt kê danh sách sinh viên cùng tên môn học và điểm
dùng bí danh bảng ngắn (vd. s, c, e)
và bí danh cột như Tên sinh viên, Môn học, Điểm
*/
select st.full_name as "Tên sinh viên", c.course_name as "Môn học", e.score as "Điểm" from students st join enrollments e on st.student_id = e.student_id
join courses c on e.course_id = c.course_id;

/*
Aggregate Functions:
Tính cho từng sinh viên:
Điểm trung bình
Điểm cao nhất
Điểm thấp nhất
*/
select st.full_name, avg(e.score) as avg_score from students st join enrollments e on st.student_id = e.student_id
group by st.full_name;

select st.full_name, max(e.score) as max_score from students st join enrollments e on st.student_id = e.student_id
group by st.full_name;

select st.full_name, min(e.score) as min_score from students st join enrollments e on st.student_id = e.student_id
group by st.full_name;

/*
GROUP BY / HAVING:
Tìm ngành học (major) có điểm trung bình cao hơn 7.5
*/
select st.major, avg(e.score) as avg_score_of_major from students st join enrollments e on st.student_id = e.student_id
group by st.major
having avg(e.score) > 7.5;

/*
JOIN:
Liệt kê tất cả sinh viên, môn học, số tín chỉ và điểm (JOIN 3 bảng)
*/
select st.full_name, c.course_name, c.credit, e.score from students st join enrollments e on st.student_id = e.student_id
join courses c on e.course_id = c.course_id;

/*
Subquery:
Tìm sinh viên có điểm trung bình cao hơn điểm trung bình toàn trường
Gợi ý: dùng AVG(score) trong subquery
*/
select st.full_name, avg(e.score) as avg_score_of_student from students st join enrollments e on st.student_id = e.student_id
group by st.full_name
having avg(e.score) >
       (select avg(e1.score) from enrollments e1);


