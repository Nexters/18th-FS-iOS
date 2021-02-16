//
//  AppView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/01/22.
//

import SwiftUI

struct AppView: View {
    @State private var selection = 0

    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color.DEPTH_4_BG)
        UITabBar.appearance().barTintColor = UIColor(Color.DEPTH_4_BG)
    }

    var body: some View {
<<<<<<< Updated upstream
        TabView(selection: $selection, content: {
            MainLabelingView()
                .tabItem {
<<<<<<< HEAD

                    Image("tabbar_add")
                }
            SearchView()
                .tabItem {
                    Image("tabbar_home")
                }
            AlbumView()
                .tabItem {
                    Image("tabbar_album")
                }
        }

//                    Image(selection == 0 ? "ico_labeling_on" : "ico_labeling_off")
//                }.tag(0)
//            SearchView()
//                .tabItem {
//                    Image(selection == 1 ? "ico_home_on" : "ico_home_off")
//                }.tag(1)
//            AlbumView()
//                .tabItem {
//                    Image(selection == 2 ? "ico_album_on" : "ico_album_off")
//                }.tag(2)
//
//        })

)    }
=======
                    Image(selection == 0 ? "ico_labeling_on" : "ico_labeling_off")
                }.tag(0)
            SearchView()
                .tabItem {
                    Image(selection == 1 ? "ico_home_on" : "ico_home_off")
                }.tag(1)
            AlbumView()
                .tabItem {
                    Image(selection == 2 ? "ico_album_on" : "ico_album_off")
                }.tag(2)
        })
=======
        NavigationView {
            TabView(selection: $selection, content: {
                MainLabelingView()
                    .tabItem {
                        Image(selection == 0 ? "ico_labeling_on" : "ico_labeling_off")
                    }.tag(0)
                SearchView()
                    .tabItem {
                        Image(selection == 1 ? "ico_home_on" : "ico_home_off")
                    }.tag(1)
                LabelView()
                    .tabItem {
                        Image(selection == 2 ? "ico_album_on" : "ico_album_off")
                    }.tag(2)
            })
        }
>>>>>>> Stashed changes
    }
>>>>>>> feature/home
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
