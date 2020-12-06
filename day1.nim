import utils

import intsets
import sequtils
import strutils

day1:
  let numbers = input.map(parseInt)
  let nbSet = numbers.toIntSet
  for i in 0..<numbers.len:
    let n1 = numbers[i]
    if 2020 - n1 in nbSet:
      part1 = (2020 - n1) * n1
      if part2 != 0:
        break
    else:
      for j in i+1..<numbers.len:
        let n2 = numbers[j]
        if 2020 - n1 - n2 in nbSet:
          part2 = (2020 - n1 - n2) * n1 * n2
          break
