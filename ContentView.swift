//
//  ContentView.swift
//  Daily Helper
//
//  Created by Zaid Tahir on 2023-06-17.
//

import SwiftUI

struct ContentView: View {
    @State var currentTime = Date()
    @State var content = ""
    var closedRange = Calendar.current.date(byAdding: .year, value: -1, to:Date())!
    
    func formatDate()-> String {
        let components = Calendar.current.dateComponents([.hour, .minute, .day, .year, .month], from: currentTime)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let day = components.day ?? 0
        let month = components.month ?? 0
        let year = components.year ?? 0
        
        return "\(day)-\(month)-\(year) (\(hour):\(minute))"
    }
    
    func returnHour()-> Int {
        let components = Calendar.current.dateComponents([.hour, .minute, .day, .year, .month], from: currentTime)
        let hour = components.hour ?? 0
        
        return hour;
    }
    
    func returnMinute()-> Int {
        let components = Calendar.current.dateComponents([.hour, .minute, .day, .year, .month], from: currentTime)
        let minute = components.minute ?? 0
        
        return minute;
    }
    
    
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            Spacer()
            Form {
                Section(header:Text("")) {
                    DatePicker("Pick a Date:", selection: $currentTime, in: Date()...)
                    TextField("Content", text: $content)
                    Text(formatDate())
                }
            }
            .foregroundColor(Color.black)
            .background(Color.mint)
            .scrollContentBackground(.hidden)


            Spacer()
            VStack {
                Spacer()
                Button(action: {
                    NotificationManager.instance.requestAuthorization()
                    let hour = self.returnHour()
                    let minute = self.returnMinute()
                    NotificationManager.instance.setValues(h: hour, m: minute, c: content, d: currentTime)
                    NotificationManager.instance.scheduleNotification()})
                { Image(systemName: "clock")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(10)}
                Spacer()
                Image(systemName: "sun.max")
                    .foregroundColor(.yellow)
                    .font(.system(size: 60))
                
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
