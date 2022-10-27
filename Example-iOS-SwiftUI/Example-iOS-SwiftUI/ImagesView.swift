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

struct ImagesView: View {
    @State var layout = WatchLayoutAttributes(
        itemSize: 200,
        spacing: -40,
        minScale: 0.2,
        nextItemScale: 0.4
    )
    
    @State var data = 0..<17
    @State var centeredItem: Int? = 0
    
    var body: some View {
        
        WatchLayoutView(layoutAttributes: layout, data: $data, centeredItem: $centeredItem) { i in
            Image("\(i)")
                .resizable()
                .clipShape(Circle())
        }
        .ignoresSafeArea()
        
        Button("Change center") {
            centeredItem = data.indices.randomElement()!
        }
    }
}

struct ImagesView_Previews: PreviewProvider {
    static var previews: some View {
        ImagesView()
    }
}
