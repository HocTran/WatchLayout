//
//  WatchLayoutView.swift
//  WatchLayout-SwiftUI
//
//  Created by Hoc Tran on 28/03/2021.
//

import SwiftUI

public struct WatchLayoutView<DataSource, Content>: UIViewRepresentable
    where DataSource : RandomAccessCollection, Content : View, DataSource.Element : Identifiable {
    
    @Binding var attributes: WatchLayoutAttributes
    
    
    private let views: [AnyView]
    private let collectionView: CollectionView
    
    public func updateUIView(_ uiView: UICollectionView, context: Context) {
        uiView.collectionViewLayout.invalidateLayout()
    }
    
    public func makeUIView(context: Context) -> UICollectionView {
        return collectionView
    }
    
    public init(attributes: Binding<WatchLayoutAttributes>, datasource: DataSource, content: @escaping (DataSource.Element) -> Content) {
        self._attributes = attributes
        
        self.views = datasource.map { i -> AnyView in
            AnyView(content(i))
        }
        
        self.collectionView = CollectionView(layoutAttributes: attributes.wrappedValue)
        self.collectionView.updateItems(self.views)
    }
    
    public func centerToIndex(_ indexPath: IndexPath) -> Self {
        DispatchQueue.main.async {
            if let layout = self.collectionView.collectionViewLayout as? WatchLayout {
                self.collectionView.setContentOffset(layout.centeredOffsetForItem(indexPath: indexPath), animated: true)
            }
        }
        
        return self
    }
}

class ItemCell: UICollectionViewCell {
    
}

class CollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var hostingUITag = 1
    private var cellId = "cell"
    private var items = [UIHostingController<AnyView>]()
    func updateItems(_ items: [AnyView]) {
        self.items = items.map {
            UIHostingController(rootView: $0)
        }
        self.reloadData()
    }
    
    init(layoutAttributes: WatchLayoutAttributes) {
        let layout = WatchLayout()
        layout.layoutAttributes = layoutAttributes
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.register(ItemCell.self, forCellWithReuseIdentifier: cellId)
        
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        let view = cell.contentView.viewWithTag(hostingUITag)
        if items[indexPath.item].view !== view {
            cell.contentView.viewWithTag(hostingUITag)?.removeFromSuperview()
            
            let newView = items[indexPath.item].view!
            newView.backgroundColor = .clear
            newView.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(newView)
            NSLayoutConstraint.activate([
                newView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                newView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                newView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                newView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            ])
            
            items[indexPath.item].view.tag = hostingUITag
        }
        
        return cell
    }
}
