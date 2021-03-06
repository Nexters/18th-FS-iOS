//
//  LabelViewFromOutside.swift
//  ShareSheet
//
//  Created by 우민지 on 2021/02/15.
//

import SwiftUI

func giveLabelBackgroundColor(color: String) -> Color {
    switch color {
    case "Yellow":
        return Color(red: 232/255, green: 194/255, blue: 93/255).opacity(0.15)
    case "Red":
        return Color(red: 199/255, green: 103/255, blue: 97/255).opacity(0.15)
    case "Violet":
        return Color(red: 160/255, green: 110/255, blue: 229/255).opacity(0.15)
    case "Blue":
        return Color(red: 76/255, green: 166/255, blue: 255/255).opacity(0.15)
    case "Green":
        return Color(red: 62/255, green: 168/255, blue: 122/255).opacity(0.15)
    case "Orange":
        return Color(red: 236/255, green: 145/255, blue: 71/255).opacity(0.15)
    case "Pink":
        return Color(red: 224/255, green: 137/255, blue: 181/255).opacity(0.15)
    case "Cobalt_Blue":
        return Color(red: 101/255, green: 101/255, blue: 229/255).opacity(0.15)
    case "Peacock_Green":
        return Color(red: 82/255, green: 204/255, blue: 204/255).opacity(0.15)
    case "Gray":
        return Color(red: 123/255, green: 131/255, blue: 153/255).opacity(0.15)
    default:
        return Color(red: 255/255, green: 255/255, blue: 255/255).opacity(0.15)
    }
}

func giveTextForegroundColor(color: String) -> Color {
    switch color {
    case "Yellow":
        return Color(red: 255/255, green: 226/255, blue: 153/255)
    case "Red":
        return Color(red: 255/255, green: 167/255, blue: 153/255)
    case "Violet":
        return Color(red: 217/255, green: 194/255, blue: 255/255)
    case "Blue":
        return Color(red: 178/255, green: 217/255, blue: 255/255)
    case "Green":
        return Color(red: 177/255, green: 229/255, blue: 207/255)
    case "Orange":
        return Color(red: 255/255, green: 203/255, blue: 161/255)
    case "Pink":
        return Color(red: 255/255, green: 199/255, blue: 227/255)
    case "Cobalt_Blue":
        return Color(red: 191/255, green: 191/255, blue: 255/255)
    case "Peacock_Green":
        return Color(red: 161/255, green: 229/255, blue: 229/255)
    case "Gray":
        return Color(red: 204/255, green: 218/255, blue: 255/255)
    default:
        return Color(red: 255/255, green: 255/255, blue: 255/255)
    }
}

