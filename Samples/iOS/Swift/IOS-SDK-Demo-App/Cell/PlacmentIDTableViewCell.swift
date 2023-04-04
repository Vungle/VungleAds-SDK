//
//  PlacementTableViewCell.swift
//  PublicSampleAppTrial
//
//  Created by John Mai on 12/28/22.
//

/**
 To see how each ad format is integrated, navigate to Ad Formats to see how to integrate ad type into an app.
 */

import UIKit

class PlacementTableViewCell: UITableViewCell {

    @IBOutlet weak var placementLbl: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var adTypeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
