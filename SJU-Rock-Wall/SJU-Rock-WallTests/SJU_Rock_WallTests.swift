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
            }
        }
    }
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        let uid: String
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
                print(responseJSON)
                
                let error = responseJSON["error"] as! Int
                
                
                uid = responseJSON["message"]
                
                
            }
            
        }
       
        let json2: [String: Any] = ["id": uid!]
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
                print(responseJSON)
                
                let error = responseJSON["error"] as! Int
                
                
                let Id = responseJSON["message"] as! Int
                
                
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
    
    func testLoginFailInvalidUsername()
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
    
    func testLoginFailsInvalidPassword()
    {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let json: [String: Any] = ["email": "jdoe@example.com", "password": "ThisIsNotATest"]
        
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
        
    
    func testPerformanceExample()
    {
        // This is an example of a performance test case.
        self.measure
        {
            // Put the code you want to measure the time of here.
        }
    }
    
}
