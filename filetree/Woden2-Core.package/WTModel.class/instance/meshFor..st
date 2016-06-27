as yet unclassified
meshFor: anEngine
	| mesh |
	armature ifNotNil: [
		mesh := WTSkinnedGenericMesh new.
		mesh
			armature: armature;
			actions: actions.
	] ifNil: [ 
		mesh := WTGenericMesh new.
	].
	mesh
		boundingBox: boundingBox copy;
		vertexBinding: (self createVertexBindingFor: anEngine);
		indexBuffer: (self createIndexBufferFor: anEngine);
		submeshes: (submeshes collect: [:sm | sm subMeshFor: anEngine]).
	^ mesh