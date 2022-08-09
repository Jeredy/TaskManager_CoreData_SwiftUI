//
//  TaskViewModel.swift
//  TaskManager_SwiftUI
//
//  Created by André Almeida on 2022-07-04.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    
    //MARK: Current week days
    @Published var currentWeek: [Date] = []
    
    //MARK: Current Day
    @Published var currentDay: Date = Date()
    
    //MARK: Filtering today tasks
    @Published var filteredTasks: [Task]?
    
    //MARK: New Task View
    @Published var addNewTask: Bool = false
    
    //MARK: Initializing
    init() {
        fetchCurrentWeek()
    }
    
    func fetchCurrentWeek() {
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else {
            return
        }
        
        (1...7).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
        }
    }
    
    //MARK: Extracting Date
    func extractDate(date: Date, format: String)->String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    //MARK: Check if currrentDay is today
    func isToday(date: Date)->Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    func isCurrentHour(date: Date) -> Bool {
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        
        return hour == currentHour
    }
}
