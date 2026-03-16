# **[ Khá ] Hệ thống Quản lý Đăng ký Môn học Đại học**

**[Bài tập] Hệ thống Quản lý Đăng ký Môn học Đại học**

## **1. Mục tiêu**

- Nhận biết và xác định các **thực thể, thuộc tính, mối quan hệ** trong hệ thống giáo dục
- Vẽ được **sơ đồ ERD** thể hiện rõ ràng các mối quan hệ **1–n**, **n–n**
- Chuẩn hóa sơ đồ ở mức cơ bản

## **2. Mô tả**

Một trường đại học cần quản lý việc **đăng ký môn học của sinh viên**. Hệ thống lưu trữ thông tin như sau:

- **Sinh viên (Student)**: mã sinh viên, họ tên, ngày sinh, giới tính, email, khoa
- **Môn học (Course)**: mã môn, tên môn, số tín chỉ, khoa phụ trách
- **Giảng viên (Instructor)**: mã giảng viên, họ tên, học vị, email, khoa
- **Lớp học phần (Class_Section)**: mã lớp học phần, học kỳ, năm học, phòng học
- **Đăng ký (Enrollment)**: ghi lại việc sinh viên đăng ký lớp học phần cụ thể

**Yêu cầu:**

1. Xác định các **thực thể** và **thuộc tính chính**
2. Xác định **mối quan hệ** giữa các thực thể, ví dụ:
    1. Giảng viên **dạy** lớp học phần nào
    2. Lớp học phần **thuộc về** môn học nào
    3. Sinh viên **đăng ký** lớp học phần nào
3. Vẽ **sơ đồ ERD** mô tả đầy đủ các mối quan hệ và **ràng buộc (1–n, n–n)**
4. Chỉ rõ **khóa chính**, **khóa ngoại**, và **thuộc tính đa trị** (nếu có)
