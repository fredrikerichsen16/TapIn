import Foundation
import UserNotifications

class NotificationManager {
    
    static let main = NotificationManager()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    private init() {}
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (success, error) in
            if success
            {
                UserDefaultsManager.main.notificationsEnabled = true
                print("Notifications activated")
            }
            else
            {
                UserDefaultsManager.main.notificationsEnabled = false
                
                if let error
                {
                    print(error.localizedDescription)
                }
            }
        })
    }
    
    /// Send notification immediately with basic information
    func sendSimpleNotification(title: String, subtitle: String) {
        guard UserDefaultsManager.main.notificationsEnabled else {
            return
        }
        
        let content = UNMutableNotificationContent()
            content.title = title
            content.subtitle = subtitle
            content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        notificationCenter.add(request)
    }
    
}
