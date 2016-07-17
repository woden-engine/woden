initialization
createMap
	| world |
	map := WTGSMap new.
	map scene: scene.
		
	world := WTGSEntity new.
	map addEntity: world.
	
	renderMode := #solid.