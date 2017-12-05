field definition
fieldsDesc
	"
	self rebuildFieldAccessors
	"
	^ #(
		psvrd_quaternion_t orientation;
		psvrd_vector3_t translation;
	)