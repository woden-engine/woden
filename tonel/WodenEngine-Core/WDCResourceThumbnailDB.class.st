Class {
	#name : #WDCResourceThumbnailDB,
	#superclass : #Object,
	#instVars : [
		'resources'
	],
	#category : #'WodenEngine-Core-Engine'
}

{ #category : #'as yet unclassified' }
WDCResourceThumbnailDB class >> tryToLoadFromFileNamed: aFileName [
	^ self new tryToLoadFromFileNamed: aFileName
]

{ #category : #initialization }
WDCResourceThumbnailDB >> initialize [
	super initialize.
	resources := Dictionary new.
]

{ #category : #accessing }
WDCResourceThumbnailDB >> resources [
	^ resources
]

{ #category : #fileout }
WDCResourceThumbnailDB >> saveTo: aFileName [
	FLSerializer serialize: resources toFileNamed: aFileName
]

{ #category : #'as yet unclassified' }
WDCResourceThumbnailDB >> thumbnailFor: resourceName ifAbsent: aBlock [
	^ resources at: resourceName ifAbsent: aBlock
]

{ #category : #'as yet unclassified' }
WDCResourceThumbnailDB >> thumbnailFor: resourceName ifAbsentPut: aBlock [
	^ resources at: resourceName ifAbsentPut: aBlock
]

{ #category : #'as yet unclassified' }
WDCResourceThumbnailDB >> tryToLoadFromFileNamed: aFileName [
	[
		resources := FLMaterializer materializeFromFileNamed: aFileName
	] on: Error do: [ :e ]
]
