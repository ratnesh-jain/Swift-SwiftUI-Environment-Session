//
//  ArrayBuilder.swift
//  SwiftUI-Study
//
//  Created by Ratnesh Jain on 06/07/24.
//

import Foundation

@resultBuilder
enum ArrayBuilder<T> {
    static func buildBlock(_ components: Array<T>...) -> Array<T> {
        components.flatMap({$0})
    }
    
    static func buildExpression(_ expression: T) -> Array<T> {
        [expression]
    }
    
    static func buildExpression(_ expression: Array<T>) -> Array<T> {
        expression
    }
    
    static func buildPartialBlock(first: Array<T>) -> Array<T> {
        first
    }
    
    static func buildPartialBlock(accumulated: Array<T>, next: Array<T>) -> Array<T> {
        var copy = accumulated
        copy.append(contentsOf: next)
        return copy
    }
    
    static func buildOptional(_ component: Array<T>?) -> Array<T> {
        component ?? []
    }
    
    static func buildEither(first component: Array<T>) -> Array<T> {
        component
    }
    
    static func buildEither(second component: Array<T>) -> Array<T> {
        component
    }
    
    static func buildFinalResult(_ component: Array<T>) -> Array<T> {
        component
    }
    
    static func buildLimitedAvailability(_ component: Array<T>) -> Array<T> {
        component
    }
}

extension Array {
    init(@ArrayBuilder<Element> builder: @escaping () -> [Element]) {
        self = builder()
    }
}

struct ArrayBuilderStudy {
    
    func buildArray() -> [Int] {
        Array {
            1
            2
            3
            
            if Bool.random() {
                1
            } else {
                2
            }
            
            [1,2,4]
        }
    }
}
