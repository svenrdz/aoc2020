import utils
import sequtils

type
  Move = object
    down, right: int

  Position = object
    x, y, len: int

proc initMove(right = 3, down = 1): Move =
  Move(down: down, right: right)

proc initPosition(len: int, x = 0, y = 0): Position =
  Position(x: x, y: y, len: len)

proc stepX(pos: var Position, move: Move) =
  pos.x.inc(move.right)
  pos.x = pos.x mod pos.len

proc stepY(pos: var Position, move: Move) =
  pos.y.inc
  pos.y = pos.y mod move.down

proc isTree(line: string, pos: Position): bool =
  result = line[pos.x] == '#'

proc solve1(input: seq[string], move = initMove()): int =
  var pos = initPosition(input[0].len)
  for line in input:
    if pos.y == 0:
      if line.isTree(pos):
        inc result
      pos.stepX(move)
    pos.stepY(move)

proc solve2(input: seq[string]): int =
  var slopes: seq[int]
  let moves = @[
    initMove(1, 1),
    initMove(3, 1),
    initMove(5, 1),
    initMove(7, 1),
    initMove(1, 2),
  ]
  for move in moves:
    slopes.add input.solve1(move)
  foldr(slopes, a * b)

let
  filename = "inputs/3"
  input = filename.read
  solution1 = input.solve1
  solution2 = input.solve2

echo solution1
doAssert solution1 == 151

echo solution2
doAssert solution2 == 7540141059
