definition
fieldsDesc
	"
	self initializeAccessors
	"
	^ #(
		 agpu_texture_type type;
		 agpu_uint width;
		 agpu_uint height;
		 agpu_ushort depthOrArraySize;
		 agpu_ushort miplevels;
		 agpu_texture_format format;
		 agpu_texture_flags flags;
		)
