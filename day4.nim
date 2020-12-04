import utils

import strutils
import strscans

type
  Fields = enum
    byr, iyr, eyr, hgt, hcl, ecl, pid, cid

  BirthYear = range[1920..2002]
  IssueYear = range[2010..2020]
  ExpirationYear = range[2020..2030]
  Unit = enum
    cms = "cm", inches = "in"
  Height = object
    unit: Unit
    cms: range[150..193]
    inches: range[59..76]
  HairColor = object
    hashtag: bool
    hex: array[0..5, range[0..15]]
  EyeColor = enum
    amb, blu, brn, gry, grn, hzl, oth
  PassportId = array[0..8, range[0..9]]
  CountryId = string

  Passport = object
    byr: BirthYear
    iyr: IssueYear
    eyr: ExpirationYear
    hgt: Height
    hcl: HairColor
    ecl: EyeColor
    pid: PassportId
    cid: string
    fields: set[Fields]
    validFields: set[Fields]

const allFields = {Fields.low..Fields.high}
const optionalFields = {cid}
const requiredFields = allFields - optionalFields

proc fill[T: range](value: var T, input: string): bool =
  let
    low = value.type.low
    high = value.type.high
  value = input.parseInt
  value in low..high

proc value(hgt: Height): int =
  case hgt.unit
  of cms: hgt.cms
  of inches: hgt.inches

proc fill(hgt: var Height, input: string): bool =
  var
    number: int
    unitString: string
    low, high: int
  discard scanf(input, "$i$w", number, unitString)
  hgt.unit = parseEnum[Unit](unitString)
  case hgt.unit
  of cms:
    hgt.cms = number
    low = hgt.cms.type.low
    high = hgt.cms.type.high
  of inches:
    hgt.inches = number
    low = hgt.inches.type.low
    high = hgt.inches.type.high
  hgt.value in low..high

proc fill[I, T](arr: var array[I, T], input: string): bool =
  let
    rLow = arr[0].type.low
    rHigh = arr[0].type.high
  if input.len != arr.len:
    return false
  for i, ch in input:
    let value = parseHexInt($ch)
    if value in rLow..rHigh:
      arr[i] = value
    else:
      return false
  true

proc fill(ecl: var EyeColor, input: string): bool =
  ecl = parseEnum[EyeColor](input)
  true

proc fill(cid: var string, input: string): bool =
  cid = input
  true

proc safeFill[T](field: var T, input: string): bool =
  try:
    field.fill(input)
  except:
    false

proc `[]=`(passport: var Passport, field: Fields, input: string) =
  let valid =
    case field
    of byr: safeFill(passport.byr, input)
    of iyr: safeFill(passport.iyr, input)
    of eyr: safeFill(passport.eyr, input)
    of hgt: safeFill(passport.hgt, input)
    of hcl:
      let validHex = safeFill(passport.hcl.hex, input[1..^1])
      passport.hcl.hashtag = input[0] == '#'
      validHex and passport.hcl.hashtag
    of ecl: safeFill(passport.ecl, input)
    of pid: safeFill(passport.pid, input)
    of cid: safeFill(passport.cid, input)
  if valid: passport.validFields.incl field

proc initPassport(batch: seq[string]): Passport =
  for field in batch:
    var attrString, value: string
    discard scanf(field, "$*:$*", attrString, value)
    let attr = parseEnum[Fields](attrString)
    result[attr] = value
    result.fields.incl attr

proc allRequiredFields(passport: Passport): bool =
  (requiredFields - passport.fields) == {}

proc allFieldsCorrect(passport: Passport): bool =
  (requiredFields - passport.validFields) == {}

proc isValid(passport: Passport): bool =
  passport.allRequiredFields and passport.allFieldsCorrect

proc parse(input: seq[string]): seq[Passport] =
  var batch: seq[string]
  for line in input:
    if line.len == 0:
      result.add batch.initPassport
      batch = @[]
    else:
      for field in line.splitWhitespace:
        batch.add field
  if batch.len > 0:
    result.add batch.initPassport

proc solve(input: seq[string]): (int, int) =
  let passports = input.parse
  for p in passports:
    if p.allRequiredFields:
      inc result[0]
    if p.isValid:
      inc result[1]

let
  filename = "inputs/4"
  input = filename.read
  (solution1, solution2) = input.solve

echo solution1
doAssert solution1 == 206

echo solution2
doAssert solution2 == 123
