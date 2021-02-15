//
//  FullstackApp.swift
//  Fullstack
//
//  Created by 우민지 on 2021/01/16.
//

import SwiftUI

@main
struct FullstackApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                AppView()
            }.background(Color.DEPTH_4_BG)
        }
    }
}
