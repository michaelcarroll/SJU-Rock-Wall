<?php
header('Content-Type: application/json');

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
	if(isset($input['username']) && $input['description'] && $input['difficulty'] && $input['name']){
		$username = $input['username'];
		$description = $input['description'];
		$name = $input['name'];
		$difficulty = array($username=>(int)$input['difficulty']);
		
		//including the db operation file
		require_once 'DbOperations.php';
	 
		$db = new DbOperation();
		if($db->createRoute($username,$name,$difficulty,$description)){
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