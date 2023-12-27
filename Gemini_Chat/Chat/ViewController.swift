import UIKit
import GoogleGenerativeAI



class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var 输入栏: UITextField!
    @IBOutlet weak var 标题: UILabel!
    @IBOutlet weak var 导航: UIView!
    
    @IBOutlet weak var 对话列表: UIButton!
    @IBOutlet weak var 新建对话: UIButton!
    @IBOutlet weak var 擦除按钮: UIButton!
    
    static var shared: ViewController = ViewController()
    
    
    var 当前标题: String = ""
    var generativeModel: GenerativeModel!
    //var objcChatModel: ChatModel = ChatModel(text: "", isIncoming: false, date: Date())
   // var objcChatListModel : ChatListModel = ChatListModel()
    var MessagesFromServer = [ChatModel]()

    static var List: [ListModel] = [] 


    var 待删除数据标题inVC: String = ""
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let 存在的初始页  = ListViewController.List2.first(where: { $0.标题 == "起始页"}){
       
            MessagesFromServer = 存在的初始页.消息
            
        }
        
        
        // 刷新表格显示
        DispatchQueue.main.async {
            self.tblChat.reloadData()
            
        }
//        // 将按钮的背景色设置为透明
//        新建对话.setBackgroundImage(UIImage(), for: .normal)
//        对话列表.setBackgroundImage(UIImage(), for: .normal)
//        
//        新建对话.alpha = 1.0
//        对话列表.alpha = 1.0

        
        标题.layer.cornerRadius = 10.0
        标题.clipsToBounds = true
        
        
        // 设置表格视图的圆角
        tblChat.layer.cornerRadius = 10.0
        tblChat.clipsToBounds = true
        
        导航.layer.cornerRadius = 10.0
        导航.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(处理删除按钮通知(_:)), name: Notification.Name("删除按钮点击通知"), object: nil)
           
        // 添加观察者来监听取消按钮点击通知
                NotificationCenter.default.addObserver(self, selector: #selector(处理取消按钮通知), name: Notification.Name("取消按钮点击通知"), object: nil)
          
        
        if let 当前消息 = ViewController.List.first(where: { $0.标题 == 当前标题 }){
            MessagesFromServer = 当前消息.消息
        }else{
            当前标题 = "起始页"
//
        }
        
        DispatchQueue.main.async {
            self.tblChat.reloadData()
        }
      
        
        generativeModel = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)

        输入栏.delegate = self
        
        //navigationItem.title = "Gemini Chat"
        //navigationController?.navigationBar.prefersLargeTitles = false
        
        
        setupTableView()

        // 添加点击空白处收回键盘的手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    // 处理取消按钮点击通知
       @objc func 处理取消按钮通知() {
           // 刷新 tableView
           // 注意：在这里更新 tableView 的数据源，然后调用 tableView.reloadData()
           tblChat.reloadData()
       }
    
    @objc func 处理删除按钮通知(_ notification: Notification) {
            if let 删除标题 = notification.userInfo?["删除标题"] as? String {
                待删除数据标题inVC = 删除标题
                
                if let index = ViewController.List.firstIndex(where: { $0.标题 == 待删除数据标题inVC }) {
                           // 删除指定索引的元素
                    ViewController.List.remove(at: index)
                           
                           // 在这里你可以更新 ViewController 中相关的界面或逻辑
                       }
            }
        }
    
    
    
    
    
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        标题.text = 当前标题
    }

    
    
    
    // 处理点击空白处的手势
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        输入栏.resignFirstResponder()
    }

    
    @IBAction func 新建对话(_ sender: UIButton) {
    
       self.performSegue(withIdentifier: "新建对话", sender: self)
     
    }
   
    
    
    
    @IBAction func 对话列表(_ sender: UIButton) {
    self.performSegue(withIdentifier: "对话列表", sender: self)
    
    
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "对话列表"{
            let destinationVC = segue.destination as! ListViewController
         
            ListViewController.List2 = ViewController.List
            destinationVC.当前标题inLVC = 标题.text!
            print(标题.text!)
        }
        
        if segue.identifier == "新建对话"{
            let destinationVC = segue.destination as! NewListViewController
         
            destinationVC.List4 = ViewController.List
        }
        
    }
    
    
    
    
    
    @IBAction func 擦除按钮(_ sender: UIButton) {
        let E3  = NewListViewController.List3.first(where: { $0.标题 == 当前标题})
        let E = ViewController.List.first(where: { $0.标题 == 当前标题})
        let E2  = ListViewController.List2.first(where: { $0.标题 == 当前标题})
        E3?.消息 = []
        E?.消息 = []
        E2?.消息 = []
        MessagesFromServer = []
        // 刷新表格显示
        DispatchQueue.main.async {
            self.tblChat.reloadData()
            
        }
    }
    
    
    
    
    
    // 发送按钮点击事件
    @objc func 发送(_ sender: UIBarButtonItem?) {
        guard let userInput = 输入栏.text, !userInput.isEmpty else {
            return
        }
        if let 当前消息 = ViewController.List.first(where: { $0.标题 == 当前标题 }){
            MessagesFromServer = 当前消息.消息
            刷新表格显示并滚动()
            
            获取输入栏消息并添加到MessagesFromServer数组中(input: userInput)
            清空输入栏并收回键盘()
            刷新表格显示并滚动()
            
            // 使用 GenerativeModel 生成聊天内容
            async {
                let generatedMessage = await ww(inputs: userInput)
                
                获取结果并添加到MessagesFromServer数组中(INPUT: userInput, OUTPUT: generatedMessage)
                
                刷新表格显示并滚动()
                当前消息.消息 = MessagesFromServer
            }
        }else{
            let list = ListModel(标题: "起始页", 消息: [])
            
            获取输入栏消息并添加到MessagesFromServer数组中(input: userInput)
            清空输入栏并收回键盘()
            刷新表格显示并滚动()
            
            // 使用 GenerativeModel 生成聊天内容
            async {
                let generatedMessage = await ww(inputs: userInput)
                
                获取结果并添加到MessagesFromServer数组中(INPUT: userInput, OUTPUT: generatedMessage)
                
                刷新表格显示并滚动()
                list.消息 = MessagesFromServer
                
                ViewController.List.append(list)
            }
            
        }
        
        
    }
    
    
    
    
    
    func 获取结果并添加到MessagesFromServer数组中(INPUT: String, OUTPUT: String){
            // 将生成的消息添加到数组中
            let generatedMessageModel = ChatModel(text: OUTPUT, isIncoming: true, date: Date())
            self.MessagesFromServer.append(generatedMessageModel)
        
    }
    
    
    func 获取输入栏消息并添加到MessagesFromServer数组中(input:String){
        // 将输入的消息添加到数组中
        let inputMessageModel = ChatModel(text: input, isIncoming: false, date: Date())
        self.MessagesFromServer.append(inputMessageModel)
    }
    
    func 清空输入栏并收回键盘(){
        // 清空输入栏
        self.输入栏.text = ""

        // 收回键盘
        self.输入栏.resignFirstResponder()
    }

    
    func 刷新表格显示并滚动() {
        // 刷新表格显示
        DispatchQueue.main.async {
        self.tblChat.reloadData()

        // 滚动到新消息位置
        let indexPath = IndexPath(row: self.MessagesFromServer.count - 1, section: 0)
        self.tblChat.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    
    
    
    
    func setupTableView() {
        tblChat.register(UINib(nibName: "ChatMessageCell", bundle: nil), forCellReuseIdentifier: "ChatMessageCell")

        tblChat.rowHeight = UITableView.automaticDimension
        tblChat.estimatedRowHeight = 60.0

        tblChat.delegate = self
        tblChat.dataSource = self
        
        //objcChatListModel.reloadTableWithShorting(arrMessage: MessagesFromServer)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessagesFromServer.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell

            let message = MessagesFromServer[indexPath.row]
            cell.messageLabel.text = message.text

            // 添加长按手势
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
            cell.addGestureRecognizer(longPressGesture)

            cell.timeLabel.text = formatDate(message.date)

            if message.isIncoming {
                // 接收消息的样式
                cell.leadingConstraint.isActive = true
                cell.trailingConstraint.isActive = false
                cell.bubbleBackgroundView.backgroundColor = #colorLiteral(red: 0.8039215686, green: 0.5529411765, blue: 0.4784313725, alpha: 1)
            } else {
                // 发送消息的样式
                cell.leadingConstraint.isActive = false
                cell.trailingConstraint.isActive = true
                cell.bubbleBackgroundView.backgroundColor = #colorLiteral(red: 0.8588235294, green: 0.8, blue: 0.5843137255, alpha: 1)
            }

            return cell
        }
    
    
    
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard gestureRecognizer.state == .began else { return }

        if let cell = gestureRecognizer.view as? ChatMessageCell {
            guard let textToCopy = cell.messageLabel.text else { return }

            let pasteboard = UIPasteboard.general
            pasteboard.string = textToCopy

            // 弹出提示（可选）
            let alertController = UIAlertController(title: "复制成功", message: "消息已复制到剪贴板", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "好的", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    


    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 设置时间格式
        return formatter.string(from: date)
    }

    // UITextFieldDelegate方法，用户点击 return 按钮时调用
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        发送(nil) // 调用发送按钮的方法
        return true
    }
    
    
    
    
    
    
    
    
    
    
    
    
}


