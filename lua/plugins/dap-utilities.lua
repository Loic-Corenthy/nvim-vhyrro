return {
    "mfussenegger/nvim-dap",
    -- "mfussenegger/nvim-dap-python",
    -- NOTE: And you can specify dependencies as well
    dependencies = {
        -- Creates a beautiful debugger UI
        "rcarriga/nvim-dap-ui",

        -- Required dependency for nvim-dap-ui
        "nvim-neotest/nvim-nio",

        -- Installs the debug adapters for you
        "mason-org/mason.nvim",
        "jay-babu/mason-nvim-dap.nvim",

        -- Add your own debuggers here
    },
    keys = {
        -- Basic debugging keymaps, feel free to change to your liking!
        {
            "<F5>",
            function()
                require("dap").continue()
            end,
            desc = "Debug: Start/Continue",
        },
        {
            "<F1>",
            function()
                require("dap").step_into()
            end,
            desc = "Debug: Step Into",
        },
        {
            "<F2>",
            function()
                require("dap").step_over()
            end,
            desc = "Debug: Step Over",
        },
        {
            "<F3>",
            function()
                require("dap").step_out()
            end,
            desc = "Debug: Step Out",
        },
        {
            "<leader>b",
            function()
                require("dap").toggle_breakpoint()
            end,
            desc = "Debug: Toggle Breakpoint",
        },
        {
            "<leader>B",
            function()
                require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
            end,
            desc = "Debug: Set Breakpoint",
        },
        -- Toggle to see last session result. Without this, you can"t see session output in case of unhandled exception.
        {
            "<F7>",
            function()
                require("dapui").toggle()
            end,
            desc = "Debug: See last session result.",
        },
        {
            "<F4>",
            function()
                require("dap").run_to_cursor()
            end,
            desc = "Debug: Run to cursor.",
        },
        {
            "<F9>",
            function()
                require("dap").up()
            end,
            desc = "Debug: Go up in the stack.",
        },
        {
            "<F10>",
            function()
                require("dap").down()
            end,
            desc = "Debug: Go down in the stack.",
        },
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        require("mason-nvim-dap").setup {
            -- Makes a best effort to setup the various debuggers with
            -- reasonable debug configurations
            automatic_installation = true,

            -- You can provide additional configuration to the handlers,
            -- see mason-nvim-dap README for more information
            handlers = {},

            -- You"ll need to check that you have the required things installed
            -- online, please don"t ask me how to install them :)
            ensure_installed = {
                -- Update this to ensure that you have the debuggers for the langs you want
                "codelldb",
            },
        }

        -- 2. Configure the Adapter (codelldb)
        -- This tells nvim-dap how to talk to the debugger
        dap.adapters.codelldb = {
            type = "server",
            port = "${port}",
            executable = {
                -- POINT THIS TO YOUR MASO INSTALL PATH
                -- usually: ~/.local/share/nvim/mason/bin/codelldb
                command = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin", "codelldb"),
                args = { "--port", "${port}" },
            },
        }

        -- 3. Configure the Launch Configurations
        -- This tells nvim-dap how to launch your specific C++ executable
        dap.configurations.cpp = {
            {
                name = "Launch file",
                type = "codelldb",
                request = "launch",
                program = function()
                    -- Ask for the executable path (defaults to current file name without extension)
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
            },
        }

        -- Reuse the C++ config for C and Rust
        dap.configurations.c = dap.configurations.cpp
        -- dap.configurations.rust = dap.configurations.cpp

        -- 4. Setup the UI
        dapui.setup()

        -- Auto-open/close the UI when debugging starts/ends
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        -- Dap UI setup
        -- For more information, see |:help nvim-dap-ui|

        -- Change breakpoint icons
        -- vim.api.nvim_set_hl(0, "DapBreak", { fg = "#e51400" })
        -- vim.api.nvim_set_hl(0, "DapStop", { fg = "#ffcc00" })
        -- local breakpoint_icons = vim.g.have_nerd_font
        --     and { Breakpoint = "", BreakpointCondition = "", BreakpointRejected = "", LogPoint = "", Stopped = "" }
        --   or { Breakpoint = "●", BreakpointCondition = "⊜", BreakpointRejected = "⊘", LogPoint = "◆", Stopped = "⭔" }
        -- for type, icon in pairs(breakpoint_icons) do
        --   local tp = "Dap" .. type
        --   local hl = (type == "Stopped") and "DapStop" or "DapBreak"
        --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
        -- end

        dap.listeners.after.event_initialized["dapui_config"] = dapui.open
        dap.listeners.before.event_terminated["dapui_config"] = dapui.close
        dap.listeners.before.event_exited["dapui_config"] = dapui.close
    end,
}

