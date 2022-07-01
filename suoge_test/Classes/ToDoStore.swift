//
//  ToDoStore.swift
//  MVCDemo
//
//  Created by sg on 2022/6/29.
//

import Foundation

let dummy = [
    "buy the milk",
    "Take my dog",
    "Rent a car"
]


struct ToDoStore {
    static let shared = ToDoStore()
    func getToDoItems(completionHandler: (   ([String]) -> Void)?   ) {
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            completionHandler?(dummy)
        })
    }
}
