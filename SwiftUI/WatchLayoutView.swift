//
//  WatchLayoutView.swift
//  WatchLayout-SwiftUI
//
//  Created by Hoc Tran on 28/03/2021.
//

import SwiftUI

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
        let collectionView = CollectionView(layoutAttributes: attributes, data: data, content: content)
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

class ItemCell: UICollectionViewCell {
    
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
        
        view.backgroundColor = .red.withAlphaComponent(0.5)
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
    
    var collectionView: CollectionView<T, Content>?
    
    func setCollectionView(_ collectionView: CollectionView<T, Content>) {
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

class CollectionView<T, Content: View>: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let cellId = "cell"
    private let items: [T]
    private let content: (T) -> Content

    init(layoutAttributes: WatchLayoutAttributes, data: [T], @ViewBuilder content: @escaping (T) -> Content) {
        let layout = WatchLayout().withAttributes(layoutAttributes)
        self.items = data
        self.content = content
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.register(ItemCell.self, forCellWithReuseIdentifier: cellId)
        self.dataSource = self
        
        self.backgroundColor = .lightGray
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ItemCell

        let ct = content(items[indexPath.item]).ignoresSafeArea() // iOS 15 sizing fix only.
        cell.updateContent(AnyView(ct))
        return cell
    }
}
