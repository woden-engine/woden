Class {
	#name : #WDIFBXNode,
	#superclass : #Object,
	#instVars : [
		'type',
		'attributes',
		'children'
	],
	#category : #'WodenEngine-Importers-FBX'
}

{ #category : #accessing }
WDIFBXNode >> attributes [
	^ attributes
]

{ #category : #accessing }
WDIFBXNode >> attributes: anObject [
	attributes := anObject
]

{ #category : #accessing }
WDIFBXNode >> childNamed: childName [
	children do: [ :child |
		child type = childName ifTrue: [ ^ child ]
	].
	^ nil
]

{ #category : #accessing }
WDIFBXNode >> children [
	^ children
]

{ #category : #accessing }
WDIFBXNode >> children: anObject [
	children := anObject
]

{ #category : #'gt inspector extensions' }
WDIFBXNode >> gtInspectorAttributesNestingIn: composite [
	<gtInspectorPresentationOrder: 1>
	^ attributes gtInspectorItemsIn: composite
]

{ #category : #'gt inspector extensions' }
WDIFBXNode >> gtInspectorModelNestingIn: composite [
	<gtInspectorPresentationOrder: 0>
	composite tree 
		title: 'Nodes';
		display: [ :root | root ];
		children: [ :each | each children ];
		format: [ :node | node type ]
]

{ #category : #initialization }
WDIFBXNode >> initialize [
	super initialize.
	attributes := #().
	
]

{ #category : #printing }
WDIFBXNode >> printOn: aStream [
	aStream nextPutAll: type
	
]

{ #category : #accessing }
WDIFBXNode >> type [
	^ type
]

{ #category : #accessing }
WDIFBXNode >> type: anObject [
	type := anObject
]
