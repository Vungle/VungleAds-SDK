//
//  LOMRECViewController.swift
//  PublicSampleAppTrial
//
//  Created by John Mai on 1/12/23.
//

/**
 IMPORTANT: Please review and set the placementID inside the Info.plist file. To do so, please do the following:
 
 Navigate to project hierarchy in Xcode, and select Info. Expand Liftoff PlacementID and be sure that MREC is set correctly. Please do the same for Liftoff Dashboard AppID as well inside the Info.plist file.
 */

import UIKit
import VungleAdsSDK

class LOMRECViewController: LOBannerViewController {
    private var mrecAd: VungleBanner?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Liftoff Medium Rectangle Ad"
    }
    
    override func btnPressed(_ sender: UIButton) {
        if sender == self.loadBtn {
            guard let placementId = self.placementId else {
                return
            }
            self.mrecAd = VungleBanner(placementId: placementId, size: BannerSize.mrec)
            self.mrecAd?.delegate = self
            self.mrecAd?.load()
        } else if sender == self.playBtn {
            // Determines whether the banner object is nil in addition to whether the ad assets have been downloaded successfully
            if ((self.mrecAd?.canPlayAd()) != nil) {
                self.mrecAd?.present(on: self.bannerAdContainer)
            }
        } else if sender == self.closeBtn {
            for subViews in self.bannerAdContainer.subviews {
                subViews.removeFromSuperview()
            }
            self.mrecAd?.delegate = nil
            self.mrecAd = nil
            
            AppUtil.resetLogMessage(tableView: self.tableView, callbacks: self.callbackLogs)
        }
    }
}
