//
//  FullscreenViewController.swift
//  PublicSampleAppTrial
//
//  Created by John Mai on 12/29/22.
//

/**
 IMPORTANT: Please review and set the placementID and appID inside the Info.plist file. To do so, please do the following:
 
 Navigate to project hierarchy in Xcode, and select Info. Expand Liftoff PlacementID and be sure that Interstitial is set correctly. Please do the same for Liftoff Dashboard AppID as well inside the Info.plist file.
 
 */

import UIKit
import VungleAdsSDK

class LOInterstitialViewController: UIViewController {
    private var interstitialAd: VungleInterstitial?
    
    private var callbackLogs: [CallbackLog] = []
    var placementId:String?
    
    @IBOutlet weak var placementIdLbl: UILabel!
    @IBOutlet weak var loadBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Liftoff Interstitial Ad"
        self.placementIdLbl.text = self.placementId
        self.callbackLogs = [
            CallbackLog(title: "interstitialAdDidLoad", index: 0),
            CallbackLog(title: "interstitialAdWillPresent", index: 1),
            CallbackLog(title: "interstitialAdDidPresent", index: 2),
            CallbackLog(title: "interstitialAdDidTrackImpression", index: 3),
            CallbackLog(title: "interstitialAdDidClick", index: 4),
            CallbackLog(title: "interstitialAdWillLeaveApplication", index: 5),
            CallbackLog(title: "interstitialAdWillClose", index: 6),
            CallbackLog(title: "interstitialAdDidClose", index: 7),
            CallbackLog(title: "interstitialAdDidFailToLoad", index: 8),
            CallbackLog(title: "interstitialAdDidFailToPresent", index: 9)
        ]
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func btnPressed(_ sender: UIButton) {
        if sender == self.loadBtn {
            // Clean up before load
            if self.interstitialAd != nil {
                self.interstitialAd?.delegate = nil
                self.interstitialAd = nil
                AppUtil.resetLogMessage(tableView: self.tableView, callbacks: self.callbackLogs)
            }

            guard let placementId = self.placementId else {
                return
            }
            
            self.interstitialAd = VungleInterstitial(placementId: placementId)
            self.interstitialAd?.delegate = self
            self.interstitialAd?.load()
        } else if sender == self.playBtn {
            // Determines whether the banner object is nil in addition to whether the ad assets have been downloaded successfully
            if (self.interstitialAd?.canPlayAd() != nil) {
                self.interstitialAd?.present(with: self)
            }
        }
    }
}

// MARK: Vungle SDK Interstitial Delegate Callbacks

extension LOInterstitialViewController: VungleInterstitialDelegate {
    // Ad load events
    func interstitialAdDidLoad(_ interstitial: VungleInterstitial) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "interstitialAdDidLoad")
    }
    
    func interstitialAdDidFailToLoad(_ interstitial: VungleInterstitial, withError: NSError) {
        print(#function)
        print(withError)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "interstitialAdDidFailToLoad")
    }
    
    // Ad Lifecycle Events
    func interstitialAdWillPresent(_ interstitial: VungleInterstitial) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "interstitialAdWillPresent")
    }
    
    func interstitialAdDidPresent(_ interstitial: VungleInterstitial) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "interstitialAdDidPresent")
    }
    
    func interstitialAdDidFailToPresent(_ interstitial: VungleInterstitial, withError: NSError) {
        print(#function)
        print(withError)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "interstitialAdDidFailToPresent")
    }
    
    func interstitialAdDidTrackImpression(_ interstitial: VungleInterstitial) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "interstitialAdDidTrackImpression")
    }
    
    func interstitialAdDidClick(_ interstitial: VungleInterstitial) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "interstitialAdDidClick")
    }
    
    func interstitialAdWillLeaveApplication(_ interstitial: VungleInterstitial) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "interstitialAdWillLeaveApplication")
    }
    
    func interstitialAdWillClose(_ interstitial: VungleInterstitial) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "interstitialAdWillClose")
    }
    
    func interstitialAdDidClose(_ interstitial: VungleInterstitial) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "interstitialAdDidClose")
    }
}

extension LOInterstitialViewController: UITableViewDelegate, UITableViewDataSource {
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
