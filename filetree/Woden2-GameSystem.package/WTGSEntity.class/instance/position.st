accessing
position
	^ self spatialDescription ifNotNil: [ :desc | desc transform translation ] ifNil: [ WMVector3D new ]