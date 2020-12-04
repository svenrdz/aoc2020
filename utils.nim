import intsets
import strutils
import sequtils

proc read*(filename: string): seq[string] =
  toSeq(filename.lines)

proc readIntSeq*(filename: string): seq[int] =
  filename.read.map(parseInt)

proc readIntSet*(filename: string): IntSet =
  toIntSet(filename.readIntSeq)