struct LabelViewFromOutside: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var keyword: String = ""
    @State private var numberOfMyLables: Int = 0
    @State var selectedLabels: [LabelEntity] = []
    @State var showAddLabelView: Bool = false
    @ObservedObject var output = Output()
    @ObservedObject var sharedImage: model // 전달 받은 객체
    @State var showToast = false
    var body: some View {
        NavigationView {
            ZStack {
                Color.DEPTH_3.edgesIgnoringSafeArea(.all)
                VStack {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Spacer(minLength: 70)
                            HStack {
                                Spacer()
                                Image(uiImage: sharedImage.imageData ?? UIImage())
                                    .resizable()
                                    .frame(width: 60, height: 131, alignment: .leading)
                                Spacer()
                            }
                            .padding(.bottom, 20)
                            HStack {
                                Spacer(minLength: 20)
                                ShareSheetSearchBarView(text: $keyword).font(Font.system(size: 16)).foregroundColor(Color.primary) // search bar
                                Spacer(minLength: 20)
                            }

                            Spacer(minLength: 40)
                            if self.keyword.isEmpty {
                                HStack {
                                    Text("내 라벨").font(Font.system(size: 14)).foregroundColor(Color.secondary)
                                    Text(" \(self.output.labels.count)").foregroundColor(Color.KEY_ACTIVE)
                                }.padding(.leading, 20)
                            } else {
                                if self.output.labels.filter { $0.name.contains(keyword) }.count > 0 {
                                    HStack {
                                        Text("검색 결과").font(Font.system(size: 14)).foregroundColor(Color.secondary)
                                        Text("\(self.output.labels.filter { $0.name.contains(keyword) }.count)").foregroundColor(Color.KEY_ACTIVE)
                                    }
                                } else {
                                    VStack(alignment: .leading) {
                                        Text("검색결과가 없습니다 ")
                                            .font(Font.system(size: 14)).foregroundColor(Color.secondary)
                                            .padding(.leading, 20)
                                        Spacer(minLength: 10)

                                        HStack {
                                            Text("\(keyword)").font(Font.system(size: 16)).foregroundColor(Color.secondary).offset(x: 8)
                                            NavigationLink(destination: AddLabelView(), isActive: $showAddLabelView) {
                                                Text("생성")
                                                    .onTapGesture {
                                                        self.showAddLabelView = true
                                                    }

                                            }.foregroundColor(Color.KEY)
                                                .font(Font.system(size: 14))
                                                .padding(8)
                                        }
                                        .background(Color.DEPTH_3)
                                        .cornerRadius(2)
                                        .border(Color.PRIMARY_4)
                                        .offset(x: 20)
                                    }
                                }
                            }
                            FlexibleView(data: self.output.labels.filter { keyword.isEmpty ? true : $0.name.contains(keyword) }, spacing: 8, alignment: HorizontalAlignment.leading) {
                                label in Button(action: {
                                    selectedLabels.insert(label, at: 0)

                                }) {
                                    Text(verbatim: label.name)
                                        .padding(8)
                                        .background(giveLabelBackgroundColor(color: self.output.colorSetToString(color: label.color)))
                                        .foregroundColor(giveTextForegroundColor(color: self.output.colorSetToString(color: label.color)))
                                }
                            }.padding([.leading], 20)
                        }
                        Spacer(minLength: 20)
                    }
                    VStack(alignment: .leading) {
                        HStack {
                            Text("추가한 라벨")
                            Text("\(selectedLabels.count)").foregroundColor(Color.KEY_ACTIVE)
                        }.padding([.leading, .top], 20)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(selectedLabels, id: \.self) { filter in
                                    Badge(name: filter.name, color: giveLabelBackgroundColor(color: self.output.colorSetToString(color: filter.color)), textColor: giveTextForegroundColor(color: self.output.colorSetToString(color: filter.color)), type: .removable {
                                        withAnimation {
                                            if let firstIndex = selectedLabels.firstIndex(of: filter) {
                                                selectedLabels.remove(at: firstIndex)
                                            }
                                        }

                                    })
                                        .transition(.opacity)
                                }
                            }
                        }.padding(20)

                    }.frame(width: UIScreen.main.bounds.width, height: 101)
                        .background(Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all))
                        .opacity(selectedLabels.count > 0 ? 1 : 0)
                }
                .navigationBarTitle(Text("스크린샷 라벨 추가"), displayMode: .inline)
                .navigationBarItems(leading:
                    Button(action: {}, label: {
                        Image("btn_cancel")
                    }),
                    trailing: Button(action: {
                        self.showToast = true
                        print("완료버튼 작동")
                    }, label: {
                        Text("완료").font(Font.system(size: 16))
                            .foregroundColor(Color.KEY_ACTIVE)
                    }))
            }
        }
        .overlay(overlayView: customToast(show: $showToast), show: $showToast)
    }

    class Output: ObservableObject {
        @Published var labels: [LabelEntity] = [
            LabelEntity(id: "1", name: "OOTD", color: ColorSet.RED(), images: [], createdAt: Date()),
            LabelEntity(id: "2", name: "컬러팔레트", color: ColorSet.BLUE(), images: [], createdAt: Date()),
            LabelEntity(id: "3", name: "UI 레퍼런스", color: ColorSet.GREEN(), images: [], createdAt: Date()),
            LabelEntity(id: "4", name: "편집디자인", color: ColorSet.GRAY(), images: [], createdAt: Date()),
            LabelEntity(id: "5", name: "채팅", color: ColorSet.CONBALT_BLUE(), images: [], createdAt: Date()),
            LabelEntity(id: "6", name: "meme 모음", color: ColorSet.YELLOW(), images: [], createdAt: Date()),
            LabelEntity(id: "7", name: "글귀", color: ColorSet.ORANGE(), images: [], createdAt: Date()),
            LabelEntity(id: "8", name: "장소(공연, 전시 등)", color: ColorSet.GRAY(), images: [], createdAt: Date()),
            LabelEntity(id: "9", name: "영화", color: ColorSet.YELLOW(), images: [], createdAt: Date()),
            LabelEntity(id: "10", name: "네일", color: ColorSet.ORANGE(), images: [], createdAt: Date()),
            LabelEntity(id: "11", name: "맛집", color: ColorSet.GRAY(), images: [], createdAt: Date()),
            LabelEntity(id: "12", name: "인테리어", color: ColorSet.GRAY(), images: [], createdAt: Date())
        ]

        func colorSetToString(color: ColorSet) -> String {
            switch color {
            case .YELLOW:
                return "Yellow"
            case .RED:
                return "Red"
            case .VIOLET:
                return "Violet"
            case .BLUE:
                return "Blue"
            case .GREEN:
                return "Green"
            case .ORANGE:
                return "Orange"
            case .PINK:
                return "Pink"
            case .CONBALT_BLUE:
                return "Cobalt_Blue"
            case .PEACOCK_GREEN:
                return "Peacock_Green"
            case .GRAY:
                return "Gray"
            }
        }
    }
}
