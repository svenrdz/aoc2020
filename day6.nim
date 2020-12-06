import utils

type
  Answers = set[char]
  Group = seq[Answers]

proc initGroup(): Group =
  @[]

proc count1(group: Group): int =
  var answers: Answers
  for person in group:
    answers = answers + person
  answers.len

proc count2(group: Group): int =
  var answers = {'a'..'z'}
  for person in group:
    answers = answers * person
  answers.len

proc process(group: var Group, p1, p2: var int) =
  p1 += group.count1
  p2 += group.count2
  group = initGroup()

day6:
  var group: Group
  for line in input:
    if line.len == 0:
      group.process(part1, part2)
      continue
    group.add line.toSet
  if group.len > 0:
    group.process(part1, part2)
