-- Load the config before package manager
require("config.before")
-- Load the package manager and other packages
require("config.lazy")
-- Load other misc configurations
require("config.after")
