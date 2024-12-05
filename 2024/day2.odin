package main

import "core:strings"
import "core:strconv"
import "core:slice"

is_safe :: proc(levels: [dynamic]int) -> bool {
    increasing := levels[1] - levels[0]
    for i in 1..<len(levels) {
        delta := levels[i] - levels[i-1]
        if abs(delta) < 1 || abs(delta) > 3 {
            return false
        }

        if (increasing * delta) < 0 {
            return false
        }
    }
    return true
}

day2 :: proc(text: string) -> (int, int) {
    p1 := 0
    p2 := 0

    lines := strings.split_lines(text)

    levels: [dynamic]int
    for line in lines {
        parts := strings.split(line, " ")
        for part in parts {
            num, _ := strconv.parse_int(part)
            append(&levels, num)
        }

        if is_safe(levels) {
            p1 += 1
            p2 += 1
        } else {
            for x in 0..<len(levels) {
                dampenedLevels: [dynamic]int
                defer delete(dampenedLevels)

                resize(&dampenedLevels, len(levels))
                copy(dampenedLevels[:], levels[:])
                ordered_remove(&dampenedLevels, x)

                if is_safe(dampenedLevels) {
                    p2 += 1
                    break
                }
            }
        }
        clear(&levels)
    }

    return p1, p2
}
