accessing
objects: someObjects
	self assert: [ view notNil ] description: 'A view has to be set'.
	
	self elements: (self view elementsFromModels: someObjects)