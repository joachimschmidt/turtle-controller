json = require "json"
local ws, err = http.websocket("ws://192.168.1.37:5757")
if err then
    print(err)

else
    if ws then
        print("CONNECTED")
        while (true) do
            local message = ws.receive()
            local obj = json.decode(message)
            if obj.type == 'eval' then
                local f = loadstring(obj['fun'])
                local result = f()
                ws.send(json.encode({data=result, nonce=obj['nonce']}))

            end
        end
        ws.close()
    end
end



function undergoMitosis()
    turtle.select(getItemIndex("computercraft:peripheral"))
    if not turtle.place() then
        return nil
    end
    turtle.select(getItemIndex("computercraft:disk_expanded"))
    turtle.drop()
    if not turtle.up() then
        return nil
    end
    turtle.select(getItemIndex("computercraft:turtle_expanded"))
    if not turtle.place() then
        return nil
    end
    peripheral.call("front", "turnOn")
    turtle.select(1)
    turtle.drop(math.floor(turtle.getItemCount() / 2))
    os.sleep(1)
    peripheral.call("front", "reboot")
    local cloneId = peripheral.call("front", "getID")
    if not turtle.down() then
        return nil
    end
    if not turtle.suck() then
        return nil
    end
    if not turtle.dig() then
        return nil
    end
    return cloneId
end