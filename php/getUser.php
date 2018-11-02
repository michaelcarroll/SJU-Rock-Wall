<?php
header('Content-Type: application/json');

$response = array();
 
set_include_path(get_include_path() . PATH_SEPARATOR . 'C:\xampp\htdocs');
if($_SERVER['REQUEST_METHOD']=='POST'){
    $inputJSON = file_get_contents('php://input');
    $input = json_decode($inputJSON, TRUE);
    //getting values
	if(isset($input['id'])){
		$id = $input['id'];
		//including the db operation file
		require_once 'DbOperation.php';
	 
		$db = new DbOperation();
		$user = $db->getUser($id);
		if(!empty($user)){
			$response['error']=0;
			$response['message']=$user;
		}else{
			$response['error']=3;
			$response['message']='Not valid username';
		}
	} else {
		$response['error']=2;
        $response['message']='User variables not set';
	}
 
}else{
    $response['error']=1;
    $response['message']='Not authorized to use this page';
}
echo json_encode($response);