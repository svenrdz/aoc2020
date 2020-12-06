import utils

import strscans
import strutils

type
  Rule = object
    letter: char
    min, max: int

  Password = object
    value: string
    rule: Rule
    correct1: bool
    correct2: bool


proc parseRuleValue(line: string): (Rule, string) =
  var ch: string
  discard scanf(line, "$i-$i $w: $w", result[0].min, result[0].max, ch, result[1])
  result[0].letter = ch[0]

proc isCorrect1(pw: string, rule: Rule): bool =
  let nbLetter = pw.count(rule.letter)
  rule.min <= nbLetter and nbLetter <= rule.max

proc isCorrect2(pw: string, rule: Rule): bool =
  let isLetterAt1 = pw[rule.min - 1] == rule.letter
  let isLetterAt2 = pw[rule.max - 1] == rule.letter
  isLetterAt1 xor isLetterAt2

proc parsePassword(line: string): Password =
  (result.rule, result.value) = line.parseRuleValue
  result.correct1 = result.value.isCorrect1(result.rule)
  result.correct2 = result.value.isCorrect2(result.rule)

day2:
  var pass: Password
  for line in input:
    pass = line.parsePassword
    if pass.correct1:
      inc part1
    if pass.correct2:
      inc part2
