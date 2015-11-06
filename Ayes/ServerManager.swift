//
//  ServerManager.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 20/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ServerManager {
  static let sharedInstance = ServerManager()
  private let baseURL = "http://ayes.binaryblitz.ru/"
  private let manager = Manager.sharedInstance
  var apiToken: String? {
    didSet {
      NSLog("api token updated: \(apiToken ?? "")")
    }
  }
  var deviceToken: String? {
    didSet {
      NSLog("device token updated: \(deviceToken ?? "")")
    }
  }
  
  enum Errors: ErrorType {
    case Unauthorized
  }
  
  private func request(method: Alamofire.Method, path: String, parameters: [String : AnyObject]?, encoding: ParameterEncoding) throws -> Request {
    let url = baseURL + path
    var parameters = parameters
    guard let token = apiToken else {
      throw Errors.Unauthorized
    }
    
    if parameters != nil {
      parameters!["api_token"] = token
    } else {
      parameters = ["api_token": token]
    }
    
    return manager.request(method, url, parameters: parameters, encoding: encoding)
  }
  
  private func get(path: String, params: [String: AnyObject]? = nil) throws -> Request {
    return try request(.GET, path: path, parameters: params, encoding: .URL)
  }
  
  private func post(path: String, params: [String: AnyObject]? = nil) throws -> Request {
    return try request(.POST, path: path, parameters: params, encoding: .JSON)
  }
  
  private func patch(path: String, params: [String: AnyObject]? = nil) throws -> Request {
    return try request(.PATCH, path: path, parameters: params, encoding: .JSON)
  }
  
  //MARK: - User
  
  func createUser(complition: ((success: Bool) -> Void)? = nil) {
    let parameters = ["user" : ["gender": ""]]
    manager.request(.POST, baseURL + "user/", parameters: parameters, encoding: .JSON)
    .validate()
    .responseJSON { (request, response, result) -> Void in
      defer { complition?(success: result.isSuccess) }
      
      guard let jsonData = result.value else {
        return
      }
      
      let json = JSON(jsonData)
      if let token = json["api_token"].string {
        self.apiToken = token
        UserManager.sharedManager.user = User()
      }
    }
  }
  
  func updateUser(complition: ((success: Bool) -> Void)? = nil) -> Request? {
    var fields = [String: String]()
    for item in UserManager.sharedManager.avalableKeys {
      fields[item] = UserManager.sharedManager.valueForKey(item)
    }
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let birthDate = UserManager.sharedManager.user?.birthDate {
      fields[kBirthDate] = dateFormatter.stringFromDate(birthDate)
    }
    
    let parameters = ["user" : fields]
    
    do {
      let request = try self.patch("user/", params: parameters)
      request.validate()
      request.response { (_, _, _, error) -> Void in
        complition?(success: error == nil)
      }
      
      return request
    } catch(Errors.Unauthorized) {
      print("Unauthorized")
      complition?(success: false)
      return nil
    } catch {
      complition?(success: false)
      return nil
    }
  }
  
  //MARK: - Questions
  
  func getQuestions(complition: ((questions: [Question]?) -> Void)? = nil) -> Request? {
    do {
      let request = try get("questions/")
      request.validate()
      request.responseJSON { (_, _, result) -> Void in
        if result.isFailure {
          complition?(questions: nil)
          return
        }
        
        if let jsonData = result.value {
          let json = JSON(jsonData)
          var questions = [Question]()
          for (_, subJson) in json {
            if let question = Question.createFromJSON(subJson) {
              questions.append(question)
            }
          }
          NSManagedObjectContext.defaultContext().MR_saveToPersistentStoreWithCompletion(nil)
          complition?(questions: questions)
        }
      }
      
      return request
    } catch(Errors.Unauthorized) {
      print("Unauthorized")
      complition?(questions: nil)
      return nil
    } catch {
      complition?(questions: nil)
      return nil
    }
  }
  
  //MARK: - Answers
  
  func submitAnswer(questionId: Int, answer: QuestionState, complition: ((_:Bool) -> Void)? = nil) -> Request? {
    do {
      let value: Bool?
      switch answer {
      case .No:
        value = false
      case .Yes:
        value = true
      case .Skip:
        value = nil
      default:
        fatalError("You cannot submit question without an answer!")
      }
      
      let request = try post("questions/\(questionId)/answers/", params: ["value": value ?? NSNull()])
      request.validate()
      request.responseJSON { (_, _, result) -> Void in
        complition?(result.isSuccess)
      }
      
      return request
    } catch(Errors.Unauthorized) {
      print("Unauthorized")
      complition?(false)
      return nil
    } catch {
      complition?(false)
      return nil
    }
  }
  
  //MARK: - Push notifications
  
  func updateDeviceToken(token: String, complition: ((_:Bool) -> Void)? = nil) -> Request? {
    let parameters = ["user" : ["device_token": token]]
    
    do {
      let request = try self.patch("user/", params: parameters)
      request.validate()
      request.response { (_, _, _, error) -> Void in
        complition?(error == nil)
      }
      
      return request
    } catch(Errors.Unauthorized) {
      print("Unauthorized")
      complition?(false)
      return nil
    } catch {
      complition?(false)
      return nil
    }
  }
}