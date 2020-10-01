Class {
	#name : #WDGSModelingComponent,
	#superclass : #WDGSComponent,
	#instVars : [
		'boundingBox',
		'color'
	],
	#classVars : [
		'ModelSolidColors'
	],
	#category : #'WodenEngine-OldGameSystem-Level'
}

{ #category : #'class initialization' }
WDGSModelingComponent class >> initialize [
	"
	self initialize
	"
	super initialize.
	
	ModelSolidColors := {
		Color green muchDarker.
		Color blue .
		Color cyan .
		Color yellow .
		Color magenta .
	}.
]

{ #category : #adding }
WDGSModelingComponent >> addedToEntity: anEntity [
	entity ifNotNil: [ entity invalidateModels ].
	super addedToEntity: anEntity.
	entity ifNotNil: [
		entity
			ensureSpatialObject;
			ensureRenderingModels;
			ensurePhysicsComponent;
			invalidateModels
	].
]

{ #category : #transformations }
WDGSModelingComponent >> applyTransformation: transformation [
]

{ #category : #accessing }
WDGSModelingComponent >> boundingBox [
	^ boundingBox
]

{ #category : #accessing }
WDGSModelingComponent >> bucket [
	^ #modeling
]

{ #category : #rendering }
WDGSModelingComponent >> buildSolidModelInto: aMeshBuilder [
	aMeshBuilder
		beginTriangles;
		currentColor: self currentColor asFloat32x4;
		addSolidBox: boundingBox
]

{ #category : #rendering }
WDGSModelingComponent >> buildTexturedModelInto: aMeshBuilder [
	aMeshBuilder
		beginTriangles;
		currentColor: (self currentColor asFloat32x4);
		addSolidBox: boundingBox
]

{ #category : #rendering }
WDGSModelingComponent >> buildWireModelInto: aMeshBuilder [
	aMeshBuilder
		beginLines;
		currentColor: self currentColor asFloat32x4;
		addWireBox: boundingBox
]

{ #category : #changing }
WDGSModelingComponent >> changedSelectionState [
	self invalidateModels
]

{ #category : #accessing }
WDGSModelingComponent >> color [
	^ color
]

{ #category : #accessing }
WDGSModelingComponent >> currentColor [
	^ selected ifTrue: [
		lastSelected
			ifTrue: [ LastSelectionColor ]
			ifFalse: [ SelectionColor ]
	] ifFalse: [ color]
]

{ #category : #accessing }
WDGSModelingComponent >> currentTexturedColor [
	^ selected ifTrue: [
		lastSelected
			ifTrue: [ LastSelectionColor ]
			ifFalse: [ SelectionColor ]
	] ifFalse: [ Color white]
]

{ #category : #selection }
WDGSModelingComponent >> elementsAlongRay: ray mode: mode do: aBlock [
	| distance |
	distance := ray intersectionDistanceWithBox: boundingBox.
	distance ifNil: [ ^ self ].
	aBlock value: (ray testResultForDistance: distance value: self).

]

{ #category : #initialization }
WDGSModelingComponent >> generateColor [
	^ ModelSolidColors atRandom
]

{ #category : #initialization }
WDGSModelingComponent >> initialize [
	super initialize.	
	color := self generateColor.
	boundingBox := BoxF64 empty.
]

{ #category : #rendering }
WDGSModelingComponent >> invalidateModels [
	entity ifNotNil: [ entity invalidateModels ]
]

{ #category : #rendering }
WDGSModelingComponent >> invalidateTexturedModel [
	entity ifNotNil: [ entity invalidateTexturedModel ]
]

{ #category : #adding }
WDGSModelingComponent >> removedFromEntity: anEntity [
	entity ifNotNil: [ entity invalidateModels ].
	super removedFromEntity: anEntity.

]

{ #category : #memento }
WDGSModelingComponent >> restoreTransformMemento: aValue [
	boundingBox := aValue copy.
	self invalidateModels.

]

{ #category : #memento }
WDGSModelingComponent >> transformMemento [
	^ boundingBox copy
]
