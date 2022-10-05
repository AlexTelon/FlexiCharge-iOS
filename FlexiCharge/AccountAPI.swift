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
    
    func registerAccount(email: String, password: String,completionHandler: @escaping (String)->Void) {
        
        var errorMessage:String = ""
        
        let userCredentials: [String: String] = [
            "username": email,
            "password": password
        ]
        
        //https://jsonplaceholder.typicode.com/posts
        //http://18.202.253.30:8080/auth/sign-up
        
        //Create the HTTP request
        guard let url = URL(string: "\(UsefulValues.apiBaseUrl)/auth/sign-up") else { return }
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
            if error != nil {
                completionHandler("Something went wrong, try agian.")
            }
            
            //Fetch http response code
            guard let httpURLResponse = response as? HTTPURLResponse else { return }
            let statusCode = httpURLResponse.statusCode
            do{
                //If statuscode is 200, account has been created. Call completionHandler to tell register view the call has been completed
                if statusCode == 200 {
                    completionHandler(errorMessage)
                }
                else{
                    //Account was not created, parse json data and send back error message.
                    if let response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]{
                        //Check for error messages in http response
                        errorMessage = self.getRegisterResponseErrors(statusCode: response["statusCode"] as! Int, message: response["message"] as! String, errorDescription: response["code"] as! String)
                    }
                    completionHandler(errorMessage)
                }
            }catch{
                completionHandler("Error when parsing response data")
            }
            
        }.resume()
        
    }
    
    

    func logInUser(email: String, password: String, accountDetails: AccountDataModel ,completionHandler: @escaping (String)->Void){
        
        var errorMessage:String = ""
        let loginCredentials: [String:String] =
        [
            "username":email,
            "password":password
        ]
        
        //create http reqeust
        guard let url = URL(string: "\(UsefulValues.apiBaseUrl)/auth/sign-in") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        //parse loginCredentials to json format.
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: loginCredentials, options: [])
        }catch let error{
            print("Error when parsin json data: \(error)")
        }
        
        
        //Send http request
        URLSession.shared.dataTask(with: request){ data, response, error in
            if error != nil{
                errorMessage = "Something went wrong, try agian."
                completionHandler(errorMessage)
            }
            guard let httpURLResponse = response as? HTTPURLResponse else { return }
            let statusCode = httpURLResponse.statusCode
            if statusCode == 200{
                completionHandler(errorMessage)
            }
            if let data = data{
                do{
                    if let response = try JSONSerialization.jsonObject(with: data, options: [])  as? [String: Any] {
                        print(response)
                        if(response["code"] as? String != nil ){
                            errorMessage = response["message"] as! String
                            completionHandler(errorMessage)
                        }else{
                            accountDetails.email = response["email"] as? String ?? ""
                            accountDetails.accessToken = response["accessToken"] as? String ?? ""
                            errorMessage = ""
//                            accountModel.isLoggedIn = true
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
    
    func verifyAccount(email: String, verificationCode: String, completionHandler: @escaping (String)->Void){
        
        let verificationInput =
        [
            "username": email,
            "code": verificationCode
        ]
        
        //create http request
        guard let url = URL(string: "\(UsefulValues.apiBaseUrl)/auth/verify") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //parse verificationInput to json format and add attatch to http request
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: verificationInput, options: [])
        }catch{
            completionHandler("Failed to parse to json data")
        }
        
        //Send http request
        URLSession.shared.dataTask(with: request){ data, response, error in
            if error != nil{
                completionHandler("Something went wrong, try agian.")
            }
            //Fetch http response code
            guard let httpURLResponse = response as? HTTPURLResponse else { return }
            let statusCode = httpURLResponse.statusCode
            if statusCode == 200 {
                print("Verifiering lyckades!")
                completionHandler("")
            }
            do{
                if let response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]{
                    print("Response 2 message: \(response["message"] as! String)")
                    completionHandler(response["message"] as! String)
                }
                
            }catch{
                completionHandler("Failed to parse data to json")
            }
            
        }.resume()
        
        
    }
    
    func forgotPassword(email: String, completionHandler: @escaping (String)->Void){
        
        var errorMessage = ""
        
        //create http request
        guard let url = URL(string: "\(UsefulValues.apiBaseUrl)/auth/forgot-password/\(email)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //Send http request
        URLSession.shared.dataTask(with: request){ data, response, error in
            if error != nil{
                completionHandler("Error when sending http request")
            }
            
            //Fetch http response code
            guard let httpURLResponse = response as? HTTPURLResponse else { return }
            let statusCode = httpURLResponse.statusCode
            if statusCode == 200 {
                print("Email skickades!")
                completionHandler(String(statusCode))
            }
            
        }.resume()
        
        
    }
    
    func confirmForgotPassword(email: String, password: String, verificationCode: String, completionHandler: @escaping (String)->Void){
        
        var errorMessage = ""
        let verificationInput =
        [
            "username": email,
            "password": password,
            "confirmationCode": verificationCode
        ]
        
        //create http request
        guard let url = URL(string: "\(UsefulValues.apiBaseUrl)/auth/confirm-forgot-password") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //parse verificationInput to json format and add attatch to http request
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: verificationInput, options: [])
        }catch{
            completionHandler("Failed to parse to json data")
        }
        
        //Send http request
        URLSession.shared.dataTask(with: request){ data, response, error in
            if error != nil{
                completionHandler("Error when sending http request")
            }
            print("Reseponse 1: \(response)")
            //Fetch http response code
            guard let httpURLResponse = response as? HTTPURLResponse else { return }
            let statusCode = httpURLResponse.statusCode
            if statusCode == 200 {
                print("Password reset lyckades!")
                completionHandler(String(statusCode))
            }
            
        }.resume()
        
        
    }
}
