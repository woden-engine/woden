Class {
	#name : #WDDDSFileHeader,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#size => UInt32',
		'#flags => UInt32',
		'#height => UInt32',
		'#width => UInt32',
		'#pitchOrLinearSize => UInt32',
		'#depth => UInt32',
		'#mipMapCount => UInt32',
		'#reserved1 => (UInt32 array: 11)',
		'#pixelFormat => WDCDDSPixelFormat',
		'#caps => UInt32',
		'#caps2 => UInt32',
		'#caps3 => UInt32',
		'#caps4 => UInt32',
		'#reserved2 => UInt32'
	],
	#category : #'WodenEngine-NativeStructures-Core-Texture'
}
