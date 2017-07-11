
"Load the runtime changes that are required for Lowcode"
'scripts/LowcodeRuntimeChanges.cs' asFileReference fileIn.
Smalltalk recreateSpecialObjectsArray.

"Update the UnifiedFFI"
"FileStream stdout nextPutAll: 'Updating the UnifiedFFI'; lf.
Gofer it
    url: 'http://smalltalkhub.com/mc/Pharo/FFI-NB/main';
    package: 'ConfigurationOfUnifiedFFI';
    load.
(Smalltalk at: #ConfigurationOfUnifiedFFI) load.
Author useAuthor: 'Woden2Loader' during: [
    FFIExternalStructure allSubclassesDo: #rebuildFieldAccessors.
]."

"Update OSWindow"
FileStream stdout nextPutAll: 'Updating the UnifiedFFI'; lf.
Gofer it
    url: 'http://smalltalkhub.com/mc/Pharo/OSWindow/main';
    package: 'ConfigurationOfOSWindow';
    load.
(Smalltalk at: #ConfigurationOfOSWindow) load.
Author useAuthor: 'Woden2Loader' during: [
    FFIExternalStructure allSubclassesDo: #rebuildFieldAccessors.
].

"Load Lowcode"
FileStream stdout nextPutAll: 'Loading LowcodeOpalCompiler'; lf.

Gofer it
    url: 'http://smalltalkhub.com/mc/ronsaldo/Lowcode/main';
    package: 'ConfigurationOfLowcode';
    load.
((Smalltalk at: #ConfigurationOfLowcode) project version: #stable) load: #(WithOpalCompiler).

"Load Git file tree. Only 32 bits for now."
Smalltalk wordSize = 8 ifFalse: [
    FileStream stdout nextPutAll: 'Loading GitFileTree'; lf.

    Metacello new
      baseline: 'FileTree';
      repository: 'github://dalehenrich/filetree:pharo6.0_dev/repository';
      load: 'Git'.
].

"Use the modified version of monticello"
'scripts/MonticelloMethodSorting.cs' asFileReference fileIn.

"Load Woden 2"
FileStream stdout nextPutAll: 'Loading Woden2'; lf.
Smalltalk wordSize = 8 ifTrue: [
    Metacello new
      baseline: 'Woden2';
      repository: 'filetree://filetree';
      load.
] ifFalse: [
    Metacello new
	   baseline: 'Woden2';
       repository: ('gitfiletree://' , ('filetree' asFileReference asAbsolute fullName));
	   load.
].

"Install the Lowcode FFI by default when using a 64 bits VM. This is because the
 passing of structures is not working completely yet."
Smalltalk wordSize = 8 ifTrue: [
    (Smalltalk at: #LowcodeFFICalloutAPI) install.
].

"Save the image"
(Smalltalk saveAs: 'woden2')
    ifFalse: [ Smalltalk snapshot: false andQuit: true ].
