library name
findAgpu
	"Look for the abstract gpu using different names."
	#(
	Agpu
	libAgpu.so
	Agpu.dll
	Agpu_d
	libAgpu_d.so
	Agpu_d.dll
	) do: [ :nm | [(self checkLibraryName: nm) ifTrue: [ ^ nm ] ] ifError: [nil] ].
	self error: 'Failed to find AbstractGPU library.'