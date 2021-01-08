//
//  File.swift
//  
//
//  Created by Chhem Sronglong on 08.01.21.
//

import Foundation
import HealthDataSync
import HealthKit
import HealthKitToFhir
import FHIR

open class SleepAnalysisContainer : ResourceContainer<Observation>, HDSExternalObjectProtocol {
    internal let unit = "%"
    
    public static func authorizationTypes() -> [HKObjectType]? {
        if let oxygenSaturationType = healthKitObjectType() {
            return [oxygenSaturationType]
        }
        
        return nil
    }
    
    public static func healthKitObjectType() -> HKObjectType? {
        return HKObjectType.categoryType(forIdentifier: .sleepAnalysis)
    }
    
    public static func externalObject(object: HKObject, converter: HDSConverterProtocol?) -> HDSExternalObjectProtocol? {
        if let sample = object as? HKSample,
            sample.sampleType == SleepAnalysisContainer.healthKitObjectType() {
            return SleepAnalysisContainer(object: object, converter: converter)
        }
        
        return nil
    }
    
    public static func externalObject(deletedObject: HKDeletedObject, converter: HDSConverterProtocol?) -> HDSExternalObjectProtocol? {
        return SleepAnalysisContainer(deletedObject: deletedObject, converter: converter)
    }
    
    public func update(with object: HKObject) {
        print(object)
        if let sample = object as? HKQuantitySample {
            print(object)
            resource?.valueQuantity?.value = FHIRDecimal(Decimal(floatLiteral: sample.quantity.doubleValue(for: HKUnit(from: unit))))
        }
    }
}
