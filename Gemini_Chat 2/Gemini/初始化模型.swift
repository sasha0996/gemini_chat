import GoogleGenerativeAI
import UIKit

enum APIKey {
  // Fetch the API key from `GenerativeAI-Info.plist`
  static var `default`: String {
    guard let filePath = Bundle.main.path(forResource: "GenerativeAI-Info", ofType: "plist")
    else {
      fatalError("Couldn't find file 'GenerativeAI-Info.plist'.")
    }
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let value = plist?.object(forKey: "API_KEY") as? String else {
      fatalError("Couldn't find key 'API_KEY' in 'GenerativeAI-Info.plist'.")
    }
    if value.starts(with: "_") {
      fatalError("Follow the instructions at https://ai.google.dev/tutorials/setup to get an API key.")
    }
    return value
  }
}

public var 由VC传入的历史记录:[ModelContent] = []

func ww (inputs:String) async->String{
    let config = GenerationConfig(maxOutputTokens: 1000)
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default,generationConfig: config
    ,safetySettings: [SafetySetting(harmCategory: .harassment, threshold: .blockNone)])
    let history = 由VC传入的历史记录
    // Initialize the chat
    let chat = model.startChat(history: history)
    let prompt:String = inputs
    let response = try! await chat.sendMessage(prompt)
    if let text = response.text {
      print(text)
    }
    return response.text ?? "0"
}

func pw (要发送的图片: UIImage) async->String{
    let model = GenerativeModel(name: "gemini-pro-vision", apiKey: APIKey.default)
    let image = 要发送的图片
    do {
        let response = try await model.generateContent(image)

        if let text = response.text {
            print(text)
            return response.text ?? "0"
        } else {
            print("Error: Response text is nil")
            return "0"
        }
    } catch {
        // 捕获错误并处理
        print("Error generating content: \(error)")
        return "0"
    }
}
