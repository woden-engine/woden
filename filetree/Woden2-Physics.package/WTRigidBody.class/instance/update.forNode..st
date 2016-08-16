accessing
update: delta forNode: sceneNode
	self hasValidHandle ifTrue: [ handle updateMotionStateTo: sceneNode ]