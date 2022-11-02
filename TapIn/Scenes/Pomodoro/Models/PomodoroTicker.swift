import SwiftUI
import RealmSwift

/// Get time in seconds as readable string of minutes and seconds
fileprivate func getReadableTime(seconds: Double) -> String {
    let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
    
    return formatter.string(from: seconds) ?? "N/A"
}

class PomodoroTicker {
    private var timer: Timer!
    private var timeElapsed = 0.0
    public var running = false
    public var stageDuration = 0.0
    
    var onUpdate: ((String, Double) -> Void)
    var onCompletedSession: () -> Void
    
    init(onUpdate: @escaping ((String, Double) -> Void),
         onCompletedSession: @escaping () -> Void) {
        self.onUpdate = onUpdate
        self.onCompletedSession = onCompletedSession
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: timerInterval)
    }
    
    private func timerInterval(timer: Timer) {
        // Make time advance if clock is running
        if running == false {
            return
        }
        
        // Timestep
        self.timeElapsed += 1
        
        updateUI()
    }
    
    func updateUI() {
        // Get remaining time as readable string
        let remainingTime = stageDuration - timeElapsed
        let readableTime = getReadableTime(seconds: remainingTime)
        
        // Get circle progress
        let circleProgress = self.getCircleProgress(duration: stageDuration, timeElapsed: timeElapsed)
        
        if remainingTime < 0 {
            self.onCompletedSession()
        } else {
            self.onUpdate(readableTime, circleProgress)
        }
    }
    
    /// Return the fraction of a given full time period that has elapsed
    /// - Parameters:
    ///   - duration: full time period (pomodoro period duration)
    ///   - timeElapsed: time that has elapsed
    /// - Returns: fraction of period elapsed -> equivalent to circle progress
    private func getCircleProgress(duration: Double, timeElapsed: Double) -> Double {
        return (duration - timeElapsed) / duration
    }
    
    /// Set timeElapsed to zero, and run the timer immediately for immediate effect rather than waiting up to one second
    func resetTimer() {
        timeElapsed = 0
    }
    
}
