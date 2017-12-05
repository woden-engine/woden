accessing structure variables
orientation
	"This method was automatically generated"
	^ PSVRDQuaternion fromHandle: (handle referenceStructAt: OFFSET_ORIENTATION length: PSVRDQuaternion byteSize)