map events
spawn
	super spawn.

	soundListener := self engine createSoundListener.
	soundListener activate.
	
	weaponSoundSource := self engine createSoundSource.
	bullets := OrderedCollection new.
	bulletsNode := WTSSpatialObjectInstanceGroup new.
	bulletsNode updatedPerFrame: false.
	bulletsNode renderable: ((WTComplexGenericMeshBuilder for: self engine)
		rotateRadiansOnX: Float halfPi;
		addCylinderRadius: 0.0254*0.357*0.5 height: 0.03 segments: 2 slices: 6;
		mesh).
	self scene add: bulletsNode.
		
	self setBoundingBox: (Box3D halfExtent: self class halfExtent).
	self levelPlayer playerEventHandler: (WTGSPlayerBehaviorEventHandler new behavior: self).
	self subscribeToTouchEvents.
