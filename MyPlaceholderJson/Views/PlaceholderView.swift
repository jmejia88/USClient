//
//  PlaceholderView.swift
//  MyPlaceholderJson
//
//  Created by iOS Development on 10/16/21.
//

import SwiftUI

struct PlaceholderView: View {
    @ObservedObject  var webService = WebService()
    @State private var favoriteColor = 0
    @State private var predicate: NSPredicate = NSPredicate(value: true)
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: PostsEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \PostsEntity.id, ascending: true),
        ]
    ) var posts: FetchedResults<PostsEntity>
            
    var body: some View {
        NavigationView{
            VStack{
                Picker("What is your favorite color?", selection: $favoriteColor) {
                    Text("All").tag(0)
                    Text("Favorites").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.leading,20)
                .padding(.trailing,20)
                .onChange(of: favoriteColor) { tag in
                    print("Color tag: \(tag)")
                    if(tag == 1){
                        self.predicate = NSPredicate(format: "isFavorite == 1")
                        
                    }else{
                        self.predicate = NSPredicate(value: true)
                    }
                }
                FetchedObjects(
                    predicate: predicate,
                    sortDescriptors: [
                        NSSortDescriptor(key: "id", ascending: true)
                    ])
                { (posts: [PostsEntity]) in
                    List{
                        ForEach(posts){ post in
                            ZStack{
                                NavigationLink(destination: PostDetail(post: post)) {
                                    EmptyView()
                                }
                                Button(action: {
                                    updatePost(post: post)
                                    print("Floating Button Click")
                                }, label: {
                                    VStack (alignment: .leading){
                                        HStack{
                                            if(!post.isRead){
                                                Image(systemName: "circle.fill")
                                                    .foregroundColor(.blue)
                                            }
                                            if(post.isFavorite){
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(.yellow)
                                            }
                                            VStack{
                                                Text(post.title!)
                                                    .font(.title3)
                                                    .bold()
                                                Text(post.body!)
                                                    .font(.subheadline)
                                            }
                                        }
                                        
                                        
                                    }
                                })
                            }
                        }.onDelete(perform: self.deleteRow)
                        
                    }.listStyle(.plain)
                        .navigationTitle("Posts")
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarItems(trailing: Button(action: {
                            self.webService.getPosts()
                        }, label: {
                            Image(systemName: "arrow.clockwise.circle")
                        }))
                        
                    Button(action: {
                        self.webService.deleteAll()
                        
                        print("Delete Button Click")
                    }, label: {
                        Text("Delete all")
                            .font(.title3)
                            .bold()
                            .padding()
                            .background(Color.red)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                    })
                }
                
                
            }
        }
        
    }
    
    func updatePost(post: PostsEntity) {
        
        post.isRead = true
        do{
            try viewContext.save()
          
        }catch let error as NSError {
            print("Error", error.localizedDescription)
        }
    }
    
    func deleteRow(at indexSet: IndexSet){
        for index in indexSet {
                let post = posts[index]
                viewContext.delete(post)
            }
    }

}

struct PlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderView()
    }
}

