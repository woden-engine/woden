initialization
createMap
	| world brush |
	map := WTGSMap new.
	map scene: scene.
		
	world := WTGSEntity new.
	map addEntity: world.
	
	brush := WTGSBrush unitCube.
	world addComponent: brush.

	renderMode := #solid.