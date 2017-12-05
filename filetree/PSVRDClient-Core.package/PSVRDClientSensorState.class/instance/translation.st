accessing structure variables
translation
	"This method was automatically generated"
	^ PSVRDVector3 fromHandle: (handle referenceStructAt: OFFSET_TRANSLATION length: PSVRDVector3 byteSize)