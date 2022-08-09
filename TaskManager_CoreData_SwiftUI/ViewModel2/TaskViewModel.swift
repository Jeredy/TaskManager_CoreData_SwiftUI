//
//  TaskViewModel.swift
//  TaskManager_SwiftUI
//
//  Created by André Almeida on 2022-07-04.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    
    //Sample Tasks
    @Published var storedTasks: [Task] = [
        Task(taskTitle: "Metting", taskDescription: "Discuss team task for the day", taskDate: .init(timeIntervalSince1970: 1659989405)),
        Task(taskTitle: "Watch some movie", taskDescription: "Watch some movies from my wait list", taskDate: .init(timeIntervalSince1970: 1659976987)),
        Task(taskTitle: "Dating", taskDescription: "Meet my girlfriend", taskDate: .init(timeIntervalSince1970: 1660077787))
    ]
    
    //MARK: Current week days
    @Published var currentWeek: [Date] = []
    
    //MARK: Current Day
    @Published var currentDay: Date = Date()
    
    //MARK: Filtering today tasks
    @Published var filteredTasks: [Task]?
    
    //MARK: Initializing
    init() {
        fetchCurrentWeek()
        filterTodayTasks()
    }
    
    //MARK: Filter Today Tasks
    func filterTodayTasks() {
        DispatchQueue.global(qos: .userInteractive).async {
            
            let calendar = Calendar.current
            
            let filtered = self.storedTasks.filter {
                return calendar.isDate($0.taskDate, inSameDayAs: self.currentDay)
            }
                .sorted { task1, task2 in
                    return task2.taskDate < task1.taskDate
                }
            
            DispatchQueue.main.async {
                withAnimation {
                    self.filteredTasks = filtered
                }
            }
        }
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
