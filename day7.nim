import utils

import sets
import hashes
import tables
import strscans
import strutils

type
  Bag = tuple[adj, name: string]
  Parents = HashSet[Bag]
  Bags = TableRef[Bag, Parents]

proc `$`(bag: Bag): string =
  bag.adj & " " & bag.name

proc initBag(adj, name: string): Bag =
  (adj, name)

proc parseBag(input: string): Bag =
  discard scanf(input, "$w $w bag", result.adj, result.name)

proc newBags(): Bags = newTable[Bag, Parents]()

proc parseLine(input: string): Bags =
  new result
  let parent = input.parseBag
  let children = input.split(" contain ")[1]
  for child in children.split(", "):
    try:
      let
        parts = child.splitWhitespace(1)
        # n = parts[0].parseInt
        bag = parts[1].parseBag
      if bag.adj == "no": continue
      result[bag] = [parent].toHashSet
    except:
      continue

proc fill(parents: var Parents, bags: Bags, keys: Parents) =
  var extra: Parents
  for key in keys:
    if key notin bags: continue
    extra = extra + bags[key].difference(parents)
  if (extra - parents).len == 0: return
  parents = parents + extra
  parents.fill(bags, extra)

day7:
  let myBag = initBag("shiny", "gold")
  var bags = newBags()
  for line in input:
    for bag, parents in line.parseLine.pairs:
      if bags.hasKeyOrPut(bag, parents):
        bags[bag] = bags[bag] + parents
  var parents: Parents
  parents.fill(bags, [myBag].toHashSet)
  part1 = parents.len
