//
//  NetworkMonitor.swift
//  Fetcher
//
//  Created by Monica Auriemma on 10/23/24.
//

import Network
import SwiftUI

class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    @Published var isConnected: Bool = false
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                // Checks for an active connection
                self.isConnected = path.status == .satisfied
            }
        }
        // Start the queue
        monitor.start(queue: queue)
    }
}
