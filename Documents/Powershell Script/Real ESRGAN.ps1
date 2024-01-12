[CmdletBinding()]
param (
    [Parameter(ValueFromRemainingArguments=$true)]
    $Path
)
$realesrgan_path = "C:/Users/isudfv/Desktop/Real-ESRGAN/inference_realesrgan.py"

foreach ($file in $Path) {
    Write-Host $file
    $parent = Split-Path -Path $file
    break
}
python $realesrgan_path -n RealESRGAN_x4plus_anime_6B -i $Path -o $parent --tile 256 --suffix "real" --ext "png"
