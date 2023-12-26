//
//  ListModel.swift
//  Chat
//
//  Created by 宋少辉 on 2023/12/24.
//  Copyright © 2023 Nirav. All rights reserved.

//import Foundation
//
//class ListModel{
//    var 标题: String
//    var 消息: [ChatModel]
//    init(标题: String, 消息: [ChatModel]) {
//        self.标题 = 标题
//        self.消息 = 消息
//    }
//}
//



import Foundation

class ListModel: Codable {
    var 标题: String
    var 消息: [ChatModel]

    init(标题: String, 消息: [ChatModel]) {
        self.标题 = 标题
        self.消息 = 消息
    }
}



