# gemini_chat
通过使用Gemini API使用Xcode编写的简易gemini-chat工具，纯小白练手，希望大神加以改进！
相关教程请参阅：https://ai.google.dev/tutorials/swift_quickstart?hl=zh-cn 
使用前请先将“GenerativeAI-Info.plist”文件中的YOUR_API_KEY替换为你申请到的API

目前已实现的功能：
1.对话管理：默认提供初始页，在初始页有对话进行后创建名为初始页的对话，可以创建新对话（需命名对话标题）、删除对话。
2.纯文本对话下实现了多轮对话，可以就之前的对话内容进行提问。
3.关于发送图片：目前只能以单张图片的形式发送，并且图片输入不支持多轮对话，待后期完善。
4.对话历史存储：退出App时会自动存储历史消息，待重新启动自动调用。

注：1.代码如shit山，大佬轻点喷。
   2.可能存在闪退或其他异常情况，尝试重启App一般可以解决，但发生错误之前的对话不会被保存。

App截图：
<img src="https://github.com/sasha0996/gemini_chat/raw/main/assets/112504162/5a3b19fd-697b-4735-a1a4-c16e5a2cca2c.jpg" width="100">

<img src="https://github.com/sasha0996/gemini_chat/raw/main/assets/112504162/e24c6a7b-b824-45dd-90c7-5984b690a291.jpg" width="100">

<img src="https://github.com/sasha0996/gemini_chat/raw/main/assets/112504162/2472d94f-b640-4278-a9e9-a97d613589bd.jpg" width="100">

