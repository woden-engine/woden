class initialization
startUp
	BufferRegistry do: [ :buffer | buffer startUp ].
	BufferRegistry removeAll