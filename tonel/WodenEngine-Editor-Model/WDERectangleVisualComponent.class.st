Class {
	#name : #WDERectangleVisualComponent,
	#superclass : #WDEVisualComponent2D,
	#instVars : [
		'rectangle',
		'material',
		'textureOffset',
		'textureScale'
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

{ #category : #accessing }
WDERectangleVisualComponent >> buildLevelElementPropertyPageWith: builder [
	super buildLevelElementPropertyPageWith: builder.
	
	builder
		vector2PropertyNamed: 'Texture Scale' selector: #textureScale;
		vector2PropertyNamed: 'Texture Offset' selector: #textureOffset
]

{ #category : #serialization }
WDERectangleVisualComponent >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#rectangle . rectangle encodeForJSON.
		#material . material ifNil: [0] ifNotNil: [material materialIndex].
		#textureScale . textureScale encodeForJSON.
		#textureOffset . textureOffset encodeForJSON.
	}
]

{ #category : #accessing }
WDERectangleVisualComponent >> entityTransformChanged [
	self raiseChangedEvent
]

{ #category : #initialization }
WDERectangleVisualComponent >> initialize [
	super initialize.
	rectangle := RectangleF32 unitRectangle.
	textureScale := Float32x2 ones.
	textureOffset := Float32x2 zeros.
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
	jsonData at: 'textureScale' ifPresent: [ :scale |
		textureScale := Float32x2 loadFromJson: scale.
	].
	jsonData at: 'textureOffset' ifPresent: [ :offset |
		textureOffset := Float32x2 loadFromJson: offset.
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

{ #category : #accessing }
WDERectangleVisualComponent >> textureOffset [

	^ textureOffset
]

{ #category : #accessing }
WDERectangleVisualComponent >> textureOffset: anObject [
	textureOffset := anObject.
	self changed
]

{ #category : #accessing }
WDERectangleVisualComponent >> textureScale [

	^ textureScale
]

{ #category : #accessing }
WDERectangleVisualComponent >> textureScale: anObject [
	textureScale := anObject.
	self changed
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
