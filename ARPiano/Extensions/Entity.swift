//
//  Entity.swift
//  ARPiano
//
//  Created by Amina Kurtović on 31. 5. 2023..
//


import RealityKit

extension Entity {
    
    func getModelEntity() -> ModelEntity? {
      findModelEntity(in: self.children[0])
    }
    
    private func findModelEntity(in entity: Entity) -> ModelEntity? {

        guard let entity = entity as? ModelEntity else {
            return findModelEntity(in: entity.children[0])
        }

        return entity
    }

}
