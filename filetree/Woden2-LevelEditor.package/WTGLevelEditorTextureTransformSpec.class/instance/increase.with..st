initialization
increase: getter with: setter
	editor selection textureTransformsDo: [ :transform |
		transform perform: setter with: (getter value: transform) * 2.0
	].

	self selectionChanged.