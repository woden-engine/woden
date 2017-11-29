initialization
addAmount: amount with: getter to: setter
	editor selection textureTransformsDo: [ :transform |
		transform perform: setter with: (getter value: transform) + amount. 
	].

	self selectionChanged.