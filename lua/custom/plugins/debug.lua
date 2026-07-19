-- Extra debugger adapters for Kickstart's bundled nvim-dap setup.

local dap = require 'dap'
local mason_bin = vim.fn.stdpath 'data' .. '/mason/bin/'

-- codelldb handles Rust and C/C++.
dap.adapters.codelldb = {
  type = 'server',
  port = '${port}',
  executable = {
    command = mason_bin .. 'codelldb',
    args = { '--port', '${port}' },
  },
}

local function native_program()
  return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
end

local native_configuration = {
  {
    name = 'Launch executable',
    type = 'codelldb',
    request = 'launch',
    program = native_program,
    cwd = '${workspaceFolder}',
  },
  {
    name = 'Attach to process',
    type = 'codelldb',
    request = 'attach',
    pid = require('dap.utils').pick_process,
    cwd = '${workspaceFolder}',
  },
}

dap.configurations.c = native_configuration
dap.configurations.cpp = native_configuration
dap.configurations.rust = native_configuration

-- .NET debugging with netcoredbg.
dap.adapters.coreclr = {
  type = 'executable',
  command = mason_bin .. 'netcoredbg',
  args = { '--interpreter=vscode' },
}

local function cs_projects()
  local buffer_path = vim.api.nvim_buf_get_name(0)
  local start_path = buffer_path ~= '' and vim.fs.dirname(buffer_path) or vim.fn.getcwd()
  local is_csproj = function(name) return name:sub(-7) == '.csproj' end

  -- A project containing the current file is almost always the right one.
  local nearest = vim.fs.find(is_csproj, { path = start_path, upward = true, type = 'file', limit = 1 })[1]
  if nearest then return { nearest } end

  -- When invoked from a solution-level buffer, offer projects below the cwd.
  local projects = vim.fs.find(is_csproj, { path = vim.fn.getcwd(), type = 'file', limit = 100 })
  table.sort(projects)
  return projects
end

local function choose_cs_project(callback)
  local projects = cs_projects()
  if #projects == 0 then
    vim.notify('No .csproj found from ' .. vim.fn.getcwd(), vim.log.levels.ERROR, { title = 'Debug .NET' })
    callback(nil)
    return
  end

  if #projects == 1 then
    callback(projects[1])
    return
  end

  vim.ui.select(projects, {
    prompt = 'Select .NET project: ',
    format_item = function(project) return vim.fn.fnamemodify(project, ':~:.') end,
  }, callback)
end

local function dotnet_program()
  return coroutine.create(function(dap_run_co)
    local dotnet = vim.fn.exepath 'dotnet'
    if dotnet == '' then
      vim.notify('dotnet was not found in PATH', vim.log.levels.ERROR, { title = 'Debug .NET' })
      coroutine.resume(dap_run_co, dap.ABORT)
      return
    end

    choose_cs_project(function(project)
      if not project then
        coroutine.resume(dap_run_co, dap.ABORT)
        return
      end

      vim.notify('Building ' .. vim.fn.fnamemodify(project, ':t'), vim.log.levels.INFO, { title = 'Debug .NET' })
      vim.system({ dotnet, 'build', project, '--nologo', '--configuration', 'Debug' }, { text = true }, function(build)
        vim.schedule(function()
          if build.code ~= 0 then
            local output = vim.trim((build.stderr and build.stderr ~= '' and build.stderr or build.stdout) or '')
            vim.notify(output ~= '' and output or 'dotnet build failed', vim.log.levels.ERROR, { title = 'Debug .NET' })
            coroutine.resume(dap_run_co, dap.ABORT)
            return
          end

          -- MSBuild 17.8+ can report the evaluated output path, including a
          -- custom AssemblyName or TargetFramework, so no bin path is guessed.
          vim.system({
            dotnet,
            'msbuild',
            project,
            '-nologo',
            '-getProperty:TargetPath',
            '-property:Configuration=Debug',
          }, { text = true }, function(query)
            vim.schedule(function()
              local target = vim.trim(query.stdout or ''):match '([^\r\n]+)$'
              if query.code ~= 0 or not target or target == '' then
                local output = vim.trim(query.stderr or '')
                vim.notify(
                  'Could not resolve the project output path' .. (output ~= '' and ':\n' .. output or ''),
                  vim.log.levels.ERROR,
                  { title = 'Debug .NET' }
                )
                coroutine.resume(dap_run_co, dap.ABORT)
                return
              end

              if not vim.startswith(target, '/') then target = vim.fs.joinpath(vim.fs.dirname(project), target) end
              target = vim.fs.normalize(target)
              if vim.fn.filereadable(target) == 0 then
                vim.notify('Built assembly not found: ' .. target, vim.log.levels.ERROR, { title = 'Debug .NET' })
                coroutine.resume(dap_run_co, dap.ABORT)
                return
              end

              coroutine.resume(dap_run_co, target)
            end)
          end)
        end)
      end)
    end)
  end)
