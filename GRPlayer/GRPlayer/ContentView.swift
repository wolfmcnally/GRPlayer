//
//  ContentView.swift
//  GRPlayer
//
//  Created by Wolf McNally on 11/14/20.
//

import SwiftUI
import GR

struct ContentView: View {
    var body: some View {
//        ProgramView(DrawMaze())
        NavigationView {
            ContentsMenu()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
