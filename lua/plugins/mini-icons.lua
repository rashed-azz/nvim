-- lazy-style spec
return {
    {
  "echasnovski/mini.icons",
  version = false,         -- always latest
  event = "VeryLazy",
  config = function()
    require("mini.icons").setup()  -- accepts options; defaults are fine
  end,
},
}

