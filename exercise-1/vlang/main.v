module main

import readline { read_line }
import regex
import strconv
import math


type NumberFn = fn () !f64

type Token = f64 | string

struct Iterator[T] {
	arr []T
mut:
	idx int
}

fn (mut iter Iterator[T]) next() ?T {
	return iter.inner_next(true)
}

fn (mut iter Iterator[T]) goback() {
	if iter.idx <= 0 {
		iter.idx = 0
	} else {
		iter.idx--
	}
}


fn (mut iter Iterator[T]) peek() ?T {
	return iter.inner_next(false)
}

fn (mut iter Iterator[T]) inner_next(increament bool) ?T {
	if iter.idx >= iter.arr.len {
		return none
	}
	defer {
		if increament {
			iter.idx++
		}
	}

	return iter.arr[iter.idx]
}

struct Empty {
	Error
}

fn (err Empty) msg() string {
	return 'No more items'
}

[heap]
struct Evaluator {
mut:
	buffer Iterator[Token]
}

fn parse(expression string) ?Iterator[Token] {
	query := r"((?P<number>[0-9]+(\.[0-9]+)?)|(?P<op>[+\-*/^]))+"

	mut re := regex.regex_opt(query)?
	re.debug=0  // disable log
	re.group_csave_flag = true

	start:= re.find_all_str(expression)

	mut tokens := []Token{}

	for str in start {
		mut op := ''

		number := strconv.atof64(str) or {
			op = str
			0
		}

		if str == '+' {
			op = str
		}

		if op != '' {
			tokens << op
		} else {
			tokens << number
		}
	}

	return Iterator[Token]{arr: tokens}
}

fn (mut ev Evaluator) evaluate_expression(expression string) !f64 {

	ev.buffer = parse(expression) or { return error("failed to parse expression") }

	return ev.e()!
}

fn (mut ev Evaluator) number() !f64 {
	token := ev.buffer.next() or { return Empty{} }

	match token {
		f64 {
			return token
		}
		else {
			return error("Expected token ${token} to be a number")
		}
	}
}

fn (mut ev Evaluator) operation() !string {
	token := ev.buffer.next() or { return Empty{} }

	match token {
		string {
			return token
		}
		else {
			return error("Expected token ${token} to be a string")
		}
	}
}

fn (mut ev Evaluator) t() !f64 {
	return ev.evaluate(ev.fe, ['/', '*'], ev.fe)
}

fn (mut ev Evaluator) fe() !f64 {
	return ev.evaluate(ev.f, ['^'], ev.f)
}

fn (mut ev Evaluator) f() !f64 {
	return ev.evaluate(ev.number, ['+', '-', '*', '/', '^'], ev.e)
}

fn (mut ev Evaluator) e() !f64 {
	return ev.evaluate(ev.t, ['+','-'], ev.e)!
}

fn (mut ev Evaluator) evaluate(a NumberFn, operations []string, b NumberFn) !f64 {
	number := a()!

	op := ev.operation() or { return number }

	if op in operations {
		return evaluate_op(number, op, b()!)
	}

	ev.buffer.goback()

	return number
}

fn evaluate_op(a f64, op string, b f64) !f64 {
	match op {
		'+' { return a + b }
		'-' { return a - b }
		'*' { return a * b }
		'/' { return a / b }
		'^' { return math.pow(a, b) }
		else { return error("Unknown operation: ${op}") }
	}
}

fn main() {
	mut evaluator := Evaluator{}

	for {
		input := read_line('Type the math expression: ')!

		number := evaluator.evaluate_expression(input)!

		println("Result: ${number}")
	}


}
