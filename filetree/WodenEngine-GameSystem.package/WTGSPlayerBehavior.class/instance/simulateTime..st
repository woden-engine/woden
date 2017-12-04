map events
simulateTime: delta
	| camera spatialDesc orientation transform |
	linearVelocity := velocityDirection * speed.
	super simulateTime: delta.
	camera := self levelPlayer camera.
	spatialDesc := entity spatialDescription.
	transform := spatialDesc transform.
	camera ifNotNil: [
		orientation := (WMMatrix3F yrot: angle y) * (WMMatrix3F xrot: angle x).
		
		camera transform
			orthonormal: orientation;
			translation: transform translation asWMVector3F;
			translateByY: self class eyePosition.
		headTransform := camera transform copy
	].

	soundListener ifNotNil: [ 
		soundListener
			position: transform translation asWMVector3F;
			velocity: linearVelocity asWMVector3F;
			orientation: transform matrix asWMMatrix3F.
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
	].

	bullets do: [ :bullet | bullet update: delta ]