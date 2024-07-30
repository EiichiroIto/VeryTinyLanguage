"
A CVTLContextTest is a test class for testing the behavior of CVTLContext
"
Class {
	#name : #VTLContextTest,
	#superclass : #TestCase,
	#category : #'VTL-Tests'
}

{ #category : #'instance creation' }
VTLContextTest >> newMemory: anInteger [

	^ VTLMemory new
		  allocate: anInteger;
		  yourself
]

{ #category : #'instance creation' }
VTLContextTest >> newObj [

	^ VTLContext new
]

{ #category : #tests }
VTLContextTest >> testByteIn [

	| obj memory r |
	obj := self newObj.
	memory := self newMemory: 4.
	memory byteAt: 0 put: 10.
	memory byteAt: 1 put: 11.
	memory byteAt: 2 put: 12.
	memory byteAt: 3 put: 13.

	obj position: 0.
	r := obj byteIn: memory.
	self assert: r equals: 10.

	obj position: 3.
	r := obj byteIn: memory.
	self assert: r equals: 13
]

{ #category : #tests }
VTLContextTest >> testDecrement [

	| obj |
	obj := self newObj.
	obj position: 123.
	self assert: obj position equals: 123.
	obj decrement.
	self assert: obj position equals: 122.
	obj decrement.
	self assert: obj position equals: 121
]

{ #category : #tests }
VTLContextTest >> testIncrement [

	| obj |
	obj := self newObj.
	obj position: 123.
	self assert: obj position equals: 123.
	obj increment.
	self assert: obj position equals: 124.
	obj increment.
	self assert: obj position equals: 125
]

{ #category : #tests }
VTLContextTest >> testPosition [

	| obj |
	obj := self newObj.
	self assert: obj position isNil.
	obj position: 123.
	self assert: obj position equals: 123.
	obj position: 456.
	self assert: obj position equals: 456
]

{ #category : #tests }
VTLContextTest >> testPrintOn [

	| obj stream |
	obj := self newObj.
	stream := WriteStream on: String new.
	obj printOn: stream.
	self assert: stream contents equals: 'Context[nil]'.
	obj position: 123.
	stream := WriteStream on: String new.
	obj printOn: stream.
	self assert: stream contents equals: 'Context[123]'
]
