//
//  MainViewTab.swift
//  Dottie_Watch Watch App
//
//  Created by Dane Davies on 11/18/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            GlucoseView()
            FoodView()
            HormoneView()
            LifestyleView()
        }
        .tabViewStyle(.page)
    }
}

#Preview {
    MainTabView()
}
