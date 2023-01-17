_G.nik = {}

function nik.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

function nik.system_open(path)
  path = path or vim.fn.expand "<cfile>"
  if vim.fn.has "mac" == 1 then
    vim.fn.jobstart({ "open", path }, { detach = true })
  elseif vim.fn.has "unix" == 1 then
    vim.fn.jobstart({ "xdg-open", path }, { detach = true })
  else
    print("System open is not supported on this OS!")
  end
end

return nik
