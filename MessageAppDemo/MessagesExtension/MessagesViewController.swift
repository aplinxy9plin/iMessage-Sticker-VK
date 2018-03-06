import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    var stickers = [MSSticker]()

    private func loadStickers(first: Int, second: Int) {
        
       let image =  #imageLiteral(resourceName: "16.png")
    
        for i in first...second {
            let str = String(format: "%02d", i)
            if let url = Bundle.main.url(forResource: str, withExtension: "png") {
                
                do {
                    let sticker = try MSSticker(contentsOfFileURL: url, localizedDescription: "")
                    stickers.append(sticker)
                } catch {
                    print(error)
                }
            }
        }
    }
    private func setupStickerBrowser() {
        let controller = MSStickerBrowserViewController(stickerSize: .small)
        
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.stickerBrowserView.backgroundColor = UIColor.yellow
        controller.stickerBrowserView.dataSource = self
        view.topAnchor.constraint(equalTo: controller.view.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: controller.view.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: controller.view.rightAnchor).isActive = true
    }
    let labelOne: UILabel = {
        let label = UILabel()
        label.text = "Scroll Top"
        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelTwo: UILabel = {
        let label = UILabel()
        label.text = "Scroll Bottom"
        label.backgroundColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddBtn(arg: "bulka")
    }
    func setupAddBtn(arg: String) {
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        var scrollView: UIScrollView!
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        
        scrollView.contentSize = CGSize(width: screenWidth, height: 2000)
        view.addSubview(scrollView)
        var xvalue = 8;
        var yvalue = 17;
        var button = UIButton();
        var images: [UIImage] = []
        var nameArray: [String] = []
        switch arg {
        case "bulka":
            loadStickers(first: 6432, second: 6479)
            for i in 6432..<6480 {
                print(i)
                nameArray.append("\(i).png")
                images.append(UIImage(named: "\(i).png")!)
            }
        default:
            print("default")
        }
        var checkFive = 1
        for i in 0..<images.count {
            if(checkFive == 5){
                checkFive = 1
                xvalue = 8
                yvalue = yvalue + 110
            }
            checkFive = checkFive + 1
            button = UIButton(frame: CGRect(x: xvalue, y: yvalue, width: 90, height: 90))
            button.setImage(images[i], for: .normal)
            button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
            button.tag = i
            scrollView.addSubview(button)
            xvalue = xvalue + 90
        }
        print(yvalue)
    }
    
    func buttonClicked(sender: UIButton) {
        print(sender.tag)
        activeConversation?.insert(stickers[sender.tag], completionHandler: { (error) in
            print("123")
        })
        print("Button Clicked")
    }
    
    func btn1OnClick() {
        print("hello")
        
        // activeConversation 会话对象
        activeConversation?.insertText("hello", completionHandler: { (error) in
            print("插入信息成功")
        })
        // 插入一个表情
        activeConversation?.insert(stickers[0], completionHandler: { (error) in
            print("123")
        })
    }
    func btnOnClick() {
        print("hello")
        
        // activeConversation 会话对象
        activeConversation?.insertText("hello", completionHandler: { (error) in
            print("插入信息成功")
        })
        // 插入一个表情
        activeConversation?.insert(stickers[1], completionHandler: { (error) in
            print("123")
        })
    }
    // 当发生内存警告的时候调用
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    // 会话处理
    
    // 将要获取焦点
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
        print("willBecomeActive")
    }
    // 失去焦点
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
        print("didResignActive")
    }
    
   // 收到信息
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
        print("didReceive")
    }
    // 开始发送
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
        print("didStartSending")
    }
    // 取消发送
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
        print("didCancelSending")
        
    }
    // 将要过度,可以改变风格
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
        
        print("willTransition")
    }
    
    // 过度完毕
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
        print("didTransition")
    }

}
// MARK: - MSStickerBrowserViewDataSource 必须要实现的数据源方法
extension MessagesViewController: MSStickerBrowserViewDataSource{
    // 一共有多少个
    func numberOfStickers(in stickerBrowserView: MSStickerBrowserView) -> Int {
        return stickers.count
    }
    // 每一个要显示什么
    func stickerBrowserView(_ stickerBrowserView: MSStickerBrowserView, stickerAt index: Int) -> MSSticker {
        return stickers[index]
    }
}
