//
//  FetchedObjects.swift
//  MyPlaceholderJson
//
//  Created by iOS Development on 10/18/21.
//

import Foundation
import SwiftUI
import CoreData

struct FetchedObjects<T, Content>: View where T : NSManagedObject, Content : View {
    
    // MARK: - Properties
    
    let content: ([T]) -> Content
    
    var request: FetchRequest<T>
    var results: FetchedResults<T>{ request.wrappedValue }

    // MARK: - Lifecycle
    
    init(
        predicate: NSPredicate = NSPredicate(value: true),
        sortDescriptors: [NSSortDescriptor] = [],
        @ViewBuilder content: @escaping ([T]) -> Content
    ) {
        self.content = content
        self.request = FetchRequest(
            entity: T.entity(),
            sortDescriptors: sortDescriptors,
            predicate: predicate
        )
    }
    
    // MARK: - Body
    
    var body: some View {
        self.content(results.map { $0 })
    }
    
}
