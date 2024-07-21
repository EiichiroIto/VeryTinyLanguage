Class {
	#name : #CVTLMemory,
	#superclass : #Object,
	#instVars : [
		'core'
	],
	#category : #'CVTL-Core'
}

{ #category : #action }
CVTLMemory >> allocate: anInteger [

	core := ByteArray new: anInteger withAll: 0
]

{ #category : #accessing }
CVTLMemory >> byteAt: anInteger [

	^ core at: anInteger + 1
]

{ #category : #accessing }
CVTLMemory >> byteAt: anInteger put: anInteger2 [

	core at: anInteger + 1 put: anInteger2
]

{ #category : #action }
CVTLMemory >> copyByteFrom: anInteger to: anInteger2 [

	| tmp |
	tmp := self byteAt: anInteger.
	self byteAt: anInteger2 put: tmp.
	^ tmp
]

{ #category : #action }
CVTLMemory >> copyString: aString to: anInteger [

	aString withIndexDo: [ :each :index | 
		self byteAt: anInteger + index - 1 put: each asciiValue ].
	self byteAt: anInteger + aString size put: 0
]

{ #category : #action }
CVTLMemory >> copyWordFrom: anInteger to: anInteger2 [

	| tmp |
	tmp := self wordAt: anInteger.
	self wordAt: anInteger2 put: tmp.
	^ tmp
]

{ #category : #accessing }
CVTLMemory >> core [

	^ core
]

{ #category : #accessing }
CVTLMemory >> core: anObject [

	core := anObject
]

{ #category : #accessing }
CVTLMemory >> countFrom: anInteger until: anInteger2 [

	| count pos |
	count := 0.
	pos := anInteger.
	[ (self byteAt: pos) ~= anInteger2 ] whileTrue: [ 
		count := count + 1.
		pos := pos + 1 ].
	^ count
]

{ #category : #accessing }
CVTLMemory >> stringFrom: anInteger until: anInteger2 [

	| stream pos c |
	stream := WriteStream on: String new.
	pos := anInteger.
	[ 
	c := self byteAt: pos.
	c ~= anInteger2 ] whileTrue: [ 
		stream nextPut: (Character value: c).
		pos := pos + 1 ].
	^ stream contents
]

{ #category : #accessing }
CVTLMemory >> wordAt: anInteger [

	^ (core at: anInteger + 1) + ((core at: anInteger + 2) * 256)
]

{ #category : #accessing }
CVTLMemory >> wordAt: anInteger put: anInteger2 [

	core at: anInteger + 1 put: anInteger2 \\ 256.
	core at: anInteger + 2 put: anInteger2 // 256
]
