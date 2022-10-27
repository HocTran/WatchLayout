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
import UIKit
import WatchLayout

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

