//
//  ContentView.swift
//  SwiftUI-Study
//
//  Created by Ratnesh Jain on 06/07/24.
//

import SwiftUI

@MainActor
struct ContentView: View {
    let viewModel = PostViewModel()
    var body: some View {
        Group {
            switch viewModel.fetchingState {
            case .fetching:
                ProgressView()
            case .fetched:
                List {
                    ForEach(viewModel.posts, id: \.id) { post in
                        NavigationLink {
                            PostDetailView(post: post)
                        } label: {
                            Text(post.title)
                        }
                    }
                }
            case .error(let message):
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.yellow)
                    Text(message)
                }
            }
        }
        .refreshable {
            Task {
                try await viewModel.refresh()
            }
        }
        .task {
            do {
                try await viewModel.fetchPosts()
            } catch {
                print(error)
            }
        }
    }
}

struct PostDetailView: View {
    let post: Post
    var body: some View {
        Text(post.title)
            .font(.largeTitle)
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
