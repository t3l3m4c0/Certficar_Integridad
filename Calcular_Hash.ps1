#Scripted by LGM

Clear-Host

# Obtener la fecha en formato Año-Mes-Día_HoraMinuto
$fecha = Get-Date -Format "yyyy-MM-dd HH:mm"

Write-Host " "
Write-Host "####### CALCULAR HASH by LGM #######"
Write-Host " "
Write-Host "$fecha"
Write-Host " "

# Obtener las unidades disponibles
$unidades = Get-PSDrive -PSProvider FileSystem | Select-Object Name, Root

# Mostrar las unidades disponibles

Write-Host "Unidades disponibles:"
Write-Host " "
$unidades | ForEach-Object { Write-Host "$($_.Name) - $($_.Root)" }
Write-Host " "
# Pedir al usuario que seleccione una unidad
$unidadSeleccionada = Read-Host "Ingrese la letra de la unidad:"

# Validar si la unidad existe
if ($unidades.Name -contains $unidadSeleccionada.ToUpper()) {
    $unidadRuta = ($unidades | Where-Object { $_.Name -eq $unidadSeleccionada.ToUpper() }).Root
    Write-Host "Has seleccionado la unidad: $unidadRuta"
} else {
    Write-Host "Unidad no válida. Saliendo del script."
    exit
}

# Obtener la fecha en formato Año-Mes-Día_HoraMinuto
$fecha = Get-Date -Format "yyyy-MM-dd_HHmm"

# Definir las rutas con la fecha en el nombre
$hash_individual = "C:\hash_result_individual_$fecha.txt"
$hash_general = "C:\hash_result_general_$fecha.txt"

# Generar los hashes individuales y guardarlos en el archivo con la fecha
Get-ChildItem $unidadRuta -Recurse -File | ForEach-Object { "$(Get-FileHash $_.FullName -Algorithm SHA256)" } | Out-File $hash_individual

# Calcular el hash del archivo generado y guardarlo en otro archivo con la fecha
Get-FileHash $hash_individual -Algorithm SHA256 | Out-File $hash_general

Write-Host "Proceso completado. Resultados guardados en:"
Write-Host $hash_individual
Write-Host $hash_general

# Definir la ruta y nombre del archivo ZIP con la fecha
$zipFile = "C:\hash_results_$fecha.zip"

# Comprimir los archivos en un ZIP
Compress-Archive -Path $hash_individual, $hash_general -DestinationPath $zipFile -Force

Write-Host "Archivos comprimidos en: $zipFile"
