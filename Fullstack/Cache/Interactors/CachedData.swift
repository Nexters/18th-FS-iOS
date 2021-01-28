//
//  RealmDataSource.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/27.
//

import Combine
import Foundation
import RealmSwift

struct CachedData: CachedDataSource {
    let realm: Realm = try! Realm()

    // 얘도 수정되어야 함
    func getAllImages() -> Observable<[ImageEntity]> {
        return Just(realm.objects(ImageRealmModel.self)).asObservable()
            .map { results in results.mapNotNull { $0.convertToEntity() }}.eraseToAnyPublisher()
    }

    // 수정되야 함
    func getUnLabeledImages(filtered: [ImageEntity]) -> Observable<[ImageEntity]> {
        return Just(realm.objects(ImageRealmModel.self)).asObservable()
            .map { results in results.mapNotNull { $0.convertToEntity() } }
            .eraseToAnyPublisher()
    }

    func getLabeldImages() -> Observable<[ImageEntity]> {
        return Just(realm.objects(ImageRealmModel.self)).asObservable()
            .map { results in results.mapNotNull { $0.convertToEntity() } }
            .eraseToAnyPublisher()
    }

    func getImages(labels: [LabelEntity], pageId: Int) -> Observable<[ImageEntity]> {
        let query: [ImageRealmModel] = realm.objects(ImageRealmModel.self)
            .filter { item in item.labels.contains { label in labels.contains { $0.id == label.id } } }
        return Just(query).asObservable()
            .map { result in result.mapNotNull { $0.convertToEntity() }}
            .eraseToAnyPublisher()
    }

    func getBookmarkImages() -> Observable<[ImageEntity]> {
        let query: [ImageRealmModel] = realm.objects(ImageRealmModel.self)
            .filter { $0.isBookmark }
        return Just(query).asObservable()
            .map { results in results.mapNotNull { $0.convertToEntity() }}
            .eraseToAnyPublisher()
    }

    func getImage(id: String) -> Observable<ImageEntity?> {
        let query: ImageRealmModel? = realm.objects(ImageRealmModel.self)
            .first { $0.id == id }
        return Just(query).asObservable()
            .map { $0?.convertToEntity() }
            .eraseToAnyPublisher()
    }

    func changeBookmark(isActive: Bool, image: ImageEntity) -> Observable<ImageEntity> {
        let query: ImageRealmModel? = realm.objects(ImageRealmModel.self)
            .first { $0.id == image.id }
        return Just(query).asObservable()
            .tryMap {
                $0?.isBookmark = isActive
                guard let entity = $0?.convertToEntity() else {
                    throw DomainError.DoNotFoundEntity
                }
                return entity
            }.eraseToAnyPublisher()
    }

    func requestLabeling(labels: [LabelEntity], images: [ImageEntity]) -> Observable<[ImageEntity]> {
        let needToAddedImages = images.filter { !$0.isCached }
        needToAddedImages.forEach { entity in
            let model = realm.create(ImageRealmModel.self)
            model.source = entity.source
            model.isBookmark = entity.isBookmark
            model.metaData = entity.metaData
        }
        let imageQuery: [ImageRealmModel] = realm.objects(ImageRealmModel.self)
            .filter { item in images.contains { $0.id == item.id }}

        let labelQuery: [LabelRealmModel] = realm.objects(LabelRealmModel.self)
            .filter { item in labels.contains { $0.id == item.id }}
        return Just((imageQuery, labelQuery)).asObservable()
            .map { imageQuery, labelQuery in
                imageQuery.forEach {
                    let neeToAddLabels: [LabelRealmModel] = labelQuery.applying($0.labels.difference(from: labelQuery)) ?? []
                    $0.labels.append(objectsIn: neeToAddLabels)
                }
                labelQuery.forEach {
                    let neeToAddImages: [ImageRealmModel] = imageQuery.applying($0.images.difference(from: imageQuery)) ?? []
                    $0.images.append(objectsIn: neeToAddImages)
                }
                return imageQuery.mapNotNull { $0.convertToEntity() }
            }.eraseToAnyPublisher()
    }

    func deleteLabel(labels: [LabelEntity], images: [ImageEntity]) -> Observable<[String]> {
        let imageQuery: [ImageRealmModel] = realm.objects(ImageRealmModel.self)
            .filter { item in images.contains { $0.id == item.id }}
        let labelQuery: [LabelRealmModel] = realm.objects(LabelRealmModel.self)
            .filter { item in labels.contains { $0.id == item.id }}
        return Just((imageQuery, labelQuery)).asObservable()
            .map { imageQuery, labelQuery in
                imageQuery.forEach { image in
                    labelQuery.forEach { item in
                        if let index = image.labels.firstIndex(where: { $0.id == item.id }) {
                            image.labels.remove(at: index)
                        }

                        if let index = item.images.firstIndex(where: { $0.id == image.id }) {
                            item.images.remove(at: index)
                        }
                    }
                }
                return imageQuery.mapNotNull { $0.id }
            }.eraseToAnyPublisher()
    }

