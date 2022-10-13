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
    
    @State var centerIndexPath: IndexPath? = IndexPath(item: 0, section: 0)
    
    let data = 0..<200
    
    var body: some Scene {
        WindowGroup {
            
            WatchLayoutView(attributes: $layout, centeredIndexPath: $centerIndexPath, data: data) { i in
                if i % 2 == 0 {
                    Text("\(i)")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(self.color(i))
                        .clipShape(Circle())
                } else {
                    ZStack {
                        self.color(i)
                        Text("\(i)")
                    }
                }
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                Button("Configuration 1") {
                    self.layout = WatchLayoutAttributes(
                        itemSize: 400,
                        spacing: 0,
                        minScale: 0.4,
                        nextItemScale: 0.6
                    )
                }
                
                Button("Configuration 2") {
                    self.layout = WatchLayoutAttributes(
                        itemSize: 160,
                        spacing: -16,
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
    
    
    func color(_ i: Int) -> Color {
        let colors: [Color] = [
            .red, .orange, .yellow, .green, .blue, .purple
        ]
        return colors[i % colors.count]
    }
}
