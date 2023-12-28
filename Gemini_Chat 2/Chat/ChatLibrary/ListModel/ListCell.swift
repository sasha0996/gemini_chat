//
//  ListCell2.swift
//  Chat
//
//  Created by 宋少辉 on 2023/12/24.
//  Copyright © 2023 Nirav. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var 标题: UILabel!
    @IBOutlet weak var 删除按钮: UIButton!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // 设置标题标签的圆角矩形背景
            标题.layer.cornerRadius = 10.0
            标题.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func 删除按钮(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("删除按钮"), object: self)
    }
}
