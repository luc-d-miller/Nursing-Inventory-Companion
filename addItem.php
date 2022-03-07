<?php 
//sign in to database
$servername = "ip address";
$username = "nicQuery";
$password = "Benedictine20";
$schema = "Inventory"; 

//establish variables to be passed to database
$itemName = '"' . $_POST['itemName'] . '"';
$quantity = (int)$_POST['quantity'];
$company = '"' . $_POST['company'] . '"';
$price = (int)$_POST['price'];
$boxQuantity = (int)$_POST['boxQuantity'];
$shelfLocation = '"' . $_POST['shelfLocation'] . '"';
$minSupplies = (int)$_POST['minSupplies'];
$barcode = '"' . $_POST['barcode'] . '"';


// Create connection
$con=mysqli_connect($servername, $username, $password, $schema);

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

$sql = "CALL insertNewItem($itemName, $quantity, $company, $price, $boxQuantity, $shelfLocation, $minSupplies, $barcode);";
if (!mysqli_query($con, $sql)) {
  echo "Failed to insert the item: " . mysqli_error($con);
}

mysqli_close($con);

?>