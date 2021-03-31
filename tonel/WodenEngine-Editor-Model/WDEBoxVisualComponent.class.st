Class {
	#name : #WDEBoxVisualComponent,
	#superclass : #WDEVisualComponent3D,
	#instVars : [
		'box',
		'material',
		'textureOffset',
		'textureScale'
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

{ #category : #accessing }
WDEBoxVisualComponent >> buildLevelElementPropertyPageWith: builder [
	super buildLevelElementPropertyPageWith: builder.
	
	builder
		vector2PropertyNamed: 'Texture Scale' selector: #textureScale;
		vector2PropertyNamed: 'Texture Offset' selector: #textureOffset
]

{ #category : #serialization }
WDEBoxVisualComponent >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#box . box encodeForJSON.
		#material . material ifNil: [0] ifNotNil: [material materialIndex].
		#textureScale . textureScale encodeForJSON.
		#textureOffset . textureOffset encodeForJSON.
	}
]

{ #category : #accessing }
WDEBoxVisualComponent >> entityTransformChanged [
	(material isNotNil and: [material hasTexture]) ifTrue: [
		self raiseChangedEvent
	].

]

{ #category : #initialization }
WDEBoxVisualComponent >> initialize [
	super initialize.
	box := BoxF32 unitBox.
	textureScale := Float32x2 ones.
	textureOffset := Float32x2 zeros.
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
	jsonData at: 'textureScale' ifPresent: [ :scale |
		textureScale := Float32x2 loadFromJson: scale.
	].
	jsonData at: 'textureOffset' ifPresent: [ :offset |
		textureOffset := Float32x2 loadFromJson: offset.
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

{ #category : #accessing }
WDEBoxVisualComponent >> textureOffset [

	^ textureOffset
]

{ #category : #accessing }
WDEBoxVisualComponent >> textureOffset: anObject [
	textureOffset := anObject.
	self changed
]

{ #category : #accessing }
WDEBoxVisualComponent >> textureScale [

	^ textureScale
]

{ #category : #accessing }
WDEBoxVisualComponent >> textureScale: anObject [
	textureScale := anObject.
	self changed
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
