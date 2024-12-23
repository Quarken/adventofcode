package main

import "core:fmt"
import "core:strings"
import "core:strconv"

Opcode :: enum {
	Adv = 0,
	Bxl = 1,
	Bst = 2,
	Jnz = 3,
	Bxc = 4,
	Out = 5,
	Bdv = 6,
	Cdv = 7
}

Computer :: struct {
	a: uint,
	b: uint,
	c: uint
}

execute_program :: proc(program: []uint, output: ^[dynamic]uint, computer: Computer) {
	computer := computer

	for i := 0; i < len(program); i += 2 {
		opcode := Opcode(program[i])
		operand := program[i+1]
		combo: uint = 0
		switch operand {
			case 0..=3: combo = operand
			case 4: combo = computer.a
			case 5: combo = computer.b
			case 6: combo = computer.c
		}

		switch opcode {
			case .Adv: {
				computer.a = computer.a >> combo
			}

			case .Bdv: {
				computer.b = computer.a >> combo
			}

			case .Cdv: {
				computer.c = computer.a >> combo
			}

			case .Bxl: {
				computer.b = computer.b ~ operand
			}

			case .Bxc: {
				computer.b = computer.b ~ computer.c
			}

			case .Bst: {
				computer.b = combo & 7
			}

			case .Jnz: {
				if computer.a != 0 {
					i = int(operand) - 2
				}
			}

			case .Out: {
				append(output, combo & 7)
			}
		}
	}
}

equiv :: proc(a, b: []uint) -> bool {
	if len(a) != len(b) do return false
	for i in 0..<len(a) {
		if a[i] != b[i] do return false
	}
	return true
}

day17 :: proc(input: string) -> (Answer, Answer) {
	lines := strings.split_lines(input)
	reg_a, _ := strconv.parse_int(lines[0][12:])
	reg_b, _ := strconv.parse_int(lines[1][12:])
	reg_c, _ := strconv.parse_int(lines[2][12:])

	computer := Computer{uint(reg_a), uint(reg_b), uint(reg_c)}
	program: [dynamic]uint

	for char in lines[4] {
		if char >= '0' && char <= '9' {
			append(&program, uint(char - '0'))
		}
	}

	p1_output: [dynamic]uint
	execute_program(program[:], &p1_output, computer)

	s := [dynamic]uint{0}

	for p in 0..<len(program) {
		t := [dynamic]uint{}
		goal := program[len(program)-p-1:]
		for base in s {
			for i in 0..<8 {
				new_a: uint = (base << 3) + uint(i)
				test: [dynamic]uint
				execute_program(program[:], &test, Computer{new_a, 0, 0})
				if equiv(test[:], goal) {
					append(&t, new_a)
				}
			}
		}
		s = t
	}

	mini := s[0]
	for i in 1..<len(s) {
		if s[i] < mini {
			mini = s[i]
		}
	}

	return p1_output[:], int(mini)
}