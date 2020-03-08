create database Inventory;
use Inventory;

-- DO THESE THINGS IF THE TABLE GETS A NEW VARIABLE
    -- Drop and re-add insertNewItem with changes
    -- Drop and re-add SelectAllItems with changes
    -- I find it easier to drop/re-add the table and modify the insert calls than make an update call for each item
    -- Create procedure to modify new variable
    -- Update addNewItem.php
		-- Give a variable
    -- Create php to modify single value
    -- Update relevant XCode
		-- Give ItemModel.swift a new instance variable and update initializer
        -- Update ItemTableViewController.swift
			-- prepare() - make a variable and send it like the others
            -- downloadItems() - modify the call to ItemModel's initializer
		-- Update ItemDetailViewController.swift IN THIS ORDER BECAUSE IT'S WONKY
			-- Add new labels in Main.storyboard
            -- Connect the dynamic label displaying the data to ItemDetailViewController.swift
            -- Set the label's text in viewDidLoad()
		-- Modify whatever XCode file ends up holding my script for sending data to the database 
			-- Placeholder text

create table items (
itemID int auto_increment not null,
itemName varchar(256) not null,
quantity int not null,
company varchar(256) not null,
price int not null,
boxQuantity int not null,
shelfLocation varchar(1) not null,
minSupplies int not null,
primary key (itemID)
);

-- Sample data - REPLACE THIS WITH THE DATA VANCE SENT 
insert into items (itemName, quantity, company, price, boxQuantity, shelfLocation, minSupplies) 
	values ("Test Boy", 111, "Test Boy Company", 100000, 10, 'A', 10);
insert into items (itemName, quantity, company, price, boxQuantity, shelfLocation, minSupplies) 
	values ("Test Girl", 222, "Test Girl Company", 200, 15, 'B', 15);
insert into items (itemName, quantity, company, price, boxQuantity, shelfLocation, minSupplies) 
	values ("Test Grumpy Old Man", 69, "Nice Company", 420, 20, 'Z', 42069);

-- Create the procedures to be used by the php service/XCode app
DELIMITER $$ 

-- Select All Items
CREATE PROCEDURE SelectAllItems() 
BEGIN
	select * from items;
END $$

-- Select a single item for editing - I can't figure out how to make the procedures use it though so fuck me
CREATE PROCEDURE SelectItem(IN id int)
BEGIN
	SELECT * FROM items WHERE itemID = id;
END $$

-- Create a new item
CREATE PROCEDURE insertNewItem(
	IN itemName1 varchar(256), 
    IN quantity1 int, 
    IN company1 varchar(256), 
    IN price1 int, 
    IN boxQuantity1 int, 
    IN shelfLocation1 char, 
    IN minSupplies1 int
)
BEGIN 
	INSERT INTO items (itemName, quantity, company, price, boxQuantity, shelfLocation, minSupplies) 
		VALUES (itemName1, quantity1, company1, price1, boxQuantity1, shelfLocation1, minSupplies1);
END $$

-- Change itemName
CREATE PROCEDURE updateName(
	IN newName varchar(256),
    IN id int
)
BEGIN
	UPDATE items SET itemName = newName WHERE itemID = id;
END $$

-- Change quantity
CREATE PROCEDURE updateQuantity(
	IN newQuantity int,
    IN id int
)
BEGIN
	UPDATE items SET quantity = newQuantity WHERE itemID = id;
END $$

-- Change company
CREATE PROCEDURE updateCompany(
	IN newCompany varchar(256),
    IN id int
)
BEGIN
	UPDATE items SET company = newCompany WHERE itemID = id;
END $$

-- Change price
CREATE PROCEDURE updatePrice(
	IN newPrice int,
    IN id int
)
BEGIN
	UPDATE items SET price = newPrice WHERE itemID = id;
END $$

-- Change boxQuantity
CREATE PROCEDURE updateBoxQuantity(
	IN newBoxQ int,
    IN id int
)
BEGIN
	UPDATE items SET boxQuantity = newBoxQ WHERE itemID = id;
END $$

-- Change shelfLocation
CREATE PROCEDURE updateShelf(
	IN newShelf varchar(1),
    IN id int
)
BEGIN
	UPDATE items SET shelfLocation = newShelf WHERE itemID = id;
END $$

-- Change minSupplies
CREATE PROCEDURE updateMinSupplies(
	IN newMin int,
    IN id int
)
BEGIN
	UPDATE items SET minSupplies = newMin WHERE itemID = id;
END $$
DELIMITER ;

-- Test item
CALL insertNewItem('Procedure Test', 1, 'Procedural Company', 12, 200, 'D', 100);
-- call selectAllItems;

-- A reset for testing  
delete from items where itemID > 3;
-- call selectAllItems;
