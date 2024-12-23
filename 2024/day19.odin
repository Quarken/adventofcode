package main

import "core:fmt"
import "core:strings"
import "core:slice"

recurse_towel_arrangements :: proc(left: string, towels: []string, cache: ^map[string]int) -> int {
	if len(left) == 0 {
		return 1
	}

	if left in cache {
		return cache[left]
	}

	total := 0
	for towel in towels {
		if strings.has_prefix(left, towel) {
			total += recurse_towel_arrangements(left[len(towel):], towels, cache)
		}
	}

	cache[left] = total
	return total
}

day19 :: proc(input: string) -> (Answer, Answer) {
	p1, p2: int

	lines := strings.split_lines(input)
	towels := strings.split(lines[0], ", ")

	cache: map[string]int
	for line in lines[2:] {
		total_arrangements := recurse_towel_arrangements(line, towels, &cache)
		p1 += total_arrangements > 0 ? 1 : 0
		p2 += total_arrangements
	}

	return p1, p2
}