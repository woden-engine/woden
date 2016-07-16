rendering
createSolidModel
	solidModelBuilder
		clear;
		currentMaterial: solidModelMaterial.
	
	(entity components at: #modeling) do: [ :model |
		model buildSolidModelInto: solidModelBuilder 
	].
		
	solidModel := solidModelBuilder mesh.
	invalidSolidModel := false.
	^ solidModel