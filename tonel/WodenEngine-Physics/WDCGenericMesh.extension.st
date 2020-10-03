Extension { #name : #WDCGenericMesh }

{ #category : #'*WodenEngine-Physics' }
WDCGenericMesh >> createCollisionTriangleMeshAccessors [
	^ submeshes collect: [ :sm | sm createCollisionTriangleMeshAccessorFor: self ] thenSelect: #isNotNil
]

{ #category : #'*WodenEngine-Physics' }
WDCGenericMesh >> extractConvexCollisionShapesWithTransform: collisionShapeTransform into: convexComponents [
	| vertexSet extractedVertices globalIndices globalFirstIndex positions |
	vertexSet := Set new.
	extractedVertices := StdnVector newFor: Float32x3.
	globalIndices := indexBuffer ifNotNil: [ indexBuffer asNativeArrayReference ].
	globalFirstIndex := indexBuffer ifNil: [ 0 ] ifNotNil: [ indexBuffer asFirstIndexIndex ].
	positions := vertexData positions.
	submeshes do: [ :sm |
		| firstIndex indices index position |
		indices := sm indexBuffer ifNotNil: [ :ib | ib asNativeArrayReference ] ifNil: [ globalIndices ].
		firstIndex := sm firstIndex.
		1 to: sm indexCount do: [ :i |
			index := indices at: firstIndex + i - globalFirstIndex.
			position := positions at: index + 1.
			(vertexSet includes: position) ifFalse: [
				vertexSet add: position.
				extractedVertices add: position asFloat32x3
			]
		].
	].

	extractedVertices ifEmpty: [ ^ self ].
	
	convexComponents add: (WDPhyCompoundCollisionShapeComponent new
		transform: collisionShapeTransform;
		shape: (WDPhyConvexHullCollisionShape new points: extractedVertices);
		yourself)

]
