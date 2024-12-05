package main

import "core:os"
import "core:fmt"
import "core:strconv"
import "core:sys/windows"
import "core:strings"
import "core:time"

Solution :: proc(input: string) -> (p1, p2: int)
solutions := []Solution{
    1 = day1,
    2 = day2,
    3 = day3,
    4 = day4,
    5 = day5
}

main :: proc() {
    arguments := os.args[1:]
    fmt.println(arguments)
    runs := 1000

    if len(arguments) == 0 {
        fmt.println("Please enter a day")
        os.exit(1)
    }

    day, ok := strconv.parse_int(arguments[0])
    if !ok {
        fmt.println(day, "is not valid")
        os.exit(1)
    }

    if len(arguments) > 1 {
        r, ok := strconv.parse_int(arguments[1])
        if !ok {
            fmt.println("Invalid number of runs")
            os.exit(1)
        }
        runs = r
    }

    sb := strings.builder_make()
    strings.write_string(&sb, "day")
    strings.write_int(&sb, day)
    strings.write_string(&sb, ".txt")

    f, success := os.read_entire_file(strings.to_string(sb))
    if !success {
        fmt.println("Error!")
        os.exit(1)
    }
    input := string(f)

    average: f64 = 0
    mintime: f64 = 99999999
    maxtime: f64 = 0
    p1, p2 := 0, 0
    for i in 0..<runs {
        stopwatch: time.Stopwatch
        time.stopwatch_start(&stopwatch)
        p1, p2 = solutions[day](input)
        time.stopwatch_stop(&stopwatch)
        duration := time.stopwatch_duration(stopwatch)
        ms := time.duration_milliseconds(duration)

        average += ms / f64(runs)
        maxtime = max(maxtime, ms)
        mintime = min(mintime, ms)
    }

    fmt.println("Advent of Code 2024 day 5")
    fmt.println("----------------------------------")
    fmt.printfln("Timings for %i runs (ms)", runs)
    fmt.printfln("  Avg: %3f", average)
    fmt.printfln("  Min: %3f", mintime)
    fmt.printfln("  Max: %3f", maxtime)
    fmt.println("----------------------------------")
    fmt.println("Solutions")
    fmt.println("  Part 1:", p1)
    fmt.println("  Part 2:", p2)
}