//
//  NetworkService.swift
//  ToDoList
//
//  Created by Bherly Novrandy on 5/16/17.
//  Copyright © 2017 Bherly Novrandy. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkService {
    
    let baseURL: String = "http://ec2-54-169-2-147.ap-southeast-1.compute.amazonaws.com:3000/todo"
    var sessionManager: SessionManager
    
    init() {
        self.sessionManager = SessionManager.default
    }
    
    func getTodoList(success: @escaping (_ data: [JSON])->Void, failure: @escaping (_ error: String)->Void) {
        self.sessionManager.request(self.baseURL)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
            switch response.result {
            case .success(let result):
                let json = JSON(result)
                if let array = json.array {
                    success(array)
                    return
                }
                
                failure("Tidak ada data.")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func postTodoList(name: String, success: @escaping ()->Void, failure: @escaping (_ error: String)->Void) {
        
        let parameters: [String: Any] = [
            "name": name
        ]
        
        self.sessionManager.request(self.baseURL, method: .post, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(_):
                    success()
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    func putTodoList(id: String, name: String, success: @escaping ()->Void, failure: @escaping (_ error: String)->Void) {
        
        let parameters: [String: Any] = [
            "id": id,
            "name": name
        ]
        
        self.sessionManager.request(self.baseURL, method: .put, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(_):
                    success()
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    func deleteTodoList(id: String, success: @escaping ()->Void, failure: @escaping (_ error: String)->Void) {
        
        let parameters: [String: Any] = [
            "id": id
        ]
        
        self.sessionManager.request(self.baseURL, method: .delete, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(_):
                    success()
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
}
