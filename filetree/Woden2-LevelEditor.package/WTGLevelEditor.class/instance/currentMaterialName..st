accessing
currentMaterialName: anObject
	currentMaterialName := anObject.
	currentMaterialName ifNil: [ currentMaterialName := '' ]