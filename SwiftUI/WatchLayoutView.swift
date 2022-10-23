//
//  WatchLayoutView.swift
//  WatchLayout-SwiftUI
//
//  Created by Hoc Tran on 28/03/2021.
//

import SwiftUI
import WatchLayout

public struct WatchLayoutView<Data, Content>: UIViewRepresentable
    where Data: RandomAccessCollection, Content: View {
    
    private let layoutAttributes: WatchLayoutAttributes
    private let data: [Data.Element]
    private let content: (Data.Element) -> Content
    private let centeredIndex: Int?
    
    public func updateUIView(_ uiView: UICollectionView, context: Context) {
        context.coordinator.reloadData(data, layoutAttributes: layoutAttributes)
        if let centeredIndex = centeredIndex {
            context.coordinator.centerToIndexPath(IndexPath(item: centeredIndex, section: 0))
        }
    }
    
    public func makeCoordinator() -> WatchLayoutCoordinator<Data.Element, Content> {
        WatchLayoutCoordinator(layoutAtributes: layoutAttributes, content: content)
    }
    
    public func makeUIView(context: Context) -> UICollectionView {
        context.coordinator.collectionView
    }
    
    public init(layoutAttributes: WatchLayoutAttributes = WatchLayoutAttributes(),
                centeredIndex: Int? = nil,
                data: Data,
                @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.layoutAttributes = layoutAttributes
        self.centeredIndex = centeredIndex
        self.data = Array(data)
        self.content = content
    }
}

class WatchLayoutItemCell: UICollectionViewCell {
    
    private var hostingViewController: UIHostingController<AnyView>?
    
    func updateContent(_ content: AnyView) {
        if let hostingViewController = hostingViewController {
            hostingViewController.view.removeFromSuperview()
            hostingViewController.rootView = content
        } else {
            hostingViewController = UIHostingController(rootView: content)
        }
        
        fitting()
    }
    
    private func fitting() {
        guard let view = hostingViewController?.view else {
            return
        }
        
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}

public class WatchLayoutCoordinator<T, Content: View>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let collectionView: UICollectionView
    private let cellId = "cell"
    private var items: [T] = []
    private let content: (T) -> Content
    
    init(layoutAtributes: WatchLayoutAttributes, @ViewBuilder content: @escaping (T) -> Content) {
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: WatchLayout().withAttributes(layoutAtributes))
        self.content = content
        
        super.init()
        
        self.collectionView.register(WatchLayoutItemCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    
    func reloadData(_ data: [T], layoutAttributes: WatchLayoutAttributes) {
        
        let shouldReCenter = items.isEmpty && !data.isEmpty
        
        items = data
        
        if let layout = self.collectionView.collectionViewLayout as? WatchLayout,
           layout.layoutAttributes != layoutAttributes {
            collectionView.collectionViewLayout = WatchLayout().withAttributes(layoutAttributes)
        }
        collectionView.reloadData()
        
        if shouldReCenter {
            centerToIndexPath(IndexPath(item: 0, section: 0))
        }
    }
    
    func centerToIndexPath(_ idx: IndexPath) {
        
        guard !items.isEmpty else {
            return
        }
        
        let indexPath: IndexPath
        
        if (0..<items.count).contains(idx.item) {
            indexPath = idx
        } else {
            // to get the closest possible item for an invalid indexpath
            indexPath = IndexPath(item: items.endIndex, section: 0)
        }
        
        DispatchQueue.main.async {
            if let layout = self.collectionView.collectionViewLayout as? WatchLayout {
                let desiredOffset = layout.centeredOffsetForItem(indexPath: indexPath)
                if self.collectionView.contentOffset != desiredOffset {
                    self.collectionView.setContentOffset(desiredOffset, animated: true)
                }
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! WatchLayoutItemCell

        let ct = content(items[indexPath.item])
        if #available(iOS 14, *) {
            cell.updateContent(AnyView(ct.ignoresSafeArea()))
        } else {
            cell.updateContent(AnyView(ct))
        }
        
        return cell
    }
}

// MARK: - Helper attribute struct
public struct WatchLayoutAttributes: Equatable {
    public let itemSize: CGFloat
    public let spacing: CGFloat
    public let minScale: CGFloat
    public let nextItemScale: CGFloat
    
    public init(
        itemSize: CGFloat = 100,
        spacing: CGFloat = 0,
        minScale: CGFloat = 0.2,
        nextItemScale: CGFloat = 0.4
    ) {
        self.itemSize = itemSize
        self.spacing = spacing
        self.minScale = min(max(minScale, 0), 1)
        self.nextItemScale = min(max(nextItemScale, 0), 1)
    }
}

public extension WatchLayout {
    func withAttributes(_ layoutAttributes: WatchLayoutAttributes) -> WatchLayout {
        let r = WatchLayout()
        r.itemSize = layoutAttributes.itemSize
        r.spacing = layoutAttributes.spacing
        r.minScale = layoutAttributes.minScale
        r.nextItemScale = layoutAttributes.nextItemScale
        return r
    }
    
    var layoutAttributes: WatchLayoutAttributes {
        WatchLayoutAttributes(itemSize: itemSize,
                              spacing: spacing,
                              minScale: minScale,
                              nextItemScale: nextItemScale)
    }
}
