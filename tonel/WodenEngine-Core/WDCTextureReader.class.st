Class {
	#name : #WDCTextureReader,
	#superclass : #Object,
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #accessing }
WDCTextureReader class >> canLoadExtension: anExtension [
	^ anExtension = self extension
]

{ #category : #accessing }
WDCTextureReader class >> canLoadMimeType: anExtension [
	^ false
]

{ #category : #accessing }
WDCTextureReader class >> extension [
	^ nil
]

{ #category : #initialization }
WDCTextureReader class >> loadFromFile: aFileName [
	^ self loadFromFile: aFileName withQuery: nil
]

{ #category : #initialization }
WDCTextureReader class >> loadFromFile: aFileName withQuery: textureFileAndQuery [
	| fileReference loader |
	fileReference := aFileName asFileReference.
	loader := self loaderForExtension: fileReference extension.
	loader ifNil: [ self error: 'Unsupported model format' ].
	^ loader loadFromFileReference: fileReference withQuery: textureFileAndQuery
]

{ #category : #initialization }
WDCTextureReader class >> loadFromFileReference: aFileReference withQuery: textureFileAndQuery [
	self subclassResponsibility
]

{ #category : #reading }
WDCTextureReader class >> loadFromStream: aStream [
	self subclassResponsibility
]

{ #category : #accessing }
WDCTextureReader class >> loaderForExtension: anExtension [
	self withAllSubclassesDo: [ :sc |
		(sc canLoadExtension: anExtension) ifTrue: [ ^ sc ]
	].

	^ nil
]

{ #category : #accessing }
WDCTextureReader class >> loaderForMimeType: aMimeType [
	self withAllSubclassesDo: [ :sc |
		(sc canLoadMimeType: aMimeType) ifTrue: [ ^ sc ]
	].

	^ nil
]
