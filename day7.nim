import utils

import sets
import hashes
import tables
import strscans
import strutils

type
  Bag = tuple[adj, name: string]
  Parents = HashSet[Bag]
  Children = CountTableRef[Bag]
  Links = object
    parents: Parents
    children: Children
  Bags = TableRef[Bag, Links]

proc `$`(bag: Bag): string =
  bag.adj & " " & bag.name

proc toBag(adj, name: string): Bag =
  (adj, name)

proc initLinks(): Links =
  Links(parents: initHashSet[Bag](), children: newCountTable[Bag]())

proc toLinks(parents: Parents): Links =
  result = initLinks()
  result.parents = parents

proc toLinks(bag: Bag, n: int): Links =
  result = initLinks()
  result.children.inc(bag, n)

proc parseBag(input: string): Bag =
  discard scanf(input, "$w $w bag", result.adj, result.name)

proc newBags(): Bags = newTable[Bag, Links]()

proc parseLine(input: string): Bags =
  new result
  let parent = input.parseBag
  result[parent] = initLinks()
  let children = input.split(" contain ")[1]
  for child in children.split(", "):
    try:
      let
        parts = child.splitWhitespace(1)
        n = parts[0].parseInt
        bag = parts[1].parseBag
      if bag.adj == "no": continue
      result[bag] = toLinks([parent].toHashSet)
      result[parent].children.merge(toLinks(bag, n).children)
    except ValueError:
      continue

proc fill(parents: var Parents, bags: Bags, keys: Parents) =
  var extra: Parents
  for key in keys:
    if key notin bags: continue
    extra = extra + bags[key].parents.difference(parents)
  if (extra - parents).len == 0: return
  parents = parents + extra
  parents.fill(bags, extra)

proc count(bags: Bags, children: Children): int =
  for bag, n in children.pairs:
    result.inc n
    result.inc n * bags.count(bags[bag].children)

day7:
  let myBag = toBag("shiny", "gold")
  var bags = newBags()
  for line in input:
    for bag, links in line.parseLine.pairs:
      if bags.hasKeyOrPut(bag, links):
        bags[bag].parents = bags[bag].parents + links.parents
        for child, n in links.children:
          bags[bag].children.inc(child, n)
  var parents: Parents
  parents.fill(bags, [myBag].toHashSet)
  part1 = parents.len
  part2 = bags.count(bags[myBag].children)
