rendering
createSolidModelBuilderFor: anEngine
	solidModelBuilder := WTDynamicGenericMeshBuilder for: anEngine.
	solidModelMaterial := anEngine resourceCache loadMaterial: 'materials/basic/white.json'.