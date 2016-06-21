as yet unclassified
subMeshFor: anEngine
	^ WTGenericSubmesh new
		firstIndex: firstIndex;
		indexCount: indexCount;
		primitiveType: primitiveType;
		material: (self actualMaterialFor: anEngine);
		yourself.