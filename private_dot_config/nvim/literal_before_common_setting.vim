set mouse=
colorscheme PaperColorSlim
if !has('gui_running')
    hi Normal guibg=NONE ctermbg=NONE
endif

lua <<EOF
    local ELLIPSIS_CHAR = '…'
    local MAX_LABEL_WIDTH = 60
    local MIN_LABEL_WIDTH = 20

    local cmp = require('cmp')
    local editorconfig = require('editorconfig')

    -- config cmp
    cmp.setup({
        snippet = {
            expand = function(args)
                vim.fn["UltiSnips#Anon"](args.body)
            end,
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-e>'] = cmp.mapping.scroll_docs(3),
            ['<C-y>'] = cmp.mapping.scroll_docs(-3),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp', keyword_length = 3 },
            { name = 'ultisnips' },
            { name = 'nvim_lsp_signature_help' },
            { name = 'path', keyword_length = 3 },
            { name = 'buffer', keyword_length = 3 },
        }),
        formatting = {
            format = function(entry, vim_item)
                local label = vim_item.abbr
                local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
                if truncated_label ~= label then
                    vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
                elseif string.len(label) < MIN_LABEL_WIDTH then
                    local padding = string.rep(' ', MIN_LABEL_WIDTH - string.len(label))
                    vim_item.abbr = label .. padding
                end
                return vim_item
            end,
        },
    })

    -- create LspHelper
    vim.api.nvim_create_user_command(
        'LspHelper',
        function(info)
            local sub_command = info.fargs[1]
            if sub_command == 'GoToDefinition' then
                vim.lsp.buf.definition()
            elseif sub_command == 'GoToDeclaration' then
                vim.lsp.buf.declaration()
            elseif sub_command == 'GoToImplementation' then
                vim.lsp.buf.implementation()
            elseif sub_command == 'GoToReferences' then
                vim.lsp.buf.references()
            elseif sub_command == 'GoToType' then
                vim.lsp.buf.type_definition()
            elseif sub_command == 'GoTo' then
                vim.lsp.buf.definition()
            elseif sub_command == 'FixIt' then
                vim.lsp.buf.code_action()
            elseif sub_command == 'CallHierarchy' then
                vim.cmd.Telescope({ args = { 'hierarchy', 'incoming_calls' } })
            elseif sub_command == 'Rename' then
                vim.lsp.buf.rename(info.fargs[2])
            elseif sub_command == 'Toggle' then
                if vim.b.cmp_enabled == nil then
                    vim.b.cmp_enabled = true
                end
                if vim.b.cmp_enabled then
                    cmp.setup.buffer { enabled = false }
                    vim.b.cmp_enabled = false
                else
                    cmp.setup.buffer { enabled = true }
                    vim.b.cmp_enabled = true
                end
            elseif sub_command == 'Restart' then
                local bufnr = vim.api.nvim_get_current_buf()
                local clients = vim.lsp.get_clients({ bufnr = bufnr })
                local client_names = {}
                for i, client in ipairs(clients) do
                    client_names[i] = client.name
                end
                if #client_names > 0 then
                    vim.cmd.LspRestart(client_names)
                end
            elseif sub_command == 'Info' then
                vim.cmd('LspInfo')
            end
        end,
        {
            desc = 'Create LspHelper to unify my mappings both in vim and nvim',
            nargs = '+',
            complete = 'customlist,v:lua.vim.fn.LspHelperSubCommands',
        })

    -- config lsp format
    vim.api.nvim_create_user_command(
        'CustomizedAutoformat',
        function()
            if vim.b.format_supported then
                vim.lsp.buf.format({ async = false })
            else
                vim.cmd('Autoformat')
            end
        end,
        { desc = 'Call lsp format if it is supported' })

    local group = vim.api.nvim_create_augroup("my.lsp", { clear = true })
    -- set lsp capabilities
    vim.api.nvim_create_autocmd('LspAttach', {
        group = group,
        callback = function(args)
            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
            if client:supports_method('textDocument/formatting') then
                vim.b.format_supported = true
            end
        end
    })
    -- show diagnostic on hold
    vim.api.nvim_create_autocmd('CursorHold', {
        group = group,
        pattern = "*",
        callback = function(args)
            -- check if there is any floating window
            for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
                if vim.api.nvim_win_get_config(winid).zindex then
                    return
                end
            end
            vim.diagnostic.open_float(0, {
                scope = "cursor",
                focusable = false,
                close_events = {
                    "CursorMoved",
                    "CursorMovedI",
                    "BufHidden",
                    "InsertCharPre",
                    "WinLeave",
                },
            })
        end
    })

    editorconfig.properties.lsp_clients_with_opts = function(bufnr, val, opts)
        if not val then
            return
        end
        local lsp_clients_with_opts = vim.json.decode(val)
        for lsp_client, opts in pairs(lsp_clients_with_opts) do
            local enabled = (opts.enabled == nil) or opts.enabled
            if not enabled then
                goto continue
            end
            local nvim_opts = opts.nvim
            if nvim_opts == nil then
                nvim_opts = opts.default
            end
            if nvim_opts then
                vim.lsp.config(lsp_client, nvim_opts)
            end
            local clients = vim.lsp.get_clients({ name = lsp_client })
            if #clients == 0 then
                vim.lsp.enable(lsp_client)
                -- trigger a event to start client
                vim.cmd.doautocmd('nvim.lsp.enable FileType')
            end
            ::continue::
        end
    end
EOF

" neovim terminal uses vim mapping {{{
tnoremap <C-W>N <C-\><C-N>
tnoremap <C-W>h <C-\><C-N><C-W>h
tnoremap <C-W>j <C-\><C-N><C-W>j
tnoremap <C-W>k <C-\><C-N><C-W>k
tnoremap <C-W>l <C-\><C-N><C-W>l
tnoremap <C-W>H <C-\><C-N><C-W>H
tnoremap <C-W>J <C-\><C-N><C-W>J
tnoremap <C-W>K <C-\><C-N><C-W>K
tnoremap <C-W>L <C-\><C-N><C-W>L
" }}}
