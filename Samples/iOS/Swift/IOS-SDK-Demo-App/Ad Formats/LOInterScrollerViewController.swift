//
//  LOInterScrollerViewController.swift
//  IOS-SDK-Demo-App
//
//  Created by Manoj Budumuru on 10/4/24.
//

import UIKit
import VungleAdsSDK

class LOInterScrollerViewController: UIViewController {
    var placementId: String?
    var banner: VungleBannerView?
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Liftoff InterScroller display"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let rect: CGRect = view.safeAreaLayoutGuide.layoutFrame
        heightConstraint.constant = rect.height
        view.layoutIfNeeded()
        if let placementId = placementId {
            let bannerAd = VungleBannerView(placementId: placementId, vungleAdSize: .VungleAdSizeFromCGSize(rect.size))
            bannerAd.delegate = self
            bannerAd.load()
            adView.addSubview(bannerAd)
            banner = bannerAd
        }
    }
    
    // use this method to set the constarints to the Ad.
    func setAdLayoutConstraints() {
        if let bannerad = banner {
            bannerad.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                bannerad.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                bannerad.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                bannerad.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                bannerad.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                bannerad.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height)
            ])
        }
    }
}

extension LOInterScrollerViewController: VungleBannerViewDelegate {
    func bannerAdDidLoad(_ bannerView: VungleAdsSDK.VungleBannerView) {
        print("bannerAdDidLoad")
    }

    func bannerAdWillPresent(_ bannerView: VungleAdsSDK.VungleBannerView) {
        print("bannerAdWillPresent")
    }

    func bannerAdDidPresent(_ bannerView: VungleAdsSDK.VungleBannerView) {
        self.setAdLayoutConstraints()
        print("bannerAdDidPresent")
    }

    func bannerAdDidFail(_ bannerView: VungleAdsSDK.VungleBannerView, withError: NSError) {
        let alert = UIAlertController(title: "Load Ad Error", message: withError.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        present(alert, animated: true,completion: nil)
    }

    func bannerAdWillClose(_ bannerView: VungleAdsSDK.VungleBannerView) {
        print("bannerAdWillClose")
    }

    func bannerAdDidClose(_ bannerView: VungleAdsSDK.VungleBannerView) {
        print("bannerAdDidClose")
    }

    func bannerAdDidTrackImpression(_ bannerView: VungleAdsSDK.VungleBannerView) {
        print("bannerAdDidTrackImpression")
    }

    func bannerAdDidClick(_ bannerView: VungleAdsSDK.VungleBannerView) {
        print("bannerAdDidClick")
    }

    func bannerAdWillLeaveApplication(_ bannerView: VungleAdsSDK.VungleBannerView) {
        print("bannerAdWillLeaveApplication")
    }
}
