map events
spawn
	super spawn.
	
	self levelPlayer playerEventHandler: (WTGSPlayerBehaviorEventHandler new behavior: self).