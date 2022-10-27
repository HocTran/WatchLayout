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
    
    @State var centeredIndex: Int? = 0
    
    @State var data = (0..<10).map { CellItem(id: $0) }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack {
                    
                    WatchLayoutView(layoutAttributes: layout, centeredIndex: $centeredIndex, data: $data) { i in
                        Text("\(i.id)")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(i.color)
                            .clipShape(Circle())
                    }
                    .ignoresSafeArea()
                    .onChange(of: centeredIndex) { newValue in
                        print(newValue)
                    }
                    
                    
                    VStack(spacing: 16) {
                        
                        Text("Selected item: \(centeredIndex ?? -1)")
                        
                        Button("Change data") {
                            data = (0..<(10..<40).randomElement()!).map { CellItem(id: $0) }
                        }

                        Button("Change center") {
                            centeredIndex = (0..<data.count).randomElement()!
                        }

                        Button("Change layout config") {
                            layout = WatchLayoutAttributes(itemSize: CGFloat((60...200).randomElement()!))
                        }
                    }
                }
                
                .navigationTitle("Example 1")
                .toolbar {
                    NavigationLink(destination: ImagesView()) {
                        Text("Images")
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct CellItem {
    
    let id: Int
    let color: Color
    
    static let colors: [Color] = [
        .red, .blue, .gray, .green, .orange, .pink, .purple, .yellow
    ]
    
    init(id: Int) {
        self.id = id
        color = Self.colors.randomElement()!
    }
}
