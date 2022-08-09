//
//  Home.swift
//  TaskManager_SwiftUI
//
//  Created by André Almeida on 2022-07-04.
//

import SwiftUI

struct Home: View {
    //MARK: - Properties
    
    @StateObject var taskModel: TaskViewModel = TaskViewModel()
    @Namespace var animation
    
    //MARK: - Body
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            //MARK: Lazy Stack with pinned header
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                Section {
                    
                    //MARK: Current Week View
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(taskModel.currentWeek, id: \.self) { day in
                                VStack(spacing: 10) {
                                    Text(taskModel.extractDate(date: day, format: "dd"))
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                    
                                    // EEE will return day as MON, TUE ...
                                    Text(taskModel.extractDate(date: day, format: "EEE"))
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                    
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 8, height: 8)
                                        .opacity(taskModel.isToday(date: day) ? 1 : 0)
                                }
                                .foregroundStyle(taskModel.isToday(date: day) ? .primary : .tertiary)
                                .foregroundColor(taskModel.isToday(date: day) ? .white : .black)
                                // Mark capsule shape
                                .frame(width: 45, height: 90)
                                .background(
                                    ZStack {
                                        //MARK: Matched Geometry Effect
                                        if taskModel.isToday(date: day) {
                                            Capsule()
                                                .fill(.black)
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                    }
                                )
                                .contentShape(Capsule())
                                .onTapGesture {
                                    withAnimation {
                                        taskModel.currentDay = day
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    TasksView()
                } header: {
                    HeaderView()
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        //MARK: Add Button
        .overlay(
            Button(action: {
                taskModel.addNewTask.toggle()
            }, label: {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black, in: Circle())
            })
            .padding()
            
            , alignment: .bottomTrailing
        )
        .sheet(isPresented: $taskModel.addNewTask) {
            NewTask()
        }
    }
    
    //MARK: Tasks View
    func TasksView()->some View {
        LazyVStack(spacing: 20) {
            
            // Converting object as our task model
            DynamicFilterdView(dateToFilter: taskModel.currentDay) { (object: Task) in
                TaskCardView(task: object)
            }
        }
        .padding()
        .padding(.top)
    }
    
    //MARK: Task Card View
    func TaskCardView(task: Task) -> some View {
        
        //MARK: Since CoreData Values will Give Optional Data
        HStack(alignment: .top, spacing: 30) {
            HStack {
                VStack(spacing: 10) {
                    Circle()
                        .fill(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? .black : .clear)
                        .frame(width: 15, height: 15)
                        .background(
                            Circle()
                                .stroke(.black, lineWidth: 1)
                                .padding(-3)
                        )
                        .scaleEffect(!taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 0.8 : 1)
                    
                    Rectangle()
                        .fill(.black)
                        .frame(width: 3)
                }
                
                VStack {
                    HStack(alignment: .top, spacing: 10) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(task.taskTitle ?? "")
                                .font(.title2.bold())
                            
                            Text(task.taskDescription ?? "")
                                .font(.callout)
                                .foregroundColor(.gray)
                        }
                        .hLeading()
                        
                        Text(task.taskDate?.formatted(date: .omitted, time: .shortened) ?? "")
                    }
                    
                    if taskModel.isCurrentHour(date: task.taskDate ?? Date()) {
                        // MARK: Team Members
                        HStack(spacing: 0) {
                            HStack(spacing: -10) {
                                ForEach(["User1", "User2", "User3"], id: \.self) { user in
                                    Image(user)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 45, height: 45)
                                        .clipShape(Circle())
                                        .background(
                                            Circle()
                                                .stroke(.black, lineWidth: 5)
                                        )
                                }
                            }
                            .hLeading()
                            
                            //MARK: Check Button
                            Button {
                                
                            } label: {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        .padding(.top)
                    }
                }
                .foregroundColor(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? .white : .black)
                .padding(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 15 : 0)
                .padding(.bottom, taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 0 : 10)
                .hLeading()
                .background(
                    Color("Black")
                        .cornerRadius(25)
                        .opacity(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 1 : 0)
                )
            }
        }
        .hLeading()
    }
    
    //MARK: Header
    func HeaderView()->some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                
                Text("Today")
                    .font(.largeTitle.bold())
            }
            .hLeading()
            
            Button {
                
            } label: {
                Image("Profile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            }
        }
        .padding()
        .padding(.top, getSafeArea().top)
        .background(Color.white)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

//MARK: UI Design Helper Functions
extension View {
    func hLeading()->some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing()->some View {
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter()->some View {
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    // MARK: Safe Area
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
}

