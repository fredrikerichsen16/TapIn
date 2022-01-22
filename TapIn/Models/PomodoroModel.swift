//
//  PomodoroModel.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 20/06/2021.
//

import SwiftUI
import Combine

enum TimerMode {
    case initial
    case running
    case paused
}

struct PomodoroModel {
    
    // Combine
    
    init() {
        var this = self
        
        passthroughSubject.sink(receiveCompletion: { completion in
            print(completion)
            
            switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }, receiveValue: { value in
            this.time = "\(value) seconds"
        }).store(in: &cancellables)
    }
    
    var time: String = "0 seconds"
    
    private var cancellables: Set<AnyCancellable> = []
    
    let passthroughSubject = PassthroughSubject<String, Error>()
    
    func startFetch() {
        Service.fetch { (result) in
            switch result {
                case .success(let value):
                    if value == "10"
                    {
                        self.passthroughSubject.send(completion: .finished)
                    }
                    else
                    {
                        passthroughSubject.send(value)
                        print(value)
                    }
                case .failure(let error):
                    passthroughSubject.send(completion: .failure(error))
                    print(error.localizedDescription)
            }
        }
    }
    
    // Combine END
    
    var pomodoroDuration: TimeInterval = 60.0 * 3.0
    var shortBreakDuration: TimeInterval = 60.0 * 5.0
    var longBreakDuration: TimeInterval = 60.0 * 15.0
    var longBreakFrequency: Int = 3
    
    var timeElapsed: TimeInterval = 0.0
    
    var timerMode: TimerMode = .initial
    
    func getButtonTitle() -> String {
        return timerMode == .running ? "Pause" : "Start"
    }
    
    func remainingTime(_ keyPath: KeyPath<PomodoroModel, TimeInterval>) -> Double {
        let startTime = self[keyPath: keyPath]
        
        return startTime - timeElapsed
    }
    
    func readableTime(seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
        
        return formatter.string(from: seconds) ?? "FAIL"
    }
    
    func readableTime(_ keyPath: KeyPath<PomodoroModel, TimeInterval>) -> String {
        let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
    
        return formatter.string(from: self[keyPath: keyPath]) ?? "00:00"
    }
    
}

struct Service {
    static let mockData = 1 ... 10
    
    static func fetch(completion: @escaping (Result<String, Error>) -> ()) {
        mockData.forEach { (value) in
            let delay = DispatchTimeInterval.seconds(value)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                completion(.success(String(value)))
            }
        }
    }
}
