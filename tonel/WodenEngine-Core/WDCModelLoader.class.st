"
I am an abstract  woden 3D model loader.
"
Class {
	#name : #WDCModelLoader,
	#superclass : #Object,
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WDCModelLoader class >> extension [
	^ nil
]

{ #category : #initialization }
WDCModelLoader class >> loadFromFile: aFileName [
	| fileReference loader |
	fileReference := aFileName asFileReference.
	loader := self loaderForExtension: fileReference extension.
	loader ifNil: [ self error: 'Unsupported model format' ].
	^ loader loadFromFileReference: fileReference
]

{ #category : #'as yet unclassified' }
WDCModelLoader class >> loadFromFileReference: aFileReference [
	^ self new loadFromFileReference: aFileReference
]

{ #category : #'as yet unclassified' }
WDCModelLoader class >> loaderForExtension: anExtension [
	self withAllSubclassesDo: [ :sc |
		sc extension = anExtension ifTrue: [ ^ sc ]
	].

	^ nil
]

{ #category : #loading }
WDCModelLoader >> loadFromFileNamed: aFileName [
	^ self loadFromFileReference: aFileName asFileReference
]

{ #category : #loading }
WDCModelLoader >> loadFromFileReference: fileReference [
	self subclassResponsibility
]
