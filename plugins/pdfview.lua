-- mod-version:2 -- lite-xl 2.0
local core = require "core"
local config = require "core.config"
local command = require "core.command"
local keymap = require "core.keymap"

-- This plugin

command.add("core.docview", {
  ["pdfview:show-preview"] = function()
    -- The current (La)TeX and PDF files, the PDF viewer command
    local texfile = core.active_view:get_name()
    local pdffile = core.active_view:get_filename()
    local viewcmd = config.pdfview and config.pdfview.view_command

    if viewcmd ~= nil then
    -- Use default PDF viewer on Windows
    elseif PLATFORM == "Windows" then
      viewcmd = "start"
    -- Use default PDF viewer on Macos
    elseif PLATFORM == "" then
      viewcmd = "open"
    -- Use default PDF viewer on Linux
    else
      viewcmd = "xdg-open"
    end

    -- Screen the full PDF filename in case there are spaces in the path
    pdffile = "\"" .. pdffile:gsub("%.tex$", ".pdf") .. "\""

    -- Windows does not understand/expand the ~ from the get_filename call
    if PLATFORM == "Windows" then
      pdffile = pdffile:gsub("~", os.getenv("USERPROFILE"))
    end

    -- Open PDF viewer
    core.log("Opening PDF preview for %s", texfile)
    system.exec(viewcmd .. " " .. pdffile)

  end
})


keymap.add { ["ctrl+shift+v"] = "pdfview:show-preview" }
