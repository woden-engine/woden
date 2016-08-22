map events
simulateTime: delta
	| camera spatialDesc orientation |
	linearVelocity := velocityDirection * speed.
	super simulateTime: delta.
	camera := self levelPlayer camera.
	camera ifNotNil: [
		spatialDesc := entity spatialDescription.
		orientation := (WMMatrix3F yrot: angle y) * (WMMatrix3F xrot: angle x).
		
		camera transform
			orthonormal: orientation;
			translation: spatialDesc transform translation asWMVector3F;
			translateByY: self class eyePosition
	].

	weaponAction ifNotNil: [
		weaponActionFrame := weaponActionFrame + (delta *30.0 * weaponAnimationSpeed).
		weaponSceneNode renderableSceneData
			setRestPose;
			addAction: weaponAction repeated: weaponActionRepeated frame: weaponActionFrame;
			computePoseMatrices.
			
		(weaponActionRepeated not and: [ weaponActionFrame > weaponAction numberOfFrames ]) ifTrue: [
			self runRepeatedWeaponAnimation: 'Idle' 
		]
	]