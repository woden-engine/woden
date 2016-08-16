private
buildConnectivity
	edges do: [ :edge |
		self addChild: edge to to: edge from.
		self addParent: edge from for: edge to.
	]
	