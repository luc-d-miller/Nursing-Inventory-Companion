create database Inventory;
use Inventory;

-- DO THESE THINGS IF THE TABLE GETS A NEW VARIABLE
    -- Drop and re-add insertNewItem with changes
    -- Drop and re-add SelectAllItems with changes
    -- Drop and re-add updateItem with changes
    -- I find it easier to drop/re-add the table and modify the insert calls than make an update call for each item
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
barcode varchar(256) not null,
primary key (itemID)
);

-- Sample data - REPLACE THIS WITH THE DATA VANCE SENT 
insert into items (itemName, quantity, company, price, boxQuantity, shelfLocation, minSupplies, barcode) 
	values ("Test Boy", 111, "Test Boy Company", 100000, 10, 'A', 10, 11111111);
insert into items (itemName, quantity, company, price, boxQuantity, shelfLocation, minSupplies, barcode) 
	values ("Test Girl", 222, "Test Girl Company", 200, 15, 'B', 15, 22222222);
insert into items (itemName, quantity, company, price, boxQuantity, shelfLocation, minSupplies, barcode) 
	values ("Test Grumpy Old Man", 69, "Nice Company", 420, 20, 'Z', 42069, 33333333);

-- Create the procedures to be used by the php service/XCode app
DELIMITER $$ 

-- Select All Items
CREATE PROCEDURE SelectAllItems() 
BEGIN
	select * from items order by itemName;
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
    IN minSupplies1 int,
    IN barcode1 varchar(256)
)
BEGIN 
	INSERT INTO items (itemName, quantity, company, price, boxQuantity, shelfLocation, minSupplies, barcode) 
		VALUES (itemName1, quantity1, company1, price1, boxQuantity1, shelfLocation1, minSupplies1, barcode1);
END $$

-- Change quantity
CREATE PROCEDURE updateQuantity(
	IN newQuantity int,
    IN id int
)
BEGIN
	UPDATE items SET quantity = newQuantity WHERE itemID = id;
END $$

CREATE PROCEDURE updateItem(
	IN newName varchar(256),
    IN id int,
    IN newQuantity int,
    IN newCompany varchar(256),
    IN newPrice int,
    IN newBoxQuantity int,
    IN newShelfLocation varchar(1),
    IN newMinimum int,
    IN newBarcode varchar(256)
)
BEGIN 
	UPDATE items SET itemName = newName, quantity = newQuantity, company = newCompany, price = newPrice, 
		boxQuantity = newBoxQuantity, shelfLocation = newShelfLocation, minSupplies = newMinimum, barcode = 
		newBarcode WHERE itemID = id;
END $$

CREATE PROCEDURE deleteItem(
	IN goneID int
)
BEGIN 
	DELETE FROM items WHERE itemID = goneID;
END $$

CREATE PROCEDURE checkBarcodes(
	IN barcode1 varchar(256)
)
BEGIN 
	SELECT * FROM items WHERE barcode = barcode1; 
END $$

DELIMITER ;

-- Test item
-- CALL insertNewItem('Procedure Test', 1, 'Procedural Company', 12, 200, 'D', 100);
-- CALL updateItem('newName', 1, 1010, 'newCompany', 2020, 333, 'X', 9999);
-- call selectAllItems;

-- A reset for testing 
-- delete from items where itemID > 1;
call selectAllItems;
-- drop table items;