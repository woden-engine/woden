protected
translate: translation subtree: subtreeRoot
	| childrenNodes |
	childrenNodes := self childrenFor: subtreeRoot.
	childrenNodes do: [ :cn |
		cn translateBy: translation.
		self translate: translation subtree: cn
	]