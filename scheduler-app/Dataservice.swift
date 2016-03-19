//
//  Dataservice.swift
//  scheduler-app
//
//  Created by Victoria on 2/28/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import Foundation
import Firebase

let BASE_URL = "https://scheduler-base.firebaseio.com"

class DataService {
    static let ds = DataService()
    private var _REF_BASE = Firebase(url: "\(BASE_URL)")
    private var _REF_USERS = Firebase(url: "\(BASE_URL)/users")
    private var _REF_GROUPS = Firebase(url: "\(BASE_URL)/groups")
    private var _REF_PNUMBERS = Firebase(url: "\(BASE_URL)/phonenumbers")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    var REF_USERS: Firebase {
        return _REF_USERS
    }
    
    var REF_GROUPS: Firebase {
        return _REF_GROUPS
    }
    
    var REF_PNUMBERS: Firebase {
        return _REF_PNUMBERS
    }
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
        REF_USERS.childByAppendingPath(uid).setValue(user)
    }
}
