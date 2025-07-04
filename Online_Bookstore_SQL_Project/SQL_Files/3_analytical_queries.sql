-- Analytical SQL Queries
-- Project: Online Bookstore Database
-- This file includes 30 queries using joins, aggregation,
-- subqueries, CTEs, and window functions to extract insights.

-- 1. Retrieve all books with price greater than 1000
SELECT * FROM Books WHERE Price > 1000;

-- 2. Find all customers who live in Karachi
SELECT * FROM Customers WHERE City = 'Karachi';

-- 3. List all orders placed after 2024-01-01
SELECT * FROM Orders
WHERE Order_Date > '2024-01-01'
ORDER BY Order_Date;

-- 4. Get names of books that are out of stock
SELECT Book_ID, Title, Stock FROM Books WHERE Stock = 0;

-- 5. Count how many books are available in each genre
SELECT Genre, COUNT(Book_ID)
FROM Books
GROUP BY Genre;

-- 6. Find the total number of orders per customer
SELECT Customer_ID, COUNT(Order_ID)
FROM Orders
GROUP BY Customer_ID
ORDER BY COUNT(Order_ID) DESC;

-- 7. Show top 5 most expensive books
SELECT * FROM Books
ORDER BY Price DESC
LIMIT 5;

-- 8. List customers who have not placed any orders
SELECT Customer_ID, Name, Country
FROM Customers
WHERE Customer_ID NOT IN (
    SELECT Customer_ID FROM Orders
);

-- 9. Get total sales amount for each book
SELECT Book_ID, SUM(Total_Amount)
FROM Orders
GROUP BY Book_ID;

-- 10. Show all orders with customer name and book title
SELECT O.*, C.Name, B.Title
FROM Orders O
JOIN Customers C ON C.Customer_ID = O.Customer_ID
JOIN Books B ON B.Book_ID = O.Book_ID;

-- 11. Find customers who ordered more than 3 copies in any order
SELECT C.Customer_ID, C.Name, C.Phone, C.Country, O.Quantity AS Books_Ordered
FROM Customers C
JOIN Orders O ON C.Customer_ID = O.Customer_ID
WHERE O.Quantity > 3;

-- 12. Display average book price by genre
SELECT Genre, AVG(Price) AS Average_Price
FROM Books
GROUP BY Genre;

-- 13. Find most recent order date for each customer
SELECT Customer_ID, MAX(Order_Date)
FROM Orders
GROUP BY Customer_ID
ORDER BY Customer_ID;

-- 14. Show books with number of times each was ordered
SELECT B.Book_ID, B.Title, COUNT(O.Order_ID) AS Number_of_Order
FROM Books B
JOIN Orders O ON B.Book_ID = O.Book_ID
GROUP BY B.Book_ID, B.Title;

-- 15. Display customers who ordered books in the 'Science Fiction' genre
SELECT O.Book_ID, C.*, B.Genre, O.Order_ID
FROM Orders O
JOIN Customers C ON C.Customer_ID = O.Customer_ID
JOIN Books B ON B.Book_ID = O.Book_ID
WHERE B.Genre = 'Science Fiction';

-- 16. Find books with 'Python' in the title
SELECT Title FROM Books
WHERE Title ILIKE '%Python%';

-- 17. Calculate total revenue from all orders
SELECT SUM(Total_Amount) AS Total_Revenue FROM Orders;

-- 18. List all books published before the year 2000
SELECT * FROM Books WHERE Published_Year < 2000;

-- 19. Show customer name, email, and total amount spent
SELECT C.Customer_ID, C.Name, C.Email, SUM(O.Total_Amount) AS Total_Spent
FROM Orders O
JOIN Customers C ON C.Customer_ID = O.Customer_ID
GROUP BY C.Customer_ID, C.Name, C.Email
ORDER BY Total_Spent DESC;

-- 20. Find all books that have never been ordered
SELECT Book_ID, Title
FROM Books
WHERE Book_ID NOT IN (
    SELECT Book_ID FROM Orders
);

-- 21. Create a view for books with price > 500 and stock > 5
CREATE VIEW HighValueBooks AS
SELECT * FROM Books
WHERE Price > 500 AND Stock > 5;

-- 22. Simulate price increase of all books by 10%
SELECT *, Price + Price * 0.1 AS New_Price
FROM Books;

-- 23. Delete all orders where quantity is 0
DELETE FROM Orders
WHERE Quantity = 0;

-- 24. Use CTE to get customers and number of books ordered
WITH CustomerOrders AS (
    SELECT C.Customer_ID, C.Name, SUM(O.Quantity) AS Total_Books
    FROM Customers C
    JOIN Orders O ON C.Customer_ID = O.Customer_ID
    GROUP BY C.Customer_ID, C.Name
)
SELECT * FROM CustomerOrders;

-- 25. Rank customers based on total amount spent
SELECT Customer_ID, Total_Spent,
       RANK() OVER (ORDER BY Total_Spent DESC) AS Spending_Rank
FROM (
    SELECT Customer_ID, SUM(Total_Amount) AS Total_Spent
    FROM Orders
    GROUP BY Customer_ID
) AS Ranked;

-- 26. Calculate running total of revenue ordered by order ID
SELECT Order_ID,
       SUM(Total_Amount) OVER (ORDER BY Order_ID) AS Running_Total
FROM Orders;

-- 27. Get the book with highest price in each genre
SELECT Title, Genre, Price
FROM Books
WHERE (Genre, Price) IN (
    SELECT Genre, MAX(Price)
    FROM Books
    GROUP BY Genre
);

-- 28. Show duplicate customer emails
SELECT Email, COUNT(*)
FROM Customers
GROUP BY Email
HAVING COUNT(*) > 1;

-- 29. Create temporary table for orders above 5000
CREATE TEMP TABLE HighValueOrders AS
SELECT * FROM Orders
WHERE Total_Amount > 5000;

SELECT * FROM HighValueOrders;

-- 30. Use CASE to label books as 'Expensive' or 'Affordable'
SELECT *, 
       CASE 
           WHEN Price > 1000 THEN 'Expensive'
           ELSE 'Affordable'
       END AS Price_Label
FROM Books;
