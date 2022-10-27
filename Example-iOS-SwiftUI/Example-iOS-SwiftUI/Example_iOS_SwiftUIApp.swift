//
//  Copyright (c) 2021 Hoc Tran (https://hoctran.com/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
    
    @State var data = (0..<1000).map { CellItem(id: $0) }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack {
                    
                    WatchLayoutView(layoutAttributes: layout, data: data, centeredIndex: $centeredIndex) { i in
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
                            data = (0..<(1000..<1500).randomElement()!).map { CellItem(id: $0) }
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
