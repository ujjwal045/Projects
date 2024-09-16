use project;

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee',
-- 'J.B. Lippincott & Co.')"
INSERT INTO BOOKS
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee','J.B. Lippincott & Co.');


-- Update an Existing Member's Address
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';


-- Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.
select member_name, count(*) from issued_status as I
JOIN members as M
ON I.issued_member_id = M.member_id
group by member_name
having count(*) >1;


-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
CREATE TABLE book_issued_cnt AS 
(
SELECT book_title, count(issued_id) as No_issued from issued_status as i
join books as b
 on i.issued_book_isbn = b.isbn
group by book_title);

select * from book_issued_cnt;

-- Task 7. Retrieve All Books in a Specific Category = 'Classic'
SELECT * FROM books 
WHERE category = "Classic";

-- Task 8: Find Total Rental Income by Category:
SELECT category, sum(rental_price) as Rental_Income FROM books
GROUP BY category;

-- Task 9: List Members Who Registered in the Last 180 Days:
SELECT member_name ,datediff(current_date(),reg_date) as time_interval from members
where datediff(current_date(),reg_date) > 180;

 -- Task 10: List Employees with Their Branch Manager's Name and their branch details:
 SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employees as e2
ON e2.emp_id = b.manager_id;


-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:
create table rental_price_above_7 as
select * from books 
where rental_price >= 7;

-- Task 12: Retrieve the List of Books Not Yet Returned:
select issued_book_name from issued_status 
where issued_id not in(
select i.issued_id from issued_status as i
join return_status as r
on i.issued_id = r.issued_id);

-- Task 13: Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 30-day return period).
--  Display the member's_id, member's name, book title, issue date, and days overdue.



-- Task 15: Branch Performance Report:
-- Create a query that generates a performance report for each branch, showing the number of books issued,
 -- the number of books returned, and the total revenue generated from book rentals.
select b.branch_id,manager_id,sum(rental_price) as total_revenue,count(i.issued_id) as issued, count(r.return_id) as returned
 from issued_status as i
 left join return_status as r
 on i.issued_id = r.issued_id
 join employees as e
 on e.emp_id = i.issued_emp_id
 join branch as b
on b.branch_id = e.branch_id
join books as bk
on bk.isbn = i.issued_book_isbn
group by branch_id,manager_id
order by b.branch_id;

 
 
 
 
 
 
 
 










