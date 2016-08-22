initialisation
pickEngine
	self allSubclasses do: [ :sc  | sc isSupported ifTrue: [ ^ sc new ] ].
	^ nil