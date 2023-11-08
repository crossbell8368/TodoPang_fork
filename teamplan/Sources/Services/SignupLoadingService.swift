//
//  SignupLoadingService.swift
//  teamplan
//
//  Created by 주찬혁 on 2023/10/20.
//  Copyright © 2023 team1os. All rights reserved.
//

import Foundation

final class SignupLoadingService{
    
    let userFS = UserServicesFirestore()
    let userCD = UserServicesCoredata()
    let statFS = StatisticsServicesFirestore()
    let statCD = StatisticsServicesCoredata()
    let aclogFS = AccessLogServicesFirestore()
    let aclogCD = AccessLogServicesCoredata()
    let chlglogFS = ChallengeLogServicesFirestore()
    let chlglogCD = ChallengeLogServicesCoredata()
    
    var newProfile: UserObject
    var newStat: StatisticsObject
    var newAccessLog: AccessLog
    var newChallengeLog: ChallengeLog
    
    //===============================
    // MARK: - Constructor
    //===============================
    init(newUser: UserSignupReqDTO){
        let signupDate = Date()
        self.newProfile = UserObject(newUser: newUser, signupDate: signupDate)
        self.newStat = StatisticsObject(identifier: newUser.identifier, signupDate: signupDate)
        self.newAccessLog = AccessLog(identifier: newUser.identifier, signupDate: signupDate)
        self.newChallengeLog = ChallengeLog(identifier: newUser.identifier, signupDate: signupDate)
        
        self.setUserFS { fsResult in
            switch fsResult {
            case .success(let fsResult):
                print("fsResult: \(fsResult)")
                self.setUserCD { cdResult in
                    switch cdResult {
                    case .success(let cdResultResult):
                        print("cdResultResult: \(cdResultResult)")
                        self.setStatisticsFS { result in
                            switch result {
                            case .success(let statisticsFSResult):
                                print("statisticsFSResult: \(statisticsFSResult)")
                                self.setStatisticsCD { result in
                                    switch result {
                                    case .success(let statisticsCDResult):
                                        print("statisticsCDResult: \(statisticsCDResult)")
                                        self.setAccessLogFS { result in
                                            switch result {
                                            case .success(let accessLogFS):
                                                print("AccessLogFS: \(accessLogFS)")
                                                self.setAccessLogCD { result in
                                                    switch result {
                                                    case .success(let setAccessLogCDResult):
                                                        print("setAccessLogCDResult: \(setAccessLogCDResult)")
                                                        self.setChallengeLogFS { result in
                                                            switch result {
                                                            case .success(let setChallengeLogFS):
                                                                print("setChallengeLogFS: \(setChallengeLogFS)")
                                                                self.setChallengeLogCD { result in
                                                                    switch result {
                                                                    case .success(let setChallengeLogCD):
                                                                        print("setChallengeLogCD: \(setChallengeLogCD)")
                                                                    case .failure(let error):
                                                                        print(error.localizedDescription)
                                                                    }
                                                                }
                                                            case .failure(let error):
                                                                print(error.localizedDescription)
                                                            }
                                                        }
                                                    case .failure(let error):
                                                        print(error.localizedDescription)
                                                    }
                                                }
                                            case .failure(let error):
                                                print(error.localizedDescription)
                                            }
                                        }
                                    case .failure(let error):
                                        print(error.localizedDescription)
                                    }
                                }
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }

            case .failure(let error):
                print(error.localizedDescription)

            }
        }
    }
    
    //===============================
    // MARK: - Set User
    //===============================
    // : Firestore
    func setUserFS(result: @escaping(Result<Bool, Error>) -> Void) {
        userFS.setUser(reqUser: self.newProfile) { fsResult in
            switch fsResult {
            
            case .success(let docsId):
                print("newProfile: \(self.newProfile)")
                self.newProfile.addDocsId(docsId: docsId)
                return result(.success(true))
                
            case .failure(let error):
                print(error)
                return result(.failure(error))
            }
        }
    }
    
    // : Coredata
    func setUserCD(result: @escaping(Result<Bool, Error>) -> Void) {
        userCD.setUser(userObject: self.newProfile) { cdResult in
            self.handleServiceResult(cdResult, with: result)
        }
    }
    
    //===============================
    // MARK: - Set Statistics
    //===============================
    // : Firestore
    func setStatisticsFS(result: @escaping(Result<Bool, Error>) -> Void) {
        statFS.setStatistics(reqStat: self.newStat) { fsResult in
            self.handleServiceResult(fsResult, with: result)
        }
    }
    
    // : Coredata
    func setStatisticsCD(result: @escaping(Result<Bool, Error>) -> Void) {
        statCD.setStatistics(reqStat: self.newStat) { cdResult in
            self.handleServiceResult(cdResult, with: result)
        }
    }
    
    //===============================
    // MARK: - Set AccessLog
    //===============================
    // : Firestore
    func setAccessLogFS(result: @escaping(Result<Bool, Error>) -> Void) {
        aclogFS.setAccessLogFS(reqLog: self.newAccessLog) { fsResult in
            self.handleServiceResult(fsResult, with: result)
        }
    }
    
    // : Coredata
    func setAccessLogCD(result: @escaping(Result<Bool, Error>) -> Void) {
        aclogCD.setAccessLog(reqLog: self.newAccessLog) { cdResult in
            self.handleServiceResult(cdResult, with: result)
        }
    }
    
    //===============================
    // MARK: - Set ChallengeLog
    //===============================
    // : Firestore
    func setChallengeLogFS(result: @escaping(Result<Bool, Error>) -> Void) {
        chlglogFS.setChallengeLogFS(reqLog: self.newChallengeLog) { fsResult in
            self.handleServiceResult(fsResult, with: result)
        }
    }
    
    // ; Coredata
    func setChallengeLogCD(result: @escaping(Result<Bool, Error>) -> Void) {
        chlglogCD.setChallengeLog(reqLog: self.newChallengeLog) { cdResult in
            self.handleServiceResult(cdResult, with: result)
        }
    }
    
    //===============================
    // MARK: - Result Handler
    //===============================
    func handleServiceResult(_ serviceResult: Result<String, Error>,
                             with result: @escaping(Result<Bool, Error>) -> Void) {
        switch serviceResult {
        case .success(let message):
            print(message)
            result(.success(true))
        case .failure(let error):
            print(error)
            result(.failure(error))
        }
    }
}


