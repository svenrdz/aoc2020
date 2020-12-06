import macros
import intsets
import strutils
import sequtils

proc read*(filename: string): seq[string] =
  toSeq(filename.lines)

proc readIntSeq*(filename: string): seq[int] =
  filename.read.map(parseInt)

proc readIntSet*(filename: string): IntSet =
  toIntSet(filename.readIntSeq)

proc toSet*(str: string): set[char] =
  for ch in str:
    result.incl ch

macro days(): untyped =
  result = newStmtList()
  for n in 1..25:
    result.add nnkTemplateDef.newTree(
      nnkPostfix.newTree(ident"*", ident("day" & $n)),
      newEmptyNode(),
      newEmptyNode(),
      nnkFormalParams.newTree(
        newEmptyNode(),
        newIdentDefs(
          ident("body"),
          ident("untyped"))),
      newEmptyNode(),
      newEmptyNode(),
      newStmtList(
        newProc(
          ident"solve",
          @[nnkBracketExpr.newTree(
              newIdentNode("array"),
              infix(newLit(1), "..", newLit(2)),
              newIdentNode("int")),
            newIdentDefs(
              ident"input",
              nnkBracketExpr.newTree(ident"seq", ident"string"))],
          newStmtList(
            nnkLetSection.newTree(
              newIdentDefs(
                nnkPragmaExpr.newTree(
                  ident"input",
                  nnkPragma.newTree(ident"inject")),
                newEmptyNode(),
                ident"input")),
            nnkVarSection.newTree(
              newIdentDefs(
                nnkPragmaExpr.newTree(
                  ident"part1",
                  nnkPragma.newTree(ident"inject")),
                newEmptyNode(),
                nnkBracketExpr.newTree(ident"result", newLit(1))),
              newIdentDefs(
                nnkPragmaExpr.newTree(
                  ident"part2",
                  nnkPragma.newTree(ident"inject")),
                newEmptyNode(),
                nnkBracketExpr.newTree(ident"result", newLit(2)))),
            ident"body",
            nnkBracket.newTree(ident"part1", ident"part2"))),
          newLetStmt(
            ident"sol",
            newDotExpr(
              newCall(
                ident"read",
                infix(newLit("inputs/"), "&", newLit($n))),
              ident"solve")),
          newCall(
            ident"echo",
            newLit("Day "),
            newLit($n),
            newLit(" solutions:")),
          newCall(
            ident"echo",
            newLit("\tPart 1: "),
            nnkBracketExpr.newTree(ident"sol", newLit(1))),
          newCall(
            ident"echo",
            newLit("\tPart 2: "),
            nnkBracketExpr.newTree(ident"sol", newLit(2)))))

days()
