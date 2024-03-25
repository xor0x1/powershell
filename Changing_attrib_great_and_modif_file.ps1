#========================================================================
# Name		: Changing_attrib_great_and_modif_file.ps1
# Author 	: Lunik
# Git	: https://github.com/xor0x1/powershell
#========================================================================

#========================================================================
# Данный скрипт модифицирует Атрибут файла:
# Создание и Изменение Файла в Рандомном порядке за период
# Выбираете дату и кол-во дней за какой период изменить дату в меньшую и большую сторону или установите 0 если только за текущую дату
# Время файла меняется по умолчанию с 08.00 до 21.00 Можно изменить в скрипте
#========================================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Функция для изменения дат файлов и папок
function ChangeDates($folderPath, $specifiedDate, $days) {
    # Изменение дат создания и последнего изменения файлов и папок
    Get-ChildItem -Path $folderPath -Recurse | ForEach-Object {
        # Случайное добавление или вычитание дней
        $randomDays = Get-Random -Minimum (-$days) -Maximum $days
        $newDate = $specifiedDate.AddDays($randomDays)

        # Генерация случайного времени в диапазоне от 8 утра до 9 вечера
        $randomHour = Get-Random -Minimum 8 -Maximum 19
        $randomTimeSpan = New-TimeSpan -Hours $randomHour -Minutes (Get-Random -Minimum 0 -Maximum 59) -Seconds (Get-Random -Minimum 0 -Maximum 59)
        $newDate = $newDate.Date + $randomTimeSpan

        # Изменяем дату создания
        $_.CreationTime = $newDate

        # Изменяем дату последнего изменения
        $_.LastWriteTime = $newDate
    }
}

# Создание формы
$form = New-Object System.Windows.Forms.Form
$form.Text = "Изменить даты файлов и папок"
$form.Size = New-Object System.Drawing.Size(400, 300)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = 'FixedSingle'

# Поле выбора папки
$folderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
$folderBrowserDialog.Description = "Выберите папку с файлами и папками"
$folderBrowserDialog.ShowNewFolderButton = $false

# Поле выбора даты
$dateLabel = New-Object System.Windows.Forms.Label
$dateLabel.Text = "Дата:"
$dateLabel.Location = New-Object System.Drawing.Point(20, 20)
$dateLabel.AutoSize = $true

$datePicker = New-Object System.Windows.Forms.DateTimePicker
$datePicker.Format = [System.Windows.Forms.DateTimePickerFormat]::Custom
$datePicker.CustomFormat = "yyyy-MM-dd HH:mm:ss"
$datePicker.Location = New-Object System.Drawing.Point(20, 50)
$datePicker.Width = 200

# Поле ввода количества дней для случайного изменения
$daysLabel = New-Object System.Windows.Forms.Label
$daysLabel.Text = "Количество дней для случайного изменения:"
$daysLabel.Location = New-Object System.Drawing.Point(20, 90)
$daysLabel.AutoSize = $true

$daysTextBox = New-Object System.Windows.Forms.TextBox
$daysTextBox.Location = New-Object System.Drawing.Point(20, 120)
$daysTextBox.Size = New-Object System.Drawing.Size(200, 20)

# Кнопка "Изменить даты"
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(20, 160)
$button.Size = New-Object System.Drawing.Size(150, 23)
$button.Text = "Изменить даты"
$button.Add_Click({
        # Получение выбранной папки
        if ($folderBrowserDialog.ShowDialog() -eq 'OK') {
            $folderPath = $folderBrowserDialog.SelectedPath

            # Получение выбранной даты
            $specifiedDate = $datePicker.Value

            # Получение введенного количества дней
            $days = [int]$daysTextBox.Text

            # Вызов функции для изменения дат файлов и папок
            ChangeDates $folderPath $specifiedDate $days

            [System.Windows.Forms.MessageBox]::Show("Даты файлов и папок были успешно изменены.", "Готово", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }
    })

# Добавление элементов на форму
$form.Controls.Add($dateLabel)
$form.Controls.Add($datePicker)
$form.Controls.Add($daysLabel)
$form.Controls.Add($daysTextBox)
$form.Controls.Add($button)

# Отображение формы
$form.ShowDialog() | Out-Null