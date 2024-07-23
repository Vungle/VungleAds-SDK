//
//  InlineCell.swift
//  PublicSampleAppTrial
//
import UIKit

class InlineCell: UITableViewCell {

    @IBOutlet weak var callbackLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.textLabel?.text = "Inline demo"
        self.imageView?.image = UIImage(named: "Liftoff-monetize-demo")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

class InlineAdCell: UITableViewCell {

    override func awakeFromNib() {
        self.selectionStyle = .none
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
