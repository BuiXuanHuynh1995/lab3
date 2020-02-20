/*1. Tạo cơ sở dữ liệu có tên: <Họ tên học viên>_<Tên máy>*/
create database lab03;

/* Tạo 4 bảng theo mô tả:*/
create table lab03.class(
class_id int not null primary key auto_increment,
class_name nvarchar(255) not null,
start_date datetime not null,
sstatus bit
);

create table lab03.student(
student_id int not null primary key,
student_name nvarchar(30) not null,
address nvarchar(50),
phone varchar(20),
sstatus bit,
class_id int not null
);

create table lab03.subject(
subject_id int not null primary key auto_increment,
subject_name nvarchar(30) not null,
credit tinyint not null default 1 check(credit>=1),
sstatus bit default 1
);

create table lab03.mark(
mark_id int not null primary key auto_increment,
subject_id int not null,
student_id int not null,
unique(subject_id,student_id),
mark float default 0 check(mark between 0 and 100),
exam_times tinyint default 1
);

/*3 Sử dụng câu lệnh sử đổi bảng để thêm các ràng buộc vào các bảng theo mô tả*/

/*a Thêm ràng buộc khóa ngoại trên cột ClassID của  bảng Student, tham chiếu đến cột ClassID trên bảng Class*/
alter table lab03.student
add foreign key(class_id) references lab03.class(class_id);

/*b Thêm ràng buộc cho cột StartDate của  bảng Class là ngày hiện hành.*/
alter table lab03.class
add check(start_date<=current_date());

/*c Thêm ràng buộc mặc định cho cột Status của bảng Student là 1.*/
alter table lab03.student
alter column sstatus set default 1;

/*dThêm ràng buộc khóa ngoại cho bảng Mark trên cột:
SubID trên bảng Mark tham chiếu đến cột SubID trên bảng Subject
StudentID tren bảng Mark tham chiếu đến cột StudentID của bảng Student.*/
alter table lab03.mark
add foreign key(subject_id) references lab03.subject(subject_id),
add foreign key(student_id) references lab03.student(student_id);

/*4 Thêm dữ liệu vào các bảng.*/
insert into lab03.class(class_id,class_name,start_date,sstatus) values
(1,'A1','2008-12-20',1),
(2,'A2','2008-12-22',1),
(3,'B3',current_date(),0);

insert into lab03.student(student_id,student_name,address,phone,sstatus,class_id)values
(1,'Hung','Ha noi','0912113113',1,1),
(2,'Hoa','Hai phong','',1,1),
(3,'Manh','HCM','0123123123',0,2);

insert into lab03.subject(subject_id,subject_name,credit,sstatus)values
(1,'CF',5,1),
(2,'C',6,1),
(3,'HDJ',5,1),
(4,'RDBMS',10,1);

insert into lab03.mark(mark_id,subject_id,student_id,mark,exam_times)values
(1,1,1,8,1),
(2,1,2,10,2),
(3,2,1,12,1);

/*5*/
/*a Thay đổi mã lớp(ClassID) của sinh viên có tên ‘Hung’ là 2.*/
update lab03.student
set class_id=2
where student_name='Hung';

/*b Cập nhật cột phone trên bảng sinh viên là ‘No phone’ cho những sinh viên chưa có số điện thoại.*/
update lab03.student
set phone ='No phone'
where phone ='' or phone =null;

/*c Nếu trạng thái của lớp (Stutas) là 0 thì thêm từ ‘New’ vào trước tên lớp.
(Chú ý: phải sử dụng phương thức write).*/

/*update lab03.class
set `class_name` .write=('new',0,0)
where sstatus=0;*/

update lab03.class
set class_name=concat('new ',class_name)
where sstatus=0;

select* from lab03.class;

/*d Nếu trạng thái của status trên bảng Class là 1 và tên lớp bắt đầu là ‘New’ thì thay thế ‘New’ bằng ‘old’.
--(Chú ý: phải sử dụng phương thức write)*/
update lab03.class
set class_name= replace(class_name,'new','old ')
where sstatus=1 and class_name like 'new%';

