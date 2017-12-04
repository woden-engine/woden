as yet unclassified
positionsDo: aBlock
	indices do: [ :index | aBlock value: (brush positions at: index + 1) ]