accessing
sceneNodesDo: aBlock
	pointEntityNode ifNotNil: [ aBlock value: pointEntityNode. ].
	components at: #sceneNode ifPresent: [ :nodes | nodes do: [:node | aBlock value: node node ] ]