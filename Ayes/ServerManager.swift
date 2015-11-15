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
    let avaliableKeys = UserManager.sharedManager.avalableKeys

    avaliableKeys.forEach { item in
      if item == kRegion && Settings.sharedInstance.country == Settings.Country.World {
        fields["country"] = UserManager.sharedManager.valueForKey(item)
      } else {
        fields[item] = UserManager.sharedManager.valueForKey(item)
      }
    }

//    let region = UserManager.sharedManager.valueForKey(kRegion)
//    if region == "MOW" || region == "SPE" {
//        fields[kLocality] = region
//    }

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
  
  func updateSettings(complition: ((success: Bool) -> Void)? = nil) -> Request? {
    
    let questionTime = Settings.sharedInstance.questionTime
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "HH"
    dateFormatter.timeZone = NSTimeZone(name: "UTC")
    let questionTimeUTC = dateFormatter.stringFromDate(questionTime)
    
    var userFields = [String: AnyObject]()
    if let hour = Int(questionTimeUTC) {
      userFields["preferred_time"] = hour
    }
    
    if let country = Settings.sharedInstance.country {
      if country == Settings.Country.Russia {
        userFields["country"] = "RU"
      } else {
        userFields["country"] = UserManager.sharedManager.user?.region ?? NSNull()
      }
    }
    
    let parameters: [String: AnyObject] = ["user" : userFields]
    
    do {
      let request = try self.patch("user/", params: parameters)
      request.validate()
      request.response { (_, resp, _, error) -> Void in
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
          var questions_ids = [Int]()
          
          for (_, subJson) in json {
            if let id = subJson["id"].int {
              questions_ids.append(id)
            }
            
            if let question = Question.createFromJSON(subJson) {
              questions.append(question)
            }
          }
          
          let allQuestions = Question.findAll() as! [Question]
          for q in allQuestions {
            if let id = q.id?.integerValue where !questions_ids.contains(id) {
              q.MR_deleteEntity()
              if let answers = Answer.findByAttribute("question_id", withValue: id) as? [Answer] {
                answers.forEach { q in q.MR_deleteEntity() }
              }
              if let favorites = Favorite.findByAttribute("question_id", withValue: id) as? [Favorite] {
                favorites.forEach { fav in fav.MR_deleteEntity() }
              }
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
  
  
  func getSimilarAnswersForQuestion(question: Question, complition: ((_: Stat?) -> Void)? = nil) -> Request? {
    guard let questionID = question.id else {
      return nil
    }
    
    do {
      let request = try get("/questions/\(questionID)/answers/similar")
      request.validate()
      request.responseJSON { (_, _, result) in
        if result.isFailure {
          complition?(nil)
          return
        }
        
        if let jsonData = result.value {
          let json = JSON(jsonData)
          let similarStat = Stat.createFromJSON(json)
          question.similarStat = similarStat
          complition?(similarStat)
//          NSManagedObjectContext.defaultContext().saveToPersistentStoreWithCompletion(nil)
        }
      }
      
      return request
    } catch(Errors.Unauthorized) {
      print("Unauthorized")
      complition?(nil)
      return nil
    } catch {
      complition?(nil)
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
  
  func submitAnswer(answer: Answer, complition: ((_:Bool) -> Void)? = nil) -> Request? {
    guard let question_id = answer.question_id else {
      return nil
    }
    
    do {
      
      let request = try post("questions/\(question_id)/answers/", params: ["value": answer.value ?? NSNull()])
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
  
  func updateDeviceToken(complition: ((_:Bool) -> Void)? = nil) -> Request? {
    let parameters = ["user" : ["device_token": deviceToken ?? NSNull()]]
    
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
  
  //MARK: - Favorite
  
  func submitFavorite(favorite: Favorite, complition: ((_: Bool) -> Void)? = nil) -> Request? {
    guard let question_id = favorite.question_id?.integerValue else {
      return nil
    }
    
    let parameters = ["question_id" : question_id]
    
    do {
      let request = try post("/favorites", params: parameters)
      request.validate()
      request.response { (_, _, _, error) in
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