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
        itemSize: 120,
        spacing: 16,
        minScale: 0.2,
        nextItemScale: 0.6
    )
    
    @State var centerIndexPath: IndexPath?
    
    let data = 0..<100
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                WatchLayoutView(attributes: $layout, centeredIndexPath: $centerIndexPath, data: data) { i in
                    Text("\(i)")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(self.randomColor())
                        .clipShape(Circle())
                }
                .ignoresSafeArea()
                .onAppear {
                    self.centerIndexPath = IndexPath(item: 0, section: 0)
                }
                .navigationTitle("Example 1")
                .toolbar {
                    NavigationLink(destination: ImagesView()) {
                        Text("Images")
                    }
                }
            }
        }
    }
    
    
    func randomColor() -> Color {
        let r: Range<Double> = 0..<1
        return Color(.sRGB, red: Double.random(in: r), green: Double.random(in: r), blue: Double.random(in: r), opacity: 1)
    }
}
