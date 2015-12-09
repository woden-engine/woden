library name
findAgpu
	"Look for the abstract gpu using different names."
	#(
	'native-libraries/Agpu'
	'native-libraries/libAgpu.so'
	'native-libraries/libAgpu.dylib'
	'native-libraries/Agpu.dll'
	'native-libraries/Agpu_d'
	'native-libraries/libAgpu_d.so'
	'native-libraries/libAgpu_d.dylib'
	'native-libraries/Agpu_d.dll'
	) do: [ :nm | [(self checkLibraryName: nm) ifTrue: [ ^ nm ] ] ifError: [nil] ].
	self error: 'Failed to find AbstractGPU library.'