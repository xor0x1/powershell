# Импорт модуля Active Directory
Import-Module ActiveDirectory

# Определите DN (Distinguished Name) вашего подразделения
$ou = "OU=USERS,DC=domain,DC=local" 

# Получение списка всех пользователей в данном подразделении
Get-ADUser -Filter * -SearchBase $ou -Property * | ForEach-Object {
    # Получение имени пользователя и времени последней авторизации
    $username = $_.SamAccountName
    $lastLogonDate = $_.LastLogonDate

    # Вывод информации
    Write-Output "Username: $username, Last Logon: $lastLogonDate"
}
