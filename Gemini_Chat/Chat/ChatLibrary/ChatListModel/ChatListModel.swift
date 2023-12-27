////
////  ChatListModel.swift
////  Chat
////
////  Created by Nirav on 14/06/19.
////  Copyright © 2019 Nirav. All rights reserved.
////
//
//import UIKit
//
//class ChatListModel: NSObject {
//    //调用消息数组
//    var chatMessages = [[ChatModel]]()
//    //调用了attemptToAssembleGroupedMessages方法，传递了从服务器获取的聊天消息数组
//    func reloadTableWithShorting(arrMessage : [ChatModel]) {
//        attemptToAssembleGroupedMessages(messagesFromServer: arrMessage)
//    }
//    //将消息按日期进行分类存储在以日期为键的字典中
//    fileprivate func attemptToAssembleGroupedMessages(messagesFromServer : [ChatModel]) {
//        print("Attempt to group our messages together based on Date property")
//        
//        let groupedMessages = Dictionary(grouping: messagesFromServer) { (element) -> Date in
//            return element.date.reduceToMonthDayYear()
//        }
//        //提取分类好的键，并将每一个键对应的消息数组保存在values中，并将values中的消息按时间升序排列后append在chatMassages之后
//        let sortedKeys = groupedMessages.keys.sorted()
//        sortedKeys.forEach { (key) in
//            var values = groupedMessages[key]
//            values = values!.sorted(by: {
//                $0.date.compare($1.date) == .orderedAscending
//            })
//            chatMessages.append(values!)
//        }
//    }
//}
////...................................................
//extension ChatListModel : UITableViewDelegate, UITableViewDataSource {
//    //提取tableView中的分区数量
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return chatMessages.count
//    }
//    //定义DateHeaderLabel
//    class DateHeaderLabel: UILabel {
//        
//        override init(frame: CGRect) {
//            super.init(frame: frame)
//            
//            backgroundColor = .black
//            textColor = .white
//            textAlignment = .center
//            translatesAutoresizingMaskIntoConstraints = false // enables auto layout
//            font = UIFont.boldSystemFont(ofSize: 14)
//        }
//        //要求子类实现的构造方法，确保了每个子类都能正确地处理从 nib 文件中加载的情况
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//        //重写视图自然大小
//        override var intrinsicContentSize: CGSize {
//            let originalContentSize = super.intrinsicContentSize
//            let height = originalContentSize.height + 12
//            layer.cornerRadius = height / 2
//            layer.masksToBounds = true
//            return CGSize(width: originalContentSize.width + 20, height: height)
//        }
//        
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if let firstMessageInSection = chatMessages[section].first {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "MM/dd/yyyy"
//            let dateString = dateFormatter.string(from: firstMessageInSection.date)
//            
//            let label = DateHeaderLabel()
//            label.text = dateString
//            //创建一个包含BILable的UIView，并将lable的中心点与view的中心点锚定
//            let containerView = UIView()
//            
//            containerView.addSubview(label)
//            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
//            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//            
//            return containerView
//            
//        }
//        return nil
//    }
//    
//    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return chatMessages[section].count
//    }
//    //配置并返回每个单元格
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
//        let chatMessage = chatMessages[indexPath.section][indexPath.row]
//        //cell.chatMessage = chatMessage
//        
//        cell.bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
//        cell.selectionStyle = .none
//        return cell
//    }
//}
////...................................................
//extension Date {
//    static func dateFromCustomString(customString: String) -> Date {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
//        return dateFormatter.date(from: customString) ?? Date()
//    }
//    
//    func reduceToMonthDayYear() -> Date {
//        let calendar = Calendar.current
//        let month = calendar.component(.month, from: self)
//        let day = calendar.component(.day, from: self)
//        let year = calendar.component(.year, from: self)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd/yyyy"
//        return dateFormatter.date(from: "\(month)/\(day)/\(year)") ?? Date()
//    }
//}
