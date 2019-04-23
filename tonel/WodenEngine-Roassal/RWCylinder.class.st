Class {
	#name : #RWCylinder,
	#superclass : #RWSimpleShape,
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #configuration }
RWCylinder class >> defaultSegments [
	^ 16
]

{ #category : #configuration }
RWCylinder class >> defaultSlices [
	^ 32
]

{ #category : #visiting }
RWCylinder >> accept: aVisitor [
	^ aVisitor visitCylinderShape: self
]

{ #category : #hooks }
RWCylinder >> baseShapeDescriptor [
	^ {#Cylinder . transparencyMode}
]

{ #category : #hooks }
RWCylinder >> createBaseShapeNodeForView: aView [
	| engine node renderable |
	node := WDSGSpatialObjectInstanceGroup new.
	node updatedPerFrame: false.
	engine := aView engine.
	
	"We create a cube of size 1, the size of the cube is then changed by a matrix transformation.
	The matrix is computed in #shapeMatrixFor:"
	renderable := (WDCGenericMeshBuilder for: engine)
		material: (self wodenMaterialForView: aView);
		addCylinderRadius: 0.5 height: 1.0 segments: self class defaultSegments slices: self class defaultSlices;
		computeBoundingBox;
		mesh.
	self setupTransparency: node renderable: renderable.
	node renderable: renderable.
	^ node
]
