//
//  LONativeAdViewController.swift
//  PublicSampleAppTrial
//
//  Created by John Mai on 12/29/22.
//

/**
 IMPORTANT: Please review and set the placementID inside the Info.plist file. To do so, please do the following:
 
 Navigate to project hierarchy in Xcode, and select Info. Expand Liftoff PlacementID and be sure that Native is set correctly. Please do the same for Liftoff Dashboard AppID as well inside the Info.plist file.
 */

import UIKit
import VungleAdsSDK

class LONativeAdViewController: UIViewController {
    private var nativeAd: VungleNative?
    
    private var callbackLogs: [CallbackLog] = []
    var placementId:String?
    
    // Use to change the position of the privacy icon for native ads
    private lazy var privacyPosition: NativeAdOptionsPosition = .topRight
    
    // Native Ad UI Components
    @IBOutlet weak var nativeAdView: UIView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var mediaView: MediaView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var sponsorLbl: UILabel!
    @IBOutlet weak var adTextLbl: UILabel!
    @IBOutlet weak var downloadBtn: UIButton!
    
    @IBOutlet weak var placementIdLbl: UILabel!
    @IBOutlet weak var loadBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Liftoff Native Ad"
        self.placementIdLbl.text = self.placementId

        self.callbackLogs = [
            CallbackLog(title: "nativeAdDidLoad", index: 0),
            CallbackLog(title: "nativeAdDidTrackImpression", index: 1),
            CallbackLog(title: "nativeAdDidClick", index: 2),
            CallbackLog(title: "nativeAdDidFailLoad", index: 3),
            CallbackLog(title: "nativeAdDidFailToPresent", index: 4)
        ]
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func btnPressed(_ sender: UIButton) {
        if sender == self.loadBtn {
            if self.nativeAd != nil {
                self.nativeAd?.delegate = nil
                self.nativeAd = nil
                
                AppUtil.resetLogMessage(tableView: self.tableView, callbacks: self.callbackLogs)
            }
            
            guard let placementId = self.placementId else {
                return
            }
            
            self.nativeAd = VungleNative(placementId: placementId)
            self.nativeAd?.delegate = self
            self.nativeAd?.load()
            
            // Feel free to change the position using NativeAdOptionsPosition enum
            self.nativeAd?.adOptionsPosition = self.privacyPosition
        } else if sender == self.playBtn {
            if (self.nativeAd?.canPlayAd() != nil) {
                
                // To specify clickable areas within the Native ad, you can include
                // an array of UIView objects using the API below.
                self.nativeAd?.registerViewForInteraction(view: self.nativeAdView,
                                                          mediaView: self.mediaView,
                                                          iconImageView: self.iconView,
                                                          viewController: self,
                                                          clickableViews: [self.iconView,self.downloadBtn,self.nativeAdView])
                playNativeAd()
            }
        } else if sender == self.closeBtn {
            self.nativeAd?.unregisterView()
            
            // Reset the values inside the labels
            self.titleLbl.text = "App Title"
            self.ratingLbl.text = "App Rating"
            self.sponsorLbl.text = "Sponsored by Text"
            self.adTextLbl.text = "Body Text"
            self.downloadBtn.setTitle("CTA Text", for: .normal)
        }
    }
    
    // MARK: Native Ad Helper Methods
    
    private func playNativeAd() {
        self.titleLbl.text = self.nativeAd?.title
        self.ratingLbl.text = "Rating: \(nativeAd?.adStarRating ?? 0)"
        self.sponsorLbl.text = self.nativeAd?.sponsoredText
        self.adTextLbl.text = self.nativeAd?.bodyText
        
        // Set the download button the text of the native ad
        self.downloadBtn.setTitle(self.nativeAd?.callToAction, for: .normal)
    }
}

// MARK: NativeAd Delegate Callbacks

extension LONativeAdViewController: VungleNativeDelegate {
    // Ad load Events
    func nativeAdDidLoad(_ native: VungleNative) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "nativeAdDidLoad")
    }
    
    func nativeAdDidFailToLoad(_ native: VungleNative, withError: NSError) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "nativeAdDidFailToLoad")
    }
    
    // Ad Lifecycle Events
    func nativeAdDidFailToPresent(_ native: VungleNative, withError: NSError) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "nativeAdDidFailToPresent")
    }
    
    func nativeAdDidTrackImpression(_ native: VungleNative) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "nativeAdDidTrackImpression")
    }
    
    func nativeAdDidClick(_ native: VungleNative) {
        print(#function)
        AppUtil.activeLogMessage(tableView: self.tableView, callbacks: self.callbackLogs, title: "nativeAdDidClick")
    }
}

// MARK: TableView for delegate callback for native ad

extension LONativeAdViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.callbackLogs.count
    }
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
