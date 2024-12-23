package main

import "core:strings"

parse_numeric :: proc(s: string) -> (int, int) {
    res, i: int
    for i = 0; s[i] >= '0' && s[i] <= '9'; i += 1 {
        res = 10 * res + int(s[i] - '0')
    }
    return res, i
}

day3 :: proc(input: string) -> (Answer, Answer) {
    p1, p2: int

    flag := true
    for index := 0; index < len(input); index += 1 {
        if input[index] == 'd' {
            if strings.has_prefix(input[index:], "do()") { flag = true; continue }
            if strings.has_prefix(input[index:], "don't()") { flag = false; continue }
        } else {
            if input[index] != 'm' do continue
            if !strings.has_prefix(input[index:], "mul(") { continue }

            first := input[index+4:]
            a, i := parse_numeric(first)
            if first[i] == ',' {
                second := first[i+1:]
                b, j := parse_numeric(second)
                if second[j] == ')' {
                    p1 += a * b
                    p2 += flag ? a * b : 0
                }
            }
        }
    }

    return p1, p2
}
