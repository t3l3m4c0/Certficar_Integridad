# Scripted by LGM

Clear-Host

# Obtener la fecha en formato Año-Mes-Día_HoraMinuto
$fecha = Get-Date -Format "yyyy-MM-dd_HHmm"

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

# Pedir al usuario que seleccione una unidad
$unidadSeleccionada = Read-Host "Dime la unidad de almacenamiento:"

# Validar si la unidad existe
if ($unidades.Name -contains $unidadSeleccionada.ToUpper()) {
    $unidadRuta = ($unidades | Where-Object { $_.Name -eq $unidadSeleccionada.ToUpper() }).Root
    Write-Host "Has seleccionado la unidad: $unidadRuta"
} else {
    Write-Host "Unidad no válida. Saliendo del script."
    exit
}

# Definir las rutas de salida
$hash_individual = "C:\hash_result_individual_$fecha.txt"
$hash_general = "C:\hash_result_general_$fecha.txt"

# Obtener la lista de archivos en la unidad seleccionada
$archivos = Get-ChildItem $unidadRuta -Recurse -File
$total = $archivos.Count
$contador = 0

# Mensaje de inicio
Write-Host "Procesando $total archivos en la unidad $unidadRuta ..."

# Generar los hashes individuales y guardarlos en el archivo con la fecha, con progreso
$archivos | ForEach-Object {
    Try {
        # Obtener el hash y escribir en el archivo manteniendo el formato
        "$(Get-FileHash $_.FullName -Algorithm SHA256)" | Out-File $hash_individual -Append
    } Catch {
        Write-Host "Error al procesar el archivo: $($_.FullName)"
    }

    # Actualizar progreso
    $contador++
    Write-Progress -Activity "Calculando Hashes" -Status "$contador de $total archivos procesados" -PercentComplete (($contador / $total) * 100)
}

# Calcular el hash del archivo generado y guardarlo en otro archivo con la fecha
Write-Host "Calculando el hash del archivo de resultados..."
Get-FileHash $hash_individual -Algorithm SHA256 | Out-File $hash_general

# Mensaje de finalización
Write-Host "Proceso completado. Resultados guardados en:"
Write-Host "$hash_individual"
Write-Host "$hash_general"

# Definir la ruta y nombre del archivo ZIP con la fecha
$zipFile = "C:\hash_results_$fecha.zip"

# Comprimir los archivos en un ZIP
Compress-Archive -Path $hash_individual, $hash_general -DestinationPath $zipFile -Force

Write-Host "Archivos comprimidos en: $zipFile"
