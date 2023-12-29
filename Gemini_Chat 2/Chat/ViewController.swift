import UIKit
import GoogleGenerativeAI

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    static var shared: ViewController = ViewController()

    var generativeModel: GenerativeModel!
    
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var 输入栏: UITextField!
    @IBOutlet weak var 标题: UILabel!
    @IBOutlet weak var 导航: UIView!
    @IBOutlet weak var 对话列表: UIButton!
    @IBOutlet weak var 新建对话: UIButton!
    @IBOutlet weak var 擦除按钮: UIButton!
    @IBOutlet weak var 添加图片按钮: UIButton!
    
    var historyModel = ModelContent(role: "", parts: "")
    var MessagesFromServer = [ChatModel]()
    static var 当前标题: String = ""
    static var List: [ListModel] = []
     
    override func viewDidLoad() {
        super.viewDidLoad()
        if let 存在的初始页  = ViewController.List.first(where: { $0.标题 == "起始页"}){
            MessagesFromServer = 存在的初始页.消息
        }
        // 刷新表格显示
        DispatchQueue.main.async {
            self.tblChat.reloadData()
        }

        标题.layer.cornerRadius = 10.0
        标题.clipsToBounds = true
        
        // 设置表格视图的圆角
        tblChat.layer.cornerRadius = 10.0
        tblChat.clipsToBounds = true
        
        导航.layer.cornerRadius = 10.0
        导航.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self,selector:#selector(处理删除按钮通知(_:)),name:Notification.Name("删除按钮点击通知"), object: nil)
           
        // 添加观察者来监听取消按钮点击通知
        NotificationCenter.default.addObserver(self, selector: #selector(处理取消按钮通知), name: Notification.Name("取消按钮点击通知"), object: nil)
          
        
        if let 当前消息 = ViewController.List.first(where: { $0.标题 == ViewController.当前标题 }){
            MessagesFromServer = 当前消息.消息
            DispatchQueue.main.async {
                self.tblChat.reloadData()
            }
        }else if let 当前消息 = ViewController.List.first(where: { $0.标题 == ViewController.当前标题 }){
            MessagesFromServer = 当前消息.消息
            DispatchQueue.main.async {
                self.tblChat.reloadData()
            }
        }else{
            ViewController.当前标题 = "起始页"
        }
        
        generativeModel = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
        输入栏.delegate = self
        
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
        if let index = ViewController.List.firstIndex(where: { $0.标题 == ListViewController.待删除数据标题 }) {
                           // 删除指定索引的元素
                    ViewController.List.remove(at: index)
                }
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        标题.text = ViewController.当前标题
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
            ViewController.List = ViewController.List
          
            print(标题.text!)
        }
        if segue.identifier == "新建对话"{
            let destinationVC = segue.destination as! NewListViewController
         
            destinationVC.List4 = ViewController.List
        }
        
    }
    
    @IBAction func 擦除按钮(_ sender: UIButton) {
        let E3  = ViewController.List.first(where: { $0.标题 == ViewController.当前标题})
        let E = ViewController.List.first(where: { $0.标题 == ViewController.当前标题})
        let E2  = ViewController.List.first(where: { $0.标题 == ViewController.当前标题})
        E3?.消息 = []
        E?.消息 = []
        E2?.消息 = []
        MessagesFromServer = []
        // 刷新表格显示
        DispatchQueue.main.async {
            self.tblChat.reloadData()
        }
    }
    
    @IBAction func 添加图片按钮(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          if let image = info[.originalImage] as? UIImage {
              // 将选择的图像赋值给类级别的属性
             let selectedImage = image
              // 将选中的图片添加到数组中
              let inputMessageModel = ChatModel(text: "", isIncoming: false, date: Date(), image: selectedImage)
              self.MessagesFromServer.append(inputMessageModel)
              // 刷新表格显示
              DispatchQueue.main.async {
                  self.tblChat.reloadData()
              }
              Task {
                  let generatedMessage = await pw(要发送的图片: selectedImage)
                  获取结果并添加到MessagesFromServer数组中( OUTPUT: generatedMessage)
                  刷新表格显示并滚动()
                  if let 当前消息 = ViewController.List.first(where: { $0.标题 == ViewController.当前标题 }){
                      当前消息.消息 = MessagesFromServer
                  }else{
                      let list = ListModel(标题: "起始页", 消息: [])
                      list.消息 = MessagesFromServer
                      ViewController.List.append(list)
                  }
              }
          }
          picker.dismiss(animated: true, completion: nil)
      }
    
    // 发送按钮点击事件
    @objc func 发送(_ sender: UIBarButtonItem?) {
        guard let userInput = 输入栏.text, !userInput.isEmpty else {
            return
        }
        if let 当前消息 = ViewController.List.first(where: { $0.标题 == ViewController.当前标题 }){
            MessagesFromServer = 当前消息.消息
            刷新表格显示并滚动()
            获取输入栏消息并添加到MessagesFromServer数组中(input: userInput)
            historyModel = ModelContent(role: "user", parts: userInput)
            由VC传入的历史记录.append(historyModel)
            historyModel = ModelContent(role: "model", parts: "")
            由VC传入的历史记录.append(historyModel)
            清空输入栏并收回键盘()
            刷新表格显示并滚动()
            // 使用 GenerativeModel 生成聊天内容
            Task {
                let generatedMessage = await ww(inputs: userInput)
                // 修改由VC传入的历史记录数组的最后一个元素
                if var lastElement = 由VC传入的历史记录.last {
                    // 进行相应的修改，例如修改 parts 属性
                    lastElement = ModelContent(role: "model", parts: generatedMessage)
                    // 将修改后的元素放回数组
                    由VC传入的历史记录[由VC传入的历史记录.count - 1] = lastElement
                }
                获取结果并添加到MessagesFromServer数组中( OUTPUT: generatedMessage)
                刷新表格显示并滚动()
                当前消息.消息 = MessagesFromServer
            }
        }else{
            let list = ListModel(标题: "起始页", 消息: [])
            获取输入栏消息并添加到MessagesFromServer数组中(input: userInput)
            historyModel = ModelContent(role: "user", parts: userInput)
            由VC传入的历史记录.append(historyModel)
            historyModel = ModelContent(role: "model", parts: "")
            由VC传入的历史记录.append(historyModel)
            清空输入栏并收回键盘()
            刷新表格显示并滚动()
            // 使用 GenerativeModel 生成聊天内容
            Task {
                let generatedMessage = await ww(inputs: userInput)
                // 修改由VC传入的历史记录数组的最后一个元素
                if var lastElement = 由VC传入的历史记录.last {
                    // 进行相应的修改，例如修改 parts 属性
                    lastElement = ModelContent(role: "model", parts: generatedMessage)
                    // 将修改后的元素放回数组
                    由VC传入的历史记录[由VC传入的历史记录.count - 1] = lastElement
                }
                获取结果并添加到MessagesFromServer数组中( OUTPUT: generatedMessage)
                刷新表格显示并滚动()
                list.消息 = MessagesFromServer
                ViewController.List.append(list)
              
            }
        }
    }
    
    func 获取结果并添加到MessagesFromServer数组中( OUTPUT: String){
            // 将生成的消息添加到数组中
        let generatedMessageModel = ChatModel(text: OUTPUT, isIncoming: true, date: Date(), image: UIImage())
            self.MessagesFromServer.append(generatedMessageModel)
    }
    
    func 获取输入栏消息并添加到MessagesFromServer数组中(input:String){
        // 将输入的消息添加到数组中
        let inputMessageModel = ChatModel(text: input, isIncoming: false, date: Date(), image: UIImage())
        self.MessagesFromServer.append(inputMessageModel)
        //print(inputMessageModel.imageData?.count)
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
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessagesFromServer.count
    }

    //控制Cell中label的内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
            let message = MessagesFromServer[indexPath.row]
        if message.text.isEmpty {
            // 消息中包含图片
            let imageData = message.imageData
            if let image = UIImage(data: imageData!) {
                // 创建包含图片的富文本
                let attachment = NSTextAttachment()
                // 设置最大宽度和最大高度
                let maxWidth: CGFloat = 200
                let maxHeight: CGFloat = 150
                // 计算调整后的大小
                var imageSize = image.size
                if imageSize.width > maxWidth {
                    imageSize.height = imageSize.height * (maxWidth / imageSize.width)
                    imageSize.width = maxWidth
                }
                if imageSize.height > maxHeight {
                    imageSize.width = imageSize.width * (maxHeight / imageSize.height)
                    imageSize.height = maxHeight
                }
                attachment.bounds = CGRect(origin: .zero, size: imageSize)
                attachment.image = image
                let imageString = NSAttributedString(attachment: attachment)
                // 将富文本赋值给 messageLabel
                cell.messageLabel.attributedText = imageString
            }
        } else {
            // 消息中只有文本
            cell.messageLabel.text = message.text
        }

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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        发送(nil) // 调用发送按钮的方法
        return true
    }
}
