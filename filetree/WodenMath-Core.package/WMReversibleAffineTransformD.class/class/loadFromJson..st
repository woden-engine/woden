serialization
loadFromJson: json
	^ self new
		matrix: (WMMatrix3D newFrom: (json at: 'matrix'))
		inverseMatrix3: (WMMatrix3D newFrom: (json at: 'inverse-matrix'));
		translation: (WMVector3D loadFromJson: (json at: 'translation'))
		inverseTranslation: (WMVector3D loadFromJson: (json at: 'inverse-translation'))