//
//  LOInlineViewController.swift
//  PublicSampleAppTrial
//

import UIKit
import VungleAdsSDK

class LOInlineViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var placementId: String?
    var adView: VungleBannerView?
    var models = [InlineModel].init(repeating: InlineModel(), count: 10)
    let adCell = InlineAdCell(style: .default, reuseIdentifier: "adCell")

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Liftoff Inline Ad"
        if let placementId = placementId {
            adView = VungleBannerView(placementId: placementId, vungleAdSize: .VungleAdSizeFromCGSize(CGSize(width: 300, height: 300)))
            adView?.delegate = self
            adView?.load()
        }
    }

    @IBAction func btnPressed(_ sender:UIButton) {
    }
}

extension LOInlineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        if model.isAd {
            return adCell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InlineCell", for: indexPath) as? InlineCell else {
            return UITableViewCell()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return models[indexPath.row].cellHeight
    }
}

extension LOInlineViewController: VungleBannerViewDelegate {
    func bannerAdDidLoad(_ bannerView: VungleAdsSDK.VungleBannerView) {
        var adModel = InlineModel()
        adModel.isAd = true
        adModel.cellHeight = 300
        models.insert(adModel, at: 1)
        adCell.contentView.addSubview(bannerView)
        tableView.reloadData()
    }

    func bannerAdWillPresent(_ bannerView: VungleAdsSDK.VungleBannerView) {
        print("bannerAdWillPresent")
    }

    func bannerAdDidPresent(_ bannerView: VungleAdsSDK.VungleBannerView) {
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
        models = models.filter({ !$0.isAd })
        tableView.reloadData()
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

struct InlineModel {
    var cellHeight: CGFloat = 200
    var isAd = false
}
