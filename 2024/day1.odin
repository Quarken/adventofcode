package main

import "core:strings"
import "core:strconv"
import "core:slice"

day1 :: proc(text: string) -> (Answer, Answer) {
    lines := strings.split_lines(text)

    col1: [dynamic]int
    col2: [dynamic]int
    similar := map[int]int{}

    for line in lines {
        num1, _ := strconv.parse_int(line[0:5])
        num2, _ := strconv.parse_int(line[8:13])

        append(&col1, num1)
        append(&col2, num2)

        similar[num2] += 1
    }

    slice.sort(col1[:])
    slice.sort(col2[:])

    p1, p2: int
    for i in 0..<len(col1) {
        num1 := col1[i]
        p1 += abs(col2[i] - col1[i])
        p2 += num1 * similar[num1]
    }

    return p1, p2
}
