import UIKit

class FileManagerHelper {
    static let shared = FileManagerHelper()

    private init() {}

    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    // 保存数据到文件
    func saveData<T: Codable>(_ data: T, toFile file: String) {
        let fileURL = documentsDirectory.appendingPathComponent(file)
        do {
            print("File saved at: \(fileURL.path)")

            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(data)
            try encodedData.write(to: fileURL)
        } catch {
            print("Error saving data to file: \(error)")
        }
    }

    // 从文件加载数据
    func loadData<T: Codable>(fromFile file: String, as type: T.Type) -> T? {
        let fileURL = documentsDirectory.appendingPathComponent(file)
        do {
            print("已加载数据")
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(type, from: data)
            return decodedData
        } catch {
            print("Error loading data from file: \(error)")
        }
        return nil
    }
}



