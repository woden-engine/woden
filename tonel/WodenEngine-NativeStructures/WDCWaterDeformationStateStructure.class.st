Class {
	#name : #WDCWaterDeformationStateStructure,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#clipMapPeriod => Float32x2',
		'#padding => Float32x2',
		'#harmonics => (WDCWaterHarmonic array: 5)'
	],
	#category : #'WodenEngine-NativeStructures-Core-Material'
}

{ #category : #accessing }
WDCWaterDeformationStateStructure >> clipMapPeriod [
	^ clipMapPeriod
]

{ #category : #accessing }
WDCWaterDeformationStateStructure >> clipMapPeriod: anObject [
	clipMapPeriod := anObject
]

{ #category : #accessing }
WDCWaterDeformationStateStructure >> harmonics [
	^ harmonics
]

{ #category : #accessing }
WDCWaterDeformationStateStructure >> harmonics: anObject [
	harmonics := anObject
]
