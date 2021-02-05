//
//  AddNewLabelView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/02/02.
// 1_라벨링_라벨추가 화면

import SwiftUI

struct AddNewLabelView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    var body: some View {
        VStack {
            TextField("라벨을 입력하세요", text: $name)
                .padding(60)
                .frame(width: 252, height: 50, alignment: .trailing)
                .foregroundColor(.white)
                .background(Color(red: 197/255, green: 197/255, blue: 197/255))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.black)
                            .foregroundColor(.gray)
                            .frame(width: 20, height: 20, alignment: .leading)
                            .padding(.leading, -100)
                    }
                )
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing:
            Button(action: onClickedBackBtn) {
                Image(systemName: "arrow.left")
            }
        )
    }

    func onClickedBackBtn() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct AddNewLabelView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewLabelView()
    }
}
