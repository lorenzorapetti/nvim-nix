local M = {}

--- Appends `new_names` to `root_files` if `field` is found in any such file in any ancestor of `fname`.
---
--- NOTE: this does a "breadth-first" search, so is broken for multi-project workspaces:
--- https://github.com/neovim/nvim-lspconfig/issues/3818#issuecomment-2848836794
---
--- @param root_files string[] List of root-marker files to append to.
--- @param new_names string[] Potential root-marker filenames (e.g. `{ 'package.json', 'package.json5' }`) to inspect for the given `field`.
--- @param field string Field to search for in the given `new_names` files.
--- @param fname string Full path of the current buffer name to start searching upwards from.
function M.root_markers_with_field(root_files, new_names, field, fname)
  local path = vim.fn.fnamemodify(fname, ':h')
  local found = vim.fs.find(new_names, { path = path, upward = true, type = 'file' })

  for _, f in ipairs(found or {}) do
    -- Match the given `field`.
    local file = assert(io.open(f, 'r'))
    for line in file:lines() do
      if line:find(field) then
        root_files[#root_files + 1] = vim.fs.basename(f)
        break
      end
    end
    file:close()
  end

  return root_files
end

function M.insert_package_json(root_files, field, fname)
  return M.root_markers_with_field(root_files, { 'package.json', 'package.json5' }, field, fname)
end

--- Returns the major version number of the `typescript` dependency declared
--- in `root_dir`'s package.json (checking `dependencies` and
--- `devDependencies`), or nil if it can't be determined.
---@param root_dir string?
---@return integer?
function M.typescript_major_version(root_dir)
  local path = root_dir and root_dir .. '/package.json'
  if not path or vim.fn.filereadable(path) ~= 1 then
    return nil
  end
  local ok, decoded = pcall(vim.json.decode, table.concat(vim.fn.readfile(path), '\n'))
  if not ok or type(decoded) ~= 'table' then
    return nil
  end
  local version = (decoded.dependencies or {}).typescript or (decoded.devDependencies or {}).typescript
  local major = version and version:match '(%d+)'
  return major and tonumber(major) or nil
end

--- Resolves the local executable that should back the tsgo-style LSP for
--- `root_dir`: `node_modules/.bin/tsgo` if present, else
--- `node_modules/.bin/tsc` when the project's `typescript` dependency is
--- major version 7+ (tsc absorbed tsgo's native Go LSP mode in v7).
--- Returns nil if neither applies.
---@param root_dir string?
---@return string?
function M.resolve_tsgo_cmd(root_dir)
  if not root_dir then
    return nil
  end
  local tsgo = root_dir .. '/node_modules/.bin/tsgo'
  if vim.fn.executable(tsgo) == 1 then
    return tsgo
  end
  local major = M.typescript_major_version(root_dir)
  if major and major >= 7 then
    local tsc = root_dir .. '/node_modules/.bin/tsc'
    if vim.fn.executable(tsc) == 1 then
      return tsc
    end
  end
  return nil
end

return M
