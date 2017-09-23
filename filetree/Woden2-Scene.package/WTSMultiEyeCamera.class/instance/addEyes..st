as yet unclassified
addEyes: aCollectionOfEyes
	eyes := aCollectionOfEyes.
	eyes do: [ :e | self addChild: e ]