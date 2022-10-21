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
    
    @State var data = 0..<10
    
    @State var name = "Hello"
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack {
                    
                    WatchLayoutView(layoutAttributes: layout, centeredIndex: $centeredIndex, data: data) { i in
                        Text("\(i)")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(self.randomColor())
                            .clipShape(Circle())
                    }
                    .ignoresSafeArea()
                    
                    VStack {
                        ForEach(data, id: \.self) {
                            Text($0.description)
                                .background(self.randomColor())
                        }
                    }

                    VStack(spacing: 16) {
                        Button("Change data") {
                            data = (0..<10).randomElement()!..<(10..<20).randomElement()!
                        }

                        Button("Change center") {
                            centeredIndex = (0..<data.count).randomElement()!
                        }

                        Button("Change layout config") {
                            layout = WatchLayoutAttributes(itemSize: CGFloat((60...200).randomElement()!))
                        }
                    }
                    
                    Text(name)
                    
                    Button("Change text") {
//                        name = "Hello" + (0..<15).randomElement()!.description
                        name = "Hello" + (data.count.description) + (0..<15).randomElement()!.description
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
    
    
    func randomColor() -> Color {
        let r: Range<Double> = 0..<1
        return Color(.sRGB, red: Double.random(in: r), green: Double.random(in: r), blue: Double.random(in: r), opacity: 1)
    }
}
