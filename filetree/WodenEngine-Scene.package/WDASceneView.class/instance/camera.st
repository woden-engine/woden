rendering process stages
camera
	^ camera ifNil: [camera := model camera]