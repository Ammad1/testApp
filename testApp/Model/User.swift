//
//  User.swift
//  testApp
//
//  Created by Ammad Tariq on 02/10/2021.
//

import Foundation
import CoreData

struct User : Codable {
    var login : String?
    var id : Int?
    var nodeId : String?
    var avatarUrl : String?
    var avatarId : String?
    var url : String?
    var htmlUrl : String?
    var followersUrl : String?
    var followingUrl : String?
    var gistsUrl : String?
    var starredUrl : String?
    var subscriptionsUrl : String?
    var organizationsUrl : String?
    var reposUrl : String?
    var eventsUrl : String?
    var receivedEventsUrl : String?
    var type : String?
    var siteAdmin : Bool?
    var notes: String {
        get {
            return CoreDataManager.shared.retrieveNotes(forId: id)
        }
    }

    enum CodingKeys: String, CodingKey {

        case login = "login"
        case id = "id"
        case nodeId = "node_id"
        case avatarUrl = "avatar_url"
        case avatarId = "gravatar_id"
        case url = "url"
        case htmlUrl = "html_url"
        case followersUrl = "followers_url"
        case followingUrl = "following_url"
        case gistsUrl = "gists_url"
        case starredUrl = "starred_url"
        case subscriptionsUrl = "subscriptions_url"
        case organizationsUrl = "organizations_url"
        case reposUrl = "repos_url"
        case eventsUrl = "events_url"
        case receivedEventsUrl = "received_events_url"
        case type = "type"
        case siteAdmin = "site_admin"
    }
    
    init() {
        
    }
//    init(userManagedObject: NSManagedObject) {
//        login = userManagedObject.value(forKey: "login")
//        id = userManagedObject.value(forKey: "id")
//        nodeId = userManagedObject.value(forKey: "nodeId")
//        avatarUrl = userManagedObject.value(forKey: "avatarUrl")
//        avatarId = userManagedObject.value(forKey: "gravatarId")
//        url = userManagedObject.value(forKey: "url")
//        htmlUrl =          userManagedObject.value(forKey: "htmlUrl")
//        followersUrl =     userManagedObject.value(forKey: "followersUrl")
//        followingUrl =     userManagedObject.value(forKey: "followingUrl")
//        gistsUrl =         userManagedObject.value(forKey: "gistsUrl")
//        starredUrl =       userManagedObject.value(forKey: "starredUrl")
//        subscriptionsUrl = userManagedObject.value(forKey: "subscriptionsUrl")
//        organizationsUrl = userManagedObject.value(forKey: "organizationsUrl")
//        reposUrl =         userManagedObject.value(forKey: "reposUrl")
//        eventsUrl =        userManagedObject.value(forKey: "eventsUrl")
//        receivedEventsUrl =userManagedObject.value(forKey: "receivedEventsUrl")
//        type =             userManagedObject.value(forKey: "type")
//        siteAdmin =        userManagedObject.value(forKey: "siteAdmin")
//
//        login =             user.login
//        id =                user.id
//        nodeId =            user.nodeId
//        avatarUrl =         user.avatarUrl
//        avatarId =          user.avatarId
//        url =               user.url
//        htmlUrl =           user.htmlUrl
//        followersUrl =      user.followersUrl
//        followingUrl =      user.followingUrl
//        gistsUrl =          user.gistsUrl
//        starredUrl =        user.starredUrl
//        subscriptionsUrl =  user.subscriptionsUrl
//        organizationsUrl =  user.organizationsUrl
//        reposUrl =          user.reposUrl
//        eventsUrl =         user.eventsUrl
//        receivedEventsUrl = user.receivedEventsUrl
//        type =              user.type
//        siteAdmin =         user.siteAdmin
//        notes = ""
//    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        login = try values.decodeIfPresent(String.self, forKey: .login)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        nodeId = try values.decodeIfPresent(String.self, forKey: .nodeId)
        avatarUrl = try values.decodeIfPresent(String.self, forKey: .avatarUrl)
        avatarId = try values.decodeIfPresent(String.self, forKey: .avatarId)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        htmlUrl = try values.decodeIfPresent(String.self, forKey: .htmlUrl)
        followersUrl = try values.decodeIfPresent(String.self, forKey: .followersUrl)
        followingUrl = try values.decodeIfPresent(String.self, forKey: .followingUrl)
        gistsUrl = try values.decodeIfPresent(String.self, forKey: .gistsUrl)
        starredUrl = try values.decodeIfPresent(String.self, forKey: .starredUrl)
        subscriptionsUrl = try values.decodeIfPresent(String.self, forKey: .subscriptionsUrl)
        organizationsUrl = try values.decodeIfPresent(String.self, forKey: .organizationsUrl)
        reposUrl = try values.decodeIfPresent(String.self, forKey: .reposUrl)
        eventsUrl = try values.decodeIfPresent(String.self, forKey: .eventsUrl)
        receivedEventsUrl = try values.decodeIfPresent(String.self, forKey: .receivedEventsUrl)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        siteAdmin = try values.decodeIfPresent(Bool.self, forKey: .siteAdmin)
    }
}
