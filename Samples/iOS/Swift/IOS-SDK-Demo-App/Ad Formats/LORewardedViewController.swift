//
//  FullscreenViewController.swift
//  PublicSampleAppTrial
//
//  Created by John Mai on 12/29/22.
//

/**
 IMPORTANT: Please review and set the placementID and appID inside the Info.plist file. To do so, please do the following:
 
 Navigate to project hierarchy in Xcode, and select Info. Expand Liftoff PlacementID and be sure that Rewarded or Rewarded Playable is set correctly. Please do the same for Liftoff Dashboard AppID as well inside the Info.plist file.
 */

import UIKit
import VungleAdsSDK

class LORewardedViewController: UIViewController {
    private var rewardedAd: VungleRewarded?
    
    private var callbackLogs: [CallbackLog] = []
    var placementId:String?
    
    @IBOutlet weak var loadBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placementIdLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Liftoff Rewarded Ad"
        self.placementIdLbl.text = self.placementId
        self.callbackLogs = [
            CallbackLog(title: "rewardedAdDidLoad", index: 0),
            CallbackLog(title: "rewardedAdWillPresent", index: 1),
            CallbackLog(title: "rewardedAdDidPresent", index: 2),
            CallbackLog(title: "rewardedAdDidTrackImpression", index: 3),
            CallbackLog(title: "rewardedAdDidClick", index: 4),
            CallbackLog(title: "rewardedAdWillLeaveApplication", index: 5),
            CallbackLog(title: "rewardedAdDidRewardUser", index: 6),
            CallbackLog(title: "rewardedAdWillClose", index: 7),
            CallbackLog(title: "rewardedAdDidClose", index: 8),
            CallbackLog(title: "rewardedAdDidFailToLoad", index: 9),
            CallbackLog(title: "rewardedAdDidFailToPresent", index: 10)
        ]
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func btnPressed(_ sender: UIButton) {
        if sender == self.loadBtn {
            // Clean up before load
            if self.rewardedAd != nil {
                self.rewardedAd?.delegate = nil
                self.rewardedAd = nil
                AppUtil.resetLogMessage(tableView: self.tableView, callbacks: self.callbackLogs)
            }
            
            guard let placementId = self.placementId else {
                return
            }
            self.rewardedAd = VungleRewarded(placementId: placementId)
            self.rewardedAd?.delegate = self
            self.rewardedAd?.load()
            
            // Set incentivized rewarded text
            self.rewardedAd?.setAlertTitleText("Close Ad")
            self.rewardedAd?.setAlertBodyText("Are you sure you want to close the ad? You will lose out on your reward")
            self.rewardedAd?.setAlertContinueButtonText("Resume Ad")
            self.rewardedAd?.setAlertCloseButtonText("Close Ad")
        } else if sender == self.playBtn {
            // Determines whether the banner object is nil in addition to whether the ad assets have been downloaded successfully
            if (self.rewardedAd?.canPlayAd() != nil) {
                self.rewardedAd?.present(with: self)
            }
        }
    }
}

// MARK: Vungle SDK Rewarded Delegate Callbacks

extension LORewardedViewController: VungleRewardedDelegate {
    // Ad load events
    func rewardedAdDidLoad(_ rewarded: VungleRewarded) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "rewardedAdDidLoad")
    }
    
    func rewardedAdDidFailToLoad(_ rewarded: VungleRewarded, withError: NSError) {
        print(#function)
        print(withError)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "rewardedAdDidFailToLoad")
    }
    
    // Ad Lifecycle Events
    func rewardedAdWillPresent(_ rewarded: VungleRewarded) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "rewardedAdWillPresent")
    }
    
    func rewardedAdDidPresent(_ rewarded: VungleRewarded) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "rewardedAdDidPresent")
    }
    
    func rewardedAdDidFailToPresent(_ rewarded: VungleRewarded, withError: NSError) {
        print(#function)
        print(withError)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "rewardedAdDidFailToPresent")
    }
    
    func rewardedAdDidTrackImpression(_ rewarded: VungleRewarded) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "rewardedAdDidTrackImpression")
    }
    
    func rewardedAdDidClick(_ rewarded: VungleRewarded) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "rewardedAdDidClick")
    }
    
    func rewardedAdWillLeaveApplication(_ rewarded: VungleRewarded) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "rewardedAdWillLeaveApplication")
    }
    
    func rewardedAdDidRewardUser(_ rewarded: VungleRewarded) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "rewardedAdDidRewardUser")
    }
    
    func rewardedAdWillClose(_ rewarded: VungleRewarded) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "rewardedAdWillClose")
    }
    
    func rewardedAdDidClose(_ rewarded: VungleRewarded) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "rewardedAdDidClose")
    }
}

extension LORewardedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.callbackLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CallbackLogTableCell",for: indexPath) as! CallbackLogTableViewCell
        let log = self.callbackLogs[indexPath.row]
        if log.isActive {
            cell.callbackLbl.textColor = .label
            cell.accessoryType = .checkmark
        } else {
            cell.callbackLbl.textColor = .gray
            cell.accessoryType = .none
        }
        cell.callbackLbl?.text = log.title
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
