package main

import "core:fmt"
import "core:strings"
import "core:strconv"

Pair :: struct {
	stone: int,
	state: int
}

magnitude :: proc(a: int) -> (res: int) {
	pow: int = 1
	for a >= pow {
		pow *= 10
		res += 1
	}
	return
}

split :: proc(num, by: int) -> (left, right: int) {
	pow: int = 10
	for i in 0..<(by-1) {
		pow *= 10
	}
	left = num / pow
	right = num % pow
	return
}

blink :: proc(stone, state, stop: int, cache: ^map[Pair]int) -> int {
	p := Pair{stone, state}
	if cache[p] != 0 {
		return cache[p]
	}

	if state == stop {
		cache[p] = 1
		return 1
	}

	if stone == 0 {
		blinks := blink(1, state+1, stop, cache)
		cache[p] = blinks
		return blinks
	}

	mag := magnitude(stone)
	if mag % 2 == 0 {
		left, right := split(stone, mag/2)
		blinks_left := blink(left, state+1, stop, cache)
		blinks_right := blink(right, state+1, stop, cache)
		cache[p] = blinks_left + blinks_right
		return blinks_left + blinks_right
	}

	blinks := blink(stone * 2024, state+1, stop, cache)
	cache[p] = blinks
	return blinks
}

day11 :: proc(input: string) -> (Answer, Answer) {
	p1, p2: int
	stones := strings.split(input, " ")

	cache_p1 := map[Pair]int{}
	cache_p2 := map[Pair]int{}
	for str in stones {
		stone, _ := strconv.parse_int(str)
		p1 += blink(stone, 0, 25, &cache_p1)
		p2 += blink(stone, 0, 75, &cache_p2)
	}

	return p1, p2
}