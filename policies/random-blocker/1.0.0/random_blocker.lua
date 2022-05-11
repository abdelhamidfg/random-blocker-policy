local policy = require('apicast.policy')
local _M = policy.new('random_blocker', '1.0.0')
local default_error_message = "Request blocked due to random blocker policy"
local new = _M.new

function _M.new(config)
    local self = new(config)
    self.error_message = config.error_message or default_error_message
    return self
end

 

local function deny_request(error_msg)
    ngx.status = ngx.HTTP_FORBIDDEN
    ngx.say(error_msg)
    ngx.exit(ngx.status)
end



function _M:access(context)
    local is_authorized = false
    local random = math.random(1,1000)
    ngx.log(ngx.WARN, "random number=", random)
    if (random % 2 == 0) then
        is_authorized=true
    end      
    if not is_authorized then
        return deny_request(self.error_message)
    end
end

return _M
