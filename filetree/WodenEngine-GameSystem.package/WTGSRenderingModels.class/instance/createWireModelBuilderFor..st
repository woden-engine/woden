rendering
createWireModelBuilderFor: anEngine
	wireModelBuilder := WTDynamicGenericMeshBuilder for: anEngine.
	wireModelMaterial := anEngine resourceCache loadMaterial: 'materials/basic/flat.json'.