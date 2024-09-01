//
//  MypageViewModel.swift
//  teamplan
//
//  Created by 크로스벨 on 5/1/24.
//  Copyright © 2024 team1os. All rights reserved.
//

import Foundation

final class MypageViewModel: ObservableObject {
    
    //MARK: Properties
    
    var userName: String
    @Published var dto: MypageDTO
    @Published var accomplishes: [Accomplishment]
    
    private let identifier: String
    private let service: MypageService
    
    //MARK: Initializer
    // prepare prepertise : UserDefault (userName / Identifier)
    init() {
        let volt = VoltManager.shared
        if let identifier = volt.getUserId(),
           let userName = volt.getUserName() {
            self.identifier = identifier
            self.userName = userName
        } else {
            self.identifier = "unknown"
            self.userName = "unknown"
            print("[MypageViewModel] Initialize Failed")
        }
        self.service = MypageService(userId: self.identifier)
        self.dto = MypageDTO()
        self.accomplishes = []
    }
    
    //MARK: Method
    
    @MainActor
    func loadData() {
        if !service.prepareService() {
            print("[MypageViewModel] Failed to load data")
        }
        self.dto = service.mypageDTO
        
        DispatchQueue.main.async {
            self.accomplishes = [
                .init(accomplishTitle: AccomplishmentTitle.challenge.rawValue,
                      accomplishCount: self.dto.completedChallenges),
                .init(accomplishTitle: AccomplishmentTitle.project.rawValue,
                      accomplishCount: self.dto.completedProjects),
                .init(accomplishTitle: AccomplishmentTitle.todo.rawValue,
                      accomplishCount: self.dto.completedTodos)
            ]
        }
    }
    
    func performAction(menu: MypageMenu) throws {
        switch menu {
            
        case .logout:
            Task {
                let result = await service.logout()
                print("[MyPageViewModel] Logout action result: \(result)")
            }
        case .withdraw:
            Task{
                let result = await service.withdraw()
                print("[MyPageViewModel] Withdraw action result: \(result)")
            }
 
        default:
            return
        }
    }
}

enum AccomplishmentTitle: String {
    case challenge = "완료 도전과제"
    case project = "완료한 목표"
    case todo = "완료한 할 일"
}
