package main

import "core:strings"
import "core:strconv"
import "core:slice"

concat :: proc(a, b: int) -> int {
	pow: int = 10
	for b >= pow {
		pow *= 10
	}
	return a * pow + b
}

recurse_operand :: proc(test: int, operand: int, operands: []int, results: ^[dynamic]int, do_concat: bool) {
	if operand > test {
		return
	}

	if len(operands) == 0 {
		append(results, operand)
		return
	}

	mul := operand * operands[0]
	add := operand + operands[0]
	cat := concat(operand, operands[0])
	recurse_operand(test, mul, operands[1:], results, do_concat)
	recurse_operand(test, add, operands[1:], results, do_concat)
	if do_concat {
		recurse_operand(test, cat, operands[1:], results, do_concat)
	}
}

day7 :: proc(input: string) -> (Answer, Answer) {
	p1, p2: int
	equations := strings.split_lines(input)

	for equation in equations {
		parts := strings.split(equation, " ")
		values := make([]int, len(parts))
		for p, i in parts {
			num, _ := strconv.parse_int(p)
			values[i] = num
		}

		test_value := values[0]
		operands := values[1:]

		p1_results: [dynamic]int
		recurse_operand(test_value, operands[0], operands[1:], &p1_results, false)
		if slice.contains(p1_results[:], test_value) {
			p1 += test_value
		}

		results_p2: [dynamic]int
		recurse_operand(test_value, operands[0], operands[1:], &results_p2, true)
		if slice.contains(results_p2[:], test_value) {
			p2 += test_value
		}
	}

	return p1, p2
}
