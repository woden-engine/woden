Class {
	#name : #WDGSSceneNodeModelingComponent,
	#superclass : #WDGSModelingComponent,
	#instVars : [
		'sceneNode'
	],
	#category : #'WodenEngine-GameSystem-Level'
}

{ #category : #adding }
WDGSSceneNodeModelingComponent >> addedToScene: scene [
	| nodeComponent |
	scene ifNil: [ ^ self ].
	nodeComponent := entity sceneNodeComponent.
	sceneNode := self createSceneNode.
	nodeComponent node addChild: sceneNode.

]

{ #category : #transformations }
WDGSSceneNodeModelingComponent >> applyTransformation: transformation [
	boundingBox := boundingBox transformedWith: transformation.
	sceneNode
		transform: (transformation asWMReversibleAffineTransformF transformTransform: sceneNode transform)
]

{ #category : #rendering }
WDGSSceneNodeModelingComponent >> buildTexturedModelInto: aMeshBuilder [
]

{ #category : #changing }
WDGSSceneNodeModelingComponent >> changedSelectionState [
	super changedSelectionState.
	sceneNode ifNotNil: [ sceneNode color: self currentTexturedColor ]
]

{ #category : #adding }
WDGSSceneNodeModelingComponent >> createSceneNode [
	^ WDSGSpatialObject new
]

{ #category : #adding }
WDGSSceneNodeModelingComponent >> removedFromEntity: anEntity [
	sceneNode ifNotNil: [ sceneNode removeFromScene ]
]

{ #category : #memento }
WDGSSceneNodeModelingComponent >> restoreTransformMemento: aValue [
	super restoreTransformMemento: aValue first.
	(sceneNode isNotNil and: [ aValue second isNotNil ]) ifTrue: [
		sceneNode transform: aValue second copy
	]
]

{ #category : #memento }
WDGSSceneNodeModelingComponent >> transformMemento [
	^ {super transformMemento . sceneNode ifNotNil: [sceneNode transform copy]}
]
