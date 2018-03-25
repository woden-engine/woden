Class {
	#name : #RWLine,
	#superclass : #RWAbstractLineShape,
	#category : 'Woden2-Roassal-Core'
}

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
