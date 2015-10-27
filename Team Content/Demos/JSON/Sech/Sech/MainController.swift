//
//  MainController.swift
//  Sech
//
//  Created by Alexander Pöhlmann on 23.10.15.
//  Copyright © 2015 Peter Stoehr. All rights reserved.
//

import Foundation

class MainController{
    let JSONMANAGER:JSONManager
    let CONNECTIONMANAGER:ConnectionManager
    
    var responseMethod:((succeeded: Bool, data: NSData) -> ())?
    var detaileResponseMethod:((succeeded: Bool, data: NSData) -> ())?
    //normal response have sech-tag name and detaile response have a prefix: "_DETAILE"
    var mapOfJSONs = [String:JSONObject]()
    
    required init(){
        self.CONNECTIONMANAGER = ConnectionManager()
        self.JSONMANAGER = JSONManager()
    }
    
    func createJSONForRequest(keyWordsWithKeys:[String:AnyObject],detail:Bool)->JSONObject?{
        var json:JSONObject?
        if detail {
            let dataForDetailRequest = createDetailRequest(keyWordsWithKeys["json"] as! JSONObject!)
            json = JSONMANAGER.createDetailRequest(dataForDetailRequest["queryID"] as! String, documentBadge: dataForDetailRequest["documentBadge"] as! [[String:AnyObject]])
        }else{
            json = JSONMANAGER.createRequestJSON(keyWordsWithKeys["ContextKeywords"] as! [JSONObject], numResults: keyWordsWithKeys["numResults"] as! Int!)
        }
        return json
    }
    
    func setMethodForResponse(postCompleted :(succeeded: Bool, data: NSData) -> ())->Bool{
        self.responseMethod = postCompleted
        return true
    }
    func setMethodForDetaileResponce(postCompleted :(succeeded: Bool, data: NSData) -> ())->Bool{
        self.detaileResponseMethod = postCompleted
        return true
    }
    
    func makeRequest(json:JSONObject,detail:Bool)->Bool{
        if detail{
            self.CONNECTIONMANAGER.makeHTTP_Request(json, url: PROJECT_URL.GETDETAILS, httpMethod: ConnectionManager.POST, postCompleted: self.detaileResponseMethod!)
        }else{
            self.CONNECTIONMANAGER.makeHTTP_Request(json, url: PROJECT_URL.RECOMMEND, httpMethod: ConnectionManager.POST, postCompleted: self.responseMethod!)
        }
        
        return  true
    }
    
    private func createDetailRequest(json:JSONObject)->[String:AnyObject]{
        var jsons = [[String:AnyObject]]()
        for jsonObject in json.getJSONArray("result")!{
            jsons.append(jsonObject.getJSONObject("documentBadge")!.jsonObject)
            
        }
        let queryID:String = json.getString("queryID")!
        return ["queryID":queryID,"documentBadge":jsons]
    }
    
//    private func reStructurKeyContextForRequest(jsons:[JSONObject])->[AnyObject]{
//        var newJsons = [[String:AnyObject]]()
//        var z = 0
//        for json in jsons{
//            for keyVal in json.jsonObject{
//                newJsons[z][keyVal.0] = keyVal.1
//            }
//            if newJsons[z].count == 2{
//                z++
//            }
//        }
//     return
//    }
}
