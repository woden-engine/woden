Class {
	#name : #RWLine,
	#superclass : #RWAbstractLineShape,
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #visiting }
RWLine >> accept: aVisitor [
	^ aVisitor visitLineShape: self
]

{ #category : #hooks }
RWLine >> createComponent: baseShape for: edge [
"	| v1 v2 renderable |
	v1 := WDLineVertex new.
	v2 := WDLineVertex new.
	renderable := baseShape renderable.
	color := self colorFor: edge.

	v1 position: edge from position;
		color: color;
		texcoord: (WDVector2 x: 0.0 y: 0.0).
	v2 position: edge to position;
		color: color;
		texcoord: (WDVector2 x: 1.0 y: 0.0).
	^ renderable componentVertices: { v1 . v2 } indices: {  0 . 1 } primitiveType: WDMeshPrimitiveType lines material: renderable subMeshes last material."
]

{ #category : #hooks }
RWLine >> createComponentRenderableFor: edge [
	| component |
	component := WDCLineMeshComponent new.
	self updateMeshComponent: component forElement: edge.
	^ component
]

{ #category : #hooks }
RWLine >> updateMeshComponent: meshComponent forElement: edge [
	meshComponent
		startPoint: edge from position;
		endPoint: edge to position.
]
