//
//  RequestLabeling.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/26.
//

import Foundation
import Combine

struct RequestLabeling : Usecase {
 
    typealias Param = RequestData
    typealias Result = ImageEntity
    
    let imageRepository : ImageRepository
    
    func get(param : Param) -> Observable<Result> {
        return imageRepository.requestLabeling(labels: param.labels, images: param.images)
    }
    
    
    struct RequestData {
        let labels : Array<LabelEntity>
        let images : Array<ImageEntity>
    }
}
