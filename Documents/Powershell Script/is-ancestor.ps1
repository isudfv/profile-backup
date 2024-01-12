param(
    [Parameter()]
    [string]$1,

    [Parameter()]
    [string]$2
)

git merge-base --is-ancestor $1 $2
if ($LASTEXITCODE.Equals(0)) {
    echo "$1 is ancestor of $2"
}
else {
    git merge-base --is-ancestor $2 $1
    if ($LASTEXITCODE.Equals(0)) {
        echo "$2 is ancestor of $1"
    }
    else{
        echo "$1 and $2 are not related"
    }
}