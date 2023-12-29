import UIKit

class ChatModel: NSObject, Codable {
    // 设置消息的属性：text-消息内容、isIncoming-是否为输入、date-时间
    var text: String
    var isIncoming: Bool
    var date: Date
    var imageData: Data?

    // 初始化ChatModel
    init(text: String, isIncoming: Bool, date: Date, image: UIImage? = nil) {
        self.text = text
        self.isIncoming = isIncoming
        self.date = date
        self.imageData = image?.pngData() // 将UIImage转换为Data
        super.init()
    }

    // Decodable 协议的遵循
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // 根据 CodingKeys 解码其他属性
        text = try container.decode(String.self, forKey: .text)
        isIncoming = try container.decode(Bool.self, forKey: .isIncoming)
        date = try container.decode(Date.self, forKey: .date)

        // 解码 image 字段，处理可能为 null 的情况
        if let imageData = try? container.decode(Data.self, forKey: .image) {
            self.imageData = imageData
        } else {
            self.imageData = nil
        }
    }

    // Encodable 协议的遵循
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        // 根据 CodingKeys 编码其他属性
        try container.encode(text, forKey: .text)
        try container.encode(isIncoming, forKey: .isIncoming)
        try container.encode(date, forKey: .date)
        try container.encode(imageData, forKey: .image)
    }

    // CodingKeys 枚举用于指定属性的键
    enum CodingKeys: String, CodingKey {
        case text
        case isIncoming
        case date
        case image
    }
}
