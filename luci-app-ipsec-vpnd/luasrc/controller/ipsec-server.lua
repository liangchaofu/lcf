module("luci.controller.ipsec-server", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/ipsec") then
		return
	end
	
	entry({"admin", "services"}, firstchild(), "IPSec VPN Server", 45).dependent = false
	entry({"admin", "services", "ipsec-server"}, cbi("ipsec-server"), _("IPSec VPN Server"), 80).dependent = false
	entry({"admin", "services", "ipsec-server", "status"}, call("act_status")).leaf = true
end

function act_status()
	local e = {}
	e.running = luci.sys.call("pgrep ipsec >/dev/null") == 0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end
