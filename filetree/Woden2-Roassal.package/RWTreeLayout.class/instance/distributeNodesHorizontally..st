private
distributeNodesHorizontally: nodeCollection
	| bounds |
	nodeCollection ifEmpty: [ ^ self ].
	nodeCollection do: [ :node | self distributeNodesHorizontally: (self childrenFor: node)].
	bounds := nodeCollection collect: [ :node | self subtreeBounds:  node ].
	self distributeSubtreeNodes: nodeCollection withBounds: bounds
