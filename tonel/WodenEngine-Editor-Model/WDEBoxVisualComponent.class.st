Class {
	#name : #WDEBoxVisualComponent,
	#superclass : #WDEVisualComponent3D,
	#instVars : [
		'box',
		'material'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #visiting }
WDEBoxVisualComponent >> accept: visitor [
	^ visitor visitBoxVisualComponent: self
]

{ #category : #accessing }
WDEBoxVisualComponent >> boundingBox [
	^ box
]

{ #category : #accessing }
WDEBoxVisualComponent >> box [
	^ box
]

{ #category : #accessing }
WDEBoxVisualComponent >> box: anObject [
	box := anObject.
	self changed.
]

{ #category : #serialization }
WDEBoxVisualComponent >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#box . box encodeForJSON.
		#material . material ifNil: [0] ifNotNil: [material materialIndex].
	}
]

{ #category : #initialization }
WDEBoxVisualComponent >> initialize [
	super initialize.
	box := BoxF32 unitBox.
]

{ #category : #testing }
WDEBoxVisualComponent >> isBoxVisualComponent [
	^ true
]

{ #category : #serialization }
WDEBoxVisualComponent >> loadFromJson: jsonData context: context [
	super loadFromJson: jsonData context: context.
	box := BoxF32 loadFromJson: (jsonData at: 'box').
	jsonData at: 'material' ifPresent: [ :index |
		material := context getMaterialWithIndex: index
	].

]

{ #category : #accessing }
WDEBoxVisualComponent >> material [

	^ material
]

{ #category : #accessing }
WDEBoxVisualComponent >> material: anObject [

	material := anObject.
	self changed.
]

{ #category : #memento }
WDEBoxVisualComponent >> materialStateMemento [
	^ material
]

{ #category : #memento }
WDEBoxVisualComponent >> restoreMaterialStateMemento: memento [
	self material: memento
]

{ #category : #memento }
WDEBoxVisualComponent >> restoreTransformStateMemento: memento [
	self box: memento
]

{ #category : #initialization }
WDEBoxVisualComponent >> setMaterial: newMaterial [
	self material: newMaterial
]

{ #category : #memento }
WDEBoxVisualComponent >> transformStateMemento [
	^ self box
]

{ #category : #transforms }
WDEBoxVisualComponent >> transformWith: transform [
	self box: (self box transformedWith: transform)
]

{ #category : #'as yet unclassified' }
WDEBoxVisualComponent >> validateMaterialList [
	self level validateMaterial: material
]
