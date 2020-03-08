<?php
$servername = "192.168.56.101";
$username = "nicQuery";
$password = "Benedictine20";
$schema = "Inventory"; 


// Create connection
$con=mysqli_connect($servername, $username, $password, $schema);

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

// Selects everything from the Inventory table
$sql = "CALL selectAllItems;";

// Check if there are results
if ($result = mysqli_query($con, $sql))
{
  $resultArray = array();
  $tempArray = array();
  
  // Loop through each row in the result set
  while($row = $result->fetch_object())
  {
    // Add each row into our results array
    $tempArray = $row;
    array_push($resultArray, $tempArray);
  }
  
  // Finally, encode the array to JSON and output the results
  echo json_encode($resultArray);
}
mysqli_close($con);


// Close connections

//Functions to write 
//Add new item
//Delete item
//Change variables
//Rename
//Quantity
//Company
//Price
//Box Quantity
//Shelf Location
//Minimum Supplies
//Maximum Supplies
?>

<?php
//A function to add a new item to the database. Doesn't work. 
function addNewItem() {
  //sign in to database
  $servername = "192.168.56.101";
  $username = "nicQuery";
  $password = "Benedictine20";
  $schema = "Inventory"; 

  //establish variables to be passed to database
  

  // Create connection
  $con=mysqli_connect($servername, $username, $password, $schema);
  
  // Check connection
  if (mysqli_connect_errno())
  {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }
  
  $sql = "CALL insertNewItem('php Test', 100, 'php company', 1000000, 1, 'E', 36, 360);";
  if (!mysqli_query($con, $sql)) {
    echo "Failed to insert the item: " . mysqli_error($con);
  }
  
  mysqli_close($con);
}
?>