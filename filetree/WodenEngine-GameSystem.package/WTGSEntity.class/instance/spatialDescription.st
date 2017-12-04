accessing
spatialDescription
	^ (components at: #spatialDescription ifAbsent: [ ^ nil ]) first