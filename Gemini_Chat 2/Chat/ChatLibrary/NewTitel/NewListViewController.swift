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
    
    var List4: [ListModel] = []
  
    @IBOutlet weak var 标题栏: UITextField!
    @IBOutlet weak var 底板: UIView!
    @IBOutlet weak var 取消按钮: UIButton!
    @IBOutlet weak var 确认按钮: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        取消按钮.layer.cornerRadius = 10.0
        取消按钮.clipsToBounds = true
        
        确认按钮.layer.cornerRadius = 10.0
        确认按钮.clipsToBounds = true
        
        底板.layer.cornerRadius = 20.0
        底板.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(处理删除按钮通知(_:)), name: Notification.Name("删除按钮点击通知"), object: nil)
        
        if List4.count != 0 {
            ViewController.List = List4
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

            
            
            if let index = ViewController.List.firstIndex(where: { $0.标题 == ListViewController.待删除数据标题 }) {
                            // 删除指定索引的元素
                            ViewController.List.remove(at: index)
                        }
            
            
            
        }
    }
    
    // UITextFieldDelegate方法，用户点击 return 按钮时调用
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        确认按钮(UIButton()) // 调用确认按钮的方法
        return true
    }

    @IBAction func 取消按钮(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction func 确认按钮(_ sender: UIButton) {
        if let 新建标题 = ViewController.List.first(where: { $0.标题 == 标题栏.text }){
            // 弹出提示（可选）
            let alertController = UIAlertController(title: "标题重复", message: "已存在相同标题的对话，请重新命名！", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "好的", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            // 清空标题栏
            self.标题栏.text = ""
        }else{
            guard let userInput = 标题栏.text, !userInput.isEmpty else {
                return
            }
            let list1 = ListModel(标题: userInput, 消息: [])
            ViewController.List.append(list1)
        }

        self.performSegue(withIdentifier: "返回", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "返回" {
            let destinationVC = segue.destination as! ViewController
            let 标题文本 = 标题栏.text
            ViewController.当前标题 = 标题文本 ?? "0"
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


