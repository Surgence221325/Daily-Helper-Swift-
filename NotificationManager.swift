//
//  NotificationManager.swift
//  Daily Helper
//
//  Created by Zaid Tahir on 2023-06-17.
//

// singleton pattern! easier way to make sure dual notifications are not sent out, also probably better for memory/speed due to static nature? -> performance is not a reason to use the singleton design pattern!
// how to allow user to select date? potentially have a class defined variable initialized when we instantiate the class?
// in that case would we not be violating singleton, if we create a class object instead of the instance
// idea: field dateComponent variables, changed when user selects their date/time
// similarly we can use this idea to set a custom message pop up for the user (content can be a field)
// question: how would this work after the first instance of NotificationManager (ie. user wants to send a different notification) -> check
// idea: at what point can we turn on the flashlight and/or screen brightness? swift code runs sequentially, thus should I just make the call after the function is completed?
import UserNotifications
import AVFoundation

class NotificationManager {
    
    
    var hour: Int
    var minute: Int
    var time: Date
    var content: String
    
    static let instance = NotificationManager()
    
    private init() {
        hour = 0
        minute = 0;
        time = Date()
        content = ""
    }
    
    func setValues(h: Int, m: Int, c: String, d: Date){
        // set values here for the class! still can use singleton
        self.hour = h;
        self.minute = m;
        self.time = d;
        self.content = c;
    }
    
    
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]){ success, error in // no real need for badge number in current build
            if let error = error {
                print ("ERROR: \(error)")
            } else {
                print("SUCCESS")
            }
        } // potential point: have to close the app once before it asks for permissions -> test with actual phone
        // likely because the iphone maintains data throughout the builds ignore
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Daily Reminder:"
        content.subtitle = self.content
        content.subtitle += "\r\n Finish Science Homework" // Need some way to allow multi lined comments to appear on home screen
        content.sound = .default
        
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false)
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger2)
        UNUserNotificationCenter.current().add(request)
        
        DispatchQueue.main.async {
            let elapsed = self.time.timeIntervalSinceNow
            let delayTime = DispatchTime.now() + elapsed
            print("one")
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.turnOnFlashlight()
            } // :( not really supported by apple to do this kind of stuff in the background: check work arounds?
            // problem: the app cannot turn on the flashlight from background
            // idea: a silent notification that automatically redirects the user to the app? allowing for such functionality.
            // other idea: this would work perfectly with a widget style app
            // widgets have perpetual access to screen/functions so it may be easier to access flashlight
        }
        }
        
        func turnOnFlashlight() {
            guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
                print("Flashlight not available")
                return
            }
            
            do {
                try device.lockForConfiguration()
                
                if device.isTorchModeSupported(.on) {
                    try device.setTorchModeOn(level: 1.0)
                    print("Flashlight turned on")
                } else {
                    print("Torch mode not supported")
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Error toggling flashlight: \(error)")
            }
        }
        
    }

