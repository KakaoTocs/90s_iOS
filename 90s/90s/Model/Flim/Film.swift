//
//  Film.swift
//  90s
//
//  Created by 김진우 on 2020/12/27.
//

import Foundation

struct Film {
    let id: String
    var name: String
    let createDate: String = Date().dateToString()
    var completeDate: String?
    var filterType : FilmFilterType
//    let filter: String
    private(set) var photos: [Photo]
    let maxCount: Int
    var state : FilmStateType = .adding
    
    @discardableResult
    mutating func add(_ photo: Photo) -> Bool {
        guard !isFull else { return false }
        photos.append(photo)
        return true
    }
}

extension Film {
    var count: Int {
        photos.count
    }
    
    var isFull: Bool {
        photos.count == maxCount
    }
}

/// Film 제작의 상태표
enum FilmStateType : Int {
    case adding = 0
    case printing = 1
    case complete = 2
    
    func contentTitle() -> String {
        switch self {
        case .adding : return "사진 추가 중"
        case .printing : return "인화중"
        case .complete : return "인화완료"
        }
    }
}

// MARK: 임시로 만든 필름 데이터

struct TestFilm {
    var filmName : String
    var filmImage : String
    var filmType : FilmFilterType?
}

extension TestFilm : Equatable {
    static func ==(lrs : TestFilm, rls : TestFilm) -> Bool {
        return lrs.filmName == rls.filmName
    }
}

enum FilmFilterType {
    case Cold
    case Cute
    case Nice
    case Hot
    case Dandy
}
extension FilmFilterType {
    var count: Int {
        self.hashValue
    }
}
