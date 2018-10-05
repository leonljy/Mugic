//
//  TrackTableViewCell.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 8. 7..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import UIKit

class TrackTableViewCell: UITableViewCell {
    
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var soloButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var volumeProgressBar: UISlider!
    @IBOutlet weak var changeNameButton: UIButton!
    
    
}


class AddTrackTableViewCell: UITableViewCell {
    @IBOutlet weak var addButton: UIButton!
}
