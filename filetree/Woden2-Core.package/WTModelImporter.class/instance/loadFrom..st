as yet unclassified
loadFrom: jsonData
	| boundingBox armature actions |
	self loadVertices: (jsonData at: 'vertices').
	submeshes := self loadSubmeshes: (jsonData at: 'submeshes').
	boundingBox := self loadBoundingBox: (jsonData at: 'boundingBox').
	armature := nil.
	actions := nil.
	jsonData at: 'armature' ifPresent: [ :armatureData | armature := self loadArmature: armatureData ].
	jsonData at: 'actions' ifPresent: [ :actionsData | actions := self loadActions: actionsData ].
	^ WTModel new
		vertices: vertices;
		indices: indices;
		submeshes: submeshes;
		boundingBox: boundingBox;
		armature: armature;
		actions: actions;
		yourself.