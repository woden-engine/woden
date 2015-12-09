definition
fieldsDesc
	"
	self initializeAccessors
	"
	^ #(
		 agpu_uint size;
		 agpu_buffer_usage_type usage;
		 agpu_buffer_binding_type binding;
		 agpu_bitfield mapping_flags;
		 agpu_uint stride;
		)
