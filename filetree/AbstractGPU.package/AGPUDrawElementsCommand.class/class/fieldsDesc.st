definition
fieldsDesc
	"
	self initializeAccessors
	"
	^ #(
		 agpu_uint index_count;
		 agpu_uint instance_count;
		 agpu_uint first_index;
		 agpu_int base_vertex;
		 agpu_uint base_instance;
		)
