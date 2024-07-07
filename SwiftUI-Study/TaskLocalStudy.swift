//
//  TaskLocalStudy.swift
//  SwiftUI-Study
//
//  Created by Ratnesh Jain on 06/07/24.
//

import Foundation

enum User {
    @TaskLocal static var id: String = "Anonymous"
}

func testTaskLocal() {
    User.$id.withValue("Admin") {
        print("1", User.id)
        
        User.$id.withValue("SubAdmin") {
            print("3", User.id)
            DispatchQueue.main.async {
                print("4", User.id)
            }
        }
    }
    
    User.$id.withValue("User") {
        print("5", User.id)
    }
    
    print("2", User.id)
}
