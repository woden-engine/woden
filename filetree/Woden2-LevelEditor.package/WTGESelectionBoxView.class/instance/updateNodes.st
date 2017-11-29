rendering
updateNodes
	node visible: editor selectionBox isEmpty not.
	node visible ifFalse: [
		self makeManipulatorsEmpty.
		^ self.
	].

	self makeManipulatorsEmpty.
	editor selectionBox isPointSelection ifTrue: [ 
		editor selectionBox rotationMode ifTrue: [
			self createTranslationAndRotationManipulators.
		] ifFalse: [
			self createTranslationManipulators.
		]
	] ifFalse: [ 
		editor selectionBox rotationMode ifTrue: [
			self createTranslationAndRotationManipulators.
		] ifFalse: [
			self createTranslationAndScaleManipulators.
		]
	].

	self updateColors.