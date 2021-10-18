//
//  WebSErviceUser.swift
//  MyPlaceholderJson
//
//  Created by iOS Development on 10/17/21.
//
import Foundation
import SwiftUI
import Combine

class webServiceUser: ObservableObject {
    var didChange = PassthroughSubject<webServiceUser,Never>()
    
    @Published var userInfo = UserInfo(){
        didSet{
            didChange.send(self)
        }
    }
    
    
    func getUserInfo(with userId : Int){
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users/\(userId)") else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let response = response {
                print(response)
            }
            do{
                guard let data = data else { return }
                let posts = try JSONDecoder().decode(UserModel.self, from: data)
                print(posts)
                DispatchQueue.main.async {
                    self.userInfo.append(posts)
                }
            }catch let error as NSError{
                print("API haven't wake up", error.localizedDescription)
            }
        }.resume()
    }
    
    func clean(){
        self.userInfo = []
    }
}
