thumbnails
ensureAllMaterialThumbnailsInDB: thumbnailDB
	self allMaterialNames do: [ :materialName |
		thumbnailDB thumbnailFor: materialName ifAbsentPut: [ (self loadMaterial: materialName) thumbnail ]
	]