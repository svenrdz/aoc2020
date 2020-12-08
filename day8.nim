import utils

import sets
import strscans
import strutils
import sequtils

type
  Operator = enum
    nop, acc, jmp
  Instruction = tuple[op: Operator, val: int]
  Program = seq[Instruction]
  Update = tuple[idx, acc: int]
  End = enum
    unknown, loop, termination
  State = object
    idx: int
    acc: int
    nd: End

proc initState(): State =
  State(idx: 0, acc: 0, nd: unknown)

proc parseInstruction(line: string): Instruction =
  var tmp: string
  discard scanf(line, "$w $i$.", tmp, result.val)
  result.op = parseEnum[Operator](tmp)

proc getUpdate(inst: Instruction): Update =
  case inst.op
  of nop: (1, 0)
  of acc: (1, inst.val)
  of jmp: (inst.val, 0)

proc apply(update: Update, state: State): State =
  result = state
  result.idx.inc update.idx
  result.acc.inc update.acc

proc next(program: Program, state: State): State =
  program[state.idx].getUpdate.apply(state)

proc visitUntilEnd(program: Program): State =
  var
    visited = initHashSet[int]()
    state = initState()
  while true:
    state = program.next(state)
    if state.idx in visited:
      state.nd = loop
      return state
    elif state.idx == program.len:
      state.nd = termination
      return state
    else:
      visited.incl state.idx

proc swap(program: Program, idx: int): Program =
  result = program
  case result[idx].op
  of nop:
    result[idx].op = jmp
  of jmp:
    result[idx].op = nop
  of acc:
    return

proc visitUntilTermination(base: Program): State =
  for i in 0..<base.len:
    if base[i].op == acc:
      continue
    let
      program = base.swap(i)
      endState = program.visitUntilEnd
    if endState.nd == termination:
      return endState

day8:
  let program = toSeq(input).map(parseInstruction)
  part1 = program.visitUntilEnd.acc
  part2 = program.visitUntilTermination.acc
