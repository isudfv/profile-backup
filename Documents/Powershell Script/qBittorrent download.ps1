param(
    [Parameter()]
    [string]$1,

    [Parameter()]
    [Int64]$2,

    [Parameter()]
    [string]$3
)

$size = "$([Math]::Floor($2 / 1024 / 1024)) MiB"

$data = @{
    subject        = "[qBittorrent] torrent download finished"
    content        = "Torrent 名称：$1<br/>Torrent 大小：$size<br/>保存路径：$3"
    ref_id         = "SJ0PR07MB7648B6FFC2BB745348103EEDC7FBA@SJ0PR07MB7648.namprd07.prod.outlook.com"
    from_name      = "qBittorrent"
    from_email     = "isudfv@qq.com"
    to_name        = "isudfv"
    to_email       = "isudfv@outlook.com"
    smtp_host_name = "smtp.qq.com"
}
Write-Host ($data | ConvertTo-Json)

# $CurlArguments = '-X', 'Post',
# 'pc:8888/email',
# '-d', 'fuck',
# '--noproxy', 'pc'
$CurlArguments = '-X', 'POST', 'pc:8888/email',
'-H', 'Smtp-Password: ',
'-d', ($data | ConvertTo-Json), 
'--noproxy', 'pc',
'-v'

& curl @CurlArguments


