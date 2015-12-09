definition
fieldsDesc
	"
	self initializeAccessors
	"
	^ #(
		 agpu_uint buffer;
		 agpu_uint binding;
		 agpu_field_type type;
		 agpu_uint components;
		 agpu_uint rows;
		 agpu_bool normalized;
		 agpu_size offset;
		 agpu_uint divisor;
		)
