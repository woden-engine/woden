"
I am an abstract  woden 3D model writer.
"
Class {
	#name : #WDCModelWriter,
	#superclass : #Object,
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WDCModelWriter class >> extension [
	^ nil
]

{ #category : #accessing }
WDCModelWriter class >> save: model intoFileReference: aFileReference [
	^ self new save: model intoFileReference: aFileReference
]

{ #category : #accessing }
WDCModelWriter class >> save: model toFile: aFileName [
	| fileReference writer |
	fileReference := aFileName asFileReference.
	writer := self writerForExtension: fileReference extension.
	writer ifNil: [ self error: 'Unsupported model format' ].
	^ writer save: model intoFileReference: fileReference
]

{ #category : #accessing }
WDCModelWriter class >> writerForExtension: anExtension [
	self allSubclassesDo: [ :sc |
		sc extension = anExtension ifTrue: [ ^ sc ]
	].

	^ nil
]

{ #category : #accessing }
WDCModelWriter >> save: model intoFileNamed: aFileName [
	^ self save: model intoFileReference: aFileName asFileReference
]

{ #category : #accessing }
WDCModelWriter >> save: model intoFileReference: aFileReference [
	self subclassResponsibility
]
