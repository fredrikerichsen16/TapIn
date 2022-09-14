import SwiftUI
import RealmSwift

class PomodoroTicker {
    let pomodoroState: PomodoroState
    
    private var timer: Timer!
    private var timeElapsed: Double = 0.0
    private var remainingTime: Double? = nil
    
    init(_ pomodoroState: PomodoroState) {
        self.pomodoroState = pomodoroState
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: timerInterval)
    }
    
    private func timerInterval(timer: Timer) {
        // Make time advance if clock is running
        if pomodoroState.timerMode != .running { return }
        self.timeElapsed += 1
        
        updateUI()
        
        if self.remainingTime ?? 1 < 0 {
            pomodoroState.completedSession()
            updateUI()
        }
    }
    
    public func updateUI() {
        // Get remaining time as readable string
        let duration = self.pomodoroState.stageState.getStageDuration()
        self.remainingTime = duration - self.timeElapsed
        let readableTime = self.getReadableTime(seconds: self.remainingTime!)
        
        // Get circle progress
        let circleProgress = self.getCircleProgress(duration: duration, timeElapsed: self.timeElapsed)
        
        pomodoroState.updateUI(readableTime: readableTime, circleProgress: circleProgress)
    }
    
    /// Get time in seconds as readable string of minutes and seconds
    private func getReadableTime(seconds: Double) -> String {
        let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
        
        return formatter.string(from: seconds) ?? "N/A"
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
        timer.fire()
    }
}
