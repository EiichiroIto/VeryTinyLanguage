"
A CVTLMemoryTest is a test class for testing the behavior of CVTLMemory
"
Class {
	#name : #VTLMemoryTest,
	#superclass : #TestCase,
	#category : #'VTL-Tests'
}

{ #category : #'instance creation' }
VTLMemoryTest >> newObj [

	^ VTLMemory new
]

{ #category : #tests }
VTLMemoryTest >> testAllocate [

	| obj |
	obj := self newObj.
	self assert: obj core isNil.
	obj allocate: 1024.
	self assert: obj core class equals: ByteArray.
	self assert: obj core size equals: 1024
]

{ #category : #tests }
VTLMemoryTest >> testByteAt [

	| obj |
	obj := self newObj.
	self assert: obj core isNil.
	obj core: #[ 5 4 3 2 1 ].
	self assert: (obj byteAt: 0) equals: 5.
	self assert: (obj byteAt: 1) equals: 4.
	self assert: (obj byteAt: 2) equals: 3.
	self assert: (obj byteAt: 3) equals: 2.
	self assert: (obj byteAt: 4) equals: 1
]

{ #category : #tests }
VTLMemoryTest >> testByteAtPut [

	| obj |
	obj := self newObj.
	self assert: obj core isNil.
	obj allocate: 5.
	obj byteAt: 0 put: 5.
	obj byteAt: 1 put: 4.
	obj byteAt: 2 put: 3.
	obj byteAt: 3 put: 2.
	obj byteAt: 4 put: 1.
	self assertCollection: obj core equals: #[ 5 4 3 2 1 ]
]

{ #category : #tests }
VTLMemoryTest >> testCopyByteFromTo [

	| obj |
	obj := self newObj.
	obj allocate: 10.
	obj byteAt: 1 put: 10.
	obj byteAt: 2 put: 20.
	obj byteAt: 3 put: 30.
	self assertCollection: obj core equals: #[ 0 10 20 30 0 0 0 0 0 0 ].
	obj copyByteFrom: 2 to: 6.
	obj copyByteFrom: 3 to: 4.
	self assertCollection: obj core equals: #[ 0 10 20 30 30 0 20 0 0 0 ]
]

{ #category : #tests }
VTLMemoryTest >> testCopyStringTo [

	| obj |
	obj := self newObj.
	obj allocate: 10.
	obj byteAt: 1 put: 2.
	obj byteAt: 5 put: 3.
	obj byteAt: 6 put: 4.
	self assertCollection: obj core equals: #[ 0 2 0 0 0 3 4 0 0 0 ].
	obj copyString: 'ABC' to: 2.
	self assertCollection: obj core equals: #[ 0 2 65 66 67 0 4 0 0 0 ]
]

{ #category : #tests }
VTLMemoryTest >> testCore [

	| obj arr |
	obj := self newObj.
	self assert: obj core isNil.
	arr := #[ 1 2 3 ].
	obj core: arr.
	self assert: obj core identicalTo: arr
]

{ #category : #tests }
VTLMemoryTest >> testCountFromUntil [

	| obj r |
	obj := self newObj.
	obj allocate: 10.
	obj byteAt: 1 put: 2.
	obj byteAt: 5 put: 3.
	obj byteAt: 6 put: 4.
	self assertCollection: obj core equals: #[ 0 2 0 0 0 3 4 0 0 0 ].
	r := obj countFrom: 0 until: 0.
	self assert: r equals: 0.
	r := obj countFrom: 1 until: 0.
	self assert: r equals: 1.
	r := obj countFrom: 5 until: 0.
	self assert: r equals: 2.
	obj copyString: 'ABC' to: 2.
	self assertCollection: obj core equals: #[ 0 2 65 66 67 0 4 0 0 0 ].
	r := obj countFrom: 0 until: 0.
	self assert: r equals: 0.
	r := obj countFrom: 1 until: 0.
	self assert: r equals: 4.
	r := obj countFrom: 6 until: 0.
	self assert: r equals: 1
]

{ #category : #tests }
VTLMemoryTest >> testStringFromUntil [

	| obj r |
	obj := self newObj.
	obj allocate: 10.
	obj copyString: 'ABC' to: 2.
	r := obj stringFrom: 2 until: 0.
	self assert: r equals: 'ABC'.
	r := obj stringFrom: 2 until: $C asciiValue.
	self assert: r equals: 'AB'
]

{ #category : #tests }
VTLMemoryTest >> testWordAt [

	| obj r |
	obj := self newObj.
	self assert: obj core isNil.
	obj core: #[ 5 4 3 2 ].
	r := obj wordAt: 0.
	self assert: r equals: 5 + (4 * 256).
	r := obj wordAt: 2.
	self assert: r equals: 3 + (2 * 256)
]

{ #category : #tests }
VTLMemoryTest >> testWordAtPut [

	| obj |
	obj := self newObj.
	self assert: obj core isNil.
	obj allocate: 4.
	obj wordAt: 0 put: 5 + (4 * 256).
	obj wordAt: 2 put: 3 + (2 * 256).
	self assertCollection: obj core equals: #[ 5 4 3 2 ]
]
