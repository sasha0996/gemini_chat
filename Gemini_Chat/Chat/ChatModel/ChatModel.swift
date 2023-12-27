//
//  ChatModel.swift
//  Chat
//
//  Created by Nirav on 14/06/19.
//  Copyright © 2019 Nirav. All rights reserved.
//

//import UIKit
//
//class ChatModel: NSObject {
//    //设置消息的属性：text-消息内容、isIncoming-是否为输入、date-时间
//    var text: String
//    var isIncoming: Bool
//    var date: Date
//    //初始化ChatModel
//    init(text: String, isIncoming: Bool, date: Date) {
//        self.text = text
//        self.isIncoming = isIncoming
//        self.date = date
//        //已删除-super.init()
//    }


import UIKit

class ChatModel: NSObject, Codable {
    // 设置消息的属性：text-消息内容、isIncoming-是否为输入、date-时间
    var text: String
    var isIncoming: Bool
    var date: Date

    // 初始化ChatModel
    init(text: String, isIncoming: Bool, date: Date) {
        self.text = text
        self.isIncoming = isIncoming
        self.date = date
        super.init()
    }
}

