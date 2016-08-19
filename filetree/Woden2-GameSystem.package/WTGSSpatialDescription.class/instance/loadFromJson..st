serialization
loadFromJson: jsonData
	jsonData at: 'transform' ifPresent: [ :jsonTransform |
		transform := WMReversibleAffineTransformD loadFromJson: jsonTransform
	].

	jsonData at: 'bounding-box' ifPresent: [ :jsonLocalBoundingBox |
		localBoundingBox := WMBox3DD loadFromJson: jsonLocalBoundingBox
	].
	self
		changed;
		recomputeBoundingBox.