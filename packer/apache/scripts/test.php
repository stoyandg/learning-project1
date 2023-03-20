<?php
$servername = "learning-project1-app-db-cluster.cluster-ro-c28tdc1meb9d.us-west-2.rds.amazonaws.com";
$username = "stoyandg";
$password = "stoyan123";

// Create connection
$conn = mysqli_connect($servername, $username, $password);

// Check connection
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}
echo "Connected successfully";
?>