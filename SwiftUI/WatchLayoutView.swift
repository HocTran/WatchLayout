//
//  WatchLayoutView.swift
//  WatchLayout-SwiftUI
//
//  Created by Hoc Tran on 28/03/2021.
//

import SwiftUI

public struct WatchLayoutView<Data, Content>: UIViewRepresentable
    where Data: RandomAccessCollection, Content: View {
    
    private let attributes: WatchLayoutAttributes
    private let data: [Data.Element]
    private let collectionView: CollectionView<Data.Element, Content>
    private let content: (Data.Element) -> Content
    
    public func updateUIView(_ uiView: UICollectionView, context: Context) {
        uiView.collectionViewLayout.invalidateLayout()
    }
    
    public func makeUIView(context: Context) -> UICollectionView {
        return collectionView
    }
    
    public init(attributes: WatchLayoutAttributes, data: Data, content: @escaping (Data.Element) -> Content) {
        self.attributes = attributes
        self.content = content
        self.data = data.map { $0 }
        self.collectionView = CollectionView(layoutAttributes: attributes, data: self.data, content: content)
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

class ItemCell<Content: View>: UICollectionViewCell {
    
    private var hostingViewController: UIHostingController<Content>?
    
    func updateContent(_ content: Content) {
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

class CollectionView<T, Content: View>: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let cellId = "cell"
    private let items: [T]
    private let content: (T) -> Content

    init(layoutAttributes: WatchLayoutAttributes, data: [T], content: @escaping (T) -> Content) {
        let layout = WatchLayout()
        layout.setAttributes(layoutAttributes)
        self.items = data
        self.content = content
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.register(ItemCell<Content>.self, forCellWithReuseIdentifier: cellId)
        
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ItemCell<Content>
        cell.updateContent(content(items[indexPath.item]))
        return cell
    }
}
