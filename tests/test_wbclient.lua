client_async = require "websocket.client_async"

connected=false
function init(self)
 self.ws = client_async({
  connect_timeout = 5, -- optional timeout (in seconds) when connecting
 })

 self.ws:on_connected(function(ok, err)
  if ok then
   print("Connected")
   connected = true
  else
   print("Unable to connect", err, msg)
  end
 end)

 self.ws:on_disconnected(function()
  print("Disconnected")
 end)

 self.ws:on_message(function(message)
  print("Received message", message)
 end)

 local sslparams = {
  mode = "client",
  protocol = "tlsv1_2",
  verify = "none",
  options = "all",
 }
 self.ws:connect("wss://echo.websocket.org", "wss", sslparams)
 --self.ws:connect("ws://121.40.165.18:8800")
end

function update(self, dt)
 self.ws:step()
end



copas=require'copas'

copas.addthread(function()
 ctx={}
 init(ctx)

 cnt=0
 while true do 
  update(ctx)
  cnt=cnt+1
  if cnt==1 then
   if connected then
    print('send')
    ctx.ws:send('test')
   end
  end
  if cnt>200000 then
   cnt=0
  end
 end

end)

