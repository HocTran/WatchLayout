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

import UIKit
import WatchLayout

class ViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!
    private var items = [UIColor]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let r: Range<CGFloat> = 0..<1
        items = (0..<100).map { i -> UIColor in
            UIColor(
                red: CGFloat.random(in: r),
                green: CGFloat.random(in: r),
                blue: CGFloat.random(in: r),
                alpha: 1)
        }
        
        let layout = WatchLayout()
        layout.itemSize = 120
        layout.spacing = -16
        layout.nextItemScale = 0.6
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
