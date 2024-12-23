package main

import "core:strings"
import "core:strconv"

day5 :: proc(input: string) -> (Answer, Answer) {
    p1, p2: int
    rules: [100][100]bool // rule[x][y] == true implies X|Y
    lines := strings.split_lines(input)

    is_rule := true
    for line in lines {
        if line == "" {
            is_rule = false
            continue
    }

        if is_rule {
            num1, _ := strconv.parse_int(line[0:2])
            num2, _ := strconv.parse_int(line[3:5])
            rules[num1][num2] = true
        } else {
            num_strs := strings.split(line, ",")
            nums: [dynamic]int
            for str in num_strs {
                n, _ := strconv.parse_int(str)
                append(&nums, n)
            }


            valid := true
            seen: [dynamic]int
            loop: for n in nums {
                append(&seen, n)
                for s in seen {
                    if rules[n][s] {
                        valid = false
                        break loop
                    }
                }
            }


            if valid {
                mid := nums[len(nums)/2]
                p1 += mid
            } else {
                sorted: [dynamic]int
                for next in nums {
                    i := 0
                    for i < len(sorted) {
                        if rules[sorted[i]][next] {
                            break
                        }
                        i += 1
                    }
                    inject_at(&sorted, i, next)
                }
                mid := sorted[len(sorted)/2]
                p2 += mid
            }
        }
    }


    return p1, p2
}
