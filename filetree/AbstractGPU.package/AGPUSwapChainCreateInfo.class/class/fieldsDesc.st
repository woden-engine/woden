definition
fieldsDesc
	"
	self initializeAccessors
	"
	^ #(
		 agpu_pointer window;
		 agpu_pointer surface;
		 agpu_texture_format colorbuffer_format;
		 agpu_texture_format depth_stencil_format;
		 agpu_uint width;
		 agpu_uint height;
		 agpu_bool doublebuffer;
		 agpu_bool sample_buffers;
		 agpu_int samples;
		)
