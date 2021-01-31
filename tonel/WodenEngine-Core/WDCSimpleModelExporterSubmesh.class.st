Class {
	#name : #WDCSimpleModelExporterSubmesh,
	#superclass : #Object,
	#instVars : [
		'material',
		'primitiveType',
		'firstIndex',
		'indexCount'
	],
	#category : #'WodenEngine-Core-Asset'
}

{ #category : #enumerating }
WDCSimpleModelExporterSubmesh >> facesDo: aBlock [
	primitiveType == #lines ifTrue: [ 
		| nextIndex |
		nextIndex := firstIndex.
		1 to: indexCount // 2 do: [ :i |
			aBlock value: { nextIndex . nextIndex + 1 }.
			nextIndex := nextIndex + 2
		].
		^ self
	].
	primitiveType == #triangles ifTrue: [ 
		| nextIndex |
		nextIndex := firstIndex.
		1 to: indexCount // 3 do: [ :i |
			aBlock value: { nextIndex . nextIndex + 1 . nextIndex + 2 }.
			nextIndex := nextIndex + 3
		].
		^ self
	].
]

{ #category : #accessing }
WDCSimpleModelExporterSubmesh >> firstIndex [

	^ firstIndex
]

{ #category : #accessing }
WDCSimpleModelExporterSubmesh >> firstIndex: anObject [

	firstIndex := anObject
]

{ #category : #accessing }
WDCSimpleModelExporterSubmesh >> indexCount [

	^ indexCount
]

{ #category : #accessing }
WDCSimpleModelExporterSubmesh >> indexCount: anObject [

	indexCount := anObject
]

{ #category : #accessing }
WDCSimpleModelExporterSubmesh >> material [

	^ material
]

{ #category : #accessing }
WDCSimpleModelExporterSubmesh >> material: anObject [

	material := anObject
]

{ #category : #accessing }
WDCSimpleModelExporterSubmesh >> primitiveType [

	^ primitiveType
]

{ #category : #accessing }
WDCSimpleModelExporterSubmesh >> primitiveType: anObject [

	primitiveType := anObject
]
