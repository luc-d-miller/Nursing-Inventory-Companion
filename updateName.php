<?php 
//hardcoded sign in to database
$servername = "[removed before passing torch]";
$username = "nicQuery";
$password = "Benedictine20";
$schema = "Inventory"; 

//establish variables to be passed to database
$itemName = '"' . $_POST['itemName'] . '"';
$itemID = '"' . $_POST['itemID'] . '"';

// Create connection
$con=mysqli_connect($servername, $username, $password, $schema);

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

$sql = "CALL updateName($itemName, $itemID);";
if (!mysqli_query($con, $sql)) {
  echo "Failed to insert the item: " . mysqli_error($con);
}

mysqli_close($con);
?>