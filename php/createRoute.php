<?php
header('Content-Type: application/json');

$response = array();

if($_SERVER['REQUEST_METHOD']=='POST'){
	$inputJSON = file_get_contents('php://input');
	$input = json_decode($inputJSON, TRUE);
    //getting values
	if(isset($input['uid']) && $input['description'] && $input['difficulty'] && $input['name'] && $input['wallState']){
		$uid = $input['uid'];
		$description = $input['description'];
		$name = $input['name'];
		$difficulty = $input['difficulty'];
                $wallState = $input['wallState'];
		
		//including the db operation file
		require_once 'DbOperation.php';
	 
		$db = new DbOperation();
		if($db->createRoute($uid,$name,$difficulty,$description,$wallState)){
			$response['error']=0;
			$response['message']='Route added successfully';
		}else{
			$response['error']=3;
			$response['message']='Unable to add route';
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