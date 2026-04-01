create schema ex01;
set search_path to ex01;

create table book (
    book_id serial primary key,
    title varchar(255),
    author varchar(100),
    genre varchar(50),
    price decimal(10,2),
    description text,
    created_at timestamp default current_timestamp
);

insert into book (title, author, genre, price, description) values
('clean code', 'robert c. martin', 'cong nghe thong tin', 350000.00, 'viet code sach va de bao tri'),
('design patterns', 'gang of four', 'cong nghe thong tin', 400000.00, 'cac mau thiet ke phan mem kinh dien'),
('giao trinh c++', 'nguyen thanh thuy', 'cong nghe thong tin', 120000.00, 'kien thuc co ban ve lap trinh c++'),
('dac nhan tam', 'dale carnegie', 'ky nang song', 85000.00, 'nghe thuat thu phuc long nguoi'),
('nha gia kim', 'paulo coelho', 'tieu thuyet', 75000.00, 'hanh trinh di tim kho bau'),
('toi thay hoa vang tren co xanh', 'nguyen nhat anh', 'truyen dai', 95000.00, 'ky uc tuoi tho tuyet dep'),
('mat biec', 'nguyen nhat anh', 'truyen dai', 110000.00, 'chuyen tinh buon cua ngan va halan'),
('cho toi xin mot ve di tuoi tho', 'nguyen nhat anh', 'truyen dai', 80000.00, 'nhung tro quay pha cua tre con'),
('tuoi tre dang gia bao nhieu', 'rosie nguyen', 'ky nang song', 90000.00, 'bai hoc cho nguoi tre'),
('sapiens luoc su loai nguoi', 'yuval noah harari', 'khoa hoc', 250000.00, 'lich su tien hoa cua loai nguoi'),
('the gioi phang', 'thomas l. friedman', 'kinh te', 180000.00, 'toan cau hoa trong the ky 21'),
('nghi giau lam giau', 'napoleon hill', 'kinh te', 105000.00, 'bi quyet thanh cong va giau co'),
('cha giau cha ngheo', 'robert kiyosaki', 'kinh te', 115000.00, 'bai hoc ve tai chinh ca nhan'),
('su im lang cua bay cuu', 'thomas harris', 'trinh tham', 130000.00, 'tieu thuyet trinh tham kinh dien'),
('sherlock holmes toan tap', 'arthur conan doyle', 'trinh tham', 500000.00, 'nhung vu an cua sherlock holmes'),
('harry potter va hon da phu thuy', 'j.k. rowling', 'gia tuong', 150000.00, 'cuoc phieu luu cua cau be phu thuy'),
('chua te nhung chiec nhan', 'j.r.r. tolkien', 'gia tuong', 300000.00, 'hanh trinh tieu diet chiec nhan quyen luc'),
('muon kiep nhan sinh', 'nguyen phong', 'ton giao', 160000.00, 'cau chuyen ve luat nhan qua'),
('hanh trinh ve phuong dong', 'baird t. spalding', 'ton giao', 140000.00, 'kham pha nhung bi an cua phuong dong'),
('tam ly hoc toi pham', 'stanton e. samenow', 'tam ly hoc', 175000.00, 'nghien cuu ve tam ly ke pham toi');

create index idx_book_author on book(author);
create index idx_book_genre on book(genre);

explain select * from book where author ilike '%Rowling%';
explain select * from book where genre = 'Fantasy';

create index idx_book_genre_btree on book using btree(genre);


create extension if not exists pg_trgm;
create index idx_book_title_gin on book using gin(title gin_trgm_ops);


cluster book using idx_book_genre;
explain analyze select * from book where genre = 'Fantasy';