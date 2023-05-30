# Импорт модуля Active Directory
Import-Module ActiveDirectory

# Определите DN (Distinguished Name) вашего контейнера
$cn = "CN=Users,DC=domain,DC=local"

# Получение списка всех контактов в данном контейнере
Get-ADObject -Filter 'objectClass -eq "contact"' -SearchBase $cn | ForEach-Object {
    # Получение имени контакта и остальных свойств
    $name = $_.Name
    $description = $_.Description
    $mail = $_.mail

    # Вывод информации
    Write-Output "Name: $name, Description: $description, Email: $mail"
}
