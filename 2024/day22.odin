package main

import "core:fmt"
import "core:strings"
import "core:strconv"

day22 :: proc(input: string) -> (Answer, Answer) {
	p1, p2: int
	lines := strings.split_lines(input)
	seqs: map[int]int
	for line, index in lines {
		prices: [2000]int
		changes: [2000]int
		seen: map[int]bool
		secret, _ := strconv.parse_int(line)

		prev := secret % 10
		for i in 0..<2000 {
			secret ~= secret << 6
			secret &= 0xFFFFFF
			secret ~= secret >> 5
			secret &= 0xFFFFFF
			secret ~= secret << 11
			secret &= 0xFFFFFF

			prices[i] = secret % 10
			changes[i] = prices[i] - prev
			prev = prices[i]
		}
		p1 += secret

		for i in 0..<1997 {
			hash := 
				23 * changes[i+0] +
				41 * changes[i+1] +
				67 * changes[i+2] +
				89 * changes[i+3]

			if !(hash in seen) {
				seen[hash] = true
				seqs[hash] += prices[i+3]
			}
		}
	}

	for _, price in seqs {
		p2 = max(p2, price)
	}

	return p1, p2
}