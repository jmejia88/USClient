//
//  SwiftUIView.swift
//  MyPlaceholderJson
//
//  Created by iOS Development on 10/17/21.
//

import SwiftUI

struct PostDetail: View {
    var post : PostsEntity
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @ObservedObject  var webService = WebServiceDetail()
    @ObservedObject  var webService2 = webServiceUser()
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                Text("Description")
                    .font(.title3)
                    .bold()
                HStack{
                    Text(post.body!)
                        .font(.caption)
                        .bold()
                }.padding(.leading,20)
                Text("User Info")
                    .font(.title3)
                    .bold()
                HStack{
                    Text("Name:")
                        .font(.caption)
                        .bold()
                    Text(self.webService2.userInfo.map{$0.name}.joined(separator: " "))
                        .font(.caption)
                }.padding(.leading,20)
                HStack{
                    Text("Email:")
                        .font(.caption)
                        .bold()
                    Text(self.webService2.userInfo.map{$0.email}.joined(separator: " "))
                        .font(.caption)
                }.padding(.leading,20)
                HStack{
                    Text("Phone:")
                        .font(.caption)
                        .bold()
                    Text(self.webService2.userInfo.map{$0.phone}.joined(separator: " "))
                        .font(.caption)
                }.padding(.leading,20)
                HStack{
                    Text("Website:")
                        .font(.caption)
                        .bold()
                    Text(self.webService2.userInfo.map{$0.website}.joined(separator: " "))
                        .font(.caption)
                }.padding(.leading,20)
                HStack{
                    Text("Comments")
                        .font(.title3)
                        .bold()
                }
                List(self.webService.postsCommentsList, id: \.id){ post in
                    
                        VStack (alignment: .leading){
                            Text(post.name)
                                .font(.title3)
                                .bold()
                            Text(post.email)
                                .font(.caption)
                                .bold()
                            Text(post.body)
                                .font(.subheadline)
                                
                        }
                    
                    
                }.listStyle(.plain)
                 .navigationTitle("Post detail")
                 .navigationBarTitleDisplayMode(.inline)
                 .navigationBarItems(trailing: Button(action: {
                     updatePost(post: self.post)
                 }, label: {
                     Image(systemName: "star")
                 }))
                 
            }.padding(.leading,20)
                .padding(.trailing,20)
            
        }.onAppear{
            self.webService.getPostCopmments(with: Int(post.id))
            self.webService2.getUserInfo(with: Int(post.userId))
        }.onDisappear{
            self.webService2.clean()
            self.webService.clean()
        }
        
    }
    
    func updatePost(post: PostsEntity) {
        
        post.isFavorite = true
        do{
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        }catch let error as NSError {
            print("Error", error.localizedDescription)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetail(post: PostsEntity())
    }
}
