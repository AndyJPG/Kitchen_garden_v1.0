//
//  SearchTableViewCell.swift
//  Kitchen_garden_v0.3
//
//  Created by Peigeng Jiang on 2/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

protocol SearchTableViewCellDelegate: class {
    func didPressButton(_ tag: Int)
}

class SearchTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var cellDelegate: SearchTableViewCellDelegate?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var harvestLabel: UILabel!
    @IBOutlet weak var pImage: UIImageView!
    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var plusButtonBackground: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            cellBackground.backgroundColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
            plusButtonBackground.backgroundColor = UIColor.init(red: 96/255, green: 186/255, blue: 114/255, alpha: 1.0)
        }
        // Configure the view for the selected state
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        cellDelegate?.didPressButton(sender.tag)
    }
    

}
