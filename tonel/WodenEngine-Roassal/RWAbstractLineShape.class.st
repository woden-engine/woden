Class {
	#name : #RWAbstractLineShape,
	#superclass : #RWShape,
	#instVars : [
		'from',
		'to'
	],
	#category : 'WodenEngine-Roassal-Core'
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

{ #category : #hooks }
RWAbstractLineShape >> buildRenderableFor: anElement view: aView [
	| baseShape component |
	baseShape := aView baseShapeNodeFor: self baseShapeDescriptor ifAbsentPut: [ self createBaseShapeNode ].
	component := self createComponent: baseShape for: anElement.
	^ component
]

{ #category : #hooks }
RWAbstractLineShape >> createBaseShapeNode [
	| baseNode renderable vertexBuffer indexBuffer subMesh |
	baseNode := WDSceneNode new.
	renderable := WDCompositeMeshRenderable new.
	vertexBuffer := WDVertexBuffer for: WDLineVertex withCapacity: 1024.
	indexBuffer := WDIndexBuffer forUInt32: 1024.
	renderable addVertexBuffer: vertexBuffer;
		indexBuffer: indexBuffer.
	subMesh := WDSubMesh new
		startIndex: 0;
		indexCount: 0;
		primitiveType: WDMeshPrimitiveType lines;
		material: WDPlainColorMaterial new.
	renderable addSubMesh: subMesh.
	
	baseNode attach: renderable.
	^ baseNode
]

{ #category : #hooks }
RWAbstractLineShape >> createComponent: baseShape for: anElement [
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
