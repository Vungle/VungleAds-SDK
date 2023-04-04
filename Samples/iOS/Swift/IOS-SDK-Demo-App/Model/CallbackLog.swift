//
//  CallbackLog.swift
//  PublicSampleAppTrial
//
//  Created by John Mai on 1/3/23.
//

/**
 To see how each ad format is integrated, navigate to Ad Formats to see how to integrate ad type into an app.
 */

import Foundation

class CallbackLog {
    var title: String = ""
    var subtitle: String = ""
    var isActive: Bool = false
    var index: Int = 0

    init(title: String, index: Int) {
        self.title = title
        self.index = index
    }
}
