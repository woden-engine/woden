Class {
	#name : #RWMeshShape,
	#superclass : #RWAbstractSolidShape,
	#instVars : [
		'mesh'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #morphic }
RWMeshShape class >> for: aViewOrEngine buildWith: aBlock [
	^ self new for: aViewOrEngine buildWith: aBlock
]

{ #category : #morphic }
RWMeshShape class >> lineGridWithWidth: width height: height subdivisions: subdivisions for: aViewOrEngine [
	^ self for: aViewOrEngine buildWith: [ :builder |
		builder
			currentMaterial: aViewOrEngine engine resourceCache flatColorMaterial;
			addLineGridWithWidth: 2.0 height: 2.0 subdivisions: 32
	]
]

{ #category : #accessing }
RWMeshShape class >> mesh: aMesh [
	^ self new mesh: aMesh; yourself
]

{ #category : #morphic }
RWMeshShape class >> xyLineGridWithWidth: width height: height subdivisions: subdivisions for: aViewOrEngine [
	^ self for: aViewOrEngine buildWith: [ :builder |
		builder
			currentMaterial: aViewOrEngine engine resourceCache flatColorMaterial;
			addLineGridWithWidth: width height: height subdivisions: subdivisions
	]
]

{ #category : #morphic }
RWMeshShape class >> xzLineGridWithWidth: width height: height subdivisions: subdivisions for: aViewOrEngine [
	^ self for: aViewOrEngine buildWith: [ :builder |
		builder
			currentMaterial: aViewOrEngine engine resourceCache flatColorMaterial;
			rotateDegreesOnX: 90;
			addLineGridWithWidth: width height: height subdivisions: subdivisions
	]
]

{ #category : #morphic }
RWMeshShape class >> yzLineGridWithWidth: width height: height subdivisions: subdivisions for: aViewOrEngine [
	^ self for: aViewOrEngine buildWith: [ :builder |
		builder
			currentMaterial: aViewOrEngine engine resourceCache flatColorMaterial;
			rotateDegreesOnY: 90;
			addLineGridWithWidth: 2.0 height: 2.0 subdivisions: subdivisions
	]
]

{ #category : #visiting }
RWMeshShape >> accept: aVisitor [
	^ aVisitor visitMeshShape: self
]

{ #category : #hooks }
RWMeshShape >> buildRenderableFor: anElement view: aView [
	^ mesh
]

{ #category : #computing }
RWMeshShape >> depthFor: anElement [
	^ (super depthFor: anElement) * mesh boundingBox depth
]

{ #category : #morphic }
RWMeshShape >> for: aViewOrEngine buildWith: aBlock [
	| builder |
	builder := (WDCComplexGenericMeshBuilder for: aViewOrEngine engine).
	aBlock value: builder.
	builder computeBoundingBox.
	self mesh: builder mesh
]

{ #category : #computing }
RWMeshShape >> heightFor: anElement [
	^ (super heightFor: anElement) * mesh boundingBox height
]

{ #category : #computing }
RWMeshShape >> localCenterFor: anElement [
	^ (self rawExtentFor: anElement) * mesh boundingBox center
]

{ #category : #accessing }
RWMeshShape >> mesh [
	^ mesh
]

{ #category : #accessing }
RWMeshShape >> mesh: anObject [
	mesh := anObject
]

{ #category : #computing }
RWMeshShape >> rawExtentFor: element [
	^ Float32x3
		x: (super widthFor: element)
		y: (super heightFor: element)
		z: (super depthFor: element)
]

{ #category : #computing }
RWMeshShape >> widthFor: anElement [
	^ (super widthFor: anElement) * mesh boundingBox width
]
