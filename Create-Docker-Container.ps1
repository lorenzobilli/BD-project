param([Parameter(Mandatory=$true)]$ContainerName)

$ScriptsFolder = Join-Path -Path ${pwd} -ChildPath "Script SQL"
$PostgresVersion = 9.6

function CreateContainer
{
	docker create -i `
		-v ${ScriptsFolder}:/mnt/ `
		-e POSTGRES_PASSWORD=password `
		--hostname=${ContainerName} `
		--name=${ContainerName} `
		--publish 5432:5432 `
		-t postgres:${PostgresVersion}
}

"Creating container ${ContainerName}..."
CreateContainer
"Done."
