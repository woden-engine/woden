adding
addedIn: aView
	renderable := shape buildRenderableFor: self view: aView.
	self buildRigidBody.
	sceneNode isInstance ifFalse: [
		aView scene add: sceneNode.
	].

	view := aView