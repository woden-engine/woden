private
addHeight: nextHeight toNodes: nextNodes
	| childrenHeight newHeight |
	childrenHeight := self computeBoundingHeightFor: nextNodes.
	newHeight := nextHeight - childrenHeight - 1.0.
	nextNodes do: [ :node | node translateToY: nextHeight . self addHeight: newHeight to: node	]