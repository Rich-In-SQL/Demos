CREATE DATABASE DemoShop;

USE DemoShop;

CREATE TABLE
    Users (
        userId INT IDENTITY (1, 1) NOT NULL,
        forename VARCHAR(50),
        surname VARCHAR(50),
        email VARCHAR(50),
        country VARCHAR(3),
        isPremium BIT DEFAULT 0,
        premiumStart DATETIME,
        premiumEnd DATETIME
    );

-- The primary key for the user
ALTER TABLE Users ADD CONSTRAINT PK_Users_Id PRIMARY KEY (userId);

INSERT INTO
    Users (forename, surname, email, country)
VALUES
    (
        'karen',
        'rutherford',
        'karen.rutherford90@hotmail.com',
        'USA'
    ),
    (
        'casper',
        'goodwin',
        'casper.goodwin81@gmail.com',
        'UK'
    ),
    (
        'mariam', 
        'jones', 
        'mariam14@yahoo.com', 
        'USA'
    ),
    (
        'eden',
        'breitenberg',
        'eden_breitenberg@hotmail.com',
        'IRE'
    ),
    (
        'malachi', 
        'morris', 
        'malachi85@yahoo.com', 
        'BEL'
    );

CREATE TABLE
    Product (
        productId INT IDENTITY (1, 1) NOT NULL,
        description VARCHAR(50),
        color VARCHAR(10),
        cost DECIMAL(19, 4)
    );

--This is the primary key for the products
ALTER TABLE Product ADD CONSTRAINT PK_Product_productId PRIMARY KEY (productId);

-- Here we are just inserting some dummy products into our product table.
INSERT INTO
    Product (description, color, cost)
VALUES
    ('Scooter', 'Red', 3.99),
    ('Bike', 'Blue', 19.99),
    ('Boat', 'Yellow', 4.99),
    ('Car', 'Green', 7.99),
    ('Tank', 'Brown', 2.00);

CREATE TABLE
    Basket (
        -- This is the ID of the basket, there can be many baskets for many users
        basketID INT IDENTITY (1, 1) NOT NULL,
        -- This is the person who owns the basket, users can have more than one basket 
        UserID INT,
        createDate DATETIME DEFAULT GETDATE ()
    )

--This is the primary key constraint for the basketID
ALTER TABLE Basket ADD CONSTRAINT PK_Basket_basketID PRIMARY KEY (basketID);

-- Create some dummy baskets for users, 
-- here we are going to use some of the users we created above
INSERT INTO
    Basket (UserID)
VALUES
    (1),
    (2),
    (3),
    (5);

CREATE TABLE
    BasketProduct (
        -- This is a foreign key, it references the basket table 
        basketID INT NOT NULL,
        -- This is a foreign key, it references the products table because baskets
        -- can have many products 
        ProductID INT NOT NULL
    );

-- This is the foreign key for the product ID, this references the product table as that
-- is where the source of the product is.
ALTER TABLE BasketProduct ADD CONSTRAINT FK_BasketProduct_ProductID FOREIGN KEY (ProductID) REFERENCES Product (productID);

-- This foreign key ensures that no values are created in the basketproduct that do not 
-- exist in the parent tables, in the base of this constrain that is the Product table.
/* This is the foreign key for the basket ID, this references the basket table as that
is where the source of the basket is. */
ALTER TABLE BasketProduct ADD CONSTRAINT FK_BasketProduct_basketID FOREIGN KEY (basketID) REFERENCES Basket (basketID);

/* This foreign key ensures that no values are created in the basketproduct that do not 
exist in the parent tables, in the base of this constrain that is the Basket table. */
/* Try and insert a value into Basket Product that doesn't exist in Basket, it will error
as it is in violation of the key. */
INSERT INTO
    BasketProduct (basketID, productID)
VALUES
    (9, 10); 
    
/* Both these values don't exist in the basket table or the product table 
Try and insert a value into Basket Product that doesn't exist in Basket, it will error
as it is in violation of the key. */

INSERT INTO
    BasketProduct (basketID, productID)
VALUES
    (2, 9); 

/* The user exists but the product doesn't, still errors because one of the keys was violated 
Insert some products into the baskets for the users, 
we are going to use the basket ids created above 
*/

INSERT INTO
    BasketProduct (basketID, productID)
VALUES
    (1, 2),
    (1, 5),
    (2, 1),
    (2, 4),
    (2, 5),
    (3, 1);

/* This query will get all baskets, their users and the products within the basket
this uses an inner join so will only return values which on each side of the join, for
example, user 4 doesn't have any products or a basket */

SELECT
    *
FROM
    Basket B
    INNER JOIN BasketProduct BP ON B.BasketID = BP.BasketID
    INNER JOIN Users U ON B.UserID = U.UserID
    INNER JOIN Product P ON BP.ProductID = P.ProductID


/* This query will get all baskets, their users and the products within the basket
this uses two left joins which will get me all users who have baskets, as you can see
user 5 has a basket but has no products but does have a basket. */

SELECT
    *
FROM
    Basket B
    INNER JOIN Users U ON B.UserID = U.UserID
    LEFT JOIN BasketProduct BP ON B.BasketID = BP.BasketID
    LEFT JOIN Product P ON BP.ProductID = P.ProductID

--Select all members and their premium status
SELECT
  forename,
  surname,
  CASE
    WHEN isPremium = 1 THEN 'Premium Member'
    ELSE 'Standard member'
  END AS isPremium
FROM
  Users