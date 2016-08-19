serialization
loadFromJson: jsonData
	jsonData at: 'intensity' ifPresent: [ :jsonIntensity |
		intensity := WMVector4F loadFromJson: jsonIntensity
	].
