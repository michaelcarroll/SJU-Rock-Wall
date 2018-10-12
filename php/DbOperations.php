<?php
class dbOperation{
	private $conn;
	

	public function createUser($email,$username,$password,$fName,$lName){
		$conn = new MongoDB\Driver\Manager('mongodb+srv://admin:Level2rock@sjurockwall-b3ehe.mongodb.net/test?retryWrites=true');
		
		$ins = new MongoDB\Driver\BulkWrite; 
     
		$ins->insert(['email'=>$email,'username'=>$username,'password'=>$password,'fName'=>$fName,'lName'=>$lName]);
		try{
			$result = $conn->executeBulkWrite('sjurockwall.users', $ins);
			return true;
		} catch (Exception $e){
			return false;
		}
	}
	
	public function login($email,$password){
		$conn = new MongoDB\Driver\Manager('mongodb+srv://admin:Level2rock@sjurockwall-b3ehe.mongodb.net/test?retryWrites=true');
		
		$filter = ['email' => $email, 'password' => $password];
		
		$query = new MongoDB\Driver\Query($filter);

		try{
			$result = $conn->executeQuery('sjurockwall.users', $query);
			foreach ( $result as $document){
				return $document->username;
			}
			return NULL;
		} catch (Exception $e){
			return NULL;
		}
	}
	
	public function getUser($username){
		$conn = new MongoDB\Driver\Manager('mongodb+srv://admin:Level2rock@sjurockwall-b3ehe.mongodb.net/test?retryWrites=true');
		
		$filter = ['username' => $username];
		
		$query = new MongoDB\Driver\Query($filter);

		try{
			$result = $conn->executeQuery('sjurockwall.users', $query);
			foreach ( $result as $document){
				return array('email' => $document->email,'username' => $document->username,'fName' => $document->fName,'lName' => $document->lName);
			}
		} catch (Exception $e){
			return NULL;
		}
	}
	
	public function getRoute($name){
		$conn = new MongoDB\Driver\Manager('mongodb+srv://admin:Level2rock@sjurockwall-b3ehe.mongodb.net/test?retryWrites=true');
		
		$filter = ['name' => $name];
		
		$query = new MongoDB\Driver\Query($filter);

		try{
			$result = $conn->executeQuery('sjurockwall.routes', $query);
			foreach ( $result as $document){
				$sum = 0;
				$count = 0;
				foreach($document->difficulty as $rating){
					$sum += $rating;
					$count++;
				}
				
				return array('name' => $document->name,'username' => $document->username,'description' => $document->description,'difficulty' => $sum/$count,'creationDate' => $document->creationDate);
			}
		} catch (Exception $e){
			return NULL;
		}
	}
	
	public function createRoute($username,$name,$difficulty,$description){
		$conn = new MongoDB\Driver\Manager('mongodb+srv://admin:Level2rock@sjurockwall-b3ehe.mongodb.net/test?retryWrites=true');
		
		$ins = new MongoDB\Driver\BulkWrite; 
     
		$ins->insert(['username' => $username,'name' => $name,'description' => $description,'difficulty' => $difficulty, 'creationDate' => date('m/d/Y')]);
		try{
			$result = $conn->executeBulkWrite('sjurockwall.routes', $ins);
			return true;
		} catch (Exception $e){
			return false;
		}
	
	}
}	
