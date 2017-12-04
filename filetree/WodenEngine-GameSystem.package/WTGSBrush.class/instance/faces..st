accessing
faces: anArrayOfFaces
	faces := anArrayOfFaces.
	faces do: [ :face | face addedToBrush: self ].