end

dap.configurations.cs = {
  {
    name = 'Launch .NET project (build)',
    type = 'coreclr',
    request = 'launch',
    program = dotnet_program,
    cwd = '${workspaceFolder}',
    console = 'integratedTerminal',
    justMyCode = true,
    stopAtEntry = false,
  },
  {
    name = 'Launch .NET DLL (manual)',
    type = 'coreclr',
    request = 'launch',
    program = function()
      local path = vim.fn.input('Path to .NET DLL: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
      return path ~= '' and path or dap.ABORT
    end,
    cwd = '${workspaceFolder}',
    console = 'integratedTerminal',
    justMyCode = true,
  },
  {
    name = 'Attach to .NET process',
    type = 'coreclr',
    request = 'attach',
    processId = '${command:pickProcess}',
    cwd = '${workspaceFolder}',
    justMyCode = true,
  },
}

-- local-lua-debugger-vscode is a VS Code extension whose adapter runs via Node.
local lua_debugger_path = vim.fn.stdpath 'data' .. '/mason/packages/local-lua-debugger-vscode/extension'
dap.adapters['local-lua'] = {
  type = 'executable',
  command = 'node',
  args = { lua_debugger_path .. '/extension/debugAdapter.js' },
  enrich_config = function(config, on_config)
    local updated = vim.deepcopy(config)
    updated.extensionPath = lua_debugger_path
    on_config(updated)
  end,
}

dap.configurations.lua = {
  {
    name = 'Launch Lua file',
    type = 'local-lua',
    request = 'launch',
    cwd = '${workspaceFolder}',
    program = function()
      return {
        lua = vim.fn.exepath 'lua' ~= '' and vim.fn.exepath 'lua' or 'lua',
        file = vim.fn.input('Path to Lua file: ', vim.fn.expand('%:p'), 'file'),
      }
    end,
  },
}

-- Python debugging with debugpy from the current uv project.
-- Install it in a project with: uv add --dev debugpy
dap.adapters.python = {
  type = 'executable',
  command = vim.fn.exepath 'uv',
  args = { 'run', 'python', '-m', 'debugpy.adapter' },
}

local function uv_python()
  local uv = vim.fn.exepath 'uv'
  if uv ~= '' then
    local result = vim.system({ uv, 'run', 'python', '-c', 'import sys; print(sys.executable)' }, { text = true }):wait()
    if result.code == 0 then
      local interpreter = vim.trim(result.stdout or '')
      if interpreter ~= '' then return interpreter end
    end
  end

  local virtual_env = vim.env.VIRTUAL_ENV
  if virtual_env and virtual_env ~= '' then return virtual_env .. '/bin/python' end
  return vim.fn.exepath 'python3' ~= '' and vim.fn.exepath 'python3' or vim.fn.exepath 'python'
end

dap.configurations.python = {
  {
    name = 'Launch current file (uv)',
    type = 'python',
    request = 'launch',
    program = '${file}',
    cwd = '${workspaceFolder}',
    pythonPath = uv_python,
    justMyCode = true,
    console = 'integratedTerminal',
  },
  {
    name = 'Attach to debugpy',
    type = 'python',
    request = 'attach',
    connect = function()
      return {
        host = vim.fn.input('Host: ', '127.0.0.1'),
        port = tonumber(vim.fn.input('Port: ', '5678')),
      }
    end,
    justMyCode = true,
  },
}
