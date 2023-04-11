//
//  PlacementSelectionTableViewController.swift
//  PublicSampleAppTrial
//
//  Created by John Mai on 12/28/22.
//

/**
 To see how each ad format is integrated, navigate to Ad Formats to see how to integrate ad type into project
 */

import UIKit
import VungleAdsSDK

class PlacementSelectionTableViewController: UIViewController {

    private let adTypesArr = Array((Bundle.main.infoDictionary?["Liftoff PlacementID"] as! Dictionary<String,Any>).keys)
    
    /// View which contains the loading text and the spinner
    private let loadingView = UIView()
    private var activityIndicator: UIActivityIndicatorView!

    /// Text shown during load the TableView
    private let loadingLabel = UILabel()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sdkVersionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sdkVersionLbl.text = "SDK Version: " + VungleAds.sdkVersion
        
        setLoadingScreen()
        
        // Initialize the SDK if it is not initialied already
        if (!VungleAds.isInitialized()) {
            VungleAds.initWithAppId(getAppID()!) { (error) in
                if (error != nil) {
                    print("Error initializing the SDK")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "Error initializing the SDK", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
                        self.present(alert, animated: true,completion: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.loadingLabel.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        self.tableView.reloadData()
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.loadingLabel.isHidden = true
                self.activityIndicator.stopAnimating()
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
        }
    }

    func getAppID() -> String? {
        let appID = Bundle.main.infoDictionary?["Liftoff Dashboard AppID"] as? String
        
        return appID
    }
    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {

        // Set the view which contains the loading text
        let width: CGFloat = 140
        let height: CGFloat = 30
        let x = (self.view.frame.width / 2) - (width / 2)
        let y = (self.view.frame.height / 2) - (height / 2)
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)

        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 26, width: 140, height: 30)
        loadingView.addSubview(loadingLabel)
        self.view.addSubview(loadingView)

        // Set the spinner
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
}

extension PlacementSelectionTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let numRow = Bundle.main.infoDictionary?["Liftoff PlacementID"] as! Dictionary<String, Any>
        return numRow.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placementIdCell", for: indexPath) as! PlacementTableViewCell
        cell.adTypeLbl.text = self.adTypesArr[indexPath.row]
        
        if let dictionary = Bundle.main.infoDictionary?["Liftoff PlacementID"] as? Dictionary<String,String> {
            cell.placementLbl.text = dictionary[cell.adTypeLbl.text!]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let selectedAdType = self.adTypesArr[indexPath.row]
        if selectedAdType == "Interstitial" {
            if let cell = tableView.cellForRow(at: indexPath) as? PlacementTableViewCell {
                self.performSegue(withIdentifier: "toInterstitialSegue", sender:cell.placementLbl.text)
            }
        } else if selectedAdType == "Banner" {
            if let cell = tableView.cellForRow(at: indexPath) as? PlacementTableViewCell {
                self.performSegue(withIdentifier: "toBannerSegue", sender:cell.placementLbl.text)
            }
        } else if selectedAdType == "Native" {
            if let cell = tableView.cellForRow(at: indexPath) as? PlacementTableViewCell {
                self.performSegue(withIdentifier: "toNativeSegue", sender:cell.placementLbl.text)
            }
        } else if selectedAdType == "MREC" {
            if let cell = tableView.cellForRow(at: indexPath) as? PlacementTableViewCell {
                self.performSegue(withIdentifier: "toMRECSegue", sender:cell.placementLbl.text)
            }
        } else if selectedAdType == "Rewarded" || selectedAdType == "Rewarded Playable" {
            if let cell = tableView.cellForRow(at: indexPath) as? PlacementTableViewCell {
                self.performSegue(withIdentifier: "toRewardedSegue", sender:cell.placementLbl.text)
            }
        } else {

            // Display popup indicating that this ad format is not yet supported
            let errorAlert = UIAlertController(title: "Confirm", message: "The ad format is not yet supported by the Liftoff SDK", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(errorAlert,animated: true,completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNativeSegue" {
            let vc = segue.destination as! LONativeAdViewController
            vc.placementId = sender as? String
        } else if segue.identifier == "toInterstitialSegue" {
            let vc = segue.destination as! LOInterstitialViewController
            vc.placementId = sender as? String
        } else if segue.identifier == "toRewardedSegue" {
            let vc = segue.destination as! LORewardedViewController
            vc.placementId = sender as? String
        } else if segue.identifier == "toBannerSegue" {
            let vc = segue.destination as! LOBannerViewController
            vc.placementId = sender as? String
        } else if segue.identifier == "toMRECSegue" {
            let vc = segue.destination as! LOMRECViewController
            vc.placementId = sender as? String
        }
    }
}
