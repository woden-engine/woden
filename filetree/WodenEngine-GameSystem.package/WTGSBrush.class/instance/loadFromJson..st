serialization
loadFromJson: jsonData
	jsonData at: 'color' ifPresent: [ :jsonColor |
		color := Color loadWodenJsonData: jsonColor
	].

	jsonData at: 'faces' ifPresent: [ :jsonFaces |
		self faces: (jsonFaces collect: [ :jsonFace | WTGSBrushFace loadFromJson: jsonFace ])
	].

	self triangulate.