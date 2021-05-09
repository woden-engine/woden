Class {
	#name : #WDEFileReferenceModel,
	#superclass : #WDEVisualComponent3D,
	#instVars : [
		'path',
		'node',
		'boundingBox'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #visiting }
WDEFileReferenceModel >> accept: visitor [
	^ visitor visitFileReferenceModel: self
]

{ #category : #accessing }
WDEFileReferenceModel >> boundingBox [
	^ boundingBox
]

{ #category : #accessing }
WDEFileReferenceModel >> buildLevelElementPropertyPageWith: builder [
	super buildLevelElementPropertyPageWith: builder.
	
	builder
		stringPropertyNamed: 'Path' selector: #path;
		stringPropertyNamed: 'Node' selector: #node
]

{ #category : #rendering }
WDEFileReferenceModel >> createEntitySystemComponentWithTransform: componentTransform for: gameEntity [
	^ WDESModelLibraryNodeInstanceComponent new 
		modelLibraryName: path;
		modelNodeName: node;
		yourself
]

{ #category : #rendering }
WDEFileReferenceModel >> createSceneNodeFor: engine fromModelAsset: modelAsset [
	^ modelAsset instanceSceneNodeNamed: node for: engine
]

{ #category : #accessing }
WDEFileReferenceModel >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#path . path.
		#node . node.
	}
]

{ #category : #rendering }
WDEFileReferenceModel >> getOrCreateModelNodeFor: engine levelEditorSession: levelEditorSession [
	| modelAsset node |
	modelAsset := levelEditorSession gameSettings getOrCreateModelAssetForPath: path engine: engine.
	node := self createSceneNodeFor: engine fromModelAsset: modelAsset.
	boundingBox := node
		ifNil: [ BoxF32 unitBox ]
		ifNotNil: [ node globalBoundingBox ].
	(parent isNotNil and: [ parent visualComponent == self ]) ifTrue: [ 
		parent localBoundingBox: boundingBox
	].
	^ node
]

{ #category : #initialization }
WDEFileReferenceModel >> initialize [
	super initialize.
	boundingBox := BoxF32 unitBox.
	path := ''.
	node := ''.
]

{ #category : #serialization }
WDEFileReferenceModel >> loadFromJson: jsonData context: context [
	super loadFromJson: jsonData context: context.
	path := jsonData at: 'path' ifAbsent: [ '' ].
	node := jsonData at: 'node' ifAbsent: [ '' ].
]

{ #category : #accessing }
WDEFileReferenceModel >> node [

	^ node
]

{ #category : #accessing }
WDEFileReferenceModel >> node: anObject [

	node := anObject
]

{ #category : #accessing }
WDEFileReferenceModel >> path [

	^ path
]

{ #category : #accessing }
WDEFileReferenceModel >> path: newPath [
	path := newPath.
	self changed
]
