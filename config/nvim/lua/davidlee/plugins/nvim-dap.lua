return {
    "mfussenegger/nvim-dap",
    dependencies = {
        -- opcional, mas ajuda a instalar/adaptar o codelldb
        "williamboman/mason.nvim",
        "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
        local dap = require("dap")

        -- mason-nvim-dap: instala/adapta o codelldb automaticamente
        pcall(function()
            require("mason-nvim-dap").setup({
                ensure_installed = { "codelldb" },
                automatic_installation = true,
                handlers = {},
            })
        end)

        -- Detecta caminhos do codelldb instalado pelo Mason (macOS/Apple Silicon ok)
        local codelldb_path
        local ok, mason_registry = pcall(require, "mason-registry")

        if ok then
            -- Usa pcall para evitar erros ao buscar o pacote
            local has_package, pkg = pcall(mason_registry.get_package, "codelldb")

            if has_package and pkg and pkg:is_installed() then
                local install_path

                -- Tenta diferentes métodos para obter o caminho de instalação
                -- compatível com diferentes versões do Mason
                if type(pkg.get_install_path) == "function" then
                    -- Método para versões mais antigas do Mason
                    local success, path = pcall(pkg.get_install_path, pkg)
                    if success then
                        install_path = path
                    end
                elseif type(pkg.get_install_path) == "string" then
                    -- Algumas versões retornam como propriedade string
                    install_path = pkg.get_install_path
                elseif pkg.install_path then
                    -- Versões mais novas podem ter install_path como propriedade
                    install_path = pkg.install_path
                end

                -- Se não conseguiu o caminho pelos métodos acima, tenta o caminho padrão
                if not install_path then
                    local mason_path = vim.fn.stdpath("data") .. "/mason"
                    install_path = mason_path .. "/packages/codelldb"
                end

                -- Procura o executável do codelldb em diferentes locais possíveis
                if install_path then
                    local candidates = {
                        install_path .. "/extension/adapter/codelldb",
                        install_path .. "/adapter/codelldb",
                        install_path .. "/codelldb",
                        install_path .. "/bin/codelldb",
                    }

                    for _, candidate in ipairs(candidates) do
                        -- Compatibilidade com vim.loop (antigo) e vim.uv (novo)
                        local fs_stat = vim.loop and vim.loop.fs_stat or vim.uv and vim.uv.fs_stat
                        if fs_stat and fs_stat(candidate) then
                            codelldb_path = candidate
                            break
                        end
                    end
                end
            end
        end

        -- fallback para binário no PATH
        if not codelldb_path then
            codelldb_path = "codelldb"
            -- Opcional: notifica que está usando fallback
            -- vim.notify("CodeLLDB: usando fallback 'codelldb' do PATH", vim.log.levels.WARN)
        end

        -- Adapter do codelldb (porta dinâmica)
        dap.adapters.codelldb = function(callback, _)
            local port = 13000 + math.random(0, 1000)
            callback({
                type = "server",
                host = "127.0.0.1",
                port = port,
                executable = {
                    command = codelldb_path,
                    args = { "--port", tostring(port) },
                    detached = false,
                },
            })
        end

        -- Configurações de launch genéricas para C/C++/Rust/Swift (pede o binário)
        local launch_cfg = {
            {
                name = "Codelldb: Launch executable",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                args = {},
                -- env = { "RUST_LOG=info" }, -- exemplo
            },
        }

        dap.configurations.c = launch_cfg
        dap.configurations.cpp = launch_cfg
        dap.configurations.rust = launch_cfg
        dap.configurations.swift = launch_cfg

        -- Keymaps básicos (sem UI)
        local map = vim.keymap.set
        map("n", "<F5>", dap.continue, { desc = "DAP Continue" })
        map("n", "<F10>", dap.step_over, { desc = "DAP Step Over" })
        map("n", "<F11>", dap.step_into, { desc = "DAP Step Into" })
        map("n", "<F12>", dap.step_out, { desc = "DAP Step Out" })
        map("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP Toggle Breakpoint" })
        map("n", "<leader>dB", function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end, { desc = "DAP Conditional Breakpoint" })
        map("n", "<leader>dr", dap.repl.toggle, { desc = "DAP REPL" })
        map("n", "<leader>dl", dap.run_last, { desc = "DAP Run Last" })
    end,
}
