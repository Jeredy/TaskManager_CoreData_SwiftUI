//
//  DynamicFilteredView.swift
//  TaskManager_CoreData_SwiftUI
//
//  Created by André Almeida on 2022-08-09.
//

import SwiftUI
import CoreData

struct DynamicFilterdView<Content: View,T>: View where T: NSManagedObject {
    //MARK: Core Data Request
    @FetchRequest var request: FetchedResults<T>
    let content: (T)->Content
    
    //MARK: Building Custom FroEach which will give CoreData object to build view
    init(dateToFilter: Date, @ViewBuilder content: @escaping (T)->Content) {
        
        // Initializing Request with NSPredicate
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [], predicate: nil)
        self.content = content
    }
    
    var body: some View {
        Group {
            if request.isEmpty {
                Text("No tasks found!!")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
            } else {
                ForEach(request, id: \.objectID) { object in
                    self.content(object)
                }
            }
        }
    }
}
