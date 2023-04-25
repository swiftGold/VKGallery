//
//  CalendarManager.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 22.04.2023.
//

import UIKit

protocol CalendarManagerProtocol {
    func fetchStringFromTimeStamp(ti: TimeInterval) -> String
    func fetchDateFromTimeStamp(ti: TimeInterval) -> Date
}

final class CalendarManager {
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
}

extension CalendarManager: CalendarManagerProtocol {
    func fetchStringFromTimeStamp(ti: TimeInterval) -> String {
        let dateFromUnix = Date(timeIntervalSince1970: ti)
        dateFormatter.dateFormat = "dd MMMM YYYY"
        dateFormatter.timeZone = .current
        let dateString = dateFormatter.string(from: dateFromUnix)
        return dateString
    }
    
    func fetchDateFromTimeStamp(ti: TimeInterval) -> Date {
        let date = Date(timeIntervalSince1970: ti)
        return date
    }
}
