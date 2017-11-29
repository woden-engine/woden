initialization
createDevice
	device := AGPU mainDevice.
	graphicsQueue := device getDefaultCommandQueue.
	"| platform deviceOpenInfo |
	platform := AGPU firstPlatform.
	platform ifNil: [ self error: 'Failed to open the AGPU platform' ].

	deviceOpenInfo := AGPUDeviceOpenInfo new debug_layer: self class debugLayerEnabled asBit.
	device := platform openDevice: deviceOpenInfo.
	device ifNil: [ self error: 'Failed to open the AGPU device' ]."
