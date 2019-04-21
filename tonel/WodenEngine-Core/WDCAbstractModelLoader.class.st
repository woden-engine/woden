"
I am a generic model loader. I can be a loader for simple models (renderables), or scene graph based models.
"
Class {
	#name : #WDCAbstractModelLoader,
	#superclass : #Object,
	#category : #'WodenEngine-Core-Asset'
}

{ #category : #accessing }
WDCAbstractModelLoader class >> extension [
	^ nil
]

{ #category : #initialization }
WDCAbstractModelLoader class >> loadFromFile: aFileName [
	^ self loadFromFileReference: aFileName asFileReference
]

{ #category : #initialization }
WDCAbstractModelLoader class >> loadFromFileReference: aFileReference [
	| loader |
	"Avoid infinite loop, and having to override explictly on the subclasses"
	self == WDCAbstractModelLoader ifFalse: [
		^ self new loadFromFileReference: aFileReference
	].

	loader := self loaderForExtension: aFileReference extension.
	loader ifNil: [ self error: 'Unsupported model format' ].
	^ loader loadFromFileReference: aFileReference
]

{ #category : #'as yet unclassified' }
WDCAbstractModelLoader class >> loaderForExtension: anExtension [
	self withAllSubclassesDo: [ :sc |
		sc extension = anExtension ifTrue: [ ^ sc ]
	].

	^ nil
]

{ #category : #loading }
WDCAbstractModelLoader >> loadFromFileNamed: aFileName [
	^ self loadFromFileReference: aFileName asFileReference
]

{ #category : #loading }
WDCAbstractModelLoader >> loadFromFileReference: fileReference [
	self subclassResponsibility
]
