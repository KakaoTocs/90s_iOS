//
//  Photo.swift
//  90s
//
//  Created by 김진우 on 2020/12/27.
//

import UIKit

// 필름에 추가된 후
struct Photo {
    let id: String
    let url: String
    let date: String
    
    func isEqual(id: String) -> Bool {
        return self == id
    }
}


extension Photo: Equatable {
    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func ==(lhs: Photo, rhs: String) -> Bool {
        return lhs.id == rhs
    }
    
    var image: UIImage {
        return UIImage(named: "photo\(Int.random(in: 0...8)).png")!
    }
}


// MARK: 임시로 만든 사진 데이터

struct TestPhoto {
    var image: String
}
