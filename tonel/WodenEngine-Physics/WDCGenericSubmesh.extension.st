Extension { #name : #WDCGenericSubmesh }

{ #category : #'*WodenEngine-Physics' }
WDCGenericSubmesh >> createCollisionTriangleMeshAccessorFor: mesh [
	| result |
	primitiveType ~= AGPU_TRIANGLES ifTrue: [ ^ nil ].
	
	result := WDPhyCollisionMeshAccessor new.
	mesh vertexData storePositionsPointerInCollisionMeshAccessor: result.
	indexBuffer ifNil: [ 
		mesh indexBuffer storeGlobalIndexPointer: firstIndex inCollisionMeshAccessor: result.
	] ifNotNil: [ 
		indexBuffer storeIndexPointer: firstIndex inCollisionMeshAccessor: result.
	].
	result indexCount: indexCount.

	^ result
]
