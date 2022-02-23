-- Copyright 2018-2019 Lienol <lawlienol@gmail.com>
module("luci.controller.ipsec-server", package.seeall)

function index()
    if not nixio.fs.access("/etc/config/ipsec") then return end

    entry({"admin", "services", "ipsec-server"},
          alias("admin", "services", "ipsec-server", "settings"),
          _("IPSec VPN 服务器"), 49).dependent = false
    entry({"admin", "services", "ipsec-server", "settings"},
          cbi("ipsec-server/settings"), _("General Settings"), 10).leaf = true
    entry({"admin", "services", "ipsec-server", "users"}, cbi("ipsec-server/users"),
          _("用户管理"), 20).leaf = true
    entry({"admin", "services", "ipsec-server", "status"}, call("status")).leaf =
        true
end

function status()
    local e = {}
    e.status = luci.sys.call("/usr/bin/pgrep ipsec > /dev/null") == 0
    luci.http.prepare_content("application/json")
    luci.http.write_json(e)
end
