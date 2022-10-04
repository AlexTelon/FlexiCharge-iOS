//
//  AccountAPI.swift
//  FlexiCharge
//
//  Created by Sandra Nissan on 2022-09-13.
//

import Foundation
import Combine
import SwiftUI

class AccountAPI : ObservableObject {
    @Published var isLoggedIn : Bool = false
    //@Published var accountDetails = AccountDataModel()
    
    init() {
        
    }
    
    func getRegisterResponseErrors(statusCode: Int, message: String, errorDescription: String) -> String {
        
        var errorMessage = ""
        
        if(statusCode == 400){
            
            if(errorDescription == "InvalidPasswordException" ){
                let start = message.index(message.startIndex, offsetBy: 38)
                let end = message.index(message.endIndex, offsetBy: 0)
                let range = start..<end
                errorMessage = String(message[range])
                print(errorMessage)
                //completionHandler("Password must have uppercase characters")
            }else{
                errorMessage = message
                print(errorMessage)
                
            }
        }
        return errorMessage
    }
    
    func saveLoggedState() {

        let def = UserDefaults.standard
        def.set(true, forKey: "isLoggedIn") // save true flag to UserDefaults
        def.synchronize()

    }
    
    //completion: @escaping (String)->Void)
    
    func registerAccount(username: String, password: String, email: String, firstName: String, surName: String, completionHandler: @escaping (String)->Void) {
        
        var errorMessage:String = ""
        
        let userCredentials: [String: String] = [
            "username": username,
            "password": password,
            "email": email,
            "name": firstName,
            "family_name": surName
        ]
        
        //https://jsonplaceholder.typicode.com/posts
        //http://18.202.253.30:8080/auth/sign-up
        
        //Create the HTTP request
        guard let url = URL(string: "http://18.202.253.30:8080/auth/sign-up") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //parse userCredentials to json format.
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: userCredentials, options: [])
        }catch let error{
            print("Error!: \(error)")
        }
        
        //make the HTTP request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                errorMessage = "error when parsing json data"
            }
            
            if let data = data {
                do{
                    if let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                        //Check for error messages in http response
                        errorMessage = self.getRegisterResponseErrors(statusCode: response["statusCode"] as! Int, message: response["message"] as! String, errorDescription: response["code"] as! String)
                    }

                }catch{
                    return
                }
            }
            //send back error message or empty string if there are no errors
            if(errorMessage.isEmpty){
                completionHandler(errorMessage)
            }else{
                completionHandler(errorMessage)
            }
            
        }.resume()
        
    }
    
    
    func logInUser(username: String, password: String, accountDetails: AccountDataModel ,completionHandler: @escaping (String)->Void){
        
        var errorMessage:String = ""
        let loginCredentials: [String:String] =
        [
            "username":username,
            "password":password
        ]
        
        //create http reqeust
        guard let url = URL(string: "http://18.202.253.30:8080/auth/sign-in") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        //parse ligonCredentials to json format.
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: loginCredentials, options: [])
        }catch let error{
            print("Error when parsin json data: \(error)")
        }
        
        
        //Make http request
        URLSession.shared.dataTask(with: request){ data, response, error in
            if error != nil{
                errorMessage = "request error"
                completionHandler(errorMessage)
            }
            
            if let data = data{
                do{
                    if let response = try JSONSerialization.jsonObject(with: data, options: [])  as? [String: Any] {

                        if(response["code"] as? String != nil ){
                            errorMessage = response["message"] as! String
                            completionHandler(errorMessage)
                        }else{
                            accountDetails.username = response["username"] as? String ?? ""
                            accountDetails.firstName = response["name"] as? String ?? ""
                            accountDetails.email = response["email"] as? String ?? ""
                            accountDetails.accessToken = response["accessToken"] as? String ?? ""
                            accountDetails.userId = response["user_id"] as? String ?? ""
                            accountDetails.lastName = response["family_name"] as? String ?? ""
                            errorMessage = ""
                            completionHandler(errorMessage)
                            self.saveLoggedState()
                        }
                        
                    }
                }catch{
                    print("Error")
                }
            }
           
        }.resume()
        
    }
       
}
