library name
checkLibraryName: aName
	^ (NativeBoost loadSymbol: 'agpuGetPlatforms' fromModule: aName) notNil