rendering
updateNodes
	node visible: editor selectionBox isEmpty not.
	node visible ifFalse: [
		self makeManipulatorsEmpty.
		^ self.
	].

	editor selectionBox isPointSelection ifTrue: [ 
		self makeManipulatorsEmpty.
		self createTranslationManipulators.
	] ifFalse: [ 
		self createTranslationAndScaleManipulators.
	].

	self updateColors.