//
//  MainMenu.swift
//  GRPlayer
//
//  Created by Wolf McNally on 2/15/21.
//

import SwiftUI

struct MainMenu: View {
    var body: some View {
        NavigationView {
            ContentsMenu()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}
