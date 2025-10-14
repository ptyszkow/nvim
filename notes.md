# Notes

## Clean state, cache nvim

```bash
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim
```

## Install Markdown Preview

```lua
:Lazy load markdown-preview.nvim
:call mkdp#util#install()
```

## Dbee Configure Db

```json
[
    {
        "id": "file_source_local_mssql",
        "url": "sqlserver://sa:{{ env `MSSQL_PWD` }}@1.1.1.127:1433?database=develop&encrypt=false&trustServerCertificate=true",
        "name": "develop",
        "type": "sqlserver"
    },
    {
        "id": "file_source_/rIv32rm7Iq",
        "url": "dev_ai_reader:{{ env `MYSQL_PWD` }}@tcp(1.1.1.1:3306)/useresponse_views?parseTime=true&charset=utf8mb4",
        "name": "ai_kdb",
        "type": "mysql"
    }
]
```

## Maybe

- sql autocompletion
- formatter sql, json, markdown, html
- rest 

