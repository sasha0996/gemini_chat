//
//  NewListViewController.swift
//  Chat
//
//  Created by 宋少辉 on 2023/12/24.
//  Copyright © 2023 Nirav. All rights reserved.
//

import UIKit

class NewListViewController: UIViewController, UITextFieldDelegate {
    
    static let shared = NewListViewController()
    static var List3: [ListModel] = []
    
    var 待删除数据标题inNLVC: String = ""
    var List4: [ListModel] = []
  
    @IBOutlet weak var 标题栏: UITextField!
    @IBOutlet weak var 底板: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        底板.layer.cornerRadius = 20.0
        底板.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(处理删除按钮通知(_:)), name: Notification.Name("删除按钮点击通知"), object: nil)
        
        if List4.count != 0 {
            NewListViewController.List3 = List4
            List4 = []
        }
        
        // 设置标题栏的代理为当前视图控制器
        标题栏.delegate = self
        
        // 添加点击空白处收回键盘的手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    // 处理点击空白处的手势
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        标题栏.resignFirstResponder()
    }
    
    // 处理删除按钮通知
    @objc func 处理删除按钮通知(_ notification: Notification) {
        if let 删除标题 = notification.userInfo?["删除标题"] as? String {
            待删除数据标题inNLVC = 删除标题
            print("NLVC中删除元素:\(待删除数据标题inNLVC)")
            
            if let index = NewListViewController.List3.firstIndex(where: { $0.标题 == 待删除数据标题inNLVC }) {
                // 删除指定索引的元素
                NewListViewController.List3.remove(at: index)
                // 在这里你可以更新 ViewController 中相关的界面或逻辑
            }
            
            // 在这里你可以更新 NewListViewController 中相关的界面或逻辑
        }
    }
    
    // UITextFieldDelegate方法，用户点击 return 按钮时调用
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        确认按钮(UIButton()) // 调用确认按钮的方法
        return true
    }

    @IBAction func 确认按钮(_ sender: UIButton) {
        guard let userInput = 标题栏.text, !userInput.isEmpty else {
            return
        }
        let list1 = ListModel(标题: userInput, 消息: [])
        
        NewListViewController.List3.append(list1)
        
        self.performSegue(withIdentifier: "返回", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "返回" {
            let destinationVC = segue.destination as! ViewController
            destinationVC.List = NewListViewController.List3
            let 标题文本 = 标题栏.text
            destinationVC.当前标题 = 标题文本 ?? "0"
        }
    }
}






    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


