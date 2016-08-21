serialization
loadFromJson: jsonData
	jsonData at: 'intensity' ifPresent: [ :jsonIntensity |
		intensity := WMVector4F loadFromJson: jsonIntensity
	].

	type := (jsonData at: 'light-type' ifAbsent: [ #point ]) asSymbol.
	outerSpotCutoff := (jsonData at: 'outer-spot-cutoff' ifAbsent: [ 90.0 ]).
	innerSpotCutoff := (jsonData at: 'inner-spot-cutoff' ifAbsent: [ 80.0 ]).