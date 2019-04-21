"
I am a generic model writer. I can be a loader for simple models (renderables), or a scene graph based models.
"
Class {
	#name : #WDCAbstractModelWriter,
	#superclass : #Object,
	#category : #'WodenEngine-Core-Asset'
}

{ #category : #accessing }
WDCAbstractModelWriter class >> extension [
	^ nil
]

{ #category : #accessing }
WDCAbstractModelWriter class >> save: model intoFileReference: aFileReference [
	^ self new save: model intoFileReference: aFileReference
]

{ #category : #accessing }
WDCAbstractModelWriter class >> save: model toFile: aFileName [
	| fileReference writer |
	fileReference := aFileName asFileReference.
	writer := self writerForExtension: fileReference extension.
	writer ifNil: [ self error: 'Unsupported model format' ].
	^ writer save: model intoFileReference: fileReference
]

{ #category : #accessing }
WDCAbstractModelWriter class >> writerForExtension: anExtension [
	self allSubclassesDo: [ :sc |
		sc extension = anExtension ifTrue: [ ^ sc ]
	].

	^ nil
]

{ #category : #accessing }
WDCAbstractModelWriter >> save: model intoFileNamed: aFileName [
	^ self save: model intoFileReference: aFileName asFileReference
]

{ #category : #accessing }
WDCAbstractModelWriter >> save: model intoFileReference: aFileReference [
	self subclassResponsibility
]
