Class {
	#name : #WDERectangleVisualComponent,
	#superclass : #WDEVisualComponent2D,
	#instVars : [
		'rectangle',
		'material'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #visiting }
WDERectangleVisualComponent >> accept: visitor [
	^ visitor visitRectangleVisualComponent: self
]

{ #category : #accessing }
WDERectangleVisualComponent >> boundingRectangle [
	^ rectangle
]

{ #category : #serialization }
WDERectangleVisualComponent >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#rectangle . rectangle encodeForJSON.
		#material . material ifNil: [0] ifNotNil: [material materialIndex].
	}
]

{ #category : #initialization }
WDERectangleVisualComponent >> initialize [
	super initialize.
	rectangle := RectangleF32 unitRectangle.
]

{ #category : #testing }
WDERectangleVisualComponent >> isRectangleVisualComponent [
	^ true
]

{ #category : #serialization }
WDERectangleVisualComponent >> loadFromJson: jsonData context: context [
	super loadFromJson: jsonData context: context.
	rectangle := RectangleF32 loadFromJson: (jsonData at: 'rectangle').
	jsonData at: 'material' ifPresent: [ :index |
		material := context getMaterialWithIndex: index
	].

]

{ #category : #accessing }
WDERectangleVisualComponent >> material [
	^ material
]

{ #category : #accessing }
WDERectangleVisualComponent >> material: aMaterial [
	material := aMaterial.
	self changed
]

{ #category : #memento }
WDERectangleVisualComponent >> materialStateMemento [
	^ material
]

{ #category : #accessing }
WDERectangleVisualComponent >> rectangle [
	^ rectangle
]

{ #category : #accessing }
WDERectangleVisualComponent >> rectangle: anObject [
	rectangle := anObject.
	self changed.
]

{ #category : #memento }
WDERectangleVisualComponent >> restoreMaterialStateMemento: memento [
	self material: memento
]

{ #category : #memento }
WDERectangleVisualComponent >> restoreTransformStateMemento: memento [
	self rectangle: memento
]

{ #category : #initialization }
WDERectangleVisualComponent >> setMaterial: newMaterial [
	self material: newMaterial
]

{ #category : #memento }
WDERectangleVisualComponent >> transformStateMemento [
	^ self rectangle
]

{ #category : #transforms }
WDERectangleVisualComponent >> transformWith: transform [
	self rectangle: (self rectangle asBox transformedWith: transform) asRectangleXY.

]

{ #category : #'as yet unclassified' }
WDERectangleVisualComponent >> validateMaterialList [
	self level validateMaterial: material
]
