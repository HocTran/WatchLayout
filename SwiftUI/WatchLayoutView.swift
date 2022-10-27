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
import WatchLayout

public struct WatchLayoutView<Data, Content>: UIViewRepresentable
    where Data: RandomAccessCollection, Content: View {
    
    private let layoutAttributes: WatchLayoutAttributes
    
    private let data: Binding<Data>
    private let centeredIndex: Binding<Data.Index?>?
    
    private let content: (Data.Element) -> Content
    
    public func updateUIView(_ uiView: UICollectionView, context: Context) {
        context.coordinator.reloadData(Array(data.wrappedValue), layoutAttributes: layoutAttributes)
        if let centeredIndex = centeredIndex?.wrappedValue {
            context.coordinator.centerToIndexPath(IndexPath(item: data.wrappedValue.distance(from: data.wrappedValue.startIndex, to: centeredIndex), section: 0))
        }
    }
    
    public func makeCoordinator() -> WatchLayoutCoordinator<Data.Element, Content> {
        WatchLayoutCoordinator(layoutAtributes: layoutAttributes, content: content)
    }
    
    public func makeUIView(context: Context) -> UICollectionView {
        context.coordinator.collectionView
    }
    
    public init(layoutAttributes: WatchLayoutAttributes = WatchLayoutAttributes(),
                data: Binding<Data>,
                centeredIndex: Binding<Data.Index?>,
                @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.layoutAttributes = layoutAttributes
        self.centeredIndex = centeredIndex
        self.data = data
        self.content = content
    }
}

// MARK: - Listing Data

extension WatchLayoutView {
    public init(layoutAttributes: WatchLayoutAttributes = WatchLayoutAttributes(),
                data: Data,
                centeredIndex: Binding<Data.Index?>,
                @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self = .init(layoutAttributes: layoutAttributes, data: .constant(data), centeredIndex: centeredIndex, content: content)
    }
}

extension WatchLayoutView where Data.Element: Hashable {
    public init(layoutAttributes: WatchLayoutAttributes = WatchLayoutAttributes(),
                data: Data,
                centeredItem: Binding<Data.Element?>,
                @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self = .init(layoutAttributes: layoutAttributes, data: .constant(data), centeredItem: centeredItem, content: content)
    }
}

// MARK: - Listing bound Data

extension WatchLayoutView {
    public init(layoutAttributes: WatchLayoutAttributes = WatchLayoutAttributes(),
                data: Binding<Data>,
                @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self = .init(layoutAttributes: layoutAttributes, data: data, centeredIndex: .constant(nil), content: content)
    }
}

extension WatchLayoutView where Data.Element: Hashable {
    public init(layoutAttributes: WatchLayoutAttributes = WatchLayoutAttributes(),
                data: Binding<Data>,
                centeredItem: Binding<Data.Element?>,
                @ViewBuilder content: @escaping (Data.Element) -> Content) {
        let centeredIndex: Binding<Data.Index?>
        if let center = centeredItem.wrappedValue, let idx = data.wrappedValue.firstIndex(of: center) {
            centeredIndex = .constant(idx)
        } else {
            centeredIndex = .constant(nil)
        }
        
        self = .init(layoutAttributes: layoutAttributes, data: data, centeredIndex: centeredIndex, content: content)
    }
}
