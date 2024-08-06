print('^4 [kmack_lib] ^2Loaded XP System^7')
local xpConfig = require 'modules.shared.xpSystem'
local Config = require 'config'



































--- Create sql table if not already made.
MySQL.query('CREATE TABLE IF NOT EXISTS kmack_xp (pid VARCHAR(250), data LONGTEXT)')
