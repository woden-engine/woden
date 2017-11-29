serialization
loadFromJson: jsonData
	scale := WMVector2D loadFromJson: (jsonData at: 'scale').
	offset := WMVector2D loadFromJson: (jsonData at: 'offset').
	rotation := jsonData at: 'rotation'.
	lock := jsonData at: 'lock'.