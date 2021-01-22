Class {
	#name : #RWAbstractLineShape,
	#superclass : #RWShape,
	#instVars : [
		'from',
		'to'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #configuration }
RWAbstractLineShape class >> defaultSize [
	^ 2
]

{ #category : #public }
RWAbstractLineShape class >> edgeFrom: e1 to: e2 [
	^ self new edgeFrom: e1 to: e2
]

{ #category : #hooks }
RWAbstractLineShape >> baseShapeDescriptor [
	^ #lines
]

{ #category : #computing }
RWAbstractLineShape >> boundingBoxFor: element [
	^ BoxF32 empty
		insertPoint: element fromPosition;
		insertPoint: element toPosition;
		yourself
]

{ #category : #hooks }
RWAbstractLineShape >> buildRenderableFor: anElement view: aView [
	| baseShape componentNode meshComponent |
	baseShape := anElement parentGroup baseShapeNodeFor: self baseShapeDescriptor ifAbsentPut: [ self createBaseShapeNodeForView: aView ].

	componentNode := WDSGLocalSpatialComponentObject new.
	componentNode 
		color: (self colorFor: anElement).
	baseShape addChild: componentNode.
	anElement replaceSceneNode: componentNode.
	
	meshComponent := self createComponentRenderableFor: anElement.
	componentNode meshComponent: meshComponent.
	^ nil
]

{ #category : #'changing shape' }
RWAbstractLineShape >> changedElement: element sceneNode: sceneNode renderable: renderable [
	self updateMeshComponent: sceneNode meshComponent forElement: element.
	sceneNode parent ifNotNil: #invalidateRenderable
]

{ #category : #hooks }
RWAbstractLineShape >> createBaseShapeNodeForView: aView [
	| node engine renderable |
	node := WDSGSpatialObjectCompositeMeshGroup new.
	engine := aView engine.
	renderable := WDCDynamicCompositeMeshRenderable for: engine.
	
	self setupTransparency: node renderable: renderable.
	node renderable: renderable.		
	^ node

]

{ #category : #hooks }
RWAbstractLineShape >> createComponentRenderableFor: anElement [
	self subclassResponsibility
]

{ #category : #initialization }
RWAbstractLineShape >> defaultColor [
	^ Color gray
]

{ #category : #public }
RWAbstractLineShape >> edgeFrom: e1 to: e2 [
	^ RWEdge new from: e1; to: e2; shape: self
]

{ #category : #public }
RWAbstractLineShape >> element [
	^ RWEdge new shape: self; yourself.
	
]

{ #category : #accesing }
RWAbstractLineShape >> elementFrom: aRWElement to: aRWElement2 [
	^ RWEdge new from: aRWElement; to: aRWElement2; shape: self; yourself.
]

{ #category : #initialization }
RWAbstractLineShape >> initialize [
	super initialize.
	color := self defaultColor
]

{ #category : #'changing shape' }
RWAbstractLineShape >> updateMeshComponent: meshComponent forElement: element [
	self subclassResponsibility
]
