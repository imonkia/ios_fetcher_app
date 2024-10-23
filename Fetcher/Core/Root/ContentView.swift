//
//  ContentView.swift
//  Fetcher
//
//  Created by Monica Reta on 10/23/24.
//

import SwiftUI

struct ContentView: View {
    // State objects
    @StateObject private var viewModel = TodoViewModel()
    @StateObject private var networkMonitor = NetworkMonitor()
    
    // State variables
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
//    @State private var todos: [TodoItem] = []
    
    var body: some View {
        VStack {
            // Check network availability
            if !networkMonitor.isConnected {
                Text("No internet connection available.")
                    .foregroundColor(Color.red)
                    .padding()
            } else {
                // Fetch data button
                Button(action:
                    {
                        Task {
                            do {
                                try await _ = viewModel.fetchData()
                            } catch TodoViewModel.CustomError.invalidUrl {
                                showAlert = true
                                alertMessage = "Invalid URL."
                            } catch TodoViewModel.CustomError.invalidData {
                                showAlert = true
                                alertMessage = "Invalid data."
                            } catch TodoViewModel.CustomError.invalidResponse {
                                showAlert = true
                                alertMessage = "Invalid response."
                            } catch {
                                showAlert = true
                                alertMessage = "Unexpected error."
                            }
                        }
                    }) {
                        Text("Fetch Data")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
            }
            List(viewModel.todos) {
                todo in
                VStack(alignment: .leading) {
                    Text(todo.title)
                        .font(.headline)
                    Text("Completed: \(todo.completed ? "Yes" : "No")")
                        .font(.subheadline)
                        .foregroundColor(todo.completed ? .green : .red)
                }
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    ContentView()
}
