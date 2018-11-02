<?php
/*
 Modeled after https://www.simplifiedios.net/swift-php-mysql-tutorial/
*/
class DbOperation{
    private $conn;
 
    //Constructor
    function __construct(){
        require_once dirname(__FILE__) . '/Config.php';
        require_once dirname(__FILE__) . '/DbConnect.php';
        // opening db connection
        $db = new DbConnect();
        $this->conn = $db->connect();
    }
 
    //Function to create a new user
    public function createUser($email,$username,$password,$fName,$lName){
        $stmt = $this->conn->prepare("INSERT INTO users(email, username, password, fName, lName) values(?, ?, ?, ?, ?)");
        $stmt->bind_param("sssss",$email,$username,$password,$fName,$lName);
        try{
            $result = $stmt->execute();
            $stmt->close();
            if ($result) {
                return true;
            } else {
                return false;
            }
        } catch(Exception $e){
            return false;
        }
    }
    
    public function login($email,$password){
        $stmt = $this->conn->prepare("SELECT id FROM users WHERE email = ? and password = ?");
        $stmt->bind_param("ss",$email,$password);
        try{
             $stmt->execute();
             $stmt->bind_result($id);
             $stmt->fetch();
             $stmt->close();
             return $id;
        } catch(Exception $e) {
             return null;
        }
    }
    
    public function getUser($id){
        $stmt = $this->conn->prepare("SELECT email, username, fName, lName FROM users WHERE id = ?");
        $stmt->bind_param("i",$id);
        try{
             $stmt->execute();
             $stmt->bind_result($email,$username,$fName,$lName);
             $stmt->fetch();
             $stmt->close();
             return array('email' => $email,'username' => $username,'fName' => $fName, 'lName' => $lName);
        } catch(Exception $e) {
             return null;
        }
    }
    
    public function createRoute($uid,$name,$difficulty,$description,$wallState){
        $stmt = $this->conn->prepare("INSERT INTO routes(uid_fk, name, description, rating, wallState) values(?, ?, ?, ?, ?)");
        $stmt->bind_param("sssss",$uid,$name,$description, $difficulty, $wallState);
        try{
            $result = $stmt->execute();
            $stmt->close();
            if ($result) {
                return true;
            } else {
                return false;
            }
        } catch(Exception $e){
            return false;
        }
        
    }
    
    
    public function rate($rid,$uid,$rating){
            $stmt = $this->conn->prepare("INSERT INTO ratings(rid_fk,uid_fk,rating) VALUES(?,?,?) ON DUPLICATE KEY UPDATE");
            $stmt->bind_param("iii",$rid,$uid,$rating);
            try{
                    $result = $stmt->execute();
                    $stmt->close();
                    if ($result) {
                        return true;
                    } else {
                        return false;
                    }
        } catch(Exception $e){
            return false;
        }
    }
    
    public function getRoute($id){
        $stmt = $this->conn->prepare("SELECT r.id, r.uid_fk, username, name, description, wallState, creationDate, r.rating, CASE WHEN AVG(d.rating) IS NULL THEN r.rating ELSE AVG(d.rating) END as communityRating FROM routes r INNER JOIN users u ON r.uid_fk = u.id INNER JOIN ratings d ON d.rid_fk = r.id WHERE r.id = ?");
        $stmt->bind_param("i",$id);
        try{
             $stmt->execute();
             $stmt->bind_result($rid,$uid,$username,$name,$description,$wallState,$creationDate,$rating,$cRating);
             $stmt->fetch();
             $stmt->close();
             return array('rid' => $rid,'uid' => $uid,'username' => $username, 'name' => $name, 'description' => $description, 'wallState' => $wallState, 'creationDate' => $creationDate, 'rating' => $rating, 'cRating' => $cRating);
        } catch(Exception $e) {
             return null;
        }
    }
     
    public function getRoutes(){
        $stmt = $this->conn->prepare("SELECT r.id, username, name FROM routes r INNER JOIN users u ON r.uid_fk = u.id ORDER BY creationDate");
        try{
             $stmt->execute();
             $stmt->bind_result($rid,$username,$name);
             $detail = array();
             while($stmt->fetch()){
                     $detail[] = array('rid' => $rid,'username' => $username, 'name' => $name);
             }
             $stmt->close();
             return $detail;
        } catch(Exception $e) {
             return null;
        }
    }
}