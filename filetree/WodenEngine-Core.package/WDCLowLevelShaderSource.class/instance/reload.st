compiling
reload
	engine trace: 'Recompiling shader {1}' format: { entryFile fullName }.
	self compile.
	stages do: #reload