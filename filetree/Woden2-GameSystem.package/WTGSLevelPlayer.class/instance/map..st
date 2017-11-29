accessing
map: anObject
	map ifNotNil: [
		map scene: nil; levelPlayer: nil
	].

	map := anObject.
	
	map ifNotNil: [
		map scene: scene; levelPlayer: self
	]
	