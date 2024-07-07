//
//  SwiftUI_StudyApp.swift
//  SwiftUI-Study
//
//  Created by Ratnesh Jain on 06/07/24.
//

import SwiftUI

@main
struct SwiftUI_StudyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    testTaskLocal()
                }
        }
    }
}
