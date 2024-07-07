//
//  PostViewModel.swift
//  SwiftUI-Study
//
//  Created by Ratnesh Jain on 06/07/24.
//

import Foundation

struct Post: Codable {
    let id: Int
    let title: String
}

@MainActor
@Observable
class PostViewModel {
    var posts: [Post] = []
    var fetchingState: FetchingState = .fetching
    var shouldRefresh: Bool = false
    
    func fetchPosts() async throws {
        guard self.posts.isEmpty || shouldRefresh else { return }
        self.fetchingState = .fetching
        try await Task.sleep(for: .seconds(1))
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://jsonplaceholder.typicode.com/post")!)
            let posts = try JSONDecoder().decode([Post].self, from: data)
            self.posts = posts
            self.fetchingState = .fetched
        } catch {
            self.fetchingState = .error(error.localizedDescription)
        }
    }
    
    func refresh() async throws {
        shouldRefresh = true
        try await self.fetchPosts()
    }
    
}
