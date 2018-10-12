<?php
header('Content-Type: application/json');
/*
 Modeled after https://www.simplifiedios.net/swift-php-mysql-tutorial/
*/

//creating response array
$response = array();
 
set_include_path(get_include_path() . PATH_SEPARATOR . 'C:\xampp\htdocs');
if($_SERVER['REQUEST_METHOD']=='POST'){
	$inputJSON = file_get_contents('php://input');
	$input = json_decode($inputJSON, TRUE);
	ob_start();                    // start buffer capture
    var_dump($input);           // dump the values
    $contents = ob_get_contents(); // put the buffer into a variable
    ob_end_clean();                // end capture
    error_log('Error:'. $contents );
    //getting values
	if(isset($input['email']) && isset($input['username']) && isset($input['password']) && isset($input['fName']) && isset($input['lName'])){
		$email = $input['email'];
		$username = $input['username'];
		$password = $input['password'];
		$fName = $input['fName'];
		$lName = $input['lName'];
		//including the db operation file
		require_once 'DbOperations.php';
	 
		$db = new DbOperation();
	 
		//inserting values 
		if($db->createUser($email,$username,$password,$fName,$lName)){
			$response['error']=0;
			$response['message']='User added successfully';
		}else{
	 
			$response['error']=3;
			$response['message']='Could not add user';
		}
	} else {
		$response['error']=2;
        $response['message']='User variables not set';
	}
 
}else{
    $response['error']=1;
    $response['message']='You are not authorized';
}
echo json_encode($response);