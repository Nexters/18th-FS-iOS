//
//  HomeDetail.swift
//  Fullstack
//
//  Created by 김범준 on 2021/02/15.
//

import Foundation
import SwiftUI

struct HomeDeatilView: View {
    @Environment(\.presentationMode) var presentationMode

    @State var isEditing: Bool = false
    var items: [Screenshot]

    var body: some View {
        ZStack {
            Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Image(isEditing ? "ico_cancel" : "ico_back")
                        .padding(.top, 13)
                        .padding(.leading, isEditing ? 18 : 20)
                        .onTapGesture {
                            if isEditing {
                                isEditing = false
                            } else {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    if !isEditing {
                        Text("최근 순 스크린샷")
                            .font(Font.B1_BOLD)
                            .foregroundColor(Color.PRIMARY_1)
                            .padding(.top, 14)
                    }

                    Spacer()

                    if isEditing {
                        Image("ico_delete_active")
                            .padding(.top, 14)
                    } else {
                        Text("선택")
                            .font(Font.B1_REGULAR)
                            .foregroundColor(Color.KEY_ACTIVE)
                            .padding(.top, 14)
                            .onTapGesture {
                                isEditing = true
                            }
                    }
                }.padding(.trailing, 20)
                    .frame(minHeight: 60)

                ScrollView {
                    GridView(row: items.count / 3 + 1, columns: 3) { row, column in
                        let index = column * 3 + row

                        if items.count > index {
                            let screenshot = items[index]
                            CScreenShotView(screenshot: screenshot, nextView: LabelView(), width: 102, height: 221)
                        }
                    }.padding(EdgeInsets(top: 20, leading: 13, bottom: 20, trailing: 13))
                }
                Spacer()
            }
        }.navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
    }

    class VM: ViewModel {
        struct Input {
            let loadTrigger: Driver<Void>
            let reloadTrigger: Driver<Void>
            let loadMoreTrigger: Driver<Void>
            let selectRepoTrigger: Driver<IndexPath>
        }

        final class Output: ObservableObject {
            @Published var isLoading = false
            @Published var isReloading = false
            @Published var isLoadingMore = false
            @Published var isEmpty = false
        }

        func transform(_ input: Input, cancelBag: CancelBag) -> Output {
            Output()
        }
    }
}
