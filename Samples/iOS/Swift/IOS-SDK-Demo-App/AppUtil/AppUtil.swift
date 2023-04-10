//
//  AppUtil.swift
//  PublicSampleAppTrial
//
//  Created by John Mai on 1/23/23.
//

/**
 To see how each ad format is integrated, navigate to Ad Formats to see how to integrate ad type into an app.
 */

import Foundation
import UIKit

class AppUtil {
    static func activeLogMessage(tableView: UITableView, callbacks:[CallbackLog], title: String) {
        for log in callbacks where log.title == title {
            log.isActive = true
        }
        tableView.reloadData()
    }

    static func resetLogMessage(tableView: UITableView, callbacks:[CallbackLog]) {
        for log in callbacks {
            log.isActive = false
            log.subtitle = ""
        }
        tableView.reloadData()
    }
}
