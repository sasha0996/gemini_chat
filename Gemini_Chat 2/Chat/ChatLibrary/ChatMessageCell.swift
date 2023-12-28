//
//  ChatMessageCell.swift
//  Chat
//
//  Created by Nirav on 14/06/19.
//  Copyright © 2019 Nirav. All rights reserved.
//

import UIKit

class ChatMessageCell: UITableViewCell {
    
    @IBOutlet var messageLabel : UILabel!{
        didSet {
            messageLabel.isUserInteractionEnabled = true
        }
    }
    @IBOutlet var timeLabel : UILabel!
    @IBOutlet var bubbleBackgroundView : UIView!
    
    @IBOutlet var leadingConstraint: NSLayoutConstraint!
    @IBOutlet var trailingConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 允许多行文本
        messageLabel.numberOfLines = 0
        // 设置文本截断方式，可以根据需要选择 .byWordWrapping 或 .byTruncatingTail
        messageLabel.lineBreakMode = .byWordWrapping
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 }
}
