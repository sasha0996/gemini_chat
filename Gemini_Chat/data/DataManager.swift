//
//  DataManager.swift
//  Chat
//
//  Created by 宋少辉 on 2023/12/26.
//  Copyright © 2023 Nirav. All rights reserved.
//

import Foundation

class DataManager {
    static let shared = DataManager()

    private init() {}

    // 保存数据到UserDefaults
    func saveData<T: Encodable>(data: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(data) {
            UserDefaults.standard.set(encodedData, forKey: key)
        }
    }

    // 从UserDefaults读取数据
    func loadData<T: Decodable>(forKey key: String, as type: T.Type) -> T? {
        if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode(type, from: savedData) {
                return loadedData
            }
        }
        return nil
    }
}
