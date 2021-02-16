//
//  CustomWidget.swift
//  Fullstack
//
//  Created by 김범준 on 2021/02/14.
//

import Foundation
import SwiftUI

struct CTextField: View {
    var placeholder: Text
    @Binding var text: String
    var commit: () -> () = {}
    @Binding var labels: [LabelEntity]
    @Binding var isEditing: Bool

    var body: some View {
        GeometryReader { fullView in
            ZStack(alignment: .leading) {
                if text.isEmpty { placeholder }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        if !labels.isEmpty && isEditing {
                            ForEach(labels, id: \.id) { label in
                                Text(label.name)
                            }
                        }
                        TextField(
                            "",
                            text: $text,
                            onEditingChanged: { isEditing in
                                print("asdasdasd \(isEditing)")
                                self.isEditing = isEditing
                            }, onCommit: commit
                        ).frame(width: fullView.size.width)
                    }
                }
            }.background(Color.red)
        }
    }
}

struct GridView<Content: View>: View {
    let columns: Int
    let row: Int
    let content: (Int, Int) -> Content

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(0 ..< row, id: \.self) { row in
                HStack {
                    ForEach(0 ..< columns, id: \.self) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }

    init(row: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.row = row
        self.columns = columns
        self.content = content
    }
}
