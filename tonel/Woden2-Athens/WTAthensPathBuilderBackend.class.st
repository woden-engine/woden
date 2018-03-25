Class {
	#name : #WTAthensPathBuilderBackend,
	#superclass : #Object,
	#category : 'Woden2-Athens'
}

{ #category : #adding }
WTAthensPathBuilderBackend >> addVertex: aPoint [
	self subclassResponsibility.
]

{ #category : #commands }
WTAthensPathBuilderBackend >> subpathClosed [
	self subclassResponsibility
]

{ #category : #commands }
WTAthensPathBuilderBackend >> subpathStarted [
	self subclassResponsibility
]
