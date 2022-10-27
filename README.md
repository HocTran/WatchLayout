# WatchLayout

[![Version](https://img.shields.io/cocoapods/v/WatchLayout.svg?style=flat)](https://cocoapods.org/pods/WatchLayout)
[![License](https://img.shields.io/cocoapods/l/WatchLayout.svg?style=flat)](https://cocoapods.org/pods/WatchLayout)
[![Platform](https://img.shields.io/cocoapods/p/WatchLayout.svg?style=flat)](https://cocoapods.org/pods/WatchLayout)

## Requirements

iOS 13+

## Installation

### Cocoapods
WatchLayout is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

UIKit | SwiftUI
:-------------:|:-------------:
| `pod 'WatchLayout'` | `pod 'WatchLayout-SwiftUI'` |


### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/HocTran/WatchLayout.git", .upToNextMajor(from: "1.1.0"))
]
```

## Usage

### UIKit

```swift
let layout = WatchLayout()
```

**Support configurations**

Set the item size for collection view cell.
```swift
layout.itemSize = 200
```

Set the cell item spacing. Minus means the items can be overlapped. Default value 0.
```swift
layout.spacing = -40
```

Set the scaling for item next to the item in the center. Default value 0.4
```swift
layout.nextItemScale = 0.4
```

Set the minimum scaling for item depending on the distance to the center.  Default value 0.2
```swift
layout.minScale = 0.2
```

Assign the custom layout to UICollectionView
```swift
collectionView.collectionViewLayout = layout
```

Scroll to an item at the index path
```swift
self.collectionView.setContentOffset(layout.centeredOffsetForItem(indexPath: IndexPath(item: 0, section: 0)), animated: true)
```

Get the current centered index
```swift
layout.centeredIndexPath
```

### SwiftUI

SwiftUI version is built on top of `UIViewRepresentable` of `WatchLayout`.

Declare a layout attributes (See the detail of each param in the UIKit usage above).

```swift
@State var layout = WatchLayoutAttributes(
    itemSize: 120,
    spacing: 16,
    minScale: 0.2,
    nextItemScale: 0.6
)
```

Create and assign layout attributes to the view

* data: *RandomAccessCollection* (or *Binding<RandomAccessCollection>*) for computing the collection.

* centeredIndex: **(Optional)** A binding to indentify the centered index of the collection.

```swift
WatchLayoutView(
    layoutAttributes: layout,
    data: data,
    centeredIndex: $centeredIndex,
    cellContent: ({ dataElement in
        // Build up your cell content here
        Text(dataElement.description)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(dataElement.color)
            .clipShape(Circle())
})
```

If **data** element is *hashable*, the centered binding can be a data element.

```swift
WatchLayoutView(
    layoutAttributes: layout,
    data: data,
    centeredItem: $centeredItem,
    cellContent: ({ dataElement in
        // Build up your cell content here
        Text(dataElement.description)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(dataElement.color)
            .clipShape(Circle())
})
```

## Screenshots

Positioning | Scrolling
:-------------:|:-------------:
![](https://raw.githubusercontent.com/HocTran/WatchLayout/SwiftUI/Screenshots/positioning.gif)  |  ![](https://raw.githubusercontent.com/HocTran/WatchLayout/SwiftUI/Screenshots/scrolling.gif)


Example 01 | Example 02
:-------------:|:-------------:
![](https://raw.githubusercontent.com/HocTran/WatchLayout/SwiftUI/Screenshots/screenshot_01.png)  |  ![](https://raw.githubusercontent.com/HocTran/WatchLayout/SwiftUI/Screenshots/screenshot_02.png)


## Example

To run the example project, clone the repo, open `WatchLayout.xcworkspace`.

### UIKit

* Select scheme `WatchLayout`, **Cmd+B** to build the framework.

* Select scheme `Example-iOS`, and run the example.

### SwiftUI

* Select scheme `WatchLayout`, **Cmd+B** to build the framework.

* Select scheme `WatchLayout-SwiftUI`, **Cmd+B** to build the framework.

* Select scheme `Example-iOS`, and run the example.


## Author

HocTran, tranhoc78@gmail.com

## License

WatchLayout is available under the MIT license. See the [LICENSE file](LICENSE) for more info.
