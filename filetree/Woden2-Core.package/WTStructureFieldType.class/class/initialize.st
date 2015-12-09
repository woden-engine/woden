class initialization
initialize
	"
	self initialize
	"
	super initialize.

	FieldTypes := IdentityDictionary new.
		
	{ 
	self name: #float type: AGPU_FLOAT components: 1 rows: 1 normalized: false size: 4 alignment: 4.
	self name: #vec2  type: AGPU_FLOAT components: 2 rows: 1 normalized: false size: 8 alignment: 4.
	self name: #vec3  type: AGPU_FLOAT components: 3 rows: 1 normalized: false size: 12 alignment: 4.
	self name: #vec4  type: AGPU_FLOAT components: 4 rows: 1 normalized: false size: 16 alignment: 4.
	
	self name: #int   type: AGPU_INT components: 1 rows: 1 normalized: false size: 4 alignment: 4.
	self name: #ivec2 type: AGPU_INT components: 2 rows: 1 normalized: false size: 8 alignment: 4.
	self name: #ivec3 type: AGPU_INT components: 3 rows: 1 normalized: false size: 12 alignment: 4.
	self name: #ivec4 type: AGPU_INT components: 4 rows: 1 normalized: false size: 16 alignment: 4.

	self name: #uint   type: AGPU_UNSIGNED_INT components: 1 rows: 1 normalized: false size: 4 alignment: 4.
	self name: #uivec2 type: AGPU_UNSIGNED_INT components: 2 rows: 1 normalized: false size: 8 alignment: 4.
	self name: #uivec3 type: AGPU_UNSIGNED_INT components: 3 rows: 1 normalized: false size: 12 alignment: 4.
	self name: #uivec4 type: AGPU_UNSIGNED_INT components: 4 rows: 1 normalized: false size: 16 alignment: 4.
	
	self name: #short type: AGPU_SHORT components: 1 rows: 1 normalized: false size: 4 alignment: 2.
	self name: #svec2 type: AGPU_SHORT components: 2 rows: 1 normalized: false size: 8 alignment: 4.
	self name: #svec4 type: AGPU_SHORT components: 4 rows: 1 normalized: false size: 16 alignment: 8.

	self name: #ushort type: AGPU_UNSIGNED_SHORT components: 1 rows: 1 normalized: false size: 2 alignment: 2.
	self name: #usvec2 type: AGPU_UNSIGNED_SHORT components: 2 rows: 1 normalized: false size: 4 alignment: 4.
	self name: #usvec4 type: AGPU_UNSIGNED_SHORT components: 4 rows: 1 normalized: false size: 8 alignment: 8.

	self name: #nshort type: AGPU_SHORT components: 1 rows: 1 normalized: true size: 2 alignment: 2.
	self name: #nsvec2 type: AGPU_SHORT components: 2 rows: 1 normalized: true size: 4 alignment: 4.
	self name: #nsvec4 type: AGPU_SHORT components: 4 rows: 1 normalized: true size: 8 alignment: 8.

	self name: #nushort type: AGPU_UNSIGNED_SHORT components: 1 rows: 1 normalized: true size: 2 alignment: 2.
	self name: #nusvec2 type: AGPU_UNSIGNED_SHORT components: 2 rows: 1 normalized: true size: 4 alignment: 4.
	self name: #nusvec4 type: AGPU_UNSIGNED_SHORT components: 4 rows: 1 normalized: true size: 8 alignment: 8.

	self name: #byte type: AGPU_BYTE components: 1 rows: 1 normalized: false size: 1 alignment: 1.
	self name: #bvec2 type: AGPU_BYTE components: 2 rows: 1 normalized: false size: 2 alignment: 2.
	self name: #bvec4 type: AGPU_BYTE components: 4 rows: 1 normalized: false size: 3 alignment: 4.

	self name: #ubyte type: AGPU_UNSIGNED_BYTE components: 1 rows: 1 normalized: false size: 1 alignment: 1.
	self name: #ubvec2 type: AGPU_UNSIGNED_BYTE components: 2 rows: 1 normalized: false size: 2 alignment: 2.
	self name: #ubvec4 type: AGPU_UNSIGNED_BYTE components: 4 rows: 1 normalized: false size: 3 alignment: 4.

	self name: #nbyte type: AGPU_BYTE components: 1 rows: 1 normalized: true size: 1 alignment: 1.
	self name: #nbvec2 type: AGPU_BYTE components: 2 rows: 1 normalized: true size: 2 alignment: 2.
	self name: #nbvec4 type: AGPU_BYTE components: 4 rows: 1 normalized: true size: 3 alignment: 4.

	self name: #nubyte type: AGPU_UNSIGNED_BYTE components: 1 rows: 1 normalized: true size: 1 alignment: 1.
	self name: #nubvec2 type: AGPU_UNSIGNED_BYTE components: 2 rows: 1 normalized: true size: 2 alignment: 2.
	self name: #nubvec4 type: AGPU_UNSIGNED_BYTE components: 4 rows: 1 normalized: true size: 3 alignment: 4.

	} do: [:type |
		FieldTypes at: type name put: type.
	]