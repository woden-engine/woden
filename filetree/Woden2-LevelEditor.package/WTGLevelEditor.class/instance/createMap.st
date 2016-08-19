initialization
createMap
	| world |
	map := WTGSMap new.
	map editorMode: true.
	map scene: scene.
		
	world := WTGSEntity new.
	world worldEntity: true.
	map addEntity: world.
	
	renderMode := #solid.