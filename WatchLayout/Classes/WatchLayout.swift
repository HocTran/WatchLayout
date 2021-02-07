
import UIKit

final public class WatchLayout: UICollectionViewLayout {
    
    public var itemSize: CGFloat = 100 {
        didSet {
            invalidateLayout()
        }
    }
    
    public var spacing: CGFloat = 0 {
        didSet {
            invalidateLayout()
        }
    }
    
    private var _minScale: CGFloat = 0.2 {
        didSet {
            invalidateLayout()
        }
    }
    
    public var minScale: CGFloat {
        get {
            return _minScale
        }
        set {
            _minScale = min(max(newValue, 0), 1)
        }
    }
    
    public func centeredOffsetForItem(indexPath: IndexPath) -> CGPoint {
        guard let collectionView = self.collectionView else {
            return .zero
        }
        
        let attr = attributes[indexPath.item]
        return CGPoint(
            x: attr.center.x - collectionView.bounds.width * 0.5,
            y: attr.center.y - collectionView.bounds.height * 0.5
        )
    }
    
    private var attributes = [UICollectionViewLayoutAttributes]()
    private var layers = 1
    
    public override var collectionViewContentSize: CGSize {
        guard let collectionView = self.collectionView else {
            return .zero
        }
        
        let size = CGFloat(layers) * (itemSize + spacing) * 2 - (itemSize + spacing)
        let inset = collectionView.contentInset
        return CGSize(width: size + collectionView.bounds.width + inset.left + inset.right,
                      height: size + collectionView.bounds.height + inset.top + inset.bottom)
    }
    
    public override class var layoutAttributesClass: AnyClass {
        return UICollectionViewLayoutAttributes.self
    }
    
    public override func prepare() {
        
        super.prepare()
        
        guard let collectionView = self.collectionView else {
            return
        }
        
        if attributes.count == collectionView.numberOfItems(inSection: 0) {
            return
        }
        
        if collectionView.numberOfItems(inSection: 0) == 0 {
            return
        }
        
        let N = collectionView.numberOfItems(inSection: 0)
        let center = CGPoint.zero
        
        var i = 0
        var layer = 0
        
        attributes.removeAll()
        
        while i < N {
            
            if layer == 0 {
                let attr = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
                attr.size = CGSize(width: itemSize, height: itemSize)
                attr.center = center
                attributes.append(attr)
                
                i += 1
            } else {
            
                let radius = CGFloat(layer) * (itemSize + spacing)
                let hexagon = Multagon(6, center: center, radius: radius)
                
                for j in 0 ..< layer {
                
                    let vertexes = hexagon.midVertex(slice: layer, slideIndex: j)
                    for vertex in vertexes {
                        let attr = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
                        attr.size = CGSize(width: itemSize, height: itemSize)
                        attr.center = vertex
                        
                        attributes.append(attr)
                        i += 1
                        if i >= N {
                            break
                        }
                    }
                }
            }
            
            layer += 1
        }
        
        layers = max(layer, 1)
        
        // move all to center
        let size = CGFloat(layers) * (itemSize + spacing) * 2 - (itemSize + spacing)
        let inset = collectionView.contentInset
        
        attributes.forEach { attr in
            attr.center = CGPoint(
                x: attr.center.x + size * 0.5 + inset.left + collectionView.bounds.width * 0.5,
                y: attr.center.y + size * 0.5 + inset.top + collectionView.bounds.height * 0.5
            )
        }
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        guard let collectionView = self.collectionView else {
            return nil
        }
        
        let center = CGPoint(x: collectionView.bounds.midX, y: collectionView.bounds.midY)
        let result = attributes.filter { rect.intersects($0.frame) }
        result.forEach { attr in
            if rect.contains(attr.frame) {
                let distance = CGPoint.distance(center, attr.center)

                var scale = 1 - (1 - minScale) * distance / itemSize // 0.8 is scale at 1 itemsize distance
                scale = min(max(scale, minScale), 1)
                attr.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        return result
    }
    
//    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        guard let collectionView = self.collectionView else {
//            return nil
//        }
//    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    //auto snap to center of item
    public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else {
            return proposedContentOffset
        }
        
        let proposedCenter = CGPoint(x: proposedContentOffset.x + collectionView.bounds.width * 0.5,
                                     y: proposedContentOffset.y + collectionView.bounds.height * 0.5)
        
        let closestAttr = attributes.min { (attr1, attr2) -> Bool in
            return CGPoint.distance(attr1.center, proposedCenter) < CGPoint.distance(attr2.center, proposedCenter)
            
        }
        
        if let attr = closestAttr {
            
            let expectedOffset = CGPoint(x: attr.center.x - proposedCenter.x + proposedContentOffset.x,
                                         y: attr.center.y - proposedCenter.y + proposedContentOffset.y)
            return expectedOffset
        } else {
            return proposedContentOffset
        }
    }
}

// Helper
private extension CGPoint {
    static func distance(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
        return sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y))
    }
}

private struct Multagon {
    
    let vertexes: [CGPoint]
    
    init(_ numberOfVertex: Int, center: CGPoint, radius: CGFloat) {
        vertexes = (0..<numberOfVertex).map { i in
            CGPoint(
                x: center.x - radius * cos(CGFloat(i) * CGFloat.pi / 3),
                y: center.y - radius * sin(CGFloat(i) * CGFloat.pi / 3))
        }
    }
    
    func midVertex(slice: Int, slideIndex: Int) -> [CGPoint] {
        if slice == 0 {
            return []
        }
        if slice == 1 || slideIndex == 0 || slideIndex == slice {
            return vertexes
        }
        
        let i = CGFloat(slideIndex)
        let s = CGFloat(slice)
        
        var shifted = vertexes
        let first = shifted.remove(at: 0)
        shifted.append(first)
        
        return zip(vertexes, shifted).map { (a, b) -> CGPoint in
            CGPoint(x: a.x + (b.x - a.x) / s * i, y: a.y + (b.y - a.y) / s * i)
        }
    }
}
