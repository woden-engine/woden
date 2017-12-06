tests
testReplaceSceneNode
	| newNode |
	newNode := WDSceneNode new.
	self assert: element sceneNode ~~ newNode.
	element replaceSceneNode: newNode.
	self assert: element sceneNode == newNode.
