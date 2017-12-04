rendering
createWireModel
	wireModelBuilder
		clear;
		currentMaterial: wireModelMaterial.
	
	(entity components at: #modeling) do: [ :model |
		model buildWireModelInto: wireModelBuilder 
	].
		
	wireModel := wireModelBuilder mesh.
	invalidWireModel := false.
	^ wireModel