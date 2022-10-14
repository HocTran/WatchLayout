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
    
    @Binding var attributes: WatchLayoutAttributes
    @Binding var centeredIndexPath: IndexPath?
    
    private let data: [Data.Element]
    private let content: (Data.Element) -> Content
    
    public func updateUIView(_ uiView: UICollectionView, context: Context) {
        uiView.collectionViewLayout = WatchLayout().withAttributes(attributes)
        context.coordinator.centerToIndexPath(centeredIndexPath)
    }
    
    public func makeCoordinator() -> WatchLayoutCoordinator<Data.Element, Content> {
        WatchLayoutCoordinator()
    }
    
    public func makeUIView(context: Context) -> UICollectionView {
        let collectionView = WatchLayoutCollectionView(layoutAttributes: attributes, data: data, content: content)
        context.coordinator.setCollectionView(collectionView)
        return collectionView
    }
    
    public init(attributes: Binding<WatchLayoutAttributes>, centeredIndexPath: Binding<IndexPath?> = .constant(nil), data: Data, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self._attributes = attributes
        self._centeredIndexPath = centeredIndexPath
        
        self.data = data.map { $0 }
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

public class WatchLayoutCoordinator<T, Content: View> {
    
    private var collectionView: WatchLayoutCollectionView<T, Content>?
    
    func setCollectionView(_ collectionView: WatchLayoutCollectionView<T, Content>) {
        self.collectionView = collectionView
    }
    
    func centerToIndexPath(_ indexPath: IndexPath?) {
        guard let indexPath = indexPath, let collectionView = self.collectionView else {
            return
        }
        
        DispatchQueue.main.async {
            if let layout = collectionView.collectionViewLayout as? WatchLayout {
                collectionView.setContentOffset(layout.centeredOffsetForItem(indexPath: indexPath), animated: true)
            }
        }
    }
}

class WatchLayoutCollectionView<T, Content: View>: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let cellId = "cell"
    private let items: [T]
    private let content: (T) -> Content

    init(layoutAttributes: WatchLayoutAttributes, data: [T], @ViewBuilder content: @escaping (T) -> Content) {
        let layout = WatchLayout().withAttributes(layoutAttributes)
        self.items = data
        self.content = content
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.register(WatchLayoutItemCell.self, forCellWithReuseIdentifier: cellId)
        self.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
public struct WatchLayoutAttributes {
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
}
