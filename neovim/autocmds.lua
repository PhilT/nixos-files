local group = vim.api.nvim_create_augroup('mygroup', { clear = true })          -- Adding this group to the below mappings causes them not to work
local autocmd = vim.api.nvim_create_autocmd

-- Show a vertical bar signifying the end of the line (80 cols) for all files (but not quickfix and other buffers)
autocmd('Filetype', { pattern = 'ruby,fsharp,lua,markdown,c,cpp,cs', callback = function(args) vim.opt.colorcolumn = '81,82' end })
--autocmd('Filetype', { pattern = 'fugitive,qf', callback = function(args) vim.opt.colorcolumn = '' end })

local options = { pattern = '*.vert,*.task,*.mesh,*.frag', command='set ft=glsl' }
autocmd('BufNewFile', options )
autocmd('BufRead', options )