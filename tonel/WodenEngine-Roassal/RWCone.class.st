Class {
	#name : #RWCone,
	#superclass : #RWSimpleShape,
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #configuration }
RWCone class >> defaultSegments [
	^ 16
]

{ #category : #configuration }
RWCone class >> defaultSlices [
	^ 32
]

{ #category : #hooks }
RWCone >> baseShapeDescriptor [
	^ {#UVConeShape . transparencyMode}
]

{ #category : #hooks }
RWCone >> createBaseShapeNodeForView: aView [
	| node renderable engine |
	node := WDSGSpatialObjectInstanceGroup new.
	node updatedPerFrame: false.
	engine := aView engine.
	
	renderable := (WDCGenericMeshBuilder for: engine)
		material: (self wodenMaterialForView: aView);
		addConeRadius: 1.0 height: 2.0 segments: self class defaultSegments slices: self class defaultSlices;
		computeBoundingBox;
		mesh.

	self setupTransparency: node renderable: renderable.
	node renderable: renderable.		
	^ node
]
