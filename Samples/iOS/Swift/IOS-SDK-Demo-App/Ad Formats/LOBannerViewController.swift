//
//  LOBannerViewController.swift
//  PublicSampleAppTrial
//
//  Created by John Mai on 12/29/22.
//

/**
 IMPORTANT: Please review and set the placementID inside the Info.plist file. To do so, please do the following:
 
 Navigate to project hierarchy in Xcode, and select Info. Expand Liftoff PlacementID and be sure that Banner is set correctly. Please do the same for Liftoff Dashboard AppID as well inside the Info.plist file.
 */

import UIKit
import VungleAdsSDK

class LOBannerViewController: UIViewController {
    @IBOutlet weak var bannerAdContainer: UIView!
    private var bannerAd: VungleBanner?
    
    @IBOutlet weak var loadBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placementLbl: UILabel!
    var callbackLogs: [CallbackLog] = []
    var placementId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Liftoff Banner Ad"
        self.placementLbl.text = self.placementId
        self.callbackLogs = [
            CallbackLog(title: "bannerAdDidLoad", index: 0),
            CallbackLog(title: "bannerAdWillPresent", index: 1),
            CallbackLog(title: "bannerAdDidPresent", index: 2),
            CallbackLog(title: "bannerAdDidTrackImpression", index: 3),
            CallbackLog(title: "bannerAdDidClick", index: 4),
            CallbackLog(title: "bannerAdWillLeaveApplication", index: 5),
            CallbackLog(title: "bannerAdWillClose", index: 6),
            CallbackLog(title: "bannerAdDidClose", index: 7),
            CallbackLog(title: "bannerAdDidFailToLoad", index: 8),
            CallbackLog(title: "bannerAdDidFailToPresent", index: 9),
        ]
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func btnPressed(_ sender:UIButton) {
        if sender == loadBtn {
            if self.bannerAd != nil {
                self.bannerAd?.delegate = nil
                self.bannerAd = nil
                AppUtil.resetLogMessage(tableView: self.tableView, callbacks: self.callbackLogs)
            }
            guard let placementId = self.placementId else {
                return
            }
            
            /**
             Banner Sizes:
                BannerSize.regular = 320x50
                BannerSize.short = 300x50
                BannerSize.leaderboard = 720x50
             */
            self.bannerAd = VungleBanner(placementId: placementId, size: BannerSize.regular)
            self.bannerAd?.delegate = self
            self.bannerAd?.load()
        } else if sender == playBtn {
            // Determines whether the banner object is nil in addition to whether the ad assets have been downloaded successfully
            if ((self.bannerAd?.canPlayAd()) != nil) {
                self.bannerAd?.present(on: self.bannerAdContainer)
            }
        } else if sender == closeBtn {
            for subView in self.bannerAdContainer.subviews {
                subView.removeFromSuperview()
            }
        }
    }
}

// MARK: Vungle SDK Interstitial Delegate Callbacks

extension LOBannerViewController: VungleBannerDelegate {
    // Ad load Events
    func bannerAdDidLoad(_ banner: VungleBanner) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "bannerAdDidLoad")
    }
    
    func bannerAdDidFailToLoad(_ banner: VungleBanner, withError: NSError) {
        print(#function)
        print(withError)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "bannerAdDidFailToLoad")
    }
    
    // Ad Lifecycle Events
    func bannerAdWillPresent(_ banner: VungleBanner) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "bannerAdWillPresent")
    }
    
    func bannerAdDidPresent(_ banner: VungleBanner) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "bannerAdDidPresent")
    }
    
    func bannerAdDidFailToPresent(_ banner: VungleBanner, withError: NSError) {
        print(#function)
        print(withError)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "bannerAdDidFailToPresent")
    }
    
    func bannerAdDidTrackImpression(_ banner: VungleBanner) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "bannerAdDidTrackImpression")
    }
    
    func bannerAdDidClick(_ banner: VungleBanner) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "bannerAdDidClick")
    }
    
    func bannerAdWillLeaveApplication(_ banner: VungleBanner) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "bannerAdWillLeaveApplication")
    }
    
    func bannerAdWillClose(_ banner: VungleBanner) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "bannerAdWillClose")
    }
    
    func bannerAdDidClose(_ banner: VungleBanner) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "bannerAdDidClose")
    }
}

extension LOBannerViewController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CallbackLogTableCell", for: indexPath) as! CallbackLogTableViewCell
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.callbackLogs.count
    }

}
