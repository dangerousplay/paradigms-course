import std/rdstdin
import std/deques
import std/re
import sugar
from std/strutils import parseFloat


type
  Evaluator = ref object
    buffer: Deque[string]

let regex = re"((?P<number>[0-9]+(\.[0-9]+)?)|(?P<op>[+\-*/^]))+"

proc parse*(expression: string): Evaluator =
  let buffer = findAll(expression, regex).toDeque
  result = Evaluator(buffer: buffer)

proc number*(e: var Evaluator): float64 =
  result = parseFloat(e.buffer.popFirst())

proc operation*(e: var Evaluator): string =
  result = e.buffer.peekFirst

proc evaluateOp(a: float64, op: string, b: float64): float64 =
  case op
    of "+":
      result = a + b
    of "-":
      result = a - b
    of "*":
      result = a * b
    of "/":
      result = a / b
    else:
      raise newException(ValueError, "Invalid operand: " & op)

proc evaluate*(e: var Evaluator, a: (var Evaluator) -> float64, operations: seq[string], b: (var Evaluator) -> float64): float64 =
  let number = a(e)
  result = number

  try:
    let op = e.operation()

    if operations.contains(op):
      e.buffer.popFirst
      result = evaluateOp(number, op, b(e))
  except IndexDefect:
    return

proc e(ev: var Evaluator): float64 =
  proc f(ev: var Evaluator): float64 =
    result = ev.evaluate((e: var Evaluator) => e.number, @["+", "-", "/", "*", "^"], (e: var Evaluator) => e.e)

  proc fe(ev: var Evaluator): float64 =
    result = ev.evaluate((e: var Evaluator) => e.f, @["^"], (e: var Evaluator) => e.f)

  proc t(ev: var Evaluator): float64 =
    result = ev.evaluate((e: var Evaluator) => e.fe, @["/", "*"], (e: var Evaluator) => e.fe)

  result = ev.evaluate((e: var Evaluator) => e.t, @["+", "-"], (e: var Evaluator) => e.e)

proc evaluateExpression(ev: var Evaluator): float64 =
  result = ev.e

while true:
  let expression = readLineFromStdin("Expression: ")
  var evaluator = parse(expression)
  let value = evaluator.evaluateExpression

  echo("Number: " & $value)
