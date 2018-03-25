Class {
	#name : #RWExampleSelection,
	#superclass : #RTExampleSelection,
	#category : 'Woden2-Roassal-Examples'
}

{ #category : #ui }
RWExampleSelection >> gtDisplayPlaygroundIn: composite [
	" not supported "
]

{ #category : #ui }
RWExampleSelection >> gtInspectorRoassalViewIn: composite [
	" not supported "
]

{ #category : #ui }
RWExampleSelection >> gtInspectorViewIn: composite [
	self deprecated: 'Please use #gtInspectorWodenViewIn: instead'.
	^ self gtInspectorWodenViewIn: composite
]

{ #category : #ui }
RWExampleSelection >> gtInspectorWodenViewIn: composite [
	<gtInspectorPresentationOrder: -10>
	composite woden
		title: 'Canvas';
		initializeView: [ self returnValue ]
		
]
