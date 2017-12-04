resource loading
loadMaterial: aMaterialName
	| engine |
	engine := scene engine.
	
	^ engine resourceCache loadMaterial: aMaterialName fallback: [ engine resourceCache defaultMaterial ]