package main

import "core:os"
import "core:fmt"
import "core:strconv"
import "core:sys/windows"
import "core:strings"
import "core:time"

Answer :: union #no_nil {int, string, Vec2, []uint}

Solution :: proc(input: string) -> (Answer, Answer)

Timings :: struct { avg, max, min: f64 }

no_solution :: proc(input: string) -> (Answer, Answer) { return 0, 0 }

solutions := [?]Solution{
    1 = day1,
    2 = day2,
    3 = day3,
    4 = day4,
    5 = day5,
    6 = day6,
    7 = day7,
    8 = day8,
    9 = day9,
    10 = day10,
    11 = day11,
    12 = day12,
    13 = day13,
    14 = day14,
    15 = day15,
    16 = day16,
    17 = day17,
    18 = day18,
    19 = day19,
    20 = day20,
    21 = no_solution,
    22 = day22
}

solruns := map[int]int{
    6 = 10,
    7 = 10,
    9 = 10,
    11 = 10,
    14 = 10,
    16 = 10,
    18 = 100,
    19 = 100,
    20 = 1
}

cached_inputs := [len(solutions)]string{}

run_timed :: proc(day, runs: int) -> (Timings, Answer, Answer) {
    if cached_inputs[day] == "" {
        sb := strings.builder_make()
        strings.write_string(&sb, "day")
        strings.write_int(&sb, day)
        strings.write_string(&sb, ".txt")

        f, success := os.read_entire_file(strings.to_string(sb))
        if !success {
            fmt.printfln("Error! input file day%i.txt not found", day)
            os.exit(1)
        }
        file_contents := string(f)
        cleaned_contents, _ := strings.replace(file_contents, "\r\n", "\n", -1)

        cached_inputs[day] = cleaned_contents
    }

    input := cached_inputs[day]

    average: f64 = 0
    mintime: f64 = 99999999
    maxtime: f64 = 0
    p1, p2: Answer
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

    return Timings{average, mintime, maxtime}, p1, p2
}

aprint_answer :: proc(answer: Answer) -> string {
    #partial switch ans in answer {
        case []uint: {
            sb := strings.builder_make()
            for i in 0..<(len(ans)-1) {
                fmt.sbprintf(&sb, "%i,", ans[i])
            }
            fmt.sbprint(&sb, ans[len(ans)-1])
            return strings.to_string(sb)
        }

        case Vec2: {
            return fmt.aprintf("%i,%i", ans.x, ans.y)
        }

        case: return fmt.aprint(ans)
    }
}

print_one_day :: proc(day, runs: int, timings: Timings, p1, p2: Answer) {
    fmt.println("Advent of Code 2024 day", day)
    fmt.println("----------------------------------")
    fmt.printfln("Timings for %i runs (ms)", runs)
    fmt.printfln("  Avg: %3f", timings.avg)
    fmt.printfln("  Min: %3f", timings.min)
    fmt.printfln("  Max: %3f", timings.max)
    fmt.println("----------------------------------")
    fmt.println("Solutions")
    fmt.println("  Part 1:", aprint_answer(p1))
    fmt.println("  Part 2:", aprint_answer(p2))
}

print_help :: proc() {
    fmt.println("Advent of Code 2024")
    fmt.println("Usage:")
    fmt.printfln("\t%s command [runs]", os.args[0])
    fmt.println("Commands:")
    fmt.println("\trun-all  Runs all days")
    fmt.println("\t(day)    Runs a specific day with index (day)")
}

main :: proc() {
    arguments := os.args[1:]
    run_all := false
    max_runs := 1000

    if len(arguments) == 0 {
        print_help()
        os.exit(1)
    }

    if len(arguments) > 1 {
        r, ok := strconv.parse_int(arguments[1])
        if !ok {
            fmt.println("Invalid number of runs")
            os.exit(1)
        }
        max_runs = r
    }

    switch arguments[0] {
        case "help": {
            print_help()
        }

        case "run-all": {
            sep := strings.repeat("-", 93)
            fmt.println(sep)
            fmt.printfln("| Day | %20s | %20s | Avg (ms) | Min (ms) | Max (ms) | Runs |", "Part 1 Answer", "Part 2 Answer")
            fmt.println(sep)
            for day in 1..<len(solutions) {
                runs := max_runs
                if day in solruns {
                    runs = min(runs, solruns[day])
                }

                timings, p1, p2 := run_timed(day, runs)
                fmt.printfln(
                    "|  %2v | %20s | %20s | % 8.3v | % 8.3v | % 8.3v | % 4v |",
                    day,
                    aprint_answer(p1),
                    aprint_answer(p2),
                    timings.avg,
                    timings.max,
                    timings.min,
                    runs
                )
            }
            fmt.println(sep)
        }

        case: {
            day, ok := strconv.parse_int(arguments[0])
            if !ok {
                print_help()
                os.exit(1)
            }

            runs := max_runs
            if day in solruns {
                runs = min(runs, solruns[day])
            }
            timings, p1, p2 := run_timed(day, runs)
            print_one_day(day, runs, timings, p1, p2)
        }
    }
}