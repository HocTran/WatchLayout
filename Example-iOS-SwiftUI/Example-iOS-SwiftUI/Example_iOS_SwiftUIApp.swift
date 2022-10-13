//
//  Example_iOS_SwiftUIApp.swift
//  Example-iOS-SwiftUI
//
//  Created by Hoc Tran on 28/03/2021.
//

import SwiftUI
import WatchLayout_SwiftUI

@main
struct Example_iOS_SwiftUIApp: App {
    
    @State var layout = WatchLayoutAttributes(
        itemSize: 160,
        spacing: -16,
        minScale: 0.4,
        nextItemScale: 0.6
    )
    
    @State var centerIndexPath: IndexPath? = nil
    
    let data = (0..<20).map {
        Item(id: $0, text: "\($0)")
    }
    
    public var body: some Scene {
        WindowGroup {
            VStack {
                WatchLayoutView(attributes: $layout, centeredIndexPath: $centerIndexPath, data: data) { i in
                    if i.id % 2 == 0 {
                        Text("\(i.text)")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.gray)
                            .clipShape(Circle())
                    } else {
                        Text("\(i.text)")
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
                
                Button("Change configuration") {
                    self.layout = WatchLayoutAttributes(
                        itemSize: 400,
                        spacing: 0,
                        minScale: 0.4,
                        nextItemScale: 0.6
                    )
                }
                
                Button("Change center") {
                    self.centerIndexPath = IndexPath(item: 0, section: 0)
                }
            }
        }
    }
}


struct Item: Identifiable {
    let id: Int
    let text: String
}
