import utils

import strutils
import sequtils

type
  RingBuffer = object
    buf: seq[int]
    rIdx, wIdx: int
  RBEmptyError = KeyError

proc size(rb: RingBuffer): int =
  rb.buf.len

proc len(rb: RingBuffer): int =
  rb.wIdx - rb.rIdx

proc initRingBuffer(n: int): RingBuffer =
  result.buf = newSeq[int](n)

proc r(rb: RingBuffer, n = 0): int =
  (n + rb.rIdx) mod rb.size

proc w(rb: RingBuffer): int =
  rb.wIdx mod rb.size

proc isEmpty(rb: RingBuffer): bool =
  rb.rIdx > rb.wIdx

proc isFull(rb: RingBuffer): bool =
  rb.wIdx - rb.rIdx >= rb.size

proc pop(rb: var RingBuffer, safe = true): int =
  if not safe and rb.isEmpty:
    raise newException(RBEmptyError, "nothing to read")
  result = rb.buf[rb.r]
  inc rb.rIdx

proc `[]`(rb: RingBuffer, idx: int): int =
  rb.buf[rb.r(idx)]

iterator items(rb: RingBuffer): int =
  for i in 0..<rb.len:
    yield rb[i]

proc `$`(rb: RingBuffer): string =
  for item in rb.items:
    result.add $item & ", "
  result[0..^3]

proc add(rb: var RingBuffer, item: int) =
  if rb.isFull:
    discard rb.pop
  rb.buf[rb.w] = item
  inc rb.wIdx

proc add(rb: var RingBuffer, data: openArray[int]) =
  for item in data:
    rb.add item

proc check(rb: RingBuffer, number: int): bool =
  for i in 0..<rb.len:
    for j in i+1..<rb.len:
      if rb[i] + rb[j] == number:
        return true
  false

proc process(input: seq[int], n: int): int =
  var buffer = initRingBuffer(n)
  buffer.add input[0..<n]
  for number in input[n..^1]:
    if not buffer.check(number):
      return number
    buffer.add number

proc findContiguousSet(input: seq[int], sumTo: int): seq[int] =
  for i in 0..<input.len:
    var
      sum = 0
    for j in i..<input.len:
      sum.inc input[j]
      if sum > sumTo:
        break
      elif sum == sumTo:
        return input[i..j]

day9:
  let numbers = input.map(parseInt)
  part1 = numbers.process(25)
  let contiguous = numbers.findContiguousSet(part1)
  part2 = contiguous.min + contiguous.max
