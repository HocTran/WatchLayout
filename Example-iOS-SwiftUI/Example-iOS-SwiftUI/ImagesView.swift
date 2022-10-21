//
//  ImagesView.swift
//  Example-iOS-SwiftUI
//
//  Created by hocairmee on 2022-10-14.
//

import SwiftUI
import WatchLayout_SwiftUI

struct ImagesView: View {
    @State var layout = WatchLayoutAttributes(
        itemSize: 200,
        spacing: -40,
        minScale: 0.2,
        nextItemScale: 0.4
    )
    
    @State var centeredIndex: Int?
    
    let data = 0...17
    
    var body: some View {
        WatchLayoutView(layoutAttributes: layout, centeredIndex: $centeredIndex, data: data) { i in
            Image("\(i)")
                .resizable()
                .clipShape(Circle())
        }
        .onAppear {
            centeredIndex = 0
        }
        .ignoresSafeArea()
    }
}

struct ImagesView_Previews: PreviewProvider {
    static var previews: some View {
        ImagesView()
    }
}
