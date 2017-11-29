iterating elements
componentsCollect: aBlock
	| result |
	result := Array new: numberOfComponents.
	self componentsDoWithIndex: [ :comp :index |
		result at: index put: (aBlock value: comp)
	].
	^ result