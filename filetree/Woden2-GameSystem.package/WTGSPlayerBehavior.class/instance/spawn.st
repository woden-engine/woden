map events
spawn
	super spawn.

	soundListener := self engine createSoundListener.
	soundListener activate.
	
	weaponSoundSource := self engine createSoundSource.
		
	self setBoundingBox: (Box3D halfExtent: self class halfExtent).
	self levelPlayer playerEventHandler: (WTGSPlayerBehaviorEventHandler new behavior: self).
	self subscribeToTouchEvents.
