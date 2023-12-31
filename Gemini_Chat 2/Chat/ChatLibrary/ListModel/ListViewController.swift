import UIKit

class ListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    // 共享实例
    static let shared = ListViewController()
    
    static var 待删除数据标题: String = ""
  
    @IBOutlet weak var tabList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 刷新表格显示
        DispatchQueue.main.async {
            self.tabList.reloadData()
        }
    
        // 隐藏分割线
        tabList.separatorStyle = .none
        
        // 设置表格视图的圆角
        tabList.layer.cornerRadius = 10.0
        tabList.clipsToBounds = true
        
        // 注册 ListCell 的 Nib 文件
        let nib = UINib(nibName: "ListCell", bundle: nil)
        tabList.register(nib, forCellReuseIdentifier: "ListCell")
        
        // 设置UITableView的数据源和委托
        tabList.dataSource = self
        tabList.delegate = self
        
        // 添加观察者来监听删除按钮的点击事件
                NotificationCenter.default.addObserver(self, selector: #selector(删除按钮点击(_:)), name: Notification.Name("删除按钮"), object: nil)
   }
    // 监听删除按钮的点击事件
       @objc func 删除按钮点击(_ notification: Notification) {
           if let cell = notification.object as? ListCell,
              let indexPath = tabList.indexPath(for: cell) {
               // 获取所点击的单元格的标题
               let 删除标题 = ViewController.List[indexPath.row].标题
               // 将标题赋值给待删除数据的标题
               ListViewController.待删除数据标题 = 删除标题
               if let index = ViewController.List.firstIndex(where: { $0.标题 == ListViewController.待删除数据标题 }) {
                              // 删除指定索引的元素
                   ViewController.List.remove(at: index)
                              
                       // 刷新tableView界面
                                   tabList.reloadData()
                              // 在这里你可以更新 ViewController 中相关的界面或逻辑
                          }
               // 发送通知，将删除的标题传递给其他视图控制器
                       NotificationCenter.default.post(name: Notification.Name("删除按钮点击通知"), object: self, userInfo: ["删除标题": 删除标题])
           }
       }

    @IBAction func 取消按钮(_ sender: UIButton) {
        // 发送通知，通知 ViewController 刷新 tableView
           NotificationCenter.default.post(name: Notification.Name("取消按钮点击通知"), object: self)
        dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewController.List.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
        // 设置ListCell中的UILabel内容为List2数组中每个元素的.标题属性
        cell.标题.text = ViewController.List[indexPath.row].标题
        let listModel = ViewController.List[indexPath.row]
        // 根据条件决定是否显示 "删除按钮"
        if listModel.标题 == ViewController.当前标题 {
                cell.删除按钮.isHidden = true
            } else {
                cell.删除按钮.isHidden = false
            }
        return cell
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedModel = ViewController.List[indexPath.row].标题
        let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        ViewController.当前标题 = selectedModel
        //ViewController.List = ListViewController.List2

        // 设置目标视图控制器以全屏方式呈现
        detailViewController.modalPresentationStyle = .fullScreen
        
        // 呈现目标视图控制器
        self.present(detailViewController, animated: true, completion: nil)
    }   
}
