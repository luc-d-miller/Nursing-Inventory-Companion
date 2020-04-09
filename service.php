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