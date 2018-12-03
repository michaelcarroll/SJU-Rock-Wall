//
//  SJU_Rock_WallTests.swift
//  SJU-Rock-WallTests
//
//  Created by Kalsow, Brandan D on 11/18/18.
//  Copyright © 2018 Kalsow, Brandan D. All rights reserved.
//

import XCTest
@testable import SJU_Rock_Wall

class SJU_Rock_WallTests: XCTestCase
{
    
    override func setUp()
    {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let json_User: [String: Any] = ["fName": "John", "lName": "Doe", "username": "jdoe", "email": "jdoe@example.com", "password": "ThisIsATest"]
        
        let jsonData_User = try? JSONSerialization.data(withJSONObject: json_User)
        
        // create post request
        let url_User = URL(string: "http://sjurockwall.atwebpages.com/createUser.php")!
        var request_User = URLRequest(url: url_User)
        request_User.httpMethod = "POST"
        
        // insert json data to the request
        request_User.httpBody = jsonData_User
        
        let userTask = URLSession.shared.dataTask(with: request_User)
        {
            data, response, error in
            guard let data = data, error == nil else
            {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any]
            {
            }
        }
        
        let json_Route: [String: Any] = ["uid": 0, "name": "Test Route", "difficulty" : "1", "description": "This route is for testing purposes only", "wallState" : "test"]
        
        let jsonData_Route = try? JSONSerialization.data(withJSONObject: json_Route)
        
        // create post request
        let url_Route = URL(string: "http://sjurockwall.atwebpages.com/createRoute.php")!
        var request_Route = URLRequest(url: url_Route)
        request_Route.httpMethod = "POST"
        
        // insert json data to the request
        request_Route.httpBody = jsonData_Route
        
        let task = URLSession.shared.dataTask(with: request_Route)
        {
            data, response, error in
            guard let data = data, error == nil else
            {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any]
            {
            }
        }
    }
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        var theData: Any = [1] as Any
         let json: [String: Any] = ["email": "jdoe@example.com", "password": "ThisIsATest"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://sjurockwall.atwebpages.com/login.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            guard let data = data, error == nil else
            {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let responseJSON = responseJSON as? [String: Any]
            {

                theData = responseJSON["message"] as! Any
                
                
            }
            
        }
       
        let json2: [String: Any] = ["id": theData]
        let jsonData2 = try? JSONSerialization.data(withJSONObject: json2)
        
         let url2 = URL(string: "http://sjurockwall.atwebpages.com/deleteUser.php")!
        var request2 = URLRequest(url: url2)
        
        request.httpMethod = "Post"
        
        request.httpBody = jsonData2
        
        let task2 = URLSession.shared.dataTask(with: request2)
        {
            data, response, error in
            guard let data = data, error == nil else
            {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any]
            {
               
            }
            
        }
    }
    
       func testLoginSuceeds()
    {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let json: [String: Any] = ["email": "jdoe@example.com", "password": "ThisIsATest"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://sjurockwall.atwebpages.com/login.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            guard let data = data, error == nil else
            {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any]
            {
                
                let error = responseJSON["error"] as! Int
                
                XCTAssertTrue(error == 0)
               

            }
        }
    }
    
    func testLoginFailsUsernameContainsTypo()
    {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let json: [String: Any] = ["email": "jdo@example.com", "password": "ThisIsATest"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://sjurockwall.atwebpages.com/login.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            guard let data = data, error == nil else
            {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any]
            {
                
                let error = responseJSON["error"] as! Int
                
                XCTAssertTrue(error == 3)
                
                
            }
        }
    }
    
    func testLoginFailsClearlyInvalidUsername()
    {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let json: [String: Any] = ["email": "wrong@failure.com", "password": "ThisIsATest"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://sjurockwall.atwebpages.com/login.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            guard let data = data, error == nil else
            {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any]
            {
                
                let error = responseJSON["error"] as! Int
                
                XCTAssertTrue(error == 3)
                
                
            }
        }
    }
    
    func testLoginFailsPasswordContainsTypo()
    {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let json: [String: Any] = ["email": "jdoe@example.com", "password": "ThisIsATests"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://sjurockwall.atwebpages.com/login.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            guard let data = data, error == nil else
            {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any]
            {
                
                let error = responseJSON["error"] as! Int
                
                XCTAssertTrue(error == 3)
                
                
            }
        }
    }
    
    func testLoginFailsPasswordClearlyWrong()
    {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let json: [String: Any] = ["email": "jdoe@example.com", "password": "TestsAreDumb"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://sjurockwall.atwebpages.com/login.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            guard let data = data, error == nil else
            {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any]
            {
                
                let error = responseJSON["error"] as! Int
                
                XCTAssertTrue(error == 3)
                
                
            }
        }
    }
    
    func testLoginVarsNotSet()
    {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let json: [String: Any] = ["email": "", "password": ""]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://sjurockwall.atwebpages.com/login.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            guard let data = data, error == nil else
            {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any]
            {
                
                let error = responseJSON["error"] as! Int
                
                XCTAssertTrue(error == 2)
                
                
            }
        }
    }
    
    func testLoginUsernameNotSet()
    {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let json: [String: Any] = ["email": "", "password": "ThisIsATest"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://sjurockwall.atwebpages.com/login.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            guard let data = data, error == nil else
            {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any]
            {
                
                let error = responseJSON["error"] as! Int
                
                XCTAssertTrue(error == 2)
                
                
            }
        }
    }
    
    func testLoginPasswordNotSet()
    {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let json: [String: Any] = ["email": "jdoe@example.com", "password": ""]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://sjurockwall.atwebpages.com/login.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            guard let data = data, error == nil else
            {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any]
            {
                
                let error = responseJSON["error"] as! Int
                
                XCTAssertTrue(error == 2)
                
                
            }
        }
    }
    
    func testCreateUserFailsForDuplicateUser()
    {
        let json: [String: Any] = ["fName": "John", "lName": "Doe", "username": "jdoe", "email": "jdoe@example.com", "password": "ThisIsATest"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://sjurockwall.atwebpages.com/createUser.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            guard let data = data, error == nil else
            {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any]
            {
                let error = responseJSON["error"] as! Int
                
                XCTAssertTrue(error == 3)
            }
        }
    }
 
    func testCreateUserFailsForEmptyVariables()
    {
        let json: [String: Any] = ["fName": "", "lName": "Doe", "username": "jdoe", "email": "jdoe@example.com", "password": "ThisIsATest"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://sjurockwall.atwebpages.com/createUser.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            guard let data = data, error == nil else
            {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any]
            {
                let error = responseJSON["error"] as! Int
                
                XCTAssertTrue(error == 2)
            }
        }
    }
    
    func testCreateRouteFailsForDuplicateRoute()
    {
        let json: [String: Any] = ["uid": 0, "name": "Test Route", "difficulty" : "1", "description": "This route is for testing purposes only", "wallState" : "test"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://sjurockwall.atwebpages.com/createRoute.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            guard let data = data, error == nil else
            {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any]
            {
                let error = responseJSON["error"] as! Int
                
                XCTAssertTrue(error == 3)
            }
        }
    }
}
