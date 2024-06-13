//
//  EntityManagingProtocol.swift
//  teamplan
//
//  Created by 크로스벨 on 3/15/24.
//  Copyright © 2024 team1os. All rights reserved.
//

import CoreData

// MARK: - Coredata Controller
protocol CoredataProtocol {
    var container: NSPersistentContainer { get }
    var context: NSManagedObjectContext { get }
}

enum CoredataConfig {
    static let defaultModel = "Coredata"
}

final class CoredataMainController: CoredataProtocol {
    static let shared = CoredataMainController()
    var container: NSPersistentContainer
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    private init(){
        container = NSPersistentContainer(name: CoredataConfig.defaultModel)
        container.loadPersistentStores{ storeDescription, error in
            if let error = error as NSError? {
                fatalError("[Coredata] Unable to load persistent container: \(error)")
            }
        }
    }
}

// MARK: - Basic
protocol BasicObjectManage {
    associatedtype Entity: NSManagedObject
    associatedtype Object
    
}

extension BasicObjectManage {
    func fetchEntity(
        with fetchReq: NSFetchRequest<Entity>,
        and context: NSManagedObjectContext) throws -> Entity? {
        
        let result = try context.fetch(fetchReq)
        return result.first
    }
}

// MARK: - Full Manage
protocol FullObjectManage: BasicObjectManage {
    associatedtype DTO
    
    func getObject(with userId: String) throws -> Object
    func setObject(with object: Object) throws
    func updateObject(with dto: DTO) throws
    func deleteObject(with userId: String) throws
    func isObjectExist(with userId: String) -> Bool
}


// MARK: - CoreValue
protocol CoreValueObjectManage: BasicObjectManage {
    
    func setObject(with object: Object) throws
    func getObject(with userId: String) throws -> Object
    func deleteObject(with userId: String) throws
    func isObjectExist(with userId: String) -> Bool
}


// MARK: - Notification
protocol NotificationObjectManage: BasicObjectManage {
    
    func setObject(with object: Object) async throws
    func getFullObject(with userId: String) async throws -> [Object]
    func getCategoryObject(with userId: String, and category: NotificationCategory) async throws -> [Object]
    func deleteObject(with userId: String, and notifyId: Int) async throws
    func deleteObjects(with userId: String, and notifyIds: [Int]) async throws
}


// MARK: - Challenge
protocol ChallengeObjectManage: BasicObjectManage {
    associatedtype DTO
    
    func setObject(with object: Object) async throws
    func getObject(with challengeId: Int, and userId: String) async throws -> Object
    func deleteObject(with userId: String) throws
    func updateObject(with dto: DTO) throws
    
    func getObjects(with userId: String) throws -> [Object]
    func getObjects(with userId: String) async throws -> [Object]
    func getCompleteObjects(with userId: String) async throws -> Int
    func isObjectExist(with userId: String) -> Bool
}


// MARK: - Log
protocol LogObjectManage: BasicObjectManage {
    
    func setObject(with object: Object) throws
    
    func getLatestObject(with userId: String) throws -> Object
    func getFullObjects(with userId: String) throws -> [Object]
    
    func deleteObject(with userId: String) throws
    func isObjectExist(with userId: String) -> Bool
}


// MARK: - Project
protocol ProjectObjectManage: BasicObjectManage {
    associatedtype UpdateDTO
    associatedtype HomeDTO
    associatedtype BackgroundDTO
    
    func setObject(with object: Object) throws
    
    func getObject(with userId: String, and projectId: Int) throws -> Object
    func getObjects(with userId: String) throws -> [Object]
    func getTargetObjects(with userId: String) throws -> [Object]
    
    func getIdList(with userId: String) throws -> [Int]
    func getHomeDTOList(with userId: String) throws -> [HomeDTO]
    func getBackgroundDTOList(with userId:String) throws -> [BackgroundDTO]
    
    func updateObject(with dto: UpdateDTO) throws
    func deleteObject(with userId: String, and projectId: Int) throws
    func deleteAllObject(with userId: String) throws
}


// MARK: - Todo
protocol TodoObjectManage: BasicObjectManage {
    associatedtype DTO
    
    func setObject(with object: Object) throws
    func getObject(userId: String, projectId: Int, todoId: Int) throws -> Object
    func getObjects(userId: String, projectId: Int) throws -> [Object]
    func updateObject(updated: DTO) throws
    func deleteObject(userId: String, projectId: Int, todoId: Int) throws
}


// MARK: - Enum
enum EntityPredicate {
    case user
    case stat
    case coreValue
    
    case singleNotify
    case fullNotify
    case categoryNotify
    
    case accessLog
    case targetLog
    
    case project
    case projectList
    case projectTargetList
    
    case fullChallenge
    case singleChallenge
    case completeChallenge
    
    var format: String {
        switch self {
        // user data
        case .coreValue, .user, .stat:
            return "user_id == %@"
            
        // notification
        case .singleNotify:
            return "user_id == %@ AND notify_id == %d"
        case .fullNotify:
            return "user_id == %@"
        case .categoryNotify:
            return "user_id == %@ AND category == %d"
            
        // accesslog
        case .accessLog:
            return "user_id == %@"
        case .targetLog:
            return "user_id == %@ AND access_record > %@"
            
        // project
        case .project:
            return "user_id == %@ AND project_id == %d"
        case .projectList:
            return "user_id == %@"
        case .projectTargetList:
            return "user_id == %@ AND (status == %d OR status == %d)"
            
        // challenge
        case .fullChallenge:
            return "user_id == %@"
        case .singleChallenge:
            return "user_id == %@ AND challenge_id == %d"
        case .completeChallenge:
            return "user_id == %@ AND status == %@"
        }
    }
}

enum EntitySortBy: String {
    case date = "access_record"
}