    func deleteImages(images: [ImageEntity]) -> Observable<[String]> {
        let imageQuery: [ImageRealmModel] = realm.objects(ImageRealmModel.self)
            .filter { item in images.contains { $0.id == item.id }}

        return Just(imageQuery).asObservable()
            .map { imageQuery in
                let ids = imageQuery.map { $0.id }
                realm.delete(imageQuery)
                return ids
            }.eraseToAnyPublisher()
    }

    // Label
    func getAllLabels() -> Observable<[LabelEntity]> {
        return Just(realm.objects(LabelRealmModel.self)).asObservable()
            .map { results in results.mapNotNull { $0.convertToEntity() } }
            .eraseToAnyPublisher()
    }

    func searchLabel(keyword: String) -> Observable<[LabelEntity]> {
        let query = realm.objects(LabelRealmModel.self)
            .filter { item in item.name.contains(keyword) }
        return Just(query).asObservable()
            .map { results in results.mapNotNull { $0.convertToEntity() } }
            .eraseToAnyPublisher()
    }

    func getLabel(id: String) -> Observable<LabelEntity?> {
        let query = realm.objects(LabelRealmModel.self)
            .first { $0.id == id }
        return Just(query).asObservable()
            .map { $0?.convertToEntity() }
            .eraseToAnyPublisher()
    }

    func getRecentSearcheLabels(count: Int?) -> Observable<[LabelEntity]> {
        guard let realCount = count else {
            let query = realm.objects(LabelRealmModel.self)
                .sorted(by: { lhs, rhs in lhs.lastSearchedAt?.timeIntervalSince1970 ?? 0 > rhs.lastSearchedAt?.timeIntervalSince1970 ?? 0 })
            return Just(query).asObservable()
                .map { results in results.mapNotNull { $0.convertToEntity() } }
                .eraseToAnyPublisher()
        }

        let query = realm.objects(LabelRealmModel.self)
            .sorted(by: { lhs, rhs in lhs.lastSearchedAt?.timeIntervalSince1970 ?? 0 > rhs.lastSearchedAt?.timeIntervalSince1970 ?? 0 })
            .prefix(realCount)

        return Just(query).asObservable()
            .map { results in results.mapNotNull { $0.convertToEntity() } }
            .eraseToAnyPublisher()
    }

    func getRecentCreatedLabels(count: Int?) -> Observable<[LabelEntity]> {
        guard let realCount = count else {
            let query = realm.objects(LabelRealmModel.self)
                .sorted(by: { lhs, rhs in lhs.createdAt?.timeIntervalSince1970 ?? 0 > rhs.createdAt?.timeIntervalSince1970 ?? 0 })
            return Just(query).asObservable()
                .map { results in results.mapNotNull { $0.convertToEntity() } }
                .eraseToAnyPublisher()
        }

        let query = realm.objects(LabelRealmModel.self)
            .sorted(by: { lhs, rhs in lhs.createdAt?.timeIntervalSince1970 ?? 0 > rhs.createdAt?.timeIntervalSince1970 ?? 0 })
            .prefix(realCount)

        return Just(query).asObservable()
            .map { results in results.mapNotNull { $0.convertToEntity() } }
            .eraseToAnyPublisher()
    }

    func createLabel(name: String, color: ColorSet) -> Observable<LabelEntity> {
        let needToAddModel: LabelRealmModel = realm.create(LabelRealmModel.self)
        needToAddModel.name = name
        needToAddModel.color = color
        return Just(needToAddModel).asObservable()
            .tryMap { item in
                guard let entity = item.convertToEntity() else {
                    throw DomainError.DoNotFoundEntity
                }

                return entity
            }.eraseToAnyPublisher()
    }

    func deleteLabel(label: LabelEntity) -> Observable<String> {
        let query = realm.object(ofType: LabelRealmModel.self, forPrimaryKey: label.id)
        return Just(query).asObservable()
            .tryMap { item in
                guard let unwrappedItem = item else {
                    throw DomainError.DoNotFoundEntity
                }
                let id = unwrappedItem.id
                realm.delete(unwrappedItem)
                return id
            }.eraseToAnyPublisher()
    }

    func updateLabel(label: LabelEntity) -> Observable<LabelEntity> {
        let query = realm.object(ofType: LabelRealmModel.self, forPrimaryKey: label.id)
        return Just(query).asObservable()
            .tryMap { item in
                guard let unwrappedItem = item else {
                    throw DomainError.DoNotFoundEntity
                }
                unwrappedItem.color = label.color
                unwrappedItem.name = label.name
                guard let entity = unwrappedItem.convertToEntity() else {
                    throw DomainError.ConvertError
                }
                return entity
            }.eraseToAnyPublisher()
    }
}
