//
//  ViewController.swift
//  WatchLayout
//
//  Created by 13203384 on 02/07/2021.
//  Copyright (c) 2021 13203384. All rights reserved.
//

import UIKit
import WatchLayout

class ViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!
    private var items = [UIColor]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let r: Range<CGFloat> = 0..<1
        items = (0..<19).map { i -> UIColor in
            UIColor(
                red: CGFloat.random(in: r),
                green: CGFloat.random(in: r),
                blue: CGFloat.random(in: r),
                alpha: 1)
        }
        
        let layout = WatchLayout()
        layout.itemSize = 200
        layout.spacing = -40
        layout.minScale = 0.2
        
        collectionView.collectionViewLayout = layout
        
        DispatchQueue.main.async {
            self.collectionView.setContentOffset(layout.centeredOffsetForItem(indexPath: IndexPath(item: 0, section: 0)), animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.backgroundColor = items[indexPath.item]
        cell.label.text = "\(indexPath.item)"
        return cell
    }
}

extension ViewController {
    
}
