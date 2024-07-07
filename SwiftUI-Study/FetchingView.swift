//
//  FetchingView.swift
//  SwiftUI-Study
//
//  Created by Ratnesh Jain on 06/07/24.
//

import Foundation
import SwiftUI

struct FetchingViewConfiguration {
    var retryView: AnyView?
}

enum FetchingViewEnvironmentKey: EnvironmentKey {
    static var defaultValue: FetchingViewConfiguration = .init()
}

extension EnvironmentValues {
    var fetchingViewConfig: FetchingViewConfiguration {
        get { self[FetchingViewEnvironmentKey.self] }
        set { self[FetchingViewEnvironmentKey.self] = newValue }
    }
}

extension View {
    
    func retry<V>(@ViewBuilder _ view: () -> V) -> some View where V: View {
        self.environment(\.fetchingViewConfig.retryView, AnyView(view()))
    }
}

struct FetchingView<Content: View, LoadingView: View, ErrorView: View>: View {
    let state: FetchingState
    @ViewBuilder var content: () -> Content
    @ViewBuilder var loadingView: () -> LoadingView
    @ViewBuilder var errorView: (String) -> ErrorView
    
    init(
        state: FetchingState,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder loadingView: @escaping () -> LoadingView,
        @ViewBuilder errorView: @escaping (String) -> ErrorView
    ) {
        self.state = state
        self.content = content
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    var body: some View {
        switch state {
        case .fetching:
            loadingView()
        case .fetched:
            content()
        case .error(let message):
            errorView(message)
        }
    }
}

struct PlainLoadingView: View {
    var body: some View {
        ProgressView()
    }
}

struct PlainErrorView: View {
    @Environment(\.fetchingViewConfig) var configuration
    let message: String
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundStyle(.yellow)
            Text(message)
            
            if let retryView = configuration.retryView {
                retryView
            }
        }
    }
}

extension FetchingView {
    init(
        state: FetchingState,
        @ViewBuilder content: @escaping ()->Content
    ) where LoadingView == PlainLoadingView, ErrorView == PlainErrorView {
        self.init(state: state, content: content) {
            PlainLoadingView()
        } errorView: { message in
            PlainErrorView(message: message)
        }
    }
    
    init(
        state: FetchingState,
        @ViewBuilder content: @escaping ()->Content,
        @ViewBuilder errorView: @escaping (String) -> ErrorView
    ) where LoadingView == PlainLoadingView {
        self.init(state: state, content: content) {
            PlainLoadingView()
        } errorView: { message in
            errorView(message)
        }
    }
}

#Preview("1") {
    FetchingView(state: .error("Error")) {
        List(1...10, id: \.self) {
            Text("\($0)")
        }
    }
    .retry {
        HStack {
            Button("Retry after sometime") {
                print("Retry")
            }
            .buttonStyle(.bordered)
            Button("Login") {
                print("Login Again")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview("2") {
    FetchingView(state: .error("Something went wrong")) {
        List(1...10, id: \.self) {
            Text("\($0)")
        }
    } loadingView: {
        ProgressView()
    } errorView: { message in
        VStack {
            Image(systemName: "gear")
                .font(.largeTitle)
                .foregroundStyle(.yellow)
            Text(message)
        }
    }
}

#Preview("3") {
    FetchingView(state: .error("Something went wrong again")) {
        List(1...10, id: \.self) {
            Text("\($0)")
        }
    } errorView: { message in
        VStack {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                Text("Message: \(message)")
            }
            Button("Retry") {
                print("Retry again")
            }
        }
    }

}

#Preview("4") {
    FetchingView(state: .error("Error")) {
        List(1...10, id: \.self) {
            Text("\($0)")
        }
    }
}
