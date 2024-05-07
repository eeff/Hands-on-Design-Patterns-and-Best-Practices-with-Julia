using Dates

const INFO = 1
const WARN = 2
const ERROR = 3

struct Logger
    filename::AbstractString
    level::Int8
    handle
end

Logger(filename, level) = Logger(filename, level, open(filename, "w"))

for sym in (:info, :warn, :error)
    fn = Symbol(sym, "!")
    level = Symbol(uppercase(String(sym)))
    label = " [$level]"

    @eval function $fn(logger::Logger, args...)
        if logger.level <= $level
            let io = logger.handle
                print(io, trunc(now(), Dates.Second), $label)
                for arg in args
                    print(io, " ", arg)
                end
                println(io)
                flush(io)
            end
        end
    end
end

info_log_file = "/tmp/info.log"
info_logger = Logger(info_log_file, INFO)
info!(info_logger, "hello", 123)
warn!(info_logger, "hello", 456)
error!(info_logger, "hello", 789)
println("info log file contents:")
for line in readlines(info_log_file)
    println(line)
end

warn_log_file = "/tmp/warn.log"
warn_logger = Logger(warn_log_file, WARN)
info!(warn_logger, "hello", 123)
warn!(warn_logger, "hello", 456)
error!(warn_logger, "hello", 789)
println()
println("warn log file contents:")
for line in readlines(warn_log_file)
    println(line)
end

error_log_file = "/tmp/error.log"
error_logger = Logger(error_log_file, ERROR)
info!(error_logger, "hello", 123)
warn!(error_logger, "hello", 456)
error!(error_logger, "hello", 789)
println()
println("error log file contents:")
for line in readlines(error_log_file)
    println(line)
end
