<?php
header('Content-Type: application/json');

$response = array();

if($_SERVER['REQUEST_METHOD']=='POST'){
	$inputJSON = file_get_contents('php://input');
	$input = json_decode($inputJSON, TRUE);
    //getting values
	if(isset($input['id'])){
		$id = $input['id'];
		//including the db operation file
		require_once 'DbOperation.php';
	 
		$db = new DbOperation();
		$route = $db->getRoute($id);
		if(!empty($route)){
			$response['error']=0;
			$response['message']=$route;
		}else{
			$response['error']=3;
			$response['message']='No route by that id';
		}
	} else {
		$response['error']=2;
                $response['message']='Route variables not set';
	}
 
}else{
    $response['error']=1;
    $response['message']='Not authorized to use this page';
}
echo json_encode($response);