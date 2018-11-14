<?php
header('Content-Type: application/json');

$response = array();

//if($_SERVER['REQUEST_METHOD']=='POST'){
	$inputJSON = file_get_contents('php://input');
	$input = json_decode($inputJSON, TRUE);
		//including the db operation file
		require_once 'DbOperation.php';
	 
		$db = new DbOperation();
                $routes = $db->getRoutes();
		if(!empty($routes)){
			$response['error']=0;
			$response['message']=$routes;
		}else{
			$response['error']=3;
			$response['message']='Unable get routes';
		}
	 
/*}else{
    $response['error']=1;
    $response['message']='Not authorized to use this page';
}*/


echo json_encode($response);