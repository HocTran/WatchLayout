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
    let data = (0..<100).map {
        Item(id: $0, text: "\($0)")
    }
    
    public var body: some Scene {
        WindowGroup {
            
            WatchLayoutView(attributes: $layout, datasource: data) { i in
                Text("\(i.text)")
                    .foregroundColor(Color(.red))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.white))
                    .cornerRadius(80)
                    .clipped()
            }
            .centerToIndex(IndexPath(item: 0, section: 0))
        }
    }
}


struct Item: Identifiable {
    let id: Int
    let text: String
}