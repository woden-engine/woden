definition
fieldsDesc
	"
	self initializeAccessors
	"
	^ #(
		 agpu_filter filter;
		 agpu_texture_address_mode address_u;
		 agpu_texture_address_mode address_v;
		 agpu_texture_address_mode address_w;
		 agpu_float mip_lod_bias;
		 agpu_uint maxanisotropy;
		 agpu_compare_function comparison_function;
		 agpu_color4f border_color;
		 agpu_float min_lod;
		 agpu_float max_lod;
		)
