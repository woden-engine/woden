initialization
createMap
	| world |
	map := WTGSMap new.
	map scene: scene.
		
	world := WTGSEntity new.
	world worldEntity: true.
	map addEntity: world.
	
	renderMode := #solid.