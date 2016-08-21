double dispatch
activateOnPlayer: aPlayer
	super activateOnPlayer: aPlayer.
	aPlayer addAndActivateWeapon: WTGSMagnumWeapon new.