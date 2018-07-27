Class {
	#name : #RWUVSphere,
	#superclass : #RWSimpleShape,
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #configuration }
RWUVSphere class >> defaultSegments [
	^ 16
]

{ #category : #configuration }
RWUVSphere class >> defaultSlices [
	^ 16
]

{ #category : #'as yet unclassified' }
RWUVSphere >> baseShapeDescriptor [
	^ {#UVSphere . transparencyMode}
]

{ #category : #'as yet unclassified' }
RWUVSphere >> createBaseShapeNodeForView: aView [
	| engine node renderable |
	node := WDSGSpatialObjectInstanceGroup new.
	node updatedPerFrame: false.
	engine := aView engine.
	
	"We create a cube of size 1, the size of the cube is then changed by a matrix transformation.
	The matrix is computed in #shapeMatrixFor:"
	renderable := (WTGenericMeshBuilder for: engine)
		material: (self wodenMaterialForView: aView);
		addUVSphereRadius: 0.5 segments: self class defaultSegments slices: self class defaultSlices;
		computeBoundingBox;
		mesh.
	self setupTransparency: node renderable: renderable.
	node renderable: renderable.
	^ node
]
