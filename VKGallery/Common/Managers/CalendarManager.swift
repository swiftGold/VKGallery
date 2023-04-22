//
//  CalendarManager.swift
//  VKGallery
//
//  Created by Сергей Золотухин on 22.04.2023.
//

import UIKit

protocol CalendarManagerProtocol {
    func fetchDateFromTimeStamp(ti: TimeInterval) -> String
}

final class CalendarManager {
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
}

extension CalendarManager: CalendarManagerProtocol {
    //Получаем строковое значение даты из timeStamp с учетом часового пояса
    func fetchDateFromTimeStamp(ti: TimeInterval) -> String {
        let dateFromUnix = Date(timeIntervalSince1970: ti)
        dateFormatter.dateFormat = "dd MMMM YYYY"
        dateFormatter.timeZone = .current
        let dateString = dateFormatter.string(from: dateFromUnix)
        return dateString
    }
}
