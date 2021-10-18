//
//  WebServiceDetail.swift
//  MyPlaceholderJson
//
//  Created by iOS Development on 10/17/21.
//

import Foundation
import SwiftUI
import Combine

class WebServiceDetail: ObservableObject {
    var didChange = PassthroughSubject<WebServiceDetail,Never>()
    
    @Published var postsCommentsList = PostsCommentsList(){
        didSet{
            didChange.send(self)
        }
    }
    
    func getPostCopmments(with postId : Int){
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(postId)/comments") else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let response = response {
                print(response)
            }
            do{
                guard let data = data else { return }
                let posts = try JSONDecoder().decode(PostsCommentsList.self, from: data)
                DispatchQueue.main.async {
                    self.postsCommentsList = posts
                }
            }catch let error as NSError{
                print("API haven't wake up", error.localizedDescription)
            }
        }.resume()
    }
    
    func clean(){
        self.postsCommentsList = []
    }
}
