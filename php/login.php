<?php
header('Content-Type: application/json');

$response = array();

if($_SERVER['REQUEST_METHOD']=='POST'){
    $inputJSON = file_get_contents('php://input');
    $input = json_decode($inputJSON, TRUE);
    //getting values
	if(isset($input['email']) && isset($input['password'])){
		$email = $input['email'];
		$password = $input['password'];
		//including the db operation file
		require_once 'DbOperation.php';
	 
		$db = new DbOperation();
		$id = $db->login($email,$password);
		if(!empty($id)){
			$response['error']=0;
			$response['message']=$id;
		}else{
			$response['error']=3;
			$response['message']='Not valid email/password';
		}
	} else {
		$response['error']=2;
                $response['message']='Login variables not set';
	}
 
}else{
    $response['error']=1;
    $response['message']='Not authorized to use this page';
}
echo json_encode($response);