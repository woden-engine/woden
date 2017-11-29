modifiers
mapMaterials: aDictionary
	submeshes do: [ :submesh | submesh material: (aDictionary at: submesh material) ]