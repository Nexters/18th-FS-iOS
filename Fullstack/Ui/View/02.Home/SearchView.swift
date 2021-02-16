//
//  SearchView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/01/22.
//

import SwiftUI

struct SearchView: View {
    let screenshots: [Screenshot] = [
        Screenshot(id: 0, imageName: "sc0"),
        Screenshot(id: 1, imageName: "sc1"),
        Screenshot(id: 2, imageName: "sc2"),
        Screenshot(id: 3, imageName: "sc3"),
        Screenshot(id: 4, imageName: "sc3"),
        Screenshot(id: 5, imageName: "sc3"),
        Screenshot(id: 6, imageName: "sc3"),
        Screenshot(id: 7, imageName: "sc3")
    ]

    @State var isEditing: Bool = false
    @State var keyword: String = ""
    @State var labels: [LabelEntity] = [LabelEntity(id: "", name: "안녕", color: ColorSet.RED(), images: [], createdAt: Date()), LabelEntity(id: "", name: "안녕", color: ColorSet.RED(), images: [], createdAt: Date()), LabelEntity(id: "", name: "안녕", color: ColorSet.RED(), images: [], createdAt: Date()), LabelEntity(id: "", name: "안녕", color: ColorSet.RED(), images: [], createdAt: Date())]

    var body: some View {
        ScrollView {
            VStack {
                if !isEditing {
                    HStack(alignment: .firstTextBaseline) {
                        Text("홈")
                            .font(Font.H1_BOLD)
                            .foregroundColor(Color.PRIMARY_1)
                            .padding(EdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 0))
                        Spacer()
                        Image("ico_profile")
                            .padding(EdgeInsets(top: 23, leading: 0, bottom: 0, trailing: 21))
                    }.frame(minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 0,
                            maxHeight: 60,
                            alignment: .topLeading)
                }

                SearchBar(keyword: $keyword, isEditing: $isEditing, labels: $labels)
                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))

                if isEditing {
                } else {
                    buildSection(title: "최근 순 사진")
                    buildSection(title: "즐겨찾는 스크린샷")
                }
            }
        }.background(Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all))
            .navigationBarTitle("")
            .navigationBarHidden(true)
    }

    @ViewBuilder
    func buildSection(title: String) -> some View {
        HStack {
            Text(title)
                .font(Font.B1_BOLD)
                .foregroundColor(Color.PRIMARY_1)

            Spacer()

            NavigationLink(destination: HomeDeatilView(items: screenshots)) {
                Image("icon_arrow")
            }
        }.padding(EdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 14))

        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(screenshots, id: \.id) {
                    screenshot in CScreenShotView(screenshot: screenshot, nextView: HomeDeatilView(items: screenshots), width: 90, height: 195)
                }
            }.padding(.leading, 16).padding(.trailing, 16)
        }
    }
}