/*e. Nếu lớp học chưa có sinh viên thì thay thế trạng thái là 0 (status=0).*/
update lab03.class
set sstatus=0
where class_id not in (select distinct class_id from lab03.student);

/*f Cập nhật trạng thái của lớp học (bảng subject) là 0 nếu môn học đó chưa có sinh viên dự thi.*/
update lab03.subject
set sstatus=0
where subject_id not in (select distinct subject_id from lab03.mark);

/*6 Hiện thị thông tin.*/
/*a Hiển thị tất cả các sinh viên có tên bắt đầu bảng ký tự ‘h’.*/
select * from lab03.student
where student_name like 'h%';

/*b Hiển thị các thông tin lớp học có thời gian bắt đầu vào tháng 12.*/
select* from lab03.class
where month(start_date)=12;

/*c Hiển thị giá trị lớn nhất của credit trong bảng subject.*/
select max(credit) from lab03.subject;

/*d Hiển thị tất cả các thông tin môn học (bảng subject) có credit lớn nhất.*/
select * from lab03.subject
where credit=(select max(credit) from lab03.subject);

/*e * Hiển thị tất cả các thông tin môn học có credit trong khoảng từ 3-5.*/
select * from lab03.subject
where credit >=3 and credit<=5;

/*f Hiển thị các thông tin bao gồm: classid, className, studentname, Address từ hai bảng Class, student*/
select class.class_id,class_name,student_name,address
from lab03.class join lab03.student
on class.class_id=student.class_id;

/* g Hiển thị các thông tin môn học chưa có sinh viên dự thi.*/
select * from lab03.subject
where subject_id not in(select distinct subject_id from lab03.mark);

/*h Hiển thị các thông tin môn học có điểm thi lớn nhất*/
select subject.* from lab03.subject join lab03.mark
on subject.subject_id=mark.subject_id
where mark = (select max(mark) from lab03.mark);

/*i Hiển thị các thông tin sinh viên và điểm trung bình tương ứng.*/
select student.*,avg(Mark)
from lab03.student join lab03.mark
on student.student_id=mark.student_id
group by(student.student_id);

/*k Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên, xếp hạng theo thứ tự điểm giảm dần (gợi ý: sử dụng hàm rank)*/
select student.*,avg(mark),rank() over (order by avg(mark) desc) as rank_student
from lab03.student join lab03.mark
on student.student_id=mark.student_id
group by(student.student_id);

/*n Hiển thị các thông tin: StudentName, SubName, Mark. Dữ liệu sắp xếp theo điểm thi (mark) giảm dần. nếu trùng sắp theo tên tăng dần.*/
select student_name,subject_name,mark
from lab03.student join lab03.mark
on student.student_id = mark.student_id join lab03.subject
on subject.subject_id=mark.subject_id
order by mark desc, student_name asc;

/*7 Xóa dữ liệu.*/
/*a Xóa tất cả các lớp có trạng thái là 0.*/
delete from lab03.class
where sstatus=0;

select* from lab03.class;

/*b Xóa tất cả các môn học chưa có sinh viên dự thi.*/
delete from lab03.subject
where subject_id not in(select distinct subject_id from lab03.mark);

select* from lab03.subject;

/*8 Thay đổi.*/
/*a Xóa bỏ cột ExamTimes trên bảng Mark.*/
alter table lab03.mark
drop column exam_times;

/*b Sửa đổi cột status trên bảng class thành tên ClassStatus.*/
alter table lab03.class
change column sstatus ClassStatus bit;

/*c Đổi tên bảng Mark thành SubjectTest.*/
alter table lab03.mark
rename to SubjectTest;

/*d Chuyển cơ sở dữ liệu hiện hành sang cơ sở dữ liệu Master.*/
use master;

/*e Xóa cơ sở dữ liệu có tên: <Họ tên học viên>_<Tên máy>*/
drop database lab03;




