import utils

import math
import tables
import sequtils

type
  Seat = object
    row: range[0..127]
    col: range[0..7]

  BinMap = Table[char, int]

proc initBinMap(lh: string): BinMap =
  for i, ch in lh:
    result[ch] = i

proc id(seat: Seat): uint16 =
  (seat.row * 8 + seat.col).uint16

proc parseBin(input: string, binMap: BinMap): int =
  var power = 2 ^ (input.len - 1)
  for ch in input:
    result.inc(power * binMap[ch])
    power = power div 2

proc parseSeat(input: string): Seat =
  result.row = input[0..6].parseBin(initBinMap("FB"))
  result.col = input[7..^1].parseBin(initBinMap("LR"))

day5:
  var
    seats: seq[Seat]
    ids: set[uint16]
    thisId: uint16
    idMin = uint16.high
    idMax = uint16.low
  for line in input:
    seats.add line.parseSeat
    thisId = seats[^1].id
    ids.incl thisId
    if thisId < idMin: idMin = thisId
    if thisId > idMax: idMax = thisId
  let allIds = {idMin..idMax}
  part1 = idMax.int
  part2 = toSeq(allIds - ids)[0].int
