//
//  TodoViewModel.swift
//  Fetcher
//
//  Created by Monica Auriemma on 10/23/24.
//

import SwiftUI

struct TodoItem: Codable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}

@MainActor
class TodoViewModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    @Published var errorMessage: String? = nil
    
    // Function to fetch data from the API
    func fetchData() async throws -> [TodoItem] {
        // API URL
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {
            print("Invalid url")
            throw CustomError.invalidUrl
        }
        
        // Send the request to the API
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Check for successful (200) response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CustomError.invalidResponse
        }
        
        do {
            // Decode the response from the API into an array of TodoItem objects
            let todoItems = try JSONDecoder().decode([TodoItem].self, from: data)
            DispatchQueue.main.async {
                self.todos = todoItems
            }
            return todos
        } catch {
            throw CustomError.invalidData
        }
    }
    
    // Custom errors
    enum CustomError: Error {
        case invalidUrl
        case invalidResponse
        case invalidData
    }
}
