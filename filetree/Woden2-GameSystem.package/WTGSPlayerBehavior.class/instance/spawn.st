map events
spawn
	super spawn.
	
	self setBoundingBox: (Box3D halfExtent: self class halfExtent).
	self levelPlayer playerEventHandler: (WTGSPlayerBehaviorEventHandler new behavior: self).
	self subscribeToTouchEvents.
