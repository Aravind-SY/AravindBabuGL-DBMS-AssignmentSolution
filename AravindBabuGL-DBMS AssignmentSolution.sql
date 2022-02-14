use ecommerce;

/*#Q1: 1)	You are required to create tables for supplier,customer,category,product,productDetails,order,rating to store the data for the E-commerce with the schema definition given below.*/
create table if not exists Supplier
(SUPP_ID int primary key auto_increment, SUPP_NAME varchar(25) not null, SUPP_CITY varchar(25) not null, SUPP_PHONE bigint not null);

create table if not exists Customer
(CUS_ID int primary key auto_increment,CUS_NAME varchar(25) not null,CUS_PHONE bigint not null, CUS_CITY varchar(25) not null,CUS_GENDER varchar(1) not null);

create table if not exists Category
(CAT_ID int primary key auto_increment,CAT_NAME varchar(25) not null);

create table if not exists Product
(PRO_ID int primary key auto_increment,PRO_NAME varchar(25) not null,PRO_DESC varchar(25) not null, CAT_ID int not null);

create table if not exists ProductDetails
(PROD_ID int primary key auto_increment,PRO_ID int not null,SUPP_ID int not null,PRICE int not null);

create table if not exists Orders
(ORD_ID int primary key auto_increment ,ORD_AMOUNT int not null,ORD_DATE date,CUS_ID int not null,PROD_ID int not null, foreign key (CUS_ID) references Customer(CUS_ID), foreign key (PROD_ID) references Productdetails(PROD_ID));

create table if not exists Rating
(RAT_ID int primary key auto_increment,CUS_ID int not null,SUPP_ID int not null,RAT_RATSTARS int not null, foreign key (CUS_ID) references Customer(CUS_ID), foreign key (SUPP_ID) references Supplier(SUPP_ID));


	/* Insert values into supplier values */
insert into Supplier (SUPP_NAME,SUPP_CITY,SUPP_PHONE) values("Rajesh Retails","Delhi",'1234567890'),
("Appario Ltd","Mumbai",'2589631470'),
("Knome products","Banglore",'9785462315'),
("Bansal Retails","Kochi",'8975463285'),
("Mittal Ltd","Lucknow",'7898456532');

	/* Insert values into customer values */
insert into Customer (CUS_NAME,CUS_PHONE,CUS_CITY,CUS_GENDER) values("AAKASH", '9999999999', "DELHI", 'M'),
("AMAN", '9785463215', "NOIDA", 'M'),
("NEHA", '9999999999', "MUMBAI", 'F'),
("MEGHA", '9994562399', "KOLKATA", 'F'),
("PULKIT", '7895999999', "LUCKNOW", 'M');

/* Insert values into category values */
	insert into Category(CAT_NAME) values("BOOKS"),("GAMES"),("GROCERIES"),("ELECTRONICS"),("CLOTHES");
    
/* Insert values into Product values */
insert into Product (PRO_NAME,PRO_DESC,CAT_ID) values ("GTA V", "DFJDJFDJFDJFDJFJF", 2),("TSHIRT", "DFDFJDFJDKFD", 5),("ROG LAPTOP", "DFNTTNTNTERND", 4),("OATS", "REURENTBTOTH", 3),("HARRY POTTER", "NBEMCTHTJTH", 1);

/* Insert values into Prodcut Details values */
insert into ProductDetails (PRO_ID,SUPP_ID,PRICE) values (1, 2, 1500),(3, 5, 30000),(5, 1, 3000),(2, 3, 2500),(4, 1, 1000);

/* Insert values into orders values */
insert into Orders (ORD_ID,ORD_AMOUNT,ORD_DATE,CUS_ID,PROD_ID) values (20, 1500, "2021-10-12", 3, 5),(25, 30500, "2021-09-16", 5, 2),(26, 2000, "2021-10-05", 1, 1),(30, 3500, "2021-08-16", 4, 3),(50, 2000, "2021-10-06", 2, 1);

/* Insert values into rating values */
insert into rating (CUS_ID,SUPP_ID,RAT_RATSTARS) values (2, 2, 4),(3,4,3),(5,1,5),(1,3,2),(4,5,4);

/* #Q3  Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000. */
    
select c.CUS_GENDER as gender, count(c.CUS_GENDER) as count
from Customer c, Orders o 
where c.CUS_ID = O.CUS_ID
and o.ORD_AMOUNT>=3000
group by c.CUS_GENDER;

/* #Q4 Display all the orders along with the product name ordered by a customer having #Customer_Id=2*/

select a.*,c.PRO_NAME from Orders a,ProductDetails b, Product c
where a.PROD_ID = b.PRO_ID
and c.Pro_id = b.Pro_id
and a.Cus_id=2 ;

/* #Q5 Display the Supplier details who can supply more than one product. */

select s.* from Supplier s, Productdetails p
where s.SUPP_ID = p.SUPP_ID
having count(p.SUPP_ID)>1;

/* #Q6 Find the category of the product whose order amount is minimum.*/

select c.*
from orders o inner join Productdetails pd
on pd.PRO_ID = o.PROD_ID 
inner join Product p
on p.PRO_ID = pd.PRO_ID 
inner join category c
on c.CAT_ID = p.CAT_ID
having min(o.ORD_AMOUNT);

/* #Q7 Display the Id and Name of the Product ordered after “2021-10-05”.*/

select p.PRO_ID, p.PRO_NAME
from Orders o 
inner join Productdetails pd
on pd.PRO_ID = o.PROD_ID
inner join Product p
on p.PRO_ID = pd.PRO_ID
where o.ORD_DATE>'2021-10-05';

/* #Q8 Display customer name and gender whose names start or end with character 'A'*/

select c.CUS_NAME, c.CUS_GENDER
from customer c 
where CUS_NAME like 'A%' or CUS_NAME like '%A';

/* #Q9 Create a stored procedure to display the Rating for a Supplier if any along with the Verdict on that rating if any like if rating >4 then “Genuine Supplier” if rating >2 “Average Supplier” else “Supplier should not be considered”.*/

delimiter &&
CREATE PROCEDURE ratingverdict()
BEGIN
select rating.rat_ratstars, supplier.supp_name, 
case when  rating.rat_ratstars > 4 then 'Genuine Supplier'
when rating.rat_ratstars > 2 then 'Average Supplier'
else 'Supplier should not be considered'
end as verdict from rating, supplier  where rating.supp_id = supplier.supp_id;
END && ;
delimiter ;
	
call ratingverdict();
