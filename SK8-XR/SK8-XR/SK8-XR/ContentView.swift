//
//  ContentView.swift
//  SK8-XR
//
//  Created by Vero Field on 4/14/26.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var sceneState = SceneState()

    var body: some View {
        ZStack {
            ARViewContainer(sceneState: sceneState)
                .ignoresSafeArea()
            HUDView(sceneState: sceneState)
        }
    }
}

#Preview {
    ContentView()
}
