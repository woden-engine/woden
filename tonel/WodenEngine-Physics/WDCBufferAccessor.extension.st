Extension { #name : #WDCBufferAccessor }

{ #category : #'*WodenEngine-Physics' }
WDCBufferAccessor >> storeGlobalIndexPointer: baseIndex inCollisionMeshAccessor: collisionMeshAccessor [
	collisionMeshAccessor
		indexBufferData: bufferView buffer data;
		indexBufferOffset: (baseIndex * type size);
		indexBufferStride: type size
]

{ #category : #'*WodenEngine-Physics' }
WDCBufferAccessor >> storeIndexPointer: baseIndex inCollisionMeshAccessor: collisionMeshAccessor [
	collisionMeshAccessor
		indexBufferData: bufferView buffer data;
		indexBufferOffset: bufferView offset + byteOffset + (baseIndex * type size);
		indexBufferStride: type size
]

{ #category : #'*WodenEngine-Physics' }
WDCBufferAccessor >> storePositionsPointerInCollisionMeshAccessor: collisionMeshAccessor [
	collisionMeshAccessor
		vertexBufferData: bufferView buffer data;
		vertexBufferOffset: bufferView offset + byteOffset;
		vertexBufferStride: type size;
		vertexCount: count
]
