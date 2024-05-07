module SingletonExample

struct AppKey
    appid::String
    value::UInt128
end

const appkey = Ref{AppKey}()
const appkey_lock = Ref(ReentrantLock())

function init()
    global appkey
    global appkey_lock

    lock(appkey_lock[])
    try
        if !isassigned(appkey)
            ak = AppKey("myapp", rand(UInt128))
            println("initializing $ak")
            appkey[] = ak
        else
            println("skipped initialization")
        end
    finally
        unlock(appkey_lock[])
    end

    appkey[]
end

end
